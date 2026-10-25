"""Tests du combat refait : arène peinte animée, Méga-Évolution de Lucario, explosion, ressources PMD Rouge (météore, soleil, rayons)."""
import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SPR = (ROOT / "source" / "opening_sprite_engine.js").read_text(encoding="utf-8")
ULT = (ROOT / "source" / "opening_ultime_engine.js").read_text(encoding="utf-8")
BR = ROOT / "source" / "pmd_destiny_fangame_v1" / "combat_bruts"


def assets(name):
    h = (ROOT / name).read_text(encoding="utf-8")
    i0 = h.index("const ASSETS = ") + len("const ASSETS = ")
    return h, json.loads(h[i0:h.index(";\n</script>", i0)])


class TestCombat(unittest.TestCase):
    def test_pages_ultime_et_sprite_ont_le_nouveau_combat(self):
        for page in ("apercu_fangame_pmd_destiny_ultime.html", "apercu_fangame_pmd_destiny.html"):
            h, A = assets(page)
            for k in ("arVortex", "arDais", "arRocks", "arMist", "fx_rrmet", "fx_sunfl", "rrRays", "sunRing", "sunOrb"):
                self.assertIn(k, A["imgs"], page + " : " + k)
            self.assertTrue(all(v.startswith("data:") for v in A["imgs"].values()))
            for k in ("rrmet", "sunfl"):
                self.assertIn(k, A["catalog"]["vfx"])
            self.assertIn("9448", A["catalog"]["pokemon"])
            for an in ("Idle", "Charge", "Attack", "RearUp"):
                self.assertIn(an, A["catalog"]["pokemon"]["9448"]["anims"])
                self.assertIn(A["catalog"]["pokemon"]["9448"]["anims"][an]["file"], A["sheets"])
            self.assertIn("function megaColumn(", h)
            for k in ("megaColumn", "megaSymbol", "megaShatter"):  # Méga-Évolution sans pierres : colonne, emblème en flammes, explosion qui fracture la réalité
                self.assertIn(k, A["imgs"], page + " : " + k)
                self.assertTrue(A["imgs"][k].startswith("data:image/webp;base64,"))
            for an in ("Tumble", "EventSleep", "DeepBreath", "Nod", "Wake", "LookUp"):  # gestes d'Évoli de la fin
                self.assertIn(an, A["catalog"]["pokemon"]["0133"]["anims"], page + " : Évoli " + an)
            for an in ("Pull", "Pose", "Hop", "Nod"):
                self.assertIn(an, A["catalog"]["pokemon"]["0447"]["anims"], page + " : Riolu " + an)
            for an in ("Hop", "Pose", "LookUp", "Nod"):
                self.assertIn(an, A["catalog"]["pokemon"]["0393"]["anims"], page + " : Tiplouf " + an)
            for k in ("skyStrato", "skyDeck", "cloudPortal"):
                self.assertIn(k, A["imgs"], page + " : " + k)
            for sid in ("shadow_0133", "shadow_0393", "shadow_0302"):
                self.assertIn(sid, A["catalog"]["pokemon"], page + " : " + sid)
                self.assertIn("Idle", A["catalog"]["pokemon"][sid]["anims"])
            self.assertLess(len(h), 9_500_000)

    def test_scenes_combat(self):
        for needle in ("id: '4a'", "id: '4b'", "id: '4c'", "id: '4d'", "pid: '9448'", "pid: '0491'", "function arenaBack(", "function rocks(", "function mistLayer(", "function skyBolts(",
                       "function riftDraw(", "function megaColumn(", "function silMorph(", "function silField(", "function rainbowBolt(", "function megaFlames(", "function realityCracks(", "function tendril(", "function pool(", "TEXP = 103.3", "I.megaShatter"):
            self.assertIn(needle, SPR)
        for banned in ("function stoneDraw(", "function megaSphere(", "function rainbowThread(", "KS0", "Pierre de Key"):  # plus de pierres dans la Méga-Évolution
            self.assertNotIn(banned, SPR)
        for needle in ("rainbowBolt(ctx, boltShape(", "megaFlames(ctx, t, LUX", "silMorph(ctx, LUX", "megaColumn(ctx, t, LUX"):
            self.assertIn(needle, SPR)
        # trio final : Riolu, Évoli et Tiplouf réunis avant le titre (plan SP) ; réveil d'Évoli par les vraies animations
        sp = SPR[SPR.index("id: 'SP'"):SPR.index("id: 'SP'") + 1400]
        for pid in ("'0447'", "'0133'", "'0393'"):
            self.assertIn("pid: " + pid, sp)
        for needle in ("'EventSleep'", "'Wake'", "'DeepBreath'", "id: 'tiplouf', pid: '0393', keys: [[142, 340, 190]"):
            self.assertIn(needle, SPR)
        self.assertNotIn("'Sink', 0, { loop: false }], [134.6", SPR)
        for banned in ("crystalsAndRune", "AR.crystals", "AR.rune"):  # la plateforme est nue : ni cristaux ni cercle magique
            self.assertNotIn(banned, SPR)
        self.assertIn("shadow_0302", SPR)  # Ténéfix (Sableye) d'ombre
        self.assertIn("shadow_0133", SPR)  # Évoli possédé
        self.assertIn("103.3", SPR.split("const IMPACTS = [")[1].split("]")[0])

    def test_decor_anime(self):
        # nuages en spirale (rotation elliptique), roches en orbite hors du dais, éclairs partout, brume qui se resserre vers le cercle
        self.assertIn("ctx.rotate(t * 0.14)", SPR)
        self.assertIn("R.ph + t * R.w", SPR)
        self.assertGreater(SPR.count("skyBolts(ctx"), 1)
        self.assertIn("rf = 1.3 - 1.15 * u", SPR)

    def test_ressources_rrt(self):
        for f in ("fx_rrmet.png", "fx_sunfl.png", "sunRing.png", "sunOrb.png", "rrRays.png", "arDais.png", "arVortex.jpg", "arRocks.png", "arMist.png", "arena_meta.json"):
            self.assertTrue((BR / f).is_file(), f)
        meta = json.loads((BR / "arena_meta.json").read_text())
        self.assertGreaterEqual(len(meta["rocks"]), 4)
        self.assertEqual(meta.get("crystals", []), [])
        for f in ("rrt_meteor.png", "rrt_sunny.png", "rrt_rayons.png"):
            self.assertTrue((ROOT / "source" / "pmd_destiny_fangame_v1" / "ressources_rrt" / f).is_file())

    def test_meteore_soleil_rayons(self):
        self.assertIn("fx(ctx, 'rrmet'", ULT)  # météorite du ciel = animation du météore de PMD Rouge
        self.assertNotIn("I.meteor", ULT)
        self.assertIn("rrRays", SPR)
        self.assertIn("rrRays", ULT)
        self.assertIn("fx(ctx, 'sunfl'", SPR)  # soleil de PMD Rouge (reflets) dans les plans de lumière finaux


if __name__ == "__main__":
    unittest.main()
