-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D28P31A/m24a0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_PLAYER
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(5) -- Lock(5) NDS
    -- CallCommon CORO_LOOK_AROUND_FUNC (fermeture/attente message: géré par say())
    GAME:WaitFrames(30)
    SkySceneKit.unlock(3) -- Unlock(3) NDS
    SkySceneKit.lock(6) -- Lock(6) NDS
    GROUND:MoveToPosition(hero, 200, 208, false, 2)
    GROUND:EntTurn(hero, Direction.Up)
    GAME:WaitFrames(15)
    -- CallCommon CORO_LOOK_AROUND_FUNC (fermeture/attente message: géré par say())
    GROUND:MoveToPosition(hero, 288, 208, false, 2)
    GROUND:EntTurn(hero, Direction.Up)
    SkySceneKit.lock(7) -- Lock(7) NDS
    GROUND:MoveToPosition(hero, 484, 208, false, 2)
    GROUND:EntTurn(hero, Direction.Up)
    SkySceneKit.unlock(3) -- Unlock(3) NDS
    SkySceneKit.lock(8) -- Lock(8) NDS
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 2 for actor ACTOR_ATTENDANT1
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(9) -- Lock(9) NDS
    -- CallCommon CORO_LOOK_AROUND_FUNC (fermeture/attente message: géré par say())
    GAME:WaitFrames(30)
    SkySceneKit.lock(10) -- Lock(10) NDS
    GROUND:MoveToPosition(partner, 216, 192, false, 2)
    GROUND:EntTurn(partner, Direction.Up)
    -- CallCommon CORO_LOOK_AROUND_FUNC (fermeture/attente message: géré par say())
    GAME:WaitFrames(15)
    GROUND:MoveToPosition(partner, 324, 192, false, 2)
    GROUND:EntTurn(partner, Direction.Up)
    GAME:WaitFrames(15)
    -- CallCommon CORO_JUMP_ANGRY_FUNC (fermeture/attente message: géré par say())
    SkySceneKit.unlock(3) -- Unlock(3) NDS
    SkySceneKit.lock(11) -- Lock(11) NDS
    GROUND:MoveToPosition(partner, 516, 192, false, 2)
    GROUND:EntTurn(partner, Direction.Up)
    SkySceneKit.lock(12) -- Lock(12) NDS
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 3 for actor ACTOR_NPC_JUPUTORU
    local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 168, 208, Direction.UpRight, "NPC_JUPUTORU")
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(13) -- Lock(13) NDS
    -- CallCommon CORO_LOOK_AROUND_RIGHT_FUNC (fermeture/attente message: géré par say())
    SkySceneKit.lock(14) -- Lock(14) NDS
    GROUND:MoveToPosition(npc_npc_juputoru, 256, 208, false, 2)
    GROUND:EntTurn(npc_npc_juputoru, Direction.Up)
    -- CallCommon CORO_LOOK_AROUND_FUNC (fermeture/attente message: géré par say())
    GAME:WaitFrames(15)
    GROUND:MoveToPosition(npc_npc_juputoru, 360, 208, false, 2)
    GROUND:EntTurn(npc_npc_juputoru, Direction.Up)
    SkySceneKit.lock(15) -- Lock(15) NDS
    GROUND:MoveToPosition(npc_npc_juputoru, 548, 208, false, 2)
    GROUND:EntTurn(npc_npc_juputoru, Direction.Up)
    SkySceneKit.lock(16) -- Lock(16) NDS
    GAME:WaitFrames(1) -- hold
  end)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(40, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa![K] Th-this place is...", french=" Waouh![K] Cet endroit est...", german=" Huah![K] D-dieser Ort ist...", italian=" Wow![K] Q-Questo posto è...", spanish=" ¡Vaya![K] Este lugar es..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wow![K] Th-this place is...", french=" Waouh![K] Cet endroit est...", german=" Wow![K] D-dieser Ort ist...", italian=" Wow![K] Q-Questo posto è...", spanish=" ¡Vaya![K] Este lugar es..."})
  else
  SkySceneKit.say({english=" Wow![K] Th-this place is...", french=" Waouh![K] Cet endroit est...", german=" Wow![K] D-dieser Ort ist...", italian=" Wow![K] Q-Questo posto è...", spanish=" ¡Vaya![K] Este lugar es..."})
  end
  -- message_Close
  -- back_SetGround(LEVEL_D28P31A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Hidden Highland.ogg", true) end)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(9) -- Unlock(9) NDS
  GAME:WaitFrames(10)
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(13) -- Unlock(13) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  pcall(function() GAME:MoveCamera(328, 192, 60, false) end) -- performer/caméra
  SkySceneKit.unlock(14) -- Unlock(14) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(6) -- Unlock(6) NDS
  GAME:WaitFrames(20)
  SkySceneKit.unlock(10) -- Unlock(10) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's awesome! Look at it,\n[hero]!", french="Il est fantastique! Regarde\nun peu, [hero]!", german="Er ist großartig! Sieh es dir an,\n[hero]!", italian="È incredibile! Guarda,\n[hero]!", spanish="¡Es increíble!\n¡Mira, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's incredible! Look at it,\n[hero]!", french="Il est fantastique! Regarde\nun peu, [hero]!", german="Er ist unglaublich! Sieh es dir\nan, [hero]!", italian="È incredibile! Guarda,\n[hero]!", spanish="¡Es asombroso!\n¡Mira, [hero]!"})
  else
  SkySceneKit.say({english="It's fantastic! Look at it,\n[hero]!", french="Il est fantastique! Regarde\nun peu, [hero]!", german="Er ist fantastisch! Sieh es dir\nan, [hero]!", italian="È incredibile! Guarda,\n[hero]!", spanish="¡Es fantástico!\n¡Mira, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Look at these fantastic\ninscriptions and paintings on the rock walls!", french="Tu as vu ces gravures et ces\npeintures sur les parois, c'est superbe!", german="Sieh dir diese fantastischen\nInschriften und Malereien an den Felswänden\nan!", italian="Guarda quelle fantastiche\nincisioni e quei bellissimi dipinti sulle pareti\nrocciose!", spanish="¡Mira todos esos fantásticos\ndibujos en las paredes de roca!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Look at all these fantastic\npaintings and inscriptions on the walls!", french="Tu as vu ces gravures et ces\npeintures sur les parois, c'est superbe!", german="Sieh dir diese fantastischen\nInschriften und Malereien an den Wänden an!", italian="Guarda quelle fantastiche\nincisioni e quei bellissimi dipinti sulle pareti\nrocciose!", spanish="¡Mira todos esos fantásticos\ndibujos en las paredes de roca!"})
  else
  SkySceneKit.say({english="Look at all these fantastic\npaintings and inscriptions on the walls!", french="Tu as vu ces gravures et ces\npeintures sur les parois, c'est superbe!", german="Sieh dir diese fantastischen\nInschriften und Malereien an den Wänden an!", italian="Guarda quelle fantastiche\nincisioni e quei bellissimi dipinti sulle pareti\nrocciose!", spanish="¡Mira todos esos fantásticos\ndibujos en las paredes de roca!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(516, 192, 60, false) end) -- performer/caméra
  SkySceneKit.unlock(15) -- Unlock(15) NDS
  GAME:WaitFrames(5)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  GAME:WaitFrames(5)
  SkySceneKit.unlock(11) -- Unlock(11) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Like [CS:N]Lapras[CR] said, this place is\nthe [CS:P]Old Ruins[CR]...", french="Ce sont les [CS:P]Ruines Anciennes[CR]\ndont a parlé [CS:N]Lokhlass[CR]...", german="Wie [CS:N]Lapras[CR] schon sagte, dies\nsind die [CS:P]Alten Ruinen[CR]...", italian="Come diceva [CS:N]Lapras[CR],\nqueste sono le [CS:P]Antiche Rovine[CR]...", spanish="Tal como dijo [CS:N]Lapras[CR], estas son\nlas [CS:P]Ruinas Arcanas[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="The Rainbow Stoneship should\nbe here.", french="Le Vaisseau Arc-en-Ciel ne doit\nplus être très loin.", german="Das Regenbogen-Steinschiff\nsollte hier sein.", italian="Il Vascello Arcobaleno dovrebbe\nessere qui.", spanish="La Barca Arcoiris debe de estar\npor aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownRight)
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yeah, that's right!", french=" Oui, c'est vrai!", german=" Ja, so ist es!", italian=" Sì, hai ragione!", spanish=" ¡Claro que sí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yup, that's right!", french=" Oui, c'est vrai!", german=" Jep, so ist es!", italian=" Sì, hai ragione!", spanish=" ¡Claro que sí!"})
  else
  SkySceneKit.say({english=" Yup, that's right!", french=" Oui, c'est vrai!", german=" Jep, so ist es!", italian=" Sì, hai ragione!", spanish=" ¡Claro que sí!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's get in there!", french=" Allons-y!", german=" Gehen wir hinein!", italian=" Entriamo!", spanish=" Entremos ahí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go in there!", french=" Allons-y!", german=" Gehen wir hinein!", italian=" Entriamo!", spanish=" Entremos ahí."})
  else
  SkySceneKit.say({english=" Let's get in there!", french=" Allons-y!", german=" Gehen wir hinein!", italian=" Entriamo!", spanish=" Entremos ahí."})
  end
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(120), p.Y+(0), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(120), p.Y+(0), false, 2) end
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(120), p.Y+(0), false, 2) end
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
