-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D45P42A/n03a1701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=42, sub=10} -- $SCENARIO_SIDE = scn[42,10] (ROM)
  -- back_SetGround(LEVEL_D45P42A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_aamarudo = SkySceneKit.spawn_npc("armaldo", 272, 248, Direction.Left, "NPC_AAMARUDO")
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Phew...[K] We just barely\nbeat them...", french="Pfiou...[K] On les a battus\nde justesse...", german="Puuuh...[K] Die haben wir gerade\nso abgewehrt...", italian="Fiuuu...[K] Ce la siamo cavata\nper il rotto della cuffia...", spanish="Uf...[K] Los hemos vencido\npor los pelos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I can see some kind of light\nover there.", french="Je vois comme une lumière\nlà-bas.", german="Sieh mal! Dort drüben kann ich\nein Licht erkennen.", italian="Mi pare di vedere una luce\nlaggiù in fondo.", spanish=" Por ahí veo algo de luz."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(252, 128, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(80)
  pcall(function() GAME:MoveCamera(252, 244, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(4)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Let's go check it out.", french=" Allons voir.", german=" Sehen wir uns das mal an.", italian=" Andiamo a controllare.", spanish=" Vamos a ver qué es."})
  -- message_Close
  do local p=npc_npc_aamarudo.Position; GROUND:MoveToPosition(npc_npc_aamarudo, p.X+(0), p.Y+(-120), false, 2) end
  GAME:WaitFrames(4)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-120), false, 2) end
  GAME:WaitFrames(20)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
end
