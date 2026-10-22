-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m06a0203.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P03A, 'UM06') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(10) [neutre/état moteur]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 456, 216, Direction.Up, "NPC_BIPPA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 416, 248, Direction.DownLeft, "NPC_HEIGANI")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 520, 240, Direction.Down, "NPC_CHIRIIN")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(4) [anim idle native]
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 392, 272, Direction.UpRight, "NPC_KIMAWARI")
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I... I remember!", french=" Je... je me rappelle!", german=" Ich... Ich weiß es wieder!", italian=" Mi... Mi ricordo!", spanish=" ¡Ahora me acuerdo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I... I remember!", french=" Je... je me rappelle!", german=" Ich... Ich weiß es wieder!", italian=" Mi... Mi ricordo!", spanish=" ¡Ahora me acuerdo!"})
  else
  SkySceneKit.say({english=" I... I remember!", french=" Je... je me rappelle!", german=" Ich... Ich weiß es wieder!", italian=" Mi... Mi ricordo!", spanish=" ¡Ahora me acuerdo!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="They're those two crooks who\nripped off my Relic Fragment!", french="Ce sont les deux escrocs qui\nm'ont volé mon Fragment de Relique!", german="Das sind die beiden Halunken,\ndie mein Reliktfragment geklaut haben!", italian="Sono quei due tipacci che mi\nhanno rubato il Frammento Antico!", spanish="¡Son esos dos canallas que\nme quitaron mi Reliquia de Piedra!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="They're those two crooks who\nstole my Relic Fragment!", french="Ce sont les deux escrocs qui\nm'ont volé mon Fragment de Relique!", german="Das sind die beiden Halunken,\ndie mein Reliktfragment gestohlen haben!", italian="Sono quei due tipacci che mi\nhanno rubato il Frammento Antico!", spanish="¡Son esos dos canallas que\nme quitaron mi Reliquia de Piedra!"})
  else
  SkySceneKit.say({english="They're those two crooks who\ntook off with my Relic Fragment!", french="Ce sont les deux escrocs qui\nm'ont volé mon Fragment de Relique!", german="Das sind die beiden Halunken,\ndie mit meinem Reliktfragment abgehauen sind!", italian="Sono quei due tipacci che mi\nhanno rubato il Frammento Antico!", spanish="¡Son esos dos canallas que\nme quitaron mi Reliquia de Piedra!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What are they doing here?!", french="Qu'est-ce qu'ils fabriquent ici,\nceux-là?!", german=" Was machen die hier?!?", italian=" Cosa ci fanno qui?!", spanish=" ¿Se puede saber qué hacen aquí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What are they doing here?!", french="Qu'est-ce qu'ils fabriquent ici,\nceux-là?!", german=" Was machen die hier?!?", italian=" Cosa ci fanno qui?!", spanish=" ¡¿Qué están haciendo aquí?!"})
  else
  SkySceneKit.say({english=" What are they doing here?!", french="Qu'est-ce qu'ils fabriquent ici,\nceux-là?!", german=" Was machen die hier?!?", italian=" Cosa ci fanno qui?!", spanish=" ¡¿Qué estarán haciendo aquí?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Growing Anxiety.ogg", true) end)
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 264, 248, Direction.Right, "NPC_DOGAASU")
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Whoa-ho-ho! I'll have you know\nthat we're an exploration team too.", french="Mouarf mouarf mouarf! Je te\nsignale que nous aussi, on est une équipe\nd'exploration, d'abord!", german="Whoahoho! Du solltest wissen,\ndass wir auch ein Erkundungsteam sind.", italian="Uooh-ho-ho! Dovete sapere che\nanche noi siamo una squadra d'esplorazione.", spanish="¡Jo, jo, jo! Para vuestra\ninformación, nosotros también somos\nun equipo explorador."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 264, 224, Direction.Right, "NPC_ZUBATTO")
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Heh-heh-heh. What's so funny\nabout an exploration team checking out the\nJob Bulletin Board?", french="Hin hin hin! Une équipe\nd'exploration qui consulte le Tableau des\nMissions. Ça vous étonne?", german="Hehehe. Was ist so seltsam\ndaran, wenn ein Erkundungsteam das\nJob-Infobrett liest?", italian="Eh-eh-eh. Cosa c'è di così strano\nnel vedere una squadra d'esplorazione che\ncontrolla la Bacheca delle missioni?", spanish="Jue, jue, jue. ¿Qué tiene de raro\nque un equipo explorador eche un vistazo\nal Tablón de Anuncios?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What?![K] You're an exploration\nteam?!", french="Quoi?![K] Vous êtes une équipe\nd'exploration?", german="Was?!?[K] Ihr seid ein\nErkundungsteam?!?", italian="Cosa?![K] Siete una squadra\nd'esplorazione?!", spanish="¡¿Cómo?![K] ¡¿Que sois\nun equipo explorador?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What?![K] You're an exploration\nteam?!", french="Quoi?![K] Vous êtes une équipe\nd'exploration?", german="Was?!?[K] Ihr seid ein\nErkundungsteam?!?", italian="Cosa?![K] Siete una squadra\nd'esplorazione?!", spanish="¡¿Cómo?![K] ¡¿Que sois\nun equipo explorador?!"})
  else
  SkySceneKit.say({english="What?![K] You're an exploration\nteam?!", french="Quoi?![K] Vous êtes une équipe\nd'exploration?", german="Was?!?[K] Ihr seid ein\nErkundungsteam?!?", italian="Cosa?![K] Siete una squadra\nd'esplorazione?!", spanish="¡¿Cómo?![K] ¡¿Que sois\nun equipo explorador?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="That's right. Though the way we\noperate isn't always...[K]by the book.", french="Exact. Même si c'est vrai que\nnos méthodes ne sont pas toujours très réglo.", german="Genau. Auch wenn unsere\nMethoden nicht immer...[K] vorschriftsmäßig\nsind.", italian="Esatto. Anche se non seguiamo\nle regole...[K] alla lettera!", spanish="Así es. Aunque la forma\nen que actuamos a veces no es...[K]\nortodoxa."})
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="But what a surprise! Why would\nyou be here?", french="Mais quelle bonne surprise!\nEt vous, quel mauvais vent vous amène\ndans le coin?", german="Aber was für eine\nÜberraschung! Warum seid ihr denn hier?", italian="Ma che sorpresa! Cosa ci fate\nvoi qui?", spanish="¡Pero menuda sorpresa!\n¿Qué es lo que hacéis aquí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We wanted to become\nexploration team members.", french="On veut devenir une\néquipe d'exploration.", german="Wir wollten Erkundungsteam-\nMitglieder werden.", italian="Vogliamo formare una squadra\nd'esplorazione.", spanish=" Deseábamos ser exploradores."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We wanted to become\nexploration team members.", french="On veut devenir une\néquipe d'exploration.", german="Wir wollten Erkundungsteam-\nMitglieder werden.", italian="Vogliamo formare una squadra\nd'esplorazione.", spanish=" Deseábamos ser exploradores."})
  else
  SkySceneKit.say({english="We wanted to become\nexploration team members.", french="On veut devenir une\néquipe d'exploration.", german="Wir wollten Erkundungsteam-\nMitglieder werden.", italian="Vogliamo formare una squadra\nd'esplorazione.", spanish="Queríamos formar un equipo\nexplorador."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So we're training at this guild.", french="C'est pour ça qu'on s'entraîne\nà la Guilde.", german="Also trainieren wir in dieser\nGilde.", italian="Quindi ci stiamo allenando in\nquesta Gilda.", spanish="Así que ahora nos estamos\nentrenando en este [CS:N]Pokégremio[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's why we're training at\nthis guild.", french="C'est pour ça qu'on s'entraîne\nà la Guilde.", german="Also trainieren wir in dieser\nGilde.", italian="Quindi ci stiamo allenando in\nquesta Gilda.", spanish="Así que ahora nos estamos\nentrenando en este [CS:N]Pokégremio[CR]."})
  else
  SkySceneKit.say({english="That's why we're training at\nthis guild.", french="C'est pour ça qu'on s'entraîne\nà la Guilde.", german="Also trainieren wir in dieser\nGilde.", italian="Quindi ci stiamo allenando in\nquesta Gilda.", spanish="Así que ahora nos estamos\nentrenando en este [CS:N]Pokégremio[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogaasu, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_zubatto, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Whaaaat?!", french=" Sérieux?!", german=" Waaaas?!?", italian=" Coooosa?!", spanish=" ¡Estaréis de broma!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="You want to become a real-deal\nexploration team member?!", french="Vous voulez vraiment former\nune équipe d'exploration?! Vous deux?", german="Ihr wollt ernsthaft\nErkundungsteam-Mitglieder werden?!?", italian="Volete diventare una vera\nsquadra d'esplorazione?!", spanish="¡¿Queréis ser un auténtico\nequipo explorador?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, npc_npc_dogaasu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogaasu, npc_npc_zubatto, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_zubatto, 336, 212, false, 2)
  GROUND:MoveToPosition(npc_npc_dogaasu, 336, 232, false, 2)
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Down)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Up)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- message_FacePositionOffset(-1, 3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" You! Come with us for a second.", french="Toi! Viens avec nous une\nseconde.", german=" Du da! Komm mal eben mit.", italian=" Tu! Vieni con noi un attimo.", spanish="¡Tú! Ven con nosotros\nun momento."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-what is it?", french=" Euh... pourquoi?", german=" W-was ist?", italian=" C-Cosa c'è?", spanish=" ¿Qué... qué pasa?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-what is it?", french=" Euh... pourquoi?", german=" W-was ist?", italian=" C-Cosa c'è?", spanish=" ¿Qué... qué pasa?"})
  else
  SkySceneKit.say({english=" Wh-what is it?", french=" Euh... pourquoi?", german=" W-was ist?", italian=" C-Cosa c'è?", spanish=" ¿Qué... qué pasa?"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(280, 236, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_zubatto, 256, 212, false, 2)
  GROUND:MoveToPosition(partner, 240, 220, false, 2)
  GROUND:MoveToPosition(npc_npc_dogaasu, 240, 228, false, 2)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 332, 228, false, 2)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6417) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- SetAnimation(11) [anim idle native]
  GROUND:MoveToPosition(partner, 224, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_dogaasu.Position; GROUND:MoveToPosition(npc_npc_dogaasu, p.X+(8), p.Y+(16), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_dogaasu, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(2, 4) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Now don't take what I'm about\nto say the wrong way.[K] You should just forget\nabout being on an exploration team!", french="Prends pas mal ce que je vais\nte dire, hein.[K] Mais tu ferais mieux d'oublier\ntoute cette histoire d'équipe d'exploration.", german="Jetzt versteh mich bitte nicht\nfalsch.[K] Aber das mit dem Erkundungsteam\nsolltest du besser vergessen!", italian="Non prendere quello che sto per\ndirti nel modo sbagliato.[K] Dovresti scordarti\ndi far parte di una squadra d'esplorazione!", spanish="No te vayas a tomar esto a mal,\npero...[K] ¡Será mejor que te olvides de explorar!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?! Why?!", french=" Quoi?! Pourquoi?!", german=" Was?!? Warum?!?", italian=" Cosa?! Perché?!", spanish=" ¡¿Qué?! ¡¿Por qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?! Why?!", french=" Quoi?! Pourquoi?!", german=" Was?!? Warum?!?", italian=" Cosa?! Perché?!", spanish=" ¡¿Qué?! ¡¿Por qué?!"})
  else
  SkySceneKit.say({english=" What?! Why?!", french=" Quoi?! Pourquoi?!", german=" Was?!? Warum?!?", italian=" Cosa?! Perché?!", spanish=" ¡¿Qué?! ¡¿Por qué?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Well, you're timid.\nYou scare easy.", french="Ben désolé de te dire ça, mais\nle courage et toi, ça fait deux. Tu as peur de\nton ombre!", german="Tja, weil du zu ängstlich bist.\nDu erschrickst leicht.", italian="Beh, non hai molto coraggio. Ti\nspaventi facilmente.", spanish="A mí no me gusta criticar,\npero te asustas con facilidad."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_zubatto, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="A scaredy-cat like you can't cut\nit on an exploration team.", french="Une poule mouillée comme\ntoi, ça n'a rien à faire dans une équipe\nd'exploration, point!", german="Für eine Memme wie dich ist\nein Erkundungsteam nichts.", italian="Una mezza calzetta come te non\npuò far parte di una squadra d'esplorazione.", spanish="Alguien tan miedica no vale\npara esta profesión."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" B-but!", french=" M... mais!", german=" A-aber!", italian=" Ehi!", spanish=" ¡Pero yo...!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" B-but!", french=" M... mais!", german=" A-aber!", italian=" Come osi?", spanish=" ¡Pero yo...!"})
  else
  SkySceneKit.say({english=" B-but!", french=" M... mais!", german=" A-aber!", italian=" Ma insomma!", spanish=" ¡Pero yo...!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  GROUND:MoveToPosition(partner, 292, 220, false, 2)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Right)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It-it's true that I'm timid...", french="C'est... c'est vrai que je suis\ntimide...", german="E-es stimmt, dass ich ängstlich\nbin...", italian="È-È vero che non ho molto\ncoraggio...", spanish=" ¡Es... es cierto que soy inseguro!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It-it's true that I'm timid...", french="C'est... c'est vrai que je suis\ntimide...", german="E-es stimmt, dass ich ängstlich\nbin...", italian="È-È vero che non ho molto\ncoraggio...", spanish=" ¡Es... es cierto que soy inseguro!"})
  else
  SkySceneKit.say({english=" It-it's true that I'm timid...", french="C'est... c'est vrai que je suis\ntimide...", german="E-es stimmt, dass ich ängstlich\nbin...", italian="È-È vero che non ho molto\ncoraggio...", spanish=" ¡Es... es cierto que soy insegura!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But that's why I'm in training!\nSo I can overcome my own shortcomings!", french="Mais c'est pour ça que je\nm'entraîne! Pour surmonter mes défauts!", german="Aber darum trainiere ich!\nUm meine eigenen Schwächen zu überwinden!", italian="Ma è per questo che mi sto\nallenando! Voglio superare le mie\ndebolezze!", spanish="¡Pero para eso me entreno!\n¡Para poder superar mis defectos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But that's why I'm in training!\nSo I can overcome my own shortcomings!", french="Mais c'est pour ça que je\nm'entraîne! Pour surmonter mes défauts!", german="Aber darum trainiere ich!\nUm meine eigenen Schwächen zu überwinden!", italian="Ma è proprio per questo che\nsono qui! Voglio superare le mie debolezze\ncon l'allenamento!", spanish="¡Pero para eso me entreno!\n¡Para poder superar mis defectos!"})
  else
  SkySceneKit.say({english="But that's why I'm in training!\nSo I can overcome my own shortcomings!", french="Mais c'est pour ça que je\nm'entraîne! Pour surmonter mes défauts!", german="Aber darum trainiere ich!\nUm meine eigenen Schwächen zu überwinden!", italian="Ma è proprio questo il motivo\nper cui mi sto allenando! Per superare\nle mie debolezze!", spanish="¡Pero para eso me entreno!\n¡Para poder superar mis defectos!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Even now, I'm working hard to\nbe picked for the guild's expedition!", french="En ce moment, je travaille dur\npour faire partie de l'expédition de la Guilde!", german="Im Moment arbeite ich daran,\nfür die Gildenexpedition ausgesucht zu werden!", italian="Adesso, mi sto dando molto\nda fare per partecipare all'imminente\nspedizione della Gilda.", spanish="Si me esfuerzo lo suficiente,\npuede que vaya a la expedición del [CS:N]Pokégremio[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Even now, I'm working hard to\nbe picked for the guild's expedition!", french="En ce moment, je travaille dur\npour faire partie de l'expédition de la Guilde!", german="Im Moment arbeite ich daran,\nfür die Gildenexpedition ausgesucht zu werden!", italian="Adesso, mi sto dando molto\nda fare per partecipare all'imminente\nspedizione della Gilda.", spanish="Si me esfuerzo lo suficiente,\npuede que vaya a la expedición del [CS:N]Pokégremio[CR]."})
  else
  SkySceneKit.say({english="Even now, I'm working hard to\nbe picked for the guild's expedition!", french="En ce moment, je travaille dur\npour faire partie de l'expédition de la Guilde!", german="Im Moment arbeite ich daran,\nfür die Gildenexpedition ausgesucht zu werden!", italian="Adesso, mi sto dando molto\nda fare per partecipare all'imminente\nspedizione della Gilda.", spanish="Si me esfuerzo lo suficiente,\npuede que vaya a la expedición del [CS:N]Pokégremio[CR]."})
  end
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogaasu, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_zubatto, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Oh? An expedition, you say?", french="Tiens donc? Une expédition,\ntu dis?", german=" Oh? Eine Expedition, sagst du?", italian=" Oh? Hai detto spedizione?", spanish=" Ah, ¿una expedición?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Heh-heh. Well, effort only gets\nyou so far.", french="Hin hin hin! C'est bien beau de\nfaire des efforts.", german="Hehe. Tja, nur der Wille reicht\naber nicht.", italian="Eh-eh. Beh, puoi sforzarti...\nMa qui ci vorrebbe proprio un miracolo!", spanish="Jue, jue... Bueno, está bien que\nte esfuerces, pero eso no es suficiente."})
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="You won't get picked for the\nexpedition party if you don't have talent, right?", french="Mais quand on est pas aidé\npar la nature, faut pas compter faire partie\nde quoi que ce soit! Suivez mon regard...", german="Ohne Talent wirst du kaum ins\nExpeditionsteam gewählt werden, oder?", italian="Se non hai talento non ti\nsceglieranno per la spedizione, giusto?", spanish="¡No te escogerán para ninguna\nexpedición si no tienes un talento natural!"})
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="It all comes down to talent...\npure talent!", french="Tout n'est qu'une question de\ntalent... uniquement de talent!", german="Im Grunde geht es um Talent.\nNur um Talent!", italian="Bisogna avere talento...\nPuro talento!", spanish="Al fin y al cabo es cuestión de\ntalento... ¡Puro talento!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(partner, "angry", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" B-big talk!", french=" Bande de vantards!", german=" D-das sagst du!", italian=" S-Senti chi parla!", spanish=" ¡No me tomes el pelo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" B-big talk!", french=" Bande de vantards!", german=" D-das sagst du!", italian=" S-Senti chi parla!", spanish=" ¡No será para tanto!"})
  else
  SkySceneKit.say({english=" B-big talk!", french=" Bande de vantards!", german=" D-das sagst du!", italian=" S-Senti chi parla!", spanish=" ¡Mira quién fue a hablar!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You sure talk a lot about talent,\nbut what kind of skills do you have?", french="Vous parlez de talent, mais\nquelles sont vos compétences, à vous?", german="Du redest zwar viel über Talent,\naber welche Fähigkeiten hast du denn?", italian="Parlate di talento,\nma voi cosa sapete fare?", spanish="Mucho hablar de talento,\npero, ¿qué sabéis hacer?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You sure talk a lot about talent,\nbut what kind of skills do you have?", french="Vous parlez de talent, mais\nquelles sont vos compétences, à vous?", german="Du redest zwar viel über Talent,\naber welche Fähigkeiten hast du denn?", italian="Vi piace parlare di talento,\nma voi cosa sapete fare?", spanish="Es fácil hablar de talento,\npero, ¿qué sabéis hacer?"})
  else
  SkySceneKit.say({english="You sure talk a lot about talent,\nbut what kind of skills do you have?", french="Vous parlez de talent, mais\nquelles sont vos compétences, à vous?", german="Du redest zwar viel über Talent,\naber welche Fähigkeiten hast du denn?", italian="Talento, talento...\nMa voi cosa sapete fare?", spanish="Con todo lo que dices\nsobre tener talento, ¿qué sabéis\nhacer vosotros?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You're so weak, you even lost\nto us!", french="Vous êtes si faibles que vous\navez même perdu contre nous!", german="Ihr seid so schwach, dass ihr\nsogar gegen uns verloren habt!", italian="Vi siete fatti battere da delle\nmezze calzette come noi!", spanish="¡Sois tan debiluchos que ni\nsiquiera pudisteis con nosotros!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You were so weak, we even\nbeat you!", french="Vous êtes si faibles que vous\navez même perdu contre nous!", german="Ihr seid so schwach, dass sogar\nwir euch geschlagen haben!", italian="Avete addirittura perso contro\ndi noi!", spanish="¡Sois tan débiles que ni siquiera\nnos pudisteis vencer!"})
  else
  SkySceneKit.say({english="You're so weak, you even lost\nto us!", french="Vous êtes si faibles que vous\navez même perdu contre nous!", german="Ihr seid so schwach, dass ihr\nsogar gegen uns verloren habt!", italian="Non vi ricordate che vi siete\ndovuti arrendere a due come noi?", spanish="¡Sois tan débiles que ni siquiera\nnos pudisteis vencer!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Whoa-ho-ho! Well, we didn't\nhave the Chief with us.", french="Mouarf mouarf mouarf! C'est\nparce que notre chef n'était pas avec nous.", german="Whoahoho! Tja, da hatten wir\nden Boss nicht dabei.", italian="Uooh-ho-ho! Beh, non c'era\nil capo con noi.", spanish="¡Jo, jo, jo! Pero eso fue porque\nel Jefe no estaba con nosotros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ch-Chief?", french=" Votre... chef?", german=" B-boss?", italian=" C-Capo?", spanish=" ¿El Jefe?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ch-Chief?", french=" Votre... chef?", german=" B-boss?", italian=" C-Capo?", spanish=" ¿El Jefe?"})
  else
  SkySceneKit.say({english=" Ch-Chief?", french=" Votre... chef?", german=" B-boss?", italian=" C-Capo?", spanish=" ¿El Jefe?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Heh-heh. That's right.", french=" Hin hin. Tout à fait.", german=" Hehe. Genau.", italian=" Eh-eh. Esatto.", spanish=" Jue, jue... Así es."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Team [CS:X]Skull[CR], our exploration\nteam, has three members.", french="L'Equipe [CS:X]Crâne[CR], notre équipe\nd'exploration, compte trois membres.", german="Team [CS:X]Totenkopf[CR], unser\nErkundungsteam, hat drei Mitglieder.", italian="Il Team [CS:X]Teschio[CR], la nostra\nsquadra d'esplorazione, è composto\nda tre membri.", spanish="El [CS:X]Equipo Calavera[CR], nuestro equipo\nexplorador, tiene tres miembros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Our Chief is incredibly talented.", french=" Notre chef, c'est le meilleur.", german="Unser Boss ist extrem\ntalentiert.", italian="Il nostro capo ha un talento\nincredibile.", spanish="Nuestro Jefe tiene muchísimo\ntalento."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="To put it bluntly, he's brutally\ntough.", french="Pour être clair, c'est un dur,\nun coriace, un balaise.", german=" Man kann sagen, er ist knallhart.", italian="In tutta franchezza, ha una\nforza brutale.", spanish="Digámoslo sin rodeos...\nEs duro como un peñasco."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Heh-heh. If the Chief were\naround, we'd snap you like a twig.", french="Hin hin. Si le chef avait été là,\non se serait débarrassés de vous en deux\ntemps, trois mouvements.", german="Hehe. Wenn der Boss dabei\nwäre, würden wir euch zertreten wie einen\nWurm.", italian="Eh-eh. Se il capo fosse qui, ti\nspezzeremmo come un ramoscello.", spanish="Jue, jue... Si el Jefe estuviera\naquí, no duraríais ni un asalto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogaasu, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_zubatto, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dogaasu, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_zubatto, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Whoa-ho-ho! Speaking of the\nChief, I can smell him coming now!", french="Mouarf mouarf mouarf! En\nparlant du chef, je le sens venir d'ici!", german="Whoahoho! Wo wir vom Boss\nreden... Ich kann gerade riechen, dass er\nkommt!", italian="Uooh-ho-ho! A proposito,\neccolo che arriva!", spanish="¡Jo, jo, jo! Hablando del Jefe,\n¡huelo que viene hacia aquí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Smell?", french=" Tu le sens?", german=" Riechen?", italian=" Che odore!", spanish=" ¿Hueles?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Smell?", french=" Tu le sens?", german=" Riechen?", italian=" Che odore!", spanish=" ¿Hueles?"})
  else
  SkySceneKit.say({english=" Smell?", french=" Tu le sens?", german=" Riechen?", italian=" Che odore!", spanish=" ¿Hueles?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Here's the Chief!", french=" Voilà le chef!", german=" Hier ist der Boss!", italian=" Ecco il capo!", spanish=" ¡Aquí está el Jefe!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Team Skull.ogg", true) end)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 336, 120, Direction.Up, "NPC_SUKATANKU")
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_sukatanku, 332, 188, false, 1) -- SlidePositionMark (glissement)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_sukatanku, Direction.Down)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Right)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(npc_npc_sukatanku, 332, 208, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" Move! Out of the way!", french=" Bouge! Du balai!", german=" Verschwinde! Aus dem Weg!", italian=" Via! Levatevi di torno!", spanish=" ¡A un lado! ¡Fuera de mi camino!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6661) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  -- GAP: SetEffect 639 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GAME:MoveCamera(280, 252, 60, false) end) -- performer/caméra
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(hero, 332, 260, false, 2) -- SlidePositionMark (glissement)
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Left)
  -- SetAnimation(68) [anim idle native]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, [hero]!", french=" Oh, [hero]!", german=" Oh, [hero]!", italian=" Oh, [hero]!", spanish=" ¡[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, [hero]!", french=" Oh, [hero]!", german=" Oh, [hero]!", italian=" Oh, [hero]!", spanish=" ¡[hero]!"})
  else
  SkySceneKit.say({english=" Oh, [hero]!", french=" Oh, [hero]!", german=" Oh, [hero]!", italian=" Oh, [hero]!", spanish=" ¡[hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh! What's this awful stench?", french="Beurk! C'est quoi cette\nodeur ignoble?", german="Bah! Was ist das für ein\nfürchterlicher Gestank?", italian="Ugh! Cos'è questo tanfo\ninsopportabile?", spanish=" ¿Qué es ese pestazo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh! What's this awful stench?", french="Beurk! C'est quoi cette\nodeur ignoble?", german="Bah! Was ist das für ein\nfürchterlicher Gestank?", italian="Ugh! Cos'è questo tanfo\norrendo?", spanish=" ¿Qué es esa peste?"})
  else
  SkySceneKit.say({english=" Ew! What's this awful stench?", french="Beurk! C'est quoi cette\nodeur ignoble?", german="Igitt! Was ist das für ein\nfürchterlicher Gestank?", italian="Ugh! Cos'è questa puzza\ntremenda?", spanish=" ¿Qué es esa peste?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(136), g.ViewCenter.Y+(0), 272, false) end) -- MovePositionOffset performer/caméra
  pcall(function() GAME:MoveCamera(440, 252, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Eek! It reeks like rotten cheese!", french="Hiii! Ça pue le fromage\npourri!", german="Ieek! Es stinkt wie\nvergammelter Käse!", italian="Bleah! Puzza di formaggio andato\na male!", spanish=" ¡Jo! ¡Huele que apesta!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" That is foul, yes sirree!", french="Sapristi! C'que ça fouette!\nD'où qu'il pue donc tant, pardi?", german=" Das ist ekelhaft, jawollja!", italian=" Che puzza, sissignore!", spanish=" Huele fatal, ¡sí, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_heigani, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(4, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! My eyes are burning!", french="Eh dis donc! Ça pique les\nyeux!", german=" Hey, hey! Meine Augen brennen!", italian="Ehi, ehi, ehi! Mi bruciano gli\nocchi!", spanish=" ¡Ay, ay! ¡Me escuecen los ojos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_sukatanku, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_sukatanku, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_sukatanku, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_sukatanku, 4) end)
  GAME:WaitFrames(45)
  pcall(function() GAME:MoveCamera(304, 252, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  GAME:WaitFrames(30)
  do local p=npc_npc_sukatanku.Position; GROUND:MoveToPosition(npc_npc_sukatanku, p.X+(0), p.Y+(12), false, 1) end
  GROUND:EntTurn(partner, Direction.Right)
  do local p=npc_npc_sukatanku.Position; GROUND:MoveToPosition(npc_npc_sukatanku, p.X+(-8), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Move it! Or do you want to end\nup like that wimp over there?!", french="Hors de mon chemin! A moins\nque tu aies envie de finir comme l'autre\npoule mouillée, là-bas?!", german="Aus dem Weg! Oder willst du\nwie dieser Waschlappen da drüben enden?!?", italian="Togliti di mezzo! O vuoi fare la\nfine di quell'altro microbo?!", spanish="¡A un lado! ¿O tú también quieres\nacabar por los suelos?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh no...", french=" Oh non...", german=" Oh nein...", italian=" Oh, no...", spanish=" Oh, no..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh no...", french=" Oh non...", german=" Oh nein...", italian=" Oh, no...", spanish=" Oh, no..."})
  else
  SkySceneKit.say({english=" Oh no...", french=" Oh non...", german=" Oh nein...", italian=" Oh, no...", spanish=" Oh, no..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(40), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_sukatanku.Position; GROUND:MoveToPosition(npc_npc_sukatanku, p.X+(-24), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dogaasu, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_dogaasu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_zubatto, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Chief!", french=" Chef!", german=" Boss!", italian=" Capo!", spanish=" ¡Jefe!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="You showed them, Chief! You're\nthe best!", french="Vous leur en avez mis plein le\nnez, chef! Z'êtes le meilleur!", german="Du hast es ihnen gezeigt, Boss!\nDu bist der Beste!", italian="Gliel'hai fatta vedere, capo! Sei\nil migliore!", spanish="¡Les has dado una buena lección,\nJefe! ¡Eres el mejor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dogaasu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_zubatto, nil, 0) end) -- EFFECT_NONE
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Yeah, yeah, whatever.[K]\nSo, you two, did you sniff out any jobs that'll\nbring in the cash?", french="Ouais, ouais, c'est ça.[K]\nAlors vous deux, vous avez flairé les\nmissions qui vont rapporter gros?", german="Ja, ja, schon gut.[K]\nAlso, ihr zwei, habt ihr irgendwelche Jobs\ngefunden, die Moneten einbringen?", italian="Sì, sì, basta così.[K]\nAllora, siete riusciti a trovare qualche\nmissione per farci un bel gruzzoletto?", spanish="Bah, no ha sido nada...[K]\nA ver, ¿habéis encontrado alguna misión que\nnos permita sacar un buen pico?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="The Job Bulletin Board only\nposted cheap tasks, but...", french="Sur le Tableau des Missions, y'a\nque des boulots mal payés, mais...", german="Am Job-Infobrett hängen nur\nbillige Jobs...", italian="La Bacheca è piena di missioni\nda due soldi, ma...", spanish="En el Tablón de Anuncios solo\nhay encargos más bien pobretones, pero..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="There's something else, Chief.\nIt's got the potential to go big...", french="Y'a autre chose, chef.\nÇa risque d'être gros...", german="Dafür gibt es etwas anderes,\nBoss. Das könnte eine ganz große Sache\nwerden...", italian="C'è qualcos'altro, capo.\nPotrebbe rivelarsi molto interessante...", spanish="Hay otra cosa, Jefe. Algo con lo\nque podremos sacar tajada..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_zubatto.Position; GROUND:MoveToPosition(npc_npc_zubatto, p.X+(10), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Psst...psst...whisper...psst...", french=" Psst... psst... blablabla... psst...", german=" Psst... psst... flüster... psst...", italian=" Psss... psss... psss... psss...", spanish=" Pss... Pss... Pss..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sukatanku, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="What? An expedition from\nthis guild?", french="Quoi? Une expédition avec cette\nGuilde?", german=" Was? Eine Expedition der Gilde?", italian="Cosa? Una spedizione di questa\nGilda?", spanish="¿Cómo? ¿Una expedición\ndel [CS:N]Pokégremio[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" That does sound tasty.", french=" Ça a l'air juteux.", german=" Das hört sich ausgezeichnet an.", italian=" Questo è pane per i miei denti.", spanish=" Eso me huele muy bien."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Doesn't it?", french=" N'est-ce pas?", german=" Nicht wahr?", italian=" Vero?", spanish=" ¿A que sí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Let's get out of here. We need\nto do some plotting.", french="Sortons d'ici. Il nous faut\nun plan, les gars.", german="Hauen wir ab. Wir müssen ein\npaar Vorbereitungen treffen.", italian="Andiamocene. Dobbiamo\narchitettare qualcosa.", spanish="Salgamos de aquí.\nVamos a tener que tramar algo."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" Come on. We're going.", french=" Allez. On y va.", german=" Kommt schon! Gehen wir.", italian=" Forza. Gambe in spalla.", spanish=" Venga. Vámonos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="[CS:N]Koffing[CR] & [CS:N]Zubat[CR]: Yeah!", french="[CS:N]Smogo[CR] et [CS:N]Nosferapti[CR]: Ouais!", german="[CS:N]Smogon[CR] & [CS:N]Zubat[CR]: Jaaa!", italian="[CS:N]Koffing[CR] e [CS:N]Zubat[CR]: Sì!", spanish="[CS:N]Koffing[CR] y [CS:N]Zubat[CR]: ¡Sí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_sukatanku, 332, 220, false, 2)
  GROUND:MoveToPosition(npc_npc_sukatanku, 332, 116, false, 2)
  GROUND:MoveToPosition(npc_npc_dogaasu, 332, 220, false, 2)
  GAME:WaitFrames(60)
  do local p=npc_npc_zubatto.Position; GROUND:MoveToPosition(npc_npc_zubatto, p.X+(40), p.Y+(16), false, 2) end
  GROUND:EntTurn(npc_npc_dogaasu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_zubatto, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="What are you all staring at?\nThis isn't a public performance!", french="Qu'est-ce que vous regardez\ncomme ça? Circulez, y'a rien à voir!", german="Was glotzt ihr so? Das ist keine\nUnterhaltungsshow!", italian="Cosa state guardando?\nNon è uno spettacolo pubblico!", spanish="¿Qué estáis mirando?\n¡Esto no es una obra de teatro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "sweating", 1) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_heigani, 4) end)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  GROUND:MoveToPosition(npc_npc_dogaasu, 332, 116, false, 2)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Heh-heh, see you around, wimps.", french="Hin hin, à la prochaine,\nles poules mouillées.", german="Hehe, bis dann, ihr\nWaschlappen.", italian=" Eh-eh, ci vediamo, microbi.", spanish=" Jue, jue. Nos vemos, enclenques."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_zubatto, 332, 220, false, 2)
  GROUND:EntTurn(partner, Direction.UpRight)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GROUND:MoveToPosition(npc_npc_zubatto, 332, 116, false, 2)
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(60)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() GAME:MoveCamera(320, 252, 60, false) end) -- performer/caméra
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(18), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Are you all right, [hero]?!", french=" Tu vas bien, [hero]?!", german=" Alles okay, [hero]?!?", italian=" Stai bene, [hero]?!", spanish=" ¡¿Estás bien, [hero]?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are you OK, [hero]?!", french=" Tu vas bien, [hero]?!", german=" Alles okay, [hero]?!?", italian=" Stai bene, [hero]?!", spanish=" ¡¿Estás bien, [hero]?!"})
  else
  SkySceneKit.say({english=" Are you OK, [hero]?!", french=" Tu vas bien, [hero]?!", german=" Alles okay, [hero]?!?", italian=" Stai bene, [hero]?!", spanish=" ¡¿Estás bien, [hero]?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-16), p.Y+(0), false, 2) end -- SlidePositionOffset
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Great! It doesn't look like\nyou're hurt.", french=" Parfait! Tu as l'air indemne.", german="Gut! Du bist anscheinend nicht\nverletzt.", italian="Bene! Non sembra che tu abbia\ndelle ferite.", spanish="¡Menos mal! No parece\nhaberte hecho daño."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Great! It doesn't look like\nyou're injured.", french=" Parfait! Tu as l'air indemne.", german="Gut! Du scheinst nicht verletzt\nzu sein.", italian="Bene! Non sembra che tu abbia\ndelle ferite.", spanish="¡Menos mal! No parece\nhaberte hecho daño."})
  else
  SkySceneKit.say({english="Great! It doesn't look like\nyou're injured.", french=" Parfait! Tu as l'air indemne.", german="Gut! Du scheinst nicht verletzt\nzu sein.", italian="Bene! Non sembra che tu abbia\ndelle ferite.", spanish="¡Menos mal! No parece\nhaberte hecho daño."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That sure was rough, though.", french=" Quelle brute!", german=" Trotzdem, das war wirklich fies.", italian=" Te la sei vista brutta, comunque.", spanish="Pero ha tenido que ser\ndesagradable."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That sure was rough, though.", french=" Quelle brute!", german=" Trotzdem, das war wirklich fies.", italian=" Te la sei vista brutta, comunque.", spanish="Pero ha tenido que ser\ndesagradable."})
  else
  SkySceneKit.say({english=" That goon was rough, though.", french=" Quelle brute!", german="Trotzdem, dieser Brutalo war\nwirklich gemein.", italian=" Te la sei vista brutta, comunque.", spanish="Pero ha tenido que ser\ndesagradable."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I couldn't work up the courage to\nchallenge him to his face!", french="Je n'ai pas eu le courage de lui\nrabattre le caquet!", german="Ich habe mich nicht getraut, ihm\ndie Meinung ins Gesicht zu sagen!", italian="Non ho avuto il coraggio\ndi raccogliere la sua sfida!", spanish="¡No he tenido valor para\nplantarle cara!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I couldn't work up the courage to\nchallenge him to his face!", french="Je n'ai pas eu le courage de lui\nrabattre le caquet!", german="Ich habe mich nicht getraut, ihm\ndie Meinung ins Gesicht zu sagen!", italian="Non ho avuto il coraggio\ndi raccogliere la sua sfida!", spanish="¡No he tenido valor para\nplantarle cara!"})
  else
  SkySceneKit.say({english="I couldn't work up the courage to\nchallenge him to his face!", french="Je n'ai pas eu le courage de lui\nrabattre le caquet!", german="Ich habe mich nicht getraut, ihm\ndie Meinung ins Gesicht zu sagen!", italian="Non ho avuto il coraggio\ndi raccogliere la sua sfida!", spanish="¡No he tenido valor para\nplantarle cara!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Even though he knocked you out,\n[hero]... I'm so disappointed in myself...", french="En plus, il s'en est pris à toi,\n[hero]... Je suis pitoyable...", german="Und das, obwohl er dich\numgehauen hat, [hero]. Ich bin so\nenttäuscht von mir selbst.", italian="Anche se ti ha messo KO,\n[hero]... Sono molto deluso da me\nstesso...", spanish="Ni siquiera para defenderte,\n[hero]. ¡Vaya compañero soy!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Even though he hurt you,\n[hero]... I'm ashamed of myself...", french="En plus, il s'en est pris à toi,\n[hero]... Je suis pitoyable...", german="Und das, obwohl er dir wehgetan\nhat, [hero]. Ich schäme mich dafür.", italian="Anche se ti ha messo KO,\n[hero]... Sono molto deluso da me\nstesso...", spanish="Ni siquiera para defenderte,\n[hero]. ¡Vaya compañero soy!"})
  else
  SkySceneKit.say({english="Even though he knocked you out,\n[hero]... I let you down...", french="En plus, il s'en est pris à toi,\n[hero]... Je suis pitoyable...", german="Und das, obwohl er dich\numgehauen hat, [hero]. Ich habe dich\nim Stich gelassen.", italian="Anche se ti ha messo KO,\n[hero]... Sono molto delusa da me\nstessa...", spanish="Ni siquiera para defenderte,\n[hero]. ¡Vaya compañera soy!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="They're right... I am a wimp...\nA big chicken.", french="Ils ont raison... je ne suis...\nqu'une grosse poule mouillée.\nLe roi des poltrons.", german="Sie haben recht, ich bin ein\nWaschlappen. Und ein Angsthase!", italian="Hanno ragione... Sono una mezza\ncalzetta... Un fifone.", spanish="Tienen razón.\nSoy un cobarde, y un inútil..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="They're right... I am a wimp...\nA big chicken.", french="Ils ont raison... je ne suis...\nqu'une grosse poule mouillée.\nLe roi des poltrons.", german="Sie haben recht, ich bin ein\nWaschlappen. Und ein Angsthase!", italian="Hanno ragione... Sono una mezza\ncalzetta... Un fifone.", spanish="Tienen razón.\nSoy un enclenque y un miedica..."})
  else
  SkySceneKit.say({english="They're right... I am a wimp...\nA big chicken.", french="Ils ont raison... je ne suis...\nqu'une grosse poule mouillée.\nLa reine des poltronnes.", german="Sie haben recht, ich bin ein\nWaschlappen. Und ein Angsthase!", italian="Hanno ragione... Sono una mezza\ncalzetta... Una fifona.", spanish="Tienen razón.\nSoy una enclenque y una miedica."})
  end
  do local __choice = SkySceneKit.ask({{english="You're not a wimp...", french="Tu n'es pas une poule mouillée.", german="Du bist kein Angsthase...", italian="Non sei una mezza calzetta...", spanish="No eres miedica..."}, {english="Bok bok bok!", french="Cot cot cooooot!", german="Angsthase!", italian="Ehm...", spanish="¡Gallina!"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I-I guess you're right...", french=" Tu... tu as sûrement raison...", german=" D-du hast wahrscheinlich recht...", italian=" P-Probabilmente hai ragione...", spanish=" Su... supongo que tienes razón."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I-I guess you're right...", french=" Tu... tu as sûrement raison...", german=" D-du hast wahrscheinlich recht...", italian=" P-Probabilmente hai ragione...", spanish=" Su... supongo que tienes razón."})
  else
  SkySceneKit.say({english=" I-I guess you're right...", french=" Tu... tu as sûrement raison...", german=" D-du hast wahrscheinlich recht...", italian=" P-Probabilmente hai ragione...", spanish=" Su... supongo que tienes razón."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'm a really big chicken.", french="Je suis vraiment une poule\nmouillée.", german=" Ich bin wirklich ein Angsthase.", italian=" Sono proprio un gran fifone.", spanish=" La verdad es que soy un gallina."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I'm a really big chicken.", french="Je suis vraiment une poule\nmouillée.", german=" Ich bin wirklich ein Angsthase.", italian=" Sono proprio un gran fifone.", spanish=" La verdad es que soy un gallina."})
  else
  SkySceneKit.say({english=" I'm a really big chicken.", french="Je suis vraiment une poule\nmouillée.", german=" Ich bin wirklich ein Angsthase.", italian=" Sono proprio una gran fifona.", spanish=" La verdad es que soy cobarde."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But it's nothing new for me...", french=" Ce n'est pas nouveau...", german=" Aber das weiß ich schon lange.", italian=" Ma tanto lo sapevo già...", spanish=" Siempre lo he sabido..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But it's nothing new for me...", french=" Ce n'est pas nouveau...", german=" Aber das weiß ich schon lange.", italian=" Ma tanto lo sapevo già...", spanish=" Siempre lo he sabido..."})
  else
  SkySceneKit.say({english=" But it's nothing new for me...", french=" Ce n'est pas nouveau...", german=" Aber das weiß ich schon lange.", italian=" Ma tanto lo sapevo già...", spanish=" Siempre lo he sabido..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I've decided that I can still do\nmy best even if I'm not very brave.", french="J'ai décidé de faire de mon\nmieux même si je manque de courage.", german="Ich habe beschlossen, dass ich\ntrotzdem mein Bestes geben kann, auch wenn\nich nicht so mutig bin.", italian="Anche se a volte mi manca il\ncoraggio, quello che posso fare è cercare di\ndare sempre il meglio di me.", spanish="Pero he decidido que aun siendo\nun miedica voy a hacer lo que pueda."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I've decided that I can still do\nmy best even if I'm not very brave.", french="J'ai décidé de faire de mon\nmieux même si je manque de courage.", german="Ich habe beschlossen, dass ich\ntrotzdem mein Bestes geben kann, auch wenn\nich nicht so mutig bin.", italian="Anche se a volte mi manca il\ncoraggio, quello che posso fare è cercare di\ndare sempre il meglio di me.", spanish="Pero he decidido que aun siendo\nun miedica voy a hacer lo que pueda."})
  else
  SkySceneKit.say({english="I've decided that I can still do\nmy best even if I'm not very brave.", french="J'ai décidé de faire de mon\nmieux même si je manque de courage.", german="Ich habe beschlossen, dass ich\ntrotzdem mein Bestes geben kann, auch wenn\nich nicht so mutig bin.", italian="Anche se a volte mi manca il\ncoraggio, quello che posso fare è cercare di\ndare sempre il meglio di me.", spanish="Pero he decidido que aun siendo\nuna miedica voy a hacer lo que pueda."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I won't let something like this\nbreak me.", french="Pas question de me laisser\nabattre.", german="Ich lasse mich nicht von so\netwas herunterziehen.", italian="Non mi farò demoralizzare da\nuna cosa del genere.", spanish="No voy a dejar que eso me\nafecte."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm not going to give up over\nsomething like this.", french="Pas question de me laisser\nabattre.", german="Wegen so etwas werde ich nicht\ndas Handtuch werfen.", italian="Non mi farò demoralizzare da\nuna cosa del genere.", spanish=" No voy a rendirme por algo así."})
  else
  SkySceneKit.say({english="I'm not giving up over something\nlike this.", french="Pas question de me laisser\nabattre.", german="Wegen so etwas werfe ich nicht\ndas Handtuch.", italian="Non mi farò demoralizzare da\nuna cosa del genere.", spanish=" No voy a rendirme por algo así."})
  end
  -- message_KeyWait
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'm going to be cheerful and\nkeep trying.", french="Je vais rester optimiste et\npersévérer.", german="Ich werde mir meine gute Laune\nnicht verderben lassen und nicht aufgeben.", italian="Rimarrò di buon umore e\ncontinuerò a provare.", spanish="Voy a seguir intentándolo\nsin desmoralizarme."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm going to be cheerful and\nkeep trying.", french="Je vais rester optimiste et\npersévérer.", german="Ich werde mir meine gute Laune\nnicht verderben lassen und nicht aufgeben.", italian="Rimarrò di buon umore e\ncontinuerò a provare.", spanish="Voy a seguir intentándolo\nsin desmoralizarme."})
  else
  SkySceneKit.say({english="I'm going to be cheerful and\nkeep trying.", french="Je vais rester optimiste et\npersévérer.", german="Ich werde mir meine gute Laune\nnicht verderben lassen und nicht aufgeben.", italian="Rimarrò di buon umore e\ncontinuerò a provare.", spanish="Voy a seguir intentándolo\nsin desmoralizarme."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Thanks for straightening me\nout, [hero]!", french="Merci d'essayer de me secouer,\n[hero]!", german="Danke, dass du mir die\nWahrheit gesagt hast, [hero]!", italian="Grazie per avermici fatto\npensare, [hero]!", spanish="¡Gracias por dejarme las cosas\nclaras, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Thank you for straightening me\nout, [hero]!", french="Merci d'essayer de me secouer,\n[hero]!", german="Danke, dass du mir die\nWahrheit gesagt hast, [hero]!", italian="Grazie per avermici fatto\npensare, [hero]!", spanish="¡Gracias por dejarme las cosas\nclaras, [hero]!"})
  else
  SkySceneKit.say({english="Thank you for straightening me\nout, [hero]!", french="Merci d'essayer de me secouer,\n[hero]!", german="Danke, dass du mir die\nWahrheit gesagt hast, [hero]!", italian="Grazie per avermici fatto\npensare, [hero]!", spanish="¡Gracias por dejarme las cosas\nclaras, [hero]!"})
  end
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Thanks for trying to cheer me\nup, [hero]...", french="Merci d'essayer de me\nréconforter, [hero]...", german="Danke, dass du mich\naufheitern willst, [hero].", italian="Grazie per aver provato a\nrisollevarmi il morale, [hero]...", spanish="Gracias por intentar\nanimarme, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Thanks for trying to cheer me\nup, [hero]...", french="Merci d'essayer de me\nréconforter, [hero]...", german="Danke, dass du mich\naufheitern willst, [hero].", italian="Grazie per aver provato a\nrisollevarmi il morale, [hero]...", spanish="Gracias por intentar\nanimarme, [hero]."})
  else
  SkySceneKit.say({english="Thanks for trying to cheer me\nup, [hero]...", french="Merci d'essayer de me\nréconforter, [hero]...", german="Danke, dass du mich\naufheitern willst, [hero].", italian="Grazie per aver provato a\nrisollevarmi il morale, [hero]...", spanish="Gracias por intentar\nanimarme, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But...", french=" Mais...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But...", french=" Mais...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  else
  SkySceneKit.say({english=" But...", french=" Mais...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But I really am a wimp...", french="C'est comme ça, je suis\nvraiment une poule mouillée...", german="Aber ich bin wirklich ein\nAngsthase...", italian="E sì, sono davvero una mezza\ntacca...", spanish="La verdad es que sí que\nsoy un miedica."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But I really am a wimp...", french="C'est comme ça, je suis\nvraiment une poule mouillée...", german="Aber ich bin wirklich ein\nAngsthase...", italian="E sì, sono davvero una mezza\ntacca...", spanish="Lo cierto es que sí que\nsoy un miedica."})
  else
  SkySceneKit.say({english=" But I really am a wimp...", french="C'est comme ça, je suis\nvraiment une poule mouillée...", german="Aber ich bin wirklich ein\nAngsthase...", italian="E sì, sono davvero una mezza\ntacca...", spanish="La verdad es que sí que\nsoy miedica."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But it's nothing new for me...", french=" Ce n'est pas nouveau...", german=" Das weiß ich schon lange.", italian=" Ma tanto lo sapevo già...", spanish=" Siempre lo he sabido..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But it's nothing new for me...", french=" Ce n'est pas nouveau...", german=" Das weiß ich schon lange.", italian=" Ma tanto lo sapevo già...", spanish=" Siempre lo he sabido..."})
  else
  SkySceneKit.say({english=" But it's nothing new for me...", french=" Ce n'est pas nouveau...", german=" Das weiß ich schon lange.", italian=" Ma tanto lo sapevo già...", spanish=" Siempre lo he sabido..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I've decided that I can still do\nmy best even if I'm not very brave.", french="J'ai décidé de faire de mon\nmieux même si je manque de courage.", german="Ich habe beschlossen, dass ich\ntrotzdem mein Bestes geben kann, auch wenn\nich nicht so mutig bin.", italian="Anche se a volte mi manca il\ncoraggio, quello che posso fare è cercare\ndi dare sempre il meglio di me.", spanish="Pero he decidido que aun siendo\nun miedica voy a hacer lo que pueda."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I've decided that I can still do\nmy best even if I'm not very brave.", french="J'ai décidé de faire de mon\nmieux même si je manque de courage.", german="Ich habe beschlossen, dass ich\ntrotzdem mein Bestes geben kann, auch wenn\nich nicht so mutig bin.", italian="Anche se a volte mi manca il\ncoraggio, quello che posso fare è cercare\ndi dare sempre il meglio di me.", spanish="Pero he decidido que aun siendo\nun miedica voy a hacer lo que pueda."})
  else
  SkySceneKit.say({english="I've decided that I can still do\nmy best even if I'm not very brave.", french="J'ai décidé de faire de mon\nmieux même si je manque de courage.", german="Ich habe beschlossen, dass ich\ntrotzdem mein Bestes geben kann, auch wenn\nich nicht so mutig bin.", italian="Anche se a volte mi manca il\ncoraggio, quello che posso fare è cercare\ndi dare sempre il meglio di me.", spanish="Pero he decidido que aun siendo\nuna miedica voy a hacer lo que pueda."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I won't let something like this\nbreak me.", french="Pas question de me laisser\nabattre.", german="Ich lasse mich nicht von so\netwas herunterziehen.", italian="Non mi farò demoralizzare da\nuna cosa del genere.", spanish="No voy a dejar que eso me\nafecte."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm not going to give up over\nsomething like this.", french="Pas question de me laisser\nabattre.", german="Wegen so etwas werde ich nicht\ndas Handtuch werfen.", italian="Non mi farò demoralizzare da\nuna cosa del genere.", spanish=" No voy a rendirme por algo así."})
  else
  SkySceneKit.say({english="I'm not giving up over something\nlike this.", french="Pas question de me laisser\nabattre.", german="Wegen so etwas werfe ich nicht\ndas Handtuch.", italian="Non mi farò demoralizzare da\nuna cosa del genere.", spanish=" No voy a rendirme por algo así."})
  end
  -- message_KeyWait
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'm going to be cheerful and\nkeep trying.", french="Je vais rester optimiste et\npersévérer.", german="Ich werde mir meine gute Laune\nnicht verderben lassen und nicht aufgeben.", italian="Manterrò il mio buonumore e\ncontinuerò a provare.", spanish="Voy a seguir intentándolo\nsin desmoralizarme."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm going to be cheerful and\nkeep trying.", french="Je vais rester optimiste et\npersévérer.", german="Ich werde mir meine gute Laune\nnicht verderben lassen und nicht aufgeben.", italian="Manterrò il mio buonumore e\ncontinuerò a provare.", spanish="Voy a seguir intentándolo\nsin desmoralizarme."})
  else
  SkySceneKit.say({english="I'm going to be cheerful and\nkeep trying.", french="Je vais rester optimiste et\npersévérer.", german="Ich werde mir meine gute Laune\nnicht verderben lassen und nicht aufgeben.", italian="Manterrò il mio buonumore e\ncontinuerò a provare.", spanish="Voy a seguir intentándolo\nsin desmoralizarme."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Thanks, [hero]!", french=" Merci, [hero]!", german=" Danke, [hero]!", italian=" Grazie, [hero]!", spanish=" ¡Gracias, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Thank you, [hero]!", french=" Merci, [hero]!", german=" Vielen Dank, [hero]!", italian=" Grazie, [hero]!", spanish=" ¡Gracias, [hero]!"})
  else
  SkySceneKit.say({english=" Thank you, [hero]!", french=" Merci, [hero]!", german=" Vielen Dank, [hero]!", italian=" Grazie, [hero]!", spanish=" ¡Gracias, [hero]!"})
  end
  -- @label_2 [étiquette de flux ExplorerScript]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="For now, we'd better keep\nworking like we've been doing.", french="Pour l'instant, continuons\nà travailler dur, comme d'habitude.", german="Gehen wir jetzt fürs Erste\nbesser unserer gewohnten Arbeit nach.", italian="Per il momento, dovremmo\ncontinuare a lavorare come abbiamo fatto\nfinora.", spanish="Por ahora vamos a seguir como\nsiempre."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="For now, we'd better keep\nworking like we've been doing.", french="Pour l'instant, continuons\nà travailler dur, comme d'habitude.", german="Gehen wir jetzt fürs Erste\nbesser unserer gewohnten Arbeit nach.", italian="Per il momento, dovremmo\ncontinuare a lavorare come abbiamo fatto\nfinora.", spanish="Por el momento, sigamos como\nhasta ahora."})
  else
  SkySceneKit.say({english="For now, we'd better keep\nworking like we've been doing.", french="Pour l'instant, continuons\nà travailler dur, comme d'habitude.", german="Gehen wir jetzt fürs Erste\nbesser unserer gewohnten Arbeit nach.", italian="Per il momento, dovremmo\ncontinuare a lavorare come abbiamo fatto\nfinora.", spanish="Sigamos con nuestra dinámica\nde siempre."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Today we're supposed to handle\nthe jobs on the Job Bulletin Board and the\nOutlaw Notice Board.", french="Aujourd'hui, on doit se charger\ndes missions du Tableau des Missions et des\nAvis de Recherche.", german="Heute sollen wir uns um die\nJobs kümmern, die an den Job- und\nGanoven-Infobrettern aushängen.", italian="Oggi dobbiamo occuparci\ndelle missioni sulla Bacheca delle missioni\ne di quelle sulla Bacheca dei ricercati.", spanish="Hoy nos toca encargarnos\nde las misiones del Tablón de Anuncios\ny del Tablón \"Se Busca\"."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Today we're supposed to handle\nthe jobs on the Job Bulletin Board and the\nOutlaw Notice Board.", french="Aujourd'hui, on doit se charger\ndes missions du Tableau des Missions et des\nAvis de Recherche.", german="Heute sollen wir uns um die\nJobs kümmern, die an den Job- und\nGanoven-Infobrettern aushängen.", italian="Oggi dobbiamo occuparci\ndelle missioni sulla Bacheca delle missioni\ne di quelle sulla Bacheca dei ricercati.", spanish="Hoy nos toca encargarnos\nde las misiones del Tablón de Anuncios\ny del Tablón \"Se Busca\"."})
  else
  SkySceneKit.say({english="Today we're supposed to handle\nthe jobs on the Job Bulletin Board and the\nOutlaw Notice Board.", french="Aujourd'hui, on doit se charger\ndes missions du Tableau des Missions et des\nAvis de Recherche.", german="Heute sollen wir uns um die\nJobs kümmern, die an den Job- und\nGanoven-Infobrettern aushängen.", italian="Oggi dobbiamo occuparci\ndelle missioni sulla Bacheca delle missioni\ne di quelle sulla Bacheca dei ricercati.", spanish="Hoy nos toca encargarnos\nde las misiones del Tablón de Anuncios\ny del Tablón \"Se Busca\"."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's keep at it, [hero]!", french=" Continuons, [hero]!", german="Halten wir uns ran,\n[hero]!", italian="Continuiamo a darci da fare,\n[hero]!", spanish="¡Pongámonos a ello,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's keep at it, [hero]!", french=" Continuons, [hero]!", german="Halten wir uns ran,\n[hero]!", italian="Continuiamo a dare il meglio,\n[hero]!", spanish="¡Pongámonos manos a la obra,\n[hero]!"})
  else
  SkySceneKit.say({english=" Let's keep at it, [hero]!", french=" Continuons, [hero]!", german="Halten wir uns ran,\n[hero]!", italian="Diamo il massimo,\n[hero]!", spanish="¡Centrémonos en eso,\n[hero]!"})
  end
  -- message_Close
  end
  end
  SkySceneKit.cleanup_npcs()
end
