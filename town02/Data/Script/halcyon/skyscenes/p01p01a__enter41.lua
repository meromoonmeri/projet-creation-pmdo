-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/enter41.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 2 then
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]- [CS:K]Spinda[CR]'s Café -\n[CN]-Shop of Hopes & Dreams-\n[CN]Opening Soon! Win Big!", french="[CN]- [CS:K]Café Spinda[CR] -\n[CN]- Ici, vos rêves se réalisent! -\n[CN]Ouverture imminente!", german="[CN]- [CS:K]Pandir-Café[CR] -\n[CN]- Hoffen und träumen! -\n[CN]Eröffnung in Kürze. Dicke Belohnungen!", italian="[CN]- Caffè di [CS:K]Spinda[CR] -\n[CN]- Luogo di sogni e di speranze -\n[CN]Grosse vincite! Prossima apertura!", spanish="[CN]¡Próxima inauguración!\n[CN][CS:K]Cafetería Spinda[CR]\n[CN]Grandes premios en una tienda de ensueño"})
  -- message_Close
  -- @label_2 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  if (SkyProg.cmp(7, 3) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [7, 3]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]- [CS:K]Spinda[CR]'s Café -\n[CN]-Shop of Hopes & Dreams-\n[CN]Win Big!", french="[CN]- [CS:K]Café Spinda[CR] -\n[CN]- Ici, vos rêves se réalisent! -", german="[CN]- [CS:K]Pandir-Café[CR] -\n[CN]- Hoffen und träumen! -\n[CN]Dicke Belohnungen!", italian="[CN]- Caffè di [CS:K]Spinda[CR] -\n[CN]- Luogo di sogni e di speranze -\n[CN]Grosse vincite!", spanish="[CN][CS:K]Cafetería Spinda[CR]\n[CN]Grandes premios en una tienda de ensueño"})
  -- message_Close
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
end
