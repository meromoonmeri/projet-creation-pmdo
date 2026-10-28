# Lost Wood — génération des tuiles PMDO

Ce lot produit de vrais assets de donjon PMDO 0.8.12 (pas seulement une planche d'aperçu) :

- `quest_pmd_destiny/Content/Tile/LostWoodFloor.tile` — 49 cellules natives 24×24 ;
- `quest_pmd_destiny/Content/Tile/LostWoodWall.tile` — 57 cellules natives 24×24 ;
- `quest_pmd_destiny/Content/Tile/LostWoodSecondary.tile` — 1 535 cellules / frames d'animation ;
- `quest_pmd_destiny/Data/AutoTile/lost_wood_{floor,wall,secondary}.json` — 47 masques d'adjacence, définitions d'autotiles natives ;
- `quest_pmd_destiny/Data/Zone/lost_wood.json` — sept étages aux graphes de génération distincts, tous reliés aux autotiles Lost Wood ;
- `quest_pmd_destiny/Content/Tile/index.idx` — index binaire natif régénéré en ajoutant les trois atlas.

## Pipeline

```sh
python3 -m venv .venv
.venv/bin/pip install numpy pillow
.venv/bin/python source/lost_wood_donjon_v1/build.py
.venv/bin/python source/lost_wood_donjon_v1/test_build.py
```

La structure de données `AutoTileAdjacent` est celle de PMDO 0.8.12 ; les sprites de référence dans `references/` ne servent qu'à reproduire le schéma des 47 cas/frames. **Les pixels des tuiles Lost Wood sont générés par ce script** (écorce, mousse, sol forestier, eau animée) ; aucun sprite commercial n'est recopié. L'aperçu assemblé `renders/lost_wood_donjon_v1/lost_wood_demo_procedural.png` est une planche de composition à but de revue, pas un rendu moteur.

Métadonnées : `art_approved: false`, `runtime_tested: false`. Les vérifications automatiques valident le conteneur natif, les références TexLoc, l'index et les sept étages ; elles ne remplacent pas un lancement dans PMDO.

## Tutoriel d'entrée et récit

À l'entrée de Lost Wood, le partenaire raconte les règles essentielles avant de partir seul : tours de déplacement et réaction des adversaires, attaque et capacités/PP, sac/objets, faim/nourriture, évitement des combats, escaliers et objectif des sept étages. Pour que le héros reste inconscient, la scène le retire de l'équipe active et le met en réserve. À la sortie du septième étage, il est restauré comme héros-joueur et le ground de la clairière joue le réveil ; aucun warp vers Metano n'est déclenché.
