# FBS1 — Fin Bristle : sommet de Mt. Bristle (4:3, PMDO 0.8.12)

Cinquième zone de fin de donjon de la série des entrées, après l'entrée Bristle (EBN1). Dans le jeu, c'est au sommet de
Mt. Bristle que les héros battent Drowzee pour sauver Azurill.

- **Référence** : la vraie salle n'existe qu'en vignette de 110 × 120 px (`reference/`, mysterydungeonwiki). Elle donne la
  composition : une clairière de sable carrée, fermée de rochers gris en pointes. Les textures viennent de
  `Mt_Bristle_entrance_TD.png` (rendu généré référencé, pas de tuiles natives).
- **Layout** : arrivée au sud par un couloir de sable (`entrance`), grande clairière pour le boss (`boss`), Azurill au fond
  nord (`azurill`). Blocs bruns bloquants. Aucune autre sortie, aucun warp.
- **Touffes au vent** : poses et cycle de l'entrée Bristle, 12 × 10 ticks, rafale d'ouest (la phase avance vers l'est).
- **Rafales de sable** : 44 traînées claires qui naissent, filent vers l'est (8 px par phase) et s'éteignent, 24 × 5 ticks.
  Chaque traînée refait le même trajet : la boucle est exacte, sans retour visible.
- Calques, du bas vers le haut : sol complet, sable, rafales, rochers, touffes, falaises. La scène boucle en 120 ticks (2 s).

Aucun test du moteur : `runtime_tested: false`, `art_approved: false`.
