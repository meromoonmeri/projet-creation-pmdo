-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P01B/m04a0103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P02A) [décor sub chargé: Sub_v02p02a]
  -- back_SetGround(LEVEL_G01P01B2) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 17.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- screen2_FlushOut [sub déjà caché]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  SkySubScreen.Show("v02p02a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  -- GAP: se_Play(8966) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Oh, now I remember! There was\nthat weird hole in front of the gate...", french="Ah oui, je me rappelle! Il y\navait ce trou bizarre devant l'entrée...", german="Oh, ich weiß es wieder! Da war\ndieses seltsame Loch vor dem Eingang.", italian="Oh, adesso mi ricordo! C'era\nquello strano buco di fronte all'ingresso...", spanish="¡Ah, ya lo recuerdo! Aquel\nagujero tan raro que hay frente a la puerta."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh, now I remember! There was\nthat weird hole in front of the gate...", french="Ah oui, je me rappelle! Il y\navait ce trou bizarre devant l'entrée...", german="Oh, ich weiß es wieder! Da war\ndieses seltsame Loch vor dem Eingang.", italian="Oh, adesso mi ricordo! C'era\nquello strano buco di fronte all'ingresso...", spanish="¡Ah, ya lo recuerdo! Aquel\nagujero tan raro que hay frente a la puerta."})
  else
  SkySceneKit.say({english="Oh, now I remember! There was\nthat weird hole in front of the gate...", french="Ah oui, je me rappelle! Il y\navait ce trou bizarre devant l'entrée...", german="Oh, ich weiß es wieder! Da war\ndieses seltsame Loch vor dem Eingang.", italian="Oh, adesso mi ricordo! C'era\nquello strano buco di fronte all'ingresso...", spanish="¡Ah, ya lo recuerdo! Aquel\nagujero tan raro que hay frente a la puerta."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I stood on the grating, then\nsomeone shouted up at me. It was shocking!", french="Quelqu'un s'est mis à crier\ndès que j'ai fait un pas sur la grille.\nÇa m'a secoué!", german="Ich stand auf dem Gitter,\nund jemand schrie von unten zu mir hoch!\nIch habe einen Riesenschreck bekommen!", italian="Mi sono messo sulla grata e poi\nqualcuno ha urlato. Che spavento!", spanish="Me puse sobre la reja y\nalguien me gritó. ¡Vaya susto!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I stood on the grating, then\nsomeone shouted up at me. It was startling!", french="Quelqu'un s'est mis à crier\ndès que j'ai fait un pas sur la grille.\nÇa m'a secoué!", german="Ich stand auf dem Gitter,\nund jemand schrie von unten zu mir hoch!\nIch bin richtig erschrocken!", italian="Mi sono messo sulla grata e poi\nqualcuno ha urlato. Che spavento mi sono\npreso!", spanish="Me puse sobre la reja y\nalguien me gritó. ¡Vaya susto!"})
  else
  SkySceneKit.say({english="I stood on the grating, then\nsomeone shouted up at me. It was startling!", french="Quelqu'un s'est mis à crier\ndès que j'ai fait un pas sur la grille.\nÇa m'a secouée!", german="Ich stand auf dem Gitter,\nund jemand schrie von unten zu mir hoch!\nIch bin richtig erschrocken!", italian="Mi sono messa sulla grata e poi\nqualcuno ha urlato. Che paura!", spanish="Me puse sobre la reja y\nalguien me gritó. ¡Vaya susto!"})
  end
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  SkySubScreen.Show("v02p02a", 0, false) -- screen2_FlushIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(0) -- screen_FlushIn
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
