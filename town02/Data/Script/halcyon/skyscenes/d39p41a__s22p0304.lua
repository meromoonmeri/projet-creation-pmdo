-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D39P41A/s22p0304.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D39P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  local npc_npc_daakurai = SkySceneKit.spawn_npc("darkrai", 376, 304, Direction.Down, "NPC_DAAKURAI")
  -- SetAnimation(43) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="You are more than welcome to\ntry and stop me.", french="Tentez donc de m'arrêter, si\nvous en avez le pouvoir.", german="Ihr seid herzlich dazu\neingeladen zu versuchen, mich aufzuhalten.", italian="Potete benissimo provare\na fermarmi.", spanish="Ahora intentad detenerme si\npodéis."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" Come to me in the [CS:P]Dark Crater[CR].", french="Rendez-vous au [CS:P]Cratère\nObscur[CR].", german="Kommt zu mir in den\n[CS:P]Dunkelkrater[CR].", italian=" Venite al [CS:P]Cratere Oscuro[CR].", spanish="Venid a buscarme. Estaré\nen el [CS:P]Cráter Oscuro[CR]."})
  -- message_Close
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:WaitFrames(30)
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 376, 352, Direction.Up, "NPC_KURESERIA")
  SkySceneKit.offset_pos(npc_npc_kureseria, 0, -32)
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Up)
  local npc_npc_parukia = SkySceneKit.spawn_npc("palkia", 440, 312, Direction.Left, "NPC_PARUKIA")
  GROUND:EntTurn(npc_npc_parukia, Direction.Right)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end) -- message_SetActor(ACTOR_NPC_DAAKURAI)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="You two...[K] I shall be waiting in\nthe [CS:P]Dark Crater[CR].", french="Vous deux...[K] je vous attendrai\nau [CS:P]Cratère Obscur[CR].", german="Ihr zwei.[K] Ich werde im\n[CS:P]Dunkelkrater[CR] warten.", italian="Voi due...[K] Vi aspetto al [CS:P]Cratere[CR]\n[CS:P]Oscuro[CR].", spanish="Pareja...[K] Os estaré esperando en\nel [CS:P]Cráter Oscuro[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[K][CS:P]Dark[CR]...[K] [CS:P]Crater[CR]...", french=" ...[K] Le [CS:P]Cratère[CR]...[K] [CS:P]Obscur[CR]...", german=" ...[K][CS:P]Dunkelkrater[CR]...", italian=" ...[K] [CS:P]Cratere[CR]...[K] [CS:P]Oscuro[CR]...", spanish=" El...[K] [CS:P]Cráter[CR]...[K] [CS:P]Oscuro[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[K][CS:P]Dark[CR]...[K] [CS:P]Crater[CR]...", french=" ...[K] Le [CS:P]Cratère[CR]...[K] [CS:P]Obscur[CR]...", german=" ...[K][CS:P]Dunkelkrater[CR]...", italian=" ...[K] [CS:P]Cratere[CR]...[K] [CS:P]Oscuro[CR]...", spanish=" El...[K] [CS:P]Cráter[CR]...[K] [CS:P]Oscuro[CR]..."})
  else
  SkySceneKit.say({english=" ...[K][CS:P]Dark[CR]...[K] [CS:P]Crater[CR]...", french=" ...[K] Le [CS:P]Cratère[CR]...[K] [CS:P]Obscur[CR]...", german=" ...[K][CS:P]Dunkelkrater[CR]...", italian=" ...[K] [CS:P]Cratere[CR]...[K] [CS:P]Oscuro[CR]...", spanish=" El...[K] [CS:P]Cráter[CR]...[K] [CS:P]Oscuro[CR]..."})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
