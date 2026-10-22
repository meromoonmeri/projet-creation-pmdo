-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P04A/enter11.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_INIT_RANDOM_NPC_JOBS, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_TYPE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_TYPE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Please hurry and help\n[c_name:RANDOM_REQUEST_NPC02]. I'm counting on you.", french="S'il vous plaît, dépêchez-vous\nde porter secours à [c_name:RANDOM_REQUEST_NPC02].\nJe compte sur vous.", german="Bitte beeilt euch und helft\n[c_name:RANDOM_REQUEST_NPC02]. Ich zähle auf euch.", italian="Per favore, fate presto\ne aiutate [c_name:RANDOM_REQUEST_NPC02]. Conto su di voi.", spanish="Daos prisa y ayudad a\n[c_name:RANDOM_REQUEST_NPC02]. Cuento con vuestro apoyo."})
  -- @label_20 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="If it isn't Team [team:]!\nI had something I wanted to ask you!", french="Mais ne serait-ce pas là\nl'Equipe [team:]? Il y a quelque chose\nque je voulais vous demander!", german="Na, wenn das mal nicht Team\n[team:] ist! Ich habe eine Bitte an euch!", italian="Ma guarda se non è\nil Team [team:]! Volevo proprio\nchiedervi una cosa!", spanish="¡Si es el [CS:X]Equipo[CR] [team:]!\nOs quería pedir una cosilla."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" I'd like you to help [c_name:RANDOM_REQUEST_NPC02].", french="J'aimerais que vous\nveniez en aide à [c_name:RANDOM_REQUEST_NPC02].", german="Ich möchte gerne, dass ihr\n[c_name:RANDOM_REQUEST_NPC02] helft.", italian="Vorrei che aiutaste\n[c_name:RANDOM_REQUEST_NPC02].", spanish="Me gustaría que ayudarais a\n[c_name:RANDOM_REQUEST_NPC02], por favor."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I just can't do it myself...\nPlease, I'm counting on you!", french="Je ne peux pas m'en occuper\nmoi-même... S'il vous plaît, je compte\nsur vous!", german="Ich habe selbst leider keine Zeit\ndafür... Bitte, ich zähle auf euch!", italian="Da solo non posso farcela...\nPer favore... conto su di voi!", spanish="Es que yo no puedo...\n¡Cuento con vuestra ayuda!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back2_SetMode(7) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to accept this job request?", french="[CN]Voulez-vous accepter la mission?", german="[CN]Nimmst du diese Job-Anfrage an?", italian="[CN]Vuoi accettare questa missione?", spanish="[CN]¿Aceptas esta misión?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh, no...\nI really thought Team [team:] could help\n[c_name:RANDOM_REQUEST_NPC02]...", french="Oh, non...\nJe pensais vraiment que l'Equipe [team:]\npouvait aider [c_name:RANDOM_REQUEST_NPC02]...", german="Oh, schade...\nIch dachte wirklich, Team [team:] könnte\n[c_name:RANDOM_REQUEST_NPC02] helfen...", italian="Oh, no...\nSperavo davvero che il Team [team:]\npotesse aiutare [c_name:RANDOM_REQUEST_NPC02]...", spanish="Pues vaya... La verdad es que\npensaba que el [CS:X]Equipo[CR] [team:] podría\nayudar a [c_name:RANDOM_REQUEST_NPC02], pero..."})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_J) [ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][hero] accepted\n[CN]the job request!", french="[CN][hero] accepte\n[CN]la mission!", german="[CN][hero] hat den\n[CN]Job angenommen!", italian="[CN][hero] ha accettato\n[CN]la missione!", spanish="[CN]¡[hero] ha aceptado\n[CN]la misión!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Thank you so much!\nPlease help [c_name:RANDOM_REQUEST_NPC02]!", french="Merci beaucoup!\nAidez [c_name:RANDOM_REQUEST_NPC02], s'il vous plaît!", german="Oh, vielen Dank!\nBitte helft [c_name:RANDOM_REQUEST_NPC02]!", italian="Grazie mille!\nVi prego, aiutate [c_name:RANDOM_REQUEST_NPC02]!", spanish="¡Muchísimas gracias!\n¡Ayudad a [c_name:RANDOM_REQUEST_NPC02], por favor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Your Job List is full,\n[CN]so you cannot accept it.", french="[CN]Votre Liste de Missions est pleine,\n[CN]donc vous ne pouvez pas l'accepter.", german="[CN]Die Jobliste ist voll, daher kannst\n[CN]du die Anfrage nicht akzeptieren.", italian="[CN]La tua lista delle missioni è piena,\n[CN]quindi non puoi accettarla.", spanish="[CN]Tu lista de misiones está llena,\n[CN]así que no puedes aceptarla."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  elseif __sw == 8 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Please hurry and find\n[c_name:RANDOM_REQUEST_NPC02]! I'm counting on you!", french="Dépêchez-vous de trouver\n[c_name:RANDOM_REQUEST_NPC02], s'il vous plaît!\nJe compte sur vous!", german="Bitte beeilt euch und findet\n[c_name:RANDOM_REQUEST_NPC02]! Ich rechne mit euch!", italian="Per favore, fate in fretta\ne trovate [c_name:RANDOM_REQUEST_NPC02]! Conto su di voi!", spanish="Daos prisa y ayudad a\n[c_name:RANDOM_REQUEST_NPC02]; cuento con vuestra ayuda."})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh, Team [team:]!\nPerfect timing!", french="Oh, Equipe [team:]!\nVous tombez à pic!", german="Oh, Team [team:]!\nPerfektes Timing!", italian="Oh, Team [team:]!\nTempismo perfetto!", spanish="¡Anda, [CS:X]Equipo[CR] [team:]!\n¡Justo a tiempo!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I'd like to ask you to look for\n[c_name:RANDOM_REQUEST_NPC02], who's been gone for a while!\nCould you, please?", french="J'aimerais vous demander\nde rechercher [c_name:RANDOM_REQUEST_NPC02] qui a disparu\ndepuis un bout de temps. Vous voulez bien?", german="Ich möchte euch bitten, nach\n[c_name:RANDOM_REQUEST_NPC02] zu suchen!\nWürdet ihr das bitte machen?", italian="Volevo chiedervi se potete\ncercare [c_name:RANDOM_REQUEST_NPC02]. Non si vede più in giro\nda un sacco di tempo! Per favore, aiutatemi!", spanish="Quería pediros que buscarais a\n[c_name:RANDOM_REQUEST_NPC02], que lleva tiempo ausente.\n¿Podríais hacerlo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back2_SetMode(7) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to accept this job request?", french="[CN]Voulez-vous accepter la mission?", german="[CN]Nimmst du diese Job-Anfrage an?", italian="[CN]Vuoi accettare questa missione?", spanish="[CN]¿Aceptas esta misión?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Whaaat?!\nI guess it can't be helped... I'll just put a\nrequest up on the Job Bulletin Board.", french="Quoiii?! Dans ce cas,\nje n'ai pas le choix... Je vais afficher\nune mission sur le Tableau des Missions.", german="Waaaaas?!? Dann bleibt mir\nnichts anderes übrig, als diese Anfrage ans\nJob-Infobrett heften zu lassen.", italian="Cooosa?!\nBeh, forse è troppo difficile... Metterò\nun annuncio sulla Bacheca delle missioni.", spanish="¡¿Cómo?!\nQué se le va a hacer... Colgaré una\nsolicitud en el Tablón de Anuncios."})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_J) [ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][hero] accepted\n[CN]the job request!", french="[CN][hero] accepte\n[CN]la mission!", german="[CN][hero] hat den\n[CN]Job angenommen!", italian="[CN][hero] ha accettato\n[CN]la missione!", spanish="[CN]¡[hero] ha aceptado\n[CN]la misión!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Thank you so much!\nPlease help [c_name:RANDOM_REQUEST_NPC02]!", french="Merci beaucoup!\nAidez [c_name:RANDOM_REQUEST_NPC02], s'il vous plaît!", german="Oh, vielen Dank!\nBitte helft [c_name:RANDOM_REQUEST_NPC02]!", italian="Grazie mille!\nVi prego, aiutate [c_name:RANDOM_REQUEST_NPC02]!", spanish="¡Muchísimas gracias!\n¡Ayudad a [c_name:RANDOM_REQUEST_NPC02], por favor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Your Job List is full,\n[CN]so you cannot accept it.", french="[CN]Votre Liste de Missions est pleine,\n[CN]donc vous ne pouvez pas l'accepter.", german="[CN]Die Jobliste ist voll, daher kannst\n[CN]du die Anfrage nicht akzeptieren.", italian="[CN]La tua lista delle missioni è piena,\n[CN]quindi non puoi accettarla.", spanish="[CN]Tu lista de misiones está llena,\n[CN]así que no puedes aceptarla."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  elseif __sw == 2 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I'll join you just inside the\ndungeon. I'm counting on you!", french="Je vous rejoindrai à l'intérieur\ndu donjon. Je compte sur vous!", german="Ich treffe euch am Eingang des\nDungeons! Ich zähle auf euch!", italian="Vi raggiungerò all'interno\ndel dungeon. Conto su di voi!", spanish="Me uniré a vuestro equipo\nen el territorio. ¡Cuento con vuestra ayuda!"})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I have to go into the dungeon to\nmeet [c_name:RANDOM_REQUEST_NPC02], but I'm too scared to go\nby myself.", french="Il faut que je me rende dans le\ndonjon pour retrouver [c_name:RANDOM_REQUEST_NPC02],\nmais j'ai trop peur d'y aller sans personne.", german="Ich muss in den Dungeon, um\n[c_name:RANDOM_REQUEST_NPC02] zu treffen, aber ich habe zu viel\nAngst, allein zu gehen.", italian="Devo incontrarmi nel dungeon\ncon [c_name:RANDOM_REQUEST_NPC02], ma ho troppa paura\nad andare per conto mio.", spanish="Tengo que ir al territorio para\nencontrarme con [c_name:RANDOM_REQUEST_NPC02], pero me da\nmiedo ir sin nadie más."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Now, Team [team:]!\nCould you please escort me to meet\n[c_name:RANDOM_REQUEST_NPC02]?", french="Alors, Equipe [team:]!\nVous pourriez m'accompagner pour retrouver\n[c_name:RANDOM_REQUEST_NPC02], s'il vous plaît?", german="Also, Team [team:]...\nWürdet ihr mich begleiten, damit ich\n[c_name:RANDOM_REQUEST_NPC02] treffen kann?", italian="Sentite, Team [team:]!\nPotreste scortarmi in modo che possa\nincontrare [c_name:RANDOM_REQUEST_NPC02]?", spanish="Bueno, [CS:X]Equipo[CR] [team:]...\n¿Me escoltaríais hasta que encontrara a\n[c_name:RANDOM_REQUEST_NPC02]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back2_SetMode(7) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to accept this job request?", french="[CN]Voulez-vous accepter la mission?", german="[CN]Nimmst du diese Job-Anfrage an?", italian="[CN]Vuoi accettare questa missione?", spanish="[CN]¿Aceptas esta misión?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oooh...\nI'm so scared, but I guess I have no choice but\nto go in alone...", french="Oooh...\nBon, j'ai vraiment peur, mais on dirait que je\nn'ai pas le choix...", german="Oooh... Ich habe solch eine Angst,\naber anscheinend bleibt mir nichts anderes\nübrig, als allein zu gehen...", italian="Oooh...\nHo una fifa enorme, ma temo di non avere\nscelta se non quella di andare per conto mio...", spanish="Jooo...\nPor más miedo que me dé, supongo que no me\nqueda más remedio que ir por mi cuenta..."})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_J) [ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][hero] accepted\n[CN]the job request!", french="[CN][hero] accepte\n[CN]la mission!", german="[CN][hero] hat den\n[CN]Job angenommen!", italian="[CN][hero] ha accettato\n[CN]la missione!", spanish="[CN]¡[hero] ha aceptado\n[CN]la misión!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Thank you so much!\nI'll try my best too!", french="Merci infiniment!\nJe vais tâcher de faire de mon mieux,\nmoi aussi!", german="Vielen, vielen Dank! Auch ich\nwerde mein Bestes geben!", italian="Grazie tante!\nAnch'io farò del mio meglio!", spanish="¡Muchísimas gracias!\n¡Yo también voy a darlo todo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Your Job List is full,\n[CN]so you cannot accept it.", french="[CN]Votre Liste de Missions est pleine,\n[CN]donc vous ne pouvez pas l'accepter.", german="[CN]Die Jobliste ist voll, daher kannst\n[CN]du die Anfrage nicht akzeptieren.", italian="[CN]La tua lista delle missioni è piena,\n[CN]quindi non puoi accettarla.", spanish="[CN]Tu lista de misiones está llena,\n[CN]así que no puedes aceptarla."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  elseif __sw == 3 or __sw == 4 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Yay! Yay!\nI get to explore with Team [team:]!\nLet's do our best!", french="Yahou! Hourra!\nJe pars en exploration avec l'Equipe\n[team:]! Faisons de notre mieux!", german="Juchhu! Juchhu!\nIch werde mit Team [team:] auf\nErkundung gehen! Geben wir unser Bestes!", italian="Evviva! Urrà!\nAndrò in esplorazione con il Team\n[team:]! Facciamo del nostro meglio!", spanish="¡Yupiiii!\n¡Me voy a explorar con el [CS:X]Equipo[CR] [team:]!\n¡A por todas!"})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Team [team:]!\nWill you take me exploring with you?", french="Equipe [team:]!\nVous voulez bien m'emmener\navec vous en exploration?", german="Team [team:]!\nWerdet ihr mich mit auf Erkundung nehmen?", italian="Team [team:]!\nPosso unirmi alla vostra\nsquadra d'esplorazione?", spanish="¡[CS:X]Equipo[CR] [team:]!\n¿Me lleváis de exploración?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back2_SetMode(7) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to accept this job request?", french="[CN]Voulez-vous accepter la mission?", german="[CN]Nimmst du diese Job-Anfrage an?", italian="[CN]Vuoi accettare questa missione?", spanish="[CN]¿Quieres aceptar esta misión?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Aah...\nI really wanted to explore with you,\nTeam [team:].", french="Aah...\nJ'avais vraiment envie d'explorer avec vous,\nEquipe [team:].", german="Ooh...\nIch möchte wirklich gerne mit euch auf\nErkundung gehen, Team [team:].", italian="Aaah...\nMi sarebbe piaciuto così tanto partecipare\na un'esplorazione del Team [team:].", spanish="Vaya...\nCon las ganas que tenía yo de explorar\ncon el [CS:X]Equipo[CR] [team:]."})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_J) [ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][hero] accepted\n[CN]the job request!", french="[CN][hero] accepte\n[CN]la mission!", german="[CN][hero] hat den\n[CN]Job angenommen!", italian="[CN][hero] ha accettato\n[CN]la missione!", spanish="[CN]¡[hero] ha aceptado\n[CN]la misión!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="You'll really go with me?\nOK then. Let's do our best!", french="Vraiment, vous acceptez?\nTrès bien, dans ce cas, faisons\nde notre mieux!", german="Ihr kommt wirklich mit?\nSuper. Lasst uns unser Bestes geben!", italian="Davvero verrete con me?\nPerfetto. Diamoci dentro allora!", spanish="¿De verdad vais a ir conmigo?\n¡Bueno, pues vamos a darlo todo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Your Job List is full,\n[CN]so you cannot accept it.", french="[CN]Votre Liste de Missions est pleine,\n[CN]donc vous ne pouvez pas l'accepter.", german="[CN]Die Jobliste ist voll, daher kannst\n[CN]du die Anfrage nicht akzeptieren.", italian="[CN]La tua lista delle missioni è piena,\n[CN]quindi non puoi accettarla.", spanish="[CN]Tu lista de misiones está llena,\n[CN]así que no puedes aceptarla."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  elseif __sw == 5 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I'm so relieved...\nNow I'll be able to go there...", french="Quel soulagement...\nMaintenant, je vais pouvoir entrer là-dedans...", german="Ich bin so erleichtert...\nJetzt werde ich endlich dorthin können...", italian="Che sollievo...\nOra potrò visitare quel dungeon...", spanish="Qué alivio...\nAsí podré ir allí..."})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="There's a place I really want\nto visit.", french="Il y a un endroit que je tiens\nabsolument à visiter.", german="Es gibt da einen Ort, den ich\nwirklich gern besuchen möchte.", italian="C'è un luogo che vorrei tanto\nvisitare.", spanish="Hay un sitio que tengo muchas\nganas de visitar."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="But I'm scared to explore a\ndungeon by myself.", french="Mais j'ai peur d'explorer\nun donjon sans assistance.", german="Aber ich traue mich nicht, auf\neigene Faust einen Dungeon zu erkunden.", italian="Ma ho paura di esplorare\nun dungeon per conto mio.", spanish="Pero me da miedo explorar un\nterritorio por mi cuenta."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I'd really like it if you could\ncome with me, Team [team:]...", french="J'aimerais vraiment ça, si vous\npouviez m'accompagner, Equipe [team:]...", german="Daher würde es mir wirklich\ngefallen, wenn ihr mit mir kommen könntet,\nTeam [team:]...", italian="Apprezzerei molto se poteste\nvenire con me, Team [team:]...", spanish="Me encantaría que vinierais\nconmigo, [CS:X]Equipo[CR] [team:]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back2_SetMode(7) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to accept this job request?", french="[CN]Voulez-vous accepter la mission?", german="[CN]Nimmst du diese Job-Anfrage an?", italian="[CN]Vuoi accettare questa missione?", spanish="[CN]¿Aceptas esta misión?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="...I see. You can't help...\nIt's not a good idea to go alone...", french="... Je vois. Vous ne pouvez\npas m'aider. Ce n'est pas une bonne idée de\nm'aventurer là-bas sans aide.", german="Verstehe, keine Hilfe von euch...\nAber es ist keine gute Idee, allein zu gehen...", italian="... Capisco. Non potete aiutarmi.\nMa andare per conto mio non mi sembra\nuna buona idea...", spanish="Entiendo, no podéis ayudarme...\nNo es buena idea ir sin nadie más..."})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_J) [ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][hero] accepted\n[CN]the job request!", french="[CN][hero] accepte\n[CN]la mission!", german="[CN][hero] hat den\n[CN]Job angenommen!", italian="[CN][hero] ha accettato\n[CN]la missione!", spanish="[CN]¡[hero] ha aceptado\n[CN]la misión!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Really?! Thank you so much!\nI'll do my best to help and stay out of the way!", french="Vraiment? Merci beaucoup!\nJe ferai de mon mieux pour aider\net pour éviter de vous freiner!", german="Wirklich?!? Oh, vielen Dank!\nIch werde versuchen, eine Hilfe zu sein und\nnicht im Wege herumzustehen!", italian="Davvero?! Oh, grazie mille!\nFarò del mio meglio per non intralciarvi!", spanish="¡¿De verdad?! ¡Muchas gracias!\nHaré todo lo posible por no estorbar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Your Job List is full,\n[CN]so you cannot accept it.", french="[CN]Votre Liste de Missions est pleine,\n[CN]donc vous ne pouvez pas l'accepter.", german="[CN]Die Jobliste ist voll, daher kannst\n[CN]du die Anfrage nicht akzeptieren.", italian="[CN]La tua lista delle missioni è piena,\n[CN]quindi non puoi accettarla.", spanish="[CN]Tu lista de misiones está llena,\n[CN]así que no puedes aceptarla."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  elseif __sw == 10 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_SUB_TYPE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_SUB_TYPE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 4 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="ZZZT! I'll meet you inside the\ndungeon entrance, and we can apprehend\nthem together! ZZZT!", french="ZZZT! On se retrouve à l'entrée\ndu donjon. Nous pourrons alors attraper\nensemble ce hors-la-loi! ZZZT!", german="ZZZT! Ich werde auf euch am\nEingang des Dungeons warten, und wir gehen\ndann gemeinsam auf Fahndung! ZZZT!", italian="ZZZT! Incontriamoci all'ingresso\ndel dungeon, così potremo catturare quel\nPokémon insieme! ZZZT!", spanish="¡Bzz! Os espero en la entrada\ndel territorio para que podamos apresarlo\njuntos. ¡Bzz!"})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="ZZZT! Good day, Team\n[team:]. I have something I wish to\ndiscuss with you... ZZZT!", french="ZZZT! Bonjour, Equipe\n[team:]. Il y a une chose dont j'aimerais\ndiscuter avec vous... ZZZT!", german="ZZZT! Guten Tag,\nTeam [team:]. Ich muss etwas mit\neuch besprechen... ZZZT!", italian="ZZZT! Buongiorno,\nTeam [team:]. C'è qualcosa di cui vorrei\ndiscutere con voi... ZZZT!", spanish="¡Bzz! Buenos días, [CS:X]Equipo[CR]\n[team:], me gustaría hablaros de algo...\n¡Bzz!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="ZZZT! No matter how hard I've\ntried, I cannot seem to catch [c_name:RANDOM_REQUEST_NPC02]\nalone. Will you assist me? ZZZT!", french="ZZZT! J'ai beau essayer,\nje n'arrive pas à attraper [c_name:RANDOM_REQUEST_NPC02]\ntout seul. Vous voulez bien m'aider? ZZZT!", german="ZZZT! Wie sehr ich mich auch\nanstrenge, ich schaffe es nicht, [c_name:RANDOM_REQUEST_NPC02]\nallein zu fangen. Könnt ihr mir helfen? ZZZT!", italian="ZZZT! Ho provato a catturare\n[c_name:RANDOM_REQUEST_NPC02] in ogni modo, ma riesce sempre\na sfuggirmi. Potete aiutarmi? ZZZT!", spanish="¡Bzz! Por más que lo intento, no\nencuentro la forma de atrapar a [c_name:RANDOM_REQUEST_NPC02]\nyo solo. ¿Me podéis ayudar? ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back2_SetMode(7) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to accept this job request?", french="[CN]Voulez-vous accepter la mission?", german="[CN]Nimmst du diese Job-Anfrage an?", italian="[CN]Vuoi accettare questa missione?", spanish="[CN]¿Aceptas esta misión?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="ZZZT! I see...\nIf Team [team:] is too busy, then I'll\nhave to ask someone else... ZZZT!", french="ZZZT! Je vois... Si l'Equipe\n[team:] est trop occupée, je vais devoir\nchercher de l'aide ailleurs. ZZZT!", german="ZZZT! Verstehe...\nWenn Team [team:] zu beschäftigt ist,\nmuss ich jemand anderes fragen... ZZZT!", italian="ZZZT! Capisco...\nSe il Team [team:] è troppo impegnato,\nallora dovrò chiedere a qualcun altro... ZZZT!", spanish="¡Bzz! Entiendo...\nSi el [CS:X]Equipo[CR] [team:] está demasiado\nocupado, tendré que pedírselo a otro... ¡Bzz!"})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_J) [ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][hero] accepted\n[CN]the job request!", french="[CN][hero] accepte\n[CN]la mission!", german="[CN][hero] hat den\n[CN]Job angenommen!", italian="[CN][hero] ha accettato\n[CN]la missione!", spanish="[CN]¡[hero] ha aceptado\n[CN]la misión!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="ZZZT! Thank you very much!\nI appreciate your assistance! ZZZT!", french="ZZZT! Merci beaucoup!\nJ'apprécie votre aide! ZZZT!", german="ZZZT! Vielen Dank dafür!\nIch schätze eure Unterstützung sehr! ZZZT!", italian="ZZZT! Grazie mille!\nApprezzo molto il vostro aiuto! ZZZT!", spanish="¡Bzz! ¡Muchas gracias!\n¡Agradezco vuestra ayuda! ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Your Job List is full,\n[CN]so you cannot accept it.", french="[CN]Votre Liste de Missions est pleine,\n[CN]donc vous ne pouvez pas l'accepter.", german="[CN]Die Jobliste ist voll, daher kannst\n[CN]du die Anfrage nicht akzeptieren.", italian="[CN]La tua lista delle missioni è piena,\n[CN]quindi non puoi accettarla.", spanish="[CN]Tu lista de misiones está llena,\n[CN]así que no puedes aceptarla."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  elseif true then -- default
  -- @label_13 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="ZZZT! Thank you for your\ncontinued assistance! ZZZT!", french="ZZZT! Merci pour votre aide\nindéfectible! ZZZT!", german="ZZZT! Vielen Dank für eure\nfortwährende Unterstützung! ZZZT!", italian="ZZZT! Grazie per tutto l'aiuto\nche continuate a fornire! ZZZT!", spanish="¡Bzz! Gracias por vuestra\ninestimable ayuda. ¡Bzz!"})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="ZZZT! Hello, Team [team:].\nThank you for your continuing assistance in\ncapturing outlaws. ZZZT!", french="ZZZT! Bonjour,\nEquipe [team:]. Merci pour votre aide\ndans la capture des hors-la-loi. ZZZT!", german="ZZZT! Hallo, Team [team:].\nVielen Dank für eure fortwährende Hilfe,\nGanoven zu stellen. ZZZT!", italian="ZZZT! Salve, Team\n[team:]. Grazie per tutto l'aiuto che\nfornite per la cattura dei ricercati. ZZZT!", spanish="¡Bzz! Hola, [CS:X]Equipo[CR] [team:].\nMuchas gracias por vuestra inestimable\nayuda capturando malhechores. ¡Bzz!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="ZZZT! Today, I would like you\nto search for and apprehend [c_name:RANDOM_REQUEST_NPC02]...\nCan you assist me? ZZZT!", french="ZZZT! Aujourd'hui\nj'aimerais que vous appréhendiez [c_name:RANDOM_REQUEST_NPC02].\nVous pouvez m'aider? ZZZT!", german="ZZZT! Heute würde ich euch\nbitten, [c_name:RANDOM_REQUEST_NPC02] zu verhaften... Kann ich\nmit eurer Unterstützung rechnen? ZZZT!", italian="ZZZT! Oggi vorrei chiedervi di\ncercare e arrestare [c_name:RANDOM_REQUEST_NPC02]...\nPotete aiutarmi? ZZZT!", spanish="¡Bzz! Hoy me gustaría que\nencontrarais y apresarais a [c_name:RANDOM_REQUEST_NPC02]...\n¿Podéis ayudarme? ¡Bzzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back2_SetMode(7) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to accept this job request?", french="[CN]Voulez-vous accepter la mission?", german="[CN]Nimmst du diese Job-Anfrage an?", italian="[CN]Vuoi accettare questa missione?", spanish="[CN]¿Aceptas esta misión?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="ZZZT! I see... There's no way\naround it. Team [team:] is busy too.\nZZZT!", french="ZZZT! Je vois... C'est sans\nissue. L'Equipe [team:] est trop occupée,\nelle aussi. ZZZT!", german="ZZZT! Ich verstehe... Dann gibt\nes leider keine Alternative. Team [team:]\nist auch beschäftigt. ZZZT!", italian="ZZZT! Capisco... Non c'è niente\nda fare. Anche il Team [team:] è\nimpegnato. ZZZT!", spanish="¡Bzz! Entiendo... No hay nada que\nhacer. El [CS:X]Equipo[CR] [team:] también está\nocupado. ¡Bzz!"})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_J) [ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][hero] accepted\n[CN]the job request!", french="[CN][hero] accepte\n[CN]la mission!", german="[CN][hero] hat den\n[CN]Job angenommen!", italian="[CN][hero] ha accettato\n[CN]la missione!", spanish="[CN]¡[hero] ha aceptado\n[CN]la misión!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="ZZZT! Thank you for your\ncontinued assistance! ZZZT!", french="ZZZT! Merci pour votre aide\nindéfectible! ZZZT!", german="ZZZT! Vielen Dank für eure\nfortwährende Unterstützung! ZZZT!", italian="ZZZT! Grazie per tutto l'aiuto\nche continuate a fornire! ZZZT!", spanish="¡Bzz! Gracias por vuestra\ninestimable ayuda. ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Your Job List is full,\n[CN]so you cannot accept it.", french="[CN]Votre Liste de Missions est pleine,\n[CN]donc vous ne pouvez pas l'accepter.", german="[CN]Die Jobliste ist voll, daher kannst\n[CN]du die Anfrage nicht akzeptieren.", italian="[CN]La tua lista delle missioni è piena,\n[CN]quindi non puoi accettarla.", spanish="[CN]Tu lista de misiones está llena,\n[CN]así que no puedes aceptarla."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  end
  end
  elseif __sw == 6 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_SUB_TYPE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_SUB_TYPE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 4 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Please, for my friend, bring me\na [CS:I]Gabite Scale[CR]!\nPlease!", french="Je vous en prie, pour sauver\nmon ami, apportez-moi une [CS:I]Carmachécaille[CR]!\nS'il vous plaît!", german="Bitte, bringt mir eine\n[CS:I]Kna-Schuppe[CR] für meinen Freund! Bitte!", italian="Vi prego, fatelo per il mio\namico... Portatemi una [CS:I]Gabitesquama[CR]!\nPer favore!", spanish="¡Por favor, tráeme una\n[CS:I]Gabitescama[CR], hazlo por mi amigo!\n¡Te lo suplico!"})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  if ((SV.SkyTalkBitFlags or {})[1] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[1]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Hey, Team [team:]!\nDo you think you could lend me a hand?", french="Hé, Equipe [team:]!\nVous pensez que vous pourriez me donner\nun coup de main?", german="Also, Team [team:]!\nGlaubt ihr, das ihr mir helfen könnt?", italian="Ehi, Team [team:]!\nPotreste darmi una mano?", spanish="Bueno, [CS:X]Equipo[CR] [team:].\n¿Me echaríais una mano?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- @label_71 [étiquette de flux ExplorerScript]
  -- back2_SetMode(7) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to accept this job request?", french="[CN]Voulez-vous accepter la mission?", german="[CN]Nimmst du diese Job-Anfrage an?", italian="[CN]Vuoi accettare questa missione?", spanish="[CN]¿Aceptas esta misión?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" WHAAAAT?!", french=" QUOIIIII?!", german=" Waaaas?!?", italian=" COOOSAAA?!", spanish=" ¡¿Quéeeee?!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I really thought that if anyone\nwould help me, it would definitely be\nTeam [team:]!", french="Je pensais que s'il y avait\nune équipe disposée à m'aider,\nce serait bien l'Equipe [team:]!", german="Ich dachte wirklich, wenn mir\njemand helfen würde, dann Team [team:]!", italian="Eppure credevo che se mai fosse\nesistita una squadra che poteva aiutarmi, quella\nsarebbe stata proprio il Team [team:]!", spanish="Pues pensaba que, si alguien\npodía ayudarme, sería el [CS:X]Equipo[CR] [team:]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="That's too bad...\nMaybe a different exploration team will help...", french="Quel dommage...\nPeut-être qu'une autre équipe d'exploration\nvoudra bien m'aider...", german="Oh, zu schade...\nVielleicht wird mir ja ein anderes\nErkundungsteam helfen...", italian="Peccato...\nForse qualche altra squadra d'esplorazione\nmi darà una mano...", spanish="Qué pena...\nIgual me ayuda otro equipo explorador..."})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_J) [ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][hero] accepted\n[CN]the job request!", french="[CN][hero] accepte\n[CN]la mission!", german="[CN][hero] hat den\n[CN]Job angenommen!", italian="[CN][hero] ha accettato\n[CN]la missione!", spanish="[CN]¡[hero] ha aceptado\n[CN]la misión especial!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Thank you so very much!\nYou've made me very happy!", french="Merci beaucoup!\nÇa me fait très plaisir!", german="Vielen, vielen Dank euch!\nIhr habt mich sehr glücklich gemacht!", italian="Grazie mille, davvero!\nSono veramente felice!", spanish="¡Muchísimas gracias!\n¡Me habéis hecho muy feliz!"})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Your Job List is full,\n[CN]so you cannot accept it.", french="[CN]Votre Liste de Missions est pleine,\n[CN]donc vous ne pouvez pas l'accepter.", german="[CN]Die Jobliste ist voll, daher kannst\n[CN]du die Anfrage nicht akzeptieren.", italian="[CN]La tua lista delle missioni è piena,\n[CN]quindi non puoi accettarla.", spanish="[CN]Tu lista de misiones está llena,\n[CN]así que no puedes aceptarla."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[1] = 1 -- $SCENARIO_TALK_BIT_FLAG[1] = 1 (ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Hey, Team [team:]!\nDo you think you could lend me a hand?", french="Hé, Equipe [team:]!\nVous pensez que vous pourriez me donner\nun coup de main?", german="Hey, Team [team:]!\nOb ihr mir wohl bei etwas helfen könntet?", italian="Ehi, Team [team:]!\nPotreste darmi una mano?", spanish="¡Hola, [CS:X]Equipo[CR] [team:]!\n¿Podríais echarme una manita?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I am in need of one more\n[CS:I]Gabite Scale[CR] to save my sick friend.", french="Il me manque une\n[CS:I]Carmachécaille[CR] pour sauver mon ami\nqui est malade.", german="Ich brauche noch eine\n[CS:I]Kna-Schuppe[CR], um meinen kranken\nFreund zu heilen.", italian="Ho bisogno di un'altra\n[CS:I]Gabitesquama[CR] per aiutare il mio amico\nammalato.", spanish="Me falta una [CS:I]Gabitescama[CR]\npara salvar a un amigo enfermo."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It's said that when [CS:N]Gabite[CR] admits\nthe strength of a team, it spares a [CS:I]Gabite\nScale[CR] as a token of appreciation.", french="On dit que lorsque [CS:N]Carmache[CR]\nreconnaît la valeur d'une équipe, il offre une\n[CS:I]Carmachécaille[CR] en signe d'appréciation.", german="Man erzählt, dass [CS:N]Knarksel[CR] im\nKampf eine [CS:I]Kna-Schuppe[CR] abwirft, um der\nStärke eines Teams zu huldigen.", italian="Si dice che quando [CS:N]Gabite[CR]\nriconosce la forza di una squadra, cede\nuna [CS:I]Gabitesquama[CR] come ricompensa.", spanish="Se dice que, cuando [CS:N]Gabite[CR]\nadmite la pericia de un equipo, le regala una\n[CS:I]Gabitescama[CR] en reconocimiento."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:N]Gabite[CR] can be found in the\ndepths of [CS:P]Labyrinth Cave[CR]! Please get a\n[CS:I]Gabite Scale[CR] for me!", french="Vous pouvez trouver [CS:N]Carmache[CR]\ndans les profondeurs de la [CS:P]Grotte Labyrinthe[CR].\nSoyez gentils, amenez-moi une [CS:I]Carmachécaille[CR]!", german="[CS:N]Knarksel[CR] haust in den Tiefen der\n[CS:P]Labyrinthhöhle[CR]! Bitte besorgt mir eine\n[CS:I]Kna-Schuppe[CR]!", italian="[CS:N]Gabite[CR] dimora nelle profondità\ndella [CS:P]Grotta Labirinto[CR]! Vi prego, procuratemi\nuna [CS:I]Gabitesquama[CR]!", spanish="[CS:N]Gabite[CR] se encuentra en las\nprofundidades de la [CS:P]Cueva Laberinto[CR].\n¡Conseguidme una [CS:I]Gabitescama[CR], por favor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_71 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  elseif true then -- default
  -- @label_15 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="You know, everyone talks about\nhow Team [team:] is an incredible\nexploration team.", french="Vous savez, tout le monde parle\ndes exploits de l'Equipe [team:].", german="Wisst ihr, alle reden davon,\nwas für ein unglaubliches Erkundungsteam\nTeam [team:] ist.", italian="Sapete, tutti parlano di quanto\nsia fantastico il Team [team:].", spanish="Todo el mundo habla de lo\nincreíblemente bien que explora el\n[CS:X]Equipo[CR] [team:]."})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I heard that Team [team:]\nis a great exploration team. Is it true?", french="J'ai entendu dire que\nl'Equipe [team:] est une grande équipe\nd'exploration. C'est vrai?", german="Ich habe gehört, dass Team\n[team:] ein großartiges Erkundungsteam\nist. Stimmt das?", italian="Mi è giunta voce che\nil Team [team:] è una squadra di\nesplorazione eccezionale. È vero?", spanish="He oído que el [CS:X]Equipo[CR]\n[team:] explora de maravilla, ¿es cierto?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="If it is, I'd like you to retrieve\nan item for me...", french="Si c'est le cas, j'aimerais que\nvous récupériez un objet pour moi...", german="Wenn das so ist, würde ich euch\nbitten, mir ein Item zurückzubringen...", italian="Se è così, vorrei che\nrecuperaste uno strumento per me...", spanish="Si es así, me gustaría que\nrecuperarais un objeto mío..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back2_SetMode(7) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to accept this job request?", french="[CN]Voulez-vous accepter la mission?", german="[CN]Nimmst du diese Job-Anfrage an?", italian="[CN]Vuoi accettare questa missione?", spanish="[CN]¿Aceptas esta misión?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Hmm...\nI knew you were that kind of exploration team.", french="Hmm...\nJe savais bien que vous étiez ce genre\nd'équipe d'exploration.", german="Hmm... Ich dachte mir schon,\ndass ihr so ein Erkundungsteam seid.", italian="Mmmh...\nPensavo che foste la squadra d'esplorazione\nperfetta per risolvere il mio problema.", spanish="Hum... Ya sabía yo que erais\nde ese tipo de equipo explorador."})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_J) [ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][hero] accepted\n[CN]the job request!", french="[CN][hero] accepte\n[CN]la mission!", german="[CN][hero] hat den\n[CN]Job angenommen!", italian="[CN][hero] ha accettato\n[CN]la missione!", spanish="[CN]¡[hero] ha aceptado\n[CN]la misión!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Thank you!\nI knew the rumors about the superb Team\n[team:] had to be true!", french="Merci!\nJe savais que les rumeurs évoquant la\nsuperbe Equipe [team:] étaient fondées!", german="Vielen Dank! Ich wusste, dass\ndie Gerüchte über das erstklassige Team\n[team:] stimmen müssen!", italian="Grazie! Sapevo che le voci su\nquanto fosse incredibile il Team [team:]\nerano vere!", spanish="¡Gracias!\nSabía que los rumores sobre el magnífico\n[CS:X]Equipo[CR] [team:] tenían que ser ciertos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Your Job List is full,\n[CN]so you cannot accept it.", french="[CN]Votre Liste de Missions est pleine,\n[CN]donc vous ne pouvez pas l'accepter.", german="[CN]Die Jobliste ist voll, daher kannst\n[CN]du die Anfrage nicht akzeptieren.", italian="[CN]La tua lista delle missioni è piena,\n[CN]quindi non puoi accettarla.", spanish="[CN]Tu lista de misiones está llena,\n[CN]así que no puedes aceptarla."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  end
  end
  elseif __sw == 11 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Team [team:] must be an\nincredible team to take on a challenge like that.", french="L'Equipe [team:] doit être\nune équipe incroyable pour oser relever\nun défi de cette envergure.", german="Team [team:] scheint mir\nein unglaubliches Team zu sein,\nHerausforderungen wie diese anzunehmen.", italian="Il Team [team:] deve\nessere davvero coraggioso se accetta\nuna sfida simile.", spanish="El [CS:X]Equipo[CR] [team:] debe de\nser increíble para aceptar un reto así."})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Are you Team [team:]?", french=" Vous êtes l'Equipe [team:]?", german=" Seid ihr Team [team:]?", italian=" Siete voi il Team [team:]?", spanish=" ¿Sois el [CS:X]Equipo[CR] [team:]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I was previously asked to give\nthis to you by [c_name:RANDOM_REQUEST_NPC01].", french="[c_name:RANDOM_REQUEST_NPC01] m'a demandé\nde vous confier ceci tout à l'heure.", german="Mir wurde aufgetragen, euch\ndas hier von [c_name:RANDOM_REQUEST_NPC01] zu geben.", italian="Prima [c_name:RANDOM_REQUEST_NPC01] mi ha\nchiesto di consegnarvi questa.", spanish="[c_name:RANDOM_REQUEST_NPC01] me ha pedido\nque os dé esto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back2_SetMode(7) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Wha--[K] This! No matter how you look at it,\n[CN]it's a Challenge Letter!", french="[CN]Que...[K] Ça alors! Impossible de se tromper!\n[CN]C'est une Lettre Défi!", german="[CN]Oooh...[K] Das hier! Wie du es auch drehst\n[CN]und wendest, es ist ein Herausforderungsbrief!", italian="[CN]Ma cos...?[K] Ah! Ma sì, non c'è dubbio...\n[CN]È una Lettera sfida!", spanish="[CN]Pero...[K] ¡Guau! ¡Se mire por donde se mire,\n[CN]es una carta de desafío!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to accept this challenge?", french="[CN]Voulez-vous relever ce défi?", german="[CN]Nimmst du diese Herausforderung an?", italian="[CN]Vuoi accettare questa sfida?", spanish="[CN]¿Aceptas este reto?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Huh? Oh no!\nYou have to take it! What would I do with it?", french="Hein? Oh non!\nVous devez relever ce défi! Qu'est-ce que\nje vais en faire, sinon?", german="Was? Oh nein! Ihr müsst es\nannehmen! Was soll ich denn sonst damit tun?", italian="Eh? Oh no!\nDovete prenderla! Che me ne faccio io?", spanish="¿Cómo? ¡No, no!\nTenéis que aceptar, ¿qué hago yo con esto?"})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_J) [ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][hero] accepted\n[CN]the challenge!", french="[CN][hero] accepte de relever\n[CN]le défi!", german="[CN][hero] hat die\n[CN]Herausforderung angenommen!", italian="[CN][hero] ha accettato\n[CN]la missione!", spanish="[CN]¡[hero] ha aceptado\n[CN]la misión!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="So we're clear. I've definitely\ndelivered the letter.", french="Alors on est quittes. J'ai livré\nla lettre comme on me l'a demandé.", german="Damit habe ich meine Pflicht\ngetan und den Brief zugestellt.", italian="Allora siamo a posto.\nIo la lettera ve l'ho consegnata.", spanish="Bueno, ya está, yo ya he\nhecho mi trabajo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Your Job List is full,\n[CN]so you cannot accept it.", french="[CN]Votre Liste de Missions est pleine,\n[CN]donc vous ne pouvez pas l'accepter.", german="[CN]Die Jobliste ist voll, daher kannst\n[CN]du die Anfrage nicht akzeptieren.", italian="[CN]La tua lista delle missioni è piena,\n[CN]quindi non puoi accettarla.", spanish="[CN]Tu lista de misiones está llena,\n[CN]así que no puedes aceptarla."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Oh? I must've been mistaken...", french=" Oh? J'ai dû faire erreur...", german="Oh, wirklich? Dann habe ich\nmich wohl geirrt...", italian=" Oh? Forse ho capito male...", spanish=" Vaya, me habré equivocado..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  elseif __sw == 14 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Huh? You want to know who the\nMission came from?", french="Hein? Vous voulez savoir de qui\nprovient cette mission?", german="Wie bitte? Du willst wissen, wer\nder Auftraggeber ist?", italian="Eh? Volete sapere chi vi ha\naffidato questo Incarico?", spanish="¿Cómo? ¿Que queréis saber\nde quién proviene la misión?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I don't really know who it was,\nbut he was a Pokémon who had a very odd\nmanner of speaking.", french="Je ne sais pas vraiment, mais\nc'était un Pokémon qui parlait\ntrès bizarrement.", german="Ich weiß wirklich nicht, wer es\nwar. Aber es war ein Pokémon mit einer\nsonderbaren Art, zu reden.", italian="Non ho idea di chi fosse, ma era\nun Pokémon che parlava in modo molto strano.", spanish="Pues no sé quién era, pero se\ntrataba de un Pokémon que hablaba\nde una forma rarísima."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Why couldn't he hand it over on\nhis own? It's really strange.", french="Pourquoi ne vous a-t-il pas\ndonné ce message lui-même?\nTout ça est bien étrange.", german="Warum konnte es das wohl nicht\nselbst überbringen? Wirklich eigenartig.", italian="Perché mai non avrà voluto\nconsegnarvelo di persona? Che strano.", spanish="¿Que por qué no podía entregar\nesto él? Pues es muy extraño, sí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  if ((SV.SkyTalkBitFlags or {})[1] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[1]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Earlier, a strange Pokémon\nappeared and asked me to give this to\nTeam [team:].", french="Tout à l'heure, un étrange\nPokémon est apparu et m'a demandé de donner\nceci à l'Equipe [team:].", german="Vorhin tauchte ein sonderbares\nPokémon auf und hat mich gebeten, Team\n[team:] das hier zu überreichen.", italian="Poco fa è comparso uno strano\nPokémon e mi ha chiesto di consegnare questo\nal Team [team:].", spanish="Antes apareció un Pokémon\ndesconocido que me pidió que le diera esto\nal [CS:X]Equipo[CR] [team:]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It won't do any good in my\npossession. You should take it.", french="A moi, ça ne me sert à rien.\nVous devriez le prendre.", german="Nehmt es besser. Es bringt mir\nnichts, wenn ich es behalte.", italian="Io non me ne faccio niente.\nFareste meglio a prenderlo voi.", spanish="A mí no me sirve para nada,\ntenéis que cogerlo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- @label_65 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][hero] read the\n[CN]paper.", french="[CN][hero] lit\n[CN]le message.", german="[CN][hero] liest die\n[CN]überreichte Notiz.", italian="[CN][hero] legge\n[CN]il messaggio.", spanish="[CN][hero] lee\n[CN]la nota."})
  -- message_Close
  -- back2_SetMode(7) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]To Team [team:],\n[CN]From Exploration Team Federation!", french="[CN]A l'attention de l'Equipe [team:],\n[CN]de la Fédération des Equipes d'Exploration!", german="[CN]An Team [team:]!\n[CN]Vom Erkundungsteamverband!", italian="[CN]Al Team [team:],\n[CN]dalla Federazione Squadre d'Esplorazione!", spanish="[CN]Al [CS:X]Equipo[CR] [team:],\n[CN]de la Federación de Exploradores."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]This is a Special Mission\n[CN]assigned only to Secret Rank\n[CN]exploration teams!", french="[CN]Ceci est une Mission Spéciale\n[CN]confiée uniquement aux équipes d'exploration\n[CN]ayant atteint le Grade Secret!", german="[CN]Dies ist eine Spezialmission,\n[CN]die nur Erkundungsteams mit\n[CN]Geheim-Rang aufgetragen wird!", italian="[CN]Questo è un Incarico Speciale\n[CN]che possono svolgere solo le\n[CN]squadre d'esplorazione di Rango Segreto!", spanish="[CN]Esta es una misión especial que\n[CN]solo se asigna a equipos exploradores\n[CN]de Rango Secreto."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Act promptly!\n[CN]That's all!", french="[CN]Agissez promptement!\n[CN]C'est tout!", german="[CN]Handelt zeitnah!\n[CN]Das ist alles!", italian="[CN]Agite subito!\n[CN]È tutto!", spanish="[CN]¡Actuad de inmediato!\n[CN]Eso es todo."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN].....................[K]\n[CN]Would you like to accept this Mission?", french="[CN].....................[K]\n[CN]Voulez-vous accepter cette mission?", german="[CN].....................[K]\n[CN]Nimmst du diese Mission an?", italian="[CN].....................[K]\n[CN]Vuoi accettare questo Incarico?", spanish="[CN]...[K]\n[CN]¿Aceptas esta misión?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][hero]\n[CN]declined the Special Mission.", french="[CN][hero]\n[CN]décline la Mission Spéciale.", german="[CN][hero]\n[CN]hat die Spezialmission abgelehnt.", italian="[CN][hero] ha rifiutato\n[CN]l'Incarico Speciale!", spanish="[CN][hero]\n[CN]ha rechazado la misión especial."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Huh?\nYou won't take it?!", french="Hein?\nVous la déclinez?!", german="Wie bitte?\nDu nimmst sie nicht an?!?", italian="Come?\nNon lo volete accettare?!", spanish="¿Cómo?\n¡¿Que no la aceptáis?!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="So, what am I supposed to do\nwith this, then?!", french="Bon, et qu'est-ce que vous\nvoulez que je fasse avec ça, alors?", german="Was soll ich dann\nhiermit machen?!?", italian="E adesso? Cosa dovrei farci io\ncon questo?!", spanish="Y qué se supone que tengo\nque hacer con esto, ¡¿eh?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_J) [ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][hero]\n[CN]accepted the Special Mission!", french="[CN][hero] accepte\n[CN]la Mission Spéciale!", german="[CN][hero]\n[CN]hat die Spezialmission angenommen!", italian="[CN][hero] ha accettato\n[CN]l'Incarico Speciale!", spanish="[CN]¡[hero] ha aceptado\n[CN]la misión especial!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Your Job List is full,\n[CN]so you cannot accept it.", french="[CN]Votre Liste de Missions est pleine,\n[CN]donc vous ne pouvez pas l'accepter.", german="[CN]Die Jobliste ist voll, daher kannst\n[CN]du die Anfrage nicht akzeptieren.", italian="[CN]La tua lista delle missioni è piena,\n[CN]quindi non puoi accettarlo.", spanish="[CN]Tu lista de misiones está llena,\n[CN]así que no puedes aceptarla."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[1] = 1 -- $SCENARIO_TALK_BIT_FLAG[1] = 1 (ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Hey, Team [team:]!\nYou've arrived at just the right time.", french="Hé, Equipe [team:]!\nVous arrivez à point nommé.", german="Hey, Team [team:]!\nIhr seid gerade zur rechten Zeit gekommen.", italian="Ehi, Team [team:]!\nSiete arrivati proprio al momento giusto.", spanish="¡Anda, el [CS:X]Equipo[CR] [team:]!\nHabéis llegado en el momento perfecto."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Earlier, a strange Pokémon\nappeared and asked me to give this to\nTeam [team:].", french="Tout à l'heure, un étrange\nPokémon est apparu et m'a demandé de donner\nceci à l'Equipe [team:].", german="Vorhin tauchte ein sonderbares\nPokémon auf und hat mich gebeten, Team\n[team:] das hier zu überreichen.", italian="Poco fa è comparso uno strano\nPokémon e mi ha chiesto di consegnare questo\nal Team [team:].", spanish="Antes apareció un Pokémon\ndesconocido que me pidió que le diera esto\nal [CS:X]Equipo[CR] [team:]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_65 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  elseif true then -- default
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_SUB_TYPE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_SUB_TYPE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I wrote down the location where\nit was stolen in a Job Letter.\nI'm depending on you!", french="J'ai écrit le nom de l'endroit où\non m'a volé mon objet sur cette\nLettre Mission. Je compte sur vous.", german="Ich habe den Ort des Diebstahls\nin einem Job-Brief vermerkt. Nun hängt es\nan euch!", italian="Ho annotato il luogo in cui\nè stato rubato in una Lettera missione.\nConto su di voi!", spanish="Os he escrito dónde me lo\nrobaron en una carta de misión.\n¡Confío en vuestra pericia!"})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Please listen. When I was\nwalking through a dungeon the other day,\nsomeone stole an item from me...", french="Ecoutez, s'il vous plaît!\nQuelqu'un m'a volé un objet alors que\nj'arpentais un donjon, l'autre jour...", german="Hört mir bitte zu. Als ich\nneulich im Dungeon spazieren ging, hat mir\njemand ein Item gestohlen...", italian="Vi prego, ascoltatemi. L'altro\ngiorno, mentre camminavo in un dungeon,\nqualcuno mi ha rubato uno strumento...", spanish="Escuchadme un momento.\nEl otro día, mientras atravesaba un\nterritorio, alguien me robó un objeto..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Huh? What did you say?\nYou'll really get my item back for me,\nTeam [team:]?", french="Alors? Qu'en dites-vous?\nVous allez récupérer l'objet pour moi,\nEquipe [team:]?", german="Habe ich richtig gehört? Ihr\nwerdet wirklich versuchen, mir das Item\nzurückzuholen, Team [team:]?", italian="Uh? Come dite?\nDavvero mi riporterete il mio strumento,\nTeam [team:]?", spanish="¿Cómo? ¿Qué has dicho?\n¿Que el [CS:X]Equipo[CR] [team:] va a recuperar\nmi objeto?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back2_SetMode(7) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to accept this job request?", french="[CN]Voulez-vous accepter la mission?", german="[CN]Nimmst du diese Job-Anfrage an?", italian="[CN]Vuoi accettare questa missione?", spanish="[CN]¿Aceptas esta misión?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh... It looks like we can't quite\nreach an agreement.", french="Oh... Apparemment, on ne\nparvient pas à s'entendre...", german="Oh, wie schade. Sieht so aus, als\nob wir nicht zusammenarbeiten werden.", italian="Oh... A quanto pare non\nriusciamo a trovare un accordo.", spanish="Vaya... Parece que no nos\nponemos de acuerdo."})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_J) [ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][hero] accepted\n[CN]the job request!", french="[CN][hero] accepte\n[CN]la mission!", german="[CN][hero] hat den\n[CN]Job angenommen!", italian="[CN][hero] ha accettato\n[CN]la missione!", spanish="[CN]¡[hero] ha aceptado\n[CN]la misión!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Thank you so much!\nI know it causes some inconvenience to you,\nso I'm glad you're kind enough to accept it!", french="Merci mille fois!\nJe sais que vous avez déjà bien d'autres\nsoucis, alors que vous acceptiez me ravit!", german="Oh, vielen Dank! Ich weiß, dass\nes euch Umstände bereitet, daher bin ich froh,\ndass ihr so nett seid, euch darum zu kümmern!", italian="Grazie mille! So che è una bella\nseccatura per voi, quindi apprezzo molto\nil fatto che abbiate deciso di aiutarmi!", spanish="¡Muchísimas gracias!\nEntiendo que pueda suponeros una molestia,\nasí que me alegra que seáis tan amables."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Your Job List is full,\n[CN]so you cannot accept it.", french="[CN]Votre Liste de Missions est pleine,\n[CN]donc vous ne pouvez pas l'accepter.", german="[CN]Die Jobliste ist voll, daher kannst\n[CN]du die Anfrage nicht akzeptieren.", italian="[CN]La tua lista delle missioni è piena,\n[CN]quindi non puoi accettarla.", spanish="[CN]Tu lista de misiones está llena,\n[CN]así que no puedes aceptarla."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  elseif true then -- default
  -- @label_11 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I know you can get back my\nitem, Team [team:]! I'm counting on you!", french="Je sais que vous allez mettre la\nmain sur mon objet, Equipe [team:]!\nJe compte sur vous!", german="Ich weiß, dass ihr mein Item\nzurückbekommen werdet, Team [team:]!\nIch zähle auf euch!", italian="Sapevo che avreste accettato\ndi riportare il mio strumento,\nTeam [team:]! Conto su di voi!", spanish="Sé que podéis recuperar mi\nobjeto, [CS:X]Equipo[CR] [team:].\n¡Cuento con vuestra ayuda!"})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Haaa... What'll I do...", french=" Haaa... Que vais-je faire?", german=" Oooh! Was soll ich nun machen...", italian=" Aaah... Che posso fare?", spanish=" Aaaaah... Qué voy a hacer..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Oh! Team [team:]!\nI've got something I wanted to ask you!", french="Oh! Equipe [team:]!\nJ'ai quelque chose à vous demander!", german="Oh! Team [team:]!\nIch habe etwas, das ich euch fragen wollte!", italian="Oh! Team [team:]!\nC'è qualcosa che vorrei chiedervi!", spanish="¡Anda, el [CS:X]Equipo[CR] [team:]!\nQuiero preguntaros una cosa."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[c_name:RANDOM_REQUEST_NPC02] took something of\nmine, and I'd really like it if you could track\nthem down and get it back for me?", french="[c_name:RANDOM_REQUEST_NPC02] a pris un de mes\nobjets et j'apprécierais beaucoup si vous\npouviez le poursuivre et récupérer mon bien.", german="[c_name:RANDOM_REQUEST_NPC02] hat mir etwas\nweggenommen und ich wollte euch fragen, ob\nihr es mir zurückholen könnt.", italian="Il Pokémon [c_name:RANDOM_REQUEST_NPC02] mi ha\nrubato uno strumento. Potreste rintracciarlo\ne farvi restituire il maltolto?", spanish="[c_name:RANDOM_REQUEST_NPC02] se ha llevado algo\nque es mío y me gustaría que lo recuperarais.\n¿Podríais hacerlo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back2_SetMode(7) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to accept this job request?", french="[CN]Voulez-vous accepter la mission?", german="[CN]Nimmst du diese Job-Anfrage an?", italian="[CN]Vuoi accettare questa missione?", spanish="[CN]¿Aceptas esta misión?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="That puts me in a difficult spot.\nHmm... What should I do...?", french="Voilà qui me place dans une\nsituation délicate... Hum... Comment faire...?", german="Das bringt mich in eine\nschwierige Lage. Hmm...\nWas soll ich nun machen?", italian="La vostra decisione mi mette in\ndifficoltà. Mmmh... Che posso fare adesso...?", spanish="Pues me ponéis en un aprieto.\nHum... ¿Qué puedo hacer?..."})
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(20)
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_J) [ProcessSpecial(PROCESS_SPECIAL_ACCEPT_RANDOM_NPC_JOB): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][hero] accepted\n[CN]the job request!", french="[CN][hero] accepte\n[CN]la mission!", german="[CN][hero] hat den\n[CN]Job angenommen!", italian="[CN][hero] ha accettato\n[CN]la missione!", spanish="[CN]¡[hero] ha aceptado\n[CN]la misión!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Thank you so very much!\nI am so grateful for your help!", french="Merci beaucoup!\nVotre aide est la bienvenue!", german="Vielen lieben Dank!\nIch bin so dankbar für eure Hilfe!", italian="Non so come ringraziarvi!\nApprezzo molto il vostro aiuto!", spanish="¡Muchísimas gracias!\n¡Os agradezco mucho vuestra ayuda!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Your Job List is full,\n[CN]so you cannot accept it.", french="[CN]Votre Liste de Missions est pleine,\n[CN]donc vous ne pouvez pas l'accepter.", german="[CN]Die Jobliste ist voll, daher kannst\n[CN]du die Anfrage nicht akzeptieren.", italian="[CN]La tua lista delle missioni è piena,\n[CN]quindi non puoi accettarla.", spanish="[CN]Tu lista de misiones está llena,\n[CN]así que no puedes aceptarla."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  end
  end
  end
  end
end
