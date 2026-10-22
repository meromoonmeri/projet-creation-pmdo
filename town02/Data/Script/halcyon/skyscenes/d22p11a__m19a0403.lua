-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D22P11A/m19a0403.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_D22P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I thought so![K] This is similar to the\nsensation I had back then...)", french="(C'est bien ce que je pensais![K] J'ai ressenti\nla même chose quand...)", german="(Das dachte ich mir![K] Dieses Gefühl war ähnlich\nwie jenes, das ich damals hatte...)", italian="(Penso di sì![K] È simile alla sensazione che\navevo avvertito quando...)", spanish="(¡Era lo que pensaba![K] Esta sensación es como\nla que tuve entonces...)"})
  else
  SkySceneKit.say({english="(I thought so![K] This is similar to the\nsensation I had back then...)", french="(C'est bien ce que je pensais![K] J'ai ressenti\nla même chose quand...)", german="(Das dachte ich mir![K] Dieses Gefühl war ähnlich\nwie jenes, das ich damals hatte...)", italian="(Penso di sì![K] È simile alla sensazione che\navevo avvertito quando...)", spanish="(¡Era lo que pensaba![K] Esta sensación es como\nla que tuve entonces...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 280, 392, Direction.Up, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end) -- message_SetActor(ACTOR_NPC_JUPUTORU)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Hey! What are you doing?!", french="Eh! Qu'est-ce que vous\nfabriquez?!", german=" Hey! Was macht ihr da?", italian=" Ehi! Cosa state facendo?!", spanish=" ¡Eh! ¡¿Qué ocurre?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Hurry!", french=" Dépêchez-vous!", german=" Beeilung!", italian=" In fretta!", spanish=" ¡Hay que darse prisa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's hurry, [hero].", french=" Vite, [hero].", german=" Beeilen wir uns, [hero].", italian=" Veloce, [hero].", spanish=" Démonos prisa, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We have to hurry, [hero].", french=" Vite, [hero].", german="Wir müssen uns\nbeeilen, [hero].", italian="Dobbiamo fare in fretta,\n[hero].", spanish="Hay que darse prisa,\n[hero]."})
  else
  SkySceneKit.say({english=" Let's hurry, [hero].", french=" Vite, [hero].", german=" Beeilen wir uns, [hero].", italian=" Facciamo presto, [hero].", spanish=" Démonos prisa, [hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 276, 4, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 276, 4, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(90)
  pcall(function() GAME:MoveCamera(180, 236, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(45)
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 120, 240, Direction.UpRight, "NPC_YAMIRAMI")
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Wheh-heh-heh!", french=" Whé hé hé!", german=" Wähähäh!", italian=" Meh-eh-eh!", spanish=" ¡Je, je, je, je!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(64), p.Y+(0), false, 2) end
  GROUND:MoveToPosition(npc_npc_yamirami, 276, 4, false, 2)
  GAME:WaitFrames(20)
  -- main_EnterDungeon(32, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
