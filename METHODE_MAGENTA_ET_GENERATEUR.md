# La méthode « rendu généré + fond magenta »

Comment le projet passe d'une **image produite par un générateur d'images** à un **Ground PMDO
importable**, et pourquoi le magenta est au centre. Toutes les formules citées viennent du code du
dépôt (`source/…`), pas d'une reconstitution.

---

## 1. Pourquoi du magenta ?

Un générateur d'images ne produit pas de canal alpha fiable : il « dessine » un rectangle opaque.
Le projet lui donne donc une **couleur de balisage** : le **magenta**, qui veut dire **« à détourer »**
(devient transparent), et sert aussi de **masque de matière** (une zone magenta peut devenir de l'eau,
un vide, un trou de fenêtre).

Le magenta a trois usages distincts, tous volontairement **exacts** (jamais approximatif) :

| Usage | Ce que le magenta signifie | Où |
|---|---|---|
| **Élément animé / transparence** | « ici il y aura l'eau / le vide » → détouré puis rempli par du vrai contenu | `bruts/decor_magenta.png` (décor) |
| **Découpe de planche** | fond magenta autour d'un sprite à isoler (rochers, cascades, écaumes…) | `bruts/*_magenta.png` |
| **Bases de salle** | zones qui deviendront **transparentes** (trous de fenêtres) | `kit.json`, `base_jour_magenta.png` |

---

## 2. Le contrat passé au générateur d'images

Règles constantes dans tous les lots :

1. **Le décor complet sur magenta** — et la règle précise est écrite dans le prompt :
   *« décor complet sur magenta (torrent = magenta) »* : l'élément qui doit devenir animé est peint
   **en magenta**, pas en couleur.
2. **Le sol est généré séparément** (`sol_complet.png`) — c'est lui qui passera **sous** la roche et
   l'eau, ce qui garantit un calque de sol continu sans trous.
3. **La référence canonique est passée au générateur** (paramètre `images=`) : le rip PMD
   (`starcavepmdsky.png`, `witheringdesert.png`, `Mt_Bristle_*`, `Dark_Crater_*`, carte du monde…).
   On demandait « pure magenta exterior; no characters or UI » pour les planches pures.
4. **Le générateur ne produit jamais une tuile livrée telle quelle.** Sa sortie est une
   **composition** ; elle est retravaillée en tuiles de 8 px (voir §5 et §7).

Exemples de sources brutes d'un lot (`source/entree_bristle_sud_nord_v1/bruts/`) :
`decor_magenta.png` (848 × 1264) · `sol_complet.png` · `touffes_vent_poses.png` (planche de poses).

---

## 3. Détourage : `key()`

Fonction partagée : `source/layouts_magenta_v1/palette.py`

```python
def key(im):
    r, g, b = ...                          # canaux
    bg = (r > 70) & (b > 70) & (r > g*1.45) & (b > g*1.45)     # le magenta
    fringe = binary_dilation(bg, iterations=1) & (r > g*1.05) & (b > g*1.05)   # liseré antialiasé
    a[bg | fringe] = 0                     # -> alpha 0
```

Points clés :
- la détection n'est **pas** une égalité à `(255,0,255)` mais un **rapport de canaux** (`r > 1.45 g`,
  `b > 1.45 g`) : cela tolère les variations du générateur tout en restant discriminant ;
- la **frange antialiasée** est détourée en plus (`fringe`), sinon il reste un liseré rose autour des
  contours ;
- dans les gros décors, la même idée est appliquée avec une **dilatation de 2 px** :
  `water = binary_dilation(mag, iterations=2)` — « liseré rose antialiasé inclus » (Bristle `classify`).

---

## 4. Déclinaison d'un même décor par biome : `tint()`

Même fichier : `tint(im, biome, palette)` convertit chaque couleur en HSV et applique une
transformation **par biome** (`cote`, `cristal`, `foret`, autre) et par variante (`palette` 0/1) :

```python
blue  = b > r*1.12 and b > g*0.87
green = g > r*1.06 and g > b*1.12
# biome 'cote'   : teinte 0.60/0.49 si bleu, 0.95/0.09 sinon ; saturation ×0.8 ; valeur ×1 / ×1.03
# biome 'cristal': teinte 0.52/0.65 ; saturation ×0.85 / ×0.62
# biome 'foret'  : vert -> teinte 0.365 ; sinon décalage fin de teinte
```

C'est ainsi qu'**un même rendu** donne les variantes jour/nuit, abysse, côte cendrée, etc., sans
redessiner — et `a[a[:,:,3]==0] = 0` garantit que la transparence reste intacte après tint.

---

## 5. Segmentation en matières : `classify()`

Sur le décor **pleine résolution**, chaque pixel est classé en **matière** par des seuils mesurés sur
le brut (pas devinés). Exemple du socle partagé (`source/entree_bristle_sud_nord_v1/build.py`) :

| Matière | Règle |
|---|---|
| `water` | magenta dilaté 2 px (voir §3) |
| `tuft` | dominante verte (`g > r+10 & g > b+10`), fermeture morphologique, **composantes ≥ 30 px** |
| `rock` | **grise** : `sat < 40`, fraction lissée sur 7 px **> 0.5**, ouverture, **composantes ≥ 2500 px** |
| `gorge` | zone encadrée + `lum < 85`, fermeture, **≥ 500 px**, remplissage des trous |
| `bank` (berge) | proche de l'eau (26 px) + **texture** `V > 14` (écart-type local de luminance), **≥ 400 px** |
| `boulder` | `sat > 95 & lum < 180` dans le sable, **≥ 80 px** |
| `sand` | le reste, **uniquement les composantes touchant le bas de l'image** |
| `rock |=` | les replats enclavés dans le sable redeviennent des falaises |

Deux garde-fous systématiques :
- **`keep_large(m, k)`** — `ndimage.label` + suppression des taches plus petites que `k` pixels :
  aucun artefact isolé ne survit ;
- **`binary_opening` / `binary_closing` / `binary_fill_holes`** pour lisser les bords.

Le résultat de `classify` est un **dictionnaire de masques booléens** — c'est le plan de découpe des
calques.

---

## 6. Réduction propre : « moyenne 2×2 par classe, sans mélange »

Le rendu généré est trop grand ; la réduction est **exacte et non mélangeante** :

```python
def down_mask(m):   return m.reshape(H,2,W,2).sum((1,3)) >= 2          # un pixel cible est "dans" la matière si ≥ 2/4
def down_colors(a,m):                                                   # couleur cible = moyenne des pixels SOURCES DE SA CLASSE
    w = m.reshape(H,2,W,2)[..., None]
    return round((a.reshape(H,2,W,2,3) * w).sum((1,3)) / max(w.sum((1,3)), 1))
def exclusive(masks, order):                                            # un pixel = UNE seule matière
    counts = [masks[k].reshape(H,2,W,2).sum((1,3)) for k in order]
    win = argmax(counts);  return {k: (win==i) & (counts.max(0) >= 2) for i,k in ...}
```

Principes :
- **aucun mélange entre matières** : un pixel de bord d'eau ne prend pas la couleur du sable voisin ;
- **arbitrage par vote** : en cas de conflit sur un bloc 2×2, la matière majoritaire gagne (`exclusive`) ;
- facteur de réduction **uniforme en X et Y** (ex. ×0,5 : 848 × 1264 → 424 × 632) — jamais d'étirement.

Ensuite, **palette commune** à tous les calques (`quantize_layers`) : les pixels opaques de tous les
calques sont mis en commun puis quantifiés en **96 couleurs** (MEDIANCUT, **dither désactivé**).
C'est ce qui garantit la cohérence artistique entre les calques (pas de dérive de teintes).

---

## 7. Trois niveaux de « natif » — et l'obligation de le dire

Le projet distingue explicitement trois origines, et le `README_PACK.md` de chaque lot doit l'écrire :

| Niveau | Définition | Exemple |
|---|---|---|
| **Natif** | pixels **exacts** d'une tuile PMD (souvent réencodés depuis `.tile`) | scintillements `Metano_Town_River_Sparkles` |
| **Façon X** | structure + **couleurs mesurées** sur X, mais **pixels recalculés** | torrent « façon rivière Métano » (`PAL` mesurée) |
| **Généré** | dessin inventé dans la DA PMD, à partir de la référence passée au générateur | terrain des nouvelles entrées, touffes au vent, papillons |

> Un rendu généré **n'est jamais présenté comme une tuile canonique**. Et une réduction/agrandissement
> d'illustration **n'est pas** une tuile native.

---

## 8. Contrôle de fidélité : `fidelity()`

Objectif : prouver que les couleurs du lot **collent au rip**. Méthode : le **même classifieur**
appliqué aux deux images, puis distance euclidienne des couleurs moyennes.

```python
def fidelity(decor, ref):
    fr, fd = materials(ref), materials(decor)          # même fonction des deux côtés
    for k in fr:
        mr, md = ref[fr[k]].mean(0), decor[fd[k]].mean(0)
        out[k] = {'rip_rgb': mr, 'decor_rgb': md, 'distance': norm(mr - md)}
```

Seuils en dur dans les lots, avec **assertion bloquante** :

```python
FIDELITY_MAX = 35          # matières (sol, cristal, roche...)
MAGMA_FIDELITY_MAX = 12    # lave : plus exigeant car les teintes chaudes dérivent vite
assert fid['distance'] < FIDELITY_MAX, fid
assert mfid['distance'] < MAGMA_FIDELITY_MAX, mfid
```

Les valeurs mesurées finissent dans le journal du lot, ex. *« Fidélité (seuil 35) : sol 6,8 · cristal
30,8 (parois 32,1 : cristaux plus cyan que le rip, limite) »* — les **limites** sont publiées aussi.

---

## 9. Du calque au Ground : `ground_project()`

Une fois les calques prêts, `ground_project(stack, blocked, entry_px, threshold_px, gfx, tools)`
fabrique le projet PMDO :

1. un **banc de tuiles par calque** (`PFX_00_NOM.tile`), alimenté case par case de **8 px** ;
2. **déduplication** : une case identique à la case (0,0) n'est pas écrite ; une case identique
   d'une frame à l'autre n'a **qu'une seule** référence (`TexLoc {0,0}`) ; sinon la liste des frames ;
3. un calque final **vide `Layer=4` (Top)** pour les éléments d'avant-plan ;
4. le `.rsground` est bâti **depuis un gabarit réel** de PMDO 0.8.12 (ouvert depuis le pack
   Expéditions), puis renseigné : `TexSize=1`, `Layers`, `obstacles` **par case de 8 px** avec ses tags,
   `Entities` avec les **markers** (`entrance` 16 × 16, `donjon_seuil`, `boss`, `objectif`),
   `Decorations` ;
5. `Content/Tile/index.idx` est **reconstruit** avec l'encodeur du projet ;
6. `Mod.xml` (namespace + UUID déterministe), `Data/Script/<ns>/ground/<asset>/init.lua` (« base
   d'édition, aucun warp ») et **`INSTALLER.py`** sont écrits dans le projet ;
7. `INSTALLER.py` fusionne ensuite l'index de tuiles **dans un mod existant** : il sauvegarde l'ancien
   index et **n'écrase jamais** une carte ou un graphique aux octets différents.

Chaque frame animée est vérifiée **visuellement** en plus : `review/<PFX>_collisions_marqueurs.png`
et `<PFX>_scene_animee.webp`, plus un aperçu HTML autonome (images en base64, hors ligne).

---

## 10. Le pipeline complet en une vue

```
   rip PMD de référence ─────────────┐
                                     ▼
   ① GÉNÉRATEUR D'IMAGES : decor_magenta.png (magenta = eau/vide) + sol_complet.png + planches
                                     │
   ② DÉTOURAGE key() : magenta → alpha 0 (+ frange antialias)      [§3]
                                     │
   ③ SEGMENTATION classify() : masques water / rock / bank / sand / tufts / gorge… [§5]
                                     │
   ④ RÉDUCTION 2×2 par classe + exclusive() + palette commune 96 couleurs [§6]
                                     │
   ⑤ CALQUES RGBA transparents, un par fonction, + animations (eau 4×10 ticks, etc.)
                                     │
   ⑥ TESTS : test_build.py (formats, cadence, grille) · fidelity() vs rip (seuil 35) [§8]
                                     │
   ⑦ ground_project() : .tile + .rsground + index.idx + Mod.xml + init.lua + INSTALLER [§9]
                                     │
   ⑧ PROJET PMDO 0.8.12 → PMDO/MODS/ → éditeur Ground (import PNG to Tileset : 8 px)
```

## 11. Ce que la méthode **ne** fait **pas**

- elle ne prétend pas que le rendu généré est une tuile native ;
- elle ne recolore, ne tourne, n'agrandit ni ne repeint une tuile native dans un lot déclaré natif ;
- elle ne remplace pas un test moteur : **un aperçu approuvé n'est pas une validation en jeu**
  (l'audit `audits/metano_import/RAPPORT.md` a montré qu'un assemblage par fragments de 8 px ne
  préserve pas les volumes natifs → privilégier des **modules natifs complets** : sommet, face, pied, retours) ;
- la qualité d'un lot se juge **au zoom natif** puis dans le jeu, pas sur l'illustration.

---

### Où lire le code

| Sujet | Fichier |
|---|---|
| Détourage et déclinaison de palette | `source/layouts_magenta_v1/palette.py` |
| Socle partagé : `classify`, réduction, calques, eau, `ground_project` | `source/entree_bristle_sud_nord_v1/build.py` |
| Application (magenta = rivière, papillons, 4:3 vaste) | `source/entree_jungle_sud_nord_v1/build.py` |
| Fidélité « même classifieur des deux côtés » | `source/fin_star_cave_v1/build.py` (`fidelity`, `materials`) |
| Seuils bloquants matière / lave | `source/arene_groudon_magma_v1/build.py` (`FIDELITY_MAX`, `MAGMA_FIDELITY_MAX`) |
| Codec `.rsground`/`.tile` et installation dans un mod | `source/pmdo_cote/build.py`, `source/pmdo_cote/INSTALLER.py` |
| Test avec le vrai chargeur PMDO | `source/pmdo_runtime/README.md`, `verify_ground_runtime.py` |
