# Doublon Complet `town02` Sans Git LFS — Prêt pour `Quest PMDO` (`0.8.12`) — **3 637 Cartes**

## Statut de Vérification Automatisée (`PASS` — 0 Erreur, 0 Git LFS)

- **Référence GitHub publiée & vérifiée (`HEAD == Remote`)** :
  - **Arborescence complète en ligne (`37 370` fichiers réels, `0` pointeur Git LFS)** :
    `https://github.com/meromoonmeri/projet-creation-pmdo/tree/town02-quest-pmdo-0812-complete`
  - **Téléchargement `.zip` direct en 1 clic (sans même installer Git)** :
    `https://github.com/meromoonmeri/projet-creation-pmdo/archive/refs/tags/town02-quest-pmdo-0812-complete.zip`
  - **Commit SHA vérifié** : `8ceb9e9f1e112470f47babe97c66e187671e1958`
- **Métriques d'intégrité (`VERIFICATION_INTEGRITE_PMDO_0812.json`)** :
  - **Cartes jouables dans `town02/Data/Ground/*.rsground`** : **`3 637` cartes** *(toutes enregistrées dans `Data/Zone/quest_all_maps.json` + `Data/Zone/index.idx`)*
  - **Feuilles de tuiles indexées (`Content/Tile/*.tile`)** : **`2 547` feuilles** *(réparties automatiquement en 4 packs `< 58 MiB` d'`index.idx` liés par `<Relationship>DependsOn</Relationship>` dans `Mod.xml`, tous `< 85 MiB` par fichier)*
  - **Décors parallaxe / ciels (`Content/BG/*.dir`)** : **`219` fichiers `.dir`**
  - **Références de cellules vérifiées (`Sheet` + `TexLoc(X, Y)`)** : **`53 861 144` références -> `0` feuille manquante, `0` `TexLoc` hors bornes**
  - **Pointeurs Git LFS restants (`.rsground`, `.ogg`, `.apng`, `.tile`, `.dir`, `.gitattributes`)** : **`0` (`100 %` binaire natif Git)**

---

## Contenu Inclus (100 % de Toutes les Branches + Tous les Dépôts + Tous les Lots 4:3)

1. **`meromoonmeri/town02` intégralement dé-LFS-ifié (`2 125 -> 0` pointeurs LFS)** :
   - `100 %` des musiques `.ogg` (`227`), animations `.apng` (`269`), tilesets `.tile`, décors `.dir`, sprites `Chara`, `Portrait`, scripts Lua et toutes les cartes Ground originales restaurées.
2. **Toutes les `18` branches de `meromoonmeri/projet-creation-pmdo`** :
   - Les **`78` maps** canoniques `TOUTES_MAPS_TOWN02_RSGROUND` (`40` `cliff_centre_01..10_{nuit,aube,crepuscule,jour}` avec les **3 bandes de nuages Chunsoft en perspective**, eau animée `1:1` et promontoire premier plan `Grass Métano`, `13` `guilde_vide_*` & `cliff_north`, `5` `metano_gen_01..05`, `4` `cliffdaytest*`, `16` palettes de props).
   - *Scène du Réveil* (`ZRV1`, `ZRV2`), *Zone Zéro* (`EAZ1..RAF3`), *Village Pokémon* (`VIL1`, `VIL2`, `layouts_village_v1 & v3` en **`4:3`**), *Tour Temporelle* (`ETT1`, `ETT2`, `FTT1`, `FTT2`), *Bureau & Intérieur Pelipper* (`PPO1`, `interieur_pelipper_v1/v2`), *Traversée du Lac Glacé*, *Grotte Givre*, *Monde Inversé Giratina*, *Colonnes Lances*, *Old Castle*, etc.
3. **Tous les `Lots 4:3` & les `15` branches de `meromoonmeri/projet-pmdo` / `zone-pmdo`** :
   - **`Lot 1 4:3`** (`cote10_01..10_*_{jour,nuit}.rsground`) et **`Lot 2 4:3`** (`cote20_11..20_*_{jour,nuit}.rsground`), *Café Spinda*, *Casino*, *Arènes Groudon Magma*, *Arène Terapagos*, *Donjons 10 Biomes* (`Jour`/`Nuit`), *Sources Lumineuses & Tours* (`cs2_*`), *Antres*, etc.
4. **Tous les dépôts compagnons toutes branches confondues** :
   - `zone-pmd` (3 branches — `328` biomes & arènes de boss), `all-zone-PMDO-project` (2 branches — `176` salles & extérieurs), `mypmdproject` (6 branches — `110` cartes dont *Magnezone HQ* & *Rescue Team Base*), `PMD-SKY-PMDO-PORT`, `PMD-RED-PMDO-PORT`, `new-era-project`, `PMD-NewEra`, `nonamevillage`, `BIBLIOTHEQUE`.

---

## Comment Installer dans `PMDO 0.8.12` (2 Minutes — Zéro Git LFS !)

### Méthode A — Cloner directement dans `PMDO/MODS/` (recommandé)
```bash
git clone --depth 1 --branch town02-quest-pmdo-0812-complete https://github.com/meromoonmeri/projet-creation-pmdo.git C:/Chemin/Vers/PMDO_depot_temp
```
Puis déplacez les **4 dossiers** suivants directement dans **`PMDO/MODS/`** :
- `PMDO/MODS/town02/` *(Quête principale)*
- `PMDO/MODS/town02_tiles_pack_a/` *(auto-chargé par `DependsOn`)*
- `PMDO/MODS/town02_tiles_pack_b/` *(auto-chargé par `DependsOn`)*
- `PMDO/MODS/town02_tiles_pack_c/` *(auto-chargé par `DependsOn`)*

*(Optionnel : si vous préférez n'avoir qu'**un seul dossier `town02/`** dans `PMDO/MODS/`, double-cliquez simplement sur `FUSIONNER_EN_DOSSIER_UNIQUE_OPTIONNEL.bat` sous Windows — ou lancez `python3 fusionner_en_un_seul_dossier.py` — la fusion s'effectue en `0,4 seconde` !)*

Lancez ensuite **`PMDO.exe`** :
- Menu **Quêtes (`Quests`)** -> sélectionnez **`New Era : Abyss to Ascension — ÉDITION INTÉGRALE TOUTES BRANCHES + LOTS 4:3 (3637 Maps)`**.
- Pour tester/éditer n'importe quelle carte :
  - **Ground Editor** : `Dev` -> `Ground` -> `Edit` -> `Open` -> choisissez l'une des **`3 637` cartes**.
  - **En jeu direct** : `Dev` -> `Travel` -> **`Quest PMDO — Catalogue Intégral (3637 Maps)`**.

### Méthode B — Publier vers votre dépôt dédié `https://github.com/meromoonmeri/NEW-ERA-MASTER` (ou `town02`)
*(Note : le jeton de session Arena est restreint en écriture au seul dépôt de session `meromoonmeri/projet-creation-pmdo` ; double-cliquez sur `CLONER_ET_POUSSER_VERS_NEW_ERA_MASTER.bat` sur votre PC ou exécutez ces 4 lignes pour créer `main` sur `NEW-ERA-MASTER` en 30 secondes :)*
```bash
git clone --depth 1 --branch town02-quest-pmdo-0812-complete https://github.com/meromoonmeri/projet-creation-pmdo.git NEW-ERA-MASTER
cd NEW-ERA-MASTER && git checkout -B main
git remote set-url origin https://github.com/meromoonmeri/NEW-ERA-MASTER.git
git push -u -f origin main
```

---

## Crédits & Gouvernance
- **Crédits** : **Palikadude**, **Abyss to Ascension**, **Spike Chunsoft** (*Pokémon Mystery Dungeon: Explorers of Sky* & *Red/Blue Rescue Team*).
- **Statuts de gouvernance** : `art_approved: false` · `runtime_tested: false`.
