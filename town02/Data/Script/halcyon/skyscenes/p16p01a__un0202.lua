-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P16P01A/un0202.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 249 then
  -- @label_0 [étiquette de flux ExplorerScript]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE02_TALK = SV.SkyVars.SIDE02_TALK or {}; SV.SkyVars.SIDE02_TALK[1] = 1 -- $SIDE02_TALK[1] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_muchuuru = SkySceneKit.spawn_npc("smoochum", 256, 152, Direction.Left, "NPC_MUCHUURU")
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english=" Yay! I love Gummis! ♪", french=" Ouais! J'adore les gelées! ♪", german=" Juchhu! Ich liebe Gummis! ♪", italian=" Evviva! Io adoro le Gomme! ♪", spanish="¡Yupi! ¡Me encantan\nlas gomis! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_muchuuru) end)
  SkySceneKit.say({english="Thanks, [CS:Y]Igglybuff[CR]! ♪[K]\nSmooches! ♪", french="Merci, [CS:Y]Toudoudou[CR]! ♪[K]\nPoutou! ♪", german="Danke, [CS:Y]Fluffeluff[CR]! ♪[K]\nKnutsch! ♪", italian="Grazie, [CS:Y]Igglybuff[CR]! ♪[K]\nSmooches! ♪", spanish=" ¡Gracias, [CS:Y]Igglybuff[CR]! ♪[K] ¡Mua! ♪"})
  if ((((SV.SkyVars or {}).SIDE02_TALK or {})[0] or 0) ~= 0) then -- if ROM: $SIDE02_TALK[0]
  if ((((SV.SkyVars or {}).SIDE02_TALK or {})[2] or 0) ~= 0) then -- if ROM: $SIDE02_TALK[2]
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- screen2_FadeOut [sub déjà caché]
  GAME:FadeOut(false, 60)
  -- supervision_ExecuteCommon(CORO_EVENT_N02_03) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  else
  -- @label_1 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  else
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
