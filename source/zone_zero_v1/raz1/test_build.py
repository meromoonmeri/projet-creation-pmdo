"""Tests dédiés — Route Zone Zéro 1 (RAZ1), lèvre du cratère, 4:3.
.venv/bin/python -m unittest source.zone_zero_v1.raz1.test_build -v
Contrôles d'images, de formats, de cadence, de mouvement, de grille et d'accès : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, unittest, zipfile
import numpy as np
from scipy import ndimage
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[2]
O = R / 'renders/zone_zero_v1/RAZ1'
S = R / '.cache/zone_zero_v1/route_zone_zero_1'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
ANIM = ('abime', 'eau', 'cascades', 'ecume')
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
MASK = {k: np.array(Image.open(O / f'masques/RAZ1_masque_{k}.png')) > 0
        for k in ('void', 'casc', 'foam', 'water', 'floor', 'bush', 'walls', 'cascades_rect')}


def alpha(a):
    return a[..., 3] == 255


def colors(a):
    return {tuple(int(v) for v in c) for c in np.unique(a[alpha(a)][:, :3], axis=0)}


def land():
    m = np.zeros((H, W), bool)
    for n in ('sol', 'falaises', 'buissons'):
        m |= alpha(STACK[n][0])
    return m


class Build(unittest.TestCase):
    def test_bruts_reference_fidelite(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        self.assertEqual(M['raw_inputs'][0]['images'], ['source/zone_zero_v1/reference/P03P01A_decoupe_style_x2.png'])
        self.assertEqual(M['raw_inputs'][1]['images'], [M['raw_inputs'][0]['file']])        # édition à un seul changement
        e = M['raw_inputs'][1]['ecart_hors_zone']
        self.assertLess(e['somme_rvb_moyenne'], 20); self.assertLess(e['part_pixels_ecart_60'], 0.01)
        ref = M['reference_da']; self.assertEqual(ref['code'], 'P03P01A')
        self.assertEqual(hashlib.sha256((R / ref['fichier']).read_bytes()).hexdigest(), ref['sha256'])
        idx = json.loads((R / 'source/outil_maps_pmdsky/index_rom.json').read_text())
        e = next(x for x in idx['maps'] if x['code'] == 'P03P01A')                          # capture vérifiée au pixel près
        self.assertEqual(e['identification'][0]['statut'], 'verifie')
        f = M['fidelite']; self.assertEqual(f['seuil'], 35)
        for k in ('prairie', 'sol_complet', 'falaises'):
            self.assertLess(f[k]['distance'], 35, k)
        if 'pelouse' in f:
            self.assertLess(f['pelouse']['distance'], 35)
        self.assertLess(f['prairie']['distance'], 12)                                          # matière principale
        b = loadmod('raz1_build', HERE / 'build.py')
        dec = np.array(Image.open(HERE / 'bruts/decor_magenta.png').convert('RGB')).astype(int)
        sol = b.make_sol(dec); self.assertEqual(sol.shape, (896, 1200, 3))
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_calques_ordre_tailles_alpha(self):
        self.assertEqual(NAMES, ['abime', 'sol_complet', 'eau', 'sol', 'falaises', 'buissons', 'cascades', 'ecume'])
        files = [Path(p).name for p in ORDER]
        self.assertTrue(all(n.startswith('RAZ1_') for n in files)); self.assertEqual(len(files), len(set(files)))
        self.assertEqual((W, H, W * 3), (768, 576, H * 4))                                  # 4:3
        for frames in STACK.values():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W)); self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255})
                v = a[alpha(a)].astype(int)                                                  # plus de magenta
                self.assertEqual(int(((v[:, 0] > 200) & (v[:, 2] > 200) & (v[:, 1] < 90)).sum()), 0)

    def test_couverture(self):
        ab, sol = alpha(STACK['abime'][0]), alpha(STACK['sol_complet'][0])
        self.assertTrue((ab | sol).all()); self.assertFalse((ab & sol).any())
        self.assertTrue((ab == MASK['void']).all())
        self.assertGreater(MASK['void'][:40].mean(), 0.25)                                   # l'abîme s'ouvre au nord

    def test_cascades_loi_native(self):
        fr = STACK['cascades']; cols = M['cascades']['colonnes']; pal = {tuple(c) for c in C.CASC_PAL}
        self.assertEqual((PH['cascades'], TK['cascades'], M['cascades']['periode_px'], M['cascades']['pas_px']), (3, 10, 96, 32))
        self.assertEqual(len(cols), 6); self.assertEqual(sorted(c['x0'] < W / 2 for c in cols), [False] * 3 + [True] * 3)
        for a in fr:
            self.assertTrue(colors(a) <= pal)
        for c in cols:
            sl = (slice(0, c['y1']), slice(c['x0'], c['x1']))
            for t in range(3):
                a, b = fr[t][sl], fr[(t + 1) % 3][sl]
                self.assertTrue(alpha(a).all()); self.assertTrue(alpha(a[0]).all())            # part du bord haut
                self.assertTrue((a[:c['y1'] - 32, :, :3] == b[32:, :, :3]).all(), (c, t))     # descend de 32 px par image
                self.assertFalse((a == b).all())
            col = fr[0][:c['y1'], (c['x0'] + c['x1']) // 2, :3].astype(int)
            self.assertTrue((col[96:] == col[:-96]).all())                                    # période 96 px
            whites = (col.min(1) > 230).mean(); self.assertTrue(0.08 < whites < 0.4, whites)  # bande blanche
        again = C.cascade_frames(H, W, cols)
        self.assertTrue(all((again[t] == fr[t]).all() for t in range(3)))                     # loi du module

    def test_ecume(self):
        fr = STACK['ecume']; pal = {tuple(c) for c in C.FOAM_PAL}; wet = MASK['water'] | MASK['foam'] | MASK['cascades_rect']
        self.assertEqual((PH['ecume'], TK['ecume']), (3, 10))
        wet_d = ndimage.binary_dilation(wet, iterations=1)
        for a in fr:
            self.assertTrue(colors(a) <= pal); self.assertFalse((alpha(a) & ~wet_d).any())     # jamais sur la terre
            self.assertGreater(int((alpha(a) & MASK['foam']).sum()), 0.8 * MASK['foam'].sum())
        self.assertTrue(all((fr[t] != fr[(t + 1) % 3]).any() for t in range(3)))              # les bouillons changent
        for c in M['cascades']['colonnes']:                                                   # écume au pied de chaque cascade
            box = alpha(fr[0][c['y1'] - 6:c['y1'] + 14, c['x0']:c['x1']])
            self.assertGreater(box.mean(), 0.3, c)

    def test_eau_rides(self):
        fr = STACK['eau']; wet = alpha(fr[0])
        self.assertEqual((PH['eau'], TK['eau']), (3, 10))
        self.assertEqual(len(M['eau']['sources']), 6)
        for a in fr:
            self.assertTrue((alpha(a) == wet).all())
        diff = [(fr[t] != fr[(t + 1) % 3]).any(2) for t in range(3)]
        self.assertTrue(all(d.sum() > 200 for d in diff)); self.assertFalse(any((d & ~wet).any() for d in diff))
        rip = {tuple(c) for c in C.RIPPLE_PAL}
        self.assertTrue(all(any(c in rip for c in colors(a)) for a in fr))
        self.assertLess(max(d.sum() for d in diff) / min(d.sum() for d in diff), 1.6)         # raccord 2 -> 0 régulier

    def test_abime_brume_eclats(self):
        fr = STACK['abime']; v = MASK['void']
        self.assertEqual((PH['abime'], TK['abime']), (24, 10))
        tones = {tuple(c) for c in C.ABYSS_TONES} | {tuple(c) for c in C.GLINT_TINTS} | {(255, 255, 255)}
        for a in fr:
            self.assertTrue((alpha(a) == v).all()); self.assertTrue(colors(a) <= tones)
        ch = [float((fr[t][v] != fr[(t + 1) % 24][v]).any(1).mean()) for t in range(24)]
        self.assertGreater(min(ch), 0.05); self.assertLess(max(ch) / min(ch), 1.6)           # bouge à chaque phase, raccord fermé
        lum = [float(fr[t][v][:, :3].mean()) for t in range(24)]
        self.assertTrue(40 < np.mean(lum) < 150, np.mean(lum))                                # brume visible, pas un puits noir
        g = M['abime']['eclats']; self.assertGreaterEqual(len(g), 20)
        for e in g:
            x, y = e['xy']; lit = [tuple(fr[t][y, x, :3]) for t in range(24)]
            self.assertIn((255, 255, 255), lit)

    def test_ora_et_scene(self):
        with zipfile.ZipFile(O / 'RAZ1_route_zone_zero_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
        sc = Image.new('RGBA', (W, H))
        for n in NAMES:
            sc.alpha_composite(Image.fromarray(STACK[n][0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/RAZ1_scene_t000.png')).all())
        for k in ANIM:
            self.assertEqual(M['scene_loop_ticks'] % (PH[k] * TK[k]), 0, k)
        self.assertEqual(M['scene_loop_ticks'], 240)

    def test_acces_sud_nord(self):
        a = M['access']; mk = a['markers']
        self.assertTrue(all(p['ok'] for p in a['chemins_16x16'].values()))
        self.assertEqual(mk['entrance'][1], H - 16); self.assertEqual(mk['sortie'][1], 0)       # arrivée au sud, sortie au nord
        walk = alpha(STACK['sol'][0])
        self.assertFalse((walk & (MASK['void'] | MASK['water'] | MASK['cascades_rect'] | MASK['foam'])).any())
        self.assertFalse(walk[:, :8].any() or walk[:, -8:].any())                               # aucune sortie latérale
        top = np.nonzero(walk[0])[0]
        self.assertLess(top.max() - top.min(), 48); self.assertLess(abs(top.mean() - mk['sortie'][0] - 8), 24)   # corniche seule
        free = ~(~walk).reshape(H // 8, 8, W // 8, 8).mean((1, 3)).__gt__(0.25)
        self.assertEqual(int((~free).sum()), a['blocked_cells'])
        bx, by = mk['belvedere']
        d = ndimage.distance_transform_edt(~MASK['void'])
        self.assertLess(d[by:by + 16, bx:bx + 16].min(), 16)                                   # belvédère au bord de l'abîme

    def test_ground_aller_retour(self):
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text()); o = doc['Object']
        self.assertEqual(doc['Version'], '0.8.12.0'); self.assertEqual(len(o['Layers']), len(NAMES) + 1)
        self.assertEqual(o['Layers'][-1]['Layer'], 4)
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
        self.assertEqual([m['EntName'] for m in o['Entities'][0]['Markers']], ['entrance', 'sortie', 'belvedere'])
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))


if __name__ == '__main__':
    unittest.main()
