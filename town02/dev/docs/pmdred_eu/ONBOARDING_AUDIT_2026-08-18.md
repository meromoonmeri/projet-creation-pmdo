# Audit d'onboarding — méthode PMD Red EU

**Date de l'audit :** 2026-08-18
**Branche auditée :** `arena/01a0159e-new-era-abyss-to-ascension-v4`
**HEAD :** `c95d17930d5963c0dd931157996946163ec2f8d3` (`Replace PMUniverse buildings with current client assets`)
**Statut avant audit :** arbre Git propre, aucune suppression suivie.

> Ce document est un relevé de l'état réel du checkout, pas une nouvelle
> pipeline. Il complète les autorités déjà présentes et ne les remplace pas.
> L'audit n'a modifié aucun Ground, donjon, script de production, asset,
> `RESERVE/`, index ou rapport existant. Le seul environnement ajouté pour les
> tests est `.venv/`, ignoré par Git.

## 1. Carte du dépôt effectivement présent

Le dépôt est très largement construit : **22 572 fichiers suivis**. Les
principales familles sont :

| Famille | Présence observée |
|---|---:|
| `Data/Ground/` | 428 `.rsground` |
| `Data/Map/` | 101 `.rsmap` |
| `Data/Zone/` | 57 zones JSON + index |
| `Data/Script/` | 692 Lua ; 684 sous `halcyon/` |
| `Content/Tile/` | 952 `.tile` + `index.idx` binaire (et 15 sources image auxiliaires) |
| `Content/Music/` | 142 fichiers |
| `Content/BG/` | 23 fichiers `.dir` |
| `Content/Particle/` | 13 fichiers, dont VFX composites animés |
| `Content/Object/` / `Content/Objects/` | objets `.dir` et planches VFX héritées |
| `RESERVE/` | 2 860 fichiers, dont les réserves PMD Red et Aegis |
| `docs/` | 6 918 fichiers ; `docs/pmdred_eu/` en contient 4 679 |
| `tools/` | 363 fichiers, dont les outils canoniques PMD Red, les audits, les tests et les générateurs historiques |
| `external/` | submodule `BIBLIOTHEQUE` + `BIBLIOTHEQUE_WORKSPACE` |
| `PMU_EXTRACTION/`, `PMU_ADAPTATION/`, `NO_NAME_VILLAGE_ADAPTATION/` | pipelines d'autres sources, séparées du portage PMD Red |

Les systèmes de mise en scène et VFX ne sont pas à recréer : ils existent
notamment dans `BossFX.lua`, `DonjonFX.lua`, `BossMusic.lua`, `VoiceVisions.lua`,
`HeroVisions.lua`, `RelayScenes.lua`, `RaidScenes.lua`, `TownNightScenes.lua`,
ainsi que dans `Content/BG/`, `Content/Particle/`, `Content/Object/` et
`Content/Objects/`. Les donjons procéduraux sont dans les JSON de
`Data/Zone/` et les arènes fixes dans `Data/Map/`.

## 2. Méthode canonique retrouvée

La méthode demandée est déjà implémentée par la chaîne suivante. **Cette chaîne
est la référence pour tout nouveau travail PMD Red ; les anciens convertisseurs
ne doivent pas être relancés comme méthode de production.**

### 2.1 Autorité ROM et manifeste source

- Autorité : ROM Europe `(En,Fr,De,Es,It)`, taille `33 554 432` octets,
  SHA-256 `0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd`,
  MD5 d'identité `9837da1fdfe900c52f2109d9718d4e85`.
- Outil : `tools/audit_pmdred_eu_rom.py`.
- Rapport source : `docs/pmdred_eu/ground_manifest.json`.
- Hash du manifeste suivi :
  `02a5d8699ceef50c8195fccedcd455694121983f23869070e5b42b6dfb4e9730`.
- Le manifeste actuel confirme : archive `pksdir0` de **724** ressources
  (`262 BPL`, `194 BPC`, `201 BMA`, `67 BPA`), **262** lignes de dépendances
  EU, **246** conversions Ground, **27** relations directes
  Ground→donjon et **64** octets de compteurs d'étages.
- `extraction.performed` est `false` dans l'artefact suivi : la ROM et les
  payloads normalisés restent locaux/ignorés. Cela est volontaire et ne doit
  pas être interprété comme une extraction absente de la méthode.

Le manifeste conserve les pointeurs, plages physiques, bornes des streams,
hashes physiques/sémantiques/normalisés, dépendances, couches BMA, collision,
données auxiliaires, slots BPA et comparaison régionale. La correction BPC
`0x00..0x7F` = longueur sur sept bits, `0x80..0xFF` = longueur sur six bits est
présente dans le décodeur et couverte par le test de régression `0x7F` dans
`tools/test_pmdred_eu_audit.py`.

### 2.2 Conversion graphique archive-backed

- Convertisseur de référence : `tools/convert_red_all.py` (`2.0.1-eu`).
- Validation de toutes les dépendances :
  `docs/pmdred_eu/conversion_validation.json` = **262/262**, zéro échec.
- Validation des **219** Grounds archive-backed :
  `docs/pmdred_eu/conversion_validation_v201_eu.json` et
  `docs/pmdred_eu/remaining_grounds/candidate_audit.json` = **219/219**, zéro
  échec, deux cycles locaux complets, comparaisons de tuiles/ticks et collision
  BMA indépendantes.
- Rapport d'audit 219 :
  `docs/pmdred_eu/static_audit_v201_eu.json`.
- Le corpus ancien `RESERVE/red_grounds/` / `RESERVE/red_tiles/` est une
  comparaison historique, pas l'autorité : 201 IDs se recouvrent, 18 IDs
  canoniques n'y sont pas et 17 IDs historiques n'appartiennent pas à la table
  EU canonique. Aucun remplacement US ou ancien n'est silencieux.

La voie archive-backed a franchi son propre périmètre Ground :
`docs/pmdred_eu/pmdo_validation/FINAL_AUDIT.json` documente **219/219**
Grounds graphiques validés et promus, avec **438/438** contrôles de hashes de
destination. Cette réussite reste une réussite de Ground graphique/runtime,
pas une preuve de la narration PMD Red complète.

### 2.3 Différentiel BMA indépendant

- Outil : `tools/audit_pmdred_bma_auxiliary.py`.
- Rapport : `docs/pmdred_eu/bma_auxiliary_differential.json`.
- Les **201 BMA** correspondent byte par byte à la référence indépendante ;
  **26** possèdent un bloc données/auxiliaire et **152** une couche collision.
- Les couches inconnues/auxiliaires restent séparées de la collision. Les
  tests synthétiques couvrent zéro, une ou deux couches collision, bornes de
  stream, XOR vertical, données auxiliaires et troncature.

### 2.4 Voie distincte des Grounds dungeon-backed

Cette voie ne doit pas être remplacée par un export d'image :

1. `tools/pmdred_dungeon_ground.py` — archive `pksdir0`, SIRO, AT4PX strict,
   `mapparam`, CANM, BMA terrain, CEX/EMAP, palettes GBA et rendu déterministe ;
2. `tools/reconstruct_pmdred_dungeon_grounds.py` — reconstruction des **27**
   relations et production des preuves ;
3. `tools/validate_pmdred_dungeon_ground_bundle.py` — re-dérivation
   indépendante des mappings, noms, étages, ressources, chunks, pixels,
   métadonnées d'animation et frames ;
4. `tools/test_pmdred_dungeon_ground.py` — régressions synthétiques et tests
   ROM-gated.

Preuves suivies :

- `docs/pmdred_eu/dungeon_grounds/manifest.json` : **27** mappings,
  **204/204** streams AT4PX différentiels, 11 Grounds de fin, 6 relais/midpoints
  et 10 Grounds fixes ;
- `docs/pmdred_eu/direct_ground_visual_review.md` : revue des 27 rendus et des
  **131** états stockés ;
- `docs/pmdred_eu/pmdo_validation/report.json` : **27/27 SAFE**, **131/131**
  ticks pixel-exacts, **131/131** captures opaques, 27 entrées et 26
  transitions ;
- `docs/pmdred_eu/pmdo_validation/route193_reentry.json` : réentrée du même
  Ground, sortie, nettoyage et capture **2/2** exacts.

### 2.5 Staging natif non destructif

`tools/migrate_pmdred_dungeon_grounds.py` alimente seulement
`RESERVE/pmdred_direct/`. L'état réel vérifié est :

- **27** dossiers de preuve ;
- **27** `.rsground`, **27** atlas `.tile`, métadonnées CANM, callbacks et
  preuves BMA ;
- `RESERVE/pmdred_direct/report.md` et `manifest.json` indiquent
  `non-destructive reserve staging`, zéro remplacement live, et un statut
  `staged_only` pour les 27 entrées ;
- contrôle local indépendant des chemins du manifeste : **135/135** sorties et
  hashes présents, zéro échec.

La validation correspondante est
`tools/validate_pmdred_dungeon_ground_migration.py`. Les anciens
`Data/Ground/d09p02`, `d09p03`, `d10p02`, `d10p03`, `d11p02`, `d11p03` existent
encore comme imports historiques distincts ; ils ne sont pas les candidats
`RESERVE/pmdred_direct/` et ne doivent pas être écrasés par égalité de nom.

### 2.6 Scheduler CANM

`Data/Script/halcyon/RedDirectGroundAnimation.lua` est bien le scheduler
attendu. Il possède `Start`, `Update`, `Finish`, `Cancel`, `Pause`, `Seek`,
`Resume`, `CurrentTick` et `ActiveAsset`. Il garde PAL au tick zéro, utilise
le reste entier de la cadence GBA, invalide les tâches remplacées et possède
les tests Lupa dans `tools/test_red_direct_ground_animation.py`.

### 2.7 Graphe de scripts et narration

- `tools/audit_pmdred_eu_ground_scripts.py` : 27 candidats, graphes typés,
  `ScriptRef`, racines et textes cinq langues ; rapport
  `docs/pmdred_eu/ground_scripts.json`.
- Résultats suivis : **27** graphes, **267/267** déclarations possédées,
  **5 617** commandes EU, **711** blocs de texte complets en cinq langues,
  dont 711 français ; zéro racine EU non déclarée/non possédée dans la
  validation enregistrée.
- Extension exhaustive : `tools/audit_pmdred_eu_all_ground_scripts.py` et
  `docs/pmdred_eu/narrative_audit/` inventorient **133** scènes Ground,
  **26** modules de cinématique de donjon, acteurs, positions, actions,
  caméra, VFX, audio, transitions et conflits sans les réduire à du dialogue.
- IR de donjon : `docs/canonical_journeys/PMD_RED_DUNGEON_SCENE_IR.json`
  conserve **4 967** actions de **267** tableaux ; 701 actions inconnues restent
  `UNMAPPED_PRESERVED`. Le registre d'opcodes est fail-closed et ne rend aucune
  scène routable par simple présence d'une API.

### 2.8 Barrière runtime et intégration narrative

- Fixture : `tools/build_pmdred_eu_runtime_fixture.py` ; comparaison :
  `tools/compare_pmdred_eu_pmdo_renders.py` ; terminaison :
  `tools/run_pmdred_eu_pmdo_termination_gate.py`.
- Le PMDO 0.8.12, l'exécutable et les assets officiels ne sont pas stockés dans
  le dépôt. Les preuves suivies viennent d'un environnement externe hashé.
- Le contrat d'intégration définitif est
  `docs/pmdred_eu/narrative_migration/INTEGRATION_CONTRACT.md` et
  `integration_contract.json`.
- L'état narratif réellement déclaré est **0/133 scènes complètement
  migrées**, 1 en cours/partielle (`s01`), 132 non commencées. Les modules
  `halcyon.pmdred_eu` et le quiz PMD Red sont présents pour l'isolation et les
  harnesses, mais restent dormants et ne sont pas branchés à la Nouvelle Partie.
- La régression Nouvelle Partie enregistrée est indépendante :
  `PASS_NORMAL_NEW_ERA_STARTUP_RESTORED`, avec démarrage natif New Era,
  `personality_test`, création du héros/partenaire et chapitre 1 ; elle ne vaut
  pas portage PMD Red narratif.
- `Data/Script/halcyon/pmdred_eu/CanonicalJourneyRegistry.lua` marque les
  chaînes comme `NOT_STARTED` / non `production_ready`. Le registre global
  maintient **0/27** chaînes dungeon-backed prêtes.

## 3. Ce qui est déjà construit / ce qui reste planifié

### Construit et réutilisable sans reconstruction

- Audit ROM EU, manifeste de provenance, extraction normalisée locale et
  décodeurs BPL/BPC/BMA/BPA ;
- validations 262 dépendances, 219 archive-backed et différentiel BMA ;
- reconstruction graphique séparée des 27 Grounds dungeon-backed ;
- bundle direct, atlas, métadonnées CANM, scheduler et tests de cycle de vie ;
- audit des graphes scripts EU et matrice narrative 133/26 ;
- fixtures PMDO exactes, comparateur indépendant et règles de terminaison ;
- chaîne native du donjon `cloven_ruins` / Aegis déjà intégrée dans
  `Data/Zone/cloven_ruins.json`, ses Grounds, ses `.rsmap`, scripts et
  `ClovenNDSScenes.lua`/`ClovenCanonicalChamber.lua`.

### À ne pas présenter comme terminé

- Promotion des 27 candidats `RESERVE/pmdred_direct/` ;
- musique, entrées, sorties, transitions, événements, acteurs et chorégraphie
  canoniques des 27 relations ;
- port narratif complet des 133 scènes et des 26 modules de donjon ;
- intégration de production du quiz PMD Red et de l'arc Fugitive ;
- chaînes complètes entrée → gameplay → relais → scène → combat → victoire /
  défaite / retry → retour narratif ;
- compatibilité runtime de l'installation actuelle du mod, qui n'a pas été
  retestée en jeu dans ce checkout.

### Aegis : frontière à préserver

`RESERVE/aegis_non_canonique/` est explicitement quarantainé. Les conversions
`d54…d61` issues de l'hypothèse Sky « numéro de donjon = groupe de cartes » sont
marquées non canoniques dans son README et dans `docs/PASSATION_AGENT_ARENA.md`.
Le contenu canonique est `cloven_ruins` déjà présent ; ne rien recoller depuis
la réserve non canonique.

## 4. Divergences et barrières trouvées dans ce checkout

Ces points sont signalés, pas corrigés silencieusement.

### D1 — `Content/Tile/index.idx` n'est pas synchronisé avec les promotions

Reproduction : `python3 tools/verify_tile_index.py --quiet`.

- index binaire : **735** entrées ;
- fichiers `.tile` sur disque : **952** selon le validateur ;
- **217** planches physiques absentes de l'index ;
- **217** planches référencées par les `.rsground`/`.rsmap` absentes de l'index ;
- résultat du garde-fou : **435 problèmes**, code 1.

Les 219 IDs archive-backed sont présents dans `Data/Ground/`, mais leurs
planches ne sont pas toutes accessibles via l'index de production actuel (les
nouvelles planches canoniques comptent 217 références absentes ; `h17p01` est
un alias explicite et doit rester traité selon son record). Ceci contredit
l'état « post-promotion exact PMDO index » des preuves historiques si on lit
celui-ci comme l'index actuel du dépôt. La preuve historique est à comprendre
comme fixture/index de validation de son run ; elle ne remplace pas un contrôle
sur le checkout courant.

**Action suivante obligatoire :** traiter l'index dans une tâche dédiée,
additive et authentifiée, en comparant l'ancien index byte par byte puis en
rejouant `verify_tile_index.py`. Ne pas lancer un rebuild aveugle et ne pas
modifier les Grounds pour masquer ce problème.

### D2 — Checkpoint exact-PMDO non reproductible dans l'environnement courant

`python3 tools/update_pmdred_eu_validation_progress.py --check` échoue sur
`tracked progress.json is stale` parce que les dépendances ignorées hashées
(ROM, extraction, candidats, PMDO, ANGLE/SDL, DumpAsset) ne sont pas présentes
sous `.runtime-cache/` dans ce checkout. La ROM n'est pas disponible via
`PMDRED_EU_ROM`.

Le `docs/pmdred_eu/pmdo_validation/progress.json` suivi est un checkpoint
historique (généré le 2026-08-12 sur la branche de l'agent précédent) ; ses
preuves et hashes restent des artefacts de preuve, mais il ne faut pas le
présenter comme une reproduction fraîche du run sur cette branche.

`tools/restore_pmdred_eu_validation_runtime.sh` est bien le mécanisme prévu,
mais sa garde de branche aux lignes 15–18 n'autorise que
`arena/019ff05e-new-era-abyss-to-ascension-v4` et
`arena/019ff57e-new-era-abyss-to-ascension-v4`, pas la branche fixe actuelle
`arena/01a0159e-new-era-abyss-to-ascension-v4`. Il faut traiter cette
incompatibilité explicitement avant de relancer la restauration ; ne pas
contourner la garde en changeant de branche.

### D3 — Anciennes méthodes encore présentes, mais non autoritatives

`tools/convert_pmdred_ground.py`, `tools/convert_pmdred_batch.py`,
`tools/pmdred_lib.py`, `docs/pmdred_extraction_tracabilite.md` et les imports
`RESERVE/red_*` sont conservés comme historique de méthode et inventaire. La
référence actuelle est `audit_pmdred_eu_rom.py` → extraction normalisée →
`convert_red_all.py` ou, pour les 27 relations, la voie
`pmdred_dungeon_ground.py`. Aucun nouveau portage ne doit repartir du helper
`/tmp/pmd-red` de l'ancienne voie.

### D4 — Documentation historique à dater

`docs/PASSATION_AGENT_ARENA.md` contient des états de juillet et un inventaire
ancien de 54 outils ; le dépôt actuel en contient davantage. Ses règles
méthodologiques et ses avertissements Aegis restent utiles, mais ses compteurs
ne sont pas un état des lieux PMD Red courant. Pour ce périmètre, utiliser
`docs/pmdred_eu/README.md`, ses rapports machine et le présent audit.

## 5. État des vérifications exécutées

Environnement de tests installé dans `.venv/` avec les versions épinglées de
`tools/requirements-pmdred.txt` : Pillow 12.3.0, skytemple-files 1.8.5, lupa
2.8.

| Vérification | Résultat observé |
|---|---|
| `tools/test_pmdred_eu_audit.py -v` | 10 OK, 2 skipped (ROM non définie) |
| `tools/test_convert_red_all.py -v` | 11/11 OK |
| `tools/test_pmdred_dungeon_ground.py -v` | 19 OK, 3 skipped (ROM) |
| `tools/test_pmdred_dungeon_ground_migration.py -v` | 3/3 OK |
| `tools/test_red_direct_ground_animation.py -v` | 3/3 OK |
| `tools/test_pmdred_eu_ground_scripts.py -v` | 6/6 OK |
| `tools/test_pmdred_eu_all_ground_scripts.py -v` | 3/3 OK |
| contrat/intégration, scope narratif, garde migration | 5 + 6 + 2 OK |
| comparateur/runtime PNG, terminaison, alias | 14 + 7 + 4 OK |
| quiz core/flow/input | 6 (1 skip) + 5 + 2 OK |
| `tools/verify_pmdred_eu_narrative_migration_guard.py` | PASS (`219`, `99`, `27`, `48`) |
| `tools/verify_tile_index.py --quiet` | FAIL, 435 problèmes — D1 |
| `tools/update_pmdred_eu_validation_progress.py --check` | FAIL, runtime ignoré absent — D2 |

Les tests explicitement ROM-gated, les tests du registre d'opcodes/IR nécessitant
les checkouts `pret`, RogueEssence, PDB et l'autorité décompressée, et le test
PMDO réel ne peuvent pas être rejoués sans les entrées locales verrouillées.
Aucun résultat historique n'est transformé en validation fraîche.

## 6. Règle de reprise pour l'agent suivant

1. Ne rien reconstruire parmi les éléments certifiés ci-dessus.
2. Avant toute modification, relire `docs/pmdred_eu/README.md` et ce relevé.
3. Résoudre D1/D2 dans des tâches séparées et documentées avant de présenter un
   état runtime actuel comme reproduit.
4. Pour un Ground archive-backed, partir du manifeste EU et de
   `convert_red_all.py`, jamais de `RESERVE/red_*` ou d'une ressource US.
5. Pour un Ground dungeon-backed, partir de
   `pmdred_dungeon_ground.py`/`reconstruct...`/`validate...`, puis garder le
   résultat sous `RESERVE/pmdred_direct/`.
6. Pour la narration, respecter le contrat d'intégration et le prochain travail
   enregistré : audit ciblé Gloomy Forest = Sinister Woods, sans toucher aux
   chapitres 1–5, aux 219 Grounds certifiés ni aux 27 routes historiques.
7. Une promotion ne peut être annoncée qu'après preuve indépendante de la
   géométrie, des scripts, des événements, de la musique, des transitions et du
   runtime — un chargement réussi ou un rendu seul ne suffit pas.

**Conclusion :** la méthode canonique PMD Red EU est retrouvée, reproductible
sur le papier, et largement matérialisée dans les outils et les rapports du
dépôt. Le périmètre graphique archive-backed est avancé et les preuves directes
sont conservées. Le port narratif et les 27 chaînes dungeon-backed restent
explicitement incomplets ; D1 et D2 sont les deux barrières techniques courantes
à ne pas masquer.
