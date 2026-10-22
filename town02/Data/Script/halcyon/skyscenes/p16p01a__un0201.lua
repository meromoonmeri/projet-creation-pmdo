-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P16P01A/un0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 249 then
  -- @label_0 [étiquette de flux ExplorerScript]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE02_TALK = SV.SkyVars.SIDE02_TALK or {}; SV.SkyVars.SIDE02_TALK[0] = 1 -- $SIDE02_TALK[0] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_upaa = SkySceneKit.spawn_npc("wooper", 224, 136, Direction.DownRight, "NPC_UPAA")
  pcall(function() UI:SetSpeaker(npc_npc_upaa) end)
  SkySceneKit.say({english=" Yay! Gummis!", french=" Ouais! Des gelées!", german=" Juchhu! Gummis!", italian=" Evviva! Le Gomme!", spanish=" ¡Bieeeen! ¡Gomis!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" How are they?", french=" Elles sont bonnes?", german=" Wie sind sie?", italian=" Come sono?", spanish=" ¿Están ricas?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_upaa) end)
  SkySceneKit.say({english=" Great! Delicious![K] Thank you! ♪", french=" Super! Un vrai délice![K] Merci! ♪", german="Großartig! Lecker![K]\nDanke schön! ♪", italian="Fantastiche! Deliziose![K]\nGrazie! ♪", spanish="¡Riquísimas! ¡De rechupete![K]\n¡Gracias! ♪"})
  -- message_Close
  if ((((SV.SkyVars or {}).SIDE02_TALK or {})[1] or 0) ~= 0) then -- if ROM: $SIDE02_TALK[1]
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
