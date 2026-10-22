-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P28A/enter12.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  if ((SV.SkyScenarioBitFlags or {})[49] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[49]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_denryuu = SkySceneKit.spawn_npc("ampharos", 320, 288, Direction.UpLeft, "NPC_DENRYUU")
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="Hey.\nIf it isn't Team [team:].", french="Hé.\nVoilà l'Equipe [team:].", german="Hey! Wenn das nicht\nTeam [team:] ist.", italian="Ehi! Ma guarda se non è\nil Team [team:]!", spanish="Anda...\nPero si es el [CS:X]Equipo[CR] [team:]."})
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="Heading up to the summit\nagain today?", french="On tente une nouvelle ascension\ndu sommet?", german="Heute wieder zum Gipfel\nunterwegs?", italian="Di nuovo alla conquista\ndella cima?", spanish="¿Hoy también te diriges\na la cima?"})
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english=" Good luck!", french=" Bonne chance!", german=" Viel Erfolg!", italian=" Buona fortuna!", spanish=" ¡Pues que tengas buena suerte!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif ((SV.SkyScenarioBitFlags or {})[48] == 1) then -- elseif ROM: $SCENARIO_MAIN_BIT_FLAG[48]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english=" He's kind of clumsy, isn't he?", french="Il est du genre maladroit,\nn'est-ce pas?", german="Er ist ein wenig tollpatschig,\nnicht wahr?", italian=" È un po' strano, non è vero?", spanish=" Es un poco torpe, ¿no?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- @label_134 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="I found this right after [CS:N]Sneasel[CR]\nran off.", french="J'ai trouvé ça juste après que\n[CS:N]Farfuret[CR] a déguerpi.", german="Kurz nachdem sich [CS:N]Sniebel[CR] aus\ndem Staub gemacht hatte, fand ich dies.", italian="Subito dopo che [CS:N]Sneasel[CR]\nse l'è data a gambe, ho trovato questo.", spanish="Encontré esto justo cuando\n[CS:N]Sneasel[CR] salió huyendo."})
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="I think it's a gift of gratitude\nfor you.", french="Je crois que c'est un cadeau\nde remerciement pour vous...", german="Sieht mir nach einem Geschenk\naus Dankbarkeit für dich aus.", italian="Penso che sia un regalo per te,\ncome segno di ringraziamento.", spanish="Creo que es un detalle\nde agradecimiento para ti."})
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english=" You should take it.", french=" Vous devriez le prendre.", german=" Du solltest es nehmen.", italian=" Dovresti prenderlo.", spanish=" Deberías quedártelo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_BAG_FULL"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_BAG_FULL, 0, 0)) [ProcessSpecial(PROCESS_SPECIAL_IS_BAG_FULL): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[48] = 1 -- $SCENARIO_MAIN_BIT_FLAG[48] = 1 (ROM)
  -- item_SetTableData(0, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_ADD_TABLE_ITEM_TO_BAG, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="[CN]This is...", french="[CN]C'est...", german="[CN]Es ist...", italian="[CN]Questo è...", spanish="[CN]Se trata de..."})
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="[CN][player] received\n[CN]a [CS:I]Sky Gift[CR].", french="[CN][player] reçoit\n[CN]un [CS:I]Don du Ciel[CR].", german="[CN][player] erhält\n[CN]ein [CS:I]Himmelspräsent[CR].", italian="[CN][player] ha ricevuto\n[CN]un [CS:I]Dono Cielo[CR].", spanish="[CN][player] ha obtenido\n[CN]un [CS:I]Regalo Cielo[CR]."})
  -- message_Close
  -- GAP: se_Play(11021) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="[CN]You gently open the lid...", french="[CN]Vous ouvrez délicatement le couvercle...", german="[CN]Du öffnest behutsam den Deckel...", italian="[CN]Apri lentamente il pacchetto...", spanish="[CN]Abres la tapa con cuidado..."})
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="[CN]Inside was the\n[CN][s_item:0]!", french="[CN]A l'intérieur se trouve l'objet\n[CN][s_item:0]!", german="[CN]Im Paket liegt das Item\n[CN][s_item:0]!", italian="[CN]... e al suo interno trovi lo strumento\n[CN][s_item:0]!", spanish="[CN]¡Había un objeto\n[CN][s_item:0] dentro!"})
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="[CN]A warm and fuzzy feeling falls over you...", french="[CN]Que c'est agréable de recevoir un cadeau...", german="[CN]Ein warmes, angenehmes Kribbeln\n[CN]überkommt dich...", italian="[CN]Una dolce sensazione di calore ti investe...", spanish="[CN]Te invade una sensación de calidez..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english=" But your hands are full already.", french="Mais vous avez déjà les\nmains pleines.", german=" Aber du hast keinen Platz dafür.", italian=" Ma non hai spazio.", spanish=" Pero tienes las manos ocupadas."})
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="OK, I'll hold on to this for you\nfor now.", french="Très bien, je vais le transporter\npour vous.", german="Ich werde es für dich\naufbewahren.", italian="Ok, per il momento lo\nconserverò io.", spanish="Bueno, de momento\nte lo guardaré yo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  elseif (SkyProg.cmp(29, 30) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_denryuu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Wie bitte?!?", italian=" Come?!", spanish=" ¡¿Cómo?!"})
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english=" The summit is utterly ruined?!", french="Le sommet est\ncomplètement dévasté?!", german="Der Gipfel ist vollkommen\nverdreckt?!?", italian=" La cima è devastata?!", spanish="¡¿La cima está totalmente\nen ruinas?!"})
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="I haven't been to the summit in\na long time myself...", french="Ça fait longtemps que je ne\nsuis pas allé au sommet, moi-même...", german="Ich persönlich war schon lange\nnicht mehr auf dem Gipfel...", italian="È da tanto che non metto\npiede lassù...", spanish="La verdad es que hace mucho\nque no subo a la cima..."})
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english=" I wonder what happened...", french="Je me demande ce qui\ns'est passé...", german="Ich frage mich, was geschehen\nist...", italian=" Mi chiedo cosa sia successo...", spanish=" Me pregunto qué habrá pasado..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 29] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english=" Leave [CS:N]Sneasel[CR] to me.", french="Laissez-moi [CS:N]Farfuret[CR],\nje m'en occupe.", german=" Überlass mir ruhig [CS:N]Sniebel[CR].", italian=" Ci penso io a [CS:N]Sneasel[CR].", spanish=" Déjame a [CS:N]Sneasel[CR] a mí."})
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="You're almost to the summit.\nJust a little more.", french="Vous êtes presque au\nsommet. Un dernier petit effort.", german="Ihr seid schon fast am Gipfel.\nNur noch ein kleines Stück.", italian="Siete quasi arrivati in cima.\nManca poco.", spanish="Estáis muy cerca de la cima.\nSolo falta un poco más."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 25] || scn($SCENARIO_MAIN) >= [2
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
