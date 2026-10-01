"""Tests dédiés — Fin Waterfall Cave (FWC1), salle du joyau, 4:3.
.venv/bin/python -m unittest source.fin_waterfall_cave_v1.test_build -v
Contrôles d'images, de formats, de cadence, de grille et d'accès : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, unittest, zipfile
import numpy as np
from scipy import ndimage
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_waterfall_cave_v1'
S = R / '.cache/fin_waterfall_cave_v1/fin_waterfall_cave'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
ANIM = ('eau', 'lueur_joyau', 'scintillements')
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
    return np.array(Image.open(O / 'masques/FWC1_masque_praticable.png')) > 0


class Build(unittest.TestCase):
    def test_bruts_references(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        ref = {r['file'].split('/')[-1]: r for r in M['raw_inputs']}
        self.assertEqual(ref['decor_magenta.png']['images'], ['Waterfall_Cave_gem_TDS.png']); self.assertFalse(ref['decor_magenta.png']['utilise'])
        self.assertEqual(ref['decor_magenta_v2.png']['images'], ['source/fin_waterfall_cave_v1/bruts/decor_magenta.png'])
        self.assertEqual(ref['sol_complet.png']['images'], ['Waterfall_Cave_gem_TDS.png decoupe [225, 270, 275, 300] x4'])
        with Image.open(R / 'Waterfall_Cave_gem_TDS.png') as im:
            self.assertEqual(im.size, (504, 432))
        f = M['fidelite']; self.assertEqual((f['seuil'], f['seuil_eau']), (35, 15))
        for k in ('galets', 'chemin', 'sol_complet'):
            self.assertLess(f[k]['distance'], 35, k)
        self.assertLess(f['eau']['distance'], 15); self.assertGreater(f['eau']['part_tons_capture'], 0.9)
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])
        self.assertIn('aucun', M['choix_agent']['boss'])

    def test_calques_ordre_tailles_alpha(self):
        self.assertEqual(NAMES, ['sol_complet', 'eau', 'sol', 'parois', 'cristaux', 'joyau', 'lueur_joyau', 'scintillements'])
        files = [Path(p).name for p in ORDER]
        self.assertTrue(all(n.startswith('FWC1_') for n in files)); self.assertEqual(len(files), len(set(files)))
        self.assertEqual((W, H, W * 3), (768, 576, H * 4))
        for frames in STACK.values():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W)); self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255})
        self.assertTrue(alpha(STACK['sol_complet'][0]).all())
        st = sum(alpha(STACK[n][0]).astype(int) for n in ('eau', 'sol', 'parois', 'cristaux', 'joyau'))
        self.assertEqual(int(st.min()), 1); self.assertEqual(int(st.max()), 1)                  # partition exacte
        for a in STACK['eau']:
            self.assertTrue((alpha(a) == alpha(STACK['eau'][0])).all())                         # même surface à chaque phase
        for n in ('lueur_joyau',):
            for a in STACK[n]:
                self.assertFalse((alpha(a) & ~alpha(STACK['joyau'][0])).any())

    def test_eau_reseau_de_reflets(self):
        fr = STACK['eau']; E = M['eau']; pal = {tuple(c) for c in E['palette']}
        self.assertEqual((PH['eau'], TK['eau']), (24, 10)); self.assertEqual(len(pal), 9)
        for a in fr:
            self.assertTrue(colors(a) <= pal)
        wm = alpha(fr[0]); lum = lambda a: a[..., :3].astype(float) @ [.299, .587, .114]
        x0, y0, x1, y1 = M['fidelite']['eau']['decoupe_ref']
        rip = np.array(Image.open(R / 'Waterfall_Cave_gem_TDS.png').convert('RGB')).astype(int)[y0:y1, x0:x1].reshape(-1, 3)
        rip = rip[(np.abs(rip[:, None] - np.array(sorted(pal))[None]).sum(-1) == 0).any(1)]
        lr = rip @ [.299, .587, .114]
        for th in (80, 100):                                                                    # part de traits clairs comme la capture
            self.assertLess(abs(float((lum(fr[0])[wm] > th).mean()) - float((lr > th).mean())), 0.05, th)
        light = (lum(fr[0]) > 100) & wm
        d = [float((fr[t][wm] != fr[(t + 1) % 24][wm]).any(-1).mean()) for t in range(24)]
        self.assertTrue(min(d) > 0.005); self.assertLess(max(d) / min(d), 1.4)                  # mouvement régulier, raccord 23 -> 0 compris
        dd = [float((fr[0][wm] != fr[t][wm]).any(-1).mean()) for t in range(1, 13)]
        self.assertTrue(all(dd[i] <= dd[i + 1] + 0.02 for i in range(11)))                      # s'écarte puis revient : pas de défilement
        # aucun liseré clair sur les rives : les tons clairs du bord suivent la même proportion qu'au large
        edge = wm & ndimage.binary_dilation(~wm, iterations=2)
        self.assertLess(light[edge].mean(), light[wm].mean() * 1.5)
        B = loadmod('fwc1_build', HERE / 'build.py')
        rng = np.random.default_rng(E['graine']); sites = B.water_sites(rng); noise = B.water_noise(rng)
        for t in (0, 7):
            self.assertTrue((B.water_frame(t, sites, noise, wm) == fr[t]).all(), t)             # loi du manifeste

    def test_joyau(self):
        fr = STACK['lueur_joyau']; G = M['lueur_joyau']
        self.assertEqual((PH['lueur_joyau'], TK['lueur_joyau']), (24, 10))
        self.assertEqual(G['pulsation'], [int(round(1 - np.cos(2 * np.pi * t / 24))) for t in range(24)])
        lum = [float(a[alpha(a)][:, :3].astype(float).mean()) for a in fr]
        self.assertTrue(all(lum[t] <= lum[t + 1] + 0.01 for t in range(12)))                   # monte jusqu'à la moitié
        self.assertTrue(all(lum[t] >= lum[t + 1] - 0.01 for t in range(12, 23)))
        self.assertGreater(lum[12] - lum[0], 15); self.assertTrue((fr[0] == fr[0]).all())
        jy = STACK['joyau'][0][alpha(STACK['joyau'][0])][:, :3].astype(float).mean(0)
        self.assertGreater(jy[0] - jy[1], 50)                                                   # rose
        self.assertGreater(int(alpha(fr[0]).sum()), 800)

    def test_scintillements(self):
        fr = STACK['scintillements']; S_ = M['scintillements']
        self.assertEqual((PH['scintillements'], TK['scintillements']), (12, 5))
        self.assertGreaterEqual(len(S_['etoiles']), 20)
        cr = alpha(STACK['cristaux'][0])
        for s in S_['etoiles']:
            x, y = s['xy']; self.assertTrue(cr[y, x])
            on = [bool(fr[t][y, x, 3]) for t in range(12)]
            self.assertEqual(on, [bool(S_['bras'][(t - s['phase']) % 12]) for t in range(12)])
        self.assertTrue(all((fr[t] != fr[(t + 1) % 12]).any() for t in range(12)))

    def test_salle_fermee_ouverte_au_sud(self):
        wk = walk()
        self.assertFalse(wk[:16].any() or wk[:, :16].any() or wk[:, -16:].any())
        self.assertTrue(wk[-8:].any())
        xs = np.nonzero(wk[-4])[0]; self.assertLess(abs(xs.mean() - W / 2), 40)
        lab, n = ndimage.label(wk); self.assertEqual(n, 1)
        self.assertFalse((wk & alpha(STACK['eau'][0])).any()); self.assertFalse((wk & alpha(STACK['joyau'][0])).any())
        eau = alpha(STACK['eau'][0]); xs = np.nonzero(eau)[1]
        self.assertGreater((xs < W / 3).sum(), 15000); self.assertGreater((xs > 2 * W / 3).sum(), 15000)   # deux bassins
        ys, xs = np.nonzero(wk & (np.mgrid[:H, :W][0] < H - 180))
        self.assertGreater(xs.max() - xs.min(), W * 0.3); self.assertGreater(ys.max() - ys.min(), H * 0.3)

    def test_ora_et_scene(self):
        with zipfile.ZipFile(O / 'FWC1_fin_waterfall_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
        sc = Image.new('RGBA', (W, H))
        for n in NAMES:
            sc.alpha_composite(Image.fromarray(STACK[n][0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/FWC1_scene_t000.png')).all())
        for k in ANIM:
            self.assertEqual(M['scene_loop_ticks'] % (PH[k] * TK[k]), 0, k)
        self.assertEqual(M['scene_loop_ticks'], 240)

    def test_acces_fin_de_donjon(self):
        a = M['access']; mk = a['markers']
        self.assertTrue(a['chemins_16x16']['arene']['ok']); self.assertTrue(a['chemins_16x16']['joyau']['ok'])
        self.assertGreater(mk['entrance'][1], H - 40)
        self.assertTrue(H // 3 < mk['arene'][1] < 3 * H // 4)
        gy, gx = np.nonzero(alpha(STACK['joyau'][0]))
        self.assertLess(mk['joyau'][1], mk['arene'][1])
        self.assertLess(abs(mk['joyau'][1] - gy.max()), 24); self.assertLess(abs(mk['joyau'][0] + 8 - gx.mean()), 24)
        wk = walk()
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
        self.assertEqual({m['EntName'] for m in o['Entities'][0]['Markers']}, {'entrance', 'arene', 'joyau'})
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))
        self.assertNotIn('warp', (S / f"Data/Script/{M['pmdo']['namespace']}/ground/{M['pmdo']['asset']}/init.lua").read_text().replace('aucun warp', ''))


if __name__ == '__main__':
    unittest.main()
