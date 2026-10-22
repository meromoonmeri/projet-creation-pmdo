-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S01P01A/m08a1002.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Mt. Horn.ogg", true) end)
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetLevel(1) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(11) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetArrow(11) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  -- worldmap_SetMark(11) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" This is where we are now.", french=" Maintenant nous sommes ici.", german=" Hier sind wir jetzt.", italian=" Adesso siamo qui.", spanish=" Ahora estamos aquí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Our present location is here.", french=" Maintenant nous sommes ici.", german=" Wir befinden uns jetzt hier.", italian=" Adesso siamo qui.", spanish=" Ahora estamos aquí."})
  else
  SkySceneKit.say({english=" This must be where we are.", french=" Maintenant nous sommes ici.", german=" Wir müssten jetzt hier sein.", italian=" Adesso siamo qui.", spanish=" Ahora estamos aquí."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- worldmap_DeleteArrow [flèche carte moteur NDS]
  -- worldmap_MoveCamera(13) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetArrow(13) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" The base camp is there.", french=" Le camp de base est là.", german=" Dort ist das Basislager.", italian=" Il Campo Base è lì.", spanish=" El campamento base está aquí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" The base camp is there.", french=" Le camp de base est là.", german=" Dort ist das Basislager.", italian=" Il Campo Base è lì.", spanish=" El campamento base está aquí."})
  else
  SkySceneKit.say({english=" The base camp is there.", french=" Le camp de base est là.", german=" Dort ist das Basislager.", italian=" Il Campo Base è lì.", spanish=" El campamento base está aquí."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Bidoof", true, "bidoof", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_BIPPA (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I reckon we've gotten ourselves\na lot closer.", french=" On s'est pas mal rapprochés.", german="Ich würde sagen, wir sind schon\nziemlich weit gekommen.", italian="Penso che ci siamo avvicinati\nmolto.", spanish="Sin duda, ahora estamos\nmucho más cerca."})
  -- message_Close
  -- GAP: se_Play(6667) — id SE NDS sans portage PMDO identifié
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
end
