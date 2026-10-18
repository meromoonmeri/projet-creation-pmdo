# Pack PMDO 0.8.12 — Fin de la Tour Temporelle V2 (`FTN2`, Sommet Noir & Or Prismatique)

- **Identifiant** : `FTN2` (`fin_tour_temporelle_noire_or_v2`)
- **Carte Ground** : `Data/Ground/ftn2_fin_tour_temporelle_noire_or.rsground`
- **Format** : `768 × 576 px` (`96 × 72` tuiles de `8 × 8 px`, `TexSize = 1`)
- **Boucle d'animation** : `240` ticks (`4.0 s` à `60 fps`, `24` phases de `10` ticks)
- **Entrée appairée** : `ETT2` (`source/entree_tour_temporelle_sud_nord_v2/`)

## Contenu des couches (`renders/fin_tour_temporelle_noire_or_v2/layers/`)

| Ordre | Fichier | Type | Phases × Ticks | Description |
| --- | --- | --- | --- | --- |
| `01` | `01_nuages_orage_rouges.png` | Animé (`Layer=0`) | `10 × 12` (`120t`) | **Couche de nuages indépendante** (`768 × 576` opaque, zéro interstice) : 9 strates de nuages d'orage cramoisis et noir d'encre en parallaxe horizontale différentielle (`±40 px/frame` sur période `400 px`) + ondulation des crêtes écarlates, sans Trou Noir figé dans la couche |
| `02` | `02_trou_noir_spirale.png` | Animé (`Layer=0`) | `10 × 12` (`120t`) | **Couche du Trou Noir indépendante** (`768 × 576` RGBA avec transparence hors du vortex et entre les bras spiraux externes, centrée en `cx=384, cy=134`) : horizon noir abyssal (`r=72 px`), anneau d'accrétion ambre-or solaire (`r=72..98 px`), rotation physique continue des bras spiraux (`18°/frame` = `180°` par cycle de 10 frames) et ondes d'accrétion relativistes entrantes |
| `03` | `03_etoiles_distorsion.png` | Animé (`Layer=0`) | `12 × 10` (`120t`) | Poussières et étincelles gravitationnelles dorées et écarlates |
| `04` | `04_rochers_flottants.png` | Animé (`Layer=1`) | `8 × 15` (`120t`) | 5 îlots rocheux d'obsidienne noire en lévitation douce (`[-1, 0, +1] px`) |
| `05` | `05_chaussee_noire.png` | Fixe (`Layer=1`) | `1 × 240` | Chaussée sud en basalte noir naturel (identique à `ETT2`) |
| `06` | `06_parvis_dalles.png` | Fixe (`Layer=1`) | `1 × 240` | Escalier sud, esplanade octogonale ouverte en dalles d'ardoise sombre (sans piliers) et escalier nord |
| `07` | `07_parois_rocheuses.png` | Fixe (`Layer=1`) | `1 × 240` | Parois et surplombs rocheux en obsidienne noire |
| `08` | `08_muraille_gothique.png` | Fixe (`Layer=1`) | `1 × 240` | Arche gothique centrale en ogive encadrant le sanctuaire nord |
| `09` | `09_reliquaire_cristal.png` | Fixe (`Layer=1`) | `1 × 240` | Reliquaire à pointes de cristal blanc-cyan scellant le cadran |
| `10` | `10_cadran_temporel.png` | Animé (`Layer=2`) | `24 × 10` (`240t`) | Cadran temporel circulaire (`cx=384, cy=164`) à roue spectrale tournante et aiguille d'or |
| `11` | `11_circuits_or.png` | Animé (`Layer=2`) | `16 × 5` (`80t`) | Pulsation d'or en fusion sur les veines des rochers noirs, la chaussée sud et l'arche |
| `12` | `12_reflets_arc_en_ciel.png` | Animé (`Layer=2`) | `24 × 10` (`240t`) | Onde de reflets arc-en-ciel parcourant toutes les veines d'or et les pointes du reliquaire |
| `13` | `13_particules_or.png` | Animé (`Layer=2`) | `12 × 10` (`120t`) | Particules d'or et éclats prismatiques ascendants |
| `14` | `14_top_vide.png` | Fixe (`Layer=4`) | `1 × 240` | Calque `Top` vide (`0` pixel opaque) réservé à l'éditeur PMDO |

## Marqueurs Ground (`Markers`)

- `entrance` : `(384, 512)` (`gx=48, gy=64`) — arrivée sur la chaussée sud en basalte noir.
- `boss` : `(384, 336)` (`gx=48, gy=42`) — centre de l'esplanade octogonale du boss.
- `objectif` : `(384, 248)` (`gx=48, gy=31`) — parvis nord face au cadran temporel et au Trou Noir.

## Statut honnête

- `art_approved: false`
- `runtime_tested: false`
