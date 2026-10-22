-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D46P21A/n08a0708.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_ONLY, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE08_BOSS2ND = SV.SkyVars.SIDE08_BOSS2ND or {}; SV.SkyVars.SIDE08_BOSS2ND[0] = 1 -- $SIDE08_BOSS2ND[0] = 1 (ROM)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Ooogh...", french=" Aargh...", german=" Uuuuff...", italian=" Oooh...", spanish=" Ay..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Argh...[K] That didn't go well...", french="Argh...[K] Ça ne s'est pas\ntrès bien passé...", german=" Argh...[K] Das war wohl nichts...", italian="Argh...[K] Non è andata affatto\nbene...", spanish=" Ay...[K] Esto no ha ido bien..."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D46P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_BARREN_VALLEY non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I can't hang back.[K]\nI've got to move swiftly.", french="Pas le temps de traîner.[K]\nIl faut faire vite.", german="Nur nicht aufhalten lassen.[K]\nIch muss schleunigst weiter!", italian="Ma non posso perdere tempo.[K]\nDevo sbrigarmi.", spanish="No puedo tomármelo con\ncalma.[K] El tiempo se agota."})
  -- message_Close
end
