# Audit framebuffer final — 23 Grounds Red actifs

## Méthode

Chaque Ground actif provenant d’un identifiant DxxPyy est reconstruit depuis ses `.tile`, puis le taux de pixels presque noirs est mesuré. Cette vérification détecte les exports qui ne contiennent que la BMA/material-layer alors que le jeu ajoute un fond matériel, un overlay ou des objets au runtime.

## Résultat

- 23 Grounds actifs audités ;
- 11 rendus complets ou sans fond manquant ;
- variante D13P03 Arc Fugitif corrigée avec le framebuffer final du sommet ;
- 12 rendus encore incomplets.

| Ground | Pixels sombres |
|---|---:|
| sinister_woods_clearing | 84,6 % |
| d11p03 | 83,9 % |
| d10p03 | 81,8 % |
| fosse_ardente | 81,6 % |
| palier_celeste | 73,7 % |
| gorge_ardente_coeur | 73,7 % |
| d11p02 | 73,7 % |
| d10p02 | 73,7 % |
| d09p02 | 73,7 % |
| arc_palier_celeste | 73,7 % |
| d09p03 | 63,5 % |
| sanctuaire_voeu | 62,9 % |

## Correction immédiate

`arc_tour_ciel_sommet` utilisait encore l’ancien material-layer noir alors que `tour_ciel_sommet` était corrigé. Sa couche visuelle pointe désormais vers `SkyTowerSummitCanonical_Base`, sans dupliquer le tileset.

## Blocage documentaire

`PMD-RED-PMDO-PORT/output/Grounds` contient pour ces douze cartes le même export BMA incomplet. Contrairement à D13P03, le dépôt New Era ne possède pas encore de rip PNG final de référence pour chacune. Les remplir avec un fond inventé ne serait pas pixel-perfect.

La correction exige donc, pour chaque carte :

1. retrouver ou produire le framebuffer final de la scène source ;
2. reconstruire palettes, overlays matériels et objets ;
3. comparer au rendu émulateur ;
4. convertir vers `.tile` ;
5. préserver collision, entités et scripts ;
6. reconstruire la `.rsmap` de combat depuis ce rendu.

## Garde-fou

`tools/audit_red_final_render.py` échoue tant qu’un Ground D actif dépasse 50 % de pixels presque noirs. Ce seuil est un détecteur de material-layer, pas une preuve suffisante de fidélité : chaque correction devra ensuite obtenir une comparaison pixel-perfect avec sa référence finale.
