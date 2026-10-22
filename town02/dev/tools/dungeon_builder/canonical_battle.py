"""Stage exact canonical Ground -> battle-map counterparts outside production.

The converter reuses the project's proven Ground-to-rsmap pipeline.  It never
creates a visually unrelated arena: the staged map must pixel-match the
canonical Ground before it can be considered for promotion.
"""
from __future__ import annotations

import copy
import hashlib
import json
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[2]


def _read(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def _sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def _skill(skill: str, charges: int, backref: int) -> tuple[dict, dict]:
    return (
        {"Element": {"SkillNum": skill, "Charges": charges,
                     "Enabled": True, "Sealed": False}, "BackRef": backref},
        {"SkillNum": skill, "Charges": charges, "CanForget": False},
    )


def _retarget_player(template: dict[str, Any], *, species: str, level: int,
                     loc: tuple[int, int], elements: tuple[str, str],
                     skills: list[tuple[str, int]], intrinsic: str,
                     hp: int) -> dict[str, Any]:
    player = copy.deepcopy(template)
    player["Element1"], player["Element2"] = elements
    player["serializationLoc"] = {"X": loc[0], "Y": loc[1]}
    player["serializationDir"] = 4
    for key in ("CurrentForm", "BaseForm"):
        player[key] = {"Species": species, "Form": 0, "Skin": "normal", "Gender": 0}
    current, base = [], []
    for index, (skill, charges) in enumerate(skills):
        current_skill, base_skill = _skill(skill, charges, index)
        current.append(current_skill); base.append(base_skill)
    player["Skills"], player["BaseSkills"] = current, base
    player["Intrinsics"] = [{"Element": {"ID": intrinsic}, "BackRef": 0}]
    player["BaseIntrinsics"] = [intrinsic]
    player["EquippedItem"] = {
        "ID": "", "Cursed": False, "HiddenValue": "", "Amount": 0, "Price": 0,
    }
    player["HP"] = hp
    player["Level"] = level
    player["Nickname"] = ""
    player["Unrecruitable"] = True
    return player


def _patch_team(map_path: Path) -> None:
    payload = _read(map_path)
    obj = payload["Object"]
    old_players = obj["MapTeams"][0]["Players"]
    tactic_source = _read(ROOT / "Data" / "Map" / "boss_burmy_pair.rsmap")["Object"]
    boss_tactic = tactic_source["MapTeams"][0]["Players"][0]["Tactic"]
    specs = [
        dict(species="gengar", level=15, loc=(11, 8), elements=("ghost", "poison"),
             skills=[("lick", 30), ("spite", 20), ("curse", 10), ("night_shade", 15)],
             intrinsic="levitate", hp=80),
        dict(species="medicham", level=12, loc=(13, 9), elements=("fighting", "psychic"),
             skills=[("confusion", 25), ("meditate", 20), ("detect", 10),
                     ("hidden_power", 15)], intrinsic="pure_power", hp=70),
        dict(species="ekans", level=15, loc=(10, 9), elements=("poison", "none"),
             skills=[("bite", 25), ("glare", 30), ("poison_sting", 35), ("wrap", 20)],
             intrinsic="intimidate", hp=65),
    ]
    players = []
    for index, spec in enumerate(specs):
        player = _retarget_player(old_players[min(index, len(old_players) - 1)], **spec)
        player["Tactic"] = copy.deepcopy(boss_tactic)
        players.append(player)
    obj["MapTeams"] = [{
        "$type": "RogueEssence.Dungeon.MonsterTeam, RogueEssence",
        "Players": players,
    }]
    obj["EntryPoints"] = [
        {"Loc": {"X": 8, "Y": 10}, "Dir": 4},
        {"Loc": {"X": 11, "Y": 10}, "Dir": 4},
    ]
    # The source template is 15x18 while the canonical D04P02 map is 20x16.
    # DiscoveryArray is serialized and must match Tiles exactly; retaining the
    # template dimensions crashes Map.EnterMap before DungeonMapInit.
    width = len(obj["Tiles"])
    height = len(obj["Tiles"][0]) if width else 0
    if not width or not height or any(len(column) != height for column in obj["Tiles"]):
        raise ValueError("fixed battle map has a ragged or empty Tiles grid")
    obj["DiscoveryArray"] = [[0 for _ in range(height)] for _ in range(width)]
    obj["Name"] = {"DefaultText": "Sinister Woods Clearing", "LocalTexts": {"fr": "Clairière des Bois Sinistres"}}
    obj["Music"] = "Boss Battle!.ogg"
    obj["Comment"] = (
        "D04P02 exact visual counterpart. Geometry/layers/collision: canonical Ground. "
        "Boss species and source levels: PMD_RED_ROM. Moves/HP are INFERRED PMDO runtime "
        "serialization pending gameplay balance review. Not a dedicated unrelated arena."
    )
    map_path.write_text("\ufeff" + json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")


def _assert_walkable(map_path: Path) -> None:
    obj = _read(map_path)["Object"]
    points = [entry["Loc"] for entry in obj["EntryPoints"]]
    points.extend(player["serializationLoc"] for team in obj["MapTeams"] for player in team["Players"])
    bad = []
    for point in points:
        if obj["Tiles"][point["X"]][point["Y"]]["Data"]["ID"] != "floor":
            bad.append((point["X"], point["Y"]))
    if bad:
        raise ValueError(f"fixed battle positions are blocked: {bad}")


def stage_sinister(workdir: Path) -> dict[str, Any]:
    """Build and validate the D04P02 battle counterpart in a disposable root."""
    try:
        from PIL import Image, ImageChops  # type: ignore
    except ImportError as exc:
        raise RuntimeError("Pillow is required; install tools/requirements-pmdred.txt") from exc

    workdir = workdir.resolve()
    if workdir.exists():
        shutil.rmtree(workdir)
    for rel in ("tools", "Data/Ground", "Data/Map", "Content/Tile", "renders"):
        (workdir / rel).mkdir(parents=True, exist_ok=True)
    for name in ("make_ground_arena.py", "inject_tile_index.py", "render_rsmap.py"):
        shutil.copy2(ROOT / "tools" / name, workdir / "tools" / name)
    shutil.copy2(ROOT / "Data/Ground/sinister_woods_clearing.rsground",
                 workdir / "Data/Ground/sinister_woods_clearing.rsground")
    shutil.copy2(ROOT / "RESERVE/maps/serment_dazzling_arene.rsmap",
                 workdir / "Data/Map/metano_town_duel.rsmap")
    shutil.copy2(ROOT / "Content/Tile/SinisterWoodsFinalCanonical_Base.tile",
                 workdir / "Content/Tile/SinisterWoodsFinalCanonical_Base.tile")
    shutil.copy2(ROOT / "Content/Tile/index.idx", workdir / "Content/Tile/index.idx")

    subprocess.run(
        [sys.executable, "tools/make_ground_arena.py", "--ground", "sinister_woods_clearing",
         "--name", "gloomy_forest_boss", "--apply"],
        cwd=workdir, check=True,
    )
    map_path = workdir / "Data/Map/gloomy_forest_boss.rsmap"
    _patch_team(map_path)
    _assert_walkable(map_path)

    # Render the staged map from its own tile package.
    subprocess.run(
        [sys.executable, "tools/render_rsmap.py", str(map_path.relative_to(workdir)),
         "renders/gloomy_forest_boss.png"], cwd=workdir, check=True,
    )
    # Render canonical Ground with the repository's deterministic renderer.
    subprocess.run(
        [sys.executable, str(ROOT / "tools/render_ground_png.py"),
         "sinister_woods_clearing", "--ground-dir", str(ROOT / "Data/Ground"),
         "--tile-dir", str(ROOT / "Content/Tile"), "--output-dir", "renders"],
        cwd=workdir, check=True,
    )
    ground_png = workdir / "renders/sinister_woods_clearing.png"
    map_png = workdir / "renders/gloomy_forest_boss.png"
    ground_img = Image.open(ground_png).convert("RGBA")
    map_img = Image.open(map_png).convert("RGBA")
    if map_img.width != ground_img.width or map_img.height < ground_img.height:
        raise ValueError(f"render dimensions differ: Ground={ground_img.size}, map={map_img.size}")
    diff = ImageChops.difference(ground_img, map_img.crop((0, 0, ground_img.width, ground_img.height)))
    different = sum(1 for pixel in diff.getdata() if pixel != (0, 0, 0, 0))
    extra = map_img.crop((0, ground_img.height, map_img.width, map_img.height))
    extra_nonblack = sum(1 for pixel in extra.getdata() if pixel != (0, 0, 0, 255))
    if different or extra_nonblack:
        raise ValueError(
            f"canonical visual mismatch: pixels={different}, extra_bottom={extra_nonblack}")
    report = {
        "schema": "new-era.canonical-battle-map-stage.v1",
        "dungeon": "gloomy_forest",
        "source_ground": "Data/Ground/sinister_woods_clearing.rsground",
        "source_scene": "PMD_RED D04P02 fixed room 2",
        "staged_map": str(map_path),
        "ground_render_size": list(ground_img.size),
        "map_render_size": list(map_img.size),
        "different_pixels": different,
        "extra_bottom_nonblack": extra_nonblack,
        "ground_sha256": _sha(ROOT / "Data/Ground/sinister_woods_clearing.rsground"),
        "map_sha256": _sha(map_path),
        "tile_sha256": _sha(workdir / "Content/Tile/gloomy_forest_boss_Canonical_Final_Render.tile"),
        "boss_provenance": {
            "species_levels": "PMD_RED_ROM",
            "moves_hp": "INFERRED",
        },
        "production_modified": False,
        "result": "PIXEL_EXACT_STAGE_PASS",
    }
    report_path = workdir / "stage_report.json"
    report_path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return report
