# Entrée Crevasse enneigée (4:3) — projet PMDO 0.8.12

Ce dossier est un projet d'édition autonome : `entree_crevasse_enneigee_sud_nord`. Il contient le Ground `ece1_entree_crevasse_enneigee` au **format 4:3 vaste**, soit 768 × 576 px ou 96 × 72 cases de 8 px (`TexSize=1`).

C'est une nouvelle entrée de donjon de la série sud → nord. On arrive au sud, sur un chemin de neige abaissé entre deux bancs bordés de corniches rocheuses et parsemés de boules de neige. Le chemin remonte jusqu'à une crevasse sombre, qui fend une grande falaise de glace lavande sur toute la largeur du nord. Le biome est inédit et a été choisi par l'agent : il reste à confirmer.

## Installer

- **Projet séparé** : copier `entree_crevasse_enneigee_sud_nord` dans `PMDO/MODS/`, activer le mod, puis ouvrir le Ground.
- **Dans un mod existant** : lancer `python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run`, puis relancer la même commande sans `--dry-run`.

## Calques (bas → haut)

| # | Calque | Animation |
|---|---|---|
| 00 | Sol complet : neige bord à bord (neige praticable du décor, blanc du rip ailleurs) | fixe |
| 01 | Neige blanche praticable | fixe |
| 02 | Ombres : neige ombrée lavande, boules de neige, sol de la grotte (praticables) | fixe |
| 03 | Corniches : rebords rocheux des bancs de neige | fixe |
| 04 | Falaises de glace, cristaux, parois de la crevasse | fixe |
| 05 | Profondeur : bouche de la crevasse | fixe |
| 06 | Scintillements : 16 éclats de givre au pied des falaises (poses générées) | 48 × 4 ticks |
| 07 | Flocons : chute de neige, 72 flocons qui ondulent puis se posent (poses générées) | 48 × 4 ticks |
| 08 | Vide, `Layer=4` (Top) | — |

La scène complète boucle en 192 ticks (3,2 s). Chaque pixel de calque est soit opaque, soit transparent : aucun alpha intermédiaire. **Toutes les couleurs sont des couleurs exactes du rip `D79P11A`.**

## Marqueurs et collisions

- **Marqueurs** :
  - `entrance` au sud, au bord de la carte, dans le chemin central ;
  - `donjon_seuil` sur le pas de la crevasse.

  **Aucun warp, aucune destination.**
- **Collisions** : seules la neige et les ombres sont praticables, sol de la grotte compris. Les boules de neige sont peintes sur la neige et restent praticables. Les corniches, les falaises et la bouche sont bloquées. Les flocons et les éclats sont purement visuels. Un chemin libre de 16 × 16 px de l'arrivée au seuil a été vérifié sur la grille. **À contrôler en jeu.**

## Limites

- **Terrain** : dessin généré à partir de la map `D79P11A` de la ROM (rendu skytemple depuis `pret/pmd-sky`). Ce ne sont pas des tuiles natives. Seules les couleurs sont exactes : chaque pixel prend la couleur du rip la plus proche. Le nom officiel du lieu n'est pas identifié.
- **Sol complet** : construit par le pipeline. Les deux éditions du générateur ont été écartées, car elles donnaient du bruit et des taches.
- **Animations** : le rip est statique. La chute de neige et les scintillements sont créés par nous à partir d'une planche générée. Ce ne sont pas des animations officielles.
- **Tests** : aucun test fait dans PMDO.
