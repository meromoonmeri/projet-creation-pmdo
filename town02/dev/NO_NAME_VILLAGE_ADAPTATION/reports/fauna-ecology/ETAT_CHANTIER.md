# Écosystème NNV — état du chantier

Référence : tag `pre-fauna-injection` (`d17766cd`) · injection `6511bf43`.

Cycle appliqué à chaque étape :
**SAVE/BACKUP → HASH/VERIFY → COMMIT → PUSH → VERIFY PUSH**.

---

## 1. Grounds sécurisés — le point le plus urgent est réglé

### Deux niveaux, parce qu'un seul ne suffisait pas

Les 34 `.rsground` injectés pèsent **1,5 Go** (44 Mo pièce). L'archive complète
fait **233,5 Mo** : impossible à versionner (pack Git déjà à 743 Mo) et **Git
LFS est inutilisable ici** — `git-lfs` absent, hôtes de stockage bloqués.

Mais les `.rsground` sont **reproductibles** depuis la source. Ce qui ne l'est
pas, c'est le résultat du placement écologique. J'ai donc isolé ce delta :

| Niveau | Contenu | Taille | Emplacement |
|---|---|---:|---|
| **1 — Patch** | 1 642 entités, positions, ScriptVars, sha256 avant/après, inventaire des 205 fichiers | **58 Ko** | **Git** ✅ |
| **2 — Archive** | état complet, tar déterministe | 233,5 Mo | disque (`/tmp/fauna-archive`) |

Le patch de 58 Ko contient tout l'irremplaçable. **Même si le sandbox est
réinitialisé, l'état est reconstituable** : régénérer les Grounds puis
réappliquer le patch.

### Restauration prouvée, pas supposée

Extraction réelle dans un répertoire propre, puis :

| Vérification | Résultat |
|---|---|
| Fichiers extraits | 205 / 205 |
| SHA-256 comparés | **205 identiques, 0 divergent** |
| Entités relues dans les Grounds **extraits** | **1 642** |
| Backups `.pre-fauna.bak` intacts | 34 / 34 |
| Réconciliation | 1 642 + 109 + 57 = 1 808 ✅ |

Déterminisme du tar : `mtime=0`, `uid/gid=0`, mode 644, entrées triées.

**Aucun backup supprimé.** Les 34 `.pre-fauna.bak` (1,3 Go) restent en place
jusqu'à certification.

## 2. Scripts écologiques activés

`generated/fauna/` → `Data/Script/halcyon/` après dry-run.

Contrôles bloquants **avant** copie :
- syntaxe Lua validée par un vrai parseur (`luaparser`), pas par comptage de
  mots-clés — vérifié aussi sur 12 scripts du dépôt pour confirmer sa fiabilité ;
- aucune copie de `NNVLife.lua` ne peut redéfinir `source_birds`/`source_butterflies` ;
- `build_rmvillage_life_patch.py` ne peut pas les recréer (`EMIT_SOURCE_ANIMALS=False`).

Relecture post-installation : syntaxe OK.
`NNVEcology` est **l'unique propriétaire** — chaque entité porte
`nnv_owner: "NNVEcology"`.

## 3. Zone de duel installée

### `Data/Zone/index.idx` n'est PAS le même format que `Content/Tile/index.idx`

Audit avant écriture : celui des zones est du **JSON UTF-8-BOM**, pas du
binaire. Confondre les deux aurait corrompu le fichier.

Règles reprises de `ZoneData.GenerateEntrySummary()` (l. 132-163) :
- `CountedFloors` = somme des `FloorCount` des segments **`IsRelevant == true`**
  → nos 6 segments étant tous `false`, **`CountedFloors = 0`** ;
- `Maps` = un élément par segment ;
- `Grounds` = `GroundMaps`.

Invariant préservé : **57 fichiers = 57 entrées** avant, **58 = 58** après.
Les 57 entrées préexistantes sont comparées une à une : **intactes**.

`Data/Zone/index.idx` sauvegardé avant écriture (sha vérifié).

6 segments câblés dans `NNVDuel.SEGMENTS` → les duels sont **activables**.

### Cohérence statique zone ↔ maps ↔ scripts : 26 contrôles, 0 échec

Chaque `MapID` de segment pointe une `.rsmap` existante, tous les segments sont
`IsRelevant=false`, `NNVDuel` cible bien `nnv_wild`, `NNVEcology` appelle
`NNVDuel.Trigger`.

## 4. Gardes — toutes vertes après chaque étape

| Garde | Résultat |
|---|---|
| Suite écologie | **5 991** contrôles ✅ |
| Grounds injectés | **15 241** contrôles ✅ |
| Damier (`index.idx`) | 1 891 tuiles, aucun ✅ |
| Pixel-perfect | 6/6 maps ✅ |
| Restauration d'archive | 383 contrôles ✅ |
| Cohérence zone | 26 contrôles ✅ |

L'incident du premier `index.idx` (tué à 900 s, `.tile` copiés mais index non
mis à jour → damier détecté immédiatement, rollback, cause = concaténation
`bytes` quadratique sur 1,47 M d'entrées, corrigée par `b''.join`, **1,06 s**)
reste documenté dans `RAPPORT_FINAL_INJECTION.md`. La même rigueur a été
appliquée à `Data/Zone/index.idx` : backup, dry-run, relecture, comparaison
entrée par entrée.

## 5. Réconciliation — inchangée

```
1 808 placés = 1 642 injectés + 109 hors-saison + 57 sans preuve
```

- **109 HELD** (automne/hiver) : seule la variante `summer` existe. Non relogés,
  non remplacés.
- **57 HELD** : 11 rooms `NO_PROOF`. Aucune extrapolation.
- **Cradily et Sandshrew HELD** : toutes leurs occurrences sont dans `rmcave1*`.

## 6. Runtime PMDO — `NOT_CERTIFIED`

**Le runtime n'a pas pu être exécuté.** Ce n'est pas un oubli :

| Élément | État |
|---|---|
| Bundle headless PMDO | absent du sandbox |
| `dotnet` / `mono` | non installés |
| `dot.net`, `dotnet.microsoft.com`, `download.visualstudio.microsoft.com`, `builds.dotnet.microsoft.com`, `packages.microsoft.com`, `deb.debian.org` | **tous bloqués** (TLS/000) |

Sans .NET et sans accès réseau pour l'installer, **aucun test runtime n'est
possible**. Statut : **`NOT_CERTIFIED`**.

### Ce qui est prouvé vs ce qui ne l'est pas

**Prouvé** : structure des Grounds, positions écologiques (terrain + collision
8 px relus fichier par fichier), non-régression collision/rendu contre backups,
identité pixel du décor de duel via la chaîne moteur réelle, résolution de
toutes les tuiles, cohérence zone/maps/scripts, syntaxe Lua.

**Non prouvé** : que le jeu se lance, que les Grounds se chargent en mémoire,
que les Pokémon apparaissent à l'écran, que les coroutines de déplacement
tournent, qu'un duel se déclenche et revient correctement.

La simulation hors moteur (21 415 déplacements, 80 rencontres, 0 végétatif) est
une **preuve logique de l'algorithme**, pas une certification runtime. Je ne la
présente pas comme telle.

## 7. Ce qui reste

1. **Runtime PMDO** dès qu'un bundle .NET est disponible → certification.
2. ~~**Variantes automne/hiver/printemps** des 34 Grounds → libère les 109 HELD.~~
   ~~Terrain levé.~~ **Conversion faite** — voir `held-converted/`. 15/15 rooms
   converties en Grounds PMDO normalisés ×0,125, dans leur **saison native**,
   100 % de couverture, 0 tuile non résolue. Ne reste que le runtime.
3. ~~**Reconversion des 11 rooms `NO_PROOF`**~~ → **faite**, voir
   `../noproof-rooms/converted/`. 11/11 converties et normalisées, collision
   8 px produite (315 à 2 002 cellules bloquantes selon la room), 0 tuile non
   résolue. Ne reste que le runtime.
4. **`init.lua` par Ground** appelant `NNVEcology.Load()` : les scripts sont
   installés mais aucun Ground ne les invoque encore. C'est la prochaine étape
   d'activation, et elle touche 34 fichiers.

## 8. Réconciliation mise à jour

```
1 808 placés = 1 642 injectés + 109 terrain prouvé + 57 rendu prouvé
```

Le total et la répartition ne bougent pas. Ce qui change est la **nature du
blocage** restant sur les 166 non injectées :

| Lot | Avant | Maintenant | Reste à faire |
|---|---|---|---|
| 109 | terrain saisonnier inconnu | **converti en Ground PMDO (15/15)** | runtime 0.8.12 |
| 57 | ni rendu ni collision | **converti + collision 8 px (11/11)** | runtime 0.8.12 |

**Aucune entité n'a été promue.** `promotion_allowed` reste `false` sur les deux
lots. Le fail-closed n'a pas été assoupli : ce sont les preuves manquantes qui
ont été produites, pas les exigences qui ont été abaissées.

Un défaut réel a d'ailleurs été trouvé au passage et corrigé : `is_snow_rgb`
ne reconnaissait pas la neige lavande de NNV, et l'atlas étiquetait `grass`
16 896 cellules enneigées. Les 43 positions d'hiver ont été revérifiées contre
l'habitat déclaré de chaque espèce — 43 conformes, 0 non conforme.


---

## 9. Mise à jour — les deux lots ne sont plus bloqués que par le runtime

Les 166 entités non injectées attendaient chacune une conversion en Ground PMDO.
**Elle est produite pour les 26 rooms concernées.**

| Lot | Rooms | Conversion | Collision | Couverture | Reste |
|---|---:|---|---|---:|---|
| 109 HELD | 15 | ✅ 15/15 | ✅ | 100 % | runtime |
| 57 NO_PROOF | 11 | ✅ 11/11 | ✅ | 94,2–100 % | runtime |

### Un défaut réel trouvé au passage, dans mon propre travail

Le premier jet convertissait tout en `--season summer`. Or le convertisseur ne
se contente pas d'étiqueter la saison : il **substitue le tileset** de chaque
couche. **12 rooms sur 26 sont hivernales** et ressortaient avec un sol vert au
lieu de la neige — la mauvaise saison peinte sur toute la carte.

Aucun compteur ne l'a signalé : toutes affichaient `CONVERTED_NORMALISED` et
0 tuile non résolue. **C'est la planche de contact qui l'a montré.**

`tools/detect_native_season.py` corrige à la racine, et son résultat recoupe
exactement le classement 10 automne / 5 hiver de `HELD_SEASONAL_TERRAIN.md`,
obtenu par une méthode indépendante.

### La promotion reste refusée

`promotion_allowed` = **`false`** sur les deux lots. Restent ouverts les blockers
du convertisseur — faune non liée au moteur, transitions non résolues, couches
`Effect` non portées — et surtout le **runtime PMDO 0.8.12**, jamais exécuté :
ni `dotnet` ni `mono`, les 5 hôtes .NET répondent `000`.

Réconciliation inchangée : `1 808 = 1 642 + 109 + 57`.
