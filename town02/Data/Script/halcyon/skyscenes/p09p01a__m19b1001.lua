-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P09P01A/m19b1001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  local npc_npc_serebii = SkySceneKit.spawn_npc("celebi", 288, 560, Direction.Up, "NPC_SEREBII")
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Oh![K] I see it now!", french=" Ça y est![K] Je le vois d'ici!", german=" Oh![K] Jetzt sehe ich ihn!", italian=" Oh![K] Adesso lo vedo!", spanish=" ¡Sí![K] ¡Ya lo veo!"})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" There it is!", french=" Le voilà!", german=" Das ist er!", italian=" Eccolo!", spanish=" ¡Allí está!"})
  -- message_Close
  GAME:FadeOut(false,  0)
  GAME:FadeIn(0)
  -- back_SetGround(LEVEL_P09P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  -- GAP: SetEffect 640 — VFX sans émote PMDO équivalente
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  GAME:WaitFrames(90)
  pcall(function() GAME:MoveCamera(300, 416, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_serebii, 284, 404, false, 2)
  GAME:WaitFrames(20)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 320, 560, Direction.Up, "NPC_JUPUTORU")
  GROUND:MoveToPosition(npc_npc_juputoru, 316, 404, false, 2)
  GROUND:MoveToPosition(partner, 280, 428, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 324, 428, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Is that...[K]the Passage of Time?", french=" C'est ça...[K] le Couloir du Temps?", german=" Ist das...[K] der Zeittunnel?", italian="È questo...[K] il Portale del\nTempo?", spanish="¿Eso es...?[K] ¿Eso es el Pasaje del\nTiempo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Is that...[K]the Passage of Time?", french=" C'est ça...[K] le Couloir du Temps?", german=" Ist das...[K] der Zeittunnel?", italian="È questo...[K] il Portale del\nTempo?", spanish="¿Eso es...?[K] ¿Eso es el Pasaje del\nTiempo?"})
  else
  SkySceneKit.say({english=" Is that...[K]the Passage of Time?", french=" C'est ça...[K] le Couloir du Temps?", german=" Ist das...[K] der Zeittunnel?", italian="È questo...[K] il Portale del\nTempo?", spanish="¿Eso es...?[K] ¿Eso es el Pasaje del\nTiempo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_serebii, partner, 4) end)
  GROUND:EntTurn(hero, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That's right.[K] That's the Passage\nof Time.", french="Exact.[K] C'est bien le Couloir du\nTemps.", german="Das ist richtig.[K] Das ist der\nZeittunnel.", italian="Proprio così.[K] Questo è il\nPortale del Tempo.", spanish=" En efecto.[K] Eso es."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I went through that to go to\nthe past.", french="C'est ce que j'ai emprunté\npour venir dans le passé.", german="Ich bin da durchgegangen, um in\ndie Vergangenheit zu gelangen.", italian="Sono passato di qua per tornare\nnel passato.", spanish=" Lo crucé para ir al pasado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, npc_npc_serebii, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_serebii, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="[CS:N]Celebi[CR], only you can open the\nPassage of Time.", french="[CS:N]Celebi[CR], tu es la seule à pouvoir\nouvrir le Couloir du Temps.", german="[CS:N]Celebi[CR], nur du kannst den\nZeittunnel öffnen.", italian="[CS:N]Celebi[CR], solo tu puoi aprire il\nPortale del Tempo.", spanish=" [CS:N]Celebi[CR], solo tú puedes abrirlo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Do your thing.", french=" Fais ce que tu as à faire.", german=" Tu, was du zu tun hast.", italian=" Procedi.", spanish=" Es tu turno."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Sure.", french=" D'accord.", german=" Sicher.", italian=" Certo.", spanish=" Cómo no."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_serebii, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_serebii.Position; GROUND:MoveToPosition(npc_npc_serebii, p.X+(0), p.Y+(-8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(30) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Stop there![K] That will do!", french=" Arrêtez![K] Ça suffit!", german=" Stehen geblieben![K] Das reicht!", italian=" Fermo![K] Fa' come ti dico!", spanish=" ¡Alto ahí![K] ¡Suficiente!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" What...?[K] That voice!", french=" Quoi...?[K] Cette voix!", german=" Was?[K] Diese Stimme!", italian=" Cosa...?[K] Quella voce!", spanish=" ¿Qué...?[K] ¡Esa voz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It... It can't be...", french=" Non... c'est impossible...", german=" Das... Das kann nicht sein...", italian=" Non... può essere...", spanish=" No... No puede ser..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It... It can't be...", french=" Non... c'est impossible...", german=" Das... Das kann nicht sein...", italian=" Non... può essere...", spanish=" No... No puede ser..."})
  else
  SkySceneKit.say({english=" It... It can't be...", french=" Non... c'est impossible...", german=" Das... Das kann nicht sein...", italian=" Non... può essere...", spanish=" No... No puede ser..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Hello to you all.[K] It's been a while.", french=" Salutations.[K] Cela faisait fort longtemps.", german="Hallo miteinander.[K] So sieht man sich\nwieder.", italian="Salve a tutti.[K] È da un po' che non ci\nvediamo.", spanish="Hola a todos.[K]\nCuánto tiempo sin vernos..."})
  -- message_Close
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Up)
  GROUND:EntTurn(npc_npc_serebii, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  pcall(function() GAME:MoveCamera(300, 308, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: BGM BGM_THE_POWER_OF_DARKNESS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" [CS:N]D-Dusknoir[CR]!", french=" [CS:N]Noctunoir[CR]!", german=" [CS:N]Z-Zwirrfinst[CR]!", italian=" [CS:N]D-Dusknoir[CR]!", spanish=" ¡[CS:N]Dusknoir[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR]...", french=" [CS:N]Noctunoir[CR]...", german=" [CS:N]Zwirrfinst[CR]...", italian=" [CS:N]Dusknoir[CR]...", spanish=" [CS:N]Dusknoir[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR]...", french=" [CS:N]Noctunoir[CR]...", german=" [CS:N]Zwirrfinst[CR]...", italian=" [CS:N]Dusknoir[CR]...", spanish=" [CS:N]Dusknoir[CR]..."})
  else
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR]...", french=" [CS:N]Noctunoir[CR]...", german=" [CS:N]Zwirrfinst[CR]...", italian=" [CS:N]Dusknoir[CR]...", spanish=" [CS:N]Dusknoir[CR]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(300, 416, 60, false) end) -- performer/caméra
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 304, 288, Direction.Down, "NPC_YONOWAARU")
  GROUND:MoveToPosition(npc_npc_yonowaaru, 300, 348, false, 1)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Your scurrying carried you far...", french="Ainsi donc, votre évasion vous\na conduits jusqu'ici...", german="Eure Wuselei hat euch ganz\nschön weit gebracht...", italian="La vostra fuga vi ha portato\nlontano...", spanish="Habéis llegado bastante lejos\nen vuestra huida, por lo que veo..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="But sad to say...[K] That's all\nover now.", french="Mais je suis au regret de vous\nannoncer que...[K] tout est fini à présent.", german="Umso trauriger,[K] dass für euch\njetzt alles vorbei ist.", italian="Mi spiace, ma...[K] ora è\ntutto finito.", spanish="Pero lamentablemente...[K]\nse acaba aquí."})
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_serebii.Position; GROUND:MoveToPosition(npc_npc_serebii, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(5)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(5)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 160, 312, Direction.Down, "NPC_YAMIRAMI")
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end) -- message_SetActor(ACTOR_NPC_YAMIRAMI)
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Wheh-heh-heh!", french=" Whé hé hé!", german=" Wähähäh!", italian=" Meh-eh-eh!", spanish=" ¡Je, je, je, je!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "shock", 1) end)
  GROUND:MoveToPosition(npc_npc_yamirami, 216, 364, false, 2)
  local npc_npc_yamirami2 = SkySceneKit.spawn_npc("sableye", 440, 304, Direction.Down, "NPC_YAMIRAMI2")
  GROUND:MoveToPosition(npc_npc_yamirami2, 384, 364, false, 2)
  local npc_npc_yamirami3 = SkySceneKit.spawn_npc("sableye", 160, 352, Direction.Down, "NPC_YAMIRAMI3")
  GROUND:MoveToPosition(npc_npc_yamirami3, 204, 396, false, 2)
  local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 456, 352, Direction.Down, "NPC_YAMIRAMI4")
  GROUND:MoveToPosition(npc_npc_yamirami4, 396, 396, false, 2)
  local npc_npc_yamirami5 = SkySceneKit.spawn_npc("sableye", 160, 400, Direction.Down, "NPC_YAMIRAMI5")
  GROUND:MoveToPosition(npc_npc_yamirami5, 208, 428, false, 2)
  local npc_npc_yamirami6 = SkySceneKit.spawn_npc("sableye", 448, 400, Direction.Down, "NPC_YAMIRAMI6")
  GROUND:MoveToPosition(npc_npc_yamirami6, 392, 428, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" The [CS:N]Sableye[CR] too...", french=" Les [CS:N]Ténéfix[CR] sont là, eux aussi...", german="Und da sind auch noch die\n[CS:N]Zobiris[CR]...", italian=" Ci sono anche i [CS:N]Sableye[CR]...", spanish=" Esos [CS:N]Sableye[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" The [CS:N]Sableye[CR] too...", french=" Les [CS:N]Ténéfix[CR] sont là, eux aussi...", german="Und da sind auch noch die\n[CS:N]Zobiris[CR]...", italian=" Ci sono anche i [CS:N]Sableye[CR]...", spanish=" Esos [CS:N]Sableye[CR]..."})
  else
  SkySceneKit.say({english=" The [CS:N]Sableye[CR] too...", french=" Les [CS:N]Ténéfix[CR] sont là, eux aussi...", german="Und da sind auch noch die\n[CS:N]Zobiris[CR]...", italian=" Ci sono anche i [CS:N]Sableye[CR]...", spanish=" Esos [CS:N]Sableye[CR]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Humph.[K] That's crafty, [CS:N]Dusknoir[CR].", french=" Pfff![K] Bien joué, [CS:N]Noctunoir[CR].", german="Hmpf.[K] Geschickt eingefädelt,\n[CS:N]Zwirrfinst[CR].", italian="Uhm.[K] È stato astuto da parte\ntua, [CS:N]Dusknoir[CR].", spanish=" Hum...[K] Muy hábil, [CS:N]Dusknoir[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="You allowed us to roam free, but\nyou kept your eye on us the whole time...", french="Tu nous as laissé partir, mais\ntu nous observais pendant tout ce temps...", german="Du ließt uns frei umherlaufen,\nhast uns aber die ganze Zeit beobachtet...", italian="Ci hai permesso di muoverci\nliberamente, ma allo stesso tempo non ci\nhai mai perso di vista...", spanish="Nos has dejado llegar hasta aquí,\npero sin perdernos nunca de vista..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="So you could capture [CS:N]Celebi[CR] as\nwell as us.", french="Ce qui te permettait de capturer\n[CS:N]Celebi[CR] en même temps que nous.", german="Das alles, damit du sowohl\n[CS:N]Celebi[CR] als auch uns gefangen nehmen kannst.", italian="E così ora hai la possibilità di\ncatturare sia noi che [CS:N]Celebi[CR].", spanish="Para, así, poder capturar\ntambién a [CS:N]Celebi[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?![K] So you mean we were...", french=" Quoi?![K] Alors tu veux dire que...", german=" Was?[K] Du meinst also...", italian="Cosa?![K] Vuoi dire che siamo\nstati...", spanish=" ¡¿Qué?![K] Quieres decir que..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?![K] So you mean we were...", french=" Quoi?![K] Alors tu veux dire que...", german=" Was?[K] Du meinst also...", italian="Cosa?![K] Vuoi dire che siamo\nstati...", spanish=" ¡¿Qué?![K] Quieres decir que..."})
  else
  SkySceneKit.say({english=" What?![K] So you mean we were...", french=" Quoi?![K] Alors tu veux dire que...", german=" Was?[K] Du meinst also...", italian="Cosa?![K] Vuoi dire che siamo\nstati...", spanish=" ¡¿Qué?![K] Quieres decir que..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" followed the whole time?!", french="... pendant tout ce temps, ils\nnous suivaient à la trace?!", german="Wir wurden die ganze Zeit\nverfolgt?", italian=" Ci avete seguito tutto il tempo?!", spanish="¿Nos han estado siguiendo todo\nel rato?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" followed the whole time?!", french="... pendant tout ce temps, ils\nnous suivaient à la trace?!", german="Wir wurden die ganze Zeit\nverfolgt?", italian=" Ci avete seguito tutto il tempo?!", spanish="¿Nos han seguido todo este\ntiempo?"})
  else
  SkySceneKit.say({english=" followed the whole time?!", french="... pendant tout ce temps, ils\nnous suivaient à la trace?!", german="Wir wurden die ganze Zeit\nverfolgt?", italian=" Ci avete seguito tutto il tempo?!", spanish="¿Nos han estado siguiendo todo\nel tiempo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Humph. I didn't see this coming.", french="Hmm. Je ne m'attendais pas\nà ça.", german="Hmpf. Das habe ich nicht\nkommen sehen.", italian="Uff... Non mi ero reso conto di\nnulla.", spanish=" Hum... No lo vi venir."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" It's all my fault, [CS:N]Celebi[CR].", french=" Tout est ma faute, [CS:N]Celebi[CR].", german=" Es ist alles meine Schuld, [CS:N]Celebi[CR].", italian=" È tutta colpa mia, [CS:N]Celebi[CR].", spanish=" Ha sido culpa mía, [CS:N]Celebi[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="Oh?[K] Apologies don't suit your\nstyle, my dear [CS:N]Grovyle[CR]!", french="Oh?[K] Mon cher [CS:N]Massko[CR],\ncela ne te ressemble pas de t'excuser!", german="Oh?[K] Entschuldigungen passen\nnicht zu deinem Stil, mein lieber [CS:N]Reptain[CR]!", italian="Oh?[K] Scusarsi non è nel tuo\nstile, mio caro [CS:N]Grovyle[CR]!", spanish="¿Eh?[K] Disculparte no es propio\nde ti, mi querido [CS:N]Grovyle[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="And do you honestly think that I\ncan be caught? Tee-hee!", french="Et crois-tu vraiment qu'on\npuisse me capturer? Hi hi!", german="Und glaubst du wirklich, dass ich\ngefangen werden kann? Hihi!", italian="Pensi davvero che mi possano\ncatturare? Eeh-eeh!", spanish="¿Realmente crees que pueden\ncogerme? ¡Ji, ji!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(8), p.Y+(8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami2.Position; GROUND:MoveToPosition(npc_npc_yamirami2, p.X+(-8), p.Y+(8), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_yamirami3.Position; GROUND:MoveToPosition(npc_npc_yamirami3, p.X+(8), p.Y+(8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(-8), p.Y+(8), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(8), p.Y+(8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami6.Position; GROUND:MoveToPosition(npc_npc_yamirami6, p.X+(-8), p.Y+(8), false, 1) end -- Move2PositionOffset
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Right)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Left)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(-8), p.Y+(8), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(5)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_serebii.Position; GROUND:MoveToPosition(npc_npc_serebii, p.X+(8), p.Y+(8), false, 1) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-8), p.Y+(0), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(5)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(8), p.Y+(0), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Everyone![K] Are you ready\nto fight?!", french="Eh![K] Est-ce que tout le monde est\nprêt à se battre?!", german="Leute![K] Seid ihr bereit zu\nkämpfen?", italian="Ehi, voi![K] Vi sentite in forma\nper la lotta?", spanish="¡Escuchadme![K] ¡Hay que\nenfrentarse a ellos! ¿Podéis hacerlo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?![K] You bet I am!", french="Hein?![K] Tu parles que\nje suis prêt!", german="Wie bitte?!?[K] Darauf kannst du\nwetten!", italian=" Eh?![K] Puoi scommetterci!", spanish=" ¡¿Cómo?![K] ¡Por supuesto que sí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?![K] Of course!", french="Hein?![K] Tu parles que\nje suis prêt!", german=" Was?!?[K] Selbstverständlich!", italian=" Cosa?![K] Certamente!", spanish=" ¡¿Qué?![K] ¡Por supuesto!"})
  else
  SkySceneKit.say({english=" What?![K] Of course!", french="Hein?![K] Tu parles que\nje suis prête!", german=" Was?!?[K] Selbstverständlich!", italian=" Cosa?![K] Certamente!", spanish=" ¡¿Qué?![K] ¡Por supuesto que sí!"})
  end
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We're going to power our\nway through!", french=" On va passer en force!", german="Wir werden uns den Weg\nfreipflügen!", italian=" Certo! Ce la possiamo fare!", spanish="¡Vamos a abrirnos paso como\nun ariete!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We'll push them aside...[K]\nThen dive into the Passage of Time!", french="Repoussons-les sur les côtés...[K]\nEt plongeons dans le Couloir du Temps!", german="Wir drängen sie zur Seite...[K]\nDann tauchen wir in den Zeittunnel ein!", italian="Li sconfiggiamo...[K]\nE poi ci tuffiamo nel Portale del Tempo!", spanish="Les tiraremos a un lado...[K]\n¡Y luego saltaremos en el Pasaje del Tiempo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" G-got it!", french=" Pigé!", german=" V-verstanden!", italian=" V-Va bene!", spanish=" ¡Entendido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" G-got it!", french=" Pigé!", german=" V-verstanden!", italian=" V-Va bene!", spanish=" ¡Entendido!"})
  else
  SkySceneKit.say({english=" G-got it!", french=" Pigé!", german=" V-verstanden!", italian=" V-Va bene!", spanish=" ¡Entendido!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Ha! So you'll resist?", french="Alors, comme ça, vous avez\nl'intention de nous résister?", german=" Ha! Ihr wollt euch widersetzen?", italian="Ah! Dunque volete opporre\nresistenza?", spanish=" ¡Ja! ¿Os resistís?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Spare yourself the effort.[K]\nYou have no chance of succeeding.", french="Ne vous donnez pas cette peine.[K]\nVous n'avez aucune chance.", german="Spart euch die Mühe.[K]\nDas ist völlig aussichtslos.", italian="Risparmiatevi lo sforzo...[K]\nNon avete alcuna possibilità.", spanish="Ahorraos el esfuerzo.[K]\nNo tenéis ninguna oportunidad."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(8), p.Y+(8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami2.Position; GROUND:MoveToPosition(npc_npc_yamirami2, p.X+(-8), p.Y+(8), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_yamirami3.Position; GROUND:MoveToPosition(npc_npc_yamirami3, p.X+(8), p.Y+(0), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(-8), p.Y+(0), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(8), p.Y+(0), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami6.Position; GROUND:MoveToPosition(npc_npc_yamirami6, p.X+(-8), p.Y+(0), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We won't know for sure...[K]until\nwe try!", french="Ça, on ne le saura...[K] qu'après\navoir essayé!", german="Das wissen wir nicht sicher...[K]\nZumindest nicht, bis wir es versucht haben!", italian="Come facciamo a saperlo...[K] se\nnon ci proviamo!", spanish="No lo sabremos con certeza...[K]\n¡hasta que lo hayamos intentado!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR]![K] You and me! Now!", french="[CS:N]Noctunoir[CR]![K] C'est entre toi\net moi! Maintenant!", german=" [CS:N]Zwirrfinst[CR]![K] Du und ich! Jetzt!", italian=" [CS:N]Dusknoir[CR]![K] Tu ed io! Ora!", spanish="¡[CS:N]Dusknoir[CR]![K] ¡Resolvamos\nesto entre tú y yo ahora mismo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CS:N]Grovyle[CR].[K] Are you really such a\nfool to think that I'd come alone?", french="[CS:N]Massko[CR].[K] Es-tu réellement assez\nstupide pour croire que je suis venu seul?", german="[CS:N]Reptain[CR].[K] Glaubst du, ich bin so\nnaiv, allein zu kommen?", italian="[CS:N]Grovyle[CR].[K] Sei davvero così folle\nda pensare che sarei venuto da solo?", spanish="[CS:N]Grovyle[CR]...[K] ¿Eres tan\ningenuo de creer que vendría solo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_juputoru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Wh-what?!", french=" Hein, quoi?!", german=" W-was?!?", italian=" C-Cosa?!", spanish=" ¿Qué?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_serebii, Direction.Up)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Now, Master [CS:N]Dialga[CR]!", french=" C'est à vous, Maître [CS:N]Dialga[CR]!", german=" Jetzt, Meister [CS:N]Dialga[CR]!", italian=" Ora, Grande [CS:N]Dialga[CR]!", spanish=" ¡Ahora, poderoso [CS:N]Dialga[CR]!"})
  -- message_Close
  -- GAP: se_Play(7434) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa![K] It turned pitch black!", french="Ouaaah![K] Il fait tout noir,\nd'un coup!", german="Holla![K] Es ist stockfinster\ngeworden!", italian=" Uaaah![K] È diventato buio pesto!", spanish=" ¡Aaah![K] ¡No se ve nada!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah![K] It turned pitch black!", french="Ouaaah![K] Il fait tout noir,\nd'un coup!", german="Uaah![K] Es ist stockfinster\ngeworden!", italian=" Uaaah![K] È diventato buio pesto!", spanish=" ¡Aaah![K] ¡No se ve nada!"})
  else
  SkySceneKit.say({english=" Waah![K] It turned pitch black!", french="Ouaaah![K] Il fait tout noir,\nd'un coup!", german="Uaah![K] Es ist stockfinster\ngeworden!", italian=" Uaaah![K] È diventato buio pesto!", spanish=" ¡Aaah![K] ¡No se ve nada!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(5)
  GAME:WaitFrames(2)
  GAME:FadeOut(false, 5)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(5)
  GAME:WaitFrames(2)
  GAME:FadeOut(false, 5)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  SkySceneKit.say({english="GRRR-OOOOOO!", french="GRRR-OOOOOO!", german="GRRR-OOOOOO!", italian="GRRR-OOOOOO!", spanish="¡GRRR! ¡GRRR!"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V19P01A) [décor sub chargé: Sub_v19p01a]
  -- back2_SetEffect(7, 0) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  -- camera2_SetPositionMark(Position<'m14', 19.5, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- GAP: se_Play(7431) — id SE NDS sans portage PMDO identifié
  SkySubScreen.Show("v19p01a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(15)
  -- camera2_SetPositionMark(Position<'m15', 58.5, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(4)
  -- camera2_SetPositionMark(Position<'m16', 97.5, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(90)
  GAME:WaitFrames(2) -- join WaitSe
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  -- back2_SetGround(V19P02A) [décor sub chargé: Sub_v19p02a]
  -- camera2_SetPositionMark(Position<'m17', 19.5, 17.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- supervision_Acting(3) [neutre/état moteur]
  -- GAP: BGM BGM_PLANETS_PARALYSIS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v19p02a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  GAME:WaitFrames(60)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V19P02A1_281) [routine d'objet NDS non simulée - documenté]
  -- camera2_SetEffect(2, 1, 1.0) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- SetAnimation(3) [anim idle native]
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  SkySceneKit.say({english="GRRR-OOOOOO...OOOOOH!", french="GRRR-OOOOOO... OOOOOH!", german="GRRR-OOOOOO...OOOOOH!", italian="GRRR-OOOOOO... OOOOOH!", spanish="¡GRRRR! ¡GRRRRR! ¡GRRRRRR!"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(90)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- message_CloseEnforce
  -- camera2_SetEffect(0, 0, 0) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  GAME:WaitFrames(30)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Uaaah!", italian=" Aaaaah!", spanish=" ¡Aaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Uaaah!", italian=" Aaaaah!", spanish=" ¡Aaah!"})
  else
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Uaaah!", italian=" Aaaaah!", spanish=" ¡Aaah!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" That...[K] That's...!", french=" C'est...[K] c'est...!", german=" Das...[K] Das ist...", italian=" Quello...[K] Quello è...!", spanish=" Eso...[K] Eso es..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Grovyle[CR]![K] What is it?! What is\nthat thing?!", french="[CS:N]Massko[CR]![K] Qu'est-ce qui\nse passe?! C'est quoi cette chose?!", german="[CS:N]Reptain[CR]![K] Was ist das? Was ist\ndieses Ding?", italian="[CS:N]Grovyle[CR]![K] Cos'è?! Cos'è quella\ncosa? Cos'è quella cosa?!", spanish="¡[CS:N]Grovyle[CR]![K]\n¿Qué pasa? ¿Qué es esa cosa?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Grovyle[CR]![K] What is it?! What is\nthat?!", french="[CS:N]Massko[CR]![K] Qu'est-ce qui\nse passe?! C'est quoi cette chose?!", german="[CS:N]Reptain[CR]![K] Was ist das? Was ist\ndieses Ding?", italian="[CS:N]Grovyle[CR]![K] Cos'è?! Cos'è quella\ncosa? Cos'è quella cosa?!", spanish="¡[CS:N]Grovyle[CR]![K]\n¿Qué pasa? ¿Qué es esa cosa?"})
  else
  SkySceneKit.say({english="[CS:N]Grovyle[CR]![K] What is it?! What is\nthat?!", french="[CS:N]Massko[CR]![K] Qu'est-ce qui\nse passe?! C'est quoi cette chose?!", german="[CS:N]Reptain[CR]![K] Was ist das? Was ist\ndieses Ding?", italian="[CS:N]Grovyle[CR]![K] Cos'è?! Cos'è quella\ncosa? Cos'è quella cosa?!", spanish="¡[CS:N]Grovyle[CR]![K]\n¿Qué pasa? ¿Qué es esa cosa?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" That's...[K]Primal...[K][CS:N]Dialga[CR]...", french=" C'est... [K][CS:N]Dialga[CR]...[K] Primal...", german=" Das ist...[K] [CS:N]Schatten-Dialga[CR]...", italian=" Quello è...[K] [CS:N]Dialga[CR]...[K] Oscuro...", spanish="Eso de ahí...[K] es...[K]\nel [CS:N]Dialga Primario[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What!?![K] That is?!", french=" Quoi!?![K] Qu'est-ce que tu dis?!", german=" Was!?![K] Das?!?", italian=" Cosa!?![K] Quello?!", spanish=" ¡¿Qué?![K] ¡¿Eso?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What!?![K] That is?!", french=" Quoi!?![K] Qu'est-ce que tu dis?!", german=" Was!?![K] Das?!?", italian=" Cosa!?![K] Quello?!", spanish=" ¡¿Qué?![K] ¡¿Eso?!"})
  else
  SkySceneKit.say({english=" What!?![K] That is?!", french=" Quoi!?![K] Qu'est-ce que tu dis?!", german=" Was!?![K] Das?!?", italian=" Cosa!?![K] Quello?!", spanish=" ¡¿Qué?![K] ¡¿Eso?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That's Primal [CS:N]Dialga[CR]?!", french=" Ça, c'est [CS:N]Dialga[CR] Primal?!", german=" Das ist [CS:N]Schatten-Dialga[CR]?!?", italian=" Quello è [CS:N]Dialga[CR] Oscuro?!", spanish=" ¡¿Eso es el [CS:N]Dialga Primario[CR]?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's Primal [CS:N]Dialga[CR]?!", french=" Ça, c'est [CS:N]Dialga[CR] Primal?!", german=" Das ist [CS:N]Schatten-Dialga[CR]?!?", italian=" Quello è [CS:N]Dialga[CR] Oscuro?!", spanish=" ¡¿Eso es el [CS:N]Dialga Primario[CR]?!"})
  else
  SkySceneKit.say({english=" That's Primal [CS:N]Dialga[CR]?!", french=" Ça, c'est [CS:N]Dialga[CR] Primal?!", german=" Das ist [CS:N]Schatten-Dialga[CR]?!?", italian=" Quello è [CS:N]Dialga[CR] Oscuro?!", spanish=" ¡¿Eso es el [CS:N]Dialga Primario[CR]?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="What's wrong, [CS:N]Grovyle[CR]?[K]\nWhere's your bravado now?", french="Que t'arrive-t-il, [CS:N]Massko[CR]?[K]\nOù sont passées tes fanfaronnades?", german="Was ist los, [CS:N]Reptain[CR]?[K]\nWo ist dein Heldenmut geblieben?", italian="Cos'hai, [CS:N]Grovyle[CR]?[K] Dov'è finita\nla tua spavalderia adesso?", spanish="¿Qué te pasa, [CS:N]Grovyle[CR]?[K]\n¿Dónde está tu bravuconería?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Gah...", french=" Argh...", german=" Pah...", italian=" Aah...", spanish=" Aaah..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_serebii, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" My dear [CS:N]Grovyle[CR]...", french=" Mon cher [CS:N]Massko[CR]...", german=" Mein lieber [CS:N]Reptain[CR]...", italian=" Mio caro [CS:N]Grovyle[CR]...", spanish=" Mi querido [CS:N]Grovyle[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_juputoru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Urf...[K] This...[K]is it for us...", french="Ah...[K] Cette fois...[K] c'en est fini\nde nous...", german="Uff...[K] Das...[K] Das war es für\nuns...", italian=" Uff...[K] È...[K] finita...", spanish="Uf...[K] Me temo que...[K]\nha llegado el final..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?! Why?!", french=" Hein?! Mais pourquoi?!", german=" Wie?!? Warum?!?", italian=" Eh?! Perché?!", spanish=" ¡¿Eh?! ¿Por qué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?! Why?!", french=" Hein?! Mais pourquoi?!", german=" Was?!? Warum?!?", italian=" Cosa?! Perché?!", spanish=" ¡¿Eh?! ¿Por qué?"})
  else
  SkySceneKit.say({english=" What?! Why?!", french=" Hein?! Mais pourquoi?!", german=" Was?!? Warum?!?", italian=" Cosa?! Perché?!", spanish=" ¡¿Eh?! ¿Por qué?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Aren't we going to fight?!", french=" On va se battre, pas vrai?!", german=" Wollen wir denn nicht kämpfen?", italian=" Non lottiamo?", spanish=" ¡¿Es que no vamos a luchar?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Aren't we going to fight?!", french=" On va se battre, pas vrai?!", german=" Wollen wir denn nicht kämpfen?", italian=" Non lottiamo?", spanish=" ¡¿Es que no vamos a luchar?!"})
  else
  SkySceneKit.say({english=" Aren't we going to fight?!", french=" On va se battre, pas vrai?!", german=" Wollen wir denn nicht kämpfen?", italian=" Non lottiamo?", spanish=" ¡¿Es que no vamos a luchar?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="It's hopeless...[K] [CS:N]Dusknoir[CR] on his\nown is one thing...", french="C'est sans espoir...[K] [CS:N]Noctunoir[CR]\ntout seul, c'est une chose...", german="Es ist aussichtslos...[K] [CS:N]Zwirrfinst[CR]\nallein ist eine Sache...", italian="Non abbiamo speranze...[K]\n[CS:N]Dusknoir[CR] da solo è una cosa...", spanish="Es inútil.[K]\nUna cosa es enfrentarse a [CS:N]Dusknoir[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="But we don't stand a chance\nagainst [CS:N]Dialga[CR].", french="Mais nous n'avons pas la\nmoindre chance face à [CS:N]Dialga[CR].", german="Aber gegen [CS:N]Dialga[CR] haben wir\nkeine Chance.", italian="Ma contro [CS:N]Dialga[CR] non abbiamo\nalcuna possibilità.", spanish="Contra [CS:N]Dialga[CR] no tenemos ninguna\noportunidad."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" You two have kept up so well...", french="Vous avez prouvé votre valeur\njusqu'ici...", german="Ihr zwei habt euch so gut\ngeschlagen...", italian="Avete retto benissimo fino a\nqui...", spanish="Lo habéis hecho muy bien hasta\nahora..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I'm sorry to let you down.[K]\nThis is where it ends.", french="Désolé de vous décevoir.[K]\nMais c'est ici que tout s'arrête.", german="Es tut mir leid, dass ich euch\nhängen lassen muss.[K] Hier endet die Geschichte.", italian="Mi dispiace deludervi.[K]\nÈ finita.", spanish="Siento que todo acabe así.[K]\nMe temo que este es el fin."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But...", french=" Mais...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But...", french=" Mais...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  else
  SkySceneKit.say({english=" But...", french=" Mais...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(0), p.Y+(-8), false, 1) end
  GROUND:EntTurn(npc_npc_serebii, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" I surrender, [CS:N]Dusknoir[CR].", french=" Je me rends, [CS:N]Noctunoir[CR].", german=" Ich gebe auf, [CS:N]Zwirrfinst[CR].", italian=" Mi arrendo, [CS:N]Dusknoir[CR].", spanish=" Me rindo, [CS:N]Dusknoir[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Do with me...as you will.", french=" Fais ce que tu veux de moi.", german="Verfüge über mich... nach\nBelieben.", italian=" Fa' di me... ciò che vuoi.", spanish=" Haz conmigo... lo que quieras."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" My d-d-dear [CS:N]Grovyle[CR]!", french=" Non, mon cher [CS:N]Massko[CR]!", german=" Mein l-l-lieber [CS:N]Reptain[CR]!", italian=" Mio c-c-caro [CS:N]Grovyle[CR]!", spanish=" Mi... ¡mi querido [CS:N]Grovyle[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" What's the matter, [CS:N]Grovyle[CR]?", french=" Qu'est-ce qui se passe, [CS:N]Massko[CR]?", german=" Was ist los mit dir, [CS:N]Reptain[CR]?", italian=" Cosa ti prende, [CS:N]Grovyle[CR]?", spanish=" ¿Qué te ha ocurrido, [CS:N]Grovyle[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="It's not like you to give up\nso easily.", french="Je ne suis guère accoutumé\nà te voir renoncer si facilement.", german="Sonst gibst du doch nicht so\nleicht auf.", italian="Non è da te rinunciare così\nfacilmente.", spanish="No es propio de ti rendirte de\nesa forma."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Yes.[K] I am giving up.", french=" Oui.[K] Je renonce, en effet.", german=" Ja.[K] Ich gebe auf.", italian=" Sì.[K] Mi arrendo.", spanish=" Es cierto.[K] Me rindo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" But...[K]hope is still alive.", french="Mais...[K] il y a toujours de\nl'espoir.", german=" Aber...[K] die Hoffnung lebt.", italian="Ma...[K] la speranza è ancora\nviva.", spanish=" Pero...[K] aún hay esperanza."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, npc_npc_serebii, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" [CS:N]Celebi[CR], you remember...", french=" [CS:N]Celebi[CR], souviens-toi...", german=" [CS:N]Celebi[CR], du erinnerst dich...", italian=" [CS:N]Celebi[CR], ti ricordi?", spanish=" [CS:N]Celebi[CR], quizás recuerdes que..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, npc_npc_yonowaaru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That last time...[K]when I traveled\nback in time to prevent the planet's paralysis...", french="La dernière fois...[K] quand je suis\nparti dans le passé pour empêcher la Paralysie\nde la Planète...", german="Das letzte Mal,[K] als ich durch\ndie Zeit zurückreiste, um die Lähmung des\nPlaneten zu verhindern...", italian="L'ultima volta...[K] che\nsono tornato indietro nel tempo per\nevitare la paralisi del pianeta...", spanish="Cuando viajé en el tiempo la vez\nanterior...[K] para evitar la parálisis del planeta..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I wasn't alone.[K] There was\nanother.", french="Je n'étais pas seul.[K] Il y avait\nquelqu'un d'autre avec moi.", german="Ich war nicht allein.[K] Es gab da\nnoch jemanden.", italian="Quella volta non ero da solo.[K]\nSono tornato con qualcuno.", spanish="No estaba solo.[K] Me acompañaba\nalguien."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What?![K] [CS:N]Grovyle[CR], you didn't come\nto our world by yourself?!", french="Quoi?![K] [CS:N]Massko[CR], tu n'es pas venu\nseul dans notre monde?!", german="Was?[K] [CS:N]Reptain[CR], du bist nicht\nallein in unsere Welt gekommen?", italian="Cosa?![K] [CS:N]Grovyle[CR], non sei\nvenuto nel nostro mondo da solo?!", spanish="¡¿Qué?![K] [CS:N]Grovyle[CR],\n¿no viniste solo a nuestro mundo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What?![K] [CS:N]Grovyle[CR], you didn't come\nto our world alone?!", french="Quoi?![K] [CS:N]Massko[CR], tu n'es pas venu\nseul dans notre monde?!", german="Was?[K] [CS:N]Reptain[CR], du bist nicht\nallein in unsere Welt gekommen?", italian="Cosa?![K] [CS:N]Grovyle[CR], non sei\nvenuto nel nostro mondo da solo?!", spanish="¡¿Qué?![K] [CS:N]Grovyle[CR],\n¿no viniste solo a nuestro mundo?"})
  else
  SkySceneKit.say({english="What?![K] [CS:N]Grovyle[CR], you didn't come\nto our world by yourself?!", french="Quoi?![K] [CS:N]Massko[CR], tu n'es pas venu\nseul dans notre monde?!", german="Was?[K] [CS:N]Reptain[CR], du bist nicht\nallein in unsere Welt gekommen?", italian="Cosa?![K] [CS:N]Grovyle[CR], non sei\nvenuto nel nostro mondo da solo?!", spanish="¡¿Qué?![K] [CS:N]Grovyle[CR],\n¿no viniste solo a nuestro mundo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" That's right.[K] I had a partner.", french="Non.[K] J'étais accompagné lors\nde ce voyage.", german="Das stimmt.[K] Ich hatte einen\nPartner.", italian=" È così.[K] Non ero da solo.", spanish=" Así es.[K] Alguien me acompañaba."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We headed to the past together.", french="Nous sommes partis ensemble\ndans le passé.", german="Wir sind zusammen in die\nVergangenheit gereist.", italian=" Siamo venuti in due nel passato.", spanish=" Fuimos juntos al pasado."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="But when we were going through\nthe Passage of Time, we had trouble...", french="Mais il y a eu un problème alors\nque nous traversions le Couloir du Temps...", german="Aber als wir durch den\nZeittunnel reisten, gab es Probleme...", italian="Ma quando siamo passati\nattraverso il Portale del Tempo, c'è\nstato un imprevisto...", spanish="Pero al cruzar el Pasaje del\nTiempo hubo ciertas complicaciones..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We became separated.", french=" Nous avons été séparés.", german=" Wir wurden getrennt.", italian=" Siamo stati separati.", spanish=" Y nos separamos."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="My partner should still be back\nin the world of the past.", french="Mon acolyte doit encore se\ntrouver dans le monde du passé.", german="Mein Partner ist wohl immer\nnoch in der Welt der Vergangenheit.", italian="Chi era con me dev'essere\nancora da qualche parte nel passato.", spanish="Mi acompañante aún debe de\nestar en el mundo del pasado."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Even if I am eliminated...", french=" Même si on m'élimine...", german="Sogar wenn ich aus dem Weg\ngeräumt werde...", italian="E anche se io non posso fare\npiù niente...", spanish=" Aunque me eliminéis..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="My partner will see our mission\nthrough to the end.", french="... notre mission sera menée\nà bien.", german="Mein Partner wird unsere\nMission zu Ende führen.", italian="... la nostra missione verrà\nportata a termine.", spanish="Mi camarada se encargará de\ncumplir nuestra misión."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="My partner will prevent the\nplanet's paralysis.", french="Et la Paralysie de la Planète\nsera évitée.", german="Mein Partner wird die Lähmung\ndes Planeten aufhalten.", italian="La paralisi del pianeta sarà\nfermata.", spanish="Estoy seguro de que logrará\nevitar la parálisis del planeta."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(180) end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Ha![K] Ha-ha-ha! Hoo-hoo-ha!", french=" Ha![K] Ha ha ha! Ha ha ha!", german=" Ha![K] Ha-ha-ha! Ho-ho-ha!", italian=" Ah![K] Ah-ah-ah! Oh-oh-oh!", spanish=" ¡Ja![K] ¡Ja, ja, ja! ¡Ja, jua, jua!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, npc_npc_yonowaaru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" What's...[K] What's so funny?", french="Que...[K] qu'est-ce qu'il y a de\nsi drôle?", german=" Was...[K] Was ist denn so lustig?", italian="Cosa...[K] Cosa c'è di così\ndivertente?", spanish="Pero qué...[K]\n¿Qué te hace tanta gracia?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Ha![K] So you claim someone went\nto the past with you...", french="Ha![K] Alors tu affirmes que\ntu n'es pas le seul à être parti dans le passé...", german="Ha![K] Du behauptest also, jemand\nsei mit dir durch die Zeit gereist...", italian="Ah![K] Quindi sostieni che qualcuno\nè venuto nel passato con te...", spanish="¡Ja![K] Dices que alguien fue\ncontigo al pasado..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Incidentally, what's the name of\nyour partner?", french="A tout hasard, peut-on connaître\nle nom de ton acolyte?", german="Wie heißt denn dein Partner\neigentlich?", italian="E sentiamo un po', qual è il suo\nnome?", spanish="Ahora que lo mencionas, ¿cómo\nse llamaba tu acompañante?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Go on. Say the name.", french=" Son nom, dis-nous son nom.", german=" Komm schon. Sag den Namen.", italian=" Coraggio. Dicci come si chiama.", spanish="Venga, dilo. Te estamos\nescuchando."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Why ask such a thing?", french=" Et pourquoi ça?", german=" Warum so eine Frage?", italian=" Perché lo vuoi sapere?", spanish=" ¿Para qué lo preguntas?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Can't tell me?", french="Serais-tu dans l'incapacité de\nme le dire?", german=" Kannst du ihn mir nicht sagen?", italian=" Non me lo puoi dire?", spanish=" ¿No te atreves a decírmelo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="No, that's not true.[K] My partner's\nname is [hero].", french="Non, je le connais.[K] Son nom est\n[hero].", german="Doch.[K] Der Name\nmeines Partners ist [hero].", italian="No, non è così.[K] Il suo nome è\n[hero].", spanish="Por supuesto que me atrevo.[K]\nEl nombre de mi acompañante es [hero]."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" My best friend...", french="Nous sommes les meilleurs\namis du monde...", german=" Mein bester Freund...", italian="L'essere vivente che mi sta più\na cuore...", spanish=" Éramos muy amigos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What?!)", french="(Quoi?!)", german="(Was?!?)", italian="(Cosa?!)", spanish="(¡¿Qué?!)"})
  else
  SkySceneKit.say({english="(What?!)", french="(Quoi?!)", german="(Was?!?)", italian="(Cosa?!)", spanish="(¡¿Qué?!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Uh...what?!", french=" Quoi... qu'est-ce que tu dis?!", german=" Äh... Was?!?", italian=" Uh... Cosa?!", spanish=" Eh... ¡¿Cómo?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-what?!", french=" Quoi... qu'est-ce que tu dis?!", german=" W-was?!?", italian=" C-Cosa?!", spanish=" Eh... ¡¿Cómo?!"})
  else
  SkySceneKit.say({english=" Wh-what?!", french=" Quoi... qu'est-ce que tu dis?!", german=" W-was?!?", italian=" C-Cosa?!", spanish=" Eh... ¡¿Cómo?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Grovyle[CR]![K] You said\n[hero]?!", french="[CS:N]Massko[CR]![K] Tu as bien dit\n[hero]?!", german="[CS:N]Reptain[CR]![K] Sagtest du\n[hero]?!?", italian="[CS:N]Grovyle[CR]![K] Hai detto\n[hero]?!", spanish="¡[CS:N]Grovyle[CR]![K]\n¡¿Has dicho [hero]?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Grovyle[CR]![K] Did you say\n[hero]?!", french="[CS:N]Massko[CR]![K] Tu as bien dit\n[hero]?!", german="[CS:N]Reptain[CR]![K] Sagtest du\n[hero]?!?", italian="[CS:N]Grovyle[CR]![K] Hai detto\n[hero]?!", spanish="¡[CS:N]Grovyle[CR]![K]\n¡¿Has dicho [hero]?!"})
  else
  SkySceneKit.say({english="[CS:N]Grovyle[CR]![K] Did you say\n[hero]?!", french="[CS:N]Massko[CR]![K] Tu as bien dit\n[hero]?!", german="[CS:N]Reptain[CR]![K] Sagtest du\n[hero]?!?", italian="[CS:N]Grovyle[CR]![K] Hai detto\n[hero]?!", spanish="¡[CS:N]Grovyle[CR]![K]\n¡¿Has dicho [hero]?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Well, this is [hero]\nright here!", french="[hero] est ici avec nous!\nLà, regarde!", german=" Nun, das hier ist [hero]!", italian=" Beh, [hero] è proprio qui!", spanish=" ¡[hero] está aquí mismo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well, this is [hero]\nright here!", french="[hero] est ici avec nous!\nLà, regarde!", german=" Nun, das hier ist [hero]!", italian=" Beh, [hero] è proprio qui!", spanish=" ¡[hero] está aquí mismo!"})
  else
  SkySceneKit.say({english="Well, this is [hero]\nright here!", french="[hero] est ici avec nous!\nLà, regarde!", german=" Nun, das hier ist [hero]!", italian=" Beh, [hero] è proprio qui!", spanish=" ¡[hero] está aquí mismo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_serebii, hero, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" What?!", french=" Pardon?!", german=" Was?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" You're...[K][hero]?", french=" Tu es...[K] [hero]?", german=" Du bist...[K] [hero]?", italian=" Tu sei...[K] [hero]?", spanish=" ¿Tú eres...?[K] ¿[hero]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" ...[K]No...[K]it can't be. It isn't.", french="... [K]Non...[K] c'est impossible.\nÇa ne peut pas être toi.", german="...[K]Nein...[K] Das kann nicht sein.\nEs kann nicht sein.", italian="...[K] No...[K] Non può essere.\nNon è così.", spanish=" No...[K] No...[K] No puede ser."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="The [hero] I know isn't\na Pokémon.", french="La personne que je connais\ndu nom de [hero] n'est pas un Pokémon.", german="[hero] ist kein Pokémon.\nDas weiß ich genau.", italian="Io conosco [hero], non è\nun Pokémon.", spanish="[hero] no era un\nPokémon."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="The [hero] that I\nknow...[K]is a human.", french=" C'est...[K] un être humain.", german=" [hero] ist...[K] ein Mensch.", italian="[hero] è...[K] un essere\numano.", spanish="[hero]...[K] era un ser\nhumano."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  else
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Hidden Highland.ogg", true) end)
  -- SetAnimation(49) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Hoo-hoo-ha![K] Precisely!", french=" Ha ha ha![K] Précisément!", german=" Ho-ho-ha![K] Ganz genau!", italian=" Ooh-ooh-ah![K] Per l'appunto!", spanish=" ¡Ja, jua, jua![K] ¡Precisamente!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yonowaaru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_serebii, npc_npc_yonowaaru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="My good fellow! [CS:N]Grovyle[CR], that\nis unmistakably your friend [hero]!", french="Mon brave [CS:N]Massko[CR], il s'agit bel\net bien de [hero]!", german="Mein Bester! [CS:N]Reptain[CR], das ist\nunverkennbar dein Partner [hero]!", italian="Mio caro [CS:N]Grovyle[CR]! Questo è\nsenza ombra di dubbio l'essere umano\n[hero]!", spanish="¡Amigo mío! [CS:N]Grovyle[CR], ahí tienes,\nsin la menor duda, a tu camarada [hero]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" What?!", french=" Pardon?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Cómo?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="That Pokémon you see was once\na human!", french="Autrefois, le Pokémon ici\nprésent était un être humain!", german="Das Pokémon vor deinen Augen\nwar früher ein Mensch!", italian="Questo Pokémon una volta era\nun essere umano!", spanish="Ese Pokémon que tienes ante ti\nera un ser humano."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, npc_npc_yonowaaru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Wh-what?!", french=" Que... quoi?!", german=" W-was?!?", italian=" C-Cosa?!", spanish=" ¡¿Qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Master [CS:N]Dialga[CR] had given me a\nmission...", french="Maître [CS:N]Dialga[CR] m'avait confié\nune mission...", german="Meister [CS:N]Dialga[CR] gab mir einen\nAuftrag...", italian="Il Grande [CS:N]Dialga[CR] mi ha assegnato\nuna missione...", spanish="El poderoso [CS:N]Dialga[CR] me encargó\nuna misión..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="It was to get rid of you,\n[CS:N]Grovyle[CR], and [hero]. Because you fled\nto the past.", french="Je devais me débarrasser de\nvous deux, [CS:N]Massko[CR] et [hero].\nParce que vous aviez fui dans le passé.", german="Ich sollte euch beseitigen,\n[CS:N]Reptain[CR] und [hero], weil ihr in die\nVergangenheit geflüchtet seid.", italian="Devo liberarmi di voi, [CS:N]Grovyle[CR] e\n[hero], perché siete fuggiti nel passato.", spanish="Debido a vuestra huida al pasado,\ntenía que librarme de ti, [CS:N]Grovyle[CR], y de\n[hero]."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I traveled through time in\npursuit of you both.", french="Je me suis lancé à vos trousses\nà travers le temps.", german="Ich reiste durch die Zeit, um\neuch zu verfolgen.", italian="Ho viaggiato nel tempo al vostro\ninseguimento.", spanish="Viajé en el tiempo para\nencontraros a ambos."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="In the past, I gathered\nintelligence that might help me find you.", french="J'ai rassemblé dans le passé des\nindices susceptibles de m'aider à vous\nlocaliser.", german="In der Vergangenheit sammelte\nich Informationen, die mir helfen sollten, euch\nzu finden.", italian="Nel passato, ho acquisito\nle informazioni necessarie per trovarvi.", spanish="Una vez en el pasado me dediqué\na reunir toda la información posible para dar\ncon vosotros."})
  -- message_Close
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
