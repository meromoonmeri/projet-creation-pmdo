"""Tests dédiés — Fin Givre (FGG1), Frosty Grotto, 4:3.
.venv/bin/python -m unittest source.fin_givre_grotte_v1.test_build -v
Contrôles d'images, de formats, de cadence, de grille et d'accès : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, unittest, zipfile
import numpy as np
from scipy import ndimage
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_givre_grotte_v1'
S = R / '.cache/fin_givre_grotte_v1/fin_givre_grotte'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
ANIM = ('eau_glacee', 'reflets', 'lueur_cristal', 'flocons')
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


def alpha(a):
    return a[..., 3] == 255


EG = loadmod('egn1', R / 'source/entree_givre_sud_nord_v1/build.py')
PAL = {tuple(v) for v in EG.PAL.values()}


def colors(a):
    return {tuple(int(v) for v in c) for c in np.unique(a[alpha(a)][:, :3], axis=0)}


def land():
    m = np.zeros((H, W), bool)
    for n in ('sol_glace', 'parois', 'cristal'):
        m |= alpha(STACK[n][0])
    return m


class Build(unittest.TestCase):
    def test_bruts_references(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        ref = {r['file'].split('/')[-1]: r['images'] for r in M['raw_inputs']}
        fin = 'reference/Rescue_Team_-_Articuno_first_appearance_120px.png'
        self.assertEqual(ref['decor_magenta.png'], ['pmdskyicearena.png', fin])               # textures + vraie salle
        self.assertEqual(ref['sol_complet.png'], ['pmdskyicearena.png decoupe [0, 222, 504, 282]'])
        self.assertEqual(Image.open(HERE / fin).size, (120, 90))
        f = M['fidelite']; self.assertEqual(f['seuil'], 35)
        self.assertLess(f['distance'], 35); self.assertLess(f['distance_vignette'], 35)
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_calques_ordre_tailles_alpha(self):
        self.assertEqual(NAMES, ['eau_glacee', 'reflets', 'sol_complet', 'sol_glace', 'parois', 'cristal', 'lueur_cristal', 'flocons'])
        files = [Path(p).name for p in ORDER]
        self.assertTrue(all(n.startswith('FGG1_') for n in files)); self.assertEqual(len(files), len(set(files)))
        self.assertEqual((W, H, W * 3), (768, 576, H * 4))                                  # 4:3
        for frames in STACK.values():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W)); self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255})
                v = a[alpha(a)].astype(int)                                                  # plus de magenta
                self.assertEqual(int(((v[:, 0] > 200) & (v[:, 2] > 200) & (v[:, 1] < 90)).sum()), 0)

    def test_couverture_complete(self):
        cover = alpha(STACK['eau_glacee'][0]) | alpha(STACK['sol_complet'][0])
        self.assertTrue(cover.all())
        self.assertFalse((alpha(STACK['eau_glacee'][0]) & alpha(STACK['sol_complet'][0])).any())

    def test_bassins_eau_glacee(self):
        fr = STACK['eau_glacee']; m = alpha(fr[0])
        self.assertEqual({tuple(v) for v in M['eau_glacee']['couleurs'].values()}, PAL)      # palette de l'entrée Givre
        lab, n = ndimage.label(m); self.assertEqual(n, 2)                                    # deux bassins
        xs = [np.nonzero(lab == i)[1].mean() for i in (1, 2)]
        self.assertTrue(min(xs) < W / 2 < max(xs))                                            # un de chaque côté
        for a in fr:
            self.assertTrue((alpha(a) == m).all()); self.assertTrue(colors(a) <= PAL)
        d = [int((fr[t][m] != fr[(t + 1) % len(fr)][m]).any(1).sum()) for t in range(len(fr))]
        self.assertTrue(min(d) > 0, d)
        self.assertEqual((PH['eau_glacee'], TK['eau_glacee']), (4, 10))

    def test_reflets_sur_l_eau(self):
        visible = alpha(STACK['eau_glacee'][0]) & ~land()
        light = {tuple(EG.PAL['reflet']), tuple(EG.PAL['clair'])}
        n = []
        for a in STACK['reflets']:
            self.assertFalse((alpha(a) & ~visible).any()); self.assertTrue(colors(a) <= light); n.append(int(alpha(a).sum()))
        self.assertGreater(max(n), 0); self.assertGreaterEqual(len(M['reflets']['placements']), 2)
        e = STACK['reflets']; self.assertTrue(any((e[t] != e[t + 1]).any() for t in range(len(e) - 1)))

    def test_cristal_et_lueur(self):
        cm = alpha(STACK['cristal'][0]); ys, xs = np.nonzero(cm)
        self.assertLess(ys.mean(), H / 2); self.assertLess(abs(xs.mean() - W / 2), 30)       # au nord, au centre
        self.assertLessEqual(len(colors(STACK['cristal'][0])), 32)
        fr = STACK['lueur_cristal']; g = alpha(fr[0]); ramp = [tuple(v) for v in M['lueur_cristal']['rampe']]
        self.assertFalse((g & ~cm).any()); self.assertGreater(int(g.sum()), 500)
        lum = lambda a: float(a[g][:, :3].astype(float).mean())
        for a in fr:
            self.assertTrue((alpha(a) == g).all()); self.assertTrue(colors(a) <= set(ramp))
        self.assertTrue((fr[0] == fr[5]).all() and (fr[2] == fr[3]).all())
        self.assertLess(lum(fr[0]), lum(fr[1])); self.assertLess(lum(fr[1]), lum(fr[2]))
        self.assertEqual((PH['lueur_cristal'], TK['lueur_cristal']), (6, 10))

    def test_flocons_de_l_entree(self):
        fr = STACK['flocons']; pal = {tuple(int(v) for v in c) for c in EG.FLAKE_PAL}
        self.assertEqual(len(M['flocons']['emetteurs']), 64)
        self.assertIn('flocons_poses.png', M['flocons']['origine'])
        n = [int(alpha(a).sum()) for a in fr]
        self.assertGreater(min(n), 0)
        for a in fr:
            self.assertTrue(colors(a) <= pal)
        self.assertTrue(all((fr[t] != fr[(t + 1) % len(fr)]).any() for t in range(len(fr))))
        self.assertEqual((PH['flocons'], TK['flocons']), (48, 5))

    def test_ora_et_scene(self):
        with zipfile.ZipFile(O / 'FGG1_fin_givre_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
        sc = Image.new('RGBA', (W, H))
        for n in NAMES:
            sc.alpha_composite(Image.fromarray(STACK[n][0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/FGG1_scene_t000.png')).all())
        for k in ANIM:
            self.assertEqual(M['scene_loop_ticks'] % (PH[k] * TK[k]), 0, k)
        self.assertEqual(M['scene_loop_ticks'], 240)

    def test_acces_fin_de_donjon(self):
        a = M['access']; mk = a['markers']
        self.assertTrue(a['chemins_16x16']['boss']['ok']); self.assertTrue(a['chemins_16x16']['cristal']['ok'])
        self.assertGreater(mk['entrance'][1], H - 40)                                          # arrivée au sud
        self.assertTrue(H // 3 < mk['boss'][1] < 3 * H // 4)                                  # arène au centre
        cm = alpha(STACK['cristal'][0]); ys, xs = np.nonzero(cm)
        self.assertTrue(0 <= mk['cristal'][1] - ys.max() < 16)                               # devant le cristal, pas dedans
        self.assertLess(abs(mk['cristal'][0] + 8 - xs.mean()), 16)
        walk = alpha(STACK['sol_glace'][0])
        self.assertFalse((walk & alpha(STACK['eau_glacee'][0])).any())                        # les bassins bloquent
        self.assertFalse(walk[:16].any() or walk[:, :16].any() or walk[:, -16:].any())       # aucune sortie hors du sud
        self.assertTrue(walk[-8:].any())
        free = ~(~walk).reshape(H // 8, 8, W // 8, 8).mean((1, 3)).__gt__(0.25)
        self.assertEqual(int((~free).sum()), a['blocked_cells'])

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
        self.assertEqual({m['EntName'] for m in o['Entities'][0]['Markers']}, {'entrance', 'boss', 'cristal'})
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))
        self.assertNotIn('warp', (S / f"Data/Script/{M['pmdo']['namespace']}/ground/{M['pmdo']['asset']}/init.lua").read_text().replace('aucun warp', ''))


if __name__ == '__main__':
    unittest.main()
