-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V24P01A/m24a0108.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_V24P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 208, 176, Direction.UpLeft, "NPC_JUPUTORU")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker("Lapras", true, "lapras", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_RAPURASU) voix hors champ (espèce ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:N]Wigglytuff[CR] promised to honor\nmy request, most agreeably.", french="[CS:N]Grodoudou[CR] a eu l'amabilité\nd'accéder à ma requête.", german="[CS:N]Knuddeluff[CR] versprach, mein\nAnsinnen zu respektieren, mir zuliebe.", italian="[CS:N]Wigglytuff[CR] ha promesso di\nessere ben disposto a onorare la mia richiesta.", spanish="[CS:N]Wigglytuff[CR] accedió de buen\ngrado a mi petición."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="He said he owed me thanks for\ncoming to [CS:N]Chatot[CR]'s aid...", french="Il a dit qu'il devait me\nremercier pour être venu au secours\nde [CS:N]Pijako[CR]...", german="Er sagte, er schulde mir Dank\ndafür, dass ich [CS:N]Plaudagei[CR] zur Hilfe gekommen\nwar...", italian="Disse che mi doveva molto\nperché ero accorso in aiuto di [CS:N]Chatot[CR]...", spanish="Dijo que estaba en deuda conmigo\npor acudir en auxilio de [CS:N]Chatot[CR]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="and that he would stop all\ninvestigations into the matter.", french="... et qu'il abandonnerait par\nconséquent toute recherche au sujet de\nce symbole.", german="Und dass er alle Untersuchungen\nin diese Richtung beenden würde.", italian="Disse inoltre che avrebbe\nsmesso di investigare su quella faccenda\ndel disegno.", spanish="Y que se encargaría de obstruir\ncualquier investigación."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So that's what happened.", french="Alors c'est comme ça que\nça s'est passé.", german=" Das ist also passiert.", italian=" Allora è andata così.", spanish=" Así que eso fue lo que sucedió."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So that's what happened.", french="Alors c'est comme ça que\nça s'est passé.", german=" Das ist also passiert.", italian=" Allora è andata così.", spanish=" Así que eso fue lo que sucedió."})
  else
  SkySceneKit.say({english=" So that's what happened.", french="Alors c'est comme ça que\nça s'est passé.", german=" Das ist also passiert.", italian=" Allora è andata così.", spanish=" Así que eso fue lo que sucedió."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But...[K]why didn't you want\nanyone to investigate the pattern?", french="Mais...[K] pourquoi tu voulais\nque ce symbole reste un secret?", german="Aber...[K] Warum wolltest du\nniemanden das Muster untersuchen lassen?", italian="Ma...[K] perché non volevi che\nqualcuno indagasse sul disegno?", spanish="Pero...[K] ¿Por qué no querías que\nnadie investigara el símbolo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But...[K]why didn't you want\nanyone to investigate the pattern?", french="Mais...[K] pourquoi tu voulais\nque ce symbole reste un secret?", german="Aber...[K] Warum wolltest du\nniemanden das Muster untersuchen lassen?", italian="Ma...[K] perché non volevi che\nqualcuno indagasse sul disegno?", spanish="Pero...[K] ¿Por qué no querías que\nnadie investigara el símbolo?"})
  else
  SkySceneKit.say({english="But...[K]why didn't you want\nanyone to investigate the pattern?", french="Mais...[K] pourquoi tu voulais\nque ce symbole reste un secret?", german="Aber...[K] Warum wolltest du\nniemanden das Muster untersuchen lassen?", italian="Ma...[K] perché non volevi che\nqualcuno indagasse sul disegno?", spanish="Pero...[K] ¿Por qué no querías que\nnadie investigara el símbolo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Lapras", true, "lapras", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_RAPURASU) voix hors champ (espèce ROM)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="In the [CS:P]Hidden Land[CR]...[K]is [CS:P]Temporal\nTower[CR] where [CS:N]Dialga[CR] reigns.", french="Dans les [CS:P]Terres Illusoires[CR]...[K]\nse dresse la [CS:P]Tour du Temps[CR], siège du pouvoir\nde [CS:N]Dialga[CR].", german="Im [CS:P]Verborgenen Land[CR]...[K] Dort\nsteht der [CS:P]Zeitturm[CR], in dem [CS:N]Dialga[CR] herrscht.", italian="Sulla [CS:P]Terra Nascosta[CR]...[K] c'è la\n[CS:P]Torre del Tempo[CR], il regno di [CS:N]Dialga[CR].", spanish="En la [CS:P]Tierra Oculta[CR]...[K] se erige\nla [CS:P]Torre del Tiempo[CR], en la que reina [CS:N]Dialga[CR]."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:N]Dialga[CR] feared intruders could\nwreak havoc at the tower that regulates time.", french="[CS:N]Dialga[CR] craignait que des intrus\nne fassent des dégâts dans la tour qui régule\nle cours du temps.", german="[CS:N]Dialga[CR] befürchtete, Eindringlinge\nkönnten Chaos am Turm, der die Zeit reguliert,\nverursachen.", italian="[CS:N]Dialga[CR] ha paura che qualcuno\npossa causare la distruzione della torre\nche regola il tempo.", spanish="[CS:N]Dialga[CR] temía que algún intruso\npudiera sabotear la torre que regula el tiempo."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:N]Dialga[CR] decided to protect\n[CS:P]Temporal Tower[CR].", french="Alors il a décidé de protéger\nla [CS:P]Tour du Temps[CR].", german="[CS:N]Dialga[CR] entschied sich dafür,\nden [CS:P]Zeitturm[CR] zu schützen.", italian="[CS:N]Dialga[CR] ha deciso di proteggere la\n[CS:P]Torre del Tempo[CR].", spanish=" Y, por eso, decidió protegerla."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="He hid the [CS:P]Hidden Land[CR] in a gap\nin time.", french="Il a dissimulé les [CS:P]Terres\nIllusoires[CR] dans une brèche temporelle.", german="Es versteckte das\n[CS:P]Verborgene Land[CR] in einer Spalte in der Zeit.", italian="Ha celato la [CS:P]Terra Nascosta[CR]\nin una breccia del tempo.", spanish="Para ello escondió la [CS:P]Tierra[CR]\n[CS:P]Oculta[CR] en un intervalo temporal."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" A gap in time?", french=" Une brèche temporelle?", german=" Eine Spalte in der Zeit?", italian=" Una breccia del tempo?", spanish=" ¿Un intervalo temporal?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" A gap in time?", french=" Une brèche temporelle?", german=" Eine Spalte in der Zeit?", italian=" Una breccia del tempo?", spanish=" ¿Un intervalo temporal?"})
  else
  SkySceneKit.say({english=" A gap in time?", french=" Une brèche temporelle?", german=" Eine Spalte in der Zeit?", italian=" Una breccia del tempo?", spanish=" ¿Un intervalo temporal?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Lapras", true, "lapras", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_RAPURASU) voix hors champ (espèce ROM)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Yes.[K] It is hard to explain, but...", french="Oui.[K] C'est difficile à expliquer,\nmais...", german="Ja.[K] Das ist schwierig zu\nerklären, aber...", italian="Sì.[K] È difficile da spiegare,\nma...", spanish=" Sí.[K] Es difícil de explicar, pero..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="It is a gap in time itself...[K]\nIt's the space between parts of a split second.", french="Il s'agit d'une brèche dans\nle cours du temps lui-même...[K] Un espace\nà l'intérieur même d'une fraction de seconde.", german="Es ist eine Spalte in der Zeit\nselbst...[K] Es ist der Abstand zwischen Teilen\neines Sekundenbruchteils.", italian="È una breccia nel tempo\nstesso...[K] È uno spazio tra le parti di\nuna frazione di secondo.", spanish="Se trata de un intervalo en el\nmismísimo tiempo...[K] Imaginaos el espacio\nque separa un segundo y otro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I see.[K] No wonder the place\ncouldn't be found.", french="Je vois.[K] Pas étonnant que\ncet endroit soit introuvable.", german="Ich verstehe.[K] Kein Wunder, dass\nniemand diesen Ort gefunden hat.", italian="Capisco.[K] Non mi stupisco che il\nposto non si possa trovare.", spanish="Ya veo.[K] Siendo así, no me\nextraña que nadie encontrase ese lugar."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" A gap in time...", french="Une brèche dans le cours\ndu temps...", german=" Eine Spalte in der Zeit...", italian=" Una breccia nel tempo...", spanish=" Un intervalo temporal..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="No one could ever hope to go to\nsuch a place.", french="Atteindre un tel endroit est\nune quête désespérée.", german="Niemand konnte jemals hoffen,\nsolch einen Ort zu finden.", italian="Nessuno potrebbe sperare di\nraggiungere un posto del genere.", spanish="Nadie podría encontrar nunca\nun lugar así."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker("Lapras", true, "lapras", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_RAPURASU) voix hors champ (espèce ROM)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="No.[K] [CS:N]Dialga[CR] left one key for\nentering the [CS:P]Hidden Land[CR].", french="Non.[K] [CS:N]Dialga[CR] a laissé une clé\npour accéder aux [CS:P]Terres Illusoires[CR].", german="Nein.[K] [CS:N]Dialga[CR] ließ einen Schlüssel\nzum [CS:P]Verborgenen Land[CR] zurück.", italian="No.[K] [CS:N]Dialga[CR] ha lasciato una\nchiave per entrare nella [CS:P]Terra Nascosta[CR].", spanish="Bueno...[K] [CS:N]Dialga[CR] dejó una llave\npara poder entrar en la [CS:P]Tierra Oculta[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That's a special fragment with a\nmysterious pattern etched into it.", french="C'est un fragment spécial avec\nun symbole mystérieux gravé dessus.", german="Es ist ein besonderes Fragment,\nin das ein rätselhaftes Muster geätzt wurde.", italian="Si tratta di un frammento\nspeciale con un misterioso disegno inciso\nsulla superficie.", spanish="Hay un fragmento especial con\nun grabado misterioso."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
