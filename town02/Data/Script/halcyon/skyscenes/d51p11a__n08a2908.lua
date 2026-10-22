-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D51P11A/n08a2908.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_TEMPORAL_PINNACLE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_D51P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n8 = SkySceneKit.spawn_npc("dusknoir", 256, 152, Direction.Down, "NPC_YONOWAARU_N8")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetOutputAttribute(128) [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: se_Play(10502) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(4) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(30)
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- supervision_Acting(5) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(30)
  -- ResetOutputAttribute(128) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P24P01A1_420) [routine d'objet NDS non simulée - documenté]
  -- supervision_RemoveActing(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P24P01A1_421) [routine d'objet NDS non simulée - documenté]
  -- supervision_RemoveActing(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(20)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" This is...?", french=" Serait-ce...?", german=" Ist das...", italian=" Questa è...?", spanish=" ¿Esto es...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru_n8, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru_n8, 4) end)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" [CS:P]Frozen Island[CR].", french=" L'[CS:P]Ile de Glace[CR].", german=" Die [CS:P]Frostinsel[CR].", italian=" L'[CS:P]Isola Glaciale[CR].", spanish=" La [CS:P]Isla Helada[CR]."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Before time stopped, it was\ncalled [CS:P]Blizzard Island[CR]...", french="Avant que le temps ne cesse de\ns'écouler, on l'appelait l'[CS:P]Ile Blizzard[CR]...", german="Vor dem Stillstand der Zeit\nwurde sie [CS:P]Blizzardinsel[CR] genannt.", italian="Prima che il tempo si fermasse,\nera chiamata [CS:P]Isola Tormenta[CR]...", spanish="Antes de que el tiempo se\ndetuviera, se la conocía como [CS:P]Isla Ventisca[CR]..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Now that the world has plunged\ninto darkness...[K]it's much more severe...", french="A présent que le monde est\nplongé dans l'ombre...[K] cet endroit est\nencore plus hostile...", german="Jetzt, wo die Welt in Dunkelheit\ngetaucht ist,[K] ist es noch schlimmer...", italian="Ora che il mondo è piombato\nnell'oscurità...[K] questo luogo è diventato\nancora più ostile...", spanish="Ahora que el mundo está sumido\nen las tinieblas...[K] todo está mucho peor."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" It's become closed off.", french="L'île est complètement isolée,\nprise par les glaces.", german=" Sie wurde abgesperrt.", italian=" Ed estremamente desolato.", spanish="Ahora es casi imposible\nacceder a ella."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" So...[K]where do we go, then?", french=" Mais alors...[K] où allons-nous?", german=" Nun...[K] Wohin sollen wir also?", italian=" Allora...[K] Dove andiamo adesso?", spanish=" Bueno...[K] ¿Y ahora adónde vamos?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(3) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_yukiwarashi = SkySceneKit.spawn_npc("snorunt", 432, 152, Direction.Left, "NPC_YUKIWARASHI")
  GROUND:MoveToPosition(npc_npc_yukiwarashi, 360, 160, false, 2)
  local npc_npc_yukiwarashi2 = SkySceneKit.spawn_npc("snorunt", 456, 136, Direction.Left, "NPC_YUKIWARASHI2")
  GROUND:MoveToPosition(npc_npc_yukiwarashi2, 376, 148, false, 2)
  local npc_npc_yukiwarashi3 = SkySceneKit.spawn_npc("snorunt", 448, 168, Direction.Left, "NPC_YUKIWARASHI3")
  GROUND:MoveToPosition(npc_npc_yukiwarashi3, 388, 172, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi3, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Right)
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" Gii!", french=" Gniiii!", german=" Gii!", italian=" Giii!", spanish=" ¡Gui!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-3, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" What was that?", french=" Qu'est-ce que c'est que ça?", german=" Was war das denn?", italian=" E questi chi sono?", spanish=" ¿Qué ha sido eso?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="It's the [CS:N]Snorunt[CR].[K]\nI believe they live around here.", french="Ce sont les [CS:N]Stalgamin[CR].[K]\nJ'ai ouï dire qu'ils vivent dans cette contrée.", german="Das sind die [CS:N]Schneppke[CR].[K]\nIch glaube, sie leben in dieser Region.", italian="Sono [CS:N]Snorunt[CR].[K] Credo che vivano\nda queste parti.", spanish="Son [CS:N]Snorunt[CR].[K]\nCreo que viven por aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi, "sweating", 1) end)
  GAME:WaitFrames(7)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi2, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi3, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" Gigii...", french=" Gniiii gniii...", german=" Gigii...", italian=" Gigiii...", spanish=" Guiguí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yukiwarashi2.Position; GROUND:MoveToPosition(npc_npc_yukiwarashi2, p.X+(16), p.Y+(0), false, 2) end
  do local p=npc_npc_yukiwarashi.Position; GROUND:MoveToPosition(npc_npc_yukiwarashi, p.X+(16), p.Y+(0), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(8), p.Y+(0), false, 2) end
  do local p=npc_npc_yukiwarashi3.Position; GROUND:MoveToPosition(npc_npc_yukiwarashi3, p.X+(16), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi2, "exclaim", 1) end)
  -- message_FacePositionOffset(-1, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" H-hey![K] Wait up a moment!", french=" Hé![K] Attendez!", german="H-hey![K]\nWartet mal einen Moment!", italian=" E-Ehi![K] Aspettate un attimo!", spanish=" ¡Eh![K] ¡Esperad un momento!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yukiwarashi, Direction.Left)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_yukiwarashi2, Direction.Left)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_yukiwarashi3, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" Gigii?", french=" Gnigni?", german=" Gigii?", italian=" Gigiii?", spanish=" ¿Guiguí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(324, 156, 60, false) end) -- performer/caméra
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(16), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- message_FacePositionOffset(1, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I have something I want to ask.", french=" J'ai une question à vous poser.", german="Es gibt da etwas,\nwas ich euch fragen möchte.", italian=" Voglio chiedervi una cosa.", spanish=" Tengo que preguntaros algo."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I think you would have noticed\nif anyone other than us came through\nhere recently...", french="Si quelqu'un était passé par ici\navant nous, vous l'auriez remarqué, non?", german="An euch kommt doch bestimmt\nniemand ungesehen vorbei...", italian="Dovreste aver fatto caso se\nrecentemente è arrivato qualcun altro\noltre a noi due...", spanish="Estoy seguro de que sabréis si\nalguien ha pasado por aquí recientemente..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Did you see anyone?", french="Alors, avez-vous vu qui\nque ce soit?", german=" War da außer uns noch jemand?", italian=" Avete notato niente?", spanish=" ¿Habéis visto a alguien?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi, "question", 1) end)
  GAME:WaitFrames(7)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi2, "question", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi3, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, -5) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" Gigii?[K] Gigigii?", french=" Gnignii?[K] Gnignignii?", german=" Gigii?[K] Gigigii?", italian=" Gigiii?[K] Gigigiii?", spanish=" ¿Guiguí?[K] ¿Guiguiguí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" Gigigii?", french=" Gnignignii?", german=" Gigigii?", italian=" Gigigiii?", spanish=" ¿Guiguiguí?"})
  GROUND:EntTurn(npc_npc_yukiwarashi, Direction.Right)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_yukiwarashi2, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_yukiwarashi3, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, -5) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" Gii.", french=" Gnii.", german=" Gii.", italian=" Giii.", spanish=" Gui."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" Gigii.", french=" Gnignii.", german=" Gigii.", italian=" Gigiii.", spanish=" Guiguí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="If you've noticed anyone,\nanything at all, please tell me!", french=" S'il vous plaît, dites-le-moi!", german="Wenn ihr jemanden gesehen habt\noder euch irgendetwas anderes aufgefallen ist,\nsagt es mir bitte!", italian="Se avete notizie, qualsiasi\nesse siano, ditemelo, vi prego!", spanish="Si habéis visto algo, lo que\nsea, ¡tenéis que contármelo!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" It's really important!", french="C'est de la plus haute\nimportance!", german=" Es ist wirklich wichtig!", italian=" È molto importante!", spanish=" ¡Es muy importante!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, -5) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" Gii!", french=" Gnii!", german=" Gii!", italian=" Giii!", spanish=" ¡Gui!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi2, "exclaim", 1) end)
  GAME:WaitFrames(7)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi3, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" Gii! Gii!", french=" Gnii! Gnii!", german=" Gii! Gii!", italian=" Giii! Giii!", spanish=" ¡Gui! ¡Gui!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(3)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(3)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(24), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(3, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Did you understand any of that?", french=" Comprenez-vous ce que je dis?", german=" Hast du irgendetwas verstanden?", italian="Avete capito quello che vi ho\ndetto?", spanish=" ¿Tú has entendido algo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yukiwarashi, Direction.Left)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_yukiwarashi2, Direction.Left)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_yukiwarashi3, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" Giiii...", french=" Gniiii...", german=" Giiii...", italian=" Giiii...", spanish=" Gui..."})
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" Giiii giiii...", french=" Gniiii gniiii...", german=" Giiii giiii...", italian=" Giiii giiii...", spanish=" Gui, gui..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi, "angry", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, -5) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" Giiiiii!!", french=" Gniiiiii!!", german=" Giiiiii!!!", italian=" Giiiiii!!", spanish=" ¡Guiiiiii!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(10503) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(6) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D51P11A1_419) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  -- MovePositionOffset<object OBJECT_D51P11A1_419> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- SetAnimation(11) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-32), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-8), g.ViewCenter.Y+(0), 3, false) end) -- MovePositionOffset performer/caméra
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(29) [anim idle native]
  GROUND:EntTurn(hero, Direction.Left)
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" GWAH!", french=" ARGH!", german=" GWAH!", italian=" GUAH!", spanish=" ¡¡Aaah!!"})
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D51P11A1_419) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi2, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi3, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(3)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" GWAH-HA-HA-HA-HA-HA!", french=" HA HA HA HA HA HA!", german=" GWAHAHAHAHAHA!", italian=" GUAH-AH-AH-AH-AH-AH!", spanish=" ¡Jua, jua, jua!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi2, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi3, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(15)
  do local p=npc_npc_yukiwarashi2.Position; GROUND:MoveToPosition(npc_npc_yukiwarashi2, p.X+(88), p.Y+(0), false, 2) end
  GAME:WaitFrames(10)
  do local p=npc_npc_yukiwarashi.Position; GROUND:MoveToPosition(npc_npc_yukiwarashi, p.X+(88), p.Y+(0), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_yukiwarashi3.Position; GROUND:MoveToPosition(npc_npc_yukiwarashi3, p.X+(88), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(60)
  -- SetAnimation(31) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(hero, "angry", 1) end)
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Bah...[K] Argh! They're no help!", french=" Bah...[K] Ils ne sont d'aucune aide!", german=" Bah...[K] Argh! Sie sind keine Hilfe!", italian="Bah...[K] Argh! Non sono di nessun\naiuto!", spanish=" Uf...[K] Ay... ¡No iban a ayudarme!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" They're just teasing me!", french=" Ils se paient ma tête, c'est tout!", german="Sie machen sich\nüber mich lustig!", italian=" Mi stanno solo prendendo in giro!", spanish=" ¡Solo querían burlarse de mí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  -- GAP: BGM BGM_DARK_ICE_MOUNTAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(npc_npc_yonowaaru_n8, 276, 148, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="The attitudes of the Pokémon\nliving in this world of darkness are a\nbit warped...", french="L'ombre perpétuelle affecte\nle comportement des Pokémon de ce monde...", german="Die Umgangsformen der in dieser\ndunklen Welt lebenden Pokémon sind wohl ein\nwenig durcheinander...", italian="Il comportamento dei Pokémon\ndi questo mondo è distorto dall'oscurità in\ncui vivono...", spanish="Este mundo de tinieblas ha hecho\nque los Pokémon que viven en él tengan una\nactitud muy retorcida."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="[CS:Y]Grovyle[CR].[K] I suspect you know\nbetter than anyone else.", french="[CS:Y]Massko[CR].[K] Tu es bien placé\npour le savoir.", german="[CS:Y]Reptain[CR].[K] Ich glaube, du weißt es\nbesser als jeder andere.", italian="[CS:Y]Grovyle[CR].[K] Immagino che tu lo\nsappia meglio di chiunque altro.", spanish="[CS:Y]Grovyle[CR]...[K] Sospecho que tú\nya lo sabes mejor que nadie."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I know I don't really know\nwhere it would be best to go...", french="Je ne sais pas vraiment où\nnous devrions aller...", german="Ich weiß zwar nicht genau,\nwo wir jetzt am besten hingehen...", italian="Non so bene dove dovremmo\nandare...", spanish="Lo que sé es que no tengo ni idea\nde adónde tendríamos que ir ahora..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="However, I believe if we follow\nthe path that lies ahead of here, it would\nbe best.", french="Mais, pour l'heure, la meilleure\nchose à faire est de suivre ce chemin.", german="Aber vielleicht sollten wir\neinfach dem Pfad vor uns folgen.", italian="Ma credo che la soluzione\nmigliore sia quella di seguire il sentiero\ndi fronte a noi.", spanish="Pero mi intuición me dice que\nlo mejor que podemos hacer ahora es seguir\navanzando por el camino que tenemos delante."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I suspect the [CS:N]Sableye[CR] will\nhave laid other traps, so we should\nproceed with caution.", french="Je soupçonne les [CS:N]Ténéfix[CR] de\nnous réserver encore quelque piège.\nRestons sur nos gardes.", german="Ich vermute, dass uns die\n[CS:N]Zobiris[CR] noch andere Fallen gestellt haben.\nDeswegen sollten wir vorsichtig weitergehen.", italian="Probabilmente i [CS:N]Sableye[CR] hanno\nin serbo qualche altra brutta sorpresa, quindi\nfaremo meglio a procedere con cautela.", spanish="Sospecho que los [CS:N]Sableye[CR]\nhabrán puesto más trampas, así que\nhabrá que ir con cuidado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yes, I see.[K] ...[K]However...", french=" Je vois.[K] Cependant...", german=" Ich verstehe.[K] ...[K]Aber...", italian=" Sì, capisco.[K] ...[K] Però...", spanish=" Sí...[K] ya veo...[K] Pero..."})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(hero, "angry", 1) end)
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="The ones we met...[K] If we see\nthem again...", french="Ceux que nous avons déjà\ncroisés...[K] Si nous les revoyons...", german="Vielleicht treffen wir noch\nmal...[K] auf die von eben...", italian="Quelli che abbiamo incontrato...[K]\nSe li rivedo...", spanish="Si...[K] Si volvemos a ver a los Pokémon\nde antes..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="... (However, the [CS:N]Snorunt[CR] could\ntease him like that...)", french="... (Les [CS:N]Stalgamin[CR] ont eu beau\nlui chercher querelle...)", german="...(Dass die [CS:N]Schneppke[CR] sich\nderart über ihn lustig gemacht haben...)", italian="... (Certo che il modo in cui gli\n[CS:N]Snorunt[CR] si sono fatti beffe di lui...)", spanish="Vaya... (Esos [CS:N]Snorunt[CR] le han\ntomado el pelo de mala manera...)"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="(This guy...[K] Sometimes he can\nbe so innocent...)", french="(... il est resté parfaitement\ncalme...[K] Il a un bon fond...)", german="(Dieser Kerl...[K] Er glaubt wohl\nwirklich und unerschütterlich an das Gute...)", italian="(Questo tipo...[K] A volte la sua\nindole così bonaria mi sorprende...)", spanish="(Y con todo...[K] Se lo ha tomado\nbien. A veces no es nada rencoroso...)"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" (No.)", french=" (En fait...)", german=" (Genau...)", italian=" (Ma forse...)", spanish="(No solo a veces, sino siempre.\nEs que su personalidad es así.)"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="(That's why his heart is not\ninfluenced by the power of the darkness...)", french="(C'est sûrement la raison pour\nlaquelle son cœur est immunisé contre\nl'ombre omniprésente...)", german="(Deswegen wird sein Herz\nwohl auch nicht von der Macht\nder Dunkelheit beeinflusst...)", italian="(... è proprio per questo che\nil suo cuore è immune al potere\ndell'oscurità...)", spanish="(Por eso su corazón no ha\nsufrido la influencia del poder siniestro...)"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  SV.SkyScenarioSide = {main=48, sub=0} -- $SCENARIO_SIDE = scn[48,0] (ROM)
  SkySceneKit.cleanup_npcs()
end
