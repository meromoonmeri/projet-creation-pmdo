-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P17P02A/n03a0702.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]I've had so much fun since Master\n[CN]took me on as an apprentice. ♪", french="[CN]Je m'amusais tellement depuis que le Maître\n[CN]m'avait pris comme apprenti. ♪", german="[CN]Ich hatte so viel Spaß, nachdem mein\n[CN]Meister mich als seinen Lehrling\n[CN]aufgenommen hatte. ♪", italian="[CN]Da quando il maestro mi ha accettato come\n[CN]apprendista, mi diverto un sacco. ♪", spanish="[CN]No me he divertido tanto desde que el maestro\n[CN]me aceptó como aprendiz. ♪"})
  -- message_Close
  -- back_SetGround(LEVEL_P17P02A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_A_FUN_EXPLORATION non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" OK, I'm off. ♪", french=" Bon, je sors. ♪", german=" Okay, ich gehe dann mal. ♪", italian=" Bene, io vado. ♪", spanish=" Bueno, hasta luego. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  local npc_npc_pukurin_papa = SkySceneKit.spawn_npc("wigglytuff", 288, 184, Direction.DownLeft, "NPC_PUKURIN_PAPA")
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(5)
  local npc_npc_pukurin_mama = SkySceneKit.spawn_npc("wigglytuff", 256, 208, Direction.UpRight, "NPC_PUKURIN_MAMA")
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_papa, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english=" See you!", french=" A plus tard!", german=" Bis dann!", italian=" A presto!", spanish=" ¡Hasta luego!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_papa, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_mama, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" Take care!", french=" Fais attention!", german=" Pass auf dich auf!", italian=" Fai attenzione!", spanish=" ¡Ve con cuidado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_mama, nil, 0) end) -- EFFECT_NONE
  GROUND:MoveToPosition(hero, 252, 268, false, 2)
  GAME:WaitFrames(25)
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.Down)
  GAME:WaitFrames(6)
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(48), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- back_SetBackEffect(4) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english="[CN]I would head off to Master's house soon\n[CN]after I got up every morning...", french="[CN]Tous les matins, juste après le réveil,\n[CN]je me rendais à la maison de mon Maître...", german="[CN]Ich machte mich jeden Morgen direkt nach dem\n[CN]Aufstehen auf zum Haus meines Meisters...", italian="[CN]Ogni mattina, appena mi alzavo,\n[CN]andavo a casa del maestro...", spanish="[CN]Me dirigía a casa del maestro cada mañana,\n[CN]en cuanto me levantaba..."})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
