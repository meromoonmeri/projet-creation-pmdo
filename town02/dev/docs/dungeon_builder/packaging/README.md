# Windows-safe distributable packaging

Reproducible packaging pipeline for New Era.

## Usage

```
python3 tools/package_windows.py --dest /tmp/new-era-package
```

Produces `New-Era.zip` at the destination, plus a `PACKAGE_REPORT.json`
that documents:
- every file included and its length
- SHA256 hashes of every canonical file (Zones, Grounds, Maps, scripts,
  music, AutoTiles, CONVERSION tables, Mod.xml, docs)
- extraction smoke-test result
- longest path measured under a simulated short-root prefix
- validation errors (missing runtime files, forbidden dev artefacts,
  path-budget violations)

## Release manifest

The package layout follows the **reference PMDO Quest mod Halcyon**
(https://github.com/Palikadude/Halcyon), which is the accepted community
layout for PMDO 0.8.12 Quest mods. See the module docstring for the
complete manifest.

```
New-Era/
├── Mod.xml                # PMDO manifest (mandatory)
├── Data/                  # canonical PMDO tree
├── Content/               # canonical assets (Tile, Music, Graphics)
├── Strings/               # localisation
├── CONVERSION/            # ROM<->PMDO name lookup tables (Halcyon convention)
├── CREDITS.md
├── readme.md
├── patchnotes.txt
├── Pokemon changes.txt
└── README-WINDOWS.txt     # Windows extraction guide (added by packager)
```

Everything else in the source repository (dev tools, ROM extraction
caches, external reference material, staging output, audit reports,
`.git`, etc.) is EXCLUDED from the package.

## Why Windows failed on the raw GitHub download

Measured on the source tree:

| Tree                              | Longest relative path |
|-----------------------------------|-----------------------|
| Runtime (Data/, Content/, Strings/, Mod.xml) | **93 chars** |
| `external/BIBLIOTHEQUE_WORKSPACE/` (dev)      | **167 chars** |
| `NO_NAME_VILLAGE_ADAPTATION/` (dev)           | **129 chars** |
| `docs/` (dev audit reports)                   | **101 chars** |

Extracting the raw GitHub repo to a typical Windows Downloads path
(~130-char prefix including the `new-era-abyss-to-ascension-V4-<sha>/`
extraction root) puts the deepest `external/` file at ~305 absolute
chars — 45 chars above Windows `MAX_PATH` (260). The **runtime tree
alone**, by contrast, stays under 230 absolute chars even at that same
extraction root.

The packager therefore ships only the runtime + docs + convention tree,
and users are guided to a short root (`C:\NE\` or `%APPDATA%\PMDO\MODS\`)
in `README-WINDOWS.txt`. The extraction smoke test embedded in the
packager confirms both invariants on every build.
