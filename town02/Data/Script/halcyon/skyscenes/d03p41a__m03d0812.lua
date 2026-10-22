-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D03P41A/m03d0812.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D03P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(5)
  GAME:WaitFrames(30)
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_0 [étiquette de flux ExplorerScript]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  -- @label_2 [étiquette de flux ExplorerScript]
  local npc_npc_suriipu = SkySceneKit.spawn_npc("drowzee", 352, 272, Direction.Up, "NPC_SURIIPU")
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="If you keep being difficult, it\nwill mean big trouble for you!", french="Si tu continues à faire des\ncaprices, tu vas avoir de gros ennuis!", german="Du bringst dich in\nSchwierigkeiten, wenn du nicht tust, was\nich sage!", italian="Se non fai quello che ti\nchiedo...[K] te ne pentirai!", spanish="Si no haces lo que te pido...[K]\nTendrás serios problemas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_ruriri = SkySceneKit.spawn_npc("azurill", 352, 248, Direction.Down, "NPC_RURIRI")
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" H-h-h...HELP!", french=" A... A L'AIDE!", german=" H-h-h...HILFE!", italian=" A-A-A... Aiuto!", spanish=" ¡So... socorro!"})
  -- message_Close
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- GAP: se_Play(5139) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 5) -- screen_WhiteOut
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  GAME:FadeOut(false, 15)
  -- @label_5 [étiquette de flux ExplorerScript]
  GAME:FadeIn(0) -- screen_FlushIn
  end
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
