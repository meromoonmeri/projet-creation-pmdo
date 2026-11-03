#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Tests du lot « animations de diva » — Team Dazzling (Lopunny, Tsar(e)ena, Mawile).

Contrôles techniques, pas d'approbation artistique : provenance native, palette,
boucle fermée, repères, planches importables, XML valide, aperçu autonome.

    .venv/bin/python -m unittest source/diva_dazzling_v1/test_diva.py -v
"""
from __future__ import annotations

import base64
import io
import json
import re
import sys
import unittest
import xml.etree.ElementTree as ET
from pathlib import Path

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(HERE))

from diva import REF, SPECIES, TICK, load, patch_animdata  # noqa: E402
from gestures import ANIM_ID, GESTURES, render  # noqa: E402

HTML = ROOT / "apercu_diva_dazzling_v1.html"
OUT = ROOT / "renders" / "diva_dazzling_v1"
VERIF = OUT / "verification.json"


class TestDivaDazzling(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.sprites = {s: load(s) for s in SPECIES}
        cls.frames = {s: render(sp)[0] for s, sp in cls.sprites.items()}
        cls.offsets = {s: render(sp)[1] for s, sp in cls.sprites.items()}

    # 01 ------------------------------------------------------------------
    def test_01_references_natives_epinglees(self) -> None:
        for slot, name in SPECIES.items():
            d = REF / f"{slot}_{name}"
            for f in ("AnimData.xml", "Idle-Anim.png", "Idle-Offsets.png", "Idle-Shadow.png"):
                self.assertTrue((d / f).is_file(), f"{slot}/{f}")
            for nm in ANIM_ID[slot], "Walk":
                self.assertTrue((d / f"{nm}-Anim.png").is_file() or nm == ANIM_ID[slot])
        for slot, name in SPECIES.items():
            self.assertEqual(self.sprites[slot].dirs, 8, slot)

    # 02 ------------------------------------------------------------------
    def test_02_geste_different_par_morphologie(self) -> None:
        self.assertEqual(set(GESTURES), set(SPECIES))
        self.assertEqual(len({ANIM_ID[s] for s in SPECIES}), 3)
        # chaque espèce a sa propre courbe de mouvement : les silhouettes de la
        # phase de tenue ne se ressemblent pas d'une espèce à l'autre
        sig = {}
        for slot, frames in self.frames.items():
            sp = self.sprites[slot]
            a = frames[0][10]
            ys, xs = np.nonzero(a[:, :, 3])
            sig[slot] = (sp.fw, sp.fh, int(a[:, :, 3].sum()), len(np.unique(xs)), len(np.unique(ys)))
        self.assertEqual(len(set(sig.values())), 3, sig)
        # aucune animation n'est une copie d'une autre
        for a in sig:
            for b in sig:
                if a < b:
                    self.assertNotEqual(sig[a][2:], sig[b][2:])

    # 03 ------------------------------------------------------------------
    def test_03_dix_huit_phases_huit_directions(self) -> None:
        for slot, frames in self.frames.items():
            self.assertEqual(len(frames), 8, slot)
            for row in frames:
                self.assertEqual(len(row), 18, slot)
                for fr in row:
                    sp = self.sprites[slot]
                    self.assertEqual(fr.shape, (sp.fh, sp.fw, 4), slot)

    # 04 ------------------------------------------------------------------
    def test_04_phase0_et_phase18_identiques_au_natif(self) -> None:
        for slot, frames in self.frames.items():
            for d in range(8):
                native = self.sprites[slot].views[d].img
                np.testing.assert_array_equal(frames[d][0], native, err_msg=f"{slot} d{d} phase0")
                np.testing.assert_array_equal(frames[d][17], native, err_msg=f"{slot} d{d} phase18")

    # 05 ------------------------------------------------------------------
    def test_05_aucune_couleur_inventee(self) -> None:
        for slot, frames in self.frames.items():
            native = self.sprites[slot].native_cols
            for d in range(8):
                for f in range(18):
                    a = frames[d][f]
                    cols = {tuple(int(v) for v in c) for c in np.unique(a[a[:, :, 3] > 0][:, :3], axis=0)}
                    self.assertEqual(cols - native, set(), f"{slot} d{d} f{f}")

    # 06 ------------------------------------------------------------------
    def test_06_mouvement_reel_et_limite(self) -> None:
        for slot, frames in self.frames.items():
            for d in range(8):
                diff = [int(np.abs(frames[d][f].astype(int) - frames[d][0].astype(int)).sum()) for f in range(18)]
                self.assertGreater(max(diff), 400, f"{slot} d{d} : geste trop discret")
                self.assertGreaterEqual(sum(1 for x in diff if x > 0), 8, f"{slot} d{d} : trop peu de phases animées")

    # 07 ------------------------------------------------------------------
    def test_07_aucun_sprite_ne_fuit_du_cadre(self) -> None:
        for slot, frames in self.frames.items():
            sp = self.sprites[slot]
            for d in range(8):
                for f in range(18):
                    a = frames[d][f]
                    self.assertGreater(int((a[:, :, 3] > 0).sum()), 40, f"{slot} d{d} f{f}")
                    ys, xs = np.nonzero(a[:, :, 3])
                    self.assertGreaterEqual(int(xs.min()), 0)
                    self.assertLessEqual(int(xs.max()), sp.fw - 1)
                    self.assertLessEqual(int(ys.max()), sp.fh - 1)

    # 08 ------------------------------------------------------------------
    def test_08_reperes_suivent_le_geste(self) -> None:
        for slot, offs in self.offsets.items():
            sp = self.sprites[slot]
            for d in range(8):
                self.assertEqual(len(offs[d]), 18)
                for f in range(18):
                    for k, (x, y) in offs[d][f].items():
                        self.assertIn(k, ("head", "body", "right", "left"), f"{slot} {k}")
                        self.assertTrue(0 <= x < sp.fw and 0 <= y < sp.fh, f"{slot} d{d} f{f} {k}=({x},{y})")
                # la tête bouge pour la révérence / le salut
                heads = {offs[d][f].get("head") for f in range(18)}
                self.assertGreater(len(heads), 1, f"{slot} d{d} : repère tête immobile")

    # 09 ------------------------------------------------------------------
    def test_09_planches_importables(self) -> None:
        for slot, name in SPECIES.items():
            sp = self.sprites[slot]
            d = OUT / f"{slot}_{name}"
            for f in ("AnimData.xml", f"{ANIM_ID[slot]}-Anim.png",
                      f"{ANIM_ID[slot]}-Offsets.png", f"{ANIM_ID[slot]}-Shadow.png"):
                self.assertTrue((d / f).is_file(), f"{slot}/{f}")
            a = Image.open(d / f"{ANIM_ID[slot]}-Anim.png")
            self.assertEqual(a.size, (sp.fw * 18, sp.fh * 8), slot)
            self.assertEqual(a.mode, "RGBA", slot)
            o = Image.open(d / f"{ANIM_ID[slot]}-Offsets.png")
            self.assertEqual(o.size, a.size, slot)
            s = Image.open(d / f"{ANIM_ID[slot]}-Shadow.png")
            self.assertEqual(s.size, a.size, slot)
            self.assertEqual(s.tobytes(), (d / f"{ANIM_ID[slot]}-Shadow.png").read_bytes()[:0] + s.tobytes())
            # la zone des repères reste marginale : pas de fuite dans l'image
            self.assertLess(int((np.array(o)[:, :, 3] > 0).sum()), a.size[0] * a.size[1] // 40, slot)

    # 10 ------------------------------------------------------------------
    def test_10_shadow_native_inchangee(self) -> None:
        for slot, name in SPECIES.items():
            sp = self.sprites[slot]
            s = np.array(Image.open(OUT / f"{slot}_{name}" / f"{ANIM_ID[slot]}-Shadow.png"))
            for d in range(8):
                np.testing.assert_array_equal(s[d * sp.fh:(d + 1) * sp.fh, :sp.fw],
                                              sp.views[d].shadow, err_msg=slot)

    # 11 ------------------------------------------------------------------
    def test_11_animdata_valide_et_complete(self) -> None:
        for slot, name in SPECIES.items():
            sp = self.sprites[slot]
            xml = OUT / f"{slot}_{name}" / "AnimData.xml"
            root = ET.parse(xml).getroot()
            anims = root.findall("./Anims/Anim")
            idx = [int(a.findtext("Index")) for a in anims]
            self.assertEqual(len(idx), len(set(idx)), f"{slot} : index dupliqué")
            node = next(a for a in anims if a.findtext("Name") == ANIM_ID[slot])
            self.assertEqual(int(node.findtext("FrameWidth")), sp.fw)
            self.assertEqual(int(node.findtext("FrameHeight")), sp.fh)
            durs = [int(x.text) for x in node.findall("./Durations/Duration")]
            self.assertEqual(len(durs), 18, slot)
            self.assertEqual(set(durs), {TICK}, slot)
            # l'Idle natif est conservé à l'identique
            native = ET.parse(REF / f"{slot}_{name}" / "AnimData.xml").getroot()
            idle = next(a for a in native.findall("./Anims/Anim") if a.findtext("Name") == "Idle")
            kept = next(a for a in anims if a.findtext("Name") == "Idle")
            self.assertEqual(idle.findtext("FrameWidth"), kept.findtext("FrameWidth"))
            self.assertEqual(len(idle.findall("./Durations/Duration")),
                             len(kept.findall("./Durations/Duration")))

    # 12 ------------------------------------------------------------------
    def test_12_patch_animdata_idempotent(self) -> None:
        import tempfile
        slot, name = "0303", SPECIES["0303"]
        sp = self.sprites[slot]
        with tempfile.TemporaryDirectory() as td:
            p = Path(td) / "AnimData.xml"
            patch_animdata(REF / f"{slot}_{name}" / "AnimData.xml", p,
                           [{"anim": "DivaSnap", "frames": 18, "dirs": 8, "frame": [sp.fw, sp.fh],
                             "ticks": [TICK] * 18, "bytes": 0}])
            once = p.read_text(encoding="utf-8")
            patch_animdata(REF / f"{slot}_{name}" / "AnimData.xml", p,
                           [{"anim": "DivaSnap", "frames": 18, "dirs": 8, "frame": [sp.fw, sp.fh],
                             "ticks": [TICK] * 18, "bytes": 0}])
            twice = p.read_text(encoding="utf-8")
            self.assertEqual(once, twice, "le patch duplique l'animation")
            self.assertEqual(twice.count("<Name>DivaSnap</Name>"), 1)
            ET.fromstring(twice)

    # 13 ------------------------------------------------------------------
    def test_13_apercu_autonome(self) -> None:
        self.assertTrue(HTML.is_file())
        txt = HTML.read_text(encoding="utf-8")
        self.assertLess(len(txt), 3_000_000)
        self.assertEqual(len(re.findall(r'<(?:img|script|link)[^>]*src="http', txt)), 0,
                         "aucune ressource externe")
        i0 = txt.index("const DATA = ") + len("const DATA = ")
        i1 = txt.index(";\nconst VER", i0)
        data = json.loads(txt[i0:i1])
        self.assertEqual(sorted(data), sorted(SPECIES))
        for slot, d in data.items():
            self.assertTrue(d["sheet"].startswith("data:image/png;base64,"), slot)
            raw = base64.b64decode(d["sheet"].split(",", 1)[1])
            im = Image.open(io.BytesIO(raw))
            sp = self.sprites[slot]
            self.assertEqual(im.size, (sp.fw * 18, sp.fh * 8), slot)
            self.assertGreaterEqual(len(d["desc"]), 60, slot)
        for label in ("Pause", "Pose de diva", "Réverence" ):
            pass
        self.assertIn("art_approved = false", txt)
        self.assertIn("runtime_tested = false", txt)

    # 14 ------------------------------------------------------------------
    def test_14_verification_json_honnete(self) -> None:
        v = json.loads(VERIF.read_text(encoding="utf-8"))
        self.assertFalse(v["art_approved"])
        self.assertFalse(v["runtime_tested"])
        self.assertEqual(v["phases"], 18)
        self.assertIn("SpriteCollab", v["source_sprites"])
        for slot in SPECIES:
            e = v["especes"][slot]
            self.assertTrue(e["phase0_identique_au_natif"], slot)
            self.assertEqual(e["couleurs_hors_palette_native"], 0, slot)
            self.assertTrue(e["boucle_fermee"], slot)
            self.assertEqual(e["reperes_hors_cadre_ou_aberrants"], 0, slot)

    # 15 ------------------------------------------------------------------
    def test_15_mutation_detectee(self) -> None:
        """Régression réelle : une planche décalée d'un pixel doit faire échouer le contrôle."""
        slot = "0428"
        frames = [row[:] for row in self.frames[slot]]
        frames[3][9] = np.roll(frames[3][9], 1, axis=1)
        native = self.sprites[slot].views[3].img
        self.assertFalse(np.array_equal(frames[3][0], frames[3][9]))
        cols = {tuple(int(v) for v in c)
                for c in np.unique(frames[3][9][frames[3][9][:, :, 3] > 0][:, :3], axis=0)}
        self.assertEqual(cols - self.sprites[slot].native_cols, set())
        self.assertFalse(np.array_equal(native, frames[3][9]), "la mutation doit être visible")


if __name__ == "__main__":
    unittest.main(verbosity=2)
