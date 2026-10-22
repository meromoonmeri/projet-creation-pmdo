-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D79P41A/s02p0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(49, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  SkyProg.set(29, 37) -- $SCENARIO_MAIN = scn[29,37] (ROM)
  -- back_SetGround(LEVEL_D79P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GROUND:MoveToPosition(hero, 300, 260, false, 2)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 324, 276, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 276, 276, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 300, 292, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-40), false, 2) end
  GAME:WaitFrames(5)
  do local p=SkySceneKit.team_member(1).Position; GROUND:MoveToPosition(SkySceneKit.team_member(1), p.X+(0), p.Y+(-40), false, 2) end
  do local p=SkySceneKit.team_member(2).Position; GROUND:MoveToPosition(SkySceneKit.team_member(2), p.X+(0), p.Y+(-40), false, 2) end
  do local p=SkySceneKit.team_member(3).Position; GROUND:MoveToPosition(SkySceneKit.team_member(3), p.X+(0), p.Y+(-40), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- me_Play(10) [ME vent/ambiance NDS sans fanfare équivalente - documenté]
  -- GAP: SetEffect 647 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(15)
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
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Visitors... What a rare sight...", french="Des visiteurs... Quelle vision peu\ncommune...", german=" Besucher! Welch seltener Anblick...", italian=" Visitatori... Una cosa alquanto rara...", spanish=" Visitantes. Qué extraño..."})
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
  SkySceneKit.say({english=" Tee-hee... Welcome...", french=" Hi hi... Bienvenue...", german=" Hihi! Seid willkommen...", italian=" Eeh-eeh... I miei saluti...", spanish=" Je, je... Os doy la bienvenida..."})
  pcall(function() UI:SetSpeaker(npc_npc_yukimenoko) end)
  SkySceneKit.say({english=" I'm [CS:N]Froslass[CR].", french=" Je suis [CS:N]Momartik[CR].", german=" Ich bin [CS:N]Frosdedje[CR].", italian=" Mi chiamo [CS:N]Froslass[CR].", spanish=" Soy [CS:N]Froslass[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yukimenoko) end)
  SkySceneKit.say({english="I play host to the infrequent\nvisitors to this frozen hinterland!", french="Je me fais l'hôte des rares\nvisiteurs de ces contrées glacées!", german="Ich empfange die gelegentlichen\nBesucher dieses gefrorenen Hinterlandes!", italian="Mi occupo di dare il benvenuto\na coloro che visitano questa landa ghiacciata!", spanish="El anfitrión de los pocos que\nse adentran en estas recónditas tierras..."})
  pcall(function() UI:SetSpeaker(npc_npc_yukimenoko) end)
  SkySceneKit.say({english="It must have been awfully\nexhausting for you to fight those blizzards.", french="Ce doit être épuisant pour vous\nde lutter contre ce blizzard.", german="Ihr müsst fürchterlich\nerschöpft vom Kampf mit diesen Blizzards\nsein.", italian="Deve essere stata davvero dura\nsuperare quelle tormente.", spanish="Luchar contra las ventiscas\nhabrá sido agotador, supongo."})
  pcall(function() UI:SetSpeaker(npc_npc_yukimenoko) end)
  SkySceneKit.say({english=" Please, do come closer...", french=" Approchez-vous plus près...", german=" Bitte, kommt näher...", italian=" Prego, avvicinatevi...", spanish=" Por favor, acercaos..."})
  pcall(function() UI:SetSpeaker(npc_npc_yukimenoko) end)
  SkySceneKit.say({english="You must be chilled almost\ndown to the bone...", french="Quiconque vient ici se retrouve\ntransi de froid...", german="Ihr müsst fast bis auf die\nKnochen durchgefroren sein.", italian=" Ormai starete per congelare...", spanish="Pobres criaturas, se os habrá\ncalado el frío hasta en los huesos..."})
  pcall(function() UI:SetSpeaker(npc_npc_yukimenoko) end)
  SkySceneKit.say({english="So let me freeze you solid!\nAll the way down to the bone!", french="Je m'en vais vous congeler\nsur place! J'espère que vous n'avez pas\nfroid aux yeux!", german="Also lasst mich euch steif\nfrieren! Ganz und gar!", italian="Lasciate che finisca il lavoro.\nVi congelerò completamente!", spanish="¡Dejad que os congele!\n¡Por completo!"})
  -- message_Close
  -- me_Play(11) [ME vent/ambiance NDS sans fanfare équivalente - documenté]
  -- GAP: SetEffect 648 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(30)
  GAME:FadeOut(true, 30) -- screen_WhiteOutAll
  GAME:WaitFrames(30)
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  SkySceneKit.cleanup_npcs()
end
