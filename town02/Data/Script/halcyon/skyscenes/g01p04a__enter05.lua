-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/enter05.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- @label_131 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_guregguru, 4) end)
  -- switch(message_Menu(MENU_SWAP_SHOP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_135 [étiquette de flux ExplorerScript]
  -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
  do local __sw = ((SV.SkyMenuResults or {})["MENU_SWAP_SHOP2"] or 0) -- switch(message_Menu(MENU_SWAP_SHOP2)) [message_Menu(MENU_SWAP_SHOP2): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 1 then
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  elseif __sw == 2 then
  -- GAP: se_Play(8718) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(30)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1')
  GAME:WaitFrames(15)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(30)
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  elseif __sw == 3 then
  GROUND:EntTurn(npc_npc_guregguru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  elseif true then -- default
  -- break_loop [contrôle de boucle forever NDS: une itération compilée]
  end
  end
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  if ((SV.SkyTalkBitFlags or {})[40] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[40]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[40] = 1 -- $SCENARIO_TALK_BIT_FLAG[40] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_guregguru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english=" Meh-heh-heh. You can't fail now!", french="Mwé hé hé... Vous ne pouvez\nplus échouer maintenant!", german="Mehehe. Ihr dürft jetzt nicht\nversagen!", italian=" Eh eh eh. Ora non potete fallire!", spanish="¡Je, je, je! ¡No podéis fracasar\nahora!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 76] || scn($SCENARIO_MAIN) >= [2
  if ((SV.SkyTalkBitFlags or {})[39] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[39]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[39] = 1 -- $SCENARIO_TALK_BIT_FLAG[39] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_guregguru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="That little [CS:N]Azurill[CR] has me\nworried too.", french="Ce petit [CS:N]Azurill[CR] m'inquiète moi\naussi.", german="Dieser kleine [CS:N]Azurill[CR] macht mir\nauch Sorgen.", italian="Quel piccolo [CS:N]Azurill[CR] preoccupa\nanche me.", spanish="Ese pequeño [CS:N]Azurill[CR] también\nme tiene preocupado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 71] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_guregguru, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 56) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 55]
  if ((SV.SkyTalkBitFlags or {})[39] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[39]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[39] = 1 -- $SCENARIO_TALK_BIT_FLAG[39] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_guregguru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Meh-heh-heh. Team [CS:X]Charm[CR]\ndoesn't interest me.", french="Mwé hé hé... L'Equipe [CS:X]Charme[CR]\nne m'intéresse pas.", german="Mehehe. Team [CS:X]Charme[CR]\ninteressiert mich nicht.", italian="Eh eh eh. Il Team [CS:X]Malia[CR] non\nm'interessa.", spanish="Je, je, je. El [CS:X]Equipo Carisma[CR] no\nme interesa."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="This here is what interests me.\nIt's all I care about.", french="C'est ça qui m'intéresse.\nCe chaudron. Le reste, je m'en moque.", german="Dies hier interessiert mich. Es\nist das Einzige, was ich wichtig nehme.", italian="Tutto ciò che mi interessa è qui.\nÈ l'unica cosa di cui mi preoccupo.", spanish="Esto de aquí es lo que me\ninteresa. No me importa nada más."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="I love doing swaps more than\nanything! Meh-heh-heh.", french="J'aime faire du troc plus\nque tout! Mwé hé hé...", german="Tauschen liebe ich mehr als alles\nandere! Mehehe.", italian="Amo i cambi più di qualsiasi\naltra cosa! Eh eh eh.", spanish="¡Hacer trueques es lo que más\nme gusta en el mundo! Je, je, je."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 33] || scn($SCENARIO_MAIN) >= [2
  if ((SV.SkyTalkBitFlags or {})[37] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[37]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[37] = 1 -- $SCENARIO_TALK_BIT_FLAG[37] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_guregguru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Meh-heh-heh. Congratulations on\nyour graduation, you two.", french="Mwé hé hé... Félicitations pour\nl'obtention de votre diplôme, vous deux.", german="Mehehe. Gratulation zur\nbestandenen Abschlussprüfung, ihr zwei.", italian="Eh eh eh. Congratulazioni per\nl'esame, voi due.", spanish="Je, je, je. Mis felicitaciones\npor superar el gran reto."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="I'll admit that I thought you two\nwould fail the exam. Meh-heh-heh.", french="J'avoue que j'étais persuadé que\nvous alliez échouer. Mwé hé hé...", german="Ich gebe zu, dass ich euch eine\nerfolgreiche Abschlussprüfung nicht zugetraut\nhätte. Mehehe.", italian="Non pensavo che ce l'avreste\nfatta. Eh eh eh.", spanish="Reconozco que pensé que no\nibais a conseguirlo. Je, je, je."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 3] || scn($SCENARIO_MAIN) >= [29
  if ((SV.SkyTalkBitFlags or {})[37] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[37]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[37] = 1 -- $SCENARIO_TALK_BIT_FLAG[37] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_guregguru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english=" Meh-heh-heh. Hey, you two...", french=" Mwé hé hé... Vous deux, là...", german=" Mehehe. Hey, ihr zwei...", italian=" Eh eh eh. Ehi, voi due...", spanish=" Je, je, je. Eh, escuchadme..."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="The graduation exam will put\nyou through the wringer.", french="Vous allez passer à la\nmoulinette pendant l'examen de la Guilde.", german="Bei der Abschlussprüfung werdet\nihr ordentlich in die Mangel genommen.", italian=" L'esame sarà molto difficile.", spanish="El gran reto no es cualquier\ncosa."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english=" Don't be flattened! Meh-heh-heh.", french="Ne vous faites pas écraser!\nMwé hé hé...", german="Lasst euch ja nicht plätten!\nMehehe.", italian="Non fatevi schiacciare!\nEh eh eh.", spanish="¡Que no os machaquen! Je, je,\nje."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  if ((SV.SkyTalkBitFlags or {})[35] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[35]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[35] = 1 -- $SCENARIO_TALK_BIT_FLAG[35] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_guregguru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english=" Meh-heh-heh. Hey, you two...", french=" Mwé hé hé... Vous deux, là...", german=" Mehehe. Hey, ihr zwei...", italian=" Eh eh eh. Ehi, voi due...", spanish=" Je, je, je. Eh, escuchadme..."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="I know it's not easy, but you\ncan't fail now.", french="Je sais que ce n'est pas facile,\nmais vous ne pouvez plus échouer maintenant.", german="Ich weiß, dass es nicht leicht\nist, aber ihr dürft jetzt nicht versagen.", italian="So che non è facile, ma non\npotete fallire.", spanish="Sé que no resulta fácil, pero\nno podéis fracasar ahora."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="The world's at stake!\nMeh-heh-heh.", french="Le sort du monde entier est en\njeu! Mwé hé hé...", german="Das Wohl der Welt steht auf\ndem Spiel! Mehehe.", italian="C'è in ballo il futuro del mondo!\nEh eh eh.", spanish="¡Está en juego el bienestar\ndel mundo! Je, je, je."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  if ((SV.SkyTalkBitFlags or {})[34] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[34]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[34] = 1 -- $SCENARIO_TALK_BIT_FLAG[34] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_guregguru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Meh-heh-heh. Tomorrow, I'm\ngoing too.", french="Mwé hé hé... Demain, je viens\naussi.", german="Mehehe. Morgen gehe ich auch\nmit.", italian=" Eh eh eh. Domani, vengo anch'io.", spanish="Je, je, je. Mañana yo también\niré."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english=" To [CS:P]Brine Cave[CR]! Meh-heh-heh.", french="A la [CS:P]Caverne Saline[CR]!\nMwé hé hé...", german=" In die [CS:P]Salzwasserhöhle[CR]! Mehehe.", italian=" Alla [CS:P]Grotta Salmastra[CR]! Eh eh eh.", spanish="¡Todos a la [CS:P]Cueva Aguamar[CR]!\nJe, je, je."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [22, 3] || scn($SCENARIO_MAIN) >= [22
  if ((SV.SkyTalkBitFlags or {})[33] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[33]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[33] = 1 -- $SCENARIO_TALK_BIT_FLAG[33] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_guregguru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Meh-heh-heh. It's good that you\ntwo made it back from the future.", french="Mwé hé hé... C'est bien que vous\nayez réussi à revenir du futur.", german="Mehehe. Es ist gut, dass ihr zwei\nes aus der Zukunft zurückgeschafft habt.", italian="Eh eh eh. È bello vedervi di\nritorno dal futuro.", spanish="Je, je, je. Qué alegría que\nhayáis regresado del futuro."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="It makes me happy.\nMeh-heh-heh-heh!", french="Ça me rend heureux.\nMwé hé hé hé!", german="Das macht mich glücklich.\nMehehehe!", italian=" Mi rende felice. Eh eh eh eh!", spanish="Me habéis alegrado el día.\n¡Je, je, je, je!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  if ((SV.SkyTalkBitFlags or {})[32] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[32]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[32] = 1 -- $SCENARIO_TALK_BIT_FLAG[32] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_guregguru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Meh-heh-heh. You go on. Do your\ngood work.", french="Mwé hé hé... Allez-y. Faites du\nbon travail.", german="Mehehe. Macht weiter so. Auf\nweitere gute Arbeit eurerseits.", italian="Eh eh eh. Forza. Impegnatevi\nal massimo.", spanish="Je, je, je. Venga, a lo vuestro.\nDemostrad de lo que sois capaces."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Do it for those like me who just\nstay home. Meh-heh-heh.", french="Faites-le pour les gens comme\nmoi, qui se contentent de rester chez eux.\nMwé hé hé...", german="Tut es für jene wie mich, die die\nganze Zeit zu Hause bleiben. Mehehe.", italian="Fatelo per quelli come me che\nrestano a casa. Eh eh eh.", spanish="Haced que los que nos quedamos\naquí nos sintamos orgullosos. Je, je, je."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 1] || scn($SCENARIO_MAIN) >= [14
  if ((SV.SkyTalkBitFlags or {})[31] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[31]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[31] = 1 -- $SCENARIO_TALK_BIT_FLAG[31] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_guregguru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Meh-heh-heh. Put my swapping\nto good use, you two...", french="Mwé hé hé... Profitez bien de\nmes trocs, vous deux...", german="Mehehe. Nutzt die von mir\nangebotene Tauschmöglichkeit sinnvoll,\nihr zwei.", italian="Eh eh eh. Fate un buon uso\ndei miei servizi, voi due...", spanish="Je, je, je. Sacad el mayor\npartido de mis trueques..."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Like for catching [CS:N]Grovyle[CR].\nMeh-heh-heh.", french="Pour capturer [CS:N]Massko[CR], par\nexemple. Mwé hé hé...", german="Wie etwa zum Fangen von\n[CS:N]Reptain[CR]. Mehehe.", italian="Potrebbero esservi utili per\ncatturare [CS:N]Grovyle[CR]. Eh eh eh.", spanish="Igual hasta pueden ayudaros a\natrapar a [CS:N]Grovyle[CR]. Je, je, je."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [13, 2] || scn($SCENARIO_MAIN) >= [13
  if ((SV.SkyTalkBitFlags or {})[30] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[30]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[30] = 1 -- $SCENARIO_TALK_BIT_FLAG[30] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_guregguru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Meh-heh-heh. Now that the\nexpedition is over, I'm back in business.", french="Mwé hé hé... Les affaires\npeuvent reprendre, maintenant que l'expédition\nest terminée.", german="Mehehe. Jetzt, wo die Expedition\nvorüber ist, bin ich wieder im Geschäft.", italian="Eh eh eh. Ora che la spedizione\nè conclusa, torno a dedicarmi ai miei affari.", spanish="Je, je, je. Ahora que se ha\nterminado la expedición puedo reabrir\nel negocio."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Back to doing swaps! My\nfavorite thing! Meh-heh-heh.", french="Revenons-en à nos trocs!\nMon activité préférée! Le troc, c'est mon\ntruc! Mwé hé hé...", german="Und wieder zurück zum\nTauschen, meiner Lieblingsbeschäftigung!\nMehehe.", italian="Torno ai cambi! La mia\noccupazione preferita! Eh eh eh.", spanish="¡Otra vez a hacer trueques!\n¡Mi afición favorita! Je, je, je."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  if ((SV.SkyTalkBitFlags or {})[29] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[29]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[29] = 1 -- $SCENARIO_TALK_BIT_FLAG[29] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_guregguru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="We're closing up the guild while\nwe're on the expedition. I have to leave my\nSwap Cauldron behind. Meh-heh-heh.", french="On ferme la Guilde le temps de\nl'expédition. Je vais devoir laisser mon\nChaudron-Troc ici. Mwé hé hé...", german="Wir schließen die Gilde,\nwährend wir auf der Expedition sind. Ich muss\nmeinen Tauschkessel zurücklassen. Mehehe.", italian="Durante la spedizione, la Gilda\nrimane chiusa. Non posso portarmi\nil Pentolone dei Cambi. Eh eh eh.", spanish="Vamos a cerrar el [CS:N]Pokégremio[CR]\ndurante la expedición. Tengo que dejar\naquí mi Caldero de Trueque. Je, je, je."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="I can't do this while on the\nexpedition, so if you have anything to swap,\ndo it now. Meh-heh-heh.", french="Si vous avez quoi que ce soit à\ntroquer, c'est maintenant. Ça ne sera pas\npossible pendant l'expédition. Mwé hé hé...", german="Ich kann das nicht während der\nExpedition machen. Also, wenn du etwas zu\ntauschen hast, dann mach das jetzt. Mehehe.", italian="Non posso lavorare durante la\nspedizione, quindi se avete qualcosa da\ncambiare fatelo adesso. Eh eh eh.", spanish="No habrá ocasión de usarlo\ndurante la expedición, así que si queréis hacer\nun trueque tendrá que ser ahora. Je, je, je."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7] || scn($SCENARIO_MAIN) >= [8, 
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 2] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_guregguru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="I'm almost done repairing my\nSwap Cauldron here... Almost, but not yet.", french="J'ai presque fini de réparer mon\nChaudron-Troc... Presque, mais pas tout à fait.", german="Ich habe meinen Tauschkessel\nhier fast fertig repariert... Fast, aber eben\nnoch nicht ganz.", italian="Ho quasi finito di riparare il mio\nPentolone dei Cambi... Quasi, ma non del\ntutto.", spanish="Ya casi he acabado de reparar\nmi Caldero de Trueque... Casi, pero aún no."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="I'll tell you when I'm done. It's\nsomething you should look forward to.\nMeh-heh-heh.", french="Je vous préviendrai quand\nj'aurai fini. Vous devez bouillir d'impatience.\nMwé hé hé...", german="Ich gebe euch Bescheid, wenn ich\ndamit fertig bin. Es ist etwas, auf das ihr euch\nfreuen solltet. Mehehe.", italian="Quando avrò finito ve lo farò\nsapere. Non vedete l'ora, eh?", spanish="Ya os avisaré cuando termine.\nEs algo por lo que vale la pena esperar.\n¡Ya veréis! Je, je, je."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="You'll finally learn what I'm up\nto here. Meh-heh-heh.", french="Vous allez enfin savoir ce que je\nfabrique ici. Mwé hé hé...", german="Ihr werdet schlussendlich\nerfahren, woran ich hier arbeite. Mehehe.", italian="Così finalmente scoprirete di\ncosa mi occupo qui. Eh eh eh.", spanish="Ya os enteraréis de lo que\nestoy haciendo aquí. Je, je, je."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 6) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 6]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_guregguru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Meh-heh-heh. I guess I get to\nenjoy this fine, ripe aroma for a while yet.", french="Mwé hé hé... Je suppose que je\nvais pouvoir profiter de ce doux fumet\npendant un moment encore.", german="Mehehe. Mir scheint, als könnte\nich diesen herrlichen, reifen Duft eine Weile\ngenießen.", italian="Eh eh eh. Penso che rimarrò qui\nancora un poco per godermi questo piacevole e\ndelicato aroma.", spanish="Je, je, je Supongo que voy a\ntener el privilegio de disfrutar de este\nexquisito aroma una temporadita."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="It's another thing that makes me\nhappy. Meh-heh-heh.", french="C'est une chose de plus qui me\nrend heureux. Mwé hé hé...", german="Eine weitere Sache, die mich\nglücklich macht. Mehehe.", italian="È un'altra cosa che mi rende\ncontento. Eh eh eh.", spanish="Otra cosa por la que alegrarme.\nJe, je, je."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english=" Oh, by the way...", french=" Ah, au fait...", german=" Ach, übrigens...", italian=" Ah, a proposito...", spanish=" Ah, por cierto..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="I'm almost done repairing my\nSwap Cauldron here...", french="J'ai presque fini de réparer mon\nChaudron-Troc...", german="Ich habe meinen Tauschkessel\nhier fast fertig repariert.", italian="Ho quasi finito di riparare il mio\nPentolone dei Cambi...", spanish="Ya casi he logrado reparar\nmi Caldero de Trueque..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="When I'm done fixing it, I'll\nbe sure to let you know.", french="Je vous préviendrai quand\nj'aurai fini.", german="Wenn ich mit der Reparatur\nganz fertig bin, werde ich euch das sicherlich\nwissen lassen.", italian="Quando avrò finito, ve lo farò\nsapere.", spanish="Cuando haya terminado de\narreglarlo os avisaré."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="You'll finally learn what I'm up\nto here. Meh-heh-heh.", french="Vous allez enfin savoir ce que je\nfabrique ici. Mwé hé hé...", german="Ihr werdet schlussendlich\nerfahren, woran ich hier arbeite. Mehehe.", italian="Sì, poi vi metterò al corrente di\nciò di cui mi occupo qui... Eh eh eh.", spanish="Ya os enteraréis de lo que\nestoy haciendo aquí. Je, je, je."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 3] || scn($SCENARIO_MAIN) >= [7, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_guregguru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Meh-heh-heh. That aroma\nwafting down from upstairs...", french="Mwé hé hé... Ce fumet en\nprovenance de l'étage supérieur...", german="Mehehe. Dieser Duft, der von\noben herabweht...", italian="Eh eh eh. Quest'aroma che viene\nda sopra...", spanish="Je, je, je. Ese aroma que baja\nde la planta de arriba..."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="I don't mind it at all. Nope, it's\nquite all right with me. Meh-heh-heh.", french="Il ne me gêne pas le moins du\nmonde. Non, il me convient même parfaitement.\nMwé hé hé...", german="Er macht mir überhaupt nichts\naus. Nein, was mich angeht, ist das voll in\nOrdnung. Mehehe.", italian="Non mi tocca. Va bene per me.\nEh eh eh.", spanish="No me importa en absoluto.\nNo, a mí no me molesta. Je, je, je."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 1] || scn($SCENARIO_MAIN) >= [6, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_guregguru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Meh-heh-heh... You two...[K]\nTrain hard every day. Meh-heh-heh.", french="Mwé hé hé... Vous deux...[K]\nEntraînez-vous bien tous les jours.\nMwé hé hé...", german="Mehehe. Ihr zwei...[K] trainiert\njeden Tag sehr hart. Mehehe.", italian="Eh eh eh... Voi due...[K]\nVi allenate duramente ogni giorno. Eh eh eh.", spanish="Je, je, je...[K] Espero que entrenéis\nmucho todos los días. Je, je, je."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, [CS:N]Croagunk[CR].[K] I've been meaning\nto ask you...", french="Hé, [CS:N]Cradopaud[CR].[K] Je voulais\nte demander...", german="Hey, [CS:N]Glibunkel[CR].[K] Ich wollte dich\netwas fragen...", italian="Ehi, [CS:N]Croagunk[CR].[K] Avevo intenzione\ndi chiederti...", spanish="Oye, [CS:N]Croagunk[CR]...[K] Hace tiempo\nque quiero preguntarte una cosa..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hey, [CS:N]Croagunk[CR].[K] I've been meaning\nto ask you...", french="Hé, [CS:N]Cradopaud[CR].[K] Je voulais\nte demander...", german="Hey, [CS:N]Glibunkel[CR].[K] Ich wollte dich\netwas fragen...", italian="Ehi, [CS:N]Croagunk[CR].[K] Avevo intenzione\ndi chiederti...", spanish="Oye, [CS:N]Croagunk[CR]...[K] Hace tiempo\nque quiero preguntarte una cosa..."})
  else
  SkySceneKit.say({english="Hey, [CS:N]Croagunk[CR].[K] I've been meaning\nto ask you...", french="Hé, [CS:N]Cradopaud[CR].[K] Je voulais\nte demander...", german="Hey, [CS:N]Glibunkel[CR].[K] Ich wollte dich\netwas fragen...", italian="Ehi, [CS:N]Croagunk[CR].[K] Avevo intenzione\ndi chiederti...", spanish="Oye, [CS:N]Croagunk[CR]...[K] Hace tiempo\nque quiero preguntarte una cosa..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Croagunk[CR], what are you doing\nhere all the time?", french="Qu'est-ce que tu fais ici tout\nle temps?", german="[CS:N]Glibunkel[CR], was machst du hier\ndie ganze Zeit?", italian="[CS:N]Croagunk[CR], cosa fai qui\ntutto il tempo?", spanish=" ¿Por qué estás siempre aquí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Croagunk[CR], what are you doing\nhere all the time?", french="Qu'est-ce que tu fais ici tout\nle temps?", german="[CS:N]Glibunkel[CR], was machst du hier\ndie ganze Zeit?", italian="[CS:N]Croagunk[CR], cosa fai qui\ntutto il tempo?", spanish=" ¿Por qué estás siempre aquí?"})
  else
  SkySceneKit.say({english="[CS:N]Croagunk[CR], what are you doing\nhere all the time?", french="Qu'est-ce que tu fais ici tout\nle temps?", german="[CS:N]Glibunkel[CR], was machst du hier\ndie ganze Zeit?", italian="[CS:N]Croagunk[CR], cosa fai qui\ntutto il tempo?", spanish=" ¿Por qué estás siempre aquí?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english=" Huh?[K] Who...me? Meh-heh-heh.", french=" Hein?[K] Qui... moi? Mwé hé hé...", german=" Wie?[K] Wer? Ich? Mehehe.", italian=" Eh?[K] Chi... io? Eh eh eh.", spanish=" ¿Eh?[K] ¿Quién, yo? Je, je, je..."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="What am I doing here...?[K]\nMeh-heh...[K] Meh-heh-heh.", french="Ce que je fais ici...?[K]\nMwé hé...[K] Mwé hé hé...", german="Was ich hier mache?[K] Mehe...[K]\nMehehe.", italian="Cosa faccio qui...?[K] Eh eh eh...[K]\nEh eh eh.", spanish="¿Que por qué estoy aquí?[K]\nJe, je...[K] Je, je, je."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english=" Meh-heh-heh-heh-heh...", french=" Mwé hé hé hé hé...", german=" Mehehehehe...", italian=" Eh eh eh eh eh...", spanish=" Je, je, je, je, je..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 7]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_guregguru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="You caught yourselves a wanted\ncriminal?", french="Vous avez épinglé un criminel\nrecherché?", german="Ihr habt einen gesuchten Ganoven\ndingfest gemacht?", italian="Avete catturato un ricercato con\nle vostre forze?", spanish="¿Habéis atrapado a algún\nmalhechor buscado por la ley?"})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="So you really can get things\ndone. Meh-heh-heh.", french="Alors c'est que vous savez\nvraiment y faire. Mwé hé hé...", german="Ihr wisst also wirklich, wie man\ndie Dinge anzupacken hat. Mehehe.", italian="Sapete davvero quello\nche fate. Eh eh eh.", spanish="Pues sí que sabéis hacer bien\nlas cosas. Je, je, je."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Of course, what you did is only\nwhat's expected of any exploration team.\nMeh-heh-heh.", french="Bien sûr, ce que vous avez fait,\nc'est ce qu'on attend de n'importe quelle équipe\nd'exploration. Mwé hé hé...", german="Natürlich habt ihr nur das getan,\nwas von einem Erkundungsteam erwartet wird.\nMehehe.", italian="Certo, fate solo quello che ci si\naspetterebbe da ogni squadra d'esplorazione.\nEh eh eh.", spanish="Pero claro, tampoco es que se\nespere menos de un equipo explorador.\nJe, je, je."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_guregguru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english=" The name's [CS:N]Croagunk[CR].", french=" Je m'appelle [CS:N]Cradopaud[CR].", german=" Mein Name ist [CS:N]Glibunkel[CR].", italian=" Mi chiamo [CS:N]Croagunk[CR]!", spanish=" Me llamo [CS:N]Croagunk[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Nice to meet you, rookies.\nMeh-heh-heh.", french="Content de vous connaître,\nla bleusaille... Mwé hé hé...", german="Freut mich, eure Bekanntschaft\nzu machen, ihr Anfänger. Mehehe.", italian="Felice di incontrarvi, reclute.\nEh eh eh.", spanish="Encantado de conoceros,\nreclutas. Je, je, je."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [3, 1]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
