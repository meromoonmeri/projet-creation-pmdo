# Workflow — créer une carte (série courante)

Procédure **opératoire** d’une session. La méthode (magenta, calques, fidélité, Ground)
est dans [GUIDE_CREATION_DE_MAP.md](GUIDE_CREATION_DE_MAP.md) et
[METHODE_MAGENTA_ET_GENERATEUR.md](METHODE_MAGENTA_ET_GENERATEUR.md).
Le gabarit à copier est `source/entree_jungle_sud_nord_v1/`.
L’index des lots de la série est [source/methode_serie_sud_nord/](source/methode_serie_sud_nord/).

Ce dépôt **n’embarque pas les bruts ni les PNG de rendu** (extraction méthodes, ~169 Mo).
Sans eux, `build.py` ne peut pas relancer un lot existant. Voir
[MANIFESTE_EXTRACTION.md](MANIFESTE_EXTRACTION.md).

---

## 0. Ouverture de session (dans l’ordre)

1. Lire **ce fichier**, [README.md](README.md), [REPRISE_MAPS.md](REPRISE_MAPS.md)
   (fin : carte suivante + préfixes pris), [AGENTS.md](AGENTS.md) (contrat),
   le `WORKFLOW.md` du gabarit et le `README_PACK.md` du lot jumeau (entrée ↔ fin).
2. Recréer l’environnement (non versionné) :

   ```sh
   python3 -m venv .venv
   .venv/bin/pip install Pillow==12.3.0 numpy==2.4.0 scipy==1.17.0
   ```

3. Relancer le serveur d’aperçus (écoute `0.0.0.0`, liens relatifs seulement) :

   ```sh
   python3 source/serveur_apercus/serve.py --port 8000
   ```

4. **Ne pas fusionner** les branches sœurs. Relever les préfixes déjà pris
   (`git grep -n "PFX = " source -- "*.py"` ici, et `git ls-remote --heads origin`
   si le dépôt source `projet-pmdo` est accessible). Un préfixe homonyme écrase
   des tuiles à l’import (« PNG to Tileset » nomme par basename).

---

## 1. Choisir le lot

| Série | Direction | Marqueurs | Warp |
|---|---|---|---|
| **Entrée** sud → nord | couloir / sentier au sud, bouche au nord | `entrance` sud, `donjon_seuil` sous la bouche | aucun |
| **Fin** de donjon | même biome que l’entrée, arène fermée | `entrance` sud, `boss` centre, `objectif` nord | aucun, **pas** de `donjon_seuil` |
| **Zone** (réveil, routes) | selon la demande | documentés dans le lot | seulement si demandé |

- **Textures canoniques** = rendu généré **référencé** : le rip PMD est passé au générateur
  (`images=[rip]`). Ce n’est **pas** un relayout de pixels natifs, sauf demande explicite.
- Format standard : **768 × 576 px = 96 × 72 cases**, grille 8 px, `TexSize=1`.
- Identifier le lot : `source/<slug>_vN/`, préfixe 4 lettres unique (`EJN1`, `FST1`, `FCT1`…).
- **Ne jamais écraser** un lot antérieur : incrémenter `vN` ou changer le slug.

Dernier lot livré ici : **FVL1 Fin Couloir violet** (`source/fin_couloir_violet_v1/`).
Carte suivante : **Fin Mt. Thunder** (préfixe à choisir, `FMT1` pris sur une sœur).

---

## 2. Copier le gabarit, pas un lot voisin « presque pareil »

```sh
# structure minimale d'un chantier
source/<slug>/
  build.py              # GEN, classify, calques, Ground, manifeste
  test_build.py         # images / formats / cadence / fidélité — PAS le moteur
  package.py            # ZIP projet + ZIP calques + aperçu HTML
  viewer_template.html
  README_PACK.md        # notice livrée dans le ZIP
  WORKFLOW.md           # ce lot : rip, seuils, bruts, commandes
  STATUS.md             # état (tests, art_approved, ce qui manque)
  bruts/                # NON extraits ici ; décor, sol, planches
```

Réutiliser par `loadmod` les utilitaires déjà stables :

| Besoin | Module |
|---|---|
| `keep_large`, `quantize_layers`, `place`, `cell_grid`, `write_ora` | `source/entree_bristle_sud_nord_v1/build.py` (régler `BM.W, BM.H`) |
| `down_class`, `down_full`, `rgba`, `quantize_group`, gabarit 4:3 | `source/entree_jungle_sud_nord_v1/build.py` |
| `reachable` (BFS, perso 16 × 16) | `source/entree_sud_nord_generee_v1/build.py` |
| Codec Ground / `.tile` / `index.idx` | `source/pmdo_cote/build.py`, `INSTALLER.py` |
| Magenta `key()`, `tint()` | `source/layouts_magenta_v1/palette.py` |

**Lire avant d’importer** : certains anciens builders écrivent dès l’import.

---

## 3. Générer les bruts (plein cadre, magenta)

Dans `source/<slug>/bruts/` :

1. **`decor_magenta.png`** (ou `decor.png` si rien à détourer) — paysage **4:3 zoomed out**,
   consigne `WIDE LANDSCAPE 4:3` → viser **1200 × 896**. Magenta pur `#FF00FF` à la place
   de l’eau / lave / vide / cascade. Rip en `images=`. Pas de perso, pas d’UI, pas de bordure.
2. **`sol_complet.png`** — même cadrage, sol seul (herbe, sable, dalle…). Éditer le décor
   plutôt que de redessiner. Recaler à (0, 0) et noter l’écart moyen.
3. **Planche de poses** sur magenta (papillons, poussière, vapeur…) — grille rarement
   respectée : **mesurer les fenêtres à la main** (`POSE_WIN`).
4. Écarter un brut hors format (ex. 1440 × 720 = 2:1) ou hors seuil de fidélité
   (~35 de distance RVB moyenne sur masque). Le garder dans `bruts/ecartes/`, ne pas
   le « corriger en silence ».

Les prompts réellement utilisés sont dans la liste `GEN` du `build.py` du lot
(et recopiés dans son `WORKFLOW.md`).

---

## 4. Segmenter → réduire → animer → collisions

1. `classify()` **en pleine résolution**, seuils **mesurés et commentés** sur le brut.
2. Réduire **par classe** (`down_class`, facteur `576/896`), recadrage centré 768 × 576.
   Jamais l’image entière avant la segmentation.
3. Palette commune 96 couleurs (MEDIANCUT, sans dither) ; palettes séparées si une
   matière vire (cristaux, arbres).
4. Un calque par fonction, bas → haut, **Top vide** (`Layer=4`) au-dessus.
   Animations chacune sur son calque, boucle fermée **y compris dernière → première**,
   scène au PPCM des cadences (souvent 120 ou 240 ticks).
5. `cell_grid` : case bloquée si > 25 % non praticable. Chemin 16 × 16 prouvé par
   `reachable`. Vue `review/<PFX>_collisions_marqueurs.png`.

---

## 5. Tests, paquet, documentation, git

```sh
.venv/bin/python source/<slug>/build.py
.venv/bin/python -m unittest source.<slug>.test_build -v
.venv/bin/python source/<slug>/package.py
```

`package.py` écrit :

- `renders/<slug>/<PFX>_projet_pmdo_0812.zip`
- `renders/<slug>/<PFX>_calques_png_8px.zip`
- `apercu_<slug>.html` (base64, hors ligne — **ne pas versionner** s’il dépasse ~1 Mo)

Puis, dans le même commit de lot :

| Fichier | Quoi |
|---|---|
| `source/<slug>/README_PACK.md` | notice d’install + calques + limites |
| `source/<slug>/WORKFLOW.md` | rip, GEN, seuils, commandes, ce qui manque |
| `source/<slug>/STATUS.md` | tests PASS, `art_approved: false`, `runtime_tested: false` |
| `renders/<slug>/README.md` | fiche de livraison (fidélité chiffrée) |
| `renders/<slug>/manifest.json` | hashes des bruts, `art_approved: false` |
| [JOURNAL_GUILDE_TREEHOUSE.md](JOURNAL_GUILDE_TREEHOUSE.md) | entrée en tête |
| [REPRISE_MAPS.md](REPRISE_MAPS.md) | état, préfixe, carte suivante |
| [INDEX_METHODES.md](INDEX_METHODES.md) | ligne du sous-projet |
| [AGENTS.md](AGENTS.md) | seulement si le contrat change |

Commit + push **uniquement** sur la branche de session. Rien fusionné depuis une sœur.

Ne jamais déclarer fait : un test moteur non exécuté, une approbation artistique,
une ouverture de carte dans l’éditeur.

---

## 6. Pièges (déjà payés)

- Homonymes de PNG → écrasement à l’import. Préfixe unique, toutes branches confondues.
- Décor 2:1 écarté. Magenta approximatif → liseré rose (`key()` par rapport de canaux).
- Liseré clair de rive : **interdit** (retour EWC1), sauf exception écrite (écume ZRV1).
- `.venv` absente après checkout ≠ tests cassés.
- ORA : horodatages ZIP différents, membres identiques → restaurer si seul changement.
- Un test Python à 0 px de différence **n’est pas** un test PMDO.
- Dans *ce* dépôt, les PNG de `renders/` et les `bruts/` ne sont **pas** là :
  `build.py` d’un ancien lot échouera tant qu’on ne les a pas récupérés.

---

## 7. Récupérer un brut ou un rip

Depuis `meromoonmeri/projet-pmdo` @ `6cca4a0` (API GitHub, pas `raw.githubusercontent.com`) :

```sh
gh api "repos/meromoonmeri/projet-pmdo/contents/<chemin>?ref=6cca4a09380211e510ab1bea454a1b1926ef4b5a" \
  --jq .content | base64 -d > <fichier>
```

Ou `OUTILS/extraire_depuis_projet-pmdo.py --seulement source/<slug> --avec-media`.
