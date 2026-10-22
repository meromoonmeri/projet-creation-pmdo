-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D28P44A/m25a0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_ANOTHER_GLOWING_NOISE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_D28P44A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 256, 208, Direction.Down, "NPC_YONOWAARU")
  -- SetAnimation(36) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: SetEffect 653 — VFX sans émote PMDO équivalente
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 288, 224, Direction.DownLeft, "NPC_JUPUTORU")
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "exclaim", 1) end)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(Wh-what was that...?)", french="(Que... qu'est-ce que c'était?)", german="(W-was war das?)", italian="(C-Cos'è stato...?)", spanish="(¿Qué ha sido eso...?)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_juputoru, 220, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" [partner]'s done it!", french=" [partner] a réussi!", german=" [partner] hat es geschafft!", italian=" [partner] ce l'ha fatta!", spanish=" ¡[partner] lo ha conseguido!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That noise...[K] It has to be the\nsound of the Rainbow Stoneship activating!", french="Ce bruit...[K] c'est certainement\nle Vaisseau Arc-en-Ciel qui a été activé!", german="Dieses Geräusch...[K] Das muss das\nStartgeräusch des Regenbogen-Steinschiffs\nsein!", italian="Quel rumore...[K] Dev'essere il\nrumore del Vascello Arcobaleno che si attiva!", spanish="Ese ruido...[K] Seguro que ha sido\nla Barca Arcoiris al activarse."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_yonowaaru, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_yonowaaru, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_yonowaaru, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_yonowaaru, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" ...Gwoh!", french=" ... Gwoh!", german=" ...Gwoh!", italian=" ... Oooh!", spanish=" ¡Grrr!"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru, 4) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(34) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(5)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(-8), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" GWWWOOOOOHHHH!", french=" GWWWOOOOOHHHH!", german=" GWWWOOOOOHHHH!", italian=" OOOOOOOOOHHHH!", spanish=" ¡AAAAH!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOutAll
  pcall(function() GAME:MoveCamera(252, 248, 60, false) end) -- performer/caméra
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- SetAnimation(11) [anim idle native]
  GROUND:MoveToPosition(hero, 252, 264, false, 2) -- SlidePositionMark (glissement)
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownRight)
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Gwah!)", french="(Aaah!)", german="(Gwah!)", italian="(Aaah!)", spanish="(¡Aah!)"})
  else
  SkySceneKit.say({english="(Gwah!)", french="(Aaah!)", german="(Gwah!)", italian="(Aaah!)", spanish="(¡Aah!)"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(68) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I won't...[K] You'll never change\nhistory!", french="Je ne vous laisserai pas...[K] Vous\nne changerez pas le cours de l'histoire!", german="Das lasse ich...[K] Ihr werdet\nniemals die Geschichte ändern!", italian="Non voglio...[K] Non cambierete\nmai la storia!", spanish="Ni hablar...[K]\n¡Nunca cambiaréis la historia!"})
  -- message_Close
  -- SetAnimation(19) [anim idle native]
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(32), p.Y+(0), false, 2) end
  GAME:WaitFrames(5)
  -- GAP: se_Play(7690) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 5) -- screen_WhiteOutAll
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  GAME:FadeOut(true, 0) -- screen_WhiteOut
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Waah!)", french="(Aaah!)", german="(Waah!)", italian="(Aaah!)", spanish="(¡Aaah!)"})
  else
  SkySceneKit.say({english="(Waah!)", french="(Aaah!)", german="(Waah!)", italian="(Aaah!)", spanish="(¡Aaah!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:TeleportTo(npc_npc_juputoru, 252, 228, Direction.Down)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Up)
  -- SetAnimation(29) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeOut(true, 0) -- screen_WhiteOutAll
  GAME:WaitFrames(1)
  GAME:FadeIn(0)
  -- GAP: SetEffect 653 — VFX sans émote PMDO équivalente
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Urrgggghhh!", french=" Aaaaaargggghhh!", german=" Urrgggghhh!", italian=" Urrgggghhh!", spanish=" ¡Aaah!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:N]Grovyle[CR]!)", french="([CS:N]Massko[CR]!)", german="([CS:N]Reptain[CR]!)", italian="([CS:N]Grovyle[CR]!)", spanish="(¡[CS:N]Grovyle[CR]!)"})
  else
  SkySceneKit.say({english="([CS:N]Grovyle[CR]!)", french="([CS:N]Massko[CR]!)", german="([CS:N]Reptain[CR]!)", italian="([CS:N]Grovyle[CR]!)", spanish="(¡[CS:N]Grovyle[CR]!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="So you shielded [hero],\n[CS:N]Grovyle[CR]?!", french="Alors tu t'es sacrifié pour\n[hero], [CS:N]Massko[CR]?!", german="Du hast [hero] geschützt,\n[CS:N]Reptain[CR]?!?", italian="E così hai fatto da scudo a\n[hero], [CS:N]Grovyle[CR]?!", spanish="¿Así que has protegido\na [hero], [CS:N]Grovyle[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" That's taken a heavy toll on you!", french=" Cela t'a coûté cher!", german=" Das hat dir schwer zugesetzt!", italian=" Ti costerà caro!", spanish="Como ves, no ha sido una buena\nidea."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Very well![K] You're going down\nfirst!", french="Fort bien![K] Tu seras donc\nle premier à disparaître!", german="Sehr gut![K] Du trittst als Erster\nab!", italian="Molto bene![K] Mi occuperò prima\ndi te!", spanish="¡Como quieras![K]\n¡Tú caerás primero!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(10497) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(31) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_juputoru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  -- SetAnimation(9) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Uwroh...[K] Wrooooooooh!", french=" Grrr...[K] Rooooooooh!", german=" Uwroh...[K] Wrooooooooh!", italian=" Uoooh...[K] Uoooooooooh!", spanish=" Ay...[K] ¡Nooooo!"})
  -- message_Close
  -- GAP: se_Play(7686) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(npc_npc_juputoru, 252, 204, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  -- SetAnimation(52) [anim idle native]
  -- SetAnimation(55) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() GAME:MoveCamera(252, 212, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_yonowaaru, 252, 180, false, 1) -- SlidePositionMark (glissement)
  GROUND:MoveToPosition(npc_npc_juputoru, 252, 180, false, 1)
  GAME:WaitFrames(45)
  GROUND:MoveToPosition(hero, 252, 228, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(32) [anim idle native]
  -- GAP: BGM BGM_THROUGH_THE_SEA_OF_TIME non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Wh-what are you doing?!", french=" Mais... que fais-tu?!", german=" W-was machst du?", italian=" C-Cosa stai facendo?!", spanish=" Pero... ¡¿qué haces?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Urrggh...[K] [CS:N]Dusknoir[CR]!", french=" Arrggh...[K] [CS:N]Noctunoir[CR]!", german=" Arrggh...[K] [CS:N]Zwirrfinst[CR]!", italian=" Urrggh...[K] [CS:N]Dusknoir[CR]!", spanish=" Grrr...[K] ¡[CS:N]Dusknoir[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" I'm...[K] I'm taking you with me...", french=" Je...[K] je t'emmène avec moi...", german=" Ich...[K] Ich nehme dich mit mir...", italian=" Ti...[K] porto via con me...", spanish=" Nos...[K] Nos vamos juntos..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We're going back to the future!", french=" On repart dans le futur!", german="Wir gehen zurück in die\nZukunft!", italian=" Ritorniamo nel futuro!", spanish=" ¡Al futuro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Wha...", french=" Qu...", german=" Wa...", italian=" Aah...", spanish=" ¿Pero...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What?!)", french="(Quoi?!)", german="(Was?!?)", italian="(Cosa?!)", spanish="(¡¿Qué?!)"})
  else
  SkySceneKit.say({english="(What?!)", french="(Quoi?!)", german="(Was?!?)", italian="(Cosa?!)", spanish="(¡¿Qué?!)"})
  end
  -- message_Close
  -- SetAnimation(33) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="[hero]![K] It's up to you\nnow!", french="[hero]![K] A toi de jouer\nmaintenant!", german="[hero]![K] Es liegt jetzt an\ndir!", italian="[hero]![K] Dipende tutto da\nte, ora!", spanish="¡[hero]![K]\n¡Ahora todo depende de ti!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7687) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetAnimation(21) [anim idle native]
  -- Slide2PositionMark<object OBJECT_D28P34A2_75> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(3)
  -- supervision_Acting(4) [neutre/état moteur]
  -- SetAnimation(20) [anim idle native]
  -- Slide2PositionMark<object OBJECT_D28P34A2_76> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(4)
  -- supervision_Acting(5) [neutre/état moteur]
  -- SetAnimation(21) [anim idle native]
  -- Slide2PositionMark<object OBJECT_D28P34A2_77> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Gah! Those are...!", french=" Gah! Ce sont...!", german=" Gah! Das sind...", italian=" Aah! Quelli sono...!", spanish=" ¡Ah! ¡Esos son...!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Time Gears!)", french="(Les Rouages du Temps!)", german="(Zahnräder der Zeit!)", italian="(Gli Ingranaggi del Tempo!)", spanish="(¡Los Engranajes del Tiempo!)"})
  else
  SkySceneKit.say({english="(Time Gears!)", french="(Les Rouages du Temps!)", german="(Zahnräder der Zeit!)", italian="(Gli Ingranaggi del Tempo!)", spanish="(¡Los Engranajes del Tiempo!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="All right, team![K] The Rainbow\nStoneship's set to go!", french="C'est bon, vous autres![K]\nLe Vaisseau Arc-en-Ciel est prêt à partir!", german="Alles klar, Team![K]\nDas Regenbogen-Steinschiff ist abfahrbereit!", italian="Va bene, squadra![K] Il Vascello\nArcobaleno è pronto a partire!", spanish="¡Muy bien, equipo![K]\n¡La Barca Arcoiris está lista para partir!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="OK, team![K] The Rainbow\nStoneship's set to go!", french="C'est bon, vous autres![K]\nLe Vaisseau Arc-en-Ciel est prêt à partir!", german="Okay, Team![K]\nDas Regenbogen-Steinschiff ist abfahrbereit!", italian="Va bene, squadra![K] Il Vascello\nArcobaleno è pronto a partire!", spanish="¡Muy bien, equipo![K]\n¡La Barca Arcoiris está lista para partir!"})
  else
  SkySceneKit.say({english="OK, team![K] The Rainbow\nStoneship's set to go!", french="C'est bon, vous autres![K]\nLe Vaisseau Arc-en-Ciel est prêt à partir!", german="Okay, Team![K]\nDas Regenbogen-Steinschiff ist abfahrbereit!", italian="Va bene, squadra![K] Il Vascello\nArcobaleno è pronto a partire!", spanish="¡Muy bien, equipo![K]\n¡La Barca Arcoiris está lista para partir!"})
  end
  -- message_Close
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:MoveToPosition(partner, 172, 228, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wha...[K]what's going on?!", french=" Qu...[K] qu'est-ce qui se passe?!", german=" Was...[K] Was geschieht hier?", italian=" Co...[K] Cosa sta succedendo?!", spanish="¿Pero qué...?[K]\n¡¿Qué está pasando?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wha...[K]what's happening?!", french=" Qu...[K] qu'est-ce qui se passe?!", german=" Was...[K] Was geschieht hier?", italian=" Co...[K] Cosa sta succedendo?!", spanish="¿Pero qué...?[K]\n¡¿Qué está pasando?!"})
  else
  SkySceneKit.say({english=" Wha...[K]what's happening?!", french=" Qu...[K] qu'est-ce qui se passe?!", german=" Was...[K] Was geschieht hier?", italian=" Co...[K] Cosa sta succedendo?!", spanish="¿Pero qué...?[K]\n¡¿Qué está pasando?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" [partner]![K] This is it for me!", french="[partner]![K] C'est ici que\nnos chemins se séparent!", german="[partner]![K] Ende der\nFahnenstange!", italian=" [partner]![K] A lui ci penso io!", spanish="¡[partner]![K]\n¡Aquí nos despedimos!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I'm taking [CS:N]Dusknoir[CR]...[K]back to\nthe future!", french="Je ramène [CS:N]Noctunoir[CR]...[K]\ndans le futur!", german="Ich nehme [CS:N]Zwirrfinst[CR]...[K] mit in\ndie Zukunft zurück!", italian=" Riporto [CS:N]Dusknoir[CR]...[K] nel futuro!", spanish="Me llevo a [CS:N]Dusknoir[CR]...[K]\n¡de vuelta al futuro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?![K] Wh-what?!", french=" Hein?![K] Quoi?!", german=" Wie bitte?!?[K] W-was?!?", italian=" Eh?![K] C-Cosa?!", spanish=" ¡¿Eh?![K] ¡¿Qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh?![K] Wh-what?!", french=" Hein?![K] Quoi?!", german=" Wie bitte?!?[K] W-was?!?", italian=" Eh?![K] C-Cosa?!", spanish=" ¡¿Eh?![K] ¡¿Qué?!"})
  else
  SkySceneKit.say({english=" Huh?![K] Wh-what?!", french=" Hein?![K] Quoi?!", german=" Wie bitte?!?[K] W-was?!?", italian=" Eh?![K] C-Cosa?!", spanish=" ¡¿Eh?![K] ¡¿Qué?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I can never come back here\nagain.", french="Je ne pourrai plus jamais\nrevenir.", german="Ich kann niemals mehr hierher\nzurückkommen.", italian=" Non tornerò mai più.", spanish=" No regresaré."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Watch [hero]'s back...[K]\nPromise me!", french="Prends soin de [hero]\npour moi...[K] Promets-le-moi!", german="Pass gut auf [hero]\nauf...[K] Versprich mir das!", italian="Prenditi cura di [hero]...[K]\nPromettimelo!", spanish="Cuida de [hero]...[K]\n¡Prométemelo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" B-but...!", french=" M-mais!", german=" A-aber...", italian=" M-Ma...!", spanish=" ¡Pero...!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" B-but...!", french=" M-mais!", german=" A-aber...", italian=" M-Ma...!", spanish=" ¡Pero...!"})
  else
  SkySceneKit.say({english=" B-but...!", french=" M-mais!", german=" A-aber...", italian=" M-Ma...!", spanish=" ¡Pero...!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Take your place, [CS:N]Grovyle[CR]...?[K]\nI can't!", french="Prendre ta place, [CS:N]Massko[CR]...?[K]\nJe ne peux pas faire ça!", german="Deinen Platz einnehmen,\n[CS:N]Reptain[CR]?[K] Das kann ich nicht!", italian="Prendere il tuo posto,\n[CS:N]Grovyle[CR]...?[K] Non posso!", spanish="¿Quieres que ocupe tu lugar,\n[CS:N]Grovyle[CR]?[K] ¡No puedo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Take your place, [CS:N]Grovyle[CR]...?[K]\nI can't!", french="Prendre ta place, [CS:N]Massko[CR]...?[K]\nJe ne peux pas faire ça!", german="Deinen Platz einnehmen,\n[CS:N]Reptain[CR]?[K] Das kann ich nicht!", italian="Prendere il tuo posto,\n[CS:N]Grovyle[CR]...?[K] Non posso!", spanish="¿Quieres que ocupe tu lugar,\n[CS:N]Grovyle[CR]?[K] ¡No puedo!"})
  else
  SkySceneKit.say({english="Take your place, [CS:N]Grovyle[CR]...?[K]\nI can't!", french="Prendre ta place, [CS:N]Massko[CR]...?[K]\nJe ne peux pas faire ça!", german="Deinen Platz einnehmen,\n[CS:N]Reptain[CR]?[K] Das kann ich nicht!", italian="Prendere il tuo posto,\n[CS:N]Grovyle[CR]...?[K] Non posso!", spanish="¿Quieres que ocupe tu lugar,\n[CS:N]Grovyle[CR]?[K] ¡No puedo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="You must and you will.[K] Because\nyou can, [partner].", french="Tu le dois et tu le feras.[K] Parce\nque tu en es capable, [partner].", german="Du musst und du wirst.[K] Weil du\nes kannst, [partner].", italian="Devi farlo e lo farai.[K] Perché\nne sei in grado, [partner].", spanish="Debes hacerlo, y lo harás...[K]\nporque puedes, [partner]."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="You two are...[K]the greatest of\ncombinations.", french="Vous faites...[K] une équipe\nhors pair.", german="Ihr beide seid...[K] das beste\nGespann, das es gibt.", italian="Voi due siete...[K] un'accoppiata\nmagnifica!", spanish="Cuando actuáis en equipo...[K]\nNo hay rival que os haga sombra."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Gwoh! Unhand me![K] Release me!", french="Argh! Lâche-moi![K] Mais tu vas\nme lâcher à la fin!", german="Gwoh! Lass mich los![K]\nLass mich gehen!", italian=" Oooh! Lasciami![K] Mollami!", spanish="¡Suéltame![K]\n¡Quítame las manos de encima!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(32) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We're almost there![K] Quiet!", french=" Du calme![K] On y est presque!", german=" Wir sind fast da![K] Ruhe!", italian=" Ci siamo quasi![K] Stai calmo!", spanish="No tengas tanta prisa.[K]\n¡Y cállate!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" ...[hero]!", french=" ... [hero]!", german=" ...[hero]!", italian=" ... [hero]!", spanish=" ¡[hero]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- SetAnimation(33) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Take care, [hero].", french="Fais attention à toi,\n[hero].", german=" Lebe wohl, [hero].", italian=" In gamba, [hero].", spanish=" Cuídate, [hero]."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" I was lucky to have known you.", french="J'ai eu de la chance\nde te connaître.", german="Ich bin froh, dich gekannt zu\nhaben.", italian=" È stata una fortuna conoscerti.", spanish="Ha sido una suerte haberte\nconocido."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Though the parting hurts...[K]\nThe rest is in your hands!", french="Ecoute-moi bien... La séparation\nest toujours douloureuse...[K] mais les larmes\ndevront attendre!", german="Auch wenn die Trennung\nschmerzt...[K] Der Rest liegt in deiner Hand!", italian="Certo, gli addii sono dolorosi...[K]\nMa ora è tutto nelle tue mani!", spanish="Separarse es duro...[K]\n¡Lo dejo todo en tus manos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:N]Grovyle[CR]!)", french="([CS:N]Massko[CR]!)", german="([CS:N]Reptain[CR]!)", italian="([CS:N]Grovyle[CR]!)", spanish="(¡[CS:N]Grovyle[CR]!)"})
  else
  SkySceneKit.say({english="([CS:N]Grovyle[CR]!)", french="([CS:N]Massko[CR]!)", german="([CS:N]Reptain[CR]!)", italian="([CS:N]Grovyle[CR]!)", spanish="(¡[CS:N]Grovyle[CR]!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(32) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Sorry for the holdup, [CS:N]Dusknoir[CR]!", french="Excuse-moi de t'avoir fait\nattendre, [CS:N]Noctunoir[CR]!", german="Entschuldige die Verzögerung,\n[CS:N]Zwirrfinst[CR]!", italian="Scusa se c'è voluto tanto,\n[CS:N]Dusknoir[CR]!", spanish="Siento haberte hecho esperar,\n[CS:N]Dusknoir[CR]..."})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7686) — id SE NDS sans portage PMDO identifié
  do local p=npc_npc_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_yonowaaru, p.X+(0), p.Y+(-4), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(0), p.Y+(-4), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "shock", 1) end)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-8), false, 1) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(16), p.Y+(-16), false, 1) end
  GAME:WaitFrames(120)
  -- SetAnimation(52) [anim idle native]
  do local p=npc_npc_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_yonowaaru, p.X+(0), p.Y+(-12), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(0), p.Y+(-12), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(7183) — id SE NDS sans portage PMDO identifié
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(150) end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Gwaaaaaaah!", french=" Aaaaaaaah!", german=" Gwaaaaaaah!", italian=" Aaaaaaaaah!", spanish=" ¡Aaaaaaah!"})
  GAME:WaitFrames(80)
  -- message_CloseEnforce
  GAME:WaitFrames(60)
  -- GAP: se_Play(7688) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_T01P01A5_194) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(120)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh... [CS:N]Grovyle[CR]...[K] Why...?", french=" Argh... [CS:N]Massko[CR]...[K] Pourquoi...?", german=" Uff... [CS:N]Reptain[CR]...[K] Warum?", italian=" Uh... [CS:N]Grovyle[CR]...[K] Perché...?", spanish=" No... [CS:N]Grovyle[CR]...[K] ¿Por qué...?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh... [CS:N]Grovyle[CR]...[K] Why...?", french=" Argh... [CS:N]Massko[CR]...[K] Pourquoi...?", german=" Uff... [CS:N]Reptain[CR]...[K] Warum?", italian=" Uh... [CS:N]Grovyle[CR]...[K] Perché...?", spanish=" No... [CS:N]Grovyle[CR]...[K] ¿Por qué...?"})
  else
  SkySceneKit.say({english=" Ugh... [CS:N]Grovyle[CR]...[K] Why...?", french=" Argh... [CS:N]Massko[CR]...[K] Pourquoi...?", german=" Uff... [CS:N]Reptain[CR]...[K] Warum?", italian=" Uh... [CS:N]Grovyle[CR]...[K] Perché...?", spanish=" No... [CS:N]Grovyle[CR]...[K] ¿Por qué...?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:N]Grovyle[CR]...)", french="([CS:N]Massko[CR]...)", german="([CS:N]Reptain[CR]...)", italian="([CS:N]Grovyle[CR]...)", spanish="([CS:N]Grovyle[CR]...)"})
  else
  SkySceneKit.say({english="([CS:N]Grovyle[CR]...)", french="([CS:N]Massko[CR]...)", german="([CS:N]Reptain[CR]...)", italian="([CS:N]Grovyle[CR]...)", spanish="([CS:N]Grovyle[CR]...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_ANOTHER_GLOWING_NOISE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(32), g.ViewCenter.Y+(0), 32, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The sound of the Rainbow\nStoneship...", french="Le bruit du Vaisseau\nArc-en-Ciel...", german="Das Geräusch des\nRegenbogen-Steinschiffs...", italian="Il rumore del Vascello\nArcobaleno...", spanish=" La Barca Arcoiris..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The sound of the Rainbow\nStoneship...", french="Le bruit du Vaisseau\nArc-en-Ciel...", german="Das Geräusch des\nRegenbogen-Steinschiffs...", italian="Il rumore del Vascello\nArcobaleno...", spanish=" La Barca Arcoiris..."})
  else
  SkySceneKit.say({english="The sound of the Rainbow\nStoneship...", french="Le bruit du Vaisseau\nArc-en-Ciel...", german="Das Geräusch des\nRegenbogen-Steinschiffs...", italian="Il rumore del Vascello\nArcobaleno...", spanish=" La Barca Arcoiris..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's getting louder!)", french="(Il devient plus fort!)", german="(Es wird lauter!)", italian="(Sta crescendo d'intensità!)", spanish="(¡El ruido cada vez es mayor!)"})
  else
  SkySceneKit.say({english="(It's getting louder!)", french="(Il devient plus fort!)", german="(Es wird lauter!)", italian="(Sta crescendo d'intensità!)", spanish="(¡El ruido cada vez es mayor!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...[K]The Rainbow Stoneship...)", french="(...[K] Le Vaisseau Arc-en-Ciel...)", german="(...[K]Das Regenbogen-Steinschiff...)", italian="(...[K] Il Vascello Arcobaleno...)", spanish="(La...[K] Barca Arcoiris...)"})
  else
  SkySceneKit.say({english="(...[K]The Rainbow Stoneship...)", french="(...[K] Le Vaisseau Arc-en-Ciel...)", german="(...[K]Das Regenbogen-Steinschiff...)", italian="(...[K] Il Vascello Arcobaleno...)", spanish="(La...[K] Barca Arcoiris...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It looks like it's gonna move...)", french="(On dirait qu'il va bouger...)", german="(Sieht aus, als ob es sich bewegen würde...)", italian="(Pare che stia per partire...)", spanish="(Parece estar a punto de moverse...)"})
  else
  SkySceneKit.say({english="(It looks like it's ready to go...)", french="(On dirait qu'il va bouger...)", german="(Sieht aus, als ob es bereit zur Abfahrt ist...)", italian="(Pare che sia pronto a partire...)", spanish="(Parece lista para zarpar...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey...\n[CS:N]Grovyle[CR]...", french="Hé...\n[CS:N]Massko[CR]...", german="Hey...\n[CS:N]Reptain[CR]...", italian="Ehi...\n[CS:N]Grovyle[CR]...", spanish=" Eh... [CS:N]Grovyle[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But...\n[CS:N]Grovyle[CR]...", french="Hé...\n[CS:N]Massko[CR]...", german="Aber...\n[CS:N]Reptain[CR]...", italian="Ma...\n[CS:N]Grovyle[CR]...", spanish=" Pero... [CS:N]Grovyle[CR]..."})
  else
  SkySceneKit.say({english="Ummm...\n[CS:N]Grovyle[CR]...", french="Hé...\n[CS:N]Massko[CR]...", german="Hmmm...\n[CS:N]Reptain[CR]...", italian="Uhm...\n[CS:N]Grovyle[CR]...", spanish=" Hum... [CS:N]Grovyle[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[CS:N]Grovyle[CR]...", french=" ... [CS:N]Massko[CR]...", german=" ...[CS:N]Reptain[CR]...", italian=" ... [CS:N]Grovyle[CR]...", spanish=" [CS:N]Grovyle[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[CS:N]Grovyle[CR]...", french=" ... [CS:N]Massko[CR]...", german=" ...[CS:N]Reptain[CR]...", italian=" ... [CS:N]Grovyle[CR]...", spanish=" [CS:N]Grovyle[CR]..."})
  else
  SkySceneKit.say({english=" ...[CS:N]Grovyle[CR]...", french=" ... [CS:N]Massko[CR]...", german=" ...[CS:N]Reptain[CR]...", italian=" ... [CS:N]Grovyle[CR]...", spanish=" [CS:N]Grovyle[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[K]Sigh...", french=" ...[K] C'est si triste...", german=" ...[K]Seufz...", italian=" ...[K] Sniff...", spanish=" Ay...[K] Vaya..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[K]It's sad...", french=" ...[K] C'est si triste...", german=" ...[K]Das ist traurig...", italian=" ...[K] Com'è triste...", spanish=" Qué...[K] Qué pena..."})
  else
  SkySceneKit.say({english=" ...[K]So sad...", french=" ...[K] C'est si triste...", german=" ...[K]So ergreifend...", italian=" ...[K] Che tristezza...", spanish=" Qué...[K] Qué lástima..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I don't even want...[K]\nwant to move...", french="C'est trop triste...[K]\nJe n'ai plus envie d'avancer...", german="Ich möchte mich nicht einmal...[K]\nmehr bewegen...", italian="Le mie gambe...[K]\nrifiutano di muoversi...", spanish="Es que no quiero...[K]\nNo quiero ni moverme..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm too sad...[K]\nto even move...", french="C'est trop triste...[K]\nJe n'ai plus envie d'avancer...", german="Ich bin zu traurig...[K]\nZu traurig, um mich zu bewegen...", italian="Sono troppo triste...[K]\nNon voglio partire...", spanish="Estoy demasiado triste...[K]\npara moverme..."})
  else
  SkySceneKit.say({english="I don't want to go...[K]\nI'm too upset.", french="C'est trop triste...[K]\nJe n'ai plus envie d'avancer...", german="Ich möchte nicht gehen...[K]\nIch bin zu aufgebracht.", italian="Non voglio andare...[K]\nIl mio cuore è gonfio di tristezza.", spanish="No quiero irme...[K]\nEstoy demasiado triste."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[K]But...", french=" ...[K] Mais...", german=" ...[K]Aber...", italian=" ...[K] Ma...", spanish=" Ay...[K] Pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[K]But...", french=" ...[K] Mais...", german=" ...[K]Aber...", italian=" ...[K] Ma...", spanish=" Ay...[K] Pero..."})
  else
  SkySceneKit.say({english=" ...[K]But...", french=" ...[K] Mais...", german=" ...[K]Aber...", italian=" ...[K] Ma...", spanish=" Ay...[K] Pero..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Right...)", french="(Très bien...)", german="(Na klar...)", italian="(OK...)", spanish="(Exacto...)"})
  else
  SkySceneKit.say({english="(Right...)", french="(Très bien...)", german="(Na klar...)", italian="(Bene...)", spanish="(Exacto...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(If we don't hurry...)", french="(Si on ne se dépêche pas...)", german="(Wenn wir uns nicht beeilen...)", italian="(Se non ci sbrighiamo...)", spanish="(Si no nos damos prisa...)"})
  else
  SkySceneKit.say({english="(If we don't hurry...)", french="(Si on ne se dépêche pas...)", german="(Wenn wir uns nicht beeilen...)", italian="(Se non ci sbrighiamo...)", spanish="(Si no nos apresuramos...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(If we don't hurry, the Rainbow Stoneship\nmight just leave without us...)", french="(Si on ne se dépêche pas, le Vaisseau\nArc-en-Ciel risque de partir sans nous...)", german="(Wenn wir uns nicht beeilen, könnte das\nRegenbogen-Steinschiff ohne uns abfahren...)", italian="(Se non ci sbrighiamo, il Vascello Arcobaleno\nprenderà il volo senza di noi...)", spanish="(Si no nos apresuramos, puede que la Barca\nArcoiris zarpe sin esperarnos...)"})
  else
  SkySceneKit.say({english="(If we don't hurry, the Rainbow Stoneship\nmight go without us...)", french="(Si on ne se dépêche pas, le Vaisseau\nArc-en-Ciel risque de partir sans nous...)", german="(Wenn wir uns nicht beeilen, könnte das\nRegenbogen-Steinschiff ohne uns abfahren...)", italian="(Se non ci sbrighiamo, il Vascello Arcobaleno\npartirà senza di noi...)", spanish="(Si no nos apresuramos, puede que la Barca\nArcoiris zarpe sin esperarnos...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...[K][CS:N]Grovyle[CR]...)", french="(...[K] [CS:N]Massko[CR]...)", german="(...[K][CS:N]Reptain[CR]...)", italian="(...[K] [CS:N]Grovyle[CR]...)", spanish="(Uf...[K] [CS:N]Grovyle[CR]...)"})
  else
  SkySceneKit.say({english="(...[K][CS:N]Grovyle[CR]...)", french="(...[K] [CS:N]Massko[CR]...)", german="(...[K][CS:N]Reptain[CR]...)", italian="(...[K] [CS:N]Grovyle[CR]...)", spanish="(Uf...[K] [CS:N]Grovyle[CR]...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I may be sad...[K] But right now...)", french="(Soit, je suis triste...[K] Mais je dois le faire...)", german="(Ich mag traurig sein...[K] Aber jetzt...)", italian="(Sono triste...[K] ma ora...)", spanish="(Puede que esté triste,[K] pero ahora...)"})
  else
  SkySceneKit.say({english="(Even though I'm sad...[K] I have to do this...)", french="(Soit, je suis triste...[K] Mais je dois le faire...)", german="(Auch wenn ich traurig bin...[K] Es muss sein...)", italian="(Sono così triste...[K] ma devo farlo...)", spanish="(Aunque esté triste...[K] debo hacer esto...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(90)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  else
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We gotta go...", french=" On devrait y aller...", german=" Wir müssen los...", italian=" Dobbiamo andare...", spanish=" Tenemos que irnos..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We'd better go...", french=" On devrait y aller...", german=" Lass uns besser gehen...", italian=" Faremmo meglio ad andare...", spanish=" Será mejor que nos vayamos..."})
  else
  SkySceneKit.say({english=" We should go...", french=" On devrait y aller...", german=" Wir sollten los...", italian=" È ora di andare...", spanish=" Deberíamos irnos..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[K]The Time Gears...", french=" ...[K] Les Rouages du Temps...", german=" ...[K]Die Zahnräder der Zeit...", italian=" ...[K] Gli Ingranaggi del Tempo...", spanish=" Ah...[K] Los Engranajes del Tiempo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[K]The Time Gears...", french=" ...[K] Les Rouages du Temps...", german=" ...[K]Die Zahnräder der Zeit...", italian=" ...[K] Gli Ingranaggi del Tempo...", spanish=" Ah...[K] Los Engranajes del Tiempo."})
  else
  SkySceneKit.say({english=" ...[K]The Time Gears...", french=" ...[K] Les Rouages du Temps...", german=" ...[K]Die Zahnräder der Zeit...", italian=" ...[K] Gli Ingranaggi del Tempo...", spanish=" Ah...[K] Los Engranajes del Tiempo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The Time Gears...[K] I'd better\ngather them up.", french="Les Rouages du Temps...[K]\nJe ferais mieux de les récupérer.", german="Die Zahnräder der Zeit...[K] Ich\nsammle sie besser ein.", italian="Gli Ingranaggi del Tempo...[K]\nFarò meglio a raccoglierli.", spanish=" Será mejor...[K] que los recoja."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The Time Gears...[K] I'd better\ngather them up.", french="Les Rouages du Temps...[K]\nJe ferais mieux de les récupérer.", german="Die Zahnräder der Zeit...[K] Ich\nsammle sie besser ein.", italian="Gli Ingranaggi del Tempo...[K]\nFarò meglio a raccoglierli.", spanish=" Será mejor...[K] que los recoja."})
  else
  SkySceneKit.say({english="The Time Gears...[K] I'd better\ngather them up.", french="Les Rouages du Temps...[K]\nJe ferais mieux de les récupérer.", german="Die Zahnräder der Zeit...[K] Ich\nsammle sie besser ein.", italian="Gli Ingranaggi del Tempo...[K]\nFarò meglio a raccoglierli.", spanish=" Será mejor...[K] que los recoja."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(90)
  GROUND:MoveToPosition(partner, 228, 188, false, 2)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Wait for us in the future,\n[CS:N]Grovyle[CR]!", french="Attends-nous dans le futur,\n[CS:N]Massko[CR]!", german="Warte auf uns in der Zukunft,\n[CS:N]Reptain[CR]!", italian=" Aspettaci nel futuro, [CS:N]Grovyle[CR]!", spanish="¡Piensa en nosotros en el futuro,\n[CS:N]Grovyle[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wait for us in the future,\n[CS:N]Grovyle[CR]!", french="Attends-nous dans le futur,\n[CS:N]Massko[CR]!", german="Warte auf uns in der Zukunft,\n[CS:N]Reptain[CR]!", italian=" Aspettaci nel futuro, [CS:N]Grovyle[CR]!", spanish="¡Piensa en nosotros en el futuro,\n[CS:N]Grovyle[CR]!"})
  else
  SkySceneKit.say({english="Wait for us in the future,\n[CS:N]Grovyle[CR]!", french="Attends-nous dans le futur,\n[CS:N]Massko[CR]!", german="Warte auf uns in der Zukunft,\n[CS:N]Reptain[CR]!", italian=" Aspettaci nel futuro, [CS:N]Grovyle[CR]!", spanish="¡Recuérdanos en el futuro,\n[CS:N]Grovyle[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We'll stop the planet's\nparalysis...", french="On empêchera la Paralysie\nde la Planète...", german="Wir werden die Lähmung des\nPlaneten aufhalten.", italian="Fermeremo la paralisi del\npianeta...", spanish="Detendremos la parálisis del\nplaneta."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We'll stop the planet's\nparalysis...", french="On empêchera la Paralysie\nde la Planète...", german="Wir werden die Lähmung des\nPlaneten aufhalten.", italian="Fermeremo la paralisi del\npianeta...", spanish="Detendremos la parálisis del\nplaneta."})
  else
  SkySceneKit.say({english="We'll stop the planet's\nparalysis...", french="On empêchera la Paralysie\nde la Planète...", german="Wir werden die Lähmung des\nPlaneten aufhalten.", italian="Fermeremo la paralisi del\npianeta...", spanish="Detendremos la parálisis del\nplaneta."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We'll change the future into a\nbetter world.", french="Et on fera du futur un monde\nmeilleur.", german="Wir werden die Zukunft in eine\nbessere Welt verwandeln.", italian="Daremo al mondo un futuro\nmigliore.", spanish="Haremos del futuro un lugar\nmejor."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We'll change the future into a\nbetter world.", french="Et on fera du futur un monde\nmeilleur.", german="Wir werden die Zukunft in eine\nbessere Welt verwandeln.", italian="Daremo al mondo un futuro\nmigliore.", spanish="Haremos del futuro un lugar\nmejor."})
  else
  SkySceneKit.say({english="We'll change the future into a\nbetter world.", french="Et on fera du futur un monde\nmeilleur.", german="Wir werden die Zukunft in eine\nbessere Welt verwandeln.", italian="Daremo al mondo un futuro\nmigliore.", spanish="Haremos del futuro un lugar\nmejor."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="A world in which [CS:N]Grovyle[CR] can\nlive happily![K] We won't fail!", french="Un monde dans lequel [CS:N]Massko[CR]\npourra vivre heureux![K] On y arrivera!", german="Eine Welt, in der [CS:N]Reptain[CR]\nglücklich und zufrieden leben kann![K] Wir\nwerden nicht scheitern!", italian="Un futuro in cui [CS:N]Grovyle[CR] potrà\nvivere felice![K] Non falliremo!", spanish="¡Un mundo en el que [CS:N]Grovyle[CR]\npueda vivir feliz![K] ¡No fallaremos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="A world in which [CS:N]Grovyle[CR] can\nlive happily![K] We won't fail!", french="Un monde dans lequel [CS:N]Massko[CR]\npourra vivre heureux![K] On y arrivera!", german="Eine Welt, in der [CS:N]Reptain[CR]\nglücklich und zufrieden leben kann![K] Wir\nwerden nicht scheitern!", italian="Un futuro in cui [CS:N]Grovyle[CR] potrà\nvivere felice![K] Non falliremo!", spanish="¡Un mundo en el que [CS:N]Grovyle[CR]\npueda vivir feliz![K] ¡No fallaremos!"})
  else
  SkySceneKit.say({english="A world in which [CS:N]Grovyle[CR] can\nlive happily![K] We won't fail!", french="Un monde dans lequel [CS:N]Massko[CR]\npourra vivre heureux![K] On y arrivera!", german="Eine Welt, in der [CS:N]Reptain[CR]\nglücklich und zufrieden leben kann![K] Wir\nwerden nicht scheitern!", italian="Un futuro in cui [CS:N]Grovyle[CR] potrà\nvivere felice![K] Non falliremo!", spanish="¡Un mundo en el que [CS:N]Grovyle[CR]\npueda vivir feliz![K] ¡No fallaremos!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 252, 196, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But...)", french="(Mais...)", german="(Aber...)", italian="(Ma...)", spanish="(Pero...)"})
  else
  SkySceneKit.say({english="(But...)", french="(Mais...)", german="(Aber...)", italian="(Ma...)", spanish="(Pero...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What [CS:N]Dusknoir[CR] said...)", french="(Ce qu'a dit [CS:N]Noctunoir[CR]...)", german="(Was [CS:N]Zwirrfinst[CR] sagte...)", italian="(Quello che ha detto [CS:N]Dusknoir[CR]...)", spanish="(Según lo que dijo [CS:N]Dusknoir[CR]...)"})
  else
  SkySceneKit.say({english="(What [CS:N]Dusknoir[CR] said...)", french="(Ce qu'a dit [CS:N]Noctunoir[CR]...)", german="(Was [CS:N]Zwirrfinst[CR] sagte...)", italian="(Quello che ha detto [CS:N]Dusknoir[CR]...)", spanish="(Según lo que dijo [CS:N]Dusknoir[CR]...)"})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
