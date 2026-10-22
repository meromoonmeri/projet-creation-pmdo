# BIBLIOTHEQUE — frontière d’intégration

`external/BIBLIOTHEQUE/` est un sous-module Git en lecture de travail, épinglé au
dépôt indépendant `meromoonmeri/BIBLIOTHEQUE`.

## Rôle

- fournir une source externe consultable pour les futurs inventaires de zones ;
- conserver l’historique et la provenance dans le dépôt BIBLIOTHEQUE ;
- empêcher l’import massif des fangames dans l’historique New Era ;
- permettre de construire ultérieurement des manifests et rapports filtrés.

## Interdictions

Le sous-module n’est pas une dépendance runtime de New Era. Aucun fichier brut ne
doit être copié automatiquement vers `Data/`, `Content/` ou les scripts PMDO.
Les exécutables, moteurs, systèmes de jeu, dialogues, castings, sprites humains
et sprites de personnages/Pokémon restent exclus du pipeline environnemental.

Seuls les maps, layouts, tilesets, couches, animations de décor, VFX
strictement environnementaux et leurs métadonnées pourront être sélectionnés,
après inventaire, provenance, filtrage et validation. Une conversion ne doit
jamais modifier les Grounds, tiles, chapitres ou validations PMD Red existants.

## Initialisation

```bash
git submodule update --init --depth 1 external/BIBLIOTHEQUE
```

## Espace de travail de cette session

À la demande du propriétaire, `external/BIBLIOTHEQUE_WORKSPACE/` contient les
schémas, outils et métadonnées dérivées suivis sur cette branche. Cet overlay ne
contient aucune source brute et n'est jamais chargé par PMDO. Son arborescence
est volontairement transférable vers le dépôt BIBLIOTHEQUE.

Toute évolution des sources brutes doit rester commitée dans le dépôt
BIBLIOTHEQUE. Le pointeur du sous-module ne peut être mis à jour qu'après audit.
