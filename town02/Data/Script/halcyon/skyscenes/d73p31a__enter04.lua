-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P31A/enter04.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Would you like to look at the scenery?", french="[CN]Voulez-vous admirer le paysage?", german="[CN]Möchtet ihr die Aussicht genießen?", italian="[CN]Vuoi guardare il panorama?", spanish="[CN]¿Quieres observar el paisaje?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- message_Close
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(6)
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_S32_02) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else -- default/annulation
  -- message_Close
  -- supervision_Suspend(-2) [neutre/état moteur]
  end
  end
end
