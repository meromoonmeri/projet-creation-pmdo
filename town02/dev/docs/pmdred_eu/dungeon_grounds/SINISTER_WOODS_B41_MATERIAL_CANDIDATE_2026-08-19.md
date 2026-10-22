# Sinister Woods b41 — candidat PMDO de staging

**Statut : `STAGED + VALIDATED + RUNTIME_TESTED` — promotion interdite.**

Preuve machine :
[`sinister_woods_b41_material_candidate_runtime_2026-08-19.json`](sinister_woods_b41_material_candidate_runtime_2026-08-19.json).
Le candidat ignoré est construit dans `.runtime-cache/sinister-woods-b41-candidate` ;
aucun fichier `Content/Tile` ou `Data/AutoTile` de production n'a été écrit.

## Source et sélection

- ROM EU : SHA-256
  `0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd` ;
- dungeon ID : `3` ;
- `mapparam` : lignes procédurales `1..12` → tileset **41** ;
- ressources réellement consommées : `b41fon`, `b41cel`, `b41cex`, `b41pal`,
  `b41canm` ;
- `b65*` n'est pas utilisé ici : il reste réservé à la ligne finale D04P02.

La reconstruction utilise les primitives ROM existantes : FON 4bpp, CEL 250
chunks 3×3, CEX 0x930 et ses trois variantes par masque, palette GBA 12×16 et
les 32 records CANM dont 16 actifs. Les 47 codes réellement supportés par
`RogueEssence.Dungeon.AutoTileAdjacent` sont tous présents dans chacun des trois
AutoTiles.

## Composition produite

Le candidat contient exactement les quatre ressources ciblées :

- `TreeshroudForest1.tile` — 24 px, 64 250 coordonnées (base + 16 records
  CANM × 16 états × 250 chunks) ;
- `treeshroud_forest_1_floor.json` ;
- `treeshroud_forest_1_wall.json` ;
- `treeshroud_forest_1_secondary.json`.

Les variantes CEX 0, 1 et 2 sont les trois variantes d'`AutoTileAdjacent`.
Les couches animées ne sont pas une recoloration globale : chaque record CANM
actif est un overlay indépendant qui conserve sa durée source — records 0 à 12
à 12 ticks, records 13 à 15 à 8 ticks. Le secondaire utilise les 16 records
sur ses 47 codes ; les images de base et les overlays sont pixel-validés par
recomposition.

## Validation indépendante

`tools/validate_sinister_woods_b41_material.py` relit la ROM et re-dérive les
chunks/CANM sans prendre le manifeste du générateur comme autorité. Il vérifie :

- hashes et tailles des cinq ressources b41 ;
- 250 chunks CEL et 47 codes × 3 variantes par famille ;
- coordonnées et durées de chaque couche PMDO ;
- résolution de toutes les coordonnées vers le `.tile` ;
- recomposition RGBA contre le rendu ROM pour chaque état CANM ;
- **2 001** contrôles de couches et **32 016** contrôles pixels ;
- absence d'écriture de production, D04P01/D04P02 inchangés et blobs Relic
  Forest inchangés.

Résultat : `PASS_WITH_STARTUP_PHASE_GATE`.

## Runtime PMDO contrôlé avec le candidat

La fixture isolée a remplacé ses copies locales du `.tile` et des trois
AutoTiles par le candidat, puis a indexé et généré les segments 0, 1 et 3 de
`gloomy_forest` :

| Segment | Dimensions | Collision libre | Collision bloquée | Musique | Setter |
|---:|---:|:---:|:---:|---|---|
| 0 | `38×51` | oui | oui | `Sinister Woods.ogg` | — |
| 1 | `51×38` | oui | oui | `Sinister Woods.ogg` | — |
| 3 | `38×64` | oui | oui | `Sinister Woods.ogg` | `deep_shadow` + `dusk` |

Le moteur PMDO 0.8.12 a terminé par `NORMAL_EXIT`, code `0`, sans watchdog,
résidu, `Missing Data`, `Exception Depth`, `Lua Trace` ou `RUNTIME_FAIL`.

## Blocage exact de promotion

Le GBA conserve pendant un seul délai CANM la palette brute initiale, puis
publie la première couleur de chaque record. `TileLayer` PMDO est cyclique et
ne possède pas de frame « startup one-shot » : le candidat conserve cette
palette brute dans le manifeste, mais ne la boucle pas comme une fausse
17e frame. Il manque donc une adaptation runtime PMDO prouvée pour effectuer
la transition initiale sans altérer le cycle steady-state.

Verdict actuel :

```text
BLOCKED_WITH_EXACT_MISSING_COMPONENT
ONE_SHOT_GBA_STARTUP_PALETTE_HOLD_NOT_REPRESENTABLE_BY_CYCLIC_PMDO_TILELAYER
```

En conséquence, aucun des quatre assets de production n'est remplacé et aucun
index de production n'est modifié. Les `relic_forest_blob_*` et D04P01/D04P02
restent intacts. La prochaine étape est de prouver cette petite adaptation
runtime, puis seulement de rejouer la gate post-promotion ; ce candidat n'est
pas présenté comme une certification finale.
