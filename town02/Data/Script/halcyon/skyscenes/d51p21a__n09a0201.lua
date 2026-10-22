-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D51P21A/n09a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=48, sub=2} -- $SCENARIO_SIDE = scn[48,2] (ROM)
  -- back_SetGround(LEVEL_D51P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n9 = SkySceneKit.spawn_npc("dusknoir", 248, 424, Direction.Up, "NPC_YONOWAARU_N9")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DARK_ICE_MOUNTAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 208, 276, false, 2)
  GROUND:MoveToPosition(npc_npc_yonowaaru_n9, 248, 276, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(6)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" We've climbed pretty far.", french=" Ça fait un moment qu'on grimpe.", german="Wir sind schon\nziemlich weit gekommen.", italian=" Siamo piuttosto in alto.", spanish=" Hemos subido un buen trecho."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="We will reach the peak soon,\nit seems.", french=" Le sommet n'est plus très loin.", german="Bald werden wir wohl\nden Gipfel erreichen.", italian="La cima non dovrebbe essere\nlontana.", spanish="Parece que pronto llegaremos\na la cumbre."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Yes.", french=" En effet.", german=" Ja.", italian=" Sì.", spanish=" Eso parece."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="However, I don't know what lies\nahead for us.", french="Mais qui sait ce qui nous y\nattend?", german="Wie dem auch sei... Ich habe\nkeine Ahnung, was vor uns liegt.", italian="Comunque non so cosa ci\naspetti più avanti.", spanish="Pero no sabemos lo que nos espera\nallí arriba."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Be prepared.", french=" Tiens-toi prêt.", german=" Sei wachsam.", italian=" Stiamo attenti.", spanish=" Prepárate."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
