-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/n01a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 2]
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I don't have time to be looking\nat job requests! Yup yup!", french="Pas l'temps d'regarder le\nTableau des Missions, pardi!", german="Ich habe keine Zeit, mir\nJob-Anfragen anzusehen! Jawollja!", italian="Non ho tempo di dare un'occhiata\nalle missioni! Già, già!", spanish="No tengo tiempo para estar\nmirando anuncios. ¡No, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- @label_1 [étiquette de flux ExplorerScript]
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  else
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Sniff...[K] Golly, I really want to\nbe assigned to do a job...", french="Snif...[K] Nom d'une pipe, j'aimerais\nvraiment qu'on me confie une mission...", german="Schnief...[K] Donnerwetter, ich\nwürde zu gerne einen richtigen Job\nzugeteilt bekommen...", italian="Sniff...[K] Ohibò, vorrei tanto che\nmi assegnassero una missione...", spanish="Buaa...[K] Jo, tengo unas ganas\nlocas de que me asignen una misión..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But I'll just have to wait.[K]\nSo, off to [CS:K]Kecleon[CR] Market.", french="Mais j'dois m'montrer patient.[K]\nAlors, direction le [CS:K]Marché Kecleon[CR].", german="Aber erst mal heißt es Geduld an\nden Tag legen.[K] Also los, auf zum\n[CS:K]Kecleon-Markt[CR].", italian="Ma non posso far altro\nche aspettare.[K] Forza, ora devo\nandare al [CS:K]Kecleon[CR] Market.", spanish="Pero tendré que esperar.[K]\nSerá mejor que vaya al [CS:K]Bazar Kecleon[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
end
