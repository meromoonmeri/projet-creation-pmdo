-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D17P45A/m99a0111.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(26, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D17P45A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  if ((SV.SkyPerformanceProgress or {})[7] == 1) then -- if ROM: $PERFORMANCE_PROGRESS_LIST[7]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_Acting(2) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 348, 236, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 372, 252, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 324, 252, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 348, 268, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- @label_1 [étiquette de flux ExplorerScript]
  local npc_npc_agunomu = SkySceneKit.spawn_npc("azelf", 352, 200, Direction.Down, "NPC_AGUNOMU")
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english="I'm [CS:N]Azelf[CR].[K] I'm the guardian\nof [CS:P]Shining Lake[CR].", french="Je m'appelle [CS:N]Créfadet[CR].[K] Je suis\nle gardien du [CS:P]Lac Cristal[CR].", german="Ich bin [CS:N]Tobutz[CR].[K] Ich bin der\nWächter des [CS:P]Kristallsees[CR]!", italian="Io sono [CS:N]Azelf[CR].[K] Sono il custode\ndel [CS:P]Lago di Cristallo[CR].", spanish="Soy [CS:N]Azelf[CR].[K]\n¡El guardián del [CS:P]Lago Cristal[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english=" I know why you're here.", french=" Je sais pourquoi vous êtes là.", german=" Ich weiß, warum ihr hier seid.", italian=" So perché sei qui.", spanish=" Sé a qué se debe esta visita."})
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english="You want to challenge me to a\nbattle...", french=" Vous êtes là pour me défier...", german="Ihr wollt mich zu einem Kampf\nherausfordern...", italian=" Vuoi sfidarmi...", spanish=" Un combate en toda regla..."})
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english=" Sure thing.", french=" Soit.", german=" Klare Sache.", italian=" Certo.", spanish=" Por mí, no hay problema."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english=" Your challenge...", french=" Votre défi...", german=" Eure Herausforderung...", italian=" La sfida...", spanish=" Así que un reto..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english=" I'm up for it!", french=" Je le relève!", german=" Dafür bin ich zu haben!", italian=" ... è accettata!", spanish=" ¡Pues venga!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english=" Come on!", french=" Approchez!", german=" Kommt schon!", italian=" In guardia!", spanish=" ¡Aquí estoy!"})
  -- message_Close
  pcall(function() SOUND:StopBGM() end)
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  else
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(partner, 332, 236, false, 2)
  GROUND:MoveToPosition(hero, 364, 236, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 348, 268, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 372, 260, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
