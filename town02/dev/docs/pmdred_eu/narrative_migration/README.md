# Migration narrative PMD Red EU → New Era

La migration effective a commencé après l’audit exhaustif. `halcyon.pmdred_eu` est un namespace **technique d’isolation et de validation**, pas une campagne parallèle. La cible produit est l’intégration de PMD Red EU dans la continuité principale de New Era.

## Périmètre définitif

[`INTEGRATION_CONTRACT.md`](INTEGRATION_CONTRACT.md) et [`integration_contract.json`](integration_contract.json) sont autoritatifs. Ils remplacent les recommandations antérieures incompatibles :

- un seul Personality Quiz, intégré au système `personality_test` New Era et à son parallaxe existant ;
- questions, branches, résultat et mise en scène Red EU, puis accès au catalogue complet des starters New Era ;
- arc Fugitive intégré à l’histoire New Era, avec départ depuis la place de Métano Town ;
- donjons, cinématiques in-dungeon, rencontres et boss traités comme des chaînes complètes ;
- aucune campagne Red parallèle et aucune simplification de mise en scène.

L’isolation actuelle de `s01` reste nécessaire pour obtenir une preuve PMDO avant de connecter le quiz existant ou une route d’histoire.

## État actuel

- **Lot prioritaire :** correction critique de la Nouvelle Partie.
- **Résultat :** `PASS_NORMAL_NEW_ERA_STARTUP_RESTORED`.
- **Nouvelle Partie réelle :** menu titre → `personality_test` New Era → création héros/partenaire → `relic_forest`, chapitre 1.
- **MissingNo visible :** non.
- **Quiz ou harness PMD Red au démarrage :** non.
- **Scènes totalement migrées :** **0/133** ; `s01` reste partielle et isolée.
- **Corpus canonique du quiz :** conservé sous forme de modules dormants, sans hook de production.

Le routage direct introduit par `524e379` a été retiré. `personality_test/init.lua` est restauré octet pour octet à son état antérieur au branchement PMD Red. `Data/StartParams.xml` pointe maintenant sur l’index réel de `personality_test` (`31`) au lieu de l’ID obsolète `40`, qui résolvait vers `searing_crucible`. Les sentinelles MissingNo historiques n’ont pas été remplacées : le flux normal les consomme avant le premier état Ground observable. Voir [`startup_regression/REPORT.md`](startup_regression/REPORT.md).

## Ce qui est effectivement porté pour `s01`

1. arrêt de la musique ;
2. assertion du Ground certifié `s01`, sans modification ;
3. masquage des acteurs PMDO absents du secteur source ;
4. six blocs français exacts de la ROM EU, centrés sur fond noir ;
5. conservation de l’attente interne `#W` du sixième bloc sous forme de deux pages confirmées ;
6. nettoyage du texte ;
7. assertion du secteur d’entités canonique sans injection ;
8. lancement de `MUS_WELCOME_TO_THE_WORLD_OF_POKEMON` via l’asset PMDO hashé ;
9. arrêt dur et explicite sur la dépendance suivante.

Les textes ne proviennent pas de pret : `authority.json` conserve leur adresse et leurs bytes français EU dans l’ordre d’exécution.

## Socle canonique du Personality Quiz

`personality_quiz_fr_eu.json` associe chaque enregistrement français directement extrait de la ROM à la structure technique du commit pret verrouillé. Le rôle de chaque autorité est strictement séparé :

- **ROM PMD Red EU :** glyphes français, ponctuation, retours de ligne, attentes `#W`, changements de page `#P`, centrage et adresses ;
- **pret/pmd-red :** graphe des questions, ordre de pointeurs, catégories, valeurs de menu et effets de personnalité ;
- **New Era :** Ground `personality_test`, parallaxe, RNG enregistrable, option non binaire et catalogue complet de starters.

Le générateur refuse tout autre hash ROM ou commit pret. Il produit `pmdred_quiz_data.lua`; `pmdred_quiz_engine.lua` applique huit tirages sans réutiliser une catégorie, l’embranchement conditionnel de la question brave et le départage canonique par comparaison strictement supérieure. `pmdred_quiz_flow.lua` reste disponible pour les harnesses, mais aucun script de démarrage ne le requiert. Son futur point d’activation reste indéfini et inactif jusqu’à un gate narratif post-démarrage validé.

## Validation PMDO réelle

Les replays isolés ont été exécutés dans **PMDO 0.8.12** avec le SDL headless patché d’Agent A.

Pour le prélude `s01` :

- 55 événements de timeline contigus avec frames monotones, frontière atteinte à la frame runtime 199 ;
- six commandes de dialogue et sept pages dans l’ordre attendu, avec début, capture et fin de chaque page journalisés ;
- sept captures synchronisées du plan Ground noir, sans acteur parasite ;
- arrêt explicite sur la dépendance attendue, jamais assimilé à une réussite complète ;
- sortie native `LoadPhase.Unload`, code **0** ;
- aucun signal watchdog, SIGSEGV, kill forcé ou processus résiduel ;
- aucun `RUNTIME_FAIL`, exception Lua ou clé de texte manquante.

Pour le socle du quiz :

- 33 événements contigus couvrant le chargement des données, neuf appels RNG dont un rejet de catégorie, huit réponses, le score, l’embranchement brave et un cas de départage ;
- inventaire runtime exact de 13 personnalités, 55 questions sélectionnables, une question conditionnelle et huit questions posées ;
- deux captures 320×240 synchronisées du vrai Ground `personality_test`, séparées par 120 frames demandées ; les 76 800 pixels RGB changent sous l’effet des couches `Dream_Back` `+30` et `Dream_Front` `-30` ;
- hashes des captures reproduits lors d’un second run ; sortie native 0, sans watchdog ni processus résiduel ;
- verdict volontairement partiel `CORE_PASS_NOT_PRODUCTION_ROUTED` pour cette preuve historique du socle.

Preuves historiques du flux routé, **désormais supplantées et non actives en production** :

- le module `init.lua` suivi a été chargé et parsé par PMDO ; seule sa callback `Enter` a été neutralisée dans la copie ignorée afin que le service pilote le même `pmdred_quiz_flow.lua` ;
- **246 événements**, **46 pages texte UI réelles** et **21 prompts** sur deux tentatives complètes ;
- restart confirmé, branche `BraveQuest2B`, chemins de genre non binaire puis féminin, résultats naïf puis brave et recommandations non contraignantes Kaiminus puis Salamèche ;
- sept pages d’introduction, BGM canonique, fade-in `CMD_BYTE_22` de 30 frames, prompts partenaire/surnom, texte final, fade BGM et fade-out `CMD_BYTE_23` de 30 frames ;
- test « move, never filter » du catalogue, deux captures synchronisées, sortie native 0 et reproduction sémantique/hashes PASS ;
- verdict partiel `FLOW_PASS_PRODUCTION_ROUTED_INTERACTIVE_INPUT_PARTIAL`.

Preuve historique des inputs physiques du quiz, **conservée uniquement comme artefact de harness** :

- `DiagManager.ActiveDebugReplay` alimente le vrai runtime avec des objets `FrameInput` neutres puis `Keys.Enter` ; aucun résultat de choix n’est injecté dans `pmdred_quiz_flow.lua` ;
- **74 impulsions**, **27 pages**, **10 vrais `BeginChoiceMenu`/`ChoiceResult`** et **212 événements** ;
- les huit questions, le genre et la confirmation de recommandation sont réellement validés par le moteur de menus ; résultat naïf/garçon/Kaiminus conforme ;
- BGM, limites palette et sortie native 0 restent dans la même timeline ; reproduction sémantique PASS ;
- verdict partiel historique `PHYSICAL_CONFIRM_INPUT_PASS_LIVE_CREATION_PARTIAL`.

Pour la correction Nouvelle Partie :

- appdata vide et vrai menu titre, sans appel direct à `NewGamePlus` et sans `EnterZone` de redirection ;
- inputs physiques de langue, titre, dialogues, choix héros, direction du partenaire, genre, capacités et surnom ;
- **95 événements** ; premier Ground `personality_test`, équipe créée Bulbizarre/Héricendre, puis `relic_forest` au chapitre 1 ;
- aucun MissingNo dans l’équipe ou les acteurs observables ; aucun `SV.PersonalityTest`, texte ou événement PMD Red ;
- capture Ground finale, sortie native 0, guard protégé PASS ;
- verdict `PASS_NORMAL_NEW_ERA_STARTUP_RESTORED`.

Limite explicitée : le moteur utilise encore sa sentinelle interne MissingNo avant le chargement du premier Ground, comme avant la migration. Elle n’est jamais montrée et est consommée par le sélecteur New Era ; elle n’a volontairement pas été remplacée par un autre Pokémon.

Le transport GitHub actuel de DumpAsset n’a plus le hash gzip historique, mais son extraction possède exactement les **11 485 fichiers** et le manifeste d’arbre SHA-256 verrouillé par Agent A. Le lock suivi n’a pas été modifié.

## Garde immuable

`protected_baseline.json` gèle avant migration :

- 219 IDs Ground et leurs **438 destinations Ground/tile** certifiées ;
- les 99 fichiers explicitement protégés des chapitres 1–5 ;
- les 27 routes `FugitiveArc` et 48 fichiers d’intégration historique associés.

Commande obligatoire avant et après chaque lot :

```bash
python3 tools/verify_pmdred_eu_narrative_migration_guard.py
```

Cette commande ne régénère et ne revalide aucun Ground ; elle compare seulement les destinations promues aux hashes historiques.

Reproduction du lot PMDO, une fois l’environnement headless verrouillé présent :

```bash
bash tools/run_new_game_startup_regression.sh
```

Ce runner pilote le menu titre réel, compare la timeline et la capture, puis rejoue le guard. Les anciens runners du quiz restent des harnesses historiques : ils ne constituent plus un chemin de production. Aucun runner ne lance de convertisseur, finalizer ou promoteur Ground.

## Artefacts

- [`INTEGRATION_CONTRACT.md`](INTEGRATION_CONTRACT.md) / [`integration_contract.json`](integration_contract.json) — périmètre produit définitif ;
- [`protected_baseline.json`](protected_baseline.json) — baseline create-only ;
- [`progress.json`](progress.json) — progression machine des 133 scènes ;
- [`scenes/s01/authority.json`](scenes/s01/authority.json) — commandes, textes EU, Ground et audio ;
- [`scenes/s01/runtime/validation.json`](scenes/s01/runtime/validation.json) — verdict PMDO partiel ;
- [`scenes/s01/runtime/events.jsonl`](scenes/s01/runtime/events.jsonl) — timeline réelle ;
- [`scenes/s01/runtime/termination.json`](scenes/s01/runtime/termination.json) — terminaison native ;
- [`scenes/s01/runtime/evidence_hashes.sha256`](scenes/s01/runtime/evidence_hashes.sha256) — intégrité de la preuve `s01` ;
- [`personality_quiz_fr_eu.json`](personality_quiz_fr_eu.json) — 219 enregistrements ROM et graphe/scoring canonique ;
- [`personality_quiz/runtime_core/validation.json`](personality_quiz/runtime_core/validation.json) — verdict PMDO du socle ;
- [`personality_quiz/runtime_core/events.jsonl`](personality_quiz/runtime_core/events.jsonl) — timeline du socle ;
- [`personality_quiz/runtime_core/evidence_hashes.sha256`](personality_quiz/runtime_core/evidence_hashes.sha256) — intégrité de la preuve du socle ;
- [`personality_quiz/runtime_flow/validation.json`](personality_quiz/runtime_flow/validation.json) — verdict PMDO du flux routé ;
- [`personality_quiz/runtime_flow/events.jsonl`](personality_quiz/runtime_flow/events.jsonl) — timeline de 246 événements ;
- [`personality_quiz/runtime_flow/evidence_hashes.sha256`](personality_quiz/runtime_flow/evidence_hashes.sha256) — intégrité de la preuve du flux ;
- [`personality_quiz/runtime_input/validation.json`](personality_quiz/runtime_input/validation.json) — verdict des vrais `FrameInput` ;
- [`personality_quiz/runtime_input/events.jsonl`](personality_quiz/runtime_input/events.jsonl) — timeline physique de 212 événements ;
- [`personality_quiz/runtime_input/evidence_hashes.sha256`](personality_quiz/runtime_input/evidence_hashes.sha256) — intégrité de la preuve historique ;
- [`startup_regression/REPORT.md`](startup_regression/REPORT.md) — cause et correction avant/après ;
- [`startup_regression/runtime/validation.json`](startup_regression/runtime/validation.json) — verdict Nouvelle Partie réelle ;
- [`startup_regression/runtime/events.jsonl`](startup_regression/runtime/events.jsonl) — timeline titre → histoire ;
- [`startup_regression/runtime/evidence_hashes.sha256`](startup_regression/runtime/evidence_hashes.sha256) — intégrité de la preuve urgente ;
- [`HASHES.sha256`](HASHES.sha256) — intégrité du lot, des scripts et des autorités consommées.

## Prochaine étape obligatoire

Avec le démarrage normal restauré et les modules PMD Red dormants, reprendre l’audit ciblé de **Gloomy Forest = Sinister Woods** : vérifier les états du chapitre 6, les routes existantes et les assets Team Dazzling avant toute modification. Les chapitres 1 à 5 et les Grounds certifiés restent intouchables. Aucun quiz ou arc PMD Red ne sera reconnecté au démarrage.
