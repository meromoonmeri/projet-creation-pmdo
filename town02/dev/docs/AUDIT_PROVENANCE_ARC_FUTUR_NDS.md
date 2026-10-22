# AUDIT DE PROVENANCE — ARC DU FUTUR DEPUIS LA NDS (pret/pmd-sky)

Date : 2026-08-09 — Branche `arena/019fd882-new-era-abyss-to-ascension-v4`

## Méthodologie (source de vérité)

Parti des **données NDS extraites dans pret/pmd-sky** + tables du jeu (XML
skytemple) + **références croisées des 3760 SSB du jeu entier** (scan global).
La complétude n'est PAS déduite de notre liste initiale : elle est reconstruite
depuis les références présentes dans les données.

Inventaire complet par zone (fichiers présents dans la NDS/decomp) :

| Zone | SSB | SSA | LSD | enter.sse | MAP_BG (BMA/BPC/BPL) | mapty |
|---|---|---|---|---|---|---|
| P05P01A (repaire) | 4 | 3 | ✓ | ✓ | p05p01a ✓ | 9 |
| P05P02A (désert) | 5 | 3 | ✓ | ✓ | p05p02a ✓ + **p05p02a2 ✓** | 6 |
| P05P03A (stockade) | 3 | 2 | ✓ | ✓ | p05p03a ✓ | 6 |
| P05P04A (fuite) | 3 | 2 | ✓ | ✓ | p05p04a ✓ | 6 |
| P06P01A (monde futur) | 3 | 2 | ✓ | ✓ | p06p01a ✓ | 6 |
| P07P01A (secret) | 2 | 2 | ✓ | ✗ | p07p01a ✓ | 6 |
| P08P01A (Passage du Temps) | 8 | 7 | ✓ | ✓ | p08p01a ✓ | 6 |
| P09P01A (climax) | 5 | 4 | ✓ | ✓ | p09p01a ✓ | 6 |
| **S04P01A (présent, retour)** | 21 | 21 | ✓ | — | s04p01a ✓ | 4 |
| **D55P11A (donjon P.d.T. ét.1)** | 12 | 6 | ✓ | ✓ | d55p11a ✓ | 6 |
| **D55P21A (ét.2)** | 11 | 5 | ✓ | ✓ | d55p21a ✓ | 10 |
| **D55P41A (ét.3)** | 3 | 3 | ✓ | ✗ | d55p41a ✓ | 1 |
| Décors back2 : V09P04A, V10P03C, V12P01A, V13P01A, V14P01A, V14P03A, V14P04A | — | — | — | — | tous ✓ | 6/9 |

## DÉCOUVERTES DE L'AUDIT (références indirectes)

1. **9 SSB manquants dans notre liste** : les `enter00.ssb` (entrée de zone) de
   7 zones, `enter01.ssb` (2e entrée de P05P02A) et **`t02a0303.ssb`** (P08P01A,
   scène visuelle sans dialogue : héros du futur + Dusknoir + 6 Sableye, dans le
   LSD p08p01a !). Total arc : **33 SSB** (24 déjà convertis).
2. **Un DONJON fait partie de l'arc** : le **Passage du Temps = D55** (3 étages :
   D55P11A → D55P21A → D55P41A), entré depuis P08P01A (`main_EnterDungeon(140)` =
   level 140 = **D55P41A**, dans n08a2308 et n08a2508). Le donjon a 26 SSB.
   (D22P11A et D48P21A référencent aussi D55 — hors arc, autres épisodes.)
3. **m17a0301 = la traversée du trou dimensionnel** (présent ↔ futur) :
   `back_SetGround(P05P02A)` → `back_ChangeGround(P05P02A2)` →
   `back_SetGround(S04P01A)` — le retour au présent est dans le script.
4. **P07P01A n'a PAS d'enter.sse/enter00** (entrée par transition de scène).
5. **Décors back2_SetGround** (référencés par les scènes) : S04P01A (m26a0614),
   V09P04A + V10P03C (P07P01A), V12P01A + V13P01A (m19b1001), V14P01A/P03A/P04A
   (m19b1007).
6. **GROUND_STATE_MAP** (pmdsky 0x48A80) = liste d'acteurs de l'overworld, PAS
   les connexions. **La table des connexions physiques des grounds (portes) n'est
   pas extraite par le decomp** → `REQUIRES_ROM_EXTRACTION`.

## Graphe des routes (data-driven)

### Transitions SCRIPTÉES (capturées dans les 33 SSB)
```
présent (S04P01A) ──trou dimensionnel──▶ P05P02A (m17a0301, réveil)
   P05P02A ──change──▶ P05P02A2 (variante décor)
   P05P02A ──script──▶ S04P01A (retour, fin de m17a0301)
   P05P01A (repaire) : enter00 + m17a0103/m19a0102 (Dusknoir→Necrozma) + n08a2008 (héros du futur)
   P05P03A ──▶ (fuite) ──▶ P05P04A ──▶ P06P01A ──▶ P07P01A ──▶ P08P01A
   P08P01A ──main_EnterDungeon(140)──▶ D55P41A (Passage du Temps)
   D55 (3 étages) ──▶ P09P01A (climax)
   P09P01A ──▶ retour (S04P01A)
```

### Transitions PHYSIQUES (portes/doors entre grounds)
| Source | Destination | Type | Script | Coordonnées | Condition/Flag | Statut |
|---|---|---|---|---|---|---|
| P05P01A → P05P02A | door | ground_list ROM | inconnues | inconnue | **REQUIRES_ROM_EXTRACTION** |
| P05P02A → P05P03A | door | idem | idem | idem | **REQUIRES_ROM_EXTRACTION** |
| P05P03A → P05P04A | door | idem | idem | idem | **REQUIRES_ROM_EXTRACTION** |
| P05P04A → P06P01A | door | idem | idem | idem | **REQUIRES_ROM_EXTRACTION** |
| P06P01A → P07P01A | door | idem | idem | idem | **REQUIRES_ROM_EXTRACTION** |
| P07P01A → P08P01A | door | idem | idem | idem | **REQUIRES_ROM_EXTRACTION** |
| P08P01A → D55 | door | idem | idem | idem | **REQUIRES_ROM_EXTRACTION** |
| P08P01A → P09P01A | door | idem | idem | idem | **REQUIRES_ROM_EXTRACTION** |

Le `enter.sse` de chaque zone définit les **positions d'entrée** (P05P02A en a 2
→ 2 portes d'entrée). Les portes elles-mêmes (rectangles + destinations) sont
dans la table des grounds de la ROM (non exposée par pmdsky ; les .rsground du
port n'ont que `Main_Entrance_Marker`).

## Données de gameplay par zone (SSA — extraites)

| Scène | Acteurs | Objets | Position markers |
|---|---|---|---|
| m17a0103 / m19a0102 (P05P01A) | YONOWAARU | p05p01a1 | 0 |
| n08a2008 (P05P01A) | YONOWAARU_N8, PLAYER_FUTURE | — | 5 |
| m17a0104/m17a0201 (P05P02A) | PLAYER, ATTENDANT1 | — | 0 |
| m17a0301 (P05P02A) | + YAMIRAMI 1-4 | — | 11 |
| m17a0302 (P05P03A) | + JUPUTORU, YAMIRAMI 1-6, YONOWAARU | **p05p03a1/2 (pieux)** | 31 |
| m26a06d3 (P05P03A) | idem | p05p03a1/2 | 25 |
| m17a0401/03 (P05P04A) | + JUPUTORU | — | 3/0 |
| m18a0401 (P06P01A) | PLAYER, ATTENDANT1 | — | 14 |
| m18b1401/m26a06e6 (P07P01A) | + JUPUTORU | — | 6/6 |
| m19a0601/m19d0612 (P08P01A) | + SEREBII | — | 3/3 |
| n08a2308..2608, t02a0303 (P08P01A) | YONOWAARU_N8, PLAYER_FUTURE, YAMIRAMI 1-6 | — | 13/0/0/2/13 |
| m19b1001/07/09/d1072 (P09P01A) | cast complet | p09p01a1/2, v15p01a2/3 | 18/15/12/1 |

Aucun `event/trigger` dans les SSA de l'arc (les triggers de gameplay sont dans
les données de ground ROM). Collisions : couvertes par les .rsground du port
(8 zones importées) et les BMA de la NDS.

## Matrice de couverture

| Élément | Source NDS | Extrait | Converti PMDO | Manquant |
|---|---|---|---|---|
| 8 zones du futur (P05P01A-P09P01A) | ✅ MAP_BG | ✅ | ✅ 8 .rsground | — |
| P05P02A2 (variante) | ✅ MAP_BG | ✅ (BMA/BPL) | ❌ (non importé) | **EXTRACTED_NOT_CONVERTED** |
| S04P01A (présent) | ✅ | ✅ | ❌ | **EXTRACTED_NOT_CONVERTED** (hors arc strict) |
| D55 donjon (3 étages) | ✅ MAP_BG | ✅ (scripts + maps) | ❌ | **EXTRACTED_NOT_CONVERTED** |
| Décors back2 (V09P04A, V10P03C, V12P01A, V13P01A, V14P01A/P03A/P04A) | ✅ MAP_BG | ✅ | ❌ (7 .rsground non importés) | **EXTRACTED_NOT_CONVERTED** |
| 24 cinématiques | ✅ SSB | ✅ | ✅ Lua | — |
| **9 cinématiques manquantes** (enter00×7, enter01, t02a0303) | ✅ SSB | ✅ (décompilées) | ❌ | **EXTRACTED_NOT_CONVERTED** |
| SSA (24+9) | ✅ | ✅ | ✅ (positions) | — |
| LSD (8+1) | ✅ | ✅ | ✅ (liste scripts) | — |
| enter.sse (7+1) | ✅ | ✅ (entrées) | ✅ (marqueurs) | — |
| BMA/BPC/BPL (8 zones) | ✅ | ✅ | ✅ (via port) | — |
| Objets de scène (pieux, p09p01a1…) | ✅ SSA | ✅ | ✅ (dans .rsground) | — |
| Entités/NPC (13 types) | ✅ SSA | ✅ | ✅ cast New Era | — |
| Collisions | ✅ BMA | ✅ | ✅ (.rsground) | — |
| Musique (14 pistes) | ✅ SOUND | ✅ ids | ✅ 6/14 .ogg | **8 BGM manquants** |
| SE (37 ids) | ✅ | ✅ | ✅ 12/37 | **25 SE à mapper** |
| Animations (32 params) | ✅ | ✅ | ✅ 30/32 | 2 params spéciaux |
| **Portes/exits physiques** | ❌ ROM | ❌ | ❌ | **REQUIRES_ROM_EXTRACTION** |

## RÉPONSES FINALES

**A. Zones de l'arc** : **9 zones de gameplay** (8 du futur + S04P01A retour) +
**1 donjon** (D55, 3 maps) + **7 décors** back2 = **17 maps distinctes** (dont
P05P02A2 variante).

**B. Maps/routes** : **17 maps** (9 grounds de gameplay + 3 donjon + 7 décors,
dont P05P02A2). Routes physiques : **REQUIRES_ROM_EXTRACTION** (8 connexions
P05P01A→…→P09P01A + P08P01A→D55).

**C. Grounds** : **9 grounds de gameplay** (8 + P05P02A2) + **7 décors** +
s21p01a (rideau, déjà importé) = **17 .rsground** (8 importés, 9 à importer).

**D. Cinématiques** : **33 SSB** dans les zones de l'arc (24 converties +
**9 NON converties** : enter00×7, enter01, t02a0303).

**E. Scripts** : **33 SSB arc** + **26 SSB donjon D55** + 8 enter.sse + 21 S04P01A
(hub, partagé avec tout le jeu).

**F. Transitions** : **33 scriptées** (back_SetGround/ChangeGround/back2/EnterDungeon,
toutes capturées dans les IR) + **8 physiques REQUIRES_ROM_EXTRACTION**.

**G. NPC/entités** : **13 entités** (PLAYER, ATTENDANT1, PLAYER_FUTURE,
YONOWAARU, YONOWAARU_N8, JUPUTORU, SEREBII, YAMIRAMI 1-6) + objets de scène
(p05p01a1, p05p03a1/2=pieux, p09p01a1/2, v15p01a2/3).

**H. Références non résolues** : **8 connexions physiques** (table grounds ROM)
+ 1 mécanique d'entrée donjon D55 à confirmer.

**I. Liste exacte de ce qui manque** :
1. 9 SSB non convertis : `enter00` (P05P01A, P05P02A, P05P03A, P05P04A, P06P01A,
   P08P01A, P09P01A), `enter01` (P05P02A), `t02a0303` (P08P01A).
2. Donjon **D55** (Passage du Temps, 3 étages) — maps + 26 scripts.
3. **P05P02A2** (variante) + **7 décors** back2 non importés en .rsground.
4. **Portes/exits physiques** (8 connexions) — `REQUIRES_ROM_EXTRACTION`
   (table des grounds dans la ROM ; pmdsky n'expose pas la structure).
5. **8 BGM** (Planet's Paralysis, Oh No!, Time Gear, Memories Returned, On the
   Ceiling, In the Hands of Fate, Another Static Noise, Strong Blast Noise).
6. **25 SE** à mapper vers des assets PMDO.
7. S04P01A (hub du présent) — 21 scènes (partagées avec le jeu entier ; hors
   arc strict, à convertir seulement si le retour au présent est joué).

## VERDICT

**« ARC DU FUTUR COMPLÈTEMENT COUVERT : NON »**

Justification (basée sur les données NDS) : la couverture cinématique est
**incomplète** — 9 SSB sur 33 ne sont pas convertis (les entrées de zone et une
scène visuelle inédite découverte via le LSD p08p01a). Un **donjon entier**
(D55, Passage du Temps) fait partie du parcours et n'est pas converti. Les
**connexions physiques entre zones** (8 portes) sont dans la table des grounds
de la ROM, non extraite par pret/pmd-sky ni exposée par pmdsky-debug →
`REQUIRES_ROM_EXTRACTION`. 8 BGM et 25 SE restent à fournir. Le décor P05P02A2
et les 7 décors back2 sont extraits mais pas convertis.

Ce qui est couvert à 100 % : les 24 cinématiques (IR + Lua), les 8 grounds
principaux (importés), les SSA/LSD/enter.sse, les positions/entités/objets,
les tables anim (30/32) et SE (37/37 documentés).
