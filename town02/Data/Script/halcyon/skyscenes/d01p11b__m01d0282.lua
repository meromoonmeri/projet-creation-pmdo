-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11B/m01d0282.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM BGM_MEMORIES_RETURNED non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V01P03B) [décor sub chargé: Sub_v01p03b]
  -- back_SetGround(LEVEL_D01P11B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 33, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- screen2_FlushOut [sub déjà caché]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  -- supervision_SpecialActing(21, 600, 0) [cadrage NDS]
  -- supervision2_SpecialActing(21, 600, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(76) [anim idle native]
  SkySubScreen.Show("v01p03b", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() GAME:MoveCamera(416, 176, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 416, 172, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Waah![K] Someone has collapsed on\nthe sand!", french="Aaah![K] Quelqu'un vient de\ns'effondrer sur le sable!", german="Waah![K] Da ist jemand im Sand\nzusammengebrochen!", italian="Waah![K] Qualcuno è\nsvenuto sulla sabbia!", spanish=" ¡Aaah![K] ¡Alguien se ha desmayado!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Waah![K] Someone has collapsed on\nthe sand!", french="Aaah![K] Quelqu'un vient de\ns'effondrer sur le sable!", german="Waah![K] Da ist jemand im Sand\nzusammengebrochen!", italian="Aaah![K] Qualcuno è\nsvenuto sulla sabbia!", spanish=" ¡Aaah![K] ¡Alguien se ha desmayado!"})
  else
  SkySceneKit.say({english="Waah![K] Someone has collapsed on\nthe sand!", french="Aaah![K] Quelqu'un vient de\ns'effondrer sur le sable!", german="Waah![K] Da ist jemand im Sand\nzusammengebrochen!", italian="Aaah![K] Qualcuno è\nsvenuto sulla sabbia!", spanish=" ¡Aaah![K] ¡Alguien se ha desmayado!"})
  end
  -- message_Close
  pcall(function() GAME:MoveCamera(308, 176, 60, false) end) -- performer/caméra
  -- SetAnimation(1024) [anim idle native]
  GROUND:MoveToPosition(partner, 312, 172, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(768) [anim idle native]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What happened?![K] Are you OK?", french=" Que s'est-il passé?![K] Ça va?", german=" Was ist passiert?!?[K] Alles okay?", italian=" Cos'è successo?![K] Stai bene?", spanish=" ¿Qué ha ocurrido?[K] ¿Estás bien?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What happened?![K] Are you OK?", french=" Que s'est-il passé?![K] Ça va?", german=" Was ist passiert?!?[K] Alles okay?", italian=" Cos'è successo?![K] Stai bene?", spanish=" ¿Qué ha ocurrido?[K] ¿Estás bien?"})
  else
  SkySceneKit.say({english=" What happened?![K] Are you OK?", french=" Que s'est-il passé?![K] Ça va?", german=" Was ist passiert?!?[K] Alles okay?", italian=" Cos'è successo?![K] Stai bene?", spanish=" ¿Qué ha ocurrido?[K] ¿Estás bien?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Show("v01p03b", 0, false) -- screen2_FlushIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(0) -- screen_FlushIn
  -- supervision_SpecialActing(3, 0, 0) [cadrage NDS]
  -- supervision2_SpecialActing(3, 0, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
