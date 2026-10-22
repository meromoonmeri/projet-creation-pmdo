# Réseau des Anciens Chemins — Veilleurs, rôles et dialogues (2026-07-27)

## Lore d'intégration (« tout est logique et propre à New Era »)

Le Réseau des Anciens Chemins est l'infrastructure laissée par les bâtisseurs
d'avant le Calme — le même peuple qui a scellé les Ancrages. Quand le réseau
d'Ancrages s'éveille (fin du ch10 / Livre II), les vieilles voies se rallument
une à une : le Terminal de Sauvegarde de chaque Station se remet à ronronner.
Chaque voie majeure est gardée par un **Veilleur** : pas un légendaire — un
Pokémon ordinaire que les bâtisseurs ont chargé, il y a des siècles, de tenir
la porte « jusqu'à ce que quelqu'un ait une bonne raison de passer ». Les
Veilleurs testent, comme les gardiens d'Ancrage — l'écho est voulu : petits
gardiens pour les voies, grands gardiens pour les failles.

## A. 12 donjons « histoire du Réseau » (boss Veilleur + dialogues FR)

| Zone | Donjon | Ét. | Veilleur (niv) | Titre du Veilleur |
|---|---|---|---|---|
| new_era_zone_02 | Pylône du Vieux Fer | 10+arène | Rempart (bastiodon 12) | Veilleur de la voie |
| new_era_zone_05 | Antenne du Grand Orage | 11+4+arène | Câble-Vif (eelektross 18) | Veilleur de la voie |
| new_era_zone_09 | Cheminée du Réacteur Rouge | 13+4+arène | Fusible (magmortar 24) | Veilleur de la voie |
| new_era_zone_11 | Forêt du Givre Statique | 10+6+arène | Blizzard-Sentinelle (abomasnow 26) | Veilleur de la voie |
| new_era_zone_13 | Aiguille du Zéro Absolu | 16+6+arène | Voile-Blanc (froslass 28) + Masque-Gel (glalie 28) | Veilleur de la voie |
| new_era_zone_15 | Cœur de la Fournaise-Mère | 24+4+arène | Soleil-de-Cendre (volcarona 32) | Veilleur de la voie |
| new_era_zone_17 | Tour du Ciel Fracturé | 26+10+arène | Déchire-Nuages (salamence 36) | Veilleur de la voie |
| new_era_zone_19 | Mer des Tempêtes Sans Fin | 41+arène | Lame-de-Fond (gyarados 40) | Veilleur de la voie |
| new_era_zone_20 | Fosse d'Argent Abyssale | 100+arène | Lanterne-Noyée (jellicent 49) + Ancre-Morte (dhelmise 49) | Veilleur de la voie |
| new_era_zone_23 | Caverne du Silence Occidental | 100+arène | Portier-du-Vide (dusknoir 54) | Veilleur de la voie |
| new_era_zone_27 | Relique Ensevelie | 100+arène | Golem-Registre (golurk 50) | Veilleur de la voie |
| new_era_zone_32 | Caverne du Méridien Sud | 51+arène | Mâchoire-du-Sud (krookodile 46) | Veilleur de la voie |

Chaque victoire pose `SV.Reseau.Veilleurs[zone]` (compteur end-game, prêt pour
une récompense « toutes les voies rouvertes »). Dialogues victoire/défaite en
français dans chaque `ExitSegment` — exemples :
- Pylône du Vieux Fer : « Le Rempart s'incline... le Pylône du Vieux Fer nous
  reconnaît. »
- Caverne du Silence Occidental : « Le Portier-du-Vide s'écarte. Étrange...
  il semblait presque nous ATTENDRE. » (foreshadowing Mewtwo ch21 — le Portier
  garde l'antichambre de la Forteresse Abandonnée.)
- Fosse d'Argent : duo Lanterne-Noyée/Ancre-Morte (91 étages + arène, le vrai
  gauntlet 100 étages d'origine).

## B. 22 donjons secondaires end-game (job board)

Lisière du Premier Signal, Conduit à Ondes Rémanentes, Taillis des
Interférences, Faille du Silence Long, Canyon des Voix Éteintes, Veine d'Azur
Profond, Berceau du Météore, Puits des Vœux Fossiles, Vallée des Chutes
Perdues, Crêtes de la Boussole Nord, Région des Sables Morts, Colline des
Vouivres, Champ de Cendres Vives, Champ du Vent Polaire, Grotte du Soleil
Enfoui, Champ des Cent Éclairs, Relique de la Nuit Noire, Mer des Prodiges,
Boyau des Eaux Troubles, Grand Large Oublié, Forêt du Vacarme, Grotte des
Anomalies. Tous au job board (difficulté S/STAR_1, niveaux 5→50).

## C. Restrictions fidèles à l'original (natif moteur)

- **Puits des Vœux Fossiles** (Wish Cave) : **reset niveau 5, sac vide,
  équipe de 2** — comme l'original, via LevelCap/BagRestrict/TeamSize de la
  Zone (gérés nativement par le moteur PMDC, zéro script custom).
- Les champs légendaires (Cendres Vives, Vent Polaire, Cent Éclairs, Fosse
  d'Argent…) restent des voies : leurs GARDIENS légendaires sont ceux des
  donjons-Ancrages ch11-32 — le Réseau est le tissu conjonctif, les Ancrages
  sont les cœurs. Aucun doublon de légendaire.

## D. Où sont les dialogues/cinématiques

- Victoire/défaite Veilleurs : `Data/Script/halcyon/zone/new_era_zone_XX/init.lua`
- Stations-Relais : choix Nord/Sud + Terminal de Sauvegarde (Kangourex natif)
- Les cinématiques d'entrée complètes (PNJ, mise en scène 3 couches) suivront
  le rythme de production dialogues (campagne 7000 lignes/chapitre) — les
  crochets sont posés.
