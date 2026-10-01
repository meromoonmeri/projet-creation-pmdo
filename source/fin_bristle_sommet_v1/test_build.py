"""Tests dédiés — Fin Bristle (FBS1), sommet de Mt. Bristle, 4:3.
.venv/bin/python -m unittest source.fin_bristle_sommet_v1.test_build -v
Contrôles d'images, de formats, de cadence, de grille et d'accès : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, unittest, zipfile
import numpy as np
from scipy import ndimage
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_bristle_sommet_v1'
S = R / '.cache/fin_bristle_sommet_v1/fin_bristle_sommet'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
ANIM = ('rafales', 'touffes')
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


def colors(a):
    return {tuple(int(v) for v in c) for c in np.unique(a[alpha(a)][:, :3], axis=0)}


def walk():
    return alpha(STACK['sable'][0]) | np.array(Image.open(O / 'masques/FBS1_masque_tuft.png')) > 0


class Build(unittest.TestCase):
    def test_bruts_references(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        ref = {r['file'].split('/')[-1]: r['images'] for r in M['raw_inputs']}
        self.assertEqual(ref['decor.png'], ['Mt_Bristle_entrance_TD.png'])
        self.assertEqual(ref['sol_complet.png'], ['Mt_Bristle_entrance_TD.png decoupe [220, 190, 340, 262] x4'])
        self.assertEqual(Image.open(HERE / 'reference/Explorers_TD_-_Mt._Bristle_Peak_110px.png').size, (110, 120))
        self.assertEqual(len(M['bruts_ecartes']), 2)
        f = M['fidelite']; self.assertEqual((f['seuil'], f['seuil_roche']), (35, 25))
        self.assertLess(f['distance'], 35); self.assertLess(f['distance_roche'], 25)
        self.assertLess(f['distance_vignette'], 45)            # garde-fou large : vignette floue et désaturée
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])
        self.assertIn('Drowzee', M['reference_fin_boss']); self.assertIn('Azurill', M['reference_fin_boss'])

    def test_calques_ordre_tailles_alpha(self):
        self.assertEqual(NAMES, ['sol_complet', 'sable', 'rafales', 'rochers', 'touffes', 'falaises'])
        files = [Path(p).name for p in ORDER]
        self.assertTrue(all(n.startswith('FBS1_') for n in files)); self.assertEqual(len(files), len(set(files)))
        self.assertEqual((W, H, W * 3), (768, 576, H * 4))
        for frames in STACK.values():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W)); self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255})
        self.assertTrue(alpha(STACK['sol_complet'][0]).all())                                  # couverture complète
        st = sum(alpha(STACK[n][0]).astype(int) for n in ('sable', 'rochers', 'falaises'))
        self.assertLessEqual(int(st.max()), 1)                                                 # classes exclusives

    def test_clairiere_fermee_ouverte_au_sud(self):
        wk = walk()
        self.assertFalse(wk[:16].any() or wk[:, :16].any() or wk[:, -16:].any())               # aucune sortie hors du sud
        self.assertTrue(wk[-8:].any())
        xs = np.nonzero(wk[-4])[0]; self.assertLess(abs(xs.mean() - W / 2), 40)                 # couloir au centre
        lab, n = ndimage.label(wk); self.assertEqual(n, 1)                                     # un seul espace praticable
        ys, xs = np.nonzero(wk & (np.mgrid[:H, :W][0] < H - 180))
        self.assertGreater(xs.max() - xs.min(), W * 0.6); self.assertGreater(ys.max() - ys.min(), H * 0.35)   # grande clairière

    def test_rafales(self):
        fr = STACK['rafales']; sand = alpha(STACK['sable'][0]); A = M['rafales']
        self.assertEqual((PH['rafales'], TK['rafales']), (24, 5))
        pal = {tuple(A['couleurs']['claire']), tuple(A['couleurs']['douce'])}
        sm = STACK['sable'][0][sand][:, :3].astype(float).mean(0)
        for c in pal:
            self.assertGreater(float(np.mean(c)) - float(sm.mean()), 20)                       # visibles sur le sable
        for a in fr:
            self.assertFalse((alpha(a) & ~sand).any()); self.assertTrue(colors(a) <= pal)
            self.assertGreater(int(alpha(a).sum()), 40)
        self.assertTrue(all((fr[t] != fr[(t + 1) % 24]).any() for t in range(24)))
        # chaque traînée suit la loi du manifeste (vers l'est) ; aucune ne boucle en vue
        for gd in A['placements'][:10]:
            x0, y0 = gd['depart']
            for t in range(24):
                k = (t - gd['phase']) % 24
                if k < A['visibles'] and sand[y0 - 2:y0 + 3, x0 + 8 * k:x0 + 8 * k + 2].all():
                    y = y0 + int(round(1.5 * np.sin(2 * np.pi * k / 12 + gd['ondulation'])))
                    self.assertTrue(alpha(fr[t])[y, x0 + 8 * k], (gd, t))
        self.assertEqual(A['visibles'], 12)

    def test_touffes(self):
        fr = STACK['touffes']; T = M['touffes']
        self.assertEqual((PH['touffes'], TK['touffes']), (12, 10))
        self.assertGreaterEqual(len(T['placements']), 5)
        self.assertIn('touffes_vent_poses.png', T['origine'])
        pal = {tuple(c) for c in T['palette']}
        for a in fr:
            self.assertTrue(colors(a) <= pal)
        self.assertTrue(all((fr[t] != fr[(t + 1) % 12]).any() for t in range(12)))
        tm = np.array(Image.open(O / 'masques/FBS1_masque_tuft.png')) > 0
        self.assertFalse((alpha(STACK['sable'][0]) & tm).any())                               # trou dans le sable sous chaque touffe
        for p in T['placements']:
            x, y = p['base_xy']; self.assertTrue(walk()[y - 4:y, x - 4:x + 4].any())

    def test_ora_et_scene(self):
        with zipfile.ZipFile(O / 'FBS1_fin_bristle_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
        sc = Image.new('RGBA', (W, H))
        for n in NAMES:
            sc.alpha_composite(Image.fromarray(STACK[n][0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/FBS1_scene_t000.png')).all())
        for k in ANIM:
            self.assertEqual(M['scene_loop_ticks'] % (PH[k] * TK[k]), 0, k)
        self.assertEqual(M['scene_loop_ticks'], 120)

    def test_acces_fin_de_donjon(self):
        a = M['access']; mk = a['markers']
        self.assertTrue(a['chemins_16x16']['boss']['ok']); self.assertTrue(a['chemins_16x16']['azurill']['ok'])
        self.assertGreater(mk['entrance'][1], H - 40)
        self.assertTrue(H // 3 < mk['boss'][1] < 3 * H // 4)
        wk = walk(); top = np.nonzero(wk[:, W // 2 - 24:W // 2 + 24].any(1))[0].min()
        self.assertLess(mk['azurill'][1], mk['boss'][1]); self.assertLess(mk['azurill'][1] - top, 32)
        self.assertLess(abs(mk['azurill'][0] + 8 - W / 2), 24)
        self.assertFalse((alpha(STACK['rochers'][0]) & wk).any())                               # les blocs bloquent
        free = ~(~wk).reshape(H // 8, 8, W // 8, 8).mean((1, 3)).__gt__(0.25)
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
        self.assertEqual({m['EntName'] for m in o['Entities'][0]['Markers']}, {'entrance', 'boss', 'azurill'})
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))
        self.assertNotIn('warp', (S / f"Data/Script/{M['pmdo']['namespace']}/ground/{M['pmdo']['asset']}/init.lua").read_text().replace('aucun warp', ''))


if __name__ == '__main__':
    unittest.main()
