-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D52P32A/n09a1201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  if ((SV.SkyScenarioBitFlags or {})[8] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[8]
  -- @label_0 [étiquette de flux ExplorerScript]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 0 -- $SCENARIO_MAIN_BIT_FLAG[8] = 0 (ROM)
  -- back_SetGround(LEVEL_D52P32A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_IN_THE_FUTURE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(90)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(200), 400, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(150)
  GAME:FadeOut(false, 30)
  else
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Looks like we made it through.", french=" On a réussi.", german=" Wir sind wohl durchgekommen.", italian="A quanto pare, ce l'abbiamo\nfatta.", spanish=" Parece que hemos conseguido pasar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" I think the [CS:N]Sableye[CR] are up ahead.", french=" Les [CS:N]Ténéfix[CR] sont tout près.", german="Ich glaube, die [CS:N]Zobiris[CR]\nbefinden sich direkt voraus.", italian="Penso che i [CS:N]Sableye[CR] siano\npoco più avanti.", spanish="Creo que los [CS:N]Sableye[CR] están\nallí delante."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Let's proceed with caution.", french=" Avançons avec prudence.", german=" Lass uns achtsam weitergehen.", italian=" Procediamo con cautela.", spanish=" Avancemos con mucho cuidado."})
  -- message_Close
  GAME:WaitFrames(60)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT_SIDE = 2 -- $COMPULSORY_SAVE_POINT_SIDE = 2 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
end
