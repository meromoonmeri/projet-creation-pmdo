-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P05P04A/m17a0403.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_PLANETS_PARALYSIS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_P05P04A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's as if...[K]all movement...", french=" Comme si...[K] tout mouvement...", german=" Es ist, als ob...[K] alle Bewegung...", italian="È come se...[K] tutti\ni movimenti...", spanish="Es como si...[K] todo\nel movimiento..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's as if...[K]all movement...", french=" Comme si...[K] tout mouvement...", german=" Es ist, als ob...[K] alle Bewegung...", italian="È come se...[K] tutti\ni movimenti...", spanish="Es como si...[K] todo\nel movimiento..."})
  else
  SkySceneKit.say({english=" It's as if...[K]all movement...", french=" Comme si...[K] tout mouvement...", german=" Es ist, als ob...[K] alle Bewegung...", italian="È come se...[K] tutti\ni movimenti...", spanish="Es como si...[K] todo\nel movimiento..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's as if everything's stopped.", french=" Comme si tout s'était arrêté.", german=" Es ist, als sei alles erstarrt.", italian=" È come se tutto fosse immobile.", spanish="Como si todo se hubiera\ndetenido."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's as if everything's stopped.", french=" Comme si tout s'était arrêté.", german=" Es ist, als sei alles erstarrt.", italian=" È come se tutto fosse immobile.", spanish="Como si todo se hubiera\ndetenido."})
  else
  SkySceneKit.say({english=" It's as if everything's stopped.", french=" Comme si tout s'était arrêté.", german=" Es ist, als sei alles erstarrt.", italian=" È come se tutto fosse immobile.", spanish="Como si todo se hubiera\ndetenido."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 272, 176, Direction.UpRight, "NPC_JUPUTORU")
  GROUND:EntTurn(npc_npc_juputoru, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Exactly.", french=" Précisément.", german=" Genau.", italian=" Esattamente.", spanish=" Exactamente."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?!", french=" Pardon?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?!", french=" Pardon?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  else
  SkySceneKit.say({english=" Pardon?!", french=" Pardon?!", german=" Wie?!?", italian=" Scusa?!", spanish=" ¡¿Qué?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Wheh-heh-heh!", french=" Whé hé hé!", german=" Wähähäh!", italian=" Meh-eh-eh-eh!", spanish=" ¡Je, je, je, je!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Left)
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wah! I hear those [CS:N]Sableye[CR]!", french="Ouah! Les [CS:N]Ténéfix[CR]!\nJe les entends d'ici!", german=" Wah! Ich höre die [CS:N]Zobiris[CR]!", italian=" Aah! Sento quei [CS:N]Sableye[CR]!", spanish="¡Aah! ¡Oigo venir a esos\n[CS:N]Sableye[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wah! I hear those [CS:N]Sableye[CR]!", french="Ouah! Les [CS:N]Ténéfix[CR]!\nJe les entends d'ici!", german=" Wah! Ich höre die [CS:N]Zobiris[CR]!", italian=" Aah! Sento quei [CS:N]Sableye[CR]!", spanish="¡Aah! ¡Oigo venir a esos\n[CS:N]Sableye[CR]!"})
  else
  SkySceneKit.say({english=" Wah! I hear those [CS:N]Sableye[CR]!", french="Ouah! Les [CS:N]Ténéfix[CR]!\nJe les entends d'ici!", german=" Wah! Ich höre die [CS:N]Zobiris[CR]!", italian=" Aah! Sento quei [CS:N]Sableye[CR]!", spanish="¡Aah! ¡Oigo venir a esos\n[CS:N]Sableye[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We have to keep running!", french=" Il faut qu'on continue à courir!", german=" Wir müssen weiterlaufen!", italian=" Dobbiamo continuare a correre!", spanish=" ¡Tenemos que seguir corriendo!"})
  -- message_Close
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(160), p.Y+(0), false, 2) end
  GAME:WaitFrames(5)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(160), p.Y+(0), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(160), p.Y+(0), false, 2) end
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(180) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
