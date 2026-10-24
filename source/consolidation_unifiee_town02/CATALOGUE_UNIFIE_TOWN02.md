# Consolidation Unifiée : `town02` + Toutes les Branches `projet-creation-pmdo` & `Guilde Treehouse PMD`

Ce dossier contient le **manifeste multi-branches vérifié** et l'**assembleur clé-en-main** permettant de réunir dans **un seul dépôt GitHub jouable (`PMDO 0.8.12.0`)** :

1. **L'intégralité de `meromoonmeri/town02`** (`1620` cartes `.rsground`, `2091` planches `.tile`, `4354` scripts Lua, `Mod.xml`, `Strings/`, `CONVERSION/`, `converter/`, `dev/`, `dist/`, `installer/` — `1887.43 Mo` hors objets LFS lourds).
2. **Toutes les maps de toutes les branches de `meromoonmeri/projet-creation-pmdo`** (`19` branches, incluant les `33` maps Studio 10 calques 60 FPS jusqu'à `FAE1`/`FAS1` et `KYE1`/`KYA1`, les mods unifiés entrées/fins, etc.).
3. **Toutes les maps de `Guilde Treehouse PMD`** issues des `15` branches de `meromoonmeri/projet-pmdo`, de `meromoonmeri/zone-pmdo`, de `meromoonmeri/all-zone-PMDO-project` et du dépôt compagnon `meromoonmeri/guilde-treehouse-pmd` (`12` salles modulaires `salles/01..12`, fenêtres transparentes `fenetres_exterieur/01..12`, `6` ambiances `exterieur/{aube,crepuscule,jour,nuit,orageux,soir}.png`, passages ouverts PMD, calques et sprites).

---

## 1. Lancement en 1 seule commande (PC / Mac / Linux / WSL / GitHub Codespaces)

Depuis un terminal connecté à votre compte GitHub (`gh auth status` + `git-lfs` installé) :

```bash
git clone -b arena/637b0828-projet-creation-pmdo https://github.com/meromoonmeri/projet-creation-pmdo.git
cd projet-creation-pmdo
bash source/consolidation_unifiee_town02/CREER_REPO_UNIFIE_TOWN02.sh town02-all-maps-pmdo --public
```

> Pour créer le dépôt en **privé**, remplacez `--public` par `--private`.

### Ce que la commande exécute automatiquement :
- Clone `meromoonmeri/town02` (`main`) avec `git lfs pull` (préservant `WaterfallVillageCapital.rsground` de `233,7 Mo` et les `1 620` `.rsground` natifs).
- Récupère **toutes les branches** de `projet-creation-pmdo` (`19`), `projet-pmdo` (`15`), `zone-pmdo` (`1`), `all-zone-PMDO-project` (`1`) **et** `guilde-treehouse-pmd` (si accessible avec votre session `gh`).
- Fusionne les **`416` lots `source/*` uniques** (en priorisant `arena/637b0828-projet-creation-pmdo` puis le commit le plus récent, tout en archivant les `164` lots ayant des variantes inter-branches dans `maps_sources/variantes_branches/` pour ne perdre **aucun** essai).
- Fusionne les **`354` lots `renders/*`**, les **`331` aperçus HTML** et les **`11` répertoires racine Guilde Treehouse** (`OUTILS, apercus, beachsky_v1, calques, col_eboulis_v1, exports, exterieur, fenetres_exterieur, salles, sprites, tiled`).
- Exécute les `build.py` procéduraux afin de matérialiser les `.tile`, `.rsground` et `init.lua` sur disque.
- Installe toutes les nouvelles planches `.tile` dans `Content/Tile/`, met à jour **`Content/Tile/index.idx`** au format binaire exact `RogueEssence.Content.TileGuide` (tri alphabétique + contrôle octet-pour-octet), installe les `.rsground` dans `Data/Ground/` (sans écraser les maps natives de `town02`), et exécute la **garde anti-damier mauve** (`0` planche absente, `0` `TexLoc` manquant, signatures PNG vérifiées).
- Protège automatiquement via `.gitattributes` (Git LFS) tout fichier `> 90 Mo`, crée `meromoonmeri/town02-all-maps-pmdo` et pousse l'ensemble.

---

## 2. Synthèse chiffrée de l'inventaire multi-branches

| Source | Branches inspectées | Éléments recensés |
| :--- | :---: | :--- |
| `meromoonmeri/town02` | `1` (`main` @ `1efd098`) | `1620` `.rsground`, `2091` `.tile`, `4354` scripts `.lua` |
| `meromoonmeri/projet-creation-pmdo` | `19` | Fusionné dans les `416` lots `source/*`, `354` lots `renders/*` et `331` aperçus HTML |
| `meromoonmeri/projet-pmdo` | `15` | Fusionné dans les `416` lots `source/*`, `354` lots `renders/*` et `331` aperçus HTML |
| `meromoonmeri/zone-pmdo` | `1` | Fusionné dans les `416` lots `source/*`, `354` lots `renders/*` et `331` aperçus HTML |
| `meromoonmeri/all-zone-PMDO-project` | `2` | Fusionné dans les `416` lots `source/*`, `354` lots `renders/*` et `331` aperçus HTML |
| `meromoonmeri/guilde-treehouse-pmd` | Privé (auto-aspiré via `gh`) | `12` salles modulaires (`salles/01..12`), `fenetres_exterieur/01..12` et `6` ambiances déjà incluses publiquement + aspiration directe des branches privées |

---

## 3. Détail de toutes les branches inspectées (`36` branches publiques + `guilde-treehouse-pmd`)

### `meromoonmeri/projet-creation-pmdo` (`19` branches)

| Branche | Commit | Date | Dernier sujet |
| :--- | :---: | :---: | :--- |
| `arena/637b0828-projet-creation-pmdo` | `0a10ed0` | `2026-10-24` | feat(unys-kyurem): add Giant Chasm duo (KYE1/KYA1) with glacial Metano Town water, black-ice sanctum & 360° blizzard cyclone (33 maps / 330 layers) |
| `arena/c89cd39e-projet-creation-pmdo` | `1df0040` | `2026-10-23` | feat(zekrom): add ZKE1 (montagne d'orage, clairiere P14P01A 1x, riviere GBA H10P02) & ZKA1 (sommet runique, tornade noire 360deg) - 17 maps / 170 layers, 102/102 tests |
| `arena/ea12f8dd-projet-creation-pmdo` | `9fa272a` | `2026-10-20` | EOC1 Entree Old Castle sud-nord : rendu genere reference oldcastlepmd, 10 calques, scintillement dore, Ground PMDO 0.8.12, 10 tests PASS |
| `arena/17e933d9-projet-creation-pmdo` | `7f88841` | `2026-10-20` | Supprimer le lot LCM1 (5 cartes Clairiere) : methode multicalque non suivie |
| `arena/d87422d0-projet-creation-pmdo` | `eefda83` | `2026-10-20` | feat(EMH1,FMH1,EFF1,FFF1,ENR1,FNR1,EFC1,FFC1,EBH1,FBH1,mods): 10 nouvelles maps (Mt. Horn, Foggy Forest, Northern Range, Foret Champignon, Bassin Chauffant) et mods unifies (28 entrees, 26 fins) |
| `arena/75cecc86-projet-creation-pmdo` | `61fa7a7` | `2026-10-18` | Animate a red-black nebula behind FTT1 |
| `arena/7a9fd1dd-projet-creation-pmdo` | `47385ac` | `2026-10-18` | Ajout du lot Grotte de Givre (EGI1 + FGI1) : entrée + fin de donjon canoniques D53 |
| `arena/8fe7a740-projet-creation-pmdo` | `147367c` | `2026-10-18` | Supprime le Promontoire 2 (zone de réveil) à la demande de l'utilisateur ; reste dans l'historique |
| `arena/1ec61104-projet-creation-pmdo` | `b0ba249` | `2026-10-17` | FTT2 Fin Tour Temporelle V2: arene du prisme temporel (fin construite depuis ETT2, decor nouveau reference, sol/nuages et lois repris byte-identiques, 14 tests PASS, 4 mutations, rebuild identique) |
| `arena/78cf8e01-projet-creation-pmdo` | `d34be74` | `2026-10-16` | Ajoute TLG1 lac gelé traversable et conserve le col suspendu |
| `arena/f9b9e04a-projet-creation-pmdo` | `f243f3e` | `2026-10-16` | ECE2: complete entrance with frosty forest, seamless design, and documentation |
| `arena/01a10333-projet-creation-pmdo` | `5bfb2e5` | `2026-10-16` | Rebuild and verify ETT2 map preview |
| `arena/52e6a9de-projet-creation-pmdo` | `c2d7795` | `2026-10-15` | fix(anim,galerie): animation logique des nuages selon leur disposition (ETT1, FTT1, EMH1, FMH1) et affichage direct de la Tour Temporelle en tete de la galerie |
| `main` | `8d2a5b8` | `2026-10-13` | Add files via upload |
| `arena/7c717e20-projet-creation-pmdo` | `931f4b4` | `2026-10-10` | PPO2 : intérieur Pelipper à la taille Halcyon 384x312 (post_office.rsground), rendu généré spacieux, tests, notice |
| `arena/94f0168a-projet-creation-pmdo` | `e41dd3f` | `2026-10-09` | PPO1 : magenta franc hors ovale, noir autour (plus de bandes) |
| `arena/36da3b03-projet-creation-pmdo` | `1b06ddc` | `2026-10-06` | Add Entree Foret Moussa EFM1 - multilayer 100% canonique single-generator |
| `arena/d0045c3b-projet-creation-pmdo` | `149914f` | `2026-10-06` | Layouts village v3 : 3 terrains nus chemins + grande place (1200x896, style v1) |
| `arena/dec8688e-projet-creation-pmdo` | `52eed1b` | `2026-10-06` | Add Fin Couloir violet FCV3 map |

### `meromoonmeri/projet-pmdo` (`15` branches)

| Branche | Commit | Date | Dernier sujet |
| :--- | :---: | :---: | :--- |
| `arena/cec12ba4-projet-pmdo` | `e0268cd` | `2026-10-08` | Integrate remote pilot work; retain corrected canonical D52 base |
| `arena/f4987da6-projet-pmdo` | `0a67f0c` | `2026-10-07` | feat(maps): add PVC1 crystal passage |
| `arena/01a108a6-projet-pmdo` | `2801e22` | `2026-10-05` | Complete Zenith entrance-path-finale trilogy |
| `arena/01a0f7e8-projet-pmdo` | `2e7182d` | `2026-10-05` | IMW3 Traversée : nouvelle intro de Mew dans l'esprit Treasure Town (EoS) |
| `arena/01a10bc6-projet-pmdo` | `0b52def` | `2026-10-05` | feat(maps): consolider six finales PMDO sur la branche de session |
| `arena/01a106dc-projet-pmdo` | `adeab32` | `2026-10-04` | Generate Halcyon-scale guild village concept |
| `arena/01a1024d-projet-pmdo` | `62a0014` | `2026-10-04` | Add EPR1 ruins passage map |
| `arena/01a0fd01-projet-pmdo` | `6a6dac9` | `2026-10-02` | ZPR1 : zone Plage aux récifs étoilés (baie multicalque, ciel étoilé aux 4 moments, récifs et coraux) |
| `arena/01a0fdc2-projet-pmdo` | `07f95d1` | `2026-10-02` | ZPR1 : build partiel (geographie, segmentation terre validee, review) |
| `arena/01a0ef89-projet-pmdo` | `4f5f6a0` | `2026-10-01` | EMB2 veines : calque genere dedie (layout strict + 221081), filtrage canonique coeur sombre + filaments chauds (2-4,5 px), animation par cycling le long de la fissure (onde verticale + coeur->halo), 32x24 ticks, tests 8/8 |
| `arena/01a0f697-projet-pmdo` | `8683fd4` | `2026-10-01` | Fin Mt. Thunder V2 (FTN1) : documentation README, AGENTS, REPRISE_MAPS |
| `arena/01a0ef03-projet-pmdo` | `97e611d` | `2026-09-29` | Correct EMB2 navigation cell counts |
| `arena/01a0eecd-projet-pmdo` | `731d750` | `2026-09-29` | Mt Blaze reprise propre multicalque — lave & veines palette cycling (32x15) |
| `arena/01a0ed06-projet-pmdo` | `4430d52` | `2026-09-29` | Plan spriter ressource |
| `main` | `6cca4a0` | `2026-09-29` | Fin Star Cave (FST1) : arène de cristal 4:3, calques et animations, marqueurs entrance/boss/objectif, 13 tests, paquets, aperçu |

### `meromoonmeri/zone-pmdo` (`1` branches)

| Branche | Commit | Date | Dernier sujet |
| :--- | :---: | :---: | :--- |
| `main` | `a434515` | `2026-09-25` | Beach/Sky v1 : eau canon Beach mesurée (9 frames vagues dessinées + 17 frames rivage sur sable, base fixe) ; guide COMMENT_JE_FAIS_LES_MAPS.md ; audit 14/14 |

### `meromoonmeri/all-zone-PMDO-project` (`2` branches)

| Branche | Commit | Date | Dernier sujet |
| :--- | :---: | :---: | :--- |
| `main` | `8c6d189` | `2026-09-20` | Add reference link to GitHub repository |
| `guilde-treehouse-historique` | `b7404f6` | `2026-09-12` | Add ten V2 coastal shapes as native PMDO 0.8.12 editing pack |
