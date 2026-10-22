-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/n01a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  SV.SkyScenarioSide = {main=40, sub=2} -- $SCENARIO_SIDE = scn[40,2] (ROM)
  -- back_SetGround(LEVEL_T01P02A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_kakureon1 = SkySceneKit.spawn_npc("kecleon", 328, 168, Direction.Down, "NPC_KAKUREON1")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_kakureon2 = SkySceneKit.spawn_npc("kecleon", 352, 168, Direction.Down, "NPC_KAKUREON2")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(1)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-64), p.Y+(0), false, 2) end
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Whew...[K] Here's [CS:K]Kecleon[CR] Market.", french="Pfiou... m'y v'là.[K]\nLe [CS:K]Marché Kecleon[CR].", german="Puh...[K] Da ist ja der\n[CS:K]Kecleon-Markt[CR].", italian=" Fiuuu...[K] Ecco il [CS:K]Kecleon[CR] Market.", spanish=" Uf...[K] Aquí está el [CS:K]Bazar Kecleon[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(336, 196, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 336, 204, false, 2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-12), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Howdy!", french=" Salut!", german=" Hallo!", italian=" Salve!", spanish=" ¡Holita!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon1, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon2, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="Welcome... ♪[K]\nTo [CS:K]Kecleon[CR] Shop. ♪", french="Bienvenue... ♪[K]\nau [CS:K]Magasin Kecleon[CR]. ♪", german="Willkommen... ♪[K]\nWillkommen im [CS:K]Kecleon-Laden[CR]. ♪", italian="Ti do il benvenuto... ♪[K]\nal [CS:K]Kecleon[CR] Market. ♪", spanish=" Hola. ♪[K] Esta es la [CS:K]Tienda Kecleon[CR]. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" Have you come to shop? ♪", french="On vient faire\nses emplettes? ♪", german=" Womit kann ich dir helfen? ♪", italian=" Ti serve qualcosa? ♪", spanish=" ¿Viene a comprar algo? ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon1, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon2, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="N-not quite...[K] Sorry to bother\nyou, but I'm not here to buy anything...", french="Ben, pas trop...[K]\nDésolé d'te déranger, mais j'suis pas là pour\nacheter des trucs...", german="Öh... Ähem...[K] Es tut mir leid,\neuch zu stören. Aber in Wahrheit bin ich nicht\ngekommen, um etwas zu kaufen...", italian="N-Non proprio...[K] Mi dispiace\ndisturbarvi, ma non sono qui per fare acquisti.", spanish="Pu... pues no...[K] Siento molestar,\npero no he venido a comprar nada..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="...[K]Just asking about inventory,\nas always...[K] Sigh... So disappointing...", french="Ah bon...[K]\nLe stock, comme d'habitude...", german="...[K]Ach, wie immer also...\nEine Frage zum Lagerstand.[K] Seufz...\nWie schade...", italian="...[K] Ho capito, come al solito vuoi\nsolo sapere cosa abbiamo a disposizione...[K]\nSigh... Che delusione...", spanish="Ah...[K] Solo viene a hacer\ninventario, como siempre...[K] Ay...\nQué chasco..."})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon1, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon1, "happy", 1) end)
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="That's all right. Don't worry. ♪[K]\nInventory inquiries are no problem. ♪[K]\nReally. ♪", french="Je comprends, il n'y a pas\nde problème. ♪[K] Vraiment. ♪", german="Ist schon gut. Keine Sorge. ♪[K]\nLagerstandsauskünfte geben wir gerne. ♪[K]\nWirklich. ♪", italian="Non ti preoccupare, è tutto\na posto. ♪[K] Non c'è problema, puoi chiedermi\nquello che vuoi. ♪[K] Davvero. ♪", spanish="Tranquilo, no pasa nada. ♪[K]\nNo me molestan esas preguntas. ♪[K]\nDe verdad. ♪"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon1, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="...What have you come to\ncheck on?", french="Alors, tu veux vérifier\nle stock de quel article?", german="...Über welches Item\nerkundigst du dich denn heute?", italian=" Cosa sei venuto a controllare?", spanish="Entonces... ¿Qué ha venido\na comprobar?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:I]Oran Berries[CR].[K]\nReally sorry to bother you... Sorry.", french="Ç'ui des [CS:I]Baies Oran[CR].[K]\nVraiment confus d'te déranger, encore...\nConfus, confus.", german="[CS:I]Sinelbeeren[CR].[K]\nTut mir wirklich leid, euch zu stören...\nEntschuldigung.", italian="Le [CS:I]Baccarance[CR]. [K]\nMi dispiace davvero disturbarvi così tanto...\nScusatemi.", spanish="Las [CS:I]Bayas Aranja[CR].[K]\nLamento mucho molestar... Lo siento."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" No, no. It's no bother at all. ♪", french="Allons, allons, ça ne me dérange\npas du tout. ♪", german="Nein, nein.\nDas macht doch gar nichts. ♪", italian=" No, no. Non disturbi affatto. ♪", spanish=" No, no. No es molestia. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kakureon1, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="Let's see...[CS:I]Oran Berries[CR]...[K]\nWe have two in stock today...", french="Voyons voir... les [CS:I]Baies Oran[CR]...[K]\nOn en a deux en stock, aujourd'hui...", german="Dann wollen wir mal nachsehen...\n[CS:I]Sinelbeeren[CR]...[K] Davon haben wir heute zwei...", italian="Vediamo... [CS:I]Baccarance[CR]...[K]\nOggi ne abbiamo a disposizione due...", spanish="Veamos... [CS:I]Bayas Aranja[CR]... Pues...[K]\nHoy tenemos dos de esas..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kakureon1, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Two of them. [K]OK, thanks!", french="Deux. C'est noté.[K]\nBen, merci, alors!", german=" Zwei davon.[K] Okay, vielen Dank!", italian=" Due? [K]Ok, grazie!", spanish=" Entendido, dos.[K] ¡Muchas gracias!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon1, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon2, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" Do your best at your work! ♪", french=" Travaille bien! ♪", german="Gib immer dein Bestes bei der\nArbeit! ♪", italian=" Fai del tuo meglio al lavoro! ♪", spanish=" ¡A trabajar duro! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon1, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon2, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon1, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" ...[K]Huh? [K]Is there something else?", french="...[K] Hein? [K]Tu désires\nautre chose?", german="...[K]Ja?[K]\nGibt es sonst noch etwas?", italian="...[K] Uh?[K] Hai bisogno\ndi qualcos'altro?", spanish=" Hum...[K] ¿Eh?[K] ¿Quería algo más?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="N-no. [K]Well, there's nothing\nmore I need to do...", french="N-non. [K]Ben, à vrai dire, j'ai\nrien d'plus à faire, aujourd'hui...", german="N-nein. [K]Na ja, es gibt nichts,\ndas ich noch erledigen müsste...", italian=" N-No.[K] Beh, non mi serve altro...", spanish="No, no...[K] No me han pedido que\nhaga nada más..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I just have a little problem...", french=" J'ai juste un p'tit problème...", german="Ich habe nur ein kleines\nProblem...", italian="È solo che ho un piccolo\nproblema...", spanish=" Pero tengo un problemilla..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" Oh...[K] What kind of problem?", french=" Oh...[K] Quel genre de problème?", german=" Oh...[K] Was für ein Problem denn?", italian=" Oh...[K] Che tipo di problema?", spanish=" Ya veo...[K] ¿Qué tipo de problema?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="It's OK to ask me about it.\n[K]Come on, spit it out! ♪", french="Allez, tu peux tout nous dire...\nVas-y, jette-toi à l'eau! ♪", german="Du kannst es mir ruhig sagen.[K]\nNun mach schon, spuck es aus! ♪", italian="Non essere timido.[K]\nForza, vuota il sacco! ♪", spanish="Puede preguntar lo que quiera.\n[K]¡Sin ningún problema! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...[K]The truth is that no matter\nwhat I do...[K]I always seem to mess it up...", french="...[K] Ben, c'est-à-dire que j'ai beau\nfaire des efforts...[K] tout c'que j'fais, j'le fais\nde traviole...", german="...[K]Die Wahrheit ist, dass egal,\nwas ich auch anfasse...[K] Es geht immer\nalles schief...", italian="...[K] Ecco, il fatto è che per\nquanto mi impegni...[K] non faccio\nche creare guai...", spanish="Pues...[K] Lo cierto es que, haga lo\nque haga...[K] Parece que siempre la pifio..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'm always making mistakes at\nthe guild...", french="J'fais rien qu'des balourdises\nà la Guilde...", german="Ich bin nicht der Schnellste und\nmache ständig Fehler in der Gilde...", italian="Alla Gilda combino sempre\nqualche pasticcio...", spanish="Siempre me estoy equivocando\nen mi trabajo del [CS:N]Pokégremio[CR]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I really want to be an explorer\nlike all the other apprentices in the guild...", french="J'veux vraiment devenir un\nexplorateur, comme tous les autres à\nla Guilde...", german="Ich möchte wirklich ein\nErkunder werden wie all die anderen\nGildenlehrlinge...", italian="Desidero tanto diventare\nun esploratore come tutti gli altri\napprendisti della Gilda...", spanish="Tengo muchas ganas de ser un\nexplorador como los demás aprendices\ndel [CS:N]Pokégremio[CR]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" For example...", french=" Imaginons...", german=" Nun sag mir...", italian=" Ad esempio...", spanish=" Por ejemplo..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="To become an explorer really\nquickly...[K]what should I do?", french="Pour devenir un explorateur\ndare-dare...[K] faudrait qu'je fasse quoi?", german="Um möglichst schnell ein echter\nErkunder zu werden...[K] Was soll ich machen?", italian="Per diventare esploratore\nin un lampo...[K] cosa dovrei fare?", spanish="Para convertirme en explorador\nmuy rápidamente...[K] ¿qué debería hacer?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon2, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="Oh! If that's it...[K]you just need\na TM! ♪", french="Oh! S'il ne s'agit que de ça...[K]\nTout ce qu'il te faut, c'est une CT! ♪", german="Oh! Na, wenn es nur das ist...[K]\nDu brauchst einfach eine TM! ♪", italian="Oh! Se è per questo...[K] ti serve\nsolo una MT! ♪", spanish="Ah, bueno, se trata de eso...[K] Lo\núnico que necesita es una MT. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" TM?[K] ...That's the way?", french="Une CT...?[K]\nC'est ça, la solution?", german=" Eine TM?[K] ...So geht das?", italian=" MT...?[K] Tutto qua?", spanish=" ¿Una MT?[K] Y... ¿así lo lograré?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="Yep. ♪[K] With a TM, you can\nlearn a new move. ♪", french="Oui, oui. ♪[K] Avec une CT,\ntu peux apprendre une nouvelle capacité. ♪", german="Genau. ♪[K] Mithilfe einer TM\nkannst selbst du eine neue Attacke lernen. ♪", italian="Certo. ♪[K] Con una MT\npuoi imparare una nuova mossa. ♪", spanish="Sí. ♪[K] Con una MT se puede\naprender un movimiento nuevo. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="If you did that, you'd be very\nhelpful in explorations. ♪", french="Avec ça, tu deviendrais un allié\ntrès utile lors des explorations. ♪", german="Hast du erst mal neue Attacken\ndrauf, kannst du den anderen eine Hilfe\nauf Erkundungen sein. ♪", italian="In questo modo saresti di grande\naiuto durante le esplorazioni. ♪", spanish="Así será todo un portento\nen las exploraciones. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="Yes, you will definitely\nbe helpful. ♪", french="Oui, ce serait vraiment un atout\nde poids pour les explorations. ♪", german="Ja, so wirst du ihnen auf jeden\nFall eine Hilfe sein. ♪", italian=" Eh sì, saresti davvero utile. ♪", spanish="Sí, las exploraciones irán\ncomo la seda. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kakureon2, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="Hmmm...[K] How about...[K]\nHere it is!", french="Hmmm...[K] Que penses-tu de...[K]\nTiens, cette capacité-là!", german="Hmmm...[K] Wie wäre es mit...[K]\nDa ist sie ja!", italian="Mmm...[K] Vediamo un po'...[K]\nEcco qua!", spanish="Hum...[K] Voy a buscar.[K]\n¡Aquí está!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kakureon2, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english=" How about this one?", french=" Qu'en dis-tu?", german=" Wie wäre es mit dieser hier?", italian=" Che ne dici di questa?", spanish=" ¿Qué tal esta?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="[CN][CS:N]Kecleon[CR] showed [CS:Y]Bidoof[CR]\n[CN]the TM [M:I0][CS:I]Hidden Power[CR].", french="[CN][CS:N]Kecleon[CR] montre à [CS:Y]Keunotor[CR]\n[CN]la CT [M:I0][CS:I]Puis. Cachée[CR].", german="[CN][CS:N]Kecleon[CR] zeigt [CS:Y]Bidiza[CR]\n[CN]die TM [M:I0][CS:I]Kraftreserve[CR].", italian="[CN][CS:N]Kecleon[CR] mostra a [CS:Y]Bidoof[CR]\n[CN]la MT [M:I0][CS:I]Introforza[CR].", spanish="[CN][CS:N]Kecleon[CR] le ha enseñado a [CS:Y]Bidoof[CR]\n[CN]la MT [M:I0][CS:I]Poder Oculto[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[M:I0][CS:I]Hidden Power[CR]...[K]\nThat sounds pretty strong...", french="[M:I0][CS:I]Puis. Cachée[CR]...[K]\nÇa a l'air vachement balaise...", german="[M:I0][CS:I]Kraftreserve[CR]...[K]\nDas klingt ganz schön stark...", italian="[M:I0][CS:I]Introforza[CR]...[K]\nDà l'idea di essere molto potente...", spanish=" [M:I0][CS:I]Poder Oculto[CR]...[K] Suena fuertecillo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="That's right. ♪[K]\nIt's a very strong move! ♪", french="Tout juste. ♪[K]\nC'est une capacité très puissante! ♪", german="Ganz genau. ♪[K]\nEine mächtige Attacke! ♪", italian="Proprio così. ♪[K]\nÈ una mossa davvero potente! ♪", spanish="Pues sí. ♪[K] ¡Es un movimiento\nmuy potente! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="If you used this TM, you could\nlearn [CS:M]Hidden Power[CR]! ♪", french="En utilisant cette CT, tu pourrais\napprendre [CS:M]Puis. Cachée[CR]! ♪", german="Wenn du diese TM verwendest,\nkannst du [CS:M]Kraftreserve[CR] lernen! ♪", italian="Se usassi questa MT, potresti\nimparare [CS:M]Introforza[CR]! ♪", spanish="¡Si usara esta MT, podría\naprender el movimiento [CS:M]Poder Oculto[CR]! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Is that right...?", french=" Sérieux...?", german=" Ist das so?", italian=" Davvero...?", spanish=" ¿Es eso cierto...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="... (Sniff...[K] If I learn [CS:M]Hidden[CR]\n[CS:M]Power[CR], then I could be more useful...)", french="... (Snif...[K] Si j'apprenais [CS:M]Puis.[CR]\n[CS:M]Cachée[CR], alors j'servirais\nenfin à quelque chose...)", german="...(Schnief...[K] Mit [CS:M]Kraftreserve[CR]\nwäre ich den anderen eine große Hilfe...)", italian="(Sniff...[K] Se imparassi\n[CS:M]Introforza[CR], potrei essere più utile...)", spanish="Pues... (Jo...[K] Si aprendiera el\nmovimiento [CS:M]Poder Oculto[CR], sería más útil...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(And the guild members would\nappreciate me more...)", french="(Et les membres d'la Guilde\nm'aimeraient un p'tit peu plus...)", german="(Und die Gildenmitglieder würden\nmich lieber mögen...)", italian="(E i membri della Gilda\nmi apprezzerebbero di più...)", spanish="(Y los miembros del [CS:N]Pokégremio[CR]\nme apreciarían más...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(If I buy this...[K]then the day\nI become the best explorer will get closer...)", french="(Et...[K] si j'achète ce truc,\nalors j'pourrais d'venir explorateur\nen un rien de temps...)", german="(Nur durch diesen Kauf...[K] würde\nder Tag, an dem ich der beste Erkunder werde,\netwas näher rücken...)", italian="(Poi...[K] se la comprassi,\ndiventare il miglior esploratore\ndel mondo non sarebbe più solo un sogno...)", spanish="(Además...[K] si la compro, el día\nen que me convierta en el mejor explorador\nestará más cerca...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="By the way...[K]how much is this\n[M:I0][CS:I]Hidden Power[CR] thing?", french="Au fait...[K] Ça coûte combien ton\nmachin, là, [M:I0][CS:I]Puis. Cachée[CR]?", german="Und, ähem...[K] Was würde\ndieses [M:I0][CS:I]Kraftreserve[CR]-Ding denn so kosten?", italian="Ditemi...[K] Quanto costa questa\n[M:I0][CS:I]Introforza[CR]?", spanish="Por cierto...[K] ¿Cuánto cuesta\nesto del [M:I0][CS:I]Poder Oculto[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon2, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="Oh! [K]You're interested in\nbuying it. ♪ I'm excited! ♪", french="Oh-oh! [K]Ça t'intéresserait de\nl'acheter? ♪ Voilà qui m'émoustille! ♪", german="Oh! [K]Du bist also interessiert? ♪\nWie aufregend! ♪", italian="Oh![K] Sei interessato\nall'acquisto. ♪ Che emozione! ♪", spanish="¡Anda![K] Veo que le interesa\ncomprar. ♪ ¡Qué emoción! ♪"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon2, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="The price...[K]let me see...[K]\nIt's [CS:G]6[MP]500[CR][M:S0].", french="Le prix est de...[K] attends voir...[K]\nC'est [CS:G]6 500[CR][M:S0].", german="Zum Preis...[K] Augenblick...[K]\n[CS:G]6.500[CR][M:S0].", italian="Il prezzo...[K] Vediamo un po'...[K]\nCosta [CS:G]6[MP]500[CR][M:S0].", spanish="Pues el precio...[K] A ver...[K]\nSon [CS:G]6500[CR][M:S0]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Whaaat?![K]\nIt's that expensive?!", french="Quoiiii?![K]\nC'est cher à c'point-là?!", german=" Waaaaas?!?[K] So teuer?!?", italian="Cooosa?![K]\nCosì tanto?!", spanish=" ¡¿Cómo?![K] ¡Pero si es carísima!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="You're surprised? [K]\nWell, TMs are very expensive...", french="Ça t'étonne?[K]\nEh bien, oui, les CT sont très coûteuses...", german="Das überrascht dich? [K]\nNun, TM sind sehr wertvoll...", italian="Sei sorpreso? [K]\nBeh, le MT sono molto costose...", spanish="¿Le sorprende?[K]\nBueno, es que las MT son muy caras..."})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="But you think that's too\nexpensive, right?", french="Mais tu penses que c'est trop\ncher pour toi, c'est ça?", german="Aber dir ist das anscheinend zu\nteuer, ja?", italian="Ma pensi che sia troppo cara,\nnon è vero?", spanish="Pero le parece un precio\ndemasiado elevado, ¿no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Sniff...[K] No...[K]\nPlease hold on a moment...", french="Snif...[K] Non...[K]\nAttends une seconde, s'te plaît...", german="Schnief...[K] Nein...[K] Einen\nAugenblick, bitte...", italian="Sniff...[K] No...[K]\nSolo un attimo, per favore...", spanish=" Jo...[K] No.[K] Deja que lo piense un poco..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Sniff...[K] What should I do...?[K]\nShould I buy it? Shouldn't I? I don't know...", french="Snif...[K] Que faire...?[K]\nL'acheter? Pas l'acheter? J'sais pas...", german="Schnüff...[K] Was mache ich\nnur?[K] Soll ich sie kaufen? Oder nicht?\nIch kann mich nicht entscheiden...", italian="Sniff...[K] Cosa devo fare...?[K]\nLa compro? Non la compro? Sono indeciso...", spanish="Jo...[K] ¿Qué hago...?[K] ¿La compro?\n¿No la compro? Qué dilema..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="To tell you the truth...[K]I've got\nthe money for it, but...", french="Pour dire la vérité...[K]\nJ'ai l'argent qu'y faut, mais...", german="Um die Wahrheit zu sagen...[K]\nIch hätte das Geld dafür...", italian="A dire la verità...[K] avrei i soldi\nper comprarla...", spanish="A decir verdad...[K] Tengo dinero\nsuficiente, pero..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8713) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(30)
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I've got my own money...[K]\nI always carry it with me...[CS:G]7[MP]000[CR][M:S0].", french="C'est mon argent à moi...[K]\nJ'l'ai toujours sur moi... [CS:G]7 000[CR][M:S0].", german="Ich hätte genug Geld...[K] Ich trage\nes immer bei mir... [CS:G]7.000[CR][M:S0].", italian="Ho dei risparmi da parte...[K]\nLi porto sempre con me... Sono [CS:G]7[MP]000[CR][M:S0].", spanish="Tengo mi propio dinero...[K]\nSiempre lo llevo encima... [CS:G]7000[CR][M:S0]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" But...[K]but this money...", french=" Mais...[K] mais cet argent...", german=" Aber...[K] Aber dieses Geld...", italian=" Però...[K] questi soldi...", spanish=" Pero...[K] Pero este dinero..."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false,  60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
