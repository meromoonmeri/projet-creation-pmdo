-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99A/s22p0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 184, 144, Direction.DownLeft, "NPC_KURESERIA")
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kureseria, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kureseria, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kureseria, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Are you ready to go to the\n[CS:P]Dark Crater[CR]?", french="Pouvons-nous nous rendre\nau [CS:P]Cratère Obscur[CR]?", german="Seid ihr bereit, zum\n[CS:P]Dunkelkrater[CR] zu gehen?", italian="Possiamo partire per il [CS:P]Cratere[CR]\n[CS:P]Oscuro[CR]?", spanish="¿Todo listo para partir al\n[CS:P]Cráter Oscuro[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Ready", french="On y va!", german="Ja", italian="Sì", spanish="¡Todo listo!"}, {english="Not yet", french="Pas encore.", german="Noch nicht", italian="Non ancora", spanish="Todavía no"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_TEAM_SETUP_HERO_AND_PARTNER_ONLY"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_HERO_) [ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_HERO_AND_PARTNER_ONLY): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  -- @label_2 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Very well.", french=" Très bien.", german=" In Ordnung.", italian=" Molto bene.", spanish=" Muy bien."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Let us be on our way![K] Off we go\nto the [CS:P]Dark Crater[CR]!", french="En route![K] C'est parti pour\nle [CS:P]Cratère Obscur[CR]!", german="Machen wir uns auf den Weg![K]\nAuf zum [CS:P]Dunkelkrater[CR]!", italian=" Andiamo...[K] al [CS:P]Cratere Oscuro[CR]!", spanish="¡En marcha![K] ¡Rumbo al\n[CS:P]Cráter Oscuro[CR]!"})
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[5] = 0 -- $PERFORMANCE_PROGRESS_LIST[5] = 0 (ROM)
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(30)
  if (SkyProg.cmp(29, 88) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 88]
  -- @label_5 [étiquette de flux ExplorerScript]
  -- supervision_ExecuteCommon(CORO_EVENT_S22_08) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  SkyProg.set(29, 88) -- $SCENARIO_MAIN = scn[29,88] (ROM)
  -- supervision_ExecuteCommon(CORO_EVENT_S22_06) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_TEAM_SETUP_PARTNER_AND_HERO_ONLY"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_PARTN) [ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_PARTNER_AND_HERO_ONLY): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hold on a second, [hero].", french="Attends deux secondes,\n[hero].", german=" Eine Sekunde, [hero].", italian="Aspetta un momento,\n[hero].", spanish="Espera un momento,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hold on, [hero].", french="Attends deux secondes,\n[hero].", german=" Warte mal, [hero].", italian="Aspetta un momento,\n[hero].", spanish="Espera un momento,\n[hero]."})
  else
  SkySceneKit.say({english=" Hold on, [hero].", french="Attends deux secondes,\n[hero].", german=" Warte mal, [hero].", italian="Aspetta un momento,\n[hero].", spanish="Espera un momento,\n[hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's about the team leader...", french=" C'est à propos du meneur...", german="Es geht darum, wer das Team\nanführt...", italian="A proposito di chi deve fare da\nleader...", spanish=" En cuanto al líder del equipo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's about the team leader...", french=" C'est à propos du meneur...", german="Es geht darum, wer das Team\nanführt...", italian="A proposito di chi deve fare da\nleader...", spanish=" En cuanto al líder del equipo..."})
  else
  SkySceneKit.say({english=" It's about the team leader...", french=" C'est à propos du meneur...", german="Es geht darum, wer das Team\nanführt...", italian="A proposito di chi deve fare da\nleader...", spanish=" En cuanto a la líder del equipo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="When we go into the\n[CS:P]Dark Crater[CR], you should be the leader,\n[hero].", french="Quand on entrera dans le\n[CS:P]Cratère Obscur[CR], c'est toi qui devrais être\nle meneur, [hero].", german="Wenn wir in den [CS:P]Dunkelkrater[CR]\ngehen, solltest du der Anführer sein,\n[hero].", italian="Quando partiamo per il\n[CS:P]Cratere Oscuro[CR], dovresti fare tu da leader,\n[hero].", spanish="Cuando nos adentremos en el\n[CS:P]Cráter Oscuro[CR], tú deberías ir de líder,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="When we go into the\n[CS:P]Dark Crater[CR], you should be the leader,\n[hero].", french="Quand on entrera dans le\n[CS:P]Cratère Obscur[CR], c'est toi qui devrais être\nle meneur, [hero].", german="Wenn wir in den [CS:P]Dunkelkrater[CR]\ngehen, solltest du der Anführer sein,\n[hero].", italian="Quando partiamo per il\n[CS:P]Cratere Oscuro[CR], dovresti fare tu da leader,\n[hero].", spanish="Cuando nos adentremos en el\n[CS:P]Cráter Oscuro[CR], tú deberías ir de líder,\n[hero]."})
  else
  SkySceneKit.say({english="When we go into the\n[CS:P]Dark Crater[CR], you should be the leader,\n[hero].", french="Quand on entrera dans le\n[CS:P]Cratère Obscur[CR], c'est toi qui devrais être\nle meneur, [hero].", german="Wenn wir in den [CS:P]Dunkelkrater[CR]\ngehen, solltest du der Anführer sein,\n[hero].", italian="Quando partiamo per il\n[CS:P]Cratere Oscuro[CR], dovresti fare tu da leader,\n[hero].", spanish="Cuando nos adentremos en el\n[CS:P]Cráter Oscuro[CR], tú deberías ir de líder,\n[hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="After all, that's the way we've\nalways done it for important missions.", french="Après tout, on a toujours fait\ncomme ça pour les missions importantes.", german="Immerhin haben wir es bei allen\nwichtigen Missionen so gemacht.", italian="In fondo, abbiamo sempre fatto\ncosì per le missioni importanti.", spanish="Al fin y al cabo, eso es lo que\nhemos hecho en todas nuestras misiones\nimportantes."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="After all, that's the way we've\nalways handled things on important missions.", french="Après tout, on a toujours fait\ncomme ça pour les missions importantes.", german="Immerhin sind wir bei allen\nwichtigen Missionen so vorgegangen.", italian="In fondo, abbiamo sempre fatto\ncosì per le missioni importanti.", spanish="Al fin y al cabo, eso es lo que\nhemos hecho en todas nuestras misiones\nimportantes."})
  else
  SkySceneKit.say({english="After all, we've always gone on\nour important missions that way.", french="Après tout, on a toujours fait\ncomme ça pour les missions importantes.", german="Immerhin haben wir uns bei allen\nwichtigen Missionen so aufgestellt.", italian="In fondo, abbiamo sempre fatto\ncosì per le missioni importanti.", spanish="Al fin y al cabo, eso es lo que\nhemos hecho en todas nuestras misiones\nimportantes."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So I think that you should be the\nleader, [hero]...[K] What do you think?", french="Donc je pense que ça devrait\nêtre toi le meneur, [hero]...[K]\nQu'est-ce que tu en penses?", german="Ich denke, du solltest die\nErkundung anführen, [hero]...[K]\nWas meinst du?", italian="Quindi, secondo me dovresti\nguidare tu la squadra, [hero]...[K]\nCosa ne pensi?", spanish="Creo que tú deberías liderar el\ngrupo, [hero]...[K] ¿Qué te parece?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So I think that you should be the\nleader, [hero]...[K] What do you think?", french="Donc je pense que ça devrait\nêtre toi le meneur, [hero]...[K]\nQu'est-ce que tu en penses?", german="Ich denke, du solltest die\nErkundung anführen, [hero]...[K]\nWas meinst du?", italian="Quindi, secondo me dovresti\nguidare tu la squadra, [hero]...[K]\nCosa ne pensi?", spanish="Creo que tú deberías liderar el\ngrupo, [hero]...[K] ¿Qué te parece?"})
  else
  SkySceneKit.say({english="So I think that you should be the\nleader, [hero]...[K] What do you think?", french="Donc je pense que ça devrait\nêtre toi le meneur, [hero]...[K]\nQu'est-ce que tu en penses?", german="Ich denke, du solltest die\nErkundung anführen, [hero]...[K]\nWas meinst du?", italian="Quindi, secondo me dovresti\nguidare tu la squadra, [hero]...[K]\nCosa ne pensi?", spanish="Creo que tú deberías liderar el\ngrupo, [hero]...[K] ¿Qué te parece?"})
  end
  do local __choice = SkySceneKit.ask({{english="Accept leadership", french="Accepter d'être le meneur", german="Führung übernehmen", italian="Accetta", spanish="Aceptar liderazgo"}, {english="Refuse", french="Refuser", german="Ablehnen", italian="Rifiuta", spanish="Rechazar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Whoa![K] Hang on, we're going with\nme as leader?", french="Ouah![K] Attends, on n'avait pas dit\nque ce serait toi le meneur?", german="Holla![K] Heißt das, wir gehen mit\nmir als Anführer?", italian="No![K] Aspetta! Faccio io\nda leader?", spanish=" ¿Qué?[K] Espera, ¿voy yo de líder?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What?[K] Wait, so I'm going as the\nleader?", french="Ouah![K] Attends, on n'avait pas dit\nque ce serait toi le meneur?", german="Was?[K] Warte mal, gehe ich\nalso jetzt als Anführer?", italian="No![K] Aspetta! Faccio io\nda leader?", spanish=" ¿Qué?[K] Espera, ¿voy yo de líder?"})
  else
  SkySceneKit.say({english="What?[K] So I'm going to go as\nthe leader?", french="Ouah![K] Attends, on n'avait pas dit\nque ce serait toi le meneur?", german="Was?[K] Also werde ich jetzt als\nAnführer gehen?", italian="No![K] Aspetta! Faccio io\nda leader?", spanish=" ¿Qué?[K] Espera, ¿voy yo de líder?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hmm...[K] I don't feel confident\nabout doing that...", french="Hum...[K] Je ne me sens pas trop\nà la hauteur...", german="Hmm...[K] Ich fühle mich nicht\nwohl dabei...", italian="Mmm...[K] Non me la sento\nproprio...", spanish="Hum...[K] Me parece que me falta\nseguridad para ser el líder..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hmm...[K] I don't have the\nconfidence to do that...", french="Hum...[K] Je ne me sens pas trop\nà la hauteur...", german="Hmm...[K] Dazu fehlt mir das\nSelbstvertrauen...", italian="Mmm...[K] Non me la sento\nproprio...", spanish="Hum...[K] Me parece que me falta\nseguridad para ser el líder..."})
  else
  SkySceneKit.say({english="Hmm...[K] I don't feel confident\nenough to be the leader...", french="Hum...[K] Je ne me sens pas trop\nà la hauteur...", german="Hmm...[K] Ich habe nicht genug\nSelbstvertrauen, um Anführer zu sein...", italian="Mmm...[K] Non me la sento\nproprio...", spanish="Hum...[K] Me parece que me falta\nseguridad para ser líder..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="When we go into the\n[CS:P]Dark Crater[CR], you should be the leader,\n[hero].", french="Quand on entrera dans le\n[CS:P]Cratère Obscur[CR], c'est toi qui devrais être\nle meneur, [hero].", german="Wenn wir in den [CS:P]Dunkelkrater[CR]\ngehen, solltest du der Anführer sein,\n[hero].", italian="Quando partiamo per il [CS:P]Cratere[CR]\n[CS:P]Oscuro[CR], dovresti fare tu da leader,\n[hero].", spanish="Cuando nos adentremos en el\n[CS:P]Cráter Oscuro[CR], tú deberías liderar el grupo,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="When we go into the\n[CS:P]Dark Crater[CR], you should be the leader,\n[hero].", french="Quand on entrera dans le\n[CS:P]Cratère Obscur[CR], c'est toi qui devrais être\nle meneur, [hero].", german="Wenn wir in den [CS:P]Dunkelkrater[CR]\ngehen, solltest du der Anführer sein,\n[hero].", italian="Quando partiamo per il [CS:P]Cratere[CR]\n[CS:P]Oscuro[CR], dovresti fare tu da leader,\n[hero].", spanish="Cuando nos adentremos en el\n[CS:P]Cráter Oscuro[CR], tú deberías liderar el grupo,\n[hero]."})
  else
  SkySceneKit.say({english="When we go into the\n[CS:P]Dark Crater[CR], you should be the leader,\n[hero].", french="Quand on entrera dans le\n[CS:P]Cratère Obscur[CR], c'est toi qui devrais être\nle meneur, [hero].", german="Wenn wir in den [CS:P]Dunkelkrater[CR]\ngehen, solltest du der Anführer sein,\n[hero].", italian="Quando partiamo per il [CS:P]Cratere[CR]\n[CS:P]Oscuro[CR], dovresti fare tu da leader,\n[hero].", spanish="Cuando nos adentremos en el\n[CS:P]Cráter Oscuro[CR], tú deberías liderar el grupo,\n[hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kureseria, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kureseria, 4) end)
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Cool![K] That's it, then! You're the\nleader, [hero]!", french="Super![K] Alors, ça marche!\nTu es le meneur, [hero]!", german="Cool![K] Das wäre geregelt! Du bist\nder Anführer, [hero]!", italian="Benissimo![K] Allora è deciso!\nFarai da leader, [hero]!", spanish="¡Guay![K] ¡Decidido! ¡Ahora estás\nal mando, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="OK![K] That's settled, then! You're\nthe leader, [hero]!", french="Super![K] Alors, ça marche!\nTu es le meneur, [hero]!", german="Okay![K] Das wäre geklärt! Du bist\nder Anführer, [hero]!", italian="Benissimo![K] Allora è deciso!\nFarai da leader, [hero]!", spanish="¡Guay![K] ¡Decidido! ¡Ahora estás\nal mando, [hero]!"})
  else
  SkySceneKit.say({english="OK![K] You're the team leader,\n[hero]!", french="Super![K] Alors, ça marche!\nTu es le meneur, [hero]!", german="Okay![K] Du führst das Team an,\n[hero]!", italian="Benissimo![K] Allora è deciso!\nFarai da leader, [hero]!", spanish="¡Guay![K] ¡Decidido! ¡Ahora estás\nal mando, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kureseria, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Cresselia[CR]!", french=" [CS:N]Cresselia[CR]!", german=" [CS:N]Cresselia[CR]!", italian=" [CS:N]Cresselia[CR]!", spanish=" ¡[CS:N]Cresselia[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Cresselia[CR]!", french=" [CS:N]Cresselia[CR]!", german=" [CS:N]Cresselia[CR]!", italian=" [CS:N]Cresselia[CR]!", spanish=" ¡[CS:N]Cresselia[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]Cresselia[CR]!", french=" [CS:N]Cresselia[CR]!", german=" [CS:N]Cresselia[CR]!", italian=" [CS:N]Cresselia[CR]!", spanish=" ¡[CS:N]Cresselia[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kureseria, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go! Off to the [CS:P]Dark Crater[CR]!", french="C'est parti! En route pour\nle [CS:P]Cratère Obscur[CR]!", german="Gehen wir! Auf zum\n[CS:P]Dunkelkrater[CR]!", italian=" Andiamo! Al [CS:P]Cratere Oscuro[CR]!", spanish=" ¡Nos vamos! ¡Al [CS:P]Cráter Oscuro[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go! Off to the [CS:P]Dark Crater[CR]!", french="C'est parti! En route pour\nle [CS:P]Cratère Obscur[CR]!", german="Gehen wir! Auf zum\n[CS:P]Dunkelkrater[CR]!", italian=" Andiamo! Al [CS:P]Cratere Oscuro[CR]!", spanish=" ¡Nos vamos! ¡Al [CS:P]Cráter Oscuro[CR]!"})
  else
  SkySceneKit.say({english=" Let's go! Off to the [CS:P]Dark Crater[CR]!", french="C'est parti! En route pour\nle [CS:P]Cratère Obscur[CR]!", german="Gehen wir! Auf zum\n[CS:P]Dunkelkrater[CR]!", italian=" Andiamo! Al [CS:P]Cratere Oscuro[CR]!", spanish=" ¡Nos vamos! ¡Al [CS:P]Cráter Oscuro[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  -- @label_4 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="I'm afraid that [CS:N]Darkrai[CR] will be\nscared off if too many of us were to go.", french="Mais je crains que [CS:N]Darkrai[CR]\nne prenne la fuite si nous sommes trop\nnombreux à y aller.", german="Allerdings fürchte ich, dass\n[CS:N]Darkrai[CR] verschreckt würde,\nwenn zu viele von uns gingen.", italian="Temo che [CS:N]Darkrai[CR]\nscapperebbe se andassimo in troppi.", spanish="Me temo que [CS:N]Darkrai[CR] se\nasustaría y huiría si fuéramos demasiados."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="That said, it would be dangerous\nto go alone.", french="Cela dit, ce serait dangereux\nd'y aller seul.", german="Nichtsdestotrotz wäre es\ngefährlich, allein zu gehen.", italian="Tuttavia, se andaste in due,\npotreste non farcela.", spanish="Aunque también es peligroso ir\nsin acompañantes."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="So to surely corner [CS:N]Darkrai[CR] and\nput a stop to his scheming once and for all...", french="Donc, pour être sûr de coincer\n[CS:N]Darkrai[CR] et de mettre un terme à\nses manigances pour de bon...", german="Um also [CS:N]Darkrai[CR] in die Enge zu\ntreiben und seinen Intrigen endgültig ein Ende\nzu setzen...", italian="Quindi, per essere sicuri di\nbattere [CS:N]Darkrai[CR] e mettere fine al suo piano\nuna volta per tutte...", spanish="Así que para arrinconar a\n[CS:N]Darkrai[CR] y poner freno a su maquiavélico\nplan de una vez por todas..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="May I suggest that we go as a\ntrio and take no one else?", french="... je suggère que nous y allions\nà trois seulement.", german="Darf ich vorschlagen, zu dritt\nund ohne weitere Pokémon zu gehen?", italian="... suggerisco di andare in tre,\nsenza far venire nessun altro.", spanish=" Sugiero que solo vayamos tres."})
  do local __choice = SkySceneKit.ask({{english="Go as a trio", french="Partir à trois", german="Als Trio gehen", italian="Accetta", spanish="Ir solo tres"}, {english="Don't go to the [CS:P]Dark Crater[CR]", french="Ne pas aller au [CS:P]Cratère Obscur[CR]", german="Nicht zum [CS:P]Dunkelkrater[CR] gehen", italian="Non andare al [CS:P]Cratere Oscuro[CR]", spanish="No ir al [CS:P]Cráter Oscuro[CR]"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- @label_1 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Very well.", french=" Très bien.", german=" Okay.", italian=" Molto bene.", spanish=" Muy bien."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Please tell me when you are\nready to leave.", french=" On part quand vous voulez.", german="Sagt mir bitte Bescheid, wenn\nihr reisefertig seid.", italian="Ditemi quando possiamo\npartire.", spanish="Avisadme cuando tengáis todo\nlisto para partir."})
  -- message_Close
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
