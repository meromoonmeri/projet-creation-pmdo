-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99A/s22p0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 87) -- $SCENARIO_MAIN = scn[29,87] (ROM)
  -- back_SetGround(LEVEL_H01P99A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_H01P99A, 'US22') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 184, 144, Direction.DownLeft, "NPC_KURESERIA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" To the northwest of here...", french=" Au nord-ouest d'ici...", german=" Nordwestlich von hier...", italian=" A nord-ovest...", spanish=" Al noroeste..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="There is a land of volcanic\nterrain.", french="... se trouve une contrée\nvolcanique.", german="Dort liegt ein Land vulkanischen\nUrsprungs.", italian="... si trova una regione\nvulcanica.", spanish=" Hay una zona volcánica."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kureseria, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" The [CS:P]Dark Crater[CR] is located there.", french="C'est là-bas que se situe\nle [CS:P]Cratère Obscur[CR].", german=" Dort liegt der [CS:P]Dunkelkrater[CR].", italian=" Il [CS:P]Cratere Oscuro[CR] è lì.", spanish="El [CS:P]Cráter Oscuro[CR] se encuentra\nallí."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Please tell me when you are\nready to leave.", french="Prévenez-moi quand vous voulez\npartir.", german="Sagt mir bitte Bescheid, wenn\nihr reisefertig seid.", italian="Ditemi quando possiamo\npartire.", spanish="Por favor, avisadme cuando\ntengáis todo listo para partir."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="I will guide you to\nthe [CS:P]Dark Crater[CR].", french="Je vous guiderai jusqu'au\n[CS:P]Cratère Obscur[CR].", german="Ich führe euch zum\n[CS:P]Dunkelkrater[CR].", italian=" Vi guiderò al [CS:P]Cratere Oscuro[CR].", spanish=" Yo os guiaré al [CS:P]Cráter Oscuro[CR]."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
