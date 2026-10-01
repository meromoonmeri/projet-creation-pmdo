"""Tests dédiés — Route Zone Zéro 3 (RAZ3), fond cristallin, 4:3.
.venv/bin/python -m unittest source.zone_zero_v1.raz3.test_build -v
Contrôles d'images, de formats, de cadence, de mouvement, de grille et d'accès : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, unittest, zipfile
import numpy as np
from scipy import ndimage
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[2]
O = R / 'renders/zone_zero_v1/RAZ3'
S = R / '.cache/zone_zero_v1/route_zone_zero_3'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
ANIM = ('eau', 'rides', 'cascades', 'ecume', 'scintillements')
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
MASK = {k: np.array(Image.open(O / f'masques/RAZ3_masque_{k}.png')) > 0
        for k in ('lake', 'casc', 'foam', 'floor', 'tunnel', 'crystal', 'walls', 'cascades_rect', 'eau')}


def alpha(a):
    return a[..., 3] == 255


def colors(a):
    return {tuple(int(v) for v in c) for c in np.unique(a[alpha(a)][:, :3], axis=0)}


def o_blocked(walk):
    return (~walk).reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > 0.25


class Build(unittest.TestCase):
    def test_bruts_references_fidelite(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        self.assertEqual(M['raw_inputs'][0]['images'], ['source/zone_zero_v1/reference/D17P34A_decoupe_style_x2.png',
                                                        'source/zone_zero_v1/reference/P03P01A_decoupe_style_x2.png'])   # deux références composées
        for code, ref in M['references_da'].items():
            self.assertEqual(hashlib.sha256((R / ref['fichier']).read_bytes()).hexdigest(), ref['sha256'])
        idx = json.loads((R / 'source/outil_maps_pmdsky/index_rom.json').read_text())
        for code in ('D17P34A', 'P03P01A'):
            e = next(x for x in idx['maps'] if x['code'] == code)
            self.assertEqual(e['identification'][0]['statut'], 'verifie', code)                 # captures vérifiées au pixel près
        f = M['fidelite']; self.assertEqual(f['seuil'], 35)
        self.assertEqual(sorted(f['seuille']), ['cristaux', 'sol', 'sol_complet'])
        for k in f['seuille']:
            self.assertLess(f[k]['distance'], 35, k)
        self.assertLess(f['sol']['distance'], 15)                                              # matière principale
        self.assertIn('non seuillee', f['parois']['note'])
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_calques_ordre_tailles_alpha(self):
        self.assertEqual(NAMES, ['eau', 'rides', 'sol_complet', 'sol', 'parois', 'cristaux', 'cascades', 'ecume', 'scintillements'])
        files = [Path(p).name for p in ORDER]
        self.assertTrue(all(n.startswith('RAZ3_') for n in files)); self.assertEqual(len(files), len(set(files)))
        self.assertEqual((W, H, W * 3), (768, 576, H * 4))
        for n, frames in STACK.items():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W)); self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255})
                if n == 'scintillements':
                    continue                                                                  # teinte téra rose voulue
                v = a[alpha(a)].astype(int)                                                  # plus de magenta ni de rose
                self.assertEqual(int(((v[:, 0] > 180) & (v[:, 2] > 180) & (v[:, 1] < np.minimum(v[:, 0], v[:, 2]) - 40)).sum()), 0)

    def test_couverture(self):
        eau, sol = alpha(STACK['eau'][0]), alpha(STACK['sol_complet'][0])
        self.assertTrue((eau | sol).all()); self.assertFalse((eau & sol).any())
        self.assertTrue((eau == MASK['eau']).all())
        self.assertGreater(eau.mean(), 0.35)                                                   # un lac sur toute la carte

    def test_eau_loi_d17p34a(self):
        fr = STACK['eau']; wet = alpha(fr[0]); tones = {tuple(c) for c in M['eau']['tons']}
        self.assertEqual((PH['eau'], TK['eau']), (4, 10)); self.assertEqual(len(tones), 12)
        rom = {tuple(int(v) for v in c) for c in np.unique(np.array(Image.open(R / 'source/zone_zero_v1/reference/D17P34A.png').convert('RGB')).reshape(-1, 3), axis=0)}
        self.assertTrue(tones <= rom)                                                          # tons exacts de l'eau de la ROM
        for a in fr:
            self.assertTrue((alpha(a) == wet).all()); self.assertTrue(colors(a) <= tones)
        ch = [float((fr[t][wet] != fr[(t + 1) % 4][wet]).any(1).mean()) for t in range(4)]
        self.assertTrue(all(0.05 < c < 0.45 for c in ch), ch)                                  # ondule à chaque image (ROM : 11-17 %)
        self.assertLess(max(ch) / min(ch), 1.5)                                                # raccord 3 -> 0 régulier
        self.assertFalse((fr[1] == fr[3]).all())                                               # boucle 0-1-2-3, pas d'aller-retour
        lines = [float(np.all(fr[t][wet][:, :3] == (47, 151, 191), 1).mean()) for t in range(4)]
        self.assertTrue(all(0.08 < v < 0.3 for v in lines), lines)                             # traits clairs (ROM : ~0,13)
        core = wet & (ndimage.distance_transform_edt(wet) > 10)
        for s in ((0, 4), (0, 8), (3, 0), (6, 0)):                                             # sur place : aucun défilement
            self.assertLess((np.roll(fr[0], s, (0, 1))[core] == fr[1][core]).all(1).mean(), (fr[0][core] == fr[1][core]).all(1).mean())
        b = loadmod('raz3_build', HERE / 'build.py')
        again = b.water_frames(wet)
        self.assertTrue(all((again[t] == fr[t]).all() for t in range(4)))                      # loi du module

    def test_cascades_ecume_rides(self):
        fr = STACK['cascades']; cols = M['cascades']['colonnes']; pal = {tuple(c) for c in C.CASC_PAL}
        self.assertEqual((PH['cascades'], TK['cascades'], M['cascades']['periode_px'], M['cascades']['pas_px']), (3, 10, 96, 32))
        self.assertEqual(len(cols), 2); self.assertEqual(sorted(c['x0'] < W / 2 for c in cols), [False, True])
        for a in fr:
            self.assertTrue(colors(a) <= pal)
        for c in cols:
            sl = (slice(0, c['y1']), slice(c['x0'], c['x1'])); h = c['y1']
            for t in range(3):
                a, b = fr[t][sl], fr[(t + 1) % 3][sl]
                self.assertTrue(alpha(a).all()); self.assertTrue(alpha(a[0]).all())
                self.assertTrue((a[:h - 32, :, :3] == b[32:, :, :3]).all(), (c, t))
            self.assertTrue(MASK['lake'][c['y1'] + 2:c['y1'] + 20, c['x0'] - 20:c['x1'] + 20].any())   # tombe dans le lac
        self.assertTrue(all((again == f_).all() for again, f_ in zip(C.cascade_frames(H, W, cols), fr)))
        ff = STACK['ecume']; wet_d = ndimage.binary_dilation(MASK['eau'] | MASK['cascades_rect'], iterations=1)
        for a in ff:
            self.assertTrue(colors(a) <= {tuple(c) for c in C.FOAM_PAL}); self.assertFalse((alpha(a) & ~wet_d).any())
        for c in cols:
            self.assertGreater(alpha(ff[0][c['y1'] - 6:c['y1'] + 10, c['x0']:c['x1']]).mean(), 0.3)
        rf = STACK['rides']
        for a in rf:
            self.assertFalse((alpha(a) & ~MASK['lake']).any()); self.assertTrue(colors(a) <= {tuple(c) for c in C.RIPPLE_PAL})
        self.assertTrue(all((rf[t] != rf[(t + 1) % 3]).any() for t in range(3)))

    def test_scintillements_tera(self):
        fr = STACK['scintillements']; stars = M['scintillements']['etoiles']; cr = alpha(STACK['cristaux'][0])
        self.assertEqual((PH['scintillements'], TK['scintillements']), (12, 5)); self.assertGreaterEqual(len(stars), 40)
        self.assertEqual({tuple(s['teinte']) for s in stars}, {tuple(c) for c in C.GLINT_TINTS})   # 4 teintes téra
        for s in stars:
            x, y = s['xy']; self.assertTrue(cr[y, x])                                           # sur un cristal
            on = [bool(alpha(fr[t])[y, x]) for t in range(12)]
            self.assertEqual(sum(on), 6)                                                        # allumée 6 phases sur 12
        for i, s in enumerate(stars):
            for t in stars[i + 1:]:
                self.assertGreater(max(abs(s['xy'][0] - t['xy'][0]), abs(s['xy'][1] - t['xy'][1])), 7)

    def test_ora_et_scene(self):
        with zipfile.ZipFile(O / 'RAZ3_route_zone_zero_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
        sc = Image.new('RGBA', (W, H))
        for n in NAMES:
            sc.alpha_composite(Image.fromarray(STACK[n][0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/RAZ3_scene_t000.png')).all())
        for k in ANIM:
            self.assertEqual(M['scene_loop_ticks'] % (PH[k] * TK[k]), 0, k)
        self.assertEqual(M['scene_loop_ticks'], 240)

    def test_acces_sud_tunnel(self):
        a = M['access']; mk = a['markers']
        self.assertTrue(all(p['ok'] for p in a['chemins_16x16'].values()))
        self.assertEqual(mk['entrance'][1], H - 16)
        walk = alpha(STACK['sol'][0])
        self.assertFalse((walk & (MASK['eau'] | MASK['cascades_rect'] | MASK['tunnel'])).any())
        self.assertFalse(walk[:, :16].any() or walk[:, -16:].any() or walk[:8].any())            # ni sortie latérale, ni bord haut
        ty, tx = np.nonzero(MASK['tunnel']); self.assertGreater(len(ty), 600)
        sx, sy = mk['sortie']
        self.assertLess(abs(sx + 8 - tx.mean()), 24); self.assertLess(sy - ty.max(), 24)          # sortie devant le tunnel
        self.assertLess(ty.max(), 90)                                                           # tunnel dans la paroi nord
        free = ~o_blocked(walk)
        self.assertEqual(int((~free).sum()), a['blocked_cells'])
        lab, n = ndimage.label(walk); self.assertEqual(n, 1)                                    # un seul sol continu
        px, py = mk['place']; self.assertTrue(180 < py < 420)

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
        self.assertEqual([m['EntName'] for m in o['Entities'][0]['Markers']], ['entrance', 'sortie', 'place'])
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))


if __name__ == '__main__':
    unittest.main()
