-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/s01p0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  SkyProg.set(29, 2) -- $SCENARIO_MAIN = scn[29,2] (ROM)
  -- back_SetGround(LEVEL_T01P01A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_T01P01A, 'US01') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(8) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  pcall(function() GAME:MoveCamera(416, 220, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 440, 204, false, 2)
  GROUND:MoveToPosition(partner, 440, 228, false, 2)
  local npc_npc_ringuma = SkySceneKit.spawn_npc("ursaring", 248, 208, Direction.Right, "NPC_RINGUMA")
  GROUND:MoveToPosition(npc_npc_ringuma, 392, 204, false, 2)
  local npc_npc_himeguma = SkySceneKit.spawn_npc("teddiursa", 264, 232, Direction.Right, "NPC_HIMEGUMA")
  GROUND:MoveToPosition(npc_npc_himeguma, 392, 228, false, 2)
  GAME:FadeIn(30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_himeguma, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="Oh, [partner] and\n[hero]![K] Hi!", french="Oh, [partner] et\n[hero]![K] Bonjour!", german="Oh, [partner] und\n[hero]![K] Hi!", italian="Oh, [partner] e\n[hero]![K] Ciao!", spanish="¡Vaya, [partner] y\n[hero]![K] ¡Hola!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [CS:N]Teddiursa[CR] and [CS:N]Ursaring[CR]!", french=" Hé, [CS:N]Teddiursa[CR] et [CS:N]Ursaring[CR]!", german=" Hey, [CS:N]Teddiursa[CR] und [CS:N]Ursaring[CR]!", italian=" Ehi, [CS:N]Teddiursa[CR]! [CS:N]Ursaring[CR]!", spanish="¡Pero si son [CS:N]Teddiursa[CR] y\n[CS:N]Ursaring[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey, [CS:N]Teddiursa[CR] and [CS:N]Ursaring[CR]!", french=" Hé, [CS:N]Teddiursa[CR] et [CS:N]Ursaring[CR]!", german=" Hey, [CS:N]Teddiursa[CR] und [CS:N]Ursaring[CR]!", italian=" Ehi, [CS:N]Teddiursa[CR]! [CS:N]Ursaring[CR]!", spanish="¡Pero si son [CS:N]Teddiursa[CR] y\n[CS:N]Ursaring[CR]!"})
  else
  SkySceneKit.say({english=" Hi, [CS:N]Teddiursa[CR] and [CS:N]Ursaring[CR]!", french=" Hé, [CS:N]Teddiursa[CR] et [CS:N]Ursaring[CR]!", german=" Hey, [CS:N]Teddiursa[CR] und [CS:N]Ursaring[CR]!", italian=" Ehi, [CS:N]Teddiursa[CR]! [CS:N]Ursaring[CR]!", spanish="¡Pero si son [CS:N]Teddiursa[CR] y\n[CS:N]Ursaring[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What's up? Are you two going\nout somewhere?", french="Qu'y a-t-il? Où est-ce que\nvous allez comme ça?", german="Alles okay? Geht ihr zwei\nirgendwo hin?", italian="Cosa fate? State andando da\nqualche parte?", spanish=" ¿Qué tal? ¿Vais a alguna parte?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What's going on? Are you going\nout somewhere?", french="Qu'y a-t-il? Où est-ce que\nvous allez comme ça?", german="Was steht an? Geht ihr zwei\nirgendwo hin?", italian="Cosa fate? State andando da\nqualche parte?", spanish="¿Cómo estáis?\n¿Vais a alguna parte?"})
  else
  SkySceneKit.say({english="What's happening? Are you going\nout somewhere?", french="Qu'y a-t-il? Où est-ce que\nvous allez comme ça?", german="Was liegt an? Geht ihr beide\nirgendwo hin?", italian="Cosa fate? State andando da\nqualche parte?", spanish="¿Qué tal estáis?\n¿Vais a alguna parte?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="Yup.[K] We're going off to\n[CS:P]Mystifying Forest[CR] now.", french="Nous partons pour la\n[CS:P]Forêt Trompeuse[CR].", german="Jawohl.[K] Wir sind gerade auf dem\nWeg zum [CS:P]Verwirrwald[CR].", italian="Già.[K] Stiamo andando alla\n[CS:P]Foresta Inganno[CR].", spanish="Sí.[K] Vamos de camino al\n[CS:P]Bosque Misterio[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?![K] [CS:P]Mystifying Forest[CR]?!", french=" Quoi?! [K]La [CS:P]Forêt Trompeuse[CR]?!", german=" Was?!?[K] Der [CS:P]Verwirrwald[CR]?!?", italian=" Cosa?![K] Alla [CS:P]Foresta Inganno[CR]?!", spanish=" ¿Qué?[K] ¿Al [CS:P]Bosque Misterio[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?![K] [CS:P]Mystifying Forest[CR]?!", french=" Quoi?! [K]La [CS:P]Forêt Trompeuse[CR]?!", german=" Was?!?[K] Der [CS:P]Verwirrwald[CR]?!?", italian=" Cosa?![K] Alla [CS:P]Foresta Inganno[CR]?!", spanish=" ¿Qué?[K] ¿Al [CS:P]Bosque Misterio[CR]?"})
  else
  SkySceneKit.say({english=" Pardon?![K] [CS:P]Mystifying Forest[CR]?!", french=" Quoi?! [K]La [CS:P]Forêt Trompeuse[CR]?!", german="Wie bitte?!?[K] Der\n[CS:P]Verwirrwald[CR]?!?", italian=" Scusa?![K] Alla [CS:P]Foresta Inganno[CR]?!", spanish=" ¿Qué?[K] ¿Al [CS:P]Bosque Misterio[CR]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But isn't it dangerous there?", french="Mais il paraît que c'est\ndangereux là-bas!", german=" Ist es da nicht gefährlich?", italian=" Ma non è pericoloso?", spanish=" Pero, ¿no es un lugar peligroso?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But isn't it dangerous there?", french="Mais il paraît que c'est\ndangereux là-bas!", german=" Ist es da nicht gefährlich?", italian=" Ma non è pericoloso?", spanish=" Pero, ¿no es un lugar peligroso?"})
  else
  SkySceneKit.say({english=" But isn't it dangerous there?", french="Mais il paraît que c'est\ndangereux là-bas!", german=" Ist es da nicht gefährlich?", italian=" Ma non è pericoloso?", spanish=" Pero, ¿no es un lugar peligroso?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Didn't you know? The grand\nmaster of all things bad is supposed to\nbe there.", french="Vous ne savez pas? On dit que\nle grand maître de tous les maux vit là-bas.", german="Wusstet ihr das nicht? Der\nGroßmeister allen Übels soll da hausen.", italian="Non lo sapete? Dicono che\nSua Malvagità si trovi lì.", spanish="¿No sabéis que allí vive el gran\nmalo requetemalo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Haven't you heard? The grand\nmaster of all things bad is supposed to\nbe there.", french="Vous ne savez pas? On dit que\nle grand maître de tous les maux vit là-bas.", german="Habt ihr nicht gehört? Der\nGroßmeister allen Übels soll sich da aufhalten.", italian="Non lo sapete? Dicono che\nSua Malvagità si trovi lì.", spanish="¿No sabéis que allí vive el gran\nmalo requetemalo?"})
  else
  SkySceneKit.say({english="Haven't you heard? The grand\nmaster of all things bad is supposed to\nbe there.", french="Vous ne savez pas? On dit que\nle grand maître de tous les maux vit là-bas.", german="Habt ihr nicht gehört? Der\nGroßmeister allen Übels soll sich da aufhalten.", italian="Non lo sapete? Dicono che\nSua Malvagità si trovi lì.", spanish="¿No sabéis que allí vive el gran\nmalo requetemalo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_himeguma, "question", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="The grand master of all\nthings bad?", french="Le grand maître de tous les\nmaux?", german=" Der Großmeister allen Übels?", italian=" Sua Malvagità?", spanish=" ¿El gran malo requetemalo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_ringuma, npc_npc_himeguma, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_himeguma, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="I've never...[K]heard of anything\nlike that.", french="Je n'en ai...[K] jamais entendu\nparler.", german="Von so etwas[K] habe ich noch\nnie gehört.", italian="Non ho mai...[K] sentito niente del\ngenere.", spanish=" Nunca...[K] había oído hablar de él."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_ringuma, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_himeguma, Direction.Right)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="You're sure you're not making\na mistake?", french="J'ai l'impression que vous vous\ntrompez...", german="Und ihr glaubt nicht, dass ihr\neuch irrt?", italian=" Non è che vi state sbagliando?", spanish=" ¿No os habréis equivocado?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="We go play in [CS:P]Mystifying\nForest[CR] often.", french="On va souvent dans la [CS:P]Forêt\nTrompeuse[CR].", german="Wir gehen häufig im\n[CS:P]Verwirrwald[CR] spielen.", italian="Andiamo spesso a giocare\nnella [CS:P]Foresta Inganno[CR].", spanish="Solemos ir a jugar al [CS:P]Bosque[CR]\n[CS:P]Misterio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="We've never seen or even heard\nof a grand master.", french="On n'a jamais entendu parler\nd'un grand maître.", german="Wir haben noch nie von einem\nGroßmeister gehört, geschweige denn ihn\ngesehen.", italian="Non abbiamo mai visto o sentito\nparlare di Sua Malvagità.", spanish="Nunca hemos visto a ningún gran\nmalo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="You must have misheard a bad\nrumor or something.", french="Ça doit être une rumeur,\nvous devez vous tromper.", german="Ihr müsst irgendwelchen\nGerüchten erlegen sein, oder so.", italian=" Saranno state solo delle dicerie.", spanish=" Debe de ser un rumor infundado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_ringuma, npc_npc_himeguma, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_himeguma, npc_npc_ringuma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Let's go.", french=" Allons-y.", german=" Gehen wir.", italian=" Andiamo.", spanish=" Vamos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_himeguma, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" Bye.", french=" A plus.", german=" Tschüss.", italian=" Ciao.", spanish=" Adiós."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(456, 220, 60, false) end) -- performer/caméra
  do local p=npc_npc_ringuma.Position; GROUND:MoveToPosition(npc_npc_ringuma, p.X+(260), p.Y+(0), false, 2) end
  GAME:WaitFrames(5)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(32), p.Y+(32), false, 2) end -- Move2PositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-8), p.Y+(8), false, 2) end -- Move2PositionOffset
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(hero, Direction.Up)
  do local p=npc_npc_himeguma.Position; GROUND:MoveToPosition(npc_npc_himeguma, p.X+(260), p.Y+(-16), false, 2) end
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[K]Something's strange.", french="...[K] Il y a quelque chose qui\ncloche.", german=" ...[K]Da ist etwas faul.", italian="...[K] C'è qualcosa di\nstrano.", spanish=" Eh...[K] Qué extraño."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[K]Something's not right.", french="...[K] Il y a quelque chose qui\ncloche.", german=" ...[K]Irgendetwas stimmt nicht.", italian="...[K] C'è qualcosa di\nstrano.", spanish=" Eh...[K] Algo no cuadra aquí."})
  else
  SkySceneKit.say({english=" ...[K]Something's not right.", french="...[K] Il y a quelque chose qui\ncloche.", german=" ...[K]Irgendetwas stimmt nicht.", italian="...[K] C'è qualcosa di\nstrano.", spanish=" Eh...[K] Qué raro."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It sounds awfully different\nfrom what [CS:N]Wigglytuff[CR] said.", french="C'est quasiment le contraire\nde ce que nous a dit [CS:N]Grodoudou[CR].", german="Das klingt irgendwie gar nicht\nwie das, was [CS:N]Knuddeluff[CR] gesagt hat.", italian="Sembra tutta un'altra storia\nrispetto a quella che ci ha raccontato\n[CS:N]Wigglytuff[CR].", spanish="Nada que ver con lo que dijo\n[CS:N]Wigglytuff[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That doesn't sound anything like\nwhat [CS:N]Wigglytuff[CR] said.", french="C'est quasiment le contraire\nde ce que nous a dit [CS:N]Grodoudou[CR].", german="Das klingt überhaupt nicht wie\ndas, was [CS:N]Knuddeluff[CR] gesagt hat.", italian="Sembra tutta un'altra storia\nrispetto a quella che ci ha raccontato\n[CS:N]Wigglytuff[CR].", spanish="Nada que ver con lo que dijo\n[CS:N]Wigglytuff[CR]."})
  else
  SkySceneKit.say({english="It sounds completely unlike what\n[CS:N]Wigglytuff[CR] told us.", french="C'est quasiment le contraire\nde ce que nous a dit [CS:N]Grodoudou[CR].", german="Das klingt völlig anders als das,\nwas [CS:N]Knuddeluff[CR] gesagt hat.", italian="Sembra tutta un'altra storia\nrispetto a quella che ci ha raccontato\n[CS:N]Wigglytuff[CR].", spanish="No concuerda con lo que dijo\n[CS:N]Wigglytuff[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Well, there's not much we\ncan do about it.[K] Let's get ready and go out to\n[CS:P]Mystifying Forest[CR].", french="Tant pis, on ne peut rien y faire.\nPréparons-nous à partir pour la [CS:P]Forêt\nTrompeuse[CR].", german="Nun, daran können wir nicht viel\nändern.[K] Machen wir uns bereit, um uns dann\nzum [CS:P]Verwirrwald[CR] zu begeben.", italian="Beh, non c'è molto che possiamo\nfare.[K] Prepariamoci e andiamo alla\n[CS:P]Foresta Inganno[CR].", spanish="Bueno, qué le vamos a hacer.[K]\nPreparémonos para ir al [CS:P]Bosque Misterio[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's not as if we can do anything\nabout it.[K] Let's get ready and go out to\n[CS:P]Mystifying Forest[CR].", french="Tant pis, on ne peut rien y faire.\nPréparons-nous à partir pour la [CS:P]Forêt\nTrompeuse[CR].", german="Nicht, dass wir irgendetwas\ndaran ändern könnten.[K] Machen wir uns fertig,\num uns dann zum [CS:P]Verwirrwald[CR] zu begeben.", italian="Beh, non c'è molto che possiamo\nfare.[K] Prepariamoci e andiamo alla\n[CS:P]Foresta Inganno[CR].", spanish="Bueno, qué le vamos a hacer.[K]\nPreparémonos para ir al [CS:P]Bosque Misterio[CR]."})
  else
  SkySceneKit.say({english="It's not as if we can do anything\nabout it.[K] Let's get ready and go out to\n[CS:P]Mystifying Forest[CR].", french="Tant pis, on ne peut rien y faire.\nPréparons-nous à partir pour la [CS:P]Forêt\nTrompeuse[CR].", german="Nicht, dass wir irgendetwas\ndaran ändern könnten.[K] Machen wir uns fertig,\num uns dann zum [CS:P]Verwirrwald[CR] zu begeben.", italian="Beh, non c'è molto che possiamo\nfare.[K] Prepariamoci e andiamo alla\n[CS:P]Foresta Inganno[CR].", spanish="Y qué le vamos a hacer.[K]\nPreparémonos para ir al [CS:P]Bosque Misterio[CR]."})
  end
  -- message_Close
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[44] = 1 -- dungeon_mode(44) = DMODE_OPEN (ROM)
  SkySceneKit.cleanup_npcs()
end
