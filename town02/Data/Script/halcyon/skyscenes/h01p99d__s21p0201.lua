-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99D/s21p0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  SkyProg.set(29, 79) -- $SCENARIO_MAIN = scn[29,79] (ROM)
  -- back_SetGround(LEVEL_H01P99D) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(10)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(24), p.Y+(0), false, 2) end
  GAME:WaitFrames(60)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(45)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(16), false, 2) end
  GROUND:MoveToPosition(hero, 236, 172, false, 2)
  GROUND:MoveToPosition(hero, 228, 164, false, 2)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So, [hero]...[K] You're awake\ntoo, huh?", french="Alors, [hero]...[K] Toi non\nplus, tu n'arrives pas à dormir, hein?", german="Na, [hero]...[K]\nDu bist auch schon wach, was?", italian="[hero]...[K] Anche tu sei\ngià in piedi, eh?", spanish="[hero]...[K] Así que tú\ntambién te has despertado ya, ¿no?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So, [hero]...[K] You're awake\ntoo, huh?", french="Alors, [hero]...[K] Toi non\nplus, tu n'arrives pas à dormir, hein?", german="Na, [hero]...[K]\nDu bist auch schon wach, was?", italian="[hero]...[K] Anche tu sei\ngià in piedi, eh?", spanish="Vaya, [hero]...[K] También te\nhas despertado ya, ¿no?"})
  else
  SkySceneKit.say({english="So, [hero]...[K] You're awake\ntoo, huh?", french="Alors, [hero]...[K] Toi non\nplus, tu n'arrives pas à dormir, hein?", german="Na, [hero]...[K]\nDu bist auch schon wach, was?", italian="[hero]...[K] Anche tu sei\ngià in piedi, eh?", spanish="Vaya, [hero]...[K] También te\nhas despertado ya, ¿no?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I couldn't sleep at all...", french="Je n'ai pas fermé l'œil de\nla nuit...", german=" Ich habe kein Auge zugemacht...", italian="Non sono proprio\nriuscito a dormire...", spanish=" No podía dormir..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I couldn't sleep at all...", french="Je n'ai pas fermé l'œil de\nla nuit...", german=" Ich habe kein Auge zugemacht...", italian="Non sono proprio\nriuscito a dormire...", spanish=" No podía dormir..."})
  else
  SkySceneKit.say({english=" I couldn't sleep at all...", french="Je n'ai pas fermé l'œil de\nla nuit...", german=" Ich habe kein Auge zugemacht...", italian="Non sono proprio\nriuscita a dormire...", spanish=" No podía dormir..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- bgm2_ChangeVolume(90, 190) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  pcall(function() SOUND:PlayBGM("Hidden Land.ogg", true) end)
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[K]Hey, [hero].", french=" ...[K] Dis, [hero].", german=" ...[K]Hey, [hero].", italian=" ...[K] Ehi, [hero].", spanish=" Oye...[K] [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[K]Hey, [hero].", french=" ...[K] Dis, [hero].", german=" ...[K]Hey, [hero].", italian=" ...[K] Ehi, [hero].", spanish=" Oye...[K] [hero]..."})
  else
  SkySceneKit.say({english=" ...[K]Hey, [hero].", french=" ...[K] Dis, [hero].", german=" ...[K]Hey, [hero].", italian=" ...[K] Ehi, [hero].", spanish=" Oye...[K] [hero]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Can't we be allowed to stay?", french="Tu ne crois pas qu'on pourrait\nnous permettre de rester?", german="Dürfen wir wirklich nicht\nhierbleiben?", italian=" Non possiamo rimanere?", spanish=" ¿Por qué no podemos quedarnos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Can't we be allowed to stay?", french="Tu ne crois pas qu'on pourrait\nnous permettre de rester?", german="Dürfen wir wirklich nicht\nhierbleiben?", italian=" Non possiamo rimanere?", spanish=" ¿Por qué no podemos quedarnos?"})
  else
  SkySceneKit.say({english=" Can't we be allowed to stay?", french="Tu ne crois pas qu'on pourrait\nnous permettre de rester?", german="Dürfen wir wirklich nicht\nhierbleiben?", italian=" Non possiamo rimanere?", spanish=" ¿Por qué no podemos quedarnos?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Can't we stay in this world?", french=" De rester dans ce monde?", german="Können wir nicht in dieser Welt\nbleiben?", italian="Non possiamo rimanere\nin questo mondo?", spanish="¿Por qué no podemos quedarnos\nen este mundo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Can't we stay in this world?", french=" De rester dans ce monde?", german="Können wir nicht in dieser Welt\nbleiben?", italian="Non possiamo rimanere\nin questo mondo?", spanish="¿Por qué no podemos quedarnos\nen este mundo?"})
  else
  SkySceneKit.say({english=" Can't we stay in this world?", french=" De rester dans ce monde?", german="Können wir nicht in dieser Welt\nbleiben?", italian="Non possiamo rimanere\nin questo mondo?", spanish="¿Por qué no podemos quedarnos\nen este mundo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...[K]When we fought [CS:N]Dialga[CR] at\n[CS:P]Temporal Tower[CR]...", french="...[K] Quand nous avons affronté\n[CS:N]Dialga[CR] dans la [CS:P]Tour du Temps[CR]...", german="...[K]Als wir [CS:N]Dialga[CR] im\n[CS:P]Zeitturm[CR] bekämpften...", italian="...[K] Quando abbiamo affrontato\n[CS:N]Dialga[CR] alla [CS:P]Torre del Tempo[CR]...", spanish="Cuando...[K] Cuando luchamos contra\n[CS:N]Dialga[CR] en la [CS:P]Torre del Tiempo[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...[K]When we fought [CS:N]Dialga[CR] at\n[CS:P]Temporal Tower[CR]...", french="...[K] Quand nous avons affronté\n[CS:N]Dialga[CR] dans la [CS:P]Tour du Temps[CR]...", german="...[K]Als wir [CS:N]Dialga[CR] im\n[CS:P]Zeitturm[CR] bekämpften...", italian="...[K] Quando abbiamo affrontato\n[CS:N]Dialga[CR] alla [CS:P]Torre del Tempo[CR]...", spanish="Cuando...[K] Cuando luchamos contra\n[CS:N]Dialga[CR] en la [CS:P]Torre del Tiempo[CR]..."})
  else
  SkySceneKit.say({english="...[K]When we fought [CS:N]Dialga[CR] at\n[CS:P]Temporal Tower[CR]...", french="...[K] Quand nous avons affronté\n[CS:N]Dialga[CR] dans la [CS:P]Tour du Temps[CR]...", german="...[K]Als wir [CS:N]Dialga[CR] im\n[CS:P]Zeitturm[CR] bekämpften...", italian="...[K] Quando abbiamo affrontato\n[CS:N]Dialga[CR] alla [CS:P]Torre del Tempo[CR]...", spanish="Cuando...[K] Cuando luchamos contra\n[CS:N]Dialga[CR] en la [CS:P]Torre del Tiempo[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You fought even though you knew\nthat you would disappear, [hero].", french="... même en sachant que tu\ndisparaîtrais, tu as continué à te battre,\n[hero].", german="Du hast gekämpft, obwohl du\nwusstest, dass du verschwinden würdest,\n[hero].", italian="Hai lottato anche se sapevi\nche dovevi scomparire, [hero].", spanish="Lo hiciste aunque sabías que\nibas a desaparecer, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You fought even though you knew\nthat you would disappear, [hero].", french="... même en sachant que tu\ndisparaîtrais, tu as continué à te battre,\n[hero].", german="Du hast gekämpft, obwohl du\nwusstest, dass du verschwinden würdest,\n[hero].", italian="Hai lottato anche se sapevi\nche dovevi scomparire, [hero].", spanish="Lo hiciste aunque sabías que\nibas a desaparecer, [hero]."})
  else
  SkySceneKit.say({english="You fought even though you knew\nthat you would disappear, [hero].", french="... même en sachant que tu\ndisparaîtrais, tu as continué à te battre,\n[hero].", german="Du hast gekämpft, obwohl du\nwusstest, dass du verschwinden würdest,\n[hero].", italian="Hai lottato anche se sapevi\nche dovevi scomparire, [hero].", spanish="Lo hiciste aunque sabías que\nibas a desaparecer, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Because even if you were to\ndisappear...", french="Parce que même si tu\nvenais à disparaître...", german="Denn sogar wenn du\nverschwinden solltest...", italian=" Perché...", spanish=" Y todo porque..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Because even if you were to\ndisappear...", french="Parce que même si tu\nvenais à disparaître...", german="Denn sogar wenn du\nverschwinden solltest...", italian=" Perché...", spanish=" Y todo porque..."})
  else
  SkySceneKit.say({english="Because even if you were to\ndisappear...", french="Parce que même si tu\nvenais à disparaître...", german="Denn sogar wenn du\nverschwinden solltest...", italian=" Perché...", spanish=" Y todo porque..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You thought that would save the\nworld...[K] That's why you did it, right?", french="... tu espérais sauver\nle monde...[K] C'est pour ça que tu l'as\nfait, pas vrai?", german="Du dachtest, es würde die Welt\nretten...[K] Darum hast du es getan, oder?", italian="... pensavi che avresti salvato\nil mondo...[K] È per quello che l'hai fatto, vero?", spanish="Pensabas que así podrías salvar\nel mundo...[K] ¿verdad?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You thought that would save the\nworld...[K] That's why you did it, right?", french="... tu espérais sauver\nle monde...[K] C'est pour ça que tu l'as\nfait, pas vrai?", german="Du dachtest, es würde die Welt\nretten...[K] Darum hast du es getan, oder?", italian="... pensavi che avresti salvato\nil mondo...[K] È per quello che l'hai fatto, vero?", spanish="Pensabas que así podrías salvar\nel mundo...[K] ¿verdad?"})
  else
  SkySceneKit.say({english="You thought that would save the\nworld...[K] That's why you did it, right?", french="... tu espérais sauver\nle monde...[K] C'est pour ça que tu l'as\nfait, pas vrai?", german="Du dachtest, es würde die Welt\nretten...[K] Darum hast du es getan, oder?", italian="... pensavi che avresti salvato\nil mondo...[K] È per quello che l'hai fatto, vero?", spanish="Pensabas que así podrías salvar\nel mundo...[K] ¿verdad?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If that's the case...[K] Maybe we\nshould do that this time too.", french="Dans ce cas...[K] peut-être que\nc'est aussi ce qu'on devrait faire cette fois.", german="Wenn es so ist...[K] Vielleicht\nsollten wir dann dieses Mal das Gleiche tun.", italian="Se è così...[K] forse\ndovremmo fare la stessa cosa anche questa\nvolta.", spanish="Si no hay otra opción...[K] quizás\ndebamos hacerlo de nuevo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If that's the case...[K] Maybe we\nshould do that this time too.", french="Dans ce cas...[K] peut-être que\nc'est aussi ce qu'on devrait faire cette fois.", german="Wenn es so ist...[K] Vielleicht\nsollten wir dann dieses Mal das Gleiche tun.", italian="Se è così...[K] forse\ndovremmo fare la stessa cosa anche questa\nvolta.", spanish="Si no hay otra opción...[K] quizás\ndebamos hacerlo de nuevo."})
  else
  SkySceneKit.say({english="If that's the case...[K] Maybe we\nshould do that this time too.", french="Dans ce cas...[K] peut-être que\nc'est aussi ce qu'on devrait faire cette fois.", german="Wenn es so ist...[K] Vielleicht\nsollten wir dann dieses Mal das Gleiche tun.", italian="Se è così...[K] forse\ndovremmo fare la stessa cosa anche questa\nvolta.", spanish="Si no hay otra opción...[K] quizás\ndebamos hacerlo de nuevo."})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner]...)", french="([partner]...)", german="([partner]...)", italian="([partner]...)", spanish="([partner]...)"})
  else
  SkySceneKit.say({english="([partner]...)", french="([partner]...)", german="([partner]...)", italian="([partner]...)", spanish="([partner]...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...[K]It's true that I fought [CS:N]Dialga[CR] knowing that\nI would disappear if we succeeded.)", french="(...[K] C'est vrai que j'ai affronté [CS:N]Dialga[CR]\nen sachant très bien que j'allais disparaître\nen remportant la victoire.)", german="(...[K]Ich wusste zwar, als ich gegen [CS:N]Dialga[CR]\nkämpfte, dass ich verschwinden würde, falls\nwir Erfolg hätten...)", italian="(...[K] È vero che ho affrontato [CS:N]Dialga[CR] sapendo\nche sarei sparito se avessimo vinto.)", spanish="(Eso...[K] es cierto. Luché contra [CS:N]Dialga[CR] sabiendo\nque desaparecería si vencíamos.)"})
  else
  SkySceneKit.say({english="(...[K]It's true that I fought [CS:N]Dialga[CR] knowing that\nI would disappear if we succeeded.)", french="(...[K] C'est vrai que j'ai affronté [CS:N]Dialga[CR]\nen sachant très bien que j'allais disparaître\nen remportant la victoire.)", german="(...[K]Ich wusste zwar, als ich gegen [CS:N]Dialga[CR]\nkämpfte, dass ich verschwinden würde, falls\nwir Erfolg hätten...)", italian="(...[K] È vero che ho affrontato [CS:N]Dialga[CR] sapendo\nche sarei sparita se avessimo vinto.)", spanish="(Eso...[K] es cierto. Luché contra [CS:N]Dialga[CR] sabiendo\nque desaparecería si vencíamos.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But that had to be done to prevent the planet's\nparalysis.)", french="(Mais je n'avais pas le choix si je voulais\nempêcher la Paralysie de la Planète.)", german="(Aber das musste getan werden, um die\nLähmung des Planeten zu verhindern.)", italian="(Ma era necessario per prevenire la paralisi\ndel pianeta.)", spanish="(Pero era necesario para impedir la parálisis\ndel planeta.)"})
  else
  SkySceneKit.say({english="(But that had to be done to prevent the planet's\nparalysis.)", french="(Mais je n'avais pas le choix si je voulais\nempêcher la Paralysie de la Planète.)", german="(Aber das musste getan werden, um die\nLähmung des Planeten zu verhindern.)", italian="(Ma era necessario per prevenire la paralisi\ndel pianeta.)", spanish="(Pero era necesario para impedir la parálisis\ndel planeta.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Back then, I was willing to disappear if it\nmeant saving the world.)", french="(A ce moment-là, j'étais prêt à disparaître\nsi ça permettait de sauver le monde.)", german="(Damals war ich bereit, für die Rettung der\nWelt zu verschwinden.)", italian="(All'epoca, ero pronto a scomparire, pur\ndi salvare il mondo.)", spanish="(Entonces no me importaba desaparecer si\npodía salvar el mundo.)"})
  else
  SkySceneKit.say({english="(Back then, I was willing to disappear if it\nmeant saving the world.)", french="(A ce moment-là, j'étais prête à disparaître\nsi ça permettait de sauver le monde.)", german="(Damals war ich bereit, für die Rettung der\nWelt zu verschwinden.)", italian="(All'epoca, ero pronta a scomparire, pur\ndi salvare il mondo.)", spanish="(Entonces no me importaba desaparecer si\npodía salvar el mundo.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I feel the same this time too...[K] But is this\nsituation really the same?)", french="(C'est toujours ce que je ressens aujourd'hui...[K]\nMais la situation est-elle vraiment la même?)", german="(Ich fühle jetzt genauso...[K] Aber ist die\nSituation wirklich gleich?)", italian="(Lo farei anche questa volta...[K] Ma la\nsituazione è davvero la stessa?)", spanish="(Ahora me siento igual...[K] ¿Pero es, realmente,\nla misma situación?)"})
  else
  SkySceneKit.say({english="(I feel the same this time too...[K] But is this\nsituation really the same?)", french="(C'est toujours ce que je ressens aujourd'hui...[K]\nMais la situation est-elle vraiment la même?)", german="(Ich fühle jetzt genauso...[K] Aber ist die\nSituation wirklich gleich?)", italian="(Lo farei anche questa volta...[K] Ma la\nsituazione è davvero la stessa?)", spanish="(Ahora me siento igual...[K] ¿Pero es, realmente,\nla misma situación?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But something...[K]something feels different this\ntime around.)", french="(Cette fois...[K] cette fois, il y a quelque chose\nde différent.)", german="(Irgendetwas...[K] Irgendetwas fühlt sich diesmal\nanders an.)", italian="(Questa volta...[K] Questa volta le cose\nsembrano un po' diverse.)", spanish="(Hay algo...[K] Algo parece distinto esta vez.)"})
  else
  SkySceneKit.say({english="(But something...[K]something feels different this\ntime around.)", french="(Cette fois...[K] cette fois, il y a quelque chose\nde différent.)", german="(Irgendetwas...[K] Irgendetwas fühlt sich diesmal\nanders an.)", italian="(Questa volta...[K] Questa volta le cose\nsembrano un po' diverse.)", spanish="(Hay algo...[K] Algo parece distinto esta vez.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 212, 148, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Oh, [hero]...[K] What do\nyou think?", french="Oh, [hero]...[K] A quoi\ntu penses?", german="Oh, [hero]...[K] Was meinst\ndu dazu?", italian="Oh, [hero]...[K] Cosa ne\npensi?", spanish=" [hero]...[K] ¿Tú qué opinas?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh, [hero]...[K] What do\nyou think?", french="Oh, [hero]...[K] A quoi\ntu penses?", german="Oh, [hero]...[K] Was meinst\ndu dazu?", italian="Oh, [hero]...[K] Cosa ne\npensi?", spanish=" [hero]...[K] ¿Tú qué opinas?"})
  else
  SkySceneKit.say({english="Oh, [hero]...[K] What do\nyou think?", french="Oh, [hero]...[K] A quoi\ntu penses?", german="Oh, [hero]...[K] Was meinst\ndu dazu?", italian="Oh, [hero]...[K] Cosa ne\npensi?", spanish=" [hero]...[K] ¿Tú qué opinas?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Should we really disappear from\nthis world?", french="Devons-nous vraiment\ndisparaître de ce monde?", german="Sollen wir wirklich aus dieser\nWelt verschwinden?", italian="Dovremmo davvero sparire da\nquesto mondo?", spanish="¿Deberíamos desaparecer de\neste mundo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Should we really disappear from\nthis world?", french="Devons-nous vraiment\ndisparaître de ce monde?", german="Sollen wir wirklich aus dieser\nWelt verschwinden?", italian="Dovremmo davvero sparire da\nquesto mondo?", spanish="¿Deberíamos desaparecer de\neste mundo?"})
  else
  SkySceneKit.say({english="Should we really disappear from\nthis world?", french="Devons-nous vraiment\ndisparaître de ce monde?", german="Sollen wir wirklich aus dieser\nWelt verschwinden?", italian="Dovremmo davvero sparire da\nquesto mondo?", spanish="¿Deberíamos desaparecer de\neste mundo?"})
  end
  do local __choice = SkySceneKit.ask({{english="Yes, perhaps...", french="Oui, peut-être...", german="Ja, vielleicht...", italian="Forse sì...", spanish="Tal vez..."}, {english="I don't know...", french="Je ne sais pas...", german="Ich weiß es nicht...", italian="Non lo so...", spanish="No lo sé..."}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urf...[K] You don't know...?", french=" Argh...[K] Tu ne sais pas...?", german=" Uff...[K] Du weißt es nicht?", italian=" Uff...[K] Non lo sai...?", spanish=" Glup...[K] ¿No sabes si...?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urf...[K] You don't know...?", french=" Argh...[K] Tu ne sais pas...?", german=" Uff...[K] Du weißt es nicht?", italian=" Uff...[K] Non lo sai...?", spanish=" Glup...[K] ¿No sabes si...?"})
  else
  SkySceneKit.say({english=" Urf...[K] You don't know...?", french=" Argh...[K] Tu ne sais pas...?", german=" Uff...[K] Du weißt es nicht?", italian=" Uff...[K] Non lo sai...?", spanish=" Glup...[K] ¿No sabes si...?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You must be thinking that maybe\nwe ought to disappear, [hero]...", french="Tu dois peut-être penser\nque nous ferions mieux de disparaître,\n[hero]...", german="Du denkst bestimmt, wir sollten\nverschwinden, [hero]...", italian="Stai pensando che forse\ndovremmo sparire, [hero]...", spanish="Debes de estar pensando que\ntenemos que desaparecer, [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You must be thinking that maybe\nwe ought to disappear, [hero]...", french="Tu dois peut-être penser\nque nous ferions mieux de disparaître,\n[hero]...", german="Du denkst bestimmt, wir sollten\nverschwinden, [hero]...", italian="Stai pensando che forse\ndovremmo sparire, [hero]...", spanish="Debes de estar pensando que\ntenemos que desaparecer, [hero]..."})
  else
  SkySceneKit.say({english="You must be thinking that maybe\nwe ought to disappear, [hero]...", french="Tu dois peut-être penser\nque nous ferions mieux de disparaître,\n[hero]...", german="Du denkst bestimmt, wir sollten\nverschwinden, [hero]...", italian="Stai pensando che forse\ndovremmo sparire, [hero]...", spanish="Debes de estar pensando que\ntenemos que desaparecer, [hero]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Well, then...", french=" Dans ce cas...", german=" Wenn dem so ist...", italian=" Beh, allora...", spanish=" Bueno, entonces..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Well, then...", french=" Dans ce cas...", german=" Wenn dem so ist...", italian=" Beh, allora...", spanish=" Bueno, entonces..."})
  else
  SkySceneKit.say({english=" Well, then...", french=" Dans ce cas...", german=" Wenn dem so ist...", italian=" Beh, allora...", spanish=" Bueno, entonces..."})
  end
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urf... You too...", french=" Argh... Toi aussi...", german=" Uff! Du auch...", italian=" Urf... Anche tu...", spanish=" Uf... Tú también..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urf... You too...", french=" Argh... Toi aussi...", german=" Uff! Du auch...", italian=" Urf... Anche tu...", spanish=" Uf... Tú también..."})
  else
  SkySceneKit.say({english=" Urf... You too...", french=" Argh... Toi aussi...", german=" Uff! Du auch...", italian=" Urf... Anche tu...", spanish=" Uf... Tú también..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You think so too, [hero]...", french="Toi aussi, tu penses la même\nchose, [hero]...", german="Auch du denkst so,\n[hero]...", italian="Anche tu la pensi\ncosì, [hero]...", spanish="Tú también lo crees,\n[hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You think so too, [hero]...", french="Toi aussi, tu penses la même\nchose, [hero]...", german="Auch du denkst so,\n[hero]...", italian="Anche tu la pensi\ncosì, [hero]...", spanish="Tú también lo crees,\n[hero]..."})
  else
  SkySceneKit.say({english=" You think so too, [hero]...", french="Toi aussi, tu penses la même\nchose, [hero]...", german="Auch du denkst so,\n[hero]...", italian="Anche tu la pensi\ncosì, [hero]...", spanish="Tú también lo crees,\n[hero]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Well, then...", french=" Dans ce cas...", german=" Nun denn...", italian=" Beh, allora...", spanish=" Entonces..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Well, then...", french=" Dans ce cas...", german=" Nun denn...", italian=" Beh, allora...", spanish=" Entonces..."})
  else
  SkySceneKit.say({english=" Well, then...", french=" Dans ce cas...", german=" Nun denn...", italian=" Beh, allora...", spanish=" Entonces..."})
  end
  -- @label_2 [étiquette de flux ExplorerScript]
  do local __choice = SkySceneKit.ask({{english="But something's weird...", french="Mais quelque chose cloche...", german="Aber irgendwas ist seltsam...", italian="C'è qualcosa che non torna...", spanish="Pero hay algo raro..."}, {english="But something's strange...", french="C'est bizarre, non?", german="Aber irgendwas ist komisch...", italian="Ma c'è qualcosa di strano...", spanish="Pero hay algo extraño..."}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Strange?[K] What's strange?", french="Quoi donc?[K] Qu'est-ce qui est\nbizarre, à ton avis?", german=" Komisch?[K] Was ist komisch?", italian="Strano?[K] Cosa ti sembra\nstrano?", spanish="¿Extraño?[K] ¿Qué te parece\nextraño?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Strange?[K] What's strange?", french="Quoi donc?[K] Qu'est-ce qui est\nbizarre, à ton avis?", german=" Komisch?[K] Was ist komisch?", italian="Strano?[K] Cosa ti sembra\nstrano?", spanish="¿Extraño?[K] ¿Qué te parece\nextraño?"})
  else
  SkySceneKit.say({english=" Strange?[K] What's strange?", french="Quoi donc?[K] Qu'est-ce qui est\nbizarre, à ton avis?", german=" Komisch?[K] Was ist komisch?", italian="Strano?[K] Cosa ti sembra\nstrano?", spanish="¿Extraño?[K] ¿Qué te parece\nextraño?"})
  end
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Huh? You think something's\nweird?", french="Hein? Tu penses que quelque\nchose cloche?", german="Du glaubst, irgendetwas sei\nseltsam?", italian="Come? Secondo te qualcosa non\nva?", spanish="¿Qué? ¿Crees que hay algo\nextraño en todo esto?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What? You think something's\nweird?", french="Hein? Tu penses que quelque\nchose cloche?", german="Du glaubst, irgendetwas sei\nseltsam?", italian="Come? Secondo te qualcosa non\nva?", spanish="¿Qué? ¿Crees que hay algo\nextraño en todo esto?"})
  else
  SkySceneKit.say({english="What? You think something's\nweird?", french="Hein? Tu penses que quelque\nchose cloche?", german="Du glaubst, irgendetwas sei\nseltsam?", italian="Come? Secondo te qualcosa non\nva?", spanish="¿Qué? ¿Crees que hay algo\nextraño en todo esto?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What is?[K] What's weird?", french=" Quoi donc?[K] Qu'est-ce qui cloche?", german=" Was ist?[K] Was ist seltsam?", italian="Cosa?[K] Cos'è che non torna\nsecondo te?", spanish="¿El qué?[K] ¿Qué te parece tan\nraro?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What is?[K] What's weird?", french=" Quoi donc?[K] Qu'est-ce qui cloche?", german=" Was ist?[K] Was ist seltsam?", italian="Cosa?[K] Cos'è che non torna\nsecondo te?", spanish="¿El qué?[K] ¿Qué te parece tan\nraro?"})
  else
  SkySceneKit.say({english=" What is?[K] What's weird?", french=" Quoi donc?[K] Qu'est-ce qui cloche?", german=" Was ist?[K] Was ist seltsam?", italian="Cosa?[K] Cos'è che non torna\nsecondo te?", spanish="¿El qué?[K] ¿Qué te parece tan\nraro?"})
  end
  -- @label_5 [étiquette de flux ExplorerScript]
  do local __choice = SkySceneKit.ask({{english="Everything [CS:N]Cresselia[CR] said...", french="Tout ce que [CS:N]Cresselia[CR] a dit...", german="Alles, was [CS:N]Cresselia[CR] sagte...", italian="Tutto ciò che [CS:N]Cresselia[CR] ha detto...", spanish="Todo lo que dijo [CS:N]Cresselia[CR]..."}, {english="The whole space-distortion idea!", french="La distorsion de l'espace!", german="Das ganze Raumverzerrungsding!", italian="L'idea della distorsione dello spazio!", spanish="La deformación del espacio"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" The distortion of space?", french=" La distorsion de l'espace?", german=" Die Verzerrung des Raumes?", italian=" La distorsione dello spazio?", spanish=" ¿La deformación del espacio?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" The distortion of space?", french=" La distorsion de l'espace?", german=" Die Verzerrung des Raumes?", italian=" La distorsione dello spazio?", spanish=" ¿La deformación del espacio?"})
  else
  SkySceneKit.say({english=" The distortion of space?", french=" La distorsion de l'espace?", german=" Die Verzerrung des Raumes?", italian=" La distorsione dello spazio?", spanish=" ¿La deformación del espacio?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hmm...[K] I don't truly understand\nthe whole idea of space distortion.", french="Hum...[K] Pour être franc,\nje ne comprends pas bien cette histoire de\ndistorsion de l'espace non plus.", german="Hmm...[K] Ich verstehe diese ganze\nIdee mit der Verzerrung des Raumes nicht\nwirklich.", italian="Mmm...[K] Davvero non capisco la\nstoria della distorsione dello spazio.", spanish="Hum...[K] No acabo de entender\nla idea de la deformación del espacio."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hmm...[K] I don't truly understand\nthe whole idea of space distortion.", french="Hum...[K] Pour être franc,\nje ne comprends pas bien cette histoire de\ndistorsion de l'espace non plus.", german="Hmm...[K] Ich verstehe diese ganze\nIdee mit der Verzerrung des Raumes nicht\nwirklich.", italian="Mmm...[K] Davvero non capisco la\nstoria della distorsione dello spazio.", spanish="Hum...[K] No acabo de entender\nla idea de la deformación del espacio."})
  else
  SkySceneKit.say({english="Hmm...[K] I don't truly understand\nthe whole idea of space distortion.", french="Hum...[K] Pour être franche,\nje ne comprends pas bien cette histoire de\ndistorsion de l'espace non plus.", german="Hmm...[K] Ich verstehe diese ganze\nIdee mit der Verzerrung des Raumes nicht\nwirklich.", italian="Mmm...[K] Davvero non capisco la\nstoria della distorsione dello spazio.", spanish="Hum...[K] No acabo de entender\nla idea de la deformación del espacio."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But we were told that we were\ncausing the distortion...", french="Mais on nous avait déjà dit\nque c'était nous, la cause de cette distorsion...", german="Aber uns wurde gesagt, dass wir\ndie Verzerrung verursachen würden...", italian="Ci hanno detto che stiamo\ncausando la distorsione...", spanish="Aunque nos dijeron que la\nestábamos causando..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But we were told that we were\ncausing the distortion...", french="Mais on nous avait déjà dit\nque c'était nous, la cause de cette distorsion...", german="Aber uns wurde gesagt, dass wir\ndie Verzerrung verursachen würden...", italian="Ci hanno detto che stiamo\ncausando la distorsione...", spanish="Aunque nos dijeron que la\nestábamos causando..."})
  else
  SkySceneKit.say({english="But we were told that we were\ncausing the distortion...", french="Mais on nous avait déjà dit\nque c'était nous, la cause de cette distorsion...", german="Aber uns wurde gesagt, dass wir\ndie Verzerrung verursachen würden...", italian="Ci hanno detto che stiamo\ncausando la distorsione...", spanish="Aunque nos dijeron que la\nestábamos causando..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We got told that at [CS:P]Luminous\nSpring[CR].", french="C'est la [CS:P]Source Lumineuse[CR]\nqui nous l'a révélé.", german="Das wurde uns bei der\n[CS:P]Glitzerquelle[CR] gesagt.", italian="Lo abbiamo sentito alla [CS:P]Sorgente\nLuccichio[CR].", spanish=" Sí, en el [CS:P]Manantial Luminoso[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We were told that at [CS:P]Luminous\nSpring[CR].", french="C'est la [CS:P]Source Lumineuse[CR]\nqui nous l'a révélé.", german="Das wurde uns bei der\n[CS:P]Glitzerquelle[CR] gesagt.", italian="Lo abbiamo sentito alla [CS:P]Sorgente\nLuccichio[CR].", spanish=" Sí, en el [CS:P]Manantial Luminoso[CR]..."})
  else
  SkySceneKit.say({english="We were told that at [CS:P]Luminous\nSpring[CR].", french="C'est la [CS:P]Source Lumineuse[CR]\nqui nous l'a révélé.", german="Das wurde uns bei der\n[CS:P]Glitzerquelle[CR] gesagt.", italian="Lo abbiamo sentito alla [CS:P]Sorgente\nLuccichio[CR].", spanish=" Sí, en el [CS:P]Manantial Luminoso[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="When you think about that, we\nhave to accept that this space distortion is\nreally happening!", french="A partir de là, on doit bien\naccepter que la distorsion de l'espace est\nréelle!", german="Wenn du darüber nachdenkst,\nmusst du einsehen, dass diese Raumverzerrung\nwirklich real ist!", italian="A pensarci bene, dobbiamo\naccettare che la distorsione dello spazio\nsia reale!", spanish="Y, si lo piensas bien, no podemos\nnegar que la deformación del espacio está\nocurriendo realmente..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="When you think about that, we\nhave to accept that this space distortion is\nreally happening!", french="A partir de là, on doit bien\naccepter que la distorsion de l'espace est\nréelle!", german="Wenn du darüber nachdenkst,\nmusst du einsehen, dass diese Raumverzerrung\nwirklich real ist!", italian="A pensarci bene, dobbiamo\naccettare che la distorsione dello spazio\nsia reale!", spanish="Y, si lo piensas bien, no podemos\nnegar que la deformación del espacio está\nocurriendo realmente..."})
  else
  SkySceneKit.say({english="When you think about that, we\nhave to accept that this space distortion is\nreally happening!", french="A partir de là, on doit bien\naccepter que la distorsion de l'espace est\nréelle!", german="Wenn du darüber nachdenkst,\nmusst du einsehen, dass diese Raumverzerrung\nwirklich real ist!", italian="A pensarci bene, dobbiamo\naccettare che la distorsione dello spazio\nsia reale!", spanish="Y, si lo piensas bien, no podemos\nnegar que la deformación del espacio está\nocurriendo realmente..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_8 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What exactly was odd about\nwhat [CS:N]Cresselia[CR] said?", french="Pourquoi tu penses qu'il y a\nquelque chose qui cloche dans ce que [CS:N]Cresselia[CR]\na dit?", german="Was genau war sonderbar an\ndem, was [CS:N]Cresselia[CR] sagte?", italian="Cosa c'è di strano in ciò che\n[CS:N]Cresselia[CR] ha detto?", spanish="¿Qué te parece tan extraño de\nlo que dijo [CS:N]Cresselia[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What exactly was odd about\nwhat [CS:N]Cresselia[CR] said?", french="Pourquoi tu penses qu'il y a\nquelque chose qui cloche dans ce que [CS:N]Cresselia[CR]\na dit?", german="Was genau war sonderbar an\ndem, was [CS:N]Cresselia[CR] sagte?", italian="Cosa c'è di strano in ciò che\n[CS:N]Cresselia[CR] ha detto?", spanish="¿Qué te parece tan extraño de\nlo que dijo [CS:N]Cresselia[CR]?"})
  else
  SkySceneKit.say({english="What exactly was odd about\nwhat [CS:N]Cresselia[CR] said?", french="Pourquoi tu penses qu'il y a\nquelque chose qui cloche dans ce que [CS:N]Cresselia[CR]\na dit?", german="Was genau war sonderbar an\ndem, was [CS:N]Cresselia[CR] sagte?", italian="Cosa c'è di strano in ciò che\n[CS:N]Cresselia[CR] ha detto?", spanish="¿Qué te parece tan extraño de\nlo que dijo [CS:N]Cresselia[CR]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But we separately found out that\nwe are causing the space distortion while at\n[CS:P]Luminous Spring[CR] too!", french="Nous aussi, on a découvert de\nnotre côté à la [CS:P]Source Lumineuse[CR] qu'on était\nla cause de la distorsion de l'espace, non?", german="Aber unabhängig davon haben\nwir auch bei der [CS:P]Glitzerquelle[CR] herausgefunden,\ndass wir die Verzerrung des Raumes bewirken!", italian="Abbiamo saputo che stiamo\ncausando la distorsione dello spazio anche\nquando eravamo alla [CS:P]Sorgente Luccichio[CR]!", spanish="Ya supimos en el [CS:P]Manantial[CR]\n[CS:P]Luminoso[CR] que estamos causando una alteración\nen el espacio."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But we separately found out that\nwe are causing the space distortion while at\n[CS:P]Luminous Spring[CR] too!", french="Nous aussi, on a découvert de\nnotre côté à la [CS:P]Source Lumineuse[CR] qu'on était\nla cause de la distorsion de l'espace, non?", german="Aber unabhängig davon haben\nwir auch bei der [CS:P]Glitzerquelle[CR] herausgefunden,\ndass wir die Verzerrung des Raumes bewirken!", italian="Abbiamo saputo che stiamo\ncausando la distorsione dello spazio anche\nquando eravamo alla [CS:P]Sorgente Luccichio[CR]!", spanish="Ya supimos en el [CS:P]Manantial[CR]\n[CS:P]Luminoso[CR] que estamos causando una alteración\nen el espacio."})
  else
  SkySceneKit.say({english="But we separately found out that\nwe are causing the space distortion while at\n[CS:P]Luminous Spring[CR] too!", french="Nous aussi, on a découvert de\nnotre côté à la [CS:P]Source Lumineuse[CR] qu'on était\nla cause de la distorsion de l'espace, non?", german="Aber unabhängig davon haben\nwir auch bei der [CS:P]Glitzerquelle[CR] herausgefunden,\ndass wir die Verzerrung des Raumes bewirken!", italian="Abbiamo saputo che stiamo\ncausando la distorsione dello spazio anche\nquando eravamo alla [CS:P]Sorgente Luccichio[CR]!", spanish="Ya supimos en el [CS:P]Manantial[CR]\n[CS:P]Luminoso[CR] que estamos causando una alteración\nen el espacio."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And if [CS:N]Azurill[CR] can't wake up\nfrom his nightmare because of the distortion...", french="Et si [CS:N]Azurill[CR] ne peut pas\nsortir de son cauchemar à cause de la\ndistorsion...", german="Und wenn [CS:N]Azurill[CR] wegen der\nVerzerrung nicht aus seinem Albtraum\naufwachen kann...", italian="E se [CS:N]Azurill[CR] non riesce a\nsvegliarsi dal suo incubo a causa\ndella distorsione...", spanish="Y si [CS:N]Azurill[CR] no puede despertar\nde la pesadilla a causa de la deformación..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And if [CS:N]Azurill[CR] can't wake up\nfrom his nightmare because of the distortion...", french="Et si [CS:N]Azurill[CR] ne peut pas\nsortir de son cauchemar à cause de la\ndistorsion...", german="Und wenn [CS:N]Azurill[CR] wegen der\nVerzerrung nicht aus seinem Albtraum\naufwachen kann...", italian="E se [CS:N]Azurill[CR] non riesce a\nsvegliarsi dal suo incubo a causa\ndella distorsione...", spanish="Y si [CS:N]Azurill[CR] no puede despertar\nde la pesadilla a causa de la deformación..."})
  else
  SkySceneKit.say({english="And if [CS:N]Azurill[CR] can't wake up\nfrom his nightmare because of the distortion...", french="Et si [CS:N]Azurill[CR] ne peut pas\nsortir de son cauchemar à cause de la\ndistorsion...", german="Und wenn [CS:N]Azurill[CR] wegen der\nVerzerrung nicht aus seinem Albtraum\naufwachen kann...", italian="E se [CS:N]Azurill[CR] non riesce a\nsvegliarsi dal suo incubo a causa\ndella distorsione...", spanish="Y si [CS:N]Azurill[CR] no puede despertar\nde la pesadilla a causa de la deformación..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Well, I think we have to believe\nwhat we were told.", french="... toute cette histoire est\nsûrement vraie. Alors je pense qu'on doit\ncroire ce qu'elle nous a dit.", german="Wir müssen wohl glauben,\nwas man uns gesagt hat.", italian="Beh, penso che dovremmo\ncredere a quello che ci hanno detto.", spanish="Tendremos que creernos lo que\nnos han contado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well, I think we have to believe\nwhat we were told.", french="... toute cette histoire est\nsûrement vraie. Alors je pense qu'on doit\ncroire ce qu'elle nous a dit.", german="Wir müssen wohl glauben,\nwas man uns gesagt hat.", italian="Beh, penso che dovremmo\ncredere a quello che ci hanno detto.", spanish="Tendremos que creernos lo que\nnos han contado."})
  else
  SkySceneKit.say({english="Well, I think we have to believe\nwhat we were told.", french="... toute cette histoire est\nsûrement vraie. Alors je pense qu'on doit\ncroire ce qu'elle nous a dit.", german="Wir müssen wohl glauben,\nwas man uns gesagt hat.", italian="Beh, penso che dovremmo\ncredere a quello che ci hanno detto.", spanish="Tendremos que creernos lo que\nnos han contado."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- @label_8 [étiquette de flux ExplorerScript]
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Urk![K] That is true...)", french="(Argh![K] C'est vrai...)", german="(Uff![K] Das stimmt...)", italian="(Ah![K] È vero...)", spanish="(¡Uf![K] Es cierto...)"})
  else
  SkySceneKit.say({english="(Urk![K] That is true...)", french="(Argh![K] C'est vrai...)", german="(Uff![K] Das stimmt...)", italian="(Ah![K] È vero...)", spanish="(¡Uf![K] Es cierto...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But something...[K] Something is different about\ndisappearing this time around!)", french="(Mais cette fois...[K] il y a quelque chose\nde différent à propos de notre disparition!)", german="(Aber irgendetwas...[K] Irgendetwas ist diesmal\nanders, was das Verschwinden betrifft!)", italian="(Ma c'è qualcosa...[K] Questa volta c'è\nqualcosa di diverso!)", spanish="(Pero algo...[K] Hay algo que no encaja...)"})
  else
  SkySceneKit.say({english="(But something...[K] Something is different about\ndisappearing this time around!)", french="(Mais cette fois...[K] il y a quelque chose\nde différent à propos de notre disparition!)", german="(Aber irgendetwas...[K] Irgendetwas ist diesmal\nanders, was das Verschwinden betrifft!)", italian="(Ma c'è qualcosa...[K] Questa volta c'è\nqualcosa di diverso!)", spanish="(Pero algo...[K] Hay algo que no encaja...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I know something is different...)", french="(Il y a une différence, je le sais...)", german="(Ich weiß, dass etwas anders ist...)", italian="(So che c'è una differenza...)", spanish="(Esta vez hay algo más. Lo presiento...)"})
  else
  SkySceneKit.say({english="(I know something is different...)", french="(Il y a une différence, je le sais...)", german="(Ich weiß, dass etwas anders ist...)", italian="(So che c'è una differenza...)", spanish="(Esta vez hay algo más. Lo presiento...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But what is it?[K] I need to think carefully...)", french="(Mais laquelle?[K] Concentre-toi...)", german="(Aber was ist es?[K] Ich muss darüber\nnachdenken.)", italian="(Ma cos'è?[K] Devo pensare attentamente...)", spanish="(¿Pero el qué?[K] Tengo que pensar en ello\ndetenidamente...)"})
  else
  SkySceneKit.say({english="(But what is it?[K] I need to think carefully...)", french="(Mais laquelle?[K] Concentre-toi...)", german="(Aber was ist es?[K] Ich muss darüber\nnachdenken.)", italian="(Ma cos'è?[K] Devo pensare attentamente...)", spanish="(¿Pero el qué?[K] Tengo que pensar en ello\ndetenidamente...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...Th-that's it!)", french="(... Ça y est!)", german="(...D-das ist es!)", italian="(C-Ci sono!)", spanish="(Hum... ¡Eso es!)"})
  else
  SkySceneKit.say({english="(...Th-that's it!)", french="(... Ça y est!)", german="(...D-das ist es!)", italian="(C-Ci sono!)", spanish="(Hum... ¡Eso es!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That's right![K] This is different from before!)", french="(Voilà![K] Voilà la différence!)", german="(Das stimmt![K] Dies ist anders als zuvor!)", italian="(È così![K] Questa volta c'è una differenza!)", spanish="(¡Claro![K] ¡Ya sé qué es!)"})
  else
  SkySceneKit.say({english="(That's right![K] This is different from before!)", french="(Voilà![K] Voilà la différence!)", german="(Das stimmt![K] Dies ist anders als zuvor!)", italian="(È così![K] Questa volta c'è una differenza!)", spanish="(¡Claro![K] ¡Ya sé qué es!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Back then with [CS:N]Dialga[CR], my disappearance\nwasn't really a choice!)", french="(Avec [CS:N]Dialga[CR], ma disparition n'était\npas vraiment un choix!)", german="(Damals mit [CS:N]Dialga[CR] hatte ich keine andere\nWahl, als zu verschwinden!)", italian="(Con [CS:N]Dialga[CR] non avevo scelta,\ndovevo per forza sparire!)", spanish="(Cuando nos enfrentamos a [CS:N]Dialga[CR],\nyo no tenía elección.)"})
  else
  SkySceneKit.say({english="(Back then with [CS:N]Dialga[CR], my disappearance\nwasn't really a choice!)", french="(Avec [CS:N]Dialga[CR], ma disparition n'était\npas vraiment un choix!)", german="(Damals mit [CS:N]Dialga[CR] hatte ich keine andere\nWahl, als zu verschwinden!)", italian="(Con [CS:N]Dialga[CR] non avevo scelta,\ndovevo per forza sparire!)", spanish="(Cuando nos enfrentamos a [CS:N]Dialga[CR],\nyo no tenía elección.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I've got to explain that to [partner]...)", french="(Je dois expliquer ça à [partner]...)", german="(Ich muss das [partner] erklären...)", italian="(Devo spiegarlo a [partner]...)", spanish="(Tengo que explicárselo a [partner]...)"})
  else
  SkySceneKit.say({english="(I've got to explain that to [partner]...)", french="(Je dois expliquer ça à [partner]...)", german="(Ich muss das [partner] erklären...)", italian="(Devo spiegarlo a [partner]...)", spanish="(Tengo que explicárselo a [partner]...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:FadeOutBGM(180) end)
  -- bgm2_ChangeVolume(90, 256) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?[K] It's different this time?", french="Hein?[K] C'est différent\ncette fois?", german="Wie bitte?[K] Es ist dieses Mal\nanders?", italian=" Eh?[K] Questa volta è diverso?", spanish=" ¿Qué?[K] ¿Esta vez es distinto?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?[K] It's different this time?", french="Hein?[K] C'est différent\ncette fois?", german="Wie bitte?[K] Es ist dieses Mal\nanders?", italian=" Eh?[K] Questa volta è diverso?", spanish=" ¿Qué?[K] ¿Esta vez es distinto?"})
  else
  SkySceneKit.say({english=" What?[K] It's different this time?", french="Hein?[K] C'est différent\ncette fois?", german="Wie bitte?[K] Es ist dieses Mal\nanders?", italian=" Eh?[K] Questa volta è diverso?", spanish=" ¿Qué?[K] ¿Esta vez es distinto?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What's...[K] What's different?", french="Quoi...?[K] Qu'est-ce qui est\ndifférent?", german=" Was...[K] Was ist anders?", italian=" Cosa...[K] Cosa c'è di diverso?", spanish=" Qué...[K] ¿Qué es distinto?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What's...[K] What's different?", french="Quoi...?[K] Qu'est-ce qui est\ndifférent?", german=" Was...[K] Was ist anders?", italian=" Cosa...[K] Cosa c'è di diverso?", spanish=" ¿Qué...?[K] ¿Qué es distinto?"})
  else
  SkySceneKit.say({english=" What's...[K] What's different?", french="Quoi...?[K] Qu'est-ce qui est\ndifférent?", german=" Was...[K] Was ist anders?", italian=" Cosa...[K] Cosa c'è di diverso?", spanish=" ¿Qué...?[K] ¿Qué es distinto?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[K]What?!", french=" ...[K] Quoi?!", german=" ...[K]Was?!?", italian=" ...[K] Cosa?!", spanish=" ¿Qué...?[K] ¡¿Quéee?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[K]What?!", french=" ...[K] Quoi?!", german=" ...[K]Was?!?", italian=" ...[K] Cosa?!", spanish=" ¿Qué...?[K] ¡¿Quéee?!"})
  else
  SkySceneKit.say({english=" ...[K]What?!", french=" ...[K] Quoi?!", german=" ...[K]Was?!?", italian=" ...[K] Cosa?!", spanish=" ¿Qué...?[K] ¡¿Quéee?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="At [CS:P]Temporal Tower[CR], you were\nwilling to disappear...", french="A la [CS:P]Tour du Temps[CR], tu avais\naccepté l'idée de ta disparition...", german="Beim [CS:P]Zeitturm[CR] warst du bereit\nzu verschwinden...", italian="Alla [CS:P]Torre del Tempo[CR], avresti\naccettato di sparire...", spanish="En la [CS:P]Torre del Tiempo[CR] ya habías\nasumido que ibas a desaparecer..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="At [CS:P]Temporal Tower[CR], you were\nwilling to disappear...", french="A la [CS:P]Tour du Temps[CR], tu avais\naccepté l'idée de ta disparition...", german="Beim [CS:P]Zeitturm[CR] warst du bereit\nzu verschwinden...", italian="Alla [CS:P]Torre del Tempo[CR], avresti\naccettato di sparire...", spanish="En la [CS:P]Torre del Tiempo[CR] ya habías\nasumido que ibas a desaparecer..."})
  else
  SkySceneKit.say({english="At [CS:P]Temporal Tower[CR], you were\nwilling to disappear...", french="A la [CS:P]Tour du Temps[CR], tu avais\naccepté l'idée de ta disparition...", german="Beim [CS:P]Zeitturm[CR] warst du bereit\nzu verschwinden...", italian="Alla [CS:P]Torre del Tempo[CR], avresti\naccettato di sparire...", spanish="En la [CS:P]Torre del Tiempo[CR] ya habías\nasumido que ibas a desaparecer..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But it's not the same this time?", french="... mais ce n'est pas la même\nchose cette fois?", german=" Aber das ist diesmal nicht so?", italian="Ma questa volta non è la\nstessa cosa?", spanish=" ¿Qué es diferente esta vez?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But it's not the same this time?", french="... mais ce n'est pas la même\nchose cette fois?", german=" Aber das ist diesmal nicht so?", italian="Ma questa volta non è la\nstessa cosa?", spanish=" ¿Qué es diferente esta vez?"})
  else
  SkySceneKit.say({english=" But it's not the same this time?", french="... mais ce n'est pas la même\nchose cette fois?", german=" Aber das ist diesmal nicht so?", italian="Ma questa volta non è la\nstessa cosa?", spanish=" ¿Qué es diferente esta vez?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh...?", french=" Hein...?", german=" Wie?", italian=" Eh...?", spanish=" ¿Qué...?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What...?", french=" Hein...?", german=" Was?", italian=" Eh...?", spanish=" ¿Qué...?"})
  else
  SkySceneKit.say({english=" What...?", french=" Hein...?", german=" Was?", italian=" Eh...?", spanish=" ¿Qué...?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You did what you did at\n[CS:P]Temporal Tower[CR] because you had to...", french="Tu as accepté de te sacrifier\nà la [CS:P]Tour du Temps[CR] parce que tu savais\nqu'il fallait le faire...", german="Du hast damals im [CS:P]Zeitturm[CR]\ngetan, was zu tun war, weil du es musstest...", italian="Hai fatto quello che dovevi alla\n[CS:P]Torre del Tempo[CR] perché non avevi scelta...", spanish="Hiciste lo que hiciste en la\n[CS:P]Torre del Tiempo[CR] porque era necesario..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You did what you did at\n[CS:P]Temporal Tower[CR] because you had to...", french="Tu as accepté de te sacrifier\nà la [CS:P]Tour du Temps[CR] parce que tu savais\nqu'il fallait le faire...", german="Du hast damals im [CS:P]Zeitturm[CR]\ngetan, was zu tun war, weil du es musstest...", italian="Hai fatto quello che dovevi alla\n[CS:P]Torre del Tempo[CR] perché non avevi scelta...", spanish="Hiciste lo que hiciste en la\n[CS:P]Torre del Tiempo[CR] porque era necesario..."})
  else
  SkySceneKit.say({english="You did what you did at\n[CS:P]Temporal Tower[CR] because you had to...", french="Tu as accepté de te sacrifier\nà la [CS:P]Tour du Temps[CR] parce que tu savais\nqu'il fallait le faire...", german="Du hast damals im [CS:P]Zeitturm[CR]\ngetan, was zu tun war, weil du es musstest...", italian="Hai fatto quello che dovevi alla\n[CS:P]Torre del Tempo[CR] perché non avevi scelta...", spanish="Hiciste lo que hiciste en la\n[CS:P]Torre del Tiempo[CR] porque era necesario..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You changed your future because\nyou knew that it would lead to world peace...", french="Tu as changé ton futur parce\nque tu savais que cela ramènerait la paix\ndans le monde...", german="Du hast deine Zukunft verändert,\nweil du wusstest, dass es zum Weltfrieden\nführt...", italian="Hai cambiato il tuo futuro\nperché sapevi che il mondo avrebbe\nritrovato la pace...", spanish="No te importaba sacrificar tu\nfuturo porque sabías que contribuirías a\nmejorar el mundo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You changed your future because\nyou knew that it would lead to world peace...", french="Tu as changé ton futur parce\nque tu savais que cela ramènerait la paix\ndans le monde...", german="Du hast deine Zukunft verändert,\nweil du wusstest, dass es zum Weltfrieden\nführt...", italian="Hai cambiato il tuo futuro\nperché sapevi che il mondo avrebbe\nritrovato la pace...", spanish="No te importaba sacrificar tu\nfuturo porque sabías que contribuirías a\nmejorar el mundo..."})
  else
  SkySceneKit.say({english="You changed your future because\nyou knew that it would lead to world peace...", french="Tu as changé ton futur parce\nque tu savais que cela ramènerait la paix\ndans le monde...", german="Du hast deine Zukunft verändert,\nweil du wusstest, dass es zum Weltfrieden\nführt...", italian="Hai cambiato il tuo futuro\nperché sapevi che il mondo avrebbe\nritrovato la pace...", spanish="No te importaba sacrificar tu\nfuturo porque sabías que contribuirías a\nmejorar el mundo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But your choice wasn't really the\nchoice to disappear.", french="Mais tu n'avais pas choisi\nde disparaître.", german="Aber deine Wahl war nicht die,\nob du verschwinden solltest.", italian=" Ma non volevi davvero sparire.", spanish="Tu desaparición era algo\nsecundario, tu elección no se basaba\nen eso..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But your choice wasn't really the\nchoice to disappear.", french="Mais tu n'avais pas choisi\nde disparaître.", german="Aber deine Wahl war nicht die,\nob du verschwinden solltest.", italian=" Ma non volevi davvero sparire.", spanish="Tu desaparición era algo\nsecundario, tu elección no se basaba\nen eso..."})
  else
  SkySceneKit.say({english="But your choice wasn't really the\nchoice to disappear.", french="Mais tu n'avais pas choisi\nde disparaître.", german="Aber deine Wahl war nicht die,\nob du verschwinden solltest.", italian=" Ma non volevi davvero sparire.", spanish="Tu desaparición era algo\nsecundario, tu elección no se basaba\nen eso..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But there's no telling what will\nhappen if we disappear. Not this time.", french="Cette fois, au contraire,\non ne sait pas ce qui arrivera si nous\ndisparaissons.", german="Aber dieses Mal kann niemand\nsagen, was passiert, wenn wir verschwinden.\nDieses Mal nicht.", italian="Non sappiamo cosa succederà\nse sparissimo. Non questa volta.", spanish="Esta vez es imposible saber\nqué pasará si desaparecemos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But there's no telling what will\nhappen if we disappear. Not this time.", french="Cette fois, au contraire,\non ne sait pas ce qui arrivera si nous\ndisparaissons.", german="Aber dieses Mal kann niemand\nsagen, was passiert, wenn wir verschwinden.\nDieses Mal nicht.", italian="Non sappiamo cosa succederà\nse sparissimo. Non questa volta.", spanish="Esta vez es imposible saber\nqué pasará si desaparecemos."})
  else
  SkySceneKit.say({english="But there's no telling what will\nhappen if we disappear. Not this time.", french="Cette fois, au contraire,\non ne sait pas ce qui arrivera si nous\ndisparaissons.", german="Aber dieses Mal kann niemand\nsagen, was passiert, wenn wir verschwinden.\nDieses Mal nicht.", italian="Non sappiamo cosa succederà\nse sparissimo. Non questa volta.", spanish="Esta vez es imposible saber\nqué pasará si desaparecemos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So we don't really know if that\nwill bring peace to the world again...", french="On ne sait pas si cela ramènera\nla paix dans le monde...", german="Wir wissen also nicht, ob danach\nwieder Frieden in diese Welt einkehrt...", italian="Quindi non sappiamo\nse sparire riporterà la pace...", spanish="No sabemos con certeza si\nnuestra desaparición ayudará o no al\nmundo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So we don't really know if that\nwill bring peace to the world again...", french="On ne sait pas si cela ramènera\nla paix dans le monde...", german="Wir wissen also nicht, ob danach\nwieder Frieden in diese Welt einkehrt...", italian="Quindi non sappiamo\nse sparire riporterà la pace...", spanish="No sabemos con certeza si\nnuestra desaparición ayudará o no al\nmundo..."})
  else
  SkySceneKit.say({english="So we don't really know if that\nwill bring peace to the world again...", french="On ne sait pas si cela ramènera\nla paix dans le monde...", german="Wir wissen also nicht, ob danach\nwieder Frieden in diese Welt einkehrt...", italian="Quindi non sappiamo\nse sparire riporterà la pace...", spanish="No sabemos con certeza si\nnuestra desaparición ayudará o no al\nmundo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What you're saying is, nothing\nabout this is certain?", french="Donc, tu dis que rien n'est\ncertain là-dedans?", german="Du sagst also, nichts an dieser\nSache sei sicher?", italian="Stai dicendo che non c'è niente\ndi certo questa volta?", spanish="Lo que quieres decir es...\n¿que no hay nada seguro?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What you're saying is, nothing\nabout this is certain?", french="Donc, tu dis que rien n'est\ncertain là-dedans?", german="Du sagst also, nichts an dieser\nSache sei sicher?", italian="Stai dicendo che non c'è niente\ndi certo questa volta?", spanish="Lo que quieres decir es...\n¿que no hay nada seguro?"})
  else
  SkySceneKit.say({english="What you're saying is, nothing\nabout this is certain?", french="Donc, tu dis que rien n'est\ncertain là-dedans?", german="Du sagst also, nichts an dieser\nSache sei sicher?", italian="Stai dicendo che non c'è niente\ndi certo questa volta?", spanish="Lo que quieres decir es...\n¿que no hay nada seguro?"})
  end
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  else
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That's true...", french=" C'est vrai...", german=" Das ist wahr.", italian=" È vero.", spanish=" Es verdad..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's true...", french=" C'est vrai...", german=" Das ist wahr.", italian=" È vero.", spanish=" Es verdad..."})
  else
  SkySceneKit.say({english=" That's true...", french=" C'est vrai...", german=" Das ist wahr.", italian=" È vero.", spanish=" Es verdad..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's true that things aren't\ncompletely certain.", french="Tout n'est pas certain dans\ncette histoire.", german="Es ist wahr, dass die Dinge nicht\nvöllig sicher sind.", italian="È vero che le cose non\nsono del tutto certe.", spanish="No sabemos nada a ciencia\ncierta."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's true that things aren't\ncompletely certain.", french="Tout n'est pas certain dans\ncette histoire.", german="Es ist wahr, dass die Dinge nicht\nvöllig sicher sind.", italian="È vero che le cose non\nsono del tutto certe.", spanish="No sabemos nada a ciencia\ncierta."})
  else
  SkySceneKit.say({english="It's true that things aren't\ncompletely certain.", french="Tout n'est pas certain dans\ncette histoire.", german="Es ist wahr, dass die Dinge nicht\nvöllig sicher sind.", italian="È vero che le cose non\nsono del tutto certe.", spanish="No sabemos nada a ciencia\ncierta."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But...", french=" Mais...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But...", french=" Mais...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  else
  SkySceneKit.say({english=" But...", french=" Mais...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It is a fact that you were a\nhuman who came from the future,\n[hero].", french="... ce qui est sûr, c'est que tu es\nun être humain venu du futur, [hero]...", german="Du bist ein Mensch aus der\nZukunft, so viel steht fest, [hero].", italian="È sicuro che tu sei un essere\numano venuto dal futuro, [hero].", spanish="Que tú, [hero], eres un\nser humano que vino del futuro, es\nun hecho."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It is a fact that you were a\nhuman who came from the future,\n[hero].", french="... ce qui est sûr, c'est que tu es\nun être humain venu du futur, [hero]...", german="Du bist ein Mensch aus der\nZukunft, so viel steht fest, [hero].", italian="È sicuro che tu sei un essere\numano venuto dal futuro, [hero].", spanish="Que tú, [hero], eres un\nser humano que vino del futuro, es\nun hecho."})
  else
  SkySceneKit.say({english="It is a fact that you were a\nhuman who came from the future,\n[hero].", french="... ce qui est sûr, c'est que tu es\nun être humain venu du futur, [hero]...", german="Du bist ein Mensch aus der\nZukunft, so viel steht fest, [hero].", italian="È sicuro che tu sei un essere\numano venuto dal futuro, [hero].", spanish="Que tú, [hero], eres un\nser humano que vino del futuro, es\nun hecho."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And I did go to the future and\nthen come back to this world.", french="... et que moi, j'ai fait un\naller-retour dans le futur.", german="Ich ging in die Zukunft und\nkam dann zurück in diese Welt.", italian="E io sono stato nel futuro e\nsono tornato in questo mondo.", spanish="Y yo estuve en el futuro y\nregresé, después, a este mundo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And I did go to the future and\nthen come back to this world.", french="... et que moi, j'ai fait un\naller-retour dans le futur.", german="Ich ging in die Zukunft und\nkam dann zurück in diese Welt.", italian="E io sono stato nel futuro e\nsono tornato in questo mondo.", spanish="Y yo estuve en el futuro y\nregresé, después, a este mundo."})
  else
  SkySceneKit.say({english="And I did go to the future and\nthen come back to this world.", french="... et que moi, j'ai fait un\naller-retour dans le futur.", german="Ich ging in die Zukunft und\nkam dann zurück in diese Welt.", italian="E io sono stata nel futuro e\nsono tornata in questo mondo.", spanish="Y yo estuve en el futuro y\nregresé, después, a este mundo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And it does seem that, because\nof us, space has started to distort.", french="Et apparemment, l'espace\ncommence à se distordre à cause de nous.", german="Und es scheint, dass der Raum\nsich unseretwegen zu verzerren beginnt.", italian="E sembra che a causa nostra\nabbia avuto inizio la distorsione dello spazio.", spanish="Todo indica que hemos sido\nnosotros los responsables de que el espacio\nse esté distorsionando."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And it does seem that, because\nof us, space has started to distort.", french="Et apparemment, l'espace\ncommence à se distordre à cause de nous.", german="Und es scheint, dass der Raum\nsich unseretwegen zu verzerren beginnt.", italian="E sembra che a causa nostra\nabbia avuto inizio la distorsione dello spazio.", spanish="Todo indica que nosotros hemos\nsido la causa de que el espacio se esté\ndistorsionando."})
  else
  SkySceneKit.say({english="And it does seem that, because\nof us, space has started to distort.", french="Et apparemment, l'espace\ncommence à se distordre à cause de nous.", german="Und es scheint, dass der Raum\nsich unseretwegen zu verzerren beginnt.", italian="E sembra che a causa nostra\nabbia avuto inizio la distorsione dello spazio.", spanish="Todo indica que la deformación\ndel espacio tiene relación con eso."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We know for certain that we\nchanged history...", french="Une chose est sûre: nous avons\nchangé l'Histoire...", german="Wir wissen sicher, dass wir die\nGeschichte verändert haben.", italian="Sappiamo di avere sicuramente\ncambiato la storia...", spanish="Sabemos con certeza que hemos\ncambiado el rumbo de la historia..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There's no escaping the fact that\nwe changed history...", french="Une chose est sûre: nous avons\nchangé l'Histoire...", german="Es führt kein Weg um die\nTatsache herum, dass wir die Geschichte\nverändert haben.", italian="Sappiamo di avere sicuramente\ncambiato la storia...", spanish="No se puede negar que hemos\ncambiado el rumbo de la historia..."})
  else
  SkySceneKit.say({english="There's no denying that we\nchanged history...", french="Une chose est sûre: nous avons\nchangé l'Histoire...", german="Wir können nicht leugnen, dass\nwir die Geschichte verändert haben.", italian="Sappiamo di avere sicuramente\ncambiato la storia...", spanish="No se puede negar que hemos\ncambiado el rumbo de la historia..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That must mean what we were\ntold is true...", french="Ce qui signifie forcément que\nce qu'on nous a raconté est vrai...", german="Das muss bedeuten, dass es\nwahr ist, was uns erzählt wurde.", italian="Questo vuol dire che ciò che ci\nhanno detto è vero.", spanish="Así que debe de ser cierto lo\nque nos contaron..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That must mean what we were\ntold is true...", french="Ce qui signifie forcément que\nce qu'on nous a raconté est vrai...", german="Das muss bedeuten, dass es\nwahr ist, was uns erzählt wurde.", italian="Questo vuol dire che ciò che ci\nhanno detto è vero.", spanish="Así que debe de ser cierto lo\nque nos contaron..."})
  else
  SkySceneKit.say({english="That must mean what we were\ntold is true...", french="Ce qui signifie forcément que\nce qu'on nous a raconté est vrai...", german="Das muss bedeuten, dass es\nwahr ist, was uns erzählt wurde.", italian="Questo vuol dire che ciò che ci\nhanno detto è vero.", spanish="Así que debe de ser cierto lo\nque nos contaron..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner]...)", french="([partner]...)", german="([partner]...)", italian="([partner]...)", spanish="([partner]...)"})
  else
  SkySceneKit.say({english="([partner]...)", french="([partner]...)", german="([partner]...)", italian="([partner]...)", spanish="([partner]...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh...", french=" Oh...", german=" Oh...", italian=" Oh...", spanish=" Mira..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh...", french=" Oh...", german=" Oh...", italian=" Oh...", spanish=" Mira..."})
  else
  SkySceneKit.say({english=" Oh...", french=" Oh...", german=" Oh...", italian=" Oh...", spanish=" Mira..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's sunlight...)", french="(Le soleil...)", german="(Es wird hell...)", italian="(C'è il sole.)", spanish="(La luz del sol...)"})
  else
  SkySceneKit.say({english="(It's sunlight...)", french="(Le soleil...)", german="(Es wird hell...)", italian="(C'è il sole.)", spanish="(La luz del sol...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The sun's coming up...)", french="(Le jour se lève...)", german="(Die Sonne geht auf...)", italian="(Sta albeggiando...)", spanish="(Está amaneciendo...)"})
  else
  SkySceneKit.say({english="(The sun's coming up...)", french="(Le jour se lève...)", german="(Die Sonne geht auf...)", italian="(Sta albeggiando...)", spanish="(Está amaneciendo...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V21P02A) [décor sub chargé: Sub_v21p02a]
  -- camera2_SetPositionMark(Position<'m3', 20, 18.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- supervision_Acting(1) [neutre/état moteur]
  SkySubScreen.Show("v21p02a", 15, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  -- Move2PositionMark<object OBJECT_V21P02A1_288> [prop décor NDS, géré par le rendu du ground]
  -- back_SetBackEffect(3) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  -- back2_SetBackEffect(3) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  GAME:WaitFrames(180)
  GAME:WaitFrames(180)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  else
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's beautiful...[K] It's another beautiful dawn...)", french="(C'est somptueux...[K] cette aurore...)", german="(Es ist wunderschön...[K] Ein schöner neuer\nSonnenaufgang...)", italian="(È stupendo...[K] Un'altra bellissima alba...)", spanish="(Es precioso...[K] Un amanecer precioso...)"})
  else
  SkySceneKit.say({english="(It's beautiful...[K] It's another beautiful dawn...)", french="(C'est somptueux...[K] cette aurore...)", german="(Es ist wunderschön...[K] Ein schöner neuer\nSonnenaufgang...)", italian="(È stupendo...[K] Un'altra bellissima alba...)", spanish="(Es precioso...[K] Un amanecer precioso...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(45)
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, [hero]...", french=" Oh, [hero]...", german=" Oh, [hero]...", italian=" Oh, [hero]...", spanish=" [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, [hero]...", french=" Oh, [hero]...", german=" Oh, [hero]...", italian=" Oh, [hero]...", spanish=" [hero]..."})
  else
  SkySceneKit.say({english=" Oh, [hero]...", french=" Oh, [hero]...", german=" Oh, [hero]...", italian=" Oh, [hero]...", spanish=" [hero]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Seeing the sun come up this way\nmakes me remember...!", french="En voyant ce lever de soleil,\nil me revient quelque chose...!", german="Wenn ich die Sonne so aufgehen\nsehe, kommen die Erinnerungen in mir hoch!", italian="Vedere l'alba mi fa tornare\nin mente...!", spanish="Este amanecer me ha hecho\nrecordar..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Seeing the sun come up this way\nmakes me remember...!", french="En voyant ce lever de soleil,\nil me revient quelque chose...!", german="Wenn ich die Sonne so aufgehen\nsehe, kommen die Erinnerungen in mir hoch!", italian="Vedere l'alba mi fa tornare\nin mente...!", spanish="Este amanecer me ha hecho\nrecordar..."})
  else
  SkySceneKit.say({english="Seeing the sun come up this way\nmakes me remember...!", french="En voyant ce lever de soleil,\nil me revient quelque chose...!", german="Wenn ich die Sonne so aufgehen\nsehe, kommen die Erinnerungen in mir hoch!", italian="Vedere l'alba mi fa tornare\nin mente...!", spanish="Este amanecer me ha hecho\nrecordar..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I've seen the sun come up from\nhere before...[K] This isn't the first time.", french="J'ai déjà vu un lever de soleil\ncomme celui-là...[K] Ce n'est pas\nla première fois.", german="Ich habe die Sonne von hier aus\nschon aufgehen sehen...[K]\nDas ist nicht das erste Mal.", italian="Ho già visto l'alba da qui...[K]\nNon è la prima volta.", spanish="Ya había visto salir el sol desde\naquí...[K] Esta no es la primera vez."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I've seen the sunrise from here\nbefore...[K] This isn't the first time.", french="J'ai déjà vu un lever de soleil\ncomme celui-là...[K] Ce n'est pas\nla première fois.", german="Ich habe die Sonne von hier aus\nschon aufgehen sehen...[K]\nDas ist nicht das erste Mal.", italian="Ho già visto l'alba da qui...[K]\nNon è la prima volta.", spanish="Ya había visto salir el sol desde\naquí...[K] Esta no es la primera vez."})
  else
  SkySceneKit.say({english="I've seen the sunrise from here\nbefore...[K] This isn't the first time.", french="J'ai déjà vu un lever de soleil\ncomme celui-là...[K] Ce n'est pas\nla première fois.", german="Ich habe die Sonne von hier aus\nschon aufgehen sehen...[K]\nDas ist nicht das erste Mal.", italian="Ho già visto l'alba da qui...[K]\nNon è la prima volta.", spanish="Ya había visto salir el sol desde\naquí...[K] Esta no es la primera vez."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The first time...[K] I was with\n[CS:N]Grovyle[CR].", french="C'était...[K] quand j'étais avec\n[CS:N]Massko[CR].", german="Das erste Mal...[K] Da war [CS:N]Reptain[CR]\ndabei.", italian="La prima volta...[K] con me c'era\n[CS:N]Grovyle[CR].", spanish="En aquella ocasión...[K] estaba con\n[CS:N]Grovyle[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The first time...[K] I was with\n[CS:N]Grovyle[CR].", french="C'était...[K] quand j'étais avec\n[CS:N]Massko[CR].", german="Das erste Mal...[K] Da war [CS:N]Reptain[CR]\ndabei.", italian="La prima volta...[K] con me c'era\n[CS:N]Grovyle[CR].", spanish="En aquella ocasión...[K] estaba con\n[CS:N]Grovyle[CR]."})
  else
  SkySceneKit.say({english="The first time...[K] I was with\n[CS:N]Grovyle[CR].", french="C'était...[K] quand j'étais avec\n[CS:N]Massko[CR].", german="Das erste Mal...[K] Da war [CS:N]Reptain[CR]\ndabei.", italian="La prima volta...[K] con me c'era\n[CS:N]Grovyle[CR].", spanish="En aquella ocasión...[K] estaba con\n[CS:N]Grovyle[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_ChangeVolume(90, 190) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  -- GAP: BGM BGM_IN_THE_HANDS_OF_FATE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(With [CS:N]Grovyle[CR]?)", french="(Avec [CS:N]Massko[CR]?)", german="([CS:N]Reptain[CR]?)", italian="([CS:N]Grovyle[CR]?)", spanish="(¿Con [CS:N]Grovyle[CR]?)"})
  else
  SkySceneKit.say({english="(With [CS:N]Grovyle[CR]?)", french="(Avec [CS:N]Massko[CR]?)", german="([CS:N]Reptain[CR]?)", italian="([CS:N]Grovyle[CR]?)", spanish="(¿Con [CS:N]Grovyle[CR]?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yup.[K] Remember when we first\ncame back from the future? We slept here?", french="Oui.[K] Tu te rappelles après notre\nretour du futur? On a dormi ici.", german="Jep.[K] Erinnerst du dich, als wir\naus der Zukunft zurückkamen? Wir haben hier\ngeschlafen.", italian="Sì.[K] Ricordi quando abbiamo\nfatto ritorno dal futuro per la prima\nvolta? Abbiamo dormito qui.", spanish="Sí.[K] ¿Recuerdas cuando\nregresamos del futuro? ¿Cuando dormimos\njuntos aquí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yes.[K] Remember when we first\ncame back from the future? We slept here?", french="Oui.[K] Tu te rappelles après notre\nretour du futur? On a dormi ici.", german="Ja.[K] Erinnerst du dich, als wir\naus der Zukunft zurückkamen? Wir haben hier\ngeschlafen.", italian="Sì.[K] Ricordi quando abbiamo\nfatto ritorno dal futuro per la prima\nvolta? Abbiamo dormito qui.", spanish="Sí.[K] ¿Recuerdas cuando\nregresamos del futuro? ¿Cuando dormimos\njuntos aquí?"})
  else
  SkySceneKit.say({english="Yep.[K] Remember when we first\ncame back from the future? We slept here?", french="Oui.[K] Tu te rappelles après notre\nretour du futur? On a dormi ici.", german="Jep.[K] Erinnerst du dich, als wir\naus der Zukunft zurückkamen? Wir haben hier\ngeschlafen.", italian="Sì.[K] Ricordi quando abbiamo\nfatto ritorno dal futuro per la prima\nvolta? Abbiamo dormito qui.", spanish="Sí.[K] ¿Recuerdas cuando\nregresamos del futuro? ¿Cuando dormimos\njuntos aquí?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's when I saw the sunrise\nfrom here for the first time.", french="C'est là que j'ai vu ce lever de\nsoleil pour la première fois.", german="Zu dem Zeitpunkt habe ich den\nSonnenaufgang hier zum ersten Mal gesehen.", italian="È stato allora che ho visto\nl'alba da qui per la prima volta.", spanish="Fue entonces cuando vi, por\nprimera vez, el amanecer en este lugar."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's when I saw the sunrise\nfrom here for the first time.", french="C'est là que j'ai vu ce lever de\nsoleil pour la première fois.", german="Zu dem Zeitpunkt habe ich den\nSonnenaufgang hier zum ersten Mal gesehen.", italian="È stato allora che ho visto\nl'alba da qui per la prima volta.", spanish="Fue entonces cuando vi, por\nprimera vez, el amanecer en este lugar."})
  else
  SkySceneKit.say({english="That's when I saw the sunrise\nfrom here for the first time.", french="C'est là que j'ai vu ce lever de\nsoleil pour la première fois.", german="Zu dem Zeitpunkt habe ich den\nSonnenaufgang hier zum ersten Mal gesehen.", italian="È stato allora che ho visto\nl'alba da qui per la prima volta.", spanish="Fue entonces cuando vi, por\nprimera vez, el amanecer en este lugar."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I just remembered something\nabout that first time...", french="Je me souviens d'une chose\nce jour-là...", german="Ich muss mich gerade an etwas\nbei diesem ersten Mal erinnern...", italian="Mi è appena tornata in mente\nuna cosa di quella volta...", spanish=" Acabo de recordar una cosa..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I just remembered something\nabout that first time...", french="Je me souviens d'une chose\nce jour-là...", german="Ich muss mich gerade an etwas\nbei diesem ersten Mal erinnern...", italian="Mi è appena tornata in mente\nuna cosa di quella volta...", spanish=" Acabo de recordar una cosa..."})
  else
  SkySceneKit.say({english="I just remembered something\nabout that first time...", french="Je me souviens d'une chose\nce jour-là...", german="Ich muss mich gerade an etwas\nbei diesem ersten Mal erinnern...", italian="Mi è appena tornata in mente\nuna cosa di quella volta...", spanish=" Acabo de recordar una cosa..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's something [CS:N]Grovyle[CR]\nasked me...", french=" [CS:N]Massko[CR] m'a posé une question...", german="An etwas, das [CS:N]Reptain[CR] mich\nfragte.", italian="Si tratta di una cosa che mi ha\nchiesto [CS:N]Grovyle[CR]...", spanish=" Algo que me preguntó [CS:N]Grovyle[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's something [CS:N]Grovyle[CR]\nasked me...", french=" [CS:N]Massko[CR] m'a posé une question...", german="An etwas, das [CS:N]Reptain[CR] mich\nfragte.", italian="Si tratta di una cosa che mi ha\nchiesto [CS:N]Grovyle[CR]...", spanish=" Algo que me preguntó [CS:N]Grovyle[CR]..."})
  else
  SkySceneKit.say({english="It's something [CS:N]Grovyle[CR]\nasked me...", french=" [CS:N]Massko[CR] m'a posé une question...", german="An etwas, das [CS:N]Reptain[CR] mich\nfragte.", italian="Si tratta di una cosa che mi ha\nchiesto [CS:N]Grovyle[CR]...", spanish=" Algo que me preguntó [CS:N]Grovyle[CR]..."})
  end
  -- message_Close
  -- bgm2_ChangeVolume(140, 0) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  end
  end
  end
  end
  end
  end
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
