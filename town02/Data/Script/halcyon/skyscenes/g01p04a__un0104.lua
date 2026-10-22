-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/un0104.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 456, 272, Direction.Up, "NPC_DIGUDA")
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Do your best, [CS:Y]Bidoof[CR]!", french=" Fais de ton mieux, [CS:Y]Keunotor[CR]!", german=" Gib dein Bestes, [CS:Y]Bidiza[CR]!", italian=" Dacci dentro, [CS:Y]Bidoof[CR]!", spanish=" ¡A por todas, [CS:Y]Bidoof[CR]!"})
  -- message_Close
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp_side(40, 3) >= 0) or (SkyProg.cmp_side(40, 2) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 3] || scn($SCENARIO_SIDE) >= [40
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- SetAnimation(2) [anim idle native]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Up, "NPC_DOGOOMU")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Let's do our best, [CS:N]Loudred[CR]!", french="Faisons de notre mieux,\n[CS:N]Ramboum[CR]!", german="Geben wir unser Bestes,\n[CS:N]Krakeelo[CR]!", italian=" Diamoci dentro, [CS:N]Loudred[CR]!", spanish=" ¡A por todas, [CS:N]Loudred[CR]!"})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
