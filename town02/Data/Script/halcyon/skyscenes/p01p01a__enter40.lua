-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/enter40.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 2 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The door is still closed, so you can't get in.\n[CN]It seems like they're still getting ready.", french="[CN]La porte est encore fermée,\n[CN]vous ne pouvez pas entrer.\n[CN]On dirait qu'ils sont en plein préparatifs.", german="[CN]Die Tür ist noch geschlossen, daher kannst\n[CN]du nicht hinein. Anscheinend sind die\n[CN]Vorbereitungen noch nicht abgeschlossen.", italian="[CN]La porta è ancora chiusa e non puoi entrare.\n[CN]Forse stanno ultimando i preparativi.", spanish="[CN]La puerta sigue cerrada, no puedes entrar.\n[CN]Parece que aún se están preparando."})
  -- message_Close
  -- supervision_Suspend(-2) [neutre/état moteur]
  elseif true then -- default
  if (SkyProg.cmp(29, 46) == 0) then -- if ROM: scn($SCENARIO_MAIN) == [29, 46]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's take [CS:N]Manaphy[CR] to the beach.", french=" Amenons [CS:N]Manaphy[CR] à la plage.", german="Lass uns [CS:N]Manaphy[CR] zum Strand\nbringen.", italian=" Portiamo [CS:N]Manaphy[CR] alla spiaggia.", spanish=" Llevemos a [CS:N]Manaphy[CR] a la playa."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's take [CS:N]Manaphy[CR] to the beach.", french=" Amenons [CS:N]Manaphy[CR] à la plage.", german="Lass uns [CS:N]Manaphy[CR] zum Strand\nbringen.", italian=" Portiamo [CS:N]Manaphy[CR] alla spiaggia.", spanish=" Llevemos a [CS:N]Manaphy[CR] a la playa."})
  else
  SkySceneKit.say({english=" Let's take [CS:N]Manaphy[CR] to the beach.", french=" Amenons [CS:N]Manaphy[CR] à la plage.", german="Lass uns [CS:N]Manaphy[CR] zum Strand\nbringen.", italian=" Portiamo [CS:N]Manaphy[CR] alla spiaggia.", spanish=" Llevemos a [CS:N]Manaphy[CR] a la playa."})
  end
  -- message_Close
  -- supervision_Suspend(-2) [neutre/état moteur]
  elseif (SkyProg.cmp(7, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 3]
  -- debug_Print('LABEL_PACCHIIRU_OPEN') [neutre/état moteur]
  -- debug_Print('BGM_FADEOUT') [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- main_EnterGround(LEVEL_P01P04A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
end
