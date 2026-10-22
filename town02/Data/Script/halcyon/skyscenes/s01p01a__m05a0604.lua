-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S01P01A/m05a0604.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Heartwarming.ogg", true) end)
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetLevel(1) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(192) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker("Torkoal", true, "torkoal", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_KOOTASU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" There.[K] We are here.", french=" Voilà.[K] Nous sommes ici.", german=" Da.[K] Hier sind wir.", italian=" Ecco.[K] Siamo qui.", spanish=" ¿Veis?[K] Estamos aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- worldmap_SetArrow(192) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  pcall(function() UI:SetSpeaker("Torkoal", true, "torkoal", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_KOOTASU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" This is the Hot Spring's location.", french="C'est ici que se trouve la Source\nChaude.", german=" Hier liegt die Heiße Quelle.", italian="La Sorgente Termale si trova\nqui.", spanish=" Aquí es donde está la Terma."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh. I get it.", french=" D'accord. Je vois.", german=" Oh. Alles klar.", italian=" Oh. Capisco.", spanish=" Ah. Ya veo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh. I see.", french=" D'accord. Je vois.", german=" Oh. Verstehe.", italian=" Oh. Capisco.", spanish=" Ah. Ya veo."})
  else
  SkySceneKit.say({english=" Oh. OK.", french=" D'accord. Je vois.", german=" Oh. Okay.", italian=" Oh. Capisco.", spanish=" Ah. Vale."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- worldmap_DeleteArrow [flèche carte moteur NDS]
  -- worldmap_MoveCamera(7) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetArrow(7) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" The waterfall is over here, so...", french=" La cascade est par là, alors...", german="Der Wasserfall ist dort drüben,\nalso...", italian=" La cascata è qui sopra, quindi...", spanish=" La cascada está aquí, así que..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" The waterfall is here, so...", french=" La cascade est par là, alors...", german="Der Wasserfall ist dort drüben,\nalso...", italian=" La cascata è qui sopra, quindi...", spanish=" La cascada está aquí, así que..."})
  else
  SkySceneKit.say({english="The waterfall's located here,\nso...", french=" La cascade est par là, alors...", german="Der Wasserfall ist dort drüben,\nalso...", italian=" La cascata è qui sopra, quindi...", spanish=" La cascada está aquí, así que..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey! Check this out,\n[hero]!", french="Waouh! Regarde ça,\n[hero]!", german=" Hey! Sieh mal, [hero]!", italian="Ehi! Guarda qui,\n[hero]!", spanish=" ¡Oye! ¡Fíjate, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hey! Check this out,\n[hero]!", french="Waouh! Regarde ça,\n[hero]!", german=" Hey! Sieh mal, [hero]!", italian="Ehi! Guarda qui,\n[hero]!", spanish=" ¡Oye! ¡Fíjate, [hero]!"})
  else
  SkySceneKit.say({english="Hey! Check this out,\n[hero]!", french="Waouh! Regarde ça,\n[hero]!", german=" Hey! Sieh mal, [hero]!", italian="Ehi! Guarda qui,\n[hero]!", spanish=" ¡Oye! ¡Fíjate, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- worldmap_DeleteArrow [flèche carte moteur NDS]
  -- worldmap_MoveCamera(192) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetArrow(192) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The water carried us all the way\nover here.", french="Le courant nous a entraînés\njusqu'ici.", german="Das Wasser hat uns den ganzen\nWeg bis hierher getragen.", italian=" L'acqua ci ha trasportati fin qui.", spanish=" El agua nos ha traído hasta aquí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The water carried us all the way\nover here.", french="Le courant nous a entraînés\njusqu'ici.", german="Das Wasser hat uns den ganzen\nWeg bis hierher getragen.", italian=" L'acqua ci ha trasportati fin qui.", spanish=" El agua nos ha traído hasta aquí."})
  else
  SkySceneKit.say({english="The water carried us all the way\nover here.", french="Le courant nous a fait parcourir\ntout ce chemin!", german="Das Wasser hat uns den ganzen\nWeg bis hierher getragen.", italian="Quanta strada abbiamo fatto con\nl'acqua!", spanish=" El agua nos ha traído hasta aquí."})
  end
  -- message_Close
  -- GAP: se_Play(6667) — id SE NDS sans portage PMDO identifié
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
end
