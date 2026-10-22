-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P19P01A/n02a1001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  -- back_SetGround(LEVEL_P19P01A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_aamarudo = SkySceneKit.spawn_npc("armaldo", 232, 344, Direction.Up, "NPC_AAMARUDO")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_aamarudo, 228, 192, false, 2)
  GAME:WaitFrames(6)
  GROUND:MoveToPosition(hero, 228, 216, false, 2)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.UpRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(hero, Direction.UpRight)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Oh! There's an opening in the\nrock here, deep in the forest!", french="Oh! Il y a une ouverture dans\nce gros rocher, au cœur de la forêt!", german="Oh! Ein Höhleneingang inmitten\ndes Waldes!", italian="Oh! In questo punto della foresta\nc'è una caverna!", spanish="¡Anda! ¡Pero si hay una cueva aquí,\nen el corazón del bosque!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" We're going in.", french=" C'est par là qu'on entre.", german=" Rein da.", italian=" Vieni, entriamo.", spanish=" Vamos a entrar."})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_aamarudo, 300, 148, false, 2)
  GAME:WaitFrames(6)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-24), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(hero, 296, 148, false, 2)
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(150) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
end
