-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/m16a0102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_T01P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  GAME:FadeIn(30)
  local npc_npc_s_agunomu = SkySceneKit.spawn_npc("azelf", 568, 200, Direction.Down, "NPC_S_AGUNOMU")
  do local p=npc_npc_s_agunomu.Position; GROUND:MoveToPosition(npc_npc_s_agunomu, p.X+(-72), p.Y+(0), false, 2) end
  local npc_npc_s_dogoomu = SkySceneKit.spawn_npc("loudred", 576, 240, Direction.UpRight, "NPC_S_DOGOOMU")
  do local p=npc_npc_s_dogoomu.Position; GROUND:MoveToPosition(npc_npc_s_dogoomu, p.X+(-72), p.Y+(0), false, 2) end
  local npc_npc_s_perappu = SkySceneKit.spawn_npc("chatot", 536, 192, Direction.DownLeft, "NPC_S_PERAPPU")
  do local p=npc_npc_s_perappu.Position; GROUND:MoveToPosition(npc_npc_s_perappu, p.X+(-72), p.Y+(0), false, 2) end
  local npc_npc_s_pukurin = SkySceneKit.spawn_npc("wigglytuff", 544, 216, Direction.Down, "NPC_S_PUKURIN")
  do local p=npc_npc_s_pukurin.Position; GROUND:MoveToPosition(npc_npc_s_pukurin, p.X+(-72), p.Y+(0), false, 2) end
  local npc_npc_s_kimawari = SkySceneKit.spawn_npc("sunflora", 528, 232, Direction.UpLeft, "NPC_S_KIMAWARI")
  do local p=npc_npc_s_kimawari.Position; GROUND:MoveToPosition(npc_npc_s_kimawari, p.X+(-72), p.Y+(0), false, 2) end
  local npc_npc_s_bippa = SkySceneKit.spawn_npc("bidoof", 584, 216, Direction.Up, "NPC_S_BIPPA")
  do local p=npc_npc_s_bippa.Position; GROUND:MoveToPosition(npc_npc_s_bippa, p.X+(-72), p.Y+(0), false, 2) end
  local npc_npc_s_chiriin = SkySceneKit.spawn_npc("chimecho", 552, 240, Direction.Up, "NPC_S_CHIRIIN")
  do local p=npc_npc_s_chiriin.Position; GROUND:MoveToPosition(npc_npc_s_chiriin, p.X+(-72), p.Y+(0), false, 2) end
  local npc_npc_s_heigani = SkySceneKit.spawn_npc("corphish", 600, 208, Direction.UpRight, "NPC_S_HEIGANI")
  do local p=npc_npc_s_heigani.Position; GROUND:MoveToPosition(npc_npc_s_heigani, p.X+(-72), p.Y+(0), false, 2) end
  local npc_npc_s_diguda = SkySceneKit.spawn_npc("diglett", 600, 232, Direction.UpLeft, "NPC_S_DIGUDA")
  do local p=npc_npc_s_diguda.Position; GROUND:MoveToPosition(npc_npc_s_diguda, p.X+(-72), p.Y+(0), false, 2) end
  local npc_npc_s_dagutorio = SkySceneKit.spawn_npc("dugtrio", 624, 240, Direction.DownRight, "NPC_S_DAGUTORIO")
  do local p=npc_npc_s_dagutorio.Position; GROUND:MoveToPosition(npc_npc_s_dagutorio, p.X+(-72), p.Y+(0), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-72), p.Y+(0), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-72), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_himeguma = SkySceneKit.spawn_npc("teddiursa", 296, 200, Direction.UpRight, "NPC_HIMEGUMA")
  GROUND:EntTurn(npc_npc_himeguma, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_himeguma, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" Oh, look![K] The guild members!", french="Oh, regardez![K] Les membres\nde la Guilde!", german=" Oh, da![K] Die Gildenmitglieder!", italian="Oh, guarda![K] Sono quelli della\nGilda!", spanish="Fíjate...[K] Allí están los miembros\ndel [CS:N]Pokégremio[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(48), g.ViewCenter.Y+(0), 48, false) end) -- MovePositionOffset performer/caméra
  local npc_npc_s_yukushii = SkySceneKit.spawn_npc("uxie", 392, 200, Direction.UpLeft, "NPC_S_YUKUSHII")
  GROUND:EntTurn(npc_npc_s_yukushii, Direction.Right)
  GAME:WaitFrames(5)
  local npc_npc_s_emuritto = SkySceneKit.spawn_npc("mesprit", 376, 216, Direction.UpLeft, "NPC_S_EMURITTO")
  GROUND:EntTurn(npc_npc_s_emuritto, Direction.Right)
  local npc_npc_s_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 352, 176, Direction.Down, "NPC_S_YONOWAARU")
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.DownRight)
  local npc_npc_yarukimono = SkySceneKit.spawn_npc("vigoroth", 352, 224, Direction.Up, "NPC_YARUKIMONO")
  GROUND:EntTurn(npc_npc_yarukimono, Direction.Right)
  GAME:WaitFrames(5)
  local npc_npc_ringuma = SkySceneKit.spawn_npc("ursaring", 320, 216, Direction.Up, "NPC_RINGUMA")
  GROUND:EntTurn(npc_npc_ringuma, Direction.Right)
  local npc_npc_oosubame = SkySceneKit.spawn_npc("swellow", 376, 248, Direction.Up, "NPC_OOSUBAME")
  GROUND:EntTurn(npc_npc_oosubame, Direction.Right)
  local npc_npc_poppo = SkySceneKit.spawn_npc("pidgey", 352, 248, Direction.Up, "NPC_POPPO")
  GROUND:EntTurn(npc_npc_poppo, Direction.Right)
  local npc_npc_taneboo = SkySceneKit.spawn_npc("seedot", 328, 248, Direction.Up, "NPC_TANEBOO")
  GROUND:EntTurn(npc_npc_taneboo, Direction.Right)
  GAME:WaitFrames(5)
  local npc_npc_jibakoiru = SkySceneKit.spawn_npc("magnezone", 320, 168, Direction.Down, "NPC_JIBAKOIRU")
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.DownRight)
  local npc_npc_koiru = SkySceneKit.spawn_npc("magnemite", 288, 176, Direction.Down, "NPC_KOIRU")
  GROUND:EntTurn(npc_npc_koiru, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="So the guild's Pokémon were\neven called!", french="Alors ils ont été convoqués,\neux aussi!", german="Also wurden sogar die Pokémon\nvon der Gilde hergerufen!", italian="Hanno chiamato anche quelli della\nGilda, allora!", spanish="Así que también han llamado\na los Pokémon del [CS:N]Pokégremio[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" For them to be called...", french=" Pour qu'ils soient là...", german=" Wenn sogar sie geholt wurden...", italian=" Hanno chiamato anche loro!", spanish=" Si les han llamado..."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Something serious must be\nhappening...", french="... il faut que ce soit quelque\nchose de grave, quoi!", german="Dann muss die Sache wirklich\nernst sein.", italian="Deve trattarsi di qualcosa di\ngrave!", spanish="Es que ha pasado algo muy\nserio..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_yukushii, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Uxie", true, "uxie", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YUKUSHII (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" [CS:N]Azelf[CR]!", french=" [CS:N]Créfadet[CR]!", german=" [CS:N]Tobutz[CR]!", italian=" [CS:N]Azelf[CR]!", spanish=" ¡[CS:N]Azelf[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_agunomu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Azelf", true, "azelf", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AGUNOMU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" [CS:N]Uxie[CR]![K] [CS:N]Mesprit[CR]!", french=" [CS:N]Créhelf[CR]![K] [CS:N]Créfollet[CR]!", german=" [CS:N]Selfe[CR]![K] [CS:N]Vesprit[CR]!", italian=" [CS:N]Uxie[CR]![K] [CS:N]Mesprit[CR]!", spanish=" ¡[CS:N]Uxie[CR]![K] ¡[CS:N]Mesprit[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_s_agunomu.Position; GROUND:MoveToPosition(npc_npc_s_agunomu, p.X+(-64), p.Y+(8), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_s_yukushii.Position; GROUND:MoveToPosition(npc_npc_s_yukushii, p.X+(16), p.Y+(0), false, 2) end
  do local p=npc_npc_s_emuritto.Position; GROUND:MoveToPosition(npc_npc_s_emuritto, p.X+(32), p.Y+(0), false, 2) end
  GROUND:EntTurn(npc_npc_s_emuritto, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Mesprit", true, "mesprit", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_EMURITTO (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Are you all right?\nYou're not hurt?", french=" Tu vas bien? Tu n'es pas blessé?", german=" Alles okay? Bist du verletzt?", italian=" Stai bene?", spanish=" ¿Estás bien? ¿Estás herido?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Azelf", true, "azelf", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AGUNOMU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Yep. I'm OK.", french=" Tout va bien.", german=" Nein, mir geht es gut.", italian=" Sì, grazie. Sto bene.", spanish=" Estoy bien."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Uxie", true, "uxie", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YUKUSHII (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" The Time Gear?", french=" Le Rouage du Temps?", german=" Und das Zahnrad der Zeit?", italian=" E l'Ingranaggio del Tempo?", spanish=" ¿Y el Engranaje del Tiempo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Azelf", true, "azelf", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AGUNOMU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" It's in [CS:P]Shining Lake[CR].", french=" Toujours dans le [CS:P]Lac Cristal[CR].", german=" Es ist im [CS:P]Kristallsee[CR].", italian=" Si trova al [CS:P]Lago di Cristallo[CR].", spanish=" Está en el [CS:P]Lago Cristal[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Mesprit", true, "mesprit", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_EMURITTO (espèce ROM, sans placement zone)
  SkySceneKit.say({english="It will be safe there without\nyour protection?[K] It can't be stolen?", french="Et il ne risque rien, là-bas, sans\nsurveillance?[K] Personne ne peut le voler?", german="Ist es dort so unbewacht\nsicher?[K] Kann es nicht gestohlen werden?", italian="Sarà davvero prudente lasciarlo\nincustodito?[K] E se lo rubassero?", spanish="¿Estará a salvo sin que tú estés\nallí para protegerlo?[K] ¿No correrá peligro?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Azelf", true, "azelf", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AGUNOMU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Yep. It will be safe for now.", french="Ouaip. Il est en sécurité pour\nl'instant.", german=" Es ist fürs Erste dort sicher.", italian=" Per il momento è al sicuro.", spanish=" Está bien protegido por ahora."})
  pcall(function() UI:SetSpeaker("Azelf", true, "azelf", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AGUNOMU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="The Time Gear is protected by\nan encasing cover of crystals.", french="Le Rouage du Temps est à l'abri\nd'un coffrage en cristal.", german="Das Zahnrad der Zeit liegt\nsicher unter einer schützenden Schicht von\nKristallen.", italian="L'Ingranaggio del Tempo è\nprotetto dai cristalli.", spanish="El Engranaje del Tiempo tiene\nahora una cobertura protectora de cristales."})
  pcall(function() UI:SetSpeaker("Azelf", true, "azelf", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AGUNOMU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Stealing it won't be easy.", french="Difficile de s'en emparer dans\nces conditions-là.", german="Es wäre nicht leicht, es zu\nstehlen.", italian="Vi assicuro che non è facile\nrubarlo.", spanish=" No será fácil robarlo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-40), p.Y+(0), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-40), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! [CS:N]Dusknoir[CR], sir!", french=" Oh! Messire [CS:N]Noctunoir[CR]!", german=" Hey! [CS:N]Zwirrfinst[CR]!", italian=" Ehi! Signor [CS:N]Dusknoir[CR]!", spanish=" ¡[CS:N]Dusknoir[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! [CS:N]Dusknoir[CR], sir!", french=" Oh! Messire [CS:N]Noctunoir[CR]!", german=" Hey! [CS:N]Zwirrfinst[CR]!", italian=" Ehi! Signor [CS:N]Dusknoir[CR]!", spanish=" ¡[CS:N]Dusknoir[CR]!"})
  else
  SkySceneKit.say({english=" Oh! [CS:N]Dusknoir[CR], sir!", french=" Oh! Messire [CS:N]Noctunoir[CR]!", german=" Oh! [CS:N]Zwirrfinst[CR]!", italian=" Ehi! Signor [CS:N]Dusknoir[CR]!", spanish=" ¡[CS:N]Dusknoir[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_s_perappu, Direction.Right)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_yonowaaru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 352, 192, Direction.Down, "NPC_YONOWAARU")
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Ah! [partner] and\n[hero]!", french="Ah! [partner] et\n[hero]!", german="Ah! [partner] und\n[hero]!", italian="[partner] e [hero]!\nSiete voi!", spanish="¡Vaya! Pero si son [partner]\ny [hero]."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" You are safe! I am so relieved!", french="Vous êtes en vie! Quel\nsoulagement!", german="Ihr seid in Sicherheit! Da bin\nich erleichtert!", italian="È un vero sollievo vedere che\nstate bene!", spanish=" ¡Qué alivio veros a salvo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_s_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_s_yonowaaru, p.X+(32), p.Y+(0), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-40), p.Y+(0), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-72), p.Y+(0), false, 2) end
  do local p=npc_npc_s_perappu.Position; GROUND:MoveToPosition(npc_npc_s_perappu, p.X+(-8), p.Y+(-32), false, 2) end
  GROUND:EntTurn(npc_npc_s_pukurin, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_s_bippa, Direction.UpLeft)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-24), p.Y+(-16), false, 2) end
  GROUND:EntTurn(npc_npc_s_perappu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Dusknoir[CR], sir, I'm glad to see\nyou're back too!", french="Content de vous revoir aussi,\nmessire [CS:N]Noctunoir[CR]!", german="[CS:N]Zwirrfinst[CR], ich bin auch\nfroh, dass du wieder da bist!", italian="Anche per noi è bello rivederla,\nsignor [CS:N]Dusknoir[CR]!", spanish="También me alegra volver a\nverte, [CS:N]Dusknoir[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Dusknoir[CR], sir, I'm glad to see\nyou're back too!", french="Content de vous revoir aussi,\nmessire [CS:N]Noctunoir[CR]!", german="[CS:N]Zwirrfinst[CR], ich bin auch\nfroh, dass du wieder da bist!", italian="Anche per noi è bello rivederla,\nsignor [CS:N]Dusknoir[CR]!", spanish="También me alegra volver a\nverte, [CS:N]Dusknoir[CR]."})
  else
  SkySceneKit.say({english="[CS:N]Dusknoir[CR], sir, I'm glad to see\nyou're back too!", french="Contente de vous revoir aussi,\nmessire [CS:N]Noctunoir[CR]!", german="[CS:N]Zwirrfinst[CR], ich bin auch\nfroh, dass du wieder da bist!", italian="Anche per noi è bello rivederla,\nsignor [CS:N]Dusknoir[CR]!", spanish="También me alegra volver a\nverte, [CS:N]Dusknoir[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Thank you for saving us!", french=" Merci d'être venu nous sauver!", german="Danke, dass du uns gerettet\nhast!", italian="Dobbiamo proprio ringraziarla!\nLei ci ha salvato!", spanish=" ¡Gracias por salvarnos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Thank you for saving us!", french=" Merci d'être venu nous sauver!", german="Danke, dass du uns gerettet\nhast!", italian="Dobbiamo proprio ringraziarla!\nLei ci ha salvato!", spanish=" ¡Gracias por salvarnos!"})
  else
  SkySceneKit.say({english=" Thank you for saving us!", french=" Merci d'être venu nous sauver!", german="Danke, dass du uns gerettet\nhast!", italian="Dobbiamo proprio ringraziarla!\nLei ci ha salvato!", spanish=" ¡Gracias por salvarnos!"})
  end
  -- message_KeyWait
  pcall(function() SOUND:FadeOutBGM(120) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So...[K] What happened?", french="Alors...[K] qu'est-ce qui s'est\npassé?", german=" Also...[K] Was ist passiert?", italian=" Ma quindi...[K] Cos'è successo?", spanish=" Entonces...[K] ¿Qué ocurrió?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So...[K] Can you tell me what\nhappened?", french="Alors...[K] qu'est-ce qui s'est\npassé?", german="Also...[K] Kannst du uns sagen, was\npassiert ist?", italian=" Può dirci cos'è successo?", spanish=" Entonces...[K] ¿Qué ocurrió?"})
  else
  SkySceneKit.say({english=" So...[K] What happened?", french="Alors...[K] qu'est-ce qui s'est\npassé?", german=" Also...[K] Was ist passiert?", italian=" Può dirci cos'è successo?", spanish=" Entonces...[K] ¿Qué ocurrió?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What happened to [CS:N]Grovyle[CR]?\nWhere did he go?", french="Qu'est-il arrivé à [CS:N]Massko[CR]?\nOù a-t-il disparu?", german="Was ist mit [CS:N]Reptain[CR] geschehen?\nWo ist er hin?", italian="Che fine ha fatto [CS:N]Grovyle[CR]? Dov'è\nsparito?", spanish="¿Qué pasó con [CS:N]Grovyle[CR]?\n¿Adónde fue?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What happened to [CS:N]Grovyle[CR]?\nWhat became of him?", french="Qu'est-il arrivé à [CS:N]Massko[CR]?\nOù a-t-il disparu?", german="Was ist mit [CS:N]Reptain[CR] geschehen?\nWo ist er hin?", italian="Cos'è successo a [CS:N]Grovyle[CR]?\nChe ne è stato di lui?", spanish="¿Qué pasó con [CS:N]Grovyle[CR]?\n¿Qué ha sido de él?"})
  else
  SkySceneKit.say({english="What happened to [CS:N]Grovyle[CR]?\nWhat became of him?", french="Qu'est-il arrivé à [CS:N]Massko[CR]?\nOù a-t-il disparu?", german="Was ist mit [CS:N]Reptain[CR] geschehen?\nWo ist er hin?", italian="Cos'è successo a [CS:N]Grovyle[CR]?\nChe ne è stato di lui?", spanish="¿Qué pasó con [CS:N]Grovyle[CR]?\n¿Qué ha sido de él?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" I gave chase to [CS:N]Grovyle[CR].", french="J'ai entrepris de donner la\nchasse à [CS:N]Massko[CR].", german=" Ich habe [CS:N]Reptain[CR] verfolgt.", italian="Ho fatto quello che era in mio\npotere per bloccare [CS:N]Grovyle[CR].", spanish=" Traté de perseguir a [CS:N]Grovyle[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" But he slipped away from me.", french="Mais il m'a glissé entre\nles doigts.", german=" Aber er ist mir entkommen.", italian=" Purtroppo, mi è sfuggito.", spanish=" Pero se me escapó."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Um...[K][CS:N]Dusknoir[CR], sir? Back at\n[CS:P]Shining Lake[CR], when you were fighting\n[CS:N]Grovyle[CR]...", french="Hum...[K] messire [CS:N]Noctunoir[CR]?\nQuand vous affrontiez [CS:N]Massko[CR] au [CS:P]Lac Cristal[CR]...", german="Ähem...[K] [CS:N]Zwirrfinst[CR]?\nAm [CS:P]Kristallsee[CR], als du mit [CS:N]Reptain[CR] gekämpft\nhast...", italian="Ehm...[K] Signor [CS:N]Dusknoir[CR]? Posso\nchiederle una cosa? Quando eravamo al [CS:P]Lago di[CR]\n[CS:P]Cristallo[CR] e lei lottava contro [CS:N]Grovyle[CR]...", spanish="Hum...[K] [CS:N]Dusknoir[CR], cuando estabas\nluchando en el [CS:P]Lago Cristal[CR] contra [CS:N]Grovyle[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Um...[K][CS:N]Dusknoir[CR], sir? Back at\n[CS:P]Shining Lake[CR], when you were fighting\n[CS:N]Grovyle[CR]...", french="Hum...[K] messire [CS:N]Noctunoir[CR]?\nQuand vous affrontiez [CS:N]Massko[CR] au [CS:P]Lac Cristal[CR]...", german="Ähem...[K] [CS:N]Zwirrfinst[CR]?\nAm [CS:P]Kristallsee[CR], als du mit [CS:N]Reptain[CR] gekämpft\nhast...", italian="Ehm...[K] Signor [CS:N]Dusknoir[CR]? Posso\nchiederle una cosa? Quando eravamo al [CS:P]Lago di[CR]\n[CS:P]Cristallo[CR] e lei lottava contro [CS:N]Grovyle[CR]...", spanish="Hum...[K] [CS:N]Dusknoir[CR], cuando estabas\nluchando en el [CS:P]Lago Cristal[CR] contra [CS:N]Grovyle[CR]..."})
  else
  SkySceneKit.say({english="Um...[K][CS:N]Dusknoir[CR], sir? Back at\n[CS:P]Shining Lake[CR], when you were fighting\n[CS:N]Grovyle[CR]...", french="Hum...[K] messire [CS:N]Noctunoir[CR]?\nQuand vous affrontiez [CS:N]Massko[CR] au [CS:P]Lac Cristal[CR]...", german="Ähem...[K] [CS:N]Zwirrfinst[CR]?\nAm [CS:P]Kristallsee[CR], als du mit [CS:N]Reptain[CR] gekämpft\nhast...", italian="Ehm...[K] Signor [CS:N]Dusknoir[CR]? Posso\nchiederle una cosa? Quando eravamo al [CS:P]Lago di[CR]\n[CS:P]Cristallo[CR] e lei lottava contro [CS:N]Grovyle[CR]...", spanish="Hum...[K] [CS:N]Dusknoir[CR], cuando estabas\nluchando en el [CS:P]Lago Cristal[CR] contra [CS:N]Grovyle[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Dusknoir[CR], sir, you and [CS:N]Grovyle[CR]\nseemed to know each other. What was...", french="Vous aviez l'air d'être de\nvieilles connaissances, [CS:N]Massko[CR] et vous.\nQu'est-ce...", german="[CS:N]Zwirrfinst[CR], du und [CS:N]Reptain[CR]\nschient einander zu kennen. Was war...", italian="... ho avuto l'impressione che lei\ne [CS:N]Grovyle[CR] vi conosceste già.", spanish="Me pareció que [CS:N]Grovyle[CR] y tú ya\nos conocíais. ¿Qué...?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Dusknoir[CR], sir, you and [CS:N]Grovyle[CR]\nseemed to know each other. What was...", french="Vous aviez l'air d'être de\nvieilles connaissances, [CS:N]Massko[CR] et vous.\nQu'est-ce...", german="[CS:N]Zwirrfinst[CR], du und [CS:N]Reptain[CR]\nschient einander zu kennen. Was war...", italian="... sembrava quasi che lei\nconoscesse già [CS:N]Grovyle[CR]. Come...", spanish="Me pareció que [CS:N]Grovyle[CR] y tú ya\nos conocíais. ¿Qué...?"})
  else
  SkySceneKit.say({english="[CS:N]Dusknoir[CR], sir, you and [CS:N]Grovyle[CR]\nseemed to know each other. What was...", french="Vous aviez l'air d'être de\nvieilles connaissances, [CS:N]Massko[CR] et vous.\nQu'est-ce...", german="[CS:N]Zwirrfinst[CR], du und [CS:N]Reptain[CR]\nschient einander zu kennen. Was war...", italian="... sembrava quasi che lei\nconoscesse già [CS:N]Grovyle[CR]. Come...", spanish="Me pareció que [CS:N]Grovyle[CR] y tú ya\nos conocíais. ¿Qué...?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_jibakoiru.Position; GROUND:MoveToPosition(npc_npc_jibakoiru, p.X+(32), p.Y+(12), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english=" ZZZT! If I may interrupt! ZZZT!", french="ZZZT! Permettez-moi de vous\ninterrompre! ZZZT!", german="ZZZT! Wenn ich unterbrechen\ndarf! ZZZT!", italian="ZZZT! Se posso interrompervi!\nZZZT!", spanish="¡Bzz! ¡Disculpad la interrupción!\n¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! The great [CS:N]Dusknoir[CR] plans\nto explain what he knows. ZZZT! And that\ntopic will be included! ZZZT!", french="ZZZT! Le grand [CS:N]Noctunoir[CR]\ncompte tout vous expliquer. ZZZT! Ce point y\ncompris! ZZZT!", german="ZZZT! Der große [CS:N]Zwirrfinst[CR]\nwird uns sagen, was er weiß. ZZZT! Und er\nwird auch über dieses Thema sprechen! ZZZT!", italian="ZZZT! Il grande [CS:N]Dusknoir[CR] è qui\nper chiarire l'accaduto. ZZZT! Tutto questo\nverrà sicuramente spiegato più avanti! ZZZT!", spanish="¡Bzz! El gran [CS:N]Dusknoir[CR] explicará\nluego lo que sabe. ¡Bzz! Y también hablará de\neso. ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! Now everyone gather\naround, please! ZZZT!", french="ZZZT! Rassemblement, tout le\nmonde, s'il vous plaît! ZZZT!", german="ZZZT! Nun versammelt euch\nbitte alle! ZZZT!", italian="ZZZT! Prego tutti di avvicinarsi\ne prestare attenzione! ZZZT!", spanish="¡Bzz! Ahora, ¡prestad todos\natención, por favor! ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:FadeOut(false,  30)
  pcall(function() GAME:MoveCamera(352, 212, 1, false) end) -- SetPositionMark performer/caméra
  GROUND:TeleportTo(hero, 424, 216, Direction.Down)
  GROUND:TeleportTo(partner, 424, 196, Direction.Down)
  GROUND:TeleportTo(npc_npc_s_yonowaaru, 352, 172, Direction.Down)
  GROUND:TeleportTo(npc_npc_jibakoiru, 320, 164, Direction.Down)
  GROUND:TeleportTo(npc_npc_s_yukushii, 424, 172, Direction.Down)
  GROUND:TeleportTo(npc_npc_s_agunomu, 408, 164, Direction.Down)
  GROUND:TeleportTo(npc_npc_s_emuritto, 384, 164, Direction.Down)
  GROUND:TeleportTo(npc_npc_s_pukurin, 352, 212, Direction.Down)
  GROUND:TeleportTo(npc_npc_s_perappu, 376, 212, Direction.Down)
  GROUND:TeleportTo(npc_npc_s_kimawari, 324, 212, Direction.Down)
  GROUND:TeleportTo(npc_npc_s_dogoomu, 400, 208, Direction.Down)
  GROUND:TeleportTo(npc_npc_s_heigani, 296, 204, Direction.Down)
  GROUND:TeleportTo(npc_npc_s_chiriin, 368, 240, Direction.Down)
  GROUND:TeleportTo(npc_npc_s_bippa, 392, 232, Direction.Down)
  GROUND:TeleportTo(npc_npc_s_diguda, 420, 232, Direction.Down)
  GROUND:TeleportTo(npc_npc_s_dagutorio, 448, 204, Direction.Down)
  GROUND:TeleportTo(npc_npc_ringuma, 256, 212, Direction.Down)
  GROUND:TeleportTo(npc_npc_himeguma, 272, 188, Direction.Down)
  GROUND:TeleportTo(npc_npc_poppo, 288, 232, Direction.Down)
  GROUND:TeleportTo(npc_npc_taneboo, 312, 236, Direction.Down)
  GROUND:TeleportTo(npc_npc_oosubame, 272, 220, Direction.Down)
  GROUND:TeleportTo(npc_npc_yarukimono, 340, 236, Direction.Down)
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.Down)
  GROUND:EntTurn(npc_npc_s_emuritto, Direction.DownRight)
  GROUND:EntTurn(npc_npc_s_agunomu, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_s_yukushii, Direction.Left)
  GROUND:EntTurn(npc_npc_s_diguda, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_s_dagutorio, Direction.Left)
  GROUND:EntTurn(npc_npc_s_bippa, Direction.Up)
  GROUND:EntTurn(npc_npc_s_dogoomu, Direction.Down)
  GROUND:EntTurn(npc_npc_s_chiriin, Direction.UpRight)
  GROUND:EntTurn(npc_npc_s_heigani, Direction.DownRight)
  GROUND:EntTurn(npc_npc_s_kimawari, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_s_perappu, Direction.Left)
  GROUND:EntTurn(npc_npc_s_pukurin, Direction.Up)
  GROUND:EntTurn(npc_npc_himeguma, Direction.Down)
  GROUND:EntTurn(npc_npc_ringuma, Direction.UpRight)
  GROUND:EntTurn(npc_npc_taneboo, Direction.Left)
  GROUND:EntTurn(npc_npc_yarukimono, Direction.Up)
  GROUND:EntTurn(npc_npc_oosubame, Direction.Up)
  GROUND:EntTurn(npc_npc_poppo, Direction.Right)
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.Down)
  GROUND:EntTurn(npc_npc_koiru, Direction.Down)
  pcall(function() GROUND:CharSetEmote(npc_npc_himeguma, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_taneboo, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dagutorio, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(45)
  -- GAP: se_Play(6669) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  -- message_FacePositionOffset(-7, 0) [neutre/état moteur]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 640, 216, Direction.Right, "NPC_BIPPA")
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Golly, I wonder what this all\ncould be about?", french="Sapristi, j'me demande bien\nc'qui s'passe!", german="Donnerwetter, worum wird es\ndenn wohl gehen?", italian=" Ohibò, chissà di che si tratta...", spanish="Vaya, me pregunto de qué va\ntodo esto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 296, 208, Direction.Right, "NPC_DOGOOMU")
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Who knows?[K] Don't ask ME!", french="Qui sait?[K] Et MOI, qu'est-ce que\nj'en sais, MOI?", german="Tja, wer weiß?[K] Frag MICH\nnicht!", italian=" Boh?[K] Ma che ne so io?", spanish="¿Quién sabe?[K]\nYo sí que no tengo ni idea."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_jibakoiru.Position; GROUND:MoveToPosition(npc_npc_jibakoiru, p.X+(0), p.Y+(16), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.DownRight)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.DownLeft)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  -- message_FacePositionOffset(-4, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english=" ZZZT! Everyone is here... ZZZT!", french="ZZZT! Tout le monde est là...\nZZZT!", german=" ZZZT! Alle sind hier... ZZZT!", italian="ZZZT! Bene! Siamo tutti\npresenti... ZZZT!", spanish="¡Bzz! Si ya estamos todos...\n¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- se_FadeOut(6669, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- call @label_0 [sous-routine locale adjacente: flux naturel]
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! So, I'd like to get this\nmeeting started! ZZZT!", french="ZZZT! Que la réunion commence!\nZZZT!", german="ZZZT! Daher würde ich nun\ngerne mit der Besprechung beginnen! ZZZT!", italian="ZZZT! Diamo inizio alla riunione!\nZZZT!", spanish="¡Bzz! Podemos iniciar la reunión.\n¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! Our topic! The rash of\nTime Gear thefts! ZZZT!", french="ZZZT! Ordre du jour!\nLa série de vols de Rouages du Temps!\nZZZT!", german="ZZZT! Das Thema ist die Welle\nvon Diebstählen der Zahnräder der Zeit! ZZZT!", italian="ZZZT! Oggi parleremo dei\nrecenti furti degli Ingranaggi del Tempo! ZZZT!", spanish="¡Bzz! El tema es la serie de\nrobos de Engranajes del Tiempo. ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! Several Time Gears have\nbeen stolen! By the Pokémon [CS:N]Grovyle[CR]! ZZZT!", french="ZZZT! Plusieurs Rouages\ndu Temps ont été dérobés par un dénommé\n[CS:N]Massko[CR]! ZZZT!", german="ZZZT! Es wurden schon mehrere\nZahnräder der Zeit gestohlen! Von einem\nPokémon namens [CS:N]Reptain[CR]! ZZZT!", italian="ZZZT! Il Pokémon [CS:N]Grovyle[CR] è\nl'autore di questi furti! ZZZT!", spanish="¡Bzz! El Pokémon [CS:N]Grovyle[CR] ha\nrobado varios Engranajes del Tiempo. ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! In the regions where a\nTime Gear has been stolen, the flow of time\nhas come to a standstill! ZZZT!", french="ZZZT! Le cours du temps\ns'est arrêté dans les régions privées\nde leur Rouage du Temps! ZZZT!", german="ZZZT! In den Regionen, deren\nZahnrad der Zeit gestohlen wurde, steht\nseitdem die Zeit still! ZZZT!", italian="ZZZT! Nelle zone dove è stato\nrubato un Ingranaggio del Tempo, lo scorrere\ndel tempo si è arrestato! ZZZT!", spanish="¡Bzz! En las regiones donde\nel Engranaje del Tiempo ha desaparecido\nse ha detenido el tiempo. ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! This is a serious problem,\nas I am sure you can guess! ZZZT!", french="ZZZT! La situation est grave,\ncomme vous pouvez l'imaginer! ZZZT!", german="ZZZT! Dies ist ein ernstes\nProblem, wie ihr euch sicher vorstellen könnt!\nZZZT!", italian="ZZZT! Come potete immaginare,\nsi tratta di un fatto gravissimo! ZZZT!", spanish="¡Bzz! Este es un problema muy\nserio, como os podéis imaginar. ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english=" ZZZT! [CS:N]Grovyle[CR] failed... ZZZT!", french=" ZZZT! [CS:N]Massko[CR] a échoué... ZZZT!", german="ZZZT! [CS:N]Reptain[CR] hat diesmal\nversagt... ZZZT!", italian="ZZZT! [CS:N]Grovyle[CR], recentemente...\nZZZT!", spanish="¡Bzz! Sin embargo, [CS:N]Grovyle[CR]\nfracasó en su último intento. ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! Failed to steal a Time\nGear! This one was protected! ZZZT!", french="ZZZT! Il a échoué dans sa\ndernière tentative de vol d'un autre Rouage\ndu Temps! Celui-ci a pu être sauvé! ZZZT!", german="ZZZT! Er konnte ein Zahnrad der\nZeit nicht stehlen! Es wurde erfolgreich\nbeschützt! ZZZT!", italian="ZZZT! È stato bloccato mentre\ncercava di rubare un Ingranaggio del Tempo!\nZZZT!", spanish="¡Bzz! No consiguió robar uno de\nlos engranajes porque estaba bien protegido.\n¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5138) — id SE NDS sans portage PMDO identifié
  -- call @label_1 [sous-routine locale adjacente: flux naturel]
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Wow!", french=" Waouh!", german=" Wow!", italian=" Wow!", spanish=" ¡Vaya!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" Isn't that something!", french=" Ça, c'est pas rien, quoi!", german=" Das ist doch schon mal was!", italian=" Grande!", spanish=" ¡Hay que ver!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- se_FadeOut(5138, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- call @label_2 [sous-routine locale adjacente: flux naturel]
  -- message_FacePositionOffset(-4, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! And the hero who\nprotected it was the mighty [CS:N]Azelf[CR]! ZZZT!", french="ZZZT! Et le héros qui l'a\nprotégé n'est autre que le puissant [CS:N]Créfadet[CR]!\nZZZT!", german="ZZZT! Und das heldenhafte\nPokémon, das es beschützt hat, ist das\nmächtige [CS:N]Tobutz[CR]! ZZZT!", italian="ZZZT! Il potente [CS:N]Azelf[CR] è riuscito\nnell'intento di sventare i suoi piani! ZZZT!", spanish="¡Bzz! El héroe que lo protegió\nfue el poderoso [CS:N]Azelf[CR]. ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! And the hero who saved\n[CS:N]Azelf[CR] and chased off [CS:N]Grovyle[CR]... ZZZT!", french="ZZZT! Quant au héros qui a\nsauvé [CS:N]Créfadet[CR] et a mis [CS:N]Massko[CR] en fuite...\nZZZT!", german="ZZZT! Und der Held, der [CS:N]Tobutz[CR]\ngerettet und [CS:N]Reptain[CR] vertrieben hat... ZZZT!", italian="ZZZT! E un altro potente\nPokémon è intervenuto per proteggere [CS:N]Azelf[CR] e\ncercare di bloccare [CS:N]Grovyle[CR]... ZZZT!", spanish="¡Bzz! Y el héroe que salvó a\n[CS:N]Azelf[CR] y puso en fuga a [CS:N]Grovyle[CR]... ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-4, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! That would be the great\n[CS:N]Dusknoir[CR] right here! ZZZT!", french="ZZZT! C'est bien entendu\nl'illustre [CS:N]Noctunoir[CR] ici présent! ZZZT!", german="ZZZT! Das war der große\n[CS:N]Zwirrfinst[CR] hier vor euch! ZZZT!", italian="ZZZT! Sto parlando del grande\n[CS:N]Dusknoir[CR], qui presente! ZZZT!", spanish="¡Bzz! No es otro que el gran\n[CS:N]Dusknoir[CR], aquí presente. ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5138) — id SE NDS sans portage PMDO identifié
  -- call @label_1 [sous-routine locale adjacente: flux naturel]
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" That's astounding!", french=" C'est stupéfiant!", german=" Das ist wirklich bemerkenswert!", italian=" Incredibile!", spanish=" ¡Es asombroso!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="No wonder he's such a famous\nexplorer!", french="Pas étonnant qu'il soit si\ncélèbre!", german="Kein Wunder, dass er so ein\nberühmter Erkunder ist!", italian="È davvero un\ngrande esploratore!", spanish="¡No me extraña que sea\nun explorador tan famoso!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- se_FadeOut(5138, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- call @label_2 [sous-routine locale adjacente: flux naturel]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Officer [CS:N]Magnezone[CR]...", french=" Shérif [CS:N]Magnézone[CR]...", german=" Oberwachtmeister [CS:N]Magnezone[CR]...", italian=" Commissario [CS:N]Magnezone[CR]...", spanish=" Agente [CS:N]Magnezone[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I'm sorry to interrupt.[K] Perhaps\nI should explain from here...", french="Excusez-moi de vous\ninterrompre.[K] Peut-être devrais-je expliquer\nla situation...", german="Leider muss ich unterbrechen.[K]\nVielleicht sollte ich weiter erklären...", italian="Sono spiacente d'interromperla,[K]\nma forse è bene che continui io il racconto,\nda qui...", spanish="Siento interrumpir.[K] Quizás deba\ncontinuar yo mismo con la explicación..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-4, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! Of course! Please take it\nfrom here! ZZZT!", french="ZZZT! Bien entendu! Prenez\nle relais! ZZZT!", german="ZZZT! Natürlich! Bitte erzähle\nselbst weiter! ZZZT!", italian="ZZZT! Ma certamente! La prego\ndi proseguire! ZZZT!", spanish="¡Bzz! ¡Por supuesto, adelante!\n¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_jibakoiru.Position; GROUND:MoveToPosition(npc_npc_jibakoiru, p.X+(0), p.Y+(-20), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Everyone![K] While we should\nbe happy that we protected the Time Gear\nthis time...", french="Oyez, oyez![K] Nous pouvons certes\nnous réjouir que le Rouage du Temps ait été\nsauvegardé cette fois-ci...", german="Pokémon![K] Es ist zwar ein Grund\nzur Freude, dass wir dieses Zahnrad der Zeit\nbeschützt haben...", italian="Signore e signori![K] Se è vero\nche possiamo rallegrarci di aver sventato\nil furto di questo Ingranaggio del Tempo...", spanish="Escuchadme.[K] Aunque podéis\nalegraros de que haya logrado proteger el\nEngranaje del Tiempo esta vez..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="The fact is...[CS:N]Grovyle[CR] remains\nat large.", french="Mais le fait est... que [CS:N]Massko[CR]\ncourt toujours.", german="Aber Tatsache ist, dass [CS:N]Reptain[CR]\nweiter auf freiem Fuß ist.", italian="... resta il fatto che [CS:N]Grovyle[CR] è\nancora in libertà.", spanish="La verdad es que [CS:N]Grovyle[CR] aún\nanda suelto."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Therefore, we cannot afford to\nfeel safe and secure.", french="Aussi, ne nous imaginons pas\nen sécurité.", german="Deshalb dürfen wir uns nicht in\nSicherheit wiegen.", italian="Pertanto, non possiamo ancora\npermetterci di sentirci al sicuro.", spanish="Por tanto, no podemos\nasumir que estamos a salvo."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CS:N]Grovyle[CR] will most certainly\nmake another attempt to steal the Time Gear.", french="[CS:N]Massko[CR] tentera à nouveau\nde s'emparer de ce Rouage du Temps.\nJe n'ai guère de doute sur ce point.", german="[CS:N]Reptain[CR] wird\nhöchstwahrscheinlich erneut versuchen, das\nZahnrad der Zeit zu stehlen.", italian="Sono certo che [CS:N]Grovyle[CR] proverà\nnuovamente ad impossessarsi di\nquell'Ingranaggio del Tempo.", spanish="No hay duda de que [CS:N]Grovyle[CR]\nvolverá a intentar robar el Engranaje del\nTiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6669) — id SE NDS sans portage PMDO identifié
  -- call @label_3 [sous-routine locale adjacente: flux naturel]
  GAME:WaitFrames(90)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="There is another matter that is\ntied to all of this.", french="Et un autre problème lié à tout\ncela demeure.", german="Und es gibt noch eine andere\nAngelegenheit, die mit all dem zu tun hat.", italian="E c'è una ragione\nper tutto questo.", spanish="Además, hay otra cuestión\nrelacionada con todo esto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- se_FadeOut(6669, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- call @label_4 [sous-routine locale adjacente: flux naturel]
  -- call @label_0 [sous-routine locale adjacente: flux naturel]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="It is an extremely important\nmatter that I must share with you.", french="Un problème de la plus haute\nimportance dont je me dois de vous informer.", german="Es ist sehr von Bedeutung, dass\nihr über diese äußerst wichtige Angelegenheit\nBescheid wisst.", italian="Si tratta di un argomento della\nmassima importanza e vorrei che ne veniste\ntutti a conoscenza.", spanish="Es una cuestión extremadamente\nimportante que debo compartir con vosotros."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I would like to explain it to\nyou now.", french=" Je m'en vais vous l'expliquer.", german="Ich würde sie euch nun gerne\nerklären.", italian=" Lasciate che vi spieghi.", spanish=" Quisiera explicarla ahora."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" First...", french=" Premièrement...", german=" Zunächst einmal...", italian=" Come prima cosa...", spanish=" Para empezar..."})
  -- se_FadeOut(6669, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Earlier, [partner] asked me\nthe following question.", french="Tout à l'heure, [partner]\nm'a posé la question suivante.", german="[partner] hat mir vorhin\ndie folgende Frage gestellt.", italian="Torniamo alla domanda che\n[partner] mi ha posto in precedenza...", spanish="Hace un rato, [partner] me\npreguntó si..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Did I know [CS:N]Grovyle[CR] from before\nall this happened?", french="Est-ce que je connaissais [CS:N]Massko[CR]\navant toute cette histoire?", german="Und zwar, ob ich [CS:N]Reptain[CR] schon\ngekannt hätte, bevor all das geschah.", italian="Voleva sapere se è vero che\nconoscevo [CS:N]Grovyle[CR] da prima che questi fatti\navessero inizio.", spanish="Ya conocía a [CS:N]Grovyle[CR] antes de\nque ocurriese todo esto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="That is correct. I do know\n[CS:N]Grovyle[CR] from before all this.", french="La réponse est oui.\nJe le connaissais avant toute cette histoire.", german="Und ja, das stimmt. Ich kannte\n[CS:N]Reptain[CR] schon vor all dem.", italian="La risposta è sì. Io conosco\n[CS:N]Grovyle[CR] da molto prima.", spanish="Tengo que admitir que así es.\nYa conocía a [CS:N]Grovyle[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  -- call @label_5 [sous-routine locale adjacente: flux naturel]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: WHAT?!", french="[CS:N]Tous[CR]: QUOI?!", german="[CS:N]Alle[CR]: WAS?!?", italian="[CS:N]Tutti[CR]: COOOSA?!", spanish="[CS:N]Todos[CR]: ¿CÓMO?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="What I am about to say...[K]\nmay be beyond your belief!", french="Ce que je m'apprête à vous\nrévéler...[K] vous ne voudrez peut-être pas\nle croire!", german="Was ich euch gleich erzählen\nwerde,[K] wird euch womöglich völlig unglaublich\nerscheinen!", italian="Quello che sto per dirvi...[K]\npotrebbe risultare difficile da credere...", spanish="Lo que voy a contaros...[K] puede\nresultar ciertamente inverosímil."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="But it also happens to be\nthe truth.", french="Mais il se trouve que c'est\nla pure vérité.", german=" Doch es ist die Wahrheit.", italian="Tuttavia, il caso vuole che si\ntratti della pura verità.", spanish="Pero no es nada más que\nla verdad."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Furthermore, if what I'm about\nto reveal isn't stopped, calamity is certain!", french="En outre, si nous ne faisons rien\npour empêcher ce dont je vais vous parler,\nnous courons tout droit à notre perte!", german="Was ich euch nun erzähle,\nhandelt von einer Gefahr, die gestoppt werden\nmuss! Ansonsten droht eine Katastrophe!", italian="Inoltre! Se ciò che sto per\nraccontarvi non dovesse essere sventato,\nla catastrofe sarà inevitabile!", spanish="Es más, si no hacemos algo\npara impedir lo que voy a revelaros,\n¡la catástrofe será inevitable!"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I, therefore, ask for your\nundivided attention.", french="C'est pourquoi je vous demande\ntoute votre attention.", german="Ich bitte euch deshalb um eure\nungeteilte Aufmerksamkeit.", italian="Vi prego, pertanto, di prestare\nla massima attenzione.", spanish="Por tanto, os pido toda vuestra\natención."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" First, [CS:N]Grovyle[CR] is...", french=" Pour commencer, [CS:N]Massko[CR] est...", german="Als Erstes muss ich sagen, dass\n[CS:N]Reptain[CR]...", italian=" Dunque, [CS:N]Grovyle[CR] è...", spanish="Antes de nada, debéis saber que\n[CS:N]Grovyle[CR] es un..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CS:N]Grovyle[CR] is a Pokémon that came\nhere from the future.", french="[CS:N]Massko[CR] est un Pokémon venu\ndu futur.", german="[CS:N]Reptain[CR] ist ein Pokémon, das\naus der Zukunft hierhergekommen ist.", italian="[CS:N]Grovyle[CR] è un Pokémon che viene\ndal futuro.", spanish="[CS:N]Grovyle[CR] es un Pokémon que\nha venido del futuro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- call @label_5 [sous-routine locale adjacente: flux naturel]
  GAME:WaitFrames(30)
  -- call @label_3 [sous-routine locale adjacente: flux naturel]
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.DownRight)
  GROUND:EntTurn(npc_npc_koiru, Direction.Right)
  -- message_FacePositionOffset(1, 4) [neutre/état moteur]
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 376, 248, Direction.Up, "NPC_KIMAWARI")
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" F-future?", french=" Du futur?", german=" Z-zukunft?", italian=" F-Futuro?", spanish=" ¿El... el futuro?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-4, 0) [neutre/état moteur]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 384, 176, Direction.DownLeft, "NPC_DIGUDA")
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Dad?[K] What does he mean by\n\"from the future\"?", french="Père?[K] Qu'est-ce que ça veut\ndire, \"du futur\"?", german=" Papi?[K] Was meint er denn damit?", italian="Papà?[K] Cosa intende con\n\"dal futuro\"?", spanish="¿Papá?[K] ¿Qué ha querido\ndecir con que viene del futuro?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dugtrio", true, "dugtrio", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_DAGUTORIO (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I think he means...from a place\nwhere things are yet to happen...", french="Il nous semble que ça signifie...\nun endroit où les choses ne se sont pas\nencore produites...", german="Ich glaube, er spricht... er\nspricht von einem Ort, an dem die Dinge noch\nnicht geschehen sind...", italian="Forse vuol dire... da un posto\ndove le cose devono ancora accadere...", spanish="Creo que quiere decir que viene\nde un lugar donde hay cosas que aún no han\nsucedido."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="But is something like that\npossible?!", french="Mais comment c'est possible,\nun truc pareil?!", german=" Aber ist so etwas möglich?!?", italian="Eeeh?! Ma stiamo parlando di\ncose realmente possibili?", spanish=" ¡¿Pero es posible algo así?!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="A Pokémon...coming from the\nFUTURE?", french=" Un Pokémon... venu du FUTUR?", german="Ein Pokémon... Ein Pokémon, das\naus der ZUKUNFT kommt?", italian="Un Pokémon... che viene dal\nfuturo?", spanish="Un Pokémon... ¿que viene del\nfuturo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CS:N]Grovyle[CR]...[K] In the world of the\nfuture, he will be a notorious criminal.", french="Dans le monde du futur...[K]\n[CS:N]Massko[CR] est un criminel notoire.", german="[CS:N]Reptain[CR][K] wird in der zukünftigen\nWelt ein berüchtigter Verbrecher sein.", italian="[CS:N]Grovyle[CR]...[K] nel futuro è un\nfamigerato fuorilegge.", spanish="[CS:N]Grovyle[CR]...[K] es un conocido\ndelincuente en el mundo del futuro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- call @label_4 [sous-routine locale adjacente: flux naturel]
  -- call @label_0 [sous-routine locale adjacente: flux naturel]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="He has a large bounty on\nhis head.", french="Sa tête est mise à prix\npour une prime faramineuse.", german="Auf ihn ist ein hohes Kopfgeld\nausgesetzt.", italian="C'è una grossa taglia sulla sua\ntesta.", spanish="Se ofrece una gran recompensa\npor él."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="To avoid capture in the future,\nhe fled.", french="Il s'est enfui du futur pour\néviter qu'on ne le capture.", german="Um in der Zukunft nicht\ngefangen zu werden, ist er geflohen.", italian="Per sfuggire alla cattura, è\nscappato...", spanish="Huyó para evitar que le\ncapturasen."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="And in fleeing, he escaped to\nthis, the world of the past.", french="Et il s'est réfugié ici,\ndans le passé.", german="Seine Flucht hat ihn in diese\nWelt geführt, in die Welt der Vergangenheit.", italian="... e si è nascosto qui, nel\npassato.", spanish="Cuando ya no tenía adónde huir,\nvino aquí, al mundo del pasado."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="After arriving in this time,\n[CS:N]Grovyle[CR] plotted...", french="Une fois arrivé dans ce monde,\n[CS:N]Massko[CR] s'est mis à conspirer...", german="In dieser Zeit angekommen,\nschmiedete [CS:N]Reptain[CR] einen Plan.", italian="Una volta arrivato qui, [CS:N]Grovyle[CR]\nha escogitato un piano...", spanish="Tras llegar a esta época,\n[CS:N]Grovyle[CR] estuvo conspirando..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="until he hit upon an utterly\ncatastrophic plan.", french="... jusqu'à ce qu'un projet\nd'une indicible infamie germe dans son esprit\nretors et perfide.", german="Einen wahrhaft katastrophalen\nPlan.", italian="... che potrebbe significare la\ncatastrofe per tutti.", spanish="Y, al final, ideó un plan\nterrible de consecuencias catastróficas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 352, 176, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Wh-what is that?! What was\nhis plan?!", french="Et... et de quoi s'agit-il?!\nQuel est donc ce projet?!", german=" W-was?!? Was für einen Plan?", italian=" C-Cosa?! E qual è questo piano?", spanish=" ¿Qué? ¡¿Qué plan?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="It was nothing less than...[K]\ncausing the planet's paralysis.", french="Rien moins que...[K]\nprovoquer la Paralysie de la Planète.", german="Keinen geringeren Plan[K]\nals die Lähmung des Planeten!", italian="Il suo scopo consiste...[K]\nnientemeno che nella totale paralisi del mondo.", spanish="Pues nada más y nada menos...[K]\nque causar la parálisis del planeta."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_perappu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" The planet's...[K]paralysis?", french=" La Paralysie...[K] de la Planète?", german=" Die...[K] Lähmung des Planeten?", italian=" La paralisi...[K] del mondo?", spanish="¿Cómo?[K] ¿La parálisis del\nplaneta?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Yes.", french=" C'est cela même.", german=" Ja.", italian=" Esattamente.", spanish=" Así es."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="If a planet becomes paralyzed,\nall movement upon it ceases.", french="Quand une planète est paralysée,\nelle est totalement privée de mouvement.", german="Wenn ein Planet gelähmt wird,\nhört jede Bewegung auf ihm auf.", italian="Se un pianeta subisce la paralisi,\nogni movimento cessa istantaneamente.", spanish="Si un planeta queda paralizado,\ncesa todo movimiento sobre su superficie."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="When a Time Gear is removed,\nthe flow of time slows in its region.", french="Dans une région privée\nde Rouage du Temps, le cours du temps\nest ralenti.", german="Wenn ein Zahnrad der Zeit\nentfernt wird, verlangsamt sich der Fluss der\nZeit in der jeweiligen Region.", italian="Quando viene rimosso un\nIngranaggio del Tempo, lo scorrere del tempo\nin quella zona subisce un rallentamento.", spanish="Al retirar un Engranaje del\nTiempo, el flujo temporal se para en\nesa zona."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="As many more are taken, time\nslows in an ever-larger area.", french="Et plus le nombre de Rouages\ndu Temps subtilisés croît, plus le phénomène\nprend une ampleur dramatique.", german="Je mehr Zahnräder der Zeit\ngestohlen werden, desto größer das Gebiet,\nin dem die Zeit langsamer fließt.", italian="Se ne vengono rimossi altri, il\ntempo rallenta in una zona ancora più ampia.", spanish="Cuantos más engranajes se\nquitan mayor es el área donde se detiene\nel tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Eventually, the planet's flow\nslows down so much that it stops entirely.", french="De telle sorte que le cours\ndu temps finit par s'arrêter complètement.", german="Schließlich wird der Fluss der\nZeit so langsam, dass sie ganz zum Stillstand\nkommt.", italian="In seguito, il tempo sull'intero\npianeta può rallentare fino all'arresto totale.", spanish="Al final, se alcanza un punto en\nel que el tiempo se detiene en todo el planeta."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Ultimately, the planet reaches a\nstate of total paralysis...", french="En dernier ressort, la planète\nest atteinte d'une paralysie totale...", german="Am Ende verfällt der Planet in\neinen Zustand vollkommener Lähmung.", italian="E infine, il pianeta rimane\ncompletamente paralizzato...", spanish="En la última fase del proceso,\nel planeta alcanza la parálisis total."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="If the planet is paralyzed...[K]\nWhat happens to this world?", french="Et si la planète est paralysée...[K]\nque deviendra notre monde?", german="Wenn der Planet gelähmt ist...[K]\nWas geschieht dann mit der Welt?", italian="Se il pianeta subisce la\nparalisi...[K] cosa succede al nostro\nmondo?", spanish="Si el planeta se paraliza...[K]\n¿Qué es lo que pasaría?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="In a world where the planet has\nbecome paralyzed...", french="Dans un monde où la planète\nest paralysée...", german="In einer Welt, in der die\nLähmung des Planeten eingetreten ist...", italian="In un mondo dove è avvenuta la\nparalisi totale...", spanish="Si el planeta quedase totalmente\nparalizado..."})
  -- message_Close
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() GROUND:CharSetEmote(npc_npc_himeguma, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_oosubame, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_taneboo, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_s_yukushii, Direction.Left)
  GROUND:EntTurn(npc_npc_s_agunomu, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_s_emuritto, Direction.DownLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_s_pukurin, Direction.Up)
  GROUND:EntTurn(npc_npc_s_perappu, Direction.Up)
  GROUND:EntTurn(npc_npc_s_kimawari, Direction.Up)
  GROUND:EntTurn(npc_npc_s_dogoomu, Direction.UpLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_s_heigani, Direction.UpRight)
  GROUND:EntTurn(npc_npc_s_chiriin, Direction.Up)
  GROUND:EntTurn(npc_npc_s_bippa, Direction.UpLeft)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_s_diguda, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_s_dagutorio, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_ringuma, Direction.UpRight)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_himeguma, Direction.Right)
  GROUND:EntTurn(npc_npc_poppo, Direction.UpRight)
  GROUND:EntTurn(npc_npc_taneboo, Direction.Up)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_oosubame, Direction.UpRight)
  GROUND:EntTurn(npc_npc_yarukimono, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- return [fin de routine SSB]
  GAME:WaitFrames(1) -- hold
  -- @label_1 [étiquette de flux ExplorerScript]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yarukimono, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_poppo, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_heigani, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_diguda, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_perappu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_bippa, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dagutorio, "happy", 1) end)
  -- return [fin de routine SSB]
  GAME:WaitFrames(1) -- hold
  -- @label_2 [étiquette de flux ExplorerScript]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_yarukimono, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_poppo, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_heigani, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_perappu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_bippa, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dagutorio, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(15)
  -- return [fin de routine SSB]
  GAME:WaitFrames(1) -- hold
  -- @label_3 [étiquette de flux ExplorerScript]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.DownRight)
  GROUND:EntTurn(npc_npc_s_emuritto, Direction.DownRight)
  GROUND:EntTurn(npc_npc_s_perappu, Direction.Left)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_s_agunomu, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_s_yukushii, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_s_diguda, Direction.UpRight)
  GROUND:EntTurn(npc_npc_s_dagutorio, Direction.DownLeft)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_s_bippa, Direction.Left)
  GROUND:EntTurn(npc_npc_s_dogoomu, Direction.Right)
  GROUND:EntTurn(npc_npc_s_chiriin, Direction.Right)
  GROUND:EntTurn(npc_npc_s_heigani, Direction.DownRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_s_kimawari, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_himeguma, Direction.Down)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_ringuma, Direction.UpRight)
  GROUND:EntTurn(npc_npc_taneboo, Direction.Left)
  GROUND:EntTurn(npc_npc_yarukimono, Direction.Up)
  GROUND:EntTurn(npc_npc_oosubame, Direction.Up)
  GROUND:EntTurn(npc_npc_poppo, Direction.Right)
  -- return [fin de routine SSB]
  GAME:WaitFrames(1) -- hold
  -- @label_4 [étiquette de flux ExplorerScript]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- return [fin de routine SSB]
  GAME:WaitFrames(1) -- hold
  -- @label_5 [étiquette de flux ExplorerScript]
  pcall(function() GROUND:CharSetEmote(npc_npc_himeguma, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yarukimono, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_poppo, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_emuritto, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_yukushii, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_agunomu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_diguda, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_perappu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_jibakoiru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dogoomu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dagutorio, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- return [fin de routine SSB]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
