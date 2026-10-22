-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D56P21A/n06a3101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=45, sub=11} -- $SCENARIO_SIDE = scn[45,11] (ROM)
  -- back_SetGround(LEVEL_D56P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 208, 424, Direction.Down, "NPC_CHAAREMU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 256, 424, Direction.Left, "NPC_SAANAITO")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DEEP_LIMESTONE_CAVERN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 228, 276, false, 2)
  GAME:WaitFrames(9)
  GROUND:MoveToPosition(npc_npc_chaaremu, 204, 308, false, 2)
  GAME:WaitFrames(12)
  GROUND:MoveToPosition(npc_npc_saanaito, 252, 308, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(6)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(9)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(3)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="We've come pretty far, haven't\nwe?", french="Nous avons bien progressé,\nn'est-ce pas?", german="Wir sind schon ziemlich weit\ngekommen, nicht wahr?", italian="Abbiamo fatto parecchia strada,\nnon è vero?", spanish=" Hemos avanzado bastante, ¿no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chaaremu, Direction.UpLeft)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="I wonder where\n[CS:N]Wigglytuff[CR] went.", french="Je me demande où est passé\n[CS:N]Grodoudou[CR]...", german="Ich frage mich, wo [CS:N]Knuddeluff[CR]\nwohl hingelaufen ist?!?", italian=" Chissà dov'è finito [CS:N]Wigglytuff[CR]...", spanish="Me pregunto dónde se habrá\nmetido [CS:N]Wigglytuff[CR]."})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Maybe farther ahead?", french="Peut-être un peu plus loin\npar là...", german=" Vielleicht noch weiter voraus?", italian=" Forse è più avanti...", spanish=" ¿Estará más adelante?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_saanaito, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Yeah.[K] Maybe...", french=" Ouais.[K] Possible...", german=" Ja.[K] Vielleicht...", italian=" Sì.[K] Forse...", spanish=" No sé.[K] A lo mejor..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Or maybe we're already\nahead of him.", french=" Ou alors, on l'a déjà dépassé.", german="Vielleicht haben wir ihn aber\nauch schon überholt.", italian=" O forse lo abbiamo già superato.", spanish=" O igual ya lo hemos adelantado."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Whatever.[K] I feel like the\ntreasure is really close...", french="Peu importe.[K] Je sens que\nle trésor est tout proche...", german="Wie dem auch sei.[K] Ich kann die\nNähe des Schatzes förmlich spüren...", italian="Non importa.[K] Sento che il tesoro\nè molto vicino...", spanish="Ya se verá.[K] En cualquier caso,\npresiento que el tesoro está muy cerca..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Everyone, be extra careful\nfrom here on.", french="Ne baissez pas votre garde,\nles filles.", german="Also, lasst uns von hier an\nbesonders vorsichtig sein.", italian="Mi raccomando, da qui in avanti\nfacciamo molta attenzione.", spanish="Hemos de tener aún más cuidado\na partir de ahora."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
