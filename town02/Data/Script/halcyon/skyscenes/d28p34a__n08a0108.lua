-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D28P34A/n08a0108.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  if true --[[BranchDebug: retail EU]] then -- if ROM: not debug
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][CS:Y]Grovyle[CR], who came from the future to\n[CN]prevent the planet's paralysis...", french="[CN]Venu du futur pour empêcher la Paralysie\n[CN]de la Planète, [CS:Y]Massko[CR]...", german="[CN][CS:Y]Reptain[CR], der aus der Zukunft kam,\n[CN]um die Lähmung des Planeten zu verhindern...", italian="[CN][CS:Y]Grovyle[CR], giunto dal futuro per\n[CN]impedire la paralisi del pianeta...", spanish="[CN][CS:Y]Grovyle[CR] vino del futuro para\n[CN]evitar la parálisis del planeta..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Collected the Time Gears...", french="[CN]... rassembla les Rouages du Temps...", german="[CN]Er sammelte die Zahnräder der Zeit...", italian="[CN]... ha raccolto gli Ingranaggi del Tempo...", spanish="[CN]Reunió los Engranajes del Tiempo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]And together with [c_name:NPC_HERO_FIRST]\n[CN]and [c_name:NPC_PARTNER_FIRST]...", french="[CN]... et, en compagnie de [c_name:NPC_HERO_FIRST]\n[CN]et [c_name:NPC_PARTNER_FIRST]...", german="[CN]Gemeinsam mit [c_name:NPC_HERO_FIRST]\n[CN]und [c_name:NPC_PARTNER_FIRST]...", italian="[CN]... e insieme a [c_name:NPC_HERO_FIRST]\n[CN]e a [c_name:NPC_PARTNER_FIRST]...", spanish="[CN]Y junto con [c_name:NPC_HERO_FIRST]\n[CN]y [c_name:NPC_PARTNER_FIRST]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Made his way to [CS:N]Dialga[CR]'s\n[CN][CS:P]Temporal Tower[CR].", french="[CN]... regagna la [CS:P]Tour du Temps[CR] de [CS:N]Dialga[CR].", german="[CN]Zusammen erreichten sie den\n[CN][CS:P]Zeitturm[CR] von [CS:N]Dialga[CR].", italian="[CN]... ha raggiunto la [CS:P]Torre del Tempo[CR] di [CS:N]Dialga[CR].", spanish="[CN]Consiguió llegar hasta la\n[CN][CS:P]Torre del Tiempo[CR] de [CS:N]Dialga[CR]."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]However...", french="[CN]Cependant...", german="[CN]Dort angekommen...", italian="[CN]Tuttavia...", spanish="[CN]Sin embargo..."})
  -- message_Close
  GAME:FadeOut(false,  0)
  GAME:FadeIn(0)
  -- back_SetGround(LEVEL_D28P34A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  pcall(function() GAME:MoveCamera(396, 248, 1, false) end) -- SetPositionMark performer/caméra
  GROUND:TeleportTo(hero, 396, 264, Direction.Down)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 424, 216, Direction.UpRight, "NPC_JUPUTORU")
  GROUND:TeleportTo(npc_npc_juputoru, 356, 228, Direction.Down)
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownRight)
  -- SetAnimation(68) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: SetEffect 653 — VFX sans émote PMDO équivalente
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 400, 208, Direction.Down, "NPC_YONOWAARU")
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
  GROUND:TeleportTo(npc_npc_juputoru, 396, 228, Direction.Down)
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
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Urrgggghhh!", french=" Aaaaaargggghhh!", german=" Urrgggghhh!", italian=" Urrgggghhh!", spanish=" ¡Aaah!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:Y]Grovyle[CR]!)", french="([CS:Y]Massko[CR]!)", german="([CS:Y]Reptain[CR]!)", italian="([CS:Y]Grovyle[CR]!)", spanish="(¡[CS:Y]Grovyle[CR]!)"})
  else
  SkySceneKit.say({english="([CS:Y]Grovyle[CR]!)", french="([CS:Y]Massko[CR]!)", german="([CS:Y]Reptain[CR]!)", italian="([CS:Y]Grovyle[CR]!)", spanish="(¡[CS:Y]Grovyle[CR]!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="So you shielded [c_name:NPC_HERO_FIRST],\n[CS:Y]Grovyle[CR]?!", french="Alors tu t'es sacrifié pour\n[c_name:NPC_HERO_FIRST], [CS:Y]Massko[CR]?!", german="Du hast [c_name:NPC_HERO_FIRST] geschützt,\n[CS:Y]Reptain[CR]?!?", italian="E così hai fatto da scudo\na [c_name:NPC_HERO_FIRST], [CS:Y]Grovyle[CR]?!", spanish="¿Así que has protegido\na [c_name:NPC_HERO_FIRST], [CS:Y]Grovyle[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" That's taken a heavy toll on you!", french=" Cela t'a coûté cher!", german=" Das hat dir schwer zugesetzt!", italian=" Ti costerà caro!", spanish="Como ves, no ha sido una buena\nidea."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Very well![K] You're going\ndown first!", french="Fort bien![K] Tu seras donc\nle premier à disparaître!", german="Sehr gut![K] Du trittst als Erster\nab!", italian="Molto bene![K] Mi occuperò prima\ndi te!", spanish="¡Como quieras![K]\n¡Tú caerás primero!"})
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
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Uwroh...[K] Wrooooooooh!", french=" Grrr...[K] Rooooooooh!", german=" Uwroh...[K] Wrooooooooh!", italian=" Uoooh...[K] Uoooooooooh!", spanish=" Ay...[K] ¡Nooooo!"})
  -- message_Close
  -- GAP: se_Play(7686) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(npc_npc_juputoru, 396, 204, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  -- SetAnimation(52) [anim idle native]
  -- SetAnimation(55) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() GAME:MoveCamera(396, 212, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_yonowaaru, 396, 180, false, 1) -- SlidePositionMark (glissement)
  GROUND:MoveToPosition(npc_npc_juputoru, 396, 180, false, 1)
  GAME:WaitFrames(45)
  GROUND:MoveToPosition(hero, 396, 228, false, 2)
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
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Urrggh...[K] [CS:N]Dusknoir[CR]!", french=" Arrggh...[K] [CS:N]Noctunoir[CR]!", german=" Arrggh...[K] [CS:N]Zwirrfinst[CR]!", italian=" Urrggh...[K] [CS:N]Dusknoir[CR]!", spanish=" Grrr...[K] ¡[CS:N]Dusknoir[CR]!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I'm...[K] I'm taking you with me...", french=" Je...[K] je t'emmène avec moi...", german=" Ich...[K] Ich nehme dich mit mir...", italian=" Ti...[K] porto via con me...", spanish=" Nos...[K] Nos vamos juntos..."})
  pcall(function() UI:SetSpeaker(hero) end)
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
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[c_name:NPC_HERO_FIRST]![K] It's up to\nyou now!", french="[c_name:NPC_HERO_FIRST]![K] A toi de jouer\nmaintenant!", german="[c_name:NPC_HERO_FIRST]![K] Es liegt jetzt an\ndir!", italian="[c_name:NPC_HERO_FIRST]![K] Dipende tutto da\nte, ora!", spanish="¡[c_name:NPC_HERO_FIRST]![K]\n¡Ahora todo depende de ti!"})
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
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_NPC_PARTNER_FIRST)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="All right, team![K] The Rainbow\nStoneship's set to go!", french="C'est bon, vous autres![K]\nLe Vaisseau Arc-en-Ciel est prêt à partir!", german="Alles klar, Team![K]\nDas Regenbogen-Steinschiff ist abfahrbereit!", italian="Va bene, squadra![K] Il Vascello\nArcobaleno è pronto a partire!", spanish="¡Muy bien, equipo![K]\n¡La Barca Arcoiris está lista para partir!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="OK, team![K] The Rainbow\nStoneship's set to go!", french="C'est bon, vous autres![K]\nLe Vaisseau Arc-en-Ciel est prêt à partir!", german="Okay, Team![K]\nDas Regenbogen-Steinschiff ist abfahrbereit!", italian="Va bene, squadra![K] Il Vascello\nArcobaleno è pronto a partire!", spanish="¡Muy bien, equipo![K]\n¡La Barca Arcoiris está lista para partir!"})
  else
  SkySceneKit.say({english="OK, team![K] The Rainbow\nStoneship's set to go!", french="C'est bon, vous autres![K]\nLe Vaisseau Arc-en-Ciel est prêt à partir!", german="Okay, Team![K]\nDas Regenbogen-Steinschiff ist abfahrbereit!", italian="Va bene, squadra![K] Il Vascello\nArcobaleno è pronto a partire!", spanish="¡Muy bien, equipo![K]\n¡La Barca Arcoiris está lista para partir!"})
  end
  -- message_Close
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:MoveToPosition(partner, 316, 228, false, 2)
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
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [c_name:NPC_PARTNER_FIRST]![K] This is it for me!", french="[c_name:NPC_PARTNER_FIRST]![K] C'est ici que\nnos chemins se séparent!", german="[c_name:NPC_PARTNER_FIRST]![K] Ende der\nFahnenstange!", italian=" [c_name:NPC_PARTNER_FIRST]![K] A lui ci penso io!", spanish="¡[c_name:NPC_PARTNER_FIRST]![K]\n¡Aquí nos despedimos!"})
  pcall(function() UI:SetSpeaker(hero) end)
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
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I can never come back\nhere again.", french="Je ne pourrai plus jamais\nrevenir.", german="Ich kann niemals mehr hierher\nzurückkommen.", italian=" Non tornerò mai più.", spanish=" No regresaré."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Watch [c_name:NPC_HERO_FIRST]'s back...[K]\nPromise me!", french="Prends soin de [c_name:NPC_HERO_FIRST]\npour moi...[K] Promets-le-moi!", german="Pass gut auf [c_name:NPC_HERO_FIRST]\nauf...[K] Versprich mir das!", italian="Prenditi cura di [c_name:NPC_HERO_FIRST]...[K]\nPromettimelo!", spanish="Cuida de [c_name:NPC_HERO_FIRST]...[K]\n¡Prométemelo!"})
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
  SkySceneKit.say({english="Take your place, [CS:Y]Grovyle[CR]...?[K]\nI can't!", french="Prendre ta place, [CS:Y]Massko[CR]...?[K]\nJe ne peux pas faire ça!", german="Deinen Platz einnehmen,\n[CS:Y]Reptain[CR]?[K] Das kann ich nicht!", italian="Prendere il tuo posto,\n[CS:Y]Grovyle[CR]...?[K] Non posso!", spanish="¿Quieres que ocupe tu lugar,\n[CS:Y]Grovyle[CR]?[K] ¡No puedo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Take your place, [CS:Y]Grovyle[CR]...?[K]\nI can't!", french="Prendre ta place, [CS:Y]Massko[CR]...?[K]\nJe ne peux pas faire ça!", german="Deinen Platz einnehmen,\n[CS:Y]Reptain[CR]?[K] Das kann ich nicht!", italian="Prendere il tuo posto,\n[CS:Y]Grovyle[CR]...?[K] Non posso!", spanish="¿Quieres que ocupe tu lugar,\n[CS:Y]Grovyle[CR]?[K] ¡No puedo!"})
  else
  SkySceneKit.say({english="Take your place, [CS:Y]Grovyle[CR]...?[K]\nI can't!", french="Prendre ta place, [CS:Y]Massko[CR]...?[K]\nJe ne peux pas faire ça!", german="Deinen Platz einnehmen,\n[CS:Y]Reptain[CR]?[K] Das kann ich nicht!", italian="Prendere il tuo posto,\n[CS:Y]Grovyle[CR]...?[K] Non posso!", spanish="¿Quieres que ocupe tu lugar,\n[CS:Y]Grovyle[CR]?[K] ¡No puedo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="You must and you will.[K] Because\nyou can, [c_name:NPC_PARTNER_FIRST].", french="Tu le dois et tu le feras.[K] Parce\nque tu en es capable, [c_name:NPC_PARTNER_FIRST].", german="Du musst und du wirst.[K] Weil du\nes kannst, [c_name:NPC_PARTNER_FIRST].", italian="Devi farlo e lo farai.[K] Perché\nne sei in grado, [c_name:NPC_PARTNER_FIRST].", spanish="Debes hacerlo, y lo harás...[K]\nporque puedes, [c_name:NPC_PARTNER_FIRST]."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="You two are...[K]the greatest of\ncombinations.", french="Vous faites...[K] une équipe\nhors pair.", german="Ihr beide seid...[K] das beste\nGespann, das es gibt.", italian="Voi due siete...[K] un'accoppiata\nmagnifica!", spanish="Cuando actuáis en equipo...[K]\nNo hay rival que os haga sombra."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Gwoh! Unhand me![K] Release me!", french="Argh! Lâche-moi![K] Mais tu vas\nme lâcher à la fin!", german="Gwoh! Lass mich los![K]\nLass mich gehen!", italian=" Oooh! Lasciami![K] Mollami!", spanish="¡Suéltame![K]\n¡Quítame las manos de encima!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(32) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" We're almost there![K] Quiet!", french=" Du calme![K] On y est presque!", german=" Wir sind fast da![K] Ruhe!", italian=" Ci siamo quasi![K] Stai calmo!", spanish="No tengas tanta prisa.[K]\n¡Y cállate!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...[c_name:NPC_HERO_FIRST]!", french=" ... [c_name:NPC_HERO_FIRST]!", german=" ...[c_name:NPC_HERO_FIRST]!", italian=" ... [c_name:NPC_HERO_FIRST]!", spanish=" ¡[c_name:NPC_HERO_FIRST]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- SetAnimation(33) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Take care, [c_name:NPC_HERO_FIRST].", french="Fais attention à toi,\n[c_name:NPC_HERO_FIRST].", german=" Lebe wohl, [c_name:NPC_HERO_FIRST].", italian=" In gamba, [c_name:NPC_HERO_FIRST].", spanish=" Cuídate, [c_name:NPC_HERO_FIRST]."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I was lucky to have known you.", french="J'ai eu de la chance\nde te connaître.", german="Ich bin froh, dich gekannt zu\nhaben.", italian=" È stata una fortuna conoscerti.", spanish="Ha sido una suerte haberte\nconocido."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Though the parting hurts...[K]\nThe rest is in your hands!", french="Ecoute-moi bien... La séparation\nest toujours douloureuse...[K] mais les larmes\ndevront attendre!", german="Auch wenn die Trennung\nschmerzt...[K] Der Rest liegt in deiner Hand!", italian="Certo, gli addii sono dolorosi...[K]\nMa ora è tutto nelle tue mani!", spanish="Separarse es duro...[K]\n¡Lo dejo todo en tus manos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:Y]Grovyle[CR]!)", french="([CS:Y]Massko[CR]!)", german="([CS:Y]Reptain[CR]!)", italian="([CS:Y]Grovyle[CR]!)", spanish="(¡[CS:Y]Grovyle[CR]!)"})
  else
  SkySceneKit.say({english="([CS:Y]Grovyle[CR]!)", french="([CS:Y]Massko[CR]!)", german="([CS:Y]Reptain[CR]!)", italian="([CS:Y]Grovyle[CR]!)", spanish="(¡[CS:Y]Grovyle[CR]!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(32) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(hero) end)
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
  GAME:WaitFrames(90)
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  -- GAP: BGM BGM_IN_THE_HANDS_OF_FATE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CN]After entrusting his mission to his friends...", french="[CN]Après avoir confié sa mission à ses acolytes...", german="[CN]Die Mission vertraute er\n[CN]seinen Freunden an.", italian="[CN]Dopo aver affidato la missione ai suoi amici...", spanish="[CN]Tras confiar su misión a sus amigos..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CN][CS:Y]Grovyle[CR] returned to\n[CN]the future.", french="[CN]... [CS:Y]Massko[CR] repartit dans le futur.", german="[CN]Dann kehrte [CS:Y]Reptain[CR]\n[CN]in die Zukunft zurück.", italian="[CN][CS:Y]Grovyle[CR] è ritornato\n[CN]nel futuro.", spanish="[CN][CS:Y]Grovyle[CR] regresó al futuro."})
  -- message_Close
  -- GAP: SetEffect 653 — VFX sans émote PMDO équivalente
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh... [CS:Y]Grovyle[CR]...[K] Why...?", french=" Argh... [CS:Y]Massko[CR]...[K] Pourquoi...?", german=" Uff... [CS:Y]Reptain[CR]...[K] Warum?", italian=" Uh... [CS:Y]Grovyle[CR]...[K] Perché...?", spanish=" No... [CS:Y]Grovyle[CR]...[K] ¿Por qué...?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh... [CS:Y]Grovyle[CR]...[K] Why...?", french=" Argh... [CS:Y]Massko[CR]...[K] Pourquoi...?", german=" Uff... [CS:Y]Reptain[CR]...[K] Warum?", italian=" Uh... [CS:Y]Grovyle[CR]...[K] Perché...?", spanish=" No... [CS:Y]Grovyle[CR]...[K] ¿Por qué...?"})
  else
  SkySceneKit.say({english=" Ugh... [CS:Y]Grovyle[CR]...[K] Why...?", french=" Argh... [CS:Y]Massko[CR]...[K] Pourquoi...?", german=" Uff... [CS:Y]Reptain[CR]...[K] Warum?", italian=" Uh... [CS:Y]Grovyle[CR]...[K] Perché...?", spanish=" No... [CS:Y]Grovyle[CR]...[K] ¿Por qué...?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:Y]Grovyle[CR]...)", french="([CS:Y]Massko[CR]...)", german="([CS:Y]Reptain[CR]...)", italian="([CS:Y]Grovyle[CR]...)", spanish="([CS:Y]Grovyle[CR]...)"})
  else
  SkySceneKit.say({english="([CS:Y]Grovyle[CR]...)", french="([CS:Y]Massko[CR]...)", german="([CS:Y]Reptain[CR]...)", italian="([CS:Y]Grovyle[CR]...)", spanish="([CS:Y]Grovyle[CR]...)"})
  end
  -- message_Close
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Yet [c_name:NPC_HERO_FIRST] and [c_name:NPC_PARTNER_FIRST] were...", french="[CN]Pendant ce temps, [c_name:NPC_HERO_FIRST] et\n[CN][c_name:NPC_PARTNER_FIRST]...", german="[CN][c_name:NPC_HERO_FIRST] und [c_name:NPC_PARTNER_FIRST]...", italian="[CN]Tuttavia [c_name:NPC_HERO_FIRST] e [c_name:NPC_PARTNER_FIRST]...", spanish="[CN][c_name:NPC_HERO_FIRST] y [c_name:NPC_PARTNER_FIRST]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Desperately trying to contain their sorrow...", french="[CN]... essayaient désespérément de surmonter\n[CN]leur chagrin...", german="[CN]Sie versuchten verzweifelt, ihre Sorge\n[CN]zu unterdrücken...", italian="[CN]... cercavano disperatamente\n[CN]di mascherare il loro dolore...", spanish="[CN]Trataban de contener\n[CN]su pesar a duras penas..."})
  -- message_Close
  pcall(function() GAME:MoveCamera(396, 212, 1, false) end) -- SetPositionMark performer/caméra
  GROUND:TeleportTo(hero, 396, 220, Direction.Down)
  GROUND:TeleportTo(partner, 420, 180, Direction.Down)
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.DownLeft)
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- GAP: SetEffect 653 — VFX sans émote PMDO équivalente
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(partner, 420, 220, false, 2)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(412, 212, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [c_name:NPC_HERO_FIRST]!", french=" Eh, [c_name:NPC_HERO_FIRST]!", german=" Hey, [c_name:NPC_HERO_FIRST]!", italian=" Ehi, [c_name:NPC_HERO_FIRST]!", spanish=" ¡Oye, [c_name:NPC_HERO_FIRST]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey, [c_name:NPC_HERO_FIRST]!", french=" Eh, [c_name:NPC_HERO_FIRST]!", german=" Hey, [c_name:NPC_HERO_FIRST]!", italian=" Ehi, [c_name:NPC_HERO_FIRST]!", spanish=" ¡Oye, [c_name:NPC_HERO_FIRST]!"})
  else
  SkySceneKit.say({english=" Hey, [c_name:NPC_HERO_FIRST]!", french=" Eh, [c_name:NPC_HERO_FIRST]!", german=" Hey, [c_name:NPC_HERO_FIRST]!", italian=" Ehi, [c_name:NPC_HERO_FIRST]!", spanish=" ¡Oye, [c_name:NPC_HERO_FIRST]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to do this for [CS:Y]Grovyle[CR]'s\nsake![K] Let's go to [CS:P]Temporal Tower[CR]!", french="Il faut qu'on y arrive,\npour [CS:Y]Massko[CR]! C'est parti pour la [CS:P]Tour\ndu Temps[CR]!", german="Wir müssen das [CS:Y]Reptain[CR] zuliebe\ntun! Gehen wir zum [CS:P]Zeitturm[CR]!", italian="Dobbiamo farlo per [CS:Y]Grovyle[CR]!\nAndiamo alla [CS:P]Torre del Tempo[CR]!", spanish="¡Tenemos que hacer esto por\n[CS:Y]Grovyle[CR]! ¡Vamos a la [CS:P]Torre del Tiempo[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to do this for [CS:Y]Grovyle[CR]'s\nsake![K] Let's go to [CS:P]Temporal Tower[CR]!", french="Il faut qu'on y arrive,\npour [CS:Y]Massko[CR]! C'est parti pour la [CS:P]Tour\ndu Temps[CR]!", german="Wir müssen das [CS:Y]Reptain[CR] zuliebe\ntun! Gehen wir zum [CS:P]Zeitturm[CR]!", italian="Dobbiamo farlo per [CS:Y]Grovyle[CR]!\nAndiamo alla [CS:P]Torre del Tempo[CR]!", spanish="¡Tenemos que hacer esto por\n[CS:Y]Grovyle[CR]! ¡Vamos a la [CS:P]Torre del Tiempo[CR]!"})
  else
  SkySceneKit.say({english="We have to do this for [CS:Y]Grovyle[CR]'s\nsake![K] Let's go to [CS:P]Temporal Tower[CR]!", french="Il faut qu'on y arrive,\npour [CS:Y]Massko[CR]! C'est parti pour la [CS:P]Tour\ndu Temps[CR]!", german="Wir müssen das [CS:Y]Reptain[CR] zuliebe\ntun! Gehen wir zum [CS:P]Zeitturm[CR]!", italian="Dobbiamo farlo per [CS:Y]Grovyle[CR]!\nAndiamo alla [CS:P]Torre del Tempo[CR]!", spanish="¡Tenemos que hacer esto por\n[CS:Y]Grovyle[CR]! ¡Vamos a la [CS:P]Torre del Tiempo[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  GAME:FadeOut(false,  90)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]Filled with that sentiment...", french="[CN]Galvanisés par cette nouvelle résolution...", german="[CN]Das waren ihre Empfindungen...", italian="[CN]Spinti da questa convinzione...", spanish="[CN]Y con esa motivación..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]They set off on a final adventure...", french="[CN]... les deux Pokémon s'embarquèrent\n[CN]dans cette ultime aventure...", german="[CN]Und so machten sie sich auf den Weg\n[CN]zu ihrem letzten Abenteuer.", italian="[CN]... partono per la loro avventura decisiva.", spanish="[CN]Partieron hacia su aventura final."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]But then...", french="[CN]Cependant...", german="[CN]Aber es sollte anders kommen...", italian="[CN]Ma poi...", spanish="[CN]Pero..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]After having returned to the future\n[CN]with [CS:N]Dusknoir[CR]...", french="[CN]... après avoir regagné le futur en compagnie\n[CN]de [CS:N]Noctunoir[CR]...", german="[CN]Nachdem er mit [CS:N]Zwirrfinst[CR]\n[CN]in die Zukunft zurückgekehrt war...", italian="[CN]Dopo essere ritornato nel futuro\n[CN]con [CS:N]Dusknoir[CR]...", spanish="[CN]Tras haber regresado al futuro\n[CN]con [CS:N]Dusknoir[CR]..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][CS:Y]Grovyle[CR]...", french="[CN]... [CS:Y]Massko[CR]...", german="[CN]Da erwachte [CS:Y]Reptain[CR]...", italian="[CN][CS:Y]Grovyle[CR]...", spanish="[CN][CS:Y]Grovyle[CR]..."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(180) end)
  GAME:WaitFrames(180)
  else
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[M:D2][CS:C]Start from where?[CR]", french="[M:D2][CS:C]Start from where?[CR]", german="[M:D2][CS:C]Start from where?[CR]", italian="[M:D2][CS:C]Start from where?[CR]", spanish="[M:D2][CS:C]Start from where?[CR]"})
  do local __choice = SkySceneKit.ask({{english="[M:D2]Beginning", french="[M:D2]Beginning", german="[M:D2]Beginning", italian="[M:D2]Beginning", spanish="[M:D2]Beginning"}, {english="[M:D2]BarrenValley1stTry", french="[M:D2]BarrenValley1stTry", german="[M:D2]BarrenValley1stTry", italian="[M:D2]BarrenValley1stTry", spanish="[M:D2]BarrenValley1stTry"}, {english="[M:D2]BarrenValley2ndTry", french="[M:D2]BarrenValley2ndTry", german="[M:D2]BarrenValley2ndTry", italian="[M:D2]BarrenValley2ndTry", spanish="[M:D2]BarrenValley2ndTry"}, {english="[M:D2]BarrenValleyBoss2ndTry", french="[M:D2]BarrenValleyBoss2ndTry", german="[M:D2]BarrenValleyBoss2ndTry", italian="[M:D2]BarrenValleyBoss2ndTry", spanish="[M:D2]BarrenValleyBoss2ndTry"}, {english="[M:D2]BarrenValleyWaypoint", french="[M:D2]BarrenValleyWaypoint", german="[M:D2]BarrenValleyWaypoint", italian="[M:D2]BarrenValleyWaypoint", spanish="[M:D2]BarrenValleyWaypoint"}, {english="[M:D2]DarkWasteland1stTry", french="[M:D2]DarkWasteland1stTry", german="[M:D2]DarkWasteland1stTry", italian="[M:D2]DarkWasteland1stTry", spanish="[M:D2]DarkWasteland1stTry"}, {english="[M:D2]DarkWasteland2ndTry", french="[M:D2]DarkWasteland2ndTry", german="[M:D2]DarkWasteland2ndTry", italian="[M:D2]DarkWasteland2ndTry", spanish="[M:D2]DarkWasteland2ndTry"}, {english="[M:D2]TemporalTower1stTry", french="[M:D2]TemporalTower1stTry", german="[M:D2]TemporalTower1stTry", italian="[M:D2]TemporalTower1stTry", spanish="[M:D2]TemporalTower1stTry"}, {english="[M:D2]TemporalTower2ndTry", french="[M:D2]TemporalTower2ndTry", german="[M:D2]TemporalTower2ndTry", italian="[M:D2]TemporalTower2ndTry", spanish="[M:D2]TemporalTower2ndTry"}, {english="[M:D2]TemporalTower2-1stTry", french="[M:D2]TemporalTower2-1stTry", german="[M:D2]TemporalTower2-1stTry", italian="[M:D2]TemporalTower2-1stTry", spanish="[M:D2]TemporalTower2-1stTry"}, {english="[M:D2]TemporalTower2-2ndTry", french="[M:D2]TemporalTower2-2ndTry", german="[M:D2]TemporalTower2-2ndTry", italian="[M:D2]TemporalTower2-2ndTry", spanish="[M:D2]TemporalTower2-2ndTry"}, {english="[M:D2]DuskForest1stTry", french="[M:D2]DuskForest1stTry", german="[M:D2]DuskForest1stTry", italian="[M:D2]DuskForest1stTry", spanish="[M:D2]DuskForest1stTry"}, {english="[M:D2]DuskForest2ndTry", french="[M:D2]DuskForest2ndTry", german="[M:D2]DuskForest2ndTry", italian="[M:D2]DuskForest2ndTry", spanish="[M:D2]DuskForest2ndTry"}, {english="[M:D2]DuskForestBoss2ndTry", french="[M:D2]DuskForestBoss2ndTry", german="[M:D2]DuskForestBoss2ndTry", italian="[M:D2]DuskForestBoss2ndTry", spanish="[M:D2]DuskForestBoss2ndTry"}, {english="[M:D2]SpacialCliffs1stTry", french="[M:D2]SpacialCliffs1stTry", german="[M:D2]SpacialCliffs1stTry", italian="[M:D2]SpacialCliffs1stTry", spanish="[M:D2]SpacialCliffs1stTry"}, {english="[M:D2]SpacialCliffs2ndTry", french="[M:D2]SpacialCliffs2ndTry", german="[M:D2]SpacialCliffs2ndTry", italian="[M:D2]SpacialCliffs2ndTry", spanish="[M:D2]SpacialCliffs2ndTry"}, {english="[M:D2]DarkIceMountain1stTry", french="[M:D2]DarkIceMountain1stTry", german="[M:D2]DarkIceMountain1stTry", italian="[M:D2]DarkIceMountain1stTry", spanish="[M:D2]DarkIceMountain1stTry"}, {english="[M:D2]DarkIceMountain2ndTry", french="[M:D2]DarkIceMountain2ndTry", german="[M:D2]DarkIceMountain2ndTry", italian="[M:D2]DarkIceMountain2ndTry", spanish="[M:D2]DarkIceMountain2ndTry"}, {english="[M:D2]DarkIceMountain2-1stTry", french="[M:D2]DarkIceMountain2-1stTry", german="[M:D2]DarkIceMountain2-1stTry", italian="[M:D2]DarkIceMountain2-1stTry", spanish="[M:D2]DarkIceMountain2-1stTry"}, {english="[M:D2]DarkIceMountain2-2ndTry", french="[M:D2]DarkIceMountain2-2ndTry", german="[M:D2]DarkIceMountain2-2ndTry", italian="[M:D2]DarkIceMountain2-2ndTry", spanish="[M:D2]DarkIceMountain2-2ndTry"}, {english="[M:D2]DarkIceMountain2-Boss2ndTry", french="[M:D2]DarkIceMountain2-Boss2ndTry", german="[M:D2]DarkIceMountain2-Boss2ndTry", italian="[M:D2]DarkIceMountain2-Boss2ndTry", spanish="[M:D2]DarkIceMountain2-Boss2ndTry"}, {english="[M:D2]IcicleForest1stTry", french="[M:D2]IcicleForest1stTry", german="[M:D2]IcicleForest1stTry", italian="[M:D2]IcicleForest1stTry", spanish="[M:D2]IcicleForest1stTry"}, {english="[M:D2]IcicleForest2ndTry", french="[M:D2]IcicleForest2ndTry", german="[M:D2]IcicleForest2ndTry", italian="[M:D2]IcicleForest2ndTry", spanish="[M:D2]IcicleForest2ndTry"}, {english="[M:D2]VastIceMountain1stTry", french="[M:D2]VastIceMountain1stTry", german="[M:D2]VastIceMountain1stTry", italian="[M:D2]VastIceMountain1stTry", spanish="[M:D2]VastIceMountain1stTry"}, {english="[M:D2]VastIceMountain2ndTry", french="[M:D2]VastIceMountain2ndTry", german="[M:D2]VastIceMountain2ndTry", italian="[M:D2]VastIceMountain2ndTry", spanish="[M:D2]VastIceMountain2ndTry"}, {english="[M:D2]VastIceMountainBoss2ndTry", french="[M:D2]VastIceMountainBoss2ndTry", german="[M:D2]VastIceMountainBoss2ndTry", italian="[M:D2]VastIceMountainBoss2ndTry", spanish="[M:D2]VastIceMountainBoss2ndTry"}, {english="[M:D2]VastIceMountain2-1stTry", french="[M:D2]VastIceMountain2-1stTry", german="[M:D2]VastIceMountain2-1stTry", italian="[M:D2]VastIceMountain2-1stTry", spanish="[M:D2]VastIceMountain2-1stTry"}, {english="[M:D2]VastIceMountain2-2ndTry", french="[M:D2]VastIceMountain2-2ndTry", german="[M:D2]VastIceMountain2-2ndTry", italian="[M:D2]VastIceMountain2-2ndTry", spanish="[M:D2]VastIceMountain2-2ndTry"}, {english="[M:D2]VastIceMountain2-Boss2ndTry", french="[M:D2]VastIceMountain2-Boss2ndTry", german="[M:D2]VastIceMountain2-Boss2ndTry", italian="[M:D2]VastIceMountain2-Boss2ndTry", spanish="[M:D2]VastIceMountain2-Boss2ndTry"}, {english="[M:D2]TALK-N08-01", french="[M:D2]TALK-N08-01", german="[M:D2]TALK-N08-01", italian="[M:D2]TALK-N08-01", spanish="[M:D2]TALK-N08-01"}, {english="[M:D2]TALK-N08-02", french="[M:D2]TALK-N08-02", german="[M:D2]TALK-N08-02", italian="[M:D2]TALK-N08-02", spanish="[M:D2]TALK-N08-02"}, {english="[M:D2]TALK-N08-03", french="[M:D2]TALK-N08-03", german="[M:D2]TALK-N08-03", italian="[M:D2]TALK-N08-03", spanish="[M:D2]TALK-N08-03"}, {english="[M:D2]TALK-N08-04", french="[M:D2]TALK-N08-04", german="[M:D2]TALK-N08-04", italian="[M:D2]TALK-N08-04", spanish="[M:D2]TALK-N08-04"}, {english="[M:D2]TALK-N08-05", french="[M:D2]TALK-N08-05", german="[M:D2]TALK-N08-05", italian="[M:D2]TALK-N08-05", spanish="[M:D2]TALK-N08-05"}, {english="[M:D2]TALK-N08-06", french="[M:D2]TALK-N08-06", german="[M:D2]TALK-N08-06", italian="[M:D2]TALK-N08-06", spanish="[M:D2]TALK-N08-06"}, {english="[M:D2]TALK-N08-07", french="[M:D2]TALK-N08-07", german="[M:D2]TALK-N08-07", italian="[M:D2]TALK-N08-07", spanish="[M:D2]TALK-N08-07"}, {english="[M:D2]TALK-N08-08", french="[M:D2]TALK-N08-08", german="[M:D2]TALK-N08-08", italian="[M:D2]TALK-N08-08", spanish="[M:D2]TALK-N08-08"}, {english="[M:D2]TALK-N08-09", french="[M:D2]TALK-N08-09", german="[M:D2]TALK-N08-09", italian="[M:D2]TALK-N08-09", spanish="[M:D2]TALK-N08-09"}, {english="[M:D2]TALK-N08-10", french="[M:D2]TALK-N08-10", german="[M:D2]TALK-N08-10", italian="[M:D2]TALK-N08-10", spanish="[M:D2]TALK-N08-10"}, {english="[M:D2]TALK-N08-11", french="[M:D2]TALK-N08-11", german="[M:D2]TALK-N08-11", italian="[M:D2]TALK-N08-11", spanish="[M:D2]TALK-N08-11"}, {english="[M:D2]TALK-N08-12", french="[M:D2]TALK-N08-12", german="[M:D2]TALK-N08-12", italian="[M:D2]TALK-N08-12", spanish="[M:D2]TALK-N08-12"}, {english="[M:D2]TALK-N08-13", french="[M:D2]TALK-N08-13", german="[M:D2]TALK-N08-13", italian="[M:D2]TALK-N08-13", spanish="[M:D2]TALK-N08-13"}, {english="[M:D2]TALK-N08-14", french="[M:D2]TALK-N08-14", german="[M:D2]TALK-N08-14", italian="[M:D2]TALK-N08-14", spanish="[M:D2]TALK-N08-14"}, {english="[M:D2]TALK-N08-15", french="[M:D2]TALK-N08-15", german="[M:D2]TALK-N08-15", italian="[M:D2]TALK-N08-15", spanish="[M:D2]TALK-N08-15"}, {english="[M:D2]TALK-N08-16", french="[M:D2]TALK-N08-16", german="[M:D2]TALK-N08-16", italian="[M:D2]TALK-N08-16", spanish="[M:D2]TALK-N08-16"}, {english="[M:D2]TALK-N08-17", french="[M:D2]TALK-N08-17", german="[M:D2]TALK-N08-17", italian="[M:D2]TALK-N08-17", spanish="[M:D2]TALK-N08-17"}, {english="[M:D2]TALK-N08-18", french="[M:D2]TALK-N08-18", german="[M:D2]TALK-N08-18", italian="[M:D2]TALK-N08-18", spanish="[M:D2]TALK-N08-18"}, {english="[M:D2]TALK-N08-19", french="[M:D2]TALK-N08-19", german="[M:D2]TALK-N08-19", italian="[M:D2]TALK-N08-19", spanish="[M:D2]TALK-N08-19"}, {english="[M:D2]TALK-N08-20", french="[M:D2]TALK-N08-20", german="[M:D2]TALK-N08-20", italian="[M:D2]TALK-N08-20", spanish="[M:D2]TALK-N08-20"}, {english="[M:D2]TALK-N08-21", french="[M:D2]TALK-N08-21", german="[M:D2]TALK-N08-21", italian="[M:D2]TALK-N08-21", spanish="[M:D2]TALK-N08-21"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  SV.SkyScenarioSide = {main=47, sub=0} -- $SCENARIO_SIDE = scn[47,0] (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE08_BOSS2ND = SV.SkyVars.SIDE08_BOSS2ND or {}; SV.SkyVars.SIDE08_BOSS2ND[0] = 0 -- $SIDE08_BOSS2ND[0] = 0 (ROM)
  -- main_EnterGround(LEVEL_D46P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 3 then
  -- message_Close
  SV.SkyScenarioSide = {main=47, sub=1} -- $SCENARIO_SIDE = scn[47,1] (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE08_BOSS2ND = SV.SkyVars.SIDE08_BOSS2ND or {}; SV.SkyVars.SIDE08_BOSS2ND[0] = 0 -- $SIDE08_BOSS2ND[0] = 0 (ROM)
  -- main_EnterGround(LEVEL_D46P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 4 then
  -- message_Close
  SV.SkyScenarioSide = {main=47, sub=3} -- $SCENARIO_SIDE = scn[47,3] (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE08_BOSS2ND = SV.SkyVars.SIDE08_BOSS2ND or {}; SV.SkyVars.SIDE08_BOSS2ND[0] = 1 -- $SIDE08_BOSS2ND[0] = 1 (ROM)
  -- main_EnterGround(LEVEL_D46P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 5 then
  -- message_Close
  SV.SkyScenarioSide = {main=47, sub=2} -- $SCENARIO_SIDE = scn[47,2] (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE08_BOSS2ND = SV.SkyVars.SIDE08_BOSS2ND or {}; SV.SkyVars.SIDE08_BOSS2ND[0] = 0 -- $SIDE08_BOSS2ND[0] = 0 (ROM)
  -- main_EnterGround(LEVEL_D46P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 6 then
  -- message_Close
  SV.SkyScenarioSide = {main=47, sub=4} -- $SCENARIO_SIDE = scn[47,4] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_D47P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 7 then
  -- message_Close
  SV.SkyScenarioSide = {main=47, sub=5} -- $SCENARIO_SIDE = scn[47,5] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_D47P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 8 then
  -- message_Close
  SV.SkyScenarioSide = {main=47, sub=5} -- $SCENARIO_SIDE = scn[47,5] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_D48P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 9 then
  -- message_Close
  SV.SkyScenarioSide = {main=47, sub=6} -- $SCENARIO_SIDE = scn[47,6] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_D48P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 10 then
  -- message_Close
  SV.SkyScenarioSide = {main=47, sub=7} -- $SCENARIO_SIDE = scn[47,7] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterDungeon(137, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D48P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 11 then
  -- message_Close
  SV.SkyScenarioSide = {main=47, sub=8} -- $SCENARIO_SIDE = scn[47,8] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterDungeon(137, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D48P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 12 then
  -- message_Close
  SV.SkyScenarioSide = {main=47, sub=8} -- $SCENARIO_SIDE = scn[47,8] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_D22P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 13 then
  -- message_Close
  SV.SkyScenarioSide = {main=47, sub=9} -- $SCENARIO_SIDE = scn[47,9] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_D22P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 14 then
  -- message_Close
  SV.SkyScenarioSide = {main=47, sub=10} -- $SCENARIO_SIDE = scn[47,10] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_D22P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 15 then
  -- message_Close
  SV.SkyScenarioSide = {main=47, sub=10} -- $SCENARIO_SIDE = scn[47,10] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_D50P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 16 then
  -- message_Close
  SV.SkyScenarioSide = {main=47, sub=11} -- $SCENARIO_SIDE = scn[47,11] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_D50P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 17 then
  -- message_Close
  SV.SkyScenarioSide = {main=48, sub=0} -- $SCENARIO_SIDE = scn[48,0] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_D51P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 18 then
  -- message_Close
  SV.SkyScenarioSide = {main=48, sub=1} -- $SCENARIO_SIDE = scn[48,1] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_D51P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 19 then
  -- message_Close
  SV.SkyScenarioSide = {main=48, sub=2} -- $SCENARIO_SIDE = scn[48,2] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterDungeon(142, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D51P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 20 then
  -- message_Close
  SV.SkyScenarioSide = {main=48, sub=3} -- $SCENARIO_SIDE = scn[48,3] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterDungeon(142, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D51P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 21 then
  -- message_Close
  SV.SkyScenarioSide = {main=48, sub=4} -- $SCENARIO_SIDE = scn[48,4] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterDungeon(142, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D51P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 22 then
  -- message_Close
  SV.SkyScenarioSide = {main=48, sub=4} -- $SCENARIO_SIDE = scn[48,4] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_D52P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 23 then
  -- message_Close
  SV.SkyScenarioSide = {main=48, sub=5} -- $SCENARIO_SIDE = scn[48,5] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_D52P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 24 then
  -- message_Close
  SV.SkyScenarioSide = {main=48, sub=5} -- $SCENARIO_SIDE = scn[48,5] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(4, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_D53P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 25 then
  -- message_Close
  SV.SkyScenarioSide = {main=48, sub=6} -- $SCENARIO_SIDE = scn[48,6] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(4, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_D53P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 26 then
  -- message_Close
  SV.SkyScenarioSide = {main=48, sub=9} -- $SCENARIO_SIDE = scn[48,9] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(4, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_D53P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 27 then
  -- message_Close
  SV.SkyScenarioSide = {main=48, sub=7} -- $SCENARIO_SIDE = scn[48,7] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(4, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterDungeon(146, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D53P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 28 then
  -- message_Close
  SV.SkyScenarioSide = {main=48, sub=8} -- $SCENARIO_SIDE = scn[48,8] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(4, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterDungeon(146, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D53P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 29 then
  -- message_Close
  SV.SkyScenarioSide = {main=48, sub=9} -- $SCENARIO_SIDE = scn[48,9] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(4, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterDungeon(146, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D53P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 30 then
  SV.SkyScenarioSide = {main=47, sub=4} -- $SCENARIO_SIDE = scn[47,4] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- message_Close
  -- main_EnterGround(LEVEL_D47P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 31 then
  SV.SkyScenarioSide = {main=47, sub=5} -- $SCENARIO_SIDE = scn[47,5] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- message_Close
  -- main_EnterGround(LEVEL_D48P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 32 then
  SV.SkyScenarioSide = {main=47, sub=6} -- $SCENARIO_SIDE = scn[47,6] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- message_Close
  -- main_EnterGround(LEVEL_D48P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 33 then
  SV.SkyScenarioSide = {main=47, sub=7} -- $SCENARIO_SIDE = scn[47,7] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- message_Close
  -- main_EnterDungeon(137, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D48P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 34 then
  SV.SkyScenarioSide = {main=47, sub=8} -- $SCENARIO_SIDE = scn[47,8] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- message_Close
  -- main_EnterDungeon(137, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D48P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 35 then
  SV.SkyScenarioSide = {main=47, sub=8} -- $SCENARIO_SIDE = scn[47,8] (ROM)
  -- message_Close
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_D22P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 36 then
  SV.SkyScenarioSide = {main=47, sub=10} -- $SCENARIO_SIDE = scn[47,10] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- message_Close
  -- main_EnterGround(LEVEL_D22P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 37 then
  SV.SkyScenarioSide = {main=47, sub=10} -- $SCENARIO_SIDE = scn[47,10] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- message_Close
  -- main_EnterGround(LEVEL_D50P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 38 then
  SV.SkyScenarioSide = {main=48, sub=0} -- $SCENARIO_SIDE = scn[48,0] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- message_Close
  -- main_EnterGround(LEVEL_D51P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 39 then
  SV.SkyScenarioSide = {main=48, sub=1} -- $SCENARIO_SIDE = scn[48,1] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- message_Close
  -- main_EnterGround(LEVEL_D51P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 40 then
  SV.SkyScenarioSide = {main=48, sub=2} -- $SCENARIO_SIDE = scn[48,2] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- message_Close
  -- main_EnterDungeon(142, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D51P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 41 then
  SV.SkyScenarioSide = {main=48, sub=3} -- $SCENARIO_SIDE = scn[48,3] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- message_Close
  -- main_EnterDungeon(142, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D51P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 42 then
  SV.SkyScenarioSide = {main=48, sub=4} -- $SCENARIO_SIDE = scn[48,4] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- message_Close
  -- main_EnterDungeon(142, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D51P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 43 then
  SV.SkyScenarioSide = {main=48, sub=4} -- $SCENARIO_SIDE = scn[48,4] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- message_Close
  -- main_EnterDungeon(142, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D51P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 44 then
  SV.SkyScenarioSide = {main=48, sub=4} -- $SCENARIO_SIDE = scn[48,4] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- message_Close
  -- main_EnterGround(LEVEL_D52P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 45 then
  SV.SkyScenarioSide = {main=48, sub=5} -- $SCENARIO_SIDE = scn[48,5] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- message_Close
  -- main_EnterGround(LEVEL_D52P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 46 then
  SV.SkyScenarioSide = {main=48, sub=5} -- $SCENARIO_SIDE = scn[48,5] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(4, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- message_Close
  -- main_EnterGround(LEVEL_D53P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 47 then
  SV.SkyScenarioSide = {main=48, sub=6} -- $SCENARIO_SIDE = scn[48,6] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(4, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- message_Close
  -- main_EnterGround(LEVEL_D53P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 48 then
  SV.SkyScenarioSide = {main=48, sub=7} -- $SCENARIO_SIDE = scn[48,7] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(4, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- message_Close
  -- main_EnterDungeon(146, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D53P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 49 then
  SV.SkyScenarioSide = {main=48, sub=9} -- $SCENARIO_SIDE = scn[48,9] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(4, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- message_Close
  -- main_EnterDungeon(146, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D53P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 50 then
  SV.SkyScenarioSide = {main=48, sub=9} -- $SCENARIO_SIDE = scn[48,9] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(4, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- message_Close
  -- main_EnterGround(LEVEL_D53P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else -- default/annulation
  -- message_Close
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
