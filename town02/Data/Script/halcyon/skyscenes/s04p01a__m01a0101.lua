-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S04P01A/m01a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  GAME:FadeOut(false, 0)
  -- back_SetBanner2(LEVEL_V01P02A, 0, 120, 96, 1, ) [bannière 2e écran NDS: information dupliquée du menu, hors canvas unique - documenté]
  GAME:FadeIn(45)
  GAME:WaitFrames(160)
  GAME:FadeOut(false, 45)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
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
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Whoa! Wh-wh-whoa...!", french=" Wouaaah! Aaah...!", german=" Boah! B-b-boah!", italian=" Wow! Wo-wo-wow...!", spanish=" ¡Cuidado! ¡Mucho cuidado!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Are...[K] Are you OK?!", french=" Ça...[K] ça va?!", german=" Bist...[K] Bist du in Ordnung?!?", italian=" Stai...[K] Stai bene?!", spanish=" ¿Estás...?[K] ¿Estás bien?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 3) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(3)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" No![K] Don't let go!", french=" Non![K] Tiens bon!", german=" Nein![K] Nicht aufgeben!", italian=" No![K] Non mollare!", spanish=" ¡No![K] ¡No te sueltes!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Just a little longer...[K] Come on! Hang on!", french="Allez, encore un effort...[K] Allez!\nTiens le coup!", german="Nur noch ein bisschen...[K] Komm schon!\nHalte durch!", italian=" Ancora un po'...[K] Forza! Devi farcela!", spanish=" Solo un poco más...[K] ¡Vamos! ¡Aguanta!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 3) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(3)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" N-n-no![K] I can't...[K]hold on...!", french=" N-non![K] Je ne peux pas...[K] continuer...!", german=" N-n-nein![K] Ich kann...[K] nicht mehr!", italian=" N-N-No![K] Non ce la...[K] faccio...!", spanish="¡No![K] No puedo...[K]\n¡No puedo sujetarme!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6402) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(6402) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(20)
  -- GAP: se_Play(6403) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Waaaaaah!", french=" Wouaaah!", german=" Uaaaaaah!", italian=" Waaaaaah!", spanish=" ¡Aaaaaah!"})
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(true, 90) -- screen_WhiteOutAll
  -- message_CloseEnforce
  GAME:WaitFrames(120)
  GAME:FadeIn(30)
  GAME:FadeOut(false, 0)
end
