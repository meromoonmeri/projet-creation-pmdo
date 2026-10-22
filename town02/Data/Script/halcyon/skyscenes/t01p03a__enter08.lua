-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P03A/enter08.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) or (SkyProg.cmp_side(40, 3) >= 0) or (SkyProg.cmp_side(40, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7] || scn($SCENARIO_SIDE) >= [40
  -- @label_4 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif ((SV.SkyTalkBitFlags or {})[126] == 1) then -- elseif ROM: $SCENARIO_TALK_BIT_FLAG[126]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_garagara = SkySceneKit.spawn_npc("marowak", 256, 208, Direction.Down, "NPC_GARAGARA")
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="[CS:K]Marowak[CR] Dojo is\ndefinitely...[K] Just definitely!", french="Le [CS:K]Dojo Ossatueur[CR], à n'en\npas douter...[K] c'est une certitude absolue...", german="Das [CS:K]Knogga-Dojo[CR] wird\nzweifellos...[K] Ganz zweifellos!", italian="Sicuramente il Dojo [CS:K]Marowak[CR]...[K]\nInsomma, sicuramente, ecco!", spanish="El [CS:K]Dojo Marowak[CR], sin el menor\natisbo de duda...[K] ¡No cabe duda!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" Definitely coming back!!", french="... renaîtra bientôt de\nses cendres!", german=" Zweifellos zurückkehren!", italian=" Riaprirà sicuramente!", spanish=" ¡¡Volverá!!"})
  -- message_Close
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[126] = 1 -- $SCENARIO_TALK_BIT_FLAG[126] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=".........[K]\nCus...[K]customers...", french="..........[K]\nDe...[K] la visite...", german=".........[K]\nKun...[K] Kundschaft...", italian=".........[K]\nCli...[K] Clienti...", spanish=" Anda...[K] Un cliente...[K] ¡Qué fuerte!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="...[K]You came all the way here,\nbut...", french="...[K] Tu as fait tout ce chemin\njusqu'ici, mais...", german="...[K]Du bist den ganzen Weg\nhierhergekommen, aber...", italian="...[K] Grazie di essere venuto fino\na qui, ma...", spanish="Has venido...[K] Has venido hasta aquí,\npero..."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="[CS:K]Marowak[CR] Dojo has collapsed as\nof today...", french="... le [CS:K]Dojo Ossatueur[CR]\nn'est plus en service...", german="Im [CS:K]Knogga-Dojo[CR] ist ab heute\nerst mal kein Training mehr möglich...", italian="... i dedali del Dojo [CS:K]Marowak[CR]\nnon sono accessibili. Chiudo il dojo.", spanish="El [CS:K]Dojo Marowak[CR] está\nfuera de servicio..."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" However!", french=" Cependant!", german=" Wie auch immer!", italian=" Però...", spanish=" ¡Peeero...!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="One day...definitely...[K]\nI'll be reviving it!", french="Un jour... c'est sûr...[K]\nje le rouvrirai!", german="Eines Tages... werde ich...[K]\nes zweifellos wiedereröffnen!", italian="Un giorno... sicuramente...[K]\nlo riaprirò!", spanish="Un día... estoy seguro de que...[K]\n¡conseguiré que resurja!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="Definitely! [K]Definitely![K]\nDefinitely reviving it!", french="C'est sûr![K]\nArchisûr! [K]Je le rouvrirai!", german="Zweifellos! [K]Zweifellos![K]\nZweifellos wiedereröffnen!", italian="Sicuramente! [K]Sicuramente![K]\nLo riaprirò sicuramente!", spanish="¡No me cabe duda![K] ¡Seguro![K]\n¡Que renacerá, te digo!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" Uhhn...huhhn...", french=" Hohhh hahhh...", german=" Hrmmmhh... hrmmmhh....", italian=" Eeeh aaah....", spanish=" Arf, arf..."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="...[K]This dojo will be closed\nbeginning tomorrow...", french="...[K] Ce dojo sera fermé\ndès demain...", german="...[K]Dieses Dojo wird ab morgen\ngeschlossen bleiben...", italian="...[K] Questo dojo rimarrà chiuso\na partire da domani...", spanish="Pues...[K] Este dojo estará cerrado\na partir de mañana..."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" Definitely be revived!", french=" Je le rouvrirai, c'est sûr!", german="Aber zweifellos wiedereröffnet\nwerden!", italian=" Ma lo riaprirò sicuramente!", spanish=" ¡Renacerá sin lugar a dudas!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" Ah... So you won't forget...", french="Ah... Et pour que tu\nn'oublies pas...", german=" Das darfst du nicht vergessen!", italian="Ah... Affinché non te lo\ndimentichi...", spanish=" Ah... Para que no lo olvides..."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" I'll give this to you.", french=" ... je t'offre ceci.", german="Ich gebe dir dies als\nErinnerungsstütze.", italian=" ... ti darò questo.", spanish=" Voy a darte esto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="[CN]In remembrance of the failed [CS:K]Marowak[CR] Dojo,\n[CN][CS:Y]Bidoof[CR]...", french="[CN]En souvenir du [CS:K]Dojo Ossatueur[CR],\n[CN]condamné à une faillite inexorable,\n[CN][CS:Y]Keunotor[CR]...", german="[CN]In Erinnerung an das gescheiterte\n[CN][CS:K]Knogga-Dojo[CR] erhält [CS:Y]Bidiza[CR]", italian="[CN]Per non essere riuscito ad accedere\nal Dojo [CS:K]Marowak[CR], [CN][CS:Y]Bidoof[CR]...", spanish="[CN]En memoria al fallido [CS:K]Dojo Marowak[CR],\n[CN][CS:Y]Bidoof[CR]..."})
  -- message_KeyWait
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="[CN]Received a [CS:I]Reviver Seed[CR]!", french="[CN]... reçoit une [CS:I]Résugraine[CR]!", german="[CN]einen [CS:I]Belebersamen[CR]!", italian="[CN]... riceve un [CS:I]Revitalseme[CR]!", spanish="[CN]Consiguió una [CS:I]Sem. Revivir[CR]."})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 73, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="Remember the dojo whenever\nyou look at it, OK?", french="Souviens-toi du dojo quand tu\nregarderas cet objet, d'accord?", german="Denk an das Dojo, wann immer\ndu ihn betrachtest, in Ordnung?", italian="Ricordati del dojo ogni volta che\nlo guarderai, ok?", spanish="Piensa en el dojo cada vez\nque la mires, ¿vale?"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="[CS:K]Marowak[CR] Dojo is\ndefinitely...[K] Just definitely!", french="Le [CS:K]Dojo Ossatueur[CR], à n'en\npas douter...[K] c'est une certitude absolue...", german="Das [CS:K]Knogga-Dojo[CR] wird\nzweifellos...[K] Ganz zweifellos!", italian="Sicuramente il Dojo [CS:K]Marowak[CR]...[K]\nInsomma, sicuramente, ecco!", spanish="El [CS:K]Dojo Marowak[CR], sin el menor\natisbo de duda...[K] ¡No cabe duda!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" Definitely coming back!", french="... renaîtra bientôt de\nses cendres!", german=" Zweifellos zurückkehren!", italian=" Riaprirà sicuramente!", spanish=" ¡Volverá!"})
  -- message_Close
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
