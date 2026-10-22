#!/usr/bin/env python3
"""Promeut les Grounds Waves of Nostalgia dans New Era : Data/, Content/, index.

Ce que la promotion installe
----------------------------
    Content/Tile/WoN_<carte>_<saison>.tile   les planches de tuiles
    Content/Tile/index.idx                   une entree par planche
    Data/Ground/won_<carte>_<saison>.rsground les Grounds
    Data/Script/halcyon/ground/<asset>/init.lua  les sorties

Le damier mauve, et comment on l'evite
--------------------------------------
`GraphicsManager.GetTile()` demande a `TileIndex.GetPosition(sheet, texLoc)`.
Cette fonction renvoie `0` dans DEUX cas : planche absente de `index.idx`, ou
couple `(X, Y)` absent de la planche declaree. Comme `0` n'est jamais `> 0`, le
moteur rend `BaseSheet.LoadError()` — le damier mauve.

Installer les `.tile` sans mettre `index.idx` a jour produirait donc 16 cartes
entierement en damier. L'index est reecrit INTEGRALEMENT depuis sa propre
lecture : aucune ecriture partielle, aucun offset recalcule a la main.

Garde-fous, tous bloquants
--------------------------
1. `index.idx` est sauvegarde avant toute ecriture, et son sha consigne.
2. Une planche deja declaree fait echouer l'installation — on n'ecrase pas.
3. Les entrees preexistantes sont comparees une a une APRES ecriture : elles
   doivent etre intactes, sinon l'index sauvegarde est restaure.
4. Chaque Ground installe est relu depuis le disque.
5. Le nombre de fichiers `.tile` doit egaler le nombre d'entrees d'index.

Rien n'est installe si l'audit de texture n'est pas `CLEAN` : promouvoir des
textures dont on n'a pas prouve l'integrite reviendrait a installer un bug.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import shutil
import struct
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parent
SEASONS = ("spring", "summer", "autumn", "winter")


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def read_index(path: Path):
    data = path.read_bytes()
    offset = 0
    count = struct.unpack_from("<I", data, offset)[0]
    offset += 4
    sets = []
    for _ in range(count):
        length = data[offset]
        offset += 1
        name = data[offset:offset + length].decode("utf-8")
        offset += length
        tile_size, entry_count = struct.unpack_from("<II", data, offset)
        offset += 8
        entries = []
        for _ in range(entry_count):
            key, position = struct.unpack_from("<QQ", data, offset)
            offset += 16
            entries.append((key, position))
        sets.append({"name": name, "tile_size": tile_size, "entries": entries})
    if offset != len(data):
        raise ValueError("index.idx malforme")
    return sets


def write_index(path: Path, sets) -> None:
    parts = [struct.pack("<I", len(sets))]
    packer = struct.Struct("<QQ").pack
    for entry in sets:
        name = entry["name"].encode("utf-8")
        parts.append(bytes([len(name)]) + name)
        parts.append(struct.pack("<II", entry["tile_size"], len(entry["entries"])))
        parts.append(b"".join(packer(k, o) for k, o in entry["entries"]))
    path.write_bytes(b"".join(parts))


def sheet_entries(tile_path: Path):
    data = tile_path.read_bytes()
    tile_size, count = struct.unpack_from("<II", data, 0)
    offset = 8
    entries = []
    for _ in range(count):
        key, position = struct.unpack_from("<QQ", data, offset)
        offset += 16
        entries.append((key, position))
    return tile_size, entries


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--grounds", type=Path, default=REPO / ".runtime-cache/won-grounds")
    parser.add_argument("--audit", type=Path,
                        default=ROOT / "reports/won-world/TEXTURE_AUDIT.json")
    parser.add_argument("--backup", type=Path, default=REPO / ".runtime-cache/won-promotion-backup")
    parser.add_argument("--report", type=Path, default=ROOT / "reports/won-world/PROMOTION.json")
    parser.add_argument("--apply", action="store_true")
    args = parser.parse_args()

    audit = json.loads(args.audit.read_text())
    if audit["verdict"] != "CLEAN":
        raise SystemExit(f"audit de texture non CLEAN ({audit['anomaly_count']} anomalies) : "
                         "promotion refusee")

    tile_dir = REPO / "Content/Tile"
    ground_dir = REPO / "Data/Ground"
    script_root = REPO / "Data/Script/halcyon/ground"
    index_path = tile_dir / "index.idx"

    existing = read_index(index_path)
    existing_names = {e["name"] for e in existing}

    planned = []
    for map_dir in sorted(p for p in args.grounds.iterdir() if p.is_dir()):
        name = map_dir.name
        for season in SEASONS:
            asset = f"won_{name}_{season}"
            sheet_stem = f"WoN_{name}_{season}"
            source_tile = map_dir / f"{season}/Content/Tile/{sheet_stem}.tile"
            source_ground = map_dir / f"{season}/Data/Ground/{asset}.rsground"
            source_script = (map_dir / season /
                             f"Data/Script/halcyon/ground/{asset}/init.lua")
            if not source_tile.is_file() or not source_ground.is_file():
                raise SystemExit(f"source manquante pour {asset}")
            if sheet_stem in existing_names:
                raise SystemExit(f"planche {sheet_stem} deja dans index.idx : "
                                 "on n'ecrase pas, promotion refusee")
            planned.append({"asset": asset, "sheet": sheet_stem, "map": name, "season": season,
                            "tile": source_tile, "ground": source_ground,
                            "script": source_script if source_script.is_file() else None})

    report = {
        "schema": "new-era.won-promotion.v1",
        "audit_verdict": audit["verdict"],
        "audit_anomalies": audit["anomaly_count"],
        "grounds_planned": len(planned),
        "sheets_planned": len(planned),
        "index_sheets_before": len(existing),
        "applied": bool(args.apply),
    }

    if not args.apply:
        report["note"] = "simulation : aucun fichier ecrit"
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(report, indent=2, ensure_ascii=False,
                                          sort_keys=True) + "\n", encoding="utf-8")
        print(json.dumps(report, indent=2, ensure_ascii=False))
        return 0

    args.backup.mkdir(parents=True, exist_ok=True)
    backup_index = args.backup / "index.idx.pre-won.bak"
    if not backup_index.exists():
        shutil.copyfile(index_path, backup_index)
    report["index_backup"] = str(backup_index)
    report["index_sha256_before"] = sha256_file(index_path)

    installed = []
    for item in planned:
        shutil.copyfile(item["tile"], tile_dir / f"{item['sheet']}.tile")
        shutil.copyfile(item["ground"], ground_dir / f"{item['asset']}.rsground")
        if item["script"]:
            target_dir = script_root / item["asset"]
            target_dir.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(item["script"], target_dir / "init.lua")
        installed.append(item["asset"])

    new_sets = list(existing)
    for item in planned:
        tile_size, entries = sheet_entries(tile_dir / f"{item['sheet']}.tile")
        new_sets.append({"name": item["sheet"], "tile_size": tile_size, "entries": entries})
    write_index(index_path, new_sets)

    # Relecture : les entrees preexistantes doivent etre intactes.
    after = read_index(index_path)
    if len(after) != len(existing) + len(planned):
        shutil.copyfile(backup_index, index_path)
        raise SystemExit("nombre de planches inattendu : index restaure")
    for before_entry, after_entry in zip(existing, after[:len(existing)]):
        if (before_entry["name"] != after_entry["name"]
                or before_entry["tile_size"] != after_entry["tile_size"]
                or before_entry["entries"] != after_entry["entries"]):
            shutil.copyfile(backup_index, index_path)
            raise SystemExit(f"entree preexistante alteree ({before_entry['name']}) : "
                             "index restaure")

    # Chaque Ground installe doit se relire.
    for item in planned:
        obj = json.loads((ground_dir / f"{item['asset']}.rsground")
                         .read_text(encoding="utf-8-sig"))["Object"]
        if obj["AssetName"] != item["asset"]:
            raise SystemExit(f"{item['asset']}: AssetName divergent apres installation")

    tiles_on_disk = len(list(tile_dir.glob("WoN_*.tile")))
    index_won = sum(1 for e in after if e["name"].startswith("WoN_"))
    if tiles_on_disk != index_won:
        shutil.copyfile(backup_index, index_path)
        raise SystemExit(f"{tiles_on_disk} planches sur disque vs {index_won} dans l'index")

    report.update({
        "index_sheets_after": len(after),
        "index_preexisting_intact": True,
        "index_sha256_after": sha256_file(index_path),
        "tiles_installed": tiles_on_disk,
        "grounds_installed": len(installed),
        "scripts_installed": sum(1 for i in planned if i["script"]),
        "assets": sorted(installed),
    })
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2, ensure_ascii=False,
                                      sort_keys=True) + "\n", encoding="utf-8")
    print(json.dumps({k: report[k] for k in
                      ("grounds_installed", "tiles_installed", "scripts_installed",
                       "index_sheets_before", "index_sheets_after",
                       "index_preexisting_intact")}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
