"""Tests dédiés — Fin Cratère (FCF1), fosse de Dark Crater, 4:3.
.venv/bin/python -m unittest source.fin_cratere_fosse_v1.test_build -v
Contrôles d'images, de formats, de cadence, de grille et d'accès : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, unittest, zipfile
import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_cratere_fosse_v1'
S = R / '.cache/fin_cratere_fosse_v1/fin_cratere_fosse'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
ANIM = ('lave', 'eclats', 'bulles', 'lueur')
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


EC = loadmod('ecn1', R / 'source/entree_cratere_sud_nord_v1/build.py')
PAL = {tuple(v) for v in EC.PAL.values()}


def colors(a):
    return {tuple(int(v) for v in c) for c in np.unique(a[alpha(a)][:, :3], axis=0)}


def land():
    m = np.zeros((H, W), bool)
    for n in ('sol_plateau', 'rebord', 'pitons', 'embleme'):
        m |= alpha(STACK[n][0])
    return m


class Build(unittest.TestCase):
    def test_bruts_references(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        ref = {r['file'].split('/')[-1]: r['images'] for r in M['raw_inputs']}
        self.assertEqual(ref['decor_magenta.png'], ['Dark_Crater_Pit_TDS.png'])              # vraie fin du jeu en référence
        a = np.array(Image.open(HERE / 'bruts/decor_magenta.png').convert('RGB'))
        f = np.array(Image.open(HERE / 'bruts/sol_complet.png').convert('RGB'))
        y0, y1, x0, x1 = 280, 600, 360, 840                                                  # sol complet = miroir documenté
        self.assertTrue((f[:y1 - y0, :x1 - x0] == a[y0:y1, x0:x1]).all())
        self.assertTrue((f[:y1 - y0, x1 - x0:2 * (x1 - x0)] == a[y0:y1, x0:x1][:, ::-1]).all())
        self.assertIn('miroir', [r for r in M['raw_inputs'] if r['file'].endswith('sol_complet.png')][0]['origine'])
        self.assertEqual(M['fidelite']['seuil'], 35); self.assertLess(M['fidelite']['distance'], 35)
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_calques_ordre_tailles_alpha(self):
        self.assertEqual(NAMES, ['lave', 'eclats', 'bulles', 'sol_complet', 'sol_plateau', 'rebord', 'pitons', 'embleme', 'lueur'])
        files = [Path(p).name for p in ORDER]
        self.assertTrue(all(n.startswith('FCF1_') for n in files)); self.assertEqual(len(files), len(set(files)))
        self.assertEqual((W, H, W * 3), (768, 576, H * 4))                                  # 4:3
        for frames in STACK.values():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W)); self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255})
                v = a[alpha(a)].astype(int)                                                  # plus de magenta
                self.assertEqual(int(((v[:, 0] > 200) & (v[:, 2] > 200) & (v[:, 1] < 90)).sum()), 0)

    def test_couverture_complete(self):
        cover = alpha(STACK['lave'][0]) | alpha(STACK['sol_complet'][0])
        self.assertTrue(cover.all())
        self.assertFalse((alpha(STACK['lave'][0]) & alpha(STACK['sol_complet'][0])).any())

    def test_lave_boucle_palette_ecn1(self):
        fr = STACK['lave']; m = alpha(fr[0])
        self.assertEqual({tuple(v) for v in M['lave']['couleurs'].values()}, PAL)            # palette de l'entrée Cratère
        self.assertTrue(m[:, :8].mean() > 0.8 and m[:, -8:].mean() > 0.8)                    # la lave borde la carte (hors pitons)
        for a in fr:
            self.assertTrue((alpha(a) == m).all()); self.assertTrue(colors(a) <= PAL)
        d = [int((fr[t][m] != fr[(t + 1) % len(fr)][m]).any(1).sum()) for t in range(len(fr))]
        self.assertTrue(min(d) > 0, d)                                                        # 3 -> 0 compris
        self.assertEqual((PH['lave'], TK['lave']), (4, 10))

    def test_bulles_et_eclats_sur_la_lave(self):
        visible = alpha(STACK['lave'][0]) & ~land()
        for k, nb in (('bulles', len(M['bulles']['emetteurs'])), ('eclats', len(M['eclats']['placements']))):
            n = []
            for a in STACK[k]:
                self.assertFalse((alpha(a) & ~visible).any(), k); n.append(int(alpha(a).sum()))
            self.assertGreater(max(n), 0, k); self.assertGreaterEqual(nb, 6, k)
        for a in STACK['eclats']:
            self.assertTrue(colors(a) <= PAL)
        e = STACK['eclats']; self.assertTrue(any((e[t] != e[t + 1]).any() for t in range(len(e) - 1)))
        self.assertEqual((PH['bulles'], TK['bulles'], PH['eclats'], TK['eclats']), (24, 5, 4, 10))

    def test_embleme_et_lueur(self):
        emb = STACK['embleme'][0]; em = alpha(emb)
        c = colors(emb); self.assertTrue(c <= PAL)
        self.assertIn(tuple(EC.PAL['inter']), c); self.assertIn(tuple(EC.PAL['jaune']), c)      # anneaux rouges + jaune gardés
        ys, xs = np.nonzero(em); self.assertLess(ys.max(), H // 4); self.assertLess(abs(xs.mean() - W / 2), 40)
        fr = STACK['lueur']; g = alpha(fr[0]); ramp = [tuple(v) for v in M['lueur']['rampe']]
        self.assertEqual(M['lueur']['pulsation'], [0, 1, 2, 2, 1, 0])
        self.assertFalse((g & ~(em | alpha(STACK['rebord'][0]))).any())                       # sur l'emblème et le rebord
        self.assertGreater(int((g & em).sum()), 300)
        lum = lambda a: float(a[g][:, :3].astype(float).mean())
        for a in fr:
            self.assertTrue((alpha(a) == g).all()); self.assertTrue(colors(a) <= set(ramp))
        self.assertTrue((fr[0] == fr[5]).all() and (fr[2] == fr[3]).all())                    # boucle 5 -> 0 douce
        self.assertLess(lum(fr[0]), lum(fr[1])); self.assertLess(lum(fr[1]), lum(fr[2]))       # la pulsation éclaire
        self.assertEqual((PH['lueur'], TK['lueur']), (6, 10))

    def test_ora_et_scene(self):
        with zipfile.ZipFile(O / 'FCF1_fin_cratere_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
        sc = Image.new('RGBA', (W, H))
        for n in NAMES:
            sc.alpha_composite(Image.fromarray(STACK[n][0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/FCF1_scene_t000.png')).all())
        for k in ANIM:
            self.assertEqual(M['scene_loop_ticks'] % (PH[k] * TK[k]), 0, k)

    def test_acces_fin_de_donjon(self):
        a = M['access']; mk = a['markers']
        self.assertTrue(a['chemins_16x16']['boss']['ok']); self.assertTrue(a['chemins_16x16']['embleme']['ok'])
        self.assertGreater(mk['entrance'][1], H - 40)                                          # arrivée au sud
        self.assertLess(mk['embleme'][1], H // 4)                                             # objectif au nord
        self.assertTrue(H // 3 < mk['boss'][1] < 3 * H // 4)                                  # arène au centre
        em = alpha(STACK['embleme'][0]); ys, xs = np.nonzero(em)
        self.assertTrue(0 <= mk['embleme'][1] - ys.max() < 40)                                # devant l'emblème, pas dedans
        self.assertLess(abs(mk['embleme'][0] + 8 - xs.mean()), 24)
        walk = alpha(STACK['sol_plateau'][0])                                                 # aucune sortie hors du sud
        self.assertFalse(walk[:16].any() or walk[:, :16].any() or walk[:, -16:].any())
        self.assertTrue(walk[-8:].any())

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
        self.assertEqual({m['EntName'] for m in o['Entities'][0]['Markers']}, {'entrance', 'boss', 'embleme'})
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))
        self.assertNotIn('warp', (S / f"Data/Script/{M['pmdo']['namespace']}/ground/{M['pmdo']['asset']}/init.lua").read_text().replace('aucun warp', ''))


if __name__ == '__main__':
    unittest.main()
