-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P09A/m11a0703.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  -- back_SetGround(LEVEL_V03P09A) [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(360), g.ViewCenter.Y+(360), 120, false) end) -- back_SetBackScrollSpeed(3.0,3.0) px/frame -> caméra continue (pilote scroll)
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- back_SetEffect(7, 0) [transition couches décor NDS immédiate]
  -- back_SetBackEffect(2) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(When I saw the Time Gear...[K] Why did my\nheart start pounding so wildly...?)", french="(Quand j'ai aperçu le Rouage du Temps...[K]\nPourquoi est-ce que mon cœur s'est mis\nà battre la chamade...?)", german="(Als ich das Zahnrad der Zeit sah...[K]\nWarum hat mein Herz da wie wild gepocht?)", italian="(Quando ho visto l'Ingranaggio del Tempo...[K]\nPerché il mio cuore ha cominciato a battere\ncosì forte...?)", spanish="(Al ver el Engranaje del Tiempo...[K] ¿por qué\nse me puso el corazón a cien?)"})
  else
  SkySceneKit.say({english="(When I saw the Time Gear...[K] Why did my\nheart start pounding so wildly...?)", french="(Quand j'ai aperçu le Rouage du Temps...[K]\nPourquoi est-ce que mon cœur s'est mis\nà battre la chamade...?)", german="(Als ich das Zahnrad der Zeit sah...[K]\nWarum hat mein Herz da wie wild gepocht?)", italian="(Quando ho visto l'Ingranaggio del Tempo...[K]\nPerché il mio cuore ha cominciato a battere\ncosì forte...?)", spanish="(Al ver el Engranaje del Tiempo...[K] ¿por qué\nme empezó a latir tan deprisa el corazón?)"})
  end
  -- message_Close
  GAME:FadeOut(false,  60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
