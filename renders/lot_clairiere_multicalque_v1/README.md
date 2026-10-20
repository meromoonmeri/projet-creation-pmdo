# Lot LCM1 — Clairière tropicale, 5 cartes multicalque (4:3, 768 × 576 px)

Demande (20 octobre 2026) : « fait 5 map par lot multicalque début chemin fin etc ». Question posée en même temps : faut-il la mer et le pont dans l'entrée Clairière ? **Oui** : le rip de référence (`large.S01P03A…png`) a la mer et le ponton au sud, et l'entrée ETC1 les reprend. Le décor de la fin FCT1 générée plus tôt ne les avait pas ; il est remplacé par `LCM1-05`, qui les contient.

## Les 5 cartes

| Code | Dossier | Rôle | Contenu |
|---|---|---|---|
| LCM1-01 | `LCM1-01_debut_ponton/` | Début | Ponton sur la mer au sud, chemin de galets vers la clairière |
| LCM1-02 | `LCM1-02_chemin/` | Chemin | Long sentier de galets entre les palmiers, sans eau |
| LCM1-03 | `LCM1-03_arene/` | Arène | Grande clairière ronde, galets d'accès au sud |
| LCM1-04 | `LCM1-04_passage/` | Passage | Couloir étroit entre haies et rochers, arche au centre |
| LCM1-05 | `LCM1-05_fin_grotte/` | Fin | Grotte dans le tertre au nord, ponton et mer au sud |

## Calques (du bas vers le haut, chaque carte)

`00 sol`, `01 chemin`, `02 eau`, `03 roches`, `04 végétation`, `05 fleurs`, `06 grotte`. Chaque calque est un PNG transparent 768 × 576 (`calques/`), et l'ensemble est en ORA (`LCM1-0X_*.ora`, `stack.xml` et `mergedimage.png`).

## Méthode et limites

- **Rendu généré référencé** : chaque décor est un `generate_image` avec le rip en référence. Ce ne sont **pas** des tuiles natives. Les sources sont dans `source/lot_clairiere_multicalque_v1/bruts/` (ignoré par Git).
- **Découpage** : classification par couleur (seuils mesurés sur les pixels du décor), mise à l'échelle 4:3 par BOX, puis chaque case de 8 px reçoit la classe majoritaire.
- **Recomposition** : `*_recomposition_source.png` et la planche `planche_recomposition_source.png`. La carte de classes a été contrôlée à l'œil sur LCM1-01 et LCM1-05.
- **Chemin faible** : les galets font 2 à 3 cases ; le calque `chemin` ne couvre que 1 à 3 % des cases. Le sentier est visible mais fragmenté.
- **Pas encore fait** : export PMDO 0.8.12 (`.rsground`/`.tile`), animations (mer, papillons), marqueurs entrée/boss/objectif, collisions et tests. Rien de cela n'est validé.
- `art_approved: false`, `runtime_tested: false`.
