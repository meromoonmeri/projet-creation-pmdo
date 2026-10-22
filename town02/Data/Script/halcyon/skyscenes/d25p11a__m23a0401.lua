-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D25P11A/m23a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Brine Cave.ogg", true) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 256, 192, Direction.Down, "NPC_PERAPPU")
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ready, [hero]?", french=" On y va, [hero]?", german=" Bereit, [hero]?", italian=" Tutto pronto, [hero]?", spanish=" ¿Seguimos, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are you ready, [hero]?", french=" On y va, [hero]?", german=" Bist du bereit, [hero]?", italian=" Tutto pronto, [hero]?", spanish=" ¿Seguimos, [hero]?"})
  else
  SkySceneKit.say({english=" Ready, [hero]?", french=" On y va, [hero]?", german=" Bist du bereit, [hero]?", italian=" Tutto pronto, [hero]?", spanish=" ¿Seguimos, [hero]?"})
  end
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="Not yet", french="Pas encore", german="Noch nicht...", italian="No", spanish="Aún no"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh. All right.", french=" D'accord.", german=" Oh. Alles klar.", italian=" Ah. Va bene.", spanish=" Vale, de acuerdo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh. OK.", french=" D'accord.", german=" Oh. Okay.", italian=" Ah. Ok.", spanish=" Vale, de acuerdo."})
  else
  SkySceneKit.say({english=" Oh. OK.", french=" D'accord.", german=" Oh. Okay.", italian=" Ah. Ok.", spanish=" Vale, de acuerdo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We'll be on our way when\nyou're ready.", french=" On repart quand tu veux.", german="Wir brechen auf, wenn du\nbereit bist.", italian="Quando è tutto pronto, ci\nmettiamo in marcia.", spanish="Continuaremos en cuanto\nte parezca bien."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go as soon as you're ready.", french=" On repart quand tu veux.", german="Lass uns gehen, sobald du bereit\nbist.", italian="Appena è tutto pronto, ci\nmettiamo in marcia.", spanish="Continuaremos en cuanto\nte parezca bien."})
  else
  SkySceneKit.say({english=" Let's leave when you're ready.", french=" On repart quand tu veux.", german=" Gehen wir, wenn du bereit bist.", italian="Quando è tutto pronto,\npartiamo.", spanish="Continuaremos en cuanto\nte parezca bien."})
  end
  -- message_Close
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetPositionLives(0) [cible objet/id de décor NDS non simulée - trace]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(24), 24, false) end) -- MovePositionOffset performer/caméra
  GROUND:MoveToPosition(npc_npc_perappu, 280, 220, false, 2)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right! Time to roll!", french=" Allez! En route!", german=" Alles klar! Legen wir los!", italian="Va bene! È ora di aprire le\ndanze!", spanish=" ¡Muy bien! ¡Vamos allá!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK! Let's move out!", french=" Allez! En route!", german=" Okay! Rücken wir aus!", italian=" Ok! Muoviamoci!", spanish=" ¡Muy bien! ¡Adelante!"})
  else
  SkySceneKit.say({english=" OK! Let's go!", french=" Allez! En route!", german=" Okay! Gehen wir!", italian=" Ok! Andiamo!", spanish=" ¡Muy bien! ¡Vamos!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" We'll make it through this time!", french=" On va y arriver cette fois-ci!", german=" Diesmal kommen wir durch!", italian=" Questa volta ce la faremo!", spanish=" ¡Esta vez lo conseguiremos!"})
  -- message_Close
  GROUND:MoveToPosition(hero, 252, 148, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 252, 148, false, 2)
  GROUND:MoveToPosition(npc_npc_perappu, 252, 148, false, 2)
  GAME:FadeOut(false, 30)
  -- main_EnterDungeon(35, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  SkySceneKit.cleanup_npcs()
end
