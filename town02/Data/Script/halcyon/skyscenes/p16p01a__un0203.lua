-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P16P01A/un0203.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 249 then
  -- @label_0 [étiquette de flux ExplorerScript]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE02_TALK = SV.SkyVars.SIDE02_TALK or {}; SV.SkyVars.SIDE02_TALK[2] = 1 -- $SIDE02_TALK[2] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_subomii = SkySceneKit.spawn_npc("budew", 224, 168, Direction.UpRight, "NPC_SUBOMII")
  pcall(function() UI:SetSpeaker(npc_npc_subomii) end)
  SkySceneKit.say({english="Chew-chew...[K] Gummis\nare tasty! ♪", french="Miam miam...[K] Ces gelées,\nc'est un régal! ♪", german="Mampf-mampf...[K] Gummis\nsind lecker! ♪", italian="Gnam, gnam...[K] Che buone\nle Gomme! ♪", spanish="Ñam, ñam...[K] ¡Qué ricas\nestán las gomis! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_subomii) end)
  SkySceneKit.say({english=" You're the best, [CS:Y]Igglybuff[CR]! ♪", french=" T'es le meilleur, [CS:Y]Toudoudou[CR]! ♪", german=" Du bist der Beste, [CS:Y]Fluffeluff[CR]! ♪", italian=" Sei il migliore, [CS:Y]Igglybuff[CR]! ♪", spanish=" ¡Eres el mejor, [CS:Y]Igglybuff[CR]! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Hee-hee, I'm happy too...[K]\nfriendly friend. ♪", french="Hi hi, je suis content aussi...[K]\ncopains de moi. ♪", german="Hihihi, ich bin auch froh...[K]\nLieber Freund. ♪", italian="Hi hi, anch'io sono felice...[K]\namicissimi miei. ♪", spanish="Ji, ji, me alegro mucho...[K]\nLos amigos son lo mejor. ♪"})
  -- message_Close
  if ((((SV.SkyVars or {}).SIDE02_TALK or {})[0] or 0) ~= 0) then -- if ROM: $SIDE02_TALK[0]
  if ((((SV.SkyVars or {}).SIDE02_TALK or {})[1] or 0) ~= 0) then -- if ROM: $SIDE02_TALK[1]
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
