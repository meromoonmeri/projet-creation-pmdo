"""Tests dédiés — Entrée Clairière tropicale sud -> nord V1 (ETC1, 4:3 vaste).
.venv/bin/python -m unittest source.entree_clairiere_tropicale_sud_nord_v1.test_build -v
Contrôles d'images, de formats, de palettes, de fidélité au rip, de cadence et de grille : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, re, unittest, zipfile
import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/entree_clairiere_tropicale_sud_nord_v1'
S = R / '.cache/entree_clairiere_tropicale_sud_nord_v1/entree_clairiere_tropicale_sud_nord'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
NAMES = [Path(L['file']).name.replace('_fNN', '') for L in M['layers']]
STATIC = ('herbe', 'ombres', 'dalles', 'touffes', 'fleurs', 'jungle', 'palmiers', 'tertre', 'seuil', 'profondeur', 'rive',
          'ponton')
REF = R / 'large.S01P03A.png.84e22fb77c4061e77b0f546545fed2c7.png'


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
BY = {re.sub(r'^ETC1_\d\d_', '', Path(n).stem): fr for n, fr in zip(NAMES, STACK)}
ORDER = list(BY)
MASK = {k: np.array(Image.open(O / f'masques/ETC1_masque_{k}.png')) > 0 for k in (*STATIC, 'mer', 'praticable')}
B = loadmod('etc1_build', HERE / 'build.py')


def alpha(a):
    return a[..., 3] == 255


def colors(frames):
    return {tuple(int(v) for v in c) for a in frames for c in np.unique(a[a[..., 3] > 0][:, :3], axis=0)}


def rip_colors():
    a = np.array(Image.open(REF).convert('RGB'))
    return {tuple(int(v) for v in c) for c in np.unique(a.reshape(-1, 3), axis=0)}


def lum(px):
    return px[..., :3].astype(float) @ [.299, .587, .114]


def poses():
    return {k: load(O / f'poses/ETC1_{k}.png') for k in M['papillons']['poses']}


class Build(unittest.TestCase):
    def test_raw_hashes_reference_and_discarded(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        ref = M['reference_da']
        self.assertEqual(ref['file'], REF.name)
        self.assertEqual(hashlib.sha256(REF.read_bytes()).hexdigest(), ref['sha256'])
        g = M['generation']
        self.assertEqual([x['file'] for x in g], ['ecartes/decor_magenta_essai1_herbe_acide.png', 'decor_magenta.png',
                                                  'sol_complet.png', 'temoin_sans_objets.png', 'papillons_poses.png'])
        self.assertTrue(all(x['images'] and len(x['prompt']) > 100 for x in g))
        for i in (0, 1, 4):
            self.assertIn(REF.name, g[i]['images'])                       # rip en référence
        for i in (2, 3):
            self.assertTrue(g[i]['images'][0].endswith('bruts/decor_magenta.png'))   # édités du décor conforme
        self.assertTrue(g[1]['images'][0].endswith('ecartes/decor_magenta_essai1_herbe_acide.png'))
        self.assertIn('flat pure magenta', g[1]['prompt'])
        # Brut écarté : non conforme (herbe > 35), jamais lu par le build.
        self.assertTrue(g[0]['ecarte']); self.assertGreater(M['fidelite_rip']['brut_ecarte']['herbe']['distance'], 35)
        self.assertEqual([r['ecarte'] for r in M['raw_inputs']], [True, False, False, False, False])
        self.assertNotIn("rgb(RAW / 'ecartes", Path(HERE / 'build.py').read_text().split('def build')[1].split('ecarte = ')[0])
        self.assertIn('choisie par l agent', M['biome'])
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_recalages(self):
        a, f, t = (B.rgb(HERE / f'bruts/{n}.png') for n in ('decor_magenta', 'sol_complet', 'temoin_sans_objets'))
        m, _ = B.classify(a, t)
        rs = B.recalage(a, f, nd.binary_erosion(m['herbe'], iterations=6))    # lève si le minimum n'est pas (0, 0)
        self.assertEqual(rs, {k: M['recalage']['sol_complet'][k] for k in rs})
        self.assertLess(rs['ecart_moyen'], 8)
        sol = BY['sol_complet'][0][alpha(BY['sol_complet'][0])][:, :3].astype(float)
        self.assertGreater(sol.mean(0)[1], sol.mean(0)[2] + 90)             # herbe claire, pas un aplat
        self.assertGreater(len(colors(BY['sol_complet'])), 12)

    def test_sizes_names_alpha_no_magenta(self):
        self.assertEqual(len(NAMES), len(set(NAMES))); self.assertTrue(all(n.startswith('ETC1_') for n in NAMES))
        self.assertEqual((W, H, W % 8, H % 8), (768, 576, 0, 0)); self.assertEqual(W * 3, H * 4)   # 4:3
        n = M['normalization']; self.assertAlmostEqual(n['scale'], 576 / 896)
        self.assertEqual(n['scaled'][0] - sum(n['crop_x']), W)
        for name, frames in BY.items():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W))
                self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255}, name)
                v = a[a[..., 3] > 0].astype(int)
                bad = (v[:, 0] - v[:, 1] > 60) & (v[:, 2] - v[:, 1] > 60)
                if name == 'fleurs':                                        # hibiscus roses du rip : pas du fond
                    self.assertLess(int(bad.sum()), 60, name)
                else:
                    self.assertEqual(int(bad.sum()), 0, name)

    def test_multicalque_full_coverage_and_order(self):
        self.assertEqual(ORDER, ['sol_complet', *STATIC, 'mer', 'papillons'])
        self.assertTrue(alpha(BY['sol_complet'][0]).all())
        fixed = [alpha(BY[k][0]) for k in STATIC] + [alpha(BY['mer'][0])]
        self.assertTrue((np.sum(fixed, 0) == 1).all())                      # fixes + mer : partition exacte
        for k in STATIC:
            self.assertGreater(int(alpha(BY[k][0]).sum()), 500, k)
            self.assertTrue((alpha(BY[k][0]) == MASK[k]).all(), k)
        for a in BY['mer']:
            self.assertTrue((alpha(a) == MASK['mer']).all())               # même masque à chaque phase

    def test_palettes_et_matieres(self):
        for g, v in M['normalization']['palettes'].items():
            self.assertLessEqual(len(colors([BY[k][0] for k in v['calques']])), v['couleurs'], g)
        L = lambda k: BY[k][0][alpha(BY[k][0])][:, :3].astype(int)
        self.assertLess(float(np.median(lum(L('profondeur')))), 50)          # entrée sombre
        f = L('fleurs'); self.assertGreater(float(((f.max(1) - f.min(1)) > 150).mean()), 0.15)   # hibiscus gardés
        d = L('dalles').mean(0); self.assertGreater(d[0], d[2] + 60); self.assertGreater(d[0], d[1])  # sable, pas vert
        self.assertGreater(L('herbe').mean(0)[1], L('jungle').mean(0)[1] + 60)
        p = L('ponton').mean(0); self.assertGreater(p[0], p[2] + 40)         # bois
        lab, n = nd.label(MASK['palmiers']); self.assertGreaterEqual(n, 6)
        lab, n = nd.label(MASK['fleurs']); self.assertGreaterEqual(n, 15)
        # Tertre autour de la bouche, rive entre la mer et l'herbe.
        self.assertTrue((nd.binary_dilation(MASK['profondeur'], iterations=3) & MASK['tertre']).any())
        self.assertTrue((nd.binary_dilation(MASK['mer'], iterations=2) & MASK['rive']).any())

    def test_ombres_et_seuil_sol_sec_jusqu_a_la_bouche(self):
        L = lambda k: lum(BY[k][0][alpha(BY[k][0])])
        self.assertLess(L('ombres').mean(), L('herbe').mean() - 15)           # herbe assombrie
        o = BY['ombres'][0][alpha(BY['ombres'][0])][:, :3].astype(int)
        self.assertGreater(float((o[:, 1] > o[:, 2] + 40).mean()), 0.8)      # reste de l'herbe
        base = nd.distance_transform_edt(~(MASK['tertre'] | MASK['profondeur'] | MASK['seuil']))
        self.assertLessEqual(float(base[MASK['ombres']].max()), 45 * 576 / 896 + 2)   # au pied du tertre seulement
        se = BY['seuil'][0][alpha(BY['seuil'][0])][:, :3].astype(int)
        self.assertGreater(float((se[:, 0] > se[:, 1]).mean()), 0.8)         # terre brune
        self.assertTrue((nd.binary_dilation(MASK['profondeur'], iterations=1) & MASK['seuil']).any())   # touche la bouche
        # Sol sec continu : de la bouche, le praticable descend sans jungle ni eau entre les deux.
        ys, xs = np.nonzero(MASK['profondeur']); x0, x1 = xs.min(), xs.max(); yb = ys.max()
        col = MASK['praticable'][yb + 1:yb + 40, (x0 + x1) // 2 - 8:(x0 + x1) // 2 + 8]
        self.assertGreater(float(col.mean()), 0.9)
        front = np.zeros((H, W), bool); front[yb + 1:yb + 20, x0 + 4:x1 - 3] = True       # entre les montants
        self.assertFalse((front & (MASK['jungle'] | MASK['mer'])).any())

    def test_fidelite_rip(self):
        dec, ref = B.rgb(HERE / 'bruts/decor_magenta.png'), B.rgb(REF)
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

    def test_mer_profil_du_rip_boucle_et_rive_sans_liseré(self):
        Mr = M['mer']; fr = BY['mer']; water = MASK['mer']
        self.assertEqual((len(fr), Mr['frame_length_ticks'], Mr['pas_px'] * len(fr)), (24, 5, Mr['periode_px']))
        ref = B.rgb(REF); prof, crest = B.wave_model(ref)
        self.assertEqual([list(c) for c in prof], Mr['profil']); self.assertEqual(crest, Mr['crete'])
        self.assertEqual([tuple(ref[404 + k, 0]) for k in range(48)], [tuple(c) for c in prof])   # colonne du rip
        self.assertEqual(crest[0], 0); self.assertLessEqual(abs(crest[-1] - crest[0]), 1)        # crête qui boucle
        self.assertTrue(colors(fr) <= rip_colors())                         # couleurs EXACTES du rip
        calc, d = B.sea_frames(water, prof, crest)
        for t, a in enumerate(fr):
            self.assertTrue((a == calc[t]).all(), t)
        self.assertTrue((B.sea_frames(water, prof, crest, ts=[24])[0][0] == fr[0]).all())   # 24 = 0
        far = water & (d > 12)                                              # large : les crêtes montent de 2 px
        far2 = far[:-2] & far[2:]
        for t in range(24):
            self.assertTrue((fr[(t + 1) % 24][:-2][far2] == fr[t][2:][far2]).all(), t)
        # Rive : tout pixel d'eau qui touche la terre (4-voisinage, dans l'image) est la bande sombre.
        land = ~water; touch = water & (nd.binary_dilation(land, structure=nd.generate_binary_structure(2, 1)))
        self.assertGreater(int(touch.sum()), 200)
        light = {tuple(c) for c in prof if lum(np.array(c, float)) >= lum(np.array([119, 183, 231], float))}
        for a in fr:
            self.assertTrue((a[touch][:, :3] == Mr['bande_rive']).all())
            near = a[water & (d <= Mr['rive_px']['calme'])][:, :3]
            self.assertFalse(any(tuple(int(v) for v in c) in light for c in np.unique(near, axis=0)))
        dm = nd.distance_transform_edt(~MASK['profondeur'])
        self.assertGreater(float(dm[water].min()), 150)                     # pas d'eau devant l'entrée

    def test_papillons_boucle_fermee(self):
        P = M['papillons']; fr = BY['papillons']; ps = poses()
        self.assertEqual({k: p.shape[0] for k, p in ps.items()}, {k: v[2] // B.POSE_K for k, v in P['poses'].items()})
        self.assertEqual((len(fr), P['frame_length_ticks']), (24, 5))
        self.assertLessEqual(len(colors(fr)), 10)
        for k, p in ps.items():                                             # une seule tache par pose (voisins exclus)
            lab, n = nd.label(alpha(p), structure=np.ones((3, 3))); self.assertLessEqual(n, 2, k)
        fl = [tuple(f) for f in P['vols']]
        calc = B.butterfly_frames(ps, fl)
        for t, a in enumerate(fr):
            self.assertTrue((a == calc[t]).all(), t)
            self.assertGreater(int(alpha(a).sum()), 40, t)
        self.assertTrue((B.butterfly_frames(ps, fl, ts=[24])[0] == fr[0]).all())   # 24 = 0
        for f in fl:                                                        # vol continu, 23 -> 0 compris
            pos = [B.flight_pos(f, t) for t in range(25)]
            self.assertTrue(all(np.hypot(pos[t + 1][0] - pos[t][0], pos[t + 1][1] - pos[t][1]) < 16 for t in range(24)))
            self.assertAlmostEqual(pos[24][0], pos[0][0]); self.assertAlmostEqual(pos[24][1], pos[0][1])
        dm = nd.distance_transform_edt(~MASK['profondeur'])
        for a in fr:
            self.assertFalse((alpha(a) & (dm < 8)).any())                  # rien sur l'entrée sombre

    def test_ora_and_scene(self):
        with zipfile.ZipFile(O / 'ETC1_entree_clairiere_tropicale_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
            self.assertIn(b'Clairiere tropicale', z.read('stack.xml'))
        sc = Image.new('RGBA', (W, H))
        for frames in STACK:
            sc.alpha_composite(Image.fromarray(frames[0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/ETC1_scene_t000.png')).all())
        for L in M['layers']:
            self.assertEqual(M['scene_loop_ticks'] % (L['phases'] * L['ticks']) if L['phases'] > 1 else 0, 0)

    def test_access(self):
        a = M['access']; self.assertTrue(a['path_found_16x16'])
        ex, ey = a['entry_px']; tx, ty = a['threshold_px']
        self.assertGreater(ey, H - 64); self.assertLess(ty, H // 3)
        self.assertTrue(MASK['ponton'][ey:ey + 16, ex:ex + 16].mean() > 0.5)        # arrivée sur le ponton
        dp = nd.distance_transform_edt(~MASK['profondeur'])
        self.assertLess(float(dp[ty:ty + 16, tx:tx + 16].min()), 8)                # seuil au ras de l'entrée sombre
        self.assertEqual(a['walkable_cells'] + a['blocked_cells'], (W // 8) * (H // 8))
        self.assertGreater(a['walkable_cells'], 1200)
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text())
        blocked = np.array([[c['Tags'] for c in col] for col in doc['Object']['obstacles']]).T.astype(bool)
        for k in ('profondeur', 'jungle', 'palmiers', 'tertre', 'rive', 'mer'):
            cells = MASK[k].reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > 0.5
            self.assertTrue(blocked[cells].all(), k)
        cells = MASK['praticable'].reshape(H // 8, 8, W // 8, 8).mean((1, 3)) == 1
        self.assertFalse(blocked[cells].any())
        self.assertFalse((MASK['praticable'] & (MASK['mer'] | MASK['jungle'])).any())

    def test_prefix_and_namespace_unique(self):
        for p in (R / 'source').glob('*/build.py'):
            if p.parent != HERE:
                s = p.read_text(errors='ignore')
                self.assertNotIn("PFX = 'ETC1'", s, p); self.assertNotIn("'entree_clairiere_tropicale_sud_nord'", s, p)

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
