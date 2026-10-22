-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m07a0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 344, 232, Direction.Down, "NPC_PERAPPU")
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Whaaaat? You failed?!", french=" Quoi? Vous avez échoué?!", german=" Waaaas? Ihr habt versagt?!?", italian=" Coooosa? Non ce l'avete fatta?!", spanish="¿Quéee? ¡¿Habéis fracasado\nen la misión?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Are you serious?[K] Oh no! What\nam I going to do?!", french="Sérieusement?[K] Oh non! Que\nvais-je faire?!", german="Ist das euer Ernst?[K] Oh nein!\nWas soll ich nur tun?!?", italian="Dite sul serio?[K] Oh, no! Cosa\nfaccio adesso?!", spanish="¿En serio?[K] ¡Oh, no!\n¡¿Qué voy a hacer ahora?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(20) [anim idle native]
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(32), p.Y+(0), false, 2) end
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(-64), p.Y+(0), false, 2) end
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(32), p.Y+(0), false, 2) end
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(-16), false, 2) end
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Seriously! What am I to do?!", french="Oh, mes aïeux! Que vais-je\nbien pouvoir faire?!", german=" Im Ernst! Was soll ich tun?!?", italian=" Seriamente! Cosa faccio?!", spanish=" ¡En serio! ¡¿Qué hago yo ahora?!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We couldn't help it. I mean,\n[CS:N]Skuntank[CR] and his...", french="On n'y peut rien. En fait, c'est\nà cause de [CS:N]Moufflair[CR] et de ses...", german="Wir konnten nichts machen. Ich\nmeine, [CS:N]Skuntank[CR] und seine...", italian="Non è colpa nostra. Voglio dire,\n[CS:N]Skuntank[CR] e la sua...", spanish="No pudimos hacer nada.\n[CS:N]Skuntank[CR] y su..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There was nothing we could do.\nYou see, [CS:N]Skuntank[CR] and his...", french="On n'y peut rien. En fait, c'est\nà cause de [CS:N]Moufflair[CR] et de ses...", german="Es gab nichts, was wir tun\nkonnten. Weißt du, [CS:N]Skuntank[CR] und seine...", italian="Non è colpa nostra. Voglio dire,\n[CS:N]Skuntank[CR] e la sua...", spanish="No pudimos hacer nada.\nEl caso es que [CS:N]Skuntank[CR] y su..."})
  else
  SkySceneKit.say({english="It's not our fault. It's because\n[CS:N]Skuntank[CR] and his...", french="On n'y peut rien. En fait, c'est\nà cause de [CS:N]Moufflair[CR] et de ses...", german="Es ist nicht unsere Schuld. Es ist\nso, [CS:N]Skuntank[CR] und seine...", italian="Non è colpa nostra. Voglio dire,\n[CS:N]Skuntank[CR] e la sua...", spanish="No pudimos hacer nada.\n[CS:N]Skuntank[CR] y su..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "angry", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Quiet![K] I don't want to hear\nany excuses!", french="Silence![K] Je ne veux entendre\naucune excuse!", german="Ruhe![K] Ich will keine Ausreden\nhören!", italian="Silenzio![K] Non voglio sentire\nscuse!", spanish="¡Silencio![K] ¡No quiero oír\nninguna excusa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk...", french=" Argh...", german=" Urks...", italian=" Urk...", spanish=" Ay..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk...", french=" Argh...", german=" Urks...", italian=" Urk...", spanish=" Ay..."})
  else
  SkySceneKit.say({english=" Urk...", french=" Argh...", german=" Urks...", italian=" Urk...", spanish=" Ay..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" You leave me no choice.", french=" Vous ne me laissez pas le choix.", german=" Ihr lasst mir keine Wahl.", italian=" Non mi lasciate altra scelta.", spanish=" No me dejáis elección."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="For the time being, you'll go\nwithout dinner tonight!", french="Vous irez vous coucher sans\nmanger jusqu'à nouvel ordre!", german="Für euch gibt es heute kein\nAbendessen! Fürs Erste!", italian="Dovrò mandarvi a letto senza\ncena!", spanish="¡Me temo que esta noche os\nvais a quedar sin cenar!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?! B-but...", french=" Quoi?! Mais...", german=" Was?!? A-aber...", italian=" C-Cosa?! M-Ma...", spanish=" ¡¿Qué?! Pero si..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?! B-but...", french=" Quoi?! Mais...", german=" Was?!? A-aber...", italian=" C-Cosa?! M-Ma...", spanish=" ¡¿Qué?! Pero si..."})
  else
  SkySceneKit.say({english=" What?! B-but...", french=" Quoi?! Mais...", german=" Was?!? A-aber...", italian=" C-Cosa?! M-Ma...", spanish=" ¡¿Qué?! Pero si..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You failed to complete an\nimportant job.", french="Vous avez échoué lors d'une\nmission importante.", german="Ihr habt bei einem wichtigen\nJob versagt.", italian="Non avete portato a termine una\nmissione importante.", spanish="Habéis fracasado en una misión\nimportantísima."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Your punishment could be much\nmore severe!", french="Ne vous plaignez pas, votre\npunition pourrait être encore plus sévère!", german="Eure Strafe könnte noch viel\nhärter ausfallen!", italian="La punizione avrebbe potuto\nessere molto più severa!", spanish="¡Vuestro castigo podría ser\nmuchísimo más severo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...", french=" Argh...", german=" Umpf...", italian=" Ugh...", spanish=" Ay..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh...", french=" Argh...", german=" Umpf...", italian=" Ugh...", spanish=" Ay..."})
  else
  SkySceneKit.say({english=" Ugh...", french=" Argh...", german=" Umpf...", italian=" Ugh...", spanish=" Ay..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I don't want to hear anything\nfrom you!", french=" Je ne veux plus vous entendre!", german="Ich will nichts mehr von euch\nhören!", italian=" Non voglio sentire altro!", spanish=" ¡No quiero oír ni una palabra más!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You've saddled me with this\nterrible task!", french="Vous me mettez dans une\nposition fort délicate, vous savez!", german="Euretwegen wird mir jetzt diese\nentsetzliche Aufgabe zuteil!", italian="Per causa vostra ora devo fare\nuna cosa... tremenda!", spanish="¡Ahora voy a tener que pasar\nun mal trago por vuestra culpa!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I've got to report this to the\nGuildmaster now!", french="Je dois faire mon rapport au\nMaître de la Guilde!", german="Ich muss dem Gildenmeister\ndavon berichten!", italian="Devo andare a fare rapporto al\nCapitano!", spanish="¡Tengo que dar parte al Gran\nBluff inmediatamente!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Upon hearing my report, the\nGuildmaster is sure to...", french="En l'entendant, le Maître va\nsûrement...", german="Wenn ich ihm das berichte, wird\nder Gildenmeister mit Sicherheit...", italian="Quando lo saprà, sicuramente\nil Capitano...", spanish="Al oír mi informe, el Gran Bluff\nsin duda se va a..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(20) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Waaaaaaah!", french=" Couaaac!", german=" Waaaaaaah!", italian=" Waaaaaaah!", spanish=" ¡Aaaaah!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(32), p.Y+(0), false, 2) end
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(-64), p.Y+(0), false, 2) end
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(32), p.Y+(0), false, 2) end
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(-32), false, 2) end
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(32), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I will report this to the\nGuildmaster after dinner.", french="Tout bien réfléchi, je ferai mon\nrapport après le dîner.", german="Ich werde dem Gildenmeister\nnach dem Abendessen davon berichten.", italian=" Informerò il Capitano dopo cena.", spanish="Mejor se lo cuento después\nde cenar."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You two will come with me when\nI do so.", french="Et vous deux, vous\nm'accompagnerez.", german="Ihr zwei werdet mich\nbegleiten, wenn es so weit ist.", italian=" E voi due verrete con me.", spanish="Tendréis que estar presentes.\nFaltaría más."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="If I had to face the\nGuildmaster's wrath all by myself, well, that\nwould hardly be fair.", french="Il serait injuste que j'affronte\nseul le courroux du Maître.", german="Wenn ich den Zorn des\nGildenmeisters alleine über mich ergehen\nlassen müsste, wäre das wohl kaum fair.", italian="Non è giusto che io debba\naffrontare le sue ire da solo.", spanish="Sería injusto que solo yo tuviera\nque enfrentarme a la ira del Gran Bluff."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Therefore, you two will come\nwith me!", french="C'est pourquoi vous viendrez\navec moi.", german="Deshalb werdet ihr beide\nmitkommen!", italian="Quindi, voi due mi\naccompagnerete.", spanish=" Por tanto, ¡vais a venir conmigo!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" That's an order!", french=" C'est un ordre!", german=" Das ist ein Befehl!", italian=" È un ordine!", spanish=" ¡Es una orden!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
