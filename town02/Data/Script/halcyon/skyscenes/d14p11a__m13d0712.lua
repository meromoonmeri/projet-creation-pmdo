-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D14P11A/m13d0712.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D14P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(This feeling...)", french="(Cette sensation...)", german="(Dieses Gefühl...)", italian="(Questa sensazione...)", spanish="(Esa sensación...)"})
  else
  SkySceneKit.say({english="(This feeling...)", french="(Cette sensation...)", german="(Dieses Gefühl...)", italian="(Questa sensazione...)", spanish="(Esa sensación...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's like the one I got at [CS:P]Fogbound Lake[CR]...)", french="(J'ai ressenti la même chose au [CS:P]Lac\ndes Brumes[CR]...)", german="(Dasselbe hatte ich am [CS:P]Nebelsee[CR].)", italian="(È davvero come quella che ho avuto al [CS:P]Lago[CR]\n[CS:P]Foschia[CR]...)", spanish="(Es como la que tuve en el [CS:P]Lago Velado[CR].)"})
  else
  SkySceneKit.say({english="(It's like the one I got at [CS:P]Fogbound Lake[CR]...)", french="(J'ai ressenti la même chose au [CS:P]Lac\ndes Brumes[CR]...)", german="(Dasselbe hatte ich am [CS:P]Nebelsee[CR].)", italian="(È davvero come quella che ho avuto al [CS:P]Lago[CR]\n[CS:P]Foschia[CR]...)", spanish="(Es como la que tuve en el [CS:P]Lago Velado[CR].)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I...[K]I know this place!)", french="(Je...[K] je connais cet endroit!)", german="(Ich...[K] Ich kenne diesen Ort!)", italian="(Io...[K] sono già stato qui!)", spanish="(Yo...[K] ¡conozco este lugar!)"})
  else
  SkySceneKit.say({english="(I...[K]I know this place!)", french="(Je...[K] je connais cet endroit!)", german="(Ich...[K] Ich kenne diesen Ort!)", italian="(Io...[K] sono già stata qui!)", spanish="(Yo...[K] ¡conozco este lugar!)"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
end
