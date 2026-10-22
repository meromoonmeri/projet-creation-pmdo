-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/m22a0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  GAME:WaitFrames(60)
  SkyProg.set(23, 2) -- $SCENARIO_MAIN = scn[23,2] (ROM)
  -- back_SetGround(LEVEL_P01P03A) [neutre/état moteur]
  -- supervision_StationCommon(7) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  local npc_npc_kootasu = SkySceneKit.spawn_npc("torkoal", 216, 80, Direction.Down, "NPC_KOOTASU")
  GROUND:MoveToPosition(npc_npc_kootasu, 216, 184, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" Oh, to be young again!", french=" Ah, retrouver ses jeunes années!", german=" Oh, noch einmal jung sein!", italian="Oh, cosa non darei per tornare\ngiovane!", spanish=" ¡Ay, quién fuera joven otra vez!"})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="If I was younger, I'd certainly\njoin the challenge to find the [CS:P]Hidden Land[CR].", french="Si j'étais plus jeune,\nje participerais sûrement à la quête des\n[CS:P]Terres Illusoires[CR].", german="Wäre ich jünger, würde ich\nmich auch der Herausforderung stellen, das\n[CS:P]Verborgene Land[CR] zu finden.", italian="Se fossi più giovane,\nsicuramente parteciperei alla ricerca\ndella [CS:P]Terra Nascosta[CR].", spanish="Si fuera más joven, me uniría,\nsin duda, a la expedición en busca de\nla [CS:P]Tierra Oculta[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" Whoa-ho-ho![K] Hold it there, old-timer!", french="Mouarf mouarf mouarf![K] Attends un peu,\nvieillard!", german=" Whoahoho![K] Stehen geblieben, Opa!", italian=" Uooh-oh-oh![K] Fermo lì, vecchietto!", spanish=" ¡Jo, jo, jo![K] ¡Quieto ahí, abuelo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" Wh-who is it?", french=" Qui... qui va là?", german=" W-wer spricht da?", italian=" C-Chi è là?", spanish=" ¿Quién anda ahí?"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Team Skull.ogg", true) end)
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 376, 168, Direction.Left, "NPC_ZUBATTO")
  GROUND:MoveToPosition(npc_npc_zubatto, 216, 172, false, 2)
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 384, 216, Direction.Left, "NPC_DOGAASU")
  GROUND:MoveToPosition(npc_npc_dogaasu, 216, 212, false, 2)
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 360, 184, Direction.Left, "NPC_SUKATANKU")
  GROUND:MoveToPosition(npc_npc_sukatanku, 252, 184, false, 2)
  GAME:WaitFrames(60)
  GROUND:EntTurn(npc_npc_kootasu, Direction.Right)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Down)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Up)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="Wha-what is it? What do you\nwant?", french="Qu'est-ce que c'est? Qu'est-ce\nque vous voulez?", german=" W-was gibt es? Was wollt ihr?", italian=" C-Cosa c'è? Cosa volete?", spanish="¿Qué...? ¿Qué pasa?\n¿Qué queréis de mí?"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Chaw-haw-haw! Well, we're\nTeam [CS:X]Skull[CR]!", french="Gnark gnark gnark! On est\nl'Equipe [CS:X]Crâne[CR]!", german="Cha-ha-ha! Nun, wir sind\nTeam [CS:X]Totenkopf[CR]!", italian="Ahr-ahr-ahr! Beh, siamo il Team\n[CS:X]Teschio[CR]!", spanish="¡Jua, jua, jua! ¡Nosotros\nsomos el [CS:X]Equipo Calavera[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Heh-heh! Did you have business\nwith [CS:N]Wigglytuff[CR]'s Guild, old-timer?", french="Hin hin hin! Alors, on complote\navec la Guilde de [CS:N]Grodoudou[CR], vieillard?", german="Hehe! Hattest du irgendetwas in\nder [CS:N]Knuddeluff-Gilde[CR] zu schaffen, Opa?", italian="Eh-eh! Te la intendi con la\nGilda di [CS:N]Wigglytuff[CR], vecchietto?", spanish="¡Jue, jue! ¿Se te ha perdido algo\nen el [CS:N]Pokégremio de Exploradores[CR],\nabuelo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Whoa-ho-ho! I overheard you\nsay something that sounded fun!", french="Mouarf mouarf mouarf! Je t'ai\nentendu parler d'un truc qui avait l'air\nmarrant!", german="Whoahoho! Ich habe zufällig\netwas von dir aufgeschnappt, was sich sehr\nlustig anhörte!", italian="Uooh-oh-oh! Per caso ti ho\nsentito dire una cosa che sembrava divertente!", spanish="¡Jo, jo, jo! ¡Te hemos oído\nhablar de algo que parecía interesante!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Something about the [CS:P]Hidden Land[CR].\nChaw-haw-haw!", french="Un truc à propos des [CS:P]Terres\nIllusoires[CR]. Gnark gnark gnark!", german="Etwas über das [CS:P]Verborgene Land[CR].\nCha-ha-ha!", italian="Qualcosa a proposito della\n[CS:P]Terra Nascosta[CR]. Ahr-ahr-ahr!", spanish="Algo sobre una expedición a\nla [CS:P]Tierra Oculta[CR]. ¡Jua, jua, jua!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" I... I was only...", french=" Je... j'étais juste...", german=" Ich... Ich habe nur...", italian=" Io... stavo solo...", spanish=" Yo... Yo solo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_zubatto, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_zubatto, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Huh? Someone's coming!", french=" Hein? Y'a quelqu'un qui arrive!", german=" Hä? Da kommt jemand!", italian=" Eh? Sta arrivando qualcuno!", spanish=" ¿Eh? ¡Alguien viene!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_sukatanku, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_kootasu, Direction.Up)
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Whoa-ho-ho! Guild chumps?", french="Mouarf mouarf mouarf!\nDes crétins de la Guilde?", german=" Whoahoho! Die Gildentrottel?", italian="Uooh-oh-oh! Le schiappe della\nGilda?", spanish="¡Jo, jo, jo!\n¿Esos bobalicones del [CS:N]Pokégremio[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sukatanku, npc_npc_kootasu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kootasu, npc_npc_sukatanku, 4) end)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Down)
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" Old-timer...", french=" Vieillard...", german=" Opa...", italian=" Vecchietto...", spanish=" Abuelete..."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Why don't we take this chat\nsomewhere we won't be disturbed? Chaw-haw!", french="Et si on allait poursuivre\ncette petite causerie à l'abri des regards\nindiscrets? Gnark gnark!", german="Warum setzen wir diesen\nPlausch nicht an einem ungestörteren Ort fort?\nCha-ha!", italian="Perché non continuiamo questa\nchiacchierata dove nessuno ci può disturbare?\nAhr-ahr!", spanish="¿Por qué no seguimos charlando\nen un lugar más tranquilo? ¡Jua, jua, jua!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" Hey...!", french=" Eh...!", german=" Hey!", italian=" Ehi...!", spanish=" ¡Eh!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_zubatto, 200, 184, false, 2)
  GROUND:EntTurn(npc_npc_sukatanku, Direction.Right)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Right)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Right)
  do local p=npc_npc_sukatanku.Position; GROUND:MoveToPosition(npc_npc_sukatanku, p.X+(160), p.Y+(0), false, 2) end
  GAME:WaitFrames(10)
  do local p=npc_npc_kootasu.Position; GROUND:MoveToPosition(npc_npc_kootasu, p.X+(160), p.Y+(0), false, 2) end
  do local p=npc_npc_dogaasu.Position; GROUND:MoveToPosition(npc_npc_dogaasu, p.X+(160), p.Y+(0), false, 2) end
  do local p=npc_npc_zubatto.Position; GROUND:MoveToPosition(npc_npc_zubatto, p.X+(160), p.Y+(0), false, 2) end
  GAME:WaitFrames(60)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitBgm
  -- main_SetGround(LEVEL_G01P04A) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterGround(LEVEL_G01P03A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
