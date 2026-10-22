# Direct dungeon-backed Ground visual review

Review date: **2026-08-11**  
Reviewed bundle: [`dungeon_grounds/manifest.json`](dungeon_grounds/manifest.json)  
Reviewed manifest SHA-256: `edb5519c4e445db96e1910a19bf425d98c8df4d461a34c2e016745a56d4ef15b`

## Scope and method

This is the human visual-review record for the 27 EU-ROM-derived Grounds reconstructed through the direct `GroundMap_SelectDungeon` graphical path. It does not promote these renders to proof of scripts, music, collision, transitions, or PMDO installation.

The review covered:

- every one of the **27** full tick-zero PNGs;
- every one of the **131** stored PNG/APNG states, decoded as complete composited RGB frames rather than trusting APNG playback;
- map extents, continuity, borders, repeated patterns, isolated or missing chunks, palette coherence, palette changes, unexpected black or transparent regions, and black-frame flashes;
- all output dimensions against the geometry recorded in each `evidence.json`.

The frames were reviewed in stable Ground-ID order. A contrasting surround was used while comparing frames so authored black pixels were distinguishable from empty viewer space. The independent bundle validator separately verifies dimensions, pixel hashes, APNG disposal mode, and the absence of fully black frames.

## Results

| Ground | Size (px) | Stored states reviewed | Result | Visual note |
|---|---:|---:|---|---|
| `d01p02` | 360×336 | 1 | Pass | Clearing, border, and approach are continuous. |
| `d02p02` | 360×336 | 4 | Pass | Pool border and short palette sequence remain coherent. |
| `d03p02` | 456×552 | 1 | Pass | Steel summit architecture and cliff edges are complete. |
| `d04p02` | 552×576 | 1 | Pass | Forest enclosure has no missing or isolated chunks. |
| `d05p02` | 360×408 | 1 | Pass | Clearing and approach retain complete edge treatment. |
| `d06p02` | 456×456 | 6 | Pass | Relay arena and water/edge palette states remain continuous. |
| `d06p03` | 456×456 | 8 | Pass | Summit and lightning-highlight sequence show no black flash. |
| `d09p02` | 456×456 | 8 | Pass | Lava-edge cycle is spatially stable in every state. |
| `d09p03` | 552×552 | 8 | Pass | Summit, distant lava, cliffs, and animated highlights remain coherent. |
| `d10p02` | 456×456 | 7 | Pass | Snow/ice relay border remains complete through the cycle. |
| `d10p03` | 528×504 | 1 | Pass | Snowy boss platform and repeated ice background are intact. |
| `d11p02` | 456×456 | 7 | Pass | Icy relay arena has no missing edge or palette discontinuity. |
| `d11p03` | 504×504 | 8 | Pass | Circular ice arena and snow-speck sequence remain coherent. |
| `d12p02` | 456×456 | 8 | Pass | Magma relay and animated rim remain continuous. |
| `d12p04` | 504×504 | 8 | Pass | Dark surround, arena, markers, and palette sequence contain no corrupt block or black flash. |
| `d13p02` | 456×456 | 6 | Pass | Sky relay and blue edge cycle remain complete. |
| `d13p03` | 552×600 | 7 | Pass | Cloud summit and startup palette changes contain no black frame. |
| `d14p01` | 528×504 | 7 | Pass | Vortex rings animate without geometry loss or disposal artifacts. |
| `d15p01` | 552×600 | 8 | Pass | Circular water/sphere sequence remains centered and continuous. |
| `d16p01` | 360×360 | 8 | Pass | Fire arena and lava strips remain stable through all states. |
| `d17p01` | 384×360 | 6 | Pass | Sand arena, vegetation, and pools contain no tile gap. |
| `d18p01` | 360×336 | 4 | Pass | Water/snow frame and interior platform remain continuous. |
| `d19p01` | 528×504 | 1 | Pass | Desert platform, cliffs, horizon, and sky are complete. |
| `d20p01` | 360×336 | 1 | Pass | Sand chamber and side walls are continuous. |
| `d21p01` | 504×480 | 1 | Pass | Authored black backdrop around and below the sunset cliff is contiguous scene background, not a rectangular missing-tile region. |
| `d23p01` | 360×336 | 1 | Pass | Chamber, approach, and wall pattern contain no seam or gap. |
| `d25p01` | 360×336 | 4 | Pass | Forest chamber and short palette sequence remain coherent. |

**Conclusion:** no unexplained visual anomaly was found in the 27 tick-zero renders or 131 bounded preview states. In particular, no preview contains an all-black frame, accidental transparent disposal, rectangular missing-tile block, discontinuous map edge, or palette-corruption flash. This accepts the generated reference renders for the direct graphical path only; it is not acceptance of PMDO migration or of the wider PMD Red reconstruction.
