# Aperçu de toutes les maps — y compris celles qui sont dans les ZIP

Ce dossier contient la **galerie complète** du projet. Elle restitue toutes les cartes
du dépôt source `meromoonmeri/projet-pmdo`, sans rien rééchantillonner ni régénérer :
les aperçus HTML sont servis **octet pour octet**, et les archives ZIP sont
**dépaquetées calque par calque** pour rejouer leurs frames dans l'ordre.

## Lancer l'aperçu

```sh
cd /home/user/projet-creation-pmdo
.venv/bin/python source/serveur_apercus/serve.py --port 8000 --bind 0.0.0.0
```

La page d'accueil `http://localhost:8000/` (ou l'URL de prévisualisation Arena)
affiche la galerie. Le serveur n'utilise que la bibliothèque standard, écoute sur
`0.0.0.0` et n'emploie que des liens relatifs : il fonctionne derrière le proxy
d'aperçu.

## Restaurer les médias (à faire une fois par nouvel environnement)

Cette extraction ne contient que les méthodes : les 2,66 Go d'aperçus et d'archives
restent dans le dépôt source. Le script suivant les récupère fichier par fichier
via l'API GitHub, extrait les ZIP et fabrique les vignettes :

```sh
python3 -m venv .venv && .venv/bin/pip install Pillow   # pour les vignettes
.venv/bin/python source/serveur_apercus/restaurer.py
```

Bilan attendu :

| | |
|---|---:|
| fichiers d'origine restaurés | **532** (2 662,6 Mo) |
| aperçus HTML autonomes | **166** |
| archives ZIP | **200** |
| médias extraits des ZIP | **35 238** |
| frames PNG indexées | **30 645** |
| animations WebP/GIF natives | **311** |
| scènes reconstituées | **710** |
| cartes PMDO natives (`.rsground`) | **266** |
| aperçus HTML embarqués dans un ZIP | **61** |
| chantiers `source/` | **208** |
| vignettes | **366** |

Le script est **idempotent** : les blobs déjà présents (nommés par leur SHA Git)
ne sont pas retéléchargés, et un marqueur `.extrait` évite de redépaqueter un ZIP.
`--force` force l'extraction, `--sans-vignettes` ignore Pillow.

Tout est stocké dans `.cache/apercus/` (ignoré par Git et exclu des snapshots) :
`blobs/` (fichiers d'origine), `packs/<id>/` (médias extraits), `thumbs/` (vignettes).
Si le cache disparaît, `restaurer.py` le reconstruit ; le serveur sait aussi
télécharger un blob manquant à la demande.

## Ce que voit l'utilisateur

| URL | Contenu |
|---|---|
| `/` | galerie cherchable : aperçus, packs, HTML embarqués, Grounds, chantiers |
| `/apercu_xxx.html` | l'aperçu autonome d'origine, avec ses canvas/data-URI/animations |
| `/renders/<lot>/index.html` | pages cibles des redirections, avec leurs assets frères |
| `/pack/<id>/` | lecteur du ZIP : animations natives + reconstitution des calques |
| `/pack/<id>/f/<chemin>` | n'importe quel fichier interne (frame, WebP, .rsground…) |
| `/pack/<id>/zip` | l'archive d'origine, téléchargeable |
| `/api/catalogue`, `/api/pack/<id>`, `/sante` | catalogue, détail d'un pack, état |

### Fidélité des animations

* **Aperçus HTML** : servis tels quels depuis le commit `6cca4a0`. Leurs calques,
  leurs data-URI, leurs boucles `requestAnimationFrame`, leurs cadences et leurs
  contrôles sont intacts. Rien n'est réécrit.
* **Animations natives** : les 311 WebP/GIF trouvés dans les ZIP sont affichés
  directement par le navigateur — ce sont les exports d'origine, avec leurs
  délais de frame réels.
* **Frames PNG** : le lecteur compose les calques du bas vers le haut (rang déduit
  de l'indice numérique du fichier : `01_sol`, `12_bulles`…), avance chaque calque
  indépendamment (`phase = temps / cadence`), sans lissage (`image-rendering:
  pixelated`), et laisse régler cadence, vitesse, zoom, grille 8 px, calques
  visibles et export PNG.
* **Cadence** : relevée dans les `manifest.json` (`frame_ms`, `FrameLength`,
  `frame_length_ticks` à 60 i/s, `fps`…), sinon dans les `NN ms` des README,
  sinon 100 ms par défaut. La source de la valeur est affichée dans le lecteur.
* **Cartes natives** : les `.rsground` n'ont pas d'image ; ils sont listés et,
  pour 198 packs sur 200, reliés à l'aperçu HTML autonome correspondant.

Aucune image n'est redessinée, agrandie ou rééchantillonnée : les vignettes
servent seulement de repère visuel dans la galerie.

## Régénérer le catalogue

```sh
python3 source/serveur_apercus/construire_catalogue.py            # arbre via l'API GitHub
python3 source/serveur_apercus/construire_catalogue.py --arbre /tmp/arbre_main.json
```

Le constructeur lit l'arbre Git du dépôt source, résout récursivement toutes les
dépendances des pages HTML (GIF, PNG, ZIP, README…), analyse le répertoire central de
chaque ZIP, détecte les séquences de frames, relève les cadences et écrit
`catalogue.json` (métadonnées) et `manifeste.json` (532 fichiers + SHA).

## Fichiers

| Fichier | Rôle |
|---|---|
| `serve.py` | serveur HTTP, routes, API, service des fichiers d'origine |
| `restaurer.py` | téléchargement, extraction, vignettes, `etat.json` |
| `construire_catalogue.py` | analyse de l'arbre distant et des ZIP |
| `catalogue.json` | 166 aperçus, 200 packs, 710 scènes, 208 chantiers |
| `manifeste.json` | chemin → SHA/size de chaque fichier à restaurer |
| `ui/galerie.*` | galerie (recherche, filtres, vignettes) |
| `ui/lecteur.*` | lecteur de pack (canvas, calques, animations, fichiers) |

## Limites honnêtes

* Les ZIP de mods PMDO contiennent des `.rsground`/`.tile` binaires : ils sont
  téléchargeables et listés, mais **pas rendus par un moteur de jeu**. Aucun test
  runtime PMDO n'est revendiqué ici.
* Quand un pack ne contient aucun calque image, le lecteur le dit et renvoie vers
  l'aperçu HTML lié (198/200).
* La cadence par défaut (100 ms) est un choix de lecture, pas un cycle officiel ;
  elle est clairement signalée et modifiable.
