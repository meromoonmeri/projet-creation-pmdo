# Méthode de production des maps PMD — générateur + pipeline natif

Synthèse opératoire de la série actuelle, après lecture de `AGENTS.md`, `REPRISE_MAPS.md`,
`METHODE_MAGENTA_ET_GENERATEUR.md`, du guide, du manuel et de l'outil PMD Sky.
Les contrats Métano et Guilde restent spécifiques à leurs lots.

## 1. Ne pas confondre les deux routes

**Route actuelle des nouveaux biomes : rendu généré référencé.** Le rip canonique est réellement
fourni au générateur en `images=[rip]`. Il fixe la matière, la palette, le style et l'échelle.
Le générateur invente un nouveau lieu. Le décor est découpé en calques, réduit par matière puis
encodé en formats natifs PMDO. Ses pixels restent **générés**, pas canoniques pixel à pixel.

**Route des pixels exacts** : si demandée explicitement, notamment pour une extension Métano,
utiliser des modules natifs complets avec provenance, sans rotation, miroir, resampling ou
recoloration de jour. Ne pas remplacer la route générée par un assemblage de bouts de maps.
Le filtre Abyss est une exception de nuit autorisée pour les lots concernés.

> **Format natif ≠ origine native des pixels.** Une banque `.tile` valide peut contenir un dessin
> généré. Elle ne prouve ni une extraction ROM, ni une validation artistique, ni un test moteur.

## 2. Préparer un nouveau lot

1. Lire les consignes et la reprise, examiner les lots voisins et les fichiers réellement disponibles.
   Le présent dépôt est une **extraction de méthodes** : de nombreux anciens bruts et ZIP manquent.
2. Vérifier les branches distantes, sans changer de branche de session ni fusionner les autres lots.
   Réutiliser uniquement le travail de la branche parente sauf demande contraire.
3. Choisir un identifiant unique, le biome, la référence, la fonction de la map et ses accès.
4. Lire le rip avant de générer. S'il vient de la ROM : épingler le commit, conserver code,
   BMA/BPC/BPL/BPA, blob Git et SHA-256. **Ne pas inférer un nom officiel à partir de `Dnn`.**
5. Standard : **768 × 576 px, 4:3 vaste, 96 × 72 cases de 8 px**. Pour les entrées, sud → nord.
   Pas de PNJ, artefact, structure ou script narratif non demandé.

Outil : `source/outil_maps_pmdsky/README.md` et `recuperer_maps.py`.
Sa commande `rom --only ...` peut réécrire l'index versionné : ne pas livrer un index global
involontairement remplacé par un sous-ensemble. On peut appeler `render()` et enregistrer le rendu
uniquement dans `reference/` du nouveau lot, comme pour EDR1.

## 3. Générer et séparer

1. Fournir le rip au générateur ; consigner les **prompts exacts** et les images de référence.
2. Générer le décor complet, avec magenta à la place des régions à remplacer/détourer.
3. Générer le sol complet séparément depuis le décor, pour un support continu sous les objets.
4. Mesurer les dimensions et les seuils sur les bruts. Rejeter un format incompatible plutôt que
   d'étirer l'image. Préserver les bruts et la géométrie approuvée.
5. Segmenter **avant réduction** : masques par matière/fonction, clef magenta par rapports de canaux
   et prise en compte des franges. Documenter les contours relevés à la main.
6. Réduire à facteur uniforme : BOX pondéré par classe, vote pour la classe gagnante, aucun mélange
   entre matières. Palette commune sans dither, sauf groupes de matière séparés justifiés.
7. Exporter les PNG en RGBA à alpha propre, dimensions divisibles par 8, préfixes uniques.
   RGB nuls sous alpha nul ; pas de magenta résiduel.
8. Garder chaque animation sur son calque. Documenter sa loi, son origine, ses couleurs, ses phases
   et sa cadence. Une animation recalculée aux couleurs du rip n'est pas une animation officielle.

## 4. Contrôler et construire le projet PMDO

- Fidélité : même classifieur sur rip, brut et sortie, nombre de pixels suffisant, distance de
  couleur sous le seuil annoncé (en général 35 ; certaines matières ont un seuil plus strict).
- Collisions sur grille 8 px, accès vérifiés avec un dégagement 16 × 16 px. Marqueurs explicites.
  Une fin n'a ni warp ni sortie. Une entrée peut avoir un seuil sans destination liée.
- Un banc `.tile` par calque, index natif fusionnable, Ground `.rsground`, `TexSize=1`, Top vide
  en `Layer=4`, `Mod.xml`, script d'initialisation sans gameplay ajouté et installateur protecteur.
- Partir d'un **gabarit réel dont la version est vérifiée**, sans dépendance cachée à un ZIP absent.
  Remplacer les anciennes références graphiques, entités, décorations et collisions.
- Relire les banques et reconstruire les images depuis le Ground : la seule relecture du JSON
  ou un test des PNG en amont ne vérifie pas l'encodage des textures.
- Tester l'installateur : dry-run sans écriture, fusion de l'index, idempotence, refus d'écrasement.
- Tester les défauts par mutations dans une copie temporaire, jamais sur les livrables.

## 5. Livrer sans surpromettre

Sources, provenance, bruts, générateur, tests, vérificateur indépendant, packager et notice sont
versionnés. PNG de rendu, ZIP, HTML autonome et caches sont régénérables et restent hors Git.
Fournir un aperçu visible, le projet PMDO et les calques ; documenter les résultats et les limites.

`art_approved: false` tant que l'utilisateur n'a pas approuvé. `runtime_tested: false` tant que le
vrai moteur n'a pas été exécuté sur ce lot. Un chargement sans GPU ne valide pas l'affichage,
les collisions en mouvement ou les animations en jeu.

## Lot de reprise : EDR1, Défilé des Roches grises

Référence ROM D46P11A, statique, nouveau nom descriptif ; aucune fusion des branches sœurs.
Voir [la notice complète](source/entree_defile_roches_grises_v1/README_PACK.md).

```sh
python -m venv .venv
.venv/bin/pip install -r source/entree_defile_roches_grises_v1/requirements.txt
.venv/bin/python source/entree_defile_roches_grises_v1/build.py
.venv/bin/python -m unittest source.entree_defile_roches_grises_v1.test_build -v
.venv/bin/python source/entree_defile_roches_grises_v1/verify.py
.venv/bin/python source/entree_defile_roches_grises_v1/package.py
```

Sorties : `renders/entree_defile_roches_grises_v1/` ; `index.html` est autonome.
Pour l'aperçu et les téléchargements, servir **ce dossier seulement**, pas la racine du dépôt :

```sh
python -m http.server 8000 --bind 0.0.0.0 --directory renders/entree_defile_roches_grises_v1
```

En session Arena, lancer ce serveur avec l'outil de processus persistant. Les ZIP sont accessibles
sur le même hôte, avec des URL relatives ; aucune URL navigateur ne pointe vers `localhost`.
