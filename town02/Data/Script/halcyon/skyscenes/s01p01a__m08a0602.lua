-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S01P01A/m08a0602.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetLevel(1) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(9) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetMark(9) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetArrow(9) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" This is where we are now.", french=" Nous sommes ici.", german=" Hier sind wir jetzt.", italian=" Adesso siamo qui.", spanish=" Aquí es donde estamos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Our present location is here.", french=" Nous sommes ici.", german=" Wir befinden uns jetzt hier.", italian=" Adesso siamo qui.", spanish=" Esta es nuestra situación."})
  else
  SkySceneKit.say({english=" This is where we are now.", french=" Nous sommes ici.", german=" Hier sind wir jetzt.", italian=" Adesso siamo qui.", spanish=" Ahora estamos aquí."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- worldmap_DeleteArrow [flèche carte moteur NDS]
  -- worldmap_MoveCamera(13) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetArrow(13) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The base camp is way over\nhere. That's where we have to meet up\nwith everyone.", french="Le camp de base est là.\nC'est là-bas que nous retrouverons les autres.", german="Das Basislager ist dort drüben.\nDa müssen wir uns mit den anderen treffen.", italian="Il Campo Base è da questa parte.\nL'appuntamento con gli altri è lì.", spanish="El campamento base está aquí.\nAhí es donde tenemos que encontrarnos\ncon los demás."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're supposed to link up with\neveryone at the base camp. That's way\nover here.", french="Le camp de base est là.\nC'est là-bas que nous retrouverons les autres.", german="Wir sollen die anderen am\nBasislager treffen. Das liegt dort drüben.", italian="Il Campo Base è da questa parte.\nL'appuntamento con gli altri è lì.", spanish="Tenemos que encontrarnos con\nlos demás en el campamento base,\nque está aquí."})
  else
  SkySceneKit.say({english="We're supposed to join up with\neveryone at the base camp. That's way\nover here.", french="Le camp de base est là.\nC'est là-bas que nous retrouverons les autres.", german="Wir sollen uns mit den anderen\nam Basislager treffen. Das liegt dort drüben.", italian="Il Campo Base è da questa parte.\nL'appuntamento con gli altri è lì.", spanish="Tenemos que encontrarnos con\ntodos en el campamento base, que está aquí."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- worldmap_DeleteArrow [flèche carte moteur NDS]
  -- worldmap_MoveCamera(11) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetArrow(11) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So, as a first step, we could try\nreaching this spot.", french="Pour commencer, nous devons\ndonc essayer d'arriver jusqu'ici.", german="Wir könnten uns also als Erstes\nvornehmen, diesen Punkt zu erreichen.", italian="Quindi, come prima tappa,\npotremmo cercare di raggiungere questo punto.", spanish="¿Qué os parece si vamos\nprimero aquí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So, as a first step, we could try\nreaching this spot.", french="Pour commencer, nous devons\ndonc essayer d'arriver jusqu'ici.", german="Wir könnten uns also als Erstes\nvornehmen, diesen Punkt zu erreichen.", italian="Quindi, come prima tappa,\npotremmo cercare di raggiungere questo punto.", spanish="¿Qué os parece si vamos\nprimero aquí?"})
  else
  SkySceneKit.say({english="So, as a first step, we could try\nreaching this spot.", french="Pour commencer, nous devons\ndonc essayer d'arriver jusqu'ici.", german="Wir könnten uns also als Erstes\nvornehmen, diesen Punkt zu erreichen.", italian="Quindi, come prima tappa,\npotremmo cercare di raggiungere questo punto.", spanish="¿Qué os parece si vamos\nprimero aquí?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Want to try reaching here as\nour first objective?", french="Rejoindre cet endroit, c'est\nnotre premier objectif, d'accord?", german="Wollen wir uns als erstes Ziel\nsetzen, dort hinzugelangen?", italian="Volete provare ad arrivare qui,\ncome primo obiettivo?", spanish="¿Qué tal si nuestro\nprimer objetivo es llegar aquí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Want to try reaching here as\nour first objective?", french="Rejoindre cet endroit, c'est\nnotre premier objectif, d'accord?", german="Wollen wir uns als erstes Ziel\nsetzen, dort hinzugelangen?", italian="Volete provare ad arrivare qui,\ncome primo obiettivo?", spanish="¿Qué os parece que nuestro\nprimer objetivo sea llegar aquí?"})
  else
  SkySceneKit.say({english="Want to try reaching here as\nour first objective?", french="Rejoindre cet endroit, c'est\nnotre premier objectif, d'accord?", german="Wollen wir uns als erstes Ziel\nsetzen, dort hinzugelangen?", italian="Volete provare ad arrivare qui,\ncome primo obiettivo?", spanish="Debemos empezar\ntratando de llegar hasta aquí."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Bidoof", true, "bidoof", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_BIPPA (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Yup yup! I agree with that.", french=" Ouaip! J'suis d'accord.", german=" Jawollja! Ich bin einverstanden.", italian=" Sì, sì! Sono d'accordo.", spanish="¡Sí, señor! Estoy plenamente\nde acuerdo."})
  -- message_Close
  -- GAP: se_Play(6667) — id SE NDS sans portage PMDO identifié
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
end
