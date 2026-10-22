# Cinematic Choreography Translation Guide (GBA -> PMDO)

Ce document établit la traduction stricte et émotionnelle de l'assembleur GBA vers l'API Lua de RogueEssence.
L'objectif est de transposer **le rythme, les silences, et la mise en scène**, pas seulement d'exécuter des commandes.

## 1. Mouvements de Caméra
| PMD Red Macro | RogueEssence Lua API | Interprétation Chorégraphique |
| :--- | :--- | :--- |
| `CAMERA_INIT_PAN()` | `GAME:MoveCamera(TargetX, TargetY, Speed)` | Définit le point d'ancrage. Souvent utilisé après un écran noir pour ouvrir une scène (FadeIn). |
| `CAMERA_PAN(direction, speed)` | `GAME:MoveCamera(...)` | Scrolling. Dans la GBA, un scrolling lent traduit la grandeur ou la tension (ex: l'ascension de la Tour). |
| `CAMERA_END_PAN()` | `GAME:MoveCamera(HeroX, HeroY, Speed)` | Retour brutal ou doux sur l'équipe. |

## 2. Effets Visuels (Le Climax)
| PMD Red Macro | RogueEssence Lua API | Interprétation Chorégraphique |
| :--- | :--- | :--- |
| `FLASH_TO(TRUE, PAL_05, 8, WHITE)` | `GAME:FadeOut(true, 8)` | Coupure violente. Utilisé pour les impacts (Météorite, Ultralaser). Éblouissement du joueur. |
| `FLASH_FROM(FALSE, PAL_05, 16, WHITE)` | `GAME:FadeIn(16)` | Retour progressif à la réalité après un impact. |
| `CALL_SCRIPT(SHOCK_FUNC)` | `SOUND:PlayBattleSE('EVT_Roar') \n GAME:WaitFrames(X)` | Tremblement de terre. Doit toujours être accompagné d'un silence musical ou d'un SFX lourd dans PMDO. |

## 3. Rythme et Audio
| PMD Red Macro | RogueEssence Lua API | Interprétation Chorégraphique |
| :--- | :--- | :--- |
| `BGM_FADEOUT(120)` | `GAME:FadeOutBGM(120)` | Fait monter la tension. Crée une anticipation avant un dialogue clé ou une apparition de boss. |
| `BGM_STOP` | `GAME:FadeOutBGM(X) \n GAME:WaitFrames(Y)` | Le silence absolu. Utilisé spécifiquement avant l'arrivée de Rayquaza ou après une révélation. À respecter scrupuleusement. |
| `BGM_SWITCH(Track)` | `GAME:PlayBGM(Track, true)` | L'explosion sonore. Doit être synchronisée à la frame près avec l'animation (ex: atterrissage d'un boss). |

## 4. Animations Acteurs
| PMD Red Macro | RogueEssence Lua API | Interprétation Chorégraphique |
| :--- | :--- | :--- |
| `SELECT_ANIMATION(AnimId)` | `GROUND:CharSetAction(...)` | La GBA utilise des index. Le convertisseur doit mapper vers `RogueEssence.Ground.Animations` (ex: `PoseAction`, `HopAction`, `AttackAction`). |
