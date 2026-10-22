# Sky Tower (Rescue Team) vs Chapitre 10 de New Era — inventaire comparatif

**Date** : 2026-08-04 · **Branche** : `arena/019fc78e-new-era-abyss-to-ascension-v4`
**Phase B** du portage. Aucune modification de code dans ce document : c'est
l'état des lieux qui doit être validé avant d'écrire quoi que ce soit.

---

## 0. Avertissement de méthode — à lire avant tout

La demande précise de s'appuyer sur `pret/pmd-red`. **Ce dépôt ne contient pas
les données de Sky Tower sous une forme exploitable.**

`pret/pmd-red` est une décompilation du **moteur** : du C et de l'assembleur
(`src/`, `asm/`, `include/`). Les scripts de cinématique, les dialogues, les
séquences d'événements et les tables de donjon sont des **données binaires
embarquées dans la ROM**, que le projet n'a pas extraites en source lisible.
C'est exactement le même mur que pour Aegis Cave (`pret/pmd-sky`), constaté et
documenté lors du portage des Aegis Cave.

Concrètement, cela veut dire :

| Ce qui est possible | Ce qui ne l'est pas |
|---|---|
| Reconstituer la **structure** (étages, biomes, boss, progression) depuis des sources concordantes | Extraire les timings au frame près du code officiel |
| Reproduire la **dramaturgie** (ordre des beats, ce que chaque scène doit produire) | Récupérer les placements de caméra exacts de la ROM |
| Réutiliser les **assets graphiques** fournis (3 PNG authentiques) | Prétendre à une fidélité « décompilée » |

La suite de ce document distingue systématiquement **[MESURÉ]** (lu dans notre
dépôt) de **[RECONSTITUÉ]** (déduit de sources externes concordantes).

---

## 1. Sky Tower dans Rescue Team — structure de référence [RECONSTITUÉ]

Sources concordantes : Bulbapedia, Serebii, guides de progression.

| Élément | Valeur |
|---|---|
| Étages | 25 (B1F–24F puis le sommet) |
| Accès | après Mt. Freeze / séquence de la météorite |
| Boss | **Rayquaza**, au sommet |
| Particularité | montée continue, pas de relais intermédiaire dans l'original |
| Suite | destruction de la météorite, puis retour et disparition du héros |

**Séquence narrative canonique** :

1. La météorite (« Étoile de la Destruction ») menace le monde
2. L'équipe gravit la Tour Céleste pour atteindre Rayquaza
3. Rayquaza refuse d'écouter et attaque — il faut le vaincre pour être entendu
4. Vaincu, il accepte : il monte en haute atmosphère
5. Ultralaser → la météorite est pulvérisée → pluie d'étoiles
6. Retour, puis conséquences (dans l'original : la disparition du héros)

---

## 2. Notre chapitre 10 — état mesuré [MESURÉ]

### 2.1 La zone `celestial_peak`

6 segments, 22 étages :

| seg | contenu | carte fixe |
|---|---|---|
| 0 | Contreforts Venteux — 8 étages, montagne rocheuse | *(procédural)* |
| 1 | Relais — corniche nuageuse, checkpoint | `celestial_peak_relay` |
| 2 | Mer de Nuages — 6 étages, plates-formes flottantes | *(procédural)* |
| 3 | Escouade Fulgur — course tactique | `celestial_peak_fulgur` |
| 4 | Sommet Sacré — 4 étages, ciel pur | *(procédural)* |
| 5 | **Arène de Rayquaza** | `celestial_peak_boss` |

### 2.2 Les grounds

| ground | taille | collision | entités | musique |
|---|---|---|---|---|
| `parvis_celeste` | 408×288 | 73 % | 4 | Sky Peak Prairie |
| `palier_celeste` | 456×456 | 79 % | 3 | Sky Peak Cave |
| `autel_celeste` | 552×600 | 85 % | 6 | Rainbow Peak |
| `tour_ciel_sommet` | 552×576 | 84 % | 6 | Sky Tower |

### 2.3 Les assets fournis

| PNG | taille | état |
|---|---|---|
| `Sky_Tower_entrance_RTRB.png` | 408×288 | ✅ intégré → planche `Sky_Tower_Entrance_Base`, ground `parvis_celeste` |
| `Sky_Tower_summit_RTRB.png` | 551×576 | ✅ intégré → planche `Sky_Tower_Summit_Base`, ground `tour_ciel_sommet` |
| `Sky_Tower_cutscene_RTRB.png` | 288×216 | ❌ **non intégré** — aucune planche, aucune carte à ce format |

### 2.4 La chaîne du climax, après correction du 2026-08-04

```
seg4 (Sommet Sacré) franchi
  └─> tour_ciel_sommet.Enter()          ACTE 0 : Rayquaza fend les nuages
        └─> ContinueDungeon(seg 5)      LE COMBAT — rayquaza n40
              └─> PeakVictory()          ACTE 1 : les trente ans
                    └─> tour_ciel_sommet ACTE 2 : la météorite, Chapter = 11
```

---

## 3. Écarts identifiés

### 3.1 Corrigé en Phase A (commit `ba05f1f`)

| # | Écart | État |
|---|---|---|
| 1 | L'arène du segment 5 contenait **Lugia n35** au milieu de deux scènes de Rayquaza | ✅ `rayquaza n40`, Dragon/Vol, `air_lock` |
| 2 | L'acte 1 (18 répliques) était écrit pour Lugia | ✅ réécrit, contexte trente ans après Rescue Team |
| 3 | Dialogue de mort citant « Lugia, le Gardien des Cieux » | ✅ |
| 4 | Segment 5 nommé « Autel de Lugia » | ✅ « Sommet de la Tour Céleste » |
| 5 | `BossMusic.Play('autel_celeste')` depuis `tour_ciel_sommet` | ✅ |

### 3.2 Écarts restants — par ordre de gravité

| # | Écart | Gravité | Effort |
|---|---|---|---|
| **A** | `autel_celeste` est du **code mort** : plus aucun script n'y mène, mais il duplique les 17 clés `CPB_*` et toute la scène | moyenne | faible |
| **B** | Le PNG **cutscene non intégré** — pas de plan large de la tour avant l'ascension | moyenne | moyen |
| **C** | **Pas de ground d'entrée dédié** : on entre dans le donjon sans voir la tour | moyenne | moyen |
| **D** | Les 3 secteurs procéduraux n'ont **aucune variation de biome** déclarée : même tileset du bas au sommet | forte | moyen |
| **E** | Aucune **cinématique intermédiaire** pendant l'ascension | faible | fort |
| **F** | Les noms de drapeaux gardent `Lugia` (`PlayedLugiaTalk`…) | nulle | — |

**Sur le point D** — c'est l'écart le plus contraire à la demande. Le brief
insiste : *« le joueur doit ressentir qu'il s'approche progressivement du
domaine de Rayquaza »*. Or les 3 secteurs partagent la même identité visuelle.
Les commentaires annoncent pourtant trois ambiances distinctes (montagne
rocheuse → plates-formes flottantes → ciel pur). C'est déclaré, pas implémenté.

**Sur le point F** — signalé pour mémoire, **à ne pas corriger** : renommer ces
drapeaux casserait les sauvegardes en cours. Ce sont des identifiants internes,
jamais affichés.

---

## 4. Plan de lots proposé

Chaque lot est livrable et testable seul.

### LOT 1 — Progression visuelle de l'ascension *(écart D)*
Donner aux 3 secteurs procéduraux trois identités distinctes : tilesets,
élément, musique, faune. La montée doit se **voir**.
Prérequis : relever les tilesets réellement attestés dans le dépôt.

### LOT 2 — Nettoyage de `autel_celeste` *(écart A)*
Supprimer la scène morte, ou reconvertir le ground en étape d'ascension.
À trancher : le décor est bon, seul le script fait doublon.

### LOT 3 — Le plan large de la tour *(écarts B et C)*
Intégrer `Sky_Tower_cutscene_RTRB.png` comme carte de transition : le duo
découvre la tour avant de l'escalader. C'est le beat d'ouverture qui manque.

### LOT 4 — Jalons d'ascension *(écart E)*
Deux à trois interventions courtes pendant la montée (l'air se raréfie, la
Voix, le premier aperçu du sommet). Volume mesuré, pas de remplissage.

---

## 5. Ce que je ne promets pas

- **Aucun timing extrait de la ROM.** Les rythmes seront calibrés sur les
  cinématiques déjà validées du projet (Mont Venteux, Aegis Cave).
- **Aucun asset inventé.** Chaque tileset, son, particule et musique sera
  vérifié contre un usage réel du dépôt avant emploi — règle qui a déjà
  rattrapé 5 assets inexistants.
- **Rien n'est testé manette en main.** Les audits sont statiques.

---

## 6. Décision attendue

Le chapitre 10 **fonctionne** depuis la Phase A : la chaîne est cohérente du
segment 0 jusqu'à la météorite, et le bon boss est dans la bonne arène.

Les lots ci-dessus sont de l'**enrichissement**, pas de la réparation.
Ordre recommandé : **1 → 3 → 2 → 4**, en commençant par ce qui se voit le plus
(la progression de l'ascension), et en gardant les jalons narratifs pour la fin.
