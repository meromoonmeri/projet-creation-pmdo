-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P05A/n00p0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  GAME:FadeOut(false, 30)
  -- CallCommon CORO_SUBSCREEN_INIT (fermeture/attente message: géré par say())
  GROUND:TeleportTo(hero, 204, 236, Direction.Down)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 208, 200, Direction.Up, "NPC_PUKURIN")
  GROUND:TeleportTo(npc_npc_pukurin, 204, 196, Direction.Down)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetPositionLives(5) [cible objet/id de décor NDS non simulée - trace]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" .........", french=" ..........", german=" ..........", italian=" ..........", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Um...[K]\nI had something I wanted to ask...", french="Heu...[K]\nJe voulais te poser une question...", german="Ähem...[K]\nDa ist noch etwas, das ich sagen wollte...", italian="Mmmh...[K]\nStavo pensando a una cosa...", spanish="Hum...[K]\nQuería comentarte una cosa..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I entrusted it to [CS:Y]Bidoof[CR]...[K]\nThat [CS:P]Star Cave[CR] exploration...", french="Je t'ai confié cette mission,\n[CS:Y]Keunotor[CR]...[K]\nL'exploration de la [CS:P]Caverne Etoile[CR]...", german="Ich habe sie dir anvertraut,\n[CS:Y]Bidiza[CR]...[K] Die Erkundung der [CS:P]Sternenhöhle[CR].", italian="[CS:Y]Bidoof[CR]...[K] Ti ho affidato\nquell'esplorazione della [CS:P]Caverna Stellata[CR]...", spanish="Te confié, [CS:Y]Bidoof[CR],[K]\naquella exploración en la [CS:P]Cueva Estrella[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="That is...[K]I probably should have\ngone instead...", french="Mais en fait...[K] j'aurais peut-être\ndû y aller moi-même...", german="Wobei...[K] Vielleicht hätte ich\nstattdessen lieber selbst gehen sollen...", italian="Ma, ecco...[K] Forse sarei dovuto\nandare io al posto tuo...", spanish="Aunque...[K] probablemente\ndebería haber ido yo en tu lugar..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(30) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Oh...!", french=" Oh...!", german=" Oh...", italian=" Oh...!", spanish=" ¡Anda!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(204, 332, 60, false) end) -- performer/caméra
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 208, 352, Direction.Up, "NPC_PERAPPU")
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(-32), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Guildmaster!![K]\nYou shouldn't go off on your own!!", french="Maître, vous n'y pensez pas![K]\nVous ne devriez jamais\npartir seul en exploration!!", german="Gildenmeister!!![K]\nSei nicht so selbstkritisch!!!", italian="Capitano!!![K]\nNon deve andare in giro da solo!", spanish="¡¡Gran Bluff!![K]\n¡No deberías ir tú solo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It's no good at all!![K]\nHumph!!", french="Ce serait une très,\ntrès mauvaise idée!![K]\nHumph!!", german="Das ist überhaupt nicht\nnotwendig!!![K] Hrmph!!!", italian="È troppo pericoloso!!![K]\nUmpf!!!", spanish="¡Ni se te ocurra pensarlo![K]\n¡He dicho!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(96), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(15)
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER_BIPPA
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="N-never mind...[K]\nIt's nothing.", french="D-d'accord...[K]\nJe n'ai rien dit.", german="A-ach, schon gut...[K]\nEs ist gar nichts.", italian="V-Va bene...[K]\nNon importa.", spanish="No, no te preocupes...[K]\nNo pasa nada."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Good luck exploring! ♪", french="Bonne chance\npour l'exploration! ♪", german="Alles Gute auf deinen\nErkundungen! ♪", italian="Buona fortuna\nper l'esplorazione! ♪", spanish=" ¡Buena suerte explorando! ♪"})
  -- message_Close
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SkySceneKit.cleanup_npcs()
end
