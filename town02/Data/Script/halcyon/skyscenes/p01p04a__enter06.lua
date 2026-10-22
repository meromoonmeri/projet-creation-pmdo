-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P04A/enter06.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if ((SV.SkyScenarioBitFlags or {})[62] == 1) or ((SV.SkyScenarioBitFlags or {})[63] == 1) or ((SV.SkyScenarioBitFlags or {})[64] == 1) or ((SV.SkyScenarioBitFlags or {})[65] == 1) or ((SV.SkyScenarioBitFlags or {})[66] == 1) or ((SV.SkyScenarioBitFlags or {})[67] == 1) or ((SV.SkyScenarioBitFlags or {})[68] == 1) or ((SV.SkyScenarioBitFlags or {})[69] == 1) or ((SV.SkyScenarioBitFlags or {})[70] == 1) or ((SV.SkyScenarioBitFlags or {})[71] == 1) or ((SV.SkyScenarioBitFlags or {})[72] == 1) or ((SV.SkyScenarioBitFlags or {})[73] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[62] || $SCENARIO_MAIN_BIT_FLAG[63] |
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_patchiiru = SkySceneKit.spawn_npc("spinda", 256, 152, Direction.Down, "NPC_PATCHIIRU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_patchiiru, 4) end)
  GAME:WaitFrames(1)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" Oh, [hero]!", french=" Oh, [hero]!", german=" Oh, [hero]!", italian=" Oh, [hero]!", spanish=" ¡Anda, [hero]!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="There is a package here for\nTeam [team:]!", french="Un colis vient d'arriver pour\nl'Equipe [team:]!", german="Ich habe hier ein Paket für\nTeam [team:]!", italian="È arrivato un pacchetto per\nil Team [team:]!", spanish="Tengo un paquete para el [CS:X]Equipo[CR]\n[team:]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- @label_2 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_BAG_FULL"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_BAG_FULL, 0, 0)) [ProcessSpecial(PROCESS_SPECIAL_IS_BAG_FULL): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  -- item_SetTableData(0, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_ADD_TABLE_ITEM_TO_BAG, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN][hero] received the package!", french="[CN][hero] réceptionne le colis!", german="[CN][hero] erhält ein Paket!", italian="[CN][hero] ha ricevuto il pacchetto!", spanish="[CN][hero] ha obtenido el paquete."})
  if ((SV.SkyScenarioBitFlags or {})[62] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[62]
  -- @label_6 [étiquette de flux ExplorerScript]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[62] = 0 -- $SCENARIO_MAIN_BIT_FLAG[62] = 0 (ROM)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[50] = 0 -- $SCENARIO_MAIN_BIT_FLAG[50] = 0 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]It's a gift from\n[CN]the Guildmaster!", french="[CN]C'est un cadeau de la part\n[CN]du Maître de la Guilde!", german="[CN]Es ist ein Präsent\n[CN]des Gildenmeisters!", italian="[CN]È un regalo da parte\n[CN]del Capitano!", spanish="[CN]¡Es un regalo del\n[CN]Gran Bluff!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]There's a message too.", french="[CN]Un message l'accompagne.", german="[CN]Zusammen mit einer Nachricht:", italian="[CN]C'è anche un messaggio.", spanish="[CN]También hay un mensaje."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Thank you for\n[CN]the [CS:I]Sky Gift[CR]!", french="[CN]Merci pour le\n[CN][CS:I]Don du Ciel[CR]!", german="[CN]Vielen Dank für das\n[CN][CS:I]Himmelspräsent[CR]!", italian="[CN]Ti ringrazio per\n[CN]il [CS:I]Dono Cielo[CR]!", spanish="[CN]¡Gracias por\n[CN]el [CS:I]Regalo Cielo[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]I am so happy!\n[CN]Even though it wasn't a Perfect Apple!", french="[CN]Je suis si heureux!\n[CN]Même si ce n'était pas une Pomme Parfaite!", german="[CN]Ich bin so glücklich!\n[CN]Auch wenn es kein Perfekter Apfel war!", italian="[CN]Sono così felice!\n[CN]Anche se non era una Mela Perfetta!", spanish="[CN]¡Me ha encantado!\n[CN]¡Y eso que no era una Manzana Perfecta!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Gifts are just so wonderful!\n[CN]I'm glad we're such friendly friends!", french="[CN]Les cadeaux, c'est si merveilleux! Je suis\n[CN]content que vous soyez des copains de moi!", german="[CN]Präsente sind etwas Wunderbares!\n[CN]Ich bin froh, dass wir so liebe Freunde sind!", italian="[CN]Ricevere un regalo è meraviglioso!\n[CN]Sono contento di essere un tuo amicissimo!", spanish="[CN]¡Los regalos son maravillosos!\n[CN]¡Casi tanto como los amigos!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Please accept this token of thanks.\n--[CS:N]Wigglytuff[CR]", french="[CN]Veuillez accepter ceci en remerciement.\n- [CS:N]Grodoudou[CR]", german="[CN]Nimm dies als Zeichen meiner Dankbarkeit.\n-[CS:N]Knuddeluff[CR]", italian="[CN]Accetta questo come segno di ringraziamento.\n- [CS:N]Wigglytuff[CR] -", spanish="[CN]Acepta este detalle en agradecimiento.\n[CN]            -[CS:N]Wigglytuff[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN][hero] gently\n[CN]opens the lid...", french="[CN][hero] ouvre\n[CN]délicatement le couvercle...", german="[CN][hero] öffnet\n[CN]behutsam den Deckel...", italian="[CN][hero] apre\n[CN]lentamente il pacchetto...", spanish="[CN][hero] abre la tapa\n[CN]con cuidado..."})
  -- message_Close
  -- GAP: se_Play(11021) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Inside was the\n[CN][s_item:0]!", french="[CN]A l'intérieur se trouve l'objet\n[CN][s_item:0]!", german="[CN]Im Paket liegt das Item\n[CN][s_item:0]!", italian="[CN]... e al suo interno trova\n[CN][s_item:0]!", spanish="[CN]¡Había un objeto\n[CN][s_item:0] dentro!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]A warm and fuzzy feeling falls over you...", french="[CN]Que c'est agréable de recevoir un cadeau...", german="[CN]Ein warmes, angenehmes Kribbeln\n[CN]überkommt dich...", italian="[CN]Una dolce sensazione di calore ti investe...", spanish="[CN]Te invade una sensación de calidez..."})
  -- message_Close
  -- @label_18 [étiquette de flux ExplorerScript]
  if ((SV.SkyScenarioBitFlags or {})[62] == 1) or ((SV.SkyScenarioBitFlags or {})[63] == 1) or ((SV.SkyScenarioBitFlags or {})[64] == 1) or ((SV.SkyScenarioBitFlags or {})[65] == 1) or ((SV.SkyScenarioBitFlags or {})[66] == 1) or ((SV.SkyScenarioBitFlags or {})[67] == 1) or ((SV.SkyScenarioBitFlags or {})[68] == 1) or ((SV.SkyScenarioBitFlags or {})[69] == 1) or ((SV.SkyScenarioBitFlags or {})[70] == 1) or ((SV.SkyScenarioBitFlags or {})[71] == 1) or ((SV.SkyScenarioBitFlags or {})[72] == 1) or ((SV.SkyScenarioBitFlags or {})[73] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[62] || $SCENARIO_MAIN_BIT_FLAG[63] |
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" You got more.", french=" Tenez, voilà un autre colis!", german=" Du hast noch mehr.", italian=" Ne è arrivato un altro.", spanish=" Y hay más."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- @label_5 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  elseif ((SV.SkyScenarioBitFlags or {})[63] == 1) then -- elseif ROM: $SCENARIO_MAIN_BIT_FLAG[63]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[63] = 0 -- $SCENARIO_MAIN_BIT_FLAG[63] = 0 (ROM)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[51] = 0 -- $SCENARIO_MAIN_BIT_FLAG[51] = 0 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]It's a gift from\n[CN][CS:N]Chatot[CR]!", french="[CN]C'est un cadeau de la part\n[CN]de [CS:N]Pijako[CR]!", german="[CN]Es ist ein Präsent von\n[CN][CS:N]Plaudagei[CR]!", italian="[CN]È un regalo da parte\n[CN]di [CS:N]Chatot[CR]!", spanish="[CN]¡Es un regalo de\n[CN][CS:N]Chatot[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]There's a message too.", french="[CN]Un message l'accompagne.", german="[CN]Zusammen mit einer Nachricht:", italian="[CN]C'è anche un messaggio.", spanish="[CN]También hay un mensaje."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Thanks for the [CS:I]Sky Gift[CR]! ♪", french="[CN]Merci pour le [CS:I]Don du Ciel[CR]! ♪", german="[CN]Vielen Dank für das\n[CN][CS:I]Himmelspräsent[CR]!", italian="[CN]Grazie per il [CS:I]Dono Cielo[CR]! ♪", spanish="[CN]¡Gracias por el [CS:I]Regalo Cielo[CR]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]I was honestly surprised to\n[CN]see a gift from you. ♪", french="[CN]J'ai été sincèrement étonné\n[CN]de recevoir un cadeau de votre part. ♪", german="[CN]Es hat mich aufrichtig gefreut,\n[CN]ein Präsent von dir zu erhalten. ♪", italian="[CN]Sono rimasto sinceramente colpito\n[CN]nel ricevere un tuo regalo. ♪", spanish="[CN]Me sorprendió mucho recibir\n[CN]un regalo tuyo. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]I think it's important to show\n[CN]your feelings of gratitude. ♪", french="[CN]Je pense qu'il est important d'exprimer\n[CN]ainsi sa reconnaissance. ♪", german="[CN]Es ist eine große Gabe, Gefühle der\n[CN]Dankbarkeit zeigen zu können. ♪", italian="[CN]È una bella cosa che tu voglia dimostrare\n[CN]i tuoi sentimenti di gratitudine. ♪", spanish="[CN]Creo que es importante\n[CN]mostrar gratitud. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]This is my thank-you. ♪\n--[CS:N]Chatot[CR]", french="[CN]Alors recevez ceci en remerciement. ♪\n- [CS:N]Pijako[CR]", german="[CN]Das hier ist mein Dankeschön. ♪\n-[CS:N]Plaudagei[CR]", italian="[CN]Questo è il mio modo per ringraziarti. ♪\n- [CS:N]Chatot[CR] -", spanish="[CN]Así te doy las gracias. ♪\n[CN]            -[CS:N]Chatot[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN][hero]\n[CN]gently opens the lid...", french="[CN][hero] ouvre\n[CN]délicatement le couvercle...", german="[CN][hero] öffnet\n[CN]behutsam den Deckel...", italian="[CN][hero] apre\n[CN]lentamente il pacchetto...", spanish="[CN][hero] abre la tapa\n[CN]con cuidado..."})
  -- message_Close
  -- GAP: se_Play(11021) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Inside was the\n[CN][s_item:0]!", french="[CN]A l'intérieur se trouve l'objet\n[CN][s_item:0]!", german="[CN]Im Paket liegt das Item\n[CN][s_item:0]!", italian="[CN]... e al suo interno trova\n[CN][s_item:0]!", spanish="[CN]¡Había un objeto\n[CN][s_item:0] dentro!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]A warm and fuzzy feeling falls over you...", french="[CN]Que c'est agréable de recevoir un cadeau...", german="[CN]Ein warmes, angenehmes Kribbeln\n[CN]überkommt dich...", italian="[CN]Una dolce sensazione di calore ti investe...", spanish="[CN]Te invade una sensación de calidez..."})
  -- message_Close
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif ((SV.SkyScenarioBitFlags or {})[64] == 1) then -- elseif ROM: $SCENARIO_MAIN_BIT_FLAG[64]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[64] = 0 -- $SCENARIO_MAIN_BIT_FLAG[64] = 0 (ROM)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[52] = 0 -- $SCENARIO_MAIN_BIT_FLAG[52] = 0 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]It's a gift from\n[CN][CS:N]Diglett[CR]!", french="[CN]C'est un cadeau de la part\n[CN]de [CS:N]Taupiqueur[CR]!", german="[CN]Es ist ein Präsent von\n[CN][CS:N]Digda[CR]!", italian="[CN]È un regalo da parte\n[CN]di [CS:N]Diglett[CR]!", spanish="[CN]¡Es un regalo de\n[CN][CS:N]Diglett[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]There's a message too.", french="[CN]Un message l'accompagne.", german="[CN]Zusammen mit einer Nachricht:", italian="[CN]C'è anche un messaggio.", spanish="[CN]También hay un mensaje."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Thank you so very much for the [CS:I]Sky Gift[CR]!", french="[CN]Merci beaucoup pour le [CS:I]Don du Ciel[CR]!", german="[CN]Vielen Dank für das\n[CN][CS:I]Himmelspräsent[CR]!", italian="[CN]Grazie mille per il [CS:I]Dono Cielo[CR]!", spanish="[CN]¡Muchísimas gracias por el [CS:I]Regalo Cielo[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]It was an unexpected surprise.\n[CN]It made me so very happy!", french="[CN]C'était une surprise incroyable.\n[CN]Ça m'a vraiment fait très plaisir!", german="[CN]Eine unerwartete Überraschung.\n[CN]Oh, es hat mich wirklich sehr gefreut!", italian="[CN]È stata davvero una bella sorpresa.\n[CN]Mi hai reso proprio felice!", spanish="[CN]Ha sido una sorpresa totalmente inesperada.\n[CN]¡Y me ha hecho muy feliz!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Please accept this thank-you.\n--[CS:N]Diglett[CR]", french="[CN]Veuillez accepter ceci en remerciement.\n- [CS:N]Taupiqueur[CR]", german="[CN]Bitte nimm dies als Dankeschön.\n-[CS:N]Digda[CR]", italian="[CN]Ecco, accetta questo come ringraziamento.\n- [CS:N]Diglett[CR] -", spanish="[CN]Por favor, acepta esto en agradecimiento.\n[CN]            -[CS:N]Diglett[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN][hero]\n[CN]gently opens the lid...", french="[CN][hero] ouvre\n[CN]délicatement le couvercle...", german="[CN][hero] öffnet\n[CN]behutsam den Deckel...", italian="[CN][hero] apre\n[CN]lentamente il pacchetto...", spanish="[CN][hero] abre la tapa\n[CN]con cuidado..."})
  -- message_Close
  -- GAP: se_Play(11021) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Inside was the\n[CN][s_item:0]!", french="[CN]A l'intérieur se trouve l'objet\n[CN][s_item:0]!", german="[CN]Im Paket liegt das Item\n[CN][s_item:0]!", italian="[CN]... e al suo interno trova\n[CN][s_item:0]!", spanish="[CN]¡Había un objeto\n[CN][s_item:0] dentro!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]A warm and fuzzy feeling falls over you...", french="[CN]Que c'est agréable de recevoir un cadeau...", german="[CN]Ein warmes, angenehmes Kribbeln\n[CN]überkommt dich...", italian="[CN]Una dolce sensazione di calore ti investe...", spanish="[CN]Te invade una sensación de calidez..."})
  -- message_Close
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif ((SV.SkyScenarioBitFlags or {})[65] == 1) then -- elseif ROM: $SCENARIO_MAIN_BIT_FLAG[65]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[65] = 0 -- $SCENARIO_MAIN_BIT_FLAG[65] = 0 (ROM)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[53] = 0 -- $SCENARIO_MAIN_BIT_FLAG[53] = 0 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]It's a gift from\n[CN][CS:N]Dugtrio[CR]!", french="[CN]C'est un cadeau de la part\n[CN]de [CS:N]Triopikeur[CR]!", german="[CN]Es ist ein Präsent von\n[CN][CS:N]Digdri[CR]!", italian="[CN]È un regalo da parte\n[CN]di [CS:N]Dugtrio[CR]!", spanish="[CN]¡Es un regalo de\n[CN][CS:N]Dugtrio[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]There's a message too.", french="[CN]Un message l'accompagne.", german="[CN]Zusammen mit einer Nachricht:", italian="[CN]C'è anche un messaggio.", spanish="[CN]También hay un mensaje."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Thank you so much for the [CS:I]Sky Gift[CR]!", french="[CN]Merci beaucoup pour le [CS:I]Don du Ciel[CR]!", german="[CN]Vielen Dank für das\n[CN][CS:I]Himmelspräsent[CR]!", italian="[CN]Ti ringraziamo tantissimo per il [CS:I]Dono Cielo[CR]!", spanish="[CN]¡Muchísimas gracias por el [CS:I]Regalo Cielo[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]You wouldn't believe how happy we are to get a\n[CN]gift! We even shouted the feeling to the sea!", french="[CN]Vous ne vous imaginez pas comme nous\n[CN]sommes heureux d'avoir reçu un cadeau!\n[CN]Nous en avons tonné notre joie face à la mer!", german="[CN]Du kannst dir nicht vorstellen, wie glücklich\n[CN]mich dein Präsent gemacht hat! Ich habe\n[CN]meine Freude sogar auf die See hinausgerufen!", italian="[CN]Non sai quanto siamo felici di ricevere\n[CN]un regalo! Abbiamo perfino urlato\n[CN]la nostra gioia in riva al mare!", spanish="[CN]¡Ni te imaginas la ilusión que nos ha hecho el\n[CN]regalo! Se lo hemos gritado al mar y todo."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Here's a thanks!\n--[CS:N]Dugtrio[CR]", french="[CN]Voici pour vous remercier.\n- [CS:N]Triopikeur[CR]", german="[CN]Hier ein Dankeschön!\n-[CS:N]Digdri[CR]", italian="[CN]Questo è il nostro modo di ringraziarti!\n- [CS:N]Dugtrio[CR] -", spanish="[CN]Toma esto como muestra de agradecimiento.\n[CN]            -[CS:N]Dugtrio[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN][hero]\n[CN]gently opens the lid...", french="[CN][hero] ouvre\n[CN]délicatement le couvercle...", german="[CN][hero] öffnet\n[CN]behutsam den Deckel...", italian="[CN][hero] apre\n[CN]lentamente il pacchetto...", spanish="[CN][hero] abre la tapa\n[CN]con cuidado..."})
  -- message_Close
  -- GAP: se_Play(11021) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Inside was the\n[CN][s_item:0]!", french="[CN]A l'intérieur se trouve l'objet\n[CN][s_item:0]!", german="[CN]Im Paket liegt das Item\n[CN][s_item:0]!", italian="[CN]... e al suo interno trova\n[CN][s_item:0]!", spanish="[CN]¡Había un objeto\n[CN][s_item:0] dentro!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]A warm and fuzzy feeling falls over you...", french="[CN]Que c'est agréable de recevoir un cadeau...", german="[CN]Ein warmes, angenehmes Kribbeln\n[CN]überkommt dich...", italian="[CN]Una dolce sensazione di calore ti investe...", spanish="[CN]Te invade una sensación de calidez..."})
  -- message_Close
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif ((SV.SkyScenarioBitFlags or {})[66] == 1) then -- elseif ROM: $SCENARIO_MAIN_BIT_FLAG[66]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[66] = 0 -- $SCENARIO_MAIN_BIT_FLAG[66] = 0 (ROM)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[54] = 0 -- $SCENARIO_MAIN_BIT_FLAG[54] = 0 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]It's a gift from\n[CN][CS:N]Sunflora[CR]!", french="[CN]C'est un cadeau de la part\n[CN]d'[CS:N]Héliatronc[CR]!", german="[CN]Es ist ein Präsent von\n[CN][CS:N]Sonnflora[CR]!", italian="[CN]È un regalo da parte\n[CN]di [CS:N]Sunflora[CR]!", spanish="[CN]¡Es un regalo de\n[CN][CS:N]Sunflora[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]There's a message too.", french="[CN]Un message l'accompagne.", german="[CN]Zusammen mit einer Nachricht:", italian="[CN]C'è anche un messaggio.", spanish="[CN]También hay un mensaje."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Oh my gosh!\n[CN]Thank you so very much for the [CS:I]Sky Gift[CR]! ♪", french="[CN]Ben mince alors!\n[CN]Mille mercis pour le [CS:I]Don du Ciel[CR]!", german="[CN]Auweia, auweia!\n[CN]Vielen Dank für das [CS:I]Himmelspräsent[CR]!", italian="[CN]Evviva!\n[CN]Ti sono così grata per il [CS:I]Dono Cielo[CR]! ♪", spanish="[CN]¡Qué superfuerte!\n[CN]¡O sea, muchas gracias por el [CS:I]Regalo Cielo[CR]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]I was so happy to receive\n[CN]a gift that I fainted!", french="[CN]J'étais si heureuse d'avoir reçu un cadeau\n[CN]que je me suis évanouie!!", german="[CN]Ich war so glücklich, ein Geschenk zu erhalten,\n[CN]dass ich in Ohnmacht gefallen bin!!!", italian="[CN]Ero talmente felice all'idea di aver\n[CN]ricevuto un regalo che sono svenuta!!!", spanish="[CN]¡Fue tan superemocionante ver el\n[CN]regalo que me desmayé y todo!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Thanks again!\n--[CS:N]Sunflora[CR]", french="[CN]Merci encore!\n- [CS:N]Héliatronc[CR]", german="[CN]Danke noch mal!\n-[CS:N]Sonnflora[CR]", italian="[CN]Grazie ancora!\n- [CS:N]Sunflora[CR] -", spanish="[CN]¡Muchas gracias de nuevo!\n[CN]            -[CS:N]Sunflora[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN][hero]\n[CN]gently opens the lid...", french="[CN][hero] ouvre\n[CN]délicatement le couvercle...", german="[CN][hero] öffnet\n[CN]behutsam den Deckel...", italian="[CN][hero] apre\n[CN]lentamente il pacchetto...", spanish="[CN][hero] abre la tapa\n[CN]con cuidado..."})
  -- message_Close
  -- GAP: se_Play(11021) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Inside was the\n[CN][s_item:0]!", french="[CN]A l'intérieur se trouve l'objet\n[CN][s_item:0]!", german="[CN]Im Paket liegt das Item\n[CN][s_item:0]!", italian="[CN]... e al suo interno trova\n[CN][s_item:0]!", spanish="[CN]¡Había un objeto\n[CN][s_item:0] dentro!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]A warm and fuzzy feeling falls over you...", french="[CN]Que c'est agréable de recevoir un cadeau...", german="[CN]Ein warmes, angenehmes Kribbeln\n[CN]überkommt dich...", italian="[CN]Una dolce sensazione di calore ti investe...", spanish="[CN]Te invade una sensación de calidez..."})
  -- message_Close
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif ((SV.SkyScenarioBitFlags or {})[67] == 1) then -- elseif ROM: $SCENARIO_MAIN_BIT_FLAG[67]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[67] = 0 -- $SCENARIO_MAIN_BIT_FLAG[67] = 0 (ROM)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[55] = 0 -- $SCENARIO_MAIN_BIT_FLAG[55] = 0 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]It's a gift from\n[CN][CS:N]Loudred[CR]!", french="[CN]C'est un cadeau de la part\n[CN]de [CS:N]Ramboum[CR]!", german="[CN]Es ist ein Präsent von\n[CN][CS:N]Krakeelo[CR]!", italian="[CN]È un regalo da parte\n[CN]di [CS:N]Loudred[CR]!", spanish="[CN]¡Es un regalo de\n[CN][CS:N]Loudred[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]There's a message too.", french="[CN]Un message l'accompagne.", german="[CN]Zusammen mit einer Nachricht:", italian="[CN]C'è anche un messaggio.", spanish="[CN]También hay un mensaje."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]HA HA HA! Thanks MUCH for THE [CS:I]Sky GIFT[CR]!", french="[CN]HA HA HA!\n[CN]Merci BEAUCOUP pour le [CS:I]DON du Ciel[CR]!", german="[CN]HA HA HA!\n[CN]Vielen DANK für DAS [CS:I]Himmelspräsent[CR]!", italian="[CN]AH AH AH! Grazie TANTE per IL [CS:I]Dono CIELO[CR]!", spanish="[CN]¡Ja, ja, ja! ¡Gracias por el [CS:I]Regalo Cielo[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]I'll TREASURE this GIFT!!", french="[CN]JE conserverai ce CADEAU précieusement!", german="[CN]Dieses PRÄSENT ist jetzt MEIN Schatz!!!", italian="[CN]CONSERVERÒ questo REGALO come un tesoro!!!", spanish="[CN]¡Lo guardaré como oro en paño!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]This is my THANKS!\n[CN]PLEASE take IT!\n--[CS:N]Loudred[CR]", french="[CN]VOICI pour vous REMERCIER!\n[CN]PRENEZ donc ÇA!\n- [CS:N]Ramboum[CR]", german="[CN]Hier ein Dankeschön von MIR!\n[CN]BITTE nimm ES!\n-[CS:N]Krakeelo[CR]", italian="[CN]Ecco il mio RINGRAZIAMENTO!\n[CN]PER FAVORE, accettalo!\n- [CS:N]Loudred[CR] -", spanish="[CN]Este es mi regalo de agradecimiento.\n[CN]¡Por favor, acéptalo!\n[CN]            -[CS:N]Loudred[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN][hero]\n[CN]gently opens the lid...", french="[CN][hero] ouvre\n[CN]délicatement le couvercle...", german="[CN][hero] öffnet\n[CN]behutsam den Deckel...", italian="[CN][hero] apre\n[CN]lentamente il pacchetto...", spanish="[CN][hero] abre la tapa\n[CN]con cuidado..."})
  -- message_Close
  -- GAP: se_Play(11021) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Inside was the\n[CN][s_item:0]!", french="[CN]A l'intérieur se trouve l'objet\n[CN][s_item:0]!", german="[CN]Im Paket liegt das Item\n[CN][s_item:0]!", italian="[CN]... e al suo interno trova\n[CN][s_item:0]!", spanish="[CN]¡Había un objeto\n[CN][s_item:0] dentro!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]A warm and fuzzy feeling falls over you...", french="[CN]Que c'est agréable de recevoir un cadeau...", german="[CN]Ein warmes, angenehmes Kribbeln\n[CN]überkommt dich...", italian="[CN]Una dolce sensazione di calore ti investe...", spanish="[CN]Te invade una sensación de calidez..."})
  -- message_Close
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif ((SV.SkyScenarioBitFlags or {})[68] == 1) then -- elseif ROM: $SCENARIO_MAIN_BIT_FLAG[68]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[68] = 0 -- $SCENARIO_MAIN_BIT_FLAG[68] = 0 (ROM)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[56] = 0 -- $SCENARIO_MAIN_BIT_FLAG[56] = 0 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]It's a gift from\n[CN][CS:N]Corphish[CR]!", french="[CN]C'est un cadeau de la part\n[CN]d'[CS:N]Ecrapince[CR]!", german="[CN]Es ist ein Präsent von\n[CN][CS:N]Krebscorps[CR]!", italian="[CN]È un regalo da parte\n[CN]di [CS:N]Corphish[CR]!", spanish="[CN]¡Es un regalo de\n[CN][CS:N]Corphish[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]There's a message too.", french="[CN]Un message l'accompagne.", german="[CN]Zusammen mit einer Nachricht:", italian="[CN]C'è anche un messaggio.", spanish="[CN]También hay un mensaje."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Hey, hey, hey!\n[CN]Thanks for the [CS:I]Sky Gift[CR]!", french="[CN]Saperlipopince!\n[CN]Merci pour le [CS:I]Don du Ciel[CR]!", german="[CN]Hey, hey, hey!\n[CN]Danke für das [CS:I]Himmelspräsent[CR]!", italian="[CN]Ehi, ehi, ehi!\n[CN]Grazie per il tuo [CS:I]Dono Cielo[CR]!", spanish="[CN]¡Oye, oye!\n[CN]¡Gracias por el [CS:I]Regalo Cielo[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]I was moved!\n[CN]I love getting presents!", french="[CN]Quelle émotion!\n[CN]J'adore recevoir des cadeaux!", german="[CN]Das hat mich sehr berührt!\n[CN]Ich liebe Geschenke!", italian="[CN]Mi hai davvero commosso!\n[CN]Adoro ricevere regali!", spanish="[CN]¡Me he emocionado y todo!\n[CN]Es que me encanta recibir regalos..."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]This is in thanks.\n--[CS:N]Corphish[CR]", french="[CN]Voici pour vous remercier.\n- [CS:N]Ecrapince[CR]", german="[CN]Dies kommt als Dank.\n-[CS:N]Krebscorps[CR]", italian="[CN]Ecco a te, per ringraziarti.\n- [CS:N]Corphish[CR] -", spanish="[CN]Acepta esto en agradecimiento.\n[CN]            -[CS:N]Corphish[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN][hero]\n[CN]gently opens the lid...", french="[CN][hero] ouvre\n[CN]délicatement le couvercle...", german="[CN][hero] öffnet\n[CN]behutsam den Deckel...", italian="[CN][hero] apre\n[CN]lentamente il pacchetto...", spanish="[CN][hero] abre la tapa\n[CN]con cuidado..."})
  -- message_Close
  -- GAP: se_Play(11021) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Inside was the\n[CN][s_item:0]!", french="[CN]A l'intérieur se trouve l'objet\n[CN][s_item:0]!", german="[CN]Im Paket liegt das Item\n[CN][s_item:0]!", italian="[CN]... e al suo interno trova\n[CN][s_item:0]!", spanish="[CN]¡Había un objeto\n[CN][s_item:0] dentro!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]A warm and fuzzy feeling falls over you...", french="[CN]Que c'est agréable de recevoir un cadeau...", german="[CN]Ein warmes, angenehmes Kribbeln\n[CN]überkommt dich...", italian="[CN]Una dolce sensazione di calore ti investe...", spanish="[CN]Te invade una sensación de calidez..."})
  -- message_Close
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif ((SV.SkyScenarioBitFlags or {})[69] == 1) then -- elseif ROM: $SCENARIO_MAIN_BIT_FLAG[69]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[69] = 0 -- $SCENARIO_MAIN_BIT_FLAG[69] = 0 (ROM)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[57] = 0 -- $SCENARIO_MAIN_BIT_FLAG[57] = 0 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]It's a gift from\n[CN][CS:N]Chimecho[CR]!", french="[CN]C'est un cadeau de la part\n[CN]d'[CS:N]Eoko[CR]!", german="[CN]Es ist ein Präsent von\n[CN][CS:N]Palimpalim[CR]!", italian="[CN]È un regalo da parte\n[CN]di [CS:N]Chimecho[CR]!", spanish="[CN]¡Es un regalo de\n[CN][CS:N]Chimecho[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]There's a message too.", french="[CN]Un message l'accompagne.", german="[CN]Zusammen mit einer Nachricht:", italian="[CN]C'è anche un messaggio.", spanish="[CN]También hay un mensaje."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Thank you for the [CS:I]Sky Gift[CR]!", french="[CN]Merci pour le [CS:I]Don du Ciel[CR]!", german="[CN]Danke dir für das [CS:I]Himmelspräsent[CR]!", italian="[CN]Grazie tante per il [CS:I]Dono Cielo[CR]!", spanish="[CN]¡Gracias por el [CS:I]Regalo Cielo[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]I was so happy all day long\n[CN]after receiving your present! ♪", french="[CN]Votre cadeau a vraiment\n[CN]illuminé ma journée! ♪", german="[CN]Als ich das Geschenk bekommen habe,\n[CN]war ich den ganzen Tag lang froh! ♪", italian="[CN]Dopo aver ricevuto il tuo regalo mi sono\n[CN]sentita felice per tutta la giornata! ♪", spanish="[CN]¡Después de recibirlo no se me borró\n[CN]la sonrisa de la cara en todo el día! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Gifts from the heart are the best gifts of all!", french="[CN]Les cadeaux qui viennent du cœur\n[CN]sont les plus beaux de tous!", german="[CN]Geschenke, die von Herzen kommen, sind die\n[CN]besten Geschenke überhaupt!", italian="[CN]I regali fatti con il cuore\n[CN]sono i migliori in assoluto!", spanish="[CN]Se ve que es un regalo hecho de corazón."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]This is my heartfelt thank-you.\n--[CS:N]Chimecho[CR]", french="[CN]Avec mes sincères remerciements.\n- [CS:N]Eoko[CR]", german="[CN]Dieses Dankeschön kommt auch von Herzen.\n-[CS:N]Palimpalim[CR]", italian="[CN]Ecco il mio ringraziamento per te.\n- [CS:N]Chimecho[CR] -", spanish="[CN]Toma esto como muestra de agradecimiento.\n[CN]            -[CS:N]Chimecho[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN][hero]\n[CN]gently opens the lid...", french="[CN][hero] ouvre\n[CN]délicatement le couvercle...", german="[CN][hero] öffnet\n[CN]behutsam den Deckel...", italian="[CN][hero] apre\n[CN]lentamente il pacchetto...", spanish="[CN][hero] abre la tapa\n[CN]con cuidado..."})
  -- message_Close
  -- GAP: se_Play(11021) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Inside was the\n[CN][s_item:0]!", french="[CN]A l'intérieur se trouve l'objet\n[CN][s_item:0]!", german="[CN]Im Paket liegt das Item\n[CN][s_item:0]!", italian="[CN]... e al suo interno trova\n[CN][s_item:0]!", spanish="[CN]¡Había un objeto\n[CN][s_item:0] dentro!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]A warm and fuzzy feeling falls over you...", french="[CN]Que c'est agréable de recevoir un cadeau...", german="[CN]Ein warmes, angenehmes Kribbeln\n[CN]überkommt dich...", italian="[CN]Una dolce sensazione di calore ti investe...", spanish="[CN]Te invade una sensación de calidez..."})
  -- message_Close
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif ((SV.SkyScenarioBitFlags or {})[70] == 1) then -- elseif ROM: $SCENARIO_MAIN_BIT_FLAG[70]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[70] = 0 -- $SCENARIO_MAIN_BIT_FLAG[70] = 0 (ROM)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[58] = 0 -- $SCENARIO_MAIN_BIT_FLAG[58] = 0 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]It's a gift from\n[CN][CS:N]Bidoof[CR]!", french="[CN]C'est un cadeau de la part\n[CN]de [CS:N]Keunotor[CR]!", german="[CN]Es ist ein Präsent von\n[CN][CS:N]Bidiza[CR]!", italian="[CN]È un regalo da parte\n[CN]di [CS:N]Bidoof[CR]!", spanish="[CN]¡Es un regalo de\n[CN][CS:N]Bidoof[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]There's a message too.", french="[CN]Un message l'accompagne.", german="[CN]Zusammen mit einer Nachricht:", italian="[CN]C'è anche un messaggio.", spanish="[CN]También hay un mensaje."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Yup yup! Thanks much for the [CS:I]Sky Gift[CR]!", french="[CN]Sapristi!\n[CN]Merci beaucoup pour le [CS:I]Don du Ciel[CR]!", german="[CN]Jawollja! Vielen Dank für das\n[CN][CS:I]Himmelspräsent[CR]!", italian="[CN]Ohibò! Grazie mille per il [CS:I]Dono Cielo[CR]!", spanish="[CN]¡Muchas gracias por el [CS:I]Regalo Cielo[CR], sí, señor!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]I sure am happy to work with\n[CN]you all in the guild,\n[CN][hero] and [partner].", french="[CN]J'suis vraiment heureux de travailler\n[CN]avec vous à la Guilde,\n[CN][hero] et [partner].", german="[CN]Ich bin so froh, mit euch beiden\n[CN]in der Gilde zu arbeiten,\n[CN][hero] und [partner].", italian="[CN]Sono davvero felice di lavorare\n[CN]con voi nella Gilda,\n[CN][hero] e [partner].", spanish="[CN]Me hace muy feliz trabajar con vuestro\n[CN]equipo en el [CS:N]Pokégremio[CR],\n[CN][hero] y [partner]."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]It's not much, but I hope you'll like this thanks.\n--[CS:N]Bidoof[CR]", french="[CN]C'est pas grand-chose, mais j'espère\n[CN]que vous aimerez.\n- [CS:N]Keunotor[CR]", german="[CN]Donnerwetter. Es ist nichts Großes, aber\n[CN]hoffentlich gefällt euch mein Dankeschön.\n-[CS:N]Bidiza[CR]", italian="[CN]Non è molto, ma spero che apprezzerete\n[CN]il mio modo di ringraziarvi.\n- [CS:N]Bidoof[CR] -", spanish="[CN]No es mucho, pero espero que os guste.\n[CN]            -[CS:N]Bidoof[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN][hero]\n[CN]gently opens the lid...", french="[CN][hero] ouvre\n[CN]délicatement le couvercle...", german="[CN][hero] öffnet\n[CN]behutsam den Deckel...", italian="[CN][hero] apre\n[CN]lentamente il pacchetto...", spanish="[CN][hero] abre la tapa\n[CN]con cuidado..."})
  -- message_Close
  -- GAP: se_Play(11021) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Inside was the\n[CN][s_item:0]!", french="[CN]A l'intérieur se trouve l'objet\n[CN][s_item:0]!", german="[CN]Im Paket liegt das Item\n[CN][s_item:0]!", italian="[CN]... e al suo interno trova\n[CN][s_item:0]!", spanish="[CN]¡Había un objeto\n[CN][s_item:0] dentro!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]A warm and fuzzy feeling falls over you...", french="[CN]Que c'est agréable de recevoir un cadeau...", german="[CN]Ein warmes, angenehmes Kribbeln\n[CN]überkommt dich...", italian="[CN]Una dolce sensazione di calore ti investe...", spanish="[CN]Te invade una sensación de calidez..."})
  -- message_Close
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif ((SV.SkyScenarioBitFlags or {})[71] == 1) then -- elseif ROM: $SCENARIO_MAIN_BIT_FLAG[71]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[71] = 0 -- $SCENARIO_MAIN_BIT_FLAG[71] = 0 (ROM)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[59] = 0 -- $SCENARIO_MAIN_BIT_FLAG[59] = 0 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]It's a gift from\n[CN][CS:N]Croagunk[CR]!", french="[CN]C'est un cadeau de la part\n[CN]de [CS:N]Cradopaud[CR]!", german="[CN]Es ist ein Präsent von\n[CN][CS:N]Glibunkel[CR]!", italian="[CN]È un regalo da parte\n[CN]di [CS:N]Croagunk[CR]!", spanish="[CN]¡Es un regalo de\n[CN][CS:N]Croagunk[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]There's a message too.", french="[CN]Un message l'accompagne.", german="[CN]Zusammen mit einer Nachricht:", italian="[CN]C'è anche un messaggio.", spanish="[CN]También hay un mensaje."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Meh-heh...\n[CN]Meh-heh-heh!", french="[CN]Mwé hé...\n[CN]Mwé hé hé!", german="[CN]Mehe...\n[CN]Mehehehe!", italian="[CN]Eh eh...\n[CN]Eh eh eh!", spanish="[CN]Je, je...\n[CN]¡Je, je, je!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Thanks for the [CS:I]Sky Gift[CR]. Meh-heh-heh.", french="[CN]Merci pour le [CS:I]Don du Ciel[CR]. Mwé hé hé.", german="[CN]Danke für das [CS:I]Himmelspräsent[CR]. Mehehe.", italian="[CN]Grazie per il [CS:I]Dono Cielo[CR]. Eh eh eh.", spanish="[CN]Gracias por el [CS:I]Regalo Cielo[CR], je, je, je."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Meh-heh-heh...\n[CN]Well done, I have to admit.", french="[CN]Mwé hé hé...\n[CN]Pas mal, faut l'avouer.", german="[CN]Mehehe...\n[CN]Gut gemacht, muss ich zugeben.", italian="[CN]Eh eh eh...\n[CN]Mi hai sorpreso, lo ammetto.", spanish="[CN]Je, je, je...\n[CN]Tengo que admitir que has acertado de lleno."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Here's a thanks.\n[CN]Meh-heh-heh...\n--[CS:N]Croagunk[CR]", french="[CN]Voici pour vous remercier.\n[CN]Mwé hé hé...\n- [CS:N]Cradopaud[CR]", german="[CN]Hier ein Dankeschön.\n[CN]Mehehe...\n-[CS:N]Glibunkel[CR]", italian="[CN]Ecco a te, per ringraziarti.\n[CN]Eh eh eh...\n- [CS:N]Croagunk[CR] -", spanish="[CN]Acepta un detalle en agradecimiento.\n[CN]Je, je, je...\n[CN]            -[CS:N]Croagunk[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN][hero]\n[CN]gently opens the lid...", french="[CN][hero] ouvre\n[CN]délicatement le couvercle...", german="[CN][hero] öffnet\n[CN]behutsam den Deckel...", italian="[CN][hero] apre\n[CN]lentamente il pacchetto...", spanish="[CN][hero] abre la tapa\n[CN]con cuidado..."})
  -- message_Close
  -- GAP: se_Play(11021) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Inside was the\n[CN][s_item:0]!", french="[CN]A l'intérieur se trouve l'objet\n[CN][s_item:0]!", german="[CN]Im Paket liegt das Item\n[CN][s_item:0]!", italian="[CN]... e al suo interno trova\n[CN][s_item:0]!", spanish="[CN]¡Había un objeto\n[CN][s_item:0] dentro!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]A warm and fuzzy feeling falls over you...", french="[CN]Que c'est agréable de recevoir un cadeau...", german="[CN]Ein warmes, angenehmes Kribbeln\n[CN]überkommt dich...", italian="[CN]Una dolce sensazione di calore ti investe...", spanish="[CN]Te invade una sensación de calidez..."})
  -- message_Close
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif ((SV.SkyScenarioBitFlags or {})[72] == 1) then -- elseif ROM: $SCENARIO_MAIN_BIT_FLAG[72]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[72] = 0 -- $SCENARIO_MAIN_BIT_FLAG[72] = 0 (ROM)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[60] = 0 -- $SCENARIO_MAIN_BIT_FLAG[60] = 0 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]It's a gift from\n[CN][partner]!", french="[CN]C'est un cadeau de la part\n[CN]de [partner]!", german="[CN]Es ist ein Präsent von\n[CN][partner]!", italian="[CN]È un regalo da parte\n[CN]di [partner]!", spanish="[CN]¡Es un regalo de\n[CN][partner]!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]There's a message too.", french="[CN]Un message l'accompagne.", german="[CN]Zusammen mit einer Nachricht:", italian="[CN]C'è anche un messaggio.", spanish="[CN]También hay un mensaje."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Thanks so much for the [CS:I]Sky Gift[CR]!", french="[CN]Merci beaucoup pour le [CS:I]Don du Ciel[CR]!", german="[CN]Danke vielmals für das [CS:I]Himmelspräsent[CR]!", italian="[CN]Grazie mille per il [CS:I]Dono Cielo[CR]!", spanish="[CN]¡Muchísimas gracias por el [CS:I]Regalo Cielo[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]I'll be sure to take good care of it,\n[CN]since it's from you, [hero].", french="[CN]J'en prendrai bien soin parce que\n[CN]ça vient de toi, [hero].", german="[CN]Ich werde gut darauf aufpassen,\n[CN]weil es von dir kommt, [hero].", italian="[CN]Lo custodirò con cura, perché è\n[CN]un tuo regalo, [hero].", spanish="[CN]Lo cuidaré con todo el cariño, ya que\n[CN]proviene de ti, [hero]."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Here's a token of my appreciation.\n[CN]Let's keep on working together!\n--[partner]", french="[CN]Voici pour te montrer ma gratitude.\n[CN]Continuons à faire du bon travail ensemble!\n- [partner]", german="[CN]Hier ist ein Zeichen meiner Dankbarkeit.\n[CN]Lass uns weiter zusammenarbeiten!\n-[partner]", italian="[CN]Questo è il mio modo di ringraziarti.\n[CN]Con eterna amicizia!\n- [partner] -", spanish="[CN]Acepta un detalle en agradecimiento.\n[CN]¡Sigamos trabajando juntos!\n[CN]            -[partner]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN][hero]\n[CN]gently opens the lid...", french="[CN][hero] ouvre\n[CN]délicatement le couvercle...", german="[CN][hero] öffnet\n[CN]behutsam den Deckel...", italian="[CN][hero] apre\n[CN]lentamente il pacchetto...", spanish="[CN][hero] abre la tapa\n[CN]con cuidado..."})
  -- message_Close
  -- GAP: se_Play(11021) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Inside was the\n[CN][s_item:0]!", french="[CN]A l'intérieur se trouve l'objet\n[CN][s_item:0]!", german="[CN]Im Paket liegt das Item\n[CN][s_item:0]!", italian="[CN]... e al suo interno trova\n[CN][s_item:0]!", spanish="[CN]¡Había un objeto\n[CN][s_item:0] dentro!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]A warm and fuzzy feeling falls over you...", french="[CN]Que c'est agréable de recevoir un cadeau...", german="[CN]Ein warmes, angenehmes Kribbeln\n[CN]überkommt dich...", italian="[CN]Una dolce sensazione di calore ti investe...", spanish="[CN]Te invade una sensación de calidez..."})
  -- message_Close
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif ((SV.SkyScenarioBitFlags or {})[73] == 1) then -- elseif ROM: $SCENARIO_MAIN_BIT_FLAG[73]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[73] = 0 -- $SCENARIO_MAIN_BIT_FLAG[73] = 0 (ROM)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[61] = 0 -- $SCENARIO_MAIN_BIT_FLAG[61] = 0 (ROM)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]It's a gift from\n[CN][CS:N]Happiny[CR]!", french="[CN]C'est un cadeau de la part\n[CN]de [CS:N]Ptiravi[CR]!", german="[CN]Es ist ein Präsent von\n[CN][CS:N]Wonneira[CR]!", italian="[CN]È un regalo da parte\n[CN]di [CS:N]Happiny[CR]!", spanish="[CN]¡Es un regalo de\n[CN][CS:N]Happiny[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]There's a message too.", french="[CN]Un message l'accompagne.", german="[CN]Zusammen mit einer Nachricht:", italian="[CN]C'è anche un messaggio.", spanish="[CN]También hay un mensaje."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Thank you for giving me that\n[CN]item the other day.", french="[CN]Merci de m'avoir donné cet objet,\n[CN]l'autre jour.", german="[CN]Danke, dass du mir neulich\n[CN]das Item überlassen hast.", italian="[CN]Grazie per avermi dato\n[CN]quello strumento l'altro giorno.", spanish="[CN]Gracias por darme aquel objeto\n[CN]el otro día."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]If I didn't get that item,\n[CN]I could have ended up being lost.", french="[CN]Si vous ne m'aviez pas donné cet objet\n[CN]j'aurais pu me perdre.", german="[CN]Ohne dieses Item hätte ich\n[CN]leicht verlorengehen können.", italian="[CN]Se non l'avessi ricevuto,\n[CN]avrei rischiato di perdermi.", spanish="[CN]Si no lo hubiera tenido, puede que\n[CN]me hubiera perdido."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]It's not much, but please accept this\n[CN]token of my appreciation.\n--[CS:N]Happiny[CR]", french="[CN]Ce n'est pas grand-chose, mais veuillez\n[CN]accepter ceci en remerciement.\n- [CS:N]Ptiravi[CR]", german="[CN]Es ist nicht viel, aber bitte nimm\n[CN]dies als Zeichen meiner Dankbarkeit.\n-[CS:N]Wonneira[CR]", italian="[CN]Non è molto, ma ti prego di accettare questo\n[CN]come segno di ringraziamento.\n- [CS:N]Happiny[CR] -", spanish="[CN]No es mucho, pero espero que te guste este\n[CN]detalle como muestra de agradecimiento.\n[CN]            -[CS:N]Happiny[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN][hero]\n[CN]gently opens the lid...", french="[CN][hero] ouvre\n[CN]délicatement le couvercle...", german="[CN][hero] öffnet\n[CN]behutsam den Deckel...", italian="[CN][hero] apre\n[CN]lentamente il pacchetto...", spanish="[CN][hero] abre la tapa\n[CN]con cuidado..."})
  -- message_Close
  -- GAP: se_Play(11021) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]Inside was the\n[CN][s_item:0]!", french="[CN]A l'intérieur se trouve l'objet\n[CN][s_item:0]!", german="[CN]Im Paket liegt das Item\n[CN][s_item:0]!", italian="[CN]... e al suo interno trova\n[CN][s_item:0]!", spanish="[CN]¡Había un objeto\n[CN][s_item:0] dentro!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]A warm and fuzzy feeling falls over you...", french="[CN]Que c'est agréable de recevoir un cadeau...", german="[CN]Ein warmes, angenehmes Kribbeln\n[CN]überkommt dich...", italian="[CN]Una dolce sensazione di calore ti investe...", spanish="[CN]Te invade una sensación de calidez..."})
  -- message_Close
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Huh?\nYou've got too many items?", french="Hein?\nVous avez trop d'objets?", german="Hmm...\nDu trägst zu viele Items?", italian="Come?\nHai troppi strumenti, dici?", spanish="Vaya...\nPues tienes demasiados objetos."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Well, I'll hold on to this for you\nfor a while, then.", french="Très bien, alors je vais vous\nmettre ça de côté pour l'instant.", german="Na gut, ich kann es für dich\nnoch einige Zeit aufbewahren.", italian="Beh, allora te lo conserverò io\nper un po'.", spanish="Bueno, entonces te lo guardo\nun tiempo, no te preocupes."})
  -- message_Close
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else
  -- @label_1 [étiquette de flux ExplorerScript]
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- @label_151 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_patchiiru, 4) end)
  -- supervision_ExecuteCommon(CORO_EVENT_S30_07) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 9) >= 0) or (SkyProg.cmp(29, 8) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 9] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_patchiiru, 4) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" Aaaah!", french=" Aaaah!", german=" Aaaah!", italian=" Aaah!", spanish=" ¡Aaaah!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Eureka![K]\nIt sounds good to hear a shout like that, huh?", french="Eurêka![K]\nC'est une douce musique pour les oreilles\nque ce cri de joie, non?", german="Heureka![K]\nDer Ausruf klingt gut, nicht wahr?", italian="Perbacco![K]\nSentire un urlo simile ti dà la carica, eh?", spanish=" ¡Eureka![K] Es genial oír ese grito, ¿eh?"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" Please continue to explore!", french="S'il vous plaît,\ncontinuez à explorer le monde!", german=" Bitte erkundet weiter!", italian=" Continuate a esplorare!", spanish=" ¡Continúa explorando!"})
  -- message_Close
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 6] || scn($SCENARIO_MAIN) >= [29
  -- jump @label_151 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 6] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_patchiiru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Project P is a dream I've had\nfor many years...", french="Le Projet P est un rêve\nque j'entretiens depuis des années...", german="Projekt P ist ein über viele\nJahre gehegter Traum von mir...", italian="Il Progetto P è un sogno che\ncovavo da molti anni...", spanish="Llevo muchos años soñando\ncon el Proyecto P..."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Someday, I know I'll make a huge\ndiscovery that will amaze everyone, all over\nthe world.", french="Un jour, je ferai une découverte\ngigantesque qui éblouira le monde entier.", german="Ich weiß, dass ich eines Tages\neine gewaltige Entdeckung machen werde, die\nalle rund um die Welt erstaunen wird.", italian="Un giorno scoprirò qualcosa\nche lascerà il mondo intero a bocca\naperta per lo stupore.... Ne sono certo!", spanish="Sé que algún día haré un\ndescubrimiento que maraville al mundo entero."})
  -- message_Close
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 3] || scn($SCENARIO_MAIN) >= [8, 
  -- jump @label_151 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 1] || scn($SCENARIO_MAIN) >= [6, 
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_patchiiru, 4) end)
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" ......................................", french=" ......................................", german=" ......................................", italian=" ......................................", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" Hopes and dreams...", french=" Vos rêves se réalisent...", german=" Hoffen und träumen...", italian=" Sogni e speranze...", spanish=" De ensueño..."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" This is...", french=" C'est...", german=" Das ist...", italian=" Questo è...", spanish=" Esto es..."})
  -- message_Close
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
