# AUDIT EXHAUSTIF — Corrélation & Unicité des Grounds (.rsground)

**Date** : 2026-08-06 — **Branche** : `arena/019fd882-new-era-abyss-to-ascension-v4` (commit `8ee0c0c`) — **Mod** : New Era — Abyss to Ascension V4

**Périmètre** : les 273 fichiers `Data/Ground/*.rsground`, leurs registres (`Data/Zone/index.idx`, `Data/Zone/*.json`), leurs références Lua (`GAME:EnterGroundMap` / `EnterZone` / `EndDungeonRun`), leurs scripts (`Data/Script/halcyon/ground/*`), leurs assets musique (`Content/Music`), et la sauvegarde (`save_fixed.rssv`).

**Références moteur vérifiées** (RogueEssence master) :
- `Scene/GameManager.cs:701-753` (`MoveToGround`) — validation du nom via l'index compilé, puis résolution via la liste `GroundMaps` de la zone active.
- `Data/ZoneData.cs:281-297` (`SegLocValid` / `GroundValid`) — contrôle des noms contre `index.idx`.
- `Dungeon/Zone.cs:145-170, 317-320` (`SetCurrentMap` / `GetGround`) — résolution d'un index `SegLoc(-1, N)` contre `GroundMaps` du JSON de zone.
- `Ground/Maps/GroundMap.cs:947-954` (`GetEntryPointIdx`) — marqueur d'entrée introuvable → `KeyNotFoundException` (crash).

---

## 0. Synthèse exécutive

| Indicateur | Valeur |
|---|---|
| Fichiers `.rsground` | **273** (tous lisibles, aucun fichier corrompu) |
| Grounds déclarés dans `index.idx` (209 zones) | 189 noms uniques |
| Zones avec JSON (`Data/Zone/*.json`) | 243 |
| Appels `EnterGroundMap` dans le Lua | 276 (158 cartes cibles distinctes) |
| Cartes cibles **entièrement saines** (fichier + registre + marqueur) | **152 / 158** |
| Anomalies bloquantes (outil automatisé) | 57 occurrences = **~10 problèmes racines** |
| Avertissements | 39 occurrences = ~6 problèmes racines |

**Verdict** : l'architecture de référencement des Grounds est globalement saine — aucun fichier dupliqué à l'identique, aucun AssetName incohérent, tous les marqueurs d'entrée cités existent, 152 des 158 cartes visées par Lua sont intégralement câblées. **En revanche, le câblage des donjons d'histoire ch. 8/9 (waterfall_pond, poisonous_forest) est cassé** (fichiers fantômes, listes de zone divergentes, index glissés) : toute sortie de ces donjons vers un Ground provoque une exception moteur. La zone `master_zone` contient 12 entrées fantômes et 4 doublons qui décalent tous les index codés en dur à partir de la position 69.

---

## 1. Modèle de résolution (rappel — fondement de l'audit)

Un transfert vers un Ground passe par **deux registres différents** et un **marqueur** :

```
GAME:EnterGroundMap("map", "Marker")
  1. index.idx[zone].Grounds        → doit contenir "map"      (sinon ArgumentException "Invalid Ground Map Name")
  2. Data/Zone/<zone>.json.GroundMaps → doit contenir "map"    (sinon Exception "Cannot find ground map ... in zone")
  3. "Marker" doit être un marker de la carte cible            (sinon KeyNotFoundException)

GAME:EnterZone("zone", -1, N)
  1. N < len(index.idx[zone].Grounds)                          (sinon "Invalid Segment ID")
  2. N < len(<zone>.json.GroundMaps)                           (sinon IndexOutOfRange)
  3. la carte GroundMaps[N] doit exister sur disque            (sinon crash au chargement)
```

Conséquence directe : **un Ground peut être présent dans l'index mais absent du JSON (ou inversement) → crash au transfert**, même si le fichier existe. C'est la classe de défaut la plus répandue dans ce dépôt.

---

## 2. UNICITÉ

### 2.1 Noms internes (`Name.DefaultText`) — 2 doublons accidentels + 1 famille volontaire

| Nom interne | Cartes | Verdict |
|---|---|---|
| `Duskwood Edge` | `bois_sombres_oree`, `gloomy_forest_entrance` | ⚠️ doublon accidentel — deux cartes distinctes affichent le même nom |
| `Poison Swamp` | `marais_poison`, `poisonous_forest_boss` | ⚠️ doublon accidentel |
| `Relay Station` | 31 cartes `new_era_sky_*_relais` / `new_era_zone_*_relais` | ✅ famille générique volontaire (template procédural) |

### 2.2 Contenu — aucun doublon intégral

- **md5 : 0 paire de fichiers identiques.** ✅
- **Quasi-doublons** : les 31 relais partagent **la même grille d'obstacles** (md5 `46eebe7b2b` pour tous) et, par groupes, **les mêmes tuiles** (16 groupes distincts ; ex. `new_era_sky_24/43/54` et `new_era_zone_05/09/11/13/15/17` partagent exactement tuiles + obstacles). C'est **volontaire** (relais interchangeables générés par `tools/convert_relays_official.py`), mais tout futur changement d'un relais devrait être propagé aux 30 autres — risque de dérive silencieuse.

### 2.3 Enregistrements en double — `master_zone` (index.idx)

```
palier_celeste     ×2  (positions 73, 74)
parvis_celeste     ×2  (positions 70, ~165)
sanctuaire_voeu    ×2  (positions ~138, ~181)
tour_ciel_sommet   ×2  (positions ~164, ~183)
```
Impact : les doublons **gonflent la liste** et décalent tous les index codés en dur qui suivent ; `FindIndex` (résolution par nom) retourne le premier, l'index dupliqué reste injoignable par `EnterZone`. À supprimer.

### 2.4 AssetName — 0 anomalie ✅
Les 273 cartes ont `AssetName == nom de fichier` (exigence moteur, `GetGround(name) → mapData.AssetName = name`).

### 2.5 EntName dupliqués au sein d'une carte — 2 cas bénins

| Carte | Détail | Verdict |
|---|---|---|
| `metano_town`, `metano_town_nuit` | 10 zones de trigger (`Cafe_Locale`, `Guild_Locale`…) composées chacune de **4 colliders** portant le même `EntName` dans la même couche | ✅ volontaire (trigger multi-rectangles) |
| `plaine_entrance` | `Main_Entrance_Marker` en double | ⚠️ le 2e marker est injoignable (`GetEntryPointIdx` renvoie le 1er) — carte dormante, mineur |

---

## 3. CORRÉLATION

### 3.1 Déclarés dans `index.idx` mais SANS fichier — **17 cartes**

| Carte fantôme | Déclarée dans | Fichier | Référencée par Lua ? |
|---|---|---|---|
| `base_camp`, `base_camp_2`, `forest_camp`, `cliff_camp`, `canyon_camp`, `rest_stop`, `final_stop`, `guildmaster_summit`, `guild_path`, `guild_hut` | `master_zone`, `normal_maze` | ✗ | non (résidus EoS jamais importés) |
| `test_grounds` | `master_zone`, `normal_maze` | ✗ | non |
| `dev_room` | `conte_sans_fin` | ✗ | non |
| `end_moonlit_temple` | `cour_clair_lune`, `chapelle_nuit` | ✗ | non |
| `sky_tower_fulgur`, `sky_tower_relay` | `sky_tower` | ✗ | **oui — zone `sky_tower` (5 appels)** |
| `waterfall_pond_relay`, `waterfall_pond_miniboss` | `master_zone`, `waterfall_pond` | ✗ | **oui — zone `waterfall_pond` (4 appels) + `EnterZone(-1, 71)`** |

⚠️ Les 5 dernières sont **actives** : `waterfall_pond` est un donjon d'histoire (débloqué, ch. 8) ; `sky_tower` est du contenu de ch. 10 préparé mais non débloqué (latent, dangereux s'il est câblé un jour sans correction).

### 3.2 Divergences `index.idx` ↔ `<zone>.json` (GroundMaps) — **15 zones**

| Zone | Dans index seul | Dans JSON seul | Gravité |
|---|---|---|---|
| `master_zone` | `poisonous_forest_*` (4), `waterfall_pond_*` (2) | `crystal_sanctuary_*` (4), `forgotten_marsh_*` (4), `celestial_peak_*` (4) — **12 entrées fantômes, aucun fichier** | 🔴 bloquant |
| `poisonous_forest` | `poisonous_forest_*` (4, fichiers réels) | `forgotten_marsh_*` (4, fantômes) | 🔴 bloquant |
| `waterfall_pond` | `waterfall_pond_relay`, `waterfall_pond_miniboss` (sans fichier) | `crystal_sanctuary_*` (3, fantômes) + `sanctuaire_voeu` ✅ | 🔴 bloquant |
| `sky_tower` | `sky_tower_fulgur`, `sky_tower_relay`, `tour_ciel_sommet` | `mont_grondant_pied`, `new_era_zone_05_relais` | 🔴 bloquant (si débloqué) |
| `purity_forest` | `bois_antan_verger` | `mont_grondant_pied`, `new_era_zone_05_relais` | 🟠 |
| `fiery_field`, `frosty_forest`, `lightning_field`, `meteor_cave`, `mt_blaze`, `mt_faraway`, `mt_freeze`, `mt_thunder`, `northwind_field`, `silver_trench`, `western_cave`, `wish_cave` | la carte légitime (ex. `champ_braises`) | **`mont_grondant_pied` + `new_era_zone_05_relais` dans toutes** | 🟠 signature d'un générateur qui a écrasé les JSON (copier-coller) |

🔴 **Détail `master_zone`** : les 12 entrées fantômes (`crystal_sanctuary_*`, `forgotten_marsh_*`, `celestial_peak_*`) sont les noms d'une conception antérieure (renommée en `waterfall_pond_*` / `poisonous_forest_*`). Elles n'ont jamais existé sur disque et **décalent de 12 positions tous les index ≥ 69** résolus par `EnterZone` (cf. 3.3).

### 3.3 Références Lua → cartes — 35 anomalies = 8 problèmes racines

**A. Chaîne de sortie des donjons d'histoire — 🔴 crashs réels (contenu débloqué)**

| Zone | Appel | Défaut |
|---|---|---|
| `waterfall_pond` (ch. 8, débloqué) | `EnterGroundMap('waterfall_pond_relay'/'waterfall_pond_miniboss')` ×4 | fichier absent → crash à la sortie des segments 0/1/2/3 |
| `waterfall_pond` | `EnterZone('master_zone', -1, 71)` ×3 (mort à Diancie, échec segments 2/4) | `master_zone.json.GroundMaps[71] = celestial_peak_entrance` — **fantôme** → crash |
| `poisonous_forest` (ch. 9, `SV.Chapter9.ForgottenMarshComplete`) | `EnterGroundMap('poisonous_forest_relay'/'miniboss'/'boss')` ×7 | présents dans `index.idx` mais **absents de `poisonous_forest.json`** (qui liste `forgotten_marsh_*`) → exception `Cannot find ground map` |
| `poisonous_forest_miniboss/…/forgotten_marsh_miniboss_ch_9.lua` | `EnterGroundMap('poisonous_forest_relay')` | idem |

**B. Chaîne d'entrée depuis Metano Town — 🔴 menu destination cassé**

Le menu `metano_town.ShowDestinationMenu` (`metano_town/init.lua:502-513, 612`) envoie le joueur sur `master_zone.json.GroundMaps[dungeon_entrance_mapping[d]]` quand le donjon sélectionné est le donjon d'histoire courant :

| Donjon | Index codé | Résolution réelle | Attendu (commentaire du code) | Verdict |
|---|---|---|---|---|
| `illuminant_riverbed` | 38 | `illuminant_riverbed_entrance` ✅ | idem | ✅ |
| `crooked_cavern` | 41 | `crooked_cavern_entrance` ✅ | idem | ✅ |
| `apricorn_grove` | 44 | `apricorn_grove_entrance` ✅ | idem | ✅ |
| `vast_steppe` | 46 | `vast_steppe_entrance` ✅ | idem | ✅ |
| `searing_tunnel` | 47 | `searing_tunnel_entrance` ✅ | idem | ✅ |
| `mount_windswept` | 50 | `mount_windswept_entrance` ✅ | idem | ✅ |
| `gloomy_forest` | 51 | **`hero_dream`** ❌ | `gloomy_forest_entrance` (54) | 🟠 index glissé |
| `cloven_ruins` | 64 | **`vast_steppe_midpoint`** ❌ | `cloven_ruins_entrance` (66) | 🟠 index glissé |
| `waterfall_pond` | 68 | **`cloven_ruins_midpoint`** ❌ | « Crystal Sanctuary Entrance » (69 = fantôme) | 🔴 |
| `poisonous_forest` | 69 | **`crystal_sanctuary_entrance`** ❌ (fantôme) | « Forgotten Marsh Entrance » (70 = fantôme) | 🔴 |
| `celestial_peak` | 70 | **`forgotten_marsh_entrance`** ❌ (fantôme) | « Celestial Peak Entrance » (71 = fantôme) | 🔴 |

→ Quand `CurrentStoryDungeon == gloomy_forest / cloven_ruins / waterfall_pond / poisonous_forest / celestial_peak`, le joueur atterrit sur la mauvaise carte (hero_dream = carte de rêve !) ou sur un fichier inexistant (crash). Le `celestial_peak` est de plus **absent de `Data/Zone/`** : la zone n'existe pas alors qu'elle est dans la liste des donjons de Metano Town (`init.lua:325`) et dans `mission_gen.lua:75`.

**C. Zones legacy (EoS) non débloquées — 🟠 latentes mais prêtes à crasher**

`fiery_field → plaines_brulees`, `mt_blaze → champ_braises`, `lightning_field → arene_hautes_plaines`, `mt_faraway → sommet_aurore`, `mt_thunder → porte_plaines_foudre`, `frosty_forest → champ_vent_boreal`, `meteor_cave → vallon_perdu`, `northwind_field → bois_des_plaintes`, `silver_trench → fosse_argentee`, `western_cave → antre_occident`, `wish_cave → sanctuaire_voeu` : les cibles sont absentes de l'index **ou** du JSON de la zone (les deux listes ne contiennent plus les bonnes cartes). Ces zones ne sont pas débloquées aujourd'hui (`UnlockDungeon` absent), mais **toute quête secondaire future ou tout déblocage les transformera en crash** au premier changement de segment.

**D. Cibles sans fichier ni registre (zone non débloquée)** : `purity_forest → purity_forest_verger` (la carte réelle est `bois_antan_verger`), `new_era_zone_05 → mt_thunder_pied` (la carte réelle est `mont_grondant_pied` ; zone déblocable uniquement via debug).

### 3.4 Marqueurs d'entrée — **0 anomalie** ✅
Les 276 appels `EnterGroundMap` ont tous un marqueur d'entrée qui **existe** dans la carte cible (`Main_Entrance_Marker` etc.). Aucun `KeyNotFoundException` latent sur ce point.

### 3.5 Handlers Lua sans entité (outil `verify_entity_handlers.py`) — 18 + 1

Les plus structurants :

| Carte | Handler orphelin | Impact |
|---|---|---|
| `gloomy_forest_entrance` | `Dungeon_Entrance_Touch`, `Kangaskhan_Rock_Action`, `Butterfree_Action` | 🔴 **aucun GroundObject dans la carte** : l'entrée du donjon Gloomy Forest (ch. 6) et le rocher relais sont injouables depuis cette carte (les cartes sœurs `vast_steppe_entrance`, `mount_windswept_entrance`, `searing_tunnel_entrance`, `cloven_ruins_entrance`, `poisonous_forest_entrance` possèdent bien ces objets) |
| `palier_celeste`, `parvis_celeste` | `Dungeon_Entrance_Touch`, `Kangaskhan_Rock_Action` | 🟠 entrée du parcours Céleste absente |
| `metano_town` | `Nidoran_Male_Action`, `Metapod_Action`, `Silcoon_Action` | 🟠 3 PNJ scriptés absents de la carte |
| `metano_inn` | `Passerby_1/2_Action` | 🟠 |
| `guild_bottom_right_bedroom`, `searing_tunnel_entrance` | `Growlithe_Action` | 🟠 |
| `guild_heros_room`, `guild_storage_hallway` | `Event_Trigger_1_Touch` | 🟠 |
| `guild_third_floor_lobby` | `Test_Action` | 🟡 reliquat de test |
| `testmap` | `Chapter1_2_Action` | 🟡 reliquat de test |
| `sanctuaire_voeu` | « Terapagos » non déclaré dans `CharacterEssentials.characters` | 🟠 création dynamique cassée |

### 3.6 Scripts de carte — 269 dossiers pour 273 cartes

- **4 cartes sans dossier de script** : `bois_sombres_fond`, `place_pokemon`, `plaine_entrance`, `plaine_grotte` (dormantes, cf. §4).
- **1 dossier sans carte** : `ground/testmap_2/` (généré automatiquement le 12/2023, template de base, à supprimer).
- **Faux positifs de `verify_ground_registration.py`** : `bois_antan_oree` et `bois_antan_verger` déclarent leur table `purity_forest_oree` / `purity_forest_verger`, et `mont_grondant_pied` déclare `mt_thunder_pied` — ces modules sont le fruit de renommages `purity_forest_* → bois_antan_*`, `mt_thunder_* → mont_grondant_*`. **Sans effet moteur** (le module retourné par `require` est utilisé tel quel), mais à harmoniser pour éviter la confusion (les fichiers zone `purity_forest`/`mt_thunder` existent toujours, avec leurs propres cibles fantômes — cf. 3.3.D).
- **Dette connue** : 84 cartes appellent `RespawnAllies` sans spawner `TEAMMATE_1` (le partenaire n'apparaît pas ; erreur loguée, non fatale — documenté dans `verify_ground_registration.py`).

### 3.7 Musique — 3 anomalies sur 75 titres distincts

| Titre référencé | Cartes | Fichier réel | Impact |
|---|---|---|---|
| `In The Depths Of The Pit.ogg` | `arene_emissaire_ombre`, `gloomy_forest_boss` | `In the Depths of the Pit.ogg` (casse différente) | silence sur FS sensible à la casse |
| `Pokemon Square.ogg` | `place_pokemon` | absent | musique muette |
| `Rayquazas Domain.ogg` | `autel_celeste` | absent | musique muette |

### 3.8 Sauvegarde — `save_fixed.rssv`

La sauvegarde embarque une copie sérialisée de la liste `master_zone.Grounds` (avec les 17 entrées fantômes et les doublons). Aucune position courante ne pointe vers une carte fantôme → **pas de crash au chargement**, mais toute nouvelle sauvegarde « fige » l'index corrompu : il faut régénérer `index.idx` **et** corriger la sauvegarde de test après nettoyage.

---

## 4. Cartes dormantes et réserve

- **101 cartes non déclarées dans aucune zone** (dont 97 avec script) : c'est la **réserve** volontaire du projet (contenu préparé, non branché — cf. `docs/INVENTAIRE_GROUNDS_2026-08-02.md`). Aucune n'est référencée par Lua. ⚠️ Tant qu'elles ne sont pas déclarées dans une zone, tout `EnterGroundMap` vers elles crashe — **aucune n'est actuellement appelée** ✅.
- **4 cartes totalement inertes** (ni zone, ni référence, ni script) : `bois_sombres_fond`, `place_pokemon` (musique absente), `plaine_entrance` (marqueur dupliqué), `plaine_grotte`. Candidats à l'intégration ou au retrait.

---

## 5. Corrections recommandées (par ordre d'impact)

1. **`Data/Zone/master_zone.json`** : retirer les 12 entrées fantômes (`crystal_sanctuary_*`, `forgotten_marsh_*`, `celestial_peak_*`) et les 4 doublons (`palier_celeste`, `parvis_celeste`, `sanctuaire_voeu`, `tour_ciel_sommet`) ; remplacer les 6 entrées `waterfall_pond_*`/`poisonous_forest_*` par les 6 cartes réelles. **Tous les index ≥ 69 des scripts devront être re-résolus** (ou, mieux, remplacés par la résolution par nom `GROUND_IDX()` déjà employée par `zone/cloven_ruins`, `zone/vast_steppe`, `zone/waterfall_pond`).
2. **`zone/waterfall_pond/init.lua`** : les 3 `EnterZone(..., 71)` → `GROUND_IDX('metano_town')` ou nouvelle carte relais ; créer `waterfall_pond_relay.rsground` / `waterfall_pond_miniboss.rsground` **ou** re-pointer les 4 `EnterGroundMap` vers `sanctuaire_voeu` (seule carte existante de la zone).
3. **`Data/Zone/poisonous_forest.json`** : `GroundMaps` = `['poisonous_forest_entrance', 'poisonous_forest_relay', 'poisonous_forest_miniboss', 'poisonous_forest_boss']` (aligner sur l'index).
4. **`metano_town/init.lua` (lignes 509-513)** : `gloomy_forest 51→54`, `cloven_ruins 64→66`, puis re-pointer `waterfall_pond`, `poisonous_forest`, `celestial_peak` vers les vraies cartes d'entrée (ou résolution par nom).
5. **`gloomy_forest_entrance.rsground`** : ajouter les GroundObjects `Dungeon_Entrance` et `Kangaskhan_Rock` (+ le PNJ Butterfree) ou réécrire le script d'entrée — sans quoi le donjon Gloomy Forest (ch. 6) est inaccessible depuis sa carte d'entrée.
6. **Zones legacy (12) + `sky_tower`/`purity_forest`** : régénérer les `GroundMaps` des JSON (ou purger les listes) — signature de copier-coller `mont_grondant_pied`/`new_era_zone_05_relais` dans 14 JSON de zone.
7. **Musique** : corriger la casse `In the Depths of the Pit.ogg`, ajouter ou re-pointer `Pokemon Square.ogg` et `Rayquazas Domain.ogg`.
8. **Nettoyage** : supprimer `ground/testmap_2/` ; renommer `Duskwood Edge`/`Poison Swamp` (2e occurrence) ; retirer le 2e `Main_Entrance_Marker` de `plaine_entrance` ; purger de `index.idx` les 11 résidus non référencés (10 camps EoS `base_camp`…`guild_hut` + `test_grounds`).
9. **`index.idx`** : après tout changement, régénérer l'index (outil éditeur `RogueEssence` — index compilé) et re-tester la sauvegarde.

---

## 6. Outillage produit

**Nouveau** : `tools/audit_grounds_correlation.py` — audit automatisé complet (unicité U1-U6, corrélation C1-C9 avec le modèle de résolution moteur à 2 registres). Usage :

```bash
python3 tools/audit_grounds_correlation.py . --json /tmp/audit_grounds.json
```

**Existants réutilisés** : `tools/verify_ground_registration.py` (index + scripts + spawners), `tools/verify_ground_targets.py` (index codés en dur), `tools/verify_entity_handlers.py` (handlers sans entité).

**Limites connues de l'audit** : l'atteignabilité réelle des zones legacy et des contenus de ch. 10-12 dépend de l'état de progression de la sauvegarde — les anomalies « latentes » y sont signalées au cas où le contenu serait débloqué ; la résolution des zones « partagées » (fichiers Lua hors dossiers de carte) n'est pas attribuée à une zone unique.
