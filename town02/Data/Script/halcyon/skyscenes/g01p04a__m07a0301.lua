-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m07a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SkyProg.set(8, 1) -- $SCENARIO_MAIN = scn[8,1] (ROM)
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 152, 304, Direction.UpRight, "NPC_DOGAASU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(484, 252, 1, false) end) -- SetPositionMark performer/caméra
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Ah, you two.", french=" Ah, vous deux.", german=" Ah, ihr zwei.", italian=" Ehi, voi due.", spanish=" Ah, aquí estáis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Your task today is to obtain\nstock to replenish the larder.", french="Votre mission aujourd'hui est de\nremplir notre garde-manger.", german="Eure Aufgabe für heute ist es,\ndie Vorräte für die Speisekammer aufzufüllen.", italian="Oggi il vostro compito è\nfare provvista di cibo.", spanish="Vuestra misión de hoy\nes rellenar nuestra despensa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Larder? You mean, go get\nsome food?", french="Le garde-manger? On doit aller\nchercher de la nourriture?", german="Speisekammer? Du meinst, wir\nsollen etwas zu essen besorgen?", italian=" Cibo? ", spanish="¿La despensa? ¿Nos mandas\nir a buscar comida?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Larder? You mean, go get\nsome food?", french="Le garde-manger? On doit aller\nchercher de la nourriture?", german="Speisekammer? Du meinst, wir\nsollen etwas zu essen besorgen?", italian=" Cibo? ", spanish="¿La despensa? ¿Nos mandas\nir a buscar comida?"})
  else
  SkySceneKit.say({english="Larder? You mean, go get\nsome food?", french="Le garde-manger? On doit aller\nchercher de la nourriture?", german="Speisekammer? Du meinst, wir\nsollen etwas zu essen besorgen?", italian=" Cibo? ", spanish="¿La despensa? ¿Nos mandas\nir a buscar comida?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(456, 240, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 440, 248, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(hero, 472, 248, false, 2)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Correct. ♪", french=" Exact. ♪", german=" Richtig. ♪", italian=" Esatto. ♪", spanish=" Correcto. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We inspected the larder\nthis morning.", french="Nous avons inspecté le\ngarde-manger ce matin...", german="Wir haben heute Morgen die\nSpeisekammer kontrolliert.", italian="Questa mattina abbiamo\nispezionato la dispensa.", spanish="Hemos inspeccionado la despensa\nesta mañana."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="For some mysterious reason, the\nguild's food stock has dropped sharply all\nof a sudden.", french="... et pour une raison\ndes plus mystérieuses, les réserves de\nnourriture de la Guilde ont subitement diminué.", german="Aus irgendeinem mysteriösen\nGrund sind die Vorräte der Gilde plötzlich\ndrastisch geschrumpft.", italian="Per qualche strano motivo,\nle scorte di cibo della Gilda sono diminuite\ntantissimo, così all'improvviso.", spanish="Por alguna misteriosa razón, las\nreservas de comida del [CS:N]Pokégremio[CR] han\nquedado repentinamente bajo mínimos."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Furthermore, our entire stock of\nPerfect Apples has disappeared. That was the\nonly item to get completely cleaned out.", french="De plus, toute la réserve de\nPommes Parfaites s'est évanouie. Nous\nsommes en rupture de stock.", german="Darüber hinaus ist der Vorrat an\nPerfekten Äpfeln verschwunden. Sie sind als\neinziges Item überhaupt nicht mehr auf Lager.", italian="Inoltre, l'intera riserva di Mele\nPerfette è sparita. Si tratta dell'unica cosa\nche è sparita del tutto.", spanish="De hecho, toda nuestra reserva\nde Manzanas Perfectas ha desaparecido.\nEs lo único de lo que no nos queda nada."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Perfect Apples?\nWhat are those?", french="Des Pommes Parfaites?\nQu'est-ce que c'est?", german=" Perfekte Äpfel? Was ist das?", italian=" Mele Perfette? Cosa sono?", spanish="¿Manzanas Perfectas?\n¿Qué es eso?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Perfect Apples?\nWhat are those?", french="Des Pommes Parfaites?\nQu'est-ce que c'est?", german=" Perfekte Äpfel? Was ist das?", italian=" Mele Perfette? Cosa sono?", spanish="¿Manzanas Perfectas?\n¿Qué es eso?"})
  else
  SkySceneKit.say({english="Perfect Apples?\nWhat are those?", french="Des Pommes Parfaites?\nQu'est-ce que c'est?", german=" Perfekte Äpfel? Was ist das?", italian=" Mele Perfette? Cosa sono?", spanish="¿Manzanas Perfectas?\n¿Qué es eso?"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="They're very big and very\ndelicious [CS:I]Apples[CR].", french="Ce sont de grosses [CS:I]Pommes[CR].\nElles sont succulentes.", german="Das sind sehr große und sehr\nschmackhafte [CS:I]Äpfel[CR].", italian="Sono [CS:I]Mele[CR] molto grandi e\nassolutamente squisite.", spanish="Es un tipo de [CS:I]manzana[CR] muy\ngrande y deliciosa."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But more than that, they are\nthe Guildmaster's favorite food! ♪", french="Et c'est aussi le mets\npréféré de notre Maître! ♪", german="Aber nicht nur das! Sie sind auch\ndie Lieblingsspeise des Gildenmeisters! ♪", italian="E sono anche il cibo preferito\ndel Capitano! ♪", spanish="Pero, sobre todo, ¡es el alimento\nfavorito del Gran Bluff! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="If there were no Perfect\nApples, the Guildmaster would, um...", french="Si nous devions tomber à court\nde Pommes Parfaites, le Maître risquerait\nde... euh...", german="Wenn es keine Perfekten Äpfel\ngäbe, würde der Gildenmeister, ähm...", italian="Se non ci fossero Mele Perfette,\nil Capitano, ehm...", spanish="Si no hubiera ninguna Manzana\nPerfecta, el Gran Bluff podría..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" The Guildmaster w-w-would...", french="Le Maître risquerait... euh...\nde...", german=" Der Gildenmeister w-w-würde...", italian=" Il Capitano...", spanish=" El Gran Bluff podría..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" ...erk!", french=" ... Hum, hum!", german=" ...Argh!", italian=" Erk!", spanish=" ¡Ayyy...!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Go on. If there were no Perfect\nApples, what would happen to [CS:N]Wigglytuff[CR]?", french="Continue! S'il n'y a plus de\nPommes Parfaites, que va-t-il arriver à\n[CS:N]Grodoudou[CR]?", german="Was? Was würde mit\n[CS:N]Knuddeluff[CR] passieren, wenn es keine\nPerfekten Äpfel gäbe?", italian="Vai avanti. Cosa succederebbe a\n[CS:N]Wigglytuff[CR] senza Mele Perfette?", spanish="Dínoslo. Si no hubiera ninguna\nManzana Perfecta, ¿qué le ocurriría a\n[CS:N]Wigglytuff[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Go on. If there were no Perfect\nApples, what would happen to [CS:N]Wigglytuff[CR]?", french="Continue! S'il n'y a plus de\nPommes Parfaites, que va-t-il arriver à\n[CS:N]Grodoudou[CR]?", german="Was? Was würde mit\n[CS:N]Knuddeluff[CR] passieren, wenn es keine\nPerfekten Äpfel gäbe?", italian="Vai avanti. Cosa succederebbe a\n[CS:N]Wigglytuff[CR] senza Mele Perfette?", spanish="¿Qué pasaría? Si no hubiera\nninguna Manzana Perfecta, ¿qué le ocurriría\na [CS:N]Wigglytuff[CR]?"})
  else
  SkySceneKit.say({english="Go on. If there were no Perfect\nApples, what would happen to [CS:N]Wigglytuff[CR]?", french="Continue! S'il n'y a plus de\nPommes Parfaites, que va-t-il arriver à\n[CS:N]Grodoudou[CR]?", german="Was? Was würde mit\n[CS:N]Knuddeluff[CR] passieren, wenn es keine\nPerfekten Äpfel gäbe?", italian="Vai avanti. Cosa succederebbe a\n[CS:N]Wigglytuff[CR] senza Mele Perfette?", spanish="Continúa. Si no hubiera ninguna\nManzana Perfecta, ¿qué le ocurriría a\n[CS:N]Wigglytuff[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" The G-Guildmaster would...[K]...[K]...", french=" Le M-m-maître va...[K] va...", german="Der G-Gildenmeister würde...[K]\n... [K]...", italian=" Il C-Capitano...[K]...[K]...", spanish=" El Gran Bluff podría... [K]... [K]..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" ...[K]Yes, that's what would happen.", french="...[K] Eh oui... voilà ce qui\nse passerait.", german=" ...[K]Ja, das würde passieren.", italian=" ...[K] Sì, ecco cosa succederebbe.", spanish=" Sí...[K] Eso es lo que haría."})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="That's why I'm begging you two\nto get some Perfect Apples.", french="C'est pour cela que je vous\nsupplie d'aller chercher des Pommes Parfaites.", german="Darum flehe ich euch an, geht\nund holt Perfekte Äpfel.", italian="È per questo che vi prego di\nandare a cercare delle Mele Perfette.", spanish="Por eso os ruego que consigáis\nalguna Manzana Perfecta."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Uh, what did he just say?![K]\nI didn't hear! It'll drive me nuts, not knowing!", french="Je suis sourd ou quoi...?[K]\nJe n'ai rien entendu! Je crois que j'ai manqué\nun épisode, là.", german="Äh, was hat er gesagt?!?[K]\nIch habe nichts gehört! Es macht mich\nwahnsinnig, so etwas nicht zu wissen!", italian="Eh, cosa ha detto?![K]\nNon ho sentito! Non saperlo mi fa impazzire!", spanish="Pero...[K] ¿qué es lo que ha dicho?\nNo lo he oído. ¡No puedo quedarme sin saberlo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Uh, what did he just say?![K]\nI didn't hear! It'll drive me crazy, not knowing!", french="Je suis sourd ou quoi...?[K]\nJe n'ai rien entendu! Je crois que j'ai manqué\nun épisode, là.", german="Äh, was hat er gesagt?!?[K]\nIch habe nichts gehört! Es wird mich\nverrückt machen, das nicht zu wissen!", italian="Eh, cosa ha detto?![K]\nNon ho sentito! Non saperlo mi fa impazzire!", spanish="¡¿Pero qué es lo que nos\nha dicho?![K] ¡No lo he oído! ¡Necesito\nsaber lo que nos ha dicho!"})
  else
  SkySceneKit.say({english="Uh, what did he just say?![K]\nI didn't hear! It'll really bug me, not knowing!", french="Je suis sourde ou quoi...?[K]\nJe n'ai rien entendu! Je crois que j'ai manqué\nun épisode, là.", german="Äh, was hat er gesagt?!?[K]\nIch habe nichts gehört! Es nervt mich, das\nnicht zu wissen!", italian="Eh, cosa ha detto?![K]\nNon ho sentito! Non saperlo mi fa impazzire!", spanish="¡¿Pero qué es lo que nos\nha dicho?![K] ¡No lo he oído! ¡Necesito saberlo!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But, oh well.", french=" Tant pis.", german=" Nun gut.", italian=" Ma pazienza.", spanish=" Bueno."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But, oh well.", french=" Tant pis.", german=" Nun gut.", italian=" Ma pazienza.", spanish=" Bueno."})
  else
  SkySceneKit.say({english=" But, oh well.", french=" Tant pis.", german=" Nun gut.", italian=" Ma pazienza.", spanish=" Bueno."})
  end
  -- message_KeyWait
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Sure, we'll go get some. You can\ncount on us!", french="Bien sûr qu'on va aller en\nchercher. Tu peux compter sur nous!", german="Natürlich holen wir welche.\nDu kannst auf uns zählen!", italian="Sicuro, andremo a cercarne\nun po'. Conta su di noi!", spanish="Vale, conseguiremos Manzanas\nPerfectas. ¡Puedes contar con nuestra ayuda!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Sure, we'll go get some. You can\ncount on us!", french="Bien sûr qu'on va aller en\nchercher. Tu peux compter sur nous!", german="Natürlich holen wir welche.\nDu kannst auf uns zählen!", italian="Sicuro, andremo a cercarne\nun po'. Conta su di noi!", spanish="Vale, conseguiremos Manzanas\nPerfectas. ¡Puedes contar con nuestra ayuda!"})
  else
  SkySceneKit.say({english="Sure, we'll go get some. You can\ncount on us!", french="Bien sûr qu'on va aller en\nchercher. Tu peux compter sur nous!", german="Natürlich holen wir welche.\nDu kannst auf uns zählen!", italian="Sicuro, andremo a cercarne\nun po'. Conta su di noi!", spanish="Vale, conseguiremos Manzanas\nPerfectas. ¡Puedes contar con nuestra ayuda!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Good! ♪", french=" Bien! ♪", german=" Gut! ♪", italian=" Bene! ♪", spanish=" ¡Estupendo! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Perfect Apples can be found\ndeep in [CS:P]Apple Woods[CR].", french="Vous trouverez des Pommes\nParfaites au cœur du [CS:P]Bois aux Pommes[CR].", german="Ihr findet die Perfekten Äpfel\ntief im [CS:P]Apfelwald[CR].", italian="Le Mele Perfette si trovano\nnel cuore del [CS:P]Giardino dei Meli[CR].", spanish="Podréis encontrar Manzanas\nPerfectas si os adentráis en el [CS:P]Manzanar[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Now, listen, this may seem like\na simple errand, but it's a crucial job.", french="Ecoutez bien, même si cela\nsemble être une simple commission,\nc'est une mission cruciale.", german="Doch Vorsicht! Es hört sich nach\neinem einfachen Auftrag an, aber dieser Job\nist von entscheidender Bedeutung.", italian="So che questa vi potrà sembrare\nuna quisquilia, ma si tratta di una missione\ndi vitale importanza.", spanish="Eso sí, comprended que esto no\nes un simple encargo, sino una misión crucial."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="After all, this is all about the\nGuildmaster's...", french="Il faut tout faire pour éviter\nde fâcher le Maître de la Guilde!", german="Schließlich geht es hier um des\nGildenmeisters...", italian=" In fondo, si tratta del Capitano...", spanish="Después de todo, se trata de\nevitar que el Gran Bluff..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" ...erk!", french=" ... Hum, hum!", german=" ...Argh!", italian=" ... erk!", spanish=" ¡Ayy...!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" ...[K]So please don't fail! ♪", french="...[K] Alors, s'il vous plaît,\nn'échouez pas! ♪", german=" ...[K]Also bitte, versagt nicht! ♪", italian="...[K] Quindi vi prego di non\ntornare a mani vuote! ♪", spanish=" En fin...[K] Así que no falléis. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" OK!", french=" D'accord!", german=" Okay!", italian=" Ok!", spanish=" ¡De acuerdo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK!", french=" D'accord!", german=" Okay!", italian=" Ok!", spanish=" ¡De acuerdo!"})
  else
  SkySceneKit.say({english=" OK!", french=" D'accord!", german=" Okay!", italian=" Ok!", spanish=" ¡De acuerdo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's give it our best,\n[hero]!", french="Faisons de notre mieux,\n[hero]!", german="Geben wir unser Bestes,\n[hero]!", italian="Mettiamocela tutta,\n[hero]!", spanish="¡Esforcémonos al máximo,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's keep doing our best,\n[hero]!", french="Faisons de notre mieux,\n[hero]!", german="Geben wir wie immer unser\nBestes, [hero]!", italian="Mettiamocela tutta,\n[hero]!", spanish="¡Sigamos esforzándonos,\n[hero]!"})
  else
  SkySceneKit.say({english="Let's keep doing our best,\n[hero]!", french="Faisons de notre mieux,\n[hero]!", german="Geben wir wie immer unser\nBestes, [hero]!", italian="Mettiamocela tutta,\n[hero]!", spanish="¡Sigamos esforzándonos,\n[hero]!"})
  end
  -- message_Close
  GROUND:MoveToPosition(partner, 404, 248, false, 2)
  GROUND:MoveToPosition(hero, 404, 248, false, 2)
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  pcall(function() GAME:MoveCamera(180, 240, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 324, 172, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 324, 172, false, 2)
  pcall(function() SOUND:FadeOutBGM(190) end)
  GROUND:MoveToPosition(partner, 324, 92, false, 2)
  GROUND:MoveToPosition(hero, 324, 92, false, 2)
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(180, 284, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Whoa-ho-ho! Looks like they're\ngoing out foraging for food.", french="Mouarf mouarf mouarf!\nOn dirait qu'on les envoie chercher\ndes provisions.", german="Whoahoho! Sieht aus, als\nwürden sie auf Futtersuche gehen.", italian="Uooh-ho-ho! Sembra che stiano\nandando a fare provvista di cibo.", spanish="¡Jo, jo, jo! Parece que van\na tener que ir a buscar comida por ahí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 184, 288, Direction.UpRight, "NPC_SUKATANKU")
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="That's because we feasted last\nnight. A thankless task thanks to us,\nchaw-haw-haw!", french="C'est à cause de notre festin\nd'hier soir. Et une corvée ingrate grâce\nà nous, une! Gnark gnark gnark!", german="Weil wir uns letzte Nacht den\nMagen vollgeschlagen haben! Die undankbare\nAufgabe verdanken sie uns, cha-ha-ha!", italian="Ed è a causa del nostro\nbanchetto di ieri notte. Un compito ingrato\nper colpa nostra, ahr-ahr-ahr.", spanish="Y todo por el festín que nos\ndimos anoche. Les ha caído una buena\npapeleta gracias a nosotros. ¡Jua, jua, jua!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-3, 1) [neutre/état moteur]
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 152, 272, Direction.UpRight, "NPC_ZUBATTO")
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Heh-heh-heh! Let's mess\nwith them!", french="Hin hin hin! On va aller les\nembêter un peu!", german=" Hehehe! Los, machen wir Zoff!", italian="Eh-eh-eh! Vediamo di\ncomplicare le cose!", spanish="¡Jue, jue, jue! ¡Vamos\na complicarles la vida!"})
  -- message_Close
  GAME:FadeOut(false, 60)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[7] = 1 -- dungeon_mode(7) = DMODE_OPEN (ROM)
  -- main_SetGround(LEVEL_G01P02A) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterGround(LEVEL_G01P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
