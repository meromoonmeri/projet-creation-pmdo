-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D20P11A/enter06.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  -- GAP: se_Play(16130) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]What would you like to do?", french="[CN]Que voulez-vous faire?", german="[CN]Was möchtest du tun?", italian="[CN]Cosa vuoi fare?", spanish="[CN]¿Qué quieres hacer?"})
  do local __choice = SkySceneKit.ask({{english="Check Storage", french="Réserve", german="Lager überprüfen", italian="Controlla strumenti", spanish="Mirar la consigna"}, {english="Save", french="Sauvegarder", german="Speichern", italian="Salva", spanish="Guardar"}, {english="Cancel", french="Annuler", german="Zurück", italian="Annulla", spanish="Cancelar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- message_Close
  -- switch(message_Menu(MENU_STORAGE)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_2 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __choice == 3 then
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- message_Close
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[7] = 1 -- $SCENARIO_MAIN_BIT_FLAG[7] = 1 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
