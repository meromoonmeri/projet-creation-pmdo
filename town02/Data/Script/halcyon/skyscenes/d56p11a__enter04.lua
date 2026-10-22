-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D56P11A/enter04.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 138 then
  if (SkyProg.cmp_side(45, 7) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [45, 7]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 288, 216, Direction.Up, "NPC_SAANAITO")
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="We can't take our time.\nWe've got things to do.", french="On ne peut pas se\npermettre de prendre notre temps.\nOn a du travail.", german="Wir können uns nicht zu viel\nZeit nehmen. Wir haben genug zu tun.", italian="Non possiamo prendercela\ncomoda. Abbiamo delle cose da fare.", spanish="No podemos dormirnos en los\nlaureles, tenemos cosas que hacer."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="I'm curious how far ahead of us\nTeam [CS:X]AWD[CR] is...", french="Je serais curieuse de savoir\nà quelle distance de nous peut se trouver\nl'Equipe [CS:X]DDA[CR]...", german="Ich bin gespannt, wie weit uns\nTeam [CS:X]SPA[CR] voraus ist...", italian="Mi piacerebbe sapere quanto\nvantaggio ha il Team [CS:X]AWD[CR]...", spanish="Tengo curiosidad por saber\ncuánta ventaja nos lleva el [CS:X]Equipo WAD[CR]..."})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(45, 4) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [45, 4]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Let's take our time and not rush\nthrough things.", french="Prenons notre temps et\névitons de nous précipiter.", german="Lasst uns mit Bedacht und nicht\nzu hastig vorgehen.", italian="Non dobbiamo avere fretta...\nfacciamo le cose con calma.", spanish="Será mejor que nos lo tomemos\ncon calma y no nos precipitemos."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Let's get ready, [CS:Y]Lopunny[CR].", french=" Préparons-nous, [CS:Y]Lockpin[CR].", german=" Bereiten wir uns vor, [CS:Y]Schlapor[CR].", italian=" Prepariamoci bene, [CS:Y]Lopunny[CR].", spanish=" Vamos a prepararnos, [CS:Y]Lopunny[CR]."})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Team [CS:X]AWD[CR] is already on its\nway there.", french="L'Equipe [CS:X]DDA[CR]\nest déjà partie devant.", german="Team [CS:X]SPA[CR] ist bereits dorthin\nunterwegs.", italian="Il Team [CS:X]AWD[CR] si sta già\ndirigendo laggiù.", spanish="El [CS:X]Equipo WAD[CR] ya se dirige\nhacia allí."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="We should hurry up and get\nready so we can catch up.", french="On devrait se dépêcher\nde se préparer pour pouvoir les rattraper.", german="Wir sollten uns beeilen, damit\nwir sie noch einholen können.", italian="Dobbiamo prepararci in fretta\nse vogliamo raggiungerli.", spanish="Deberíamos darnos prisa en\nprepararnos para alcanzarlos."})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 139 then
  if (SkyProg.cmp_side(45, 7) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [45, 7]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="It's too bad that we'll have to\npass through [CS:N]Aggron[CR]'s territory again, but...", french="Malheureusement, on va devoir\nrepasser par le territoire de [CS:N]Galeking[CR]...", german="Wirklich dumm, dass wir erneut\ndurch das Gebiet von [CS:N]Stolloss[CR] müssen...", italian="Purtroppo dobbiamo attraversare\ndi nuovo il territorio di [CS:N]Aggron[CR], ma...", spanish="No será agradable tener que\nvolver a pasar por tierras de [CS:N]Aggron[CR], pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="In order to get ahead...[K] We just\nhave to get over there.", french="Mais si nous voulons avancer...[K]\nnous devons passer par là.", german="Aber um weiter zu kommen,[K]\nbleibt uns wohl nichts anderes übrig.", italian="... se vogliamo proseguire...[K] non\nabbiamo altra scelta.", spanish="Para poder avanzar...[K] Tenemos\nque pasar por ahí."})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(45, 6) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [45, 6]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Let's proceed with caution,\n[CS:Y]Lopunny[CR].", french="Agissons prudemment,\n[CS:Y]Lockpin[CR].", german="Lass uns mit Bedacht fortfahren,\n[CS:Y]Schlapor[CR].", italian="Procediamo con cautela,\n[CS:Y]Lopunny[CR].", spanish="Será mejor que vayamos con\ncautela, [CS:Y]Lopunny[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="We might run into Team [CS:X]AWD[CR]\nsomewhere out here.", french="Il se pourrait que l'on tombe\nsur l'Equipe [CS:X]DDA[CR] quelque part\ndans les parages.", german="Wir könnten Team [CS:X]SPA[CR] irgendwo\ndort draußen über den Weg laufen.", italian="Potremmo imbatterci\nnel Team [CS:X]AWD[CR] da queste parti.", spanish="Podríamos encontrarnos con el\n[CS:X]Equipo WAD[CR] en algún sitio de por aquí."})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Let's proceed with caution,\n[CS:Y]Lopunny[CR].", french="Agissons prudemment,\n[CS:Y]Lockpin[CR].", german="Lass uns mit Bedacht fortfahren,\n[CS:Y]Schlapor[CR].", italian="Procediamo con cautela,\n[CS:Y]Lopunny[CR].", spanish="Será mejor que vayamos con\ncautela, [CS:Y]Lopunny[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="We might run into Team [CS:X]AWD[CR]\nsomewhere out here.", french="Il se pourrait que l'on tombe\nsur l'Equipe [CS:X]DDA[CR] quelque part\ndans les parages.", german="Wir könnten Team [CS:X]SPA[CR] irgendwo\ndort draußen über den Weg laufen.", italian="Potremmo imbatterci\nnel Team [CS:X]AWD[CR] da queste parti.", spanish="Podríamos encontrarnos con el\n[CS:X]Equipo WAD[CR] en algún sitio de por aquí."})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 141 then
  if (SkyProg.cmp_side(45, 13) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [45, 13]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="It looks like we can get to the\ncavern by going through the wall between the\ntwo entrances.", french="On dirait qu'on peut accéder\nà la caverne en traversant le mur qui sépare\nles deux entrées.", german="Es scheint, als könnten wir die\nHöhle erreichen, indem wir durch die Wand\nzwischen den beiden Eingängen schreiten.", italian="A quanto pare possiamo\nraggiungere la caverna attraversando\nla parete tra le due entrate.", spanish="Parece que podemos entrar en la\ncueva atravesando el muro que está\nentre las dos entradas."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Once you're ready, let's get\ngoing.", french=" On y va quand vous voulez.", german="Machen wir uns auf den Weg,\nsobald du bereit bist.", italian=" Quando siamo pronte, andiamo.", spanish="Nos pondremos en marcha\nen cuanto estés a punto."})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(45, 10) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [45, 10]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Let's try again![K]\nInto that wall!", french="Essayons encore![K]\nDans le mur!", german="Lasst es uns noch mal\nprobieren![K] Durch diese Wand!", italian="Riproviamoci![K]\nAttraversiamo la parete!", spanish="¡Vamos a intentarlo otra vez![K]\n¡Por el muro!"})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(45, 9) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [45, 9]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="It couldn't be that the wall\nbetween the two entrances is...", french="Je ne pense pas que le mur\nentre les deux entrées soit...", german="Es kann doch nicht sein, dass die\nWand zwischen diesen beiden Eingängen...", italian="Non sarà che la parete tra\nle due entrate...", spanish="No es posible que el muro que\nhay entre las dos entradas sea..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Maybe it's a hidden doorway!", french="C'est peut-être un passage\nsecret!", german=" Vielleicht ist es ein Geheimgang!", italian="Forse si tratta di un passaggio\nsegreto!", spanish=" ¡Quizá sea una entrada secreta!"})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif ((((SV.SkyVars or {}).SIDE06_ROOM or {})[2] or 0) ~= 0) then -- elseif ROM: $SIDE06_ROOM[2]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="No more telling jokes to\n[CS:N]Medicham[CR].", french="On ne fait plus de blagues à\n[CS:N]Charmina[CR].", german="Und keine weiteren Scherze mit\n[CS:N]Meditalis[CR].", italian=" Basta scherzare con [CS:N]Medicham[CR].", spanish="No le cuentes más chistes a\n[CS:N]Medicham[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Let's really do it this time.", french=" On ne rigole pas, cette fois.", german=" Lasst es uns diesmal hinkriegen.", italian="Questa volta dobbiamo farcela\nsul serio.", spanish=" Esta vez vamos a conseguirlo."})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif ((((SV.SkyVars or {}).SIDE06_ROOM or {})[0] or 0) ~= 0) then -- elseif ROM: $SIDE06_ROOM[0]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Let's try the one on the left\nthis time.", french="Essayons la partie gauche,\ncette fois-ci.", german="Lasst uns diesmal den linken\nEingang ausprobieren.", italian="Questa volta proviamo l'entrata\na sinistra.", spanish="Esta vez podemos probar por\nla izquierda."})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif ((((SV.SkyVars or {}).SIDE06_ROOM or {})[1] or 0) ~= 0) then -- elseif ROM: $SIDE06_ROOM[1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Let's try the one on the right\nthis time.", french="Essayons la partie droite,\ncette fois-ci.", german="Lasst uns diesmal den rechten\nEingang ausprobieren.", italian="Questa volta proviamo l'entrata\na destra.", spanish="Esta vez podemos probar por\nla derecha."})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(45, 8) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [45, 8]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Let's try again.", french=" Essayons encore.", german="Lasst es uns noch einmal\nprobieren.", italian=" Riproviamo.", spanish=" Vamos a intentarlo otra vez."})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="I guess we'll have to pick\nan entrance and see.", french="Je pense que nous devons\nchoisir une entrée et voir où ça nous mène.", german="Es bleibt uns wohl nichts anderes\nübrig. Lasst uns einen Eingang wählen und\nsehen, was passiert.", italian="Dovremo scegliere un'entrata\ne vedere cosa succede.", spanish="Supongo que tendremos que\nelegir una entrada y ver qué pasa."})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 143 then
  if (SkyProg.cmp_side(45, 13) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [45, 13]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Let's try and head deeper again.", french="Essayons de progresser encore\nplus loin dans la caverne.", german="Versuchen wir, noch tiefer zu\nkommen.", italian="Forza, arriviamo fino in fondo\nun'altra volta.", spanish="Volvamos a intentar\nadentrarnos más."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="We need to locate where the\ntreasure is.", french=" Il nous faut localiser le trésor.", german="Wir müssen herausfinden, wo\nsich der Schatz befindet.", italian="Dobbiamo scoprire dov'è finito\nil tesoro.", spanish=" Hay que localizar el tesoro."})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="We should be more cautious\nfrom here on, [CS:Y]Lopunny[CR].", french="On devrait redoubler de vigilance\nà partir d'ici, [CS:Y]Lockpin[CR].", german="Wir sollten von hier an mehr\nachtgeben, [CS:Y]Schlapor[CR].", italian="Da qui in poi faremmo meglio\na procedere con cautela, [CS:Y]Lopunny[CR].", spanish="A partir de ahora deberíamos ir\ncon más cautela, [CS:Y]Lopunny[CR]."})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  -- @label_0 [étiquette de flux ExplorerScript]
  if (SkyProg.cmp_side(45, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [45, 2]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="On the other side of this jungle\nis [CS:P]Boulder Quarry[CR].", french="Au-delà de cette jungle se\ntrouve la [CS:P]Carrière Rocher[CR].", german="Auf der anderen Seite dieses\nDschungels befindet sich der [CS:P]Geröllbruch[CR].", italian="Al di là di questa giungla\nsi trova la [CS:P]Cava Rocciosa[CR].", spanish="Al otro lado de esta selva se\nhalla el [CS:P]Roquedal[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Get ready so we can go.", french=" Préparons-nous à partir.", german=" Mach hin, damit wir loskönnen.", italian="Prepariamoci e mettiamoci\nin cammino.", spanish="Prepárate para que\npodamos irnos."})
  -- message_Close
  -- @label_6 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="On the other side of this jungle\nis [CS:P]Boulder Quarry[CR].", french="Au-delà de cette jungle se\ntrouve la [CS:P]Carrière Rocher[CR].", german="Auf der anderen Seite dieses\nDschungels befindet sich der [CS:P]Geröllbruch[CR].", italian="Al di là di questa giungla\nsi trova la [CS:P]Cava Rocciosa[CR].", spanish="Al otro lado de esta selva se\nhalla el [CS:P]Roquedal[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Let's hurry up and get ready so\nwe can go.", french="Dépêchons-nous de nous\npréparer et mettons-nous en route.", german="Wir sollten uns beeilen und\nfertig werden, damit wir aufbrechen können!", italian="Sbrighiamoci con i preparativi,\ncosì possiamo partire.", spanish="Vamos a prepararnos para poder\nir allí."})
  -- message_Close
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
