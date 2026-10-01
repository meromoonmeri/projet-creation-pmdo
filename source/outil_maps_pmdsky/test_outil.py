"""Tests de l'outil de récupération des maps PMD Sky (index versionné ; rendus si présents dans .cache).
.venv/bin/python -m unittest source.outil_maps_pmdsky.test_outil -v
"""
from pathlib import Path
import importlib.util, json, unittest

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
I = json.loads((HERE / 'index_rom.json').read_text())
M = {m['code']: m for m in I['maps']}
ROM = R / '.cache/maps_pmdsky/rom'


class Outil(unittest.TestCase):
    def test_source_epinglee(self):
        self.assertEqual(I['source']['commit'], 'c8073235b39746a7ee74e6cea16c730bd91a1e67')
        self.assertIn('bg_list.dat', I['source']['table'])

    def test_couverture(self):
        ok = [m for m in M.values() if not m.get('erreur')]
        self.assertGreaterEqual(len(ok), 468)
        for m in M.values():                                  # seules erreurs admises : fichiers absents du dépôt
            if m.get('erreur'):
                self.assertTrue(m['erreur'].startswith('absent du depot'), m)
        self.assertGreaterEqual(sum(1 for m in ok if m['frames'] > 1), 150)
        self.assertTrue(all(m['taille_px'][0] % 8 == 0 and m['taille_px'][1] % 8 == 0 for m in ok))

    def test_pas_de_nom_de_donjon_invente(self):
        self.assertFalse(any('donjon' in m for m in M.values()))   # dNN != DUNGEON_ID (vérifié par les captures)

    def test_identifications_connues(self):
        ids = {i['capture']: (c, i['statut']) for c, m in M.items() for i in m.get('identification', [])}
        for cap, code in {'Waterfall_Cave_ledge_TDS.png': 'D04P12A', 'Southern_Jungle_exit_S.png': 'D54P31A',
                          'lakecrystalpmdsky.png': 'D17P34A', 'Steam_Cave_Peak_TDS.png': 'D10P41A',
                          'aurorepmdsky.png': 'V38P05A'}.items():
            self.assertEqual(ids[cap], (code, 'verifie'), cap)
        self.assertEqual(ids['Waterfall_Cave_gem_TDS.png'], ('D04P31A', 'probable'))

    @unittest.skipUnless((ROM / 'png').exists(), 'rendus absents : lancer recuperer_maps.py rom')
    def test_rendus_au_pixel(self):
        from PIL import Image
        import numpy as np
        for cap, code in {'Southern_Jungle_exit_S.png': 'D54P31A', 'Mt_Horn_entrance_Sky.png': 'D07P11A'}.items():
            a = np.array(Image.open(R / cap).convert('RGB')); b = np.array(Image.open(ROM / 'png' / f'{code}.png').convert('RGB'))
            self.assertTrue((a == b).all(), cap)
        with Image.open(ROM / 'anim' / 'D17P11A.webp') as im:              # frames identiques successives fusionnées par WebP
            self.assertTrue(1 < im.n_frames <= M['D17P11A']['frames_gardees'])

if __name__ == '__main__':
    unittest.main()
