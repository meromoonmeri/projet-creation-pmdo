#!/usr/bin/env python3
"""
Serveur HTTP statique PMDO 0.8.12 + téléchargement fiable à la demande des packages `<MAP_ID>_PMDO_0.8.12.zip` :
  - Sert les assets versionnés (`?v=...`) avec `Cache-Control: public, max-age=3600, immutable`
    afin que les frames d'animation préchargées tournent à 60 FPS sans aucun re-téléchargement.
  - Sert `/download/<MAP_ID>_PMDO_0.8.12.zip` et `/.cache/virtual_zips/<MAP_ID>_PMDO_0.8.12.zip` :
    si le `.zip` virtuel n'est pas encore présent dans `.cache/virtual_zips/` (ex. après réveil du conteneur),
    exécute automatiquement `source.<dossier>.build.build()` à la volée, met l'archive en cache disque,
    et l'envoie avec **un seul** en-tête `Content-Disposition` valide (`0` doublon `ERR_RESPONSE_HEADERS_MULTIPLE_CONTENT_DISPOSITION`).
  - Sert également les 78 `.rsground` autonomes `town02` depuis `TOUTES_MAPS_TOWN02_RSGROUND.zip`.
"""
from __future__ import annotations

import importlib.util
import io
import json
import os
import posixpath
import re
import sys
import threading
import zipfile
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs, unquote, urlsplit

ROOT = Path("/home/user/projet-creation-pmdo")
for _sp in (str(ROOT), str(ROOT / "source")):
    if _sp not in sys.path:
        sys.path.insert(0, _sp)

VZIP_CACHE_DIR = ROOT / ".cache/virtual_zips"
OUT_DIR = ROOT / "livrables_cliff_nord_centre_pmdo"
MASTER_TOWN02_ZIP = (
    OUT_DIR / "TOUTES_MAPS_TOWN02_RSGROUND.zip"
    if (OUT_DIR / "TOUTES_MAPS_TOWN02_RSGROUND.zip").exists()
    else VZIP_CACHE_DIR / "livrables_cliff_nord_centre_pmdo/TOUTES_MAPS_TOWN02_RSGROUND.zip"
)
PACK_ZIP = OUT_DIR / "PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip"
FORCE_DOWNLOAD_EXTS = (".rsground", ".tile", ".dir", ".idx", ".zip")

_MOD_CACHE: dict[str, bytes] = {}
_MOD_LOCK = threading.Lock()
_MAP_FOLDER_INDEX: dict[str, str] | None = None
_BUILD_LOCKS: dict[str, threading.Lock] = {}
_INDEX_LOCK = threading.Lock()


def _discover_map_folders() -> dict[str, str]:
    """Construit l'index `MAP_ID -> nom_dossier_source` depuis `renders/*/metadata.json` et `source/*/build.py`."""
    global _MAP_FOLDER_INDEX
    with _INDEX_LOCK:
        if _MAP_FOLDER_INDEX is not None:
            return _MAP_FOLDER_INDEX
        mapping: dict[str, str] = {}
        renders_root = ROOT / "renders"
        if renders_root.is_dir():
            for meta_p in sorted(renders_root.glob("*/metadata.json")):
                folder = meta_p.parent.name
                if (ROOT / "source" / folder / "build.py").is_file():
                    try:
                        data = json.loads(meta_p.read_text(encoding="utf-8"))
                        mid = str(data.get("map_id", "")).strip()
                        if mid:
                            mapping[mid.upper()] = folder
                    except Exception:
                        pass
        src_root = ROOT / "source"
        if src_root.is_dir():
            pat = re.compile(r'^\s*MAP_ID\s*=\s*["\']([A-Za-z0-9_]+)["\']', re.MULTILINE)
            for bp in sorted(src_root.glob("*/build.py")):
                try:
                    m = pat.search(bp.read_text(encoding="utf-8", errors="ignore"))
                    if m:
                        mapping.setdefault(m.group(1).upper(), bp.parent.name)
                except Exception:
                    pass
        _MAP_FOLDER_INDEX = mapping
        return mapping


def _ensure_map_virtual_zip(map_id: str) -> Path | None:
    """Garantit l'existence sur disque d'une archive ZIP PMDO valide `<MAP_ID>_PMDO_0.8.12.zip`."""
    mid = map_id.strip().upper()
    VZIP_CACHE_DIR.mkdir(parents=True, exist_ok=True)
    target_zip = VZIP_CACHE_DIR / f"{mid}_PMDO_0.8.12.zip"
    if target_zip.is_file() and target_zip.stat().st_size > 256 and zipfile.is_zipfile(target_zip):
        return target_zip

    mapping = _discover_map_folders()
    folder = mapping.get(mid)
    if not folder:
        # Force un rafraîchissement de l'index au cas où une nouvelle map vient d'être créée
        global _MAP_FOLDER_INDEX
        with _INDEX_LOCK:
            _MAP_FOLDER_INDEX = None
        folder = _discover_map_folders().get(mid)
    if not folder:
        return None

    with _INDEX_LOCK:
        lock = _BUILD_LOCKS.setdefault(mid, threading.Lock())

    with lock:
        if target_zip.is_file() and target_zip.stat().st_size > 256 and zipfile.is_zipfile(target_zip):
            return target_zip
        build_path = ROOT / "source" / folder / "build.py"
        if not build_path.is_file():
            return None
        spec = importlib.util.spec_from_file_location(f"pmdo_dl_{folder}", build_path)
        if spec is None or spec.loader is None:
            return None
        mod = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(mod)
        mod.build()
        if target_zip.is_file() and target_zip.stat().st_size > 256 and zipfile.is_zipfile(target_zip):
            return target_zip
    return None


def _send_blob(
    handler: SimpleHTTPRequestHandler,
    payload: bytes,
    fname: str,
    send_body: bool,
    ctype: str = "application/octet-stream",
    as_attachment: bool = True,
) -> None:
    handler._skip_auto_headers = True  # type: ignore[attr-defined]
    handler.send_response(200)
    handler.send_header("Content-Type", ctype)
    handler.send_header("Content-Length", str(len(payload)))
    handler.send_header("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0")
    handler.send_header("Pragma", "no-cache")
    handler.send_header("Expires", "0")
    handler.send_header("Access-Control-Allow-Origin", "*")
    handler.send_header("Access-Control-Expose-Headers", "Content-Disposition, Content-Length")
    if as_attachment:
        safe = fname.replace('"', "")
        handler.send_header("Content-Disposition", f'attachment; filename="{safe}"')
    handler.end_headers()
    if send_body:
        handler.wfile.write(payload)


def _build_single_cliff_mod_zip(slug: str) -> bytes | None:
    if not MASTER_TOWN02_ZIP.exists():
        return None
    with _MOD_LOCK:
        if slug in _MOD_CACHE:
            return _MOD_CACHE[slug]
        with zipfile.ZipFile(MASTER_TOWN02_ZIP, "r") as zin:
            names = set(zin.namelist())
            rsg_prefix = f"Data/Ground/cliff_centre_{slug}_"
            matched = sorted(n for n in names if n.startswith(rsg_prefix) and n.endswith(".rsground"))
            if not matched:
                return None
            buf = io.BytesIO()
            with zipfile.ZipFile(buf, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=6) as zout:
                if "LISEZ_MOI_IMPORTANT_TOWN02.md" in names:
                    zout.writestr("LISEZ_MOI_IMPORTANT_TOWN02.md", zin.read("LISEZ_MOI_IMPORTANT_TOWN02.md"))
                for fn in matched:
                    zout.writestr(fn, zin.read(fn))
            data = buf.getvalue()
            _MOD_CACHE[slug] = data
            return data


class NoCachePMDOHandler(SimpleHTTPRequestHandler):
    def _try_virtual_deliverable(self, send_body: bool) -> bool:
        parts = urlsplit(self.path)
        clean_path = unquote(parts.path).lstrip("/")

        if clean_path == "":
            return False

        # Kit clé-en-main d'assemblage du dépôt unifié « PROJET PMD » façon Halcyon / `town02`
        if base_fname := posixpath.basename(clean_path):
            if base_fname in (
                "KIT_PROJET_PMD_HALCYON_TOWN02.zip",
                "KIT_CONSOLIDATION_UNIFIEE_TOWN02.zip",
            ):
                kit_dir = ROOT / "source" / "consolidation_unifiee_town02"
                gth_dir = ROOT / "source" / "guilde_treehouse_halcyon_v1"
                buf = io.BytesIO()
                with zipfile.ZipFile(buf, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=6) as zout:
                    for fn in (
                        "CREER_PROJET_PMD.sh",
                        "CREER_REPO_UNIFIE_TOWN02.sh",
                        "assembler_repo_unifie_town02.py",
                        "CATALOGUE_UNIFIE_TOWN02.md",
                        "manifeste_complet_toutes_branches.json",
                        "test_consolidation_town02.py",
                    ):
                        fp = kit_dir / fn
                        if fp.is_file():
                            zout.write(fp, arcname=f"PROJET_PMD_KIT/{fn}")
                    for fn in ("build.py", "test_build.py"):
                        fp = gth_dir / fn
                        if fp.is_file():
                            zout.write(fp, arcname=f"PROJET_PMD_KIT/guilde_treehouse_halcyon_v1/{fn}")
                _send_blob(
                    self,
                    buf.getvalue(),
                    base_fname,
                    send_body,
                    ctype="application/zip",
                    as_attachment=True,
                )
                return True

        # A) Route dédiée `/download/<MAP_ID>_PMDO_0.8.12.zip` ou `/.cache/virtual_zips/<MAP_ID>_PMDO_0.8.12.zip`
        base_fname = posixpath.basename(clean_path)
        if base_fname.endswith("_PMDO_0.8.12.zip") and (
            clean_path.startswith("download/")
            or clean_path.startswith(".cache/virtual_zips/")
            or clean_path == base_fname
        ):
            map_id = base_fname[: -len("_PMDO_0.8.12.zip")]
            vzip_path = _ensure_map_virtual_zip(map_id)
            if vzip_path is not None and vzip_path.is_file():
                _send_blob(
                    self,
                    vzip_path.read_bytes(),
                    base_fname,
                    send_body,
                    ctype="application/zip",
                    as_attachment=True,
                )
                return True

        # B) Autres archives `.zip` virtuelles présentes dans `.cache/virtual_zips/`
        if clean_path.endswith(".zip"):
            direct_file = ROOT / clean_path
            if direct_file.is_file() and zipfile.is_zipfile(direct_file):
                _send_blob(self, direct_file.read_bytes(), base_fname, send_body, ctype="application/zip", as_attachment=True)
                return True
            rel_inside_cache = (
                clean_path[len(".cache/virtual_zips/") :]
                if clean_path.startswith(".cache/virtual_zips/")
                else clean_path
            )
            cached_zip = VZIP_CACHE_DIR / rel_inside_cache
            if cached_zip.is_file() and zipfile.is_zipfile(cached_zip):
                _send_blob(self, cached_zip.read_bytes(), base_fname, send_body, ctype="application/zip", as_attachment=True)
                return True

        # 0) Inventaire JSON en direct des 78 cartes `.rsground` compatibles `town02`
        if clean_path.endswith("api_town02_grounds.json") and MASTER_TOWN02_ZIP.exists():
            with zipfile.ZipFile(MASTER_TOWN02_ZIP, "r") as zf:
                entries = [
                    {"name": posixpath.basename(i.filename), "size_bytes": i.file_size}
                    for i in sorted(zf.infolist(), key=lambda x: x.filename)
                    if i.filename.endswith(".rsground")
                ]
            payload = json.dumps({"count": len(entries), "grounds": entries}, ensure_ascii=False).encode("utf-8")
            _send_blob(self, payload, "api_town02_grounds.json", send_body, ctype="application/json; charset=utf-8", as_attachment=False)
            return True

        # 1) Streaming direct de N'IMPORTE LEQUEL des 78 fichiers `.rsground` depuis `TOUTES_MAPS_TOWN02_RSGROUND.zip`
        if clean_path.endswith(".rsground") and MASTER_TOWN02_ZIP.exists():
            fname = posixpath.basename(clean_path)
            target = f"Data/Ground/{fname}"
            with zipfile.ZipFile(MASTER_TOWN02_ZIP, "r") as zf:
                if target in zf.namelist():
                    _send_blob(self, zf.read(target), fname, send_body)
                    return True

        # 2) Pack 40 falaises `PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip` assemblé à la volée
        if clean_path == "livrables_cliff_nord_centre_pmdo/PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip" and not PACK_ZIP.is_file() and MASTER_TOWN02_ZIP.exists():
            with _MOD_LOCK:
                payload = _MOD_CACHE.get("__PACK40__")
                if payload is None:
                    buf = io.BytesIO()
                    with zipfile.ZipFile(MASTER_TOWN02_ZIP, "r") as zin, zipfile.ZipFile(
                        buf, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=6
                    ) as zout:
                        if "LISEZ_MOI_IMPORTANT_TOWN02.md" in zin.namelist():
                            zout.writestr("LISEZ_MOI_IMPORTANT_TOWN02.md", zin.read("LISEZ_MOI_IMPORTANT_TOWN02.md"))
                        for n in sorted(zin.namelist()):
                            if n.startswith("Data/Ground/cliff_centre_") and n.endswith(".rsground"):
                                zout.writestr(n, zin.read(n))
                    payload = buf.getvalue()
                    _MOD_CACHE["__PACK40__"] = payload
            _send_blob(self, payload, "PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip", send_body, ctype="application/zip")
            return True

        # 3) Pack 4 ambiances d'une falaise `MOD_<slug>_PMDO_0812.zip`
        if clean_path.startswith("livrables_cliff_nord_centre_pmdo/mods_individuels/MOD_") and clean_path.endswith(
            "_PMDO_0812.zip"
        ):
            fname = posixpath.basename(clean_path)
            slug = fname[len("MOD_") : -len("_PMDO_0812.zip")]
            payload = _build_single_cliff_mod_zip(slug)
            if payload is not None:
                _send_blob(self, payload, fname, send_body, ctype="application/zip")
                return True

        return False

    def do_HEAD(self) -> None:
        if not self._try_virtual_deliverable(send_body=False):
            super().do_HEAD()

    def do_GET(self) -> None:
        if not self._try_virtual_deliverable(send_body=True):
            super().do_GET()

    def end_headers(self) -> None:
        if getattr(self, "_skip_auto_headers", False):
            self._skip_auto_headers = False
            super().end_headers()
            return
        parts = urlsplit(self.path)
        qs = parse_qs(parts.query)
        if "v" in qs and "dl" not in qs:
            self.send_header("Cache-Control", "public, max-age=3600, immutable")
        else:
            self.send_header("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0")
            self.send_header("Pragma", "no-cache")
            self.send_header("Expires", "0")
        self.send_header("Access-Control-Allow-Origin", "*")
        clean_path = unquote(parts.path)
        fname = posixpath.basename(clean_path)
        if fname and ("dl" in qs or fname.lower().endswith(FORCE_DOWNLOAD_EXTS)):
            safe = fname.replace('"', "")
            self.send_header("Content-Disposition", f'attachment; filename="{safe}"')
        super().end_headers()

    def log_message(self, fmt: str, *args) -> None:
        pass


def main() -> None:
    os.chdir(str(ROOT))
    server = ThreadingHTTPServer(("0.0.0.0", 8000), NoCachePMDOHandler)
    print(
        "Serving /home/user/projet-creation-pmdo on http://0.0.0.0:8000 (Studio PMDO 60 FPS + /download/<MAP_ID>_PMDO_0.8.12.zip)",
        flush=True,
    )
    server.serve_forever()


if __name__ == "__main__":
    main()
