-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D54P31A/n06a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=45, sub=3} -- $SCENARIO_SIDE = scn[45,3] (ROM)
  -- back_SetGround(LEVEL_D54P31A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- bgm2_PlayFadeIn(BGM_HEAVY_WIND4) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 32, 256, Direction.Right, "NPC_CHAAREMU")
  GROUND:MoveToPosition(npc_npc_chaaremu, 208, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="I think we've reached the other\nside of the jungle...", french="Je crois qu'on est enfin venues\nà bout de cette jungle...", german="Sieht so aus, als hätten wir die\nandere Seite des Dschungels erreicht.", italian="Dovremmo essere dall'altra\nparte della giungla...", spanish="Creo que ya hemos llegado\nal otro extremo de la selva..."})
  -- message_Close
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 40, 224, Direction.Right, "NPC_SAANAITO")
  GROUND:MoveToPosition(npc_npc_saanaito, 208, 252, false, 2)
  GAME:WaitFrames(36)
  GROUND:MoveToPosition(hero, 176, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, hero, 4) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" I'm pretty sure of it.", french=" C'est même sûr.", german=" Da bin ich mir ziemlich sicher.", italian=" Ne sono abbastanza sicura.", spanish=" Sí, no me cabe duda."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Seems like we're out of\n[CS:P]Southern Jungle[CR].", french="On est sorties de la\n[CS:P]Jungle Méridionale[CR].", german="Anscheinend haben wir den\n[CS:P]Süddschungel[CR] verlassen.", italian="A quanto pare siamo fuori\ndalla [CS:P]Giungla Meridionale[CR].", spanish="Parece que hemos salido de la\n[CS:P]Selva Meridional[CR]."})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="So...[K] [CS:P]Boulder Quarry[CR] is just\nahead, right?", french="Donc...[K] la [CS:P]Carrière Rocher[CR]\ndevrait se trouver droit devant, n'est-ce pas?", german="Also...[K] müsste der [CS:P]Geröllbruch[CR]\ndirekt vor uns liegen?", italian="Quindi...[K] la [CS:P]Cava Rocciosa[CR]\nè poco più avanti, giusto?", spanish="Entonces...[K] el [CS:P]Roquedal[CR] está\njusto delante, ¿no?"})
  -- message_Close
  -- GAP: se_Play(10245) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="[CN]Guuuuuuuu!", french="[CN]Guuuuuuuu!", german="[CN]Guuuuuuuu!", italian="[CN]Guuuuuuuu!", spanish="[CN]¡Guuuuuuuu!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(4)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Right)
  GAME:WaitFrames(3)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Huh?[K] I think I heard some kind\nof strange noise coming from over there...", french="Hein?[K] J'ai entendu un bruit\nbizarre, par là-bas...", german="Nanu![K] Mir ist, als hätte ich\ngerade ein sonderbares Geräusch von dort\ndrüben vernommen...", italian="Uh?[K] Mi pare di aver sentito\nuno strano rumore provenire da laggiù...", spanish="¿Eh?[K] Creo que he oído un\nruido rarísimo que venía de ahí..."})
  -- message_Close
  -- GAP: se_Play(10245) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="[CN]Guuuuuuuu!", french="[CN]Guuuuuuuu!", german="[CN]Guuuuuuuu!", italian="[CN]Guuuuuuuu!", spanish="[CN]¡Guuuuuuuu!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, hero, 4) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I heard it again.", french=" Moi aussi, je viens de l'entendre.", german=" Da war es wieder.", italian=" Eccolo di nuovo.", spanish=" Lo he vuelto a oír."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Let's go check it out.", french=" Allons voir.", german=" Lasst uns mal nachsehen.", italian=" Andiamo a controllare.", spanish=" Vamos a investigar."})
  -- message_Close
  pcall(function() GAME:MoveCamera(360, 240, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_saanaito, 472, 252, false, 2)
  GAME:WaitFrames(18)
  GROUND:MoveToPosition(npc_npc_chaaremu, 472, 220, false, 2)
  GAME:WaitFrames(2)
  GROUND:MoveToPosition(hero, 456, 236, false, 2)
  GAME:WaitFrames(27)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
