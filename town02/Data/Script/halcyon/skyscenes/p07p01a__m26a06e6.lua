-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P07P01A/m26a06e6.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM BGM_MEMORIES_RETURNED non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V17P01A) [décor sub chargé: Sub_v17p01a]
  -- back_SetGround(LEVEL_P07P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera2_SetPositionMark(Position<'m0', 21, 21.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(180, 380, 1, false) end) -- SetPositionMark performer/caméra
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 120, 376, Direction.Left, "NPC_JUPUTORU")
  -- Destroy() [neutre/état moteur]
  GROUND:TeleportTo(hero, 208, 396, Direction.Down)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:TeleportTo(partner, 120, 396, Direction.Down)
  SkySceneKit.offset_pos(partner, 28, 0)
  GAME:FadeOut(false, 0) -- screen_FlushOut
  SkySubScreen.Show("v17p01a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(24), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [hero].", french=" [hero].", german=" [hero].", italian=" [hero].", spanish=" [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [hero].", french=" [hero].", german=" [hero].", italian=" [hero].", spanish=" [hero]..."})
  else
  SkySceneKit.say({english=" [hero].", french=" [hero].", german=" [hero].", italian=" [hero].", spanish=" [hero]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to...[K] We have to\nget back!", french=" Il faut...[K] il faut qu'on rentre!", german="Wir müssen...[K] Wir müssen\nwieder zurück!", italian="Dobbiamo...[K] Dobbiamo tornare\nindietro!", spanish="Tenemos que...[K]\n¡Tenemos que regresar!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to...[K] We have to\nget back!", french=" Il faut...[K] il faut qu'on rentre!", german="Wir müssen...[K] Wir müssen\nwieder zurück!", italian="Dobbiamo...[K] Dobbiamo tornare\nindietro!", spanish="Tenemos que...[K]\n¡Tenemos que regresar!"})
  else
  SkySceneKit.say({english="We have to...[K] We have to\nget back!", french=" Il faut...[K] il faut qu'on rentre!", german="Wir müssen...[K] Wir müssen\nwieder zurück!", italian="Dobbiamo...[K] Dobbiamo tornare\nindietro!", spanish="Tenemos que...[K]\n¡Tenemos que regresar!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Back to our own world!", french=" Qu'on rentre dans notre monde!", german=" Zurück in unsere Zeit!", italian=" Nel nostro mondo!", spanish="¡Hay que volver a nuestro\nmundo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Back to our own world!", french=" Qu'on rentre dans notre monde!", german=" Zurück in unsere Zeit!", italian=" Nel nostro mondo!", spanish="¡Hay que volver a nuestro\nmundo!"})
  else
  SkySceneKit.say({english=" Back to our own world!", french=" Qu'on rentre dans notre monde!", german=" Zurück in unsere Zeit!", italian=" Nel nostro mondo!", spanish="¡Hay que volver a nuestro\nmundo!"})
  end
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
