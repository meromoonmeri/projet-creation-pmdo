"""Tests de l'Opening ULTIME (Voyage 0-31 s + course lunaire 31-46 s + opening sprites 46-153 s)."""
import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
HTML = ROOT / "apercu_fangame_pmd_destiny_ultime.html"
ENGINE = ROOT / "source" / "opening_ultime_engine.js"
META = ROOT / "renders" / "pmd_destiny_fangame_v1" / "opening_ultime" / "metadata.json"


class TestOpeningUltime(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.html = HTML.read_text(encoding="utf-8")
        cls.eng = ENGINE.read_text(encoding="utf-8")
        i0 = cls.html.index("const ASSETS = ") + len("const ASSETS = ")
        i1 = cls.html.index(";\n</script>", i0)
        cls.assets = json.loads(cls.html[i0:i1])

    def test_autonome_sans_requete_externe(self):
        self.assertIsNone(re.search(r"""(src|href)=["']/renders""", self.html))
        self.assertIsNone(re.search(r"""["']/renders/""", self.html))
        self.assertTrue(all(v.startswith("data:") for v in self.assets["imgs"].values()))

    def test_duree_et_musique(self):
        self.assertIn("D = 153.0", self.eng)
        self.assertIn("TITLE_T = 148.0", self.eng)
        self.assertIn("2aafI3XvKxo", self.html)
        self.assertEqual(json.loads(META.read_text(encoding="utf-8"))["duration_seconds"], 153.0)

    def test_trois_moteurs_assembles(self):
        for g in ("PMDDestinyVoyage", "PMDDestinySprite", "PMDDestinyUltime"):
            self.assertIn("root." + g + " =", self.html)
        self.assertIn("PMDDestinyUltime.create", self.html)
        self.assertIn("const BT0 = 20.0, MT0 = 31.0, MT1 = 46.0", self.eng)
        self.assertIn("if (t < BT0) return V.render", self.eng)
        self.assertIn("if (t >= MT1)", self.eng)

    def test_passage_46_68_conserve(self):
        self.assertIn("id: 'OC', t0: 46, t1: 52.5", self.html)
        self.assertIn("id: '3d', t0: 62, t1: 68", self.html)
        self.assertIn("OC: 0,", self.html)

    def test_course_lunaire_trio_et_decor_lune(self):
        self.assertIsNotNone(re.search(r"const RUN = \[.*'0393'.*'0133'.*'0447'", self.eng, re.S))
        self.assertIn("'moonBg'", self.eng)
        self.assertIn("'moonFg'", self.eng)
        for k in ("moonBg", "moonFg", "plainsTree"):
            self.assertIn(k, self.assets["imgs"])

    def test_personnages_en_gros_plan(self):
        m = re.search(r"const MEMORIES = \[(.*?)\n    \];", self.eng, re.S)
        self.assertIsNotNone(m)
        pids = set(re.findall(r"\['(\d{4})', '", m.group(1)))
        self.assertGreaterEqual(len(pids), 12)
        scales = [float(x) for x in re.findall(r"\d+, \d+, (\d+(?:\.\d+)?), [01]\]", m.group(1))]
        self.assertGreaterEqual(min(scales), 5.0)
        cat = self.assets["catalog"]["pokemon"]
        for pid in pids:
            self.assertIn(pid, cat)
        self.assertNotIn("pt_", self.eng)  # aucun portrait fixe
        self.assertIsNone(re.search(r"bateau|ship", self.eng, re.I))

    def test_plage_pmd_sky_logo_etoile_et_un_seul_groupe(self):
        for k in ("beachSea", "beachBubbles", "beachSand", "pmdLogo", "skyCloud"):
            self.assertIn(k, self.assets["imgs"])  # textures canoniques fournies + logo « Pokémon Mystery Dungeon »
        self.assertIn("function fBeach(", self.eng)
        self.assertNotIn("beachSky", self.eng)
        self.assertEqual(len(re.findall(r"function flock\(", self.eng)), 1)  # un seul groupe
        self.assertEqual(self.eng.count("flock(ctx, t, seaTop"), 1)
        self.assertIn("'0278', 'Hover', 2", self.eng)  # vrais sprites Goélise
        self.assertIn("'0279', 'Walk', 2", self.eng)  # Bekipan de profil
        self.assertIn("function wfPos(", self.eng)  # l'étoile-badge tombe en dernier sur le logo
        self.assertIn("starPath(ctx, LX(), LY(), R, rot); ctx.clip();", self.eng)  # l'étoile ouvre la scène suivante
        self.assertIn("function tide(", self.eng)  # marée animée sur le sable
        self.assertIn("fx(ctx, 'bubble', 6 + ", self.eng)  # éclatement des bulles (sprite généré)
        self.assertIn("function logoDraw(", self.eng)  # logo généré : construction en vague + reflet
        self.assertIn("BUBBLES.forEach", self.eng)  # bulles animées (remontée, balancement, bouclage)
        self.assertIn("function skyFallDecor(", self.html)  # chute dans le ciel : décor généré multicalque
        self.assertIn("function handLinks(", self.html)  # le trio se tient par la main
        self.assertNotIn("mat: k < 1", self.eng)  # les personnages ne se dissolvent plus : ils sortent avec le mouvement de caméra

    def test_catalogue_et_images_resolus(self):
        cat = self.assets["catalog"]["pokemon"]
        for pid, anim in re.findall(r"\['(\d{4})', '(\w+)', \d", self.eng):
            self.assertIn(anim, cat[pid]["anims"], (pid, anim))
            self.assertIn(cat[pid]["anims"][anim]["file"], self.assets["sheets"])
        for k in ("rigCore", "rigLW", "rigRW", "enterUI", "daySeaAtlas", "nightSeaAtlas", "laprasSky", "opm2", "opm3", "opm4"):
            self.assertIn(k, self.assets["imgs"])


    def test_chute_meteorite_et_gestes(self):
        # grammaire de la cinématique « Crise de la Météorite » du dépôt PMD-RED-PMDO-PORT (flashs 2/8/15/60 images, tremblement, silence) + gestes réels
        for needle in ("function fSkyFall(", "function meteorDraw(", "S.SC.find((q) => q.id === '5a').custom = fSkyFall", "const PULSES = [", "SKSEQ", "function bang(", "'Hurt'", "'Wake'", "'Pull'", "'Swing'"):
            self.assertIn(needle, self.eng)
        self.assertIn("meteor", self.assets["imgs"])
        for needle in ("'LookUp', 0, { loop: false }], [134.6", "'Swing', 0, { loop: false }], [141.1", "id: 'tiplouf', pid: '0393', keys: [[142, 340, 190]"):
            self.assertIn(needle, self.html)


if __name__ == "__main__":
    unittest.main()
