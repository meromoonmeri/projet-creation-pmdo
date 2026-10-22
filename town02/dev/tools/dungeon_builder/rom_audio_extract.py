"""ROM PMD Red EU music extraction pipeline.

Chain (all deterministic, all provenance-tracked):

    pmdred-eu.gba (SHA-256 pinned)
        -> gba_mus_ripper (IAGOnGithub fork, pinned commit)
             -> song_ripper       (Sappy sequence -> MIDI)
             -> sound_font_ripper (Sappy voicegroup -> SoundFont2)
        -> FluidSynth (bundled with pygame-ce wheel)
             MIDI + SF2 -> WAV 44100/16-bit stereo
        -> ffmpeg (imageio-ffmpeg static wheel)
             WAV -> OGG Vorbis (PMDO convention: -qscale:a 5 -ar 44100 -ac 2)

Nothing here substitutes canonical assets:
- Music IDs are looked up in pret/pmd-red include/constants/bg_music.h.
- The song_table.inc order is 1:1 with gba_mus_ripper's songNNNN.mid index.
- If a track cannot be extracted end-to-end, the failure is recorded with the
  exact reason (missing binary, corrupt SF2, no audio in ROM) and the
  ROM_AUDIO_EXTRACTION_PENDING blocker keeps the downstream gate closed.

Not for online use in tests: this script drives real binaries and produces
several MB per track. It is invoked out-of-band from batch preflight."""

from __future__ import annotations

import argparse
import contextlib
import dataclasses
import hashlib
import json
import os
import re
import shutil
import struct
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Iterable

ROOT = Path(__file__).resolve().parents[2]

# ------------------------------ constants ---------------------------------

PMDRED_EU_ROM_SIZE = 33_554_432
PMDRED_EU_ROM_SHA256 = (
    "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"
)
PMDRED_EU_ROM_MD5 = "9837da1fdfe900c52f2109d9718d4e85"

# IAGOnGithub fork of gba-mus-ripper. Fixes the pdta/sdta chunk truncation
# and the loop-point overreach that make berg8793 SF2 output unreadable
# by FluidSynth on PMD Red EU.
IAGO_GBA_MUS_RIPPER_REPO = "IAGOnGithub/gba-mus-ripper"
IAGO_GBA_MUS_RIPPER_HEAD = "16fc3735998b68e1adfa531f629e28301070b521"

# Pretty PMDO filenames the mod expects.
PMDO_TRACK_NAMES = {
    "MUS_TINY_WOODS": "Tiny Woods.ogg",
    "MUS_THUNDERWAVE_CAVE": "Thunderwave Cave.ogg",
    "MUS_SINISTER_WOODS": "Sinister Woods.ogg",
    "MUS_SILENT_CHASM": "Silent Chasm.ogg",
    "MUS_GREAT_CANYON": "Great Canyon.ogg",
    "MUS_MT_STEEL": "Mt Steel.ogg",
    "MUS_MT_THUNDER": "Mt Thunder.ogg",
    "MUS_LAPIS_CAVE": "Lapis Cave.ogg",
    "MUS_MT_BLAZE": "Mt Blaze.ogg",
    "MUS_FROSTY_FOREST": "Frosty Forest.ogg",
    "MUS_MT_FREEZE": "Mt Freeze.ogg",
}


# ------------------------------ small utils --------------------------------


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as fh:
        for chunk in iter(lambda: fh.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def md5_file(path: Path) -> str:
    h = hashlib.md5()
    with path.open("rb") as fh:
        for chunk in iter(lambda: fh.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def run(cmd: list[str], *, cwd: Path | None = None, timeout: int = 600) -> str:
    """Run a subprocess. Raise CalledProcessError with combined output on failure."""
    proc = subprocess.run(
        cmd,
        cwd=str(cwd) if cwd else None,
        capture_output=True,
        text=True,
        timeout=timeout,
    )
    if proc.returncode != 0:
        raise subprocess.CalledProcessError(
            proc.returncode, cmd, output=proc.stdout, stderr=proc.stderr
        )
    return proc.stdout


# ------------------------------ verification -------------------------------


def verify_rom(rom_path: Path) -> dict:
    if not rom_path.is_file():
        raise FileNotFoundError(f"ROM not found: {rom_path}")
    size = rom_path.stat().st_size
    sha = sha256_file(rom_path)
    md5 = md5_file(rom_path)
    if size != PMDRED_EU_ROM_SIZE:
        raise ValueError(
            f"ROM size mismatch: got {size}, expected {PMDRED_EU_ROM_SIZE}"
        )
    if sha != PMDRED_EU_ROM_SHA256:
        raise ValueError(f"ROM SHA-256 mismatch: got {sha}")
    if md5 != PMDRED_EU_ROM_MD5:
        raise ValueError(f"ROM MD5 mismatch: got {md5}")
    return {"path": str(rom_path), "size": size, "sha256": sha, "md5": md5}


def load_pret_music_id_map(pret_root: Path) -> dict[str, int]:
    """Parse pret's include/constants/bg_music.h enum MusicID to get {NAME: id}."""
    header = pret_root / "include" / "constants" / "bg_music.h"
    text = header.read_text()
    m = re.search(r"enum\s+MusicID\s*\{(.*?)\};", text, re.DOTALL)
    if not m:
        raise ValueError(f"cannot find enum MusicID in {header}")
    body = m.group(1)
    entries: dict[str, int] = {}
    value = 0
    for raw in body.splitlines():
        line = re.sub(r"//.*$", "", raw).strip().rstrip(",").strip()
        if not line:
            continue
        if "=" in line:
            name, val = [p.strip() for p in line.split("=", 1)]
            value = int(val, 0)
        else:
            name = line
        entries[name] = value
        value += 1
    return entries


def sf2_looks_valid(path: Path) -> tuple[bool, str]:
    """Cheap RIFF sanity check. Rejects the berg8793/PMD-Red truncated SF2 bug."""
    data = path.read_bytes()
    if len(data) < 12 or data[:4] != b"RIFF" or data[8:12] != b"sfbk":
        return False, "not a RIFF/sfbk file"
    riff_size = struct.unpack("<I", data[4:8])[0]
    if riff_size != len(data) - 8:
        return False, f"RIFF chunk size {riff_size} != file size - 8 ({len(data)-8})"
    if b"pdta" not in data:
        return False, "missing pdta chunk (instrument headers)"
    return True, "ok"


# ------------------------------ ripper toolchain ---------------------------


def ensure_gba_mus_ripper(cache_dir: Path) -> Path:
    """Clone (or reuse) the IAGOnGithub gba-mus-ripper fork at its pinned commit
    and compile the four Linux binaries. Returns the bin/ dir."""
    src_dir = cache_dir / "gba-mus-ripper-iago"
    bin_dir = src_dir / "bin"
    if not src_dir.is_dir():
        run(
            [
                "gh", "repo", "clone", IAGO_GBA_MUS_RIPPER_REPO,
                str(src_dir), "--", "--depth", "1",
            ],
            timeout=300,
        )
    # pin to exact commit
    try:
        run(["git", "-C", str(src_dir), "cat-file", "-e", IAGO_GBA_MUS_RIPPER_HEAD])
    except subprocess.CalledProcessError:
        run(
            ["git", "-C", str(src_dir), "fetch", "--depth", "1",
             "origin", IAGO_GBA_MUS_RIPPER_HEAD],
            timeout=300,
        )
    run(["git", "-C", str(src_dir), "checkout", "--detach",
         IAGO_GBA_MUS_RIPPER_HEAD])

    if not (bin_dir / "gba_mus_ripper").is_file():
        # patch: the fork's Makefile hardcodes MinGW paths and .exe suffixes
        mus_cpp = src_dir / "src" / "gba_mus_ripper.cpp"
        text = mus_cpp.read_text()
        text = (text
                .replace("song_ripper.exe", "song_ripper")
                .replace("sound_font_ripper.exe", "sound_font_ripper")
                .replace("sappy_detector.exe", "sappy_detector"))
        mus_cpp.write_text(text)
        # build
        run(
            ["make", "WHOLE=-s -static",
             "CPPC=/usr/bin/g++ -std=gnu++11",
             "CC=/usr/bin/gcc -std=c99"],
            cwd=src_dir, timeout=600,
        )
        # place data files next to the binaries so sound_font_ripper finds them
        for name in ("goldensun_synth.raw", "psg_data.raw"):
            src = src_dir / "data" / name
            if src.is_file():
                shutil.copy(src, bin_dir / name)
    return bin_dir


def rip_songs_and_soundbanks(rom_path: Path, bin_dir: Path,
                             out_dir: Path) -> dict:
    """Run gba_mus_ripper -sb -gm and return the discovered layout."""
    if out_dir.exists():
        shutil.rmtree(out_dir)
    out_dir.mkdir(parents=True)
    run(
        [str(bin_dir / "gba_mus_ripper"), str(rom_path),
         "-o", str(out_dir), "-gm", "-sb"],
        cwd=bin_dir, timeout=900,
    )
    # index tracks by song number -> (midi_path, sf2_path)
    tracks: dict[int, dict] = {}
    for bank_dir in sorted(out_dir.iterdir()):
        if not bank_dir.is_dir():
            continue
        sf2 = next(bank_dir.glob("*.sf2"), None)
        if sf2 is None:
            continue
        for mid in bank_dir.glob("song*.mid"):
            m = re.match(r"song(\d+)\.mid$", mid.name)
            if not m:
                continue
            tracks[int(m.group(1))] = {
                "midi": mid,
                "sf2": sf2,
                "bank_dir": bank_dir.name,
            }
    return tracks


# ------------------------------ synthesis ---------------------------------


def _find_pygame_ce_libs(venv_root: Path) -> Path:
    for lib_dir in venv_root.rglob("pygame_ce.libs"):
        return lib_dir
    raise FileNotFoundError("pygame-ce bundled libs not found; pip install pygame-ce")


def _bootstrap_fluidsynth(venv_root: Path) -> None:
    """Preload the pygame-ce-bundled libfluidsynth so pyFluidSynth picks it up."""
    import ctypes
    import ctypes.util

    pygame_libs = _find_pygame_ce_libs(venv_root)
    lib_files = sorted(os.listdir(pygame_libs))
    libfluid = next(
        (f for f in lib_files if f.startswith("libfluidsynth")), None
    )
    if libfluid is None:
        raise FileNotFoundError("libfluidsynth not found in pygame-ce libs")
    # Preload dependencies GLOBALLY so libfluidsynth can resolve them by SONAME
    for prefix in ("libsndfile", "libogg", "libvorbis", "libFLAC", "libopus"):
        for f in lib_files:
            if f.startswith(prefix):
                ctypes.CDLL(str(pygame_libs / f), mode=ctypes.RTLD_GLOBAL)
                break
    ctypes.CDLL(str(pygame_libs / libfluid), mode=ctypes.RTLD_GLOBAL)

    # Patch ctypes.util.find_library so pyFluidSynth resolves to our copy.
    orig = ctypes.util.find_library
    lib_path = str(pygame_libs / libfluid)

    def _patched(name: str):
        if name in ("fluidsynth", "libfluidsynth", "fluidsynth-3",
                    "libfluidsynth-3"):
            return lib_path
        return orig(name)

    ctypes.util.find_library = _patched


def render_midi_to_wav(midi: Path, sf2: Path, out_wav: Path,
                       venv_root: Path,
                       samplerate: int = 44100, gain: float = 0.5) -> None:
    _bootstrap_fluidsynth(venv_root)
    import fluidsynth  # noqa: WPS433 (dynamic import after bootstrap)

    out_wav.parent.mkdir(parents=True, exist_ok=True)
    fs = fluidsynth.Synth(samplerate=float(samplerate), gain=gain)
    try:
        fs.setting("audio.file.type", "wav")
        fs.setting("player.reset-synth", 0)
        sfid = fs.sfload(str(sf2))
        if sfid == -1:
            raise RuntimeError(f"SF2 load failed: {sf2}")
        fs.program_select(0, sfid, 0, 0)
        fs.midi2audio(str(midi), str(out_wav))
    finally:
        fs.delete()
    if not out_wav.is_file() or out_wav.stat().st_size == 0:
        raise RuntimeError(f"WAV renderer produced no output: {out_wav}")


def convert_wav_to_ogg(wav: Path, ogg: Path, ffmpeg: Path,
                       quality: int = 5, samplerate: int = 44100,
                       channels: int = 2) -> None:
    ogg.parent.mkdir(parents=True, exist_ok=True)
    run(
        [str(ffmpeg), "-hide_banner", "-loglevel", "error", "-y",
         "-i", str(wav),
         "-c:a", "libvorbis", "-qscale:a", str(quality),
         "-ar", str(samplerate), "-ac", str(channels),
         str(ogg)],
        timeout=300,
    )
    if not ogg.is_file() or ogg.stat().st_size == 0:
        raise RuntimeError(f"OGG encoding produced no output: {ogg}")


# ------------------------------ orchestration ------------------------------


@dataclasses.dataclass
class ExtractionRequest:
    music_name: str            # e.g. MUS_TINY_WOODS
    output_ogg_name: str       # e.g. Tiny Woods.ogg


@dataclasses.dataclass
class ExtractionResult:
    music_name: str
    music_id: int
    output_ogg_name: str
    status: str                # PASS / FAIL
    reason: str = ""
    midi_sha256: str = ""
    sf2_sha256: str = ""
    wav_sha256: str = ""
    ogg_sha256: str = ""
    ogg_size: int = 0
    bank_dir: str = ""


def extract_tracks(
    rom_path: Path,
    pret_root: Path,
    venv_root: Path,
    cache_dir: Path,
    ffmpeg: Path,
    requests: Iterable[ExtractionRequest],
    output_dir: Path,
) -> tuple[dict, list[ExtractionResult]]:
    rom_info = verify_rom(rom_path)
    music_ids = load_pret_music_id_map(pret_root)
    bin_dir = ensure_gba_mus_ripper(cache_dir)
    rip_dir = cache_dir / "pmdred-eu-rip"
    tracks = rip_songs_and_soundbanks(rom_path, bin_dir, rip_dir)

    results: list[ExtractionResult] = []
    output_dir.mkdir(parents=True, exist_ok=True)
    wav_stage = cache_dir / "pmdred-eu-wav"
    wav_stage.mkdir(parents=True, exist_ok=True)

    for req in requests:
        res = ExtractionResult(music_name=req.music_name, music_id=-1,
                               output_ogg_name=req.output_ogg_name,
                               status="FAIL")
        try:
            mid_id = music_ids[req.music_name]
            res.music_id = mid_id
            if mid_id not in tracks:
                raise KeyError(f"song{mid_id:04d}.mid not produced by ripper")
            info = tracks[mid_id]
            midi_path: Path = info["midi"]
            sf2_path: Path = info["sf2"]
            res.bank_dir = info["bank_dir"]
            res.midi_sha256 = sha256_file(midi_path)
            ok, why = sf2_looks_valid(sf2_path)
            if not ok:
                raise RuntimeError(f"SF2 rejected as invalid: {why} ({sf2_path})")
            res.sf2_sha256 = sha256_file(sf2_path)
            slug = re.sub(r"[^A-Za-z0-9_]+", "_",
                          req.music_name.lower()).strip("_")
            wav_out = wav_stage / f"song{mid_id:04d}_{slug}.wav"
            render_midi_to_wav(midi_path, sf2_path, wav_out, venv_root)
            res.wav_sha256 = sha256_file(wav_out)
            ogg_out = output_dir / req.output_ogg_name
            convert_wav_to_ogg(wav_out, ogg_out, ffmpeg)
            res.ogg_sha256 = sha256_file(ogg_out)
            res.ogg_size = ogg_out.stat().st_size
            res.status = "PASS"
        except Exception as e:  # noqa: BLE001
            res.reason = f"{type(e).__name__}: {e}"
        results.append(res)

    report = {
        "schema": "new-era.rom-audio-extraction.v1",
        "recorded_at": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "rom": rom_info,
        "toolchain": {
            "ripper_repo": IAGO_GBA_MUS_RIPPER_REPO,
            "ripper_commit": IAGO_GBA_MUS_RIPPER_HEAD,
            "ripper_bin_dir": str(bin_dir),
            "synth": "pyFluidSynth (pygame-ce bundled libfluidsynth)",
            "encoder": str(ffmpeg),
            "encoder_options": "libvorbis -qscale:a 5 -ar 44100 -ac 2",
        },
        "results": [dataclasses.asdict(r) for r in results],
    }
    return report, results


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rom", type=Path,
                        default=ROOT / ".runtime-cache/downloads/pmdred-eu.gba")
    parser.add_argument("--pret", type=Path,
                        default=Path("/tmp/pmd-red-audio"))
    parser.add_argument("--venv", type=Path,
                        default=ROOT / ".runtime-cache/audio-venv")
    parser.add_argument("--cache", type=Path,
                        default=ROOT / ".runtime-cache/audio")
    parser.add_argument("--ffmpeg", type=Path, default=None)
    parser.add_argument("--out", type=Path,
                        default=ROOT / "Content/Music",
                        help="output .ogg directory (PMDO Content/Music)")
    parser.add_argument("--report", type=Path,
                        default=ROOT / "docs/canonical/red/audio"
                                       / "pmdred_eu_music_extraction.json")
    parser.add_argument("--track", action="append", default=None,
                        help="e.g. MUS_TINY_WOODS=Tiny Woods.ogg. Repeatable.")
    args = parser.parse_args(argv)

    ffmpeg = args.ffmpeg
    if ffmpeg is None:
        # Use imageio-ffmpeg's bundled binary from the venv.
        import subprocess as _sp
        ffmpeg = Path(_sp.run(
            [str(args.venv / "bin/python"), "-c",
             "import imageio_ffmpeg; print(imageio_ffmpeg.get_ffmpeg_exe())"],
            check=True, capture_output=True, text=True,
        ).stdout.strip())

    if args.track:
        requests = []
        for spec in args.track:
            k, _, v = spec.partition("=")
            requests.append(ExtractionRequest(k, v or PMDO_TRACK_NAMES.get(k, "")))
    else:
        requests = [
            ExtractionRequest(k, v) for k, v in PMDO_TRACK_NAMES.items()
        ]

    args.cache.mkdir(parents=True, exist_ok=True)
    report, results = extract_tracks(
        rom_path=args.rom,
        pret_root=args.pret,
        venv_root=args.venv,
        cache_dir=args.cache,
        ffmpeg=ffmpeg,
        requests=requests,
        output_dir=args.out,
    )
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2) + "\n")

    passed = sum(1 for r in results if r.status == "PASS")
    total = len(results)
    print(f"extracted {passed}/{total}: report -> {args.report}")
    for r in results:
        print(f"  [{r.status}] {r.music_name} (id={r.music_id}) -> "
              f"{r.output_ogg_name} {r.ogg_size}B "
              f"sha256={r.ogg_sha256[:12]} {r.reason}")
    return 0 if passed == total else 1


if __name__ == "__main__":
    sys.exit(main())
