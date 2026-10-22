-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P01B/m02d0112.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P01A) [décor sub chargé: Sub_v02p01a]
  -- back_SetGround(LEVEL_G01P01B2) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- screen2_FlushOut [sub déjà caché]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  SkySubScreen.Show("v02p01a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Pokémon detected![K] Pokémon detected!", french=" Pokémon détecté![K] Pokémon détecté!", german=" Pokémon entdeckt![K] Pokémon entdeckt!", italian=" Pokémon in arrivo![K] Pokémon in arrivo!", spanish=" ¡Pokémon detectado![K] ¡Pokémon detectado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Whose footprint?[K] Whose footprint?", french="A qui appartient l'empreinte?[K]\nA qui appartient l'empreinte?", german=" Wessen Fußabdruck?[K] Wessen Fußabdruck?", italian="A chi corrisponde la forma della zampa?[K]\nA chi corrisponde la forma della zampa?", spanish="¿De quién es la huella?[K]\n¿De quién es la huella?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The footprint is [c_kind:ATTENDANT1]'s![K]\nThe footprint is [c_kind:ATTENDANT1]'s!", french="C'est l'empreinte de [c_kind:ATTENDANT1]![K]\nC'est l'empreinte de [c_kind:ATTENDANT1]!", german="Der Fußabdruck ist von [c_kind:ATTENDANT1]![K]\nDer Fußabdruck ist von [c_kind:ATTENDANT1]!", italian="È la zampa di [c_kind:ATTENDANT1]![K]\nÈ la zampa di [c_kind:ATTENDANT1]!", spanish="¡La huella es de [c_kind:ATTENDANT1]![K]\n¡La huella es de [c_kind:ATTENDANT1]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waah!", french=" Aaah!", german=" Waah!", italian=" Waah!", spanish=" ¡Aaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah!", french=" Aaah!", german=" Waah!", italian=" Aaah!", spanish=" ¡Aaah!"})
  else
  SkySceneKit.say({english=" Waah!", french=" Aaah!", german=" Waah!", italian=" Aaah!", spanish=" ¡Aaah!"})
  end
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Show("v02p01a", 0, false) -- screen2_FlushIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
