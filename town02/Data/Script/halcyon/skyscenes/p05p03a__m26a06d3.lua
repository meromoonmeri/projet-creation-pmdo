-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P05P03A/m26a06d3.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_MEMORIES_RETURNED non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_P05P03A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(3) [neutre/état moteur]
  -- supervision_Acting(4) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- SetAnimation(78) [anim idle native]
  -- SetAnimation(78) [anim idle native]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 1096, 160, Direction.Down, "NPC_JUPUTORU")
  -- SetAnimation(34) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(228, 676, 1, false) end) -- SetPositionMark performer/caméra
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Left)
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 160, 696, Direction.UpRight, "NPC_YAMIRAMI")
  SkySceneKit.offset_pos(npc_npc_yamirami, 8, -32)
  local npc_npc_yamirami2 = SkySceneKit.spawn_npc("sableye", 304, 696, Direction.UpLeft, "NPC_YAMIRAMI2")
  SkySceneKit.offset_pos(npc_npc_yamirami2, -8, -32)
  local npc_npc_yamirami3 = SkySceneKit.spawn_npc("sableye", 184, 704, Direction.Up, "NPC_YAMIRAMI3")
  SkySceneKit.offset_pos(npc_npc_yamirami3, 0, -32)
  local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 280, 704, Direction.Up, "NPC_YAMIRAMI4")
  SkySceneKit.offset_pos(npc_npc_yamirami4, 0, -32)
  local npc_npc_yamirami5 = SkySceneKit.spawn_npc("sableye", 216, 704, Direction.Up, "NPC_YAMIRAMI5")
  SkySceneKit.offset_pos(npc_npc_yamirami5, 0, -32)
  local npc_npc_yamirami6 = SkySceneKit.spawn_npc("sableye", 248, 704, Direction.Up, "NPC_YAMIRAMI6")
  SkySceneKit.offset_pos(npc_npc_yamirami6, 0, -32)
  GROUND:EntTurn(npc_npc_yamirami, Direction.UpRight)
  GROUND:EntTurn(npc_npc_yamirami2, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_yamirami3, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Up)
  -- SetAnimation(45) [anim idle native]
  -- SetAnimation(45) [anim idle native]
  -- SetAnimation(45) [anim idle native]
  -- SetAnimation(45) [anim idle native]
  -- SetAnimation(45) [anim idle native]
  -- SetAnimation(45) [anim idle native]
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 232, 880, Direction.Up, "NPC_YONOWAARU")
  GROUND:TeleportTo(npc_npc_yonowaaru, 228, 768, Direction.Down)
  SkySceneKit.offset_pos(npc_npc_yonowaaru, 0, 16)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Up)
  -- supervision_Acting(8) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  -- screen2_FadeIn(0, 30) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- SetAnimation(18) [anim idle native]
  SkySceneKit.offset_pos(hero, 0, 2)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P05P03A1_136) [routine d'objet NDS non simulée - documenté]
  GROUND:EntTurn(partner, Direction.Down)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey!", french=" Eh!", german=" Hey!", italian=" Ehi!", spanish=" ¡Eh!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey!", french=" Eh!", german=" Hey!", italian=" Ehi!", spanish=" ¡Eh!"})
  else
  SkySceneKit.say({english=" Hey!", french=" Eh!", german=" Hey!", italian=" Ehi!", spanish=" ¡Eh!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(18) [anim idle native]
  SkySceneKit.offset_pos(partner, 0, 2)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P05P03A1_135) [routine d'objet NDS non simulée - documenté]
  GROUND:EntTurn(hero, Direction.Down)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(There's a break in the rope!)", french="(La corde est tailladée!)", german="(Da ist ein Riss im Seil!)", italian="(La corda è sfilacciata!)", spanish="(¡Se ha roto una cuerda!)"})
  else
  SkySceneKit.say({english="(There's a break in the rope!)", french="(La corde est tailladée!)", german="(Da ist ein Riss im Seil!)", italian="(La corda è sfilacciata!)", spanish="(¡Se ha roto una cuerda!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(18) [anim idle native]
  SkySceneKit.offset_pos(npc_npc_juputoru, 0, 2)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P05P03A1_137) [routine d'objet NDS non simulée - documenté]
  GROUND:EntTurn(npc_npc_juputoru, Direction.Down)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Now![K] Attack!", french=" Maintenant![K] Chargez!", german=" Jetzt![K] Angreifen!", italian=" Ora![K] Attacca!", spanish=" ¡Ahora![K] ¡Atacad!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Go!", french=" On fonce!", german=" Los!", italian=" Vai!", spanish=" ¡Vamos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Go!", french=" On fonce!", german=" Los!", italian=" Vai!", spanish=" ¡Vamos!"})
  else
  SkySceneKit.say({english=" Go!", french=" On fonce!", german=" Los!", italian=" Vai!", spanish=" ¡Vamos!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- se_FadeOut(7196, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- Destroy() [neutre/état moteur]
  -- SetAnimation(19) [anim idle native]
  -- SetAnimation(19) [anim idle native]
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(hero, 228, 668, false, 2)
  GROUND:MoveToPosition(partner, 276, 668, false, 2)
  GROUND:MoveToPosition(npc_npc_juputoru, 180, 668, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P05P03A1_135) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(13) [anim idle native]
  -- SetAnimation(13) [anim idle native]
  -- SetAnimation(12) [anim idle native]
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Gwah!", french=" Gwah!", german=" Gwah!", italian=" Aaah!", spanish=" ¡Ah!"})
  -- Move2PositionMark 0 [cible sans placement SSA zone: mouvement non joué]
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  -- SetAnimation(14) [anim idle native]
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(-8), p.Y+(32), false, 2) end -- Slide2PositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami2, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami3, "shock", 1) end)
  -- SetAnimation(14) [anim idle native]
  do local p=npc_npc_yamirami2.Position; GROUND:MoveToPosition(npc_npc_yamirami2, p.X+(8), p.Y+(32), false, 2) end -- Slide2PositionOffset
  -- SetAnimation(14) [anim idle native]
  do local p=npc_npc_yamirami3.Position; GROUND:MoveToPosition(npc_npc_yamirami3, p.X+(0), p.Y+(32), false, 2) end -- Slide2PositionOffset
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "shock", 1) end)
  -- SetAnimation(14) [anim idle native]
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(0), p.Y+(32), false, 2) end -- Slide2PositionOffset
  -- SetAnimation(14) [anim idle native]
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(0), p.Y+(32), false, 2) end -- Slide2PositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "shock", 1) end)
  -- SetAnimation(14) [anim idle native]
  do local p=npc_npc_yamirami6.Position; GROUND:MoveToPosition(npc_npc_yamirami6, p.X+(0), p.Y+(32), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
