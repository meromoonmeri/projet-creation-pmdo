-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D46P11A/n08a0908.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Argh...[K] That didn't go well...", french="Argh...[K] Ça ne s'est pas\ntrès bien passé...", german=" Argh...[K] Das war wohl nichts...", italian="Argh...[K] Non è andata affatto\nbene...", spanish=" Ay...[K] Esto no ha ido bien."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I should turn back for now.", french="Je devrais me reposer\npour l'instant.", german=" Ich sollte noch mal beginnen.", italian="È meglio che torni indietro\nper ora.", spanish=" Voy a retroceder de momento."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D46P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(29) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_BARREN_VALLEY non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  GAME:WaitFrames(15)
  -- SetAnimation(31) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I can't falter now.", french="Ce n'est pas le moment\nde flancher.", german=" Ich darf jetzt nicht zögern.", italian=" Non posso esitare adesso.", spanish=" Ahora no puedo flaquear."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I can't waste any time.", french=" Pas une seconde à perdre.", german=" Ich habe keine Zeit zu verlieren.", italian=" Non posso perdere tempo.", spanish=" No hay tiempo que perder."})
  -- message_Close
end
