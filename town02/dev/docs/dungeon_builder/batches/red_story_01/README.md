# Lot Red Story 01 — Tiny Woods + Thunderwave Cave

## Statut

| Donjon | Floors | Mapgen PMDO | Route PMDO | Promotion | Blocker restant |
|---|---:|---:|---:|---:|---|
| Tiny Woods | 3 | 30/30, invalid 0 | PASS | **oui** (PROMOTED_RUNTIME_VALIDATED) | — |
| Thunderwave Cave | 5 | 50/50, invalid 0 | PASS | **oui** (PROMOTED_RUNTIME_VALIDATED) | — |

Les deux routes chargent l’entrée canonique, chaque floor, le Ground final D01P02/D02P02, puis reviennent au Ground d’entrée après `EndGame` natif. Les seeds et escaliers sont journalisés.

L'ancien blocker `CANONICAL_MUSIC_ASSET_MISSING` a été levé le 2026-08-24 : les
deux pistes canoniques ont été rippées depuis la ROM PMD Red EU
(SHA-256 `0f9d125d…4cbcd`) via `tools/dungeon_builder/rom_audio_extract.py`
(chaîne complète : `gba_mus_ripper` → MIDI + SF2 → `fluidsynth` → WAV → `ffmpeg` → OGG Vorbis Q5).
Traçabilité complète dans `docs/canonical/red/audio/pmdred_eu_music_extraction.json` et
`docs/canonical/red/audio/ROM_AUDIO_TRANSPORT_AUDIT.json`. L'item `ammo_gravelerock`
requis par Thunderwave Cave a été importé depuis PMDODump/DumpAsset commit épinglé
`d74394dc…de08` (source alignée sur `PMDODUMP_COMMIT` dans `scope_registry.py`).

## Règles réconciliées

- shops désactivés : `kecleonShopChance=0` ;
- Monster Houses désactivées : `monsterHouseChance=0` ;
- météo claire conservée ;
- Tiny Woods : `trapDensity=0` ;
- Thunderwave Cave : Wonder Tiles et densité 3 ;
- espèces, probabilités, objets et floors issus des manifests ROM ;
- objets limités à leurs floors source ;
- niveaux New Era séparés comme `SUPPLEMENTAL` ;
- profils RogueElements explicitement `INFERRED` et sélectionnés par `ChanceFloorGen`.

## Assets et décision de non-promotion

Les DTEF `tiny_woods` et `thunderwave_cave` existent dans PMDO. En revanche, les pistes PMD Red `Tiny Woods.ogg` et `Thunderwave Cave.ogg` n’existent ni dans `Content/Music` du mod ni dans le catalogue PMDO base. Le mapgen accepte le champ texte sans charger l’audio ; ce n’est donc pas une preuve d’asset.

La tentative de promotion a été annulée après le préflight. Les `Data/Zone` actives ont été restaurées. Aucune musique de remplacement n’est utilisée.

## Preuves

- `batch_report.json` ;
- `native_mapgen_report.md` ;
- `runtime/native_mapgen.jsonl` ;
- `runtime/routes/tiny_woods.jsonl` et `.log` ;
- `runtime/routes/thunderwave_cave.jsonl` et `.log`.
