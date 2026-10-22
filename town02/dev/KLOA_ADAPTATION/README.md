# Kloa - Child of the Forest — extraction qualitative (maps & textures)

Pipeline d'extraction exhaustif calqué sur l'adaptation No Name Village
(`dev/NO_NAME_VILLAGE_ADAPTATION/`) — NNV est un jeu GameMaker extrait via
UndertaleModLib ; Kloa est un jeu **Unity**, l'outil d'autorité est
**UnityPy 1.25.3**.

## Provenance verrouillée

- Source : `meromoonmeri/BIBLIOTHEQUE` branche `bibliotheque`,
  dossier `Kloa - Child of the Forest Demo/` (démo Unity, stockée en Git LFS).
- Transport : archive codeload de la branche (le dépôt inclut les objets LFS
  dans ses archives) ; chaque fichier d'assets vérifié contre le **SHA-256 de
  son pointeur LFS** (ex. `sharedassets0.assets` =
  `69cbda30e2207615a558b91784a0b38c097cdc04bf2ce11ef91ee8869fcf9369`,
  1 266 040 octets — vérifié exact).
- Cache brut : `.runtime-cache/kloa/source/` (141 fichiers, 1.3 GB,
  git-ignoré, restaurable par `dev/tools/kloa_fetch_assets.py` +
  l'archive codeload).

## Outils (autorité du format : Unity, rien d'interprété)

- `dev/tools/kloa_fetch_assets.py` — récupération authentifiée (API GitHub +
  batch LFS ; fallback archive codeload quand le CDN LFS est inaccessible).
- `dev/tools/kloa_extract_assets.py` — extraction exhaustive :
  **818 Texture2D** (PNG pixel-perfect, aucun resampling),
  **13 560 Sprites** (rects consignés dans l'inventaire — redécoupables
  depuis les atlas versionnés), **908 AnimationClips** (courbes PPtr =
  frames de sprite + temps, `m_SampleRate`, boucle).
- `dev/tools/kloa_extract_maps.py` — extraction des **41 maps** (scènes
  Unity `level0..level40`, noms lus dans `BuildSettings`) : pour chaque
  scène, placement monde de chaque SpriteRenderer (position recomposée via
  la hiérarchie des Transforms, échelle, flip, teinte, sorting layer/order)
  + colliders 2D (géométrie praticable). Ce sont les valeurs sérialisées
  par Unity, pas une reconstruction.

## Contenu versionné ici

- `extracted/textures/<assets>/<name>_<path_id>.png` — les 818 textures
  décodées (24 MB) : atlas d'arbres (`TreesAtlas` 2048², vérifié
  visuellement pixel-perfect), fonds de zones (`new_background5` 4410×2088,
  `monk_cavebackgroundPond` 10752×256, `landscape` 6336×480), tuiles d'eau
  animées (`ALBERO-water-Sheet` 512×256 ×20 frames), murs/puzzles
  (`WallsFullCustom_Atl`), cinématiques (`CUTSCENE_BOW`, `KATANA_CUTSCENE`,
  `KLOA_RESURRECTION`), personnages haute résolution.
- `extracted/maps/level*.json` — les 41 compositions de scène
  (39 358 SpriteRenderers posés au total, 29 715 colliders).
- `extracted/animations/<assets>/<clip>_<path_id>.json` — les 908 clips.
- `extracted/inventory.json` — inventaire complet déterministe (dimensions,
  formats, rects de sprites, SHA-256 de chaque PNG exporté).
- `extracted/manifest.json` — hash-lock de toutes les sorties.

Index légers versionnés dans `dev/docs/kloa/` :
`KLOA_ASSET_INVENTORY.json`, `KLOA_SCENE_INDEX.json`.

## Zones de la démo (maps utilisables comme références de biome)

| Zone | Scènes | Notes |
|---|---|---|
| Forest | ForestScene_1..21_demo, Okamaru, Transition | biome principal, 12 scènes |
| Orange Zone | OrangeZone_Scene_1..3 (+MEMORY) | variante automnale |
| Ruins Zone | RuinsZone_Scene_1..4 (+MEMORY) | ruines |
| Caves | Cave, MonkCave_Scene | grottes |
| Boss | KurodaiBoss, KurodaiMidBoss, BigSlime_MidBoss | arènes |
| Autres | GoddessScene, ShopDorobo, BowTransition, DemoEnd, DarkScene | scènes spéciales |

## Usage prévu (comme NNV)

Réserve de référence qualitative pour les biomes/décors des chapitres
autorisés (6-32). Toute promotion vers `Content/Tile` + `Data/Ground` devra
passer par le même processus que NNV : conversion dédiée, rapports, et
validation runtime PMDO réelle. **Aucune ressource CH1–CH5 n'est touchée**
(verrou `dev/tools/ch1_5_lockfile.py`).
