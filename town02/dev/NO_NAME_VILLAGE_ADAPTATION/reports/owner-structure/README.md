# Structure fournie par le propriétaire — mesure et aperçu

**Étape : `PREVIEW_ONLY`.** Rien n'est écrit sous `Data/`. Aucun `.rsground`,
aucune planche `.tile`, aucune `Decoration` ajoutée. Le choix final t'appartient.

Source : `ASSSET.png`, poussé sur la branche (`1e859d4d`),
sha256 `be2d42…` (voir `owner-structure.json`).

---

## 1. Ce que l'asset est réellement

Il **ressemble** à du pixel-art. Il n'en est pas. Mesuré, pas supposé :

| Mesure | Valeur | Ce que ça implique |
|---|---:|---|
| Couleurs distinctes | **224 057** | du pixel-art en a quelques dizaines |
| Pixels à alpha 255 | **0** | *aucun* pixel pleinement opaque, alpha max 254 |
| Halo alpha 1–8 | **27 889 px** | résidu de compression (noir/vert/rouge purs), retiré |
| Épaisseur de contour | **5 à 12 px** | un contour natif est d'épaisseur constante |
| Variance intra-bloc | croissante dès f=2 | **aucune grille de pixels détectable** |

Conséquence directe, et elle est importante : **il n'existe pas de « taille
native » à retrouver par division entière.** Toute réduction est un *rendu*,
pas une *restitution*. Je le dis au lieu de choisir un facteur en silence.

Le halo transparent a été retiré avant toute mesure : le garder décalait la
bbox de 6 px et aurait sali les bords en jeu.

**Taille du sujet nettoyé : 1369 × 971 px** — soit **85,6 × 60,7 Pokémon**.
À ×1, c'est **12 fois trop large** pour une maison PMDO. Intégration à ×1 refusée.

## 2. Référentiel appliqué

Celui déjà établi et versionné dans `reports/pmdo-scale-reference/` :

```
unité monde PMDO       = 8 px
Pokémon                = 16 px = 2×2 unités monde
maison PMDO médiane    = 114 px de large = 7,1 Pokémon
structures PMU confirmées = 40 à 212 px, médiane 98 px
```

## 3. Les quatre candidats

| Largeur | Taille | En Pokémon | vs maison PMDO médiane | Dans la plage PMU |
|---:|---:|---:|---:|:---:|
| **114 px** | 114×81 | 7,1 × 5,1 | ×1,00 | ✅ |
| **144 px** | 144×102 | 9,0 × 6,4 | ×1,26 | ✅ |
| **150 px** | 150×106 | 9,4 × 6,6 | ×1,32 | ✅ **retenu** |
| **176 px** | 176×125 | 11,0 × 7,8 | ×1,54 | ✅ (déborde la parcelle) |
| **212 px** | 212×150 | 13,3 × 9,4 | ×1,86 | ✅ (borne haute) |

Aucun diviseur n'est entier — conséquence directe du point 1, pas une négligence.

**Rééchantillonnage NEAREST exclusivement**, conformément à la règle du projet.
Les fichiers `CONTROL_ONLY_*_LANCZOS.png` existent **uniquement pour montrer ce
que NEAREST coûte** sur une source non-pixel-art. Ils ne sont pas proposés à
l'intégration et ne le seront pas.

## 4. SUBSTITUTION sur une parcelle NNV — l'erreur corrigée

**Mon premier jet était faux.** Il posait les quatre candidats sur du terrain
**libre**, en cherchant explicitement un emplacement ne recouvrant aucun
bâtiment. Résultat : j'**ajoutais** quatre maisons au village, et j'en affichais
quatre alors que ce sont quatre **échelles du même asset**.

La demande était l'inverse : les quatre structures NNV (`objplayerhouse`,
`objloggerhouse`, `objhunterhouse`, `objcarpenterhouse`) doivent être
**remplacées**, et l'asset fourni occupe **l'un de ces quatre emplacements**.

`tools/substitute_owner_structure_on_plot.py` fait la substitution :

```
bâtiment actuel de la parcelle  -> RETIRÉ
structure du propriétaire       -> POSÉE à sa place
terrain, arbres, chemins, reste -> INTACTS
les 3 autres parcelles          -> INCHANGÉES
```

**6 bâtiments avant, 6 après.** Le compte est vérifié, pas supposé.

Les 4 parcelles NNV sont déjà tenues par les frames 0–3 de la planche PMU :

| Parcelle | Bâtiment remplacé | Position monde |
|---|---|---|
| `objplayerhouse` | frame 0 (122×120) | (50, 361) |
| `objloggerhouse` | frame 1 (116×99) | (102, 181) |
| `objhunterhouse` | frame 2 (115×98) | (478, 215) |
| `objcarpenterhouse` | frame 3 (126×94) | (176, 3) |

### Le placement corrigé : ancré sur la parcelle

Le premier jet centrait sur le **bâtiment sortant** et alignait par le bas. À
176 px de large sur une parcelle de **150×123**, l'asset **débordait de 13 px de
chaque côté** et empiétait sur les arbres voisins.

L'ancrage porte désormais sur la **parcelle** — la surface réellement libérée
par le retrait de la structure NNV : centré horizontalement dedans, aligné sur
son bord bas où aboutit le chemin du village.

La largeur retenue est **150 px**, la plus grande qui tienne dans la parcelle.
Le confinement est **vérifié**, pas espéré : débordement `{left:0, right:0,
top:0, bottom:0}`, `fits_in_plot: true`. Un dépassement serait signalé comme tel
plutôt que corrigé en silence.

### Son feuillage suit la saison

L'asset porte **47,7 %** de verdure. Laissé vert vif, il aurait juré dans un
village orange en automne et enneigé en hiver — exactement le défaut corrigé sur
les deux autres bâtiments.

Il reçoit donc la **même règle**, via le **même module**
(`seasonalize_building_foliage.py`) : même sélection, mêmes teintes mesurées sur
les arbres NNV. Voir `reports/season-coherence/FOLIAGE_README.md`.

### Le terrain sous la maison n'est pas inventé

Premier essai : je recollais un morceau du rendu de parcelle dégagée. Ça
laissait un **rectangle de terrain plus clair** visible à l'œil — le raccord ne
tombait pas juste. Repris : le terrain est **rendu depuis le Ground matérialisé**
de chaque saison en omettant simplement la `Decoration` remplacée. Ce qui
apparaît sous la maison est le terrain réellement peint dans la donnée.

### Un défaut réel de l'asset, trouvé en le composant

Après substitution, la maison présentait **23 382 divergences de pixels** entre
les quatre saisons. Cause : **l'asset n'a aucun pixel à alpha 255** — son maximum
est 254, et l'essentiel du corps est à 253. Le terrain saisonnier
**transparaissait à travers les murs**. En jeu, la maison se serait teintée en
vert au printemps et en lavande en hiver.

Correction : les pixels **déjà quasi opaques** (alpha ≥ 250) sont promus à 255.
841 792 px sur l'asset natif. Les bords doux, ombres portées et zones
volontairement translucides sont **laissés intacts** — ils doivent se composer
avec le terrain.

Après correction : **13 921 px pleinement opaques comparés, 424 semi-transparents
exclus, 0 divergence** entre les quatre saisons. Vérifié aussi sur l'image.

## 5. Ce qui n'est pas prouvé

- La **collision** de cette structure n'existe pas : aucune cellule 8 px n'a été
  posée. Un bâtiment traversable est un défaut, pas un détail.
- L'**intérieur** n'existe pas : pas de Ground d'intérieur, pas de porte câblée.
- Le **runtime PMDO 0.8.12** reste `NOT_CERTIFIED` (ni dotnet ni mono
  disponibles ici).
- La parcelle montrée est `objplayerhouse`, **par défaut**. Les trois autres
  s'obtiennent avec `--plot objloggerhouse|objhunterhouse|objcarpenterhouse`.
  Le choix de la parcelle et de la largeur te revient.
- Les **trois autres structures NNV** n'ont pas encore de remplaçant : tu n'as
  fourni qu'un asset. Elles restent telles quelles.
