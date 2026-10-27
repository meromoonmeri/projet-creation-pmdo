#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Construit bibliotheque_ground/ : toutes les maps Ground/.rsground en version
CLAMPEE (aucune donnee hors zone), pretes a importer dans la quest PMDO 0.8.12.

Usage (depuis la racine du depot) :
    python3 OUTILS/construire_bibliotheque_ground.py                # construit
    python3 OUTILS/construire_bibliotheque_ground.py --sceller-bords # + collision
    python3 OUTILS/construire_bibliotheque_ground.py --dry-run       # analyse seule

Sources :
- les 6 ZIP de maps a la racine (126 .rsground, contenus de projet-pmdo) ;
- les .rsground des branches arena/* de ce depot (exports, rendus, tests,
  references) ; chaque chemin est pris depuis la branche la plus recente qui le
  contient ; dedup par hash.

Regles appliquees (PROMPT PMDO Destiny, Etape 0) :
- Exclusion ferme : tout contenu issu d'un remake de jeu commercial
  (ExplorersOfSkyOrigins, pret/pmd-red, extractions de ROM...) n'est PAS
  materialise ; il est signale dans CREDITS.md.
- Provenance ambiguë ou licence inconnue : PAS materialise, signale.
- Clamp : toutes les positions/rects de l'espace CARTE (Collider, Hitbox,
  Loc/StartLoc/EndLoc, obstacles.Bounds) sont ramenees dans les limites de la
  carte (pixels = tuiles 8px x TexSize) par intersection. Les coordonnees de
  TEXTURE (TexLoc), les fonds (MapLoc/BGMovement) et les identifiants
  (MetLoc...) ne sont jamais touches. Rapport : bibliotheque_ground/rapport_clamp.
"""
from __future__ import annotations

import argparse
import gzip
import hashlib
import json
import subprocess
import sys
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BIB = ROOT / "bibliotheque_ground"
LOTS = BIB / "lots"

# --- Etape 0 : filtre de provenance -----------------------------------------
EXCLUS_CONTENU_COMMERCIAL = ("ExplorersOfSkyOrigins", "pret/pmd-red", "pmd-red")
# References de provenance inconnue : NE PAS importer, signaler (accord de
# l'auteur requis avant toute reutilisation).
REFERENCES_AMBIGUES = {
    "source/ledian_dojo_v1/references/ledian_dojo.rsground":
        "Mod communautaire d'auteur (Ledian Dojo) : licence non verifiee",
    "source/antre_harmonie_v3/references/altere_pond.rsground":
        "Origine non etablie (reference d'etude de l'Antre Harmonie)",
    "source/amp_plains_fleurie_v1/references/vast_steppe_entrance.rsground":
        "Origine non etablie (possible derive d'un remake)",
}
# References acceptees (DumpAsset/PMDO base, Halcyon) ou origine propre Metano.
REFS_DUMPASSET = {"spinda_cafe", "guild_second_floor", "luminous_spring"}
REFS_HALCYON = {"crooked_cavern_entrance", "crooked"}
REFS_METANO = {"metano_cafe", "metano_normal_home"}

RECT_KEYS = ("Collider", "Hitbox")           # rects espace carte (pixels)
POINT_KEYS = ("Loc", "StartLoc", "EndLoc")   # points espace carte (pixels)


def git(*args: str, binary: bool = False):
    r = subprocess.run(["git", *args], cwd=ROOT, capture_output=True)
    if r.returncode != 0:
        raise RuntimeError(f"git {' '.join(args)}: {r.stderr.decode()[:300]}")
    return r.stdout if binary else r.stdout.decode("utf-8", "replace")


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


# --- Collecte des sources ---------------------------------------------------

def scan_zip_sources() -> dict[str, dict]:
    out: dict[str, dict] = {}
    for zp in sorted(ROOT.glob("*.zip")):
        with zipfile.ZipFile(zp) as zf:
            names = zf.namelist()
            maps = [n for n in names if n.endswith(".rsground")]
            if not maps:
                continue
            roots = {n.split("Data/Ground/")[0] for n in maps}
            root = roots.pop() if len(roots) == 1 else ""
            out[zp.name] = {"path": zp, "root": root, "members": names, "maps": maps}
    return out


def scan_branch_sources():
    """(owner des .rsground, index basename->[(branche,chemin)] des .tile/.dir)."""
    out = git("branch", "-r", "--list", "origin/*")
    branches = []
    for line in out.splitlines():
        b = line.strip().removeprefix("origin/")
        if not b or "->" in b or b.startswith("arena/b5e61bd4"):
            continue
        branches.append(b)
    dates = {b: int(git("log", "-1", "--format=%ct", f"origin/{b}").strip() or 0)
             for b in branches}
    owner: dict[str, str] = {}
    assets: dict[str, list[tuple[str, str]]] = {}
    for b in sorted(branches, key=lambda x: dates[x]):
        for p in git("ls-tree", "-r", "--name-only", f"origin/{b}").splitlines():
            if p.endswith(".rsground") or p.endswith(".rsground.gz"):
                owner[p] = b   # la branche la plus recente gagne
            elif p.endswith((".tile", ".dir")):
                stem = p.rsplit("/", 1)[-1].rsplit(".", 1)[0]
                assets.setdefault(stem, [])
                if all(pp != p for _, pp in assets[stem]):
                    assets[stem].append((b, p))
    return owner, assets


# --- Clamp ------------------------------------------------------------------

def clamp_map(doc: dict) -> tuple[dict, dict]:
    """Ramene toute donnee espace-carte dans les limites (intersection)."""
    obj = doc.get("Object") or {}
    tex = int(obj.get("TexSize") or 1)
    lays = obj.get("Layers") or []
    if not lays or not lays[0].get("Tiles"):
        return {"erreur": "aucune couche de tuiles"}, doc
    W = len(lays[0]["Tiles"])
    H = len(lays[0]["Tiles"][0]) if W else 0
    pw, ph = W * 8 * tex, H * 8 * tex
    stats = {"grille": f"{W}x{H}", "pixels": f"{pw}x{ph}", "TexSize": tex,
             "corrections": {}, "exemples": []}

    def fix(name, d):
        try:
            x, y = int(d.get("X", 0)), int(d.get("Y", 0))
            w, h = int(d.get("Width", 0)), int(d.get("Height", 0))
        except (TypeError, ValueError):
            return
        nx = max(0, min(x, pw - 1)) if pw else 0
        ny = max(0, min(y, ph - 1)) if ph else 0
        nw = max(0, min(x + w, pw) - nx)
        nh = max(0, min(y + h, ph) - ny)
        if (nx, ny, nw, nh) != (x, y, w, h):
            d["X"], d["Y"], d["Width"], d["Height"] = nx, ny, nw, nh
            stats["corrections"][name] = stats["corrections"].get(name, 0) + 1
            if len(stats["exemples"]) < 8:
                stats["exemples"].append(
                    f"{name}: ({x},{y},{w}x{h}) -> ({nx},{ny},{nw}x{nh})")

    def fixpt(name, d):
        try:
            x, y = int(d.get("X", 0)), int(d.get("Y", 0))
        except (TypeError, ValueError):
            return
        nx = max(0, min(x, pw - 1)) if pw else 0
        ny = max(0, min(y, ph - 1)) if ph else 0
        if (nx, ny) != (x, y):
            d["X"], d["Y"] = nx, ny
            stats["corrections"][name] = stats["corrections"].get(name, 0) + 1
            if len(stats["exemples"]) < 8:
                stats["exemples"].append(f"{name}: ({x},{y}) -> ({nx},{ny})")

    def iter_obstacles(node):
        """obstacles peut etre [{Bounds}] ou [[{Bounds}], ...] selon les packs."""
        if isinstance(node, dict):
            yield node
        elif isinstance(node, list):
            for v in node:
                yield from iter_obstacles(v)

    for ob in iter_obstacles(obj.get("obstacles") or []):
        if isinstance(ob.get("Bounds"), dict):
            fix("obstacles.Bounds", ob["Bounds"])

    for ent in obj.get("Entities") or []:
        if not isinstance(ent, dict):
            continue
        for key in ("MapChars", "GroundObjects", "Spawners", "Markers"):
            for item in ent.get(key) or []:
                if not isinstance(item, dict):
                    continue
                for k in RECT_KEYS:
                    if isinstance(item.get(k), dict):
                        fix(f"{key}.{k}", item[k])
                for k in POINT_KEYS:
                    if isinstance(item.get(k), dict):
                        fixpt(f"{key}.{k}", item[k])

    for dec in obj.get("Decorations") or []:
        for anim in (dec.get("Anims") or []) if isinstance(dec, dict) else []:
            if isinstance(anim, dict):
                for k in POINT_KEYS:
                    if isinstance(anim.get(k), dict):
                        fixpt(f"Decorations.{k}", anim[k])

    # Post-controle : plus aucune donnee hors zone ?
    reste = 0
    for ob in iter_obstacles(obj.get("obstacles") or []):
        b = ob.get("Bounds") or {}
        if not isinstance(b, dict):
            continue
        if b.get("X", 0) < 0 or b.get("Y", 0) < 0 or \
           b.get("X", 0) + max(b.get("Width", 0), 0) > pw or \
           b.get("Y", 0) + max(b.get("Height", 0), 0) > ph:
            reste += 1
    stats["hors_zone_restants"] = reste
    return stats, doc


def cellules_bord_ouvertes(doc: dict) -> tuple[list[tuple[int, int]], dict]:
    """Cellules de bord non bloquees par une collision (Tags != 0)."""
    obj = doc.get("Object") or {}
    lays = obj.get("Layers") or []
    if not lays or not lays[0].get("Tiles"):
        return [], {}
    W = len(lays[0]["Tiles"])
    H = len(lays[0]["Tiles"][0]) if W else 0
    tex = int(obj.get("TexSize") or 1)
    cell = 8 * tex
    blocked = set()

    def iter_obstacles(node):
        if isinstance(node, dict):
            yield node
        elif isinstance(node, list):
            for v in node:
                yield from iter_obstacles(v)

    for ob in iter_obstacles(obj.get("obstacles") or []):
        b = ob.get("Bounds") or {}
        if not isinstance(b, dict) or int(b.get("Tags") or 0) == 0:
            continue
        x0, y0 = int(b.get("X", 0)), int(b.get("Y", 0))
        x1 = x0 + max(int(b.get("Width", 0)), 0) - 1
        y1 = y0 + max(int(b.get("Height", 0)), 0) - 1
        for gx in range(max(0, x0 // cell), max(0, x1 // cell) + 1):
            for gy in range(max(0, y0 // cell), max(0, y1 // cell) + 1):
                blocked.add((gx, gy))
    ouvertes = []
    for x in range(W):
        for y in (0, H - 1):
            if (x, y) not in blocked:
                ouvertes.append((x, y))
    for y in range(1, H - 1):
        for x in (0, W - 1):
            if (x, y) not in blocked:
                ouvertes.append((x, y))
    return ouvertes, {"cellules_bord": 2 * (W + H),
                      "cellules_bord_ouvertes": len(ouvertes)}


def sceller_bords(doc: dict, ouvertes: list[tuple[int, int]]) -> int:
    """Ajoute une collision (Tags=1) sur chaque cellule de bord marchable."""
    if not ouvertes:
        return 0
    obj = doc.setdefault("Object", {})
    tex = int(obj.get("TexSize") or 1)
    cell = 8 * tex
    obs = obj.setdefault("obstacles", [])
    for (x, y) in ouvertes:
        obs.append({"Bounds": {"X": x * cell, "Y": y * cell,
                               "Width": cell, "Height": cell}, "Tags": 1})
    return len(ouvertes)


def collect_refs(doc: dict) -> dict:
    """Sheet/anim (assets reels), autotilesets (metadonnees editeur), musique, entites."""
    refs = {"sheets": set(), "anims": set(), "autotilesets": set(), "music": "",
            "entites": []}
    obj = doc.get("Object") or {}

    def walk(node):
        if isinstance(node, dict):
            for key in ("Sheet", "AnimIndex", "AutoTileset"):
                v = node.get(key)
                if isinstance(v, str) and v:
                    bucket = {"Sheet": "sheets", "AnimIndex": "anims",
                              "AutoTileset": "autotilesets"}[key]
                    refs[bucket].add(v)
            for v in node.values():
                walk(v)
        elif isinstance(node, list):
            for v in node:
                walk(v)

    walk(obj.get("Layers") or [])
    walk(obj.get("Background") or {})
    walk(obj.get("Decorations") or [])
    refs["music"] = obj.get("Music") or ""
    for ent in obj.get("Entities") or []:
        for key in ("MapChars", "GroundObjects", "Spawners", "Markers"):
            for item in (ent.get(key) or []) if isinstance(ent, dict) else []:
                if isinstance(item, dict):
                    nom = item.get("EntName") or item.get("NPCName") or ""
                    refs["entites"].append(f"{key}:{nom or '(sans nom)'}")
    for k in ("sheets", "anims", "autotilesets"):
        refs[k] = sorted(refs[k])
    return refs


def chevauchements(doc: dict) -> int:
    obj = doc.get("Object") or {}
    rects = []
    for ent in obj.get("Entities") or []:
        for key in ("MapChars", "GroundObjects", "Spawners", "Markers"):
            for item in (ent.get(key) or []) if isinstance(ent, dict) else []:
                if isinstance(item, dict) and isinstance(item.get("Collider"), dict):
                    c = item["Collider"]
                    rects.append((c.get("X", 0), c.get("Y", 0),
                                  c.get("Width", 0), c.get("Height", 0)))
    n = 0
    for i in range(len(rects)):
        for j in range(i + 1, len(rects)):
            x1, y1, w1, h1 = rects[i]
            x2, y2, w2, h2 = rects[j]
            if x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1:
                n += 1
    return n


# --- Resolution des tilesets ------------------------------------------------

def build_asset_index(zip_sources, branch_assets) -> dict[str, list[tuple[str, str]]]:
    """basename (sans extension) -> [(source, chemin interne)] pour .tile/.dir"""
    idx: dict[str, list[tuple[str, str]]] = {}
    for zname, zs in zip_sources.items():
        for m in zs["members"]:
            base = m.rsplit("/", 1)[-1]
            stem, ext = base.rsplit(".", 1) if "." in base else (base, "")
            if ext in ("tile", "dir"):
                idx.setdefault(stem, []).append((zname, m))
    for stem, lst in branch_assets.items():
        idx.setdefault(stem, []).extend(lst)
    return idx


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--sceller-bords", action="store_true",
                    help="ajoute une collision sur les cellules de bord marchables")
    args = ap.parse_args()

    zip_sources = scan_zip_sources()
    print(f"Packs ZIP avec maps : {len(zip_sources)} "
          f"({sum(len(z['maps']) for z in zip_sources.values())} maps)")
    owner, branch_assets = scan_branch_sources()
    print(f"Fichiers .rsground sur les branches : {len(owner)} chemins uniques")

    asset_index = build_asset_index(zip_sources, branch_assets)
    rapport: dict = {"maps": [], "exclus": [], "lots": {}}
    seen_lot_names: dict[str, set] = {}

    def lot_map_path(lot: str, map_name: str) -> Path:
        noms = seen_lot_names.setdefault(lot, set())
        base = map_name
        k = 2
        while map_name in noms:
            map_name = f"{base.rsplit('.', 1)[0]}_{k}.rsground"
            k += 1
        noms.add(map_name)
        return LOTS / lot / "Data" / "Ground" / map_name

    def treat_map(lot: str, map_name: str, raw: bytes, origine: str):
        txt = raw.lstrip(b"\xef\xbb\xbf").strip()
        if not txt.startswith(b"{"):
            # lien symbolique git (pointeur vers .cache/tiles/... non versionne)
            rapport["maps"].append({
                "map": map_name, "lot": lot, "origine": origine,
                "lien_symbolique": raw.decode("utf-8", "replace")[:200],
                "motif": "cible absente du depot, non materialisee"})
            return
        try:
            doc = json.loads(raw.decode("utf-8-sig"))
        except Exception as e:
            rapport["maps"].append({"map": map_name, "lot": lot, "erreur": str(e)})
            return
        stats, doc = clamp_map(doc)
        refs = collect_refs(doc)
        ouvertes, fr = cellules_bord_ouvertes(doc)
        if args.sceller_bords:
            stats["cellules_bord_scellees"] = sceller_bords(doc, ouvertes)
            ouvertes, fr = cellules_bord_ouvertes(doc)  # recontrole
        dest = lot_map_path(lot, map_name)
        out = json.dumps(doc, ensure_ascii=False, separators=(",", ":")).encode("utf-8")
        if not args.dry_run:
            dest.parent.mkdir(parents=True, exist_ok=True)
            dest.write_bytes(out)
        dispo, manquants, copies = [], [], []
        for name in refs["sheets"] + refs["anims"]:
            cands = asset_index.get(name, [])
            if not cands:
                manquants.append(name)
                continue
            dispo.append(name)
            if args.dry_run:
                continue
            src, member = cands[0]
            if src.endswith(".zip"):
                data = zipfile.ZipFile(zip_sources[src]["path"]).read(member)
                rel = "Content/" + member.split("Content/", 1)[-1]
            else:
                data = git("show", f"origin/{src}:{member}", binary=True)
                rel = "Content/" + member.split("Content/", 1)[-1]
            if data:
                base = LOTS / lot / rel
                base.parent.mkdir(parents=True, exist_ok=True)
                if not base.exists():
                    base.write_bytes(data)
                    copies.append(rel)
        rapport["maps"].append({
            "map": map_name, "lot": lot, "origine": origine,
            "sha256_origine": sha256(raw), "sha256_clampe": sha256(out),
            "clamp": stats, "frontiere": fr,
            "chevauchements_entites": chevauchements(doc),
            "refs": refs, "tilesets_trouves": dispo, "tilesets_manquants": manquants,
        })

    # ---- 1. packs ZIP
    for zname, zs in zip_sources.items():
        lot = zname[:-4]
        seen_lot_names.setdefault(lot, set())
        rapport["lots"][lot] = {"source": f"ZIP {zname}", "maps": len(zs["maps"])}
        with zipfile.ZipFile(zs["path"]) as zf:
            for m in zs["maps"]:
                treat_map(lot, m.rsplit("/", 1)[-1], zf.read(m), f"{zname}!{m}")
            # payload d'import : Content complet + scripts + meta du pack
            if not args.dry_run:
                for member in zs["members"]:
                    rel = (member[len(zs["root"]):]
                           if zs["root"] and member.startswith(zs["root"]) else member)
                    if rel.startswith("Content/") or rel.startswith("Data/Script/"):
                        p = LOTS / lot / rel
                        p.parent.mkdir(parents=True, exist_ok=True)
                        p.write_bytes(zf.read(member))
                    elif rel and "/" not in rel.rstrip("/"):
                        p = LOTS / lot / "meta_src" / rel
                        p.parent.mkdir(parents=True, exist_ok=True)
                        p.write_bytes(zf.read(member))

    # ---- 2. fichiers des branches
    for path, b in sorted(owner.items()):
        raw = git("show", f"origin/{b}:{path}", binary=True)
        if path.endswith(".gz"):
            raw = gzip.decompress(raw)
        map_name = path.rsplit("/", 1)[-1]
        if map_name.endswith(".gz"):
            map_name = map_name[:-3]
        base = map_name[:-len(".rsground")] if map_name.endswith(".rsground") else map_name

        # Etape 0 : exclusions fermees + signalements
        if any(s in path for s in EXCLUS_CONTENU_COMMERCIAL):
            rapport["exclus"].append({
                "fichier": path, "branche": b,
                "motif": "contenu derive d'un remake de jeu commercial (exclusion ferme)"})
            continue
        if path in REFERENCES_AMBIGUES:
            rapport["exclus"].append({
                "fichier": path, "branche": b, "motif": REFERENCES_AMBIGUES[path]})
            continue

        if base in REFS_DUMPASSET:
            lot = "references_dumpasset"
        elif base in REFS_HALCYON or "Halcyon__" in map_name:
            lot = "references_halcyon"
        elif base in REFS_METANO:
            lot = "references_metano"
        elif path.startswith("exports/"):
            lot = path.split("/")[1]
        elif "/reseau_metano_normal_v1/" in path:
            lot = "reseau_metano_normal_v1"
        elif "/package/Data/Ground/" in path:
            lot = "packages_destiny"
        else:
            lot = "destiny_cliff_tests" if base.startswith("cliff") else "maps_branches"
        seen_lot_names.setdefault(lot, set())
        rapport["lots"].setdefault(lot, {"source": "branches arena/*", "maps": 0})
        rapport["lots"][lot]["maps"] += 1
        treat_map(lot, map_name, raw, f"{b}:{path}")

    # ---- 3. lot.json par lot
    if not args.dry_run:
        for lot, meta in rapport["lots"].items():
            maps = [m for m in rapport["maps"] if m["lot"] == lot
                    and "erreur" not in m and "lien_symbolique" not in m]
            names = [m["map"] for m in maps]
            payload = {
                "lot": lot,
                "source": meta.get("source"),
                "quest_cible": "PMDO Destiny 0.8.12 (Namespace halcyon, GameVersion 0.8.12.0)",
                "maps": [{"map": m["map"], "grille": m["clamp"].get("grille"),
                          "sha256_clampe": m["sha256_clampe"],
                          "tilesets_manquants": m["tilesets_manquants"]} for m in maps],
                "declaration_groundmaps": {
                    "instruction": "Ajouter ces noms EN FIN du tableau GroundMaps "
                                   "de Data/Zone/<zone>.json, sans decaler les index existants",
                    "GroundMaps": [Path(n).stem for n in names]},
            }
            lotdir = LOTS / lot
            (lotdir / "lot.json").parent.mkdir(parents=True, exist_ok=True)
            (lotdir / "lot.json").write_text(
                json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")

    # ---- 4. rapports globaux
    ok = [m for m in rapport["maps"] if "erreur" not in m and "lien_symbolique" not in m]
    liens = [m for m in rapport["maps"] if "lien_symbolique" in m]
    erreurs = [m for m in rapport["maps"] if "erreur" in m]
    total = len(ok)
    corr = sum(sum(m["clamp"].get("corrections", {}).values()) for m in ok)
    hors = sum(m["clamp"].get("hors_zone_restants", 0) for m in ok)
    ouvertes_total = sum(m.get("frontiere", {}).get("cellules_bord_ouvertes", 0)
                         for m in ok)
    manq = sorted({t for m in ok for t in m["tilesets_manquants"]})
    autot = sorted({t for m in ok for t in m["refs"].get("autotilesets", [])})
    rapport["synthese"] = {
        "maps_clampees": total, "erreurs": len(erreurs),
        "liens_symboliques": len(liens),
        "corrections_appliquees": corr, "hors_zone_restants": hors,
        "cellules_bord_ouvertes_total": ouvertes_total,
        "assets_non_resolus": manq,
        "autotilesets_editeur_non_resolus": autot,
        "exclus": len(rapport["exclus"]),
        "scellement_bords": args.sceller_bords,
    }
    if not args.dry_run:
        BIB.mkdir(exist_ok=True)
        (BIB / "rapport_clamp.json").write_text(
            json.dumps(rapport, ensure_ascii=False, indent=1), encoding="utf-8")
        lines = ["# Rapport de clamp — bibliothèque Ground", "",
                 f"- maps clampées : **{total}** ({len(erreurs)} erreur(s))",
                 f"- liens symboliques non matérialisés : **{len(liens)}**",
                 f"- corrections hors zone appliquées : **{corr}**",
                 f"- anomalies hors zone restantes : **{hors}**",
                 f"- cellules de bord marchables (frontières ouvertes) : **{ouvertes_total}**",
                 f"- scellement des bords : {'oui' if args.sceller_bords else 'non (option --sceller-bords)'}",
                 f"- assets (.tile/.dir) non résolus : {', '.join(manq) if manq else 'aucun'}",
                 f"- noms d'autotileset éditeur non résolus : {len(autot)} "
                 f"(métadonnées, sans fichier correspondant)",
                 f"- fichiers exclus (Étape 0) : **{len(rapport['exclus'])}**",
                 ""]
        for e in rapport["exclus"]:
            lines.append(f"- EXCLUS `{e['fichier']}` ({e['branche']}) — {e['motif']}")
        for m in liens:
            lines.append(f"- LIEN `{m['lot']}/{m['map']}` -> `{m['lien_symbolique']}` — {m['motif']}")
        lines.append("")
        for m in ok:
            c = m["clamp"].get("corrections", {})
            fr = m.get("frontiere", {})
            extra = ""
            if fr.get("cellules_bord_ouvertes"):
                extra += f" ; frontière ouverte : {fr['cellules_bord_ouvertes']} cellules"
            if m["chevauchements_entites"]:
                extra += f" ; chevauchements entités : {m['chevauchements_entites']}"
            lines.append(f"- `{m['lot']}/{m['map']}` {m['clamp'].get('grille')} — "
                         f"corrections : {sum(c.values()) or 'aucune'}{extra}")
        for m in erreurs:
            lines.append(f"- ERREUR `{m['lot']}/{m['map']}` : {m['erreur']}")
        (BIB / "rapport_clamp.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(json.dumps(rapport["synthese"], ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
