# Manifeste d'extraction

- **Source** : `meromoonmeri/projet-pmdo` @ [`6cca4a09380211e510ab1bea454a1b1926ef4b5a`](https://github.com/meromoonmeri/projet-pmdo/commit/6cca4a09380211e510ab1bea454a1b1926ef4b5a) (branche `main`)
- **Date d'extraction** : 2026-10-01
- **Dépôt source** : 41868 fichiers, 6.21 Go
- **Extrait ici** : 3592 fichiers, 168.9 Mo — soit 2.7 % du volume
- **Non extrait** : 38276 fichiers, 6.04 Go (images de rendu, archives, aperçus HTML)

## Méthode d'extraction

Clone *blobless* + *sparse-checkout* : Git ne télécharge que les blobs demandés,
jamais les 6 Go. Reproductible avec `OUTILS/extraire_depuis_projet-pmdo.py`.

## Contenu extrait par catégorie

| Catégorie | Fichiers | Mo |
|---|---:|---:|
| Données PMDO natives / Tiled | 245 | 77.7 |
| Règles, configs, provenance | 842 | 47.8 |
| Assets légers (PNG des kits, gabarits) | 1356 | 36.1 |
| Scripts et code | 740 | 5.0 |
| Documentation | 326 | 1.6 |
| Visionneuses HTML | 83 | 0.6 |

## Contenu extrait par dossier

| Dossier | Fichiers | Mo |
|---|---:|---:|
| `source` | 2159 | 67.4 |
| `exports` | 236 | 24.7 |
| `sprites` | 153 | 20.9 |
| `(racine)` | 10 | 17.4 |
| `salles` | 72 | 14.0 |
| `renders` | 561 | 11.1 |
| `calques` | 264 | 5.3 |
| `tiled` | 24 | 2.9 |
| `apercus` | 3 | 2.1 |
| `image-search` | 17 | 1.7 |
| `exterieur` | 6 | 1.0 |
| `audits` | 3 | 0.2 |
| `fenetres_exterieur` | 84 | 0.2 |

## Volontairement NON extrait (récupérable à la demande)

| Dossier | Fichiers | Go | Contenu |
|---|---:|---:|---|
| `renders` | 32907 | 4.32 | rendus PNG/GIF/WebP des maps, aperçus HTML, ZIP d'étapes |
| `(racine)` | 287 | 0.88 | archives ZIP livrées, aperçus HTML, images de référence PMD |
| `source` | 456 | 0.56 | PNG de travail des sous-projets (gabarits, découpes) |
| `exports` | 3790 | 0.19 | exports PNG et planches, quelques JSON/CSV repris ici |
| `sprites` | 812 | 0.10 | planches de sprites et découpes PNG |
| `salles` | 24 | 0.00 | PNG/Aseprite des 12 salles (extrait sauf Aseprite) |

## Récupérer ce qui manque

```sh
# un fichier précis, sans cloner :
curl -L -o fichier.png \
  https://raw.githubusercontent.com/meromoonmeri/projet-pmdo/6cca4a09380211e510ab1bea454a1b1926ef4b5a/renders/exemple/fichier.png
```

Ou relancer l'extraction avec `--avec-media` (voir `OUTILS/extraire_depuis_projet-pmdo.py`),
ou un `git sparse-checkout add renders/mon_dossier` dans un clone blobless.
