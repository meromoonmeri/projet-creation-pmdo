"""Tests dédiés — Entrée Sables mouvants sud -> nord V1 (EQS1, 4:3 vaste).
.venv/bin/python -m unittest source.entree_sables_mouvants_sud_nord_v1.test_build -v
Contrôles d'images, de formats, de palettes, de fidélité au rip, de cadence et de grille : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, re, unittest, zipfile
import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/entree_sables_mouvants_sud_nord_v1'
S = R / '.cache/entree_sables_mouvants_sud_nord_v1/entree_sables_mouvants_sud_nord'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
NAMES = [Path(L['file']).name.replace('_fNN', '') for L in M['layers']]
STATIC = ('sable', 'ombres', 'bord_fosse', 'roche', 'pierres', 'profondeur')
REF = R / 'witheringdesert.png'


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
BY = {re.sub(r'^EQS1_\d\d_', '', Path(n).stem): fr for n, fr in zip(NAMES, STACK)}
ORDER = list(BY)
MASK = {k: np.array(Image.open(O / f'masques/EQS1_masque_{k}.png')) > 0
        for k in ('fosse', 'chutes', 'profondeur', 'sable', 'ombres', 'bord_fosse')}
B = loadmod('eqs1_build', HERE / 'build.py')


def alpha(a):
    return a[..., 3] == 255


def colors(frames):
    return {tuple(int(v) for v in c) for a in frames for c in np.unique(a[a[..., 3] > 0][:, :3], axis=0)}


def rip_colors():
    a = np.array(Image.open(REF).convert('RGB'))
    return {tuple(int(v) for v in c) for c in np.unique(a.reshape(-1, 3), axis=0)}


def walk():
    return alpha(BY['sable'][0]) | alpha(BY['ombres'][0])


def steps(frames, mask=None):
    n = len(frames); m = np.ones((H, W), bool) if mask is None else mask
    return [int((frames[t][m] != frames[(t + 1) % n][m]).any(-1).sum()) for t in range(n)]


class Build(unittest.TestCase):
    def test_raw_hashes_and_reference(self):
        for r in M['raw_inputs']:
            self.assertEqual(hashlib.sha256((R / r['file']).read_bytes()).hexdigest(), r['sha256'])
        ref = M['reference_da']
        self.assertEqual(ref['file'], REF.name)
        self.assertEqual(hashlib.sha256(REF.read_bytes()).hexdigest(), ref['sha256'])
        g = M['generation']
        self.assertEqual([x['file'] for x in g], ['decor_magenta.png', 'sol_complet.png', 'poussiere_poses.png'])
        self.assertTrue(all(x['images'] and len(x['prompt']) > 100 for x in g))
        self.assertIn(REF.name, g[0]['images']); self.assertIn(REF.name, g[2]['images'])     # rip en référence
        self.assertTrue(g[1]['images'][0].endswith('bruts/decor_magenta.png'))                 # sol : édité du décor
        self.assertIn('choisi par l agent', M['biome'])
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_sol_complet_recale_sur_le_decor(self):
        a, f = B.rgb(HERE / 'bruts/decor_magenta.png'), B.rgb(HERE / 'bruts/sol_complet.png')
        rec = B.recalage(a, f)                                              # lève si le minimum n'est pas (0, 0)
        self.assertEqual(rec['ecart_moyen_sable'], M['sol_complet']['ecart_moyen_sable'])
        self.assertLess(rec['ecart_moyen_sable'], rec['ecart_decale_1px'])
        sol = BY['sol_complet'][0][alpha(BY['sol_complet'][0])][:, :3].astype(float)
        self.assertGreater(sol.mean(0)[0], sol.mean(0)[2] + 80)             # sol complet = sable jaune, pas un aplat
        self.assertGreater(len(colors(BY['sol_complet'])), 12)              # stries gardées (premier essai lisse écarté)

    def test_sizes_names_alpha_no_magenta(self):
        self.assertEqual(len(NAMES), len(set(NAMES))); self.assertTrue(all(n.startswith('EQS1_') for n in NAMES))
        self.assertEqual((W, H, W % 8, H % 8), (768, 576, 0, 0)); self.assertEqual(W * 3, H * 4)   # 4:3
        n = M['normalization']; self.assertAlmostEqual(n['scale'], 576 / 896)
        self.assertEqual(n['scaled'][0] - sum(n['crop_x']), W)
        for name, frames in BY.items():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W))
                if name != 'rayons':
                    self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255}, name)
                v = a[a[..., 3] > 0].astype(int)
                self.assertEqual(int(((v[:, 0] - v[:, 1] > 60) & (v[:, 2] - v[:, 1] > 60)).sum()), 0)   # ni magenta ni frange

    def test_multicalque_full_coverage_and_order(self):
        self.assertEqual(ORDER, ['fosse', 'sol_complet', *STATIC, 'chutes', 'poussiere', 'rayons'])
        cover = np.zeros((H, W), bool)
        for k in ORDER:
            if k != 'rayons':
                cover |= alpha(BY[k][0])
        self.assertTrue(cover.all())
        fixed = [alpha(BY[k][0]) for k in STATIC] + [MASK['chutes']]        # calques fixes et chutes exclusifs
        self.assertEqual(int(np.sum(fixed, 0).max()), 1)
        for k in STATIC:
            self.assertGreater(int(alpha(BY[k][0]).sum()), 500, k)        # aucun calque vide
        self.assertFalse((alpha(BY['sol_complet'][0]) & MASK['fosse']).any())

    def test_palettes_et_matieres(self):
        pg = M['normalization']['palettes']
        self.assertLessEqual(len(colors([BY[k][0] for k in pg['terrain']['calques']])), 96)
        self.assertLessEqual(len(colors([BY['roche'][0], BY['pierres'][0]])), 64)
        self.assertLessEqual(len(colors(BY['profondeur'])), 12)
        lum = lambda k: BY[k][0][alpha(BY[k][0])][:, :3].astype(float) @ [.299, .587, .114]
        sb = BY['sable'][0][alpha(BY['sable'][0])][:, :3].astype(float).mean(0)
        self.assertGreater(sb[0], sb[2] + 100)                             # sable jaune vif
        self.assertLess(float(np.median(lum('profondeur'))), 50)           # entrée sombre
        self.assertLess(lum('ombres').mean(), lum('sable').mean() - 8)     # ombres plus sombres que le sable
        self.assertLess(lum('bord_fosse').mean(), lum('sable').mean() - 8) # lèvre de la fosse plus sombre
        ro = nd.distance_transform_edt(~(alpha(BY['roche'][0]) | alpha(BY['pierres'][0]) | alpha(BY['bord_fosse'][0])))
        self.assertLessEqual(float(ro[alpha(BY['ombres'][0])].max()), 14)  # ombres au pied des roches
        dp = nd.distance_transform_edt(~MASK['fosse'])
        self.assertLessEqual(float(dp[alpha(BY['bord_fosse'][0])].max()), 12)   # bord collé à la fosse

    def test_fidelite_rip(self):
        dec, ref = B.rgb(HERE / 'bruts/decor_magenta.png'), B.rgb(REF)
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

    def test_fosse_couleurs_du_rip_boucle_et_enfoncement(self):
        F = M['fosse']; fr = BY['fosse']; mask = MASK['fosse']
        self.assertEqual((len(fr), F['frame_length_ticks']), (12, 10))
        for a in fr:
            self.assertTrue((alpha(a) == mask).all())
        self.assertEqual(colors(fr), {tuple(c) for c in F['sequence']})     # les 4 couleurs de la séquence
        self.assertTrue(colors(fr) <= rip_colors())                         # couleurs EXACTES du rip
        for t in (0, 5, 11):
            self.assertTrue((B.pit_frames(mask, ts=[t])[0] == fr[t]).all(), t)      # fichiers = manifeste
        self.assertTrue((B.pit_frames(mask, ts=[12])[0] == fr[0]).all())            # 12 = 0
        d = steps(fr, mask)
        self.assertTrue(min(d) > 0 and max(d) < 2 * min(d), d)              # 11 -> 0 compris
        # Enfoncement : les lignes claires s'éloignent du bord (vers le centre) de 0,5 px par phase. Mesure : moyenne
        # circulaire de d mod 6 sur les lignes claires, lobes neutralisés (amplitude 2,5 px sur une période de 6 : avec
        # eux, la mesure est dominée par la rotation ; la séquence complète est déjà vérifiée contre le manifeste).
        dist = nd.distance_transform_edt(mask); ring = mask & (dist >= 3) & (dist < 30)
        amp = B.PIT_LOBE_A; B.PIT_LOBE_A = 0.0
        try:
            flat = B.pit_frames(mask)
        finally:
            B.PIT_LOBE_A = amp
        ph = []
        for a in flat:
            dd = dist[(a[..., :3] == F['sequence'][0]).all(-1) & ring]
            ph.append(np.angle(np.exp(2j * np.pi * dd / 6).mean()) * 6 / (2 * np.pi))
        adv = [(ph[(t + 1) % 12] - ph[t]) % 6 for t in range(12)]
        self.assertTrue(all(0 < v < 1.5 for v in adv), adv)                # toujours vers le centre, 11 -> 0 compris
        self.assertAlmostEqual(sum(adv) / 12, F['enfoncement_px_par_phase'], delta=0.05)   # 6 px par boucle
        self.assertFalse((fr[0][mask & (dist < 1.5)][:, :3] != F['sequence'][0]).any())   # liseré fixe du bord

    def test_chutes_translation_pure_boucle_fermee(self):
        C = M['chutes']; fr = BY['chutes']; mask = MASK['chutes']
        self.assertEqual((len(fr), C['frame_length_ticks'], C['pas_px']), (24, 5, 4))
        self.assertEqual(C['periode_px'], C['pas_px'] * len(fr))
        for a in fr:
            self.assertTrue((alpha(a) == mask).all())
        cols = colors(fr); self.assertTrue(cols <= rip_colors())            # couleurs EXACTES du rip
        self.assertEqual(cols, {tuple(C['fond'])} | {tuple(c) for p in C['paires'] for c in p})
        inner = mask & np.roll(mask, C['pas_px'], axis=0)
        for t in range(24):                                                 # translation pure vers le sud, 23 -> 0 compris
            nxt = fr[(t + 1) % 24]; shifted = np.roll(fr[t], C['pas_px'], axis=0)
            self.assertTrue((nxt[inner] == shifted[inner]).all(), t)
        self.assertTrue((B.fall_frames(mask, ts=[24])[0] == fr[0]).all())    # 24 = 0
        lab, n = nd.label(mask); self.assertEqual(n, 2)                     # deux chutes
        for (cx, yb) in C['pieds']:
            self.assertTrue(mask[yb, cx] and not mask[min(H - 1, yb + 3), cx])

    def test_poussiere_boucle_fermee(self):
        P = M['poussiere']; fr = BY['poussiere']
        poses = {k: load(O / f'poses/EQS1_{k}.png') for k in P['poses']}
        self.assertEqual({k: p.shape[0] for k, p in poses.items()}, {k: v[2] // 8 for k, v in P['poses'].items()})
        self.assertEqual((len(fr), P['frame_length_ticks']), (24, 5))
        self.assertLessEqual(len(colors(fr)), 8)
        puffs = [tuple(e) for e in P['bouffees']]; swirls = [tuple(e) for e in P['tourbillons']]
        self.assertEqual((len(puffs), len(swirls)), (4, 3))
        calc = B.dust_frames(poses, puffs, swirls, walk())
        for t, a in enumerate(fr):
            self.assertTrue((a == calc[t]).all(), t)                        # fichiers = chronologie du manifeste
            self.assertGreater(int(alpha(a).sum()), 10, t)
        self.assertTrue((B.dust_frames(poses, puffs, swirls, walk(), ts=[24])[0] == fr[0]).all())   # 24 = 0
        for cx, yb in M['chutes']['pieds']:                                 # bouffées au pied des chutes
            self.assertTrue(any(abs(px - cx) <= 8 and 0 <= py - yb <= 6 for px, py, _ in puffs))
        only_sw = B.dust_frames(poses, [], swirls, walk())
        for a in only_sw:                                                   # tourbillons : seulement sur le sable
            self.assertFalse((alpha(a) & ~walk()).any())
        dp = nd.distance_transform_edt(~MASK['fosse'])
        for x, y, _ in swirls:
            self.assertGreater(float(dp[y, x]), 40)

    def test_rayons_overlay_boucle_et_bouche_libre(self):
        Rr = M['rayons']; fr = BY['rayons']
        self.assertEqual((len(fr), Rr['frame_length_ticks']), (12, 10))
        self.assertEqual(colors(fr), {tuple(Rr['couleur'])}); self.assertIn(tuple(Rr['couleur']), rip_colors())
        levels = set(np.unique(np.concatenate([a[..., 3].ravel() for a in fr])).tolist())
        self.assertTrue(levels <= set(range(0, Rr['alpha_max'] + 1, Rr['palier_alpha'])), levels)
        self.assertEqual(max(levels), Rr['alpha_max'])
        for t in (0, 7):
            self.assertTrue((B.ray_frames(ts=[t])[0] == fr[t]).all(), t)
        self.assertTrue((B.ray_frames(ts=[12])[0] == fr[0]).all())          # 12 = 0
        mouth = nd.binary_dilation(MASK['profondeur'], iterations=4)
        for a in fr:
            self.assertFalse((a[..., 3] > 0)[mouth].any())                  # pas de lumière sur l'entrée sombre
            self.assertFalse((a[int(Rr['fondu_fraction_h'] * H):, :, 3] > 0).any())   # fondu avant le sud
        d = steps(fr)
        self.assertTrue(min(d) > 0 and d[11] <= 1.1 * max(d[:11]), d)

    def test_ora_and_scene(self):
        with zipfile.ZipFile(O / 'EQS1_entree_sables_mouvants_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
            self.assertIn(b'Sables mouvants', z.read('stack.xml'))
        sc = Image.new('RGBA', (W, H))
        for frames in STACK:
            sc.alpha_composite(Image.fromarray(frames[0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/EQS1_scene_t000.png')).all())
        for L in M['layers']:
            self.assertEqual(M['scene_loop_ticks'] % (L['phases'] * L['ticks']) if L['phases'] > 1 else 0, 0)

    def test_access(self):
        a = M['access']; self.assertTrue(a['path_found_16x16'])
        ex, ey = a['entry_px']; tx, ty = a['threshold_px']
        self.assertGreater(ey, H - 64); self.assertLess(ty, H // 3)
        self.assertTrue(walk()[ey:ey + 16, ex:ex + 16].mean() > 0.5)        # arrivée sur le sable
        dp = nd.distance_transform_edt(~MASK['profondeur'])
        self.assertLess(float(dp[ty:ty + 16, tx:tx + 16].min()), 24)          # seuil au pied de l'entrée sombre
        self.assertEqual(a['walkable_cells'] + a['blocked_cells'], (W // 8) * (H // 8))
        self.assertGreater(a['walkable_cells'], 1500)
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text())
        blocked = np.array([[c['Tags'] for c in col] for col in doc['Object']['obstacles']]).T.astype(bool)
        for k in ('fosse', 'chutes', 'profondeur'):                         # fosse, chutes, bouche : cases bloquées
            cells = MASK[k].reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > 0.5
            self.assertTrue(blocked[cells].all(), k)

    def test_prefix_and_namespace_unique(self):
        for p in (R / 'source').glob('*/build.py'):
            if p.parent != HERE:
                s = p.read_text(errors='ignore')
                self.assertNotIn("PFX = 'EQS1'", s, p); self.assertNotIn("'entree_sables_mouvants_sud_nord'", s, p)

    def test_ground_roundtrip(self):
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text()); o = doc['Object']
        self.assertEqual(doc['Version'], '0.8.12.0'); self.assertEqual(len(o['Layers']), len(STACK) + 1)
        self.assertEqual(o['Layers'][-1]['Layer'], 4)
        nr = loadmod('native_reader', R / 'source/cote_v5_expeditions/audit_references.py')
        gfx = loadmod('pmdo_codec', R / 'source/pmdo_cote/build.py')
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
                exp = frames[t]
                if 'rayons' in L['file']:                                   # alpha intermédiaire : prémultiplié à l'écriture
                    exp = np.array(nr.straight(gfx.premult(Image.fromarray(exp))))
                self.assertTrue((out == exp).all(), (li, t))
        self.assertEqual(sum(w['Tags'] for c in o['obstacles'] for w in c), M['access']['blocked_cells'])
        self.assertEqual({m['EntName'] for m in o['Entities'][0]['Markers']}, {'entrance', 'donjon_seuil'})
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))


if __name__ == '__main__':
    unittest.main()
