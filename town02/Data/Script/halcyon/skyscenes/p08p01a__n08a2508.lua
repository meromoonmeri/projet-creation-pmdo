-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P08P01A/n08a2508.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(140, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_P08P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_OH_NO non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 224, 296, Direction.DownRight, "NPC_YAMIRAMI")
  -- SetAnimation(17) [anim idle native]
  local npc_npc_yamirami2 = SkySceneKit.spawn_npc("sableye", 280, 272, Direction.Down, "NPC_YAMIRAMI2")
  -- SetAnimation(17) [anim idle native]
  local npc_npc_yamirami3 = SkySceneKit.spawn_npc("sableye", 336, 296, Direction.DownLeft, "NPC_YAMIRAMI3")
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(10)
  local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 224, 352, Direction.UpRight, "NPC_YAMIRAMI4")
  -- SetAnimation(17) [anim idle native]
  local npc_npc_yamirami5 = SkySceneKit.spawn_npc("sableye", 280, 376, Direction.Up, "NPC_YAMIRAMI5")
  -- SetAnimation(17) [anim idle native]
  local npc_npc_yamirami6 = SkySceneKit.spawn_npc("sableye", 336, 352, Direction.UpLeft, "NPC_YAMIRAMI6")
  -- SetAnimation(17) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:N]Sableye[CR]: Wheh-heh-heh!", french="[CS:N]Ténéfix[CR]: Whé hé hé!", german="[CS:N]Zobiris[CR]: Wähähäh!", italian="[CS:N]Sableye[CR]: Meh-eh-eh!", spanish="[CS:N]Sableye[CR]: ¡Je, je, je!"})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="[CS:Y]Grovyle[CR]![K] You can't fail\nthis time!", french="[CS:Y]Massko[CR]![K] Tu n'as pas droit\nà l'échec cette fois-ci!", german="[CS:Y]Reptain[CR]![K]\nDieses Mal darfst du nicht scheitern!", italian="[CS:Y]Grovyle[CR]![K] Questa volta non puoi\nfallire!", spanish="¡[CS:Y]Grovyle[CR]![K] ¡Esta vez no puedes\nfracasar!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Humph![K] I should say the\nsame thing!", french="Pfff![K] J'en ai autant\nà ton service!", german="Hmpf![K]\nDasselbe könnte ich dir sagen!", italian=" Bah![K] Pensa per te!", spanish=" Hum...[K] ¡Lo mismo digo!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Let's go!", french=" Allons-y!", german=" Auf geht's!", italian=" Andiamo!", spanish=" ¡Vamos!"})
  -- message_Close
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2)
  -- SetAnimation(12) [anim idle native]
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2)
  -- SetAnimation(12) [anim idle native]
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2)
  -- SetAnimation(12) [anim idle native]
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(140, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
