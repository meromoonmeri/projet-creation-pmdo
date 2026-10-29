from __future__ import annotations

"""Structural checks for the PMDO 0.8.12 skill, .dir strips, and preview."""

import hashlib
import json
import struct
import subprocess
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SRC = Path(__file__).resolve().parent
MOVE_PATH = SRC / "Data/Skill/bitter_blade.json"
BLADE_SOURCE = SRC / "assets/bitter_blade_blade_source.png"
BLADE_CUTOUT = SRC / "assets/bitter_blade_blade_cutout.png"
WISP_SOURCE = SRC / "assets/bitter_blade_wisp_source.png"
WISP_CUTOUT = SRC / "assets/bitter_blade_wisp_cutout.png"
UPSTREAM_MANIFEST = SRC / "references/upstream/manifest.json"
CERULEDGE_REF = SRC / "references/upstream/monster_ceruledge.json"
QUICK_ATTACK_REF = SRC / "references/upstream/skill_quick_attack.json"
SHADOW_SNEAK_REF = SRC / "references/upstream/skill_shadow_sneak.json"
FLARE_BLITZ_REF = SRC / "references/upstream/skill_flare_blitz.json"
NATIVE_MANIFEST = SRC / "references/upstream/native_vfx_manifest.json"
CUSTOM_MANIFEST = SRC / "assets/pmdo_animation/animation_manifest.json"
SPRITE_MANIFEST = SRC / "references/upstream/ceruledge_sprite/manifest.json"
SPRITE_CREDITS = SRC / "references/upstream/ceruledge_sprite/credits.txt"
WALK_SHEET = SRC / "references/upstream/ceruledge_sprite/Walk-Anim.png"
ANIM_DATA = SRC / "references/upstream/ceruledge_sprite/AnimData.xml"
ATLAS = SRC / "assets/bitter_blade_animation_sheet.png"
GIF = ROOT / "exports/illustrations/bitter_blade/bitter_blade_dash_preview.gif"
OLD_GIF = ROOT / "exports/illustrations/bitter_blade/bitter_blade_vfx_preview.gif"

ANIMATIONS = {
    "Bitter_Blade_Aura": (72, "PreAction"),
    "Bitter_Blade_Wisp": (32, "TileEmitter"),
    "Bitter_Blade_Slash": (72, "ActionFX"),
}


def identify(path: Path, fmt: str = "%w %h %[channels] %[opaque]") -> list[str]:
    return subprocess.check_output(["identify", "-format", fmt, str(path)], text=True).strip().split()


def frame_signatures(strip: Path, cell: int) -> set[str]:
    signatures = set()
    for frame in range(8):
        raw = subprocess.check_output(
            [
                "convert",
                str(strip),
                "-crop",
                f"{cell}x{cell}+{frame * cell}+0",
                "+repage",
                "-depth",
                "8",
                "rgba:-",
            ]
        )
        assert len(raw) == cell * cell * 4
        signatures.add(hashlib.sha256(raw).hexdigest())
    return signatures


def assert_no_warm_effect_pixels(strip: Path) -> None:
    raw = subprocess.check_output(["convert", str(strip), "-depth", "8", "rgba:-"])
    for red, green, blue, alpha in zip(raw[0::4], raw[1::4], raw[2::4], raw[3::4]):
        if alpha > 16:
            assert not (red > 140 and green < 170 and blue < 150), (
                f"Warm/red pixel in black-flame asset {strip}: {(red, green, blue, alpha)}"
            )


def main() -> None:
    document = json.loads(MOVE_PATH.read_text(encoding="utf-8"))
    assert document["Version"] == "0.8.12.0"
    move = document["Object"]
    assert move["Released"] is True
    assert move["IndexNum"] == 891
    assert move["BaseCharges"] == 10
    data = move["Data"]
    for source in (BLADE_SOURCE, WISP_SOURCE):
        assert identify(source)[3] == "true"
    for cutout in (BLADE_CUTOUT, WISP_CUTOUT):
        cutout_info = identify(cutout)
        assert "a" in cutout_info[2] and cutout_info[3] == "false"
    assert data["Element"] == "fire"
    assert data["Category"] == 1
    assert data["HitRate"] == 100
    assert any(state.get("Power") == 90 for state in data["SkillStates"])
    states = {state["$type"] for state in data["SkillStates"]}
    assert "PMDC.Dungeon.ContactState, PMDC" in states
    assert "PMDC.Dungeon.BladeState, PMDC" in states
    assert "PMDC.Dungeon.HealState, PMDC" in states
    assert any(
        event["Value"].get("$type") == "PMDC.Dungeon.DamageFormulaEvent, PMDC"
        for event in data["OnHits"]
    )
    drains = [
        event["Value"]
        for event in data["AfterActions"]
        if event["Value"].get("$type") == "PMDC.Dungeon.HPDrainEvent, PMDC"
    ]
    assert len(drains) == 1 and drains[0]["DrainFraction"] == 2

    hitbox = move["HitboxAction"]
    assert hitbox["$type"] == "RogueEssence.Dungeon.DashAction, RogueEssence"
    assert hitbox["Range"] == 5
    assert hitbox["CharAnim"] == 5
    assert hitbox["HitTiles"] is True
    assert hitbox["StopAtHit"] is True and hitbox["StopAtWall"] is True
    assert hitbox["TargetAlignments"] == 4
    assert hitbox["AppearanceMod"] == 2  # DashAppearance.Invisible

    afterimage = hitbox["Emitter"]
    assert afterimage["$type"] == "RogueEssence.Content.AfterImageEmitter, RogueEssence"
    trail = hitbox["TileEmitter"]
    assert trail["$type"] == "RogueEssence.Content.SingleEmitter, RogueEssence"
    assert trail["Anim"]["Anim"]["AnimIndex"] == "Bitter_Blade_Wisp"
    slash = hitbox["ActionFX"]["Emitter"]
    assert slash["$type"] == "RogueEssence.Content.SingleEmitter, RogueEssence"
    assert slash["Anim"]["Anim"]["AnimIndex"] == "Bitter_Blade_Slash"
    preactions = hitbox["PreActions"]
    assert preactions[0]["Sound"] == "DUN_Move_Start"
    assert preactions[1]["Emitter"]["$type"] == "RogueEssence.Content.ListEmitter, RogueEssence"
    aura = preactions[1]["Emitter"]
    assert aura["Anim"][0]["Anim"]["AnimIndex"] == "Bitter_Blade_Aura"
    assert hitbox["ActionFX"]["Sound"] == "DUN_Fury_Cutter"

    hitfx = data["HitFX"]
    gather = hitfx["Emitter"]
    assert gather["$type"] == "RogueEssence.Content.FiniteGatherEmitter, RogueEssence"
    assert gather["UseDest"] is True
    assert gather["Anims"][0]["AnimIndex"] == "Absorb"
    assert hitfx["Sound"] == "DUN_Absorb"

    quick_attack = json.loads(QUICK_ATTACK_REF.read_text(encoding="utf-8-sig"))["Object"]
    quick_action = quick_attack["HitboxAction"]
    assert quick_action["$type"] == "RogueEssence.Dungeon.DashAction, RogueEssence"
    assert quick_action["CharAnim"] == hitbox["CharAnim"] == 5
    assert quick_action["Emitter"] == afterimage
    assert quick_action["Range"] == 3 and hitbox["Range"] == 5
    shadow_sneak = json.loads(SHADOW_SNEAK_REF.read_text(encoding="utf-8-sig"))["Object"]
    assert shadow_sneak["HitboxAction"]["AppearanceMod"] == hitbox["AppearanceMod"] == 2
    flare_blitz = json.loads(FLARE_BLITZ_REF.read_text(encoding="utf-8-sig"))["Object"]
    assert flare_blitz["HitboxAction"]["Range"] == hitbox["Range"] == 5
    assert flare_blitz["HitboxAction"]["CharAnim"] == hitbox["CharAnim"]

    ceruledge = json.loads(CERULEDGE_REF.read_text(encoding="utf-8-sig"))["Object"]
    level_skills = [form["LevelSkills"] for form in ceruledge["Forms"]]
    assert any(
        entry.get("Skill") == "bitter_blade" and entry.get("Level") == 48
        for skills in level_skills
        for entry in skills
    )

    native = json.loads(NATIVE_MANIFEST.read_text(encoding="utf-8"))
    native_paths = {asset["path"] for asset in native["assets"]}
    assert "Content/Particle/Absorb.dir" in native_paths
    assert "Content/Sound/Battle/DUN_Absorb.ogg" in native_paths
    assert "Content/Sound/Battle/DUN_Fury_Cutter.ogg" in native_paths
    assert "Content/Sound/Battle/DUN_Move_Start.ogg" in native_paths
    assert "Content/Particle/Will_O_Wisp.dir" in native_paths
    assert "Content/Particle/Night_Slash.dir" in native_paths
    assert "Content/Particle/Shadow_Claw.dir" in native_paths

    upstream = json.loads(UPSTREAM_MANIFEST.read_text(encoding="utf-8"))
    assert upstream["commit"] == "3e767571f9dd94270b848b3a73de9bec2553a2eb"
    upstream_files = {item["upstream_path"]: item for item in upstream["files"]}
    for reference in (
        "Data/Skill/will_o_wisp.json",
        "Data/Skill/night_slash.json",
        "Data/Skill/shadow_claw.json",
        "Data/Skill/phantom_force.json",
    ):
        item = upstream_files[reference]
        local = SRC / "references/upstream" / item["local_path"]
        assert local.is_file() and local.stat().st_size == item["bytes"]

    manifest = json.loads(CUSTOM_MANIFEST.read_text(encoding="utf-8"))
    assert "black/charcoal flames" in manifest["visual_style"]
    assert manifest["animation_style_references"] == ["Will_O_Wisp", "Night_Slash", "Shadow_Claw"]
    manifest_by_name = {item["anim_index"]: item for item in manifest["animations"]}
    assert set(manifest_by_name) == set(ANIMATIONS)
    for name, (cell, action_slot) in ANIMATIONS.items():
        item = manifest_by_name[name]
        strip = SRC / item["editable_png_strip"]
        resource = SRC / item["resource"]
        assert item["frame_count"] == 8
        assert item["frame_size"] == [cell, cell]
        assert item["sheet_size"] == [cell * 8, cell]
        assert identify(strip)[:2] == [str(cell * 8), str(cell)]
        channels = identify(strip)[2:]
        assert "a" in channels[0] and channels[1] == "false"
        encoded = resource.read_bytes()
        assert len(encoded) >= 8 and struct.unpack("<Q", encoded[:8])[0] == len(encoded) - 8
        assert encoded[8:] == strip.read_bytes()
        assert encoded[8:16] == b"\x89PNG\r\n\x1a\n"
        assert len(frame_signatures(strip, cell)) == 8
        assert_no_warm_effect_pixels(strip)
        if action_slot == "PreAction":
            assert aura["Anim"][0]["Anim"]["AnimIndex"] == name
        elif action_slot == "TileEmitter":
            assert trail["Anim"]["Anim"]["AnimIndex"] == name
        else:
            assert slash["Anim"]["Anim"]["AnimIndex"] == name

    walk_info = identify(WALK_SHEET)
    assert walk_info[:2] == ["128", "448"]
    walk_anim = ET.parse(ANIM_DATA).getroot().find("./Anims/Anim[Name='Walk']")
    assert walk_anim is not None
    assert walk_anim.findtext("FrameWidth") == "32"
    assert walk_anim.findtext("FrameHeight") == "56"
    assert len(walk_anim.findall("./Durations/Duration")) == 4
    sprite_manifest = json.loads(SPRITE_MANIFEST.read_text(encoding="utf-8"))
    assert sprite_manifest["sprite_id"] == "0937"
    assert sprite_manifest["credit_name"] == "BaronessFaron"
    credits = SPRITE_CREDITS.read_text(encoding="utf-8")
    assert "CC_BY-NC_4" in credits and "PMDCollab_1" in credits

    assert identify(ATLAS)[:2] == ["900", "560"]
    gif_info = subprocess.check_output(["identify", "-format", "%w %h\n", str(GIF)], text=True)
    gif_frames = gif_info.strip().splitlines()
    assert len(gif_frames) == 104
    assert all(line == "640 640" for line in gif_frames)
    assert not OLD_GIF.exists()

    print(
        "PASS: PMDO 0.8.12 Bitter Blade properties; 5-tile CharAnim 5 rush with "
        "invisible body/Quick Attack afterimages; native 8-way Ceruledge preview; "
        "three 8-frame .dir strips; 50% drain; references and credits."
    )


if __name__ == "__main__":
    main()
