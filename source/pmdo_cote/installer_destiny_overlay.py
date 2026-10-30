#!/usr/bin/env python3
"""Install the Destiny map catalogue into an existing PMDO 0.8.12 Quest.

This is an overlay installer, not a second Mod.xml/Quest. It preserves the
quest UUID and header, merges the native tile index, and refreshes the existing
developer-only ``exploration_cartes`` zone to list every Ground in the quest.
No story links, warps, or transitions are created.
"""
from __future__ import annotations

import argparse
import copy
import hashlib
import io
import json
import os
from pathlib import Path, PurePosixPath
import shutil
import struct
import tempfile
import xml.etree.ElementTree as ET

EXPECTED_NAMESPACE = "destiny"
EXPECTED_GAME_VERSION = "0.8.12.0"
ZONE_ID = "exploration_cartes"
ZONE_NAME = "Exploration des cartes (dev)"
ZONE_COMMENT = (
    "Zone de prévisualisation : toutes les maps Data/Ground déclarées pour l'exploration "
    "en mode développeur. Aucune transition ; ne fait pas partie de la progression."
)
MANIFEST_PATH = Path("Documentation/catalogue_manifest.json")


def exact(stream: io.BytesIO, size: int) -> bytes:
    data = stream.read(size)
    if len(data) != size:
        raise ValueError("index.idx / tileset tronqué")
    return data


def read_string(stream: io.BytesIO) -> str:
    size = 0
    for shift in range(0, 35, 7):
        byte = exact(stream, 1)[0]
        size |= (byte & 127) << shift
        if byte < 128:
            return exact(stream, size).decode("utf-8")
    raise ValueError("longueur .NET invalide dans l'index PMDO")


def write_string(value: str) -> bytes:
    raw = value.encode("utf-8")
    size = len(raw)
    prefix = bytearray()
    while size >= 128:
        prefix.append((size & 127) | 128)
        size >>= 7
    prefix.append(size)
    return bytes(prefix) + raw


def read_index_bytes(data: bytes) -> dict[str, bytes]:
    if not data:
        return {}
    stream = io.BytesIO(data)
    count, = struct.unpack("<i", exact(stream, 4))
    if not 0 <= count <= 100_000:
        raise ValueError("nombre de tilesets invalide dans Content/Tile/index.idx")
    nodes: dict[str, bytes] = {}
    folded: set[str] = set()
    for _ in range(count):
        name = read_string(stream)
        header = exact(stream, 8)
        tile_size, tile_count = struct.unpack("<ii", header)
        if tile_size <= 0 or not 0 <= tile_count <= 10_000_000:
            raise ValueError(f"nœud de tileset invalide dans index.idx : {name}")
        node = header + exact(stream, tile_count * 16)
        if name in nodes or name.casefold() in folded:
            raise ValueError(f"nom de tileset en double dans index.idx : {name}")
        nodes[name] = node
        folded.add(name.casefold())
    if stream.read(1):
        raise ValueError("octets excédentaires dans Content/Tile/index.idx")
    return nodes


def encode_index(nodes: dict[str, bytes]) -> bytes:
    ordered = sorted(nodes)
    return struct.pack("<i", len(ordered)) + b"".join(
        write_string(name) + nodes[name] for name in ordered
    )


def tile_index_node(path: Path) -> bytes:
    with path.open("rb") as stream:
        header = stream.read(8)
        if len(header) != 8:
            raise ValueError(f"tileset trop court : {path.name}")
        tile_size, count = struct.unpack("<ii", header)
        if tile_size <= 0 or not 0 <= count <= 10_000_000:
            raise ValueError(f"en-tête tileset invalide : {path.name}")
        rest = stream.read(count * 16)
        if len(rest) != count * 16:
            raise ValueError(f"table de tileset tronquée : {path.name}")
        return header + rest


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def load_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def atomic_write(path: Path, data: bytes) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temp_name = None
    try:
        with tempfile.NamedTemporaryFile(
            prefix=f".{path.name}.", suffix=".tmp", dir=path.parent, delete=False
        ) as temp:
            temp_name = temp.name
            temp.write(data)
            temp.flush()
            os.fsync(temp.fileno())
        os.replace(temp_name, path)
    finally:
        if temp_name:
            Path(temp_name).unlink(missing_ok=True)


def make_backup(path: Path) -> Path | None:
    if not path.exists():
        return None
    base = path.with_name(path.name + ".pre_destiny_maps.bak")
    backup = base
    suffix = 1
    while backup.exists():
        backup = base.with_name(base.name + f".{suffix}")
        suffix += 1
    shutil.copy2(path, backup)
    return backup


def get_target_quest(target: Path) -> ET.Element:
    mod_path = target / "Mod.xml"
    if not mod_path.is_file():
        raise ValueError("Cible invalide : sélectionner le dossier de la quête qui contient Mod.xml.")
    root = ET.parse(mod_path).getroot()
    namespace = (root.findtext("Namespace") or "").strip()
    game_version = (root.findtext("GameVersion") or "").strip()
    mod_type = (root.findtext("ModType") or "").strip()
    if mod_type.casefold() != "quest":
        raise ValueError(f"Le dossier cible n'est pas une Quest PMDO (ModType={mod_type!r}).")
    if namespace != EXPECTED_NAMESPACE:
        raise ValueError(
            f"Namespace cible {namespace!r}; attendu {EXPECTED_NAMESPACE!r}. Mod.xml reste intact."
        )
    if game_version != EXPECTED_GAME_VERSION:
        raise ValueError(f"Version cible {game_version!r}; attendu {EXPECTED_GAME_VERSION!r}.")
    return root


def validate_overlay(source: Path) -> tuple[dict, list[Path]]:
    manifest_path = source / MANIFEST_PATH
    if not manifest_path.is_file():
        raise ValueError(f"Manifeste de l'overlay absent : {manifest_path}")
    manifest = load_json(manifest_path)
    rows = manifest.get("maps", [])
    if not isinstance(rows, list) or not rows:
        raise ValueError("Le manifeste ne contient aucune Ground.")

    expected: dict[str, tuple[str, str]] = {}
    rows_by_ground: dict[str, dict] = {}
    map_ids: set[str] = set()
    for row in rows:
        map_id = row.get("mapId")
        relative = row.get("groundFile")
        checksum = row.get("outputGroundSha256")
        if not all(isinstance(value, str) and value for value in (map_id, relative, checksum)):
            raise ValueError("Identifiant, chemin ou SHA Ground invalide dans le manifeste.")
        safe = PurePosixPath(relative)
        if (
            safe.is_absolute()
            or ".." in safe.parts
            or len(safe.parts) != 3
            or safe.parts[:2] != ("Data", "Ground")
            or safe.suffix != ".rsground"
            or safe.stem != map_id
            or not map_id.isascii()
        ):
            raise ValueError(f"Chemin/identifiant Ground invalide dans le manifeste : {relative}")
        if relative in expected or map_id in map_ids:
            raise ValueError(f"Ground ou identifiant en double dans le manifeste : {relative}")
        expected[relative] = (map_id, checksum)
        rows_by_ground[relative] = row
        map_ids.add(map_id)

    grounds = sorted(
        (source / "Data/Ground").glob("*.rsground"), key=lambda path: path.name.casefold()
    )
    actual = {path.relative_to(source).as_posix(): path.stem for path in grounds}
    expected_ids = {relative: value[0] for relative, value in expected.items()}
    if actual != expected_ids:
        raise ValueError(
            f"Grounds de l'overlay différents du manifeste : "
            f"{len(actual)} présents, {len(expected_ids)} attendus."
        )
    for path in grounds:
        relative = path.relative_to(source).as_posix()
        _, expected_sha = expected[relative]
        if sha256_file(path) != expected_sha:
            raise ValueError(f"SHA-256 Ground incorrect : {path.name}")
        document = load_json(path)
        obj = document.get("Object", {})
        expected_version = rows_by_ground[relative].get(
            "groundVersion", rows_by_ground[relative].get("version")
        )
        ground_version = str(document.get("Version", ""))
        if not expected_version or ground_version != str(expected_version):
            raise ValueError(
                f"Ground.Version différent du manifeste pour {path.name}: "
                f"{ground_version!r} != {expected_version!r}"
            )
        tex_size = obj.get("TexSize")
        expected_tex_size = rows_by_ground[relative].get("texSize")
        if not isinstance(tex_size, int) or isinstance(tex_size, bool) or tex_size <= 0:
            raise ValueError(f"TexSize Ground invalide : {path.name}")
        if expected_tex_size is not None and int(expected_tex_size) != tex_size:
            raise ValueError(
                f"Ground.TexSize différent du manifeste pour {path.name}: "
                f"{tex_size} != {expected_tex_size}"
            )
        if obj.get("AssetName") != path.stem:
            raise ValueError(f"AssetName Ground différent du nom du fichier : {path.name}")
    return manifest, grounds


def safe_copy_plan(source: Path, target: Path) -> list[tuple[Path, Path]]:
    plan: list[tuple[Path, Path]] = []
    for top in ("Data/Ground", "Data/Script/destiny", "Content/Tile", "Content/BG"):
        root = source / top
        if not root.exists():
            continue
        for src in sorted(root.rglob("*"), key=lambda path: path.as_posix().casefold()):
            if not src.is_file():
                continue
            relative = src.relative_to(source)
            if relative.as_posix() == "Content/Tile/index.idx":
                continue  # rebuilt by merging the target and overlay tilesets
            if relative.parts[:2] == ("Content", "Tile") and src.suffix.casefold() != ".tile":
                continue
            if relative.parts[:2] == ("Content", "BG") and src.suffix.casefold() != ".dir":
                continue
            dst = target / relative
            if dst.exists():
                if not dst.is_file() or sha256_file(dst) != sha256_file(src):
                    raise ValueError(
                        f"Conflit : le fichier cible existe avec un contenu différent : {relative}"
                    )
            else:
                plan.append((src, dst))
    if not list((source / "Data/Ground").glob("*.rsground")):
        raise ValueError("L'overlay ne contient aucun Ground.")
    return plan


def merged_tile_index(source: Path, target: Path) -> tuple[bytes, int]:
    target_tile_dir = target / "Content/Tile"
    source_tile_dir = source / "Content/Tile"
    index_path = target_tile_dir / "index.idx"
    nodes = read_index_bytes(index_path.read_bytes()) if index_path.exists() else {}
    names_casefold = {name.casefold(): name for name in nodes}
    for directory in (target_tile_dir, source_tile_dir):
        if not directory.exists():
            continue
        for path in sorted(directory.glob("*.tile"), key=lambda item: item.name.casefold()):
            name = path.stem
            folded = name.casefold()
            prior_name = names_casefold.get(folded)
            if prior_name is not None and prior_name != name:
                raise ValueError(f"Collision de casse dans l'index tilesets : {prior_name} / {name}")
            node = tile_index_node(path)
            if prior_name is not None and prior_name in nodes and nodes[prior_name] != node:
                raise ValueError(
                    f"Le tileset {name} existe déjà dans index.idx avec un contenu différent; "
                    "installation annulée pour protéger la quête."
                )
            # Unrelated/orphan nodes are preserved; files and matching index
            # nodes are added without replacing a different existing tileset.
            nodes[name] = node
            names_casefold[folded] = name
    encoded = encode_index(nodes)
    if read_index_bytes(encoded) != nodes:
        raise ValueError("Échec de la relecture de l'index de tilesets fusionné.")
    return encoded, len(nodes)


def set_localized_name(container: dict, text: str) -> None:
    name = container.setdefault("Name", {})
    if not isinstance(name, dict):
        raise ValueError("Format Name inconnu dans les données de zone.")
    name["DefaultText"] = text
    local_texts = name.setdefault("LocalTexts", {})
    if not isinstance(local_texts, dict):
        raise ValueError("Format LocalTexts inconnu dans les données de zone.")
    local_texts["fr"] = text


def zone_documents(target: Path, ground_ids: list[str]) -> tuple[bytes, bytes]:
    zone_dir = target / "Data/Zone"
    index_path = zone_dir / "index.idx"
    if not index_path.is_file():
        raise ValueError("Data/Zone/index.idx absent dans la quête cible.")
    index_doc = load_json(index_path)
    index_obj = index_doc.get("Object")
    if not isinstance(index_obj, dict):
        raise ValueError("Data/Zone/index.idx n'a pas d'objet Dictionary PMDO reconnu.")
    if ZONE_ID in index_obj and not isinstance(index_obj[ZONE_ID], dict):
        raise ValueError(f"Entrée index existante invalide : {ZONE_ID}")

    zone_path = zone_dir / f"{ZONE_ID}.json"
    template_candidates = (
        zone_path,
        zone_dir / "personality_test.json",
        zone_dir / "exploration_cartes.json",
    )
    zone_doc = next((load_json(path) for path in template_candidates if path.is_file()), None)
    if zone_doc is None:
        raise ValueError("Aucun ZoneData PMDO de référence dans Data/Zone.")
    zone_obj = zone_doc.get("Object")
    if (
        not isinstance(zone_obj, dict)
        or zone_obj.get("$type") != "RogueEssence.Data.ZoneData, RogueEssence"
    ):
        raise ValueError("Le modèle de zone n'est pas un ZoneData PMDO reconnu.")
    zone_doc["Version"] = EXPECTED_GAME_VERSION
    set_localized_name(zone_obj, ZONE_NAME)
    zone_obj["Comment"] = ZONE_COMMENT
    zone_obj["Segments"] = []
    zone_obj["GroundMaps"] = ground_ids
    zone_bytes = (json.dumps(zone_doc, ensure_ascii=False, indent=1) + "\n").encode("utf-8")

    entries = [value for value in index_obj.values() if isinstance(value, dict) and "Grounds" in value]
    if ZONE_ID in index_obj:
        index_entry = copy.deepcopy(index_obj[ZONE_ID])
    elif entries:
        index_entry = copy.deepcopy(entries[0])
        index_entry["SortOrder"] = max(int(value.get("SortOrder", 0)) for value in entries) + 1
    else:
        raise ValueError("Aucun modèle ZoneEntrySummary avec Grounds dans Data/Zone/index.idx.")
    set_localized_name(index_entry, ZONE_NAME)
    index_entry["Grounds"] = ground_ids
    index_entry["Maps"] = []
    index_entry["Comment"] = ZONE_COMMENT
    index_obj[ZONE_ID] = index_entry
    index_bytes = (
        "\ufeff" + json.dumps(index_doc, ensure_ascii=False, indent=1) + "\n"
    ).encode("utf-8")
    return zone_bytes, index_bytes


def ground_ids_after_merge(target: Path, source_grounds: list[Path]) -> list[str]:
    target_ground_dir = target / "Data/Ground"
    names: dict[str, str] = {}
    if target_ground_dir.exists():
        for path in target_ground_dir.glob("*.rsground"):
            folded = path.stem.casefold()
            if folded in names and names[folded] != path.stem:
                raise ValueError(f"Collision de casse entre Grounds : {names[folded]} / {path.stem}")
            names[folded] = path.stem
    for path in source_grounds:
        folded = path.stem.casefold()
        if folded in names and names[folded] != path.stem:
            raise ValueError(f"Collision de nom Ground (différence de casse) : {names[folded]} / {path.stem}")
        names[folded] = path.stem
    result = sorted(names.values(), key=str.casefold)
    non_ascii = [name for name in result if not name.isascii()]
    if non_ascii:
        raise ValueError(
            "Identifiants Ground non ASCII non pris en charge pour cette zone développeur : "
            + ", ".join(non_ascii[:12])
        )
    return result


def install(source: Path, target: Path, dry_run: bool = False) -> dict:
    source, target = source.resolve(), target.resolve()
    quest_header = get_target_quest(target)
    if source == target or target in source.parents:
        raise ValueError("Extraire l'overlay dans un dossier temporaire séparé de la quête cible.")
    _, source_grounds = validate_overlay(source)
    plan = safe_copy_plan(source, target)
    ground_ids = ground_ids_after_merge(target, source_grounds)
    if not ground_ids:
        raise ValueError("La quête ne contient aucune carte Ground après fusion.")

    tile_index_data, tile_count = merged_tile_index(source, target)
    zone_bytes, zone_index_bytes = zone_documents(target, ground_ids)
    pending_writes = {
        target / "Data/Zone" / f"{ZONE_ID}.json": zone_bytes,
        target / "Data/Zone/index.idx": zone_index_bytes,
        target / "Content/Tile/index.idx": tile_index_data,
    }
    writes = [
        path for path, data in pending_writes.items()
        if not path.exists() or path.read_bytes() != data
    ]

    print(f"Quest : {quest_header.findtext('Name') or target.name}")
    print(f"Grounds du catalogue : {len(source_grounds)}")
    print(f"Grounds visibles dans la zone dev : {len(ground_ids)}")
    print(f"Tilesets dans l'index fusionné : {tile_count}")
    print(f"Fichiers à ajouter : {len(plan)} ; index/zone à mettre à jour : {len(writes)}")
    if dry_run:
        print("Simulation terminée : aucun fichier modifié.")
        return {
            "catalogueGrounds": len(source_grounds),
            "groundMapsVisible": len(ground_ids),
            "tilesets": tile_count,
            "filesAdded": len(plan),
            "metadataWrites": len(writes),
        }

    created: list[Path] = []
    original_metadata: list[tuple[Path, bytes | None]] = []
    temporary_files: list[Path] = []
    try:
        for src, dst in plan:
            dst.parent.mkdir(parents=True, exist_ok=True)
            with tempfile.NamedTemporaryFile(
                prefix=f".{dst.name}.", suffix=".destiny-overlay.tmp", dir=dst.parent, delete=False
            ) as temp:
                temp_path = Path(temp.name)
                temporary_files.append(temp_path)
                with src.open("rb") as incoming:
                    shutil.copyfileobj(incoming, temp, length=1024 * 1024)
                temp.flush()
                os.fsync(temp.fileno())
            try:
                os.link(temp_path, dst)
                created.append(dst)
            except FileExistsError:
                if not dst.is_file() or sha256_file(dst) != sha256_file(src):
                    raise ValueError(f"Le fichier cible a changé pendant l'installation : {dst}")
            except OSError:
                if dst.exists():
                    if not dst.is_file() or sha256_file(dst) != sha256_file(src):
                        raise ValueError(f"Le fichier cible a changé pendant l'installation : {dst}")
                else:
                    os.replace(temp_path, dst)
                    created.append(dst)
            finally:
                temp_path.unlink(missing_ok=True)
                if temp_path in temporary_files:
                    temporary_files.remove(temp_path)

        for path, data in pending_writes.items():
            current = path.read_bytes() if path.exists() else None
            if current == data:
                continue
            original_metadata.append((path, current))
            make_backup(path)
            atomic_write(path, data)

        check_zone = load_json(target / "Data/Zone" / f"{ZONE_ID}.json")
        check_index = load_json(target / "Data/Zone/index.idx")
        if check_zone["Object"].get("GroundMaps") != ground_ids:
            raise ValueError("Vérification après écriture : la zone n'énumère pas tous les Grounds.")
        if check_index["Object"].get(ZONE_ID, {}).get("Grounds") != ground_ids:
            raise ValueError("Vérification après écriture : index de zone incomplet.")
    except Exception:
        for path in reversed(created):
            path.unlink(missing_ok=True)
        for path, old_data in reversed(original_metadata):
            if old_data is None:
                path.unlink(missing_ok=True)
            else:
                atomic_write(path, old_data)
        raise
    finally:
        for path in temporary_files:
            path.unlink(missing_ok=True)

    print(f"Installation terminée : {len(source_grounds)} Grounds ajoutés/confirmés dans {target}.")
    print(f"Zone développeur prête : {ZONE_ID} ({len(ground_ids)} maps), sans transition narrative.")
    print("Mod.xml, UUID, titre et zones de progression conservés.")
    return {
        "catalogueGrounds": len(source_grounds),
        "groundMapsVisible": len(ground_ids),
        "tilesets": tile_count,
        "filesAdded": len(plan),
        "metadataWrites": len(writes),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("quest", type=Path, help="dossier de la Quest PMDO contenant Mod.xml")
    parser.add_argument("--dry-run", action="store_true", help="vérifier sans écrire")
    args = parser.parse_args()
    try:
        install(Path(__file__).resolve().parent, args.quest, args.dry_run)
    except (OSError, ValueError, ET.ParseError, KeyError, TypeError) as exc:
        parser.exit(1, f"Installation annulée : {exc}\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
