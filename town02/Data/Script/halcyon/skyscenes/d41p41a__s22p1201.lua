-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D41P41A/s22p1201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(8198) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  -- back_SetGround(LEVEL_D41P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(45)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  local npc_npc_bosugodora = SkySceneKit.spawn_npc("aggron", 344, 216, Direction.Left, "NPC_BOSUGODORA")
  pcall(function() GROUND:CharSetEmote(npc_npc_bosugodora, "exclaim", 1) end)
  local npc_npc_aabokku = SkySceneKit.spawn_npc("arbok", 240, 184, Direction.DownRight, "NPC_AABOKKU")
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, "exclaim", 1) end)
  local npc_npc_dosaidon = SkySceneKit.spawn_npc("rhyperior", 216, 216, Direction.Right, "NPC_DOSAIDON")
  pcall(function() GROUND:CharSetEmote(npc_npc_dosaidon, "exclaim", 1) end)
  local npc_npc_magukarugo = SkySceneKit.spawn_npc("magcargo", 240, 256, Direction.UpRight, "NPC_MAGUKARUGO")
  pcall(function() GROUND:CharSetEmote(npc_npc_magukarugo, "exclaim", 1) end)
  local npc_npc_muumaaji = SkySceneKit.spawn_npc("mismagius", 320, 256, Direction.UpLeft, "NPC_MUUMAAJI")
  pcall(function() GROUND:CharSetEmote(npc_npc_muumaaji, "exclaim", 1) end)
  local npc_npc_buubaan = SkySceneKit.spawn_npc("magmortar", 320, 184, Direction.DownLeft, "NPC_BUUBAAN")
  pcall(function() GROUND:CharSetEmote(npc_npc_buubaan, "exclaim", 1) end)
  local npc_npc_daakurai = SkySceneKit.spawn_npc("darkrai", 280, 168, Direction.Down, "NPC_DAAKURAI")
  pcall(function() GROUND:CharSetEmote(npc_npc_daakurai, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" That blasted [CS:N]Cresselia[CR]!", french=" Maudite [CS:N]Cresselia[CR]!", german=" Das hat [CS:N]Cresselia[CR] umgehauen!", italian=" Quella maledetta [CS:N]Cresselia[CR]!", spanish=" ¡Esa dichosa [CS:N]Cresselia[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="She fled with [hero] and\nthat sidekick!", french="Elle s'est enfuie avec\n[hero] et son faire-valoir!", german="Sie ist mit [hero] und\ndiesem Handlanger geflohen!", italian="È scappata con [hero] e\nquell'altro Pokémon!", spanish="¡Ha huido con [hero] y su\nacompañante!"})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="...So be it.[K] They will eventually\nhave to return here.", french="... Soit.[K] Ces trois-là finiront\nbien par revenir.", german="Sei es drum.[K] Irgendwann werden\nsie hierher zurückkehren müssen.", italian="E sia.[K] Prima o poi\ndovranno tornare qui.", spanish="Sea.[K] Tendrán que volver aquí,\ntarde o temprano."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="Because they will try to\ndefeat me.", french=" Pour essayer de me vaincre.", german="Denn sie werden versuchen,\nmich zu besiegen.", italian=" Per cercare di sconfiggermi.", spanish=" Porque querrán derrotarme."})
  -- message_Close
  -- GAP: se_Play(6925) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end) -- message_SetActor(ACTOR_NPC_DAAKURAI)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="However...[K] That will end in their\nelimination, not mine.", french="Mais...[K] ce sont ces trois-là\nqui mordront la poussière, et pas moi.", german="Das Ergebnis allerdings...[K] Das\nErgebnis wird darin bestehen, dass ich sie alle\naus dem Weg räumen werde!", italian="Tuttavia...[K] Quando torneranno\nsarò io a eliminarli, non viceversa.", spanish=" Pero...[K] no seré yo el derrotado."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" All I need to do is wait.", french="Patience, mon heure de gloire\nviendra.", german="Alles, was ich tun muss, ist\nwarten.", italian=" Devo solo aspettare.", spanish=" Solo tengo que esperar."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="I look forward to their\nnext arrival.", french=" J'ai hâte de les revoir.", german="Ich freue mich auf ihr nächstes\nEintreffen.", italian=" Non vedo l'ora che tornino.", spanish=" Estaré esperando su llegada."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
