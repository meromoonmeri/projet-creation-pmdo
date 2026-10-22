-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/um0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Up, "NPC_DOGOOMU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="HEY! It's you two![K] Came to visit\nyour old friends at the guild?", french="HEP LA! C'est vous![K] Alors\ncomme ça, on vient rendre visite\nà ses vieux potes de la Guilde?", german="HEY! Ihr zwei seid es![K] Seid ihr\ngekommen, um eure alten Freunde in der Gilde\nzu besuchen?", italian="EHI! Voi due![K] Siete qui per\nsalutare i vecchi amici della Gilda?", spanish="¡Eh, pareja![K] ¿Venís a visitar\na los viejos amigos?"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="WHAT?[K] You want to pull sentry\nduty and earn some money?", french="QUOI?[K] Vous voulez gagner\nde l'argent en montant la garde?", german="WAS?[K] Ihr wollt Wache schieben\nund ein wenig Geld verdienen?", italian="COSA?[K] Volete fare il turno di\nguardia per guadagnare un po' di soldi?", spanish="¿Qué?[K] ¿Que queréis hacer de\nvigías y ganaros un dinerillo?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}, {english="Check High Score", french="Meilleur score", german="Highscore prüfen", italian="Guarda i record", spanish="Puntuaciones"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Oh, you won't, HUH?", french=" Ah, vous voulez pas, HEIN?", german=" Aha, ihr wollt nicht, WIE?!?", italian=" Ah, non volete, EH?", spanish=" Vaya... No queréis, ¿eh?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- jump @label_133 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  -- @label_134 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- screen2_FadeOut [sub déjà caché]
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_HA_MIHARIBAN) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_133 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(message_Menu(MENU_GUILD_MINI_GAME_SCOREBOARD)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" GO for it, you two!", french=" Au boulot, vous deux!", german=" HALTET euch ran, ihr zwei!", italian=" FORZA, voi due!", spanish=" ¡Manos a la obra, pareja!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="WHAT?[K] You'd rather go on\nsentry duty?", french="QUOI?[K] Vous préférez monter\nla garde?", german="WAS?[K] Ihr wollt lieber zum\nWachdienst antreten?", italian="COSA?[K] Volete fare un turno di\nguardia?", spanish="¿Qué?[K] ¿Que preferís hacer de\nvigías?"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="That's fine, I suppose.[K] Do a good\njob if you're gonna volunteer, you two.", french="Moi, ça ne me dérange pas,\nhein.[K] Faites du bon boulot si vous vous\nportez volontaires pour le faire.", german="Das ist in Ordnung, denke ich.[K]\nWenn ihr euch freiwillig meldet, dann strengt\neuch auch an, ihr zwei.", italian="Va bene, suppongo.[K] Visto che vi\noffrite spontaneamente, almeno fate un buon\nlavoro!", spanish="Está bien.[K] Más vale que hagáis\nun buen trabajo."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Will you go on sentry duty?", french="Alors, vous voulez monter\nla garde?", german="Werdet ihr zum Wachdienst\nantreten?", italian=" Volete fare il turno di guardia?", spanish=" ¿Vais a hacer de vigías?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}, {english="Check High Score", french="Meilleur score", german="Highscore prüfen", italian="Guarda i record", spanish="Puntuaciones"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Oh, you won't, HUH?", french=" Ah, vous voulez pas, HEIN?", german=" Aha, ihr wollt nicht, WIE?!?", italian=" Ah, non volete, EH?", spanish=" Vaya... No queréis, ¿eh?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- jump @label_133 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  -- jump @label_134 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="So did you two learn ANYTHING\nabout the distortion of space?", french="Alors, est-ce que vous avez\nappris QUOI QUE CE SOIT à propos de la\ndistorsion spatiale?", german="Habt ihr IRGENDETWAS über die\nRaumkrümmung in Erfahrung gebracht?", italian="Allora, avete scoperto QUALCOSA\nsulla distorsione dello spazio?", spanish="¿Os habéis enterado ya de algo\nsobre la deformación del espacio?"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="WHAT?[K] You'd rather not talk\nabout it? You'd rather go on sentry duty?", french="QUOI?[K] Vous préférez ne rien\ndire? Vous préférez monter la garde?", german="WAS?[K] Ihr wollt lieber nicht\ndarüber sprechen? Ihr wollt lieber zum\nWachdienst antreten?", italian="COSA?[K] Preferite non parlarne?\nPreferite fare il turno di guardia?", spanish="¿Qué?[K] ¿Que no queréis hablar de\nello? ¿Que preferís hacer de vigías?"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="That's fine, I suppose.[K] Do a good\njob if you're gonna volunteer, you two.", french="Moi, ça ne me dérange pas,\nhein.[K] Faites du bon boulot si vous vous\nportez volontaires pour le faire.", german="Das ist in Ordnung, denke ich.[K]\nWenn ihr euch freiwillig meldet, dann strengt\neuch auch an, ihr zwei.", italian="Va bene, suppongo.[K] Visto che vi\noffrite spontaneamente, almeno fate un buon\nlavoro!", spanish="Está bien.[K] Más vale que hagáis\nun buen trabajo."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Will you go on sentry duty?", french="Alors, vous voulez monter\nla garde?", german="Werdet ihr zum Wachdienst\nantreten?", italian=" Volete fare il turno di guardia?", spanish=" ¿Vais a hacer de vigías?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}, {english="Check High Score", french="Meilleur score", german="Highscore prüfen", italian="Guarda i record", spanish="Puntuaciones"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Oh, you won't, HUH?", french=" Ah, vous voulez pas, HEIN?", german=" Aha, ihr wollt nicht, WIE?!?", italian=" Ah, non volete, EH?", spanish=" Vaya... No queréis, ¿eh?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- jump @label_133 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  -- jump @label_134 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 76) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 76]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="I don't know what you're in for.\nI mean...exploring a dream! Imagine that![K]\nYou dig down deep and TOUGH IT OUT!", french="Je me demande bien ce qui vous\ny attend. C'est vrai, quoi! Explorer un rêve!\nC'est incroyable![K] Allez-y et TENEZ BON!", german="Keine Ahnung, was euch\nerwartet... Eine Traumerkundung![K] Sucht\ngründlich und STEHT DAS DURCH!", italian="Non so cosa vogliate fare. Voglio\ndire... esplorare un sogno! Accipicchia![K]\nAndate là dentro e DATE IL MEGLIO!", spanish="A saber lo que os espera, porque\neso de explorar un sueño...[K] ¡es tremendo!\n¡Meteos ahí dentro y resolvedlo todo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 75) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 75]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="WELL?[K] Can you go into that\nkid's dream?", french="ALORS?[K] Est-ce que vous\npouvez entrer dans le rêve du petit?", german="NUN?[K] Könnt ihr euch in den\nTraum des Kleinen begeben?", italian="EBBENE?[K] Potete entrare nel\nsogno del piccolo?", spanish="¿Y bien?[K] ¿Podéis entrar en el\nsueño del pequeño Pokémon?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 73] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="I'm worried about that little\n[CS:N]Azurill[CR]...", french="Je m'inquiète pour le\npetit [CS:N]Azurill[CR]...", german="Ich mache mir Sorgen um den\nkleinen [CS:N]Azurill[CR]...", italian="Sono in ansia per quel piccolo\n[CS:N]Azurill[CR]...", spanish="Me preocupa el pobre\n[CS:N]Azurill[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="WHAT?[K] You're volunteering for\nsentry duty now?", french="QUOI?[K] Vous vous portez\nvolontaires pour monter la garde?", german="WAS?[K] Ihr tretet jetzt freiwillig\nzum Wachdienst an?", italian="COSA?[K] Vi offrite per il turno di\nguardia?", spanish="¿Qué?[K] ¿Queréis pasar el rato\nen el puesto de vigía?"})
  -- message_KeyWait
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="This is HARDLY the time for\nthat, you two!", french="C'est VRAIMENT pas le moment\npour un truc pareil, vous deux!", german="Dies ist wohl KAUM der richtige\nZeitpunkt dafür, ihr zwei!", italian=" Non è QUESTO il momento!", spanish="¡Ahora no es momento para\neso, pareja!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 71] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="HEY, I heard you two solved the\nmysteries of [CS:P]Aegis Cave[CR].[K] IMPRESSIVE!", french="Hé, à ce qu'il paraît, vous avez\npercé le mystère de la [CS:P]Grotte Egide[CR].[K]\nSUPER BALAISE!", german="HEY, ich habe gehört, dass ihr\nzwei die Geheimnisse um die [CS:P]Ägishöhle[CR]\ngelüftet habt.[K] BEEINDRUCKEND!", italian="EHI, ho sentito che avete risolto\ni misteri della [CS:P]Grotta Egida[CR].[K] FORMIDABILE!", spanish="He oído que habéis resuelto los\nmisterios de la [CS:P]Cueva Regia[CR].[K] ¡Impresionante!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Huh?[K] ...Say WHAT?[K] You want to\nearn some money pulling sentry duty?", french="Hein?[K] ... QUOI?[K] Vous voulez\nqu'on vous paye pour monter la garde?", german="Wie?[K] ...WAS sagt ihr?[K] Ihr wollt\netwas Geld beim Wachdienst verdienen?", italian="Eh?[K] COSA dite?[K] Volete\nguadagnare un po' di soldi facendo la guardia?", spanish="¿Qué?[K] ¿Queréis sacaros un\ndinerillo trabajando de vigías?"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Here you are, famous explorers\nand all, but you want to pull sentry duty?[K]\nI can't say I understand why.", french="Vous, de célèbres explorateurs\net tout et tout, vous voulez monter la garde?[K]\nMoi je dis, je vous comprends pas.", german="Nun seid ihr berühmte Erkunder\nund so weiter, und trotzdem wollt ihr\nWachdienst schieben?[K] Verstehe ich nicht...", italian="Voi, che avete esplorato il mondo\nin lungo e in largo, volete fare il turno di\nguardia?[K] Non posso certo dire che vi capisco.", spanish="Os habéis ganado cierta fama...\n¿y aun así queréis hacer de vigías?[K] No lo\nentiendo, la verdad."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Whatever.[K] So you want to go on\nsentry duty?", french="Enfin, comme vous voulez,\nhein.[K] Alors, vous voulez monter la garde?", german="Wie auch immer.[K] Ihr wollt also\nden Wachdienst antreten?", italian="Comunque...[K] Volete stare\ndi guardia?", spanish="Como queráis.[K] ¿Vais a aceptar\nla tarea de vigía?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}, {english="Check High Score", french="Meilleur score", german="Highscore prüfen", italian="Guarda i record", spanish="Puntuaciones"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Oh, you won't, HUH?", french="Oh, finalement, vous voulez\npas, HEIN?", german=" Aha, ihr wollt nicht, WIE?!?", italian=" Ah, non volete, EH?", spanish=" Vaya... No queréis, ¿eh?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- jump @label_133 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  -- jump @label_134 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 56) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="WHOOOOAH![K] I'd gone off to that\n[CS:P]Aegis Cave[CR]...", french="WOUAAAAH![K] Je suis allé dans\nla [CS:P]Grotte Egide[CR]...", german="WUUUUAH![K] Ich bin zu dieser\n[CS:P]Ägishöhle[CR] gegangen...", italian="WOOOOOW![K] Sono andato alla\n[CS:P]Grotta Egida[CR]...", spanish="¡Aaah![K] Yo ya he estado en la\n[CS:P]Cueva Regia[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="I'll be honest with you. That\nplace made NO SENSE at all!", french="Tu veux que je sois honnête\navec toi? Cet endroit, ça veut CARREMENT\nrien dire!", german="Ich werde ehrlich zu dir sein.\nDieser Ort ergibt einfach KEINEN SINN!", italian="Sarò onesto con voi. Quel posto\nera veramente ASSURDO!", spanish="Para seros sincero, ese lugar\nes una locura."})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="I wandered around in a circle\nin the same area OVER AND OVER...", french="J'ai tourné en rond dans\nla même salle pendant des PLOMBES...", german="Ich bin IMMER UND IMMER\nWIEDER in derselben Gegend im Kreis\ngelaufen...", italian="Ho girato in tondo nella stessa\nzona PER ORE...", spanish="Estuve andando en círculos\nuna y otra vez, sin parar..."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="No one would come rescue me\nwhen I had an accident...", french="J'ai eu un accident et il y avait\nPERSONNE pour venir me secourir...", german="Niemand wollte mich retten\nkommen als ich verunglückte...", italian="E nessuno sarebbe venuto a\nsoccorrermi se avessi avuto un incidente...", spanish="Y nadie vino a rescatarme\ncuando sufrí un accidente..."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="That place...[K] What WAS that\nall about?", french="Cet endroit...[K] J'ai vraiment\nRIEN compris!", german="Dieser Ort...[K] Um WAS handelte\nes sich da?", italian="Quel posto...[K] Che cos'era\nQUEL POSTO?", spanish=" Ese lugar...[K] ¿De qué se trataba?"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" ...Huff...puff...", french=" ... Hmpff... hmpff...", german=" ...Keuch... Schnauf...", italian=" Uff... Puff...", spanish=" Uf..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 55]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" WHOOOOAH!", french=" WOUAAAAH!", german=" WUUUUAH!", italian=" OOOOOH!", spanish=" ¡Aaah!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="I can...[K]go explore with the\nAWESOME celebs of Team [CS:X]Charm[CR]...", french="Je vais pouvoir...[K] partir\nen exploration avec les SUPERSTARS\nde l'Equipe [CS:X]Charme[CR]...", german="Ich kann[K] auf Erkundung gehen\nmit den FANTASTISCHEN Größen von\nTeam [CS:X]Charme[CR]...", italian="Posso...[K] andare a esplorare con\nil famoso e FANTASTICO Team [CS:X]Malia[CR]...", spanish="Puedo...[K] ir a explorar con las\nfamosas integrantes del [CS:X]Equipo Carisma[CR]..."})
  -- message_KeyWait
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" It's like a...[K]DREAM!", french="Pincez-moi, j'ai l'impression\nde...[K] REVER!", german=" Es ist wie ein...[K] TRAUM!", italian=" È un...[K] SOGNO!", spanish=" Es como...[K] ¡un sueño!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(5)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" ...What?[K] Sentry duty?", french=" ... Quoi?[K] Tour de garde?", german=" ...Was?[K] Wachdienst?", italian=" Cosa?[K] Turno di guardia?", spanish=" ¿Qué?[K] ¿De vigías?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Who gives a YIPPEE-KI-YAY?\nThis is WAY more important!", french="Mais on s'en CONTREFICHE!\nÇa, c'est BIEN PLUS important!", german="Wen interessiert das schon?\nDas hier ist VIEL wichtiger!", italian="A chi importa un bel nulla?\nQuesto è più importante!", spanish="¿Y qué más da eso? ¡Esto es\nmucho más importante!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Oh! HEY, you two![K] Came to visit\nus, did you?", french="Oh! Hé, VOUS DEUX![K] Vous venez\nnous rendre visite, pas vrai?", german="Oh! HEY, ihr zwei![K] Ihr seid\ngekommen, um uns zu besuchen, nicht wahr?", italian="Oh! EHI, voi due![K] Siete qui per\nfarci visita?", spanish="¡Eh, pareja![K] Venís de visita,\n¿no?"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="...WHAT?[K] You want to earn\nsome money pulling sentry duty?", french="... QUOI?[K] Vous voulez qu'on vous\npaye pour monter la garde?", german="...WAS?[K] Ihr wollt euch mit\ndem Wachdienst etwas Geld verdienen?", italian="COSA?[K] Volete guadagnare\nun po' di soldi facendo il turno di guardia?", spanish="¿Qué?[K] ¿Queréis sacaros\nun dinerillo trabajando de vigías?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}, {english="Check High Score", french="Meilleur score", german="Highscore prüfen", italian="Guarda i record", spanish="Puntuaciones"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Oh, you won't, HUH?", french=" Ah, non, HEIN?", german=" Aha, ihr wollt nicht, WIE?!?", italian=" Ah, non volete, EH?", spanish=" Vaya... No queréis, ¿eh?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 3 then
  -- jump @label_133 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  -- jump @label_134 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 3] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="That...?[K] Thinking about it\neven now...", french=" Quoi...?[K] Rien que d'y penser...", german="Das...[K] Selbst jetzt darüber\nnachzudenken...", italian="Quel...?[K] Ci stavo proprio\npensando...", spanish="¿Qué?[K] Con solo pensarlo...\nincluso ahora..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" WAAAAH!", french=" WOUAAAAAH!", german=" WAAAAH!", italian=" AAAAH!", spanish=" ¡Aaaah!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" It's all on YOU now!", french="Tout dépend de VOUS,\nmaintenant!", german=" Es liegt nun alles bei EUCH!", italian=" Ora dipende tutto da VOI!", spanish=" ¡Ahora está en vuestras manos!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="You have to stop the planet's\nparalysis! GOOD LUCK!", french="Vous devez empêcher la\nParalysie de la Planète! BONNE CHANCE!", german="Ihr müsst die Lähmung des\nPlaneten aufhalten! VIEL GLÜCK!", italian="Dovete impedire la paralisi del\npianeta! BUONA FORTUNA!", spanish="¡Tenéis que poner freno a la\nparálisis del planeta! ¡Buena suerte!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="You two go on ahead to Treasure\nTown and get ready.", french="Vous deux, allez à Bourg-Trésor\net préparez-vous.", german="Ihr zwei geht nach Schatzstadt\nund macht euch fertig.", italian="Voi due andate a Borgo Tesoro e\npreparatevi.", spanish=" Id a Aldea Tesoro y preparaos."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="When another apprentice comes\nback, I'll get them to cover for me while I get\ngeared up.", french="Dès qu'un autre apprenti\nreviendra, je lui ordonnerai de me\nremplacer pendant que je m'équipe.", german="Wenn ein weiterer Schüler\nzurückkommt, lasse ich ihn für mich\neinspringen, während ich mich fertig mache.", italian="Quando torneranno le altre\nreclute, mi farò sostituire per andare a\nprepararmi.", spanish="Cuando regrese otro aprendiz,\nharé que me sustituya mientras me equipo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [22, 3] || scn($SCENARIO_MAIN) >= [22
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 456, 272, Direction.Up, "NPC_DIGUDA")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="HEY, [CS:N]Diglett[CR]! Let's put in a good\nday of sentry duty! That'll do for now.", french="Hé, [CS:N]Taupiqueur[CR]! C'est parti pour\nune nouvelle journée à monter la garde!\nC'est tout pour l'instant.", german="HEY, [CS:N]Digda[CR]! Legen wir einen\nguten Tag beim Wachdienst hin! Das reicht\nfürs Erste.", italian="EHI, [CS:N]Diglett[CR]! Facciamo di oggi un\naltro bel giorno di guardia! È tutto, per ora.", spanish="¡Eh, [CS:N]Diglett[CR]! ¡Hagamos de vigías!\nSerá suficiente por ahora."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Well there's nothing we can do\nbut our usual job.", french="Bon, on ne peut rien faire\nd'autre que notre travail habituel.", german="Nun, da können wir wohl nichts\nweiter tun, als unsere normale Arbeit zu\nverrichten.", italian="Non possiamo fare altro che il\nnostro solito lavoro.", spanish="Volvamos a nuestro trabajo\ndiario."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(16, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="I can throw a LOT more effort\ninto this!", french="Je suis capable de BIEN mieux\nque ça!", german="Ich kann WEIT mehr Einsatz und\nAufwand in diese Aufgabe stecken!", italian=" Potevo dare molto di PIÙ!", spanish=" ¡Puedo esforzarme mucho más!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 0] || scn($SCENARIO_MAIN) >= [15
  -- @label_121 [étiquette de flux ExplorerScript]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="HEY, [CS:N]Diglett[CR]! It's a new day!\nLet's buckle down and FOCUS!", french="Hé, [CS:N]Taupiqueur[CR]! Aujourd'hui est\nun nouveau jour! Alors au boulot! Et fais\nbien GAFFE, compris?", german="HEY, [CS:N]Digda[CR]! Es ist ein neuer Tag!\nReißen wir uns zusammen und KONZENTRIEREN\nwir uns!", italian="HEI, [CS:N]Diglett[CR]! È un nuovo giorno!\nSpicciati e CONCENTRATI!", spanish="¡Eh, [CS:N]Diglett[CR]! ¡Ya es de día!\n¡A trabajar! ¡Céntrate!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 1]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="HEY, [CS:N]Diglett[CR]![K] We've been away\nfrom this! We'd better FOCUS!", french="Hé, [CS:N]Taupiqueur[CR]![K] On n'est pas\nbien concentrés, là! On ferait mieux de faire\nsuper GAFFE!", german="HEY, [CS:N]Digda[CR]![K] Wir sind von\nunserer Aufgabe abgekommen! KONZENTRIEREN\nwir uns besser!", italian="EHI, [CS:N]Diglett[CR]![K] Basta!\nDobbiamo CONCENTRARCI!", spanish="¡Eh, [CS:N]Diglett[CR]![K] ¡Nos hemos\ndistraído! ¡Tenemos que centrarnos!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Good for YOU![K] I'm glad you two\ngot picked for the expedition too!", french="Félicitations![K] Je suis\nBIEN CONTENT que vous fassiez partie\nde l'expédition, vous aussi!", german="Prima für EUCH![K] Ich bin froh,\ndass ihr zwei ebenfalls für die Expedition\nausgewählt wurdet!", italian="Buon per voi![K] Sono contento\nche abbiano scelto anche voi per la spedizione!", spanish="¡Bien![K] ¡Me alegro de que también\nos seleccionaran para la expedición!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="The expedition is no walk in the\npark![K] So don't GOOF UP and get in my way!", french="Mais attention: l'expédition,\nc'est pas une promenade dans le bac à sable![K]\nAlors PAS DE GAFFE, je suis pas votre nounou!", german="Die Expedition ist aber kein\nSpaziergang![K] VERPATZT es nicht und haltet\nmich nicht auf!", italian="La spedizione non sarà una\npasseggiata![K] Niente ERRORI e teniamo\nduro!", spanish="¡La expedición va a ser dura![K]\n¡Así que nada de vaguear y a seguirme\ntodos!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" GOT THAT?!", french=" COMPRIS?!", german=" VERSTANDEN?!?", italian=" CAPITO?!", spanish=" ¿Entendido?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Pssst... Yeah, I'd say you two\nlucked out, getting us to share those [CS:I]Apples[CR]...", french="Pssst, vous deux... Ouais, moi\nje dis que vous avez eu du bol qu'on accepte\nde partager ces [CS:I]Pommes[CR] avec vous...", german="Tja, ich würde sagen, ihr zwei\nhabt echt Glück gehabt, dass wir uns durchge-\nrungen haben, diese [CS:I]Äpfel[CR] mit euch zu teilen.", italian="Psss... Sì, voi due avete avuto\nun colpo di fortuna. Riuscire a convincerci a\ndividere quelle [CS:I]Mele[CR]...", spanish="Pss... Habéis tenido suerte porque\naquí estábamos nosotros para compartir\nesas [CS:I]Manzanitas[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" ...I was worried about you two...", french="... J'étais vachement inquiet\npour vous deux...", german="...Ich habe mir Sorgen um euch\nzwei gemacht...", italian=" Ero preoccupato per voi due...", spanish=" Me teníais preocupado..."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="...Anyway, here's to all of us!\nLet's work on being picked for the expedition...", french="... Bref, à la nôtre! Travaillons\ndur pour faire partie de l'expédition!", german="...Wie auch immer. Auf uns!\nArbeiten wir daran, für die Expedition\nausgewählt zu werden...", italian="In ogni modo! Diamo il meglio\nper essere scelti per la spedizione...", spanish="En fin, habrá que trabajar duro\npara poder participar en la expedición."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 2] || scn($SCENARIO_MAIN) >= [8, 
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="HEY, [CS:N]Diglett[CR]! We GOTTA work\nhard at getting picked for the expedition!", french="Hé, [CS:N]Taupiqueur[CR]! Il faut\nABSOLUMENT qu'on travaille dur pour être\nchoisis pour l'expédition!", german="HEY, [CS:N]Digda[CR]! Wir müssen hart\ndaran arbeiten, für die Expedition ausgewählt\nzu werden!", italian="EHI, [CS:N]Diglett[CR]! DOBBIAMO lavorare\nduro così saremo scelti per la spedizione!", spanish="¡Eh, [CS:N]Diglett[CR]! ¡Hay que trabajar\nduro si queremos participar en la expedición!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 6) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 6]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Ugh...[K] Our Guildmaster is really\na special guy...", french="Euuuh...[K] Le Maître de la Guilde\nest quelqu'un de très SPECIAL...", german="Uff...[K] Unser Gildenmeister ist\nein ganz besonderer Kerl...", italian="Uh...[K] Il nostro Capitano è\nveramente speciale...", spanish="Uf...[K] El Gran Bluff es un tanto\nespecial..."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Special in all sorts of ways...", french="Spécial de bien des façons,\nd'ailleurs...", german=" In jeder Hinsicht besonders...", italian=" Speciale in tutti i sensi...", spanish=" En todos los sentidos..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 3] || scn($SCENARIO_MAIN) >= [7, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" HEY, you two!", french=" HEP LA, vous deux!", german=" HEY, ihr zwei!", italian=" EHI, voi due!", spanish=" ¡Eh, pareja!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="I thought I smelled something\nawfully ODD coming from over there...", french="Je crois qu'il y a comme une\nodeur super BIZARRE par là-bas...", german="Mir war so, als hätte ich etwas\nextrem Merkwürdiges gerochen, das von dort\nherüberzieht...", italian="Penso di aver sentito un odore\nterribilmente STRANO venire da lì...", spanish="Me ha llegado un tufillo un tanto\nraro..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Did something happen on the\nother floor?", french="Est-ce qu'il s'est passé quelque\nchose à l'étage supérieur?", german="Ist auf der anderen Ebene etwas\npassiert?", italian="È successo qualcosa sull'altro\npiano?", spanish="¿Ha pasado algo en la otra\nplanta?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 1]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" All right! Look SHARP, [CS:N]Diglett[CR]!", french="Hop hop hop! GROUILLE-TOI,\n[CS:N]Taupiqueur[CR]!", german=" Gut! BEEILE dich, [CS:N]Digda[CR]!", italian=" Va bene! Stai ALL'ERTA, [CS:N]Diglett[CR]!", spanish=" ¡Bien! ¡No te distraigas, [CS:N]Diglett[CR]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [6, 5] || scn($SCENARIO_MAIN) >= [6, 
  -- jump @label_121 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(5, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [5, 5]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="[CS:N]Diglett[CR] is on sentry duty today.\nGOOD THING!", french="[CS:N]Taupiqueur[CR] est au poste de guet\naujourd'hui. EXCELLENT!", german="[CS:N]Digda[CR] schiebt heute\nWachdienst. WUNDERBAR!", italian="[CS:N]Diglett[CR] oggi è di guardia.\nMOLTO BENE!", spanish="[CS:N]Diglett[CR] está hoy de vigía.\n¡Mucho mejor!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="You two don't inspire confidence\nas sentries! HAW HAW!", french="Vous, vous êtes pas crédibles\ncomme gardes! WHA HA HA HA!", german="So gut wie er könnt ihr niemals\nsein! Nicht in hundert Jahren! HARHAR!", italian="Voi non ispirate fiducia come\nguardie! AHR AHR!", spanish="¡No me inspiráis confianza de\nvigías! ¡Jua, jua!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 7]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="All right, [CS:N]Diglett[CR]![K] Time to buck\nup and FOCUS!", french="Très bien, [CS:N]Taupiqueur[CR]![K]\nAu boulot! Et fais bien GAFFE!", german="Gut, [CS:N]Digda[CR]![K] Zeit, dich\nzusammenzureißen. Und KONZENTRIERE DICH!", italian="Va bene, [CS:N]Diglett[CR]![K] È ora di\nspicciarsi e di CONCENTRARSI!", spanish="¡Muy bien, [CS:N]Diglett[CR]![K] ¡Hora de\ntrabajar! ¡Céntrate!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 5]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" HEY! [CS:N]Diglett[CR]!", french=" Hé! [CS:N]Taupiqueur[CR]!", german=" HEY! [CS:N]Digda[CR]!", italian=" EHI! [CS:N]Diglett[CR]!", spanish=" ¡Oye! ¡[CS:N]Diglett[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Let me know right away if\nANYONE sketchy comes along!", french="Si jamais tu vois QUI QUE CE\nSOIT de louche, préviens-moi ILLICO!", german="Lass es mich sofort wissen,\nwenn IRGENDJEMAND Komisches hier\nvorbeikommt!", italian="Fammi sapere immediatamente\nse arriva qualcuno che non riconosci!", spanish="Mantenme informado si pasa por\naquí alguien con aspecto sospechoso."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end) -- message_SetActor(ACTOR_NPC_DIGUDA)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Yes! Will do!", french=" Oui! Promis!", german=" Ja! Wird gemacht!", italian=" Sì! Certo!", spanish=" ¡Sí, señor! ¡A la orden!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 3] || scn($SCENARIO_MAIN) >= [4, 
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="All right![K] Time to buck up and\nWORK HARD!", french="Allez![K] Maintenant, c'est l'heure\nde se mettre au boulot, et FISSA!\nHOP HOP HOP!", german="Zeit, uns zusammenzureißen\nund[K] HART ZU ARBEITEN!", italian="Va bene![K] È ora di spicciarsi e\ndi LAVORARE DURO!", spanish=" ¡Muy bien![K] ¡Hora de trabajar!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
