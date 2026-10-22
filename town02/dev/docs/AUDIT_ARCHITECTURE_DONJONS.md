# Audit architecture des donjons — 3 structures, pas une de plus

Date : 2026-07-30. Référence validée en jeu : **crooked_cavern** (intouchée, protégée).

## Le modèle de référence (crooked_cavern, tel que lu dans le JSON moteur)

- **La Route** = 2 `RangeDictSegment` procéduraux (étages 0-5 / 5-10 chacun) — la seule structure générée (RogueElements).
- **La zone du Boss** = 1 `LayeredSegment` final chargé à la main (`LoadGen:chapter_3_boss_fight`).
- **Pas de Mini-boss** → aucune structure correspondante n'existe (c'est le point : ne jamais en créer par habitude).
- Grounds déclarés (`GroundMaps`) : `crooked_cavern_entrance` (approche) et `crooked_den` (scène post-boss) — ce sont des **cartes de narration hors donjon**, pas des structures du donjon ; elles n'ont pas vocation à être comptées dans les 3 structures.

Règles de cohérence fichiers (déduites de l'audit, lecture moteur) :
- tout changement de segmentation **doit régénérer l'entrée de la zone dans `Data/Zone/index.idx`** (`Grounds` = noms des GroundMaps ; `Maps` = listes d'ID d'étages, convention **Max exclu** : `et0-7` = étages 0..6 = 7 étages). Un idx périmé = la classe exacte du crash hero_dream (L15) : le résumé et la zone chargée racontent deux histoires.
- `LayeredSegment` (étage chargé, boss/mini-boss/relais) est l'outil natif pour les points fixes manuels — conforme au modèle Zone/Segment/Floor de RogueEssence, aucune structure parallèle inventée.

## Inventaire et classification des donjons d'histoire

| Donjon | Segments (étages) | Verdict vs modèle |
|---|---|---|
| crooked_cavern (ch3) | Route 10+10 · Boss | ✅ conforme, intouché |
| vast_steppe (ch4) | Route 7 · Mini-boss · Route 7 · Boss · **annexe_toupie** | ⚠️ 1 hors-cadre — **différé (validé en jeu, gelé)** |
| searing_tunnel (ch5) | Route 10 · Route 5 · Mini-boss · Boss · **annexe_toupie** | ⚠️ 1 hors-cadre — **différé (chapitre en cours de test)** |
| mount_windswept (ch5) | Route 7 · Mini-boss · Route 6 · Boss · **annexe_toupie** | ⚠️ 1 hors-cadre — **différé (chapitre en cours de test)** |
| gloomy_forest (ch6) | Route 18 · Route 3 · Mini-boss · Route 3 · Boss · **verdant_oath_arena** · **annexe_toupie** · serment_dazzling_arene · metano_raid_1/2/3 | ⚠️ 2 hors-cadre — **différé (TownRaid route par INDEX de segment ; retrait = renumérotation coordonnée)** |
| cloven_ruins (ch7) | Route 20 · Relais · Route 3 · Mini-boss · Route 3 · Boss · <s>annexe_toupie</s> | ✅ **migré** |
| crystal_sanctuary (ch8) | Route 25 · Relais · Route 3 · Mini-boss · Route 3 · Boss · <s>annexe_toupie</s> | ✅ **migré** |
| forgotten_marsh (ch8) | Route 30 · Relais · Route 3 · Mini-boss · Route 3 · Boss · <s>annexe_toupie</s> | ✅ **migré** |
| celestial_peak (ch9) | Route 35 · Relais · Route 3 · Mini-boss · Route 3 · Boss · <s>annexe_toupie</s> | ✅ **migré** |

Notes :
- les relais (`*_relay`/relais chargés) sont des `LayeredSegment` placés **au milieu de la Route** = partie intégrante de la Route (point fixe manuel), conforme à la règle — pas une structure à part.
- `autel_celeste` (ground de celestial_peak) est référencé par des scripts (init zone + BossMusic + ground init) → **vivant et justifié narrativement**, conservé.
- Éléments « vivants » de gloomy_forest (non hors-cadre) : `serment_dazzling_arene` (seg 7) et `metano_raid_1/2/3` (segs 8-10) sont lancés par `TownRaid.lua` via `ContinueDungeon('gloomy_forest', 7 + wave, …)` — contenu d'événement de raid branché par index.

## Éléments hors-cadre — décisions

1. **`annexe_toupie`** (LoadGen post-boss, dernier segment de 7 donjons sur 8) : **0 référence Lua**, absent du modèle Crooked, héritage de gabarit. Décision : suppression.
   - **Appliqué** : cloven_ruins, crystal_sanctuary, forgotten_marsh, celestial_peak (ch6-9, non validés en jeu ; scripts `ContinueDungeon` max seg 5 = boss, non affectés).
   - **Différé (à appliquer dès retest en jeu possible)** : vast_steppe (ch4 **validée** — gelée), searing_tunnel + mount_windswept (ch5 **en cours de test** — ne pas mélanger avec le diagnostic crash/transition en cours). Le diff est trivial : retirer le dernier Segment + régénérer l'entrée idx (Maps → 5 segments).
   - **Différé gloomy_forest** : annexe en seg 6 + `verdant_oath_arena` en seg 5 (0 référence Lua). Retirer les deux exige de renuméroter TownRaid (`7 + wave` → `5 + wave`) et `gloomy_forest_boss/init.lua` (seg 7 → 5) : à faire en une seule fois, quand TownRaid entrera en phase de test.
2. **`backup_master_zone`** (zone "Debug" de sauvegarde, 46 grounds, Released) : référencée **uniquement par son propre init.lua**. Décision : suppression **appliquée** (JSON de zone + entrée idx + `Data/Script/halcyon/zone/backup_master_zone/`). Les fichiers de cartes restent sur le disque.
3. **Zones hors périmètre, volontairement non touchées** : `normal_maze` (vivant — dojo Ledian ch2), `beginner_lesson` (tutoriel), tout le pack amont Halcyon/PMDO (`*_maze`, `imbion_*`, `eaux_inexplorees` 33 segs, etc.), et les donjons post-jeu du projet `new_era_sky_*` / `new_era_zone_*` (déjà conformes : Route seule ou Route + arène chargée `veilleur_*` — Boss optionnel respecté).

## Correctif embarqué : idx périmé des ch6-9 (classe L15)

Les entrées `index.idx` des 4 zones migrées étaient des vestiges d'anciens découpages (ex. cloven_ruins : 15 étages/5 segments déclarés vs 20/7 réels ; grounds incomplets). **Régénérées intégralement** (Grounds + Maps + paramètres zone) lors de la migration. vast_steppe / searing_tunnel / mount_windswept : idx vérifié **déjà cohérent** (rien à faire).

## Auto-questionnement (réponses après migration)

- Chaque donjon migré est-il décrit par Route / Boss / (Mini-boss), sans superflu ? **Oui** pour les 4 migrés ; vast/steppe→searing/mount/gloomy documentés avec lot de retrait prêt.
- Relais intégrés à la Route ? **Oui** (LayeredSegment médian par construction).
- Zone de Mini-boss uniquement si justifiée ? **Oui** ; aucune créée artificiellement (crooked sans mini-boss = preuve que la structure est absente si non justifiée).
- Organisation native Zone/Segment/Floor respectée ? **Oui** — aucune structure parallèle ajoutée, seules des suppressions de segments morts.
- Comparaison avec Crooked Cavern ? **Oui** — les 4 donjons migrés correspondent désormais au même schéma (Route procédurale segmentée + points fixes manuels chargés + arène Boss finale).

## Réserve

Audit et migration **statiques** (aucun test en jeu ici). Les 4 zones migrées sont des ch6-9 non encore validées en jeu : le test joueur de chaque chapitre confirmera. Avant tout retrait différé (vast_steppe, searing_tunnel, mount_windswept, gloomy_forest), retest en jeu obligatoire du chapitre concerné.
