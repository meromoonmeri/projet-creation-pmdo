# FWC1 — Fin Waterfall Cave : salle du joyau (4:3, PMDO 0.8.12)

Septième zone de fin de donjon de la série des entrées, après l'entrée Waterfall Cave (EWC1 à EWC3). Dans le jeu, après le
8e sous-sol, on arrive dans une grotte pleine de cristaux. Au fond se dresse un joyau géant : quand on le pousse, une vague
emporte les héros jusqu'aux sources chaudes. Il n'y a pas de boss.

- **Référence** : la vraie salle, `Waterfall_Cave_gem_TDS.png` (`reference/`). C'est un rendu généré référencé en deux
  étapes, eau en magenta ; ce ne sont pas des tuiles natives.
  1. Décor 4:3 avec la capture : les bassins sortaient en galets (brut gardé, non utilisé).
  2. Édition à un seul changement : les bassins gauche et droit passent en magenta.
- **Fidélité** (distance RVB moyenne à la capture) : galets 17.53, chemin sombre 20.13,
  sol complet 10.86 (seuil 35) ; eau 3.88 (seuil 15).
- **Layout** : arrivée au sud par un chemin sombre (`entrance`), chemin de galets et cristaux entre deux bassins (`arene`),
  joyau géant au nord (`joyau`, au pied du joyau). Les cristaux du sol sont praticables ; le joyau bloque. Aucune autre
  sortie, aucun warp.
- **Eau** : le réseau de reflets de la capture est calculé. Ce sont des cellules de Worley arrondies (q = F1 / F2) et
  étirées, dans 9 tons exacts de l'eau de la capture. Chaque centre de cellule tourne sur un petit cercle, donc le réseau
  ondule sur place sans défiler (24 × 10 ticks, boucle fermée). La part de traits clairs est celle de la capture, et les
  rives n'ont aucun liseré.
- **Joyau** : les facettes pulsent vers le rose clair (24 × 10 ticks). Le contour reste fixe.
- **Cristaux** : 61 étoiles déphasées naissent puis s'éteignent sur les cristaux (12 × 5 ticks).
- **Calques, du bas vers le haut** : sol complet, eau, sol, parois, cristaux, joyau, lueur du joyau, scintillements. La
  scène boucle en 240 ticks (4 s).

Aucun test du moteur : `runtime_tested: false`, `art_approved: false`.
