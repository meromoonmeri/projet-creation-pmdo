-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D07P11A/m08b1201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 328, 208, Direction.UpRight, "NPC_BIPPA")
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Ugh... We couldn't get through\nthere...", french=" Argh... On y est pas arrivés...", german="Uff... Wir haben es nicht\ngeschafft.", italian="Ugh... Non siamo riusciti a\npassare...", spanish="Vaya mala pata, no hemos\nconseguido pasar."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D07P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_D07P11A, 'UM08') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Mt. Horn.ogg", true) end)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(9) -- Unlock(9) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(15)
  GROUND:EntTurn(partner, Direction.Down)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpRight)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hmm... We were maybe a little\ncareless.", french="Hmm... On aurait dû être plus\nprudents...", german="Hmm... Vielleicht waren wir\nein bisschen leichtsinnig.", italian="Forse siamo stati troppo\nspericolati.", spanish="Hum. Creo que nos hemos\nconfiado más de la cuenta."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hmm... I think we may have\nbeen a little careless.", french="Hmm... On aurait dû être plus\nprudents...", german="Hmm... Ich glaube, wir waren\nvielleicht ein bisschen leichtsinnig.", italian="Forse siamo stati troppo\nspericolati.", spanish="Hum. Tal vez nos hemos\nconfiado más de la cuenta."})
  else
  SkySceneKit.say({english="Hmm... We got maybe a little\ncareless.", french="Hmm... On aurait dû être plus\nprudents...", german="Hmm... Vielleicht waren wir\netwas zu leichtsinnig.", italian="Forse siamo stati troppo\nspericolati.", spanish="Hum. Supongo que nos hemos\nconfiado más de la cuenta."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_bippa, 4) end)
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="But...[K] I'm not giving up.[K]\nLet's get it done!", french="Mais...[K] pas question\nd'abandonner.[K] Faut accomplir not' mission!", german="Aber...[K] Ich gebe nicht auf![K]\nWir schaffen das!", italian="Però...[K] non ho intenzione\ndi arrendermi.[K] Dobbiamo farcela!", spanish="Pero...[K] Yo no pienso rendirme.[K]\n¡A por ello!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Down)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup![K] Let's get it done!", french=" Oui![K] Finissons-en!", german=" Ja![K] Wir schaffen das!", italian=" Già![K] Dobbiamo farcela!", spanish=" ¡Sí![K] ¡Venga!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes![K] Let's get it done!", french=" Oui![K] Finissons-en!", german=" Ja![K] Wir schaffen das!", italian=" Sì![K] Dobbiamo farcela!", spanish=" ¡Sí![K] ¡Vamos!"})
  else
  SkySceneKit.say({english=" Yup![K] Let's get it done!", french=" Oui![K] Finissons-en!", german=" Ja![K] Wir schaffen das!", italian=" Sì![K] Dobbiamo farcela!", spanish=" ¡Sí![K] ¡Adelante!"})
  end
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
