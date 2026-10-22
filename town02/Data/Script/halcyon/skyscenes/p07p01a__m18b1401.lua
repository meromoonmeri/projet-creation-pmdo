-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P07P01A/m18b1401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetBanner2(LEVEL_V17P03A, 0, 256, 152, 15) [bannière 2e écran NDS: information dupliquée du menu, hors canvas unique - documenté]
  GAME:FadeIn(45)
  GAME:WaitFrames(160)
  GAME:FadeOut(false, 45)
  GAME:WaitFrames(15)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V17P01A) [décor sub chargé: Sub_v17p01a]
  -- back_SetGround(LEVEL_P07P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 21, 21.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  SkySubScreen.Show("v17p01a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_FUTURE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(80)
  pcall(function() GAME:MoveCamera(180, 316, 60, false) end) -- performer/caméra
  pcall(function() GAME:MoveCamera(180, 380, 60, false) end) -- performer/caméra
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 120, 376, Direction.Left, "NPC_JUPUTORU")
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownLeft)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Left)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownLeft)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(24), p.Y+(-8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Good.[K] This will do.", french=" C'est bon.[K] Ici, ça ira.", german=" Gut.[K] Das wird reichen.", italian=" Ok.[K] Qui va bene.", spanish=" Muy bien.[K] Aquí mismo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Those [CS:N]Sableye[CR] won't be able to\nspot us easily here.", french="Les [CS:N]Ténéfix[CR] ne nous repéreront\npas facilement ici.", german="Die [CS:N]Zobiris[CR] werden uns hier\nnicht so leicht finden.", italian="Quei [CS:N]Sableye[CR] non ci troveranno\nfacilmente.", spanish="Esos [CS:N]Sableye[CR] no nos verán\nfácilmente en este sitio."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Tell us, [CS:N]Grovyle[CR].", french=" Raconte-nous, [CS:N]Massko[CR].", german=" Erzähle uns alles, [CS:N]Reptain[CR].", italian=" Dicci, [CS:N]Grovyle[CR].", spanish=" Cuéntanos, [CS:N]Grovyle[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Tell us, [CS:N]Grovyle[CR].", french=" Raconte-nous, [CS:N]Massko[CR].", german=" Erzähle uns alles, [CS:N]Reptain[CR].", italian=" Dicci, [CS:N]Grovyle[CR].", spanish=" Cuéntanos, [CS:N]Grovyle[CR]."})
  else
  SkySceneKit.say({english=" Please tell us, [CS:N]Grovyle[CR].", french=" Raconte-nous, [CS:N]Massko[CR].", german=" Bitte erzähle uns alles, [CS:N]Reptain[CR].", italian=" Raccontaci per favore, [CS:N]Grovyle[CR].", spanish=" Cuéntanos, [CS:N]Grovyle[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="In the future...[K] Why did the\nplanet become paralyzed?", french="Dans le futur...[K] pourquoi\nla planète s'est-elle paralysée?", german="In der Zukunft...[K]\nWieso ist der Planet gelähmt?", italian="Nel futuro...[K] Perché il pianeta\nè paralizzato?", spanish="En el futuro...[K]\n¿por qué se ha paralizado el planeta?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="In the future...[K] Why did the\nplanet's paralysis take place?", french="Dans le futur...[K] pourquoi\nla planète s'est-elle paralysée?", german="In der Zukunft...[K]\nWie kam es zur Lähmung des Planeten?", italian="Nel futuro...[K] Perché ha avuto\nluogo la paralisi del pianeta?", spanish="En el futuro...[K]\n¿por qué se ha paralizado el planeta?"})
  else
  SkySceneKit.say({english="In the future...[K] Why did the\nplanet become paralyzed?", french="Dans le futur...[K] pourquoi\nla planète s'est-elle paralysée?", german="In der Zukunft...[K]\nWie kam es zur Lähmung des Planeten?", italian="Nel futuro...[K] Perché il pianeta\nè paralizzato?", spanish="En el futuro...[K]\n¿por qué se ha paralizado el planeta?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="The cause of the planet's\nparalysis...", french="La cause de la Paralysie\nde la Planète...", german="Der Grund für die Lähmung\ndes Planeten...", italian="La causa della paralisi del\npianeta...", spanish="La causa de la parálisis del\nplaneta..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That dates back to your time.\nIn the world of the past.", french="Ça remonte à votre temps.\nDans le monde du passé.", german="Der Grund liegt noch in eurer\nZeit. In der Welt der Vergangenheit.", italian="... è da ricercare nel vostro\ntempo. Nel mondo del passato.", spanish="Se remonta a vuestra época.\nTodo sucedió en el mundo del pasado."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="The planet's paralysis started\nwith the collapse of [CS:P]Temporal Tower[CR], which\nwas governed by [CS:N]Dialga[CR].", french="C'est l'effondrement de la [CS:P]Tour\ndu Temps[CR], gouvernée par [CS:N]Dialga[CR], qui a entraîné\nle début de la Paralysie de la Planète.", german="Die Lähmung des Planeten begann\nmit dem Einsturz des [CS:P]Zeitturms[CR], auf dem\n[CS:N]Dialga[CR] regierte.", italian="La paralisi del pianeta ha avuto\ninizio con il crollo della [CS:P]Torre del Tempo[CR],\nche era governata da [CS:N]Dialga[CR].", spanish="La parálisis del planeta comenzó\ncon el derrumbamiento de la [CS:P]Torre del Tiempo[CR],\nque estaba gobernada por [CS:N]Dialga[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]D-Dialga[CR]?[K] Who is that?", french=" [CS:N]D-Dialga[CR]?[K] Qui est-ce?", german=" [CS:N]Dialga[CR]?[K] Wer ist das?", italian=" [CS:N]D-Dialga[CR]?[K] Chi è?", spanish=" ¿[CS:N]Dialga[CR]?[K] ¿Quién es?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]D-Dialga[CR]?[K] Who is that?", french=" [CS:N]D-Dialga[CR]?[K] Qui est-ce?", german=" [CS:N]Dialga[CR]?[K] Wer ist das?", italian=" [CS:N]D-Dialga[CR]?[K] Chi è?", spanish=" ¿[CS:N]Dialga[CR]?[K] ¿Quién es?"})
  else
  SkySceneKit.say({english=" [CS:N]D-Dialga[CR]?[K] Who is that?", french=" [CS:N]D-Dialga[CR]?[K] Qui est-ce?", german=" [CS:N]Dialga[CR]?[K] Wer ist das?", italian=" [CS:N]D-Dialga[CR]?[K] Chi è?", spanish=" ¿[CS:N]Dialga[CR]?[K] ¿Quién es?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="He is the legendary Pokémon\nthat controls time.", french="C'est le Pokémon légendaire\nqui contrôle le temps.", german="Das legendäre Pokémon, das die\nZeit beherrscht.", italian="È il Pokémon leggendario che\ncontrolla il tempo.", spanish="Es el Pokémon legendario que\ncontrola el tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="[CS:N]Dialga[CR] ensured the proper flow\nof time from [CS:P]Temporal Tower[CR].", french="[CS:N]Dialga[CR] s'assurait que le temps\ns'écoulait normalement depuis la [CS:P]Tour\ndu Temps[CR].", german="Vom [CS:P]Zeitturm[CR] aus stellte [CS:N]Dialga[CR]\nsicher, dass die Zeit richtig floss.", italian="[CS:N]Dialga[CR] controllava il flusso\ntemporale dalla [CS:P]Torre del Tempo[CR].", spanish="[CS:N]Dialga[CR] se ocupaba de que el\ntiempo fluyera como corresponde desde\nla [CS:P]Torre del Tiempo[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="But when [CS:P]Temporal Tower[CR]\ncollapsed...", french="Mais après l'effondrement de\nla [CS:P]Tour du Temps[CR]...", german="Doch als der [CS:P]Zeitturm[CR]\neinstürzte...", italian="Ma la [CS:P]Torre del Tempo[CR] è\ncrollata.", spanish="Pero cuando la [CS:P]Torre del Tiempo[CR]\nse derrumbó..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Time gradually got out of\ncontrol...", french="... le temps s'est mis à\nse détraquer progressivement...", german="Damals geriet die Zeit allmählich\naußer Kontrolle.", italian="E così il tempo è sfuggito al\ncontrollo...", spanish="El tiempo se fue descontrolando\npoco a poco..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="And eventually, the planet fell\ninto paralysis.", french="... jusqu'à ce que la planète\nfinisse par être complètement paralysée.", german="Und letzten Endes trat die\nLähmung des Planeten ein.", italian="E alla fine il pianeta è rimasto\nparalizzato.", spanish="Y, al final, el planeta quedó\nparalizado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What...[K]what happened to [CS:N]Dialga[CR]?", french=" Que...[K] qu'est-il arrivé à [CS:N]Dialga[CR]?", german=" Was...[K] wurde aus [CS:N]Dialga[CR]?", italian="Cosa...[K] Cosa è successo a\n[CS:N]Dialga[CR]?", spanish=" ¿Qué...?[K] ¿Qué le pasó a [CS:N]Dialga[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What...[K]what happened to [CS:N]Dialga[CR]?", french=" Que...[K] qu'est-il arrivé à [CS:N]Dialga[CR]?", german=" Was...[K] wurde aus [CS:N]Dialga[CR]?", italian="Cosa...[K] Cosa è successo a\n[CS:N]Dialga[CR]?", spanish=" ¿Qué...?[K] ¿Qué le pasó a [CS:N]Dialga[CR]?"})
  else
  SkySceneKit.say({english=" What...[K]what happened to [CS:N]Dialga[CR]?", french=" Que...[K] qu'est-il arrivé à [CS:N]Dialga[CR]?", german=" Was...[K] wurde aus [CS:N]Dialga[CR]?", italian="Cosa...[K] Cosa è successo a\n[CS:N]Dialga[CR]?", spanish=" ¿Qué...?[K] ¿Qué le pasó a [CS:N]Dialga[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="When time went out of whack,\n[CS:N]Dialga[CR] also lost control.", french="Quand le temps a été chamboulé,\n[CS:N]Dialga[CR] a perdu le contrôle.", german="Als die Zeit durcheinanderkam,\ngeriet auch [CS:N]Dialga[CR] außer Kontrolle.", italian="Quando il tempo ha perso il\nsuo equilibrio, anche [CS:N]Dialga[CR] ha perso il\ncontrollo.", spanish="Con el tiempo completamente\nenloquecido, [CS:N]Dialga[CR] también perdió el control."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Now, here in your future, the\nplanet has become fully paralyzed.", french="A présent, ici dans le futur,\nla planète est complètement paralysée.", german="Hier, in eurer Zukunft, ist der\nPlanet nun vollständig gelähmt.", italian="Ora, qui nel vostro futuro, il\npianeta è completamente paralizzato.", spanish="Como veis, aquí en el futuro,\nel planeta está completamente paralizado."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="And thus [CS:N]Dialga[CR] has lost almost\nall his reason...[K]and is governed by darkness.", french="Par conséquent, [CS:N]Dialga[CR] a presque\ntotalement perdu la raison...[K] et l'ombre s'est\nemparée de lui.", german="Deshalb hat [CS:N]Dialga[CR] fast komplett\nden Verstand verloren...[K] und ist der Dunkelheit\nverfallen.", italian="E di conseguenza [CS:N]Dialga[CR] ha quasi\ncompletamente perso la ragione...[K] ed è in\nbalia dell'oscurità.", spanish="[CS:N]Dialga[CR] ha perdido la razón...[K]\ny la oscuridad se ha apoderado de él."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" [CS:N]Dialga[CR] is now beyond recognition.", french="[CS:N]Dialga[CR] est désormais\nméconnaissable.", german="[CS:N]Dialga[CR] ist jetzt nicht mehr\nwiederzuerkennen.", italian=" [CS:N]Dialga[CR] ora è irriconoscibile.", spanish=" [CS:N]Dialga[CR] está irreconocible."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="He has become an entirely\ndifferent entity...[K] Yes...", french="Il a changé du tout au tout...[K]\nOui...", german="Es ist zu einem völlig anderen\nWesen geworden...[K] Ja...", italian="È diventato un'entità\ncompletamente diversa...[K] Sì...", spanish="Se ha convertido en un ser\ntotalmente distinto...[K] Sí..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="He has been transformed into\nPrimal [CS:N]Dialga[CR], a primordial presence.", french="... il s'est transformé en [CS:N]Dialga[CR]\nPrimal, une entité issue du fond des âges.", german="Es hat sich in die urzeitliche\nKreatur [CS:N]Schatten-Dialga[CR] verwandelt.", italian="Si è trasformato in [CS:N]Dialga[CR]\nOscuro, una presenza primordiale.", spanish="Se ha transformado en un ser\nprimitivo, en el [CS:N]Dialga Primario[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" OK... Urf...", french=" D'accord... ouah...", german=" Okay... Urf...", italian=" Ok... Uh...", spanish=" Ah... Vaya..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK... Urf...", french=" D'accord... ouah...", german=" Okay... Urf...", italian=" Ok... Uh...", spanish=" Ah... Vaya..."})
  else
  SkySceneKit.say({english=" OK... Urf...", french=" D'accord... ouah...", german=" Okay... Urf...", italian=" Ok... Uh...", spanish=" Ah... Vaya..."})
  end
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Primal [CS:N]Dialga[CR] feels no emotion.", french="[CS:N]Dialga[CR] Primal ne ressent aucune\némotion.", german="[CS:N]Schatten-Dialga[CR] empfindet\nkeinerlei Emotionen.", italian="[CS:N]Dialga[CR] Oscuro non prova\nalcuna emozione.", spanish="El [CS:N]Dialga Primario[CR] no tiene\nemociones."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="He seeks only self-preservation,\nso he prevents history from changing.", french="Il est gouverné par son instinct\nde conservation, et c'est pour ça qu'il refuse\nque l'histoire change.", german="Sein einziges Ziel ist die\nSelbsterhaltung. Darum will es verhindern,\ndass die Geschichte geändert wird.", italian="Cerca solo di preservare se\nstesso, quindi di impedire che la storia\ncambi.", spanish="Solo busca perpetuar su forma\nactual, así que intenta evitar que cambie\nla historia."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That's why [CS:N]Dialga[CR] wants\nme gone.", french="C'est aussi pour cette raison\nqu'il veut me voir disparaître.", german="Deshalb will [CS:N]Dialga[CR] mich\nloswerden.", italian="È per questo che [CS:N]Dialga[CR] mi dà\nla caccia.", spanish="Por eso, [CS:N]Dialga[CR] quiere acabar\nconmigo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Because I tried to change\nhistory.", french="Parce que j'ai tenté de modifier\nle cours de l'histoire.", german="Weil ich versucht habe, den\nLauf der Geschichte zu verändern.", italian="Perché sto cercando di cambiare\nla storia.", spanish=" Por querer cambiar la historia."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Because I tried to stop the\nplanet's paralysis.", french="Parce que j'ai essayé d'entraver\nla Paralysie de la Planète.", german="Weil ich versucht habe, die\nLähmung des Planeten zu verhindern.", italian="Perché ho cercato di fermare la\nparalisi del pianeta.", spanish="Por haber intentado evitar\nla parálisis del planeta."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Because I traveled back in time\nto your world from this place...your future.", french="Parce que j'ai voyagé dans\nle temps jusqu'à votre monde dans l'espoir\nde vous éviter un tel futur.", german="Weil ich aus dieser Welt,\naus eurer Zukunft, in die Vergangenheit, in\neure Welt gereist bin.", italian="Perché sono tornato indietro nel\ntempo, nel vostro mondo, da qui... dal vostro\nfuturo.", spanish="Por haber viajado a vuestro\nmundo desde aquí... vuestro futuro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  else
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Grovyle[CR], you're saying that you\ncame back to our world...", french="[CS:N]Massko[CR], tu affirmes être venu\ndans notre monde...", german=" [CS:N]Reptain[CR], du sagst also...", italian="[CS:N]Grovyle[CR], stai dicendo che sei\nvenuto nel nostro mondo...", spanish="[CS:N]Grovyle[CR], dices que fuiste a\nnuestro mundo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Grovyle[CR], you're saying that you\ncame back to our world...", french="[CS:N]Massko[CR], tu affirmes être venu\ndans notre monde...", german=" [CS:N]Reptain[CR], du sagst also...", italian="[CS:N]Grovyle[CR], stai dicendo che sei\nvenuto nel nostro mondo...", spanish="[CS:N]Grovyle[CR], dices que fuiste a\nnuestro mundo..."})
  else
  SkySceneKit.say({english="[CS:N]Grovyle[CR], you're saying that you\ncame back to our world...", french="[CS:N]Massko[CR], tu affirmes être venu\ndans notre monde...", german=" [CS:N]Reptain[CR], du sagst also...", italian="[CS:N]Grovyle[CR], stai dicendo che sei\nvenuto nel nostro mondo...", spanish="[CS:N]Grovyle[CR], dices que fuiste a\nnuestro mundo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So you could prevent the planet's\nparalysis?!", french="... dans le but d'empêcher\nla Paralysie de la Planète?!", german="Du bist in unsere Welt\ngekommen, um die Lähmung des Planeten zu\nverhindern?!?", italian="... per prevenire la paralisi del\npianeta?!", spanish="¡¿Para evitar la parálisis del\nplaneta?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So you could prevent the planet's\nparalysis?!", french="... dans le but d'empêcher\nla Paralysie de la Planète?!", german="Du bist in unsere Welt\ngekommen, um die Lähmung des Planeten zu\nverhindern?!?", italian="... per prevenire la paralisi del\npianeta?!", spanish="¡¿Para evitar la parálisis del\nplaneta?!"})
  else
  SkySceneKit.say({english="So you could prevent the planet's\nparalysis?!", french="... dans le but d'empêcher\nla Paralysie de la Planète?!", german="Du bist in unsere Welt\ngekommen, um die Lähmung des Planeten zu\nverhindern?!?", italian="... per prevenire la paralisi del\npianeta?!", spanish="¡¿Para evitar la parálisis del\nplaneta?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But that's...[K]completely the\nopposite of what we were told!", french="Mais c'est...[K] tout le contraire\nde ce qu'on nous avait dit!", german="Aber das ist...[K] Das ist das\ngenaue Gegenteil von dem, was man uns gesagt\nhat!", italian="Ma è...[K] esattamente l'opposto\ndi quello che ci avevano detto!", spanish="Pero eso es...[K] ¡exactamente lo\ncontrario de lo que nos dijeron!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But that's...[K]completely the\nopposite of what we were told!", french="Mais c'est...[K] tout le contraire\nde ce qu'on nous avait dit!", german="Aber das ist...[K] Das ist das\ngenaue Gegenteil von dem, was man uns gesagt\nhat!", italian="Ma è...[K] esattamente l'opposto\ndi quello che ci avevano detto!", spanish="Pero eso es...[K] ¡exactamente lo\ncontrario de lo que nos dijeron!"})
  else
  SkySceneKit.say({english="But that's...[K]completely the\nopposite of what we were told!", french="Mais c'est...[K] tout le contraire\nde ce qu'on nous avait dit!", german="Aber das ist...[K] Das ist das\ngenaue Gegenteil von dem, was man uns gesagt\nhat!", italian="Ma è...[K] esattamente l'opposto\ndi quello che ci avevano detto!", spanish="Pero eso es...[K] ¡exactamente lo\ncontrario de lo que nos dijeron!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Grovyle[CR], you came back to our\nworld to paralyze the planet...didn't you?!", french="[CS:N]Massko[CR], si tu es venu dans\nnotre monde... c'est justement pour paralyser\nla planète, pas vrai?!", german="[CS:N]Reptain[CR], du bist in unsere Welt\ngekommen, um den Planeten zu lähmen, oder?!?", italian="[CS:N]Grovyle[CR], sei venuto nel nostro\nmondo per paralizzare il pianeta... vero?!", spanish="[CS:N]Grovyle[CR], tú habías venido\na nuestro mundo a paralizar el planeta, ¿no?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Grovyle[CR], you came back to our\nworld to paralyze the planet...didn't you?!", french="[CS:N]Massko[CR], si tu es venu dans\nnotre monde... c'est justement pour paralyser\nla planète, pas vrai?!", german="[CS:N]Reptain[CR], du bist in unsere Welt\ngekommen, um den Planeten zu lähmen, oder?!?", italian="[CS:N]Grovyle[CR], sei venuto nel nostro\nmondo per paralizzare il pianeta... vero?!", spanish="[CS:N]Grovyle[CR], tú habías venido\na nuestro mundo a paralizar el planeta, ¿no?"})
  else
  SkySceneKit.say({english="[CS:N]Grovyle[CR], you came back to our\nworld to paralyze the planet...didn't you?!", french="[CS:N]Massko[CR], si tu es venu dans\nnotre monde... c'est justement pour paralyser\nla planète, pas vrai?!", german="[CS:N]Reptain[CR], du bist in unsere Welt\ngekommen, um den Planeten zu lähmen, oder?!?", italian="[CS:N]Grovyle[CR], sei venuto nel nostro\nmondo per paralizzare il pianeta... vero?!", spanish="[CS:N]Grovyle[CR], tú habías venido\na nuestro mundo a paralizar el planeta, ¿no?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And, [CS:N]Grovyle[CR]...[K]weren't you the\none stealing the Time Gears?!", french="D'ailleurs, [CS:N]Massko[CR]...[K] c'était\npourtant bien toi qui volais les Rouages\ndu Temps, pas vrai?!", german="Und [CS:N]Reptain[CR]...[K] Hast du nicht\ndie Zahnräder der Zeit gestohlen?!?", italian="E, [CS:N]Grovyle[CR]...[K] non stavi rubando\ngli Ingranaggi del Tempo?!", spanish="Vamos a ver, [CS:N]Grovyle[CR]...[K]\n¿Estabas o no estabas robando los Engranajes\ndel Tiempo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And, [CS:N]Grovyle[CR]...[K]weren't you the\none stealing the Time Gears?!", french="D'ailleurs, [CS:N]Massko[CR]...[K] c'était\npourtant bien toi qui volais les Rouages\ndu Temps, pas vrai?!", german="Und [CS:N]Reptain[CR]...[K] Hast du nicht\ndie Zahnräder der Zeit gestohlen?!?", italian="E, [CS:N]Grovyle[CR]...[K] non stavi rubando\ngli Ingranaggi del Tempo?!", spanish="Vamos a ver, [CS:N]Grovyle[CR]...[K]\n¿Estabas o no estabas robando los Engranajes\ndel Tiempo?"})
  else
  SkySceneKit.say({english="And, [CS:N]Grovyle[CR]...[K]weren't you the\none stealing the Time Gears?!", french="D'ailleurs, [CS:N]Massko[CR]...[K] c'était\npourtant bien toi qui volais les Rouages\ndu Temps, pas vrai?!", german="Und [CS:N]Reptain[CR]...[K] Hast du nicht\ndie Zahnräder der Zeit gestohlen?!?", italian="E, [CS:N]Grovyle[CR]...[K] non stavi rubando\ngli Ingranaggi del Tempo?!", spanish="Vamos a ver, [CS:N]Grovyle[CR]...[K]\n¿Estabas o no estabas robando los Engranajes\ndel Tiempo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" You've got to be joking!", french=" Vous plaisantez!", german=" Das soll wohl ein Scherz sein!", italian=" Vi hanno ingannato!", spanish=" Estás de broma, ¿no?"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" I was collecting Time Gears...", french="Je réunissais les Rouages\ndu Temps...", german="Ich habe die Zahnräder der Zeit\ngesammelt...", italian="Sì, stavo raccogliendo gli\nIngranaggi del Tempo.", spanish="Estaba reuniendo los Engranajes\ndel Tiempo..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Because they were needed for\npreventing the planet's paralysis.", french="... parce que j'en avais besoin\npour prévenir la Paralysie de la Planète.", german="Und das nur, weil ich sie\ngebraucht habe, um die Lähmung des Planeten\nzu verhindern.", italian="Ma lo facevo perché servivano\na evitare la paralisi del pianeta.", spanish="Porque eran necesarios para\nevitar la parálisis del planeta."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I needed to take them to\n[CS:P]Temporal Tower[CR] and put them in place.", french="Il fallait que je les remette\nà leur place dans la [CS:P]Tour du Temps[CR].", german="Ich musste sie zum [CS:P]Zeitturm[CR]\nbringen, um sie an ihre vorgesehene Stelle zu\nsetzen.", italian="Dovevo portarli alla [CS:P]Torre del[CR]\n[CS:P]Tempo[CR] e metterli al loro posto.", spanish="Tenía que llevarlos hasta\nla [CS:P]Torre del Tiempo[CR] y ponerlos en su sitio."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That would have reversed the\ncollapse of [CS:P]Temporal Tower[CR], which was\nfully under way in your time.", french="C'était la seule manière\nd'annuler l'effondrement de la [CS:P]Tour du Temps[CR],\nqui était déjà entamé dans votre temps.", german="Das hätte den Einsturz des\n[CS:P]Zeitturms[CR] rückgängig gemacht, der zu eurer\nZeit bereits im Gange war.", italian="Questo avrebbe evitato il crollo\ndella [CS:P]Torre del Tempo[CR], ormai imminente.", spanish="Eso habría impedido que se\nderrumbara la [CS:P]Torre del Tiempo[CR], algo que\nestá teniendo lugar en vuestra época."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="While it is true that removing a\nTime Gear from a specific place causes time\nto stop in that area...", french="Il est vrai que lorsqu'un Rouage\ndu Temps disparaît, le temps s'arrête\ndans la région concernée...", german="Es stimmt zwar, dass die Zeit in\neinem Gebiet stehenbleibt, wenn man sein\nZahnrad der Zeit entfernt.", italian="È vero che rimuovere un\nIngranaggio del Tempo dalla sua posizione\ncausa, in quella zona, l'arresto del tempo.", spanish="Es cierto que, al retirar un\nengranaje, el tiempo se detiene en la zona\ncircundante..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That's only temporary. After the\nTime Gears are put into [CS:P]Temporal Tower[CR]...", french="Mais ce n'est que temporaire.\nUne fois les Rouages du Temps remis en place\nà la [CS:P]Tour du Temps[CR]...", german="Aber das ist nur vorübergehend.\nWenn die Zahnräder der Zeit in den\n[CS:P]Zeitturm[CR] eingesetzt worden wären...", italian="Ma è solo un processo\ntemporaneo. Riportando gli Ingranaggi\ndel Tempo nella [CS:P]Torre del Tempo[CR]...", spanish="Pero eso es solo temporal.\nTras colocar los Engranajes del Tiempo en\nla [CS:P]Torre del Tiempo[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Time would have been fully\nrestored to normal everywhere.", french="... partout, le temps aurait\nrepris son cours normal.", german="Dann wäre die Zeit überall\nwieder in ihren Normalzustand zurückversetzt\nworden.", italian="... il tempo sarebbe tornato a\nscorrere ovunque normalmente.", spanish="El tiempo habría empezado a\nfluir de nuevo y con normalidad en todas\npartes."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Urf...[K] But then, what about all\nthe things [CS:N]Dusknoir[CR] said about you?", french="Hum...[K] Mais que penser de tout\nce que [CS:N]Noctunoir[CR] nous a raconté à ton sujet?", german="Urf...[K] Aber was ist dann mit all\ndem, was [CS:N]Zwirrfinst[CR] über dich gesagt hat?", italian="Uff...[K] Ma allora, tutte quelle\ncose che [CS:N]Dusknoir[CR] ci ha detto di te?", spanish="Pero...[K] ¿y todas las cosas que\n[CS:N]Dusknoir[CR] dijo de ti?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Urf...[K] But then, what about all\nthe things [CS:N]Dusknoir[CR] said about you?", french="Hum...[K] Mais que penser de tout\nce que [CS:N]Noctunoir[CR] nous a raconté à ton sujet?", german="Urf...[K] Aber was ist dann mit all\ndem, was [CS:N]Zwirrfinst[CR] über dich gesagt hat?", italian="Uff...[K] Ma allora, tutte quelle\ncose che [CS:N]Dusknoir[CR] ci ha detto di te?", spanish="Pero...[K] ¿y todas las cosas que\n[CS:N]Dusknoir[CR] dijo de ti?"})
  else
  SkySceneKit.say({english="Urf...[K] But then, what about all\nthe things [CS:N]Dusknoir[CR] said about you?", french="Hum...[K] Mais que penser de tout\nce que [CS:N]Noctunoir[CR] nous a raconté à ton sujet?", german="Urf...[K] Aber was ist dann mit all\ndem, was [CS:N]Zwirrfinst[CR] über dich gesagt hat?", italian="Uff...[K] Ma allora, tutte quelle\ncose che [CS:N]Dusknoir[CR] ci ha detto di te?", spanish="Pero...[K] ¿y todas las cosas que\n[CS:N]Dusknoir[CR] dijo de ti?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Like how he said you were a\nwanted outlaw in the future.", french="Il nous a affirmé que tu étais\nun criminel dont la tête était mise à prix dans\nle futur.", german="Er sagte zum Beispiel, dass du\nin der Zukunft ein gesuchter Verbrecher bist.", italian="Come per esempio che nel futuro\nsei un fuorilegge ricercato.", spanish="Nos contó que en el futuro\neras un malhechor buscado por la ley."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Like how he said you were a\nwanted outlaw in the future.", french="Il nous a affirmé que tu étais\nun criminel dont la tête était mise à prix dans\nle futur.", german="Er sagte zum Beispiel, dass du\nin der Zukunft ein gesuchter Verbrecher bist.", italian="Come per esempio che nel futuro\nsei un fuorilegge ricercato.", spanish="Nos contó que en el futuro\neras un malhechor buscado por la ley."})
  else
  SkySceneKit.say({english="Like how he said you were a\nwanted outlaw in the future.", french="Il nous a affirmé que tu étais\nun criminel dont la tête était mise à prix dans\nle futur.", german="Er sagte zum Beispiel, dass du\nin der Zukunft ein gesuchter Verbrecher bist.", italian="Come per esempio che nel futuro\nsei un fuorilegge ricercato.", spanish="Nos contó que en el futuro\neras un malhechor buscado por la ley."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And how you escaped from\nthe future...", french="Et aussi que tu avais fui\nle futur pour échapper à la justice...", german="Und wie du aus der\nZukunft geflohen bist...", italian="E di come sei scappato\ndal futuro...", spanish=" Y que para escaparte..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And how you escaped from\nthe future...", french="Et aussi que tu avais fui\nle futur pour échapper à la justice...", german="Und wie du aus der\nZukunft geflohen bist...", italian="E di come sei scappato\ndal futuro...", spanish=" Y que para escaparte..."})
  else
  SkySceneKit.say({english="And how you escaped from\nthe future...", french="Et aussi que tu avais fui\nle futur pour échapper à la justice...", german="Und wie du aus der\nZukunft geflohen bist...", italian="E di come sei scappato\ndal futuro...", spanish=" Y que para escaparte..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="then fled to our world in\nthe past.", french="... et te réfugier dans\nnotre monde, dans le passé.", german="Nur, um dich in die Welt der\nVergangenheit zu flüchten.", italian="E che ti sei rifugiato nel nostro\nmondo, nel passato, per sfuggire alla legge.", spanish="Buscaste refugio en nuestro\nmundo, en el pasado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="then fled to our world in\nthe past.", french="... et te réfugier dans\nnotre monde, dans le passé.", german="Nur, um dich in die Welt der\nVergangenheit zu flüchten.", italian="E che ti sei rifugiato nel nostro\nmondo, nel passato, per sfuggire alla legge.", spanish="Buscaste refugio en nuestro\nmundo, en el pasado."})
  else
  SkySceneKit.say({english="then fled to our world in\nthe past.", french="... et te réfugier dans\nnotre monde, dans le passé.", german="Nur, um dich in die Welt der\nVergangenheit zu flüchten.", italian="E che ti sei rifugiato nel nostro\nmondo, nel passato, per sfuggire alla legge.", spanish="Buscaste refugio en nuestro\nmundo, en el pasado."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So you're saying all that was\njust a bunch of lies?", french="Tu soutiens qu'il nous a menti\nsur toute la ligne?", german="Du sagst also, dass all das nur\nein Haufen Lügen war?", italian="Quindi stai dicendo che sono solo\nun sacco di bugie?", spanish=" ¿Insinúas que todo era mentira?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So you're claiming all that was\njust a bunch of lies?", french="Tu soutiens qu'il nous a menti\nsur toute la ligne?", german="Du sagst also, dass all das nur\nein Haufen Lügen war?", italian="Quindi stai dicendo che sono solo\nun sacco di bugie?", spanish="¿Insinúas que no había nada de\ncierto en esa historia?"})
  else
  SkySceneKit.say({english="So you're saying all that was\njust a bunch of lies?", french="Tu soutiens qu'il nous a menti\nsur toute la ligne?", german="Du sagst also, dass all das nur\nein Haufen Lügen war?", italian="Quindi stai dicendo che sono solo\nun sacco di bugie?", spanish=" ¿Insinúas que era todo mentira?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" What else could it be?", french=" Quoi d'autre?", german=" Was sollte es sonst sein?", italian=" Cos'altro potrebbero essere?", spanish=" ¿Y qué iba a ser si no?"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Because [CS:N]Dusknoir[CR] really is...", french=" En réalité, [CS:N]Noctunoir[CR] est...", german="[CS:N]Zwirrfinst[CR] ist nämlich in\nWirklichkeit...", italian="Questo perché [CS:N]Dusknoir[CR] in realtà\nè...", spanish="Al fin y al cabo, [CS:N]Dusknoir[CR]\nen realidad es..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="an agent sent from this future\nby Primal [CS:N]Dialga[CR]...[K]to get rid of me.", french="... un sbire de [CS:N]Dialga[CR]\nPrimal, qui l'a envoyé dans le passé...[K] pour\nse débarrasser de moi.", german="Nun, er ist ein Agent, den\n[CS:N]Schatten-Dialga[CR] aus der Zukunft geschickt\nhat...[K] Um mich aus dem Weg zu räumen.", italian="Non è altro che un agente\nmandato dal futuro da [CS:N]Dialga[CR] Oscuro...[K]\nper liberarsi di me.", spanish="Un agente enviado del futuro por\nel [CS:N]Dialga Primario[CR]...[K] para librarse de mí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What?![K] [CS:N]Dusknoir[CR] was...[K]an agent\nsent to get rid of you?!", french="Quoi?![K] [CS:N]Noctunoir[CR] avait\npour mission de...[K] se débarrasser de toi?!", german="Was?!?[K] [CS:N]Zwirrfinst[CR] wurde\ngeschickt,[K] um dich aus dem Weg zu räumen?", italian="Cosa?![K] [CS:N]Dusknoir[CR] è stato...[K]\nincaricato di liberarsi di te?!", spanish="¡¿Qué?![K] [CS:N]Dusknoir[CR] fue enviado...[K]\n¡¿para acabar contigo?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What?![K] [CS:N]Dusknoir[CR] was...[K]an agent\nsent to get rid of you?!", french="Quoi?![K] [CS:N]Noctunoir[CR] avait\npour mission de...[K] se débarrasser de toi?!", german="Was?!?[K] [CS:N]Zwirrfinst[CR] wurde\ngeschickt,[K] um dich aus dem Weg zu räumen?", italian="Cosa?![K] [CS:N]Dusknoir[CR] è stato...[K]\nincaricato di liberarsi di te?!", spanish="¡¿Qué?![K] [CS:N]Dusknoir[CR] fue enviado...[K]\n¡¿para acabar contigo?!"})
  else
  SkySceneKit.say({english="What?![K] [CS:N]Dusknoir[CR] was...[K]an agent\nsent to get rid of you?!", french="Quoi?![K] [CS:N]Noctunoir[CR] avait\npour mission de...[K] se débarrasser de toi?!", german="Was?!?[K] [CS:N]Zwirrfinst[CR] wurde\ngeschickt,[K] um dich aus dem Weg zu räumen?", italian="Cosa?![K] [CS:N]Dusknoir[CR] è stato...[K]\nincaricato di liberarsi di te?!", spanish="¡¿Qué?![K] [CS:N]Dusknoir[CR] fue enviado...[K]\n¡¿para acabar contigo?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" That's right.", french=" Exact.", german=" Genau.", italian=" Proprio così.", spanish=" Así es."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" I have said that Primal [CS:N]Dialga[CR]...", french="Je vous ai déjà dit que [CS:N]Dialga[CR]\nPrimal...", german="Ich habe ja gesagt, dass\n[CS:N]Schatten-Dialga[CR]...", italian="Come vi ho detto, [CS:N]Dialga[CR]\nOscuro...", spanish="Como ya he dicho, el [CS:N]Dialga[CR]\n[CS:N]Primario[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="will try to thwart any attempt\nto alter the course of history.", french="... s'opposera par tous les\nmoyens à ce que le cours de l'histoire soit\naltéré.", german="Nun, es will jeden Versuch, den\nVerlauf der Geschichte zu verändern,\nverhindern.", italian="... cerca di impedire ogni\ntentativo di alterare il corso della storia.", spanish="Hará lo que sea para frustrar\ncualquier intento de alterar el curso de\nla historia."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That's why, when he learned that\nI traveled through time...", french="Du coup, quand il a appris\nque j'étais parti dans le passé...", german="Als es erfuhr, dass ich durch die\nZeit reise...", italian="Perciò, quando ha scoperto che\nero tornato indietro nel tempo...", spanish="Por eso, cuando descubrió\nque había viajado al pasado..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" He sent [CS:N]Dusknoir[CR] after me.", french="... il a envoyé [CS:N]Noctunoir[CR]\nà ma poursuite.", german="Zu diesem Zeitpunkt beschloss\nes, mir [CS:N]Zwirrfinst[CR] hinterherzuschicken.", italian="... mi ha messo [CS:N]Dusknoir[CR] alle\ncostole.", spanish=" Envió a [CS:N]Dusknoir[CR] a por mí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The great...[K][CS:N]Dusknoir[CR]...?[K]\nIt can't be!", french="Le grand... [K][CS:N]Noctunoir[CR]...?[K]\nMais c'est impossible!", german="Der große...[K] [CS:N]Zwirrfinst[CR]?[K]\nDas kann nicht sein!", italian="Il grande...[K] [CS:N]Dusknoir[CR]...?[K]\nNon può essere!", spanish="El gran...[K] ¿[CS:N]Dusknoir[CR]?[K]\n¡No puede ser!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The great...[K][CS:N]Dusknoir[CR]...?[K]\nIt can't be!", french="Le grand... [K][CS:N]Noctunoir[CR]...?[K]\nMais c'est impossible!", german="Der große...[K] [CS:N]Zwirrfinst[CR]?[K]\nDas kann nicht sein!", italian="Il grande...[K] [CS:N]Dusknoir[CR]...?[K]\nNon può essere!", spanish="El gran...[K] ¿[CS:N]Dusknoir[CR]?[K]\n¡No puede ser!"})
  else
  SkySceneKit.say({english="The great...[K][CS:N]Dusknoir[CR]...?[K]\nIt can't be!", french="Le grand... [K][CS:N]Noctunoir[CR]...?[K]\nMais c'est impossible!", german="Der große...[K] [CS:N]Zwirrfinst[CR]?[K]\nDas kann nicht sein!", italian="Il grande...[K] [CS:N]Dusknoir[CR]...?[K]\nNon può essere!", spanish="El gran...[K] ¿[CS:N]Dusknoir[CR]?[K]\n¡No puede ser!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="It's hard for you to believe,\nI know...", french="Je sais que c'est un peu difficile\nà croire pour vous...", german="Es ist schwer zu glauben, ich\nweiß...", italian="Lo so, per voi è difficile da\ncredere...", spanish=" Ya sé que es difícil de creer..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I can't believe it at all!", french="Dis plutôt que je n'en crois pas\nun mot!", german="Ich kann es überhaupt nicht\nglauben!", italian=" Non ci posso affatto credere!", spanish=" ¡No, no me creo ni una palabra!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I can't believe it at all!", french="Dis plutôt que je n'en crois pas\nun mot!", german="Ich kann es überhaupt nicht\nglauben!", italian=" Non ci posso affatto credere!", spanish=" ¡No, no me creo ni una palabra!"})
  else
  SkySceneKit.say({english=" I can't believe it at all!", french="Dis plutôt que je n'en crois pas\nun mot!", german="Ich kann es überhaupt nicht\nglauben!", italian=" Non ci posso affatto credere!", spanish=" ¡No, no me creo ni una palabra!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You're saying all this about\nthe great [CS:N]Dusknoir[CR]?!", french="C'est quand même le nom du\ngrand [CS:N]Noctunoir[CR] que tu salis!", german="Du sagst das alles über den\ngroßen [CS:N]Zwirrfinst[CR]?!?", italian="Stai dicendo tutto questo del\ngrande [CS:N]Dusknoir[CR]?!", spanish="¡Estás calumniando al gran\n[CS:N]Dusknoir[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You're saying all this about\nthe great [CS:N]Dusknoir[CR]?!", french="C'est quand même le nom du\ngrand [CS:N]Noctunoir[CR] que tu salis!", german="Du sagst das alles über den\ngroßen [CS:N]Zwirrfinst[CR]?!?", italian="Stai dicendo tutto questo del\ngrande [CS:N]Dusknoir[CR]?!", spanish="¡Estás calumniando al gran\n[CS:N]Dusknoir[CR]!"})
  else
  SkySceneKit.say({english="You're saying all this about\nthe great [CS:N]Dusknoir[CR]?!", french="C'est quand même le nom du\ngrand [CS:N]Noctunoir[CR] que tu salis!", german="Du sagst das alles über den\ngroßen [CS:N]Zwirrfinst[CR]?!?", italian="Stai dicendo tutto questo del\ngrande [CS:N]Dusknoir[CR]?!", spanish="¡Estás calumniando al gran\n[CS:N]Dusknoir[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I don't understand why [CS:N]Dusknoir[CR]\nis acting this way here, but...", french="J'avoue que je ne m'explique pas\nson comportement ici, dans le futur, mais...", german="Ich verstehe nicht, warum sich\n[CS:N]Zwirrfinst[CR] hier so verhält, aber...", italian="Non capisco perché [CS:N]Dusknoir[CR]\nqui agisca in questo modo, ma...", spanish="No entiendo por qué [CS:N]Dusknoir[CR]\nestá actuando de esta forma, pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I don't understand why [CS:N]Dusknoir[CR]\nis acting this way here, but...", french="J'avoue que je ne m'explique pas\nson comportement ici, dans le futur, mais...", german="Ich verstehe nicht, warum sich\n[CS:N]Zwirrfinst[CR] hier so verhält, aber...", italian="Non capisco perché [CS:N]Dusknoir[CR]\nqui agisca in questo modo, ma...", spanish="No entiendo por qué [CS:N]Dusknoir[CR]\nestá actuando de esta forma, pero..."})
  else
  SkySceneKit.say({english="I don't understand why [CS:N]Dusknoir[CR]\nis acting this way here, but...", french="J'avoue que je ne m'explique pas\nson comportement ici, dans le futur, mais...", german="Ich verstehe nicht, warum sich\n[CS:N]Zwirrfinst[CR] hier so verhält, aber...", italian="Non capisco perché [CS:N]Dusknoir[CR]\nqui agisca in questo modo, ma...", spanish="No entiendo por qué [CS:N]Dusknoir[CR]\nestá actuando de esta forma, pero..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But I admired...[K][CS:N]Dusknoir[CR]...", french="... j'ai beaucoup d'admiration\npour...[K] [CS:N]Noctunoir[CR]...", german="Aber ich habe [CS:N]Zwirrfinst[CR]...[K]\nbewundert...", italian=" Io ammiravo...[K] [CS:N]Dusknoir[CR]...", spanish=" Yo admiraba...[K] a [CS:N]Dusknoir[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But I respected...[K][CS:N]Dusknoir[CR]...", french="... j'ai beaucoup d'admiration\npour...[K] [CS:N]Noctunoir[CR]...", german="Aber ich hatte großen Respekt\nvor[K] [CS:N]Zwirrfinst[CR]...", italian=" Io rispettavo...[K] [CS:N]Dusknoir[CR]...", spanish=" Yo admiraba...[K] a [CS:N]Dusknoir[CR]..."})
  else
  SkySceneKit.say({english=" But I looked up to...[K][CS:N]Dusknoir[CR]...", french="... j'ai beaucoup d'admiration\npour...[K] [CS:N]Noctunoir[CR]...", german="Aber ich habe [CS:N]Zwirrfinst[CR]...[K]\nbewundert...", italian=" [CS:N]Dusknoir[CR]...[K] era il mio idolo...", spanish=" Yo admiraba...[K] a [CS:N]Dusknoir[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I can't...[K] I can't believe you...", french="C'est impossible...[K] je ne peux\npas croire à ton histoire...", german="Ich kann...[K] Ich kann dir nicht\nglauben...", italian="Non posso...[K] Non posso\ncrederti!", spanish=" No puedo...[K] No puedo creerte..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I can't...[K] I can't believe you...", french="C'est impossible...[K] je ne peux\npas croire à ton histoire...", german="Ich kann...[K] Ich kann dir nicht\nglauben...", italian="Non posso...[K] Non posso\ncrederti!", spanish=" No puedo...[K] No puedo creerte..."})
  else
  SkySceneKit.say({english=" I can't...[K] I can't believe you...", french="C'est impossible...[K] je ne peux\npas croire à ton histoire...", german="Ich kann...[K] Ich kann dir nicht\nglauben...", italian="Non posso...[K] Non posso\ncrederti!", spanish=" No puedo...[K] No puedo creerte..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_TIME_GEAR non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It is hard to accept, but...)", french="(C'est dur à avaler, mais...)", german="(Es ist schwer zu akzeptieren, aber...)", italian="(È difficile da accettare, ma...)", spanish="(Es difícil aceptarlo, pero...)"})
  else
  SkySceneKit.say({english="(It is hard to accept, but...)", french="(C'est dur à avaler, mais...)", german="(Es ist schwer zu akzeptieren, aber...)", italian="(È difficile da accettare, ma...)", spanish="(Es difícil aceptarlo, pero...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Looking back over what we've been through in\nthis future world...)", french="(... en repensant à toutes les épreuves qu'on a\ntraversées ici...)", german="(Wenn ich daran denke, was wir in dieser\nzukünftigen Welt erleben mussten...)", italian="(Se ripenso a quello che abbiamo dovuto\npassare in questo mondo futuro...)", spanish="(Viendo lo que hemos pasado desde que\nllegamos al mundo futuro...)"})
  else
  SkySceneKit.say({english="(Looking back over what we've been through in\nthis future world...)", french="(... en repensant à toutes les épreuves qu'on a\ntraversées ici...)", german="(Wenn ich daran denke, was wir in dieser\nzukünftigen Welt erleben mussten...)", italian="(Se ripenso a quello che abbiamo dovuto\npassare in questo mondo futuro...)", spanish="(Viendo lo que hemos pasado desde que\nllegamos al mundo futuro...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What [CS:N]Grovyle[CR] said is reasonable.[K] It makes\nperfect sense.)", french="(... la version de [CS:N]Massko[CR] est cohérente.[K]\nTout concorde parfaitement.)", german="(Dann kommen mir die Worte von [CS:N]Reptain[CR]\nvernünftig vor.[K] Es ergibt wirklich Sinn.)", italian="(Beh, ciò che [CS:N]Grovyle[CR] ha detto è ragionevole.[K]\nÈ assolutamente credibile.)", spanish="(Lo que dice [CS:N]Grovyle[CR] es razonable.[K]\nTiene bastante sentido.)"})
  else
  SkySceneKit.say({english="(What [CS:N]Grovyle[CR] said is reasonable.[K] It makes\nperfect sense.)", french="(... la version de [CS:N]Massko[CR] est cohérente.[K]\nTout concorde parfaitement.)", german="(Dann kommen mir die Worte von [CS:N]Reptain[CR]\nvernünftig vor.[K] Es ergibt wirklich Sinn.)", italian="(Beh, ciò che [CS:N]Grovyle[CR] ha detto è ragionevole.[K]\nÈ assolutamente credibile.)", spanish="(Lo que dice [CS:N]Grovyle[CR] es razonable.[K]\nTiene bastante sentido.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(And [partner] knows it.)", french="(Et [partner] le sait.)", german="(Und [partner] weiß es.)", italian="(E [partner] lo sa.)", spanish="(Y [partner] lo sabe.)"})
  else
  SkySceneKit.say({english="(And [partner] knows it.)", french="(Et [partner] le sait.)", german="(Und [partner] weiß es.)", italian="(E [partner] lo sa.)", spanish="(Y [partner] lo sabe.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner] knows deep down that what\n[CS:N]Grovyle[CR] says is true.)", french="(En son for intérieur, [partner] sait que\n[CS:N]Massko[CR] dit la vérité.)", german="([partner] weiß im Grunde, dass [CS:N]Reptain[CR]\ndie Wahrheit sagt.)", italian="([partner] sa perfettamente che [CS:N]Grovyle[CR]\ndice la verità.)", spanish="(En el fondo [partner] sabe perfectamente\nque lo que dice [CS:N]Grovyle[CR] es verdad.)"})
  else
  SkySceneKit.say({english="([partner] knows deep down that what\n[CS:N]Grovyle[CR] says is true.)", french="(En son for intérieur, [partner] sait que\n[CS:N]Massko[CR] dit la vérité.)", german="([partner] weiß im Grunde, dass [CS:N]Reptain[CR]\ndie Wahrheit sagt.)", italian="([partner] sa perfettamente che [CS:N]Grovyle[CR]\ndice la verità.)", spanish="(En el fondo [partner] sabe perfectamente\nque lo que dice [CS:N]Grovyle[CR] es verdad.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But knowing that makes it that much harder\nto accept...)", french="(Mais ça ne lui rend pas les choses plus\nfaciles...)", german="(Aber das zu wissen, macht es fast noch\nschwerer, es zu akzeptieren.)", italian="(Ma è più difficile accettarlo sapendo tutto\nquesto...)", spanish="(Pero saberlo hace que le resulte mucho\nmás duro aceptarlo...)"})
  else
  SkySceneKit.say({english="(But knowing that makes it that much harder\nto accept...)", french="(Mais ça ne lui rend pas les choses plus\nfaciles...)", german="(Aber das zu wissen, macht es fast noch\nschwerer, es zu akzeptieren.)", italian="(Ma è più difficile accettarlo sapendo tutto\nquesto...)", spanish="(Pero saberlo hace que le resulte mucho\nmás duro aceptarlo...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But...)", french="(Pourtant...)", german="(Aber...)", italian="(Ma...)", spanish="(Sin embargo...)"})
  else
  SkySceneKit.say({english="(But...)", french="(Pourtant...)", german="(Aber...)", italian="(Ma...)", spanish="(Sin embargo...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 120, 396, false, 2)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "exclaim", 1) end)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownLeft)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Hey! Where are you going?", french=" Eh, tu vas où comme ça?", german=" Hey! Wo gehst du hin?", italian=" Ehi! Dove stai andando?", spanish=" ¡Oye! ¿Adónde vas?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'm going to see [CS:N]Dusknoir[CR].", french="Je vais rendre une petite visite\nà [CS:N]Noctunoir[CR].", german=" Ich gehe zu [CS:N]Zwirrfinst[CR].", italian=" Sto andando da [CS:N]Dusknoir[CR].", spanish=" Voy a ver a [CS:N]Dusknoir[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I'm going to see [CS:N]Dusknoir[CR].", french="Je vais rendre une petite visite\nà [CS:N]Noctunoir[CR].", german=" Ich gehe zu [CS:N]Zwirrfinst[CR].", italian=" Sto andando da [CS:N]Dusknoir[CR].", spanish=" Voy a ver a [CS:N]Dusknoir[CR]."})
  else
  SkySceneKit.say({english=" I'm going to see [CS:N]Dusknoir[CR].", french="Je vais rendre une petite visite\nà [CS:N]Noctunoir[CR].", german=" Ich gehe zu [CS:N]Zwirrfinst[CR].", italian=" Sto andando da [CS:N]Dusknoir[CR].", spanish=" Voy a ver a [CS:N]Dusknoir[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I want to see [CS:N]Dusknoir[CR].[K]\nI'm going to find out if what you said is true\nor not.", french="Il faut que je voie [CS:N]Noctunoir[CR].[K]\nJ'entends bien découvrir si ce que tu as dit est\nvrai ou pas.", german="Ich will [CS:N]Zwirrfinst[CR] sehen.[K]\nIch werde herausfinden, ob du die Wahrheit\ngesagt hast.", italian="Voglio vedere [CS:N]Dusknoir[CR].[K] Devo\nscoprire se quello che dici è vero o no.", spanish="Quiero ver a [CS:N]Dusknoir[CR].[K] Quiero\nque me diga si tu historia es cierta o no."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I want to see [CS:N]Dusknoir[CR].[K]\nI'm going to find out if what you said is true\nor not.", french="Il faut que je voie [CS:N]Noctunoir[CR].[K]\nJ'entends bien découvrir si ce que tu as dit est\nvrai ou pas.", german="Ich will [CS:N]Zwirrfinst[CR] sehen.[K]\nIch werde herausfinden, ob du die Wahrheit\ngesagt hast.", italian="Voglio vedere [CS:N]Dusknoir[CR].[K] Devo\nscoprire se quello che dici è vero oppure no.", spanish="Quiero ver a [CS:N]Dusknoir[CR].[K] Quiero\nque me diga si tu historia es cierta o no."})
  else
  SkySceneKit.say({english="I want to see [CS:N]Dusknoir[CR].[K]\nI'm going to find out if what you said is true\nor not.", french="Il faut que je voie [CS:N]Noctunoir[CR].[K]\nJ'entends bien découvrir si ce que tu as dit est\nvrai ou pas.", german="Ich will [CS:N]Zwirrfinst[CR] sehen.[K]\nIch werde herausfinden, ob du die Wahrheit\ngesagt hast.", italian="Voglio vedere [CS:N]Dusknoir[CR].[K] Devo\nscoprire se quello che dici è vero oppure no.", spanish="Quiero ver a [CS:N]Dusknoir[CR].[K] Quiero\nque me diga si tu historia es cierta o no."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" What's the point of that?!", french=" Mais enfin, c'est ridicule!", german=" Was soll denn das bringen?!?", italian=" Che senso ha?!", spanish=" ¡¿Y qué vas a ganar con eso?!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="You'll only be making it easy for\nthem to get rid of you!", french="Tu vas te jeter directement\ndans la gueule du loup!", german="Du machst es ihnen nur leichter,\ndich aus dem Weg zu räumen.", italian="Per loro sarà solo più semplice\nsbarazzarsi di te!", spanish="¡Se lo pondrás en bandeja!\n¡Se librarán de ti!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="You don't stand a chance\nagainst them!", french="Tu n'as aucune chance contre\neux!", german=" Du hast keine Chance gegen sie!", italian="Non hai alcuna possibilità contro\ndi loro!", spanish="¡No tienes ninguna oportunidad\ncontra ellos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Then...[K]what am I supposed\nto do?!", french="Mais...[K] qu'est-ce que je suis\ncensé faire moi, maintenant?!", german=" Und...[K] Was soll ich dann tun?!?", italian=" Allora...[K] cosa dovrei fare?!", spanish="Entonces...[K]\n¡¿Qué tengo que hacer?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Then...[K]what am I supposed\nto do?!", french="Mais...[K] qu'est-ce que je suis\ncensé faire moi, maintenant?!", german=" Und...[K] Was soll ich dann tun?!?", italian=" Allora...[K] cosa dovrei fare?!", spanish="Entonces...[K]\n¡¿Qué tengo que hacer?!"})
  else
  SkySceneKit.say({english="Then...[K]what am I supposed\nto do?!", french="Mais...[K] qu'est-ce que je suis\ncensée faire moi, maintenant?!", german=" Und...[K] Was soll ich dann tun?!?", italian=" Allora...[K] cosa dovrei fare?!", spanish="Entonces...[K]\n¡¿Qué tengo que hacer?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" What are you supposed to do?!", french=" Qu'est-ce que tu dois faire?!", german=" Was du tun sollst?!?", italian=" Cosa dovresti fare?!", spanish=" ¡¿Que qué tienes que hacer?!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Didn't you wonder this earlier?!", french="Il me semble que tu t'es déjà\nposé cette question tout à l'heure, non?!", german="Hast du dich das nicht schon\nzuvor gefragt?!?", italian=" Non te lo sei già chiesto prima?!", spanish="¿No habías pensado en eso\nantes?"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="And you decided...that you would\ndecide for yourself!", french="Et tu as décidé... que tu te\nferais ta propre opinion!", german="Und du hast beschlossen, dass du\nfür dich selbst entscheidest!", italian="E hai deciso... che avresti fatto\ndi testa tua!", spanish="Dijiste que querías escucharme y\nque, después, te formarías tu propia opinión."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="You insisted that, because you\ndon't know what to believe...", french="Et tu as bien insisté sur le fait\nque, comme tu ne savais plus qui croire...", german="Weil du nicht wusstest, was du\nglauben sollst...", italian="Insistevi nel dire che, poiché\nnon sapevi a cosa credere...", spanish="Insististe en que te lo explicara\ntodo porque ya no sabías a quién creer..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="you wouldn't accept words for\ntheir face value...[K]and you'd think for yourself!", french="... tu n'avalerais pas n'importe\nquoi sans réfléchir...[K] et que tu ne te laisserais\npas influencer!", german="Darum wolltest du meine Worte\nnicht für bare Münze nehmen...[K] Sondern selbst\nnachdenken!", italian="... non avresti accettato a priori\nla mia versione...[K] e che avresti deciso con la\ntua testa!", spanish="Dijiste que no asumirías nada\ncomo cierto...[K] sin pensarlo bien antes."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk...", french=" Argh...", german=" Urk...", italian=" Uh...", spanish=" Ay..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk...", french=" Argh...", german=" Urk...", italian=" Uh...", spanish=" Ay..."})
  else
  SkySceneKit.say({english=" Urk...", french=" Argh...", german=" Urk...", italian=" Uh...", spanish=" Ay..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="It's times like this, when things\nare tough, that you have to be strong.", french="Dans des moments difficiles\ncomme celui-ci, il faut savoir trancher.", german="In schweren Momenten wie\ndiesen musst du stark sein.", italian="È in momenti come questi,\nquando le cose sono difficili, che bisogna\nessere forti.", spanish="Es en momentos tan duros como\neste cuando es más necesario ser fuerte."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Think for yourself, then act as\nyou deem right.", french="Pense par toi-même, décide-toi\net agis en conséquence.", german="Überlege selbst, und tue dann,\nwas du für das Richtige hältst.", italian="Pensa con la tua testa e poi\nagisci di conseguenza.", spanish="Uno tiene que pensar por sí\nmismo, tener sus propias convicciones y\ndefenderlas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_juputoru, 208, 396, false, 2)
  GAME:WaitFrames(20)
  GROUND:EntTurn(partner, Direction.Right)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(28), p.Y+(0), false, 2) end
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Down)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Grovyle[CR]...[K] What are you going\nto do now?", french="[CS:N]Massko[CR]...[K] Qu'est-ce que tu vas\nfaire maintenant?", german="[CS:N]Reptain[CR]...[K] Was hast du jetzt\nvor?", italian="[CS:N]Grovyle[CR]...[K] Adesso cosa hai\nintenzione di fare?", spanish="[CS:N]Grovyle[CR]...[K]\n¿Qué vas a hacer ahora?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Grovyle[CR]...[K] What are you going\nto do now?", french="[CS:N]Massko[CR]...[K] Qu'est-ce que tu vas\nfaire maintenant?", german="[CS:N]Reptain[CR]...[K] Was hast du jetzt\nvor?", italian="[CS:N]Grovyle[CR]...[K] Adesso cosa hai\nintenzione di fare?", spanish="[CS:N]Grovyle[CR]...[K]\n¿Qué vas a hacer ahora?"})
  else
  SkySceneKit.say({english="[CS:N]Grovyle[CR]...[K] What are you going\nto do now?", french="[CS:N]Massko[CR]...[K] Qu'est-ce que tu vas\nfaire maintenant?", german="[CS:N]Reptain[CR]...[K] Was hast du jetzt\nvor?", italian="[CS:N]Grovyle[CR]...[K] Adesso cosa hai\nintenzione di fare?", spanish="[CS:N]Grovyle[CR]...[K]\n¿Qué vas a hacer ahora?"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I'm going back to the past again\nto stop the planet's paralysis.", french="Je vais retourner dans le passé\npour empêcher la Paralysie de la Planète.", german="Ich gehe wieder in die\nVergangenheit, um die Lähmung des Planeten\nzu verhindern.", italian="Tornerò nel passato per fermare\nla paralisi del pianeta.", spanish="Me vuelvo al pasado otra vez\npara detener la parálisis del planeta."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" To do that...", french=" Et pour ce faire...", german=" Und um das zu erreichen...", italian=" Per farlo...", spanish=" Para hacerlo..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" I need to find [CS:N]Celebi[CR].", french=" ... il faut que je trouve [CS:N]Celebi[CR].", german=" Dazu muss ich [CS:N]Celebi[CR] finden.", italian=" Per farlo, devo trovare [CS:N]Celebi[CR].", spanish=" Tengo que encontrar a [CS:N]Celebi[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Cel[CR]...[K][CS:N]Celebi[CR]?", french=" [CS:N]Cel[CR]...[K] [CS:N]Celebi[CR]?", german=" [CS:N]Cel[CR]...[K] [CS:N]Celebi[CR]?", italian=" [CS:N]Cel[CR]...[K] [CS:N]Celebi[CR]?", spanish=" [CS:N]Ce[CR]...[K] ¿[CS:N]Celebi[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Cel[CR]...[K][CS:N]Celebi[CR]?", french=" [CS:N]Cel[CR]...[K] [CS:N]Celebi[CR]?", german=" [CS:N]Cel[CR]...[K] [CS:N]Celebi[CR]?", italian=" [CS:N]Cel[CR]...[K] [CS:N]Celebi[CR]?", spanish=" [CS:N]Ce[CR]...[K] ¿[CS:N]Celebi[CR]?"})
  else
  SkySceneKit.say({english=" [CS:N]Cel[CR]...[K][CS:N]Celebi[CR]?", french=" [CS:N]Cel[CR]...[K] [CS:N]Celebi[CR]?", german=" [CS:N]Cel[CR]...[K] [CS:N]Celebi[CR]?", italian=" [CS:N]Cel[CR]...[K] [CS:N]Celebi[CR]?", spanish=" [CS:N]Ce[CR]...[K] ¿[CS:N]Celebi[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" That's right.", french=" Exact.", german=" Genau.", italian=" Sì.", spanish=" Así es."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="You can come with me or not.\nIt's your choice.", french="Vous pouvez me suivre ou pas.\nA vous de voir.", german="Ihr könnt mitkommen oder nicht.\nEs ist eure Wahl.", italian="Potete venire o non venire.\nTocca a voi decidere.", spanish="Podéis venir conmigo o no.\nEs decisión vuestra."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="You two decide on your own\ncourse of action.", french="Décidez par vous-mêmes\nde la marche à suivre.", german="Ihr entscheidet selbst, was ihr\ntun wollt.", italian="Dovete decidere di testa vostra\ncome agire.", spanish=" Podéis escoger vuestro destino."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" I'm off.", french=" Moi, j'y vais.", german=" Ich bin weg.", italian=" Non dipende da me.", spanish=" Yo me voy."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(160), p.Y+(0), false, 2) end
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk...", french=" Argh...", german=" Urk...", italian=" Ah...", spanish=" Ay..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk...", french=" Argh...", german=" Urk...", italian=" Ah...", spanish=" Ay..."})
  else
  SkySceneKit.say({english=" Urk...", french=" Argh...", german=" Urk...", italian=" Ah...", spanish=" Ay..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...............)", french="(...............)", german="(...............)", italian="(...............)", spanish="(...)"})
  else
  SkySceneKit.say({english="(...............)", french="(...............)", german="(...............)", italian="(...............)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I don't know what I should believe either.)", french="(Moi non plus, je ne sais plus ce que je dois\ncroire.)", german="(Ich weiß auch nicht, was ich glauben soll.)", italian="(Anch'io non so a cosa credere.)", spanish="(Yo tampoco sé a quién creer.)"})
  else
  SkySceneKit.say({english="(I don't know what I should believe either.)", french="(Moi non plus, je ne sais plus ce que je dois\ncroire.)", german="(Ich weiß auch nicht, was ich glauben soll.)", italian="(Anch'io non so a cosa credere.)", spanish="(Yo tampoco sé a quién creer.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But...[K]there is one thing I can say with\ncertainty.)", french="(Pourtant...[K] il y a au moins une chose dont\nje suis sûr.)", german="(Aber...[K] Es gibt eine Sache, die ich mit\nSicherheit sagen kann.)", italian="(Ma...[K] c'è una cosa che posso dire con\ncertezza.)", spanish="(Pero...[K] hay una cosa que sé a ciencia cierta...)"})
  else
  SkySceneKit.say({english="(But...[K]there is one thing I can say with\ncertainty.)", french="(Pourtant...[K] il y a au moins une chose dont\nje suis sûre.)", german="(Aber...[K] Es gibt eine Sache, die ich mit\nSicherheit sagen kann.)", italian="(Ma...[K] c'è una cosa che posso dire con\ncertezza.)", spanish="(Pero...[K] hay una cosa que sé a ciencia cierta...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(In this future world of darkness...)", french="(Dans ce futur englouti par l'ombre...)", german="(In dieser zukünftigen Welt der Dunkelheit...)", italian="(In questo futuro mondo d'oscurità...)", spanish="(En este mundo futuro de oscuridad...)"})
  else
  SkySceneKit.say({english="(In this future world of darkness...)", french="(Dans ce futur englouti par l'ombre...)", german="(In dieser zukünftigen Welt der Dunkelheit...)", italian="(In questo futuro mondo d'oscurità...)", spanish="(En este mundo futuro de oscuridad...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The planet is paralyzed.)", french="(... la planète est paralysée.)", german="(In dieser Zeit ist der Planet gelähmt.)", italian="(... il pianeta è paralizzato.)", spanish="(El planeta está paralizado.)"})
  else
  SkySceneKit.say({english="(The planet is paralyzed.)", french="(... la planète est paralysée.)", german="(In dieser Zeit ist der Planet gelähmt.)", italian="(... il pianeta è paralizzato.)", spanish="(El planeta está paralizado.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(And the paralysis of the planet...[K] It happened\nback in our world.)", french="(Et la Paralysie de la Planète...[K] c'est dans\nnotre monde qu'elle a commencé.)", german="(Und die Lähmung unseres Planeten[K] ist in\nunserer Zeit geschehen.)", italian="(E la paralisi del pianeta...[K] è avvenuta nel\npassato, nel nostro mondo..)", spanish="(Y la parálisis del planeta...[K] parece haber\nsucedido en nuestra época.)"})
  else
  SkySceneKit.say({english="(And the paralysis of the planet...[K] It happened\nback in our world.)", french="(Et la Paralysie de la Planète...[K] c'est dans\nnotre monde qu'elle a commencé.)", german="(Und die Lähmung unseres Planeten[K] ist in\nunserer Zeit geschehen.)", italian="(E la paralisi del pianeta...[K] è avvenuta nel\npassato, nel nostro mondo..)", spanish="(Y la parálisis del planeta...[K] parece haber\nsucedido en nuestra época.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That's why, to stop that from happening...)", french="(Donc, si on veut empêcher ça...)", german="(Um dies zu verhindern, gibt es nur eine\nMöglichkeit...)", italian="(Quindi, per impedire tutto questo...)", spanish="(Por eso, para evitar que tenga lugar...)"})
  else
  SkySceneKit.say({english="(That's why, to stop that from happening...)", french="(Donc, si on veut empêcher ça...)", german="(Um dies zu verhindern, gibt es nur eine\nMöglichkeit...)", italian="(Quindi, per impedire tutto questo...)", spanish="(Por eso, para evitar que tenga lugar...)"})
  end
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(We have to get back to the past!)", french="(... on doit retourner dans le passé!)", german="(Wir müssen wieder in die Vergangenheit!)", italian="(... dobbiamo tornare nel passato!)", spanish="(¡Tenemos que regresar al pasado!)"})
  else
  SkySceneKit.say({english="(We have to get back to the past!)", french="(... on doit retourner dans le passé!)", german="(Wir müssen wieder in die Vergangenheit!)", italian="(... dobbiamo tornare nel passato!)", spanish="(¡Tenemos que regresar al pasado!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(We have to get back![K] Back to our world!)", french="(Il faut qu'on rentre![K] Qu'on rentre chez nous!)", german="(Wir müssen zurück![K] Zurück in unsere Zeit!)", italian="(Dobbiamo tornare indietro![K] Nel nostro\nmondo!)", spanish="(¡Debemos volver![K]\n¡Regresar a nuestro mundo!)"})
  else
  SkySceneKit.say({english="(We have to get back![K] Back to our world!)", french="(Il faut qu'on rentre![K] Qu'on rentre chez nous!)", german="(Wir müssen zurück![K] Zurück in unsere Zeit!)", italian="(Dobbiamo tornare indietro![K] Nel nostro\nmondo!)", spanish="(¡Debemos volver![K]\n¡Regresar a nuestro mundo!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 208, 396, false, 2)
  GAME:WaitFrames(45)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(80)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [hero]...", french=" [hero]...", german=" [hero]...", italian=" [hero]...", spanish=" [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [hero]...", french=" [hero]...", german=" [hero]...", italian=" [hero]...", spanish=" [hero]..."})
  else
  SkySceneKit.say({english=" [hero]...", french=" [hero]...", german=" [hero]...", italian=" [hero]...", spanish=" [hero]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup...[K] I know...", french=" Ouaip...[K] je sais...", german=" Ja...[K] Ich weiß...", italian=" Sì...[K] lo so...", spanish=" Sí...[K] Ya lo sé..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes...[K] I know...", french=" Ouaip...[K] je sais...", german=" Ja...[K] Ich weiß...", italian=" Sì...[K] lo so...", spanish=" Sí...[K] Ya lo sé..."})
  else
  SkySceneKit.say({english=" Yep...[K] I know...", french=" Ouaip...[K] je sais...", german=" Ja...[K] Ich weiß...", italian=" Sì...[K] lo so...", spanish=" Sí...[K] Ya lo sé..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What [CS:N]Grovyle[CR] said...[K] [CS:N]Grovyle[CR] is\nright...", french=" [CS:N]Massko[CR]...[K] Il a raison...", german="Was [CS:N]Reptain[CR] gesagt hat...[K]\n[CS:N]Reptain[CR] hat recht...", italian="Quello che ha detto [CS:N]Grovyle[CR]...[K]\n[CS:N]Grovyle[CR] ha ragione...", spanish="Lo que dijo [CS:N]Grovyle[CR]...[K]\n[CS:N]Grovyle[CR] tiene razón..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What [CS:N]Grovyle[CR] said...[K] [CS:N]Grovyle[CR] is\nright...", french=" [CS:N]Massko[CR]...[K] Il a raison...", german="Was [CS:N]Reptain[CR] gesagt hat...[K]\n[CS:N]Reptain[CR] hat recht...", italian="Quello che ha detto [CS:N]Grovyle[CR]...[K]\n[CS:N]Grovyle[CR] ha ragione...", spanish="Lo que dijo [CS:N]Grovyle[CR]...[K]\n[CS:N]Grovyle[CR] tiene razón..."})
  else
  SkySceneKit.say({english="What [CS:N]Grovyle[CR] said...[K] [CS:N]Grovyle[CR] is\nright...", french=" [CS:N]Massko[CR]...[K] Il a raison...", german="Was [CS:N]Reptain[CR] gesagt hat...[K]\n[CS:N]Reptain[CR] hat recht...", italian="Quello che ha detto [CS:N]Grovyle[CR]...[K]\n[CS:N]Grovyle[CR] ha ragione...", spanish="Lo que dijo [CS:N]Grovyle[CR]...[K]\n[CS:N]Grovyle[CR] tiene razón..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Things are very tough now...[K]\nThat's why we have to be strong.", french="C'est un de ces moments\ndifficiles...[K] où il faut se montrer résolu.", german="Es kommen harte Zeiten...[K]\nDarum müssen wir jetzt stark sein.", italian="È una dura realtà...[K] È per\nquesto che dobbiamo essere forti.", spanish="Todo se ha complicado mucho...[K]\nPor eso debemos ser fuertes."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Things are very tough now...[K]\nThat's why we have to be strong.", french="C'est un de ces moments\ndifficiles...[K] où il faut se montrer résolu.", german="Es kommen harte Zeiten...[K]\nDarum müssen wir jetzt stark sein.", italian="È una dura realtà...[K] È per\nquesto che dobbiamo essere forti.", spanish="Todo se ha complicado mucho...[K]\nPor eso debemos ser fuertes."})
  else
  SkySceneKit.say({english="Things are very tough now...[K]\nThat's why we have to be strong.", french="C'est un de ces moments\ndifficiles...[K] où il faut se montrer résolu.", german="Es kommen harte Zeiten...[K]\nDarum müssen wir jetzt stark sein.", italian="È una dura realtà...[K] È per\nquesto che dobbiamo essere forti.", spanish="Todo se ha complicado mucho...[K]\nPor eso debemos ser fuertes."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(45)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'm all right now...[K] Let's go.", french=" C'est décidé...[K] On y va.", german=" Ich bin in Ordnung.[K] Gehen wir.", italian=" E va bene...[K] Andiamo.", spanish=" De acuerdo...[K] Vámonos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I'm all right now...[K] Let's go.", french=" C'est décidé...[K] On y va.", german=" Ich bin in Ordnung.[K] Gehen wir.", italian=" E va bene...[K] Andiamo.", spanish=" Ya estoy bien...[K] Vámonos."})
  else
  SkySceneKit.say({english=" I'm all right now...[K] Let's go.", french=" C'est décidé...[K] On y va.", german=" Ich bin in Ordnung.[K] Gehen wir.", italian=" E va bene...[K] Andiamo.", spanish=" Ya estoy bien...[K] Vámonos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's catch up to [CS:N]Grovyle[CR].", french=" Rattrapons [CS:N]Massko[CR].", german=" Holen wir [CS:N]Reptain[CR] ein.", italian=" Raggiungiamo [CS:N]Grovyle[CR].", spanish=" Alcancemos a [CS:N]Grovyle[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's catch up to [CS:N]Grovyle[CR].", french=" Rattrapons [CS:N]Massko[CR].", german=" Holen wir [CS:N]Reptain[CR] ein.", italian=" Raggiungiamo [CS:N]Grovyle[CR].", spanish=" Alcancemos a [CS:N]Grovyle[CR]."})
  else
  SkySceneKit.say({english=" Let's catch up to [CS:N]Grovyle[CR].", french=" Rattrapons [CS:N]Massko[CR].", german=" Holen wir [CS:N]Reptain[CR] ein.", italian=" Raggiungiamo [CS:N]Grovyle[CR].", spanish=" Alcancemos a [CS:N]Grovyle[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(24), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [hero].", french=" [hero].", german=" [hero].", italian=" [hero].", spanish=" [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [hero].", french=" [hero].", german=" [hero].", italian=" [hero].", spanish=" [hero]..."})
  else
  SkySceneKit.say({english=" [hero].", french=" [hero].", german=" [hero].", italian=" [hero].", spanish=" [hero]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to...[K] We have to\nget back!", french=" Il faut...[K] il faut qu'on rentre!", german="Wir müssen...[K] Wir müssen\nwieder zurück!", italian="Dobbiamo...[K] Dobbiamo tornare\nindietro!", spanish="Tenemos que...[K]\n¡Tenemos que regresar!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to...[K] We have to\nget back!", french=" Il faut...[K] il faut qu'on rentre!", german="Wir müssen...[K] Wir müssen\nwieder zurück!", italian="Dobbiamo...[K] Dobbiamo tornare\nindietro!", spanish="Tenemos que...[K]\n¡Tenemos que regresar!"})
  else
  SkySceneKit.say({english="We have to...[K] We have to\nget back!", french=" Il faut...[K] il faut qu'on rentre!", german="Wir müssen...[K] Wir müssen\nwieder zurück!", italian="Dobbiamo...[K] Dobbiamo tornare\nindietro!", spanish="Tenemos que...[K]\n¡Tenemos que regresar!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Back to our own world!", french=" Qu'on rentre dans notre monde!", german=" Zurück in unsere Zeit!", italian=" Nel nostro mondo!", spanish="¡Hay que volver a nuestro\nmundo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Back to our own world!", french=" Qu'on rentre dans notre monde!", german=" Zurück in unsere Zeit!", italian=" Nel nostro mondo!", spanish="¡Hay que volver a nuestro\nmundo!"})
  else
  SkySceneKit.say({english=" Back to our own world!", french=" Qu'on rentre dans notre monde!", german=" Zurück in unsere Zeit!", italian=" Nel nostro mondo!", spanish="¡Hay que volver a nuestro\nmundo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(160), p.Y+(0), false, 2) end
  GAME:WaitFrames(45)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(160), p.Y+(0), false, 2) end
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(180) end)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(30)
  SkyProg.set(20, 0) -- $SCENARIO_MAIN = scn[20,0] (ROM)
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
