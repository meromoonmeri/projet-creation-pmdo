# AUDIT DÉFINITIF — DONJONS DU PARCOURS FUTUR (NDS → PMDO)

Date : 2026-08-09 — Branche `arena/019fd882-new-era-abyss-to-ascension-v4`
Méthode : scan data-driven des 3760 SSB + DUNGEON_DATA_LIST (ROM) + mappa_s.bin
(handler officiel skytemple) + dialogues/acteurs des scènes. Aucune liste a priori.

## RÉVÉLATION MAJEURE — LE PARCOURS FUTUR CONTIENT 6 DONJONS

Le **main story** (héros + partenaire + Grovyle, dans le futur corrompu) traverse
**6 vrais donjons jouables**, prouvés par les données :

| Dungeon ID | Nom (BGM/dialogue NDS) | Floors | Groupe mappa | Map fixe | Étage(s) fixe(s) |
|---|---|---|---|---|---|
| **27** | **Chasm Cave** | **8** | 18 | D18P11A | m17a0501/0504/0601/0701 |
| **28** | **Dark Hill** | **15** | 19 | D19P11A | m18a0101/0201/0301 |
| **29** | **Sealed Ruin** | **8** | 20 | D20P11A | m18b0501/0601/0701 |
| **30** | **Sealed Ruin Pit** | **6** | 20 (prec 8) | D21P21A | m18b0801/0901/1002 |
| **31** | Salle SPIRITOMB (boss) | **1** | 20 (prec 14) | D21P41A | m18b0902/1101/1201/1301 |
| **32** | **Dusk Forest** | **8** | 21 | D22P11A | m19a0201/0301/0401/0403/0501 |

Preuves :
- `D18P11A/m17a0601 → main_EnterDungeon(27)` ; `D19P11A/m18a0201 → (28)` ;
  `D20P11A/m18b0601 → (29)` ; `D21P21A/m18b0801 → (30)` ; `D21P41A/m18b1101,1201 → (31)` ;
  `D22P11A/m19a0301,0403 → (32)`.
- BGM des scènes : InTheFuture (futur) puis **ChasmCave / DarkHill / SealedRuin /
  SealedRuinPit / DuskForest** — noms des donjons du parcours.
- Dialogues : « Why did Dusknoir bring us here? » (D19P11A) ; « This is Dusk
  Forest. Its name comes from the dark fog » (D22P11A) ; Spiritomb timide
  (D21P41A) — pas un boss, la scène de confiance avec Grovyle.
- Acteurs : PLAYER + ATTENDANT1 + JUPUTORU (Grovyle) dans toutes les scènes →
  MAIN STORY, pas SE5.

## RÉPONSES AUX QUESTIONS

**A. Vrais donjons du parcours** : 6 (Chasm Cave, Dark Hill, Sealed Ruin,
Sealed Ruin Pit, salle Spiritomb, Dusk Forest) — dungeons 27-32.

**B. Floors par dungeon** : 27=8, 28=15, 29=8, 30=6, 31=1, 32=8 (total 46 floors).

**C. Dark Hill appartient-il au parcours ?** **OUI** — dungeon 28, 15 floors,
entré depuis D19P11A/m18a0201, BGM DarkHill, acteurs du trio. (Le user avait raison.)

**D. Chasm Cave appartient-il au parcours ?** **OUI** — dungeon 27, 8 floors,
entré depuis D18P11A/m17a0601, BGM ChasmCave.

**E. Structure du Passage du Temps** : le dungeon **140** (D55P41A, 1 floor fixe,
fixed_floor_id=34, tileset 187) est le donjon du **Special Episode 5** (future
hero + Dusknoir), entré depuis P08P01A/n08a2308 — scénario **séparé** du main
story. D55P11A/D55P21A = dungeons 138 (10f) et 139 (7f) = SE5 aussi.

**F. Tilesets NDS par floor** : voir matrice ci-dessous (tileset_id mappa_s →
dungeon{id}.dpc/.dpl/.dma).

**G. BMA/BPC/BPL** : les maps fixes D18-D22 ont BMA/BPC/BPL dans pret/pmd-sky
+ .rsground dans le port (téléchargés). Les floors procéduraux utilisent les
.dpc/.dpl/.dma de dungeon.bin (pas de BMA).

**H. Tables de génération** : extraites de mappa_s.bin (voir détail).

## MATRICE FLOORS (données mappa_s.bin)

### Dungeon 27 = Chasm Cave (groupe 18)
| F | tileset | music | struct | room_dens | en_dens | item | trap | dark | ennemis (md@Lv:weight) |
|---|---|---|---|---|---|---|---|---|---|
| 1-4 | 26 | 19 | 6/4 | 8 | 4 | 3 | 6 | 2 | 81@28, 132@28, 254@28, 354@26, 467@28 |
| 5 | 27 | 19 | 4 | 8 | 5 | 3 | 6 | 2 | 81, 95, 132, 254, 354, 468 |
| 6-8 | 27 | 19 | 4/6 | 8 | 5 | 3 | 6 | 2 | 82, 95, 132, 354, 468 |

### Dungeon 28 = Dark Hill (groupe 19) — 15 floors
| F | tileset | struct | en_dens | ennemis |
|---|---|---|---|---|
| 1-5 | 28 | 1/11 | 3-4 | 92@30, 200@30, 386@30, 514@28 |
| 6 | 28 | 9 | 4 | +372@31 |
| 7-8 | 29 | 1/11 | 5 | 93@31, 200, 372, 386, 514 |
| 9-11 | 29 | 11/9 | 5 | 93, 372, 388, 514 |
| 12-15 | 29 | 1/11 | 5 | 94@32-33, 372, 388, 514 |

### Dungeon 29 = Sealed Ruin (groupe 20) — 8 floors
tileset 30, music 21, en_dens 4-5, item 3-4, trap 6, **monster_house 5%**
ennemis : 89, 232, 404, 407, 507, 518 (L27-31)

### Dungeon 30 = Sealed Ruin Pit (groupe 20, prec 8) — 6 floors
tileset 31, music 22, en_dens 5, item 4, trap 6, monster_house 5%
ennemis : 89, 232, 404, 407, 507, 518 (L28-32)

### Dungeon 31 = salle Spiritomb (groupe 20, prec 14) — 1 floor FIXE
tileset 176, fixed_floor_id=7, **1 ennemi : 484@L51 (weight 10000)**

### Dungeon 32 = Dusk Forest (groupe 21) — 8 floors
tilesets 33→34 (F5), music 23, dark 2 (F6-8), trap 8 (F7-8)
ennemis : 189@33, 453@30, 471@31, 486@33

(items : ~102-112 entrées/floor ; traps : table standard 25 poids.)

## SCÉNARIOS — SÉPARATION STRICTE

| Élément | Main story (trio) | SE5 (future hero) | SE4 (Team Charm) |
|---|---|---|---|
| Dungeons 27-32 (D18-D22) | **OUI** (m17a-m19a*) | n08a* dans D22P11A (partagé) | — |
| Dungeon 140 (D55P41A) | NON | **OUI** (n08a2308/2508) | — |
| Dungeons 138/139 (D55P11A/21A) | NON | OUI (n08a2108, n08a1808) | — |
| Dungeons D46-D53 (n08a*) | NON | OUI | — |
| Dungeons 143-165 (D56-D63) | NON | NON | OUI (Team Charm) |
| Dungeon 31 = Spiritomb | OUI (scène de confiance) | — | — |

## ARCHITECTURE PMDO — ÉTAT RÉEL

| Dungeon | PMDO Zone | Floors | Maps fixes (.rsground) | Tilesets | Statut |
|---|---|---|---|---|---|
| 27 Chasm Cave | ❌ absent | ❌ | D18p11a.rsground ✅ (importé) | D18p11a_Base.tile ✅ | **MISSING (Zone)** |
| 28 Dark Hill | ❌ absent | ❌ | D19p11a.rsground ✅ | D19p11a_Base.tile ✅ | **MISSING (Zone)** |
| 29 Sealed Ruin | ❌ absent | ❌ | D20p11a.rsground ✅ | D20p11a_Base.tile ✅ | **MISSING (Zone)** |
| 30 SR Pit | ❌ absent | ❌ | D21p21a.rsground ✅ | D21p21a_Base.tile ✅ | **MISSING (Zone)** |
| 31 Spiritomb | ❌ absent | ❌ | D21p41a.rsground ✅ | D21p41a_Base.tile ✅ | **MISSING (Zone)** |
| 32 Dusk Forest | ❌ absent | ❌ | D22p11a.rsground ✅ | D22p11a_Base.tile ✅ | **MISSING (Zone)** |

**CONCLUSION ARCHITECTURALE** : les 6 donjons du parcours futur ne sont PAS
encore créés comme Zones PMDO. Les maps fixes et tilesets sont importés
(prêts), mais il manque : Data/Zone/{chasm_cave,dark_hill,sealed_ruin,
sealed_ruin_pit,mismagius_room,dusk_forest}.json + GenSteps (46 floors de
génération) + script de zone + tables d'ennemis/items/traps + branchement.

Le runner `FutureArc.Play` ne peut PAS simuler ces donjons : il orchestre les
cinématiques, mais chaque dungeon doit être une Zone PMDO native
(Zone → Segment → Floors → GenSteps → spawns) pour être jouable.

## ÉLÉMENTS BLOQUÉS

- **6 Zones donjon** à créer (MISSING — le cœur du travail restant).
- **Ennemis** : md_index → espèce : table monster.md (REQUIRES_EXTRACTION —
  les md_index + niveaux + poids sont extraits ; le boss du dungeon 31 est
  CONFIRMÉ = SPIRITOMB par l'entité script NPC_MIKARUGE (ミカルゲ) des scènes
  D21P41A, seule entité de l'arène fixe 7, placée à (8,2) = (324,196) px).
- **Tilesets de donjon** (dungeon26-34.dpc/.dpl/.dma) : conversion vers les
  auto-tilesets PMDO (REQUIRES_ASSET).
- **BGM** : ChasmCave/DarkHill/SealedRuin/SealedRuinPit/DuskForest → .ogg
  (REQUIRES_ASSET — vérifier présence dans Content/Music).
- **SE** : table NDS documentée (37 ids), 12 mappés, 25 à mapper.
- **D55 (SE5)** : zone passage_temps.json créée mais c'est le SE5 — hors
  main story ; à garder séparé.

## VERDICT

**COUVERTURE NDS : COMPLÈTE** (6 donjons + 46 floors + maps fixes + tables
prouvés). **INTÉGRATION PMDO : INCOMPLÈTE** — les 6 Zones donjon restent à
créer (les assets maps fixes + tilesets sont prêts). Le D55 (SE5) est séparé.
**RUNTIME : NON VÉRIFIÉ**.
