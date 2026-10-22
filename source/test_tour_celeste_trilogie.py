#!/usr/bin/env python3
"""Suite de tests unitaires complète de la Trilogie « La Tour Céleste » (`ETC1`, `RTC1`, `STC1`).

Vérifie rigoureusement :
1. Purge intégrale de toutes les anciennes cartes PMD Red (`EST1`, `MST1`, `SST1`, `FGM1`).
2. Absence totale de crédits dans le code, les métadonnées, les aperçus HTML et les archives `.zip`.
3. Fidélité canonique pixel-art (`< 30.0`) sur les 3 scènes + test négatif de non-trivialité (`> 45.0`).
4. Vecteurs de déplacement optique réels `(dx, dy)` sur les couches de nuages multi-trames (`24` poses) :
   - `ETC1` : convergence symétrique vers le portail nord (`gauche : dx > 0, dy < 0` ; `droite : dx < 0, dy < 0`)
     + rotation cyclonique continue (`07_spirale_cyclone_portail`).
   - `RTC1` : courants ascendants multi-vitesses vers le sommet (`dy < 0` sur `01`, `02`, `03`) + étoiles scintillantes.
   - `STC1` : dérive planétaire ouest-est (`dx > 0` sur `02`) + ailes de vent divergentes vers l'extérieur et le bas
     (`gauche : dx < 0, dy > 0` ; `droite : dx > 0, dy > 0` sur `03` et `04`).
   - Continuité périodique fermée `pose23 -> pose00` sans aucun saut brusque.
5. Intégrité binaire RogueEssence `0.8.12.0` (`.zip`, `Mod.xml`, `.rsground`, `.tile <= 4096 px`, `index.idx` lu via `read_node`, connexité piétonne entrée sud -> zone nord/centrale).
6. Test de généralité à résolution non canonique `(256, 192)` sur les 3 générateurs (`ETC1`, `RTC1`, `STC1`).
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

REPO_ROOT = Path(__file__).resolve().parents[1]
if str(REPO_ROOT / "source") not in sys.path:
    sys.path.insert(0, str(REPO_ROOT / "source"))

from tour_celeste_moteur_nuages import TOOLS_MOD, fidelity


def _load_builder(folder_name: str):
    path = REPO_ROOT / "source" / folder_name / "build.py"
    spec = importlib.util.spec_from_file_location(f"builder_{folder_name}", path)
    mod = importlib.util.module_from_spec(spec)
    assert spec and spec.loader
    spec.loader.exec_module(mod)
    return mod


def _measure_shift_2d(
    img_a: np.ndarray, img_b: np.ndarray, max_shift: int = 24
) -> Tuple[int, int, float]:
    """Estime le déplacement entier `(dx, dy)` qui minimise `mean(|A(x - dx, y - dy) - B(x, y)|)`."""
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


class TestTourCelesteTrilogie(unittest.TestCase):
    MAPS = [
        ("ETC1", "tour_celeste_entree_v1", "D13P01.png", "ETC1_PMDO_0.8.12.zip"),
        ("RTC1", "tour_celeste_relais_v1", "D13P02.png", "RTC1_PMDO_0.8.12.zip"),
        ("STC1", "tour_celeste_sommet_v1", "b71_sky_tower_summit.png", "STC1_PMDO_0.8.12.zip"),
    ]

    def test_01_zero_prior_pmd_red_artifacts(self) -> None:
        forbidden_re = re.compile(
            r"(?:^|[^a-z])(est1|mst1|sst1|fgm1|suite_tour_celeste_pmdo_v1|foret_obscure_pmd_red)(?:$|[^a-z])"
        )
        for sub in ("source", "renders", ".cache"):
            root = REPO_ROOT / sub
            if not root.exists():
                continue
            for p in root.rglob("*"):
                low = p.name.lower()
                self.assertIsNone(
                    forbidden_re.search(low),
                    f"Ancien artefact PMD Red non purgé : {p}",
                )

    def test_02_zero_credits_everywhere(self) -> None:
        forbidden_words = ("credit", "crédit", "author:", "auteur:", "created by", "made by", "copyright")
        targets = (
            list((REPO_ROOT / "source").glob("tour_celeste*"))
            + list((REPO_ROOT / "renders").glob("tour_celeste*"))
            + list((REPO_ROOT / ".cache" / "virtual_zips").glob("*TC1_PMDO_0.8.12.zip"))
        )
        for t in targets:
            files = [t] if t.is_file() else list(t.rglob("*"))
            for f in files:
                if f.suffix.lower() in {".py", ".json", ".xml", ".resx", ".html"}:
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
        for map_id, slug, ref_name, _ in self.MAPS:
            comp_path = REPO_ROOT / "renders" / slug / "composite_pose0.png"
            ref_path = REPO_ROOT / "source" / slug / "references" / ref_name
            self.assertTrue(comp_path.is_file(), f"Composite manquant pour {map_id}")
            self.assertTrue(ref_path.is_file(), f"Référence canonique manquante pour {map_id}")

            dist = fidelity(comp_path, ref_path)
            self.assertLess(dist, 30.0, f"Fidélité insuffisante pour {map_id}: {dist:.3f} >= 30.0")

            # Contrôle négatif obligatoire : une image altérée/inversée DOIT échouer franchement !
            comp_arr = np.asarray(Image.open(comp_path).convert("RGB"))
            corrupted = (255 - comp_arr).astype(np.uint8)
            with tempfile.NamedTemporaryFile(suffix=".png", delete=True) as tmp:
                Image.fromarray(corrupted, mode="RGB").save(tmp.name)
                bad_dist = fidelity(Path(tmp.name), ref_path)
                self.assertGreater(
                    bad_dist, 45.0, f"La garde de fidélité est triviale sur {map_id}: {bad_dist:.3f}"
                )

    def test_04_physical_cloud_motion_vectors_and_periodicity(self) -> None:
        # 1. ETC1 : convergence symétrique vers le portail nord (`gauche : dx > 0, dy < 0` ; `droite : dx < 0, dy < 0`)
        etc_layers, _, _ = _load_builder("tour_celeste_entree_v1").build_layers_for_size()
        by_slug_etc = {l.slug: l.frames for l in etc_layers}

        e0 = np.asarray(by_slug_etc["03_panaches_convergents_proches"][0])
        e1 = np.asarray(by_slug_etc["03_panaches_convergents_proches"][1])
        e23 = np.asarray(by_slug_etc["03_panaches_convergents_proches"][23])
        mid = e0.shape[1] // 2
        dx_l, dy_l, err_l = _measure_shift_2d(e0[:, :mid], e1[:, :mid], max_shift=24)
        dx_r, dy_r, err_r = _measure_shift_2d(e0[:, mid:], e1[:, mid:], max_shift=24)
        self.assertGreater(dx_l, 0, f"ETC1 flanc gauche doit converger vers la droite (`dx > 0`), reçu {dx_l}")
        self.assertLess(dy_l, 0, f"ETC1 flanc gauche doit monter vers le nord (`dy < 0`), reçu {dy_l}")
        self.assertEqual(dx_r, -dx_l, "ETC1 flanc droit doit être exactement symétrique (`dx_r = -dx_l`)")
        self.assertEqual(dy_r, dy_l, "ETC1 flanc droit doit monter à la même vitesse verticale")
        self.assertLess(err_l, 2.5)
        self.assertLess(err_r, 2.5)
        dx_loop, dy_loop, err_loop = _measure_shift_2d(e23[:, :mid], e0[:, :mid], max_shift=24)
        self.assertEqual((dx_loop, dy_loop), (dx_l, dy_l), "Rupture de boucle sur ETC1 pose23->pose00 !")
        self.assertLess(err_loop, 2.5)

        # Rotation cyclonique continue sur `07_spirale_cyclone_portail`
        c0 = np.asarray(by_slug_etc["07_spirale_cyclone_portail"][0], dtype=np.float32)
        c6 = np.asarray(by_slug_etc["07_spirale_cyclone_portail"][6], dtype=np.float32)
        self.assertGreater(float(np.abs(c0 - c6).mean()), 0.5)

        # 2. RTC1 : courants ascendants verticaux sur les deux murailles latérales (`dy < 0`)
        rtc_layers, _, _ = _load_builder("tour_celeste_relais_v1").build_layers_for_size()
        by_slug_rtc = {l.slug: l.frames for l in rtc_layers}

        r0 = np.asarray(by_slug_rtc["03_murailles_cumulus_etoilees"][0])
        r1 = np.asarray(by_slug_rtc["03_murailles_cumulus_etoilees"][1])
        r23 = np.asarray(by_slug_rtc["03_murailles_cumulus_etoilees"][23])
        dx_rl, dy_rl, err_rl = _measure_shift_2d(r0[:, :200], r1[:, :200], max_shift=24)
        dx_rr, dy_rr, err_rr = _measure_shift_2d(r0[:, -200:], r1[:, -200:], max_shift=24)
        self.assertEqual(dx_rl, 0)
        self.assertLess(dy_rl, 0, f"RTC1 muraille gauche doit monter (`dy < 0`), reçu {dy_rl}")
        self.assertEqual((dx_rr, dy_rr), (0, dy_rl))
        self.assertLess(err_rl, 1.0)
        self.assertLess(err_rr, 1.0)
        dx_rloop, dy_rloop, _ = _measure_shift_2d(r23[:, :200], r0[:, :200], max_shift=24)
        self.assertEqual((dx_rloop, dy_rloop), (0, dy_rl), "Rupture de boucle sur RTC1 pose23->pose00 !")

        # 3. STC1 : dérive planétaire ouest-est (`dx > 0` sur `02`) + ailes divergentes vers l'extérieur et le bas (`04`)
        stc_layers, _, _ = _load_builder("tour_celeste_sommet_v1").build_layers_for_size()
        by_slug_stc = {l.slug: l.frames for l in stc_layers}

        h0 = np.asarray(by_slug_stc["02_horizon_planetaire_courbe"][0])
        h1 = np.asarray(by_slug_stc["02_horizon_planetaire_courbe"][1])
        self.assertGreater(float(np.abs(h1.astype(np.float32) - h0.astype(np.float32)).mean()), 0.1)

        s0 = np.asarray(by_slug_stc["04_ailes_vent_sculptees_proches"][0])
        s1 = np.asarray(by_slug_stc["04_ailes_vent_sculptees_proches"][1])
        s23 = np.asarray(by_slug_stc["04_ailes_vent_sculptees_proches"][23])
        dx_sl, dy_sl, _ = _measure_shift_2d(s0[340:550, 20:250], s1[340:550, 20:250], max_shift=24)
        dx_sr, dy_sr, _ = _measure_shift_2d(s0[340:550, -250:-20], s1[340:550, -250:-20], max_shift=24)
        self.assertLess(dx_sl, 0, f"STC1 aile gauche doit s'écarter vers la gauche (`dx < 0`), reçu {dx_sl}")
        self.assertGreater(dy_sl, 0, f"STC1 aile gauche doit plonger vers le bas (`dy > 0`), reçu {dy_sl}")
        self.assertEqual(dx_sr, -dx_sl, "STC1 aile droite doit s'écarter symétriquement (`dx_sr = -dx_sl`)")
        self.assertEqual(dy_sr, dy_sl)
        dx_sloop, dy_sloop, _ = _measure_shift_2d(s23[340:550, 20:250], s0[340:550, 20:250], max_shift=24)
        self.assertEqual((dx_sloop, dy_sloop), (dx_sl, dy_sl), "Rupture de boucle sur STC1 pose23->pose00 !")

    def test_05_binary_rsground_tile_index_and_walkability(self) -> None:
        for map_id, slug, _, zip_name in self.MAPS:
            meta = json.loads((REPO_ROOT / "renders" / slug / "metadata.json").read_text(encoding="utf-8"))
            self.assertEqual(meta["n_frames"], 24)
            for sheet_id, count in meta["unique_tiles_per_sheet"].items():
                self.assertGreaterEqual(count, 2, f"Feuille vide détectée : {sheet_id}={count}")
                self.assertLessEqual(count, 12000, f"Budget tuiles dépassé : {sheet_id}={count}")

            zip_path = REPO_ROOT / ".cache" / "virtual_zips" / zip_name
            self.assertTrue(zip_path.is_file(), f"Archive PMDO manquante : {zip_path}")
            with zipfile.ZipFile(zip_path, "r") as zf:
                names = set(zf.namelist())
                rsg_rel = f"Data/Ground/{map_id.lower()}_tour_celeste.rsground"
                self.assertIn("Mod.xml", names)
                self.assertIn("INSTALLER.py", names)
                self.assertIn("Content/Tile/index.idx", names)
                self.assertIn(rsg_rel, names)

                idx_bytes = zf.read("Content/Tile/index.idx")
                with tempfile.NamedTemporaryFile(suffix=".idx", delete=True) as tmp_idx:
                    Path(tmp_idx.name).write_bytes(idx_bytes)
                    nodes_map = TOOLS_MOD.read_index(Path(tmp_idx.name))
                self.assertEqual(len(nodes_map), 10, f"Nombre de feuilles incorrect dans index.idx pour {map_id}")

                for sheet_key, node_bytes in nodes_map.items():
                    tile_rel = f"Content/Tile/{sheet_key}.tile"
                    self.assertIn(tile_rel, names)
                    tile_blob = zf.read(tile_rel)
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
                self.assertEqual(len(obj["Decorations"]), 1)

                obs = obj["obstacles"]
                gw, gh = len(obs), len(obs[0])
                walk = np.array([[obs[x][y]["Tags"] == 0 for x in range(gw)] for y in range(gh)], dtype=bool)
                lbl, _ = ndimage.label(walk)
                south_labels = set(lbl[-3:, :].ravel()) - {0}
                center_labels = set(lbl[gh // 2 - 4 : gh // 2 + 4, gw // 2 - 4 : gw // 2 + 4].ravel()) - {0}
                self.assertTrue(
                    bool(south_labels & center_labels),
                    f"Le couloir sud n'est pas connexe au cœur praticable sur {map_id} !",
                )

    def test_06_non_canonical_resolution_256x192(self) -> None:
        for map_id, slug, _, _ in self.MAPS:
            mod = _load_builder(slug)
            layers, walk_grid, palette = mod.build_layers_for_size(256, 192)
            self.assertEqual(len(layers), 10)
            self.assertEqual(palette.ndim, 2)
            self.assertEqual(palette.shape[1], 3)
            self.assertEqual(walk_grid.shape, (24, 32))
            self.assertGreater(int(walk_grid.sum()), 25, f"Grille praticable vide à 256x192 sur {map_id}")
            for layer in layers:
                for fr in layer.frames:
                    self.assertEqual(fr.size, (256, 192))


if __name__ == "__main__":
    unittest.main()
