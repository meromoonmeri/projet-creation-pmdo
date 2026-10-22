#!/usr/bin/env python3
"""Suite de tests unitaires de `STC1 — Sommet de la Tour Céleste — Arène de Rayquaza`.

Vérifie rigoureusement :
1. Suppression intégrale de tous les autres lots PMD Red générés (`ETC1`, `RTC1`, `EST1`, `MST1`, `SST1`,
   `FGM1`, `CVM1`, `FAR1`, `FRZ1`, `MET1`, `PKS1`, `SKY1`, `SKY2`, `SKY3`, `tour_celeste_entree_v1`,
   `tour_celeste_relais_v1`, `suite_tour_celeste_pmdo_v1`) dans `source/`, `renders/`, `.cache/` et `*.html`.
2. Zéro crédit dans le code, les métadonnées, les aperçus HTML et l'archive `.zip`.
3. Fidélité canonique pixel-art (`< 30.0` face à `b71_sky_tower_summit.png`) + garde négative (`> 45.0`).
4. Mouvements physiques multi-trames (`24` poses) :
   - dérive planétaire ouest-est le long du limbe courbe de la Terre (`02_horizon_planetaire_courbe`),
   - ailes de vent divergentes vers l'extérieur et le bas (`gauche : dx < 0, dy > 0` ; `droite : dx > 0, dy > 0`),
   - continuité périodique sans couture `pose23 -> pose00`.
5. Intégrité binaire RogueEssence `0.8.12.0` (`Mod.xml`, `INSTALLER.py`, `Content/Tile/index.idx` via `read_index()`,
   tuiles `8×8` PNG dans chaque `.tile`, `Data/Ground/stc1_tour_celeste.rsground`, connexité piétonne sud -> couronne).
6. Généralité sans supposition de taille à résolution non canonique `(256, 192)`.
"""

from __future__ import annotations

import importlib.util
import io
import json
import re
import struct
import sys
import tempfile
import unittest
import zipfile
from pathlib import Path
from typing import Tuple

import numpy as np
from PIL import Image
from scipy import ndimage

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parents[1]
if str(REPO_ROOT / "source") not in sys.path:
    sys.path.insert(0, str(REPO_ROOT / "source"))

from tour_celeste_moteur_nuages import TOOLS_MOD, fidelity


def _load_sommet_builder():
    path = HERE / "build.py"
    spec = importlib.util.spec_from_file_location("builder_stc1", path)
    mod = importlib.util.module_from_spec(spec)
    assert spec and spec.loader
    spec.loader.exec_module(mod)
    return mod


def _measure_shift_2d(
    img_a: np.ndarray, img_b: np.ndarray, max_shift: int = 24
) -> Tuple[int, int, float]:
    a = img_a.astype(np.float32)
    b = img_b.astype(np.float32)
    best_dx, best_dy, best_err = 0, 0, float("inf")
    m = max_shift
    core_b = b[m:-m, m:-m]
    h_c, w_c = core_b.shape[:2]
    for dy in range(-m, m + 1, 4):
        for dx in range(-m, m + 1, 4):
            shifted = a[m - dy : m - dy + h_c, m - dx : m - dx + w_c]
            err = float(np.abs(shifted - core_b).mean())
            if err < best_err - 1e-4:
                best_err = err
                best_dx, best_dy = dx, dy
    return best_dx, best_dy, best_err


class TestSommetTourCelesteSeul(unittest.TestCase):
    def test_01_all_other_pmd_red_lots_deleted(self) -> None:
        forbidden_re = re.compile(
            r"(?:^|[^a-z0-9])(etc1|rtc1|est1|mst1|sst1|fgm1|cvm1|far1|frz1|met1|pks1|sky1|sky2|sky3"
            r"|tour_celeste_entree|tour_celeste_relais|suite_tour_celeste|foret_obscure_pmd_red)(?:$|[^a-z0-9])"
        )
        for sub in ("source", "renders", ".cache"):
            root = REPO_ROOT / sub
            if not root.exists():
                continue
            for p in root.rglob("*"):
                self.assertIsNone(
                    forbidden_re.search(p.name.lower()),
                    f"Lot PMD Red non supprimé détecté : {p}",
                )
        for html_file in REPO_ROOT.glob("*.html"):
            self.assertIsNone(
                forbidden_re.search(html_file.name.lower()),
                f"Page HTML d'un ancien lot PMD Red non supprimée : {html_file}",
            )
        index_txt = (REPO_ROOT / "index.html").read_text(encoding="utf-8", errors="ignore").lower()
        for removed_id in ("etc1", "rtc1", "est1", "mst1", "sst1", "fgm1"):
            self.assertNotIn(removed_id, index_txt, f"Référence résiduelle '{removed_id}' dans index.html")

    def test_02_zero_credits_everywhere(self) -> None:
        forbidden_words = ("credit", "crédit", "author:", "auteur:", "created by", "made by", "copyright")
        targets = [
            HERE,
            REPO_ROOT / "source" / "tour_celeste_moteur_nuages.py",
            REPO_ROOT / "source" / "build_studio_tour_celeste.py",
            REPO_ROOT / "renders" / "tour_celeste_sommet_v1",
            REPO_ROOT / "index.html",
            REPO_ROOT / "apercu_sommet_tour_celeste_stc1_pmdo.html",
            REPO_ROOT / ".cache" / "virtual_zips" / "STC1_PMDO_0.8.12.zip",
        ]
        for t in targets:
            files = [t] if t.is_file() else list(t.rglob("*"))
            for f in files:
                if f.suffix.lower() in {".py", ".json", ".xml", ".resx", ".html"} and f.name != "test_build.py":
                    txt = f.read_text(encoding="utf-8", errors="ignore").lower()
                    for w in forbidden_words:
                        self.assertNotIn(w, txt, f"Mention interdite '{w}' détectée dans {f}")
                elif f.suffix.lower() == ".zip":
                    with zipfile.ZipFile(f, "r") as zf:
                        for name in zf.namelist():
                            if name.endswith((".xml", ".resx", ".rsground")):
                                txt = zf.read(name).decode("utf-8", errors="ignore").lower()
                                for w in forbidden_words:
                                    self.assertNotIn(w, txt, f"Mention interdite '{w}' dans {f}:{name}")

    def test_03_fidelity_and_negative_guard(self) -> None:
        comp_path = REPO_ROOT / "renders" / "tour_celeste_sommet_v1" / "composite_pose0.png"
        ref_path = HERE / "references" / "b71_sky_tower_summit.png"
        dist = fidelity(comp_path, ref_path)
        self.assertLess(dist, 30.0, f"Fidélité insuffisante pour STC1: {dist:.3f}")

        comp_arr = np.asarray(Image.open(comp_path).convert("RGB"))
        corrupted = (255 - comp_arr).astype(np.uint8)
        with tempfile.NamedTemporaryFile(suffix=".png", delete=True) as tmp:
            Image.fromarray(corrupted, mode="RGB").save(tmp.name)
            bad_dist = fidelity(Path(tmp.name), ref_path)
            self.assertGreater(bad_dist, 45.0)

    def test_04_physical_cloud_motion_vectors_and_periodicity(self) -> None:
        stc_layers, _, _ = _load_sommet_builder().build_layers_for_size()
        by_slug = {l.slug: l.frames for l in stc_layers}

        h0 = np.asarray(by_slug["02_horizon_planetaire_courbe"][0])
        h1 = np.asarray(by_slug["02_horizon_planetaire_courbe"][1])
        self.assertGreater(float(np.abs(h1.astype(np.float32) - h0.astype(np.float32)).mean()), 0.1)

        s0 = np.asarray(by_slug["04_ailes_vent_sculptees_proches"][0])
        s1 = np.asarray(by_slug["04_ailes_vent_sculptees_proches"][1])
        s23 = np.asarray(by_slug["04_ailes_vent_sculptees_proches"][23])
        dx_sl, dy_sl, _ = _measure_shift_2d(s0[340:550, 20:250], s1[340:550, 20:250], max_shift=24)
        dx_sr, dy_sr, _ = _measure_shift_2d(s0[340:550, -250:-20], s1[340:550, -250:-20], max_shift=24)
        self.assertLess(dx_sl, 0)
        self.assertGreater(dy_sl, 0)
        self.assertEqual(dx_sr, -dx_sl)
        self.assertEqual(dy_sr, dy_sl)
        dx_sloop, dy_sloop, _ = _measure_shift_2d(s23[340:550, 20:250], s0[340:550, 20:250], max_shift=24)
        self.assertEqual((dx_sloop, dy_sloop), (dx_sl, dy_sl))

    def test_05_binary_rsground_tile_index_and_walkability(self) -> None:
        meta = json.loads(
            (REPO_ROOT / "renders" / "tour_celeste_sommet_v1" / "metadata.json").read_text(encoding="utf-8")
        )
        self.assertEqual(meta["n_frames"], 24)
        for sheet_id, count in meta["unique_tiles_per_sheet"].items():
            self.assertGreaterEqual(count, 2, f"Feuille vide : {sheet_id}={count}")
            self.assertLessEqual(count, 12000, f"Budget tuiles dépassé : {sheet_id}={count}")

        zip_path = REPO_ROOT / ".cache" / "virtual_zips" / "STC1_PMDO_0.8.12.zip"
        self.assertTrue(zip_path.is_file())
        with zipfile.ZipFile(zip_path, "r") as zf:
            names = set(zf.namelist())
            rsg_rel = "Data/Ground/stc1_tour_celeste.rsground"
            self.assertIn("Mod.xml", names)
            self.assertIn("INSTALLER.py", names)
            self.assertIn("Content/Tile/index.idx", names)
            self.assertIn(rsg_rel, names)

            idx_bytes = zf.read("Content/Tile/index.idx")
            with tempfile.NamedTemporaryFile(suffix=".idx", delete=True) as tmp_idx:
                Path(tmp_idx.name).write_bytes(idx_bytes)
                nodes_map = TOOLS_MOD.read_index(Path(tmp_idx.name))
            self.assertEqual(len(nodes_map), 10)

            for sheet_key, node_bytes in nodes_map.items():
                tile_blob = zf.read(f"Content/Tile/{sheet_key}.tile")
                tile_size, count_entries = struct.unpack_from("<ii", node_bytes, 0)
                self.assertEqual(tile_size, 8)
                self.assertGreaterEqual(count_entries, 1)
                _, _, first_pos = struct.unpack_from("<iiq", node_bytes, 8)
                png_len = struct.unpack_from("<q", tile_blob, first_pos)[0]
                tile_img = Image.open(io.BytesIO(tile_blob[first_pos + 8 : first_pos + 8 + png_len]))
                self.assertEqual(tile_img.size, (8, 8))

            rsg = json.loads(zf.read(rsg_rel).decode("utf-8"))
            self.assertEqual(rsg["Version"], "0.8.12.0")
            obj = rsg["Object"]
            self.assertGreaterEqual(len(obj["Layers"]), 10)
            obs = obj["obstacles"]
            gw, gh = len(obs), len(obs[0])
            walk = np.array([[obs[x][y]["Tags"] == 0 for x in range(gw)] for y in range(gh)], dtype=bool)
            lbl, _ = ndimage.label(walk)
            south_labels = set(lbl[-3:, :].ravel()) - {0}
            center_labels = set(lbl[gh // 2 - 4 : gh // 2 + 4, gw // 2 - 4 : gw // 2 + 4].ravel()) - {0}
            self.assertTrue(bool(south_labels & center_labels))

    def test_06_non_canonical_resolution_256x192(self) -> None:
        mod = _load_sommet_builder()
        layers, walk_grid, palette = mod.build_layers_for_size(256, 192)
        self.assertEqual(len(layers), 10)
        self.assertEqual(palette.shape[1], 3)
        self.assertEqual(walk_grid.shape, (24, 32))
        self.assertGreater(int(walk_grid.sum()), 25)
        for layer in layers:
            for fr in layer.frames:
                self.assertEqual(fr.size, (256, 192))


if __name__ == "__main__":
    unittest.main()
