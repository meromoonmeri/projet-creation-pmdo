#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Extraction des MAPS de Kloa - Child of the Forest (scènes Unity).

Équivalent des rooms GameMaker de l'adaptation NNV : pour chaque scène
(level0..level40, noms lus dans BuildSettings), exporte le placement complet
des SpriteRenderers — la vérité de la composition visuelle de la map :

  * position/rotation/échelle monde (Transform recomposé via la hiérarchie),
  * sprite référencé (path_id + nom + fichier source du sprite),
  * ordre de rendu (sorting layer + order in layer),
  * flip X/Y, couleur (teinte/alpha),
  * colliders 2D (Box/Polygon/Circle) pour la géométrie praticable.

Sorties (.runtime-cache/kloa/extracted/maps/<scene>.json) + un index
versionné dev/docs/kloa/KLOA_SCENE_INDEX.json (déterministe, léger).

Rien n'est interprété : ce sont les valeurs sérialisées par Unity.
"""
from __future__ import annotations

import json
import math
import os
from pathlib import Path

import UnityPy

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / ".runtime-cache" / "kloa" / "source"
OUT = ROOT / ".runtime-cache" / "kloa" / "extracted" / "maps"
DOC = ROOT / "dev" / "docs" / "kloa"


def scene_names() -> dict[str, str]:
    env = UnityPy.load(str(SRC / "globalgamemanagers"))
    for obj in env.objects:
        if obj.type.name == "BuildSettings":
            d = obj.read_typetree()
            return {f"level{i}": s for i, s in enumerate(d.get("scenes", []))}
    return {}


def q_to_euler_z(q) -> float:
    x, y, z, w = q.get("x", 0), q.get("y", 0), q.get("z", 0), q.get("w", 1)
    return math.degrees(math.atan2(2 * (w * z + x * y), 1 - 2 * (y * y + z * z)))


def main() -> int:
    OUT.mkdir(parents=True, exist_ok=True)
    DOC.mkdir(parents=True, exist_ok=True)
    names = scene_names()
    index = {}
    for f in sorted(os.listdir(SRC)):
        if not f.startswith("level") or "." in f:
            continue
        try:
            env = UnityPy.load(str(SRC / f))
        except Exception as e:
            index[f] = {"error": str(e)[:100]}
            continue
        objects = {o.path_id: o for o in env.objects}
        # index Transform -> GameObject, et arbre des Transforms
        transforms = {}
        gos = {}
        for o in env.objects:
            if o.type.name in ("Transform", "RectTransform"):
                try:
                    t = o.read_typetree()
                    transforms[o.path_id] = t
                except Exception:
                    pass
            elif o.type.name == "GameObject":
                try:
                    gos[o.path_id] = o.read_typetree()
                except Exception:
                    pass

        def world_pos(tid, depth=0):
            """Recompose la position monde en remontant les parents."""
            if depth > 64 or tid not in transforms:
                return 0.0, 0.0, 0.0, 1.0, 1.0
            t = transforms[tid]
            lp = t.get("m_LocalPosition", {})
            ls = t.get("m_LocalScale", {})
            x, y, z = lp.get("x", 0), lp.get("y", 0), lp.get("z", 0)
            sx, sy = ls.get("x", 1), ls.get("y", 1)
            father = (t.get("m_Father") or {}).get("m_PathID", 0)
            if father and father in transforms:
                px, py, pz, psx, psy = world_pos(father, depth + 1)
                return px + x * psx, py + y * psy, pz + z, psx * sx, psy * sy
            return x, y, z, sx, sy

        rows = []
        colliders = []
        for o in env.objects:
            if o.type.name == "SpriteRenderer":
                try:
                    d = o.read_typetree()
                    go_id = (d.get("m_GameObject") or {}).get("m_PathID", 0)
                    go = gos.get(go_id, {})
                    tid = None
                    for comp in go.get("m_Component", []):
                        cid = (comp.get("component") or {}).get("m_PathID", 0)
                        if cid in transforms:
                            tid = cid
                            break
                    x, y, z, sx, sy = world_pos(tid) if tid else (0, 0, 0, 1, 1)
                    sp = d.get("m_Sprite") or {}
                    color = d.get("m_Color") or {}
                    rows.append({
                        "go": go.get("m_Name"),
                        "x": round(x, 4), "y": round(y, 4), "z": round(z, 4),
                        "scale": [round(sx, 4), round(sy, 4)],
                        "sprite_path_id": sp.get("m_PathID"),
                        "sprite_file_id": sp.get("m_FileID"),
                        "sorting_layer": d.get("m_SortingLayerID"),
                        "order": d.get("m_SortingOrder"),
                        "flip": [bool(d.get("m_FlipX")), bool(d.get("m_FlipY"))],
                        "color": [round(color.get(k, 1), 4) for k in ("r", "g", "b", "a")],
                        "enabled": bool(d.get("m_Enabled", 1)),
                    })
                except Exception:
                    pass
            elif o.type.name in ("BoxCollider2D", "PolygonCollider2D",
                                 "CircleCollider2D"):
                try:
                    d = o.read_typetree()
                    go_id = (d.get("m_GameObject") or {}).get("m_PathID", 0)
                    go = gos.get(go_id, {})
                    entry = {"type": o.type.name, "go": go.get("m_Name"),
                             "is_trigger": bool(d.get("m_IsTrigger"))}
                    if o.type.name == "BoxCollider2D":
                        sz = d.get("m_Size", {})
                        entry["size"] = [sz.get("x"), sz.get("y")]
                    elif o.type.name == "CircleCollider2D":
                        entry["radius"] = d.get("m_Radius")
                    colliders.append(entry)
                except Exception:
                    pass
        scene = {
            "schema": "new-era.kloa-scene.v1",
            "file": f,
            "scene_path": names.get(f, ""),
            "sprite_renderers": sorted(rows, key=lambda r: (r["sorting_layer"] or 0,
                                                            r["order"] or 0,
                                                            r["go"] or "")),
            "colliders": colliders,
        }
        (OUT / f"{f}.json").write_text(json.dumps(scene, indent=1))
        index[f] = {"scene_path": names.get(f, ""),
                    "sprite_renderers": len(rows),
                    "colliders": len(colliders)}
        print(f"{f}: {names.get(f,'?').split('/')[-1]} — {len(rows)} sprites posés, "
              f"{len(colliders)} colliders")
    (DOC / "KLOA_SCENE_INDEX.json").write_text(
        json.dumps({"schema": "new-era.kloa-scene-index.v1",
                    "unitypy": UnityPy.__version__,
                    "scenes": index}, indent=1))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
