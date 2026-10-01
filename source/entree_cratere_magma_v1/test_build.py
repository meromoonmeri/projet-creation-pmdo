"""Tests dédiés — Entrée Cratère magma (ECM1), Dark Crater V2, 4:3.
.venv/bin/python -m unittest source.entree_cratere_magma_v1.test_build -v
Contrôles d'images, de formats, de cadence, de mouvement, de grille et d'accès : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, unittest, zipfile
import numpy as np
from scipy import ndimage
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/entree_cratere_magma_v1'
S = R / '.cache/entree_cratere_magma_v1/entree_cratere_magma'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
ANIM = ('magma', 'cascades', 'braises', 'colonnes')
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
MG = loadmod('magma_visqueux', R / 'source/magma_visqueux/magma.py')
PAL = {tuple(c) for c in MG.PAL}
MASK = {k: np.array(Image.open(O / f'masques/ECM1_masque_{k}.png')) > 0 for k in ('magma', 'cascade', 'ash', 'rock', 'mouth')}


def alpha(a):
    return a[..., 3] == 255


def colors(a):
    return {tuple(int(v) for v in c) for c in np.unique(a[alpha(a)][:, :3], axis=0)}


def land():
    m = np.zeros((H, W), bool)
    for n in ('cendre', 'falaises', 'bouche_grotte'):
        m |= alpha(STACK[n][0])
    return m


def best_shift(a, b, m, shifts):
    """Décalage vertical de a qui ressemble le plus à b sur m (part de pixels identiques)."""
    score = {s: float((np.roll(a, s, axis=0)[m] == b[m]).all(1).mean()) for s in shifts}
    return max(score, key=score.get), score


class Build(unittest.TestCase):
    def test_bruts_references(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        self.assertEqual(M['raw_inputs'][0]['images'], ['Dark_Crater_entrance_TDS.png'])      # rendu généré référencé
        b = loadmod('ecm1_build', HERE / 'build.py')
        dec = np.array(Image.open(HERE / 'bruts/decor_magenta.png').convert('RGB')).astype(int)
        self.assertTrue((np.array(Image.open(HERE / 'bruts/sol_complet.png').convert('RGB')) == b.make_sol(dec)).all())
        f = M['fidelite']; self.assertEqual(f['seuil'], 35); self.assertLess(f['distance'], 35)
        fm = M['fidelite_magma']; self.assertEqual(fm['seuil'], 12); self.assertLess(fm['distance'], 12)
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_calques_ordre_tailles_alpha(self):
        self.assertEqual(NAMES, ['magma', 'sol_complet', 'cendre', 'falaises', 'bouche_grotte', 'cascades', 'braises', 'colonnes'])
        files = [Path(p).name for p in ORDER]
        self.assertTrue(all(n.startswith('ECM1_') for n in files)); self.assertEqual(len(files), len(set(files)))
        self.assertEqual((W, H, W * 3), (768, 576, H * 4))                                  # 4:3
        for frames in STACK.values():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W)); self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255})
                v = a[alpha(a)].astype(int)                                                  # plus de magenta ni de vert
                self.assertEqual(int(((v[:, 0] > 200) & (v[:, 2] > 200) & (v[:, 1] < 90)).sum()), 0)
                self.assertEqual(int(((v[:, 1] > 160) & (v[:, 1] > 1.8 * v[:, 0]) & (v[:, 1] > 1.8 * v[:, 2])).sum()), 0)

    def test_couverture_complete(self):
        mg, sol = alpha(STACK['magma'][0]), alpha(STACK['sol_complet'][0])
        self.assertTrue((mg | sol).all()); self.assertFalse((mg & sol).any())
        self.assertTrue((mg == (MASK['magma'] | MASK['cascade'])).all())

    def test_magma_visqueux(self):
        fr = STACK['magma']; m = alpha(fr[0]); vis = MASK['magma'] & ~land()
        self.assertEqual((PH['magma'], TK['magma']), (32, 15))
        lab, n = ndimage.label(MASK['magma']); self.assertEqual(n, 2)                       # une mare de chaque côté
        xs = sorted(np.nonzero(lab == i)[1].mean() for i in (1, 2)); self.assertTrue(xs[0] < W / 3 and xs[1] > 2 * W / 3)
        for a in fr:
            self.assertTrue((alpha(a) == m).all()); self.assertTrue(colors(a) <= PAL)
        ch = [float((fr[t][vis] != fr[(t + 1) % 32][vis]).any(1).mean()) for t in range(32)]
        self.assertGreater(min(ch), 0.2)                                                     # ça bouge à chaque phase
        self.assertLess(max(ch) - min(ch), 0.1)                                              # boucle fermée : pas de saut 31 -> 0
        core = vis & (ndimage.distance_transform_edt(vis) > 8)
        wins = [best_shift(fr[t], fr[(t + 1) % 32], core, range(-6, 7))[0] for t in range(0, 32, 4)]
        self.assertTrue(all(1 <= w <= 5 for w in wins), wins)                                # dérive lente vers le sud (3 px)
        dark = [float(np.isin(fr[t][vis][:, 0], [70, 120]).mean()) for t in range(0, 32, 8)]
        self.assertTrue(all(0.03 < d < 0.3 for d in dark), dark)                             # plaques de croûte
        rip = {tuple(c) for c in MG.RIP_RAMP}
        self.assertGreater(float(np.mean([tuple(c) in rip for c in fr[0][vis][::7, :3].tolist()])), 0.6)

    def test_cascades(self):
        fr = STACK['cascades']; cm = MASK['cascade']
        lab, n = ndimage.label(cm); self.assertEqual(n, 2)
        self.assertEqual((PH['cascades'], TK['cascades']), (32, 15))
        for a in fr:
            self.assertFalse((alpha(a) & ~cm).any()); self.assertTrue(colors(a) <= PAL)
            self.assertLess(alpha(a).sum(), 0.9 * cm.sum())                                  # la lame serpente
            self.assertGreater(alpha(a).sum(), 0.4 * cm.sum())
        rock = alpha(STACK['falaises'][0]) | alpha(STACK['cendre'][0])
        self.assertGreater(float((rock & cm).mean() / cm.mean()), 0.5)                       # décor regarni derrière
        both = cm & alpha(fr[0]) & alpha(fr[1])
        w, sc = best_shift(fr[0], fr[1], both, range(0, 14))
        self.assertTrue(5 <= w <= 10, (w, sc))                                               # descend de ~7,5 px par phase
        feet = M['magma']['pieds_cascade']; self.assertEqual(len(feet), 2)
        for x, y in feet:
            self.assertTrue(MASK['magma'][min(y + 4, H - 1), x])                              # pied dans la mare

    def test_colonnes(self):
        fr = STACK['colonnes']; vents = M['colonnes']['events']
        self.assertEqual((PH['colonnes'], TK['colonnes']), (48, 5)); self.assertEqual(len(vents), 4)
        vis = MASK['magma'] & ~land(); peaks = []
        for v in vents:
            self.assertTrue(vis[v['y'], v['x']])
            box = (slice(max(0, v['y'] - 130), v['y'] + 14), slice(v['x'] - 20, v['x'] + 20))
            n = [int(alpha(a[box]).sum()) for a in fr]
            self.assertLess(min(n), 400); self.assertGreater(max(n), 1500)                   # calme puis jet
            peaks.append(int(np.argmax(n)))
            tall = [a[box] for a in fr if alpha(a[box]).sum() > 1500]
            ys = np.nonzero(alpha(tall[0]).any(1))[0]; self.assertGreater(ys.max() - ys.min(), 80)
        self.assertEqual(len(set(peaks)), 4)                                                  # éruptions décalées
        for a in fr:
            self.assertTrue(colors(a) <= PAL)
        self.assertTrue(all((fr[t] != fr[(t + 1) % 48]).any() for t in range(48)))

    def test_braises(self):
        fr = STACK['braises']; g = alpha(fr[0]); ramp = [tuple(v) for v in M['braises']['rampe']]
        self.assertFalse((g & ~alpha(STACK['falaises'][0])).any()); self.assertGreater(int(g.sum()), 100)
        lum = lambda a: float(a[g][:, :3].astype(float).mean())
        for a in fr:
            self.assertTrue((alpha(a) == g).all()); self.assertTrue(colors(a) <= set(ramp))
        self.assertTrue((fr[0] == fr[5]).all() and (fr[2] == fr[3]).all())
        self.assertLess(lum(fr[0]), lum(fr[1])); self.assertLess(lum(fr[1]), lum(fr[2]))

    def test_ora_et_scene(self):
        with zipfile.ZipFile(O / 'ECM1_entree_cratere_magma_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
        sc = Image.new('RGBA', (W, H))
        for n in NAMES:
            sc.alpha_composite(Image.fromarray(STACK[n][0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/ECM1_scene_t000.png')).all())
        for k in ANIM:
            self.assertEqual(M['scene_loop_ticks'] % (PH[k] * TK[k]), 0, k)
        self.assertEqual(M['scene_loop_ticks'], 480)

    def test_acces_entree(self):
        a = M['access']; mk = a['markers']
        self.assertTrue(a['chemin_16x16']['ok'])
        self.assertGreater(mk['entrance'][1], H - 40)                                          # arrivée au sud
        ys, xs = np.nonzero(MASK['mouth'])
        self.assertTrue(0 <= mk['donjon_seuil'][1] - ys.max() < 24)                          # devant la grotte
        self.assertLess(abs(mk['donjon_seuil'][0] + 8 - xs.mean()), 24)
        walk = alpha(STACK['cendre'][0])
        self.assertFalse((walk & (MASK['magma'] | MASK['cascade'])).any())
        free = ~(~walk).reshape(H // 8, 8, W // 8, 8).mean((1, 3)).__gt__(0.25)
        self.assertEqual(int((~free).sum()), a['blocked_cells'])
        for v in M['colonnes']['events']:
            self.assertFalse(free[v['y'] // 8, v['x'] // 8])                                  # évents non praticables

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
        self.assertEqual([m['EntName'] for m in o['Entities'][0]['Markers']], ['entrance', 'donjon_seuil'])
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))
        self.assertNotIn('warp', (S / f"Data/Script/{M['pmdo']['namespace']}/ground/{M['pmdo']['asset']}/init.lua").read_text().replace('aucun warp', ''))


if __name__ == '__main__':
    unittest.main()
