-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D40P11A/s22p0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D40P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Dark Crater.ogg", true) end)
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 184, 368, Direction.DownLeft, "NPC_KURESERIA")
  GROUND:MoveToPosition(npc_npc_kureseria, 180, 196, false, 2)
  GROUND:MoveToPosition(partner, 164, 212, false, 2)
  GROUND:MoveToPosition(hero, 196, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_kureseria, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Let's hurry.", french=" Dépêchons-nous.", german=" Wir müssen uns beeilen.", italian=" Affrettiamoci.", spanish=" Démonos prisa."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="If [CS:N]Darkrai[CR]'s scheme can't be\nstopped soon...", french="Si on ne met pas rapidement fin\naux exactions de [CS:N]Darkrai[CR]...", german="Wenn das Vorhaben von [CS:N]Darkrai[CR]\nnicht bald vereitelt werden kann...", italian=" Se non fermiamo [CS:N]Darkrai[CR]...", spanish="Si no le paramos pronto los pies\na [CS:N]Darkrai[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="All the world's Pokémon will\nbecome imprisoned in a nightmare...", french="... tous les Pokémon du monde\nse retrouveront à jamais emprisonnés\ndans un cauchemar...", german="Dann wird die ganze Welt der\nPokémon zur Gefangenen eines Albtraums.", italian="Se non lo fermiamo, tutti i\nPokémon del mondo saranno imprigionati in un\nincubo.", spanish="Todos los Pokémon del mundo\nquedarán atrapados en una pesadilla..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" This time, we have to do it!", french=" Cette fois-ci, on doit réussir!", german="Diesmal müssen wir es\nschaffen!", italian=" Questa volta dobbiamo farcela!", spanish=" ¡Esta vez lo conseguiremos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" This time, we'll get it done!", french=" Cette fois-ci, on doit réussir!", german=" Diesmal erledigen wir die Sache!", italian=" Questa volta dobbiamo farcela!", spanish=" ¡Esta vez lo conseguiremos!"})
  else
  SkySceneKit.say({english=" This time, we'll get it done!", french=" Cette fois-ci, on doit réussir!", german=" Diesmal erledigen wir die Sache!", italian=" Questa volta dobbiamo farcela!", spanish=" ¡Esta vez lo conseguiremos!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_kureseria, 180, 124, false, 2)
  GROUND:MoveToPosition(partner, 180, 124, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(hero, 180, 124, false, 2)
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  -- main_EnterDungeon(67, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
