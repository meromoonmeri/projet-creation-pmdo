-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m13a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetBanner2(LEVEL_V03P12A, 0, 168, 128, 11) [bannière 2e écran NDS: information dupliquée du menu, hors canvas unique - documenté]
  GAME:FadeIn(45)
  GAME:WaitFrames(160)
  GAME:FadeOut(false, 45)
  GAME:WaitFrames(15)
  SkyProg.set(14, 1) -- $SCENARIO_MAIN = scn[14,1] (ROM)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 336, 128, Direction.Up, "NPC_BIPPA")
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Huff-puff...", french=" Pff, pff...", german=" Keuch, keuch...", italian=" Pant... pant...", spanish=" Uf, uf."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Come on! Hurry!", french=" Allez! On s'grouille!", german=" Kommt! Beeilung!", italian=" Forza! Sbrigatevi!", spanish=" ¡Vamos! ¡Rápido!"})
  -- message_Close
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(4) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 416, 264, Direction.Up, "NPC_GUREGGURU")
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "happy", 1) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 472, 264, Direction.Up, "NPC_KIMAWARI")
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 392, 232, Direction.UpRight, "NPC_DIGUDA")
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 464, 224, Direction.Up, "NPC_PERAPPU")
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 448, 264, Direction.Up, "NPC_HEIGANI")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 424, 248, Direction.Up, "NPC_DAGUTORIO")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 432, 232, Direction.Up, "NPC_CHIRIIN")
  -- SetAnimation(4) [anim idle native]
  -- GAP: se_Play(6669) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(0), p.Y+(56), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(20)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(56), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(20)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(0), p.Y+(48), false, 2) end
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(56), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(partner, 332, 228, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 356, 228, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(hero, 332, 212, false, 2)
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 336, 128, Direction.Up, "NPC_YONOWAARU")
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_yonowaaru, p.X+(0), p.Y+(56), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(npc_npc_bippa, Direction.Right)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(npc_npc_yonowaaru, 332, 196, false, 2)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Everyone's here, yup yup!", french=" Tout l'monde est là, pour sûr!", german=" Alle sind hier, jawollja!", italian=" Ci siamo tutti, sissignore!", spanish=" Ya estamos todos, ¡sí, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- se_FadeOut(6669, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  pcall(function() GAME:MoveCamera(440, 248, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_bippa, 404, 228, false, 2)
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "exclaim", 1) end)
  GROUND:EntTurn(npc_npc_diguda, Direction.Left)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_diguda, 392, 256, false, 2)
  GROUND:MoveToPosition(hero, 384, 212, false, 2)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_chiriin, Direction.Left)
  GROUND:MoveToPosition(npc_npc_chiriin, 448, 244, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(partner, 384, 228, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_yonowaaru, 360, 228, false, 2)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_diguda, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Left)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_guregguru, Direction.UpLeft)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 480, 208, Direction.UpLeft, "NPC_PUKURIN")
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 480, 248, Direction.Up, "NPC_DOGOOMU")
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Left)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Sorry, everyone!", french=" Désolé, vous autres!", german=" Tut mir leid, Leute!", italian=" Scusate il ritardo!", spanish=" Sentimos el retraso."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Sorry, everyone!", french=" Désolé, vous autres!", german=" Tut mir leid, Leute!", italian=" Scusate il ritardo!", spanish=" Sentimos el retraso."})
  else
  SkySceneKit.say({english=" Sorry, everyone!", french=" Désolée, vous autres!", german=" Tut mir leid, Leute!", italian=" Scusate il ritardo!", spanish=" Sentimos el retraso."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We just got told that the call\nwent out, so we came running!", french="On vient juste d'apprendre\nqu'on battait le rappel, alors on a accouru!", german="Wir haben gerade erst gehört,\ndass wir zur Gilde kommen sollen, und haben\nuns beeilt!", italian="Eccoci, abbiamo saputo che ci\navete chiamato!", spanish="Nos acabamos de enterar de\nque había una reunión, así que hemos\ntenido que venir corriendo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We just got told that the call\nwent out, so we came running!", french="On vient juste d'apprendre\nqu'on battait le rappel, alors on a accouru!", german="Wir haben gerade erst gehört,\ndass wir zur Gilde kommen sollen, und haben\nuns beeilt!", italian="Eccoci, abbiamo saputo che ci\navete chiamato!", spanish="Nos acabamos de enterar de\nque había una reunión, así que hemos\ntenido que venir corriendo."})
  else
  SkySceneKit.say({english="We just got told that the call\nwent out, so we came running!", french="On vient juste d'apprendre\nqu'on battait le rappel, alors on a accouru!", german="Wir haben gerade erst gehört,\ndass wir zur Gilde kommen sollen, und haben\nuns beeilt!", italian="Eccoci, abbiamo saputo che ci\navete chiamato!", spanish="Nos acabamos de enterar de\nque había una reunión, así que hemos\ntenido que venir corriendo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So, what's up?", french=" Alors, qu'est-ce qui se passe?", german=" Also, was gibt es?", italian=" Che succede?", spanish=" ¿Qué es lo que ocurre?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What's going on?", french=" Alors, qu'est-ce qui se passe?", german=" Was ist denn los?", italian=" Cos'è successo?", spanish=" ¿Qué es lo que ocurre?"})
  else
  SkySceneKit.say({english=" What's going on?", french=" Alors, qu'est-ce qui se passe?", german=" Was ist denn los?", italian=" Cos'è successo?", spanish=" ¿Qué es lo que ocurre?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Another Time Gear was stolen!", french="On a volé un autre Rouage\ndu Temps!", german="Es wurde noch ein Zahnrad der\nZeit gestohlen!", italian="È stato rubato un altro\nIngranaggio del Tempo!", spanish="¡Han robado otro Engranaje\ndel Tiempo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" What?![K] Not another one!", french=" Heiiin?![K] Encore un!", german=" Was?!?[K] Nicht noch eins!", italian=" Cosa?[K] Non è possibile!", spanish=" ¡¿Qué?![K] ¡Otro no!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Growing Anxiety.ogg", true) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" From where now...?", french=" Où ça, cette fois-ci...?", german=" Von wo diesmal?", italian="Quale è stato rubato questa\nvolta?", spanish=" ¿Dónde ha sido esta vez?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" From where now...?", french=" Où ça, cette fois-ci...?", german=" Von wo diesmal?", italian="Quale è stato rubato questa\nvolta?", spanish=" ¿Dónde ha sido esta vez?"})
  else
  SkySceneKit.say({english=" From where now...?", french=" Où ça, cette fois-ci...?", german=" Von wo diesmal?", italian="Quale è stato rubato questa\nvolta?", spanish=" ¿Dónde ha sido esta vez?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Where was this Time Gear\nstolen from?", french="Où a-t-on volé un Rouage\ndu Temps?", german="Wo wurde dieses Zahnrad\nder Zeit gestohlen?", italian=" Da dove proveniva?", spanish="¿Dónde han robado el Engranaje\ndel Tiempo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Where was this Time Gear\nstolen from?", french="Où a-t-on volé un Rouage\ndu Temps?", german="Wo wurde dieses Zahnrad\nder Zeit gestohlen?", italian=" Da dove proveniva?", spanish="¿Dónde han robado el Engranaje\ndel Tiempo?"})
  else
  SkySceneKit.say({english="Where was this Time Gear\nstolen from?", french="Où a-t-on volé un Rouage\ndu Temps?", german="Wo wurde dieses Zahnrad\nder Zeit gestohlen?", italian=" Da dove proveniva?", spanish="¿Dónde han robado el Engranaje\ndel Tiempo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" W-well, it...", french=" Eh bien, il...", german=" N-nun, es...", italian=" E-Ecco... Si t-tratta di...", spanish=" Esto..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Uh...what's the problem?", french="Ben alors... c'est quoi\nl'problème?", german=" Äh, was ist?", italian=" Uh? Cosa c'è?", spanish=" ¿Qué... qué pasa?"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Did it happen somewhere you\ndon't want to talk about?", french="Vous voulez pas nous dire où\nqu'c'était?", german="War es an einem Ort, von dem\ndu nicht sprechen willst?", italian="È come se non volessi dirci\ndov'è successo...", spanish="¿Ha ocurrido en algún sitio del\nque no quieres hablar?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Wait![K] Tell me it wasn't the one\nfrom...", french="Une minute![K] Ne me dites pas que\nc'était celui de...", german=" Warte![K] Sag nicht, es war vom...", italian="Un momento![K] Non dirmi che si\ntratta di quello...", spanish="¡Espera![K] No me digas que\nha sido el que había en..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wait![K] It wasn't the one from...", french="Une minute![K] Ne me dites pas que\nc'était celui de...", german=" Warte![K] Es war doch nicht vom...", italian="Un momento![K] Non dirmi che si\ntratta di quello...", spanish="¡Espera![K] No me digas que\nha sido el que había en..."})
  else
  SkySceneKit.say({english=" Wait![K] It wasn't the one from...", french="Une minute![K] Ne me dites pas que\nc'était celui de...", german=" Warte![K] Es war doch nicht vom...", italian="Un momento![K] Non dirmi che si\ntratta di quello...", spanish="¡Espera![K] No me digas que\nha sido el que había en..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Yes...[K]it was!", french=" Si...[K] c'est bien celui-là!", german=" Doch...[K] Das war es!", italian="Proprio così...[K] Si tratta di\nquello!", spanish=" Sí...[K] En efecto."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="This time...[K]the Time Gear from\n[CS:P]Fogbound Lake[CR] was stolen.", french="Cette fois-ci...[K] c'est le Rouage\ndu Temps du [CS:P]Lac des Brumes[CR] qui a disparu.", german="Diesmal[K] wurde das Zahnrad der\nZeit aus dem [CS:P]Nebelsee[CR] gestohlen.", italian="Questa volta...[K] è\nl'Ingranaggio del Tempo situato al [CS:P]Lago Foschia[CR]\nad essere stato rubato.", spanish="Esta vez...[K] han robado\nel Engranaje del Tiempo del [CS:P]Lago Velado[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Huh?!", french=" Heiiin?!", german=" Was?!?", italian=" Eeeh?!", spanish=" ¡¿Qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But, how?!", french=" Mais comment?!", german=" Aber wie?!?", italian=" Com'è possibile?", spanish=" ¡¿Pero cómo ha podido ser?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" B-but, how?!", french=" Mais comment?!", german=" A-aber wie?!?", italian=" Com'è possibile?", spanish=" ¡¿Pero cómo ha podido ser?!"})
  else
  SkySceneKit.say({english=" B-but, how?!", french=" Mais comment?!", german=" A-aber wie?!?", italian=" Com'è possibile?", spanish=" ¡¿Pero cómo ha podido ser?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The Time Gear that was at\n[CS:P]Fogbound Lake[CR]...", french="La Rouage du Temps du [CS:P]Lac\ndes Brumes[CR]...", german="Das Zahnrad der Zeit aus dem\n[CS:P]Nebelsee[CR]...", italian="L'Ingranaggio del Tempo che si\ntrovava al [CS:P]Lago Foschia[CR]...", spanish="El Engranaje del Tiempo del\n[CS:P]Lago Velado[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The Time Gear that was at\n[CS:P]Fogbound Lake[CR]...", french="La Rouage du Temps du [CS:P]Lac\ndes Brumes[CR]...", german="Das Zahnrad der Zeit aus dem\n[CS:P]Nebelsee[CR]...", italian="L'Ingranaggio del Tempo che si\ntrovava al [CS:P]Lago Foschia[CR]...", spanish="El Engranaje del Tiempo del\n[CS:P]Lago Velado[CR]..."})
  else
  SkySceneKit.say({english="The Time Gear that was at\n[CS:P]Fogbound Lake[CR]...", french="La Rouage du Temps du [CS:P]Lac\ndes Brumes[CR]...", german="Das Zahnrad der Zeit aus dem\n[CS:P]Nebelsee[CR]...", italian="L'Ingranaggio del Tempo che si\ntrovava al [CS:P]Lago Foschia[CR]...", spanish="El Engranaje del Tiempo del\n[CS:P]Lago Velado[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Only we knew about that, right?", french="On était les seuls à connaître\nson emplacement, pas vrai?", german=" Davon wussten nur wir, oder?", italian="Eravamo gli unici a conoscere\nquel posto. Giusto?", spanish="Era algo que solo conocíamos\nnosotros, ¿verdad?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Only we knew about that, right?", french="On était les seuls à connaître\nson emplacement, pas vrai?", german=" Davon wussten nur wir, oder?", italian="Eravamo gli unici a conoscere\nquel posto. Giusto?", spanish="Era algo que solo sabíamos\nnosotros, ¿no?"})
  else
  SkySceneKit.say({english=" Only we knew about that, right?", french="On était les seuls à connaître\nson emplacement, pas vrai?", german=" Davon wussten nur wir, oder?", italian="Eravamo gli unici a conoscere\nquel posto. Giusto?", spanish="Solo nosotros sabíamos que\nestaba allí, ¿verdad?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So, what happened?!", french=" Alors, comment ça se fait?!", german=" Was ist also passiert?!?", italian=" Come può essere successo?", spanish=" Entonces, ¿cómo ha ocurrido?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So how could this happen?!", french=" Alors, comment ça se fait?!", german=" Wie konnte das also geschehen?", italian=" Come può essere successo?", spanish=" ¿Cómo ha podido suceder?"})
  else
  SkySceneKit.say({english=" So how could this happen?!", french=" Alors, comment ça se fait?!", german=" Wie konnte das also geschehen?", italian=" Come può essere successo?", spanish=" ¿Cómo ha podido suceder?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" ........................", french=" ........................", german=" .........", italian=" ........................", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It couldn't be...[K]that a member of\nthe guild talked, could it?!", french="Est-ce que...[K] un membre\nde la Guilde aurait parlé?!", german="Kann es sein,[K] dass ein Mitglied\nder Gilde es verraten hat?!?", italian="È impossibile...[K] che un membro\ndella Gilda lo abbia preso, vero?", spanish="Puede que...[K] algún miembro\ndel [CS:N]Pokégremio[CR] se haya ido de la lengua, ¿no?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It couldn't be...[K]that a member of\nthe guild talked, could it?!", french="Est-ce que...[K] un membre\nde la Guilde aurait parlé?!", german="Kann es sein,[K] dass ein Mitglied\nder Gilde es verraten hat?!?", italian="È impossibile...[K] che un membro\ndella Gilda lo abbia preso, vero?", spanish="Puede que...[K] algún miembro\ndel [CS:N]Pokégremio[CR] se haya ido de la lengua, ¿no?"})
  else
  SkySceneKit.say({english="It couldn't be...[K]that a member of\nthe guild talked, could it?!", french="Est-ce que...[K] un membre\nde la Guilde aurait parlé?!", german="Kann es sein,[K] dass ein Mitglied\nder Gilde es verraten hat?!?", italian="È impossibile...[K] che un membro\ndella Gilda lo abbia preso, vero?", spanish="Puede que...[K] algún miembro\ndel [CS:N]Pokégremio[CR] se haya ido de la lengua, ¿no?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(4) [anim idle native]
  -- GAP: se_Play(8970) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "angry", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "angry", 1) end)
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" WHAT?! That was uncalled for!", french=" QUOI?! Pour qui tu nous prends?", german="WAS?!? Das ist eine\nunangebrachte Unterstellung!", italian=" COSA??? Ma cosa dici!!!", spanish=" ¡¿Qué?! ¿A qué viene eso?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey, hey! Don't trust your\nfellow members?!", french="Eh dis donc, tu n'as pas\nconfiance en nous ou quoi?!", german="Hey, hey, hey! Vertraut ihr\neuren Freunden nicht?!?", italian="Ehi, ehi, ehi! Non ti fidi nemmeno\ndei tuoi compagni?!", spanish="¡Oye, oye, oye!\n¡¿No confías en tus compañeros?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk! Sorry! You guys are right...", french="Argh! Désolé, vous avez\nraison...", german="Urk! Tut mir leid!\nIhr habt recht...", italian="Oops! Scusate, ragazzi... Avete\nragione...", spanish=" ¡Ay! Perdonadme, tenéis razón."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Urk! Sorry! That was uncalled\nfor, you're right...", french="Argh! Désolé, vous avez\nraison...", german="Urk! Tut mir leid! Das war\nunangebracht, ihr habt recht...", italian="Oops! Scusate, ragazzi... Avete\nragione...", spanish="¡Ay! Perdonadme.\nEs verdad, no debería haber dicho eso."})
  else
  SkySceneKit.say({english="Urk! Sorry! That was uncalled\nfor, you're right...", french="Argh! Désolée, vous avez\nraison...", german="Urk! Tut mir leid! Das war\nunangebracht, ihr habt recht...", italian="Oops! Scusate, ragazzi... Avete\nragione...", spanish="¡Ay! Perdonadme.\nEs verdad, no debería haber dicho eso."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="No one would break our promise\nto keep that a secret...[K] It'd just never happen!", french="Personne ne manquerait\nà sa promesse de garder le secret...[K]\nC'est tout simplement impossible!", german="Niemand hier würde unser\nVersprechen brechen, das Geheimnis zu\nhüten...[K] Nie im Leben!", italian="Nessuno di noi infrangerebbe mai\nla promessa che abbiamo fatto.[K] Nessuno!", spanish="Ninguno de nosotros rompería\nla promesa que hicimos.[K] ¡Ninguno!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="No one would break our vow of\nsecrecy...[K] It'd just never happen!", french="Personne ne manquerait\nà sa promesse de garder le secret...[K]\nC'est tout simplement impossible!", german="Niemand hier würde das\ngegebene Wort brechen, Stillschweigen\nzu bewahren...[K] Nie im Leben!", italian="Nessuno di noi infrangerebbe mai\nla promessa che abbiamo fatto.[K] Nessuno!", spanish="Ninguno de nosotros rompería\nla promesa que hicimos.[K] ¡Ninguno!"})
  else
  SkySceneKit.say({english="No one would break our promise\nto keep that a secret...[K] It'd just never happen!", french="Personne ne manquerait\nà sa promesse de garder le secret...[K]\nC'est tout simplement impossible!", german="Niemand hier würde unser\nVersprechen brechen, das Geheimnis zu\nhüten...[K] Nie im Leben!", italian="Nessuno di noi infrangerebbe mai\nla promessa che abbiamo fatto.[K] Nessuno!", spanish="Ninguno de nosotros rompería\nla promesa que hicimos.[K] ¡Ninguno!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I should have thought first...[K]\nI'm sorry!", french="J'aurais dû réfléchir avant\nde parler...[K] Excusez-moi!", german="Ich hätte zuerst nachdenken\nsollen...[K] Tut mir leid!", italian="Avrei dovuto riflettere prima di\nparlare...[K] Mi dispiace!", spanish="Debería haber pensado un poco\nantes de abrir la boca...[K] Lo siento mucho."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I should have thought before I\nspoke...[K] I'm sorry!", french="J'aurais dû réfléchir avant\nde parler...[K] Excusez-moi!", german="Ich hätte nachdenken sollen,\nbevor ich den Mund aufmache...[K] Tut mir leid!", italian="Avrei dovuto riflettere prima di\nparlare...[K] Mi dispiace!", spanish="Debería haber pensado un poco\nantes de abrir la boca...[K] Lo siento mucho."})
  else
  SkySceneKit.say({english="I wasn't thinking. I know no one\nwould ever do that...[K] I'm sorry.", french="J'aurais dû réfléchir avant\nde parler...[K] Excusez-moi!", german="Ich habe nicht nachgedacht.\nNiemand würde so etwas tun...[K] Es tut mit leid.", italian="Avrei dovuto riflettere prima di\nparlare...[K] Mi dispiace!", spanish="Debería haber pensado antes\nde abrir la boca. Ya sé que ninguno lo haría...[K]\nPerdonadme."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Well, it's no wonder that you'd\nleap to that conclusion!", french="Pas étonnant que ça te soit venu\nà l'esprit tout de suite!", german="Nun, es ist kein Wunder, dass\ndu auf diese Idee gekommen bist!", italian="Beh, non è poi così strano che tu\nabbia pensato a quella possibilità!", spanish="Bueno, es natural que llegases\na esa conclusión."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="I mean, this horrible thing did\nhappen right after our expedition.", french="Je veux dire, c'est arrivé juste\naprès notre expédition.", german="Ich meine, dieses Unglück ist\nschließlich direkt nach unserer Expedition\npassiert.", italian="Voglio dire... In fondo è\nsuccesso tutto dopo la nostra spedizione,\nno?", spanish="Al fin y al cabo, es una gran\ncoincidencia que esto ocurra justo después\nde nuestra expedición."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Just one moment![K] I'm afraid I\ndon't quite understand...", french="Un instant, je vous prie![K]\nJe crains de ne pas tout saisir...", german="Einen Moment![K] Ich fürchte,\nich verstehe das nicht ganz...", italian="Chiedo scusa![K] Temo di non aver\ncompreso l'accaduto...", spanish="¡Un momento![K]\nNo acabo de entenderlo..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="There was a Time Gear at\n[CS:P]Fogbound Lake[CR]? [K]I did not know that...", french="Il y avait un Rouage du Temps\nau [CS:P]Lac des Brumes[CR]? [K]Je l'ignorais...", german="Es gab ein Zahnrad der Zeit im\n[CS:P]Nebelsee[CR]?[K] Das wusste ich nicht...", italian="Un Ingranaggio del Tempo si\ntrovava al [CS:P]Lago Foschia[CR]?[K] Non ne sapevo\nnulla...", spanish="¿Había un Engranaje del Tiempo\nen el [CS:P]Lago Velado[CR]?[K] No tenía ni idea."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Did I not hear quite a different\ntale about your recent expedition?", french="Il me semble avoir entendu\nune toute autre version de l'histoire...", german="Habe ich nicht etwas ganz\nanderes über eure letzte Expedition gehört?", italian="Non ho forse ascoltato una\nversione dei fatti leggermente differente?", spanish="¿No me habíais contado algo muy\ndistinto sobre la expedición?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I recall being told that your\nexpedition to [CS:P]Fogbound Lake[CR] ended in failure.", french="J'avais cru comprendre que\nvotre expédition au [CS:P]Lac des Brumes[CR]\ns'était soldée par un cuisant échec.", german="Mir wurde erzählt, dass die\nExpedition zum [CS:P]Nebelsee[CR] gescheitert ist.", italian="Raccontaste che la spedizione al\n[CS:P]Lago Foschia[CR] fu un fallimento.", spanish="Si no recuerdo mal, me dijisteis\nque la expedición al [CS:P]Lago Velado[CR] había sido\nun fracaso."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" I apologize, great [CS:N]Dusknoir[CR].", french="Toutes mes excuses,\ngrand [CS:N]Noctunoir[CR].", german="Ich bitte um Verzeihung, großer\n[CS:N]Zwirrfinst[CR].", italian="Devo chiederle perdono, grande\n[CS:N]Dusknoir[CR].", spanish="Te debo una disculpa, gran\n[CS:N]Dusknoir[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="We made a promise. So we\ncouldn't tell even you, [CS:N]Dusknoir[CR].", french="Nous avions fait une promesse.\nOn ne pouvait rien dire, même à vous,\n[CS:N]Noctunoir[CR].", german="Wir hatten ein Versprechen\ngegeben. Darum konnten wir es nicht einmal\ndir verraten, [CS:N]Zwirrfinst[CR].", italian="Avevamo promesso...\nNon potevamo rivelare nulla nemmeno a lei,\n[CS:N]Dusknoir[CR].", spanish="Hicimos una promesa y no\npodíamos contárselo a nadie.\nNi siquiera a ti, [CS:N]Dusknoir[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Anyway...[K] A lone intruder slipped\ninto [CS:P]Fogbound Lake[CR]...", french="Bref...[K] Un intrus s'est faufilé\nau [CS:P]Lac des Brumes[CR]...", german="Wie auch immer...[K] Ein einzelner\nEindringling hat den [CS:P]Nebelsee[CR] gefunden...", italian="Ad ogni modo...[K]\nQualcuno è riuscito da solo a raggiungere il\n[CS:P]Lago Foschia[CR].", spanish="El caso es que...[K] un intruso\nse coló en el [CS:P]Lago Velado[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="knocked out [CS:N]Uxie[CR]...[K]and made off\nwith the Time Gear.", french="... il a assommé [CS:N]Créhelf[CR]...[K] avant\nde s'enfuir avec le Rouage du Temps.", german="Dann hat er [CS:N]Selfe[CR] überwältigt...[K]\nund das Zahnrad der Zeit mitgenommen.", italian="Ha sistemato [CS:N]Uxie[CR]...[K] e se l'è\nsvignata con l'Ingranaggio del Tempo.", spanish="Derribó a [CS:N]Uxie[CR]...[K] y se apoderó\ndel Engranaje del Tiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Uxie[CR]?!", french=" [CS:N]Créhelf[CR]?!", german=" [CS:N]Selfe[CR]?!?", italian=" [CS:N]Uxie[CR]?!", spanish=" ¡¿[CS:N]Uxie[CR]?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Uxie[CR]?!", french=" [CS:N]Créhelf[CR]?!", german=" [CS:N]Selfe[CR]?!?", italian=" [CS:N]Uxie[CR]?!", spanish=" ¡¿[CS:N]Uxie[CR]?!"})
  else
  SkySceneKit.say({english=" [CS:N]Uxie[CR]?!", french=" [CS:N]Créhelf[CR]?!", german=" [CS:N]Selfe[CR]?!?", italian=" [CS:N]Uxie[CR]?!", spanish=" ¡¿[CS:N]Uxie[CR]?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Is [CS:N]Uxie[CR] all right?!", french=" Est-ce que [CS:N]Créhelf[CR] va bien?!", german=" Geht es [CS:N]Selfe[CR] gut?!?", italian=" [CS:N]Uxie[CR] sta bene?", spanish=" ¡¿Cómo está [CS:N]Uxie[CR]?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Is [CS:N]Uxie[CR] all right?!", french=" Est-ce que [CS:N]Créhelf[CR] va bien?!", german=" Geht es [CS:N]Selfe[CR] gut?!?", italian=" [CS:N]Uxie[CR] sta bene?", spanish=" ¡¿Cómo está [CS:N]Uxie[CR]?!"})
  else
  SkySceneKit.say({english=" Is [CS:N]Uxie[CR] all right?!", french=" Est-ce que [CS:N]Créhelf[CR] va bien?!", german=" Geht es [CS:N]Selfe[CR] gut?!?", italian=" [CS:N]Uxie[CR] sta bene?", spanish=" ¡¿Cómo está [CS:N]Uxie[CR]?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Yes. [CS:N]Uxie[CR] is fine.", french=" Oui, il va bien.", german=" Ja. Es geht [CS:N]Selfe[CR] gut.", italian=" Sì. Per fortuna [CS:N]Uxie[CR] sta bene.", spanish=" [CS:N]Uxie[CR] está bien."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="He's under the protection of\n[CS:N]Magnezone[CR]'s squad.[K] No need to worry.", french="Il est sous la protection\nde la brigade de [CS:N]Magnézone[CR].[K] Pas d'inquiétude\nà avoir.", german="Es steht unter dem Schutz der\nTruppe von [CS:N]Magnezone[CR].[K] Macht euch keine\nSorgen.", italian="Si trova sotto la protezione\ndella squadra di [CS:N]Magnezone[CR].[K] Non dobbiamo\npreoccuparci.", spanish="La brigada de [CS:N]Magnezone[CR] lo\nprotege.[K] No hay de qué preocuparse."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whew! Glad to hear that!", french=" Ouf! Content de l'apprendre!", german=" Puh! Da bin ich erleichtert!", italian=" Fiuu! Meno male!", spanish="Menos mal, menudo peso nos\nquitas de encima."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Whew! I'm glad to hear that!", french=" Ouf! Content de l'apprendre!", german=" Puh! Da bin ich erleichtert!", italian=" Oh! Meno male!", spanish="Menos mal, nos estábamos\npreocupando."})
  else
  SkySceneKit.say({english=" Whew! I'm glad to hear that!", french=" Ouf! Contente de l'apprendre!", german=" Puh! Da bin ich erleichtert!", italian=" Oh! Meno male!", spanish="Menos mal, nos estábamos\npreocupando."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Wait, there's more. According to\n[CS:N]Uxie[CR]'s victim statement...", french="Attendez, ce n'est pas tout.\nD'après la déposition de [CS:N]Créhelf[CR]...", german="Wartet, das war nicht alles.\nDie Zeugenaussage von [CS:N]Selfe[CR]...", italian="Un momento! C'è dell'altro.\n[CS:N]Uxie[CR] ha fatto una deposizione.", spanish="Hay algo más. Gracias a la\ndeclaración de [CS:N]Uxie[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The intruder's identity has been\nrevealed.", french=" ... on a pu identifier le coupable.", german="Sie offenbarte die Identität des\nEindringlings.", italian="L'identità del ladro è stata\nrivelata.", spanish="La identidad del intruso\nha sido revelada."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Then fess up! What kind of\ncritter are we dealing with?", french="Ben vas-y, quoi! Quel genre\nd'créature c'est?", german="Na warte! Mit was für einem\nUnhold haben wir es zu tun?", italian="E allora dicci! Con chi abbiamo a\nche fare?", spanish="¡Pues dínosla! ¿Con qué clase de\ntipejo estamos tratando?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="There's already a wanted poster\nup for the thief.", french="Le voleur fait déjà l'objet\nd'un avis de recherche.", german="Der Dieb wird bereits per\nSteckbrief gesucht.", italian="È già stato affisso un manifesto\ncon il volto del ricercato.", spanish="Ya hay un cartel preparado para\nfacilitar su captura."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" See for yourselves.", french=" Regardez par vous-mêmes.", german=" Seht selbst.", italian=" Guardate con i vostri occhi.", spanish=" Podéis verlo vosotros mismos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ResetHitAttribute(31) [neutre/état moteur]
  -- ResetHitAttribute(31) [neutre/état moteur]
  -- ResetHitAttribute(31) [neutre/état moteur]
  -- ResetHitAttribute(31) [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_bippa, 460, 216, false, 2)
  GROUND:MoveToPosition(hero, 444, 212, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(npc_npc_perappu, 480, 220, false, 2)
  GROUND:MoveToPosition(partner, 424, 216, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_yonowaaru, 396, 216, false, 2)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_pukurin, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  GAME:WaitFrames(30)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V13P01A) [décor sub chargé: Sub_v13p01a]
  -- camera2_SetPositionMark(Position<'m16', 19.5, 17.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v13p01a", 30, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This Pokémon goes by the name\nof [CS:N]Grovyle[CR].", french="Ce Pokémon se fait appeler\n[CS:N]Massko[CR].", german="Dieses Pokémon nennt sich\n[CS:N]Reptain[CR].", italian="Questo Pokémon risponde al\nnome di [CS:N]Grovyle[CR].", spanish=" El Pokémon se llama [CS:N]Grovyle[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This Pokémon goes by the name\nof [CS:N]Grovyle[CR].", french="Ce Pokémon se fait appeler\n[CS:N]Massko[CR].", german="Dieses Pokémon nennt sich\n[CS:N]Reptain[CR].", italian="Questo Pokémon risponde al\nnome di [CS:N]Grovyle[CR].", spanish=" El Pokémon se llama [CS:N]Grovyle[CR]."})
  else
  SkySceneKit.say({english="This Pokémon goes by the name\nof [CS:N]Grovyle[CR].", french="Ce Pokémon se fait appeler\n[CS:N]Massko[CR].", german="Dieses Pokémon nennt sich\n[CS:N]Reptain[CR].", italian="Questo Pokémon risponde al\nnome di [CS:N]Grovyle[CR].", spanish=" El Pokémon se llama [CS:N]Grovyle[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Oof![K] That's one nasty piece\nof work!", french="Pfiou![K] Il s'paye une d'ces\ntrombines, l'autre!", german="Uff![K] Das ist vielleicht ein\nfieser Ganove!", italian=" Puf![K] Che brutta faccia, ohibò!", spanish=" ¡Vaya![K] ¡Menudo elemento!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:N]Grovyle[CR]...)", french="([CS:N]Massko[CR]...)", german="([CS:N]Reptain[CR]...)", italian="([CS:N]Grovyle[CR]...)", spanish="([CS:N]Grovyle[CR].)"})
  else
  SkySceneKit.say({english="([CS:N]Grovyle[CR]...)", french="([CS:N]Massko[CR]...)", german="([CS:N]Reptain[CR]...)", italian="([CS:N]Grovyle[CR]...)", spanish="([CS:N]Grovyle[CR].)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(So this is the Pokémon...)", french="(Alors c'est lui le Pokémon...)", german="(Das ist also das Pokémon...)", italian="(Così è questo il Pokémon...)", spanish="(Así que este es el Pokémon...)"})
  else
  SkySceneKit.say({english="(So this is the Pokémon...)", french="(Alors c'est lui le Pokémon...)", german="(Das ist also das Pokémon...)", italian="(Così è questo il Pokémon...)", spanish="(Así que este es el Pokémon...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...the thief who's stealing the Time Gears.)", french="(... l'escroc qui vole les Rouages du Temps.)", german="(Es stiehlt die Zahnräder der Zeit.)", italian="(È lui che sta rubando gli Ingranaggi del\nTempo.)", spanish="(Que está robando los Engranajes del Tiempo.)"})
  else
  SkySceneKit.say({english="(...the thief who's stealing the Time Gears.)", french="(... l'escroc qui vole les Rouages du Temps.)", german="(Es stiehlt die Zahnräder der Zeit.)", italian="(È lui che sta rubando gli Ingranaggi del\nTempo.)", spanish="(Que está robando los Engranajes del Tiempo.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" This wanted poster just arrived.", french="Cet avis de recherche vient\njuste d'arriver.", german="Dieser Steckbrief ist gerade\nerst angekommen.", italian="Questo manifesto è appena\narrivato.", spanish=" Este cartel acaba de llegar."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It was issued based on [CS:N]Uxie[CR]'s\nstatement. It arrived as part of an all-points\nbulletin.", french="Il est basé sur la déposition\nde [CS:N]Créhelf[CR]. Il est arrivé par messager\nspécial.", german="Er basiert auf der Aussage von\n[CS:N]Selfe[CR] und wird im Rahmen einer\nGroßfahndung eingesetzt.", italian="È basato sulla descrizione\nfornita da [CS:N]Uxie[CR]. Ne sono già stati consegnati\nmolti.", spanish="El retrato robot se basa en\nla declaración de [CS:N]Uxie[CR].\nHa sido distribuido por todas partes."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(npc_npc_bippa, Direction.DownRight)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Right)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Oh, that figures! That's why all\nthose [CS:N]Pelipper[CR] were flying around!", french="Waouh, j'comprends maintenant!\nC'est pour ça qu'y avait autant d'[CS:N]Bekipan[CR]!", german="Oh, das erklärt einiges! Darum\nfliegen so viele [CS:N]Pelipper[CR] umher!", italian="Oh! Questo spiega la presenza di\ntutti quei [CS:N]Pelipper[CR]!", spanish="¡Ah, claro! Por eso vimos\nvolar a todos esos [CS:N]Pelipper[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Officer [CS:N]Magnezone[CR] obviously\ndoesn't want to see things worsen.", french="De toute évidence, le shérif\n[CS:N]Magnézone[CR] refuse que les choses s'aggravent.", german="Oberwachtmeister [CS:N]Magnezone[CR]\nversucht offenbar, noch Schlimmeres zu\nvermeiden.", italian="È evidente che il Commissario\n[CS:N]Magnezone[CR] vuole evitare che succeda di nuovo.", spanish="Obviamente, el agente [CS:N]Magnezone[CR]\nno quiere que empeore la situación."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="They've put a remarkably high\nbounty on the thieving [CS:N]Grovyle[CR].", french="Il y a une récompense\nastronomique pour la capture de [CS:N]Massko[CR].", german="Es wurde ein bemerkenswert\nhohes Kopfgeld auf [CS:N]Reptain[CR] ausgesetzt.", italian="Hanno messo una taglia notevole\nsu quel farabutto di [CS:N]Grovyle[CR].", spanish="Han ofrecido una recompensa\nconsiderable por ese ladrón de [CS:N]Grovyle[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We promised [CS:N]Uxie[CR]...", french=" On a promis à [CS:N]Créhelf[CR]...", german=" Wir haben [CS:N]Selfe[CR] versprochen...", italian=" Abbiamo promesso a [CS:N]Uxie[CR]...", spanish=" Le prometimos a [CS:N]Uxie[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We promised [CS:N]Uxie[CR]...", french=" On a promis à [CS:N]Créhelf[CR]...", german=" Wir haben [CS:N]Selfe[CR] versprochen...", italian=" Abbiamo promesso a [CS:N]Uxie[CR]...", spanish=" Le prometimos a [CS:N]Uxie[CR]..."})
  else
  SkySceneKit.say({english=" We promised [CS:N]Uxie[CR]...", french=" On a promis à [CS:N]Créhelf[CR]...", german=" Wir haben [CS:N]Selfe[CR] versprochen...", italian=" Abbiamo promesso a [CS:N]Uxie[CR]...", spanish=" Le prometimos a [CS:N]Uxie[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We promised not to reveal the\nsecret of [CS:P]Fogbound Lake[CR].", french="On lui a promis de ne pas\nrévéler le secret du [CS:P]Lac des Brumes[CR].", german="Wir haben versprochen, das\nGeheimnis des [CS:P]Nebelsees[CR] nicht zu verraten.", italian="Abbiamo promesso di non\nrivelare il segreto del [CS:P]Lago Foschia[CR].", spanish="Que no revelaríamos el secreto\ndel [CS:P]Lago Velado[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We promised not to reveal the\nsecret of [CS:P]Fogbound Lake[CR].", french="On lui a promis de ne pas\nrévéler le secret du [CS:P]Lac des Brumes[CR].", german="Wir haben versprochen, das\nGeheimnis des [CS:P]Nebelsees[CR] nicht zu verraten.", italian="Abbiamo promesso di non\nrivelare il segreto del [CS:P]Lago Foschia[CR].", spanish="Que no revelaríamos el secreto\ndel [CS:P]Lago Velado[CR]."})
  else
  SkySceneKit.say({english="We promised not to reveal the\nsecret of [CS:P]Fogbound Lake[CR].", french="On lui a promis de ne pas\nrévéler le secret du [CS:P]Lac des Brumes[CR].", german="Wir haben versprochen, das\nGeheimnis des [CS:P]Nebelsees[CR] nicht zu verraten.", italian="Abbiamo promesso di non\nrivelare il segreto del [CS:P]Lago Foschia[CR].", spanish="Que no revelaríamos el secreto\ndel [CS:P]Lago Velado[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But then this happens...", french=" Et voilà le résultat...", german=" Und dann passiert so etwas...", italian=" Ma è successo questo...", spanish=" Y ahora ha pasado esto."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But then this happens...", french=" Et voilà le résultat...", german=" Und dann passiert so etwas...", italian=" Ma è successo questo...", spanish=" Y ahora ha pasado esto."})
  else
  SkySceneKit.say({english=" But then this happens...", french=" Et voilà le résultat...", german=" Und dann passiert so etwas...", italian=" Ma è successo questo...", spanish=" Y ahora ha pasado esto."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" We didn't leak the secret, but...", french="On n'a pas vendu la mèche,\nmais...", german="Wir haben es nicht verraten,\naber...", italian="Nessuno di noi ha parlato,\neppure...", spanish="Nosotros no hemos dicho nada,\npero..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_kimawari, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="I'm ashamed to show my face in\nfront of [CS:N]Uxie[CR] now!", french="... j'aurais quand même honte\nde me montrer devant [CS:N]Créhelf[CR] après ça!", german="Ich könnte [CS:N]Selfe[CR] jetzt nicht\nmehr ins Gesicht sehen!", italian="Dopo quello che è successo, con\nche faccia potremmo mai presentarci a [CS:N]Uxie[CR]?", spanish="Cuando vea a [CS:N]Uxie[CR], se me va a\ncaer la cara de vergüenza."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! Here's what sticks in\nmy craw! The view there has been ruined!", french="Eh dis donc, ce qui me reste\nen travers des pinces, c'est l'idée que ce\nsuperbe paysage soit saccagé maintenant!", german="Hey, und wisst ihr, was das\nSchlimmste ist? Der schöne Ausblick dort\nist jetzt ruiniert!", italian="Ehi, ehi, ehi! E non è finita!\nQuel che non mi va giù è che quella vista\ncosì incantevole sia stata rovinata!", spanish="A mí lo que me fastidia es que\nse ha arruinado una vista preciosa."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="And, hey, hey! I just can't\nforgive that!", french="Eh dis donc, ça,\nc'est impardonnable!", german="Und, hey, hey! Das kann ich\nniemals verzeihen!", italian=" È davvero imperdonabile!", spanish=" Eso sí que no puedo perdonarlo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  -- SetAnimation(9) [anim idle native]
  -- message_FacePositionOffset(4, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Urrrr...", french=" Rrrrr...", german=" Arrrr...", italian=" Grrrr...", spanish=" Grrrr..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_pukurin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Hey! Guildmaster...!", french=" Eh, le Maître...!", german=" Hey! Gildenmeister!", italian=" Ehi! Capitano...!", spanish=" ¡Eh! ¡Gran Bluff...!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(4, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Urrr...[K] Urrrrrr...[K] Urrrrrrr...!", french=" Rrrr...[K] Rrrrrrr...[K] Rrrrrrrr...!", german=" Arrr...[K] Arrrrrr...[K] Arrrrrrr!", italian=" Grrr...[K] Grrrrrr...[K] Grrrrrrr...!", spanish=" Grrr...[K] Grrrrrr...[K] ¡Grrrrrrr...!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" G-G-Guildmaster!", french=" M-M-Maître!", german=" G-G-Gildenmeister!", italian=" C-C-Capitano!", spanish=" ¡Gran... Gran Bluff!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_EARTHQUAKE2 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:WaitFrames(30)
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Down)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(npc_npc_diguda, Direction.Left)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Right)
  GROUND:EntTurn(npc_npc_chiriin, Direction.DownLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_heigani, Direction.Left)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_bippa, Direction.DownRight)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownRight)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Right)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Left)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Left)
  GROUND:EntTurn(npc_npc_heigani, Direction.Right)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GROUND:EntTurn(hero, Direction.UpLeft)
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 264, 216, Direction.Up, "NPC_ZUBATTO")
  GROUND:EntTurn(npc_npc_zubatto, Direction.Down)
  -- message_FacePositionOffset(4, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Urrrrrrrrr...!!!", french=" Rrrrrrrrrr...!!!", german=" Arrrrrrrrr!!!", italian=" Grrrrrrrrr...!!!", spanish=" ¡Grrrrrrrrr!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Right)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpRight)
  GROUND:EntTurn(npc_npc_perappu, Direction.Up)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GROUND:EntTurn(npc_npc_diguda, Direction.UpRight)
  GROUND:EntTurn(npc_npc_guregguru, Direction.UpRight)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpRight)
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpRight)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  GAME:WaitFrames(60)
  -- message_FacePositionOffset(4, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" YOOM...TAH!", french=" TA... DAAA!", german=" LUUU... FIII!", italian=" BADABUM!", spanish=" ¡Se acabó!"})
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" WAH!", french=" Wouaaah!", german=" WAH!", italian=" OH... EH?!", spanish=" ¡¿Qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Squawk! Squawk!", french=" Couac! Couac!", german=" Kreisch! Kreisch!", italian=" Squack! Squack!", spanish=" ¡Cruac, cruac!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- message_FacePositionOffset(4, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Everyone![K] We'll catch [CS:N]Grovyle[CR]!", french="On va capturer [CS:N]Massko[CR]![K]\nTous ensemble!", german="Pokémon![K] Wir werden [CS:N]Reptain[CR]\nfangen!", italian="Ascoltatemi bene! Noi...[K]\nacciufferemo [CS:N]Grovyle[CR]!", spanish="¡Escuchadme todos![K]\n¡Vamos a atrapar a [CS:N]Grovyle[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="We'll catch that thief! I vow it\nupon the name of [CS:N]Wigglytuff[CR]'s Guild!", french="On l'attrapera! Je le jure sur\nl'honneur de la Guilde de [CS:N]Grodoudou[CR]!", german="Wir fangen diesen Dieb! Ich\nschwöre es im Namen der [CS:N]Knuddeluff-Gilde[CR]!", italian="Acciufferemo quel ladro! Lo\ngiuro sull'onore della Gilda!", spanish="¡Cogeremos a ese ladrón!\n¡Lo prometo en nombre de mi [CS:N]Pokégremio[CR]!"})
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(4, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" [CS:N]Chatot[CR], if you will!", french=" [CS:N]Pijako[CR], si tu veux bien!", german=" [CS:N]Plaudagei[CR], wenn ich bitten darf!", italian="[CS:N]Chatot[CR]! Ti prego di fare\nl'annuncio!", spanish=" [CS:N]Chatot[CR], ¡adelante!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Y-yes!", french=" Oui, Maître!", german=" J-ja!", italian=" S-Sissignore!", spanish=" ¡Sí!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  GROUND:EntTurn(npc_npc_bippa, Direction.DownRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" OK, everyone!", french=" Très bien, tout le monde!", german=" Okay, Pokémon!", italian=" Ok, gente!", spanish=" Vale, ¡oídme todos!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="From here on out, we are putting\nour full focus on capturing [CS:N]Grovyle[CR]!", french="Dorénavant, nous consacrerons\ntous nos efforts à la seule capture\nde [CS:N]Massko[CR]!", german="Ab jetzt konzentriert ihr euch\nvoll und ganz darauf, [CS:N]Reptain[CR] zu fangen!", italian="D'ora in avanti, concentreremo\nle forze nella caccia a [CS:N]Grovyle[CR]!", spanish="A partir de ahora, nuestro único\nobjetivo será... ¡capturar a [CS:N]Grovyle[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Do your best to bring [CS:N]Grovyle[CR] to\njustice!", french="Faites de votre mieux pour\nle mettre sous les verrous!", german="Gebt alles, um [CS:N]Reptain[CR] zur\nRechenschaft zu ziehen!", italian="Faremo tutto quello che è in\nnostro potere per consegnare [CS:N]Grovyle[CR] alla\ngiustizia!", spanish="Haced todo lo que podáis para\nque podamos poner a [CS:N]Grovyle[CR] en manos de\nla justicia."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" It goes without saying!", french=" Ça va sans dire!", german=" Selbstverständlich!", italian=" Signorsì!", spanish=" ¡Por supuesto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey, hey! There's no way\nwe can let any more Time Gears be stolen!", french="Eh dis donc, hors de question\nqu'on le laisse voler d'autres Rouages\ndu Temps!", german="Hey, hey, hey! Es kommt nicht in\nFrage, dass noch ein Zahnrad der Zeit\ngestohlen wird!", italian="Ehi, ehi, ehi! Non permetteremo\nche un altro Ingranaggio del Tempo venga\nrubato! Non esiste proprio!", spanish="¡Oye, oye! No podemos permitir\nque roben otro Engranaje del Tiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="C'mon, everyone! Let's pull\ntogether![K] Let's do it for [CS:N]Uxie[CR]!", french="Allez, tout le monde sur le pont\net soyons solidaires![K] Pour [CS:N]Créhelf[CR]!", german="Los, Pokémon! Wir müssen alle\nzusammenarbeiten![K] Wir müssen es auch für\n[CS:N]Selfe[CR] tun!", italian="Coraggio, gente! Abbiamo bisogno\ndell'aiuto di tutti![K] Dobbiamo farlo anche per\n[CS:N]Uxie[CR]!", spanish="¡Vamos todos! Necesitamos que\ncada uno ponga su granito de arena.[K] Tenemos\nque hacerlo por [CS:N]Uxie[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" [CS:N]Wigglytuff[CR]...", french=" [CS:N]Grodoudou[CR]...", german=" [CS:N]Knuddeluff[CR]...", italian=" [CS:N]Wigglytuff[CR]...", spanish=" [CS:N]Wigglytuff[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_yonowaaru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I believe I understand the\nsituation now.", french="Je crois comprendre la situation\nà présent.", german="Ich glaube, ich verstehe die\nSituation jetzt.", italian="Comprendo appieno la situazione,\nadesso.", spanish=" Creo que entiendo lo que ocurre."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I will join in your guild's pursuit\nof [CS:N]Grovyle[CR].", french="Aussi vais-je me joindre à vous\npour capturer [CS:N]Massko[CR].", german="Ich werde der Gilde bei der Jagd\nnach [CS:N]Reptain[CR] helfen.", italian="Unirò i miei sforzi ai vostri e\nvi aiuterò a cercare [CS:N]Grovyle[CR].", spanish="Ayudaré al [CS:N]Pokégremio[CR] a\ncapturar a [CS:N]Grovyle[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(4, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Th-thank you, great [CS:N]Dusknoir[CR]!", french=" Merci, ô grand [CS:N]Noctunoir[CR]!", german=" D-danke, großer [CS:N]Zwirrfinst[CR]!", italian="G-Grazie infinite, o grande\n[CS:N]Dusknoir[CR]!", spanish=" ¡Gracias, gran [CS:N]Dusknoir[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Golly! Having the great [CS:N]Dusknoir[CR]\nin our corner is mighty heartening!", french="Sapristi! Avoir l'grand\n[CS:N]Noctunoir[CR] dans son camp, ça vous redonne\ndu cœur à l'ouvrage, pour sûr!", german="Donnerwetter! Den großen\n[CS:N]Zwirrfinst[CR] auf unserer Seite zu haben,\nmacht mir wirklich Mut!", italian="Ohibò! Avere il grande [CS:N]Dusknoir[CR]\ndalla nostra è molto rassicurante!", spanish="¡Huy! Tener al gran [CS:N]Dusknoir[CR]\nde nuestro lado es bastante motivador."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! We're honored!", french="Eh dis donc, c'est un grand\nhonneur! Pincez-moi, je rêve!", german=" Hey, hey! Es ist uns eine Ehre!", italian=" Ehi, ehi! È un vero onore!", spanish=" ¡Oye, oye! ¡Qué honor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" No, no! It's my honor entirely.", french="Que nenni, voyons. Tout l'honneur\nest pour moi.", german=" Ach was! Es ist mir eine Ehre.", italian="No, no! Sono io ad essere\nonorato!", spanish=" No, el honor es mío."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="At present, the Guildmaster\nand I shall confer!", french="A présent, le Maître de la Guilde\net moi-même devons nous entretenir!", german="Nun ist es Zeit, dass der\nGildenmeister und ich uns beratschlagen!", italian="Ora, signore e signori, il\nCapitano ed io ci ritireremo per un consulto!", spanish="De momento, el Gran Bluff y\nyo vamos a tener una reunión."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  GROUND:EntTurn(npc_npc_bippa, Direction.DownRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We will devise a strategy for\nfinding [CS:N]Grovyle[CR].", french="Nous allons mettre au point\nune stratégie pour débusquer [CS:N]Massko[CR].", german="Wir werden eine Strategie\nerarbeiten, um [CS:N]Reptain[CR] zu finden.", italian="Elaboreremo una strategia per\nscovare [CS:N]Grovyle[CR].", spanish="Vamos a idear una estrategia\npara encontrar a [CS:N]Grovyle[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="In the meantime! You should all\nstart preparing to go on searches!", french="Pendant ce temps, allez tous\nfaire vos préparatifs pour partir\nà sa recherche!", german="In der Zwischenzeit solltet ihr\neuch auf die Suche vorbereiten!", italian="Nel frattempo, dovreste tutti\nprepararvi per quando cominceranno le\nricerche!", spanish="Mientras tanto, tendréis que\nprepararos para iniciar la búsqueda."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Return here when you are ready\nto leave.", french="Revenez me voir quand vous\nserez prêts à partir.", german="Kommt hierher zurück, wenn ihr\nfertig seid.", italian=" Fatevi trovare pronti.", spanish="Volved aquí cuando estéis\nlistos para partir."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="OK, everyone![K] Let's outdo\nourselves! ♪", french="Très bien, tout le monde![K]\nSurpassons-nous! ♪", german="Okay, Pokémon![K] Übertreffen\nwir uns selbst! ♪", italian="Membri della Gilda![K] Dobbiamo\nsuperare noi stessi!", spanish="¡Muy bien![K] ¡Esta vez tenemos\nque hacerlo mejor que nunca! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GROUND:EntTurn(npc_npc_bippa, Direction.Down)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "happy", 1) end)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_bippa, Direction.Down)
  -- SetAnimation(24) [anim idle native]
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  -- SetAnimation(66) [anim idle native]
  GROUND:EntTurn(partner, Direction.Down)
  -- SetAnimation(66) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: SÌÌÌÌÌ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_diguda, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_dagutorio, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_dagutorio, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_dagutorio, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dagutorio, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_dagutorio, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru, npc_npc_dagutorio, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_dagutorio, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_dagutorio, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_dagutorio, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_dagutorio, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_dagutorio, 4) end)
  -- GAP: se_Play(6422) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  -- GAP: se_Play(6422) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(npc_npc_bippa, Direction.Left)
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  GROUND:MoveToPosition(npc_npc_yonowaaru, 332, 216, false, 2)
  GAME:WaitFrames(5)
  do local p=npc_npc_guregguru.Position; GROUND:MoveToPosition(npc_npc_guregguru, p.X+(-60), p.Y+(0), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_heigani.Position; GROUND:MoveToPosition(npc_npc_heigani, p.X+(-72), p.Y+(0), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(-96), p.Y+(0), false, 2) end
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_chiriin, 516, 236, false, 2)
  GAME:WaitFrames(15)
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(-120), p.Y+(0), false, 2) end
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(-8), p.Y+(8), false, 2) end
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(-116), p.Y+(0), false, 2) end
  GROUND:MoveToPosition(npc_npc_yonowaaru, 332, 124, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 364, 172, false, 2)
  GROUND:MoveToPosition(npc_npc_heigani, 332, 216, false, 2)
  GROUND:MoveToPosition(npc_npc_kimawari, 332, 216, false, 2)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  GROUND:MoveToPosition(npc_npc_heigani, 332, 124, false, 2)
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_kimawari, 332, 124, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 332, 216, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 332, 124, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 332, 124, false, 2)
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(8), p.Y+(8), false, 2) end -- Move2PositionOffset
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Come on, let's get ready,\n[hero].", french="Allez, on va vite se préparer,\n[hero].", german="Komm schon, bereiten wir uns\nvor, [hero].", italian=" Andiamo, [hero].", spanish="Venga, vamos a prepararnos,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's hurry and get ready,\n[hero].", french="Allez, on va vite se préparer,\n[hero].", german="Beeilen wir uns mit den\nVorbereitungen, [hero].", italian=" Andiamo, [hero].", spanish="Preparémonos cuanto antes,\n[hero]."})
  else
  SkySceneKit.say({english="We should hurry and get ready,\n[hero].", french="Allez, on va vite se préparer,\n[hero].", german="Wir sollten uns mit den\nVorbereitungen beeilen, [hero].", italian=" Andiamo, [hero].", spanish="Debemos prepararnos enseguida,\n[hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's start preparing with a\nvisit to Treasure Town.", french="Commençons nos préparatifs\npar une visite à Bourg-Trésor.", german="Fangen wir mit einem Besuch in\nSchatzstadt an.", italian="Come prima cosa, facciamo un\nsalto a Borgo Tesoro.", spanish="Vamos a prepararnos haciendo un\nrecorrido por Aldea Tesoro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's start preparing with a\nvisit to Treasure Town.", french="Commençons nos préparatifs\npar une visite à Bourg-Trésor.", german="Fangen wir mit einem Besuch in\nSchatzstadt an.", italian="Penso sia una buona idea fare un\nsalto a Borgo Tesoro.", spanish="Vamos a prepararnos haciendo un\nrecorrido por Aldea Tesoro."})
  else
  SkySceneKit.say({english="Let's start preparing with a\nvisit to Treasure Town.", french="Commençons nos préparatifs\npar une visite à Bourg-Trésor.", german="Fangen wir mit einem Besuch in\nSchatzstadt an.", italian="Penso sia una buona idea fare un\nsalto a Borgo Tesoro.", spanish="Vamos a prepararnos haciendo un\nrecorrido por Aldea Tesoro."})
  end
  -- message_Close
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-96), p.Y+(0), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-96), p.Y+(0), false, 2) end
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
