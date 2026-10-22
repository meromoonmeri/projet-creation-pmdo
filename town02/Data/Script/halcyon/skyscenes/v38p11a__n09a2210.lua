-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V38P11A/n09a2210.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM BGM_A_NEW_WORLD non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V38P09A) [décor sub chargé: Sub_v38p09a]
  -- back_SetGround(LEVEL_V38P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(480), g.ViewCenter.Y+(300), 120, false) end) -- back_SetBackScrollSpeed(4.0,2.5) px/frame -> caméra continue (pilote scroll)
  -- SetAnimation(17) [anim idle native]
  SkySubScreen.Show("v38p09a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  pcall(function() UI:SetSpeaker("Celebi", true, "celebi", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SEREBII (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Wow!", french=" Waouh!", german=" Wow!", italian=" Wow!", spanish=" ¡Vaya!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Th-the land...", french=" La terre...", german=" D-das Land...", italian=" L-La terra...", spanish=" Las plantas..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" The land...it turned green!", french=" La terre devient verte!", german=" Das Land... Es ist ergrünt!", italian="La terra... è diventata tutta\nverde!", spanish=" Las plantas... ¡han vuelto a crecer!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Celebi", true, "celebi", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SEREBII (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Such...[K]such a beautiful scene...", french=" Quel...[K] spectacle magnifique...", german="Was...[K] Was für\nein schöner Anblick!", italian=" Che...[K] Che scena meravigliosa...", spanish=" Qué paisaje...[K] tan hermoso..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" This is [CS:N]Dialga[CR]'s...", french=" C'est...", german=" Das war [CS:N]Dialga[CR]...", italian=" Questo è...", spanish=" [CS:N]Dialga[CR]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" This is [CS:N]Dialga[CR]'s power!", french=" ... le pouvoir de [CS:N]Dialga[CR]!", german=" Die Kräfte von [CS:N]Dialga[CR]!", italian=" Questo è il potere di [CS:N]Dialga[CR]!", spanish=" ¡¿[CS:N]Dialga[CR] puede hacer todo esto?!"})
  -- message_Close
  -- GAP: se_Play(11539) — id SE NDS sans portage PMDO identifié
  pcall(function() SOUND:FadeOutBGM(150) end)
  SkySubScreen.Hide(30) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  -- back_SetBackScrollSpeed(0,0): arrêt du défilement
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
