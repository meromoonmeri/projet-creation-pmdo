-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D20P11A/m18b0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D20P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Sealed Ruin.ogg", true) end)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 256, 212, false, 2)
  GROUND:MoveToPosition(partner, 216, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(360, 212, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 376, 212, false, 2)
  GROUND:MoveToPosition(partner, 344, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Since [CS:N]Grovyle[CR] left, it's been one\nstraight shot without any branching paths.", french="Depuis que [CS:N]Massko[CR] est parti\nseul, la route suit une ligne droite sans\nla moindre bifurcation.", german="Seit [CS:N]Reptain[CR] gegangen ist,\nwar der Weg schnurgerade und ohne\nAbzweigungen.", italian="Da quando [CS:N]Grovyle[CR] se n'è andato,\nabbiamo percorso una strada senza alcun bivio.", spanish="Desde que [CS:N]Grovyle[CR] nos dejó,\nel camino no se ha bifurcado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Since [CS:N]Grovyle[CR] left, it's been one\nstraight shot without any branching paths.", french="Depuis que [CS:N]Massko[CR] est parti\nseul, la route suit une ligne droite sans\nla moindre bifurcation.", german="Seit [CS:N]Reptain[CR] gegangen ist,\nwar der Weg schnurgerade und ohne\nAbzweigungen.", italian="Da quando [CS:N]Grovyle[CR] se n'è andato,\nabbiamo percorso una strada senza alcun bivio.", spanish="Desde que [CS:N]Grovyle[CR] nos dejó,\nel camino no se ha bifurcado."})
  else
  SkySceneKit.say({english="Since [CS:N]Grovyle[CR] left, it's been one\nstraight shot without any branching paths.", french="Depuis que [CS:N]Massko[CR] est parti\nseul, la route suit une ligne droite sans\nla moindre bifurcation.", german="Seit [CS:N]Reptain[CR] gegangen ist,\nwar der Weg schnurgerade und ohne\nAbzweigungen.", italian="Da quando [CS:N]Grovyle[CR] se n'è andato,\nabbiamo percorso una strada senza alcun bivio.", spanish="Desde que [CS:N]Grovyle[CR] nos dejó,\nel camino no se ha bifurcado."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So [CS:N]Grovyle[CR] should be\nahead of us.", french="Il devrait donc être tout droit\ndevant nous.", german="Also müsste [CS:N]Reptain[CR] vor uns\nsein.", italian="Dunque [CS:N]Grovyle[CR] dovrebbe\nessere giusto davanti a noi.", spanish="Así que seguro que podemos\ndar con [CS:N]Grovyle[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So [CS:N]Grovyle[CR] should be ahead of\nus on this same path.", french="Il devrait donc être tout droit\ndevant nous.", german="Also müsste [CS:N]Reptain[CR] auf dem\nselben Weg vor uns sein.", italian="Dunque [CS:N]Grovyle[CR] dovrebbe\nessere giusto davanti a noi.", spanish="Así que seguro que podemos\nencontrar a [CS:N]Grovyle[CR]."})
  else
  SkySceneKit.say({english="So [CS:N]Grovyle[CR] should be\nahead of us.", french="Il devrait donc être tout droit\ndevant nous.", german="Also müsste [CS:N]Reptain[CR] vor uns\nsein.", italian="Dunque [CS:N]Grovyle[CR] dovrebbe\nessere giusto davanti a noi.", spanish="Seguro que aún podemos\nencontrar a [CS:N]Grovyle[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go, [hero]!", french=" Allons-y, [hero]!", german=" Gehen wir, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Vamos, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go, [hero]!", french=" Allons-y, [hero]!", german=" Gehen wir, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Vamos, [hero]!"})
  else
  SkySceneKit.say({english=" Let's go, [hero]!", french=" Allons-y, [hero]!", german=" Gehen wir, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Vamos, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's catch up to [CS:N]Grovyle[CR]!", french=" Rattrapons [CS:N]Massko[CR]!", german=" Lass uns [CS:N]Reptain[CR] einholen!", italian=" Raggiungiamo [CS:N]Grovyle[CR]!", spanish=" ¡Hay que alcanzar a [CS:N]Grovyle[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's catch up to [CS:N]Grovyle[CR]!", french=" Rattrapons [CS:N]Massko[CR]!", german=" Lass uns [CS:N]Reptain[CR] einholen!", italian=" Raggiungiamo [CS:N]Grovyle[CR]!", spanish=" ¡Hay que alcanzar a [CS:N]Grovyle[CR]!"})
  else
  SkySceneKit.say({english=" Let's catch up to [CS:N]Grovyle[CR]!", french=" Rattrapons [CS:N]Massko[CR]!", german=" Lass uns [CS:N]Reptain[CR] einholen!", italian=" Raggiungiamo [CS:N]Grovyle[CR]!", spanish=" ¡Hay que alcanzar a [CS:N]Grovyle[CR]!"})
  end
  -- message_Close
end
