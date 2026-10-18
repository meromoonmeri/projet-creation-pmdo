#!/usr/bin/env python3
"""Tests unitaires et fonctionnels — Fin de la Tour Temporelle V2 (FTN2, Sommet Noir & Or Prismatique).

Vérifie :
1. Format 768x576, grille 8x8 (96x72), TexSize=1, boucle 240 ticks (24 phases x 10 ticks).
2. Continuité directe du chemin avec l'entrée ETT2 (chaussée sud en basalte noir, escalier sud,
   large esplanade octogonale ouverte sans piliers, escalier nord).
3. Veines d'or aux reflets arc-en-ciel (10_circuits_or + 11_reflets_arc_en_ciel) sur les parois
   rocheuses d'obsidienne noire et la chaussée sud.
4. Trou Noir cosmique et nuages rouges/noirs en animation spirale + palette cycling
   (01_trou_noir_spirale + trou_noir_spirale_indexee.png + palettes_spirale_24frames.json)
   directement derrière le cadran temporel (09_cadran_temporel).
5. Absence de frange magenta, fidélité < 35, connectivité praticable entrance -> boss -> objectif,
   archive .ora et bundle PMDO 0.8.12 (.rsground, 12 banques .tile, index.idx, aperçu HTML).
"""
from __future__ import annotations

import json
import unittest
import zipfile
from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]
LOT = "fin_tour_temporelle_noire_or_v2"
RENDERS = REPO / "renders" / LOT
LAYERS_DIR = RENDERS / "layers"
ANIM_DIR = RENDERS / "animation"
MASQUES_DIR = RENDERS / "masques"
REVIEW_DIR = RENDERS / "review"
BRUTS = HERE / "bruts"
ETT2_BRUTS = REPO / "source" / "entree_tour_temporelle_sud_nord_v2" / "bruts"
ETT2_MASQUES = REPO / "renders" / "entree_tour_temporelle_sud_nord_v2" / "masques"


class TestFinTourTemporelleNoireOrV2(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.meta = json.loads((RENDERS / "metadata.json").read_text(encoding="utf-8"))
        cls.manifest = json.loads((RENDERS / "manifest.json").read_text(encoding="utf-8"))

    def test_01_dimensions_and_grid(self) -> None:
        self.assertEqual(self.meta["id"], "FTN2")
        self.assertEqual(self.meta["Width"], 768)
        self.assertEqual(self.meta["Height"], 576)
        self.assertEqual(self.meta["TexSize"], 1)
        self.assertEqual(self.meta["TileSize"], 8)
        self.assertEqual(self.meta["GridWidth"], 96)
        self.assertEqual(self.meta["GridHeight"], 72)
        self.assertEqual(self.meta["LoopTicks"], 240)
        self.assertEqual(self.meta["ScenePhases"], 24)
        self.assertFalse(self.meta["art_approved"])
        self.assertFalse(self.meta["runtime_tested"])

    def test_02_bruts_exist_and_dimensions(self) -> None:
        for name in (
            "decor_magenta.png",
            "trou_noir_magenta.png",
            "nebuleuse_spatiale.png",
            "sol_complet.png",
            "nuages_magenta.png",
        ):
            p = BRUTS / name
            self.assertTrue(p.is_file(), f"Brut manquant : {p}")
            with Image.open(p) as im:
                self.assertEqual(im.size, (1200, 896), f"Dimensions brutes invalides pour {name}")

    def test_03_same_path_as_entrance_ett2(self) -> None:
        """Vérifie que le chemin sud et l'esplanade du boss correspondent au tracé d'ETT2 sans piliers."""
        chaussee = np.array(Image.open(LAYERS_DIR / "05_chaussee_noire.png").convert("RGBA"))
        parvis = np.array(Image.open(LAYERS_DIR / "06_parvis_dalles.png").convert("RGBA"))
        m_chaussee = chaussee[..., 3] > 0
        m_parvis = parvis[..., 3] > 0

        self.assertGreater(int(m_chaussee.sum()), 12000, "Chaussée noire sud trop réduite")
        self.assertGreater(int(m_parvis.sum()), 42000, "Esplanade octogonale trop réduite")

        # Vérifier l'absence de trous/piliers au cœur de l'esplanade octogonale du boss (y=265..365, x=280..488)
        arena_core = m_parvis[265:365, 280:488]
        self.assertGreater(float(arena_core.mean()), 0.96, "Des piliers ou obstacles trouent l'esplanade du boss")

        # Comparer avec le brut d'ETT2 sur le chemin (chaussée + parvis)
        if (ETT2_BRUTS / "decor_magenta.png").is_file():
            a_ftn2 = np.array(Image.open(BRUTS / "decor_magenta.png").convert("RGB")).astype(float)
            a_ett2 = np.array(Image.open(ETT2_BRUTS / "decor_magenta.png").convert("RGB")).astype(float)
            # Zone centrale du chemin sud et de l'esplanade en 1200x896
            diff_road = np.abs(a_ftn2[400:880, 520:680] - a_ett2[400:880, 520:680]).mean()
            self.assertLess(float(diff_road), 12.0, f"Écart trop grand avec le chemin d'ETT2 : {diff_road:.2f}")

    def test_04_golden_veins_with_rainbow_reflections(self) -> None:
        """Vérifie que les veines d'or (11_circuits_or) ont des reflets arc-en-ciel (12_reflets_arc_en_ciel)."""
        circuits_sheet = np.array(Image.open(LAYERS_DIR / "11_circuits_or.png").convert("RGBA"))
        reflets_sheet = np.array(Image.open(LAYERS_DIR / "12_reflets_arc_en_ciel.png").convert("RGBA"))
        self.assertEqual(circuits_sheet.shape, (576 * 16, 768, 4))
        self.assertEqual(reflets_sheet.shape, (576 * 24, 768, 4))

        c0 = circuits_sheet[:576]
        r0 = reflets_sheet[:576]
        r6 = reflets_sheet[6 * 576 : 7 * 576]
        r12 = reflets_sheet[12 * 576 : 13 * 576]

        # Veines dans les parois rocheuses et la chaussée (y >= 220)
        rock_veins_mask = np.zeros((576, 768), dtype=bool)
        rock_veins_mask[220:, :] = c0[220:, :, 3] > 0
        self.assertGreater(int(rock_veins_mask.sum()), 9000, "Pas assez de veines d'or dans les rochers")

        # Vérifier que la couche de reflets arc-en-ciel illumine effectivement les veines d'or rocheuses
        shimmer_on_veins = rock_veins_mask & (r0[..., 3] > 0)
        self.assertGreater(
            int(shimmer_on_veins.sum()),
            4500,
            "Les reflets arc-en-ciel ne couvrent pas suffisamment les veines d'or des rochers",
        )

        # Vérifier la diversité chromatique (arc-en-ciel) sur les veines rocheuses
        vein_colors = r0[shimmer_on_veins, :3].astype(int)
        has_cyan_blue = ((vein_colors[:, 2] > vein_colors[:, 0] + 24) & (vein_colors[:, 1] > 140)).any()
        has_emerald = ((vein_colors[:, 1] > vein_colors[:, 0] + 24) & (vein_colors[:, 1] > 160)).any()
        has_rose_violet = ((vein_colors[:, 0] > 160) & (vein_colors[:, 2] > 160)).any()
        has_warm_gold = ((vein_colors[:, 0] > 200) & (vein_colors[:, 1] > 150) & (vein_colors[:, 2] < 130)).any()
        self.assertTrue(has_cyan_blue, "Reflet cyan/azur manquant sur les veines d'or")
        self.assertTrue(has_emerald, "Reflet émeraude manquant sur les veines d'or")
        self.assertTrue(has_rose_violet, "Reflet rose/améthyste manquant sur les veines d'or")
        self.assertTrue(has_warm_gold, "Dominante d'or solaire manquante sur les veines")

        # Vérifier que les reflets arc-en-ciel se déplacent le long des veines au fil des phases
        diff_0_6 = np.abs(r0[rock_veins_mask, :3].astype(float) - r6[rock_veins_mask, :3].astype(float)).mean()
        diff_6_12 = np.abs(r6[rock_veins_mask, :3].astype(float) - r12[rock_veins_mask, :3].astype(float)).mean()
        self.assertGreater(float(diff_0_6), 12.0, "L'animation des reflets arc-en-ciel sur les veines est figée")
        self.assertGreater(float(diff_6_12), 12.0, "L'animation des reflets arc-en-ciel ne progresse pas")

    def test_05_black_hole_and_spiral_red_clouds_behind_dial(self) -> None:
        """Vérifie que les nuages rouges (01) et le Trou Noir spiralé (02) forment 2 couches animées indépendantes."""
        clouds_sheet = np.array(Image.open(LAYERS_DIR / "01_nuages_orage_rouges.png").convert("RGBA"))
        bh_sheet = np.array(Image.open(LAYERS_DIR / "02_trou_noir_spirale.png").convert("RGBA"))
        self.assertEqual(clouds_sheet.shape, (576 * 10, 768, 4), "01_nuages_orage_rouges doit compter 10 frames de 768x576")
        self.assertEqual(bh_sheet.shape, (576 * 10, 768, 4), "02_trou_noir_spirale doit compter 10 frames de 768x576")

        # 1. Vérifier les 10 frames de 01_nuages_orage_rouges (plein cadre opaque, zéro interstice, parallaxe)
        for f in range(10):
            p_c = ANIM_DIR / "nuages_orage_rouges" / f"FTN2_00_nuages_orage_rouges_f{f:02d}.png"
            self.assertTrue(p_c.is_file(), f"Frame nuages manquante : {p_c}")
            arr_c = np.array(Image.open(p_c).convert("RGBA"))
            self.assertEqual(arr_c.shape, (576, 768, 4))
            self.assertTrue((arr_c[..., 3] == 255).all(), f"Interstice détecté dans {p_c.name}")
            self.assertTrue(((arr_c[..., :3] % 8) == 0).all(), f"Couleurs non quantifiées NDS 5 bits dans {p_c.name}")

        # 2. Vérifier les 10 frames de 02_trou_noir_spirale (couche RGBA indépendante avec alpha=0 hors du vortex)
        yy, xx = np.mgrid[:576, :768]
        r_bh = np.hypot(xx - 384.0, yy - 134.0)
        for f in range(10):
            p_f = ANIM_DIR / "trou_noir_spirale" / f"FTN2_01_trou_noir_spirale_f{f:02d}.png"
            self.assertTrue(p_f.is_file(), f"Frame Trou Noir manquante : {p_f}")
            arr_f = np.array(Image.open(p_f).convert("RGBA"))
            self.assertEqual(arr_f.shape, (576, 768, 4))
            self.assertTrue(((arr_f[..., :3] % 8) == 0).all(), f"Couleurs non quantifiées NDS 5 bits dans {p_f.name}")
            # Cœur du Trou Noir 100% opaque, extérieur lointain (y >= 360) 100% transparent
            self.assertTrue((arr_f[r_bh < 85.0, 3] == 255).all(), "Le cœur du Trou Noir doit être opaque sur la couche 02")
            self.assertTrue((arr_f[360:, :, 3] == 0).all(), "La couche 02 du Trou Noir doit être transparente hors du vortex")
            # Vérifier la présence de trouées transparentes entre les bras spiraux externes (r_bh entre 152 et 192)
            outer_corona = (r_bh >= 152.0) & (r_bh <= 192.0)
            frac_alpha = float((arr_f[outer_corona, 3] > 0).mean())
            self.assertGreater(frac_alpha, 0.25, "Bras spiraux externes trop réduits sur la couche 02")
            self.assertLess(frac_alpha, 0.88, "Pas de transparence entre les bras spiraux externes de la couche 02")

        # Vérifier les WebP et planches de contrôle des couches indépendantes
        self.assertTrue((RENDERS / "FTN2_nuages_orage_rouges_10frames.webp").is_file())
        self.assertTrue((RENDERS / "FTN2_trou_noir_seul_10frames.webp").is_file())
        self.assertTrue((RENDERS / "FTN2_trou_noir_spirale_10frames.webp").is_file())
        self.assertTrue((REVIEW_DIR / "FTN2_planche_10_frames_trou_noir.png").is_file())
        self.assertTrue((REVIEW_DIR / "FTN2_planche_couches_fond_independantes.png").is_file())

        # Vérifier la carte indexée et les 10 palettes du cycle spiralé
        idx_map_path = ANIM_DIR / "trou_noir_spirale_indexee.png"
        pal_json_path = ANIM_DIR / "palettes_spirale_10frames.json"
        self.assertTrue(idx_map_path.is_file(), "Carte indexée trou_noir_spirale_indexee.png manquante")
        self.assertTrue(pal_json_path.is_file(), "Fichier palettes_spirale_10frames.json manquant")

        idx_map = np.array(Image.open(idx_map_path))
        self.assertEqual(idx_map.shape, (576, 768))
        self.assertLessEqual(int(idx_map.max()), 15)
        self.assertEqual(int(len(np.unique(idx_map))), 16)

        pal_data = json.loads(pal_json_path.read_text(encoding="utf-8"))
        self.assertEqual(pal_data["n_frames"], 10)
        self.assertIn(pal_data["frame_length_ticks"], (12, 24))
        self.assertEqual(pal_data["independent_layers"], ["01_nuages_orage_rouges", "02_trou_noir_spirale"])

        # Vérifier dans la scène finale (frame_00) que le disque noir et l'anneau d'accrétion du Trou Noir
        # sont visibles de part et d'autre de l'arche gothique derrière le cadran (cx=384, cy=134)
        scene0 = np.array(Image.open(REVIEW_DIR / "FTN2_scene_t000.png").convert("RGB")).astype(float)

        visible_void = (np.abs(xx - 384) > 64) & (r_bh < 74.0) & (yy >= 95) & (yy <= 175)
        self.assertGreater(int(visible_void.sum()), 800)
        void_lum = scene0[visible_void] @ [0.299, 0.587, 0.114]
        self.assertLess(float(void_lum.mean()), 18.0, "L'horizon noir du Trou Noir n'est pas visible derrière le cadran")

        visible_ring = (np.abs(xx - 384) > 64) & (r_bh >= 74.0) & (r_bh <= 98.0) & (yy >= 75) & (yy <= 185)
        self.assertGreater(int(visible_ring.sum()), 900)
        ring_red = scene0[visible_ring, 0].mean()
        ring_green = scene0[visible_ring, 1].mean()
        self.assertGreater(float(ring_red), 155.0, "Anneau d'accrétion trop sombre derrière le cadran")
        self.assertGreater(float(ring_green), 40.0, "Anneau d'accrétion sans éclat doré/ambré")

        # Vérifier que CHACUNE des deux couches (01_nuages_orage_rouges [nébuleuse spatiale] ET 02_trou_noir_spirale) évolue indépendamment
        bh_active = r_bh <= 194.0
        for f in range(10):
            c_cur = clouds_sheet[f * 576 : (f + 1) * 576, :, :3].astype(float)
            c_nxt = clouds_sheet[((f + 1) % 10) * 576 : (((f + 1) % 10) + 1) * 576, :, :3].astype(float)
            self.assertGreater(float(np.abs(c_cur - c_nxt).mean()), 4.0, f"Nébuleuse spatiale figée entre frame {f} et {(f+1)%10}")

            b_cur = bh_sheet[f * 576 : (f + 1) * 576, :, :3][bh_active].astype(float)
            b_nxt = bh_sheet[((f + 1) % 10) * 576 : (((f + 1) % 10) + 1) * 576, :, :3][bh_active].astype(float)
            self.assertGreater(float(np.abs(b_cur - b_nxt).mean()), 8.0, f"Trou Noir figé entre frame {f} et {(f+1)%10}")

    def test_06_no_magenta_fringe(self) -> None:
        scene0 = np.array(Image.open(REVIEW_DIR / "FTN2_scene_t000.png").convert("RGB")).astype(int)
        r, g, b = scene0[..., 0], scene0[..., 1], scene0[..., 2]
        mag = (r > 200) & (b > 200) & (g < 80)
        self.assertEqual(int(mag.sum()), 0, "Pixels magenta résiduels détectés dans la scène")

    def test_07_disjoint_static_masks_and_top_vide(self) -> None:
        static_names = [
            "05_chaussee_noire.png",
            "06_parvis_dalles.png",
            "07_parois_rocheuses.png",
            "08_muraille_gothique.png",
            "09_reliquaire_cristal.png",
        ]
        acc = np.zeros((576, 768), dtype=int)
        for nm in static_names:
            a = np.array(Image.open(LAYERS_DIR / nm).convert("RGBA"))
            acc += (a[..., 3] > 0).astype(int)
        self.assertLessEqual(int(acc.max()), 1, "Chevauchement détecté entre couches statiques")

        top = np.array(Image.open(LAYERS_DIR / "14_top_vide.png").convert("RGBA"))
        self.assertEqual(int((top[..., 3] > 0).sum()), 0, "14_top_vide doit être 100% transparent")

    def test_08_fidelity_under_35(self) -> None:
        for k, val in self.meta["Fidelity"].items():
            self.assertLess(float(val), 35.0, f"Écart de fidélité >= 35 pour {k}: {val}")

    def test_09_markers_and_connected_walkability(self) -> None:
        blocked = np.array(self.meta["BlockedGrid"], dtype=bool)
        self.assertEqual(blocked.shape, (72, 96))
        markers = self.meta["Markers"]
        for name in ("entrance", "boss", "objectif"):
            self.assertIn(name, markers)
            gx, gy = markers[name]["gx"], markers[name]["gy"]
            self.assertFalse(bool(blocked[gy, gx]), f"Marqueur {name} placé sur une cellule bloquée")

        _, n_comp = nd.label(~blocked)
        self.assertEqual(int(n_comp), 1, "La zone praticable doit former une unique composante connexe")

    def test_10_ora_and_pmdo_0812_bundle(self) -> None:
        for ora_name in ("ftn2_fin_tour_temporelle_noire_or.ora", "FTN2_fin_tour_temporelle_noire_or_v2_calques.ora"):
            ora_p = RENDERS / ora_name
            self.assertTrue(ora_p.is_file(), f"Archive ORA manquante : {ora_p}")
            with zipfile.ZipFile(ora_p) as zf:
                self.assertEqual(zf.read("mimetype"), b"image/openraster")
                self.assertIn("mergedimage.png", zf.namelist())
                self.assertIn("stack.xml", zf.namelist())

        zip_p = RENDERS / "FTN2_projet_pmdo_0812.zip"
        self.assertTrue(zip_p.is_file(), "Archive ZIP PMDO 0.8.12 manquante")
        with zipfile.ZipFile(zip_p) as zf:
            names = set(zf.namelist())
            self.assertIn(f"{LOT}/Mod.xml", names)
            self.assertIn(f"{LOT}/Data/Ground/ftn2_fin_tour_temporelle_noire_or.rsground", names)
            self.assertIn(f"{LOT}/Content/Tile/index.idx", names)
            self.assertEqual(sum(n.endswith(".tile") for n in names), 13)

        html_p = REPO / f"apercu_{LOT}.html"
        self.assertTrue(html_p.is_file(), "Aperçu HTML racine manquant")
        self.assertTrue((RENDERS / "viewer.html").is_file(), "Viewer HTML local manquant")


def main() -> None:
    suite = unittest.defaultTestLoader.loadTestsFromTestCase(TestFinTourTemporelleNoireOrV2)
    res = unittest.TextTestRunner(verbosity=2).run(suite)
    if not res.wasSuccessful():
        raise SystemExit(1)


if __name__ == "__main__":
    main()
