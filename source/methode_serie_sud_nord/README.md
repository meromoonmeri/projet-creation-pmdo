# Méthode — série d’entrées / fins sud → nord

Chantier **documentaire** : la méthode courante de création de cartes du projet,
telle qu’elle est réellement pratiquée depuis le format 4:3 (Entrée Jungle, 26 sept. 2026)
jusqu’à Fin Star Cave (FST1, 29 sept. 2026).

Ce n’est **pas** un générateur. Les builders vivent chacun dans `source/<lot>/`.
Ici : le gabarit, l’ordre des lots, les préfixes, ce qu’il reste à faire.

| Document | Rôle |
|---|---|
| [WORKFLOW.md](WORKFLOW.md) | Relancer un lot, en créer un nouveau, récupérer les bruts |
| [STATUS.md](STATUS.md) | État de la série, carte suivante, préfixes pris |
| [../../WORKFLOW.md](../../WORKFLOW.md) | Workflow de session (racine) |
| [../../GUIDE_CREATION_DE_MAP.md](../../GUIDE_CREATION_DE_MAP.md) | Méthode pas à pas (formats, calques, Ground) |
| [../../METHODE_MAGENTA_ET_GENERATEUR.md](../../METHODE_MAGENTA_ET_GENERATEUR.md) | Magenta, `key()`, `classify()`, fidélité |

## Gabarit à copier

`source/entree_jungle_sud_nord_v1/` — `build.py`, `test_build.py`, `package.py`,
`viewer_template.html`, `README_PACK.md`, désormais `WORKFLOW.md`.

Une **fin** se calque plutôt sur `source/fin_star_cave_v1/` ou `source/fin_jungle_sud_v1/`
(même biome que l’entrée, pas de bouche sombre, marqueurs `entrance` / `boss` / `objectif`).

## Contrat en une phrase

> Rendu généré **référencé** (rip PMD en `images=`) → décor sur magenta → segmentation
> pleine résolution → réduction par classe à 768 × 576 → un calque par fonction + Top vide
> → animations en boucle fermée → collisions 16 × 16 → tests Python → paquet PMDO 0.8.12.
> Les pixels livrés ne sont **pas** des tuiles natives. `art_approved: false`.
