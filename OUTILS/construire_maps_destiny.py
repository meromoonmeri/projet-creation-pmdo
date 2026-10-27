#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Construit TOUTES les maps Ground des aperçus (visionneuses comprises) et les
intègre à quest_pmd_destiny/.

Principe : chaque lot d'aperçu est un projet de map généré ; ses scripts
`source/**/build.py` (branche arena/e39626d2) régénèrent la map PMDO :

- type A (`ground_project`) : sorties dans /tmp/destiny-src/.cache/<lot>/<ns>/
  (Data/Ground/*.rsground, Content/Tile/*.tile, Data/Script/) ;
- type B (`build_rsground_package`) : sorties dans /tmp/destiny-src/.cache/tiles/<lot>/
  (.rsground + *.tile) et dans .cache/virtual_zips/<MAP_ID>_PMDO_0.8.12.zip.

Les maps récoltées sont clampees (clamp_map + frontiere, comme la bibliotheque)
puis ecrites dans bibliotheque_ground/lots/<lot>/ ; la quest est ensuite
reconstruite par OUTILS/construire_quest_destiny.py et l'index des tuiles
regenere (format INSTALLER.py).

Etapes de /tmp/destiny-src (hors depot, non persiste) :
  source/ + renders/ extraits de la branche arena/e39626d2,
  zips racine copies (gabarit mod_metano_expeditions),
  bruts/ + reference/ recuperes de meromoonmeri/projet-pmdo,
  images de reference racine recuperees de projet-pmdo pour exécuter les
  builds — JAMAIS recopiées dans la quest.

Usage :
    python3 OUTILS/construire_maps_destiny.py                  # tout
    python3 OUTILS/construire_maps_destiny.py --jobs 2 --etapes build
    python3 OUTILS/construire_maps_destiny.py --lots arene_groudon_magma_v1
"""
from __future__ import annotations

import argparse
import concurrent.futures
import importlib.util
import json
import re
import shutil
import subprocess
import sys
import time
import zipfile
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BUILD = Path("/tmp/destiny-src")
BRANCHE = "origin/arena/e39626d2-projet-creation-pmdo"
BIB_LOTS = ROOT / "bibliotheque_ground" / "lots"
QUEST = ROOT / "quest_pmd_destiny"
STATUS = BUILD / "build_status.json"
LOGS = BUILD / "build_logs"
VENV_PY = ROOT / ".venv" / "bin" / "python"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(m)
    return m


def build_files() -> list[str]:
    """Chemins source/**/build.py qui produisent des maps (type A ou B)."""
    out = subprocess.run(
        ["git", "grep", "-l", "-E", "ground_project|build_rsground_package",
         BRANCHE, "--", "source/*build.py", "source/**/build.py"],
        cwd=ROOT, capture_output=True, text=True).stdout
    files = sorted({line.split(":", 1)[1] for line in out.splitlines() if line})
    return files


def lot_of(rel: str) -> str:
    return rel.split("/")[1]


# ------------------------------------------------------------------- build
def run_build(rel: str) -> dict:
    t0 = time.time()
    lot = lot_of(rel)
    log = LOGS / f"{lot}__{rel.replace('/', '_')}.log"
    env = {"PATH": "/usr/bin:/bin:/usr/local/bin",
           "PYTHONPATH": f"{BUILD}:{BUILD / 'source'}",
           "OPENBLAS_NUM_THREADS": "1", "OMP_NUM_THREADS": "1",
           "HOME": "/tmp"}
    try:
        r = subprocess.run([str(VENV_PY), rel],
                           cwd=BUILD, env=env, capture_output=True, text=True,
                           timeout=1800)
        log.write_text(r.stdout + "\n--- stderr ---\n" + r.stderr, encoding="utf-8")
        ok = r.returncode == 0
        err = "" if ok else (r.stderr.strip().splitlines() or ["?"])[-1][:200]
    except subprocess.TimeoutExpired:
        ok, err = False, "timeout 1800 s"
        log.write_text("TIMEOUT\n", encoding="utf-8")
    return {"rel": rel, "lot": lot, "ok": ok, "err": err, "s": round(time.time() - t0, 1)}


def etape_build(files: list[str], jobs: int) -> dict:
    LOGS.mkdir(exist_ok=True)
    status = {}
    if STATUS.exists():
        raw = json.loads(STATUS.read_text())
        # migration : anciennes clés = nom de lot
        for k, v in raw.items():
            rel = v.get("rel") or f"source/{k}/build.py"
            status[rel] = {**v, "rel": rel, "lot": v.get("lot") or lot_of(rel)}
    todo = [f for f in files if not status.get(f, {}).get("ok")]
    print(f"[build] {len(todo)} scripts à exécuter ({jobs} jobs)", flush=True)
    with concurrent.futures.ThreadPoolExecutor(max_workers=jobs) as ex:
        futs = {ex.submit(run_build, f): f for f in todo}
        for i, f in enumerate(concurrent.futures.as_completed(futs), 1):
            res = f.result()
            status[res["rel"]] = res
            mark = "OK " if res["ok"] else "FAIL"
            print(f"[build {i}/{len(todo)}] {mark} {res['rel']} ({res['s']} s)"
                  + ("" if res["ok"] else f" — {res['err']}"), flush=True)
            STATUS.write_text(json.dumps(status, ensure_ascii=False, indent=1))
    n_ok = sum(1 for v in status.values() if v.get("ok"))
    print(f"[build] terminé : {n_ok}/{len(status)} OK", flush=True)
    return status


# ------------------------------------------------------------------ harvest
def clamp_and_write(bib, lot: str, name: str, raw: bytes, origine: str,
                    rapport: list) -> None:
    txt = raw.lstrip(b"\xef\xbb\xbf").strip()
    if not txt.startswith(b"{"):
        rapport.append({"map": name, "lot": lot, "origine": origine,
                        "erreur": "contenu non JSON"})
        return
    doc = json.loads(raw.decode("utf-8-sig"))
    stats, doc = bib.clamp_map(doc)
    refs = bib.collect_refs(doc)
    ouvertes, fr = bib.cellules_bord_ouvertes(doc)
    dest = BIB_LOTS / lot / "Data" / "Ground" / name
    k = 2
    while dest.exists():
        dest = BIB_LOTS / lot / "Data" / "Ground" / f"{name[:-9]}_{k}.rsground"
        k += 1
    dest.parent.mkdir(parents=True, exist_ok=True)
    out = json.dumps(doc, ensure_ascii=False, separators=(",", ":")).encode("utf-8")
    dest.write_bytes(out)
    rapport.append({"map": dest.name, "lot": lot, "origine": origine,
                    "clamp": stats, "frontiere": fr,
                    "chevauchements_entites": bib.chevauchements(doc),
                    "refs_sheets": len(refs.get("sheets", [])),
                    "refs_anims": len(refs.get("anims", []))})


def copy_tree(src: Path, dst_root: Path) -> int:
    n = 0
    for p in src.rglob("*"):
        if p.is_file():
            d = dst_root / p.relative_to(src)
            d.parent.mkdir(parents=True, exist_ok=True)
            if not d.exists() or d.read_bytes() != p.read_bytes():
                shutil.copyfile(p, d)
            n += 1
    return n


def etape_harvest(files: list[str]) -> list[dict]:
    bib = load_module("cbg", ROOT / "OUTILS" / "construire_bibliotheque_ground.py")
    rapport = []
    vzip_dir = BUILD / ".cache" / "virtual_zips"
    lots = sorted({lot_of(f) for f in files})
    for lot in lots:
        stages = [s for s in (BUILD / ".cache" / lot).glob("*/")
                  if (s / "Data" / "Ground").is_dir()] if (BUILD / ".cache" / lot).is_dir() else []
        tiles_dir = BUILD / ".cache" / "tiles" / lot
        if not stages and not tiles_dir.is_dir():
            continue
        # harvest idempotent : le lot est reconstruit à chaque exécution
        for sub in ("Data/Ground", "Data/Script", "Content"):
            shutil.rmtree(BIB_LOTS / lot / sub, ignore_errors=True)
        # type A : .cache/<lot>/<ns>/
        for stage in stages:
            for rs in sorted((stage / "Data" / "Ground").glob("*.rsground")):
                clamp_and_write(bib, lot, rs.name, rs.read_bytes(),
                                f"build {lot}: {rs.relative_to(BUILD)}", rapport)
            for sub in ("Content", "Data/Script"):
                if (stage / sub).is_dir():
                    copy_tree(stage / sub, BIB_LOTS / lot / sub)
        # type B : .cache/tiles/<lot>/ (.rsground + *.tile à plat + Data/)
        if tiles_dir.is_dir():
            for rs in sorted(tiles_dir.rglob("*.rsground")):
                clamp_and_write(bib, lot, rs.name, rs.read_bytes(),
                                f"build {lot}: {rs.relative_to(BUILD)}", rapport)
            tdst = BIB_LOTS / lot / "Content" / "Tile"
            for t in sorted(tiles_dir.glob("*.tile")):
                tdst.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(t, tdst / t.name)
            if (tiles_dir / "Data" / "Script").is_dir():
                copy_tree(tiles_dir / "Data" / "Script", BIB_LOTS / lot / "Data" / "Script")
        meta = {"source": f"build source/{lot}/build.py (branche arena/e39626d2, maps régénérées)",
                "lot": lot}
        (BIB_LOTS / lot).mkdir(parents=True, exist_ok=True)
        (BIB_LOTS / lot / "lot.json").write_text(
            json.dumps(meta, ensure_ascii=False, indent=1), encoding="utf-8")
    orphelins = [p.name for p in vzip_dir.glob("*.zip")] if vzip_dir.is_dir() else []
    (ROOT / "bibliotheque_ground" / "rapport_maps_destiny.json").write_text(
        json.dumps({"date": date.today().isoformat(), "maps": rapport,
                    "virtual_zips": orphelins}, ensure_ascii=False, indent=1),
        encoding="utf-8")
    n_lots = len({m["lot"] for m in rapport})
    print(f"[harvest] {len(rapport)} maps récoltées et clampees sur {n_lots} lots", flush=True)
    return rapport


# -------------------------------------------------------------------- quest
def etape_quest() -> None:
    r = subprocess.run([str(VENV_PY), str(ROOT / "OUTILS" / "construire_quest_destiny.py")],
                       cwd=ROOT, capture_output=True, text=True)
    print(r.stdout, flush=True)
    if r.returncode != 0:
        print(r.stderr, flush=True)
        raise SystemExit("construction de la quest en échec")
    imp = load_module("imp", ROOT / "OUTILS" / "importer_tiles_town02.py")
    nodes = {}
    for tile in sorted((QUEST / "Content" / "Tile").glob("*.tile")):
        with tile.open("rb") as f:
            nodes[tile.stem] = imp.read_node(f)
    (QUEST / "Content" / "Tile" / "index.idx").write_bytes(imp.encode_index(nodes))
    print(f"[quest] index tuiles régénéré : {len(nodes)} tilesets", flush=True)


# -------------------------------------------------------------------- audit
def etape_audit(status: dict, rapport: list[dict]) -> None:
    maps = sorted((QUEST / "Data" / "Ground").glob("*.rsground"))
    fails = {l: v for l, v in status.items() if not v.get("ok")}
    lines = [
        "# Récupération des maps des aperçus dans la quest", "",
        f"Généré le {date.today().isoformat()} par `OUTILS/construire_maps_destiny.py`.", "",
        f"- Scripts de build exécutés : **{len(status)}** "
        f"({sum(1 for v in status.values() if v.get('ok'))} OK, {len(fails)} échecs).",
        f"- Maps récoltées et clampees : **{len(rapport)}** "
        f"({len({m['lot'] for m in rapport})} lots).",
        f"- Maps présentes dans `quest_pmd_destiny/Data/Ground/` : **{len(maps)}**.", "",
        "## Échecs de build (maps non récupérées)", "",
    ]
    if not fails:
        lines.append("Aucun.")
    for l, v in sorted(fails.items()):
        lines.append(f"- `{l}` : {v.get('err', '?')}")
    lines += ["", "## Provenance", "",
              "Les maps sont régénérées par les scripts `source/**/build.py` de la branche "
              "`arena/e39626d2` (méthode documentée dans chaque `renders/<lot>/manifest.json`). "
              "Les images de référence servant aux builds restent hors du dépôt et ne sont pas "
              "distribuées. `art_approved: false` / `runtime_tested: false` restent la règle.", ""]
    (QUEST / "RAPPORT_MAPS_DESTINY.md").write_text("\n".join(lines), encoding="utf-8")
    print(f"[audit] {len(maps)} maps dans la quest — rapport écrit", flush=True)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--jobs", type=int, default=2)
    ap.add_argument("--etapes", default="build,harvest,quest,audit")
    ap.add_argument("--lots", default="")
    args = ap.parse_args()

    if not BUILD.is_dir():
        raise SystemExit("/tmp/destiny-src absent — préparer l'étape d'extraction")
    if not VENV_PY.is_file():
        raise SystemExit(".venv absent — python3 -m venv .venv && pip install numpy pillow scipy")

    files = build_files()
    if args.lots:
        want = set(args.lots.split(","))
        files = [f for f in files if lot_of(f) in want]
    print(f"[plan] {len(files)} scripts de build", flush=True)

    etapes = args.etapes.split(",")
    status = {}
    rapport: list[dict] = []
    if "build" in etapes:
        status = etape_build(files, args.jobs)
    elif STATUS.exists():
        status = json.loads(STATUS.read_text())
    if "harvest" in etapes:
        rapport = etape_harvest(files)
    if "quest" in etapes:
        etape_quest()
    if "audit" in etapes:
        if not rapport and (ROOT / "bibliotheque_ground" / "rapport_maps_destiny.json").is_file():
            rapport = json.loads((ROOT / "bibliotheque_ground" / "rapport_maps_destiny.json").read_text(
                encoding="utf-8-sig"))["maps"]
        etape_audit(status, rapport)
    return 0


if __name__ == "__main__":
    sys.exit(main())
