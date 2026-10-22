-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/um2403.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_banebuu = SkySceneKit.spawn_npc("spoink", 384, 232, Direction.UpLeft, "NPC_BANEBUU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Your team has done it,\n[hero]! You're beyond belief!", french="Vous avez réussi,\n[hero]! Vous êtes incroyables!", german="Euer Team hat es geschafft,\n[hero]! Ihr seid einfach unglaublich!", italian="La tua squadra ce l'ha fatta,\n[hero]! Siete incredibili!", spanish="¡Tu equipo lo ha logrado,\n[hero]! ¡Sois increíbles!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" Thank you so much!", french=" Merci mille fois!", german=" Vielen Dank!", italian=" Grazie mille!", spanish=" ¡Muchas gracias!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" Everything was [CS:N]Darkrai[CR]'s doing!", french="Tout est de la faute de cet\nimmonde [CS:N]Darkrai[CR]!", german="Das war alles das Werk von\n[CS:N]Darkrai[CR]!", italian=" È tutta opera di [CS:N]Darkrai[CR]!", spanish=" ¡Todo ha sido obra de [CS:N]Darkrai[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" I, for one, am amazed!", french="En ce qui me concerne,\nje suis abasourdi!", german=" Ich für meinen Teil bin erstaunt!", italian=" Sono sbalordito!", spanish=" ¡Estoy sorprendido!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Oh, my... Things have taken a\nturn for the sinister.", french="Aïe aïe aïe... Tout ça prend\nune sinistre tournure.", german="Oje! Die Dinge sind nun wirklich\nfinster geworden.", italian="Oh... Gli eventi stanno prendendo\nuna brutta piega.", spanish="Esto se está volviendo muy, pero\nque muy siniestro."})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="I hope something can be done\nbefore all Pokémon get caught in a nightmare...", french="Espérons que cela s'arrange\navant que tous les Pokémon ne soient happés\ndans ce cauchemar...", german="Ich hoffe nur, dass etwas getan\nwerden kann, bevor alle Pokémon in einem\nAlbtraum gefangen sind...", italian="Spero si possa fare qualcosa per\nevitare che tutti i Pokémon vengano\nimprigionati in un incubo...", spanish="Espero que se pueda hacer algo\npara evitar que todos los Pokémon queden\natrapados en una pesadilla."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 76] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" You're entering the [CS:P]nightmare[CR]?!", french="Vous allez entrer dans\nle [CS:P]Cauchemar[CR]?!", german=" Ihr betretet den [CS:P]Albtraum[CR]?!?", italian=" State per entrare nell'[CS:P]Incubo[CR]?!", spanish="¡¿Cómo?! ¡¿Que vas a entrar\nen la [CS:P]pesadilla[CR]?!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Ewww...[K] What an awful place it\nmust be.", french="Brrrr...[K] Ça doit être horrible\ncomme endroit.", german="Bah...[K] Was für ein\nschrecklicher Ort muss das sein.", italian="Puah...[K] Dev'essere un posto\nterribile.", spanish="Pero...[K] ¡si debe de ser un lugar\nhorroroso!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="I can't begin to imagine such a\nhorrid place.", french="Je n'arrive même pas\nà imaginer à quel point ça doit être\naffreux.", german="Ich kann mir einen so schlimmen\nOrt nicht einmal ansatzweise vorstellen.", italian="Non riesco nemmeno a\nimmaginare un posto così orribile.", spanish=" No puedo ni imaginármelo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 73] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="That poor little [CS:N]Azurill[CR]... It's\nquite worrisome.", french="Pauvre petit [CS:N]Azurill[CR]...\nC'est très préoccupant.", german="Der arme kleine [CS:N]Azurill[CR]... Es ist\nziemlich beunruhigend.", italian="Quel povero piccolo [CS:N]Azurill[CR]...\nÈ piuttosto inquietante.", spanish="El pobre [CS:N]Azurill[CR]... Lo que le pasa\nes muy preocupante."})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="To be locked in a nightmare for\ndays on end...[K] I've never heard of such a thing.", french="Se retrouver enfermé dans un\ncauchemar pendant des jours et des jours...\nJe n'ai jamais rien entendu d'aussi terrible!", german="Tagelang in einem Albtraum\neingesperrt zu sein...[K] So etwas habe ich noch\nnie gehört.", italian="Rimanere imprigionati in un\nincubo per giorni e giorni...[K] Non avevo mai\nsentito una cosa così.", spanish="Quedarse encerrado así en una\npesadilla...[K] Nunca había oído nada parecido."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 71] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="I do wish that the women of\nTeam [CS:X]Charm[CR] would come back again.", french="Aaaaah... Si seulement les filles\nde l'Equipe [CS:X]Charme[CR] voulaient bien revenir...", german="Ich wünschte, dass die Damen\nvon Team [CS:X]Charme[CR] noch mal zurückkämen.", italian="Oh, come vorrei che quelle del\nTeam [CS:X]Malia[CR] tornassero!", spanish="¡Ojalá el [CS:X]Equipo Carisma[CR] vuelva\npor aquí!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Just once, I would love to\nmeet them.", french="Rien qu'une fois, j'aimerais\nles rencontrer.", german="Es wäre toll, sie zumindest ein\neinziges Mal treffen zu können.", italian="Vorrei incontrarle, almeno una\nvolta.", spanish=" Me encantaría conocerlas."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Oh?![K] Team [CS:X]Charm[CR] came\nvisiting?!", french="Quoi?![K] L'Equipe [CS:X]Charme[CR]\nest dans les parages?!", german="Ach?!?[K] Team [CS:X]Charme[CR] kam auf\neinen Besuch vorbei?!?", italian="Oh?![K] È venuto in visita il Team\n[CS:X]Malia[CR]?!", spanish="¡¿Qué?![K] ¿El [CS:X]Equipo Carisma[CR] ha\nvenido de visita?"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" Where?! Where?!", french=" Où ça?! Où ça?!", german=" Wo?!? Wo?!?", italian=" Dove?! Dove?!", spanish=" ¿Dónde? ¿Dónde?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Oh, is that right?![K] Secret Rank,\nyou say?", french="Oh, c'est vrai?![K] Le Grade\nSecret, vous dites?", german="Oh, ist das wahr?!?[K]\nGeheim-Rang sagst du?", italian="Oh, davvero?![K] Rango Segreto,\nhai detto?", spanish="¡¿Es eso cierto?![K] ¿Rango\nSecreto?"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="It has such a mysterious ring to\nit. How exciting!", french="Ça a l'air si mystérieux...\nComme c'est palpitant!", german="Es hat so einen mysteriösen\nKlang. Wie spannend!", italian="Suona così misterioso!\nChe emozione!", spanish="Qué misterioso. ¡Tiene que ser\nmuy emocionante!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 33] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Now and then, I hear the sounds\nof tremors from [CS:K]Marowak[CR] Dojo.", french="De temps à autre, j'entends\ndes grondements en provenance du\n[CS:K]Dojo Ossatueur[CR].", german="Dann und wann höre ich\nErdbebengeräusche aus dem [CS:K]Knogga-Dojo[CR].", italian="È da un po' che sento provenire\ndelle scosse dal Dojo [CS:K]Marowak[CR].", spanish="De vez en cuando oigo temblores\nprocedentes del [CS:K]Dojo Marowak[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" What's he doing in there...?", french="Qu'est-ce qu'il peut bien\nfabriquer là-dedans...?", german=" Was macht er bloß da drin?", italian=" Cosa sta combinando là dentro?", spanish=" ¿Qué hará allí dentro?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="I've heard! You're taking the\nguild's graduation exam?", french="Alors, on dit que vous allez\ntenter d'obtenir le diplôme de la Guilde?", german="Ich habe es gehört! Ihr wollt die\nGildenabschlussprüfung absolvieren?", italian="Ehi, ho saputo che sosterrete\nl'esame di diploma della Gilda!", spanish="¿Así que vais a intentar superar\nel gran reto del [CS:N]Pokégremio de Exploradores[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Now, I hear that [CS:N]Wigglytuff[CR]'s\nGuild has an especially tough exam.", french="Pour tout vous dire, il paraît\nque l'examen de la Guilde de [CS:N]Grodoudou[CR]\nest particulièrement difficile.", german="Na ja, man munkelt, dass die\n[CS:N]Knuddeluff-Gilde[CR] eine besonders schwierige\nAbschlussprüfung hat.", italian="Dicono che l'esame della\nGilda di [CS:N]Wigglytuff[CR] sia particolarmente duro.", spanish="Dicen que el reto del [CS:N]Pokégremio[CR]\nes muy duro."})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" Oh, but you're up to it, I'm sure!", french="Oh, mais vous, vous serez\nà la hauteur, j'en suis sûr!", german="Oh, aber ihr könnt das schaffen!\nDa bin ich mir sicher!", italian="Oh, ma voi ce la farete, ne sono\nsicuro!", spanish="¡Pero seguro que no es nada\npara una pareja de hábiles exploradores!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Team [team:] can do it!\nI'm absolutely positive!", french="L'Equipe [team:] peut y\narriver! Je n'en doute pas une seconde!", german="Team [team:] kann es\nschaffen! Ich bin da absolut zuversichtlich!", italian="Il Team [team:] ce la può\nfare! Sono assolutamente ottimista!", spanish="¡El [CS:X]Equipo[CR] [team:] puede\nlograrlo! ¡Estoy seguro!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" Please don't fail!", french=" Je vous en prie, n'échouez pas!", german=" Bitte versagt nicht!", italian=" Vi prego, mettetecela tutta!", spanish=" ¡No fracaséis, por favor!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="I hear the whole guild's off to\n[CS:P]Brine Cave[CR]!", french="J'ai entendu dire que\nla Guilde au grand complet partait\npour la [CS:P]Caverne Saline[CR]!", german="Ich habe gehört, dass sich die\ngesamte Gilde zur [CS:P]Salzwasserhöhle[CR]\naufmachen wird!", italian="Ho sentito che tutta la Gilda sta\nper andare alla [CS:P]Grotta Salmastra[CR]!", spanish="He oído que todo el [CS:N]Pokégremio[CR]\nirá a la [CS:P]Cueva Aguamar[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" Best of luck to you!", french=" Bonne chance à tous!", german=" Ich wünsche euch viel Glück!", italian=" In bocca al lupo!", spanish=" ¡Mucha suerte!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 1] || scn($SCENARIO_MAIN) >= [22
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="I'm so happy to see you back\nsafe, Team [team:]!", french="Je suis si content que\nvous soyez de retour indemnes,\nma chère Equipe [team:]!", german="Ich bin so froh, dass ihr\nunversehrt zurück seid, Team [team:]!", italian="Sono così contento di vedervi\ntornare in salute, Team [team:]!", spanish="¡Me alegro de veros, [CS:X]Equipo[CR]\n[team:]!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="I'm not very good at figuring out\ncomplicated things...", french="J'ai du mal à comprendre\nles histoires compliquées...", german="Ich bin nicht so gut darin,\nkomplizierte Dinge zu begreifen...", italian="Non sono molto bravo a capire\nle cose complicate...", spanish="No se me da bien entender los\nasuntos complejos..."})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="But you can always count on my\nsupport, Team [team:]!", french="Mais vous pouvez toujours\ncompter sur mon soutien, ma chère Equipe\n[team:]!", german="Aber ihr könnt immer auf meine\nUnterstützung zählen, Team [team:]!", italian="Ma potete sempre contare sul\nmio sostegno, Team [team:]!", spanish="¡Pero podéis contar con mi\napoyo, [CS:X]Equipo[CR] [team:]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="What do you suppose finally\nhappened to [CS:N]Grovyle[CR]?", french="A votre avis, qu'est-ce qui a\nbien pu arriver à [CS:N]Massko[CR]?", german="Was glaubt ihr ist schlussendlich\nmit [CS:N]Reptain[CR] passiert?", italian="Cosa pensate che sia successo\nalla fine a [CS:N]Grovyle[CR]?", spanish="¿Qué crees que le pasó a\n[CS:N]Grovyle[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" I do hope this plan works...", french="Si seulement ce plan pouvait\nmarcher...", german="Hoffentlich funktioniert dieser\nPlan...", italian=" Spero che il piano funzioni...", spanish=" Espero que el plan funcione..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="I'll be sure to bounce around\nand spread the rumor!", french="Je ne manquerai pas de bondir\nde-ci de-là pour répandre la rumeur!", german="Ich werde umherflitzen und das\nGerücht verbreiten!", italian="Andrò in giro a spargere la\nvoce!", spanish="¡Me aseguraré de extender el\nrumor!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="I hope it helps lure [CS:N]Grovyle[CR] to\n[CS:P]Crystal Cave[CR].", french="En espérant que ça pousse\n[CS:N]Massko[CR] à se rendre à la [CS:P]Caverne Cristal[CR].", german="Ich hoffe, das hilft, [CS:N]Reptain[CR] zur\n[CS:P]Kristallhöhle[CR] zu locken.", italian="Spero che attirare [CS:N]Grovyle[CR] alla\n[CS:P]Grotta di Cristallo[CR] si riveli d'aiuto.", spanish="Espero que atraiga a [CS:N]Grovyle[CR]\na la [CS:P]Cueva Cristal[CR]."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Oh... If only I could do something\nthat would be useful...", french="Ah... Si seulement je pouvais\nme rendre utile...", german="Ach... Wenn ich doch nur etwas\nNützliches tun könnte...", italian="Oh... Se solo potessi rendermi\nutile in qualche modo...", spanish=" Si pudiera hacer algo útil..."})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="I'm so sorry I can only offer\nmy support...[K] Good luck!", french="Je suis vraiment désolé de\nn'avoir que mon soutien à vous offrir...[K]\nBonne chance!", german="Ich bin so traurig, dass ich euch\nnur meine moralische Unterstützung anbieten\nkann...[K] Viel Glück!", italian="Mi dispiace di poter offrire\nsoltanto qualche parola di sostegno...[K]\nBuona fortuna!", spanish="Solo puedo ofreceros mi apoyo.[K]\n¡Buena suerte!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 1] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" My thoughts go with you!", french=" Mes pensées vous accompagnent!", german=" In Gedanken bin ich bei euch!", italian=" Vi penserò!", spanish=" ¡Que la fuerza os acompañe!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Please catch that dreadful\n[CS:N]Grovyle[CR]!", french="Faites en sorte d'attraper\nl'ignoble [CS:N]Massko[CR]!", german="Bitte fangt diesen grausamen\n[CS:N]Reptain[CR] ein!", italian="Vi prego, catturate il terribile\n[CS:N]Grovyle[CR]!", spanish="¡Por favor, atrapad al malvado\n[CS:N]Grovyle[CR]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 4] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Oh, [hero] and\n[partner]!", french="Tiens, [hero] et\n[partner]!", german="Oh, [hero] und\n[partner]!", italian="Oh, [hero] e\n[partner]!", spanish="Oh, ¡[hero] y\n[partner]!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="There were many [CS:N]Pelipper[CR] flying\nabout, filling the sky!", french="Vous avez vu tous ces [CS:N]Bekipan[CR]\ndans le ciel?", german="Habt ihr die vielen [CS:N]Pelipper[CR] am\nHimmel bemerkt?", italian="C'erano tantissimi [CS:N]Pelipper[CR] che\nvolavano, dappertutto!", spanish="¡Había muchos [CS:N]Pelipper[CR] volando!\n¡Cubrían todo el cielo!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="I've never seen so many\n[CS:N]Pelipper[CR] in the sky at once!", french="Je n'avais jamais vu autant de\n[CS:N]Bekipan[CR] d'un coup!", german="Ich habe noch nie so viele\n[CS:N]Pelipper[CR] auf einmal am Himmel gesehen!", italian="Non avevo mai visto volare così\ntanti [CS:N]Pelipper[CR] in una volta sola!", spanish="¡Nunca había visto tantos\n[CS:N]Pelipper[CR] volando a la vez!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [13, 2] || scn($SCENARIO_MAIN) >= [13
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Oh, [hero] and\n[partner]!", french="Tiens, [hero] et\n[partner]!", german="Oh, [hero] und\n[partner]!", italian="Oh, [hero] e\n[partner]!", spanish="Oh, ¡[hero] y\n[partner]!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="I've come into an interesting bit\nof news I can't wait to share with you.", french="J'ai ici une information que\nje suis impatient de partager avec vous.", german="Ich bin an ein paar interessante\nNeuigkeiten gekommen, die ich unbedingt mit\neuch teilen muss.", italian="Ho saputo una cosa...!!!\nNon vedo l'ora di raccontarla a qualcuno!", spanish="Me he enterado de algunas cosas\ncuriosas que a lo mejor os viene bien saber."})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Have you heard about Eggs,\n[hero]?", french="Est-ce que tu as déjà entendu\nparler des Œufs, [hero]?", german="Hast du schon von Eiern gehört,\n[hero]?", italian="Hai presente le Uova, no,\n[hero]?", spanish="¿Sabes algo sobre los Huevos,\n[hero]?"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Eggs are quite rare, I hear.[K] And\nI hear you may get them as rewards for jobs.", french="Les Œufs sont plutôt rares,\nà ce qu'on dit.[K] Et il paraît qu'on peut\nen recevoir en récompense après une mission.", german="Eier sind ziemlich selten, sagt\nman.[K] Und ich habe gehört, dass man sie als\nBelohnung für erledigte Jobs bekommen kann.", italian="Si dice che le Uova siano\npiuttosto rare.[K] E che si possano ottenere\ncome ricompensa per alcune missioni.", spanish="No es muy habitual encontrar\nHuevos.[K] A veces, incluso se ofrecen como\nrecompensa en algunas misiones."})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="But as precious as Eggs can be,\nthey can be a burden to look after.", french="Mais aussi précieux qu'ils\nsoient, ils peuvent s'avérer un terrible fardeau\ncar il faut s'en occuper constamment.", german="So wertvoll Eier auch sein\nmögen, es kann eine wahre Last sein, sich um\nsie kümmern zu müssen.", italian="Ma per quanto un Uovo possa\nessere prezioso, prendersene cura è\ndavvero faticoso.", spanish="Pero, aunque sean muy valiosos,\ncuidar de ellos puede resultar una carga."})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" But...[K]worry no more!", french=" Mais...[K] plus d'inquiétude à avoir!", german="Aber[K] macht euch keine Sorgen\nmehr!", italian="Ma...[K] Non c'è nulla di cui\npreoccuparsi!", spanish="Si es vuestro caso...[K] ¡no pasa\nnada!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="There's a new shop in town that\nwill take care of your Eggs!", french="Il y a une nouvelle boutique\nen ville qui prendra soin de tes Œufs!", german="Es gibt einen neuen Laden im Ort,\nder sich um Eier kümmert!", italian="In città c'è un nuovo negozio che\nsi prende cura delle Uova!", spanish="¡Hay un nuevo establecimiento\ndonde se ocupan de cuidar de los Huevos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_banebuu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" See that shop in the lower left?", french="Tu vois cette boutique en bas\nà gauche?", german=" Seht ihr den Laden unten links?", italian="Vedi quel negozio in basso sulla\nsinistra?", spanish="Está ahí abajo, a la izquierda.\n¿Lo ves?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_banebuu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_banebuu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="A Pokémon named [CS:N]Chansey[CR] runs\nthe shop.", french="Elle est tenue par un Pokémon\ndu nom de [CS:N]Leveinard[CR].", german="Ein Pokémon namens [CS:N]Chaneira[CR]\nführt den Laden.", italian="Lo gestisce un Pokémon di nome\n[CS:N]Chansey[CR].", spanish="Un Pokémon llamado [CS:N]Chansey[CR]\nes quien lo dirige."})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="If you ever get an Egg, [CS:N]Chansey[CR]\nwill take care of it for you, [hero].", french="Si jamais tu obtiens un Œuf,\nc'est à [CS:N]Leveinard[CR] que tu dois le confier,\n[hero].", german="Solltest du jemals ein Ei finden,\ndann wird [CS:N]Chaneira[CR] für dich darauf aufpassen,\n[hero].", italian="Se trovi un Uovo, se ne\nprenderà cura [CS:N]Chansey[CR], [hero].", spanish="Si consigues un Huevo, [CS:N]Chansey[CR]\npodrá encargarse de él, [hero]."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Oh, [hero] and\n[partner]!", french="Tiens, [hero] et\n[partner]!", german="Oh, [hero] und\n[partner]!", italian="Oh, [hero] e\n[partner]!", spanish=" ¡[hero] y [partner]!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="It's been much too long! It's me,\n[CS:N]Spoink[CR]!", french="Ça fait si longtemps! C'est moi,\n[CS:N]Spoink[CR]!", german="Es ist schon viel zu lange her!\nIch bin es, [CS:N]Spoink[CR]!", italian="Quanto tempo! Sono io,\n[CS:N]Spoink[CR]!", spanish="¡Cuánto tiempo! ¡Soy yo!\n¡[CS:N]Spoink[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="You're going on an expedition!\nI heard! How fabulous!", french="Il paraît que vous partez en\nexpédition! C'est fabuleux!", german="Ihr geht auf eine Expedition! Ich\nhab es gehört! Sagenhaft!", italian="Ho sentito che state partendo\nper una spedizione! È fantastico!", spanish="¡He oído que os vais de\nexpedición! ¡Fabuloso!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Oh, please do come back with\nlots of treasures! ♪", french="J'espère que vous allez revenir\navec une montagne de trésors! ♪", german="Oh, bitte kommt mit reichlich\nSchätzen zurück! ♪", italian="Ah, mi raccomando, tornate con\nmolti tesori! ♪", spanish="¡Regresad con muchos\ntesoros! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7] || scn($SCENARIO_MAIN) >= [8, 
  if ((SV.SkyTalkBitFlags or {})[2] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[2]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Inside a dungeon...[K]until you make\na move, no enemies can take their turns. Did\nyou know that surprising fact?", french="Dans un donjon...[K] aucun ennemi\nne peut agir tant que vous restez immobile.\nEtonnant, non?", german="In einem Dungeon[K] kann kein\nGegner einen Zug unternehmen, solange ihr\neuch nicht bewegt habt. Wusstet ihr das?", italian="All'interno di un dungeon...[K]\nfinché non fai una mossa, nessun nemico\npotrà agire. Lo sapevi? Sorprendente, vero?", spanish="En los territorios...[K] los enemigos\nno pueden atacar primero. ¿Lo sabíais?"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="So when you run into an enemy\nin a dungeon...[K]you don't have to panic.", french="Alors quand vous tombez sur\nun ennemi dans un donjon...[K] pas de panique!", german="Wenn ihr also in einem Dungeon\nauf einen Gegner trefft,[K] braucht ihr nicht in\nPanik zu verfallen.", italian="Perciò quando ci si imbatte in un\nnemico all'interno di un dungeon...[K] non bisogna\nfarsi prendere dal panico.", spanish="Así que cuando os encontréis con\nadversarios en un territorio...[K] que no cunda\nel pánico."})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="That gives you time to stay calm\nwhile you choose what to do. You'll be a\ngreat explorer if you make careful choices! ♪", french="Prenez le temps de réfléchir à\nune stratégie. Faire le bon choix est la clé\ndu succès pour un explorateur! ♪", german="Das gibt euch Zeit, eure nächste\nAktion gründlich zu planen. Trefft weise Ent-\nscheidungen und ihr werdet große Erkunder! ♪", italian="C'è tutto il tempo di\nscegliere come agire. Facendo le scelte giuste,\nsi diventa grandi esploratori! ♪", spanish="Tendréis tiempo de escoger\nvuestro movimiento. ¡Seréis grandes\nexploradores si elegís con cuidado! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[2] = 1 -- $SCENARIO_TALK_BIT_FLAG[2] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_banebuu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Oh, [hero] and\n[partner]!", french="Tiens, [hero] et\n[partner]!", german="Oh, [hero] und\n[partner]!", italian="Oh, [hero] e\n[partner]!", spanish=" ¡[hero] y [partner]!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" It's me! [CS:N]Spoink[CR]!", french=" C'est moi, [CS:N]Spoink[CR]!", german=" Ich bin es! [CS:N]Spoink[CR]!", italian=" Sono io! [CS:N]Spoink[CR]!", spanish=" ¡Soy yo! ¡[CS:N]Spoink[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Thank you so much for getting\nmy pearl back for me!", french="Je vous suis si reconnaissant\nd'avoir récupéré ma perle!", german="Vielen Dank, dass ihr mir meine\nPerle zurückgebracht habt!", italian="Grazie infinite per avermi\nriportato la perla!", spanish="¡Muchas gracias por recuperar\nmi perla!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="I'll give you a useful tip as\nfurther gratitude! ♪", french="En signe de gratitude, je vais\nvous donner un bon tuyau! ♪", german="Aus Dankbarkeit gebe ich euch\nnoch einen Tipp! ♪", italian="Ecco un suggerimento utile in\nsegno della mia gratitudine! ♪", spanish="Como muestra de mi gratitud, os\ndaré un consejo. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Inside a dungeon...[K]until you make\na move, no enemies can take their turns. Did\nyou know that surprising fact?", french="Dans un donjon...[K] aucun ennemi\nne peut agir tant que vous restez immobile.\nEtonnant, non?", german="In einem Dungeon[K] kann kein\nGegner einen Zug unternehmen, solange ihr\neuch nicht bewegt habt. Wusstet ihr das?", italian="All'interno di un dungeon...[K]\nfinché non fai qualcosa, nessun nemico\npotrà agire. Lo sapevi? Sorprendente, vero?", spanish="En los territorios...[K] los enemigos\nno pueden atacar primero. ¿Lo sabíais?"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="So when you run into an enemy\nin a dungeon...[K]you don't have to panic.", french="Alors quand vous tombez sur\nun ennemi dans un donjon...[K] pas de panique!", german="Wenn ihr also in einem Dungeon\nauf einen Gegner trefft,[K] braucht ihr nicht in\nPanik zu verfallen.", italian="Perciò quando ci si imbatte in un\nnemico all'interno di un dungeon...[K] non bisogna\nfarsi prendere dal panico.", spanish="Así que cuando os encontréis con\nadversarios en un territorio...[K] que no cunda\nel pánico."})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="That gives you time to stay calm\nwhile you choose what to do. You'll be a\ngreat explorer if you make careful choices! ♪", french="Prenez le temps de réfléchir à\nune stratégie. Faire le bon choix est la clé\ndu succès pour un explorateur! ♪", german="Das gibt euch Zeit, eure nächste\nAktion gut zu planen. Trefft weise Entschei-\ndungen, und ihr werdet große Erkunder! ♪", italian="C'è tutto il tempo di\nscegliere come agire. Facendo le scelte giuste,\nsi diventa grandi esploratori! ♪", spanish="Tendréis tiempo de escoger\nvuestro movimiento. ¡Seréis grandes\nexploradores si elegís con cuidado! ♪"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 3] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
