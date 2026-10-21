#!/usr/bin/env python3
"""
Serveur HTTP statique PMDO 0.8.12 + streaming direct des 40 `.rsground` & des 10 Mods autonomes :
  - Sert les assets versionnés (`?v=...`) avec `Cache-Control: public, max-age=3600, immutable`
    afin que les frames d'animation préchargées tournent à 60 FPS sans aucun re-téléchargement.
  - Sert à la volée n'importe lequel des 40 fichiers `.rsground` (`10 falaises × 4 ambiances : jour, aube, crepuscule, nuit`)
    depuis `PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip`, que l'URL soit en racine `livrables_cliff_nord_centre_pmdo/`
    ou sous `livrables_cliff_nord_centre_pmdo/grounds_rsground/`.
  - Sert ou assemble à la volée (avec cache RAM) n'importe lequel des 10 Mods autonomes 4 ambiances
    `livrables_cliff_nord_centre_pmdo/mods_individuels/MOD_<slug>_PMDO_0812.zip`.
"""
from __future__ import annotations

import io
import os
import posixpath
import threading
import zipfile
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs, unquote, urlsplit

ROOT = Path("/home/user/projet-creation-pmdo")
OUT_DIR = ROOT / "livrables_cliff_nord_centre_pmdo"
PACK_ZIP = OUT_DIR / "PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip"
FORCE_DOWNLOAD_EXTS = (".rsground", ".tile", ".dir", ".idx", ".zip")

_MOD_CACHE: dict[str, bytes] = {}
_MOD_LOCK = threading.Lock()


def _send_blob(handler: SimpleHTTPRequestHandler, payload: bytes, fname: str, send_body: bool) -> None:
    handler.send_response(200)
    handler.send_header("Content-Type", "application/octet-stream")
    handler.send_header("Content-Length", str(len(payload)))
    handler.send_header("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0")
    handler.send_header("Access-Control-Allow-Origin", "*")
    safe = fname.replace('"', "")
    handler.send_header("Content-Disposition", f'attachment; filename="{safe}"')
    handler.end_headers()
    if send_body:
        handler.wfile.write(payload)


def _build_single_cliff_mod_zip(slug: str) -> bytes | None:
    if not PACK_ZIP.exists():
        return None
    with _MOD_LOCK:
        if slug in _MOD_CACHE:
            return _MOD_CACHE[slug]
        with zipfile.ZipFile(PACK_ZIP, "r") as zin:
            names = set(zin.namelist())
            rsg_prefix = f"MOD_CLIFF_NORD_CENTRE_PMDO/Data/Ground/cliff_centre_{slug}_"
            matched = [n for n in names if n.startswith(rsg_prefix) and n.endswith(".rsground")]
            if not matched:
                return None
            out_prefix = f"MOD_CLIFF_{slug.upper()}"
            buf = io.BytesIO()
            with zipfile.ZipFile(buf, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=6) as zout:
                for info in zin.infolist():
                    fn = info.filename
                    if any(seg in fn for seg in ("/Content/Tile/", "/Content/BG/")) or fn.endswith(
                        ("/INSTALLER.py", "/Mod.xml")
                    ):
                        rel = fn.split("/", 1)[1]
                        zout.writestr(f"{out_prefix}/{rel}", zin.read(fn))
                    elif fn in matched or f"cliff_centre_{slug}_" in fn:
                        rel = fn.split("/", 1)[1]
                        zout.writestr(f"{out_prefix}/{rel}", zin.read(fn))
            data = buf.getvalue()
            _MOD_CACHE[slug] = data
            return data


class NoCachePMDOHandler(SimpleHTTPRequestHandler):
    def _try_virtual_deliverable(self, send_body: bool) -> bool:
        parts = urlsplit(self.path)
        clean_path = unquote(parts.path).lstrip("/")

        # 1) Streaming direct des 40 fichiers `.rsground` (`jour`, `aube`, `crepuscule`, `nuit`)
        if clean_path.startswith("livrables_cliff_nord_centre_pmdo/") and clean_path.endswith(".rsground"):
            disk_file = ROOT / clean_path
            if disk_file.is_file():
                return False
            fname = posixpath.basename(clean_path)
            target = f"MOD_CLIFF_NORD_CENTRE_PMDO/Data/Ground/{fname}"
            if PACK_ZIP.exists():
                with zipfile.ZipFile(PACK_ZIP, "r") as zf:
                    if target in zf.namelist():
                        _send_blob(self, zf.read(target), fname, send_body)
                        return True

        # 2) Génération à la volée des Mods autonomes 4 ambiances `MOD_<slug>_PMDO_0812.zip`
        if clean_path.startswith("livrables_cliff_nord_centre_pmdo/mods_individuels/MOD_") and clean_path.endswith(
            "_PMDO_0812.zip"
        ):
            disk_file = ROOT / clean_path
            if disk_file.is_file():
                return False
            fname = posixpath.basename(clean_path)
            slug = fname[len("MOD_") : -len("_PMDO_0812.zip")]
            payload = _build_single_cliff_mod_zip(slug)
            if payload is not None:
                _send_blob(self, payload, fname, send_body)
                return True

        # 3) Extraction à la volée de `TILES_ET_CIELS_REQUIS_PMDO_0812.zip` depuis `PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip`
        if clean_path == "livrables_cliff_nord_centre_pmdo/TILES_ET_CIELS_REQUIS_PMDO_0812.zip":
            disk_file = ROOT / clean_path
            if disk_file.is_file():
                return False
            with _MOD_LOCK:
                payload = _MOD_CACHE.get("__DEPS__")
                if payload is None and PACK_ZIP.exists():
                    buf = io.BytesIO()
                    with zipfile.ZipFile(PACK_ZIP, "r") as zin, zipfile.ZipFile(
                        buf, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=6
                    ) as zout:
                        for info in zin.infolist():
                            fn = info.filename
                            if any(seg in fn for seg in ("/Content/Tile/", "/Content/BG/")) or fn.endswith(
                                ("/INSTALLER.py", "/Mod.xml")
                            ):
                                zout.writestr(fn, zin.read(fn))
                    payload = buf.getvalue()
                    _MOD_CACHE["__DEPS__"] = payload
            if payload is not None:
                _send_blob(self, payload, "TILES_ET_CIELS_REQUIS_PMDO_0812.zip", send_body)
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
        "Serving /home/user/projet-creation-pmdo on http://0.0.0.0:8000 (4 ambiances Scène du Réveil + 40 .rsground streaming)",
        flush=True,
    )
    server.serve_forever()


if __name__ == "__main__":
    main()
