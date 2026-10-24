#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Compilation native façon `Palikadude/Halcyon` (`PMDO 0.8.12.0`) de `guilde-treehouse-pmd` :
  - Les 12 salles modulaires (`01_accueil` .. `12_salle_chef`) ;
  - Les 11 calques indépendants (`00_exterieur` .. `10_bordure_avant` en `Layer=4 Top`) ;
  - Les fenêtres transparentes et les 6 ambiances (`jour`, `nuit`, `crepuscule`, `aube`, `soir`, `orageux`) ;
  - Passages ouverts PMD sans battants ordinaires (seule porte fermée au nord de `02_hall_missions` -> `12_salle_chef`) ;
  - Collisions 8×8 calculées depuis `01_sol.png`, marqueurs d'entrée et déclencheurs `Touch` Halcyon ;
  - Scripts Lua placés sous `Data/Script/halcyon/ground/<ground_id>/init.lua` (standard `town02` / `Halcyon`).
"""
from __future__ import annotations

import copy
import io
import json
import os
import struct
import zipfile
import zlib
from pathlib import Path
from typing import Dict, List, Optional, Tuple

import numpy as np
from PIL import Image

# Compatibilité Pillow 11 pour putpalette le cas échéant
_ORIG_PUTPALETTE = Image.Image.putpalette


def _safe_putpalette(self, data, rawmode="RGB"):  # type: ignore[no-untyped-def]
    if isinstance(data, (list, tuple)) and rawmode == "RGB" and len(data) < 768:
        data = list(data) + [0] * (768 - len(data))
    return _ORIG_PUTPALETTE(self, data, rawmode=rawmode)


Image.Image.putpalette = _safe_putpalette  # type: ignore[assignment]

ROOT = Path(__file__).resolve().parents[2]
MAP_ID = "GTH1"
LOT_NAME = "guilde_treehouse_halcyon_v1"
CACHE_PKG = ROOT / ".cache" / "tiles" / LOT_NAME
RENDERS_DIR = ROOT / "renders" / LOT_NAME
RENDERS_PKG = RENDERS_DIR / "package"
VZIP_PATH = ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"

COLS = 64
AMBIANCES = ("jour", "nuit", "crepuscule", "aube", "soir", "orageux")
NIGHT_INTERIOR_AMBIANCES = {"nuit", "soir"}

# Graphe modulaire des 12 salles Guilde Treehouse (passages ouverts PMD + porte nord vers bureau chef)
# Format : room_id -> { callback_touch_name: (dest_room_slug, dest_marker_name, trigger_side) }
ROOM_CONNECTIONS: Dict[str, List[Tuple[str, str, str, str]]] = {
    "01": [
        ("Passage_Nord", "02_hall_missions", "Entree_Sud", "N"),
        ("Passage_Sud", "metano_town", "Entrance", "S"),
    ],
    "02": [
        ("Passage_Sud", "01_accueil", "Entree_Nord", "S"),
        ("Passage_Ouest", "04_cantine", "Entree_Est", "O"),
        ("Echelle_Nord", "03_salle_commune", "Entree_Echelle_Nord", "EN"),
        ("Porte_Maitre_Nord", "12_salle_chef", "Entree_Sud", "PN"),
    ],
    "03": [
        ("Echelle_Nord", "02_hall_missions", "Entree_Echelle_Nord", "EN"),
        ("Passage_Ouest", "05_chambre_equipe", "Entree_Est", "O"),
        ("Passage_Est", "07_chambre_residents", "Entree_Ouest", "E"),
        ("Passage_Sud", "09_dortoir_quatre", "Entree_Nord", "S"),
    ],
    "04": [("Passage_Est", "02_hall_missions", "Entree_Ouest", "E")],
    "05": [("Passage_Est", "03_salle_commune", "Entree_Ouest", "E")],
    "06": [("Passage_Sud", "03_salle_commune", "Centre", "S")],
    "07": [("Passage_Ouest", "03_salle_commune", "Entree_Est", "O")],
    "08": [("Passage_Est", "03_salle_commune", "Entree_Ouest", "E")],
    "09": [("Passage_Nord", "03_salle_commune", "Entree_Sud", "N")],
    "10": [("Passage_Ouest", "03_salle_commune", "Entree_Est", "O")],
    "11": [("Passage_Ouest", "03_salle_commune", "Entree_Est", "O")],
    "12": [("Passage_Sud", "02_hall_missions", "Entree_Porte_Maitre", "S")],
}


def _png_chunk(chunk_type: bytes, data: bytes) -> bytes:
    crc = zlib.crc32(chunk_type + data) & 0xFFFFFFFF
    return struct.pack(">I", len(data)) + chunk_type + data + struct.pack(">I", crc)


def encode_8x8_png(tile_rgba: np.ndarray) -> bytes:
    """Encode un bloc 8×8 RGBA en PNG indexé compact conforme ISO/IEC 15948."""
    flat = tile_rgba.reshape(-1, 4)
    uniq, inv = np.unique(flat, axis=0, return_inverse=True)
    n_col = len(uniq)
    idx_grid = inv.reshape(8, 8)
    if n_col <= 16:
        bit_depth = 4
        rows_raw = bytearray()
        for y in range(8):
            rows_raw.append(0)
            row = idx_grid[y]
            for x in range(0, 8, 2):
                rows_raw.append((int(row[x]) << 4) | int(row[x + 1]))
    else:
        bit_depth = 8
        rows_raw = bytearray()
        for y in range(8):
            rows_raw.append(0)
            rows_raw.extend(int(v) for v in idx_grid[y])

    ihdr = struct.pack(">IIBBBBB", 8, 8, bit_depth, 3, 0, 0, 0)
    plte = uniq[:, :3].astype(np.uint8).tobytes()
    chunks = [b"\x89PNG\r\n\x1a\n", _png_chunk(b"IHDR", ihdr), _png_chunk(b"PLTE", plte)]
    if (uniq[:, 3] < 255).any():
        chunks.append(_png_chunk(b"tRNS", uniq[:, 3].astype(np.uint8).tobytes()))
    chunks.append(_png_chunk(b"IDAT", zlib.compress(bytes(rows_raw), level=6)))
    chunks.append(_png_chunk(b"IEND", b""))
    return b"".join(chunks)


class DedupTileBank:
    """Banque `.tile` dédupliquée (< 24 000 tuiles 8×8 uniques)."""

    def __init__(self, sheet_name: str, cols: int = COLS) -> None:
        self.sheet_name = sheet_name
        self.cols = cols
        self._lookup: Dict[bytes, int] = {}
        self._tiles: List[np.ndarray] = []

    def add_image_grid(self, rgba: np.ndarray) -> List[List[Optional[int]]]:
        h, w, _ = rgba.shape
        gw, gh = w // 8, h // 8
        grid: List[List[Optional[int]]] = [[None] * gh for _ in range(gw)]
        for cx in range(gw):
            x0 = cx * 8
            col = grid[cx]
            for cy in range(gh):
                y0 = cy * 8
                patch = rgba[y0 : y0 + 8, x0 : x0 + 8]
                if not patch[:, :, 3].any():
                    continue
                key = patch.tobytes()
                tidx = self._lookup.get(key)
                if tidx is None:
                    tidx = len(self._tiles)
                    self._lookup[key] = tidx
                    self._tiles.append(patch.copy())
                col[cy] = tidx
        return grid

    @property
    def count(self) -> int:
        return len(self._tiles)

    def to_tile_bytes(self) -> bytes:
        if len(self._tiles) >= 24000:
            raise ValueError(f"Banque {self.sheet_name} dépasse 24 000 tuiles ({len(self._tiles)})")
        blobs = [encode_8x8_png(t) for t in self._tiles]
        header = struct.pack("<II", 8, len(blobs))
        off = 8 + 16 * len(blobs)
        entries: List[bytes] = []
        payloads: List[bytes] = []
        for i, blob in enumerate(blobs):
            entries.append(struct.pack("<IIq", i % self.cols, i // self.cols, off))
            payloads.append(struct.pack("<q", len(blob)) + blob)
            off += 8 + len(blob)
        return header + b"".join(entries) + b"".join(payloads)


_EMPTY_CELL: dict = {"AutoTileset": "", "Associates": [], "Layers": [], "NeighborCode": -1}


def _cell_json(sheet: str, tidx: Optional[int], cols: int = COLS) -> dict:
    if tidx is None:
        return _EMPTY_CELL
    return {
        "AutoTileset": "",
        "Associates": [],
        "Layers": [
            {
                "Frames": [
                    {
                        "Sheet": sheet,
                        "TexLoc": {"X": tidx % cols, "Y": tidx // cols},
                    }
                ],
                "FrameLength": 60,
            }
        ],
        "NeighborCode": -1,
    }


def _make_marker(name: str, x: int, y: int, direction: int = 0) -> dict:
    return {
        "EntName": name,
        "Direction": direction,
        "EntEnabled": True,
        "EntOrder": 0,
        "triggerType": 0,
        "Collider": {"X": int(x), "Y": int(y), "Width": 16, "Height": 16},
    }


def _make_touch_object(name: str, x: int, y: int, w: int, h: int) -> dict:
    anim_empty = {
        "$type": "RogueEssence.Content.ObjAnimData, RogueEssence",
        "AnimIndex": "",
        "FrameTime": 1,
        "StartFrame": -1,
        "EndFrame": -1,
        "AnimDir": -1,
        "Alpha": 255,
        "AnimFlip": 0,
    }
    return {
        "EntName": name,
        "Direction": 0,
        "EntEnabled": True,
        "EntOrder": 0,
        "InteractOrder": 0,
        "triggerType": 2,
        "ObjectAnim": copy.deepcopy(anim_empty),
        "Passable": True,
        "CurrentAnim": copy.deepcopy(anim_empty),
        "AnimTime": {"Ticks": 0},
        "Cycles": 0,
        "DrawOffset": {"X": 0, "Y": 0},
        "Collider": {"X": int(x), "Y": int(y), "Width": int(w), "Height": int(h)},
    }


def _compute_entities_for_room(
    rid: str, w_px: int, h_px: int, porte_nord: Optional[List[int]]
) -> Tuple[List[dict], List[dict]]:
    cx = (w_px // 2 // 8) * 8
    cy = (int(h_px * 0.60) // 8) * 8
    markers = [
        _make_marker("entrance", cx - 8, cy - 8, 4),
        _make_marker("Centre", cx - 8, cy - 8, 0),
        _make_marker("Entree_Sud", cx - 8, h_px - 48, 4),
        _make_marker("Entree_Nord", cx - 8, int(h_px * 0.42) // 8 * 8, 0),
        _make_marker("Entree_Ouest", 32, cy - 8, 2),
        _make_marker("Entree_Est", w_px - 48, cy - 8, 6),
        _make_marker("Entree_Echelle_Nord", cx - 8, int(h_px * 0.40) // 8 * 8, 0),
        _make_marker("Entree_Porte_Maitre", (porte_nord[0] + 24) // 8 * 8 if porte_nord else cx, int(h_px * 0.44) // 8 * 8, 0),
    ]
    touch_objs: List[dict] = []
    for ent_name, _dest_slug, _dest_marker, side in ROOM_CONNECTIONS.get(rid, []):
        if side == "N":
            touch_objs.append(_make_touch_object(ent_name, cx - 40, 0, 80, 16))
        elif side == "S":
            touch_objs.append(_make_touch_object(ent_name, cx - 40, h_px - 16, 80, 16))
        elif side == "O":
            touch_objs.append(_make_touch_object(ent_name, 0, cy - 32, 16, 64))
        elif side == "E":
            touch_objs.append(_make_touch_object(ent_name, w_px - 16, cy - 32, 16, 64))
        elif side == "EN":
            touch_objs.append(_make_touch_object(ent_name, cx - 24, int(h_px * 0.30) // 8 * 8, 48, 24))
        elif side == "PN" and porte_nord:
            px0, _py0, px1, py1 = porte_nord
            touch_objs.append(
                _make_touch_object(ent_name, (px0 // 8) * 8, ((py1 - 16) // 8) * 8, max(24, ((px1 - px0) // 8) * 8), 24)
            )
    return markers, touch_objs


def _generate_halcyon_init_lua(
    ground_id: str, rid: str, fixed_ambiance: Optional[str]
) -> str:
    lines = [
        f"-- Script Ground Halcyon / town02 (PMDO 0.8.12.0) pour {ground_id}",
        "-- Généré automatiquement depuis le kit Guilde Treehouse (12 salles modulaires, 6 ambiances).",
        "require 'origin.common'",
        "",
        f"local {ground_id} = {{}}",
        "",
        f"function {ground_id}.Init(map)",
        "  DEBUG.EnableDbgCoro()",
        "  COMMON.RespawnAllies()",
        "end",
        "",
        f"function {ground_id}.Enter(map)",
        "  GAME:FadeIn(20)",
        "end",
        "",
        f"function {ground_id}.Update(map) end",
        f"function {ground_id}.GameSave(map) end",
        f"function {ground_id}.GameLoad(map)",
        "  GAME:FadeIn(20)",
        "end",
        "",
    ]
    for ent_name, dest_slug, dest_marker, _side in ROOM_CONNECTIONS.get(rid, []):
        lines.append(f"function {ground_id}.{ent_name}_Touch(obj, activator)")
        lines.append("  DEBUG.EnableDbgCoro()")
        lines.append("  GAME:FadeOut(false, 20)")
        if dest_slug == "metano_town":
            lines.append(f"  GAME:EnterGroundMap('metano_town', '{dest_marker}')")
        elif fixed_ambiance:
            lines.append(
                f"  GAME:EnterGroundMap('guilde_th_{dest_slug}_{fixed_ambiance}', '{dest_marker}')"
            )
        else:
            lines.append("  local amb = SV.guilde_treehouse_ambiance")
            lines.append("  if amb and amb ~= '' then")
            lines.append(
                f"    GAME:EnterGroundMap('guilde_th_{dest_slug}_' .. amb, '{dest_marker}')"
            )
            lines.append("  else")
            lines.append(f"    GAME:EnterGroundMap('guilde_th_{dest_slug}', '{dest_marker}')")
            lines.append("  end")
        lines.append("end")
        lines.append("")

    lines.append(f"return {ground_id}")
    lines.append("")
    return "\n".join(lines)


def _symlink_rel(src: Path, dst: Path) -> None:
    dst.parent.mkdir(parents=True, exist_ok=True)
    if dst.exists() or dst.is_symlink():
        dst.unlink()
    rel = os.path.relpath(src, dst.parent)
    dst.symlink_to(rel)


def build() -> dict:
    kit = json.loads((ROOT / "kit.json").read_text(encoding="utf-8"))
    template_doc = json.loads((ROOT / "cliffdaytest.rsground").read_text(encoding="utf-8-sig"))
    template_obj = template_doc["Object"]
    calques_meta = kit["calques"]  # 11 calques : 00_exterieur .. 10_bordure_avant

    tile_out_dir = CACHE_PKG / "Content" / "Tile"
    ground_out_dir = CACHE_PKG / "Data" / "Ground"
    script_out_dir = CACHE_PKG / "Data" / "Script" / "halcyon" / "ground"
    for d in (tile_out_dir, ground_out_dir, script_out_dir):
        d.mkdir(parents=True, exist_ok=True)

    pkg_tile_dir = RENDERS_PKG / "Content" / "Tile"
    pkg_ground_dir = RENDERS_PKG / "Data" / "Ground"
    pkg_script_dir = RENDERS_PKG / "Data" / "Script" / "halcyon" / "ground"
    for d in (pkg_tile_dir, pkg_ground_dir, pkg_script_dir):
        d.mkdir(parents=True, exist_ok=True)

    generated_tiles: List[str] = []
    generated_grounds: List[str] = []
    max_tiles_in_bank = 0

    for room in kit["salles"]:
        rid = room["id"]
        dossier = room["dossier"]
        nom_fr = room["nom"]
        w_px, h_px = room["dimensions"]
        gw, gh = w_px // 8, h_px // 8
        has_windows = room["trous_fenetres"] > 0

        # 1) Banques .tile par salle (Jour, Nuit, et Fenêtres 6 ambiances)
        bank_jour = DedupTileBank(f"GTH_{rid}_CORPS_JOUR")
        bank_nuit = DedupTileBank(f"GTH_{rid}_CORPS_NUIT")
        bank_win = DedupTileBank(f"GTH_{rid}_FENETRES_6AMB") if has_windows else None

        grids_body: Dict[str, List[List[List[Optional[int]]]]] = {"jour": [], "nuit": []}
        for mode_in, bank in (("jour", bank_jour), ("nuit", bank_nuit)):
            for idx_l, cinfo in enumerate(calques_meta):
                if idx_l == 0:
                    grids_body[mode_in].append([[None] * gh for _ in range(gw)])
                    continue
                lp = ROOT / "calques" / dossier / mode_in / f"{cinfo['id']}.png"
                arr = np.array(Image.open(lp).convert("RGBA"))
                grids_body[mode_in].append(bank.add_image_grid(arr))

        grids_win: Dict[str, List[List[Optional[int]]]] = {}
        for amb in AMBIANCES:
            if has_windows and bank_win is not None:
                wp = ROOT / "fenetres_exterieur" / rid / f"{amb}.png"
                w_arr = np.array(Image.open(wp).convert("RGBA"))
                grids_win[amb] = bank_win.add_image_grid(w_arr)
            else:
                grids_win[amb] = [[None] * gh for _ in range(gw)]

        # Écriture des .tile de la salle
        banks_to_save = [(bank_jour.sheet_name, bank_jour), (bank_nuit.sheet_name, bank_nuit)]
        if bank_win is not None and bank_win.count > 0:
            banks_to_save.append((bank_win.sheet_name, bank_win))

        for sname, bobj in banks_to_save:
            max_tiles_in_bank = max(max_tiles_in_bank, bobj.count)
            tpath = tile_out_dir / f"{sname}.tile"
            tpath.write_bytes(bobj.to_tile_bytes())
            _symlink_rel(tpath, pkg_tile_dir / f"{sname}.tile")
            generated_tiles.append(f"{sname}.tile")

        # 2) Collisions 8×8 calculées depuis `01_sol.png` (alpha >= 96 -> praticable Tags=0, sinon mur Tags=1)
        sol_arr = np.array(Image.open(ROOT / "calques" / dossier / "jour" / "01_sol.png").convert("RGBA"))
        obstacles = []
        for cx in range(gw):
            col_obs = []
            x0 = cx * 8
            for cy in range(gh):
                y0 = cy * 8
                patch_a = sol_arr[y0 : y0 + 8, x0 : x0 + 8, 3]
                walkable = int((patch_a >= 96).sum()) >= 24
                col_obs.append(
                    {
                        "Bounds": {"X": x0, "Y": y0, "Width": 8, "Height": 8},
                        "Tags": 0 if walkable else 1,
                    }
                )
            obstacles.append(col_obs)

        markers, touch_objs = _compute_entities_for_room(rid, w_px, h_px, room.get("porte_nord"))

        # Pré-construit une seule fois les 10 calques intérieurs (01..10) pour jour et pour nuit
        body_layers_precomp: Dict[str, List[dict]] = {}
        for mode_in, bsheet in (("jour", bank_jour.sheet_name), ("nuit", bank_nuit.sheet_name)):
            blist: List[dict] = []
            for idx_l in range(1, len(calques_meta)):
                cinfo = calques_meta[idx_l]
                grid_ref = grids_body[mode_in][idx_l]
                tiles_cols = [
                    [_cell_json(bsheet, grid_ref[cx][cy]) for cy in range(gh)]
                    for cx in range(gw)
                ]
                blist.append(
                    {
                        "Name": f"{cinfo['id']}_{cinfo['nom']}",
                        "Layer": 4 if idx_l == 10 else 0,
                        "Visible": True,
                        "Tiles": tiles_cols,
                    }
                )
            body_layers_precomp[mode_in] = blist

        # 3) Génération des 7 cartes .rsground + scripts Lua Halcyon de la salle :
        #    1 canonique `guilde_th_<dossier>` + 6 variantes d'ambiance `guilde_th_<dossier>_<amb>`
        variants_spec: List[Tuple[str, str, Optional[str]]] = [
            (f"guilde_th_{dossier}", "jour", None),
        ] + [(f"guilde_th_{dossier}_{amb}", amb, amb) for amb in AMBIANCES]

        entities_payload = [
            {
                "Name": "Passages_et_Entrees_Halcyon",
                "Visible": True,
                "MapChars": [],
                "GroundObjects": touch_objs,
                "Spawners": [],
                "Markers": markers,
            }
        ]

        for ground_id, amb, fixed_amb in variants_spec:
            interior_mode = "nuit" if amb in NIGHT_INTERIOR_AMBIANCES else "jour"
            body_sheet = bank_jour.sheet_name if interior_mode == "jour" else bank_nuit.sheet_name
            sheet_win = (
                bank_win.sheet_name
                if (bank_win is not None and bank_win.count > 0)
                else body_sheet
            )
            grid_win = grids_win[amb]
            layer0_json = {
                "Name": f"{calques_meta[0]['id']}_{calques_meta[0]['nom']}",
                "Layer": 0,
                "Visible": True,
                "Tiles": [
                    [_cell_json(sheet_win, grid_win[cx][cy]) for cy in range(gh)]
                    for cx in range(gw)
                ],
            }
            layers_json = [layer0_json] + body_layers_precomp[interior_mode]

            obj = dict(template_obj)
            suffix_label = f" ({amb})" if fixed_amb else ""
            obj["AssetName"] = ground_id
            obj["Name"] = {"DefaultText": f"Guilde Treehouse — {nom_fr}{suffix_label}", "LocalTexts": {}}
            obj["Comment"] = (
                f"Guilde Treehouse PMD ({dossier}, ambiance {amb}, intérieur {interior_mode}) — "
                f"11 calques indépendants, fenêtres transparentes, passages ouverts PMD. Non testé runtime C#."
            )
            obj["Music"] = "Wigglytuff's Guild.ogg"
            obj["obstacles"] = obstacles
            obj["Layers"] = layers_json
            obj["Entities"] = entities_payload

            doc = {"Version": "0.8.12.0", "Object": obj}
            g_bytes = ("\ufeff" + json.dumps(doc, ensure_ascii=False, separators=(",", ":"))).encode(
                "utf-8"
            )
            gpath = ground_out_dir / f"{ground_id}.rsground"
            gpath.write_bytes(g_bytes)
            _symlink_rel(gpath, pkg_ground_dir / f"{ground_id}.rsground")
            generated_grounds.append(ground_id)

            # Script Lua Halcyon sous `Data/Script/halcyon/ground/<ground_id>/init.lua`
            lua_txt = _generate_halcyon_init_lua(ground_id, rid, fixed_amb)
            sfile_cache = script_out_dir / ground_id / "init.lua"
            sfile_cache.parent.mkdir(parents=True, exist_ok=True)
            sfile_cache.write_text(lua_txt, encoding="utf-8")
            sfile_pkg = pkg_script_dir / ground_id / "init.lua"
            sfile_pkg.parent.mkdir(parents=True, exist_ok=True)
            sfile_pkg.write_text(lua_txt, encoding="utf-8")

    # Mod.xml autonome Halcyon-compatible + metadata.json + archive ZIP virtuelle
    (RENDERS_PKG / "Mod.xml").write_text(
        "<Header>\n"
        "  <Name>Guilde Treehouse PMD (Architecture Halcyon)</Name>\n"
        "  <Author>Minori</Author>\n"
        "  <Description>12 salles modulaires, passages ouverts PMD, fenêtres transparentes et 6 ambiances.</Description>\n"
        "  <Namespace>halcyon</Namespace>\n"
        "  <UUID>CAE98609-7A96-4CFC-B5AB-0E1D41F6A1FF</UUID>\n"
        "  <Version>1.0.0</Version>\n"
        "  <GameVersion>0.8.12</GameVersion>\n"
        "  <ModType>Mod</ModType>\n"
        "</Header>\n",
        encoding="utf-8",
    )

    meta = {
        "map_id": MAP_ID,
        "lot": LOT_NAME,
        "rooms_count": len(kit["salles"]),
        "ambiances": list(AMBIANCES),
        "rsground_count": len(generated_grounds),
        "tile_banks_count": len(generated_tiles),
        "max_tiles_per_bank": max_tiles_in_bank,
        "ground_ids": generated_grounds,
        "tile_files": generated_tiles,
        "provenance": "Kit Guilde Treehouse PMD (12 salles modulaires, fenêtres transparentes, 6 ambiances) compilé au standard Palikadude/Halcyon & town02 (PMDO 0.8.12.0).",
    }
    RENDERS_DIR.mkdir(parents=True, exist_ok=True)
    (RENDERS_DIR / "metadata.json").write_text(
        json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8"
    )

    # Archive ZIP téléchargeable `GTH1_PMDO_0.8.12.zip`
    VZIP_PATH.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(VZIP_PATH, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=6) as zf:
        zf.write(RENDERS_PKG / "Mod.xml", arcname="Mod.xml")
        for tf in sorted(tile_out_dir.glob("*.tile")):
            zf.write(tf, arcname=f"Content/Tile/{tf.name}")
        for gf in sorted(ground_out_dir.glob("*.rsground")):
            zf.write(gf, arcname=f"Data/Ground/{gf.name}")
        for sf in sorted(script_out_dir.glob("*/init.lua")):
            zf.write(sf, arcname=f"Data/Script/halcyon/ground/{sf.parent.name}/init.lua")

    return meta


if __name__ == "__main__":
    res = build()
    print(
        f"[OK] Guilde Treehouse Halcyon compilée : {res['rsground_count']} .rsground, "
        f"{res['tile_banks_count']} banques .tile (max {res['max_tiles_per_bank']} tuiles/banque), "
        f"ZIP={VZIP_PATH.stat().st_size / 1048576:.2f} Mo"
    )
