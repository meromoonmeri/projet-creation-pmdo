-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m03a0102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P03A, 'UM03') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 368, 184, Direction.Down, "NPC_PERAPPU")
  GROUND:MoveToPosition(npc_npc_perappu, 416, 212, false, 2)
  GAME:WaitFrames(30)
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 460, 244, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(30)
  -- supervision_Acting(3) [neutre/état moteur]
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(partner, 428, 244, false, 2)
  pcall(function() GAME:MoveCamera(444, 228, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?", french=" Quoi?", german=" Häh?", italian=" Eh?", spanish=" ¿Eh?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh?", french=" Quoi?", german=" Häh?", italian=" Eh?", spanish=" ¿Eh?"})
  else
  SkySceneKit.say({english=" Oh?", french=" Quoi?", german=" Oh?", italian=" Eh?", spanish=" ¿Eh?"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Left)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Last time we did a job, it was\nfrom the board on the other side...", french="La dernière fois que nous avons\nfait une mission, elle était affichée sur le\ntableau qui est de l'autre côté...", german="Letztes Mal hatten wir einen Job\nvon dem Brett auf der anderen Seite.", italian="L'ultima volta che abbiamo fatto\nuna missione, l'abbiamo scelta dalla Bacheca\ndall'altra parte...", spanish="Nuestra misión anterior era del\notro tablón, ¿no?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Last time we did a job, it was\nfrom the board on the other side...", french="La dernière fois que nous avons\nfait une mission, elle était affichée sur le\ntableau qui est de l'autre côté...", german="Letztes Mal hatten wir einen Job\nvon dem Brett auf der anderen Seite.", italian="L'ultima volta che abbiamo fatto\nuna missione, l'abbiamo scelta dalla Bacheca\ndall'altra parte...", spanish="Me parece que nuestra misión\nanterior estaba puesta en el otro tablón."})
  else
  SkySceneKit.say({english="Last time we did a job, it was\nfrom the board on the other side...", french="La dernière fois que nous avons\nfait une mission, elle était affichée sur le\ntableau qui est de l'autre côté...", german="Letztes Mal hatten wir einen Job\nvon dem Brett auf der anderen Seite.", italian="L'ultima volta che abbiamo fatto\nuna missione, l'abbiamo scelta dalla Bacheca\ndall'altra parte...", spanish="Si no recuerdo mal, nuestra\nmisión anterior era del otro tablón."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Correct! ♪", french=" Exact! ♪", german=" Sehr richtig! ♪", italian=" Esatto! ♪", spanish=" ¡Así es! ♪"})
  -- message_Close
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Today, we'll have you do a job\nlisted on this side. ♪", french="Aujourd'hui, vous allez faire une\nmission qui se trouve de ce côté. ♪", german="Heute werdet ihr einen Job von\ndiesem Brett erledigen. ♪", italian="Oggi, sceglieremo una delle\nmissioni affisse su questa Bacheca. ♪", spanish="Hoy os encargaréis de una\nde las misiones de este de aquí. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="How is this different from the\nboard on the other side?", french="Quelle est la différence entre\nces missions et celles qui sont affichées de\nl'autre côté?", german="Was ist denn an diesem Brett\nanders?", italian=" Che differenza c'è?", spanish="¿Qué diferencia hay entre\nuno y otro?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="How is this different from the\nboard on the other side?", french="Quelle est la différence entre\nces missions et celles qui sont affichées de\nl'autre côté?", german="Was ist denn an diesem Brett\nanders?", italian=" Che differenza c'è?", spanish="¿Cuál es la diferencia\ncon el otro tablón?"})
  else
  SkySceneKit.say({english="How is this different from the\nboard on the other side?", french="Quelle est la différence entre\nces missions et celles qui sont affichées de\nl'autre côté?", german="Was ist denn an diesem Brett\nanders?", italian=" Che differenza c'è?", spanish="¿En qué se diferencia este de\naquel?"})
  end
  -- message_Close
  GROUND:EntTurn(npc_npc_perappu, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Take a closer look! ♪", french=" Regardez plus attentivement! ♪", german=" Seht genauer hin! ♪", italian=" Guardate meglio! ♪", spanish=" ¡Fijaos bien! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V03P01A) [décor sub chargé: Sub_v03p01a]
  -- camera2_SetPositionMark(Position<'m4', 19.5, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v03p01a", 15, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! Check it out, [hero]!", french=" Oh! Regarde, [hero]!", german="Hey! Sieh dir das an,\n[hero]!", italian=" Ehi! Guarda qui, [hero]!", spanish=" ¡Anda! ¡Mira, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, look, [hero]!", french=" Oh! Regarde, [hero]!", german=" Oh, sieh mal, [hero]!", italian=" Oh! Guarda qui, [hero]!", spanish=" ¡Oh! ¡Mira, [hero]!"})
  else
  SkySceneKit.say({english=" Oh! Look at this, [hero]!", french=" Oh! Regarde, [hero]!", german=" Oh! Sieh mal, [hero]!", italian=" Oh! Guarda, [hero]!", spanish=" ¡Vaya! ¡Mira esto, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="There are posters up here that\nshow a variety of Pokémon!", french="Il y a des affiches qui montrent\ndifférents Pokémon!", german="Da hängen Plakate von lauter\nverschiedenen Pokémon!", italian="Qui ci sono affisse le immagini\ndi tanti Pokémon diversi!", spanish="¡Aquí hay carteles de distintos\nPokémon!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There are posters up here that\nshow a variety of Pokémon!", french="Il y a des affiches qui montrent\ndifférents Pokémon!", german="Da hängen Plakate von lauter\nverschiedenen Pokémon!", italian="Qui ci sono affisse le immagini\ndi tanti Pokémon diversi!", spanish="¡Han colgado carteles de\ndistintos Pokémon!"})
  else
  SkySceneKit.say({english="There are posters up here that\nshow a variety of Pokémon!", french="Il y a des affiches qui montrent\ndifférents Pokémon!", german="Da hängen Plakate von lauter\nverschiedenen Pokémon!", italian="Qui ci sono affisse le immagini\ndi tanti Pokémon diversi!", spanish="¡Aquí hay carteles colgados\nde distintos Pokémon!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Wow, they all look pretty cool!\nAre they famous explorers or something?", french="Waouh, ils ont l'air cool!\nCe sont des explorateurs célèbres?", german="Wow, sehen die cool aus!\nSind das berühmte Erkunder oder so?", italian="Wow, sembrano tutti dei tipi\ngiusti! Sono esploratori famosi o qualcosa\ndel genere?", spanish="¡Cómo molan! ¿Son\nexploradores famosos o algo así?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wow, they all look pretty cool!\nAre they famous explorers?", french="Waouh, ils ont l'air cool!\nCe sont des explorateurs célèbres?", german="Wow, sehen die cool aus!\nSind das berühmte Erkunder?", italian="Wow, sembrano tutti molto\ninteressanti! Sono esploratori famosi o\nqualcosa del genere?", spanish="¡Cómo molan!\n¿Son exploradores famosos?"})
  else
  SkySceneKit.say({english="Wow, they all look sort of cool!\nAre they famous explorers?", french="Waouh, ils ont l'air cool!\nCe sont des explorateurs célèbres?", german="Wow, die sehen irgendwie cool\naus! Sind das berühmte Erkunder?", italian="Wow, sembrano tutti Pokémon\ninteressanti! Sono esploratori famosi o\nqualcosa del genere?", spanish="¡Cómo molan! ¿Son\nexploradores famosos o algo así?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Who are these Pokémon, [CS:N]Chatot[CR]?", french=" [CS:N]Pijako[CR], qui sont ces Pokémon?", german="Was sind das für Pokémon,\n[CS:N]Plaudagei[CR]?", italian="Chi sono questi Pokémon,\n[CS:N]Chatot[CR]?", spanish="¿Quiénes son estos Pokémon,\n[CS:N]Chatot[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Who are these Pokémon, [CS:N]Chatot[CR]?", french=" [CS:N]Pijako[CR], qui sont ces Pokémon?", german="Was sind das für Pokémon,\n[CS:N]Plaudagei[CR]?", italian="Chi sono questi Pokémon,\n[CS:N]Chatot[CR]?", spanish="¿Quiénes son estos Pokémon,\n[CS:N]Chatot[CR]?"})
  else
  SkySceneKit.say({english=" Who are these Pokémon, [CS:N]Chatot[CR]?", french=" [CS:N]Pijako[CR], qui sont ces Pokémon?", german="Was sind das für Pokémon,\n[CS:N]Plaudagei[CR]?", italian="Chi sono questi Pokémon,\n[CS:N]Chatot[CR]?", spanish="¿Quiénes son estos Pokémon,\n[CS:N]Chatot[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The Pokémon posted here...[K]\nare outlaws.", french="Les Pokémon affichés ici...[K]\nsont des hors-la-loi.", german="Die hier abgebildeten\nPokémon...[K] sind Ganoven.", italian="Questi Pokémon...[K] sono dei\nricercati.", spanish="Estos Pokémon de aquí...[K]\nson malhechores."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="They're all shady characters.\nAnd they're wanted for committing crimes.", french="Ce sont des personnages peu\nrecommandables. Ils sont recherchés pour\nles crimes qu'ils ont commis.", german="Das sind alles sehr fragwürdige\nTypen, gesuchte Verbrecher.", italian="Sono tutti dei tipi loschi. E sono\nricercati perché hanno commesso dei crimini.", spanish="No son de fiar y se les busca\npor haber cometido delitos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What?![K] They're all wanted by\nthe law?", french="Quoi?![K] Ce sont tous\ndes hors-la-loi?", german="Was?!?[K] Sie werden alle als\nVerbrecher gesucht?", italian="Cosa?![K] Sono ricercati dalla\nlegge?", spanish="¡¿Qué?![K]\n¿Todos ellos han violado la ley?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh no![K] They're outlaws?!", french="Quoi?![K] Ce sont tous\ndes hors-la-loi?", german=" Oh nein![K] Das sind Verbrecher?!?", italian=" Oh, no![K] Sono ricercati?!", spanish="¿De verdad?[K] ¿De verdad son\nbandidos?"})
  else
  SkySceneKit.say({english="Oh my gosh![K] They're wanted\nby the law?", french="Quoi?![K] Ce sont tous\ndes hors-la-loi?", german="Auweia![K] Das sind alles\ngesuchte Verbrecher?", italian="Cosa?![K] Sono ricercati dalla\nlegge?", spanish="¿De veras?[K] ¿De verdad, les\nbusca la ley?"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Correct.[K] So there are bounties\non their heads.", french="Exact.[K] Leur tête est mise\nà prix.", german="Sehr richtig.[K] Es sind Kopfgelder\nauf sie ausgesetzt.", italian="Proprio così.[K] C'è una taglia sulla\ntesta di ognuno di loro.", spanish="Así es.[K] Y se ofrece\nuna recompensa por su captura."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="In other words, there is a cash\nreward if you capture one.", french="Cela signifie qu'une récompense\nest offerte pour la capture de chacun d'eux.", german="Anders gesagt, wer einen fängt,\nbekommt zur Belohnung Geld.", italian="In altre parole, se ne catturate\nuno avete diritto a una ricompensa.", spanish="En otras palabras, si les\natrapáis, recibiréis dinero."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="There are so many aggressive\nPokémon around these days that everyone's\nfinding it hard to keep up with the problem.", french="Ces temps-ci, la situation\ndevient très difficile à gérer, tellement\nil y a de Pokémon méchants.", german="Heutzutage treiben sich so viele\nbösartige Pokémon herum, dass wir gar nicht\nmehr hinterherkommen.", italian="Oggigiorno ci sono così tanti\nPokémon aggressivi in giro che sta\ndiventando difficile tenerli a bada.", spanish="Hay tantos Pokémon agresivos\nhoy en día, que hace falta toda la ayuda\ndisponible para atajar el problema."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Wait a second! You expect us to\ncatch outlaws?", french="Hein? Tu es en train de nous\ndire qu'on doit capturer des hors-la-loi?", german="Moment mal! Du erwartest von\nuns, dass wir Ganoven fangen?", italian="Aspetta un attimo! Vuoi che\ncatturiamo dei veri criminali?", spanish="¡Un momento!\n¿Pretendes que persigamos maleantes?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wait! You're telling us to go\ncatch these outlaws?", french="Hein? Tu es en train de nous\ndire qu'on doit capturer des hors-la-loi?", german="Warte mal! Heißt das, wir\nsollen diese Ganoven fangen?", italian="Aspetta un attimo! Vuoi che\ncatturiamo dei veri criminali?", spanish="¡Un momento! ¿Y tenemos que\natraparlos nosotros?"})
  else
  SkySceneKit.say({english="And we're supposed to go catch\nthese outlaws?", french="Hein? Tu es en train de nous\ndire qu'on doit capturer des hors-la-loi?", german="Und wir sollen jetzt diese\nGanoven fangen?", italian="Aspetta un attimo! Vuoi che\ncatturiamo dei veri criminali?", spanish="¡¿Cómo?! ¿Nos estás diciendo\nque tenemos que perseguir forajidos?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" No way! That's not possible!", french="Tu plaisantes, pas vrai?\nCe n'est pas possible!", german=" Niemals! Das ist unmöglich!", italian=" No! Non ci credo!", spanish="¡Ni hablar! ¡Imposible!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You can't be serious!\nThat's not possible!", french="Tu plaisantes, pas vrai?\nCe n'est pas possible!", german="Das kann nicht dein Ernst sein!\nDas ist unmöglich!", italian="Non puoi dire sul serio! È\nimpossibile!", spanish="¡No lo dirás en serio!\n¡Eso es imposible!"})
  else
  SkySceneKit.say({english=" No way! That's not possible!", french="Tu plaisantes, pas vrai?\nCe n'est pas possible!", german=" Niemals! Das ist unmöglich!", italian="No, non stai dicendo sul serio,\nvero?", spanish="¿Qué dices?\n¡Eso sería imposible!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Hee-heeee! ♪[K] Just joking! ♪", french=" Hi hiii! ♪[K] C'est une blague! ♪", german="Hihihi! ♪[K] Ich mache nur\nSpaß! ♪", italian="Eeh-eeeeh! ♪[K] Non\npreoccupatevi! ♪", spanish="¡Ji, ji, ji! ♪[K]\n¡Solo bromeaba! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The bad Pokémon out there come\nin all shades of badness! ♪", french="On rencontre tous les degrés\nde méchanceté parmi ces Pokémon! ♪", german="Es gibt da draußen bösartige und\nweniger bösartige Pokémon! ♪", italian="Ci sono tanti tipi diversi di\nricercato! ♪", spanish="Hay muchos grados de maldad y\ntipos de Pokémon malvados, claro. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Some of those Pokémon are\ncompletely wicked, through and through...", french="Certains de ces Pokémon sont\ncomplètement malfaisants et corrompus\njusqu'à la moelle...", german="Einige dieser Pokémon sind von\nGrund auf durch und durch gemein.", italian="Alcuni di loro sono davvero\npericolosi, cattivi fino al midollo...", spanish="Algunos de estos Pokémon\nson realmente malignos..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But there are also bad Pokémon\nwho are merely petty thieves. So you've got\nevil to naughty...and everything in between! ♪", french="Mais d'autres ne sont que des\nvoleurs à la petite semaine. Cela peut donc\naller de la petite frappe au grand bandit! ♪", german="Aber es gibt auch bösartige\nPokémon, die nur harmlose Diebe sind.\nDazwischen gibt es noch viele Abstufungen! ♪", italian="... ma ce ne sono altri che sono\nsolamente ladruncoli da strapazzo.\nCe n'è per tutti i gusti! ♪", spanish="Pero otros son solo unos\nladronzuelos. Hay de todo: desde verdaderos\nmaleantes hasta Pokémon algo traviesos. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="So I'm sure we can avoid giving\nyou a job catching a superbad Pokémon...", french="Je suis sûr qu'on peut vous\ntrouver une mission pour laquelle vous n'aurez\npas à capturer un Pokémon super méchant...", german="Ihr werdet also keines der sehr\nbösartigen Pokémon fangen müssen...", italian="Quindi sono sicuro che\ntroveremo una missione che non richieda\nla cattura di un Pokémon pericolosissimo...", spanish="No tenéis que empezar por\nun malo malísimo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Hee-heeeee! ♪", french=" Hi hiiiii! ♪", german=" Hihihi! ♪", italian=" Eeh-eeeeeh! ♪", spanish=" ¡Ji, ji, ji! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="So look over these posters, then\npick a Pokémon that looks weak enough for you\nto bring to justice! ♪", french="Examinez les affiches et\nchoisissez un Pokémon qui vous semble assez\nfaible pour que vous puissiez le capturer! ♪", german="Seht euch die Bilder an und\nwählt ein Pokémon, das so schwach aussieht,\ndass ihr es zur Rechenschaft ziehen könnt! ♪", italian="Date un'occhiata a questi annunci,\npoi scegliete un Pokémon che vi sembra\nabbastanza innocuo! ♪", spanish="Mirad los carteles y escoged\nuno lo bastante debilucho como para traerlo\nante la justicia sin demasiados problemas. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Um...[K] You say some are weak...", french="Hum...[K] Tu dis que certains sont\nfaibles...", german="Äh...[K] Du sagst also, dass\nmanche schwächer sind.", italian="Ehm...[K] Dici che alcuni non sono\nmolto forti...", spanish="Hum...[K] Así que algunos son\ndébiles..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Um...[K] You say some are weak...", french="Hum...[K] Tu dis que certains sont\nfaibles...", german="Äh...[K] Du sagst also, dass\nmanche schwächer sind.", italian="Ehm...[K] Quindi alcuni non\nsono molto forti...", spanish="Hum...[K] Dices que algunos son\ndébiles..."})
  else
  SkySceneKit.say({english=" Um...[K] You say some are weak...", french="Hum...[K] Tu dis que certains sont\nfaibles...", german="Äh...[K] Du sagst also, dass\nmanche schwächer sind.", italian="Ehm...[K] Dici che alcuni sono\nabbastanza deboli...", spanish="Vaya...[K] ¿Así que algunos no son\nmuy fuertes?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But they're still bad Pokémon,\naren't they?", french="Mais ce sont quand même des\nPokémon méchants, c'est ça?", german="Aber es sind immer noch\nbösartige Pokémon, oder nicht?", italian="... però sono Pokémon di cui non\nci si può fidare, vero?", spanish="Pero siguen siendo malvados,\n¿no?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But they're still bad Pokémon,\naren't they?", french="Mais ce sont quand même des\nPokémon méchants, c'est ça?", german="Aber es sind immer noch\nbösartige Pokémon, oder nicht?", italian="... però sono dei fuorilegge,\nvero?", spanish="Aunque siguen siendo malvados,\n¿no?"})
  else
  SkySceneKit.say({english="They're still bad Pokémon,\naren't they?", french="Mais ce sont quand même des\nPokémon méchants, c'est ça?", german="Aber es sind immer noch\nbösartige Pokémon, oder nicht?", italian="... però sono comunque cattivi,\nvero?", spanish="Aunque siguen siendo malvados,\n¿no?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Characters like that weird\nme out!", french="Des Pokémon aussi dangereux,\nça me fait peur!", german="Solche Typen finde ich zum\nWeglaufen!", italian="Tipi del genere mi fanno venire\nla pelle d'oca!", spanish="¡Tratar con individuos así me\npone los pelos de punta!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm scared of dangerous\nPokémon!", french="Des Pokémon aussi dangereux,\nça me fait peur!", german="Ich habe Angst vor gefährlichen\nPokémon!", italian=" Tipi del genere mi fanno paura!", spanish="La verdad es que me asustan\nmucho los Pokémon peligrosos."})
  else
  SkySceneKit.say({english="I'm scared of dangerous\nPokémon!", french="Des Pokémon aussi dangereux,\nça me fait peur!", german="Ich habe Angst vor gefährlichen\nPokémon!", italian="Tipi del genere mi fanno venire\ni brividi!", spanish="¡Los Pokémon peligrosos me dan\nmucho miedo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It's all a part of your training.\nYou'll work through it, I'm sure! ♪", french="Cela fait partie de votre\nentraînement. Je suis certain que vous\nvous en tirerez très bien! ♪", german="Alles ist Teil eures Trainings.\nIhr beißt euch schon durch, ganz sicher! ♪", italian="Fa parte del vostro\naddestramento. Andrà tutto bene,\nne sono certo! ♪", spanish="Todo es parte de vuestro\nentrenamiento. ¡Estoy seguro de que\nos las arreglaréis muy bien! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But I suppose you do need to be\nprepared to confront a tough opponent...", french="Mais, avant d'affronter des\nadversaires trop coriaces, vous allez avoir\nbesoin qu'on vous entraîne correctement...", german="Aber ich nehme an, dass ihr auf\neinen schwierigen Gegner gefasst sein müsst.", italian="È necessario che abbiate\nl'equipaggiamento adatto per affrontare\nanche avversari tosti...", spanish="Pero supongo que tendréis que\nprepararos bien antes de enfrentaros a\nun contrincante difícil."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="So I'll have someone give you a\ntour of the facilities.", french="Quelqu'un va donc vous faire\nvisiter nos installations.", german="Also werde ich jemanden bitten,\neuch erst einmal herumzuführen.", italian="Dirò a qualcuno di mostrarvi\ni negozi in città.", spanish="Así que tendré que pedirle a\nalguien que os muestre las inmediaciones."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Hey! [CS:N]Bidoof[CR]![K] [CS:N]Bidoof[CR]?!", french=" Hé! [CS:N]Keunotor[CR]![K] [CS:N]Keunotor[CR]?!", german=" Hey! [CS:N]Bidiza[CR]![K] [CS:N]Bidiza[CR]?!?", italian=" Ehi! [CS:N]Bidoof[CR]![K] [CS:N]Bidoof[CR]?!", spanish=" ¡Eh! ¡[CS:N]Bidoof[CR]![K] ¡[CS:N]Bidoof[CR]!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 368, 184, Direction.Down, "NPC_BIPPA")
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end) -- message_SetActor(ACTOR_NPC_BIPPA)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Yup yup!", french=" Ouaip! Me v'là, pour sûr!", german=" Jawollja!", italian=" Già, già!", spanish=" ¡Sí, señor!"})
  -- message_Close
  -- supervision_Acting(4) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(npc_npc_bippa, 364, 212, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 384, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_bippa, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Huff-puff-huff...[K] You called?", french=" Pfiou...[K] Tu m'as appelé?", german="Schnauf-prust-schnauf...[K] Du hast\nmich gerufen?", italian="Puff-puff-puff...[K] Mi hai\nchiamato?", spanish=" Uf, uf...[K] ¿Me ha llamado alguien?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Ah, [CS:N]Bidoof[CR]! ♪", french=" Ah, [CS:N]Keunotor[CR]! ♪", german=" Ah, [CS:N]Bidiza[CR]! ♪", italian=" Ah, [CS:N]Bidoof[CR]! ♪", spanish=" ¡Ah, [CS:N]Bidoof[CR]! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="These are the new recruits that\njust joined us.", french="Voici les deux nouvelles recrues\nqui viennent de nous rejoindre.", german="Hier sind die neuen Rekruten, die\nuns beigetreten sind.", italian="Queste sono due reclute che si\nsono appena unite alla Gilda.", spanish="Estos Pokémon se acaban de unir\na nosotros."})
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, partner, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Take them and show them around\nthe town. ♪", french=" Fais leur visiter le bourg. ♪", german="Nimm sie mit und führe sie\ndurch die Stadt. ♪", italian="Portale a fare un giro in\ncittà. ♪", spanish="Enséñales los alrededores y\nla aldea. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Yes sirree! By golly, I'll do just\nthat! Yup yup!", french="Ouaip! Pas d'problème, pour\nsûr! Sapristi, c'est parti!", german="Donnerwetter! Menschenskind,\ndas werde ich! Jawollja!", italian="Sissignore! Ohibò, lo farò!\nGià, già!", spanish=" ¡Sí, señor! ¡Eso haré!"})
  -- message_Close
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="This is [CS:N]Bidoof[CR]. He's one of your\nfellow apprentices.", french="C'est [CS:N]Keunotor[CR]. C'est\nun apprenti ici, tout comme vous.", german="Das ist [CS:N]Bidiza[CR]. Er ist auch ein\nGildenlehrling.", italian="Questo è [CS:N]Bidoof[CR]. È uno degli\naltri apprendisti.", spanish=" Este es [CS:N]Bidoof[CR]. Es otro aprendiz."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I want you to pay attention to\nwhat [CS:N]Bidoof[CR] has to say and follow his orders.", french="Ecoutez bien tout ce que vous dit\n[CS:N]Keunotor[CR] et suivez ses instructions.", german="Ich möchte, dass ihr [CS:N]Bidiza[CR]\nzuhört und seinen Anweisungen folgt.", italian="Voglio che facciate attenzione a\nquanto vi dice [CS:N]Bidoof[CR] e che seguiate i suoi\nordini.", spanish="Quiero que prestéis atención a lo\nque os diga [CS:N]Bidoof[CR], ¡y que sigáis sus órdenes!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Off you go! ♪", french=" Allez-y! ♪", german=" Und nun, geht! ♪", italian=" Potete andare! ♪", spanish=" Hala, ¡andando! ♪"})
  -- message_Close
  GROUND:EntTurn(npc_npc_bippa, Direction.UpLeft)
  GROUND:MoveToPosition(npc_npc_perappu, 392, 228, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_perappu, 364, 228, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_perappu, 364, 180, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Aw, shucks, I'm overjoyed!", french="Ouah, sapristi, j'suis hyper\ncontent! J'me roule par terre!", german=" Mannomann, bin ich glücklich!", italian=" Ohibò, sono stracontento!", spanish=" Oh, vaya, ¡qué alegría!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Why's that?", french=" Pourquoi?", german=" Warum denn?", italian=" Come mai?", spanish=" ¿Y eso?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Why's that?", french=" Pourquoi?", german=" Warum denn?", italian=" Come mai?", spanish=" ¿Y eso por qué?"})
  else
  SkySceneKit.say({english=" Why's that?", french=" Pourquoi?", german=" Warum denn?", italian=" Come mai?", spanish=" ¿Y eso por qué?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I'm glad to have members junior\nto me! I'm almost overcome right now...[K]\nI might just blubber with happiness!", french="Ça m'fait plaisir d'plus être\nl'bleu! J'suis vraiment hyper content...[K]\nJ'crois que j'vais chialer d'bonheur!", german="Ich bin so froh, dass ich jetzt\nnicht mehr der Neuling bin![K]\nIch könnte vor Freude platzen!", italian="Sono felice che ci siano dei\nprincipianti... più principianti di me! Sono così\nemozionato...[K] Sto per piangere dalla gioia!", spanish="¡Ya no soy el último aprendiz!\n¡Qué feliz que me siento![K] ¡Hacía tiempo\nque no estaba así de contento!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Before you all signed on, I was\nthe most recent rookie...", french="Avant qu'vous arriviez, c'était\nmoi l'dernier arrivé parmi les recrues...", german="Bevor ihr euch eingeschrieben\nhabt, war ich der neueste Lehrling.", italian="Prima che voi entraste nella\nGilda, io ero l'ultimo arrivato...", spanish="Antes de que llegaseis,\nyo era el novato del [CS:N]Pokégremio[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Sniffle...", french=" Snif...", german=" Schnief...", italian=" Sniff...", spanish=" Snif..."})
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Well, I'd best show you around.\nCome with me, please.", french="Ben j'vais vous faire visiter\nalors. Vous me suivez?", german="Na ja, ich führe euch am besten\nherum. Kommt bitte mit mir.", italian="Beh, sarà meglio che vi mostri\nun po' in giro. Venite con me.", spanish="Bueno, os voy a enseñar\ntodo esto. Acompañadme, por favor."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_bippa, 364, 212, false, 2)
  GAME:WaitFrames(10)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-32), p.Y+(0), false, 2) end -- Move2PositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-64), p.Y+(0), false, 2) end -- Move2PositionOffset
  GROUND:MoveToPosition(npc_npc_bippa, 364, 180, false, 2)
  GROUND:MoveToPosition(partner, 364, 212, false, 2)
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(hero, 364, 212, false, 2)
  GROUND:MoveToPosition(partner, 364, 180, false, 2)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
