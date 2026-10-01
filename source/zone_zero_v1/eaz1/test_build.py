"""Tests dédiés — Entrée Zone Zéro 1 (EAZ1), grotte de cristal, 4:3.
.venv/bin/python -m unittest source.zone_zero_v1.eaz1.test_build -v
Contrôles d'images, de formats, de cadence, de mouvement, de grille et d'accès : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, unittest, zipfile
import numpy as np
from scipy import ndimage
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[2]
O = R / 'renders/zone_zero_v1/EAZ1'
S = R / '.cache/zone_zero_v1/entree_zone_zero'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
ANIM = ('cristaux', 'portail', 'lucioles', 'scintillements')
PH = {k: M[k]['phases'] for k in ANIM}
TK = {k: M[k]['frame_length_ticks'] for k in ANIM}


def load(p):
    return np.array(Image.open(p).convert('RGBA'))


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


def name_of(p):
    return Path(p).stem.split('_', 2)[2].replace('_fNN', '')


def expand(p):
    if 'fNN' in p:
        return [load(O / p.replace('fNN', f'f{t:02d}')) for t in range(PH[name_of(p)])]
    return [load(O / p)]


ORDER = M['layer_order_bottom_to_top']
NAMES = [name_of(p) for p in ORDER]
STACK = {n: expand(p) for n, p in zip(NAMES, ORDER)}
C = loadmod('zone_zero_commun', HERE.parent / 'commun.py')
B = loadmod('eaz1_build', HERE / 'build.py')
MASK = {k: np.array(Image.open(O / f'masques/EAZ1_masque_{k}.png')) > 0 for k in ('floor', 'dalles', 'walls', 'crystal', 'geode', 'tunnel')}


def alpha(a):
    return a[..., 3] == 255


def colors(a):
    return {tuple(int(v) for v in c) for c in np.unique(a[alpha(a)][:, :3], axis=0)}


class Build(unittest.TestCase):
    def test_bruts_editions_fidelite(self):
        raws = M['raw_inputs']
        for r in raws:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        self.assertEqual([r['utilise'] for r in raws], [False, False, True])                 # seul le dernier est utilisé
        self.assertEqual(raws[0]['images'], ['source/zone_zero_v1/reference/D17P11A_decoupe_style_x2.png'])
        self.assertEqual(raws[2]['images'][0], raws[1]['file'])                               # édition de l'édition 1
        self.assertGreater(raws[2]['edition']['correlation_contours_avec_v0'], 0.85)          # même layout
        ref = M['references_da']['D17P11A']
        self.assertEqual(hashlib.sha256((R / ref['fichier']).read_bytes()).hexdigest(), ref['sha256'])
        idx = json.loads((R / 'source/outil_maps_pmdsky/index_rom.json').read_text())
        e = next(x for x in idx['maps'] if x['code'] == 'D17P11A')
        self.assertEqual(e['taille_px'], [600, 480])                                          # rendu ROM direct de l'outil
        self.assertTrue(e['animation_palette'])
        f = M['fidelite']; self.assertEqual(f['seuil'], 35)
        self.assertEqual(sorted(f['seuille']), ['cristaux', 'parois', 'sol', 'sol_complet'])
        for k in f['seuille']:
            self.assertLess(f[k]['distance'], 35, k)
        self.assertLess(f['sol']['distance'], 15)                                             # matière principale
        sc = np.array(Image.open(O / 'review/EAZ1_scene_t000.png').convert('RGB')).astype(int)   # recalcul
        ref_a = np.array(Image.open(R / ref['fichier']).convert('RGB')).astype(int)
        mr, mx = B.materials(ref_a), B.materials(sc)
        self.assertAlmostEqual(float(np.linalg.norm(ref_a[mr['sol']].mean(0) - sc[mx['sol']].mean(0))), f['sol']['distance'], places=1)
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_calques_ordre_tailles_alpha(self):
        self.assertEqual(NAMES, ['sol_complet', 'sol', 'parois', 'cristaux', 'geode', 'portail', 'lucioles', 'scintillements'])
        files = [Path(p).name for p in ORDER]
        self.assertTrue(all(n.startswith('EAZ1_') for n in files)); self.assertEqual(len(files), len(set(files)))
        self.assertEqual((W, H, W * 3), (768, 576, H * 4))
        for frames in STACK.values():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W)); self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255})
        self.assertTrue(alpha(STACK['sol_complet'][0]).all())
        cover = np.zeros((H, W), bool)
        for n in ('sol', 'parois', 'cristaux', 'geode', 'portail'):
            a = alpha(STACK[n][0]); self.assertFalse((cover & a).any(), n); cover |= a
        self.assertTrue(cover.all())                                                         # classes disjointes, carte couverte

    def test_loi_palette_d17p11a(self):
        self.assertEqual(M['cristaux']['sequence_niveaux'], [0, 0, 0, 1, 2, 2, 3, 3, 4, 4, 4, 3, 3, 2, 2, 1, 1, 1])
        self.assertEqual((PH['cristaux'], TK['cristaux']), (18, 10))
        for n in ('cristaux', 'portail'):
            fr = STACK[n]; m = alpha(fr[0]); base = fr[0][m][:, :3].astype(int)
            for t, k in enumerate(M['cristaux']['sequence_niveaux']):
                self.assertTrue((alpha(fr[t]) == m).all())
                exp = base if k == 0 else np.minimum(base + 8 * k, 231)
                self.assertTrue((fr[t][m][:, :3] == exp).all(), (n, t))                      # + 8 par niveau, plafond 231
        self.assertTrue((STACK['cristaux'][8] != STACK['cristaux'][0]).any())
        self.assertTrue((STACK['cristaux'][17] != STACK['cristaux'][0]).any())               # raccord 17 -> 0 : niveau 1 -> 0
        # loi simplifiée : ROM (79, 151, 167) -> (111, 183, 191) au niveau 4 ; la loi retenue ajoute 8 partout -> (111, 183, 199)
        self.assertEqual(tuple(B.glow(np.array([[79, 151, 167]]), 4)[0]), (111, 183, 199))
        self.assertEqual(tuple(B.glow(np.array([[231, 231, 239]]), 1)[0]), (231, 231, 231))

    def test_lucioles_scintillements(self):
        fr = STACK['lucioles']; self.assertEqual((PH['lucioles'], TK['lucioles']), (18, 10))
        tints = {tuple(c) for c in C.GLINT_TINTS}; dim = {tuple(int(v * 0.75) for v in c) for c in C.GLINT_TINTS}
        for a in fr:
            self.assertTrue(colors(a) <= tints | dim); self.assertGreater(alpha(a).sum(), 20)
        self.assertTrue(all((fr[t] != fr[(t + 1) % 18]).any() for t in range(18)))
        again, _ = B.mote_frames([tuple(map(tuple, s)) for s in M['lucioles']['sources']])
        self.assertTrue(all((x == y).all() for x, y in zip(again, fr)))
        sf = STACK['scintillements']; stars = M['scintillements']['etoiles']; ge = alpha(STACK['geode'][0])
        self.assertEqual((PH['scintillements'], TK['scintillements']), (12, 5)); self.assertGreaterEqual(len(stars), 25)
        for s in stars:
            x, y = s['xy']; self.assertTrue(ge[y, x])
            self.assertEqual(sum(bool(alpha(sf[t])[y, x]) for t in range(12)), 6)

    def test_ora_et_scene(self):
        with zipfile.ZipFile(O / 'EAZ1_entree_zone_zero_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
        sc = Image.new('RGBA', (W, H))
        for n in NAMES:
            sc.alpha_composite(Image.fromarray(STACK[n][0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/EAZ1_scene_t000.png')).all())
        for k in ANIM:
            self.assertEqual(M['scene_loop_ticks'] % (PH[k] * TK[k]), 0, k)
        self.assertEqual(M['scene_loop_ticks'], 180)

    def test_acces_sud_donjon(self):
        a = M['access']; mk = a['markers']
        self.assertTrue(all(p['ok'] for p in a['chemins_16x16'].values()))
        self.assertEqual(mk['entrance'][1], H - 16)
        walk = alpha(STACK['sol'][0])
        self.assertFalse((walk & (MASK['geode'] | MASK['tunnel'] | MASK['walls'])).any())
        self.assertFalse(walk[:, :16].any() or walk[:, -16:].any() or walk[:16].any())           # ni sortie latérale, ni bord haut
        self.assertFalse(walk[H - 8:, :W // 2 - 100].any() or walk[H - 8:, W // 2 + 60:].any())  # une seule brèche au sud
        ty, tx = np.nonzero(MASK['tunnel']); self.assertGreater(len(ty), 1500)
        self.assertGreater(tx.mean(), W / 2); self.assertLess(ty.mean(), H / 2)                   # géode au nord-est
        dx, dy = mk['donjon']
        self.assertLess(abs(dx + 8 - tx.mean()), 40); self.assertLess(abs(dy - ty.max()), 24)     # devant le tunnel
        self.assertTrue(MASK['dalles'].sum() > 5000)                                              # pas japonais praticables
        blocked = (~walk).reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > 0.25
        self.assertEqual(int(blocked.sum()), a['blocked_cells'])
        reach = B.reach_map(blocked, (mk['entrance'][1] // 8, mk['entrance'][0] // 8))
        self.assertTrue(reach[dy // 8, dx // 8])
        cut = walk.copy(); cut[mk['donjon'][1] + 24:mk['donjon'][1] + 40, :] = False             # couper le chemin : donjon perdu
        blocked2 = (~cut).reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > 0.25
        self.assertFalse(B.reach_map(blocked2, (mk['entrance'][1] // 8, mk['entrance'][0] // 8))[dy // 8, dx // 8])

    def test_ground_aller_retour(self):
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text()); o = doc['Object']
        self.assertEqual(doc['Version'], '0.8.12.0'); self.assertEqual(len(o['Layers']), len(NAMES) + 1)
        nr = loadmod('native_reader', R / 'source/cote_v5_expeditions/audit_references.py')
        banks = {p.stem: nr.tiles(p)[1] for p in (S / 'Content/Tile').glob('*.tile')}
        self.assertEqual(set(banks), set(M['pmdo']['banks']))
        for li, n in enumerate(NAMES):
            frames = STACK[n]; ticks = TK.get(n, 60)
            for t in sorted({0, len(frames) // 2, len(frames) - 1}):
                out = np.zeros((H, W, 4), 'uint8')
                for x, col in enumerate(o['Layers'][li]['Tiles']):
                    for y, cell in enumerate(col):
                        for track in cell['Layers']:
                            if len(track['Frames']) > 1:
                                self.assertEqual((len(track['Frames']), track['FrameLength']), (len(frames), ticks))
                            f = track['Frames'][t % len(track['Frames'])]
                            out[y*8:y*8+8, x*8:x*8+8] = np.array(nr.straight(banks[f['Sheet']][f['TexLoc']['X'], f['TexLoc']['Y']]))
                self.assertTrue((out == frames[t]).all(), (n, t))
        self.assertEqual(sum(w['Tags'] for c in o['obstacles'] for w in c), M['access']['blocked_cells'])
        self.assertEqual([m['EntName'] for m in o['Entities'][0]['Markers']], ['entrance', 'donjon', 'cercle'])
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))


if __name__ == '__main__':
    unittest.main()
