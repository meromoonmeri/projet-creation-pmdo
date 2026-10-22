-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/us0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  if ((SV.SkyTalkBitFlags or {})[47] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[47]
  -- @label_75 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 59 then
  -- CallCommon CORO_SUBSCREEN_INIT (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_rapurasu = SkySceneKit.spawn_npc("lapras", 504, 152, Direction.Down, "NPC_RAPURASU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rapurasu, 4) end)
  if (SkyProg.cmp(26, 0) < 0) or ((SV.SkyTalkBitFlags or {})[43] == 1) then -- if ROM: scn($SCENARIO_MAIN) < [26, 0] || $SCENARIO_TALK_BIT_FLAG[43]
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="Would you like to return to\nTreasure Town now?", french="Voulez-vous regagner\nBourg-Trésor maintenant?", german="Möchtet ihr jetzt nach\nSchatzstadt zurückkehren?", italian=" Volete tornare a Borgo Tesoro?", spanish=" ¿Queréis volver a Aldea Tesoro?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- @label_136 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" I see.", french=" Je vois.", german=" Ich verstehe.", italian=" Capisco.", spanish=" Entiendo."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" Off we go to Treasure Town!", french=" En route pour Bourg-Trésor!", german=" Auf nach Schatzstadt!", italian=" Andiamo a Borgo Tesoro!", spanish=" ¡Vamos a Aldea Tesoro!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- main_EnterGround(LEVEL_D01P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else -- default/annulation
  -- @label_135 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" I see.", french=" Je vois.", german=" Ich verstehe.", italian=" Capisco.", spanish=" Entiendo."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="Then good luck reaching\n[CS:P]Temporal Tower[CR]!", french="Bonne chance pour atteindre\nla [CS:P]Tour du Temps[CR]!", german="Dann viel Glück für den Weg\nzum [CS:P]Zeitturm[CR]!", italian="Allora in bocca al lupo per il\nviaggio verso la [CS:P]Torre del Tempo[CR]!", spanish="Espero que tengáis suerte y que\nconsigáis llegar a la [CS:P]Torre del Tiempo[CR]."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_EVENT_END_FREE (fermeture/attente message: géré par say())
  end
  end
  else
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="Would you like to return to\nTreasure Town now?", french="Voulez-vous regagner\nBourg-Trésor maintenant?", german="Möchtet ihr jetzt nach\nSchatzstadt zurückkehren?", italian=" Volete tornare a Borgo Tesoro?", spanish=" ¿Queréis volver a Aldea Tesoro?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_135 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[43] = 1 -- $SCENARIO_TALK_BIT_FLAG[43] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="Oh?[K] I don't seem to see [CS:N]Grovyle[CR]\nanywhere...", french="Ah?[K] Nulle part je n'aperçois\n[CS:N]Massko[CR]...", german="Oh?[K] Ich kann [CS:N]Reptain[CR] nirgendwo\nausmachen.", italian="Eh?[K] Non mi sembra di vedere\n[CS:N]Grovyle[CR]...", spanish="¿Eh?[K] No veo a [CS:N]Grovyle[CR] por\nninguna parte..."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" [CS:N]Grovyle[CR] is...?", french=" [CS:N]Massko[CR] est...?", german=" [CS:N]Reptain[CR] ist...", italian=" [CS:N]Grovyle[CR] è...?", spanish=" ¿Y [CS:N]Grovyle[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Lapras[CR]...[K]well, [CS:N]Grovyle[CR] is...", french=" [CS:N]Lokhlass[CR]... [K]euh, [CS:N]Massko[CR] est...", german=" [CS:N]Lapras[CR]...[K] Nun, [CS:N]Reptain[CR] ist...", italian=" [CS:N]Lapras[CR]...[K] beh, [CS:N]Grovyle[CR] è...", spanish="[CS:N]Lapras[CR]...[K] La verdad es que\n[CS:N]Grovyle[CR] ha..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Lapras[CR]...[K]well, [CS:N]Grovyle[CR] is...", french=" [CS:N]Lokhlass[CR]... [K]euh, [CS:N]Massko[CR] est...", german=" [CS:N]Lapras[CR]...[K] Nun, [CS:N]Reptain[CR] ist...", italian=" [CS:N]Lapras[CR]...[K] beh, [CS:N]Grovyle[CR] è...", spanish="[CS:N]Lapras[CR]...[K] La verdad es que\n[CS:N]Grovyle[CR] ha..."})
  else
  SkySceneKit.say({english=" [CS:N]Lapras[CR]...[K]well, [CS:N]Grovyle[CR] is...", french=" [CS:N]Lokhlass[CR]... [K]euh, [CS:N]Massko[CR] est...", german=" [CS:N]Lapras[CR]...[K] Nun, [CS:N]Reptain[CR] ist...", italian=" [CS:N]Lapras[CR]...[K] beh, [CS:N]Grovyle[CR] è...", spanish="[CS:N]Lapras[CR]...[K] La verdad es que\n[CS:N]Grovyle[CR] ha..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" ...[K]N-n-no...[K]it can't be...", french=" ... [K]N-n-non... [K]c'est impossible...", german="...[K]N-n-neiiiiin![K] Das kann\nnicht sein!", italian=" ...[K] N-No...[K] Non può essere...", spanish=" No...[K] No...[K] No puede ser..."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" [CS:N]Grovyle[CR] is...?", french=" [CS:N]Massko[CR] est...?", german=" [CS:N]Reptain[CR] ist...", italian=" [CS:N]Grovyle[CR] è...?", spanish=" ¿[CS:N]Grovyle[CR] ha...?"})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="...Well...[K]I see...[K] I find it hard to\naccept, but...", french="... Bien... [K]Je vois...[K] C'est\ndifficile à admettre, mais...", german="...Nun...[K] Ich verstehe...[K] Ich kann\nes nur schwer begreifen, aber...", italian="Bene...[K] capisco...[K] è difficile\nda accettare, ma...", spanish="De acuerdo...[K] Entiendo...[K]\nMe resulta duro aceptarlo, pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" For now...[K]we must go onward...", french="Pour l'instant... [K]nous devons\naller de l'avant...", german="Fürs Erste[K] müssen wir\nvoranschreiten.", italian="Per ora...[K] dobbiamo guardare\navanti...", spanish="Ahora...[K] tenemos que seguir\nadelante..."})
  -- jump @label_136 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  elseif __sw == 11 then
  -- @label_132 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_SUBSCREEN_INIT (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rapurasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="Would you like to go to the\n[CS:P]Hidden Land[CR]?", french="Voulez-vous aller dans les\n[CS:P]Terres Illusoires[CR]?", german="Möchtet ihr in das\n[CS:P]Verborgene Land[CR] reisen?", italian="Volete andare alla [CS:P]Terra[CR]\n[CS:P]Nascosta[CR]?", spanish=" ¿Queréis ir a la [CS:P]Tierra Oculta[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- @label_137 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_TEAM_SETUP_HERO_AND_PARTNER_ONLY"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_HERO_) [ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_HERO_AND_PARTNER_ONLY): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" I see.", french=" Je vois.", german=" Ich verstehe.", italian=" Capisco.", spanish=" Entiendo."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" Off we go to the [CS:P]Hidden Land[CR].", french="En route pour les [CS:P]Terres\nIllusoires[CR].", german=" Auf in das [CS:P]Verborgene Land[CR].", italian=" Andiamo alla [CS:P]Terra Nascosta[CR].", spanish=" Vamos a la [CS:P]Tierra Oculta[CR]."})
  -- message_Close
  if (SkyProg.cmp(29, 1) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 1]
  -- debug_Print('BGM_FADEOUT') [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- main_EnterDungeon(38, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(30)
  GAME:WaitFrames(1) -- hold
  else
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- main_EnterGround(LEVEL_D27P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  elseif true then -- default
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_TEAM_SETUP_PARTNER_AND_HERO_ONLY"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_PARTN) [ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_PARTNER_AND_HERO_ONLY): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [hero].", french=" Ecoute, [hero].", german=" Hey, [hero].", italian=" Ehi, [hero].", spanish=" Oye, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Listen, [hero].", french=" Ecoute, [hero].", german=" Hör mal, [hero].", italian=" Ascolta, [hero].", spanish=" Oye, [hero]."})
  else
  SkySceneKit.say({english=" Say, [hero].", french=" Ecoute, [hero].", german=" Hör mal, [hero].", italian=" Senti, [hero].", spanish=" Oye, [hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="When we go to the [CS:P]Hidden Land[CR],\nyou should be the leader, [hero].", french="Quand on ira dans les [CS:P]Terres\nIllusoires[CR], tu devrais prendre la tête\ndu groupe, [hero].", german="Wenn wir in das\n[CS:P]Verborgene Land[CR] reisen, solltest du der\nAnführer sein, [hero].", italian="Quando andiamo alla [CS:P]Terra[CR]\n[CS:P]Nascosta[CR], dovresti essere tu il leader,\n[hero].", spanish="Tú deberías ir de líder cuando\nvayamos a la [CS:P]Tierra Oculta[CR], [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="When we go to the [CS:P]Hidden Land[CR],\nyou should be the leader, [hero].", french="Quand on ira dans les [CS:P]Terres\nIllusoires[CR], tu devrais prendre la tête\ndu groupe, [hero].", german="Wenn wir in das\n[CS:P]Verborgene Land[CR] reisen, solltest du der\nAnführer sein, [hero].", italian="Quando andiamo alla [CS:P]Terra[CR]\n[CS:P]Nascosta[CR], dovresti essere tu il leader,\n[hero].", spanish="Tú deberías ir de líder cuando\nvayamos a la [CS:P]Tierra Oculta[CR], [hero]."})
  else
  SkySceneKit.say({english="When we go to the [CS:P]Hidden Land[CR],\nyou should be the leader, [hero].", french="Quand on ira dans les [CS:P]Terres\nIllusoires[CR], tu devrais prendre la tête\ndu groupe, [hero].", german="Wenn wir in das\n[CS:P]Verborgene Land[CR] reisen, solltest du der\nAnführer sein, [hero].", italian="Quando andiamo alla [CS:P]Terra[CR]\n[CS:P]Nascosta[CR], dovresti essere tu il leader,\n[hero].", spanish="Tú deberías ir de líder cuando\nvayamos a la [CS:P]Tierra Oculta[CR], [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="After all, that's the way we've\nalways done it for important missions.", french="Après tout, on a toujours fait\ncomme ça pour les missions importantes.", german="Schließlich haben wir das auf\nallen wichtigen Missionen so gehandhabt.", italian="Dopotutto, abbiamo sempre fatto\ncosì per le missioni importanti.", spanish="Al fin y al cabo, eso es lo que\nhemos hecho en todas nuestras misiones\nimportantes."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="After all, that's the way we've\nalways handled things on important missions.", french="Après tout, on a toujours fait\ncomme ça pour les missions importantes.", german="Schließlich haben wir die Dinge\nauf allen wichtigen Missionen so gehandhabt.", italian="Dopotutto, abbiamo sempre fatto\nin questo modo durante le missioni importanti.", spanish="Al fin y al cabo, eso es lo que\nhemos hecho en todas nuestras misiones\nimportantes."})
  else
  SkySceneKit.say({english="After all, that's the way we've\nalways done it for important missions.", french="Après tout, on a toujours fait\ncomme ça pour les missions importantes.", german="Schließlich haben wir das auf\nallen wichtigen Missionen so gehandhabt.", italian="Dopotutto, abbiamo sempre fatto\ncosì per le missioni importanti.", spanish="Al fin y al cabo, eso es lo que\nhemos hecho en todas nuestras misiones\nimportantes."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So I was thinking you should be\nleader again, [hero].[K] What do you think?", french="Alors j'ai pensé que tu devrais\nêtre le meneur à nouveau, [hero].[K]\nQu'est-ce que tu en penses?", german="Also dachte ich, dass du wieder\nder Anführer sein solltest, [hero].[K] Was\nmeinst du?", italian="Così, pensavo che dovresti di\nnuovo fare il leader, [hero].[K] Cosa ne\npensi?", spanish="¿Qué opinas, [hero]?[K]\n¿No deberías liderar tú?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So I was thinking you should be\nleader again, [hero].[K] What do you think?", french="Alors j'ai pensé que tu devrais\nêtre le meneur à nouveau, [hero].[K]\nQu'est-ce que tu en penses?", german="Also dachte ich, dass du wieder\nder Anführer sein solltest, [hero].[K] Was\nmeinst du?", italian="Così, pensavo che dovresti di\nnuovo fare il leader, [hero].[K] Cosa ne\npensi?", spanish="¿Qué opinas, [hero]?[K]\n¿No deberías liderar tú?"})
  else
  SkySceneKit.say({english="So I was thinking you should be\nleader again, [hero].[K] What do you think?", french="Alors j'ai pensé que tu devrais\nêtre le meneur à nouveau, [hero].[K]\nQu'est-ce que tu en penses?", german="Also dachte ich, dass du wieder\nder Anführer sein solltest, [hero].[K] Was\nmeinst du?", italian="Così, pensavo che dovresti di\nnuovo fare il leader, [hero].[K] Cosa ne\npensi?", spanish="¿Qué opinas, [hero]?[K]\n¿No deberías liderar tú?"})
  end
  do local __choice = SkySceneKit.ask({{english="Accept leadership", french="Accepter d'être le meneur", german="Annehmen und Anführer werden", italian="Voglio essere il leader", spanish="Aceptar liderazgo"}, {english="Refuse", french="Refuser", german="Ablehnen", italian="Non voglio essere il leader", spanish="Rechazar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Whoa![K] Hang on, we're going with\nme as leader?", french="Hé![K] Attends, alors finalement\nc'est moi le meneur?", german="Boah![K] Warte mal... Wir gehen\nmit mir als Anführer?", italian="Ehi![K] Aspetta, stiamo andando\ncon me come leader?", spanish="¡Alto![K] Espera un momento...\n¿vamos a ir allí conmigo de líder?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What?[K] Wait, so I'm going as\nthe leader?", french="Hé![K] Attends, alors finalement\nc'est moi le meneur?", german="Ähem?[K] Warte mal, also ich soll\nder Anführer sein?", italian="Cosa?[K] Aspetta, quindi sarò io\na fare il leader?", spanish="¡Alto![K] Espera un momento...\n¿Vamos a ir allí conmigo de líder?"})
  else
  SkySceneKit.say({english="Pardon?[K] So I'm going to go as\nthe leader?", french="Hé![K] Attends, alors finalement\nc'est moi le meneur?", german="Bitte?[K] Ich werde als\nAnführer mitgehen?", italian="Scusa?[K] Quindi sarò io a fare\nda leader?", spanish="¡Alto![K] Espera un momento...\n¿vamos a ir allí conmigo de líder?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hmm...[K] I don't feel confident\nabout doing that...", french="Hmm...[K] Je n'ai pas assez\nconfiance en moi pour mener notre équipe...", german="Hmm,[K] ich bin mir da nicht so\nsicher.", italian="Uhm...[K] Non mi sento tanto a\nmio agio in questo ruolo...", spanish="Hum...[K] No me siento cómodo\nocupando esa posición..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hmm...[K] I don't have the\nconfidence to do that...", french="Hmm...[K] Je n'ai pas assez\nconfiance en moi pour mener notre équipe...", german="Hmm,[K] ich traue mir das nicht so\nrecht zu.", italian="Uhm...[K] Non so se sono in grado\ndi farlo...", spanish="Hum...[K] No me siento cómodo\nocupando esa posición..."})
  else
  SkySceneKit.say({english="Hmm...[K] I don't feel confident\nenough to be the leader...", french="Hmm...[K] Je n'ai pas assez\nconfiance en moi pour mener notre équipe...", german="Hmm,[K] ich fühle mich nicht sicher\ngenug, um als Anführer zu fungieren.", italian="Uhm...[K] Non credo che il ruolo di\nleader faccia per me...", spanish="Hum...[K] No me siento cómoda\nocupando esa posición..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If we go to the [CS:P]Hidden Land[CR], you\nshould be the leader, [hero]...", french="Si nous allons dans les [CS:P]Terres\nIllusoires[CR], c'est toi qui devrais être meneur,\n[hero]...", german="Falls wir in das\n[CS:P]Verborgene Land[CR] reisen, solltest du der\nAnführer sein, [hero].", italian="Se andiamo alla [CS:P]Terra Nascosta[CR]\ndovresti essere tu il leader, [hero]...", spanish="Si vamos a la [CS:P]Tierra Oculta[CR],\ntú deberías ir de líder, [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If we go to the [CS:P]Hidden Land[CR], you\nshould be the leader, [hero]...", french="Si nous allons dans les [CS:P]Terres\nIllusoires[CR], c'est toi qui devrais être meneur,\n[hero]...", german="Falls wir in das\n[CS:P]Verborgene Land[CR] reisen, solltest du der\nAnführer sein, [hero].", italian="Se andiamo alla [CS:P]Terra Nascosta[CR]\ndovresti essere tu il leader, [hero]...", spanish="Si vamos a la [CS:P]Tierra Oculta[CR],\ntú deberías ir de líder, [hero]..."})
  else
  SkySceneKit.say({english="If we go to the [CS:P]Hidden Land[CR], you\nshould be the leader, [hero]...", french="Si nous allons dans les [CS:P]Terres\nIllusoires[CR], c'est toi qui devrais être meneur,\n[hero]...", german="Falls wir in das\n[CS:P]Verborgene Land[CR] reisen, solltest du der\nAnführer sein, [hero].", italian="Se andiamo alla [CS:P]Terra Nascosta[CR]\ndovresti essere tu il leader, [hero]...", spanish="Si vamos a la [CS:P]Tierra Oculta[CR],\ntú deberías ir de líder, [hero]..."})
  end
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Cool![K] That's it, then!\nNow [hero]'s the leader!", french="Génial![K] Alors ça marche!\nMaintenant, c'est [hero] le meneur!", german="Prima![K] Dann sind wir uns einig!\nJetzt ist [hero] der Anführer!", italian="Fantastico![K] È fatta, allora!\nOra [hero] è il leader!", spanish="¡Genial![K] ¡Entonces ya está!\n¡Ahora [hero] vuelve a ser líder!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="OK![K] That's settled. You're the\nleader, [hero]!", french="Génial![K] Alors ça marche!\nMaintenant, c'est [hero] le meneur!", german="Okay![K] Das wäre somit erledigt.\nDu bist der Anführer, [hero]!", italian="Ok![K] È deciso, sei il leader della\nsquadra, [hero]!", spanish="¡Genial![K] ¡Entonces ya está!\n¡Ahora [hero] vuelve a ser líder!"})
  else
  SkySceneKit.say({english="OK![K] You're the team leader,\n[hero]!", french="Génial![K] Alors ça marche!\nMaintenant, c'est [hero] le meneur!", german="Okay![K] Du bist der Anführer des\nTeams, [hero]!", italian="Ok![K] Sei il leader della squadra,\n[hero]!", spanish="¡Genial![K] ¡Entonces ya está!\n¡Ahora [hero] vuelve a ser líder!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go! Off to the [CS:P]Hidden Land[CR]!", french="On y va! En route pour les\n[CS:P]Terres Illusoires[CR]!", german="Los geht's! Auf in das\n[CS:P]Verborgene Land[CR]!", italian=" Andiamo! Alla [CS:P]Terra Nascosta[CR]!", spanish=" ¡Adelante! ¡A la [CS:P]Tierra Oculta[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go! Off to the [CS:P]Hidden Land[CR]!", french="On y va! En route pour les\n[CS:P]Terres Illusoires[CR]!", german="Los geht's! Auf in das\n[CS:P]Verborgene Land[CR]!", italian=" Andiamo! Alla [CS:P]Terra Nascosta[CR]!", spanish=" ¡Adelante! ¡A la [CS:P]Tierra Oculta[CR]!"})
  else
  SkySceneKit.say({english=" Let's go! Off to the [CS:P]Hidden Land[CR]!", french="On y va! En route pour les\n[CS:P]Terres Illusoires[CR]!", german="Los geht's! Auf in das\n[CS:P]Verborgene Land[CR]!", italian=" Andiamo! Alla [CS:P]Terra Nascosta[CR]!", spanish=" ¡Adelante! ¡A la [CS:P]Tierra Oculta[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rapurasu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_rapurasu, 4) end)
  -- jump @label_137 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  -- @label_141 [étiquette de flux ExplorerScript]
  if (SkyProg.cmp(26, 1) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [26, 1]
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="The [CS:P]Hidden Land[CR] is a pure place\nwhere only the chosen may go.", french="Les [CS:P]Terres Illusoires[CR] sont une\nrégion où seuls les élus peuvent\nse rendre.", german="Das [CS:P]Verborgene Land[CR] ist ein\nreiner Ort, zu dem nur Auserwählte Zugang\nhaben.", italian="La [CS:P]Terra Nascosta[CR] è un luogo\npuro, accessibile solo a pochi prescelti.", spanish="La [CS:P]Tierra Oculta[CR] es un lugar\npuro al que solo pueden ir los elegidos."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="Only the two of you may go,\n[hero] and [partner]...[K] Is that OK?", french="Vous ne pouvez y aller qu'à\ndeux, [hero] et [partner]...[K]\nCela vous convient-il?", german="Nur ihr beide dürft gehen,\n[hero] und [partner].[K] Ist das\nin Ordnung?", italian="Potete andarci solo voi due,\n[hero] e [partner]...[K] Va bene?", spanish="Solo pueden ir [hero] y\n[partner].[K] ¿Os parece bien?"})
  do local __choice = SkySceneKit.ask({{english="Go as a duo", french="Partir à deux", german="Als Duo gehen", italian="Accetta.", spanish="Ir en pareja"}, {english="Don't go", french="Rester", german="Nicht gehen", italian="Non andare.", spanish="No ir"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- @label_138 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" I see.", french=" Je vois.", german=" Ich verstehe.", italian=" Capisco.", spanish=" Entiendo."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="Then please tell me anytime\nthat you want to go to the [CS:P]Hidden Land[CR] again.", french="Faites-moi savoir si jamais vous\nvoulez retourner dans les [CS:P]Terres Illusoires[CR].", german="Dann sagt mir Bescheid, wenn\nihr wieder in das [CS:P]Verborgene Land[CR] reisen\nmöchtet.", italian="Quando volete ritornare alla\n[CS:P]Terra Nascosta[CR], fatemelo sapere.", spanish="Avisadme cuando queráis volver\na la [CS:P]Tierra Oculta[CR]."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- jump @label_137 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="The [CS:P]Hidden Land[CR] is a pure place\nwhere only the chosen may go.", french="Les [CS:P]Terres Illusoires[CR] sont une\nune région où seuls les élus peuvent\nse rendre.", german="Das [CS:P]Verborgene Land[CR] ist ein\nreiner Ort, zu dem nur Auserwählte Zugang\nhaben.", italian="La [CS:P]Terra Nascosta[CR] è un luogo\npuro, accessibile solo a pochi prescelti.", spanish="La [CS:P]Tierra Oculta[CR] es un lugar\npuro al que solo pueden ir los elegidos."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="You may not bring other team\nmembers.", french="Vous ne pouvez pas emmener\nd'autres membres de l'équipe.", german="Du kannst keine anderen\nTeam-Mitglieder mitbringen.", italian="Non puoi portare altri membri\ndella squadra.", spanish="No podéis llevar a ningún otro\ncompañero de equipo."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="Just the three of you...\n[hero], [partner], and [CS:N]Grovyle[CR]...\nhave been chosen.", french="Seuls vous trois...\n[hero], [partner] et [CS:N]Massko[CR]...\navez été élus.", german="Nur ihr drei, [hero],\n[partner] und [CS:N]Reptain[CR] wurdet auserwählt.", italian="Solo voi tre... [hero],\n[partner] e [CS:N]Grovyle[CR]...\nSiete voi i prescelti.", spanish="Solo podéis ir vosotros tres...\n[hero], [partner] y [CS:N]Grovyle[CR] habéis\nsido elegidos."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="So only your trio may go. Is that\nall right?", french="Alors vous ne pouvez y aller que\ntous les trois. Cela vous convient-il?", german="Also darf nur euer Trio gehen.\nAlles klar?", italian="Quindi potete andarci solo voi\ntre. Va bene?", spanish="Así que tendréis que ir los tres\njuntos. ¿Os parece bien?"})
  do local __choice = SkySceneKit.ask({{english="Go as a trio", french="Partir à trois", german="Als Trio gehen", italian="Accetta.", spanish="Ir en trío"}, {english="Don't go", french="Rester", german="Nicht gehen", italian="Non andare.", spanish="No ir"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_138 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- jump @label_137 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  end
  else -- default/annulation
  -- jump @label_138 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[47] = 1 -- $SCENARIO_TALK_BIT_FLAG[47] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rapurasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="Oh?[K] Someone was nearly\novercome by the waves at this beach?", french="Ah?[K] Quelqu'un a failli se noyer\nsur cette plage?", german="Oh?[K] Jemand wurde fast von den\nWellen an diesem Strand überwältigt?", italian="Eh?[K] Qualcuno è stato quasi\nportato via dalle onde su questa spiaggia?", spanish="¿Eh?[K] ¿Alguien casi se ahoga\nentre las olas de la playa?"})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="That's terrible! I'm sorry...[K]\nI never knew that happened...", french="C'est affreux! Je suis désolé...[K]\nJe n'en avais aucune idée...", german="Das ist ja schrecklich! Es tut\nmir leid.[K] Ich wusste nichts davon.", italian="È terribile! Mi dispiace...[K]\nNon ne sapevo nulla...", spanish="¡Qué espanto! Lo siento...[K]\nNo tenía ni idea de eso..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 93] || scn($SCENARIO_MAIN) >= [2
  if ((SV.SkyTalkBitFlags or {})[46] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[46]
  -- jump @label_75 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[46] = 1 -- $SCENARIO_TALK_BIT_FLAG[46] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rapurasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" Oh...[K]I see...", french=" Oh... [K]Je vois...", german=" Oh,[K] ich verstehe...", italian=" Oh...[K] capisco...", spanish=" Oh...[K] Ya veo..."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="[CS:N]Darkrai[CR] was shattered along\nwith the dimensional hole...", french="[CS:N]Darkrai[CR] a été anéanti en même\ntemps que le gouffre dimensionnel...", german="[CS:N]Darkrai[CR] wurde zusammen mit\ndem dimensionalen Loch zerschmettert.", italian="[CS:N]Darkrai[CR] si è eclissato\nnel tunnel dimensionale...", spanish="[CS:N]Darkrai[CR] estaba en el interior del\nagujero dimensional cuando se hizo añicos..."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="He has likely lost his memory\nand been banished to some unknown place...", french="Sans doute a-t-il perdu la\nmémoire et été banni dans un lieu inconnu...", german="Wahrscheinlich hat er sein\nGedächtnis verloren und wurde an einen\nunbekannten Ort verbannt.", italian="Probabilmente ha perso la\nmemoria ed è stato esiliato in qualche\nposto sconosciuto lontano da qui...", spanish="Entonces debe de haber perdido\nla memoria y aparecido en un lugar extraño\ny remoto..."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" That could be a very good thing.", french="C'est peut-être une très bonne\nchose.", german="Das könnte eine sehr gute Sache\nsein.", italian=" È una cosa positiva.", spanish=" Eso sería estupendo..."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="For the world, certainly![K]\nBut maybe for [CS:N]Darkrai[CR] too...", french="Pour le monde, bien sûr![K]\nMais peut-être aussi pour [CS:N]Darkrai[CR]...", german="Für die Welt bestimmt![K] Aber\nvielleicht auch für [CS:N]Darkrai[CR]!", italian="Per il mondo, certo![K]\nMa forse anche per [CS:N]Darkrai[CR]...", spanish="¡Para el mundo, quiero decir![K]\nY quién sabe si también para [CS:N]Darkrai[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" Well...that is over.", french=" Bien... tout est terminé.", german=" Nun, das ist jetzt vorbei.", italian=" Bene... è tutto finito.", spanish=" Bueno... Eso ya es historia."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="Peace has returned...[K]and it's\nyour team's doing, [hero]!", french="La paix est revenue... [K]et c'est\ngrâce à ton équipe, [hero]!", german="Es herrscht wieder Frieden,[K] und\ndas haben wir deinem Team zu verdanken,\n[hero]!", italian="È tornata la pace...[K] ed è\nmerito della tua squadra, [hero]!", spanish="Hemos recobrado la paz y la\ntranquilidad...[K] ¡y todo gracias a tu equipo,\n[hero]!"})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" Thank you very much!", french=" Merci beaucoup!", german=" Vielen Dank!", italian=" Grazie mille!", spanish=" ¡Muchísimas gracias!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  if ((SV.SkyTalkBitFlags or {})[45] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[45]
  -- jump @label_75 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[45] = 1 -- $SCENARIO_TALK_BIT_FLAG[45] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rapurasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="The whole plot to destroy\n[CS:P]Temporal Tower[CR]...", french="Tout ce complot visant à\ndétruire la [CS:P]Tour du Temps[CR]...", german="Der gesamte Plan zur\nZerstörung des [CS:P]Zeitturms[CR]...", italian="Il complotto per distruggere la\n[CS:P]Torre del Tempo[CR]...", spanish="Toda esta conspiración para\ndestruir la [CS:P]Torre del Tiempo[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="and the plot to expand the\ndistortion of space itself...", french="... et à aggraver la distorsion\nde l'espace lui-même...", german="Und das Komplott zur\nErweiterung der Raumkrümmung selbst...", italian="Il piano per espandere la\ndistorsione dello spazio...", spanish="Y los planes para expandir la\ndeformación del espacio..."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="It was all put into motion by\nthat wicked Pokémon [CS:N]Darkrai[CR]...", french="... c'est ce Pokémon maléfique,\n[CS:N]Darkrai[CR], qui avait tout manigancé...", german="All das wurde von dem\nbösartigen Pokémon [CS:N]Darkrai[CR] angezettelt...", italian="È tutta opera di quel\nmanigoldo di [CS:N]Darkrai[CR]...", spanish="Todo fue urdido por ese malvado\n[CS:N]Darkrai[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="I must add my voice to all those\nalready pleading for your help, [hero].", french="Moi aussi, je me joins à tous\nceux qui implorent ton aide, [hero].", german="Ich muss meine Stimme denen\nhinzufügen, die bereits um deine Hilfe bitten,\n[hero].", italian="Devo aggiungere la mia voce a\ntutte quelle che già chiedono il vostro aiuto,\n[hero].", spanish="Debo sumar mi voz a la de todos\nlos que piden tu ayuda, [hero]."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="Please stop [CS:N]Darkrai[CR]'s\nawful scheme!", french="Je vous conjure de contrecarrer\nles horribles projets de cet infâme [CS:N]Darkrai[CR]!", german="Bitte verhindere den\nschrecklichen Plan von [CS:N]Darkrai[CR]!", italian="Per favore, fermate il terribile\npiano di [CS:N]Darkrai[CR]!", spanish="¡Tenéis que detener los terribles\nplanes de [CS:N]Darkrai[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" Bring lasting peace to the world!", french="Ramenez une paix durable en ce\nmonde!", german="Bring der Welt fortwährenden\nFrieden!", italian="Date al mondo una pace\nduratura!", spanish="¡Tenéis que devolver al mundo la\npaz y la tranquilidad de una vez por todas!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 76] || scn($SCENARIO_MAIN) >= [2
  -- jump @label_132 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56] || scn($SCENARIO_MAIN) >= [2
  -- jump @label_75 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 6] || scn($SCENARIO_MAIN) >= [29
  if ((SV.SkyTalkBitFlags or {})[44] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[44]
  -- jump @label_75 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[44] = 1 -- $SCENARIO_TALK_BIT_FLAG[44] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rapurasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="You graduated from the guild![K]\nCongratulations!", french="Vous avez obtenu votre diplôme\nde la Guilde![K] Félicitations!", german="Ihr habt den Gildenabschluss\nerworben![K] Glückwunsch!", italian="Avete passato l'esame della\nGilda![K] Congratulazioni!", spanish="¡Habéis superado el gran reto![K]\n¡Enhorabuena!"})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="I'm sure that will open you to\neven more as an exploration team!", french="Je suis sûr que ça va vous\nouvrir de nouvelles perspectives dans le\ndomaine de l'exploration!", german="Ich glaube, das wird euch für\nmehr als bloßes Erkunden bereit machen!", italian="Sono sicuro che ora sarete anche\npiù di una squadra d'esplorazione!", spanish="¡Estoy seguro de que eso\nampliará vuestras posibilidades como\nequipo de exploración!"})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="Consider me a big supporter![K]\nBest of luck!", french="Je suis un de vos admirateurs\nles plus fervents![K] Bonne chance!", german="Betrachtet mich als einen\ngroßen Unterstützer![K] Viel Glück!", italian="Consideratemi un grande\ntifoso![K] Buona fortuna!", spanish="¡Podéis contar con mi apoyo![K]\n¡Muchísima suerte!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4] || scn($SCENARIO_MAIN) >= [29
  if ((SV.SkyTalkBitFlags or {})[43] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[43]
  -- jump @label_75 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[43] = 1 -- $SCENARIO_TALK_BIT_FLAG[43] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_rapurasu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="I'm glad you were able to halt\n[CS:P]Temporal Tower[CR]'s destruction.", french="Je suis heureux que vous ayez\npu mettre un terme à la destruction de la [CS:P]Tour\ndu Temps[CR].", german="Ich bin froh, dass ihr die\nZerstörung des [CS:P]Zeitturms[CR] abwenden konntet.", italian="Sono contento che abbiate\nevitato la distruzione della [CS:P]Torre del Tempo[CR].", spanish="Me alegro de que pudierais\ndetener la destrucción de la [CS:P]Torre del[CR]\n[CS:P]Tiempo[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="And [hero] even returned\nsafely...[K] I'm delighted to hear it.", french="Et [hero] a même réussi\nà revenir indemne...[K] Enchanté de l'apprendre.", german="Und [hero] ist sogar\nunversehrt zurückgekehrt.[K] Ich bin erfreut,\ndas zu hören.", italian="E anche [hero] è ancora\nqui con noi...[K] Che gioia!", spanish="Incluso [hero] ha podido\nregresar a salvo...[K] Me alegra saberlo."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="Finally, the world is at peace.[K]\nYour exploration team is back in action too.", french="La paix règne enfin sur le\nmonde.[K] Et votre équipe d'exploration peut\naussi reprendre ses activités.", german="Endlich herrscht wieder Frieden\nauf der Welt.[K] Euer Erkundungsteam ist auch\nwieder im Einsatz.", italian="Finalmente, il mondo è in pace.[K]\nE la vostra squadra d'esplorazione è di nuovo\nin azione.", spanish="Por fin, el mundo está en paz...[K]\ny tu equipo vuelve a entrar en acción."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="Please tell me whenever you\nwant to go to the [CS:P]Hidden Land[CR] again.", french="Faites-moi savoir si jamais\nvous voulez retourner dans les [CS:P]Terres\nIllusoires[CR].", german="Bitte lasst es mich wissen, wenn\nihr erneut in das [CS:P]Verborgene Land[CR] reisen wollt.", italian="Quando volete tornare alla\n[CS:P]Terra Nascosta[CR], ditelo a me.", spanish="Avisadme cuando queráis\nregresar a la [CS:P]Tierra Oculta[CR]."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- jump @label_75 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
