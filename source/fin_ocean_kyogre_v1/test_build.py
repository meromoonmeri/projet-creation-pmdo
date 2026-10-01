"""Tests dédiés — Fin Océan (FOC1), arène de Kyogre sous la mer, 4:3.
.venv/bin/python -m unittest source.fin_ocean_kyogre_v1.test_build -v
Contrôles d'images, de formats, de cadence, de boucles, de grille et d'accès : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, unittest, zipfile
import numpy as np
from scipy import ndimage
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_ocean_kyogre_v1'
S = R / '.cache/fin_ocean_kyogre_v1/fin_ocean_kyogre'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
ANIM = ('abysse', 'nuances_eau', 'motifs_lumineux', 'algues', 'bulles', 'scintillements')
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


def mask(k):
    return np.array(Image.open(O / f'masques/FOC1_masque_{k}.png')) > 0


def lum(a):
    return a[..., :3].astype(float) @ [.299, .587, .114]


class Build(unittest.TestCase):
    def test_bruts_et_reference(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
            self.assertTrue(r['utilise'])
            for im in r['images']:
                self.assertTrue((R / im).exists(), im)
        ref = M['reference_da']
        self.assertEqual(ref['code'], 'D42P41A')
        self.assertEqual(hashlib.sha256((R / ref['fichier']).read_bytes()).hexdigest(), ref['sha256'])
        idx = {m['code']: m for m in json.loads((R / 'source/outil_maps_pmdsky/index_rom.json').read_text())['maps']}
        self.assertEqual(idx['D42P41A']['taille_px'], [504, 504])
        with Image.open(R / ref['fichier']) as im:
            self.assertEqual(im.size, (504, 504))
        f = M['fidelite']; self.assertEqual(f['seuil'], 35)
        for k in ('sol', 'sol_complet', 'parois'):
            self.assertLess(f[k]['distance'], 35, k)
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_calques_ordre_tailles_alpha(self):
        self.assertEqual(NAMES, ['sol_complet', 'abysse', 'sol', 'nuances_eau', 'motifs_lumineux', 'parois', 'coraux', 'algues',
                                 'bulles', 'scintillements'])
        files = [Path(p).name for p in ORDER]
        self.assertTrue(all(n.startswith('FOC1_') for n in files)); self.assertEqual(len(files), len(set(files)))
        self.assertEqual((W, H, W * 3), (768, 576, H * 4))
        for frames in STACK.values():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W)); self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255})
        self.assertTrue(alpha(STACK['sol_complet'][0]).all())
        st = sum(mask(k).astype(int) for k in ('trench', 'floor', 'weed', 'coral', 'walls'))
        self.assertEqual((int(st.min()), int(st.max())), (1, 1))                                 # partition exacte
        self.assertTrue((alpha(STACK['sol'][0]) == mask('floor')).all())
        self.assertTrue((alpha(STACK['coraux'][0]) == mask('coral')).all())
        self.assertTrue((alpha(STACK['parois'][0]) == (mask('walls') | mask('weed'))).all())    # paroi remplie sous les algues

    def test_abysse_tourbillon(self):
        fr = STACK['abysse']; A = M['abysse']; tr = mask('trench'); tones = {tuple(c) for c in A['tons']}
        self.assertEqual((PH['abysse'], TK['abysse']), (24, 10))
        ys, xs = np.nonzero(tr)
        self.assertLess(ys.max(), H * 0.4); self.assertLess(abs(xs.mean() - W / 2), 40)            # fosse au nord, dans l'axe
        for a in fr:
            self.assertTrue((alpha(a) == tr).all())
            self.assertTrue({tuple(int(v) for v in c) for c in np.unique(a[tr][:, :3], axis=0)} <= tones)
        d = [float((fr[t][tr] != fr[(t + 1) % 24][tr]).any(-1).mean()) for t in range(24)]
        self.assertGreater(min(d), 0.05); self.assertLess(max(d) / min(d), 1.6)                   # rotation régulière, raccord compris
        self.assertLess(float(lum(fr[0])[tr].mean()), 70)                                          # abysse sombre
        B = loadmod('foc1_b', HERE / 'build.py')
        self.assertTrue(all((B.abyss_frames(tr)[0][t] == fr[t]).all() for t in (0, 13)))          # loi du manifeste

    def test_nuances_eau(self):
        fr = STACK['nuances_eau']; fl = mask('floor'); sol = STACK['sol'][0]
        self.assertEqual((PH['nuances_eau'], TK['nuances_eau']), (16, 15))
        for a in fr:
            self.assertFalse((alpha(a) & ~fl).any())
            on = alpha(a); self.assertTrue(0.08 < on[fl].mean() < 0.6)
            dl = lum(a)[on] - lum(sol)[on]
            self.assertTrue((np.abs(dl) > 0).all()); self.assertLess(float(np.abs(dl).max()), 60)   # nuances, pas d'aplats
            self.assertGreater((dl < 0).sum(), 1000); self.assertGreater((dl > 12).sum(), 3000)
        d = [float((alpha(fr[t]) != alpha(fr[(t + 1) % 16]))[fl].mean()) for t in range(16)]
        self.assertGreater(min(d), 0.02); self.assertLess(max(d) / min(d), 1.8)
        B = loadmod('foc1_b2', HERE / 'build.py')
        lf = B.light_frames(sol, fl, np.random.default_rng(M['nuances_eau']['graine']))
        self.assertTrue((lf[0] == fr[0]).all() and (lf[9] == fr[9]).all())

    def test_motifs_sur_toute_la_zone(self):
        fr = STACK['motifs_lumineux']; G = M['motifs_lumineux']; fl = mask('floor')
        self.assertEqual((PH['motifs_lumineux'], TK['motifs_lumineux']), (24, 10))
        glow = {tuple(c) for c in G['rampe']}
        union = np.zeros((H, W), bool)
        for a in fr:
            self.assertFalse((alpha(a) & ~fl).any())
            self.assertTrue({tuple(int(v) for v in c) for c in np.unique(a[alpha(a)][:, :3], axis=0)} <= glow)
            union |= alpha(a)
            self.assertGreater(int(alpha(a).sum()), 1500)                                           # chaque phase éclaire des gravures
        self.assertEqual(int(union.sum()), G['pixels_graves'])                                      # chaque gravure s'allume
        ys, xs = np.nonzero(union)
        self.assertGreater(xs.max() - xs.min(), W * 0.6); self.assertGreater(ys.max() - ys.min(), H * 0.45)   # toute la zone
        cx, cy = G['centre_sceau']
        mean_r = []
        for a in fr[1:20]:
            y, x = np.nonzero(np.all(a[..., :3] == G['rampe'][3], -1) & ~(np.hypot(*np.mgrid[:H, :W][::-1] - np.array([cx, cy])[:, None, None]) < 100))
            if len(y):
                mean_r.append(float(np.hypot(x - cx, y - cy).mean()))
        self.assertTrue(all(mean_r[i] < mean_r[i + 1] for i in range(len(mean_r) - 1)))             # l'onde s'éloigne du sceau
        self.assertGreater(G['pixels_sceau'], 1500)
        self.assertGreater(int(alpha(fr[0]).sum()), int(alpha(fr[12]).sum()) * 0.3)

    def test_algues_ondulent_base_fixe(self):
        fr = STACK['algues']; A = M['algues']
        self.assertEqual((PH['algues'], TK['algues']), (12, 20)); self.assertGreaterEqual(len(A['touffes']), 15)
        wd = mask('weed')
        for a in fr:
            self.assertFalse((alpha(a) & ~ndimage.binary_dilation(wd, structure=np.ones((1, 7)))).any())
        for tf in A['touffes']:
            x, y = tf['base']
            rows = [a[y, max(0, x - 6):x + 7, 3].tobytes() for a in fr]
            self.assertEqual(len(set(rows)), 1, tf)                                                  # la base ne bouge pas
        self.assertTrue(all((fr[t] != fr[(t + 1) % 12]).any() for t in range(12)))
        self.assertTrue((fr[0] != fr[6]).any())

    def test_bulles(self):
        fr = STACK['bulles']; B_ = M['bulles']
        self.assertEqual((PH['bulles'], TK['bulles']), (48, 5)); self.assertGreaterEqual(B_['nombre'], 50)
        self.assertEqual(B_['sources'][0]['nom'], 'abysse')
        cols = {tuple(B_['couleurs'][k]) for k in ('bord', 'reflet', 'interieur')}
        tr = ndimage.binary_dilation(mask('trench'), iterations=30)
        for a in fr:
            self.assertTrue({tuple(int(v) for v in c) for c in np.unique(a[alpha(a)][:, :3], axis=0)} <= cols)
            self.assertGreater(int((alpha(a) & tr).sum()), 20)                                        # bulles de l'abysse à chaque phase
        self.assertTrue(all((fr[t] != fr[(t + 1) % 48]).any() for t in range(48)))
        self.assertGreater(len({k for k in range(48) if (alpha(fr[k]) & ~tr).any()}), 40)             # évents et algues

    def test_scintillements(self):
        fr = STACK['scintillements']; S_ = M['scintillements']
        self.assertEqual((PH['scintillements'], TK['scintillements']), (12, 5))
        self.assertGreaterEqual(len(S_['etoiles']), 60); self.assertGreaterEqual(len({tuple(s['teinte']) for s in S_['etoiles']}), 4)
        tr = mask('trench')
        for s in S_['etoiles']:
            x, y = s['xy']; self.assertFalse(tr[y, x])
            on = [tuple(fr[t][y, x]) == (255, 255, 255, 255) for t in range(12)]
            self.assertEqual(on, [bool(S_['bras'][(t - s['phase']) % 12]) for t in range(12)])
        xy = np.array([s['xy'] for s in S_['etoiles']])
        dmin = min(np.abs(xy[i] - xy[j]).max() for i in range(len(xy)) for j in range(i))
        self.assertGreaterEqual(int(dmin), 7)

    def test_arene_fermee_ouverte_au_sud(self):
        wk = mask('floor')
        self.assertFalse(wk[:16].any() or wk[:, :16].any() or wk[:, -16:].any())
        self.assertTrue(wk[-8:].any())
        xs = np.nonzero(wk[-4])[0]; self.assertLess(abs(xs.mean() - W / 2), 40)
        self.assertEqual(ndimage.label(wk)[1], 1)
        self.assertFalse((wk & ndimage.binary_dilation(mask('trench'), iterations=6)).any())         # corniches non praticables
        ys, xs = np.nonzero(wk & (np.mgrid[:H, :W][0] < H - 150))
        self.assertGreater(xs.max() - xs.min(), W * 0.6); self.assertGreater(ys.max() - ys.min(), H * 0.4)

    def test_ora_et_scene(self):
        with zipfile.ZipFile(O / 'FOC1_fin_ocean_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
        sc = Image.new('RGBA', (W, H))
        for n in NAMES:
            sc.alpha_composite(Image.fromarray(STACK[n][0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/FOC1_scene_t000.png')).all())
        for k in ANIM:
            self.assertEqual(M['scene_loop_ticks'] % (PH[k] * TK[k]), 0, k)
        self.assertEqual(M['scene_loop_ticks'], 240)

    def test_acces_marqueurs(self):
        a = M['access']; mk = a['markers']
        self.assertTrue(a['chemins_16x16']['sceau']['ok']); self.assertTrue(a['chemins_16x16']['kyogre']['ok'])
        self.assertGreater(mk['entrance'][1], H - 40)
        cx, cy = M['motifs_lumineux']['centre_sceau']
        self.assertLess(np.hypot(mk['sceau'][0] + 8 - cx, mk['sceau'][1] + 8 - cy), 16)
        ty, tx = np.nonzero(mask('trench'))
        self.assertLess(abs(mk['kyogre'][0] + 8 - tx.mean()), 20); self.assertLess(mk['kyogre'][1], cy - 60)
        self.assertLess(mk['kyogre'][1] - ty.max(), 48)
        wk = mask('floor')
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
        self.assertEqual({m['EntName'] for m in o['Entities'][0]['Markers']}, {'entrance', 'kyogre', 'sceau'})
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))
        self.assertNotIn('warp', (S / f"Data/Script/{M['pmdo']['namespace']}/ground/{M['pmdo']['asset']}/init.lua").read_text().replace('aucun warp', ''))


if __name__ == '__main__':
    unittest.main()
