# `t01p04` exhaustive exact-PMDO validation

## Verdict

`PASS` — promoted additively on 2026-08-12 after exhaustive validation of the exact canonical Ground and tile in PMDO 0.8.12.

| Gate | Result |
| --- | --- |
| Full-RGBA visual comparison | 2/2 full-map runtime samples pixel-exact at 528×528; 0 mismatched pixels; maximum channel delta 0 |
| Opacity | 2/2 fully opaque |
| Tiles and palettes | Authenticated raw EU BPL/BPC/BMA reference matched exact PMDO output at the complete static schedule and reload |
| Animation | Canonical resources have no BPA or animated-palette channel; exhaustive schedule is static tick 0, independently repeated after reload |
| Collision | One BMA layer with 4,028 solid cells; clear movement `(-8, 0)` and blocked movement `(0, 0)` passed |
| Lifecycle | Two loads, two exits, one same-Ground re-entry, strict lifecycle order, four cleanup probes, sink, final cleanup, and terminal `end` passed |
| Project integration | Additive lowercase destination and one zone entry; reserve, `sky_eos_t01p04a`, `dojo_ossatueur`, and dormant cinematic assets remain untouched |
| Classification | Canonical source: Makuhita Dojo exterior/training-facility Ground; not itself a battle arena, boss Ground, or validated cinematic. Deferred project cinematic reuse is documented separately |
| Destination | `Data/Ground/t01p04.rsground`; `Content/Tile/t01p04_Base.tile`; `Data/Zone/master_zone.json` |
| Promotion | `PROMOTED_ADDITIVE_CANONICAL`; no active destination was replaced |

Exact PMDO executable SHA-256: `faf9755c5c6ba1a06460c433b401c118bae218887b8687aefb995b80d4de8327`. Authenticated EU ROM SHA-256: `0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd`.

## Static schedule and BMA behavior

`t01p04` has no BPA or BPL animation channels, so the complete independently derived animation schedule contains one primary sample at tick 0. Exact PMDO and the raw-resource renderer matched over the complete 528×528 RGBA image on primary load and again at reload tick 0. Both captures are fully opaque and share the same canonical RGBA state, as required for a static Ground.

The BMA-derived obstacle grid has one collision layer, 4,028 solid cells, and collision hash `103f07a8556c2d9d490be4a8063de96223dfd8a1ab5780302f72fcd8da0620df`. PMDO moved the actor left by `(-8, 0)` from a clear aligned footprint and rejected the adjacent downward move with `(0, 0)`. Authenticated BMA auxiliary data contains 44 nonzero cells (hash `e6985c55b86b415a8efedbe1b1f9b1140791f3f168d8bba54edab84a833e51f7`); this was retained by canonical conversion and its static/differential gates.

## Identity correction and separation

Authenticated extraction identifies canonical debug ID 5, map ID/file ID 6, Ground place ID 5, conversion type 2, and weather ID -1. At pinned `pret/pmd-red` commit `bf0092d0e34fd8e49b859a0b5f96f00740faa42d`, enum index 6 is `MAP_MAKUHITA_DOJO`.

The retained reserve comment and historical animation audit incorrectly call `t01p04` `MAP_FILE_ID_PELIPPER_POST_OFFICE_INSIDE`, which is index 5 and authenticated `t01p03`. Canonical records correct the identity without altering historical reserve bytes.

The repository previously had no lowercase destination or registration. Promotion added the exact bare candidate and one entry after `t01p03`; it did not import the reserve marker or alter:

- the separately registered EoS `sky_eos_t01p04a` Ground/tile/script;
- the active French `dojo_ossatueur` Ground/tile/script/entities;
- the dormant ten-dialogue-line `arc_fugitif/scene/t01p04.lua`, which has no Fugitive registry/sequence entry and no lowercase Ground init.

The canonical source is a training-facility exterior/service Ground. It is classified separately from an arena because this map has no arena/boss runtime role in the validated artifact. The deferred script is only intended cinematic reuse and is not routed or claimed complete.

## Lifecycle and evidence

The native lifecycle loaded the Ground, performed collision probes, captured primary tick 0, exited/finalized, re-entered the same Ground, captured reload tick 0, exited/finalized again, and entered an inert sink. All cleanup and strict-order checks passed with no state leakage, stale asset, orphaned animation, permanent lock, or orphan process.

- `validation_record.json`, `promotion_record.json`, `provenance.json` — complete machine-readable verdict, identity, classification, preservation, destination, and hashes.
- `report.json` — full metrics for both samples.
- `events.jsonl` — untouched 28-event exact-PMDO stream.
- `actual/` and `comparisons/` — durable primary/reload PMDO captures and side-by-side EU-ROM comparisons.
- `fixture_manifest.json`, runtime/index/engine/comparison logs, and `post_promotion_index.log` — isolation and integration proof.
- `commands.sh` — bounded reproduction with authority, identity, lifecycle, comparison, and post-promotion gates.
- `evidence_hashes.sha256` — evidence and preservation checksum manifest.

Only Ground map/tile reconstruction, identity, visuals, static timing, collision, lifecycle, cleanup, and additive registration are claimed. Events, characters, choreography, cameras, dialogue, music, VFX, and cinematics remain later milestones. The existing 27-relationship dungeon restitution bundle remains unchanged and passing.
