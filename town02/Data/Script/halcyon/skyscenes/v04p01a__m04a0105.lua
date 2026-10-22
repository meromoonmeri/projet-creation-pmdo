-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V04P01A/m04a0105.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  -- back_SetGround(LEVEL_V04P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 184, 320, Direction.Left, "NPC_DOGOOMU")
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 168, 320, Direction.Down, "NPC_DIGUDA")
  -- ResetHitAttribute(31) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  pcall(function() GAME:MoveCamera(156, 324, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end) -- message_SetActor(ACTOR_NPC_DOGOOMU)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="[CS:N]Diglett[CR] burrows through it and\npops out underneath the sentry post.", french="[CS:N]Taupiqueur[CR] se fraie un chemin\ndans le tunnel et arrive sous le poste de guet.", german="[CS:N]Digda[CR] wühlt sich durch bis zum\nWachposten unter dem Gitter.", italian="[CS:N]Diglett[CR] ci scava attraverso e\nspunta sotto il posto di guardia.", spanish="[CS:N]Diglett[CR] lo cruza para llegar justo\ndebajo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_diguda, 140, 316, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Down)
  GROUND:MoveToPosition(npc_npc_diguda, 140, 372, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_diguda, 60, 372, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_diguda, 60, 228, false, 2)
  -- Move2PositionMark 0 [cible sans placement SSA zone: mouvement non joué]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:MoveToPosition(npc_npc_diguda, 156, 228, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_diguda, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 24, 112, Direction.Right, "NPC_BIPPA")
  -- ResetOutputAttribute(256) [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="From the sentry post, [CS:N]Diglett[CR]\ninspects the footprints of visitors, identifies\nthem, then informs me.", french="Depuis le poste de guet,\n[CS:N]Taupiqueur[CR] inspecte les empreintes des\nvisiteurs, les identifie et m'informe.", german="Vom Wachposten aus inspiziert\n[CS:N]Digda[CR] die Fußabdrücke der Besucher,\nidentifiziert sie und informiert mich.", italian="Dal posto di guardia, [CS:N]Diglett[CR]\nispeziona le zampe dei visitatori, le\nidentifica e poi mi fa rapporto.", spanish="Desde ahí, [CS:N]Diglett[CR] inspecciona\nlas huellas de los visitantes y luego me\ninforma."})
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-96), 64, false) end) -- MovePositionOffset performer/caméra
  GROUND:MoveToPosition(npc_npc_bippa, 152, 112, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() GAME:MoveCamera(156, 228, 60, false) end) -- performer/caméra
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_diguda, Direction.Left)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(156, 324, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Left)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Right)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Then I decide if the Pokémon\nis suspicious or not and open the gate if\nhe passes muster.", french="Puis je décide si le Pokémon est\nsuspect ou pas et j'ouvre la porte si le visiteur\na rien de louche.", german="Ich entscheide dann, ob das\nPokémon verdächtig ist oder nicht. Wenn alles\nin Ordnung ist, öffne ich das Tor.", italian="Poi io decido se il Pokémon\nè sospetto o no. Se supera l'ispezione,\napro la porta.", spanish="Entonces yo decido si se trata\nde un Pokémon sospechoso o no, y le abro\nla puerta."})
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_diguda, Direction.Down)
  pcall(function() GAME:MoveCamera(156, 228, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_dogoomu, 252, 316, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 252, 152, false, 2)
  -- Destroy() [neutre/état moteur]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  GROUND:TeleportTo(npc_npc_bippa, 252, 152, Direction.Down)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_bippa, 252, 220, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_bippa, Direction.Right)
  GROUND:MoveToPosition(npc_npc_bippa, 304, 220, false, 2)
  -- Destroy() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="So we serve as the guild's\ngatekeepers. That's the gist of it.", french="En résumé, on est les gardiens\nde la Guilde.", german="Alles in allem dienen wir also\nals die Torwächter der Gilde.", italian="Quindi siamo i guardiani della\nGilda. Questo è quanto.", spanish="Y en eso consiste la guardia.\nNo hay mucho más que explicar."})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
