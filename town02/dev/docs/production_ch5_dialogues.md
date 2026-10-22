# Production Chapitre 5 — Campagne « 7000 lignes » (Prompt Maître §3.1)

Suivi de production du quota : **7000 lignes de dialogue minimum pour le chapitre 5**.
Outil de mesure : `python3 tools/count_dialogue.py 5` (1 ligne = 1 appel `WaitShowDialogue`/`StartConversation`).

## État du compteur

| Date | Lignes ch5 | Delta | Contenu livré |
|---|---|---|---|
| 2026-07-26 (avant campagne) | 996 | — | état hérité |
| 2026-07-26 (session 1) | 1118 | +122 | Relais Steppe & Mont réécrits : cinématiques + PNJ à variantes |
| 2026-07-26 (session 2) | 1254 | +136 | Camp de base du Mont (10 PNJ × 3-4 états), vie de ville (café, maisons eau/normale, auberge, étang, dojo) |
| 2026-07-26 (session 3) | 1279 | +25 | 2 cinématiques dramatiques : « La veillée du camp » (steppe, Hyko×Almotz) et « La dernière veillée » (mont, veille du sommet) |
| 2026-07-26 (session 4) | 1351 | +72 | Système de légendes des aînés (5 légendes avec OST dédiés) + cinématique majeure « La Nuit où le Ciel a Tremblé » |
| 2026-07-26 (session 5) | 1361 (+~60 hors compteur ch5 : Grodoudou compte en « commun ») | +10 | « Les Héros d'Autrefois » (Grodoudou, hommage PMD Rescue Team/Explorers, 3 actes) + « L'Arbitre du Ciel » (Reinier, Rayquaza) |
| 2026-07-26 (session 6) | **1390** | +29 | Réseau de foreshadowing longue portée : Premier Rêve (twist arc 6 énoncé), registre des pulses de Phileas (twist Necrozma), yeux d'or (Fulgur), brume aux 3 silhouettes (Suaire) + cinématique « Ce que le vent a emporté » (secret Hyko×Penticus, sacrifice il y a 25 ans) |

## Livré en session 1

### Relais Grande Steppe (`vast_steppe_midpoint_ch_5.lua`)
- **Arrivée initiale** réécrite (8 lignes, ancrée dans le décor officiel cliff_camp).
- **Dialogues à variantes** (Prompt Maître §4.2 — arcs de 4-6 états) :
  - Partenaire : 5 variantes × 3 lignes (gardien vaincu / gardien perdu / mini-boss vaincu / mini-boss perdu / défaut).
  - Hyko (Growlithe) : 4 variantes × 3 lignes — voix « recrue réglementaire » (carnet de patrouille, manuel page 42).
  - Almotz (Zigzaton) : 4 variantes × 3 lignes — voix « famille nombreuse » (gratin de Baies Oran, huit à table).
- **CINÉMATIQUE COMIQUE : « La Berceuse de Plum »** (~35 lignes) — le modèle Rondoudou du Prompt Maître §3.2 : Plum, artiste lyrique itinérante, endort tout le camp. Comique individuel (Almotz s'endort en pleine phrase, le héros lutte, Hyko résiste « par procédure » puis s'effondre), chute tendre (Almotz parle de sa mère en dormant, Plum est touchée), retombée comique au réveil (« JE NE DORMAIS PAS ! »). Révèle : le trac de Plum (micro-intrigue réutilisable), la famille d'Almotz, la rigidité attachante de Hyko.
- Positions/états mémorisés : `SV.Chapter5.PlumSceneSeen`, repositionnement des recrues selon victoire/défaite.

### Relais Mont Venteux (`mount_windswept_midpoint_ch_5.lua`)
- **Arrivée initiale** réécrite (8 lignes, canyon_camp officiel).
- **Dialogues à variantes** : Partenaire ×5, Hyko ×4, Almotz ×4 états (même grille que la steppe, voix distinctes).
- **CINÉMATIQUE CONTEMPLATIVE : « Le Fragment tombé du ciel »** (~40 lignes) — adaptation **New Era** du motif *Minior: The Fallen Star* (source : CregALeg/minior-game-jam) :
  - pluie d'étoiles filantes (Swift_Star/Meteor_Mash_Star), l'une d'elles « grossit » et s'écrase ;
  - **Météno** (Minior, ajouté à CharacterEssentials) : ton étourdi-poétique, « on est faits pour tomber, nous autres » ;
  - il préfigure le phénomène du sommet SANS rien nommer : « une lumière qui a PEUR » — conforme à la règle ch5 (Necrozma/Abîme jamais nommés) ;
  - sème l'accroche des « amis dispersés » (arc secondaire réutilisable ch6+, façon Minior sans en reprendre l'intrigue).
- `SV.Chapter5.FragmentSceneSeen` ; scène jouée une seule fois après le mini-boss.

### Câblage
- `init.lua` des deux relais : `SetupGround()` au retour, actions Teammate1/2/3 routées vers les variantes ch5.
- `Meteno` (minior) ajouté à `CharacterEssentials.characters`.

## Adaptation Minior → New Era : règles retenues

Conformément au document de réadaptation fourni (§10) et à la directive multi-sources :
- **AUCUN import brut** de la trame Minior : on n'en reprend que des **motifs** (chute d'étoile, personnage tombé du ciel, vœu murmuré) réinterprétés dans le lore Anima.
- Le Météno du Mont Venteux est un **témoin**, pas un protagoniste : sa « lumière qui a peur » est le phénomène du sommet ch5 (cohérence : `SawSummitPhenomenon`).
- La mythologie « Fil du Destin / il y a 20 ans » (§10.1bis) est **réservée** pour l'arc Jirachi déjà planifié (Grotte du Vœu, palier 7 du plan d'assignation — Jirachi = origine des Anima). La fiche boss Jirachi dans `docs/fiches_boss.md` référence ce motif.
- Les dialogues traduits du doc (§10.2-10.7) serviront de **base de ton** pour l'arc Jirachi ch25+ — pas avant.

## Plan de production restant (vers 7000)

Budget par lieu, à livrer en sessions successives (répartition Prompt Maître : 25/35/20/10/10) :

| Lot | Lieu / système | Cible lignes | Priorité |
|---|---|---|---|
| A | Metano ville pendant l'expédition (maisons, café, auberge, PNJ de rue : réactions à l'absence de la guilde, rumeurs) | ~1800 | 1 |
| B | Entrées de donjon (steppe/tunnel/mont) : variantes des 8 PNJ de camp par état d'avancement (Tropius, Noctowl, Audino, Snubbull, Breloom, Girafarig, Mareep, Cranidos) | ~1500 | 1 |
| C | Guilde (3 étages) : veille de départ, briefings, soirs de camp, retour | ~1200 | 2 |
| D | Relais (nouvelles couches : nuits de camp, discussions croisées Hyko×Almotz) | ~600 | 2 |
| E | Rumeurs dynamiques post-expédition (retour ch5→ch6) | ~500 | 3 |
| F | Cinématiques additionnelles (départ collectif enrichi, nuit du premier camp, retour triomphal) | ~300 | 3 |

Chaque lot suit la checklist §7 du Prompt Maître (voix par PNJ, zéro réplique figée, cohérence temporelle) et met à jour `docs/bible_continuite.md`.
