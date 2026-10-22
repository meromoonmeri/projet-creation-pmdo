# Audit intégral du périmètre narratif PMD Red EU → New Era

**Verdict : audit préalable terminé — aucune modification in-game effectuée.**

Cet audit ne considère jamais une scène comme un simple texte. Son unité de comparaison est :

> **dialogue + acteurs + positions + déplacements + trajectoires + animations + orientations + synchronisation + caméra + VFX + audio + transitions + logique événementielle**.

## 1. Autorités et périmètre

| Autorité | Identité | Usage |
|---|---|---|
| ROM PMD Red Europe `(En,Fr,De,Es,It)` | SHA-256 `0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd` | contenu régional, textes français et graphes exécutés |
| `pret/pmd-red` | commit `bf0092d0e34fd8e49b859a0b5f96f00740faa42d` | structures typées, ordre des commandes, constantes et sémantique technique |
| New Era | commit de départ `216a8e918fa8289903a1891704977d71af5e27d0` | implémentation PMDO comparée, en lecture seule |
| Grounds archive-backed | `docs/pmdred_eu/pmdo_validation/FINAL_AUDIT.json` | **219/219 certifiés, immuables pour ce chantier** |
| Relations dungeon-backed | `docs/pmdred_eu/dungeon_grounds/manifest.json` | **27 dépendances séparées**, jamais confondues avec les 219 Grounds |

Inventaire couvert :

- **133** graphes/scènes Ground ayant une déclaration station PMD Red et une identité EU ;
- **26** modules C de cinématique de donjon, moteur commun inclus ;
- **47 513** appels de macros dans les stations source ;
- **3 661** tableaux de commandes ordonnés ;
- **684** fichiers Lua New Era inventoriés et hashés ;
- **99** fichiers explicitement rattachés aux chapitres 1–5 et placés sous protection stricte ;
- **59** identités musicales PMD Red et **28** acteurs explicites des cinématiques de donjon inventoriés.

Les séquences ordonnées, arguments de mouvements, attentes, cues, animations, caméras, VFX, audio et transitions sont conservés sans texte sous copyright dans `source_action_index.json`. Les positions initiales des entités et les liens de Ground sont dans `narrative_scope.json`.

## 2. Résultat global

**Aucune scène New Era ne dispose aujourd’hui d’une preuve complète de fidélité narrative PMD Red EU.**

Aucune scène ne peut donc être classée globalement `CONSERVÉ` pour son exécution narrative. Les occurrences `CONSERVÉ` de la matrice désignent uniquement des domaines individuellement absents des deux côtés ou des dépendances déjà validées — jamais une certification de scène complète.

| Domaine | PMD Red source | New Era exécuté | Conclusion |
|---|---:|---:|---|
| Dialogues/choix | 5 040 | 2 526 appels | `ADAPTÉ` + contenu français largement `PORTÉ` |
| Acteurs/sélections | 830 | 60 | `PORTÉ` |
| Déplacements/trajectoires | 755 | 83 | `PORTÉ` + `ADAPTÉ` |
| Animations/poses | 3 194 | 3 | `PORTÉ` |
| Orientations/rotations | 1 998 | 1 | `PORTÉ` |
| Caméras | 55 | 27 | `PORTÉ` + `ADAPTÉ` |
| Portraits/expressions | 1 558 | 59 | `PORTÉ` |
| VFX/transitions visuelles | 490 | 257 | `PORTÉ` + `ADAPTÉ`, sans preuve d’équivalence |
| Audio/BGM/fanfares | 1 391 | 414 | `PORTÉ` + `ADAPTÉ`, sans preuve d’identité ni de timing |
| Attentes/cues/synchronisation | 14 480 | 2 613 | `PORTÉ`; ordre et concurrence non restitués |
| Logique/branches/variants | 5 720 | 17 | `PORTÉ` |
| Changements de map/routes | 727 | 4 | `PORTÉ` + conflits de routage |

Ces nombres sont des **comptages structurels**, pas un score de fidélité : un seul appel PMDO ne remplace pas nécessairement une commande GBA et inversement.

## 3. Dialogues français

- Le catalogue `strings.fr.resx` déclare **4 186** clés `SCENE_*`.
- Seulement **209** ont une valeur non vide ; **3 977** sont vides.
- Les 133 modules de scène exécutent **2 448** références de clés, mais **aucune de ces références exécutées ne pointe actuellement vers une valeur française non vide**.
- Les valeurs non vides appartiennent principalement aux IDs dont les modules sont des wrappers vers `FugitiveCinematics.lua`; ces wrappers n’utilisent pas les clés et jouent à la place des dialogues littéraux adaptés à New Era.
- Les **69** graphes EU décodés exactement contiennent **3 073** blocs français authentifiés.
- Parmi les 209 valeurs non vides du catalogue, **une seule** est textuellement identique à un bloc EU brut ; ce résultat ne constitue pas une validation sémantique.
- **7 scènes non-Friend-Area** et **57 Friend Areas** nécessitent encore un décodeur EU spécialisé avant de fermer l’inventaire français à 100 %.

Conclusion : le texte actuel est soit vide, soit une adaptation New Era, soit un placeholder. Les dialogues PMD Red français doivent être portés depuis la ROM EU avec leur ordre, leurs variantes, leurs pauses et leur attribution d’acteur.

## 4. Chorégraphie, positions et timing

Le source PMD Red contient notamment :

- **755** commandes de marche/warp ;
- **3 194** commandes d’animation/pose ;
- **1 998** rotations/orientations ;
- **14 480** attentes, attentes de cues et émissions de cues ;
- **55** panoramiques caméra explicites ;
- **490** effets ou transitions visuelles ;
- les positions initiales exactes de chaque `GroundLivesData` et les liens de sortie.

New Era contient **1 524 appels de mise en scène commentés** dans les 133 scènes EU auditées, donc non exécutés. De nombreux fichiers reproduisent la quantité approximative de dialogues mais laissent les mouvements, actions, réactions et caméras sous forme de commentaires tels que `-- GROUND:CharSetAction(...)` ou `-- CAMERA_PAN(...)`.

Les positions finales ne sont pas toujours une valeur unique : elles dépendent des branches, variantes de partenaire et chemins de commandes. `source_action_index.json` conserve les trajectoires et attentes par tableau de script. La fermeture de l’audit spatial exige un interpréteur déterministe des opcodes qui calcule, pour chaque branche :

1. position et direction initiales ;
2. chaque waypoint et vitesse ;
3. frame/tick de départ et d’arrivée ;
4. position, direction, animation et visibilité finales ;
5. état caméra/VFX/audio au même instant.

## 5. Implémentation New Era existante

- **133** modules existent sous `arc_fugitif/scene`, mais l’ensemble n’est pas le même que l’EU :
  - `s06` EU est absent → `PORTÉ` ;
  - `t01p06`, absent de la ROM EU, existe dans New Era → `CONFLIT`/variante à conserver hors matrice EU.
- **27** scènes sont activement routées dans `FugitiveArc.SEQUENCE`.
- **27** modules sont de simples wrappers vers `FugitiveCinematics.lua`.
- `FugitiveCinematics.lua` contient 29 adaptations écrites pour New Era : casting, dialogues, musiques, placements et rythme ne sont pas des restitutions 1:1.
- `FugitiveArc.Play` avance l’étape même après une exception (`pcall`) : ce comportement de tolérance est incompatible avec une reproduction fidèle et doit rester propre à l’arc New Era existant.
- Les scènes non routées sont principalement des squelettes : dialogues par clés et actions source commentées.

## 6. Classification opérationnelle

Chaque scène reçoit une et une seule **classification principale** ; les autres statuts restent des indicateurs secondaires par domaine :

| Classe principale | Scènes | Justification de décision |
|---|---:|---|
| `CONSERVÉ` | 0 | aucune preuve de fidélité scénique complète |
| `PORTÉ` | 1 | `s06` canonique EU n’a pas de module New Era |
| `ADAPTÉ` | 44 | autorité EU exacte et module présent, mais équivalence complète non démontrée |
| `CONFLIT` | 27 | route `FugitiveArc` active à protéger ; cette priorité couvre aussi 3 graphes encore dépendants du décodeur |
| `DÉPENDANCE` | 61 | module présent, mais autorité régionale EU à fermer avant décision de portage |

Total : **133/133 scènes classées une fois**. La priorité explicite est `CONFLIT` → `PORTÉ` → `DÉPENDANCE` → `ADAPTÉ`; elle empêche un même élément de recevoir plusieurs classes principales.

- **CONSERVÉ** (indicateur de préservation) : les 219 Grounds certifiés, les scripts New Era existants, les chapitres 1–5 et les variantes historiques restent inchangés ; les Grounds sont classés principalement `DÉPENDANCE` et les fichiers protégés `CONFLIT` dans les registres machine.
- **PORTÉ** : textes EU, acteurs manquants, trajectoires, rotations, animations, cues, branches, VFX, SFX, musiques et scènes absentes.
- **ADAPTÉ** : tout appel PMDO existant qui remplit une fonction comparable mais n’a pas encore prouvé son équivalence de coordonnées, timing, animation, rendu ou audio.
- **CONFLIT** : les 27 routes actives `FugitiveArc`, les 99 fichiers chapitres 1–5, le module non-EU `t01p06`, les flags/routes New Era et les adaptations de casting/dialogue à ne pas écraser.
- **DÉPENDANCE** : chaque scène dépend de son Ground certifié ; 27 scènes dépendent en plus d’une relation dungeon-backed ; 64 graphes exigent une fermeture du décodage EU ; les assets, l’audio, les VFX et l’interpréteur d’opcodes sont des gates séparés.

## 7. Livrables

- [`narrative_scope.json`](narrative_scope.json) — inventaire exhaustif, matrice par domaine, fichiers New Era, assets et dépendances ;
- [`source_action_index.json`](source_action_index.json) — ordre des actions source, arguments expurgés des textes, tableaux de commandes ;
- [`matrix.csv`](matrix.csv) et [`SCENE_MATRIX.md`](SCENE_MATRIX.md) — matrice PMD Red EU → New Era sur 133 scènes ;
- [`DUNGEON_CUTSCENES.md`](DUNGEON_CUTSCENES.md) — 26 modules de cinématique de donjon ;
- [`DEPENDENCIES.md`](DEPENDENCIES.md) — Grounds, relations dungeon-backed, systèmes et assets ;
- [`CONFLICTS.md`](CONFLICTS.md) — routes actives et périmètre intouchable ;
- [`MIGRATION_PLAN.md`](MIGRATION_PLAN.md) — ordre de migration et gates d’acceptation.

La seule étape suivante autorisée est la **fermeture des dépendances d’autorité et la validation explicite du plan**. Aucun script, Ground, route, asset ou état de jeu n’a été modifié pendant cet audit.
