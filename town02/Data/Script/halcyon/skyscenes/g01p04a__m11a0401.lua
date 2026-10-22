-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m11a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  SkyProg.set(12, 3) -- $SCENARIO_MAIN = scn[12,3] (ROM)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- supervision_Acting(0) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(484, 252, 1, false) end) -- SetPositionMark performer/caméra
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Oh! You two!", french=" Oh! Vous autres!", german=" Oh! Ihr zwei!", italian=" Ehi! Voi due!", spanish=" ¡Ah! ¡Aquí estáis!"})
  -- message_Close
  GROUND:EntTurn(partner, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(16), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Before you get to work today...", french="Avant de vous mettre au\ntravail aujourd'hui...", german="Bevor ihr heute mit eurer\nArbeit beginnt...", italian="Prima che vi mettiate al lavoro,\noggi...", spanish="Antes de que os pongáis a\ntrabajar hoy..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" I'd like you to run an errand.", french=" J'ai une course à vous confier.", german="Ich möchte, dass ihr noch eine\nBesorgung macht.", italian="... avrei bisogno che svolgeste\nuna commissione per me.", spanish=" Me gustaría haceros un encargo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" An errand?", french=" Une course?", german=" Eine Besorgung?", italian=" Una commissione?", spanish=" ¿Un encargo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" An errand?", french=" Une course?", german=" Eine Besorgung?", italian=" Una commissione?", spanish=" ¿Un encargo?"})
  else
  SkySceneKit.say({english=" An errand?", french=" Une course?", german=" Eine Besorgung?", italian=" Una commissione?", spanish=" ¿Un encargo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Yes, an errand!", french=" Oui, une course!", german=" Ja, eine Besorgung!", italian=" Proprio così!", spanish=" Sí, un encargo."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Go to [CS:K]Kecleon[CR] Market. Ask the\nowners if they plan to stock Perfect Apples.", french="Allez au [CS:K]Marché Kecleon[CR].\nDemandez aux propriétaires s'ils comptent\nmettre en rayon des Pommes Parfaites.", german="Geht zum [CS:K]Kecleon-Markt[CR] und\nfragt die Besitzer, ob sie vorhaben, Perfekte\nÄpfel in ihr Sortiment aufzunehmen.", italian="Andate al [CS:K]Kecleon[CR] Market e\nchiedete se hanno intenzione di tenere in\nnegozio le Mele Perfette.", spanish="Id al [CS:K]Bazar Kecleon[CR] y preguntad\na sus dueños si tienen previsto vender\nManzanas Perfectas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You want us to ask if they'll\nstock Perfect Apples?", french="Tu veux qu'on leur demande\ns'ils comptent mettre en rayon des Pommes\nParfaites?", german="Wir sollen fragen, ob sie\nPerfekte Äpfel ins Sortiment aufnehmen\nwollen?", italian=" Vuoi che andiamo a chiedere...", spanish="¿Quieres que preguntemos si\npiensan vender Manzanas Perfectas?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You want us to ask if they'll\nstock Perfect Apples?", french="Tu veux qu'on leur demande\ns'ils comptent mettre en rayon des Pommes\nParfaites?", german="Wir sollen fragen, ob sie\nPerfekte Äpfel ins Sortiment aufnehmen\nwollen?", italian=" Vuoi che andiamo a chiedere...", spanish="¿Quieres que preguntemos si\npiensan vender Manzanas Perfectas?"})
  else
  SkySceneKit.say({english="You want us to ask if they'll\nstock Perfect Apples?", french="Tu veux qu'on leur demande\ns'ils comptent mettre en rayon des Pommes\nParfaites?", german="Wir sollen fragen, ob sie\nPerfekte Äpfel ins Sortiment aufnehmen\nwollen?", italian=" Vuoi che andiamo a chiedere...", spanish="¿Quieres que preguntemos si\npiensan vender Manzanas Perfectas?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="At [CS:K]Kecleon[CR] Market? We should\nfind out if they plan to sell Perfect Apples?", french="Au [CS:K]Marché Kecleon[CR]? On doit\nleur demander s'ils comptent vendre des\nPommes Parfaites?", german="Beim [CS:K]Kecleon-Markt[CR]?\nWir sollen herausfinden, ob sie Perfekte Äpfel\nverkaufen wollen?", italian="... se al [CS:K]Kecleon[CR] Market hanno\nintenzione di ordinare delle Mele Perfette?", spanish="¿Tenemos que averiguar si\npiensan vender Manzanas Perfectas\nen el [CS:K]Bazar Kecleon[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="At [CS:K]Kecleon[CR] Market? We should\nfind out if they plan to sell Perfect Apples?", french="Au [CS:K]Marché Kecleon[CR]? On doit\nleur demander s'ils comptent vendre des\nPommes Parfaites?", german="Beim [CS:K]Kecleon-Markt[CR]?\nWir sollen herausfinden, ob sie Perfekte Äpfel\nverkaufen wollen?", italian="... se al [CS:K]Kecleon[CR] Market hanno\nintenzione di ordinare delle Mele Perfette?", spanish="¿Tenemos que averiguar si\npiensan vender Manzanas Perfectas\nen el [CS:K]Bazar Kecleon[CR]?"})
  else
  SkySceneKit.say({english="At [CS:K]Kecleon[CR] Market? We should\nfind out if they plan to sell Perfect Apples?", french="Au [CS:K]Marché Kecleon[CR]? On doit\nleur demander s'ils comptent vendre des\nPommes Parfaites?", german="Beim [CS:K]Kecleon-Markt[CR]?\nWir sollen herausfinden, ob sie Perfekte Äpfel\nverkaufen wollen?", italian="... se al [CS:K]Kecleon[CR] Market hanno\nintenzione di ordinare delle Mele Perfette?", spanish="¿Tenemos que averiguar si\npiensan vender Manzanas Perfectas\nen el [CS:K]Bazar Kecleon[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Correct.", french=" Exact.", german=" Richtig.", italian=" Precisamente.", spanish=" Correcto."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The guild's storage holds many\nPerfect Apples.[K] Or at least it can...", french="Le grenier de la Guilde contient\nbeaucoup de Pommes Parfaites.[K] Du moins,\nil peut en contenir beaucoup...", german="Der Gildenspeicher fasst\nreichlich Perfekte Äpfel.[K] Zumindest wäre\ngenug Platz...", italian="Nel magazzino della Gilda ci sono\nmolte Mele Perfette...[K] in teoria...", spanish="La despensa del [CS:N]Pokégremio[CR] está\nbien provista de Manzanas Perfectas.[K]\nAl menos en teoría..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But the Guildmaster raids the\nstorage when we're not looking and uses up\nour supply.", french="Mais, dès qu'on a le dos tourné,\nle Maître pille la réserve et dévore tout.", german="Doch der Gildenmeister plündert\ndie Vorräte heimlich, wenn niemand hinsieht.", italian="Tuttavia, i frequenti spuntini del\nCapitano stanno esaurendo le nostre scorte!", spanish="Pero en cuanto nos descuidamos\nel Gran Bluff se cuela en la despensa y\narrambla con nuestras provisiones."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And you know what happens if\nthe Guildmaster is deprived of his Perfect\nApples!", french="Et vous savez ce qui se passe\nquand le Maître est privé de ses Pommes\nParfaites!", german="Und ihr wisst, was passiert,\nwenn der Gildenmeister ohne Perfekte Äpfel\nauskommen muss!", italian="E se il nostro Capitano venisse\nprivato delle sue adorate Mele Perfette...\nNon voglio nemmeno pensarci!", spanish="¡Y ya sabéis lo que pasa si\nel Gran Bluff se queda sin sus Manzanas\nPerfectas!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But having to search for a fresh\nload of them is always a chore.", french="Mais c'est toujours une corvée\ningrate de se réapprovisionner.", german="Aber eine frische Ladung zu\nbesorgen, ist jedes Mal wieder eine Schufterei.", italian="È difficile trovarne sempre una\nbella quantità.", spanish="Lo malo es que tener que salir a\nbuscarlas resulta una gran carga."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Sending an exploration team to\n[CS:P]Apple Woods[CR] when the supply runs out is just\ntoo much work.", french="On ne peut pas se permettre\nd'envoyer une équipe d'exploration au [CS:P]Bois aux\nPommes[CR] dès que les réserves sont épuisées.", german="Ständig Erkundungsteams in den\n[CS:P]Apfelwald[CR] zu schicken, wenn der Vorrat alle\nist... Das ist einfach zu viel Arbeit.", italian="Inviare una squadra nel [CS:P]Giardino[CR]\n[CS:P]dei Meli[CR] ogni volta che si esaurisce la scorta\nè un lavoro troppo pesante!", spanish="Mandar un equipo de exploración\nal [CS:P]Manzanar[CR] cada vez que se agotan\nlas provisiones supone demasiado esfuerzo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Gotcha! So, if [CS:K]Kecleon[CR] Market\nstarted stocking Perfect Apples, we could just\ngo buy them!", french="Pigé! Alors s'ils se mettaient à\nvendre des Pommes Parfaites au [CS:K]Marché\nKecleon[CR], il suffirait d'aller en acheter!", german="Ach so! Wenn der [CS:K]Kecleon-Markt[CR]\nPerfekte Äpfel im Sortiment hätte, könnten\nwir sie einfach dort kaufen!", italian="Ci sono! Se convincessimo il\n[CS:K]Kecleon[CR] Market a metterle in catalogo,\npotremmo comprarle da loro!", spanish="¡Ya lo entiendo! Entonces, si\nel [CS:K]Bazar Kecleon[CR] vendiera Manzanas Perfectas,\n¡solo tendríamos que ir a comprarlas!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So, if [CS:K]Kecleon[CR] Market started\nstocking Perfect Apples, we could go buy them!", french="Pigé! Alors s'ils se mettaient à\nvendre des Pommes Parfaites au [CS:K]Marché\nKecleon[CR], il suffirait d'aller en acheter!", german="Wenn also der [CS:K]Kecleon-Markt[CR]\nPerfekte Äpfel im Sortiment hätte, könnten\nwir sie dort kaufen!", italian="Ho capito! Se riuscissimo a\nconvincere il [CS:K]Kecleon[CR] Market a metterle in\ncatalogo, potremmo comprarle da loro!", spanish="¡Ya lo entiendo! Entonces, si\nel [CS:K]Bazar Kecleon[CR] vendiera Manzanas Perfectas,\n¡solo tendríamos que ir a comprarlas!"})
  else
  SkySceneKit.say({english="So, if [CS:K]Kecleon[CR] Market started\nstocking Perfect Apples, we could go buy them!", french="Pigé! Alors s'ils se mettaient à\nvendre des Pommes Parfaites au [CS:K]Marché\nKecleon[CR], il suffirait d'aller en acheter!", german="Wenn also der [CS:K]Kecleon-Markt[CR]\nPerfekte Äpfel im Sortiment hätte, könnten\nwir sie dort kaufen!", italian="Ho capito! Se riuscissimo a\nconvincere il [CS:K]Kecleon[CR] Market a metterle in\ncatalogo, potremmo comprarle da loro!", spanish="¡Ya lo entiendo! Entonces, si\nel [CS:K]Bazar Kecleon[CR] vendiera Manzanas Perfectas,\n¡solo tendríamos que ir a comprarlas!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(44) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Precisely!", french=" Précisément!", german=" Sehr richtig!", italian=" Esattamente!", spanish=" Exacto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Gotcha.[K] We'll go visit the\n[CS:K]Kecleon[CR] brothers at their market.", french="Entendu.[K] On va aller faire\nun tour au [CS:K]Marché Kecleon[CR].", german="Alles klar.[K] Wir werden die\nBrüder [CS:K]Kecleon[CR] in ihrem Markt besuchen.", italian="Ricevuto![K] Andremo a fare una\nvisita ai fratelli [CS:K]Kecleon[CR].", spanish="Vale.[K] Nos pasaremos por\nel [CS:K]Bazar Kecleon[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="OK.[K] We'll go visit the [CS:K]Kecleon[CR]\nMarket.", french="Entendu.[K] On va aller faire\nun tour au [CS:K]Marché Kecleon[CR].", german="Okay.[K] Wir machen uns auf den\nWeg zum [CS:K]Kecleon-Markt[CR].", italian="D'accordo.[K] Andremo a dare\nun'occhiata al [CS:K]Kecleon[CR] Market.", spanish="De acuerdo.[K] Iremos al\n[CS:K]Bazar Kecleon[CR]."})
  else
  SkySceneKit.say({english="Gotcha.[K] We'll go visit the\n[CS:K]Kecleon[CR] Market.", french="Entendu.[K] On va aller faire\nun tour au [CS:K]Marché Kecleon[CR].", german="Alles klar.[K] Wir machen uns auf\nden Weg zum [CS:K]Kecleon-Markt[CR].", italian="D'accordo.[K] Andremo a dare\nun'occhiata al [CS:K]Kecleon[CR] Market.", spanish="Comprendido.[K] Iremos\nal [CS:K]Bazar Kecleon[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Great! Way to take charge! ♪", french="Parfait! Voilà une attitude qui\nme plaît! ♪", german="Großartig! Das wäre also\nerledigt! ♪", italian=" Perfetto! Così vi voglio!", spanish=" ¡Estupendo! ¡Así se habla! ♪"})
  -- message_Close
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.cleanup_npcs()
end
