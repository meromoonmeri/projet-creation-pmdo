# Sinister Woods — comparaison matériau ROM → PMDO

**Verdict global : `BLOCKED_WITH_EXACT_MISSING_COMPONENT`**
**Verdict de comparaison : `REPLACE_REQUIRED`**

La comparaison a été réalisée avec le ROM EU authentifié et le renderer
existant `tools/pmdred_dungeon_ground.py`. Aucun fichier de production graphique
n'a été modifié par cette comparaison. Le câblage Relic Forest de la Zone a
ensuite été corrigé séparément ; voir
`docs/pmdred_eu/narrative_audit/SINISTER_WOODS_RELIC_FOREST_SEPARATION_2026-08-18.md`.

## Correction importante de sélection ROM

`mapparam` montre que le dungeon ID `3` n'utilise pas le même matériau pour
les étages procéduraux et la salle finale :

- étages procéduraux, lignes 1–12 : **tileset 41** → `b41fon`, `b41cel`,
  `b41cex`, `b41pal`, `b41canm` ;
- ligne finale 13 : **tileset 65** → `b65fon`, `b65cel`, `b65emap0`, `b65pal`,
  `b65canm`.

Utiliser `b65*` pour les étages procéduraux aurait donc été contraire à la
source ROM. Le `b65*` déjà reconstruit reste la référence de la finale directe
D04P02 et n'est pas modifié.

## Comparaison procédurale b41 → TreeshroudForest1

| Mesure | ROM b41 | PMDO Treeshroud |
|---|---:|---:|
| matériau CEL/chunks comparés | 127 chunks CEX utilisés | 1 234 tuiles |
| taille d'une tuile | 24×24 | 24×24 |
| couleurs RGB affichées | 38 | 63 |
| intersection exacte des couleurs | `0` | — |
| chunks 24×24 pixel-exacts | `0` | — |
| animations CANM | 16 records actifs | — |
| animations AutoTile | — | 90 groupes secondaires animés |

Le matériau `TreeshroudForest1` n'est donc pas une équivalence pixel/structurelle
au matériau ROM b41. Ce n'est pas une différence de simple nommage : les sets
de couleurs n'ont aucune intersection et aucun chunk complet ne correspond.

## Ressources à remplacer après reconstruction complète

La cible de remplacement est précisément :

- `TreeshroudForest1.tile` ;
- `Data/AutoTile/treeshroud_forest_1_floor.json` ;
- `Data/AutoTile/treeshroud_forest_1_wall.json` ;
- `Data/AutoTile/treeshroud_forest_1_secondary.json`.

La reconstruction candidate doit encore dériver, depuis b41/CEX, les rôles
PMDO floor/wall/secondary et leur mapping d'adjacence. Aucun atlas incomplet
n'est promu.

Les six `relic_forest_blob_*` restent hors périmètre et ne seront pas modifiés.
D04P01/D04P02 restent également intacts.

## Runtime procédural contrôlé

Une fixture ignorée a chargé les segments 0, 1 et 3 de `gloomy_forest` :

- segment 0 : `38×51`, 2 probes libres / 2 bloquées ;
- segment 1 : `51×38`, 4 libres / 0 bloquée ;
- segment 3 : `38×64`, 4 libres / 0 bloquée ;
- musique observée : `Sinister Woods.ogg` ;
- terminaison PMDO : `NORMAL_EXIT`, code 0, sans watchdog ni processus résiduel.

La gate stricte reste toutefois bloquée par une erreur réelle du contenu actuel :

```text
Missing Data: deep_shadow
```

Référence : `Data/Zone/gloomy_forest.json:6808`,
`DefaultMapStatusStep.SetterID = deep_shadow`. Le fichier
`Data/MapStatus/deep_shadow.json` n'existe pas. Aucun fichier de statut n'a été
inventé et aucun remplacement approximatif (`darkness`, `dusk` ou autre) n'a
été effectué.

## Mise à jour post-gates — 2026-08-19

Les étapes b41, `deep_shadow` et la séparation Relic Forest ont depuis été
fermées. Le matériau n'est pas installé sous les noms Treeshroud partagés :
les consommateurs Relic/New Era restent inchangés. La promotion contrôlée,
avec namespace unique, est documentée dans
`SINISTER_WOODS_B41_PROMOTION_2026-08-19.md`.

Le présent document reste l'audit historique qui a établi `REPLACE_REQUIRED`
pour l'ancien triplet Treeshroud ; il ne doit pas être lu comme le verdict
final post-promotion. Le verdict graphique/runtime courant est celui de la
preuve post-gates ; la certification du portage narratif PMD Red complet reste
bloquée séparément.
