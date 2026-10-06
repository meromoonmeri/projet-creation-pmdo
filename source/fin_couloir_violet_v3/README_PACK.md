# FCV3 — Fin Couloir violet : sanctuaire du sigil gravé

Nouvelle passe visuelle, plus spectaculaire, de la fin du Couloir violet : une vaste arène rocheuse violette, un sigil lumineux gravé dans le sol, une arche naturelle et un autel au nord. **FCV2 reste intacte** et demeure disponible comme version précédente.

## Prévisualisation

- Aperçu interactif autonome : `apercu_fin_couloir_violet_v3.html`
- Scène native : `review/FCV3_scene_t000.png`
- Vue agrandie 2× : `review/FCV3_scene_x2.png`
- Contrôle collision/repères : `review/FCV3_collisions_marqueurs.png`
- OpenRaster éditable : `.cache/fin_couloir_violet_v3/FCV3_calques.ora`

Dans l’aperçu HTML, les calques se masquent individuellement et le bouton de droite affiche les obstacles et les trois repères d’édition.

## Caractéristiques

- Canevas 768 × 576 px, format 4:3, grille 96 × 72 cellules, 8 px par cellule.
- Couches Ground : `00_sol_complet`, `01_sol`, `02_ombres`, `03_gravure_lumineuse`, `04_lueur_sigil`, `05_parois`, puis `06_top` vide.
- Entrée au sud, repère d’arène au centre du sigil, objectif au nord sous l’arche; aucun warp, sortie, personnage ou objet de gameplay n’est créé.
- Chemins calculés pour une empreinte 16 × 16 px depuis l’entrée jusqu’au centre et à l’objectif; collisions manuelles à valider dans le moteur.
- Couleurs quantifiées avec une palette commune de 96 couleurs, sans tramage. Le halo du sigil utilise une alpha graduée de 3 à 48/255; le codec Ground la prémultiplie. Le test compare donc le signal prémultiplié (écart maximal ≤ 1) plutôt que les RGB droits sous faible alpha.

## Références et choix de production

- Aucun visuel authentique de la salle finale n’avait été trouvé lors de la recherche précédente. `S05P03A` est une référence de matière/palette uniquement, pas un modèle canonique de la fin.
- `FCV2_decor.png` sert de repère de continuité spatiale. `bruts/decor.png` est une nouvelle composition générée, et non une retouche de FCV2.
- `bruts/sol_complet.png` reprend sans retouche le socle FCV2 et reste sous les calques opaques de la nouvelle composition.
- Le sigil, l’arche, l’autel, la mousse lumineuse, le biome de travail et le préfixe **FCV3** sont des choix de conception de l’agent; ils ne sont pas présentés comme des décisions canoniques de l’utilisateur.
- Les petites touches lilas périphériques sont traitées comme du lichen bioluminescent, pas comme des objets interactifs.

## Fichiers source

- `bruts/decor.png` — composition FCV3 générée, 1200 × 896 px.
- `bruts/sol_complet.png` — fond de base repris de FCV2, 1200 × 896 px.
- `reference/S05P03A.png` — rip de référence matière.
- `reference/FCV2_decor.png` — repère de continuité spatiale.
- `build.py`, `test_build.py`, `verify.py`, `package.py` — construction, tests, vérification et empaquetage.
- `generation.json` — provenance, méthode et état de revue.

## Construire et vérifier

Depuis la racine du dépôt :

```bash
.venv/bin/python source/fin_couloir_violet_v3/build.py
.venv/bin/python -m unittest source.fin_couloir_violet_v3.test_build -v
.venv/bin/python source/fin_couloir_violet_v3/verify.py
.venv/bin/python source/fin_couloir_violet_v3/package.py
```

Le constructeur produit un dossier PMDO 0.8.12 dans `.cache/fin_couloir_violet_v3/fin_couloir_violet_v3/`. Le paquet de projet et l’archive des PNG/calques sont créés dans `renders/fin_couloir_violet_v3/`.

## Limites et statut

- `art_approved: false` — la composition attend une validation visuelle finale de l’utilisateur.
- `runtime_tested: false` — PMDO n’a pas été lancé; le gameplay et le rendu moteur ne sont pas validés.
- Les fichiers `.tile` sont sérialisés et testés contre l’encodeur local, mais les pixels générés ne sont pas des tuiles originales certifiées.
- Les collisions sont des repères d’édition dérivés de polygones; les rochers périphériques et les chemins doivent être confirmés en jeu.
