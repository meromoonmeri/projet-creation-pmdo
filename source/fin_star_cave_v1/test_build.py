"""Tests dédiés — Entrée Star Cave sud -> nord V1 (FST1, 4:3 vaste).
.venv/bin/python -m unittest source.fin_star_cave_v1.test_build -v
Contrôles d'images, de formats, de palettes, de fidélité au rip, de cadence et de grille : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, re, unittest, zipfile
import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/fin_star_cave_v1'
S = R / '.cache/fin_star_cave_v1/fin_star_cave'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
NAMES = [Path(L['file']).name.replace('_fNN', '') for L in M['layers']]
STATIC = ('sol', 'ombres', 'parois', 'blocs')
REF = R / 'starcavepmdsky.png'


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
BY = {re.sub(r'^FST1_\d\d_', '', Path(n).stem): fr for n, fr in zip(NAMES, STACK)}
ORDER = list(BY)
MASK = {k: np.array(Image.open(O / f'masques/FST1_masque_{k}.png')) > 0
        for k in ('sol', 'ombres', 'blocs', 'parois', 'facettes')}
B = loadmod('fst1_build', HERE / 'build.py')


def alpha(a):
    return a[..., 3] == 255


def colors(frames):
    return {tuple(int(v) for v in c) for a in frames for c in np.unique(a[a[..., 3] > 0][:, :3], axis=0)}


def rip_colors():
    a = np.array(Image.open(REF).convert('RGB'))
    return {tuple(int(v) for v in c) for c in np.unique(a.reshape(-1, 3), axis=0)}


def walk():
    return alpha(BY['sol'][0]) | alpha(BY['ombres'][0])


def lum(px):
    return px[..., :3].astype(float) @ [.299, .587, .114]


def steps(frames, mask=None):
    n = len(frames); m = np.ones((H, W), bool) if mask is None else mask
    return [int((frames[t][m] != frames[(t + 1) % n][m]).any(-1).sum()) for t in range(n)]


def stars_of_manifest():
    return [(int(x), int(y), f, c, int(o)) for x, y, f, c, o in M['etoiles']['etoiles']]


class Build(unittest.TestCase):
    def test_raw_hashes_and_reference(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        ref = M['reference_da']
        self.assertEqual(ref['file'], REF.name)
        self.assertEqual(hashlib.sha256(REF.read_bytes()).hexdigest(), ref['sha256'])
        g = M['generation']
        self.assertEqual([x['file'] for x in g], ['decor.png', 'sol_complet.png', 'poussiere_etoile_poses.png'])
        self.assertTrue(all(x['images'] and len(x['prompt']) > 100 for x in g))
        for x in g:
            self.assertIn(REF.name, x['images'])                            # rip en référence, les trois fois
        self.assertTrue(g[1]['images'][0].endswith('bruts/decor.png'))      # sol : édité du décor
        self.assertIn('no sparkles, no stars', g[0]['prompt'])              # étoiles animées à part
        self.assertIn('choisis par l agent', M['biome'])
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_decor_sans_etoiles_et_sol_complet_recale(self):
        a, f = B.rgb(HERE / 'bruts/decor.png'), B.rgb(HERE / 'bruts/sol_complet.png')
        self.assertEqual(int((a.min(-1) >= 250).sum()), 0)                  # aucune étoile blanche peinte
        rec = B.recalage(a, f)                                              # lève si le minimum n'est pas (0, 0)
        self.assertEqual(rec['ecart_moyen_sol'], M['sol_complet']['ecart_moyen_sol'])
        self.assertLess(rec['ecart_moyen_sol'], rec['ecart_decale_1px'])
        sol = BY['sol_complet'][0][alpha(BY['sol_complet'][0])][:, :3].astype(float)
        self.assertGreater(sol.mean(0)[2], sol.mean(0)[0] + 80)             # sol bleu acier
        self.assertGreater(len(colors(BY['sol_complet'])), 12)              # cratères gardés, pas un aplat

    def test_sizes_names_alpha_no_magenta(self):
        self.assertEqual(len(NAMES), len(set(NAMES))); self.assertTrue(all(n.startswith('FST1_') for n in NAMES))
        self.assertEqual((W, H, W % 8, H % 8), (768, 576, 0, 0)); self.assertEqual(W * 3, H * 4)   # 4:3
        n = M['normalization']; self.assertAlmostEqual(n['scale'], 576 / 896)
        self.assertEqual(n['scaled'][0] - sum(n['crop_x']), W)
        for name, frames in BY.items():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W))
                self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255}, name)          # aucun alpha intermédiaire
                v = a[a[..., 3] > 0].astype(int)
                self.assertEqual(int(((v[:, 0] - v[:, 1] > 60) & (v[:, 2] - v[:, 1] > 60)).sum()), 0, name)

    def test_multicalque_full_coverage_and_order(self):
        self.assertEqual(ORDER, ['sol_complet', *STATIC, 'reflets', 'etoiles', 'poussiere_etoile'])
        self.assertTrue(alpha(BY['sol_complet'][0]).all())                  # sol complet sous tout
        fixed = [alpha(BY[k][0]) for k in STATIC]
        self.assertTrue((np.sum(fixed, 0) == 1).all())                      # calques fixes : partition exacte
        for k in STATIC:
            self.assertGreater(int(alpha(BY[k][0]).sum()), 500, k)
            self.assertTrue((alpha(BY[k][0]) == MASK[k]).all(), k)

    def test_palettes_et_matieres(self):
        pg = M['normalization']['palettes']
        self.assertLessEqual(len(colors([BY[k][0] for k in pg['terrain']['calques']])), 96)
        self.assertLessEqual(len(colors([BY['parois'][0], BY['blocs'][0]])), 96)
        L = lambda k: lum(BY[k][0][alpha(BY[k][0])])
        self.assertNotIn('profondeur', BY)                                  # pas de bouche sombre dans une fin
        self.assertLess(L('ombres').mean(), L('sol').mean() - 8)            # ombres plus sombres que le sol
        dn = nd.distance_transform_edt(walk())
        self.assertLessEqual(float(nd.distance_transform_edt(~(MASK['parois'] | MASK['blocs']))
                                   [alpha(BY['ombres'][0])].max()), 28)     # contre les parois (bande 20-25 px)
        lab, n = nd.label(MASK['blocs']); self.assertGreaterEqual(n, 5)
        ring = nd.binary_dilation(MASK['blocs'], iterations=2) & ~MASK['blocs']
        self.assertGreater(walk()[ring].mean(), 0.6)                        # blocs posés sur le sol
        self.assertGreater(float(dn.max()), 40)

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

    def test_etoiles_formes_exactes_du_rip_et_boucle(self):
        E = M['etoiles']; fr = BY['etoiles']; stars = stars_of_manifest()
        self.assertEqual((len(fr), E['frame_length_ticks']), (24, 5))
        self.assertTrue(colors(fr) <= rip_colors())                         # couleurs EXACTES du rip
        rip = np.array(Image.open(REF).convert('RGB'))                      # formes relevées : présentes dans le rip
        for nm in ('croix_blanche', 'croix_lavande', 'etoile_lavande', 'etoile_verte'):
            spr = B._spr(B.STAR_SPRITES[nm], B.STAR_CMAP); hh, ww = spr.shape[:2]; m = spr[..., 3] > 0
            found = any((rip[y:y + hh, x:x + ww][m] == spr[m][:, :3]).all()
                        for y, x in np.argwhere((rip == spr[hh // 2, ww // 2, :3]).all(-1)) - [hh // 2, ww // 2]
                        if y >= 0 and x >= 0 and y + hh <= rip.shape[0] and x + ww <= rip.shape[1])
            self.assertTrue(found, nm)
        calc = B.star_frames(stars)
        for t, a in enumerate(fr):
            self.assertTrue((a == calc[t]).all(), t)                        # fichiers = manifeste
        self.assertTrue((B.star_frames(stars, ts=[24])[0] == fr[0]).all())  # 24 = 0
        shapes = {nm: B._spr(rows, B.STAR_CMAP) for nm, rows in B.STAR_SPRITES.items()}
        for a in fr:                                                        # chaque tache = un sprite entier du rip
            lab, n = nd.label(alpha(a), structure=np.ones((3, 3)))
            for s in nd.find_objects(lab):
                self.assertTrue(any(a[s].shape == sp.shape and (a[s] == sp).all() for sp in shapes.values()), s)
        where = [('parois' if (MASK['parois'] | MASK['blocs'])[y, x] else 'sol') for x, y, *_ in stars]
        self.assertEqual((where.count('parois'), where.count('sol')), (E['nombre']['parois'], E['nombre']['sol']))
        pts = np.array([(x, y) for x, y, *_ in stars])
        dd = np.abs(pts[:, None] - pts[None]).max(-1) + np.eye(len(pts), dtype=int) * 999
        self.assertGreaterEqual(int(dd.min()), E['ecart_min_px'])
        d = steps(fr); self.assertTrue(min(d) > 0, d)                       # ça scintille à chaque pas, 23 -> 0 compris
        self.assertIn(0, E['cycles']['eclat']); self.assertNotIn(0, E['cycles']['veille'])

    def test_reflets_rampe_du_rip_sur_les_facettes(self):
        Rf = M['reflets']; fr = BY['reflets']
        self.assertEqual((len(fr), Rf['frame_length_ticks'], Rf['pas_px'] * len(fr)), (24, 5, Rf['periode_u_px']))
        self.assertTrue(colors(fr) <= {tuple(c) for c in Rf['rampe']} <= rip_colors())
        fac, rank, _ = B.facets_of([BY['parois'][0], BY['blocs'][0]])
        self.assertTrue((fac == MASK['facettes']).all())
        self.assertEqual(int(fac.sum()), Rf['facettes_px'])
        self.assertFalse((fac & ~(MASK['parois'] | MASK['blocs'])).any())   # seulement sur les cristaux
        calc = B.glint_frames(fac, rank)
        base = np.zeros((H, W, 4), 'uint8')
        for k in ('parois', 'blocs'):
            m = alpha(BY[k][0]); base[m] = BY[k][0][m]
        for t, a in enumerate(fr):
            self.assertTrue((a == calc[t]).all(), t)
            m = alpha(a); self.assertGreater(int(m.sum()), 200, t)
            self.assertTrue((lum(a[m]) >= lum(base[m]) - 1).all(), t)       # un reflet éclaircit, jamais n'assombrit
        self.assertTrue((B.glint_frames(fac, rank, ts=[24])[0] == fr[0]).all())   # 24 = 0
        u = np.add.outer(np.arange(H), np.arange(W))                        # la vague avance de 20 px en u par phase
        cen = [float(np.angle(np.exp(2j * np.pi * u[alpha(a)] / Rf['periode_u_px']).mean())) for a in fr]
        adv = [((cen[(t + 1) % 24] - cen[t]) * Rf['periode_u_px'] / (2 * np.pi)) % Rf['periode_u_px'] for t in range(24)]
        # Mesure bruitée par la répartition inégale des facettes (15 à 26 px par pas) : on exige une avance toujours
        # positive et 20 px en moyenne ; l'égalité exacte avec la formule est vérifiée phase par phase ci-dessus.
        self.assertTrue(all(10 < v < 30 for v in adv), [round(v, 1) for v in adv])
        self.assertAlmostEqual(sum(adv) / 24, Rf['pas_px'], delta=1.0)

    def test_poussiere_etoile_boucle_fermee(self):
        P = M['poussiere_etoile']; fr = BY['poussiere_etoile']
        poses = {k: load(O / f'poses/FST1_{k}.png') for k in P['poses']}
        self.assertEqual({k: p.shape[0] for k, p in poses.items()}, {k: v[2] // 8 for k, v in P['poses'].items()})
        self.assertNotIn('nuee_5', P['poses']); self.assertIn('nuee_5', P['poses_ecartees'])
        self.assertFalse((O / 'poses/FST1_nuee_5.png').exists())
        self.assertEqual((len(fr), P['frame_length_ticks']), (24, 5))
        self.assertLessEqual(len(colors(fr)), 8)
        em = [tuple(e) for e in P['emetteurs']]; self.assertEqual(len(em), 5)
        calc = B.dust_frames(poses, em)
        for t, a in enumerate(fr):
            self.assertTrue((a == calc[t]).all(), t)                        # fichiers = chronologie du manifeste
            self.assertGreater(int(alpha(a).sum()), 10, t)
        self.assertTrue((B.dust_frames(poses, em, ts=[24])[0] == fr[0]).all())   # 24 = 0
        for x, y, _ in em:                                                  # naissance au sol, montée sur le sol
            self.assertTrue(walk()[y, x] and walk()[y - 30, x])
        self.assertTrue(all(nm is None or nm in P['poses'] for nm in P['sequence']))

    def test_ora_and_scene(self):
        with zipfile.ZipFile(O / 'FST1_fin_star_cave_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
            self.assertIn(b'Star Cave', z.read('stack.xml'))
        sc = Image.new('RGBA', (W, H))
        for frames in STACK:
            sc.alpha_composite(Image.fromarray(frames[0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/FST1_scene_t000.png')).all())
        for L in M['layers']:
            self.assertEqual(M['scene_loop_ticks'] % (L['phases'] * L['ticks']) if L['phases'] > 1 else 0, 0)

    def test_access(self):
        a = M['access']; self.assertTrue(a['path_found_16x16'] and a['path_to_boss'] and a['path_to_objective'])
        ex, ey = a['entry_px']; bx, by = a['boss_px']; ox, oy = a['objective_px']
        self.assertGreater(ey, H - 64); self.assertLess(oy, H // 3)
        self.assertTrue(walk()[ey:ey + 16, ex:ex + 16].mean() > 0.5)        # arrivée sur le sol
        self.assertTrue(walk()[by:by + 16, bx:bx + 16].mean() > 0.9)        # boss sur le sol
        dn = nd.distance_transform_edt(walk())
        self.assertGreater(float(dn[by + 8, bx + 8]), 40)                    # boss au coeur de l'arène, loin des parois
        self.assertLess(abs(ox + 8 - W // 2), 72)                            # objectif dans la colonne centrale
        self.assertLess(oy, by - 80)                                         # objectif au nord du boss
        self.assertGreater(by, H // 4); self.assertLess(by, 3 * H // 4)
        self.assertEqual(a['walkable_cells'] + a['blocked_cells'], (W // 8) * (H // 8))
        self.assertGreater(a['walkable_cells'], 1500)
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text())
        blocked = np.array([[c['Tags'] for c in col] for col in doc['Object']['obstacles']]).T.astype(bool)
        for k in ('blocs', 'parois'):                                       # blocs, parois : cases bloquées
            cells = MASK[k].reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > 0.5
            self.assertTrue(blocked[cells].all(), k)
        for px in (a['entry_px'], a['boss_px'], a['objective_px']):
            self.assertFalse(blocked[px[1] // 8:px[1] // 8 + 2, px[0] // 8:px[0] // 8 + 2].any(), px)
        # la fin ne s'ouvre pas sur un autre lieu : le bord nord et les flancs sont des parois bloquées
        self.assertTrue(blocked[:4].all()); self.assertTrue(blocked[:, :4].all() and blocked[:, -4:].all())

    def test_prefix_and_namespace_unique(self):
        for p in (R / 'source').glob('*/build.py'):
            if p.parent != HERE:
                s = p.read_text(errors='ignore')
                self.assertNotIn("PFX = 'FST1'", s, p); self.assertNotIn("'fin_star_cave'", s, p)

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
        self.assertEqual({m['EntName'] for m in o['Entities'][0]['Markers']}, {'entrance', 'boss', 'objectif'})
        self.assertEqual(len(o['Entities'][0]['Markers']), 3)                # pas de warp ni de seuil
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))


if __name__ == '__main__':
    unittest.main()
