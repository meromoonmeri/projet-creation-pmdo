-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D04P11A/m05d0335.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D04P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I need to...[K]summon my courage!", french="Il faut que...[K] je prenne\nmon courage à deux mains!", german="Ich muss[K] meinen ganzen Mut\nzusammennehmen!", italian=" Devo...[K] farmi coraggio!", spanish=" Necesito...[K] ¡armarme de valor!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Be brave...[K] Be the bravest ever!", french="Il faut que...[K] je prenne\nmon courage à deux mains!", german="Sei tapfer...[K] Sei so tapfer wie\nnoch nie!", italian="Sii coraggioso...[K] Sii il più\ncoraggioso di tutti!", spanish="Debo ser valiente...[K]\n¡El más valiente!"})
  else
  SkySceneKit.say({english=" Be brave...[K] Use all your courage!", french=" Il faut que...[K] je sois courageuse!", german="Sei tapfer...[K] Nimm all deinen\nMumm zusammen!", italian="Sii coraggiosa...[K] Sii la più\ncoraggiosa di tutti!", spanish="Debo ser valiente...[K]\n¡Tengo que echarle coraje!"})
  end
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
end
