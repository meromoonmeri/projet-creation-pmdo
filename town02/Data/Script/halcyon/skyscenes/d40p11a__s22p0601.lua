-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D40P11A/s22p0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D40P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_ON_THE_CEILING non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- bgm_ChangeVolume(0,128) [volume BGM non scriptable en Lua PMDO: piste maintenue - documenté]
  GAME:FadeIn(30)
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 184, 368, Direction.DownLeft, "NPC_KURESERIA")
  GROUND:MoveToPosition(npc_npc_kureseria, 180, 196, false, 2)
  GROUND:MoveToPosition(partner, 164, 212, false, 2)
  GROUND:MoveToPosition(hero, 196, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So this is the entrance to the\n[CS:P]Dark Crater[CR]...", french="Voici donc l'entrée du [CS:P]Cratère\nObscur[CR]...", german="Das ist also der Eingang zum\n[CS:P]Dunkelkrater[CR]...", italian="Quindi questo è l'ingresso del\n[CS:P]Cratere Oscuro[CR]...", spanish="Así que esta es la entrada al\n[CS:P]Cráter Oscuro[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So this is the entrance to the\n[CS:P]Dark Crater[CR]...", french="Voici donc l'entrée du [CS:P]Cratère\nObscur[CR]...", german="Das ist also der Eingang zum\n[CS:P]Dunkelkrater[CR]...", italian="Quindi questo è l'ingresso del\n[CS:P]Cratere Oscuro[CR]...", spanish="Así que esta es la entrada al\n[CS:P]Cráter Oscuro[CR]..."})
  else
  SkySceneKit.say({english="So this is the entrance to the\n[CS:P]Dark Crater[CR]...", french="Voici donc l'entrée du [CS:P]Cratère\nObscur[CR]...", german="Das ist also der Eingang zum\n[CS:P]Dunkelkrater[CR]...", italian="Quindi questo è l'ingresso del\n[CS:P]Cratere Oscuro[CR]...", spanish="Así que esta es la entrada al\n[CS:P]Cráter Oscuro[CR]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kureseria, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Here we face [CS:N]Darkrai[CR].[K] There is\nno telling what he has in store for us.", french="Apprêtons-nous à affronter\n[CS:N]Darkrai[CR].[K] Qui sait ce qu'il nous réserve?", german="Hier stellen wir uns [CS:N]Darkrai[CR].[K]\nKeiner kann sagen, was dieses Pokémon für\nuns bereithält.", italian="È qui che dobbiamo affrontare\n[CS:N]Darkrai[CR].[K] Non possiamo\nsapere che accoglienza ci ha preparato.", spanish="Aquí nos enfrentaremos a\n[CS:N]Darkrai[CR].[K] A saber qué sorpresas nos tiene\npreparadas."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="We must proceed with the\nutmost care!", french="Nous devons agir avec la plus\ngrande prudence!", german="Wir müssen mit\ngrößtmöglicher Vorsicht vorgehen!", italian="Dobbiamo procedere con molta\ncautela!", spanish="¡Hay que ir con muchísimo\ncuidado!"})
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
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(2) -- join WaitBgm
  -- main_EnterDungeon(67, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
