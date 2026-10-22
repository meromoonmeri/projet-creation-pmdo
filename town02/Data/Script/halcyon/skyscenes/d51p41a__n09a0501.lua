-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D51P41A/n09a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=48, sub=4} -- $SCENARIO_SIDE = scn[48,4] (ROM)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(144, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D51P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  -- SetAnimation(5) [anim idle native]
  local npc_npc_yonowaaru_n9 = SkySceneKit.spawn_npc("dusknoir", 0, 272, Direction.Right, "NPC_YONOWAARU_N9")
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(hero, 120, 204, false, 2) -- Slide2PositionMark (glissement)
  GROUND:MoveToPosition(npc_npc_yonowaaru_n9, 120, 204, false, 2) -- Slide2PositionMark (glissement)
  -- GAP: BGM BGM_TEMPORAL_PINNACLE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(204, 204, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 228, 204, false, 2)
  GROUND:MoveToPosition(npc_npc_yonowaaru_n9, 156, 204, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(20)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="It seems like this is\nthe pinnacle.", french=" On dirait le pinacle.", german="Sieht fast so aus,\nals sei das hier die Spitze.", italian="A quanto pare, abbiamo raggiunto\nla sommità.", spanish=" Parece que hemos llegado a la cima."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="And it looks like the trail heads\ndown the mountain from here.", french=" Après, ça redescend.", german="Und von hier aus führt der Pfad\nanscheinend nur noch den Berg hinunter.", italian="E sembra che da questo punto\nil sentiero prosegua in discesa.", spanish="Y parece que el rastro conduce\nal pie de la montaña, ¡cuesta abajo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru_n9, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" It should be much easier.", french="Ça devrait nous faciliter\nla tâche.", german="Das sollte\nsehr viel einfacher sein.", italian="Dovrebbe essere molto\npiù facile.", spanish=" Eso facilitará mucho las cosas."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  pcall(function() GAME:MoveCamera(252, 204, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 284, 204, false, 2)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_yonowaaru_n9, 220, 204, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(10753, 192) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" [CS:Y]Grovyle[CR]! Look out! Above you!", french="[CS:Y]Massko[CR]! Attention!\nAu-dessus de toi!", german=" [CS:Y]Reptain[CR]! Pass auf! Über dir!", italian=" [CS:Y]Grovyle[CR]! Attento! Sopra di te!", spanish="¡[CS:Y]Grovyle[CR]!\n¡Cuidado con el trozo de hielo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- se_ChangeVolume(10753, 5, 256) [canal SE NDS: one-shots PMDO, volume non scriptable]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  -- SetAnimation(35) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(10754) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  -- SetAnimation(19) [anim idle native]
  -- SetAnimation(19) [anim idle native]
  GROUND:MoveToPosition(npc_npc_yonowaaru_n9, 268, 204, false, 2)
  GAME:FadeOut(true, 15) -- screen_WhiteOut
  -- GAP: se_Play(10755) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Gwaaaaaaahhh!!", french=" Aaaaah!!", german=" Gwaaaaaaah!!!", italian=" Guaaaaaaahhh!!", spanish=" ¡¡Aaaaaaah!!"})
  -- message_Close
  GAME:WaitFrames(2) -- join WaitSe
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:TeleportTo(hero, 300, 164, Direction.Down)
  -- SetAnimation(29) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Down)
  -- SetAnimation(13) [anim idle native]
  -- SetOutputAttribute(2) [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  -- SetAnimation(31) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]D-[K]Dusknoir[CR]!", french=" [CS:N]N-[K]Noctunoir[CR]!", german=" [CS:N]Z-[CR][K][CS:N]Zwirrfinst[CR]!", italian=" [CS:N]D-[CR][K][CS:N]Dusknoir[CR]!", spanish=" [CS:N]Du[CR]...[K] ¡[CS:N]Dusknoir[CR]!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Y-you protected me!?[K]\nWhy'd you protect me?!", french="Tu m'as protégé!?[K]\nMais pourquoi?!", german="D-du hast mich gerettet?!?[K]\nWarum hast du mir geholfen?!?", italian="T-Tu mi hai protetto!?[K]\nPerché mai l'hai fatto?!", spanish="¡¿Me has protegido?![K]\n¡¿Por qué lo has hecho?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 268, 180, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru_n9, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Right)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "shock", 1) end)
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Down)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Oof!", french=" Ouf!", german=" Uuuooff!", italian=" Uff!", spanish=" ¡Ay!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Are you all right?!", french=" Tu vas bien?!", german=" Geht es dir gut?!?", italian=" Stai bene?!", spanish=" ¡¿Estás bien?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Ugh...[K] N-never mind that...", french=" Argh...[K] Ne t'occupe pas de cela...", german="Uff...[K]\nM-mach dir darum keine Sorgen...", italian=" Urgh...[K] N-Non ti preoccupare...", spanish=" Ay...[K] No... No te preocupes..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Look out...[K] They're coming...", french=" Attention...[K] Ils arrivent...", german=" Pass auf...[K] Sie kommen...", italian="Fai attenzione...[K] Stanno\narrivando...", spanish=" Cuidado...[K] Ahí vienen..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(10756) — id SE NDS sans portage PMDO identifié
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" GOGIGIGIGI!!", french=" GOGNIGNIGNIGNI!!", german=" GOGIGIGIGI!!!", italian=" GOGIGIGIGI!!", spanish=" ¡¡GOGUIGUIGUIGUÍ!!"})
  GAME:WaitFrames(90)
  -- message_CloseEnforce
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(15)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_onigoori = SkySceneKit.spawn_npc("glalie", 64, 176, Direction.Down, "NPC_ONIGOORI")
  GROUND:MoveToPosition(npc_npc_onigoori, 180, 172, false, 2)
  GAME:WaitFrames(10)
  local npc_npc_onigoori2 = SkySceneKit.spawn_npc("glalie", 64, 232, Direction.Down, "NPC_ONIGOORI2")
  GROUND:MoveToPosition(npc_npc_onigoori2, 180, 228, false, 2)
  GAME:WaitFrames(10)
  local npc_npc_onigoori3 = SkySceneKit.spawn_npc("glalie", 416, 176, Direction.Down, "NPC_ONIGOORI3")
  GROUND:MoveToPosition(npc_npc_onigoori3, 320, 172, false, 2)
  GAME:WaitFrames(10)
  local npc_npc_onigoori4 = SkySceneKit.spawn_npc("glalie", 416, 232, Direction.Down, "NPC_ONIGOORI4")
  GROUND:MoveToPosition(npc_npc_onigoori4, 320, 228, false, 2)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(hero, 236, 200, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_onigoori, Direction.DownRight)
  GROUND:EntTurn(npc_npc_onigoori2, Direction.UpRight)
  GROUND:EntTurn(npc_npc_onigoori3, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_onigoori4, Direction.UpLeft)
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Th-these...[K]guys?!", french=" Mais...[K] qui sont-ils?!", german=" D-diese...[K] Typen?!?", italian=" C-Chi sono...[K] questi?!", spanish=" ¡¿Son...[K] los de antes?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="[CS:N]Glalie[CR]...[K] They have the power to\ndo whatever they wish with ice...", french="Des [CS:N]Oniglali[CR]...[K] Ils ont\nune maîtrise parfaite de la glace...", german="[CS:N]Firnontor[CR]...[K] Sie haben die Macht,\nEis nach Belieben zu manipulieren...", italian="[CS:N]Glalie[CR]...[K] Hanno il potere di\nmanipolare il ghiaccio a loro piacimento...", spanish="No, estos son [CS:N]Glalie[CR]...[K]\nControlan el hielo a voluntad."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" B-but...", french=" Mais...", german=" A-aber...", italian=" M-Ma...", spanish=" Pe... pero..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_onigoori) end)
  SkySceneKit.say({english=" GOGI!", french=" GOGNI!", german=" GOGI!", italian=" GOGI!", spanish=" ¡GOGUÍ!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_onigoori) end)
  SkySceneKit.say({english=" GOGIGI!", french=" GOGNIGNI!", german=" GOGIGI!", italian=" GOGIGI!", spanish=" ¡GOGUIGUÍ!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_onigoori, 196, 180, false, 1) -- Slide2PositionMark (glissement)
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:MoveToPosition(npc_npc_onigoori2, 196, 228, false, 1) -- Slide2PositionMark (glissement)
  GAME:WaitFrames(7)
  GROUND:MoveToPosition(npc_npc_onigoori3, 308, 180, false, 1) -- Slide2PositionMark (glissement)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_onigoori4, 308, 228, false, 1) -- Slide2PositionMark (glissement)
  GROUND:EntTurn(npc_npc_onigoori, Direction.DownRight)
  GROUND:EntTurn(npc_npc_onigoori2, Direction.UpRight)
  GROUND:EntTurn(npc_npc_onigoori3, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_onigoori4, Direction.UpLeft)
  -- message_FacePositionOffset(2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="But looking at them, they seem\nto be so influenced by the darkness that\nthey've lost themselves.", french="Il semblerait que l'ombre leur\nait fait perdre la tête.", german="Aber bei genauem Hinsehen sind\nsie derart von der Dunkelheit beeinflusst, dass\nsie völlig von Sinnen sind.", italian="Ma pare che l'oscurità li abbia\ninfluenzati al punto di annullare\ncompletamente la loro volontà...", spanish="Pero por lo que veo han sufrido\ntanto con la oscuridad que han perdido\ncompletamente la razón."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Seems like they became\nmore vicious.", french="Ils sont encore plus agressifs\nque d'ordinaire.", german="Sie sind wohl um einiges\nangriffslustiger als normalerweise.", italian=" Hanno un'aria molto più feroce.", spanish="Parecen ser más despiadados\nque nunca."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(10756) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_onigoori) end)
  SkySceneKit.say({english=" GOGIGIGIGI!", french=" GOGNIGNIGNIGNI!", german=" GOGIGIGIGI!", italian=" GOGIGIGIGI!", spanish=" ¡GOGUIGUIGUIGUÍ!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Humph![K] We're gonna have to try\nto take these guys!", french="Pfff![K] Pas de problème, on va\ns'en débarrasser vite fait bien fait!", german="Hmpf![K] Ein Kampf\nist unausweichlich!", italian="Bah![K] Dobbiamo sbarazzarcene,\nnon abbiamo altra scelta!", spanish="¡Uf![K] ¡No queda otro remedio\nque enfrentarnos a ellos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Don't believe there are only\nthese guys, [CS:Y]Grovyle[CR]!", french="Méfie-toi, ils ne sont pas seuls,\n[CS:Y]Massko[CR]!", german="Und denke nicht, dass wir es\nnur mit ihnen zu tun haben, [CS:Y]Reptain[CR]!", italian="Non credere che siano soli,\n[CS:Y]Grovyle[CR]!", spanish="¿De verdad crees que están\nsolos, [CS:Y]Grovyle[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Come?!", spanish=" ¡¿Qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(10757) — id SE NDS sans portage PMDO identifié
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" BUAOOOOOON!", french=" ROOOAAAAARRRR!", german=" BUAOOOOOON!", italian=" BUAOOOOOON!", spanish=" ¡BUAOOOOOON!"})
  GAME:WaitFrames(60)
  -- bgm2_PlayFadeIn(BGM_EARTHQUAKE1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(20)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Wh-what?!", french=" C'était quoi, ça?!", german=" W-was?!?", italian=" C-Cosa succede?!", spanish=" ¡¿Pero qué...?!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  -- message_Close
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Right)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Up)
  GAME:WaitFrames(50)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(30)
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_manmuu = SkySceneKit.spawn_npc("mamoswine", 256, 72, Direction.Down, "NPC_MANMUU")
  -- SetAnimation(23) [anim idle native]
  -- ResetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  GROUND:MoveToPosition(npc_npc_manmuu, 252, 156, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- SetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GROUND:EntTurn(hero, Direction.Up)
  -- GAP: se_Play(10758) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('1', '1', '1', '0')
  GAME:WaitFrames(30)
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(8), 8, false) end) -- MovePositionOffset performer/caméra
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(7)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D51P41A1_422) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  -- GAP: se_Play(10757) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() UI:SetSpeaker(npc_npc_manmuu) end)
  SkySceneKit.say({english=" BUAOOOOOON!", french=" ROOOAAAAARRRR!", german=" BUAOOOOOON!", italian=" BUAOOOOOON!", spanish=" ¡BUAOOOOOON!"})
  GAME:WaitFrames(90)
  -- message_CloseEnforce
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(20)
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" He's a...?!", french=" C'est un...?!", german=" Ist das ein...", italian=" È un...?!", spanish=" ¡¿Es un...?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" He's a [CS:K]Mamoswine[CR]!", french=" Un [CS:K]Mammochon[CR]!", german=" Es ist ein [CS:K]Mamutel[CR]!", italian=" È un [CS:K]Mamoswine[CR]!", spanish=" ¡Es un [CS:K]Mamoswine[CR]!"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Among Ice types...[K][CS:K]Mamoswine[CR]\nare said to be the strongest Pokémon!", french="De tous les Pokémon de type\nGlace...[K] on dit que [CS:K]Mammochon[CR] est le plus fort!", german="Unter den Eis-Pokémon...[K]\ngelten [CS:K]Mamutel[CR] gemeinhin als die\nstärksten Vertreter!", italian="Si dice che tra i Pokémon di tipo\nGhiaccio...[K] [CS:K]Mamoswine[CR] sia il più forte\nin assoluto!", spanish="Dicen que, entre los Pokémon\nde tipo Hielo...[K] ¡[CS:K]Mamoswine[CR] es el más\nfuerte de todos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- GAP: se_Play(10757) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() UI:SetSpeaker(npc_npc_manmuu) end)
  SkySceneKit.say({english=" BUAAAAOOOOOON!", french=" ROOOAAAAARRRR!", german=" BUAAAAOOOOOON!", italian=" BUAAAAOOOOOON!", spanish=" ¡BUAAAAOOOOOON!"})
  GAME:WaitFrames(90)
  -- message_CloseEnforce
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" H-here they come!", french=" Il arrive!", german=" P-pass auf! Es geht los!", italian=" A-Arriva!", spanish=" ¡Aquí viene!"})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(144, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
