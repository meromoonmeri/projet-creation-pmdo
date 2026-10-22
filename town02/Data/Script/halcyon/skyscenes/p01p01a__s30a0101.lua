-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/s30a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  SkyProg.set(6, 4) -- $SCENARIO_MAIN = scn[6,4] (ROM)
  -- back_SetGround(LEVEL_P01P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- supervision_StationCommon(7) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 204, 156, false, 2)
  GROUND:MoveToPosition(partner, 232, 156, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(5)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? What's going on?", french=" Hein? Que se passe-t-il?", german=" Hmmm? Was ist los?", italian=" Eh? Che succede?", spanish=" ¿Eh? ¿Qué está pasando?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh? What's going on?", french=" Hein? Que se passe-t-il?", german=" Hmmm? Was ist los?", italian=" Eh? Che succede?", spanish=" ¿Cómo? ¿Qué está ocurriendo?"})
  else
  SkySceneKit.say({english=" Huh? What's going on?", french=" Hein? Que se passe-t-il?", german=" Hmmm? Was ist los?", italian=" Eh? Che succede?", spanish=" ¿Cómo? ¿Qué está sucediendo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(216, 260, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 204, 268, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(partner, 232, 216, false, 2)
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Stairs?! In a place like this?", french=" Des escaliers? Ici?", german="Treppenstufen?!?\nAn einem Ort wie diesem?", italian=" Scale?! In un posto simile?", spanish="¡¿Unas escaleras?!\n¿En un sitio así?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" There are stairs here!", french=" Des escaliers? Ici?", german=" Hier sind Treppenstufen!", italian=" Ci sono delle scale qui!", spanish="¡Pero si aquí hay\nunas escaleras!"})
  else
  SkySceneKit.say({english=" There are stairs here!", french=" Des escaliers? Ici?", german=" Hier sind Treppenstufen!", italian=" Ci sono delle scale qui!", spanish="¡Aquí hay\nunas escaleras!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Something's written on the sign.", french="Il y a quelque chose d'inscrit\nsur la pancarte...", german="Da steht was auf\ndem Schild geschrieben.", italian=" Sul cartello c'è scritto qualcosa.", spanish=" Hay algo escrito en la señal."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There's something written on\nthe sign...", french="Il y a quelque chose d'inscrit\nsur la pancarte...", german="Etwas steht auf\ndem Schild geschrieben...", italian="C'è scritto qualcosa sul\ncartello...", spanish=" Hay algo escrito en esta señal..."})
  else
  SkySceneKit.say({english="It seems there's something\nwritten on the sign.", french="Il y a quelque chose d'inscrit\nsur la pancarte...", german="Sieht aus, als steht da etwas\nauf dem Schild geschrieben.", italian="Sembra che ci sia scritto\nqualcosa sul cartello.", spanish="Parece que hay algo escrito\nen la señal."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-30), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? What?", french=" Hein? Comment?", german=" Wie? Was ist das denn?", italian=" Mmmh? Cosa?", spanish=" ¿Eh? ¿Qué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh? What?", french=" Hein? Comment?", german=" Wie? Was ist das denn?", italian=" Mmmh? Cosa?", spanish=" ¿Qué? ¿Cómo?"})
  else
  SkySceneKit.say({english=" Huh? What?", french=" Hein? Comment?", german=" Wie? Was ist das denn?", italian=" Mmmh? Cosa?", spanish=" ¿Qué? ¿Cómo?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It says...[K]\"[CS:K]Spinda[CR]'s Café! A Shop\nof Hopes and Dreams, Opening Soon! Win Big!\"", french="C'est écrit: \"[CS:K]Café Spinda[CR]!\nIci, vos rêves se réalisent!\nOuverture imminente!\"", german="Hier steht...[K] [F:S2]- [CS:K]Pandir-Café[CR] -\n- Hoffen und träumen! -\nEröffnung in Kürze. Dicke Belohnungen![F:E2]", italian="Dice...[K] \"Caffè di [CS:K]Spinda[CR]! Luogo\ndi sogni e di speranze. Grosse vincite!\nProssima apertura!\"", spanish="Dice...[K] \"¡Próxima inauguración!\n[CS:K]Cafetería Spinda[CR]\nGrandes premios en una tienda de ensueño\"."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="\"[CS:K]Spinda[CR]'s Café! A Shop of Hopes\nand Dreams, Opening Soon! Win Big!\"[K] it says.", french="C'est écrit: \"[CS:K]Café Spinda[CR]!\nIci, vos rêves se réalisent!\nOuverture imminente!\"", german="Da steht:[K] [F:S2]- [CS:K]Pandir-Café[CR] -\n- Hoffen und träumen! -\nEröffnung in Kürze. Dicke Belohnungen![F:E2]", italian="Dice...[K] \"Caffè di [CS:K]Spinda[CR]! Luogo\ndi sogni e di speranze. Grosse vincite!\nProssima apertura!\"", spanish="Dice...[K] \"¡Próxima inauguración!\n[CS:K]Cafetería Spinda[CR]\nGrandes premios en una tienda de ensueño\"."})
  else
  SkySceneKit.say({english="\"[CS:K]Spinda[CR]'s Café! A Shop of Hopes\nand Dreams, Opening Soon! Win Big!\"[K] it says.", french="C'est écrit: \"[CS:K]Café Spinda[CR]!\nIci, vos rêves se réalisent!\nOuverture imminente!\"", german="Da steht:[K] [F:S2]- [CS:K]Pandir-Café[CR] -\n- Hoffen und träumen! -\nEröffnung in Kürze. Dicke Belohnungen![F:E2]", italian="Dice...[K] \"Caffè di [CS:K]Spinda[CR]! Luogo\ndi sogni e di speranze. Grosse vincite!\nProssima apertura!\"", spanish="Pone...[K] \"¡Próxima inauguración!\n[CS:K]Cafetería Spinda[CR]\nGrandes premios en una tienda de ensueño\"."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Looks like a new shop's opening\nup, huh?", french="On dirait qu'un nouvel endroit\nva ouvrir ses portes, non?", german="Sieht fast so aus, als ob bald\nein neuer Laden eröffnet, nicht wahr?", italian="Pare che aprirà un nuovo\nlocale, eh?", spanish="Parece que van a abrir un nuevo\nestablecimiento, ¿eh?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Looks like a new shop will be\nopening soon.", french="On dirait qu'un nouvel endroit\nva ouvrir ses portes, non?", german="Sieht so aus, als ob demnächst\nein neuer Laden aufmacht.", italian="Sembra che presto aprirà\nun nuovo locale.", spanish="Por lo visto van a abrir\nun nuevo establecimiento."})
  else
  SkySceneKit.say({english="It seems like there will be a\nnew shop here soon, huh?", french="On dirait qu'un nouvel endroit\nva ouvrir ses portes, non?", german="Anscheinend eröffnet hier\ndemnächst ein neuer Laden.", italian="Pare che presto sorgerà\nun nuovo locale qui, eh?", spanish="Parece que pronto habrá un\nestablecimiento nuevo aquí, ¿eh?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But \"Hopes and Dreams\"?\nWhat kind of shop is that?", french="Mais... \"Tous vos rêves se\nréalisent\"? De quel genre d'endroit\npeut-il bien s'agir?", german="Aber... [F:S2]Hoffen und träumen[F:E2]?\nWas für ein Laden das wohl ist?", italian="Ma non capisco quel\n\"Luogo di sogni e di speranze\"...\nChe razza di locale sarà?", spanish="¿\"Una tienda de ensueño\"?\n¿Qué tipo de tienda será?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But \"Hopes and Dreams\"?\nI wonder what kind of shop this will be...", french="Mais... \"Tous vos rêves se\nréalisent\"? De quel genre d'endroit\npeut-il bien s'agir?", german="Aber... [F:S2]Hoffen und träumen[F:E2]?\nIch frage mich, was für ein Laden das wird...", italian="Ma cosa vorrà dire quel\n\"Luogo di sogni e di speranze\"?\nChissà di che locale si tratta...", spanish="Pero... ¿\"Una tienda de\nensueño\"? Me pregunto qué tipo\nde tienda será..."})
  else
  SkySceneKit.say({english="But \"Hopes and Dreams\"?\nI wonder what kind of shop it is...", french="Mais... \"Tous vos rêves se\nréalisent\"? De quel genre d'endroit\npeut-il bien s'agir?", german="Aber... [F:S2]Hoffen und träumen[F:E2]?\nIch frage mich, was für ein Laden das wird...", italian="Ma cosa significherà quel\n\"Luogo di sogni e di speranze\"?\nMi chiedo che tipo di locale sarà...", spanish="Pero... ¿\"Una tienda de\nensueño\"? Me pregunto de qué tipo\nde tienda se tratará..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's come back after it's\nopen and check it out.", french="Revenons une fois que ce sera\nouvert et on verra bien.", german="Lass uns wiederkommen und mal\nreinschauen, sobald er geöffnet hat.", italian="Torniamo a dare un'occhiata\nquando avrà aperto.", spanish="Será cosa de volver cuando la\nabran para echarle un vistazo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's come back after it's open\nand find out.", french="Revenons une fois que ce sera\nouvert et on verra bien.", german="Lass uns wiederkommen, sobald\ner geöffnet hat, und sehen, was es mit diesem\nLaden auf sich hat.", italian="Torniamo a controllare quando\navrà aperto.", spanish="Podemos volver cuando la\ninauguren para averiguarlo."})
  else
  SkySceneKit.say({english="Let's come back after it\nopens and find out.", french="Revenons une fois que ce sera\nouvert et on verra bien.", german="Lass uns wiederkommen, sobald\ner geöffnet hat, und sehen, was es mit diesem\nLaden auf sich hat.", italian="Torniamo a controllare quando\navrà aperto.", spanish="Podríamos volver cuando la\ninauguren para echarle un vistazo."})
  end
  -- message_Close
end
