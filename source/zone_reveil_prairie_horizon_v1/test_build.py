"""Tests dédiés — Zone de réveil, prairie de Sky Peak face à l'océan (ZRV1 : jour, aube, nuit).
.venv/bin/python -m unittest source.zone_reveil_prairie_horizon_v1.test_build -v
Contrôles d'images, de palettes, de fidélité, de cadence, de boucles et de grille : PAS un test du moteur PMDO.
"""
from pathlib import Path
import hashlib, importlib.util, io, json, unittest, zipfile
import numpy as np
from PIL import Image
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
O = R / 'renders/zone_reveil_prairie_horizon_v1'
M = json.loads((O / 'manifest.json').read_text())
W, H = M['size_px']


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp); sp.loader.exec_module(m); return m


B = loadmod('zrv1_build', HERE / 'build.py')
S = B.STAGE


def load(p):
    return np.array(Image.open(p).convert('RGBA'))


def alpha(a):
    return a[..., 3] > 0


def expand(L):
    if L['phases'] == 1:
        return [load(O / L['file'])]
    return [load(O / L['file'].replace('fNNN', f'f{t:03d}')) for t in range(L['phases'])]


STACKS = {amb: [expand(L) for L in M['ambiances'][amb]['layers']] for amb in B.AMB}
BY = {amb: dict(zip(B.ORDER, st)) for amb, st in STACKS.items()}
MASK = {k: np.array(Image.open(O / f'masques/ZRV1_masque_{k}.png')) > 0
        for k in ('panorama', 'mer', 'herbe', 'chemin', 'fleurs', 'rochers', 'buissons', 'praticable')}
MEADOW = MASK['herbe'] | MASK['chemin'] | MASK['fleurs'] | MASK['rochers'] | MASK['buissons']


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def idx(name):
    a = np.array(Image.open(O / f'masques/ZRV1_{name}_index.png')).astype(int)
    return np.where(a == 255, -1, a // 25)


def colors(frames):
    return {tuple(int(v) for v in c) for f in frames for c in f[f[..., 3] == 255][:, :3]}


class Build(unittest.TestCase):
    def test_bruts_references_et_prompts(self):
        for r in M['raw_inputs']:
            self.assertEqual(sha(R / r['file']), r['sha256'], r['file'])
        for k, v in M['references'].items():
            self.assertEqual(sha(R / v['file']), v['sha256'], k)
        g = {x['file']: x for x in M['generation']}
        self.assertEqual(set(g), {'decor_jour.png', 'decor_nuit.png', 'decor_aube.png', 'nuages_sprites.png'})
        self.assertIn('232233.png', g['decor_jour.png']['images'])                          # cimes en référence
        self.assertTrue(any('s01p02a' in i for i in g['decor_jour.png']['images']))          # mer du jeu en référence
        self.assertTrue(any('skypeak_gif_frame0' in i for i in g['decor_jour.png']['images']))
        self.assertIn('bgnightbackgroundpmdskyda.png', g['decor_nuit.png']['images'])        # nuit native en référence
        self.assertIn(f'{B.LOT}/bruts/decor_jour.png', g['decor_aube.png']['images'])
        gif = Image.open(R / '2cwdrrs469f61.gif'); gif.seek(0)
        self.assertTrue((np.array(gif.convert('RGB')) == np.array(Image.open(HERE / 'references/skypeak_gif_frame0.png').convert('RGB'))).all())
        for x in M['raw_inputs'][:3]:
            self.assertEqual(x['size'], [1200, 896])
        self.assertFalse(M['art_approved']); self.assertFalse(M['runtime_tested'])

    def test_recalage_des_editions(self):
        day = B.rgb(B.RAW / 'decor_jour.png'); m, sg = B.seg.classify(day)
        zone = (np.mgrid[:896, :1200][0] > sg['horizon_y'] + 200) & ~m['buissons']
        for k in ('nuit', 'aube'):
            self.assertEqual(B.recalage(day, B.rgb(B.RAW / f'decor_{k}.png'), zone), M['recalage'][k])   # (0, 0) le meilleur

    def test_fidelite_skypeak(self):
        for k, v in M['fidelite_rip']['brut'].items():
            self.assertLess(v['distance'], 35, k)
        for k, v in M['fidelite_rip']['calques_finaux'].items():
            self.assertLess(v['distance_rip'], 35, k)
        gif = B.rgb(HERE / 'references/skypeak_gif_frame0.png')[150:]
        fm = B.skypeak_materials(gif)
        self.assertEqual([round(float(x), 1) for x in gif[fm['herbe']].mean(0)], M['fidelite_rip']['brut']['herbe']['rip_rgb'])

    def test_partition_et_calques(self):
        for amb, by in BY.items():
            self.assertEqual(list(by), B.ORDER)
            self.assertTrue(alpha(by['sol_complet'][0]).all())
            parts = [alpha(by[k][0]) for k in B.STATIC] + [alpha(by['mer'][0]), alpha(by['ecume'][0])]
            self.assertTrue((np.sum(parts, 0) == 1).all(), amb)                        # partition exacte
            for k in B.STATIC:
                self.assertTrue((alpha(by[k][0]) == MASK[k]).all(), (amb, k))
                self.assertTrue(set(np.unique(by[k][0][..., 3])) <= {0, 255})
            for k in B.ANIMS:
                for f in by[k]:
                    self.assertTrue(set(np.unique(f[..., 3])) <= {0, 255}, (amb, k))   # pas d'alpha intermédiaire
            self.assertTrue(((alpha(by['mer'][0]) | alpha(by['ecume'][0])) == MASK['mer']).all())
        yh = M['horizon_y_final']
        self.assertFalse(MASK['panorama'][yh:].any()); self.assertTrue(MASK['panorama'][:yh].all())
        self.assertFalse(MASK['mer'][:yh].any())
        # Promontoire : la mer entoure le haut de la prairie ; la prairie touche le bord sud sur toute la largeur.
        self.assertTrue(MEADOW[H - 1].all())
        top = np.nonzero(MEADOW.any(1))[0].min(); self.assertTrue(MASK['mer'][top:top + 20, :40].all())
        self.assertTrue(MASK['mer'][top:top + 20, -40:].all())

    def test_mer_rotation_de_palette_du_jeu(self):
        rep = json.loads(B.STUDY.read_text())['cartes']['s01p02a']['palettes_animees']
        p7 = np.array(next(p for p in rep if p['palette'] == 7)['couleurs'], 'uint8')
        p8 = np.array(next(p for p in rep if p['palette'] == 8)['couleurs'], 'uint8')
        self.assertEqual(M['etude_palettes']['sha256'], sha(B.STUDY))
        self.assertTrue((np.array(M['ambiances']['jour']['mer_palette_7']) == p7).all())      # jour : couleurs EXACTES
        self.assertTrue((np.array(M['ambiances']['jour']['ecume_palette_8']) == p8).all())
        i7, i8 = idx('mer'), idx('ecume')
        want7, want8, _ = B.sea_fields(MASK['mer'], MEADOW, M['horizon_y_final'],
                                       B.lum_of(B.down_full(B.rgb(B.RAW / 'decor_jour.png')).astype(float)) > 215)
        self.assertTrue((i7 == want7).all()); self.assertTrue((i8 == want8).all())
        for amb in B.AMB:
            am = M['ambiances'][amb]; pal7, pal8 = np.array(am['mer_palette_7'], 'uint8'), np.array(am['ecume_palette_8'], 'uint8')
            zones = []
            if am['reflet_palette_7']:
                zones = [(np.array(Image.open(O / f'masques/ZRV1_{amb}_reflet.png')) > 0, np.array(am['reflet_palette_7'], 'uint8'))]
            self.assertEqual(len(BY[amb]['mer']), 10); self.assertEqual(len(BY[amb]['ecume']), 10)
            for s, (f, g) in enumerate(zip(B.palette_frames(i7, pal7, zones), B.palette_frames(i8, pal8))):
                self.assertTrue((BY[amb]['mer'][s] == f).all(), (amb, s)); self.assertTrue((BY[amb]['ecume'][s] == g).all(), (amb, s))
            L = {Path(x['file']).name.split('_', 2)[2].split('_f')[0]: x for x in am['layers']}
            self.assertEqual((L['mer']['phases'], L['mer']['ticks']), (10, 10))      # 10 crans x 10 ticks = la mer du jeu
            self.assertEqual((L['ecume']['phases'], L['ecume']['ticks']), (10, 10))
        self.assertTrue(colors(BY['jour']['mer']) <= {tuple(int(v) for v in c) for c in p7.reshape(-1, 3)})
        self.assertTrue(colors(BY['jour']['ecume']) <= {tuple(int(v) for v in c) for c in p8.reshape(-1, 3)})
        # Les vagues avancent vers le rivage : dans chaque colonne, l'index croît avec y (bandes de haut en bas), et la
        # crête (couleur de base 7 = index 7 + cran) est à l'index 7 + s au cran s.
        col = i7[:, 200]; ys = np.nonzero(col >= 0)[0]
        steps = np.diff(col[ys]); steps = steps[steps != 0]
        self.assertGreater(float(((steps == 1) | (steps == -9)).mean()), 0.95)       # 0 -> 1 -> ... -> 9 -> 0 vers le sud
        for s in range(10):
            crest = (i7 == (7 + s) % 10)
            self.assertTrue((BY['jour']['mer'][s][crest][:, :3] == p7[0][7]).all())
        # Bandes : la plus fine fait au moins 0,8 px à l'horizon, période plus grande au rivage qu'à l'horizon.
        self.assertGreaterEqual(B.P_HORIZON * min(B.BAND) / sum(B.BAND), 0.8)
        # Écume : index 9 au bord, 8 juste après ; elle passe au blanc à un cran au moins.
        dist = nd.distance_transform_edt(~MEADOW)
        self.assertTrue((i8[MASK['mer'] & (dist <= B.FOAM_IN)] == 9).all())
        self.assertTrue((dist[i8 >= 0] <= B.FOAM_OUT).all())
        wh = [float((B.lum_of(f[i8 >= 0][:, :3].astype(float)) > 200).mean()) for f in BY['jour']['ecume']]
        self.assertGreater(max(wh), 0.3); self.assertLess(min(wh), 0.1)

    def test_aube_nuit_transposition_et_reflet(self):
        day = B.rgb(B.RAW / 'decor_jour.png'); day_l = B.lum_of(B.down_full(day).astype(float))
        i8 = idx('ecume'); sea = MASK['mer']
        p7 = np.array(M['ambiances']['jour']['mer_palette_7'], 'uint8'); p8 = np.array(M['ambiances']['jour']['ecume_palette_8'], 'uint8')
        for amb in ('aube', 'nuit'):
            am = M['ambiances'][amb]; af = B.down_full(B.rgb(B.RAW / f'decor_{amb}.png')).astype(int)
            refl = np.array(Image.open(O / f'masques/ZRV1_{amb}_reflet.png')) > 0
            self.assertEqual(int(refl.sum()), am['reflet_px']); self.assertGreater(am['reflet_px'], 2000)
            self.assertTrue((refl <= sea).all())
            want = B.transpose_palette(p7, day_l, af, sea & (i8 < 0) & ~refl)
            self.assertTrue((np.array(am['mer_palette_7']) == want).all(), amb)
            self.assertTrue((np.array(am['ecume_palette_8']) == B.transpose_palette(p8, day_l, af, sea & ~refl)).all())
            ys, xs = np.nonzero(refl)                                                  # une colonne sous l'astre
            self.assertLess(xs.max() - xs.min(), W * 0.6)
            rl = B.lum_of(np.array(am['reflet_palette_7'], float).reshape(-1, 3)).mean()
            nl = B.lum_of(np.array(am['mer_palette_7'], float).reshape(-1, 3)).mean()
            self.assertGreater(rl, nl + 20)                                            # le reflet est plus clair
        n = B.lum_of(np.array(M['ambiances']['nuit']['mer_palette_7'], float).reshape(-1, 3)).mean()
        d = B.lum_of(p7.reshape(-1, 3).astype(float)).mean()
        self.assertLess(n, d - 30)                                                     # la mer de nuit est sombre

    def test_nuages_boucle_et_zone(self):
        for amb in B.AMB:
            fr = BY[amb]['nuages']; self.assertEqual(len(fr), B.CLOUD_PHASES)
            strips = {n: load(O / f'masques/ZRV1_{amb}_nuages_bande_{n}.png') for n in B.CLOUD_ROWS}
            for t, want in enumerate(B.cloud_frames(strips)):                          # les 192 phases
                self.assertTrue((want == fr[t]).all(), (amb, t))
            self.assertTrue((B.cloud_frames(strips, ts=[B.CLOUD_PHASES])[0] == fr[0]).all())   # boucle fermée
            for f in fr[::16]:
                ys = np.nonzero(alpha(f).any(1))[0]
                self.assertLess(int(ys.max()), M['horizon_y_final'])                  # jamais sur la mer ni la prairie
            a0 = alpha(fr[0]).sum()
            self.assertTrue(all(abs(int(alpha(f).sum()) - a0) <= a0 * 0.02 for f in fr[::8]))   # les nuages passent, entiers
            self.assertFalse((fr[0] == fr[1]).all())
        for row in B.CLOUD_ROWS.values():
            self.assertEqual(row['pas'] * B.CLOUD_PHASES % row['periode'], 0)
            self.assertEqual(W % row['periode'], 0)
        night = load(R / B.REFS['nuit'])[..., :3].reshape(-1, 3)
        self.assertTrue(colors(BY['nuit']['nuages']) <= {tuple(int(v) for v in c) for c in night})   # nuit : couleurs natives

    def test_bulles_et_scintillements(self):
        for amb in B.AMB:
            am = M['ambiances'][amb]; bub = [tuple(b) for b in am['bulles']]
            cols = [tuple(c) for c in am['bulles_couleurs']]
            want = B.bubble_frames(bub, cols)
            for t in range(B.PHASES):
                self.assertTrue((BY[amb]['bulles'][t] == want[t]).all(), (amb, t))
                self.assertTrue((alpha(want[t]) <= MASK['mer']).all(), (amb, t))       # toujours sur la mer
            self.assertTrue((B.bubble_frames(bub, cols, ts=[B.PHASES])[0] == want[0]).all())
            self.assertEqual(len(bub), B.BUBBLES)
            sc = am['scintillements']
            sparks = [([tuple(p) for p in px], [tuple(p) for p in co], off) for px, co, off in zip(sc['pixels'], sc['coeurs'], sc['decalages'])]
            got = B.sparkle_frames(sparks)
            for t in range(B.PHASES):
                self.assertTrue((BY[amb]['scintillements'][t] == got[t]).all(), (amb, t))
            self.assertTrue((B.sparkle_frames(sparks, ts=[B.PHASES])[0] == got[0]).all())
            zone = MASK['panorama'] if amb == 'nuit' else MASK['mer']
            for f in got:
                self.assertTrue((alpha(f) <= zone).all(), amb)
            self.assertGreaterEqual(sc['n'], 8)    # nuit : 9 étoiles dans le brut (bord de lune et de nuages exclus)
        p7 = {tuple(c) for s in M['ambiances']['jour']['mer_palette_7'] for c in s}
        p8 = {tuple(c) for s in M['ambiances']['jour']['ecume_palette_8'] for c in s}
        self.assertTrue(colors(BY['jour']['scintillements']) <= p7); self.assertTrue(colors(BY['jour']['bulles']) <= p8)
        # Nuit : étoiles aux couleurs du brut, retirées du panorama (le ciel est dessous).
        af = B.down_full(B.rgb(B.RAW / 'decor_nuit.png')).astype(int); pan = BY['nuit']['panorama'][0]
        for px in M['ambiances']['nuit']['scintillements']['pixels']:
            for y, x, r, g, b in px:
                self.assertEqual((r, g, b), tuple(af[y, x]))
                self.assertLess(B.lum_of(pan[y, x, :3].astype(float)), B.lum_of(np.array([r, g, b], float)))

    def test_access_et_reveil(self):
        a = M['access']; self.assertTrue(a['path_found_16x16'])
        ex, ey = a['entry_px']; rx, ry = a['reveil_px']; P = MASK['praticable']
        self.assertGreater(ey, H - 64); self.assertTrue(P[ey:ey + 16, ex:ex + 16].all())            # sortie au sud
        self.assertTrue(MASK['chemin'][ey:ey + 16, ex:ex + 16].any())
        self.assertTrue(P[ry:ry + 16, rx:rx + 16].all())
        self.assertLess(abs(rx + 8 - W // 2), 16)                                    # centré
        self.assertTrue(MASK['mer'][max(0, ry - 28):ry, rx:rx + 16].any())             # face à l'océan, tout près
        self.assertLess(ry, H // 2)
        for amb in B.AMB:
            doc = json.loads((S / f"Data/Ground/{B.ASSET[amb]}.rsground").read_text())
            blocked = np.array([[c['Tags'] for c in col] for col in doc['Object']['obstacles']]).T.astype(bool)
            self.assertEqual(int(blocked.sum()), a['blocked_cells'])
            for k in ('mer', 'panorama', 'rochers', 'buissons'):
                cells = MASK[k].reshape(H // 8, 8, W // 8, 8).mean((1, 3)) > 0.5
                self.assertTrue(blocked[cells].all(), (amb, k))
            cells = P.reshape(H // 8, 8, W // 8, 8).mean((1, 3)) == 1
            self.assertFalse(blocked[cells].any())
            mk = {m['EntName']: m for m in doc['Object']['Entities'][0]['Markers']}
            self.assertEqual(set(mk), {'reveil', 'entrance'})
            self.assertEqual([mk['reveil']['Collider']['X'], mk['reveil']['Collider']['Y']], a['reveil_px'])
            self.assertEqual(mk['reveil']['Direction'], 4)                             # regarde le nord (l'océan)
        for k in ('mer', 'panorama', 'rochers', 'buissons'):
            self.assertFalse((P & MASK[k]).any(), k)
        self.assertGreater(float(P[MASK['herbe']].mean()), 0.97)

    def test_ora_et_scenes(self):
        for amb, st in STACKS.items():
            with zipfile.ZipFile(O / f'ZRV1_zone_reveil_{amb}_calques.ora') as z:
                merged = np.array(Image.open(io.BytesIO(z.read('mergedimage.png'))).convert('RGBA'))
                self.assertEqual(sum(1 for n in z.namelist() if n.startswith('data/layer')), len(B.ORDER))
            comp = Image.new('RGBA', (W, H))
            for fr in st:
                comp.alpha_composite(Image.fromarray(fr[0]))
            self.assertTrue((np.array(comp) == merged).all(), amb)
            self.assertTrue((load(O / f'review/ZRV1_{amb}_scene_t000.png') == merged).all(), amb)

    def test_prefixe_et_namespace_uniques(self):
        for p in (R / 'source').glob('*/build*.py'):
            if p.parent != HERE:
                s = p.read_text(errors='ignore')
                self.assertNotIn("PFX = 'ZRV1'", s, p); self.assertNotIn("'zone_reveil_prairie_horizon'", s, p)
        names = [p.name for p in (O / 'calques').rglob('*.png')] + [p.name for p in (O / 'animation').rglob('*.png')]
        self.assertEqual(len(names), len(set(names)))                                  # basenames uniques (import Tileset)

    def test_ground_roundtrip(self):
        nr = loadmod('native_reader', R / 'source/cote_v5_expeditions/audit_references.py')
        banks = {p.stem: nr.tiles(p)[1] for p in (S / 'Content/Tile').glob('*.tile')}
        self.assertEqual(set(banks), set(M['pmdo']['tiles_per_bank']))
        tools = loadmod('index_tools', R / 'source/pmdo_cote/INSTALLER.py')
        self.assertEqual(set(tools.read_index(S / 'Content/Tile/index.idx')), set(banks))
        for amb in B.AMB:
            self.assertTrue(all(any(b.startswith(f'ZRV1{B.AMB[amb]}_{i:02d}_') for b in banks) for i in range(len(B.ORDER))))
            doc = json.loads((S / f"Data/Ground/{B.ASSET[amb]}.rsground").read_text()); o = doc['Object']
            self.assertEqual(doc['Version'], '0.8.12.0'); self.assertEqual(len(o['Layers']), len(B.ORDER) + 1)
            self.assertEqual(o['Layers'][-1]['Layer'], 4)
            for li, (frames, L) in enumerate(zip(STACKS[amb], M['ambiances'][amb]['layers'])):
                for t in sorted({0, len(frames) // 2, len(frames) - 1}):
                    out = np.zeros((H, W, 4), 'uint8')
                    for x, col in enumerate(o['Layers'][li]['Tiles']):
                        for y, cell in enumerate(col):
                            for track in cell['Layers']:
                                if len(track['Frames']) > 1:
                                    self.assertEqual((len(track['Frames']), track['FrameLength']), (len(frames), L['ticks']))
                                f = track['Frames'][t % len(track['Frames'])]
                                out[y*8:y*8+8, x*8:x*8+8] = np.array(nr.straight(banks[f['Sheet']][f['TexLoc']['X'], f['TexLoc']['Y']]))
                    self.assertTrue((out == frames[t]).all(), (amb, li, t))


if __name__ == '__main__':
    unittest.main()
