#!/usr/bin/env python3
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent / "tools"))
from audit_archive import engine_evidence, png_size, safe_name

assert safe_name("Village/Data/Map001.rxdata")
assert not safe_name("../escape")
assert not safe_name("C:\\escape")
assert engine_evidence(["Game.rxproj", "Game.ini", "Data/Map001.rxdata"])[0]["engine"] == "RPG_MAKER_XP_RGSS"
assert png_size(b"\x89PNG\r\n\x1a\n" + b"\0" * 8 + (32).to_bytes(4, "big") + (48).to_bytes(4, "big")) == [32, 48]
print("No Name Village audit tests: OK")
