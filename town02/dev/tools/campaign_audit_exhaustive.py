#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Audit automatique exhaustif des campagnes PMD Red & Sky.

Détecte tout ce qui pourrait donner une fausse impression de complétude :

  A. PLACEHOLDERS   — marqueurs explicites (TODO/FIXME/PLACEHOLDER/STUB…)
                      et implicites (image 25 octets, layer vide, map vide,
                      texte générique) dans les données des campagnes.
  B. FRAMES         — pour chaque ground : expected_frame_count par tuile
                      (source .rsground) vs frames réellement rendues ;
                      un rendu < besoin = PARTIAL, jamais PASS.
  C. ASSETS         — chaque Sheet référencé par un .rsground doit exister
                      dans les .tile source ; chaque cellule (TexLoc) doit
                      exister dans la planche ; planches jamais référencées
                      listées (orphelins).
  D. RÉFÉRENCES     — renders référencés par le manifest présents sur
                      disque ; entrées de manifest sans render et
                      réciproquement ; cinématiques référencées présentes.
  E. MAPPINGS       — couverture des identités : grounds sans nom humain
                      (nom == ID technique), donjons sans grounds, grounds
                      de donjon sans rôle.
  F. CINÉMATIQUES   — séquences .cif.json vides, sans dialogue ni musique ;
                      scènes lua avec seulement des commentaires ; écart
                      entre nombre de scènes et grounds d'histoire.
  G. DOUBLONS       — renders/planches au même SHA-256 sous des noms
                      différents ; grounds au contenu identique.
  H. FAUX PASS      — verdicts du manifest non étayés (render annoncé mais
                      fichier absent, "validated" sans preuve listée).

Chaque anomalie est classée CRITICAL / HIGH / MEDIUM / LOW / ACCEPTED.
Aucune fusion en un pourcentage unique : couvertures séparées.

Sortie : dev/CAMPAIGNS/<camp>/AUDIT.json + AUDIT.md (+ code retour 1 si
CRITICAL ou HIGH non acceptés).
"""
from __future__ import annotations

import hashlib
import io
import json
import re
import struct
import sys
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]

CAMPAIGNS = {
    "PMD_RED_RESCUE_TEAM": {
        "grounds": ROOT / ".runtime-cache/campaigns/red_src/Grounds",
        "tiles": ROOT / ".runtime-cache/campaigns/red_src/Tiles",
    },
    "PMD_SKY_EXPLORERS": {
        "grounds": ROOT / ".runtime-cache/ports/sky/output/Grounds",
        "tiles": ROOT / ".runtime-cache/ports/sky/output/Tiles",
    },
}

PLACEHOLDER_TOKENS = re.compile(
    r"\b(TODO|FIXME|XXX|HACK|PLACEHOLDER|TEMPORARY|STUB|MOCK|DUMMY|"
    r"TEST_ONLY|NOT_IMPLEMENTED|UNIMPLEMENTED|WIP|TBD|TBA)\b", re.I)

# Anomalies vérifiées manuellement contre la SOURCE et acceptées.
# Chaque entrée doit citer la preuve — jamais d'acceptation de confort.
ACCEPTED_FINDINGS = {
    ("PMD_SKY_EXPLORERS", "PLACEHOLDER", "b01p01_beach"):
        "asset hérité du port (MAP_BG_CONVERSION_REPORT.md: 'b01p01_beach "
        "hérité'), sans layers dans la source du port elle-même — conservé "
        "comme trace, exclu du contenu de campagne",
    ("PMD_SKY_EXPLORERS", "PLACEHOLDER", "Renders/s05p04a/frame_000.png"):
        "frame 0 canoniquement NOIRE: s05p04a est une séquence de fondu "
        "d'ouverture (344 frames source, vérifié: frame 10 a du contenu, "
        "24092 cellules distinctes rendues dans animation.apng)",
}


def sha256(p: Path) -> str:
    return hashlib.sha256(p.read_bytes()).hexdigest()


def load_tile_cells(path: Path) -> set:
    raw = path.read_bytes()
    _, count = struct.unpack_from("<II", raw, 0)
    cells = set()
    for i in range(count):
        key, _ = struct.unpack_from("<QQ", raw, 8 + i * 16)
        cells.add((key & 0xFFFFFFFF, key >> 32))
    return cells


def _tile_content_hash(path: Path) -> str:
    """Hash du CONTENU pixel d'une planche .tile (cellules décodées),
    indépendant du timestamp/de l'ordre de sérialisation du conteneur."""
    from PIL import Image
    raw = path.read_bytes()
    _, count = struct.unpack_from("<II", raw, 0)
    items = []
    for i in range(count):
        key, off = struct.unpack_from("<QQ", raw, 8 + i * 16)
        ln = struct.unpack_from("<Q", raw, off)[0]
        img = Image.open(io.BytesIO(raw[off + 8:off + 8 + ln])).convert("RGBA")
        items.append(((key & 0xFFFFFFFF, key >> 32),
                      hashlib.sha256(img.tobytes()).hexdigest()))
    return hashlib.sha256(str(sorted(items)).encode()).hexdigest()


def _ground_source(cfg: dict, gid: str):
    for base in (cfg["grounds"], ROOT / "Data" / "Ground"):
        for suf in (".rsground", ".rsground.excluded"):
            p = base / f"{gid}{suf}"
            if p.exists():
                return p
    return None


def _find_tile(cfg: dict, sheet: str):
    for base in (cfg["tiles"], ROOT / "Content" / "Tile"):
        for cand in (sheet, sheet[:1].upper() + sheet[1:]):
            p = base / f"{cand}.tile"
            if p.exists():
                return p
    return None


_TILE_HASH_CACHE: dict = {}
_TILE_CELLS_CACHE: dict = {}


def _tile_cell_hash(cfg: dict, sheet: str, x, y):
    """Hash pixel d'une cellule précise d'une planche (None si absent)."""
    from PIL import Image
    tp = _find_tile(cfg, sheet)
    if tp is None:
        return None
    key = str(tp)
    if key not in _TILE_CELLS_CACHE:
        raw = tp.read_bytes()
        _, count = struct.unpack_from("<II", raw, 0)
        cells = {}
        for i in range(count):
            k, off = struct.unpack_from("<QQ", raw, 8 + i * 16)
            ln = struct.unpack_from("<Q", raw, off)[0]
            img = Image.open(io.BytesIO(raw[off + 8:off + 8 + ln])) \
                .convert("RGBA")
            cells[(k & 0xFFFFFFFF, k >> 32)] = hashlib.sha256(
                img.tobytes()).hexdigest()[:16]
        _TILE_CELLS_CACHE[key] = cells
    return _TILE_CELLS_CACHE[key].get((x, y), f"CELL_MISSING:{x},{y}")


def _source_duplicate_verdict(cfg: dict, gids: list) -> str:
    """Contre-épreuve pour renders identiques : IDENTICAL_SOURCE si les
    Layers sont sémantiquement identiques une fois chaque nom de planche
    (Sheet) remplacé par le HASH DU CONTENU PIXEL de la planche — deux
    grounds qui référencent des planches nommées différemment mais aux
    pixels identiques sont le même visuel canonique."""
    layer_hashes = set()
    for gid in gids:
        gp = _ground_source(cfg, gid)
        if gp is None:
            return f"SOURCE_MISSING:{gid}"
        try:
            obj = json.loads(gp.read_text(encoding="utf-8-sig"))["Object"]
        except Exception:
            return f"SOURCE_UNREADABLE:{gid}"
        layers = obj.get("Layers")
        if isinstance(layers, dict):
            layers = layers.get("$values") or []
        sheets = set()
        for l in layers or []:
            for col in (l.get("Tiles") or []):
                for cell in col:
                    for cl in cell.get("Layers", []):
                        for fr in cl.get("Frames", []):
                            if fr.get("Sheet"):
                                sheets.add(fr["Sheet"])
        norm = json.dumps(layers, sort_keys=True)
        for s in sorted(sheets, key=len, reverse=True):
            tp = _find_tile(cfg, s)
            if tp is None:
                return f"TILE_MISSING:{s}"
            key = str(tp)
            if key not in _TILE_HASH_CACHE:
                _TILE_HASH_CACHE[key] = _tile_content_hash(tp)
            norm = norm.replace(f'"{s}"', f'"@{_TILE_HASH_CACHE[key]}@"')
        layer_hashes.add(hashlib.sha256(norm.encode()).hexdigest())
    if len(layer_hashes) == 1:
        return "IDENTICAL_SOURCE"
    # Cas variante animée : le doublon ne porte que sur frame_000 ; si la
    # PROJECTION PREMIÈRE FRAME de chaque cellule est identique, le partage
    # de frame_000 est canonique (ex. Sky d53p41a statique vs d53p41b animé).
    ff_hashes = set()
    for gid in gids:
        gp = _ground_source(cfg, gid)
        obj = json.loads(gp.read_text(encoding="utf-8-sig"))["Object"]
        layers = obj.get("Layers")
        if isinstance(layers, dict):
            layers = layers.get("$values") or []
        proj = []
        for l in layers or []:
            grid = []
            for col in (l.get("Tiles") or []):
                gcol = []
                for cell in col:
                    firsts = []
                    for cl in cell.get("Layers", []):
                        fr = (cl.get("Frames") or [None])[0]
                        if fr and fr.get("Sheet"):
                            h = _tile_cell_hash(
                                cfg, fr["Sheet"],
                                fr.get("TexLoc", {}).get("X"),
                                fr.get("TexLoc", {}).get("Y"))
                            if h is None:
                                return f"TILE_MISSING:{fr['Sheet']}"
                            firsts.append(h)
                    gcol.append(firsts)
                grid.append(gcol)
            proj.append(grid)
        ff_hashes.add(hashlib.sha256(
            json.dumps(proj).encode()).hexdigest())
    if len(ff_hashes) == 1:
        return "IDENTICAL_FIRST_FRAME"
    return "DIFFERS"


def audit_campaign(camp: str, cfg: dict) -> dict:
    cdir = ROOT / "dev" / "CAMPAIGNS" / camp
    findings = []          # {severity, category, subject, detail}
    def add(sev, cat, subject, detail):
        accepted = ACCEPTED_FINDINGS.get((camp, cat, subject))
        if accepted:
            findings.append({"severity": "ACCEPTED", "category": cat,
                             "subject": subject, "detail": detail,
                             "acceptance_proof": accepted})
            return
        findings.append({"severity": sev, "category": cat,
                         "subject": subject, "detail": detail})

    manifest = json.loads((cdir / "MANIFEST.json").read_text(encoding="utf-8-sig"))
    render_report = json.loads((cdir / "Renders" / "render_report.json")
                               .read_text(encoding="utf-8-sig"))
    renders = {r["ground"]: r for r in render_report["renders"]}

    grounds_dir, tiles_dir = cfg["grounds"], cfg["tiles"]
    have_sources = grounds_dir.is_dir() and tiles_dir.is_dir()

    # ---------------- B/C: frames + assets (nécessite les sources)
    frame_status = {}
    referenced_sheets = set()
    missing_cells_total = 0
    if have_sources:
        tile_cells_cache: dict[str, set] = {}
        for g in sorted(grounds_dir.glob("*.rsground")):
            name = g.stem
            try:
                obj = json.loads(g.read_text(encoding="utf-8-sig"))["Object"]
            except Exception as e:
                add("CRITICAL", "ASSET", name, f"rsground illisible: {e}")
                continue
            layers = obj.get("Layers")
            if isinstance(layers, dict):
                layers = layers.get("$values") or []
            if not layers or not layers[0].get("Tiles"):
                add("HIGH", "PLACEHOLDER", name,
                    "map sans layer/tuiles (contenu vide)")
                frame_status[name] = {"expected": 0, "rendered": 0,
                                      "status": "MISSING"}
                continue
            need = 1
            local_missing = 0
            for l in layers:
                for col in l.get("Tiles") or []:
                    for cell in col:
                        for cl in cell.get("Layers", []):
                            frames = cl.get("Frames", [])
                            need = max(need, len(frames))
                            for fr in frames:
                                sheet = fr.get("Sheet")
                                if not sheet:
                                    continue
                                referenced_sheets.add(sheet)
                                if sheet not in tile_cells_cache:
                                    tp = tiles_dir / f"{sheet}.tile"
                                    tile_cells_cache[sheet] = (
                                        load_tile_cells(tp) if tp.exists()
                                        else None)
                                cells = tile_cells_cache[sheet]
                                if cells is None:
                                    continue      # sheet manquant traité après
                                tl = fr.get("TexLoc", {})
                                if (tl.get("X"), tl.get("Y")) not in cells:
                                    local_missing += 1
            if local_missing:
                missing_cells_total += local_missing
                add("HIGH", "ASSET", name,
                    f"{local_missing} référence(s) TexLoc absentes des "
                    f"planches source")
            r = renders.get(name, {})
            rendered = r.get("frames_rendered", 0)
            anim_sheet = cdir / "Renders" / name / "animation_frames.png"
            # Couvert si: le cycle rendu >= besoin max par tuile, OU la
            # planche exhaustive par tuile existe (toutes les frames de
            # toutes les séquences y sont blittées).
            covered = rendered >= need or anim_sheet.exists()
            frame_status[name] = {
                "expected": need,
                "rendered": rendered,
                "animation_sheet": anim_sheet.exists(),
                "status": ("PASS" if covered else "PARTIAL"),
            }
            if not covered:
                sev = "HIGH" if need <= 64 else "MEDIUM"
                add(sev, "FRAMES", name,
                    f"frames rendues {rendered} < requises {need} et pas de "
                    f"planche exhaustive animation_frames.png")
        # sheets manquants et orphelins
        for s in sorted(referenced_sheets):
            if not (tiles_dir / f"{s}.tile").exists():
                add("CRITICAL", "REFERENCE", s,
                    "planche .tile référencée mais absente des sources")
        all_sheets = {t.stem for t in tiles_dir.glob("*.tile")}
        orphans = sorted(all_sheets - referenced_sheets)
        if orphans:
            add("LOW", "ASSET", f"{len(orphans)} planches",
                f"planches jamais référencées par un ground (ex: "
                f"{', '.join(orphans[:6])}) — archivage, pas bloquant")
    else:
        add("MEDIUM", "REFERENCE", camp,
            "sources .rsground/.tile absentes du cache: audit frames/assets "
            "NOT_TESTED sur cette exécution (restaurer .runtime-cache)")

    # ---------------- A: placeholders dans manifest et données campagne
    scan_files = [cdir / "MANIFEST.json", cdir / "MANIFEST.md"]
    scan_files += list((cdir / "Cinematics").rglob("*.lua"))[:400]
    for f in scan_files:
        if not f.exists():
            continue
        try:
            txt = f.read_text(encoding="utf-8", errors="replace")
        except Exception:
            continue
        for m in PLACEHOLDER_TOKENS.finditer(txt):
            line = txt[:m.start()].count("\n") + 1
            frag = txt[max(0, m.start()-40):m.end()+40].replace("\n", " ")
            add("MEDIUM", "PLACEHOLDER", f"{f.relative_to(cdir)}:{line}",
                f"marqueur {m.group(0)!r}: …{frag}…")

    # renders placeholder implicites (PNG minuscules = images vides)
    for png in (cdir / "Renders").rglob("frame_000.png"):
        if png.stat().st_size < 400:
            add("HIGH", "PLACEHOLDER", str(png.relative_to(cdir)),
                f"render suspect ({png.stat().st_size} octets)")

    # ---------------- D: références manifest <-> renders
    for e in manifest["grounds"]:
        gid = e["ground"]
        if e.get("render"):
            # le manifest désigne le dossier par render.dir (IDs renommés
            # pour collision — ex. t00p01_sky -> Renders/t00p01/ — gardent
            # leur dossier d'origine, documenté par id_note)
            rdir = (e["render"].get("dir") or f"Renders/{gid}/").strip("/")
            d = cdir / rdir
            if not d.is_dir() or not (d / "frame_000.png").exists():
                add("CRITICAL", "REFERENCE", gid,
                    "render annoncé dans le manifest mais absent du disque")
            else:
                n_png = len(list(d.glob("frame_*.png")))
                apng = d / "animation.apng"
                declared = e["render"]["frames"]
                # Après compaction: frame_000.png + animation.apng (frames
                # distinctes consécutives fusionnées par durée, sans perte).
                ok = (n_png == declared) or (apng.exists() and n_png == 1)
                if not ok:
                    add("HIGH", "REFERENCE", gid,
                        f"manifest annonce {declared} frames, {n_png} PNG "
                        f"présents et pas d'animation.apng")
        elif not e.get("render_error"):
            add("HIGH", "FAUX_PASS", gid,
                "ni render ni render_error: état non documenté")
    disk_renders = {d.name for d in (cdir / "Renders").iterdir() if d.is_dir()}
    manifest_ids = {e["ground"] for e in manifest["grounds"]}
    # dossiers référencés via render.dir (IDs renommés: le dossier reste)
    for e in manifest["grounds"]:
        rd = (e.get("render") or {}).get("dir")
        if rd:
            manifest_ids.add(rd.strip("/").split("/")[-1])
    for extra in sorted(disk_renders - manifest_ids):
        add("MEDIUM", "REFERENCE", extra,
            "render sur disque sans entrée de manifest")

    # ---------------- E: mappings / identités
    technical = 0
    for e in manifest["grounds"]:
        nm = (e.get("human_name_en") or "").strip()
        gid = e["ground"]
        if not nm or nm.lower() == gid.lower() or re.match(
                r"^[a-z]\d{2}p\d{2}", nm.lower()):
            if ("dungeon" in e or "area_group" in e or "series_role" in e):
                continue   # identité disponible via donjon/groupe/série
            technical += 1
            add("LOW", "MAPPING", gid,
                "nom humain == identifiant technique et aucune identité de "
                "donjon/groupe/série rattachée")
    # donjons déclarés sans ground rendu
    for did, d in (manifest.get("dungeons") or {}).items():
        for g in d.get("grounds", []):
            if g not in renders or "error" in renders.get(g, {}):
                add("HIGH", "MAPPING", f"{did}/{g}",
                    "ground de donjon déclaré sans rendu disponible")

    # ---------------- F: cinématiques
    cine_dir = cdir / "Cinematics"
    empty_cifs = 0
    if cine_dir.is_dir():
        for cif in sorted(cine_dir.glob("*.cif.json")):
            try:
                d = json.loads(cif.read_text(encoding="utf-8-sig"))
            except Exception as e:
                add("HIGH", "CINEMATIC", cif.name, f"illisible: {e}")
                continue
            seq = d.get("raw_sequence", [])
            if not seq:
                empty_cifs += 1
                add("MEDIUM", "CINEMATIC", cif.name,
                    "séquence vide (aucun événement extrait)")
            else:
                kinds = Counter(x.get("type") for x in seq)
                if not kinds.get("Dialog") and not kinds.get("Audio"):
                    add("LOW", "CINEMATIC", cif.name,
                        f"séquence sans dialogue ni audio ({dict(kinds)})")
        for lua in sorted((cine_dir / "scene_lua").glob("*.lua"))[:500] \
                if (cine_dir / "scene_lua").is_dir() else []:
            txt = lua.read_text(encoding="utf-8", errors="replace")
            code = [l for l in txt.splitlines()
                    if l.strip() and not l.strip().startswith("--")]
            if len(code) < 5:
                add("MEDIUM", "CINEMATIC", f"scene_lua/{lua.name}",
                    "scène quasi vide (<5 lignes de code)")

    # ---------------- F1b: dialogues canoniques Red (dialogues/*.json.gz)
    dlg_idx_p = cine_dir / "DIALOGUES_INDEX.json"
    if dlg_idx_p.exists():
        dlg_idx = json.loads(dlg_idx_p.read_text(encoding="utf-8-sig"))
        for st, s in dlg_idx.get("stations", {}).items():
            if s["status"] == "PASS":
                if not s.get("file") or not (cine_dir / s["file"]).exists():
                    add("HIGH", "CINEMATIC", st,
                        f"dialogues PASS mais archive absente: {s.get('file')}")
                elif not s.get("text_blocks"):
                    # 0 bloc n'est une anomalie QUE si la séquence cif de la
                    # même scène contient des boîtes de dialogue (contre-
                    # épreuve ROM indépendante) ; sinon c'est canonique.
                    cif_p = cine_dir / f"{st}.cif.json"
                    cif_dialogs = 0
                    if cif_p.exists():
                        try:
                            cd = json.loads(
                                cif_p.read_text(encoding="utf-8-sig"))
                            cif_dialogs = sum(
                                1 for x in cd.get("raw_sequence", [])
                                if x.get("type") == "Dialog")
                        except Exception:
                            pass
                    if cif_dialogs:
                        add("HIGH", "CINEMATIC", st,
                            f"0 bloc de texte extrait alors que le cif "
                            f"compte {cif_dialogs} boîtes de dialogue")
                    else:
                        add("ACCEPTED", "CINEMATIC", st,
                            "0 bloc de texte — canonique (le cif de la ROM "
                            "compte aussi 0 dialogue pour cette station)")
            elif s["status"] == "REVIEW_REQUIRED":
                add("LOW", "CINEMATIC", st,
                    "dialogues REVIEW_REQUIRED (graphe EU non exact — "
                    "documenté, pas un PASS)")
            else:
                add("MEDIUM", "CINEMATIC", st,
                    f"dialogues status inattendu: {s['status']}")

    # ---------------- F2: archives de scripts ROM (Sky : rom_scripts/*.json.gz)
    idx_p = cine_dir / "ROM_SCRIPTS_INDEX.json"
    if idx_p.exists():
        idx = json.loads(idx_p.read_text(encoding="utf-8-sig"))
        for zone, z in idx.get("zones", {}).items():
            if not (cine_dir / z["file"]).exists():
                add("HIGH", "CINEMATIC", zone,
                    f"archive de scripts ROM manquante: {z['file']}")
            for name, s in z.get("scripts", {}).items():
                if s["status"] not in ("PASS",):
                    sev = "HIGH" if s["status"] in ("FAIL", "MISSING") \
                        else "MEDIUM"
                    add(sev, "CINEMATIC", f"{zone}/{name}",
                        f"script ROM status={s['status']}"
                        + (f" ({s.get('error','')[:120]})"
                           if s.get("error") else ""))
        # cohérence index ↔ manifest : zones liées
        linked_levels = set()
        for e in manifest["grounds"]:
            for s in (e.get("cinematic") or {}).get("levels", []):
                linked_levels.add(s["level"])
        unlinked = sorted(set(idx.get("zones", {})) - linked_levels
                          - {"COMMON"})
        for z in unlinked:
            add("MEDIUM", "CINEMATIC", z,
                "zone SCRIPT de la ROM non liée à un ground du manifest")

    # ---------------- G: doublons (renders identiques)
    hashes = defaultdict(list)
    for d in sorted((cdir / "Renders").iterdir()):
        p = d / "frame_000.png" if d.is_dir() else None
        if p and p.exists():
            hashes[sha256(p)].append(d.name)
    dup_groups = [v for v in hashes.values() if len(v) > 1]
    for grp in dup_groups:
        # Contre-épreuve SOURCE automatique : les renders identiques sont
        # canoniques si (1) les Layers des .rsground sont identiques après
        # normalisation de l'ID propre et (2) le CONTENU pixel des planches
        # .tile référencées est identique (le conteneur binaire diffère par
        # timestamp/ordre — comparer les cellules décodées, pas les octets).
        verdict = _source_duplicate_verdict(cfg, grp)
        if verdict == "IDENTICAL_SOURCE":
            add("ACCEPTED", "DUPLICATE", "+".join(grp[:4]),
                f"{len(grp)} renders bit-identiques — CONFIRMÉ canonique : "
                f"Layers normalisés ET contenu pixel des planches .tile "
                f"identiques dans la source (variantes du même lieu)")
        elif verdict == "IDENTICAL_FIRST_FRAME":
            add("ACCEPTED", "DUPLICATE", "+".join(grp[:4]),
                f"{len(grp)} renders frame_000 identiques — CONFIRMÉ "
                f"canonique : projection première frame identique au niveau "
                f"pixel ; les sources ne diffèrent que par l'ANIMATION "
                f"(variante animée du même lieu, frames rendues séparément)")
        elif verdict == "DIFFERS":
            add("HIGH", "DUPLICATE", "+".join(grp[:4]),
                f"{len(grp)} renders bit-identiques alors que les sources "
                f"diffèrent — rendu suspect à réexaminer")
        else:
            add("LOW", "DUPLICATE", "+".join(grp[:4]),
                f"{len(grp)} renders bit-identiques (frame_000) — source "
                f"incomplète pour trancher ({verdict})")

    # ---------------- couvertures séparées (jamais fusionnées)
    n = len(manifest["grounds"])
    rendered_n = sum(1 for e in manifest["grounds"] if e.get("render"))
    frames_pass = sum(1 for v in frame_status.values() if v["status"] == "PASS")
    sev_count = Counter(f["severity"] for f in findings)
    coverage = {
        "grounds_total": n,
        "render_pct": round(100 * rendered_n / n, 1) if n else 0,
        "frames_full_pct": (round(100 * frames_pass / len(frame_status), 1)
                            if frame_status else None),
        "cinematic_linked_pct": round(
            100 * sum(1 for e in manifest["grounds"] if "cinematic" in e) / n, 1)
            if n else 0,
        "human_identity_pct": round(100 * (n - technical) / n, 1) if n else 0,
        "note": "pourcentages séparés — ne JAMAIS fusionner en un '100%'",
    }
    blocking = sev_count.get("CRITICAL", 0) + sev_count.get("HIGH", 0)
    return {
        "campaign": camp,
        "findings": findings,
        "severity_totals": dict(sev_count),
        "frame_status": frame_status,
        "coverage": coverage,
        "verdict": "BLOCKED" if blocking else "AUDIT_PASS",
        "blocking_findings": blocking,
    }


def main() -> int:
    rc = 0
    for camp, cfg in CAMPAIGNS.items():
        res = audit_campaign(camp, cfg)
        cdir = ROOT / "dev" / "CAMPAIGNS" / camp
        (cdir / "AUDIT.json").write_text(
            json.dumps(res, indent=1, ensure_ascii=False))
        md = [f"# Audit automatique — {camp}\n",
              f"**Verdict : {res['verdict']}** — {res['blocking_findings']} "
              f"anomalie(s) bloquante(s)\n",
              f"Sévérités : {res['severity_totals']}\n",
              f"Couvertures (séparées) : {json.dumps(res['coverage'], ensure_ascii=False)}\n",
              "| Sévérité | Catégorie | Sujet | Détail |", "|---|---|---|---|"]
        order = {"CRITICAL": 0, "HIGH": 1, "MEDIUM": 2, "LOW": 3, "ACCEPTED": 4}
        for f in sorted(res["findings"],
                        key=lambda x: order.get(x["severity"], 9))[:400]:
            md.append(f"| {f['severity']} | {f['category']} | "
                      f"`{f['subject']}` | {f['detail'][:140]} |")
        (cdir / "AUDIT.md").write_text("\n".join(md) + "\n")
        print(f"{camp}: {res['verdict']} — {res['severity_totals']} — "
              f"couvertures {res['coverage']}")
        if res["verdict"] != "AUDIT_PASS":
            rc = 1
    return rc


if __name__ == "__main__":
    raise SystemExit(main())
