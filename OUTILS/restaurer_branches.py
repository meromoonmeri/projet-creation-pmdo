#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Restaure dans l'apercu_local les apercus recents des BRANCHES de ce depot.

Usage (depuis la racine du depot) :
    python3 OUTILS/restaurer_branches.py --dry-run   # analyse seule
    python3 OUTILS/restaurer_branches.py             # restaure
    python3 OUTILS/restaurer_branches.py --fetch     # git fetch des branches avant

Principe :
- Chaque branche arena/* (sauf la branche de travail courante) est consideree
  a son TIP : les suppressions faites en fin de branche sont respectees.
- Pour chaque nom d'apercu racine, la branche gagnante est celle dont le TIP
  est le plus recent parmi celles qui contiennent encore le fichier.
- Chaque chemin partage est source depuis la branche la plus recente qui le
  contient (le plus recent gagne) ; les contenus identiques (hash de blob) sont
  sautes -> pas de doublons, aucun fichier local n'est ecrase.
- Les references reelles des pages (src/href/url() + litteraux JS resolvant
  vers un fichier existant) sont materialisees recursivement (pages, images,
  videos, JSON, paquets de mods).
- Les arbres d'assets des ouvertures / title screen anime PMD Destiny sont
  restaures integralement.
"""
from __future__ import annotations

import argparse
import hashlib
import posixpath
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

# Arbres entiers a restaurer en plus des references des pages (ouvertures,
# title screen anime PMD Destiny).
FORCED_TREES = (
    "renders/pmd_destiny_fangame_v1/",
    "renders/pmd_destiny_nuit_v1/",
)

ATTR_RE = re.compile(r"""(?:src|href)\s*=\s*["']([^"']+)["']""", re.I)
URL_RE = re.compile(r"""url\(\s*["']?([^"')\s]+)""")
JS_RE = re.compile(
    r"""["']([^"'\s]+\.(?:png|jpe?g|gif|webp|mp4|json|zip|html|css|js|dir|ora|wav|mp3|ogg))["']""",
    re.I,
)
NOISE_CHARS = set("${}[]\\`$")

SKIP_PREFIXES = (".git/", ".venv/", ".cache/", ".nox/", "node_modules/")
LOCAL_GENERATED = re.compile(r"^apercu_zip_")  # produits par restaurer_maps_zip.py


def git(*args: str, binary: bool = False):
    r = subprocess.run(["git", *args], cwd=ROOT, capture_output=True)
    if r.returncode != 0:
        raise RuntimeError(f"git {' '.join(args)}: {r.stderr.decode()[:400]}")
    return r.stdout if binary else r.stdout.decode("utf-8", "replace")


def remote_branches() -> list[str]:
    out = git("branch", "-r", "--list", "origin/arena/*")
    names = []
    for line in out.splitlines():
        b = line.strip().removeprefix("origin/")
        if not b or b.startswith("arena/b5e61bd4"):  # branche de travail courante
            continue
        names.append(b)
    return sorted(names)


def tip_date(b: str) -> int:
    return int(git("log", "-1", "--format=%ct", f"origin/{b}").strip() or 0)


def tree_of(b: str) -> set[str]:
    return set(git("ls-tree", "-r", "--name-only", f"origin/{b}").splitlines())


def blob_hash(b: str, p: str) -> str:
    return git("rev-parse", f"origin/{b}:{p}").strip()


def local_hash(p: str) -> str:
    data = (ROOT / p).read_bytes()
    return hashlib.sha1(b"blob %d\0" % len(data) + data).hexdigest()


def refs_of(name: str, text: str) -> set[str]:
    out: set[str] = set()
    for rx in (ATTR_RE, URL_RE):
        out.update(rx.findall(text))
    if name.endswith(".html") or name.endswith(".htm"):
        out.update(JS_RE.findall(text))
    return out


def norm_ref(ref: str) -> str | None:
    ref = ref.split("#", 1)[0].split("?", 1)[0].strip()
    if not ref or ref.startswith(("data:", "http:", "https:", "//", "javascript:", "mailto:", "blob:")):
        return None
    if NOISE_CHARS & set(ref):  # litteraux de gabarit JS (${...}, ${c.x}...)
        return None
    return ref


def resolve(ref: str, page: str, all_paths: set[str], local: set[str]) -> str | None:
    cands: list[str] = []
    if ref.startswith("/"):
        cands.append(ref.lstrip("/"))
    else:
        base = posixpath.dirname(page)
        cands.append(posixpath.normpath(posixpath.join(base, ref)))
        cands.append(posixpath.normpath(ref))
    for c in cands:
        if not c or c in (".", "..") or c.startswith("..") or c.startswith(SKIP_PREFIXES):
            continue
        if c in all_paths or c in local:
            return c
    return None


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--fetch", action="store_true")
    args = ap.parse_args()

    if args.fetch:
        print("git fetch des branches arena/* (--depth=5)...")
        subprocess.run(
            ["git", "fetch", "--depth=5", "origin",
             "+refs/heads/arena/*:refs/remotes/origin/*"],
            cwd=ROOT, check=True,
        )

    branches = remote_branches()
    if not branches:
        print("Aucune branche origin/arena/* trouvee (lancer avec --fetch).")
        return 1
    print(f"{len(branches)} branches distantes analysees.")

    trees = {b: tree_of(b) for b in branches}
    dates = {b: tip_date(b) for b in branches}
    all_paths: set[str] = set().union(*trees.values())

    # Proprietaire de chaque chemin = branche la plus recente le contenant.
    owner: dict[str, str] = {}
    for b in sorted(branches, key=lambda x: dates[x]):
        for p in trees[b]:
            owner[p] = b  # les suivantes (plus anciennes) n'ecrasent pas

    local_files = [
        p for p in ROOT.rglob("*")
        if p.is_file() and not any(part in (".git", ".venv", ".nox", "__pycache__") for part in p.parts)
    ]
    local_rel = {str(p.relative_to(ROOT)) for p in local_files}

    # Gagnant par nom d'apercu racine (branche au TIP le plus recent).
    winners: dict[str, str] = {}
    for b in sorted(branches, key=lambda x: dates[x]):
        for p in trees[b]:
            if posixpath.dirname(p) == "" and p.startswith("apercu_") and p.endswith(".html"):
                winners[p] = b  # la plus recente gagne

    new_pages = {p: b for p, b in winners.items() if p not in local_rel}
    skipped_local = sorted(p for p in winners if p in local_rel and not LOCAL_GENERATED.match(p))
    print(f"{len(winners)} apercus racine sur les branches ; "
          f"{len(new_pages)} a restaurer ; {len(skipped_local)} deja presents localement.")

    # File : pages racines nouvelles + arbres forces.
    queue: list[str] = []
    seeded: set[str] = set()

    def seed(p: str) -> None:
        if p not in seeded and p in all_paths:
            seeded.add(p)
            queue.append(p)

    for p in sorted(new_pages):
        seed(p)
    for b in branches:
        for p in sorted(trees[b]):
            if p.startswith(FORCED_TREES) or (p.startswith("renders/") and p.endswith("/index.html")):
                seed(p)

    fetched = 0
    conflicts: list[str] = []
    missing: set[str] = set()
    seen: set[str] = set()

    while queue:
        p = queue.pop()
        if p in seen:
            continue
        seen.add(p)

        b = owner[p]
        is_page = p.endswith((".html", ".htm"))
        data = git("show", f"origin/{b}:{p}", binary=True)

        if p in local_rel:
            try:
                if local_hash(p) != blob_hash(b, p) and not LOCAL_GENERATED.match(p):
                    conflicts.append(f"{p}  (branche {b})")
            except Exception:
                conflicts.append(f"{p}  (branche {b})")
        else:
            if not args.dry_run:
                dest = ROOT / p
                dest.parent.mkdir(parents=True, exist_ok=True)
                dest.write_bytes(data)
            local_rel.add(p)
            fetched += 1

        if is_page:
            text = data.decode("utf-8", "replace")
            for ref in refs_of(p, text):
                n = norm_ref(ref)
                if n is None:
                    continue
                tgt = resolve(n, p, all_paths, local_rel)
                if tgt is None:
                    missing.add(f"{n}  <-  {p}")
                    continue
                seed(tgt)

    print(f"{fetched} fichiers {'a restaurer' if args.dry_run else 'restaures'}.")
    if conflicts:
        print(f"\nCONFLITS (fichier local differant, local conserve ; {len(conflicts)}) :")
        for c in sorted(conflicts)[:40]:
            print("  ", c)
    if missing:
        print(f"\nREFERENCES ABSENTES (liens ou assets non commites ; {len(missing)}) :")
        for m in sorted(missing)[:60]:
            print("  ", m)

    if args.dry_run:
        print("\nApercus a restaurer par branche :")
        per: dict[str, list[str]] = {}
        for p, b in sorted(new_pages.items()):
            per.setdefault(b, []).append(p)
        for b in sorted(per, key=lambda x: -dates[x]):
            print(f"  {b}  ({len(per[b])} pages)")
            for p in per[b]:
                print(f"    {p}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
