# PMD Red EU — Audio canonique (extraction ROM)

## Chaîne de production

```
pmdred-eu.gba (SHA-256 pinned, byte-for-byte from meromoonmeri/PMD-RED-PMDO-PORT@b441d467)
    │
    ├─▶ IAGOnGithub/gba-mus-ripper @ 16fc3735
    │       ├─▶ song_ripper : sequence Sappy/mp2k → MIDI (940 slots, 574 uniques)
    │       └─▶ sound_font_ripper : voicegroups Sappy → SF2 (6 banques valides, avec pdta)
    │
    ├─▶ pyFluidSynth (libfluidsynth 3.5.6 bundled by pygame-ce wheel)
    │       MIDI + SF2 → WAV 44100 Hz / 16-bit / stereo
    │
    └─▶ ffmpeg 7.0.2 static (imageio-ffmpeg wheel)
            WAV → OGG Vorbis (-qscale:a 5 -ar 44100 -ac 2, format attendu par PMDO)
```

Tout est piloté par `tools/dungeon_builder/rom_audio_extract.py` — script idempotent,
provenance JSON complète produite dans `docs/canonical/red/audio/pmdred_eu_music_extraction.json`
à chaque exécution.

## Fichiers importants

| Fichier | Rôle |
|---|---|
| `ROM_AUDIO_TRANSPORT_AUDIT.json` | Diagnostic exhaustif des tentatives de récupération de la ROM PMD Red EU depuis le repo `meromoonmeri/BIBLIOTHEQUE`, transport LFS bloqué dans le sandbox, et solution retenue (source alternative canonique déjà déclarée par `tools/restore_pmdred_eu_validation_runtime.sh`). |
| `pmdred_eu_music_extraction.json` | Rapport machine de l'extraction, avec les SHA-256 de chaque MIDI, SF2, WAV et OGG produits, l'ID d'enum MusicID et la banque d'échantillons utilisée. |
| `AMMO_GRAVELEROCK_IMPORT_AUDIT.json` | Import canonique de l'item `ammo_gravelerock` depuis PMDODump/DumpAsset au commit épinglé `d74394dc…` (submodule de `audinowho/PMDODump@21ec4abd…`, le pin utilisé par `scope_registry.py`). Débloque `thunderwave_cave` sur `audit-all`. |

## Correspondance ROM ↔ PMDO

| pret enum `MusicID` | valeur | song_table.inc | song rip | Banque | OGG sortie |
|---|---:|---|---|---:|---|
| `MUS_THUNDERWAVE_CAVE` | 14 | `seq_014` | `song0014.mid` | 0 | `Content/Music/Thunderwave Cave.ogg` |
| `MUS_SINISTER_WOODS` | 15 | `seq_015` | `song0015.mid` | 0 | (Sinister Woods.ogg pré-existant conservé — voir ci-dessous) |
| `MUS_TINY_WOODS` | 125 | `seq_125` | `song0125.mid` | 1 | `Content/Music/Tiny Woods.ogg` |

Correction importante par rapport aux notes précédentes : `MUS_TINY_WOODS` = **125**
(vérifié en compilant l'enum `MusicID` de pret/pmd-red @ `bf0092d0`), pas 126. Le
numéro `seq_126` correspond à une autre piste. Cette différence n'a aucun impact
autre qu'un renommage d'ID dans la doc.

## Sinister Woods.ogg — non écrasé

`Content/Music/Sinister Woods.ogg` existe déjà dans le repo (SHA-256
`3a0870204bf21da1648e2af0747a74a18e6c9430aac9bc48a7a2e7867d8c3ce7`, importé
antérieurement lors de la promotion de gloomy_forest). Ce fichier n'a **pas** été
remplacé par le rendu ROM local (SHA `6a0cf68e…`) même si le rendu ROM figure dans
le rapport comme PASS. Motif : la zone active `Data/Zone/gloomy_forest.json` est
déjà promue et route-validée avec l'asset existant ; le rendu ROM local sert
uniquement à démontrer que la même piste peut être régénérée à volonté depuis la
ROM byte-vérifiée. Si un futur audit veut basculer la sinister sur le rendu local,
il suffit de rejouer `python3 tools/dungeon_builder/rom_audio_extract.py --track
MUS_SINISTER_WOODS="Sinister Woods.ogg"` puis de re-valider la route
`sinister_full_route_runtime.jsonl`.

## Rejouer

```bash
# depuis la racine du repo
python3 tools/dungeon_builder/rom_audio_extract.py
#   ↳ écrit .runtime-cache/audio/... (git-ignored)
#   ↳ écrit Content/Music/Tiny Woods.ogg et Content/Music/Thunderwave Cave.ogg
#   ↳ écrit docs/canonical/red/audio/pmdred_eu_music_extraction.json
```

Prérequis :

1. La ROM PMD Red EU byte-vérifiée à `.runtime-cache/downloads/pmdred-eu.gba` — obtenue
   via `tools/restore_pmdred_eu_validation_runtime.sh` sur les branches supportées,
   ou en clonant à la main `meromoonmeri/PMD-RED-PMDO-PORT@b441d467` (SHA-256
   `0f9d125d…4cbcd`, taille exacte 33 554 432 octets).
2. Un checkout de `pret/pmd-red@bf0092d0` à `/tmp/pmd-red-audio` (pour lire l'enum
   `MusicID`). Le script ne modifie jamais ce dossier ; il n'en extrait que le header.
3. Le venv `.runtime-cache/audio-venv` avec `pygame-ce`, `pyFluidSynth`,
   `imageio-ffmpeg`, `mido`, `numpy` installés.

## Ce que le pipeline **ne fait pas**

- Aucune substitution : quand une piste est demandée pour un donjon, elle est
  rippée depuis la ROM PMD Red EU et rien d'autre. `music_map_gba_pmdo.json`
  restait un mapping de secours (par exemple `"Thunderwave Cave" → "Thunderstruck
  Pass.ogg"`) qui n'est **plus utilisé** pour D01/D02.
- Aucun placeholder : si l'extraction d'une piste échoue (SF2 rejeté, chunk RIFF
  invalide, MIDI absent du song_table…), le status devient `FAIL`, la raison
  exacte est enregistrée dans le report, et le batch reste fail-closed pour ce
  donjon (blocker `CANONICAL_MUSIC_ASSET_MISSING` réactivé).
- Aucun rendu approximatif : le FluidSynth utilisé est libfluidsynth 3.5.6
  (bundled dans pygame-ce), pas un synthétiseur maison. Les échantillons PCM
  proviennent des voicegroups Sappy dans la ROM, décodés par `sound_font_ripper`
  puis rendus par FluidSynth avec le SF2 original de la banque appropriée.
