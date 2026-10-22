-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D23P11A/m19b0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 3 for actor ACTOR_NPC_JUPUTORU
    local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 256, 344, Direction.DownRight, "NPC_JUPUTORU")
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
  SkyProg.set(20, 4) -- $SCENARIO_MAIN = scn[20,4] (ROM)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...[K] We blew that attempt.", french=" Argh...[K] On s'est pris une raclée.", german=" Uff...[K] Das war wohl nichts.", italian=" Uff...[K] Abbiamo fallito.", spanish="Vaya...[K] No lo hemos logrado\nesta vez."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh...[K] That wasn't very good.", french=" Argh...[K] On s'est pris une raclée.", german=" Uff...[K] Das war nicht sehr gut.", italian=" Uff...[K] Non è andata molto bene.", spanish=" Ay...[K] No ha ido muy bien."})
  else
  SkySceneKit.say({english=" Ugh...[K] We didn't make it.", french=" Argh...[K] On s'est pris une raclée.", german=" Uff...[K] Nicht geschafft.", italian=" Uh...[K] Non ce l'abbiamo fatta.", spanish=" Ay...[K] No ha salido bien."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D23P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_D23P11A, 'UM19') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Deep Dusk Forest.ogg", true) end)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(5)
  SkySceneKit.unlock(11) -- Unlock(11) NDS
  SkySceneKit.unlock(9) -- Unlock(9) NDS
  GAME:WaitFrames(5)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(15)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownRight)
  local npc_npc_serebii = SkySceneKit.spawn_npc("celebi", 304, 344, Direction.DownLeft, "NPC_SEREBII")
  GROUND:EntTurn(npc_npc_serebii, Direction.DownLeft)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Urk... This is pretty tough\ngoing...", french="Pfff... Comme c'est\néprouvant...", german="Urks... Das ist eine ziemlich\nraue Gangart...", italian=" Eh... È piuttosto impegnativo...", spanish=" Esto está resultando muy duro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk... This isn't easy at all...", french="Pfff... Comme c'est\néprouvant...", german="Urks... Das ist überhaupt nicht\neinfach...", italian=" Eh... Non è per niente facile...", spanish=" Esto no es nada fácil."})
  else
  SkySceneKit.say({english="Urk... This is kind of\nchallenging...", french="Pfff... Comme c'est\néprouvant...", german="Urks... Das ist eine echte\nHerausforderung...", italian=" Eh... È piuttosto impegnativo...", spanish="Menuda prueba que estamos\nviviendo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We don't have far to go to the\nPassage of Time.", french="Le Couloir du Temps n'est plus\ntrès loin.", german="Wir müssen bis zum Zeittunnel\nnicht weit gehen.", italian="Non siamo lontani dal Portale del\nTempo.", spanish="Ya no queda mucho para llegar\nal Pasaje del Tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We must reach it, no matter\nwhat.", french="On doit y arriver, coûte\nque coûte.", german="Wir müssen dort ankommen,\nkoste es, was es wolle.", italian="Dobbiamo raggiungerlo ad ogni\ncosto.", spanish=" Hay que alcanzarlo como sea."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We'll leave as soon as you're\nready.", french=" On repart quand vous voulez.", german=" Wir gehen, sobald du bereit bist.", italian=" Appena tutto è pronto partiamo.", spanish=" Nos iremos en cuanto digáis."})
  -- message_Close
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
