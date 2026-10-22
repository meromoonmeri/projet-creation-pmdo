# Plan de migration narratif ordonné

Ce plan commence **après validation humaine de l’audit**. Il n’autorise aucune modification in-game pendant la phase actuelle.

## Principes non négociables

1. Les chapitres 1–5 New Era restent byte-identiques.
2. Les 219 Grounds archive-backed restent byte-identiques après le chantier narratif.
3. Les 27 relations dungeon-backed conservent leur registre et leur gate propres.
4. La ROM EU est l’autorité de contenu ; pret n’est jamais utilisé comme source de texte français ou de bytes régionaux.
5. La campagne PMD Red et la continuité New Era ont des namespaces, flags et points d’entrée séparés.
6. Une scène ne passe que si **texte, acteurs, spatial, chorégraphie, caméra, VFX, audio, timing, transitions et logique** passent ensemble.

## Phase 0 — Gel et baselines

**Livrables :**

- manifestes SHA-256 des 99 fichiers chapitres 1–5 ;
- manifeste des 219 destinations Ground/tile certifiées ;
- manifeste des routes, scripts, flags et aliases New Era existants ;
- tests refusant toute dérive de ces baselines.

**Gate :** aucune migration si un fichier protégé ou un Ground certifié change.

## Phase 1 — Fermer l’autorité EU

### 1A. Graphes Ground

- étendre le décodeur aux sept graphes narratifs divergents : `t01p01`, `b01p01a`, `a05p02`, `d06p01`, `d07p02`, `d12p01`, `d13p01` ;
- décoder le chemin générique `gFunctionScriptTable` des 57 Friend Areas ;
- obtenir pour les 133 stations : graphes, tableaux, opcodes, arguments, textes FR, branches, positions, liens et hashes sans erreur.

### 1B. Cinématiques de donjon

- extraire depuis la ROM EU les 25 modules spécialisés et le moteur commun ;
- récupérer textes FR, flags de quête, acteurs, battle transitions et retours ;
- relier chaque module à son dungeon ID, son Ground et ses états victoire/défaite.

### 1C. Présentation globale

- auditer `intro`, test de personnalité, titre, carte du monde, écrans société/santé ;
- inventorier les transitions hors Ground qui participent à la narration.

**Gate :** zéro bloc français, branche, opcode ou racine de commande sans propriétaire.

## Phase 2 — IR de scène PMD Red

Créer un format intermédiaire immutable et diffable, une entrée par branche de scène :

- acteur/role/source entity ;
- position `(x, y, demi-tuile)`, direction, visibilité et animation initiales ;
- timeline d’actions ordonnée ;
- waypoints, vitesse et animation de déplacement ;
- cues et dépendances entre coroutines ;
- portrait, pose, réaction, rotation ;
- caméra, VFX, palette/flash/fade ;
- BGM, fanfare, SFX et fades ;
- texte français EU et markup ;
- conditions, variants héros/partenaire, flags et résultats ;
- état final complet et transition suivante.

L’IR doit conserver les opcodes bruts inconnus au lieu de les ignorer.

**Gate :** ré-encodage/normalisation stable et simulation déterministe de toutes les branches.

## Phase 3 — Adaptateurs PMDO

Écrire des adaptateurs testés, sans encore connecter les routes de jeu :

| PMD Red | Adaptation PMDO requise |
|---|---|
| `GroundLivesData` / sélections | acteurs temporaires ou persistants avec ownership explicite |
| `WALK_GRID`, `WALK_RELATIVE`, `WALK_DIRECT` | waypoints PMDO, vitesse et frame de fin exactes |
| `ROTATE_TO`, `SET_DIR_WAIT` | direction/rotation avec nombre de frames exact |
| `SELECT_ANIMATION`, poses/opcodes | table index GBA → animation PMDO validée par acteur |
| `ALERT_CUE` / `AWAIT_CUE` | scheduler multi-acteurs déterministe, sans race |
| `CAMERA_PAN` | caméra PMDO avec cadrage, durée et easing mesurés |
| flashes/fades/effects | overlays/VFX PMDO avec alpha, couche et durée exacts |
| `BGM_*`, fanfares, SFX | mapping hashé, loop/fade/timing exacts |
| `SCENARIO`, `VARIANT`, jumps | namespace de flags PMD Red et graphe de branches |
| map/dungeon/battle transitions | contrôleur transactionnel avec retour victoire/défaite |

**Gate :** tests unitaires pour chaque opcode utilisé et échec dur pour tout opcode non mappé.

## Phase 4 — Fermer les assets

1. mapper les 59 cues musicaux ;
2. mapper les SFX/fanfares et attaques élémentaires ;
3. runtime-prober les 28 acteurs explicites et le casting Ground ;
4. vérifier chaque animation et émotion de portrait ;
5. convertir/importer uniquement les assets absents, avec provenance et hash ;
6. valider particules, flashes, tremblements, attaques et effets de disparition.

**Gate :** aucune substitution « proche » ou silencieuse ; toute adaptation doit être explicitement approuvée.

## Phase 5 — Harness cinématique isolé

Créer une quest/fixture ignorée qui :

- symlink les Grounds certifiés en lecture seule ;
- injecte uniquement le script PMD Red à tester ;
- sélectionne une branche/variant déterministe ;
- journalise chaque action avec frame, acteur, position, direction, animation, caméra, VFX et audio ;
- capture les frames clés et l’état final ;
- quitte par `LoadPhase.Unload`, `NORMAL_EXIT_0`, sans processus résiduel.

**Gate par scène :** timeline attendue exacte, aucun acteur/asset manquant, positions initiales et finales exactes, transitions/reload/cleanup PASS.

## Phase 6 — Ordre de portage

Le portage se fait d’abord en **mode replay isolé**, jamais directement dans la progression New Era.

1. **Socle global** : intro, test de personnalité, création du héros/partenaire, titres/carte.
2. **Début PMD Red** : base/ville, Petit Bois, Grotte Éclair, Mt Acier.
3. **Team Meanies et Electhor** : Bois Sinistre, Val Silencieux, Mt Foudre.
4. **Grand Canyon et arc fugitif canonique** : `a02*`, Grotte Lapis, Mt Ardent, `a03*`, Forêt Givrée, Mt Glacial, Feunard.
5. **Retour et crise** : ville/base, Team ACT, Mine Magma/Groudon.
6. **Météore et Tour Céleste** : entrée, relais, Rayquaza, conséquences et adieux.
7. **Postgame par chaînes de quête** : Kyogre, Lugia, Deoxys, Ho-Oh, Mewtwo, Regis/Mew, Jirachi, Celebi, Latios, chiens légendaires, Mankey/Medicham/Smeargle.
8. **Friend Areas** : comportements génériques, habitants et départs, séparément des cinématiques principales.
9. **Variantes régionales/spéciales** : S02/S05/S06 et ressources EU-only.

Une vague n’est connectable qu’après PASS de toutes ses scènes et dépendances dungeon-backed.

## Phase 7 — Décisions de conflit

Avant connexion au jeu, décider explicitement :

- point d’entrée de la campagne/replay PMD Red après le chapitre 5 ;
- coexistence avec `FugitiveArc` et ses 27 routes ;
- casting canonique PMD Red vs casting contemporain New Era ;
- traitement des aliases de Grounds ;
- noms affichés et localisation française ;
- politique de musique lorsqu’un master PMD Red exact n’est pas disponible ;
- états première visite, replay, retry, victoire, défaite et abandon.

Décision recommandée : **campagne canonique parallèle**, accessible après le chapitre 5 ou via un mode mémoire/replay, sans réutiliser `SV.FugitiveArc`.

## Phase 8 — Connexion progressive

Pour chaque vague :

1. créer le namespace de scripts PMD Red sans modifier l’ancien ;
2. ajouter un point d’entrée explicitement approuvé ;
3. valider première visite/replay/retry/victoire/défaite ;
4. exécuter la non-régression chapitres 1–5 et hashes Grounds ;
5. archiver preuves timeline, images, audio events, état final et terminaison ;
6. promouvoir atomiquement ;
7. attendre le gate avant la vague suivante.

## Gate final

Le port narratif est terminé uniquement lorsque :

- les 133 stations, 26 modules de donjon et présentations globales ont une disposition explicite ;
- tous les textes FR viennent de l’autorité EU ;
- toutes les branches et variants sont couverts ;
- acteurs, positions, trajectoires, timings, animations, caméras, VFX et audio sont vérifiés ;
- les 27 relations dungeon-backed sont traitées séparément ;
- les 219 Grounds et les 99 fichiers chapitres 1–5 restent byte-identiques ;
- aucun conflit n’est masqué ;
- aucun port New Era existant n’a été écrasé.
