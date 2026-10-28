#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Génère `apercu_toutes_les_maps.html` : page d'index de TOUTES les maps du projet.

Sources recensées :
  1. maps `.rsground` présentes localement (racine, quest, renders, source) ;
  2. aperçus HTML locaux (`apercu_*.html` à la racine) — liens relatifs ;
  3. aperçus HTML distants (`apercu_*.html` de meromoonmeri/projet-pmdo, commit figé) —
     ouverts via htmlpreview.github.io (rendu HTML) ;
  4. maps livrées SOUS ZIP (`renders/<dossier>/*.zip` du dépôt distant) — lien de téléchargement ;
  5. lots de la bibliothèque (bibliotheque_ground/rapport_clamp.json) ;
  6. maps, aperçus et ZIP de CHAQUE branche du dépôt de création meromoonmeri/projet-creation-pmdo
     (branches récentes incluses), dédoublonnés par contenu ;
  7. maps externes à la quest (town02 : WaterfallVillageCapital en Git LFS, non téléchargeable ici).

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
CREATION = "meromoonmeri/projet-creation-pmdo"
PREVIEW = "https://htmlpreview.github.io/?"
SORTIE = ROOT / "apercu_toutes_les_maps.html"
RE_CREATION = re.compile(r"(\.rsground|\.zip|(^|/)apercu_[^/]*\.html)$", re.I)


def gh(endpoint: str, jq: str) -> str:
    return subprocess.run(["gh", "api", endpoint, "--jq", jq],
                          capture_output=True, text=True, timeout=180, check=True).stdout


def gh_tree(sha: str) -> list[tuple[str, int]]:
    out = gh(f"repos/{REMOTE}/git/trees/{sha}?recursive=1",
             '.tree[] | select(.type=="blob") | "\\(.path)\\t\\(.size)"')
    res = []
    for line in out.splitlines():
        p, s = line.split("\t")
        res.append((p, int(s)))
    return res


def branches_creation() -> list[dict]:
    """Toutes les branches du dépôt de création ; chaque contenu n'est listé qu'une fois."""
    lignes = gh(f"repos/{CREATION}/branches?per_page=100",
                '.[] | "\\(.name)\\t\\(.commit.sha)\\t\\(.commit.commit.committer.date // "")"').splitlines()
    lignes.sort(key=lambda x: x.split("\t")[2], reverse=True)
    vus: set[str] = set()
    groupes = []
    for ligne in lignes:
        nom, sha, date = ligne.split("\t")
        arbre = gh(f"repos/{CREATION}/git/trees/{sha}?recursive=1",
                   '.tree[] | select(.type=="blob") | "\\(.path)\\t\\(.sha)\\t\\(.size)"')
        fichiers = []
        for l in arbre.splitlines():
            chemin, blob, taille = l.split("\t")
            if not RE_CREATION.search(chemin) or blob in vus:
                continue
            vus.add(blob)
            fichiers.append((chemin, int(taille), sha))
        groupes.append({"branche": nom, "date": date[:10], "fichiers": fichiers})
    return groupes


def lots_bibliotheque() -> list[tuple[str, int, str]]:
    rapport = json.loads((ROOT / "bibliotheque_ground" / "rapport_clamp.json").read_text(encoding="utf-8-sig"))
    lots = rapport.get("lots", {})
    return [(nom, int(info.get("maps", 0)), info.get("source", ""))
            for nom, info in (lots.items() if isinstance(lots, dict) else [])]


def mo(n: int) -> str:
    return f"{n / 1_048_576:.1f} Mo"


def stem_norm(s: str) -> str:
    return re.sub(r"[^a-z0-9]", "", s.lower())


def main() -> None:
    lots = lots_bibliotheque()
    branches = branches_creation()
    tree = gh_tree(REMOTE_SHA)
    remote_html = sorted([(p, s) for p, s in tree if re.fullmatch(r"apercu_[^/]+\.html", p)])
    remote_zip = sorted([(p, s) for p, s in tree if re.fullmatch(r"renders/[^/]+/[^/]+\.zip", p)])
    local_html = sorted(p.name for p in ROOT.glob("apercu_*.html") if p != SORTIE)
    local_rsg = sorted(str(p.relative_to(ROOT)) for p in ROOT.rglob("*.rsground")
                       if not {".git", ".cache", ".venv"} & set(p.parts))
    local_tmj = sorted(str(p.relative_to(ROOT)) for p in (ROOT / "tiled").glob("*.tmj")) if (ROOT / "tiled").is_dir() else []

    remote_stems = {stem_norm(re.sub(r"^apercu_", "", Path(p).stem)): p for p, _ in remote_html}

    def li_zip(p: str, s: int) -> str:
        dossier = Path(p).parent.name
        apercu = remote_stems.get(stem_norm(Path(p).stem)) or remote_stems.get(stem_norm(dossier))
        extra = (f' · <a href="{html.escape(PREVIEW + RAW + apercu)}">aperçu</a>' if apercu else
                 " · <em>pas d'aperçu HTML dédié</em>")
        return f'<li><a href="{html.escape(RAW + p)}">{html.escape(p)}</a> <small>{mo(s)}</small>{extra}</li>'

    def li_html_local(n: str) -> str:
        return f'<li><a href="{html.escape(n)}">{html.escape(n)}</a></li>'

    def li_html_remote(p: str, s: int) -> str:
        return (f'<li><a href="{html.escape(PREVIEW + RAW + p)}">{html.escape(p)}</a> <small>{mo(s)}</small>'
                f' · <a href="{html.escape(BLOB + p)}">code/téléchargement</a></li>')

    def li_branche(b: dict) -> str:
        if not b["fichiers"]:
            return ""
        items = []
        for chemin, taille, sha in b["fichiers"]:
            lien_code = f"https://github.com/{CREATION}/blob/{sha}/{chemin}"
            extra = ""
            if chemin.lower().endswith(".html"):
                brut = f"https://raw.githubusercontent.com/{CREATION}/{sha}/{chemin}"
                extra = f' · <a href="{html.escape(PREVIEW + brut)}">aperçu</a>'
            items.append(f'<li>{html.escape(chemin)} <small>{mo(taille)}</small>{extra} · '
                         f'<a href="{html.escape(lien_code)}">code</a></li>')
        return (f'<details><summary><strong>{html.escape(b["branche"])}</strong> '
                f'<small>{b["date"]} · {len(b["fichiers"])} fichier(s)</small></summary>'
                f'<ul>{"".join(items)}</ul></details>')

    nb_b = sum(len(b["fichiers"]) for b in branches)
    corps = f"""<!doctype html><html lang="fr"><head><meta charset="utf-8">
<title>Aperçu de toutes les maps — PMDO Destiny</title>
<style>body{{background:#1d1a14;color:#eee;font:15px/1.5 system-ui,sans-serif;max-width:1040px;margin:24px auto;padding:0 16px}}
a{{color:#ffd76a}}small,em{{color:#aaa}}li{{margin:3px 0}}h2{{border-bottom:1px solid #444;padding-bottom:4px;margin-top:32px}}
details{{margin:6px 0}}summary{{cursor:pointer;padding:4px 0}}
.note{{background:#2b2619;border-left:4px solid #ffd76a;padding:8px 12px}}</style></head><body>
<h1>Aperçu de toutes les maps du projet</h1>
<p class="note">Village de la quest : <strong>WaterfallVillageCapital</strong> (« Reverie Town », dépôt
<code>meromoonmeri/town02</code>, fichier Git LFS de ~233 Mo : <strong>non téléchargeable depuis le sandbox</strong>,
aperçu à faire depuis un clone local avec <code>git lfs pull</code>, voir <code>OUTILS/INSTALLER_WATERFALL_VILLAGE.md</code>).
Les aperçus distants s'ouvrent via htmlpreview.github.io (fichiers très lourds : chargement possiblement long).
Les maps exclues pour raison de licence sont listées dans <code>bibliotheque_ground/rapport_clamp.json</code>.</p>
<p>Recensement : {len(local_html)} aperçus HTML locaux · {len(remote_html)} aperçus HTML distants (dépôt projet-pmdo) ·
{len(remote_zip)} archives ZIP de maps · {len(local_rsg)} fichiers .rsground locaux · {len(local_tmj)} salles Tiled ·
{len(lots)} lots de bibliothèque · {len(branches)} branches de création ({nb_b} fichiers de maps/aperçus/ZIP uniques).</p>

<h2>1. Aperçus HTML locaux (racine du dépôt)</h2><ul>{''.join(li_html_local(n) for n in local_html)}</ul>

<h2>2. Maps .rsground présentes localement ({len(local_rsg)})</h2>
<ul>{''.join(f'<li><code>{html.escape(p)}</code></li>' for p in local_rsg)}</ul>

<h2>3. Salles de la Guilde Treehouse (Tiled, non exportées en .rsground) ({len(local_tmj)})</h2>
<ul>{''.join(f'<li><code>{html.escape(p)}</code></li>' for p in local_tmj)}</ul>

<h2>4. Maps sous ZIP — dossiers renders/ de meromoonmeri/projet-pmdo ({len(remote_zip)})</h2>
<p>Les archives ne sont pas décompressées dans ce dépôt : téléchargement direct, ou aperçu HTML du même nom quand il existe.
Les ZIP PMDO ont été déployés dans la quest (voir <code>quest_pmd_destiny/RAPPORT_DEPLOIEMENT_ZIPS.json</code>).</p>
<ul>{''.join(li_zip(p, s) for p, s in remote_zip)}</ul>

<h2>5. Aperçus HTML distants — dépôt meromoonmeri/projet-pmdo ({len(remote_html)})</h2>
<ul>{''.join(li_html_remote(p, s) for p, s in remote_html)}</ul>

<h2>6. Lots de la bibliothèque ({len(lots)} lots, {sum(n for _, n, _ in lots)} maps recensées)</h2>
<p>Recensés dans <code>bibliotheque_ground/rapport_clamp.json</code>. Ces maps ne sont pas toutes matérialisées localement :
la colonne « source » indique leur origine.</p>
<ul>{''.join(f'<li><strong>{html.escape(n)}</strong> — {c} map(s) · <small>{html.escape(src)}</small></li>' for n, c, src in lots)}</ul>

<h2>7. Maps et aperçus par branche de création ({len(branches)} branches de {CREATION})</h2>
<p>Chaque fichier n'apparaît qu'une fois (dans la branche la plus récente qui le contient).
« aperçu » ouvre le HTML via htmlpreview.github.io ; « code » ouvre la page GitHub du fichier à ce commit.</p>
{''.join(li_branche(b) for b in branches)}

<h2>8. Maps externes à la quest (town02)</h2><ul>
<li><strong>WaterfallVillageCapital</strong> (village Reverie Town) — <code>meromoonmeri/town02</code>,
Data/Ground, Git LFS 233 Mo (oid sha256 afc5081f…) — <em>non prévisualisable ici</em>.</li>
<li><strong>waterfall_cave_1</strong> — même dépôt, récupérable sans LFS depuis <code>meromoonmeri/PMD-SKY-PMDO-PORT</code>
(voir <code>OUTILS/integrer_waterfall_town02.py</code>) — non encore prévisualisée.</li>
</ul>
</body></html>"""
    SORTIE.write_text(corps, encoding="utf-8")
    print(f"écrit : {SORTIE.relative_to(ROOT)} — {len(local_html)} locaux, {len(remote_html)} distants, "
          f"{len(remote_zip)} zips, {len(local_rsg)} rsground, {len(local_tmj)} tmj, "
          f"{len(lots)} lots, {len(branches)} branches, {nb_b} fichiers de branches")


if __name__ == "__main__":
    main()
