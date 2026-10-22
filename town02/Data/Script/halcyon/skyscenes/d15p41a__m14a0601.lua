-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D15P41A/m14a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(23, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  SkyProg.set(15, 3) -- $SCENARIO_MAIN = scn[15,3] (ROM)
  -- back_SetGround(LEVEL_D15P41A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(partner, 280, 252, false, 2)
  GROUND:MoveToPosition(hero, 320, 252, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 300, 292, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 332, 292, false, 2) end end
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Th-this is...", french=" C'est...", german=" D-das ist...", italian=" Q-Questo è...", spanish=" Esto... es..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Th-this is...", french=" C'est...", german=" D-das ist...", italian=" Q-Questo è...", spanish=" Esto... es..."})
  else
  SkySceneKit.say({english=" Th-this is...", french=" C'est...", german=" D-das ist...", italian=" Q-Questo è...", spanish=" Esto... es..."})
  end
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V14P01A) [décor sub chargé: Sub_v14p01a]
  -- camera2_SetPositionMark(Position<'m4', 34.5, 17.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v14p01a", 30, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" fantastic...", french=" C'est fantastique...", german=" Das ist fantastisch...", italian=" È straordinario...", spanish=" ¡Fantástico!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" fantastic...", french=" C'est fantastique...", german=" Das ist fantastisch...", italian=" È straordinario...", spanish=" ¡Fantástico!"})
  else
  SkySceneKit.say({english=" fantastic...", french=" C'est fantastique...", german=" Das ist fantastisch...", italian=" È straordinario...", spanish=" ¡Fantástico!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I wasn't expecting this...[K]\nthis huge lake sprawling underground...", french="Qui l'eût cru...[K] Un immense lac\nsouterrain...", german="Das hätte ich nicht erwartet...[K]\nDiesen riesigen unterirdischen See...", italian="Chi l'avrebbe mai detto...[K]\nC'è un immenso lago sotterraneo.", spanish="No me esperaba...[K] este enorme\nlago subterráneo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I didn't expect to see this...[K]\nthis huge lake sprawling underground...", french="Qui l'eût cru...[K] Un immense lac\nsouterrain...", german="Das hätte ich nicht erwartet...[K]\nDiesen riesigen unterirdischen See...", italian="Chi l'avrebbe mai detto...[K]\nC'è un immenso lago sotterraneo.", spanish="No me esperaba...[K] este enorme\nlago subterráneo."})
  else
  SkySceneKit.say({english="I didn't expect to see this...[K]\nthis huge lake extending underground...", french="Qui l'eût cru...[K] Un immense lac\nsouterrain...", german="Das hätte ich nicht erwartet...[K]\nDiesen riesigen unterirdischen See...", italian="Chi l'avrebbe mai detto...[K]\nC'è un immenso lago sotterraneo.", spanish="No me esperaba...[K] este enorme\nlago subterráneo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey! There's something glowing\nway over there!", french="Regarde, il y a quelque chose\nqui brille, au loin là-bas!", german=" Hey! Da hinten leuchtet was!", italian="Ehi! C'è qualcosa che luccica\nlaggiù!", spanish=" ¡Mira! ¡Hay algo que brilla!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Look! Something's glowing way\nover there!", french="Regarde, il y a quelque chose\nqui brille, au loin là-bas!", german="Sieh mal! Da hinten leuchtet\netwas!", italian=" Guarda! C'è una luce laggiù!", spanish=" ¡Mira! ¡Allí hay algo que brilla!"})
  else
  SkySceneKit.say({english="Oh! There's something glowing\nway over there!", french="Regarde, il y a quelque chose\nqui brille, au loin là-bas!", german=" Oh! Da hinten leuchtet etwas!", italian=" Guarda! C'è una luce laggiù!", spanish=" ¡Mira! ¡Allí hay algo que brilla!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That light...[K] I'm sure I've seen\nit before...", french="Cette lumière...[K] je suis sûr\nde l'avoir déjà vue quelque part...", german="Dieses Licht...[K]\nIch bin mir sicher, dass ich es schon mal\ngesehen habe.", italian="Quella luce...[K] Sono sicuro di\naverla già vista...", spanish="Esa luz...[K] Me parece que\nme suena..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That light...[K] I'm sure I've seen\nit before...", french="Cette lumière...[K] je suis sûr\nde l'avoir déjà vue quelque part...", german="Dieses Licht...[K]\nIch bin mir sicher, dass ich es schon mal\ngesehen habe.", italian="Quella luce...[K] Sono sicuro di\naverla già vista...", spanish="Esa luz...[K] Me parece que\nme suena..."})
  else
  SkySceneKit.say({english="That light...[K] I'm sure I've seen\nit before...", french="Cette lumière...[K] je suis sûre\nde l'avoir déjà vue quelque part...", german="Dieses Licht...[K]\nIch bin mir sicher, dass ich es schon mal\ngesehen habe.", italian="Quella luce...[K] Sono sicura di\naverla già vista...", spanish="Esa luz...[K] Me parece que\nme suena..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That's it! I got it!", french=" Ça y est, j'y suis!", german=" Das ist es! Ich habe es!", italian=" Ma certo! Ho capito!", spanish=" ¡Ya lo tengo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's it! I've got it now!", french=" Ça y est, j'y suis!", german=" Das ist es! Jetzt habe ich es!", italian=" Ah! Adesso capisco!", spanish=" ¡Ya lo tengo!"})
  else
  SkySceneKit.say({english=" That's it! I've got it now!", french=" Ça y est, j'y suis!", german=" Das ist es! Jetzt habe ich es!", italian=" Ah! Adesso capisco!", spanish=" ¡Ya lo tengo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's the same kind of light that\nwe saw at [CS:P]Fogbound Lake[CR]!", french="C'est la même lumière qu'au [CS:P]Lac\ndes Brumes[CR]!", german="So ein Licht haben wir am\n[CS:P]Nebelsee[CR] gesehen!", italian="È la stessa luce che abbiamo\nvisto al [CS:P]Lago Foschia[CR]!", spanish="¡Es el mismo tipo de luz que\nvimos en el [CS:P]Lago Velado[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's the same kind of light that\nwe saw at [CS:P]Fogbound Lake[CR]!", french="C'est la même lumière qu'au [CS:P]Lac\ndes Brumes[CR]!", german="So ein Licht haben wir am\n[CS:P]Nebelsee[CR] gesehen!", italian="È la stessa luce che abbiamo\nvisto al [CS:P]Lago Foschia[CR]!", spanish="¡Es el mismo tipo de luz que\nvimos en el [CS:P]Lago Velado[CR]!"})
  else
  SkySceneKit.say({english="It's the same kind of light that\nwe saw at [CS:P]Fogbound Lake[CR]!", french="C'est la même lumière qu'au [CS:P]Lac\ndes Brumes[CR]!", german="So ein Licht haben wir am\n[CS:P]Nebelsee[CR] gesehen!", italian="È la stessa luce che abbiamo\nvisto al [CS:P]Lago Foschia[CR]!", spanish="¡Es el mismo tipo de luz que\nvimos en el [CS:P]Lago Velado[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That means...", french=" Ce qui veut dire...", german=" Das heißt...", italian=" Questo significa...", spanish=" Eso quiere decir que..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That means...", french=" Ce qui veut dire...", german=" Das heißt...", italian=" Questo significa...", spanish=" Eso quiere decir que..."})
  else
  SkySceneKit.say({english=" That means...", french=" Ce qui veut dire...", german=" Das heißt...", italian=" Questo significa...", spanish=" Eso quiere decir que..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That light may be coming from\na Time Gear!", french="... que cette lumière doit\némaner d'un Rouage du Temps!", german="Dieses Licht kommt vielleicht\nvon einem Zahnrad der Zeit!", italian="Potrebbe provenire da un\nIngranaggio del Tempo!", spanish="¡Puede que esa luz provenga de\nun Engranaje del Tiempo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That light could be coming from\na Time Gear!", french="... que cette lumière doit\némaner d'un Rouage du Temps!", german="Dieses Licht kommt vielleicht\nvon einem Zahnrad der Zeit!", italian="Potrebbe provenire da un\nIngranaggio del Tempo!", spanish="¡Puede que esa luz provenga de\nun Engranaje del Tiempo!"})
  else
  SkySceneKit.say({english="That light may be coming from\na Time Gear!", french="... que cette lumière doit\némaner d'un Rouage du Temps!", german="Dieses Licht kommt vielleicht\nvon einem Zahnrad der Zeit!", italian="Potrebbe provenire da un\nIngranaggio del Tempo!", spanish="¡Puede que esa luz provenga de\nun Engranaje del Tiempo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's get a closer look at it,\n[hero]!", french="Allons voir ça de plus près,\n[hero]!", german="Sehen wir uns das genauer an,\n[hero]!", italian="Andiamo a dare un'occhiata da\nvicino, [hero]!", spanish="Echemos un vistazo más de\ncerca, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We need to get a closer look at\nit, [hero]!", french="Allons voir ça de plus près,\n[hero]!", german="Wir müssen uns das genauer\nansehen, [hero]!", italian="Andiamo a dare un'occhiata da\nvicino, [hero]!", spanish="Echemos un vistazo más de\ncerca, [hero]."})
  else
  SkySceneKit.say({english="Let's get a closer look at it,\n[hero]!", french="Allons voir ça de plus près,\n[hero]!", german="Sehen wir uns das genauer an,\n[hero]!", italian="Andiamo a dare un'occhiata da\nvicino, [hero]!", spanish="Echemos un vistazo más de\ncerca, [hero]."})
  end
  -- message_Close
  pcall(function() GAME:MoveCamera(300, 196, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 280, 204, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(hero, 320, 204, false, 2)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 300, 236, false, 2) end end
  GAME:WaitFrames(3)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 332, 236, false, 2) end end
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(6925) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 5) -- screen_FadeChange vers alpha 128 (assombrissement, adaptation)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wah! It went dark!", french="Ouah! Il fait tout noir, d'un seul\ncoup!", german=" Wah! Es ist dunkel geworden!", italian=" Ah! Si è spenta!", spanish=" ¡Aaah! ¡Se ha oscurecido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wah! It went dark!", french="Ouah! Il fait tout noir, d'un seul\ncoup!", german=" Wah! Es ist dunkel geworden!", italian=" Ah! Si è spenta!", spanish=" ¡Aaah! ¡Se ha oscurecido!"})
  else
  SkySceneKit.say({english=" Wah! It went dark!", french="Ouah! Il fait tout noir, d'un seul\ncoup!", german=" Wah! Es ist dunkel geworden!", italian=" Ah! Si è spenta!", spanish=" ¡Aaah! ¡Se ha oscurecido!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Wait!", french=" Attendez!", german=" Wartet!", italian=" Fermi!", spanish=" ¡Esperad!"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" What?![K] Who are you?!", french=" Quoi?![K] Qui êtes-vous?!", german=" Was?!?[K] Wer seid ihr?!?", italian=" Chi siete?[K] Che ci fate qui?", spanish=" ¡¿Qué?![K] ¡¿Quiénes sois?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Waaah! Where's that voice\ncoming from?", french=" Ouaaah! Qui a dit ça?", german="Waaah! Woher kommt diese\nStimme?", italian=" Aaaah! Chi ha parlato?", spanish=" ¿De dónde viene esa voz?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaah! Who said that?", french=" Ouaaah! Qui a dit ça?", german=" Waaah! Wer hat das gesagt?", italian=" Aaaah! Chi ha parlato?", spanish=" ¿Quién ha dicho eso?"})
  else
  SkySceneKit.say({english=" Waah! Who said that?", french=" Ouaaah! Qui a dit ça?", german=" Waah! Wer hat das gesagt?", italian=" Aaaah! Chi ha parlato?", spanish=" ¿Quién ha hablado?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Why...", french=" Que...", german=" Wieso...", italian=" Perché...", spanish=" ¿Por qué...?"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Why did you come here?!", french=" Que faites-vous ici?!", german=" Wieso seid ihr hier?!?", italian=" Perché siete qui?", spanish=" ¡¿Por qué habéis venido aquí?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Why?[K] We just came to look\nfor a Time Gear!", french="Ce qu'on fait ici?[K] On est juste\nà la recherche d'un Rouage du Temps!", german="Wieso?[K] Wir sind hergekommen,\nweil wir ein Zahnrad der Zeit suchen!", italian="Perché, dici?[K] Siamo venuti a\ncercare l'Ingranaggio del Tempo!", spanish="¿Que por qué?[K] Solo hemos\nvenido a buscar un Engranaje del Tiempo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Why?[K] We just came to look\nfor a Time Gear!", french="Ce qu'on fait ici?[K] On est juste\nà la recherche d'un Rouage du Temps!", german="Wieso?[K] Wir sind hergekommen,\nweil wir ein Zahnrad der Zeit suchen!", italian="Perché, dici?[K] Siamo venuti a\ncercare l'Ingranaggio del Tempo!", spanish="¿Que por qué?[K] Solo hemos\nvenido a buscar un Engranaje del Tiempo."})
  else
  SkySceneKit.say({english="Why?[K] We just came to look\nfor a Time Gear!", french="Ce qu'on fait ici?[K] On est juste\nà la recherche d'un Rouage du Temps!", german="Wieso?[K] Wir sind hergekommen,\nweil wir ein Zahnrad der Zeit suchen!", italian="Perché, dici?[K] Siamo qui per\ncercare l'Ingranaggio del Tempo!", spanish="¿Que por qué?[K] Solo hemos\nvenido a buscar un Engranaje del Tiempo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Stay away from the Time Gear!", french=" Bas les pattes!", german="Haltet euch von dem Zahnrad der Zeit\nfern!", italian=" Non avvicinatevi all'Ingranaggio del Tempo!", spanish=" ¡Apartaos del Engranaje del Tiempo!"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="If you won't leave the Time Gear\nalone...[K]I'll stop you!", french="Laissez ce Rouage du Temps où il est...\nOu sinon...[K] je vous règle votre compte!", german="Wenn ihr das Zahnrad der Zeit nicht\nin Ruhe lasst,[K] dann werde ich euch aufhalten!", italian="Se oserete avvicinarvi all'Ingranaggio del\nTempo...[K] sarà peggio per voi!", spanish="¡Dejadlo donde está![K] De lo contrario,\ntendréis que véroslas conmigo."})
  -- message_Close
  GAME:FadeIn(5) -- screen_FadeChange vers alpha 256 (éclaircissement, adaptation)
  -- GAP: se_Play(7171) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  local npc_npc_emuritto = SkySceneKit.spawn_npc("mesprit", 304, 160, Direction.Down, "NPC_EMURITTO")
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Who...who are you?!", french=" Qui... qui es-tu?!", german=" Wer... Wer bist du?!?", italian=" Chi... sei tu?", spanish=" ¿Quién... quién eres?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Who...who are you?!", french=" Qui... qui es-tu?!", german=" Wer... Wer bist du?!?", italian=" Chi... sei tu?", spanish=" ¿Quién... quién eres?"})
  else
  SkySceneKit.say({english=" Who...who are you?!", french=" Qui... qui es-tu?!", german=" Wer... Wer bist du?!?", italian=" Chi... sei tu?", spanish=" ¿Quién... quién eres?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" I'm [CS:N]Mesprit[CR]!", french=" Je m'appelle [CS:N]Créfollet[CR]!", german=" Ich bin [CS:N]Vesprit[CR]!", italian=" Il mio nome è [CS:N]Mesprit[CR]!", spanish=" Soy [CS:N]Mesprit[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="Here at the deep [CS:P]Underground\nLake[CR], I protect the Time Gear!", french="Je protège le Rouage du Temps\ndu [CS:P]Lac Souterrain[CR]!", german="Ich beschütze hier am\n[CS:P]Untergrundsee[CR] das Zahnrad der Zeit!", italian="Qui, nelle profondità del [CS:P]Lago[CR]\n[CS:P]Sotterraneo[CR], io custodisco l'Ingranaggio\ndel Tempo!", spanish="La guardiana del Engranaje del\nTiempo del [CS:P]Lago Subterráneo[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Protect the Time Gear?!", french="Tu protèges le Rouage\ndu Temps?!", german="Du beschützt das Zahnrad der\nZeit?!?", italian="Custodisci... l'Ingranaggio del\nTempo?", spanish="¡¿Proteges el Engranaje del\nTiempo?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Protect the Time Gear?!", french="Tu protèges le Rouage\ndu Temps?!", german="Du beschützt das Zahnrad der\nZeit?!?", italian="Custodisci... l'Ingranaggio del\nTempo?", spanish="¡¿Proteges el Engranaje del\nTiempo?!"})
  else
  SkySceneKit.say({english=" Protect the Time Gear?!", french="Tu protèges le Rouage\ndu Temps?!", german="Du beschützt das Zahnrad der\nZeit?!?", italian="Custodisci... l'Ingranaggio del\nTempo?", spanish="¡¿Proteges el Engranaje del\nTiempo?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="I won't allow you to disturb the\nTime Gear!", french="Je ne vous laisserai pas\nvous en prendre au Rouage du Temps!", german="Ich erlaube euch nicht, das\nZahnrad der Zeit zu stören!", italian="Non vi permetterò di disturbare\nl'Ingranaggio del Tempo!", spanish="¡Sí, y no pienso permitir que\nos acerquéis a él!"})
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" Get ready!", french=" En garde!", german=" Macht euch bereit!", italian=" In guardia!", spanish=" ¡Preparaos!"})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(23, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
