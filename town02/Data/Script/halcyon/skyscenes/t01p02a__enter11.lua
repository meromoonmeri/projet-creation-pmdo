-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/enter11.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_kakureon2 = SkySceneKit.spawn_npc("kecleon", 352, 168, Direction.Down, "NPC_KAKUREON2")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon2, 4) end)
  if ((SV.SkyTalkBitFlags or {})[95] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[95]
  -- @label_131 [étiquette de flux ExplorerScript]
  -- switch(message_Menu(MENU_KECLEON_WARES)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[95] = 1 -- $SCENARIO_TALK_BIT_FLAG[95] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="Ah, the returning heroes\nof Team [team:]!", french="Ah, les voilà de retour,\nle duo héroïque de l'Equipe [team:]!", german="Ah, die heimkehrenden Helden\nvon Team [team:]!", italian="Ah, l'eroico Team [team:]\nè di ritorno!", spanish="Ah, ¡aquí tenemos de vuelta\nel heroico [CS:X]Equipo[CR] [team:]!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="I thank you sincerely for\nstopping the spreading nightmare!", french="Merci beaucoup d'avoir mis un\nterme à la propagation du cauchemar!", german="Ich danke euch zutiefst, dass ihr\ndie Ausbreitung des Albtraums verhindert habt!", italian="Vi ringrazio di cuore per\naver fermato la diffusione dell'incubo!", spanish="¡Les agradezco sinceramente que\ndetuvieran el avance de esa pesadilla!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon2, 4) end)
  if ((SV.SkyTalkBitFlags or {})[94] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[94]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[94] = 1 -- $SCENARIO_TALK_BIT_FLAG[94] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="Please don't succumb to\nanyone bad!", french="Veillez à ne pas succomber aux\nassauts des Pokémon méchants!", german="Bitte gebt euch dem Bösen nicht\ngeschlagen!", italian="Vi prego, non cedete di fronte\nalla malvagità!", spanish="¡No sucumban ante los\npeligros que les esperan ahí fuera!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="Go forward to victory! Fight!\nFight!", french="Tout droit à la victoire!\nBattez-vous! Battez-vous!", german="Vorwärts zum Sieg! Kämpft!\nKämpft!", italian="Puntate alla vittoria! Lottate!\nLottate!", spanish=" ¡Sean fuertes! ¡Luchen con brío!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon2, 4) end)
  if ((SV.SkyTalkBitFlags or {})[93] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[93]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[93] = 1 -- $SCENARIO_TALK_BIT_FLAG[93] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english=" ...Hmmm...", french=" ... Hmmm...", german=" ...Hmm...", italian=" Mmmm...", spanish=" Hum..."})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="What could it possibly be? What\nhas made little [CS:N]Azurill[CR] unable to wake?", french="Qu'est-ce que ça peut bien être?\nQu'est-ce qui empêche le petit [CS:N]Azurill[CR] de se\nréveiller?", german="Was könnte es nur sein? Was\nkönnte den kleinen [CS:N]Azurill[CR] nur davon abhalten,\naufzuwachen?", italian="Com'è possibile? Cos'è che non\npermette al piccolo [CS:N]Azurill[CR] di svegliarsi?", spanish="¿De qué se tratará? ¿Qué será\nlo que impide despertarse al pequeño [CS:N]Azurill[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="I do hope the dear child will\nawaken and brighten our day with his cheer.", french="J'espère que ce petit va finir\npar se réveiller pour éclairer notre journée\nde sa gaieté.", german="Ich hoffe inständig, dass der\nliebe Kleine aufwachen und unseren Tag\nmit seinem Frohsinn bereichern wird.", italian="Spero che quel caro piccino si\nsvegli e rassereni la nostra giornata con la\nsua allegria.", spanish="Espero que ese chiquillo\nnos alegre el día despertándose al fin."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 71] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon2, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 67]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon2, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon2, 4) end)
  if ((SV.SkyTalkBitFlags or {})[92] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[92]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[92] = 1 -- $SCENARIO_TALK_BIT_FLAG[92] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="My brother is waiting for a\nchance to speed over to see Team [CS:X]Charm[CR].\nIt's quite annoying!", french="Mon frère guette le moment\nopportun pour filer voir l'Equipe [CS:X]Charme[CR].\nÇa m'énerve, ça m'énerve!", german="Mein Bruder wartet auf eine\nMöglichkeit hinüberzueilen, um Team [CS:X]Charme[CR]\nsehen zu können. Das ist ziemlich nervig!", italian="Mio fratello sta aspettando\nl'occasione giusta per andare a vedere il\nTeam [CS:X]Malia[CR]. Uffa.", spanish="Mi hermano no piensa más que\nen salir corriendo a ver al [CS:X]Equipo Carisma[CR].\n¡Es irritante!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="For when that very chance\narrives...[K] I intend to dash first!", french="Car, lorsque ce moment\narrivera...[K] J'ai bien l'intention d'être le\npremier à décamper!", german="Denn wenn sich diese Möglichkeit\nbietet...[K] Dann bin ich der Erste, der\nlosflitzen wird!", italian="Se si dovesse presentare\nl'occasione...[K]\nVoglio arrivare io per primo!", spanish="Pero cuando llegue la ocasión...[K]\n¡Seré yo quien vaya primero!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon2, 4) end)
  if ((SV.SkyTalkBitFlags or {})[91] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[91]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[91] = 1 -- $SCENARIO_TALK_BIT_FLAG[91] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="You've graduated!\nCongratulations!", french="Vous avez décroché le diplôme\nde la Guilde! Félicitations!", german="Ihr habt den Abschluss\nerworben! Glückwunsch!", italian="Avete superato l'esame!\nCongratulazioni!", spanish="¡Han superado el reto!\n¡Enhorabuena!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="We hope for your continued\npatronage and generosity! ♪", french="Nous espérons que vous\ncontinuerez à fréquenter notre humble\nboutique! ♪", german="Wir hoffen auf eure\nfortwährende Unterstützung und\nGroßzügigkeit! ♪", italian="Contiamo sul vostro sostegno\ne sulla vostra generosità! ♪", spanish="¡Esperamos que sigan visitando\nnuestro comercio! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon2, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon2, 4) end)
  if ((SV.SkyTalkBitFlags or {})[90] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[90]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[90] = 1 -- $SCENARIO_TALK_BIT_FLAG[90] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="Our thoughts go with you!\nPlease be strong!", french="Nos pensées vous accompagnent!\nCourage!", german="In Gedanken sind wir bei euch!\nBitte seid stark!", italian=" Vi penseremo! Siate forti!", spanish="¡Les deseamos lo mejor! ¡Sean\nfuertes!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon2, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 3] || scn($SCENARIO_MAIN) >= [23
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon2, 4) end)
  if ((SV.SkyTalkBitFlags or {})[89] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[89]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[89] = 1 -- $SCENARIO_TALK_BIT_FLAG[89] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="Ah, welcome back, [hero]\nand [partner]!", french="Ah, content de vous revoir,\n[hero] et [partner]!", german="Ah, willkommen zurück,\n[hero] und [partner]!", italian="Ah, siete di nuovo qui,\n[hero] e [partner]! Che bello!", spanish="¡Hola, [hero] y [partner]!\n¡Otra vez por aquí!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="Ahhh! We are happy to see you!\nWe were so very worried about you!", french="Aaah! Ça nous fait plaisir de\nvous voir! Nous étions si inquiets à\nvotre sujet!", german="Ahhh! Wir freuen uns, euch zu\nsehen! Wir haben uns solche Sorgen um euch\ngemacht!", italian="Ahhh! Siamo felici di vedervi!\nEravamo così preoccupati per voi!", spanish="¡Aaah! ¡Qué alegría, de nuevo\npor aquí! ¡Estábamos muy preocupados\npor ustedes!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon2, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 3] || scn($SCENARIO_MAIN) >= [17
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon2, 4) end)
  if ((SV.SkyTalkBitFlags or {})[88] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[88]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[88] = 1 -- $SCENARIO_TALK_BIT_FLAG[88] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="Surely, the great [CS:N]Dusknoir[CR] will\nbring that terrible [CS:N]Grovyle[CR] to justice.", french="Je suis sûr que le grand\n[CS:N]Noctunoir[CR] arrivera à capturer cet odieux\n[CS:N]Massko[CR].", german="Der große [CS:N]Zwirrfinst[CR] wird den\nschrecklichen [CS:N]Reptain[CR] mit Sicherheit seiner\ngerechten Strafe zuführen.", italian="Sicuramente il grande [CS:N]Dusknoir[CR]\nassicurerà alla giustizia quel manigoldo di\n[CS:N]Grovyle[CR].", spanish="Sin duda el gran [CS:N]Dusknoir[CR] se\nencargará de poner a ese terrible [CS:N]Grovyle[CR]\nen manos de la justicia."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon2, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 4] || scn($SCENARIO_MAIN) >= [12
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon2, 4) end)
  if ((SV.SkyTalkBitFlags or {})[87] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[87]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[87] = 1 -- $SCENARIO_TALK_BIT_FLAG[87] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="Welcome back! ♪[K] Back to your\nguild training, eh?", french="Content de vous revoir! ♪[K]\nOn reprend l'entraînement de la Guilde, hein?", german="Willkommen zurück! ♪[K] Wieder\nzurück zum Gildentraining, wie?", italian="Felice ritorno! ♪[K] Avete\nripreso gli allenamenti della Gilda, eh?", spanish="¡Encantado de verles! ♪[K] Otra\nvez a entrenar con el [CS:N]Pokégremio[CR], ¿eh?"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="We hope for your continued\npatronage of our humble business! ♪", french="Nous espérons que vous\ncontinuerez à fréquenter notre humble\nboutique! ♪", german="Wir hoffen auf eure\nfortwährende Unterstützung, was unsere\nbescheidene Sache anbelangt! ♪", italian="Speriamo che continuerete a\nsostenere la nostra modesta impresa! ♪", spanish="¡Esperamos que sigan visitando\nnuestro humilde negocio! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon2, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [9, 1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon2, 4) end)
  if ((SV.SkyTalkBitFlags or {})[86] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[86]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[86] = 1 -- $SCENARIO_TALK_BIT_FLAG[86] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="I hope you enjoy yourselves on\nthe guild's expedition! ♪", french="J'espère que vous vous\namuserez bien pendant l'expédition de\nla Guilde! ♪", german="Ich hoffe, dass ihr euch auf der\nExpedition der Gilde gut amüsiert! ♪", italian="Spero che vi divertirete durante\nla spedizione della Gilda! ♪", spanish="¡Espero que lo pasen muy bien en\nla expedición del [CS:N]Pokégremio[CR]! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon2, 4) end)
  if ((SV.SkyTalkBitFlags or {})[85] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[85]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[85] = 1 -- $SCENARIO_TALK_BIT_FLAG[85] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="The guild is going on an\nexpedition, I hear! ♪", french="La Guilde part bientôt en\nexpédition, à ce qu'il paraît! ♪", german="Ich habe gehört, dass sich die\nGilde auf eine Expedition begibt! ♪", italian="La Gilda sta partendo per una\nspedizione, ho sentito! ♪", spanish="¡Me han dicho que el [CS:N]Pokégremio[CR]\nse va de expedición! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english=" Ah, it has been a long time! ♪", french=" Ah, ça faisait longtemps! ♪", german=" Ah, es ist lange her! ♪", italian=" Ah, era da tanto tempo! ♪", spanish=" ¡Ah, cuánto tiempo! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 1] || scn($SCENARIO_MAIN) >= [6, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon2, 4) end)
  if ((SV.SkyTalkBitFlags or {})[84] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[84]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[84] = 1 -- $SCENARIO_TALK_BIT_FLAG[84] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="Ahhh! To arrest a criminal so\nearly in your career! You must be exceptional!", french="Waouh! Vous devez être\nune équipe exceptionnelle pour capturer\nun criminel si tôt dans votre carrière!", german="Ahhh! So früh in eurer Laufbahn\neinen Ganoven dingfest zu machen! Ihr müsst\nwirklich außergewöhnlich sein!", italian="Ahhh! Arrestare un criminale\nall'inizio della carriera! Siete eccezionali!", spanish="¡Vaya! ¿Ya han arrestado a un\nmalhechor? ¡Sin duda son excepcionales!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="It's hard to believe you've been\non an exploration team for a short while! ♪", french="Difficile de croire que vous\nvenez de former votre équipe d'exploration\nil y a si peu de temps! ♪", german="Es ist schwer zu glauben, dass\nihr erst seit Kurzem einem Erkundungsteam\nangehört! ♪", italian="È difficile credere che siete una\nsquadra d'esplorazione da così poco tempo! ♪", spanish="¡Casi no puedo creer que lleven\ntan poco tiempo con su equipo explorador! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon2, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon2, 4) end)
  -- switch(message_Menu(MENU_KECLEON_WARES)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- supervision_ExecuteCommon(CORO_EVENT_M03_03) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 0] || scn($SCENARIO_MAIN) >= [3, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon2, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
