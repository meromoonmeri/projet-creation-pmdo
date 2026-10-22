# Câblage `NNVEcology.Load()` — rapport

Commit `0da53030`, poussé et vérifié contre le distant.

---

## 1. 34/34 Grounds câblés

| | |
|---|---|
| Fichiers `init.lua` câblés | **34 / 34** |
| Entités couvertes | **1 642 / 1 642** |
| Contrôles post-câblage | **9 036**, 0 échec |
| Rooms `NO_PROOF` câblées | **0** |

## 2. Où l'appel est fait, et pourquoi

Le moteur appelle `Init(map)` une fois, `Enter(map)` à chaque entrée, puis
`Update(map)` à chaque frame.

| Fonction | Ce qu'on y met | Raison |
|---|---|---|
| `Init` | **rien** | les entités ne sont pas garanties prêtes ; NNVLife a déjà appris que muter le moteur ici est dangereux |
| `Enter` | `NNVEcology.Load(<asset>)` + `Setup()` | les `MapChars` sont chargés avec la carte ; `Setup()` est sans effet de bord |
| `Update` | `NNVEcology.Update()` | la vie tourne ici ; toute mutation moteur est différée au premier Update |

Vérifié fichier par fichier : **aucun appel faune dans `Init`**.

## 3. `Load()` est devenu autonome

Il ne dépendait d'aucune donnée externe passée en argument : je lui ai ajouté
`E.Discover(room)`, qui reconstruit les colonies **depuis le Ground lui-même**.

Chaîne moteur vérifiée dans RogueEssence 0.8.12 :

```
_ZONE.CurrentGround.Entities[i].MapChars   -> List<GroundChar>  (public)
GroundChar.EntName                         -> nom de l'entité
LTBL(ch) == ch.LuaData == Data.LuaDataTable -> nos ScriptVars
```

`LTBL` est le mécanisme déjà utilisé par `GeneralFunctions.lua` et `common.lua`
du dépôt — pas une invention.

Le filtre est double : `nnv_kind == 'wild'` **et** `nnv_owner == 'NNVEcology'`.
Aucun PNJ narratif ni entité d'un autre système ne peut être capturé.

## 4. Aucun double chargement

- `Load()` écrase entièrement `E.roster`/`E.colonies` et remet
  `tick`/`cursor`/`ready` à zéro : deux appels ne peuvent pas empiler deux
  rosters.
- Le câbleur **refuse** d'insérer si un appel existe déjà.
- Vérifié sur les fichiers écrits : exactement **1 `Load()`, 1 `Setup()`,
  1 `Update()`** par fichier.

## 5. Un bug attrapé avant écriture

Le premier dry-run a **refusé les 34 fichiers**. Deux causes réelles :

1. `function M.Update(map) end` est écrit **sur une seule ligne** dans les
   init.lua générés. Mon regex exigeait un saut de ligne après la signature,
   échouait, et créait une **seconde** `M.Update` — en Lua la dernière écrase
   la première, donc **le corps d'origine aurait été perdu**. Corrigé en
   traitant les deux styles.
2. Ma garde « ligne perdue » était trop littérale : réécrire une fonction
   d'une ligne en forme multiligne est légitime. Remplacée par des contrôles
   qui portent sur le sens — fonctions présentes, non dupliquées, appels
   moteur préservés.

Aucune écriture n'a eu lieu pendant ces deux itérations.

## 6. Grounds sans faune : aucune erreur

`Discover()` renvoie une liste vide → `Update()` sort immédiatement. Vérifié en
retirant la faune d'un Ground réel : 87 → 0 `MapChars`, 0 colonie, aucune
exception. Tous les appels sont sous `pcall` : **la faune ne peut pas casser un
Ground ni une cinématique**.

## 7. Comportement narratif inchangé

Comparaison de chaque `init.lua` avec son `.pre-wire.bak` :

- aucune fonction `M.X` perdue ;
- aucune fonction dupliquée ;
- **tous les appels moteur d'origine préservés** (`LivingWorld.*`, `TownNight.*`,
  `Seasons.*`, `Weather.*`, `GAME:*`, `TownPlace.*`) ;
- les transitions `Exit_*_Touch` intactes ;
- chaque fichier reparse (`luaparser`).

Aucune variable existante écrasée : on insère `M.Context`, `M.Day`,
`M.SourceSeason` restent tels quels.

## 8. Le monde vit — pas de clones synchronisés

Simulation de la boucle réelle, profils lus **depuis le Lua installé** (source
de vérité du runtime), 240 passes sur les 87 individus de rm83 :

| Mesure | Résultat |
|---|---|
| Déplacements | **17 132** |
| Paires de même espèce comparées | 1 439 |
| **Trajectoires relatives identiques (clones)** | **0** |
| Séquences d'états distinctes | 12 |
| États distincts observés | 8 (`vol`, `virage`, `pose_breve`, `derive`, `tourne`, `affleure`, `suit`, `vire`) |
| Individus jamais mobiles | **0** |
| Profils végétatifs | **0** |

La désynchronisation vient de la phase propre à chaque individu (son index dans
la colonie), qui décale pause, direction et état.

> Note d'honnêteté : mon premier test lisait les `states` dans le JSON alors
> qu'ils vivent dans le Lua — il ne rapportait qu'un seul état. Corrigé en
> lisant `Data/Script/halcyon/NNVEcology.lua`, le fichier réellement exécuté.

## 9. Gardes vérifiées par régression

| Régression injectée | Détection |
|---|---|
| Double `NNVEcology.Update()` | ✅ `2 appels Update` |
| Appel sorti du `pcall` | ✅ `hors pcall` |

Retour au vert après restauration dans les deux cas.

## 10. Suite complète après câblage

| Garde | Résultat |
|---|---|
| Suite écologie | 5 991 ✅ |
| Grounds injectés | 15 241 ✅ |
| Câblage | 9 036 ✅ |
| Damier `index.idx` | aucun ✅ |
| Pixel-perfect duels | 6/6 ✅ |
| Restauration d'archive | 383 ✅ |

## 11. État du fail-closed — inchangé

```
1 808 = 1 642 injectés + 109 hors-saison + 57 sans preuve
```

- **109 HELD** (automne/hiver) : intacts, non relogés.
- **57 HELD** (11 rooms `NO_PROOF`) : aucune room câblée, vérifié explicitement.
- **Cradily et Sandshrew : toujours HELD.** Le câbleur refuserait tout fichier
  les contenant.

## 12. Sauvegarde

- Archive régénérée après câblage (les `init.lua` ont changé) : **233,5 Mo**,
  restauration reprouvée — 205/205 hashes, 1 642 entités relues dans les
  Grounds *extraits*.
- Patch versionné : **58 Ko** dans Git.
- Les 34 `init.lua` câblés sont **versionnés** dans
  `generated/fauna/ground-init/` (140 Ko) : même après un reset du sandbox, le
  câblage est récupérable.
- Backups `.pre-wire.bak` conservés. Aucun backup supprimé.

## 13. Runtime : `NOT_CERTIFIED`

Rien n'a changé sur ce point et je ne le présente pas autrement. Ni `dotnet` ni
`mono`, et les 6 hôtes .NET testés sont bloqués. Aucun test runtime n'a pu être
exécuté.

**Ce qui est prouvé** : structure et syntaxe des 34 `init.lua`, placement des
appels dans le cycle de vie, absence de double chargement, préservation du
comportement narratif, cohérence des 1 642 entités que `Discover()` verra,
désynchronisation des individus.

**Ce qui ne l'est pas** : que le jeu se lance, que les Grounds se chargent, que
les Pokémon apparaissent, que les coroutines tournent, qu'un duel se déclenche
et revienne.

La simulation est une preuve **logique de l'algorithme**, pas une certification.
