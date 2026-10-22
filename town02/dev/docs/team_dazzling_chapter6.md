# Team Dazzling — audit, chapitre 6 et feuille de route

Date : 25 juillet 2026
Projet : `New Era : Abyss to Ascension` — dépôt V2 uniquement

## 1. Résultat de l’analyse préalable

### Conflit « Lockpin »

Le conflit est résolu sans créer de doublon :

- dans les données françaises de PMDODump, **Lopunny porte déjà le nom français Lockpin** ;
- le projet ne contient actuellement aucune entrée de personnage, de sprite de terrain ou de variable appelée `Lockpin` ;
- la Team Dazzling utilise donc le codename **Aria** pour ce personnage ;
- `Lockpin` reste le nom français de l’espèce Lopunny, pas un second personnage.

Référence vérifiée : `Data/Monster/lopunny.json` dans DumpAsset/PMDODump, index national 428.

### Assets vérifiés dans DumpAsset

Les fichiers suivants existent dans la base d’assets PMDO :

| Personnage | Espèce | Index | Sprite | Portrait |
|---|---|---:|---|---|
| Adagio | Tsareena / Sucreine | 763 | `Content/Chara/763.chara` | `Content/Portrait/763.portrait` |
| Aria | Lopunny / Lockpin | 428 | `Content/Chara/428.chara` | `Content/Portrait/428.portrait` |
| Sonata | Mismagius / Magirêve | 429 | `Content/Chara/429.chara` | `Content/Portrait/429.portrait` |
| Papilusion | Butterfree / Papilusion | 12 | présent dans la base PMDO | présent dans la base PMDO |
| Chenipent | Venipede / Venipede | 543 | présent dans la base PMDO | présent dans la base PMDO |

Les trois Pokémon de la Team ont leurs données de talents et de capacités dans DumpAsset. Aucun fichier de sprite ou de portrait n’est copié dans le mod : ces ressources appartiennent à la base PMDO.

### Capacités et talents vérifiés

Pour rester dans la plage de niveaux demandée, les premières équipes de combat pourront utiliser uniquement les capacités apprises au plus tard au niveau 42 :

- **Adagio — Tsareena**, niveau initial proposé : 38–39 ; talents disponibles : `leaf_guard`, `queenly_majesty`, `sweet_veil` ; capacités utilisables : `trop_kick`, `magical_leaf`, `stomp`, `aromatic_mist`, `captivate`.
- **Aria — Lopunny**, niveau initial proposé : 34–35 ; talents disponibles : `cute_charm`, `klutz`, `limber` ; capacités utilisables : `return`, `quick_attack`, `jump_kick`, `baton_pass`, `agility`.
- **Sonata — Mismagius**, niveau initial proposé : 32–33 ; talent disponible : `levitate` ; capacités utilisables : `mystical_fire`, `power_gem`, `phantom_force`, `lucky_chant`, `magical_leaf`, `psywave`, `spite`, `astonish`.

Les fichiers de capacités correspondants existent dans `Data/Skill` de DumpAsset. Aucun kit de combat n’est encore attribué aux personnages de terrain de l’introduction : la première scène est sociale et ne doit pas se transformer en combat.

### Émotions réellement utilisées

Le projet utilise déjà les émotions suivantes dans ses scripts : `Normal`, `Happy`, `Worried`, `Angry`, `Determined`, `Surprised`, `Sigh`, `Inspired`, `Pain`, `Sad` et d’autres émotions standard PMDO.

L’introduction n’utilise que :

- `Normal` ;
- `Happy` ;
- `Worried` ;
- `Angry` ;
- `Determined` ;
- `Surprised` ;
- `Sigh`.

Les effets d’émote utilisés sont les effets déjà employés dans le projet : `happy` et `angry` via `GROUND:CharSetEmote`/`GeneralFunctions.EmoteAndPause`.

## 2. Conventions reprises du projet

L’implémentation reprend directement les structures suivantes :

| Fonction | Exemple existant | Réutilisation chapitre 6 |
|---|---|---|
| Déclencheur temporaire | `metano_town_ch_4.SetupGround()` | zone invisible `Event_Trigger_9` au centre du village |
| Dispatch par chapitre | `metano_town/init.lua` | `metano_town_ch_6` chargé uniquement lorsque `Chapter == 6` |
| Cinématique de terrain | `metano_town_ch_4.SignpostIntroductionCutscene()` | déplacements parallèles, caméra et `CutsceneMode` |
| Groupe de PNJ | `metano_town_ch_5.SetupGround()` | trois personnages en `ground_talking` |
| Dialogue localisé | `STRINGS.MapStrings` et `.resx` | clés `MT6_001` à `MT6_035` |
| Cible de mission | `event_mapgen.lua` et `BattleScriptEvent` | Chenipent placé par `PlaceEntranceMobsStep` au dernier étage |
| Sortie de donjon | `GeneralFunctions.EndDungeonRun` | retour vers Metano Town avec résultat moteur explicite |

## 3. Première apparition implémentée

### Déclenchement

La scène est attachée à un objet temporaire `Event_Trigger_9` créé dans la zone centrale de Metano Town. Elle n’est créée que lorsque :

```lua
SV.ChapterProgression.Chapter == 6
```

et que :

```lua
SV.Chapter6.DazzlingIntroPlayed == false
```

Le joueur peut donc reprendre le contrôle et parcourir librement le village. La scène ne se lance pas au chargement de la carte.

### Personnages

Les entrées ajoutées à `CharacterEssentials.lua` sont :

- `Adagio` → Tsareena, femelle ;
- `Aria` → Lopunny, femelle ;
- `Sonata` → Mismagius, femelle ;
- `Butterfree` → Papilusion, femelle ;
- `Venipede` → Chenipent, genre inconnu.

### Commandes utilisées

- `GAME:CutsceneMode(true/false)` ;
- `GAME:MoveCamera` ;
- `GROUND:MoveToPosition` ;
- `GROUND:CharAnimateTurnTo` ;
- `GROUND:CharSetEmote` ;
- `TASK:BranchCoroutine` ;
- `TASK:JoinCoroutines` ;
- `UI:SetSpeaker` ;
- `UI:SetSpeakerEmotion` ;
- `UI:WaitShowDialogue` ;
- `GeneralFunctions.EmoteAndPause` ;
- `AI:DisableCharacterAI` et `AI:SetCharacterAI`.

### Caméra, mouvements et transitions

- la caméra se centre sur le carrefour central ;
- Papilusion s’avance vers le héros ;
- les trois membres de la Team Dazzling entrent successivement depuis le côté droit ;
- le héros et le partenaire se rapprochent sans téléportation pendant l’introduction ;
- la scène se termine sans écran noir et rend le contrôle au joueur ;
- le partenaire récupère son IA `origin.ai.ground_partner`.

### Sons et musique

Aucun fichier audio Team Dazzling n’est inventé, téléchargé ou ajouté. La scène conserve la musique actuelle de Metano Town.

Les trois liens fournis par la production restent des références d’intégration pour le compositeur :

- thème social : `tvSlzzXpZEQ` ;
- thème combat : `dPPZbBXetMU` ;
- thème final : `OdOZG_tLVoc`.

Le code ne joue pas un nom de fichier inexistant. Lorsque les fichiers seront intégrés au projet, les changements pourront reprendre exactement le système déjà présent : `SOUND:FadeOutBGM(...)`, puis `SOUND:PlayBGM(...)`.

## 4. Dialogue de la première scène

Le rythme suit le format du projet, mais la scène est maintenant une vraie séquence de terrain : **56 clés de dialogue**, arrivée en plusieurs temps, réactions de la foule, déplacements parallèles, interruption d’Aria, farce de Sonata, silence d’Adagio et sortie du trio.

- Papilusion demande de l’aide pour Chenipent.
- Adagio refuse calmement au nom des missions prioritaires.
- Aria transforme l’idéalisme du partenaire en provocation.
- Sonata nie toute responsabilité avec son innocence apparente.
- Le partenaire s’indigne.
- Le héros accepte la mission.
- Adagio conclut avec une remarque piquante : « Tu fais de ton mieux ? C’est adorable. »
- La Team Dazzling donne son nom officiel et repart sans combat.

Le nom utilisé dans les dialogues est toujours **Team Dazzling**. « Les Trois Reines » n’est pas utilisé.

## 5. Mission Forêt Lugubre

Une nouvelle zone `gloomy_forest` et une Ground Map `gloomy_forest_entrance` sont créées à partir des ressources forestières déjà présentes dans `relic_forest` :

- 18 étages normaux ;
- 3 étages de profondeur ;
- une arène de boss dédiée pour Zarude ;
- Zarude niveau 42, capacités vérifiées `fury_swipes`, `scary_face`, `grass_knot`, `bite` et talent `leaf_guard` ;
- apparition unique sur une Ground Map avant le duel ;
- double flash blanc et `COMMON.BossTransition()` avant le lancement du combat ;
- génération procédurale PMDO existante ;
- Ground Map extérieure avec ruines forestières réutilisées ;
- musique existante `Mystifying Forest.ogg` ;
- aucune nouvelle commande de génération ;
- aucun téléchargement d’asset externe ;
- nom français : **Forêt Lugubre** ;
- script de zone et script d’entrée séparés ;
- sortie explicite pour victoire, défaite, fuite et secours.

Au 18e étage normal, `SpawnChapter6Chenipent` réutilise :

- `SpecificTeamSpawner` ;
- `MobSpawn` ;
- `MobSpawnInteractable` ;
- `BattleScriptEvent` ;
- `PlaceEntranceMobsStep`.

L’événement `TeamDazzlingChenipentRescue` marque `SV.Chapter6.ChenipentFound` après interaction. La victoire du donjon ne valide la mission que si Chenipent a réellement été trouvé.

## 6. Progression de la Team Dazzling jusqu’au chapitre 20

Cette répartition est une proposition narrative à intégrer progressivement, pas une implémentation complète déjà présentée comme terminée.

| Chapitre | Fonction dramatique | Évolution |
|---:|---|---|
| 6 | Première rencontre, mission de Chenipent | Le héros est insignifiant à leurs yeux. |
| 7 | Petite scène au tableau des missions | Aria prend une mission puis la repose pour provoquer le partenaire. |
| 8 | Première compétition non combattue | Adagio remarque que l’équipe progresse plus vite que prévu. |
| 9 | Farce de Sonata sur un objet | Le trio devient familier sans devenir cruel. |
| 10 | Premier défi scénarisé | Première utilisation du thème combat, avec enjeu limité. |
| 11 | Mission menée en parallèle | Elles cessent de sous-estimer complètement le héros. |
| 12 | Aria pousse le partenaire à bout | Le partenaire apprend à répondre sans perdre son calme. |
| 13 | Sonata aide véritablement puis masque son geste par une farce | Première preuve d’attachement indirect. |
| 14 | Adagio corrige une erreur du héros | Respect professionnel encore présenté comme une critique. |
| 15 | Défi d’exploration sérieux | Les niveaux augmentent progressivement, jamais figés à 30–42. |
| 16 | Désaccord interne du trio | Adagio veut prioriser la mission, Aria et Sonata veulent aider. |
| 17 | Alliance ponctuelle | Elles combattent aux côtés du héros sans abandonner leurs piques. |
| 18 | Crise personnelle d’Adagio | Elle explique sa distance sans devenir soudainement douce. |
| 19 | Dernière compétition | Le héros est reconnu comme un égal. |
| 20 | Affrontement final émotionnel | Thème final ; rivalité terminée, personnalités conservées. |

### Progression des niveaux proposée

- chapitre 6 : Adagio 38, Aria 34, Sonata 32 ;
- chapitres 7–10 : +1 à +2 niveaux selon les missions ;
- milieu de jeu : Adagio reste toujours légèrement au-dessus ;
- chapitres 15–18 : progression vers 40–42 ;
- chapitre 20 : les niveaux finaux dépendront de l’équilibrage réel des donjons, sans recopier un niveau fixe sur toutes les apparitions.

## 7. Checklist de tests

### Déclenchement

- [ ] le chapitre 5 ne déclenche aucune scène Team Dazzling ;
- [ ] le chapitre 6 ne lance pas la scène au chargement de Metano Town ;
- [ ] le joueur peut quitter la place sans déclencher la scène ;
- [ ] `Event_Trigger_9` ne réapparaît pas après l’introduction ;
- [ ] une sauvegarde/reprise pendant ou après la scène ne la duplique pas.

### Assets

- [ ] silhouettes Tsareena, Lopunny et Mismagius visibles ;
- [ ] portraits 763, 428 et 429 chargés ;
- [ ] Papilusion et Chenipent chargés ;
- [ ] aucune référence à `char_lopunny` ajoutée ;
- [ ] émotions `Normal`, `Happy`, `Worried`, `Angry`, `Determined`, `Surprised`, `Sigh` vérifiées en jeu.

### Mission

- [ ] Forêt Lugubre apparaît dans l’index des zones ;
- [ ] cinq étages générés ;
- [ ] Chenipent apparaît au dernier étage ;
- [ ] interaction de sauvetage exécutée une seule fois ;
- [ ] victoire sans Chenipent ne valide pas la mission ;
- [ ] victoire avec Chenipent valide la mission ;
- [ ] fuite, K.O., défaite et secours retournent vers une transition valide ;
- [ ] la scène de remerciement n’apparaît qu’après une mission réussie.

### Musique

- [ ] aucun fichier audio absent n’est appelé ;
- [ ] la musique actuelle de la ville reste stable pendant l’introduction ;
- [ ] le thème social est ajouté uniquement après intégration humaine du fichier ;
- [ ] le thème combat est réservé aux défis importants ;
- [ ] le thème final n’est utilisé qu’au dernier affrontement.

### Validation technique

- [ ] parse Lua sur tous les scripts ;
- [ ] parse JSON sur toutes les zones ;
- [ ] parse XML sur tous les RESX ;
- [ ] correspondance entre chaque `ScriptGenStep` et une fonction `ZONE_GEN_SCRIPT` ;
- [ ] correspondance entre chaque `BattleScriptEvent` et une fonction `BATTLE_SCRIPT` ;
- [ ] vérification PMDO réelle avec une sauvegarde de test ;
- [ ] test de compatibilité après mise à jour du moteur.

## 8. Point de continuité

La fin canonique est maintenant reliée par un seul point de progression : la victoire sur le sommet du Mont Venteux. `mount_windswept.ExitSegment` pose `SV.Chapter5.FinishedExpedition` puis passe `SV.ChapterProgression.Chapter` à 6 uniquement sur `ResultType.Cleared`.

Aucune scène, aucun dialogue et aucune carte du chapitre 5 n’est modifiée par cette jonction. Une défaite, une fuite ou un secours conserve le chapitre 5 et ne peut pas déclencher Team Dazzling.

Les scènes du chapitre 6 restent protégées par `SV.ChapterProgression.Chapter == 6`.
