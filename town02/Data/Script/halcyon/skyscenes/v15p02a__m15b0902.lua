-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V15P02A/m15b0902.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_V15P02A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(456, 180, 60, false) end) -- performer/caméra
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- message_SetWaitMode(100, 60) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Incredible!", french=" Incroyable!", german=" Unglaublich!", italian=" È fantastico!", spanish=" ¡Increíble!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Incredible!", french=" Incroyable!", german=" Unglaublich!", italian=" È fantastico!", spanish=" ¡Increíble!"})
  else
  SkySceneKit.say({english=" Fantastic!", french=" Incroyable!", german=" Fantastisch!", italian=" È fantastico!", spanish=" ¡Fantástico!"})
  end
  -- message_KeyWait
  -- message_SetWaitMode(150, 45) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Look at all those crystals\nsticking up from the lake.", french="Regarde un peu tous\nces cristaux!", german="Sieh dir all die Kristalle an,\ndie aus dem See ragen.", italian="Guarda tutti quei cristalli che\nspuntano dall'acqua...", spanish="Mira todos esos cristales que\nasoman en el lago."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Look at all those crystals\nemerging from the lake's surface.", french="Regarde un peu tous\nces cristaux!", german="Sieh dir all die Kristalle an,\ndie aus dem See ragen.", italian="Guarda tutti quei cristalli che\nspuntano dall'acqua...", spanish="Mira todos esos cristales que\nasoman sobre la superficie del lago."})
  else
  SkySceneKit.say({english="Look at all those crystals\nsticking up from the surface.", french="Regarde un peu tous\nces cristaux!", german="Sieh dir all die Kristalle an,\ndie aus dem See ragen.", italian="Guarda tutti quei cristalli che\nspuntano dall'acqua...", spanish="Mira todos esos cristales que\nasoman sobre la superficie del lago."})
  end
  -- message_KeyWait
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Is this lake...[K]where [CS:N]Azelf[CR] lives?", french="Est-ce que c'est le lac...[K]\nde [CS:N]Créfadet[CR]?", german="Ist das der See,[K] an dem [CS:N]Tobutz[CR]\nlebt?", italian="Sarà questo...[K] il lago dove vive\n[CS:N]Azelf[CR]?", spanish="¿Será este el lago?[K] ¿Será aquí\ndonde vive [CS:N]Azelf[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Is this lake...[K]where [CS:N]Azelf[CR] lives?", french="Est-ce que c'est le lac...[K]\nde [CS:N]Créfadet[CR]?", german="Ist das der See,[K] an dem [CS:N]Tobutz[CR]\nlebt?", italian="Sarà questo...[K] il lago dove vive\n[CS:N]Azelf[CR]?", spanish="¿Será este el lago?[K] ¿Será aquí\ndonde vive [CS:N]Azelf[CR]?"})
  else
  SkySceneKit.say({english=" Is this lake...[K]where [CS:N]Azelf[CR] lives?", french="Est-ce que c'est le lac...[K]\nde [CS:N]Créfadet[CR]?", german="Ist das der See,[K] an dem [CS:N]Tobutz[CR]\nlebt?", italian="Sarà questo...[K] il lago dove vive\n[CS:N]Azelf[CR]?", spanish="¿Será este el lago?[K] ¿Será aquí\ndonde vive [CS:N]Azelf[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_SetWaitMode(-1, -1) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ............", french=" ............", german=" ............", italian=" ............", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ............", french=" ............", german=" ............", italian=" ............", spanish=" ..."})
  else
  SkySceneKit.say({english=" ............", french=" ............", german=" ............", italian=" ............", spanish=" ..."})
  end
  -- message_KeyWait
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [hero]!", french=" Eh, [hero]!", german=" Hey, [hero]!", italian=" Ehi, [hero]!", spanish=" Oye, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey, [hero]!", french=" Eh, [hero]!", german=" Hey, [hero]!", italian=" Ehi, [hero]!", spanish=" Oye, [hero]."})
  else
  SkySceneKit.say({english=" Oh, [hero]!", french=" Eh, [hero]!", german=" Oh, [hero]!", italian=" Oh, [hero]!", spanish=" Oye, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Look over there!", french=" Regarde là-bas!", german=" Sieh mal her!", italian=" Guarda laggiù!", spanish=" ¡Por allí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Look over there!", french=" Regarde là-bas!", german=" Sieh mal her!", italian=" Guarda laggiù!", spanish=" ¡Por allí!"})
  else
  SkySceneKit.say({english=" Look over there!", french=" Regarde là-bas!", german=" Sieh mal her!", italian=" Guarda laggiù!", spanish=" ¡Por allí!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Look! In the middle of the\nlake...[K] Where it's like an island...", french="Regarde! Au milieu du lac...\n[K]il y a une sorte d'île...", german="Sieh nur! In der Mitte des\nSees![K] Da ist eine Art Insel...", italian="Al centro del lago...[K] c'è come\nun'isoletta.", spanish="¡Mira! En medio del lago...[K]\nEso que parece una isla..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Look! In the middle of the\nlake...[K] Where it's like an island...", french="Regarde! Au milieu du lac...\n[K]il y a une sorte d'île...", german="Sieh nur! In der Mitte des\nSees![K] Da ist eine Art Insel...", italian="Al centro del lago...[K] c'è come\nun'isoletta.", spanish="¡Mira! En medio del lago...[K]\nEso que parece una isla..."})
  else
  SkySceneKit.say({english="Look! In the middle of the\nlake...[K] Where it's like an island...", french="Regarde! Au milieu du lac...\n[K]il y a une sorte d'île...", german="Sieh nur! In der Mitte des\nSees![K] Da ist eine Art Insel...", italian="Al centro del lago...[K] c'è come\nun'isoletta.", spanish="¡Mira! En medio del lago...[K]\nEso que parece una isla..."})
  end
  -- message_Close
  pcall(function() GAME:MoveCamera(352, 180, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" There's someone there!", french=" ... et il y a quelqu'un là-bas!", german=" Da ist jemand!", italian="Mi sembra di vedere\nqualcuno laggiù!", spanish=" ¡Hay alguien allí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I think I see someone!", french=" ... et il y a quelqu'un là-bas!", german=" Ich glaube, ich sehe jemanden!", italian="Mi sembra di vedere\nqualcuno laggiù!", spanish=" ¡Creo que veo a alguien!"})
  else
  SkySceneKit.say({english=" I think I see someone!", french=" ... et il y a quelqu'un là-bas!", german=" Ich glaube, ich sehe jemanden!", italian="Mi sembra di vedere\nqualcuno laggiù!", spanish=" ¡Creo que veo a alguien!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go!", french=" Allons-y!", german=" Gehen wir hin!", italian=" Andiamo!", spanish=" ¡Vamos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go!", french=" Allons-y!", german=" Gehen wir hin!", italian=" Andiamo!", spanish=" ¡Vamos!"})
  else
  SkySceneKit.say({english=" Let's go!", french=" Allons-y!", german=" Gehen wir hin!", italian=" Andiamo!", spanish=" ¡Vamos!"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(30)
end
