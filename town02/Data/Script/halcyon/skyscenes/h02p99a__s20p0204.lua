-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s20p0204.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The next morning...", french="[CN]Le lendemain matin...", german="[CN]Am nächsten Morgen...", italian="[CN]La mattina dopo...", spanish="[CN]Al día siguiente..."})
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:EntTurn(partner, Direction.Left)
  -- SetAnimation(76) [anim idle native]
  -- SetAnimation(76) [anim idle native]
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DO_YOUR_BEST_AS_ALWAYS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(5)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Oh, yeah! The weather's great\ntoday again!", french="Oh, oui! Quel temps magnifique\naujourd'hui!", german="Oh ja! Das Wetter ist heute\nwieder klasse!", italian="Oh, sì! Il tempo è di nuovo\nbello oggi!", spanish=" ¡Hoy hace un tiempo excelente!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh, yeah! The weather's great\ntoday again!", french="Oh, oui! Quel temps magnifique\naujourd'hui!", german="Oh ja! Das Wetter ist heute\nwieder klasse!", italian="Oh, sì! Il tempo è di nuovo\nbello oggi!", spanish=" ¡Hoy hace un tiempo excelente!"})
  else
  SkySceneKit.say({english="Ooh, yes! The weather's great\ntoday again!", french="Oh, oui! Quel temps magnifique\naujourd'hui!", german="Oh ja! Das Wetter ist heute\nwieder klasse!", italian="Oh, sì! Il tempo è di nuovo\nbello oggi!", spanish=" ¡Hoy hace un tiempo excelente!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's do good again today,\n[hero]!", french="Faisons encore de notre mieux\naujourd'hui, [hero]!", german="Lass uns heute unser Bestes\ngeben, [hero]!", italian="Mettiamocela tutta anche oggi,\n[hero]!", spanish="¡Sigamos con nuestras\naventuras, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's do good again today,\n[hero]!", french="Faisons encore de notre mieux\naujourd'hui, [hero]!", german="Lass uns heute unser Bestes\ngeben, [hero]!", italian="Mettiamocela tutta anche oggi,\n[hero]!", spanish="¡Sigamos con nuestras\naventuras, [hero]!"})
  else
  SkySceneKit.say({english="Let's do good again today,\n[hero]!", french="Faisons encore de notre mieux\naujourd'hui, [hero]!", german="Lass uns heute unser Bestes\ngeben, [hero]!", italian="Mettiamocela tutta anche oggi,\n[hero]!", spanish="¡Sigamos con nuestras\naventuras, [hero]!"})
  end
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
