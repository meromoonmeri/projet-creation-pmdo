-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D17P34A/m15b0904.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D17P34A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_agunomu = SkySceneKit.spawn_npc("azelf", 352, 216, Direction.Down, "NPC_AGUNOMU")
  GROUND:EntTurn(npc_npc_agunomu, Direction.DownRight)
  -- SetAnimation(42) [anim idle native]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(5)
  GAME:WaitFrames(30)
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_0 [étiquette de flux ExplorerScript]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_OH_NO non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  -- @label_2 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english=" Ugh...[K]urgh...", french=" Argh...[K] argh...", german=" Ugh...[K] Urgh...", italian=" Ugh...[K] Urgh...", spanish=" ¡Ay!...[K] Uf..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 352, 248, Direction.Up, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Now I'll take it![K] The Time Gear!", french="Et maintenant il est à moi.[K]\nLe Rouage du Temps est à moi.", german="Jetzt habe ich es![K] Das Zahnrad\nder Zeit!", italian="Quello lo prendo io![K]\nL'Ingranaggio del Tempo!", spanish="¡Ahora voy a llevármelo![K]\n¡Me iré con el Engranaje del Tiempo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_juputoru, 368, 220, false, 2)
  GROUND:MoveToPosition(npc_npc_juputoru, 368, 196, false, 2)
  GROUND:MoveToPosition(npc_npc_juputoru, 348, 140, false, 2)
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english=" No...[K]you can't take it...[K] Never...", french=" Non...[K] tu ne l'auras pas...[K] Jamais...", german="Nein...[K] Du kannst es nicht nehmen.[K]\nNiemals...", italian=" No...[K] non ti permetterò...[K] mai...", spanish=" No...[K] No puedes llevártelo...[K] Jamás..."})
  -- message_Close
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- GAP: se_Play(5139) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 5) -- screen_WhiteOut
  GAME:FadeIn(0) -- screen_FlushIn
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(180), 60, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(15)
  GAME:FadeOut(false, 15)
  -- @label_5 [étiquette de flux ExplorerScript]
  end
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
