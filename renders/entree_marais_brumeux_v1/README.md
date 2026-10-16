# EMB1 — Entrée des Marais brumeux

Nouveau biome choisi : marais. 768×576 / grille8px /96×72 / TexSize1. Neuf calques +Top vide.
Pixels générés avec référence Murky Forest fournie ; pas des pixels officiels exacts.
Vase, ombres, berges, racines, feuillage et profondeur dessinée séparés ; eau et brume sur
pistes indépendantes24×5ticks. Brume tramée à alpha binaire, clippée sur eau ; pas opacité moteur.
Sud→seuil nord avec passage16×16, aucun warp/destination/boss/PNJ/objet ajouté.
`art_approved=false`, `runtime_tested=false`, `render_tested=false` ; tests Python ≠ vrai PMDO.

Projet : extraire EMB1_projet_pmdo_0812.zip dans MODS, activer et ouvrir
`emb1_entree_marais_brumeux`. Pour fusionner, fermer PMDO puis exécuter INSTALLER.py vers
le mod cible, d'abord avec --dry-run. Index fusionné/sauvegardé ; fichiers modifiés protégés.
Import PNG manuel à **8px**, sans resampling. Le sol complet est un support non aligné,
la surface visible vient du décor généré partitionné. ORA = phase0 de chaque calque, PNG =24phases.
Référence forestière, eau et brume inventées. Avis artistique et contrôle dans PMDO attendus.
