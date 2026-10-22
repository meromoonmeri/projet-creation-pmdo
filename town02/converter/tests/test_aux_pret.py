"""Tests for the pret/pmd-red auxiliary loader.

Uses a synthetic mini C-header written on the fly (never a real pret
file) to prove the enum parser handles the canonical shapes: implicit
auto-increment, explicit decimal, explicit hex, mixed, comments.
"""
from __future__ import annotations

from pathlib import Path

from converter.aux_sources.pret import load_pret_checkout


def _make_fake_pret(root: Path) -> Path:
    """Build a minimal directory that looks like a pret checkout with
    one synthetic constants header. No real game content is used."""
    hdr_dir = root / "include" / "constants"
    hdr_dir.mkdir(parents=True, exist_ok=True)
    (hdr_dir / "demo.h").write_text(
        "/* synthetic header for tests only */\n"
        "#ifndef GUARD_DEMO_H\n"
        "#define GUARD_DEMO_H\n"
        "\n"
        "enum ShapeKind {\n"
        "    SHAPE_NONE,             // auto = 0\n"
        "    SHAPE_TRIANGLE,         // auto = 1\n"
        "    SHAPE_SQUARE = 10,      // explicit\n"
        "    SHAPE_CIRCLE,           // auto = 11\n"
        "    SHAPE_HEXAGON = 0x20,   // hex\n"
        "    SHAPE_STAR,             // auto = 0x21\n"
        "};\n"
        "\n"
        "enum EmptyEnum {\n"
        "};\n"
        "\n"
        "#endif\n",
        encoding="utf-8",
    )
    return root


def test_loader_missing_checkout(tmp_path: Path) -> None:
    assert load_pret_checkout(tmp_path / "does-not-exist") is None


def test_loader_missing_constants_dir(tmp_path: Path) -> None:
    (tmp_path / "somefile").write_text("nope", encoding="utf-8")
    assert load_pret_checkout(tmp_path) is None


def test_loader_parses_synthetic_enums(tmp_path: Path) -> None:
    _make_fake_pret(tmp_path)
    checkout = load_pret_checkout(tmp_path)
    assert checkout is not None

    shape = checkout.get_enum("ShapeKind")
    assert shape is not None, "ShapeKind enum should be parsed"
    assert shape.members == {
        "SHAPE_NONE":     0,
        "SHAPE_TRIANGLE": 1,
        "SHAPE_SQUARE":   10,
        "SHAPE_CIRCLE":   11,
        "SHAPE_HEXAGON":  0x20,
        "SHAPE_STAR":     0x21,
    }
    empty = checkout.get_enum("EmptyEnum")
    assert empty is not None and empty.members == {}


def test_loader_absent_enum_returns_none(tmp_path: Path) -> None:
    _make_fake_pret(tmp_path)
    checkout = load_pret_checkout(tmp_path)
    assert checkout is not None
    assert checkout.get_enum("NoSuchEnum") is None
