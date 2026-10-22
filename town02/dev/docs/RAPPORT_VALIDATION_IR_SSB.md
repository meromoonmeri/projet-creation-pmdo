# RAPPORT DE VALIDATION — IR CANONIQUE SSB — ARC DU FUTUR

Date : 2026-08-09 — Pipeline : `SSB original → header US → routines → opcodes+params → IR canonique JSON`

Aucune donnée Sky n'a été modifiée : l'IR est la représentation canonique **pure** du bytecode.
Le cast New Era (couche d'adaptation) est appliqué **après**, séparément.

## Récapitulatif

- Scènes : **24**
- Opérations totales : **7035**
- Constantes totales : **0**
- Strings totales : **1357**
- Paramètres non résolus : **0**
- Opcodes inconnus : **0**
- Énumérés non documentés (id valide, nom absent de la table XML) : **5**
- Toutes scènes OK : **OUI**

## Par scène

| Zone | Scène | Taille (o) | Routines | Ops | Const | Strings | End cursor | cursor==size | Opcodes inconnus | Params non résolus | Modèle | **OK** |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| P05P01A | m17a0103 | 706 | 1 | 59 | 0 | 10 | 706 | ✅ | 0 | 0 | ✅ | ✅ |
| P05P01A | m19a0102 | 530 | 1 | 56 | 0 | 8 | 530 | ✅ | 0 | 0 | ✅ | ✅ |
| P05P01A | n08a2008 | 2834 | 1 | 195 | 0 | 34 | 2834 | ✅ | 0 | 0 | ✅ | ✅ |
| P05P02A | m17a0104 | 1982 | 1 | 152 | 0 | 36 | 1982 | ✅ | 0 | 0 | ✅ | ✅ |
| P05P02A | m17a0201 | 394 | 1 | 18 | 0 | 6 | 394 | ✅ | 0 | 0 | ✅ | ✅ |
| P05P02A | m17a0301 | 4548 | 1 | 322 | 0 | 81 | 4548 | ✅ | 0 | 0 | ✅ | ✅ |
| P05P03A | m17a0302 | 15526 | 1 | 1651 | 0 | 212 | 15526 | ✅ | 0 | 0 | ✅ | ✅ |
| P05P03A | m26a06d3 | 1276 | 1 | 236 | 0 | 10 | 1276 | ✅ | 0 | 0 | ✅ | ✅ |
| P05P04A | m17a0401 | 2062 | 1 | 117 | 0 | 37 | 2062 | ✅ | 0 | 0 | ✅ | ✅ |
| P05P04A | m17a0403 | 860 | 1 | 84 | 0 | 15 | 860 | ✅ | 0 | 0 | ✅ | ✅ |
| P06P01A | m18a0401 | 15370 | 1 | 642 | 0 | 275 | 15370 | ✅ | 0 | 0 | ✅ | ✅ |
| P06P01A | m26a0614 | 418 | 1 | 32 | 0 | 6 | 418 | ✅ | 0 | 0 | ✅ | ✅ |
| P07P01A | m18b1401 | 12920 | 1 | 535 | 0 | 208 | 12920 | ✅ | 0 | 0 | ✅ | ✅ |
| P07P01A | m26a06e6 | 546 | 1 | 53 | 0 | 9 | 546 | ✅ | 0 | 0 | ✅ | ✅ |
| P08P01A | m19a0601 | 5812 | 1 | 389 | 0 | 90 | 5812 | ✅ | 0 | 0 | ✅ | ✅ |
| P08P01A | m19d0612 | 324 | 1 | 15 | 0 | 3 | 324 | ✅ | 0 | 0 | ✅ | ✅ |
| P08P01A | n08a2308 | 1878 | 1 | 206 | 0 | 20 | 1878 | ✅ | 0 | 0 | ✅ | ✅ |
| P08P01A | n08a2408 | 716 | 1 | 136 | 0 | 4 | 716 | ✅ | 0 | 0 | ✅ | ✅ |
| P08P01A | n08a2508 | 568 | 1 | 97 | 0 | 4 | 568 | ✅ | 0 | 0 | ✅ | ✅ |
| P08P01A | n08a2608 | 3002 | 1 | 359 | 0 | 36 | 3002 | ✅ | 0 | 0 | ✅ | ✅ |
| P09P01A | m19b1001 | 9282 | 1 | 776 | 0 | 150 | 9282 | ✅ | 0 | 0 | ✅ | ✅ |
| P09P01A | m19b1007 | 5554 | 1 | 545 | 0 | 69 | 5554 | ✅ | 0 | 0 | ✅ | ✅ |
| P09P01A | m19b1009 | 1988 | 1 | 239 | 0 | 20 | 1988 | ✅ | 0 | 0 | ✅ | ✅ |
| P09P01A | m19d1072 | 1050 | 1 | 121 | 0 | 14 | 1050 | ✅ | 0 | 0 | ✅ | ✅ |

## Énumérés non documentés (id numérique valide, nom absent de la table XML)

Valeur conservée telle quelle dans l'IR ; le convertisseur Lua devra les mapper
manuellement ou les signaler comme NON CONVERTIS.

| Scène | Op | Arg | Type | Valeur | Routine | Seq |
|---|---|---|---|---|---|---|
| P08P01A/m19a0601 | SetEffect | effect_id | Effect | 645 | 0 | 162 |
| P09P01A/m19b1001 | SetEffect | effect_id | Effect | 640 | 0 | 14 |
| P09P01A/m19b1007 | SetEffect | effect_id | Effect | 640 | 0 | 8 |
| P09P01A/m19b1009 | SetEffect | effect_id | Effect | 640 | 0 | 6 |
| P09P01A/m19b1009 | SetEffect | effect_id | Effect | 651 | 0 | 205 |

## Méthode

1. Header US (12 octets) : nb_constants, nb_strings, constant_strings_start, const_table_length, strings_EN, unknown.
2. `start_of_const_table = data_offset + u16*2` ; `nb_routines = u16`.
3. Table des routines : 6 octets/entrée (offset u16×2, type u16, linked u16).
4. Bytecode : `u16 opcode` + paramètres `u16` ; `-1` = longueur variable (préfixe u16).
5. Table d'offsets de constantes, constantes (chaînes), puis strings EN.
6. Résolution des paramètres : même sémantique que le désassembleur officiel (`ENUM_ARGUMENTS` : Entity/Object/Routine/Face/FaceMode/GameVar/Level/Menu/ProcessSpecial/Direction/Bgm/Effect ; `Number` point-fixe 1/256 ; `String`/`ConstString` ; `PositionMark` = 4 params).
7. Contre-vérification : modèle `Ssb` de skytemple-files (ops/constantes/strings/routines identiques).
8. `cursor == file_size` : le parseur doit consommer exactement le fichier, sans octet restant.

Fichiers IR : `docs/ssb_ir/<ZONE>_<scene>.json` (un par scène) + `docs/ssb_ir/_validation_summary.json`.