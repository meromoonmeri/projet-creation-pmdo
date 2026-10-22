-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D79P41A/s02p0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(49, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D79P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- me_Play(10) [ME vent/ambiance NDS sans fanfare équivalente - documenté]
  -- GAP: SetEffect 647 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  GAME:WaitFrames(30)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Tee-hee...", french=" Hi hi...", german=" Hihi...", italian=" Eeh-eeh...", spanish=" Je, je..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- me_Play(11) [ME vent/ambiance NDS sans fanfare équivalente - documenté]
  -- GAP: SetEffect 648 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(30)
  GAME:FadeOut(true, 30) -- screen_WhiteOutAll
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(45)
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Up)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(5)
  do local p=SkySceneKit.team_member(1).Position; GROUND:MoveToPosition(SkySceneKit.team_member(1), p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  do local p=SkySceneKit.team_member(2).Position; GROUND:MoveToPosition(SkySceneKit.team_member(2), p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(5)
  do local p=SkySceneKit.team_member(3).Position; GROUND:MoveToPosition(SkySceneKit.team_member(3), p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  local npc_npc_yukimenoko = SkySceneKit.spawn_npc("froslass", 304, 192, Direction.Down, "NPC_YUKIMENOKO")
  pcall(function() UI:SetSpeaker(npc_npc_yukimenoko) end)
  SkySceneKit.say({english="Tee-hee... How nice of you to\nvisit again.", french="Hi hi... vous revoilà! Vous\navez apprécié ma chaleureuse hospitalité?\nDe toute façon, peu me chaut...", german="Hihi! Wie schön, dass ihr\nwiedergekommen seid.", italian="Eeh-eeh... Gentile da parte\nvostra tornare a farmi visita.", spanish="Je, je...\nQué detalle por vuestra parte volver por aquí."})
  pcall(function() UI:SetSpeaker(npc_npc_yukimenoko) end)
  SkySceneKit.say({english="For repeat visitors, I had better\nnot skimp on my hospitality...", french="Je ne voudrais pas froisser\nde bons clients... Subissez les foudres\nde glace!", german="Für Stammgäste will ich mit\nmeiner Gastfreundschaft mal nicht geizen...", italian="Per coloro che tornano, la mia\nospitalità è ancora maggiore...", spanish="Para los visitantes más\nhabituales no escatimo hospitalidad..."})
  -- message_Close
  -- me_Play(11) [ME vent/ambiance NDS sans fanfare équivalente - documenté]
  -- GAP: SetEffect 648 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(30)
  GAME:FadeOut(true, 30) -- screen_WhiteOutAll
  GAME:WaitFrames(30)
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  SkySceneKit.cleanup_npcs()
end
