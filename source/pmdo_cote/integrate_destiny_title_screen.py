#!/usr/bin/env python3
"""Integrate the namespaced PMD Destiny title-screen component into a Destiny Quest.

The component intentionally contains no Mod.xml. Integration preserves the
stable Destiny identity and refuses different-content file collisions. The
service/assets are renamed to the `destiny` target namespace; no Halcyon Quest
identity is used. This validates resource structure and hashes, not rendering
or gameplay in PMDO.
"""
from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import struct
import tempfile
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[2]
COMPONENT_ROOT = ROOT / "source/pmdo_cote/destiny_title_screen_component"

QUEST_NAMESPACE = "destiny"
QUEST_UUID = "1da28568-6363-5c51-8caa-9430b42862f0"
GAME_VERSION = "0.8.12.0"
TITLE_BG = "Destiny_Title_Screen_Background"
TITLE_BGM = "Top Menu Theme.ogg"
OPENING_ASSET = "Destiny_Logo_Anime_Opening"
REPORT_RELATIVE = Path("Documentation/DESTINY_TITLE_SCREEN.json")
COMPONENT_MANIFEST_RELATIVE = Path("Documentation/destiny_title_screen_manifest.json")
QUEST_BUILD_RELATIVE = Path("Documentation/QUEST_BUILD.json")
README_RELATIVE = Path("README.md")

EXPECTED_COMPONENT_FILES = {
    "Content/ContentParams.xml",
    "Content/BG/Destiny_Title_Screen_Background.dir",
    "Content/BG/Destiny_Title_Screen_Background_Jour.dir",
    "Content/BG/Destiny_Title_Screen_Background_Nuit.dir",
    "Content/Obj/Destiny_Logo_Anime_Opening.dir",
    "Content/UI/Title.png",
    "Content/UI/Enter.png",
    "Data/Script/destiny/services/destiny_title_anim/init.lua",
}


def _sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def _read_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def _png_dimensions(data: bytes, label: str) -> tuple[int, int]:
    if len(data) < 24 or data[:8] != b"\x89PNG\r\n\x1a\n" or data[12:16] != b"IHDR":
        raise ValueError(f"PNG invalide ou tronqué : {label}")
    width, height = struct.unpack_from(">II", data, 16)
    if width <= 0 or height <= 0:
        raise ValueError(f"Dimensions PNG invalides : {label}")
    return width, height


def _dir_header(data: bytes, label: str) -> dict:
    """Validate the PMDO DirSheet envelope and its embedded PNG dimensions."""
    if len(data) < 24:
        raise ValueError(f"DirSheet tronqué : {label}")
    png_length, = struct.unpack_from("<q", data, 0)
    if png_length <= 0:
        raise ValueError(f"Taille PNG DirSheet invalide : {label}")
    png_end = 8 + png_length
    if png_end + 16 != len(data):
        raise ValueError(f"Longueur DirSheet incohérente : {label}")
    width, height = _png_dimensions(data[8:png_end], label)
    tile_width, tile_height, rotate_type, frames = struct.unpack_from("<iiii", data, png_end)
    if tile_width <= 0 or tile_height <= 0 or frames <= 0:
        raise ValueError(f"Métadonnées DirSheet invalides : {label}")
    if width % tile_width or height % tile_height:
        raise ValueError(f"Atlas DirSheet non divisible par le frame : {label}")
    if (width // tile_width) * (height // tile_height) < frames:
        raise ValueError(f"Atlas DirSheet trop petit pour ses frames : {label}")
    return {
        "atlasWidth": width,
        "atlasHeight": height,
        "tileWidth": tile_width,
        "tileHeight": tile_height,
        "rotateType": rotate_type,
        "frames": frames,
    }


def _safe_component_path(relative: str) -> PurePosixPath:
    path = PurePosixPath(relative)
    if path.is_absolute() or ".." in path.parts or not path.parts:
        raise ValueError(f"Chemin du composant invalide : {relative}")
    if path.as_posix() != relative:
        raise ValueError(f"Chemin non canonique dans le composant : {relative}")
    if path.name.casefold() == "mod.xml":
        raise ValueError("Le composant d’écran-titre ne peut pas fournir de Mod.xml.")
    return path


def validate_component(component_root: Path = COMPONENT_ROOT) -> dict:
    component_root = Path(component_root).resolve()
    manifest_path = component_root / "manifest.json"
    if not manifest_path.is_file():
        raise FileNotFoundError(f"Manifeste de l’écran-titre absent : {manifest_path}")
    manifest = _read_json(manifest_path)
    if manifest.get("schemaVersion") != 1 or manifest.get("packageType") != "quest-component-not-standalone":
        raise ValueError("Type/version du composant d’écran-titre invalide.")
    target = manifest.get("target", {})
    if (target.get("namespace"), target.get("uuid"), target.get("gameVersion"), target.get("modType")) != (
        QUEST_NAMESPACE, QUEST_UUID, GAME_VERSION, "Quest"
    ):
        raise ValueError("Le manifeste du composant ne cible pas l’identité Destiny stable attendue.")
    if manifest.get("source", {}).get("targetModXmlIncluded") is not False:
        raise ValueError("Le composant ne doit jamais fournir/remplacer Mod.xml.")

    rows = manifest.get("files")
    if not isinstance(rows, list):
        raise ValueError("Liste de fichiers du composant invalide.")
    files: dict[str, bytes] = {}
    declared_paths: set[str] = set()
    for row in rows:
        relative = row.get("path")
        digest = row.get("sha256")
        expected_bytes = row.get("bytes")
        if not isinstance(relative, str) or not isinstance(digest, str) or not isinstance(expected_bytes, int):
            raise ValueError("Entrée de fichier incomplète dans le manifeste du composant.")
        path = _safe_component_path(relative)
        if relative in declared_paths:
            raise ValueError(f"Fichier répété dans le manifeste du composant : {relative}")
        declared_paths.add(relative)
        source = component_root.joinpath(*path.parts)
        if not source.is_file():
            raise FileNotFoundError(f"Fichier du composant absent : {source}")
        data = source.read_bytes()
        if len(data) != expected_bytes or _sha256(data) != digest:
            raise ValueError(f"SHA-256/taille du composant invalide : {relative}")
        files[relative] = data
    if declared_paths != EXPECTED_COMPONENT_FILES:
        raise ValueError(
            f"Le composant contient {len(declared_paths)} chemins différents de la liste attendue "
            f"({len(EXPECTED_COMPONENT_FILES)})."
        )

    params = ET.fromstring(files["Content/ContentParams.xml"])
    if (params.findtext("TitleBG") or "").strip() != TITLE_BG:
        raise ValueError("ContentParams.xml ne référence pas le fond Destiny unique.")
    if (params.findtext("TitleBGM") or "").strip() != TITLE_BGM:
        raise ValueError("La musique de menu attendue du PMDO de base n’est pas référencée.")

    dir_paths = (
        "Content/BG/Destiny_Title_Screen_Background.dir",
        "Content/BG/Destiny_Title_Screen_Background_Jour.dir",
        "Content/BG/Destiny_Title_Screen_Background_Nuit.dir",
        "Content/Obj/Destiny_Logo_Anime_Opening.dir",
    )
    dir_info = {relative: _dir_header(files[relative], relative) for relative in dir_paths}
    if files["Content/BG/Destiny_Title_Screen_Background.dir"] != files[
        "Content/BG/Destiny_Title_Screen_Background_Jour.dir"
    ]:
        raise ValueError("L’alias par défaut doit être strictement identique au fond Jour.")
    for relative, info in dir_info.items():
        if (info["tileWidth"], info["tileHeight"], info["rotateType"], info["frames"]) != (320, 240, 0, 24):
            raise ValueError(f"Format/timing DirSheet inattendu : {relative}")

    ui_sizes = {
        "Content/UI/Title.png": (320, 240),
        "Content/UI/Enter.png": (74, 11),
    }
    for relative, expected in ui_sizes.items():
        if _png_dimensions(files[relative], relative) != expected:
            raise ValueError(f"Dimensions UI incorrectes pour {relative}")

    service_path = "Data/Script/destiny/services/destiny_title_anim/init.lua"
    service = files[service_path].decode("utf-8")
    for token in (
        "Destiny_Title_Screen_Background_Jour",
        "Destiny_Title_Screen_Background_Nuit",
        OPENING_ASSET,
        "EngineServiceEvents.AddMenu",
    ):
        if token not in service:
            raise ValueError(f"Service d’écran-titre : référence absente {token!r}")
    stale_resource_literals = (
        "'Title_Screen_Background_Jour'",
        '"Title_Screen_Background_Jour"',
        "'Title_Screen_Background_Nuit'",
        '"Title_Screen_Background_Nuit"',
    )
    for stale in stale_resource_literals:
        if stale in service:
            raise ValueError(f"Référence d’asset source non renommée : {stale}")
    if "halcyon" in service.casefold():
        raise ValueError("Le service d’écran-titre conserve une référence de namespace Halcyon.")

    return {
        "manifest": manifest,
        "manifestSha256": _sha256(manifest_path.read_bytes()),
        "files": files,
        "dirSheets": dir_info,
        "uiDimensions": {key: list(value) for key, value in ui_sizes.items()},
    }


def _quest_identity(quest: Path) -> tuple[ET.Element, bytes, dict]:
    mod_path = quest / "Mod.xml"
    if not mod_path.is_file():
        raise ValueError("Quest cible invalide : Mod.xml absent.")
    raw = mod_path.read_bytes()
    root = ET.fromstring(raw)
    identity = {
        "name": (root.findtext("Name") or "").strip(),
        "namespace": (root.findtext("Namespace") or "").strip(),
        "uuid": (root.findtext("UUID") or "").strip().lower(),
        "gameVersion": (root.findtext("GameVersion") or "").strip(),
        "modType": (root.findtext("ModType") or "").strip(),
        "modXmlSha256": _sha256(raw),
    }
    expected = (QUEST_NAMESPACE, QUEST_UUID, GAME_VERSION, "quest")
    actual = (identity["namespace"], identity["uuid"], identity["gameVersion"], identity["modType"].casefold())
    if actual != expected:
        raise ValueError(
            "Mod.xml cible refusé : identité attendue namespace destiny, UUID stable "
            f"{QUEST_UUID}, PMDO {GAME_VERSION}, Quest; reçu {actual}."
        )
    return root, raw, identity


def _merge_content_params(existing: bytes | None, source: bytes) -> tuple[bytes, str | None]:
    source_root = ET.fromstring(source)
    if (source_root.findtext("TitleBG") or "").strip() != TITLE_BG:
        raise ValueError("ContentParams.xml du composant ne contient pas le TitleBG Destiny attendu.")
    if existing is None:
        return source, None

    target_root = ET.fromstring(existing)
    if target_root.tag != source_root.tag:
        raise ValueError("ContentParams.xml cible et composant ont des racines incompatibles.")
    if target_root.tag.startswith("{"):
        raise ValueError("ContentParams.xml cible utilise un namespace XML; fusion conservatrice refusée.")
    title_nodes = [child for child in target_root if child.tag == "TitleBG"]
    if len(title_nodes) > 1:
        raise ValueError("ContentParams.xml cible contient plusieurs TitleBG; fusion refusée.")
    if title_nodes and list(title_nodes[0]):
        raise ValueError("TitleBG contient des éléments enfants inattendus; fusion refusée.")

    # Preserve the original XML bytes outside the one TitleBG element. This
    # retains comments, whitespace, unknown settings, ordering, declaration and BOM.
    has_utf8_bom = existing.startswith(b"\xef\xbb\xbf")
    try:
        text = existing.decode("utf-8-sig" if has_utf8_bom else "utf-8")
    except UnicodeDecodeError as exc:
        raise ValueError("ContentParams.xml cible doit être en UTF-8 pour préserver ses octets hors TitleBG.") from exc
    prefix = b"\xef\xbb\xbf" if has_utf8_bom else b""
    newline = "\r\n" if "\r\n" in text else "\n"

    def openings(tag: str, closing: bool = False) -> list[int]:
        token = f"</{tag}" if closing else f"<{tag}"
        result: list[int] = []
        offset = 0
        while True:
            position = text.find(token, offset)
            if position < 0:
                return result
            boundary = position + len(token)
            if boundary < len(text) and (text[boundary] == ">" or text[boundary].isspace()):
                result.append(position)
            offset = boundary

    if title_nodes:
        old_title_bg = (title_nodes[0].text or "").strip()
        tag_starts = openings("TitleBG")
        tag_closes = openings("TitleBG", closing=True)
        if len(tag_starts) != 1 or len(tag_closes) != 1:
            raise ValueError("Impossible d’isoler l’unique balise TitleBG sans réécrire le XML cible.")
        open_start = tag_starts[0]
        open_end = text.find(">", open_start) + 1
        close_start = tag_closes[0]
        close_end = text.find(">", close_start) + 1
        if open_end <= open_start or close_end <= close_start or close_start < open_end:
            raise ValueError("Balise TitleBG mal formée; fusion refusée.")
        inner = text[open_end:close_start]
        if "<" in inner or ">" in inner:
            raise ValueError("TitleBG cible contient du markup inattendu; fusion refusée.")
        if old_title_bg == TITLE_BG:
            return existing, old_title_bg

        leading_count = 0
        while leading_count < len(inner) and inner[leading_count].isspace():
            leading_count += 1
        trailing_count = 0
        while trailing_count < len(inner) - leading_count and inner[len(inner) - 1 - trailing_count].isspace():
            trailing_count += 1
        suffix = inner[len(inner) - trailing_count:] if trailing_count else ""
        replacement = inner[:leading_count] + TITLE_BG + suffix
        text = text[:open_end] + replacement + text[close_start:]
    else:
        root_name = target_root.tag
        closing_token = f"</{root_name}"
        close_positions = []
        offset = 0
        while True:
            position = text.find(closing_token, offset)
            if position < 0:
                break
            boundary = position + len(closing_token)
            if boundary < len(text) and (text[boundary] == ">" or text[boundary].isspace()):
                close_positions.append(position)
            offset = boundary
        if len(close_positions) != 1:
            raise ValueError("Impossible d’insérer TitleBG dans la racine ContentParams.xml sans réécriture.")
        close_start = close_positions[0]
        line_start = text.rfind("\n", 0, close_start) + 1
        prefix_on_line = text[line_start:close_start]
        if prefix_on_line.strip() == "":
            insertion = f"<TitleBG>{TITLE_BG}</TitleBG>{newline}"
        else:
            insertion = f"<TitleBG>{TITLE_BG}</TitleBG>"
        text = text[:close_start] + insertion + text[close_start:]
        old_title_bg = None

    result = prefix + text.encode("utf-8")
    result_root = ET.fromstring(result)
    if (result_root.findtext("TitleBG") or "").strip() != TITLE_BG:
        raise ValueError("TitleBG Destiny absent du ContentParams.xml fusionné.")
    return result, old_title_bg

def _atomic_write(path: Path, data: bytes) -> None:
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


def integrate_destiny_title_screen(
    quest_dir: Path,
    component_root: Path = COMPONENT_ROOT,
) -> dict:
    """Copy the component into a stable-identity Destiny Quest, idempotently.

    Different-content conflicts fail before any write; Mod.xml is read-only and
    its exact bytes are checked again after integration.
    """
    quest = Path(quest_dir).resolve()
    if not quest.is_dir():
        raise FileNotFoundError(f"Dossier de quête absent : {quest}")
    component = validate_component(Path(component_root))
    _mod_root, mod_bytes_before, identity = _quest_identity(quest)

    files: dict[str, bytes] = component["files"]
    pending: dict[Path, bytes] = {}
    for relative, data in files.items():
        target = quest.joinpath(*PurePosixPath(relative).parts)
        if relative == "Content/ContentParams.xml":
            current = target.read_bytes() if target.is_file() else None
            merged, old_title_bg = _merge_content_params(current, data)
            if current != merged:
                pending[target] = merged
        else:
            if target.exists():
                if not target.is_file() or target.read_bytes() != data:
                    raise ValueError(f"Conflit de ressource Destiny, contenu différent : {relative}")
            else:
                pending[target] = data

    params_path = quest / "Content/ContentParams.xml"
    params_after = pending.get(params_path, params_path.read_bytes() if params_path.is_file() else files[
        "Content/ContentParams.xml"
    ])
    title_bg_after = (ET.fromstring(params_after).findtext("TitleBG") or "").strip()
    if title_bg_after != TITLE_BG:
        raise ValueError("ContentParams.xml fusionné ne pointe pas sur le fond Destiny.")
    if params_path.is_file():
        title_bg_before = (ET.fromstring(params_path.read_bytes()).findtext("TitleBG") or "").strip() or None
    else:
        title_bg_before = None

    final_file_hashes = {}
    for relative in sorted(files):
        if relative == "Content/ContentParams.xml":
            data = params_after
        else:
            data = files[relative]
        final_file_hashes[relative] = {"bytes": len(data), "sha256": _sha256(data)}

    component_manifest_data = (Path(component_root).resolve() / "manifest.json").read_bytes()
    component_manifest_path = quest / COMPONENT_MANIFEST_RELATIVE
    if component_manifest_path.exists():
        if not component_manifest_path.is_file() or component_manifest_path.read_bytes() != component_manifest_data:
            raise ValueError("Conflit avec un manifeste de provenance d’écran-titre déjà présent.")
    else:
        pending[component_manifest_path] = component_manifest_data

    report_path = quest / REPORT_RELATIVE
    prior_report = _read_json(report_path) if report_path.is_file() else None
    if prior_report is not None and prior_report.get("componentId") != "destiny_title_screen_0812":
        raise ValueError("Le rapport d’écran-titre existant appartient à un autre composant.")
    report_title_bg_before = (
        prior_report.get("titleBg", {}).get("before", title_bg_before)
        if prior_report is not None else title_bg_before
    )

    report = {
        "schemaVersion": 1,
        "componentId": "destiny_title_screen_0812",
        "integrated": True,
        "target": identity,
        "targetModXmlPreservedByteForByte": True,
        "componentManifestSha256": component["manifestSha256"],
        "sourceManifestMember": COMPONENT_MANIFEST_RELATIVE.as_posix(),
        "sourceCommit": component["manifest"]["source"]["commit"],
        "titleBg": {
            "before": report_title_bg_before,
            "after": title_bg_after,
            "resource": TITLE_BG,
        },
        "assets": final_file_hashes,
        "staticValidation": "PASS",
        "runtimeTested": False,
        "pmdoTitleScreenRendered": False,
        "narrativeOrGroundChanges": False,
        "note": "Component intégré, mais le rendu du TopMenu et le chargement du service restent à tester dans PMDO.",
    }
    report_data = (json.dumps(report, ensure_ascii=False, indent=2) + "\n").encode("utf-8")
    if not report_path.is_file() or report_path.read_bytes() != report_data:
        pending[report_path] = report_data

    readme_path = quest / README_RELATIVE
    if readme_path.is_file():
        readme = readme_path.read_text(encoding="utf-8")
        marker = "## Écran-titre Destiny"
        if marker not in readme:
            readme += (
                "\n## Écran-titre Destiny\n\n"
                "Fonds animés Jour/Nuit (24 poses), logo Destiny et opening du blason intégrés. "
                "Contrôles statiques : `Documentation/DESTINY_TITLE_SCREEN.json`; provenance source : "
                "`Documentation/destiny_title_screen_manifest.json`. Le rendu et le service n’ont pas "
                "encore été testés dans le moteur PMDO.\n"
            )
            pending[readme_path] = readme.encode("utf-8")

    build_path = quest / QUEST_BUILD_RELATIVE
    if build_path.is_file():
        build_doc = _read_json(build_path)
        build_doc["titleScreen"] = {
            "integrated": True,
            "component": "destiny_title_screen_0812",
            "staticValidation": "PASS",
            "runtimeTested": False,
            "pmdoRendered": False,
            "report": "Documentation/DESTINY_TITLE_SCREEN.json",
        }
        build_data = (json.dumps(build_doc, ensure_ascii=False, indent=2) + "\n").encode("utf-8")
        if build_path.read_bytes() != build_data:
            pending[build_path] = build_data

    original: dict[Path, bytes | None] = {}
    written: list[Path] = []
    try:
        for path, data in pending.items():
            original[path] = path.read_bytes() if path.is_file() else None
            _atomic_write(path, data)
            written.append(path)
        mod_bytes_after = (quest / "Mod.xml").read_bytes()
        if mod_bytes_after != mod_bytes_before:
            raise ValueError("L’intégration a modifié Mod.xml; restauration en cours.")
        validate_installed_title_screen(quest, component_root=Path(component_root))
    except Exception:
        for path in reversed(written):
            old = original[path]
            if old is None:
                path.unlink(missing_ok=True)
            else:
                _atomic_write(path, old)
        raise

    return {
        "integrated": True,
        "namespace": identity["namespace"],
        "uuid": identity["uuid"],
        "gameVersion": identity["gameVersion"],
        "filesAddedOrUpdated": len(pending),
        "titleBackground": TITLE_BG,
        "defaultDayNightFrames": 24,
        "openingFrames": 24,
        "staticValidation": "PASS",
        "runtimeTested": False,
        "pmdoRendered": False,
        "modXmlPreservedByteForByte": True,
    }


def validate_installed_title_screen(
    quest_dir: Path,
    component_root: Path = COMPONENT_ROOT,
) -> dict:
    quest = Path(quest_dir).resolve()
    component = validate_component(Path(component_root))
    _mod_root, _mod_bytes, identity = _quest_identity(quest)
    for relative, source_bytes in component["files"].items():
        target = quest.joinpath(*PurePosixPath(relative).parts)
        if not target.is_file():
            raise FileNotFoundError(f"Ressource d’écran-titre non intégrée : {relative}")
        if relative == "Content/ContentParams.xml":
            root = ET.parse(target).getroot()
            if (root.findtext("TitleBG") or "").strip() != TITLE_BG:
                raise ValueError("ContentParams.xml installé n’utilise pas le TitleBG Destiny.")
        elif target.read_bytes() != source_bytes:
            raise ValueError(f"Le contenu installé diffère de la source attestée : {relative}")

    report_path = quest / REPORT_RELATIVE
    if not report_path.is_file():
        raise FileNotFoundError("Rapport d’intégration de l’écran-titre absent.")
    report = _read_json(report_path)
    if report.get("componentId") != "destiny_title_screen_0812" or report.get("integrated") is not True:
        raise ValueError("Rapport d’intégration d’écran-titre invalide.")
    report_target = report.get("target", {})
    if report_target.get("modXmlSha256") != identity["modXmlSha256"]:
        raise ValueError("Le Mod.xml a changé depuis l’intégration de l’écran-titre.")
    if (report_target.get("namespace"), report_target.get("uuid"), report_target.get("gameVersion"),
            report_target.get("modType", "").casefold()) != (
        QUEST_NAMESPACE, QUEST_UUID, GAME_VERSION, "quest"
    ):
        raise ValueError("L’identité du rapport d’écran-titre ne correspond pas à la Quest Destiny.")
    if report.get("componentManifestSha256") != component["manifestSha256"]:
        raise ValueError("Le manifeste source du composant a changé depuis l’intégration.")
    if report.get("sourceManifestMember") != COMPONENT_MANIFEST_RELATIVE.as_posix():
        raise ValueError("Le rapport ne référence pas la copie embarquée du manifeste source.")
    source_manifest_copy = quest / COMPONENT_MANIFEST_RELATIVE
    source_manifest = (Path(component_root).resolve() / "manifest.json").read_bytes()
    if not source_manifest_copy.is_file() or source_manifest_copy.read_bytes() != source_manifest:
        raise ValueError("La provenance source embarquée dans la Quest est absente ou différente.")
    report_assets = report.get("assets", {})
    if set(report_assets) != set(component["files"]):
        raise ValueError("Inventaire d’assets du rapport d’écran-titre incomplet.")
    for relative, metadata in report_assets.items():
        actual = quest.joinpath(*PurePosixPath(relative).parts).read_bytes()
        if len(actual) != metadata.get("bytes") or _sha256(actual) != metadata.get("sha256"):
            raise ValueError(f"L’asset installé diffère du rapport d’intégration : {relative}")
    return {
        "status": "PASS",
        "namespace": identity["namespace"],
        "uuid": identity["uuid"],
        "titleBg": TITLE_BG,
        "resourceFiles": len(component["files"]),
        "modXmlPreservedByteForByte": True,
        "runtimeTested": False,
    }


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("quest", type=Path, help="Dossier de la Quest Destiny avec Mod.xml")
    parser.add_argument("--component", type=Path, default=COMPONENT_ROOT)
    args = parser.parse_args()
    print(json.dumps(
        integrate_destiny_title_screen(args.quest, args.component),
        ensure_ascii=False,
        indent=2,
    ))
