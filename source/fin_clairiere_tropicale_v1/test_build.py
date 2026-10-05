#!/usr/bin/env python3
"""Smoke tests for FCT2 segmentation, day/night effects and PMDO stage."""
from pathlib import Path
import sys
import unittest

import numpy as np

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(HERE))

import build as production
import verify as native_verify


class FCT2ProductionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.decor = production.rgb(production.RAW / 'decor.png')
        cls.underlay = production.rgb(production.RAW / 'sol_complet.png')

    def test_segmentation_partitions_pixels_and_keeps_floor_unknowns_walkable(self):
        masks, counts = production.classify(self.decor, self.underlay)
        coverage = np.sum(np.stack(list(masks.values()), axis=0), axis=0)
        self.assertTrue(np.all(coverage == 1))
        self.assertGreater(counts['unclassified_floor_pixels'], 0)
        self.assertGreater(counts['foliage_preserved_inside_arena_pixels'], 0)
        material_foliage = production.materials(self.decor)['feuillage']
        walkable = masks['clairiere'] | masks['ombres']
        self.assertFalse(np.any(material_foliage & walkable))
        self.assertTrue(np.any(material_foliage & (masks['jungle'] | masks['canopee_avant'])))
        self.assertGreater(counts['shrine_pixels'], 0)

    def test_day_stone_is_neutralized_without_green_cast(self):
        layers, _, _, _ = production.quantized_layers(self.decor, self.underlay)
        for name in ('roches', 'sanctuaire'):
            layer = layers[name]
            pixels = layer[layer[..., 3] > 0]
            self.assertGreater(len(pixels), 0)
            self.assertTrue(np.all(pixels[:, 0] >= pixels[:, 1]))
            self.assertTrue(np.all(pixels[:, 1] >= pixels[:, 2]))

    def test_night_map_is_generator_output_with_cool_neutral_stones(self):
        night = production.rgb(production.RAW / 'decor_nuit.png')
        night_underlay = production.rgb(production.RAW / 'sol_complet_nuit.png')
        day_masks, _ = production.classify(self.decor, self.underlay)
        layers, _, _, _ = production.quantized_layers(
            night, night_underlay, masks_override=day_masks, night=True)
        for name in ('roches', 'sanctuaire'):
            pixels = layers[name][layers[name][..., 3] > 0]
            self.assertGreater(len(pixels), 0)
            self.assertTrue(np.all(pixels[:, 0] <= pixels[:, 1]))
            self.assertTrue(np.all(pixels[:, 1] <= pixels[:, 2]))

    def test_night_lights_are_low_opacity_and_animated(self):
        frames = production.night_light_frames()
        self.assertEqual(len(frames), 24)
        alphas = np.stack([frame[..., 3] for frame in frames])
        self.assertEqual(int(alphas.max()), 55)
        self.assertLessEqual(int(alphas.max()), 64)
        self.assertGreater(int(alphas[alphas > 0].min()), 0)
        self.assertTrue(np.any(frames[0] != frames[1]))

    def test_both_native_grounds_reconstruct_and_install_safely(self):
        report = native_verify.verify(native_verify.STAGE)
        self.assertEqual(report['result'], 'PASS')
        self.assertEqual(set(report['variants']), {'jour', 'nuit'})
        self.assertEqual(report['pixel_differences'], 0)
        self.assertEqual(report['native_layers_reconstructed'], 17)
        self.assertEqual(report['animation_frames_reconstructed'], 72)
        self.assertEqual(report['ora_documents_checked'], 2)
        for metrics in report['generated_map_reconstruction'].values():
            self.assertLess(metrics['mean_absolute_rgb_error'], 10)
            self.assertGreater(metrics['pixels_with_max_channel_error_le_8_percent'], 80)
        self.assertFalse(report['pmdo_engine_or_dotnet_tested'])
        self.assertTrue(report['installer']['index_merge'])
        self.assertTrue(report['installer']['both_variants_installed'])
        self.assertTrue(report['installer']['conflict_protected'])


if __name__ == '__main__':
    unittest.main(verbosity=2)
