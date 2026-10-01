"""Tests dédiés — Fin Jungle (FJS1), fond de Southern Jungle, 4:3.
.venv/bin/python -m unittest source.fin_jungle_sud_v1.test_build -v
Contrôles d'images, de formats, de cadence, de grille et d'accès : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, unittest, zipfile
import numpy as np
from scipy import ndimage
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_jungle_sud_v1'
S = R / '.cache/fin_jungle_sud_v1/fin_jungle_sud'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
ANIM = ('feuilles', 'papillons')
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
    return alpha(STACK['sable'][0]) | alpha(STACK['pelouse'][0])


class Build(unittest.TestCase):
    def test_bruts_references(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        ref = {r['file'].split('/')[-1]: r['images'] for r in M['raw_inputs']}
        self.assertIn('Southern_Jungle_exit_S.png', ref['decor_etape_recolore.png'])
        self.assertEqual(ref['decor.png'], ['source/fin_jungle_sud_v1/bruts/decor_etape_recolore.png'])
        self.assertEqual(ref['sol_complet.png'], ['Southern_Jungle_exit_S.png decoupe [300, 190, 400, 240] x4'])
        with Image.open(R / 'Southern_Jungle_exit_S.png') as im:
            self.assertEqual(im.size, (504, 456))
        f = M['fidelite']; self.assertEqual(f['seuil'], 35)
        for k in ('sable', 'pelouse'):
            self.assertLess(f[k]['distance'], 35, k)
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])
        self.assertIn('non nomme', M['choix_agent']['boss'])

    def test_calques_ordre_tailles_alpha(self):
        self.assertEqual(NAMES, ['sol_complet', 'sable', 'pelouse', 'feuilles', 'rocher', 'jungle', 'papillons', 'canopee'])
        files = [Path(p).name for p in ORDER]
        self.assertTrue(all(n.startswith('FJS1_') for n in files)); self.assertEqual(len(files), len(set(files)))
        self.assertEqual((W, H, W * 3), (768, 576, H * 4))
        for frames in STACK.values():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W)); self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255})
        self.assertTrue(alpha(STACK['sol_complet'][0]).all())                                  # couverture complète
        st = sum(alpha(STACK[n][0]).astype(int) for n in ('sable', 'pelouse', 'rocher', 'jungle', 'canopee'))
        self.assertEqual(int(st.min()), 1); self.assertEqual(int(st.max()), 1)                  # partition exacte

    def test_couleurs(self):
        rk = STACK['rocher'][0][alpha(STACK['rocher'][0])][:, :3].astype(int)
        self.assertLess(float((rk.max(1) - rk.min(1)).mean()), 30)                              # rocher gris, pas olive
        self.assertLessEqual(len(colors(STACK['rocher'][0])), 16)
        pe = STACK['pelouse'][0][alpha(STACK['pelouse'][0])][:, :3].astype(float).mean(0)
        self.assertGreater(pe[1] - pe[0], 50)                                                   # pelouse verte
        ca = STACK['canopee'][0][alpha(STACK['canopee'][0])][:, :3].astype(float) @ [.299, .587, .114]
        self.assertLess(float(ca.mean()), 50)                                                   # premier plan sombre
        self.assertGreater(int(alpha(STACK['canopee'][0])[-40:].sum()), W * 40 // 3)            # canopée au bas de l'écran

    def test_clairiere_fermee_ouverte_au_sud(self):
        wk = walk()
        self.assertFalse(wk[:16].any() or wk[:, :16].any() or wk[:, -16:].any())               # aucune sortie hors du sud
        self.assertTrue(wk[-8:].any())
        xs = np.nonzero(wk[-4])[0]; self.assertLess(abs(xs.mean() - W / 2), 40)                 # couloir au centre
        lab, n = ndimage.label(wk); self.assertEqual(n, 1)                                     # un seul espace praticable
        pe = alpha(STACK['pelouse'][0]); self.assertGreater(int(pe.sum()), 8000)
        self.assertLess(np.nonzero(pe)[1].mean(), W / 3)                                        # pelouse à gauche, comme la référence
        ys, xs = np.nonzero(wk & (np.mgrid[:H, :W][0] < H - 180))
        self.assertGreater(xs.max() - xs.min(), W * 0.6); self.assertGreater(ys.max() - ys.min(), H * 0.35)

    def test_feuilles(self):
        fr = STACK['feuilles']; sand = alpha(STACK['sable'][0]); F = M['feuilles']
        self.assertEqual((PH['feuilles'], TK['feuilles']), (48, 5))
        self.assertGreaterEqual(F['nombre'], 10)
        pal = {tuple(c) for c in F['couleurs']}
        for a in fr:
            self.assertFalse((alpha(a) & ~sand).any())                                          # seulement sur le sable (vert sur vert invisible)
            self.assertTrue(colors(a) <= pal); self.assertGreater(int(alpha(a).sum()), 40)
        self.assertTrue(all((fr[t] != fr[(t + 1) % 48]).any() for t in range(48)))
        for c in pal:
            self.assertGreater(c[1] - c[0], 40)                                                 # tons de palmes
        for lf in F['placements']:                                                              # loi du manifeste
            x0, y0 = lf['depart']
            for t in range(48):
                k = (t - lf['phase']) % 48
                if k < F['chute']:
                    x = x0 + int(round(lf['sens'] * 4 * np.sin(2 * np.pi * k / 10))); y = y0 + 2 * k
                    self.assertTrue(alpha(fr[t])[y:y + 4, x:x + 6].any(), (lf, t))

    def test_papillons(self):
        fr = STACK['papillons']; P = M['papillons']
        self.assertEqual((PH['papillons'], TK['papillons']), (48, 5))
        self.assertIn('papillons_poses.png', P['origine'])
        self.assertTrue(all((fr[t] != fr[(t + 1) % 48]).any() for t in range(48)))
        for v in P['vols']:
            pts = v['positions']; self.assertEqual(len(pts), 48)
            steps = [np.hypot(pts[(t + 1) % 48][0] - pts[t][0], pts[(t + 1) % 48][1] - pts[t][1]) for t in range(48)]
            ax, ay = v['amplitude']
            self.assertLessEqual(max(steps), 2 * np.pi * (ax + 2 * ay) / 48 + 1.5)             # boucle fermée, sans saut (pas du huit)
            for t in (0, 24):
                x, y = pts[t]; self.assertTrue(alpha(fr[t])[y - 12:y + 12, x - 12:x + 12].any())

    def test_ora_et_scene(self):
        with zipfile.ZipFile(O / 'FJS1_fin_jungle_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
        sc = Image.new('RGBA', (W, H))
        for n in NAMES:
            sc.alpha_composite(Image.fromarray(STACK[n][0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/FJS1_scene_t000.png')).all())
        for k in ANIM:
            self.assertEqual(M['scene_loop_ticks'] % (PH[k] * TK[k]), 0, k)
        self.assertEqual(M['scene_loop_ticks'], 240)

    def test_acces_fin_de_donjon(self):
        a = M['access']; mk = a['markers']
        self.assertTrue(a['chemins_16x16']['boss']['ok']); self.assertTrue(a['chemins_16x16']['objectif']['ok'])
        self.assertGreater(mk['entrance'][1], H - 40)
        self.assertTrue(H // 3 < mk['boss'][1] < 3 * H // 4)
        ry, rx = np.nonzero(alpha(STACK['rocher'][0]))
        self.assertLess(mk['objectif'][1], mk['boss'][1])
        self.assertLess(abs(mk['objectif'][1] - ry.max()), 24); self.assertLess(abs(mk['objectif'][0] + 8 - rx.mean()), 24)
        wk = walk(); self.assertFalse((alpha(STACK['rocher'][0]) & wk).any())                  # le rocher bloque
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
        self.assertEqual({m['EntName'] for m in o['Entities'][0]['Markers']}, {'entrance', 'boss', 'objectif'})
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))
        self.assertNotIn('warp', (S / f"Data/Script/{M['pmdo']['namespace']}/ground/{M['pmdo']['asset']}/init.lua").read_text().replace('aucun warp', ''))


if __name__ == '__main__':
    unittest.main()
