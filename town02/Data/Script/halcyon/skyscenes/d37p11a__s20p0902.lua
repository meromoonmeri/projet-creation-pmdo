-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D37P11A/s20p0902.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 76) -- $SCENARIO_MAIN = scn[29,76] (ROM)
  -- back_SetGround(LEVEL_D37P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: se_Play(8201) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_G01P07A1_108) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_IN_THE_NIGHTMARE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[K]Is this inside the dream...?", french="...[K] Est-ce que nous sommes\ndans le cauchemar...?", german="...[K]Sieht so das Innere des\nTraumes aus?", italian="...[K] Siamo all'interno\ndel sogno...?", spanish="Entonces...[K] ¿Estamos en\nel sueño?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[K]Is this inside the dream...?", french="...[K] Est-ce que nous sommes\ndans le cauchemar...?", german="...[K]Sieht so das Innere des\nTraumes aus?", italian="...[K] Siamo all'interno\ndel sogno...?", spanish="Entonces...[K] ¿Estamos en\nel sueño?"})
  else
  SkySceneKit.say({english=" ...[K]Is this inside the dream...?", french="...[K] Est-ce que nous sommes\ndans le cauchemar...?", german="...[K]Sieht so das Innere des\nTraumes aus?", italian="...[K] Siamo all'interno\ndel sogno...?", spanish="Entonces...[K] ¿Estamos en\nel sueño?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Drowzee", true, "drowzee", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_SURIIPU) voix hors champ (espèce ROM)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" [partner]! [hero]!", french=" [partner]! [hero]!", german=" [partner]! [hero]!", italian=" [partner]! [hero]!", spanish=" ¡[partner]! ¡[hero]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Drowzee", true, "drowzee", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_SURIIPU) voix hors champ (espèce ROM)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Can you hear me?[K] It's me.\n[CS:N]Drowzee[CR].", french="Est-ce que vous m'entendez?[K]\nC'est moi. [CS:N]Soporifik[CR].", german="Könnt ihr mich hören?[K] Ich bin\nes. [CS:N]Traumato[CR].", italian="Riuscite a sentirmi?[K] Sono io,\n[CS:N]Drowzee[CR].", spanish="¿Podéis oírme?[K] Soy yo,\n[CS:N]Drowzee[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup! We hear you!", french=" Oui! On t'entend!", german=" Jep! Wir hören dich!", italian=" Sì! Ti sentiamo!", spanish=" ¡Sí! ¡Te oímos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes! We hear you!", french=" Oui! On t'entend!", german=" Ja! Wir hören dich!", italian=" Sì! Ti sentiamo!", spanish=" ¡Sí! ¡Te oímos!"})
  else
  SkySceneKit.say({english=" Yep! We hear you!", french=" Oui! On t'entend!", german=" Jep! Wir hören dich!", italian=" Sì! Ti sentiamo!", spanish=" ¡Sí! ¡Te oímos!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Drowzee", true, "drowzee", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_SURIIPU) voix hors champ (espèce ROM)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Good.[K] It sounds like you're\nsafely inside.", french="Bien.[K] Vous êtes en sécurité à\nl'intérieur.", german="Gut.[K] Hört sich an, als wärt ihr\ngut reingekommen.", italian=" Bene.[K] Siete nel sogno.", spanish="Bien.[K] Parece que habéis pasado\nsin problemas."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="As I've said before, there's\nsomething very bad about this dream.", french="Comme je l'ai dit, il y a quelque\nchose de malsain dans ce rêve.", german="Wie ich bereits sagte, ist an\ndem Traum etwas richtig Böses.", italian="Come ho detto prima, c'è\nqualcosa che non va in questo sogno.", spanish="Como os dije antes, creo que\nalgo malo está ocurriendo."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="I don't think I need to remind\nyou, but...", french="Je pense qu'il est inutile de\nle vous rappeler mais...", german="Ich glaube nicht, dass ich euch\ndaran erinnern muss, aber...", italian="Non penso di dovervelo\nricordare, ma...", spanish="No creo que sea necesario\nrecordároslo, pero..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Be careful in there.", french=" Faites preuve de prudence.", german=" Seid vorsichtig da drinnen.", italian=" ... fate attenzione lì dentro.", spanish=" Id con mucho cuidado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" OK! Thanks, [CS:N]Drowzee[CR]!", french=" D'accord! Merci, [CS:N]Soporifik[CR]!", german=" Okay! Danke, [CS:N]Traumato[CR]!", italian=" Ok! Grazie, [CS:N]Drowzee[CR]!", spanish=" ¡Vale! Gracias, ¡[CS:N]Drowzee[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK! Thanks, [CS:N]Drowzee[CR]!", french=" D'accord! Merci, [CS:N]Soporifik[CR]!", german=" Okay! Danke, [CS:N]Traumato[CR]!", italian=" Ok! Grazie, [CS:N]Drowzee[CR]!", spanish=" ¡Vale! Gracias, ¡[CS:N]Drowzee[CR]!"})
  else
  SkySceneKit.say({english=" OK! Thanks, [CS:N]Drowzee[CR]!", french=" D'accord! Merci, [CS:N]Soporifik[CR]!", german=" Okay! Danke, [CS:N]Traumato[CR]!", italian=" Ok! Grazie, [CS:N]Drowzee[CR]!", spanish=" ¡Vale! Gracias, ¡[CS:N]Drowzee[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's get moving.[K] Into the dream.", french=" Avançons...[K] dans le rêve.", german="Dann gehen wir mal.[K] In den\nTraum hinein...", italian=" Andiamo.[K] Esploriamo il sogno.", spanish=" En marcha.[K] Al sueño."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's get going.[K] Into the dream.", french=" Avançons...[K] dans le rêve.", german="Dann gehen wir mal.[K] In den\nTraum hinein...", italian=" Andiamo.[K] Esploriamo il sogno.", spanish=" En marcha.[K] Al sueño."})
  else
  SkySceneKit.say({english=" Let's get going.[K] Into the dream.", french=" Avançons...[K] dans le rêve.", german="Dann gehen wir mal.[K] In den\nTraum hinein...", italian=" Andiamo.[K] Esploriamo il sogno.", spanish=" En marcha.[K] Al sueño."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 224, 124, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 256, 124, false, 2)
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  -- main_EnterDungeon(63, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
end
