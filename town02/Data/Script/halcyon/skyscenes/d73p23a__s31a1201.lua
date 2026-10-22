-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P23A/s31a1201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 16) -- $SCENARIO_MAIN = scn[29,16] (ROM)
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 232, 448, Direction.Up, "NPC_SHEIMI")
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We're almost to the\n3rd Station Clearing! Keep going!", french="Nous avons presque atteint\nla trouée du 3[F:E] Relais! Continuons d'avancer!", german="Wir sind schon fast bei der\n3. Zwischenlagerlichtung! Durchhalten!", italian="Abbiamo quasi raggiunto\nil Bivacco 3! Andiamo avanti!", spanish="¡Ya casi estamos en la Base del\nTercer Puerto! ¡Sigamos!"})
  -- message_Close
  -- back_SetGround(LEVEL_D73P23A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_D73P23A, 'US31') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(40) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(41) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(42) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(7) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(9) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Sky Peak Prairie.ogg", true) end)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_sheimi, 228, 284, false, 2)
  GROUND:MoveToPosition(hero, 228, 324, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 252, 316, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 204, 316, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Phew! The 3rd Station Clearing.", french=" Pfiou! La trouée du 3[F:E] Relais!", german="Puh!\nDie 3. Zwischenlagerlichtung.", italian=" Fiuuu! Eccoci al Bivacco 3.", spanish="Buf, al fin... ¡La Base del\nTercer Puerto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sheimi, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="By the way, [player].\nDid you happen to find any treasures called\n[CS:I]Sky Gift[CR]s while we were climbing?", french="Au fait, [player].\nEst-ce que tu as déjà trouvé un [CS:I]Don du Ciel[CR]\nlors de notre ascension?", german="Übrigens, [player], hast du\nzufällig schon ein [CS:I]Himmelspräsent[CR]\nwährend des Aufstiegs gefunden?", italian="A proposito, [player].\nDurante la nostra esplorazione, ti è capitato\ndi scoprire un tesoro chiamato [CS:I]Dono Cielo[CR]?", spanish="Por cierto, [player]...\n¿Por casualidad has encontrado algún tesoro\nllamado [CS:I]Regalo Cielo[CR] mientras ascendíamos?"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="A [CS:I]Sky Gift[CR] is a special kind of\ntreasure that can only be found on [CS:P]Sky Peak[CR].", french="Un [CS:I]Don du Ciel[CR] est un trésor\nparticulier qu'on ne trouve que sur\nle [CS:P]Pic Céleste[CR].", german="Ein [CS:I]Himmelspräsent[CR] ist ein\neinzigartiger Schatz, der nur auf dem\n[CS:P]Himmelsgipfel[CR] gefunden werden kann.", italian="Un [CS:I]Dono Cielo[CR] è un particolare\ntipo di tesoro che si trova solo sul [CS:P]Picco[CR]\n[CS:P]del Cielo[CR].", spanish="Un [CS:I]Regalo Cielo[CR] es un tesoro\nmuy especial que solo se halla en la\n[CS:P]Cumbre del Cielo[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="As its name indicates, it's a\ngift that should be given to others...", french="En fait, c'est un trésor qu'il est\nconseillé d'offrir aux autres...", german="Wie der Name nahelegt, wird es\nals Präsent an andere verschenkt.", italian="Come suggerisce il nome,\nsi tratta di un regalo da fare a qualcuno...", spanish="Como su nombre indica, es un\nregalo que debería entregarse a alguien..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="You never know what's in it until\nit's opened. It's a mysterious treasure!", french="Impossible de savoir ce qu'il\ncontient avant de l'avoir ouvert.\nC'est un trésor plein de mystère!", german="Und was darin ist, bleibt\nverborgen, bis es geöffnet wird! Eine\ngeheimnisvolle Sache!", italian="Non saprai mai cosa si nasconde\nal suo interno finché non lo apri.\nÈ un tesoro misterioso!", spanish="Nunca sabes qué contiene hasta\nque lo abres. ¡Es de lo más misterioso!"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="But...if it's opened by the one\nwho found it, then it's completely empty, so be\ncareful! Hee hee! ♪", french="Mais... si c'est la personne qui\nl'a trouvé qui l'ouvre, alors il est\ncomplètement vide. Donc attention! Hi hi! ♪", german="Aber... Wenn es derjenige\nöffnet, der es gefunden hat, ist es komplett\nleer. Also sei vorsichtig! Hi hi! ♪", italian="Ma... se lo apre chi lo ha\nscoperto, diventa completamente vuoto.\nMi raccomando, fai attenzione! Ih ih! ♪", spanish="Peeero... si lo abre quien lo ha\nencontrado, lo hallará totalmente vacío, así\nque, ¡cuidado! ¡Ji, ji! ♪"})
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, "happy", 1) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(25)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="It's said that if you send a\n[CS:I]Sky Gift[CR] as a token of thanks, whoever\nreceives it will be very happy.", french="On dit qu'un [CS:I]Don du Ciel[CR] envoyé\nen gage de remerciement rendra n'importe\nquel destinataire fou de joie.", german="Wenn man ein [CS:I]Himmelspräsent[CR]\naus Dankbarkeit verschenkt, macht es den\nEmpfänger sehr glücklich. So sagt man.", italian="A quanto si dice, se spedisci\nun [CS:I]Dono Cielo[CR] come segno di ringraziamento,\nregalerai la felicità a chiunque lo riceva.", spanish="Se dice que si se envía un\n[CS:I]Regalo Cielo[CR] como muestra de agradecimiento,\nse hará muy feliz al destinatario."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="[player], why don't you send\na [CS:I]Sky Gift[CR] to those who have helped you?", french="[player], pourquoi ne pas\nenvoyer un [CS:I]Don du Ciel[CR] à ceux\nqui t'ont apporté leur aide?", german="[player], warum versendest\ndu nicht ein [CS:I]Himmelspräsent[CR] an jene,\ndie dir geholfen haben?", italian="[player], perché non invii\nun [CS:I]Dono Cielo[CR] a chi ti ha aiutato?", spanish="[player], ¿por qué no envías\nun [CS:I]Regalo Cielo[CR] a quienes te hayan ayudado?"})
  -- message_Close
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 276, 316, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 180, 316, false, 2) end end
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.cleanup_npcs()
end
