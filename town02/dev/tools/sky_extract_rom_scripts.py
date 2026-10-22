#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
sky_extract_rom_scripts.py — Extraction canonique EXHAUSTIVE des scripts de la
ROM PMD Explorers of Sky EU (C2SP) vers la campagne PMD_SKY_EXPLORERS.

AUTORITÉ : ROM Sky EU vérifiée SHA-256
  1fa39d35873b58e02f3623438414c334ad93b840651a8a9ac13ee3c789f170c1
Décodeur : skytemple-files (SsbHandler → ExplorerScript, SsaHandler → SSA/SSE/SSS).
Aucune donnée inventée : chaque échec de décompilation est enregistré tel quel
(status FAIL/PARTIAL, jamais masqué). SKIPPED ≠ PASS.

Périmètre : la totalité de SCRIPT/ de la ROM :
  - .ssb  (3760) : logique + dialogues 5 langues → ExplorerScript + strings
  - .ssa/.sse/.sss (1884) : placements acteurs/objets/performers/events/triggers
  - .lsd  (315)  : liste des scènes d'un level

Sorties (consolidées PAR ZONE pour rester lisibles et versionnables) :
  dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Cinematics/rom_scripts/<ZONE>.json.gz
      { zone, scripts: {name: {kind, status, explorerscript, strings{lang:[..]},
        ssa: {layers, triggers, position_markers}, error}}, }
  dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Cinematics/ROM_SCRIPTS_INDEX.json
      index machine-readable : par zone, par fichier, statut, compteurs.

Relation aux outils existants (anti-doublon) :
  - dev/tools/ssb_to_ir.py ciblait la ROM US (pret) et 24 scènes de l'arc du
    futur pour New Era ; le présent outil couvre la ROM EU entière pour la
    campagne canonique. Le décodage délègue à skytemple-files (pas de parseur
    parallèle réécrit ici).
"""
import argparse
import gzip
import hashlib
import json
import os
import sys
import time
import warnings
from collections import OrderedDict

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
ROM_PATH = os.path.join(
    REPO, ".runtime-cache", "sky-rom",
    "Pokemon Mystery Dungeon - Explorers of Sky (Europe) (En,Fr,De,Es,It).nds")
ROM_SHA256 = "1fa39d35873b58e02f3623438414c334ad93b840651a8a9ac13ee3c789f170c1"
OUT_DIR = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_SKY_EXPLORERS",
                       "Cinematics", "rom_scripts")
INDEX_PATH = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_SKY_EXPLORERS",
                          "Cinematics", "ROM_SCRIPTS_INDEX.json")


def sha256_file(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def walk(folder, prefix=""):
    for name in folder.files:
        yield prefix + name
    for name, sub in folder.folders:
        yield from walk(sub, prefix + name + "/")


def pos_to_dict(pos):
    d = OrderedDict()
    d["x_relative"] = pos.x_relative
    d["y_relative"] = pos.y_relative
    d["x_offset"] = pos.x_offset
    d["y_offset"] = pos.y_offset
    if getattr(pos, "direction", None) is not None:
        d["direction"] = pos.direction.name
        d["direction_ssa_id"] = pos.direction.ssa_id
    else:
        d["direction"] = None
    return d


def ssa_to_dict(ssa):
    out = OrderedDict()
    layers = []
    for layer in ssa.layer_list:
        ld = OrderedDict()
        ld["actors"] = [OrderedDict(
            actor_id=a.actor.id, actor_name=a.actor.name, entid=a.actor.entid,
            pos=pos_to_dict(a.pos), script_id=a.script_id, unkE=a.unkE,
        ) for a in layer.actors]
        ld["objects"] = [OrderedDict(
            object_id=o.object.id, object_name=o.object.unique_name,
            hitbox_w=o.hitbox_w, hitbox_h=o.hitbox_h,
            pos=pos_to_dict(o.pos), script_id=o.script_id, unk12=o.unk12,
        ) for o in layer.objects]
        ld["performers"] = [OrderedDict(
            type=p.type, pos=pos_to_dict(p.pos),
            hitbox_w=p.hitbox_w, hitbox_h=p.hitbox_h,
            unk10=p.unk10, unk12=p.unk12,
        ) for p in layer.performers]
        ld["events"] = [OrderedDict(
            trigger_width=e.trigger_width, trigger_height=e.trigger_height,
            trigger_id=e.trigger_id, pos=pos_to_dict(e.pos), unkE=e.unkE,
        ) for e in layer.events]
        ld["unk10s"] = [OrderedDict(
            unk0=u.unk0, unk2=u.unk2, unk4=u.unk4, unk6=u.unk6,
        ) for u in layer.unk10s]
        layers.append(ld)
    out["layers"] = layers
    out["triggers"] = [OrderedDict(
        coroutine=t.coroutine.name, coroutine_id=t.coroutine.id,
        unk2=t.unk2, unk3=t.unk3, script_id=t.script_id,
    ) for t in ssa.triggers]
    out["position_markers"] = [OrderedDict(
        pos=pos_to_dict(pm.pos), unk8=pm.unk8, unkA=pm.unkA,
        unkC=pm.unkC, unkE=pm.unkE,
    ) for pm in ssa.position_markers]
    return out


def build_level_links(rom, config):
    """Table de liaison canonique level script -> MAP_BG (bg_list.dat).

    Permet de relier chaque zone SCRIPT/<LEVEL>/ au ground de campagne
    (les rsground du port portent l'ID MAP_BG en minuscules).
    Sortie : Cinematics/LEVEL_MAP_LINKS.json
    """
    from skytemple_files.graphics.bg_list_dat.handler import BgListDatHandler
    bgl = BgListDatHandler.deserialize(rom.getFileByName("MAP_BG/bg_list.dat"))
    links = OrderedDict()
    for lv in config.script_data.level_list:
        entry = OrderedDict(id=lv.id, mapid=lv.mapid, mapty=lv.mapty,
                            nameid=lv.nameid, weather=lv.weather)
        if 0 <= lv.mapid < len(bgl.level):
            entry["map_bg"] = bgl.level[lv.mapid].bma_name.lower()
        else:
            entry["map_bg"] = None
        links[lv.name] = entry
    out = OrderedDict()
    out["schema"] = "sky-level-map-links/1"
    out["source_rom_sha256"] = ROM_SHA256
    out["authority"] = ("ppmdu_config level_list (name→mapid) x "
                        "MAP_BG/bg_list.dat (mapid→bma_name), ROM EU")
    out["levels"] = links
    path = os.path.join(os.path.dirname(OUT_DIR), "LEVEL_MAP_LINKS.json")
    with open(path, "w", encoding="utf-8") as fh:
        json.dump(out, fh, ensure_ascii=False, indent=1)
    print(f"LEVEL_MAP_LINKS: {path} ({len(links)} levels)")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--zones", nargs="*", help="Limiter à ces zones (debug)")
    ap.add_argument("--force", action="store_true",
                    help="Réécrire même si le .json.gz existe déjà")
    ap.add_argument("--links-only", action="store_true",
                    help="Ne générer que LEVEL_MAP_LINKS.json")
    args = ap.parse_args()

    from ndspy.rom import NintendoDSRom
    from skytemple_files.common.util import get_ppmdu_config_for_rom
    from skytemple_files.script.ssb.handler import SsbHandler
    from skytemple_files.script.ssa_sse_sss.handler import SsaHandler

    actual = sha256_file(ROM_PATH)
    if actual != ROM_SHA256:
        print(f"FATAL: ROM sha256 mismatch: {actual}", file=sys.stderr)
        sys.exit(2)
    rom = NintendoDSRom.fromFile(ROM_PATH)
    assert bytes(rom.idCode) == b"C2SP", rom.idCode
    config = get_ppmdu_config_for_rom(rom)
    print(f"ROM OK C2SP {config.game_version} {config.game_region}")

    build_level_links(rom, config)
    if args.links_only:
        return

    all_files = sorted(f for f in walk(rom.filenames) if f.startswith("SCRIPT/"))
    zones = OrderedDict()
    for f in all_files:
        parts = f.split("/")
        if len(parts) < 3:
            continue
        zones.setdefault(parts[1], []).append(f)
    if args.zones:
        want = {z.upper() for z in args.zones}
        zones = OrderedDict((k, v) for k, v in zones.items() if k in want)

    os.makedirs(OUT_DIR, exist_ok=True)
    index = OrderedDict()
    index["schema"] = "sky-rom-scripts-index/1"
    index["source_rom"] = os.path.basename(ROM_PATH)
    index["source_sha256"] = ROM_SHA256
    index["game_code"] = "C2SP"
    index["decoder"] = "skytemple-files SsbHandler/SsaHandler (EU config)"
    index["zones"] = OrderedDict()

    counters = dict(ssb_pass=0, ssb_partial=0, ssb_fail=0,
                    ssa_pass=0, ssa_fail=0, lsd_pass=0, lsd_fail=0)
    t0 = time.time()
    for zi, (zone, files) in enumerate(zones.items()):
        zone_out = OrderedDict()
        zone_out["zone"] = zone
        zone_out["scripts"] = OrderedDict()
        zidx = OrderedDict()
        out_path = os.path.join(OUT_DIR, f"{zone}.json.gz")
        for f in files:
            name = f.split("/")[-1]
            ext = os.path.splitext(name)[1].lower()
            entry = OrderedDict()
            entry["rom_path"] = f
            data = rom.getFileByName(f)
            entry["size_bytes"] = len(data)
            entry["sha256"] = hashlib.sha256(bytes(data)).hexdigest()
            if ext == ".ssb":
                entry["kind"] = "ssb"
                try:
                    ssb = SsbHandler.deserialize(data, static_data=config)
                    entry["strings"] = OrderedDict(
                        (lang, list(strs)) for lang, strs in ssb.strings.items())
                    entry["constants"] = list(ssb.constants)
                    with warnings.catch_warnings():
                        warnings.simplefilter("ignore")
                        try:
                            src, _ = ssb.to_explorerscript()
                            entry["explorerscript"] = src
                            entry["status"] = "PASS"
                            counters["ssb_pass"] += 1
                        except Exception as e:  # décompilation structurée KO
                            entry["explorerscript"] = None
                            try:
                                src2, _ = ssb.to_ssb_script()
                                entry["ssbscript"] = src2
                                entry["status"] = "PARTIAL"
                                entry["error"] = (
                                    f"explorerscript FAIL ({type(e).__name__}: {e}); "
                                    "fallback ssbscript linéaire OK")
                                counters["ssb_partial"] += 1
                            except Exception as e2:
                                entry["status"] = "FAIL"
                                entry["error"] = (
                                    f"explorerscript: {type(e).__name__}: {e}; "
                                    f"ssbscript: {type(e2).__name__}: {e2}")
                                counters["ssb_fail"] += 1
                except Exception as e:
                    entry["status"] = "FAIL"
                    entry["error"] = f"deserialize: {type(e).__name__}: {e}"
                    counters["ssb_fail"] += 1
            elif ext in (".ssa", ".sse", ".sss"):
                entry["kind"] = ext[1:]
                try:
                    ssa = SsaHandler.deserialize(data)
                    entry["ssa"] = ssa_to_dict(ssa)
                    entry["status"] = "PASS"
                    counters["ssa_pass"] += 1
                except Exception as e:
                    entry["status"] = "FAIL"
                    entry["error"] = f"{type(e).__name__}: {e}"
                    counters["ssa_fail"] += 1
            elif ext == ".lsd":
                entry["kind"] = "lsd"
                try:
                    from skytemple_files.script.lsd.handler import LsdHandler
                    lsd = LsdHandler.deserialize(data)
                    entry["entries"] = list(lsd.entries)
                    entry["status"] = "PASS"
                    counters["lsd_pass"] += 1
                except Exception as e:
                    entry["status"] = "FAIL"
                    entry["error"] = f"{type(e).__name__}: {e}"
                    counters["lsd_fail"] += 1
            else:
                entry["kind"] = ext.lstrip(".")
                entry["status"] = "UNSUPPORTED"
            zone_out["scripts"][name] = entry
            zidx[name] = OrderedDict(kind=entry["kind"], status=entry["status"],
                                     size=entry["size_bytes"])
            if "error" in entry:
                zidx[name]["error"] = entry["error"][:200]
        with gzip.open(out_path, "wt", encoding="utf-8") as fh:
            json.dump(zone_out, fh, ensure_ascii=False, indent=1)
        index["zones"][zone] = OrderedDict(
            file=f"rom_scripts/{zone}.json.gz",
            n_files=len(files), scripts=zidx)
        if (zi + 1) % 25 == 0 or zi + 1 == len(zones):
            print(f"[{zi+1}/{len(zones)}] {zone} — {time.time()-t0:.0f}s "
                  f"{counters}")

    index["totals"] = counters
    n_ssb = counters["ssb_pass"] + counters["ssb_partial"] + counters["ssb_fail"]
    n_ssa = counters["ssa_pass"] + counters["ssa_fail"]
    index["coverage"] = OrderedDict(
        ssb_total=n_ssb,
        ssb_explorerscript_pct=round(100.0 * counters["ssb_pass"] / max(1, n_ssb), 2),
        ssb_decoded_pct=round(100.0 * (counters["ssb_pass"] + counters["ssb_partial"])
                              / max(1, n_ssb), 2),
        ssa_total=n_ssa,
        ssa_pct=round(100.0 * counters["ssa_pass"] / max(1, n_ssa), 2),
        lsd_total=counters["lsd_pass"] + counters["lsd_fail"],
        note="Couvertures séparées ; ne JAMAIS fusionner en un seul pourcentage.")
    with open(INDEX_PATH, "w", encoding="utf-8") as fh:
        json.dump(index, fh, ensure_ascii=False, indent=1)
    print("INDEX:", INDEX_PATH)
    print("TOTALS:", counters)


if __name__ == "__main__":
    main()
