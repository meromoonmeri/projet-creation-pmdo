-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D26P43A/m23a0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D26P43A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 280, 192, Direction.Up, "NPC_PERAPPU")
  -- SetAnimation(34) [anim idle native]
  GAME:FadeIn(30)
  local npc_npc_kabutopusu = SkySceneKit.spawn_npc("kabutops", 280, 272, Direction.Down, "NPC_KABUTOPUSU")
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_kabutopusu.Position; GROUND:MoveToPosition(npc_npc_kabutopusu, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2)
  local npc_npc_omusutaa = SkySceneKit.spawn_npc("omastar", 248, 264, Direction.DownRight, "NPC_OMUSUTAA")
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_omusutaa.Position; GROUND:MoveToPosition(npc_npc_omusutaa, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2)
  local npc_npc_omusutaa2 = SkySceneKit.spawn_npc("omastar", 304, 264, Direction.DownLeft, "NPC_OMUSUTAA2")
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_omusutaa2.Position; GROUND:MoveToPosition(npc_npc_omusutaa2, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_omusutaa, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_omusutaa) end)
  SkySceneKit.say({english=" Eep...", french=" Brrr...", german=" Mieps...", italian=" Eeh...", spanish=" Epa..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_omusutaa2, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_omusutaa2) end)
  SkySceneKit.say({english=" Erf...", french=" Arf...", german=" Uff...", italian=" Aah...", spanish=" Uf..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kabutopusu, "sweating", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kabutopusu) end)
  SkySceneKit.say({english=" Aiyeeeh!", french=" Fuyons!", german=" Aiyeeeh!", italian=" Ahiaaaaaaa!", spanish=" ¡Aaayyy!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7430) — id SE NDS sans portage PMDO identifié
  do local p=npc_npc_kabutopusu.Position; GROUND:MoveToPosition(npc_npc_kabutopusu, p.X+(40), p.Y+(-40), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_omusutaa.Position; GROUND:MoveToPosition(npc_npc_omusutaa, p.X+(-160), p.Y+(-18), false, 2) end
  do local p=npc_npc_omusutaa2.Position; GROUND:MoveToPosition(npc_npc_omusutaa2, p.X+(160), p.Y+(18), false, 2) end
  do local p=npc_npc_kabutopusu.Position; GROUND:MoveToPosition(npc_npc_kabutopusu, p.X+(0), p.Y+(-60), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(15)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GAME:MoveCamera(276, 212, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 256, 188, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(hero, 296, 188, false, 2)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Chatot[CR]!", french=" [CS:N]Pijako[CR]!", german=" [CS:N]Plaudagei[CR]!", italian=" [CS:N]Chatot[CR]!", spanish=" ¡[CS:N]Chatot[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Chatot[CR]!", french=" [CS:N]Pijako[CR]!", german=" [CS:N]Plaudagei[CR]!", italian=" [CS:N]Chatot[CR]!", spanish=" ¡[CS:N]Chatot[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]Chatot[CR]!", french=" [CS:N]Pijako[CR]!", german=" [CS:N]Plaudagei[CR]!", italian=" [CS:N]Chatot[CR]!", spanish=" ¡[CS:N]Chatot[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(32) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Urf...", french=" Argh...", german=" Umpf...", italian=" Uff...", spanish=" Uf..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Chatot[CR]! Are you all right?![K]\nStay with us!", french="[CS:N]Pijako[CR]! Tu vas bien?![K]\nReste avec nous!", german="[CS:N]Plaudagei[CR]! Bist du okay?!?[K]\nHalte durch!", italian="[CS:N]Chatot[CR]! Stai bene?![K] Resta con\nnoi!", spanish="¡[CS:N]Chatot[CR]! ¡¿Estás bien?![K]\n¡Aguanta!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Chatot[CR]! Are you all right?![K]\nStay with us!", french="[CS:N]Pijako[CR]! Tu vas bien?![K]\nReste avec nous!", german="[CS:N]Plaudagei[CR]! Bist du okay?!?[K]\nHalte durch!", italian="[CS:N]Chatot[CR]! Stai bene?![K] Resta con\nnoi!", spanish="¡[CS:N]Chatot[CR]! ¡¿Estás bien?![K]\n¡Aguanta!"})
  else
  SkySceneKit.say({english="[CS:N]Chatot[CR]! Are you all right?![K]\nStay with us!", french="[CS:N]Pijako[CR]! Tu vas bien?![K]\nReste avec nous!", german="[CS:N]Plaudagei[CR]! Bist du okay?!?[K]\nHalte durch!", italian="[CS:N]Chatot[CR]! Stai bene?![K] Resta con\nnoi!", spanish="¡[CS:N]Chatot[CR]! ¡¿Estás bien?![K]\n¡Aguanta!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" [CS:N]Chatot[CR]!", french=" [CS:N]Pijako[CR]!", german=" [CS:N]Plaudagei[CR]!", italian=" [CS:N]Chatot[CR]!", spanish=" ¡[CS:N]Chatot[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  pcall(function() GAME:MoveCamera(276, 252, 60, false) end) -- performer/caméra
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 264, 344, Direction.Up, "NPC_PUKURIN")
  GROUND:MoveToPosition(npc_npc_pukurin, 260, 268, false, 2)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 296, 360, Direction.Up, "NPC_JUPUTORU")
  GROUND:MoveToPosition(npc_npc_juputoru, 292, 268, false, 2)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" That voice... Guildmaster...", french=" Cette voix... Maître!", german=" Diese Stimme... Gildenmeister...", italian=" Quella voce... il Capitano...", spanish=" Esa voz... Gran Bluff..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_pukurin, 260, 220, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_juputoru, 292, 220, false, 2)
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(-8), false, 2) end
  GROUND:EntTurn(npc_npc_pukurin, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Wigglytuff[CR]![K] And [CS:N]Grovyle[CR] too!", french="[CS:N]Grodoudou[CR]![K] Et [CS:N]Massko[CR] est là\naussi!", german=" [CS:N]Knuddeluff[CR]![K] Und auch [CS:N]Reptain[CR]!", italian=" [CS:N]Wigglytuff[CR]![K] E anche [CS:N]Grovyle[CR]!", spanish=" ¡[CS:N]Wigglytuff[CR]![K] ¡Y [CS:N]Grovyle[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Wigglytuff[CR]![K] And [CS:N]Grovyle[CR] too!", french="[CS:N]Grodoudou[CR]![K] Et [CS:N]Massko[CR] est là\naussi!", german=" [CS:N]Knuddeluff[CR]![K] Und auch [CS:N]Reptain[CR]!", italian=" [CS:N]Wigglytuff[CR]![K] E anche [CS:N]Grovyle[CR]!", spanish=" ¡[CS:N]Wigglytuff[CR]![K] ¡Y [CS:N]Grovyle[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]Wigglytuff[CR]![K] And [CS:N]Grovyle[CR] too!", french="[CS:N]Grodoudou[CR]![K] Et [CS:N]Massko[CR] est là\naussi!", german=" [CS:N]Knuddeluff[CR]![K] Und auch [CS:N]Reptain[CR]!", italian=" [CS:N]Wigglytuff[CR]![K] E anche [CS:N]Grovyle[CR]!", spanish=" ¡[CS:N]Wigglytuff[CR]![K] ¡Y [CS:N]Grovyle[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 296, 352, Direction.Up, "NPC_DOGOOMU")
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end) -- message_SetActor(ACTOR_NPC_DOGOOMU)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Guildmaster!", french=" Maître!", german=" Gildenmeister!", italian=" Capitano!", spanish=" ¡Gran Bluff!"})
  -- message_Close
  -- GAP: se_Play(6916) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(1)
  pcall(function() GAME:MoveCamera(276, 252, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_dogoomu, 292, 244, false, 2)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 328, 400, Direction.Up, "NPC_HEIGANI")
  GROUND:MoveToPosition(npc_npc_heigani, 324, 252, false, 2)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 232, 368, Direction.Up, "NPC_KIMAWARI")
  GROUND:MoveToPosition(npc_npc_kimawari, 232, 228, false, 2)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 224, 392, Direction.Up, "NPC_CHIRIIN")
  GROUND:MoveToPosition(npc_npc_chiriin, 224, 256, false, 2)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 320, 368, Direction.Up, "NPC_BIPPA")
  GROUND:MoveToPosition(npc_npc_bippa, 320, 228, false, 2)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 256, 384, Direction.Up, "NPC_GUREGGURU")
  GROUND:MoveToPosition(npc_npc_guregguru, 260, 260, false, 2)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 280, 392, Direction.Up, "NPC_DAGUTORIO")
  GROUND:MoveToPosition(npc_npc_dagutorio, 296, 260, false, 2)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 256, 360, Direction.Up, "NPC_DIGUDA")
  GROUND:MoveToPosition(npc_npc_diguda, 256, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_juputoru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(4), 3, false) end) -- MovePositionOffset performer/caméra
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_diguda.Position; GROUND:MoveToPosition(npc_npc_diguda, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_guregguru.Position; GROUND:MoveToPosition(npc_npc_guregguru, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  do local p=npc_npc_dagutorio.Position; GROUND:MoveToPosition(npc_npc_dagutorio, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_chiriin.Position; GROUND:MoveToPosition(npc_npc_chiriin, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_heigani.Position; GROUND:MoveToPosition(npc_npc_heigani, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" WAAH! [CS:N]Grovyle[CR]!", french=" OUAAAH! [CS:N]Massko[CR]!", german=" UAAAH! [CS:N]Reptain[CR]!", italian=" AAAH! [CS:N]Grovyle[CR]!", spanish=" ¡Aaah! ¡[CS:N]Grovyle[CR]!"})
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_bippa, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpRight)
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpRight)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpLeft)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="What is [CS:N]Grovyle[CR] doing with the\nGuildmaster?!", french="Qu'est-ce que [CS:N]Massko[CR] fabrique\navec le Maître de la Guilde?!", german="Was macht [CS:N]Reptain[CR] bei dem\nGildenmeister?!?", italian="Cosa ci fa [CS:N]Grovyle[CR] con il\nCapitano?!", spanish="¡¿Qué hace [CS:N]Grovyle[CR] con\nel Gran Bluff?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I'll explain later! This is more\nimportant!", french="Je vous expliquerai plus tard.\nIl y a d'autres priorités pour l'instant!", german="Das erkläre ich später! Das hier\nist wichtiger!", italian="Ve lo spiego più tardi! C'è\nqualcosa di più importante!", spanish="¡Luego lo explicaré!\n¡Esto es más importante!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(16), p.Y+(-8), false, 2) end
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" [CS:N]Chatot[CR]!", french=" [CS:N]Pijako[CR]!", german=" [CS:N]Plaudagei[CR]!", italian=" [CS:N]Chatot[CR]!", spanish=" ¡[CS:N]Chatot[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! This is bad! [CS:N]Chatot[CR]\nis down!", french="Eh dis donc, ça va mal! [CS:N]Pijako[CR]\nest K.O.!", german="Hey, hey! Das ist übel! [CS:N]Plaudagei[CR]\nist zu Boden gegangen!", italian="Ehi, ehi! No! [CS:N]Chatot[CR] è al\ntappeto!", spanish="¡Oye, oye! ¡Esto tiene mala\npinta! ¡[CS:N]Chatot[CR] está herido!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Golly! He's hurt!", french=" Sapristi, il est blessé!", german=" Donnerwetter! Er ist verletzt!", italian=" Ohibò! È ferito!", spanish=" ¡Huyuyuy! ¡Tiene mala cara!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(276, 212, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_dogoomu, 296, 212, false, 2)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 208, false, 2)
  GROUND:MoveToPosition(npc_npc_kimawari, 232, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 224, 208, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 320, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 244, 224, false, 2)
  GROUND:MoveToPosition(npc_npc_dagutorio, 304, 224, false, 2)
  GROUND:MoveToPosition(npc_npc_diguda, 256, 208, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_juputoru, 320, 164, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.Left)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Right)
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpRight)
  GROUND:EntTurn(npc_npc_guregguru, Direction.UpRight)
  GROUND:EntTurn(npc_npc_diguda, Direction.UpRight)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Chatot[CR]![K] Are you OK?[K]\nAre you hurt?", french="[CS:N]Pijako[CR]![K] Tu vas bien?[K]\nTu es blessé?", german="[CS:N]Plaudagei[CR]![K] Bist du okay?[K]\nBist du verletzt?", italian="[CS:N]Chatot[CR]![K] Stai bene?[K]\nSei ferito?", spanish="¡[CS:N]Chatot[CR]![K] ¿Estás bien?[K]\n¿Estás herido?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Ha ha ha... I'm fine...", french=" Ha ha ha... Je vais bien...", german=" Ha ha ha... Mir geht es gut...", italian=" Ah ah ah... Sto bene...", spanish=" Ja, ja, ja... Estoy bien..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I'm hale and hearty...[K] As you\ncan see...", french="Je suis en pleine forme...[K]\ncomme vous pouvez le constater...", german="Ich bin gesund und munter...[K] wie\nihr seht...", italian="Sto bene...[K] come potete\nvedere...", spanish="Estoy sano y salvo...[K]\nTal y como podéis ver..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" [CS:N]Chatot[CR]!", french=" [CS:N]Pijako[CR]!", german=" [CS:N]Plaudagei[CR]!", italian=" [CS:N]Chatot[CR]!", spanish=" ¡[CS:N]Chatot[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I'm sorry, [CS:N]Chatot[CR].[K] If I only got\nhere earlier...", french="Je suis désolé, [CS:N]Pijako[CR].[K]\nSi seulement j'étais arrivé plus tôt...", german="Es tut mir leid, [CS:N]Plaudagei[CR].[K] Wäre\nich doch nur früher gekommen...", italian="Mi spiace, [CS:N]Chatot[CR].[K] Se solo fossi\narrivato prima...", spanish="Lo siento, [CS:N]Chatot[CR].[K]\nSi hubiera podido venir antes..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Please don't blame yourself...[K]\nGuildmaster...", french="Ne vous en voulez pas...[K]\nMaître...", german="Bitte mach dir keine\nVorwürfe...[K] Gildenmeister...", italian="Per favore non si biasimi...[K]\nCapitano...", spanish="No ha sido culpa tuya...[K]\nGran Bluff..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" But...[K]this is so humiliating!", french=" Mais...[K] c'est si humiliant!", german=" Aber...[K] Das ist so erniedrigend!", italian=" Ma...[K] è così umiliante!", spanish=" Pero...[K] ¡esto es tan humillante!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="To be knocked out by the same\nenemies...again!", french="Etre mis K.O. par les mêmes\nennemis... pour la seconde fois!", german="Von denselben Gegnern besiegt\nzu werden... Schon wieder!", italian="Venire sconfitto dallo stesso\nnemico... di nuovo!", spanish="Caer así ante los mismos\nenemigos... ¡otra vez!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" That isn't true, [CS:N]Chatot[CR]!", french=" C'est faux, [CS:N]Pijako[CR]!", german=" Das ist nicht wahr, [CS:N]Plaudagei[CR]!", italian=" Non è vero, [CS:N]Chatot[CR]!", spanish=" ¡Eso no es cierto, [CS:N]Chatot[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" The last time we came here...", french="La dernière fois qu'on est\nvenus ici...", german="Als wir das letzte Mal\nhierherkamen...", italian="L'ultima volta che siamo venuti\nqui...", spanish="La última vez que estuvimos\naquí..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You were knocked out right\naway, [CS:N]Chatot[CR], so you probably don't remember\nthis. But...[K]that time...", french="... tu es tombé K.O. tout de\nsuite, [CS:N]Pijako[CR], alors tu ne t'en souviens\nprobablement pas, mais...[K] à l'époque...", german="Da wurdest du sofort K.O.\ngeschlagen, [CS:N]Plaudagei[CR]. Deswegen wirst du dich\nkaum erinnern können. Aber[K] damals...", italian="Sei stato steso immediatamente,\n[CS:N]Chatot[CR], quindi probabilmente non te lo ricordi.\nMa...[K] quella volta...", spanish="Quedaste fuera de combate\ninmediatamente, así que probablemente\nno lo recuerdas. Pero...[K] aquella vez..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="When [CS:N]Kabutops[CR]'s gang sprang out\nat us...[K]you shielded me from attack, [CS:N]Chatot[CR].", french="... quand la bande de [CS:N]Kabutops[CR]\nnous est tombée dessus...[K] tu t'es sacrifié pour\nme protéger, [CS:N]Pijako[CR].", german="Als die Bande von [CS:N]Kabutops[CR] sich\nauf uns stürzen wollte,[K] hast du mich vor der\nAttacke beschützt, [CS:N]Plaudagei[CR].", italian="Quando la banda di [CS:N]Kabutops[CR] ci\nha aggredito...[K] mi hai fatto da scudo\ncontro un attacco, [CS:N]Chatot[CR].", spanish="Cuando la banda de [CS:N]Kabutops[CR]\nsaltó sobre nosotros...[K] tú me protegiste\ndel ataque, [CS:N]Chatot[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Excuse me...?", french=" Pardon...?", german=" Wie bitte?", italian=" Come...?", spanish=" ¿Cómo dices?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I sent [CS:N]Kabutops[CR]'s gang packing\nright after that, but...", french="Je les ai fait déguerpir juste\naprès, mais...", german="Gleich danach habe ich mir die\nBande von [CS:N]Kabutops[CR] vorgeknöpft...", italian="Subito dopo ho fatto scappare\n[CS:N]Kabutops[CR] e i suoi amici, ma...", spanish="Después les di su merecido,\npero..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="If it weren't for you jumping out\nto shield me, [CS:N]Chatot[CR], I would have been\nknocked out on the spot.", french="... sans toi, [CS:N]Pijako[CR], ils m'auraient\nenvoyé au tapis immédiatement.", german="Wenn du nicht gewesen wärst,\num die Attacke abzufangen, [CS:N]Plaudagei[CR]...\nIch wäre auf der Stelle zu Boden gegangen.", italian="Se non ti fossi messo fra me e\ni nemici, [CS:N]Chatot[CR], sarei stato sconfitto.", spanish="Si no te hubieras interpuesto\npara protegerme, yo habría quedado fuera\nde combate en aquel preciso momento."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" I owe my life to [CS:N]Chatot[CR].", french="Je te dois une fière chandelle,\n[CS:N]Pijako[CR].", german="Ohne [CS:N]Plaudagei[CR] hätte es für\nmich übel ausgesehen.", italian=" Ti sono riconoscente, [CS:N]Chatot[CR].", spanish="[CS:N]Chatot[CR] me libró de una buena.\nNo sé cómo hubiera acabado si no llega a\nestar allí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" That's...[K]what happened?", french="C'est vraiment...[K] comme ça\nque ça s'est passé?", german=" Das ist[K] wirklich geschehen?", italian=" È...[K] andata così?", spanish=" ¿Eso?[K] ¿Eso fue lo que sucedió?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" [CS:N]Chatot[CR], you are...", french=" [CS:N]Pijako[CR], tu es...", german=" [CS:N]Plaudagei[CR], du bist...", italian=" [CS:N]Chatot[CR], tu sei...", spanish=" [CS:N]Chatot[CR], eres..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" my invaluable partner.", french=" ... mon inestimable partenaire.", german="Du bist mein unverzichtbarer\nPartner.", italian="... il mio preziosissimo\ncompagno.", spanish="Eres importantísimo para mí.\nMi leal compañero."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I...[K]I am privileged to hear such\nwords, Guildmaster.", french="C'est...[K] c'est un honneur pour\nmoi, Maître.", german="Es...[K] Es ist eine Ehre für mich,\ndiese Worte zu hören, Gildenmeister.", italian="Io...[K] io sono onorato di\nsentire queste parole, Capitano.", spanish="Yo...[K] Para mí... es un gran honor\noírte decir eso, Gran Bluff."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" I'm...[K]such a happy Pokémon...", french=" Je suis...[K] transporté de joie...", german="Das macht mich...[K] zu einem sehr\nglücklichen Pokémon...", italian="Io sono...[K] davvero un Pokémon\nfelice...", spanish=" Me...[K] Me has emocionado..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  -- SetAnimation(31) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  -- GAP: se_Play(7185) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" ...Pfft.", french=" ... Pfff!", german=" ...Pfft.", italian=" ... Aaaah.", spanish=" Snif..."})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" WHOA, [CS:N]Chatot[CR]!", french=" OUAH, [CS:N]Pijako[CR]!", german=" HUAH, [CS:N]Plaudagei[CR]!", italian=" EHI, [CS:N]Chatot[CR]!", spanish=" ¡Vaya, [CS:N]Chatot[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" [CS:N]Chatot[CR]!", french=" [CS:N]Pijako[CR]!", german=" [CS:N]Plaudagei[CR]!", italian=" [CS:N]Chatot[CR]!", spanish=" ¡[CS:N]Chatot[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Everyone, stay calm!", french=" Du calme, tout le monde!", german=" Leute, bleibt ruhig!", italian=" Gente, mantenete la calma!", spanish=" ¡Guardad la calma!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_juputoru, 276, 168, false, 2)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" ...Yes. He'll live.", french=" ... C'est bon. Il est vivant.", german=" Ja, er wird durchkommen.", italian=" Sì. Ce la farà.", spanish=" Sobrevivirá. Tranquilos."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="He still has time! Get him back\nto the guild now!", french="Il a encore du temps devant lui!\nRamenez-le à la Guilde tout de suite!", german="Ihm bleibt noch Zeit! Schafft\nihn jetzt zur Gilde!", italian="C'è ancora tempo! Portatelo\nsubito alla Gilda!", spanish="¡Aún tiene tiempo!\n¡Llevadle al [CS:N]Pokégremio[CR] ahora mismo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Well then! Quick, let's all go\nback to the guild!", french="Allez, on se dépêche!\nTous à la Guilde!", german="Nun denn! Schnell, gehen wir alle\nzur Gilde zurück!", italian="Bene allora! Presto, torniamo\ntutti alla Gilda!", spanish="¡Entendido!\n¡Rápido, volvamos todos al [CS:N]Pokégremio[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well then! Quick, let's all go\nback to the guild!", french="Allez, on se dépêche!\nTous à la Guilde!", german="Nun denn! Schnell, gehen wir alle\nzur Gilde zurück!", italian="Bene allora! Presto, torniamo\ntutti alla Gilda!", spanish="¡Entendido!\n¡Rápido, volvamos todos al [CS:N]Pokégremio[CR]!"})
  else
  SkySceneKit.say({english="Well, we have to be quick!\nLet's all go back to the guild!", french="Allez, on se dépêche!\nTous à la Guilde!", german="Nun denn! Schnell, gehen wir alle\nzur Gilde zurück!", italian="Bene allora! Presto, torniamo\ntutti alla Gilda!", spanish="¡Entendido!\n¡Rápido, volvamos todos al [CS:N]Pokégremio[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="No.[K] We will take [CS:N]Chatot[CR] back to\nthe guild.", french="Non.[K] On va s'occuper de ramener\n[CS:N]Pijako[CR] à la Guilde.", german="Nein.[K] Wir werden [CS:N]Plaudagei[CR]\nzurück zur Gilde bringen.", italian="No.[K] Porteremo noi [CS:N]Chatot[CR] alla\nGilda.", spanish="No.[K] Nosotros llevaremos a\n[CS:N]Chatot[CR] al [CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="But, as for you, [hero]\nand [partner]...", french="Quant à vous, [hero]\net [partner]...", german="Aber ihr, [hero]\nund [partner]...", italian="Ma voi, [hero]\ne [partner]...", spanish=" [hero] y [partner]..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="And you, [CS:N]Grovyle[CR]... You three\nmust keep going.", french="Et toi aussi, [CS:N]Massko[CR]...\nVous devez continuer.", german="Und du, [CS:N]Reptain[CR]... Ihr drei müsst\nweitermachen.", italian="... e tu, [CS:N]Grovyle[CR]... Voi tre dovete\nproseguire.", spanish="Y [CS:N]Grovyle[CR]...\nTenéis que seguir adelante."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But...!", french=" Mais...!", german=" Aber!", italian=" Ma...!", spanish=" ¡Pero...!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But...!", french=" Mais...!", german=" Aber!", italian=" Ma...!", spanish=" ¡Pero...!"})
  else
  SkySceneKit.say({english=" But...!", french=" Mais...!", german=" Aber!", italian=" Ma...!", spanish=" ¡Pero...!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Don't worry about it.", french=" Ne vous en faites pas.", german=" Macht euch keine Sorgen.", italian=" Non dovete preoccuparvi.", spanish=" No os preocupéis más."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Besides, if you don't go on from\nhere...", french="En plus, si vous rentrez\nmaintenant...", german="Und außerdem, wenn ihr jetzt\nnicht weitergeht...", italian=" Inoltre, se non proseguite...", spanish=" Además, si no seguís adelante..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Chatot[CR]'s shielding you will have\nbeen for nothing.", french="... le sacrifice de [CS:N]Pijako[CR] n'aura\nservi à rien.", german="Dann hätte [CS:N]Plaudagei[CR] sich für\nnichts und wieder nichts vor euch geworfen.", italian="Ciò che ha fatto [CS:N]Chatot[CR]\nnon sarà servito a nulla.", spanish="El sacrificio de [CS:N]Chatot[CR] habrá\nsido en vano."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urf...", french=" Argh...", german=" Uff...", italian=" Uff...", spanish=" Hum..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urf...", french=" Argh...", german=" Urf...", italian=" Uff...", spanish=" Hum..."})
  else
  SkySceneKit.say({english=" Urf...", french=" Argh...", german=" Urf...", italian=" Uff...", spanish=" Hum..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" The strange pattern is up ahead.", french="L'étrange symbole vous attend\nun peu plus loin.", german="Das seltsame Muster liegt vor\nuns.", italian="Quello strano disegno è più\navanti.", spanish="El dibujo está un poco más\nadelante."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Now, hurry.", french=" Allez, faites vite.", german=" Beeilung.", italian=" Sbrigatevi, ora.", spanish=" Ahora, daos prisa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Thanks, [CS:N]Wigglytuff[CR].[K] We will\ncontinue onward.", french="Merci, [CS:N]Grodoudou[CR].[K]\nOn va continuer.", german="Danke, [CS:N]Knuddeluff[CR].[K] Wir werden\nweiter vorangehen!", italian="Grazie, [CS:N]Wigglytuff[CR].[K]\nProseguiremo.", spanish="Gracias, [CS:N]Wigglytuff[CR].[K]\nContinuaremos con la misión."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(0), p.Y+(-24), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpRight)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Let's go, [partner],\n[hero].", french="Allons-y, [partner],\n[hero].", german="Lasst uns gehen, [partner]\nund [hero].", italian="Andiamo, [partner],\n[hero].", spanish="[partner], [hero]...\nVámonos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...Yup.", french=" ... D'accord.", german=" ...Jep.", italian=" Sì.", spanish=" De acuerdo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...OK.", french=" ... D'accord.", german=" ...Okay.", italian=" Ok.", spanish=" De acuerdo."})
  else
  SkySceneKit.say({english=" ...OK.", french=" ... D'accord.", german=" ...Okay.", italian=" Ok.", spanish=" De acuerdo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go, [hero].", french=" C'est parti, [hero].", german=" Gehen wir, [hero].", italian=" Andiamo, [hero].", spanish=" Vámonos, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go, [hero].", french=" C'est parti, [hero].", german=" Gehen wir, [hero].", italian=" Andiamo, [hero].", spanish=" Vámonos, [hero]."})
  else
  SkySceneKit.say({english=" Let's go, [hero].", french=" C'est parti, [hero].", german=" Gehen wir, [hero].", italian=" Andiamo, [hero].", spanish=" Vámonos, [hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_juputoru, 276, 84, false, 2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-40), false, 2) end
  GAME:WaitFrames(5)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-36), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  GROUND:MoveToPosition(partner, 276, 84, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(hero, 276, 84, false, 2)
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Good luck![K] Find the [CS:P]Hidden Land[CR]!", french="Bonne chance![K] Trouvez\nles [CS:P]Terres Illusoires[CR]!", german="Viel Glück![K] Findet das\n[CS:P]Verborgene Land[CR]!", italian="Buona fortuna![K] Trovate la\n[CS:P]Terra Nascosta[CR]!", spanish="¡Buena suerte![K]\n¡Encontrad la [CS:P]Tierra Oculta[CR]!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(160) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)
  SkySceneKit.cleanup_npcs()
end
