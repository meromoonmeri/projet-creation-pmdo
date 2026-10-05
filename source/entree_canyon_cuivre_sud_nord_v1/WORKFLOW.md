# Workflow EOC1 — Entrée du Canyon Cuivré

## Décisions

- Type choisi : entrée de donjon, arrivée au sud et seuil au nord.
- Composition : canyon de roches cuivrées, large sentier ocre sinueux et bouche sombre au nord. « Canyon Cuivré » est un nom de travail choisi par l'agent, pas une préférence explicitement formulée.
- Composition générée retenue : option 1 (choix de l'utilisateur).
- Référence PMD Sky : `D55P11A`, commit de source épinglé dans `source/outil_maps_pmdsky/README.md`. Le code seul est utilisé ; le nom de donjon n'est pas supposé.
- Taille cible : 768 × 576 px, 96 × 72 cases, 8 px par case.
- Identifiants : lot `entree_canyon_cuivre_sud_nord_v1`, préfixe libre `EOC1`, namespace `entree_canyon_cuivre`, asset `eoc1_entree_canyon_cuivre`.

## Étapes

1. Garder les deux bruts générés (`bruts/decor.png`, `bruts/sol_complet.png`) et enregistrer leurs empreintes SHA-256, leurs dimensions et les prompts.
2. Normaliser le décor en 4:3 sans déformation ; réduire à 768 × 576 sur la grille.
3. Séparer le sol, les ombres, les parois, les rochers, la végétation, la profondeur de grotte et la poussière animée. Détecter automatiquement les plantes par masque RGB (`g > r+10`, `g > b+10`) et composantes connexes — ne pas saisir leurs coordonnées à la main. Les fenêtres manuelles ne concernent que les amas de rochers. La bouche sombre est isolée comme matte ; ne pas prétendre que le générateur a produit une matte magenta s'il n'en a pas produit.
4. Quantifier les calques de terrain avec une palette commune sans tramage ; garder l'alpha strictement binaire.
5. Générer les phases de poussière sur un calque transparent indépendant ; contrôler la boucle et la palette.
6. Définir les collisions et trouver les marqueurs sur la grille, puis prouver l'accessibilité avec une empreinte 2 × 2 cases.
7. Écrire le Ground PMDO 0.8.12, les banques `.tile`, l'`index.idx` autonome et l'installeur fusionnant l'index sans remplacer celui d'un mod existant.
8. Exécuter tests, vérification indépendante, paquet ZIP et contrôle visuel du rendu à 1×.

## Limites

La référence originale n'est pas versionnée avec le lot ; elle est récupérable par `source/outil_maps_pmdsky/recuperer_maps.py`. Les rendus d'IA sont des guides graphiques, pas des tuiles natives. Aucune validation PMDO graphique ou de gameplay n'est revendiquée.
