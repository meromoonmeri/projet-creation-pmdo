-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D08P11A/m09a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_PLAYER
    GROUND:EntTurn(hero, Direction.Right)
    -- SetAnimation(76) [anim idle native]
    SkySceneKit.lock(5) -- Lock(5) NDS
    -- SetAnimation(63) [anim idle native]
    GAME:WaitFrames(2) -- join WaitAnimation
    GAME:WaitFrames(10)
    -- SetAnimation(2) [anim idle native]
    GROUND:EntTurn(hero, Direction.Down)
    GAME:WaitFrames(40)
    -- CallCommon CORO_LOOK_AROUND_LEFT_FUNC (fermeture/attente message: géré par say())
    GROUND:EntTurn(hero, Direction.Down)
    SkySceneKit.lock(6) -- Lock(6) NDS
    GAME:WaitFrames(1) -- hold
  end)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh, we blew it...", french=" Argh, on a échoué...", german=" Uff, wir haben es vermasselt...", italian=" Ugh, non ce l'abbiamo fatta...", spanish=" Uf... Hemos metido la pata."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh, we blew it...", french=" Argh, on a échoué...", german=" Uff, wir haben es vermasselt...", italian=" Ugh, non ce l'abbiamo fatta...", spanish=" ¡Qué mal! Hemos metido la pata."})
  else
  SkySceneKit.say({english=" Ugh, we blew it...", french=" Argh, on a échoué...", german=" Uff, wir haben es vermasselt...", italian=" Ugh, non ce l'abbiamo fatta...", spanish=" Vaya, hemos metido la pata."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- back_SetGround(LEVEL_D08P11A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_D08P11A, 'UM09') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 304, 432, Direction.Up, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Foggy Forest.ogg", true) end)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" What are you doing?", french=" Que faites-vous?", german=" Was macht ihr?", italian=" Cosa state facendo?", spanish=" ¿Qué hacéis aquí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...Huh?!", french=" ... Hein?!", german=" ...Wie?!?", italian=" ... Eh?!", spanish=" ¡¿Eh?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...Huh?!", french=" ... Hein?!", german=" ...Wie?!?", italian=" ... Eh?!", spanish=" ¡¿Eh?!"})
  else
  SkySceneKit.say({english=" ...Huh?!", french=" ... Hein?!", german=" ...Wie?!?", italian=" ... Eh?!", spanish=" ¡¿Eh?!"})
  end
  SkySceneKit.lock(3) -- Lock(3) NDS
  -- message_Close
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(8) -- Unlock(8) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(15)
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-where is this?", french=" Mais... où sommes-nous?", german=" W-wo sind wir?", italian=" D-Dove siamo?", spanish=" ¿Do... dónde estamos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-where is this?", french=" Mais... où sommes-nous?", german=" W-wo sind wir?", italian=" D-Dove siamo?", spanish=" ¿Do... dónde estamos?"})
  else
  SkySceneKit.say({english=" Wh-where is this?", french=" Mais... où sommes-nous?", german=" W-wo sind wir?", italian=" D-Dove siamo?", spanish=" ¿Do... dónde estamos?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="This is the base camp. It\nappears that your exploration has suffered\na setback.", french="Voici le camp de base. On dirait\nque votre exploration n'a pas été de tout\nrepos.", german="Dies ist das Basislager.\nOffenbar läuft eure Erkundung nicht allzu gut.", italian="Questo è il Campo Base. Sembra\nche la vostra esplorazione abbia subito una\nbattuta d'arresto.", spanish="Este es el campamento base.\nParece que vuestra exploración ha sufrido\nun contratiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Do it again! Get going!", french=" Allez! Ne vous attardez pas ici!", german=" Versucht es noch mal! Geht!", italian=" Provate di nuovo! Muovetevi!", spanish=" Volved a explorar, ¡venga!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Urk! Let's get going,\n[hero].", french=" Argh! En route, [hero].", german=" Urks! Gehen wir, [hero].", italian="Urk! Andiamo,\n[hero].", spanish=" ¡Ay! Vamos, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Urk! Let's get going,\n[hero].", french=" Argh! En route, [hero].", german=" Urks! Gehen wir, [hero].", italian="Urk! Andiamo,\n[hero].", spanish=" ¡Ay! Vamos, [hero]."})
  else
  SkySceneKit.say({english="Eep! Let's get going,\n[hero].", french=" Argh! En route, [hero].", german=" Urks! Gehen wir, [hero].", italian="Urk! Andiamo,\n[hero].", spanish=" ¡Ay! Vamos, [hero]."})
  end
  -- message_Close
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
