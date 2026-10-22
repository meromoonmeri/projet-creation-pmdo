# Cinématiques de donjon PMD Red

Ces modules C forment un périmètre séparé des 133 stations Ground. Le moteur commun `dungeon_cutscene.c` est inclus. Chaque module possède exactement une classe principale; les indicateurs secondaires signalent ses autres contraintes.

| Module | Source | Classe principale | Cible Ground suggérée | Acteurs | Musiques | Dialogues | Indicateurs secondaires |
|---|---|---|---|---:|---:|---:|---|
| `engine_core` | `src/dungeon_cutscene.c` | **DÉPENDANCE** | `—` | 18 | 0 | 0 | — |
| `articuno` | `src/dungeon_cutscene_articuno.c` | **CONFLIT** | `d10p03` | 1 | 2 | 0 | ADAPTÉ + DÉPENDANCE |
| `celebi` | `src/dungeon_cutscene_celebi.c` | **PORTÉ** | `—` | 1 | 1 | 0 | DÉPENDANCE |
| `deoxys` | `src/dungeon_cutscene_deoxys.c` | **PORTÉ** | `d22p01` | 1 | 2 | 0 | DÉPENDANCE |
| `empty_summit` | `src/dungeon_cutscene_empty_summit.c` | **PORTÉ** | `—` | 0 | 0 | 0 | DÉPENDANCE |
| `entei` | `src/dungeon_cutscene_entei.c` | **PORTÉ** | `d16p01` | 1 | 2 | 0 | DÉPENDANCE |
| `groudon` | `src/dungeon_cutscene_groudon.c` | **CONFLIT** | `d12p04` | 2 | 2 | 0 | ADAPTÉ + DÉPENDANCE |
| `hooh` | `src/dungeon_cutscene_hooh.c` | **PORTÉ** | `d19p01` | 1 | 2 | 0 | DÉPENDANCE |
| `jirachi` | `src/dungeon_cutscene_jirachi.c` | **PORTÉ** | `d23p01` | 1 | 2 | 0 | DÉPENDANCE |
| `kyogre` | `src/dungeon_cutscene_kyogre.c` | **PORTÉ** | `d14p01` | 2 | 2 | 0 | DÉPENDANCE |
| `latios` | `src/dungeon_cutscene_latios.c` | **PORTÉ** | `d21p01` | 1 | 2 | 0 | DÉPENDANCE |
| `lugia` | `src/dungeon_cutscene_lugia.c` | **PORTÉ** | `d15p01` | 1 | 2 | 0 | DÉPENDANCE |
| `magma_cavern` | `src/dungeon_cutscene_magma_cavern.c` | **CONFLIT** | `d12p02` | 2 | 0 | 0 | ADAPTÉ + DÉPENDANCE |
| `mankey` | `src/dungeon_cutscene_mankey.c` | **PORTÉ** | `—` | 0 | 1 | 0 | DÉPENDANCE |
| `meanies` | `src/dungeon_cutscene_meanies.c` | **PORTÉ** | `d04p02` | 3 | 2 | 0 | DÉPENDANCE |
| `medicham` | `src/dungeon_cutscene_medicham.c` | **PORTÉ** | `—` | 1 | 1 | 0 | DÉPENDANCE |
| `mewtwo` | `src/dungeon_cutscene_mewtwo.c` | **PORTÉ** | `d20p01` | 1 | 2 | 0 | DÉPENDANCE |
| `moltres` | `src/dungeon_cutscene_moltres.c` | **CONFLIT** | `d09p03` | 1 | 2 | 0 | ADAPTÉ + DÉPENDANCE |
| `no_one_here` | `src/dungeon_cutscene_no_one_here.c` | **PORTÉ** | `—` | 0 | 0 | 0 | DÉPENDANCE |
| `raikou` | `src/dungeon_cutscene_raikou.c` | **PORTÉ** | `d17p01` | 1 | 2 | 0 | DÉPENDANCE |
| `rayquaza` | `src/dungeon_cutscene_rayquaza.c` | **CONFLIT** | `d13p03` | 1 | 3 | 0 | ADAPTÉ + DÉPENDANCE |
| `regis` | `src/dungeon_cutscene_regis.c` | **PORTÉ** | `—` | 3 | 2 | 0 | DÉPENDANCE |
| `skarmory` | `src/dungeon_cutscene_skarmory.c` | **PORTÉ** | `d03p02` | 2 | 2 | 0 | DÉPENDANCE |
| `smeargle` | `src/dungeon_cutscene_smeargle.c` | **PORTÉ** | `—` | 1 | 1 | 0 | DÉPENDANCE |
| `suicune` | `src/dungeon_cutscene_suicune.c` | **PORTÉ** | `d18p01` | 1 | 2 | 0 | DÉPENDANCE |
| `zapdos` | `src/dungeon_cutscene_zapdos.c` | **PORTÉ** | `d06p03` | 2 | 3 | 0 | DÉPENDANCE |

## Règle de portage

1. ne pas injecter ces séquences dans les Grounds certifiés ;
2. établir le point d’appel exact du moteur de donjon ;
3. porter branche, caméra, animation, VFX, SFX, musique et timing comme une unité ;
4. valider les états avant/après combat, victoire, défaite et retour ;
5. protéger toute cible déjà routée par `FugitiveArc` sous un namespace parallèle.
