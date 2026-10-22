# Pourquoi le fail-closed saisonnier était justifié — mesure

`rmvillage` est la seule room dont les **quatre** rendus de référence sont
versionnés dans Git. Elle permet donc de tester ce qu'on ne pouvait
qu'affirmer : **le terrain d'été prouve-t-il quoi que ce soit pour l'hiver ?**

Classification par le classifieur validé (colorimétrie du rendu réel, celui qui
avait évité les faux positifs de rmvillage et rm59), sur 6 084 cellules :

| Saison | Composition du terrain |
|---|---|
| été | grass 4 309 · open 1 579 · marsh 196 |
| printemps | grass 4 499 · open 1 389 · marsh 196 |
| **automne** | **open 3 761 · grass 1 878** · marsh 445 |
| **hiver** | **open 5 880** · marsh 193 · **snow 11** |

Divergence par rapport à l'été :

| Saison | Cellules divergentes | Part |
|---|---:|---:|
| printemps | 380 | 6,2 % |
| **automne** | 4 862 | **79,9 %** |
| **hiver** | 8 624 | **100 %** (toutes les cellules changent de classe) |

## Conclusion

En hiver, **la totalité du terrain change de classification** : l'herbe
disparaît au profit de sol nu et de neige. Un placement validé sur le terrain
d'été n'a aucune valeur probante en hiver — un Pokémon posé sur une cellule
`grass` d'été peut se retrouver sur une cellule d'une autre nature.

Le refus de libérer les 109 HELD sans la variante de Ground de leur saison
n'était donc pas une précaution excessive : c'était la seule décision correcte.
Le printemps, à 6,2 % de divergence, aurait pu passer pour anodin ; l'automne à
80 % et l'hiver à 100 % démontrent le contraire.

Les 109 HELD le restent tant que les variantes `autumn`/`winter` des 15 rooms
concernées ne sont pas converties et rendues.
