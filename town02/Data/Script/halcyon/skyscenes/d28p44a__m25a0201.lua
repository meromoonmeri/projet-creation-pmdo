-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D28P44A/m25a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  GAME:FadeOut(true, 0) -- screen_WhiteOutAll
  GAME:WaitFrames(1)
  GAME:FadeIn(0)
  -- back_SetGround(LEVEL_D28P44A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 256, 208, Direction.Down, "NPC_YONOWAARU")
  -- SetAnimation(52) [anim idle native]
  GAME:FadeIn(30)
  -- bgm2_PlayFadeIn(BGM_ANOTHER_STATIC_NOISE) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="GWOH![K] GWWWOOOOHH![K]\nGWWWWWOOOOOOOHHHH!", french=" OH![K] OOOOHH![K] OOOOOOOHHHH!", german="GWOH![K] GWWWOOOOHH![K]\nGWWWWWOOOOOOOHHHH!", italian="OOOH![K] OOOOOOOOHH![K]\nOOOOOOOOOOOOOHHHH!", spanish="¡OH![K] ¡OOOOOH![K]\n¡OOOOOOOH!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:WaitFrames(15)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- GAP: se_Play(5126) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5126) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- GAP: BGM BGM_STATIC_NOISE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- bgm2_PlayFadeIn(BGM_ANOTHER_STATIC_NOISE) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "shock", 1) end)
  -- SetAnimation(33) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(150)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  pcall(function() SOUND:FadeOutBGM(5) end)
  -- GAP: se_Play(7684) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(36) [anim idle native]
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 208, 184, Direction.DownRight, "NPC_YAMIRAMI")
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  local npc_npc_yamirami2 = SkySceneKit.spawn_npc("sableye", 312, 184, Direction.DownLeft, "NPC_YAMIRAMI2")
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_yamirami3 = SkySceneKit.spawn_npc("sableye", 184, 208, Direction.Right, "NPC_YAMIRAMI3")
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 336, 208, Direction.Left, "NPC_YAMIRAMI4")
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "shock", 1) end)
  local npc_npc_yamirami5 = SkySceneKit.spawn_npc("sableye", 192, 240, Direction.UpRight, "NPC_YAMIRAMI5")
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "shock", 1) end)
  local npc_npc_yamirami6 = SkySceneKit.spawn_npc("sableye", 328, 240, Direction.UpLeft, "NPC_YAMIRAMI6")
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(60)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We...[K]did it...", french=" Nous...[K] nous avons réussi...", german=" Wir...[K] Wir haben es geschafft...", italian=" Ce...[K] l'abbiamo fatta...", spanish=" Lo hemos...[K] conseguido."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We...[K]did it...", french=" Nous...[K] nous avons réussi...", german=" Wir...[K] Wir haben es geschafft...", italian=" Ce...[K] l'abbiamo fatta...", spanish=" Lo hemos...[K] conseguido."})
  else
  SkySceneKit.say({english=" We...[K]did it...", french=" Nous...[K] nous avons réussi...", german=" Wir...[K] Wir haben es geschafft...", italian=" Ce...[K] l'abbiamo fatta...", spanish=" Lo hemos...[K] conseguido."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 288, 280, Direction.UpLeft, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR] is...[K]down...", french=" [CS:N]Noctunoir[CR] est...[K] vaincu...", german=" [CS:N]Zwirrfinst[CR] ist...[K] erledigt...", italian=" [CS:N]Dusknoir[CR] è...[K] sconfitto...", spanish=" [CS:N]Dusknoir[CR] ha...[K] caído..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We've finally beaten [CS:N]Dusknoir[CR]!", french="Nous avons enfin battu\n[CS:N]Noctunoir[CR]!", german="Wir haben [CS:N]Zwirrfinst[CR] zu guter\nLetzt besiegt!", italian="Finalmente abbiamo battuto\n[CS:N]Dusknoir[CR]!", spanish=" ¡Hemos vencido a [CS:N]Dusknoir[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Wheh... It can't be...", french=" Whé... C'est impossible...", german=" Wäh... Das kann nicht sein...", italian=" Eh-eh... Non può essere...", spanish=" Eje... No puede ser..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(9) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_yamirami2) end)
  SkySceneKit.say({english=" Wheeh...[K] Lord [CS:N]Dusknoir[CR]...", french=" Whé...[K] Messire [CS:N]Noctunoir[CR]...", german=" Wähäh...[K] Meister [CS:N]Zwirrfinst[CR]...", italian=" Eh-eh-eh...[K] Lord [CS:N]Dusknoir[CR]...", spanish=" Je, je...[K] Poderoso [CS:N]Dusknoir[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yamirami5) end)
  SkySceneKit.say({english=" Lord [CS:N]Dusknoir[CR]...[K]was defeated!", french="Messire [CS:N]Noctunoir[CR]...[K]\na été vaincu!", german="Meister [CS:N]Zwirrfinst[CR]...[K] wurde\nbesiegt!", italian="Lord [CS:N]Dusknoir[CR]...[K] è stato\nsconfitto!", spanish="El poderoso [CS:N]Dusknoir[CR]...[K]\n¡ha sido derrotado!"})
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "sweating", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "sweating", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yamirami, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_yamirami3, Direction.UpRight)
  GROUND:EntTurn(npc_npc_yamirami2, Direction.DownRight)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_yamirami, Direction.DownRight)
  GROUND:EntTurn(npc_npc_yamirami3, Direction.DownRight)
  GROUND:EntTurn(npc_npc_yamirami2, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetOutputAttribute(2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yamirami4) end) -- message_SetActor(ACTOR_NPC_YAMIRAMI4)
  pcall(function() UI:SetSpeaker(npc_npc_yamirami4) end)
  SkySceneKit.say({english=" Wheeeeh!", french=" Wheeeeh!", german=" Wähähäh!", italian=" Eeeeeeh!", spanish=" ¡Jeeee, jeeee!"})
  -- GAP: se_Play(7430) — id SE NDS sans portage PMDO identifié
  GROUND:MoveToPosition(npc_npc_yamirami, 252, 148, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_yamirami2, 252, 148, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami3, 252, 148, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_yamirami4, 252, 148, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami5, 252, 148, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_yamirami6, 252, 148, false, 2)
  GROUND:EntTurn(npc_npc_yamirami, Direction.Up)
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_yamirami2, Direction.Up)
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_yamirami3, Direction.Up)
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Up)
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Up)
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Up)
  -- Destroy() [neutre/état moteur]
  -- message_CloseEnforce
  GAME:WaitFrames(120)
  pcall(function() GAME:MoveCamera(252, 220, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 252, 232, false, 1)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 220, 220, false, 1)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_juputoru, 284, 220, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Hidden Highland.ogg", true) end)
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru, 4) end)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Humph.[K] Your [CS:N]Sableye[CR] ran off.", french="Pfff![K] Tes sbires [CS:N]Ténéfix[CR]\nont quitté le navire.", german="Grmpf.[K] Deine [CS:N]Zobiris[CR] sind\nweggelaufen.", italian="Ehi.[K] I [CS:N]Sableye[CR] sono scappati\nvia.", spanish="¡Ja![K] Tus sicarios [CS:N]Sableye[CR]\nhan huido despavoridos."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="You just have no luck attracting\nreliable allies.", french="On dirait que tu ne peux pas\ncompter sur tes propres alliés.", german="Du hast einfach kein Glück\ndamit, verlässliche Mitstreiter zu finden.", italian="Non hai più nessuno dalla tua\nparte.", spanish="Parece que no se te da bien\nencontrar aliados en los que confiar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Urgggh...", french=" Argggh...", german=" Urgggh...", italian=" Urgggh...", spanish=" Aaaah..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" [partner].", french=" [partner].", german=" [partner].", italian=" [partner].", spanish=" [partner]..."})
  GROUND:EntTurn(hero, Direction.UpRight)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What is it?", french=" Qu'est-ce qui se passe?", german=" Was ist los?", italian=" Cosa c'è?", spanish=" ¿Qué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What is it?", french=" Qu'est-ce qui se passe?", german=" Was ist los?", italian=" Cosa c'è?", spanish=" ¿Qué?"})
  else
  SkySceneKit.say({english=" What is it?", french=" Qu'est-ce qui se passe?", german=" Was ist los?", italian=" Cosa c'è?", spanish=" ¿Qué?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Go to the top of the temple.", french=" Va au sommet du temple.", german=" Steig den Tempel ganz hinauf.", italian=" Vai in cima al tempio.", spanish=" Sube al templo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Put the Relic Fragment in that\nhollow spot.", french="Place le Fragment de Relique\ndans la cavité.", german="Setze das Reliktfragment in\ndiese hohle Stelle ein.", italian="Inserisci il Frammento Antico\nnell'incavatura.", spanish="Introduce la Reliquia de Piedra\nen el hueco."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I want you to check if the\nRainbow Stoneship actually works.", french="Assure-toi que le Vaisseau\nArc-en-Ciel fonctionne bien.", german="Ich will, dass du herausfindest,\nob das Regenbogen-Steinschiff funktioniert.", italian="Devi controllare se il Vascello\nArcobaleno funziona ancora.", spanish="Quiero que compruebes si\nla Barca Arcoiris funciona."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Meanwhile, [hero] and I\nwill keep an eye on [CS:N]Dusknoir[CR] here.", french="Pendant ce temps, [hero]\net moi, on reste là pour surveiller [CS:N]Noctunoir[CR].", german="Währenddessen behalten\n[hero] und ich hier [CS:N]Zwirrfinst[CR] im Auge.", italian="Nel frattempo, [hero] ed\nio terremo d'occhio [CS:N]Dusknoir[CR].", spanish="Mientras tanto, [hero] y\nyo vigilaremos a [CS:N]Dusknoir[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right. I'll go do that.", french=" Entendu, j'y vais.", german=" Alles klar. Das mache ich.", italian=" Va bene. Vado.", spanish=" Vale, ya voy."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK. I'll go do that.", french=" Entendu, j'y vais.", german=" Okay. Das mache ich.", italian=" Ok. Vado subito.", spanish=" Muy bien. Ahora mismo voy."})
  else
  SkySceneKit.say({english=" OK. I'll go do that.", french=" Entendu, j'y vais.", german=" Okay. Das mache ich.", italian=" Ok. Vado subito.", spanish=" Muy bien. Ahora mismo voy."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 36, 236, false, 2)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="If the Rainbow Stoneship works,\nwe can go to [CS:P]Temporal Tower[CR].", french="Si le Vaisseau Arc-en-Ciel\nfonctionne, on pourra aller à la [CS:P]Tour\ndu Temps[CR].", german="Falls das Regenbogen-Steinschiff\nfunktioniert, können wir zum [CS:P]Zeitturm[CR] gehen.", italian="Se il Vascello Arcobaleno\nfunziona, potremo andare alla\n[CS:P]Torre del Tempo[CR].", spanish="Si la Barca Arcoiris funciona,\npodremos ir a la [CS:P]Torre del Tiempo[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" I hope it activates...", french=" J'espère qu'il va s'activer...", german=" Ich hoffe, es klappt...", italian=" Spero che si attivi...", spanish=" Espero que se active..."})
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
  SkySceneKit.say({english=" Urgggh...", french=" Aaargh...", german=" Argggh...", italian=" Urgggh...", spanish=" Grr..."})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru, 4) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Don't move!", french=" Pas un geste!", german=" Nicht bewegen!", italian=" Non ti muovere!", spanish=" ¡No te muevas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Urgghh...[K] [CS:N]Grovyle[CR]...\n[hero]...", french="Aaargh...[K] [CS:N]Massko[CR]...\n[hero]...", german="Argghh...[K] [CS:N]Reptain[CR]...\n[hero]...", italian="Urgghh...[K] [CS:N]Grovyle[CR]...\n[hero]...", spanish="Grrr...[K] [CS:N]Grovyle[CR]...\n[hero]..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Is this really...", french=" Est-ce vraiment...", german=" Ist das wirklich...", italian=" È davvero...", spanish=" ¿Es esto...?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Is this what you really want?", french="Est-ce là vraiment ce que vous\nsouhaitez?", german="Ist das wirklich, was ihr\nwollt?", italian=" È davvero questo che volete?", spanish="¿Realmente es esto lo que\nqueréis?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="If history is changed...[K]\nWe Pokémon of the future will disappear...", french="Si le cours de l'histoire est\naltéré...[K] nous, les Pokémon du futur, serons\namenés à disparaître...", german="Wenn die Geschichte verändert\nwird,[K] dann werden wir Pokémon aus der\nZukunft verschwinden...", italian="Se la storia cambia...[K]\nnoi Pokémon del futuro scompariremo...", spanish="Si cambiáis la historia...[K]\nlos Pokémon del futuro desapareceremos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:StopBGM() end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Wh-what?)", french="(Hein, quoi?)", german="(W-was?)", italian="(C-Cosa?)", spanish="(¿Cómo dices?)"})
  else
  SkySceneKit.say({english="(Wh-what?)", french="(Hein, quoi?)", german="(W-was?)", italian="(C-Cosa?)", spanish="(¿Cómo dices?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(If history is changed...[K]Pokémon of the\nfuture will disappear?)", french="(Si on modifie le cours de l'histoire...[K]\nles Pokémon du futur disparaîtront?)", german="(Wenn die Geschichte verändert wird,[K] dann\nwerden die Pokémon der Zukunft\nverschwinden?)", italian="(Se la storia cambia...[K] i Pokémon del futuro\nscompariranno?)", spanish="(Si la historia cambia...[K] ¿los Pokémon del\nfuturo desaparecerán?)"})
  else
  SkySceneKit.say({english="(If history is changed...[K]Pokémon of the\nfuture will disappear?)", french="(Si on modifie le cours de l'histoire...[K]\nles Pokémon du futur disparaîtront?)", german="(Wenn die Geschichte verändert wird,[K] dann\nwerden die Pokémon der Zukunft\nverschwinden?)", italian="(Se la storia cambia...[K] i Pokémon del futuro\nscompariranno?)", spanish="(Si la historia cambia...[K] ¿los Pokémon del\nfuturo desaparecerán?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" It won't be just me.", french="Je ne serai pas le seul dans\nce cas.", german=" Das betrifft nicht nur mich.", italian=" Non solo io.", spanish=" Y no seré solo yo."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Both of you...[K] [CS:N]Grovyle[CR] and\n[hero] alike...", french="Vous aussi...[K] [CS:N]Massko[CR] et\n[hero]...", german="Auch ihr beiden...[K] [CS:N]Reptain[CR] und\n[hero] gleichermaßen...", italian="Entrambi...[K] sia [CS:N]Grovyle[CR] che\n[hero]...", spanish="[CS:N]Grovyle[CR], [hero]...[K]\nvosotros dos también..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Since you come from a future\nthat will cease to exist, you will both\ndisappear too...[K] Is that what you really want?", french="Puisque vous venez d'un futur\nqui cessera d'exister...[K] Est-ce là ce que\nvous voulez?", german="Da ihr aus einer Zukunft kommt,\ndie nicht mehr existieren wird, werdet auch\nihr verschwinden...[K] Wollt ihr das wirklich?", italian="Venite da un futuro che cesserà\ndi esistere, quindi scomparirete anche voi...[K]\nÈ quello che volete davvero?", spanish="Venís de un futuro que\nva a dejar de existir, vosotros también\ndesapareceréis...[K] ¿Es eso lo que queréis?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(If we change history, we'll disappear too?!)", french="(Si on change le cours de l'histoire,\non disparaîtra, nous aussi?!)", german="(Wenn wir die Geschichte verändern,\nverschwinden auch wir?!?)", italian="(Se cambiamo la storia, scompariremo anche\nnoi?!)", spanish="(Si cambiamos la historia, ¡¿también\ndesapareceremos?!)"})
  else
  SkySceneKit.say({english="(If we change history, we'll disappear too?!)", french="(Si on change le cours de l'histoire,\non disparaîtra, nous aussi?!)", german="(Wenn wir die Geschichte verändern,\nverschwinden auch wir?!?)", italian="(Se cambiamo la storia, scompariremo anche\nnoi?!)", spanish="(Si cambiamos la historia, ¡¿también\ndesapareceremos?!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Is [CS:N]Dusknoir[CR]...)", french="(Est-ce que [CS:N]Noctunoir[CR]...)", german="(Sagt [CS:N]Zwirrfinst[CR] etwa...)", italian="([CS:N]Dusknoir[CR]...)", spanish="(¿Estará [CS:N]Dusknoir[CR] mintiendo?)"})
  else
  SkySceneKit.say({english="(Is [CS:N]Dusknoir[CR]...)", french="(Est-ce que [CS:N]Noctunoir[CR]...)", german="(Sagt [CS:N]Zwirrfinst[CR] etwa...)", italian="([CS:N]Dusknoir[CR]...)", spanish="(¿Estará [CS:N]Dusknoir[CR] mintiendo?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Is [CS:N]Dusknoir[CR] telling...[K]the truth?)", french="(Est-ce que [CS:N]Noctunoir[CR] dit...[K] vrai?)", german="(Sagt [CS:N]Zwirrfinst[CR] etwa...[K] die Wahrheit?)", italian="([CS:N]Dusknoir[CR] starà dicendo...[K] la verità?)", spanish="(¿O será...?[K] ¿O será verdad lo que dice?)"})
  else
  SkySceneKit.say({english="(Is [CS:N]Dusknoir[CR] telling...[K]the truth?)", french="(Est-ce que [CS:N]Noctunoir[CR] dit...[K] vrai?)", german="(Sagt [CS:N]Zwirrfinst[CR] etwa...[K] die Wahrheit?)", italian="([CS:N]Dusknoir[CR] starà dicendo...[K] la verità?)", spanish="(¿O será...?[K] ¿O será verdad lo que dice?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:N]Grovyle[CR]!)", french="([CS:N]Massko[CR]!)", german="([CS:N]Reptain[CR]!)", italian="([CS:N]Grovyle[CR]!)", spanish="(¡[CS:N]Grovyle[CR]!)"})
  else
  SkySceneKit.say({english="([CS:N]Grovyle[CR]!)", french="([CS:N]Massko[CR]!)", german="([CS:N]Reptain[CR]!)", italian="([CS:N]Grovyle[CR]!)", spanish="(¡[CS:N]Grovyle[CR]!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- GAP: BGM BGM_TIME_GEAR non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" ...[K]It's true, [hero].", french=" ...[K] C'est la vérité, [hero].", german=" ...[K]Es stimmt, [hero].", italian=" ...[K] È vero, [hero].", spanish=" Es...[K] Es cierto, [hero]."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="If we change history...[K]we will\ndisappear.", french="Si nous modifions le cours de\nl'histoire...[K] nous disparaîtrons, toi et moi.", german="Wenn wir die Geschichte\nverändern,[K] dann werden wir verschwinden.", italian="Se cambiamo la storia...[K]\nnoi scompariremo.", spanish="Si cambiamos la historia...[K]\nnosotros desapareceremos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:N]G-Grovyle[CR]!)", french="([CS:N]M-Massko[CR]!)", german="([CS:N]R-Reptain[CR]!)", italian="([CS:N]G-Grovyle[CR]!)", spanish="(¡[CS:N]Grovyle[CR]!)"})
  else
  SkySceneKit.say({english="([CS:N]G-Grovyle[CR]!)", french="([CS:N]M-Massko[CR]!)", german="([CS:N]R-Reptain[CR]!)", italian="([CS:N]G-Grovyle[CR]!)", spanish="(¡[CS:N]Grovyle[CR]!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" But...[K]that doesn't matter...", french=" Mais...[K] peu importe...", german=" Aber...[K] das macht nichts...", italian=" Ma...[K] non ha importanza...", spanish=" Pero...[K] eso no importa..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="If it means restoring time...[K]\nAnd bringing peace to the world!", french="Si c'est la seule manière\nde remettre le temps en marche...[K] et\nde restaurer la paix dans le monde!", german="Wenn damit die Zeit gerettet\nwird...[K] Und Frieden in die Welt zurückkehrt!", italian="Perché questo significa\nristabilire il flusso del tempo...[K] e portare la\npace nel mondo!", spanish="Si significa devolver el tiempo\na la normalidad...[K] ¡y traer la paz al mundo!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="It's what I came to the past\nto do...", french="C'est dans ce but que je suis\nvenu dans le passé...", german="Genau deshalb bin ich ja in die\nVergangenheit gereist...", italian="È per questo che sono venuto nel\npassato...", spanish="A eso vine... Por eso vine\nal pasado."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="[CS:N]Celebi[CR] too...[K] She helped us,\nknowing that she will disappear if we succeed.", french="[CS:N]Celebi[CR] aussi...[K] Elle nous a aidés\nen sachant qu'elle disparaîtrait si\nnous réussissions.", german="[CS:N]Celebi[CR] auch...[K] Es half uns,\nobwohl es wusste, dass es verschwinden wird,\nfalls wir Erfolg haben.", italian="Anche [CS:N]Celebi[CR]...[K] Ci ha aiutato,\npur sapendo che se la nostra impresa fosse\nriuscita, sarebbe scomparsa.", spanish="[CS:N]Celebi[CR] también...[K]\nNos ayudó, sabiendo que desaparecería si\nteníamos éxito en nuestra misión."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Even [CS:N]Celebi[CR]?)", french="(Même [CS:N]Celebi[CR]?)", german="(Sogar [CS:N]Celebi[CR]?)", italian="(Anche [CS:N]Celebi[CR]?)", spanish="(¿Incluso [CS:N]Celebi[CR]?)"})
  else
  SkySceneKit.say({english="(Even [CS:N]Celebi[CR]?)", french="(Même [CS:N]Celebi[CR]?)", german="(Sogar [CS:N]Celebi[CR]?)", italian="(Anche [CS:N]Celebi[CR]?)", spanish="(¿Incluso [CS:N]Celebi[CR]?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Oh![K] I recall, when we were in the future...)", french="(Oh![K] Je me souviens, quand nous étions\ndans le futur...)", german="(Oh![K] Ich erinnere mich, als wir damals in der\nZukunft waren...)", italian="(Oh![K] Ricordo, quando eravamo nel futuro...)", spanish="(¡Oh![K] Ahora recuerdo que cuando estábamos\nen el futuro...)"})
  else
  SkySceneKit.say({english="(Oh![K] I recall, when we were in the future...)", french="(Oh![K] Je me souviens, quand nous étions\ndans le futur...)", german="(Oh![K] Ich erinnere mich, als wir damals in der\nZukunft waren...)", italian="(Oh![K] Ricordo, quando eravamo nel futuro...)", spanish="(¡Oh![K] Ahora recuerdo que cuando estábamos\nen el futuro...)"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
