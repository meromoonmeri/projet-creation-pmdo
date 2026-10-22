-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/n01a0702.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_T01P02A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_kakureon1 = SkySceneKit.spawn_npc("kecleon", 328, 168, Direction.Down, "NPC_KAKUREON1")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_kakureon2 = SkySceneKit.spawn_npc("kecleon", 352, 168, Direction.Down, "NPC_KAKUREON2")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GAME:MoveCamera(424, 196, 1, false) end) -- SetPositionMark performer/caméra
  local npc_npc_yukikaburi = SkySceneKit.spawn_npc("snover", 544, 216, Direction.Left, "NPC_YUKIKABURI")
  GROUND:TeleportTo(npc_npc_yukikaburi, 424, 212, Direction.Down)
  GROUND:TeleportTo(hero, 424, 192, Direction.Down)
  GROUND:EntTurn(npc_npc_kakureon1, Direction.DownRight)
  GROUND:EntTurn(npc_npc_kakureon2, Direction.DownRight)
  GROUND:EntTurn(npc_npc_yukikaburi, Direction.Up)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:FadeOut(false, 0) -- screen_FlushOut
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" Excuse me! [K]H-hold this!", french=" Excuse-moi! [K]T-tiens ça!", german=" Entschuldige![K] N-nimm das bitte!", italian=" Scusami![K] P-Prendi questo!", spanish=" ¡Disculpa![K] ¡Sujétame esto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="[CN][CS:Y]Bidoof[CR] received something\n[CN]from the strange Pokémon.", french="[CN]Un étrange Pokémon\n[CN]donne quelque chose à [CS:Y]Keunotor[CR].", german="[CN][CS:Y]Bidiza[CR] erhielt etwas von\n[CN]dem sonderbaren Pokémon.", italian="[CN][CS:Y]Bidoof[CR] riceve qualcosa\n[CN]da uno strano Pokémon.", spanish="[CN][CS:Y]Bidoof[CR] ha recibido algo\n[CN]del Pokémon desconocido."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Huh...[K] Golly, what is this?", french=" Hein...[K] Sapristi, c'est quoi, ça?", german="Nanu![K]\nDonnerwetter, was ist los?", italian=" Uh...[K] Ohibò, cos'è questo?", spanish=" ¿Eh?...[K] Caramba, ¿qué es esto?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yukikaburi, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(-200), p.Y+(0), false, 2) end
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_kakureon2, Direction.Left)
  GROUND:EntTurn(npc_npc_kakureon1, Direction.Left)
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hey! [K]You...[K]wait!", french=" Hé! [K]Toi...[K] attends un peu!", german=" Hey! [K]Du...[K] Warte!", italian=" Ehi![K] Tu...[K] Aspetta!", spanish=" ¡Eh![K] ¡Tú!...[K] ¡Espera!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:FadeOut(false,  90)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
