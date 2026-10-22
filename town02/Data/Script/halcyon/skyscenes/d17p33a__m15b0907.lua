-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D17P33A/m15b0907.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D17P33A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  pcall(function() GAME:MoveCamera(228, 244, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 208, 228, false, 2)
  GROUND:MoveToPosition(hero, 248, 244, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 220, 276, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 256, 284, false, 2) end end
  GAME:FadeIn(30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- bgm2_PlayFadeIn(BGM_EARTHQUAKE3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '0', '2', '0')
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa! Tremors?!", french=" Ouaaah! Le sol tremble?!", german=" Boah! Ein Beben?!?", italian=" Waaah! Un terremoto!", spanish="¿Qué pasa? El suelo está\ntemblando."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaah! Tremors?!", french=" Ouaaah! Le sol tremble?!", german=" Waaah! Ein Beben?!?", italian=" Aaaah! Un terremoto!", spanish="¿Qué pasa? El suelo está\ntemblando."})
  else
  SkySceneKit.say({english=" Waaah! Tremors!", french=" Ouaaah! Le sol tremble?!", german=" Waaah! Ein Beben?!?", italian=" Aaaah! Un terremoto!", spanish="¿Qué pasa? El suelo está\ntemblando."})
  end
  -- message_Close
  GAME:FadeOut(false, 15)
  -- camera_SetEffect(0): arrêt d'effet caméra
end
