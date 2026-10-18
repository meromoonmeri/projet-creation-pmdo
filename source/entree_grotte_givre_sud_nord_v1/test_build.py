#!/usr/bin/env python3
"""Tests unitaires et fonctionnels — Entrée Grotte de Givre sud -> nord V1 (EGI1).

.venv/bin/python -m unittest source.entree_grotte_givre_sud_nord_v1.test_build -v
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

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / "renders" / "entree_grotte_givre_sud_nord_v1"
S = R / ".cache" / "entree_grotte_givre_sud_nord_v1" / "entree_grotte_givre"
REF = HERE / "reference" / "D53P11B.png"
STATIC = ("vide", "rochers", "crevasses", "arche", "sol")
PFX = "EGI1"
N_BANKS = len(STATIC) + 1  # sol_complet + STATIC (le calque Top vide n'a pas de banque)


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


class TestEntreeGrotteGivreSudNordV1(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.M = json.loads((O / "manifest.json").read_text(encoding="utf-8"))
        cls.W, cls.H = cls.M["size_px"]
        cls.NAMES = [Path(L["file"]).name.replace("_fNN", "") for L in cls.M["layers"]]
        cls.STACK = [expand(L) for L in cls.M["layers"]]
        cls.BY = {re.sub(rf"^{PFX}_\d\d_", "", Path(n).stem): fr for n, fr in zip(cls.NAMES, cls.STACK)}
        cls.ORDER = list(cls.BY)
        cls.MASK = {
            k: np.array(Image.open(O / f"masques/{PFX}_masque_{k}.png")) > 0
            for k in (*STATIC, "praticable")
        }
        cls.B = loadmod("egi1_build", HERE / "build.py")

    def test_01_raw_hashes_and_reference(self) -> None:
        for r in self.M["raw_inputs"]:
            self.assertEqual(hashlib.sha256((R / r["file"]).read_bytes()).hexdigest(), r["sha256"])
        ref = self.M["reference_da"]
        self.assertEqual(hashlib.sha256(REF.read_bytes()).hexdigest(), ref["sha256"])
        self.assertFalse(self.M["art_approved"])
        self.assertFalse(self.M["pmdo"]["runtime_tested"])

    def test_02_sizes_names_alpha_no_magenta(self) -> None:
        self.assertEqual(len(self.NAMES), len(set(self.NAMES)))
        self.assertTrue(all(n.startswith(f"{PFX}_") for n in self.NAMES))
        self.assertEqual((self.W, self.H, self.W % 8, self.H % 8), (768, 576, 0, 0))
        for name, frames in self.BY.items():
            for a in frames:
                self.assertEqual(a.shape[:2], (self.H, self.W))
                self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255}, name)
                v = a[a[..., 3] > 0].astype(int)
                if len(v):
                    bad = (v[:, 0] - v[:, 1] > 60) & (v[:, 2] - v[:, 1] > 60)
                    self.assertEqual(int(bad.sum()), 0, name)

    def test_03_multicalque_full_coverage_and_order(self) -> None:
        self.assertEqual(self.ORDER, ["sol_complet", *STATIC])
        self.assertTrue(alpha(self.BY["sol_complet"][0]).all())
        fixed = [alpha(self.BY[k][0]) for k in STATIC]
        self.assertTrue((np.sum(fixed, 0) == 1).all())
        for k in STATIC:
            self.assertGreater(int(alpha(self.BY[k][0]).sum()), 400, k)
            self.assertTrue((alpha(self.BY[k][0]) == self.MASK[k]).all(), k)

    def test_04_palettes_et_fidelite_rip_sous_seuil_35(self) -> None:
        for g, v in self.M["normalization"]["palettes"].items():
            self.assertLessEqual(len(colors([self.BY[k][0] for k in v["calques"]])), v["couleurs"], g)
        f = self.M["fidelite_rip"]
        for k, v in f["brut"].items():
            self.assertLess(v["distance"], 35, k)
        for k, v in f["calques_finaux"].items():
            self.assertLess(v["distance_rip"], 35, k)
        self.assertLess(f["sol_complet"], 35)

    def test_05_grotte_givre_arche_et_sol(self) -> None:
        A = self.BY
        # L'arche sombre est centrée horizontalement, dans le tiers supérieur.
        arc = A["arche"][0]
        m = arc[..., 3] > 0
        self.assertGreater(int(m.sum()), 300)
        ys, xs = np.nonzero(m)
        self.assertLess(ys.mean(), self.H * 0.4)
        self.assertLess(abs(xs.mean() - self.W / 2), 120)
        px = arc[m][:, :3].astype(float) @ [0.299, 0.587, 0.114]
        self.assertLess(px.mean(), 100)
        # Le sol de glace est bleu-clair (b > r).
        sol = A["sol"][0]
        pxs = sol[sol[..., 3] > 0][:, :3].astype(int)
        self.assertGreater(pxs[:, 2].mean(), pxs[:, 0].mean() + 30)
        # La plaine de glace couvre ~20 % de la carte carrée (le reste est roc et ciel).
        self.assertGreater(int(self.MASK["praticable"].sum()), 0.15 * self.W * self.H)

    def test_06_markers_and_16x16_walkable_path(self) -> None:
        acc = self.M["access"]
        self.assertTrue(acc["path_found_16x16"])
        # La plaine de glace fait ~1200 cellules praticables (roc des deux côtés).
        self.assertGreater(acc["walkable_cells"], 1100)
        self.assertLess(acc["goal_px"][1], acc["boss_px"][1])
        self.assertLess(acc["boss_px"][1], acc["entry_px"][1])

    def test_07_ora_and_pmdo_0812_bundle(self) -> None:
        ora_p = O / f"{PFX}_entree_grotte_givre_calques.ora"
        self.assertTrue(ora_p.is_file())
        with zipfile.ZipFile(ora_p) as z:
            self.assertEqual(z.read("mimetype"), b"image/openraster")
            self.assertIn("mergedimage.png", z.namelist())
        self.assertTrue((S / "Mod.xml").is_file())
        self.assertTrue((S / "Data/Ground/egi1_entree_grotte_givre.rsground").is_file())
        self.assertEqual(len(list((S / "Content/Tile").glob(f"{PFX}_*.tile"))), N_BANKS)


if __name__ == "__main__":
    unittest.main(verbosity=2)
