# Conception des donjons à segments multiples — Progression de biome et cohérence

*Document de référence fourni par l'utilisateur (directive 2026-07-29). Il PRIME
sur les biomes inférés de `tools/mapgen/data/` : tout conflit se résout en
faveur de ce document.*

> **PORTÉE (précision utilisateur) : ces conceptions s'appliquent À PARTIR DU
> CHAPITRE 6** (Forêt Lugubre → Pic Céleste et tout donjon ultérieur). Les
> chapitres 1-5 (jusqu'au Mont Venteux inclus, le modèle) ne sont pas repris.
> Règles associées déjà données : mini-boss à 3 étages d'un relais, boss 3
> étages au-dessus du mini-boss ; les donjons gagnent 5-10 étages par chapitre.

## Principe général

Un donjon à plusieurs segments (relais) n'est pas une succession de zones interchangeables reliées par des points de passage neutres. Chaque segment doit exprimer visuellement une étape de la progression à l'intérieur du donjon — altitude, distance parcourue, dangerosité croissante, changement d'environnement logique. Le joueur doit pouvoir dire à quel moment de sa progression il se trouve rien qu'en regardant le décor, sans avoir besoin d'un indicateur de texte.

Ne jamais traiter un segment comme une simple variation cosmétique du précédent (recolorisation de tileset sans logique). Chaque changement de décor doit être justifié par la géographie et la narration du lieu.

## Progression de biome par segment — exemple de référence : Mont Windsep

Le Mont Windsep sert de modèle pour cette logique et doit être audité selon ces critères (cf. directive de revue déjà établie) :

1. **Segment de départ** — terrain verdoyant, végétation dense, ambiance encore proche de la base de la montagne. C'est le début de l'ascension, le décor doit rester accueillant.
2. **Segment intermédiaire** — après le premier relais, transition vers un environnement plus escarpé : sentier de falaise, minéral plus présent, végétation qui se raréfie, terrain plus resserré. La difficulté visuelle du terrain doit suivre la difficulté réelle du gameplay.
3. **Segment final / Ground du boss** — au sommet. Le décor doit rendre l'altitude explicite : vue dégagée, éléments rocheux dominants, ciel plus présent dans la composition, absence progressive de la végétation basse, sensation de vent ou d'exposition. Le joueur doit ressentir "je suis au sommet" avant même le combat de boss.

Cette logique de dégradé de biome (du plus dense/accueillant au plus exposé/hostile) s'applique à tout futur donjon à segments, adaptée au thème propre de chaque lieu — un donjon aquatique suivra une logique différente (surface calme → profondeur → zone abyssale, par exemple), mais le principe de nuance progressive reste identique.

## Points de relais (checkpoints)

Chaque relais doit être cohérent avec le biome du segment dans lequel il se trouve, pas avec un modèle de relais générique réutilisé tel quel partout dans le jeu.

- Le décor immédiat autour d'un point médian reflète la transition en cours : un relais entre le segment verdoyant et le segment falaise doit déjà montrer les premiers signes du changement (rochers apparaissant, végétation qui s'éclaircit), pas un copier-coller neutre.
- Les éléments fonctionnels du relais (feu de camp, zone de repos, éventuels PNJ) restent cohérents avec l'altitude et l'exposition du lieu — pas de feu de camp en plein vent exposé sans justification, pas de végétation d'accueil dense en haute altitude.
- Se référer à l'auto-questionnement du fichier de méthode général sur le positionnement et les collisions pour chaque relais (feu de camp, sacs, décor solide).

**Fonction de gameplay des relais** : chaque point médian de donjon restaure les PP et l'estomac (faim) du joueur et de son équipe. C'est une fonction systématique de tout relais, quel que soit le donjon ou le segment — à implémenter de façon cohérente sur l'ensemble des donjons à segments du projet, pas au cas par cas.

**Rencontres inoffensives** : il doit être possible de croiser, aux abords des relais ou dans certaines zones du segment, des Pokémon sauvages inoffensifs (non hostiles, sans déclenchement de combat). Cela renforce la sensation d'un biome vivant plutôt qu'un couloir de rencontres uniquement hostiles, et doit rester cohérent avec la faune logique du biome traversé (ex : un segment verdoyant en base de montagne aura une faune différente d'un segment de sommet exposé).

## Sources d'assets

Pour la construction des tilesets et décors de chaque segment, utiliser exclusivement les sources déjà validées pour ce projet (cf. Règle 7) :

- Les assets déjà présents dans le projet.
- DumpAsset (PMDODump).
- Le Trio Dungeon Pack et les autres dépôts GitHub référencés dans la bibliothèque du projet.

Ne jamais improviser un asset hors de ces sources. Si un biome nécessite un élément visuel absent de ces bibliothèques, le signaler plutôt que d'utiliser une ressource non validée.

**Principe d'exploitation maximale des outils PMDO** : au-delà des seuls assets visuels, New Era doit utiliser de la façon la plus intelligente et la plus complète possible l'ensemble des outils, systèmes et dépôts GitHub de l'écosystème PMDO (RogueEssence, RogueElements, PMDC, PMDODump, DumpAsset, tutoriels et wiki officiels, mods de référence de la bibliothèque). Pour chaque système de donjon (génération procédurale, gestion de la faim/PP, rencontres, IA des Pokémon sauvages, effets de biome), vérifier systématiquement si le moteur ou l'écosystème propose déjà une solution native ou une référence dans un mod existant avant de développer une solution maison. L'objectif est de tirer le meilleur parti de ce que le moteur permet, plutôt que de le contourner ou de sous-exploiter ses capacités.

## Fluidité des déplacements

Les déplacements à l'intérieur du donjon doivent être aussi fluides que les références internes déjà jugées satisfaisantes du projet : Illuminant Riverbed et Relic Forest. Utiliser ces deux donjons comme benchmark de fluidité de navigation — largeur des passages, absence de blocages artificiels, lisibilité du chemin, rythme de déplacement du joueur.

Avant de considérer un segment terminé, comparer concrètement sa jouabilité à ces deux références : si la navigation est plus heurtée, plus confuse ou moins fluide, le segment n'est pas terminé.

## Génération procédurale des étages

Les étages de chaque segment doivent être variés dans leur conception plutôt que répétitifs, et générés aléatoirement dans la mesure permise par le moteur (RogueElements). Utiliser les capacités de génération procédurale du moteur pour éviter la sensation de niveaux copiés-collés d'un étage à l'autre, tout en gardant :

- une variété suffisante de layouts pour qu'un joueur ne reconnaisse pas un patron répété d'étage en étage ;
- une mesure de difficulté progressive et logique à l'intérieur de la génération aléatoire — la génération procédurale ne doit jamais produire un étage plus difficile avant un étage plus facile de façon incohérente avec la progression du donjon ;
- une cohérence visuelle avec le segment/biome en cours, même quand le layout change : la génération aléatoire porte sur la structure de l'étage, pas sur le biome, qui reste déterminé par le segment.

## Cohérence avec les cinématiques

La progression de biome doit rester synchronisée avec les cutscenes qui ponctuent le donjon. Une cinématique déclenchée à un point du donjon doit se dérouler dans un décor cohérent avec le segment atteint à ce moment (pas de cutscene avec un arrière-plan de sommet alors que le joueur vient d'entrer dans le segment de départ, et inversement). Appliquer ici les règles générales de mise en scène et de transitions déjà définies (fichier de méthode général) : orientation des personnages, cadrage caméra, transitions de fondu — rien de spécifique à ajouter, seulement s'assurer que le biome affiché dans la cutscene correspond exactement à celui du segment de donjon où elle se déclenche.

## Auto-questionnement avant de valider un segment de donjon

- Le biome de ce segment est-il visuellement distinct du segment précédent et du suivant, de façon logique avec la progression (altitude, distance, danger) ?
- Le joueur peut-il déduire sa position dans la progression du donjon rien qu'en observant le décor ?
- Le point de relais reflète-t-il la transition de biome en cours, ou est-ce un modèle générique recopié sans adaptation ?
- Les assets utilisés proviennent-ils exclusivement des sources validées du projet ?
- La navigation dans ce segment est-elle aussi fluide que dans Illuminant Riverbed ou Relic Forest ? Si non, qu'est-ce qui casse le rythme ?
- La génération procédurale des étages produit-elle une variété suffisante tout en respectant une courbe de difficulté cohérente ?
- Si une cutscene se déclenche dans ce segment, son décor correspond-il exactement au biome atteint à ce point du donjon ?

Si l'une de ces questions révèle une incohérence, le segment n'est pas terminé.

---

## Annexe d'application (état d'avancement, 2026-07-30)

**Barème d'étages retenu** (« les donjons gagnent 5 à 10 étages par chapitre ») :
rampe **+5 par chapitre**, ligne de base ch6 = 21 étages procéduraux (Forêt
Lugubre inchangée). Structure cible partout : **approche → relais → 3F →
mini-boss → 3F → boss**.

| Ch | Donjon | Étages avant | Étages après | Mini-boss | Statut |
|---|---|---|---|---|---|
| 6 | Forêt Lugubre | 18+3 | 18+3+3 + OST propre (Hidden Highland.ogg, Sky) | Tengalice + Cornèbre (seg 2) | **conforme, non testé en jeu** |
| 7 | Aegis Cave | 15+5 | 20+3+3 | Kaorine + Golemastoc (seg 3) | **conforme, non testé en jeu** |
| 8 | Sanctuaire de Cristal | 12+6 | 25+3+3 | Strassie + Momartik (seg 3) | **conforme, non testé en jeu** |
| 9 | Marais de l'Oubli | 10+8 | 30+3+3 | Avaltout + Coatox (seg 3) | **conforme, non testé en jeu** |
| 10 | Pic Céleste | 8+6+4 | **35**+3+3 | Salle Fulgurée (déjà en place) | **CONFORME** |

**Mini-boss ch6-9 (build 2026-08-02-K)** — arènes créées sur le template
validé (`searing_tunnel_miniboss` : arène rsmap 15×15 autotile + ground de
cinématique) :

- `tools/make_miniboss_arenas.py` génère les rsmap (équipe de 2, Unrecruitable,
  niveaux = boss du chapitre −2) et les rsground (salle 456×456 px, ring de
  mur + plancher de l'AutoTileset du donjon, entités marker + TEAMMATE_1..3).
- Scènes **simplifiées** (directive) : arrivée + 2 répliques → Voix → flash
  blanc → apparition de chaque gardien → répliques → `COMMON.BossTransition()`
  → arène (défaite = réveil au relais, victoire = 3F vers le boss).
- Casting choisi (utilisateur a laissé le choix) : espèces vanilla assorties
  au biome et au boss du donjon, toutes déjà chargées par le moteur (les
  boss existants prouvent le chargement sans sprite mod).
- Zones restructurées : insertion du duo de segments (arène + 2e 3F) ;
  tout l'existant est décalé (verdant_oath 3→5, colossus_quarry 3→5 dans
  LegendZones, raid Metano 6-8→8-10, annexe 4→6, duel Dazzling 5→7).
- Grounds enregistrées dans `index.idx` + `master_zone.json` **À LA FIN**
  (mapIDs 82-85, aucun décalage des 82 premières cartes).
**Transitions (builds 2026-08-02-L a -N)** — audit comparatif ch1-4 vs ch5,
**ch1-4 inchangés** (validés en jeu, rétablis après un passage de correctifs
non demandés) ; c'est la transition vers le mont Venteux et le rêve qui sont
alignées sur leur rythme :

- **Transition creuset → camp (déroulé validé par le joueur, -P)** :
  dialogues → marche de sortie visible → **noir qui s'applique après la
  marche**, tenu sans trou (mode cinématique non coupé avant la bascule) →
  répliques d'accueil MWE5_001/002 **sur le noir** → le noir se lève sur le
  camp. Aucun aperçu de l'ancienne carte ne doit subsister ; si un aperçu
  persiste en jeu, le build chargé n'est pas celui du dépôt.
- **Bascules du rêve blindées (-O)** : `EnterGroundMap` vers `hero_dream`
  sous pcall avec filet (rêve sauté proprement vers le matin si la map est
  indisponible) et retour au camp protégé de même.
- **Départ vers le rêve** : `FadeOutBGM` ajouté (la musique du bivouac ne
  joue plus sur le noir) ; noir tenu des deux côtés (déjà garanti).
- Ouvertures des 10 scènes de mini-boss alignées sur le patron searing
  (noir posé avant la mise en place) + fuites de fondu en chemin d'erreur
  bouchées (`WaitFrames` après le `FadeOut` de secours).

- 4 donjons ch6+ ont un **pool de spawn sauvage vide** (constat audit) :
  les rencontres procédurales restent à remplir (chantier séparé).

Reste à faire (ordre) : (1) restauration PP/faim systématique aux relais ;
(2) rencontres inoffensives près des relais ; (3) remplir les pools de spawn
des donjons ch7+ ; (4) test en jeu des 4 mini-boss (ni la géométrie des
salles ni les cinématiques n'ont été vues en jeu à ce stade).

**Crash au coucher résolu côté scripts (build 2026-08-02-Q)** — trace joueur
du 2026-07-30 : `NullReferenceException` dans `GroundScene.ProcessInput()`,
Lua Trace vide, bloc répété en boucle. Analyse menée directement sur la
source moteur (`RogueCollab/RogueEssence`, `master`) :

- `GameManager.ScreenMainCoroutine` **nullifie `SceneOutcome` AVANT**
  d'exécuter la bascule. Si la coroutine de bascule meurt en route, la
  boucle reprend → `ProcessInput()` → `ZoneManager.Instance.CurrentGround
  .OnCheck()` ; or `Zone.SetCurrentMap` nullifie `CurrentGround` **avant**
  le chargement → NRE à chaque frame (180 frames d'erreur → arrêt du jeu).
- `GAME:EnterGroundMap` est un **itérateur C# paresseux** (`ScriptGame.cs`)
  : aucun code ne s'exécute à l'appel Lua. Aucun `pcall` Lua ne peut donc
  attraper un échec de bascule — le « filet » du build -O était illusoire.
- `DataManager.Instance.GetGround` **avale l'exception réelle, logue et
  rend `null`** : un asset absent/illisible ne lève rien, la bascule
  continue sur une carte nulle. Il écrit en revanche deux lignes de log
  décisives : `Loading rsground file: hero_dream` puis `Completed file
  load.` **ou** `Missing Data: hero_dream`.
- `ZoneEntrySummary.GroundValid(nom)` est le test d'enregistrement exact
  utilisé par `MoveToGround` — appelable depuis Lua.

Correctifs appliqués :

- **Préflight avant armement** (CampNightfall) : `GroundValid('hero_dream')`
  + `GetGround('hero_dream') ~= nil` via `_DATA`. Si refus → rêve sauté
  proprement vers le matin + ligne de log dédiée. Si le préflight lui-même
  est cassé (liaison absente), la bascule est tentée quand même
  (dégradation ouverte, jamais de faux négatif).
- **Code mort supprimé après l'armement** (ArrivalCutscene) : le bloc de
  « nettoyage » du camp (fondu, `RemoveTempChar` ×7, téléportations ×3)
  s'exécutait **pendant** la bascule, sur une carte en cours de
  destruction — et mutait une carte de toute façon rechargée de zéro à
  chaque entrée. Une bascule armée reste la dernière instruction d'une
  scène, sans exception.
- `COMMON.RespawnAllies()` passé sous `pcall` dans `hero_dream.Init`
  (il s'exécute dans la coroutine de bascule ; une erreur y serait fatale
  de la même façon — et DreamScene sait renoncer si le héros est absent).

Diagnostic en jeu désormais tranchable en trois lignes de log : le tag de
build (`[NREPROBE] build 2026-08-02-Q`), puis `Loading rsground file:
hero_dream` → `Completed file load.` ou `Missing Data: hero_dream`.
