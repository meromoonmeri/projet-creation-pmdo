"""Construire ce lot avec le pipeline partagé, sans modifier les autres cartes."""
from pathlib import Path
import sys
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1]))
from source.maps_suite_v1.pipeline import Map

if __name__ == '__main__':
    Map(HERE).build()
