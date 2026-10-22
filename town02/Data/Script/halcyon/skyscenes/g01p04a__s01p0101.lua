-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/s01p0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 1) -- $SCENARIO_MAIN = scn[29,1] (ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]As a result of [hero]\n[CN]and [partner]'s heroic actions...", french="[CN]Grâce aux actes héroïques\n[CN]de [hero] et [partner]...", german="[CN]Durch das heldenhafte Handeln\n[CN]von [hero] und [partner]", italian="[CN]Grazie alle eroiche imprese\n[CN]di [hero] e [partner]...", spanish="[CN]Como resultado de las heroicas\n[CN]acciones de [hero] y [partner]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]the destruction of time was stopped...", french="[CN]la destruction du temps fut arrêtée...", german="[CN]wurde die Zerstörung der Zeit verhindert...", italian="[CN]la distruzione del tempo è stata arrestata...", spanish="[CN]se detuvo la destrucción del tiempo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]and peace returned to\n[CN]the world of Pokémon.", french="[CN]... et la paix revint dans\n[CN]le monde des Pokémon.", german="[CN]Frieden kehrte zurück\n[CN]in die Welt der Pokémon.", italian="[CN]... e nel mondo dei Pokémon\n[CN]è tornata la pace.", spanish="[CN]y la paz regresó al mundo Pokémon."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Of course, not everything\n[CN]returned to normal right away.", french="[CN]Bien entendu, tout ne rentra pas\n[CN]immédiatement dans l'ordre.", german="[CN]Natürlich stellte sich die Normalität\n[CN]nicht von heute auf morgen ein.", italian="[CN]Ovviamente, non è tornato\n[CN]tutto alla normalità.", spanish="[CN]Por supuesto, no todo volvió a la\n[CN]normalidad inmediatamente."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Some places remained where time\n[CN]was still out of control...", french="[CN]Il subsista certains lieux où le temps\n[CN]n'avait pas repris son cours normal...", german="[CN]An manchen Orten war die Zeit\n[CN]immer noch außer Kontrolle...", italian="[CN]Rimangono dei luoghi nei quali\n[CN]il tempo è ancora fuori controllo...", spanish="[CN]Quedaron algunos lugares donde el\n[CN]tiempo aún andaba descontrolado..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]But overall, things were\n[CN]becoming better everywhere.", french="[CN]Néanmoins, dans l'ensemble, la\n[CN]situation s'améliora partout.", german="[CN]Aber überall besserte sich\n[CN]die Situation.", italian="[CN]In generale, però, le cose stanno\n[CN]migliorando dappertutto.", spanish="[CN]Pero, en general, la situación\n[CN]mejoró en todas partes."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]As for [hero] and [partner]...", french="[CN]Quant à [hero] et [partner]...", german="[CN][hero] und [partner]", italian="[CN]Per quanto riguarda\n[CN][hero] e [partner]...", spanish="[CN]En cuanto a [hero] y [partner]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]They returned to [CS:N]Wigglytuff[CR]'s Guild...", french="[CN]... ces valeureux Pokémon s'en retournèrent\n[CN]à la Guilde de [CS:N]Grodoudou[CR]...", german="[CN]kehrten zur [CS:N]Knuddeluff-Gilde[CR] zurück", italian="[CN]I due Pokémon hanno fatto ritorno alla Gilda\n[CN]di [CS:N]Wigglytuff[CR]...", spanish="[CN]Regresaron al [CS:N]Pokégremio de Exploradores[CR]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]And fell back into their daily\n[CN]routine of vigorous training.", french="[CN]... et à son lot quotidien\n[CN]d'entraînements intensifs.", german="[CN]und fielen zurück in ihre tägliche\n[CN]Routine des knallharten Trainings.", italian="[CN]... e hanno ricominciato ad allenarsi\n[CN]con grande impegno.", spanish="[CN]y retomaron su rutina diaria\n[CN]de entrenamientos."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]One morning, several months later...", french="[CN]Un matin, plusieurs mois plus tard...", german="[CN]Eines Morgens, einige Monate später...", italian="[CN]Una mattina, alcuni mesi più tardi...", spanish="[CN]Pero, una mañana, algunos meses más tarde..."})
  -- message_Close
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P04A, 'US01') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(8) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- supervision_Acting(3) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.DownRight, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Right, "NPC_DOGOOMU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 456, 272, Direction.Right, "NPC_DIGUDA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 424, 256, Direction.Right, "NPC_BIPPA")
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 360, 272, Direction.Right, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  GAME:WaitFrames(5)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.Right, "NPC_GUREGGURU")
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 392, 256, Direction.Right, "NPC_CHIRIIN")
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 392, 272, Direction.Right, "NPC_HEIGANI")
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 456, 256, Direction.Right, "NPC_KIMAWARI")
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?![K] G-graduation?!", french=" Hein?![K] L-le diplôme?!", german="Wie bitte?!?[K]\nA-abschlussprüfung?!?", italian=" Eh?![K] U-Un esame?!", spanish=" ¿Qué?[K] ¿Un reto?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?![K] Graduation?!", french=" Quoi?![K] Le diplôme?!", german=" Was?!?[K] Abschlussprüfung?!?", italian=" Cosa?![K] U-Un esame?!", spanish=" ¿Cómo?[K] ¿Un reto?"})
  else
  SkySceneKit.say({english=" Pardon?![K] Graduation?!", french=" Pardon?![K] Le diplôme?!", german="Wie bitte?!?[K]\nAbschlussprüfung?!?", italian=" Scusa?![K] U-Un esame?!", spanish=" ¿Cómo dices?[K] ¿Un reto?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="That's right.[K] Graduation from\nthe guild! ♪", french="C'est exact.[K] Le diplôme de la\nGuilde! ♪", german="So ist es.[K] Die Abschlussprüfung\nder Gilde! ♪", italian="Esatto.[K] L'esame di diploma\ndella Gilda! ♪", spanish="Correcto.[K] ¡El gran reto del\n[CS:N]Pokégremio[CR]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="If you graduate, you can leave\nthe guild.", french="Si vous parvenez à obtenir\nle diplôme, vous pourrez quitter la Guilde.", german="Wenn ihr die Abschlussprüfung\nbesteht, könnt ihr die Gilde verlassen.", italian="Se lo superate, potrete lasciare\nla Gilda.", spanish="Si lo superáis, podréis dejar el\n[CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You'll be rid of the harsh daily\ntraining program too.", french="Fini le difficile programme\nd'entraînement quotidien!", german="Ihr seid dann auch das strenge\ntägliche Trainingsprogramm los.", italian="Non dovrete neanche più\nseguire il nostro rigido programma\nd'allenamento.", spanish="Os libraréis también del duro\nprograma de entrenamiento."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Of course, that all depends on\nyour passing the graduation exam.", french="Bien sûr, cela dépend de vos\nrésultats à l'examen.", german="Selbstverständlich hängt alles\ndavon ab, ob ihr die Abschlussprüfung\nbesteht.", italian="Naturalmente, solo se superate\nl'esame.", spanish="Por supuesto, todo depende de\nque superéis el reto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_heigani, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey, hey! [CS:N]Chatot[CR]!", french=" Eh dis donc, [CS:N]Pijako[CR]!", german=" Hey, hey, hey! [CS:N]Plaudagei[CR]!", italian=" Ehi, ehi, ehi! [CS:N]Chatot[CR]!", spanish=" ¡Oye, oye, oye, [CS:N]Chatot[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_heigani, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_heigani, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! We've been around a\nlot longer than those two.", french="Nous sommes ici depuis bien\nplus longtemps que ces deux-là, dis donc!", german="Hey, hey! Wir sind schon viel\nlänger dabei als diese beiden.", italian="Ehi, ehi! Noi facciamo parte della\nGilda da più tempo di loro due.", spanish="Nosotros llevamos aquí más\ntiempo..."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! Why do [hero]\nand [partner] get to take the graduation\nexam before we do?", french="Eh dis donc! Pourquoi\n[hero] et [partner] ont le droit\nde passer l'examen avant nous?", german="Hey, hey! Warum dürfen\n[hero] und [partner] die Prüfung\nvor uns ablegen?", italian="Ehi, ehi! Perché [hero]\ne [partner] possono sostenere l'esame\nprima di noi?", spanish="¿Por qué [hero] y\n[partner] pueden afrontar el gran\nreto antes que nosotros?"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="They've already proven\nthemselves to be worthy many times over.", french="A de nombreuses reprises, j'ai\npu admirer leur valeur et leur courage.", german="Sie haben sich oft genug als\nwürdig erwiesen.", italian="Hanno già dimostrato più\ne più volte di meritarlo.", spanish="Han demostrado su gran valía\nen numerosas ocasiones."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And after all, [hero] and\n[partner] saved the world. ♪", french="Qui plus est, [hero] et\n[partner] ont sauvé le monde. ♪", german="Und immerhin haben\n[hero] und [partner] die Welt\ngerettet. ♪", italian="In fondo, [hero] e\n[partner] hanno salvato il mondo. ♪", spanish="Al fin y al cabo, [hero] y\n[partner] han salvado el mundo. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It's only natural that they've\nearned the right to be tested.", french="Ces deux-là ont largement\nmérité de passer cette épreuve.", german="Sie haben sich\nselbstverständlich das Recht erworben,\ngeprüft zu werden.", italian="Mi sembra ovvio che abbiano\nil diritto di sostenere l'esame.", spanish="Tienen derecho a intentar\nsuperar el reto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="...And that's how it goes.[K]\nWe will soon conduct the graduation exam.\nI expect you to be prepared for it! ♪", french="... C'est comme ça.[K]\nNous allons bientôt commencer l'examen.\nAllez vite vous préparer! ♪", german="...Und so läuft das.[K]\nWir werden euch bald die Prüfung abnehmen.\nIch erwarte, dass ihr vorbereitet seid! ♪", italian="E così sarà.[K]\nL'esame avrà luogo tra poco. Preparatevi\nbene! ♪", spanish="Y no hay más que hablar.[K]\nPronto tendréis que afrontar el reto.\n¡Preparaos como es debido! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_dogoomu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="[CS:N]Loudred[CR] took the graduation\nexam last year.", french="[CS:N]Ramboum[CR] l'a tenté\nl'année dernière.", german="[CS:N]Krakeelo[CR] hat letztes Jahr\ndie Abschlussprüfung gemacht.", italian="[CS:N]Loudred[CR] ha sostenuto l'esame\nl'anno scorso.", spanish="[CS:N]Loudred[CR] intentó superar el reto\nel año pasado..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_dogoomu, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_kimawari, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" And promptly failed! Hey, hey!", french="Et il a lamentablement échoué,\ndis donc!", german="Und ist glatt durchgefallen!\nHey, hey!", italian="E ovviamente non l'ha passato!\nEhi, ehi!", spanish=" ¡Y no pudo superarlo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_heigani, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" G-g-get LOST!", french=" T-t-taisez-VOUS!", german=" L-l-lasst mich in RUHE!", italian=" S-Sparisci!", spanish=" ¡LO HAS TENIDO QUE DECIR!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So...[K] What are we supposed to\ndo for this graduation exam?", french="Alors...[K] qu'est-ce que nous\ndevrons faire lors de cet examen?", german="Also...[K] Was wird von uns in\ndieser Abschlussprüfung verlangt?", italian="Quindi...[K] cosa dovremmo fare\nper questo esame?", spanish="Y...[K] ¿qué hay que hacer para\nsuperar el gran reto?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So...[K] What do we have to do\nfor this graduation exam?", french="Alors...[K] qu'est-ce que nous\ndevrons faire lors de cet examen?", german="Also...[K] Was müssen wir für\ndiese Abschlussprüfung tun?", italian="Quindi...[K] cosa dovremmo fare\nper questo esame?", spanish="Y...[K] ¿qué hay que hacer para\nsuperar el gran reto?"})
  else
  SkySceneKit.say({english="So...[K] What are we supposed to\ndo for this graduation exam?", french="Alors...[K] qu'est-ce que nous\ndevrons faire lors de cet examen?", german="Also...[K] Was wird von uns in\ndieser Abschlussprüfung verlangt?", italian="Quindi...[K] cosa dovremmo fare\nper questo esame?", spanish="Y...[K] ¿qué hay que hacer para\nsuperar el gran reto?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 424, 208, Direction.Down, "NPC_PUKURIN")
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(16), false, 1) end
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_guregguru, Direction.UpRight)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpRight)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpRight)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_diguda, Direction.UpLeft)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I want you to explore the depths\nof a wood named [CS:P]Mystifying Forest[CR].", french="Je voudrais que vous exploriez\nles profondeurs d'un bois qui s'appelle la\n[CS:P]Forêt Trompeuse[CR].", german="Ich möchte, dass ihr die Tiefen\neines Gehölzes namens [CS:P]Verwirrwald[CR] erkundet.", italian="Voglio che esploriate le parti più\nrecondite di una foresta chiamata [CS:P]Foresta[CR]\n[CS:P]Inganno[CR].", spanish="Quiero que exploréis a fondo\nun territorio llamado [CS:P]Bosque Misterio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You should find a place called\n[CS:P]Luminous Spring[CR] there.", french="Là-bas, vous devrez trouver\nun lieu qu'on appelle la [CS:P]Source Lumineuse[CR].", german="Ihr solltet dort auch einen Ort\nvorfinden, der [CS:P]Glitzerquelle[CR] genannt wird.", italian="Lì dovreste trovare un luogo\nchiamato [CS:P]Sorgente Luccichio[CR].", spanish="Allí encontraréis un lugar\nllamado [CS:P]Manantial Luminoso[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:P]Luminous Spring[CR]?", french=" La [CS:P]Source Lumineuse[CR]?", german=" [CS:P]Glitzerquelle[CR]?", italian=" [CS:P]Sorgente Luccichio[CR]?", spanish=" ¿[CS:P]Manantial Luminoso[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:P]Luminous Spring[CR]?", french=" La [CS:P]Source Lumineuse[CR]?", german=" [CS:P]Glitzerquelle[CR]?", italian=" [CS:P]Sorgente Luccichio[CR]?", spanish=" ¿[CS:P]Manantial Luminoso[CR]?"})
  else
  SkySceneKit.say({english=" [CS:P]Luminous Spring[CR]?", french=" La [CS:P]Source Lumineuse[CR]?", german=" [CS:P]Glitzerquelle[CR]?", italian=" [CS:P]Sorgente Luccichio[CR]?", spanish=" ¿[CS:P]Manantial Luminoso[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Yup! ♪[K] It was where Pokémon\nonce went to evolve.", french="Ouiii! ♪[K] C'est à cet endroit que\nles Pokémon partaient autrefois pour évoluer.", german="Ja! ♪[K] Dort gingen einst die\nPokémon hin, um sich zu entwickeln.", italian="Sì! ♪[K] È lì che una volta i\nPokémon andavano a evolversi.", spanish="Sí. ♪[K] Allí es donde antaño\niban los Pokémon a evolucionar."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="But maybe because of the time\ntroubles we had...[K]no sunlight shines on the\nspring now.", french="Mais peut-être à cause des\ndérèglements temporels...[K] le soleil a cessé\nde briller sur la source.", german="Vielleicht scheint wegen der\nSchwierigkeiten, die wir mit der Zeit hatten,[K]\nkein Sonnenlicht mehr auf die Quelle.", italian="Ma forse a causa dei problemi\nlegati al tempo che abbiamo avuto...[K] adesso\nla luce del sole non raggiunge più la sorgente.", spanish="Aunque ya no brilla la luz del sol\nen el manantial.[K] Quizás debido a los problemas\ncon el tiempo..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Now nothing can evolve there.", french="Maintenant, c'est complètement\nimpossible d'évoluer là-bas.", german="Im Moment kann sich dort nichts\nentwickeln.", italian="Non si può più evolvere\nnessuno lì.", spanish="El caso es que, ahora, ningún\nPokémon puede evolucionar allí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We want you to travel to\n[CS:P]Luminous Spring[CR].[K] And return with\nits treasure! ♪", french="Nous voulons que vous alliez à\nla [CS:P]Source Lumineuse[CR]...[K] et que vous reveniez\navec le trésor qu'elle abrite! ♪", german="Wir möchten, dass ihr zur\n[CS:P]Glitzerquelle[CR] reist.[K] Und mit ihrem Schatz\nzurückkehrt! ♪", italian="Vogliamo che andiate fino alla\n[CS:P]Sorgente Luccichio[CR][K] e torniate con\nil suo tesoro! ♪", spanish="Queremos que vayáis al\n[CS:P]Manantial Luminoso[CR]...[K] ¡y regreséis con\nsu tesoro! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="If you can bring that treasure\nback to the guild, you pass the exam.", french="C'est en rapportant ce trésor\nà la Guilde que vous réussirez l'examen.", german="Wenn ihr diesen Schatz zur Gilde\nzurückbringen könnt, habt ihr die Prüfung\nbestanden.", italian="Se riuscirete a riportare il\ntesoro alla Gilda, otterrete il diploma.", spanish="Si conseguís traer el tesoro al\n[CS:N]Pokégremio[CR], habréis superado el reto."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You will then be recognized as a\nfully trained exploration team...", french="Votre équipe sera ainsi reconnue\nen tant qu'équipe d'exploration à part entière...", german="Ihr werdet dann als voll\nausgebildetes Erkundungsteam anerkannt.", italian="A quel punto la vostra squadra\nsarà considerata come pienamente addestrata...", spanish="En ese caso, pasaréis a ser\nun equipo explorador profesional..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And graduate from the guild\nwith full honors! ♪", french="... et obtiendra le diplôme\nde la Guilde avec mention! ♪", german="Und ihr geht mit vollen Ehren\nvon dieser Gilde ab! ♪", italian="... e potrete lasciare la Gilda\ncon il massimo dei voti! ♪", spanish=" ¡Y os trataremos como tal! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Gotcha![K] We just have to bring\nback the treasure!", french="Compris![K] Il nous suffit\nde rapporter le trésor!", german="Verstanden![K] Wir müssen\neinfach nur den Schatz zurückbringen!", italian="Ho capito![K] Dobbiamo solamente\ntrovare il tesoro!", spanish="¡Entendido![K] ¡Solo tenemos que\ntraer el tesoro!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="OK![K] We have to bring back\nthe treasure!", french="Compris![K] Il nous suffit\nde rapporter le trésor!", german="Okay![K] Wir müssen den Schatz\nzurückbringen!", italian="Ho capito![K] Dobbiamo solamente\ntrovare il tesoro!", spanish="¡Vale![K] ¡Solo hay que traer el\ntesoro!"})
  else
  SkySceneKit.say({english="Sure thing![K] We just have to\nbring back the treasure!", french="Compris![K] Il nous suffit\nde rapporter le trésor!", german="Klare Sache![K] Wir müssen\neinfach den Schatz zurückbringen!", italian="Ho capito![K] Dobbiamo solamente\ntrovare il tesoro!", spanish="¡Claro![K] ¡Solo hay que regresar\ncon el tesoro!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's do this right, [hero]!", french="Faisons de notre mieux,\n[hero]!", german="Lass es uns richtig angehen,\n[hero]!", italian="Mettiamocela tutta,\n[hero]!", spanish=" ¡Hagámoslo, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's do this, [hero]!", french=" Allons-y, [hero]!", german=" Das machen wir, [hero]!", italian="Mettiamocela tutta,\n[hero]!", spanish=" ¡Hagámoslo, [hero]!"})
  else
  SkySceneKit.say({english=" Let's do this, [hero]!", french=" Allons-y, [hero]!", german=" Das machen wir, [hero]!", italian="Mettiamocela tutta,\n[hero]!", spanish=" ¡Hagámoslo, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(90) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="But...[K]you have to watch out for\none thing.", french="Mais...[K] vous devez prendre garde\nà une chose.", german="Aber...[K] Passt auf diese eine\nSache auf.", italian="Ma...[K] c'è una cosa dalla quale\ndovrete guardarvi.", spanish="Pero...[K] hay algo que debéis\nsaber."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_pukurin, 4) end)
  GROUND:EntTurn(hero, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="There you'll find...[K]a frighteningly\nstrong enemy.", french="Là-bas, vous rencontrerez...\nun ennemi terriblement puissant.", german="Es gibt dort[K] einen fürchterlich\nstarken Gegner.", italian="Sulla vostra strada\nincontrerete...[K] un nemico spaventosamente\nforte.", spanish="Allí os encontraréis con...[K] un\nenemigo increíblemente fuerte."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="The grand master of all things\nbad lives there.", french="Car c'est là que vit le grand\nmaître de tous les maux.", german="Der Großmeister allen Übels\nlebt dort.", italian="Sua Malvagità abita da quelle\nparti.", spanish="El gran malo requetemalo vive\nallí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The...[K]grand master of all\nthings bad?!", french="Le...[K] grand maître de tous les\nmaux?!", german="Der...[K] Großmeister allen\nÜbels?!?", italian=" Sua...[K] Malvagità?!", spanish="¿Eh?[K]\n¿El gran malo requetemalo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The...[K]grand master of all\nthings bad?!", french="Le...[K] grand maître de tous les\nmaux?!", german="Der...[K] Großmeister allen\nÜbels?!?", italian=" Sua...[K] Malvagità?!", spanish="¿Eh?[K]\n¿El gran malo requetemalo?"})
  else
  SkySceneKit.say({english="The...[K]grand master of all\nthings bad?!", french="Le...[K] grand maître de tous les\nmaux?!", german="Der...[K] Großmeister allen\nÜbels?!?", italian=" Sua...[K] Malvagità?!", spanish="¿Eh?[K]\n¿El gran malo requetemalo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Yup.", french=" Ouiii.", german=" Genau.", italian=" Sì.", spanish=" Sí."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="The grand master is\nterribly wicked.", french="Le grand maître est un être\nterriblement malfaisant.", german="Der Großmeister ist schrecklich\ndurchtrieben.", italian="La cattiveria di Sua Malvagità\nè assolutamente senza limiti.", spanish=" El gran malo es muy, muy malo."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="It's a horrifying presence that\nno one would ever want to meet...", french="C'est une créature horrible\nque personne ne souhaite rencontrer.", german="Seine Gegenwart ist so\nentsetzlich, dass niemand sie wirklich\nerleben möchte...", italian="È una presenza terrificante che\nnessuno vorrebbe mai incontrare...", spanish="Nadie en su sano juicio querría\nenfrentarse a él."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" So... Good luck with that! ♪", french=" Alors, ben... bon courage! ♪", german=" So, dann mal viel Glück! ♪", italian=" Quindi... Buona fortuna! ♪", spanish=" Así que... ¡Buena suerte! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What... Huh?!", french=" Quoi?! Mais...", german=" Was... Wie?!?", italian=" Eh?! Cosa...", spanish=" ¿Cómo? ¿Qué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What... Huh?!", french=" Quoi?! Mais...", german=" Was... Wie?!?", italian=" Eh?! Cosa...", spanish=" ¿Cómo? ¿Qué?"})
  else
  SkySceneKit.say({english=" What... Huh?!", french=" Quoi?! Mais...", german=" Was... Wie?!?", italian=" Eh?! Cosa...", spanish=" ¿Cómo? ¿Qué?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(15)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="That will do for the\nmorning briefing!", french="Ça sera tout pour la réunion de\nce matin!", german="Das reicht für die morgendliche\nUnterweisung!", italian=" Questo è tutto per stamattina!", spanish="¡No tengo nada más que decir!\n¡La reunión matutina se acabó por hoy!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="All right, everyone! ♪[K] Let's get\ndown to work! ♪", french="Très bien! ♪[K] Tout le monde\nau travail! ♪", german="Alles klar, Leute! ♪[K] Gehen\nwir an die Arbeit! ♪", italian="Forza, gente! ♪[K] Mettiamoci\nal lavoro! ♪", spanish="¡De acuerdo! ♪[K] ¡Ahora todos\na trabajar! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
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
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
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
  GROUND:MoveToPosition(npc_npc_pukurin, 420, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 224, 252, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 188, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 240, 272, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 188, false, 2)
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(-32), p.Y+(0), false, 2) end -- Move2PositionOffset
  GROUND:MoveToPosition(npc_npc_kimawari, 324, 188, false, 2)
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 132, false, 2)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What'll we do, [hero]?!\nThe grand master of all things bad!", french="Qu'allons-nous faire,\n[hero]?! Le grand maître de\ntous les maux!", german="Was machen wir bloß,\n[hero]?!? Der Großmeister allen Übels!", italian="Cosa dobbiamo fare,\n[hero]?! Hai sentito? Sua Malvagità!", spanish="¿Qué vamos a hacer,\n[hero]? ¡El gran malo requetemalo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What'll we do, [hero]?!\nThe grand master of all things bad!", french="Qu'allons-nous faire,\n[hero]?! Le grand maître de tous les\nmaux!", german="Was machen wir bloß,\n[hero]?!? Der Großmeister allen Übels!", italian="Cosa dobbiamo fare,\n[hero]?! Hai sentito? Sua Malvagità!", spanish="¿Qué hacemos, [hero]?\n¡El gran malo requetemalo!"})
  else
  SkySceneKit.say({english="What'll we do, [hero]?!\nThe grand master of all things bad!", french="Qu'allons-nous faire,\n[hero]?! Le grand maître de tous les\nmaux!", german="Was machen wir bloß,\n[hero]?!? Der Großmeister allen Übels!", italian="Cosa dobbiamo fare,\n[hero]?! Hai sentito? Sua Malvagità!", spanish="¿Qué vamos a hacer,\n[hero]? ¡El gran malo requetemalo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:TeleportTo(npc_npc_dogoomu, 320, 260, Direction.Down)
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Left)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [CS:N]Loudred[CR]!", french=" Hé, [CS:N]Ramboum[CR]!", german=" Hey, [CS:N]Krakeelo[CR]!", italian=" Ehi, [CS:N]Loudred[CR]!", spanish=" ¡Oye, [CS:N]Loudred[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey, [CS:N]Loudred[CR]!", french=" Hé, [CS:N]Ramboum[CR]!", german=" Hey, [CS:N]Krakeelo[CR]!", italian=" Ehi, [CS:N]Loudred[CR]!", spanish=" ¡Oye, [CS:N]Loudred[CR]!"})
  else
  SkySceneKit.say({english=" Oh, [CS:N]Loudred[CR]!", french=" Oh, [CS:N]Ramboum[CR]!", german=" Hey, [CS:N]Krakeelo[CR]!", italian=" Ehi, [CS:N]Loudred[CR]!", spanish=" ¡Espera, [CS:N]Loudred[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(392, 252, 60, false) end) -- performer/caméra
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-64), p.Y+(0), false, 2) end
  GAME:WaitFrames(10)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-48), p.Y+(0), false, 2) end
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Loudred[CR], you took the graduation\nexam last year, right?[K] Can you tell\nme something?", french="[CS:N]Ramboum[CR], tu as passé\nl'examen l'année dernière, pas vrai?[K] Tu peux\nnous en dire plus?", german="[CS:N]Krakeelo[CR], du hast doch letztes\nJahr die Prüfung gemacht, nicht?[K] Kannst du\nmir etwas darüber erzählen?", italian="[CS:N]Loudred[CR], tu hai provato a fare\nl'esame l'anno scorso, giusto?[K] Puoi dirci\nqualcosa al riguardo?", spanish="[CS:N]Loudred[CR], tú afrontaste el reto\nel año pasado, ¿no?[K] ¿Puedes contarnos algo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Loudred[CR], you took the graduation\nexam last year, didn't you?[K] There's something\nwe'd like to know.", french="[CS:N]Ramboum[CR], tu as passé\nl'examen l'année dernière, pas vrai?[K] Tu peux\nnous en dire plus?", german="[CS:N]Krakeelo[CR], du hast doch letztes\nJahr die Prüfung gemacht, oder nicht?[K] Es gibt\nda etwas, das wir gerne wissen würden.", italian="[CS:N]Loudred[CR], tu hai provato a fare\nl'esame l'anno scorso, giusto?[K] Puoi dirci\nqualcosa al riguardo?", spanish="[CS:N]Loudred[CR], tú afrontaste el reto\nel año pasado, ¿no?[K] ¿Puedes contarnos algo?"})
  else
  SkySceneKit.say({english="[CS:N]Loudred[CR], you took the graduation\nexam last year, right?[K] Can you tell\nme something?", french="[CS:N]Ramboum[CR], tu as passé\nl'examen l'année dernière, pas vrai?[K] Tu peux\nnous en dire plus?", german="[CS:N]Krakeelo[CR], du hast doch letztes\nJahr die Prüfung gemacht, oder?[K] Kannst du\nmir etwas darüber erzählen?", italian="[CS:N]Loudred[CR], tu hai provato a fare\nl'esame l'anno scorso, giusto?[K] Puoi dirci\nqualcosa al riguardo?", spanish="[CS:N]Loudred[CR], tú afrontaste el reto\nel año pasado, ¿no?[K] ¿Qué puedes contarnos?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What was the grand master of\nall things bad like?", french="A quoi ressemble le grand\nmaître de tous les maux?", german="Wie ist dieser Großmeister\nallen Übels denn so?", italian=" Com'è Sua Malvagità?", spanish="¿Cómo era el gran malo\nrequetemalo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Can you tell us what the grand\nmaster of all things bad was like?", french="A quoi ressemble le grand\nmaître de tous les maux?", german="Kannst du uns erzählen, was der\nGroßmeister allen Übels für ein Typ ist?", italian=" Com'è Sua Malvagità?", spanish="¿Cómo era el gran malo\nrequetemalo? Queremos detalles..."})
  else
  SkySceneKit.say({english="What was the grand master of\nall things bad like?", french="A quoi ressemble le grand\nmaître de tous les maux?", german="Wie ist der Großmeister allen\nÜbels denn so?", italian=" Com'è Sua Malvagità?", spanish="¿Cómo era el gran malo\nrequetemalo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Ugh, I'm sorry, but I'm NOT\nallowed to talk about it.[K] It's the guild rule.\nI CAN'T talk about it.", french="Euh, je suis désolé, mais j'ai\nPAS le droit d'en parler.[K] C'est la règle\nde la Guilde. Je PEUX PAS en parler.", german="Ähm, tut mir leid, aber dazu\ndarf ich nichts sagen.[K] Das ist die Gildenregel.\nIch DARF nicht darüber sprechen.", italian="Ugh, spiacente, ma NON posso\nparlarne.[K] È la regola della Gilda.\nNON ne posso parlare.", spanish="Me temo que no puedo hablar de\nello.[K] Son las normas del [CS:N]Pokégremio[CR].\nNo puedo hablar del tema."})
  -- message_KeyWait
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" But...[K]I will tell you this.", french="Mais...[K] laissez-moi vous dire\nquelque chose.", german="Aber...[K] Ich kann euch Folgendes\nsagen.", italian=" Ma...[K] vi dirò questo.", spanish=" Pero...[K] os diré algo."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="You're in for...[K]a dreadful,\nterrifying time.", french="Vous allez...[K] passer un moment\nEPOUVANTABLE. Vraiment TERRIBLE.", german="Euch erwartet...[K] eine\nschauderhafte, schreckliche Zeit.", italian="Vi aspetta...[K] un'avventura\ndavvero terrificante.", spanish="Vais a pasarlo...[K] fatal.\nMuy, muy mal."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="What I went through...[K] Even\nnow, when I let myself remember it...", french="Ce que j'ai vécu...[K] même\nAUJOURD'HUI, quand j'y repense...", german="Was ich alles mitgemacht\nhabe...[K] Sogar jetzt, wenn die Erinnerung mich\neinholt...", italian="Le cose che ho passato...[K] Anche\nadesso, quando ci ripenso...", spanish="Lo que yo tuve que pasar...[K]\nIncluso ahora, solo con recordarlo..."})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "sweating", 1) end)
  -- SetAnimation(18) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" WAAAAH!", french=" WOUAAAH!", german=" AAAAH!", italian=" AAAAAH!", spanish=" ¡AAAAH!"})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- message_Close
  -- GAP: se_Play(7430) — id SE NDS sans portage PMDO identifié
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(-80), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(45)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  -- message_FacePositionOffset(-2, 4) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Ugh...[K] Asking [CS:N]Loudred[CR] didn't give\nus anything to go on.", french="Hum...[K] La réponse de [CS:N]Ramboum[CR]\nne nous a pas servi à grand-chose.", german="Uff...[K] [CS:N]Krakeelo[CR] zu fragen,\nhat uns kein bisschen weitergeholfen.", italian="Ugh...[K] [CS:N]Loudred[CR] non ci ha detto\nniente di utile.", spanish="Vaya...[K] Preguntarle a [CS:N]Loudred[CR] no\nha servido de mucho."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Ugh...[K] [CS:N]Loudred[CR] didn't tell us\nanything useful.", french="Hum...[K] La réponse de [CS:N]Ramboum[CR]\nne nous a pas servi à grand-chose.", german="Uff...[K] [CS:N]Krakeelo[CR] hat uns nichts\nNützliches erzählt.", italian="Ugh...[K] [CS:N]Loudred[CR] non ci ha detto\nniente di utile.", spanish="Vaya...[K] Preguntarle a [CS:N]Loudred[CR] no\nha sido muy útil."})
  else
  SkySceneKit.say({english="Ugh...[K] [CS:N]Loudred[CR] was useless for\ngetting information.", french="Hum...[K] La réponse de [CS:N]Ramboum[CR]\nne nous a pas servi à grand-chose.", german="Uff...[K] Aus [CS:N]Krakeelo[CR] waren\nüberhaupt keine nützlichen Informationen\nherauszubekommen.", italian="Ugh...[K] [CS:N]Loudred[CR] non ci ha detto\nniente di utile.", spanish="Vaya...[K] Preguntarle a [CS:N]Loudred[CR] no\nha sido muy útil que digamos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We're going to have to do our\nbest to graduate on our own, I guess.", french="Nous allons devoir faire de\nnotre mieux pour réussir par nous-mêmes,\nj'imagine.", german="Wir bereiten uns am besten\nallein auf die Prüfung vor, denke ich mal.", italian="Immagino che dovremo fare\ndel nostro meglio per superare l'esame.", spanish="Tendremos que esforzarnos para\nsuperar el reto, con o sin ayuda."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We'll just have to do our best to\ngraduate on our own.", french="Nous allons devoir faire de\nnotre mieux pour réussir par nous-mêmes,\nj'imagine.", german="Wir bereiten uns am besten\nallein auf die Prüfung vor.", italian="Immagino che dovremo fare\ndel nostro meglio per superare l'esame.", spanish="Tendremos que esforzarnos para\nsuperar el reto, con o sin ayuda."})
  else
  SkySceneKit.say({english="We'll just have to do our best to\ngraduate on our own.", french="Nous allons devoir faire de\nnotre mieux pour réussir par nous-mêmes,\nj'imagine.", german="Wir bereiten uns am besten\nalleine auf die Prüfung vor.", italian="Immagino che dovremo fare\ndel nostro meglio per superare l'esame.", spanish="Tendremos que esforzarnos para\nsuperar el reto, con o sin ayuda."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's go down to Treasure Town\nand get ready.", french="Allons à Bourg-Trésor\npour nous préparer.", german="Ab nach Schatzstadt. Zeit, uns\nbereit zu machen.", italian="Andiamo a Borgo Tesoro per\nprepararci.", spanish="Vayamos a Aldea Tesoro a\nprepararnos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go to Treasure Town and\nget ready.", french="Allons à Bourg-Trésor\npour nous préparer.", german="Gehen wir nach Schatzstadt und\nmachen uns bereit.", italian="Andiamo a Borgo Tesoro per\nprepararci.", spanish="Vayamos a Aldea Tesoro a\nprepararnos."})
  else
  SkySceneKit.say({english="I guess we should go down to\nTreasure Town and get ready.", french="Allons à Bourg-Trésor\npour nous préparer.", german="Ich denke, wir sollten nach\nSchatzstadt gehen und uns bereit machen.", italian="Andiamo a Borgo Tesoro per\nprepararci.", spanish="Vayamos a Aldea Tesoro y\npreparémonos."})
  end
  -- message_Close
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SkySceneKit.cleanup_npcs()
end
