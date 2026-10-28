# Serveur d'aperçus de la session — la page d'accueil liste **chaque map**

```sh
python3 source/serveur_apercus/serve.py                 # 0.0.0.0:8000
python3 source/serveur_apercus/serve.py --port 8080
```

Sert la racine du dépôt en lecture seule (bibliothèque standard seulement, `GET`, `HEAD`,
`?dl=1` en pièce jointe). La page `/` est **générée à la volée**.

## Ce que contient la page `/`

1. **« Toutes les maps du projet »** — les **290 maps recensées**, chacune sur sa propre ligne
   de la liste jaune sur fond noir, rangées en 9 familles (entrées 27, fins 18, arènes 12,
   zones & routes 23, guilde/café/intérieurs 47, côtes/Métano/falaises 36, donjons 48,
   cartes du monde 21, décors & autres 58) :
   - lien direct vers le **PNG natif** de `maps/` (badge `PNG natif`, 171 maps) ;
   - sinon vers sa **vignette** (badge `vignette`, 61 maps) ;
   - sinon la ligne reste listée et signalée **sans image** avec la raison (58 lots) ;
   - chaque ligne porte un **lien profond** vers sa carte dans la galerie
     (`apercu_galerie_maps.html#<ancre>`, ancre surlignée à l'arrivée) ;
   - libellés lisibles avec le **code de map** (`EBN1 · Entrée Bristle Sud Nord v1`,
     `RAZ1 · Zone Zéro v1`, `01 · Accueil de la guilde`) et sa taille d'image + son poids.
2. Un **filtre instantané** (champ collant en haut) : nom, dossier, **code** (`EKR1`), famille ;
   les familles vidées se masquent et le compteur affiche « *n* / 290 maps affichées ».
3. Les **53 aperçus autonomes** et les liens de téléchargement des packs, comme avant.

Recensement et vignettes viennent des mêmes JSON que la galerie
(`source/galerie_maps/galerie*.json`) et des fichiers natifs de `maps/MANIFESTE_MAPS.json` :
une seule source de vérité, rien à recopier à la main. La section est mise en cache et
invalidée dès que l'un de ces fichiers change (`mtime`).

Les codes de map absents des métadonnées (`EKR1`…) sont retrouvés dans les noms de fichiers
du lot puis dans son aperçu autonome, une seule fois par lot (cache mémoire).

## Contrôles

```sh
python3 source/serveur_apercus/test_index.py                     # 20 contrôles, hors réseau
NODE_PATH=/tmp/nc/node_modules node source/serveur_apercus/test_index_filtre.js /tmp/index.html
```

`test_index.py` vérifie que **chaque** map est listée une fois, que les 171 liens natifs
pointent vers un fichier existant, que les 232 illustrations ont un lien valide, que les 58
lots sans image sont présents et signalés, et que les ancres de galerie sont conformes.
`test_index_filtre.js` rejoue la page dans jsdom (filtre par dossier, par code, par mot
accentué, compteur, masquage des familles vides).

Honnêteté : la page liste et illustre ; elle ne prouve ni collisions, ni marqueurs, ni runtime
PMDO (`art_approved = false`).
