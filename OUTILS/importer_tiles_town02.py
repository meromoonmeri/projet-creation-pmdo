#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Importe les tuiles town02 (New Era : Abyss to Ascension) dans quest_pmd_destiny/
EN NE GARDANT PAS les éléments de Palikadude/Halcyon.

Règle de provenance (PROMPT PMDO Destiny + consigne de l'utilisateur) :
- fichier présent dans Palikadude/Halcyon (même nom)  -> NEUTRALISÉ :
  placeholder neutre de mêmes dimensions (mêmes (x,y), mêmes tailles de
  sous-images) pour que les maps ne cassent pas, AUCUN pixel d'origine copié.
  Deux homonymes modifiés (Metano_Town_Base.tile, Title_Screen_Background.dir)
  suivent la même règle par défaut ; la surcharge peut les basculer en « propre ».
- tout le reste (créations Abyss Ascension) -> copié à l'identique.

Formats (vérifiés, cf. renders/*/package/INSTALLER.py de la branche e39626d2) :
- .tile  = [i32 tile_size][i32 count][count x (i32 x, i32 y, u64 offset)]
           puis à chaque offset [u64 png_len][png].
- .dir   = [u64 png_len][png][16 octets de queue (w,h,x,y) recopiés tels quels].
- Content/Tile/index.idx = [i32 n][n x (chaîne .NET 7-bit + nœud .tile)] trié
           par nom ; le nœud = les (8 + 16*count) premiers octets du .tile.

Sorties :
- quest_pmd_destiny/Content/{Tile,BG}/… + Content/Tile/index.idx régénéré
- quest_pmd_destiny/PLACEHOLDERS_HALCYON.json (art_approved: false)
- quest_pmd_destiny/COMPATIBILITE_TUILES.md (rapport)
- OUTILS/surcharge_provenance_tiles.json (surcharge éditable, créée au 1er lancement)

Usage : python3 OUTILS/importer_tiles_town02.py [--dry-run]
Réexécutable ; ne supprime jamais les fichiers déjà présents hors de son périmètre.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import shutil
import struct
import sys
import zlib
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TOWN = Path("/tmp/town02-src/Content")
HAL = Path("/tmp/halcyon-src/Content")
QUEST = ROOT / "quest_pmd_destiny"
CONTENT = QUEST / "Content"
SURCHARGE = ROOT / "OUTILS" / "surcharge_provenance_tiles.json"

NOMS_HOMONYMES_MODIFIES = ["Metano_Town_Base.tile", "Title_Screen_Background.dir"]
SUSPECTS = re.compile(r"pmd\s*sky|pmd_|rip|sprite.?resource|\beos\b|\beod\b|nds", re.I)


# ------------------------------------------------------------------ binaires
def exact(f, n):
    b = f.read(n)
    if len(b) != n:
        raise ValueError("fichier tronqué")
    return b


def write_string(value: str) -> bytes:
    raw = value.encode("utf-8")
    size, header = len(raw), bytearray()
    while size >= 128:
        header.append((size & 127) | 128)
        size >>= 7
    return bytes(header) + bytes([size]) + raw


def read_string(f) -> str:
    size, shift = 0, 0
    while True:
        byte = exact(f, 1)[0]
        size |= (byte & 127) << shift
        if byte < 128:
            return exact(f, size).decode("utf-8")
        shift += 7
        if shift > 35:
            raise ValueError("chaîne .NET invalide")


def parse_tile(raw: bytes):
    """-> (tile_size, [(x, y, png_bytes)])"""
    tile_size, count = struct.unpack_from("<ii", raw, 0)
    recs = []
    for i in range(count):
        x, y, off = struct.unpack_from("<iiQ", raw, 8 + 16 * i)
        (ln,) = struct.unpack_from("<Q", raw, off)
        png = raw[off + 8: off + 8 + ln]
        if png[:8] != b"\x89PNG\r\n\x1a\n":
            raise ValueError("PNG invalide dans .tile")
        recs.append((x, y, png))
    return tile_size, recs


def png_size(png: bytes) -> tuple[int, int]:
    return struct.unpack_from(">II", png, 16)


# --------------------------------------------------------------- PNG neutre
def png_neutre(w: int, h: int) -> bytes:
    """Damier gris/magenta translucide : structure visible, art évidemment absent."""
    rows = bytearray()
    for yy in range(h):
        rows.append(0)
        for xx in range(w):
            cell = ((xx // 8) + (yy // 8)) & 1
            if cell:
                rows += bytes((150, 150, 158, 190))
            else:
                rows += bytes((96, 96, 104, 190))

    def chunk(tag, data):
        c = struct.pack(">I", len(data)) + tag + data
        return c + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)

    ihdr = struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0)
    return (b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", ihdr)
            + chunk(b"IDAT", zlib.compress(bytes(rows), 9)) + chunk(b"IEND", b""))


def placeholder_tile(raw: bytes) -> bytes:
    tile_size, recs = parse_tile(raw)
    count = len(recs)
    header_len = 8 + count * 16
    body = bytearray()
    table = bytearray()
    off = header_len
    for x, y, png in recs:
        w, h = png_size(png)
        n = png_neutre(w, h)
        table += struct.pack("<iiQ", x, y, off)
        body += struct.pack("<Q", len(n)) + n
        off += 8 + len(n)
    return struct.pack("<ii", tile_size, count) + bytes(table) + bytes(body)


def placeholder_dir(raw: bytes) -> bytes:
    (ln,) = struct.unpack_from("<Q", raw, 0)
    png = raw[8: 8 + ln]
    w, h = png_size(png)
    queue = raw[8 + ln:]
    n = png_neutre(w, h)
    return struct.pack("<Q", len(n)) + n + queue


# ------------------------------------------------- index.idx (cf. INSTALLER)
def read_node(f) -> bytes:
    header = exact(f, 8)
    tile_size, count = struct.unpack("<ii", header)
    if tile_size <= 0 or not 0 <= count <= 10_000_000:
        raise ValueError("nœud TileIndex invalide")
    return header + exact(f, count * 16)


def encode_index(nodes: dict[str, bytes]) -> bytes:
    return struct.pack("<i", len(nodes)) + b"".join(
        write_string(k) + nodes[k] for k in sorted(nodes))


# ------------------------------------------------------------------ divers
def sha256(p: Path) -> str:
    h = hashlib.sha256()
    with p.open("rb") as f:
        for c in iter(lambda: f.read(1 << 20), b""):
            h.update(c)
    return h.hexdigest()


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    for d in (TOWN, HAL):
        if not d.is_dir():
            print(f"SOURCE MANQUANTE : {d} — relancer le clonage sparse (voir rapport).",
                  file=sys.stderr)
            return 2

    # --- index Halcyon par nom (hash)
    hal: dict[str, list[str]] = {}
    for p in list((HAL / "Tile").glob("*")) + list((HAL / "BG").glob("*")):
        if p.is_file() and p.name != "index.idx":
            hal.setdefault(p.name, []).append(sha256(p))

    surcharge: dict[str, str] = {}
    if SURCHARGE.exists():
        surcharge = json.loads(SURCHARGE.read_text(encoding="utf-8-sig"))

    fichiers = [p for p in sorted(list((TOWN / "Tile").glob("*")) + list((TOWN / "BG").glob("*")))
                if p.is_file() and p.name != "index.idx"]

    copie, neutre, homonymes, suspects = [], [], [], []
    stats = {"propre": 0, "neutre": 0, "copie_binaire": 0}
    manifest = []

    for src in fichiers:
        ext = src.suffix.lower()
        if src.name in hal:
            identique = sha256(src) in hal[src.name]
            cat = "halcyon_identique" if identique else "halcyon_homonyme_modifie"
        else:
            cat = "hors_halcyon"
        verdict = surcharge.get(src.name)
        if verdict not in ("propre", "neutre"):
            verdict = "neutre" if cat.startswith("halcyon") else "propre"
            if cat == "halcyon_homonyme_modifie":
                homonymes.append(src.name)
        if cat == "hors_halcyon" and SUSPECTS.search(src.name):
            suspects.append(src.name)

        dst_dir = CONTENT / ("Tile" if src.parent.name == "Tile" else "BG")
        dst = dst_dir / src.name
        if verdict == "propre":
            stats["propre"] += 1
            if ext in (".tile", ".dir", ".png", ".sai2"):
                copie.append((src, dst))
            else:
                stats["copie_binaire"] += 1
                copie.append((src, dst))
        else:
            stats["neutre"] += 1
            if ext not in (".tile", ".dir"):
                # aucun art hors .tile/.dir ne doit arriver par le neutre
                continue
            neutre.append((src, dst, ext, cat))
            manifest.append({
                "fichier": f"Content/{dst_dir.name}/{src.name}",
                "type": ext[1:],
                "origine": "Palikadude/Halcyon (contenu tiers non redistribué)",
                "categorie": cat,
                "sha256_original": sha256(src),
                "art_approved": False,
                "runtime_tested": False,
                "note": "placeholder neutre : mêmes dimensions et coordonnées, aucun pixel d'origine",
            })

    print(f"town02 : {len(fichiers)} fichiers -> "
          f"{stats['propre']} conservés, {stats['neutre']} neutralisés")
    if homonymes:
        print("homonymes modifiés neutralisés par défaut :", ", ".join(homonymes))
    if suspects:
        print(f"{len(suspects)} noms suspects conservés (origine non vérifiable, "
              f"voir rapport) — surcharge possible en « neutre »")

    if args.dry_run:
        print("dry-run : aucun fichier écrit.")
        return 0

    # --- écriture
    for src, dst in copie:
        dst.parent.mkdir(parents=True, exist_ok=True)
        if not dst.exists() or dst.read_bytes() != src.read_bytes():
            shutil.copyfile(src, dst)
    for src, dst, ext, cat in neutre:
        dst.parent.mkdir(parents=True, exist_ok=True)
        raw = src.read_bytes()
        out = placeholder_tile(raw) if ext == ".tile" else placeholder_dir(raw)
        if not dst.exists() or dst.read_bytes() != out:
            dst.write_bytes(out)

    # --- index régénéré depuis TOUS les .tile présents
    nodes = {}
    for tile in sorted((CONTENT / "Tile").glob("*.tile")):
        with tile.open("rb") as f:
            nodes[tile.stem] = read_node(f)
    idx_path = CONTENT / "Tile" / "index.idx"
    idx_path.write_bytes(encode_index(nodes))
    print(f"index.idx régénéré : {len(nodes)} tilesets "
          f"({idx_path.stat().st_size} octets)")

    # --- manifeste + surcharge
    (QUEST / "PLACEHOLDERS_HALCYON.json").write_text(
        json.dumps({
            "date": date.today().isoformat(),
            "politique": "aucun pixel de Palikadude/Halcyon redistribué ; "
                         "placeholders neutres pour garder les maps jouables",
            "art_approved": False,
            "fichiers": manifest,
        }, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")
    if not SURCHARGE.exists():
        SURCHARGE.write_text(json.dumps({
            "_mode": "propre | neutre — relancer OUTILS/importer_tiles_town02.py après modification",
            "_exemples": {
                "Metano_Town_Base.tile": "propre",
                "Title_Screen_Background.dir": "propre",
                "10-PMD SKY.tile": "neutre",
            },
        }, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")

    # --- rapport
    lignes = [
        "# Compatibilité des tuiles town02 avec la quest PMDO Destiny",
        "",
        f"Généré le {date.today().isoformat()} par `OUTILS/importer_tiles_town02.py`.",
        "",
        "## Politique appliquée",
        "",
        "- **Palikadude/Halcyon (contenu tiers) : NON redistribué.** Les "
        f"{stats['neutre']} fichiers qui y sont identiques (ou homonymes) sont remplacés "
        "par des **placeholders neutres** (damier gris) de **mêmes dimensions, mêmes "
        "coordonnées (x,y), mêmes tailles de sous-images** : les maps se chargent et "
        "restent jouables, sans aucun pixel d'origine.",
        "- **Créations Abyss Ascension : conservées à l'identique** "
        f"({stats['propre']} fichiers copiés sans modification).",
        "- `Content/Tile/index.idx` **régénéré** depuis les `.tile` présents "
        "(format exact repris de `renders/*/package/INSTALLER.py`).",
        "",
        "## Basculer un fichier",
        "",
        f"Éditer `{SURCHARGE.relative_to(ROOT)}` (`\"nom.ext\": \"propre\"` ou `\"neutre\"`), "
        "puis relancer ce script. Cas ambigus par défaut neutre : "
        + (", ".join(f"`{h}`" for h in homonymes) or "aucun") + ".",
        "",
        f"## Noms conservés dont l'origine n'a pas pu être vérifiée ({len(suspects)})",
        "",
        "Ces fichiers ne sont pas dans Palikadude/Halcyon : ils sont donc traités comme "
        "vos créations, mais leur nom évoque du matériel existant. À confirmer ; passez "
        "en `\"neutre\"` dans la surcharge pour tout retirer.",
        "",
    ]
    for s in suspects:
        lignes.append(f"- `{s}`")
    lignes += ["", "## Restaurer l'art complet en local", "",
               "Vous possédez town02 : copiez simplement les `.tile`/`.dir` d'origine "
               "par-dessus les placeholders (mêmes noms) — les coordonnées sont "
               "identiques, la restauration est sans risque.", ""]
    (QUEST / "COMPATIBILITE_TUILES.md").write_text("\n".join(lignes), encoding="utf-8")

    print(f"rapport : quest_pmd_destiny/COMPATIBILITE_TUILES.md "
          f"({len(manifest)} placeholders documentés)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
