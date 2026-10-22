# PLAN NARRATIF — « LA ROUTE CANONIQUE » (Arc hors-trame : donjons PMD Red)

**Date : 2026-08-06 — Statut : PLAN NARRATIF, aucune implémentation.**
Directives utilisateur intégrées : donjons PMD Red **prioritaires**, importés **tous** avec leurs
cinématiques canoniques ; **hors arc narratif principal**, dans un **chapitre dédié** ; départ à
**Metano Town** ; **zéro doublon** ; la trame New Era n'est **pas modifiée** ; le tout doit **se marier**
avec l'histoire de New Era (cohérence, pas d'incohérence).

---

## 1. CONCEPT — comment l'arc se marie avec la trame New Era

**Prémisse (sans rien casser de la trame ch1-32)** :

> La guilde de Metano Town découvre, dans ses archives, les **« Anciennes Routes de Sauvetage »** :
> le réseau légendaire de donjons que les équipes de sauvetage d'une ère révolue parcouraient pour
> apaiser les esprits de la nature — les **gardiens canoniaux** (Zapdos, Moltres, Articuno, Groudon,
> Rayquaza, Kyogre, Lugia, Ho-Oh, Mewtwo, Mew, Jirachi, Celebi, Deoxys, Regis, Latios, Entei,
> Suicune, Raikou…). Ces routes sont **liées aux Cœurs/Anima** : chaque Cœur stabilisé par la trame
> principale **déverrouille un tronçon** de la Route. L'Abîme (fil rouge New Era) **puise dans ces
> routes oubliées** : rouvrir un donjon canonique, c'est **resceller un fragment du sceau** — le joueur
> a donc un enjeu dans la trame principale SANS en modifier le déroulé.

**Conséquences de cohérence (vérifiées contre l'existant) :**
- La trame principale (arcs 1-6, ch1-32, bosses New Era, twist Eternatus/Necrozma) **reste intacte**.
- L'arc « Route Canonique » est un **chapitre dédié, hors numérotation** de la trame (étiqueté
  « Hors-Trame — La Route Canonique »), déblocable progressivement selon l'avancement (ch. ≥ 7).
- Les donjons déjà présents dans la trame principale ne sont **pas dupliqués** : la Route **converge**
  vers eux (cf. §4 — tableau anti-doublon).
- Les 57 Friend Areas restent des **zones d'accueil/arènes de boss** (décision actée — directive
  utilisateur), pas des donjons de la Route.

---

## 2. STRUCTURE DU CHAPITRE DÉDIÉ

**Accès** : une porte ancienne à **Metano Town** (ou l'« archives » de la guilde — à trancher au
moment du branchement), inactive au début, qui s'ouvre tronçon par tronçon.

**3 tronçons (milestones), chacun = un segment de la Route canonique :**

| Tronçon | Contenu (ordre canonique) | Gardiens canoniques | Déblocage (trame principale) |
|---|---|---|---|
| **I — Les Premières Routes** | Tiny Woods → Mt. Thunder Peak (6 donjons) + arc fugitif narratif | Zapdos | après ch. 7 |
| **II — Les Routes du Ciel** | Great Canyon → Magma Cavern Pit (10 donjons) | Moltres, Articuno, Groudon | après ch. 9-10 |
| **III — Le Sommet Céleste** | Sky Tower + Sky Tower Summit (2 donjons — **convergence** avec tour_celeste ch10) | Rayquaza | après ch. 10 |
| **IV — Les Routes Légendaires** | post-game (33 donjons, ordre canonique des quêtes 34→50) | Kyogre, Lugia, Deoxys, Ho-Oh, Mewtwo, Regis+Mew, Jirachi, Celebi, Latios, Entei, Suicune, Raikou | post-trame (ch. 14+) |

---

## 3. LA ROUTE CANONIQUE — 51 DONJONS, ORDRE ET CINÉMATIQUES VÉRIFIÉS

*(Sources : `pret/pmd-red/data/dungeon/dungeon_data.json` + `floor_id.json` (étages) ;
`src/dungeon_cutscene_*.c` (constantes CUTSCENE_* = cinématique/boss canonique).)*

### Tronçon I — Les Premières Routes (6)
| Ordre | Donjon | Étages | Cinématique canonique |
|---|---|---|---|
| 1 | Tiny Woods | 3 | — (mission d'apprentissage) |
| 2 | Thunderwave Cave | 5 | — |
| 3 | Mt. Steel | 9 | — |
| 4 | Sinister Woods | 13 | — (rencontre des Meanies/Gengar) |
| 5 | Silent Chasm | 9 | — |
| 6 | Mt. Thunder | 10 | — |
| 7 | **Mt. Thunder Peak** | 3 | **Zapdos** (`dungeon_cutscene_zapdos.c`) |

*Arc fugitif canonique (grounds, pas de donjon) : raconté en cinématique entre I et II.*

### Tronçon II — Les Routes du Ciel (10)
| Ordre | Donjon | Étages | Cinématique canonique |
|---|---|---|---|
| 8 | Great Canyon | 12 | — |
| 9 | Lapis Cave | 14 | — |
| 10 | Mt. Blaze | 12 | — |
| 11 | **Mt. Blaze Peak** | 3 | **Moltres** (`dungeon_cutscene_moltres.c`) |
| 12 | Frosty Forest | 9 | — |
| 13 | **Frosty Grotto** | 5 | **Articuno** (`dungeon_cutscene_articuno.c`) |
| 14 | Mt. Freeze | 15 | — |
| 15 | Magma Cavern | 23 | — |
| 16 | **Magma Cavern Pit** | 3 | **Groudon** (`dungeon_cutscene_groudon.c`) |

### Tronçon III — Le Sommet Céleste (2, convergence)
| Ordre | Donjon | Étages | Cinématique canonique |
|---|---|---|---|
| 17 | **Sky Tower** | 25 | — (parvis : `parvis_celeste` = D13P01 déjà converti) |
| 18 | **Sky Tower Summit** | 9 | **Rayquaza** (`dungeon_cutscene_rayquaza.c` ; D13P03 = `tour_celeste_sommet`, déjà implémenté ch10) |

### Tronçon IV — Les Routes Légendaires (33, ordre canonique post-trame)
Ordre basé sur les quêtes officielles (event_flag.h : 34,0 Stormy Sea → 35,0 Silver Trench → 37,0
Meteor Cave → 43,0 Mt Faraway → 45,0 Western Cave → 50,0 Buried Relic) puis le reste :

| Ordre | Donjon | Étages | Gardien canonique |
|---|---|---|---|
| 19 | **Stormy Sea** | 40 | Kyogre (`dungeon_cutscene_kyogre.c`) |
| 20 | **Silver Trench** | 99 | Lugia (`dungeon_cutscene_lugia.c`) |
| 21 | **Meteor Cave** | 20 | Deoxys (`dungeon_cutscene_deoxys.c`) |
| 22 | **Mt. Faraway** | 40 | Ho-Oh (`dungeon_cutscene_hooh.c`) |
| 23 | **Western Cave** | 99 | Mewtwo (`dungeon_cutscene_mewtwo.c`) |
| 24 | **Buried Relic** | 99 | Regis + Mew (`dungeon_cutscene_regis.c`) |
| 25 | **Wish Cave** | 99 | Jirachi (`dungeon_cutscene_jirachi.c`) |
| 26 | **Purity Forest** | 99 | Celebi (`dungeon_cutscene_celebi.c`) |
| 27 | **Northern Range** | 25 | Latios (`dungeon_cutscene_latios.c`) |
| 28 | Pitfall Valley | 25 | — |
| 29 | Desert Region | 20 | — |
| 30 | Southern Cavern | 50 | — |
| 31 | Wyvern Hill | 30 | — |
| 32 | **Fiery Field** | 30 | Entei (`dungeon_cutscene_entei.c`) |
| 33 | **Northwind Field** | 30 | Suicune (`dungeon_cutscene_suicune.c`) |
| 34 | Solar Cave | 20 | — |
| 35 | **Lightning Field** | 30 | Raikou (`dungeon_cutscene_raikou.c`) |
| 36 | Darknight Relic | 15 | — |
| 37 | Murky Cave | 19 | — |
| 38 | Grand Sea | 30 | — |
| 39 | Uproar Forest | 10 | — |
| 40 | Oddity Cave | 15 | — |
| 41 | Remains Island | 20 | — |
| 42 | Marvelous Sea | 20 | — |
| 43 | Fantasy Strait | 30 | — |
| 44 | Rock Path | 4 | — |
| 45 | Snow Path | 4 | — |
| 46 | Howling Forest | 15 | — |
| 47 | Waterfall Pond | 19 | — |
| 48 | Unown Relic | 11 | — |
| 49 | Joyous Tower | 99 | — |
| 50 | Far-Off Sea | 75 | — |

*(51e = Purity Forest compté au n°26 ; total 51 = 50 lignes + Sky Tower Summit.)*

---

## 4. ANTI-DOUBLON — résolution des chevauchements avec la trame principale

| Donjon / Gardien | Conflit avec la trame New Era | Résolution proposée |
|---|---|---|
| **Sky Tower / Rayquaza** | tour_celeste ch10 = déjà la version canonique (D13P01/D13P03) | **Convergence** : le Tronçon III mène AU MÊME tour_celeste (aucune ré-import, aucun doublon — le sommet canonique EST la trame principale) |
| **Regis (Buried Relic)** | trio Regi déjà dans cloven_ruins ch7 (`sanctuaire_titans`, import Aegis Cave Sky) | Buried Relic conservé **sans le trio** en gardien de tronçon : Mew (99F) reste le gardien final canonique (QUEST_LEGEND_MEW, event_flag.h:50,0) ; le trio = présence décorative/écho, PAS un combat dupliqué |
| **Mew** | trame principale prévoit Mew ch26 (arène `foret_mue`, vague6) | La rencontre canonique Mew = **fin de Buried Relic** (Route). L'assignation vague6 `foret_mue` devient un **écho/alt** (pas un combat canonique) — un seul Mew canonique |
| **Jirachi (Wish Cave)** | trame principale : `wishmaker_cave` (donjon Jirachi du mod) + Partie 8.3 (ground Wish Cave = salle finale) | La Route utilise **le ground `sanctuaire_voeu` (D23P01) comme salle finale** de Wish Cave, conformément à la synthèse Partie 8.3 — **un seul Jirachi** (celui de wishmaker_cave reste LE donjon Jirachi) ; Wish Cave = 99 étages menant à la salle |
| **Kyogre (Stormy Sea)** | trame principale : Kyogre ch12 (arène `plancher_abysses`, vague6) | **Le canonique = Stormy Sea** (Route, Tronçon IV). L'assignation vague6 ch12 est **révoquée/reconvertie** (l'arène devient l'écho) — un seul Kyogre canonique |
| **Ho-Oh (Mt. Faraway)** | trame principale : Ho-Oh ch18 (`pic_arc_en_ciel`, vague6) | Idem : **Mt. Faraway = rencontre canonique** ; `pic_arc_en_ciel` redevient réserve décorative |
| **Celebi (Purity Forest)** | trame principale : Celebi ch20 (`foret_guerison`, vague6) | Idem : **Purity Forest = rencontre canonique** |
| **Lugia (Silver Trench)** | plus aucun Lugia dans la trame principale (ch10 = Rayquaza, fixes 83cf229) | **Aucun conflit** — Silver Trench = unique Lugia canonique ✓ |
| **Groudon / Zapdos / Moltres / Articuno / Raikou / Entei / Suicune / Latios / Deoxys / Mewtwo** | aucun dans la trame principale | **Aucun conflit** — rencontres canoniques uniques ✓ |
| **Friend Areas (57)** | — | hors Route (zones d'accueil / arènes — directive utilisateur) ✓ |
| **Labyrinthes élémentaires (17)** | déjà tranché (Partie 8.7 : compléter nos mazes dojo) | hors Route ✓ |
| **Duels rivaux (4)** | combats ponctuels (Partie 6) | hors Route ✓ |

**Règle d'or anti-doublon** : chaque gardien canonique apparaît **une seule fois** dans tout le mod
(Route ou trame). Les assignations vague6 en conflit (Kyogre/Ho-Oh/Celebi/Mew) sont **révoquées** au
profit de la Route ; les arènes concernées restent des cartes disponibles (échos décoratifs).

---

## 5. CINÉMATIQUES CANONIQUES — périmètre d'import (1:1, règle Partie 6)

Chaque donjon à gardien importe SA cinématique de donjon canonique (`dungeon_cutscene_*.c`) :
arrivée du gardien, dialogues canoniques, musique dédiée, combat en arène. Les 18 entrées de donjon
déjà converties (`pmdred_extraction_tracabilite.md` — foret_tendre_oree, grotte_statique_seuil,
pic_ferreux_pied, bois_sombres_oree, gouffre_muet_bord, mont_grondant_pied, grand_canyon_porte,
grotte_lazuli_seuil/fond, mont_cendre_pied, foret_givree_oree, mont_gele_pied, gorge_ardente_porte,
parvis_celeste, vallon_perdu, sanctuaire_voeu, caverne_trouble_fond/autel) + les 12 arènes (lot 3 :
D12P02/04, D13P02, D14P01, D15P01, D16P01, D17P01, D18P01, D19P01, D20P01, D21P01, D25P01) sont les
**assets d'entrée/arène** de la Route. Cinématiques : castings conservés (règle 1:1 PMD Red), seuls
les noms de zone changent (noms FR proposés au §6).

---

## 6. NOMS FRANÇAIS PROPOSÉS (convention traçabilité — à valider)

| PMD Red | Nom FR (proposé) | PMD Red | Nom FR (proposé) |
|---|---|---|---|
| Tiny Woods | Forêt Tendre | Mt. Faraway | Mont Lointain |
| Thunderwave Cave | Grotte Statique | Western Cave | Grotte Occidentale |
| Mt. Steel | Pic Ferreux | Buried Relic | Relique Enfouie |
| Sinister Woods | Bois Sombres | Wish Cave | Grotte du Vœu |
| Silent Chasm | Gouffre Muet | Purity Forest | Forêt de la Pureté |
| Mt. Thunder / Peak | Mont Grondant / Cime du Mont Grondant | Northern Range | Chaîne Nordique |
| Great Canyon | Grand Canyon | Pitfall Valley | Vallon Perdu |
| Lapis Cave | Grotte Lazuli | Desert Region | Région Désertique |
| Mt. Blaze / Peak | Mont Cendré / Cime du Mont Cendré | Southern Cavern | Caverne Méridionale |
| Frosty Forest / Grotto | Forêt Givrée / Grotte Givrée | Wyvern Hill | Colline aux Drakes |
| Mt. Freeze / Peak | Mont Gelé / Cime du Mont Gelé | Fiery / Northwind / Lightning Field | Plaine Ardent / Champ du Vent du Nord / Champ de Foudre |
| Magma Cavern / Pit | Gorge Ardente / Fond de la Gorge Ardente | Solar Cave | Grotte Solaire |
| Sky Tower / Summit | Tour Céleste / Sommet (déjà ch10) | Darknight Relic | Relique de la Nuit |
| Stormy Sea | Mer Orageuse | Murky Cave | Caverne Trouble |
| Silver Trench | Fosse d'Argent | Grand Sea / Marvelous Sea / Fantasy Strait | Grande Mer / Mer Merveilleuse / Détroit Fantastique |
| Meteor Cave | Grotte de la Météorite | Uproar Forest / Oddity Cave | Forêt du Tumulte / Caverne Étrange |
| Rock Path / Snow Path | Sentier Rocheux / Sentier Neigeux | Remains Island | Île des Vestiges |
| Howling Forest / Waterfall Pond | Forêt des Hurlements / Étang de la Cascade | Unown Relic / Joyous Tower / Far-Off Sea | Relique des Zarbi / Tour Joyeuse / Mer Lointaine |

---

## 7. PROCHAINE ÉTAPE (après validation de ce plan)

1. Validation du plan narratif (concept §1, tronçons §2, anti-doublon §4, noms §6).
2. Implémentation **Tronçon I** d'abord (7 donjons : 6 + Mt. Thunder Peak/Zapdos) :
   `Data/Zone/<id>.json` (structure RogueEssence éprouvée), tables d'ennemis depuis
   `pokemon_found.json` (espèces vérifiées `Content/Chara/`), cinématique Zapdos 1:1, branchement
   entrées converties (`foret_tendre_oree`, `grotte_statique_seuil`, `pic_ferreux_pied`…), porte à
   Metano Town, `master_zone` + `index.idx`, musique vérifiée `Content/Music/`.
3. Audit de fidélité par donjon puis commit ; passage au tronçon suivant.

**EN ATTENTE DE VALIDATION.**
