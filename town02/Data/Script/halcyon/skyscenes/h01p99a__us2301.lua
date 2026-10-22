-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99A/us2301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- screen2_FadeOut [sub déjà caché]
  if ((SV.SkyTalkBitFlags or {})[41] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[41]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- screen2_FadeOut [sub déjà caché]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 184, 144, Direction.DownLeft, "NPC_KURESERIA")
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kureseria, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kureseria, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="I would love to join your Team\n[team:]...", french="J'adorerais intégrer votre\nEquipe [team:]...", german="Ich würde mich gerne eurem\nTeam [team:] anschließen.", italian="Sarebbe fantastico far parte del\nTeam [team:]...", spanish="Me encantaría unirme\nal [CS:X]Equipo[CR] [team:]..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Will you have me?", french=" M'acceptez-vous?", german=" Nehmt ihr mich?", italian=" Mi volete con voi?", spanish=" ¿Me aceptáis?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_PREPARE_MENU_ACCEPT_TEAM_MEMBER, 18, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_ACCEPT_TEAM_MEMBER"] or 0) -- switch(message_Menu(MENU_ACCEPT_TEAM_MEMBER)) [message_Menu(MENU_ACCEPT_TEAM_MEMBER): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 2 then
  -- message_Close
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" ...I see. That's disappointing.", french=" ... Je vois. Quelle déception!", german="...Verstehe. Das ist\nenttäuschend.", italian=" Capisco. Che delusione!", spanish=" Ya veo. Qué decepción."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="If you have a change of heart,\nand you would let me join your team...", french="Si d'aventure vous changiez\nd'avis et décidiez de m'accepter dans votre\néquipe...", german="Falls du es dir anders überlegen\nsolltest und mich in dein Team aufnehmen\nmöchtest...", italian="Se doveste cambiare idea e\nmi voleste nella vostra squadra...", spanish="Si cambiáis de opinión y queréis\nque me una al equipo..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Please tell me.", french=" ... faites-le-moi savoir.", german=" Lass es mich bitte wissen.", italian=" Ditemelo per favore.", spanish=" Hacédmelo saber."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Thank you so much!", french=" Merci de tout cœur!", german=" Vielen Dank!", italian=" Grazie infinite!", spanish=" ¡Muchísimas gracias!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kureseria, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Oh, for sure, [c_name:NPC_NEW_FRIEND]!\nThank you for joining us!", french="Oh, bien sûr, [c_name:NPC_NEW_FRIEND]!\nMerci de te joindre à nous!", german="Aber sicher doch, [c_name:NPC_NEW_FRIEND]!\nDanke, dass du dich uns anschließt!", italian="Oh, davvero, [c_name:NPC_NEW_FRIEND]!\nWow, è fantastico che tu ti sia unita a noi!", spanish="Oh, ¡de nada, [c_name:NPC_NEW_FRIEND]!\n¡Gracias por unirte al equipo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh, you bet, [c_name:NPC_NEW_FRIEND]!\nThank you for joining us!", french="Oh, bien sûr, [c_name:NPC_NEW_FRIEND]!\nMerci de te joindre à nous!", german="Schon in Ordnung, [c_name:NPC_NEW_FRIEND]!\nDanke, dass du dich uns anschließt!", italian="Oh, davvero, [c_name:NPC_NEW_FRIEND]!\nChe bello che tu ti sia unita a noi!", spanish="Oh, ¡de nada, [c_name:NPC_NEW_FRIEND]!\n¡Gracias por unirte al equipo!"})
  else
  SkySceneKit.say({english="Oh, for sure, [c_name:NPC_NEW_FRIEND]!\nThank you for joining us!", french="Oh, bien sûr, [c_name:NPC_NEW_FRIEND]!\nMerci de te joindre à nous!", german="Aber sicher doch, [c_name:NPC_NEW_FRIEND]!\nDanke, dass du dich uns anschließt!", italian="Oh, davvero, [c_name:NPC_NEW_FRIEND]!\nChe gioia che tu ti sia unita a noi!", spanish="Oh, ¡de nada, [c_name:NPC_NEW_FRIEND]!\n¡Gracias por unirte al equipo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayFanfare("Fanfare/JoinTeam") end) -- me_Play(5) [jingle ME NDS -> fanfare PMDO]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][c_name:NPC_NEW_FRIEND] joined the team!", french="[CN][c_name:NPC_NEW_FRIEND] a rejoint l'équipe!", german="[CN][c_name:NPC_NEW_FRIEND] gehört nun zum Team.", italian="[CN][c_name:NPC_NEW_FRIEND] entra a far parte della squadra!", spanish="[CN]¡[c_name:NPC_NEW_FRIEND] se unió al equipo!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  GAME:FadeOut(false, 30)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(60)
  GAME:FadeIn(30)
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[41] = 1 -- $SCENARIO_TALK_BIT_FLAG[41] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kureseria, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kureseria, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Thanks to you, [hero] and\n[partner], that [CS:N]Darkrai[CR] was stopped from\ncarrying out his wicked scheme.", french="Grâce à vous, [hero] et\n[partner], les projets machiavéliques du vil\n[CS:N]Darkrai[CR] sont anéantis.", german="Dank euch, [hero] und\n[partner], wurde [CS:N]Darkrai[CR] davon abgehalten,\nseinen fiesen Plan umzusetzen.", italian="Grazie a voi, [hero] e\n[partner], [CS:N]Darkrai[CR] non è riuscito a\nrealizzare il suo malvagio piano.", spanish="[CS:N]Darkrai[CR] no ha podido llevar a\ncabo su malvado plan gracias a vuestra\nlabor, [hero] y [partner]."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" My job here is done.", french=" Ma mission ici est achevée.", german=" Meine Arbeit hier ist erledigt.", italian=" Il mio lavoro qui è finito.", spanish=" Ya he cumplido mi misión."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Sincerely... Thank you.", french=" De tout cœur... merci.", german=" Meinen aufrichtigen Dank.", italian="Grazie...\nGrazie di tutto cuore!", spanish=" Muchas gracias... de corazón."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Cresselia[CR], what about you?[K]\nWhat are you going to do now?", french="Et toi, [CS:N]Cresselia[CR]?[K]\nQu'est-ce que tu comptes faire maintenant?", german="[CS:N]Cresselia[CR], was wird aus dir?[K]\nWas wirst du jetzt tun?", italian="[CS:N]Cresselia[CR], e tu?[K] Cosa farai\nadesso?", spanish="[CS:N]Cresselia[CR]...[K] ¿Qué vas a\nhacer ahora?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Cresselia[CR], what about you?[K]\nWhat are your plans now?", french="Et toi, [CS:N]Cresselia[CR]?[K]\nQu'est-ce que tu comptes faire maintenant?", german="[CS:N]Cresselia[CR], was wird aus dir?[K]\nWas hast du jetzt vor?", italian="[CS:N]Cresselia[CR], e tu?[K]\nCosa pensi di fare adesso?", spanish="[CS:N]Cresselia[CR]...[K] ¿Qué vas a\nhacer ahora?"})
  else
  SkySceneKit.say({english="[CS:N]Cresselia[CR], what about you?[K]\nWhat are you going to do now?", french="Et toi, [CS:N]Cresselia[CR]?[K]\nQu'est-ce que tu comptes faire maintenant?", german="[CS:N]Cresselia[CR], was wird aus dir?[K]\nWas wirst du jetzt tun?", italian="[CS:N]Cresselia[CR], e tu?[K] Cosa farai\nadesso?", spanish="[CS:N]Cresselia[CR]...[K] ¿Qué vas a\nhacer ahora?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kureseria, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" I've pondered many possibilities.", french="J'ai envisagé bien des\npossibilités.", german="Ich habe viele Möglichkeiten in\nErwägung gezogen.", italian=" Ho vagliato più possibilità.", spanish=" He considerado varias opciones."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kureseria, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" May I...[K]join Team [team:]?", french="Puis-je... [K]me joindre à l'Equipe\n[team:]?", german="Darf ich...[K] Team [team:]\nbeitreten?", italian="Potrei...[K] unirmi al Team\n[team:]?", spanish="Tal vez podría...[K] ¿Os parecería\nbien que me uniera al [CS:X]Equipo[CR] [team:]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Huh?[K] [CS:N]Cresselia[CR]? In our\nexploration team?", french="Hein?[K] [CS:N]Cresselia[CR]? Dans notre\néquipe d'exploration?", german="Wie?[K] [CS:N]Cresselia[CR]? In unserem\nErkundungsteam?", italian="Eh?[K] [CS:N]Cresselia[CR]? Nella nostra\nsquadra d'esplorazione?", spanish="¿Qué?[K] ¿Tener a [CS:N]Cresselia[CR] en\nnuestro equipo explorador?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What?[K] [CS:N]Cresselia[CR]? In our\nexploration team?", french="Hein?[K] [CS:N]Cresselia[CR]? Dans notre\néquipe d'exploration?", german="Wie?[K] [CS:N]Cresselia[CR]? In unserem\nErkundungsteam?", italian="Eh?[K] [CS:N]Cresselia[CR]? Nella nostra\nsquadra d'esplorazione?", spanish="¿Qué?[K] ¿Tener a [CS:N]Cresselia[CR] en\nnuestro equipo explorador?"})
  else
  SkySceneKit.say({english="Pardon?[K] [CS:N]Cresselia[CR]? In our\nexploration team?", french="Hein?[K] [CS:N]Cresselia[CR]? Dans notre\néquipe d'exploration?", german="Wie?[K] [CS:N]Cresselia[CR]? In unserem\nErkundungsteam?", italian="Eh?[K] [CS:N]Cresselia[CR]? Nella nostra\nsquadra d'esplorazione?", spanish="¿Qué?[K] ¿Tener a [CS:N]Cresselia[CR] en\nnuestro equipo explorador?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="If I'm not a burden, I very much\nhope that you would accept me on your team...", french="Si je ne représente pas un trop\nlourd fardeau, j'aimerais beaucoup que\nvous m'acceptiez dans votre équipe...", german="Wenn ich keine Last bin, hoffe\nich sehr, dass ihr mich in euer Team\naufnehmen werdet.", italian="Se non sono di peso, spero\ndavvero che mi accetterete nella vostra\nsquadra...", spanish="Si no lo consideráis una carga,\nme gustaría que me aceptarais en vuestro\nequipo explorador..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Will you have me?", french=" M'acceptez-vous?", german=" Nehmt ihr mich?", italian=" Mi volete con voi?", spanish=" ¿Me aceptáis?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Are you joking? You're not a\nburden at all!", french="Tu plaisantes? Tu n'as rien\nd'un fardeau! Bien au contraire!", german="Machst du Witze? Du bist ganz\nund gar keine Last!", italian="Stai scherzando? Non sei per\nnulla di peso!", spanish="¿Pero qué dices? ¡Claro que no\neres ninguna carga!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You must be joking! You're the\nlast Pokémon I'd consider a burden!", french="Tu plaisantes? Tu n'as rien\nd'un fardeau! Bien au contraire!", german="Du musst Witze machen! Du bist\ndas letzte Pokémon, das ich als Last\nbetrachten würde!", italian="Starai scherzando! Sei l'ultimo\nPokémon che considererei un peso!", spanish="¿Pero qué dices? ¡Claro que no\neres ninguna carga!"})
  else
  SkySceneKit.say({english=" Not at all! You're no burden!", french="Tu plaisantes? Tu n'as rien\nd'un fardeau! Bien au contraire!", german=" Absolut nicht! Du bist keine Last!", italian=" Non è vero! Non sei un peso!", spanish="¿Pero qué dices? ¡Claro que no\neres ninguna carga!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's great you want to join us!", french="C'est un honneur que tu veuilles\nte joindre à nous!", german="Es ist großartig, dass du dich\nuns anschließen willst!", italian="Grande! Farai parte della\nnostra squadra!", spanish=" ¡Nos encantaría contar contigo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We're honored to have you!", french="C'est un honneur que tu veuilles\nte joindre à nous!", german="Es ist uns eine Ehre, dich dabei\nzu haben!", italian="Saremmo felici di averti con\nnoi!", spanish=" ¡Nos encantaría contar contigo!"})
  else
  SkySceneKit.say({english=" We'd love to have you!", french="C'est un honneur que tu veuilles\nte joindre à nous!", german="Wir würden dich gerne dabei\nhaben!", italian="Sarebbe bellissimo averti con\nnoi!", spanish=" ¡Nos encantaría contar contigo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Right, [hero]?", french=" Pas vrai, [hero]?", german=" Richtig, [hero]?", italian=" Vero, [hero]?", spanish=" ¿Verdad, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Right, [hero]?", french=" Pas vrai, [hero]?", german=" Richtig, [hero]?", italian=" Vero, [hero]?", spanish=" ¿Verdad, [hero]?"})
  else
  SkySceneKit.say({english=" Right, [hero]?", french=" Pas vrai, [hero]?", german=" Richtig, [hero]?", italian=" Vero, [hero]?", spanish=" ¿Verdad, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_PREPARE_MENU_ACCEPT_TEAM_MEMBER, 18, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_ACCEPT_TEAM_MEMBER"] or 0) -- switch(message_Menu(MENU_ACCEPT_TEAM_MEMBER)) [message_Menu(MENU_ACCEPT_TEAM_MEMBER): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 2 then
  -- message_Close
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" ...I see. That's disappointing.", french=" ... Je vois. Quelle déception!", german="...Verstehe. Das ist\nenttäuschend.", italian=" Capisco. Che delusione!", spanish=" Ya veo. Qué decepción."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="If you have a change of heart,\nand you would let me join your team...", french="Si d'aventure vous changiez\nd'avis et décidiez de m'accepter dans votre\néquipe...", german="Falls ihr es euch anders\nüberlegen solltet und mich in euer Team\naufnehmen möchtet...", italian="Se doveste cambiare idea e\nmi voleste nella vostra squadra...", spanish="Si cambiáis de opinión y queréis\nque me una al equipo..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Please tell me.", french=" ... faites-le-moi savoir.", german=" Lasst es mich bitte wissen.", italian=" Ditemelo per favore.", spanish=" Hacédmelo saber."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Thank you so much!", french=" Merci de tout cœur!", german=" Vielen Dank!", italian=" Grazie infinite!", spanish=" ¡Muchísimas gracias!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kureseria, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kureseria, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Oh, for sure, [c_name:NPC_NEW_FRIEND]!\nThank you for joining us!", french="Oh, bien sûr, [c_name:NPC_NEW_FRIEND]!\nMerci de te joindre à nous!", german="Aber sicher doch, [c_name:NPC_NEW_FRIEND]!\nDanke, dass du dich uns anschließt!", italian="Oh, davvero, [c_name:NPC_NEW_FRIEND]!\nWow, è fantastico che ora tu ti sia\nunita a noi!", spanish="Oh, ¡de nada, [c_name:NPC_NEW_FRIEND]!\n¡Gracias por unirte al equipo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh, you bet, [c_name:NPC_NEW_FRIEND]!\nThank you for joining us!", french="Oh, bien sûr, [c_name:NPC_NEW_FRIEND]!\nMerci de te joindre à nous!", german="Schon in Ordnung, [c_name:NPC_NEW_FRIEND]!\nDanke, dass du dich uns anschließt!", italian="Oh, davvero, [c_name:NPC_NEW_FRIEND]!\nChe bello che tu ti sia unita a noi!", spanish="Oh, ¡de nada, [c_name:NPC_NEW_FRIEND]!\n¡Gracias por unirte al equipo!"})
  else
  SkySceneKit.say({english="Oh, for sure, [c_name:NPC_NEW_FRIEND]!\nThank you for joining us!", french="Oh, bien sûr, [c_name:NPC_NEW_FRIEND]!\nMerci de te joindre à nous!", german="Aber sicher doch, [c_name:NPC_NEW_FRIEND]!\nDanke, dass du dich uns anschließt!", italian="Oh, davvero, [c_name:NPC_NEW_FRIEND]!\nChe gioia che tu ti sia unita a noi!", spanish="Oh, ¡de nada, [c_name:NPC_NEW_FRIEND]!\n¡Gracias por unirte al equipo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayFanfare("Fanfare/JoinTeam") end) -- me_Play(5) [jingle ME NDS -> fanfare PMDO]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][c_name:NPC_NEW_FRIEND] joined the team!", french="[CN][c_name:NPC_NEW_FRIEND] a rejoint l'équipe!", german="[CN][c_name:NPC_NEW_FRIEND] gehört nun zum Team.", italian="[CN][c_name:NPC_NEW_FRIEND] entra a far parte della squadra!", spanish="[CN]¡[c_name:NPC_NEW_FRIEND] se unió al equipo!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  GAME:FadeOut(false, 30)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(60)
  GAME:FadeIn(30)
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  elseif (SkyProg.cmp(29, 91) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 102 then
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kureseria, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="I was driven to journey far and\nwide. I simply had to! I must stop [CS:N]Darkrai[CR]'s\nvile scheme.", french="J'ai été poussée à voyager de\npar le monde. Je n'ai pas eu le choix! Il faut\ndéjouer l'infâme complot de [CS:N]Darkrai[CR].", german="Ich spürte den Drang, überall\nherumzureisen. Ich musste einfach! Das fiese\nKomplott von [CS:N]Darkrai[CR] muss verhindert werden.", italian="Ho sentito un impulso irrefrena-\nbile a viaggiare lontano. Dovevo farlo!\nBisogna fermare il vile piano di [CS:N]Darkrai[CR].", spanish="Tuve que embarcarme en un\nviaje larguísimo. No tenía otra opción si\nquería detener el malvado plan de [CS:N]Darkrai[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="We don't have far to go.[K]\nThere's no giving up now!", french="Ce n'est plus très loin.[K]\nAccrochons-nous!", german="Es ist nicht mehr weit.[K]\nJetzt nicht aufgeben!", italian="Non ci manca più molto.[K]\nNon possiamo mollare adesso!", spanish="Ya no queda mucho.[K] ¡No podemos\nrendirnos ahora!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_7 [étiquette de flux ExplorerScript]
  -- supervision_ExecuteCommon(CORO_EVENT_S22_05) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 90) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 90]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 102 then
  -- @label_5 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 102 then
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kureseria, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="There's no telling when [CS:N]Darkrai[CR]\nwill strike.", french="Il est impossible de prévoir\nquand [CS:N]Darkrai[CR] se décidera à frapper.", german="Es kann nicht vorhergesagt\nwerden, wann [CS:N]Darkrai[CR] zuschlagen wird.", italian="Non si sa quando [CS:N]Darkrai[CR]\ncolpirà.", spanish="Es imposible saber cuándo\natacará [CS:N]Darkrai[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Let's proceed with\nutmost caution.", french="Procédons avec la plus extrême\nprudence.", german="Gehen wir mit äußerster\nVorsicht vor.", italian="Procediamo con la massima\ncautela.", spanish=" Obremos con cautela."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 89) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 89]
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 88] || scn($SCENARIO_MAIN) >= [2
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
