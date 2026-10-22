#!/usr/bin/env python3
"""Promotion des Grounds canoniques PMD Red sur les emplacements actifs.

Constat
-------
Les Grounds du périmètre Ch.6-32 sont censés être les ports 1:1 des Grounds de
la ROM (`RESERVE/red_grounds/`, 245 fichiers, et `RESERVE/pmdred_direct/` pour
les 27 reconstruits depuis les octets de la ROM EU). En comparant tuile à tuile
(en neutralisant le seul nom de planche), 17 Grounds actifs **divergent** de leur
port : géométrie retouchée, voire dimensions changées
(`foret_givree_oree` 42x40 au lieu de 42x33, `mont_gele_pied` 36x40 au lieu de
36x33). Ce ne sont donc plus les décors de la ROM.

Ce que fait ce script
---------------------
Pour chaque Ground du périmètre, il réinstalle le port canonique à
l'emplacement actif :

* la géométrie, les collisions, les décors et les entités viennent du port ;
* `AssetName` reprend le nom actif (les scripts et les zones y font référence) ;
* la planche de tuiles du port est copiée dans `Content/Tile` si elle manque,
  et la référence `Sheet` reste celle du port — donc les pixels sont ceux de la
  ROM, pas une retexture ;
* le Ground remplacé est archivé sous `RESERVE/legacy_ch6_32/replaced_grounds/`.

Source de la correspondance nom actif ↔ identifiant ROM :
`docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md`.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import shutil
from pathlib import Path
from typing import Dict, Optional, Tuple

ROOT = Path(__file__).resolve().parents[1]
GROUND_DIR = ROOT / "Data" / "Ground"
TILE_DIR = ROOT / "Content" / "Tile"
RED_GROUNDS = ROOT / "RESERVE" / "red_grounds"
RED_TILES = ROOT / "RESERVE" / "red_tiles"
DIRECT_TILES = ROOT / "RESERVE" / "pmdred_direct" / "tiles"
DIRECT_GROUNDS = ROOT / "RESERVE" / "pmdred_direct" / "grounds"
ARCHIVE = ROOT / "RESERVE" / "legacy_ch6_32" / "replaced_grounds"

#: Ground actif -> identifiant ROM (docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md)
CANON: Dict[str, str] = {
    "foret_tendre_oree": "d01p01", "d01p02": "d01p02",
    "grotte_statique_seuil": "d02p01", "d02p02": "d02p02",
    "pic_ferreux_pied": "d03p01", "d03p02": "d03p02",
    "bois_sombres_oree": "d04p01",
    "gouffre_muet_bord": "d05p01", "d05p02": "d05p02",
    "mont_grondant_pied": "d06p01", "d06p02": "d06p02", "d06p03": "d06p03",
    "grand_canyon_porte": "d07p01", "d07p02": "d07p02",
    "grotte_lazuli_seuil": "d08p01", "grotte_lazuli_fond": "d08p02",
    "mont_cendre_pied": "d09p01", "d09p02": "d09p02", "d09p03": "d09p03",
    "foret_givree_oree": "d10p01", "d10p02": "d10p02", "d10p03": "d10p03",
    "mont_gele_pied": "d11p01", "d11p02": "d11p02", "d11p03": "d11p03",
    "gorge_ardente_porte": "d12p01", "gorge_ardente_coeur": "d12p02",
    "fosse_ardente": "d12p04",
    "arc_parvis_celeste": "d13p01", "arc_palier_celeste": "d13p02",
    "arc_tour_ciel_sommet": "d13p03",
    "abime_tempetes": "d14p01", "fosse_argentee": "d15p01",
    "champ_braises": "d16p01", "champ_foudre": "d17p01",
    "champ_vent_boreal": "d18p01", "sommet_aurore": "d19p01",
    "antre_occident": "d20p01", "cretes_boreales": "d21p01",
    "vallon_perdu": "d22p01", "sanctuaire_voeu": "d23p01",
    "caverne_trouble_fond": "d24p01", "caverne_trouble_autel": "d24p02",
    "bois_des_plaintes": "d25p01",
}


def read(path: Path) -> Optional[dict]:
    if not path.is_file():
        return None
    try:
        return json.loads(path.read_text(encoding="utf-8-sig"))
    except (OSError, json.JSONDecodeError):
        return None


def tile_signature(payload: dict) -> Optional[str]:
    """Empreinte des tuiles, nom de planche neutralisé."""
    obj = payload.get("Object") if payload else None
    if not obj:
        return None
    layers = obj.get("Layers") or [{}]
    text = json.dumps(layers[0].get("Tiles"), sort_keys=True)
    text = re.sub(r'"Sheet": "[^"]*"', '"Sheet": "*"', text)
    return hashlib.sha256(text.encode()).hexdigest()[:16]


def _sheets_available(path: Path) -> bool:
    payload = read(path)
    if payload is None:
        return False
    for sheet in sheets_of(payload):
        if not any((base / f"{sheet}.tile").is_file()
                   for base in (TILE_DIR, RED_TILES, DIRECT_TILES)):
            return False
    return True


def port_for(rom_id: str) -> Tuple[Optional[Path], str]:
    """Port canonique le plus fidèle DONT les planches sont disponibles.

    La reconstruction EU directe (`pmdred_direct`) serait la plus fidèle — elle
    embarque les animations CANM — mais ses atlas `*_DirectBase.tile` ne sont pas
    dans le dépôt : on ne promeut alors que le port 1:1 `red_grounds`.
    """
    direct = DIRECT_GROUNDS / f"{rom_id}.rsground"
    if direct.is_file() and _sheets_available(direct):
        return direct, "pmdred_direct (octets ROM EU)"
    red = RED_GROUNDS / f"{rom_id}.rsground"
    if red.is_file():
        return red, "red_grounds (port 1:1)"
    if direct.is_file():
        return direct, "pmdred_direct (atlas absent)"
    return None, ""


def sheets_of(payload: dict) -> set:
    return set(re.findall(r'"Sheet": "([^"]+)"', json.dumps(payload)))


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--apply", action="store_true", help="écrire les fichiers")
    parser.add_argument("--report", type=str, default="")
    args = parser.parse_args()

    rows = []
    promoted = missing_tiles = 0
    for ground, rom_id in sorted(CANON.items()):
        active_path = GROUND_DIR / f"{ground}.rsground"
        port_path, origin = port_for(rom_id)
        active, port = read(active_path), read(port_path) if port_path else None
        if port is None:
            rows.append((ground, rom_id, "aucun port disponible", ""))
            continue
        same = tile_signature(active) == tile_signature(port) if active else False
        if same:
            rows.append((ground, rom_id, "déjà conforme", origin))
            continue

        payload = json.loads(json.dumps(port))
        payload["Object"]["AssetName"] = ground
        if active:
            # on conserve le nom affiché et la musique choisis par le mod
            for key in ("Name", "Music"):
                if active["Object"].get(key):
                    payload["Object"][key] = active["Object"][key]

        needed = sheets_of(payload)
        for sheet in sorted(needed):
            target = TILE_DIR / f"{sheet}.tile"
            source = next((base / f"{sheet}.tile" for base in (RED_TILES, DIRECT_TILES)
                           if (base / f"{sheet}.tile").is_file()), None)
            if target.is_file():
                continue
            if source is not None:
                if args.apply:
                    shutil.copy2(source, target)
            else:
                missing_tiles += 1
                rows.append((ground, rom_id, f"planche manquante: {sheet}", origin))

        if args.apply:
            if active_path.is_file():
                ARCHIVE.mkdir(parents=True, exist_ok=True)
                shutil.copy2(active_path, ARCHIVE / active_path.name)
            active_path.write_text(
                json.dumps(payload, ensure_ascii=False, indent=2) + "\n",
                encoding="utf-8-sig")
        promoted += 1
        rows.append((ground, rom_id, "PROMU depuis le port", origin))

    width = max(len(r[0]) for r in rows)
    for ground, rom_id, state, origin in rows:
        print(f"{ground:<{width}} {rom_id:8} {state:26} {origin}")
    print(f"\n{promoted} Ground(s) à promouvoir, {missing_tiles} planche(s) manquante(s)")
    if not args.apply:
        print("(simulation : relancer avec --apply)")

    if args.report:
        lines = ["# Promotion des Grounds canoniques PMD Red", "",
                 "| Ground actif | ROM | État | Port utilisé |", "|---|---|---|---|"]
        lines += [f"| `{g}` | `{r.upper()}` | {s} | {o} |" for g, r, s, o in rows]
        Path(args.report).write_text("\n".join(lines) + "\n", encoding="utf-8")
        print(f"rapport: {args.report}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
