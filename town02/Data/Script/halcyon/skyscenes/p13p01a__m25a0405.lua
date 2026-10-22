-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P13P01A/m25a0405.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- back_SetGround(LEVEL_P13P01A) [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-600), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(-5.0,0.0) px/frame -> caméra continue (pilote scroll)
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's not far now, [hero].", french="Ce n'est plus très loin,\n[hero].", german="Es ist nicht mehr weit,\n[hero].", italian="Non manca più molto,\n[hero].", spanish="Enseguida llegaremos,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're nearly there,\n[hero].", french="Ce n'est plus très loin,\n[hero].", german=" Wir sind fast da, [hero].", italian=" Ci siamo quasi, [hero].", spanish=" Ya casi estamos, [hero]."})
  else
  SkySceneKit.say({english="We're getting close,\n[hero].", french="Ce n'est plus très loin,\n[hero].", german="Wir kommen näher,\n[hero].", italian="Ci stiamo avvicinando,\n[hero].", spanish="Nos estamos acercando,\n[hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" There's no turning back now.", french="Plus question de rebrousser\nchemin.", german=" Jetzt gibt es kein Zurück mehr.", italian=" Dobbiamo mettercela tutta.", spanish=" Ya no hay marcha atrás."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" There's no turning back now.", french="Plus question de rebrousser\nchemin.", german=" Jetzt gibt es kein Zurück mehr.", italian=" Dobbiamo mettercela tutta.", spanish=" Ya no hay marcha atrás."})
  else
  SkySceneKit.say({english=" There's no turning back now.", french="Plus question de rebrousser\nchemin.", german=" Jetzt gibt es kein Zurück mehr.", italian=" Dobbiamo mettercela tutta.", spanish=" Ya no hay marcha atrás."})
  end
  -- message_Close
  GAME:WaitFrames(90)
  -- back_SetBackScrollSpeed(0,0): arrêt du défilement
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! Up there...", french=" Eh, regarde là-haut...", german=" Hey! Da oben...", italian=" Ehi! Lassù...", spanish=" Fíjate allí arriba."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! Up there...", french=" Eh, regarde là-haut...", german=" Hey! Da oben...", italian=" Ehi! Lassù...", spanish=" Fíjate allí arriba."})
  else
  SkySceneKit.say({english=" Oh! Up there...", french=" Eh, regarde là-haut...", german=" Oh! Da oben...", italian=" Ehi! Lassù...", spanish=" Fíjate allí arriba."})
  end
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V25P02A) [décor sub chargé: Sub_v25p02a]
  -- camera2_SetPositionMark(Position<'m0', 20, 12.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v25p02a", 15, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The top of [CS:P]Temporal Tower[CR] is\nglowing red...[K] What's that about?", french="Il y a un halo rouge au sommet\nde la [CS:P]Tour du Temps[CR]...[K] Qu'est-ce que c'est?", german="Die Spitze des [CS:P]Zeitturms[CR]\nglüht rot...[K] Was hat das zu bedeuten?", italian="La cima della [CS:P]Torre del Tempo[CR]\nemette una luce rossa...[K] Di cosa si tratta?", spanish="La parte superior de la [CS:P]Torre[CR]\n[CS:P]del Tiempo[CR] tiene un extraño brillo rojizo...[K]\n¿Por qué será?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The top of [CS:P]Temporal Tower[CR] is\nglowing red...[K] What could that be?", french="Il y a un halo rouge au sommet\nde la [CS:P]Tour du Temps[CR]...[K] Qu'est-ce que c'est?", german="Die Spitze des [CS:P]Zeitturms[CR]\nglüht rot...[K] Was könnte das sein?", italian="La cima della [CS:P]Torre del Tempo[CR]\nemette una luce rossa...[K] Cosa potrebbe\nessere?", spanish="La parte superior de la [CS:P]Torre[CR]\n[CS:P]del Tiempo[CR] tiene un extraño brillo rojizo...[K]\n¿Por qué será?"})
  else
  SkySceneKit.say({english="The top of [CS:P]Temporal Tower[CR] is\nglowing red...[K] Why is that?", french="Il y a un halo rouge au sommet\nde la [CS:P]Tour du Temps[CR]...[K] Qu'est-ce que c'est?", german="Die Spitze des [CS:P]Zeitturms[CR]\nglüht rot...[K] Warum nur?", italian="La cima della [CS:P]Torre del Tempo[CR]\nemette una luce rossa...[K] Come mai?", spanish="La parte superior de la [CS:P]Torre[CR]\n[CS:P]del Tiempo[CR] tiene un extraño brillo rojizo...[K]\n¿Por qué será?"})
  end
  -- message_Close
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's move it!", french=" Dépêchons-nous!", german=" Setzen wir uns in Bewegung!", italian=" Muoviamoci!", spanish=" ¡Adelante!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's hustle!", french=" Dépêchons-nous!", german=" Machen wir Dampf!", italian=" Sbrighiamoci!", spanish=" ¡Adelante!"})
  else
  SkySceneKit.say({english=" Let's hurry!", french=" Dépêchons-nous!", german=" Beeilen wir uns!", italian=" Presto!", spanish=" ¡Adelante!"})
  end
  -- message_Close
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-120), p.Y+(-20), false, 2) end -- Move2PositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-120), p.Y+(-20), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
