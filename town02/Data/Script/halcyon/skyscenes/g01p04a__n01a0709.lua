-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/n01a0709.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Whaaaat?!", french=" Quoiiiii?!", german=" Waaaas?!?", italian=" Cooosaaa?!", spanish=" ¡¿Cómooo?!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You want to take time off\nfrom guild training?!", french="Tu veux délaisser ton\nentraînement à la Guilde pour\nprendre un peu de repos?!", german="Du möchtest vom Gildentraining\nbeurlaubt werden?!?", italian=" Vuoi prenderti una vacanza?!", spanish="¡¿Que quieres dejar de entrenar\nen el [CS:N]Pokégremio[CR] durante un tiempo?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="By time off, I just mean a\ncouple days. Yup yup.", french="Ben, j'veux dire quelques\njours, quoi. Ouaip.", german="Mit Urlaub meine ich aber nur\nwenige Tage. Jawollja.", italian="Per vacanza intendo solo qualche\ngiorno... Già, già.", spanish="Sí, señor, pero en realidad solo\nsería un par de días."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="What is your reason for wanting\nto take time off?", french="Et pour quelle raison voudrais-tu\nprendre ce congé?", german=" Und was ist der Grund dafür?", italian="E per quale motivo vorresti\nandare in vacanza?", spanish="¿Y cuál es el motivo de que\nquieras tomarte ese tiempo libre?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Huh?[K] R-reason?", french=" Hein?[K] Que... quelle raison?", german=" Häh?[K] G-grund?", italian=" Uh?[K] Il motivo?", spanish=" ¿Cómo?[K] ¿El... motivo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="The reason I want to take\ntime off...[K]um...[K]um...", french="C'est-à-dire que la raison...\nc'est que...[K] heu...[K] ben...", german="Der Grund für meinen Urlaub...[K]\nÄäähh...[K] Öööhh...", italian="Il motivo per cui vorrei\nuna vacanza...[K] Uhm...[K] Uhm...", spanish="El motivo por el que quiero\ntiempo libre...[K] Hum...[K] Hum..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="O-oh![K] I haven't been feeling good\nlately! Yup yup!", french="Oh, ah![K] Je m'sens pas bien,\nces derniers temps, ma foi!", german="O-oh, natürlich![K] In letzter Zeit\nhabe ich mich nicht so gut gefühlt! Jawollja!", italian="O-Oh![K] Ultimamente non sono\nstato tanto bene! Già già!", spanish="Puees...[K] Es que últimamente\nme encuentro un poco regular. ¡Sí, señor!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="My stomach really hurts...[K]\nOoogh...", french="C'est mon estomac...\nJ'ai trop mal.[K] Ouuuuuille...", german=" Magenschmerzen...[K] Uuuufff...", italian="Mi fa male lo stomaco...[K]\nGroan...", spanish="Me duele la tripa un montón...[K]\nAaaay..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Your stomach hurts?[K] You, the\none with the cast-iron stomach?", french="Tu as mal à l'estomac?[K]\nToi, le Pokémon à l'estomac d'acier?", german="Magenschmerzen?[K] Du? Dein\nMagen ist mit Abstand der am besten\ntrainierte von allen Gildenmitgliedern!", italian="Ti fa male lo stomaco?[K] Proprio\na te, che digeriresti anche i sassi?", spanish="¿Que te duele la tripa?[K] ¡Pero si\ntienes un estómago a prueba de bombas!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Last night at dinner you were\nthe only one to ask for seconds, am I right?", french="Pourtant, si j'ai bonne\nsouvenance, tu as été le seul à\nte resservir hier soir, non?", german="Gestern Abend warst du wieder\nmal der Einzige, der Nachschlag wollte. Oder\netwa nicht?", italian="L'altra sera sei stato l'unico\na cena a chiedere il bis... o mi sbaglio?", spanish="Anoche durante la cena fuiste el único\nque pidió repetir, ¿me equivoco?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And now you're saying that your\nstomach hurts?", french="Et maintenant tu prétends que\nton estomac te fait souffrir?", german="Und jetzt jammerst du über\nMagenschmerzen?", italian="E adesso mi dici che ti fa male\nlo stomaco?", spanish="¿Y ahora me dices que te duele\nla tripa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Ooogh...[K] I ate too much...", french="Ouuuuuille...[K]\nJustement, j'ai trop mangé...", german="Uuuuff...[K]\nIch habe eben zu viel gegessen.", italian=" Groan...[K] Ho mangiato troppo...", spanish=" Uuf...[K] Es que cené demasiado..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="...[K]I see.[K]\nThis seems really strange...", french="...[K] Je vois.[K]\nTout cela me semble bien étrange...", german=" ...[K]Aha.[K] Wirklich eigenartig...", italian="...[K] Capisco.[K]\nMi sembra molto strano...", spanish="Ya...[K] Entiendo.[K]\nMe parece muy raro, la verdad..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="...[K]All right.[K]\nYour request for a day off is granted.", french="Ton congé est accordé...[K]\nmais...", german="...[K]Nun gut.[K] Dein Antrag auf\nein bisschen freie Zeit wird bewilligt.", italian="...[K] Va bene.[K]\nTi concedo un po' di vacanza.", spanish="Pero...[K] Está bien.[K] Puedes tomarte\nunos días libres."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Just don't cause any trouble for\nother teams, OK?", french="... n'importune pas les autres\néquipes, d'accord?", german="Aber behindere die anderen\nTeams nicht bei ihrer Arbeit, in Ordnung?", italian="Ma non disturbare il lavoro\ndelle altre squadre, intesi?", spanish="Pero no molestes a otros equipos,\n¿vale?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Sniff...[K] Thank you...", french=" Snif...[K] Merci...", german=" Schnief...[K] Vielen Dank...", italian=" Sniff...[K] Grazie...", spanish=" Ay...[K] Gracias..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  -- back_SetBackEffect(4) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Sniff...[K] I ended up suddenly having\n[CN]to lie to [CS:N]Chatot[CR]...", french="[CN]Snif...[K] J'ai pas eu d'aut' choix que d'mentir\n[CN]à [CS:N]Pijako[CR]...", german="[CN]Schnief...[K] So kam es, dass ich\n[CN][CS:N]Plaudagei[CR] anlügen musste...", italian="[CN]Sniff...[K] Alla fine ho dovuto raccontare\n[CN]una bugia a [CS:N]Chatot[CR]...", spanish="[CN]Jo...[K] Me vi teniendo\n[CN] que mentir a [CS:N]Chatot[CR]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]But...", french="[CN]Mais...", german="[CN]Aber...", italian="[CN]Ma...", spanish="[CN]Aunque..."})
  -- message_Close
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]But...but it's all right.", french="[CN]Mais c'est pas grave.", german="[CN]Aber... Aber es war eine Notlüge.", italian="[CN]Ma... va bene così.", spanish="[CN]No me quedaba otro remedio."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]My dream...", french="[CN]Mon rêve...", german="[CN]Für meinen Traum...", italian="[CN]Il mio sogno...", spanish="[CN]Mi sueño..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]If I can make my dream of becoming the best\n[CN]explorer ever come true!", french="[CN]Si j'réussis à réaliser mon rêve de d'venir le\n[CN]plus grand explorateur d'tous les temps!", german="[CN]Um meinen Traum erfüllen zu können,\n[CN]der beste Erkunder aller Zeiten zu werden!", italian="[CN]Se potessi realizzare il mio sogno e diventare\n[CN]il più grande esploratore di tutti i tempi...", spanish="[CN]Si consigo que se cumpla mi sueño de ser\n[CN]el mejor explorador que haya existido..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]If I can do that, then maybe I won't mess up\n[CN]guild assignments anymore...", french="[CN]Si j'peux faire ça, alors p'tête que j'arrêterai\n[CN]d'faire des balourdises à la Guilde...", german="[CN]Wenn ich das schaffe, werde ich auch\n[CN]keine Gildenaufgaben mehr vergeigen...", italian="[CN]Se ci riuscissi, allora forse non combinerei più\n[CN]dei guai quando mi assegnano un incarico...", spanish="[CN]Si lo consigo, puede que ya no jorobe las\n[CN]misiones del [CS:N]Pokégremio[CR]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]And I won't cause trouble for anyone anymore.", french="[CN]Et j'causerai plus d'soucis à personne.", german="[CN]Und niemandem jemals mehr zur Last fallen.", italian="[CN]E non sarei più una fonte di\n[CN]preoccupazioni per gli altri.", spanish="[CN]Y ya no le causaré más problemas a nadie."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Everyone will be so happy! Yup yup!", french="[CN]Tout le monde s'ra si content! Ouaip ouaip!", german="[CN]Alle werden sich freuen! Jawollja!", italian="[CN]Sarebbero tutti felici! Già, già!", spanish="[CN]¡Y todos tan contentos! ¡Sí, señor!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]This is a rare chance!", french="[CN]C'est l'occasion ou jamais!", german="[CN]Was für eine seltene Gelegenheit!", italian="[CN]È un'opportunità troppo ghiotta!", spanish="[CN]Esta es una oportunidad como pocas."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]I've got to take advantage of this chance!\n[CN]I've just gotta! Yup yup!", french="[CN]Faut qu'j'la saisisse!\n[CN]Y faut, y faut, sapristi!", german="[CN]Die muss ich einfach nutzen!\n[CN]Ich muss einfach! Jawollja!", italian="[CN]Devo sfruttarla fino in fondo!\n[CN]Devo farlo! Già, già!", spanish="[CN]¡Así que tengo que aprovecharla!\n[CN]¡Es de cajón! ¡Sí, señor!"})
  -- message_Close
  -- back_SetBackEffect(5) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  SkySceneKit.cleanup_npcs()
end
