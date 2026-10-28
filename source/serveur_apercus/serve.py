"""Serveur d'aperçus pour la session Arena (bibliothèque standard seulement).

    python3 source/serveur_apercus/serve.py            # 0.0.0.0:8000
    python3 source/serveur_apercus/serve.py --port 8080

Sert la racine du dépôt en lecture seule sur 0.0.0.0:8000 (supporte GET, HEAD, ?dl=1 et les query strings du proxy).
"""
from functools import partial
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
import argparse, collections, html, io, itertools, json, re, subprocess, time
from urllib.parse import urlsplit

R = Path(__file__).resolve().parents[2]

# --------------------------------------------------------------------------- toutes les maps
GALERIES = ('source/galerie_maps/galerie.json',
            'source/galerie_maps/galerie_branche.json',
            'source/galerie_maps/galerie_salles.json')
ORDRE_FAMILLES = ('entree', 'fin', 'arene', 'zone', 'guilde', 'cotes', 'donjon', 'monde', 'divers')
_MAPS_CACHE = {'cle': None, 'html': None}


def unites_maps():
    """Les 290 maps recensées (mêmes JSON que la galerie) + les fichiers natifs de `maps/`."""
    unites = []
    for nom in GALERIES:
        f = R / nom
        if f.exists():
            unites += json.loads(f.read_text(encoding='utf-8'))['unites']
    locaux = {}
    manifeste = R / 'maps' / 'MANIFESTE_MAPS.json'
    if manifeste.exists():
        for m in json.loads(manifeste.read_text(encoding='utf-8'))['maps']:
            locaux[(m['lot'], m.get('sous_map') or '')] = m
    for u in unites:
        m = locaux.get((u['lot'], u.get('sous_map') or ''))
        u['_local'] = m
    return unites


def slug(texte):
    return re.sub(r'[^a-z0-9]+', '-', texte.lower()).strip('-')


MOTS = {'entree': 'Entrée', 'fins': 'Fins', 'arene': 'Arène', 'arenes': 'Arènes', 'cafe': 'Café',
        'donjon': 'Donjon', 'donjons': 'Donjons', 'guilde': 'Guilde', 'ile': 'Île', 'iles': 'Îles',
        'reveil': 'Réveil', 'zero': 'Zéro', 'zarbi': 'Zarbi', 'metano': 'Métano', 'cotes': 'Côtes',
        'cotier': 'Côtier', 'cotiere': 'Côtière', 'foret': 'Forêt', 'forets': 'Forêts',
        'givree': 'Givrée', 'givre': 'Givre', 'neige': 'Neige', 'pierres': 'Pierres',
        'prairie': 'Prairie', 'caverne': 'Caverne', 'cristal': 'Cristal', 'cristaux': 'Cristaux',
        'traversee': 'Traversée', 'fosse': 'Fosse', 'chateau': 'Château', 'jardin': 'Jardin',
        'secret': 'Secret', 'nuit': 'Nuit', 'jour': 'Jour', 'aube': 'Aube', 'crepuscule': 'Crépuscule',
        'nord': 'Nord', 'sud': 'Sud', 'est': 'Est', 'ouest': 'Ouest', 'du': 'du', 'de': 'de',
        'des': 'des', 'la': 'la', 'le': 'le', 'les': 'les', 'et': 'et', 'en': 'en', 'aux': 'aux',
        'au': 'au', 'sur': 'sur', 'a': 'à', 'd': 'd', 'l': 'l', 'arenes': 'Arènes',
        'mega': 'Méga', 'clairiere': 'Clairière', 'cratere': 'Cratère', 'vapeur': 'Vapeur',
        'givre': 'Givre', 'glace': 'Glace', 'magma': 'Magma', 'sommet': 'Sommet', 'mont': 'Mont',
        'sanctuaire': 'Sanctuaire', 'grotte': 'Grotte', 'antre': 'Antre', 'foret': 'Forêt',
        'falaises': 'Falaises', 'ruines': 'Ruines', 'ruine': 'Ruine', 'terrasses': 'Terrasses',
        'couloir': 'Couloir', 'violet': 'Violet', 'sables': 'Sables', 'mouvants': 'Mouvants',
        'tropicale': 'Tropicale', 'boreales': 'Boréales', 'boreale': 'Boréale',
        'reseau': 'Réseau', 'multietage': 'Multiétage', 'multicalques': 'Multicalques',
        'cendres': 'Cendres', 'geysers': 'Geysers', 'siphons': 'Siphons', 'generee': 'Générée',
        'generees': 'Générées', 'reverie': 'Rêverie', 'faille': 'Faille', 'spatiale': 'Spatiale',
        'entrees': 'Entrées', 'zones': 'Zones', 'collines': 'Collines', 'tours': 'Tours',
        'cote': 'Côte', 'bois': 'Bois', 'eau': 'Eau', 'canopee': 'Canopée', 'fern': 'Fern',
        'celeste': 'Céleste', 'eoliens': 'Éoliens', 'arc_en_ciel': 'Arc-en-Ciel',
        'sacre': 'Sacré', 'sacree': 'Sacrée', 'lointain': 'Lointain', 'foudre': 'Foudre',
        'brasier': 'Brasier', 'argent': 'Argent', 'cyclopeenne': 'Cyclopéenne',
        'enfouies': 'Enfouies', 'ankoku': 'Ankoku', 'prehistoire': 'Préhistoire'}


def joli(texte: str) -> str:
    """`entree_caverne_cristal_sud_nord_v1` → « Entrée Caverne Cristal Sud Nord v1 »."""
    mots = [m for m in re.split(r'[_\-\s]+', str(texte)) if m]
    sortie = []
    for i, m in enumerate(mots):
        bas = m.lower()
        if re.fullmatch(r'v\d+|\d+', bas):
            sortie.append(m)                      # v1, 02, 12 : jamais capitalisés
        elif bas in MOTS:
            mot = MOTS[bas]
            sortie.append(mot.capitalize() if i == 0 and mot[:1].islower() else mot)
        else:
            sortie.append(m[:1].upper() + m[1:])
    return ' '.join(sortie)


_CODES = {}


def codes_du_lot(u):
    """Code de la map introuvable dans les métadonnées : cherché dans les noms de fichiers
    du lot (`EKR1_scene_t000.png`) puis dans son aperçu autonome. Mis en cache par lot."""
    lot = u['lot'].split('/')[-1]
    if lot in _CODES:
        return _CODES[lot]
    trouves = collections.Counter()
    for base in ('source', 'renders'):
        d = R / base / lot
        if not d.is_dir():
            continue
        for f in itertools.islice(d.rglob('*.png'), 400):
            m = re.match(r'([A-Z]{2,4}\d{1,2}[A-Z]?)_', f.name)
            if m:
                trouves[m.group(1)] += 1
    if not trouves:
        page = R / f'apercu_{lot}.html'
        if page.exists() and page.stat().st_size < 12_000_000:
            txt = page.read_text(errors='ignore')
            for m in re.finditer(r'([A-Z]{2,4}\d{1,2}[A-Z]?)_(?:scene|vue|collisions|coll)', txt):
                trouves[m.group(1)] += 1
    code = trouves.most_common(1)[0][0] if trouves else None
    _CODES[lot] = code
    return code


def code_map(u):
    """Code de la map : `EBN1`, `RAZ1`, `AGM3`… sinon le nom du lot, sinon l'étiquette."""
    if u.get('sous_map'):
        return u['sous_map']
    source = (u.get('source') or '').rsplit('/', 1)[-1]
    m = re.match(r'([A-Z]{2,4}\d{1,2}[A-Z]?)_', source)
    if m:
        return m.group(1)
    return codes_du_lot(u)


def fiche(u):
    """Une ligne de la liste : lien prioritaire vers le PNG natif de `maps/`, sinon vignette."""
    m = u.get('_local')
    lot = u['lot'].split('/')[-1]
    if u['lot'].startswith('guilde/') and u.get('titre'):
        libelle = u['titre']                      # « 01 · Accueil de la guilde » : déjà propre
    elif u.get('sous_map'):
        libelle = f"{u['sous_map']} · {joli(lot)}"
    else:
        code = code_map(u)
        libelle = f"{code} · {joli(u['etiquette'])}" if code else joli(u['etiquette'])
    titre = html.escape(libelle)
    taille = u.get('source_taille') or []
    detail = ''
    if taille:
        detail += f'{taille[0]}×{taille[1]} · '
    if m:
        lien = f'<a href="{html.escape(m["fichier"])}">{titre}</a>'
        detail += f'{m["octets"] / 1000:.0f} ko'
        badge = '<span class="nat">PNG natif</span>'
        cible = f' · <a class="ghost" href="apercu_galerie_maps.html#{slug(u["etiquette"])}">galerie</a>'
    elif u.get('vignette'):
        lien = f'<a href="{html.escape(u["vignette"])}">{titre}</a>'
        detail += f'vignette seule ({u.get("nature_label") or "image"})'
        badge = '<span class="vgn">vignette</span>'
        cible = f' · <a class="ghost" href="apercu_galerie_maps.html#{slug(u["etiquette"])}">galerie</a>'
    else:
        lien = f'<span class="none">{titre}</span>'
        detail = u.get('raison') or 'aucune image versionnée'
        badge = '<span class="abs">sans image</span>'
        cible = ''
    f = Path(u.get('source') or '').name          # nom du fichier source : porte souvent le code
    mots = ' '.join([u['etiquette'], u.get('titre', ''), libelle, str(code_map(u) or ''),
                     f, u['lot'], u['categorie_label']]).lower()
    return (f'<li data-mots="{html.escape(mots, quote=True)}">{badge}{lien} '
            f'<small>{html.escape(detail)}</small>{cible}</li>')


def section_maps():
    """Section « toutes les maps » de la page d'accueil (résultat mis en cache par mtime)."""
    fichiers = [R / n for n in GALERIES] + [R / 'maps' / 'MANIFESTE_MAPS.json']
    cle = tuple(f.stat().st_mtime_ns for f in fichiers if f.exists())
    if _MAPS_CACHE['cle'] == cle:
        return _MAPS_CACHE['html']

    unites = unites_maps()
    familles = {}
    for u in unites:
        familles.setdefault(u['categorie'], []).append(u)
    natifs = sum(1 for u in unites if u.get('_local'))
    poids = sum(u['_local']['octets'] for u in unites if u.get('_local'))
    ordre = [c for c in ORDRE_FAMILLES if c in familles] + \
            [c for c in familles if c not in ORDRE_FAMILLES]

    blocs = []
    for c in ordre:
        items = sorted(familles[c], key=lambda u: u['etiquette'].lower())
        label = html.escape(items[0]['categorie_label'])
        blocs.append(f'<section class="famille" data-famille="{c}">'
                     f'<h3>{label} <small>{len(items)}</small></h3>'
                     f'<ul class="maps">{"".join(fiche(u) for u in items)}</ul></section>')

    entete = (f'<h2 id="maps">Toutes les maps du projet <small>'
              f'{len(unites)} recensées · {natifs} fichiers natifs dans <code>maps/</code> · '
              f'{poids / 1e6:.1f} Mo · {len(unites) - natifs} sans image versionnée</small></h2>')
    script = """<script>
(function(){var q=document.getElementById('qm'),n=document.getElementById('qn'),tous=[].slice.call(document.querySelectorAll('li[data-mots]'));
function filtre(){var v=q.value.trim().toLowerCase(),n2=0;tous.forEach(function(li){var ok=!v||li.dataset.mots.indexOf(v)>=0;li.style.display=ok?'':'none';if(ok)n2++;});
document.querySelectorAll('section.famille').forEach(function(s){s.style.display=[].some.call(s.querySelectorAll('li'),function(li){return li.style.display!=='none';})?'':'none';});
n.textContent=n2+' / '+tous.length+' maps affichées';}
q.addEventListener('input',filtre);filtre();window.__INDEX__={maps:tous.length};})();
</script>"""
    html_out = (entete +
                '<div class="mapbar"><input id="qm" type="search" placeholder="Filtrer les maps : nom, code (EKR1), famille, dossier…">'
                '<span id="qn"></span><a class="dlbtn mini" href="apercu_galerie_maps.html">🖼 Galerie visuelle (vignettes)</a></div>'
                + ''.join(blocs) + script)
    _MAPS_CACHE.update(cle=cle, html=html_out)
    return html_out


def commit_dates():
    """Date (epoch) du dernier commit ayant touché chaque apercu_*.html de la racine."""
    try:
        out = subprocess.run(['git', '-C', str(R), 'log', '--name-only', '--format=@%ct', '--',
                              'apercu_*.html'], capture_output=True, text=True, timeout=20).stdout
    except Exception:
        return {}
    dates, t = {}, 0
    for line in out.splitlines():
        if line.startswith('@'):
            t = int(line[1:])
        elif line.strip() and line.strip() not in dates:
            dates[line.strip()] = t
    return dates


def title_of(p):
    m = re.search(r'<title>(.*?)</title>', p.read_text(errors='ignore')[:4000], re.S)
    return html.unescape(m.group(1).strip()) if m else p.stem


def index_page():
    dates = commit_dates()
    rows = []
    for p in R.glob('apercu_*.html'):
        d = dates.get(p.name)
        rows.append((d is None, max(d or 0, int(p.stat().st_mtime)), p))
    rows.sort(key=lambda r: (not r[0], -r[1]))
    serie = [r for r in rows if '_sud_nord_' in r[2].name]
    autres = [r for r in rows if '_sud_nord_' not in r[2].name]

    def li(r):
        new, t, p = r
        tag = '<span class="new">nouveau</span> ' if new else ''
        day = time.strftime('%d/%m/%Y', time.localtime(t))
        return (f'<li>{tag}<a href="{html.escape(p.name)}">{html.escape(title_of(p))}</a>'
                f' <small>{html.escape(p.name)} · {day}</small></li>')

    maps_html = section_maps()
    return f'''<!doctype html><html lang="fr"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Aperçus — Projet Création PMDO</title>
<style>body{{background:#161b26;color:#eee;font:15px/1.55 system-ui,sans-serif;max-width:1040px;margin:24px auto;padding:0 16px}}
a{{color:#ffd76a}}small{{color:#999}}li{{margin:5px 0}}.new{{background:#2c7a5b;color:#fff;border-radius:4px;padding:0 6px;font-size:12px}}
.dlbox{{background:#1e2638;border:2px solid #f2b84b;border-radius:10px;padding:14px 18px;margin:14px 0 18px}}
.dlbtn{{display:inline-block;background:#f2b84b;color:#1b1308;font-weight:700;padding:8px 14px;border-radius:7px;text-decoration:none;margin:6px 8px 2px 0}}
h2{{border-bottom:1px solid #303f5c;padding-bottom:5px;margin-top:26px}}
h2 small{{font-weight:400;color:#8e9bb3;font-size:12.5px}}
h3{{margin:20px 0 6px;font-size:15px;color:#ffe9a8}}h3 small{{color:#8e9bb3;font-weight:400}}
.mapbar{{position:sticky;top:0;z-index:5;display:flex;gap:10px;align-items:center;flex-wrap:wrap;background:#141a24;border:1px solid #2b3444;border-radius:9px;padding:9px 12px;margin:10px 0 4px}}
#qm{{flex:1;min-width:220px;background:#0f141c;border:1px solid #38445a;border-radius:999px;padding:8px 14px;color:#eee;font:14px system-ui;outline:none}}
#qm:focus{{border-color:#ffd76a}}#qn{{color:#8e9bb3;font-size:12.5px;white-space:nowrap}}
.dlbtn.mini{{padding:6px 11px;font-size:12.5px;margin:0}}
ul.maps{{list-style:none;padding:0;margin:0;columns:2;column-gap:26px}}
@media(max-width:820px){{ul.maps{{columns:1}}}}
ul.maps li{{margin:2px 0;break-inside:avoid;font-size:13.5px;line-height:1.45}}
ul.maps a{{text-decoration:none}}ul.maps a:hover{{text-decoration:underline}}
ul.maps small{{color:#8b97ab;font-size:11.5px}}
a.ghost{{color:#7f8ca3;font-size:11px;text-decoration:none}}a.ghost:hover{{color:#ffd76a}}
.nat,.vgn,.abs{{font-size:10px;border-radius:4px;padding:1px 5px;margin-right:5px;letter-spacing:.2px}}
.nat{{background:#1d4030;color:#8ff0b5}}.vgn{{background:#2c3348;color:#a9bde0}}.abs{{background:#3a2029;color:#f0a8b8}}
.none{{color:#8b97ab}}</style></head><body>
<h1>Aperçus &amp; Téléchargements PMDO</h1>
{maps_html}
<div class="dlbox" style="border-color:#38bdf8;background:#17253b">
  <strong style="font-size:17px;color:#eef8ff">NOUVEAU — Pack des 10 Falaises Nord Centrées Nues · Grass Métano · Multicalque · Mer 8 Phases · Ciel Jour / Nuit (20 Cartes PMDO 0.8.12)</strong><br>
  <a class="dlbtn" style="background:#38bdf8;color:#081626" href="apercu_cliff_nord_centre_pmdo.html">🌊☀️🌙 Ouvrir le visualiseur interactif des 10 versions (Jour/Nuit + 8 calques + Mer 8 phases + Nuages 3 plans)</a>
  <a class="dlbtn" href="livrables_cliff_nord_centre_pmdo/PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip?dl=1">⬇ Pack Complet 20 Cartes PMDO 0.8.12 (.ZIP — 5,88 Mio)</a>
</div>
<div class="dlbox" style="border-color:#818cf8;background:#19213a">
  <strong style="font-size:17px;color:#eef2ff">NOUVEAU — Cliff Nord en Nuit (<code>cliffdaytest</code> &amp; <code>cliffnordouesttest1</code>) · Nuages 3 Plans &amp; Mer 8 Phases Animés (PMDO 0.8.12 · Zéro Génération IA)</strong><br>
  <a class="dlbtn" style="background:#818cf8;color:#0f1326" href="apercu_cliff_nord_nuit_pmdo.html">🌙 Ouvrir l’aperçu temps réel (Nuages 3 plans + Mer 8 phases + Cascades + Nuit/Jour)</a>
  <a class="dlbtn" href="livrables_cliff_nord_nuit_pmdo/PACK_CLIFF_NORD_NUIT_PMDO_0812.zip?dl=1">⬇ Pack Complet PMDO 0.8.12 (.ZIP — .rsground + .dir + .tile + INSTALLER.py + GIF)</a>
</div>
<div class="dlbox" style="border-color:#34d399;background:#162925">
  <strong style="font-size:17px;color:#ecfdf5">NOUVEAU — Réseau Complet des Salles Vides de la Guilde Halcyon (13 Maps Connectées · Sans Lit ni Meuble · Sans Spinda Sign · PMDO 0.8.12)</strong><br>
  <a class="dlbtn" style="background:#34d399;color:#092118" href="apercu_guilde_reseau_vide_et_cliffnorth.html">🏰 Ouvrir le réseau des salles vides de la Guilde</a>
  <a class="dlbtn" href="livrables_guilde_reseau_vide_et_cliffnorth_pmdo/PACK_GUILDE_RESEAU_VIDE_ET_CLIFFNORTH_PMDO.zip?dl=1">⬇ Pack Guilde Salles Vides (.ZIP)</a>
</div>
<div class="dlbox" style="border-color:#b2ef63;background:#1a2822">
  <strong style="font-size:17px;color:#f2ffe5">Treehouses Monumentales de Guilde SANS ESCALIER EXTÉRIEUR · Styles « Jardin Secret » &amp; « Sky Peak » (GJN1–GJN4 &amp; GSN1–GSN4 · 100 % RGBA Sans Fond)</strong><br>
  <a class="dlbtn" style="background:#b2ef63;color:#10200b" href="apercu_guilde_sans_escalier_jardin_skypeak.html">Ouvrir la galerie Sans Escalier Extérieur</a>
  <a class="dlbtn" href="livrables_guilde_sans_escalier_pmdo/PACK_GUILDE_SANS_ESCALIER_JARDIN_SKYPEAK_PMDO.zip?dl=1">Télécharger le Pack ZIP Sans Escalier</a>
</div>
<div class="dlbox" style="border-color:#6ef0a3;background:#192530">
  <strong style="font-size:17px;color:#e8fff2">Treehouses Monumentales de Guilde · Styles « Jardin Secret » &amp; « Sky Peak » (GJS1–GJS4 &amp; GSP1–GSP4 · 100 % RGBA Sans Fond)</strong><br>
  <a class="dlbtn" style="background:#6ef0a3;color:#0b1c14" href="apercu_guilde_jardin_secret_sky_peak.html">Ouvrir la galerie interactive Jardin Secret &amp; Sky Peak</a>
  <a class="dlbtn" href="livrables_guilde_jardin_secret_sky_peak_pmdo/PACK_GUILDE_JARDIN_SECRET_SKY_PEAK_PMDO.zip?dl=1">Télécharger le Pack ZIP</a>
</div>
<div class="dlbox" style="border-color:#e4b659;background:#2c2320">
  <strong style="font-size:17px;color:#f7ebd2">Les 8 Spinda Cafés Monumentaux (#0327 · Style Officiel « Dojo Makuhita » PMD · Sans Devanture · Sans Fond RGBA)</strong><br>
  <a class="dlbtn" style="background:#d95d56;color:#fff" href="apercu_spinda_cafe_dojo_pmdo.html">Ouvrir la galerie interactive (SPC1–SPC8)</a>
  <a class="dlbtn" href="livrables_spinda_cafe_dojo_pmdo/Spinda_Cafe_Style_DojoMakuhita_PMDO.zip?dl=1">Télécharger le Pack ZIP</a>
</div>
<div class="dlbox" style="border-color:#d99f66;background:#2d241c">
  <strong style="font-size:17px;color:#f6ecd6">Pack Tentes &amp; Kiosques Évoli (#0133 · Style Bourg-Trésor PMD · Sans Fond RGBA)</strong><br>
  <a class="dlbtn" style="background:#d99f66;color:#1b1209" href="apercu_tente_evoli_pmdo.html">Ouvrir l’aperçu Tentes Évoli (EVT1–EVT6)</a>
  <a class="dlbtn" href="livrables_tente_evoli_pmdo/Evoli_Tentes_BourgTresor_PMDO.zip?dl=1">Télécharger le Pack ZIP</a>
</div>
<div class="dlbox" style="border-color:#f4ced7;background:#2f2228">
  <strong style="font-size:17px;color:#ffd9e6">Maison / Monument Forgelina (Style « Réserve Kangourex » PMD · Sans Visage · Sans Fond RGBA)</strong><br>
  <a class="dlbtn" style="background:#e88eb4;color:#1b1015" href="apercu_maison_forgelina_pmdo.html">Ouvrir l’aperçu Maison Forgelina (FGK1–FGK6)</a>
  <a class="dlbtn" href="livrables_maison_forgelina_pmdo/Forgelina_Maisons_Style_Kangourex_PMDO.zip?dl=1">Télécharger le Pack ZIP</a>
</div>
<div class="dlbox" style="border-color:#dd4d98;background:#2a2024">
  <strong style="font-size:17px;color:#f4ced7">Pack Tentes, Huttes &amp; Kiosques Forgelina (#0959 · Modèle « Arcanine Hut » · Sans Fond RGBA)</strong><br>
  <a class="dlbtn" style="background:#dd4d98;color:#fff" href="apercu_tentes_huttes_forgelina_pmdo.html">Ouvrir la galerie interactive Forgelina</a>
  <a class="dlbtn" href="livrables_forgelina_pmdo/Forgelina_Tentes_Huttes_ArcanineStyle_PMDO.zip?dl=1">Télécharger le Pack ZIP</a>
</div>
<div class="dlbox">
  <strong style="font-size:17px;color:#a9e39e">Grandes Treehouses Monumentales de Guilde (3–4 étages · Sans Fond RGBA)</strong><br>
  <a class="dlbtn" href="apercu_treehouses_guilde_monumentales_v2.html">Ouvrir la galerie interactive (9 structures)</a>
  <a class="dlbtn" href="livrables_treehouses_guilde_pmdo/PACK_TREEHOUSES_GUILDE_PMDO_SANS_FOND.zip?dl=1">Télécharger le Pack ZIP</a>
</div>
<div class="dlbox">
  <strong style="font-size:17px;color:#ffd76a">Objets Café &amp; Estrade 100 % SANS FOND (PMDO 0.8.12)</strong><br>
  <a class="dlbtn" href="telecharger_objets_cafe_pmdo.html">Ouvrir la page de téléchargement (16 objets sans fond)</a>
  <a class="dlbtn" href="livrables_pmdo_sans_fond/PACK_PMDO_1X_ET_MOD_0812_SANS_FOND.zip?dl=1">Télécharger le ZIP</a>
</div>
<h2>Aperçus autonomes &amp; packs ({len(rows)})</h2>
<p>{len(rows)} aperçus autonomes. Chaque page contient ses calques, ses animations et ses liens de téléchargement.</p>
<h2>Lots récents &amp; conversions Nuit ({len(autres)})</h2><ul>{''.join(li(r) for r in autres)}</ul>
<h2>Entrées de donjon sud → nord ({len(serie)})</h2><ul>{''.join(li(r) for r in serie)}</ul>
</body></html>'''


class Handler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        if '?dl=1' in getattr(self, 'path', ''):
            clean_name = Path(urlsplit(self.path).path).name
            if clean_name:
                self.send_header('Content-Disposition', f'attachment; filename="{clean_name}"')
        super().end_headers()

    def send_head(self):
        clean_path = urlsplit(self.path).path
        if clean_path in ('/', '/index.html'):
            body = index_page().encode('utf-8')
            self.send_response(200)
            self.send_header('Content-Type', 'text/html; charset=utf-8')
            self.send_header('Content-Length', str(len(body)))
            self.send_header('Cache-Control', 'no-store')
            self.end_headers()
            return io.BytesIO(body)
        if '/.git' in clean_path or clean_path.startswith('/.venv'):
            self.send_error(404)
            return None
        return super().send_head()

    def log_message(self, fmt, *args):
        pass


class Server(ThreadingHTTPServer):
    allow_reuse_address = True
    daemon_threads = True

    def handle_error(self, request, client_address):
        import sys
        if isinstance(sys.exc_info()[1], (BrokenPipeError, ConnectionResetError)):
            return
        super().handle_error(request, client_address)


if __name__ == '__main__':
    ap = argparse.ArgumentParser()
    ap.add_argument('--port', type=int, default=8000)
    ap.add_argument('--bind', default='0.0.0.0')
    a = ap.parse_args()
    srv = Server((a.bind, a.port), partial(Handler, directory=str(R)))
    print(f'Aperçus : http://{a.bind}:{a.port}/  (racine {R})', flush=True)
    srv.serve_forever()
