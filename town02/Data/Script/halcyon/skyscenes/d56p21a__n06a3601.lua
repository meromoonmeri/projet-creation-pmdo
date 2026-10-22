-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D56P21A/n06a3601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 200, 296, Direction.Down, "NPC_CHAAREMU")
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Hmm...[K] Looks like we didn't do\nso well.", french="Hum...[K] Ce n'était pas\nune franche réussite.", german="Hmm...[K] Sieht fast so aus, als\nwären wir nicht gut genug gewesen.", italian="Mmmh...[K] A quanto pare non\nè andata molto bene.", spanish="Hum...[K] Parece que\nno nos ha ido demasiado bien."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="We'll do better\nnext time. [M:H8]", french="On fera mieux la\nprochaine fois. [M:H8]", german="Nächstes Mal geben wir uns\nmehr Mühe. [M:H8]", italian="Faremo meglio la prossima\nvolta. [M:H8]", spanish=" Nos irá mejor la próxima vez. [M:H8]"})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D56P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 264, 296, Direction.Left, "NPC_SAANAITO")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Down)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Right)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DEEP_LIMESTONE_CAVERN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(7)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Right)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(14)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(9)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" .........", french=" .........", german=" .........", italian=" .........", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Looks like we're right back\nhere again...", french=" Nous voilà de retour...", german="Sieht fast so aus, als wären wir\nwieder hier...", italian="A quanto pare, siamo tornate\nindietro...", spanish=" Pues estamos aquí otra vez..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Anyhow, let's aim for the depths\nand try again.", french="Retournons dans les profondeurs\npour tenter à nouveau notre chance.", german="Aber egal, lasst uns die Tiefen\nerreichen und es noch mal versuchen.", italian="Comunque dobbiamo riprovarci\ne raggiungere le profondità della cava.", spanish="En fin, vamos a lo más profundo\na intentarlo de nuevo."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="We have to try to figure out\nwhere the treasure is.", french=" Nous devons trouver le trésor.", german="Wir müssen herausfinden, wo\nder Schatz geblieben ist...", italian="Dobbiamo capire dove si trova\nil tesoro.", spanish="Hay que intentar averiguar\ndónde está el tesoro."})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "angry", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="And get our revenge on\nTeam [CS:X]AWD[CR]!", french="Et prendre notre revanche sur\nl'Equipe [CS:X]DDA[CR]!", german=" Und es Team [CS:X]SPA[CR] heimzahlen!", italian="E prenderci la nostra rivincita\nsul Team [CS:X]AWD[CR]!", spanish=" ¡Y vengarnos del [CS:X]Equipo WAD[CR]!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Let's hurry up and go!", french=" Pas de temps à perdre!", german=" Beeilen wir uns und brechen auf!", italian=" Forza, andiamo!", spanish=" ¡No hay tiempo que perder!"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
