#!/usr/bin/env python3
"""Serveur HTTP local d'aperçus pour les cartes PMDO du dépôt.

Sert la racine du dépôt (HTML d'aperçu, PNG/GIF/WEBP sous renders/ et exports/)
et génère sur `/` un index dynamique avec galerie visuelle mettant en avant :
1. La Tour Temporelle — Roche Noire & Or (ETT1, FTT1, ECL1, CLR1, CLR2)
2. Le Lot en Cache du 1er Tour (EAW1/FAW1, ERG1/FRG1, ERL1/FRL1/FRL2, ETX1/FTX1) & Mont Horn (EMH1/FMH1)
3. Le Catalogue Complet de toutes les maps 4:3 (apercu_catalogue_complet_maps.html)
"""
from __future__ import annotations

import argparse
import html
import http.server
import os
import re
import socketserver
import urllib.parse
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TITLE_RE = re.compile(r"<title>(.*?)</title>", re.IGNORECASE | re.DOTALL)


def extract_title(path: Path) -> str:
    try:
        head = path.read_text(encoding="utf-8", errors="ignore")[:4096]
    except OSError:
        return path.stem
    m = TITLE_RE.search(head)
    return html.unescape(m.group(1).strip()) if m else path.stem


def categorize(name: str) -> str:
    if name in (
        "apercu_tour_temporelle_roche_noire_or_complet.html",
        "apercu_lot_cache_premier_tour.html",
        "apercu_catalogue_complet_maps.html",
    ):
        return "0_galeries_principales"
    if "tour_temporelle" in name or "colonnes_lances" in name:
        return "1_tour_temporelle"
    if name.startswith("apercu_entree_"):
        return "2_entrees_donjon"
    if name.startswith("apercu_fin_") or name.startswith("apercu_arene_"):
        return "3_fins_donjon"
    return "4_autres"


SECTION_LABELS = {
    "0_galeries_principales": "🌟 Galeries Principales & Catalogues Complets",
    "1_tour_temporelle": "⚡ Tour Temporelle (Roche Noire & Or) & Colonnes Lances (ETT1, FTT1, ECL1, CLR1, CLR2)",
    "2_entrees_donjon": "🚪 Entrées de Donjon Sud → Nord (4:3)",
    "3_fins_donjon": "👑 Fins de Donjon / Arènes de Boss (4:3, Pur Décor Sans Artefact)",
    "4_autres": "🗺️ Autres Aperçus",
}


def index_page() -> bytes:
    pages = sorted(ROOT.glob("apercu_*.html"))
    groups: dict[str, list[tuple[str, str]]] = {k: [] for k in SECTION_LABELS}
    for p in pages:
        groups[categorize(p.name)].append((p.name, extract_title(p)))

    parts = [
        "<!doctype html><html lang='fr'><head><meta charset='utf-8'>",
        "<meta name='viewport' content='width=device-width,initial-scale=1'>",
        "<title>Galerie PMDO — Tour Temporelle (Roche Noire & Or) & Catalogue Complet 4:3</title>",
        "<style>",
        "body{background:#0d1117;color:#e6edf3;font:15px/1.55 system-ui,sans-serif;margin:0;padding:24px}",
        "main{max-width:1440px;margin:auto}",
        "h1{font-size:26px;margin:0 0 6px;color:#f0c674}",
        "h2{font-size:18px;margin:28px 0 12px;color:#e7c77f;border-bottom:1px solid #29404c;padding-bottom:6px}",
        "p{color:#b3c9d3;margin:0 0 14px}code{color:#cfe4ee}",
        ".top-btns{display:flex;gap:12px;flex-wrap:wrap;margin:14px 0 22px;padding:14px;background:#161b22;border:1px solid #f0c674;border-radius:10px}",
        ".top-btns a{padding:8px 14px;border-radius:7px;text-decoration:none;font-weight:700;font-size:14px}",
        ".grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(390px,1fr));gap:16px}",
        ".card{background:#161b22;border:1px solid #30363d;border-radius:10px;padding:12px}",
        ".card.gold{border-color:#e6b450;background:#151821}",
        ".card h3{margin:0 0 6px;font-size:15px;color:#f0c674}",
        ".card .meta{font-size:12px;color:#8b949e;margin-bottom:8px;font-family:monospace}",
        ".card img{width:100%;height:auto;image-rendering:pixelated;border-radius:6px;border:1px solid #21262d;background:#000}",
        ".card .links{margin-top:8px;display:flex;gap:8px;flex-wrap:wrap;font-size:12px}",
        ".card .links a{background:#21262d;color:#58a6ff;text-decoration:none;padding:4px 10px;border-radius:5px;border:1px solid #30363d}",
        "ul{list-style:none;padding:0;margin:0;display:grid;grid-template-columns:repeat(auto-fill,minmax(360px,1fr));gap:8px}",
        "li a{display:flex;flex-direction:column;background:#161b22;border:1px solid #29404c;border-radius:6px;padding:8px 12px;color:inherit;text-decoration:none}",
        "li a:hover{border-color:#e7c77f}li span{color:#9fb6c0;font-size:12px;font-family:monospace}",
        "</style></head><body><main>",
        "<h1>⚡ Galerie PMDO — Tour Temporelle (Roche Noire & Or) & Catalogue Complet (34 Maps 4:3)</h1>",
        "<p>Animations logiques suivant la disposition spatiale des nuages (dérive horizontale 1:1 en strates sur <code>ETT1</code> &amp; <code>EMH1/FMH1</code>, courant annulaire tangentiel autour du piton octogonal sur <code>FTT1</code>) et pur décor sans artefact.</p>",
        "<div class='top-btns'>",
        "<a href='/apercu_tour_temporelle_roche_noire_or_complet.html' style='background:#f0c674;color:#0d1117'>⏳ Tour Temporelle — Roche Noire & Or (ETT1, FTT1, ECL1, CLR1, CLR2)</a>",
        "<a href='/apercu_lot_cache_premier_tour.html' style='background:#21262d;color:#f0c674;border:1px solid #f0c674'>📦 Lot en Cache du 1er Tour (EAW1/FAW1, ERG1/FRG1, ERL1/FRL1/FRL2)</a>",
        "<a href='/apercu_catalogue_complet_maps.html' style='background:#21262d;color:#58a6ff;border:1px solid #30363d'>📚 Catalogue Complet des 34 Maps 4:3</a>",
        "</div>",
        "<h2>⚡ 1. Tour Temporelle — Roche Noire Obsidienne & Or + Colonnes Lances (Aperçu Direct)</h2>",
        "<div class='grid'>",
        "<div class='card gold'><h3>ETT1 — Entrée Tour Temporelle — Roche Noire & Or (4:3)</h3><div class='meta'>768×576 · Nuages animés en 5 strates horizontales 1:1 derrière la falaise d'obsidienne</div><img src='/renders/entree_tour_temporelle_roche_noire_or_v1/review/ETT1_scene_animee.webp'><div class='links'><a href='/apercu_entree_tour_temporelle_roche_noire_or_v1.html'>Viewer ETT1</a><a href='/renders/entree_tour_temporelle_roche_noire_or_v1/review/ETT1_scene_t000.png'>PNG t000</a><a href='/renders/entree_tour_temporelle_roche_noire_or_v1/review/ETT1_collisions_marqueurs.png'>Collisions</a></div></div>",
        "<div class='card gold'><h3>FTT1 — Fin Tour Temporelle — Sommet Roche Noire & Or (4:3)</h3><div class='meta'>768×576 · Flux nuageux tangentiel/radial autour de l'arène octogonale · Zéro artefact</div><img src='/renders/fin_tour_temporelle_roche_noire_or_v1/review/FTT1_scene_animee.webp'><div class='links'><a href='/apercu_fin_tour_temporelle_roche_noire_or_v1.html'>Viewer FTT1</a><a href='/renders/fin_tour_temporelle_roche_noire_or_v1/review/FTT1_scene_t000.png'>PNG t000</a><a href='/renders/fin_tour_temporelle_roche_noire_or_v1/review/FTT1_collisions_marqueurs.png'>Collisions</a></div></div>",
        "<div class='card gold'><h3>ECL1 — Entrée Colonnes Lances / Tour Temporelle (D30P42A)</h3><div class='meta'>Portique noir/or & nuages dorés animés</div><img src='/renders/entree_colonnes_lances_sud_nord_v1/review/ECL1_scene_animee.webp'><div class='links'><a href='/apercu_entree_colonnes_lances_v1.html'>Viewer ECL1</a><a href='/renders/entree_colonnes_lances_sud_nord_v1/review/ECL1_scene_t000.png'>PNG t000</a></div></div>",
        "<div class='card gold'><h3>CLR1 & CLR2 — Sommet Colonnes Lances / Tour Temporelle (V1 & V2)</h3><div class='meta'>Réf. D30P42A · Sommet Colonnes Lances V1 & V2</div><img src='/renders/colonnes_lances_v2/CLR2/review/CLR2_scene_animee.webp'><div class='links'><a href='/apercu_colonnes_lances_v1.html'>Viewer CLR1</a><a href='/apercu_colonnes_lances_v2.html'>Viewer CLR2</a></div></div>",
        "</div>",
    ]
    for key, label in SECTION_LABELS.items():
        items = groups[key]
        if not items:
            continue
        parts.append(f"<h2>{html.escape(label)} ({len(items)})</h2><ul>")
        for fname, title in items:
            href = urllib.parse.quote(fname)
            parts.append(
                f"<li><a href='/{href}'><b>{html.escape(title)}</b>"
                f"<span>{html.escape(fname)}</span></a></li>"
            )
        parts.append("</ul>")
    parts.append("</main></body></html>")
    return "".join(parts).encode("utf-8")


class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(ROOT), **kwargs)

    def do_GET(self):
        parsed = urllib.parse.urlsplit(self.path)
        if parsed.path in ("/", "/index.html"):
            body = index_page()
            self.send_response(200)
            self.send_header("Content-Type", "text/html; charset=utf-8")
            self.send_header("Cache-Control", "no-store")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
            return
        super().do_GET()


class ThreadingHTTPServer(socketserver.ThreadingMixIn, http.server.HTTPServer):
    allow_reuse_address = True
    daemon_threads = True


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--host", default="0.0.0.0", help="Adresse d'écoute (défaut: 0.0.0.0)")
    ap.add_argument("--port", type=int, default=int(os.environ.get("PORT", "8000")), help="Port HTTP (défaut: 8000)")
    args = ap.parse_args()
    with ThreadingHTTPServer((args.host, args.port), Handler) as httpd:
        print(f"Serveur d'aperçus PMDO actif sur http://{args.host}:{args.port}/ (racine: {ROOT})", flush=True)
        httpd.serve_forever()


if __name__ == "__main__":
    main()
