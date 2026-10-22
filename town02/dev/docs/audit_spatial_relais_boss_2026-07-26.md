# Audit spatial — Relais & Grounds de boss (directive §11)

Date : 2026-07-26
Périmètre : tous les grounds de **relais/checkpoint** (priorité chapitre 5) et tous les grounds de **boss**, toutes sources confondues.
Référence méthode : PMDO Tutorial — Lesson 7 (Boss Battle), placement des entités et triggers.
Outil : `tools/fix_grounds_entities.py` + `tools/fix_ch7_ch10_flow.py` (vérification `is_cell_walkable` par entité, flood-fill de connexité depuis le marker d'entrée, contrôle des bornes de carte).

## Problème racine identifié

Le patron fonctionnel du projet est `searing_tunnel_midpoint` : spawners **nommés** `TEAMMATE_1..3` avec collider positionné, objets `North_Exit`/`South_Exit` en `triggerType=2` (Touch) et `Kangaskhan_Rock` en `triggerType=1` (Action) avec animation.

Plusieurs cartes construites ensuite (relais ch5, cartes ch7-10) avaient :
- des **spawners vides** (sans `EntName`, sans position) → `COMMON.RespawnAllies(true)` ne trouve pas `TEAMMATE_x`, **les équipiers n'apparaissent pas** ;
- des triggers en `triggerType=0` (**inactifs**) → sorties et rocher Kangourex morts ;
- des entités **hors bornes** (rocher à `Y=-64` sur les entrées ch8-10) ou **hors zone walkable** ;
- des positions de cinématique héritées d'une carte plus grande (ex. `TeleportTo(240,380)` sur une carte de 240×320 px).

## Rapports §11.3 par ground (après correction)

| Ground | Dimensions | Entités sur cellules walkables | Connexité entrée | Verdict |
|---|---|---|---|---|
| vast_steppe_midpoint | 240×320 (8px) | 3 spawners nommés + 2 sorties + rocher : oui | oui | **OK — corrigé** (spawners vides → nommés ; triggers 0 → 2/1 ; cutscene recalée 160/128,264→(…,216)) |
| searing_tunnel_midpoint | 456×456 (24px) | oui (modèle canonique) | oui | OK (inchangé) |
| mount_windswept_midpoint | 240×320 (8px) | oui | oui | **OK — corrigé** (idem vast_steppe_midpoint) |
| vast_steppe_miniboss | 368×528 | oui | oui | OK (inchangé) |
| vast_steppe_guardian | 368×528 | oui | oui | OK (inchangé) |
| searing_tunnel_miniboss | 416×544 | oui | oui | **OK — corrigé** (TEAMMATE_3 (304,472) était dans un mur → (272,472)) |
| mount_windswept_miniboss | 384×528 | oui | oui | OK (inchangé) |
| mount_windswept_guardian | 528×624 (24px) | oui | oui | OK (inchangé) |
| searing_crucible | 504×504 (24px) | oui | oui | OK (inchangé) |
| gloomy_forest_midpoint | 352×416 | oui | oui | OK (inchangé) |
| crooked_cavern_midpoint | 352×416 | oui | oui | OK (inchangé) |
| gloomy_forest_boss | 600×600 | oui | oui | OK (inchangé) |
| cloven_ruins_entrance | 240×320 | oui | oui | **OK — corrigé** (triggers 0 → 2/1, spawners vides → nommés) |
| cloven_ruins_midpoint | 240×320 | oui | oui | **OK — corrigé** (spawners + triggers + script `init.lua` créé + zone JSON/GroundMaps) |
| cloven_ruins_boss | 240×320 | oui | oui | **OK — corrigé** (spawners ; cinématique : héros/partenaire (152,240)/(120,240), Regigigas (144,128) — trajets simulés cellule par cellule, aucun mur traversé) |
| celestial_peak_relay | 240×320 | oui | oui | **OK — corrigé** (marker « Kangaskhan_Statue » dans un mur supprimé → vrai rocher + sorties + spawners ; réutilisation post-Fulgur segment 4) |
| celestial_peak_fulgur | 240×320 | oui | oui | **OK — corrigé** (spawners ajoutés ; positions Fulgur (120/156/192,140) vérifiées walkables) |
| celestial_peak_boss | 240×320 | oui | oui | **OK — corrigé** (spawners ; Lugia (156,100→140) vérifié walkable) |
| crystal_sanctuary_relay | 240×320 | oui | oui | **OK — corrigé** (idem celestial_peak_relay) |
| crystal_sanctuary_boss | 240×320 | oui | oui | **OK — corrigé** (spawners ; Diancie (156,140) walkable) |
| forgotten_marsh_relay | 240×320 | oui | oui | **OK — corrigé** (idem) |
| forgotten_marsh_boss | 240×320 | oui | oui | **OK — corrigé** (spawners ; Laggron (156,140) walkable) |
| crystal_sanctuary_entrance | 240×320 | oui | oui | **RECONSTRUITE** (ancienne : 144×192 px, grille obstacles 4 blocs au mauvais format, rocher à Y=-64 hors carte ; crop réel de `first_core_location`, bords scellés) |
| forgotten_marsh_entrance | 240×320 | oui | oui | **RECONSTRUITE** (idem ; crop réel d'`altere_pond`) |
| celestial_peak_entrance | 240×320 | oui | oui | **RECONSTRUITE** (idem ; crop réel de `mount_windswept_entrance`) |

Résultat du contrôle automatique final : **21/21 grounds relais+boss = OK, 0 problème restant** (spawners nommés, walkables, connectés à l'entrée ; objets atteignables ; aucune entité hors bornes).

## Corrections de flux associées (bloquantes en jeu)

1. `zone/celestial_peak/init.lua` : `end GAME:EnterGroundMap(...)` orphelin → **erreur de syntaxe Lua** qui aurait crashé toute la zone. Corrigé (loadfile OK).
2. `metano_town/init.lua` : `cloven_ruins` absent du menu de destinations ; mappings d'entrée ch8-10 pointaient sur `gloomy_forest_boss`/`testmap`/`test_grounds` (52/53/54) → repointés sur les vraies entrées (68/69/70) après ajout des 10 grounds manquants à `master_zone.json`.
3. `master_zone.json` : 10 grounds ch8-10 ajoutés (index 68-77) — ils n'étaient pas déclarés du tout.
4. `Data/Zone/index.idx` : résumés `crystal_sanctuary`, `forgotten_marsh`, `celestial_peak` créés (absents) ; `cloven_ruins` complété avec le relais ; `master_zone.Grounds` synchronisé.
5. Cartes de combat manquantes créées sur le modèle validé `cloven_ruins_boss/relay` : `crystal_sanctuary_relay/boss`, `forgotten_marsh_relay/boss`, `celestial_peak_relay/fulgur/boss` (7 `.rsmap`). Sans elles, les segments `LoadGen` des zones ch8-10 auraient crashé.
6. `CharacterEssentials.lua` : boss ch8-10 absents de la table `characters` (crash immédiat de chaque cinématique, même bug que celui corrigé pour le ch5) → ajout de `Diancie`, `Swampert` (Laggron), `Lugia`, `Fulgur_Luxray/Lucario/Heliolisk`. Le `Luxray` existant (PNJ « Rulux ») n'est pas réutilisé pour éviter une collision d'instance.
7. Scripts ground créés : `cloven_ruins_midpoint`, `crystal_sanctuary_entrance`, `forgotten_marsh_entrance`, `celestial_peak_entrance` ; relais ch8-10 réécrits sur le patron checkpoint complet (Respawn + rocher + 2 sorties).

## Validations exécutées

- `python3 tools/validate_all.py` : ✅ les 5 salles de boss ch5 valides.
- Syntaxe Lua (`loadfile`) sur **tous** les `ground/*/init.lua`, `*_ch_*.lua` et `zone/*/init.lua` : 0 erreur.
- JSON + BOM UTF-8 vérifiés sur les 26 fichiers de données touchés.
- Audit spatial automatique complet (ci-dessus) : 0 problème.
- Test en jeu non réalisable dans cet environnement : à faire au prochain lancement (checklist : relais ch5 ×3, relais/boss ch7, entrées+relais+boss ch8-10).
