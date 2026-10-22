-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D42P42A/n01a2701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=40, sub=8} -- $SCENARIO_SIDE = scn[40,8] (ROM)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(127, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D42P42A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 252, 252, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I've come pretty far...", french=" J'suis arrivé vraiment loin...", german=" Ich bin recht weit gekommen...", italian=" Ho fatto parecchia strada...", spanish=" He llegado bastante lejos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Golly, this here looks like\nanother dead end, yup yup...", french="Sapristi, mais c'est qu'on dirait\nun autre cul-de-sac, pardi...", german="Donnerwetter, das sieht nach\neiner weiteren Sackgasse aus, jawollja...", italian="Ohibò, questo posto ha tutta\nl'aria di essere un altro vicolo cieco,\ngià, già...", spanish="Caramba, parece que aquí\nse vuelve a acabar la cueva..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Is this here really...[K]really the\ndeepest point in the cave?", french="Ici, c'est...[K] c'est vraiment\nl'endroit le plus profond de la caverne?", german="Ist das hier wirklich...[K] wirklich\nder tiefste Punkt der Höhle?", italian="Questo sarà davvero...[K] il punto\npiù profondo della caverna?", spanish="¿Será este...[K] definitivamente\nel lugar más profundo de la cueva?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" .........", french=" .........", german=" ..........", italian=" ..........", spanish=" ..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...Phewwwww...", french=" ... Ouuuuaaah...", german=" ...Puuuuuh...", italian=" Rooonf...", spanish=" Fiiiiiuuuu..."})
  pcall(function() SOUND:FadeOutBGM(60) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" So sleepy...[K] Yaaaaawn...", french=" J'ai... sommeil...[K] Ouuaaaaaah...", german=" So müde...[K] Gääääähn...", italian=" Che sonno...[K] Yaaaaaawn...", spanish=" Qué sueñito...[K] Aaaaaahm..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Where is that voice...?", french=" D'où elle vient, cette voix...?", german=" Woher kommt diese Stimme?", italian=" Da dove proviene questa voce...?", spanish=" ¿De dónde proviene esa voz?..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="W-wait[K] a minute...[K]\nIs that voice...?", french="A-attends voir[K] une minute...[K]\nCette voix, c'est...?", german="A-augenblick![K] Könnte diese...[K]\nStimme wirklich...", italian="A-Aspetta[K] un attimo...[K]\nChe quella voce...?", spanish="Un... Un momento.[K] Será...[K]\n¿Será esa voz la de...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...Whooo iis iit?", french=" ... Quiii est làààà?", german=" ...Gähn, weeer... ist da?", italian=" ... Chiii èèè?", spanish=" ¿Quién anda ahí?..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Whoooo's therrre?[K] Yaaaaawn...", french=" Quiii est làààà?[K] Ouuuuaaaaah...", german=" Ist daaa jemaaaand?[K] Gäääähn...", italian=" Chiii sta parlandooo?[K] Yaaaaaawn...", spanish=" ¿Quién anda ahí?[K] Uaaaa..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" You mean me?", french=" Ben... c'est moi, quoi.", german=" Meinst du mich?", italian=" Ti riferisci a me?", spanish=" ¿Te refieres a mí?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I-I'm [CS:Y]Bidoof[CR].", french=" Je... j'm'appelle [CS:Y]Keunotor[CR].", german=" I-ich bin [CS:Y]Bidiza[CR].", italian=" I-Io mi chiamo [CS:Y]Bidoof[CR].", spanish=" Me... Me llamo [CS:Y]Bidoof[CR]."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Who are you?", french=" Qui es-tu?", german=" Und wer bist du?", italian=" Tu chi sei?", spanish=" ¿Quién eres?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Meeee? Yaaaaawn...", french=" Moiiiii? Ouuuaaah...", german=" Iiiich? Gääähn...", italian=" Iiiooo? Yaaaaaawn...", spanish=" ¿Yooo? Uaaa..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Fwaaaaaahhhhhhh...[K] I'm...[K] I'm...", french=" Mouuuaaaaah...[K] Je...[K] suis...", german=" Faaaaaah...[K] Ich...[K] Ich...", italian=" Roooooonfff...[K] Io...[K] Io...", spanish=" Fiiiiiiu...[K] Soy...[K] Soy..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(1) [neutre/état moteur]
  -- GAP: se_Play(9224) — id SE NDS sans portage PMDO identifié
  local npc_npc_jiraachi = SkySceneKit.spawn_npc("jirachi", 256, 224, Direction.Down, "NPC_JIRAACHI")
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(50)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(43) [anim idle native]
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: BGM BGM_BEYOND_THE_DREAM non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english=" I'm [CS:N]Jirachi[CR]. Yaaaaawn...", french=" Je suis [CS:N]Jirachi[CR]. Ouuuuuaaaaah...", german=" Gäääähn. Ich bin [CS:N]Jirachi[CR]. Gäääähn...", italian=" Io sono [CS:N]Jirachi[CR]. Yaaaaaawn...", spanish=" Soy [CS:N]Jirachi[CR]. Uaaaa..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:N]J[CR]-[CS:N]Jirachi[CR]![K] You're THE\n[CS:N]Jirachi[CR], aren't you?!", french="[CS:N]J[CR]-[CS:N]Jirachi[CR]![K]\nLE [CS:N]Jirachi[CR] de la légende,\npas vrai?!", german="[CS:N]J-Jirachi[CR]![K]\nDAS [CS:N]Jirachi[CR], nicht wahr?!?", italian="[CS:N]J-Jirachi[CR]![K] Tu sei QUEL\n[CS:N]Jirachi[CR], non è vero?!", spanish="¡[CS:N]Ji[CR]... [CS:N]Jirachi[CR]![K] Eres [CS:N]Jirachi[CR],\n¡¿no es así?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english=" Mmm-hmm... That's right...", french=" Mmh-mmh... En effet.", german=" Mmm-hmm... Das stimmt...", italian=" Mmmmmh... Esatto...", spanish=" Sí... Eso mismo..."})
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="Speaking of... Whoooo are\nyoooooou? Yaaaaawn...", french="Et toi, dis-moi... quiiii es-tuuuu?\nOuuuuaaaah...", german="Aber... Wer bist du?\nGääääähn...", italian="A proposito... Chiii sei tuuuuuu?\nYaaaaaawn...", spanish="Por cierto... ¿Y quién eres\ntúuuuu? Uaaaa..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'm [CS:Y]Bidoof[CR].\n(...Didn't I already say that...?)", french="Je... Moi, c'est [CS:Y]Keunotor[CR].\n(... Ben, j'lui ai déjà dit, non...?)", german="Ich bin [CS:Y]Bidiza[CR].\n(...Hab ich das nicht schon einmal gesagt?)", italian="Mi chiamo [CS:Y]Bidoof[CR].\n(Ma non l'avevo già detto...?)", spanish="Soy [CS:Y]Bidoof[CR].\n(¿No se lo había dicho ya?...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" U-um...", french=" Heu...", german=" Oh-om...", italian=" U-Uhm...", spanish=" Hum... Esto..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english=" Whaaaaaat? Zzzz... Snorf...", french=" Quoiiiiiiii? Zzzz... ron...", german=" Waaaaas? Zzzz... Schnrmpf...", italian=" Cooomeee? Zzz... Ronf...", spanish=" ¿Quéeeeee? Zzzz... Grooonf..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I heard that you...[K] That you can\ngrant wishes, [CS:N]Jirachi[CR]...", french="On dit que...[K] qu'tu peux exaucer\nles vœux, [CS:N]Jirachi[CR]...", german="Ich hörte, dass du...[K] dass du\nWünsche wahr werden lassen kannst, [CS:N]Jirachi[CR]...", italian="Ho sentito che...[K] che puoi\nesaudire i desideri, [CS:N]Jirachi[CR]...", spanish="He oído que...[K] concedes\ndeseos, [CS:N]Jirachi[CR]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Is it really true?", french=" C'est vraiment vrai?", german=" Stimmt das?", italian=" È così?", spanish=" ¿Es eso cierto?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="Yep, it'ssss truuuuuuue.[K]\nYaaaaawn...", french="Ouiii, c'est vraiiiiii.[K]\nOuuuuaaaah...", german="Ja, das stimmmmmmt.[K]\nGääääääähn...", italian="Sì, èèè vvveeeroooooo.[K]\nYaaaaaawn...", spanish="Pues sí, es verdaaaaaaaad.[K]\nUaaaa..."})
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="But right now, I'm pretty\nsleeeepy, so I can't really help you. Sorrrry...\nZzz... Zzzz... Snorf...", french="Mais là, je suis un peu assoupiiii,\nalors je ne peux pas faire grand-chose\npour toi. Désolééé... Zzz... ron... zzzz...", german="Nur bin ich gerade... ein wenig\nmüüüüde... Tut mir leid... Zzz...\nZzzz... Schnrmpf...", italian="Ma adesso ho tanto sonno,\nquindi non posso proprio aiutarti.\nMi dissspiaceee... Zzz... Zzz... Ronf...", spanish="Pero ahora estoy algo amodorrado,\nno puedo ayudarte, lo sientooo...\nZzz... Zzzz... Grooonf..."})
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english=" And...", french=" Et...", german=" Und...", italian=" E...", spanish=" Y..."})
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="I usually toss and turn in my\nsleep... Zzzz... Snorf...", french="Il semblerait que je m'agite\nbeaucoup dans mon sommeil... Zzzz... ron...", german="Ich schlafe meist recht...\nunruhig... Zzzz... Zzzzzzz...", italian="... di solito mentre dormo mi\nrigiro da una parte all'altra... Zzz... Ronf...", spanish="Por lo visto me da por moverme\nmucho mientras duermo... Zzzz... Grooonf..."})
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english=" So, if you're nearby...", french="Alors, si tu t'approches\ntrop près...", german=" Wenn du näherkommst...", italian=" Quindi, se sei vicino a me...", spanish=" Así que, si estás cerca..."})
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="I will probably attack you...[K]\nSorry if I do... Zzzz... Snorf...", french="... il se pourrait que je\nt'attaque...[K] Désolé, si ça arrive...\nZzzz... ron... zzzz...", german="Dann werde ich vielleicht sogar\nangreifen...[K] Ist aber keine Absicht... Zzzzzz...\nSchnrmpf...", italian="... probabilmente ti attaccherò...[K]\nScusami, non vorrei farlo... Zzzz... Snorf...", spanish="Seguramente te ataque...[K]\nNo me lo tengas en cuenta... Zzzz... Grooonf..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Wh-whaaaaat?!", french=" Qu-quoiiiii?!", german=" W-waaaaas?!?", italian=" C-Cooosaaa?!", spanish=" ¡¿Có... cómo?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  pcall(function() UI:SetSpeaker(npc_npc_jiraachi) end)
  SkySceneKit.say({english="...Yaaaaawn...[K]\nI'm so sleepy...", french="... Ouuuuaaaah...[K]\nSi fatiguééééé...", german="...Gääääähn...[K]\nIch bin sooo müde...", italian="Yaaaaaawn...[K]\nHo tanto sonno...", spanish="Aaaaaaahm...[K]\nQué sueñito tengo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(127, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
