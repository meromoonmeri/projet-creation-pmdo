#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Génère `apercu_galerie_toutes_maps.html` : galerie de TOUS les aperçus de maps, classés par biome.

Les aperçus sont lus depuis .cache/apercus/ (téléchargés par OUTILS/telecharger_apercus.py) et sont
servis localement par source/serveur_apercus/serve.py : ils s'ouvrent directement dans le navigateur
(pages canvas/JS, pas de passage par GitHub).
Le classement se fait par mots-clés dans le nom de fichier (premier biome qui correspond gagne).

Usage : python3 OUTILS/generer_galerie_maps.py
"""
from __future__ import annotations

import html
import json
import re
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / ".cache" / "apercus" / "manifest.json"
SORTIE = ROOT / "apercu_galerie_toutes_maps.html"

# (titre, mots-clés) — ordre = priorité
BIOMES = [
    ("Légendaires & sanctuaires (Palkia, Groudon, Kyogre…)",
     r"palkia|faille_spatiale|groudon|kyogre|dialga|giratina|terapagos|legend|sanctuaire|arene_|tour_celeste|mont_lointain|mont_foudre|mont_brasier|tera"),
    ("Glace, givre & biomes glacials",
     r"glace|givre|givree|neige|enneig|boreal|aurore|crevasse|cirque_polaire|frost|ice|glacier|froid|polaire"),
    ("Volcans, magma & cendres",
     r"magma|volcan|cendre|cratere|crater|brasier|fosse|gorge_ardente|feu|lave|fissure|eruption|ardent"),
    ("Forêts, jungles & bois",
     r"foret|forest|bois|jungle|sous_bois|clairiere|mystif|jardin|champignon|mushroom|bristle|mousse|sakura|flore|tropical|verdure|feuill"),
    ("Désert, steppe & ruines",
     r"desert|sable|steppe|dune|ruine|zarbi|plaine|brulee|volcanic|poussiere"),
    ("Côtes, eau, plages & cascades",
     r"plage|beach|cote|mer|ocean|lac|lake|cascade|waterfall|siphon|eau|vapeur|steam|riviere|marin|anse|bassin|source|abyss|sea|port"),
    ("Métano, villes, guilde & cafés",
     r"metano|cafe|spinda|guilde|guild|treehouse|ville|town|maison|village|kirlia|reseau|casino|dojo|salle|bourg|halcyon"),
    ("Donjons, entrées & fins de donjon",
     r"entree|fin_|fin-|donjon|dungeon|dtef|antre|grotte|cave|sommet|puits|jardin_secret"),
]


def classe(nom: str) -> str:
    n = nom.lower()
    for titre, mots in BIOMES:
        if re.search(mots, n):
            return titre
    return "Autres aperçus"


def main() -> None:
    manifest = json.loads(MANIFEST.read_text(encoding="utf-8")) if MANIFEST.is_file() else []
    ok = [m for m in manifest if m.get("statut") in ("ok", "déjà présent")]
    par_biome: dict[str, list[dict]] = defaultdict(list)
    for m in ok:
        par_biome[classe(m["chemin"])].append(m)
    ordre = [b[0] for b in BIOMES] + ["Autres aperçus"]

    def carte(m: dict) -> str:
        nom = Path(m["chemin"]).name
        repo = m["repo"].split("/")[-1]
        branche = m["branche"].replace("arena/", "")[:22]
        return (f'<li><a href="{html.escape(".cache/apercus/" + m["fichier"])}" target="_blank">'
                f'{html.escape(nom)}</a> <small>{repo} · {html.escape(branche)} · '
                f'{m["taille"] / 1_048_576:.1f} Mo</small></li>')

    sections = []
    for titre in ordre:
        items = sorted(par_biome.get(titre, []), key=lambda m: m["chemin"].lower())
        if not items:
            continue
        sections.append(f'<h2>{html.escape(titre)} <small>({len(items)})</small></h2>'
                        f'<ul>{"".join(carte(m) for m in items)}</ul>')

    corps = f"""<!doctype html><html lang="fr"><head><meta charset="utf-8">
<title>Galerie de toutes les maps — PMD Destiny</title>
<style>body{{background:#1d1a14;color:#eee;font:15px/1.5 system-ui,sans-serif;max-width:1100px;margin:24px auto;padding:0 16px}}
a{{color:#ffd76a}}small{{color:#aaa}}li{{margin:4px 0}}h2{{border-bottom:1px solid #444;padding-bottom:4px;margin-top:30px}}
.note{{background:#2b2619;border-left:4px solid #ffd76a;padding:8px 12px}}</style></head><body>
<h1>Galerie de toutes les maps (aperçus)</h1>
<p class="note">{len(ok)} aperçus interactifs, classés par biome. Cliquez pour ouvrir un aperçu dans un nouvel onglet :
ils sont servis localement par le serveur d'aperçus (dossier <code>.cache/apercus/</code>). Les fichiers
sont lourds (jusqu'à 30 Mo) : le chargement peut prendre quelques secondes.</p>
{''.join(sections)}
</body></html>"""
    SORTIE.write_text(corps, encoding="utf-8")
    print(f"écrit : {SORTIE.name} — {len(ok)} aperçus, {len(par_biome)} biomes")


if __name__ == "__main__":
    main()
