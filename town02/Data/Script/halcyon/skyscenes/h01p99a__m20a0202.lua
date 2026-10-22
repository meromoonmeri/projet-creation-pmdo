-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99A/m20a0202.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_H01P99A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(90)
  pcall(function() GAME:MoveCamera(368, 188, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 336, 180, false, 2)
  GAME:WaitFrames(40)
  GROUND:MoveToPosition(hero, 368, 188, false, 2)
  GAME:WaitFrames(20)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 496, 208, Direction.Left, "NPC_JUPUTORU")
  GROUND:MoveToPosition(npc_npc_juputoru, 408, 204, false, 2)
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This cliff is known as\nSharpedo Bluff.", french="Cet endroit s'appelle la Falaise\nSharpedo.", german="Diesen Felsvorsprung nennt man\nTohaido-Klippe.", italian="Questa scogliera si chiama\nPromontorio Sharpedo.", spanish="Este acantilado es conocido\ncomo el Risco Sharpedo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This cliff is known as\nSharpedo Bluff.", french="Cet endroit s'appelle la Falaise\nSharpedo.", german="Diesen Felsvorsprung nennt man\nTohaido-Klippe.", italian="Questa scogliera si chiama\nPromontorio Sharpedo.", spanish="Este acantilado es conocido\ncomo el Risco Sharpedo."})
  else
  SkySceneKit.say({english="This cliff is known as\nSharpedo Bluff.", french="Cet endroit s'appelle la Falaise\nSharpedo.", german="Diesen Felsvorsprung nennt man\nTohaido-Klippe.", italian="Questa scogliera si chiama\nPromontorio Sharpedo.", spanish="Este acantilado es conocido\ncomo el Risco Sharpedo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Sharpedo Bluff?", french=" La Falaise Sharpedo?", german=" Tohaido-Klippe?", italian=" Promontorio Sharpedo?", spanish=" ¿El Risco Sharpedo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yup.[K] I think they call it that\nbecause the cliff itself is shaped like a\nPokémon named [CS:N]Sharpedo[CR].", french="Ouaip.[K] Je crois qu'elle doit\nson nom à un Pokémon appelé [CS:N]Sharpedo[CR].\nElle a la même forme que lui.", german="Jep.[K] Ich glaube, sie heißt so,\nweil sie die Form eines Pokémon namens\n[CS:N]Tohaido[CR] hat.", italian="Già.[K] Penso l'abbiano chiamata\ncosì perché questa scogliera ha la forma di\nun Pokémon chiamato [CS:N]Sharpedo[CR].", spanish="Sí.[K] Creo que lo llaman así\nporque la pared del acantilado tiene\nla forma del Pokémon [CS:N]Sharpedo[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yes.[K] I think the name comes\nfrom the fact that the cliff itself is shaped\nlike a Pokémon named [CS:N]Sharpedo[CR].", french="Ouaip.[K] Je crois qu'elle doit\nson nom à un Pokémon appelé [CS:N]Sharpedo[CR].\nElle a la même forme que lui.", german="Ja.[K] Ich denke, der Name kommt\ndaher, dass die Klippe die Form eines Pokémon\nmit dem Namen [CS:N]Tohaido[CR] hat.", italian="Sì.[K] Penso l'abbiano chiamata\ncosì perché questa scogliera ha la forma\ndi un Pokémon di nome [CS:N]Sharpedo[CR].", spanish="Sí.[K] Creo que lo llaman así\nporque la pared del acantilado tiene\nla forma del Pokémon [CS:N]Sharpedo[CR]."})
  else
  SkySceneKit.say({english="Yep![K] I think it's called that\nbecause the cliff is shaped like a Pokémon\nnamed [CS:N]Sharpedo[CR].", french="Ouaip.[K] Je crois qu'elle doit\nson nom à un Pokémon appelé [CS:N]Sharpedo[CR].\nElle a la même forme que lui.", german="Jep.[K] Ich glaube, sie heißt so,\nweil sie die Form eines Pokémon namens\n[CS:N]Tohaido[CR] hat.", italian="Già.[K] Penso l'abbiano chiamata\ncosì perché questa scogliera ha la forma di\nun Pokémon chiamato [CS:N]Sharpedo[CR].", spanish="Sí.[K] Creo que lo llaman así\nporque la pared del acantilado tiene\nla forma del Pokémon [CS:N]Sharpedo[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="As far as I can tell...[K]nothing\nseems out of the ordinary.", french="A première vue...[K] tout a l'air\nnormal.", german="Soweit ich sehe,[K] scheint nichts\nungewöhnlich zu sein.", italian="A quanto vedo...[K]\nmi sembra non ci sia nulla di strano.", spanish="Aunque yo, la verdad...[K] no le\nveo el parecido."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="As far as I can tell...[K]nothing\nseems out of the ordinary.", french="A première vue...[K] tout a l'air\nnormal.", german="Soweit ich sehe,[K] scheint nichts\nungewöhnlich zu sein.", italian="A quanto vedo...[K]\nmi sembra non ci sia nulla di strano.", spanish="Aunque yo, la verdad...[K] no le\nveo el parecido."})
  else
  SkySceneKit.say({english="As far as I can tell...[K]nothing\nseems out of the ordinary.", french="A première vue...[K] tout a l'air\nnormal.", german="Soweit ich sehe,[K] scheint nichts\nungewöhnlich zu sein.", italian="A quanto vedo...[K]\nmi sembra non ci sia nulla di strano.", spanish="Aunque yo, la verdad...[K] no le\nveo el parecido."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 312, 148, false, 2)
  GAME:WaitFrames(10)
  pcall(function() GAME:MoveCamera(272, 188, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 312, 172, false, 2)
  GROUND:MoveToPosition(npc_npc_juputoru, 296, 188, false, 2)
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  -- GAP: se_Play(7450) — id SE NDS sans portage PMDO identifié
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(60)
  GAME:WaitFrames(2) -- join WaitSe
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's down here.", french=" C'est par ici, en bas.", german=" Es ist hier unten.", italian=" È qui sotto.", spanish=" Es por aquí abajo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's down here.", french=" C'est par ici, en bas.", german=" Es ist hier unten.", italian=" È qui sotto.", spanish=" Es por aquí abajo."})
  else
  SkySceneKit.say({english=" It's down here.", french=" C'est par ici, en bas.", german=" Es ist hier unten.", italian=" È qui sotto.", spanish=" Es por aquí abajo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This is where I lived before I\njoined the guild.", french="C'est là que je vivais avant\nde rejoindre la Guilde.", german="Hier habe ich gewohnt, bevor\nich der Gilde beigetreten bin.", italian="Prima di unirmi alla Gilda vivevo\nqui.", spanish="Aquí era donde vivía antes de\nunirme al [CS:N]Pokégremio[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I lived here before I joined\nthe guild.", french="C'est là que je vivais avant\nde rejoindre la Guilde.", german="Hier habe ich gelebt, bevor\nich der Gilde beigetreten bin.", italian="Prima di unirmi alla Gilda vivevo\nqui.", spanish="Aquí era donde vivía antes de\nunirme al [CS:N]Pokégremio[CR]."})
  else
  SkySceneKit.say({english="I lived here before I joined\nthe guild.", french="C'est là que je vivais avant\nde rejoindre la Guilde.", german="Hier habe ich gelebt, bevor\nich der Gilde beigetreten bin.", italian="Prima di unirmi alla Gilda vivevo\nqui.", spanish="Aquí era donde vivía antes de\nunirme al [CS:N]Pokégremio[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Go on...go in.", french=" Allez-y... entrez.", german=" Kommt schon... Geht nur hinein.", italian=" Forza... Entrate.", spanish=" Adelante... entrad."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Go ahead...go in.", french=" Allez-y... entrez.", german=" Nur zu... Geht hinein.", italian=" Avanti... Entrate.", spanish=" Adelante... entrad."})
  else
  SkySceneKit.say({english=" Go on, after you.", french=" Allez-y... entrez.", german=" Nur zu, nach euch.", italian=" Avanti, dopo di voi.", spanish=" Adelante... entrad."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(0), p.Y+(-32), false, 2) end
  GROUND:MoveToPosition(npc_npc_juputoru, 276, 156, false, 2)
  -- Destroy() [neutre/état moteur]
  -- ResetHitAttribute(31) [neutre/état moteur]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-16), p.Y+(-16), false, 2) end
  GROUND:MoveToPosition(hero, 276, 156, false, 2)
  -- Destroy() [neutre/état moteur]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-8), p.Y+(8), false, 2) end
  GROUND:MoveToPosition(partner, 276, 156, false, 2)
  -- Destroy() [neutre/état moteur]
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
