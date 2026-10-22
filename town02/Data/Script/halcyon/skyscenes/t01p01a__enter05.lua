-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/enter05.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_yomawaru = SkySceneKit.spawn_npc("duskull", 520, 168, Direction.Down, "NPC_YOMAWARU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yomawaru, 4) end)
  if ((SV.SkyTalkBitFlags or {})[118] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[118]
  -- @label_131 [étiquette de flux ExplorerScript]
  -- switch(message_Menu(MENU_DUSKULL_BANK)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[118] = 1 -- $SCENARIO_TALK_BIT_FLAG[118] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english="Thank you so much,\n[hero] and [partner]!", french="Merci mille fois,\n[hero] et [partner]!", german="Vielen Dank, [hero] und\n[partner]!", italian="Grazie molte, [hero] e\n[partner]!", spanish="¡Muchísimas gracias,\n[hero] y [partner]!"})
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english="This gives me the peace of mind\nto run the bank properly!", french="Ainsi, je peux gérer la\nbanque l'âme en paix!", german="Das gibt mir den Seelenfrieden,\nden ich benötige, um die Bank ordentlich zu\nführen!", italian="Ora che il mondo è salvo, ho la\npace mentale necessaria per occuparmi\nadeguatamente della banca.", spanish="Me habéis tranquilizado lo\nsuficiente como para llevar este\nbanco como debe ser."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yomawaru, 4) end)
  if ((SV.SkyTalkBitFlags or {})[117] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[117]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[117] = 1 -- $SCENARIO_TALK_BIT_FLAG[117] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english=" Best of luck! Do take care!", french="Bonne chance! Prenez soin de\nvous!", german=" Viel Glück! Gebt auf euch acht!", italian=" Auguri! Fate attenzione!", spanish=" ¡Buena suerte! ¡Cuidaos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yomawaru, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 67]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yomawaru, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yomawaru, 4) end)
  if ((SV.SkyTalkBitFlags or {})[115] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[115]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[115] = 1 -- $SCENARIO_TALK_BIT_FLAG[115] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english=" Whooooo! I wish to see them!", french=" Ouuuh là là! Je veux les voir!", german=" Whuuuuu! Ich möchte sie sehen!", italian=" Woooooow! Voglio vederle!", spanish="¡Ah, se me parte el alma de\nemoción! ¡Quiero verlas!"})
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english="What I would give for a mere\nglimpse of the members of Team [CS:X]Charm[CR]!", french="Que ne donnerais-je pas\npour entrapercevoir l'Equipe\n[CS:X]Charme[CR]!", german="Was würde ich nur darum\ngeben, einen Blick auf die Mitglieder von Team\n[CS:X]Charme[CR] zu erhaschen!", italian="Cosa non darei per vedere anche\nper un attimo le belle del Team [CS:X]Malia[CR]!", spanish="¡Daría lo que fuera por poder\nver al [CS:X]Equipo Carisma[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english="Will you be offended if I left to\nlook at them right now?", french="Vous offusqueriez-vous si je\nm'éclipsais pour les voir?", german="Wäret ihr beleidigt, wenn ich\nmich jetzt aufmachen würde, um sie zu\nsuchen?", italian="Vi offendete se vado a dare\nun'occhiata proprio adesso?", spanish="¿Os ofendería que saliera\nvolando a verlas?"})
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english="...But that would certainly result\nin me being reprimanded...", french="... Mais je n'y gagnerais\ncertainement que des réprimandes...", german="Aber dafür würde ich sicherlich\neine Rüge bekommen.", italian="Ma verrò sicuramente\nrimproverato...", spanish="Aunque si lo hiciera, me\nremordería la conciencia. La culpa\nsería mi pena..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yomawaru, 4) end)
  if ((SV.SkyTalkBitFlags or {})[116] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[116]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[116] = 1 -- $SCENARIO_TALK_BIT_FLAG[116] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english="I congratulate you on your guild\ngraduation.", french="Je vous félicite pour l'obtention\nde votre diplôme.", german="Ich beglückwünsche euch zu der\nbestandenen Gildenabschlussprüfung.", italian="Mi congratulo con voi per\naver superato l'esame.", spanish="Os felicito por haber superado\nel reto del [CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english="I do hope you continue to rake in\nmoney...[K]and allow me to hoard it!", french="Je compte sur vous pour\ncontinuer à amasser de l'argent...[K]\nque je puisse garder précieusement!", german="Ich hoffe, ihr nehmt auch\nweiterhin Geld ein...[K] Und gestattet mir, es zu\nhorten!", italian="Spero che continuerete a\nrastrellare soldi...[K] e che mi permetterete di\ntenerli per voi!", spanish="Espero que sigáis atesorando\nmucho dinero...[K] ¡y que me permitáis\nguardarlo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yomawaru, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yomawaru, 4) end)
  if ((SV.SkyTalkBitFlags or {})[114] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[114]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[114] = 1 -- $SCENARIO_TALK_BIT_FLAG[114] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english=" My thoughts go with you...", french="Mes pensées vous\naccompagnent...", german=" In Gedanken bin ich bei euch...", italian=" Il mio pensiero va a voi...", spanish=" Os acompañaré en espíritu..."})
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english="Please, put an end to the planet's\nparalysis.", french="Mettez un terme à la Paralysie\nde la Planète, je vous en prie.", german="Bitte bereitet der Lähmung des\nPlaneten ein Ende.", italian="Per favore, scongiurate la\nparalisi del pianeta.", spanish="Por favor, detened la parálisis\ndel planeta."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(24, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yomawaru, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [23
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yomawaru, 4) end)
  if ((SV.SkyTalkBitFlags or {})[113] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[113]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[113] = 1 -- $SCENARIO_TALK_BIT_FLAG[113] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english="Good to see you with us...[K]\nYour absence kept me from resting in peace...", french="C'est bon de vous revoir parmi\nnous...[K] Votre absence m'a empêché de\nreposer en paix...", german="Gut, euch bei uns zu haben.[K]\nEure Abwesenheit hat dafür gesorgt, dass ich\nkeine ruhige Minute hatte.", italian="È bello avervi di nuovo con\nnoi...[K] La vostra assenza non mi consentiva\ndi dormire sonni tranquilli...", spanish="Es un alivio veros por aquí...[K]\nVuestra ausencia me impedía descansar en\npaz..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yomawaru, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 3] || scn($SCENARIO_MAIN) >= [17
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yomawaru, 4) end)
  if ((SV.SkyTalkBitFlags or {})[112] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[112]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[112] = 1 -- $SCENARIO_TALK_BIT_FLAG[112] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english="Startling, isn't it?[K] Visitations of\nPokémon from a distant future...", french="N'est-ce pas stupéfiant?[K]\nLa venue de Pokémon en provenance d'un\nlointain futur...", german="Alarmierend, nicht wahr?[K]\nBesuche von Pokémon aus einer fernen\nZukunft.", italian="Sorprendente, nevvero?[K] Visite\ndi Pokémon da un futuro lontano...", spanish="Inquietante, ¿verdad?[K] Visitas de\nPokémon del futuro..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yomawaru, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 4] || scn($SCENARIO_MAIN) >= [12
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yomawaru, 4) end)
  if ((SV.SkyTalkBitFlags or {})[111] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[111]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[111] = 1 -- $SCENARIO_TALK_BIT_FLAG[111] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english=" Ah, welcome back.", french=" Ah, content de vous revoir.", german=" Ah, willkommen zurück.", italian="Ah, sono contento di vedervi di\nritorno.", spanish=" Ah, casi parecéis una aparición."})
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english="The money earned on your\nexpedition... Please allow me to hoard it for\nyou in my bank.", french="L'argent que vous avez gagné au\ncours de l'expédition... Laissez-moi en prendre\nsoin pour vous dans ma banque.", german="Das Geld, das ihr auf eurer\nExpedition erbeutet habt... Bitte erlaubt, dass\nich es in meiner Bank horte.", italian="I soldi guadagnati durante la\nvostra spedizione... Permettete che li tenga io\nnella mia banca.", spanish="Permitidme que custodie la suma\nque habéis atesorado en la expedición."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yomawaru, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [9, 1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yomawaru, 4) end)
  if ((SV.SkyTalkBitFlags or {})[110] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[110]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[110] = 1 -- $SCENARIO_TALK_BIT_FLAG[110] = 1 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english="I wish you the best of fortunes\non your expedition. Hee-hee!", french="Je souhaite que la fortune vous\nsourie pendant l'expédition. Gni hi hiii...", german="Ich wünsche euch viel Glück\nauf eurer Expedition. Heehee!", italian="Vi auguro il meglio per la vostra\nspedizione. Eeh-eeh!", spanish="Os deseo la mejor de las suertes\nen vuestra expedición."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yomawaru, 4) end)
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
