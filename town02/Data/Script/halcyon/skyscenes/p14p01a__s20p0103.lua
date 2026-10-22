-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P14P01A/s20p0103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_P14P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Why can't I evolve?", french="Pourquoi je ne peux pas\névoluer?", german="Warum kann ich mich nicht\nentwickeln?", italian=" Perché io non posso?", spanish="¿Por qué yo no puedo\nevolucionar?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Why can't I evolve?", french="Pourquoi je ne peux pas\névoluer?", german="Warum kann ich mich nicht\nentwickeln?", italian=" Perché io non posso?", spanish="¿Por qué yo no puedo\nevolucionar?"})
  else
  SkySceneKit.say({english=" Why can't I evolve?", french="Pourquoi je ne peux pas\névoluer?", german="Warum kann ich mich nicht\nentwickeln?", italian=" Perché io non posso?", spanish="¿Por qué yo no puedo\nevolucionar?"})
  end
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]Why can you not evolve...?", french="[CN]Pourquoi ne peux-tu pas évoluer...?", german="[CN]Warum du dich nicht entwickeln kannst?", italian="[CN]Perché non puoi evolverti?", spanish="[CN]¿Que por qué no puedes evolucionar tú?"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]It may be influenced by a distortion\n[CN]in the fabric of space...", french="[CN]Peut-être est-ce dû à une distorsion\n[CN]dans la trame de l'espace...", german="[CN]Vielleicht hat die Verzerrung des\n[CN]Raumgefüges etwas damit zu tun...", italian="[CN]Potrebbe essere dovuto a una\n[CN]distorsione della struttura dello spazio...", spanish="[CN]Podría deberse a\n[CN]una deformación del espacio..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Distortion?[K] The fabric of space?", french="Une distorsion?[K] Dans la trame\nde l'espace?", german=" Verzerrung?[K] Das Raumgefüge?", italian="Distorsione?[K] Della struttura\ndello spazio?", spanish=" ¿Deformación?[K] ¿Del espacio?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Distortion?[K] The fabric of space?", french="Une distorsion?[K] Dans la trame\nde l'espace?", german=" Verzerrung?[K] Das Raumgefüge?", italian="Distorsione?[K] Della struttura\ndello spazio?", spanish=" ¿Deformación?[K] ¿Del espacio?"})
  else
  SkySceneKit.say({english=" Distortion?[K] The fabric of space?", french="Une distorsion?[K] Dans la trame\nde l'espace?", german=" Verzerrung?[K] Das Raumgefüge?", italian="Distorsione?[K] Della struttura\ndello spazio?", spanish=" ¿Deformación?[K] ¿Del espacio?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]Why that should be, I do not know...", french="[CN]Quelle en est la cause, je l'ignore...", german="[CN]Ich weiß nicht, warum das so sein könnte...", italian="[CN]Il motivo, non lo conosco...", spanish="[CN]No sé por qué..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]But your presence...[K]is somehow related\n[CN]to the distortion of space itself.", french="[CN]Mais ta présence...[K] est liée\n[CN]à la distorsion elle-même.", german="[CN]Aber deine Existenz...[K] Sie hängt\n[CN]irgendwie mit der Verzerrung des Raumes\n[CN]selbst zusammen.", italian="[CN]Tuttavia, la tua presenza...[K] è in qualche modo\n[CN]collegata alla distorsione dello spazio.", spanish="[CN]Pero tu presencia...[K] está de algún modo\n[CN]relacionada con la deformación del espacio."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]And as a result of that,\n[CN]you cannot evolve...", french="[CN]Il en résulte que\n[CN]tu ne peux évoluer...", german="[CN]Und als Folge daraus\n[CN]kannst du dich nicht entwickeln...", italian="[CN]Di conseguenza,\n[CN]non puoi evolverti...", spanish="[CN]Y por eso...\n[CN]no puedes evolucionar."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]No.[K] It is not only you...[K]\n[CN]There is yet another...", french="[CN]Non.[K] Pas seulement toi...[K]\n[CN]Il y a encore quelqu'un d'autre...", german="[CN]Nein.[K] Es trifft nicht nur dich...[K]\n[CN]Es gibt noch ein anderes Pokémon...", italian="[CN]No.[K] Non sei solo tu.[K]\n[CN]C'è un altro Pokémon...", spanish="[CN]Y...[K] no solo tú...[K]\n[CN]Hay alguien más..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]The one behind you...[K]is also\n[CN]forbidden its evolution.", french="[CN]Le Pokémon derrière toi...[K] est\n[CN]également interdit d'évolution.", german="[CN]Das Pokémon hinter dir...[K] Auch ihm\n[CN]bleibt eine Entwicklung versagt.", italian="[CN]Quello dietro di te...[K] anche a quel Pokémon\n[CN]l'evoluzione è preclusa.", spanish="[CN]Detrás de ti...[K] Ese Pokémon\n[CN]tampoco puede evolucionar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  local npc_npc_ringuma = SkySceneKit.spawn_npc("ursaring", 336, 248, Direction.UpLeft, "NPC_RINGUMA")
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "shock", 1) end)
  local npc_npc_ringuma2 = SkySceneKit.spawn_npc("ursaring", 272, 248, Direction.UpRight, "NPC_RINGUMA2")
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma2, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Down)
  GROUND:EntTurn(npc_npc_ringuma, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_ringuma2, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?! [hero] too?!", french=" Hein?! [hero] aussi?!", german=" Huch?!? [hero] auch?!?", italian=" Eh?! Anche [hero]?!", spanish="¡¿Quéee?! ¿[hero]\ntampoco?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?! [hero] too?!", french=" Hein?! [hero] aussi?!", german=" Was?!? [hero] auch?!?", italian=" Cosa?! Anche [hero]?!", spanish="¡¿Quéee?! ¿[hero]\ntampoco?"})
  else
  SkySceneKit.say({english=" What?! [hero] too?!", french=" Hein?! [hero] aussi?!", german=" Was?!? [hero] auch?!?", italian=" Cosa?! Anche [hero]?!", spanish="¡¿Quéee?! ¿[hero]\ntampoco?"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
