# Audit ch5 — Chargement des segments & salles de boss/mini-boss (2026-07-27)

Vérification statique complète des 3 donjons du chapitre 5 (Grande Steppe,
Tunnel Incandescent, Mont Venteux) : segments de zone, arènes, grounds,
scripts de flux, dépendances (musiques, tilesets, statuses), post-fix écran noir.

## 1. Segments de zone — ✅ tous chargeables

| Zone | Segment | Type | Étages | Carte/Gén | Musique | Verdict |
|---|---|---|---|---|---|---|
| vast_steppe | 0 | RangeDict | 0-6 (7) | génération grille | Sky Peak Prairie.ogg | ✅ couverture 0..6 complète |
| vast_steppe | 1 | Layered | 1 | `vast_steppe_miniboss.rsmap` | Boss Battle!.ogg | ✅ |
| vast_steppe | 2 | RangeDict | 0-6 (7) | génération grille | Sky Peak Prairie.ogg | ✅ |
| vast_steppe | 3 | Layered | 1 | `vast_steppe_guardian.rsmap` | Boss Battle!.ogg | ✅ |
| searing_tunnel | 0 | RangeDict | 0-9 (2 nœuds 0-4/5-9) | génération | Spring Cave.ogg | ✅ couverture 0..9 sans trou |
| searing_tunnel | 1 | RangeDict | 0-4 (5) | génération | Lower Spring Cave.ogg | ✅ |
| searing_tunnel | 2 | Layered | 1 | `searing_crucible.rsmap` | Boss Battle!.ogg | ✅ |
| mount_windswept | 0 | RangeDict | 0-6 (7) | génération | Mt. Travail.ogg | ✅ |
| mount_windswept | 1 | Layered | 1 | `mount_windswept_miniboss.rsmap` | Boss Battle!.ogg | ✅ |
| mount_windswept | 2 | RangeDict | 0-5 (6) | génération | Mt. Travail.ogg | ✅ |
| mount_windswept | 3 | Layered | 1 | `mount_windswept_guardian.rsmap` | Boss Battle!.ogg | ✅ |

`index.idx` cohérent : vast_steppe 14 étages [7,1,7,1], mount_windswept 13
[7,1,6,1], searing_tunnel 15 [10,5,1].

## 2. Arènes de combat (.rsmap) — ✅ 6/6 valides

| Arène | Dim. | Boss (espèce, niv, pos) | Entrées sur sol | Flood-fill | Statuses |
|---|---|---|---|---|---|
| vast_steppe_miniboss | 15×15 | Mudbray 16 (7,4) + Stantler 16 (5,5) | 2/2 ✅ | 169/169 ✅ | mysterious_force |
| vast_steppe_guardian | 17×15 | Stantler 20 (8,4) | 2/2 ✅ | 195/195 ✅ | mysterious_force |
| searing_tunnel_miniboss | 15×15 | Torkoal 17 (6,4) + Magmar 17 (9,4) | 2/2 ✅ | 169/169 ✅ | mysterious_force |
| searing_crucible | 21×21 | Magcargo 18 + 8 Slugma 13 (anneau) | 1/1 ✅ | 72/72 ✅ | steam + mysterious_force |
| mount_windswept_miniboss | 15×15 | Gligar 18 (5,4) + Skarmory 18 (9,4) | 2/2 ✅ | 169/169 ✅ | mysterious_force |
| mount_windswept_guardian | 17×15 | Aerodactyl 22 (8,4) | 2/2 ✅ | 195/195 ✅ | mysterious_force |

Tous les boss sont sur cases walkables ET atteignables depuis l'entrée.
Statuses `steam`/`mysterious_force` présents dans `Data/MapStatus/`. Niveaux
conformes au palier 2 (équipe 15-25).

## 3. Flux segment→ground→segment — ✅ chaîne complète vérifiée

```
entrance ──EnterDungeon(seg 0)──▶ seg0 ──Cleared──▶ midpoint (relais)
midpoint ──North_Exit──▶ EnterDungeon(seg 2)   [steppe/mont]
   ▲                        │ Cleared
   │                        ▼
   │              zone.ExitSegment ──▶ ground miniboss/guardian (cinématique)
   │                        │ ContinueDungeon(seg 1/3) = combat
   │                        ▼
   └──DefeatedBoss──── ground (retour) ──▶ midpoint / suite
```
- Steppe : seg0→midpoint→seg2→guardian ground→seg3(combat)→guardian ground→
  sortie vers Tunnel (master_zone[47]). Miniboss : entré via ExitSegment(1)
  — win/lose deux chemins écrits (DefeatedBoss→midpoint, DiedToBoss→entrance).
- Tunnel : seg0→miniboss ground (ContinueDungeon 1)→seg1→ExitSegment(1)→
  crucible ground (cinématique Magcargo)→ContinueDungeon(2)=combat→retour.
- Mont : seg0→midpoint→seg2→guardian ground→seg3→victoire = fin d'expédition
  (Chapter=6 posé dans zone init ET mount_windswept_guardian_ch_5 — cohérent).
- Tous les `EndDungeonRun(master_zone, -1, N)` vérifiés : ground[1]=metano_town,
  [6]=guild_dining_room, [22]=guild_second_floor, [46]=vast_steppe_entrance,
  [47]=searing_tunnel_entrance, [48]=searing_tunnel_midpoint,
  [49]=searing_crucible, [50]=mount_windswept_entrance. ✅ aucun index cassé.
- 27 scripts Lua ch5 : syntaxe OK (lupa), strings.resx + strings.fr.resx
  présents partout où MapStrings est utilisé.

## 4. Grounds ch5 — inventaire complet avec provenance

| Ground | Rôle | Dim (cellules 8px) | Provenance | Tilesets |
|---|---|---|---|---|
| vast_steppe_entrance | camp d'entrée Steppe | 64×64 | **création New Era** | Vast_Steppe_* (4 feuilles) |
| vast_steppe_midpoint | relais (Kangourex) | 99×66 | **importé DumpAsset : `cliff_camp`** (relais officiels 1ad6675) | CliffCamp |
| vast_steppe_miniboss | cinématique mini-boss | 46×66 | **création New Era** (crop du biome) | VastSteppeMiniboss_* |
| vast_steppe_guardian | cinématique gardien | 46×66 | **création New Era** | VastSteppeGuardian_* |
| searing_tunnel_entrance | camp d'entrée Tunnel | 73×48 | **création New Era** | Searing_Tunnel_* |
| searing_tunnel_midpoint | relais (patron canonique) | 57×57 | **halcyon d'origine** (autotiles magma_cavern_2) | autotiles jeu de base |
| searing_tunnel_miniboss | cinématique mini-boss | 52×68 | **création New Era** | SearingTunnelMiniboss_* |
| searing_crucible | antre de Magcargo (cinématique majeure) | 63×63 | **importé DumpAsset : tileset `Spring_Cave_Pit`** | Spring_Cave_Pit |
| mount_windswept_entrance | camp d'entrée Mont | 69×63 | **création New Era** | Mount_Windswept_* |
| mount_windswept_midpoint | relais/camp de base | 144×78 | **importé DumpAsset : `canyon_camp`** (relais officiels) | CanyonCamp |
| mount_windswept_miniboss | cinématique mini-boss | 48×66 | **création New Era** | MountWindsweptMiniboss_* |
| mount_windswept_guardian | cinématique gardien (falaise) | 66×78 | **importé DumpAsset : `end_treacherous_mountain`** (tileset MountainPeak) | MountainPeak |

Audit spatial des 12 grounds : `Main_Entrance_Marker` sur cellule walkable
12/12 ; spawners TEAMMATE_1..3 présents 12/12 ; flood-fill : toutes les entités
(markers, spawners, objets interactifs) dans la composante atteignable — les
zones « non atteignables » résiduelles (entrances/miniboss) sont des poches
décoratives hors gameplay, sans entité. `$values` orphelins : 0 (post-fix).

## 5. Anomalies trouvées → corrigées dans ce commit

1. **`mount_windswept_entrance` : Kangaskhan_Rock triggerType=0** (inerte) alors
   que le script `Kangaskhan_Rock_Action` existe et que les 2 autres entrances
   sont à 1 (Action). → passé à 1.
2. **`searing_crucible` : champ Music vide** → `In the Depths of the Pit.ogg`
   (celle que le script ch5 joue) en musique par défaut du ground.
3. **`mount_windswept_entrance` : champ Music vide** → `Canyon Camp.ogg`
   (utile hors ch5 ; en ch5 les PlayBGM scriptés priment).

## 6. Limite

Validation statique (JSON/flux/flood-fill). Le test en jeu (chargement réel
par le moteur) reste à faire — aucun crash connu attendu au vu du format
canonique (identique aux grounds officiels) et du fix écran noir appliqué.

---

# ADDENDUM 2026-07-27 (2) — Balayage anti-bugs global + architecture des arènes

## A. Balayage complet du dépôt

| Check | Résultat |
|---|---|
| Tous les JSON Data/* se parsent | ✅ 0 invalide |
| `$values` orphelins (cause écran noir) | ✅ 0 dans tout le dépôt |
| Tilesets référencés par .rsmap/.rsground | ✅ 4 manquants récupérés (LuminousSpring, LuminousSpringAnim, PostOffice, TownBase) + index régénéré (297) |
| Musiques référencées par les zones | ✅ 1 manquante récupérée (Faded Trail.ogg, réf. préexistante d'imbion_grainy_pasture) |
| Cibles `ContinueDungeon`/`EnterDungeon` | ✅ tous les segments cibles existent |
| Grounds fantômes master_zone (base_camp…, hérités du jeu de base, jamais présents) | ✅ inoffensifs : aucun script ne les vise (seule réf = code commenté luminous_spring) — indices 10-19/54 à ne jamais utiliser |

## B. Bugs réels trouvés → corrigés

1. **ch3 CASSÉ (préexistant)** : `crooked_cavern` seg[2] chargeait `MapID:
   "crooked_den"` — ce .rsmap n'existe pas (crooked_den n'est qu'un ground).
   L'arène réelle est `chapter_3_boss_fight.rsmap` (Luxio 10/Glameow 9/Cacnea 9,
   cf. commentaire du zone script). → MapID corrigé. De plus `crooked_den_ch_3.lua`
   lançait le combat sur le segment 1 (devenu procédural depuis l'insertion des
   Profondeurs) au lieu du 2 → 2 appels corrigés.
2. **Vague 2** : `foret_embuscade`/`jardin_secret` listaient leur carte finale
   (.rsmap) dans `GroundMaps` (liste de .rsground) → retirées.
3. **Imbion (préexistant)** : 4 zones réclamaient des salles finales
   `end_ashen_geode`/`end_berry_grove`/`end_gourmet_jungle`/`end_grainy_pasture`
   jamais importées (GameBanana CC BY-NC-ND, non re-téléchargeable ici) → le
   dernier étage est rendu procédural (extension du nœud précédent) ; salles
   spéciales restaurables si les fichiers redeviennent accessibles.

## C. Architecture des arènes de boss/mini-boss (réponse à la question)

**Patron général : 3 pièces par boss.**
1. **Étages normaux** = segments `RangeDictSegment` (génération procédurale).
2. **Ground de cinématique** (`.rsground`, hors-donjon) : le `ExitSegment` du
   segment précédent y envoie (`EnterGroundMap`). C'est là que se jouent
   dialogue/mise en scène — puis `ContinueDungeon(zone, N)` lance le combat.
3. **Arène de combat** = **étage spécial de donjon** : segment dédié
   `LayeredSegment`/`LoadGen` qui charge une carte fixe `.rsmap` (1 étage,
   status `mysterious_force`, boss = MapTeam placée).

| Ch. | Zone | Arène (.rsmap = étage spécial) | Ground de cinématique |
|---|---|---|---|
| 1 | relic_forest | — (pas de boss segmenté) | scènes dans `relic_forest` ground |
| 2 | illuminant_riverbed | — | `luminous_spring` (fin scénarisée) |
| 3 | crooked_cavern | seg2 `chapter_3_boss_fight` (corrigé) | `crooked_den` |
| 4 | apricorn_grove | — (fin scénarisée) | `apricorn_glade` |
| 5 | vast_steppe | seg1 `vast_steppe_miniboss` / seg3 `vast_steppe_guardian` | grounds homonymes |
| 5 | searing_tunnel | seg2 `searing_crucible` | `searing_tunnel_miniboss` (mi-parcours, combat SUR seg1 procédural — intentionnel : embuscade en étage normal) + `searing_crucible` |
| 5 | mount_windswept | seg1/seg3 `mount_windswept_miniboss`/`_guardian` | grounds homonymes |
| 6 | gloomy_forest | seg2 `gloomy_forest_boss` (Zarude) / seg3 `verdant_oath_arena` (revanche) | `gloomy_forest_boss` ground |
| 7 | cloven_ruins | seg3 `cloven_ruins_boss` (Regigigas) | `cloven_ruins_boss` ground |
| 8 | crystal_sanctuary | seg3 `crystal_sanctuary_boss` (Diancie) | `crystal_sanctuary_boss` ground |
| 9 | forgotten_marsh | seg3 `forgotten_marsh_boss` (Laggron) | `forgotten_marsh_boss` ground |
| 10 | celestial_peak | seg3 `celestial_peak_fulgur` (Escouade) / seg5 `celestial_peak_boss` (Lugia, retilé Rainbow_Peak) | `autel_celeste` (pmd-red 1:1) |

Note : deux cas à part, tous deux voulus — le mini-boss du Tunnel (Torkoal/Magmar)
attaque sur un étage procédural du segment 1 (embuscade), et Gloomy Forest a une
4e arène (`verdant_oath_arena`) pour la revanche légendaire Zarude.

---

# ADDENDUM 2026-07-27 (3) — Vérification boss ch6-10 + correspondances pmd-red/pmd-sky

## A. Arènes de combat ch6-10 : 7/7 ✅ (vérif machine)

| Arène (.rsmap) | Boss | Niv | Entrées | Flood-fill | mysterious_force | Lancement (`ContinueDungeon`) |
|---|---|---|---|---|---|---|
| gloomy_forest_boss | Zarude | 27 | 2/2 sur sol | 104/104 | ✅ | seg 2 ✅ |
| verdant_oath_arena | Zarude (revanche) | 30 | 2/2 | 104/104 | ✅ | seg 3 ✅ |
| cloven_ruins_boss | Regigigas | 28 | 2/2 | 104/104 | ✅ | seg 3 ✅ |
| crystal_sanctuary_boss | Diancie | 30 | 2/2 | 104/104 | ✅ | seg 3 ✅ |
| forgotten_marsh_boss | Laggron (swampert) | 32 | 2/2 | 104/104 | ✅ | seg 3 ✅ |
| celestial_peak_fulgur | Luxray/Lucario/Heliolisk | 33 | 2/2 | 104/104 | ✅ | seg 3 ✅ |
| celestial_peak_boss | Lugia | 35 | 2/2 | 104/104 | ✅ | seg 5 ✅ (via autel_celeste) |

Grounds de cinématique associés : 8/8 ✅ (Main_Entrance_Marker sur sol,
TEAMMATE_1..3 présents, toutes entités atteignables, musiques présentes).
Note : `celestial_peak_boss.rsground` (ground, tileset Mount_Windswept_Base)
est un VESTIGE non référencé par aucun script — remplacé par `autel_celeste` ;
conservé mais inutilisé, sans risque.

## B. Correspondance boss ↔ donjons PMD officiels (pmd-red / Explorers of Sky)

| Boss New Era | Existe dans pmd-red (GBA) ? | Existe dans Explorers of Sky ? | Zone importable ? | Décision |
|---|---|---|---|---|
| Mini-boss ch5 (Mudbray/Stantler, Torkoal/Magmar, Gligar/Skarmory, Magcargo, Aerodactyl) | non (boss inventés New Era) | non | — | arènes création New Era ✅ |
| Zarude (ch6) | non (Pokémon gén. 8, inexistant dans tout PMD) | non | — | création New Era ✅ |
| **Regigigas (ch7)** | non (gén. 4 ; pmd-red = gén. 3). Le trio Regi y est à Buried Relic mais en **FIXED_ROOM de donjon** (étages fixes), pas en ground map → rien à importer 1:1 | oui : **Aegis Cave** — mais **EXCLUE DÉFINITIVEMENT** par la directive (doublon Regigigas, source EoSO) | non | arène création New Era ✅ conforme à la directive |
| **Diancie (ch8)** | non (gén. 6) | non | — | création New Era ✅ |
| **Laggron (ch9)** | non (jamais boss légendaire dans PMD) | non | — | création New Era ✅ |
| Escouade Fulgur (ch10) | non (équipe originale) | non | — | création New Era ✅ |
| **Lugia (ch10)** | oui : Silver Trench (cinématique D15P01) + notre choix Sky Tower Summit (D13P03) | (Silver Trench absent de Sky) | **oui — déjà fait** | cinématique = `autel_celeste` (D13P03 1:1) ; D15P01 converti en réserve (`fosse_argentee`) |

En résumé : **Lugia est le seul boss ch1-10 qui possède une zone PMD officielle
importable — et elle est déjà importée et branchée.** Regigigas avait un
candidat (Aegis Cave) explicitement exclu par la directive multi-sources ;
Diancie, Laggron, Zarude et les mini-boss n'existent dans aucun PMD → leurs
arènes/grounds sont des créations New Era, et les 12 arènes pmd-red converties
en réserve (Groudon, Kyogre, Ho-Oh, Mewtwo, oiseaux, chiens, Latios, Jirachi…)
restent disponibles pour les chapitres 11+.
