-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P31A/enter09.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_RECURITABLE_IN_TEAM"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_RECURITABLE_IN_T) [ProcessSpecial(PROCESS_SPECIAL_IS_RECURITABLE_IN_TEAM): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I knew it was going to be a\nbother. That's why I hesitated for so long...", french="Je savais que ça vous\nennuierait, c'est pour ça que j'ai longuement\nhésité.", german="Ich wusste, dass es für euch\neine Last sein würde. Deswegen habe ich so\nlange gezögert...", italian="Pensavo che sarei stata solo\nun peso per voi, ecco perché ho esitato\nfino a ora...", spanish="Sabía que suponía una molestia.\nPor eso llevo tanto tiempo dudando..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I'm so glad I blurted out my\nrequest!", french="Je suis si heureuse d'avoir osé\nvous poser la question.", german="Ich bin so froh, dass ich endlich\nmit meiner Frage herausgeplatzt bin.", italian="Sono così felice di avervelo\nchiesto!", spanish="¡Me alegro de haber soltado ya\nmi propuesta!"})
  -- message_Close
  -- @label_64 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- screen2_FadeOut [sub déjà caché]
  if ((SV.SkyTalkBitFlags or {})[122] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[122]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- screen2_FadeOut [sub déjà caché]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 256, 264, Direction.Down, "NPC_SHEIMI")
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="I was deeply moved while\nclimbing the mountain with you,\nTeam [team:]. I won't forget it...", french="J'ai vraiment été émue de\ngravir cette montagne avec vous,\nEquipe [team:]. Je ne l'oublierai pas...", german="Mit euch den Berg zu besteigen,\nTeam [team:], war ein unvergessliches\nErlebnis. Es hat mich wirklich tief bewegt.", italian="È stato davvero emozionante\nscalare questa montagna con voi,\nTeam [team:]. Non lo dimenticherò mai...", spanish="[CS:X]Equipo[CR] [team:], me\nconmovió mucho escalar la montaña a vuestro\nlado. Es algo que no olvidaré..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="What do you think...\nThat is...letting me join Team [team:]?", french="Que diriez-vous si...\nenfin... si je vous demandais de me laisser\nrejoindre l'Equipe [team:]?", german="Was glaubt ihr... Könnte ich bei\nTeam [team:] mitmachen?", italian="Che ne dite...\nNon è che magari... mi fareste entrare\nnel Team [team:]?", spanish="¿Qué os parecería si...\nbueno...si me uniera al [CS:X]Equipo[CR] [team:]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_PREPARE_MENU_ACCEPT_TEAM_MEMBER, 21, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_ACCEPT_TEAM_MEMBER"] or 0) -- switch(message_Menu(MENU_ACCEPT_TEAM_MEMBER)) [message_Menu(MENU_ACCEPT_TEAM_MEMBER): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 2 then
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Oh... I see...\nThat's too bad.", french="Oh... Je vois...\nC'est bien dommage.", german="Oh... Ich verstehe...\nDas ist zu schade.", italian="Oh... capisco...\nChe peccato.", spanish="Ah... Entiendo...\nEs una lástima."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Well, I'll always be here\nwaiting.", french=" Hé bien, je ne bouge pas d'ici...", german="Nun ja, ich werde immer hier\nsein und auf euch warten.", italian="Beh, se mai doveste cambiare\nidea...", spanish="Bueno, siempre estaré aquí\nesperándoos."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="If you ever happen to change\nyour mind, just come find me.", french="Si jamais vous changez d'avis,\nvous pourrez me trouver ici.", german="Wenn ihr euch je umentscheiden\nsolltet, kommt einfach vorbei.", italian=" ... io sarò qui ad aspettarvi.", spanish="Si alguna vez cambiáis de idea,\nvenid a buscarme."})
  -- message_Close
  -- jump @label_64 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Really?", french=" Vraiment?", german=" Im Ernst?", italian=" Davvero?", spanish=" ¿En serio?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Th-thank you so very much!", french=" Mer... merci mille fois!", german=" V-vielen, vielen Dank!", italian=" G-Grazie mille!", spanish=" Mu... ¡muchísimas gracias!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" I'm so incredibly happy!", french=" Je suis si heureuse, c'est fou!", german="Das macht mich so\nunglaublich fröhlich!", italian="Non sto nella pelle\ndalla felicità!", spanish=" ¡Me hacéis felicísima!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I'm so glad I finally brought\nmyself to ask!", french="Je suis si contente d'avoir\nfinalement eu le courage de vous poser\nla question.", german="Ich bin so froh, dass ich mich\nendlich getraut habe zu fragen!", italian="Che gioia! Finalmente sono\nriuscita a chiedervelo!", spanish="¡Cuánto me alegro de haberme\natrevido por fin a preguntároslo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayFanfare("Fanfare/JoinTeam") end) -- me_Play(5) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][c_name:NPC_NEW_FRIEND] joined the team!", french="[CN][c_name:NPC_NEW_FRIEND] a rejoint l'équipe!", german="[CN][c_name:NPC_NEW_FRIEND] gehört nun zum Team.", italian="[CN][c_name:NPC_NEW_FRIEND] in squadra.", spanish="[CN]¡[c_name:NPC_NEW_FRIEND] se unió al equipo!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  GAME:FadeOut(false, 30)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(60)
  GAME:FadeIn(30)
  -- jump @label_64 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[122] = 1 -- $SCENARIO_TALK_BIT_FLAG[122] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Oh, Team [team:]!", french=" Oh, l'Equipe [team:]!", german=" Oh, Team [team:]!", italian=" Oh, Team [team:]!", spanish=" ¡Ay, [CS:X]Equipo[CR] [team:]!"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="I'm so glad that you've decided\nto climb this mountain again.", french="Je suis vraiment ravie que vous\nayez décidé de gravir la montagne\nune nouvelle fois!", german="Ich bin so froh, dass ihr euch\ndafür entschieden habt, diesen Berg noch\neinmal zu besteigen.", italian="Sono così felice che abbiate\ndeciso di scalare nuovamente questa montagna.", spanish="Me alegro muchísimo de que\nhayáis decidido volver a escalar esta montaña."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="A mountain is really something\nspecial, isn't it?", french="Une montagne, c'est un lieu\nun peu spécial, non?", german="Ein Berg ist wirklich etwas\nBesonderes, nicht wahr?", italian="Una montagna è qualcosa di\nveramente speciale, non è vero?", spanish="Una montaña es un lugar\nde lo más especial, ¿no te parece?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_sheimi, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="You can forget all your\nworries and troubles here...", french="Ici, on peut oublier tous\nses soucis et ses problèmes...", german="Hier kannst du all deine Sorgen\nund Nöte vergessen...", italian="Qui tutte le preoccupazioni\ne i problemi svaniscono come per incanto...", spanish="Aquí una se olvida de todos sus\nproblemas y preocupaciones..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="I'm not sure why, but everyone\nhere is honest and openhearted.", french="Je ne sais pas très bien\npourquoi, mais tout le monde ici\nest honnête et charitable.", german="Ich weiß nicht warum, aber\nhier sind alle aufrichtig und offenherzig.", italian="Non so spiegarmelo, ma in questo\nluogo tutti si comportano in maniera onesta\ne sincera.", spanish="No sé muy bien por qué, pero\naquí todo el mundo es honesto y generoso."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" It's really strange...", french=" C'est vraiment bizarre...", german=" Es ist wirklich sonderbar...", italian=" È davvero strano...", spanish=" Es muy extraño..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sheimi, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="That reminds me,\nTeam [team:].", french="Au fait, j'y pense,\nEquipe [team:]...", german="Wo ich gerade davon spreche,\nTeam [team:]...", italian="Ora che ci penso,\nTeam [team:]...", spanish="Ah, [CS:X]Equipo[CR] [team:],\neso me recuerda que..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="I've been thinking about this for\nsome time now, and...", french="Ça fait un moment que j'y\nréfléchis maintenant et...", german="Ich habe jetzt schon eine Weile\ndarüber nachgedacht...", italian=" Ho riflettuto a lungo e...", spanish="Llevo algún tiempo pensando\nen esto y..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Looking at this mountain's\nscenery, I've finally made up my mind.", french="... en contemplant ce paysage\nmontagneux, j'ai finalement pris ma décision...", german="Und beim Betrachten dieser\nBerglandschaft habe ich einen Entschluss\ngefasst.", italian="... ammirando questo paesaggio\nho finalmente capito una cosa.", spanish="Mientras observaba el paisaje\nde esta montaña al fin me he decidido."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Um...[K] I...", french=" Heu...[K] Je...", german=" Hmmm...[K] Ich...", italian=" Ehm...[K] È...", spanish=" Hum...[K] Esto..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="I was deeply moved while\nclimbing the mountain with you,\nTeam [team:]. I won't forget it...", french="J'ai vraiment été émue de\ngravir cette montagne avec vous,\nEquipe [team:]. Je ne l'oublierai pas...", german="Mit euch den Berg zu besteigen,\nTeam [team:], war ein unvergessliches\nErlebnis. Es hat mich wirklich tief bewegt.", italian="È stato davvero emozionante\nscalare questa montagna con voi,\nTeam [team:]. Non lo dimenticherò mai...", spanish="[CS:X]Equipo[CR] [team:], me\nconmovió mucho escalar la montaña a vuestro\nlado. Es algo que no olvidaré..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="What do you think...\nThat is...letting me join Team [team:]?", french="Que diriez-vous si... enfin...\nsi je vous demandais de me laisser\nrejoindre l'Equipe [team:]?", german="Was glaubt ihr... Könnte ich bei\nTeam [team:] mitmachen?", italian="Che ne dite...\nNon è che magari... mi fareste entrare\nnel Team [team:]?", spanish="¿Qué os parecería si...\nbueno... si me uniera al [CS:X]Equipo[CR] [team:]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_PREPARE_MENU_ACCEPT_TEAM_MEMBER, 21, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_ACCEPT_TEAM_MEMBER"] or 0) -- switch(message_Menu(MENU_ACCEPT_TEAM_MEMBER)) [message_Menu(MENU_ACCEPT_TEAM_MEMBER): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Oh... I see...\nThat's too bad.", french="Oh... Je vois...\nC'est bien dommage.", german="Oh... Ich verstehe...\nDas ist zu schade.", italian="Oh... capisco...\nChe peccato.", spanish="Ah... Entiendo...\nEs una lástima."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Well, I'll always be here\nwaiting.", french=" Hé bien, je ne bouge pas d'ici...", german="Nun ja, ich werde immer hier\nsein und auf euch warten.", italian="Beh, se mai doveste cambiare\nidea...", spanish="Bueno, siempre estaré aquí\nesperándoos."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="If you ever happen to change\nyour mind, just come find me.", french="Si jamais vous changez d'avis,\nvous pourrez me trouver ici.", german="Wenn ihr euch je umentscheiden\nsolltet, kommt einfach vorbei.", italian=" ... io sarò qui ad aspettarvi.", spanish="Si alguna vez cambiáis de idea,\nvenid a buscarme."})
  -- message_Close
  -- jump @label_64 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Really?", french=" Vraiment?", german=" Im Ernst?", italian=" Davvero?", spanish=" ¿En serio?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Th-thank you so very much!", french=" M... merci mille fois!", german=" V-vielen, vielen Dank!", italian=" G-Grazie mille!", spanish=" Mu... ¡muchísimas gracias!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" I'm so incredibly happy!", french=" Je suis si heureuse, c'est fou!", german="Das macht mich so\nunglaublich fröhlich!", italian="Non sto nella pelle\ndalla felicità!", spanish=" ¡Me hacéis felicísima!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="I'm so glad I finally brought\nmyself to ask!", french="Je suis si contente d'avoir\nfinalement eu le courage de vous poser\nla question.", german="Ich bin so froh, dass ich mich\nendlich getraut habe zu fragen!", italian="Che gioia! Finalmente sono\nriuscita a chiedervelo!", spanish="¡Cuánto me alegro de haberme\natrevido por fin a preguntároslo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayFanfare("Fanfare/JoinTeam") end) -- me_Play(5) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][c_name:NPC_NEW_FRIEND] joined the team!", french="[CN][c_name:NPC_NEW_FRIEND] a rejoint l'équipe!", german="[CN][c_name:NPC_NEW_FRIEND] gehört nun zum Team.", italian="[CN][c_name:NPC_NEW_FRIEND] in squadra.", spanish="[CN]¡[c_name:NPC_NEW_FRIEND] se unió al equipo!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  GAME:FadeOut(false, 30)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(60)
  GAME:FadeIn(30)
  -- jump @label_64 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  elseif (SkyProg.cmp(29, 30) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 157 or __sw == 158 or __sw == 159 or __sw == 160 or __sw == 161 or __sw == 162 or __sw == 163 or __sw == 164 or __sw == 165 then
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Usually, [CS:N]Grimer[CR] and [CS:N]Muk[CR] should\nbe living farther down the mountain, I think...", french="Normalement, les [CS:N]Tadmorv[CR] et\nles [CS:N]Grotadmorv[CR] habitent plus bas sur la\nmontagne, je crois...", german="Gewöhnlich wohnen [CS:N]Sleima[CR] und\n[CS:N]Sleimok[CR] weiter unten am Berg...", italian="Di solito i [CS:N]Grimer[CR] e i [CS:N]Muk[CR] vivono\nnelle profondità della montagna, almeno credo...", spanish="Creo que los [CS:N]Grimer[CR] y [CS:N]Muk[CR]\nviven en la parte inferior de la montaña..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We need to do something about\nthe summit, no matter what!", french="Il faut qu'on fasse quelque chose\nau sujet du sommet, peu importe quoi!", german="Wir müssen etwas mit dem\nGipfel machen, was auch immer es sein mag!", italian="Dobbiamo raggiungere la cima\na qualsiasi costo!", spanish="Tenemos que llegar a la cima\nsea como sea."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Let's hurry, [player]!", french=" Hâtons-nous, [player]!", german=" Beeilung, [player]!", italian=" Sbrighiamoci, [player]!", spanish=" ¡Deprisa, [player]!"})
  -- message_Close
  -- jump @label_64 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_65 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sheimi, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Once you're ready, let's go!", french="Une fois que vous aurez fini\nvos préparatifs, allons-y!", german="Lasst uns aufbrechen,\nsobald ihr bereit seid!", italian="Quando avete finito di\nprepararvi, andiamo!", spanish="¡Vamos en cuanto lo tengas\ntodo listo!"})
  -- message_Close
  -- jump @label_64 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 29) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 29]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 157 or __sw == 158 then
  -- @label_70 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="The road ahead is long, so don't\npush yourself. Take your time.", french="La route est longue jusqu'au\nsommet, alors ne te précipite pas.\nPrends ton temps.", german="Der Weg vor uns ist weit, also\nsollte man es ruhig langsam angehen lassen.", italian="Ci attende un lungo cammino,\nquindi non serve farsi prendere dalla fretta.\nProcediamo con calma.", spanish="Nos aguarda un largo camino, así\nque no te exijas demasiado y tómate tu tiempo."})
  -- message_Close
  -- jump @label_64 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 159 then
  -- @label_80 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="It's said that if you give a [CS:I]Sky\nGift[CR] as a token of gratitude, it will bring\nhappiness.", french="On dit qu'offrir un [CS:I]Don du Ciel[CR]\nen gage de remerciement apporte\nchance et bonheur.", german="Wenn du aus Dankbarkeit ein\n[CS:I]Himmelspräsent[CR] verschenkst, wird es\nFrohsinn verbreiten. So erzählt man sich.", italian="Si dice che regalare\nun [CS:I]Dono Cielo[CR] come segno di ringraziamento\nsia di buon auspicio.", spanish="Se dice que, si entregas un\n[CS:I]Regalo Cielo[CR] como agradecimiento, te traerá\nfelicidad."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="How about sending some to those\nwho have always helped you, [player]?", french="Que dirais-tu d'en offrir\naux personnes qui t'apportent\nrégulièrement leur aide, [player]?", german="Was hältst du davon, welche an\njene zu versenden, die immer hilfsbereit zu\ndir waren, [player]?", italian="Che ne dici di inviarne uno\na tutti quelli che ti hanno sempre aiutato,\n[player]?", spanish="¿Qué te parece entregar alguno\na quien siempre te ha ayudado, [player]?"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="You can use the Delivery\nService in the [CS:P]Shaymin Village[CR]\nto send them. ♪", french="Pour les envoyer, il te suffit\nd'utiliser le [CS:K]Service de Livraison Shaymin[CR]\nau [CS:P]Village Shaymin[CR]. ♪", german="Du kannst den Lieferservice in\n[CS:P]Shaymin-Dorf[CR] dazu verwenden. ♪", italian="Puoi usare il Servizio Consegne\ndel [CS:P]Villaggio Shaymin[CR] per spedirli. ♪", spanish="Puedes usar el servicio de\nrepartos de [CS:P]Aldea Shaymin[CR]\npara enviarlos. ♪"})
  -- message_Close
  -- jump @label_64 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 160 then
  -- @label_96 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="I can finally relax now that I've\nreached the base.", french="Je peux enfin me détendre\nmaintenant que j'ai atteint le campement.", german="Jetzt, wo ich die Basis erreicht\nhabe, kann ich mich endlich ausruhen.", italian="Ora che abbiamo finalmente\nraggiunto la base, posso rilassarmi.", spanish="Ahora que he llegado a la base\nya puedo relajarme."})
  -- message_Close
  -- jump @label_64 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 161 then
  -- @label_103 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="This is the 5th Station Clearing![K]\nWe're halfway to the summit!", french="C'est la trouée du 5[F:E] Relais![K]\nOn est à mi-chemin du sommet!", german="Die 5. Zwischenlagerlichtung![K]\nWir sind auf halbem Weg zum Gipfel!", italian="Questo è il Bivacco 5![K]\nSiamo a metà strada!", spanish="Es la Base del Quinto Puerto.[K]\n¡Estamos a medio camino!"})
  -- message_Close
  -- jump @label_64 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 162 then
  -- @label_110 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" There's snow from here on.", french="A partir d'ici, la neige\nrecouvre tout.", german=" Von hier an liegt Schnee.", italian="Da questo punto in poi la strada\nè coperta di neve.", spanish=" A partir de aquí hallaremos nieve."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Once you've finished all your\npreparations, let's get going.", french="Une fois que tu auras fini\ntes préparatifs, poursuivons notre route!", german="Sobald alle Vorbereitungen\nabgeschlossen sind, sollten wir aufbrechen.", italian="Quando avete finito\ni preparativi, partiamo.", spanish="Cuando acabes todos tus\npreparativos nos pondremos en marcha."})
  -- message_Close
  -- jump @label_64 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 163 then
  -- @label_135 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="You meet all different kinds of\nfolks when climbing a mountain. It's so\nmuch fun!", french="Tu rencontres des tas de\nPokémon différents quand tu gravis\nune montagne. C'est si amusant!", german="Beim Bergsteigen triffst du so\nviele unterschiedliche Pokémon. Das macht\neinen Riesenspaß!", italian="Si incontrano così tanti Pokémon\ndiversi quando si scala una montagna. È così\ndivertente!", spanish="Se conoce a tanta gente\nvariopinta durante el ascenso a una montaña...\n¡Es la mar de entretenido!"})
  -- message_Close
  -- jump @label_64 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 164 then
  -- @label_145 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" I wonder if [CS:N]Sneasel[CR]'s all right...", french="Je me demande si [CS:N]Farfuret[CR]\nse porte bien...", german="Ich frage mich, ob es [CS:N]Sniebel[CR]\ngut geht...", italian=" Mi chiedo se [CS:N]Sneasel[CR] stia bene...", spanish=" Me pregunto si [CS:N]Sneasel[CR] estará bien..."})
  -- message_Close
  -- jump @label_64 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 165 then
  -- @label_155 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We're almost to the summit!\nLet's do our best!", french="Nous avons presque atteint\nle sommet! Donnons tout ce que nous avons!", german="Wir sind schon fast am Gipfel!\nGeben wir unser Bestes!", italian="Abbiamo quasi raggiunto la cima!\nAncora un piccolo sforzo!", spanish="¡Ya casi estamos en la cima!\n¡Vamos a por todas!"})
  -- message_Close
  -- jump @label_64 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_65 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 28) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 28]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 157 or __sw == 158 then
  -- jump @label_70 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 159 then
  -- jump @label_80 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 160 then
  -- jump @label_96 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 161 then
  -- jump @label_103 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 162 then
  -- jump @label_110 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 163 then
  -- jump @label_135 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 164 then
  -- jump @label_145 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 165 then
  -- jump @label_155 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_65 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 27) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 27]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 157 or __sw == 158 then
  -- jump @label_70 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 159 then
  -- jump @label_80 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 160 then
  -- jump @label_96 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 161 then
  -- jump @label_103 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 162 then
  -- jump @label_110 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 163 then
  -- jump @label_135 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 164 then
  -- jump @label_145 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_65 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 26) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 26]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 157 or __sw == 158 then
  -- jump @label_70 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 159 then
  -- jump @label_80 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 160 then
  -- jump @label_96 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 161 then
  -- jump @label_103 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 162 then
  -- jump @label_110 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 163 then
  -- jump @label_135 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 164 then
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="[CS:N]Sneasel[CR]...\nI'm so worried...", french="[CS:N]Farfuret[CR]...\nJe suis si inquiète...", german="[CS:N]Sniebel[CR]...\nIch mache mir solche Sorgen...", italian="[CS:N]Sneasel[CR]...\nSono così preoccupata...", spanish=" [CS:N]Sneasel[CR] me tiene muy preocupada..."})
  -- message_Close
  -- jump @label_64 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_65 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 25) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 25]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 157 or __sw == 158 or __sw == 159 or __sw == 160 or __sw == 161 or __sw == 162 or __sw == 163 then
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" If we don't hurry, [CS:N]Sneasel[CR]...", french="Si on ne se dépêche pas,\n[CS:N]Farfuret[CR] va...", german="Wenn wir uns nicht beeilen,\nwird [CS:N]Sniebel[CR]...", italian=" Se non ci muoviamo, [CS:N]Sneasel[CR]...", spanish=" Si no nos damos prisa, [CS:N]Sneasel[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Let's hurry to the\n8th Station Clearing!", french="Direction la trouée\ndu 8[F:E] Relais, vite!", german="Lasst uns keine Zeit verlieren\nund zur 8. Zwischenlagerlichtung eilen!", italian=" Forza, corriamo al Bivacco 8!", spanish="¡Vamos rápido a la Base del\nOctavo Puerto!"})
  -- message_Close
  -- jump @label_64 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_65 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 24) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 24]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 157 or __sw == 158 then
  -- jump @label_70 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 159 then
  -- jump @label_80 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 160 then
  -- jump @label_96 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 161 then
  -- jump @label_103 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 162 then
  -- jump @label_110 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 163 then
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="There's a Rescue Expert at\nthe 8th Station Clearing.", french="Il y a un pro du sauvetage\nà la trouée du 8[F:E] Relais.", german="Auf der 8. Zwischenlagerlichtung\ngibt es einen Rettungsexperten.", italian="Al Bivacco 8 c'è un esperto di\nsoccorsi.", spanish="En la Base del Octavo Puerto\nhay un experto en rescates."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Let's hurry, [player]!", french=" Dépêchons, [player]!", german=" Beeilen wir uns, [player]!", italian=" Sbrighiamoci, [player]!", spanish=" ¡Deprisa, [player]!"})
  -- message_Close
  -- jump @label_64 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_65 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 23) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 23]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 157 or __sw == 158 then
  -- jump @label_70 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 159 then
  -- jump @label_80 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 160 then
  -- jump @label_96 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 161 then
  -- jump @label_103 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 162 then
  -- jump @label_110 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_65 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 22) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 22]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 157 or __sw == 158 then
  -- jump @label_70 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 159 then
  -- jump @label_80 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 160 then
  -- jump @label_96 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 161 then
  -- jump @label_103 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 162 then
  -- jump @label_110 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_65 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 21) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 21]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 157 or __sw == 158 then
  -- jump @label_70 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 159 then
  -- jump @label_80 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 160 then
  -- jump @label_96 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 161 then
  -- jump @label_103 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_65 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 20) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 20]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 157 or __sw == 158 then
  -- jump @label_70 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 159 then
  -- jump @label_80 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 160 then
  -- jump @label_96 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 161 then
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" All right! Let's regroup and go!", french="Très bien! Regroupons-nous\net progressons!", german="Okay! Macht euch startklar,\nwir brechen auf!", italian="Bene! Riformiamo il gruppo\ne partiamo!", spanish="De acuerdo, reagrupémonos y,\n¡en marcha!"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="This is the 5th Station Clearing![K]\nWe're halfway to the summit!", french="C'est la trouée du 5[F:E] Relais![K]\nOn est à mi-chemin du sommet!", german="Die 5. Zwischenlagerlichtung![K]\nWir sind auf halbem Weg zum Gipfel!", italian="Questo è il Bivacco 5![K]\nSiamo a metà strada!", spanish="Es la Base del Quinto Puerto.[K]\n¡Estamos a medio camino!"})
  -- message_Close
  -- jump @label_64 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_65 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 19) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 19]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 157 or __sw == 158 or __sw == 159 or __sw == 160 then
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="[player], let's hurry up and\nhead for the 5th Station Clearing.", french="[player], dépêchons-nous\nd'atteindre la trouée du 5[F:E] Relais.", german="[player], wir sollten\nuns schnell auf den Weg zur\n5. Zwischenlagerlichtung machen.", italian="[player], muoviamoci\ne raggiungiamo il Bivacco 5.", spanish="Vamos deprisa a la Base del\nQuinto Puerto, [player]."})
  -- message_Close
  -- jump @label_64 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_65 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 18) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 18]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 157 or __sw == 158 then
  -- jump @label_70 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 159 then
  -- jump @label_80 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 160 then
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" [player]! We'll hurry too!", french="[player]!\nNous devons nous dépêcher!", german="[player]! Wir werden uns\nauch beeilen!", italian="[player]! Anche noi\ndobbiamo sbrigarci!", spanish=" ¡Démonos prisa, [player]!"})
  -- message_Close
  -- jump @label_64 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_65 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 17) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 17]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 157 or __sw == 158 then
  -- jump @label_70 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 159 then
  -- jump @label_80 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_65 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 16) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 16]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 157 or __sw == 158 then
  -- jump @label_70 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 159 then
  -- jump @label_80 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_65 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 15) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 15]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 157 or __sw == 158 then
  -- jump @label_70 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_65 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 14) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 14]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 157 then
  -- jump @label_70 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 158 then
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Mountain climbing is so great\nwhen everyone cooperates!", french="Escalader une montagne est une\nexpérience grandiose quand chacun\ny met du sien!", german="Bergsteigen ist wirklich eine\ngroßartige Sache, solange alle\nzusammenarbeiten!", italian="È così bello scalare una\nmontagna quando ci si aiuta gli uni\ncon gli altri!", spanish="¡Escalar es estupendo cuando\ntodo el mundo colabora!"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="I know. I'm just so\nincredibly excited!", french="Oui, je sais. C'est juste que je\nsuis très impatiente!", german="Genau. Ich bin nur so\nunglaublich aufgeregt!", italian="Lo so. È che sono così\nemozionata!", spanish=" ¡Aish, es que estoy nerviosísima!"})
  -- message_Close
  -- jump @label_64 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_65 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 13) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 13]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 157 then
  -- jump @label_70 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_65 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 12) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 12]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 157 then
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="[CS:P]Sky Peak[CR] has resting areas,\nlabeled 1st Station through 9th Station.", french="On trouve des bivouacs sur le\n[CS:P]Pic Céleste[CR], au niveau des trouées.\nIl y en a neuf en tout.", german="Der [CS:P]Himmelsgipfel[CR] bietet\nZwischenlagerlichtungen zum Verschnaufen.\nSie sind nummeriert von 1 bis 9.", italian="Lungo il [CS:P]Picco del Cielo[CR] ci sono\nnove aree, note come Bivacchi, dove\nè possibile fare una sosta.", spanish="La [CS:P]Cumbre del Cielo[CR] tiene zonas\nde descanso numeradas, del Primer Puerto\nal Noveno Puerto."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="The 10th Station is, of course,\nthe summit.", french="Le 10[F:E] Relais, bien sûr,\nc'est le sommet.", german="Und danach kommt\nselbstverständlich der Gipfel.", italian="Naturalmente, il Bivacco 10\nè la cima.", spanish="El Décimo Puerto obviamente es\nla cima."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="The road ahead is long, so let's\ntake it in stages.", french="La route est longue jusqu'au\nsommet, alors il vaut mieux\nprocéder par étapes.", german="Der Weg vor uns ist weit, also\nwerden wir ihn in Abschnitten bewältigen.", italian="Ci attende un lungo cammino,\nquindi dovremo procedere a tappe.", spanish="Nos aguarda un largo camino,\nasí que es mejor dividirlo en etapas."})
  -- message_Close
  -- jump @label_64 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_65 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 11) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 11]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if true then -- default
  end
  end
  -- jump @label_65 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 10) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 10]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if true then -- default
  end
  end
  -- jump @label_65 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_64 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
