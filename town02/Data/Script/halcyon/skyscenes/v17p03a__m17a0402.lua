-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V17P03A/m17a0402.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V17P01A) [décor sub chargé: Sub_v17p01a]
  -- back_SetGround(LEVEL_V17P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 17, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(232, 156, 60, false) end) -- performer/caméra
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(240), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(2.0,0.0) px/frame -> caméra continue (pilote scroll)
  -- GAP: BGM BGM_PLANETS_PARALYSIS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v17p01a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(60)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- back_SetBackScrollSpeed(0,0): arrêt du défilement
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This is...[K]our world?[K]\nIn the future?", french="C'est...[K] notre monde?[K]\nDans le futur?", german="Ist das...[K] unsere Welt?[K]\nIn der Zukunft?", italian="Questo è...[K] il nostro mondo?[K]\nNel futuro?", spanish="Este es...[K] ¿nuestro mundo?[K]\n¿Así es en el futuro?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This is...[K]our world?[K]\nIn the future?", french="C'est...[K] notre monde?[K]\nDans le futur?", german="Ist das...[K] unsere Welt?[K]\nIn der Zukunft?", italian="Questo è...[K] il nostro mondo?[K]\nNel futuro?", spanish="Este es...[K] ¿nuestro mundo?[K]\n¿Así es en el futuro?"})
  else
  SkySceneKit.say({english="This is...[K]our world?[K]\nIn the future?", french="C'est...[K] notre monde?[K]\nDans le futur?", german="Ist das...[K] unsere Welt?[K]\nIn der Zukunft?", italian="Questo è...[K] il nostro mondo?[K]\nNel futuro?", spanish="Este es...[K] ¿nuestro mundo?[K]\n¿Así es en el futuro?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Those boulders are floating![K]\nThis is really a strange place...", french="Ces pierres flottent\nlittéralement dans les airs![K] Décidément,\ncet endroit est très étrange...", german="Die Felsen schweben![K]\nDas ist wirklich ein merkwürdiger Ort...", italian="Quei massi stanno galleggiando![K]\nÈ davvero un posto strano...", spanish="¡Esas piedras están flotando![K]\nEste lugar es muy extraño."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Those boulders are floating![K]\nThis is really a strange place...", french="Ces pierres flottent\nlittéralement dans les airs![K] Décidément,\ncet endroit est très étrange...", german="Die Felsen schweben![K]\nDas ist wirklich ein merkwürdiger Ort...", italian="Quei massi stanno galleggiando![K]\nÈ davvero un posto strano...", spanish="¡Esas piedras están flotando![K]\nEste lugar es muy extraño."})
  else
  SkySceneKit.say({english="Those boulders are floating![K]\nThis is really a strange place...", french="Ces pierres flottent\nlittéralement dans les airs![K] Décidément,\ncet endroit est très étrange...", german="Die Felsen schweben![K]\nDas ist wirklich ein merkwürdiger Ort...", italian="Quei massi stanno galleggiando![K]\nÈ davvero un posto strano...", spanish="¡Esas piedras están flotando![K]\nEste lugar es muy extraño."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" And it's horribly dark...", french=" Et il fait horriblement sombre...", german=" Und es ist schrecklich dunkel.", italian=" Ed è terribilmente buio...", spanish=" Y está horriblemente oscuro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" And it's horribly dark...", french=" Et il fait horriblement sombre...", german=" Und es ist schrecklich dunkel.", italian=" Ed è terribilmente buio...", spanish=" Y está horriblemente oscuro."})
  else
  SkySceneKit.say({english=" And it's horribly dark...", french=" Et il fait horriblement sombre...", german=" Und es ist schrecklich dunkel.", italian=" Ed è terribilmente buio...", spanish=" Y está horriblemente oscuro."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Not even the wind blows...", french=" Pas même un courant d'air...", german=" Es weht nicht einmal der Wind.", italian="Non c'è nemmeno un filo di\nvento...", spanish=" Ni siquiera sopla el viento..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Not even the wind blows...", french=" Pas même un courant d'air...", german=" Es weht nicht einmal der Wind.", italian="Non c'è nemmeno un filo di\nvento...", spanish=" Ni siquiera sopla el viento..."})
  else
  SkySceneKit.say({english=" Not even the wind blows...", french=" Pas même un courant d'air...", german=" Es weht nicht einmal der Wind.", italian="Non c'è nemmeno un filo di\nvento...", spanish=" Ni siquiera sopla el viento..."})
  end
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
