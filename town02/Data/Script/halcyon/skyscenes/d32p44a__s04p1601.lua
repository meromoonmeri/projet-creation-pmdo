-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D32P44A/s04p1601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(61, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  SkyProg.set(29, 66) -- $SCENARIO_MAIN = scn[29,66] (ROM)
  -- back_SetGround(LEVEL_D32P44A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_LOWER_BRINE_CAVE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  local npc_npc_mimiroppu = SkySceneKit.spawn_npc("lopunny", 232, 584, Direction.Up, "NPC_MIMIROPPU")
  GROUND:MoveToPosition(npc_npc_mimiroppu, 228, 404, false, 2)
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 208, 600, Direction.Up, "NPC_CHAAREMU")
  GROUND:MoveToPosition(npc_npc_chaaremu, 204, 412, false, 2)
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 256, 600, Direction.Up, "NPC_SAANAITO")
  GROUND:MoveToPosition(npc_npc_saanaito, 252, 412, false, 2)
  GROUND:MoveToPosition(hero, 300, 420, false, 2)
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 324, 436, false, 2) end end
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 276, 436, false, 2) end end
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 300, 452, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="This appears to be the\nlast chamber...", french="On dirait que c'est la dernière\nchambre...", german="Das hier scheint der letzte Raum\nzu sein...", italian="Sembra trattarsi dell'ultima\nstanza...", spanish=" Esta parece ser la última sala..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(300, 276, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(60)
  GROUND:MoveToPosition(npc_npc_mimiroppu, 228, 276, false, 2)
  GROUND:MoveToPosition(npc_npc_chaaremu, 204, 284, false, 2)
  GROUND:MoveToPosition(npc_npc_saanaito, 252, 284, false, 2)
  GROUND:MoveToPosition(hero, 300, 276, false, 2)
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 324, 292, false, 2) end end
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 276, 292, false, 2) end end
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 300, 308, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- GAP: se_Play(6925) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(30) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitSe
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" ........................", french=" ........................", german=" ........................", italian=" ........................", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="THOSE WHO SEEK THE TREASURES\nSLEEPING IN THE GROUND...", french="QUICONQUE CHERCHE LES TRESORS QUI\nSOMMEILLENT DANS LE VENTRE DE LA TERRE...", german="ALLE, DIE IHR SCHÄTZE IM BODEN\nSUCHT...", italian="O VOI CHE CERCATE I TESORI CHE\nRIPOSANO SOTTOTERRA...", spanish="AQUELLOS QUE BUSCAN LOS TESOROS\nQUE YACEN AQUÍ..."})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" SHOW ALL OF YOUR POWER!", french=" DOIT MONTRER TOUT SON POUVOIR!", german=" DEMONSTRIERT EURE GANZE KRAFT!", italian=" DIMOSTRATE TUTTA LA VOSTRA FORZA!", spanish=" ¡QUE DEMUESTREN SU PODER!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7952) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 15) -- screen_WhiteOut
  GAME:WaitFrames(90)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" The stone statues![K] They're alive!", french="Les statues de pierre![K] Elles\ns'animent!", german=" Die Steinstatuen![K] Sie leben!", italian="Le statue di pietra![K] Si stanno\nmuovendo!", spanish="Las estatuas de piedra...[K]\n¡Han cobrado vida!"})
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_mimiroppu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" We'll team up for this battle!", french="Faisons équipe pour cette\nbataille!", german="Wir bestehen diesen Kampf\nzusammen!", italian="Uniamo le forze per\nquesto scontro!", spanish="¡Hagamos frente común en\neste combate!"})
  -- message_Close
  GROUND:EntTurn(npc_npc_mimiroppu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(5136) — id SE NDS sans portage PMDO identifié
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
