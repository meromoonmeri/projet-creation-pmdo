-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P09A/m10a1212.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Restored.ogg", true) end)
  -- back_SetGround(LEVEL_V03P09A) [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(360), g.ViewCenter.Y+(360), 120, false) end) -- back_SetBackScrollSpeed(3.0,3.0) px/frame -> caméra continue (pilote scroll)
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- back_SetEffect(7, 0) [transition couches décor NDS immédiate]
  -- back_SetBackEffect(2) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(When I see that Time Gear...)", french="(Quand je le vois...)", german="(Wenn ich das Zahnrad der Zeit sehe...)", italian="(Quando ho visto l'Ingranaggio del Tempo...)", spanish="(Cuando veo ese Engranaje del Tiempo...)"})
  else
  SkySceneKit.say({english="(When I see that Time Gear...)", french="(Quand je le vois...)", german="(Wenn ich das Zahnrad der Zeit sehe...)", italian="(Quando ho visto l'Ingranaggio del Tempo...)", spanish="(Cuando veo ese Engranaje del Tiempo...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Why does my pulse race when I see it?)", french="(Mon cœur se met à battre la chamade!)", german="(Wieso schlägt mein Puls schneller, wenn\nich es ansehe?)", italian="(Perché mi sono sentito così strano?)", spanish="(¿Por qué se me acelera el pulso al mirarlo?)"})
  else
  SkySceneKit.say({english="(Why does my pulse race when I see it?)", french="(Mon cœur se met à battre la chamade!)", german="(Wieso schlägt mein Puls schneller, wenn\nich es ansehe?)", italian="(Perché mi sono sentita così strana?)", spanish="(¿Por qué se me acelera el pulso al mirarlo?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(And this unease I feel...[K] What does it mean?)", french="(Et ce malaise que je ressens...[K] qu'est-ce qu'il\nsignifie?)", german="(Und diese Unruhe, die ich empfinde...[K]\nWas bedeutet das?)", italian="(E questa sensazione spiacevole...[K]\nChe cosa significa?)", spanish="(Y esa sensación de desasosiego...[K]\n¿qué significa?)"})
  else
  SkySceneKit.say({english="(And this unease I feel...[K] What does it mean?)", french="(Et ce malaise que je ressens...[K] qu'est-ce qu'il\nsignifie?)", german="(Und diese Unruhe, die ich empfinde...[K]\nWas bedeutet das?)", italian="(E questa sensazione spiacevole...[K]\nChe cosa significa?)", spanish="(Y esa sensación de desasosiego...[K]\n¿qué significa?)"})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(180) end)
  GAME:FadeOut(false,  90)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
end
