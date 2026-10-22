# Classification fonctionnelle → pipeline PMDO (contrat)

Chaque catégorie de `GROUND_CLASSIFICATION.json` (déterminée par preuves ROM :
mapty arm9 × structure SCRIPT/ × collision BMA × xrefs SSB — jamais le nom de
fichier) impose son PROPRE pipeline PMDO et son PROPRE test runtime. Aucune
catégorie ne doit être forcée dans le pipeline d'une autre.

| Catégorie (n) | Pipeline PMDO | Test runtime exigé | État |
|---|---|---|---|
| MAP (95) | `.rsground` + zone conteneur (`sky_hub_zone`) ; NPC/events/transitions à porter par chapitre | LOAD + MOVEMENT (fait 95/95) puis NPC/INTERACTION/EVENT/TRANSITION (à venir par journey) | 95/95 LOAD+MOVE |
| BOSS_ARENA_FIXED (17) | `.rsmap` LoadGen/MappedRoomStep depuis fixed.bin (géométrie+positions+boss exacts) — JAMAIS une génération procédurale | zone chargée + espèces fixed.bin dans MapTeams + BattlePositionEvent (fait 9 arènes histoire) | 9 construites |
| CINEMATIC_GROUND (26) | décor de scènes compilées/artisanales (`skyscenes/`) ; PAS ajouté aux zones libres | scène rejouée : positions/dialogues/timing (16 compilées + pilote PASS) | partiel |
| CINEMATIC_BACKGROUND (213) | background PMDO (`Background`/`BGMovement` du rsmap ou image de scène) ; statique OU défilant selon le script — JAMAIS converti en map explorable | affichage + mouvement si scrolling (pilote à faire) | à faire |
| DUNGEON_SCREEN (62) | rattaché au système de donjon (intermèdes/transitions pré-post donjon) ; PAS une map libre | transition affichée au bon moment du journey | à faire |
| SCRIPTED_SCREEN (24) | écran scripté entrable sans collision (menus de lieux, écrans spéciaux) | script d'écran exécuté | à faire |
| VARIANT | alias d'état du même lieu (heure/évènement) — pas de doublon d'implémentation | même tests que la base | suit la base |
| REVIEW_REQUIRED (22) | donnée dormante ROM (level jamais scripté ni référencé) — AUCUN portage tant que le rôle n'est pas prouvé | — | documenté |

Règles :
1. Un render correct n'est jamais une preuve de gameplay.
2. Changer la catégorie d'une ressource exige une preuve ROM nouvelle.
3. L'audit doit signaler HIGH toute ressource utilisée hors de son pipeline
   (ex. background porté comme map, arène convertie en donjon procédural).
