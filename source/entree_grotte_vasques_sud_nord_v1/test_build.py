"""Tests dédiés — Entrée Grotte aux vasques sud -> nord V1 (EGV1, 4:3 vaste).
.venv/bin/python -m unittest source.entree_grotte_vasques_sud_nord_v1.test_build -v
Contrôles d'images, de formats, de palettes, de fidélité au rip, de cadence et de grille : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, re, unittest, zipfile
import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/entree_grotte_vasques_sud_nord_v1'
S = R / '.cache/entree_grotte_vasques_sud_nord_v1/entree_grotte_vasques_sud_nord'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
NAMES = [Path(L['file']).name.replace('_fNN', '') for L in M['layers']]
STATIC = ('sol', 'ombres', 'vasques', 'parois', 'blocs', 'profondeur')
REF = HERE / 'references/D56P12A.png'
PA = json.loads((HERE / 'references/palette_anim.json').read_text())['maps']['D56P12A']


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
BY = {re.sub(r'^EGV1_\d\d_', '', Path(n).stem): fr for n, fr in zip(NAMES, STACK)}
ORDER = list(BY)
MASK = {k: np.array(Image.open(O / f'masques/EGV1_masque_{k}.png')) > 0
        for k in ('sol', 'ombres', 'vasques', 'eau', 'rebords', 'parois', 'blocs', 'profondeur', 'reflets')}
B = loadmod('egv1_build', HERE / 'build.py')


def alpha(a):
    return a[..., 3] == 255


def colors(frames, mask=None):
    out = set()
    for a in frames:
        m = a[..., 3] > 0 if mask is None else (a[..., 3] > 0) & mask
        out |= {tuple(int(v) for v in c) for c in np.unique(a[m][:, :3], axis=0)}
    return out


def rip_colors():
    a = np.array(Image.open(REF).convert('RGB'))
    out = {tuple(int(v) for v in c) for c in np.unique(a.reshape(-1, 3), axis=0)}
    for s in PA['emplacements']:                                   # couleurs de toutes les frames de l'animation
        out |= {tuple(c) for c in s['couleurs_par_frame']}
    return out


def walk():
    return alpha(BY['sol'][0]) | alpha(BY['ombres'][0])


def lum(px):
    return px[..., :3].astype(float) @ [.299, .587, .114]


def steps(frames, mask=None):
    n = len(frames); m = np.ones((H, W), bool) if mask is None else mask
    return [int((frames[t][m] != frames[(t + 1) % n][m]).any(-1).sum()) for t in range(n)]


class Build(unittest.TestCase):
    def test_raw_hashes_and_reference(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        ref = M['reference_da']
        self.assertEqual(ref['code_rom'], 'D56P12A')
        self.assertEqual(hashlib.sha256(REF.read_bytes()).hexdigest(), ref['sha256'])
        g = M['generation']
        self.assertEqual([x['file'] for x in g], ['decor.png', 'sol_complet.png', 'source_poses.png'])
        self.assertTrue(all(x['images'] and len(x['prompt']) > 100 and x['essais'] for x in g))
        self.assertIn('references/D56P12A.png', g[0]['images']); self.assertIn('references/D56P41A.png', g[0]['images'])
        self.assertIn('references/D56P12A.png', g[2]['images'])                # planche : rip en référence
        self.assertEqual(g[1]['images'], ['bruts/decor.png'])                   # sol : édité du décor
        self.assertIn('no water in front of it', g[0]['prompt'])                # pas d'eau devant l'entrée
        self.assertIn('choisi par l agent', M['biome'])
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])
        self.assertEqual(hashlib.sha256((R / M['pmdo']['template']['file']).read_bytes()).hexdigest(),
                         M['pmdo']['template']['sha256'])

    def test_provenance_rom(self):
        prov = json.loads((HERE / 'references/provenance.json').read_text())
        outil = loadmod('outil_maps', R / 'source/outil_maps_pmdsky/recuperer_maps.py')
        self.assertEqual(prov['commit'], outil.PMD_SKY_COMMIT)                  # même commit épinglé que l'outil
        for code, p in prov['maps'].items():
            png = HERE / 'references' / p['png']
            self.assertEqual(hashlib.sha256(png.read_bytes()).hexdigest(), p['png_sha256'], code)
            with Image.open(png) as im:
                self.assertEqual(list(im.size), p['taille_px'])
            self.assertEqual(set(p['fichiers']), {'bma', 'bpc', 'bpl'})
            self.assertTrue(all(len(f['blob_git']) == 40 and len(f['sha256']) == 64 for f in p['fichiers'].values()))
        self.assertEqual(PA['specs_bpl'], [{'palette': 13, 'duree_par_frame': 2, 'frames': 32}])
        self.assertEqual(len(PA['emplacements']), 5)
        self.assertEqual(len(PA['sequence_etats_distincts']), 32)
        rip = np.array(Image.open(REF).convert('RGB'))
        for s in PA['emplacements']:                                            # couleur de frame 0 présente dans le rip
            self.assertTrue((rip == s['couleurs_par_frame'][0]).all(-1).any())
        self.assertEqual(sum(s['pixels'] for s in PA['emplacements']), PA['pixels_animes'])

    def test_sol_complet_recale(self):
        a, f = B.rgb(HERE / 'bruts/decor.png'), B.rgb(HERE / 'bruts/sol_complet.png')
        rec = B.recalage(a, f)                                              # lève si le minimum n'est pas (0, 0)
        self.assertEqual(rec['ecart_moyen_sol'], M['sol_complet']['ecart_moyen_sol'])
        self.assertLess(rec['ecart_moyen_sol'], rec['ecart_decale_1px'])
        sol = BY['sol_complet'][0][alpha(BY['sol_complet'][0])][:, :3].astype(float)
        self.assertLess(np.linalg.norm(sol.mean(0) - B.SAND), 12)          # même sable que le décor (pas le jaune écarté)
        self.assertGreater(len(colors(BY['sol_complet'])), 12)              # mouchetures gardées, pas un aplat

    def test_sizes_names_alpha_no_magenta(self):
        self.assertEqual(len(NAMES), len(set(NAMES))); self.assertTrue(all(n.startswith('EGV1_') for n in NAMES))
        self.assertEqual((W, H, W % 8, H % 8), (768, 576, 0, 0)); self.assertEqual(W * 3, H * 4)   # 4:3
        n = M['normalization']; self.assertAlmostEqual(n['scale'], 576 / 896)
        self.assertEqual(n['scaled'][0] - sum(n['crop_x']), W)
        for name, frames in BY.items():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W))
                self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255}, name)          # aucun alpha intermédiaire
                v = a[a[..., 3] > 0].astype(int)
                self.assertEqual(int(((v[:, 0] - v[:, 1] > 60) & (v[:, 2] - v[:, 1] > 60)).sum()), 0, name)

    def test_multicalque_partition(self):
        self.assertEqual(ORDER, ['sol_complet', *STATIC, 'reflets_vasques', 'bulles_source'])
        self.assertTrue(alpha(BY['sol_complet'][0]).all())                  # sol complet sous tout
        fixed = [alpha(BY[k][0]) for k in STATIC]
        self.assertTrue((np.sum(fixed, 0) == 1).all())                      # calques fixes : partition exacte
        for k in STATIC:
            self.assertGreater(int(alpha(BY[k][0]).sum()), 300, k)
            self.assertTrue((alpha(BY[k][0]) == MASK[k]).all(), k)
        self.assertTrue((MASK['vasques'] == (MASK['eau'] | MASK['rebords'])).all())
        self.assertFalse((MASK['eau'] & MASK['rebords']).any())

    def test_palettes_et_matieres(self):
        pg = M['normalization']['palettes']
        self.assertLessEqual(len(colors([BY[k][0] for k in pg['terrain']['calques']])), 96)
        self.assertLessEqual(len(colors([BY[k][0] for k in pg['roche']['calques']])), 96)
        wpal = {tuple(c) for c in M['normalization']['eau']['couleurs_rip']}
        self.assertEqual(len(wpal), 12)
        self.assertTrue(wpal <= rip_colors())                               # eau : couleurs EXACTES du rip
        self.assertEqual(colors([BY['vasques'][0]], MASK['eau']), wpal)     # toutes, et rien d'autre, sur l'eau
        self.assertLessEqual(len(colors([BY['vasques'][0]], MASK['rebords'])), 64)
        L = lambda k: lum(BY[k][0][alpha(BY[k][0])])
        self.assertLess(L('ombres').mean(), L('sol').mean() - 8)            # ombres plus sombres que le sable
        self.assertLess(L('profondeur').mean(), 80)                         # profondeur sombre
        lab, n = nd.label(MASK['blocs']); self.assertGreaterEqual(n, 4)
        ring = nd.binary_dilation(MASK['blocs'], iterations=2) & ~MASK['blocs']
        self.assertGreater(walk()[ring].mean(), 0.6)                        # flèches posées sur le sable
        ev = BY['vasques'][0][MASK['eau']][:, :3].astype(int)               # eau turquoise (g et b >> r) ; seuls les
        tq = (ev[:, 1] - ev[:, 0] > 60) & (ev[:, 2] - ev[:, 0] > 60)        # reflets blanc-cyan du rip y échappent
        self.assertGreater(tq.mean(), 0.9); self.assertTrue((ev.mean(0)[1:] - ev.mean(0)[0] > 80).all())

    def test_fidelite_rip(self):
        dec, ref = B.rgb(HERE / 'bruts/decor.png'), B.rgb(REF)
        fid = B.fidelity(dec, ref)
        for k, v in fid.items():
            self.assertLess(v['distance'], 35, (k, v))                      # brut ≈ rip, matière par matière
            self.assertAlmostEqual(v['distance'], M['fidelite_rip']['brut'][k]['distance'], places=1)
        for nm, v in M['fidelite_rip']['calques_finaux'].items():
            lay = BY[nm][0]; px = lay[alpha(lay)][:, :3].astype(float)
            sel = B.materials(px.reshape(-1, 1, 3))[v['matiere']][:, 0]
            px = px[sel] if sel.sum() > 50 else px
            d = float(np.linalg.norm(px.mean(0) - np.array(fid[v['matiere']]['rip_rgb'])))
            self.assertLess(d, 35, (nm, d)); self.assertAlmostEqual(d, v['distance_rip'], places=1)
        self.assertLess(M['fidelite_rip']['calques_finaux']['vasques']['distance_rip'], fid['eau']['distance'])

    def test_reflets_animation_de_palette_exacte(self):
        Rf = M['reflets_vasques']; fr = BY['reflets_vasques']
        self.assertEqual((len(fr), Rf['frame_length_ticks']), (32, 2))      # cadence du BPL
        slots = [[tuple(c) for c in s] for s in Rf['emplacements']]
        self.assertEqual(slots, [[tuple(c) for c in s['couleurs_par_frame']] for s in PA['emplacements']])
        self.assertTrue(colors(fr) <= rip_colors())                         # couleurs EXACTES de l'animation du jeu
        m = alpha(fr[0])
        self.assertEqual(int(m.sum()), Rf['pixels'])
        self.assertFalse((m & ~MASK['eau']).any())                          # seulement sur l'eau
        self.assertTrue((MASK['reflets'] == m).all())
        self.assertTrue((fr[0][m] == BY['vasques'][0][m]).all())            # frame 0 = calque fixe : pas de saut
        slot_map = np.full((H, W), -1, int)
        for k, s in enumerate(slots):                                       # chaque pixel suit UN emplacement
            slot_map[m & (fr[0][..., :3] == s[0]).all(-1)] = k
        self.assertTrue((slot_map[m] >= 0).all())
        self.assertEqual([int((slot_map == k).sum()) for k in range(5)], Rf['pixels_par_emplacement'])
        calc = B.reflet_frames(slot_map, slots)
        for t, a in enumerate(fr):
            self.assertTrue((a == calc[t]).all(), t)                        # fichiers = loi du BPL
            self.assertTrue((alpha(a) == m).all(), t)
        self.assertTrue((B.reflet_frames(slot_map, slots, ts=[32])[0] == fr[0]).all())   # 32 = 0
        seq = []
        keys = []
        for a in fr:                                                        # même enchaînement d'états que le rip
            k = a[m].tobytes()
            if k not in keys:
                keys.append(k)
            seq.append(keys.index(k))
        self.assertEqual(seq, PA['sequence_etats_distincts'])

    def test_bulles_source(self):
        P = M['bulles_source']; fr = BY['bulles_source']
        poses = {k: load(O / f'poses/EGV1_{k}.png') for k in P['poses']}
        self.assertEqual({k: p.shape[:2] for k, p in poses.items()},
                         {k: (v[2] // P['reduction'][k][0], v[3] // P['reduction'][k][1]) for k, v in P['poses'].items()})
        self.assertEqual((len(fr), P['frame_length_ticks']), (32, 4))
        wpal = {tuple(c) for c in M['normalization']['eau']['couleurs_rip']}
        self.assertTrue(colors(fr) <= wpal)                                 # couleurs ramenées à l'eau du rip
        em = [tuple(e) for e in P['emetteurs']]; self.assertEqual(len(em), 10)
        self.assertEqual(sum(x < W // 2 for x, _, _ in em), 5)              # moitié de chaque côté
        calc = B.bubble_frames(poses, em, MASK['eau'], MASK['vasques'])
        for t, a in enumerate(fr):
            self.assertTrue((a == calc[t]).all(), t)                        # fichiers = chronologie du manifeste
            self.assertGreater(int(alpha(a).sum()), 10, t)
            self.assertFalse((alpha(a) & ~MASK['vasques']).any(), t)        # jamais hors des vasques
        self.assertTrue((B.bubble_frames(poses, em, MASK['eau'], MASK['vasques'], ts=[32])[0] == fr[0]).all())
        for x, y, _ in em:
            self.assertTrue(MASK['eau'][y, x])                              # source au milieu de l'eau
        self.assertTrue(all(nm is None or nm in P['poses'] for nm in P['sequence']))
        rings = np.zeros((H, W), bool)                                      # anneaux : sur l'eau seule
        for t in range(32):
            calc_r = B.bubble_frames({k: (v if k.startswith('anneau') else v * 0) for k, v in poses.items()}, em,
                                     MASK['eau'], MASK['vasques'], ts=[t])[0]
            rings |= alpha(calc_r)
        self.assertFalse((rings & ~MASK['eau']).any())
        self.assertTrue(min(steps(fr)) > 0)                                 # ça bouge à chaque pas, 31 -> 0 compris

    def test_ora_and_scene(self):
        with zipfile.ZipFile(O / 'EGV1_entree_grotte_vasques_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
            self.assertIn(b'Grotte aux vasques', z.read('stack.xml'))
        sc = Image.new('RGBA', (W, H))
        for frames in STACK:
            sc.alpha_composite(Image.fromarray(frames[0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/EGV1_scene_t000.png')).all())
        for L in M['layers']:
            self.assertEqual(M['scene_loop_ticks'] % (L['phases'] * L['ticks']) if L['phases'] > 1 else 0, 0)

    def test_access(self):
        a = M['access']; self.assertTrue(a['path_found_16x16'])
        ex, ey = a['entry_px']; tx, ty = a['threshold_px']
        self.assertGreater(ey, H - 64); self.assertLess(ty, H // 3)          # arrivée au sud, seuil au nord
        self.assertTrue(walk()[ey:ey + 16, ex:ex + 16].mean() > 0.5)
        mouth = MASK['profondeur'] & (np.mgrid[:H, :W][0] > 60)
        ys, xs = np.nonzero(mouth & (np.abs(np.mgrid[:H, :W][1] - (tx + 8)) < 60))
        self.assertLess(ty - ys.max(), 24)                                   # seuil juste sous la bouche
        self.assertLess(abs(tx + 8 - xs.mean()), 16)
        zone = np.zeros((H, W), bool); zone[ys.max():ty + 64, max(0, tx - 48):tx + 64] = True
        self.assertFalse((MASK['eau'] & zone).any())                         # pas d'eau devant l'entrée
        self.assertEqual(a['walkable_cells'] + a['blocked_cells'], (W // 8) * (H // 8))
        self.assertGreater(a['walkable_cells'], 1200)
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text())
        blocked = np.array([[c['Tags'] for c in col] for col in doc['Object']['obstacles']]).T.astype(bool)
        for k in ('vasques', 'parois', 'blocs', 'profondeur'):               # cases bloquées
            cells = MASK[k].reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > 0.5
            self.assertTrue(blocked[cells].all(), k)
        for px in (a['entry_px'], a['threshold_px']):
            self.assertFalse(blocked[px[1] // 8:px[1] // 8 + 2, px[0] // 8:px[0] // 8 + 2].any(), px)
        self.assertTrue(blocked[:8].all())                                   # voûte et stalactites au nord

    def test_prefix_and_namespace_unique(self):
        for p in (R / 'source').glob('*/build.py'):
            if p.parent != HERE:
                s = p.read_text(errors='ignore')
                self.assertNotIn("PFX = 'EGV1'", s, p); self.assertNotIn("'entree_grotte_vasques_sud_nord'", s, p)

    def test_ground_roundtrip(self):
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text()); o = doc['Object']
        self.assertEqual(doc['Version'], '0.8.12.0'); self.assertEqual(len(o['Layers']), len(STACK) + 1)
        self.assertEqual(o['Layers'][-1]['Layer'], 4); self.assertEqual(o['TexSize'], 1)
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
        self.assertEqual(len(o['Entities'][0]['Markers']), 2)                # pas de warp
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))


if __name__ == '__main__':
    unittest.main()
