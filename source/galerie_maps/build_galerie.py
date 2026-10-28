#!/usr/bin/env python3
"""Construit `galerie_maps.html` : la galerie exhaustive des maps du dépôt.

Une vignette par unité de map (171 : 163 lots + 8 sous-maps de `zone_zero_v1/v2`),
rangée par famille (entrées, fins, arènes, zones, guilde/intérieurs, carte du monde,
côtes, donjons, décors). Filtre par famille, recherche, masquage des vignettes, visionneuse
avec le chemin exact de l'image source dans `meromoonmeri/projet-pmdo`.

    .venv/bin/python source/galerie_maps/preparer.py   # vignettes (une fois)
    .venv/bin/python source/galerie_maps/build_galerie.py
"""
from __future__ import annotations

import json
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
GALERIE = HERE / "galerie.json"           # lots du dépôt source (renders/ @ 6cca4a0)
GALERIE_BRANCHE = HERE / "galerie_branche.json"   # lots propres à cette branche
GALERIE_SALLES = HERE / "galerie_salles.json"     # 12 salles de la guilde (kit.json)
MANIFESTE_MAPS = ROOT / "maps" / "MANIFESTE_MAPS.json"   # maps rapatriées physiquement
SORTIE = ROOT / "apercu_galerie_maps.html"

DEPOT = "meromoonmeri/projet-pmdo"
COMMIT = "6cca4a09380211e510ab1bea454a1b1926ef4b5a"
ORDRE = ["entree", "fin", "arene", "zone", "guilde", "cotes", "donjon", "monde", "divers"]

gabarit = """<!doctype html>
<html lang="fr">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width,initial-scale=1" />
<title>Aperçu exhaustif des maps — Projet Création PMDO</title>
<style>
:root{--bg:#0d1119;--bg2:#141b27;--carte:#18212f;--bord:#293749;--txt:#e8eefb;--dim:#93a3bb;--or:#f4b942}
*{box-sizing:border-box}
html,body{margin:0;background:var(--bg);color:var(--txt);font:15px/1.5 system-ui,-apple-system,"Segoe UI",Roboto,sans-serif}
a{color:#ffd76a}
header{position:sticky;top:0;z-index:20;background:linear-gradient(180deg,rgba(13,17,25,.98),rgba(13,17,25,.92));border-bottom:1px solid var(--bord);backdrop-filter:blur(6px)}
.enveloppe{max-width:1500px;margin:0 auto;padding:14px 20px}
h1{margin:0 0 4px;font-size:22px;letter-spacing:.2px}
h1 span{color:var(--or)}
.sous{color:var(--dim);font-size:13px;margin:0 0 10px}
.sous b{color:var(--txt)}
.barre{display:flex;gap:8px;flex-wrap:wrap;align-items:center}
button.filtre{background:#1b2536;color:var(--txt);border:1px solid var(--bord);border-radius:999px;padding:6px 12px;font:600 13px system-ui;cursor:pointer;transition:.15s}
button.filtre:hover{background:#243146}
button.filtre.actif{background:var(--or);color:#241a05;border-color:var(--or)}
button.filtre small{opacity:.7;font-weight:500}
#recherche{flex:1;min-width:190px;background:#111827;color:var(--txt);border:1px solid var(--bord);border-radius:999px;padding:8px 14px;font:14px system-ui;outline:none}
#recherche:focus{border-color:var(--or)}
.bascule{display:flex;gap:6px;align-items:center;color:var(--dim);font-size:13px;user-select:none;cursor:pointer}
main{max-width:1500px;margin:0 auto;padding:20px}
h2.famille{margin:34px 0 12px;font-size:17px;border-bottom:1px solid var(--bord);padding-bottom:7px;color:#ffe9a8}
h2.famille small{color:var(--dim);font-weight:400;font-size:13px}
.grille{display:grid;grid-template-columns:repeat(auto-fill,minmax(268px,1fr));gap:16px}
.carte{background:var(--carte);border:1px solid var(--bord);border-radius:12px;overflow:hidden;display:flex;flex-direction:column;transition:transform .12s,border-color .12s}
.carte:hover{transform:translateY(-2px);border-color:#4b6386}
.vue{position:relative;background:linear-gradient(135deg,#101722,#1a2433);cursor:zoom-in;aspect-ratio:4/3;display:flex;align-items:center;justify-content:center;overflow:hidden}
.vue img{width:100%;height:100%;object-fit:contain;image-rendering:pixelated;display:block}
.vue.masquee img{visibility:hidden}
.vue .voile{position:absolute;inset:0;display:flex;align-items:center;justify-content:center;color:var(--dim);font-size:12px;pointer-events:none}
.legende{padding:9px 12px 12px;display:flex;flex-direction:column;gap:3px}
.titre{font-weight:650;font-size:14px;line-height:1.25}
.meta{color:var(--dim);font-size:11.5px;font-family:ui-monospace,Menlo,monospace;word-break:break-all}
.badges{display:flex;gap:5px;flex-wrap:wrap}
.badge{background:#223046;color:#a9c4e8;border-radius:5px;padding:1px 6px;font-size:10.5px;letter-spacing:.3px}
.badge.nat{background:#3a2a12;color:#ffd484}
.badge.absent{background:#3a1d24;color:#ffb3bf}
.carte.absente{opacity:.72}
.carte.absente .vue{aspect-ratio:auto;padding:22px 12px;min-height:96px;background:repeating-linear-gradient(45deg,#111823,#111823 8px,#151d2a 8px,#151d2a 16px)}
.raison{color:#c8a1a8;font-size:11.5px;line-height:1.35}
a.local{font-size:11.5px;color:#9ee6b8;text-decoration:none;font-weight:600}
a.local:hover{text-decoration:underline}
footer{max-width:1500px;margin:0 auto;padding:26px 20px 60px;color:var(--dim);font-size:12.5px;border-top:1px solid var(--bord)}
#visionneuse{position:fixed;inset:0;z-index:60;background:rgba(5,8,14,.94);display:none;flex-direction:column;align-items:center;justify-content:center;padding:24px;gap:12px}
#visionneuse.open{display:flex}
#visionneuse img{max-width:94vw;max-height:76vh;image-rendering:pixelated;border:1px solid #35455c;border-radius:8px;background:#0b1018}
#visionneuse .inf{color:var(--txt);text-align:center;font-size:13px}
#visionneuse .inf code{color:#ffd76a;font-size:12px}
#visionneuse .fermer{position:absolute;top:16px;right:22px;font-size:26px;background:none;border:0;color:#fff;cursor:pointer}
.vide{color:var(--dim);padding:26px 0;display:none}
</style>
</head>
<body>
<header><div class="enveloppe">
  <h1>Aperçu exhaustif des maps — <span>Projet Création PMDO</span></h1>
  <p class="sous">__ENTETE__ Les vignettes sont des compositions statiques versionnées dans la branche (<code>apercus/galerie_maps/</code>) ; l'image d'origine de chaque map est indiquée sous la vignette.</p>
  <div class="barre" id="familles"></div>
  <div class="barre" style="margin-top:8px">
    <input id="recherche" type="search" placeholder="Rechercher une map (nom, code EKR1, biome, dossier…)" />
    <label class="bascule"><input type="checkbox" id="voile"> masquer les vignettes</label>
    <label class="bascule"><input type="checkbox" id="avecimg" checked> masquer les lots sans image</label>
    <label class="bascule"><input type="checkbox" id="local"> seulement les fichiers natifs de la branche</label>
    <label class="bascule"><input type="checkbox" id="images"> charger les images (désactivé = plus léger)</label>
  </div>
</div></header>
<main id="contenu"></main>
<div class="vide" id="vide">Aucune map ne correspond à cette recherche.</div>
<footer>
  <p><b>__NB__</b> — Quatre sources, toutes versionnées, aucun zip : (1) le dépôt
  <a href="https://github.com/__DEPOT__">__DEPOT__</a> au commit <code>__COMMIT__</code> pour les lots hérités
  (une composition par map) ; (2) les fichiers <b>de cette branche</b> — <code>renders/&lt;lot&gt;/layers/*.png</code>
  recomposés, ou les calques du manifeste embarqué des aperçus <code>apercu_*.html</code> ; (3) les bruts et
  références <code>source/&lt;lot&gt;/</code> quand le rendu final n'est pas versionné (badge « rendu » ou
  « référence ») ; (4) les 12 salles de la guilde de <code>kit.json</code> (<code>salles/</code>, jour et nuit).
  (5) les <b>fichiers natifs rapatriés</b> dans <code>maps/</code> (octets exacts, sha1 git vérifié,
  manifeste <code>maps/MANIFESTE_MAPS.json</code>), liés depuis chaque vignette concernée.
  Les 4,6 Go de calques, bruts animés et paquets restent dans le dépôt source.</p>
  <p>Honnêteté : ces aperçus sont des compositions 2D, ils ne prouvent ni la fidélité des tuiles natives, ni les
  collisions, ni un import runtime PMDO. <code>art_approved = false</code> pour l'ensemble.</p>
</footer>
<div id="visionneuse"><button class="fermer" aria-label="Fermer">×</button><img alt="" /><div class="inf"></div></div>
<script>
const DONNEES = __DONNEES__;
window.__GALERIE__ = { DONNEES };   // accès pour le test navigateur
const ORDRE = __ORDRE__;
window.__GALERIE__.ORDRE = ORDRE;
const DEPOT = "__DEPOT__", COMMIT = "__COMMIT__";
const contenu = document.getElementById('contenu'), familles = document.getElementById('familles');
const recherche = document.getElementById('recherche'), cbVoile = document.getElementById('voile');
const cbImages = document.getElementById('images'), vide = document.getElementById('vide');
const cbAvecImage = document.getElementById('avecimg');
const cbLocal = document.getElementById('local');
let avecImageSeulement = true;
let familleActive = 'toutes';
cbAvecImage.checked = false;

const parFamille = {};
for (const u of DONNEES) (parFamille[u.categorie] = parFamille[u.categorie] || []).push(u);
const libelles = {};
for (const u of DONNEES) libelles[u.categorie] = u.categorie_label;
const ordre = ORDRE.filter(c => parFamille[c]).concat(Object.keys(parFamille).filter(c => !ORDRE.includes(c)));

function bouton(cle, texte, n) {
  const b = document.createElement('button');
  b.className = 'filtre' + (cle === 'toutes' ? ' actif' : '');
  b.innerHTML = texte + ' <small>(' + n + ')</small>';
  b.dataset.cle = cle;
  b.onclick = () => { familleActive = cle; document.querySelectorAll('button.filtre').forEach(x => x.classList.toggle('actif', x.dataset.cle === cle)); dessiner(); };
  return b;
}
familles.appendChild(bouton('toutes', 'Toutes', DONNEES.length));
for (const c of ordre) familles.appendChild(bouton(c, libelles[c], parFamille[c].length));

function correspond(u) {
  if (cbAvecImage.checked && !u.present) return false;
  if (cbLocal.checked && !u.local) return false;
  const q = recherche.value.trim().toLowerCase();
  if (!q) return true;
  return (u.etiquette + ' ' + (u.source || '') + ' ' + (u.raison || '') + ' ' + u.titre).toLowerCase().includes(q);
}

function carte(u) {
  const d = document.createElement('article');
  d.className = 'carte' + (u.present ? '' : ' absente');
  const vue = document.createElement('div'); vue.className = 'vue' + (cbVoile.checked ? ' masquee' : '');
  if (!u.present) {
    vue.innerHTML = '<div class="voile">pas d’image versionnée sur cette branche</div>';
  } else if (u.vignette && cbImages.checked) {
    const im = document.createElement('img');
    im.setAttribute('loading', 'lazy'); im.alt = u.titre; im.src = u.vignette;
    im.onerror = () => { im.remove(); vue.innerHTML = '<div class="voile">vignette absente</div>'; };
    im.onclick = () => ouvrir(u);
    vue.appendChild(im);
  } else {
    vue.innerHTML = '<div class="voile">image non chargée</div>';
  }
  const lg = document.createElement('div'); lg.className = 'legende';
  const badges = document.createElement('div'); badges.className = 'badges';
  const badge = document.createElement('span'); badge.className = 'badge'; badge.textContent = u.categorie_label;
  badges.appendChild(badge);
  const nat = document.createElement('span');
  nat.className = 'badge nat' + (u.present ? '' : ' absent');
  nat.textContent = u.present ? (u.nature_label || u.nature || 'image') : 'sans image';
  badges.appendChild(nat);
  const t = document.createElement('div'); t.className = 'titre'; t.textContent = u.titre;
  const m = document.createElement('div'); m.className = 'meta';
  m.textContent = (u.source || u.etiquette) + (u.source_taille ? ' · ' + u.source_taille[0] + '×' + u.source_taille[1] : '');
  lg.append(badges, t, m);
  if (u.local) {
    const a = document.createElement('a');
    a.className = 'local';
    a.href = u.local; a.target = '_blank'; a.rel = 'noopener';
    a.textContent = '▶ PNG natif ' + (u.source_taille ? u.source_taille[0] + '×' + u.source_taille[1] : '') +
                    ' · ' + (u.local_octets / 1024).toFixed(0) + ' ko';
    lg.appendChild(a);
  }
  if (!u.present && u.raison) {
    const r = document.createElement('div'); r.className = 'raison'; r.textContent = u.raison;
    lg.appendChild(r);
  }
  d.append(vue, lg);
  return d;
}

function dessiner() {
  contenu.innerHTML = '';
  const famillesAffichees = familleActive === 'toutes' ? ordre : [familleActive];
  let total = 0;
  for (const c of famillesAffichees) {
    const items = parFamille[c].filter(correspond);
    if (!items.length) continue;
    total += items.length;
    const h = document.createElement('h2'); h.className = 'famille';
    h.innerHTML = libelles[c] + ' <small>— ' + items.length + ' map' + (items.length > 1 ? 's' : '') + '</small>';
    contenu.appendChild(h);
    const g = document.createElement('div'); g.className = 'grille';
    for (const u of items) g.appendChild(carte(u));
    contenu.appendChild(g);
  }
  vide.style.display = total ? 'none' : 'block';
}

const vis = document.getElementById('visionneuse');
function ouvrir(u) {
  const img = vis.querySelector('img');
  img.src = u.vignette; img.alt = u.titre;
  vis.querySelector('.inf').innerHTML =
    '<b>' + u.titre + '</b><br><code>' + u.etiquette + '</code><br>' +
    '<a href="https://github.com/' + DEPOT + '/blob/' + COMMIT + '/' + (u.source || '') + '" target="_blank" rel="noopener">ouvrir l\\'image d\\'origine ' +
    (u.source_taille ? '(' + u.source_taille[0] + '×' + u.source_taille[1] + ')' : '') + '</a>';
  vis.classList.add('open');
}
vis.onclick = (e) => { if (e.target === vis || e.target.classList.contains('fermer')) vis.classList.remove('open'); };
document.addEventListener('keydown', (e) => { if (e.key === 'Escape') vis.classList.remove('open'); });
recherche.oninput = dessiner;
cbVoile.onchange = dessiner;
cbImages.onchange = dessiner;
cbAvecImage.onchange = dessiner;
cbLocal.onchange = dessiner;
dessiner();
</script>
</body>
</html>
"""


NATURES = {
    "rendu": "rendu",
    "reference": "référence",
    "compo": "composition",
}


def locales() -> dict[tuple[str, str], dict]:
    if not MANIFESTE_MAPS.exists():
        return {}
    return {(m["lot"], m.get("sous_map") or ""): m
            for m in json.loads(MANIFESTE_MAPS.read_text())["maps"]}


def charger() -> list[dict]:
    dispo = locales()
    unites = []
    for fichier, nature in ((GALERIE, None), (GALERIE_BRANCHE, None), (GALERIE_SALLES, None)):
        if not fichier.exists():
            continue
        for u in json.loads(fichier.read_text())["unites"]:
            u.setdefault("nature", "rendu" if (u.get("source") or "").startswith("renders/") else "compo")
            u["nature_label"] = NATURES.get(u["nature"], u["nature"])
            m = dispo.get((u["lot"], u.get("sous_map") or ""))
            if m:
                u["local"] = m["fichier"]
                u["local_octets"] = m["octets"]
                u["local_sha256"] = m["sha256"]
            unites.append(u)
    return unites


def main() -> int:
    unites = charger()
    unites.sort(key=lambda u: (ORDRE.index(u["categorie"]) if u["categorie"] in ORDRE else 99,
                               u["etiquette"].lower()))
    familles = Counter(u["categorie_label"] for u in unites)
    avec = sum(1 for u in unites if u.get("present"))
    locales_nb = sum(1 for u in unites if u.get("local"))
    poids = sum(u.get("local_octets", 0) for u in unites)
    entete = (f"<b>{len(unites)} maps recensées</b> — {avec} avec vignette, "
              f"<b>{locales_nb} fichiers natifs dans la branche</b> (<code>maps/</code>, "
              f"{poids / 1e6:.1f} Mo), {len(unites) - avec} sans image versionnée — "
              f"en {len(familles)} familles. ")
    page = (gabarit
            .replace("__DONNEES__", json.dumps(unites, ensure_ascii=False).replace("</", "<\\/"))
            .replace("__ORDRE__", json.dumps(ORDRE))
            .replace("__DEPOT__", DEPOT)
            .replace("__COMMIT__", COMMIT)
            .replace("__ENTETE__", entete)
            .replace("__NB__", f"{len(unites)} maps, {len(familles)} familles"))
    SORTIE.write_text(page, encoding="utf-8")
    print(f"{SORTIE.relative_to(ROOT)} — {len(page) / 1024:.0f} ko, {len(unites)} maps")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
