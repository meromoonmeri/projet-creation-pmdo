-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P29A/s31a3501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 232, 264, Direction.Down, "NPC_SHEIMI")
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Oogh... They're much stronger\nthan I thought...", french="Aïe... Ils sont plus forts\nque je ne le pensais...", german="Argh... Sie sind noch viel\nstärker, als ich dachte...", italian="Orgh... Sono molto più forti di\nquel che pensassi...", spanish="Uf... Son mucho más fuertes\nde lo que yo creía..."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D73P29A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_D73P29A, 'US31') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(20) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
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
  -- GAP: BGM BGM_SKY_PEAK_FINAL_PASS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Usually, [CS:N]Grimer[CR] and [CS:N]Muk[CR] should\nbe living farther down the mountain, I think...", french="Normalement, les [CS:N]Tadmorv[CR] et\nles [CS:N]Grotadmorv[CR] habitent plus bas sur la\nmontagne, je crois...", german="Gewöhnlich wohnen [CS:N]Sleima[CR] und\n[CS:N]Sleimok[CR] weiter unten am Berg...", italian="Di solito i [CS:N]Grimer[CR] e i [CS:N]Muk[CR] vivono\nnelle profondità della montagna, almeno credo...", spanish="Creo que los [CS:N]Grimer[CR] y [CS:N]Muk[CR]\nviven en la parte inferior de la montaña..."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We need to do something about\nthe summit, no matter what!", french="Il faut qu'on fasse quelque chose\nau sujet du sommet, peu importe quoi!", german="Wir müssen etwas mit dem\nGipfel machen, was auch immer es sein mag!", italian="Dobbiamo raggiungere la cima\na qualsiasi costo!", spanish="Tenemos que llegar a la cima\nsea como sea."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
