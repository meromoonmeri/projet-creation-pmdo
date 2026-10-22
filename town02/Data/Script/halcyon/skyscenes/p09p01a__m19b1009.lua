-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P09P01A/m19b1009.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_P09P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: SetEffect 640 — VFX sans émote PMDO équivalente
  GAME:FadeIn(15)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P09P01A1_141) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(3) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(5)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 304, 264, Direction.Left, "NPC_JUPUTORU")
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  local npc_npc_serebii = SkySceneKit.spawn_npc("celebi", 304, 296, Direction.Up, "NPC_SEREBII")
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_OH_NO non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Ack! Our time-traveling path has\nbeen shattered!", french="Aïe! Notre passage dans\nle temps a volé en éclats!", german="Argh! Unser Zeitreise-Pfad\nwurde zersplittert.", italian="Ah! Il nostro varco temporale\nè stato distrutto!", spanish="¡Aaah! ¡Han destruido la vía\npor la que viajábamos en el tiempo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Ack! Our time-traveling path has\nbeen shattered!", french="Aïe! Notre passage dans\nle temps a volé en éclats!", german="Argh! Unser Zeitreise-Pfad\nwurde zersplittert.", italian="Ah! Il nostro varco temporale\nè stato distrutto!", spanish="¡Aaah! ¡Han destruido la vía\npor la que viajábamos en el tiempo!"})
  else
  SkySceneKit.say({english="Ack! Our time-traveling path has\nbeen shattered!", french="Aïe! Notre passage dans\nle temps a volé en éclats!", german="Argh! Unser Zeitreise-Pfad\nwurde zersplittert.", italian="Ah! Il nostro varco temporale\nè stato distrutto!", spanish="¡Aaah! ¡Han destruido la vía\npor la que viajábamos en el tiempo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(300, 364, 60, false) end) -- performer/caméra
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 304, 384, Direction.Down, "NPC_YONOWAARU")
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Up)
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 256, 392, Direction.Up, "NPC_YAMIRAMI")
  GROUND:EntTurn(npc_npc_yamirami, Direction.Up)
  local npc_npc_yamirami2 = SkySceneKit.spawn_npc("sableye", 344, 392, Direction.Left, "NPC_YAMIRAMI2")
  GROUND:EntTurn(npc_npc_yamirami2, Direction.Up)
  local npc_npc_yamirami3 = SkySceneKit.spawn_npc("sableye", 248, 416, Direction.Right, "NPC_YAMIRAMI3")
  GROUND:EntTurn(npc_npc_yamirami3, Direction.Up)
  local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 352, 416, Direction.Up, "NPC_YAMIRAMI4")
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Up)
  local npc_npc_yamirami5 = SkySceneKit.spawn_npc("sableye", 248, 440, Direction.Down, "NPC_YAMIRAMI5")
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Up)
  local npc_npc_yamirami6 = SkySceneKit.spawn_npc("sableye", 352, 440, Direction.Right, "NPC_YAMIRAMI6")
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" There they are!", french=" Les voilà!", german=" Da sind sie!", italian=" Eccoli!", spanish=" ¡Ahí están!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(300, 276, 60, false) end) -- performer/caméra
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Down)
  GROUND:EntTurn(npc_npc_serebii, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We got so close to the Passage\nof Time!", french="On y était presque! On a presque\natteint le Couloir du Temps!", german="Wir sind so nahe an den\nZeittunnel gekommen!", italian="Siamo molto vicini al Portale\ndel Tempo!", spanish="¡Estábamos ya tan cerca del\npasaje!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We almost made it to the\nPassage of Time!", french="On y était presque! On a presque\natteint le Couloir du Temps!", german="Wir haben es fast bis zum\nZeittunnel geschafft!", italian="Siamo quasi al Portale del\nTempo!", spanish="¡Estábamos ya tan cerca del\npasaje!"})
  else
  SkySceneKit.say({english="We got so close to the Passage\nof Time!", french="On y était presque! On a presque\natteint le Couloir du Temps!", german="Wir sind so nahe an den\nZeittunnel gekommen!", italian="Siamo quasi al Portale del\nTempo!", spanish="¡Estábamos ya tan cerca del\npasaje!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_serebii, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.DownRight)
  GROUND:EntTurn(hero, Direction.DownLeft)
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Dive in now! You can make it!", french="Foncez maintenant! Vous pouvez\ny arriver!", german="Springt jetzt rein! Ihr könnt es\nschaffen!", italian=" Tuffatevi! Ce la potete fare!", spanish="¡Saltad dentro! ¡Aún podéis\nllegar!"})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Now! Into the Passage of Time!", french="Plongez dans le Couloir\ndu Temps! Vite!", german=" Jetzt! In den Zeittunnel!", italian=" Ora! Nel Portale del Tempo!", spanish=" ¡Ahora! ¡Al Pasaje del Tiempo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-what about you, [CS:N]Celebi[CR]?!", french=" Et... et toi, [CS:N]Celebi[CR]?!", german=" W-was ist mit dir, [CS:N]Celebi[CR]?!?", italian=" C-Che ne sarà di te, [CS:N]Celebi[CR]?!", spanish=" ¡¿Y qué pasará contigo, [CS:N]Celebi[CR]?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-what about you, [CS:N]Celebi[CR]?!", french=" Et... et toi, [CS:N]Celebi[CR]?!", german=" W-was ist mit dir, [CS:N]Celebi[CR]?!?", italian=" C-Che ne sarà di te, [CS:N]Celebi[CR]?!", spanish=" ¡¿Y qué pasará contigo, [CS:N]Celebi[CR]?!"})
  else
  SkySceneKit.say({english=" Wh-what about you, [CS:N]Celebi[CR]?!", french=" Et... et toi, [CS:N]Celebi[CR]?!", german=" W-was ist mit dir, [CS:N]Celebi[CR]?!?", italian=" C-Che ne sarà di te, [CS:N]Celebi[CR]?!", spanish=" ¡¿Y qué pasará contigo, [CS:N]Celebi[CR]?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="Don't fret over me![K] I told you I\ncan't be caught!", french="Ne vous en faites pas pour moi!\nJe vous ai déjà dit qu'on ne pouvait pas me\ncapturer!", german="Kümmert euch nicht um mich![K]\nIch sagte euch doch bereits, ich kann nicht\ngefangen werden!", italian="Non preoccupatevi per me![K]\nVi ho detto che non posso essere catturata!", spanish="¡No os inquietéis![K]\n¡Ya os dije que nadie puede capturarme!"})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="Stop the planet's paralysis...[K]\nChange history!", french="Empêchez la Paralysie de la\nPlanète...[K] Modifiez le cours de l'histoire!", german="Stoppt die Lähmung des\nPlaneten...[K] Verändert die Geschichte!", italian="Fermate la paralisi del\npianeta...[K] Cambiate la storia!", spanish="Detened la parálisis del planeta...[K]\n¡Cambiad la historia!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Thanks!", french=" Merci!", german=" Danke!", italian=" Grazie!", spanish=" ¡Gracias!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Thanks, [CS:N]Celebi[CR]!", french=" Merci, [CS:N]Celebi[CR]!", german=" Danke, [CS:N]Celebi[CR]!", italian=" Grazie, [CS:N]Celebi[CR]!", spanish=" ¡Gracias, [CS:N]Celebi[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Thank you, [CS:N]Celebi[CR]!", french=" Merci, [CS:N]Celebi[CR]!", german=" Danke, [CS:N]Celebi[CR]!", italian=" Grazie, [CS:N]Celebi[CR]!", spanish=" ¡Gracias, [CS:N]Celebi[CR]!"})
  else
  SkySceneKit.say({english=" Thank you, [CS:N]Celebi[CR]!", french=" Merci, [CS:N]Celebi[CR]!", german=" Danke, [CS:N]Celebi[CR]!", italian=" Grazie, [CS:N]Celebi[CR]!", spanish=" ¡Gracias, [CS:N]Celebi[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" You're not getting away!", french=" Vous ne m'échapperez pas!", german=" Ihr kommt nicht davon!", italian=" Non riuscirete a scappare!", spanish=" ¡No escaparéis!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(300, 300, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_yonowaaru, 300, 316, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami, 268, 284, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami2, 332, 284, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami3, 252, 300, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami4, 348, 300, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami5, 252, 324, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami6, 348, 324, false, 2)
  GROUND:MoveToPosition(npc_npc_juputoru, 300, 228, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 300, 228, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(partner, 300, 228, false, 2)
  -- SetAnimation(30) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- SetAnimation(77) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- SetAnimation(77) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_yamirami, Direction.UpRight)
  GROUND:EntTurn(npc_npc_yamirami2, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_yamirami3, Direction.UpRight)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.UpRight)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_serebii, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(7435) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 15) -- screen_WhiteOutAll
  GAME:WaitFrames(2) -- join WaitSe
  -- Destroy() [neutre/état moteur]
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- Destroy() [neutre/état moteur]
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  -- GAP: SetEffect 651 — VFX sans émote PMDO équivalente
  -- GAP: se_Play(7439) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(80)
  GAME:FadeIn(15)
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: BGM BGM_ANOTHER_STATIC_NOISE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami2, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami3, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(70)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Gah...", french=" Argh...", german=" Pah...", italian=" Ah...", spanish=" ¡Ah!"})
  -- message_Close
  GAME:WaitFrames(60)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
