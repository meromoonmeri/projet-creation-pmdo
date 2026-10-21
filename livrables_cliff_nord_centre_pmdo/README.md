# Cliff Nord Centrée — Grass Métano Multicalque (PMDO 0.8.12, Jour & Nuit Animés)

## Contenu du pack (`100 % textures natives Halcyon / Chunsoft — 0 % génération IA`)
- **Dimensions** : `1200 × 880 px` (`150 × 110` tuiles `8×8`, `TexSize = 8`), promontoire **parfaitement centré sur `X = 600 px`** entouré par la mer animée à l'**Ouest**, au **Nord** et à l'**Est**, avec **isthme piéton centré au Sud (`X = 484..716, Y = 880`)**.
- **4 cartes `.rsground` prêtes pour PMDO `0.8.12`** dans `MOD_CLIFF_NORD_CENTRE_PMDO/Data/Ground/` :
  1. `cliff_nord_centre_jour.rsground` — **Jour complet animé** (`8` calques `MapLayer` + `4` couches `LayeredBG`)
  2. `cliff_nord_centre_nuit.rsground` — **Nuit étoilée animée** (`8` calques `MapLayer` + `5` couches `LayeredBG` avec lune & étoiles)
  3. `cliff_nord_centre_nue_jour.rsground` — **Plateau Nu Jour prêt à bâtir** (Ciel/Nuages + Mer 8 phases + Parois Falaise + Plateau Grass Métano + 3 calques vierges)
  4. `cliff_nord_centre_nue_nuit.rsground` — **Plateau Nu Nuit prêt à bâtir**
- **Calques séparés `PNG 1×` sans perte** (`Jour` & `Nuit`) dans `calques_1x_separes/` et rendus complets dans `png_1x/`.

## Installation dans votre projet PMDO existant (sans écraser votre `index.idx`)
```bash
python INSTALLER.py "CHEMIN/VERS/PMDO/MODS/TON_MOD" --dry-run
python INSTALLER.py "CHEMIN/VERS/PMDO/MODS/TON_MOD"
```

## Crédits & Statut honnête
- **Crédits artistiques** : **Palikadude** (*PMD: Halcyon* — `Metano_Town_Base`, `Metano_Town_Cliffs`, `Metano_Town_Objects`, `Metano_Town_Animation_Tileset` et variantes `_Night`) & **Chunsoft / Nintendo / The Pokémon Company** (*PMD: Explorateurs du Ciel*).
- **Statut de vérification** : `art_approved: false`, `runtime_tested: false` (vérifié mathématiquement sur la structure binaire `.tile` / `.dir` / `index.idx` / `.rsground` ; à ouvrir dans l'éditeur Ground de PMDO `0.8.12` pour validation finale en jeu).
