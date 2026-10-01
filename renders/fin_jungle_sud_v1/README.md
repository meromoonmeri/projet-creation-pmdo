# FJS1 — Fin Jungle : fond de Southern Jungle (4:3, PMDO 0.8.12)

Sixième zone de fin de donjon de la série des entrées, après l'entrée Jungle (EJN1). Southern Jungle est le donjon de
l'épisode spécial 4 de PMD Sky (« Here Comes Team Charm! »).

- **Référence** : la vraie sortie, `Southern_Jungle_exit_S.png` (`reference/`). Elle montre une clairière de sable jaune
  olive, une pelouse à gauche, un rocher gris au fond, des fougères et des palmes, et une canopée sombre au premier plan.
  C'est un rendu généré référencé en trois étapes, toutes avec la capture. Ce ne sont pas des tuiles natives.
- **Fidélité** : sable à 19,2 et pelouse à 16,8 de la capture (distance RVB moyenne, seuil 35).
- **Layout** : arrivée au sud par un chemin de sable (`entrance`), grande clairière pour le combat de fin (`boss`),
  objectif devant le rocher gris au nord (`objectif`). Aucune autre sortie, aucun warp. Le boss n'est pas nommé, car les
  sources ne s'accordent pas.
- **Feuilles** : 14 feuilles tombent de la jungle sur le sable en se balançant, se posent 6 phases puis s'effacent
  (48 × 5 ticks). Chaque feuille refait la même chute, donc la boucle est exacte.
- **Papillons** : poses générées de l'entrée Jungle, 6 vols en huit fermés (48 × 5 ticks).
- **Calques, du bas vers le haut** : sol complet, sable, pelouse, feuilles, rocher, jungle, papillons, canopée. La scène
  boucle en 240 ticks (4 s).

Aucun test du moteur : `runtime_tested: false`, `art_approved: false`.
