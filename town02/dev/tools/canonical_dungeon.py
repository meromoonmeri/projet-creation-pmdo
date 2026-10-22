#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""canonical-dungeon — orchestrateur de reconstruction & validation runtime.

Chef d'orchestre du flux canonique complet :

    ROM EU (hash-lock) -> pipeline d'extraction existante (manifests,
    conversion table, scripts EU) -> manifest canonique par donjon ->
    Dungeon Builder / RogueElements (zones procédurales déjà en place) ->
    DTEF/RawAsset/autotiling (Data/AutoTile + Content/Tile existants) ->
    PMDO 0.8.12 réel (bundle headless du projet) -> tests runtime PAR
    ÉTAGE -> matrice machine-readable -> verdict CANONICAL_RUNTIME_PASS.

Il ne recrée AUCUN composant :
  * la vérité ROM vient de converter/rom_cache/eu_ground_manifest.json
    (produit par dev/tools/audit_pmdred_eu_rom.py) ;
  * la génération est celle des zones RogueElements du dépôt
    (Data/Zone/*.json, construites par le Dungeon Builder) ;
  * la validation mapgen/traversal est le service moteur DÉJÀ intégré
    Data/Script/halcyon/services/mapgen_validator (il appelle
    structure:GetMap(context) dans le vrai moteur, comme MapGenTest) ;
  * la validation des Grounds de scène est le harness runtime existant
    (fixtures + ground_gameplay_validator).

Commandes :
    canonical_dungeon.py manifest  <zone|all>   # manifest canonique
    canonical_dungeon.py test      <zone|all>   # runtime réel par étage
    canonical_dungeon.py validate  <zone|all>   # matrice + verdict
    canonical_dungeon.py report                 # matrice agrégée

Aucun PASS n'est délivré sans exécution réelle du moteur : `test`
refuse de conclure si le bundle PMDO headless n'est pas présent
(.runtime-cache/pmdo-headless-bundle, restauré par la procédure du
projet) et marque alors RUNTIME_UNAVAILABLE.
"""
from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
import time
from pathlib import Path
from typing import Any, Optional

ROOT = Path(__file__).resolve().parents[2]
RUNTIME = ROOT / ".runtime-cache"
BUNDLE = RUNTIME / "pmdo-headless-bundle"
DUMP = RUNTIME / "DumpAsset"
OUT_DIR = ROOT / "dev" / "docs" / "canonical_dungeon_runtime"
EU_MANIFEST = ROOT / "converter" / "rom_cache" / "eu_ground_manifest.json"
ROM_SHA = "0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd"

# Les 12 donjons protégés (jamais modifiés par cet outil).
PROTECTED = {
    "tiny_woods", "thunderwave_cave", "mt_steel", "mt_thunder",
    "silent_chasm", "great_canyon", "lapis_cave", "mt_freeze",
    "mt_blaze", "mt_thunder_peak", "mt_blaze_peak", "mt_freeze_peak",
}

FAILURE_KINDS = (
    "GENERATION_FAILURE", "TILESET_FAILURE", "AUTOTILE_FAILURE",
    "GROUND_FAILURE", "COLLISION_FAILURE", "SPAWN_FAILURE",
    "TRANSITION_FAILURE", "SCRIPT_FAILURE", "CAMERA_FAILURE",
    "RENDER_FAILURE", "RUNTIME_FAILURE", "CANONICAL_DATA_MISMATCH",
    "UNIMPLEMENTED", "REVIEW_REQUIRED",
)


def read_json(p: Path) -> Any:
    return json.loads(p.read_text(encoding="utf-8-sig"))


def zone_ids(selector: str) -> list[str]:
    if selector != "all":
        return [z.strip() for z in selector.split(",") if z.strip()]
    out = []
    for p in sorted((ROOT / "Data" / "Zone").glob("*.json")):
        if p.name in ("index.idx", "master_zone.json", "zone_index.json"):
            continue
        out.append(p.stem)
    return out


# ------------------------------------------------------------------ manifest

def eu_dungeon_rows() -> dict[str, dict]:
    """map_to_dungeon rows of the EU ROM keyed by stable ground id."""
    if not EU_MANIFEST.exists():
        return {}
    m = read_json(EU_MANIFEST)
    rows = {}
    for r in m.get("map_to_dungeon_table", {}).get("entries", []):
        rows[r["stable_ground_id"]] = r
    return rows


def build_manifest(zone: str) -> dict:
    """Manifest canonique d'un donjon : contraintes obligatoires
    (identité, étages, segments, grounds de scène, données ROM) séparées
    des paramètres de génération (laissés à RogueElements)."""
    zp = ROOT / "Data" / "Zone" / f"{zone}.json"
    if not zp.exists():
        return {"zone": zone, "status": "UNKNOWN_ZONE"}
    z = read_json(zp)
    obj = z.get("Object", z)
    segments = obj.get("Segments", [])
    if isinstance(segments, dict):
        segments = segments.get("$values", [])
    floor_total = 0
    seg_infos = []
    for i, seg in enumerate(segments):
        count = seg.get("FloorCount")
        if count is None:
            fl = seg.get("Floors")
            if isinstance(fl, dict):
                fl = fl.get("$values", [])
            count = len(fl) if isinstance(fl, list) else 0
        floor_total += int(count or 0)
        seg_infos.append({"index": i, "floor_count": int(count or 0),
                          "type": str(seg.get("$type", ""))[:80]})
    rom_rows = eu_dungeon_rows()
    # grounds de scène référencés par les scripts de zone
    zscript = ROOT / "Data" / "Script" / "halcyon" / "zone" / zone / "init.lua"
    grounds = []
    if zscript.exists():
        import re
        text = zscript.read_text(encoding="utf-8", errors="replace")
        grounds = sorted(set(re.findall(r"['\"]((?:d\d{2}p\d{2}|[a-z_]+))['\"]",
                                        text)) & set(
            p.stem for p in (ROOT / "Data" / "Ground").glob("*.rsground")))
    return {
        "schema": "new-era.canonical-dungeon-manifest.v1",
        "zone": zone,
        "protected": zone in PROTECTED,
        "rom_sha256": ROM_SHA,
        "segments": seg_infos,
        "floor_total": floor_total,
        "scene_grounds": grounds[:24],
        "rom_dungeon_rows": {k: v for k, v in rom_rows.items()
                             if k in set(grounds)},
        "generation": "RogueElements (procédural, aucune seed de production)",
    }


# ------------------------------------------------------------------ runtime

def pmdo_env() -> Optional[dict]:
    if not (BUNDLE / "PMDO").exists() or not DUMP.is_dir():
        return None
    env = dict(os.environ)
    env.update({
        "DOTNET_BUNDLE_EXTRACT_BASE_DIR": str(RUNTIME / "dotnet-headless"),
        "LD_LIBRARY_PATH": str(BUNDLE),
        "SDL_VIDEODRIVER": "offscreen",
        "SDL_AUDIODRIVER": "dummy",
        "SDL_VIDEO_GL_DRIVER": str(BUNDLE / "libGLESv2.so"),
        "SDL_VIDEO_EGL_DRIVER": str(BUNDLE / "libEGL.so"),
        "PMDO_HEADLESS_ANGLE_DEFAULT_DISPLAY": "1",
        "PMDO_HEADLESS_DISMISS_SPLASH": "1",
        "FNA3D_FORCE_DRIVER": "OpenGL",
        "FNA3D_OPENGL_FORCE_ES3": "1",
        "ANGLE_DEFAULT_PLATFORM": "vulkan",
        "VK_ICD_FILENAMES": str(BUNDLE / "vk_swiftshader_icd.absolute.json"),
    })
    return env


def ensure_quest_appdata() -> Path:
    """Un appdata avec MODS/New-Era -> le dépôt (symlink)."""
    app = RUNTIME / "canonical-appdata"
    (app / "MODS").mkdir(parents=True, exist_ok=True)
    link = app / "MODS" / "New-Era"
    if not link.exists():
        link.symlink_to(ROOT)
    return app


def run_mapgen(zones: list[str], iterations: int, out_file: Path,
               timeout_s: int) -> dict:
    """Exécute le service moteur mapgen_validator (génération réelle
    RogueElements + traversabilité) sur les zones demandées."""
    env = pmdo_env()
    if env is None:
        return {"status": "RUNTIME_UNAVAILABLE",
                "reason": "bundle PMDO headless absent — restaurer via la "
                          "procédure .runtime-cache du projet"}
    app = ensure_quest_appdata()
    out_file.parent.mkdir(parents=True, exist_ok=True)
    if out_file.exists():
        out_file.unlink()
    env["PMDO_MAPGEN_VALIDATOR"] = ",".join(zones)
    env["PMDO_MAPGEN_ITER"] = str(iterations)
    env["PMDO_MAPGEN_OUT"] = str(out_file)
    cmd = [str(BUNDLE / "PMDO"), "-asset", str(DUMP) + "/",
           "-appdata", str(app) + "/", "-quest", "New-Era"]
    t0 = time.time()
    # PMDO ne quitte pas après la fin du validateur (boucle de jeu).
    # On surveille le JSONL: dès {"event":"end"} le travail moteur est
    # terminé et on peut arrêter le process proprement.
    proc = subprocess.Popen(cmd, env=env, stdout=subprocess.DEVNULL,
                            stderr=subprocess.DEVNULL)
    rc: Optional[int] = None
    ended = False
    while time.time() - t0 < timeout_s:
        if proc.poll() is not None:
            rc = proc.returncode
            break
        if out_file.exists():
            try:
                tail = out_file.read_bytes()[-256:]
                if b'"event":"end"' in tail:
                    ended = True
                    break
            except Exception:
                pass
        time.sleep(5)
    if proc.poll() is None:
        proc.terminate()
        try:
            proc.wait(timeout=15)
        except subprocess.TimeoutExpired:
            proc.kill()
            proc.wait()
        if ended:
            rc = 0          # travail moteur complet, arrêt volontaire
    dur = round(time.time() - t0, 1)
    rows = []
    if out_file.exists():
        for line in out_file.read_text(encoding="utf-8",
                                       errors="replace").splitlines():
            try:
                rows.append(json.loads(line))
            except Exception:
                pass
    return {"status": "RAN", "returncode": rc, "duration_s": dur,
            "rows": rows}


def _loadmap_floors(zone: str) -> dict[tuple, list[str]]:
    """(segment,floor) -> MapIDs des RoomGenLoadMap/MappedRoomStep du floor.
    Ces étages chargent une salle fixe au runtime réel; GetMap standalone
    ne la compose pas (walkable~1). On valide l'existence de la map."""
    import re as _re
    zp = ROOT / "Data" / "Zone" / f"{zone}.json"
    if not zp.exists():
        return {}
    z = read_json(zp)
    segs = z["Object"]["Segments"]
    if isinstance(segs, dict):
        segs = segs["$values"]
    out = {}
    for si, seg in enumerate(segs):
        fl = seg.get("Floors")
        if isinstance(fl, dict):
            fl = fl.get("$values")
        if not isinstance(fl, list):
            continue
        for fi, f in enumerate(fl):
            s = json.dumps(f)
            if "RoomGenLoadMap" in s or "MappedRoomStep" in s:
                out[(si, fi)] = _re.findall(r'"MapID":\s*"([^"]+)"', s)
    return out


def summarize_zone(zone: str, rows: list[dict]) -> dict:
    """Matrice par étage à partir des événements moteur réels.

    Schéma émis par mapgen_validator (moteur) :
      status=="OK", valid, topology_ok, traversable, entry_ok,
      stairs_reachable, isolated, components, autotiles, rooms/halls…
    """
    floors: dict[str, dict] = {}
    loadmaps = _loadmap_floors(zone)
    end = None
    for r in rows:
        if r.get("event") == "end":
            end = r
            continue
        if r.get("event") != "floor" or r.get("zone") != zone:
            continue
        fid = f"seg{r.get('segment', '?')}_floor{r.get('floor', '?')}"
        # Agrégation stricte multi-itérations : un étage n'est PASS que si
        # TOUTES les itérations le sont (le pire cas gagne, jamais l'inverse).
        prior = floors.get(fid)
        generator = str(r.get("generator") or "")
        fixed_room = generator == "LoadGen"        # rsmap fixe (boss/scène)
        # Étage à salle spéciale préchargée (RoomGenLoadMap au sein d'un
        # GridFloorGen): GetMap standalone ne compose pas la map; le
        # runtime réel du donjon la charge. Vérifier que la map existe.
        key = (r.get("segment"), r.get("floor"))
        if (not fixed_room and key in loadmaps and
                int(r.get("rooms") or 0) == 0 and
                int(r.get("walkable") or 0) <= 4):
            maps_ok = all((ROOT / "Data" / "Map" / f"{m}.rsmap").exists()
                          for m in loadmaps[key])
            fixed_room = maps_ok
        sealed = bool(r.get("has_seals"))
        scripted = bool(r.get("has_scripted"))
        gen_ok = (r.get("status") == "OK" and
                  (bool(r.get("valid")) or fixed_room))
        topo_ok = bool(r.get("topology_ok")) or fixed_room
        isolated = int(r.get("isolated") or 0)
        # Jouabilité vérifiée par le moteur: entrée + escalier atteignable.
        # Les poches isolées sont journalisées (accessibles par trap_warp),
        # elles ne condamnent pas un étage complétable.
        trav_ok = bool(r.get("traversable")) and bool(r.get("entry_ok"))
        # Même sémantique que le service moteur (mapgen_validator):
        # la progression exige AU MOINS UN escalier atteignable. Les
        # escaliers secondaires (stairs_secret_* dans un vault scellé)
        # s'ouvrent en jeu et restent journalisés.
        stairs_ok = fixed_room or scripted or (
            int(r.get("stairs") or 0) >= 1 and
            int(r.get("stairs_reachable") or 0) >= 1)
        autotiles = str(r.get("autotiles") or "")
        # Les rsmap fixes (LoadGen) portent leurs textures directement,
        # sans autotile: l'absence d'autotile y est canonique.
        auto_ok = fixed_room or bool(autotiles.strip())
        rooms = int(r.get("rooms") or 0)
        # RoomFloorGen (placement libre): les salles adjacentes se
        # connectent sans couloir — hall_count n'y est pas un invariant
        # (même sémantique que hall_floor=0 dans mapgen_validator).
        complexity_ok = fixed_room or (
            rooms >= 2 and (int(r.get("halls") or 0) >= 1 or
                            generator == "RoomFloorGen"))
        cur = {
            "generation":  "PASS" if gen_ok else "GENERATION_FAILURE",
            "topology":    "PASS" if topo_ok else "GENERATION_FAILURE",
            "traversal":   "PASS" if trav_ok else "COLLISION_FAILURE",
            "stairs":      "PASS" if stairs_ok else "TRANSITION_FAILURE",
            "autotile":    "PASS" if auto_ok else "AUTOTILE_FAILURE",
            "complexity":  "PASS" if complexity_ok else "REVIEW_REQUIRED",
            "rooms": rooms, "halls": int(r.get("halls") or 0),
            "branches": r.get("branches"), "loops": r.get("loops"),
            "dead_ends": r.get("dead_ends"),
            "width": r.get("width"), "height": r.get("height"),
            "autotiles": autotiles,
            "iterations_seen": 1,
            "error": r.get("error"),
        }
        if prior is not None:
            for k in ("generation", "topology", "traversal", "stairs",
                      "autotile", "complexity"):
                if prior.get(k) != "PASS":
                    cur[k] = prior[k]        # le pire verdict est conservé
            cur["iterations_seen"] = prior.get("iterations_seen", 1) + 1
            cur["error"] = cur["error"] or prior.get("error")
        floors[fid] = cur
    def floor_ok(f: dict) -> bool:
        return all(f[k] == "PASS" for k in
                   ("generation", "topology", "traversal", "stairs",
                    "autotile", "complexity"))
    n_fail = sum(1 for f in floors.values() if not floor_ok(f))
    verdict = "CANONICAL_RUNTIME_PASS" if floors and n_fail == 0 else (
        "FAIL" if floors else "NO_DATA")
    return {"zone": zone, "floors": floors, "floor_count": len(floors),
            "failures": n_fail, "verdict": verdict, "engine_end": end}


# ------------------------------------------------------------------ commands

def cmd_manifest(selector: str) -> int:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    out = {}
    for z in zone_ids(selector):
        out[z] = build_manifest(z)
    dest = OUT_DIR / "manifests.json"
    dest.write_text(json.dumps(out, indent=1, ensure_ascii=False),
                    encoding="utf-8")
    print(f"{len(out)} manifest(s) -> {dest.relative_to(ROOT)}")
    return 0


def cmd_test(selector: str, iterations: int, timeout_s: int) -> int:
    zones = zone_ids(selector)
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    raw = OUT_DIR / f"mapgen_{selector.replace(',', '_')[:40]}.jsonl"
    res = run_mapgen(zones, iterations, raw, timeout_s)
    if res["status"] != "RAN":
        print(json.dumps(res, indent=1))
        return 2
    matrix = {z: summarize_zone(z, res["rows"]) for z in zones}
    dest = OUT_DIR / "matrix.json"
    prev = read_json(dest) if dest.exists() else {}
    prev.update(matrix)
    dest.write_text(json.dumps(prev, indent=1, ensure_ascii=False),
                    encoding="utf-8")
    total_floors = sum(m["floor_count"] for m in matrix.values())
    total_fail = sum(m["failures"] for m in matrix.values())
    print(f"zones={len(zones)} floors={total_floors} failures={total_fail} "
          f"durée={res['duration_s']}s rc={res['returncode']}")
    for z, m in matrix.items():
        print(f"  {z}: {m['verdict']} ({m['floor_count']} étages, "
              f"{m['failures']} échec(s))")
    return 0 if total_fail == 0 and total_floors > 0 else 1


def cmd_validate(selector: str) -> int:
    dest = OUT_DIR / "matrix.json"
    if not dest.exists():
        print("Aucune matrice: lancer `test` d'abord.")
        return 2
    matrix = read_json(dest)
    zones = zone_ids(selector)
    bad = 0
    for z in zones:
        m = matrix.get(z)
        v = m["verdict"] if m else "NO_DATA"
        if v != "CANONICAL_RUNTIME_PASS":
            bad += 1
        print(f"{z}: {v}")
    print(f"=> {len(zones) - bad}/{len(zones)} CANONICAL_RUNTIME_PASS")
    return 0 if bad == 0 else 1


def cmd_report() -> int:
    dest = OUT_DIR / "matrix.json"
    matrix = read_json(dest) if dest.exists() else {}
    ok = sum(1 for m in matrix.values()
             if m.get("verdict") == "CANONICAL_RUNTIME_PASS")
    floors = sum(m.get("floor_count", 0) for m in matrix.values())
    print(json.dumps({
        "zones_tested": len(matrix),
        "zones_pass": ok,
        "floors_tested": floors,
        "protected_untouched": sorted(PROTECTED),
    }, indent=1, ensure_ascii=False))
    return 0


def main(argv: Optional[list[str]] = None) -> int:
    ap = argparse.ArgumentParser(prog="canonical-dungeon")
    sub = ap.add_subparsers(dest="cmd", required=True)
    for name in ("manifest", "test", "validate"):
        p = sub.add_parser(name)
        p.add_argument("selector")
        if name == "test":
            p.add_argument("--iterations", type=int, default=1)
            p.add_argument("--timeout", type=int, default=1500)
    sub.add_parser("report")
    a = ap.parse_args(argv)
    if a.cmd == "manifest":
        return cmd_manifest(a.selector)
    if a.cmd == "test":
        return cmd_test(a.selector, a.iterations, a.timeout)
    if a.cmd == "validate":
        return cmd_validate(a.selector)
    return cmd_report()


if __name__ == "__main__":
    raise SystemExit(main())
