-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D15P41A/m99a0108.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(23, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D15P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  if ((SV.SkyPerformanceProgress or {})[7] == 1) then -- if ROM: $PERFORMANCE_PROGRESS_LIST[7]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_Acting(2) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 300, 204, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 324, 220, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 276, 220, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 300, 236, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- @label_1 [étiquette de flux ExplorerScript]
  local npc_npc_emuritto = SkySceneKit.spawn_npc("mesprit", 304, 160, Direction.Down, "NPC_EMURITTO")
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="I'm [CS:N]Mesprit[CR].[K] I'm the guardian\nof the [CS:P]Underground Lake[CR]!", french="Je m'appelle [CS:N]Créfollet[CR].[K] Je suis\nla gardienne du [CS:P]Lac Souterrain[CR]!", german="Ich bin [CS:N]Vesprit[CR].[K] Ich bewache\nden [CS:P]Untergrundsee[CR]!", italian="Io sono [CS:N]Mesprit[CR].[K] Custodisco il\n[CS:P]Lago Sotterraneo[CR]!", spanish="Soy [CS:N]Mesprit[CR].[K]\n¡Yo guardo el [CS:P]Lago Subterráneo[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="Your trespassing here can mean\nonly one thing.", french="Vous avez pénétré ici sans\nma permission. Cela ne peut signifier\nqu'une chose.", german="Euer Eindringen hier kann nur\neines bedeuten.", italian="Aver oltrepassato questo punto\npuò significare solo una cosa.", spanish="Esta intrusión solo puede\nsignificar una cosa..."})
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english="You're here to challenge me to\na battle!", french=" Vous êtes là pour me défier...", german="Ihr seid hier, um mich zum\nKampf herauszufordern!", italian=" Sei qui per sfidarmi...", spanish="¡Un combate para ver quién es\nmejor!"})
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" How amusing...", french=" Comme c'est amusant...", german=" Wie amüsant...", italian=" Divertente...", spanish=" Menuda idea..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" This challenge of yours...", french=" Votre défi...", german=" Eure Herausforderung...", italian=" La sfida...", spanish=" Desafiarme a mí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" I accept it!", french=" Je l'accepte!", german=" Ich nehme sie an!", italian=" ... è accettata!", spanish=" ¡Acepto!"})
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
  pcall(function() UI:SetSpeaker(npc_npc_emuritto) end)
  SkySceneKit.say({english=" Come on!", french=" Allez, approchez!", german=" Kommt schon!", italian=" In guardia!", spanish=" ¡Adelante!"})
  -- message_Close
  pcall(function() SOUND:StopBGM() end)
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  else
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(partner, 284, 204, false, 2)
  GROUND:MoveToPosition(hero, 316, 204, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 300, 236, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 324, 228, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
