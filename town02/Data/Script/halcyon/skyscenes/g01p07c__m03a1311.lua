-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m03a1311.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- bgm2_PlayFadeIn(BGM_STORM) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.Left)
  -- SetAnimation(76) [anim idle native]
  -- SetAnimation(76) [anim idle native]
  GAME:FadeIn(15) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But...what happens if a region\nloses its Time Gear?", french="Mais... que se passerait-il si\nune région perdait son Rouage du Temps?", german="Aber was, wenn eine Region ihr\nZahnrad der Zeit verliert?", italian="Cosa succede se un Ingranaggio\ndel Tempo sparisce?", spanish="Pero... ¿Qué pasaría si una\nregión perdiera su Engranaje del Tiempo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But...what happens if a region\nloses its Time Gear?", french="Mais... que se passerait-il si\nune région perdait son Rouage du Temps?", german="Aber was, wenn eine Region ihr\nZahnrad der Zeit verliert?", italian="Cosa succede se un Ingranaggio\ndel Tempo sparisce?", spanish="Pero... ¿Qué pasaría si una\nregión perdiera su Engranaje del Tiempo?"})
  else
  SkySceneKit.say({english="But...what happens if a region\nloses its Time Gear?", french="Mais... que se passerait-il si\nune région perdait son Rouage du Temps?", german="Aber was, wenn eine Region ihr\nZahnrad der Zeit verliert?", italian="Cosa succede se un Ingranaggio\ndel Tempo sparisce?", spanish="Pero... ¿Qué pasaría si una\nregión perdiera su Engranaje del Tiempo?"})
  end
  -- message_Close
  GAME:FadeOut(false, 15)
end
