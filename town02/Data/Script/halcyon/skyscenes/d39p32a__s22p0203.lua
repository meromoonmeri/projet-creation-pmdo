-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D39P32A/s22p0203.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D39P32A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 248, 264, Direction.Down, "NPC_KURESERIA")
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeIn(5)
  GAME:WaitFrames(30)
  local npc_npc_parukia = SkySceneKit.spawn_npc("palkia", 296, 240, Direction.DownLeft, "NPC_PARUKIA")
  GROUND:EntTurn(npc_npc_parukia, Direction.Left)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_parukia, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_parukia, Direction.DownLeft)
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_parukia, Direction.Left)
  GAME:WaitFrames(45)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_parukia, "shock", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  else
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" There's a second...[K] [CS:N]Cresselia[CR]?!", french=" Il y a une autre...[K] [CS:N]Cresselia[CR]?!", german="Da ist eine zweite...[K]\n[CS:N]Cresselia[CR]?!?", italian=" C'è una seconda...[K] [CS:N]Cresselia[CR]?!", spanish=" Hay otra...[K] ¡[CS:N]Cresselia[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" There's a second...[K] [CS:N]Cresselia[CR]?!", french=" Il y a une autre...[K] [CS:N]Cresselia[CR]?!", german="Da ist eine zweite...[K]\n[CS:N]Cresselia[CR]?!?", italian=" C'è una seconda...[K] [CS:N]Cresselia[CR]?!", spanish=" Hay otra...[K] ¡[CS:N]Cresselia[CR]!"})
  else
  SkySceneKit.say({english=" There's a second...[K] [CS:N]Cresselia[CR]?!", french=" Il y a une autre...[K] [CS:N]Cresselia[CR]?!", german="Da ist eine zweite...[K]\n[CS:N]Cresselia[CR]?!?", italian=" C'è una seconda...[K] [CS:N]Cresselia[CR]?!", spanish=" Hay otra...[K] ¡[CS:N]Cresselia[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8199) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect 351 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(20)
  GAME:FadeOut(true, 1) -- screen_WhiteOut
  SkySceneKit.cleanup_npcs()
end
