-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m08a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Oh? Are you all ready for the\nexpedition?", french="Ça y est? Vous avez terminé\nvos préparatifs pour l'expédition?", german="Oh? Sind alle bereit für die\nExpedition?", italian="Allora? È tutto pronto per la\nspedizione?", spanish="¿Ah? ¿Lo tenéis todo\npara la expedición?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The expedition will be a long\njourney. You should be stocked up on items.\nAre you all ready to go?", french="L'expédition sera un long voyage.\nVous devriez prendre le maximum d'objets\navec vous. Avez-vous tout ce qu'il vous faut?", german="Diese Expedition wird eine lange\nReise sein. Ihr solltet ausreichend Items dabei\nhaben. Seid ihr bereit?", italian="La spedizione sarà lunga.\nDovreste fare provvista di strumenti.\nÈ davvero tutto pronto?", spanish="La expedición será un viaje\nmuy largo. Os conviene llevar todos los\nobjetos que necesitéis. ¿Todo listo?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Incidentally...", french="Au fait, au cas où vous l'auriez\noublié...", german=" Übrigens...", italian=" Tra l'altro...", spanish=" Y por cierto..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You may not bring members of\nyour team that aren't members of the guild.\nUnderstood?", french="... vous n'avez pas le droit\nd'emmener des coéquipiers qui ne sont pas\nmembres de la Guilde. Compris?", german="Ihr dürft keine Team-Mitglieder\nmitnehmen, die keine Gildenmitglieder sind.\nVerstanden?", italian="... non potete portare membri\ndella vostra squadra che non facciano parte\ndella Gilda. Capito?", spanish="No os pueden acompañar\nmiembros del equipo que no formen\nparte del [CS:N]Pokégremio[CR]. ¿Entendido?"})
  do local __choice = SkySceneKit.ask({{english="I know!", french="Oui!", german="Ja", italian="Sì!", spanish="Sí, claro. Si ya lo sabía..."}, {english="I didn't know...", french="Non...", german="Nein", italian="No...", spanish="Pues no tenía ni idea..."}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It's quite apparent that someone\nfailed to pay attention to me...", french="De toute évidence, vous ne\nm'avez pas écouté...", german="Offensichtlich hat mir jemand\nnicht richtig zugehört.", italian="Sembra che qualche apprendista\nnon abbia ascoltato le mie parole...", spanish="Vaya, es evidente que alguien no\nme ha estado prestando atención..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The situation being what it is,\nI shall explain again.", french="Dans ce cas, je me vois dans\nl'obligation de vous expliquer encore une fois.", german="Wie es aussieht, muss ich es\nnoch einmal erklären.", italian="Visto come stanno le cose,\nve lo spiegherò di nuovo.", spanish="Por lo que veo tendré que\nexplicároslo de nuevo."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You may not bring members of\nyour team that are not members of the guild.", french="Vous ne pouvez pas emmener\nde coéquipiers qui ne font pas partie\nde la Guilde.", german="Ihr dürft keine Mitglieder aus\neurem Team mitnehmen, die keine Mitglieder\nder Gilde sind.", italian="Non potete portare con voi\nmembri della vostra squadra che non facciano\nparte della Gilda.", spanish="No os pueden acompañar\nmiembros del equipo que no formen\nparte del [CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Keeping that in mind, you should\ncomplete your preparations.", french="Pensez-y en finissant de vous\npréparer!", german="Vergesst das nicht, während ihr\neure Vorbereitungen trefft.", italian="Tenetelo a mente, mentre finite\ndi prepararvi.", spanish="Teniendo eso en cuenta,\nhaced los preparativos que necesitéis."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Understood. ♪", french=" Compris? ♪", german=" Verstanden? ♪", italian=" Capito. ♪", spanish=" Entendido. ♪"})
  -- message_Close
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_ExecuteCommon(CORO_EVENT_M08_05_06) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_1 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="What, not yet?[K] Get moving and\nget ready.", french="Quoi, pas encore?[K] Remuez-vous\net préparez-vous!", german="Was, noch nicht?[K] Beeilt euch und\ngeht euch vorbereiten.", italian="Cosa, non ancora?[K]\nDatevi una mossa!", spanish="¿Cómo, todavía no?[K]\n¡Venga, preparaos ya!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The other apprentices should be\ngetting their stocks of items ready too.", french="Les autres apprentis auront\nbientôt fini de faire le plein d'objets.", german="Die anderen Lehrlinge sollten\nihren Vorrat an Items auch aufstocken.", italian="Anche gli altri apprendisti\nstaranno facendo provvista di strumenti.", spanish="Los demás aprendices deben de\nestar preparando todas sus cosas para el viaje."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="When you're done preparing for\nthe expedition, report to me. ♪", french="Quand vous aurez terminé vos\npréparatifs pour l'expédition, faites-le-moi\nsavoir. ♪", german="Wenn ihr mit den Vorbereitungen\nfertig seid, meldet euch bei mir. ♪", italian="Quando avete terminato i\npreparativi, venite da me. ♪", spanish="Venid a hablar conmigo en cuanto\nlo tengáis todo preparado. ♪"})
  -- message_Close
  -- @label_4 [étiquette de flux ExplorerScript]
  end
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
