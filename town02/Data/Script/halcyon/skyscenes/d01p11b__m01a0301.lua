-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11B/m01a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...Wh-what?", french=" ... Qu... quoi?", german=" ...W-was?", italian=" ... C-Cosa?", spanish=" ¿Cómo...?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...Wh-what?", french=" ... Qu... quoi?", german=" ...W-was?", italian=" ... C-Cosa?", spanish=" ¿Cómo...?"})
  else
  SkySceneKit.say({english=" ...Wh-what?", french=" ... Qu... quoi?", german=" ...W-was?", italian=" ... C-Cosa?", spanish=" ¿Cómo...?"})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V01P03B) [décor sub chargé: Sub_v01p03b]
  -- back_SetGround(LEVEL_D01P11B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 33, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  pcall(function() GAME:MoveCamera(264, 204, 1, false) end)
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v01p03b", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(12)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Owowow... That wasn't so good.", french="Ouille, ouille, ouille... Ça ne s'est\npas très bien passé.", german=" Auauau... Das war ein Reinfall.", italian="Ahiahiahi... Non è andata molto\nbene.", spanish="Ay, ay... No lo hemos hecho\nmuy bien."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Owowow... That didn't go well.", french="Ouille, ouille, ouille... Ça ne s'est\npas très bien passé.", german=" Auauau... Das lief nicht so gut.", italian="Ahiahiahi... Non è andata molto\nbene.", spanish="Ay, ay... Esto no ha ido\ndemasiado bien."})
  else
  SkySceneKit.say({english=" Ouch! We didn't do too well...", french="Ouille, ouille, ouille... Ça ne s'est\npas très bien passé.", german="Autsch! Wir waren nicht gerade\nsuper...", italian="Ahi... Non è andata molto\nbene.", spanish="Ay, ¡qué daño! Esto no ha ido\nmuy bien que digamos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I guess if either of us faints,\nthe other one can't carry on!", french="Apparemment, ni toi ni moi ne\npouvons continuer si l'autre se retrouve K.O.", german="Ich glaube, wenn einer von uns\nohnmächtig wird, kann der andere auch nicht\nweiterkämpfen!", italian="Se uno di noi due va KO, l'altro\nnon può proseguire da solo.", spanish="Por lo que veo, si uno de\nnosotros se debilita, ¡el otro no puede\nseguir adelante solo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I guess if either of us faints,\nthe other one can't carry on!", french="Apparemment, ni toi ni moi ne\npouvons continuer si l'autre se retrouve K.O.", german="Ich glaube, wenn einer von uns\nohnmächtig wird, kann der andere auch nicht\nweiterkämpfen!", italian="Se uno di noi due va KO, l'altro\nnon può proseguire da solo.", spanish="Parece que si uno de nosotros se\ndebilita, ¡el otro no puede seguir adelante solo!"})
  else
  SkySceneKit.say({english="I guess if either of us faints,\nthe other one can't carry on!", french="Apparemment, ni toi ni moi ne\npouvons continuer si l'autre se retrouve K.O.", german="Ich glaube, wenn einer von uns\nohnmächtig wird, kann der andere auch nicht\nweiterkämpfen!", italian="Se io vado KO, tu non potrai\nproseguire. Lo stesso succede in caso sia tu ad\nandare KO.", spanish="Supongo que no podemos seguir\nadelante por separado.\n¡No podemos debilitarnos!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...Could this be what they're\ncalling a mystery dungeon?", french="... Se pourrait-il... Est-ce cela\nqu'on appelle un donjon mystère?", german="...War das etwa einer von\ndiesen sogenannten Mystery Dungeons?", italian="Che questo sia uno dei\nfamigerati dungeon misteriosi?", spanish="Eso debía de ser lo que suelen\nllamar un territorio misterioso..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...Could this be what they're\ncalling a mystery dungeon?", french="... Se pourrait-il... Est-ce cela\nqu'on appelle un donjon mystère?", german="...War das etwa einer von\ndiesen sogenannten Mystery Dungeons?", italian="Che questo sia uno dei\nfamigerati dungeon misteriosi?", spanish="Supongo que era lo que suelen\nllamar un territorio misterioso..."})
  else
  SkySceneKit.say({english="...Could this be what they're\ncalling a mystery dungeon?", french="... Se pourrait-il... Est-ce cela\nqu'on appelle un donjon mystère?", german="...War das etwa einer von\ndiesen sogenannten Mystery Dungeons?", italian="Che questo sia uno dei\nfamigerati dungeon misteriosi?", spanish="Supongo que era lo que suelen\nllamar un territorio misterioso..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey! We don't have time\nfor this!", french="Oh! On n'a pas de temps\nà perdre avec ça!", german="Hey! Wir haben keine Zeit zum\nReden!", italian=" Beh, adesso non abbiamo tempo!", spanish="¡Oye! ¡No es momento para\nquedarse aquí como un pasmarote!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! This isn't the time for this!", french="Oh! On n'a pas de temps\nà perdre avec ça!", german="Hey! Dafür haben wir jetzt\nkeine Zeit!", italian=" Beh, adesso non abbiamo tempo!", spanish="¡Oye! ¡Este no es el momento\npara ponerse a divagar!"})
  else
  SkySceneKit.say({english=" Oh! There's no time to waste!", french="Oh! On n'a pas de temps\nà perdre avec ça!", german="Hey! Wir haben keine Zeit zu\nverlieren!", italian=" Oh! Non c'è tempo da perdere!", spanish=" ¡Oye! ¡No hay tiempo que perder!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to find [CS:N]Koffing[CR] and his\nbuddy to get my item back!", french="On doit retrouver [CS:N]Smogo[CR] et\nson acolyte pour leur reprendre mon objet!", german="Wir müssen [CS:N]Smogon[CR] und seinen\nKumpel finden und meinen Schatz zurückholen!", italian="Dobbiamo trovare [CS:N]Koffing[CR] e il\nsuo compare per recuperare il mio tesoro!", spanish="¡Hay que encontrar a [CS:N]Koffing[CR]\ny al Pokémon que lo acompañaba para\nrecuperar mi talismán!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We've got to find [CS:N]Koffing[CR] and\nhis sidekick to recover my item!", french="On doit retrouver [CS:N]Smogo[CR] et\nson acolyte pour leur reprendre mon objet!", german="Wir müssen [CS:N]Smogon[CR] und sein\nAnhängsel finden und meinen Schatz retten!", italian="Dobbiamo trovare [CS:N]Koffing[CR] e il\nsuo compare per recuperare il mio tesoro!", spanish="¡Hay que encontrar a [CS:N]Koffing[CR]\ny a su compinche para recuperar mi talismán!"})
  else
  SkySceneKit.say({english="We need to catch [CS:N]Koffing[CR] and\nhis buddy and get my treasure back!", french="On doit retrouver [CS:N]Smogo[CR] et\nson acolyte pour leur reprendre mon objet!", german="Wir müssen [CS:N]Smogon[CR] und seinen\nFreund fangen und meinen Schatz retten!", italian="Dobbiamo trovare [CS:N]Koffing[CR] e il\nsuo compare per recuperare il mio tesoro!", spanish="¡Hay que dar con [CS:N]Koffing[CR] y con\nsu compinche para recuperar mi talismán!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's roll, [hero]!", french=" Allons-y, [hero]!", german=" Packen wir es an, [hero]!", italian=" Forza, andiamo, [hero]!", spanish=" ¡A por ellos, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go, [hero]!", french=" Allons-y, [hero]!", german=" Los, gehen wir, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡En marcha, [hero]!"})
  else
  SkySceneKit.say({english=" Let's go, [hero]!", french=" Allons-y, [hero]!", german=" Los, gehen wir, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Adelante, [hero]!"})
  end
  -- message_Close
  GROUND:MoveToPosition(partner, 96, 204, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 104, 204, false, 2)
  GAME:WaitFrames(60)
  pcall(function() SOUND:FadeOutBGM(60) end)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitBgm2
  -- main_EnterDungeon(1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
