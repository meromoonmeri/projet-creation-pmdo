-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/n01a0104.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  GAME:WaitFrames(30)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 216, 296, Direction.DownLeft, "NPC_DOGOOMU")
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="HEY! Not YET?![K]\nYou're SLOW, [CS:Y]BIDOOF[CR]!", french="QUOI! Toujours PAS de RETOUR![K]\nT'es LENT, [CS:Y]KEUNOTOR[CR]!", german="HEY! Immer noch NICHT?!?[K]\nDu bist LANGSAM, [CS:Y]BIDIZA[CR]!", italian="EHI! ANCORA niente?![K]\nSei LENTO, [CS:Y]BIDOOF[CR]!", spanish="¡Pero bueno, vaya horas![K]\n¡Eres un lentorro, [CS:Y]Bidoof[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end) -- message_SetActor(ACTOR_PLAYER_BIPPA)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Yes![K]\nI'm here!", french="Ouais![K]\nMe v'là!", german=" Doch![K] Da bin ich!", italian="Sì! [K]\nEccomi!", spanish=" ¡Bueno, vale![K] ¡Ya llego!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 256, 292, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Whew...[K]\nSorry to keep you waiting. [K]Here it is! Yup yup!", french="Pffff...[K]\nDésolé d't'avoir fait attendre.[K] Tiens, la v'là!\nOuaip ouaip!", german="Puh...[K] Tut mir leid, dass es so\nlange gedauert hat.[K] Hier ist er! Jawollja!", italian="Pant pant...[K]\nScusa se ti ho fatto aspettare.[K]\nEcco qua! Già, già!", spanish="Arf, arf...[K] Siento mucho haberte\nhecho esperar.[K] ¡Toma!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Here's your [CS:I]Reviver Seed[CR]!", french=" V'là ta [CS:I]Résugraine[CR]!", german=" Hier ist dein [CS:I]Belebersamen[CR]!", italian=" Il tuo [CS:I]Revitalseme[CR]!", spanish=" Aquí tienes tu [CS:I]Sem. Revivir[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-16), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(30)
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(16), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Wh-what...[K]IS this? HUH?!", french="Que...[K]\nQU'EST-CE que C'EST que ce MACHIN? HEIN?!", german=" W-was...[K] ist DAS? HÄH?!?", italian=" C-Cosa...[K] È questo? UH?!", spanish=" Pe... pero...[K] ¡¿qué es esto?!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" THIS is a [CS:I]DOOM Seed[CR], ISN'T it?!", french="ÇA, c'est une [CS:I]PEPINGRAINE[CR],\nça se voit PAS?!", german="DIES ist ein [CS:I]SCHWUNDsamen[CR]!\nODER etwa nicht?!?", italian=" QUESTO è un [CS:I]SEMEFATO[CR], VERO?!", spanish=" Es una [CS:I]Sem. Condena[CR], ¡¿no?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="NO, GENIUS!![K]\nBRING me the RIGHT one!", french="Tu es un VRAI génie, TOI,\nma PAROLE![K]\nRAMENE-moi la BONNE graine, et au TROT!", german="Und JETZT, SCHLAUMEIER...[K]\nBRING mir sofort den RICHTIGEN!", italian="NON ci siamo, GENIACCIO!!![K]\nPORTAMI quello GIUSTO!", spanish="¡Menudo lumbreras estás hecho![K]\nAnda, ve y tráeme la buena esta vez..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Eeeeeeeek!!", french=" Aaaarrrrgh!", german=" Ieeeeeeek!!!", italian=" Aaaaaaaah!!!", spanish=" ¡Aaaaaaay!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 232, 224, Direction.Down, "NPC_GUREGGURU")
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "happy", 1) end)
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Sniff...[K]\n[CN]Didn't matter what I did, I would always\n[CN]mess it up...", french="[CN]Snif...[K]\n[CN]Quoi qu'je fasse, j'le faisais de traviole...", german="[CN]Schnüff...[K]\n[CN]Egal, was mir aufgetragen wurde,\n[CN]jedes Mal ging etwas schief...", italian="[CN]Sniff...[K]\n[CN]Per quanto mi impegni, finisco sempre\n[CN]per fare qualcosa di sbagliato...", spanish="[CN]Jo...[K] Daba igual qué hiciera,\n[CN] al final siempre la fastidiaba..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]And then another time...", french="[CN]Comme c'te fois, là...", german="[CN]Und dann...", italian="[CN]Anche in un'altra occasione...", spanish="[CN]Un día..."})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
