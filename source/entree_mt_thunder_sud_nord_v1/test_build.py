"""Tests dédiés — Entrée Mt. Thunder sud -> nord V1 (EMT1, 4:3 vaste).
.venv/bin/python -m unittest source.entree_mt_thunder_sud_nord_v1.test_build -v
Contrôles d'images, de formats, de palettes, de fidélité au rip, de cadence et de grille : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, re, unittest, zipfile
import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/entree_mt_thunder_sud_nord_v1'
S = R / '.cache/entree_mt_thunder_sud_nord_v1/entree_mt_thunder_sud_nord'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
NAMES = [Path(L['file']).name.replace('_fNN', '') for L in M['layers']]
STATIC = ('sable', 'cailloux', 'pics', 'falaise', 'piton', 'seuil', 'profondeur', 'ciel', 'nuages')
REF = R / 'Game Boy Advance - Pokemon Mystery Dungeon_ Red Rescue Team - Dungeon Boss Rooms - Mt. Thunder.png'


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
BY = {re.sub(r'^EMT1_\d\d_', '', Path(n).stem): fr for n, fr in zip(NAMES, STACK)}
ORDER = list(BY)
MASK = {k: np.array(Image.open(O / f'masques/EMT1_masque_{k}.png')) > 0 for k in (*STATIC, 'praticable')}
B = loadmod('emt1_build', HERE / 'build.py')


def alpha(a):
    return a[..., 3] == 255


def colors(frames):
    return {tuple(int(v) for v in c) for a in frames for c in np.unique(a[a[..., 3] > 0][:, :3], axis=0)}


def rip_colors():
    a = np.array(Image.open(REF).convert('RGB'))
    return {tuple(int(v) for v in c) for c in np.unique(a.reshape(-1, 3), axis=0)}


def lum(px):
    return px[..., :3].astype(float) @ [.299, .587, .114]


def sheet():
    return B.rip_sheet(B.rgb(REF))


class Build(unittest.TestCase):
    def test_raw_hashes_and_reference(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        ref = M['reference_da']
        self.assertEqual(ref['file'], REF.name)
        self.assertEqual(hashlib.sha256(REF.read_bytes()).hexdigest(), ref['sha256'])
        g = M['generation']
        self.assertEqual([x['file'] for x in g], ['decor.png', 'sol_complet.png'])
        self.assertTrue(all(x['images'] == [REF.name] and len(x['prompt']) > 100 for x in g))   # rip en référence
        self.assertIn('choisi par l agent', M['biome'])
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])
        # La scène du rip s'arrête en y = 352 : dessous, planche sur fond noir (jamais mesurée comme décor).
        a = B.rgb(REF); self.assertTrue((a[352:360].sum(-1) == 0).mean() > 0.9)
        self.assertEqual(ref['scene_rows'], [0, 352])

    def test_sizes_names_alpha_no_magenta(self):
        self.assertEqual(len(NAMES), len(set(NAMES))); self.assertTrue(all(n.startswith('EMT1_') for n in NAMES))
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
        self.assertEqual(ORDER, ['sol_complet', *STATIC, 'lueurs', 'eclairs'])
        self.assertTrue(alpha(BY['sol_complet'][0]).all())
        fixed = [alpha(BY[k][0]) for k in STATIC]
        self.assertTrue((np.sum(fixed, 0) == 1).all())                      # calques fixes : partition exacte
        for k in STATIC:
            self.assertGreater(int(alpha(BY[k][0]).sum()), 300, k)
            self.assertTrue((alpha(BY[k][0]) == MASK[k]).all(), k)
        sol = BY['sol_complet'][0][..., :3].astype(float).reshape(-1, 3)
        self.assertGreater(len(colors(BY['sol_complet'])), 8)               # texture, pas un aplat
        self.assertGreater(sol.mean(0)[0], sol.mean(0)[2] + 60)             # sable jaune

    def test_palettes_et_matieres(self):
        for g, v in M['normalization']['palettes'].items():
            self.assertLessEqual(len(colors([BY[k][0] for k in v['calques']])), v['couleurs'], g)
        L = lambda k: BY[k][0][alpha(BY[k][0])][:, :3].astype(int)
        self.assertLess(float(np.median(lum(L('profondeur')))), 60)          # grotte sombre
        s = L('sable'); self.assertGreater(float(((s[:, 0] > 190) & (s[:, 0] - s[:, 2] > 50)).mean()), 0.9)
        for k in ('falaise', 'piton'):
            p = L(k).mean(0); self.assertGreater(p[0], p[2] + 25, k)        # roche brune
        for k in ('ciel', 'nuages'):
            p = L(k); self.assertLess(float(np.median(p.max(1) - p.min(1))), 20, k)   # gris de l'orage
        self.assertLess(float(lum(L('ciel')).mean()), float(lum(L('nuages')).mean()) - 50)
        lab, n = nd.label(MASK['pics']); self.assertGreaterEqual(n, 8)
        lab, n = nd.label(MASK['cailloux']); self.assertGreaterEqual(n, 15)
        ring = nd.binary_dilation(MASK['pics'], iterations=2) & ~MASK['pics']
        self.assertGreater(float((MASK['sable'] | MASK['cailloux'])[ring].mean()), 0.7)   # pics posés sur le sable
        self.assertTrue((nd.binary_dilation(MASK['profondeur'], iterations=3) & MASK['piton']).any())
        ys, _ = np.nonzero(MASK['ciel']); self.assertLess(float(ys.max()), H * 0.2)   # ciel en haut
        # Le sable mène à la grotte : sous la bouche, le seuil (sol de terre) puis le sable, praticables et continus.
        ys, xs = np.nonzero(MASK['profondeur']); cx = (xs.min() + xs.max()) // 2
        yb = int(np.nonzero(MASK['profondeur'][:, cx])[0].max())
        col = MASK['praticable'][yb + 1:yb + 30, cx - 8:cx + 8]
        self.assertGreater(float(col.mean()), 0.9)
        self.assertTrue((nd.binary_dilation(MASK['profondeur'], iterations=1) & MASK['seuil']).any())   # touche la bouche
        se = BY['seuil'][0][alpha(BY['seuil'][0])][:, :3].astype(int)
        self.assertGreater(float((se[:, 0] > se[:, 2] + 15).mean()), 0.8)                       # terre brune

    def test_fidelite_rip(self):
        dec, ref = B.rgb(HERE / 'bruts/decor.png'), B.rgb(REF)[:352]
        fid = B.fidelity(dec, ref)
        self.assertEqual(set(fid), {'sable', 'roche', 'ciel', 'nuages_sombres', 'nuages_clairs'})
        for k, v in fid.items():
            self.assertLess(v['distance'], 35, (k, v))
            self.assertAlmostEqual(v['distance'], M['fidelite_rip']['brut'][k]['distance'], places=1)
        for key, v in M['fidelite_rip']['calques_finaux'].items():
            lay = BY[v['calque']][0]; px = lay[alpha(lay)][:, :3].astype(float)
            sel = B.materials(px.reshape(-1, 1, 3))[v['matiere']][:, 0]
            self.assertGreater(int(sel.sum()), 50, key)                    # la matière est bien présente
            d = float(np.linalg.norm(px[sel].mean(0) - np.array(fid[v['matiere']]['rip_rgb'])))
            self.assertLess(d, 35, (key, d)); self.assertAlmostEqual(d, v['distance_rip'], places=1)
        f = B.rgb(HERE / 'bruts/sol_complet.png').reshape(-1, 3).mean(0)
        self.assertLess(float(np.linalg.norm(f - np.array(fid['sable']['rip_rgb']))), 35)
        # La mesure en un seul groupe est gardée pour mémoire, écartée et expliquée (pas cachée).
        e = M['fidelite_rip']['nuages_un_seul_groupe_ecarte']
        self.assertAlmostEqual(e['distance'], B.fidelity_clouds_one_group(dec, ref), places=1); self.assertIn('proportions', e['raison'])

    def test_eclairs_sprites_exacts_boucle_fermee(self):
        E = M['eclairs']; fr, lu = BY['eclairs'], BY['lueurs']; ref = B.rgb(REF)
        bolts, flash, sw = sheet()
        self.assertEqual((len(fr), len(lu), E['frame_length_ticks']), (48, 48, 5))
        self.assertEqual(sw, {'normal': ((240, 240, 128), (240, 240, 0)), 'fading': ((184, 176, 120), (160, 152, 32))})
        for k, (y0, y1, x0, x1) in E['boites_rip'].items():                 # pose = pixels du rip
            p = load(O / f'poses/EMT1_eclair_{k}.png'); self.assertEqual(p.shape[:2], (y1 - y0, x1 - x0))
            self.assertTrue((alpha(p) == (ref[y0:y1, x0:x1] == (240, 240, 0)).all(-1)).all(), k)
        y0, y1, x0, x1 = E['flash_rip']; p = load(O / 'poses/EMT1_flash.png')
        self.assertTrue((alpha(p) == (ref[y0:y1, x0:x1] == (240, 240, 128)).all(-1)).all())
        self.assertTrue(colors(fr) <= {sw['normal'][1], sw['fading'][1]})    # couleurs EXACTES de la planche
        self.assertTrue(colors(lu) <= {sw['normal'][0], sw['fading'][0]})
        st = [tuple(s) for s in E['frappes']]                               # recalcul depuis le manifeste
        self.assertEqual([[int(b[3]), int(b[4])] for b in B.strike_boxes(bolts, flash, st)], E['arcs'])
        la, ea = B.anim_frames(bolts, flash, sw, strikes=st)
        for t in range(48):
            self.assertTrue((fr[t] == ea[t]).all(), t); self.assertTrue((lu[t] == la[t]).all(), t)
        l48, e48 = B.anim_frames(bolts, flash, sw, ts=[48], strikes=st)
        self.assertTrue((e48[0] == fr[0]).all()); self.assertTrue((l48[0] == lu[0]).all())   # 48 = 0
        self.assertTrue(all(not m for k, m, *_ in st if k == 1))           # éclair 1 : à gauche seulement
        self.assertTrue(any(m for k, m, *_ in st) and any(not m for k, m, *_ in st))
        self.assertEqual(sorted(s[4] for s in st), list(range(0, 48, 8)))   # un éclair toutes les 8 phases
        # Normal -> Fading -> rien, jamais deux éclairs à la fois.
        for t in range(48):
            on = [s for s in st if B.strike_state((t - s[4]) % 48)]
            self.assertLessEqual(len(on), 1, t)
            cs = colors([fr[t]])
            if on:
                want = sw[B.strike_state((t - on[0][4]) % 48)][1]; self.assertEqual(cs, {want}, t)
            else:
                self.assertEqual(cs, set(), t)
        # Éclairs et arcs dans l'orage seulement : jamais sur le relief.
        land = MASK['sable'] | MASK['cailloux'] | MASK['pics'] | MASK['falaise'] | MASK['piton'] | MASK['profondeur']
        near = nd.binary_dilation(land, iterations=2)
        for a in fr + lu:
            self.assertFalse((alpha(a) & near).any())
            self.assertTrue(((MASK['nuages'] | MASK['ciel'])[alpha(a)]).all())
        for t in range(48):                                                 # l'arc suit l'éclair
            self.assertEqual(bool(alpha(fr[t]).any()), bool(alpha(lu[t]).any()), t)

    def test_ora_and_scene(self):
        with zipfile.ZipFile(O / 'EMT1_entree_mt_thunder_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
            self.assertIn(b'Mt. Thunder', z.read('stack.xml'))
        sc = Image.new('RGBA', (W, H))
        for frames in STACK:
            sc.alpha_composite(Image.fromarray(frames[0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/EMT1_scene_t000.png')).all())
        for L in M['layers']:
            self.assertEqual(M['scene_loop_ticks'] % (L['phases'] * L['ticks']) if L['phases'] > 1 else 0, 0)

    def test_access(self):
        a = M['access']; self.assertTrue(a['path_found_16x16'])
        ex, ey = a['entry_px']; tx, ty = a['threshold_px']
        self.assertGreater(ey, H - 64); self.assertLess(ty, H // 3)
        self.assertTrue(MASK['praticable'][ey:ey + 16, ex:ex + 16].mean() > 0.9)     # arrivée sur la crête sud
        dp = nd.distance_transform_edt(~MASK['profondeur'])
        self.assertLess(float(dp[ty:ty + 16, tx:tx + 16].min()), 8)                # seuil au ras de la grotte
        self.assertEqual(a['walkable_cells'] + a['blocked_cells'], (W // 8) * (H // 8))
        self.assertGreater(a['walkable_cells'], 1200)
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text())
        blocked = np.array([[c['Tags'] for c in col] for col in doc['Object']['obstacles']]).T.astype(bool)
        for k in ('profondeur', 'pics', 'piton', 'falaise', 'ciel', 'nuages'):
            cells = MASK[k].reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > 0.5
            self.assertTrue(blocked[cells].all(), k)
        cells = MASK['praticable'].reshape(H // 8, 8, W // 8, 8).mean((1, 3)) == 1
        self.assertFalse(blocked[cells].any())
        self.assertFalse((MASK['praticable'] & (MASK['nuages'] | MASK['ciel'] | MASK['pics'] | MASK['falaise'])).any())

    def test_prefix_and_namespace_unique(self):
        for p in (R / 'source').glob('*/build.py'):
            if p.parent != HERE:
                s = p.read_text(errors='ignore')
                self.assertNotIn("PFX = 'EMT1'", s, p); self.assertNotIn("'entree_mt_thunder_sud_nord'", s, p)

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
