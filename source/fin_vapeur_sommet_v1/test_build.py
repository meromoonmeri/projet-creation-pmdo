"""Tests dédiés — Fin Vapeur (FVS1), sommet de Steam Cave, 4:3.
.venv/bin/python -m unittest source.fin_vapeur_sommet_v1.test_build -v
Contrôles d'images, de formats, de cadence, de grille et d'accès : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, unittest, zipfile
import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_vapeur_sommet_v1'
S = R / '.cache/fin_vapeur_sommet_v1/fin_vapeur_sommet'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
PH = {'eau_source': M['eau_source']['phases'], 'bulles': M['bulles']['phases'], 'vapeur': M['vapeur']['phases']}
TK = {'eau_source': M['eau_source']['frame_length_ticks'], 'bulles': M['bulles']['frame_length_ticks'],
      'vapeur': M['vapeur']['frame_length_ticks']}


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


class Build(unittest.TestCase):
    def test_bruts_references(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        ref = {r['file'].split('/')[-1]: r['images'] for r in M['raw_inputs']}
        self.assertEqual(ref['decor_magenta.png'], ['Steam_Cave_Peak_TDS.png'])              # vraie fin du jeu en référence
        self.assertEqual(ref['vapeur_poses.png'], ['Steam_Cave_Peak_TDS.png'])
        self.assertEqual(M['fidelite']['seuil'], 35); self.assertLess(M['fidelite']['distance'], 35)
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_calques_ordre_tailles_alpha(self):
        self.assertEqual(NAMES, ['eau_source', 'bulles', 'sol_complet', 'sol_arene', 'margelle', 'events', 'stalagmites', 'vapeur'])
        files = [Path(p).name for p in ORDER]
        self.assertTrue(all(n.startswith('FVS1_') for n in files)); self.assertEqual(len(files), len(set(files)))
        self.assertEqual((W, H, W * 3), (768, 576, H * 4))                                  # 4:3
        for frames in STACK.values():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W)); self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255})
                v = a[alpha(a)].astype(int)                                                  # plus de magenta
                self.assertEqual(int(((v[:, 0] > 200) & (v[:, 2] > 200) & (v[:, 1] < 90)).sum()), 0)

    def test_couverture_complete(self):
        cover = alpha(STACK['eau_source'][0]) | alpha(STACK['sol_complet'][0])
        self.assertTrue(cover.all())
        self.assertFalse((alpha(STACK['eau_source'][0]) & alpha(STACK['sol_complet'][0])).any())

    def test_eau_de_la_source_boucle(self):
        fr = STACK['eau_source']; m = alpha(fr[0]); pal = {tuple(v) for v in M['eau_source']['couleurs'].values()}
        e2 = loadmod('esn2', R / 'source/entree_vapeur_sud_nord_v2/build.py')
        self.assertEqual(pal, {tuple(v) for v in e2.PAL.values()})                           # palette de l'entrée Vapeur V2
        ys, xs = np.nonzero(m); self.assertLess(ys.max(), H // 2)                            # la source est au nord
        for a in fr:
            self.assertTrue((alpha(a) == m).all())
            self.assertTrue({tuple(int(v) for v in c) for c in np.unique(a[m][:, :3], axis=0)} <= pal)
        d = [int((fr[t][m] != fr[(t + 1) % len(fr)][m]).any(1).sum()) for t in range(len(fr))]
        self.assertTrue(min(d) > 0, d)                                                        # 3 -> 0 compris

    def test_bulles_sur_l_eau(self):
        water = alpha(STACK['eau_source'][0]); land = np.zeros((H, W), bool)
        for n in ('sol_arene', 'margelle', 'events', 'stalagmites'):
            land |= alpha(STACK[n][0])
        n = []
        for a in STACK['bulles']:
            self.assertFalse((alpha(a) & ~(water & ~land)).any()); n.append(int(alpha(a).sum()))
        self.assertGreater(max(n), 0); self.assertEqual(len(M['bulles']['emetteurs']), 4)
        self.assertEqual((PH['bulles'], TK['bulles']), (24, 5))

    def test_vapeur_sur_les_events_boucle(self):
        v = M['vapeur']; fr = STACK['vapeur']
        self.assertEqual((PH['vapeur'], TK['vapeur'], len(v['events_px'])), (24, 5, 3))
        poses = [load(O / f'poses_vapeur/FVS1_vapeur_pose_{i}.png') for i in range(7)]
        hs = [p.shape[0] for p in poses]
        self.assertEqual(hs[:4], sorted(hs[:4])); self.assertGreaterEqual(max(hs), 90)       # le panache grandit, ~100 px
        vents = alpha(STACK['events'][0])
        for name, (x, y) in v['events_px'].items():
            self.assertTrue(vents[y - 8:y + 8, x - 8:x + 8].any(), name)                       # pied du panache sur l'évent
            off = v['decalages'][name]
            for k, pose in enumerate(v['chronologie_event']):
                a = fr[(k + off) % PH['vapeur']]
                self.assertTrue(alpha(a)[y - 2:y + 1, x - 6:x + 7].any(), (name, k))          # le panache part de l'évent
        pal = {tuple(c) for c in v['palette']}
        n = [int(alpha(a).sum()) for a in fr]
        self.assertGreater(min(n), 0)                                                         # toujours de la vapeur quelque part
        for a in fr:
            self.assertTrue({tuple(int(c) for c in px) for px in np.unique(a[alpha(a)][:, :3], axis=0)} <= pal)
        offs = sorted(v['decalages'][k] for k in v['events_px'])
        self.assertEqual(len(set(offs)), 3)                                                  # évents décalés

    def test_ora_et_scene(self):
        with zipfile.ZipFile(O / 'FVS1_fin_vapeur_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
        sc = Image.new('RGBA', (W, H))
        for n in NAMES:
            sc.alpha_composite(Image.fromarray(STACK[n][0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/FVS1_scene_t000.png')).all())
        self.assertEqual(M['scene_loop_ticks'] % (PH['eau_source'] * TK['eau_source']), 0)
        self.assertEqual(M['scene_loop_ticks'] % (PH['vapeur'] * TK['vapeur']), 0)

    def test_acces_fin_de_donjon(self):
        a = M['access']; mk = a['markers']
        self.assertTrue(a['chemins_16x16']['boss']['ok']); self.assertTrue(a['chemins_16x16']['source']['ok'])
        self.assertGreater(mk['entrance'][1], H - 40)                                          # arrivée au sud
        self.assertLess(mk['source'][1], H // 2)                                              # objectif au nord
        self.assertTrue(H // 3 < mk['boss'][1] < 3 * H // 4)                                  # arène au centre
        water = alpha(STACK['eau_source'][0]); ys = np.nonzero(water.any(1))[0]
        self.assertGreater(mk['source'][1], ys.max())                                         # devant la source, pas dedans
        self.assertTrue(alpha(STACK['stalagmites'][0])[:8].mean() > 0.9)                      # aucune sortie au nord

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
        self.assertEqual({m['EntName'] for m in o['Entities'][0]['Markers']}, {'entrance', 'boss', 'source'})
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))
        self.assertNotIn('warp', (S / f"Data/Script/{M['pmdo']['namespace']}/ground/{M['pmdo']['asset']}/init.lua").read_text().replace('aucun warp', ''))


if __name__ == '__main__':
    unittest.main()
