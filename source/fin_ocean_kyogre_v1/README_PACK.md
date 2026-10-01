# FOC1 — Fin Océan : arène de Kyogre sous la mer (4:3, PMDO 0.8.12)

Zone de fin de donjon sous l'océan, faite pour accueillir Kyogre. Demande : « des motifs sur toute la zone, des nuances
d'eau, des effets de bulles… une zone où il y aura Kyogre après… elle doit être magnifique ».

- **Référence canonique** : la map `D42P41A` de PMD Explorers of Sky (`reference/`), rendue par `source/outil_maps_pmdsky`
  (pret/pmd-sky + skytemple-files). C'est un fond marin bleu gravé d'anneaux de bulles et de fissures de corail, entouré
  d'un anneau de roche bleue, avec des scintillements multicolores. Aucune map sous-marine jouable n'existe dans PMD Sky ;
  c'est la plus proche (choix de l'agent). Le décor est un **rendu généré référencé**, avec un nouveau layout et la fosse
  en magenta ; ce ne sont pas des tuiles natives.
- **Fidélité** (distance RVB moyenne à la référence) : sol 12.2, sol complet 4.03, parois 30.1 (seuil 35).
- **Layout** : arrivée au sud (`entrance`). Le chemin s'ouvre sur une grande arène ovale avec un **sceau de Kyogre** gravé
  au centre (`sceau`). Au nord, une **fosse abyssale** entourée de corniches en gradins (non praticables) : c'est de là que
  Kyogre surgira. Le marqueur `kyogre` est au bord sud de la fosse. Algues et coraux décorent les parois. Aucune autre
  sortie, aucun warp.
- **Animations**, toutes en boucle fermée sur 240 ticks (4 s) :
  - **abysse** : tourbillon lent à 3 bras dans 7 tons sombres, crêtes qui accrochent la lumière, bord nord dans l'ombre de
    la corniche (24 × 10 ticks) ;
  - **nuances d'eau** : caustiques fines et ondulées (réseau F2 − F1 de 420 centres qui tournent, domaine déformé, traits
    discontinus), plus des nappes de lumière et d'ombre qui ondulent (16 × 15) ;
  - **motifs lumineux** (motifs sur toute la zone) : le sceau s'allume, puis une onde de lumière part du sceau et
    parcourt les 13 841 pixels gravés du sol. La traîne est éteinte avant le raccord (24 × 10) ;
  - **algues** : 29 touffes qui ondulent par cisaillement, base fixe ; la paroi est remplie sous les algues (12 × 20) ;
  - **bulles** : 69 bulles (18 sources : la fosse, 9 évents gravés, 8 algues) qui naissent, grossissent, montent en
    oscillant puis éclatent (48 × 5) ;
  - **scintillements** : 80 étoiles aux 4 teintes relevées sur la référence (12 × 5).
- **Calques, du bas vers le haut** : sol complet, abysse, sol, nuances d'eau, motifs lumineux, parois, coraux, algues,
  bulles, scintillements.

Aucun test du moteur : `runtime_tested: false`, `art_approved: false`. Kyogre n'est pas placé : seul le marqueur l'est.
