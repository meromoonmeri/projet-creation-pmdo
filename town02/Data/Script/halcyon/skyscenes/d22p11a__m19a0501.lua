-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D22P11A/m19a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 3 for actor ACTOR_NPC_JUPUTORU
    local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 280, 232, Direction.Down, "NPC_JUPUTORU")
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
  SkySceneKit.say({english=" Ugh...[K] We blew that attempt.", french=" Argh...[K] On a raté notre coup.", german=" Uff...[K] Der Versuch war nichts.", italian="Uh...[K] Ci siamo sforzati\ninutilmente.", spanish="Ay...[K] No lo hemos logrado esta\nvez."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh...[K] That wasn't good.", french=" Argh...[K] On a raté notre coup.", german=" Uff...[K] Das war nicht gut.", italian="Uh...[K] Non è andata per niente\nbene.", spanish="Ay...[K] No, no hemos tenido mucho\ntino."})
  else
  SkySceneKit.say({english=" Ugh...[K] We didn't make it.", french=" Argh...[K] On a raté notre coup.", german=" Uff...[K] Nicht geschafft.", italian=" Uh...[K] Non ce l'abbiamo fatta.", spanish=" Ay...[K] No hemos conseguido pasar."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D22P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_D22P11A, 'UM19') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DUSK_FOREST non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(9) -- Unlock(9) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Down)
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Urk... This is pretty tough\ngoing...", french=" Aaah... Ce que c'est difficile...", german="Umpf... Das ist eine ziemlich\nraue Gangart...", italian=" Uff... È piuttosto dura...", spanish=" La cosa está difícil..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk... This isn't easy at all...", french=" Aaah... Ce que c'est difficile...", german="Umpf... Das ist gar nicht\neinfach...", italian=" Uff... Non è per niente facile...", spanish="Es más complicado de lo que\nparece."})
  else
  SkySceneKit.say({english="Urk... This is kind of\nchallenging...", french=" Aaah... Ce que c'est difficile...", german="Umpf... Das ist eine echte\nHerausforderung...", italian=" Uff... È molto impegnativo...", spanish="Desde luego, esto es todo un\ndesafío."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.Down)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We have to fight our\nway through.", french="Il faut qu'on se batte pour\npasser.", german="Wir müssen uns da\ndurchkämpfen.", italian="Dobbiamo mettercela tutta per\nriuscire ad attraversare questo posto.", spanish="Tendremos que abrirnos paso\nluchando."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Those [CS:N]Sableye[CR] will catch up if\nwe don't hurry.", french="Ces [CS:N]Ténéfix[CR] vont nous rattraper\nsi on ne se dépêche pas.", german="Diese [CS:N]Zobiris[CR] holen auf, wenn\nwir uns nicht beeilen.", italian="Quei [CS:N]Sableye[CR] ci prenderanno\nse non ci sbrighiamo.", spanish="Esos [CS:N]Sableye[CR] nos alcanzarán\nsi no nos damos prisa."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We'll leave as soon as\nyou're ready.", french=" On repart quand tu veux.", german="Wir gehen, sobald ihr\nfertig seid.", italian=" Appena ve la sentite, partiamo.", spanish="Nos iremos en cuanto estéis\na punto."})
  -- message_Close
  -- SetAnimation(4) [anim idle native]
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
