"""Point d'entrée historique vers les tests ETT2 maintenus sous source/."""
import unittest

from source.entree_tour_temporelle_sud_nord_v2.test_build import main as verify_outputs


class TestETT2Compatibility(unittest.TestCase):
    def test_generated_map_pipeline_outputs(self):
        verify_outputs()


if __name__ == '__main__':
    verify_outputs()
