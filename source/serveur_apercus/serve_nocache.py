#!/usr/bin/env python3
"""
Serveur HTTP statique PMDO 0.8.12 + streaming direct des **78 `.rsground` 100 % natifs `meromoonmeri/town02`** :
  - Sert les assets versionnés (`?v=...`) avec `Cache-Control: public, max-age=3600, immutable`
    afin que les frames d'animation préchargées tournent à 60 FPS sans aucun re-téléchargement.
  - Sert à la volée **n'importe lequel des 78 fichiers `.rsground` autonomes `town02`**
    (`40` `cliff_centre_*` + `13` `guilde_vide_* & cliff_north` + `5` `metano_gen_*`
     + `4` `cliffdaytest[_nuit] & cliffnordouesttest1[_nuit]` + `16` `palette_*`)
    depuis `TOUTES_MAPS_TOWN02_RSGROUND.zip` (zéro `.tile` externe requis, zéro `.dir` externe requis !).
  - Sert `/livrables_cliff_nord_centre_pmdo/api_town02_grounds.json` (inventaire complet des 78 `.rsground`).
  - Sert aussi à la volée les 10 Mods autonomes 4 ambiances `MOD_<slug>_PMDO_0812.zip`.
"""
from __future__ import annotations

import io
import json
import os
import posixpath
import threading
import zipfile
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs, unquote, urlsplit

ROOT = Path("/home/user/projet-creation-pmdo")
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


def _send_blob(
    handler: SimpleHTTPRequestHandler,
    payload: bytes,
    fname: str,
    send_body: bool,
    ctype: str = "application/octet-stream",
    as_attachment: bool = True,
) -> None:
    handler.send_response(200)
    handler.send_header("Content-Type", ctype)
    handler.send_header("Content-Length", str(len(payload)))
    handler.send_header("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0")
    handler.send_header("Access-Control-Allow-Origin", "*")
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

        cached_zip = VZIP_CACHE_DIR / clean_path
        if clean_path.endswith(".zip") and not (ROOT / clean_path).is_file():
            if cached_zip.is_file():
                _send_blob(self, cached_zip.read_bytes(), posixpath.basename(clean_path), send_body)
                return True
            parent_dir = (ROOT / clean_path).parent
            if parent_dir.is_dir() and parent_dir != ROOT:
                buf = io.BytesIO()
                with zipfile.ZipFile(buf, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=6) as zout:
                    for fp in sorted(parent_dir.rglob("*")):
                        if fp.is_file() and fp.suffix.lower() != ".zip":
                            zout.writestr(fp.relative_to(parent_dir).as_posix(), fp.read_bytes())
                _send_blob(self, buf.getvalue(), posixpath.basename(clean_path), send_body)
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

        # 2) Pack 40 falaises `PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip` assemblé à la volée depuis `TOUTES_MAPS_TOWN02_RSGROUND.zip`
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
            _send_blob(self, payload, "PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip", send_body)
            return True

        # 3) Pack 4 ambiances d'une falaise `MOD_<slug>_PMDO_0812.zip` (pur `.rsground` town02 !)
        if clean_path.startswith("livrables_cliff_nord_centre_pmdo/mods_individuels/MOD_") and clean_path.endswith(
            "_PMDO_0812.zip"
        ):
            fname = posixpath.basename(clean_path)
            slug = fname[len("MOD_") : -len("_PMDO_0812.zip")]
            payload = _build_single_cliff_mod_zip(slug)
            if payload is not None:
                _send_blob(self, payload, fname, send_body)
                return True

        return False

    def do_HEAD(self) -> None:
        if not self._try_virtual_deliverable(send_body=False):
            super().do_HEAD()

    def do_GET(self) -> None:
        if not self._try_virtual_deliverable(send_body=True):
            super().do_GET()

    def end_headers(self) -> None:
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
        "Serving /home/user/projet-creation-pmdo on http://0.0.0.0:8000 (78 .rsground 100 % natifs town02)",
        flush=True,
    )
    server.serve_forever()


if __name__ == "__main__":
    main()
