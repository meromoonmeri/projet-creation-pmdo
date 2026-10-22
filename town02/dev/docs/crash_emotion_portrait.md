# Crash `SpeakerPortrait.Draw` — cause racine et correction

**Build `2026-08-03-I`** · **Rien n'a été testé en jeu.**

## Ce que je m'étais trompé à croire

Aux builds F/G/H, j'avais diagnostiqué « Jigglypuff n'a pas de portrait dans
`Content/Portrait/` du mod ». J'avais construit un contournement (`HasPortrait`,
table `PORTRAIT_SUR` de 26 espèces, cache `_portraitOK`) qui, quand il jugeait un
portrait « incertain », affichait **le nom seul sans portrait**.

C'était faux, et tu me l'as dit : **les portraits sont nativement supportés par le
moteur**. `PathMod.cs:378-384` fait retomber le mod sur les assets du jeu de base —
les 34 fichiers de `Content/Portrait/` ne sont qu'une surcharge partielle. Mon
contournement dégradait donc l'affichage de portraits parfaitement fonctionnels.

Le crash avait une tout autre cause.

## La vraie cause, lue dans le moteur

| # | Fichier moteur | Ce qui se passe |
|---|---|---|
| 1 | `Lua/ScriptUI.cs:599` | `SetSpeakerEmotion` résout le nom par `GraphicsManager.Emotions.FindIndex(...)`. **`FindIndex` rend `-1`** si le nom n'existe pas — et ce `-1` est écrit tel quel dans `m_curspeakerEmo.Emote`. Aucun contrôle. |
| 2 | `Content/PortraitSheet.cs:313` | `GetReferencedEmoteIndex` commence par `GraphicsManager.Emotions[type]` avec `type == -1` → `ArgumentOutOfRangeException`. |
| 3 | `SpeakerPortrait.Draw` | L'exception part du **rendu**, donc elle se rejoue **à chaque frame** tant que la boîte de dialogue est affichée. D'où les ~60 lignes/seconde dans ton log. |

Le piège : les noms d'**émotes de bulle** et d'**émotions de portrait** se
ressemblent, et rien dans le moteur ne signale l'erreur avant le crash graphique.

## Les 9 fautifs

Des noms d'émote de bulle passés là où le moteur attend une émotion de portrait :

| Nom invalide | Occurrences | Corrigé en |
|---|---|---|
| `Sweating` | 4 | `Worried` |
| `Shock` | 2 | `Surprised` |
| `Question` | 2 | `Worried` |
| `Shocked` | 2 | `Surprised` |

**6 des 8 premières étaient dans `mount_windswept_entrance_ch_5.lua`** — dont
`HeroDialogue(..., "Question")` que j'ai introduit au build H en convertissant les
boîtes de narration en pensées attribuées. C'est mon changement du tour précédent
qui a déclenché ce crash-ci.

## Correction en trois niveaux

**1. Les 9 noms corrigés** vers des émotions réellement valides.

**2. Le contournement supprimé.** `HasPortrait`, `PORTRAIT_SUR`, `_portraitOK` et le
bloc de commentaire qui décrivait la fausse cause sont retirés. `Speak()` fait
maintenant simplement `UI:SetSpeaker(chara)` : le moteur résout lui-même la feuille
et ses fallbacks. **Les portraits natifs sont rendus à tout le monde.**

**3. Un garde-fou runtime, point d'entrée unique.**
`GeneralFunctions.SetEmotion(emotion)` valide le nom contre
`EMOTIONS_PORTRAIT` ; si le nom est inconnu, il trace dans le log et retombe sur
`"Normal"` — jamais `-1`, donc jamais de crash.

**2 438 appels** `UI:SetSpeakerEmotion` (206 fichiers + 6 helpers internes) ont été
routés vers ce validateur. Il ne reste **qu'un seul** appel moteur direct dans tout
le dépôt : celui du validateur lui-même.

## Nouvel outil : `tools/verify_emotions.py`

Vérification statique de tous les noms littéraux passés à `SetEmotion`,
`HeroDialogue`, `Speak`, `StartConversation` et aux tables `emo =`. Il signale aussi
tout `UI:SetSpeakerEmotion` qui contournerait le garde-fou.

Le rapport nomme le diagnostic : `<- EMOTE DE BULLE, pas une émotion de portrait`.

Testé en non-régression sur les 4 cas fautifs : les 4 sont détectés.
Un faux positif a dû être corrigé en route — le motif `StartConversation` capturait
le *texte* du dialogue quand l'appel n'avait que deux arguments (150 fausses
alertes) ; il exige désormais explicitement trois arguments.

**Résultat sur le dépôt : `AUCUN RISQUE DE CRASH DE PORTRAIT`.**

Limite assumée : les émotions passées par variable calculée ne sont pas résolues
statiquement — c'est exactement le rôle du garde-fou runtime.

## Baselines

| Contrôle | Valeur |
|---|---|
| `audit_bugs.py` | 12 (inchangé) |
| `audit_integrite.py` | 849 (inchangé) |
| `count_dialogue.py` ch5 | 1612 (inchangé) |
| Compilation Lua | 670 fichiers, 0 erreur |
| `verify_emotions.py` | **0 risque** |

Verts : `verify_scene_positions`, `verify_lua_globals`, `verify_cutscene_guard`,
`verify_spawner_enabled`, `verify_legend`.
