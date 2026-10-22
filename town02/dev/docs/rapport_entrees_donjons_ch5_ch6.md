# Refonte des entrées de donjons — chapitres 5 et 6

Date : 25 juillet 2026

## État des entrées

| Donjon | Ground Map | Introduction | Transition | État |
|---|---|---|---|---|
| Grande Steppe | `vast_steppe_entrance` | arrivée de l’expédition, préparation et découverte de la plaine | `Dungeon_Entrance_Touch` → `EnterDungeon` | existante, auditée |
| Tunnel Incandescent | `searing_tunnel_entrance` | arrivée nocturne, chaleur, préparation de l’équipe | `Dungeon_Entrance_Touch` → `EnterDungeon` | existante, auditée |
| Profondeurs du Tunnel | `searing_tunnel_midpoint` | point médian et décision de continuer | transition du segment 0 vers le segment 1 | existante, auditée |
| Crucible Incandescent | `searing_crucible` | arrivée dans l’arène et mise en place du boss | entrée du segment 2 | existante, auditée |
| Mont Venteux | `mount_windswept_entrance` | arrivée au camp, inquiétude de Penticus et préparation | `Dungeon_Entrance_Touch` → `EnterDungeon` | existante, auditée |
| Forêt Lugubre | `gloomy_forest_entrance` | ruines forestières, ombres, avertissement de Papilusion, formation de l’équipe et dernier temps calme | `Dungeon_Entrance_Touch` → `EnterDungeon` | ajoutée au chapitre 6, scène développée |

Le Tunnel conserve 15 étages normaux + l’arène. Les maps `searing_tunnel_midpoint` et `searing_crucible` ne sont pas des téléportations silencieuses : elles sont déjà des étapes narratives de la progression du Tunnel.

## Systèmes utilisés

Les entrées utilisent uniquement les conventions déjà présentes :

- `PlotScripting` appelé par `Enter` et `GameLoad` ;
- flags `SV.Chapter5`/`SV.Chapter6` pour empêcher la répétition ;
- `GAME:CutsceneMode` ;
- `GAME:MoveCamera` ;
- `GAME:FadeIn` / `GAME:FadeOut` ;
- `GROUND:MoveToPosition` ;
- `GROUND:CharAnimateTurnTo` ;
- `GROUND:CharSetEmote` ;
- `TASK:BranchCoroutine` et `TASK:JoinCoroutines` ;
- `UI:SetSpeaker`, `UI:SetSpeakerEmotion`, `UI:WaitShowDialogue` ;
- `SOUND:PlayBGM` et `SOUND:FadeOutBGM` ;
- `GAME:EnterDungeon` après l’entrée extérieure.

## Assets réutilisés

La nouvelle Ground Map de la Forêt Lugubre réutilise la structure de `relic_forest.rsground` : ruines, sol, couches et décorations déjà présents dans le projet. Elle utilise `Mystifying Forest.ogg`, déjà présent dans `Content/Music`.

Aucun DTEF externe n’est injecté directement dans le mod. Le DTEF reste pertinent pour une future création de tileset, mais il serait incorrect de prétendre qu’un nouveau tileset DTEF a été importé sans passage par le pipeline PMDO et vérification dans l’éditeur.

Pour le boss Zarude, l’OST fournie par la production — `060 - Battle against Dusknoir - Pokémon Mystery Dungeon: Explorers of Sky` — reste une référence humaine. Elle n’est ni téléchargée ni convertie. En attendant l’intégration légitime du fichier, l’arène utilise `Boss Battle!.ogg`, déjà présent dans le projet.

## Tests obligatoires

### Tests de flux

- [ ] entrée en ville puis arrivée sur chaque Ground Map ;
- [ ] aucune entrée ne lance immédiatement le premier étage ;
- [ ] chaque scène se joue une seule fois ;
- [ ] `GameLoad` ne duplique pas les personnages temporaires ;
- [ ] le fondu final ne produit pas d’écran noir ;
- [ ] le bouton/objet d’entrée reste utilisable après la scène ;
- [ ] l’entrée fonctionne après un échec précédent ;
- [ ] la sauvegarde/reprise conserve les flags.

### Tests par donjon

- [ ] Grande Steppe : entrée, cinématique, premier étage ;
- [ ] Tunnel : entrée, nuit, premier étage ;
- [ ] Tunnel : point médian, retour après défaite, reprise ;
- [ ] Crucible : transition vers l’arène et retour ;
- [ ] Mont Venteux : arrivée, camp, premier étage ;
- [ ] Forêt Lugubre : arrivée sur la nouvelle map, cinématique, premier étage ;
- [ ] Forêt Lugubre : 18 étages normaux ;
- [ ] Forêt Lugubre : 3 étages de profondeur ;
- [ ] Forêt Lugubre : Chenipent au 18e étage ;
- [ ] Forêt Lugubre : apparition unique de Zarude ;
- [ ] Forêt Lugubre : double flash blanc et lancement du combat boss ;
- [ ] Forêt Lugubre : sortie après victoire/défaite du boss.

### Validation statique

- [ ] tous les `.lua` parsés ;
- [ ] tous les `.json` et `.rsground` parsés ;
- [ ] tous les `.resx` parsés ;
- [ ] aucun nom de musique absent appelé ;
- [ ] chaque `EnterDungeon` est précédé par une Ground Map dédiée ;
- [ ] chaque `Dungeon_Entrance_Touch` possède un script ;
- [ ] chaque intro utilise des émotions déjà utilisées dans le projet.

## Limites honnêtes

PMDO n’est pas lancé dans l’environnement actuel. Les positions, collisions de la nouvelle Ground Map et rendu final doivent donc être contrôlés dans l’éditeur/jeu. La validation statique ne permet pas de garantir la qualité visuelle finale ni la réussite d’un déplacement sur chaque tuile.
