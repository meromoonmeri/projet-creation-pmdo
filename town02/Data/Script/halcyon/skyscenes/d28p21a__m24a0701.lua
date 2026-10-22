-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D28P21A/m24a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 3 for actor ACTOR_NPC_JUPUTORU
    local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 232, 168, Direction.Down, "NPC_JUPUTORU")
    -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
    -- SetAnimation(29) [anim idle native]
    SkySceneKit.lock(9) -- Lock(9) NDS
    GAME:WaitFrames(30)
    -- SetAnimation(31) [anim idle native]
    GAME:WaitFrames(2) -- join WaitAnimation
    -- SetAnimation(2) [anim idle native]
    GAME:WaitFrames(15)
    GROUND:EntTurn(npc_npc_juputoru, Direction.UpLeft)
    -- CallCommon CORO_LOOK_AROUND_FUNC (fermeture/attente message: géré par say())
    SkySceneKit.lock(10) -- Lock(10) NDS
    GAME:WaitFrames(1) -- hold
  end)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...[K] We got wiped out.", french=" Argh...[K] On a échoué.", german=" Uff...[K] Wir wurden ausgeschaltet.", italian=" Uff...[K] Ci hanno sconfitti.", spanish=" Uf...[K] Nos han zurrado bien."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh...[K] That didn't go well.", french=" Argh...[K] On a échoué.", german=" Uff...[K] Das hat nicht geklappt.", italian=" Uff...[K] Non è andata bene.", spanish="Uf...[K] Parece que no ha habido\nsuerte."})
  else
  SkySceneKit.say({english=" Ugh...[K] That wasn't so good.", french=" Argh...[K] On a échoué.", german=" Uff...[K] Das war nicht so gut.", italian=" Uff...[K] Non è andata molto bene.", spanish=" Uf...[K] La cosa no marcha."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D28P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_D28P21A, 'UM24') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Hidden Highland.ogg", true) end)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(9) -- Unlock(9) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Down)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk! This is pretty hard.", french=" Ce n'est vraiment pas facile.", german="Umpf! Das ist ganz schön\nschwierig.", italian=" Eh! È piuttosto dura.", spanish=" ¡Qué duro que es esto!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk! That was challenging.", french=" Ce n'est vraiment pas facile.", german="Umpf! Das war eine\nHerausforderung.", italian=" Eh! Non è facile...", spanish=" Esto es todo un desafío."})
  else
  SkySceneKit.say({english=" Urk! It's not easy...", french=" Ce n'est vraiment pas facile.", german=" Umpf! Das ist nicht einfach...", italian=" Eh! Non è facile...", spanish=" ¡Ay! Ojalá fuera más fácil..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We've come this far.", french="On a déjà accompli tant\nde choses.", german=" Wir sind so weit gekommen.", italian=" Siamo arrivati fin qui.", spanish="Hemos hecho un gran esfuerzo\npara llegar hasta aquí."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We'll get through whatever\nit takes.", french=" On y arrivera quoi qu'il en coûte.", german="Wir kommen durch, was es auch\nkostet.", italian="Ce la dobbiamo fare, costi quel\nche costi.", spanish="Ahora vamos a atravesar este\nlugar, sea como sea."})
  -- message_Close
  -- SetAnimation(4) [anim idle native]
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
