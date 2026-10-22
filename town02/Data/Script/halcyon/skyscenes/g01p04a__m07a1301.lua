-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m07a1301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Ahem. One last item.", french=" Hum, hum! Une dernière chose.", german=" Ähem. Eine Sache noch.", italian=" Ahem. Un'ultima cosa.", spanish=" Ejem. Una última cosa."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Tomorrow or the day after...\nOr perhaps in several days' time...", french="Demain ou après-demain...\nou peut-être dans quelques jours...", german="Morgen oder übermorgen, oder\nauch in einigen Tagen...", italian="Domani oppure domani l'altro...\nO forse tra qualche giorno...", spanish="Mañana, o pasado mañana...\nO tal vez dentro de varios días..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We plan to announce the\nmembers of the expedition party. ♪", french="... nous annoncerons qui fera\npartie de l'expédition. ♪", german="An einem dieser Tage wollen wir\ndie Mitglieder des Expeditionsteams\nbekanntgeben. ♪", italian="... abbiamo intenzione di\nannunciare i nomi di coloro che\nparteciperanno alla spedizione. ♪", spanish="Planeamos anunciar la lista\nde integrantes de la expedición. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 360, 272, Direction.UpRight, "NPC_DAGUTORIO")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 392, 272, Direction.Up, "NPC_HEIGANI")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 424, 256, Direction.Up, "NPC_BIPPA")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 456, 256, Direction.Up, "NPC_KIMAWARI")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 456, 272, Direction.Up, "NPC_DIGUDA")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 392, 256, Direction.Up, "NPC_CHIRIIN")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Up, "NPC_DOGOOMU")
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Wow!", french=" Waouh!", german=" Wow!", italian=" Wow!", spanish=" ¡Bien!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="By golly, the members are\nfinally going to be picked!", french="Sapristi! Les membres\nd'l'expédition, ils vont enfin être choisis!", german="Donnerwetter, endlich werden\ndie Mitglieder bestimmt!", italian="Ohibò, finalmente stanno per\nscegliere i membri!", spanish="Huy, ¡por fin vamos a saber\nquiénes son los elegidos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Oh my gosh! It will be so fun!", french="Ben mince alors! J'hallucine!\nÇa va être trop bien!", german=" Hui! Das wird ein Riesenspaß!", italian=" Shock! Sarà così divertente!", spanish=" ¡Estoy superemocionada!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Everyone, this is your last\nchance to make an impression. ♪", french="C'est donc votre dernière chance\nde faire bonne impression. ♪", german="Das ist für euch alle die letzte\nChance, einen guten Eindruck zu machen. ♪", italian="Gente, questa è la vostra\nultima occasione per fare bella figura. ♪", spanish="Esta es la última oportunidad\nque tenéis para destacar. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Work hard and impress us if you\nwant to be chosen. ♪", french="Travaillez dur et\nimpressionnez-nous si vous voulez\nêtre choisis. ♪", german="Bemüht euch und beeindruckt\nuns, wenn ihr ausgewählt werden wollt. ♪", italian="Lavorate bene e sorprendeteci\nse volete entrare nella squadra. ♪", spanish="Esforzaos e impresionadnos\nsi queréis ser seleccionados. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="All right, everyone. ♪ Let's get\ndown to work as usual. ♪", french="Allez, vous tous. ♪ Au travail\ncomme à l'accoutumée. ♪", german="In Ordnung, Pokémon. ♪ Nun\ngeht eurer gewohnten Arbeit nach. ♪", italian="Bene, gente. ♪ Andiamo a\nfare il nostro lavoro come al solito. ♪", spanish="Muy bien... ♪ Ahora, todos a\ntrabajar. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  GAME:WaitFrames(1)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  -- SetAnimation(24) [anim idle native]
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: URRÀ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
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
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Down)
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_diguda, Direction.Down)
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Left)
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 336, 232, Direction.Right, "NPC_SUKATANKU")
  GROUND:MoveToPosition(npc_npc_sukatanku, 324, 132, false, 2)
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 312, 224, Direction.DownRight, "NPC_ZUBATTO")
  GROUND:MoveToPosition(npc_npc_zubatto, 324, 132, false, 2)
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 312, 248, Direction.Right, "NPC_DOGAASU")
  GROUND:MoveToPosition(npc_npc_dogaasu, 324, 132, false, 2)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 424, 208, Direction.Down, "NPC_PUKURIN")
  GROUND:MoveToPosition(npc_npc_pukurin, 420, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 224, 252, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 188, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 240, 272, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 188, false, 2)
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(-32), p.Y+(0), false, 2) end -- Move2PositionOffset
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_kimawari, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 132, false, 2)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'm so hungry, [hero]...", french="J'ai tellement faim,\n[hero]...", german="Ich habe solchen Hunger,\n[hero]...", italian=" Ho tanta fame, [hero]...", spanish="Tengo la tripa vacía,\n[hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I'm so hungry, [hero]...", french="J'ai tellement faim,\n[hero]...", german="Ich habe solchen Hunger,\n[hero]...", italian=" Ho tanta fame, [hero]...", spanish="Estoy tan hambriento,\n[hero]..."})
  else
  SkySceneKit.say({english=" I'm so hungry, [hero]...", french="J'ai tellement faim,\n[hero]...", german="Ich habe solchen Hunger,\n[hero]...", italian=" Ho tanta fame, [hero]...", spanish="Estoy tan hambrienta,\n[hero]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Ah, you two.", french=" Hé! Vous deux.", german=" Ah, ihr zwei.", italian=" Ah, voi due.", spanish=" Ah, aquí estáis."})
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(456, 240, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 472, 248, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(partner, 440, 248, false, 2)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You two should take care of\nlisted jobs today.", french="Aujourd'hui, accomplissez\ncertaines des missions qui sont affichées.", german="Kümmert euch heute um die\nausgeschriebenen Jobs.", italian="Oggi voi due dovreste occuparvi\ndelle missioni affisse sulle Bacheche.", spanish="Hoy tenéis que realizar las\nmisiones que veáis en los tablones."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" We're counting on you. ♪", french=" Nous comptons sur vous. ♪", german=" Wir zählen auf euch. ♪", italian=" Contiamo su di voi. ♪", spanish=" Contamos con vosotros. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="There's one other thing. About\nthe expedition...", french="Encore une chose. A propos\nde l'expédition...", german="Eine Sache noch. Was die\nExpedition angeht...", italian="C'è un'altra cosa. A proposito\ndella spedizione...", spanish=" Ah, una cosa más..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You should give up on being\nchosen as expedition members.", french="Vous devriez vous faire une\nraison. Vous n'avez aucune chance d'en faire\npartie.", german="Ihr solltet nicht erwarten, als\nExpeditionsmitglieder ausgewählt zu werden.", italian=" Penso che dovreste rinunciare.", spanish="Ya os podéis ir olvidando de que\nos seleccionemos para la expedición."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?! Wh-why?!", french=" Hein?! Pourquoi?!", german=" Häh?!? W-warum?!?", italian=" Eh?! P-Perché?!", spanish=" ¡¿Qué?! ¡¿Por qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh?! Wh-why?!", french=" Hein?! Pourquoi?!", german=" Häh?!? W-warum?!?", italian=" Eh?! P-Perché?!", spanish=" ¡¿Qué?! ¡¿Por qué?!"})
  else
  SkySceneKit.say({english=" Huh?! Wh-why?!", french=" Hein?! Pourquoi?!", german=" Häh?!? W-warum?!?", italian=" Eh?! P-Perché?!", spanish=" ¡¿Qué?! ¡¿Por qué?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Your failure yesterday\nweighs heavily.", french="Votre échec d'hier va peser\nlourd dans la balance.", german="Euer gestriges Versagen wiegt\nschwer.", italian="Quello che è successo ieri ha un\npeso determinante.", spanish="El fracaso de ayer sin duda\ntendrá un gran peso en la decisión final."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="As you know, it is difficult to\ntell what our Guildmaster is thinking from his\ndemeanor...", french="Comme vous le savez, les\npensées du Maître sont impénétrables...", german="Wie ihr wisst, kann man aus\ndem Verhalten des Gildenmeisters schwer\nschließen, was er denkt.", italian="Come saprete, mi è difficile\ncapire cosa passa per la testa del Capitano\ndal suo comportamento...", spanish="Como sabéis, el comportamiento\ndel Gran Bluff impide saber lo que piensa..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But there's no doubt that he\nmust be seething with anger inside.", french="... mais il ne fait aucun doute\nqu'il doit bouillir de colère.", german="Aber es besteht kein Zweifel,\ndass er innerlich vor Wut kochen muss.", italian="Ma non c'è dubbio che sia\narrabbiatissimo.", spanish="Pero, aunque no lo aparente, sin\nduda debe de estar realmente enfurecido."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It's unlikely that he would\nbother to choose you for the expedition.", french="Il est peu probable qu'il vous\nchoisisse pour l'expédition.", german="Es ist unwahrscheinlich, dass er\ngerade euch für die Expedition auswählt.", italian="È improbabile che vi scelga per\nla spedizione.", spanish="Es muy poco probable que vaya\na escogeros."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="So when the time comes to\nannounce the members, don't get your\nhopes up.", french="Donc n'ayez pas trop d'espoir\nquand les lauréats seront annoncés.", german="Wenn also die Mitglieder\nausgewählt werden, macht euch keine\nHoffnungen.", italian="Quindi, quando arriverà il\nmomento dell'annuncio, non fatevi troppe\nillusioni.", spanish="Así que, cuando llegue la hora de\ncomunicar la lista, no esperéis demasiado."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" That's all.", french=" C'est tout.", german=" Das ist alles.", italian=" È tutto.", spanish=" Eso es todo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_perappu, 356, 220, false, 2)
  GAME:WaitFrames(15)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:MoveToPosition(npc_npc_perappu, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_perappu, 324, 132, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I was already weak\nfrom hunger...", french="J'étais déjà affaibli par\nla faim...", german="Ich war schon ganz schwach\nvor Hunger.", italian=" Ero già debole per la fame...", spanish="Ya me sentía muy débil\npor el hambre..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I was already weak\nfrom hunger...", french="J'étais déjà affaibli par\nla faim...", german="Ich war schon ganz schwach\nvor Hunger.", italian=" Ero già debole per la fame...", spanish="Ya me sentía muy débil\npor el hambre..."})
  else
  SkySceneKit.say({english="I was already weak\nfrom hunger...", french="J'étais déjà affaiblie par\nla faim...", german="Ich war schon ganz schwach\nvor Hunger.", italian=" Ero già debole per la fame...", spanish="Ya me sentía muy débil\npor el hambre..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And then to be told something\nlike that... There's no way I can get\nmotivated now...", french="Et maintenant, après avoir\nentendu ça... je ne suis plus du tout motivé...", german="Und dann so etwas zu erfahren...\nJetzt kann ich mich gar nicht mehr motivieren.", italian="... e poi mi dicono questa cosa...\nAdesso sarà veramente difficile trovare le\nmotivazioni...", spanish="Y, ahora, que me digan algo así...\nHe perdido toda la motivación."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And then to be told something\nlike that... There's no way I can get\nmotivated now...", french="Et maintenant, après avoir\nentendu ça... je ne suis plus du tout motivé...", german="Und dann so etwas zu erfahren...\nJetzt kann ich mich gar nicht mehr motivieren.", italian="... e poi mi dicono questa cosa...\nAdesso sarà veramente difficile trovare le\nmotivazioni...", spanish="Y, ahora, que me digan algo así...\nHe perdido toda la motivación."})
  else
  SkySceneKit.say({english="And then to be told something\nlike that... There's no way I can get\nmotivated now...", french="Et maintenant, après avoir\nentendu ça... je ne suis plus du tout motivée...", german="Und dann so etwas zu erfahren...\nJetzt kann ich mich gar nicht mehr motivieren.", italian="... e poi mi dicono questa cosa...\nAdesso sarà veramente difficile trovare le\nmotivazioni...", spanish="Y, ahora, que me digan algo así...\nHe perdido toda la motivación."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Psst! Listen up!", french=" Psst! Ecoutez!", german=" Psst! Hört mal!", italian=" Psst! Ehi!", spanish=" ¡Pss! Escuchad..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Huh? I heard a voice\nsomewhere...", french=" Hein? J'entends des voix?", german="Huch? Ich habe eine Stimme\ngehört...", italian="Eh? Ho sentito una voce da\nqualche parte...", spanish="¿Eh? Me ha parecido oír una voz\npor ahí..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Huh? I heard a voice\nsomewhere...", french=" Hein? J'entends des voix?", german="Huch? Ich habe eine Stimme\ngehört...", italian="Eh? Ho sentito una voce da\nqualche parte...", spanish="¿Eh? Me ha parecido oír una\nvoz..."})
  else
  SkySceneKit.say({english="Huh? I heard a voice\nsomewhere...", french=" Hein? J'entends des voix?", german="Huch? Ich habe eine Stimme\ngehört...", italian="Eh? Ho sentito una voce da\nqualche parte...", spanish="¿Eh? Me ha parecido oír una\nvoz..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Shhh! Over here!", french=" Chut! Par ici!", german=" Schhh! Hier drüben!", italian=" Shhh! Da questa parte!", spanish=" ¡Chist! Por aquí. Por aquí, ¿me oís?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_Acting(3) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(360, 268, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! [CS:N]Bidoof[CR]!", french=" Hé! [CS:N]Keunotor[CR]!", german=" Hey! [CS:N]Bidiza[CR]!", italian=" Ehi! [CS:N]Bidoof[CR]!", spanish=" ¡Vaya! ¡Es [CS:N]Bidoof[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh! [CS:N]Bidoof[CR]!", french=" Hé! [CS:N]Keunotor[CR]!", german=" Oh! [CS:N]Bidiza[CR]!", italian=" Ehi! [CS:N]Bidoof[CR]!", spanish=" ¡Oh! ¡Es [CS:N]Bidoof[CR]!"})
  else
  SkySceneKit.say({english=" Hi! [CS:N]Bidoof[CR]!", french=" Hé! [CS:N]Keunotor[CR]!", german=" Hallo, [CS:N]Bidiza[CR]!", italian=" Ehi! [CS:N]Bidoof[CR]!", spanish=" ¡Hola! ¡[CS:N]Bidoof[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Shhh! By golly, not so loud!", french=" Chut! Sapristi, pas si fort!", german="Schhh! Menschenskind, nicht so\nlaut!", italian=" Shhh! Ohibò, non così forte!", spanish=" ¡Chist! No habléis tan alto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Come this way!", french=" V'nez par là!", german=" Kommt hier herüber!", italian=" Venite da questa parte!", spanish=" Venid por aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(528, 268, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_bippa, 560, 284, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_kimawari, 832, 268, false, 2)
  GAME:WaitFrames(5)
  do local p=npc_npc_chiriin.Position; GROUND:MoveToPosition(npc_npc_chiriin, p.X+(16), p.Y+(-16), false, 2) end
  GROUND:MoveToPosition(npc_npc_chiriin, 832, 268, false, 2)
  GAME:WaitFrames(60)
  GROUND:EntTurn(hero, Direction.DownRight)
  GROUND:EntTurn(partner, Direction.DownRight)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpLeft)
  GAME:WaitFrames(30)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(24), p.Y+(24), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(32), p.Y+(0), false, 2) end
  GROUND:MoveToPosition(hero, 832, 268, false, 2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(24), p.Y+(24), false, 2) end
  GROUND:MoveToPosition(partner, 832, 268, false, 2)
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
