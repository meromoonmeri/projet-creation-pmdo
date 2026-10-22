-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D51P11A/enter07.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 113 or __sw == 114 then
  -- @label_12 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 117 then
  if (SkyProg.cmp_side(47, 5) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [47, 5]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" .............", french=" .........", german=" .........", italian=" .............", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...[K] (I have no idea what's on his\nmind, as usual...)", french="...[K] (Comme toujours, j'ignore ce\nqu'il a à l'esprit...)", german="...[K](Schon wieder kann ich mir\nnicht erklären, was in ihm vorgeht...)", italian="...[K] (Come al solito non ho idea di\ncosa gli passi per la testa...)", spanish="(Para variar...[K] no tengo ni la\nmenor idea de qué le pasa por la cabeza...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(Anyway...[K]if I only knew why\nthe [CS:N]Sableye[CR] suddenly came to attack...)", french="(Quoi qu'il en soit...[K] si seulement\nje savais pourquoi les [CS:N]Ténéfix[CR] ont\nsoudainement attaqué...)", german="(Wie auch immer...[K] Wenn ich\nnur wüsste, warum die [CS:N]Zobiris[CR] so plötzlich\nangriffen...)", italian="(Comunque...[K] se solo sapessi\nperché i [CS:N]Sableye[CR] ci hanno attaccato così\nimprovvisamente...)", spanish="(Si tan solo supiera...[K] por qué\nle atacaron de repente los [CS:N]Sableye[CR]...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(It would be clear whether he\nremains my ally...)", french="(... je pourrais deviner plus\nfacilement s'il entend rester de mon côté...)", german="(Dann könnte ich mir sicher\nsein, ob er auf meiner Seite steht...)", italian="(... riuscirei a capire se è\nveramente dalla mia parte...)", spanish="(Quedaría claro si sigue siendo\nmi aliado...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(Or if he were to change sides\nagain and become my enemy...)", french="(... ou changer de camp\nà nouveau et redevenir mon ennemi...)", german="(Oder ob er noch mal die Seiten\nwechseln und abermals mein Feind wird...)", italian="(... o se sta meditando di\ntradirmi e diventare mio nemico...)", spanish="(O si pretende volver a cambiar\nde bando y convertirse en mi enemigo...)"})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" ..............", french=" .........", german=" .........", italian=" ..............", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...[K] (I have no idea what's on his\nmind, as usual...)", french="...[K] (Comme toujours, j'ignore ce\nqu'il a à l'esprit...)", german="...[K](Schon wieder kann ich mir\nnicht erklären, was in ihm vorgeht...)", italian="...[K] (Come al solito non ho idea di\ncosa gli passi per la testa...)", spanish="(Para variar...[K] no tengo ni la\nmenor idea de qué le pasa por la cabeza...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(Anyway...[K]if I only knew why\nthe [CS:N]Sableye[CR] suddenly came to attack...)", french="(Quoi qu'il en soit...[K] si seulement\nje savais pourquoi les [CS:N]Ténéfix[CR] ont\nsoudainement attaqué...)", german="(Wie auch immer...[K] Wenn ich\nnur wüsste, warum die [CS:N]Zobiris[CR] so plötzlich\nangriffen...)", italian="(Comunque...[K] se solo sapessi\nperché i [CS:N]Sableye[CR] ci hanno attaccato così\nimprovvisamente...)", spanish="(Si tan solo supiera...[K] por qué\nle atacaron de repente los [CS:N]Sableye[CR]...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(It would be clear whether he\nremains my ally...)", french="(... je pourrais deviner plus\nfacilement s'il entend rester de mon côté...)", german="(Dann könnte ich mir sicher\nsein, ob er auf meiner Seite steht...)", italian="(... riuscirei a capire se è\nveramente dalla mia parte...)", spanish="(Quedaría claro si sigue siendo\nmi aliado...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(Or if he were to change sides\nagain and become my enemy...)", french="(... ou changer de camp\nà nouveau et redevenir mon ennemi...)", german="(Oder ob er noch mal die Seiten\nwechseln und abermals mein Feind wird...)", italian="(... o se sta meditando di\ntradirmi e diventare mio nemico...)", spanish="(O si pretende volver a cambiar\nde bando y convertirse en mi enemigo...)"})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 118 then
  if (SkyProg.cmp_side(47, 6) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [47, 6]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Anyway, we must reach the\npinnacle so I can see for myself...", french="Quoi qu'il en soit, nous devons\natteindre le pinacle pour que je puisse\nme faire une idée par moi-même...", german="So oder so müssen wir die\nKuppel erreichen, damit ich das selbst\nherausfinden kann...", italian="In ogni caso dobbiamo\nraggiungere la vetta, solo così potrò capire...", spanish="En fin, debemos llegar a la cima\npara poder ver por mí mismo..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Master [CS:N]Dialga[CR]'s true intentions...", french="... des véritables intentions\nde Maître [CS:N]Dialga[CR].", german="Die wahren Absichten von\nMeister [CS:N]Dialga[CR]...", italian="... quali sono le vere intenzioni\ndel Maestro [CS:N]Dialga[CR]...", spanish="Cuáles son las auténticas\nintenciones de [CS:N]Dialga[CR]..."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I haven't been here in a\nwhile either.", french="Ça fait un moment que je ne\nsuis pas venu ici, moi aussi.", german="Auch ich war eine ganze Weile\nnicht mehr hier.", italian="Anch'io non vengo qui da\nparecchio tempo.", spanish="Hace tiempo que yo tampoco\nvengo por aquí."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Anyway, I need to find Master\n[CS:N]Dialga[CR] and ask...", french="Quoi qu'il en soit, je dois trouver\nMaître [CS:N]Dialga[CR] et lui demander...", german="Wie auch immer. Ich muss\nMeister [CS:N]Dialga[CR] finden...", italian="In ogni caso, devo trovare\nil Maestro [CS:N]Dialga[CR] e parlargli...", spanish="En cualquier caso, debo hallar al\nmaestro [CS:N]Dialga[CR] y preguntarle..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" What his true intentions are...", french="... quelles sont ses\nvéritables intentions.", german="Ihn fragen, was er wirklich\nvorhat...", italian="Capire quali sono le sue vere\nintenzioni...", spanish="Cuáles son sus verdaderas\nintenciones..."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 119 then
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if (SkyProg.cmp_side(47, 8) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [47, 8]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="It's just a little farther to the\npinnacle...", french="Encore quelques efforts et nous\natteindrons le pinacle...", german="Bis zur Kuppel ist es nur noch\nein kleines Stück...", italian=" Manca poco alla vetta...", spanish="La cima no queda ya\ndemasiado lejos..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Don't even think I'm going to join\nyou in your fight against Master [CS:N]Dialga[CR].", french="Ne songe pas un instant que je\nte soutiendrai dans ton duel contre\nMaître [CS:N]Dialga[CR].", german="Denk gar nicht erst daran, dass\nich dich in deinem Kampf gegen Meister [CS:N]Dialga[CR]\nunterstützen werde.", italian="Non pensare nemmeno\nche mi unirò a te per lottare contro\nil Maestro [CS:N]Dialga[CR].", spanish="Ni se te ocurra pensar que me\nuniré a ti en tu lucha contra [CS:N]Dialga[CR]."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="You will fight Master [CS:N]Dialga[CR]...[K]\nAnd once you are defeated...", french="Tu affronteras Maître\n[CS:N]Dialga[CR] sans moi...[K]\nEt une fois que tu auras été vaincu...", german="Du wirst Meister [CS:N]Dialga[CR]\nherausfordern...[K] Und nach deiner Niederlage...", italian="Affronterai il Maestro [CS:N]Dialga[CR]...[K]\nE quando ti avrà sconfitto...", spanish="Lucharás contra [CS:N]Dialga[CR]...[K]\nY cuando te haya vencido..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I will simply ask Master [CS:N]Dialga[CR]\nhis true intentions.", french="Je demanderai simplement\nà Maître [CS:N]Dialga[CR] quelles sont ses\nvéritables intentions.", german="Da werde ich Meister [CS:N]Dialga[CR]\neinfach nach seinen wahren Absichten befragen.", italian="... gli chiederò quali sono\nle sue vere intenzioni.", spanish="Le preguntaré cuáles son\nsus auténticas intenciones."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I won't fight by your side on\nthe pinnacle.", french="Je ne me battrai pas\nà tes côtés sur le pinacle.", german="Ich werde in der Kuppel nicht an\ndeiner Seite kämpfen.", italian="Quando avremo raggiunto\nla vetta, non lotterò al tuo fianco.", spanish="No combatiré junto a ti\nen la cima."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="You will fight Master [CS:N]Dialga[CR]...[K]\nAnd once you are defeated...", french="Tu affronteras Maître\n[CS:N]Dialga[CR] sans moi...[K]\nEt une fois que tu auras été vaincu...", german="Du wirst Meister [CS:N]Dialga[CR]\nherausfordern...[K] Und nach deiner Niederlage...", italian="Affronterai il Maestro [CS:N]Dialga[CR]...[K]\nE quando ti avrà sconfitto...", spanish="Lucharás contra [CS:N]Dialga[CR]...[K]\nY cuando te haya vencido..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" I will ask Master [CS:N]Dialga[CR].", french="... je poserai ma question\nà Maître [CS:N]Dialga[CR].", german="Da werde ich Meister [CS:N]Dialga[CR]\nfragen.", italian=" ... parlerò con lui.", spanish=" Le preguntaré a [CS:N]Dialga[CR]."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 50 then
  if (SkyProg.cmp_side(47, 10) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [47, 10]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I wonder if we'll have to fight\nthe [CS:N]Sableye[CR] up ahead again.", french="Je me demande s'il nous faudra\nencore affronter les [CS:N]Ténéfix[CR] par la suite.", german="Ich frage mich, ob wir die\n[CS:N]Zobiris[CR] noch einmal bekämpfen müssen.", italian="Mi domando se più avanti\ndovremo affrontare di nuovo i [CS:N]Sableye[CR].", spanish="Me pregunto si tendremos que\nvolver a enfrentarnos a los [CS:N]Sableye[CR]."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="That would be best.[K]\nI need some sort of clue.", french="Ce serait une bonne chose.[K]\nIl me faut un début de réponse.", german="Das wäre am besten.[K]\nIch brauche einen Hinweis.", italian="A dirla tutta, è quello che spero.[K]\nHo bisogno di risposte.", spanish="Eso sería lo mejor.[K]\nNecesito tener alguna pista."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(47, 9) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [47, 9]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" It's probably too late.", french="Il est probablement\ndéjà trop tard.", german="Möglicherweise ist es bereits\nzu spät.", italian=" Probabilmente è troppo tardi.", spanish=" Probablemente ya sea tarde."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I've got nothing to do with\nwhatever happens to [CS:N]Celebi[CR].", french="Je n'ai rien à voir avec ce\nqui a pu arriver à [CS:N]Celebi[CR].", german="Was auch immer mit [CS:N]Celebi[CR]\npassiert, geht mich nichts an.", italian="Non ho niente a che fare con\nquello che può essere successo a [CS:N]Celebi[CR].", spanish="No tengo nada que ver en lo que\nvaya a sucederle a [CS:N]Celebi[CR]."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" It's probably too late.", french="Il est probablement\ndéjà trop tard.", german="Möglicherweise ist es bereits\nzu spät.", italian=" Probabilmente è troppo tardi.", spanish=" Probablemente ya sea tarde."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I've got nothing to do with\nwhatever happens to [CS:N]Celebi[CR].", french="Je n'ai rien à voir avec ce\nqui a pu arriver à [CS:N]Celebi[CR].", german="Was auch immer mit [CS:N]Celebi[CR]\npassiert, geht mich nichts an.", italian="Non ho niente a che fare con\nquello che può essere successo a [CS:N]Celebi[CR].", spanish="No tengo nada que ver en lo que\nvaya a sucederle a [CS:N]Celebi[CR]."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 121 then
  if (SkyProg.cmp_side(47, 11) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [47, 11]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="There are some [CS:N]Porygon[CR] ahead\nof here.", french="Il y a des [CS:N]Porygon[CR]\nun peu plus loin.", german=" Vor uns ist eine Gruppe [CS:N]Porygon[CR].", italian=" Più avanti ci sono dei [CS:N]Porygon[CR].", spanish="Hay algunos [CS:N]Porygon[CR]\nmás adelante."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I bet that the [CS:N]Porygon[CR] can guide\nus to the [CS:P]Frozen Island[CR].", french="J'imagine que ces [CS:N]Porygon[CR]\npourront nous guider jusqu'à l'[CS:P]Ile de Glace[CR].", german="Ich wette, die [CS:N]Porygon[CR] können\nuns zur [CS:P]Frostinsel[CR] führen.", italian="Scommetto che loro possono\nportarci sull'[CS:P]Isola Glaciale[CR].", spanish="Seguro que los [CS:N]Porygon[CR] pueden\nguiarnos hasta la [CS:P]Isla Helada[CR]."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="There are some [CS:N]Porygon[CR] ahead\nof here.", french="Il y a des [CS:N]Porygon[CR]\nun peu plus loin.", german=" Vor uns ist eine Gruppe [CS:N]Porygon[CR].", italian=" Più avanti ci sono dei [CS:N]Porygon[CR].", spanish="Hay algunos [CS:N]Porygon[CR]\nmás adelante."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I bet that the [CS:N]Porygon[CR] can guide\nus to the [CS:P]Frozen Island[CR].", french="J'imagine que ces [CS:N]Porygon[CR]\npourront nous guider jusqu'à l'[CS:P]Ile de Glace[CR].", german="Ich wette, die [CS:N]Porygon[CR] können\nuns zur [CS:P]Frostinsel[CR] führen.", italian="Scommetto che loro possono\nportarci sull'[CS:P]Isola Glaciale[CR].", spanish="Seguro que los [CS:N]Porygon[CR] pueden\nguiarnos hasta la [CS:P]Isla Helada[CR]."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 122 then
  if (SkyProg.cmp_side(48, 4) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [48, 4]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="At any rate, we'll need to pass\nthis pinnacle.", french="Quoi qu'il en soit, il nous faut\naller au-delà de ce pinacle.", german="Auf jeden Fall müssen wir diese\nKuppel passieren.", italian="In ogni caso, dobbiamo superare\nquesta vetta.", spanish="En cualquier caso, tendremos que\natravesar esta cima."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Once you're ready, we'll go.", french="Une fois que tu seras prêt,\nnous nous mettrons en route.", german=" Wir gehen, sobald du fertig bist.", italian=" Quando sei pronto, andiamo.", spanish=" Nos iremos cuando estés listo."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(48, 1) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [48, 1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="We should probably follow this\nroad to see where it leads.", french="Nous devrions probablement\nsuivre cette route et voir où elle nous mène.", german="Wir sollten diesem Weg folgen,\num zu sehen, wohin er führt.", italian="Forse dovremmo seguire questa\nstrada per vedere dove ci porta.", spanish="Creo que deberíamos seguir este\nsendero para ver adónde conduce."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="If we do that, we should be able\nto get a new grasp on things.", french="Ça devrait nous permettre\nd'y voir plus clair.", german="Wenn wir das tun, sollten wir zu\neiner neuen Sicht der Dinge gelangen.", italian="In questo modo potremmo\nfar luce su ciò che sta accadendo.", spanish="Si lo hacemos, probablemente\ndescubramos algo nuevo de todo esto."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="We should probably follow this\nroad to see where it leads.", french="Nous devrions probablement\nsuivre cette route et voir où elle nous mène.", german="Wir sollten diesem Weg folgen,\num zu sehen, wohin er führt.", italian="Forse dovremmo seguire questa\nstrada per vedere dove ci porta.", spanish="Creo que deberíamos seguir este\nsendero para ver adónde conduce."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I suspect the [CS:N]Sableye[CR] are\nstill laying traps, so we should proceed with\ncaution.", french="Je soupçonne les [CS:N]Ténéfix[CR]\nde nous préparer d'autres embûches,\nalors procédons avec méfiance.", german="Ich vermute, die [CS:N]Zobiris[CR] legen\nimmer noch Fallen, also lass uns weiterhin\nvorsichtig sein.", italian="Meglio procedere con cautela,\nho il sospetto che i [CS:N]Sableye[CR] cercheranno\ndi metterci ancora i bastoni tra le ruote.", spanish="Sospecho que los [CS:N]Sableye[CR] siguen\nponiendo trampas, así que deberíamos\nir con cautela."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 123 then
  if (SkyProg.cmp_side(48, 4) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [48, 4]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="We need to get over there, at\nany rate.", french="Il faut que nous allions là-bas,\ncoûte que coûte.", german="Wir müssen dort hinüber, um\njeden Preis.", italian="Dobbiamo raggiungere la vetta,\ncosti quel che costi.", spanish="En cualquier caso, tenemos que\nllegar hasta allí."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Once you're ready, we'll go.", french="Une fois que tu seras prêt,\nnous nous mettrons en route.", german=" Wir gehen, sobald du fertig bist.", italian=" Quando sei pronto, andiamo.", spanish=" Nos iremos cuando estés listo."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(48, 3) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [48, 3]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" We need to get out of here.", french=" Nous devons partir d'ici.", german=" Wir müssen hier raus.", italian=" Dobbiamo andarcene da qui.", spanish=" Debemos salir de aquí."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Once you're ready, we'll go.", french="Une fois que tu seras prêt,\nnous nous mettrons en route.", german=" Wir gehen, sobald du fertig bist.", italian=" Quando sei pronto, andiamo.", spanish=" Nos iremos cuando estés listo."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I don't know what awaits\nus ahead.", french="Je ne sais pas ce qui nous\nattend là-bas.", german="Ich weiß nicht, was uns\nerwartet.", italian="Non so cosa ci aspetta\npiù avanti.", spanish="No sé qué nos aguarda\nmás adelante."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Remain cautious.", french=" Reste sur tes gardes.", german=" Lass Vorsicht walten.", italian=" Stiamo attenti.", spanish=" Avanza con cautela."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 125 then
  if (SkyProg.cmp_side(48, 5) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [48, 5]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Anyway... [K][CS:N]Celebi[CR] and the [CS:N]Sableye[CR]\nare up ahead.", french="Quoi qu'il en soit...[K]\n[CS:N]Celebi[CR] et les [CS:N]Ténéfix[CR] sont devant.", german="Wie auch immer... [K][CS:N]Celebi[CR] und die\n[CS:N]Zobiris[CR] sind uns voraus.", italian="In ogni caso...[K] [CS:N]Celebi[CR] e i [CS:N]Sableye[CR]\nsono più avanti.", spanish="En cualquier caso...[K] [CS:N]Celebi[CR]\ny los [CS:N]Sableye[CR] están más adelante."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="The chances are high that we\nwill see Master [CS:N]Dialga[CR] and his new henchman\nthere too.", french="Il est fort probable que là-bas\nnous rencontrions aussi Maître [CS:N]Dialga[CR]\net son nouveau bras droit.", german="Die Chancen stehen gut, dass wir\ndort auch auf Meister [CS:N]Dialga[CR] und seinen neuen\nGehilfen treffen.", italian="È molto probabile che laggiù\ntroveremo anche il Maestro [CS:N]Dialga[CR]\ne il suo nuovo servitore.", spanish="Es muy probable que también\nveamos a [CS:N]Dialga[CR] y a su nueva mano derecha."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Brace yourself, and let's go!", french="Prépare-toi à affronter ce qui\nnous attend, et mettons-nous en route!", german="Mach dich startklar, und dann\ngehen wir!", italian=" Forza, andiamo!", spanish=" ¡Prepárate y en marcha!"})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Anyway...[K] [CS:N]Celebi[CR] and the [CS:N]Sableye[CR]\nare up ahead.", french="Quoi qu'il en soit...[K]\n[CS:N]Celebi[CR] et les [CS:N]Ténéfix[CR] sont devant.", german="Wie auch immer...[K] [CS:N]Celebi[CR] und die\n[CS:N]Zobiris[CR] sind uns voraus.", italian="In ogni caso...[K] [CS:N]Celebi[CR] e i [CS:N]Sableye[CR]\nsono più avanti.", spanish="En cualquier caso...[K] [CS:N]Celebi[CR]\ny los [CS:N]Sableye[CR] están más adelante."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="The chances are high that we\nwill see Master [CS:N]Dialga[CR] and his new henchman\nthere too.", french="Il est fort probable que là-bas\nnous rencontrions aussi Maître [CS:N]Dialga[CR]\net son nouveau bras droit.", german="Die Chancen stehen gut, dass wir\ndort auch auf Meister [CS:N]Dialga[CR] und seinen neuen\nGehilfen treffen.", italian="È molto probabile che laggiù\ntroveremo anche il Maestro [CS:N]Dialga[CR]\ne il suo nuovo servitore.", spanish="Es muy probable que también veamos\na [CS:N]Dialga[CR] y a su nueva mano derecha."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Ready yourself, and let's go!", french=" Prépare-toi et allons-y!", german="Mach, dass du fertig wirst,\ndamit wir los können!", italian=" Preparati e poi andiamo!", spanish=" ¡Prepárate y vamos allá!"})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 129 then
  if (SkyProg.cmp_side(48, 9) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [48, 9]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" We only have a little time left...", french="Il ne nous reste que très peu\nde temps...", german="Uns bleibt nur noch ein bisschen\nZeit...", italian=" Ci rimane solo poco tempo...", spanish=" Nos queda muy poco tiempo..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Let's hurry to the pinnacle.", french="Dépêchons-nous d'atteindre\nle pinacle.", german=" Lass uns zur Kuppel eilen.", italian="Sbrighiamoci a raggiungere\nla vetta.", spanish=" Vayamos deprisa a la cima."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(48, 6) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [48, 6]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="There isn't much time left\nfor us...", french="Il ne nous reste pas\nbeaucoup de temps...", german=" Uns bleibt nicht mehr viel Zeit...", italian=" Non ci rimane molto tempo...", spanish=" No nos queda mucho tiempo..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Anyway, all we can do is live\nlife to the fullest within our limited time.", french="Tout ce que nous pouvons\nfaire, c'est vivre intensément le temps\nqui nous reste.", german="Alles was wir tun können, ist\ndie verbleibende Zeit in vollen Zügen zu\ngenießen.", italian="Comunque, tutto ciò che\npossiamo fare è impegnarci al massimo\nnel poco tempo che ci resta.", spanish="Lo único que podemos hacer es\nvivir al máximo el tiempo que tengamos."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Once you're ready, let's go.", french="Une fois que tu seras prêt,\nmettons-nous en route.", german="Sobald du fertig bist, können\nwir los.", italian=" Quando sei pronto, andiamo.", spanish=" Nos iremos cuando estés listo."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" I saw it, [CS:Y]Grovyle[CR].", french=" Je l'ai vue, [CS:Y]Massko[CR].", german=" Ich habe es gesehen, [CS:Y]Reptain[CR].", italian=" L'ho vista, [CS:Y]Grovyle[CR].", spanish=" La he visto, [CS:Y]Grovyle[CR]."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="The light that emanated from\nyour body earlier...", french="La lumière émanant\nde ton corps, l'autre fois...", german="Das Licht, das dein Körper zuvor\nausstrahlte...", italian="Ho visto quella luce che\nsi sprigionava dal tuo corpo...", spanish=" La luz que emitía tu cuerpo antes..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Tell me...[K] Was that a sign\nthat we're about to disappear?", french="Dis-moi...[K] était-ce le signe que\nnous sommes sur le point de disparaître?", german="Sag mir,[K] war das ein Zeichen\ndafür, dass wir bald verschwinden werden?", italian="Dimmi...[K] Significa forse che\nstiamo per scomparire?", spanish="Dime...[K] ¿Significa que estamos\na punto de desaparecer?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" .........", french=" .........", german=" .........", italian=" .........", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" I knew...[K] I should've known...", french="Je le savais...[K]\nJ'aurais dû le savoir...", german="Wusste ich es doch...[K] Ich meine,\nich hätte es wissen sollen...", italian="Lo sapevo...[K] Dovevo\nimmaginarlo...", spanish=" Lo sabía...[K] Debería haberlo sabido..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="......[K]I guess there isn't much time\nleft for us, huh...?", french="......[K] J'imagine qu'il ne nous\nreste plus beaucoup de temps, n'est-ce pas?", german="......[K]\nAlso bleibt uns nicht mehr viel Zeit, oder?", italian="......[K] Suppongo che non ci sia\nrimasto molto tempo, eh...?", spanish="Supongo...[K] que no nos queda\nmucho tiempo, ¿verdad?"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" But the shorter the time is...", french="Mais moins il nous reste\nde temps...", german=" Und je knapper die Zeit...", italian="Ma più il tempo a nostra\ndisposizione diminuisce...", spanish=" Cuanto menos tiempo queda..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="The brighter the radiance\nbecomes...", french=" ... plus la lumière devient vive.", german=" Desto heller wird das Leuchten...", italian=" ... e più intensa diventa la luce...", spanish=" Más brillante se hace el resplandor."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Anyway, all we can do is live\nlife to the fullest within our limited time.", french="Tout ce que nous pouvons\nfaire, c'est vivre intensément le temps\nqui nous reste.", german="Alles was uns bleibt, ist die\nrestliche Zeit in vollen Zügen zu genießen.", italian="Comunque, tutto ciò che\npossiamo fare è impegnarci al massimo\nnel poco tempo che ci resta.", spanish="Lo único que podemos hacer es\nvivir al máximo el tiempo que tengamos."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Once you're ready, let's go.", french="Une fois que tu seras prêt,\nmettons-nous en route.", german="Sobald du fertig bist, können\nwir los.", italian=" Quando sei pronto, andiamo.", spanish=" Nos iremos cuando estés listo."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 131 then
  if (SkyProg.cmp_side(48, 9) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [48, 9]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="We have to hold Master [CS:N]Dialga[CR]\nback...before we disappear from this world...", french="Nous devons stopper\nMaître [CS:N]Dialga[CR]... avant de disparaître\nde ce monde...", german="Wir müssen Meister [CS:N]Dialga[CR]\naufhalten, bevor wir von dieser Welt\nverschwinden...", italian="Dobbiamo fermare\nil Maestro [CS:N]Dialga[CR]... prima di scomparire\nda questo mondo...", spanish="Tenemos que detener a [CS:N]Dialga[CR]\nantes de desaparecer..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Let's hurry to the pinnacle.", french="Dépêchons-nous d'atteindre\nle pinacle.", german=" Lass uns zur Kuppel eilen.", italian=" Raggiungiamo la cima, presto!", spanish=" Vayamos deprisa a la cima."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(48, 8) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [48, 8]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="There's a good chance that\nMaster [CS:N]Dialga[CR] is already at the top.", french="Il y a de grandes chances\npour que Maître [CS:N]Dialga[CR] soit déjà au sommet.", german="Die Chancen stehen gut, dass\nMeister [CS:N]Dialga[CR] bereits oben ist.", italian="È molto probabile che il Maestro\n[CS:N]Dialga[CR] sia già in cima.", spanish="Es muy probable que [CS:N]Dialga[CR]\nya esté en la cima."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Hurry. We have to go.", french=" Vite. Il faut partir.", german=" Beeilt euch. Wir müssen los.", italian=" Presto. Dobbiamo andare.", spanish=" Rápido. Tenemos que irnos."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="There's a good chance that\nMaster [CS:N]Dialga[CR] is already at the top.", french="Il y a de grandes chances\npour que Maître [CS:N]Dialga[CR] soit déjà au sommet.", german="Die Chancen stehen gut, dass\nMeister [CS:N]Dialga[CR] bereits oben ist.", italian="È molto probabile che il Maestro\n[CS:N]Dialga[CR] sia già in cima.", spanish="Es muy probable que [CS:N]Dialga[CR]\nya esté en la cima."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Hurry. We have to go.", french=" Vite. Il faut partir.", german=" Beeilt euch. Wir müssen los.", italian=" Presto. Dobbiamo andare.", spanish=" Rápido. Tenemos que irnos."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
