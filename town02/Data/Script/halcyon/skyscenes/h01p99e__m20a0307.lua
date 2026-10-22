-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99E/m20a0307.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- bgm2_PlayFadeIn(BGM_ON_THE_BEACH_AT_DUSK) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V21P02B) [décor sub chargé: Sub_v21p02b]
  -- back_SetGround(LEVEL_H01P99E) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 20, 18.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  SkySubScreen.Show("v21p02b", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  -- bgm_ChangeVolume(140,190) [volume BGM non scriptable en Lua PMDO: piste maintenue - documenté]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yes, [hero] was always\nthere to cheer me up...", french="Oui, [hero] a toujours\nété là pour me remonter le moral...", german="Ja, [hero] war immer da,\num mich aufzubauen...", italian="Sì, [hero] era sempre\nqui a tirarmi su il morale...", spanish="Sí, [hero] siempre estaba\nahí para animarme..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yes, [hero] was always\nthere to cheer me up...", french="Oui, [hero] a toujours\nété là pour me remonter le moral...", german="Ja, [hero] war immer da,\num mich aufzubauen...", italian="Sì, [hero] era sempre\nqui a tirarmi su il morale...", spanish="Sí, [hero] siempre estaba\nahí para animarme..."})
  else
  SkySceneKit.say({english="Yes, [hero] was always\nthere to cheer me up...", french="Oui, [hero] a toujours\nété là pour me remonter le moral...", german="Ja, [hero] war immer da,\num mich aufzubauen...", italian="Sì, [hero] era sempre\nqui a tirarmi su il morale...", spanish="Sí, [hero] siempre estaba\nahí para animarme..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" And...", french=" ... et...", german=" Und...", italian=" E...", spanish=" Y además..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" And...", french=" ... et...", german=" Und...", italian=" E...", spanish=" Y además..."})
  else
  SkySceneKit.say({english=" And...", french=" ... et...", german=" Und...", italian=" E...", spanish=" Y además..."})
  end
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  pcall(function() SOUND:FadeOutBGM(140) end) -- bgm_ChangeVolume vers 0 (silence)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
