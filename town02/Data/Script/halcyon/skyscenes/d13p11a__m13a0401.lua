-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D13P11A/m13a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(14, 4) -- $SCENARIO_MAIN = scn[14,4] (ROM)
  -- back_SetGround(LEVEL_D13P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Northern Desert.ogg", true) end)
  GROUND:MoveToPosition(hero, 248, 268, false, 2)
  GROUND:MoveToPosition(partner, 216, 268, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The [CS:P]Northern Desert[CR] is through\nhere...", french="Il faut passer par ici pour\nrallier le [CS:P]Désert du Nord[CR]...", german="Die [CS:P]Nordwüste[CR] liegt in dieser\nRichtung...", italian="Il [CS:P]Deserto del Nord[CR] comincia\nqui...", spanish="El [CS:P]Desierto Norte[CR] empieza\naquí..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The [CS:P]Northern Desert[CR] is through\nhere...", french="Il faut passer par ici pour\nrallier le [CS:P]Désert du Nord[CR]...", german="Die [CS:P]Nordwüste[CR] liegt in dieser\nRichtung...", italian="Il [CS:P]Deserto del Nord[CR] comincia\nqui...", spanish="El [CS:P]Desierto Norte[CR] empieza\naquí..."})
  else
  SkySceneKit.say({english="The [CS:P]Northern Desert[CR] is through\nhere...", french="Il faut passer par ici pour\nrallier le [CS:P]Désert du Nord[CR]...", german="Die [CS:P]Nordwüste[CR] liegt in dieser\nRichtung...", italian="Il [CS:P]Deserto del Nord[CR] comincia\nqui...", spanish="El [CS:P]Desierto Norte[CR] empieza\naquí..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" If a Time Gear really is here...", french="S'il abrite vraiment un Rouage\ndu Temps...", german="Wenn es hier wirklich ein\nZahnrad der Zeit gibt...", italian="Se qui si trova un Ingranaggio\ndel Tempo...", spanish="Si oculta algún Engranaje del\nTiempo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" If a Time Gear really is here...", french="S'il abrite vraiment un Rouage\ndu Temps...", german="Wenn es hier wirklich ein\nZahnrad der Zeit gibt...", italian="Se qui si trova un Ingranaggio\ndel Tempo...", spanish="Si oculta algún Engranaje del\nTiempo..."})
  else
  SkySceneKit.say({english=" If a Time Gear really is here...", french="S'il abrite vraiment un Rouage\ndu Temps...", german="Wenn es hier wirklich ein\nZahnrad der Zeit gibt...", italian="Se qui si trova un Ingranaggio\ndel Tempo...", spanish="Si oculta algún Engranaje del\nTiempo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Grovyle[CR] will show up here\nfor sure.", french="... [CS:N]Massko[CR] finira forcément par\nfaire son apparition.", german="Dann wird [CS:N]Reptain[CR] mit Sicherheit\nhier auftauchen.", italian="... allora anche [CS:N]Grovyle[CR] si farà\nvedere.", spanish="[CS:N]Grovyle[CR] acabará\npresentándose sin duda alguna."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Grovyle[CR] should show up here\nfor sure.", french="... [CS:N]Massko[CR] finira forcément par\nfaire son apparition.", german="Dann taucht [CS:N]Reptain[CR] mit\nSicherheit hier auf.", italian="... allora anche [CS:N]Grovyle[CR] si farà\nvedere.", spanish="[CS:N]Grovyle[CR] acabará\npresentándose sin duda alguna."})
  else
  SkySceneKit.say({english="[CS:N]Grovyle[CR] should show up here\nfor sure.", french="... [CS:N]Massko[CR] finira forcément par\nfaire son apparition.", german="Dann taucht [CS:N]Reptain[CR] mit\nSicherheit hier auf.", italian="... allora anche [CS:N]Grovyle[CR] si farà\nvedere.", spanish="[CS:N]Grovyle[CR] acabará\npresentándose sin duda alguna."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's go for it and find that\nTime Gear!", french="Allons dénicher ce Rouage\ndu Temps!", german="Lass uns dieses Zahnrad der Zeit\nsuchen!", italian="Andiamo! Troviamo l'Ingranaggio\ndel Tempo!", spanish=" ¡Tenemos que encontrarlo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's do our best and find that\nTime Gear!", french="Allons dénicher ce Rouage\ndu Temps!", german="Geben wir unser Bestes und\nsuchen dieses Zahnrad der Zeit!", italian="Andiamo! Troviamo l'Ingranaggio\ndel Tempo!", spanish=" ¡Tenemos que encontrarlo!"})
  else
  SkySceneKit.say({english="Let's do our best and find that\nTime Gear!", french="Allons dénicher ce Rouage\ndu Temps!", german="Geben wir unser Bestes und\nsuchen dieses Zahnrad der Zeit!", italian="Andiamo! Troviamo l'Ingranaggio\ndel Tempo!", spanish=" ¡Tenemos que encontrarlo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 228, 164, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(partner, 228, 164, false, 2)
  GAME:WaitFrames(20)
  GAME:FadeOut(false, 30)
  -- main_EnterDungeon(20, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
end
