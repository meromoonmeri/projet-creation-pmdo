-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P17P02A/un0202.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(42, 4) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [42, 4]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_pukurin_mama = SkySceneKit.spawn_npc("wigglytuff", 256, 208, Direction.UpRight, "NPC_PUKURIN_MAMA")
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english="Lately, [CS:N]Smoochum[CR] has come\naround asking for you when you're not home...", french="Dernièrement, [CS:N]Lippouti[CR] est\npassée te voir alors que tu t'étais absenté...", german="Neulich kam [CS:N]Kussilla[CR] vorbei und\nfragte nach dir, als du nicht zu Hause warst...", italian="Ultimamente [CS:N]Smoochum[CR] viene\nsempre a chiedere di te quando non sei\nin casa...", spanish="[CS:Y]Igglybuff[CR], últimamente [CS:N]Smoochum[CR]\nha venido preguntando por ti cuando no estabas\nen casa..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english="Aren't you playing with\n[CS:N]Smoochum[CR] and the others?", french="Tu ne joues pas avec [CS:N]Lippouti[CR]\net les autres?", german="Spielst du nicht immer mit\n[CS:N]Kussilla[CR] und den anderen?", italian="Ma non vai sempre a giocare con\n[CS:N]Smoochum[CR] e gli altri?", spanish="¿Es que ya no juegas con [CS:N]Smoochum[CR] y\nlos demás?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yeah...[K]I'm a bit busy exploring.", french="Euh...[K] Je suis un peu occupé\navec mes explorations.", german="Jaaa...[K] Aber ich bin mit den\nErkundungen recht beschäftigt.", italian="Ehm...[K] Ultimamente vado\nsempre in giro a esplorare.", spanish="Ah...[K] Es que estoy algo ocupado\nexplorando."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" Exploring? [K]With [CS:N]Banette[CR]...?", french="Tes explorations?[K]\nAvec [CS:N]Branette[CR]...?", german=" Erkundungen?[K] Mit [CS:N]Banette[CR]?", italian=" Esplorare?[K] Con [CS:N]Banette[CR]...?", spanish=" ¿Explorando?[K] ¿Con [CS:N]Banette[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english="It's dangerous out there, so don't\ngo too far...", french="C'est dangereux là-bas, alors ne\nt'aventure pas trop loin.", german="Es ist gefährlich da draußen,\nalso gehe nicht zu weit weg...", italian="È pericoloso lì fuori, quindi non\nallontanarti troppo...", spanish="No te vayas demasiado lejos,\nque hay sitios peligrosos, ve con cuidado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep! ♪[K] Got it, [CS:N]Mama[CR]. ♪", french=" Voui! ♪[K] Compris, [CS:N]maman[CR]. ♪", german=" Ja! ♪[K] Verstanden, [CS:N]Mama[CR]. ♪", italian=" Sì! ♪[K] Ho capito, [CS:N]mamma[CR]. ♪", spanish=" ¡Vale! ♪[K] Tranquila, [CS:N]mamá[CR]. ♪"})
  -- message_Close
  -- @label_4 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp_side(41, 6) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [41, 6]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" Be careful out there today.", french=" Sois prudent aujourd'hui.", german=" Sei vorsichtig da draußen.", italian=" Fai attenzione là fuori.", spanish=" Ten cuidado por ahí."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" Don't go anywhere dangerous.", french="Ne va pas te promener dans des\nendroits dangereux.", german=" Bring dich nicht in Gefahr.", italian="Non andare a giocare in posti\npericolosi.", spanish=" No vayas por sitios peligrosos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Yep! ♪[K] I'll be careful,\n[CS:N]Mama[CR]. ♪", french="Voui, voui! ♪[K] Je ferai\nattention, [CS:N]maman[CR]. ♪", german="Ja! ♪[K] Ich pass schon auf,\n[CS:N]Mama[CR]. ♪", italian="Sì! ♪[K] Starò attento,\n[CS:N]mamma[CR]. ♪", spanish=" ¡Sí! ♪[K] Iré con cuidado, [CS:N]mamá[CR]. ♪"})
  -- message_Close
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(41, 3) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [41, 3]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" Be careful, OK?", french=" Fais attention, d'accord?", german=" Sei vorsichtig, okay?", italian=" Stai attento, va bene?", spanish=" Ten cuidado, ¿eh?"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" Come home before it gets dark.", french=" Rentre avant qu'il ne fasse nuit.", german="Komm nach Hause, bevor es\ndunkel wird.", italian="Torna a casa prima che faccia\nbuio.", spanish=" Vuelve antes de que se haga de noche."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep! ♪[K] Got it, [CS:N]Mama[CR]. ♪", french=" Voui! ♪[K] Compris, [CS:N]maman[CR]. ♪", german=" Ja! ♪[K] Schon klar, [CS:N]Mama[CR]. ♪", italian=" Sì! ♪[K] Certo, [CS:N]mamma[CR]. ♪", spanish=" ¡Sí, sí! ♪[K] Tranquila, [CS:N]mamá[CR]. ♪"})
  -- message_Close
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(41, 1) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [41, 1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" Have fun playing, but be careful!", french="Amuse-toi bien,\nmais fais attention!", german="Viel Spaß beim Spielen, aber\nsei vorsichtig!", italian=" Divertiti, ma fai attenzione!", spanish=" Pásatelo bien, pero ten cuidado."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" Come back before it gets dark.", french="Reviens avant la tombée\nde la nuit.", german="Sei zurück, bevor es dunkel\nwird.", italian=" Torna prima di sera.", spanish="Vuelve antes de que se haga\nde noche."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yeah. ♪", french=" Vouais. ♪", german=" Jaaa. ♪", italian=" Sì. ♪", spanish=" Sí, sí. ♪"})
  -- message_Close
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
