# PMU Phase 1 — rapport canonique

- **État global tous artefacts découverts :** `PARTIAL`
- **Snapshot SQL public (IR + raster) :** `SOURCE_CERTIFIED`
- **Maps du snapshot certifiées/partielles :** 1861 / 139
- **IDs rendus :** `s1` à `s2000` (2000 maps)
- **Maps standard découvertes, blocages inclus :** 2001
- **Cellules SQL :** 2,120,606 / 2,120,606, SQLite `ok`
- **Caches V9 client :** 140 sources, 138 standard, 0 décodée, 140 `BLOCKED`
- **Tilesets / tiles :** 11 / 52,486
- **PNG source / états animés vérifiés :** 2000 / 962
- **Contact sheets vérifiées :** 32
- **Références graphiques hors plage :** 4,754 événements bruts, 2,395 événements dédupliqués; repli officiel vers tile 0 préservé
- **Échecs de validation finale :** 0

## Villes critiques

### Grassroot Town

- `s737` — Exbel, Grassroot Town — révision 1715
- `s1810` — Exbel, Grassroot Town — révision 32

Les deux enregistrements exacts sont conservés; aucune révision n’est supprimée ou fusionnée arbitrairement.

### Snowbasin Town

- `s1991` — Winden, Snowbasin Town — révision 378

### Silversail Village

- `UNKNOWN` — aucun nom exact et aucun ID canonique prouvé dans le snapshot SQL public.
- Sept maps portent le libellé régional `Archford, Southwestern Isle`, mais elles restent `UNVERIFIED` comme identité Silversail.
- Aucun PNG de wiki ou de ville externe n’a été téléchargé, utilisé comme géométrie ou substitué aux données.

## Inventaires exhaustifs

- Animations : 962 maps; frames, emplacements et timings sous `/home/user/new-era-abyss-to-ascension-V4/.runtime-cache/pmu-extraction/source/inventories/animation-inventory.json`.
- NPC : 4661 presets acteurs runtime; inventaire sous `/home/user/new-era-abyss-to-ascension-V4/.runtime-cache/pmu-extraction/source/inventories/npc-inventory.json`.
- Objets : 2001 définitions; inventaire sous `/home/user/new-era-abyss-to-ascension-V4/.runtime-cache/pmu-extraction/source/inventories/object-inventory.json`.
- Stories/scripts : 1001 stories; inventaires dédiés et 65 arêtes scriptées statiquement prouvées.
- Triggers : index complet sous `/home/user/new-era-abyss-to-ascension-V4/.runtime-cache/pmu-extraction/source/inventories/trigger-inventory.json`; passabilité exhaustive dans chaque IR canonique.
- Types historiques inconnus : 6 cellules (101/103), préservées `UNKNOWN`.

## Graphe

Le graphe contient 8746 arêtes, dont 65 transitions story/script prouvées statiquement. Les destinations calculées restent `UNVERIFIED`.

## Certification et barrière de phase

Le snapshot SQL public des 2 000 maps est `SOURCE_CERTIFIED` pour l’IR et le raster. L’état global reste `PARTIAL` : 137 caches standard recouvrant le snapshot ne peuvent pas être comparés, `s3000` n’existe que sous forme chiffrée bloquée, et six cellules gardent une sémantique inconnue.

La phase 2 est autorisée **uniquement** pour ce snapshot SQL certifié et doit rester dans une pipeline séparée. Les contenus V9 bloqués, dont `s3000`, ne sont pas adaptables. Cette pipeline de phase 1 ne produit toujours aucun `.rsground` et ne remplace aucune méthode runtime/headless existante.

## Index et artefacts

- `canonical-map-index.json` : index JSON enrichi des 2 000 maps.
- `canonical-map-table.md` : tableau `Map ID | Nom | Type | Dimensions | Tileset | PNG | Source | Statut`.
- `connection-graph.json` / `.dot` : graphe canonique complet, transitions scriptées prouvées incluses.
- `audit/` : preuves compactes SQL/DAT/tiles/inventaires/certification, types inconnus et références graphiques dédupliquées.
- `artifact-hashes.sha256` : hashes SHA-256 de tous les livrables suivis du rapport.
- `critical-maps/` : copies byte-identiques des PNG source et états animés de `s737`, `s1810` et `s1991`, avec hashes.
- Bulk reproductible : `/home/user/new-era-abyss-to-ascension-V4/.runtime-cache/pmu-extraction` (IR, manifests, PNG, animations, inventaires, graphe et contact sheets).
