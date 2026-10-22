-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D56P11A/n06a2701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[1] = 1 -- $SIDE06_ROOM[1] = 1 (ROM)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Oh![K] I can see a light coming\nfrom over there!", french=" Oh![K] Je vois une lumière, là-bas!", german="Oh![K]\nIch sehe ein Licht dort drüben!", italian=" Oh![K] Vedo una luce laggiù!", spanish=" ¡Anda![K] Por ahí veo una luz."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 392, 112, Direction.DownLeft, "NPC_CHAAREMU")
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" That's got to be the exit!", french=" C'est forcément la sortie!", german=" Das muss der Ausgang sein!", italian=" Deve essere l'uscita!", spanish=" ¡Tiene que ser la salida!"})
  -- message_Close
  -- back_SetGround(LEVEL_D56P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetAnimation(10) [anim idle native]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 424, 80, Direction.DownLeft, "NPC_SAANAITO")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_ILLUSION_STONE_CHAMBER non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_chaaremu, 276, 212, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(hero, 300, 188, false, 2)
  GAME:WaitFrames(9)
  GROUND:MoveToPosition(npc_npc_saanaito, 308, 188, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(9)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-3, 3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" What?[K] Th-this is...", french=" Quoi?[K] Mais c'est...", german=" Was?[K] D-das ist...", italian=" Come?[K] M-Ma questo è...", spanish=" ¿Qué?[K] Pe... pero si..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" The place...[K]where we started...", french="L'endroit...[K] d'où nous sommes\nparties...", german="Genau...[K] Der Ort,\nvon dem aus wir gestartet sind...", italian=" Il punto...[K] da cui siamo partite...", spanish="Estamos...[K] en el punto\nde partida..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-3, 3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Whaaaat?![K] Why?!", french=" Quoi?![K] Comment ça se fait?!", german=" Waaaaas?!?[K] Warum nur?!?", italian=" Cooosaaa?![K] Com'è possibile?!", spanish=" ¡¿Qué?![K] ¡¿Por qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_chaaremu, 220, 212, false, 2)
  GAME:WaitFrames(9)
  GROUND:MoveToPosition(hero, 252, 196, false, 2)
  GAME:WaitFrames(3)
  GROUND:MoveToPosition(npc_npc_saanaito, 284, 212, false, 2)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.UpLeft)
  GAME:WaitFrames(3)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_saanaito, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="When we took the left entrance\nwe ended up right back here...", french="Quand nous avons pris l'entrée\nde gauche, nous nous sommes retrouvées ici...", german="Wir nahmen den linken Eingang\nund sind hier gelandet...", italian="Quando abbiamo preso l'entrata\na sinistra, siamo finite di nuovo qui...", spanish="Al tomar la entrada de la\nizquierda acabamos aquí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chaaremu, Direction.UpRight)
  GAME:WaitFrames(3)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_saanaito, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="So when we took the right\nentrance, I thought we'd progress...", french="Alors je pensais que l'entrée\nde droite nous ferait progresser...", german="Als wir den rechten Eingang\nbetraten, waren wir also sicher, dass wir\nweiterkommen würden...", italian="Quindi scegliendo quella a destra\nsaremmo dovute andare avanti...", spanish="Así que pensé que, al tomar el\ncamino de la derecha, avanzaríamos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(9)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" What in the world is going on?!", french="Mais enfin, qu'est-ce qui se\npasse, ici?!", german=" Was geht hier vor sich?!?", italian=" Ma cosa sta succedendo?!", spanish=" ¡¿Qué narices está pasando?!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="How...[K] How do we\nmove forward?", french="Comment...[K] comment on fait\npour avancer?", german="Wie...[K] Wie wollen wir jetzt\nvorankommen?", italian="Come...[K] Come facciamo\na proseguire?", spanish="¿Cómo...?[K] ¿Cómo vamos a\navanzar?"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
