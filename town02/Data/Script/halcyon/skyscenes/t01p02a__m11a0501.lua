-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/m11a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  SkyProg.set(12, 4) -- $SCENARIO_MAIN = scn[12,4] (ROM)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  -- back_SetGround(LEVEL_T01P02A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-32), p.Y+(0), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-32), p.Y+(0), false, 2) end
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 320, 200, Direction.Up, "NPC_YONOWAARU")
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "happy", 1) end)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?[K] Isn't that...?", french=" Hein?[K] Serait-ce...?", german=" Huch?[K] Ist das nicht...", italian=" Eh?[K] Ma quello non è...?", spanish=" ¿Eh?[K] ¿Ese no es...?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey![K] Isn't that...?", french=" Hein?[K] Serait-ce...?", german=" Hey![K] Ist das nicht...", italian=" Ehi![K] Ma quello non è...?", spanish=" ¡Eh![K] ¿Ese no es...?"})
  else
  SkySceneKit.say({english=" Hey![K] Isn't that...?", french=" Hein?[K] Serait-ce...?", german=" Hey![K] Ist das nicht...", italian=" Ehi![K] Ma quello non è...?", spanish=" ¡Mira![K] ¿Ese no es...?"})
  end
  -- message_Close
  pcall(function() GAME:MoveCamera(336, 212, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 360, 188, false, 2)
  GROUND:MoveToPosition(partner, 360, 208, false, 2)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yonowaaru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, nil, 0) end) -- EFFECT_NONE
  local npc_npc_kakureon1 = SkySceneKit.spawn_npc("kecleon", 328, 168, Direction.Down, "NPC_KAKUREON1")
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon1, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "exclaim", 1) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kakureon1, hero, 4) end)
  local npc_npc_kakureon2 = SkySceneKit.spawn_npc("kecleon", 352, 168, Direction.Down, "NPC_KAKUREON2")
  GROUND:EntTurn(npc_npc_kakureon2, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Hello there! You're from the\nguild, if I'm not mistaken?", french="Bonjour à vous! Vous êtes de\nla Guilde, si je ne m'abuse?", german="Hallo! Ihr seid von der Gilde,\nwenn ich mich nicht irre.", italian="Buongiorno a voi. Se non erro\nvoi fate parte della Gilda.", spanish="¡Hola! Sois miembros del\n[CS:N]Pokégremio[CR], ¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup. We're Team [team:].", french="Oui, on est l'Equipe\n[team:].", german="Jep. Wir sind\nTeam [team:].", italian="Già. Noi siamo il\nTeam [team:].", spanish="Sí. Somos el [CS:X]Equipo[CR]\n[team:]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes. We're Team [team:].", french="Oui, on est l'Equipe\n[team:].", german="Ja. Wir sind\nTeam [team:].", italian="È proprio così. Noi siamo il\nTeam [team:].", spanish="Sí. Somos el [CS:X]Equipo[CR]\n[team:]."})
  else
  SkySceneKit.say({english=" Yes. We're Team [team:].", french="Oui, on est l'Equipe\n[team:].", german="Ja. Wir sind\nTeam [team:].", italian="È proprio così. Noi siamo il\nTeam [team:].", spanish="Sí. Somos el [CS:X]Equipo[CR]\n[team:]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We work at the guild.[K] Great to\nmeet you!", french="On travaille à la Guilde.[K]\nEnchantés de vous connaître!", german="Wir arbeiten für die Gilde.[K]\nWie toll, dich zu treffen!", italian=" Piacere di conoscerla!", spanish="Trabajamos en el [CS:N]Pokégremio[CR].[K]\n¡Es un placer conocerte!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We work at the guild.[K]\nIt's great to meet you!", french="On travaille à la Guilde.[K]\nEnchantés de vous connaître!", german="Wir arbeiten für die Gilde.[K]\nFreut uns sehr, dich zu treffen!", italian=" È un onore per noi conoscerla!", spanish="Trabajamos en el [CS:N]Pokégremio[CR].[K]\n¡Es un placer conocerte!"})
  else
  SkySceneKit.say({english="We work at the guild.[K]\nWe're pleased to meet you!", french="On travaille à la Guilde.[K]\nQuel honneur de vous connaître!", german="Wir arbeiten für die Gilde.[K]\nEs freut uns sehr, dich zu treffen!", italian=" È un onore per noi conoscerla!", spanish="Trabajamos en el [CS:N]Pokégremio[CR].[K]\n¡Es un placer conocerte!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So what are you doing in town,\n[CS:N]Dusknoir[CR], sir? Shopping?", french="Alors, qu'est-ce que vous faites\nen ville, messire [CS:N]Noctunoir[CR]? Des courses?", german="Was machst du denn in der\nStadt, [CS:N]Zwirrfinst[CR]? Einkaufen?", italian="Cosa la porta qui in centro,\nsignor [CS:N]Dusknoir[CR]? Fa un po' di compere?", spanish="¿Y qué te ha traído a la aldea,\n[CS:N]Dusknoir[CR]? ¿Has venido a hacer compras?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So what are you doing in town,\n[CS:N]Dusknoir[CR], sir? Shopping?", french="Alors, qu'est-ce que vous faites\nen ville, messire [CS:N]Noctunoir[CR]? Des courses?", german="Was machst du denn in der\nStadt, [CS:N]Zwirrfinst[CR]? Einkaufen?", italian="Cosa la porta qui in centro,\nsignor [CS:N]Dusknoir[CR]? Sta forse facendo acquisti?", spanish="¿Y qué te ha traído a la aldea,\n[CS:N]Dusknoir[CR]? ¿Has venido a hacer compras?"})
  else
  SkySceneKit.say({english="So what are you doing in town,\n[CS:N]Dusknoir[CR], sir? Some shopping?", french="Alors, qu'est-ce que vous faites\nen ville, messire [CS:N]Noctunoir[CR]? Des courses?", german="Was machst du denn in der\nStadt, [CS:N]Zwirrfinst[CR]? Einkaufen?", italian="Cosa la porta qui in centro,\nsignor [CS:N]Dusknoir[CR]? Sta forse facendo acquisti?", spanish="¿Y qué te ha traído a la aldea,\n[CS:N]Dusknoir[CR]? ¿Has venido a hacer compras?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" No, no. Simply enjoying a chat!", french="Non, non. Je devise un peu,\nvoilà tout!", german="Nein, nein. Ich halte nur einen\ngemütlichen Plausch!", italian="No, niente di tutto questo. Stavo\nsemplicemente discorrendo.", spanish="No, qué va. Tan solo estaba\ndisfrutando de una tranquila charla."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="I hailed him down! The great\n[CS:N]Dusknoir[CR] is so very famous.", french="Je l'ai hélé de loin! Le grand\n[CS:N]Noctunoir[CR] est une telle célébrité.", german="Ich habe ihn sozusagen hier\nfestgenagelt! Der große [CS:N]Zwirrfinst[CR] ist ja eine\nsolche Berühmtheit.", italian="Sono io che gli ho attaccato un\nbottone senza fine! Sono un fan sfegatato del\ngrande [CS:N]Dusknoir[CR].", spanish="Fui yo quien le pedí que se\nacercara al verlo pasar. El gran [CS:N]Dusknoir[CR]\nes muy famoso."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kakureon1, 4) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="We started a conversation![K]\nAnd what a surprising talk!", french="Et on s'est mis à discuter![K]\nEt quelle discussion!", german="Wir fingen an, uns zu\nunterhalten![K] Es war ein erstaunliches\nGespräch!", italian="E come immaginavo...[K] il mio\neroe è un artista della parola!", spanish="Entonces nos pusimos a hablar. [K]\n¡Y qué charla tan sorprendente!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="The great [CS:N]Dusknoir[CR] is so worldly\nand wise. I'm thoroughly impressed!", french="Le grand [CS:N]Noctunoir[CR] est si\nexpérimenté et si sage! C'est stupéfiant!", german="Der große [CS:N]Zwirrfinst[CR] ist so\nwortgewandt und weise. Ich bin äußerst\nbeeindruckt!", italian="Il sommo [CS:N]Dusknoir[CR] sa proprio\ntutto! Che grande conversatore!", spanish="El gran [CS:N]Dusknoir[CR] sabe infinidad\nde cosas de todo tipo. Verdaderamente, me\nha dejado impresionado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Sounds like the rumors are true!", french="Il semblerait que la rumeur\ndise vrai!", german="Hört sich an, als würden die\nGerüchte stimmen.", italian="Allora quello che si dice in giro\nè vero!", spanish="Parece que los rumores son\nciertos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I guess the rumors are true!", french="Il semblerait que la rumeur\ndise vrai!", german=" Die Gerüchte sind wohl wahr!", italian="Allora quello che si dice in giro\nè vero!", spanish="Supongo que los rumores son\nciertos."})
  else
  SkySceneKit.say({english="Well, it certainly sounds like the\nrumors are true!", french="Il semblerait que la rumeur\ndise vrai!", german="Tja, es hört sich ganz so an, als\nwürden die Gerüchte stimmen!", italian="Allora quello che si dice in giro\nè vero!", spanish="Bueno, por lo que se ve los\nrumores son ciertos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Dusknoir[CR], sir, you really must be\nas smart as they say!", french="Messire [CS:N]Noctunoir[CR], vous devez\nvraiment être aussi brillant qu'on le dit!", german="[CS:N]Zwirrfinst[CR], du musst\nwirklich so schlau sein, wie alle sagen!", italian="Signor [CS:N]Dusknoir[CR], lei è veramente\nun pozzo di scienza!", spanish="[CS:N]Dusknoir[CR], ¡eres, sin duda,\ntan listo como dicen!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Dusknoir[CR], sir, you really must be\nas knowledgeable as they say!", french="Messire [CS:N]Noctunoir[CR], vous devez\nvraiment être aussi brillant qu'on le dit!", german="[CS:N]Zwirrfinst[CR], du musst\nwirklich so klug sein, wie alle sagen!", italian="Signor [CS:N]Dusknoir[CR], lei è veramente\nun pozzo di scienza!", spanish="[CS:N]Dusknoir[CR], ¡eres, sin duda,\ntan erudito como dicen!"})
  else
  SkySceneKit.say({english="[CS:N]Dusknoir[CR], sir, you really must be\nas knowledgeable as they say!", french="Messire [CS:N]Noctunoir[CR], vous devez\nvraiment être aussi brillant qu'on le dit!", german="[CS:N]Zwirrfinst[CR], du musst\nwirklich so klug sein, wie alle sagen!", italian="Signor [CS:N]Dusknoir[CR], lei è veramente\nun pozzo di scienza!", spanish="[CS:N]Dusknoir[CR], ¡eres, sin duda,\ntan erudito como dicen!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="May I ask, [partner], what I\ncan do for you?", french="Que puis-je faire pour toi,\n[partner]?", german="Darf ich fragen, [partner],\nwas ich für euch tun kann?", italian="[partner], siete qui per\nqualche ragione particolare?", spanish="Y bien, [partner]...\n¿En qué puedo ayudarle?"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="Have you come to shop? Oh, yes!\nFine merchandise! ♪ Fine wares! ♪", french="Tu as des achats à faire?\nBien sûr! Chez Kecleon, y'a tout c'qui est\nbon! ♪", german="Wollt ihr etwas kaufen? Oh ja!\nWir haben gute Waren! ♪ Gute Waren! ♪", italian="Volete fare spese? Sììì!\nGrandi articoli! ♪ Grande convenienza! ♪", spanish="¿Ha venido a comprar? ¡Claro!\n¡Tenemos la mejor mercancía! ♪\n¡Los mejores artículos! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Sorry, nope.[K] We're here to ask\nyou something today, not shop.", french="Non, désolé.[K] On a juste\nune question à te poser.", german="Leider nein.[K] Heute sind wir hier,\nweil wir eine Frage haben.", italian="Oggi no.[K] Siamo qui per\nchiedervi una cosa.", spanish="No, lo siento.[K] Hoy solo venimos\na preguntar algo, no a comprar."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Sorry, no.[K] We came to ask you\nsomething today, not shop.", french="Non, désolé.[K] On a juste\nune question à te poser.", german="Leider nein.[K] Heute sind wir hier,\nweil wir eine Frage haben.", italian="Scusaci, ma oggi no.[K] Siamo\nvenuti per chiedervi una cosa.", spanish="No, lo siento.[K] Hoy solo venimos\na preguntar algo, no a comprar."})
  else
  SkySceneKit.say({english="Sorry, no.[K] We came to ask you\nsomething today, not shop.", french="Non, désolée.[K] On a juste\nune question à te poser.", german="Leider nein.[K] Heute sind wir hier,\nweil wir eine Frage haben.", italian="Scusaci, ma oggi no.[K] Siamo\nvenuti per chiedervi una cosa.", spanish="No, lo siento.[K] Hoy solo venimos\na preguntar algo, no a comprar."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You see...", french=" Voilà...", german=" Wisst ihr...", italian=" Ecco...", spanish=" El caso es que..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You see...", french=" Voilà...", german=" Wisst ihr...", italian=" In breve...", spanish=" El caso es que..."})
  else
  SkySceneKit.say({english=" You see...", french=" Voilà...", german=" Wisst ihr...", italian=" In breve...", spanish=" El caso es que..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" Hmm...[K] I see...[K] Perfect Apples?", french="Hum...[K] Je vois...[K] Des Pommes\nParfaites?", german="Hmm...[K] Verstehe...[K]\nPerfekte Äpfel?", italian="Mmm...[K] Ah, sì, capisco...[K] Mele\nPerfette?", spanish="Hum...[K] Entiendo...[K]\n¿Manzanas Perfectas?"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon1, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="I am sorry to disappoint you.[K]\nWe have no plans to stock Perfect Apples.", french="Je suis vraiment désolé.[K]\nNous n'avons pas l'intention de vendre des\nPommes Parfaites.", german="Leider muss ich euch\nenttäuschen.[K] Wir haben nicht vor,\nPerfekte Äpfel zu verkaufen.", italian="Mi dispiace molto.[K] Non abbiamo\nin programma di vendere Mele Perfette.", spanish="Siento decepcionarles.[K]\nNo tenemos previsto vender Manzanas\nPerfectas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, OK. Too bad.", french=" Oh, d'accord. Dommage.", german=" Oh, okay. Schade.", italian=" Oh, ok. Peccato.", spanish=" Vaya... ¡Qué mala pata!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, all right. That's too bad.", french=" Oh, d'accord. Dommage.", german=" Oh, okay. Das ist schade.", italian=" Oh, che peccato.", spanish=" Vaya... No ha habido suerte."})
  else
  SkySceneKit.say({english=" Oh, OK. Too bad.", french=" Oh, d'accord. Dommage.", german=" Oh, okay. Schade.", italian=" Oh, che peccato.", spanish=" Vaya... ¡Qué mala pata!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Chatot[CR]'s going to be disappointed\nwhen he hears this...", french="[CS:N]Pijako[CR] va être déçu quand\nil saura ça...", german="[CS:N]Plaudagei[CR] wird enttäuscht sein,\nwenn er das hört...", italian="[CS:N]Chatot[CR] non sarà molto contento\ndi saperlo...", spanish="[CS:N]Chatot[CR] se va a llevar\nun chasco cuando se entere..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Chatot[CR] will be disappointed\nwith this news...", french="[CS:N]Pijako[CR] va être déçu quand\nil saura ça...", german="[CS:N]Plaudagei[CR] wird über diese\nNachricht enttäuscht sein...", italian="[CS:N]Chatot[CR] non sarà molto contento\ndi saperlo...", spanish="[CS:N]Chatot[CR] se va a llevar\nuna decepción cuando lo sepa..."})
  else
  SkySceneKit.say({english="[CS:N]Chatot[CR] will be disappointed\nwhen he hears this...", french="[CS:N]Pijako[CR] va être déçu quand\nil saura ça...", german="[CS:N]Plaudagei[CR] wird enttäuscht sein,\nwenn er das hört...", italian="[CS:N]Chatot[CR] non sarà molto contento\ndi saperlo...", spanish="[CS:N]Chatot[CR] se va a llevar\nuna decepción cuando lo sepa..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  local npc_npc_mariru = SkySceneKit.spawn_npc("marill", 160, 232, Direction.Right, "NPC_MARIRU")
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end) -- message_SetActor(ACTOR_NPC_MARIRU)
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" [CS:N]Azurill[CR], hurry!", french=" [CS:N]Azurill[CR], grouille-toi!", german=" [CS:N]Azurill[CR], beeil dich!", italian=" [CS:N]Azurill[CR], sbrigati!", spanish=" ¡[CS:N]Azurill[CR], rápido!"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_ruriri = SkySceneKit.spawn_npc("azurill", 120, 232, Direction.Right, "NPC_RURIRI")
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end) -- message_SetActor(ACTOR_NPC_RURIRI)
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Wait for me!", french=" Attends-moi!", german=" Warte auf mich!", italian=" Aspettami fratellone!", spanish=" ¡Espérame!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_mariru, 352, 228, false, 2)
  GROUND:MoveToPosition(npc_npc_ruriri, 324, 228, false, 2)
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon1, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Down)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GROUND:EntTurn(npc_npc_kakureon1, Direction.Down)
  GROUND:EntTurn(npc_npc_kakureon2, Direction.Down)
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="The [CS:N]Marill[CR] and [CS:N]Azurill[CR] brothers!\nWell, hello to you both!", french="Les frères [CS:N]Marill[CR] et [CS:N]Azurill[CR]!\nBien le bonjour!", german="Die Brüder [CS:N]Marill[CR] und [CS:N]Azurill[CR]!\nNa? Hallo, ihr beiden!", italian="Oh guarda! [CS:N]Marill[CR] e [CS:N]Azurill[CR]!\nBeh, buongiorno a voi!", spanish="Los hermanos [CS:N]Marill[CR] y [CS:N]Azurill[CR].\nVaya, ¡hola a los dos!"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_mariru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_mariru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_ruriri, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  pcall(function() SOUND:PlayBGM("Heartwarming.ogg", true) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Oh! Hi, [CS:N]Kecleon[CR] brothers!", french=" Oh! Salut, les frères [CS:N]Kecleon[CR]!", german=" Oh! Hallo, Brüder [CS:N]Kecleon[CR]!", italian="Oh! Buongiorno a voi, fratelli\n[CS:N]Kecleon[CR]!", spanish=" ¡Ah! ¡Hola, señores [CS:N]Kecleon[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Oh! And Team [team:] too!", french="Oh! L'Equipe [team:] est là\naussi!", german="Oh! Und Team [team:] ist\nauch da!", italian="Oh! E anche a voi, Team\n[team:]!", spanish="¡Vaya! ¡Y también está aquí\nel [CS:X]Equipo[CR] [team:]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, -4) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What's up? What's the big rush?", french="Qu'est-ce qui se passe? Pourquoi\nvous êtes si pressés?", german=" Was ist los? Warum die Eile?", italian="Che si dice? Come mai tanta\nfretta?", spanish="¿Qué pasa?\n¿Adónde vais con tanta prisa?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What's up? What's the rush?", french="Qu'est-ce qui se passe? Pourquoi\nvous êtes si pressés?", german=" Was ist los? Warum so eilig?", italian=" Come va? Dove correte di bello?", spanish="¿Qué pasa?\n¿Adónde vais con tanta prisa?"})
  else
  SkySceneKit.say({english=" What's up? What's the big rush?", french="Qu'est-ce qui se passe? Pourquoi\nvous êtes si pressés?", german=" Was ist los? Warum die Eile?", italian="Come state? Dove andate di\nbello?", spanish="¿Qué pasa?\n¿Adónde vais con tanta prisa?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="You know how we've been\nlooking for our lost item?", french="Vous savez qu'on a perdu\nun objet? Eh bien, on tient une piste!", german="Erinnert ihr euch an das\nverlorene Item, das wir suchen?", italian="Ricordi che abbiamo smarrito\nuno strumento?", spanish="¿Recordáis que estábamos\nbuscando un objeto que habíamos perdido?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, -4) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Lost item? You mean the same\none you were looking for before?", french="Un objet perdu? Celui que\nvous cherchiez déjà la dernière fois?", german="Verlorenes Item? Meinst du\ndasselbe Item, das ihr das letzte Mal\ngesucht habt?", italian="Uno strumento? Vuoi dire quello\nche stavate cercando prima?", spanish="¿Aquel objeto? ¿Pero todavía\nno lo habéis encontrado?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Lost item? Do you mean the\nsame one you were looking for before?", french="Un objet perdu? Celui que\nvous cherchiez déjà la dernière fois?", german="Verlorenes Item? Meinst du\ndasselbe Item, das ihr das letzte Mal\ngesucht habt?", italian="Uno strumento? Intendi dire\nquello che stavate cercando prima?", spanish="¿Aquel objeto? ¿Pero todavía\nno lo habéis encontrado?"})
  else
  SkySceneKit.say({english="Lost item? Do you mean the\nsame one you were looking for before?", french="Un objet perdu? Celui que\nvous cherchiez déjà la dernière fois?", german="Verlorenes Item? Meinst du\ndasselbe Item, das ihr das letzte Mal\ngesucht habt?", italian="Uno strumento? Intendi dire\nquello che stavate cercando prima?", spanish="¿Aquel objeto? ¿Pero todavía\nno lo habéis encontrado?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Yes! An item called [CS:Z]Water Float[CR]!", french="Oui! C'est un objet qui s'appelle\n[CS:Z]Hydroflotteur[CR]!", german=" Ja! Unseren [CS:Z]Schwimmreif[CR]!", italian="Proprio quello! Si chiama\n[CS:Z]Acquaboa[CR]!", spanish="No, todavía no. Se trata de\nnuestro [CS:Z]Flotarill[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="A [CS:Z]Water Float[CR]? Now that is\nquite the precious item!", french="Un [CS:Z]Hydroflotteur[CR]?\nEn voilà un objet fort précieux!", german="Ein [CS:Z]Schwimmreif[CR]? Das ist\naber ein ziemlich kostbares Item!", italian="Un'[CS:Z]Acquaboa[CR], dite? Si tratta di\nuno strumento davvero raro!", spanish="¿Un [CS:Z]Flotarill[CR]?\nVaya, ese es un objeto bastante valioso."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_mariru, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="Yes! That's why we've been\nlooking hard for it a long time.", french="Oui! C'est pour ça que ça fait\nsi longtemps qu'on le cherche.", german="Ja! Darum suchen wir schon\nsehr lange verzweifelt danach.", italian="Sì! È per questo che l'abbiamo\ncercato dappertutto!", spanish="¡Así es! Por eso lo estamos\nbuscando por todas partes."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english="And then! Someone said they saw\na [CS:Z]Water Float[CR] on the beach today!", french="Et aujourd'hui, quelqu'un a dit\navoir vu un [CS:Z]Hydroflotteur[CR] sur la plage!", german="Und dann hat jemand gesagt,\ndass er heute am Strand einen [CS:Z]Schwimmreif[CR]\ngesehen hat!", italian="Ma finalmente qualcuno oggi ha\ndetto di aver visto un'[CS:Z]Acquaboa[CR] sulla spiaggia!", spanish="¡Sí! Y alguien nos ha dicho hoy\nque ha visto un [CS:Z]Flotarill[CR] en la playa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" We're rushing to the beach now!", french="C'est pour ça qu'on court,\non va à la plage!", german="Jetzt laufen wir so schnell\nwir können zum Strand!", italian="E stiamo correndo proprio lì,\nadesso!", spanish=" ¡Ahora mismo íbamos hacia allá!"})
  -- message_Close
  -- supervision_Acting(1) [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(90) end) -- bgm_ChangeVolume vers 0 (silence)
  pcall(function() GAME:MoveCamera(440, 212, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 520, 232, Direction.Left, "NPC_ZUBATTO")
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 520, 208, Direction.Left, "NPC_DOGAASU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, npc_npc_dogaasu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogaasu, npc_npc_zubatto, 4) end)
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Heh-heh-heh! Juicy tidbit!", french=" Hin hin hin! Intéressant!", german=" Hehehe! Reizende Kerlchen!", italian="Eh-eh-eh! Che informazione\nsuccosa!", spanish="¡Jue, jue, jue!\nFíjate tú de lo que me acabo de enterar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Whoa-ho-ho! Could be useful for\nour plan!", french="Mouarf mouarf mouarf!\nÇa pourrait nous être utile!", german="Whoahoho! Könnten für unseren\nPlan nützlich sein!", italian="Uooh-oh-oh! Potrebbe essere\nutile al nostro piano!", spanish="¡Jo, jo, jo!\nPodría ser útil para nuestro plan."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="We'll bring the Chief up to\nspeed, then get the jump on them.", french="Mettons le chef au parfum.\nEnsuite, on pourra leur tomber dessus.", german="Wir erzählen es dem Boss und\ngehen dann hinterher!", italian="Andiamo a dirlo al capo e poi\ngliela sgraffigniamo!", spanish="Informaremos al Jefe sobre\nesto, y luego les sacaremos ventaja."})
  -- message_Close
  do local p=npc_npc_zubatto.Position; GROUND:MoveToPosition(npc_npc_zubatto, p.X+(48), p.Y+(0), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_dogaasu.Position; GROUND:MoveToPosition(npc_npc_dogaasu, p.X+(48), p.Y+(0), false, 2) end
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  -- bgm_ChangeVolume(90,255) [volume BGM non scriptable en Lua PMDO: piste maintenue - documenté]
  pcall(function() GAME:MoveCamera(336, 212, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  -- message_FacePositionOffset(1, -4) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's awesome! It's great that\nit's finally turned up!", french="C'est super que vous l'ayez enfin\nretrouvé!", german="Das ist ja toll! Wie schön, dass\ner endlich aufgetaucht ist!", italian="Benissimo! Finalmente è saltata\nfuori!", spanish="¡Estupendo! ¡Qué bien que\npor fin haya aparecido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's excellent! It's great that\nit's finally turned up!", french="C'est super que vous l'ayez enfin\nretrouvé!", german="Das ist ja großartig! Wie schön,\ndass er endlich aufgetaucht ist!", italian="Bene! Per fortuna alla fine è\nsaltata fuori!", spanish="¡Eso es estupendo! ¡Qué bien\nque por fin haya aparecido!"})
  else
  SkySceneKit.say({english="That's super! It's great that it's\nfinally turned up!", french="C'est super que vous l'ayez enfin\nretrouvé!", german="Das ist ja super! Wie schön,\ndass er endlich aufgetaucht ist!", italian="Bene! Per fortuna alla fine è\nsaltata fuori!", spanish="¡Eso es genial! ¡Qué bien que\npor fin haya aparecido!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(npc_npc_mariru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Yes!", french=" Oui!", german=" Ja!", italian=" Sì!", spanish=" ¡Sí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Yep!", french=" Ouaip!", german=" Jep!", italian=" Evviva!", spanish=" ¡Sí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, npc_npc_ruriri, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_ruriri, npc_npc_mariru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Come on, [CS:N]Azurill[CR]! Let's go quick!", french="Allez, [CS:N]Azurill[CR]! Pas une minute\nà perdre!", german="Komm schon, [CS:N]Azurill[CR]!\nBeeilen wir uns!", italian="Andiamo, [CS:N]Azurill[CR]! Facciamo\npresto!", spanish=" ¡Vamos, [CS:N]Azurill[CR]! ¡Démonos prisa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Yep!", french=" Ouaip!", german=" Jep!", italian=" Sì!", spanish=" ¡Sí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_mariru, 536, 228, false, 2)
  GROUND:MoveToPosition(npc_npc_ruriri, 536, 228, false, 2)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Right)
  GROUND:EntTurn(npc_npc_kakureon1, Direction.Right)
  GROUND:EntTurn(npc_npc_kakureon2, Direction.Right)
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I was wondering how those little\nbrothers were doing with their item search.", french="Je me demandais justement où\nils en étaient avec leurs recherches.", german="Ich habe mich schon gefragt,\nwie die beiden kleinen Brüder mit ihrer\nSuche nach dem Item vorankommen.", italian="Mi stavo giusto chiedendo come\nprocedeva la loro ricerca dello strumento\nperduto.", spanish="Lo cierto es que me preguntaba\nsi habrían encontrado ya ese objeto."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I was wondering how those little\nbrothers were doing with their item search.", french="Je me demandais justement où\nils en étaient avec leurs recherches.", german="Ich habe mich schon gefragt,\nwie die beiden kleinen Brüder mit ihrer\nSuche nach dem Item vorankommen.", italian="Mi stavo giusto chiedendo come\nprocedeva la loro ricerca dello strumento\nperduto.", spanish="Lo cierto es que me preguntaba\nsi habrían encontrado ya ese objeto."})
  else
  SkySceneKit.say({english="I was wondering how those little\nbrothers were doing with their item search.", french="Je me demandais justement où\nils en étaient avec leurs recherches.", german="Ich habe mich schon gefragt,\nwie die beiden kleinen Brüder mit ihrer\nSuche nach dem Item vorankommen.", italian="Mi stavo giusto chiedendo come\nprocedeva la loro ricerca dello strumento\nperduto.", spanish="Lo cierto es que me preguntaba\nsi habrían encontrado ya ese objeto."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kakureon1, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kakureon2, hero, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Good for them. Looks like\nthey've found it.", french="On dirait qu'ils l'ont retrouvé.\nTant mieux pour eux.", german="Freut mich für sie. Wie es\naussieht, haben sie es gefunden.", italian="Sembra che l'abbiano trovato.\nBuon per loro.", spanish="Me alegro por ellos.\nParece que por fin lo han encontrado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Good for them. Looks like\nthey've found it.", french="On dirait qu'ils l'ont retrouvé.\nTant mieux pour eux.", german="Freut mich für sie. Wie es\naussieht, haben sie es gefunden.", italian="Sembra che l'abbiano trovato.\nBuon per loro.", spanish="Me alegro por ellos.\nParece que por fin lo han encontrado."})
  else
  SkySceneKit.say({english="Good for them. Looks like\nthey've found it.", french="On dirait qu'ils l'ont retrouvé.\nTant mieux pour eux.", german="Freut mich für sie. Wie es\naussieht, haben sie es gefunden.", italian="Sembra che l'abbiano trovato.\nBuon per loro.", spanish="Me alegro por ellos.\nParece que por fin lo han encontrado."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kakureon1, npc_npc_yonowaaru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="I've never heard of a\n[CS:Z]Water Float[CR].", french="Je n'ai jamais entendu parler\nd'un [CS:Z]Hydroflotteur[CR].", german="Ich habe noch nie etwas von\neinem [CS:Z]Schwimmreif[CR] gehört.", italian="Non ho mai sentito nominare\nquest'[CS:Z]Acquaboa[CR].", spanish="Nunca había oído hablar de\nningún [CS:Z]Flotarill[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" What purpose does it serve?", french=" A quoi ça sert?", german=" Für was ist so etwas gut?", italian=" A cosa serve?", spanish=" ¿Para qué sirve?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru, npc_npc_kakureon1, 4) end)
  GROUND:EntTurn(npc_npc_kakureon2, Direction.DownLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="A [CS:Z]Water Float[CR] is an item\nspecifically for [CS:N]Azurill[CR].", french="L'[CS:Z]Hydroflotteur[CR] est un objet\nconçu spécialement pour [CS:N]Azurill[CR].", german="Ein [CS:Z]Schwimmreif[CR] ist ein Item,\ndas speziell für [CS:N]Azurill[CR] gedacht ist.", italian="Un'[CS:Z]Acquaboa[CR] è uno strumento che\nsolo [CS:N]Azurill[CR] può usare.", spanish="Los [CS:Z]Flotarill[CR] son objetos\nespecíficos para [CS:N]Azurill[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="It can be obtained only by\ntrading precious treasures again and again.", french="On ne peut l'obtenir qu'après\navoir échangé de nombreux trésors de grande\nvaleur.", german="Man kann es nur bekommen,\nindem man immer wieder kostbare Schätze\neintauscht.", italian="Per ottenerne uno è necessario\ndare in cambio molti tesori rari e preziosi.", spanish="Solo se pueden conseguir\nintercambiando muchos tesoros."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="As such, it is said to be an\nexceedingly rare item.", french="C'est pourquoi on dit qu'il s'agit\nd'un objet extrêmement rare.", german="Daher soll es ein ausgesprochen\nseltenes Item sein.", italian="È per questo che si tratta di uno\nstrumento rarissimo.", spanish="Por eso, se dice que es un objeto\nrealmente difícil de conseguir."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" Gah! Is that so?", french=" Ah bon?", german=" Ahaaa! Tatsächlich?", italian=" Oh! Davvero?", spanish=" ¡Vaya! ¿En serio?"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="Our line of work is buying and\nselling! But we have never heard of it.[K] It must\nbe exceedingly rare!", french="Nous faisons du commerce\ndepuis longtemps et nous n'en avons jamais\nentendu parler.[K] Il doit être très rare!", german="Unser Geschäft ist der Handel\nmit Items, aber davon haben wir noch nie\ngehört.[K] Es muss sehr selten sein!", italian="Il nostro lavoro è proprio quello\ndi vendere e comprare strumenti! Eppure non\nl'abbiamo mai sentito.[K] Dev'essere rarissimo!", spanish="Nosotros nos ganamos la vida\ncomerciando y nunca habíamos oído hablar\nde él.[K] ¡Tiene que ser realmente raro!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="To sell such a rare item![K]\nI'm afraid such a day will never come.", french="Ah, vendre un objet pareil![K] Si\nseulement! J'ai bien peur que cela n'arrive\njamais.", german="Ein so seltenes Item zu\nverkaufen![K] Das wird uns wohl niemals\nvergönnt sein.", italian="Che colpaccio sarebbe se\nriuscissimo a vendere uno strumento del\ngenere![K] Temo che quel giorno non verrà mai.", spanish="Ya me gustaría a mí vender\nun objeto tan raro...[K] Pero me temo que no\nhabrá manera."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="To sell...?[K] Hey, I just\nremembered!", french=" Vendre...?[K] Eh, j'allais oublier!", german="Zu verkaufen?[K] Hey, da fällt\nmir etwas ein!", italian="Vendere, eh? Ehi![K] Aspetta un\nmomento! Ora che mi ricordo...", spanish=" ¿Vender...?[K] Ah, ¡se me olvidaba!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="To sell...?[K] Oh, I just\nremembered!", french=" Vendre...?[K] Eh, j'allais oublier!", german="Zu verkaufen?[K] Hey, da fällt\nmir etwas ein!", italian="Vendere...?[K] Ah già! Quasi\ndimenticavo!", spanish=" ¿Vender...?[K] Ah, ¡se me olvidaba!"})
  else
  SkySceneKit.say({english="To sell...?[K] Oh, no! I just\nremembered!", french=" Vendre...?[K] Eh, j'allais oublier!", german="Zu verkaufen?[K] Hey, da fällt\nmir etwas ein!", italian="Vendere...?[K] Ah, già! Quasi\ndimenticavo!", spanish=" ¿Vender...?[K] Ah, ¡se me olvidaba!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kakureon1, partner, 4) end)
  GROUND:EntTurn(npc_npc_kakureon2, Direction.Down)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to report back to\n[CS:N]Chatot[CR] about the Perfect Apples!", french="Il faut qu'on prévienne [CS:N]Pijako[CR]\npour les Pommes Parfaites!", german="Wir müssen [CS:N]Plaudagei[CR] noch\nwegen der Perfekten Äpfel Bescheid geben!", italian="Dobbiamo andare da [CS:N]Chatot[CR] a\ndirgli delle Mele Perfette!", spanish="Tenemos que informar a [CS:N]Chatot[CR]\nsobre las Manzanas Perfectas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to report back to\n[CS:N]Chatot[CR] about the Perfect Apples!", french="Il faut qu'on prévienne [CS:N]Pijako[CR]\npour les Pommes Parfaites!", german="Wir müssen [CS:N]Plaudagei[CR] noch\nwegen der Perfekten Äpfel Bescheid geben!", italian="Dobbiamo andare da [CS:N]Chatot[CR] a\ndirgli delle Mele Perfette!", spanish="Tenemos que informar a [CS:N]Chatot[CR]\nsobre las Manzanas Perfectas."})
  else
  SkySceneKit.say({english="We have to report back to\n[CS:N]Chatot[CR] about the Perfect Apples!", french="Il faut qu'on prévienne [CS:N]Pijako[CR]\npour les Pommes Parfaites!", german="Wir müssen [CS:N]Plaudagei[CR] noch\nwegen der Perfekten Äpfel Bescheid geben!", italian="Dobbiamo andare da [CS:N]Chatot[CR] a\ndirgli delle Mele Perfette!", spanish="Tenemos que informar a [CS:N]Chatot[CR]\nsobre las Manzanas Perfectas."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's race back to the guild!", french=" Retournons vite à la Guilde!", german="Laufen wir schnell zurück zur\nGilde!", italian=" Torniamo subito alla Gilda!", spanish="¡Volvamos al [CS:N]Pokégremio[CR] cuanto\nantes!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go back to the guild!", french=" Retournons vite à la Guilde!", german=" Gehen wir zurück zur Gilde!", italian=" Torniamo subito alla Gilda!", spanish="¡Volvamos al [CS:N]Pokégremio[CR] cuanto\nantes!"})
  else
  SkySceneKit.say({english=" Hurry! Back to the guild!", french=" Retournons vite à la Guilde!", german=" Schnell! Zurück zur Gilde!", italian=" Torniamo subito alla Gilda!", spanish="¡Volvamos al [CS:N]Pokégremio[CR] cuanto\nantes!"})
  end
  -- message_Close
  GAME:FadeOut(false,  60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:WaitFrames(45)
  SkySceneKit.cleanup_npcs()
end
