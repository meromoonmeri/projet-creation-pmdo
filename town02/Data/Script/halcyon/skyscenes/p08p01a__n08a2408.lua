-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P08P01A/n08a2408.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(8198) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  -- back_SetGround(LEVEL_P08P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(45)
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 224, 320, Direction.Right, "NPC_YAMIRAMI")
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2)
  local npc_npc_yamirami2 = SkySceneKit.spawn_npc("sableye", 280, 288, Direction.Down, "NPC_YAMIRAMI2")
  -- SetAnimation(12) [anim idle native]
  local npc_npc_yamirami3 = SkySceneKit.spawn_npc("sableye", 328, 320, Direction.Left, "NPC_YAMIRAMI3")
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2)
  local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 240, 352, Direction.UpRight, "NPC_YAMIRAMI4")
  -- SetAnimation(12) [anim idle native]
  local npc_npc_yamirami5 = SkySceneKit.spawn_npc("sableye", 280, 368, Direction.Up, "NPC_YAMIRAMI5")
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2)
  local npc_npc_yamirami6 = SkySceneKit.spawn_npc("sableye", 312, 352, Direction.UpLeft, "NPC_YAMIRAMI6")
  -- SetAnimation(12) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami2, "shock", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami3, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Wheh-heh-heh?[K] N-not here?!", french=" Whé hé hé?[K] Personne?!", german=" Wähähäh?[K] N-nicht hier?!?", italian=" Meh-eh-eh?[K] N-Non ci sono più?!", spanish=" ¿Je, je, je?[K] ¡¿Dónde están?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(3)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami3, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" D-did...[K]they run away?!", french=" Ils se sont...[K] échappés?!", german=" S-sind...[K] sie weggelaufen?!?", italian=" S-Sono...[K] scappati?!", spanish=" Se...[K] ¡¿Se han escapado?!"})
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" L-look![K] Look for them!", french=" Cherchez-les![K] Cherchez-les!", german=" S-sucht![K] Sucht nach ihnen!", italian=" F-Forza![K] Cerchiamoli!", spanish=" ¡Buscad![K] ¡Hay que dar con ellos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
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
  -- message_Close
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
