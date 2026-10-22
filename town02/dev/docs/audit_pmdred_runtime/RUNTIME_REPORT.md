# Runtime audit — PMD Red imports

## Automated engine execution

PMDO/PMDC **0.8.12 Linux x64** was executed with the real New Era quest under FNA3D OpenGL/llvmpipe (`SDL_VIDEODRIVER=offscreen`). Lua 5.4 and New Era `main.lua` initialized successfully.

A temporary startup probe invoked the actual runtime chain:

`GraphicsManager.GetTile → TileIndex.GetPosition → BaseSheet.Load → Texture2D.FromStream`

for every distinct image payload referenced by the 41 PMD Red Grounds.

- Coordinate/frame references covered: **230,824**
- Distinct sheet/offset payloads decoded: **38,115**
- Successful decodes: **38,115**
- Failures: **0**
- `ChampVentBoreal_Base` coordinates 2,13–4,14: included and passed
- `unknown image type`: **0**
- `Texture2D.FromStream`: **0 errors**
- `BaseSheet.Load`: **0 errors**

Evidence: `AUTOMATED_TILE_ENGINE_TEST.log`.

## Classification boundary

This proves runtime texture/index/frame decoding. It does **not** prove movement, camera composition, checkpoint interaction, boss combat, or transitions for each Ground. Those columns remain `MANUAL`, and all 41 verdicts remain `MANUAL_REVIEW`. No static result was promoted to `RUNTIME_PASS`.
