-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D56P11A/n06a2301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[0] = 1 -- $SIDE06_ROOM[0] = 1 (ROM)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Oh![K] I can see some kind of light\nover there!", french=" Oh![K] J'aperçois une lueur, là-bas!", german="Oh![K] Ich sehe dort drüben so\neine Art Licht!", italian=" Oh![K] Vedo una luce laggiù!", spanish="¡Anda![K] Por ahí veo una especie\nde luz."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 424, 80, Direction.DownLeft, "NPC_SAANAITO")
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" I bet that's the exit!", french=" Je parie que c'est la sortie!", german=" Das ist sicherlich der Ausgang!", italian=" Scommetto che è l'uscita!", spanish=" ¡Seguro que es la salida!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 392, 112, Direction.DownLeft, "NPC_CHAAREMU")
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="We did it![K] We made it through\nthe cave!", french="Victoire![K] On a traversé\nla caverne!", german="Wir haben es geschafft![K]\nWir haben die Höhle durchquert!", italian="Ce l'abbiamo fatta![K] Siamo\narrivate in fondo alla cava!", spanish="¡Lo hemos conseguido![K] ¡Hemos\natravesado la cueva!"})
  -- message_Close
  -- back_SetGround(LEVEL_D56P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetAnimation(10) [anim idle native]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
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
  GROUND:MoveToPosition(npc_npc_chaaremu, 284, 212, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(hero, 296, 196, false, 2)
  GAME:WaitFrames(9)
  GROUND:MoveToPosition(npc_npc_saanaito, 284, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
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
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Wait...[K] I-isn't this...?", french=" Attendez...[K] Mais c'est...", german=" Wartet...[K] Ist das nicht...", italian=" Aspetta...[K] M-Ma questo non è...?", spanish=" Espera...[K] ¿No... No estamos...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Right...[K]where we started...", french=" Notre...[K] point de départ...", german="Ganz genau...[K]\nHier haben wir angefangen...", italian=" Il...[K] punto di partenza...", spanish=" Justo...[K] en el punto de partida..."})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "angry", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" We...[K] We were tricked!", french="On...[K] on est tombées dans\nle panneau!", german=" W-[K]wir wurden reingelegt!", italian=" Siamo...[K] Siamo state ingannate!", spanish=" Nos...[K] ¡Nos la han jugado!"})
  -- message_Close
  GROUND:EntTurn(npc_npc_chaaremu, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" This isn't the right entrance...", french=" Ce n'est pas le bon chemin...", german="Es war nicht der richtige\nEingang...", italian=" Questa non è l'entrata giusta...", spanish=" Esta no es la entrada correcta..."})
  -- message_Close
  GROUND:EntTurn(npc_npc_chaaremu, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="The entrance on the left must\nbe the right one!", french="Il fallait prendre le chemin\nde gauche!", german="Der linke Eingang muss der\nrichtige sein!", italian=" Deve essere quella a sinistra!", spanish="La buena debe de ser\nla de la izquierda."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But isn't it nice? ♪[K] Now we\nknow the way. [M:H8]", french="Voyez le bon côté des choses![K]\nNous ne pouvons plus nous tromper. [M:H8]", german="Aber ist das nicht toll? ♪[K]\nJetzt wissen wir den Weg! [M:H8]", italian="Ma non è meglio così? ♪[K]\nAlmeno adesso sappiamo quale strada\nprendere. [M:H8]", spanish="¿Pero no estáis contentas? ♪[K]\nAhora sabemos cuál es el camino bueno. [M:H8]"})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_saanaito, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Now we know![K] Let's try the path\nto the left this time.", french="Plus d'erreur possible![K] Prenons\nle chemin de gauche, cette fois-ci.", german="Jetzt wissen wir es![K] Lasst uns\ndiesmal den linken Eingang ausprobieren.", italian="È vero![K] Proviamo ad andare\na sinistra questa volta.", spanish="¡Ahora ya lo sabemos![K] Esta vez\nvamos a probar por el camino de la izquierda."})
  -- message_Close
  -- ResetOutputAttribute(2) [neutre/état moteur]
  -- ResetOutputAttribute(2) [neutre/état moteur]
  -- ResetOutputAttribute(2) [neutre/état moteur]
  SkySceneKit.cleanup_npcs()
end
