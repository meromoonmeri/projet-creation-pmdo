-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D28P21A/m24a0901.ssb (ROM sha256 1fa39d35…).
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
  pcall(function() UI:SetSpeaker("Sableye", true, "sableye", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YAMIRAMI (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Wheh-heh...heh?", french=" Whé hé... hé?", german=" Wähä... häh?", italian=" Eh-eh-eh... eh?", spanish=" Je, je, je... ¿je?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" They vanished?![K] No, that isn't it.", french=" Disparus?![K] Non, c'est impossible.", german="Sie sind verschwunden?[K] Nein,\ndas kann nicht sein.", italian="Sono scomparsi?![K] No, non può\nessere.", spanish="¡Han desaparecido![K]\nNo, no puede ser."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" They just managed to retreat.", french="Ils ont simplement réussi\nà battre en retraite.", german="Sie haben nur einen\nerfolgreichen Rückzug vollzogen.", italian="Deve essere stata una ritirata\nstrategica.", spanish="Simplemente, habrán\nretrocedido."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="...Humph. So be it.[K] There is no\nneed for panic.", french="... Pfff! Soit.[K] Inutile de\npaniquer.", german="Grmpf. Dann ist es halt so.[K]\nDas ist kein Grund zur Panik.", italian="Bah. Se è così...[K] non c'è nulla\ndi cui preoccuparsi.", spanish="Hum... No importa.[K]\nNo hay que perder la calma."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" They will return. They have to.", french="Ils reviendront. Ils n'ont pas\nle choix.", german="Sie werden zurückkommen. Es\nbleibt ihnen nichts anderes übrig.", italian=" Ritorneranno. Devono farlo.", spanish=" Ya volverán. No les queda otra."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="And we'll be waiting![K] Ha-ha-ha!\nHoo-hoo-ha!", french="Et nous les attendrons de pied\nferme![K] Ha ha ha! Ho ho ha!", german="Und wir werden auf sie\nwarten![K] Ha-ha-ha! Ho-ho-ha!", italian="E noi li aspetteremo![K] Ah-ah-ah!\nOoh-ooh-oh!", spanish="¡Y aquí estaremos esperándoles![K]\n¡Ja, ja, ja! ¡Ja, jua, jua!"})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D28P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_D28P21A, 'UM24') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Hidden Highland.ogg", true) end)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(9) -- Unlock(9) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk![K] This isn't easy at all.", french=" Argh![K] Ce n'est pas de la tarte.", german=" Uff![K] Das ist gar nicht einfach.", italian=" Uh![K] Non è per niente facile.", spanish=" ¡Vaya![K] Nos han machacado..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk![K] This is really challenging.", french=" Argh![K] Ce n'est pas de la tarte.", german="Uff![K] Das ist eine echte\nHerausforderung.", italian=" Uh![K] È davvero impegnativo.", spanish=" ¡Vaya![K] Es bastante complicado."})
  else
  SkySceneKit.say({english=" Urk![K] It's really tough.", french=" Argh![K] Ce n'est pas de la tarte.", german=" Uff![K] Das ist wirklich brutal.", italian=" Uh![K] È davvero dura.", spanish=" ¡Madre mía![K] ¡No hay manera!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="It doesn't matter if [CS:N]Dusknoir[CR] is\nlying in wait.", french=" [CS:N]Noctunoir[CR] ou pas, peu importe.", german="Es macht nichts, wenn\n[CS:N]Zwirrfinst[CR] uns auflauert.", italian="Non importa se [CS:N]Dusknoir[CR]\nci sta aspettando.", spanish="No importa que [CS:N]Dusknoir[CR] esté\nesperándonos."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We will get through this time.", french=" On y arrivera cette fois-ci.", german=" Diesmal kommen wir durch.", italian="Questa volta ce la dobbiamo\nfare.", spanish=" Esta vez le venceremos."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
