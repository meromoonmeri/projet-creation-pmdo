-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m04a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[1] = 3 -- dungeon_mode(1) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[3] = 3 -- dungeon_mode(3) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[4] = 3 -- dungeon_mode(4) = DMODE_OPEN_AND_REQUEST (ROM)
  SkyProg.set(5, 1) -- $SCENARIO_MAIN = scn[5,1] (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[4] = 1 -- $PERFORMANCE_PROGRESS_LIST[4] = 1 (ROM)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(484, 252, 1, false) end) -- SetPositionMark performer/caméra
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:StopBGM() end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 288, 272, Direction.Right, "NPC_DOGOOMU")
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end) -- message_SetActor(ACTOR_NPC_DOGOOMU)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" HEY, you two!", french=" HEP LA, vous deux!", german=" HEY, ihr zwei!", italian=" EHI, voi due!", spanish=" ¡EH! ¡PAREJA!"})
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_dogoomu, 4) end)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_dogoomu, 416, 268, false, 2)
  pcall(function() GAME:MoveCamera(448, 252, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_dogoomu, 4) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="We need your help with\nsomething today!", french="On a besoin de votre aide\naujourd'hui!", german=" Wir brauchen heute eure Hilfe!", italian="Oggi ci serve il vostro aiuto\nper una cosetta!", spanish="¡Hoy necesitamos que nos\nayudéis con una cosa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  pcall(function() GAME:MoveCamera(196, 252, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_dogoomu, 208, 268, false, 2)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 280, 268, false, 2)
  GAME:WaitFrames(7)
  GROUND:MoveToPosition(hero, 264, 252, false, 2)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" [CS:N]Diglett[CR], I brought them!", french=" [CS:N]Taupiqueur[CR], les voilà!", german=" [CS:N]Digda[CR], hier sind sie!", italian=" [CS:N]Diglett[CR], ecco qui!", spanish=" ¡[CS:N]Diglett[CR], aquí están!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 160, 304, Direction.Right, "NPC_DIGUDA")
  GROUND:EntTurn(npc_npc_diguda, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Thank you, [CS:N]Loudred[CR].", french=" Merci, [CS:N]Ramboum[CR].", german=" Danke, [CS:N]Krakeelo[CR].", italian=" Grazie, [CS:N]Loudred[CR].", spanish=" Gracias, [CS:N]Loudred[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_diguda, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_dogoomu, 168, 284, false, 2)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.UpLeft)
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="You two are doing sentry\nduty today!", french="Aujourd'hui, vous allez être\nde garde à l'entrée!", german="Ihr beide übernehmt heute den\nWachdienst!", italian=" Voi due siete di guardia oggi!", spanish=" ¡Hoy os toca guardia!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_diguda, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_diguda, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diguda, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Sorry. I'm usually the one to do\nsentry duty.", french="Désolé. Normalement, c'est moi\nla sentinelle.", german="Tut mir leid. Normalerweise ist\nder Wachdienst meine Aufgabe.", italian=" Mi spiace. Di solito lo faccio io.", spanish="Lo siento. Normalmente soy yo\nquien se ocupa de esto."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="But today, my dad gave me his\nduty of updating the boards.", french="Mais aujourd'hui, je dois\naccomplir les tâches de mon père,\nc'est-à-dire mettre les tableaux à jour.", german="Aber heute hat mein Vater mir\naufgetragen, die Infobretter zu aktualisieren.", italian="Ma oggi mio padre mi ha chiesto\ndi aggiornare le Bacheche al suo posto.", spanish="Pero mi padre me ha pedido\nque me encargue hoy de poner al día\nlos tablones."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" That's why I can't man my post.", french="Et c'est pour ça que je ne peux\npas être à mon poste.", german="Also kann ich nicht auf meinem\nPosten sein.", italian="Per questo non posso stare di\nguardia.", spanish="Y por eso no puedo quedarme de\nguardia."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="It would be great if someone\ncould take over my sentry duty for today.", french="Ce serait super si quelqu'un\npouvait s'occuper du poste de garde\naujourd'hui.", german="Es wäre toll, wenn heute jemand\nden Wachdienst für mich übernehmen könnte.", italian="Sarebbe fantastico se qualcuno\npotesse prendere il mio posto.", spanish=" Y alguien debe ocupar mi puesto."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="And that's why you're here.\nPlease do a good job for me.[K] Bye!", french="Et c'est pour ça que vous êtes\nici. S'il vous plaît, travaillez bien.[K] A plus!", german="Und darum seid ihr hier.\nBitte macht meinen Job gut.[K] Tschüss!", italian="Ed ecco perché siete qui.\nVi prego di fare un buon lavoro.[K] Ciao!", spanish="Por eso estáis aquí. Espero\nque hagáis un buen trabajo.[K] ¡Hasta luego!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6422) — id SE NDS sans portage PMDO identifié
  GROUND:EntTurn(npc_npc_diguda, Direction.Down)
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" ...And that's THAT.", french=" ... Et c'est TOUT.", german=" Das ist ALLES!", italian=" ... E così è DECISO.", spanish=" Pues... No hay más que hablar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Huh?! I didn't follow that at all!\nWhy are we involved?", french="Euh... j'ai pas tout suivi!\nQu'est-ce qu'on fait là?", german="Ähem?!? Ich habe das nicht\nganz mitbekommen! Warum hast du uns geholt?", italian="Eh?! Cos'ha detto?\nPerché dobbiamo farlo noi?", spanish="¿Eh? ¡No me he enterado\nde nada! ¿Por qué nos ha tenido que tocar?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Huh?! I didn't follow that at all!\nWhy are we involved in this?", french="Euh... j'ai pas tout suivi!\nQu'est-ce qu'on fait là?", german="Ähem?!? Ich habe das nicht\nganz mitbekommen! Warum hast du uns geholt?", italian="Eh?! Non sono riuscito a seguire\nquello che diceva! Perché dobbiamo farlo noi?", spanish="¿Eh? ¡No me he enterado\nde nada! ¿Por qué nos ha tenido que tocar?"})
  else
  SkySceneKit.say({english="Huh?! I didn't follow that at all!\nHow did we get involved in this?", french="Euh... j'ai pas tout suivi!\nQu'est-ce qu'on fait là?", german="Ähem?!? Ich habe das nicht\nganz mitbekommen! Warum hast du uns geholt?", italian="Eh?! Cosa voleva dire?\nPerché dobbiamo farlo noi?", spanish="¿Eh? ¡No me he enterado\nde nada! ¿Por qué nos ha tenido que tocar?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- SetAnimation(68) [anim idle native]
  -- SetAnimation(68) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitSe
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Shut your YAP!", french=" On se TAIT!", german=" Halt die KLAPPE!", italian=" Chiudi il BECCO!", spanish=" ¡Cerrad el pico!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="NO MORE BELLYACHING!\nGO DO YOUR DUTY!", french="FINI LES RONCHONNEMENTS!\nA VOS POSTES!", german="KEIN GEMURRE MEHR!\nGEHT UND TUT EURE PFLICHT!", italian="BASTA LAMENTARSI!\nAL LAVORO!", spanish="¡BASTA DE GIMOTEAR!\n¡ID A CUMPLIR CON VUESTRO DEBER!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh... My head hurts...", french="Argh... Bonjour les maux de\ntête...", german=" Argh, mein Kopf tut weh.", italian=" Ugh... Mi fa male la testa...", spanish="Ay... Tengo la cabeza como un\nbombo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ow... My head is pounding...", french="Argh... Bonjour les maux de\ntête...", german=" Au, mir tut der Kopf weh.", italian=" Ahi... Che mal di testa...", spanish=" Uf... Qué dolor de cabeza..."})
  else
  SkySceneKit.say({english=" Ow... My head hurts...", french="Argh... Bonjour les maux de\ntête...", german=" Au, mir tut der Kopf weh.", italian=" Ahi... Mi gira la testa...", spanish=" Uf... Mi cabeza..."})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(45)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What do you expect us to do,\nanyway?", french=" Qu'est-ce qu'on doit faire?", german=" Was sollen wir überhaupt tun?", italian=" Cosa dobbiamo fare?", spanish=" ¿Y qué tenemos que hacer?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What are we supposed to do?", french=" Qu'est-ce qu'on doit faire?", german=" Was sollen wir überhaupt tun?", italian=" Cosa dobbiamo fare?", spanish=" ¿Y qué tenemos que hacer?"})
  else
  SkySceneKit.say({english="What are we expected to do,\nanyway?", french=" Qu'est-ce qu'on doit faire?", german=" Was sollen wir eigentlich tun?", italian=" Cosa dobbiamo fare?", spanish=" ¿Y qué tenemos que hacer?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Climb down this hole and\nstand guard. You're on sentry duty!", french="Descendez dans ce trou et\nmontez la garde. Aujourd'hui, vous êtes\nau poste de garde!", german="Klettert dieses Loch hinunter und\nhaltet Wache. Ihr habt Wachdienst!", italian="Dovete scendere in questo buco\nper fare il turno di guardia!", spanish="Bajad por aquí y vigilad.\n¡Estáis de guardia!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Sentry duty?", french=" Au poste de garde?", german=" Wachdienst?", italian=" Turno di guardia?", spanish=" ¿De guardia?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Sentry duty?", french=" Au poste de garde?", german=" Wachdienst?", italian=" Turno di guardia?", spanish=" ¿De guardia?"})
  else
  SkySceneKit.say({english=" Sentry duty?", french=" Au poste de garde?", german=" Wachdienst?", italian=" Turno di guardia?", spanish=" ¿De guardia?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.UpLeft)
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" You heard right.[K] Sentry duty.", french="Vous avez bien entendu.[K]\nAu poste de garde.", german=" Richtig gehört.[K] Wachdienst.", italian="Avete sentito bene.[K] Dovete\nfare la guardia.", spanish=" Habéis oído bien.[K] De guardia."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="We can't have suspicious\ncharacters coming into the guild.", french="Il ne faut pas que des individus\nsuspects puissent entrer à la Guilde.", german="Wir müssen vermeiden, dass\nzwielichtige Gestalten in die Gilde kommen.", italian="Dobbiamo evitare che Pokémon\nsospetti entrino alla Gilda.", spanish="No podemos permitir que entren\nindividuos sospechosos en el [CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="So we station a sentry below the\nguild entrance to evaluate Pokémon visitors.", french="On a donc installé un système\nde sentinelle sous l'entrée de la Guilde\npour identifier les visiteurs.", german="Also ist unter dem Gildeneingang\neine Wache stationiert, die besuchende\nPokémon überprüft.", italian="Quindi c'è una guardia sotto\nla Gilda per controllare i Pokémon che\nvengono qui.", spanish="Así que ponemos a un vigía bajo\nla puerta para comprobar quién quiere entrar."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="When you first came, you had\nyour footprint evaluated, right?", french="Lors de votre première visite,\non a identifié vos empreintes, pas vrai?", german="Als ihr zum ersten Mal kamt,\nwurden eure Fußabdrücke überprüft, oder?", italian="La prima volta che avete fatto\nvisita alla Gilda le vostre zampe sono state\nesaminate, giusto?", spanish="Cuando llegaste se comprobó\ntu huella, ¿no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" My footprint?[K] What do you...?", french="Mes empreintes?[K] Qu'est-ce que\ntu...?", german=" Mein Fußabdruck?[K] Was?", italian=" La mia zampa?[K] Cosa...?", spanish=" ¿Mi huella?[K] ¿Qué quieres...?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" My footprint?[K] What do you...?", french="Mes empreintes?[K] Qu'est-ce que\ntu...?", german=" Mein Fußabdruck?[K] Was?", italian=" La mia zampa?[K] Cosa...?", spanish=" ¿Mi huella?[K] ¿Qué quieres...?"})
  else
  SkySceneKit.say({english=" My footprint?[K] What do you...?", french="Mes empreintes?[K] Qu'est-ce que\ntu...?", german=" Mein Fußabdruck?[K] Was?", italian=" La mia zampa?[K] Cosa...?", spanish=" ¿Mi huella?[K] ¿Qué quieres...?"})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
