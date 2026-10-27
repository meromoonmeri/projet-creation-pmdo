# Café Spinda — réseau au propre, sans fond magenta

Demande de l'utilisateur (20 octobre 2026) : « le réseau café au propre sans le fond
majenta ». Dérivé propre du réseau V4 (`renders/cafe_spinda_reseau_v4/`, **préservé
tel quel**, aperçus magenta compris) — rien n'est régénéré.

## Ce qui change par rapport à V4
- Les 5 salles (accueil, casino, salon bas, café, salon_haut ; 600×448, grille 8 px)
  sont exportées en **PNG à fond transparent** : alpha 0 hors de la salle, **aucun
  pixel magenta** (vérifié salles et calques).
- La **frange magenta** du détourage d'origine (pixels teintés le long des bordures
  rocheuses : 623 à 1082 px par salle) est **recolorée** par le plus proche pixel
  propre du même calque, alpha et silhouette inchangées.
- Les calques sont fournis en **PNG** (V4 les stockait en WebP).
- Les aperçus `*_sur_fond_neutre.png` utilisent un fond neutre chaud (58,48,40) —
  uniquement pour regarder ; les salles livrées restent transparentes.

## Provenance et limites
Calques repris à l'identique du pack V4 (`SpindaV4_pack.zip`, dépôt source
`meromoonmeri/projet-pmdo` @ 6cca4a0, conservé dans `source/cafe_spinda_reseau_propre_v1/`) :
`verify.py` prouve que la recomposition égale les salles exportées et que l'écart avec
le pack se limite exactement à la frange recolorée. Le terrain reste du **généré
référencé, pas des pixels natifs** (sauf fenêtres et escaliers natifs de V4, non
recomposés ici). Réseau : 3 niveaux, 4 liens réciproques — transitions indépendantes,
**pas de warps, pas de test PMDO** (`runtime_PMDO: NOT TESTED`).

Commandes : `build.py` puis `verify.py` puis `package.py` (aperçu racine
`apercu_cafe_spinda_reseau_propre_v1.html` + `CafeSpinda_reseau_propre.zip`).
