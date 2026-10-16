# Pipeline des suites de maps après EDR1

`pipeline.py` charge les helpers d'EDR1 dans une instance isolée et applique un `config.json`
par carte : masque de sol, profondeur, matériau, marqueurs et identifiants.
Il ne modifie pas EDR1 et ne dépend pas des caches ou ZIP historiques absents.
Dépendances : mêmes versions Pillow, NumPy et SciPy qu'EDR1.

```sh
.venv/bin/python source/maps_suite_v1/pipeline.py source/entree_aiguilles_dorees_v2
```

Deux routes de profondeur :
- `depth_mode: drawn` : profondeur déjà dessinée par le générateur, isolée par contour mesuré,
  quantifiée séparément sans remplacement par un aplat ; c'est la correction immersive EAD2.
- Sinon, pour une entrée : clef magenta puis remplissage par une couleur du rip (prototype EAD1).
- Une fin sèche n'a pas de calque de profondeur, pas de sortie ni warp (FDR1, FAD1).

Les pixels restent générés ; seuls les formats et la grille sont natifs. Effets de poussière
recalculés aux couleurs du rip, pas animations officielles. Aucune approbation artistique ni
validation du moteur n'est supposée. Les contours sont des découpes sur le nouveau rendu,
pas des relayouts de tuiles natives.

Lot terminé techniquement : **EAD2**, 8 tests dédiés et 30 images reconstruites par un lecteur
indépendant ; contrôle en jeu et avis artistique en attente. EAD1 est rejeté artistiquement.
FDR1 est maintenant finalisé techniquement : 13 tests dédiés dont cinq mutations, 29 images reconstruites, ZIP projet et calques/ORA. Avis artistique et test en jeu en attente.

FAD1 : fin des Aiguilles dorées assortie à EAD2, matériau `gold`, `kind: end`, six calques + Top, poussière tombante 24×5 ticks. 13 tests dédiés et 29 reconstructions ; aucun changement du pipeline commun. Avis artistique et moteur en attente.

EFF1 : `source/entree_foret_feuillus_v1/build.py` réutilise les helpers dans une instance isolée, mais possède sa partition forestière et son ordre de neuf calques. Utiliser son build dédié, pas la CLI minérale générique. 14 tests, 32 reconstructions, pas de validation artistique/moteur.
