-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S02P01A/m05a0704.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_THAT_SHAPE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_S02P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  GAME:FadeOut(false, 0) -- screen_FlushOut
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 184, 104, Direction.Down, "NPC_PUKURIN")
  -- SetAnimation(23) [anim idle native]
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end) -- message_SetActor(ACTOR_PLAYER)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That shape...)", french="(Cette silhouette...)", german="(Diese Form...)", italian="(Quella forma...)", spanish="(Esa forma...)"})
  else
  SkySceneKit.say({english="(That shape...)", french="(Cette silhouette...)", german="(Diese Form...)", italian="(Quella forma...)", spanish="(Esa forma...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I've seen that shape before...)", french="(... je l'ai déjà vue...)", german="(Ich habe diese Form schon einmal gesehen.)", italian="(Ho già visto quella forma...)", spanish="(Yo he visto esa silueta antes...)"})
  else
  SkySceneKit.say({english="(I've seen that shape before...)", french="(... je l'ai déjà vue...)", german="(Ich habe diese Form schon einmal gesehen.)", italian="(Ho già visto quella forma...)", spanish="(Yo he visto esa silueta antes...)"})
  end
  pcall(function() UI:SetSpeaker(hero) end) -- message_SetActor(ACTOR_PLAYER)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That shape...[K] There's no mistaking it!)", french="(Cette silhouette...[K] Il n'y a pas d'erreur\npossible!)", german="(Diese Form...[K] Sie ist unverwechselbar!)", italian="(Quella forma...[K] È impossibile sbagliarsi!)", spanish="(Esa silueta...[K] ¡Es inconfundible!)"})
  else
  SkySceneKit.say({english="(That shape...[K] There's no mistaking it!)", french="(Cette silhouette...[K] Il n'y a pas d'erreur\npossible!)", german="(Diese Form...[K] Sie ist unverwechselbar!)", italian="(Quella forma...[K] È impossibile sbagliarsi!)", spanish="(Esa silueta...[K] ¡Es inconfundible!)"})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8966) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(0) -- screen_FlushIn
  GROUND:EntTurn(npc_npc_pukurin, Direction.Right)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(hero) end) -- message_SetActor(ACTOR_PLAYER)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That was...[K][CS:N]Wigglytuff[CR]!)", french="(C'était... [K][CS:N]Grodoudou[CR]!)", german="(Das war...[K] [CS:N]Knuddeluff[CR]!)", italian="(Quello era...[K] [CS:N]Wigglytuff[CR]!)", spanish="(Se trataba de...[K] ¡[CS:N]Wigglytuff[CR]!)"})
  else
  SkySceneKit.say({english="(That was...[K][CS:N]Wigglytuff[CR]!)", french="(C'était... [K][CS:N]Grodoudou[CR]!)", german="(Das war...[K] [CS:N]Knuddeluff[CR]!)", italian="(Quello era...[K] [CS:N]Wigglytuff[CR]!)", spanish="(Se trataba de...[K] ¡[CS:N]Wigglytuff[CR]!)"})
  end
  -- message_Close
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
