-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D10P41A/m11a0705.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D10P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_guraadon = SkySceneKit.spawn_npc("groudon", 328, 184, Direction.Down, "NPC_GURAADON")
  -- SetAnimation(47) [anim idle native]
  -- ResetOutputAttribute(256) [neutre/état moteur]
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  local npc_npc_yukushii = SkySceneKit.spawn_npc("uxie", 328, 184, Direction.Down, "NPC_YUKUSHII")
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end) -- message_SetActor(ACTOR_NPC_YUKUSHII)
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english=" Soon after they left...", french="Je savais que peu après leur\ndépart...", german=" Kurz nachdem sie gingen...", italian=" Sapevo che dopo di loro...", spanish="Poco después de que se\nmarchasen..."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english=" Another Pokémon would come...", french=" ... un autre Pokémon viendrait...", german=" Da kam ein anderes Pokémon...", italian="... sarebbe venuto un altro\nPokémon...", spanish=" Llegó otro Pokémon..."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english=" But this one...", french=" Mais celui-là...", german=" Aber dieses Pokémon...", italian=" Ma questo...", spanish=" Pero este..."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english=" It stole the Time Gear!", french="... il m'a volé mon Rouage\ndu Temps!", german=" Es stahl das Zahnrad der Zeit!", italian="... ha rubato l'Ingranaggio del\nTempo!", spanish=" ¡Va a robar el Engranaje del Tiempo!"})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  GAME:FadeOut(false, 15)
  SkySceneKit.cleanup_npcs()
end
