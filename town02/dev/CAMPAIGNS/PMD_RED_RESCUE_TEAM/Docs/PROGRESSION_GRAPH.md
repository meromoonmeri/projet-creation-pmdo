# Graphe de progression — PMD Red Rescue Team (EU)

Deux faces séparées : opcodes scénario décodés de la ROM EU (69 stations exactes) et chaîne EVENT_* pret (TECHNICAL_REFERENCE).

- Écritures scénario ROM : **6** ; gardes : **24** ; checks de quête : **2**
- Événements pret (référence) : **226**, états SCENARIO_MAIN posés : **121**

## États SCENARIO_MAIN de la chaîne pret (annotation humaine)

| État | Annotation pret | Événement |
|---|---|---|
| `19.2` | — | FORMATION_HERO |
| `1.0` | — | EVENT_DIVIDE |
| `58.1` | — | EVENT_DIVIDE |
| `19.1` | — | EVENT_DIVIDE_NEXT_DAY_FUNC |
| `19.1` | — | EVENT_DIVIDE_NEXT_DAY2_FUNC |
| `2.1` | — | EVENT_DIVIDE_FIRST |
| `3.1` | — | EVENT_DIVIDE_FIRST |
| `4.1` | — | EVENT_DIVIDE_FIRST |
| `5.1` | ??? See QUEST_CAN_RECRUIT also | EVENT_DIVIDE_FIRST |
| `6.1` | — | EVENT_DIVIDE_FIRST |
| `7.1` | — | EVENT_DIVIDE_FIRST |
| `8.1` | — | EVENT_DIVIDE_FIRST |
| `9.1` | — | EVENT_DIVIDE_FIRST |
| `10.1` | — | EVENT_DIVIDE_FIRST |
| `11.1` | — | EVENT_DIVIDE_SECOND |
| `12.1` | — | EVENT_DIVIDE_SECOND |
| `13.1` | — | EVENT_DIVIDE_SECOND |
| `14.1` | — | EVENT_DIVIDE_SECOND |
| `15.1` | — | EVENT_DIVIDE_SECOND |
| `16.1` | — | EVENT_DIVIDE_SECOND |
| `17.1` | — | EVENT_DIVIDE_SECOND |
| `18.1` | — | EVENT_DIVIDE_AFTER |
| `19.1` | — | EVENT_DIVIDE_AFTER |
| `20.1` | — | EVENT_DIVIDE_AFTER |
| `21.1` | — | EVENT_DIVIDE_AFTER |
| `22.1` | — | EVENT_DIVIDE_AFTER |
| `23.1` | — | EVENT_DIVIDE_AFTER |
| `24.1` | — | EVENT_DIVIDE_AFTER |
| `25.1` | — | EVENT_DIVIDE_AFTER |
| `26.1` | — | EVENT_DIVIDE_AFTER |
| `27.1` | ??? Set from EVENT_DIVIDE_AFTER | EVENT_DIVIDE_AFTER |
| `2.0` | — | EVENT_M00E01A_L001 |
| `3.0` | Chose team name. See QUEST_SET_TEAM_NAME. Set in EVENT_M01E01A_L003 | EVENT_M01E01A_L003 |
| `3.2` | — | EVENT_M01E02A_L001 |
| `3.3` | ??? Bed tutorial related. | EVENT_M01E02A_L001B |
| `3.4` | ??? See QUEST_UNK1 also | EVENT_M01E02A_L001C |
| `3.5` | — | EVENT_M01E02A_L002 |
| `3.6` | ??? Thunderwave cave related | EVENT_M01E02A_L003 |
| `4.0` | ??? Set upon exiting Thunderwave Cave. | EVENT_M01E02A_L006 |
| `4.2` | — | EVENT_M01E02B_L001 |
| `4.3` | — | EVENT_M01E02B_L002 |
| `4.4` | ??? See QUEST_CAN_ACCESS_JOBS also | EVENT_M01E02B_L003 |
| `4.5` | ??? Mt Steel related | EVENT_M01E02B_L004 |
| `4.6` | — | EVENT_M01E02B_L004B |
| `5.0` | — | EVENT_M01E02B_L008 |
| `5.1` | ??? See QUEST_CAN_RECRUIT also | EVENT_M01E03A_L000 |
| `5.2` | — | EVENT_M01E03A_L001 |
| `5.3` | — | EVENT_M01E03A_L002 |
| `5.5` | ??? See QUEST_UNK10 and QUEST_UNK11 also | EVENT_M01E03A_L003 |
| `5.6` | — | EVENT_M01E03A_L004 |
| `5.7` | ??? See QUEST_MAZE_14 also | EVENT_M01E03A_L005 |
| `5.8` | — | EVENT_M01E03A_L006 |
| `5.9` | ??? Sinister Woods related | EVENT_M01E03A_L007 |
| `6.0` | — | EVENT_M01E03A_L011 |
| `6.1` | — | EVENT_M01E04A_L000 |
| `6.2` | — | EVENT_M01E04A_L001 |
| `6.3` | ??? Silent Chasm related | EVENT_M01E04A_L002 |
| `7.0` | — | EVENT_M01E04A_L006 |
| `7.1` | — | EVENT_M01E04B_L000 |
| `7.2` | — | EVENT_M01E04B_L001 |
| `7.3` | ??? Mt Thunder related | EVENT_M01E04B_L002 |
| `8.0` | ??? See QUEST_LEGEND_ZAPDOS also | EVENT_M01E04B_L007 |
| `8.1` | — | EVENT_M01E05A_L000 |
| `8.2` | — | EVENT_M01E05A_L001 |
| `8.3` | ??? Great Canyon related | EVENT_M01E05A_L002 |
| `9.0` | — | EVENT_M01E05A_L006 |
| `9.1` | — | EVENT_M01E05B_L000 |
| `9.2` | — | EVENT_M01E05B_L001 |
| `9.3` | — | EVENT_M01E05B_L002 |
| `9.4` | — | EVENT_M01E05B_L003 |
| `9.5` | — | EVENT_M01E05B_L004 |
| `10.0` | — | EVENT_M01E05B_L005 |
| `10.2` | — | EVENT_M01E06A_L001 |
| `10.3` | — | EVENT_M01E06A_L002 |
| `11.0` | Fugitive story begins. See QUEST_SQUARE_ASLEEP also | EVENT_M01E06A_L003 |
| `11.2` | ??? See QUEST_UNK12 also | EVENT_M01E07A_L001 |
| `11.4` | ??? See QUEST_UNK5 also | EVENT_M01E07A_L002 |
| `12.0` | Lapis Cave completed? Mt Blaze story begins? | EVENT_M01E07A_L005 |
| `12.2` | — | EVENT_M01E07B_L001 |
| `13.0` | Mt Blaze completed. Frosty Grotto story begins. See QUEST_SQUARE_ASLEEP and QUEST_LEGEND_MOLTRES also | EVENT_M01E07B_L005 |
| `13.2` | — | EVENT_M01E08A_L001 |
| `14.0` | Frosty Grotto completed. Mt Freeze story begins? See QUEST_LEGEND_ARTICUNO also | EVENT_M01E08A_L005 |
| `14.2` | — | EVENT_M01E08B_L001 |
| `15.0` | Mt Freeze completed? See QUEST_UNK5 and QUEST_MAZE_14 also | EVENT_M01E08B_L006 |
| `15.2` | — | EVENT_M01E09A_L001 |
| `15.3` | — | EVENT_M01E09A_L002 |
| `15.4` | — | EVENT_M01E09A_L003 |
| `15.5` | ??? Uproar Forest related | EVENT_M01E09A_L004 |
| `15.6` | — | EVENT_M01E09A_L005 |
| `15.7` | — | EVENT_M01E09A_L006 |
| `15.8` | — | EVENT_M01E09A_L007 |
| `15.9` | — | EVENT_M01E09A_L008 |
| `15.10` | ??? Magma Cavern related | EVENT_M01E09A_L009 |
| `15.11` | ??? Magma Cavern related | EVENT_M01E09A_L010 |
| `16.0` | Magma Cavern completed. Sky Tower story begins. See QUEST_LEGEND_GROUDON also | EVENT_M01E09A_L015 |
| `16.1` | — | EVENT_M01E10A_L001 |
| `16.2` | World calamity music is forced. Partner awaits in Pokémon Square for you to confirm you're ready for Sky Tower. You begin dreaming with Gardevoir and Gengar is there. See QUEST_IN_WORLD_CALAMITY | EVENT_M01E10A_L001 |
| `16.3` | — | EVENT_M01E10A_L002 |
| `16.4` | ??? Sky Tower related | EVENT_M01E10A_L003 |
| `17.0` | Sky Tower completed. See QUEST_LEGEND_RAYQUAZA also | EVENT_M01E10A_L008 |
| `18.0` | ??? See QUEST_REACHED_POSTGAME also | EVENT_M01END_L001 |
| `18.0` | ??? See QUEST_REACHED_POSTGAME also | EVENT_M01END_L002 |
| `18.2` | ??? See QUEST_UNLOCKED_EVOLUTIONS also | EVENT_M02E01A_L001 |
| `18.3` | ??? See QUEST_CAN_CHANGE_LEADER also | EVENT_M02E01A_L002 |
| `18.4` | — | EVENT_M02E01A_L003 |
| `19.2` | — | EVENT_M02E02A_L001 |
| `20.2` | — | EVENT_M02E02B_L001 |
| `21.2` | — | EVENT_M02E02C_L001 |
| `22.2` | — | EVENT_M02E02D_L001 |
| `23.2` | — | EVENT_M02E02E_L001 |
| `24.2` | — | EVENT_M02E02F_L001 |
| `25.2` | — | EVENT_M02E02G_L001 |
| `26.2` | — | EVENT_M02E02H_L001 |
| `27.2` | — | EVENT_M02END_L001 |
| `15.5` | ??? Uproar Forest related | EVENT_S01E01A_L001 |
| `2.2` | ??? Set upon exiting Tiny Woods. | GETOUT_M01E01A |
| `4.7` | — | GETOUT_M01E02B |
| `4.8` | — | GETOUT_M01E02B |
| `5.10` | — | GETOUT_M01E03A |
| `5.11` | — | GETOUT_M01E03A |
| `6.3` | ??? Silent Chasm related | GETOUT_M01E04A |
| `7.4` | — | GETOUT_M01E04B |
| `7.5` | — | GETOUT_M01E04B |
| `8.4` | — | GETOUT_M01E05A |
| `11.5` | — | GETOUT_M01E07A |
| `12.3` | — | GETOUT_M01E07B |
| `12.4` | — | GETOUT_M01E07B |
| `13.3` | — | GETOUT_M01E08A |
| `13.4` | — | GETOUT_M01E08A |
| `14.3` | — | GETOUT_M01E08B |
| `15.12` | — | GETOUT_M01E09A |
| `15.9` | — | GETOUT_M01E09A |
| `16.5` | — | GETOUT_M01E10A |
| `16.6` | — | GETOUT_M01E10A |
| `19.1` | — | GETOUT_U00E01A |
| `19.1` | — | GETOUT_T00E01A |
