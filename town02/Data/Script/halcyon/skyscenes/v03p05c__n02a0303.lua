-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P05C/n02a0303.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_V03P05C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_STORM non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]When [CS:Y]Igglybuff[CR] and I returned from climbing\n[CN]the mountain...", french="[CN]Alors que [CS:Y]Toudoudou[CR] et moi rentrions\n[CN]à la maison après avoir gravi la montagne...", german="[CN]Als [CS:Y]Fluffeluff[CR] und ich\n[CN]vom Berg zurückkehrten...", italian="[CN]Mentre io e [CS:Y]Igglybuff[CR] tornavamo indietro\n[CN]dopo aver scalato la montagna...", spanish="[CN]Cuando [CS:Y]Igglybuff[CR] y yo\n[CN]bajábamos la montaña..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]We found ourselves stuck in a sudden storm...", french="[CN]On s'est fait surprendre par un orage...", german="[CN]Da wurden wir plötzlich von\n[CN]einem Unwetter überrascht...", italian="[CN]... siamo stati sorpresi da\n[CN]una violenta tempesta.", spanish="[CN]Nos sorprendió una tormenta..."})
  -- message_Close
  GAME:FadeOut(false, 30)
end
