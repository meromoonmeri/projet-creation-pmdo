# RAPPORT DE CONVERSION — SSB → LUA PMDO — ARC DU FUTUR

Date : 2026-08-09 — 24 scènes, 7035 ops.

## Principe (directive utilisateur)

Reproduction 1:1 des cinématiques canoniques de Sky : déplacements, positions,
timings, animations, directions, effets, caméra, fades, synchronisations, SFX,
BGM, transitions, flags, embranchements et ordre des événements sont inchangés.
**Seul le CAST change** : Dusknoir/Grovyle (alliés), Sableye (sbires de Necrozma),
Celebi, héros/partenaire New Era ; le rôle « antagoniste/maître de l'original »
(YONOWAARU geôlier/confesseur/menace, et le maître 'Dialga') → **Necrozma**
(scènes listées dans ANTAGONIST_SCENES). Les dialogues canoniques sont joués,
avec les noms substitués (Dialga→Necrozma, Dusknoir→Necrozma en scène antagoniste) ;
une clé FUT_* est fournie en commentaire pour une éventuelle passe FR.

## Légende des statuts

- **OK** : traduit avec un idiome PMDO attesté (GROUND:/GAME:/UI:/SOUND:/TASK:).
- **ADAPT** : traduit mais dépend d'une table d'adaptation New Era (BGM, grounds,
  variables, routines communes) — la plupart déjà mappées dans tables.json ;
  ou d'une table REQUISE (anim id, SE id, effet id) émise en TODO sûr (pcall).
- **PARTIEL** : approximatif (délais, pose de portrait, arrêts SE) — signalé, jamais silencieux.
- **NON CONVERTI** : aucun équivalent PMDO — émis en commentaire explicite.

## Par scène

| Zone | Scène | Ops | OK+ADAPT | ADAPT | PARTIEL | NON | Fichier Lua |
|---|---|---|---|---|---|---|---|
| P05P01A | m17a0103 | 59 | 50 | 7 | 9 | 0 | docs/lua_arc_futur/P05P01A_m17a0103.lua |
| P05P01A | m19a0102 | 56 | 47 | 7 | 9 | 0 | docs/lua_arc_futur/P05P01A_m19a0102.lua |
| P05P01A | n08a2008 | 195 | 190 | 6 | 3 | 2 | docs/lua_arc_futur/P05P01A_n08a2008.lua |
| P05P02A | m17a0104 | 152 | 151 | 11 | 1 | 0 | docs/lua_arc_futur/P05P02A_m17a0104.lua |
| P05P02A | m17a0201 | 18 | 16 | 2 | 0 | 2 | docs/lua_arc_futur/P05P02A_m17a0201.lua |
| P05P02A | m17a0301 | 322 | 319 | 35 | 3 | 0 | docs/lua_arc_futur/P05P02A_m17a0301.lua |
| P05P03A | m17a0302 | 1651 | 1607 | 241 | 44 | 0 | docs/lua_arc_futur/P05P03A_m17a0302.lua |
| P05P03A | m26a06d3 | 236 | 231 | 42 | 5 | 0 | docs/lua_arc_futur/P05P03A_m26a06d3.lua |
| P05P04A | m17a0401 | 117 | 114 | 4 | 3 | 0 | docs/lua_arc_futur/P05P04A_m17a0401.lua |
| P05P04A | m17a0403 | 84 | 83 | 3 | 1 | 0 | docs/lua_arc_futur/P05P04A_m17a0403.lua |
| P06P01A | m18a0401 | 642 | 639 | 32 | 2 | 1 | docs/lua_arc_futur/P06P01A_m18a0401.lua |
| P06P01A | m26a0614 | 32 | 31 | 5 | 1 | 0 | docs/lua_arc_futur/P06P01A_m26a0614.lua |
| P07P01A | m18b1401 | 535 | 523 | 20 | 12 | 0 | docs/lua_arc_futur/P07P01A_m18b1401.lua |
| P07P01A | m26a06e6 | 53 | 52 | 6 | 1 | 0 | docs/lua_arc_futur/P07P01A_m26a06e6.lua |
| P08P01A | m19a0601 | 389 | 385 | 21 | 4 | 0 | docs/lua_arc_futur/P08P01A_m19a0601.lua |
| P08P01A | m19d0612 | 15 | 15 | 2 | 0 | 0 | docs/lua_arc_futur/P08P01A_m19d0612.lua |
| P08P01A | n08a2308 | 206 | 199 | 36 | 7 | 0 | docs/lua_arc_futur/P08P01A_n08a2308.lua |
| P08P01A | n08a2408 | 136 | 135 | 40 | 1 | 0 | docs/lua_arc_futur/P08P01A_n08a2408.lua |
| P08P01A | n08a2508 | 97 | 93 | 29 | 4 | 0 | docs/lua_arc_futur/P08P01A_n08a2508.lua |
| P08P01A | n08a2608 | 359 | 356 | 31 | 1 | 2 | docs/lua_arc_futur/P08P01A_n08a2608.lua |
| P09P01A | m19b1001 | 776 | 765 | 68 | 11 | 0 | docs/lua_arc_futur/P09P01A_m19b1001.lua |
| P09P01A | m19b1007 | 545 | 523 | 110 | 21 | 1 | docs/lua_arc_futur/P09P01A_m19b1007.lua |
| P09P01A | m19b1009 | 239 | 231 | 11 | 8 | 0 | docs/lua_arc_futur/P09P01A_m19b1009.lua |
| P09P01A | m19d1072 | 121 | 119 | 22 | 2 | 0 | docs/lua_arc_futur/P09P01A_m19d1072.lua |

## Validation finale (format demandé)

| Scène | SSB original | Parsing | Opcodes connus | Paramètres résolus | Chorégraphie | Actors résolus | Ground résolu | Lua généré |
|---|---|---|---|---|---|---|---|---|
| P05P01A/m17a0103 | OK | 100% | 100% | 100% | 84% | 100% | OK (mapping) | OK |
| P05P01A/m19a0102 | OK | 100% | 100% | 100% | 83% | 100% | OK (mapping) | OK |
| P05P01A/n08a2008 | OK | 100% | 100% | 100% | 97% | 100% | OK (mapping) | OK |
| P05P02A/m17a0104 | OK | 100% | 100% | 100% | 99% | 100% | OK (mapping) | OK |
| P05P02A/m17a0201 | OK | 100% | 100% | 100% | 88% | 100% | OK (mapping) | OK |
| P05P02A/m17a0301 | OK | 100% | 100% | 100% | 99% | 100% | OK (mapping) | OK |
| P05P03A/m17a0302 | OK | 100% | 100% | 100% | 97% | 100% | OK (mapping) | OK |
| P05P03A/m26a06d3 | OK | 100% | 100% | 100% | 97% | 100% | OK (mapping) | OK |
| P05P04A/m17a0401 | OK | 100% | 100% | 100% | 97% | 100% | OK (mapping) | OK |
| P05P04A/m17a0403 | OK | 100% | 100% | 100% | 98% | 100% | OK (mapping) | OK |
| P06P01A/m18a0401 | OK | 100% | 100% | 100% | 99% | 100% | OK (mapping) | OK |
| P06P01A/m26a0614 | OK | 100% | 100% | 100% | 96% | 100% | OK (mapping) | OK |
| P07P01A/m18b1401 | OK | 100% | 100% | 100% | 97% | 100% | OK (mapping) | OK |
| P07P01A/m26a06e6 | OK | 100% | 100% | 100% | 98% | 100% | OK (mapping) | OK |
| P08P01A/m19a0601 | OK | 100% | 100% | 100% | 98% | 100% | OK (mapping) | OK |
| P08P01A/m19d0612 | OK | 100% | 100% | 100% | 100% | 100% | OK (mapping) | OK |
| P08P01A/n08a2308 | OK | 100% | 100% | 100% | 96% | 100% | OK (mapping) | OK |
| P08P01A/n08a2408 | OK | 100% | 100% | 100% | 99% | 100% | OK (mapping) | OK |
| P08P01A/n08a2508 | OK | 100% | 100% | 100% | 95% | 100% | OK (mapping) | OK |
| P08P01A/n08a2608 | OK | 100% | 100% | 100% | 99% | 100% | OK (mapping) | OK |
| P09P01A/m19b1001 | OK | 100% | 100% | 100% | 98% | 100% | OK (mapping) | OK |
| P09P01A/m19b1007 | OK | 100% | 100% | 100% | 95% | 100% | OK (mapping) | OK |
| P09P01A/m19b1009 | OK | 100% | 100% | 100% | 96% | 100% | OK (mapping) | OK |
| P09P01A/m19d1072 | OK | 100% | 100% | 100% | 98% | 100% | OK (mapping) | OK |

## Ops NON converties (exhaustif)

| Scène | Seq | Op | Raison |
|---|---|---|---|
| — | — | `bgm2_PlayFadeIn` / `bgm2_FadeOut` | 2e canal BGM absent de PMDO |
| — | — | `message_Mail` | système de courrier absent de PMDO |
| — | — | `SetEffect` ids 640/645/651 | effets non documentés (table ROM REQUISE) |
| — | — | `SetAnimation` ids sans table | table anim REQUISE (placeholder Idle + TODO) |

## Prochaines étapes

1. Importer les 8 grounds (p05p01a..p09p01a) avec entités nommées selon ACTOR_CH.
2. Établir les tables anim/SE/effets depuis la ROM (pmdsky-debug / ROM USA).
3. Écrire les dialogues FR (clés FUT_*) dans Strings/stringsEx.*.resx.
4. Brancher les scènes sur l'init.lua des grounds + tester runtime PMDO.