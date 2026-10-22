-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D50P11A/n08a2608.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D50P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n8 = SkySceneKit.spawn_npc("dusknoir", 488, 216, Direction.Left, "NPC_YONOWAARU_N8")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_SPACIAL_CLIFFS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 292, 236, false, 2)
  GROUND:MoveToPosition(npc_npc_yonowaaru_n8, 292, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="This is the entrance to\n[CS:P]Spacial Cliffs[CR].", french="Voici l'entrée des [CS:P]Falaises\nSpatiales[CR].", german="Das ist der Eingang zu den\n[CS:P]Raumklippen[CR].", italian="Questo è l'ingresso delle [CS:P]Alture[CR]\n[CS:P]Dimensionali[CR].", spanish="Esta es la entrada del\n[CS:P]Acantilado Abismo[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Once we pass through here,\nwe'll come to the place where the\n[CS:N]Porygon[CR] live.", french="L'endroit où vivent les [CS:N]Porygon[CR]\nn'est plus très loin.", german="Sobald wir hier durch sind,\nerreichen wir den Ort,\nan dem die [CS:N]Porygon[CR] leben.", italian="Superato questo punto,\narriveremo nel luogo dove vivono\ni [CS:N]Porygon[CR].", spanish="Una vez que pasemos por aquí,\nllegaremos al lugar en el que habitan\nlos [CS:N]Porygon[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:N]Celebi[CR] and [CS:N]Dialga[CR] have already\ngone to [CS:P]Frozen Island[CR].", french="[CS:N]Celebi[CR] et [CS:N]Dialga[CR] sont déjà\npartis pour l'[CS:P]Ile de Glace[CR].", german="[CS:N]Celebi[CR] und [CS:N]Dialga[CR] sind bereits\nauf der [CS:P]Frostinsel[CR].", italian="[CS:N]Celebi[CR] e [CS:N]Dialga[CR] hanno già\nraggiunto l'[CS:P]Isola Glaciale[CR].", spanish="[CS:N]Celebi[CR] y [CS:N]Dialga[CR] deberían\nestar ya en la [CS:P]Isla Helada[CR]."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Let's hurry.", french=" Dépêchons.", german=" Wir sollten uns beeilen.", italian=" Muoviamoci.", spanish=" Démonos prisa."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
