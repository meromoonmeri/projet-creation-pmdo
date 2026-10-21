"""Suite de vérification intégrale — Lot 2 : Treehouses de Guilde SANS ESCALIER EXTÉRIEUR (Jardin Secret & Sky Peak)."""
from __future__ import annotations

import io
import json
import re
import struct
import subprocess
import zipfile
from pathlib import Path

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
OUT_DIR = R / "livrables_guilde_sans_escalier_pmdo"
OUT_1X = OUT_DIR / "1x_PMDO_8px_sans_fond"
OUT_HD = OUT_DIR / "HD_sans_fond"
OUT_TILE = OUT_DIR / "Mod_PMDO_Tile_Pret_A_Importer" / "Content" / "Tile"
OUT_ZIP = OUT_DIR / "PACK_GUILDE_SANS_ESCALIER_JARDIN_SKYPEAK_PMDO.zip"
OUT_HTML = R / "apercu_guilde_sans_escalier_jardin_skypeak.html"

EXPECTED_PREFIXES = {"GJN1", "GJN2", "GJN3", "GJN4", "GSN1", "GSN2", "GSN3", "GSN4"}


def decode_pmdo_tile(path: Path) -> Image.Image:
    raw = path.read_bytes()
    tile_size, count = struct.unpack_from("<II", raw, 0)
    assert tile_size == 8, f"{path}: tile_size attendu 8, obtenu {tile_size}"
    coords = []
    for i in range(count):
        x, y, off = struct.unpack_from("<IIQ", raw, 8 + 16 * i)
        (png_len,) = struct.unpack_from("<q", raw, off)
        png_bytes = raw[off + 8 : off + 8 + png_len]
        t_im = Image.open(io.BytesIO(png_bytes)).convert("RGBA")
        assert t_im.size == (8, 8)
        coords.append((x, y, t_im))
    max_x = max(x for x, _, _ in coords) + 1
    max_y = max(y for _, y, _ in coords) + 1
    canvas = Image.new("RGBA", (max_x * 8, max_y * 8), (0, 0, 0, 0))
    for x, y, t_im in coords:
        canvas.paste(t_im, (x * 8, y * 8))
    return canvas


def check_rgba_binary_and_clean(path: Path) -> np.ndarray:
    arr = np.array(Image.open(path).convert("RGBA"))
    alpha = arr[:, :, 3]
    uniq_a = set(np.unique(alpha).tolist())
    assert uniq_a.issubset({0, 255}), f"{path}: alpha non binaire {uniq_a}"
    opaque = alpha == 255
    assert np.any(opaque), f"{path}: image vide"
    r, g, b = arr[:, :, 0].astype(np.int16), arr[:, :, 1].astype(np.int16), arr[:, :, 2].astype(np.int16)
    fringe = opaque & ((b - np.maximum(r, g)) > 20) & (b > 95) & (r < 80)
    assert int(fringe.sum()) == 0, f"{path}: {int(fringe.sum())} pixels de frange bleue!"
    return arr


def main() -> None:
    manifest = json.loads((OUT_DIR / "manifest.json").read_text(encoding="utf-8"))
    assert manifest["exterior_stairs_count"] == 0
    assert manifest["pyramidal_roofs_count"] == 0
    assert manifest["art_approved"] is False
    assert manifest["runtime_tested"] is False
    assert set(manifest["tile_prefixes"]) == EXPECTED_PREFIXES
    assert len(manifest["structures"]) == 8

    # 1. Unicité des préfixes .tile de 4 caractères sur TOUT le dépôt
    foreign_prefixes = set()
    for tp in R.rglob("*.tile"):
        if OUT_DIR in tp.parents:
            continue
        foreign_prefixes.add(tp.name[:4])
    overlap = EXPECTED_PREFIXES & foreign_prefixes
    assert not overlap, f"Collision de préfixes .tile détectée: {overlap}"

    # 2. Intégrité pixel-par-pixel de toutes les images HD, 1x, découpes et banques .tile
    for st in manifest["structures"]:
        slug = st["slug"]
        pfx = st["pfx"]
        assert st["exterior_stairs_count"] == 0
        assert st["pyramidal_roofs_count"] == 0
        assert st["art_approved"] is False
        assert st["runtime_tested"] is False
        assert st["occluded_pixels_reconstructed"] is False

        hd_j = check_rgba_binary_and_clean(OUT_HD / f"{slug}_HD_jour.png")
        hd_n = check_rgba_binary_and_clean(OUT_HD / f"{slug}_HD_nuit.png")
        assert hd_j.shape == hd_n.shape

        im_j = check_rgba_binary_and_clean(OUT_1X / f"{slug}_1x_jour.png")
        im_n = check_rgba_binary_and_clean(OUT_1X / f"{slug}_1x_nuit.png")
        im_av = check_rgba_binary_and_clean(OUT_1X / f"{slug}_1x_Avant_Base.png")
        im_ar = check_rgba_binary_and_clean(OUT_1X / f"{slug}_1x_Arriere_Under.png")
        assert im_j.shape[0] % 8 == 0 and im_j.shape[1] % 8 == 0

        assert int(np.sum((im_av[:, :, 3] > 0) & (im_ar[:, :, 3] > 0))) == 0
        recombined = np.where((im_av[:, :, 3] > 0)[:, :, None], im_av, im_ar)
        assert np.array_equal(recombined, im_j), f"{slug}: Avant_Base U Arriere_Under != 1x_jour"

        rec_j = np.array(decode_pmdo_tile(OUT_TILE / f"{pfx}_Jour.tile"))
        rec_n = np.array(decode_pmdo_tile(OUT_TILE / f"{pfx}_Nuit.tile"))
        assert np.array_equal(rec_j, im_j), f"{pfx}_Jour.tile ne reconstruit pas exactement 1x_jour!"
        assert np.array_equal(rec_n, im_n), f"{pfx}_Nuit.tile ne reconstruit pas exactement 1x_nuit!"

        tsj_j = json.loads((OUT_TILE / f"{pfx}_Jour.tsj").read_text(encoding="utf-8"))
        assert tsj_j["tilewidth"] == 8 and tsj_j["tileheight"] == 8
        assert tsj_j["imagewidth"] == im_j.shape[1] and tsj_j["imageheight"] == im_j.shape[0]
        assert (OUT_TILE / tsj_j["image"]).resolve().exists()

    # 3. Vérification des planches récapitulatives, de l'archive ZIP et de la galerie HTML sans <canvas>/damier
    check_rgba_binary_and_clean(OUT_1X / "00_Planche_Complete_Jour_SansEscalier_Jardin_SkyPeak.png")
    check_rgba_binary_and_clean(OUT_1X / "00_Planche_Complete_Nuit_SansEscalier_Jardin_SkyPeak.png")

    with zipfile.ZipFile(OUT_ZIP, "r") as zf:
        assert zf.testzip() is None
        names = set(zf.namelist())
        assert "README.md" in names and "manifest.json" in names
        assert len(names) >= 70

    html = OUT_HTML.read_text(encoding="utf-8")
    assert "<canvas" not in html.lower(), "Balise <canvas> interdite!"
    assert not re.search(r"repeating-conic-gradient|checkerboard", html, re.I), "Damier interdit!"
    assert html.count('<img id="img-') == 8

    # 4. Vérification stricte du budget global du dépôt (< 128.00 MiB vs commit de base 9fa272a)
    out = subprocess.check_output(
        ["git", "diff", "--name-status", "9fa272ae2e5a9b18021802371540b7fd55a32d9e"],
        cwd=R,
        text=True,
    )
    tracked_delta = 0
    seen = set()
    for line in out.strip().splitlines():
        p = R / line.split("\t")[-1]
        if p.exists() and p.is_file():
            tracked_delta += p.stat().st_size
            seen.add(p.resolve())
    untracked = subprocess.check_output(["git", "ls-files", "--others", "--exclude-standard"], cwd=R, text=True)
    new_bytes = sum(
        (R / ln.strip()).stat().st_size
        for ln in untracked.strip().splitlines()
        if ln.strip() and (R / ln.strip()).is_file() and (R / ln.strip()).resolve() not in seen
    )
    total_mib = (tracked_delta + new_bytes) / (1024 * 1024)
    assert total_mib < 126.0, f"Delta dépôt trop élevé: {total_mib:.2f} MiB >= 126.0 MiB!"

    print(f"[ALL TESTS PASSED] 8 structures Sans Escalier Extérieur (GJN1..GJN4, GSN1..GSN4) OK! Delta={total_mib:.2f}/128.00 MiB")


if __name__ == "__main__":
    main()
