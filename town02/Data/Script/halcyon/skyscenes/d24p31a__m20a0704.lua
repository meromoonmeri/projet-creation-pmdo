-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D24P31A/m20a0704.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- back_SetGround(LEVEL_D24P31B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 256, 232, Direction.Up, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Time...[K]is at a standstill here!", french=" Le temps...[K] il s'est arrêté!", german=" Die Zeit...[K] Sie steht hier still!", italian=" Il tempo...[K] qui è fermo!", spanish=" El tiempo...[K] ¡se ha detenido!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But didn't they...?", french=" Mais ils n'ont pas...?", german=" Aber haben sie nicht...", italian=" Ma loro non...?", spanish=" ¿Pero no habían...?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But didn't they...?", french=" Mais ils n'ont pas...?", german=" Aber haben sie nicht...", italian=" Ma loro non...?", spanish=" ¿Pero no habían...?"})
  else
  SkySceneKit.say({english=" But didn't they...?", french=" Mais ils n'ont pas...?", german=" Aber haben sie nicht...", italian=" Ma loro non...?", spanish=" ¿Pero no habían...?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Just before we were dragged\noff to the future with you, [CS:N]Grovyle[CR]...", french="Juste avant qu'on parte dans\nle futur avec toi, [CS:N]Massko[CR]...", german="Kurz bevor wir mit dir in die\nZukunft verschleppt worden sind, [CS:N]Reptain[CR]...", italian="Poco prima di finire nel futuro\ncon te, [CS:N]Grovyle[CR]...", spanish="Justo antes de que nos\narrastrasen al futuro, [CS:N]Grovyle[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Just before we were dragged\noff to the future with you, [CS:N]Grovyle[CR]...", french="Juste avant qu'on parte dans\nle futur avec toi, [CS:N]Massko[CR]...", german="Kurz bevor wir mit dir in die\nZukunft verschleppt worden sind, [CS:N]Reptain[CR]...", italian="Poco prima di finire nel futuro\ncon te, [CS:N]Grovyle[CR]...", spanish="Justo antes de que nos\narrastrasen al futuro, [CS:N]Grovyle[CR]..."})
  else
  SkySceneKit.say({english="Just before we were dragged\noff to the future with you, [CS:N]Grovyle[CR]...", french="Juste avant qu'on parte dans\nle futur avec toi, [CS:N]Massko[CR]...", german="Kurz bevor wir mit dir in die\nZukunft verschleppt worden sind, [CS:N]Reptain[CR]...", italian="Poco prima di finire nel futuro\ncon te, [CS:N]Grovyle[CR]...", spanish="Justo antes de que nos\narrastrasen al futuro, [CS:N]Grovyle[CR]..."})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
