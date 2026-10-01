#!/usr/bin/env python3
"""Génère les index du dépôt projet-creation-pmdo à partir de l'arbre Git de projet-pmdo
et des fichiers effectivement extraits.

Entrées : /tmp/projet.json (arbre récursif de meromoonmeri/projet-pmdo@main), /tmp/selection.json
Sorties : INDEX_METHODES.md, MANIFESTE_EXTRACTION.md, INVENTAIRE_FICHIERS.txt
"""
import json, collections, datetime, pathlib, os

REPO = pathlib.Path('/home/user/projet-creation-pmdo')
TREE = json.load(open('/tmp/projet.json'))['tree']
SELECTION = set(json.load(open('/tmp/selection.json')))
SHA = '6cca4a09380211e510ab1bea454a1b1926ef4b5a'
DATE = datetime.date.today().isoformat()

blobs = [e for e in TREE if e['type'] == 'blob']
taille_originale = {e['path']: e.get('size', 0) for e in blobs}

# ---------------------------------------------------------------- familles
FAMILLES = [
    ("Entrées de donjon sud→nord", ("entree_",)),
    ("Fins de donjon / arènes de boss", ("fin_",)),
    ("Arènes", ("arene_", "arena_")),
    ("Falaises, côtes et matière Métano", ("cote_", "falaise", "falaises_")),
    ("Métano (matière, import, calibration)", ("metano", "metano_")),
    ("Donjons générés / DTEF / autotiles", ("donjon", "dungeon_", "dtef")),
    ("Zones, relayouts, biomes", ("zone_", "zones_", "biome", "relayout")),
    ("Guilde, café, intérieurs", ("cafe_", "guild", "guilde", "maisons", "casino_", "spinda", "sakura", "crooked")),
    ("Plages, eau, océan", ("beach_", "plage", "eau_", "waterfall", "siphons", "cascades", "lake")),
    ("Aurores boréales / glace / ciel", ("boreale", "boreal", "glace", "aurore", "ciel_", "sky")),
    ("Monts, tours, panoramas", ("mont_", "tours_", "spring", "soleil_", "panorama", "caps_", "colonnes_")),
    ("Pokémon, sprites, mécaniques", ("pokemon", "mega_", "transformations", "sprite", "tera_", "audit_", "sprite_audit")),
    ("Runtime PMDO, outils, références", ("pmdo_runtime", "runtime", "references", "regles_", "layout", "outil", "tools")),
]

def famille(nom):
    for libelle, prefixes in FAMILLES:
        if any(nom.startswith(p) for p in prefixes):
            return libelle
    return "Autres projets"

# ---------------------------------------------------------------- inventaire source/
source_dirs = collections.defaultdict(list)
for e in blobs:
    if e['path'].startswith('source/'):
        p = e['path'].split('/')
        if len(p) > 2:
            source_dirs[p[1]].append(e['path'])

def extraits(paths):
    return [p for p in paths if p in SELECTION]

def cles(paths, dossier):
    """Marqueurs de méthode présents dans un sous-projet."""
    noms = {p.rsplit('/', 1)[-1] for p in paths if p.startswith(dossier + '/')} | \
           {p.rsplit('/', 1)[-1] for p in paths}
    marq = []
    for f, lbl in [('build.py', 'build'), ('package.py', 'package'), ('verify.py', 'verify'),
                   ('test_build.py', 'test'), ('INSTALLER.py', 'installer'),
                   ('provenance.json', 'provenance'), ('requirements.txt', 'req'),
                   ('README_PACK.md', 'PACK'), ('README.md', 'README'), ('STATUS.md', 'STATUS'),
                   ('WORKFLOW.md', 'WORKFLOW'), ('AUDIT.md', 'AUDIT'), ('CONTINUITE.md', 'CONTINUITE'),
                   ('gallery.py', 'gallery'), ('serve.py', 'serve'), ('viewer_template.html', 'viewer')]:
        if f in noms:
            marq.append(lbl)
    if any(p.endswith('.rsground') for p in paths):
        marq.append('**Ground**')
    if any(p.endswith('.tile') for p in paths):
        marq.append('**tileset**')
    if any('/references/' in p for p in paths):
        marq.append('réf.')
    return ' · '.join(marq)

groupes = collections.defaultdict(list)
for nom, paths in source_dirs.items():
    ext = extraits(paths)
    taille_ext = sum(taille_originale.get(p, 0) for p in ext)
    taille_tot = sum(taille_originale.get(p, 0) for p in paths)
    groupes[famille(nom)].append((nom, len(ext), len(paths), taille_ext, taille_tot, cles(ext, 'source/' + nom)))

# ---------------------------------------------------------------- INDEX_METHODES.md
ordre = [f[0] for f in FAMILLES] + ["Autres projets"]
lignes = [f"# Index des méthodes — {len(source_dirs)} sous-projets de `source/`",
          "",
          f"Extrait de [`meromoonmeri/projet-pmdo`](https://github.com/meromoonmeri/projet-pmdo) "
          f"au commit [`{SHA[:7]}`](https://github.com/meromoonmeri/projet-pmdo/commit/{SHA}) — {DATE}.",
          "",
          "Chaque sous-projet est un **chantier de map autonome** : il contient son générateur, ses tests,",
          "sa documentation et, quand il existe, ses données PMDO natives (`.rsground`, `.tile`).",
          "",
          "Colonne **Méthode** : `build` = générateur du rendu, `test` = tests de build, `verify` = vérification",
          "aveugle des sorties, `package` = fabrication du pack importable, `installer` = installation dans un mod,",
          "`provenance` = traçabilité des références, `Ground`/`tileset` = données natives PMDO présentes.",
          ""]
for g in ordre:
    items = sorted(groupes.get(g, []))
    if not items:
        continue
    tot_f = sum(i[1] for i in items)
    tot_mb = sum(i[3] for i in items) / 1024 / 1024
    lignes += [f"## {g} — {len(items)} projets · {tot_f} fichiers extraits · {tot_mb:.0f} Mo", "",
               "| Sous-projet | Méthode | Fichiers extraits | Mo |", "|---|---|---:|---:|"]
    for nom, n_ext, n_tot, t_ext, t_tot, marq in items:
        lignes.append(f"| `source/{nom}/` | {marq or '—'} | {n_ext}/{n_tot} | {t_ext/1024/1024:.1f} |")
    lignes.append("")
(REPO / 'INDEX_METHODES.md').write_text('\n'.join(lignes) + '\n', encoding='utf-8')

# ---------------------------------------------------------------- MANIFESTE_EXTRACTION.md
sel_entries = [e for e in blobs if e['path'] in SELECTION]
tot_ext = sum(e.get('size', 0) for e in sel_entries)
tot_orig = sum(e.get('size', 0) for e in blobs)
def cat(p):
    n = p.rsplit('/', 1)[-1]
    x = ('.' + n.rsplit('.', 1)[-1].lower()) if '.' in n else ''
    if x in ('.rsground', '.tile', '.tmj', '.tsj', '.chara', '.dir', '.npz', '.idx'):
        return 'Données PMDO natives / Tiled'
    if x in ('.py', '.cjs', '.js', '.tsx', '.lua', '.cs', '.sh'):
        return 'Scripts et code'
    if x == '.md':
        return 'Documentation'
    if x in ('.json', '.xml', '.yml', '.yaml', '.csv', '.txt', '.cfg', '.ini', '.toml', '.jsonpatch'):
        return 'Règles, configs, provenance'
    if x == '.html':
        return 'Visionneuses HTML'
    return 'Assets légers (PNG des kits, gabarits)'
par_cat = collections.Counter(); par_cat_n = collections.Counter()
for e in sel_entries:
    par_cat[cat(e['path'])] += e.get('size', 0); par_cat_n[cat(e['path'])] += 1

par_top = collections.Counter(); par_top_n = collections.Counter()
for e in sel_entries:
    t = e['path'].split('/')[0] if '/' in e['path'] else '(racine)'
    par_top[t] += e.get('size', 0); par_top_n[t] += 1
exclus = collections.Counter(); exclus_n = collections.Counter()
for e in blobs:
    if e['path'] in SELECTION:
        continue
    t = e['path'].split('/')[0] if '/' in e['path'] else '(racine)'
    exclus[t] += e.get('size', 0); exclus_n[t] += 1

M = [f"# Manifeste d'extraction",
     "",
     f"- **Source** : `meromoonmeri/projet-pmdo` @ [`{SHA}`](https://github.com/meromoonmeri/projet-pmdo/commit/{SHA}) (branche `main`)",
     f"- **Date d'extraction** : {DATE}",
     f"- **Dépôt source** : {len(blobs)} fichiers, {tot_orig/1024**3:.2f} Go",
     f"- **Extrait ici** : {len(sel_entries)} fichiers, {tot_ext/1024**2:.1f} Mo — soit {100*tot_ext/tot_orig:.1f} % du volume",
     f"- **Non extrait** : {len(blobs)-len(sel_entries)} fichiers, {(tot_orig-tot_ext)/1024**3:.2f} Go (images de rendu, archives, aperçus HTML)",
     "",
     "## Méthode d'extraction",
     "",
     "Clone *blobless* + *sparse-checkout* : Git ne télécharge que les blobs demandés,",
     "jamais les 6 Go. Reproductible avec `OUTILS/extraire_depuis_projet-pmdo.py`.",
     "",
     "## Contenu extrait par catégorie", "",
     "| Catégorie | Fichiers | Mo |", "|---|---:|---:|"]
for k, v in par_cat.most_common():
    M.append(f"| {k} | {par_cat_n[k]} | {v/1024**2:.1f} |")
M += ["", "## Contenu extrait par dossier", "", "| Dossier | Fichiers | Mo |", "|---|---:|---:|"]
for k, v in par_top.most_common():
    M.append(f"| `{k}` | {par_top_n[k]} | {v/1024**2:.1f} |")
M += ["", "## Volontairement NON extrait (récupérable à la demande)", "",
      "| Dossier | Fichiers | Go | Contenu |", "|---|---:|---:|---|"]
DESCR = {'renders': "rendus PNG/GIF/WebP des maps, aperçus HTML, ZIP d'étapes",
         'exports': "exports PNG et planches, quelques JSON/CSV repris ici",
         'sprites': "planches de sprites et découpes PNG",
         '(racine)': "archives ZIP livrées, aperçus HTML, images de référence PMD",
         'source': "PNG de travail des sous-projets (gabarits, découpes)",
         'salles': "PNG/Aseprite des 12 salles (extrait sauf Aseprite)",
         'calques': "PNG des calques (extraits)"}
for k, v in exclus.most_common():
    if v < 1024:
        continue
    M.append(f"| `{k}` | {exclus_n[k]} | {v/1024**3:.2f} | {DESCR.get(k, '—')} |")
M += ["", "## Récupérer ce qui manque", "",
      "```sh", "# un fichier précis, sans cloner :",
      "curl -L -o fichier.png \\",
      f"  https://raw.githubusercontent.com/meromoonmeri/projet-pmdo/{SHA}/renders/exemple/fichier.png",
      "```", "",
      "Ou relancer l'extraction avec `--avec-media` (voir `OUTILS/extraire_depuis_projet-pmdo.py`),",
      "ou un `git sparse-checkout add renders/mon_dossier` dans un clone blobless.", ""]
(REPO / 'MANIFESTE_EXTRACTION.md').write_text('\n'.join(M), encoding='utf-8')

# ---------------------------------------------------------------- INVENTAIRE_FICHIERS.txt
I = [f"# Inventaire exhaustif — {len(sel_entries)} fichiers extraits",
     f"# source : meromoonmeri/projet-pmdo @ {SHA}", ""]
for e in sorted(sel_entries, key=lambda x: x['path']):
    I.append(f"{e.get('size', 0):>10}  {e['path']}")
(REPO / 'INVENTAIRE_FICHIERS.txt').write_text('\n'.join(I) + '\n', encoding='utf-8')
print("INDEX_METHODES.md, MANIFESTE_EXTRACTION.md, INVENTAIRE_FICHIERS.txt générés")
print(f"source/ sous-projets : {len(source_dirs)}")
