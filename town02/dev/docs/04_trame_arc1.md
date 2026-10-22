# Trame narrative — New Era : Abyss to Ascension
## Squelette global (32 chapitres, 6 arcs) + Arc 1 détaillé — SOUMIS À VALIDATION

Contraintes respectées : chapitres 1-5 existants conservés tels quels (seuls des
ajouts légers de préfiguration y sont proposés, jamais de réécriture) ; Necrozma =
menace de l'Abîme ; Eternatus = twist final préparé par les rêves ; deux équipes
rivales récurrentes ; lore réel du mod réutilisé (la guilde de Metano, l'expédition,
les « cores » — cf. `first_core_location`, « anima core » dans le todo.txt de l'auteur).

---

## Vue d'ensemble des 6 arcs

| Arc | Chapitres | Titre de travail | Fonction dramatique |
|---|---|---|---|
| 1 | 1-6 | **Les Braises de Metano** | Base existante (ch. 1-5) + ch. 6 de transition : premiers signes de l'Abîme, introduction de l'Escouade Fulgur (équipe Luxray) |
| 2 | 7-12 | **Les Cœurs qui s'éteignent** | Les cores régionaux faiblissent un à un ; introduction du Cercle du Suaire (équipe spectre) ; premiers rêves du héros |
| 3 | 13-17 | **La Lumière dévorée** | Révélation : une entité vole la lumière des cores — Necrozma nommé ; visions du passé (chute d'Ultra-Necrozma en ce monde) |
| 4 | 18-23 | **L'Abîme ouvert** | Le monde se dégrade visiblement (sauvages agressifs, donjons qui prolifèrent) ; alliance forcée avec l'Escouade Fulgur ; le Cercle du Suaire bascule |
| 5 | 24-28 | **Ascension brisée** | Confrontation avec Necrozma… qui révèle qu'il ne dévorait pas la lumière par malice : il la **scellait** loin de quelque chose d'enfoui. Visions du futur : un ciel veiné de pourpre |
| 6 | 29-32 | **Le Cœur du Vide** | Twist : l'énergie des cores est l'ancien sceau posé sur **Eternatus**, endormi au fond de l'Abîme. Chaque core « sauvé » à la manière naïve des héros a affaibli le sceau. Finale en deux temps : Abîme (Eternatus) puis Ascension (Necrozma rédempteur prête sa lumière). |

**Logique du twist** : tout ce que le joueur croyait savoir (Necrozma = voleur de
lumière = mal) est recontextualisé — la lumière des cores n'était pas la *vie* du
monde mais sa *prison*. Les rêves du héros, dès l'arc 2, sont des fragments de
mémoire du dernier gardien du sceau, dont le héros porte l'héritage (raison de son
arrivée dans ce monde — cohérent avec l'amnésie classique PMD déjà posée par la
cinématique d'ouverture de Relic Forest).

## Les deux équipes rivales

**Escouade Fulgur** (Luxray, chef ; Lucario, bras droit ; Héliolisk, éclaireur) —
rivaux « loyaux » : arrogants, obsédés par le classement de la guilde, mais avec un
code d'honneur. Arc de rédemption : rivaux (arcs 1-3) → alliés critiques (arc 4+).
Ton d'écriture : joutes verbales, esprit de compétition, panache.

**Le Cercle du Suaire** (Banette, meneur ; Ectoplasma, manipulateur ; Nostenfer,
traqueur) — antagonistes « brumeux » : sabotent les missions, volent des fragments
de core, semblent servir l'Abîme. Révélation arc 4 : ce sont les descendants des
anciens gardiens du sceau, devenus fanatiques — ils affaiblissent les cores
volontairement croyant que seul un monde éteint prive Eternatus de l'énergie
Dynamax dont il se nourrit. Ton : menace feutrée, apparitions dans le brouillard,
musique et VFX distincts de Fulgur.

## Règle légendaires
Necrozma : apparitions scriptées uniquement (visions arc 3, boss arc 5, allié arc 6).
Eternatus : uniquement ch. 31-32. Aucun légendaire en spawn, boss secondaire ou job board.

---

## ARC 1 — Les Braises de Metano (ch. 1-6)

### Chapitres 1-5 (existants — modifications minimales)
Contenu conservé intégralement. Ajouts de préfiguration proposés (à valider) :
- **Ch. 2, nuit à la guilde** : premier rêve — 3 lignes de texte sur fond noir +
  son de cristal fêlé (`SOUND:PlayBattleSE`), aucune image. Indéchiffrable à ce stade.
- **Ch. 3, first_core_location** : au moment où le core devient instable (scène que
  l'auteur voulait déjà retravailler, cf. todo.txt), une teinte violette d'un instant
  (`GAME:FadeOut`/`FadeIn` coloré) — préfigure l'Abîme sans rien nommer.
- **Ch. 5** : dans la scène de fin existante, un PNJ mineur mentionne « une équipe
  aux yeux d'or qui pose trop de questions sur les cores » → amorce Fulgur.

### Chapitre 6 (nouveau) — « Ceux qui brillent »
**Trame (40-60 min)** : la guilde reçoit l'ordre d'inspecter le core de la région
après l'instabilité du ch. 3. L'Escouade Fulgur, guilde rivale de la côte, arrive à
Metano avec le même mandat — course à l'objectif. Mission d'histoire type
« sauvetage » : Héliolisk, parti seul en éclaireur, disparaît dans une faille
apparue en une nuit (premier « donjon né de l'Abîme »). Le héros le sauve ; Luxray,
humilié et reconnaissant à la fois, jure qu'ils se reverront. Dernière scène : rêve
n°2 — première image : une silhouette prismatique enchaînée dans le noir.

**Donjons du ch. 6 (fiches complètes à produire à l'étape donjons, après validation
de l'arc)** : 3 histoire (Sentier des Failles, Cœur Fêlé — inspection du core,
Gouffre Naissant — sauvetage d'Héliolisk, boss : trio de Pokémon sauvages enragés) +
7 job board échelonnés sur les jours en jeu, réutilisant les biomes/tilesets déjà
présents dans le mod (à inventorier depuis `Data/Zone/` existant + DumpAsset).

**Escalade du monde** : à partir du ch. 6, +5 % de spawns agressifs (statut Enraged
sur une fraction des tables), +1 donjon secondaire par chapitre par rapport à l'arc 1.

---

### Points à valider avant l'écriture de l'arc 2
1. Le principe « lumière des cores = sceau d'Eternatus » comme moteur du twist.
2. Les compositions des deux équipes (Lucario/Héliolisk autour de Luxray ; le trio spectre imposé est respecté).
3. Les 3 retouches de préfiguration dans les chapitres existants (ou zéro retouche si vous préférez l'existant strictement intact).
4. Le chapitre 6 comme chapitre de transition avant le premier grand arc nouveau.
