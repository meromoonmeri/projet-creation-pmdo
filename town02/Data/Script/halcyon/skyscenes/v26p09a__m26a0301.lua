-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V26P09A/m26a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_V26P09A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() SOUND:PlayBGM("Time Restored.ogg", true) end)
  GAME:FadeIn(60)
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Th-this is...", french=" C'est...", german=" D-das ist...", italian=" Q-Questa è...", spanish=" Esto... Esto es..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Th-this is...", french=" C'est...", german=" D-das ist...", italian=" Q-Questa è...", spanish=" Esto... Esto es..."})
  else
  SkySceneKit.say({english=" Th-this is...", french=" C'est...", german=" D-das ist...", italian=" Q-Questa è...", spanish=" Esto... Esto es..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end) -- message_SetActor(ACTOR_PLAYER)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:N]Dialga[CR] must be showing this to us...)", french="(Ça doit être [CS:N]Dialga[CR] qui nous fait voir ça...)", german="([CS:N]Dialga[CR] zeigt uns das wohl gerade...)", italian="([CS:N]Dialga[CR] ci sta facendo vedere...)", spanish="([CS:N]Dialga[CR] debe de estar mostrándonos esto...)"})
  else
  SkySceneKit.say({english="([CS:N]Dialga[CR] must be showing this to us...)", french="(Ça doit être [CS:N]Dialga[CR] qui nous fait voir ça...)", german="([CS:N]Dialga[CR] zeigt uns das wohl gerade...)", italian="([CS:N]Dialga[CR] ci sta facendo vedere...)", spanish="([CS:N]Dialga[CR] debe de estar mostrándonos esto...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(He must be using telepathy to do so.)", french="(Il doit se servir de la télépathie\npour y arriver.)", german="(Wahrscheinlich setzt es dazu Telepathie ein.)", italian="(Ci sta facendo vedere queste immagini\ncon i suoi poteri telepatici.)", spanish="(Debe de estar usando telepatía.)"})
  else
  SkySceneKit.say({english="(He must be using telepathy to do so.)", french="(Il doit se servir de la télépathie\npour y arriver.)", german="(Wahrscheinlich setzt es dazu Telepathie ein.)", italian="(Ci sta facendo vedere queste immagini\ncon i suoi poteri telepatici.)", spanish="(Debe de estar usando telepatía.)"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
end
