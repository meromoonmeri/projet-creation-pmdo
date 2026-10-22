-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D52P11A/n09a1101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Argh...[K] We didn't do so well...", french=" Argh...[K] Un échec retentissant...", german="Argh...[K]\nWir waren wohl nicht gut genug...", italian=" Argh...[K] Ci è andata male...", spanish=" Ay...[K] No lo hemos hecho bien..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" We should turn back for now.", french="Nous devrions faire demi-tour\npour l'instant.", german="Wir sollten besser\nnoch einmal umkehren.", italian=" Meglio tornare sui nostri passi.", spanish=" Retrocedamos de momento."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D52P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n9 = SkySceneKit.spawn_npc("dusknoir", 280, 272, Direction.Right, "NPC_YONOWAARU_N9")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Icicle Forest.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="If we don't hurry, we'll never be\nable to catch up to them!", french="Du nerf! Sinon, on n'arrivera\njamais à les rattraper!", german="Wenn wir uns nicht beeilen,\nwerden wir sie nicht mehr einholen können!", italian="Se non ci sbrighiamo, non\nriusciremo mai a prenderli!", spanish="Si no nos damos prisa, ¡nunca\npodremos alcanzarlos!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Once we're prepared, let's go!", french=" Préparons-nous et allons-y!", german="Lass uns aufbrechen, sobald\nwir vorbereitet sind!", italian=" Quando siamo pronti, andiamo!", spanish="En cuanto estemos preparados,\n¡sigamos adelante!"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
