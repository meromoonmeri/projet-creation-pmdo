from __future__ import annotations

import json
import subprocess
from pathlib import Path

from .util import atomic_write_json, sha256_file


def git_output(repository: Path, *args: str) -> str:
    return subprocess.check_output(["git", "-C", str(repository), *args], text=True).strip()


def audit_sources(pmu_root: Path, report_path: Path) -> dict:
    repositories = {}
    audited_names = (
        "PMU-Client", "PMU-Server", "Scripts", "PMU-Client-fork", "PMU-Server-fork",
        "pmdcp-Client", "pmdcp-PMD-Toolkit", "pmdcp-UpdatePackages", "pmdcp-RaileyBuilder",
    )
    for name in audited_names:
        path = pmu_root / name
        if not (path / ".git").exists():
            continue
        repositories[name] = {
            "path": str(path), "head": git_output(path, "rev-parse", "HEAD"),
            "commit_count_all": int(git_output(path, "rev-list", "--all", "--count")),
            "branches_all": git_output(path, "branch", "-a").splitlines(),
            "remotes": git_output(path, "remote", "-v").splitlines(),
        }
    client = pmu_root / "PMU-Client"
    server = pmu_root / "PMU-Server"
    map_files = sorted((client / "resources/MapData").glob("Map-*.dat"))
    tile_files = sorted((client / "resources/GFX/Tiles").glob("Tiles*.tile"))
    content_zip = server / "Content_Data.zip"
    report = {
        "status": "DISCOVERED", "repositories": repositories,
        "assets": {
            "client_v9_maps": {"count": len(map_files), "directory": str(map_files[0].parent if map_files else "")},
            "tilesets": {"count": len(tile_files), "directory": str(tile_files[0].parent if tile_files else ""), "total_bytes": sum(p.stat().st_size for p in tile_files)},
            "content_data_zip": {"path": str(content_zip), "size": content_zip.stat().st_size, "sha256": sha256_file(content_zip)},
            "script_dll": {"path": str(server / "Data/Scripts/Script.dll"), "sha256": sha256_file(server / "Data/Scripts/Script.dll")},
        },
        "authoritative_code": {
            "v9_loader_saver": str(client / "Client/Maps/MapHelper.cs"),
            "tile_archive_loader": str(client / "Client/Graphics/Tileset.cs"),
            "renderer": str(client / "Client/Graphics/Renderers/Maps/MapRenderer.cs"),
            "map_editor": str(client / "Client/Windows/Editors/MapEditor"),
            "server_sql_loader_saver": str(server / "DataManager/DataManager/Maps/MapDataManager.cs"),
            "server_map_runtime": str(server / "Server/Server/Maps"),
            "scripts_source": str(server / "Server/Script"),
            "historical_pmd_toolkit": str(pmu_root / "pmdcp-PMD-Toolkit"),
            "historical_tileset_atlases": str(pmu_root / "pmdcp-PMD-Toolkit/Dependencies/Assets/Tile"),
        },
        "audit_notes": [
            "The Git histories are shallow by upstream content, not by clone depth.",
            "The sole GitHub forks of PMU-Client and PMU-Server point to the same five-commit history.",
            "No releases or tags and no deleted map editor/generator executable were found in those histories.",
            "The pmdcp organization was audited: PMD-Toolkit contains a later independent editor and historical PNG tile atlases used only for pixel validation; UpdatePackages/RaileyBuilder contain no missing PMU map corpus.",
            "Content_Data.zip contains SQL/batch members only; no hidden graphics or map images.",
            "DLL decompilation is not used where corresponding C# source is present.",
            "The 140 client map ciphertexts reject the public placeholder key. The deployment key is absent from source, all history, and the sole fork; these caches remain BLOCKED rather than guessed.",
        ],
    }
    atomic_write_json(report_path, report)
    return report
