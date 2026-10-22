# Restitution canonique — Wish Cave

## Paquet

- Zone : `wish_cave`
- 98 floors procéduraux + 99F fixe
- Ground/arène D23P01 : `sanctuaire_voeu` / `wish_cave_jirachi.rsmap`
- Jirachi niveau 40
- équipe ramenée au niveau 1
- argent interdit à l’entrée

## Rencontre et vœux

Après la victoire, le joueur revient dans le même sanctuaire et choisit :

1. beaucoup d’argent ;
2. beaucoup d’objets ;
3. une Friend Area non possédée ;
4. plus de puissance ;
5. quelque chose de bien.

`WishSystem.lua` applique les récompenses. `FriendAreas.lua` contient les 57 zones d’accueil PMD Red et peut accorder aléatoirement une zone non possédée. Une Friend Area reste un habitat Grodoudou, jamais une arène.

## Géométrie

- grille verticale 4×6 ;
- cellules 7×7 ;
- salles 3–8 ;
- BranchRatio 55–96 % ;
- halls 1–2 ;
- reconnexion 20 %.

Aucun patron exact partagé.

## Sauvegarde

- `SV.WishCave` : Wish Stone, retour de victoire, vœu accordé ;
- `SV.FriendAreas.Owned` ;
- `SV.FriendAreas.Residents` ;
- `SV.CanonicalDungeons.WishCaveCleared`.

## Validation

- 99 floors comptés ;
- 57 IDs Friend Areas uniques ;
- index synchronisé ;
- SpawnRangeList valides ;
- Jirachi seul ;
- scène, combat et vœu dans D23P01.
