-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P12A/m03a1314.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- bgm2_PlayFadeIn(BGM_STORM) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back_SetGround(LEVEL_V03P12A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(480, 132, 1, false) end)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Do my eyes deceive me?[K] Could it be...?[K]\nYes, it is!", french="Est-ce que mes yeux me jouent des\ntours?[K] Est-ce que c'est bien...?[K] Oui, c'est ça!", german="Sehe ich richtig?[K] Kann es sein?[K]\nJa, es ist wahr!", italian="I miei occhi mi ingannano?[K] Quello è...[K]\nSì, è così!", spanish="¿Qué ven mis ojos?[K] ¿Se trata de...?[K]\n¡Sí! ¡Ahí está!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:FadeIn(10)
  GAME:WaitFrames(45)
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GAME:MoveCamera(168, 132, 1, false) end)
  GAME:WaitFrames(15)
  pcall(function() GAME:MoveCamera(480, 132, 1, false) end)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" I've finally found it![K] A Time Gear!", french=" Je l'ai enfin trouvé![K] Un Rouage du Temps!", german="Endlich habe ich es gefunden![K] Ein Zahnrad\nder Zeit!", italian="Finalmente l'ho trovato![K] Un Ingranaggio\ndel Tempo!", spanish="¡Al fin lo he encontrado! [K]\n¡Un Engranaje del Tiempo!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" But...[K]this is only the first of many...", french=" Mais...[K] ce n'est que le premier...", german=" Aber...[K] Es ist nur das erste von vielen...", italian=" Ma...[K] è solo il primo...", spanish="Pero...[K] Este solo es el primero\nde una larga serie."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GAME:MoveCamera(168, 132, 1, false) end)
  GAME:WaitFrames(10)
  pcall(function() GAME:MoveCamera(480, 132, 1, false) end)
  GAME:WaitFrames(15)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  pcall(function() GAME:MoveCamera(168, 132, 1, false) end)
  GAME:WaitFrames(10)
  pcall(function() GAME:MoveCamera(480, 132, 1, false) end)
  GAME:WaitFrames(90)
  pcall(function() SOUND:FadeOutBGM(120) end)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(false, 120)
  GAME:WaitFrames(60)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SCENARIO_BALANCE_FLAG = 1 -- $SCENARIO_BALANCE_FLAG = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SPECIAL_EPISODE_OPEN = SV.SkyVars.SPECIAL_EPISODE_OPEN or {}; SV.SkyVars.SPECIAL_EPISODE_OPEN[0] = 1 -- $SPECIAL_EPISODE_OPEN[0] = 1 (ROM)
end
