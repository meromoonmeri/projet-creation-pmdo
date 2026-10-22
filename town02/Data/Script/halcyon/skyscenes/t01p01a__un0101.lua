-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/un0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) or (SkyProg.cmp_side(40, 3) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7] || scn($SCENARIO_SIDE) >= [40
  -- @label_4 [étiquette de flux ExplorerScript]
  -- switch(message_Menu(MENU_DUSKULL_BANK)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp_side(40, 2) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 2]
  if ((SV.SkyTalkBitFlags or {})[128] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[128]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[128] = 1 -- $SCENARIO_TALK_BIT_FLAG[128] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_yomawaru = SkySceneKit.spawn_npc("duskull", 520, 168, Direction.Down, "NPC_YOMAWARU")
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english=" Oh? [CS:Y]Bidoof[CR]...", french=" Oh? [CS:Y]Keunotor[CR]...", german=" Oh? [CS:Y]Bidiza[CR]...", italian=" Oh? [CS:Y]Bidoof[CR]...", spanish=" Ah, [CS:Y]Bidoof[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english="You sure have a cheerful\nexpression today.", french="Tu as vraiment une mine\nréjouie aujourd'hui.", german="Du siehst heute aber ganz schön\nfröhlich aus.", italian=" Hai proprio un'aria allegra oggi.", spanish=" Hoy se te ve radiante de felicidad."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yomawaru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english="I know! [K]Something good is\nhappening! Hee-hee.", french="Je sais! [K]Quelque chose\nde bien t'est arrivé! Gni hi hiii...", german="Ich weiß![K] Etwas Gutes\ngeschieht! Huhuhu.", italian="Ci sono! [K]È successo qualcosa\ndi bello! Hii-hii.", spanish="¡Ya sé![K] Eso es que pasa\nalgo bueno. Ji, ji."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english="Oh! [CS:Y]Bidoof[CR]![K]\nGreetings! Hee-hee.", french="Oh! [CS:Y]Keunotor[CR]![K]\nBienvenue! Gni hi hiii...", german="Oh! [CS:Y]Bidiza[CR]![K]\nSei gegrüßt! Huhuhu.", italian="Oh! [CS:Y]Bidoof[CR]![K]\nSalve! Hii-hii.", spanish="¡Ah, hola, [CS:Y]Bidoof[CR]![K]\n¿Qué tal? Ji, ji."})
  pcall(function() UI:SetSpeaker(npc_npc_yomawaru) end)
  SkySceneKit.say({english="Today's such a nice day, isn't it?[K]\nGood luck with your work!", french="Quelle belle journée aujourd'hui,\nn'est-ce pas?[K]\nBonne chance avec ton travail!", german="Heute ist ein so schöner Tag,\nnicht wahr?[K] Viel Glück bei deiner Arbeit!", italian="È una bellissima giornata oggi,\nnon è vero?[K] Buona fortuna per il tuo lavoro!", spanish="Hace un día precioso, ¿verdad?[K]\n¡Buena suerte con tus misiones!"})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
