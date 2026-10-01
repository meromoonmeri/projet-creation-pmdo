"""Tests dédiés — Colonnes Lances, ruines (CLR1), 4:3.
.venv/bin/python -m unittest source.colonnes_lances_v1.test_build -v
Contrôles d'images, de formats, de cadence, de mouvement, de grille et d'accès : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, re, unittest, zipfile
import numpy as np
from scipy import ndimage
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/colonnes_lances_v1/CLR1'
S = R / '.cache/colonnes_lances_v1/colonnes_lances'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
ANIM = ('nuages', 'rochers', 'vitrail', 'eclats')
PH = {k: M[k]['phases'] for k in ANIM}
TK = {k: M[k]['frame_length_ticks'] for k in ANIM}


def load(p):
    return np.array(Image.open(p).convert('RGBA'))


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


def name_of(p):
    return re.sub(r'_fN+$', '', Path(p).stem.split('_', 2)[2])


def expand(p):
    mt = re.search(r'fN+', p)
    if mt:
        w = len(mt.group()) - 1
        return [load(O / p.replace(mt.group(), f'f{t:0{w}d}')) for t in range(PH[name_of(p)])]
    return [load(O / p)]


ORDER = M['layer_order_bottom_to_top']
NAMES = [name_of(p) for p in ORDER]
STACK = {n: expand(p) for n, p in zip(NAMES, ORDER)}
MASK = {k: np.array(Image.open(O / f'masques/CLR1_masque_{k}.png')) > 0
        for k in ('floor', 'ruins', 'rocks', 'void', 'vitrail', 'ciel_visible', 'piliers', 'couchees', 'autel', 'stairs')}


def alpha(a):
    return a[..., 3] == 255


def colors(a, m=None):
    m = alpha(a) if m is None else m
    return {tuple(int(v) for v in c) for c in np.unique(a[m][:, :3], axis=0)}


class Build(unittest.TestCase):
    def test_bruts_references_fidelite(self):
        deco, nua = M['raw_inputs']
        for raw in (deco, nua):
            self.assertEqual(hashlib.sha256((R / raw['file']).read_bytes()).hexdigest(), raw['sha256'])
            with Image.open(R / raw['file']) as im:
                self.assertEqual(list(im.size), raw['size'])
            self.assertTrue(raw['utilise'])
        self.assertEqual(deco['images'], ['source/colonnes_lances_v1/reference/D30P42A_sommet_decoupe_x2.png',
                                          'source/colonnes_lances_v1/reference/D28P33A_escalier_decoupe_x2.png'])
        self.assertEqual(nua['images'], ['source/colonnes_lances_v1/reference/D30P42A_nuages_decoupe_x3.png'])
        for p in deco['images'] + nua['images']:
            self.assertTrue((R / p).exists())
        idx = {x['code']: x for x in json.loads((R / 'source/outil_maps_pmdsky/index_rom.json').read_text())['maps']}
        for code, size, anim in (('D30P42A', [552, 576], True), ('D28P33A', [600, 432], False)):
            ref = M['references_da'][code]
            self.assertEqual(hashlib.sha256((R / ref['fichier']).read_bytes()).hexdigest(), ref['sha256'])
            self.assertEqual(idx[code]['taille_px'], size)                                   # rendu ROM direct de l'outil
            with Image.open(R / ref['fichier']) as im:
                self.assertEqual(im.size, tuple(size))
            self.assertEqual(idx[code]['animation_palette'], anim)
        f = M['fidelite']; self.assertEqual(f['seuil'], 35)
        self.assertEqual(sorted(f['seuille']), ['briques', 'escalier', 'nuages', 'piliers'])
        for k in f['seuille']:
            self.assertLess(f[k]['distance'], 35, k)
        self.assertLess(f['briques']['distance'], 20)                                        # matière principale
        sc = np.array(Image.open(O / 'review/CLR1_scene_t000.png').convert('RGB')).astype(int)   # recalcul
        ref = np.array(Image.open(R / M['references_da']['D30P42A']['fichier']).convert('RGB')).astype(int)
        for k in ('briques', 'piliers'):
            b0, a0, b1, a1 = f[k]['boite_scene_y0x0y1x1']; y0, x0, y1, x1 = f[k]['boite_ref_y0x0y1x1']
            d = np.linalg.norm(ref[y0:y1, x0:x1].reshape(-1, 3).mean(0) - sc[b0:b1, a0:a1].reshape(-1, 3).mean(0))
            self.assertAlmostEqual(float(d), f[k]['distance'], places=1)
            self.assertGreater(float(MASK['floor' if k == 'briques' else 'piliers'][b0:b1, a0:a1].mean()), 0.9, k)
        self.assertEqual(tuple(ref[560, 5]), tuple(M['ciel']['ton']))                        # ciel = ton ROM
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_calques_ordre_tailles_alpha(self):
        self.assertEqual(NAMES, ['ciel', 'nuages', 'sol', 'ruines', 'rochers', 'vitrail', 'eclats'])
        files = [Path(p).name for p in ORDER]
        self.assertTrue(all(n.startswith('CLR1_') for n in files)); self.assertEqual(len(files), len(set(files)))
        self.assertEqual((W, H, W * 3), (768, 576, H * 4))                                  # 4:3
        for n, frames in STACK.items():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W)); self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255})
                v = a[alpha(a)].astype(int)                                                  # ni magenta ni liseré rosé
                self.assertEqual(int(((v[:, 0] - v[:, 1] > 45) & (v[:, 2] - v[:, 1] > 35)).sum()), 0, n)
        ciel = STACK['ciel'][0]
        self.assertTrue(alpha(ciel).all()); self.assertEqual(colors(ciel), {tuple(M['ciel']['ton'])})   # couverture complète
        plat = alpha(STACK['sol'][0]) | alpha(STACK['ruines'][0])
        self.assertFalse((alpha(STACK['sol'][0]) & alpha(STACK['ruines'][0])).any())
        self.assertGreater(float(plat.mean()), 0.6)

    def test_nuages_derive_boucle(self):
        fr = STACK['nuages']; N = M['nuages']
        self.assertEqual((PH['nuages'], TK['nuages'], N['pas_px'], N['periode_px']), (120, 10, 4, 480))
        vis = MASK['ciel_visible']; pal = {tuple(c) for c in N['palette']}
        plat = alpha(STACK['sol'][0]) | alpha(STACK['ruines'][0])
        seen = []
        for a in fr:
            self.assertFalse((alpha(a) & ~vis).any())                                        # seulement là où le ciel se voit
            self.assertTrue(colors(a) <= pal)
            self.assertFalse(alpha(a[:3]).any())                                             # sommets jamais coupés en haut
            seen.append(float((alpha(a) & ~plat).sum() / (~plat).sum()))
        self.assertTrue(all(0.15 < s < 0.8 for s in seen), (min(seen), max(seen)))
        step = N['pas_px']; ok = vis[:, :-step] & vis[:, step:]
        for t in (0, 17, 59, 118, 119):                                                      # raccord 119 -> 0 compris
            a, b = fr[t], fr[(t + 1) % 120]
            self.assertTrue((b[:, :-step][ok] == a[:, step:][ok]).all(), t)                  # dérive de 4 px vers l'ouest
            self.assertTrue((a != b).any())
        rows = [r['haut'] for r in N['rangees']]
        self.assertEqual(rows, sorted(rows)); self.assertGreater(min(np.diff(rows)), 60)

    def test_vitrail_loi_rom(self):
        fr = STACK['vitrail']; V = M['vitrail']; B = loadmod('clr1_build', HERE / 'build.py')
        self.assertEqual((PH['vitrail'], TK['vitrail']), (12, 10))
        self.assertEqual([list(c) for c in B.ROM_TONES], V['tons_rom']); self.assertEqual(B.RAMP, V['rampes_indices'])
        m = alpha(fr[0]); self.assertFalse((m & ~MASK['vitrail']).any()); self.assertFalse((m & ~MASK['autel']).any())
        self.assertEqual(int(m.sum()), V['pixels_a'] + V['pixels_b']); self.assertGreater(V['pixels_a'], 80)
        self.assertGreater(V['pixels_b'], 80)
        tones = [tuple(c) for c in V['tons_rom']]
        for t, a in enumerate(fr):
            self.assertTrue((alpha(a) == m).all())
            want = {tones[V['rampes_indices']['a'][t]], tones[V['rampes_indices']['b'][t]]}
            self.assertEqual(colors(a), want, t)                                              # deux tons ROM à chaque pas
            if t:
                self.assertTrue((a != fr[t - 1]).any())
        self.assertEqual(len({tones[i] for i in V['rampes_indices']['a'] + V['rampes_indices']['b']}), 22)   # 22 tons de la ROM

    def test_rochers_eclats(self):
        fr = STACK['rochers']; lab, n = ndimage.label(MASK['rocks'])
        self.assertEqual(n, len(M['rochers']['liste'])); self.assertGreaterEqual(n, 5)
        self.assertEqual((PH['rochers'], TK['rochers']), (30, 20))
        ys0 = [np.nonzero(alpha(fr[0]) & (ndimage.binary_dilation(lab == i, iterations=3)))[0].mean() for i in range(1, n + 1)]
        for t, a in enumerate(fr):
            self.assertEqual(colors(a), colors(fr[0])) if t in (0,) else self.assertTrue(colors(a) <= colors(fr[0]) | colors(fr[1]))
            self.assertFalse((alpha(a) & (alpha(STACK['sol'][0]))).any())
            for i in range(1, n + 1):
                yy = np.nonzero(alpha(a) & ndimage.binary_dilation(lab == i, iterations=3))[0]
                self.assertLessEqual(abs(yy.mean() - ys0[i - 1]), 4.5)                        # flotte de 1 ou 2 px
        self.assertTrue(any((fr[t] != fr[0]).any() for t in range(1, 30)))
        ef = STACK['eclats']; tones = {tuple(c) for c in M['eclats']['tons']}
        self.assertEqual((PH['eclats'], TK['eclats'], len(M['eclats']['liste'])), (60, 10, 18))
        ys, xs = np.nonzero(MASK['vitrail'])
        for t, a in enumerate(ef):
            self.assertTrue(colors(a) <= tones); self.assertGreater(int(alpha(a).sum()), 4)
            yy, xx = np.nonzero(alpha(a))
            self.assertTrue(xx.min() >= xs.min() - 16 and xx.max() <= xs.max() + 16)          # autour de l'autel
            self.assertTrue(yy.min() >= ys.max() - 90 and yy.max() <= ys.max() + 10)
            self.assertTrue((a != ef[(t + 1) % 60]).any())

    def test_ora_et_scene(self):
        with zipfile.ZipFile(O / 'CLR1_colonnes_lances_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
        sc = Image.new('RGBA', (W, H))
        for n in NAMES:
            sc.alpha_composite(Image.fromarray(STACK[n][0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/CLR1_scene_t000.png')).all())
        for k in ANIM:
            self.assertEqual(M['scene_loop_ticks'] % (PH[k] * TK[k]), 0, k)
        self.assertEqual(M['scene_loop_ticks'], 1200)

    def test_acces_escalier_autel(self):
        a = M['access']; mk = a['markers']
        self.assertTrue(all(p['ok'] for p in a['chemins_16x16'].values()))
        self.assertGreater(mk['entrance'][1], H - 40)                                          # arrivée au sud
        walk = alpha(STACK['sol'][0])
        self.assertEqual(ndimage.label(walk)[1], 1)                                            # un seul sol continu
        self.assertTrue(walk[H - 1].any()); self.assertTrue(MASK['stairs'][H - 8:].any())      # l'escalier touche le bord sud
        self.assertFalse(walk[:, :16].any() or walk[:, -16:].any() or walk[:100].any())        # ni sortie latérale ni au nord
        self.assertFalse((walk & (MASK['piliers'] | MASK['couchees'] | MASK['autel'] | MASK['void'] | MASK['rocks'])).any())
        xs = np.nonzero(walk[H - 1])[0]
        self.assertLess(xs.max() - xs.min(), 90)                                               # seul l'escalier central arrive au sud
        free = ~(~walk).reshape(H // 8, 8, W // 8, 8).mean((1, 3)).__gt__(0.25)
        self.assertEqual(int((~free).sum()), a['blocked_cells'])
        ay = np.nonzero(MASK['autel'].any(1))[0].max(); axs = np.nonzero(MASK['autel'].any(0))[0]
        self.assertTrue(-8 <= mk['autel'][1] - ay < 24)          # peut mordre sur la dernière marche (<= 25 %); self.assertTrue(axs.min() < mk['autel'][0] + 8 < axs.max())
        py, px = np.nonzero(MASK['piliers'])
        self.assertTrue(px.min() < mk['centre'][0] < px.max() and py.min() < mk['centre'][1] < py.max())   # dans le cercle
        pl, npil = ndimage.label(MASK['piliers']); self.assertEqual(npil, 8)
        self.assertEqual(ndimage.label(MASK['couchees'])[1], 3)
        for i in range(1, 9):
            yy, xx = np.nonzero(pl == i); gy, gx = int(yy.max()) // 8, int(xx.mean()) // 8
            self.assertFalse(free[gy, gx])                                                    # colonnes bloquantes

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
        self.assertEqual([m['EntName'] for m in o['Entities'][0]['Markers']], ['entrance', 'autel', 'centre'])
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))
        self.assertNotIn('warp', (S / f"Data/Script/{M['pmdo']['namespace']}/ground/{M['pmdo']['asset']}/init.lua").read_text().replace('aucun warp', ''))


if __name__ == '__main__':
    unittest.main()
