-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/m16a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_T01P01A) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  GAME:FadeIn(30)
  local npc_npc_s_dogoomu = SkySceneKit.spawn_npc("loudred", 512, 192, Direction.UpRight, "NPC_S_DOGOOMU")
  do local p=npc_npc_s_dogoomu.Position; GROUND:MoveToPosition(npc_npc_s_dogoomu, p.X+(-88), p.Y+(0), false, 2) end
  local npc_npc_s_perappu = SkySceneKit.spawn_npc("chatot", 576, 208, Direction.DownLeft, "NPC_S_PERAPPU")
  do local p=npc_npc_s_perappu.Position; GROUND:MoveToPosition(npc_npc_s_perappu, p.X+(-88), p.Y+(0), false, 2) end
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 592, 208, Direction.Left, "NPC_GUREGGURU")
  do local p=npc_npc_guregguru.Position; GROUND:MoveToPosition(npc_npc_guregguru, p.X+(-88), p.Y+(0), false, 2) end
  local npc_npc_s_pukurin = SkySceneKit.spawn_npc("wigglytuff", 552, 240, Direction.Down, "NPC_S_PUKURIN")
  do local p=npc_npc_s_pukurin.Position; GROUND:MoveToPosition(npc_npc_s_pukurin, p.X+(-88), p.Y+(0), false, 2) end
  local npc_npc_s_kimawari = SkySceneKit.spawn_npc("sunflora", 504, 232, Direction.UpLeft, "NPC_S_KIMAWARI")
  do local p=npc_npc_s_kimawari.Position; GROUND:MoveToPosition(npc_npc_s_kimawari, p.X+(-88), p.Y+(0), false, 2) end
  local npc_npc_s_bippa = SkySceneKit.spawn_npc("bidoof", 568, 184, Direction.Up, "NPC_S_BIPPA")
  do local p=npc_npc_s_bippa.Position; GROUND:MoveToPosition(npc_npc_s_bippa, p.X+(-88), p.Y+(0), false, 2) end
  local npc_npc_s_chiriin = SkySceneKit.spawn_npc("chimecho", 536, 192, Direction.Up, "NPC_S_CHIRIIN")
  do local p=npc_npc_s_chiriin.Position; GROUND:MoveToPosition(npc_npc_s_chiriin, p.X+(-88), p.Y+(0), false, 2) end
  local npc_npc_s_heigani = SkySceneKit.spawn_npc("corphish", 528, 240, Direction.UpRight, "NPC_S_HEIGANI")
  do local p=npc_npc_s_heigani.Position; GROUND:MoveToPosition(npc_npc_s_heigani, p.X+(-88), p.Y+(0), false, 2) end
  local npc_npc_s_diguda = SkySceneKit.spawn_npc("diglett", 616, 216, Direction.UpLeft, "NPC_S_DIGUDA")
  do local p=npc_npc_s_diguda.Position; GROUND:MoveToPosition(npc_npc_s_diguda, p.X+(-88), p.Y+(0), false, 2) end
  local npc_npc_s_dagutorio = SkySceneKit.spawn_npc("dugtrio", 600, 240, Direction.DownRight, "NPC_S_DAGUTORIO")
  do local p=npc_npc_s_dagutorio.Position; GROUND:MoveToPosition(npc_npc_s_dagutorio, p.X+(-88), p.Y+(0), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-88), p.Y+(0), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-88), p.Y+(0), false, 2) end
  GAME:WaitFrames(30)
  local npc_npc_himeguma = SkySceneKit.spawn_npc("teddiursa", 384, 224, Direction.Up, "NPC_HIMEGUMA")
  GROUND:EntTurn(npc_npc_himeguma, Direction.Right)
  GAME:WaitFrames(4)
  local npc_npc_ringuma = SkySceneKit.spawn_npc("ursaring", 352, 224, Direction.Up, "NPC_RINGUMA")
  GROUND:EntTurn(npc_npc_ringuma, Direction.Right)
  local npc_npc_kakureon1 = SkySceneKit.spawn_npc("kecleon", 368, 248, Direction.Up, "NPC_KAKUREON1")
  GROUND:EntTurn(npc_npc_kakureon1, Direction.UpRight)
  local npc_npc_s_emuritto = SkySceneKit.spawn_npc("mesprit", 296, 232, Direction.UpRight, "NPC_S_EMURITTO")
  GROUND:EntTurn(npc_npc_s_emuritto, Direction.Right)
  local npc_npc_s_yukushii = SkySceneKit.spawn_npc("uxie", 312, 248, Direction.Up, "NPC_S_YUKUSHII")
  GROUND:EntTurn(npc_npc_s_yukushii, Direction.Right)
  GAME:WaitFrames(4)
  local npc_npc_s_agunomu = SkySceneKit.spawn_npc("azelf", 336, 248, Direction.Up, "NPC_S_AGUNOMU")
  GROUND:EntTurn(npc_npc_s_agunomu, Direction.Right)
  GAME:WaitFrames(4)
  local npc_npc_jibakoiru = SkySceneKit.spawn_npc("magnezone", 304, 184, Direction.Down, "NPC_JIBAKOIRU")
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 336, 248, Direction.Up, "NPC_CHIRIIN")
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Everyone's already here!", french=" Tout le monde est déjà là!", german=" Es sind schon alle da!", italian=" Ci siamo davvero tutti!", spanish=" ¡Ya están aquí todos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 328, 224, Direction.UpRight, "NPC_HEIGANI")
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! I don't see the great\n[CS:N]Dusknoir[CR] around yet.", french="Eh dis donc, on dirait que\nle grand [CS:N]Noctunoir[CR] n'est pas encore arrivé.", german="Hey, hey! Ich sehe den großen\n[CS:N]Zwirrfinst[CR] noch nicht.", italian="Ehi, ehi! Manca il grande\n[CS:N]Dusknoir[CR].", spanish="¡Oye, oye! Todavía no se ve\npor aquí al gran [CS:N]Dusknoir[CR]."})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_s_dogoomu, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dogoomu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 296, 208, Direction.Right, "NPC_DOGOOMU")
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" What's THAT?!", french=" Qu'est-ce que c'est que ÇA?!", german=" Was ist DAS?!?", italian=" E quello cos'è?!", spanish=" ¡¿QUÉ ES ESO?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-16), 32, false) end) -- MovePositionOffset performer/caméra
  GROUND:MoveToPosition(npc_npc_s_dogoomu, 352, 184, false, 2)
  do local p=npc_npc_s_kimawari.Position; GROUND:MoveToPosition(npc_npc_s_kimawari, p.X+(-40), p.Y+(-16), false, 2) end -- Move2PositionOffset
  GROUND:MoveToPosition(npc_npc_s_chiriin, 408, 176, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(partner, 348, 208, false, 2)
  GROUND:MoveToPosition(npc_npc_s_heigani, 376, 236, false, 2)
  GROUND:MoveToPosition(hero, 372, 212, false, 2)
  GROUND:MoveToPosition(npc_npc_s_pukurin, 404, 232, false, 2)
  GROUND:MoveToPosition(npc_npc_s_bippa, 376, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_s_perappu, 396, 204, false, 2)
  GROUND:MoveToPosition(npc_npc_s_diguda, 444, 204, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 420, 200, false, 2)
  GROUND:MoveToPosition(npc_npc_s_dagutorio, 432, 228, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_himeguma, 336, 224, false, 2)
  GROUND:MoveToPosition(npc_npc_ringuma, 312, 212, false, 2)
  GROUND:MoveToPosition(npc_npc_kakureon1, 352, 244, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_s_emuritto, 280, 220, false, 2)
  GROUND:MoveToPosition(npc_npc_s_yukushii, 296, 236, false, 2)
  GROUND:MoveToPosition(npc_npc_s_agunomu, 320, 244, false, 2)
  GROUND:MoveToPosition(npc_npc_s_kimawari, 328, 188, false, 2)
  GROUND:EntTurn(npc_npc_kakureon1, Direction.Up)
  GROUND:EntTurn(npc_npc_s_emuritto, Direction.UpRight)
  GROUND:EntTurn(npc_npc_s_yukushii, Direction.UpRight)
  GROUND:EntTurn(npc_npc_s_agunomu, Direction.UpRight)
  GROUND:EntTurn(npc_npc_himeguma, Direction.Up)
  GROUND:EntTurn(npc_npc_ringuma, Direction.UpRight)
  GROUND:EntTurn(npc_npc_s_dogoomu, Direction.Up)
  GROUND:EntTurn(npc_npc_s_kimawari, Direction.Up)
  GROUND:EntTurn(npc_npc_s_chiriin, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_s_heigani, Direction.Up)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_s_pukurin, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_s_bippa, Direction.Up)
  GROUND:EntTurn(npc_npc_s_perappu, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_s_diguda, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_guregguru, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_s_dagutorio, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! That is a dimensional\nhole! ZZZT!", french="ZZZT! C'est un gouffre\ndimensionnel! ZZZT!", german="ZZZT! Das ist das dimensionale\nLoch! ZZZT!", italian="ZZZT! Quello è un tunnel\ndimensionale! ZZZT!", spanish="¡Bzz! ¡Eso es un agujero\ndimensional! ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_kimawari, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 376, 248, Direction.Up, "NPC_KIMAWARI")
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Dimensional hole?[K] Oh, what\n[CS:N]Magnemite[CR] was trying to explain earlier...", french="Un gouffre dimensionnel?[K] Ah oui,\nce dont [CS:N]Magnéti[CR] parlait tout à l'heure...", german="Dimensionales Loch?[K] Ach so, das\nhat [CS:N]Magnetilo[CR] zuvor erwähnt.", italian="Tunnel dimensionale?[K] Ah, già!\n[CS:N]Magnemite[CR] ne stava parlando prima...", spanish="¿Un agujero dimensional?[K]\nAh, claro. Era lo que [CS:N]Magnemite[CR] intentaba\nexplicarnos antes..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 640, 216, Direction.Right, "NPC_BIPPA")
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Golly! This is it? Isn't that\nsomething!", french="Sapristi, c'est ça? Ma foi, c'est\nquequ'chose, hein!", german="Donnerwetter! Das ist es?\nDa sieh mal einer an!", italian=" Ohibò! È questo? È incredibile!", spanish="¡Huy! ¿Es eso de ahí?\n¡Hay que ver!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="So stepping inside this here\nthing will take you to the future?", french="Alors si on met un pied dans\nc'machin, ça vous transporte direct dans\nl'futur?", german="Wenn man da reingeht, bringt\nes einen also in die Zukunft?", italian="Entrando qui dentro si finisce nel\nfuturo...?", spanish="¿Y meterte ahí te lleva al\nfuturo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_s_bippa.Position; GROUND:MoveToPosition(npc_npc_s_bippa, p.X+(-4), p.Y+(-12), false, 2) end
  do local p=npc_npc_jibakoiru.Position; GROUND:MoveToPosition(npc_npc_jibakoiru, p.X+(48), p.Y+(-12), false, 2) end
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.DownRight)
  GROUND:EntTurn(npc_npc_s_bippa, Direction.UpLeft)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_kimawari, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dogoomu, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_s_kimawari.Position; GROUND:MoveToPosition(npc_npc_s_kimawari, p.X+(0), p.Y+(4), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_s_dogoomu.Position; GROUND:MoveToPosition(npc_npc_s_dogoomu, p.X+(0), p.Y+(4), false, 2) end -- SlidePositionOffset
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english=" ZZZT! Watch out! ZZZT!", french=" ZZZT! Attention! ZZZT!", german=" ZZZT! Vorsicht! ZZZT!", italian=" ZZZT! Attenzione! ZZZT!", spanish=" ¡Bzz! ¡Mucho cuidado! ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english=" ZZZT! Stay clear! ZZZT!", french=" ZZZT! Reculez! ZZZT!", german="ZZZT! Geht nicht zu nah ran!\nZZZT!", italian=" ZZZT! Non avvicinatevi! ZZZT!", spanish=" ¡Bzz! ¡Apartaos! ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! The instant you touch it,\nyou will be sent to the future! ZZZT!", french="ZZZT! A l'instant où vous le\ntouchez, vous êtes aspirés vers le futur!\nZZZT!", german="ZZZT! Wenn ihr es berührt,\nwerdet ihr sofort in die Zukunft befördert!\nZZZT!", italian="ZZZT! È sufficiente sfiorarlo\nper essere spediti all'istante nel futuro! ZZZT!", spanish="¡Bzz! ¡Con solo tocarlo podrías\nterminar en el futuro! ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! Please be extremely\ncareful! ZZZT!", french="ZZZT! Soyez extrêmement\nprudents! ZZZT!", german="ZZZT! Seid bitte äußerst\nvorsichtig! ZZZT!", italian="ZZZT! Vi prego di fare\nattenzione! ZZZT!", spanish="¡Bzz! ¡Tened muchísimo cuidado!\n¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_bippa, "sweating", 1) end)
  do local p=npc_npc_s_bippa.Position; GROUND:MoveToPosition(npc_npc_s_bippa, p.X+(4), p.Y+(12), false, 1) end
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Oof!", french=" Pfiou!", german=" Uff!", italian=" Puff!", spanish=" ¡Uf!"})
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_s_bippa, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey![K] [CS:N]Uxie[CR]![K] [CS:N]Mesprit[CR]![K]\nAnd [CS:N]Azelf[CR] too!", french="Eh! C'est [CS:N]Créhelf[CR] et [CS:N]Créfollet[CR]![K]\nEt [CS:N]Créfadet[CR] est là aussi!", german="Hey![K] [CS:N]Selfe[CR]![K] [CS:N]Vesprit[CR]![K] Und [CS:N]Tobutz[CR]\nist auch da!", italian="Ehi! Guardate![K] [CS:N]Uxie[CR]![K]\n[CS:N]Mesprit[CR]![K] C'è anche [CS:N]Azelf[CR]!", spanish="¡Mira![K] ¡[CS:N]Uxie[CR]![K] ¡[CS:N]Mesprit[CR]![K]\n¡Y también [CS:N]Azelf[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hey![K] [CS:N]Uxie[CR]![K] [CS:N]Mesprit[CR]![K]\nAnd [CS:N]Azelf[CR] too!", french="Eh! C'est [CS:N]Créhelf[CR] et [CS:N]Créfollet[CR]![K]\nEt [CS:N]Créfadet[CR] est là aussi!", german="Hey![K] [CS:N]Selfe[CR]![K] [CS:N]Vesprit[CR]![K] Und [CS:N]Tobutz[CR]\nist auch da!", italian="Ehi! Guardate![K] [CS:N]Uxie[CR]![K]\n[CS:N]Mesprit[CR]![K] C'è anche [CS:N]Azelf[CR]!", spanish="¡Mira![K] ¡[CS:N]Uxie[CR]![K] ¡[CS:N]Mesprit[CR]![K]\n¡Y también [CS:N]Azelf[CR]!"})
  else
  SkySceneKit.say({english="Oh![K] [CS:N]Uxie[CR]![K] [CS:N]Mesprit[CR]![K]\nAnd [CS:N]Azelf[CR] too!", french="Eh! C'est [CS:N]Créhelf[CR] et [CS:N]Créfollet[CR]![K]\nEt [CS:N]Créfadet[CR] est là aussi!", german="Oh![K] [CS:N]Selfe[CR]![K] [CS:N]Vesprit[CR]![K] Und [CS:N]Tobutz[CR]\nist auch da!", italian="Ehi! Guardate![K] [CS:N]Uxie[CR]![K]\n[CS:N]Mesprit[CR]![K] C'è anche [CS:N]Azelf[CR]!", spanish="¡Mira![K] ¡[CS:N]Uxie[CR]![K] ¡[CS:N]Mesprit[CR]![K]\n¡Y también [CS:N]Azelf[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(32), 32, false) end) -- MovePositionOffset performer/caméra
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_ringuma, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_himeguma, Direction.DownLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_s_kimawari, Direction.Down)
  GROUND:EntTurn(npc_npc_s_dogoomu, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_kakureon1, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_s_heigani, Direction.Left)
  GROUND:EntTurn(npc_npc_s_bippa, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_s_perappu, Direction.DownLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_s_pukurin, Direction.Left)
  GROUND:EntTurn(npc_npc_s_chiriin, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownLeft)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_s_dagutorio, Direction.Left)
  GROUND:EntTurn(npc_npc_s_diguda, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker("Uxie", true, "uxie", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YUKUSHII (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" [partner]!", french=" [partner]!", german=" [partner]!", italian=" [partner]!", spanish=" ¡[partner]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_himeguma.Position; GROUND:MoveToPosition(npc_npc_himeguma, p.X+(0), p.Y+(28), false, 2) end
  do local p=npc_npc_kakureon1.Position; GROUND:MoveToPosition(npc_npc_kakureon1, p.X+(8), p.Y+(0), false, 2) end
  GAME:WaitFrames(10)
  do local p=npc_npc_s_emuritto.Position; GROUND:MoveToPosition(npc_npc_s_emuritto, p.X+(16), p.Y+(-4), false, 2) end
  do local p=npc_npc_s_yukushii.Position; GROUND:MoveToPosition(npc_npc_s_yukushii, p.X+(16), p.Y+(0), false, 2) end
  do local p=npc_npc_s_agunomu.Position; GROUND:MoveToPosition(npc_npc_s_agunomu, p.X+(16), p.Y+(-8), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-24), p.Y+(0), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-24), p.Y+(0), false, 2) end
  do local p=npc_npc_ringuma.Position; GROUND:MoveToPosition(npc_npc_ringuma, p.X+(-40), p.Y+(20), false, 2) end
  GROUND:EntTurn(npc_npc_kakureon1, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_s_emuritto, Direction.Right)
  GROUND:EntTurn(npc_npc_s_yukushii, Direction.UpRight)
  GROUND:EntTurn(npc_npc_s_agunomu, Direction.Up)
  GROUND:EntTurn(npc_npc_himeguma, Direction.Up)
  GROUND:EntTurn(partner, Direction.Down)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_ringuma, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You're all safe! Am I glad to\nsee that!", french="Vous êtes sains et saufs tous\nles trois! Je suis si content!", german="Ihr seid alle in Sicherheit!\nBin ich froh!", italian=" State tutti bene! Evviva!", spanish="¡Estáis a salvo!\n¡Me alegra saberlo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You're all safe! Am I glad to\nsee that!", french="Vous êtes sains et saufs tous\nles trois! Je suis si content!", german="Ihr seid alle in Sicherheit!\nBin ich froh!", italian=" State tutti bene! Evviva!", spanish="¡Estáis a salvo!\n¡Me alegra saberlo!"})
  else
  SkySceneKit.say({english="You're all safe! Am I glad to\nsee that!", french="Vous êtes sains et saufs tous\nles trois! Je suis si contente!", german="Ihr seid alle in Sicherheit!\nBin ich froh!", italian=" State tutti bene! Evviva!", spanish="¡Estáis a salvo!\n¡Me alegra saberlo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Mesprit", true, "mesprit", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_EMURITTO (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Naturally!", french=" Naturellement!", german=" Natürlich!", italian=" Certo che stiamo bene!", spanish=" ¡Naturalmente!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(3, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So did the plan work?", french=" Alors le plan a fonctionné?", german=" Hat der Plan denn geklappt?", italian=" Allora il piano ha funzionato!", spanish=" Entonces, ¿el plan funcionó?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So was the plan successful?", french=" Alors le plan a fonctionné?", german=" Hat der Plan denn funktioniert?", italian=" Diteci, ha funzionato il piano?", spanish=" Entonces, ¿el plan funcionó?"})
  else
  SkySceneKit.say({english=" So did the plan succeed?", french=" Alors le plan a fonctionné?", german=" Hat der Plan denn funktioniert?", italian=" Diteci, ha funzionato il piano?", spanish=" Entonces, ¿el plan funcionó?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-4, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Azelf", true, "azelf", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AGUNOMU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Yep.", french=" Comme sur des roulettes.", german=" Ja.", italian=" Sì.", spanish=" A la perfección."})
  pcall(function() UI:SetSpeaker("Azelf", true, "azelf", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AGUNOMU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I have to hand it to the great\n[CS:N]Dusknoir[CR]. It was flawless.", french="Rendons grâce à [CS:N]Noctunoir[CR].\nSon plan était parfait.", german="Ich muss wirklich sagen, dass\nder Plan von [CS:N]Zwirrfinst[CR] einwandfrei\nfunktionierte.", italian="Il merito è tutto del grande\n[CS:N]Dusknoir[CR]. È stato perfetto.", spanish="Hay que reconocer que el plan\nde [CS:N]Dusknoir[CR] era impecable."})
  pcall(function() UI:SetSpeaker("Azelf", true, "azelf", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AGUNOMU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" [CS:N]Grovyle[CR]'s been captured.", french=" [CS:N]Massko[CR] est hors d'état de nuire.", german=" [CS:N]Reptain[CR] wurde gefasst.", italian=" [CS:N]Grovyle[CR] è stato catturato.", spanish=" [CS:N]Grovyle[CR] ha sido capturado."})
  pcall(function() UI:SetSpeaker("Azelf", true, "azelf", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AGUNOMU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="And we regained all the Time\nGears he'd stolen.", french="Et nous avons récupéré tous\nles Rouages du Temps qu'il avait volés.", german="Und wir haben die gestohlenen\nZahnräder der Zeit wieder.", italian="Siamo anche tornati in possesso\ndegli Ingranaggi del Tempo rubati.", spanish="Y hemos recuperado todos los\nEngranajes del Tiempo que había robado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yes! That's awesome!", french=" Super!", german=" Ja! Super!", italian=" Wow! Fantastico!", spanish=" ¡Genial! ¡Me alegro mucho!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes! That's excellent!", french=" Super!", german=" Ja! Großartig!", italian=" Sì! Benissimo!", spanish=" ¡Excelente! ¡Me alegro mucho!"})
  else
  SkySceneKit.say({english=" Yes! I'm so glad!", french=" Super!", german=" Ja! Bin ich froh!", italian=" Sì! Benissimo!", spanish=" ¡Genial! ¡Cómo me alegro!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Uxie", true, "uxie", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YUKUSHII (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR] should be along shortly.", french="[CS:N]Noctunoir[CR] ne devrait pas tarder\nà arriver.", german="[CS:N]Zwirrfinst[CR] müsste gleich hier\nsein.", italian="[CS:N]Dusknoir[CR] dovrebbe essere qui tra\nbreve.", spanish=" [CS:N]Dusknoir[CR] estará aquí enseguida."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  GROUND:EntTurn(npc_npc_ringuma, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Oh! Who's that?!", french=" Oh! Qui est-ce?!", german=" Oh! Wer ist das?!?", italian=" Oh! Chi è quello?!", spanish=" ¡Oh! ¡¿Quién es ese?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(npc_npc_s_yukushii, Direction.Right)
  GROUND:EntTurn(npc_npc_s_emuritto, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_s_agunomu, Direction.Right)
  GROUND:EntTurn(npc_npc_himeguma, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_s_kimawari, Direction.Right)
  GROUND:EntTurn(npc_npc_s_dogoomu, Direction.Right)
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.DownRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_kakureon1, Direction.Right)
  GROUND:EntTurn(npc_npc_s_heigani, Direction.Right)
  GROUND:EntTurn(npc_npc_s_bippa, Direction.Right)
  GROUND:EntTurn(npc_npc_s_perappu, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_s_pukurin, Direction.Right)
  GROUND:EntTurn(npc_npc_s_chiriin, Direction.DownRight)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_s_dagutorio, Direction.Right)
  GROUND:EntTurn(npc_npc_s_diguda, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" It's the great [CS:N]Dusknoir[CR]!", french=" Le grand [CS:N]Noctunoir[CR]!", german=" Das ist der große [CS:N]Zwirrfinst[CR]!", italian=" È il grande [CS:N]Dusknoir[CR]!", spanish=" ¡Es el gran [CS:N]Dusknoir[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" Here comes the great [CS:N]Dusknoir[CR]!", french=" Voilà le grand [CS:N]Noctunoir[CR]!", german="Hier kommt der große\n[CS:N]Zwirrfinst[CR]!", italian="Ecco che arriva il grande\n[CS:N]Dusknoir[CR]!", spanish=" ¡Aquí viene el gran [CS:N]Dusknoir[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_s_dogoomu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Everyone! MAKE WAY!", french=" Tout le monde! FAITES PLACE!", german=" Leute! MACHT PLATZ!", italian=" FATE LARGO!", spanish=" ¡Todos a un lado! ¡Abrid paso!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_s_yamirami1 = SkySceneKit.spawn_npc("sableye", 592, 208, Direction.Left, "NPC_S_YAMIRAMI1")
  GROUND:MoveToPosition(npc_npc_s_yamirami1, 360, 204, false, 1)
  local npc_npc_s_juputoru = SkySceneKit.spawn_npc("grovyle", 616, 208, Direction.Left, "NPC_S_JUPUTORU")
  -- SetAnimation(46) [anim idle native]
  GROUND:MoveToPosition(npc_npc_s_juputoru, 360, 204, false, 1)
  local npc_npc_s_yamirami2 = SkySceneKit.spawn_npc("sableye", 640, 208, Direction.Left, "NPC_S_YAMIRAMI2")
  GROUND:MoveToPosition(npc_npc_s_yamirami2, 360, 204, false, 1)
  local npc_npc_s_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 664, 208, Direction.Left, "NPC_S_YONOWAARU")
  GROUND:MoveToPosition(npc_npc_s_yonowaaru, 360, 204, false, 1)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(176), g.ViewCenter.Y+(0), 117, false) end) -- MovePositionOffset performer/caméra
  do local p=npc_npc_jibakoiru.Position; GROUND:MoveToPosition(npc_npc_jibakoiru, p.X+(-48), p.Y+(0), false, 2) end
  GROUND:MoveToPosition(npc_npc_s_diguda, 444, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 452, 176, false, 2)
  GROUND:MoveToPosition(npc_npc_s_chiriin, 428, 172, false, 2)
  GROUND:MoveToPosition(npc_npc_s_bippa, 408, 172, false, 2)
  GROUND:MoveToPosition(npc_npc_s_dagutorio, 436, 244, false, 2)
  GROUND:MoveToPosition(npc_npc_s_pukurin, 412, 248, false, 2)
  GROUND:MoveToPosition(npc_npc_s_perappu, 392, 236, false, 2)
  GROUND:MoveToPosition(npc_npc_s_heigani, 376, 244, false, 2)
  GROUND:MoveToPosition(npc_npc_kakureon1, 360, 252, false, 2)
  GROUND:MoveToPosition(hero, 348, 228, false, 2)
  GROUND:MoveToPosition(partner, 324, 224, false, 2)
  GROUND:MoveToPosition(npc_npc_s_kimawari, 296, 200, false, 2)
  GROUND:MoveToPosition(npc_npc_s_dogoomu, 320, 200, false, 2)
  GROUND:MoveToPosition(npc_npc_himeguma, 336, 256, false, 2)
  GROUND:MoveToPosition(npc_npc_s_yukushii, 288, 244, false, 2)
  GROUND:MoveToPosition(npc_npc_s_emuritto, 288, 216, false, 2)
  GROUND:MoveToPosition(npc_npc_s_agunomu, 312, 252, false, 2)
  GROUND:MoveToPosition(npc_npc_ringuma, 272, 240, false, 2)
  GROUND:MoveToPosition(npc_npc_jibakoiru, 264, 196, false, 2)
  GROUND:EntTurn(npc_npc_s_dagutorio, Direction.UpRight)
  GROUND:EntTurn(npc_npc_s_pukurin, Direction.UpRight)
  GROUND:EntTurn(npc_npc_s_heigani, Direction.UpRight)
  GROUND:EntTurn(npc_npc_s_diguda, Direction.DownRight)
  GROUND:EntTurn(npc_npc_s_chiriin, Direction.DownRight)
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownRight)
  GROUND:EntTurn(npc_npc_s_bippa, Direction.DownRight)
  GROUND:EntTurn(npc_npc_s_perappu, Direction.UpRight)
  GROUND:EntTurn(npc_npc_kakureon1, Direction.UpRight)
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(npc_npc_himeguma, Direction.UpRight)
  GROUND:EntTurn(npc_npc_s_agunomu, Direction.Right)
  GROUND:EntTurn(npc_npc_s_yukushii, Direction.Right)
  GROUND:EntTurn(npc_npc_s_emuritto, Direction.Right)
  GROUND:EntTurn(npc_npc_s_dogoomu, Direction.Right)
  GROUND:EntTurn(npc_npc_s_kimawari, Direction.Right)
  GROUND:EntTurn(npc_npc_ringuma, Direction.Right)
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Th-that's...", french=" C-C'est...", german=" D-das...", italian=" E quello...", spanish=" Ese..."})
  GAME:WaitFrames(90)
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-176), g.ViewCenter.Y+(0), 593, false) end) -- MovePositionOffset performer/caméra
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" That's [CS:N]Grovyle[CR]?", french=" C'est [CS:N]Massko[CR], ça?", german=" Ist das [CS:N]Reptain[CR]?", italian=" Quello è [CS:N]Grovyle[CR]?", spanish=" ¿Ese es [CS:N]Grovyle[CR]?"})
  GAME:WaitFrames(120)
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="He looks like a BAD guy, that's\nfor sure!", french="Sans blague, il a une mine\nPATIBULAIRE!", german="Er sieht wirklich wie ein\nÜBLER Kerl aus!", italian=" Quello sì che sembra un cattivo!", spanish=" ¡QUÉ CARA DE MALVADO!"})
  GAME:WaitFrames(120)
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_s_diguda, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_s_chiriin, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_s_bippa, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_s_dagutorio, Direction.Up)
  GROUND:EntTurn(npc_npc_s_pukurin, Direction.Up)
  GROUND:EntTurn(npc_npc_s_perappu, Direction.Up)
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Heh, it's great they finally\ncaught him.", french="Eh, c'est super qu'ils aient enfin\nréussi à l'attraper.", german="Hehe! Zum Glück haben sie ihn\nendlich geschnappt.", italian="Per fortuna lo hanno preso,\nfinalmente!", spanish="Menos mal que al final le han\ncogido."})
  GAME:WaitFrames(120)
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="That's right. The world was\nnearly ruined because of him.", french="Bien dit! On a frôlé la fin\ndu monde par sa faute.", german="Stimmt. Seinetwegen wäre fast\ndie Welt untergegangen.", italian="È vero. Il mondo ha rischiato di\nandare verso la rovina a causa sua.", spanish="Ya lo creo. El mundo ha estado\nen peligro por su culpa."})
  GROUND:MoveToPosition(npc_npc_s_yamirami1, 360, 164, false, 1)
  GROUND:EntTurn(npc_npc_s_diguda, Direction.Left)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Left)
  GROUND:EntTurn(npc_npc_s_chiriin, Direction.Left)
  GROUND:EntTurn(npc_npc_s_bippa, Direction.Left)
  GROUND:EntTurn(npc_npc_s_dagutorio, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_s_pukurin, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_s_perappu, Direction.UpLeft)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_s_dogoomu, Direction.Up)
  GROUND:EntTurn(npc_npc_s_kimawari, Direction.Up)
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.UpRight)
  GROUND:EntTurn(npc_npc_s_emuritto, Direction.UpRight)
  GROUND:EntTurn(npc_npc_s_yukushii, Direction.UpRight)
  GROUND:EntTurn(npc_npc_s_agunomu, Direction.Up)
  GROUND:EntTurn(npc_npc_himeguma, Direction.Up)
  GROUND:EntTurn(npc_npc_ringuma, Direction.UpRight)
  GROUND:MoveToPosition(npc_npc_s_juputoru, 360, 164, false, 1)
  GROUND:MoveToPosition(npc_npc_s_yamirami1, 296, 164, false, 1)
  -- message_CloseEnforce
  GROUND:MoveToPosition(npc_npc_s_juputoru, 316, 164, false, 1)
  GROUND:MoveToPosition(npc_npc_s_yamirami2, 360, 164, false, 2)
  GROUND:EntTurn(npc_npc_s_yamirami1, Direction.Down)
  GROUND:MoveToPosition(npc_npc_s_yamirami2, 340, 164, false, 2)
  GROUND:MoveToPosition(npc_npc_s_yonowaaru, 352, 180, false, 1)
  GROUND:EntTurn(npc_npc_s_juputoru, Direction.Down)
  -- SetAnimation(26) [anim idle native]
  GROUND:EntTurn(npc_npc_s_yamirami2, Direction.Down)
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-20), 40, false) end) -- MovePositionOffset performer/caméra
  GROUND:MoveToPosition(npc_npc_s_diguda, 436, 212, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 444, 184, false, 2)
  GROUND:MoveToPosition(npc_npc_s_chiriin, 420, 196, false, 2)
  GROUND:MoveToPosition(npc_npc_s_bippa, 408, 172, false, 2)
  GROUND:MoveToPosition(npc_npc_s_dagutorio, 404, 236, false, 2)
  GROUND:MoveToPosition(npc_npc_s_pukurin, 412, 216, false, 2)
  GROUND:MoveToPosition(npc_npc_s_perappu, 392, 200, false, 2)
  GROUND:MoveToPosition(npc_npc_s_heigani, 380, 228, false, 2)
  GROUND:MoveToPosition(npc_npc_kakureon1, 360, 236, false, 2)
  GROUND:MoveToPosition(hero, 372, 204, false, 2)
  GROUND:MoveToPosition(partner, 348, 204, false, 2)
  GROUND:MoveToPosition(npc_npc_s_kimawari, 296, 200, false, 2)
  GROUND:MoveToPosition(npc_npc_s_dogoomu, 320, 200, false, 2)
  GROUND:MoveToPosition(npc_npc_himeguma, 336, 240, false, 2)
  GROUND:MoveToPosition(npc_npc_s_yukushii, 304, 224, false, 2)
  GROUND:MoveToPosition(npc_npc_s_emuritto, 284, 220, false, 2)
  GROUND:MoveToPosition(npc_npc_s_agunomu, 328, 228, false, 2)
  GROUND:MoveToPosition(npc_npc_ringuma, 272, 240, false, 2)
  GROUND:MoveToPosition(npc_npc_jibakoiru, 264, 196, false, 2)
  GROUND:EntTurn(npc_npc_s_emuritto, Direction.UpRight)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Left)
  GROUND:EntTurn(npc_npc_s_chiriin, Direction.Left)
  GROUND:EntTurn(npc_npc_s_pukurin, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_s_dagutorio, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_s_perappu, Direction.UpLeft)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_s_diguda, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 352, 192, Direction.Down, "NPC_YONOWAARU")
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Everyone!", french=" Oyez, oyez!", german=" Pokémon!", italian=" Signore e signori!", spanish=" ¡Escuchadme todos!"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Today, I would like to share\nexcellent news with you.", french="Aujourd'hui j'ai une excellente\nnouvelle à vous annoncer!", german="Ich darf euch heute eine\nwunderbare Neuigkeit überbringen.", italian="È con estremo piacere che vi\ncomunico quest'oggi l'esito della nostra\nmissione!", spanish="Hoy quiero compartir excelentes\nnoticias con vosotros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Finally...[K][CS:N]Grovyle[CR]...", french=" Enfin...[K] [CS:N]Massko[CR]...", german=" Endlich wurde [K][CS:N]Reptain[CR]...", italian=" Finalmente...[K] [CS:N]Grovyle[CR]...", spanish=" Finalmente...[K] [CS:N]Grovyle[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" [CS:N]Grovyle[CR] has been captured!", french=" [CS:N]Massko[CR] a enfin été capturé!", german=" ...[CS:N]Reptain[CR] wurde gefasst!", italian=" [CS:N]Grovyle[CR] è stato catturato!", spanish=" ¡[CS:N]Grovyle[CR] ha sido capturado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5138) — id SE NDS sans portage PMDO identifié
  -- call @label_0 [sous-routine locale adjacente: flux naturel]
  GAME:WaitFrames(120)
  -- call @label_1 [sous-routine locale adjacente: flux naturel]
  -- se_FadeOut(5138, 60) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="This was all made possible\nby your selfless support and cooperation!", french="Sans votre infaillible soutien\net votre précieuse coopération, jamais nous\nn'aurions pu y arriver!", german="Dies war nur dank eurer\nHilfsbereitschaft und Kooperation möglich!", italian="Tutto questo grazie al vostro\naiuto!", spanish="¡Esto ha sido posible gracias a\nvuestra desinteresada colaboración!"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" I can't thank you enough!", french="Je ne pourrai jamais vous\nremercier assez!", german="Ich kann euch nicht genug\ndanken!", italian="Non potrò mai ringraziarvi\nabbastanza!", spanish=" ¡No sé cómo daros las gracias!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5138) — id SE NDS sans portage PMDO identifié
  -- call @label_0 [sous-routine locale adjacente: flux naturel]
  GAME:WaitFrames(120)
  -- call @label_1 [sous-routine locale adjacente: flux naturel]
  -- se_FadeOut(5138, 60) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="As you can see, [CS:N]Grovyle[CR] is a\nvicious and wicked Pokémon.", french="Comme vous pouvez le\nconstater, [CS:N]Massko[CR] est un infâme Pokémon\nà l'esprit maléfique.", german="Wie ihr seht, ist [CS:N]Reptain[CR] ein\ngemeines und hinterhältiges Pokémon.", italian="Come potete vedere, [CS:N]Grovyle[CR] è\nun Pokémon subdolo e malvagio.", spanish="Como veis, [CS:N]Grovyle[CR] es un\nPokémon desalmado y brutal."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_s_heigani, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_kakureon1, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="His capture should result in\nlasting peace for your world.", french="Sa capture devrait garantir\nune paix durable à votre monde.", german="Nach seiner Festnahme sollte in\neurer Welt für lange Zeit Frieden herrschen.", italian="La sua cattura assicurerà la\npace in questo mondo.", spanish="Su captura traerá paz a vuestro\nmundo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_juputoru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_s_juputoru, "sweating", 1) end)
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- message_FacePositionOffset(1, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Grovyle", true, "grovyle", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_JUPUTORU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Mmmmmf![K] Mmmmmf!", french=" Mmh![K] Mhhhhh!", german=" Mmmmmf![K] Mmmmmf!", italian=" Mmmmmf![K] Mmmmmf!", spanish=" ¡Mmmm![K] ¡Mmmm!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It looks like they have [CS:N]Grovyle[CR]\nmuzzled...", french="On dirait que [CS:N]Massko[CR]\nest réduit au silence...", german="Wie es aussieht, haben sie\n[CS:N]Reptain[CR] geknebelt...", italian="A quanto pare hanno imbavagliato\n[CS:N]Grovyle[CR]...", spanish="Parece que han amordazado a\n[CS:N]Grovyle[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It looks like they have [CS:N]Grovyle[CR]\nmuzzled...", french="On dirait que [CS:N]Massko[CR]\nest réduit au silence...", german="Wie es aussieht, haben sie\n[CS:N]Reptain[CR] geknebelt...", italian="A quanto pare hanno imbavagliato\n[CS:N]Grovyle[CR]...", spanish="Parece que han amordazado a\n[CS:N]Grovyle[CR]..."})
  else
  SkySceneKit.say({english="It looks like they have [CS:N]Grovyle[CR]\nmuzzled...", french="On dirait que [CS:N]Massko[CR]\nest réduit au silence...", german="Wie es aussieht, haben sie\n[CS:N]Reptain[CR] geknebelt...", italian="A quanto pare hanno imbavagliato\n[CS:N]Grovyle[CR]...", spanish="Parece que han amordazado a\n[CS:N]Grovyle[CR]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" He can't say a word that way.", french="Impossible de prononcer\nle moindre mot, muselé comme il est.", german=" Er kann kein Wort sagen.", italian=" Non può proprio parlare, così.", spanish="Así no puede decir ni una\npalabra."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" He can't say a word that way.", french="Impossible de prononcer\nle moindre mot, muselé comme il est.", german=" Er kann kein Wort sagen.", italian=" Non può proprio parlare, così.", spanish="Así no puede decir ni una\npalabra."})
  else
  SkySceneKit.say({english=" He can't say a word that way.", french="Impossible de prononcer\nle moindre mot, muselé comme il est.", german=" Er kann kein Wort sagen.", italian=" Non può proprio parlare, così.", spanish="Así no puede decir ni una\npalabra."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="But...[K]I must also deliver a\nsad piece of news.", french="Mais...[K] j'ai aussi une bien triste\nnouvelle à vous apprendre.", german="Aber...[K] Ich habe auch eine\nschlechte Neuigkeit.", italian="Purtroppo...[K] porto con me\nanche delle brutte notizie...", spanish="Aunque...[K] también tengo que\ndaros una triste noticia."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_s_heigani, Direction.Up)
  GROUND:EntTurn(npc_npc_kakureon1, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="It is time for me to return to\nthe future.", french="Il est temps pour moi de\nregagner mon monde.", german="Es ist an der Zeit für mich, in\ndie Zukunft zurückzukehren.", italian="È tempo per me di tornare nel\nfuturo.", spanish="Ya es hora de que regrese\nal futuro."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Everyone![K] I must now bid you\nfarewell.", french="Vous tous![K] Je dois vous\nfaire mes adieux sur-le-champ.", german="Lebt wohl![K] Ich muss euch nun\nverlassen.", italian="Signore e signori![K] È tempo di\ndirsi addio!", spanish="Por tanto...[K]\nAhora debo deciros adiós."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_AT_THE_END_OF_THE_DAY non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Oh, so that was true? Hey, hey...", french=" Oh, alors c'était vrai, dis donc...", german=" Oh, es stimmte also? Hey, hey...", italian="Ehi, ehi... Allora le cose stavano\nproprio così...", spanish="Oh, ¿así que era verdad?\nOye, oye..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" I'm feeling the blues...", french=" Ça m'fiche l'cafard...", german="Das macht mich ganz\nmelancholisch...", italian=" Che tristezza...", spanish=" Me siento un tanto melancólico..."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="There was so much I wanted to\nlearn from you, yup yup...", french="Y'a tant d'choses que j'espérais\napprendre de vous, pour sûr...", german="Ich wollte noch so viel von dir\nlernen, jawollja...", italian="Avrei voluto chiederle così\ntante cose, sissignore...", spanish="Había tantas cosas que quería\naprender de ti. Sí, señor..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" [CS:N]Uxie[CR]...[CS:N]Mesprit[CR]...[CS:N]Azelf[CR]...", french="[CS:N]Créhelf[CR]... [CS:N]Créfollet[CR]...\n[CS:N]Créfadet[CR]...", german=" [CS:N]Selfe[CR]... [CS:N]Vesprit[CR]... [CS:N]Tobutz[CR]...", italian=" [CS:N]Uxie[CR]... [CS:N]Mesprit[CR]... [CS:N]Azelf[CR]...", spanish=" [CS:N]Uxie[CR]... [CS:N]Mesprit[CR]... [CS:N]Azelf[CR]..."})
  -- message_KeyWait
  GROUND:EntTurn(npc_npc_s_yukushii, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" I entrust you with the rest.", french="Je vous fais confiance\npour la suite.", german="Ich vertraue euch die Aufgabe\nan, es zu Ende zu bringen.", italian=" Affido a voi il resto.", spanish=" Os confío a vosotros el resto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 4) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Azelf", true, "azelf", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_AGUNOMU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Yep.", french=" Ouaip.", german=" Ja.", italian=" D'accordo.", spanish=" Sí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Mesprit", true, "mesprit", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_EMURITTO (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" We know.", french="Nous savons ce que nous avons\nà faire.", german=" Wir wissen Bescheid.", italian=" Lasci fare a noi.", spanish=" Lo sabemos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Uxie", true, "uxie", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YUKUSHII (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" We got the Time Gears back.", french="Nous avons récupéré\nles Rouages du Temps.", german="Wir haben die Zahnräder der\nZeit wieder.", italian="Gli Ingranaggi del Tempo sono\ntornati in mano nostra...", spanish="Hemos recuperado los Engranajes\ndel Tiempo."})
  pcall(function() UI:SetSpeaker("Uxie", true, "uxie", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YUKUSHII (espèce ROM, sans placement zone)
  SkySceneKit.say({english="And we will make sure they're\nreturned to their rightful places.", french="Et nous allons nous assurer\nqu'ils reprennent leur juste place.", german="Und wir werden sicherstellen,\ndass sie wieder da hinkommen, wo sie\nhingehören.", italian="Sarà nostro compito rimetterli\nal loro posto.", spanish="Y nos encargaremos de que\nvuelvan a ocupar el lugar que les corresponde."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" The task is yours.", french=" Cette tâche vous revient.", german=" Das ist eure Aufgabe.", italian=" Va bene.", spanish=" Eso queda en vuestras manos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! Thank you very much!\nZZZT! For everything! ZZZT!", french="ZZZT! Merci beaucoup!\nZZZT! Merci pour tout! ZZZT!", german="ZZZT! Vielen Dank!\nZZZT! Für alles! ZZZT!", italian="ZZZT! Grazie! ZZZT! Grazie di\ntutto! ZZZT!", spanish="¡Bzz! ¡Muchas gracias! ¡Bzz!\n¡Por todo! ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! You have literally saved\nus all. ZZZT!", french="ZZZT! Vous nous avez tous\nsauvés. ZZZT!", german="ZZZT! Du hast uns wirklich alle\ngerettet. ZZZT!", italian="ZZZT! Ci avete salvati tutti.\nGrazie! ZZZT!", spanish="¡Bzz! Nos has salvado a todos.\n¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Oh, no, no...", french=" Que nenni...", german=" Oh, ach was...", italian=" Oh, no, no...", spanish=" Oh, no, qué va..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="You have been most kind and\nhelpful.", french="Votre urbanité n'a d'égale\nque votre obligeance.", german="Du warst sehr freundlich und\nhilfsbereit.", italian=" Il merito è anche vostro.", spanish="Habéis sido muy atentos y\nserviciales."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I hope you will continue to work\nto preserve the peace.", french="Faites en sorte de préserver\nla paix en ce monde.", german="Ich hoffe, dass du weiterhin\nfür die Sicherheit dieser Welt sorgen wirst.", italian="Spero che manterrete il vostro\nimpegno e farete di tutto perché la pace\nregni nel mondo.", spanish="Espero que sigáis trabajando\npara preservar la paz."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! Yes! You can depend on\nthat! ZZZT!", french="ZZZT! Oui! Vous pouvez compter\nsur nous! ZZZT!", german="ZZZT! Ja! Darauf kannst du\ndich verlassen! ZZZT!", italian=" ZZZT! Può scommetterci! ZZZT!", spanish="¡Bzz! ¡De acuerdo! ¡Puedes\ncontar con ello! ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Now...[K]I'm afraid the time\nhas come.", french="A présent...[K] je crains\nque l'heure ne soit venue.", german=" Nun...[K] Es ist leider an der Zeit.", italian="E ora...[K] temo che sia giunto\nil momento.", spanish="Ahora...[K] Me temo\nque el momento ha llegado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-16), 32, false) end) -- MovePositionOffset performer/caméra
  GROUND:EntTurn(npc_npc_s_kimawari, Direction.UpRight)
  GROUND:EntTurn(npc_npc_s_dogoomu, Direction.UpRight)
  GROUND:MoveToPosition(npc_npc_s_yamirami2, 368, 156, false, 1)
  -- SetAnimation(46) [anim idle native]
  GROUND:MoveToPosition(npc_npc_s_juputoru, 348, 156, false, 1)
  GROUND:MoveToPosition(npc_npc_s_yamirami1, 328, 156, false, 1)
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.Up)
  GROUND:EntTurn(npc_npc_s_yamirami2, Direction.Left)
  -- SetAnimation(26) [anim idle native]
  do local p=npc_npc_s_juputoru.Position; GROUND:MoveToPosition(npc_npc_s_juputoru, p.X+(4), p.Y+(-8), false, 1) end
  GROUND:EntTurn(npc_npc_s_yamirami1, Direction.Right)
  do local p=npc_npc_s_yamirami2.Position; GROUND:MoveToPosition(npc_npc_s_yamirami2, p.X+(-16), p.Y+(0), false, 1) end
  GROUND:EntTurn(npc_npc_s_yamirami2, Direction.Up)
  GAME:WaitFrames(15)
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_s_yamirami2, "shock", 1) end)
  -- SetAnimation(12) [anim idle native]
  do local p=npc_npc_s_juputoru.Position; GROUND:MoveToPosition(npc_npc_s_juputoru, p.X+(0), p.Y+(-16), false, 2) end
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(7183) — id SE NDS sans portage PMDO identifié
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_s_yamirami1, Direction.Right)
  GROUND:EntTurn(npc_npc_s_yamirami2, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  do local p=npc_npc_s_yamirami2.Position; GROUND:MoveToPosition(npc_npc_s_yamirami2, p.X+(0), p.Y+(-24), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(7183) — id SE NDS sans portage PMDO identifié
  -- Destroy() [neutre/état moteur]
  do local p=npc_npc_s_yamirami1.Position; GROUND:MoveToPosition(npc_npc_s_yamirami1, p.X+(24), p.Y+(0), false, 2) end
  do local p=npc_npc_s_yamirami1.Position; GROUND:MoveToPosition(npc_npc_s_yamirami1, p.X+(0), p.Y+(-24), false, 2) end
  GROUND:EntTurn(npc_npc_s_yamirami1, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(7183) — id SE NDS sans portage PMDO identifié
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(60)
  do local p=npc_npc_s_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_s_yonowaaru, p.X+(0), p.Y+(-16), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Everyone![K] Though it pains me...", french="Vous tous![K] C'est un déchirement\npour moi...", german="Pokémon![K] Es tut mir im Herzen\nweh...", italian=" Per quanto mi addolori...", spanish="¡Amigos![K] Aunque siento un gran\ndolor en mi corazón..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_kimawari, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Ooogie...[K]I hate sad good-byes!", french=" Snif...[K] je déteste les adieux!", german="Schnief...[K] Ich hasse traurige\nAbschiede!", italian=" Sniff...[K] Odio gli addii!", spanish=" Ayy...[K] ¡Cómo odio las despedidas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_s_diguda, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 384, 176, Direction.DownLeft, "NPC_DIGUDA")
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" I h-h-hope we see you again...", french="J'espère qu'on vous reverra\nun jour, snif...", german="Ich h-h-hoffe, dass wir uns\nwiedersehen werden...", italian=" A-Arrivederci! A presto...", spanish=" Espero volver a verte..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_perappu, "sweating", 1) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 352, 176, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Waaah!", french=" Bouhouuu!", german=" Wäääh!", italian=" Waaaa!", spanish=" ¡Buaaa!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR]...sir...waaah!", french=" Messire... [CS:N]Noctunoir[CR]... bouhouuu!", german=" [CS:N]Zwirrfinst[CR]... wäääh!", italian=" S-Signor [CS:N]Dusknoir[CR]... Sob... Sniff!", spanish=" [CS:N]Dusknoir[CR]... ¡Buaaa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  do local p=npc_npc_s_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_s_yonowaaru, p.X+(0), p.Y+(-12), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_yonowaaru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Oh, yes.", french=" Ah, au fait.", german=" Oh, ach ja.", italian=" Oh, dimenticavo.", spanish=" Ah, sí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_s_yonowaaru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Before I go...[K]I must see two\nPokémon...", french="Avant de partir...[K] j'ai deux\nPokémon à voir...", german="Bevor ich gehe,[K] muss ich noch\nzwei Pokémon sehen...", italian="Prima di andarmene...[K] vorrei\ndire una cosa a due Pokémon...", spanish="Antes de irme...[K] Tengo que ver\na dos Pokémon."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" [partner]! [K]And [hero]!", french=" [partner]! [K]Et [hero]!", german=" [partner]! [K]Und [hero]!", italian=" [partner]![K] E [hero]!", spanish="¡[partner]! [K]\n¡Y [hero]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's us. Let's go up there.", french=" C'est nous. Approchons-nous.", german=" Das sind wir. Gehen wir zu ihm.", italian=" Siamo noi! Andiamo.", spanish="¡Vaya! Quiere despedirse\nde nosotros..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's us. Let's go up there.", french=" C'est nous. Approchons-nous.", german=" Das sind wir. Gehen wir zu ihm.", italian=" Siamo noi! Andiamo.", spanish="¡Vaya! Quiere despedirse\nde nosotros..."})
  else
  SkySceneKit.say({english=" That's us. Let's go up there.", french=" C'est nous. Approchons-nous.", german=" Das sind wir. Gehen wir zu ihm.", italian=" Siamo noi! Andiamo.", spanish=" ¡Vaya! Quiere despedirse..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 344, 176, false, 1)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(hero, 364, 176, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So, this is really good-bye!", french="Alors, ça y est, il faut se dire\nau revoir pour de bon!", german="Jetzt nehmen wir also wirklich\nAbschied!", italian="E così, è il momento di dirci\naddio...", spanish="Así que aquí nos decimos\nadiós..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So, this is really good-bye!", french="Alors, ça y est, il faut se dire\nau revoir pour de bon!", german="Jetzt nehmen wir also wirklich\nAbschied!", italian="E così, è il momento di dirci\naddio...", spanish="Así que aquí nos decimos\nadiós..."})
  else
  SkySceneKit.say({english=" So, this is really good-bye!", french="Alors, ça y est, il faut se dire\nau revoir pour de bon!", german="Jetzt nehmen wir also wirklich\nAbschied!", italian="E così, è il momento di dirci\naddio...", spanish="Así que aquí nos decimos\nadiós..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR], sir!", french=" Messire [CS:N]Noctunoir[CR]!", german=" [CS:N]Zwirrfinst[CR]!", italian=" Signor [CS:N]Dusknoir[CR]...", spanish=" ¡[CS:N]Dusknoir[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR], sir!", french=" Messire [CS:N]Noctunoir[CR]!", german=" [CS:N]Zwirrfinst[CR]!", italian=" Signor [CS:N]Dusknoir[CR]...", spanish=" ¡[CS:N]Dusknoir[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR], sir!", french=" Messire [CS:N]Noctunoir[CR]!", german=" [CS:N]Zwirrfinst[CR]!", italian=" Signor [CS:N]Dusknoir[CR]...", spanish=" ¡[CS:N]Dusknoir[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="For everything you've done...[K]\nThank you! Sincerely!", french="Merci! Sincèrement...[K]\npour tout ce que vous avez fait pour nous!", german="Du hast so viel für uns getan...[K]\nDanke! Wirklich!", italian="Per tutto quello che ha fatto\nper noi...[K] grazie di cuore!", spanish="Muchas gracias...[K] por todo lo que\nhas hecho... ¡De verdad!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="For everything you've done...[K]\nThank you! Sincerely!", french="Merci! Sincèrement...[K]\npour tout ce que vous avez fait pour nous!", german="Du hast so viel für uns getan...[K]\nDanke! Wirklich!", italian="Per tutto quello che ha fatto\nper noi...[K] grazie di cuore!", spanish="Muchas gracias...[K] por todo lo que\nhas hecho... ¡De verdad!"})
  else
  SkySceneKit.say({english="For everything you've done...[K]\nThank you! Sincerely!", french="Merci! Sincèrement...[K]\npour tout ce que vous avez fait pour nous!", german="Du hast so viel für uns getan...[K]\nDanke! Wirklich!", italian="Per tutto quello che ha fatto\nper noi...[K] grazie di cuore!", spanish="Muchas gracias...[K] por todo lo que\nhas hecho... ¡De verdad!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Well...[K]this is...[K]good-bye...", french="Alors...[K] disons-nous...[K]\nau revoir...", german=" Nun...[K] Dies ist...[K] der Abschied...", italian="Sì...[K] certo...[K] è il momento di\ndirsi addio...", spanish="Bueno...[K] Es hora del...[K]\nadiós..."})
  -- message_KeyWait
  pcall(function() SOUND:FadeOutBGM(60) end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Or is it?", french=" Mais le faut-il vraiment?", german=" Oder nicht?", italian=" O forse no...", spanish=" ¿O tal vez no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?!", french=" Pardon?!", german=" Huch?!?", italian=" Eeh?!", spanish=" ¡¿Qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?!", french=" Pardon?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  else
  SkySceneKit.say({english=" Pardon?!", french=" Pardon?!", german=" Wie bitte?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7179) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(27) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_OH_NO non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" It's too soon for farewells!", french="Il est encore trop tôt pour\nnous dire adieu!", german="Es ist noch zu früh, um sich\nzu verabschieden!", italian=" È troppo presto per gli addii!", spanish=" ¡Es muy pronto para despedidas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(28) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(7943) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waah!", french=" Ouaaah!", german=" Waah!", italian=" Aargh!!!", spanish=" ¡Aaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah!", french=" Ouaaah!", german=" Waah!", italian=" Aaah!", spanish=" ¡Aaah!"})
  else
  SkySceneKit.say({english=" Waah!", french=" Ouaaah!", german=" Waah!", italian=" Aaah!", spanish=" ¡Aaah!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_diguda, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_perappu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_bippa, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dogoomu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dagutorio, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_jibakoiru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_himeguma, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" You two...[K]are coming with me!", french="Vous deux...[K] vous venez avec\nmoi!", german=" Ihr zwei...[K] kommt mit mir!", italian=" Voi due...[K] venite con me!", spanish=" Porque...[K] ¡os venís conmigo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(50) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-16), false, 2) end -- SlidePositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_s_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_s_yonowaaru, p.X+(0), p.Y+(-24), false, 1) end -- SlidePositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-24), false, 1) end -- SlidePositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-24), false, 1) end -- SlidePositionOffset
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Waaah!", italian=" Aaaah!", spanish=" ¡Aaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Waaah!", italian=" Aaaah!", spanish=" ¡Aaah!"})
  else
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Waaah!", italian=" Aaaah!", spanish=" ¡Aaah!"})
  end
  GAME:WaitFrames(45)
  -- message_CloseEnforce
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- GAP: se_Play(7183) — id SE NDS sans portage PMDO identifié
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_diguda, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_perappu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_bippa, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dogoomu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dagutorio, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_jibakoiru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_himeguma, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" By gosh!", french=" Sapristi!", german=" Meine Güte!", italian=" Ohibò!", spanish=" ¡Córcholis!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" [partner]! [hero]!", french=" [partner]! [hero]!", german=" [partner]! [hero]!", italian=" [partner]! [hero]!", spanish=" ¡[partner]! ¡[hero]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_s_diguda.Position; GROUND:MoveToPosition(npc_npc_s_diguda, p.X+(-8), p.Y+(-12), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_guregguru.Position; GROUND:MoveToPosition(npc_npc_guregguru, p.X+(-12), p.Y+(-8), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_s_chiriin.Position; GROUND:MoveToPosition(npc_npc_s_chiriin, p.X+(-12), p.Y+(-12), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_s_bippa.Position; GROUND:MoveToPosition(npc_npc_s_bippa, p.X+(-12), p.Y+(-8), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_s_dagutorio.Position; GROUND:MoveToPosition(npc_npc_s_dagutorio, p.X+(0), p.Y+(-12), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_s_pukurin.Position; GROUND:MoveToPosition(npc_npc_s_pukurin, p.X+(-8), p.Y+(-12), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_s_perappu.Position; GROUND:MoveToPosition(npc_npc_s_perappu, p.X+(-8), p.Y+(-12), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_s_heigani.Position; GROUND:MoveToPosition(npc_npc_s_heigani, p.X+(0), p.Y+(-20), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_kakureon1.Position; GROUND:MoveToPosition(npc_npc_kakureon1, p.X+(0), p.Y+(-16), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_s_kimawari.Position; GROUND:MoveToPosition(npc_npc_s_kimawari, p.X+(8), p.Y+(-12), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_s_dogoomu.Position; GROUND:MoveToPosition(npc_npc_s_dogoomu, p.X+(12), p.Y+(-16), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_himeguma.Position; GROUND:MoveToPosition(npc_npc_himeguma, p.X+(0), p.Y+(-12), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_s_yukushii.Position; GROUND:MoveToPosition(npc_npc_s_yukushii, p.X+(8), p.Y+(-12), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_s_emuritto.Position; GROUND:MoveToPosition(npc_npc_s_emuritto, p.X+(8), p.Y+(-12), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_s_agunomu.Position; GROUND:MoveToPosition(npc_npc_s_agunomu, p.X+(8), p.Y+(-12), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_ringuma.Position; GROUND:MoveToPosition(npc_npc_ringuma, p.X+(12), p.Y+(-12), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_jibakoiru.Position; GROUND:MoveToPosition(npc_npc_jibakoiru, p.X+(12), p.Y+(-12), false, 2) end -- Move2PositionOffset
  -- GAP: se_Play(7195) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_T01P01A5_194) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" Wh-what was...", french=" Qu'est-ce que...", german=" W-was war...", italian=" C-Cosa...", spanish=" ¿Pero... qué...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" What just happened...?", french=" Qu'est-ce qui s'est passé...?", german=" Was ist gerade passiert?", italian=" Cos'è successo...?", spanish=" ¿Qué acaba de suceder...?"})
  -- message_Close
  GAME:FadeOut(false,  60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  -- @label_0 [étiquette de flux ExplorerScript]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_diguda, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_perappu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_bippa, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_jibakoiru, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_himeguma, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "happy", 1) end)
  -- return [fin de routine SSB]
  GAME:WaitFrames(1) -- hold
  -- @label_1 [étiquette de flux ExplorerScript]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_perappu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_bippa, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_jibakoiru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_himeguma, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(15)
  -- return [fin de routine SSB]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
