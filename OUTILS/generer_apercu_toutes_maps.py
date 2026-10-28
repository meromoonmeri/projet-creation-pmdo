#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Génère `apercu_toutes_les_maps.html` : catalogue de TOUTES les maps, aperçus et ZIP du projet.

Sources :
  - inventaire complet des branches (.cache/inventaire/fichiers.tsv, produit par .cache/inventaire/inventaire.py) :
    meromoonmeri/projet-creation-pmdo, meromoonmeri/guilde-treehouse-pmd, meromoonmeri/projet-pmdo ;
  - fichiers locaux (racine, quest_pmd_destiny/Data/Ground, renders/, tiled/) ;
  - bibliotheque_ground/rapport_clamp.json (lots).
Chaque contenu distinct (SHA de blob) n'est listé qu'une fois, avec la première branche qui le contient.
Les aperçus HTML s'ouvrent via htmlpreview.github.io sur le commit exact de la branche.

Usage : python3 OUTILS/generer_apercu_toutes_maps.py
"""
from __future__ import annotations

import html
import json
import re
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
INV = ROOT / ".cache" / "inventaire" / "fichiers.tsv"
RECUP = ROOT / ".cache" / "recuperation" / "manifest.json"
SORTIE = ROOT / "apercu_toutes_les_maps.html"
PREVIEW = "https://htmlpreview.github.io/?"
REPOS_SHORT = {"meromoonmeri/projet-creation-pmdo": "creation",
               "meromoonmeri/guilde-treehouse-pmd": "guilde",
               "meromoonmeri/projet-pmdo": "projet-pmdo"}


def local_par_blob() -> dict[str, str]:
    """blob -> chemin local (.cache/apercus/) pour les aperçus téléchargés."""
    m = ROOT / ".cache" / "apercus" / "manifest.json"
    if not m.is_file():
        return {}
    return {x["blob"]: ".cache/apercus/" + x["fichier"] for x in json.loads(m.read_text(encoding="utf-8"))
            if x.get("statut") in ("ok", "déjà présent")}


def mo(n: int) -> str:
    return f"{n / 1_048_576:.1f} Mo"


def raw(repo: str, sha: str, chemin: str) -> str:
    return f"https://raw.githubusercontent.com/{repo}/{sha}/{chemin}"


def blob_url(repo: str, sha: str, chemin: str) -> str:
    return f"https://github.com/{repo}/blob/{sha}/{chemin}"


def charge_inventaire() -> list[dict]:
    """Une entrée par contenu distinct (blob) ; première branche rencontrée."""
    vus: dict[str, dict] = {}
    for l in INV.read_text(encoding="utf-8").splitlines():
        repo, br, csha, rest = l.split("\t", 3)
        chemin, blob, taille = rest.rsplit("\t", 2)
        if blob in vus:
            continue
        vus[blob] = {"repo": repo, "branche": br, "commit": csha, "chemin": chemin,
                     "blob": blob, "taille": int(taille)}
    return list(vus.values())


def locaux() -> list[tuple[str, int]]:
    res = []
    for p in ROOT.rglob("*"):
        if not p.is_file() or {".git", ".cache", ".venv", "node_modules"} & set(p.parts):
            continue
        if p.suffix.lower() in (".rsground", ".tmj", ".html") and p.name.startswith(("apercu", "")):
            res.append((str(p.relative_to(ROOT)), p.stat().st_size))
    return sorted(res)


def quest_ground_noms() -> set[str]:
    return {p.stem for p in (ROOT / "quest_pmd_destiny" / "Data" / "Ground").glob("*.rsground")}


def recuperes_ok() -> dict[str, str]:
    """blob -> statut de déploiement (pour l'affichage)."""
    if not RECUP.is_file():
        return {}
    return {r["blob"]: r.get("statut", "") for r in json.loads(RECUP.read_text(encoding="utf-8"))}


LOCAL: dict[str, str] = {}


def main() -> None:
    global LOCAL
    LOCAL = local_par_blob()
    contenus = charge_inventaire()
    quest_noms = quest_ground_noms()

    lots = json.loads((ROOT / "bibliotheque_ground" / "rapport_clamp.json").read_text(encoding="utf-8-sig")).get("lots", {})

    def repo_court(r: str) -> str:
        return REPOS_SHORT.get(r, r)

    maps = [c for c in contenus if c["chemin"].lower().endswith(".rsground")]
    apercus = [c for c in contenus if re.search(r"(^|/)apercu[^/]*\.html$", c["chemin"], re.I)]
    zips = [c for c in contenus if c["chemin"].lower().endswith(".zip")]
    tmjs = [c for c in contenus if c["chemin"].lower().endswith(".tmj")]

    # regroupement des maps par nom
    par_nom: dict[str, list[dict]] = defaultdict(list)
    for m in maps:
        par_nom[Path(m["chemin"]).stem.lower()].append(m)

    # maps extraites des ZIP et déployées dans la quest (origine notée par deployer_recuperation.py)
    commit_de = {(c["repo"], c["branche"]): c["commit"] for c in contenus}
    rap = ROOT / "quest_pmd_destiny" / "RAPPORT_RECUPERATION_DEPOTS.json"
    if rap.is_file():
        for c in json.loads(rap.read_text(encoding="utf-8")).get("copies", []):
            if not c["fichier"].startswith("Data/Ground/"):
                continue
            repo, br, rest = c["origine"].split(":", 2)
            chemin = rest.split("!", 1)[0] + " ! " + c["fichier"]
            nom = Path(c["fichier"]).stem.lower()
            par_nom[nom].append({"repo": repo, "branche": br, "commit": commit_de.get((repo, br), ""),
                                 "chemin": chemin, "blob": "", "taille": 0})

    # aperçus par nom de map approché (apercu_<nom>.html ↔ nom de map)
    apercu_par_stem: dict[str, list[dict]] = defaultdict(list)
    for a in apercus:
        base = Path(a["chemin"]).stem
        base = re.sub(r"^apercu_?", "", base, flags=re.I).lower()
        apercu_par_stem[base].append(a)

    def ligne_map(nom: str, versions: list[dict]) -> str:
        dans_quest = nom in quest_noms
        statut = ("<span class='ok'>dans la quest</span>" if dans_quest else
                  ("<span class='ref'>référence / hors quest</span>" if any(
                      re.search(r"references|refs|dump", v["chemin"]) for v in versions)
                   else "<span class='todo'>source (non déployée)</span>"))
        items = []
        for v in versions:
            items.append(f'<li>{html.escape(repo_court(v["repo"]))} · {html.escape(v["branche"][:40])} · '
                         f'<code>{html.escape(v["chemin"])}</code> <small>{mo(v["taille"])}</small> · '
                         f'<a href="{html.escape(blob_url(v["repo"], v["commit"], v["chemin"]))}">code</a></li>')
        ap = apercu_par_stem.get(nom, [])
        liens_ap = " ".join(
            f'<a href="{html.escape(LOCAL.get(a["blob"]) or PREVIEW + raw(a["repo"], a["commit"], a["chemin"]))}">aperçu</a>'
            f' <small>({html.escape(repo_court(a["repo"]))})</small>' for a in ap[:3])
        return (f'<div class="carte-map"><div class="titre-map"><strong>{html.escape(nom)}</strong> {statut} '
                f'<small>{len(versions)} version(s)</small> {liens_ap}</div><ul>{"".join(items)}</ul></div>')

    maps_html = "".join(ligne_map(n, v) for n, v in sorted(par_nom.items()))

    apercus_html = "".join(
        f'<li><a href="{html.escape(LOCAL.get(a["blob"]) or PREVIEW + raw(a["repo"], a["commit"], a["chemin"]))}">'
        f'{html.escape(Path(a["chemin"]).name)}</a> <small>{mo(a["taille"])} · {html.escape(repo_court(a["repo"]))}'
        f' · {html.escape(a["branche"][:40])}</small> · '
        f'<a href="{html.escape(blob_url(a["repo"], a["commit"], a["chemin"]))}">code</a></li>'
        for a in sorted(apercus, key=lambda x: x["chemin"]))

    rec = recuperes_ok()
    zips_html = "".join(
        f'<li>{html.escape(repo_court(z["repo"]))} · {html.escape(z["branche"][:40])} · '
        f'<code>{html.escape(z["chemin"])}</code> <small>{mo(z["taille"])}</small> · '
        f'<a href="{html.escape(raw(z["repo"], z["commit"], z["chemin"]))}">télécharger</a>'
        f'{" · <span class=ok>contenu moteur déployé</span>" if rec.get(z["blob"]) else ""}</li>'
        for z in sorted(zips, key=lambda x: x["chemin"]))

    lots_html = "".join(
        f'<li><strong>{html.escape(n)}</strong> — {info.get("maps", 0)} map(s) · '
        f'<small>{html.escape(info.get("source", ""))}</small></li>' for n, info in lots.items())

    loc = locaux()
    loc_html = "".join(f"<li><code>{html.escape(p)}</code> <small>{mo(s)}</small></li>" for p, s in loc)

    corps = f"""<!doctype html><html lang="fr"><head><meta charset="utf-8">
<title>Catalogue de toutes les maps — PMD Destiny</title>
<style>body{{background:#1d1a14;color:#eee;font:15px/1.5 system-ui,sans-serif;max-width:1100px;margin:24px auto;padding:0 16px}}
a{{color:#ffd76a}}small{{color:#aaa}}li{{margin:3px 0}}h2{{border-bottom:1px solid #444;padding-bottom:4px;margin-top:32px}}
.carte-map{{margin:6px 0;padding:4px 8px;background:#26221a;border-radius:4px}}.titre-map{{font-weight:600}}
.ok{{color:#8f8}}.ref{{color:#aaa}}.todo{{color:#fb6}}.note{{background:#2b2619;border-left:4px solid #ffd76a;padding:8px 12px}}
table td{{padding:2px 10px}}</style></head><body>
<h1>Catalogue de toutes les maps du projet</h1>
<p><a href="apercu_galerie_toutes_maps.html"><strong>→ Ouvrir la galerie visuelle par biome</strong></a></p>
<p class="note">Ce catalogue est généré à partir de l'inventaire complet des 120 branches des 3 dépôts
(<code>projet-creation-pmdo</code>, <code>guilde-treehouse-pmd</code>, <code>projet-pmdo</code>).
Chaque contenu n'apparaît qu'une fois ; une map peut exister en plusieurs versions (plusieurs branches).
Les aperçus HTML s'ouvrent via htmlpreview.github.io ; les fichiers très lourds peuvent mettre du temps à charger.
WaterfallVillageCapital (village Reverie Town, town02, Git LFS 233 Mo) n'est pas dans ce catalogue : à installer localement.</p>

<h2>Résumé</h2>
<table>
<tr><td>Maps .rsground distinctes (par nom)</td><td><strong>{len(par_nom)}</strong></td></tr>
<tr><td>Versions de maps (contenus distincts)</td><td>{len(maps)}</td></tr>
<tr><td>Maps déjà dans la quest (Data/Ground)</td><td>{sum(1 for n in par_nom if n in quest_noms)}</td></tr>
<tr><td>Aperçus HTML distincts</td><td>{len(apercus)}</td></tr>
<tr><td>Archives ZIP distinctes</td><td>{len(zips)}</td></tr>
<tr><td>Salles Tiled (.tmj) distinctes</td><td>{len(tmjs)}</td></tr>
<tr><td>Lots de la bibliothèque (rapport_clamp)</td><td>{len(lots)} ({sum(int(i.get("maps", 0)) for i in lots.values())} maps recensées)</td></tr>
</table>

<h2>1. Maps (.rsground) — {len(par_nom)} noms distincts</h2>
<p>Cliquez une map pour voir ses versions (branche, commit) et ses aperçus.</p>
{maps_html}

<h2>2. Aperçus HTML — {len(apercus)}</h2>
<ul>{apercus_html}</ul>

<h2>3. Archives ZIP — {len(zips)}</h2>
<ul>{zips_html}</ul>

<h2>4. Lots de la bibliothèque ({len(lots)})</h2>
<ul>{lots_html}</ul>

<h2>5. Fichiers locaux du workspace ({len(loc)})</h2>
<ul>{loc_html}</ul>
</body></html>"""
    SORTIE.write_text(corps, encoding="utf-8")
    print(f"écrit : {SORTIE.name} — {len(par_nom)} maps, {len(apercus)} aperçus, {len(zips)} zips, "
          f"{len(tmjs)} tmj, {len(lots)} lots, {len(loc)} fichiers locaux")


if __name__ == "__main__":
    main()
