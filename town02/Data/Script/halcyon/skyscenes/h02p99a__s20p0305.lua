-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s20p0305.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v24p08a", 15, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I was told I was somehow connected to the\ndistortion of space.)", french="(On m'a dit que c'était lié\nà la distorsion de l'espace.)", german="(Mir wurde gesagt, dass ich irgendetwas mit\nder Verzerrung des Raumes zu tun hätte.)", italian="(Mi è stato detto che in qualche modo ho\na che fare con la distorsione dello spazio.)", spanish="(Si no recuerdo mal, no podía evolucionar\nporque estaba relacionado, de algún modo,\ncon la deformación del espacio.)"})
  else
  SkySceneKit.say({english="(I was told I was somehow connected to the\ndistortion of space.)", french="(On m'a dit que c'était lié\nà la distorsion de l'espace.)", german="(Mir wurde gesagt, dass ich irgendetwas mit\nder Verzerrung des Raumes zu tun hätte.)", italian="(Mi è stato detto che in qualche modo ho\na che fare con la distorsione dello spazio.)", spanish="(Si no recuerdo mal, no podía evolucionar\nporque estaba relacionada, de algún modo,\ncon la deformación del espacio.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I heard that at [CS:P]Luminous Spring[CR].)", french="(C'est à la [CS:P]Source Lumineuse[CR] que j'ai\nentendu ça.)", german="(Das habe ich bei der [CS:P]Glitzerquelle[CR] gehört.)", italian="(L'ho sentito alla [CS:P]Sorgente Luccichio[CR].)", spanish="(Eso fue en el [CS:P]Manantial Luminoso[CR].)"})
  else
  SkySceneKit.say({english="(I heard that at [CS:P]Luminous Spring[CR].)", french="(C'est à la [CS:P]Source Lumineuse[CR] que j'ai\nentendu ça.)", german="(Das habe ich bei der [CS:P]Glitzerquelle[CR] gehört.)", italian="(L'ho sentito alla [CS:P]Sorgente Luccichio[CR].)", spanish="(Eso fue en el [CS:P]Manantial Luminoso[CR].)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(In that case...[K] What I heard about my\nexistence ruining the world...", french="(Dans ce cas...[K] ce que j'ai entendu sur\nmon existence dévastant le monde...)", german="(Wenn das so ist...[K] Was ich gehört habe über\ndie Zerstörung der Welt durch meine\nExistenz...)", italian="(In tal caso...[K] ciò che ho sentito riguardo alla\nmia presenza che sta distruggendo il mondo...)", spanish="(Entonces...[K] lo que oí sobre que mi presencia\nen este mundo podría acabar con él...)"})
  else
  SkySceneKit.say({english="(In that case...[K] What I heard about my\nexistence ruining the world...)", french="(Dans ce cas...[K] ce que j'ai entendu sur\nmon existence dévastant le monde...)", german="(Wenn das so ist...[K] Was ich gehört habe über\ndie Zerstörung der Welt durch meine\nExistenz...)", italian="(In tal caso...[K] ciò che ho sentito riguardo alla\nmia presenza che sta distruggendo il mondo...)", spanish="(Entonces...[K] lo que oí sobre que mi presencia\nen este mundo podría acabar con él...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Maybe...[K] Maybe it's true.)", french="(Peut-être...[K] peut-être que c'est vrai.)", german="(Vielleicht...[K] Vielleicht stimmt es.)", italian="(Potrebbe...[K] Potrebbe essere vero.)", spanish="(Tal vez...[K] Tal vez sea cierto.)"})
  else
  SkySceneKit.say({english="(Maybe...[K] Maybe it's true.)", french="(Peut-être...[K] peut-être que c'est vrai.)", german="(Vielleicht...[K] Vielleicht stimmt es.)", italian="(Potrebbe...[K] Potrebbe essere vero.)", spanish="(Tal vez...[K] Tal vez sea cierto.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Merely by existing here, I might cause the\nworld's destruction.)", french="(Peut-être que ma simple présence ici peut\ncauser la destruction du monde.)", german="(Vielleicht steht durch meine bloße Existenz\ndie Welt vor ihrer Zerstörung.)", italian="(La mia esistenza qui potrebbe causare la\ndistruzione del mondo.)", spanish="(Podría causar la destrucción de este mundo\ntan solo por mi existencia.)"})
  else
  SkySceneKit.say({english="(Merely by existing here, I might cause the\nworld's destruction.)", french="(Peut-être que ma simple présence ici peut\ncauser la destruction du monde.)", german="(Vielleicht steht durch meine bloße Existenz\ndie Welt vor ihrer Zerstörung.)", italian="(La mia esistenza qui potrebbe causare la\ndistruzione del mondo.)", spanish="(Podría causar la destrucción de este mundo\ntan solo por mi existencia.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Is that what I am here...?)", french="(Est-ce que c'est pour cela que je suis là...?)", german="(Liegt es wirklich an mir?)", italian="(Io sto causando tutto questo..?)", spanish="(¿Es eso lo que soy aquí? ¿Un peligro?)"})
  else
  SkySceneKit.say({english="(Is that what I am here...?)", french="(Est-ce que c'est pour cela que je suis là...?)", german="(Liegt es wirklich an mir?)", italian="(Io sto causando tutto questo..?)", spanish="(¿Es eso lo que soy aquí? ¿Un peligro?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(36), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Why are you daydreaming?[K]\nIt's not like you, [hero].", french="Tu es ailleurs ou quoi?[K]\nÇa ne te ressemble pas, [hero].", german="Warum bist du so\ngedankenverloren?[K] Das kenne ich gar nicht\nvon dir, [hero].", italian="Stai sognando a occhi aperti?[K]\nNon è da te, [hero].", spanish="¿Qué haces mirando a las\nmusarañas?[K] No es propio de ti, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Why are you daydreaming?[K]\nIt's not like you, [hero].", french="Tu es ailleurs ou quoi?[K]\nÇa ne te ressemble pas, [hero].", german="Warum bist du so\ngedankenverloren?[K] Das kenne ich gar nicht\nvon dir, [hero].", italian="Stai sognando a occhi aperti?[K]\nNon è da te, [hero].", spanish="¿Qué haces mirando a las\nmusarañas?[K] No es propio de ti, [hero]."})
  else
  SkySceneKit.say({english="Why are you daydreaming?[K]\nIt's not like you, [hero].", french="Tu es ailleurs ou quoi?[K]\nÇa ne te ressemble pas, [hero].", german="Warum bist du so\ngedankenverloren?[K] Das kenne ich gar nicht\nvon dir, [hero].", italian="Stai sognando a occhi aperti?[K]\nNon è da te, [hero].", spanish="¿Qué haces mirando a las\nmusarañas?[K] No es propio de ti, [hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Come on, let's see some energy,\n[hero]!", french="Allons, un peu d'entrain,\n[hero]!", german="Komm schon, zeig etwas Elan,\n[hero]!", italian="Forza, mettici un po' di energia,\n[hero]!", spanish="Venga, ¡un poco de energía,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Come on, let's see some energy,\n[hero]!", french="Allons, un peu d'entrain,\n[hero]!", german="Komm schon, zeig etwas Elan,\n[hero]!", italian="Forza, mettici un po' di energia,\n[hero]!", spanish="Venga, ¡un poco de energía,\n[hero]!"})
  else
  SkySceneKit.say({english="Come on, let's see some energy,\n[hero]!", french="Allons, un peu d'entrain,\n[hero]!", german="Komm schon, zeig etwas Elan,\n[hero]!", italian="Forza, mettici un po' di energia,\n[hero]!", spanish="Venga, ¡un poco de energía,\n[hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner]'s even peppier than usual.)", french="([partner] montre encore plus de vivacité\nque d'habitude.)", german="([partner] ist sogar noch schwungvoller\nals gewöhnlich.)", italian="([partner] è più vivace del solito.)", spanish="(Qué vitalidad la de [partner].)"})
  else
  SkySceneKit.say({english="([partner]'s even peppier than usual.)", french="([partner] montre encore plus de vivacité\nque d'habitude.)", german="([partner] ist sogar noch schwungvoller\nals gewöhnlich.)", italian="([partner] è più vivace del solito.)", spanish="(Qué vitalidad la de [partner].)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But...[K][partner] could be right.)", french="(Mais...[K] [partner] a sûrement raison.)", german="(Aber...[K] [partner] könnte recht haben.)", italian="(Ma...[K] [partner] forse ha ragione.)", spanish="(Aunque...[K] [partner] tal vez tenga razón.)"})
  else
  SkySceneKit.say({english="(But...[K][partner] could be right.)", french="(Mais...[K] [partner] a sûrement raison.)", german="(Aber...[K] [partner] könnte recht haben.)", italian="(Ma...[K] [partner] forse ha ragione.)", spanish="(Aunque...[K] [partner] tal vez tenga razón.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's not for sure that I'm going to destroy\nthe world!)", french="(Je ne vais peut-être pas détruire le monde,\naprès tout!)", german="(Es ist nicht sicher, dass ich die Welt\nzerstören werde!)", italian="(Non è scontato che io distruggerò il\nmondo!)", spanish="(¡No es seguro que vaya a destruir\nel mundo!)"})
  else
  SkySceneKit.say({english="(It's not for sure that I'm going to destroy\nthe world!)", french="(Je ne vais peut-être pas détruire le monde,\naprès tout!)", german="(Es ist nicht sicher, dass ich die Welt\nzerstören werde!)", italian="(Non è scontato che io distruggerò il\nmondo!)", spanish="(¡No es seguro que vaya a destruir\nel mundo!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(There's no point feeling sorry for myself.)", french="(Ça ne sert à rien de s'apitoyer.)", german="(Selbstmitleid hilft ja auch nicht weiter.)", italian="(Non ha senso essere tristi.)", spanish="(Y no sirve de nada quedarme aquí\nlamentándome.)"})
  else
  SkySceneKit.say({english="(There's no point feeling sorry for myself.)", french="(Ça ne sert à rien de s'apitoyer.)", german="(Selbstmitleid hilft ja auch nicht weiter.)", italian="(Non ha senso essere tristi.)", spanish="(Y no sirve de nada quedarme aquí\nlamentándome.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I gotta cheer up!)", french="(Je dois remonter la pente!)", german="(Ich muss mich aufrappeln!)", italian="(Devo tirarmi su!)", spanish="(¡Tengo que animarme!)"})
  else
  SkySceneKit.say({english="(I gotta cheer up!)", french="(Je dois remonter la pente!)", german="(Ich muss mich aufrappeln!)", italian="(Devo tirarmi su!)", spanish="(¡Tengo que animarme!)"})
  end
  -- message_Close
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(120) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yup![K] That's the [hero]\nI know!", french="Oui![K] Ça, ça te ressemble plus,\n[hero]!", german="Genau![K] So kenne ich dich,\n[hero]!", italian="Sì![K] Adesso ti riconosco,\n[hero]!", spanish="¡Sí![K]\n¡Así se hace, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yes![K] That's the [hero]\nI know!", french="Oui![K] Ça, ça te ressemble plus,\n[hero]!", german="Ja![K] So kenne ich dich,\n[hero]!", italian="Sì![K] Adesso ti riconosco,\n[hero]!", spanish="¡Sí![K]\n¡Así se hace, [hero]!"})
  else
  SkySceneKit.say({english="Yep![K] That's the [hero]\nI know!", french="Oui![K] Ça, ça te ressemble plus,\n[hero]!", german="Genau![K] So kenne ich dich,\n[hero]!", italian="Sì![K] Adesso ti riconosco,\n[hero]!", spanish="¡Sí![K]\n¡Así se hace, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's make this another big day,\n[hero]!", french="C'est parti pour une nouvelle\njournée magnifique, [hero]!", german="Machen wir auch diesen Tag zu\netwas Besonderem, [hero]!", italian="Facciamo anche oggi del nostro\nmeglio, [hero]!", spanish="¡Seguro que hoy será un\ngran día, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's make this another big day,\n[hero]!", french="C'est parti pour une nouvelle\njournée magnifique, [hero]!", german="Machen wir auch diesen Tag zu\netwas Besonderem, [hero]!", italian="Facciamo anche oggi del nostro\nmeglio, [hero]!", spanish="¡Seguro que hoy será un\ngran día, [hero]!"})
  else
  SkySceneKit.say({english="Let's make this another big day,\n[hero]!", french="C'est parti pour une nouvelle\njournée magnifique, [hero]!", german="Machen wir auch diesen Tag zu\netwas Besonderem, [hero]!", italian="Facciamo anche oggi del nostro\nmeglio, [hero]!", spanish="¡Seguro que hoy será un\ngran día, [hero]!"})
  end
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: BGM BGM_DO_YOUR_BEST_AS_ALWAYS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
