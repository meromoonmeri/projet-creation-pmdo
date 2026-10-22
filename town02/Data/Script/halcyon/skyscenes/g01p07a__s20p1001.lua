-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07A/s20p1001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  local npc_npc_suriipu = SkySceneKit.spawn_npc("drowzee", 208, 208, Direction.Up, "NPC_SURIIPU")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_suriipu, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_suriipu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_suriipu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Will you go into [CS:N]Azurill[CR]'s dream?", french="Voulez-vous aller dans le rêve\nd'[CS:N]Azurill[CR]?", german="Wollt ihr in den Traum von\n[CS:N]Azurill[CR] hineingehen?", italian="Volete entrare nel sogno\ndi [CS:N]Azurill[CR]?", spanish=" ¿Entrar en el sueño de [CS:N]Azurill[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_TEAM_SETUP_HERO_AND_PARTNER_ONLY"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_HERO_) [ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_HERO_AND_PARTNER_ONLY): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  -- @label_2 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Good.", french=" Bien.", german=" Gut.", italian=" Bene.", spanish=" Bien."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Then come over here.", french=" Alors venez par ici.", german=" Dann kommt hier herüber.", italian=" Allora venite qui.", spanish=" Venid aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:FadeOut(false, 60)
  local npc_npc_mariru = SkySceneKit.spawn_npc("marill", 208, 168, Direction.Down, "NPC_MARIRU")
  GROUND:EntTurn(npc_npc_mariru, Direction.Right)
  GROUND:EntTurn(npc_npc_suriipu, Direction.DownRight)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:TeleportTo(npc_npc_mariru, 156, 184, Direction.Down)
  GROUND:TeleportTo(hero, 204, 164, Direction.Down)
  GROUND:TeleportTo(partner, 184, 184, Direction.Down)
  GROUND:TeleportTo(npc_npc_suriipu, 184, 164, Direction.Down)
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(45)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(1, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="I'm going to send you into\n[CS:N]Azurill[CR]'s dream.", french="Je vais vous envoyer dans\nle rêve d'[CS:N]Azurill[CR].", german="Ich schicke euch jetzt in den\nTraum von [CS:N]Azurill[CR].", italian="Vi farò entrare nel sogno\ndi [CS:N]Azurill[CR].", spanish="Os voy a mandar al sueño de\n[CS:N]Azurill[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Here goes!", french=" C'est parti!", german=" Und los geht's!", italian=" Ecco!", spanish=" ¡Allá va!"})
  -- message_Close
  -- GAP: se_Play(8195) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_G01P07A1_108) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(2) -- join WaitSe
  SkySceneKit.play_scene("d37p11a__s20p100200", "d37p11a__s20p1002", hero, partner) -- supervision_ExecuteActing(LEVEL_D37P11A, 'S20P1002', 0) [chaînage scène ROM]
  elseif true then -- default
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_TEAM_SETUP_PARTNER_AND_HERO_ONLY"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_PARTN) [ProcessSpecial(PROCESS_SPECIAL_IS_TEAM_SETUP_PARTNER_AND_HERO_ONLY): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hold on a second, [hero].", french=" Attends, [hero].", german=" Eine Sekunde, [hero].", italian="Aspetta un momento,\n[hero].", spanish="Espera un momento,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hold on, [hero].", french=" Attends, [hero].", german=" Warte mal, [hero].", italian="Aspetta un momento,\n[hero].", spanish="Espera un momento,\n[hero]."})
  else
  SkySceneKit.say({english=" Hold on, [hero].", french=" Attends, [hero].", german=" Warte mal, [hero].", italian="Aspetta un momento,\n[hero].", spanish="Espera un momento,\n[hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="When we go into the [CS:P]nightmare[CR],\nyou should be the leader, [hero].", french="Quand nous serons dans le\n[CS:P]Cauchemar[CR], c'est toi qui devrais être\nle meneur, [hero].", german="Wenn wir in den [CS:P]Albtraum[CR]\nhineingehen, solltest du der Anführer sein,\n[hero].", italian="[hero], dovresti fare tu\nda leader quando entreremo nell'[CS:P]Incubo[CR].", spanish="Cuando entremos en la [CS:P]pesadilla[CR],\ntú deberías ir de líder, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="When we go into the [CS:P]nightmare[CR],\nyou should be the leader, [hero].", french="Quand nous serons dans le\n[CS:P]Cauchemar[CR], c'est toi qui devrais être\nle meneur, [hero].", german="Wenn wir in den [CS:P]Albtraum[CR]\nhineingehen, solltest du der Anführer sein,\n[hero].", italian="[hero], dovresti fare tu\nda leader quando entreremo nell'[CS:P]Incubo[CR].", spanish="Cuando entremos en la [CS:P]pesadilla[CR],\ntú deberías ir de líder, [hero]."})
  else
  SkySceneKit.say({english="When we go into the [CS:P]nightmare[CR],\nyou should go as the leader, [hero].", french="Quand nous serons dans le\n[CS:P]Cauchemar[CR], c'est toi qui devrais être\nle meneur, [hero].", german="Wenn wir in den [CS:P]Albtraum[CR]\nhineingehen, solltest du als Anführer gehen,\n[hero].", italian="[hero], dovresti fare tu\nda leader quando entreremo nell'[CS:P]Incubo[CR].", spanish="Cuando entremos en la [CS:P]pesadilla[CR],\ntú deberías ir de líder, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="After all, that's the way we've\nalways done it for important missions.", french="Après tout, c'est comme ça que\nnous avons toujours fait pour les missions\nimportantes.", german="Immerhin haben wir es bei allen\nwichtigen Missionen so gemacht.", italian="In fondo, abbiamo sempre fatto\ncosì per le missioni importanti.", spanish="Al fin y al cabo, así vamos\nsiempre en las misiones importantes."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="After all, that's the way we've\nalways handled things on important missions.", french="Après tout, c'est comme ça que\nnous avons toujours fait pour les missions\nimportantes.", german="Immerhin sind wir bei allen\nwichtigen Missionen so vorgegangen.", italian="In fondo, abbiamo sempre fatto\ncosì per le missioni importanti.", spanish="Al fin y al cabo, así vamos\nsiempre en las misiones importantes."})
  else
  SkySceneKit.say({english="After all, we've always gone on\nour important missions that way.", french="Après tout, c'est comme ça que\nnous avons toujours fait pour les missions\nimportantes.", german="Immerhin haben wir uns bei allen\nwichtigen Missionen so aufgestellt.", italian="In fondo, abbiamo sempre fatto\ncosì per le missioni importanti.", spanish="Al fin y al cabo, así vamos\nsiempre en las misiones importantes."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So I think that you should be the\nleader, [hero]...[K] What do you think?", french="Donc je pense que tu dois être\nle meneur, [hero]...[K] Qu'est-ce que\ntu en dis?", german="Ich denke, du solltest die\nErkundung anführen, [hero]...[K]\nWas meinst du?", italian="Quindi, secondo me dovresti\nguidare tu la squadra, [hero]...[K]\nCosa ne pensi?", spanish="Creo que tú deberías liderar el\ngrupo, [hero]...[K] ¿Qué te parece?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So I think that you should be the\nleader, [hero]...[K] What do you think?", french="Donc je pense que tu dois être\nle meneur, [hero]...[K] Qu'est-ce que\ntu en dis?", german="Ich denke, du solltest die\nErkundung anführen, [hero]...[K]\nWas meinst du?", italian="Quindi, secondo me dovresti\nguidare tu la squadra, [hero]...[K]\nCosa ne pensi?", spanish="Creo que tú deberías liderar el\ngrupo, [hero]...[K] ¿Qué te parece?"})
  else
  SkySceneKit.say({english="So I think that you should be the\nleader, [hero]...[K] What do you think?", french="Donc je pense que tu dois être\nle meneur, [hero]...[K] Qu'est-ce que\ntu en dis?", german="Ich denke, du solltest die\nErkundung anführen, [hero]...[K]\nWas meinst du?", italian="Quindi, secondo me dovresti\nguidare tu la squadra, [hero]...[K]\nCosa ne pensi?", spanish="Creo que tú deberías liderar el\ngrupo, [hero]...[K] ¿Qué te parece?"})
  end
  do local __choice = SkySceneKit.ask({{english="Accept leadership", french="Accepter d'être le meneur", german="Führung übernehmen", italian="Accetta", spanish="Aceptar liderazgo"}, {english="Refuse", french="Refuser", german="Ablehnen", italian="Rifiuta", spanish="Rechazar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Whoa![K] Hang on, we're going with\nme as leader?", french="Oh![K] Attends, tu veux que ce soit\nmoi le meneur, alors?", german="Holla![K] Warte mal, wir gehen mit\nmir als Anführer?", italian="No![K] Aspetta! Faccio io\nda leader?", spanish=" ¿Qué?[K] Espera, ¿voy yo de líder?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What?[K] Wait, so I'm going as\nthe leader?", french="Oh![K] Attends, tu veux que ce soit\nmoi le meneur, alors?", german="Was?[K] Warte, also ich werde der\nAnführer sein?", italian="No![K] Aspetta! Faccio io\nda leader?", spanish=" ¿Qué?[K] Espera, ¿voy yo de líder?"})
  else
  SkySceneKit.say({english="What?[K] So I'm going to go as\nthe leader?", french="Oh![K] Attends, tu veux que ce soit\nmoi le meneur, alors?", german="Was?[K] Dann werde ich als\nAnführer des Teams gehen?", italian="No![K] Aspetta! Faccio io\nda leader?", spanish=" ¿Qué?[K] Espera, ¿voy yo de líder?"})
  end
  -- message_Close
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hmm...[K] I don't feel confident\nabout doing that...", french="Hum...[K] Je ne me sens pas\nvraiment capable d'assumer ce rôle-là...", german="Hmm...[K] Ich fühle mich nicht\nganz wohl in dieser Rolle...", italian="Mmm...[K] Non me la sento\nproprio...", spanish="Hum...[K] No tengo tanta seguridad\ncomo para ir de líder..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hmm...[K] I don't have the\nconfidence to do that...", french="Hum...[K] Je ne me sens pas\nvraiment capable d'assumer ce rôle-là...", german="Hmm...[K] Dazu fehlt mir das\nSelbstvertrauen...", italian="Mmm...[K] Non me la sento\nproprio...", spanish="Hum...[K] No me siento tan seguro\ncomo para ir de líder..."})
  else
  SkySceneKit.say({english="Hmm...[K] I don't feel confident\nenough to be the leader...", french="Hum...[K] Je ne me sens pas\nvraiment capable d'assumer ce rôle-là...", german="Hmm...[K] Ich fühle mich nicht\nselbstbewusst genug, um Anführer zu sein...", italian="Mmm...[K] Non me la sento\nproprio...", spanish="Hum...[K] No me siento tan segura\ncomo para ir de líder..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If we're going into the\n[CS:P]nightmare[CR], you should be the leader,\n[hero]...", french="Si nous allons dans le\n[CS:P]Cauchemar[CR], c'est toi qui devrais être\nle meneur, [hero]...", german="Wenn wir in den [CS:P]Albtraum[CR]\nhineingehen, solltest du der Anführer sein,\n[hero].", italian="Se entriamo nell'[CS:P]Incubo[CR],\ndovresti fare tu da leader, [hero]...", spanish="Si vamos a adentrarnos en la\n[CS:P]pesadilla[CR], creo que tú deberías liderar el\ngrupo, [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If we're going into the\n[CS:P]nightmare[CR], you should be the leader,\n[hero]...", french="Si nous allons dans le\n[CS:P]Cauchemar[CR], c'est toi qui devrais être\nle meneur, [hero]...", german="Wenn wir in den [CS:P]Albtraum[CR]\nhineingehen, solltest du der Anführer sein,\n[hero].", italian="Se entriamo nell'[CS:P]Incubo[CR],\ndovresti fare tu da leader, [hero]...", spanish="Si vamos a adentrarnos en la\n[CS:P]pesadilla[CR], creo que tú deberías liderar el\ngrupo, [hero]..."})
  else
  SkySceneKit.say({english="If we're going to go into the\n[CS:P]nightmare[CR], I think you should be the leader,\n[hero]...", french="Si nous allons dans le\n[CS:P]Cauchemar[CR], c'est toi qui devrais être\nle meneur, [hero]...", german="Wenn wir in den [CS:P]Albtraum[CR]\nhineingehen, solltest du meiner Meinung nach\nder Anführer sein, [hero].", italian="Se entriamo nell'[CS:P]Incubo[CR],\ndovresti fare tu da leader, [hero]...", spanish="Si vamos a adentrarnos en la\n[CS:P]pesadilla[CR], creo que tú deberías liderar el\ngrupo, [hero]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_suriipu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_suriipu, 4) end)
  -- @label_1 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="I'm all ready to send you into\nthe dream.", french="Je suis prêt à vous envoyer\ndans le rêve.", german="Ich bin jetzt bereit, euch in\nden Traum zu schicken.", italian="Sono pronto a farvi entrare\nnel sogno.", spanish="Estoy listo para enviaros al\nsueño."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Tell me when you're ready.", french=" Quand vous voudrez.", german=" Sagt mir, wann ihr bereit seid.", italian="Avvertitemi quando avete\nultimato i preparativi.", spanish=" Avisadme y empezaremos."})
  -- message_Close
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Cool![K] That's it, then! You're the\nleader, [hero]!", french="Cool![K] C'est décidé, alors! Tu es\nle meneur, [hero]!", german="Cool![K] Abgemacht! Du bist der\nAnführer, [hero]!", italian="Benissimo![K] Allora è deciso!\nFarai da leader, [hero]!", spanish="¡Guay![K] ¡Decidido! ¡Ahora estás\nal mando, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="OK![K] That's settled, then! You're\nthe leader, [hero]!", french="Cool![K] C'est décidé, alors! Tu es\nle meneur, [hero]!", german="Okay![K] Das wäre geregelt! Du\nbist der Anführer, [hero]!", italian="Benissimo![K] Allora è deciso!\nFarai da leader, [hero]!", spanish="¡Guay![K] ¡Decidido! ¡Ahora estás\nal mando, [hero]!"})
  else
  SkySceneKit.say({english="OK![K] You're the team leader,\n[hero]!", french="Cool![K] C'est décidé, alors! Tu es\nle meneur, [hero]!", german="Okay![K] Du führst das Team an,\n[hero]!", italian="Benissimo![K] Allora è deciso!\nFarai da leader, [hero]!", spanish="¡Guay![K] ¡Decidido! ¡Ahora estás\nal mando, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go! Into the [CS:P]nightmare[CR]!", french="Allons-y! Direction le\n[CS:P]Cauchemar[CR]!", german=" Gehen wir! In den [CS:P]Albtraum[CR]!", italian="Forza! Entriamo\nnell'[CS:P]Incubo[CR]!", spanish="¡Vamos! ¡Adentrémonos en la\n[CS:P]pesadilla[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go! Into the [CS:P]nightmare[CR]!", french="Allons-y! Direction le\n[CS:P]Cauchemar[CR]!", german=" Gehen wir! In den [CS:P]Albtraum[CR]!", italian="Forza! Entriamo\nnell'[CS:P]Incubo[CR]!", spanish="¡Vamos! ¡Adentrémonos en la\n[CS:P]pesadilla[CR]!"})
  else
  SkySceneKit.say({english=" Let's go! Into the [CS:P]nightmare[CR]!", french="Allons-y! Direction le\n[CS:P]Cauchemar[CR]!", german=" Gehen wir! In den [CS:P]Albtraum[CR]!", italian="Forza! Entriamo\nnell'[CS:P]Incubo[CR]!", spanish="¡Vamos! ¡Adentrémonos en la\n[CS:P]pesadilla[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_suriipu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_suriipu, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="All right, [CS:N]Drowzee[CR]![K]\nDo your thing!", french="Très bien, [CS:N]Soporifik[CR]![K]\nA toi de jouer!", german="Alles klar, [CS:N]Traumato[CR]![K]\nTu, was du tun musst!", italian="Forza, [CS:N]Drowzee[CR]![K]\nFai ciò che devi fare!", spanish="De acuerdo, ¡[CS:N]Drowzee[CR]![K]\n¡Contamos contigo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK, [CS:N]Drowzee[CR]![K] It's your show!", french="Très bien, [CS:N]Soporifik[CR]![K]\nA toi de jouer!", german=" Okay, [CS:N]Traumato[CR]![K] Dein Auftritt!", italian="Forza, [CS:N]Drowzee[CR]![K]\nFai ciò che devi fare!", spanish="De acuerdo, ¡[CS:N]Drowzee[CR]![K]\n¡Contamos contigo!"})
  else
  SkySceneKit.say({english="All right, [CS:N]Drowzee[CR]![K]\nWe're counting on you!", french="Très bien, [CS:N]Soporifik[CR]![K]\nA toi de jouer!", german="Alles klar, [CS:N]Traumato[CR]![K]\nWir zählen auf dich!", italian="Forza, [CS:N]Drowzee[CR]![K]\nContiamo su di te!", spanish="De acuerdo, ¡[CS:N]Drowzee[CR]![K]\n¡Contamos contigo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  -- @label_4 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" By the way...", french=" Au fait...", german=" Ach, übrigens...", italian=" Come dicevo prima...", spanish=" Por cierto..."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="[CS:N]Azurill[CR] is in a very delicate\nstate now.", french="[CS:N]Azurill[CR] est dans un état\ncritique.", german="[CS:N]Azurill[CR] ist jetzt in einem sehr\nkritischen Zustand.", italian="Le condizioni di [CS:N]Azurill[CR] sono\nmolto delicate.", spanish=" [CS:N]Azurill[CR] está muy delicado ahora."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="Judging by the resonations from\n[CS:N]Azurill[CR]'s dream...", french="A en juger d'après les échos\ndu rêve d'[CS:N]Azurill[CR]...", german="Den Resonanzen des Traumes von\n[CS:N]Azurill[CR] nach zu urteilen...", italian="A giudicare dalle onde che\nprovengono dal sogno di [CS:N]Azurill[CR]...", spanish="A juzgar por las resonancias del\nsueño de [CS:N]Azurill[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="I believe that only the two of\nyou should enter the [CS:P]nightmare[CR].[K] What do you\nthink of that plan?", french="... seuls deux Pokémon devraient\nentrer dans le [CS:P]Cauchemar[CR]: [hero]\net [partner].[K] Qu'en pensez-vous?", german="Nun, meiner Meinung nach solltet\nnur ihr beide den [CS:P]Albtraum[CR] betreten.[K] Was\nhaltet ihr von diesem Plan?", italian="... credo che solo voi due\ndovreste entrare nell'[CS:P]Incubo[CR].[K] Cosa ne pensate?", spanish="Creo que solo [hero] y\n[partner] deberían entrar en la [CS:P]pesadilla[CR].[K]\n¿Qué os parece?"})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="Will just the two of you go into\nthe [CS:P]nightmare[CR]?", french="Vous êtes d'accord pour n'entrer\nqu'à deux dans ce [CS:P]Cauchemar[CR]?", german="Geht nur ihr zwei in den\n[CS:P]Albtraum[CR] hinein?", italian="Entrerete solo in due\nnell'[CS:P]Incubo[CR]?", spanish=" ¿Os sentís capaces?"})
  do local __choice = SkySceneKit.ask({{english="Go as a duo", french="Partir à deux", german="Als Duo gehen", italian="Entrate in due", spanish="Ir en pareja"}, {english="Don't enter the [CS:P]nightmare[CR]", french="Ne pas entrer dans le [CS:P]Cauchemar[CR]", german="Den [CS:P]Albtraum[CR] nicht betreten", italian="Non entrare nell'[CS:P]Incubo[CR]", spanish="No entrar en la [CS:P]pesadilla[CR]"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
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
