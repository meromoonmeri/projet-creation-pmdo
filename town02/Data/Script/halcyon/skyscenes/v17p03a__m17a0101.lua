-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V17P03A/m17a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetBanner2(LEVEL_S04P01A, 0, 156, 124, 14) [bannière 2e écran NDS: information dupliquée du menu, hors canvas unique - documenté]
  GAME:FadeIn(45)
  GAME:WaitFrames(160)
  GAME:FadeOut(false, 45)
  GAME:WaitFrames(15)
  SkyProg.set(18, 1) -- $SCENARIO_MAIN = scn[18,1] (ROM)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="..................", french="..................", german="..................", italian="..................", spanish="..."})
  else
  SkySceneKit.say({english="..................", french="..................", german="..................", italian="..................", spanish="... ..."})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="....................................", french="....................................", german="....................................", italian="....................................", spanish="... ... ..."})
  else
  SkySceneKit.say({english="....................................", french="....................................", german="....................................", italian="....................................", spanish="... ... ... ..."})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="...Ugh...", french="... Argh...", german="...Argh...", italian="... Oooh...", spanish="(Ay...)"})
  else
  SkySceneKit.say({english="...Ugh...", french="... Argh...", german="...Argh...", italian="... Oooh...", spanish="(Ay...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="Where is this...?", french="Où suis-je...?", german="Wo bin ich?", italian="Dove...?", spanish="(¿Dónde estoy?)"})
  else
  SkySceneKit.say({english="Where is this...?", french="Où suis-je...?", german="Wo bin ich?", italian="Dove...?", spanish="(¿Dónde estoy?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="I was...[K]dragged?", french="On m'a...[K] traîné jusqu'ici?", german="Wurde ich...[K] mitgerissen?", italian="Dove...[K] mi trovo?", spanish="(Me...[K] ¿Me han arrastrado?)"})
  else
  SkySceneKit.say({english="I was...[K]dragged?", french="On m'a...[K] traînée jusqu'ici?", german="Wurde ich...[K] mitgerissen?", italian="Dove...[K] mi trovo?", spanish="(Me...[K] ¿Me han arrastrado?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="I can't... Losing consciousness...again...", french="Je ne peux... je vais m'évanouir... encore...", german="Ich kann nicht... Werde wieder ohnmächtig...", italian="Devo... tenere gli occhi aperti...", spanish="(No puedo... volver a perder... la\nconsciencia...)"})
  else
  SkySceneKit.say({english="I can't... Losing consciousness...again...", french="Je ne peux... je vais m'évanouir... encore...", german="Ich kann nicht... Werde wieder ohnmächtig...", italian="Devo... tenere gli occhi aperti...", spanish="(No puedo... volver a perder... la\nconsciencia...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="........................", french="........................", german="........................", italian="........................", spanish="..."})
  else
  SkySceneKit.say({english="........................", french="........................", german="........................", italian="........................", spanish="..."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  GAME:WaitFrames(30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V17P01A) [décor sub chargé: Sub_v17p01a]
  -- back_SetGround(LEVEL_V17P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 17, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_ON_THE_CEILING non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v17p01a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(60)
  GAME:WaitFrames(180)
  GAME:WaitFrames(90)
  GAME:FadeOut(false, 60)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
