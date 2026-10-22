-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/m01a0103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(120)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="......", french="......", german="......", italian="......", spanish="(...)"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="............", french="............", german="............", italian="............", spanish="(... ...)"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="..................", french="..................", german="..................", italian="..................", spanish="(... ... ...)"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Urrgh...", french="Aaaah...", german="Urrgh...", italian="Urrgh...", spanish="(¡Uf!)"})
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V01P03A) [décor sub chargé: Sub_v01p03a]
  -- camera2_SetPositionMark(Position<'m0', 33, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v01p03a", 120, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="Where...", french="Où...", german="Wo...", italian="Dove...", spanish="(¿Dónde...?)"})
  else
  SkySceneKit.say({english="Where...", french="Où...", german="Wo...", italian="Dove...", spanish="(¿Dónde...?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="...Where am I?", french="... où suis-je?", german="Wo bin ich?", italian="... sono?", spanish="(¿Dónde estoy?)"})
  else
  SkySceneKit.say({english="...Where am I?", french="... où suis-je?", german="Wo bin ich?", italian="... sono?", spanish="(¿Dónde estoy?)"})
  end
  -- message_Close
  -- back_SetGround(LEVEL_D01P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetAnimation(76) [anim idle native]
  GAME:FadeIn(120)
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="...[K]I can't...[K] Drifting off...", french="...[K] Je n'y arrive pas...[K] Je...", german="...[K]Ich kann nicht...[K] So müde...", italian="...[K] Non ce la faccio...[K] Sto per svenire...", spanish="(No...[K] No puedo...[K] mantenerme despierto.)"})
  else
  SkySceneKit.say({english="...[K]I can't...[K] Drifting off...", french="...[K] Je n'y arrive pas...[K] Je...", german="...[K]Ich kann nicht...[K] So müde...", italian="...[K] Non ce la faccio...[K] Sto per svenire...", spanish="(No...[K] No puedo...[K] mantenerme despierta.)"})
  end
  -- message_Close
  GAME:FadeOut(false, 20) -- screen_FadeChange vers alpha 128 (assombrissement, adaptation)
  GAME:FadeIn(20) -- screen_FadeChange vers alpha 256 (éclaircissement, adaptation)
  GAME:FadeOut(false, 20) -- screen_FadeChange vers alpha 128 (assombrissement, adaptation)
  GAME:FadeIn(20) -- screen_FadeChange vers alpha 256 (éclaircissement, adaptation)
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(120) end)
  SkySubScreen.Hide(150) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 150)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(60)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
