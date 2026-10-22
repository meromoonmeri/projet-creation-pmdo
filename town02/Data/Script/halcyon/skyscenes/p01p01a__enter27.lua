-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/enter27.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]- Assembly Post -\n[CN]For service, please ring bell!\n[CN]            -[CS:N]Chimecho[CR]", french="[CN]- Point de Rassemblement -\n[CN]Prière d'utiliser la cloche!\n[CN]            - [CS:N]Eoko[CR]", german="[CN]- Versammlungsort -\n[CN]Bitte Glocke läuten!\n[CN]  -[CS:N]Palimpalim[CR]", italian="[CN]- Raduno Squadra -\n[CN]Per assistenza, suonare la campana!\n[CN]            - [CS:N]Chimecho[CR] -", spanish="[CN]Punto de reunión\n[CN]¡Toca la campana y acudiré!\n[CN]            -[CS:N]Chimecho[CR]"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Ring the bell and\n[CN]summon [CS:N]Chimecho[CR]?", french="[CN]Voulez-vous faire sonner la cloche\n[CN]pour appeler [CS:N]Eoko[CR]?", german="[CN]Glocke läuten und\n[CN][CS:N]Palimpalim[CR] herbeirufen?", italian="[CN]Vuoi suonare la campana per\n[CN]chiamare [CS:N]Chimecho[CR]?", spanish="[CN]¿Tocar la campana y\n[CN]llamar a [CS:N]Chimecho[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- message_Close
  -- supervision_RemoveCommon(7) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(8) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: se_Play(5123) — id SE NDS sans portage PMDO identifié
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 156 then
  -- supervision_ExecuteCommon(CORO_EVENT_S31_40) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  SkySceneKit.play_scene("p01p01a__m00p100100", "p01p01a__m00p1001", hero, partner) -- supervision_ExecuteActing(LEVEL_P01P01A, 'M00P1001', 0) [chaînage scène ROM]
  end
  end
  elseif __choice == 2 then
  -- @label_1 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else -- default/annulation
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
