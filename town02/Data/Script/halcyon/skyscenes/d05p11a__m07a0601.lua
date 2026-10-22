-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D05P11A/m07a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D05P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:MoveToPosition(partner, 256, 204, false, 2)
  GROUND:MoveToPosition(hero, 296, 204, false, 2)
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Apple Woods.ogg", true) end)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's get some Perfect Apples\nfor sure this time.", french="Cette fois, nous rapporterons\ndes Pommes Parfaites!", german="Lass uns diesmal auf jeden Fall\nPerfekte Äpfel holen.", italian="Questa volta dobbiamo trovare\ndelle Mele Perfette.", spanish="Esta vez tenemos que conseguir\nesas Manzanas Perfectas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's make sure we come back\nwith Perfect Apples this time.", french="Cette fois, nous rapporterons\ndes Pommes Parfaites!", german="Lass uns diesmal auf jeden Fall\nPerfekte Äpfel finden.", italian="Questa volta dobbiamo trovare\ndelle Mele Perfette.", spanish="Esta vez tenemos que volver\ncon esas Manzanas Perfectas."})
  else
  SkySceneKit.say({english="Let's bring back some Perfect\nApples for sure this time.", french="Cette fois, nous rapporterons\ndes Pommes Parfaites!", german="Lass uns diesmal auf jeden Fall\nPerfekte Äpfel mitbringen.", italian="Questa volta dobbiamo trovare\ndelle Mele Perfette.", spanish="Esta vez tenemos que conseguir\nesas Manzanas Perfectas."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's give it our best,\n[hero]!", french="Faisons de notre mieux,\n[hero]!", german="Geben wir unser Bestes,\n[hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Hagámoslo lo mejor posible,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's keep doing our best,\n[hero]!", french="Faisons de notre mieux,\n[hero]!", german="Geben wir wie immer unser\nBestes, [hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Sigamos esforzándonos,\n[hero]!"})
  else
  SkySceneKit.say({english="Let's keep doing our best,\n[hero]!", french="Faisons de notre mieux,\n[hero]!", german="Geben wir wie immer unser\nBestes, [hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Sigamos esforzándonos,\n[hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(276, 124, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 276, 124, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(partner, 276, 124, false, 2)
  GROUND:MoveToPosition(hero, 276, 4, false, 2)
  GROUND:MoveToPosition(partner, 276, 4, false, 2)
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  pcall(function() GAME:MoveCamera(276, 192, 60, false) end) -- performer/caméra
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 280, 288, Direction.Up, "NPC_SUKATANKU")
  GROUND:MoveToPosition(npc_npc_sukatanku, 276, 180, false, 2)
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 272, 320, Direction.Up, "NPC_DOGAASU")
  GROUND:MoveToPosition(npc_npc_dogaasu, 272, 228, false, 2)
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 272, 352, Direction.Up, "NPC_ZUBATTO")
  GROUND:MoveToPosition(npc_npc_zubatto, 272, 236, false, 2)
  GROUND:MoveToPosition(npc_npc_dogaasu, 240, 196, false, 2)
  GROUND:MoveToPosition(npc_npc_zubatto, 312, 196, false, 2)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Up)
  GROUND:EntTurn(npc_npc_sukatanku, Direction.Up)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="They're persistent, I'll give\nthem that.", french="Faut reconnaître que ces\ndeux-là sont plutôt du genre buté.", german="Sie sind hartnäckig, das muss\nich ihnen lassen.", italian="Non gettano facilmente la\nspugna, questo è certo.", spanish="¡Hay que admitir que no\nse rinden con facilidad!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Chaw-haw-haw! You could say\nthe same about us.", french="Gnark gnark gnark! Mais on peut\ndire la même chose de nous.", german="Cha-ha-ha! Das kann man von\nuns auch sagen.", italian="Ahr-ahr-ahr! Si potrebbe dire lo\nstesso di noi.", spanish="¡Jua, jua, jua! Lo mismo\nse puede decir de nosotros."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="But so what? We're going\nafter them.", french=" Alors? Suivons-les!", german="Aber was soll es? Gehen wir\nhinterher.", italian="E allora? Noi gli staremo alle\ncostole.", spanish="¿Y qué más da? Vamos\na seguirles."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_sukatanku, 276, 124, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(npc_npc_dogaasu, 276, 124, false, 2)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_zubatto, 276, 124, false, 2)
  GROUND:MoveToPosition(npc_npc_sukatanku, 276, 4, false, 2)
  GROUND:MoveToPosition(npc_npc_dogaasu, 276, 4, false, 2)
  GROUND:MoveToPosition(npc_npc_zubatto, 276, 4, false, 2)
  GAME:FadeOut(false, 30)
  -- main_EnterDungeon(7, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
