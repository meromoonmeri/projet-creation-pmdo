# Récupération — Entrée Tour Temporelle V2 (ETT2)

Origine : commit `934a1b4e9b5a9875362ef394798ceef80db67867` (`Add files via upload`, 14 octobre 2026). Les fichiers source ETT2 étaient à la racine au lieu de `source/entree_tour_temporelle_sud_nord_v2/` ; ils sont replacés dans ce dossier afin que les chemins `HERE.parents[1]`, `bruts/` et `viewer_template.html` correspondent au code.

## Bruts restaurés

- `bruts/decor_magenta.png` ← ancien `decor_magenta (4).png`. L’attribution a été corrigée après lecture du `build.py` et contrôle de palette : ce blob donne exactement les mesures inscrites au `STATUS.md` (`2.7`, `0.5`, `8.7`, `3.5`), contrairement au fichier anciennement placé ici.
- `bruts/sol_complet.png` ← ancien `sol_complet (2).png` (dallage ardoise/noir).
- `bruts/nuages_magenta.png` ← ancien `nuages_magenta.png` (bandes cramoisi/noir sur magenta).
- `bruts/alternatives/decor_magenta_alternative_2.png` ← ancien `decor_magenta (2).png`.
- `bruts/alternatives/decor_magenta_alternative_3_veines_rouges.png` ← ancien `decor_magenta (1).png` (variante à veines rouges, archivée et non retenue pour le brief noir-or). Tous les blobs sources sont conservés sans retouche des pixels.

Les autres scripts et notices du commit ont été remis dans ce dossier. `OUTILS/generer_workflows_chantiers.py` a été replacé sous le chemin `OUTILS/` indiqué dans son usage.

## Reconstruction et limites (14 octobre 2026)

Après correction de l'attribution ci-dessus, `build.py` a été exécuté avec le décor ETT2 exact, le sol noir d'ardoise et les nuages rouge/noir. Il a reconstruit les 14 calques, les animations, les masques, l'ORA, le Ground de staging, le manifeste et la revue sous `renders/entree_tour_temporelle_sud_nord_v2/`. `package.py:build_html()` a produit `apercu_entree_tour_temporelle_sud_nord_v2.html`; le WebP de scène boucle sur 48 images à 768 × 576.

Les sorties concordent avec les mesures historiques du `STATUS.md` : fidélité `[2.7, 0.5, 8.7, 3.5, 1.3, 10.1]`, chemin 16 × 16 accessible, 10 brèches et 0 pixel de brèche sur le chemin. La reconstruction comprend ciel d'abîme rouge-noir, nuages dérivants, reflets arc-en-ciel, circuits d'or, rochers flottants et éclats prismatiques.

Les références ROM D29P11A et D30P34A et les exports/source ETT1 ne sont pas présents. Le manifeste les marque comme indisponibles, sans les remplacer. Le statut reste `art_approved = false` et `runtime_tested = false`. Le 16/10/2026, `build.py` et `package.py` ont été rejoués ; les 14 vérifications de sortie passent après adaptation des préconditions pour tester explicitement l'absence des références. Cela ne valide ni la conservation complète de V1 ni la fidélité canonique ; ces limites restent visibles dans le manifeste.
