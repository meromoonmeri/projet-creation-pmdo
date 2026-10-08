# Workflow — série sud → nord

Complète [WORKFLOW.md](../../WORKFLOW.md) (session) pour **cette** série seulement.

## Relancer un lot déjà livré

Les PNG ne sont pas dans cette extraction. Ordre :

1. Récupérer le rip (racine de `projet-pmdo`) et `source/<lot>/bruts/`.
2. Recréer `.venv` (Pillow 12.3, NumPy 2.4, SciPy 1.17).
3. Lire le `WORKFLOW.md` **du lot** (seuils `classify`, fenêtres de poses, fidélité).
4. `.venv/bin/python source/<lot>/build.py` — réécrit `renders/<lot>/` et `.cache/<lot>/`.
5. Un rebuild change les horodatages ZIP de l’ORA : si les 16 membres sont identiques,
   **restaurer** le `.ora` versionné.
6. `.venv/bin/python -m unittest source.<lot>.test_build -v` puis `package.py`.

Les tests relisent le Ground dans `.cache/` : un test sans rebuild préalable échoue
souvent par cache manquant, pas par régression.

## Créer la carte suivante (fin ou entrée)

1. Confirmer le biome dans [STATUS.md](STATUS.md) (ou demander si la consigne est ambiguë).
2. Choisir un **préfixe libre** (table STATUS + `git grep PFX`).
3. Copier le gabarit :
   - entrée → `entree_jungle_sud_nord_v1` ;
   - fin → `fin_jungle_sud_v1` / `fin_star_cave_v1` (structure Ground + tests).
4. Remplacer `PFX`, `NAMESPACE`, `ASSET`, `OUT`, `STAGE`, `REF`, liste `GEN`.
5. Générer les bruts avec le rip en référence (prompts dans `GEN`, consigne 4:3 1200 × 896).
6. Mesurer les couleurs du brut, écrire `classify()`, seuils commentés.
7. Recaler le sol (0, 0). Réutiliser les planches d’animation du jumeau si même biome.
8. Marqueurs : entrée = `entrance` + `donjon_seuil` ; fin = `entrance` + `boss` + `objectif`.
9. Fidélité matière principale vs rip, seuil 35 (40 documenté pour Waterfall / Horn).
10. Tests, paquet, journal, `REPRISE_MAPS.md`, commit sur la branche de session.

## Outils `loadmod` (ne pas recopier)

Le builder Jungle importe Bristle ; les fins importent Jungle et souvent
`fin_vapeur_sommet_v1` (helpers Ground). Régler `BM.W, BM.H` **avant** d’appeler
`cell_grid` / `write_ora`.

## Ce que cette extraction ne permet pas

Sans `bruts/` et sans le rip, on peut **écrire** la méthode (prompts, calques, tests)
mais pas **produire** les PNG ni faire passer `test_build.py`. C’est volontaire :
ce dépôt pèse 2,7 % de `projet-pmdo`.
