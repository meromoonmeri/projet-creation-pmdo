# `maps/` — les maps physiquement dans la branche

Chaque fichier de ce dossier est **le PNG final d'une map, en résolution native, octet pour
octet celui du dépôt source** (`meromoonmeri/projet-pmdo` @ `6cca4a0`). Aucun redimensionnement,
aucun ré-encodage, aucun zip.

Manifeste : **[`MANIFESTE_MAPS.json`](MANIFESTE_MAPS.json)** — pour chaque map : chemin local,
taille, **sha256 du fichier**, **sha1 git du blob d'origine**, taille d'image, dossier source,
famille. Intégrité vérifiée au téléchargement (`sha1("blob <taille>\0" + octets) == sha du blob`)
puis relisible à tout moment :

```sh
.venv/bin/python source/galerie_maps/rapatrier.py --verifier
```

Index visuel : **[`../apercu_galerie_maps.html`](../apercu_galerie_maps.html)** — chaque carte
porte un lien « ▶ PNG natif » vers le fichier local, et la case *« seulement les fichiers natifs
de la branche »* masque tout le reste.

## Arborescence

```
maps/
├── MANIFESTE_MAPS.json
├── <lot>/<fichier>.png            ex. maps/entree_caverne_cristal_sud_nord_v1/EKR1_scene_t000.png
└── <lot>/<sous-map>/<fichier>.png ex. maps/zone_zero_v1/RAZ1/RAZ1_scene_t000.png
```

Le nom de fichier est **celui d'origine** (codes `EKR1`, `ZRV2`, `AGM3`…), pour retrouver
immédiatement la provenance.

## État du rapatriement

| Lot de maps | Famille (`categorie`) | Maps | Poids | État |
|---|---|---:|---:|---|
| **Série entrée / fin / arène / zone / guilde** | `entree`, `fin`, `arene`, `zone`, `guilde` | **83** | **51,6 Mo** | ✅ présent |
| Donjons générés & donjons PMD | `donjon` | 31 | 14,6 Mo | à rapatrier |
| Côtes, Métano & falaises | `cotes` | 23 | 19,6 Mo | à rapatrier |
| Décors, animations & autres lots | `divers` | 14 | 9,8 Mo | à rapatrier |
| Cartes du monde | `monde` | 20 | 29,0 Mo | à rapatrier |

Commande du lot suivant (mêmes garanties, mêmes vérifications) :

```sh
.venv/bin/python source/galerie_maps/rapatrier.py --categories donjon,cotes
.venv/bin/python source/galerie_maps/rapatrier.py --categories divers,monde
.venv/bin/python source/galerie_maps/rapatrier.py --tout
.venv/bin/python source/galerie_maps/build_galerie.py        # met la galerie à jour
```

## Ce qui n'est **pas** dans `maps/`, et pourquoi

- **Les calques, bruts, frames d'animation et paquets** (≈ 4,6 Go) : inutiles au jeu, récupérables
  fichier par fichier depuis le dépôt source (chemin exact dans `MANIFESTE_MAPS.json › source`).
- **Les 58 lots de la branche sans image versionnée** (`grotte_ouest_*`, `ruines_enfouies_*`,
  `destiny_*`, `tiny_woods_*`, `sinister_woods_*`, `zekrom_*`, …) : leur **rendu final n'existe
  dans aucun dépôt** — il a été produit en session et n'a jamais été committé (`renders/**/*.png`
  est ignoré). Ce qui existe est déjà là : `source/<lot>/bruts/…`, `source/<lot>/references/…`
  et, pour 13 lots, `renders/<lot>/layers/*.png`. La galerie les montre en le disant (badge
  « rendu » ou « référence »).
- **Les 12 salles de la guilde** : elles sont déjà versionnées en clair dans `salles/`
  (jour + nuit, PNG et bases), avec `kit.json` pour les règles d'accès.

## Pour un mod PMDO (Pokémon Mystery Dungeon : Destiny)

- Les **données moteur** sont les `.rsground` (Ground), `.tile` (tilesets), `.dir` et
  `init.lua` — déjà présents dans la branche (`source/**`, 143 fichiers, 64,3 Mo) : ce sont eux
  qu'on installe dans `PMDO/MODS/…/Data/Ground`.
- Les PNG de `maps/` sont les **compositions finales** : références de layout, de palette et de
  calques pour l'import « PNG to Tileset » à **8 px**, pas des tilesets directement importables.
- Honnêteté maintenue : `art_approved = false`, aucun test runtime PMDO (aucun fichier de ce
  dossier n'a été ouvert dans le moteur).
