#!/usr/bin/env python3
"""Tests unitaires et fonctionnels — Fin du Couloir violet — Sanctuaire V1 (FCV4, 4:3 vaste).

.venv/bin/python -m unittest source.fin_couloir_violet_sanctuaire_v1.test_build -v
"""
from __future__ import annotations

import hashlib
import importlib.util
import json
import re
import unittest
import zipfile
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / "renders" / "fin_couloir_violet_sanctuaire_v1"
S = R / ".cache" / "fin_couloir_violet_sanctuaire_v1" / "fin_couloir_violet_sanctuaire"
REF = HERE / "reference" / "S05P03A.png"
STATIC = ("sol", "ombres", "gravillons", "blocs", "rochers", "falaise", "vide", "stele")


def load(p: Path) -> np.ndarray:
    return np.array(Image.open(p).convert("RGBA"))


def loadmod(name: str, path: Path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


def expand(L: dict) -> list[np.ndarray]:
    if L["phases"] == 1:
        return [load(O / L["file"])]
    return [load(O / L["file"].replace("fNN", f"f{t:02d}")) for t in range(L["phases"])]


def alpha(a: np.ndarray) -> np.ndarray:
    return a[..., 3] == 255


def colors(frames: list[np.ndarray]) -> set[tuple[int, int, int]]:
    return {tuple(int(v) for v in c) for a in frames for c in np.unique(a[a[..., 3] > 0][:, :3], axis=0)}


def rip_colors() -> set[tuple[int, int, int]]:
    a = np.array(Image.open(REF).convert("RGB"))
    return {tuple(int(v) for v in c) for c in np.unique(a.reshape(-1, 3), axis=0)}


def lum(px: np.ndarray) -> np.ndarray:
    return px[..., :3].astype(float) @ [0.299, 0.587, 0.114]


class TestFinCouloirVioletSanctuaireV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.M = json.loads((O / "manifest.json").read_text(encoding="utf-8"))
        cls.W, cls.H = cls.M["size_px"]
        cls.NAMES = [Path(L["file"]).name.replace("_fNN", "") for L in cls.M["layers"]]
        cls.STACK = [expand(L) for L in cls.M["layers"]]
        cls.BY = {re.sub(r"^FCV4_\d\d_", "", Path(n).stem): fr for n, fr in zip(cls.NAMES, cls.STACK)}
        cls.ORDER = list(cls.BY)
        cls.MASK = {k: np.array(Image.open(O / f"masques/FCV4_masque_{k}.png")) > 0 for k in (*STATIC, "praticable")}
        cls.B = loadmod("fcv4_build", HERE / "build.py")

    def test_01_raw_hashes_and_reference(self) -> None:
        for r in self.M["raw_inputs"]:
            self.assertEqual(hashlib.sha256((R / r["file"]).read_bytes()).hexdigest(), r["sha256"])
        ref = self.M["reference_da"]
        self.assertEqual(hashlib.sha256(REF.read_bytes()).hexdigest(), ref["sha256"])
        self.assertFalse(self.M["art_approved"])
        self.assertFalse(self.M["pmdo"]["runtime_tested"])

    def test_02_sizes_names_alpha_no_magenta(self) -> None:
        self.assertEqual(len(self.NAMES), len(set(self.NAMES)))
        self.assertTrue(all(n.startswith("FCV4_") for n in self.NAMES))
        self.assertEqual((self.W, self.H, self.W % 8, self.H % 8), (768, 576, 0, 0))
        for name, frames in self.BY.items():
            for a in frames:
                self.assertEqual(a.shape[:2], (self.H, self.W))
                self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255}, name)
                v = a[a[..., 3] > 0].astype(int)
                bad = (v[:, 0] - v[:, 1] > 60) & (v[:, 2] - v[:, 1] > 60)
                self.assertEqual(int(bad.sum()), 0, name)

    def test_03_multicalque_full_coverage_and_order(self) -> None:
        self.assertEqual(self.ORDER, ["sol_complet", *STATIC, "lueurs_stele", "eboulis", "poussiere"])
        self.assertTrue(alpha(self.BY["sol_complet"][0]).all())
        fixed = [alpha(self.BY[k][0]) for k in STATIC]
        self.assertTrue((np.sum(fixed, 0) == 1).all())
        for k in STATIC:
            self.assertGreater(int(alpha(self.BY[k][0]).sum()), 500, k)
            self.assertTrue((alpha(self.BY[k][0]) == self.MASK[k]).all(), k)

    def test_04_palettes_et_matieres(self) -> None:
        for g, v in self.M["normalization"]["palettes"].items():
            self.assertLessEqual(len(colors([self.BY[k][0] for k in v["calques"]])), v["couleurs"], g)
        L = lambda k: self.BY[k][0][alpha(self.BY[k][0])][:, :3].astype(int)
        self.assertLess(float(np.median(lum(L("vide")))), 30)
        s = L("sol")
        self.assertGreater(float((s[:, 0] > s[:, 1] + 4).mean()), 0.8)
        for k in ("rochers", "blocs", "falaise", "stele"):
            p = L(k).mean(0)
            self.assertGreater(p[2], p[0] + 20, k)

    def test_05_fidelite_rip_sous_seuil_35(self) -> None:
        f = self.M["fidelite_rip"]
        for k in ("sol", "roche"):
            self.assertLess(f["brut"][k]["distance"], 20, k)
        for k in ("sol", "rochers", "blocs", "stele"):
            self.assertLess(f["calques_finaux"][k]["distance_rip"], 20, k)
        self.assertLess(f["sol_complet"], 20)

    def test_06_eboulis_exact_rip_colors_and_lueurs_stele(self) -> None:
        rc = rip_colors()
        self.assertTrue(colors(self.BY["eboulis"]).issubset(rc))
        self.assertTrue(colors(self.BY["lueurs_stele"]).issubset(rc))
        self.assertEqual(len(self.BY["eboulis"]), 24)
        self.assertEqual(len(self.BY["poussiere"]), 24)
        self.assertEqual(len(self.BY["lueurs_stele"]), 24)

    def test_07_markers_and_16x16_walkable_path(self) -> None:
        acc = self.M["access"]
        self.assertTrue(acc["path_found_16x16"])
        self.assertGreater(acc["walkable_cells"], 1500)
        self.assertLess(acc["goal_px"][1], acc["boss_px"][1])
        self.assertLess(acc["boss_px"][1], acc["entry_px"][1])

    def test_08_ora_and_pmdo_0812_bundle(self) -> None:
        ora_p = O / "FCV4_fin_couloir_violet_calques.ora"
        self.assertTrue(ora_p.is_file())
        with zipfile.ZipFile(ora_p) as z:
            self.assertEqual(z.read("mimetype"), b"image/openraster")
            self.assertIn("mergedimage.png", z.namelist())
        self.assertTrue((S / "Mod.xml").is_file())
        self.assertTrue((S / "Data/Ground/fcv4_fin_couloir_violet.rsground").is_file())
        self.assertEqual(len(list((S / "Content/Tile").glob("FCV4_*.tile"))), 12)


if __name__ == "__main__":
    unittest.main(verbosity=2)
