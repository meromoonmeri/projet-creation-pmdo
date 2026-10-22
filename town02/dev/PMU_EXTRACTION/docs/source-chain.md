# PMU source chain and exact behavior

## Map loading and saving

Authority: `PMU-Client/Client/Maps/MapHelper.cs`.

`LoadMapFromFile` decrypts the complete file, decodes UTF-16LE text, validates `MapData|V9`, allocates an inclusive `[MaxX+1, MaxY+1]` tile array, and parses `Data`, `NpcSettings`, and `Tile` records. `SaveLocalMap` emits the same records in X-major/Y-minor order and encrypts the UTF-16LE bytes.

The cipher implementation in `Encryption.cs` is TripleDES-CBC with PKCS#7 padding. Its 24-byte key is SHA-1 of the UTF-16LE configured passphrase, resized with zero padding; its eight-byte IV is SHA-1 of the empty UTF-16LE string truncated to eight bytes. The implementation round-trips known plaintext exactly. However, all 140 checked-in map ciphertexts reject the public placeholder key. The actual deployment key is absent from all public history and the sole public fork. Those cache files are therefore reported `BLOCKED`, not guessed. The SQL map structures remain independently recoverable.

## SQL authority

Authority: `PMU-Server/DataManager/DataManager/Maps/MapDataManager.cs`.

`LoadRawMap` joins `map_general`, `map_data`, and `map_switchovers`, then reads `map_npcs` and `map_tiles`. `SaveRawMap` writes those same structures and iterates every inclusive X/Y coordinate. The streaming importer mirrors the source column order; it never loads the 1.15 GB SQL member as one object.

The SQL snapshot contains 2,000 standard maps (`s1` through `s2000`) among 17,028 general map records and exactly 2,120,606 standard-map cells. SQLite integrity is `ok`; every inclusive grid has the expected cell count. The remaining records include player houses, runtime instances, and random-dungeon maps. They remain inventoried by the source audit but are not silently conflated with the canonical standard world scope.

## Tile archives

Authority: `PMU-Client/Client/Graphics/Tileset.cs`.

Each archive begins with little-endian signed 32-bit width and height. Tile count is `(width/32)*(height/32)`. The index has, per tile, a signed 64-bit offset relative to the end of the index and a signed 32-bit encoded-image size. The pipeline validates all offsets and decodes every embedded image at 32×32. All 52,486 images in 11 authoritative archives decode correctly; 52,395 also match independent historical toolkit atlases pixel-for-pixel, while the 91 differences are confined to the toolkit's distinct `Tiles7` revision.

## Rendering and animation

Authority: `PMU-Client/Client/Graphics/Renderers/Maps/MapRenderer.cs` and `Client/Widgets/MapViewer.cs`.

The editor/screenshot renderer processes Ground, Mask, Mask2, Fringe, and Fringe2. In animation state, a nonzero paired animation tile replaces the base tile. `MapViewer.OnTick` flips the state after 250 ms. Therefore a complete source representation includes a base PNG and, where any replacement exists, an animated-state PNG, with a 500 ms full period.

The integrated whole-map capture passes `MaxX`/`MaxY` to exclusive loop bounds and allocates `MaxX*32` by `MaxY*32`, omitting the last source row and column. This is a screenshot helper defect, not map geometry. The pipeline preserves all inclusive source cells.

Final validation verifies 2,000 source PNGs, 962 animated-state PNGs and 32 contact sheets. Of the animated maps, 917 states differ in visible pixels; 45 preserve a valid replacement state whose substitutions happen not to change visible output. The renderer emitted 4,754 raw out-of-range events, reduced to 2,395 unique map/cell/layer references after base/animated-state deduplication. The original tile-0 fallback is retained and every event is indexed rather than painted over.

## Map editor and network save

The editor is integrated under `Client/Windows/Editors/MapEditor`. It edits the in-memory structured map and invokes `Messenger.SendSaveMap`; the server persists the received map through `MapDataManager`. No screenshot/image-based map format participates in this chain.
