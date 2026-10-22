#!/usr/bin/env python3
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parent
sys.path.insert(0, str(ROOT / "src"))
sys.path.insert(0, str(REPO / "PMU_EXTRACTION/src"))
sys.path.insert(0, str(REPO / "tools"))
from pmu_adaptation.cli import main

if __name__ == "__main__":
    raise SystemExit(main())
