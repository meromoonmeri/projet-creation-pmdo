"""Tests dédiés — Entrée Couloir violet sud -> nord V1 (ECV1, 4:3 vaste).
.venv/bin/python -m unittest source.entree_couloir_violet_sud_nord_v1.test_build -v
Contrôles d'images, de formats, de palettes, de fidélité au rip, de cadence et de grille : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, re, unittest, zipfile
import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/entree_couloir_violet_sud_nord_v1'
S = R / '.cache/entree_couloir_violet_sud_nord_v1/entree_couloir_violet_sud_nord'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
NAMES = [Path(L['file']).name.replace('_fNN', '') for L in M['layers']]
STATIC = ('sol', 'ombres', 'gravillons', 'blocs', 'rochers', 'falaise', 'vide', 'profondeur')
REF = R / 'large.S05P03A.png.301f7a1eadda348357be0801e81faa2a.png'


def load(p):
    return np.array(Image.open(p).convert('RGBA'))


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


def expand(L):
    if L['phases'] == 1:
        return [load(O / L['file'])]
    return [load(O / L['file'].replace('fNN', f'f{t:02d}')) for t in range(L['phases'])]


STACK = [expand(L) for L in M['layers']]
BY = {re.sub(r'^ECV1_\d\d_', '', Path(n).stem): fr for n, fr in zip(NAMES, STACK)}
ORDER = list(BY)
MASK = {k: np.array(Image.open(O / f'masques/ECV1_masque_{k}.png')) > 0 for k in (*STATIC, 'praticable')}
B = loadmod('ecv1_build', HERE / 'build.py')


def alpha(a):
    return a[..., 3] == 255


def colors(frames):
    return {tuple(int(v) for v in c) for a in frames for c in np.unique(a[a[..., 3] > 0][:, :3], axis=0)}


def rip_colors():
    a = np.array(Image.open(REF).convert('RGB'))
    return {tuple(int(v) for v in c) for c in np.unique(a.reshape(-1, 3), axis=0)}


def lum(px):
    return px[..., :3].astype(float) @ [.299, .587, .114]


def pebbles():
    return {k: load(O / f'poses/ECV1_gravillon_{k}.png') for k in M['eboulis']['gravillons_rip']}


def puffs():
    return [load(O / f'poses/ECV1_poussiere_{i}.png') for i in range(len(M['poussiere']['fenetres']))]


class Build(unittest.TestCase):
    def test_raw_hashes_and_reference(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        ref = M['reference_da']
        self.assertEqual(ref['file'], REF.name)
        self.assertEqual(hashlib.sha256(REF.read_bytes()).hexdigest(), ref['sha256'])
        g = M['generation']
        self.assertEqual([x['file'] for x in g], ['decor.png', 'sol_complet.png', 'poussiere_poses.png'])
        self.assertTrue(all(x['images'] == [REF.name] and len(x['prompt']) > 100 for x in g))   # rip en référence
        self.assertIn('choisi par l agent', M['biome'])
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_sizes_names_alpha_no_magenta(self):
        self.assertEqual(len(NAMES), len(set(NAMES))); self.assertTrue(all(n.startswith('ECV1_') for n in NAMES))
        self.assertEqual((W, H, W % 8, H % 8), (768, 576, 0, 0)); self.assertEqual(W * 3, H * 4)   # 4:3
        n = M['normalization']; self.assertAlmostEqual(n['scale'], 576 / 896)
        self.assertEqual(n['scaled'][0] - sum(n['crop_x']), W)
        for name, frames in BY.items():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W))
                self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255}, name)
                v = a[a[..., 3] > 0].astype(int)
                bad = (v[:, 0] - v[:, 1] > 60) & (v[:, 2] - v[:, 1] > 60)
                self.assertEqual(int(bad.sum()), 0, name)

    def test_multicalque_full_coverage_and_order(self):
        self.assertEqual(ORDER, ['sol_complet', *STATIC, 'eboulis', 'poussiere'])
        self.assertTrue(alpha(BY['sol_complet'][0]).all())
        fixed = [alpha(BY[k][0]) for k in STATIC]
        self.assertTrue((np.sum(fixed, 0) == 1).all())                      # calques fixes : partition exacte
        for k in STATIC:
            self.assertGreater(int(alpha(BY[k][0]).sum()), 500, k)
            self.assertTrue((alpha(BY[k][0]) == MASK[k]).all(), k)
        sol = BY['sol_complet'][0][..., :3].astype(float).reshape(-1, 3)
        self.assertGreater(len(colors(BY['sol_complet'])), 12)              # texture, pas un aplat
        self.assertGreater(sol.mean(0)[0], sol.mean(0)[1] + 8)              # mauve (r > g)

    def test_palettes_et_matieres(self):
        for g, v in M['normalization']['palettes'].items():
            self.assertLessEqual(len(colors([BY[k][0] for k in v['calques']])), v['couleurs'], g)
        L = lambda k: BY[k][0][alpha(BY[k][0])][:, :3].astype(int)
        self.assertLess(float(np.median(lum(L('profondeur')))), 40)          # tunnel sombre
        self.assertLess(float(np.median(lum(L('vide')))), 30)
        s = L('sol'); self.assertGreater(float((s[:, 0] > s[:, 1] + 4).mean()), 0.8)          # sol mauve
        for k in ('rochers', 'blocs', 'falaise'):
            p = L(k).mean(0); self.assertGreater(p[2], p[0] + 25, k); self.assertLess(abs(p[0] - p[1]), 12, k)   # bleu-violet
        lab, n = nd.label(MASK['blocs']); self.assertGreaterEqual(n, 6)
        lab, n = nd.label(MASK['gravillons']); self.assertGreaterEqual(n, 15)
        # Blocs et gravillons posés dans le sol (entourés de sol / ombres) ; rochers autour du tunnel.
        floor = MASK['sol'] | MASK['ombres']
        ring = nd.binary_dilation(MASK['blocs'], iterations=2) & ~MASK['blocs']
        self.assertGreater(float(floor[ring].mean()), 0.9)
        self.assertTrue((nd.binary_dilation(MASK['profondeur'], iterations=3) & MASK['rochers']).any())
        ys, _ = np.nonzero(MASK['falaise']); self.assertLess(float(np.median(ys)), H * 0.35)   # falaise au fond

    def test_ombres_et_sol_jusqu_au_tunnel(self):
        L = lambda k: lum(BY[k][0][alpha(BY[k][0])])
        self.assertLess(L('ombres').mean(), L('sol').mean() - 15)             # sol assombri
        o = BY['ombres'][0][alpha(BY['ombres'][0])][:, :3].astype(int)
        self.assertGreater(float((o[:, 0] >= o[:, 1]).mean()), 0.8)          # reste du sol mauve
        base = nd.distance_transform_edt(~(MASK['rochers'] | MASK['blocs'] | MASK['gravillons'] | MASK['falaise']
                                           | MASK['vide'] | MASK['profondeur']))
        self.assertLessEqual(float(base[MASK['ombres']].max()), 30 * 576 / 896 + 3)   # au pied des parois seulement
        # Sol continu du tunnel vers le sud.
        ys, xs = np.nonzero(MASK['profondeur']); x0, x1 = xs.min(), xs.max(); yb = ys.max()
        col = MASK['praticable'][yb + 1:yb + 40, (x0 + x1) // 2 - 8:(x0 + x1) // 2 + 8]
        self.assertGreater(float(col.mean()), 0.9)

    def test_fidelite_rip(self):
        dec, ref = B.rgb(HERE / 'bruts/decor.png'), B.rgb(REF)
        fid = B.fidelity(dec, ref)
        for k, v in fid.items():
            self.assertLess(v['distance'], 35, (k, v))
            self.assertAlmostEqual(v['distance'], M['fidelite_rip']['brut'][k]['distance'], places=1)
        for nm, v in M['fidelite_rip']['calques_finaux'].items():
            lay = BY[nm][0]; px = lay[alpha(lay)][:, :3].astype(float)
            sel = B.materials(px.reshape(-1, 1, 3))[v['matiere']][:, 0]
            self.assertGreater(int(sel.sum()), 50, nm)                     # la matière est bien présente
            d = float(np.linalg.norm(px[sel].mean(0) - np.array(fid[v['matiere']]['rip_rgb'])))
            self.assertLess(d, 35, (nm, d)); self.assertAlmostEqual(d, v['distance_rip'], places=1)
        f = B.rgb(HERE / 'bruts/sol_complet.png').reshape(-1, 3).mean(0)
        self.assertLess(float(np.linalg.norm(f - np.array(fid['sol']['rip_rgb']))), 35)

    def test_eboulis_gravillons_exacts_boucle_fermee(self):
        E = M['eboulis']; fr = BY['eboulis']; ps = pebbles(); ref = B.rgb(REF)
        self.assertEqual((len(fr), E['frame_length_ticks']), (24, 5))
        for k, (y, x, h, w) in E['gravillons_rip'].items():                 # pixels EXACTS du rip
            p = ps[k]; self.assertEqual(p.shape[:2], (h, w))
            self.assertTrue((p[alpha(p)][:, :3] == ref[y:y + h, x:x + w][alpha(p)]).all(), k)
            self.assertGreater(int(alpha(p).sum()), 15, k)
        self.assertTrue(colors(fr) <= rip_colors())                         # couleurs EXACTES du rip
        spots = [tuple(s) for s in E['chutes']]; self.assertEqual(len(spots), 4)
        calc_p, calc_d = B.anim_frames(ps, puffs(), spots)
        for t in range(24):
            self.assertTrue((fr[t] == calc_p[t]).all(), t); self.assertTrue((BY['poussiere'][t] == calc_d[t]).all(), t)
        p24, d24 = B.anim_frames(ps, puffs(), spots, ts=[24])
        self.assertTrue((p24[0] == fr[0]).all()); self.assertTrue((d24[0] == BY['poussiere'][0]).all())   # 24 = 0
        floor = MASK['sol'] | MASK['ombres']; wall = MASK['rochers'] | MASK['blocs']
        for x, y, name, off, sens in spots:
            self.assertTrue(floor[y, x] and wall[y - 8, x] and wall[y - 20, x])   # au pied d'une paroi
            # Trajet continu : chute accélérée (pas croissants, <= 9 px), roulement <= 1 px / phase, repos au sol.
            st = [B.pebble_state(u, sens) for u in range(24)]
            vis = [s for s in st if s]; self.assertEqual(len(vis), E['visible_phases'])
            self.assertTrue(all(abs(vis[i + 1][1] - vis[i][1]) <= 9 and abs(vis[i + 1][0] - vis[i][0]) <= 1
                                for i in range(len(vis) - 1)))
            steps = np.diff(E['chute_dy']); self.assertTrue((steps > 0).all() and (np.diff(steps) > 0).all())
            self.assertEqual(vis[-1][1], 0)
            self.assertIsNone(st[23]); self.assertEqual(st[0][1], E['chute_dy'][0])   # 23 absent -> 0 recommence
        dm = nd.distance_transform_edt(~MASK['profondeur'])
        for a in fr + BY['poussiere']:
            self.assertFalse((alpha(a) & (dm < 8)).any())                  # rien sur le tunnel
        n_vis = [int(alpha(a).sum() > 0) for a in fr]; self.assertTrue(all(n_vis))   # toujours un gravillon en scène

    def test_poussiere_poses(self):
        P = M['poussiere']; ps = puffs(); fr = BY['poussiere']
        self.assertEqual(len(ps), 4); self.assertLessEqual(len(colors(fr)), 6)
        widths = [p.shape[1] for p in ps]; self.assertTrue(8 <= widths[0] < widths[1])   # nuage qui grossit
        self.assertTrue(all(w <= 28 for w in widths))
        for p in ps[:3]:                                                    # nuages pleins : une tache principale
            lab, n = nd.label(alpha(p), structure=np.ones((3, 3))); sz = nd.sum(alpha(p), lab, range(1, n + 1))
            self.assertGreater(float(sz.max() / sz.sum()), 0.8)
        for p in ps:
            v = p[alpha(p)][:, :3].astype(int); self.assertTrue(((v[:, 2] - v[:, 0]) < 40).all())   # pas de rocher bleu
        busy = [t for t, a in enumerate(fr) if alpha(a).any()]
        self.assertEqual(len(busy), 16)                                     # 4 chutes x 4 phases, sans recouvrement

    def test_ora_and_scene(self):
        with zipfile.ZipFile(O / 'ECV1_entree_couloir_violet_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
            self.assertIn(b'Couloir violet', z.read('stack.xml'))
        sc = Image.new('RGBA', (W, H))
        for frames in STACK:
            sc.alpha_composite(Image.fromarray(frames[0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/ECV1_scene_t000.png')).all())
        for L in M['layers']:
            self.assertEqual(M['scene_loop_ticks'] % (L['phases'] * L['ticks']) if L['phases'] > 1 else 0, 0)

    def test_access(self):
        a = M['access']; self.assertTrue(a['path_found_16x16'])
        ex, ey = a['entry_px']; tx, ty = a['threshold_px']
        self.assertGreater(ey, H - 64); self.assertLess(ty, H // 3)
        self.assertTrue(MASK['praticable'][ey:ey + 16, ex:ex + 16].mean() > 0.9)     # arrivée dans le couloir sud
        dp = nd.distance_transform_edt(~MASK['profondeur'])
        self.assertLess(float(dp[ty:ty + 16, tx:tx + 16].min()), 8)                # seuil au ras du tunnel
        self.assertEqual(a['walkable_cells'] + a['blocked_cells'], (W // 8) * (H // 8))
        self.assertGreater(a['walkable_cells'], 1500)
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text())
        blocked = np.array([[c['Tags'] for c in col] for col in doc['Object']['obstacles']]).T.astype(bool)
        for k in ('profondeur', 'blocs', 'rochers', 'falaise', 'vide'):
            cells = MASK[k].reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > 0.5
            self.assertTrue(blocked[cells].all(), k)
        cells = MASK['praticable'].reshape(H // 8, 8, W // 8, 8).mean((1, 3)) == 1
        self.assertFalse(blocked[cells].any())
        self.assertFalse((MASK['praticable'] & (MASK['rochers'] | MASK['blocs'] | MASK['vide'])).any())

    def test_prefix_and_namespace_unique(self):
        for p in (R / 'source').glob('*/build.py'):
            if p.parent != HERE:
                s = p.read_text(errors='ignore')
                self.assertNotIn("PFX = 'ECV1'", s, p); self.assertNotIn("'entree_couloir_violet_sud_nord'", s, p)

    def test_ground_roundtrip(self):
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text()); o = doc['Object']
        self.assertEqual(doc['Version'], '0.8.12.0'); self.assertEqual(len(o['Layers']), len(STACK) + 1)
        self.assertEqual(o['Layers'][-1]['Layer'], 4)
        nr = loadmod('native_reader', R / 'source/cote_v5_expeditions/audit_references.py')
        banks = {p.stem: nr.tiles(p)[1] for p in (S / 'Content/Tile').glob('*.tile')}
        self.assertEqual(set(banks), set(M['pmdo']['banks']))
        for li, (frames, L) in enumerate(zip(STACK, M['layers'])):
            for t in sorted({0, len(frames) // 2, len(frames) - 1}):
                out = np.zeros((H, W, 4), 'uint8')
                for x, col in enumerate(o['Layers'][li]['Tiles']):
                    for y, cell in enumerate(col):
                        for track in cell['Layers']:
                            if len(track['Frames']) > 1:
                                self.assertEqual((len(track['Frames']), track['FrameLength']), (len(frames), L['ticks']))
                            f = track['Frames'][t % len(track['Frames'])]
                            out[y*8:y*8+8, x*8:x*8+8] = np.array(nr.straight(banks[f['Sheet']][f['TexLoc']['X'], f['TexLoc']['Y']]))
                self.assertTrue((out == frames[t]).all(), (li, t))
        self.assertEqual(sum(w['Tags'] for c in o['obstacles'] for w in c), M['access']['blocked_cells'])
        self.assertEqual({m['EntName'] for m in o['Entities'][0]['Markers']}, {'entrance', 'donjon_seuil'})
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))


if __name__ == '__main__':
    unittest.main()
