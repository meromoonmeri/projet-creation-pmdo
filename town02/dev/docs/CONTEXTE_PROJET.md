# Contexte projet — New Era : Abyss to Ascension

> **Fichier de reprise.** À lire en premier au début de chaque session.
> Dernière mise à jour : 25/07/2026 — dépôt **V4**, base `e34af24` (checkpoints) + cette passe.

---

## 0. Fusion V2 → V4 (25/07/2026)

Ce travail a été développé sur la base `f2a50d3` puis **fusionné** dans le dépôt V4,
qui contenait déjà un commit indépendant `e34af24` (**système de checkpoint
mi-donjon** : `crooked_cavern_midpoint`, `gloomy_forest_midpoint`, cartes 60 et 61).

**Rien n'a été écrasé.** Quatre fichiers étaient touchés des deux côtés :

| Fichier | Résolution |
|---|---|
| `GeneralFunctions.lua` | lignes différentes (V4 : bouton *Sauvegarder* ; moi : typo `Parnter`) → fusion automatique |
| `crooked_den_ch_3.lua` | lignes différentes (V4 : segment 1→2 ; moi : casse musique) → fusion automatique |
| `scriptvars.lua` | blocs distincts → fusion automatique |
| `zone/gloomy_forest/init.lua` | **conflit de conception, fusionné à la main** (voir ci-dessous) |

### Conflit `gloomy_forest` — comment il a été tranché

V4 redirige les défaites vers le **relais de mi-donjon** (carte 61) ; ma correction
renvoyait à la **guilde** pour la séquence dîner/nuit/lendemain. Les deux intentions
sont conservées, selon l'endroit où meurt le joueur :

| Situation | Destination | Nuit ? |
|---|---|---|
| Défaite/fuite segment 0 (étages normaux) | guilde, carte 6 (ou 22) | ✅ oui |
| Objectif de sauvetage non rempli | guilde, carte 6 | ✅ oui |
| Fuite volontaire depuis les profondeurs | guilde, carte 6 | ✅ oui |
| Défaite segment 1 (profondeurs) | relais, carte 61 | ❌ non — on repart du checkpoint |
| Défaite segment 2 (Zarude) | relais, carte 61 | ❌ non — on repart du checkpoint |

C'est cohérent : on ne dort que lorsqu'on rentre réellement à la guilde.
**Le bug d'origine était toujours présent dans V4** (segment 0 renvoyait carte 1,
Metano Town, en plein jour) — il est corrigé ici.

### Bug bloquant trouvé DANS le code V4

`SV.GloomyForest` était écrit par `zone/gloomy_forest/init.lua` en cas de défaite
au-delà du checkpoint, mais **jamais déclaré** dans `scriptvars.lua`. Seul
`debug_tools` posait un garde-fou, que le joueur n'exécute jamais.
Résultat : `attempt to index a nil value (field 'GloomyForest')` — **crash à chaque
défaite dans les profondeurs ou contre Zarude**. Détecté par simulation Lua, corrigé
(déclaration ajoutée à côté de `SV.SearingTunnel`, qui suit le même motif).

---

## 1. Connaissances techniques acquises (ne pas les redécouvrir)

### Format `.tile` — décodé et validé

Format binaire propriétaire, **round-trip byte-identique vérifié** sur 5 fichiers.

```
uint32   tileSize            (8 ou 24 px)
uint32   tileCount
tileCount × (uint64 key, uint64 absoluteOffset)
à chaque offset : uint64 length + PNG brut
```

- **Clé** : `key = x | (y << 32)` où `(x, y)` est la position dans l'atlas.
- **Déduplication** : plusieurs clés peuvent pointer le **même offset** (jusqu'à 99 % de
  dédup sur `Vast_Steppe_Base`). Une réécriture naïve casse le fichier — il faut
  préserver le partage d'offsets.
- Outils prêts : `compose.py` (`sheet()`, `write_tile()`, `rebuild_index()`).

### `Content/Tile/index.idx`

```
uint32 nbTilesets
puis pour chacun : uint8 lenNom, nom UTF-8, uint32 tileSize, uint32 tileCount,
                   copie de la table (tileCount × 16 octets)
```
**À régénérer après tout ajout de tileset** (`compose.rebuild_index()`).

### Architecture des cartes

| Élément | Rôle |
|---|---|
| `Data/Ground/<nom>.rsground` | Carte de **cinématique** (exploration, dialogues) |
| `Data/Map/<nom>.rsmap` | **Étage de combat** (grille de tuiles logiques, équipes ennemies) |
| `Data/Zone/<zone>.json` | Donjon : liste de **segments** (procéduraux ou salle fixe) |

**Une salle de boss a besoin des deux fichiers** (`.rsground` + `.rsmap`), plus un
segment `LoadGen` + `MappedRoomStep` dans le JSON de zone. Modèle de référence :
`gloomy_forest_boss` et `searing_crucible`.

### Points de vigilance

- **Grilles `Tiles[X][Y]`** — l'indice extérieur est X (largeur). Idem `obstacles[X][Y]`.
- **`TexSize`** : 1 → tuiles 8 px, 3 → 24 px. **Pas de mélange dans une même carte.**
- **Toutes les cartes sont « identity-mapped »** : la tuile en (x,y) référence toujours
  `TexLoc {X:x, Y:y}` de sa propre feuille. Chaque carte a donc son `.tile` dédié,
  qui est en réalité l'image de la carte découpée. Il n'existe **pas** de bibliothèque
  de motifs réutilisables : pour composer, on prélève des morceaux de cartes existantes.
- **`obstacles`** : `Tags = 0` marchable, `1` bloqué. Grille toujours en cellules de 8 px,
  donc `W*TexSize × H*TexSize` cellules.
- **Chaîne de chargement Lua** : un `ground/<map>/init.lua` doit `require` explicitement
  chaque `<map>_ch_N.lua` dont il appelle des fonctions. Erreur classique et silencieuse.

---

## 2. Travail réalisé dans cette passe

### Étape 1 — déblocage du chapitre 5 ✅

| # | Correctif | Fichier |
|---|---|---|
| 1 | `GAME:UnlockDungeon("dark_maze")` supprimé (zone inexistante → crash au passage ch.5→6) | `ground/guild_heros_room/init.lua` |
| 2 | `gloomy_forest` ajouté au menu de destination + 4 entrées de `dungeon_entrance_mapping` (`vast_steppe` 46, `searing_tunnel` 47, `mount_windswept` 50, `gloomy_forest` 51) — évitait un `nil` au départ en donjon d'histoire | `ground/metano_town/init.lua` |
| 3 | Les 5 `init.lua` de boss : ajout du `require` du module `_ch_5` + appels repointés (`<map>_ch_5.FirstPreBossScene()`) | `ground/*_miniboss\|guardian/init.lua` |
| 4 | **5 salles de boss créées** (voir § 3) | `Data/Ground/`, `Data/Map/`, `Content/Tile/` |
| 5 | Segments ajoutés : `vast_steppe` et `mount_windswept` passent de 1 à **4 segments** (0 procédural, 1 mini-boss, 2 procédural, 3 gardien) | `Data/Zone/*.json` |

**Bug supplémentaire trouvé et corrigé** : les 7 espèces de boss du chapitre 5
(`Mudbray`, `Stantler`, `Torkoal`, `Magmar`, `Gligar`, `Skarmory`, `Aerodactyl`)
étaient invoquées par `MakeCharactersFromList` mais **absentes de la table `characters`**
→ `characters[name]` = `nil` → **crash immédiat de chaque cinématique**.
Ajoutées dans `CharacterEssentials.lua`. Le mod est `ModType: Quest`, les sprites
viennent du jeu de base à l'exécution (seuls 39 `.chara` sont embarqués) — les
identifiants d'espèce suffisent.

### Étape 2 — cohérence du scénario ✅

| # | Correctif | Détail |
|---|---|---|
| 6 | **`gloomy_forest.ExitSegment`** : les 3 sorties passent par un helper `EndDayReturn()` qui pose `Dinnertime`/`Bedtime`/`MorningWakeup`/`MorningAddress` et sort vers la carte 6 (réfectoire) ou 22 | C'était **le bug d'origine signalé** : défaite → retour en pleine ville de jour, sans dîner ni nuit, et `DaysPassed` bloqué |
| 7 | **`gloomy_forest_boss`** : branche ajoutée quand `GloomyBossEncountered` est vrai mais le boss pas vaincu → relance le combat au lieu d'un simple `FadeIn` sans sortie | Le joueur restait **bloqué sans issue** après une défaite contre Zarude |
| 8 | 5 drapeaux `SV.Chapter5.*BossSeen` déclarés ; faute `ParnterCompletedForest` → `PartnerCompletedForest` | — |

**Bug supplémentaire trouvé** : `metano_town` utilisait `GreenKecleonStockedRefreshed`
alors que la variable déclarée et réinitialisée chaque jour est
`GreenKecleonRefreshedStock` (idem Purple). **Le stock des marchands Kecleon ne se
renouvelait donc jamais.** Aligné sur le nom déclaré.

`SV.Settings.Nicknames` / `.Starters` : **faux positif**, `CONFIG.Initialize()` les
crée à la volée. Aucune correction nécessaire.

---

## 3. Les 5 salles de boss

| Salle | Méthode | Taille | Marchable |
|---|---|---|---|
| `vast_steppe_miniboss` | Composition biome parent | 46×66 (8 px) | 74 % |
| `vast_steppe_guardian` | Composition, mur d'arbres renforcé | 46×66 (8 px) | 75 % |
| `searing_tunnel_miniboss` | Composition + murailles rocheuses prélevées | 52×68 (8 px) | 49 % |
| `mount_windswept_miniboss` | Composition biome parent | 48×66 (8 px) | 68 % |
| `mount_windswept_guardian` | **Importée de DumpAsset** (`end_treacherous_mountain`) | 22×26 (24 px) | 23 % |

### Méthode de composition (biome parent)

Chaîne : `catalog.py` → `stage.py` → `rooms_*.py`.

1. **Catalogue de props** : composantes connexes sur l'union des calques décor, séparées
   par seuil de cœur opaque (0.9), boîte élargie de 1 tuile.
   - Props touchant le bord de la carte source **exclus** (déjà coupés là-bas).
   - `BLOCKLIST` dans `catalog.py` : mobilier de gameplay à ne jamais réutiliser
     comme décor (rocher Kangourex).
2. **Sol** : pavage à partir d'une zone de sol « propre » (aucun décor au-dessus),
   détectée par `patches.clean_mask`.
3. **Mise en scène** : `Stage.border()` pour les lisières (plusieurs passes à
   profondeurs croissantes = lisière épaisse), `Stage.scatter()` hors aire de combat,
   `Stage.reserve()` pour protéger le couloir et le cœur d'arène.
4. **Obstacles** dérivés de l'opacité réelle des tuiles.

### Import DumpAsset (`mount_windswept_guardian`)

- Source : `end_treacherous_mountain.rsground` + tileset `MountainPeak.tile` (24 px).
- ⚠️ **La carte DumpAsset arrive sans aucune collision** (tous `Tags = 0`) : le joueur
  traverserait les parois. Collisions **régénérées depuis le rendu** (`fix_collision.py`,
  seuil de luminance 65 : sol ≈ 86, roche ≈ 23), puis contrôle de connexité
  départ → boss et comblement des poches inaccessibles.
- `guildmaster_summit` **volontairement écarté** : son nom est lié au maître de guilde
  (`SV.guildmaster_summit` avec `ExpositionComplete`/`BattleComplete`), l'utiliser comme
  arène créerait une incohérence narrative.

### Étages de combat générés

`make_rsmap.py` produit les 5 `.rsmap` sur le modèle de `gloomy_forest_boss` :
rectangle de sol bordé de murs `unbreakable`, autotiles cohérents avec la zone
(`lush_prairie`, `craggy_peak`, `mt_blaze`), 2 points d'entrée.

| Salle | Ennemis |
|---|---|
| `vast_steppe_miniboss` | Mudbray L16, Stantler L16 |
| `vast_steppe_guardian` | Stantler L20 (HP+190) |
| `searing_tunnel_miniboss` | Torkoal L17, Magmar L17 |
| `mount_windswept_miniboss` | Gligar L18, Skarmory L18 |
| `mount_windswept_guardian` | Aerodactyl L22 (HP+210) |

Niveaux calés sur `searing_crucible` (Magcargo L18 / Slugma L13).

---

## 4. Correction d'une erreur de l'audit initial

**Le bug B6 (« 10 cartes manquantes ») était un faux positif.** Vérifié avec
`check_b6.py` : l'unique référence (`base_camp_2` dans `luminous_spring/init.lua:153`)
est **à l'intérieur d'un bloc commenté** `--[[ Base Game functionality, commented out ]]`.
Aucune des 10 cartes n'est atteignable en jeu, aucun `EnterZone` ne vise leurs index.
Ce sont des vestiges du projet Halcyon d'origine. **Aucune action requise.**

Les cartes existent bien dans DumpAsset si le besoin se présentait un jour.

---

## 5. Bugs connus non corrigés

### ~~7 musiques manquantes~~ → CORRIGÉ (25/07/2026)

Toutes les références musicales du projet pointent désormais vers un fichier existant.
**Vérifié : 33 références distinctes, 40 fichiers `.ogg`, 0 manquante.**

Deux causes distinctes, deux traitements :

**a) Fautes de casse (21 corrections)** — le fichier existait déjà, seul le nom
écrit dans le code était faux :

| Écrit dans le code | Fichier réel | Occurrences |
|---|---|---|
| `In The Depths of the Pit.ogg` | `In the Depths of the Pit.ogg` | 20 |
| `At The End of the Day.ogg` | `At the End of the Day.ogg` | 1 |

Indice qui confirmait la faute : `crooked_den_ch_3.lua:663` utilisait déjà la bonne
casse. Corrigé dans les scripts Lua **et** dans le champ `Music` des cartes.

**b) Fichiers réellement absents (5)** — récupérés depuis DumpAsset, qui est le dump
officiel des assets du jeu de base :

| Fichier | Traitement |
|---|---|
| `Spring Cave.ogg` | copié depuis DumpAsset (7 usages, chapitre 5) |
| `Lower Spring Cave.ogg` | copié (3 usages, `searing_tunnel_midpoint`) |
| `Outlaw.ogg` | copié (`event_single.lua`) |
| `Deep Dark Crater.ogg` | copié (`testmap`) |
| `C05. Rescue.ogg` | **nom hérité de Halcyon** : l'asset officiel s'appelle `Rescue.ogg`. Fichier copié + 2 références corrigées dans `common.lua` |

### ~~Traduction (étape 3)~~ → TERMINÉE (25/07/2026)

**Le projet est intégralement traduit pour tout ce qui est visible en jeu.**

| Chantier | Résultat |
|---|---|
| Titres de chapitre | **7 traduits** (ch.1 apparaît 2×) — *Un Autre Commencement*, *La Première Mission*, *Rivaux*, *Une Vraie Aventure*, *L'Expédition*, *La Forêt Lugubre* |
| `stringsEx.fr.resx` | **1827 clés** = parité totale avec l'EN. `TALK_FULL_3006/3007` ajoutées (dialogues d'Audino) ; `MSG_DESTINY_BOND` et `MSG_STAT_BOOST_MIN` sont **vides côté EN aussi** → rien à traduire |
| Dialogues en dur | **5 traduits** (voir ci-dessous) |
| Données JSON | **13 champs complétés** : catégorie Pokédex de Charbambin, tuiles à effet (lave, ombre de chute, pierres de rivière), terrain, 8 autotiles |

#### Correction méthodologique importante

L'audit initial annonçait **49 dialogues anglais** et **45 clés `.resx` manquantes**.
Ces deux chiffres étaient **faux** : le script ne retirait pas les commentaires Lua et
ne vérifiait pas si une clé était réellement lue.

Après analyse correcte (`audit_dialogues.py`, qui supprime `--` et `--[[ ]]`) :

- **49 → 5 dialogues réellement visibles.** Les 44 autres sont du code commenté,
  dont les 3 blocs qu'on prévoyait de supprimer (note de dev
  `searing_tunnel_entrance_ch_5.lua:1127`, messages de fin de démo Halcyon dans
  `guild_heros_room_ch_1.lua` et `guild_guildmasters_room_ch_2.lua`) : **déjà
  neutralisés par leurs auteurs, aucune action nécessaire.**
- **45 → 0 clé `.resx` à traduire.** Les 30 « manquantes » de `metano_town`,
  `guild_third_floor_lobby` et `ledian_dojo` sont des **coquilles vides ou des
  placeholders** (`''`, `'info 1'`, `'test'`) qu'**aucun script de leur carte ne lit**.
  Le vrai contenu vit ailleurs et est déjà traduit : le café Spinda dans
  `metano_cafe` (48/48 clés FR), l'assemblée d'Audino dans `guild_second_floor` (10/10).
  Les 12 restantes appartiennent à `test_grounds` (carte de test).

#### Les 5 dialogues traduits

| Fichier | Texte |
|---|---|
| `guild_third_floor_lobby/init.lua:207` | `AND ALL FOR ONE!` → *ET TOUS POUR UN !* |
| `PartnerEssentials.lua:853` | phrase sur Relicanth (2 fragments concaténés) |
| `beginner_lesson_evt.lua:108` | tutoriel des objets tenus |
| `apricorn_grove_entrance/init.lua:207` | `C'mon. Let's head home!` → *Allez. Rentrons !* |
| `metano_town/init.lua:3022` | vœu du puits (2 fragments) |

Reste **1 chaîne anglaise**, volontairement conservée :
`guild_third_floor_lobby.Test_Action` → `"All guildmates now considered met."`.
C'est un **outil de debug** ; l'entité `Test` n'existe pas sur la carte, le callback
est donc inatteignable en jeu.

#### Non traduit à dessein

- `Data/AI/*.json` (3 tactiques) : `Assignable: false`, jamais affichées au joueur.
- Clés `.resx` de `test_grounds` : carte de test.

### Autres

- `DefeatedBoss()` / `DiedToBoss()` sont écrites dans les 5 fichiers `_ch_5` mais
  **jamais appelées** : le retour après combat n'est pas branché. À faire quand la
  logique de sortie de segment boss sera arrêtée.
- 14 callbacks d'entités déclarés pour des entités absentes des cartes (code mort).

---

## 6. Validation automatisée

Scripts dans `/home/user` (hors dépôt) :

| Script | Rôle |
|---|---|
| `validate_ch5.py` | Chaîne complète ch.5 : cartes, tilesets, index, segments, espèces, syntaxe, `require` |
| `validate_all.py` | Les 5 salles : cohérence grille/obstacles, tilesets, entités, connexité départ→boss |
| `verify_arena.py <carte> [blocked]` | Rendu PNG avec positions de cinématique et masque de collision |
| `check_b6.py` | Références live vs code mort |
| `audit_i18n.py` / `audit_bugs.py` / `audit_entities.py` | Audits d'origine |

**État actuel : tout au vert.** 195/195 fichiers Lua compilent, 5/5 salles valides,
segments cohérents avec les appels du code.

⚠️ **Aucun test en jeu réel n'a pu être effectué** (ni .NET ni RogueEssence dans
l'environnement). Toutes les validations sont statiques. Le test manette en main
reste indispensable, en particulier :
1. traverser la Grande Steppe → mini-boss → gardien → Tunnel → Mont Venteux ;
2. perdre volontairement dans la Forêt Lugubre et vérifier dîner → nuit → lendemain ;
3. perdre contre Zarude et vérifier qu'on n'est plus bloqué.

---

## 7. Reste à faire

1. **Tester le chapitre 5 en jeu** — seul point réellement bloquant. Toutes les
   validations sont statiques ; rien n'a tourné dans le moteur.
2. Brancher `DefeatedBoss()` / `DiedToBoss()` (écrites dans les 5 fichiers `_ch_5`,
   jamais appelées) une fois le comportement de sortie de segment arrêté en jeu.
3. Envisager le système de checkpoint mi-donjon pour les 4 donjons à boss.
4. Ménage optionnel : supprimer les ~30 clés `.resx` mortes et les 14 callbacks
   d'entités inexistantes (aucun impact fonctionnel, confort de maintenance).

Les étapes 1, 2 et 3 du plan initial sont terminées.
