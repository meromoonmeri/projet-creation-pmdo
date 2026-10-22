# Authoring guide — `crooked_cavern_midpoint` (relay / checkpoint)

This document covers the two parts of the Crooked Cavern checkpoint that **cannot
be produced from text alone** in this repo and require the **PMDO editor** (a GUI
tool shipped with the PMDO/PMDC dev build). Everything else (scripts, config, FR
strings, segment scaffolding) is already implemented in the repo — see
`audit_checkpoint_crooked_cavern.md` §"Journal d'implémentation".

---

## Part A — Author the relay ground map (`crooked_cavern_midpoint`)

The map is **registered** in `Data/Zone/master_zone.json` (GroundMaps index **60**)
and has its scripts (`Data/Script/halcyon/ground/crooked_cavern_midpoint/`), but its
**layout does not exist yet** — this repo ships no ground-map data files at all.

### Steps in the Ground Map Editor

1. Create a new ground map named **`crooked_cavern_midpoint`**.
2. **Tileset (biome grotte)** — reuse assets already in the project:
   - `Content/Tile/Crooked_Cavern_Base.tile`
   - `Content/Tile/Crooked_Cavern_Objects.tile`
   - `Content/Tile/Crooked_Cavern_Shadows.tile`
   - optionally accents from `Content/Tile/Crooked_Den.tile`
3. **Ambiance** (sanctuaire paisible, contraste avec le donjon) : cristaux lumineux,
   mousse sur les rochers, petites zones d'herbe, fleurs dans les fissures, petits
   champignons, rais de lumière du plafond, particules douces. **Aucun ennemi,
   aucun piège, aucun aléa.**
4. **Required named entities** (the scripts reference these by name):
   | Entity | Type | Purpose |
   |---|---|---|
   | `Main_Entrance_Marker` | entry marker | where the duo spawns on arrival |
   | `North_Exit` | touch-zone (forward) | the ONLY exit → triggers `North_Exit_Touch` → Profondeurs (segment 1) |
   | `Kangaskhan_Rock` | object (`Content/Object/Kangaskhan_Rock.dir`) | triggers `Kangaskhan_Rock_Action` → save + storage |
   - **Do NOT add a backward/south exit** (spec: no return to the first half).
5. **Layout** (suggested flow): Entrée → clairière ouverte → Statue Kangourex (centre, mise en valeur : socle de pierre, fleurs, mousse, cristaux, particules) → petite aire de repos → tunnel vers `North_Exit`. Pas de cul-de-sac.
6. **Music**: set the map BGM to `Heartwarming.ogg` (already referenced by the scripts; confirmed present in `Content/Music/`). Alternative calm candidates: `Goodnight.ogg`, `At the End of the Day.ogg`, `Star Cave.ogg`.

### After authoring — wire the scene coordinates

The scene file `crooked_cavern_midpoint_ch_3.lua` contains `-- TODO_MAP:` markers for
every `GROUND:TeleportTo` / `MoveToPosition` / `MoveCamera` / `GROUND:Hide('North_Exit')`
coordinate. Open the map in the editor, read off the real tile coordinates, and replace
each placeholder. The logic (state machine, dialogue, `EnterDungeon`) is already correct.

---

## Part B — Tune the "Profondeurs" second half (segment 1)

`Data/Zone/crooked_cavern.json` now has **3 segments**:

| idx | segment | status |
|---|---|---|
| 0 | Caverne Tortueuse (procédural) | unchanged |
| 1 | **Profondeurs** (procédural, NEW) | scaffolded = exact copy of segment 0 with a distinct floor name |
| 2 | boss (`chapter_3_boss_fight`, LoadGen) | unchanged (renumbered 1 → 2) |

The scaffolded Profondeurs is **structurally valid but currently identical in
difficulty to the first half** (same species roster: aron, diglett, dunsparce,
houndour, mankey, nosepass, onix, purrloin, roggenrola, whismur, zubat). Crooked
Cavern auto-scales levels (`ZoneData.Level == -1`), so levels are NOT a difficulty
knob here.

**To make it the "harder second half", open the zone in the PMDO Zone Editor and:**
- swap in tougher species (e.g. evolved forms / higher-BST cave dwellers);
- increase spawn density / aggression;
- add traps, Monster Houses, or restricted visibility on the deeper floors;
- adjust floor count / layout size to taste;
- optionally change the segment music to a tenser track.

This is genuine level design and **must be playtested** — it cannot be tuned blindly
from text.

---

## Part C — Kangaskhan sprite (optional)

The relay uses the **`Kangaskhan_Rock.dir` object** (confirmed present, already wired
to the shared `GeneralFunctions.Kangashkhan_Rock_Interact` handler). No character
sprite is required for the checkpoint to function. The Kangaskhan *character* sprite
(`Content/Chara/115.chara`) is **not** in this mod and is only needed if you want a
living Kangaskhan NPC at the relay (it would be provided by a full PMDO install).

---

## Verification after editor work

Run through the test checklist in `audit_checkpoint_crooked_cavern.md` §"Checklist
de test", in particular:
- first arrival unlocks the checkpoint;
- save via the rock, reload → correct return;
- the only exit is forward (no backward path);
- dying in the Profondeurs OR to the boss respawns at the relay (not the entrance);
- escaping returns to the entrance (not the relay) — by design.
