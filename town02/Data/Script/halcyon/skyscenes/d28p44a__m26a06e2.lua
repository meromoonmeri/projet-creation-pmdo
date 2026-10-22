-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D28P44A/m26a06e2.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM BGM_MEMORIES_RETURNED non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(S04P01A) [décor sub chargé: Sub_s04p01a]
  -- back_SetGround(LEVEL_D28P44A) [neutre/état moteur]
  GAME:FadeOut(true, 0) -- screen_WhiteOutAll
  GAME:WaitFrames(1)
  GAME:FadeIn(0)
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:TeleportTo(partner, 276, 220, Direction.Down)
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.Left)
  pcall(function() GAME:MoveCamera(268, 212, 1, false) end) -- SetPositionMark performer/caméra
  -- GAP: SetEffect 653 — VFX sans émote PMDO équivalente
  GAME:FadeOut(false, 0) -- screen_FlushOut
  SkySubScreen.Show("s04p01a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [hero]!", french=" Eh, [hero]!", german=" Hey, [hero]!", italian=" Ehi, [hero]!", spanish=" ¡Oye, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey, [hero]!", french=" Eh, [hero]!", german=" Hey, [hero]!", italian=" Ehi, [hero]!", spanish=" ¡Oye, [hero]!"})
  else
  SkySceneKit.say({english=" Hey, [hero]!", french=" Eh, [hero]!", german=" Hey, [hero]!", italian=" Ehi, [hero]!", spanish=" ¡Oye, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to do this for [CS:N]Grovyle[CR]'s\nsake! Let's go to [CS:P]Temporal Tower[CR]!", french="Il faut qu'on y arrive,\npour [CS:N]Massko[CR]! C'est parti pour la [CS:P]Tour\ndu Temps[CR]!", german="Wir müssen das [CS:N]Reptain[CR] zuliebe\ntun! Gehen wir zum [CS:P]Zeitturm[CR]!", italian="Dobbiamo farlo per [CS:N]Grovyle[CR]!\nAndiamo alla [CS:P]Torre del Tempo[CR]!", spanish="¡Tenemos que hacer esto por\n[CS:N]Grovyle[CR]! ¡Vamos a la [CS:P]Torre del Tiempo[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to do this for [CS:N]Grovyle[CR]'s\nsake! Let's go to [CS:P]Temporal Tower[CR]!", french="Il faut qu'on y arrive,\npour [CS:N]Massko[CR]! C'est parti pour la [CS:P]Tour\ndu Temps[CR]!", german="Wir müssen das [CS:N]Reptain[CR] zuliebe\ntun! Gehen wir zum [CS:P]Zeitturm[CR]!", italian="Dobbiamo farlo per [CS:N]Grovyle[CR]!\nAndiamo alla [CS:P]Torre del Tempo[CR]!", spanish="¡Tenemos que hacer esto por\n[CS:N]Grovyle[CR]! ¡Vamos a la [CS:P]Torre del Tiempo[CR]!"})
  else
  SkySceneKit.say({english="We have to do this for [CS:N]Grovyle[CR]'s\nsake! Let's go to [CS:P]Temporal Tower[CR]!", french="Il faut qu'on y arrive,\npour [CS:N]Massko[CR]! C'est parti pour la [CS:P]Tour\ndu Temps[CR]!", german="Wir müssen das [CS:N]Reptain[CR] zuliebe\ntun! Gehen wir zum [CS:P]Zeitturm[CR]!", italian="Dobbiamo farlo per [CS:N]Grovyle[CR]!\nAndiamo alla [CS:P]Torre del Tempo[CR]!", spanish="¡Tenemos que hacer esto por\n[CS:N]Grovyle[CR]! ¡Vamos a la [CS:P]Torre del Tiempo[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(true, 60) -- screen_WhiteOutAll
  GAME:FadeOut(true, 0) -- screen_WhiteOut
  GAME:FadeIn(0)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
