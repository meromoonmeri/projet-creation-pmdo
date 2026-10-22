# Comparaison manifest v2 (commit 9583f6c0) vs v3 (session courante)

Le v2 était AUDIT_PASS mais l'audit lui-même documentait des trous majeurs :
cinématiques Sky à 0 %, dialogues Red absents, doublons LOW non confirmés,
aucun graphe de progression, aucune matrice de couverture §49. Le v3 comble
ces trous **à la source** (ROM EU vérifiées), sans toucher au canon.

## Ce que le v2 laissait ouvert — et ce que le v3 apporte

| Trou du v2 | Apport v3 | Preuve |
|---|---|---|
| SKY `cinematic_linked_pct = 0.0` — « scripts SSB de la NDS non extraits, REVIEW_REQUIRED » | ROM Sky EU restaurée (sha256 `1fa39d35…` = pointeur LFS exact, code jeu C2SP) ; **3760/3760 SSB décompilés en ExplorerScript avec dialogues 5 langues, 1884/1884 SSA/SSE/SSS (placements acteurs), 315/315 LSD — 0 FAIL, 0 PARTIAL** ; liaison level→MAP_BG (`LEVEL_MAP_LINKS.json`) → **cinematic_linked 73,0 %** (336/460 grounds, 322/323 zones SCRIPT liées, COMMON=global) | `Cinematics/ROM_SCRIPTS_INDEX.json`, `rom_scripts/*.json.gz` (323 archives) |
| RED : cif.json comptaient les boîtes de dialogue mais **aucun texte** | ROM Red EU restaurée (sha256 `0f9d125d…`) ; extraction `--all-stations` : **69 stations au graphe EU exact, 3073 blocs de texte 5 langues (en/fr/de/es/it)** avec adresses ROM + raw_hex, ordre des opérations de script préservé ; 64 stations **REVIEW_REQUIRED** (honnête, pas un PASS) | `Cinematics/DIALOGUES_INDEX.json`, `dialogues/*.json.gz` |
| 34 LOW Red + 26 LOW Sky « doublons à confirmer une à une » | Contre-épreuve **automatisée dans l'outil d'audit** : Layers normalisés par hash pixel des planches + projection première frame → 24 groupes Red et 26 groupes Sky **CONFIRMÉS canoniques (ACCEPTED avec preuve)** ; le test a d'abord produit 25 HIGH « sources diffèrent » qui ont exigé l'affinage première-frame (variantes animées d53p41a/b, v00p01/v01p07b) — l'outil est plus fiable qu'avant, pas plus complaisant | `AUDIT.json` catégorie DUPLICATE, `_source_duplicate_verdict()` |
| Aucun graphe de progression (§36) | **Sky** : 245 états `$SCENARIO_MAIN` écrits / 223 lus, 97 bit flags, 1219 déclencheurs de scène, atteignabilité vérifiée (1 seul état lu-jamais-écrit : 0.0 = init sauvegarde). **Red** : face ROM EU (écritures/gardes décodées des 69 stations) + chaîne EVENT_* pret (226 events, 121 états annotés) en statut **TECHNICAL_REFERENCE séparé** | `Docs/PROGRESSION_GRAPH.json/.md` × 2 |
| Aucune matrice §49 | Matrice de couverture par dimension (extraction / render / frames / runtime / cinématique / dialogues / cast / progression / donjons / audit), statuts stricts PASS/PARTIAL/NOT_TESTED/TECHNICAL_REFERENCE, **jamais fusionnés** | `COVERAGE_MATRIX.md` + `Docs/COVERAGE_MATRIX.json` × 2 |

## Couvertures (séparées — jamais fusionnées)

| Mesure | RED v2 | RED v3 | SKY v2 | SKY v3 |
|---|---|---|---|---|
| render_pct | 100,0 | 100,0 | 99,8 | 99,8 |
| frames_full_pct | 100,0 | 100,0 | 99,8 | 99,8 |
| cinematic_linked_pct | 52,0 | 52,0 | **0,0** | **73,0** |
| dialogues 5 langues | 0 station | **69 stations / 3073 blocs** | — (inclus dans SSB) | **3760 SSB avec strings** |
| progression | — | **graphe 2 faces** | — | **graphe complet ROM** |
| Verdict audit | AUDIT_PASS (34 LOW) | AUDIT_PASS (74 LOW, 32 ACCEPTED prouvés) | AUDIT_PASS (26 LOW) | AUDIT_PASS (1 LOW, 27 ACCEPTED prouvés) |

## Ce qui reste honnêtement ouvert (repris dans COVERAGE_MATRIX)

- RED : 64 stations dialogues REVIEW_REQUIRED (graphe EU ≠ pret exact) ;
  chaîne EVENT_* globale non décodée octet à octet dans la ROM EU ;
  alt_sectors du cast (49 entités).
- SKY : runtime PMDO NOT_TESTED ; tables de gameplay des donjons
  (spawns/items/traps) NOT_TESTED ; 124 grounds sans zone SCRIPT propre
  (variantes de MAP_BG — canonique).
- Les statuts NOT_TESTED / REVIEW_REQUIRED ne sont PAS des échecs cachés :
  ce sont les prochaines phases du prompt maître.
