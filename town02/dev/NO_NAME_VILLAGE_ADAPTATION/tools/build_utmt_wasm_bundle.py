#!/usr/bin/env python3
"""Build a deterministic UTMT/UndertaleModLib bundle for .NET browser-WASM.

Inputs are kept outside Git:
* cepha-cli's `_framework` directory (the .NET WASM runtime);
* PortsMaster's pinned UTMT 0.6.1 `utmt-cli` directory.

The output can either run the official CLI decompiler (with the audited WASM
compatibility patch) or the exhaustive reflection extractor compiled from
NoNameVillageExtractor.cs.
"""
from __future__ import annotations

import argparse
import base64
import hashlib
import json
import shutil
import subprocess
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def integrity(path: Path) -> str:
    return "sha256-" + base64.b64encode(hashlib.sha256(path.read_bytes()).digest()).decode()


def convert(source: Path, target: Path) -> None:
    subprocess.run(
        ["python3", str(HERE / "pe_to_webcil.py"), str(source), str(target)],
        check=True,
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--cepha-framework", type=Path, required=True)
    parser.add_argument("--utmt-directory", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--mode", choices=("extract", "decompile"), required=True)
    args = parser.parse_args()

    framework = args.output / "_framework"
    if args.output.exists():
        shutil.rmtree(args.output)
    shutil.copytree(args.cepha_framework, framework)
    boot = framework / "dotnet.boot.js"
    if not boot.is_file():
        raise FileNotFoundError(boot)

    converted = []
    with tempfile.TemporaryDirectory(prefix="nv-utmt-") as temp_name:
        temp = Path(temp_name)
        subprocess.run(
            [
                "python3",
                str(HERE / "patch_utmt_for_wasm.py"),
                str(args.utmt_directory),
                str(temp),
            ],
            check=True,
        )
        for dll in sorted(args.utmt_directory.glob("*.dll")):
            source = dll
            if args.mode == "decompile" and dll.name in {"UndertaleModCli.dll", "UndertaleModLib.dll"}:
                source = temp / dll.name
            target = framework / (dll.stem + ".wasm")
            convert(source, target)
            converted.append((dll.name, sha256(source), target))

    extractor = HERE / "runtime/NoNameVillageExtractor.dll"
    extractor_target = framework / "NoNameVillageExtractor.wasm"
    convert(extractor, extractor_target)
    converted.append((extractor.name, sha256(extractor), extractor_target))

    text = boot.read_text(encoding="utf-8")
    start_marker, end_marker = "/*json-start*/", "/*json-end*/"
    start = text.index(start_marker) + len(start_marker)
    end = text.index(end_marker)
    config = json.loads(text[start:end])
    config["mainAssemblyName"] = (
        "NoNameVillageExtractor.dll" if args.mode == "extract" else "UndertaleModCli.dll"
    )
    names = {target.name for _, _, target in converted}
    config["resources"]["assembly"] = [
        row for row in config["resources"]["assembly"]
        if row["name"] != "cepha.wasm" and row["name"] not in names
    ]
    for _, _, target in converted:
        config["resources"]["assembly"].append(
            {"virtualPath": target.name, "name": target.name, "integrity": integrity(target)}
        )
    config["resources"]["pdb"] = []
    boot.write_text(
        text[:start] + json.dumps(config, indent=2) + text[end:], encoding="utf-8"
    )

    report = {
        "schema": "no-name-village.utmt-wasm-bundle.v1",
        "mode": args.mode,
        "mainAssembly": config["mainAssemblyName"],
        "runtime": {
            "dotnetNativeSha256": sha256(framework / "dotnet.native.wasm"),
            "dotnetBootSha256": sha256(boot),
        },
        "assemblies": [
            {
                "name": name,
                "sourceSha256": source_hash,
                "webcil": target.name,
                "webcilSha256": sha256(target),
            }
            for name, source_hash, target in converted
        ],
    }
    (args.output / "bundle-manifest.json").write_text(
        json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    print(json.dumps({"mode": args.mode, "assemblies": len(converted), "output": str(args.output)}))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
