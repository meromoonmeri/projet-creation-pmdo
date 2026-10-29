# Bitter Blade / Lame en Peine — PMDO 0.8.12

## Fichiers livrés

- Donnée PMDO à importer : `Data/Skill/bitter_blade.json`.
- Illustration VFX générée : `assets/bitter_blade_vfx.png` (sortie brute du générateur) et `assets/bitter_blade_vfx_cutout.png` (découpe avec alpha, prête pour un pipeline d’images).
- Aperçu animé : `exports/illustrations/bitter_blade/bitter_blade_vfx_preview.gif`.
- Scripts reproductibles : `prepare_vfx.py`, puis `build_preview.py`.

## Données de capacité

L’entrée amont `Data/Skill/bitter_blade.json` (PMDO 0.8.12, commit `3e767571f9dd94270b848b3a73de9bec2553a2eb`) était déjà présente, mais avec `Released:false`, sans soin par absorption et sans VFX. La version livrée conserve son index 891, son type Feu, sa catégorie physique, sa puissance 90, son taux de réussite de 100 %, son unique frappe et ses 10 charges; elle ajoute `ContactState`, `HealState` et l’évènement `HPDrainEvent` avec `DrainFraction:2` pour rendre la moitié des dégâts sous forme de PV.

La structure d’animation suit les données existantes d’Audinowho : `AttackAction` et particule de lame native `Slash_RSE` (modèle de Tranch’Aqua), puis `FiniteGatherEmitter` avec `Absorb` et `DUN_Absorb` pour le retour d’énergie (modèle de Vampipoing). `DUN_Fury_Cutter` accompagne le coup. Les références complètes et leur commit/blob sont conservés dans `references/upstream/`.

Le Pokémon Ceruledge/Malvalame possède déjà `bitter_blade` dans `LevelSkills` au niveau 48 dans la donnée amont `Data/Monster/ceruledge.json`; aucun fichier Monster n’a donc été modifié.

## Visuel

Le générateur a produit un arc de lame pixel-art rouge/orange, avec cœur bleu, impact blanc et traînées violettes. Il avait aplati un damier de transparence dans le PNG; `prepare_vfx.py` retire les tons neutres du damier tout en préservant les pixels de feu, de flamme bleue et l’étincelle centrale. L’aperçu montre la taille de l’arc, l’impact et un filet d’énergie rouge-or qui revient vers le lanceur.

Le PNG généré et le GIF sont des **concepts VFX**. Ils ne sont pas un `.dir` PMDO prêt à charger. La donnée de capacité utilise, elle, les effets natifs listés ci-dessus. Le cache/runtime PMDO n’étant pas disponible dans ce workspace, le chargement, le rendu et le comportement en jeu restent à tester dans PMDO 0.8.12.

## Vérifications locales

```sh
python3 source/bitter_blade_v1/prepare_vfx.py
python3 source/bitter_blade_v1/build_preview.py
python3 source/bitter_blade_v1/validate.py
```

`validate.py` vérifie les champs de capacité, le drain à 50 %, l’apprentissage de Malvalame au niveau 48, l’existence des index d’animation référencés dans les manifestes Audinowho et les dimensions du GIF. Il ne remplace pas un test du moteur.
