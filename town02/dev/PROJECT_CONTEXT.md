# PROJECT_CONTEXT — New Era : Abyss to Ascension

## Décision fondatrice autoritative — 2026-08-07

- New Era est une suite dans le même monde que Rescue Team et Explorers of Sky, environ 30 ans plus tard.
- Les lieux canoniques conservent leur nom et leur géographie reconnaissable ; la convention de noms originaux ne concerne que les lieux inédits.
- Les imports Sky/Red 1:1 sont la fondation du monde, ensuite vieillie par retouche artistique manuelle.
- **`cloven_ruins` / Aegis Cave est le donjon final du chapitre 5**, après le Mont Venteux, et mène à `FinishedExpedition` puis au chapitre 6. Toute mention le classant chapitre 7 est obsolète.
- Référence complète : `docs/CONTINUITE_CANONIQUE_30_ANS_APRES.md`.
- **Portée à partir de la fin du chapitre 5 / début du chapitre 6** : un lieu canonique est un paquet indivisible Ground(s) + donjon JSON + segments + salles `.rsmap` + tables + mécaniques + boss + musique + scripts + géographie. Les Grounds Red/Sky ne sont jamais des décors interchangeables. Tout croisement entre le Ground d’un lieu et le JSON/boss d’un autre est une corruption architecturale à démêler.


Dernière mise à jour : 2026-08-05 (fix duel Metano — session agent Arena.ai)

## Session 2026-08-05 — Damier mauve/noir du duel Team Dazzling (RÉSOLU)

- **Incident** : `metano_town_duel` en damier mauve/noir depuis `9cbdf80`
  (63×63 « copie pixel » de toute la ville).
- **Cause racine vérifiée octet par octet** : les 27 planches
  `metano_city_*.tile` n'ont **jamais été injectées** dans
  `Content/Tile/index.idx` (541 entrées avant, pendant et après le commit,
  malgré son message affirmant « 568 planches »). Sans entrée d'index, le
  moteur dessine la texture manquante = damier.
- **Correctif** : restauration du `.rsmap` à `79a096b` (14×18, état valide),
  suppression des 27 planches mort-nées. Positions intactes : entrées
  (6,10)/(5,10), trio au centre.
- **Preuve** : 0 pixel d'écart avec la fenêtre (41,29) de
  `metano_town.rsground` sur 145 152 px (`tools/verify_duel_pixelmatch.py`).
- **Garde-fou ajouté** : `tools/verify_tile_index.py` (planches ↔ index ↔
  cartes : 541/541 cohérent).
- Détails : `docs/DIAGNOSTIC_DAMIER_DUEL_METANO_2026-08-05.md`.
- Reste non testé en jeu (validation statique uniquement).
- Rappel format : chaîne texture = nom `Sheet` → `index.idx` →
  `.tile` → PNG. Toute nouvelle planche **doit** être injectée dans
  `index.idx` ET vérifiée avec `tools/verify_tile_index.py`.

## Session 2026-08-05b — Arène Tornadus régénérée (méthode relais, patron crooked_den)

- **Problème** : `mount_windswept_guardian.rsground` utilisait la feuille 24 px
  `Mt Horn Entrance Layer 1` sur une grille 8 px → rendu cassé (détecté par
  `validate_all.py`).
- **v1 algorithmique ECARTEE** (composition depuis `mount_windswept_entrance`)
  : jugée « horrible » par l'auteur. Leçon : ne plus JAMAIS composer une salle
  algorithmiquement ; partir d'un plan officiel porté.
- **v2 RETENUE ET VALIDEE par l'auteur** : plan officiel EoS `mt_travail_peak`
  (dépôt `slothplaysnecro/PMDO-Explorers-Maps`, vendored dans
  `tools/mapgen/data/mt_travail_peak_source.png`), recadré (36,24) en 54×54
  cellules 8 px = 432×432 px, pile l'espace de la chorégraphie Lua. Sommet à
  horizon dégagé : Tornadus plane au perchoir (216,24) dans la bande ciel
  (obstacles libres là, coiffes de falaises bloquées par critère de texture).
- **Correctif** : `tools/mapgen/gen_tornadus_arene.py` clone la structure de
  `crooked_den`, régénère feuille `Mount_Windswept_Guardian_Base` + entrée
  `index.idx` mise à jour en place, obstacles (64 % marchable, positions Lua
  forcées libres, BFS entrée sud), spawners/markers repositionnés.
- **Intacts** : `AssetName`/`Name`/`Music` (`Sky Tower.ogg`), `.rsmap` de
  combat 19×19 `craggy_peak`, zone, master_zone, scripts.
- **Validation** : `validate_all.py` ✅ ; `verify_tile_index.py` 542/542.
- Détails : `docs/ARENE_TORNADUS_PATRON_CROOKED_DEN_2026-08-05.md`.
- Non testé en jeu (validation statique).

## Session 2026-08-05c — Zone de test « Arène de Tornadus » (tornadus_arena)

- **Demande** : zone de combat pour tester l'arène Tornadus en jeu, un seul
  segment fixe, sans toucher l'histoire.
- **Créée** : `Data/Zone/tornadus_arena.json` (1 segment `LoadGen` +
  `MappedRoomStep` → `mount_windswept_guardian`, patron mount_windswept
  seg 2) + entrée `index.idx` (CountedFloors 1, Maps [[0]], Grounds []) +
  `zone/tornadus_arena/init.lua` (modèle petit_tunnel, retour Metano) +
  accès test : liste `dungeons` de Metano + `UnlockDungeon` dans
  debug_tools (lignes commentées TEST).
- **Validation** : verify_zone_index --all OK ; Lua compile ; JSON round-trip.
  Les 184 FAIL pré-existants de `--all` ne sont PAS liés (purge ch6-32).
- Détails + procédure de retrait : `docs/ZONE_TEST_TORNADUS_ARENA_2026-08-05.md`.
- Non testé en jeu — c'est l'objet de la zone.

## But de ce fichier

Fichier de reprise à la racine du dépôt. À lire au début de la prochaine session, en complément de `docs/CONTEXTE_PROJET.md`.

## Prise en main effectuée

- Dépôt cloné depuis `https://github.com/meromoonmeri/new-era-abyss-to-ascension-V4.git`.
- Branche locale : `main`, alignée sur `origin/main` au commit `239525a`.
- `Mod.xml`, `patchnotes.txt`, la structure `CONVERSION/`, `Content/`, `Data/`, `Strings/`, `docs/`, `tools/` et l'historique `git log` ont été inspectés.
- Les pages wiki de référence ont été ouvertes au moins pour cadrage initial : `Floor_Generation_Overview`, `Text_Guide`, `Scripting_Cheat_Sheet`, `Script_Reference`. Pour une tâche de code/contenu précise, relire la page pertinente avant modification.
- Le fichier racine `PROJECT_CONTEXT.md` n'existait pas avant cette prise en main ; celui-ci a donc été créé conformément au protocole.

## Identité du mod vérifiée

Dans `Mod.xml` :

- `Name` : `New Era : Abyss to Ascension`
- `Namespace` : `halcyon`
- `UUID` : `CAE98609-7A96-4CFC-B5AB-0E1D41F6A1FF`
- `Version` : `0.5.1`
- `GameVersion` : `0.8.12`
- `ModType` : `Quest`

Rappel : ne pas modifier `Namespace` / UUID sans validation explicite, pour préserver la compatibilité des sauvegardes.

## Intégrité du clone local

Contrôles effectués le 2026-07-26 :

- `git status --short --branch` : propre avant création de ce fichier.
- `git ls-files -d` : aucun fichier suivi supprimé.
- `git fsck --no-progress` : aucune sortie signalant un problème.
- Fichiers suivis vs présents :
  - `Data/Ground/*.rsground` : 68 suivis, 68 présents. *(2026-07-30 : le dépôt en contient désormais **276**.)*
  - `Content/Tile/*.tile` : 248 suivis, 248 présents. *(2026-07-30 : **498**.)*
  - `Content/Music/*.ogg` : 51 suivis, 51 présents. *(2026-07-30 : **133**.)*
- Tous les gros fichiers critiques observés sont présents, notamment `Data/Ground/metano_town.rsground` (~38,3 Mo), `Content/Tile/index.idx` (~4,4 Mo), `Content/Music/Team_Dazzling.ogg`.

~~Attention : `verify_new_era.sh` est obsolète sur les compteurs exacts.~~ **RÉSOLU le 2026-07-30** : seuils resynchronisés à 276 / 498 / 133, le script passe au vert.

## Validation exécutée

- `python3 tools/validate_all.py` : OK.
  - Les 5 salles de boss Ch5 (`vast_steppe_miniboss`, `vast_steppe_guardian`, `searing_tunnel_miniboss`, `mount_windswept_miniboss`, `mount_windswept_guardian`) sont validées par le script : présence des fichiers, tilesets, cohérence obstacles, spawners/markers, positions cinématiques, connexité.
- Pas de test en jeu effectué dans cet environnement.

## État technique/narratif constaté

- Le renommage public Halcyon vers `New Era : Abyss to Ascension` est bien présent dans `Mod.xml`, mais le namespace reste `halcyon`.
- `patchnotes.txt` documente seulement les versions 0.3.0, 0.4.0 et 0.5.0 ; il n'est pas à jour avec le commit courant `Version 0.5.1` de `Mod.xml`.
- Le dossier `docs/CONTEXTE_PROJET.md` contient une mémoire longue du projet, notamment les formats `.tile`, `Content/Tile/index.idx`, l'architecture `.rsground` / `.rsmap` / `Data/Zone/*.json`, et la règle de `require` explicite des `ground/<map>/<map>_ch_N.lua`.
- L'architecture Lua réelle diffère du résumé du prompt : il n'y a pas de `newera_common.lua` ni de `newera_include.lua`. Les scripts sont sous le namespace `halcyon`.
- `Data/Script/halcyon/main.lua` charge les services `debug_tools`, `menu_tools`, `upgrade_tools`, `config_tools`.
- `Data/Script/halcyon/event.lua` charge `origin.common`, `halcyon.dungeon_event.beginner_lesson_evt`, `event_single`, `event_battle`, `event_misc`, `event_mapgen`.
- Les `ground/*/init.lua` possédant des fichiers frères `_ch_N.lua` ont été inspectés : aucun cas détecté de sibling `_ch_N.lua` sans `require` correspondant.

## Team Dazzling / Lockpin

- `CharacterEssentials.lua` contient un commentaire explicite : `Lockpin` est le nom français d'espèce de Lopunny, pas un second personnage.
- Team Dazzling utilise les codenames `Adagio` (Tsareena), `Aria` (Lopunny) et `Sonata` (Mismagius).
- `Mawile` existe séparément comme PNJ `Bria`, pas comme membre Team Dazzling.
- `docs/team_dazzling_chapter6.md` dit aussi que le nom utilisé dans les dialogues est `Team Dazzling`, pas `Les Trois Reines`.

## Zones légendaires / Grodoudou

- Le système n'est plus seulement une idée : il existe dans `Data/Script/halcyon/LegendZones.lua`, `Data/Script/halcyon/ground/metano_town/metano_town_legend.lua`, `SV.LegendZones` dans `scriptvars.lua`, et le `require` correspondant dans `metano_town/init.lua`.
- Règle actuelle : achat chez Grodoudou = accès à un lieu de revanche, pas recrutement automatique ni rencontre aléatoire.
- Une seule entrée est actuellement `ready = true` : `verdant_oath` / Zarude, déverrouillée par `SV.Chapter6.DefeatedGloomyBoss == true`, destination `gloomy_forest` segment 3.
- Les autres entrées sont des contrats d'avenir avec `ready = false` ou flags non prêts.

## Points d'attention trouvés pendant la prise en main

1. ~~`verify_new_era.sh` doit être mis à jour~~ — **fait le 2026-07-30** (276 / 498 / 133).
2. `docs/audit_critique_2026-07-26.md` dit que la branche défaite Team Dazzling est absente, mais le code courant contient `PostDefeatCutscene()` et le dispatch depuis `metano_town/init.lua`. Cet audit est donc au moins partiellement dépassé.
3. Suspicion de bug dans `metano_town_ch_6.SetupGround()` : en branche `SV.Chapter6.DefeatedByZarude`, le code appelle `GROUND:TeleportTo(hero, ...)` et `GROUND:TeleportTo(partner, ...)` sans déclarer `local hero = CH('PLAYER')` ni `local partner = CH('Teammate1')` dans cette fonction. À confirmer/corriger avant de travailler sur la branche défaite.
4. Suspicion de bug de progression Ch6 : `PostDefeatCutscene()` pose `SV.Chapter6.PostMissionScenePlayed = true`. Comme le dispatch de la scène de victoire vérifie `MissionComplete and not PostMissionScenePlayed`, cela pourrait empêcher la scène post-victoire après une défaite préalable. À confirmer en test / simulation avant correction.

## Règles opérationnelles pour la prochaine tâche

- Toujours vérifier `git status --short` et `git ls-files -d` avant tout `git add`.
- Ne pas utiliser `git add -A` / `git add .` sans contrôle explicite des suppressions.
- Pour toute affirmation technique, citer fichier + ligne.
- Le test en jeu reste requis dès que possible ; les validations statiques ne suffisent pas.

---

## Session 2026-07-26 — Priorités 1 à 3 traitées sans commit

### Pré-contrôle d'intégrité

Au début de la reprise, le répertoire avait perdu `.git` dans le snapshot local. Le dépôt a été réinitialisé avec `git init`, `git fetch origin main`, puis restauré avec `git reset --hard origin/main` avant toute modification de contenu. Après restauration :

- `Data/Ground/*.rsground` : 68 présents ;
- `Content/Tile/*.tile` : 248 présents ;
- `Content/Music/*.ogg` : 51 présents ;
- `Data/Ground/metano_town.rsground` : 38 335 570 octets ;
- `git ls-files -d` : aucun fichier suivi supprimé.

### Priorité 1.1 — Ch6 `hero` / `partner` non déclarés

Bug confirmé.

Preuve dans l'état `origin/main` : `metano_town_ch_6.SetupGround()` utilisait `GROUND:TeleportTo(hero, ...)` et `GROUND:TeleportTo(partner, ...)` dans la branche retour après défaite Zarude, mais aucune déclaration locale `hero` / `partner` n'existait dans cette fonction. Les seules déclarations de ce type étaient dans d'autres fonctions (`DazzlingIntroduction`, `PostMissionCutscene`, `PostDefeatCutscene`) et ne pouvaient pas être capturées par `SetupGround`.

Test de reproduction par exécution Lua simulée via Lupa, avec `GROUND:TeleportTo` configuré pour refuser un premier argument nil :

```text
C_ORIGIN_CONFIRMED_ERROR [string "<python>"]:9: GROUND.TeleportTo first argument is nil
```

Correction appliquée dans `Data/Script/halcyon/ground/metano_town/metano_town_ch_6.lua` :

- `local hero = CH('PLAYER')` ajouté en début de `SetupGround()` ;
- `local partner = CH('Teammate1')` ajouté juste après ;
- la branche défaite utilise maintenant ces deux valeurs locales.

Lignes actuelles : `metano_town_ch_6.lua:24-26` pour les déclarations, `metano_town_ch_6.lua:69-72` pour les deux `TeleportTo`.

Test après correction :

```text
C_FIXED_TELEPORTS [('Butterfree', 824, 816), ('Adagio', 1008, 784), ('Aria', 1040, 816), ('Sonata', 1072, 848), ('PLAYER', 792, 896), ('Teammate1', 824, 896)]
```

Conclusion : la branche se déclenche en simulation sans erreur nil et téléporte bien le héros + partenaire.

### Priorité 1.2 — Conflit de flag `PostMissionScenePlayed`

Bug confirmé.

Dans l'état `origin/main`, la séquence simulée `défaite Zarude -> PostDefeatCutscene -> nouvelle tentative victorieuse` donnait :

```text
D_ORIGIN_AFTER_DEFEAT calls= ['CALL.PostDefeatCutscene'] PostMission= True PostDefeat= True
D_ORIGIN_AFTER_RETRY_WIN calls= [] PostMission= True PostDefeat= True
```

Donc la scène de victoire était bloquée : `PostDefeatCutscene()` posait `PostMissionScenePlayed = true`, puis le dispatch de victoire ne passait plus.

Correction appliquée :

- le dispatch Ch6 dans `Data/Script/halcyon/ground/metano_town/init.lua` vérifie désormais `DefeatedByZarude and not PostDefeatScenePlayed` pour la branche défaite (`init.lua:102-105`) ;
- `PostDefeatCutscene()` vérifie désormais `PostDefeatScenePlayed` au lieu de `PostMissionScenePlayed` (`metano_town_ch_6.lua:829-832`) ;
- `PostDefeatCutscene()` ne pose plus `PostMissionScenePlayed`; elle pose seulement `PostDefeatScenePlayed = true` (`metano_town_ch_6.lua:957`).

Le contenu narratif de `PostDefeatCutscene()` n'a pas été modifié ; seule la logique de flags/dispatch a été changée.

Tests après correction :

```text
D_FIXED_AFTER_DEFEAT calls= ['CALL.PostDefeatCutscene'] PostMission= False PostDefeat= True
D_FIXED_AFTER_RETRY_WIN calls= ['CALL.PostMissionCutscene'] PostMission= True PostDefeat= True
D_FIXED_VICTORY_ONLY calls= ['CALL.PostMissionCutscene'] PostMission= True PostDefeat= False
```

Conclusion :

- défaite puis victoire : la scène défaite se joue, puis la scène victoire se joue à la réussite ultérieure ;
- victoire seule : la scène victoire continue de se jouer ;
- pas de test en jeu réel effectué, seulement simulation Lua avec stubs moteur.

### Priorité 2 — `verify_new_era.sh`

Script mis à jour :

- `EXPECTED_GROUNDS=68` (`verify_new_era.sh:13`) ;
- `EXPECTED_TILESETS=248` (`verify_new_era.sh:14`) ;
- `EXPECTED_MUSIC=51` (`verify_new_era.sh:15`) ;
- les checks `.rsground`, `.tile` et musiques comparent désormais contre ces constantes (`verify_new_era.sh:20-25`, `:56-61`, `:79-84`).

Autres compteurs inspectés :

- Lua : le script affiche 229 fichiers mais ne bloquait pas sur un seuil obsolète ;
- zones JSON : le script affiche 31 zones mais ne bloquait pas sur un seuil obsolète ;
- `.resx` : pas de compteur dédié dans ce script.

Relance après correction :

```text
✅ TOUT OK — 68 maps, 248 tilesets, 51 musiques
```

### Priorité 3 — Grodoudou / Zarude segment 3

Deux niveaux de vérification ont été exécutés.

#### Vérification statique complète

`python3 tools/verify_legend.py /home/user/new-era-abyss-to-ascension-V4` : résultat `TOUT EST VERIFIE`.

Points vérifiés par ce script :

- `Legend_Merchant` est présent sur `metano_town.rsground`, espèce `wigglytuff`, action activable, case marchable ;
- `Legend_Stand` et `Legend_Stand_Marker` existent ;
- `metano_town/init.lua` require et délègue au module `metano_town_legend.lua` ;
- `LegendZones.lua` existe ;
- toutes les clés `LZ_*` utilisées existent en EN et FR ;
- `verdant_oath` est la seule entrée `ready=true` ;
- `gloomy_forest` possède le segment 3 ;
- le segment 3 charge `verdant_oath_arena.rsmap` ;
- la map contient Zarude et `Unrecruitable = false` ;
- `zone/gloomy_forest/init.lua` gère `segmentID == 3` et appelle `LegendZones.SetDefeated('verdant_oath')`.

#### Simulation Lua du parcours boutique

Simulation via Lupa du vrai `LegendZones.lua` + `metano_town_legend.lua` avec stubs moteur :

```text
A no story unlock: buy list stays empty
  keys_contains_Verdant= False nothing= True
  spent= [] purchased= False defeated_flag= False
  enterDungeon= []

B story unlock: purchase succeeds
  keys_contains_Verdant= True nothing= False
  spent= [15000] purchased= True defeated_flag= False
  enterDungeon= []
  sounds= ['DUN_Money']
  flash= [(0, 0, 2, 6, 26)]

C owned zone: travel enters gloomy_forest segment 3
  keys_contains_Verdant= True nothing= False
  spent= [] purchased= True defeated_flag= False
  enterDungeon= [('gloomy_forest', 3, 0, 0)]

D segment 3 combat context
  segment_count= 4 mapid= verdant_oath_arena rsmap_exists= True
  map_species= ['zarude'] unrecruitable= [False]
```

Conclusion : le parcours achat puis voyage vers `gloomy_forest` segment 3 est cohérent en simulation. Le combat réel en jeu n'a pas été lancé dans cet environnement.

### Validations générales relancées

- `bash verify_new_era.sh` : OK, plus de fausse erreur de compteur.
- `python3 tools/verify_legend.py /home/user/new-era-abyss-to-ascension-V4` : OK.
- `python3 tools/validate_all.py` : OK, les 5 salles de boss Ch5 restent valides.

### État Git après cette session

Fichiers modifiés non commités :

- `Data/Script/halcyon/ground/metano_town/init.lua`
- `Data/Script/halcyon/ground/metano_town/metano_town_ch_6.lua`
- `verify_new_era.sh`

Fichier non suivi :

- `PROJECT_CONTEXT.md`

Aucun commit/push effectué.

---

## Session 2026-07-26 — Application du guide maître Team Dazzling

Guide lu : `/home/user/uploads/guide-maitre-new-era.md`.

### Décision d'application

Le guide demande une introduction officielle Team Dazzling immédiatement après `Grand Stepped` (`guide-maitre-new-era.md:103-104`). Dans le dépôt réel, aucun identifiant exact `Grand Stepped` n'existe ; l'équivalent le plus proche est `vast_steppe` / Grande Steppe. Or `vast_steppe` est intégré au chapitre 5 comme étape de l'expédition : après victoire finale, `Data/Script/halcyon/zone/vast_steppe/init.lua:100-102` route directement vers `searing_tunnel_entrance`, et `vast_steppe_guardian_ch_5.DefeatedBoss()` route aussi vers `searing_tunnel_entrance` (`Data/Script/halcyon/ground/vast_steppe_guardian/vast_steppe_guardian_ch_5.lua:239-244`).

Après clarification utilisateur, carte blanche a été donnée. Choix appliqué : ne pas casser le flux Ch5 existant ; renforcer la première scène Team Dazzling déjà chargée par l'architecture actuelle en chapitre 6, tout en appliquant les exigences qualitatives du guide : entrée célébrité, foule, thème musical, ton condescendant non maléfique, mission Chenipent comme contraste prestige/compassion.

### Changements appliqués

Fichier : `Data/Script/halcyon/ground/metano_town/metano_town_ch_6.lua`.

- Ajout d'un court temps de célébration avant l'arrivée des Dazzling : nouvelles clés `MT6_118` à `MT6_121`, jouées juste après le placement initial du héros, du partenaire et de Papilusion.
- Réorganisation locale : Papilusion ne formule sa demande qu'après l'entrée de la Team Dazzling, pour suivre le déroulé du guide : satisfaction du retour -> rumeur -> entrée Dazzling -> demande de secours.
- Ajout du thème `Team_Dazzling.ogg` dans l'introduction, avec `SOUND:FadeOutBGM(30)` puis `SOUND:PlayBGM("Team_Dazzling.ogg", true)`. Le fichier existe et `verify_new_era.sh` le vérifie.
- Réécriture des clés `MT6_003` à `MT6_006`, `MT6_015` à `MT6_017`, `MT6_042` à `MT6_047` pour coller au guide : Adagio polie et supérieure, Aria provocatrice, Sonata théâtrale, foule impressionnée.

Fichiers de texte :

- `Data/Script/halcyon/ground/metano_town/strings.resx` : valeurs EN ajustées et clés `MT6_118` à `MT6_121` ajoutées.
- `Data/Script/halcyon/ground/metano_town/strings.fr.resx` : valeurs FR ajustées et clés `MT6_118` à `MT6_121` ajoutées.

Adaptation assumée : le guide parle de Chenipotte, mais le dépôt réel a déjà `Venipede` / `Chenipent` comme personnage de mission (`CharacterEssentials.lua` et `docs/team_dazzling_chapter6.md`). La scène conserve donc Chenipent pour ne pas casser les scripts de mission existants.

### Tests effectués

- Parse XML de `strings.resx` et `strings.fr.resx` : OK.
- Simulation Lua de `metano_town_ch_6.SetupGround()` + `DazzlingIntroduction()` avec stubs moteur : OK.
  - `SV.Chapter6.DazzlingIntroPlayed` devient `true`.
  - `SV.Chapter6.MissionAvailable` devient `true`.
  - `SOUND:PlayBGM("Team_Dazzling.ogg", true)` est bien appelé.
  - Les nouvelles clés `MT6_118` à `MT6_121` sont bien lues.
- `bash verify_new_era.sh` : OK.
- `python3 tools/validate_all.py` : OK.
- `python3 tools/verify_legend.py /home/user/new-era-abyss-to-ascension-V4` : OK.

Pas de test en jeu réel effectué dans cet environnement.

### État Git

Modifications non commitées supplémentaires :

- `Data/Script/halcyon/ground/metano_town/metano_town_ch_6.lua`
- `Data/Script/halcyon/ground/metano_town/strings.resx`
- `Data/Script/halcyon/ground/metano_town/strings.fr.resx`

Les modifications précédentes restent non commitées :

- `Data/Script/halcyon/ground/metano_town/init.lua`
- `verify_new_era.sh`
- `PROJECT_CONTEXT.md` non suivi

---

## Session 2026-07-27 (agent Arena.ai) — Addendum boss Ch5 : LOT -1, 6, 7, 8

Branche : `arena/019fa547-new-era-abyss-to-ascension-v4`. PR #3.

### LOT -1 — Intégrité (vérifié AVANT toute écriture)

- `git status` propre, `git ls-files` vs disque : **aucune différence** sur `Data/Map/*.rsmap`.
- Les 6 `.rsmap` de boss présents et non vides (84 Ko à 229 Ko).
- Aucun fichier de taille nulle dans `Data/Ground` / `Data/Map`.
- **Correction d'une inexactitude de doc** : le guide maître annonce 370 `.rsmap` et 244 `.rsground`. Le dépôt contient **186 `.rsmap`** et 244 `.rsground`, et `git ls-files` en compte exactement 186 — ce n'est donc pas une perte de données mais un compteur faux dans la doc. `verify_new_era.sh` attend lui 68 `.rsground` (chiffre d'une ancienne arborescence). Ces compteurs sont à réconcilier un jour.

### LOT 1 — Positions réelles des boss (vérifiées, pas estimées)

Lues dans `MakeCharactersFromList` : Mudbray (184,232) + Stantler (152,200) ; Stantler Alpha (184,200) ; Torkoal (220,232) + Magmar (292,208) ; Magcargo (256,192) ; Gligar (180,240) + Skarmory (268,192) ; Aerodactyl (224,192).
Toutes conformes aux estimations du prompt (±8 px) **sauf** le second membre de chaque duo, plus haut/latéral que l'estimation. Positions duo/coéquipiers recalculées sur la position réelle du boss le plus bas de chaque arène.

### LOT 6.2 — Écran de résultats : bug trouvé et corrigé

`GeneralFunctions.EndDungeonRun(result, zone, structure, mapid, entryid, display, fanfare)` : c'est **`display`** qui déclenche le journal de fin de donjon.

- `vast_steppe_guardian` (Steppe → premier camp) passait `display=false, fanfare=false` → **aucun écran de résultats** avant la cinématique du camp. Corrigé en `true, true`.
- Deux autres sorties de victoire ont le même défaut mais sont **hors périmètre autorisé** : `zone/vast_steppe/init.lua:133` (ground 47) et `zone/searing_tunnel/init.lua:216` (ground 49, Crucible). Le correctif a été préparé puis **annulé** (`git checkout`) pour respecter la liste blanche. **À corriger dans une prochaine tâche autorisant `Data/Script/halcyon/zone/`.**
- Les mini-boss n'utilisent pas `EndDungeonRun` (ils restent dans la session : `EnterGroundMap` intra-zone ou `ContinueDungeon`) : pas d'écran de résultats attendu à ce stade, c'est cohérent.
- `mount_windswept_guardian` (fin de chapitre) était déjà correct (`true, true`).

### LOT 8 — Modèle Crooked Cavern + portraits

- Référence étudiée : `ground/crooked_den/crooked_den_ch_3.lua` (108 clés FR). Caméra assez **statique** (3 `MoveCamera` sur toute la scène) mais **densité et variété d'emotes très supérieures** : Angry, Crying, Joyous, Special1/2, Stunned… Écart signalé : les scènes Ch5 visent une caméra plus mobile que ce modèle ; c'est assumé et conforme à l'addendum.
- **Portraits : contrainte majeure.** `Content/Portrait/` ne contient que **34 portraits**, indexés par n° national. **Aucune espèce de boss du Ch5 n'a de portrait** : Mudbray #749, Stantler #234, Torkoal #324, Magmar #126, Gligar #207, Skarmory #227, Aerodactyl #142, Magcargo #219 — tous absents. Growlithe #58 (Hyko) et Audino #531 (Rin) également absents. Présents : starters, Zigzagoon #263 (Almotz), Tropius #357 (Penticus).
  → Conséquence : les boss **ne peuvent pas** avoir de portrait dans une boîte de dialogue. Le texte narratif les concernant est donc écrit en boîte centrée (`UI:SetCenter(true)`), comme le fait déjà le code existant. Les emotes employées sont toutes issues du jeu de Crooked Cavern (Normal, Worried, Determined, Surprised, Sad, Pain, Inspired), donc sûres.

### Durée / densité (LOT 6.1 et 8.3) — mesuré, non atteint, signalé

Estimation (12 car/s + 1,2 s par boîte, hors combats et exploration) :

| Scène | Avant | Après |
|---|---|---|
| Steppe mini-boss | 2,0 min | **3,2 min** |
| Steppe gardien | 1,8 min | **2,7 min** |
| Tunnel mini-boss | 1,9 min | **2,5 min** |
| Crucible (créateur) | 9,5 min | 9,5 min |
| Mont mini-boss | 2,0 min | **2,8 min** |
| Mont gardien | 1,8 min | **2,6 min** |
| **Total cinématiques boss** | 19,0 min | **23,3 min** |

+48 clés EN/FR ajoutées. L'objectif de 10 min par scène **n'est pas atteint** (sauf Crucible) et n'a pas été forcé : conformément à la consigne, on signale plutôt que de remplir. Le Crucible montre qu'atteindre 10 min demande ~86 boîtes et plusieurs PNJ nommés présents dans la scène — les arènes de boss n'ont que héros + partenaire + une Voix sans portrait.

**Estimation durée totale Ch5 : ~2 h 30 à 3 h 30** (36 étages procéduraux + 6 arènes + cinématiques + camp), donc **en dessous des 5 h visées**. Le levier réaliste n'est pas le dialogue de boss mais les relais (`vast_steppe_midpoint` n'a que **4 clés**) et les lots A-F de `docs/production_ch5_dialogues.md`.

---

## Session 2026-07-31 (agent Arena.ai) — arc 2, add-ons, Grodoudou, Team Dazzling

Branche `arena/019fa547`. **PR #3 toujours OUVERTE** — rien n'est mergé, rien n'est testé en jeu.

### Livré dans cette session

| Vague | Contenu |
|---|---|
| Boss ch5 | cadrage caméra, flash blanc, stats 25-32, dialogues, tag |
| Réseau des Anciens Chemins | Veilleurs (12 arènes) + ouverture des voies + 12 derniers donjons pmd-red (zones 44-55) |
| Réseau du Ciel | 67 zones EoS (`new_era_sky_00..66`), 25 Stations-Relais |
| Tunnel Ardent | fix brume + **arène mini-boss qui n'existait pas** + clan de lave développé |
| Arc 2 | `SuaireArc.lua` (5 actes) + `SuaireJobs.lua` (5 contrats de job board) |
| Grodoudou | déplacée au comptoir libre + cinématique d'arrivée |
| Team Dazzling | audit + **16 clés de dialogue non traduites** corrigées |

### Bugs réels trouvés et corrigés (pas des ajouts, des réparations)

1. **`searing_tunnel_miniboss.rsmap` était orpheline** : aucun segment ne la chargeait.
   Le combat Torkoal/Magmar n'avait donc jamais lieu, et `DefeatedBoss`/`DiedToBoss`
   étaient du code mort. Segment d'arène créé, renumérotation complète de la zone.
2. **Brume du Tunnel** : `AddMapStatus("steam")` absent, remplacé par un overlay
   ponctuel sur une carte de 416×544 → salle couverte en partie seulement.
3. **`colossus_quarry`** : `cloven_ruins` n'appelait jamais `SetDefeated`. La zone-amie
   Regigigas à 22 000 P n'était jamais marquée comme conquise. `verify_legend` passe
   maintenant à **0 échec** (contre 2 au baseline).
4. **16 clés Team Dazzling** (MT6_101..116) écrites en français dans le fichier
   **anglais** et absentes du fichier FR → le joueur FR voyait du texte non traduit sur
   toute la scène de défaite et de victoire du ch6.
5. **`TunnelMiniBossDefeated/Lost`** non déclarés dans `scriptvars`, contrairement à
   leurs 6 homologues.

### ⚠️ Risque à tester en priorité

**La renumérotation des segments de `searing_tunnel`** : avant `2=Crucible, 3=annexe`,
après `2=arène, 3=Crucible, 4=annexe`. Le moteur stocke segment+étage dans le `ZoneLoc`
de la sauvegarde. Une partie sauvegardée **à l'intérieur** du Tunnel peut pointer sur un
segment qui a changé de sens. Un `ZoneLoc` n'est pas modifiable depuis Lua : le décalage
est documenté dans `debug_tools` avec un garde `OnUpgrade`. **Sortir du donjon avant de
charger cette version.**

### État chiffré du dépôt

- **202 donjons** (12 histoire + 68 Ancrages/secondaires + 46 pmd-red + 67 EoS + 9 mazes)
- **73 ont une arène de boss** ; les 67 zones EoS et 34 des 46 pmd-red n'en ont pas
  (choix assumé des vagues : les cinématiques viendront après)
- Validation intégrale : Lua **634/634**, zones **208/208**, resx **555/555**,
  rsground **269/269**, index **209 entrées, 0 zone manquante**

### Corrections d'idées fausses de mes rapports précédents

- **Les portraits ne manquent pas.** Les 34 fichiers de `Content/Portrait/` sont des
  surcharges du mod ; le moteur PMDO fournit nativement les autres. Mes réserves sur
  Torkoal/Magmar/Suaire/Veilleurs étaient infondées.
- **`Data/Monster/` ne contient que des surcharges** (12 espèces). La liste réelle est
  dans `Data/Misc/MonsterFeature.json` (975 espèces) — c'est la source à interroger.
- **Les autotiles de donjon viennent du jeu de base**, pas du dépôt. Vérifier leur
  existence dans `Data/AutoTile/` (8 fichiers seulement) donne un faux négatif ; le bon
  critère est « déjà référencé par une zone existante ».

### Ce qui reste (par valeur décroissante)

1. **Tester en jeu.** 10 vagues de contenu non testé, c'est le vrai risque du projet.
2. Cinématiques de boss pour les 67 zones EoS et les 34 pmd-red sans arène.
3. Densité des relais ch5 : `vast_steppe_midpoint` et `mount_windswept_midpoint` n'ont
   que **4 clés** chacun, contre 42 pour `searing_tunnel_midpoint`.
4. Chapitres 11-32 : donjons et 42 cinématiques d'Ancrage prêts, **scénario non écrit**.
5. `normal_maze` déclare 38 GroundMaps (toute la ville, la guilde…) — résidu de test à
   nettoyer, sans danger immédiat mais brouille les audits.


## Audit de session 2026-07-28 — vérification des affirmations du build `2026-08-01-G` (cycle nuit + Rondoudou)

Audité sur la branche `arena/019fa547-new-era-abyss-to-ascension-v4`, commit `7773049`.
Étape 0 : `git status` propre, 0 `deleted:`, 271 `.rsground` / 497 `.tile` / 133 `.ogg` présents.

### 1. Format `.tile` + roundtrip — CONFIRMÉ
- `tools/tile_night.py` existe (7 071 o), documente le format `[u32 tileSize][u32 nb][table 16o][PNG 8×8]`.
- `python3 tools/tile_night.py --check` réexécuté : **14/14 tilesets roundtrip=OK**, « FORMAT VALIDE ».
- Vérification indépendante (script séparé) : Metano_Town_Base = 35 646 refs / 3 929 tuiles distinctes, PNG magic OK, MD5 `2dd72c6a…` conforme au commentaire du script.
- Planche `docs/apercu_tuiles_nuit.png` présente (672×236 RGB, lisible).

### 2. Carte `metano_town_nuit.rsground` — CONFIRMÉ avec 2 écarts
- Fichier présent, 38 815 146 o (non vide).
- **Écart 1** : la carte est à l'index **79** de `master_zone.json`, PAS 80 (80 = `guild_guildmasters_bedroom`). Le routage Lua (`TownNight.lua:272`, `NightWatch.lua:244`) passe par `EnterGroundMap('metano_town_nuit', …)` par nom → aucun impact fonctionnel, mais l'affirmation « index 80 » est fausse.
- Les 14 tilesets `Metano_Town_*_Night.tile` existent physiquement dans `Content/Tile/` (listés un à un).
- **Écart 2 (corrigé ce jour)** : les 14 tilesets Night étaient **absents de `Content/Tile/index.idx`** (483 entrées au lieu de 497). Régénéré via `tools/rebuild_tile_index.py` : 497 entrées, toutes les anciennes préservées bit à bit (vérifié par parsing comparatif). `Data/Zone/index.idx` contenait déjà `metano_town_nuit`.
- Obstacles nuit == jour : **True** (comparaison structurelle des deux grilles 189×189, pas des tailles).
- Musique : `Goodnight.ogg` (jour : `Treasure Town.ogg`).

### 3. `TownNight.lua` + 3 PNJ — CONFIRMÉ avec 1 nuance
- `Data/Script/halcyon/TownNight.lua` (446 l.). PNJ : `Nuit_Garde` (Veilleur de Nuit), `Nuit_Etoiles` (Compteuse d'Étoiles), `Nuit_Insomniaque` (Plume-Grise) — nicknames dans `CharacterEssentials.lua:1058-1076`.
- 4 paliers **distincts** chacun (`TownNight.LINES`, l.324-364 ; textes différents vérifiés) ; sélection par compteur `s.Met[inst]` (`Talk`, l.366).
- **Nuance** : les 12 marchands ne sont PAS retirés de la carte (les entités existent dans le `.rsground` nuit) ; ils sont masqués par `GROUND:Hide` à l'Init (`metano_town_nuit/init.lua:73-75`). Le code le documente honnêtement (l.345-352) et pose un filet : 12 handlers `*_Owner_Action` → réplique `absent(…)`.
- Commerces fermés : `Shop/Bank/Storage/Swap/TM/Tutor/Appraisal_Action` + panneaux + `Legend_Stand_Action` donnent tous du texte (l.130-344). Vérifiable en statique uniquement — non testé en jeu.

### 4. Choix de fin de journée — CONFIRMÉ avec 1 nuance
- `TownNight.StoryLocked()` : `TownNight.lua:91`. `Offer()` (l.128) : deux ChoiceMenuYesNo enchaînés → 'diner'/'dormir'/'ville'. Gating chapitre ≥ 6 (`Available`, l.122).
- **Nuance** : StoryLocked teste `MissionCompleted`, `MorningWakeup`, `MorningAddress` — mais PAS `Dinnertime`/`Bedtime` en entrée (ces deux-là sont *reposés* par `EndDay` l.192-241 pour préserver l'enchaînement d'origine). L'affirmation « teste les 4 drapeaux » est donc partiellement vraie (2/4 testés + MissionCompleted).
- Point d'insertion : PAS dans `GeneralFunctions.lua` — dans les `zone/*/init.lua` (9 zones appellent `TownNight.EndDay`/`EndDayWithEpilogue` : gloomy_forest, mount_windswept, searing_tunnel, vast_steppe, relic_forest, apricorn_grove, crooked_cavern, illuminant_riverbed, …).

### 5. Pas de système temporel parallèle — CONFIRMÉ
- `DaysPassed` : 31 usages ; `EndOfDay` : 17 ; drapeaux fin de journée : 214 usages — tous en place.
- Aucun `CurrentHour`/`TimeOfDay`/`NightMode` dans `scriptvars.lua` (grep = 0).

### 6. Rondoudou (Grodoudou) — PARTIELLEMENT CONFIRMÉ
- Entité `Legend_Merchant`, espèce `wigglytuff`, nick `Grodoudou`, **présente et visible** dans les DEUX cartes, pos **(656, 1272)** ; objet `Legend_Stand` (648,1248). Sprite : `Content/Chara/40.chara` ABSENT du dépôt (39 .chara custom seulement) → le sprite vient de l'asset pack PMDO de base, non vérifiable dans ce dépôt.
- **Position vs « Ramolos »** : ambiguïté dans la demande. Le Kecleon (Shop_Owner « Lars ») est en **(1056, 832)** → ~594 px de Grodoudou : PAS adjacent. Le vrai Ramolos/Slowpoke (Tutor_Owner « Ezalor ») est en **(1159, 1277)** → ~503 px : PAS adjacent non plus. Grodoudou est dans la **rangée des étals** avec Mido/nuzleaf **(592, 1296)** et Rhizo/lombre **(720, 1296)** (~68 px chacun) — zone commerciale cohérente, mais PAS celle de Lars/Ezalor. À trancher : le déplacer ou valider l'emplacement actuel.
- **Population du shop Kecleon** : autour de (1056,832) il n'y a que Lars et Zigs/TM_Owner (1080,832). Aucun client/passant statique dans la carte (les 12 MapChars sont tous des marchands + Hyko en 663,924) ; la vie ambiante repose sur les scripts (TownVoices…). Signalé, non « supposé normal ».
- Interaction : `metano_town_legend.lua` a une vraie mise en scène d'achat (FaceUp, PurchaseFlash, émotes) — pas un menu sec.
- **Cinématique d'introduction du stand : ELLE EXISTE** — `metano_town_legend.ArrivalScene` (`metano_town_legend.lua:215`), caméra sur le comptoir, partenaire + Grodoudou se présentent, jouée une fois après `FinishedExpedition`, branchée dans `metano_town/init.lua:2825/2832`.

### Réserve générale
Audit statique (fichiers/lignes). Aucun test en jeu dans cette sandbox.


## Correctifs test en jeu 2026-07-28 (2e passe) — Mount Windswept Entrance
- BUG 1 (sacs multiples + Yellow_Box) : BuildCampDay = 1 seul Grassy_Bag (196,224), caisse supprimee ; BuildCampMorning = sac seul, feu eteint.
- BUG 2 (Penticus sur le feu / immobile) : feu purge au matin (BuildCampMorning) + Penticus s'ecarte en (216,240) et Phileas (216,208) avant les departs (section 14).
- Cameras trop brutes + arrivee : l'expedition arrive desormais PAR LE SUD (spawn 256,588-636) et remonte la colonne x=256 en ligne droite (couloir degage : 8 pointes rocheuses taillees cols 31-32), camera en 2 glissements longs (150/110 frames). Anciennes coords heritees du Tunnel (92,176/60,136) supprimees.
- BUG 3 (carte) : agrandie 63x69 -> 63x81 (commit precedent) ; clairiere degagee ; 8 touffes Flowers_Town_3 (asset atteste au relais) posees en deco ; marker sud (256,616).
- BUG 4 (coffre) : c'est Kangaskhan_Rock (depot Kangaskhan, GeneralFunctions.Kangashkhan_Rock_Interact — callback existant, pas un bug de script). Il etait INCRUSTE dans la falaise ouest (160,144, 3 cellules sous collision). Deplace en (176,352), zone 4x4 verifiee libre, accessible.
- BUG 5 (vertige/reve invisibles) : le reve utilise desormais le patron des visions : DreamSky (Dream_Back+Dream_Front en parallaxe, les « fichiers dream qui se superposent » = leur usage prevu) + UI:WaitShowBG('Genesis_Void') par-dessus le fondu noir (comme HeroVisions), puis WaitHideBG. Le DizzyVeil du matin reste (ecran allume).
- Reste a faire (assume, non code) : tentes (aucun asset objet 'tent' dans le depot — les tentes du relais sont dans SON tileset) et ocean visible (repeinture de tiles cote sud avec DuskBeach/beach_animation, gros chantier a part). Les lits n'apparaissent QUE la nuit (DeployBeds) et disparaissent au matin : le camp est bien « demonte au reveil ».


## Chantiers complementaires 2026-07-28 (3e passe) — Mount Windswept Entrance

### Verification tentes (demande de suivi — documentee, non concluante en assets objets)
Fichiers consultes :
- Content/Object/ (29 .dir listes un a un) : AUCUN asset de tente. Seuls camp-assets : Campfire, Grassy_Bag, Hay_Bed, Yellow_Box, River_Stone_*.
- Content/Tile/ : ForestCamp/ForestCampFront/ForestCampSecret(+Front) rendus en PNG -> ce sont des tilesets de clairiere forestiere (murs de feuillage + herbe), PAS de tentes dessinees.
- CliffCamp, SnowCamp, CanyonCamp rendus -> paysages (falaises, neige, canyon+riviere). Le rendu complet de mount_windswept_midpoint (624x1152) montre falaises/riviere/pont, pas de sprites de tentes distincts.
- DumpAsset (API GitHub, 209 entrees Content/Tile) : BaseCamp/CaveStop/ForestCamp etc. examines ; BaseCamp = clairiere du camp de base RB (rendu verifie), pas de tuiles de tente isolables proprement.
Conclusion actee : pas d'asset de tente reutilisable -> le camp reste raconte par feu + sac + paillasses nocturnes (DeployBeds) ; « camp demonte au reveil » deja conforme.

### Chantier ocean (commit 174df36)
- Mer animee DuskBeach (8 frames, FrameLength 10 — patron riviere Metano) sur les rows 76-80, infranchissable (Tags=1).
- 6 pierres cotieres River_Stone_* en deco sur la greve ; marker remonte en (256,592) ; file d'arrivee remontee hors de l'eau (lua).
- Valide : luac OK, audit 0 defaut, BFS marker->feu->portail OK, rendu PNG controle. NON teste en jeu (pas d'executable dans la sandbox) : retest joueur requis.

### Rappel : retest en jeu des 5 bugs (31dce6b) + ocean (174df36) a faire par le joueur sur la save v6.


## Audit v2 transition Creuset -> Mont Venteux + crash reve (2026-07-30, build -W)

### Verdict principal : le depot etait deja correct — le jeu chargeait un master_zone.json ANCIEN
- `hero_dream` EST declare dans `Data/Zone/master_zone.json` (index 51, 86 GroundMaps) depuis `cb10d10`, appele PAR NOM (`EnterGroundMap('hero_dream','Main_Entrance_Marker',true)`), `Main_Entrance_Marker` present dans le rsground. `Data/Zone/index.idx` contient aussi hero_dream dans le resume `Grounds` de master_zone. Paire idx/json du depot coherente.
- Preuve moteur definitive (RogueEssence) : deux barriers distinctes dans `MoveToGround` — `GameManager.cs:714` `summary.GroundValid(mapname)` (resume de zone, issu de `index.idx` → `ZoneEntrySummary.Grounds`, ZoneData.cs:294) qui jette `Invalid Ground Map Name`, PUIS `GameManager.cs:730-731` `CurrentZone.GroundMaps.FindIndex` (zone data reellement chargee = master_zone.json) qui jette `Cannot find ground map of name X in zone Y`. Le log du joueur montre le 2e jet : **le resume connaissait hero_dream, la zone chargee non** → les deux fichiers du dossier de jeu n'etaient PAS de la meme version (synchro partielle de mod : index.idx/scripts recents, master_zone.json < cb10d10).
- Consequence : aucune correction JSON n'etait possible/utile cote depot ; la correction est cote INSTALLATION DU JEU (recopier l'integralite de Data/, verifier la 1re ligne du log `[NREPROBE] build 2026-08-02-W` au lancement).

### Hardening livre (build -W) — 3e garde des preflights reve
- Nouvelle fonction `zoneConnait(nom)` dans les deux preflights du reve (aller : mount_windswept_entrance_ch_5.lua ; retour : hero_dream/init.lua) : reproduction EXACTE du test de bascule (`_ZONE.CurrentZone.GroundMaps`, public, lie ; ZoneManager.CurrentZone, ZoneManager.cs:73). Si la zone EN MEMOIRE ne connait pas la destination → verdict certain → bascule refusee, repli degrade au camp, log explicite. nil = indecidable (liaison absente) → politique inchangee, on tente quand meme (anti faux negatif).
- Effet : meme si une future installation joue avec index.idx et master_zone.json desynchronises, plus JAMAIS de cascade NRE ProcessInput : le reve est saute proprement.

### Probleme "flash du creuset" avant le camp — analyse moteur
- Faits moteur : `GAME:FadeOut(false, 40)` = coroutine BLOQUANTE cote script (ScriptGame.cs Coroutine, "waits to complete"), noir garanti avant l'armement ; la couverture de fondu est GLOBALE et persistante (GameManager fadeScreen dessinee a chaque frame hors chargement, commentaire l.402) ; meme-zone = chargement synchrone (Zone.cs:319 GetGround direct) → aucune frame presentee pendant le bloc de chargement ; l'Init du camp repose `FadeOut(1)` + `CutsceneMode(true)` sans condition avant tout FadeIn. **Aucun chemin du code actuel (-S a -W) ne peut reafficher le creuset.**
- Le symptome decrit (noir -> bref retour au creuset vide -> bascule) correspond au comportement des builds ANTERIEURES a -S. Meme conclusion que le crash : la build jouee n'est pas celle du depot. Le tag [NREPROBE] tranchera.

### Lecons (formulation corrigee, remplace les versions du prompt externes)
- L15 revu : une ground map appelee par EnterGroundMap doit etre dans le GroundMaps de la zone — ET les deux fichiers temoins doivent rester synchrones : `master_zone.json` ET `index.idx` (cb10d10 a fait les deux). Le test discriminant dans un log : "Invalid Ground Map Name" = resume ignorant ; "Cannot find ground map of name X in zone Y" = resume sachant mais zone chargee vieille → synchro d'installation en cause, pas le depot.
- L16-VISUEL revu : `GAME:FadeOut` est bloquant ; l'ordre outro valide ch1-4 = `FadeOut` (noir complet) -> `CutsceneMode(false)` -> `WaitFrames(30)` -> `EnterGroundMap` en DERNIERE ligne, LA CARTE D'ARRIVEE reposant `FadeOut(1)` + `CutsceneMode(true)` dans son Init AVANT tout FadeIn. Un apercu de la carte sortante malgre ce patron = la build jouee n'est pas celle du depot (verifier [NREPROBE]).


## Uniformisation architecture donjons (2026-07-30, build -X) — 3 structures, pas une de plus

- Modele : crooked_cavern (Route procedurale RangeDictSegment + Boss en LayeredSegment LoadGen manuel + Mini-boss absent car injustifie). Reference complete : docs/AUDIT_ARCHITECTURE_DONJONS.md.
- Hors-cadre systematique trouve : segment `annexe_toupie` (LoadGen post-boss, 0 reference Lua, heritage de gabarit) dans 7 donjons sur 8.
- APPLIQUE : retrait `annexe_toupie` (dernier segment) de cloven_ruins / crystal_sanctuary / forgotten_marsh / celestial_peak + REGENERATION integrale de leurs entrees index.idx (derive detectee : Maps/Grounds perimes — classe L15) + suppression totale de `backup_master_zone` (json + idx + script, referencee nulle part ailleurs que par son propre init).
- DIFFERE (retraits prets, attendent un retest en jeu) : vast_steppe (ch4 validee, gelee), searing_tunnel + mount_windswept (ch5 en test), gloomy_forest (annexe seg6 + verdant_oath_arena seg5 — exige renumero TownRaid 7+wave -> 5+wave et gloomy_forest_boss seg 7 -> 5).
- Regle ajoutee : toute modif de segmentation d'une zone impose la regeneration de son entree index.idx (Maps = IDs d'etages, Max exclu ; Grounds = GroundMaps). Convention verifiee : zones JSON = BOM + indent=1, idx = BOM + indent=2, pas de newline finale.
- Validations post-migration : 0 bloquant (ground_registration), audits integrite 925 / bugs 12 (baselines), legend 423 OK / 0 echec. NON teste en jeu.


## Fix freeze campement (2026-07-30, build -Y)
- Cause : MoveToPosition attend l'achevement de l'action (ScriptGround.cs:491-538) ; cible bloquee (entite ou tuile) = coroutine jamais reprise = JoinCoroutines gele CutsceneMode(true). Les destinations de la REUNION (-V) tombaient a 4-14 px de Rin (222,266) / Reinier (292,276) et traversaient le foyer : scene figee, « aucun pokemon ne bouge ».
- Correctif : arrivees Shuca/Ganlon/Phileas recodees en trajets courts et droits (teleport a ~20 px sud de la destination + marche nord), degagements >=18 px verifies contre les 12 positions debout, le duo (240,300)/(272,300) et le foyer; pcall ajoute autour des marches. Aucune replique ni beat modifie.
- Regle projet ajoutee : jamais de MoveToPosition longue traversee dans une foule ; destinations a >=18 px de tout occupant ; toujours sous pcall dans une branche joignable.
- NON teste en jeu : retest requis du campement complet (reunion -> repas -> Plum -> veillee).


## Remise a l'etat d'avant (demande joueur 2026-07-30, build -Z) — ancienne scene + ancien fondu noir
- Ordre du joueur : « remets avant tes modifications, remets l'ancienne scene et le fondu noir ». Executee uniquement sur les 6 fichiers concernes.
- searing_crucible (ch5 + resx EN/FR) : restaure a c021422 (avant -S). Retour au patron d'origine : pas de replique de sortie sous crepuscule, CutsceneMode conserve actif pendant l'armement (patron hero_dream), EnterGroundMap en derniere ligne. Les cles SC5_087/088 disparaissent comme a l'origine.
- campement (ch5 + resx EN/FR) : restaure a -U (b1d5a9d, donc SANS la refonte -V reunion progressive) + inversion propre du patch -S : le dialogue d'arrivee sur le noir (MWE5_001/002) est de retour. Protections anti-crash conservees et invisibles : preflight -T/-U du reve + re-greffe du garde zoneConnait (-W), sorties garanties -U, hero_dream/init.lua et init du camp inchanges (HEAD).
- Consequence mesurable : count_dialogue ch5 repasse a 1580 (= baseline pre-V) ; audits integrite 925 / bugs 12 ; lupa OK x2 ; 158+86 cles completes EN/FR ; legend 0 echec.
- NON teste en jeu. Si la frame parasite du creuset persiste sur cette build ANCIENNE, elle ne vient pas des versions recentes de ces scripts : il faudra les lignes de log [NREPROBE] + [BossSeq]/[MWE5] pour poursuivre.


## Audit exhaustif total (2026-08-03, agent Arena.ai) — 6 domaines, mesures réelles

Passe d'audit systématique demandée (narration, code, architecture, RogueEssence, Lua,
positionnement, français). Outils du dépôt exécutés AVANT toute réécriture, conformément
à la méthode. Toute anomalie ci-dessous est adossée à un fichier + ligne.

### Intégrité de départ
`git status --short` propre, 0 `deleted:`. Comptages réels : **278 `.rsground`, 537 `.tile`,
147 `.ogg` (dont 133 dans `Content/Music`), 696 `.lua`**. `verify_new_era.sh` au vert sur ses
seuils (278/537/133). Note : `PROJECT_CONTEXT.md:38-40` annonce encore 276/498/133 — compteurs
de doc en retard d'une vague d'import, le script, lui, est à jour.

### CORRIGÉ 1 — `index.idx` : 8 grounds atteignables non déclarés (BLOQUANT)
`Data/Zone/index.idx` déclarait **88** grounds dans `master_zone.Grounds` contre **185** dans
`Data/Zone/master_zone.json` (`GroundMaps`). 8 d'entre eux n'étaient présents dans **aucun**
résumé de zone alors qu'ils sont atteignables par `EnterGroundMap` :

| ground | appelant (preuve) |
|---|---|
| `guilde_parvis` | `ground/carrefour_assemblee/init.lua:67` |
| `carrefour_sud` | `ground/carrefour_assemblee/init.lua:72` |
| `carrefour_assemblee` | `ground/bourg_comptoir/init.lua:154` |
| `cap_dents_mer` | `ground/bourg_comptoir/init.lua:144` |
| `dojo_ossatueur` | `ground/bourg_comptoir/init.lua:149` |
| `plage_lucioles` | `ground/carrefour_sud/init.lua:47` |
| `carrefour_nord` | `ground/metano_town_nuit/init.lua:112` |
| `tour_ciel_sommet` | `zone/celestial_peak/init.lua:126` |

C'est exactement le mode de crash documenté pour `hero_dream` : le moteur valide un nom de
ground contre l'index compilé (`GroundEntrySummary.Grounds.Contains`), pas contre le `.json`
→ « Invalid Ground Map Name » au transfert. Les 8 entrées ont été ajoutées, **BOM et style de
sérialisation préservés**, aucune autre zone modifiée (diff vérifié clé par clé).
`verify_ground_registration` : **9 anomalies bloquantes → 1**. La divergence restante (89
grounds) est **légitime** : ils sont indexés sous leur propre zone de donjon (ex.
`abime_tempetes` → `eaux_inexplorees`), l'outil ne compare que `master_zone`. Aucun orphelin.

### CORRIGÉ 2 — français (domaine 4.1)
- `GeneralFunctions.lua:1494` : « Congratulations! » → « Félicitations ! » (montée de grade).
- `PartnerEssentials.lua:455` : « They're my favorite! » → « C'est mon dessert préféré ! ».
- « Rank » anglais résiduel → « Rang » (`GeneralFunctions.lua:1495`, `PartnerEssentials.lua:1199`).
- **150 occurrences** de l'artefact `,[pause=N], ` dans **30 fichiers** : rendait une virgule
  doublée à l'écran (« Sans partenaire, , ils ne m'ont même pas... »). Corrigé mécaniquement en
  `,[pause=N] `, sans toucher au texte. Vérifié : 145 lignes, toutes du texte affiché.

### CORRIGÉ 3 — outillage d'audit inexécutable
`tools/audit_chapter_gaps.py`, `audit_cutscene_exit.py`, `audit_text_tags.py` contenaient
`MOD='/home/user/nea'; os.chdir(MOD)` en dur → `FileNotFoundError` immédiat. Racine désormais
déduite du script (surchargeable par `MOD_ROOT`). Les 3 outils tournent.

### Mesuré, NON corrigé (signalements, pas des bugs confirmés)

**Domaine 1.1 — cinématiques par chapitre** (catégories séparées comme exigé ; PNJ =
handler d'interaction sans `CutsceneMode`, qualitative = caméra + orientation + son) :

| Ch | Cinématiques | qualitatives | partielles | squelettes | PNJ |
|---|---|---|---|---|---|
| 1 | 44 | 37 (84 %) | 5 | 2 | 3 |
| 5 | 61 | 37 (61 %) | 24 | 0 | 43 |
| 6 | 16 | 8 (50 %) | 8 | 0 | 169 |
| 7 | 8 | 3 (38 %) | 5 | 0 | 177 |
| 8 | 6 | 2 (33 %) | 3 | 1 | 4 |
| 9 | 4 | 1 (25 %) | 3 | 0 | 9 |
| 10 | 5 | 2 (40 %) | 3 | 0 | 6 |

**Rupture de qualité confirmée aux ch8-10** : 4 à 6 cinématiques par chapitre contre 44 au ch1,
et surtout un effondrement du monde vivant. Attention : le brut de
`audit_cinematiques_par_chapitre.py` annonce 90 % de « squelettes » aux ch6-7 — c'est un
**artefact** de son seuil « ≥6 boîtes », qui classe 165 handlers de PNJ par chapitre comme
cinématiques. Ne pas agir sur ce chiffre tel quel.

**Domaine 5 — PNJ figés** (mesuré sur `ground/metano_town/strings.fr.resx`) :
ch8 = 53 PNJ / 216 clés / 0 PNJ à réplique unique ; ch9 = 53 / 194 / **8** ;
ch10 = 53 / 150 / **25** (Azumarill, Bagon, Bellossom, Butterfree, Doduo, Furret, Gloom,
Gulpin, Jigglypuff, Lickitung, Linoone, Ludicolo, Mareep, Marill, Metapod, Oddish, Roselia,
Sentret, Silcoon, Sonata, Spheal, Spinda, Venipede, WooperB, WooperG). Le ch10 est le
chapitre final de l'arc : c'est là que la ville devrait le plus réagir. Écart net ch6-7
(349/386 handlers) contre ch8-10 (54 handlers). **Signal d'alerte confirmé, contenu à écrire.**

**Domaine 1.3/1.4 — dialogues de boss** : le test décisif a été passé à l'échelle sur les
**42 arènes légendaires** : 101 répliques distinctes, **0 réplique partagée par deux boss**.
Le score 16-18/100 d'`audit_boss_cinematics` mesure la **densité de mise en scène** (2 boîtes,
1 caméra, 0 coroutine), pas l'interchangeabilité de l'écriture. La Voix (`\uE040`) : 100
occurrences, dont 88 en `SetSpeaker` = glyphe de **masquage de nom** pour locuteur inconnu, pas
la Voix. La distinction Voix / voix d'entrée générique est explicitement documentée et gardée
dans le code (`gloomy_forest_boss_ch_6.lua:16,151`, `pre_tonnerre/init.lua:125`,
`hero_dream/init.lua:132`). **Aucune confusion introduite.**

**Domaine 3.1 — collisions, vérifiées sur fichier** : 409 points d'intérêt testés sur les 278
grounds (`Dungeon_Entrance`, `Kangaskhan_Rock`, `Main_Entrance_Marker`, `North/South_Exit`,
`Boss_Marker`), emprise complète du collider + 1 case. **1 seul cas réellement enclavé** :
`luminous_spring` `South_Exit` (96,408) muré côté ouest — mais son handler
`South_Exit_Touch` est **dans un bloc commenté** (`ground/luminous_spring/init.lua:148-154`,
« Base Game functionality, commented out ») : vestige inerte du jeu de base, **pas un bug, non
corrigé**. Piège méthodologique à retenir : les sorties sont des bandes de déclenchement
(ex. 456x4 px) et la grille d'obstacles est **toujours en cases de 8 px**, indépendamment de
`TexSize` — tester la cellule du coin du collider produit ~30 faux positifs.
56 grounds ont une grille 100 % libre (dette connue, 13 arènes de boss concernées).

**Domaine 3.4 — fondus** : les 7 signalements d'`audit_fade_leaks` sont des `FadeOut` placés
dans des **branches d'erreur** (`pcall`) : filets de sécurité volontaires qui ne se déclenchent
que si le fondu nominal a échoué. Conception correcte, **rien à corriger**.

**Domaine 2.2 — échelle** : les 12 donjons d'histoire vont de 5 étages (`relic_forest`) à 44
(`celestial_peak`) ; aucun n'atteint la fourchette 30-100 du gabarit légendaire, ce qui est
cohérent avec leur rôle narratif. 4 zones dépassent 100 étages, 11 sont à 0 étage (dont 6
`*_maze` en `SingularSegment` et 3 `imbion_*` avec `Released=false`, donc non exposées).

**Domaine 4.2 — texte en dur** : ~6000 appels `WaitShowDialogue` avec littéral français hors
`STRINGS` (dont toutes les arènes légendaires). C'est un **choix d'architecture assumé du
dépôt**, pas une régression ; le signaler sans le réécrire (aucune traduction cible ne le
consomme). Après correction, **0 dialogue anglais visible** (`audit_dialogues`).

### Non vérifiable dans cet environnement — à tester manuellement
Aucun binaire RogueEssence ni Lua dans le sandbox : tout est **statique**. Restent à valider
en jeu (règle 6) : (1) l'entrée effective sur les 8 grounds réindexés — c'est le test qui
ferme le correctif 1 ; (2) le rendu des 150 dialogues reponctués ; (3) la montée de grade
(« Félicitations ! » + « Rang ») ; (4) le ressenti caméra/emote (domaines 1.5, 1.6, 3.2, 3.3)
qui ne se mesure pas sur fichier ; (5) raids, boutiques, relais et quêtes annexes — le câblage
est confirmé (`SideQuests.AllDone` conditionne la progression de chapitre,
`guild_heros_room/init.lua:157-217`) mais leur jouabilité ne l'est pas.


## Session 2026-08-13 — Smart Dungeon Designer PMDO/RogueElements

- Nouvel outil : `tools/smart_dungeon.py` et package `tools/smart_dungeon/`.
- Pipeline : analyse sémantique des assets réels, intention naturelle, progression,
  plans hiérarchiques, décoration, score multi-critères, réparations locales,
  comparaison de variantes et compilation `ZoneData` RogueElements.
- Régénération partielle : étage, salle ou décoration ; verrous persistants et seed.
- Exemple validé : `docs/smart_dungeon/example_sanctuaire/`, 12 étages,
  score moyen 87,728, minimum 81,116, 24 `FloorStairsStep` dans le ZoneData.
- Tests : `tests/test_smart_dungeon_designer.py`.
- Aucun Ground, Zone ou asset certifié n'est modifié par la génération ; la sortie
  reste dans le dossier projet choisi jusqu'à promotion explicite.

## Charte et Manifeste d'Architecture et d'Identité des Donjons (2026-08-04, agent Arena.ai)

### 1. Directive maîtresse actée (Ch6 à Ch32)
- Enregistrement officiel de la constitution dans `docs/MANIFESTE_IDENTITE_DONJONS_CH6_CH32.md`.
- **Règle absolue 1 — Zéro ground indépendant pour les boss** : De Tornadus (Ch6) au boss final (Ch32), tout affrontement de boss a lieu dans une salle de confrontation en donjon (`.rsmap` intégrée en fin de segment), adaptée au biome du donjon (tuiles, élément, météo, musique).
- **Règle absolue 2 — Identité forte et immédiatement reconnaissable** : Chaque donjon s'appuie sur une architecture, une progression, une topologie, des gimmicks environnementaux et une ambiance uniques, permettant au joueur de l'identifier en quelques secondes. Étalon qualitatif : `illuminant_riverbed` (sans jamais le copier).
- **Règle absolue 3 — Tables de Pokémon sauvages dédiées** : Interdiction du copier-coller de pools sauvages entre donjons. Chaque table est conçue sur mesure selon l'habitat, le barème de niveau du chapitre et la narration.


## Framework de Génération des Donjons Ch6 à Ch32 & Roster Ch6 (2026-08-04, agent Arena.ai)

### 1. Constitution et Inventaire Central actés
- Enregistrement du **Framework de génération (Ch6–32)** dans `docs/FRAMEWORK_GENERATION_DONJONS_CH6_CH32.md` (règle du chapitre par chapitre, 20-60 étages, points médians GitHub toutes les 5 étages, 3 mini-boss nommés, garde-fou légendaires).
- Création du **Fichier d'Inventaire Central (Source de Vérité Unique)** : `docs/inventaire_donjons.md`.

### 2. Proposition et soumission du Chapitre 6 (Étape 2 du Framework)
- Soumission du roster des 4 donjons secondaires du Chapitre 6 dans l'inventaire pour validation utilisateur :
  1. `forsaken_desert` (Désert des Oubliés, 20 ét., 2 segments, 3 mini-boss, 0 légendaire)
  2. `geode_crevice` (Crevasse de Géode, 20 ét., 2 segments, 3 mini-boss, 0 légendaire)
  3. `wild_orchard` (Verger Sauvage, 20 ét., 2 segments, 3 mini-boss, 0 légendaire)
  4. `scorched_plains` (Plaines Brûlées, 20 ét., 2 segments, 3 mini-boss, 0 légendaire)


## Automatisation des Outils & Intégration Job Board des Donjons Secondaires (2026-08-04, agent Arena.ai)

### 1. Intégrité et harmonisation en donjon (Ch6–10)
- Suppression intégrale des anciens grounds indépendants de boss obsolètes (`gloomy_forest_boss`, `crystal_sanctuary_boss`, `forgotten_marsh_boss`, `celestial_peak_boss`) au profit d'arènes en donjon (`.rsmap`).
- Harmonisation biômique des 13 arènes de boss et mini-boss Ch5–10 (`retile_all_boss_arenas.py`).
- **Enrichissement des 20 donjons secondaires (Ch6–10)** avec les mécaniques de PMDO, du Dungeon Pack et de ProjectEoN (`enrich_all_secondary_dungeons_features.py`) : pièges légers puis de statut dosés avec parcimonie, 2 à 4 Dalles Miracle (`WonderTileStep`) par étage pour soigner les baisses de statistiques, Marchand Kecleon aléatoire (`12-15%`) et Étages Café (`Café Spinda`) aux étages 10–12.

### 2. Job Board & Contrats de Guilde (`SecondaryJobs.lua`)
- Création du module `Data/Script/halcyon/SecondaryJobs.lua` consignant les **20 contrats officiels** pour les 20 donjons secondaires d'exploration des Chapitres 6 à 10.
- Câblage dans `GeneralFunctions.lua` : chaque contrat épinglé apparaît sur le **Tableau des Missions de Guilde (`Job Bulletin Board`)** aux emplacements 2 à 5 avec client/cible nommés, titre, texte d'ambiance en français idiomatique et difficulté par chapitre.

### 3. Pipeline de Conversion Musicale (`tools/music_converter.py`)
- Outil Python complet automatisant le téléchargement (`yt-dlp`), la normalisation EBU R128 et la suppression des silences (`ffmpeg` `loudnorm`/`silenceremove`), l'encodage Ogg Vorbis paramétré (`-aq 5`, `44100 Hz`) et la journalisation multithreadée.

### 4. Quêtes Secondaires PNJ de Metano Town (`SideQuests.lua`)
- Injection des **20 quêtes secondaires PNJ** dans `SideQuests.LIST` et câblage de `SideQuests.TalkGiver` / `SideQuests.TurnIn`.
- **Mécanique** : si le joueur discute avec un PNJ de Metano Town (`Sentret`, `Mawile`, `Bellossom`, `Electrike`, `Manectric`, `Meditite`, etc.), une cinématique s'exécute où le PNJ expose une urgence dans un donjon secondaire (sac de courrier volé, ami piégé, sève confisquée, etc.).
- **Enrichissement des dialogues** : chaque quête comprend de **20 à 25 lignes de dialogue au total** (`ask`, `accept`, `refuse`, `pending`, `done`), et chaque PNJ est vérifié présent dans les tournées actives de la ville (`TownLife.TOURNEES`).
- **Déblocage** : accepter la quête débloque le donjon dans `SV.ChapterProgression.UnlockedDungeons[dungeon_id] = true` et affiche un message à l'écran.
- **Récompense & Retour Automatique (`SideQuests.OnDungeonClear`)** : une fois le donjon accompli (`ResultType.Cleared`), le joueur est automatiquement téléporté **face au PNJ en ville (`metano_town`)** ou **face au Job Board de Bekipan à la guilde (`guild_second_floor`)**, déclenchant la cinématique de félicitation et de remise de prime sans transition manuelle.




## Session 2026-08-13 — Smart Dungeon Designer Phase 2

- Conception préalable : `docs/SMART_DUNGEON_PHASE2_DESIGN.md` documente l'audit
  de Phase 1, les points d'extension, les nouvelles structures et les critères de
  validation avant implémentation.
- Analyse multi-source enrichie : pixels, Grounds, couches, collisions,
  cooccurrences, zones natives, preuves, confiance, ambiguïtés, matériaux
  apparents et ponts visuels. Un asset ambigu n'est pas employé comme élément
  exceptionnel sans preuve forte ou override.
- Direction artistique procédurale : vocabulaire principal, secondaire,
  exceptionnel et de transition, fonctions de composition, budgets, quatre
  actes, axes visuels et décisions explicables dans `art_direction.json`.
- Level design hiérarchique : familles adaptables, signatures, fonctions de
  salles, régions, rythme spatial, approches de boss/relais, landmarks, courbe de
  spectacle et surprise contrôlée.
- Décoration composée : groupes transformables, respiration, mémoire locale et
  globale, budgets et raisons de placement; plus de placement indépendant comme
  logique principale.
- Qualité séparée : structure, art par étage et cohérence globale du donjon. La
  sélection privilégie admissibilité, goulot structure/visuel, identité,
  nouveauté, puis agrégat — jamais le seul score total.
- Explicabilité : `decision_log.json`, `artistic_quality_report.json`,
  `previews/design_board.svg` et commande `explain-design`.
- Démonstration Phase 2 `docs/smart_dungeon/example_sanctuaire/` : 12 étages,
  familles de composition variées, score structurel moyen 88,236 (min. 82,738),
  score visuel moyen 84,623 (min. 79,725), qualité artistique globale 89,368,
  24
  `FloorStairsStep`, validation complète réussie.
- Tests Phase 2 : 12 tests vérifient déterminisme, double validation, rejet d'un
  étage structurellement valide mais visuellement plat, différenciation de deux
  intentions avec la même bibliothèque, mémoire/budgets, scènes spéciales,
  verrous, régénérations et compilation.
- Aucun fichier de `Data/Ground`, `Content/Tile` ou `Data/Zone` n'est écrit ou
  modifié par le Smart Dungeon Designer.

## Correction 2026-08-13 — contrat des relais Smart Dungeon

- Correction utilisateur actée : un relais n'est pas une salle `refuge` dans un
  étage procédural. C'est un Ground médian entre deux `RangeDictSegment`, selon
  les références `searing_tunnel_midpoint`, `crooked_cavern_midpoint` et
  `MidpointTemplate.lua`.
- Les relais ne consomment plus d'étage. Douze étages et deux relais compilent
  maintenant trois segments 1–4, 5–8 et 9–12, avec Grounds après 4 et 8.
- Chaque `RelayPlan` impose `Kangaskhan_Rock`, `Main_Entrance_Marker`,
  `North_Exit` vers le segment suivant et `South_Exit` vers le précédent, ainsi
  que soin, stockage et sauvegarde.
- Les Grounds candidats sont clonés dans le dossier projet depuis des références
  certifiées lues sans modification. Casting et spawners hérités sont retirés;
  aucun `MissingNo` n'est présent. Provenance et SHA-256 source sont conservés.
- Sorties : `relays/grounds/`, scripts Ground/Zone candidats,
  `relays/manifest.json`, contrats de segments/relais et `previews/relays.svg`.
- Si les sheets du Ground source ne figurent pas dans le catalogue limité, le
  choix est explicitement marqué `canonical_structural_fallback_no_visual_claim`
  avec confiance 0,25; aucune compatibilité visuelle n'est inventée.
- Démonstration : deux relais validés, 3 segments, 12 étages compilés, 24
  `FloorStairsStep`; aucun Ground, script historique ou `Data/Zone` modifié.

## Session 2026-08-13 — parcours complet et Grounds intelligents (v3)

- Audit préalable documenté dans `docs/SMART_DUNGEON_COMPLETE_JOURNEY_DESIGN.md` :
  modèles Searing Tunnel, Vast Steppe ShopStep, neutres Dungeon Pack, arènes
  Vast Steppe/Searing Crucible/Mount Windswept, Grounds, maps et AutoTiles.
- `reference_knowledge.json` indexe 57 zones, 96 Grounds, 95 maps et 8 familles
  AutoTile dans la démonstration, avec provenance et SHA-256; aucune ressource
  certifiée n'est écrite.
- `dungeon_profile.json` relie biome progressif, segments, règles de chaque
  étage, ennemis pondérés/niveaux, neutres, loot sol/enterré/rare, argent,
  pièges, eau, obscurité, Monster Houses, Kecleon et salles spéciales.
- Les populations de segments voisins gardent environ 50 % de recouvrement et
  les textures partagent un vocabulaire non générique, afin d'exprimer une
  évolution du même biome plutôt que des biomes indépendants.
- Chaque étage éligible reçoit un `SpreadPlanChance` Kecleon natif distinct; le
  `ShopStep`, `ShopkeeperInteract`, `shop_security`, assortiment et prix sont
  dérivés des modèles du dépôt. Les `TeamSpawnZoneStep` sont compilés par étage.
- Les Pokémon inoffensifs utilisent le contrat natif
  `PresetMultiTeamSpawner + Ally=true + wait_only + MobSpawnInteractable`; aucun
  dialogue de biome erroné n'est copié.
- Le boss n'est plus un FloorPlan. Le dernier étage est une approche; le Ground
  final joue introduction/dialogue, `BossTransition`, segment `LayeredSegment`
  mappé sans escalier, retour victoire/défaite et conclusion scriptée. Distance
  joueur/Absol = 6 cases, arène 45×42, caméra locale, aucune sortie physique.
- Le générateur de Grounds `generate-ground` sépare géométrie abstraite et
  rendu. Démonstration `example_ground_clairiere` : 64×48, 3 lacs, navigation
  valide, 93,49 % de raccords exacts, 6,51 % de fallbacks localisés, frames et
  timings natifs conservés, aucun dézoom forcé.
- Démonstration donjon : 12 étages, 3 segments procéduraux + 1 segment boss,
  2 relais, 24 FloorStairsStep sur les seuls étages procéduraux, structure
  moyenne 88,216, visuel moyen 84,770, artistique globale 89,419, minimums
  82,738/79,725, validation complète réussie.
- Suite : 15 tests réussis, couvrant notamment tables par étage, shops natifs,
  neutres, boss ≤6, arène sans escalier, connaissances du dépôt, grammaire de
  tiles, animations, navigation, déterminisme, verrous et régénérations.
- Référence externe méthodologique : Bulbapedia Aegis Cave, consultée le
  2026-08-13, utilisée uniquement pour la forme « sections + tables par tranche
  + règles par étage », sans copie de données ni d'assets.
