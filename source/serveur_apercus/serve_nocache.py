#!/usr/bin/env python3
"""
Serveur HTTP statique sans cache navigateur + téléchargement direct des `.rsground` / `.zip` :
  - Force `Cache-Control: no-store, no-cache, must-revalidate, max-age=0` sur toutes les réponses
    afin qu'aucun calque PNG mis à jour ne puisse jamais être servi depuis un ancien cache navigateur.
  - Sert également à la volée n'importe lequel des 20 fichiers `grounds_rsground/cliff_centre_<slug>_<mode>.rsground`
    directement depuis `PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip` avec `Content-Disposition: attachment`.
"""
from __future__ import annotations

import os
import posixpath
import zipfile
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs, unquote, urlsplit

ROOT = Path("/home/user/projet-creation-pmdo")
PACK_ZIP = ROOT / "livrables_cliff_nord_centre_pmdo/PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip"
FORCE_DOWNLOAD_EXTS = (".rsground", ".tile", ".dir", ".idx", ".zip")


class NoCachePMDOHandler(SimpleHTTPRequestHandler):
    def _try_virtual_rsground(self, send_body: bool) -> bool:
        parts = urlsplit(self.path)
        clean_path = unquote(parts.path).lstrip("/")
        if clean_path.startswith("livrables_cliff_nord_centre_pmdo/grounds_rsground/") and clean_path.endswith(".rsground"):
            fname = posixpath.basename(clean_path)
            target = f"MOD_CLIFF_NORD_CENTRE_PMDO/Data/Ground/{fname}"
            if PACK_ZIP.exists():
                with zipfile.ZipFile(PACK_ZIP, "r") as zf:
                    if target in zf.namelist():
                        payload = zf.read(target)
                        self.send_response(200)
                        self.send_header("Content-Type", "application/octet-stream")
                        self.send_header("Content-Length", str(len(payload)))
                        self.end_headers()
                        if send_body:
                            self.wfile.write(payload)
                        return True
        return False

    def do_HEAD(self) -> None:
        if not self._try_virtual_rsground(send_body=False):
            super().do_HEAD()

    def do_GET(self) -> None:
        if not self._try_virtual_rsground(send_body=True):
            super().do_GET()

    def end_headers(self) -> None:
        self.send_header("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0")
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")
        self.send_header("Access-Control-Allow-Origin", "*")
        parts = urlsplit(self.path)
        qs = parse_qs(parts.query)
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
    print("Serving /home/user/projet-creation-pmdo on http://0.0.0.0:8000 (no-cache + virtual .rsground streaming)", flush=True)
    server.serve_forever()


if __name__ == "__main__":
    main()
