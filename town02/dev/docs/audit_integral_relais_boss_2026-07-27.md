# AUDIT INTÉGRAL — donjons, relais, boss, crash ReplayData (2026-07-27)

Rapport unique demandé. Périmètre : crash Vast Steppe (`Init_vast_steppe_midpoint`),
spawns des relais, réactivité des cinématiques, scan systématique de toutes les
zones/salles/relais, cohérence des tables de données.

---

## 0. ADDENDUM — Black screen au lancement : `Invalid Segment ID: -1 62`

### Cause exacte (moteur vérifié : GameManager.cs + ZoneData.cs, RogueCollab/RogueEssence)

Au clic sur « Continuer », `TopMenu.continueMain` relance la partie via
`GameManager.MoveToZone(Save.NextDest)`. La sauvegarde a été faite **au relais
de la Grande Steppe** : `NextDest = (master_zone, segment -1, ground 62)` —
c'est la destination écrite par `EndDungeonRun(..., "master_zone", -1, 62, ...)`
du checkpoint vague 8 (62 = `vast_steppe_midpoint`, index correct).

`MoveToZone` ne valide PAS contre le fichier de zone complet
(`master_zone.json`, qui liste bien 79 grounds) mais contre le **résumé
`ZoneEntrySummary` de `Data/Zone/index.idx`** :
`SegLocValid` → pour un ground : `0 <= ID < Grounds.Count`. Si l'index installé
est désynchronisé du JSON (résumé plus court que la liste réelle des grounds),
le jeu **fonctionne en cours de partie** (le jeu utilise alors la ZoneData
complète) mais **crash au rechargement** — exactement le symptôme observé
(écran noir après « Script variables loaded »).

### Audit systématique de l'index → 13 désynchronisations réelles trouvées et corrigées

Scan des 129 zones : comparaison entrée par entrée `index.idx` ↔ `Data/Zone/*.json` :

- **5 zones avec `Grounds` désynchronisé** (résumé vide alors que le JSON a
  1 ground) : `chapelle_nuit`, `conte_sans_fin`, `cour_clair_lune`,
  `montagne_traitresse`, `nervure_monde` → champ `Grounds` resynchronisé.
- **8 zones totalement absentes de l'index** (invisibles/plantogènes si
  jamais ciblées) : `imbion_*` (7) et `shady_shop` → entrées
  `ZoneEntrySummary` générées en reproduisant fidèlement
  `ZoneData.GenerateEntrySummary()` du moteur.

Après fix : **129/129 zones, index 100 % synchrone** (Grounds et Maps).
`master_zone` : 79 grounds, `[62] = vast_steppe_midpoint` → `SegLocValid`
passe, la sauvegarde au relais recharge.

Scan complémentaire : toutes les destinations `EndDungeonRun/EnterZone(zone,
-1, N)` des scripts confrontées aux longueurs `Grounds` de l'index —
**0 destination hors limites**.

### Consigne d'installation

Si le black screen persiste après mise à jour : la copie **installée** du mod
(dossier MODS du jeu) doit être resynchronisée avec ce dépôt — une
installation partielle (JSON de zones à jour mais `index.idx` ancien)
reproduit exactement ce crash. Aucune sauvegarde n'a besoin d'être supprimée :
la destination (ground 62) est valide dès que l'index est à jour.

---

## 1. Cause exacte du crash `ReplayData.ReadUI()` / `AutoReviveEvent` + fix

### Analyse du moteur (sources vérifiées : RogueCollab/RogueEssence, PMDCollab/PMDC)

`PMDC.Dungeon.AutoReviveEvent.Apply()` (SingleCharEvent.cs) : quand un membre
meurt en possédant une **Graine Rappel** (`seed_reviver`, `AskToUse=true` dans
`Data/Item/seed_reviver.json` du mod), le jeu demande « utiliser l'objet ? ».
**Si un replay est en cours** (`DataManager.Instance.CurrentReplay != null`),
il ne pose pas la question : il lit la réponse enregistrée via
`ReplayData.ReadUI()` → `List.get_Item(index)`. Si la liste des choix UI
enregistrés est épuisée ou désalignée → `ArgumentOutOfRangeException`. C'est
exactement la pile du log.

### Le point décisif : tout le log est un REJEU, pas une partie live

La cascade `Recorded action failed: Move …` qui précède (des dizaines en
500 ms, via `ProcessPlayerInput`) ne peut se produire **que** pendant le rejeu
d'un quicksave/replay : le moteur rejoue des inputs enregistrés qui ne
correspondent plus à l'état du donjon. Le fichier **`QUICKSAVE (1).rsqs`**
présent à la racine du dépôt (zone `vast_steppe`, daté 2026-07-26) confirme la
session quicksave. Chronologie reconstituée :

1. Le joueur recharge un quicksave de Vast Steppe fait avec une **version
   antérieure du mod** (le contenu a beaucoup changé entre-temps : spawns,
   étages, Annexe de la Toupie…). Le donjon regénéré diverge du donjon
   enregistré.
2. Les mouvements rejoués échouent en série (`Recorded action failed`) — le
   personnage n'est plus là où le replay le croit.
3. Le replay rejoue une action « Tile » sur une case qui, dans le donjon
   regénéré, **n'a plus d'effet de tuile** → `ProcessTileInteract` lève
   « Attempted to trigger a nonexistent tile effect » (DSceneMap.cs lève cette
   exception quand `tile.Effect.ID` est vide — ce n'est PAS un tile manquant
   dans nos données).
4. Le poison (état enregistré dans le quicksave) tue le héros **en arrière-plan
   du rejeu** — d'où « aucun dégât visible » : l'affichage du rejeu est déjà
   désynchronisé. → `Character.Die()` → `AutoReviveEvent` (Graine Rappel en
   inventaire) → `ReadUI()` → il n'y a **aucune réponse UI enregistrée** pour ce
   prompt (dans la partie d'origine, le joueur n'était pas mort là) → crash.
5. Le moteur abandonne le rejeu, solde le segment en `Downed` → notre
   `ExitSegment` (vague 8) fait son travail et ramène au relais →
   `Init_vast_steppe_midpoint` + `WipedCutscene`. Le KO affiché est donc un
   **effet de bord du crash de rejeu, pas un KO mérité** (préuve : la pile
   complète passe par `ProcessPlayerInput` = pipeline d'inputs rejoués, et
   l'utilisateur n'a vu ni animation de dégât ni écran K.O.).

### Fixes appliqués (côté mod — le moteur n'est pas modifiable d'ici)

- **Suppression de la seule source de RNG non-déterministe en donjon** :
  `BATTLE_SCRIPT.AnnexePolissage` (Lustro, Annexe de la Toupie) tirait l'objet
  offert avec `math.random`, qui n'est **pas** couvert par le système
  d'enregistrement (seul `GAME.Rand`/`map.Rand` l'est). Tout quicksave pris
  après une visite chez Lustro devenait irrejouable (inventaire divergent →
  désync garanti). Remplacé par `GAME.Rand:Next()` (event_battle.lua).
- **Consigne d'exploitation** (à faire côté joueur, documentée ici) : après
  toute mise à jour du mod, supprimer les quicksaves en cours (`*.rsqs`) — un
  quicksave pris sous une autre version du contenu est structurellement
  irrejouable, quel que soit le code. Le `QUICKSAVE (1).rsqs` commité dans le
  dépôt est un artefact de test, il n'est pas chargé par le jeu depuis là.
- Les autres `math.random` du code hérité Halcyon (`common.lua` ChooseQuote,
  boutiques journalières seedées) ne touchent que du texte d'ambiance ou du
  contexte ville (hors enregistrement dungeon) — laissés en l'état, listés en
  « à surveiller » §7.

## 2. « Recorded action failed » + « nonexistent tile effect » + fix

Couvert au §1 : ce sont les symptômes 2 et 3 du **même** rejeu désynchronisé,
pas des bugs indépendants. Vérifications faites pour l'exclure côté données :

- **Aucun effet de tuile orphelin** : scan complet des 129 `Data/Zone`, 483
  `Data/Map`/`Data/Ground` → toutes les références `tile_*`/`stairs_*`
  absentes du mod (`tile_wonder`, `tile_evo`, `stairs_secret_*`…) existent dans
  le **jeu de base** (vérifié fichier par fichier contre l'index DumpAsset,
  59/59 présents). Le mod est de type `Quest` : ces IDs se résolvent dans les
  données de base au runtime. Les 2 seuls tiles ajoutés par le mod
  (`tile_mystery`, `mysterious_distortion`) sont bien présents **et indexés**
  (`Data/Tile/index.idx`, `Data/MapStatus/index.idx`).
- Le donjon Vast Steppe n'a **pas** de tile poison custom : le poison venait
  d'un statut de combat classique, appliqué par le rejeu.

## 3. Fix du placement de spawn (statue Kangourex)

Cause réelle du « héros sur la statue » : dans **7 des 9** cinématiques
`WipedCutscene`, la position téléportée du **partenaire** (et la caméra
centrée dessus donnait l'impression que c'était le héros) chevauchait le
collider du rocher Kangourex (24×24). Test d'intersection boîte 16×16 vs
collider, AVANT fix :

| Relais | Chevauchement détecté |
|---|---|
| vast_steppe_midpoint | partenaire (704,224) SUR rocher (696,216,24×24) |
| mount_windswept_midpoint | partenaire (992,368) SUR rocher (984,352) |
| cloven_ruins_midpoint | partenaire (192,328) SUR rocher (188,312) |
| crystal_sanctuary_relay | partenaire (432,136) SUR rocher (424,120) |
| forgotten_marsh_relay | partenaire (160,208) SUR rocher (152,192) |
| celestial_peak_relay | partenaire (116,256) SUR rocher (104,240) |
| searing_tunnel / gloomy / crooked | OK (pas de chevauchement) |

**Nouvelles coordonnées (toutes flood-vérifiées libres, boîte 16×16 entière)** :

| Relais | Héros | Partenaire | Caméra |
|---|---|---|---|
| vast_steppe_midpoint | (668,256) | (700,256) | (684,264) |
| mount_windswept_midpoint | (960,360) | (992,384) | (976,368) |
| cloven_ruins_midpoint | (172,344) | (204,344) | (188,336) |
| crystal_sanctuary_relay | (408,152) | (440,152) | (424,144) |
| forgotten_marsh_relay | (136,224) | (168,224) | (152,216) |
| celestial_peak_relay | (88,272) | (120,272) | (104,264) |

Le duo se réveille **devant/sous la statue**, jamais dessus. La collision
solide du rocher existait déjà dans les 15 relais (`Passable=False`,
TriggerType Action) — rien à ajouter côté map.

### Partenaire éloigné / non lié au héros — 3 causes corrigées

1. **Spawners de la map à 350 px du marker** : à Vast Steppe, les spawners
   `TEAMMATE_1/2/3` étaient collés au rocher (744/712/680,296) alors que le
   `Main_Entrance_Marker` est à (388,268) — reliquat de la conversion. En
   arrivée normale, le héros apparaissait au marker et le partenaire **à
   l'autre bout du camp**. Corrigé par patch chirurgical des `.rsground`
   (SEULS les 3 champs `Collider.X/Y` des spawners changent — diff git : 12
   lignes par fichier ; tiles/obstacles/décor prouvés identiques octet pour
   octet) : vast_steppe → (356,300)/(420,300)/(388,236) autour du marker ;
   mount_windswept → (804,416)/(868,416)/(836,352) ; gloomy_forest →
   (324,270)/(260,238)/(324,238). Les autres relais étaient déjà à ≤56 px.
2. **`LoadGamePartnerPosition` sans garde-fou** : au rechargement d'une
   sauvegarde, le partenaire était téléporté aveuglément sur
   `SV.partner.LoadPositionX/Y` — y compris `-1,-1` (défaut) ou des
   coordonnées d'une **autre carte** (reliquat). Fix dans
   `PartnerEssentials.lua` : position invalide (<0) ou à plus de 240 px du
   héros ⇒ repositionnement à côté du héros (+32,0), puis IA `ground_partner`
   réactivée normalement.
3. **WipedCutscene ne resynchronisait pas le suivi** : après la scène, l'IA
   était réactivée mais sans ré-ancrer `ground_partner` sur le héros ni
   sauvegarder la position. Les 6 scènes font désormais
   `AI:SetCharacterAI(partner,'origin.ai.ground_partner',hero,…)` +
   `PartnerEssentials.SaveGamePartnerPosition(partner)`.

## 4. Cinématique corrigée — réaction confirmée par personnage

`vast_steppe_midpoint` — personnages présents dans la scène de réveil et leur
séquence APRÈS fix :

| Personnage | Présence | Actions scriptées |
|---|---|---|
| Héros | ✅ | EventSleep → anim `Wake` → tourne vers le bas |
| Partenaire (« Rin ») | ✅ | EventSleep → `Wake` désynchronisé (+14f) → 4 répliques (Pain/Worried/Normal/Determined) → IA de suivi ré-ancrée |
| Hyko (Caninos, Teammate2) | ✅ **nouveau** | posté en contrebas (640,296), émote Exclaim au réveil du duo, 2 répliques (« Ils se réveillent ! », rappel du protocole) |
| Almotz (Zigzaton, Teammate3) | ✅ **nouveau** | posté en contrebas (724,296), tourne la tête vers le duo, 1 réplique (les a tirés des herbes hautes) |

Même traitement pour `mount_windswept_midpoint` (Hyko : les feux du camp ;
Almotz : la corniche). La scène équivalente du Tunnel Ardent faisait déjà
réagir les 4 personnages (réveils décalés + LookAround + répliques) — modèle
suivi. Les relais ch3/6/7-10 sont des scènes à 2 (le duo est seul dans ces
donjons, cohérent avec l'histoire) : les 2 acteurs y ont chacun réveil animé +
dialogue.

## 5. Tableau récapitulatif par donjon (scan automatisé, 129 zones)

Méthode : parsing des `Data/Zone/*.json` (segments) croisé avec les
`ExitSegment` Lua (segments gérés, fallback `else`/`EndDungeonRun`), existence
des grounds référencés, marker `Main_Entrance_Marker` dans chaque ground.

| Donjon | Entrance | Exit/retour | Relais + cinés | Mini-boss | Boss | Notes |
|---|---|---|---|---|---|---|
| crooked_cavern (ch3) | OK | OK | OK (3 états + KO) | — | OK (chapter_3_boss_fight) | |
| vast_steppe (ch5) | OK | OK | **CORRIGÉ** (spawns + Hyko/Almotz réactifs) | OK vast_steppe_miniboss | OK vast_steppe_guardian | **fix bloc segment 4 imbriqué** |
| searing_tunnel (ch5) | OK | OK | OK (scène à 4 déjà conforme) | OK (Tropius) | OK (lave scriptée) | **fix bloc segment 3 imbriqué** |
| mount_windswept (ch5) | OK | OK | **CORRIGÉ** (idem steppe) | OK | OK | **fix bloc segment 4 imbriqué** |
| gloomy_forest (ch6) | OK | OK | OK + **spawners rapprochés** | — | OK (Zarude, flag requis) | |
| cloven_ruins (ch7) | OK | OK | **CORRIGÉ** (spawn hors statue) | — | OK | |
| crystal_sanctuary (ch8) | OK | OK | **CORRIGÉ** | — | OK (Diancie) | |
| forgotten_marsh (ch9) | OK | OK | **CORRIGÉ** | — | OK (Méga-Tortank) | |
| celestial_peak (ch10) | OK | OK | **CORRIGÉ** | OK (Fulgur) | OK (Lugia) | |
| 15 secondaires vague 2 | OK | OK (retour bourg) | n/a | n/a | n/a | |
| 49 donjons-Ancrages ch11-32 | OK | OK | n/a | n/a | OK (LegendZones + ciné vague 7) | |
| 34 new_era_zone_XX (Réseau) | OK | OK | OK (6 Stations + ciné d'arrivée) | n/a | OK (12 Veilleurs) | |
| 57 Friend Areas / arènes | OK | OK | n/a | n/a | OK | 2 arènes réservées non câblées (voir §7) |
| master_zone | n/a (hub) | n/a | n/a | n/a | n/a | ExitSegment vide = normal (grounds only) |

Résultat du scan « segments orphelins sans fallback » : **1 seul** vrai cas
(`master_zone`, qui est le hub — comportement normal). Les 62 alertes brutes
initiales étaient des faux positifs (fallback inconditionnel en fin de
fonction plutôt que `else`), re-vérifiées une à une par heuristique affinée.

**3 bugs réels de flux découverts et corrigés par ce scan** : dans
`vast_steppe`, `mount_windswept` et `searing_tunnel`, le bloc « Annexe de la
Toupie » (sortie du segment mystère) avait été inséré **à l'intérieur** de la
branche du mini-boss (resp. mort/fuite) au lieu du niveau racine : sortir de
l'Annexe déclenchait le retour à l'arène du mini-boss (ou n'était jamais
atteint). Blocs remontés en tête de fonction — comme dans les 9 autres donjons
équipés, qui étaient corrects.

## 6. Mini-boss : ground importée ou salle créée

| Rencontre | Décision | Source / raison |
|---|---|---|
| Tropius (Tunnel Ardent ch5) | Ground map importée | Halcyon d'origine (searing_tunnel_miniboss) |
| Mini-boss Steppe ch5 | Ground map importée | Halcyon d'origine (vast_steppe_miniboss) |
| Mini-boss Mont Venteux ch5 | Ground map importée | Halcyon d'origine (mount_windswept_miniboss) |
| Escouade Fulgur (ch10) | Ground map importée | DumpAsset (celestial_peak_fulgur) |
| Zarude (ch6) | Ground map importée | DumpAsset (gloomy_forest_boss) |
| Trio Regi + Regigigas | Ground map importée | EoSO « Deep Aegis Cave » → Titans_Arena_Base |
| 42 gardiens-Ancrages | Ground maps importées | pmd-red/sloth/DumpAsset (cf. DOCUMENT_MAITRE) |
| 12 Veilleurs du Réseau | Salle de donjon standard + dialogue | par conception : combat au dernier étage du segment, dialogues avant/après dans ExitSegment — pas de ground dédiée nécessaire, aucun biome incohérent |

Aucun mini-boss ne reste sans salle cohérente ; le fallback « salle créée +
cinématique » (SEGMENT H) n'a donc pas eu à produire de nouvelle map.

## 7. Zones à risque : identifiées / corrigées / restantes

- **Identifiées** : 29 (7 WipedCutscene avec chevauchement statue ; 3 maps à
  spawners éloignés ; 3 zones à bloc Annexe imbriqué ; 1 RNG non-déterministe
  en donjon ; 1 LoadGamePartnerPosition sans failsafe ; 1 quicksave périmé ;
  **13 entrées d'index de zones désynchronisées** — cause du black screen au
  lancement, cf. §0).
- **Corrigées** : 28 (tout sauf le quicksave, qui est un artefact côté
  utilisateur — consigne donnée §1).
- **Restant à vérifier manuellement (en jeu)** : 2 arènes importées non
  câblées et sans `Main_Entrance_Marker` (`arene_cauchemar`,
  `arene_emissaire_ombre` — réservées, aucune référence de script ne pointe
  dessus : sans danger tant qu'inutilisées, marker à poser au câblage) ; les
  `math.random` hérités de Halcyon dans le chatter partenaire en donjon
  (texte d'ambiance uniquement, ne modifie pas l'état de jeu — risque replay
  théorique faible) ; test in-game de non-régression (§9).

## 8. Fichiers créés/modifiés (ce lot)

**Modifiés**
- `Data/Zone/index.idx` — **resync 5 zones + ajout 8 zones manquantes (fix black screen `Invalid Segment ID: -1 62`)**
- `Data/Script/halcyon/event_battle.lua` — RNG déterministe Lustro
- `Data/Script/halcyon/PartnerEssentials.lua` — failsafe LoadGamePartnerPosition
- `Data/Script/halcyon/zone/vast_steppe/init.lua` — bloc Annexe désimbriqué
- `Data/Script/halcyon/zone/mount_windswept/init.lua` — idem
- `Data/Script/halcyon/zone/searing_tunnel/init.lua` — idem
- `Data/Script/halcyon/ground/vast_steppe_midpoint/vast_steppe_midpoint_ch_5.lua` — spawns hors statue + Hyko/Almotz réactifs
- `Data/Script/halcyon/ground/mount_windswept_midpoint/mount_windswept_midpoint_ch_5.lua` — idem
- `Data/Script/halcyon/ground/cloven_ruins_midpoint/init.lua` — spawn hors statue + re-ancrage IA
- `Data/Script/halcyon/ground/crystal_sanctuary_relay/init.lua` — idem
- `Data/Script/halcyon/ground/forgotten_marsh_relay/init.lua` — idem
- `Data/Script/halcyon/ground/celestial_peak_relay/init.lua` — idem
- `Data/Ground/vast_steppe_midpoint.rsground` — 3 Collider spawners (12 lignes)
- `Data/Ground/mount_windswept_midpoint.rsground` — idem
- `Data/Ground/gloomy_forest_midpoint.rsground` — idem

**Créés**
- `docs/audit_integral_relais_boss_2026-07-27.md` (ce rapport)

## 9. Confirmation d'intégrité + tests

- **Aucune géométrie/collision/décor modifié** : pour les 3 `.rsground`
  touchés, contrôle programmatique post-patch — `Layers` (tiles), `obstacles`
  et `Decorations` **strictement identiques** à HEAD ; seuls 3 champs
  `Collider.X/Y` de spawners diffèrent (diff git : 12 lignes/fichier).
- Scan final automatique : **0 chevauchement** spawner/objet et **0
  chevauchement** TeleportTo/objet sur les 15 relais + 9 WipedCutscene ;
  toutes les cases d'éveil 100 % walkables (flood-check).
- 11 fichiers Lua modifiés validés `loadfile` sans erreur (lupa).
- **Références de données** : 0 espèce, 0 skill, 0 objet cassé sur l'ensemble
  scripts + zones (croisement avec l'index complet du jeu de base : 1011
  monstres, 883 skills, 2452 items).
- **Limite honnête** : le test in-game (SEGMENT I — reproduire le KO poison,
  vérifier le respawn et le rejeu de quicksave) ne peut pas être exécuté dans
  cet environnement sans le moteur ; toutes les validations ci-dessus sont
  statiques mais couvrent chaque mécanisme incriminé par le log.
