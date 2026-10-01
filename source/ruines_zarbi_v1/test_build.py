"""Tests dédiés — Ruines Zarbi, déchirures 1 (RZD1), 4:3.
.venv/bin/python -m unittest source.ruines_zarbi_v1.test_build -v
Contrôles d'images, de formats, de cadence, de mouvement, de grille et d'accès : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, unittest, zipfile
import numpy as np
from scipy import ndimage
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/ruines_zarbi_v1/RZD1'
S = R / '.cache/ruines_zarbi_v1/ruines_zarbi'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']
ANIM = ('vide', 'rochers', 'failles', 'debris', 'zarbi')
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
B = loadmod('rzd1_build', HERE / 'build.py')
MASK = {k: np.array(Image.open(O / f'masques/RZD1_masque_{k}.png')) > 0
        for k in ('floor', 'dalles', 'ruins', 'rift', 'void', 'rocks', 'fissures')}


def alpha(a):
    return a[..., 3] == 255


def colors(a, m=None):
    m = alpha(a) if m is None else m
    return {tuple(int(v) for v in c) for c in np.unique(a[m][:, :3], axis=0)}


class Build(unittest.TestCase):
    def test_bruts_references_fidelite(self):
        (raw,) = M['raw_inputs']
        self.assertEqual(hashlib.sha256((R / raw['file']).read_bytes()).hexdigest(), raw['sha256'])
        self.assertEqual(raw['images'], ['source/ruines_zarbi_v1/reference/D28P44A_decoupe_style_x2.png',
                                         'source/ruines_zarbi_v1/reference/D30P34A_decoupe_style_x2.png'])
        idx = {x['code']: x for x in json.loads((R / 'source/outil_maps_pmdsky/index_rom.json').read_text())['maps']}
        for code, size, anim in (('D28P44A', [504, 528], False), ('D30P34A', [552, 576], True)):
            ref = M['references_da'][code]
            self.assertEqual(hashlib.sha256((R / ref['fichier']).read_bytes()).hexdigest(), ref['sha256'])
            self.assertEqual(idx[code]['taille_px'], size)                                   # rendu ROM direct de l'outil
            self.assertEqual(Image.open(R / ref['fichier']).size, tuple(size))
            self.assertEqual(idx[code]['animation_palette'], anim)
        f = M['fidelite']; self.assertEqual(f['seuil'], 35)
        self.assertEqual(sorted(f['seuille']), ['briques', 'dalles', 'linteaux', 'sol_complet', 'terre'])
        for k in f['seuille']:
            self.assertLess(f[k]['distance'], 35, k)
        self.assertLess(f['briques']['distance'], 15)                                        # matière principale
        sc = np.array(Image.open(O / 'review/RZD1_scene_t000.png').convert('RGB')).astype(int)   # recalcul
        b0, a0, b1, a1 = f['briques']['boite_scene_y0x0y1x1']; y0, x0, y1, x1 = f['briques']['boite_ref_y0x0y1x1']
        ref = np.array(Image.open(R / M['references_da']['D30P34A']['fichier']).convert('RGB')).astype(int)
        d = np.linalg.norm(ref[y0:y1, x0:x1].reshape(-1, 3).mean(0) - sc[b0:b1, a0:a1].reshape(-1, 3).mean(0))
        self.assertAlmostEqual(float(d), f['briques']['distance'], places=1)
        self.assertTrue(MASK['floor'][b0:b1, a0:a1].mean() > 0.9)                            # la boîte tombe bien sur le sol
        self.assertFalse(M['art_approved']); self.assertFalse(M['pmdo']['runtime_tested'])

    def test_calques_ordre_tailles_alpha(self):
        self.assertEqual(NAMES, ['sol_complet', 'vide', 'sol', 'ruines', 'rochers', 'failles', 'debris', 'zarbi'])
        files = [Path(p).name for p in ORDER]
        self.assertTrue(all(n.startswith('RZD1_') for n in files)); self.assertEqual(len(files), len(set(files)))
        self.assertEqual((W, H, W * 3), (768, 576, H * 4))
        for frames in STACK.values():
            for a in frames:
                self.assertEqual(a.shape[:2], (H, W)); self.assertTrue(set(np.unique(a[..., 3])) <= {0, 255})
        self.assertTrue(alpha(STACK['sol_complet'][0]).all())
        vide = alpha(STACK['vide'][0])
        self.assertTrue((vide == (MASK['void'] | MASK['rocks'])).all())                      # le vide passe sous les rochers
        cover = np.zeros((H, W), bool)
        for m in (alpha(STACK['sol'][0]), alpha(STACK['ruines'][0]), MASK['rift'], MASK['void'] | MASK['rocks']):
            self.assertFalse((cover & m).any()); cover |= m
        self.assertTrue(cover.all())                                                         # classes disjointes, carte couverte
        self.assertEqual(len(M['failles']['liste']), 5); self.assertGreaterEqual(len(M['rochers']['liste']), 15)

    def test_loi_rom_d30p34a_failles(self):
        L = M['loi_rom']; tones = [tuple(c) for c in L['tons']]
        self.assertEqual((L['pas'], L['ticks_par_pas']), (7, 10)); self.assertEqual(len(tones), 21)
        self.assertEqual(sorted(sum(L['rampes_indices'].values(), [])), list(range(21)))    # 3 rampes = les 21 tons
        self.assertEqual((PH['failles'], TK['failles']), (21, 10))
        ramp = {k: [tones[i] for i in v] for k, v in L['rampes_indices'].items()}
        rift = MASK['rift']; din = ndimage.distance_transform_edt(rift); dout = ndimage.distance_transform_edt(~rift)
        inner, outer1 = rift & (din <= 1), ~rift & (dout <= 1)
        interior = {tuple(c) for c in M['failles']['tons_interieur']}
        for t, a in enumerate(STACK['failles']):
            s = t % 7
            self.assertEqual(colors(a, inner), {ramp['vive'][s]}, t)                        # bord interne = rampe vive au pas s
            self.assertEqual(colors(a, rift & (din > 1) & (din <= 2)), {ramp['moyenne'][s]}, t)
            self.assertEqual(colors(a, outer1), {ramp['sombre'][s]}, t)                     # lueur externe = rampe sombre
            self.assertTrue(colors(a, rift & (din > 2)) <= interior)
            self.assertTrue(alpha(a)[rift].all())
        w = [int((alpha(a) & ~rift & ~MASK['fissures']).sum()) for a in STACK['failles'][:7]]
        self.assertEqual(len(set(w)), 2)                                                     # la lueur bat : 2 largeurs
        self.assertTrue((STACK['failles'][0] != STACK['failles'][7]).any())                  # tourbillon : 21 pas, pas 7
        self.assertTrue(all((STACK['failles'][t] != STACK['failles'][(t + 1) % 21]).any() for t in range(21)))
        cr = MASK['fissures'] & ~(~rift & (dout <= 2))                                        # l'onde court dans les crevasses
        lit = [sum(1 for c in STACK['failles'][t][cr][:, :3].tolist() if tuple(c) in ramp['moyenne'][:3]) for t in range(21)]
        self.assertGreater(min(lit), 20); self.assertGreater(M['failles']['crevasses_px'], 1000)

    def test_vide_rochers(self):
        vf = STACK['vide']; self.assertEqual((PH['vide'], TK['vide']), (7, 30))
        allowed = {tuple(c) for c in M['vide']['tons']} | {tuple(c) for c in B.STAR}
        for a in vf:
            self.assertTrue(colors(a) <= allowed); self.assertTrue((alpha(a) == alpha(vf[0])).all())
        self.assertTrue(all((vf[t] != vf[(t + 1) % 7]).any() for t in range(7)))
        again, _ = B.void_frames(alpha(vf[0]))
        self.assertTrue(all((x == y).all() for x, y in zip(again, vf)))
        self.assertTrue({tuple(c) for c in M['vide']['tons_rom']} <= {tuple(c) for c in M['loi_rom']['tons']})
        rf = STACK['rochers']; self.assertEqual((PH['rochers'], TK['rochers']), (21, 10))
        lab, n = ndimage.label(MASK['rocks']); self.assertEqual(n, len(M['rochers']['liste']))
        base = STACK['rochers']; ref = None
        for d in M['rochers']['liste']:
            m = lab == d['id']; ys, xs = np.nonzero(m)
            t0 = d['phase'] % 21                                                               # dy = 0 : rocher à sa place
            self.assertTrue(alpha(rf[t0])[m].all())
            for t in range(21):
                dy = int(round(d['amp'] * np.sin(2 * np.pi * (t - d['phase']) / 21)))
                self.assertLessEqual(abs(dy), 2)
                ok = (ys + dy >= 0) & (ys + dy < H)
                self.assertTrue((rf[t][ys[ok] + dy, xs[ok]] == rf[t0][ys[ok], xs[ok]]).all(), (d['id'], t))
        self.assertTrue(all((rf[t] != rf[(t + 1) % 21]).any() for t in range(21)))

    def test_zarbi_boucle_fermee(self):
        zs = M['zarbi']['lettres']; self.assertEqual((PH['zarbi'], TK['zarbi']), (84, 5))
        self.assertEqual(''.join(z['lettre'] for z in zs), 'ZARBI!?')
        self.assertEqual(M['scene_loop_ticks'], 84 * 5)
        rifts = {r['id']: r for r in M['failles']['liste']}; rift = MASK['rift']
        for z in zs:
            cx, cy = z['centre']; self.assertEqual(z['centre'], rifts[z['faille']]['centre'])
            pts = [B.zarbi_path(k, cx, cy, z['rx'], z['ry'], z['a0'], z['sens']) for k in range(84)]
            self.assertEqual(sum(p[3] for p in pts), 82)                                       # caché 2 pas sur 84
            self.assertTrue(rift[int(round(pts[0][1])), int(round(pts[0][0]))])               # sort de la faille
            self.assertTrue(rift[int(round(pts[81][1])), int(round(pts[81][0]))])             # y rentre
            self.assertEqual((pts[0][2], pts[81][2]), (0.34, 0.34)); self.assertEqual(pts[40][2], 1)
            for k in range(84):                                                                # trajectoire continue, boucle fermée
                a, b = pts[k], pts[(k + 1) % 84]
                self.assertLess(np.hypot(a[0] - b[0], a[1] - b[1]), 8, (z['lettre'], k))
        tones = {tuple(c) for c in M['zarbi']['tons']}
        halo = {tuple(M['loi_rom']['tons'][i]) for i in M['loi_rom']['rampes_indices']['moyenne']}
        for k, a in enumerate(STACK['zarbi']):
            eye = int((a[..., :3] == np.array(B.Z.EYE_W, 'uint8')).all(2).sum())
            self.assertGreater(eye, 6 * 8, k)                                                  # au moins 6 yeux visibles
            body = colors(a) & (tones | halo)
            self.assertTrue(tones <= body | {tuple(B.Z.PUPIL)})
        again, _, _ = B.zarbi_frames(M['failles']['liste'], np.zeros((H, W, 3), 'uint8'), np.zeros((H, W), bool))

        def spr(x):                                                                            # pixels aux tons des sprites
            return sum(int((x[..., :3] == np.array(c, 'uint8')).all(2).sum()) for c in B.Z.TONES)
        for k in (0, 42, 83):                                                                  # recalcul (sans ombres)
            self.assertEqual(spr(again[k]), spr(STACK['zarbi'][k]), k)

    def test_debris_aspires(self):
        df = STACK['debris']; self.assertEqual((PH['debris'], TK['debris']), (21, 10))
        self.assertEqual(M['debris']['eclats'], 30)
        near = ndimage.distance_transform_edt(~MASK['rift']) < 46
        for a in df:
            self.assertGreater(alpha(a).sum(), 30); self.assertFalse((alpha(a) & ~near).any())
            self.assertFalse((alpha(a) & (MASK['void'] | MASK['rocks'])).any())
        self.assertTrue(all((df[t] != df[(t + 1) % 21]).any() for t in range(21)))

    def test_ora_et_scene(self):
        with zipfile.ZipFile(O / 'RZD1_ruines_zarbi_calques.ora') as z:
            merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
        sc = Image.new('RGBA', (W, H))
        for n in NAMES:
            sc.alpha_composite(Image.fromarray(STACK[n][0]))
        self.assertTrue((np.array(sc) == merged).all())
        self.assertTrue((np.array(sc) == load(O / 'review/RZD1_scene_t000.png')).all())
        for k in ANIM:
            self.assertEqual(M['scene_loop_ticks'] % (PH[k] * TK[k]), 0, k)
        self.assertEqual(M['scene_loop_ticks'], 420)

    def test_acces_sud_autel(self):
        a = M['access']; mk = a['markers']
        self.assertTrue(all(p['ok'] for p in a['chemins_16x16'].values()))
        self.assertEqual(mk['entrance'][1], H - 16)
        walk = alpha(STACK['sol'][0])
        self.assertFalse((walk & (MASK['rift'] | MASK['void'] | MASK['rocks'] | MASK['ruins'])).any())
        self.assertFalse(walk[:, :16].any() or walk[:, -16:].any() or walk[:16].any())           # ni sortie latérale, ni bord haut
        xs = np.nonzero(walk[H - 1])[0]                                                           # une seule sortie : le chemin
        self.assertEqual(len(xs), xs.max() - xs.min() + 1); self.assertLess(len(xs), 240)
        self.assertLess(abs((xs.min() + xs.max()) / 2 - W / 2), 20)
        self.assertLess(mk['autel'][1], H / 3); self.assertLess(abs(mk['autel'][0] + 8 - W / 2), 40)  # autel au nord, centré
        self.assertTrue(MASK['dalles'].sum() > 2000)                                              # joints du chemin rebouchés
        blocked = (~walk).reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > 0.25
        self.assertEqual(int(blocked.sum()), a['blocked_cells'])
        start = (mk['entrance'][1] // 8, mk['entrance'][0] // 8)
        for k in ('autel', 'faille'):
            self.assertTrue(B.reach_map(blocked, start)[mk[k][1] // 8, mk[k][0] // 8], k)
        cut = walk.copy(); cut[H - 120:H - 104, :] = False                                         # couper le chemin : autel perdu
        blocked2 = (~cut).reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > 0.25
        self.assertFalse(B.reach_map(blocked2, start)[mk['autel'][1] // 8, mk['autel'][0] // 8])

    def test_ground_aller_retour(self):
        doc = json.loads((S / f"Data/Ground/{M['pmdo']['asset']}.rsground").read_text()); o = doc['Object']
        self.assertEqual(doc['Version'], '0.8.12.0'); self.assertEqual(len(o['Layers']), len(NAMES) + 1)
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
        self.assertEqual([m['EntName'] for m in o['Entities'][0]['Markers']], ['entrance', 'autel', 'faille'])
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(M['pmdo']['banks']))


if __name__ == '__main__':
    unittest.main()
