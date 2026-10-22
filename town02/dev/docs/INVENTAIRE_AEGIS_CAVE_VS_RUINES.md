# Inventaire comparatif — Aegis Cave (EoS) vs Aegis Cave (New Era)

Date : 2026-08-03. Établi AVANT toute modification, conformément à la demande.
Aucune ligne de code n'a été écrite sur la base de ce document : il sert à
décider, pas à justifier après coup.

---

## 1. Sources consultées

| Source | Ce qu'elle a donné | Limite |
|---|---|---|
| `pret/pmd-sky` (décompilation) | Arborescence réelle : `asm/`, `src/`, `include/`, `lib/`, `tools/`. **Décompilation du MOTEUR en C/ASM**, pas des données de donjon. | Ne contient PAS les scripts `.ssb` de donjon ni les tables de spawn dans un format lisible directement. Les données de donjon vivent dans la ROM (`files/`), non versionnées. |
| Serebii (fiche Aegis Cave EoS) | Structure d'étages, listes de spawn par secteur, bosses, conditions. | Source secondaire, mais **concordante sur 4 sites indépendants**. |
| Bulbapedia (Walkthrough ch. 25) | Mécanique Unown détaillée, comportement du marqueur de pierre, absence de Monster Houses. | Idem. |

**Point d'honnêteté méthodologique** : `pret/pmd-sky` est une décompilation du
code moteur. Les scripts d'événement d'Aegis Cave (format `.ssb`, dans
`SCRIPT/D42P21A/` de la ROM) **ne sont pas** dans le dépôt Git sous forme
lisible. Je n'ai donc **pas pu lire les scripts officiels ligne à ligne**.
La structure ci-dessous est reconstituée à partir de sources secondaires
concordantes, ce qui est fiable pour la STRUCTURE et les MÉCANIQUES, mais ne
me permet pas de prétendre reproduire les scripts au pas près.
Pour un portage réellement pas-à-pas il faudrait `skytemple-files` +
une ROM, hors de portée de cet environnement.

---

## 2. Structure officielle d'Aegis Cave (EoS)

### 2.1 Découpage en secteurs

| # | Secteur | Étages | Fin de secteur |
|---|---|---|---|
| 1 | Ice Maze | B1F–B3F | retour à l'entrée (boucle) |
| 2 | Regice's Chamber | 1 salle fixe | boss Regice |
| 3 | Rock Maze | B1F–B3F | retour à l'entrée (boucle) |
| 4 | Regirock's Chamber | 1 salle fixe | boss Regirock |
| 5 | Steel Maze | B1F–B4F | retour à l'entrée (boucle) |
| 6 | Registeel's Chamber | 1 salle fixe | boss Registeel |
| 7 | Aegis Cave Pit (Deepest Part) | B1F–B5F | pas de puzzle |
| 8 | Regigigas's Chamber | 1 salle fixe | boss final |

**Total : 15 étages procéduraux + 4 salles fixes.**

### 2.2 La mécanique centrale — le puzzle Unown

C'est le cœur du donjon, et c'est une **boucle**, pas une progression linéaire :

1. Une **tablette de pierre** à l'entrée porte des cavités en forme de lettres Unown.
2. Le joueur descend le labyrinthe. Les Unown vaincus **lâchent parfois** une
   pierre gravée de leur lettre (drop **aléatoire**, et le spawn de la bonne
   forme d'Unown est lui-même aléatoire).
3. Arrivé en bas du labyrinthe, le joueur **revient à l'entrée** — le secteur
   boucle sur lui-même tant que le mot n'est pas complété.
4. Une fois les bonnes pierres en poche, on interagit avec la tablette, le jeu
   demande de **fermer les yeux**, et un escalier apparaît vers la salle du Regi.

Les trois mots, dans l'ordre imposé : **ICE** → **ROCK** → **STEEL**.
Puis le Pit (5F, sans puzzle) → Regigigas.

### 2.3 Détails à ne pas perdre

- **Aucune Monster House** dans tout le donjon (particularité assumée).
- Un des rares donjons où l'on **trouve des Clés** au sol.
- Les 28 formes d'Unown comptent comme **28 espèces distinctes** vis-à-vis de la
  limite de 14 espèces par étage : une forme cherchée peut être absente.
- **Team Charm** est retrouvée à terre après Registeel, puis **combat au côté du
  joueur** contre Regigigas.
- Combat final : **Regigigas + 4 Hitmonlee + 4 Bronzong** (les statues s'animent).
- Faiblesse commune des Regi : type Combat.
- Spawns communs : Zubat/Golbat/Crobat, Machop/Machoke, Unown (alphabet complet).

---

## 3. Ce que New Era possède DÉJÀ

| Élément | État | Preuve |
|---|---|---|
| Zone `cloven_ruins` | 6 segments, 26 étages | `Data/Zone/cloven_ruins.json` |
| Ground d'entrée | **refait, à ne pas toucher** | `cloven_ruins_entrance.rsground` (1488×1048, collision 100 % jouable) |
| Relais intermédiaire | segment 1 | `cloven_ruins_relay` |
| Mini-boss | segment 3 | `cloven_ruins_miniboss` (Kaorine/Golemastoc) |
| Arène finale | segment 5 | `sanctuaire_titans` |
| **Les 3 Regi** | déclarés ET mis en scène | `CharacterEssentials.lua`, `cloven_ruins_boss_ch_7.lua:187-231` |
| **Regigigas** | déclaré, boss du ch. 7 | `cloven_ruins_boss_ch_7.lua:3` |
| **Zarbi R-E-G-I-S** | déclarés, formes correctes (17,4,6,8,18) | `CharacterEssentials.lua:1141-1181` |
| Unown spawnable | oui, déjà utilisé ailleurs | `Data/Zone/bassin_tari.json` |

**Découverte importante** : les Zarbi sont déclarés pour épeler **R-E-G-I-S**,
pas ICE/ROCK/STEEL. Et ils ne sont **utilisés qu'à un seul endroit**
(`cloven_ruins_boss_ch_7.lua:121`), en décor de la scène de Regigigas.
Le système d'énigme n'existe donc **pas** : seuls les sprites existent.

---

## 4. Écart mesuré — ce qui manque réellement

| # | Élément manquant | Gravité | Remarque |
|---|---|---|---|
| M1 | **Système de pierres Unown** (drop, inventaire, vérification du mot) | Bloquant | Rien n'existe. C'est le cœur du donjon. |
| M2 | **Tablette interactive** + « fermez les yeux » + apparition d'escalier | Bloquant | Aucun objet de ce type sur le ground. |
| M3 | **Boucle de secteur** (revenir à l'entrée tant que le mot est incomplet) | Bloquant | La zone actuelle est **linéaire**, sans boucle. |
| M4 | **3 secteurs distincts** Glace/Roche/Acier avec biomes propres | Majeur | Actuellement : 3 blocs procéduraux au même habillage (`Deep Dark Crater.ogg` partout). |
| M5 | **3 arènes de Regi séparées** | Majeur | Les 3 Regi apparaissent dans **une seule** scène, pas en 3 combats. |
| M6 | **Pit 5F** avant Regigigas | Moyen | Segment 4 fait 3 étages. |
| M7 | **Escorte alliée** au combat final (équivalent Team Charm) | Moyen | Absent. |
| M8 | **Regigigas + 4 Hitmonlee + 4 Bronzong** | Moyen | Regigigas seul actuellement. |
| M9 | Suppression des Monster Houses sur la zone | Mineur | À vérifier dans les `ZoneSteps`. |

---

## 5. Le point de décision que je ne tranche pas seul

La demande dit : « structure, mécaniques, puzzles, level design, progression,
combats et mise en scène **aussi fidèles que possible** ; seul le scénario change ».

Or il y a une **tension réelle** entre cette consigne et l'état du projet :

### 5.1 Le puzzle Unown repose sur du grinding aléatoire

Dans EoS, la mécanique est unanimement décrite comme frustrante — les joueurs
rapportent « quatre heures » pour une seule lettre, parce que le drop ET le
spawn de la forme sont aléatoires. C'est **fidèle**, mais c'est aussi le défaut
le plus connu du donjon.

Trois options, à ton arbitrage :

- **(A) Fidélité stricte** : drop aléatoire, boucle de secteur, aucune aide.
  Le joueur peut rester bloqué longtemps. Fidèle à 100 %.
- **(B) Fidèle avec garde-fou** : même boucle et même puzzle, mais le taux de
  drop monte à chaque passage infructueux (pitié invisible). La sensation est
  identique, la frustration bornée.
- **(C) Fidélité de structure, énigme repensée** : on garde 3 secteurs + 3 Regi
  + Pit + Regigigas, mais les pierres s'obtiennent par exploration déterministe.

### 5.2 Les mots ICE/ROCK/STEEL sont anglais

Le projet est **intégralement en français** (0 dialogue anglais visible, vérifié).
Épeler « ICE » avec des Zarbi dans un jeu français est incohérent, et les Zarbi
déjà déclarés épellent **REGIS**. Options : `GLACE` / `ROCHE` / `ACIER`
(cohérent FR, 5+5+5 lettres), ou garder `REGIS` déjà en place.

### 5.3 Volume à produire

Barre de qualité demandée : **le Mont Venteux, 6103 lignes**.
Les Ruines totalisent aujourd'hui **2626 lignes**. L'écart est de ~3500 lignes,
soit l'équivalent de plusieurs sessions de production dense — sans compter les
3 arènes de Regi à créer (maps + collisions + scripts) et le système de pierres.

---

## 6. Ce que je propose comme ordre de travail

1. **Arbitrage** sur 5.1 (A/B/C), 5.2 (mots FR ou REGIS) et sur l'ampleur.
2. **Lot 1 — ossature de zone** : passer `cloven_ruins` à 8 segments
   (3 labyrinthes + 3 arènes Regi + Pit 5F + Regigigas), habillages distincts
   par secteur, Monster Houses retirées.
3. **Lot 2 — système de pierres Unown** : SV, drop, tablette, vérification,
   boucle de secteur. Testé isolément.
4. **Lot 3 — les 3 arènes de Regi** : maps + collisions tracées + entrées
   construites (jamais instantanées), une identité visuelle par Regi.
5. **Lot 4 — Pit + Regigigas** : escorte alliée, statues qui s'animent,
   Hitmonlee/Bronzong.
6. **Lot 5 — cinématiques internes** au niveau du Mont Venteux, avec plan de
   beats produit AVANT le script.
7. **Audit final** + non-régression sur les baselines connues.

Chaque lot est vérifié avant le suivant. Aucun ne démarre sans que le précédent
soit au vert.
