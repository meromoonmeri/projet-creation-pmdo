# Audit exhaustif — crash Mod Dev lors du déblocage

Date : 2026-08-07  
Branche : `arena/019fd882-new-era-abyss-to-ascension-v4`

## Symptôme ciblé

Crash pendant la création/initialisation d’une sauvegarde en Mod Dev, au moment où `DebugTools:OnNewGame()` déverrouille les destinations.

## Causes racines confirmées statiquement

### 1. Déblocage aveugle de tout l’index Zone

Ancien code :

```lua
local dungeon_keys = ...:GetOrderedKeys(false)
for ii = 0, dungeon_keys.Count-1 do
  GAME:UnlockDungeon(dungeon_keys[ii])
end
```

Cette boucle incluait des entrées qui ne sont pas des donjons de destination :

- `master_zone` : hub de Grounds, `CountedFloors = 0` ;
- `bug_maze` : zone spéciale dojo, `CountedFloors = 0` ;
- `electric_maze` : zone spéciale dojo, `CountedFloors = 0`.

`master_zone` ne doit jamais passer par `UnlockDungeon`. Une fois ajouté aux destinations de la sauvegarde Dev, le menu tente de le traiter comme un donjon et peut échouer en construisant son résumé.

### 2. `UnlockDungeon("bourg_comptoir")` sur un Ground

`altere_pond_ch_11.lua` appelait :

```lua
GAME:UnlockDungeon("bourg_comptoir")
```

Or `bourg_comptoir` est le Ground technique de Treasure Town dans `master_zone`, pas un fichier `Data/Zone/bourg_comptoir.json`. L’appel était protégé par `pcall`, ce qui masquait le diagnostic, mais injectait une opération sémantiquement invalide dans le flux de déblocage.

### 3. Namespace mort `source_duns_imbi`

Onze scripts non chargés par le namespace `halcyon` contenaient des déblocages de zones absentes :

- `berry_grove` ;
- `ashen_geode` ;
- `grainy_pasture` ;
- `gourmet_jungle` ;
- ainsi que des menus de destinations pointant vers plusieurs zones externes absentes.

Ce namespace n’était requis nulle part et constituait du code mort importé. Il a été supprimé.

## Correctif

Le déblocage Dev :

1. lit le résumé de chaque zone ;
2. exclut `master_zone` ;
3. exige `Released == true` ;
4. exige `CountedFloors > 0` ;
5. protège chaque zone individuellement par `pcall` ;
6. journalise l’entrée exclue ou fautive sans interrompre la création de la sauvegarde.

Les labyrinthes spéciaux dojo à `CountedFloors = 0` restent déverrouillés uniquement par leur flux dédié, pas par le déblocage global.

## Garde-fou ajouté

`tools/audit_unlocks.py` vérifie :

- chaque appel littéral `GAME:UnlockDungeon` contre `Data/Zone/index.idx` ;
- les zones à zéro étage compté ;
- la présence du dangereux patron de déblocage global non filtré ;
- l’utilisation interdite de `master_zone` comme donjon.

Résultat après correction :

- 128 appels littéraux examinés ;
- 0 identifiant de zone absent ;
- 0 déblocage global non filtré ;
- 4 avertissements attendus décrivant les trois entrées exclues.

## Validations complémentaires

- `audit_bugs.py` : 0 signalement ;
- `audit_imports_canoniques.py` : 0 erreur, 0 avertissement ;
- `validate_all.py` : OK ;
- `verify_zone_index.py --all` : 0 incohérence sur les zones comparables ;
- `git diff --check` : OK.

## Validation runtime encore nécessaire

L’environnement d’audit ne lance pas RogueEssence. Tester :

1. nouvelle sauvegarde Mod Dev ;
2. arrivée sur le premier Ground ;
3. ouverture du menu des destinations ;
4. vérification que `master_zone`, `bug_maze` et `electric_maze` ne figurent pas dans le menu général ;
5. vérification que les labyrinthes Bug/Électrique restent accessibles depuis le dojo ;
6. transition chapitre 11 vers Treasure Town sans tentative de `UnlockDungeon("bourg_comptoir")`.

Si un crash subsiste, fournir `Logs/` ou la stack trace complète : il s’agira alors d’une seconde cause runtime distincte du déblocage invalide corrigé ici.
