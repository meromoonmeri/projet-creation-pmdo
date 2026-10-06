# Fin Couloir violet — arène rocheuse naturelle (FCV2) — PMDO 0.8.12

La file locale `REPRISE_MAPS.md` indique le Couloir violet après FTL1. Le nom FCV2 et le cadrage de fin sont des choix de travail de l'agent, pas des noms canoniques choisis par l'utilisateur.

Carte 4:3 vaste : **768 × 576 px**, soit **96 × 72 cases de 8 px** (`TexSize=1`). Le passage arrive du sud et débouche sur un grand espace d'arène; un petit autel de roche au nord sert de point focal, sans personnage ni objet de gameplay.

## Calques (bas → haut)

| # | Calque | Contenu |
|---|---|---|
| 00 | Sol complet | Texture de roche mauve générée, base éditable |
| 01 | Sol | Sol praticable de la composition, hors empreintes des gros blocs et de l'autel |
| 02 | Ombres | Pixels sombres du sol séparés par luminance et voisinage local; praticables |
| 03 | Parois | Rebords, massifs rocheux et empreintes bloquées de la composition |
| 04 | Top | Calque vide (`Layer=4`) |

Les calques visibles partitionnent exactement le rendu généré; la composition est normalisée uniformément de 1200 × 896 à 768 × 576 px, avec 2 px de padding répété en haut et en bas avant réduction BOX. Les calques RGBA sont quantifiés dans une palette commune de 96 couleurs, sans tramage.

## Référence et choix de conception

- Aucune capture de la vraie salle finale n'a été trouvée dans le checkout ni parmi les têtes distantes disponibles lors de la vérification. Conformément à la méthode locale, le rendu de la carte d'entrée **S05P03A** est donc la référence de matière et de palette.
- Le rendu de référence est conservé dans `reference/S05P03A.png`. Il est issu de `pret/pmd-sky`, commit `c8073235b39746a7ee74e6cea16c730bd91a1e67`, rendu par l'outil local avec `skytemple-files 1.8.5`; ses métadonnées et son SHA-256 figurent dans `generation.json` et le manifeste.
- Contrôle RGB sur deux zones sans gros rochers : distance euclidienne des moyennes de la matière générée au rip, seuil **35**. C'est une mesure de couleur/matière, pas une preuve de copie pixel à pixel. La composition générée n'est pas un tileset natif certifié.
- L'entrée sud, l'arène centrale, l'autel nord, le titre de travail et le préfixe **FCV2** sont des choix de l'agent. `FCV1` était réservé; FCV2, d'abord contrôlé dans `main` et la tête sœur, a ensuite été re-vérifié dans `main` et les deux têtes Arena distantes disponibles avant empaquetage; aucune collision n'a été trouvée.
- La carte n'ajoute ni cristal, ni dallage/carrelage, ni warp, ni sortie. Les points d'entrée, d'arène et d'objectif sont des marqueurs d'édition uniquement.

## Accès et limites de validation

- Collisions sur grille de 8 px; arrivée sud, arène centrale et objectif nord reliés par une empreinte test de **16 × 16 px**.
- Les masques des massifs rocheux et de l'autel sont des polygones d'édition documentés dans le manifeste; les petits gravillons sont traités comme praticables.
- **Aucun warp, aucune sortie et aucun `donjon_seuil`.**
- Tests locaux, reconstruction des banques `.tile`, archive ORA, paquet et dry-run de l'installeur vérifiés. Le runtime PMDO n'est pas installé ici : aucun rendu moteur ni test de gameplay en jeu n'a été effectué.
- `art_approved: false`; `runtime_tested: false`.

## Livrables

- `renders/fin_couloir_violet_v2/FCV2_projet_pmdo_0812.zip` : projet Ground, banques `.tile`, index et installeur.
- `renders/fin_couloir_violet_v2/FCV2_calques_png_8px.zip` : calques, masques, sources, référence, ORA, manifeste et aperçu.
- `.cache/fin_couloir_violet_v2/FCV2_calques.ora` : document OpenRaster à calques.
- `renders/fin_couloir_violet_v2/review/FCV2_scene_t000.png` et `review/index.html` : rendu de la carte et aperçu interactif.
- `apercu_fin_couloir_violet_v2.html` : aperçu autonome à la racine.

## Reproduire

```sh
.venv/bin/python source/fin_couloir_violet_v2/build.py
.venv/bin/python -m unittest source.fin_couloir_violet_v2.test_build -v
.venv/bin/python source/fin_couloir_violet_v2/verify.py
.venv/bin/python source/fin_couloir_violet_v2/package.py
```
