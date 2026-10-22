-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P17P02A/n02a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The next morning...", french="[CN]Le lendemain matin...", german="[CN]Am nächsten Morgen...", italian="[CN]Il mattino seguente...", spanish="[CN]A la mañana siguiente..."})
  -- message_Close
  -- back_SetGround(LEVEL_P17P02A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_P17P02A, 'UN02') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_pukurin_papa = SkySceneKit.spawn_npc("wigglytuff", 288, 184, Direction.DownLeft, "NPC_PUKURIN_PAPA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_pukurin_mama = SkySceneKit.spawn_npc("wigglytuff", 256, 208, Direction.UpRight, "NPC_PUKURIN_MAMA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(42) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_papa, "happy", 1) end)
  GAME:WaitFrames(8)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_mama, "happy", 1) end)
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Heartwarming.ogg", true) end)
  GAME:WaitFrames(30)
  GAME:WaitFrames(80)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(hero, 208, 168, false, 2)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_papa, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_mama, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(4)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(5)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.Left)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Good morning! ♪[K]\n[CS:N]Papa[CR]. ♪ [CS:N]Mama[CR]. ♪", french="Bonjour! ♪[K]\n[CS:N]Papa[CR] de moi. ♪ [CS:N]Maman[CR] de moi. ♪", german="Guten Morgen! ♪[K]\n[CS:N]Papa[CR]. ♪ [CS:N]Mama[CR]. ♪", italian="Buongiorno! ♪[K]\n[CS:N]Papà[CR]. ♪ [CS:N]Mamma[CR]. ♪", spanish="¡Buenos días! ♪[K] ¡Hola,\n[CS:N]papá[CR]! ♪ ¡Hola, [CS:N]mamá[CR]! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english=" Yep. Good morning. ♪", french=" Bonjour! ♪", german=" Guten Morgen! ♪", italian=" Buongiorno! ♪", spanish=" Buenos días, pequeñín. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" Good morning! ♪ [CS:Y]Igglybuff[CR]. ♪", french=" Bonjour! ♪ [CS:Y]Toudoudou[CR]. ♪", german=" Guten Morgen, [CS:Y]Fluffeluff[CR]. ♪", italian=" Buongiorno! ♪ [CS:Y]Igglybuff[CR]. ♪", spanish=" ¡Buenos días, ♪ [CS:Y]Igglybuff[CR]! ♪"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
