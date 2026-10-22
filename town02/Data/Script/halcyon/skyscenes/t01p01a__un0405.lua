-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/un0405.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if (SkyProg.cmp_side(43, 2) >= 0) or ((SV.SkyTalkBitFlags or {})[140] == 1) then -- if ROM: scn($SCENARIO_SIDE) >= [43, 2] || $SCENARIO_TALK_BIT_FLAG[14
  -- @label_0 [étiquette de flux ExplorerScript]
  -- switch(message_Menu(MENU_DUSKULL_BANK)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_1 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[140] = 1 -- $SCENARIO_TALK_BIT_FLAG[140] = 1 (ROM)
  local npc_npc_yomawaru = SkySceneKit.spawn_npc("duskull", 520, 168, Direction.Down, "NPC_YOMAWARU")
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english=" Oh! Hello, [CS:Y]Sunflora[CR]!", french=" Oh! Salut, [CS:Y]Héliatronc[CR]!", german=" Oh! Hallo, [CS:Y]Sonnflora[CR]!", italian=" Oh! Ciao, [CS:Y]Sunflora[CR]!", spanish=" ¡Anda, hola, [CS:Y]Sunflora[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english="I see you're working hard,\nas always!", french="Je vois que tu travailles dur,\ncomme d'habitude!", german="Wie ich sehe, bist du fleißig,\nwie immer!", italian="Noto che stai lavorando sodo,\ncome sempre!", spanish="Veo que trabajas duro,\ncomo siempre."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
