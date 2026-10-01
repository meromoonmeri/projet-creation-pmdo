"""Tests dédiés — RAF3 (Réseau Zone Zéro V2, route fleurie), 4:3.
.venv/bin/python -m unittest source.zone_zero_v2.raf3.test_build -v
Les contrôles sont dans source/zone_zero_v2/tests_communs.py (images, cadence, mouvement, grille, accès ; PAS le moteur PMDO).
"""
import importlib.util
from pathlib import Path

_sp = importlib.util.spec_from_file_location('zone_zero_v2_tests', Path(__file__).resolve().parents[1] / 'tests_communs.py')
_m = importlib.util.module_from_spec(_sp); _sp.loader.exec_module(_m)
Build = _m.make('raf3')

if __name__ == '__main__':
    import unittest
    unittest.main()
