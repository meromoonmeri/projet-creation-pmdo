# New Era : Quest PMDO 0.8.12 — Édition Intégrale Sans Git LFS (3 637 Cartes — Toutes Branches + Lots 4:3)

Ce dépôt est le **doublon complet 100 % sans Git LFS (`0` pointeur LFS)** de `meromoonmeri/town02`, prêt à l'emploi pour **`PMDO 0.8.12`** et réunissant **les `3 637` cartes Ground** issues de **toutes les branches et de tous les dépôts** :

- **`town02` complet dé-LFS-ifié (`100 %` binaire réel)** : musiques `.ogg`, animations `.apng`, tilesets `.tile`, ciels/décors `.dir`, portraits, sprites, scripts Lua et toutes les cartes originales restaurées.
- **Toutes les branches de `projet-creation-pmdo` (18 branches)** :
  - Pack canonique `78` maps (`40` `cliff_centre_*` *Scène du Réveil* `Nuit`/`Aube`/`Crépuscule`/`Jour` avec **3 plans de nuages Chunsoft** + eau animée `1:1` + promontoire `Grass Métano`, `13` `guilde_vide_*` & `cliff_north`, `metano_gen_01..05`, `cliffdaytest*`, `16` palettes de props).
  - *Scène du Réveil* (`ZRV1`, `ZRV2`), *Zone Zéro* (`EAZ1..RAF3`), *Village Pokémon* (`VIL1`, `VIL2`, `layouts_village` `4:3`), *Tour Temporelle* (`ETT1`, `ETT2`, `FTT1`, `FTT2`), *Bureau Pelipper* (`PPO1`, `interieur_pelipper_v1/v2`), *Traversée Lac Glacé*, *Grotte Givre*, *Monde Inversé Giratina*, *Colonnes Lances*, *Old Castle*, etc.
- **Tous les `Lots 4:3` & les 15 branches de `projet-pmdo` / `zone-pmdo`** :
  - **`Lot 1 4:3`** (`cote10_01..10_*_{jour,nuit}`) & **`Lot 2 4:3`** (`cote20_11..20_*_{jour,nuit}`), `layouts_village_v1 & v3` (`4:3`), *Café Spinda*, *Casino*, *Arène Groudon Magma*, *Arène Terapagos*, *Donjons 10 Biomes*, *Sources Lumineuses & Tours*, *Antres*, etc.
- **Tous les dépôts compagnons** : `zone-pmd` (3 branches), `all-zone-PMDO-project` (2 branches), `mypmdproject` (6 branches — *Magnezone HQ*, *Rescue Team Base*, *Boss Zones*), `PMD-SKY-PMDO-PORT`, `PMD-RED-PMDO-PORT`, `new-era-project`, `PMD-NewEra`, `nonamevillage`, `BIBLIOTHEQUE`.

---

## Installation immédiate dans PMDO `0.8.12` (0 Git LFS requis !)

1. Clonez ce dépôt normalement (`git clone --depth 1 --branch town02-quest-pmdo-0812-complete https://github.com/meromoonmeri/projet-creation-pmdo.git NEW-ERA-MASTER`).
2. Copiez les **4 dossiers** suivants directement dans le dossier **`MODS/`** de votre installation `PMDO 0.8.12` :
   - `town02/` *(Quête principale contenant les `3 637` cartes dans `Data/Ground/` et la zone `quest_all_maps`)*
   - `town02_tiles_pack_a/` *(chargé automatiquement via `<Relationship>DependsOn</Relationship>`)*
   - `town02_tiles_pack_b/` *(chargé automatiquement via `<Relationship>DependsOn</Relationship>`)*
   - `town02_tiles_pack_c/` *(chargé automatiquement via `<Relationship>DependsOn</Relationship>`)*
   *(Optionnel : sous Windows, double-cliquez sur `FUSIONNER_EN_DOSSIER_UNIQUE_OPTIONNEL.bat` — ou lancez `python3 fusionner_en_un_seul_dossier.py` — pour fusionner instantanément les 4 dossiers en un seul dossier `town02/` !)*
3. Lancez **`PMDO` (`0.8.12`)** -> **Quêtes (`Quests`)** -> sélectionnez **`New Era : Abyss to Ascension — ÉDITION INTÉGRALE`**.
4. Pour ouvrir ou visiter n'importe laquelle des **`3 637` cartes** :
   - **Éditeur** : mode `Dev` -> onglet `Ground` -> `Edit` -> `Open` -> choisissez n'importe laquelle des `3 637` cartes `.rsground`.
   - **Jeu direct** : mode `Dev` -> `Travel` -> **`Quest PMDO — Catalogue Intégral (3637 Maps)`**.

---

## Gouvernance & Crédits

- **Crédits artistiques** : **Palikadude**, **Abyss to Ascension**, **Spike Chunsoft** (*Pokémon Mystery Dungeon: Explorers of Time / Darkness / Sky* & *Red/Blue Rescue Team*).
- **Statuts de validation** : `art_approved: false`, `runtime_tested: false` (vérification binaire automatisée `PASS` sur `53 861 144` références de tuiles, `0` pointeur Git LFS, `0` feuille `.tile` manquante, `0` coordonnée `TexLoc` hors bornes).

---

## Pousser ce doublon sans LFS vers `meromoonmeri/NEW-ERA-MASTER` ou `meromoonmeri/town02` en 1 commande

Depuis votre PC (aucun Git LFS nécessaire) :
```bash
git clone --depth 1 --branch town02-quest-pmdo-0812-complete https://github.com/meromoonmeri/projet-creation-pmdo.git NEW-ERA-MASTER
cd NEW-ERA-MASTER
git checkout -B main
git remote set-url origin https://github.com/meromoonmeri/NEW-ERA-MASTER.git
git push -u -f origin main
```
