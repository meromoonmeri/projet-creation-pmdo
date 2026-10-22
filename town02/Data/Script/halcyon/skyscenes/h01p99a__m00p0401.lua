-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99A/m00p0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 176, 136, Direction.Left, "NPC_DAGUTORIO")
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" O sea![K] We call out to you!", french="Ô mer![K] Nous en appelons\nà ta sagesse!", german=" Oh weites Meer![K] Erhöre mich!", italian=" Oh mare![K] Ti chiamiamo!", spanish=" ¡Oh, mar![K] ¡Te invocamos!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="We are frustrated with our\ninsignificant selves!", french="Nous sommes contrariés par\nnotre personne insignifiante!", german="Mein unbedeutendes Dasein\nfrustriert mich über alle Maßen!", italian="La nostra insignificanza ci crea\nfrustrazione!", spanish="¡Nos frustra nuestra\ninsignificancia!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="There is nothing we want more\nthan to capture that [CS:N]Grovyle[CR] thief on our own!", french="Nous aimerions tellement\ncapturer nous-mêmes [CS:N]Massko[CR] le voleur!", german="Mehr als alles andere will ich\neigenhändig diesen [CS:N]Reptain[CR] fangen!", italian="Non desideriamo altro che\ncatturare quel ladro di [CS:N]Grovyle[CR] con le nostre\nforze!", spanish="¡No hay nada que deseemos más\nque capturar solos a ese ladrón de [CS:N]Grovyle[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="But that is denied to us! Every\nday, we must toil away at our dull job!", french="Mais cela nous est refusé!\nJour après jour, nous devons retourner\nà notre tâche sans intérêt.", german="Aber es ist mir nicht vergönnt!\nJeden Tag verrichte ich dieselbe stupide\nArbeit!", italian="Ma non ci è permesso! Ogni\ngiorno dobbiamo occuparci del nostro tedioso\nlavoro!", spanish="¡Pero no está a nuestro alcance!\n¡Cada día tenemos que partirnos la espalda\nen nuestro mediocre trabajo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(9) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" We are so...[K] We are very...", french="Nous sommes si...[K] nous sommes\ntrès...", german=" Ich bin...[K] Ich bin so...", italian=" Siamo...[K] Siamo molto...", spanish=" Estamos tan...[K] Tan sumamente..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" We're extremely frustrated!", french="Nous sommes extrêmement\nfrustrés!", german=" Ich bin so entsetzlich frustriert!", italian=" Siamo estremamente frustrati!", spanish=" ¡Estamos realmente frustrados!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" What are we to do?!", french=" Que devons-nous faire?!", german=" Was soll ich nur tun?!?", italian=" Cosa dobbiamo fare?!", spanish=" ¡¿Qué debemos hacer?!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Answer, O mighty sea![K] Tell us\nwhat to do!", french="Réponds-nous, ô puissante\nmer![K] Dis-nous quoi faire!", german="Antworte mir, oh allwissendes\nMeer![K] Sag mir, was ich tun soll!", italian="Rispondi, o vasto mare![K] Dicci\ncosa fare!", spanish="¡Oh, poderoso mar!\n¡Respóndenos![K] ¡Dinos qué hacer!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  SkySceneKit.say({english="[CN]SPLOOOOSH...", french="[CN]SPLAAASH...", german="[CN]PLITSCH...", italian="[CN]SPLOOOOSH...", spanish="[CN]CHOOOOFFF..."}) -- message_ImitationSound (onomatopée)
  -- message_KeyWait
  SkySceneKit.say({english="[CN]SPLAAAASH...", french="[CN]PLOUUUF...", german="[CN]PLATSCH...", italian="[CN]SPLAAAASH...", spanish="[CN]CHAAAAFFF..."}) -- message_ImitationSound (onomatopée)
  -- message_KeyWait
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- GAP: se_Play(6675) — id SE NDS sans portage PMDO identifié
  SkySceneKit.say({english="[CN]SPLOOSH...SPLASH!", french="[CN]PLOUUUF... SPLAAAASH!", german="[CN]PLITSCH... PLATSCH!", italian="[CN]SPLOOSH... SPLASH!", spanish="[CN]CHOF... ¡CHAF!"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="What?![K] O sea![K] Whatever did\nyou just say, O sea?", french="Comment?![K] Ô mer![K] Qu'as-tu dit,\nô majestueuse mer?", german="Was?!?[K] Oh Meer![K] Was hast du\nnur gesagt, oh Meer?", italian="Cosa?![K] O mare![K] Cosa hai\ndetto, o mare?", spanish="¡¿Qué?![K] ¡Oh, mar![K]\n¿Qué nos acabas de decir, poderoso mar?"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" What...[K] What did you say?!", french=" Que...[K] qu'as-tu dit?!", german=" Was...[K] Was hast du gesagt?!?", italian=" Cosa...[K] Cosa hai detto?!", spanish=" ¿Qué...?[K] ¡¿Qué nos has dicho?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="[CN]...[K]YOUR...DUTY...", french="[CN]...[K] TON... DEVOIR...", german="[CN]...[K]DEINE... PFLICHT...", italian="[CN]...[K] IL VOSTRO... COMPITO...", spanish="[CN]...[K] VUESTRO... DEBER..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Uh...[K] Yes...?", french=" Euh...[K] oui...?", german=" Äh...[K] Ja?", italian=" Eh...[K] Sì...?", spanish=" Esto...[K] ¿Sí...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="[CN]...[K]DO YOUR DUTY...", french="[CN]...[K] ACCOMPLIS TON DEVOIR...", german="[CN]...[K]TU DEINE PFLICHT...", italian="[CN]...[K] FATE IL VOSTRO LAVORO...", spanish="[CN]...[K] CUMPLID CON VUESTRO DEBER..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" But...?!", french=" Mais...?!", german=" Aber...", italian=" Ma...?!", spanish=" Pero..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="[CN]NO MORE BELLYACHING![K]\n[CN]GO DO YOUR DUTY!", french="[CN]FINI LES RONCHONNEMENTS![K]\n[CN]RETOURNE ACCOMPLIR TON DEVOIR!", german="[CN]KEINE GRÜBELEIEN MEHR![K]\n[CN]GEH UND TU DEINE PFLICHT!", italian="[CN]BASTA TERGIVERSARE![K]\n[CN]AL LAVORO!", spanish="[CN]¡DEJAD DE GIMOTEAR![K]\n[CN]¡ID A CUMPLIR CON VUESTRO DEBER!"})
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(3)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(5)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Waaaah! S-s-sorry!", french=" Ouaaaah! Par... pardon!", german=" Waaaah! V-v-verzeih mir!", italian=" Waaaah! S-S-Scusaci!", spanish=" ¡Aaah! ¡Lo sentimos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6422) — id SE NDS sans portage PMDO identifié
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Down)
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(60)
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(90)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 400, 208, Direction.Up, "NPC_DOGOOMU")
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end) -- message_SetActor(ACTOR_NPC_DOGOOMU)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Hey, [CS:N]Diglett[CR].[K] That's what you\nwanted me to do, right?", french="Hé, [CS:N]Taupiqueur[CR].[K] C'est bien ça\nque tu voulais que je fasse, HEIN?", german="Hey, [CS:N]Digda[CR].[K] Das sollte ich also\nfür dich tun, nicht wahr?", italian="Ehi, [CS:N]Diglett[CR].[K] È questo che\nvolevi farmi fare, giusto?", spanish="Eh, [CS:N]Diglett[CR].[K] Esto es lo\nque querías que hiciera, ¿no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitEffect
  GROUND:EntTurn(hero, Direction.Right)
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetPositionLives(0) [cible objet/id de décor NDS non simulée - trace]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(360, 196, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 400, 184, Direction.Down, "NPC_DIGUDA")
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Yes. Exactly.", french=" Oui. Exactement.", german=" Ja. Genau.", italian=" Sì. Esatto.", spanish=" Así es."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Your voice carries so well,\n[CS:N]Loudred[CR]. It worked perfectly!", french="Tu as une voix qui porte,\n[CS:N]Ramboum[CR]. Ça a marché comme sur\ndes roulettes!", german="Du hast eine so volle Stimme,\n[CS:N]Krakeelo[CR]. Es hat perfekt funktioniert!", italian="La tua voce è così potente,\n[CS:N]Loudred[CR]. Ha funzionato benissimo!", spanish="Tu voz se proyecta tan bien,\n[CS:N]Loudred[CR]... ¡Ha funcionado perfectamente!"})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Thank you so much for this,\n[CS:N]Loudred[CR].", french="Merci beaucoup pour ton aide,\n[CS:N]Ramboum[CR].", german="Vielen Dank, dass du das getan\nhast, [CS:N]Krakeelo[CR].", italian=" Grazie mille, [CS:N]Loudred[CR].", spanish="Muchísimas gracias\npor ayudarme, [CS:N]Loudred[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="But, wow...[K]pulling a stunt like\nthat on your own dad.", french="Mais quand même...[K] jouer\nun tour pareil à ton propre père!", german="Aber ich muss schon sagen...[K]\nDem eigenen Vater so einen Streich zu spielen!", italian="Ma, wow...[K] fare una cosa del\ngenere a tuo padre!", spanish="Pero hay que ver...[K] ¡Hacerle\nesto a tu propio padre!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="You're sure you did the right\nthing? I'm serious!", french="T'es sûr d'avoir eu raison\nde faire ça? Je PLAISANTE pas!", german="Bist du dir sicher, dass das\nrichtig war? Ich meine, im Ernst?", italian="Pensi sinceramente che fosse la\ncosa giusta da fare? Dico sul serio!", spanish="¿Tú crees que has hecho bien?\n¡Hablo en serio!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Yes, I'm certain.[K] It's about time\nmy dad got over this and went back to work.", french="Oui, j'en suis sûr.[K] Il est grand\ntemps que mon père arrête avec ses bêtises\net qu'il se remette au travail.", german="Ja, ich bin mir sicher.[K] Es war\nhöchste Zeit für ihn, darüber hinwegzukommen\nund wieder zu arbeiten.", italian="Sì, ne sono certo.[K] Era ora che\nmio padre superasse la cosa e tornasse al\nlavoro.", spanish="Sin duda alguna.[K] Ya era hora de\nque mi padre superase este bache y volviera\na su trabajo."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" He needed a jolt like that.", french="Ce qu'il lui fallait, c'était\nun choc.", german=" Er hat diesen Schock gebraucht.", italian=" Gli serviva una scossa così.", spanish="Necesitaba un empujoncito\ncomo este."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="W-well now, you're sure tough\nas a rock when it comes to your family.", french="Waouh, t'es solide comme un roc\nquand ça concerne ta famille, toi.", german="N-nun ja, in Familiendingen bist\ndu wohl knallhart.", italian="B-Beh, sei proprio determinato\nquando si tratta della tua famiglia.", spanish="Desde luego eres duro como\nuna piedra en lo que respecta a tu familia..."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="But if you're OK with it,\nI'm glad to have helped!", french="Mais si tu trouves que c'était\nimportant, alors je suis CONTENT d'avoir pu\nt'aider!", german="Aber ich habe dir gerne\ngeholfen, wenn du damit glücklich bist!", italian="Se pensi veramente che sia\nstata la cosa giusta da fare, sono contento di\naverti aiutato!", spanish="Pero si a ti te parece bien así,\n¡me alegro de haber podido ayudar!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Thank you![K] We should get back\nto our own sentry jobs, [CS:N]Loudred[CR]!", french="Merci![K] Retournons au\nposte de garde, [CS:N]Ramboum[CR]!", german="Vielen Dank![K] Wir sollten zurück\nzum Wachposten und auch wieder arbeiten,\n[CS:N]Krakeelo[CR]!", italian="Grazie![K] Adesso dobbiamo\ntornare a fare la guardia, [CS:N]Loudred[CR]!", spanish="¡Gracias![K] ¡Ahora tenemos que\nvolver a nuestra labor de vigía, [CS:N]Loudred[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Yeah!", french=" Ouais!", german=" Ja!", italian=" Sì!", spanish=" ¡Sí!"})
  -- message_Close
  -- GAP: se_Play(6422) — id SE NDS sans portage PMDO identifié
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_dogoomu, 496, 204, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  SkySceneKit.cleanup_npcs()
end
