"""Tests FMT2 : provenance, calques, animations exactes, segmentation, accès, ORA et codec Ground/.tile.

Ces tests vérifient les artefacts locaux; ils ne lancent pas le moteur PMDO.
Commande : .venv/bin/python -m unittest source.fin_mt_thunder_v1.test_build -v
"""
from pathlib import Path
import hashlib, importlib.util, io, json, struct, subprocess, sys, unittest, zipfile

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
LOT = 'fin_mt_thunder_v1'
OUT = ROOT / 'renders' / LOT
STAGE = ROOT / '.cache' / LOT / 'fin_mt_thunder'
BUILD = HERE / 'build.py'
PFX = 'FMT2'


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f'Module introuvable: {path}')
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def rgba(path):
    with Image.open(path) as image:
        return np.asarray(image.convert('RGBA'), dtype=np.uint8)


def rgba_from_bytes(raw):
    with Image.open(io.BytesIO(raw)) as image:
        return np.asarray(image.convert('RGBA'), dtype=np.uint8)


def read_tile_bank(path):
    raw = path.read_bytes()
    tile_size, count = struct.unpack_from('<ii', raw, 0)
    assert tile_size == 8, f'tuile native inattendue dans {path}: {tile_size}'
    result, cache = {}, {}
    for i in range(count):
        x, y, offset = struct.unpack_from('<iiq', raw, 8 + 16 * i)
        length, = struct.unpack_from('<q', raw, offset)
        assert 8 + count * 16 <= offset and length >= 1 and offset + 8 + length <= len(raw), f'offset .tile invalide: {path}'
        if offset not in cache:
            tile = rgba_from_bytes(raw[offset + 8:offset + 8 + length]).astype(np.uint32)
            alpha = tile[..., 3:4]
            tile[..., :3] = np.minimum(255, (tile[..., :3] * 255 + alpha // 2) // np.maximum(alpha, 1))
            tile[alpha[..., 0] == 0] = 0
            cache[offset] = tile.astype(np.uint8)
        assert (x, y) not in result, f'tuile dupliquée dans {path}: {(x, y)}'
        result[(x, y)] = cache[offset]
    return result


def reconstruct_layer_first_frame(obj, banks, layer_index, width=96, height=72):
    output = np.zeros((height * 8, width * 8, 4), dtype=np.uint8)
    layer = obj['Layers'][layer_index]
    for x, column in enumerate(layer['Tiles']):
        for y, tile in enumerate(column):
            if not tile['Layers']:
                continue
            frame = tile['Layers'][0]['Frames'][0]
            output[y*8:(y+1)*8, x*8:(x+1)*8] = banks[frame['Sheet']][(frame['TexLoc']['X'], frame['TexLoc']['Y'])]
    return output


class FMT2Build(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not (OUT / 'manifest.json').exists() or not (STAGE / 'Mod.xml').exists():
            subprocess.run([sys.executable, str(BUILD)], cwd=ROOT, check=True)
        cls.manifest = json.loads((OUT / 'manifest.json').read_text(encoding='utf-8'))
        cls.width, cls.height = cls.manifest['size_px']
        cls.layers = cls.manifest['layers']
        cls.ground_path = STAGE / 'Data/Ground' / f"{cls.manifest['asset']}.rsground"
        cls.doc = json.loads(cls.ground_path.read_text(encoding='utf-8'))
        cls.obj = cls.doc['Object']
        cls.build = load_module('fmt2_build_mod', BUILD)

    def test_input_hashes_and_review_flags(self):
        for source in self.manifest['inputs']:
            path = ROOT / source['file']
            self.assertTrue(path.is_file(), path)
            self.assertEqual(hashlib.sha256(path.read_bytes()).hexdigest(), source['sha256'])
            with Image.open(path) as image:
                self.assertEqual(list(image.size), source['size_px'])
        self.assertFalse(self.manifest['art_approved'])
        self.assertFalse(self.manifest['runtime_tested'])
        self.assertFalse(self.manifest['pmdo']['runtime_tested'])

    def test_dimensions_layers_and_binary_alpha(self):
        self.assertEqual((self.width, self.height), (768, 576))
        self.assertEqual(self.manifest['grid_cells'], [96, 72])
        self.assertEqual((self.width % 8, self.height % 8), (0, 0))
        self.assertEqual(len(self.layers), 11)          # 8 statiques + lueurs + éclairs + top
        anims = [l for l in self.layers if l['phases'] > 1]
        self.assertEqual(len(anims), 2)
        for item in anims:
            self.assertEqual(item['phases'], 48)
            self.assertEqual(item['ticks'], 5)
            for t in range(48):
                frame = rgba(OUT / item['file'].replace('fNN', f'f{t:02d}'))
                self.assertEqual(frame.shape, (self.height, self.width, 4))
                self.assertTrue(set(np.unique(frame[..., 3])) <= {0, 255}, f"{item['file']} f{t:02d}")
        for item in self.layers:
            if item['phases'] == 1:
                image = rgba(OUT / item['file'])
                self.assertEqual(image.shape, (self.height, self.width, 4), item['file'])
                self.assertTrue(set(np.unique(image[..., 3])) <= {0, 255}, item['file'])
        base = rgba(OUT / self.layers[0]['file'])
        self.assertTrue(np.all(base[..., 3] == 255), 'le sol complet doit rester une base opaque')
        top = rgba(OUT / f'calques/{PFX}_10_top.png')
        self.assertFalse(np.any(top), 'le calque Top éditorial doit être vide')

    def test_masks_partition_every_pixel_and_scene_opaque(self):
        masks = []
        for name in ('sable', 'cailloux', 'pics', 'profondeur', 'falaise', 'ciel', 'nuages'):
            mask = np.asarray(Image.open(OUT / 'masques' / f'{PFX}_masque_{name}.png').convert('L')) > 0
            self.assertEqual(mask.shape, (self.height, self.width))
            masks.append(mask)
        coverage = np.stack(masks).sum(axis=0)
        self.assertTrue(np.all(coverage == 1), 'les matières doivent couvrir la carte sans chevauchement')
        self.assertTrue(np.all(rgba(OUT / f'review/{PFX}_scene_t000.png')[..., 3] == 255))

    def test_fidelity_under_threshold(self):
        fid = self.manifest['fidelite']
        for key in ('sable', 'roche', 'ciel', 'nuages_sombres', 'nuages_clairs'):
            self.assertLess(fid[key]['distance'], fid['seuil'], key)
            self.assertEqual(len(fid[key]['rip_rgb']), 3)

    def test_lightning_exact_pixels_and_loop(self):
        sw = self.manifest['eclairs']['couleurs']
        allowed_bolt = {tuple(sw['normal'][1]), tuple(sw['fading'][1])}
        allowed_flash = {tuple(sw['normal'][0]), tuple(sw['fading'][0])}
        ecl = rgba(OUT / f'animation/eclairs/{PFX}_09_eclairs_f00.png')
        lue = rgba(OUT / f'animation/lueurs/{PFX}_08_lueurs_f00.png')
        px_ecl = {tuple(v) for v in np.unique(ecl[ecl[..., 3] > 0][:, :3], axis=0)}
        px_lue = {tuple(v) for v in np.unique(lue[lue[..., 3] > 0][:, :3], axis=0)}
        self.assertTrue(px_ecl <= allowed_bolt, px_ecl - allowed_bolt)
        self.assertTrue(px_lue <= allowed_flash, px_lue - allowed_flash)
        # boucle exacte : 6 frappes x 4 phases éclairées, motif périodique de 48
        b = self.build
        lit = sum(1 for t in range(48) for (_, _, _, _, _, off) in
                  [(0, 0, 0, 0, 0, off) for (_, _, _, _, off) in b.STRIKES] if b.strike_state((t - off) % 48))
        self.assertEqual(lit, 24)
        states = [b.strike_state(t % 48) for t in range(96)]
        self.assertEqual(states[:48], states[48:])
        for hit in self.manifest['eclairs']['part_sol']:
            self.assertLess(hit['sur_sable'], 0.3, hit)

    def test_markers_south_centre_north_and_16px_reachable(self):
        access = self.manifest['access']
        self.assertTrue(access['path_to_boss_16x16'])
        self.assertTrue(access['path_to_objective_16x16'])
        self.assertGreater(access['entry_px'][1], access['boss_px'][1])
        self.assertGreater(access['boss_px'][1], access['objective_px'][1])
        self.assertGreater(access['entry_px'][1], self.height - 120)
        self.assertLess(abs(access['boss_px'][0] - self.width // 2), 80)
        self.assertLess(abs(access['objective_px'][0] - self.width // 2), 80)
        mask = np.asarray(Image.open(OUT / f'masques/{PFX}_masque_praticable.png').convert('L')) > 0
        blocked = self.build.cell_grid(~mask)
        self.assertEqual(int(blocked.sum()), access['blocked_cells'])
        for point in (access['entry_px'], access['boss_px'], access['objective_px']):
            self.assertTrue(self.build.footprint_free(blocked, point[1] // 8, point[0] // 8))
        self.assertTrue(self.build.reachable_2x2(blocked, tuple(access['entry_cell_yx']),
                                                 tuple(access['boss_cell_yx']))[0])
        self.assertTrue(self.build.reachable_2x2(blocked, tuple(access['entry_cell_yx']),
                                                 tuple(access['objective_cell_yx']))[0])

    def test_ground_has_only_three_edit_markers_and_no_exit_or_warp(self):
        self.assertEqual(self.doc['Version'], '0.8.12.0')
        self.assertEqual(self.obj['TexSize'], 1)
        self.assertEqual(self.obj['AssetName'], 'fmt2_fin_mt_thunder')
        self.assertEqual(len(self.obj['Layers']), 11)
        self.assertEqual(len(self.obj['obstacles']), 96)
        self.assertEqual(len(self.obj['obstacles'][0]), 72)
        entities = self.obj['Entities']
        self.assertEqual(len(entities), 1)
        self.assertEqual([m['EntName'] for m in entities[0]['Markers']], ['entrance', 'boss', 'objectif'])
        self.assertFalse(entities[0]['MapChars'])
        self.assertFalse(entities[0]['GroundObjects'])
        self.assertFalse(entities[0]['Spawners'])
        for marker in entities[0]['Markers']:
            self.assertEqual(marker['Collider']['Width'], 16)
            self.assertEqual(marker['Collider']['Height'], 16)
        self.assertNotIn('Warp', self.obj)
        self.assertNotIn('warp', self.obj)
        self.assertEqual(self.manifest['pmdo']['warp'], 'aucun')
        self.assertEqual(self.manifest['pmdo']['exit'], 'aucune')

    def test_ground_tile_banks_round_trip_first_frames(self):
        paths = sorted((STAGE / 'Content/Tile').glob(f'{PFX}_*.tile'))
        self.assertEqual(len(paths), 10)
        banks = {path.stem: read_tile_bank(path) for path in paths}
        for item in self.layers[:10]:
            index = item['order']
            restored = reconstruct_layer_first_frame(self.obj, banks, index)
            expected_file = OUT / (item['file'].replace('fNN', 'f00') if item['phases'] > 1 else item['file'])
            self.assertTrue(np.array_equal(restored, rgba(expected_file)), item['name'])
        tools = load_module('fmt2_index_verify', ROOT / 'source/pmdo_cote/INSTALLER.py')
        decoded = {}
        for path in paths:
            with path.open('rb') as stream:
                decoded[path.stem] = tools.read_node(stream)
        self.assertEqual(set(decoded), set(banks))
        index_data = (STAGE / 'Content/Tile/index.idx').read_bytes()
        self.assertEqual(struct.unpack_from('<i', index_data, 0)[0], len(paths))

    def test_openraster_round_trip_matches_scene(self):
        ora_path = OUT / f'{PFX}_fin_mt_thunder_calques.ora'
        self.assertTrue(ora_path.is_file())
        with zipfile.ZipFile(ora_path) as archive:
            self.assertEqual(archive.read('mimetype'), b'image/openraster')
            self.assertTrue({'stack.xml', 'mergedimage.png', 'Thumbnails/thumbnail.png'} <= set(archive.namelist()))
            merged = rgba_from_bytes(archive.read('mergedimage.png'))
            stack_xml = archive.read('stack.xml').decode('utf-8')
            self.assertIn('00_sol_complet', stack_xml)
            self.assertIn('08_lueurs_f00', stack_xml)
        self.assertTrue(np.array_equal(merged, rgba(OUT / f'review/{PFX}_scene_t000.png')))

    def test_collision_overlay_and_animated_preview(self):
        preview = rgba(OUT / f'review/{PFX}_collisions_marqueurs.png')
        self.assertEqual(preview.shape, (self.height, self.width, 4))
        self.assertGreater(int(np.count_nonzero(preview[..., 0] > preview[..., 1] + 40)), 0)
        webp = OUT / f'review/{PFX}_scene_animee.webp'
        self.assertTrue(webp.is_file())
        with Image.open(webp) as image:
            self.assertGreater(getattr(image, 'n_frames', 1), 1)
        template = (HERE / 'viewer_template.html').read_text(encoding='utf-8')
        self.assertIn('__DATA__', template)
        self.assertIn('FMT2', template)


if __name__ == '__main__':
    unittest.main()
