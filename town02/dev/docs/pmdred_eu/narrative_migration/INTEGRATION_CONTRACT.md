# Contrat définitif d’intégration PMD Red EU → New Era

**Statut : décision produit autoritative pour toute la migration.**

Ce contrat complète l’audit figé dans `docs/pmdred_eu/narrative_audit/` et remplace toute recommandation antérieure incompatible, notamment l’idée d’une campagne PMD Red indépendante. L’isolation actuelle des scripts et du harness est uniquement une mesure technique de validation et de prévention des collisions ; elle ne constitue ni un second jeu, ni une seconde campagne, ni un second quiz.

## 1. Règle de restitution

La source canonique PMD Red EU commande :

- dialogues français et ordre des pages ;
- événements, conditions, branches et déclencheurs ;
- acteurs et rôles dramatiques ;
- positions, directions, déplacements, trajectoires et warps ;
- animations, poses, expressions et réactions ;
- waits, cues, synchronisation et chorégraphie ;
- caméra, cadrage et mouvements ;
- palettes, fondus, flashes, VFX et effets environnementaux ;
- BGM, jingles, SFX et leurs timings ;
- entrées, sorties, changements de Ground, transitions de donjon et combats ;
- cinématiques de donjon, rencontres, pré-combats, après-combats et états finaux.

New Era commande uniquement l’adaptation nécessaire du contexte : point de départ, continuité, casting contemporain lorsque la décision est explicite, catalogue de starters, systèmes PMDO, états de sauvegarde, intégration aux zones et progression existantes.

Une scène n’est jamais considérée comme portée si elle perd un mouvement, une pose, une attente, un effet, une réaction, une transition ou une étape logique observable de la source.

## 2. Personality Quiz : un seul système intégré

Il est interdit de créer un deuxième Personality Quiz indépendant.

Le port doit étendre le système New Era existant autour de `personality_test` :

1. conserver les introductions françaises EU, l’ordre canonique des questions Red, les réponses, embranchements, pondérations et calculs de personnalité ;
2. conserver le choix de genre, la révélation du résultat, les transitions, timings, sons, BGM, fondus et palettes Red ;
3. utiliser le Ground existant `personality_test.rsground` sans le modifier pendant ce chantier ;
4. conserver son `LayeredBG` :
   - `Dream_Back`, alpha 255, dérive X `+30`, répétition horizontale ;
   - `Dream_Front`, alpha 128, dérive X `-30`, répétition horizontale ;
   - les deux plans se déplacent en sens opposés et forment le parallaxe reconnu du quiz ;
5. utiliser les sprites, portraits, animations, genres, formes et conventions visuelles New Era pour les Pokémon montrés ;
6. transmettre le résultat canonique du quiz au sélecteur de héros New Era ;
7. ouvrir le **catalogue complet des starters actuellement disponibles dans New Era** : le résultat peut déterminer la recommandation ou la sélection mise en avant, mais ne doit jamais limiter le joueur aux starters PMD Red historiques ;
8. conserver le système actuel de création du partenaire et ses règles New Era, tout en adaptant proprement l’enchaînement canonique Red ;
9. préserver strictement la **Nouvelle Partie New Era native** : le menu titre, `CharacterSelect()`, la création du héros/partenaire et l’entrée du chapitre 1 ne doivent jamais déclencher le quiz PMD Red. Les modules Red restent dormants jusqu’à un gate narratif **post-démarrage**, explicitement défini et validé avant connexion.

Le module isolé `halcyon.pmdred_eu.scene.s01` est un harness de restitution de la séquence source. Il ne doit devenir ni une route concurrente ni un hook de Nouvelle Partie. Toute future activation du quiz devra passer par le gate post-démarrage New Era, encore inactif.

## 3. Arc Fugitive : intégré à l’histoire New Era

L’arc Fugitive PMD Red EU doit être vécu dans la continuité principale de New Era, pas dans une campagne Red parallèle.

- Le départ jouable se fait depuis **la place de Métano Town**.
- Avant connexion, le gate de progression, les personnages présents, les événements actifs, les flags, les quêtes et les routes de Métano doivent être vérifiés de manière ciblée.
- Les routes historiques `FugitiveArc` protégées ne sont jamais écrasées silencieusement.
- Le namespace technique PMD Red sert à éviter les collisions de fonctions et de flags, pas à créer une campagne séparée.
- L’orchestrateur intégré doit appartenir à la progression New Era et conduire le joueur depuis Métano vers l’arc reconstruit.
- La structure scénique Red reste l’autorité : rassemblement/départ, accusations, foule, fuite, traversées, haltes, révélations, retours et conséquences.
- Les adaptations de casting, de contexte ou de continuité sont explicitement étiquetées et ne peuvent supprimer une action canonique.

La connexion est interdite tant qu’un conflit avec les chapitres, personnages, zones, événements, sauvegardes ou routes existants n’a pas une résolution documentée et testée.

## 4. Donjons, rencontres et boss

Les donjons PMD Red ne sont pas de simples destinations Ground. Chaque chaîne comprend :

1. entrée et scène d’approche ;
2. layout/gameplay canonique lorsque disponible et déjà certifié ;
3. relais, checkpoints et transitions ;
4. événements d’étage et cinématiques in-dungeon ;
5. scène de rencontre ;
6. mise en place du combat : acteurs, placements, directions, réactions, caméra, animation, VFX, audio et timing ;
7. combat ;
8. scène de victoire, défaite, retry ou repli ;
9. sortie et retour narratif.

Feunard, Absol et chaque personnage associé à ces séquences doivent conserver leur **rôle canonique exact** : rencontre, allié, révélation, confrontation ou boss selon la source. Aucun personnage ne doit être transformé en boss — ou réduit à une apparition statique — si la source ne le fait pas.

Les 25 modules spécialisés de cinématique de donjon et le moteur commun restent un périmètre obligatoire. Les 27 relations dungeon-backed sont intégrées uniquement via leur gate séparé.

## 5. Provenance obligatoire par élément

Chaque scène, donjon et rencontre doit distinguer :

- `PMD_RED_EU_CANON` — comportement directement restitué de l’autorité EU ;
- `NEW_ERA_ADAPTATION` — changement strictement requis par le contexte ou l’architecture New Era ;
- `NEW_ERA_NATIVE` — contenu New Era conservé tel quel autour de la restitution.

Toute substitution de casting, starter, musique, asset, zone, flag ou système est enregistrée avec sa justification. Une adaptation non déclarée est un échec de migration.

## 6. Invariants intouchables

- Les **219 Grounds archive-backed** et leurs tiles restent byte-identiques.
- Les **99 fichiers chapitres 1–5** et tous les fichiers gelés dans `protected_baseline.json` restent byte-identiques.
- Les **27 routes FugitiveArc** protégées ne sont ni supprimées ni écrasées.
- Les 27 relations dungeon-backed restent suivies séparément.
- Aucun Ground n’est régénéré, reconverti ou modifié pour faire fonctionner une scène.
- La mise en scène s’adapte aux Grounds promus, jamais l’inverse.

## 7. Gate d’acceptation

Une scène ou chaîne de donjon ne passe que si la validation PMDO réelle contrôle ensemble :

- ordre complet des actions et branches ;
- acteurs, rôles, apparitions et disparitions ;
- positions/directions initiales et finales ;
- déplacements, chemins, rotations, animations et poses ;
- timings, waits, cues et synchronisation texte/action ;
- caméra, palettes, VFX et transitions ;
- BGM, SFX, jingles et fades ;
- état de sauvegarde et transition suivante ;
- première visite, replay, retry, victoire, défaite et abandon selon l’applicabilité ;
- non-régression New Era et garde des hashes protégés.

Un lancement sans erreur ne constitue pas un PASS. Une scène simplifiée ne constitue pas un port.

## 8. Ordre de réalisation révisé

1. terminer `s01` en intégrant le quiz Red au système `personality_test` New Era et à son parallaxe existant ;
2. valider le pont résultat canonique → catalogue complet des starters New Era ;
3. fermer la présentation globale et les transitions de création du héros/partenaire ;
4. définir le gate narratif New Era et l’entrée depuis la place de Métano ;
5. reconstruire l’arc Fugitive scène par scène avec ses donjons ;
6. intégrer les cinématiques de donjon et les rencontres/boss canoniques ;
7. connecter chaque vague à la progression New Era seulement après son PASS complet.
