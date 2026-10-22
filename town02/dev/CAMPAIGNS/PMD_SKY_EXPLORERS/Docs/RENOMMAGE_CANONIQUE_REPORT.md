# Rapport de Renommage Canonique — MAP_BG PMD Sky (NDS) → PMDO

**Dépôt** : `meromoonmeri/PMD-SKY-PMDO-PORT` (branche `master`, commit `656a380`)
**Date** : 2026-08-06
**Portée** : identité des cartes UNIQUEMENT (nom de fichier + `AssetName` + `Name`).
**Aucune modification** des `.tile`, frames d'animation, collisions, layers ou dimensions.

---

## 1. Le mapping canonique (instruction utilisateur)

**AEGIS CAVE = groupe MAP_BG `d32`** (instruction explicite et répétée du porteur
de projet, avec exemple « d32p11a → aegis_cave_entrance, d32pXX →
aegis_cave_floor_XX »).

### ANCIEN NOM → NOUVEAU NOM → SOURCE DE VALIDATION

| Ancien (source MAP_BG) | Nouveau nom canonique | Nom EN | Source de validation |
|---|---|---|---|
| `d32p11a` | **`aegis_cave_entrance`** | Aegis Cave Entrance | Instruction projet (d32 = Aegis Cave, entrée) |
| `d32p12a` | **`aegis_cave_floor_01`** | Aegis Cave Floor 01 | Instruction projet (d32pXX → floor_XX) |
| `d32p13a` | **`aegis_cave_floor_02`** | Aegis Cave Floor 02 | idem |
| `d32p14a` | **`aegis_cave_floor_03`** | Aegis Cave Floor 03 | idem |
| `d32p31a` | **`aegis_cave_floor_04`** | Aegis Cave Floor 04 | idem |
| `d32p32a` | **`aegis_cave_floor_05`** | Aegis Cave Floor 05 | idem |
| `d32p33a` | **`aegis_cave_floor_06`** | Aegis Cave Floor 06 | idem |
| `d32p41a` | **`aegis_cave_floor_07`** | Aegis Cave Floor 07 | idem |
| `d32p42a` | **`aegis_cave_floor_08`** | Aegis Cave Floor 08 | idem |
| `d32p43a` | **`aegis_cave_floor_09`** | Aegis Cave Floor 09 | idem |
| `d32p44a` | **`aegis_cave_floor_10`** | Aegis Cave Floor 10 | idem |

> Les sheets `.tile` restent nommés d'après la source (`D32p11a_Base.tile`, …) —
> les tiles ne sont pas modifiés (règle). Chaque `.rsground` renommé référence
> toujours son sheet source.

## 2. Révocation des renommages spéculatifs (d54–d61)

Le précédent renommage avait attribué `aegis_cave_*` au groupe d54–d61, ce qui
est incorrect (Aegis Cave = d32). Retour aux **IDs source neutres** (aucune
identité canonique revendiquée) :

| Ancien (spéculatif) | Nouveau (neutre) |
|---|---|
| `aegis_cave_ice_1/2/3` | `d54p11a` / `d54p31a` / `d54p32a` |
| `aegis_cave_regice_1/2/3` | `d55p11a` / `d55p21a` / `d55p41a` |
| `aegis_cave_rock_1/2/3/4` | `d56p11a` / `d56p12a` / `d56p21a` / `d56p41a` |
| `aegis_cave_regirock_1..5` | `d57p21a` / `d57p41a` / `d57p42a` / `d57p43a` / `d57p44a` |
| `aegis_cave_steel_1` | `d58p41a` |
| `aegis_cave_registeel_1` | `d59p41a` |
| `aegis_cave_pit_1` | `d60p41a` |
| `aegis_cave_regigigas_1` | `d61p41a` |

## 3. Suppression des doublons (renommages spéculatifs antérieurs)

Des doublons existaient (le renommage git mv + une restauration antérieure) :
- `temporal_spire_1..4` (spéculatif sur d42) → **supprimés** ; conservés
  `d42p21a`, `d42p31a`, `d42p41a`, `d42p42a` (exports batch, IDs source).
- `test_dungeon_1/2` (spéculatif sur d00) → **supprimés** ; conservés
  `d00p01`, `d00p02` (exports batch, IDs source).

## 4. Conservé (bien étayé)

| Ground | Source | Justification |
|---|---|---|
| `waterfall_cave_1` | `d06p11a` | `DUNGEON_WATERFALL_CAVE = 6` (enum pret/pmd-sky) ; donjon 6 = son propre tileset (mappa) ; visuel grotte rocheuse |

## 5. État final (vérifié via API GitHub)

- Grounds : **459** (465 − 6 doublons supprimés)
- `aegis_cave_*` : **11** (entrance + floor_01..10), toutes `AssetName` == nom de fichier
- `temporal_spire_*`, `test_dungeon_*`, `d32p*` (source) : **absents** (renommés/supprimés)
- 0 référence de tuile invalide sur les cartes Aegis (vérifié au rendu)

## 6. Note de transparence

`include/enums.h` de pret/pmd-sky liste `DUNGEON_DUSK_FOREST = 32` et
`DUNGEON_ICE_AEGIS_CAVE = 54` (IDs internes de donjon). Le mapping demandé par
le projet (d32 = Aegis Cave) s'applique au **groupe MAP_BG** ; si vous
souhaitez recouper avec la table donjon→groupe de la ROM, fournissez-la et le
manifest sera ajusté. Les cartes d54–d61 restent en IDs source neutres,
prêtes à recevoir leur nom canonique une fois la table confirmée.

## 7. Preuves visuelles

`/home/user/preuves_sky/` (rendu depuis les fichiers finaux sur origin/master,
0 tuile manquante) :
- `aegis_cave_entrance.png` (1008×456)
- `aegis_cave_floor_01.png` (1008×456), `floor_03` (576×408), `floor_04` (912×456),
  `floor_07` (1440×960), `floor_10` (600×648)
- `waterfall_cave_1.png` (le vrai Waterfall Cave, d06)
