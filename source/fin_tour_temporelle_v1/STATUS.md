# État — FTT1, Fin de la Tour Temporelle

Mise à jour : 19 octobre 2026.

## Livrable vérifié

- Build de `source/fin_tour_temporelle_v1/build.py` réussi : map 768 × 576 px, grille 8 px, neuf calques d’image, `Top` vide réservé dans Ground PMDO, boucle de 240 ticks (4 s).
- Fond en trois plans : ciel d’espace presque noir, nébuleuse rouge-noir générée à partir du seul échantillon de style ETT2, puis pulsations lumineuses diagonales/spiralées en 24 phases. Les pulsations restent derrière le sol et l’architecture.
- Décor et sol magenta segmentés avant réduction ; le fond nébuleux, non magenta, est normalisé séparément. Tous les masques exportés sont à 768 × 576 px. Entrée `[384,560]`, marqueur `boss_dialga` `[384,344]`, 118 939 pixels praticables et 5 199 cases bloquées.
- **11 tests `unittest` PASS** après le dernier build, dont un test dédié à la couverture rouge-noir, au centre noir et aux phases animées.
- Packager exécuté : ZIP projet PMDO 0.8.12, ZIP calques/masques/5 animations/ORA/sources/état et aperçu autonome. Les archives passent `ZipFile.testzip()` sans membre corrompu ; l’aperçu est autonome, sans ressource distante.
- Le JavaScript de l’aperçu passe `node --check`; `git diff --check` passe.

## Statut et limites

- Direction « fin de la Tour Temporelle au sommet » choisie comme interprétation du contexte ETT2 ; elle n’a pas été nommée explicitement par l’utilisateur. Dialga est une hypothèse de contexte, pas un personnage placé.
- D29P11A et D30P34A sont des références MAP_BG rendues et consultées, mais leurs noms de lieux ne sont pas établis. Elles n’ont pas été fournies au générateur. Le décor est nouveau, généré à partir du seul échantillon de style ETT2 ; aucune tuile native/canonique ni pixel ROM n’est revendiqué.
- `art_approved: false` et `runtime_tested: false`. Les tests valident des invariants de fichiers et de logique, pas l’approbation artistique, l’import visuel PMDO ni le gameplay.
- Le cache `.cache/fin_tour_temporelle_v1/` est éphémère : relancer le builder avant les tests ou avant de reconstruire le ZIP projet Ground.

## Commandes

```bash
.venv/bin/python source/fin_tour_temporelle_v1/build.py
.venv/bin/python -m unittest source.fin_tour_temporelle_v1.test_build -v
.venv/bin/python source/fin_tour_temporelle_v1/package.py
```

Livrables : `renders/fin_tour_temporelle_v1/FTT1_projet_pmdo_0812.zip`, `FTT1_calques_png_8px.zip`, ORA, manifest et revue ; aperçu interactif autonome : `apercu_fin_tour_temporelle_v1.html`.
