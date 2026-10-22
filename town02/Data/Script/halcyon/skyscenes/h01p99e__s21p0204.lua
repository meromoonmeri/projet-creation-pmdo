-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99E/s21p0204.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_IN_THE_HANDS_OF_FATE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_H01P99E) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Well...[K]I wonder too.", french="Ben...[K] moi aussi, je me le\ndemande.", german=" Nun...[K] Das frage ich mich auch.", italian=" Beh...[K] Me lo chiedo anch'io.", spanish="Bueno...[K] Yo también me lo\npregunto."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Well...[K]I wonder too.", french="Ben...[K] moi aussi, je me le\ndemande.", german=" Nun...[K] Das frage ich mich auch.", italian=" Beh...[K] Me lo chiedo anch'io.", spanish="Bueno...[K] Yo también me lo\npregunto."})
  else
  SkySceneKit.say({english=" Well...[K]I wonder too.", french="Ben...[K] moi aussi, je me le\ndemande.", german=" Nun...[K] Das frage ich mich auch.", italian=" Beh...[K] Me lo chiedo anch'io.", spanish="Bueno...[K] Yo también me lo\npregunto."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I really don't know...", french=" Je n'en ai aucune idée...", german=" Ich weiß es wirklich nicht...", italian=" Non lo so davvero...", spanish=" La verdad es que no lo sé..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I really don't know...", french=" Je n'en ai aucune idée...", german=" Ich weiß es wirklich nicht...", italian=" Non lo so davvero...", spanish=" La verdad es que no lo sé..."})
  else
  SkySceneKit.say({english=" I really don't know...", french=" Je n'en ai aucune idée...", german=" Ich weiß es wirklich nicht...", italian=" Non lo so davvero...", spanish=" La verdad es que no lo sé..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But maybe...", french=" Mais peut-être...", german=" Aber vielleicht...", italian=" Forse, però...", spanish=" Pero tal vez..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But maybe...", french=" Mais peut-être...", german=" Aber vielleicht...", italian=" Forse, però...", spanish=" Pero tal vez..."})
  else
  SkySceneKit.say({english=" But maybe...", french=" Mais peut-être...", german=" Aber vielleicht...", italian=" Forse, però...", spanish=" Pero tal vez..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Maybe it was because\n[hero] stood by me.", french="Peut-être que c'est grâce à\nla présence de [hero] à mes côtés.", german="Vielleicht war es, weil\n[hero] mir beigestanden hat.", italian="Forse perché [hero] era\nal mio fianco.", spanish="Tal vez se debió a que\n[hero] estaba allí conmigo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Maybe it was because\n[hero] stood by me.", french="Peut-être que c'est grâce à\nla présence de [hero] à mes côtés.", german="Vielleicht war es, weil\n[hero] mir beigestanden hat.", italian="Forse perché [hero] era\nal mio fianco.", spanish="Tal vez se debió a que\n[hero] estaba allí conmigo."})
  else
  SkySceneKit.say({english="Maybe it was because\n[hero] stood by me.", french="Peut-être que c'est grâce à\nla présence de [hero] à mes côtés.", german="Vielleicht war es, weil\n[hero] mir beigestanden hat.", italian="Forse perché [hero] era\nal mio fianco.", spanish="Tal vez se debió a que\n[hero] estaba allí conmigo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 224, 168, Direction.UpLeft, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" [hero]...?", french=" [hero]...?", german=" [hero]?", italian=" [hero]?", spanish=" ¿[hero]?"})
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
