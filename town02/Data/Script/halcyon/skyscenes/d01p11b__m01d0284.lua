-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11B/m01d0284.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V01P03B) [décor sub chargé: Sub_v01p03b]
  -- back_SetGround(LEVEL_D01P11B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 33, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  -- supervision_SpecialActing(21, 600, 0) [cadrage NDS]
  -- supervision2_SpecialActing(21, 600, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 352, 176, Direction.DownLeft, "NPC_ZUBATTO")
  -- SetOutputAttribute(2) [neutre/état moteur]
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 352, 200, Direction.Left, "NPC_DOGAASU")
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(5) [anim idle native]
  -- screen2_FlushOut [sub déjà caché]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  SkySubScreen.Show("v01p03b", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Sorry, kiddo. We'll take that!", french="Désolé, mon chou. On va te\nle prendre!", german="Sorry, du Zwerg. Aber das\nnehmen wir!", italian=" Questo ce lo prendiamo noi!", spanish="Lo siento, colega.\n¡Nos lo quedamos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_zubatto.Position; GROUND:MoveToPosition(npc_npc_zubatto, p.X+(-28), p.Y+(24), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- message_FacePositionOffset(2, 1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Aaaah!", french=" Aaah!", german=" Aaaah!", italian=" Aaaah!", spanish=" ¡Aaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Aaaah!", french=" Aaah!", german=" Aaaah!", italian=" Aaaah!", spanish=" ¡Aaah!"})
  else
  SkySceneKit.say({english=" Aaaah!", french=" Aaah!", german=" Aaaah!", italian=" Aaaah!", spanish=" ¡Aaah!"})
  end
  GAME:WaitFrames(10)
  do local p=npc_npc_zubatto.Position; GROUND:MoveToPosition(npc_npc_zubatto, p.X+(28), p.Y+(-24), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_zubatto, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_zubatto, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_zubatto, 4) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Whoa-ho-ho![K] Not gonna make a\nmove to get that back?[K] What's the matter?[K]\nToo scared?", french="Mouarf![K] Tu lèves même pas\nle petit doigt pour le récupérer?[K] Qu'est-ce qui\nt'arrive?[K] T'as trop peur?", german="Whoahoho![K] Willst du es dir\nnicht zurückholen?[K] Was ist los?[K]\nHast du etwa Angst?", italian="Ooooh![K] Non provi a\nriprendertelo?[K] Cosa c'è?[K]\nTroppa fifa?", spanish="¡Jo, jo, jo![K] ¿Es que no vas a\nmover ni un dedo para recuperarlo?[K]\n¿Qué te pasa?[K] ¿Tienes miedo?"})
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="I didn't expect that you'd be such\na big coward!", french="Je pensais pas avoir affaire\nà une poule mouillée pareille!", german="Ich hätte nicht gedacht, dass du\nso ein Angsthase bist!", italian="Non pensavo che avresti avuto\ncosì tanta paura!", spanish="¡No me esperaba que fueras\ntan cobarde!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogaasu, npc_npc_zubatto, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, npc_npc_dogaasu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Come on. Let's get out of here.", french=" Allez, on s'en va!", german=" Komm schon. Hauen wir ab.", italian=" Forza, andiamocene via di qua.", spanish=" Venga. Vámonos de aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogaasu, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="See you around, chicken.[K]\nHeh-heh-heh.", french="A bientôt, poule mouillée.[K]\nHin hin hin!", german="Bis irgendwann, du Memme.[K]\nHehehe.", italian="Ci vediamo, pusillanime.[K]\nEh-eh-eh.", spanish="Nos vemos, gallina.[K]\nJue, jue, jue."})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_dogaasu, 96, 212, false, 2)
  GROUND:EntTurn(npc_npc_zubatto, Direction.DownLeft)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Show("v01p03b", 0, false) -- screen2_FlushIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(0) -- screen_FlushIn
  -- supervision_SpecialActing(3, 0, 0) [cadrage NDS]
  -- supervision2_SpecialActing(3, 0, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
