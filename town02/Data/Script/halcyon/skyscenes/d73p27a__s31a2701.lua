-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P27A/s31a2701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 232, 216, Direction.Down, "NPC_SHEIMI")
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Oogh...\nIt's hard to make progress...", french="Ouille...\nPas facile...", german="Uff...\nEs ist hart, vorwärts zu kommen...", italian="Orgh...\nÈ difficile fare progressi...", spanish="Uf...\nCuesta mucho avanzar..."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D73P27A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_D73P27A, 'US31') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if (SkyProg.cmp(29, 31) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 31]
  -- @label_23 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(9) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_SKY_PEAK_SNOWFIELD non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  if (SkyProg.cmp(29, 30) == 0) then -- if ROM: scn($SCENARIO_MAIN) == [29, 30]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Usually, [CS:N]Grimer[CR] and [CS:N]Muk[CR] should\nbe living farther down the mountain, I think...", french="Normalement, les [CS:N]Tadmorv[CR] et\nles [CS:N]Grotadmorv[CR] habitent plus bas sur la\nmontagne, je crois...", german="Gewöhnlich wohnen [CS:N]Sleima[CR] und\n[CS:N]Sleimok[CR] weiter unten am Berg...", italian="Di solito i [CS:N]Grimer[CR] e i [CS:N]Muk[CR] vivono\nnelle profondità della montagna, almeno credo...", spanish="Creo que los [CS:N]Grimer[CR] y [CS:N]Muk[CR]\nviven en la parte inferior de la montaña..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We need to do something about\nthe summit, no matter what!", french="Il faut qu'on fasse quelque chose\nau sujet du sommet, peu importe quoi!", german="Wir müssen etwas mit dem\nGipfel machen, was auch immer es sein mag!", italian="Dobbiamo raggiungere la cima\na qualsiasi costo!", spanish="Tenemos que llegar a la cima\nsea como sea."})
  -- message_Close
  else
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Yeah...\nLooks like it might be too difficult...", french="C'est un peu\ndécourageant...", german="Hmmm...\nDie Sache könnte zu happig sein...", italian="Eh sì...\nSembra che sarà molto difficile...", spanish="La verdad es que...\ntal vez sea demasiado difícil..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="But it will be amazing to reach\nthe summit after such hard work!", french="Mais alors, quelle satisfaction\nquand nous atteindrons le sommet\naprès tant d'efforts!", german="Aber denkt daran, wie es sein\nwird, nach einem solchen Kraftakt den Gipfel\nzu erreichen!", italian="Ma sarà ancora più emozionante\nraggiungere la cima dopo aver faticato tanto!", spanish="¡Pero será aún más gratificante\nllegar a la cima tras un arduo trabajo!"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We can't give up!\nLet's do our best!", french="On ne peut pas abandonner ici!\nCourage!", german="Wir dürfen nicht aufgeben!\nLasst uns unser Bestes geben!", italian="Non possiamo arrenderci!\nMettiamocela tutta!", spanish="¡No podemos rendirnos!\n¡Vamos a por todas!"})
  -- message_Close
  end
  elseif (SkyProg.cmp(29, 30) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30]
  -- supervision_Station(15) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(40) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(41) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_23 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 29) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 29]
  -- supervision_Station(15) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(40) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(41) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_23 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 28) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 28]
  -- jump @label_23 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 27) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 27]
  -- supervision_Station(15) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(41) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_23 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 26) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 26]
  -- jump @label_23 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 25) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 25]
  -- supervision_Station(15) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(17) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_23 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 24) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 24]
  -- supervision_Station(15) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(17) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_23 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 23] || scn($SCENARIO_MAIN) >= [2
  -- jump @label_23 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_23 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
