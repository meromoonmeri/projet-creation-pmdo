#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Génère `apercu_toutes_les_maps.html` : page d'index de TOUTES les maps du projet.

Sources recensées :
  1. maps `.rsground` présentes localement (racine, quest, renders, source) ;
  2. aperçus HTML locaux (`apercu_*.html` à la racine) — liens relatifs ;
  3. aperçus HTML distants (`apercu_*.html` de meromoonmeri/projet-pmdo, commit figé) —
     ouverts via htmlpreview.github.io (rendu HTML) ;
  4. maps livrées SOUS ZIP (`renders/<dossier>/*.zip` du dépôt distant) — lien de téléchargement ;
  5. maps externes (town02 : WaterfallVillageCapital en Git LFS, non téléchargeable ici).

Usage : python3 OUTILS/generer_apercu_toutes_maps.py
"""
from __future__ import annotations

import html
import json
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REMOTE = "meromoonmeri/projet-pmdo"
REMOTE_SHA = "6cca4a09380211e510ab1bea454a1b1926ef4b5a"
RAW = f"https://raw.githubusercontent.com/{REMOTE}/{REMOTE_SHA}/"
BLOB = f"https://github.com/{REMOTE}/blob/{REMOTE_SHA}/"
PREVIEW = "https://htmlpreview.github.io/?"
SORTIE = ROOT / "apercu_toutes_les_maps.html"


def gh_tree() -> list[tuple[str, int]]:
    out = subprocess.run(
        ["gh", "api", f"repos/{REMOTE}/git/trees/{REMOTE_SHA}?recursive=1", "--jq",
         '.tree[] | select(.type=="blob") | "\\(.path)\\t\\(.size)"'],
        capture_output=True, text=True, timeout=120, check=True).stdout
    res = []
    for line in out.splitlines():
        p, s = line.split("\t")
        res.append((p, int(s)))
    return res


def mo(n: int) -> str:
    return f"{n / 1_048_576:.1f} Mo"


def stem_norm(s: str) -> str:
    return re.sub(r"[^a-z0-9]", "", s.lower())


def main() -> None:
    tree = gh_tree()
    remote_html = sorted([(p, s) for p, s in tree if re.fullmatch(r"apercu_[^/]+\.html", p)])
    remote_zip = sorted([(p, s) for p, s in tree if re.fullmatch(r"renders/[^/]+/[^/]+\.zip", p)])
    local_html = sorted(p.name for p in ROOT.glob("apercu_*.html") if p != SORTIE)
    local_rsg = sorted(str(p.relative_to(ROOT)) for p in ROOT.rglob("*.rsground")
                       if ".git" not in p.parts and ".cache" not in p.parts and ".venv" not in p.parts)
    local_tmj = sorted(str(p.relative_to(ROOT)) for p in (ROOT / "tiled").glob("*.tmj")) if (ROOT / "tiled").is_dir() else []

    remote_stems = {stem_norm(re.sub(r"^apercu_", "", Path(p).stem)): p for p, _ in remote_html}

    def li_zip(p: str, s: int) -> str:
        dossier = Path(p).parent.name
        nom = Path(p).stem
        apercu = remote_stems.get(stem_norm(nom)) or remote_stems.get(stem_norm(dossier))
        extra = (f' · <a href="{html.escape(PREVIEW + RAW + apercu)}">aperçu</a>' if apercu else
                 ' · <em>pas d\'aperçu HTML dédié</em>')
        return (f'<li><a href="{html.escape(RAW + p)}">{html.escape(p)}</a> <small>{mo(s)}</small>{extra}</li>')

    def li_html_local(n: str) -> str:
        return f'<li><a href="{html.escape(n)}">{html.escape(n)}</a></li>'

    def li_html_remote(p: str, s: int) -> str:
        return (f'<li><a href="{html.escape(PREVIEW + RAW + p)}">{html.escape(p)}</a> <small>{mo(s)}</small>'
                f' · <a href="{html.escape(BLOB + p)}">code/téléchargement</a></li>')

    corps = f"""<!doctype html><html lang="fr"><head><meta charset="utf-8">
<title>Aperçu de toutes les maps — PMDO Destiny</title>
<style>body{{background:#1d1a14;color:#eee;font:15px/1.5 system-ui,sans-serif;max-width:1040px;margin:24px auto;padding:0 16px}}
a{{color:#ffd76a}}small,em{{color:#aaa}}li{{margin:3px 0}}h2{{border-bottom:1px solid #444;padding-bottom:4px;margin-top:32px}}
.note{{background:#2b2619;border-left:4px solid #ffd76a;padding:8px 12px}}</style></head><body>
<h1>Aperçu de toutes les maps du projet</h1>
<p class="note">Village de la quest : <strong>WaterfallVillageCapital</strong> (« Reverie Town », dépôt
<code>meromoonmeri/town02</code>, fichier Git LFS de ~233 Mo : <strong>non téléchargeable depuis le sandbox</strong>,
aperçu à faire depuis un clone local avec <code>git lfs pull</code>, voir <code>OUTILS/INSTALLER_WATERFALL_VILLAGE.md</code>).
Les aperçus distants s'ouvrent via htmlpreview.github.io (fichiers très lourds : chargement possiblement long).</p>
<p>Recensement : {len(local_html)} aperçus HTML locaux · {len(remote_html)} aperçus HTML distants ·
{len(remote_zip)} archives ZIP de maps (dossiers <code>renders/</code>) · {len(local_rsg)} fichiers .rsground locaux · {len(local_tmj)} salles Tiled (.tmj).</p>

<h2>1. Aperçus HTML locaux (racine du dépôt)</h2><ul>{''.join(li_html_local(n) for n in local_html)}</ul>

<h2>2. Maps .rsground présentes localement ({len(local_rsg)})</h2>
<ul>{''.join(f'<li><code>{html.escape(p)}</code></li>' for p in local_rsg)}</ul>

<h2>3. Salles de la Guilde Treehouse (Tiled, non exportées en .rsground) ({len(local_tmj)})</h2>
<ul>{''.join(f'<li><code>{html.escape(p)}</code></li>' for p in local_tmj)}</ul>

<h2>4. Maps sous ZIP — dossiers renders/ du dépôt distant ({len(remote_zip)})</h2>
<p>Les archives ne sont pas décompressées dans ce dépôt : téléchargement direct, ou aperçu HTML du même nom quand il existe.</p>
<ul>{''.join(li_zip(p, s) for p, s in remote_zip)}</ul>

<h2>5. Aperçus HTML distants — dépôt {REMOTE} ({len(remote_html)})</h2>
<ul>{''.join(li_html_remote(p, s) for p, s in remote_html)}</ul>

<h2>6. Maps externes à la quest (town02)</h2><ul>
<li><strong>WaterfallVillageCapital</strong> (village Reverie Town) — <code>meromoonmeri/town02</code>,
Data/Ground, Git LFS 233 Mo (oid sha256 afc5081f…) — <em>non prévisualisable ici</em>.</li>
<li><strong>waterfall_cave_1</strong> — même dépôt, récupérable sans LFS depuis <code>meromoonmeri/PMD-SKY-PMDO-PORT</code>
(voir <code>OUTILS/integrer_waterfall_town02.py</code>) — non encore prévisualisée.</li>
</ul>
</body></html>"""
    SORTIE.write_text(corps, encoding="utf-8")
    print(f"écrit : {SORTIE.relative_to(ROOT)} — {len(local_html)} locaux, {len(remote_html)} distants, "
          f"{len(remote_zip)} zips, {len(local_rsg)} rsground, {len(local_tmj)} tmj")


if __name__ == "__main__":
    main()
