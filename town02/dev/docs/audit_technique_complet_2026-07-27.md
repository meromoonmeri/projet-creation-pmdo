# AUDIT TECHNIQUE COMPLET — New Era : Abyss to Ascension (2026-07-27)

Audit exhaustif préparatoire à une version publique stable. Méthode : scans
programmatiques systématiques (aucun échantillonnage), croisement contre les
sources du moteur (RogueCollab/RogueEssence, PMDCollab/PMDC) et l'inventaire
complet du jeu de base (audinowho/DumpAsset : 1011 monstres, 883 skills,
2452 items, 473 autotiles, 949 charas, 1027 portraits, 759 SE, 73 musiques,
18 grounds, 59 tiles).

## 1. PÉRIMÈTRE SCANNÉ

| Domaine | Volume | Méthode |
|---|---|---|
| Scripts Lua | **527 fichiers** | loadfile (lupa) + analyse statique regex |
| Zones (donjons) | **129** | segments / MapID / GroundMaps / spawns / index |
| Grounds | **244 .rsground** | entités, callbacks, colliders, musiques |
| Maps de combat | **~370 .rsmap** | autotiles, sheets, musiques, MapID |
| Tilesets | 483 .tile + index | croisement Sheet |
| resx (dialogues) | tous les packages ground | XML + clés + langue |
| Musiques / SE | 133 OST + SE | croisement PlayBGM/PlaySE/Music |
| Données | Item/Status/MapStatus/Tile/Monster/AutoTile | JSON + refs croisées |

## 2. ERREURS ACTUELLES DU LOG — CAUSES RACINES

### « Invalid Segment ID: -1 62 » (black screen au lancement) — CORRIGÉ (commit 23e57a6)
`TopMenu.continueMain` → `MoveToZone(Save.NextDest)` valide la destination
contre le **résumé** `ZoneEntrySummary` de `Data/Zone/index.idx`
(`SegLocValid` : ground valide si `0 ≤ ID < Grounds.Count` du résumé), pas
contre le JSON complet. L'index désynchronisé (résumés plus courts que les
JSON) faisait échouer le rechargement d'une sauvegarde au relais de la
Grande Steppe (ground 62 de master_zone). Fix : resync 5 zones + ajout de
8 zones absentes ; **129/129 synchrones** (re-vérifié à ce tour, avec en
plus `montagne_traitresse` corrigée, cf. §3.3).
⚠️ Rappel d'installation : la copie du mod dans le dossier MODS du jeu doit
inclure le `Data/Zone/index.idx` à jour, sinon le crash revient.

### « attempt to call a nil value »
Scan complet des 527 scripts : **0 erreur de syntaxe**, 0 require introuvable
(1393 requires résolus), 0 appel `module_ch_N.Fonction()` vers une fonction
inexistante, 0 callback de zone manquant (Init/EnterSegment/ExitSegment,
hors zones héritées à comportement par défaut). Les candidats plausibles
identifiés et corrigés : `STRINGS:Format(STRINGS.MapStrings['X'])` avec clé
absente (→ `Format(nil)` = call nil) — voir §3.4/3.5/3.6.

### « Map Count: 0 »
Vérifié dans `Zone.cs` du moteur : `DiagManager.LogInfo("Map Count: " +
curRevisit)` — c'est le **compteur de revisites** de l'étage (0 = première
visite). **Message informatif normal, pas une erreur.**

## 3. ERREURS RÉELLES TROUVÉES ET CORRIGÉES (ce tour)

### 3.1 Autotiles inexistants — `champ_braises_arene.rsmap` (arène Sulfura ch14)
Référençait `fiery_field_floor/wall` : inexistants dans le mod **et** dans le
jeu de base (Fiery Field pmd-red n'a jamais été converti en autotile PMDO).
Sol et murs invisibles garantis. → Remplacés par `mt_blaze_floor/wall`
(base game, DA volcan la plus proche) : 104 + 167 tuiles. Scan global des
160 autres autotiles hérités : tous existent dans la base → **plus aucun
autotile cassé**.

### 3.2 MapID de boss cassé — `chapelle_nuit.json` (donjon Lunala ch31)
Le `RoomGenLoadBoss` du segment 1 pointait sur `"murky_cave_wall"` (un nom
d'autotile collé par erreur à la place d'une map !). Étage boss ingénérable
→ crash assuré à la génération. → Remplacé par `boss_pink_wall` (même pool
que sa zone jumelle `cour_clair_lune`). Scan global : **0 autre MapID cassé**
sur les 129 zones.

### 3.3 `montagne_traitresse.json` : GroundMaps contenait un `.rsmap`
`montagne_traitresse_fond` est une map de combat, pas un ground. Ground (-1,0)
invalide si jamais ciblé + index faux. → `GroundMaps` vidé + index resync.

### 3.4 Clé resx corrompue — `Tutor_Info_004&#13;&#10;`
Dans `metano_town/strings.resx` et `.fr.resx`, la clé contenait un CRLF
encodé. Le script demandait `Tutor_Info_004` → nil → **crash au dialogue du
Tuteur de capacités dès le chapitre 6**. → Clé nettoyée dans les 2 fichiers.

### 3.5 244 dialogues INVERSÉS EN/FR dans 12 packages ground
`strings.resx` (attendu : anglais) contenait le français et `strings.fr.resx`
l'anglais pour 244 clés — un joueur en français voyait ces 244 répliques **en
anglais** (cloven_ruins_boss 25, genesis_vision 15, guild_heros_room 16,
guild_third_floor_lobby 11, metano_town 130, arènes/relais steppe-mont-tunnel
47). → Valeurs échangées clé par clé (heuristique lexicale stricte, XML
revalidé, 0 inversion restante).

### 3.6 Clé inter-package manquante — `MT7_Noctowl_006`
`guild_third_floor_lobby_ch_7.lua` utilisait une clé stockée dans le package
`metano_town` : or `MapStrings` est chargé **par package** → nil → crash au
dialogue de Phileas (mission ch7). → Clé copiée (EN+FR) dans le package.

### 3.7 4 effets sonores inexistants (mod + base vérifiés)
`DUN_Ally_Join`→`DUN_Follow_Me`, `DUN_Health_Low_Fix`→`DUN_Heal`,
`DUN_Learn_Move`→`DUN_TM`, `DUN_Tall_Grass`→`DUN_Grass_Knot` (8 occurrences,
3 fichiers). Le moteur loggue une erreur par tentative sinon.

### 3.8 Callback manquant — `crooked_cavern_midpoint.South_Exit_Touch`
L'objet `South_Exit` (TriggerType Touch) existait sur la map **sans**
callback : la sortie sud du relais ch3 était muette. → Handler ajouté
(retour à `crooked_cavern_entrance`, patron identique aux autres relais).
`testmap.Chapter1_1` : map de test non branchée, ignorée volontairement.

## 4. LISTE DES AVERTISSEMENTS (non bloquants, documentés)

1. **`shady_shop`** : ground + zone présents (Mega_Stones), **aucun script
   halcyon** — inoffensif tant que non câblé (verrou StoryCompleted prévu).
2. **Zones `imbion_*` (7)** : héritées, sans script de zone → comportement
   par défaut du moteur. Jouables mais sans scénario.
3. **`arene_cauchemar`, `arene_emissaire_ombre`** : grounds réservés sans
   entités ni `Main_Entrance_Marker` — à compléter au câblage (Accusation).
4. **`math.random` hérités Halcyon** (common.lua ChooseQuote, boutiques
   seedées par GetDailySeed) : texte d'ambiance/ville uniquement ; risque
   replay théorique faible, non corrigé pour ne pas dévier du code hérité.
5. **Zones gauntlet très longues** héritées (eaux_inexplorees 105 étages…) :
   choix de design en attente de validation (troncage proposé).
6. **`QUICKSAVE (1).rsqs`** à la racine : artefact de test ; les quicksaves
   pris sous une ancienne version du mod sont irrejouables par nature.
7. **`Map Count: 0`** dans les logs : informatif (compteur de revisites).

## 5. RESSOURCES ORPHELINES (inventaire, AUCUNE suppression)

- **110 grounds jamais référencés** par une zone ou un `EnterGroundMap` :
  majoritairement du stock importé en réserve pour les chapitres 11-32
  (arènes/Friend Areas vagues 4/6 : lac_mystique, cratere_fumant,
  crete_tenebres, iles legendaire/australe/close/finale, dojo_ossatueur,
  cafe_toupie, bourg_comptoir, visions tempete_vision_a/b/c…). C'est un
  **stock intentionnel** documenté dans les registres de vagues ; rien n'est
  supprimé (les chapitres à venir les consomment).
- Scripts jamais exécutés : les `*_ch_N.lua` de chapitres non écrits (>10)
  n'existent pas encore — pas de code mort détecté côté scripts ; les
  fonctions de modules partagés appelées sont **toutes définies** (12 fausses
  alertes = fonctions du runtime `origin` du jeu de base, vérifiées).

## 6. CARTOGRAPHIE DES DÉPENDANCES (synthèse)

```
master_zone (hub, 79 grounds : ville, guilde, entrances, relais, arènes matérielles)
 ├─ ch1-10 : crooked_cavern → vast_steppe → searing_tunnel → mount_windswept
 │    → gloomy_forest → cloven_ruins → crystal_sanctuary → forgotten_marsh
 │    → celestial_peak   [entrance → seg0 → relais → seg1/2 → miniboss/boss ground]
 ├─ ch11-32 : 49 donjons-Ancrages (LegendZones.lua : contrat = zone+segment+cine+flags)
 │    boss arena .rsmap (RoomGenLoadBoss) → ExitSegment → SetDefeated → SV.Anchors
 ├─ Réseau des Anciens Chemins : 34 new_era_zone_XX (+6 Stations-Relais grounds,
 │    12 Veilleurs dans ExitSegment, job board via mission_gen)
 └─ Annexe de la Toupie : FLOOR_GEN_SCRIPT.NewEraMystery → tile_mystery
      → segment caché (annexe_toupie.rsmap) → 5 BATTLE_SCRIPT (event_battle.lua)
Scripts partagés : common.lua / GeneralFunctions / CharacterEssentials (108+ persos)
 / PartnerEssentials (spawn+follow) / BossFX / RelayScenes / LegendZones
Validation moteur au chargement : Data/Zone/index.idx (résumés) — TOUJOURS
 resynchroniser après modification d'une zone.
```

Dépendances par données (vérifiées 0 cassée) : Zone→MapID→Data/Map ;
Map→AutoTileset→Data/AutoTile∪base ; Map/Ground→Sheet→Content/Tile ;
Zone→Species/SkillNum/Item→base∪mod ; Ground→Music→Content/Music∪base ;
scripts→EnterGroundMap/EnterDungeon→grounds/zones existants ;
scripts→MapStrings→strings.resx du même package.

## 7. COMPTEURS FINAUX

| Vérification | Résultat |
|---|---|
| Syntaxe Lua (527 fichiers) | **0 erreur** |
| requires (1393) | **0 introuvable** |
| Callbacks ground Action/Touch | **0 manquant** (après fix §3.8) |
| Callbacks zone Init/Enter/ExitSegment | **0 manquant** |
| MapID (RoomGenLoad*) | **0 cassé** (après fix §3.2) |
| Autotiles | **0 cassé** (après fix §3.1) |
| Tilesets (Sheets) | **0 cassé** |
| Musiques (Data + scripts) | **0 cassée** (Boss Battle/Threat = base game) |
| SE | **0 cassé** (après remap §3.7) |
| Espèces / skills / items | **0 référence cassée** |
| Espèces boss/PNJ (sprites/portraits) | **0 inconnue** (base ∪ mod) |
| resx XML | **0 invalide** ; **0 clé corrompue** ; **0 inversion EN/FR** |
| MapStrings→clés | **0 manquante réelle** (post_office utilise le fallback origin du moteur, vérifié dans Text.LoadScriptStringDict) |
| index.idx | **129/129 zones synchrones** |
| JSON (toutes données) | **0 invalide** ; 0 `$values` orphelin ; 0 `rand.s` nul |
| SV utilisées jamais assignées | 2 (magnagate : commentaire ; unlocked_trades : code commenté) — non-bloquant |

**Zones à risque ce tour : 8 identifiées, 8 corrigées, 0 restante**
(cumul projet : 37 identifiées, 36 corrigées, 1 restante = quicksaves périmés
côté joueur).

## 8. FICHIERS MODIFIÉS (ce tour)

- `Data/Map/champ_braises_arene.rsmap` — autotiles mt_blaze_* (§3.1)
- `Data/Zone/chapelle_nuit.json` — MapID boss → boss_pink_wall (§3.2)
- `Data/Zone/montagne_traitresse.json` + `Data/Zone/index.idx` — §3.3
- `Data/Script/halcyon/ground/metano_town/strings.resx` + `.fr.resx` — §3.4 + §3.5
- 11 autres paires resx (12 packages au total) — §3.5
- `Data/Script/halcyon/ground/guild_third_floor_lobby/strings.resx` + `.fr.resx` — §3.6
- `Data/Script/halcyon/event_battle.lua`, `ground/metano_town/init.lua`,
  `ground/gloomy_forest_boss/gloomy_forest_boss_ch_6.lua` — SE remappés (§3.7)
- `Data/Script/halcyon/ground/crooked_cavern_midpoint/init.lua` — South_Exit (§3.8)

## 9. GARANTIES D'INTÉGRITÉ

- Aucune géométrie, collision, position de spawn ni décor de map modifiés à
  ce tour (uniquement autotiles inexistants → existants sur 1 arène, données
  JSON de zone, resx, scripts).
- Tous les fichiers touchés revalidés : JSON parse, XML parse, loadfile Lua.
- La vérification finale globale (§7) tourne en une passe et ressort
  **« TOUT PROPRE »** — elle peut être rejouée à tout moment.

## 10. LIMITE

Le test in-game reste impossible dans cet environnement (pas de moteur) :
toutes les garanties ci-dessus sont statiques mais couvrent l'intégralité des
classes d'erreurs observées dans les logs fournis (nil value, références
cassées, index désynchronisé, tuiles inexistantes).
