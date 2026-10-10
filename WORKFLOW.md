# Workflow de création de maps — PMDO 0.8.12

Ce document est le **parcours opératoire** pour produire une nouvelle map, de la demande
jusqu'au projet PMDO installable. Il ne remplace pas les sources de référence ; il dit
dans quel ordre les utiliser :

| Document | Quand le lire |
|---|---|
| [GUIDE_CREATION_DE_MAP.md](GUIDE_CREATION_DE_MAP.md) | Formats, tailles, calques, markers, tests |
| [METHODE_MAGENTA_ET_GENERATEUR.md](METHODE_MAGENTA_ET_GENERATEUR.md) | Détourage magenta, segmentation, réduction, palette |
| [AGENTS.md](AGENTS.md) | **Règles de production approuvées** (textures canoniques, Métano, import) — à lire en entier avant toute map |
| [REPRISE_MAPS.md](REPRISE_MAPS.md) | État de la série sud → nord, préfixes pris, branches sœurs |
| [MANUEL_METHODE_PMDO.md](MANUEL_METHODE_PMDO.md) | Contrat artistique, limites du moteur, état des livraisons |
| [INDEX_METHODES.md](INDEX_METHODES.md) | Tableau des sous-projets (générateur, tests, package) |

---

## 0. Avant de commencer (préparation)

1. **Lire la demande** et noter ce qui est explicite : biome, référence, format, nombre de lots,
   nuit/jour, animations. Ce qui n'est pas explicite se signale comme **« biome choisi par l'agent, à confirmer »**.
2. **Vérifier la branche de session.** Travailler uniquement sur la branche de session
   (`arena/<session>`). Ne jamais pousser sur une autre branche.
3. **Vérifier les branches sœurs.** `git ls-remote --heads origin` puis, pour les têtes `arena/*` récentes,
   `git grep -l <nom_de_la_référence> origin/<branche>`. Une référence déjà utilisée ailleurs doit être
   signalée. Ne jamais fusionner ni reprendre du travail d'une branche sœur sans accord.
4. **Choisir un préfixe unique** (ex. `EXX1`) et le comparer à la liste « préfixes pris » de
   `REPRISE_MAPS.md`. Les fichiers `PFX_*` sont nommés par *basename* dans PNG to Tileset : deux lots
   avec le même préfixe s'écrasent.
5. **Choisir la référence canonique** : rip PMD (racine du dépôt ou `pret/`), en vérifiant qu'il n'est
   pas déjà pris comme entrée de la série.
6. **Environnement** : `.venv` (Pillow ≈ 12.3, NumPy ≈ 2.4, SciPy ≈ 1.17, `source/requirements.txt`).
   `.venv` et `.cache/` ne sont pas versionnés.

## 1. Choisir la méthode

Deux méthodes coexistent. Les choisir **selon la map**, pas par défaut :

| Méthode | Usage | Ce qui est vrai |
|---|---|---|
| **A. Rendu généré référencé** (méthode courante des entrées sud → nord) | Nouvelles maps, biomes de la série | Le rip est passé au générateur en `images=[rip]`. Textures et palette *inspirées* du rip, fidélité mesurée. **Pas des pixels natifs.** |
| **B. Pixels natifs exacts** (Métano, `natifs/`, import PNG to Tileset) | Extensions de Métano, lots d'import moteur | Prélèvements documentés, modules complets, pas de rotation/miroir/recoloration. |

Une demande de « textures canoniques » suit la méthode **A**, sauf si l'utilisateur nomme explicitement
la méthode B. Annoncer dans chaque livrable l'origine de chaque matériau.

## 2. Composition (rendu généré)

Dans `renders/<lot>/bruts/` :

1. `decor_magenta.png` — décor complet, eau/lave/vide en **magenta**, cadrage « WIDE LANDSCAPE 4:3, zoomed out » (≈ 1200 × 896), rip en `images=`.
2. `sol_complet.png` — même cadrage, sol seul (à défaut : quilting depuis le sol du décor).
3. Une **planche de poses** pour l'animation propre au biome.

Le générateur respecte rarement une grille demandée : choisir les cases à la main. Si rien ne revient, relancer
avec un prompt plus court. Un brut non conforme est **écarté**, pas corrigé en silence.

## 3. Segmentation, réduction, palette

1. **Détourer** le magenta par rapport de canaux (`r > 1.45 g`, `b > 1.45 g`, frange antialiasée).
2. **Segmenter en pleine résolution** (`classify`) en masques de matières (eau, roche, berge, sable, végétation…), seuils mesurés et commentés. **Jamais** l'image entière réduite avant segmentation.
3. **Réduire par classe** (`down_class`) à facteur uniforme (×576/896, recadrage centré à **768 × 576**), moyenne par classe, aucun mélange entre matières.
4. **Palette commune de 96 couleurs** (MEDIANCUT, sans dither) ; palettes séparées pour les matières qui changent (arbres, cristaux).
5. **Fidélité** : moyenne RGB de la matière principale contre le rip, sous un seuil documenté (≈ 35 à 40 selon le lot ; ex. Amp 9,6 ; Waterfall 17,0 ; Horn 34,8). Noter les valeurs dans le `README_PACK.md`.

## 4. Calques et animation

Un calque **par fonction**, du bas vers le haut, plus un calque **Top vide** (`Layer=4`) au-dessus.

- Ordre type : eau/mare → scintillements → sol complet → sol secondaire → chemin/berge → rochers → végétation → décor sombre (entrée) → animations → Top.
- **Eau** : au moins 4 phases cohérentes (ex. 4 × 10 ticks, façon Métano). Pas de fond d'eau statique présenté comme animé.
- **Animations** : chacune sur **son propre calque**, taille constante, cadence documentée, boucle fermée testée **dernière → première comprise**. Scène au PPCM des cadences (ex. 240 ticks = 4 s).
- Une animation générée n'est pas un « cycle officiel récupéré ». Le dire.

## 5. Markers, collisions, accès

- `entrance` au **sud**, sur le sentier. `donjon_seuil` sous la bouche d'entrée (au nord). `boss` au centre (arènes). `objectif` au nord (fins de donjon).
- **Aucun warp** sans demande explicite. Une fin de donjon n'a ni sortie ni warp.
- Collisions : `cell_grid` (case bloquée si plus de 25 % non praticable), puis **BFS** (`reachable`) pour un chemin libre de **16 × 16 px** de l'entrée jusqu'à la destination.
- Fournir la vue `review/<PFX>_collisions_marqueurs.png`. Mention « à contrôler en jeu ».
- Collisions, occlusion et gameplay **ne se déduisent jamais** des seuls contrôles d'images.

## 6. Exports et manifeste

Dans `renders/<lot>/` :

- `PFX_NN_nom.png` — un PNG par calque, transparent, **taille divisible par 8**, sans rééchantillonnage.
- `animation/<effet>/` — frames par effet, `Top` inclus.
- `masques/`, `ORA` éditable, `review/` (scène t000, WebP, collisions).
- `manifest.json` — hashes des bruts, normalisation, origine de chaque matière, cadence, marqueurs, et les deux drapeaux **`art_approved: false`** et **`runtime_tested: false`** tant qu'une validation n'est pas faite.

## 7. Projet PMDO 0.8.12

Dans `source/<lot>/` (copier le gabarit `source/entree_jungle_sud_nord_v1/`) :

- une banque `.tile` par calque (`source/pmdo_cote/build.py`, `TileBank`, `layer`, `save`) ;
- un calque Top vide, `index.idx`, `Mod.xml`, script d'init `init.lua`, `.rsground` ;
- `INSTALLER.py` (fusion d'index avec sauvegarde de l'ancien) ;
- staging dans `.cache/<lot>/`.

Installation : copier le projet dans `PMDO/MODS/` ; dans un mod existant :
`python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis sans `--dry-run`.

## 8. Tests, vérification, paquet

```sh
.venv/bin/python source/<lot>/build.py                   # génère renders/<lot>/ (relit le Ground dans .cache)
.venv/bin/python -m unittest source.<lot>.test_build -v  # formats, cadence, alpha, provenance
.venv/bin/python source/<lot>/verify.py                  # contrôle aveugle des sorties (si présent)
.venv/bin/python source/<lot>/package.py                 # ZIP projet PMDO, ZIP calques, aperçu HTML
```

Attention : certains anciens builders écrivent leurs exports **dès l'import**. Lire le code avant de les importer.
Un rebuild réécrit les ZIP de l'ORA avec de nouveaux horodatages : restaurer le fichier s'il n'a pas d'autre changement.

Un test Python **n'est pas** un test moteur. Le test PMDO réel se fait avec `source/pmdo_runtime/`
(chargeur PMDO 0.8.12, sans affichage) et doit être annoncé séparément.

## 9. Documentation du lot (obligatoire)

Chaque lot livre :

- `source/<lot>/README_PACK.md` — installation, calques, marqueurs, limites ;
- `source/<lot>/WORKFLOW.md` *(si le lot a une méthode propre)* — sinon renvoyer à ce fichier ;
- une entrée dans `REPRISE_MAPS.md` (préfixe, référence, biome « à confirmer », tests) ;
- une ligne dans `INDEX_METHODES.md` ;
- la mise à jour de `README.md` si le lot change la série ou la méthode.

## 10. Livraison et honnêteté

Présenter un **aperçu visible** (`apercu_<lot>.html`, PNG par calque, galerie) avant de présenter un Ground.
Dire explicitement :

- ce qui est **généré** (inspiré du rip), ce qui est **natif** (copié de Métano ou d'une ROM) ;
- ce qui n'a **pas** été testé : rendu GPU, collisions en mouvement, gameplay, import moteur ;
- ce qui est **à confirmer** (biome, direction artistique, emplacement de l'entrée).

Ne pas dire « validé » ni « pixel-exact » sans preuve. Les aperçus approuvés ne valent pas validation à l'import.

## Checklist rapide (une map)

- [ ] Demande lue, points à confirmer notés
- [ ] Branche de session vérifiée, branches sœurs relevées
- [ ] Préfixe unique, référence non prise
- [ ] Méthode choisie (A ou B) et annoncée
- [ ] Bruts générés, segmentés, réduits à 768 × 576 (ou format demandé)
- [ ] Fidélité mesurée et notée
- [ ] Calques bas → haut + Top vide ; animations en boucle fermée
- [ ] Markers et collisions ; chemin 16 × 16 prouvé
- [ ] `manifest.json` avec `art_approved` / `runtime_tested`
- [ ] Projet PMDO 0.8.12, `INSTALLER.py`
- [ ] Tests passés et annoncés comme tests Python
- [ ] Documentation du lot, `REPRISE_MAPS.md`, `INDEX_METHODES.md`
- [ ] Aperçu HTML présenté, limites écrites
