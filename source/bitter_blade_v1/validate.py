from __future__ import annotations

"""Structural checks for the PMDO data and generated Bitter Blade preview."""

import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SRC = Path(__file__).resolve().parent
MOVE_PATH = SRC / "Data/Skill/bitter_blade.json"
CERULEDGE_REF = SRC / "references/upstream/monster_ceruledge.json"
NATIVE_MANIFEST = SRC / "references/upstream/native_vfx_manifest.json"
CUTOUT = SRC / "assets/bitter_blade_vfx_cutout.png"
GIF = ROOT / "exports/illustrations/bitter_blade/bitter_blade_vfx_preview.gif"


def main() -> None:
    document = json.loads(MOVE_PATH.read_text(encoding="utf-8"))
    assert document["Version"] == "0.8.12.0"
    move = document["Object"]
    assert move["Released"] is True
    assert move["IndexNum"] == 891
    assert move["BaseCharges"] == 10
    data = move["Data"]
    assert data["Element"] == "fire"
    assert data["Category"] == 1
    assert data["HitRate"] == 100
    assert any(s.get("Power") == 90 for s in data["SkillStates"])
    states = {s["$type"] for s in data["SkillStates"]}
    assert "PMDC.Dungeon.ContactState, PMDC" in states
    assert "PMDC.Dungeon.BladeState, PMDC" in states
    assert "PMDC.Dungeon.HealState, PMDC" in states
    assert any(
        e["Value"].get("$type") == "PMDC.Dungeon.DamageFormulaEvent, PMDC"
        for e in data["OnHits"]
    )
    drains = [
        e["Value"]
        for e in data["AfterActions"]
        if e["Value"].get("$type") == "PMDC.Dungeon.HPDrainEvent, PMDC"
    ]
    assert len(drains) == 1 and drains[0]["DrainFraction"] == 2

    hitbox = move["HitboxAction"]
    assert hitbox["$type"] == "RogueEssence.Dungeon.AttackAction, RogueEssence"
    assert hitbox["TileEmitter"]["Anim"]["Anim"]["AnimIndex"] == "Slash_RSE"
    hitfx = data["HitFX"]
    emitter = hitfx["Emitter"]
    assert emitter["$type"] == "RogueEssence.Content.FiniteGatherEmitter, RogueEssence"
    assert emitter["UseDest"] is True
    assert emitter["Anims"][0]["AnimIndex"] == "Absorb"
    assert hitfx["Sound"] == "DUN_Absorb"

    ceruledge = json.loads(CERULEDGE_REF.read_text(encoding="utf-8-sig"))["Object"]
    level_skills = [form["LevelSkills"] for form in ceruledge["Forms"]]
    assert any(
        entry.get("Skill") == "bitter_blade" and entry.get("Level") == 48
        for skills in level_skills
        for entry in skills
    )

    manifest = json.loads(NATIVE_MANIFEST.read_text(encoding="utf-8"))
    asset_paths = {asset["path"] for asset in manifest["assets"]}
    assert "Content/Particle/Slash_RSE.dir" in asset_paths
    assert "Content/Particle/Absorb.dir" in asset_paths

    cutout_info = subprocess.check_output(
        ["identify", "-format", "%w %h %[channels] %[opaque]", str(CUTOUT)], text=True
    ).split()
    assert cutout_info[:2] == ["1024", "1024"]
    assert "a" in cutout_info[2] and cutout_info[3] == "false"
    gif_frames = subprocess.check_output(
        ["identify", "-format", "%w %h\n", str(GIF)], text=True
    ).strip().splitlines()
    assert len(gif_frames) == 12
    assert all(line == "512 288" for line in gif_frames)

    print("PASS: Bitter Blade PMDO 0.8.12 structure, 50% drain, Ceruledge learnset, native VFX refs, alpha cutout, and 12-frame preview.")


if __name__ == "__main__":
    main()
