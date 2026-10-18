# Fin Tour Temporelle (FTT1) — arène noire et or, 4:3

Zone de fin de donjon qui prolonge l'entrée ETT2 (Tour Temporelle). Choisie par l'utilisateur après la
question sur la prochaine map (18 octobre 2026). Format 4:3 : 768 × 576 px, soit 96 × 72 cases de 8 px.

## Sorties
- `renders/fin_tour_temporelle_v1/calques/` : sol complet, sol praticable, murs et rochers (PNG transparents).
- `renders/fin_tour_temporelle_v1/animation/` : circuits d'or, 4 phases × 10 ticks (boucle de 40 ticks).
- `renders/fin_tour_temporelle_v1/FTT1_fin_tour_temporelle.ora` : ORA éditable, 4 calques.
- `renders/fin_tour_temporelle_v1/manifest.json` : marqueurs, chemin, flags.
- `renders/fin_tour_temporelle_v1/apercu_fin_tour_temporelle_v1.png` : aperçu composé.

## Marqueurs et collisions
- `entrance` au sud (384, 544), `boss` au centre de l'arène (384, 330), `objectif` au pied de la porte au nord (384, 200).
- Sol praticable : fermeture du sol de l'ardoise, composante connexe. Chemin de 16 × 16 entrée → objectif : 44 cases.
- Aucun warp, aucune sortie.

## Méthode et limites
- **Décor** : rendu généré référencé sur le décor ETT2 exact (`source/entree_tour_temporelle_sud_nord_v2/bruts/decor_magenta.png`).
  Le plan reste proche de l'entrée : à revoir si vous voulez une arène plus distincte.
- **Pas d'export Ground** : le gabarit `mod_metano_expeditions_pmdo_0812.zip` n'est pas présent dans ce dépôt ; l'export Ground des autres fins ne peut donc pas être rejoué ici.
- **Animation** : seul le circuit d'or est animé (palette cyclique créée par le script). Pas d'animation officielle.
- **Tests** : 8 tests PASS (`.venv/bin/python -m unittest source.fin_tour_temporelle_v1.test_build -v`). `art_approved` et `runtime_tested` restent à `false`. Aucun test dans PMDO.
