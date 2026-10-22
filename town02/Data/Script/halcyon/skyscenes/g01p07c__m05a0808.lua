-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m05a0808.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(And when we were exploring [CS:P]Waterfall\nCave[CR]!)", french="(Et aussi quand nous avons exploré la [CS:P]Grotte\nCascade[CR]!)", german="(Als wir die [CS:P]Wasserfallhöhle[CR] erkundeten!)", italian="(E quando stavamo esplorando la [CS:P]Grotta della[CR]\n[CS:P]Cascata[CR]!)", spanish="(¡Y cuando explorábamos la [CS:P]Cueva Cascada[CR]!)"})
  else
  SkySceneKit.say({english="(And when we were exploring [CS:P]Waterfall\nCave[CR]!)", french="(Et aussi quand nous avons exploré la [CS:P]Grotte\nCascade[CR]!)", german="(Als wir die [CS:P]Wasserfallhöhle[CR] erkundeten!)", italian="(E quando stavamo esplorando la [CS:P]Grotta della[CR]\n[CS:P]Cascata[CR]!)", spanish="(¡Y cuando explorábamos la [CS:P]Cueva Cascada[CR]!)"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
end
