-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D17P11A/m26a06e5.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_MEMORIES_RETURNED non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_D17P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:TeleportTo(hero, 316, 284, Direction.Down)
  GROUND:TeleportTo(partner, 284, 284, Direction.Down)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's roll, [hero]!", french=" On y va, [hero]!", german=" Nichts wie los, [hero]!", italian="Andiamo, [hero]!\nRock'n'roll!", spanish=" ¡Adelante, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go, [hero]!", french=" On y va, [hero]!", german=" Gehen wir, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Adelante, [hero]!"})
  else
  SkySceneKit.say({english=" Let's go, [hero]!", french=" On y va, [hero]!", german=" Gehen wir, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Adelante, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We're off to [CS:N]Azelf[CR]'s lake!", french="En route pour le lac\nde [CS:N]Créfadet[CR]!", german=" Auf zum See von [CS:N]Tobutz[CR]!", italian=" Destinazione: il lago di [CS:N]Azelf[CR]!", spanish=" ¡Vamos al lago de [CS:N]Azelf[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Onward to [CS:N]Azelf[CR]'s lake!", french="En route pour le lac\nde [CS:N]Créfadet[CR]!", german=" Auf zum See von [CS:N]Tobutz[CR]!", italian=" Destinazione: il lago di [CS:N]Azelf[CR]!", spanish=" ¡Vamos al lago de [CS:N]Azelf[CR]!"})
  else
  SkySceneKit.say({english=" We're off to [CS:N]Azelf[CR]'s lake!", french="En route pour le lac\nde [CS:N]Créfadet[CR]!", german=" Auf zum See von [CS:N]Tobutz[CR]!", italian=" Destinazione: il lago di [CS:N]Azelf[CR]!", spanish=" ¡Vamos al lago de [CS:N]Azelf[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:FadeIn(0) -- screen_FlushIn
end
