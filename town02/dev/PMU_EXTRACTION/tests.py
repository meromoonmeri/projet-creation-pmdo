#!/usr/bin/env python3
from pathlib import Path
import sys
import tempfile

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "src"))

from pmu_extraction.dat_maps import decrypt_bytes, encrypt_bytes, parse_v9
from pmu_extraction.inventories import _static_script_transition
from pmu_extraction.sql_dump import parse_insert_rows


def main() -> None:
    statement = r"INSERT INTO `x` VALUES (1,'a,b',NULL,'it\'s','line\nnext'),(-2,'\\');"
    assert list(parse_insert_rows(statement)) == [(1, "a,b", None, "it's", "line\nnext"), (-2, "\\")]
    plaintext = "MapData|V9|0|19|14|\r\n".encode("utf-16-le")
    assert decrypt_bytes(encrypt_bytes(plaintext)) == plaintext
    tile = {"data1": 72, "string1": "1695", "string2": "33", "string3": "25", "x": 4, "y": 7}
    edge = _static_script_transition("s282", tile)
    assert edge is not None and edge["target"] == "s1695"
    assert (edge["target_x"], edge["target_y"]) == (33, 25)
    # Dynamic/selection-only scripted tiles must not be fabricated into edges.
    tile["data1"] = 14
    assert _static_script_transition("s282", tile) is None
    maps = sorted((ROOT.parent / ".runtime-cache/pmu/PMU-Client/resources/MapData").glob("Map-*.dat"))
    if maps:
        # The repository ciphertexts use an unpublished deployment key. Verify
        # that the public placeholder is rejected rather than mis-decoded.
        try:
            parse_v9(maps[0])
        except ValueError as exc:
            assert "Padding is incorrect" in str(exc)
        else:
            raise AssertionError("Expected deployment-key block was not surfaced")
    print("tests: OK")


if __name__ == "__main__":
    main()
