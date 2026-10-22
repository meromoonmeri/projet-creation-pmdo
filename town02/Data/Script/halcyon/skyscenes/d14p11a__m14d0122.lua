-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D14P11A/m14d0122.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D14P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ready?!", french=" On y va?!", german=" Fertig?!?", italian=" Pronti?", spanish=" ¡Estoy listo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are you ready?!", french=" On y va?!", german=" Bist du so weit?!?", italian=" Pronti?", spanish=" ¡Estoy listo!"})
  else
  SkySceneKit.say({english=" Are you ready?!", french=" On y va?!", german=" Bist du so weit?!?", italian=" Te la senti?", spanish=" ¡Estoy lista!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" One...[K]two...[K]three![K] Go!", french=" Un...[K] deux...[K] trois![K] Banzaï!", german=" Eins...[K] zwei...[K] drei![K] Los!", italian=" Uno...[K] due...[K] tre![K] Andiamo!", spanish="A la de una...[K] A la de dos...[K]\nY a la de tres...[K] ¡Allá vamos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" One...[K]two...[K]three![K] Go!", french=" Un...[K] deux...[K] trois![K] Banzaï!", german=" Eins...[K] zwei...[K] drei![K] Los!", italian=" Uno...[K] due...[K] tre![K] Andiamo!", spanish="A la de una...[K] A la de dos...[K]\nY a la de tres...[K] ¡Allá vamos!"})
  else
  SkySceneKit.say({english=" One...[K]two...[K]three![K] Go!", french=" Un...[K] deux...[K] trois![K] Banzaï!", german=" Eins...[K] zwei...[K] drei![K] Los!", italian=" Uno...[K] due...[K] tre![K] Andiamo!", spanish="A la de una...[K] A la de dos...[K]\nY a la de tres...[K] ¡Allá vamos!"})
  end
  -- message_Close
  GROUND:MoveToPosition(hero, 248, 180, false, 2)
  GROUND:MoveToPosition(partner, 216, 180, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 248, 148, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 216, 148, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(74) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(74) [anim idle native]
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
end
