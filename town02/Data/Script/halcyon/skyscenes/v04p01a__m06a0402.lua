-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V04P01A/m06a0402.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  -- back_SetGround(LEVEL_V04P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- ResetOutputAttribute(256) [neutre/état moteur]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 200, 320, Direction.Left, "NPC_DOGOOMU")
  -- ResetOutputAttribute(256) [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end) -- message_SetActor(ACTOR_NPC_DOGOOMU)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="You two go through this tunnel\nuntil you pop out at the sentry post.", french="Vous passez par le tunnel jusqu'à\nce que vous arriviez au poste de guet.", german="Ihr geht durch diesen Tunnel, bis\nihr beim Wachposten ankommt.", italian="Dovete attraversare questo\ntunnel finché non sbucate sotto il posto di\nguardia.", spanish="Tenéis que cruzar este túnel y\nsituaros bajo el puesto vigía."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 140, 316, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 140, 316, false, 2)
  GROUND:MoveToPosition(hero, 140, 372, false, 2)
  GROUND:MoveToPosition(partner, 140, 372, false, 2)
  GROUND:MoveToPosition(hero, 60, 372, false, 2)
  GROUND:MoveToPosition(partner, 60, 372, false, 2)
  GROUND:MoveToPosition(hero, 60, 228, false, 2)
  GROUND:MoveToPosition(partner, 60, 228, false, 2)
  -- Move2PositionMark 0 [cible sans placement SSA zone: mouvement non joué]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:MoveToPosition(hero, 160, 228, false, 2)
  GROUND:MoveToPosition(partner, 144, 228, false, 2)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="From the sentry post, inspect\nthe footprints of visitors, identify them, then\ninform me.", french="Du poste de guet, vous\nexaminez les empreintes des visiteurs, vous\nles identifiez puis vous m'informez.", german="Vom Wachposten aus inspiziert\nihr die Fußabdrücke der Besucher, identifiziert\nsie und informiert mich.", italian="Dal posto di guardia, ispezionate\nle zampe dei visitatori, identificatele e\npoi fatemi rapporto.", spanish="Desde el puesto vigía, tenéis\nque identificar a cada visitante por sus\nhuellas y luego informarme."})
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 24, 112, Direction.Right, "NPC_BIPPA")
  -- ResetOutputAttribute(256) [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-96), 80, false) end) -- MovePositionOffset performer/caméra
  GROUND:MoveToPosition(npc_npc_bippa, 152, 112, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  pcall(function() GAME:MoveCamera(156, 228, 60, false) end) -- performer/caméra
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
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
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="I will then decide if the\nPokémon is suspicious or not. If it passes\nmuster, I will open the gate.", french="Je déciderai alors si le Pokémon\nest suspect ou non. S'il ne l'est pas, j'ouvrirai\nla porte.", german="Ich entscheide dann, ob das\nPokémon verdächtig ist oder nicht. Wenn alles\nin Ordnung ist, öffne ich das Tor.", italian="Poi io decido se il Pokémon\nè sospetto o no. Se supera l'ispezione, apro la\nporta.", spanish="Entonces yo decido si se trata\nde un Pokémon sospechoso o no, y le abro\nla puerta."})
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  pcall(function() GAME:MoveCamera(156, 228, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_dogoomu, 252, 316, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 252, 148, false, 2)
  -- Destroy() [neutre/état moteur]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(60)
  GROUND:TeleportTo(npc_npc_bippa, 252, 148, Direction.Down)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_bippa, 252, 220, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_bippa, Direction.Right)
  GROUND:MoveToPosition(npc_npc_bippa, 304, 220, false, 2)
  -- Destroy() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="And I'll let that cleared Pokémon\ninto the guild.[K] That's the gist of it.", french="Et je laisserai ce Pokémon\nentrer dans la Guilde.[K] Voilà.", german="Dann lasse ich das Pokémon in\ndie Gilde.[K] Jetzt wisst ihr Bescheid.", italian="E faccio entrare quel Pokémon\nnella Gilda.[K] Questo è il succo della cosa.", spanish="Y así se decide quién puede\nentrar en el [CS:N]Pokégremio[CR] y quién no.[K]\nNo hay mucho más que explicar."})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
