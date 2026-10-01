# Outil de récupération des maps et BG de PMD Explorers of Sky

`recuperer_maps.py` récupère **toutes** les maps de fond (MAP_BG) du jeu et les fonds de la galerie projectpokemon.

## Sources

| Commande | Source | Ce qui sort |
|---|---|---|
| `rom` | décompilation [pret/pmd-sky](https://github.com/pret/pmd-sky), commit épinglé `c8073235`, clone partiel dans `.cache/pmd-sky` | 473 entrées de `bg_list.dat` (table map → BMA/BPC/BPL/BPA du jeu US), 468 rendues avec skytemple-files, dont 154 animées |
| `galerie` | [galerie projectpokemon, catégorie 12](https://projectpokemon.org/home/gallery/category/12-pok%C3%A9mon-mystery-dungeon-explorers-of-sky/) : tilesets de donjon, fonds animés GIF/APNG, fonds de menu, fonds d'écran | images originales dans `.cache/maps_pmdsky/galerie/<album>/` avec `index.json` |
| `identifie` | captures nommées à la racine du dépôt | nom de lieu attaché aux codes, avec l'écart mesuré comme preuve |
| `cherche TERME` | `index_rom.json` | recherche par code, fichier ou capture |

```bash
.venv/bin/python source/outil_maps_pmdsky/recuperer_maps.py rom --max-frames 64      # ~2,5 min, rendu complet
.venv/bin/python source/outil_maps_pmdsky/recuperer_maps.py rom --only D17,V24P04A   # sous-ensemble
.venv/bin/python source/outil_maps_pmdsky/recuperer_maps.py galerie                  # besoin d'un accès HTTPS à projectpokemon.org
.venv/bin/python source/outil_maps_pmdsky/recuperer_maps.py cherche D17
.venv/bin/python -m unittest source.outil_maps_pmdsky.test_outil -v
```

## Sorties

- `.cache/maps_pmdsky/rom/png/<CODE>.png` : frame 0, tous les calques, sans collision (non versionné).
- `.cache/maps_pmdsky/rom/anim/<CODE>.webp` : WebP animé sans perte, 167 ms par frame (10 ticks). WebP fusionne les frames identiques qui se suivent.
- `index_rom.json` (versionné) : code, fichiers source, taille, frames, BPA, collision, lettre, identification.
- `planches/planche_<lettre>.jpg` (versionnées) : planches contact par première lettre du code.
- Codes dont le BMA est partagé : suffixe `__<BPC>`.

## Limites vérifiées

- **Le préfixe `dNN` n'est PAS le `DUNGEON_ID` d'`include/enums.h`.** Les captures le prouvent au pixel près : D04 = Waterfall Cave, D05 = Apple Woods, D07 = Mt. Horn, D10 = Steam Cave Peak, D20/D21 = Sealed Ruin, D40/D41 = Dark Crater, D54 = Southern Jungle. L'outil ne donne donc un nom qu'aux codes identifiés par une capture (26 vérifiés à l'écart 0, 4 probables). Le `RENOMMAGE_CANONIQUE_REPORT.md` du port PMD-SKY-PMDO-PORT repose sur l'hypothèse `dNN = DUNGEON_ID`, à revoir.
- Les libellés des lettres (D, G, H, P, S, T, V, W) sont supposés d'après les planches.
- 5 entrées de `bg_list.dat` pointent vers un BMA absent de la décompilation : S11P02C, S13P01A, S13P01A__S13P01A, S99P02A, S99P03A.
- La commande `galerie` n'a pas pu être testée dans la sandbox Arena : projectpokemon.org y coupe le TLS. Elle affiche une erreur claire. Le parseur (pages d'albums IPS, pagination `/page/N/`, original = miniature sans `small.`) a été écrit d'après les pages lues avec un navigateur.
- Le rendu des animations suit la méthode du port : `bma.to_pil`, 8 emplacements BPA pris dans le nom de fichier. La cadence réelle par BPA n'est pas reproduite.
