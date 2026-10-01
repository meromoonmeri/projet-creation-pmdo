# FGG2 — Fin Givre V2 : Frosty Grotto sous les aurores (4:3, PMDO 0.8.12)

Demande : « Il faut pas de cristal stp et on aurait aimé voir les aurore boreal dans le design texture canonique
de la référence adapté a notre layout ». FGG1 (avec cristal) reste disponible à côté.

- **Layout de FGG1** : arrivée au sud par le couloir de glace, arène (boss) au centre, deux bassins d'eau glacée.
  Le cristal et son monticule sont retirés ; le nord s'ouvre sur le ciel derrière une rangée de pics sombres
  (marqueur `belvedere` au bord nord de l'arène, face aux aurores). Aucun warp.
- **Aurores** : rideaux en flammes de `aurorepmdsky.png` (PMD Sky), sommets vert menthe / cyan, cœur magenta-violet,
  franges cyan, régénérés en panorama 768 px (rendu généré référencé, pas de pixels natifs) sur le marine du ciel de
  la référence. Calque propre, 12 phases x 10 ticks (2 s), boucle exacte, **une seule géométrie** : onde verticale
  qui court le long du ruban (3 px) et rayons qui s'allument en bande glissante. Pas de défilement, pas de cycle de
  palette global.
- **Ciel** (fixe, couleurs de la référence) et **étoiles** (36, scintillent sur 12 phases) sur des calques séparés.
- Eau glacée (4 x 10), reflets (4 x 10) et flocons (48 x 5) repris de l'entrée Givre, comme FGG1.

Calques, du bas vers le haut : eau glacée, reflets, sol complet, ciel, étoiles, aurore, sol de glace, parois, flocons.

Aucun test du moteur : `runtime_tested: false`, `art_approved: false`.
