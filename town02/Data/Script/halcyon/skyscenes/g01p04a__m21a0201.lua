-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m21a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  GAME:WaitFrames(30)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 344, 272, Direction.Up, "NPC_BIPPA")
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 288, 224, Direction.DownRight, "NPC_DOGOOMU")
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 280, 264, Direction.UpRight, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 312, 272, Direction.Up, "NPC_GUREGGURU")
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 272, 240, Direction.Right, "NPC_CHIRIIN")
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 360, 224, Direction.DownLeft, "NPC_HEIGANI")
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 368, 264, Direction.UpLeft, "NPC_KIMAWARI")
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 328, 216, Direction.Down, "NPC_PERAPPU")
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" ...What?![K] What was that again?", french="... Quoi?! Qu'est-ce que\nvous avez dit?", german=" Was?!?[K] Was war das gleich?", italian="Cosa?![K] Cosa dite che è\nsuccesso?", spanish="¡¿Qué?![K]\n¿Pero qué estáis diciendo?"})
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Just...[K]just hold on for a moment.", french=" Attendez... attendez une minute.", german=" Nur...[K] nur einen kleinen Moment.", italian="Ehi...[K] Aspettate solo un\nmomento.", spanish=" Esperad...[K] Esperad un momento."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Let me get this story straight!", french=" Je dois tirer tout ça au clair.", german="Ich will das nicht falsch\nverstehen!", italian="Fatemi capire bene questa\nstoria!", spanish=" ¡A ver si lo he entendido bien!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" OK...", french=" D'accord...", german=" Okay...", italian=" Ok...", spanish=" Vale..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK...", french=" D'accord...", german=" Okay...", italian=" Ok...", spanish=" Vale..."})
  else
  SkySceneKit.say({english=" OK...", french=" D'accord...", german=" Okay...", italian=" Ok...", spanish=" Vale..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Ahem! Let me summarize your\nstory so far...", french="Hum! Laissez-moi résumer\nvotre histoire...", german="Ähem! Ich fasse eure\nGeschichte bis hierhin zusammen...", italian="Ehm! Fatemi riordinare un attimo\ngli eventi...", spanish="¡Ejem! Dejadme aclarar unos\npuntos..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="First...[K] [CS:N]Grovyle[CR] is actually a\ngood Pokémon...?", french="Premièrement...[K] [CS:N]Massko[CR] est\nen réalité un bon Pokémon...?", german="Erstens...[K] [CS:N]Reptain[CR] ist eigentlich\nein gutes Pokémon?", italian="Prima cosa...[K] [CS:N]Grovyle[CR] in realtà\nè un Pokémon buono...?", spanish="Para empezar...[K] [CS:N]Grovyle[CR] es,\nen realidad, un Pokémon bueno..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And he was collecting the Time\nGears to save the world?", french="Et c'est pour sauver le monde\nqu'il rassemblait les Rouages du Temps?", german="Und er sammelte die Zahnräder\nder Zeit, um die Welt zu retten?", italian="E stava rubando gli Ingranaggi\ndel Tempo per salvare il mondo?", spanish="Y, además, estaba reuniendo los\nEngranajes del Tiempo ¿para salvar el mundo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Right.", french=" C'est bien ça.", german=" Richtig.", italian=" Proprio così.", spanish=" Eso es."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes.", french=" C'est bien ça.", german=" Ja.", italian=" Sì.", spanish=" Eso es."})
  else
  SkySceneKit.say({english=" Yep!", french=" C'est bien ça.", german=" Jep!", italian=" Già!", spanish=" Eso es."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And the great [CS:N]Dusknoir[CR] only\npretended to be kind and helpful...?", french="Et le grand [CS:N]Noctunoir[CR] faisait\njuste semblant de vouloir nous aider...?", german="Und der große [CS:N]Zwirrfinst[CR] hat\nnur vorgegeben, nett und hilfsbereit zu sein?", italian="E il grande [CS:N]Dusknoir[CR] faceva solo\nfinta di essere gentile e di aiutarci...", spanish="Y el gran [CS:N]Dusknoir[CR] solo estaba\nfingiendo ser amable y servicial..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But he was actually a heinous\nand wicked villain?", french="Alors qu'en réalité, c'est\nun ignoble scélérat aux desseins malfaisants?", german="Aber eigentlich soll er ein böser\nund durchtriebener Finsterling sein?", italian=" Ma in realtà è un poco di buono?", spanish="Pero, en realidad, es un villano\natroz y malvado, ¿no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yup...though I didn't really\nphrase it as \"heinous and wicked\"...", french="Oui... même si lui ne l'a pas\nvraiment dit de cette façon...", german="Jep. Obwohl ich nicht\nwirklich [F:S2]böse und durchtrieben[F:E2] gesagt\nhabe...", italian="Sì... Io però non ho detto\nproprio \"poco di buono\"...", spanish="Sí, aunque yo no he usado\nla expresión \"atroz y malvado\"..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yes...though I didn't really\nphrase it as \"heinous and wicked\"...", french="Oui... même si lui ne l'a pas\nvraiment dit de cette façon...", german="Jep. Obwohl ich nicht\nwirklich [F:S2]böse und durchtrieben[F:E2] gesagt\nhabe...", italian="Sì... Io però non ho detto\nproprio \"poco di buono\"...", spanish="Sí, aunque yo no he usado\nla expresión \"atroz y malvado\"..."})
  else
  SkySceneKit.say({english="Yep...though I didn't really\nphrase it as \"heinous and wicked\"...", french="Oui... même si lui ne l'a pas\nvraiment dit de cette façon...", german="Jep. Obwohl ich nicht\nwirklich [F:S2]böse und durchtrieben[F:E2] gesagt\nhabe...", italian="Sì... Io però non ho detto\nproprio \"poco di buono\"...", spanish="Sí, aunque yo no he usado\nla expresión \"atroz y malvado\"..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Also, [hero] was really\n[CS:N]Grovyle[CR]'s partner?", french="En outre, [hero] et\n[CS:N]Massko[CR] étaient partenaires?", german="Also war [hero] in\nWirklichkeit der Partner von [CS:N]Reptain[CR]?", italian="E poi, [hero] lavorava\nveramente insieme a [CS:N]Grovyle[CR]?", spanish="Y, según decís, [hero] y\n[CS:N]Grovyle[CR] eran compañeros, ¿cierto?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup.", french=" Oui.", german=" Jep.", italian=" Già.", spanish=" Así es."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes.", french=" Oui.", german=" Ja.", italian=" Sì.", spanish=" Así es."})
  else
  SkySceneKit.say({english=" Yep.", french=" Oui.", german=" Ja.", italian=" Già.", spanish=" Así es."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="So [CS:N]Dusknoir[CR] wanted to get rid\nof both [hero] and [CS:N]Grovyle[CR]...?", french="Donc, [CS:N]Noctunoir[CR] cherchait à\nse débarrasser de [hero] et [CS:N]Massko[CR]...?", german="Also wollte [CS:N]Zwirrfinst[CR] sowohl\n[hero] als auch [CS:N]Reptain[CR] loswerden?", italian="Così [CS:N]Dusknoir[CR] si voleva liberare\nsia di [hero] che di [CS:N]Grovyle[CR]...?", spanish="[CS:N]Dusknoir[CR] pretendía librarse de\nlos dos, de [hero] y [CS:N]Grovyle[CR], ¿voy bien?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" So he took them to the future?", french="Et c'est pour ça qu'il les a\nemmenés dans le futur?", german="Darum nahm er sie mit in die\nZukunft?", italian=" Quindi li ha portati nel futuro?", spanish="Y, por eso, decís que se los\nllevó al futuro, ¿no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup. And me too.", french=" Oui, et moi aussi.", german=" Jep. Und mich auch.", italian=" Sì. E ha portato anche me.", spanish=" Sí. Arrastrándome a mí de paso."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes. And me too.", french=" Oui, et moi aussi.", german=" Ja. Und mich auch.", italian=" Sì. E ha portato anche me.", spanish=" Sí. Y a mí de paso."})
  else
  SkySceneKit.say({english=" Yep. And me too.", french=" Oui, et moi aussi.", german=" Jep. Und mich auch.", italian=" Sì. E ha portato anche me.", spanish=" Sí. Y también a mí."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Then you managed to escape\nfrom [CS:N]Dusknoir[CR] by the skin of your teeth...?", french="Ensuite vous avez réussi\nà échapper in extremis aux griffes de\n[CS:N]Noctunoir[CR]...?", german="Dann seid ihr [CS:N]Zwirrfinst[CR] so\ngerade eben entkommen?", italian="Poi la fuga da [CS:N]Dusknoir[CR] vi è\nriuscita per un pelo...?", spanish="Luego, conseguisteis escapar de\n[CS:N]Dusknoir[CR] por los pelos..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And you barely made it back\nhome from the future?", french="Et vous avez réussi à rentrer\nde justesse?", german="Und ihr habt es aus der Zukunft\nso gerade eben zurück nach Hause geschafft?", italian="Appena in tempo per riuscire a\ntornare a casa dal futuro?", spanish="Y, de milagro, lograsteis\nregresar del futuro... ¿He entendido bien?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup.", french=" Ouaip.", german=" Jep.", italian=" Già.", spanish=" En efecto."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes.", french=" Ouaip.", german=" Ja.", italian=" Sì.", spanish=" En efecto."})
  else
  SkySceneKit.say({english=" Yep.", french=" Ouaip.", german=" Jep.", italian=" È così.", spanish=" En efecto."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And finally, this planet will soon\nbecome paralyzed...[K]and to prevent that...", french="Et pour finir, la planète va\nbientôt se retrouver paralysée...[K]\net pour empêcher ça...", german="Und schließlich wird dieser\nPlanet bald gelähmt sein...[K] Und um das zu\nverhindern...", italian="E alla fine, questo pianeta\nrimarrà presto paralizzato...[K] e per evitarlo...", spanish="Para finalizar, el planeta pronto\nquedará paralizado...[K] y para poder evitarlo..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Grovyle[CR] has started gathering\nTime Gears again?", french="... [CS:N]Massko[CR] s'est remis en quête\ndes Rouages du Temps?", german="Darum sammelt [CS:N]Reptain[CR] also\njetzt wieder Zahnräder der Zeit?", italian="... [CS:N]Grovyle[CR] ha ricominciato a\ncercare gli Ingranaggi del Tempo?", spanish="[CS:N]Grovyle[CR] ha empezado a reunir\nde nuevo los Engranajes del Tiempo, ¿me\nequivoco?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Meanwhile, you two are\nlooking for a place called the [CS:P]Hidden Land[CR]?[K]\nIs that your story in its full entirety?!", french="Et de votre côté, vous cherchez\nun endroit appelé les [CS:P]Terres Illusoires[CR]?[K]\nEst-ce que ça résume bien votre histoire?!", german="Währenddessen sucht ihr nach\ndem [CS:P]Verborgenen Land[CR]?[K] Ist das eure\nvollständige Geschichte?", italian="Nel frattempo, voi due state\ncercando un posto chiamato [CS:P]Terra Nascosta[CR]?[K]\nÈ questo tutto quello che vi è successo?!", spanish="Y, mientras tanto, estáis\nbuscando un lugar llamado la [CS:P]Tierra Oculta[CR]...[K]\n¡¿Esa es toda vuestra historia?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup. That's all of it!", french=" Oui, c'est exactement ça!", german=" Jep. Das war alles!", italian="Già. Le cose sono andate proprio\ncosì.", spanish=" Sí. Eso es todo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes. That's all of it!", french=" Oui, c'est exactement ça!", german=" Ja. Das war alles!", italian="Già. Le cose sono andate proprio\ncosì.", spanish=" Sí. Eso es todo."})
  else
  SkySceneKit.say({english=" Yep! That's all of it!", french=" Oui, c'est exactement ça!", german=" Jep. Das war alles!", italian="Già. Le cose sono andate proprio\ncosì.", spanish=" Sí. Eso es todo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" ........................", french=" ........................", german=" ........................", italian=" ........................", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Hee![K] Hee-heeee! Hee-heeee!", french=" Hi![K] Hi hi! Hi hi hi!", german=" Hi![K] Hihihi! Hihihi!", italian=" Eeh![K] Eeh-Eeeeh! Eeh-Eeeeh!", spanish=" ¡Ji![K] ¡Ji, ji, ji! ¡Ji, ji, ji, ji!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" [partner] and [hero]...", french=" [partner] et [hero]...", german=" [partner] und [hero]...", italian=" [partner] e [hero]...", spanish=" [partner] y [hero]..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You must have had a bad dream\nor something!", french="Mais vous avez dû faire\nun cauchemar, rien d'autre!", german="Ihr müsst schlecht geträumt\nhaben!", italian="Dev'essere stato un brutto sogno\no qualcosa del genere!", spanish="¡Sin duda habéis tenido una\npesadilla!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  else
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Why don't you two just go to\nyour room and get some rest! ♪", french="Pourquoi est-ce que vous\nn'allez pas vous reposer un peu dans votre\nchambre? ♪", german="Warum geht ihr nicht erst\neinmal auf euer Zimmer und ruht euch etwas\naus? ♪", italian="Perché non andate nella vostra\nstanza a riposarvi un po'?! ♪", spanish="¿Por qué no os vais a vuestro\ncuarto a descansar un poco? ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Now, wait a second!", french=" Eh, attends!", german=" Jetzt warte aber mal!", italian=" Ehi, aspetta un secondo!", spanish=" No, ¡espera un segundo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What? Wait a second!", french=" Eh, attends!", german=" Was? Eine Sekunde!", italian=" Cosa? Aspetta un secondo!", spanish=" ¿Qué? ¡Espera un segundo!"})
  else
  SkySceneKit.say({english=" Now, hold on a second!", french=" Eh, attends!", german=" Jetzt warte aber eine Sekunde!", italian=" Ehi, aspetta un secondo!", spanish=" ¿Qué? ¡Espera un segundo!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You're saying we're lying?", french=" Tu insinues qu'on vous ment?", german=" Sagst du, dass wir lügen?", italian="Stai dicendo che stiamo\nmentendo?", spanish=" ¿Estás diciendo que mentimos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You think we're lying?", french=" Tu insinues qu'on vous ment?", german=" Du denkst, wir lügen?", italian=" Pensi che stiamo mentendo?", spanish=" ¿Estás diciendo que mentimos?"})
  else
  SkySceneKit.say({english=" Are you accusing us of lying?", french=" Tu insinues qu'on vous ment?", german=" Bezichtigst du uns der Lüge?", italian=" Ci stai accusando di mentire?", spanish=" ¿Nos acusas de mentir?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What we just told you, it's true.\nAll of it.", french="Tout ce qu'on vient de vous\nraconter n'est que la pure vérité.", german="Es stimmt, was wir euch gerade\nerzählt haben. Jedes einzelne Wort.", italian="Quello che vi abbiamo detto è\nvero, tutto quanto.", spanish="Todo lo que os hemos contado\nes verdad. Absolutamente todo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What we just told you is\nall true.", french="Tout ce qu'on vient de vous\nraconter n'est que la pure vérité.", german="Was wir euch gerade erzählt\nhaben, ist die reine Wahrheit.", italian="Quello che vi abbiamo appena\ndetto è vero.", spanish="Todo lo que os hemos contado\nes verdad."})
  else
  SkySceneKit.say({english="What we just told you is\nall true.", french="Tout ce qu'on vient de vous\nraconter n'est que la pure vérité.", german="Was wir euch gerade erzählt\nhaben, ist die reine Wahrheit.", italian="Quello che vi abbiamo appena\ndetto è vero.", spanish="Todo lo que os hemos contado\nes verdad."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" I'm sure...I'm sure... ♪", french="Bien sûr, je n'en doute pas\nun seul instant... ♪", german=" Sicher, sicher... ♪", italian=" Certo... Certo... ♪", spanish=" Claro, claro... ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I'm sure you two are suffering\nfrom exhaustion!", french="Je suis sûr que c'est la\nfatigue qui vous accable!", german="Ich bin sicher, ihr beide seid\ntotal erschöpft!", italian="Sono sicuro che avete un gran\nbisogno di riposare!", spanish="Seguro que esto es a causa del\nagotamiento. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" A good nap will fix that! ♪", french="Une bonne sieste vous remettra\nd'aplomb! ♪", german="Nach einem kurzen Nickerchen\ngeht das wieder! ♪", italian="Un bel sonnellino vi farà star\nmeglio! ♪", spanish=" Una buena siesta lo arreglará."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's not it, [CS:N]Chatot[CR]![K] I tell you,\nwe're not lying!", french="Tu te trompes, [CS:N]Pijako[CR]![K]\nJe t'assure qu'on vous dit la vérité!", german="Das hat nichts damit zu tun,\n[CS:N]Plaudagei[CR]![K] Ich versichere dir, dass wir nicht\nlügen!", italian="Non è così, [CS:N]Chatot[CR]![K] Te lo\nassicuro, non stiamo mentendo!", spanish="¡No es eso, [CS:N]Chatot[CR]![K]\n¡Te aseguro que te estamos contando\nla verdad!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's not it, [CS:N]Chatot[CR]![K] Seriously,\nwe're telling you the truth!", french="Tu te trompes, [CS:N]Pijako[CR]![K]\nJe t'assure qu'on vous dit la vérité!", german="Das hat nichts damit zu tun,\n[CS:N]Plaudagei[CR]![K] Wir sagen dir wirklich die\nWahrheit!", italian="Non è così, [CS:N]Chatot[CR]![K] Davvero,\nstiamo dicendo la verità!", spanish="¡No es eso, [CS:N]Chatot[CR]![K]\n¡Te aseguro que no mentimos!"})
  else
  SkySceneKit.say({english="That's not it, [CS:N]Chatot[CR]![K] Please\nbelieve us, we're not lying!", french="Tu te trompes, [CS:N]Pijako[CR]![K]\nJe t'assure qu'on vous dit la vérité!", german="Das hat nichts damit zu tun,\n[CS:N]Plaudagei[CR]![K] Bitte glaube uns, wir lügen nicht!", italian="Non è così, [CS:N]Chatot[CR]![K] Ti prego,\ndevi crederci, non stiamo mentendo!", spanish="¡No es eso, [CS:N]Chatot[CR]![K]\n¡Te aseguro que todo es cierto!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "angry", 1) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" That's quite enough!", french=" Il suffit!", german=" Das reicht erst einmal!", italian=" Ne ho abbastanza!", spanish=" ¡Ya basta!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="So tell me! Is there any part of\nyour story that's even remotely plausible?", french="Non mais franchement,\nvotre histoire ne tient pas debout!", german="Sagt mal! Ist irgendwas an der\nGeschichte dran, das im Enferntesten\nglaubwürdig ist?", italian="Allora ditemi! C'è anche solo una\nparte della vostra storia che sia minimamente\nplausibile?", spanish="¡Vamos a ver! ¿Hay siquiera\nuna mínima parte de vuestra historia que\nsea remotamente creíble?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" A place called the [CS:P]Hidden Land[CR]?!", french=" Les [CS:P]Terres Illusoires[CR]?!", german="Ein Ort namens\n[CS:P]Verborgenes Land[CR]?!?", italian="Un posto chiamato [CS:P]Terra[CR]\n[CS:P]Nascosta[CR]?!", spanish="¡¿Un lugar llamado\nla [CS:P]Tierra Oculta[CR]?!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I'm the head of intelligence here,\nand I've heard of no such place.", french="Ici, c'est moi le chef des\nservices de renseignements, et je n'ai jamais\nentendu parler d'un tel endroit.", german="Ich bin der Leiter des\nInformationsdienstes hier und habe noch nie\nvon einem solchen Ort gehört.", italian="Neppure io che sono il gazzettino\ndella Gilda ho mai sentito parlare di questo\nposto.", spanish="Manejo toda la información del\n[CS:N]Pokégremio[CR] y jamás había oído hablar de\ntal sitio."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Besides, the great [CS:N]Dusknoir[CR] is\nfar too kind to do anything like you've alleged!", french="D'autre part, le grand [CS:N]Noctunoir[CR]\nest bien trop bon pour se rendre coupable de\nce dont vous l'accusez!", german="Nebenbei bemerkt ist der große\n[CS:N]Zwirrfinst[CR] viel zu liebenswürdig, um\netwas von dem zu tun, was ihr ihm vorwerft!", italian="Inoltre, il grande [CS:N]Dusknoir[CR] è\ndi gran lunga troppo onesto per fare anche\nsolo una delle cose di cui l'accusate!", spanish="¡Además, el gran [CS:N]Dusknoir[CR] es\ndemasiado bondadoso para hacer nada de eso\nque le achacáis!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Well, sure, I couldn't believe the\ntruth about [CS:N]Dusknoir[CR] either...", french="Je sais bien, moi non plus\nje n'arrivais pas à croire la vérité au sujet de\n[CS:N]Noctunoir[CR]...", german="Sicher! Ich konnte die Wahrheit\nüber [CS:N]Zwirrfinst[CR] auch nicht glauben...", italian="Beh, certo, neanch'io riuscivo a\ncredere alla verità su [CS:N]Dusknoir[CR]...", spanish="Bueno, lo cierto es que yo\ntampoco podía creer la verdad sobre\n[CS:N]Dusknoir[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well, yes, I couldn't believe the\ntruth about [CS:N]Dusknoir[CR] either...", french="Je sais bien, moi non plus\nje n'arrivais pas à croire la vérité au sujet de\n[CS:N]Noctunoir[CR]...", german="Nun ja, ich konnte die\nWahrheit über [CS:N]Zwirrfinst[CR] auch nicht glauben...", italian="Beh, sì, neanch'io riuscivo a\ncredere alla verità su [CS:N]Dusknoir[CR]...", spanish="Bueno, lo cierto es que yo\ntampoco podía creer la verdad sobre\n[CS:N]Dusknoir[CR]."})
  else
  SkySceneKit.say({english="Well, yes, I couldn't believe the\ntruth about [CS:N]Dusknoir[CR] either...", french="Je sais bien, moi non plus\nje n'arrivais pas à croire la vérité au sujet de\n[CS:N]Noctunoir[CR]...", german="Nun ja, ich konnte die\nWahrheit über [CS:N]Zwirrfinst[CR] auch nicht glauben...", italian="Beh, sì, neanch'io riuscivo a\ncredere alla verità su [CS:N]Dusknoir[CR]...", spanish="Bueno, lo cierto es que yo\ntampoco podía creer la verdad sobre\n[CS:N]Dusknoir[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It was a huge shock. And it was\nreally hard to accept.", french="Ça a été un choc terrible. Et j'ai\neu beaucoup de mal à l'accepter.", german="Es war ein Riesenschock. Und es\nwar wirklich schwer zu akzeptieren.", italian="È stato un grande shock. Ed è\nstata dura da accettare.", spanish="Fue algo desconcertante.\nY me costó muchísimo aceptarlo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It came as a huge shock. And it\nwas really hard to accept.", french="Ça a été un choc terrible. Et j'ai\neu beaucoup de mal à l'accepter.", german="Es war ein Riesenschock. Und es\nwar wirklich schwer zu akzeptieren.", italian="È stato un grande shock. Ed è\nstata dura da accettare.", spanish="Fue algo desconcertante.\nY me costó muchísimo aceptarlo."})
  else
  SkySceneKit.say({english="It was a huge shock. And it was\nreally hard to accept.", french="Ça a été un choc terrible. Et j'ai\neu beaucoup de mal à l'accepter.", german="Es war ein Riesenschock. Und es\nwar wirklich schwer zu akzeptieren.", italian="È stato un grande shock. Ed è\nstata dura da accettare.", spanish="Fue algo desconcertante.\nY me costó muchísimo aceptarlo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But...!", french=" Pourtant...!", german=" Aber...", italian=" Tuttavia...", spanish=" Pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But...!", french=" Pourtant...!", german=" Aber...", italian=" Tuttavia...", spanish=" Pero..."})
  else
  SkySceneKit.say({english=" But...!", french=" Pourtant...!", german=" Aber...", italian=" Tuttavia...", spanish=" Pero..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" I'll hear no more of this!", french=" Je ne veux plus vous entendre!", german="Ich will nichts mehr davon\nhören!", italian="Non voglio sentire una parola di\npiù!", spanish=" ¡No pienso oír nada más!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I don't care what you say! The\ngreat [CS:N]Dusknoir[CR], the villain?!", french="Peu m'importe ce que vous\ndites! Le grand [CS:N]Noctunoir[CR], un traître?!", german="Euer Gerede interessiert mich\nnicht! Der große [CS:N]Zwirrfinst[CR], ein Bösewicht?!?", italian="Dite pure quello che vi pare!\nIl grande [CS:N]Dusknoir[CR] è cattivo?", spanish="¡No me importa lo que digáis!\n¡¿El gran [CS:N]Dusknoir[CR], un villano?!"})
  -- message_KeyWait
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" That's simply unbelievable!", french=" C'est tout bonnement impensable!", german=" Das ist einfach unvorstellbar!", italian=" È semplicemente inammissibile!", spanish=" ¡Eso es inconcebible!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Seriously, don't you two feel the\nsame way?", french="Soyons sérieux, vous n'êtes pas\nde mon avis, vous aussi?", german="Mal ganz ehrlich, denkt ihr zwei\nnicht genauso?", italian="Seriamente, non la pensate così\nanche voi?", spanish=" ¿No pensáis lo mismo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="How can anybody seriously think\nof the great [CS:N]Dusknoir[CR] as a villain?!", french="Comment imaginer ne serait-ce\nqu'une seule seconde que l'illustre [CS:N]Noctunoir[CR]\npuisse être un scélérat?!", german="Wie kann irgendjemand den\ngroßen [CS:N]Zwirrfinst[CR] ernsthaft für einen\nBösewicht halten?!?", italian="Come si potrebbe credere\nseriamente che il grande [CS:N]Dusknoir[CR] sia un\ncriminale?!", spanish="¡¿Cómo puede tomar nadie al\ngran [CS:N]Dusknoir[CR] por un villano?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" We hold [CS:N]Dusknoir[CR] in high esteem.", french="Nous tenons [CS:N]Noctunoir[CR] en haute\nestime.", german=" Ich schätze [CS:N]Zwirrfinst[CR] sehr.", italian="Abbiamo grande stima di\n[CS:N]Dusknoir[CR].", spanish=" Estimamos mucho a [CS:N]Dusknoir[CR]."})
  GROUND:EntTurn(hero, Direction.DownLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dagutorio, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" We cannot believe it.", french=" Nous ne pouvons le croire.", german=" Ich kann das nicht glauben.", italian=" Non possiamo crederci.", spanish=" No podemos creerlo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" See?![K] See?!", french=" Vous voyez?![K] Vous voyez bien?!", german=" Seht ihr?[K] Seht ihr?!?", italian=" Visto?![K] Visto?!", spanish=" ¡¿Lo veis?![K] ¡¿Lo veis?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="See?[K] Everyone shares the\nsame opinion!", french="Rendez-vous à l'évidence.[K]\nTout le monde est du même avis!", german=" Seht ihr?[K] Da sind sich alle einig!", italian="Visto?[K] La pensano tutti come\nme!", spanish="¿Lo veis?[K]\n¡Todos opinan lo mismo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" But...", french=" Mais...", german=" Aber...", italian=" Sì, però...", spanish=" Pero..."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kimawari, 4) end)
  GROUND:EntTurn(partner, Direction.DownRight)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 384, 216, Direction.DownLeft, "NPC_PUKURIN")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_kimawari, 4) end)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 376, 240, Direction.Left, "NPC_DIGUDA")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_kimawari, 4) end)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Hm?[K] What is it, [CS:N]Sunflora[CR]?", french="Hum?[K] Qu'y a-t-il,\n[CS:N]Héliatronc[CR]?", german=" Hm?[K] Was ist denn, [CS:N]Sonnflora[CR]?", italian=" Eh?[K] Cosa c'è, [CS:N]Sunflora[CR]?", spanish=" ¿Eh?[K] ¿Qué pasa, [CS:N]Sunflora[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="There is something I don't\nunderstand.", french="Il y a quelque chose que\nje ne comprends pas.", german=" Etwas verstehe ich daran nicht.", italian="C'è una cosa che non mi è\nchiara.", spanish=" Hay algo que no entiendo."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" That time...", french=" La dernière fois...", german=" Das eine Mal...", italian=" Quella volta...", spanish=" En aquella ocasión..."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="when the great [CS:N]Dusknoir[CR] was\nabout to return to the future...", french="... quand le grand [CS:N]Noctunoir[CR]\ns'apprêtait à repartir dans le futur...", german="Als der große [CS:N]Zwirrfinst[CR] vor\nder Rückkehr in die Zukunft stand...", italian="Voglio dire, quando il grande\n[CS:N]Dusknoir[CR] stava per tornare nel futuro...", spanish="Cuando el gran [CS:N]Dusknoir[CR] iba\na regresar al futuro..."})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
