-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P06P01A/m18a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(19, 2) -- $SCENARIO_MAIN = scn[19,2] (ROM)
  -- back_SetGround(LEVEL_P06P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(partner, 152, 212, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(hero, 128, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Huff-huff...[K] We've climbed a\nlong ways up...", french="Pff, pff...[K] Cette escalade\nn'en finit plus...", german="Keuch, keuch...[K] Wir sind ziemlich\nweit nach oben gestiegen...", italian="Uff-Uff...[K] Ci stiamo\narrampicando da un bel po'...", spanish="Uf... Puf...[K]\nYa hemos subido un gran trecho..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Huff-huff...[K] We've been climbing\na long time now...", french="Pff, pff...[K] Cette escalade\nn'en finit plus...", german="Keuch, keuch...[K] Wir sind ziemlich\nweit nach oben gestiegen...", italian="Uff-Uff...[K] Ci stiamo\narrampicando da un bel po'...", spanish="Uf... Puf...[K]\nYa llevamos mucho tiempo subiendo..."})
  else
  SkySceneKit.say({english="Huff-huff...[K] We've climbed a\nlong ways up...", french="Pff, pff...[K] Cette escalade\nn'en finit plus...", german="Keuch, keuch...[K] Wir sind ziemlich\nweit nach oben gestiegen...", italian="Uff-Uff...[K] Ci stiamo\narrampicando da un bel po'...", spanish="Uf... Puf...[K]\nHemos subido un gran trecho..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(300, 228, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 272, 212, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 256, 236, false, 2)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Whoa![K] Look at that,\n[hero]!", french="Waouh![K] Regarde ça,\n[hero]!", german=" Boah![K] Sieh mal, [hero]!", italian="Wow![K] Guarda,\n[hero]!", spanish="¡Vaya![K]\n¡Mira eso, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wow![K] Look at that,\n[hero]!", french="Waouh![K] Regarde ça,\n[hero]!", german=" Boah![K] Sieh mal, [hero]!", italian="Wow![K] Guarda,\n[hero]!", spanish="¡Vaya![K]\n¡Mira eso, [hero]!"})
  else
  SkySceneKit.say({english="Wow![K] Look at that,\n[hero]!", french="Waouh![K] Regarde ça,\n[hero]!", german=" Boah![K] Sieh mal, [hero]!", italian="Wow![K] Guarda,\n[hero]!", spanish="¡Vaya![K]\n¡Mira eso, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(300, 176, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 316, 148, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 276, 172, false, 2)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It was true...[K] The future really\nis a world of darkness...", french="C'était donc vrai...[K] Le futur\nest plongé dans une ombre abyssale...", german="Es ist wahr...[K] Die Zukunft\nist wirklich eine Welt der Dunkelheit.", italian="Era la verità...[K] Il futuro è\ndavvero un mondo d'oscurità...", spanish="Era cierto...[K] El futuro es\nrealmente un mundo de oscuridad..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It was true...[K] The future really\nis a world of darkness...", french="C'était donc vrai...[K] Le futur\nest plongé dans une ombre abyssale...", german="Es ist wahr...[K] Die Zukunft\nist wirklich eine Welt der Dunkelheit.", italian="Era la verità...[K] Il futuro è\ndavvero un mondo d'oscurità...", spanish="Era cierto...[K] El futuro es\nrealmente un mundo de oscuridad..."})
  else
  SkySceneKit.say({english="It was true...[K] The future really\nis a world of darkness...", french="C'était donc vrai...[K] Le futur\nest plongé dans une ombre abyssale...", german="Es ist wahr...[K] Die Zukunft\nist wirklich eine Welt der Dunkelheit.", italian="Era la verità...[K] Il futuro è\ndavvero un mondo d'oscurità...", spanish="Era cierto...[K] El futuro es\nrealmente un mundo de oscuridad..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[K]That cluster of lights...", french=" ...[K] Ce groupe de lumières...", german=" ...[K]Diese Lichtergruppe...", italian=" ...[K] Quelle luci...", spanish=" Fíjate...[K] Esas luces de allí..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[K]That cluster of lights...", french=" ...[K] Ce groupe de lumières...", german=" ...[K]Diese Lichtergruppe...", italian=" ...[K] Quelle luci...", spanish=" Fíjate...[K] Esas luces de allí..."})
  else
  SkySceneKit.say({english=" ...[K]That cluster of lights...", french=" ...[K] Ce groupe de lumières...", german=" ...[K]Diese Lichtergruppe...", italian=" ...[K] Quelle luci...", spanish=" Fíjate...[K] Esas luces de allí..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's beautiful, but...", french=" C'est beau, mais...", german=" Sie ist schön, aber...", italian=" È bellissimo, ma...", spanish=" Son hermosas, pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's beautiful, but...", french=" C'est beau, mais...", german=" Sie ist schön, aber...", italian=" È bellissimo, ma...", spanish=" Son hermosas, pero..."})
  else
  SkySceneKit.say({english=" It's beautiful, but...", french=" C'est beau, mais...", german=" Sie ist schön, aber...", italian=" È bellissimo, ma...", spanish=" Son hermosas, pero..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Those lights...[K] Isn't that...[K]\nthe stockade?", french="Ce sont...[K] les lumières de...[K]\nla Cour des Condamnés, non?", german="Kommen diese Lichter...[K] nicht\naus dem...[K] Gefangenenraum?", italian="Quelle luci...[K] Quella non è...[K]\nla Sala Punizioni?", spanish="Esas luces...[K] ¿No son las de...?[K]\n¿Las de ese sitio donde nos tenían prisioneros?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Those lights...[K] Isn't that...[K]\nthe stockade?", french="Ce sont...[K] les lumières de...[K]\nla Cour des Condamnés, non?", german="Kommen diese Lichter...[K] nicht\naus dem...[K] Gefangenenraum?", italian="Quelle luci...[K] Quella non è...[K]\nla Sala Punizioni?", spanish="Esas luces...[K] ¿No son las de...?[K]\n¿Las de ese sitio donde nos tenían prisioneros?"})
  else
  SkySceneKit.say({english="Those lights...[K] Isn't that...[K]\nthe stockade?", french="Ce sont...[K] les lumières de...[K]\nla Cour des Condamnés, non?", german="Kommen diese Lichter...[K] nicht\naus dem...[K] Gefangenenraum?", italian="Quelle luci...[K] Quella non è...[K]\nla Sala Punizioni?", spanish="Esas luces...[K] ¿No son las de...?[K]\n¿Las de ese sitio donde nos tenían prisioneros?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(90)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [hero]...", french=" Dis, [hero]...", german=" Hey, [hero]...", italian=" Ehi, [hero]...", spanish=" Oye, [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey, [hero]...", french=" Dis, [hero]...", german=" Hey, [hero]...", italian=" Ehi, [hero]...", spanish=" Oye, [hero]..."})
  else
  SkySceneKit.say({english=" Say, [hero]...", french=" Dis, [hero]...", german=" Sag mal, [hero]...", italian=" Senti, [hero]...", spanish=" Oye, [hero]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The great [CS:N]Dusknoir[CR] saved us\nmore than once.", french="Le grand [CS:N]Noctunoir[CR] est venu\nnous sauver plus d'une fois.", german="Der große [CS:N]Zwirrfinst[CR] hat uns\nmehr als einmal gerettet.", italian="Il grande [CS:N]Dusknoir[CR] ci ha salvato\npiù di una volta.", spanish="El gran [CS:N]Dusknoir[CR] nos salvó\nen más de una ocasión."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The great [CS:N]Dusknoir[CR] saved us\nmore than once.", french="Le grand [CS:N]Noctunoir[CR] est venu\nnous sauver plus d'une fois.", german="Der große [CS:N]Zwirrfinst[CR] hat uns\nmehr als einmal gerettet.", italian="Il grande [CS:N]Dusknoir[CR] ci ha salvato\npiù di una volta.", spanish="El gran [CS:N]Dusknoir[CR] nos salvó\nen más de una ocasión."})
  else
  SkySceneKit.say({english="The great [CS:N]Dusknoir[CR] saved us\nmore than once.", french="Le grand [CS:N]Noctunoir[CR] est venu\nnous sauver plus d'une fois.", german="Der große [CS:N]Zwirrfinst[CR] hat uns\nmehr als einmal gerettet.", italian="Il grande [CS:N]Dusknoir[CR] è venuto in\nnostro aiuto più di una volta.", spanish="El gran [CS:N]Dusknoir[CR] nos salvó\nen más de una ocasión."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" He taught us many things too.", french="Et nous avons beaucoup appris\nà son contact.", german=" Und er hat uns viel beigebracht.", italian=" Ci ha anche insegnato tante cose.", spanish="También nos enseñó muchas\ncosas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" He taught us many things too.", french="Et nous avons beaucoup appris\nà son contact.", german=" Und er hat uns viel beigebracht.", italian=" Ci ha anche insegnato tante cose.", spanish="También nos enseñó muchas\ncosas."})
  else
  SkySceneKit.say({english=" He taught us many things too.", french="Et nous avons beaucoup appris\nà son contact.", german=" Und er hat uns viel beigebracht.", italian=" Ci ha anche insegnato tante cose.", spanish="También nos enseñó muchas\ncosas."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's why I...[K]I really looked up\nto [CS:N]Dusknoir[CR].", french="C'est pour ça que...[K] j'avais\nbeaucoup d'admiration pour [CS:N]Noctunoir[CR].", german="Darum[K] habe ich wirklich zu\n[CS:N]Zwirrfinst[CR] aufgesehen.", italian="È per questo che...[K] ammiravo\ndavvero [CS:N]Dusknoir[CR].", spanish=" Por eso yo...[K] Yo lo admiraba."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's why I...[K]I came to really\nrespect [CS:N]Dusknoir[CR].", french="C'est pour ça que...[K] j'avais\nbeaucoup d'admiration pour [CS:N]Noctunoir[CR].", german="Darum[K] habe ich [CS:N]Zwirrfinst[CR]\nwirklich respektiert.", italian="È per questo che...[K] ammiravo\ndavvero [CS:N]Dusknoir[CR].", spanish=" Por eso yo...[K] Yo lo admiraba."})
  else
  SkySceneKit.say({english="That's why I...[K]I really looked up\nto [CS:N]Dusknoir[CR].", french="C'est pour ça que...[K] j'avais\nbeaucoup d'admiration pour [CS:N]Noctunoir[CR].", german="Darum[K] habe ich wirklich zu\n[CS:N]Zwirrfinst[CR] aufgesehen.", italian="È per questo che...[K] ammiravo\ndavvero [CS:N]Dusknoir[CR].", spanish=" Por eso yo...[K] Yo lo admiraba."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But was [CS:N]Dusknoir[CR]...[K]deceiving us?", french="Mais se pourrait-il qu'il\nse soit...[K] joué de nous?", german="Aber hat [CS:N]Zwirrfinst[CR][K] uns\ngetäuscht?", italian="Ma [CS:N]Dusknoir[CR]...[K] ci stava\ningannando?", spanish="Pero, ¿y si [CS:N]Dusknoir[CR]...?[K] ¿Y si\nnos estaba engañando?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But was [CS:N]Dusknoir[CR]...[K]deceiving us?", french="Mais se pourrait-il qu'il\nse soit...[K] joué de nous?", german="Aber hat [CS:N]Zwirrfinst[CR][K] uns\ngetäuscht?", italian="Ma [CS:N]Dusknoir[CR]...[K] ci stava\ningannando?", spanish="Pero, ¿y si [CS:N]Dusknoir[CR]...?[K] ¿Y si\nnos estaba engañando?"})
  else
  SkySceneKit.say({english=" But was [CS:N]Dusknoir[CR]...[K]deceiving us?", french="Mais se pourrait-il qu'il\nse soit...[K] joué de nous?", german="Aber hat [CS:N]Zwirrfinst[CR][K] uns\ngetäuscht?", italian="Ma [CS:N]Dusknoir[CR]...[K] ci stava\ningannando?", spanish="Pero, ¿y si [CS:N]Dusknoir[CR]...?[K] ¿Y si\nnos estaba engañando?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Even after all this...[K]I still can't\nbelieve it.", french="Même après tout ce qui s'est\npassé...[K] je n'arrive toujours pas à y croire.", german="Selbst nach all dem...[K] Ich kann\nes noch immer nicht glauben.", italian="Ancora adesso...[K] stento a\ncrederci.", spanish="Incluso después de lo que\nha pasado...[K] me cuesta creerlo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Even after all this...[K]I still can't\nbelieve it.", french="Même après tout ce qui s'est\npassé...[K] je n'arrive toujours pas à y croire.", german="Selbst nach all dem...[K] Ich kann\nes noch immer nicht glauben.", italian="Ancora adesso...[K] stento a\ncrederci.", spanish="Incluso después de lo que\nha pasado...[K] me cuesta creerlo."})
  else
  SkySceneKit.say({english="Even after all this...[K]I still can't\nbelieve it.", french="Même après tout ce qui s'est\npassé...[K] je n'arrive toujours pas à y croire.", german="Selbst nach all dem...[K] Ich kann\nes noch immer nicht glauben.", italian="Ancora adesso...[K] stento a\ncrederci.", spanish="Incluso después de lo que\nha pasado...[K] me cuesta creerlo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I don't know what to believe\nanymore...", french="Je ne sais plus ce que je dois\npenser...", german="Ich weiß nicht mehr, was ich\nglauben soll...", italian=" Non so più a cosa credere...", spanish=" Ya no sé qué pensar..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I don't know what to believe\nanymore...", french="Je ne sais plus ce que je dois\npenser...", german="Ich weiß nicht mehr, was ich\nglauben soll...", italian=" Non so più a cosa credere...", spanish=" Ya no sé qué pensar..."})
  else
  SkySceneKit.say({english="I don't know what to believe\nanymore...", french="Je ne sais plus ce que je dois\npenser...", german="Ich weiß nicht mehr, was ich\nglauben soll...", italian=" Non so più a cosa credere...", spanish=" Ya no sé qué pensar..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" My head feels all messed up...", french="Je n'arrive pas à mettre de\nl'ordre dans mes idées...", german=" Mir schwirrt der Kopf...", italian="In testa ho una gran\nconfusione...", spanish=" Estoy hecho un lío..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I'm feeling all jumbled up...", french="Je n'arrive pas à mettre de\nl'ordre dans mes idées...", german=" Ich bin ganz durcheinander...", italian=" Sono davvero confuso...", spanish=" Estoy hecho un lío..."})
  else
  SkySceneKit.say({english=" I'm feeling all jumbled up...", french="Je n'arrive pas à mettre de\nl'ordre dans mes idées...", german=" Ich bin ganz durcheinander...", italian=" Sono davvero confusa...", spanish=" Estoy hecha un lío..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner]...)", french="([partner]...)", german="([partner]...)", italian="([partner]...)", spanish="([partner]...)"})
  else
  SkySceneKit.say({english="([partner]...)", french="([partner]...)", german="([partner]...)", italian="([partner]...)", spanish="([partner]...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What should we...[K] What should\nwe do now?", french="Qu'est-ce que...[K] qu'est-ce qu'on\nfait maintenant?", german="Was sollen wir...[K]\nWas sollen wir jetzt tun?", italian="Cosa possiamo...[K] Cosa possiamo\nfare adesso?", spanish="¿Qué deberíamos...?[K]\n¿Qué deberíamos hacer ahora?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What should we...[K] What should\nwe do now?", french="Qu'est-ce que...[K] qu'est-ce qu'on\nfait maintenant?", german="Was sollen wir...[K]\nWas sollen wir jetzt tun?", italian="Cosa possiamo...[K] Cosa possiamo\nfare adesso?", spanish="¿Qué deberíamos...?[K]\n¿Qué deberíamos hacer ahora?"})
  else
  SkySceneKit.say({english="What should we...[K] What should\nwe do now?", french="Qu'est-ce que...[K] qu'est-ce qu'on\nfait maintenant?", german="Was sollen wir...[K]\nWas sollen wir jetzt tun?", italian="Cosa possiamo...[K] Cosa possiamo\nfare adesso?", spanish="¿Qué deberíamos...?[K]\n¿Qué deberíamos hacer ahora?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" When can we stop running?", french="Jusqu'où on va devoir courir\ncomme ça, à la fin?", german="Wie lange müssen wir noch\nlaufen?", italian="Quando potremo smettere di\ncorrere?", spanish="¿Cuándo podremos dejar de\nhuir?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" How far do we have to run?", french="Jusqu'où on va devoir courir\ncomme ça, à la fin?", german="Wie weit müssen wir noch\nlaufen?", italian="Per quanto tempo dobbiamo\ncontinuare a scappare?", spanish="¿Cuándo podremos dejar de\nhuir?"})
  else
  SkySceneKit.say({english=" Can we ever stop running?", french="Jusqu'où on va devoir courir\ncomme ça, à la fin?", german="Wann können wir endlich\naufhören, wegzulaufen?", italian=" Smetteremo mai di correre?", spanish="¿Cuándo podremos dejar de\nhuir?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Can we return to our world?", french="Comment on fait pour rentrer\nchez nous?", german="Können wir in unsere Welt\nzurück?", italian="Potremo tornare nel nostro\nmondo?", spanish="¿Lograremos volver a nuestro\nmundo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="How do we go back to our\nown world?", french="Comment on fait pour rentrer\nchez nous?", german="Wie kommen wir wieder in\nunsere eigene Welt?", italian="Come torneremo nel nostro\nmondo?", spanish="¿Cómo podremos volver a\nnuestro mundo?"})
  else
  SkySceneKit.say({english="How do we go back to our\nown world?", french="Comment on fait pour rentrer\nchez nous?", german="Wie kommen wir wieder in\nunsere eigene Welt?", italian="Come torneremo nel nostro\nmondo?", spanish="¿Cómo podremos volver a\nnuestro mundo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  else
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Everyone at the guild...[K] I wonder\nhow they're doing?", french="Et les autres à la Guilde...[K]\nje me demande comment ils vont.", german="Die anderen unserer Gilde...[K]\nWie es ihnen wohl geht?", italian="I membri della Gilda...[K]\nMi chiedo come stiano...", spanish="Y nuestros amigos del\n[CS:N]Pokégremio[CR]...[K] Me pregunto qué habrá sido de\nellos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Everyone at the guild...[K] I wonder\nhow they're doing?", french="Et les autres à la Guilde...[K]\nje me demande comment ils vont.", german="Die anderen unserer Gilde...[K]\nWie es ihnen wohl geht?", italian="I membri della Gilda...[K]\nMi chiedo come stiano...", spanish="Y nuestros amigos del\n[CS:N]Pokégremio[CR]...[K] Me pregunto qué habrá sido de\nellos."})
  else
  SkySceneKit.say({english="Everyone at the guild...[K] I wonder\nhow they're doing?", french="Et les autres à la Guilde...[K]\nje me demande comment ils vont.", german="Die anderen unserer Gilde...[K]\nWie es ihnen wohl geht?", italian="I membri della Gilda...[K]\nMi chiedo come stiano...", spanish="Y nuestros amigos del\n[CS:N]Pokégremio[CR]...[K] Me pregunto qué habrá sido de\nellos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Are they worried about us\nbeing gone?", french="Tu crois qu'ils s'inquiètent\npour nous?", german="Ob sie sich Sorgen um uns\nmachen?", italian=" Saranno preoccupati per noi?", spanish="¿Qué habrán pensado de nuestra\ndesaparición?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are they worried about us?", french="Tu crois qu'ils s'inquiètent\npour nous?", german="Ob sie sich Sorgen um uns\nmachen?", italian=" Saranno preoccupati per noi?", spanish="¿Qué habrán pensado de nuestra\ndesaparición?"})
  else
  SkySceneKit.say({english="The way we disappeared...\nAre they worried about us?", french="Tu crois qu'ils s'inquiètent\npour nous?", german="Nachdem wir verschwunden\nsind... Ob sie sich Sorgen um uns machen?", italian="La nostra strana scomparsa...\nSaranno preoccupati per noi?", spanish="¿Les habrá preocupado nuestra\ndesaparición?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Wigglytuff[CR], [CS:N]Chatot[CR], [CS:N]Bidoof[CR], and\neveryone else...[K] I wonder if they're doing well?", french="[CS:N]Grodoudou[CR], [CS:N]Pijako[CR], [CS:N]Keunotor[CR]\net les autres...[K] Je me demande s'ils vont bien.", german="[CS:N]Knuddeluff[CR], [CS:N]Plaudagei[CR], [CS:N]Bidiza[CR] und\nalle anderen...[K] Ob es ihnen gut geht?", italian="[CS:N]Wigglytuff[CR], [CS:N]Chatot[CR], [CS:N]Bidoof[CR], e\ntutti gli altri...[K] staranno bene?", spanish="Me pregunto si [CS:N]Wigglytuff[CR],\n[CS:N]Chatot[CR], [CS:N]Bidoof[CR] y los demás...[K] estarán bien."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Wigglytuff[CR], [CS:N]Chatot[CR], [CS:N]Bidoof[CR], and\neveryone else...[K] I wonder if they're doing well?", french="[CS:N]Grodoudou[CR], [CS:N]Pijako[CR], [CS:N]Keunotor[CR]\net les autres...[K] Je me demande s'ils vont bien.", german="[CS:N]Knuddeluff[CR], [CS:N]Plaudagei[CR], [CS:N]Bidiza[CR] und\nalle anderen...[K] Ob es ihnen gut geht?", italian="[CS:N]Wigglytuff[CR], [CS:N]Chatot[CR], [CS:N]Bidoof[CR], e\ntutti gli altri...[K] staranno bene?", spanish="Me pregunto si [CS:N]Wigglytuff[CR],\n[CS:N]Chatot[CR], [CS:N]Bidoof[CR] y los demás...[K] estarán bien."})
  else
  SkySceneKit.say({english="[CS:N]Wigglytuff[CR], [CS:N]Chatot[CR], [CS:N]Bidoof[CR], and\neveryone else...[K] I wonder if they're doing well?", french="[CS:N]Grodoudou[CR], [CS:N]Pijako[CR], [CS:N]Keunotor[CR]\net les autres...[K] Je me demande s'ils vont bien.", german="[CS:N]Knuddeluff[CR], [CS:N]Plaudagei[CR], [CS:N]Bidiza[CR] und\nalle anderen...[K] Ob es ihnen gut geht?", italian="[CS:N]Wigglytuff[CR], [CS:N]Chatot[CR], [CS:N]Bidoof[CR], e\ntutti gli altri...[K] staranno bene?", spanish="Me pregunto si [CS:N]Wigglytuff[CR],\n[CS:N]Chatot[CR], [CS:N]Bidoof[CR] y los demás...[K] estarán bien."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I m-m-miss the guild...[K] I want\nto see everyone!", french="La Guilde me manque tellement,\nsnif...[K] Je meurs d'envie de tous les revoir!", german="Ich v-v-vermisse die Gilde...[K]\nIch will alle wiedersehen!", italian="Mi manca la Gilda...[K] Voglio\nvedere tutti gli altri!", spanish="Echo... Echo de menos el\n[CS:N]Pokégremio[CR]...[K] ¡Quiero estar con mis amigos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I m-m-miss the guild...[K] I want\nto see everyone!", french="La Guilde me manque tellement,\nsnif...[K] Je meurs d'envie de tous les revoir!", german="Ich v-v-vermisse die Gilde...[K]\nIch will alle wiedersehen!", italian="Mi manca la Gilda...[K] Voglio\nvedere tutti gli altri!", spanish="Echo... Echo de menos el\n[CS:N]Pokégremio[CR]...[K] ¡Quiero estar con mis amigos!"})
  else
  SkySceneKit.say({english="I m-m-miss the guild...[K] I want\nto see everyone!", french="La Guilde me manque tellement,\nsnif...[K] Je meurs d'envie de tous les revoir!", german="Ich v-v-vermisse die Gilde...[K]\nIch will alle wiedersehen!", italian="Mi manca la Gilda...[K] Voglio\nvedere tutti gli altri!", spanish="Echo... Echo de menos el\n[CS:N]Pokégremio[CR]...[K] ¡Quiero estar con mis amigos!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner]'s feeling pretty down.)", french="([partner] a l'air d'avoir le moral à zéro.)", german="([partner] ist ziemlich fertig.)", italian="([partner] è piuttosto giù di morale.)", spanish="(Parece que a [partner] le ha afectado\nmucho lo que ha pasado.)"})
  else
  SkySceneKit.say({english="([partner]'s feeling pretty down.)", french="([partner] a l'air d'avoir le moral à zéro.)", german="([partner] ist ziemlich fertig.)", italian="([partner] è piuttosto giù di morale.)", spanish="(Parece que a [partner] le ha afectado\nmucho lo que ha pasado.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's only natural.)", french="(Ça se comprend.)", german="(Das ist nur natürlich.)", italian="(È naturale.)", spanish="(Es normal, claro.)"})
  else
  SkySceneKit.say({english="(It's only natural.)", french="(Ça se comprend.)", german="(Das ist nur natürlich.)", italian="(È naturale.)", spanish="(Es normal, claro.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What's happened so far...[K] It's all so hard\nto believe.)", french="(Toute cette histoire...[K] c'est si difficile\nà croire.)", german="(Was bisher passiert ist,[K] ist wirklich schwer\nzu begreifen.)", italian="(Tutto quello che è successo finora...[K] è così\ndifficile da credere.)", spanish="(Lo que ha ocurrido hasta ahora...[K]\nresulta muy difícil de asimilar.)"})
  else
  SkySceneKit.say({english="(What's happened so far...[K] It's all so hard\nto believe.)", french="(Toute cette histoire...[K] c'est si difficile\nà croire.)", german="(Was bisher passiert ist,[K] ist wirklich schwer\nzu begreifen.)", italian="(Tutto quello che è successo finora...[K] è così\ndifficile da credere.)", spanish="(Lo que ha ocurrido hasta ahora...[K]\nresulta muy difícil de asimilar.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I'm...[K]scared too.)", french="(Moi aussi...[K] j'ai peur.)", german="(Ich...[K] Ich habe auch Angst.)", italian="(Anch'io...[K] sono spaventato.)", spanish="(Yo también...[K] estoy asustado.)"})
  else
  SkySceneKit.say({english="(I'm...[K]scared too.)", french="(Moi aussi...[K] j'ai peur.)", german="(Ich...[K] Ich habe auch Angst.)", italian="(Anch'io...[K] sono spaventata.)", spanish="(Yo también...[K] estoy asustada.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But...[K]I can't give up now.)", french="(Mais...[K] je n'ai pas le droit de baisser\nles bras.)", german="(Aber...[K] Ich darf jetzt nicht aufgeben.)", italian="(Ma...[K] non posso mollare adesso.)", spanish="(Pero...[K] no puedo rendirme ahora.)"})
  else
  SkySceneKit.say({english="(But...[K]I can't give up now.)", french="(Mais...[K] je n'ai pas le droit de baisser\nles bras.)", german="(Aber...[K] Ich darf jetzt nicht aufgeben.)", italian="(Ma...[K] non posso mollare adesso.)", spanish="(Pero...[K] no puedo rendirme ahora.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(If we don't keep going, those [CS:N]Sableye[CR] will\ncatch us.)", french="(Si on n'avance pas, les [CS:N]Ténéfix[CR] vont nous\nrattraper.)", german="(Wenn wir aufgeben, werden uns die [CS:N]Zobiris[CR]\nfangen.)", italian="(Se non ce la mettiamo tutta, quei [CS:N]Sableye[CR]\nci prenderanno.)", spanish="(Si no seguimos adelante, esos [CS:N]Sableye[CR] nos\natraparán.)"})
  else
  SkySceneKit.say({english="(If we don't keep going, those [CS:N]Sableye[CR] will\ncatch us.)", french="(Si on n'avance pas, les [CS:N]Ténéfix[CR] vont nous\nrattraper.)", german="(Wenn wir aufgeben, werden uns die [CS:N]Zobiris[CR]\nfangen.)", italian="(Se non ce la mettiamo tutta, quei [CS:N]Sableye[CR]\nci prenderanno.)", spanish="(Si no seguimos adelante, esos [CS:N]Sableye[CR] nos\natraparán.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I've got to do something to cheer up\n[partner].)", french="(Il faut que je fasse quelque chose pour\nremonter le moral de [partner].)", german="(Ich muss [partner] irgendwie aufheitern.)", italian="(Devo fare qualcosa per tirare su il morale a\n[partner].)", spanish="(Tengo que hacer algo para animar a\n[partner].)"})
  else
  SkySceneKit.say({english="(I've got to do something to cheer up\n[partner].)", french="(Il faut que je fasse quelque chose pour\nremonter le moral de [partner].)", german="(Ich muss [partner] irgendwie aufheitern.)", italian="(Devo fare qualcosa per tirare su il morale a\n[partner].)", spanish="(Tengo que hacer algo para animar a\n[partner].)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But words of support will seem like false\ncomfort right now...)", french="(Mais des paroles d'encouragement seraient\nun bien maigre réconfort dans la situation\nactuelle...)", german="(Aber aufheiternde Worte wären jetzt kein\nrichtiger Trost.)", italian="(Ma parole di conforto ora suonerebbero\nfalse...)", spanish="(Pero que no suene demasiado forzado...)"})
  else
  SkySceneKit.say({english="(But words of support will seem like false\ncomfort right now...)", french="(Mais des paroles d'encouragement seraient\nun bien maigre réconfort dans la situation\nactuelle...)", german="(Aber aufheiternde Worte wären jetzt kein\nrichtiger Trost.)", italian="(Ma parole di conforto ora suonerebbero\nfalse...)", spanish="(Pero que no suene demasiado forzado...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(If there were something I could say...[K]\nSomething that offers a glimmer of hope...)", french="(S'il y avait quelque chose que je puisse\ndire...[K] quelque chose qui lui redonne\ncourage...)", german="(Wenn ich nur etwas sagen könnte...[K]\nEtwas, das wirklich Hoffnung gibt...)", italian="(Se ci fosse qualcosa da poter dire...[K]\nQualcosa che offra un barlume di speranza...)", spanish="(Si tuviéramos alguna esperanza...[K]\nalguna razón de peso para seguir adelante...)"})
  else
  SkySceneKit.say({english="(If there were something I could say...[K]\nSomething that offers a glimmer of hope...)", french="(S'il y avait quelque chose que je puisse\ndire...[K] quelque chose qui lui redonne\ncourage...)", german="(Wenn ich nur etwas sagen könnte...[K]\nEtwas, das wirklich Hoffnung gibt...)", italian="(Se ci fosse qualcosa da poter dire...[K]\nQualcosa che offra un barlume di speranza...)", spanish="(Si tuviéramos alguna esperanza...[K]\nalguna razón de peso para seguir adelante...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(If only there were some hope, we could work\ntoward it...)", french="(Si seulement il y avait un espoir, on pourrait\ns'y raccrocher...)", german="(Wenn es nur einen Hoffnungsschimmer gäbe,\nkönnten wir uns daran festhalten...)", italian="(Se solo ci fosse una piccola speranza,\npotremmo lavorarci su...)", spanish="(Cuando tienes un objetivo, puedes centrarte\nen alcanzarlo y olvidar lo demás...)"})
  else
  SkySceneKit.say({english="(If only there were some hope, we could work\ntoward it...)", french="(Si seulement il y avait un espoir, on pourrait\ns'y raccrocher...)", german="(Wenn es nur einen Hoffnungsschimmer gäbe,\nkönnten wir uns daran festhalten...)", italian="(Se solo ci fosse una piccola speranza,\npotremmo lavorarci su...)", spanish="(Cuando tienes un objetivo, puedes centrarte\nen alcanzarlo y olvidar lo demás...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It could be anything.[K] I just need to think\nof something!)", french="(N'importe quoi.[K] Je vais bien finir par\ntrouver quelque chose!)", german="(Egal, was...[K] Mir muss etwas einfallen!)", italian="(Potrebbe essere qualunque cosa.[K] Devo solo\nfarmi venire in mente qualcosa!)", spanish="(Cualquier cosa me serviría.[K]\n¡Tengo que pensar en algo!)"})
  else
  SkySceneKit.say({english="(It could be anything.[K] I just need to think\nof something!)", french="(N'importe quoi.[K] Je vais bien finir par\ntrouver quelque chose!)", german="(Egal, was...[K] Mir muss etwas einfallen!)", italian="(Potrebbe essere qualunque cosa.[K] Devo solo\nfarmi venire in mente qualcosa!)", spanish="(Cualquier cosa me serviría.[K]\n¡Tengo que pensar en algo!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 276, 148, false, 1)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?", french=" Hein?", german=" Ähem?", italian=" Eh?", spanish=" ¿Eh?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hmm?", french=" Hein?", german=" Hmm?", italian=" Mmm?", spanish=" ¿Eh?"})
  else
  SkySceneKit.say({english=" Oh?", french=" Hein?", german=" Hey?", italian=" Oh?", spanish=" ¿Eh?"})
  end
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What's up, [hero]?", french="Qu'est-ce qui se passe,\n[hero]?", german=" Was ist los, [hero]?", italian=" Cosa c'è, [hero]?", spanish=" ¿Qué pasa, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What is it, [hero]?", french="Qu'est-ce qui se passe,\n[hero]?", german=" Was ist denn, [hero]?", italian=" Cosa c'è, [hero]?", spanish=" ¿Qué pasa, [hero]?"})
  else
  SkySceneKit.say({english=" What is it, [hero]?", french="Qu'est-ce qui se passe,\n[hero]?", german=" Was ist denn, [hero]?", italian=" Cosa c'è, [hero]?", spanish=" ¿Qué pasa, [hero]?"})
  end
  do local __choice = SkySceneKit.ask({{english="Let's find [CS:N]Grovyle[CR]!", french="Allons trouver [CS:N]Massko[CR]!", german="Lass uns [CS:N]Reptain[CR] suchen!", italian="Troviamo [CS:N]Grovyle[CR]!", spanish="¡Hay que encontrar a [CS:N]Grovyle[CR]!"}, {english="Let's return to our world!", french="Retournons chez nous!", german="Auf in unsere Welt!", italian="Torniamo nel nostro mondo!", spanish="¡Tenemos que volver a casa!"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?![K] Let's return to our world?", french=" Pardon?![K] Retourner chez nous?", german="Ähem?!?[K] In unsere Welt\nzurückkehren?", italian="Eh?![K] Tornare nel nostro\nmondo?", spanish="¡¿Qué?![K] ¿Quieres que\nregresemos a casa?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What?![K] Let's return to\nour world?", french=" Pardon?![K] Retourner chez nous?", german="Was?!?[K] In unsere Welt\nzurückkehren?", italian="Cosa?![K] Tornare nel nostro\nmondo?", spanish="¡¿Qué?![K] ¿Quieres que\nregresemos a casa?"})
  else
  SkySceneKit.say({english="Pardon?![K] Let's return to\nour world?", french=" Pardon?![K] Retourner chez nous?", german="Wie?!?[K] In unsere Welt\nzurückkehren?", italian="Scusa?![K] Tornare nel nostro\nmondo?", spanish="¡¿Qué?![K] ¿Quieres que\nregresemos a casa?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" How are we supposed to return?", french="Et comment on fait pour\nrentrer?", german=" Wie sollen wir zurückkehren?", italian=" Come pensi di ritornare?", spanish=" ¿Y cómo vamos a volver?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" How are we supposed to return?", french="Et comment on fait pour\nrentrer?", german=" Wie sollen wir zurückkehren?", italian=" Come pensi di ritornare?", spanish=" ¿Y cómo vamos a volver?"})
  else
  SkySceneKit.say({english=" How are we supposed to return?", french="Et comment on fait pour\nrentrer?", german=" Wie sollen wir zurückkehren?", italian=" Come pensi di ritornare?", spanish=" ¿Y cómo vamos a volver?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Well, sure, it would be great if\nwe could go back to our world...", french="Bien sûr, ce serait formidable\nde pouvoir rentrer chez nous...", german="Ich meine, es wäre toll, in\nunsere Welt zurückzukehren...", italian="Beh, certo, sarebbe grandioso se\npotessimo tornare nel nostro mondo...", spanish="Sería genial encontrar la forma\nde volver a nuestro mundo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well, sure, it would be great if\nwe could go back to our world...", french="Bien sûr, ce serait formidable\nde pouvoir rentrer chez nous...", german="Ich meine, es wäre toll, in\nunsere Welt zurückzukehren...", italian="Beh, certo, sarebbe grandioso se\npotessimo tornare nel nostro mondo...", spanish="Sería genial encontrar la forma\nde volver a nuestro mundo..."})
  else
  SkySceneKit.say({english="Well, sure, it would be great if\nwe could go back to our world...", french="Bien sûr, ce serait formidable\nde pouvoir rentrer chez nous...", german="Ich meine, es wäre toll, in\nunsere Welt zurückzukehren...", italian="Beh, certo, sarebbe grandioso se\npotessimo tornare nel nostro mondo...", spanish="Sería genial encontrar la forma\nde volver a nuestro mundo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But...how?", french=" Mais... comment?", german=" Aber wie?", italian=" Ma... come?", spanish=" Pero... ¿cómo lo haremos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But...how?", french=" Mais... comment?", german=" Aber wie?", italian=" Ma... come?", spanish=" Pero... ¿cómo lo haremos?"})
  else
  SkySceneKit.say({english=" But...how?", french=" Mais... comment?", german=" Aber wie?", italian=" Ma... come?", spanish=" Pero... ¿cómo lo haremos?"})
  end
  -- message_Close
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Huh?[K] We're going to first find\n[CS:N]Grovyle[CR]?", french="Hein?[K] On retrouve d'abord\n[CS:N]Massko[CR]?", german="Äh?[K] Wir müssen\nerst [CS:N]Reptain[CR] finden?", italian="Eh?[K] Prima andiamo a cercare\n[CS:N]Grovyle[CR]?", spanish="¿Qué?[K] ¿Que vamos a buscar\nprimero a [CS:N]Grovyle[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What?[K] We're going to first find\n[CS:N]Grovyle[CR]?", french="Hein?[K] On retrouve d'abord\n[CS:N]Massko[CR]?", german="Was?[K] Wir müssen\nerst [CS:N]Reptain[CR] finden?", italian="Eh?[K] Prima andiamo a cercare\n[CS:N]Grovyle[CR]?", spanish="¿Qué?[K] ¿Que vamos a buscar\nprimero a [CS:N]Grovyle[CR]?"})
  else
  SkySceneKit.say({english="Pardon?[K] We're going to first\nfind [CS:N]Grovyle[CR]?", french="Hein?[K] On retrouve d'abord\n[CS:N]Massko[CR]?", german="Wie?[K] Wir müssen\nerst [CS:N]Reptain[CR] finden?", italian="Eh?[K] Prima andiamo a cercare\n[CS:N]Grovyle[CR]?", spanish="¿Qué?[K] ¿Que vamos a buscar\nprimero a [CS:N]Grovyle[CR]?"})
  end
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So we find [CS:N]Grovyle[CR]...[K]\nThen what?", french="Et ensuite quand on l'aura\nretrouvé...[K] on fera quoi?", german="Also suchen wir [CS:N]Reptain[CR]...[K]\nUnd dann?", italian="Allora cerchiamo [CS:N]Grovyle[CR]...[K]\nE poi cosa facciamo?", spanish="Supongamos que encontramos a\n[CS:N]Grovyle[CR]...[K] ¿Y luego qué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So if we do find [CS:N]Grovyle[CR]...[K]\nThen what?", french="Et ensuite quand on l'aura\nretrouvé...[K] on fera quoi?", german="Und wenn wir [CS:N]Reptain[CR] finden...[K]\nWas dann?", italian="Allora cerchiamo [CS:N]Grovyle[CR]...[K]\nE poi cosa facciamo?", spanish="Supongamos que encontramos a\n[CS:N]Grovyle[CR]...[K] ¿Y luego qué?"})
  else
  SkySceneKit.say({english="So if we do find [CS:N]Grovyle[CR]...[K]\nThen what?", french="Et ensuite quand on l'aura\nretrouvé...[K] on fera quoi?", german="Und wenn wir [CS:N]Reptain[CR] finden...[K]\nWas dann?", italian="Allora cerchiamo [CS:N]Grovyle[CR]...[K]\nE poi cosa facciamo?", spanish="Supongamos que encontramos a\n[CS:N]Grovyle[CR]...[K] ¿Y luego qué?"})
  end
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What?![K] You want to go after\n[CS:N]Grovyle[CR]?", french="Quoi?![K] Tu veux qu'on se lance\nsur les traces de [CS:N]Massko[CR]?", german="Was?!?[K] Du willst [CS:N]Reptain[CR]\nsuchen?", italian="Cosa?![K] Vuoi andare a cercare\n[CS:N]Grovyle[CR]?", spanish="¡¿Qué?![K] ¿Quieres encontrar a\n[CS:N]Grovyle[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What?![K] You want to go after\n[CS:N]Grovyle[CR]?", french="Quoi?![K] Tu veux qu'on se lance\nsur les traces de [CS:N]Massko[CR]?", german="Was?!?[K] Du willst [CS:N]Reptain[CR]\nsuchen?", italian="Cosa?![K] Vuoi andare a cercare\n[CS:N]Grovyle[CR]?", spanish="¡¿Qué?![K] ¿Quieres encontrar a\n[CS:N]Grovyle[CR]?"})
  else
  SkySceneKit.say({english="Pardon?![K] You want to go after\n[CS:N]Grovyle[CR]?", french="Quoi?![K] Tu veux qu'on se lance\nsur les traces de [CS:N]Massko[CR]?", german="Wie?!?[K] Du willst [CS:N]Reptain[CR]\nsuchen?", italian="Cosa?![K] Vuoi andare a cercare\n[CS:N]Grovyle[CR]?", spanish="¡¿Qué?![K] ¿Quieres encontrar a\n[CS:N]Grovyle[CR]?"})
  end
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-why?!", french=" Mais pour quoi faire?!", german=" W-warum?!?", italian=" P-Perché?!", spanish=" ¡¿Para qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-why?!", french=" Mais pour quoi faire?!", german=" W-warum?!?", italian=" P-Perché?!", spanish=" ¡¿Para qué?!"})
  else
  SkySceneKit.say({english=" Wh-why?!", french=" Mais pour quoi faire?!", german=" W-warum?!?", italian=" P-Perché?!", spanish=" ¡¿Para qué?!"})
  end
  -- @label_2 [étiquette de flux ExplorerScript]
  do local __choice = SkySceneKit.ask({{english="I want to ask him something!", french="J'ai quelque chose à lui demander!", german="Ich will ihn etwas fragen!", italian="Voglio chiedergli una cosa!", spanish="¡Quiero preguntarle algo!"}, {english="I want to know something!", french="Il y a une chose que je veux savoir!", german="Ich will etwas wissen!", italian="Voglio sapere una cosa!", spanish="¡Hay algo que quiero saber!"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You wanted to know something?", french=" Tu veux savoir quelque chose?", german=" Du willst etwas wissen?", italian=" Vuoi sapere una cosa?", spanish="¿Que hay algo que quieres\nsaber?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You wanted to know something?", french=" Tu veux savoir quelque chose?", german=" Du willst etwas wissen?", italian=" Vuoi sapere una cosa?", spanish="¿Que hay algo que quieres\nsaber?"})
  else
  SkySceneKit.say({english=" You wanted to know something?", french=" Tu veux savoir quelque chose?", german=" Du willst etwas wissen?", italian=" Vuoi sapere una cosa?", spanish="¿Que hay algo que quieres\nsaber?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh...[K]right...", french=" Ah...[K] d'accord...", german=" Oh. [K]Ach ja...", italian=" Ah...[K] Certo...", spanish=" Ah...[K] Claro..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh...[K]I see...", french=" Ah...[K] d'accord...", german=" Oh. [K]Verstehe...", italian=" Ah...[K] Capisco...", spanish=" Ah...[K] Claro..."})
  else
  SkySceneKit.say({english=" Oh...[K]I get it...", french=" Ah...[K] d'accord...", german=" Oh. [K]Richtig...", italian=" Ah...[K] Certo...", spanish=" Ah...[K] Claro..."})
  end
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ask him something?", french=" Quelque chose à lui demander?", german=" Ihn etwas fragen?", italian=" Chiedergli una cosa?", spanish=" ¿Preguntarle algo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ask him something?", french=" Quelque chose à lui demander?", german=" Ihn etwas fragen?", italian=" Chiedergli una cosa?", spanish=" ¿Preguntarle algo?"})
  else
  SkySceneKit.say({english=" Ask him something?", french=" Quelque chose à lui demander?", german=" Ihn etwas fragen?", italian=" Chiedergli una cosa?", spanish=" ¿Preguntarle algo?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh...[K]right...", french=" Ah...[K] d'accord...", german=" Oh. [K]Ach ja...", italian=" Ah...[K] Certo...", spanish=" Ah...[K] Claro..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh...[K]I see...", french=" Ah...[K] d'accord...", german=" Oh. [K]Verstehe...", italian=" Ah...[K] Capisco...", spanish=" Ah...[K] Claro..."})
  else
  SkySceneKit.say({english=" Oh...[K]I get it...", french=" Ah...[K] d'accord...", german=" Oh. [K]Richtig...", italian=" Ah...[K] Certo...", spanish=" Ah...[K] Claro..."})
  end
  -- @label_5 [étiquette de flux ExplorerScript]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Grovyle[CR] went to our world from\nhere the first time.", french="[CS:N]Massko[CR] a déjà fait le voyage\nentre cet endroit et notre monde.", german="[CS:N]Reptain[CR] ist schon einmal von\ndieser Welt in unsere gekommen.", italian="[CS:N]Grovyle[CR] la prima volta era\nvenuto nel presente da qui.", spanish="[CS:N]Grovyle[CR] viajó a nuestro mundo\ndesde aquí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Grovyle[CR] went to our world from\nhere the first time.", french="[CS:N]Massko[CR] a déjà fait le voyage\nentre cet endroit et notre monde.", german="[CS:N]Reptain[CR] ist schon einmal von\ndieser Welt in unsere gekommen.", italian="[CS:N]Grovyle[CR] la prima volta era\nvenuto nel presente da qui.", spanish="[CS:N]Grovyle[CR] viajó a nuestro mundo\ndesde aquí."})
  else
  SkySceneKit.say({english="[CS:N]Grovyle[CR] went to our world from\nhere the first time.", french="[CS:N]Massko[CR] a déjà fait le voyage\nentre cet endroit et notre monde.", german="[CS:N]Reptain[CR] ist schon einmal von\ndieser Welt in unsere gekommen.", italian="[CS:N]Grovyle[CR] la prima volta era\nvenuto nel presente da qui.", spanish="[CS:N]Grovyle[CR] viajó a nuestro mundo\ndesde aquí."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So [CS:N]Grovyle[CR] should know how\nto go to our world.", french="Donc il doit savoir comment\nfaire pour rentrer.", german="Also müsste [CS:N]Reptain[CR] wissen,\nwie man in unsere Welt kommt.", italian="Quindi [CS:N]Grovyle[CR] deve conoscere\nun modo per tornare nel nostro mondo.", spanish="¡Él debe de saber cómo ir a\nnuestro mundo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So [CS:N]Grovyle[CR] should know how\nto travel to our world.", french="Donc il doit savoir comment\nfaire pour rentrer.", german="Also müsste [CS:N]Reptain[CR] wissen,\nwie man in unsere Welt kommt.", italian="Quindi [CS:N]Grovyle[CR] deve conoscere\nun modo per tornare nel nostro mondo.", spanish="¡Él debe de saber cómo ir a\nnuestro mundo!"})
  else
  SkySceneKit.say({english="So [CS:N]Grovyle[CR] should know how\nto travel to our world.", french="Donc il doit savoir comment\nfaire pour rentrer.", german="Also müsste [CS:N]Reptain[CR] wissen,\nwie man in unsere Welt kommt.", italian="Quindi [CS:N]Grovyle[CR] deve conoscere\nun modo per tornare nel nostro mondo.", spanish="¡Él debe de saber cómo ir a\nnuestro mundo!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But...[K]isn't [CS:N]Grovyle[CR] a bad\nPokémon?", french="Mais...[K] [CS:N]Massko[CR] est un méchant\nPokémon, non?", german="Aber...[K] Ist [CS:N]Reptain[CR] nicht ein\nbösartiges Pokémon?", italian="Ma...[K] [CS:N]Grovyle[CR] non è un\nPokémon cattivo?", spanish="Pero...[K] ¿[CS:N]Grovyle[CR] no es\nun Pokémon malvado?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But...[K]isn't [CS:N]Grovyle[CR] a bad\nPokémon?", french="Mais...[K] [CS:N]Massko[CR] est un méchant\nPokémon, non?", german="Aber...[K] Ist [CS:N]Reptain[CR] nicht ein\nbösartiges Pokémon?", italian="Ma...[K] [CS:N]Grovyle[CR] non è un\nPokémon cattivo?", spanish="Pero...[K] ¿[CS:N]Grovyle[CR] no es\nun Pokémon malvado?"})
  else
  SkySceneKit.say({english="But...[K]isn't [CS:N]Grovyle[CR] a bad\nPokémon?", french="Mais...[K] [CS:N]Massko[CR] est un méchant\nPokémon, non?", german="Aber...[K] Ist [CS:N]Reptain[CR] nicht ein\nbösartiges Pokémon?", italian="Ma...[K] [CS:N]Grovyle[CR] non è un\nPokémon cattivo?", spanish="Pero...[K] ¿[CS:N]Grovyle[CR] no es\nun Pokémon malvado?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Didn't he...[K]come to our world to\nsteal the Time Gears?", french="S'il est venu dans notre\nmonde...[K] c'était pour voler les Rouages\ndu Temps?", german="Ist er nicht...[K] Ist er nicht in\nunsere Welt gekommen, um die Zahnräder der\nZeit zu stehlen?", italian="Non è venuto...[K] nel nostro\nmondo per rubare gli Ingranaggi del Tempo?", spanish="¿Acaso no vino a nuestro mundo\na robar los Engranajes del Tiempo?[K] ¿Eh?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Didn't he...[K]come to our world to\nsteal the Time Gears?", french="S'il est venu dans notre\nmonde...[K] c'était pour voler les Rouages\ndu Temps?", german="Ist er nicht...[K] Ist er nicht in\nunsere Welt gekommen, um die Zahnräder der\nZeit zu stehlen?", italian="Non è venuto...[K] nel nostro\nmondo per rubare gli Ingranaggi del Tempo?", spanish="¿Acaso no vino a nuestro mundo\na robar los Engranajes del Tiempo?[K] ¿Eh?"})
  else
  SkySceneKit.say({english="Didn't he...[K]come to our world to\nsteal the Time Gears?", french="S'il est venu dans notre\nmonde...[K] c'était pour voler les Rouages\ndu Temps?", german="Ist er nicht...[K] Ist er nicht in\nunsere Welt gekommen, um die Zahnräder der\nZeit zu stehlen?", italian="Non è venuto...[K] nel nostro\nmondo per rubare gli Ingranaggi del Tempo?", spanish="¿Acaso no vino a nuestro mundo\na robar los Engranajes del Tiempo?[K] ¿Eh?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="How could I trust anything that\nhe'd say?", french="Après ça, comment pourrais-je\ncroire un traître mot de ce qu'il dit?", german="Wie soll ich ihm irgendetwas\nglauben?", italian="Come posso credere a quello che\ndice?", spanish="¿Cómo vamos a confiar en lo\nque nos diga?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="How could I trust anything he\nwould say?", french="Après ça, comment pourrais-je\ncroire un traître mot de ce qu'il dit?", german="Wie soll ich ihm irgendetwas\nglauben?", italian="Come posso credere a quello che\ndice?", spanish="¿Cómo vamos a confiar en\ncualquier cosa que nos diga?"})
  else
  SkySceneKit.say({english="How am I supposed to trust\nanything he may say?", french="Après ça, comment pourrais-je\ncroire un traître mot de ce qu'il dit?", german="Wie soll ich ihm irgendetwas\nglauben?", italian="Come potrei credere a quello che\ndice?", spanish="¿Cómo vamos a confiar en\nsu palabra?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What about you, [hero]?", french="Qu'est-ce que tu en penses,\n[hero]?", german=" Was ist mit dir, [hero]?", italian=" E tu, [hero]?", spanish=" ¿Tú qué opinas, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What about you, [hero]?", french="Qu'est-ce que tu en penses,\n[hero]?", german=" Was ist mit dir, [hero]?", italian=" E tu, [hero]?", spanish=" ¿Tú qué opinas, [hero]?"})
  else
  SkySceneKit.say({english=" What about you, [hero]?", french="Qu'est-ce que tu en penses,\n[hero]?", german=" Was ist mit dir, [hero]?", italian=" E tu, [hero]?", spanish=" ¿Tú qué opinas, [hero]?"})
  end
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Do you trust [CS:N]Grovyle[CR],\n[hero]?", french="Tu as confiance en [CS:N]Massko[CR],\n[hero]?", german="Vertraust du [CS:N]Reptain[CR],\n[hero]?", italian="Tu credi a [CS:N]Grovyle[CR],\n[hero]?", spanish="¿Confías en [CS:N]Grovyle[CR],\n[hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Do you trust [CS:N]Grovyle[CR],\n[hero]?", french="Tu as confiance en [CS:N]Massko[CR],\n[hero]?", german="Vertraust du [CS:N]Reptain[CR],\n[hero]?", italian="Tu credi a [CS:N]Grovyle[CR],\n[hero]?", spanish="¿Confías en [CS:N]Grovyle[CR],\n[hero]?"})
  else
  SkySceneKit.say({english="Do you trust [CS:N]Grovyle[CR],\n[hero]?", french="Tu as confiance en [CS:N]Massko[CR],\n[hero]?", german="Vertraust du [CS:N]Reptain[CR],\n[hero]?", italian="Tu credi a [CS:N]Grovyle[CR],\n[hero]?", spanish="¿Confías en [CS:N]Grovyle[CR],\n[hero]?"})
  end
  -- @label_6 [étiquette de flux ExplorerScript]
  do local __choice = SkySceneKit.ask({{english="We have to trust him!", french="On n'a pas le choix!", german="Vertrauen wir ihm!", italian="Dobbiamo credergli!", spanish="¡Debemos confiar en él!"}, {english="I don't know...", french="J'en sais trop rien...", german="Ich weiß nicht...", italian="Non lo so...", spanish="No lo sé..."}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And you don't know either,\ndo you, [hero]?", french="Tu n'en sais trop rien, toi non\nplus, [hero]?", german="Und du bist dir auch\nnicht sicher, [hero], was?", italian=" Non è così, [hero]?", spanish="Tú tampoco sabes qué pensar,\n¿verdad, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And you don't know either,\ndo you, [hero]?", french="Tu n'en sais trop rien, toi non\nplus, [hero]?", german="Und du bist dir auch\nnicht sicher, [hero], was?", italian=" Non è così, [hero]?", spanish="Tú tampoco sabes qué pensar,\n¿verdad, [hero]?"})
  else
  SkySceneKit.say({english="And you don't know either,\ndo you, [hero]?", french="Tu n'en sais trop rien, toi non\nplus, [hero]?", german="Und du bist dir auch\nnicht sicher, [hero], was?", italian=" Non è così, [hero]?", spanish="Tú tampoco sabes qué pensar,\n¿verdad, [hero]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But you still want to catch up to\n[CS:N]Grovyle[CR] and talk to him?", french="Mais tu veux quand même\nrattraper [CS:N]Massko[CR] pour lui parler?", german="Aber du willst trotzdem [CS:N]Reptain[CR]\nsuchen und mit ihm reden?", italian="Ma tu vuoi ancora raggiungere\n[CS:N]Grovyle[CR] e parlargli?", spanish="Pero, aun así, sigues queriendo\nalcanzar a [CS:N]Grovyle[CR] y hablar con él, ¿no?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But you still insist on catching\nup to [CS:N]Grovyle[CR] so you can talk to him?", french="Mais tu veux quand même\nrattraper [CS:N]Massko[CR] pour lui parler?", german="Aber du willst trotzdem\nunbedingt [CS:N]Reptain[CR] suchen und mit ihm reden?", italian="Ma tu insisti ancora per\nraggiungere [CS:N]Grovyle[CR] e parlargli?", spanish="Pero, aun así, sigues queriendo\nalcanzar a [CS:N]Grovyle[CR] y hablar con él, ¿no?"})
  else
  SkySceneKit.say({english="But you still want to catch up to\n[CS:N]Grovyle[CR] and talk to him?", french="Mais tu veux quand même\nrattraper [CS:N]Massko[CR] pour lui parler?", german="Aber du willst trotzdem [CS:N]Reptain[CR]\nsuchen und mit ihm reden?", italian="Ma tu vuoi ancora raggiungere\n[CS:N]Grovyle[CR] e parlargli?", spanish="Pero, aun así, sigues queriendo\nalcanzar a [CS:N]Grovyle[CR] y hablar con él, ¿no?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" And then trust what he says?", french="Et te risquer à lui faire\nconfiance?", german=" Und ihm glauben, was er sagt?", italian="E poi credere a quello che ci\ndirà?", spanish="¿Y luego? ¿Creerás lo que nos\ndiga?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" And then trust what he says?", french="Et te risquer à lui faire\nconfiance?", german=" Und ihm glauben, was er sagt?", italian="E poi credere a quello che ci\ndirà?", spanish="¿Y luego? ¿Creerás lo que nos\ndiga?"})
  else
  SkySceneKit.say({english=" And then trust what he says?", french="Et te risquer à lui faire\nconfiance?", german=" Und ihm glauben, was er sagt?", italian="E poi credere a quello che ci\ndirà?", spanish="¿Y luego? ¿Creerás lo que nos\ndiga?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Well...[K]I hate this idea!", french="Eh bien...[K] ça ne me dit rien\nqui vaille!", german=" Tja...[K] Die Idee gefällt mir nicht!", italian=" Beh...[K] Odio quest'idea!", spanish=" Pues...[K] ¡a mí me parece fatal!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Well...[K]I hate this idea!", french="Eh bien...[K] ça ne me dit rien\nqui vaille!", german=" Tja...[K] Die Idee gefällt mir nicht!", italian=" Beh...[K] Odio quest'idea!", spanish="Pues...[K] ¡a mí me parece\nuna idea pésima!"})
  else
  SkySceneKit.say({english=" Well...[K]I hate this idea!", french="Eh bien...[K] ça ne me dit rien\nqui vaille!", german=" Tja...[K] Die Idee gefällt mir nicht!", italian=" Beh...[K] Odio quest'idea!", spanish=" Pues...[K] ¡yo detesto esa idea!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Trust a Pokémon like that?[K]\nNever!", french="Faire confiance à un Pokémon\ncomme lui?[K] Jamais!", german="Einem Pokémon wie ihm\nvertrauen?[K] Niemals!", italian="Fidarsi di un Pokémon come\nquello?[K] Mai!", spanish="¿Confiar en un Pokémon así?[K]\n¡Jamás!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Trust a Pokémon like that?[K]\nNever!", french="Faire confiance à un Pokémon\ncomme lui?[K] Jamais!", german="Einem Pokémon wie ihm\nvertrauen?[K] Niemals!", italian="Fidarsi di un Pokémon come\nquello?[K] Mai!", spanish="¿Confiar en un Pokémon así?[K]\n¡Jamás!"})
  else
  SkySceneKit.say({english="Trust a Pokémon like that?[K]\nNever!", french="Faire confiance à un Pokémon\ncomme lui?[K] Jamais!", german="Einem Pokémon wie ihm\nvertrauen?[K] Niemals!", italian="Fidarsi di un Pokémon come\nquello?[K] Mai!", spanish="¿Confiar en un Pokémon así?[K]\n¡Jamás!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That bad Pokémon![K] Trust that...", french="C'est un méchant Pokémon![K]\nAlors quant à lui faire confiance...", german="Dieses bösartige Pokémon![K]\nIhm zu vertrauen...", italian="Quel Pokémon cattivo![K] Credere\na quel...", spanish="¡Es un Pokémon malvado![K]\n¿Cómo podríamos confiar en él?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That bad Pokémon![K] Trust that...", french="C'est un méchant Pokémon![K]\nAlors quant à lui faire confiance...", german="Dieses bösartige Pokémon![K]\nIhm zu vertrauen...", italian="Quel Pokémon cattivo![K] Credere\na quel...", spanish="¡Es un Pokémon malvado![K]\n¿Cómo podríamos confiar en él?"})
  else
  SkySceneKit.say({english=" That bad Pokémon![K] Trust that...", french="C'est un méchant Pokémon![K]\nAlors quant à lui faire confiance...", german="Dieses bösartige Pokémon![K]\nIhm zu vertrauen...", italian="Quel Pokémon cattivo![K] Credere\na quel...", spanish="¡Es un Pokémon malvado![K]\n¿Cómo podríamos confiar en él?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I don't want to...[K] But...", french=" ... je m'y refuse![K] Pourtant...", german=" Ich will nicht...[K] Aber...", italian=" Non voglio...[K] Ma...", spanish="Esa idea no me gusta nada de\nnada...[K] pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I don't want to...[K] But...", french=" ... je m'y refuse![K] Pourtant...", german=" Ich will nicht...[K] Aber...", italian=" Non voglio...[K] Ma...", spanish="No me gusta nada de nada...[K]\npero..."})
  else
  SkySceneKit.say({english=" I don't want to...[K] But...", french=" ... je m'y refuse![K] Pourtant...", german=" Ich will nicht...[K] Aber...", italian=" Non voglio...[K] Ma...", spanish=" No me gusta la idea...[K] pero..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(45)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But...[K]maybe we don't have any\nother choice...", french="Pourtant...[K] nous n'avons pas\nd'autre choix...", german="Aber...[K] Vielleicht haben wir keine\nandere Wahl...", italian="Ma...[K] forse non abbiamo\naltra scelta...", spanish="Quizás...[K] Puede que no tengamos\notra opción..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But...[K]maybe we don't have any\nother choice...", french="Pourtant...[K] nous n'avons pas\nd'autre choix...", german="Aber...[K] Vielleicht haben wir keine\nandere Wahl...", italian="Ma...[K] forse non abbiamo\naltra scelta...", spanish="Quizás...[K] Puede que no tengamos\notra opción..."})
  else
  SkySceneKit.say({english="But...[K]maybe we don't have any\nother choice...", french="Pourtant...[K] nous n'avons pas\nd'autre choix...", german="Aber...[K] Vielleicht haben wir keine\nandere Wahl...", italian="Ma...[K] forse non abbiamo\naltra scelta...", spanish="Quizás...[K] Puede que no tengamos\notra opción..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I don't know why, but [CS:N]Dusknoir[CR]\nwants to get rid of us.", french="Je ne me l'explique pas, mais\n[CS:N]Noctunoir[CR] veut se débarrasser de nous.", german="Ich weiß nicht warum, aber\n[CS:N]Zwirrfinst[CR] will uns loswerden.", italian="Non so perché, ma [CS:N]Dusknoir[CR]\nvuole liberarsi di noi.", spanish="No comprendo el motivo, pero\n[CS:N]Dusknoir[CR] nos atacó a los tres."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I don't know why, but [CS:N]Dusknoir[CR]\nwants to get rid of us.", french="Je ne me l'explique pas, mais\n[CS:N]Noctunoir[CR] veut se débarrasser de nous.", german="Ich weiß nicht warum, aber\n[CS:N]Zwirrfinst[CR] will uns loswerden.", italian="Non so perché, ma [CS:N]Dusknoir[CR]\nvuole liberarsi di noi.", spanish="No comprendo el motivo, pero\n[CS:N]Dusknoir[CR] nos atacó a los tres."})
  else
  SkySceneKit.say({english="I don't know why, but [CS:N]Dusknoir[CR]\nwants to get rid of us.", french="Je ne me l'explique pas, mais\n[CS:N]Noctunoir[CR] veut se débarrasser de nous.", german="Ich weiß nicht warum, aber\n[CS:N]Zwirrfinst[CR] will uns loswerden.", italian="Non so perché, ma [CS:N]Dusknoir[CR]\nvuole liberarsi di noi.", spanish="No comprendo el motivo, pero\n[CS:N]Dusknoir[CR] nos atacó a los tres."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That means the only other\nPokémon we know here in the future...", french="Donc, il n'y a qu'un seul autre\nPokémon qu'on connaisse dans le futur...", german="Das einzige Pokémon, das wir\nsonst in dieser Zukunft kennen...", italian="Questo significa che tra i\nPokémon che conosciamo qua nel futuro...", spanish="Y aparte de él, el único Pokémon\nal que conocemos en el futuro..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That means the only other\nPokémon we know here in the future...", french="Donc, il n'y a qu'un seul autre\nPokémon qu'on connaisse dans le futur...", german="Das einzige Pokémon, das wir\nsonst in dieser Zukunft kennen...", italian="Questo significa che tra i\nPokémon che conosciamo qua nel futuro...", spanish="Y aparte de él, el único Pokémon\nal que conocemos en el futuro..."})
  else
  SkySceneKit.say({english="That means the only other\nPokémon we know here in the future...", french="Donc, il n'y a qu'un seul autre\nPokémon qu'on connaisse dans le futur...", german="Das einzige Pokémon, das wir\nsonst in dieser Zukunft kennen...", italian="Questo significa che tra i\nPokémon che conosciamo qua nel futuro...", spanish="Y aparte de él, el único Pokémon\nal que conocemos en el futuro..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That leaves only [CS:N]Grovyle[CR]...", french=" Il ne nous reste que [CS:N]Massko[CR]...", german=" Das ist [CS:N]Reptain[CR].", italian=" Ci rimane solo [CS:N]Grovyle[CR]...", spanish=" Es [CS:N]Grovyle[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That leaves only [CS:N]Grovyle[CR]...", french=" Il ne nous reste que [CS:N]Massko[CR]...", german=" Das ist [CS:N]Reptain[CR].", italian=" Ci rimane solo [CS:N]Grovyle[CR]...", spanish=" Es [CS:N]Grovyle[CR]..."})
  else
  SkySceneKit.say({english=" That leaves only [CS:N]Grovyle[CR]...", french=" Il ne nous reste que [CS:N]Massko[CR]...", german=" Das ist [CS:N]Reptain[CR].", italian=" Ci rimane solo [CS:N]Grovyle[CR]...", spanish=" Es [CS:N]Grovyle[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We don't have any choice.[K]\nWe must rely on [CS:N]Grovyle[CR].", french="On n'a pas le choix.[K] [CS:N]Massko[CR]\nest notre seul espoir.", german="Wir haben keine Wahl.[K]\nWir müssen uns auf [CS:N]Reptain[CR] verlassen.", italian="Non abbiamo altra scelta.[K]\nDobbiamo affidarci a [CS:N]Grovyle[CR].", spanish="No nos queda otra salida.[K]\nTenemos que confiar en [CS:N]Grovyle[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have no choice.[K] We must pin\nour hopes on [CS:N]Grovyle[CR].", french="On n'a pas le choix.[K] [CS:N]Massko[CR]\nest notre seul espoir.", german="Wir haben keine Wahl.[K]\n[CS:N]Reptain[CR] ist unsere einzige Hoffnung.", italian="Non abbiamo scelta.[K] Dobbiamo\naffidare le nostre speranze a [CS:N]Grovyle[CR].", spanish="No tenemos otra opción.[K]\nTenemos que confiar en [CS:N]Grovyle[CR]."})
  else
  SkySceneKit.say({english="We don't have any choice.[K]\nWe must pin our hopes on [CS:N]Grovyle[CR].", french="On n'a pas le choix.[K] [CS:N]Massko[CR]\nest notre seul espoir.", german="Wir haben keine Wahl.[K]\n[CS:N]Reptain[CR] ist unsere einzige Hoffnung.", italian="Non abbiamo altra scelta.[K]\nDobbiamo affidare le nostre speranze a\n[CS:N]Grovyle[CR].", spanish="No tenemos a nadie más.[K]\nTenemos que confiar en [CS:N]Grovyle[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Well...[K]I can't trust him!", french="Eh bien moi...[K] je ne peux pas\nlui accorder ma confiance!", german="Tja...[K] Ich kann ihm nicht\nvertrauen!", italian="Beh...[K] Io non riesco a fidarmi\ndi lui!", spanish="Bueno...[K] El caso\nes que... ¡yo no puedo confiar en él!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Well...[K]I can't trust him!", french="Eh bien moi...[K] je ne peux pas\nlui accorder ma confiance!", german="Tja...[K] Ich kann ihm nicht\nvertrauen!", italian="Beh...[K] Io non riesco a fidarmi\ndi lui!", spanish="Bueno...[K] Allá tú...\n¡Pero yo no puedo confiar en él!"})
  else
  SkySceneKit.say({english=" Well...[K]I can't trust him!", french="Eh bien moi...[K] je ne peux pas\nlui accorder ma confiance!", german="Tja...[K] Ich kann ihm nicht\nvertrauen!", italian="Beh...[K] Io non riesco a fidarmi\ndi lui!", spanish="Como quieras...[K]\n¡Pero yo no puedo confiar en él!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" A Pokémon like that? Never!", french="Un Pokémon comme lui?\nJamais!", german="Einem Pokémon wie ihm?\nNiemals!", italian=" Di un Pokémon così? Mai!", spanish=" ¿Un Pokémon como él? ¡Nunca!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" A Pokémon like that? Never!", french="Un Pokémon comme lui?\nJamais!", german="Einem Pokémon wie ihm?\nNiemals!", italian=" Di un Pokémon così? Mai!", spanish=" ¿Un Pokémon como él? ¡Nunca!"})
  else
  SkySceneKit.say({english=" A Pokémon like that? Never!", french="Un Pokémon comme lui?\nJamais!", german="Einem Pokémon wie ihm?\nNiemals!", italian=" Di un Pokémon così? Mai!", spanish=" ¿Un Pokémon como él? ¡Nunca!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="There's no way that I can\ntrust him!", french="Hors de question que je lui\naccorde ma confiance!", german="Ich kann ihm auf keinen Fall\nvertrauen!", italian=" Non potrei mai fidarmi di lui!", spanish=" ¡Jamás confiaría en alguien así!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There's no way that I can\ntrust him!", french="Hors de question que je lui\naccorde ma confiance!", german="Ich kann ihm auf keinen Fall\nvertrauen!", italian=" Non potrei mai fidarmi di lui!", spanish=" ¡Jamás confiaría en alguien así!"})
  else
  SkySceneKit.say({english="There's no way that I can\ntrust him!", french="Hors de question que je lui\naccorde ma confiance!", german="Ich kann ihm auf keinen Fall\nvertrauen!", italian=" Non potrei mai fidarmi di lui!", spanish=" ¡Jamás confiaría en alguien así!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" There's just no way! But...", french="C'est plus fort que moi!\nPourtant...", german=" Es geht einfach nicht! Aber...", italian=" Non c'è verso! Ma...", spanish=" ¡Imposible! Aunque..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" There's just no way! But...", french="C'est plus fort que moi!\nPourtant...", german=" Es geht einfach nicht! Aber...", italian=" Non c'è verso! Ma...", spanish=" ¡Imposible! Aunque..."})
  else
  SkySceneKit.say({english=" There's just no way! But...", french="C'est plus fort que moi!\nPourtant...", german=" Es geht einfach nicht! Aber...", italian=" Non c'è verso! Ma...", spanish=" ¡Imposible! Aunque..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(45)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But...[K]I understand, [hero].", french="Pourtant...[K] je comprends,\n[hero].", german="Aber...[K] Ich verstehe dich,\n[hero].", italian=" Ma...[K] capisco, [hero].", spanish="La verdad es que...[K]\nte entiendo, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But...[K]I understand, [hero].", french="Pourtant...[K] je comprends,\n[hero].", german="Aber...[K] Ich verstehe dich,\n[hero].", italian=" Ma...[K] capisco, [hero].", spanish="La verdad es que...[K]\nte entiendo, [hero]."})
  else
  SkySceneKit.say({english=" But...[K]I understand, [hero].", french="Pourtant...[K] je comprends,\n[hero].", german="Aber...[K] Ich verstehe dich,\n[hero].", italian=" Ma...[K] capisco, [hero].", spanish="La verdad es que...[K]\nte entiendo, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I don't know why, but [CS:N]Dusknoir[CR]\nwants to get rid of us.", french="Je ne me l'explique pas, mais\n[CS:N]Noctunoir[CR] veut se débarrasser de nous.", german="Ich weiß nicht warum, aber\n[CS:N]Zwirrfinst[CR] will uns loswerden.", italian="Non so perché, ma [CS:N]Dusknoir[CR]\nvuole liberarsi di noi.", spanish="No comprendo el motivo, pero\n[CS:N]Dusknoir[CR] nos atacó a los tres."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I don't know why, but [CS:N]Dusknoir[CR]\nwants to get rid of us.", french="Je ne me l'explique pas, mais\n[CS:N]Noctunoir[CR] veut se débarrasser de nous.", german="Ich weiß nicht warum, aber\n[CS:N]Zwirrfinst[CR] will uns loswerden.", italian="Non so perché, ma [CS:N]Dusknoir[CR]\nvuole liberarsi di noi.", spanish="No comprendo el motivo, pero\n[CS:N]Dusknoir[CR] nos atacó a los tres."})
  else
  SkySceneKit.say({english="I don't know why, but [CS:N]Dusknoir[CR]\nwants to get rid of us.", french="Je ne me l'explique pas, mais\n[CS:N]Noctunoir[CR] veut se débarrasser de nous.", german="Ich weiß nicht warum, aber\n[CS:N]Zwirrfinst[CR] will uns loswerden.", italian="Non so perché, ma [CS:N]Dusknoir[CR]\nvuole liberarsi di noi.", spanish="No comprendo el motivo, pero\n[CS:N]Dusknoir[CR] nos atacó a los tres."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That means the only other\nPokémon we know here in the future...", french="Donc, il n'y a qu'un seul autre\nPokémon qu'on connaisse dans le futur...", german="Das einzige Pokémon, das wir\nsonst in dieser Zukunft kennen...", italian="Questo significa che tra i\nPokémon che conosciamo qua nel futuro...", spanish="Y aparte de él, el único Pokémon\nal que conocemos en el futuro..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That means the only other\nPokémon we know here in the future...", french="Donc, il n'y a qu'un seul autre\nPokémon qu'on connaisse dans le futur...", german="Das einzige Pokémon, das wir\nsonst in dieser Zukunft kennen...", italian="Questo significa che tra i\nPokémon che conosciamo qua nel futuro...", spanish="Y aparte de él, el único Pokémon\nal que conocemos en el futuro..."})
  else
  SkySceneKit.say({english="That means the only other\nPokémon we know here in the future...", french="Donc, il n'y a qu'un seul autre\nPokémon qu'on connaisse dans le futur...", german="Das einzige Pokémon, das wir\nsonst in dieser Zukunft kennen...", italian="Questo significa che tra i\nPokémon che conosciamo qua nel futuro...", spanish="Y aparte de él, el único Pokémon\nal que conocemos en el futuro..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That leaves only [CS:N]Grovyle[CR]...", french=" Il ne nous reste que [CS:N]Massko[CR]...", german=" Das ist [CS:N]Reptain[CR].", italian=" Ci rimane solo [CS:N]Grovyle[CR]...", spanish=" Es [CS:N]Grovyle[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That leaves only [CS:N]Grovyle[CR]...", french=" Il ne nous reste que [CS:N]Massko[CR]...", german=" Das ist [CS:N]Reptain[CR].", italian=" Ci rimane solo [CS:N]Grovyle[CR]...", spanish=" Es [CS:N]Grovyle[CR]..."})
  else
  SkySceneKit.say({english=" That leaves only [CS:N]Grovyle[CR]...", french=" Il ne nous reste que [CS:N]Massko[CR]...", german=" Das ist [CS:N]Reptain[CR].", italian=" Ci rimane solo [CS:N]Grovyle[CR]...", spanish=" Es [CS:N]Grovyle[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We don't have any choice.[K]\nWe must rely on [CS:N]Grovyle[CR].", french="On n'a pas le choix.[K] [CS:N]Massko[CR]\nest notre seul espoir.", german="Wir haben keine Wahl.[K]\nWir müssen uns auf [CS:N]Reptain[CR] verlassen.", italian="Non abbiamo altra scelta.[K]\nDobbiamo affidarci a [CS:N]Grovyle[CR].", spanish="No nos queda otra salida.[K]\nTenemos que confiar en [CS:N]Grovyle[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have no choice.[K] We must pin\nour hopes on [CS:N]Grovyle[CR].", french="On n'a pas le choix.[K] [CS:N]Massko[CR]\nest notre seul espoir.", german="Wir haben keine Wahl.[K]\n[CS:N]Reptain[CR] ist unsere einzige Hoffnung.", italian="Non abbiamo scelta.[K] Dobbiamo\naffidare le nostre speranze a [CS:N]Grovyle[CR].", spanish="No tenemos otra opción.[K]\nTenemos que confiar en [CS:N]Grovyle[CR]."})
  else
  SkySceneKit.say({english="We don't have any choice.[K]\nWe must pin our hopes on [CS:N]Grovyle[CR].", french="On n'a pas le choix.[K] [CS:N]Massko[CR]\nest notre seul espoir.", german="Wir haben keine Wahl.[K]\n[CS:N]Reptain[CR] ist unsere einzige Hoffnung.", italian="Non abbiamo altra scelta.[K]\nDobbiamo affidare le nostre speranze a\n[CS:N]Grovyle[CR].", spanish="No tenemos a nadie más.[K]\nTenemos que confiar en [CS:N]Grovyle[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- @label_9 [étiquette de flux ExplorerScript]
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(160) end)
  GAME:WaitFrames(180)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Well then...[K]all right.", french=" Bon alors...[K] c'est d'accord.", german=" Na dann...[K] Okay.", italian=" Beh allora...[K] siamo d'accordo.", spanish=" Entonces...[K] de acuerdo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Well then...[K]OK.", french=" Bon alors...[K] c'est d'accord.", german=" Na dann...[K] Okay.", italian=" Beh allora...[K] siamo d'accordo.", spanish=" Entonces...[K] de acuerdo."})
  else
  SkySceneKit.say({english=" Well then...[K]OK.", french=" Bon alors...[K] c'est d'accord.", german=" Na dann...[K] Okay.", italian=" Beh allora...[K] siamo d'accordo.", spanish=" Entonces...[K] de acuerdo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="All right, [hero].[K]\nLet's chase after [CS:N]Grovyle[CR]!", french="D'accord, [hero].[K]\nLançons-nous à la poursuite de [CS:N]Massko[CR]!", german="Okay, [hero].[K]\nSuchen wir [CS:N]Reptain[CR]!", italian="Va bene, [hero].[K]\nCerchiamo [CS:N]Grovyle[CR]!", spanish="Muy bien, [hero].[K]\n¡Encontremos a [CS:N]Grovyle[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="OK, [hero].[K] Let's track\ndown [CS:N]Grovyle[CR]!", french="D'accord, [hero].[K]\nLançons-nous à la poursuite de [CS:N]Massko[CR]!", german="Okay, [hero].[K]\nSpüren wir [CS:N]Reptain[CR] auf!", italian="Ok, [hero].[K] Rintracciamo\n[CS:N]Grovyle[CR]!", spanish="Muy bien, [hero].[K]\n¡Vamos a buscar a [CS:N]Grovyle[CR]!"})
  else
  SkySceneKit.say({english="OK, [hero].[K] Let's track\ndown [CS:N]Grovyle[CR]!", french="D'accord, [hero].[K]\nLançons-nous à la poursuite de [CS:N]Massko[CR]!", german="Okay, [hero].[K]\nSpüren wir [CS:N]Reptain[CR] auf!", italian="Ok, [hero].[K] Rintracciamo\n[CS:N]Grovyle[CR]!", spanish="Muy bien, [hero].[K]\n¡Vamos a buscar a [CS:N]Grovyle[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's meet with [CS:N]Grovyle[CR] and ask\nhim how to get back to our world!", french="Quand on l'aura retrouvé, on lui\ndemandera comment rentrer chez nous!", german="Lass uns [CS:N]Reptain[CR] fragen,\nwie wir in unsere Welt zurückkommen!", italian="Troviamo [CS:N]Grovyle[CR] e chiediamogli\ncome tornare nel nostro mondo!", spanish="¡Tenemos que hablar con [CS:N]Grovyle[CR]\ny preguntarle cómo volver a nuestro mundo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's meet with [CS:N]Grovyle[CR] and ask\nhim how we can return to our world!", french="Quand on l'aura retrouvé, on lui\ndemandera comment rentrer chez nous!", german="Lass uns [CS:N]Reptain[CR] fragen,\nwie wir in unsere Welt zurückkehren können!", italian="Troviamo [CS:N]Grovyle[CR] e chiediamogli\ncome tornare nel nostro mondo!", spanish="¡Tenemos que hablar con [CS:N]Grovyle[CR]\ny preguntarle cómo volver a nuestro mundo!"})
  else
  SkySceneKit.say({english="Let's meet with [CS:N]Grovyle[CR] and ask\nhim how we can get back to our world!", french="Quand on l'aura retrouvé, on lui\ndemandera comment rentrer chez nous!", german="Lass uns [CS:N]Reptain[CR] fragen,\nwie wir in unsere Welt zurückkommen!", italian="Troviamo [CS:N]Grovyle[CR] e chiediamogli\ncome tornare nel nostro mondo!", spanish="¡Tenemos que hablar con [CS:N]Grovyle[CR]\ny preguntarle cómo volver a nuestro mundo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner]!)", french="([partner]!)", german="([partner]!)", italian="([partner]!)", spanish="(¡[partner]!)"})
  else
  SkySceneKit.say({english="([partner]!)", french="([partner]!)", german="([partner]!)", italian="([partner]!)", spanish="(¡[partner]!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go, [hero]!", french=" Allons-y, [hero]!", german=" Gehen wir, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Vamos, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go, [hero]!", french=" Allons-y, [hero]!", german=" Gehen wir, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Vamos, [hero]!"})
  else
  SkySceneKit.say({english=" Let's go, [hero]!", french=" Allons-y, [hero]!", german=" Gehen wir, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Vamos, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go after [CS:N]Grovyle[CR]!", french=" Allons trouver [CS:N]Massko[CR]!", german=" Folgen wir [CS:N]Reptain[CR]!", italian=" Andiamo alla ricerca di [CS:N]Grovyle[CR]!", spanish=" ¡Busquemos a [CS:N]Grovyle[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go after [CS:N]Grovyle[CR]!", french=" Allons trouver [CS:N]Massko[CR]!", german=" Folgen wir [CS:N]Reptain[CR]!", italian=" Andiamo alla ricerca di [CS:N]Grovyle[CR]!", spanish=" ¡Busquemos a [CS:N]Grovyle[CR]!"})
  else
  SkySceneKit.say({english=" Let's go after [CS:N]Grovyle[CR]!", french=" Allons trouver [CS:N]Massko[CR]!", german=" Folgen wir [CS:N]Reptain[CR]!", italian=" Andiamo alla ricerca di [CS:N]Grovyle[CR]!", spanish=" ¡Busquemos a [CS:N]Grovyle[CR]!"})
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
  GROUND:MoveToPosition(hero, 376, 180, false, 2)
  GAME:WaitFrames(30)
  pcall(function() GAME:MoveCamera(360, 176, 60, false) end) -- performer/caméra
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_IN_THE_HANDS_OF_FATE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [hero], thanks.", french=" Merci, [hero].", german=" [hero], danke.", italian=" [hero], grazie.", spanish=" Gracias, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [hero], thank you.", french=" Merci, [hero].", german=" [hero], danke.", italian=" [hero], grazie.", spanish=" Gracias, [hero]."})
  else
  SkySceneKit.say({english=" [hero], thank you.", french=" Merci, [hero].", german=" [hero], danke.", italian=" [hero], grazie.", spanish=" Gracias, [hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You were worried about me for\nbeing so down.", french="Tu as fait ce que tu as pu pour\nme remonter le moral.", german="Du hast dir Sorgen gemacht,\nweil ich mich hängen ließ.", italian="Eri in ansia per me perché\nero giù di corda.", spanish="Has visto que estaba deprimido\ny me has animado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You tried to pick me up because\nI was feeling down.", french="Tu as fait ce que tu as pu pour\nme remonter le moral.", german="Du wolltest mich aufmuntern,\nweil ich so niedergeschlagen war.", italian="Hai provato a tirarmi su perché\nnon stavo bene.", spanish="Has visto que estaba deprimido\ny me has animado."})
  else
  SkySceneKit.say({english="You tried to cheer me up\nbecause I was feeling down.", french="Tu as fait ce que tu as pu pour\nme remonter le moral.", german="Du wolltest mich aufmuntern,\nweil ich so niedergeschlagen war.", italian="Hai provato a tirarmi su il\nmorale perché ero giù di corda.", spanish="Has visto que estaba deprimida\ny me has animado."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Even though you should be just\nas scared as I am, [hero]...[K] I'm sorry.", french="Alors même que tu dois avoir\naussi peur que moi, [hero]...[K]\nExcuse-moi.", german="Dabei müsstest du genauso\ngroße Angst haben, [hero].[K]\nEs tut mir leid.", italian="E lo hai fatto anche se\nprobabilmente provi la mia stessa paura,\n[hero]...[K] Mi dispiace.", spanish="Y eso que seguro que tienes\ntanto miedo como yo, [hero]...[K] Lo siento."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Even though you should be just\nas scared as I am, [hero]...[K] I'm sorry.", french="Alors même que tu dois avoir\naussi peur que moi, [hero]...[K]\nExcuse-moi.", german="Dabei müsstest du genauso\ngroße Angst haben, [hero].[K]\nEs tut mir leid.", italian="Anche se devi provare la mia\nstessa paura, [hero]...[K] Mi dispiace.", spanish="Aunque seguro que tienes\ntanto miedo como yo, [hero]...[K] Lo siento."})
  else
  SkySceneKit.say({english="Even though you should be just\nas scared as I am, [hero]...[K] I'm sorry.", french="Alors même que tu dois avoir\naussi peur que moi, [hero]...[K]\nExcuse-moi.", german="Dabei müsstest du genauso\ngroße Angst haben, [hero].[K]\nEs tut mir leid.", italian="Anche se devi provare la mia\nstessa paura, [hero]...[K] Mi dispiace.", spanish="Aunque sin duda tienes\ntanto miedo como yo, [hero]...[K] Lo siento."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Even though I have my closest\nand most precious friend with me...", french="Malgré la présence à mes côtés\nde mon plus grand soutien dans la vie...", german="Obwohl mein allerbester Freund\nbei mir ist...", italian="Sebbene tu, il Pokémon più\nvicino e prezioso, sia con me...", spanish="Aunque somos amigos y te\naprecio como a nadie más..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Even though I have my closest\nand most precious friend with me...", french="Malgré la présence à mes côtés\nde mon plus grand soutien dans la vie...", german="Obwohl mein allerbester Freund\nbei mir ist...", italian="Sebbene tu, il Pokémon più\nvicino e prezioso, sia con me...", spanish="Aunque somos amigos y te\naprecio como a nadie más..."})
  else
  SkySceneKit.say({english="Even though I have my closest\nand most precious friend with me...", french="Malgré la présence à mes côtés\nde mon plus grand soutien dans la vie...", german="Obwohl mein allerbester Freund\nbei mir ist...", italian="Sebbene tu, il Pokémon più\nvicino e prezioso, sia con me...", spanish="A pesar de nuestra gran amistad\ny de que te aprecio como a nadie más..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I worried all alone...", french="... je me suis inquiété dans\nmon coin.", german="Trotzdem habe ich mir ganz\nallein Sorgen gemacht.", italian=" ... l'ansia mi ha avvolto...", spanish=" No compartí mi preocupación..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I worried all alone...", french="... je me suis inquiété dans\nmon coin.", german="Trotzdem habe ich mir ganz\nallein Sorgen gemacht.", italian=" ... l'ansia mi ha avvolto...", spanish=" No compartí mi preocupación..."})
  else
  SkySceneKit.say({english=" I worried all alone...", french="... je me suis inquiétée dans\nmon coin.", german="Trotzdem habe ich mir ganz\nallein Sorgen gemacht.", italian=" ... l'ansia mi ha avvolta...", spanish=" No compartí mi preocupación..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" And almost gave up alone.", french="Et j'ai bien failli baisser\nles bras.", german="Und fast hätte ich allein\naufgegeben.", italian="... e mi ha quasi fatto mollare\ntutto.", spanish="Y estuve a punto de abandonar\ncomo si estuviera solo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" And almost gave up alone.", french="Et j'ai bien failli baisser\nles bras.", german="Und fast hätte ich allein\naufgegeben.", italian="... e mi ha quasi fatto mollare\ntutto.", spanish="Y estuve a punto de abandonar\ncomo si estuviera solo."})
  else
  SkySceneKit.say({english=" And almost gave up alone.", french="Et j'ai bien failli baisser\nles bras.", german="Und fast hätte ich allein\naufgegeben.", italian="... e mi ha quasi fatto mollare\ntutto.", spanish="Y estuve a punto de abandonar\ncomo si estuviera sola."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" When, in fact, I'm not alone.", french="Alors qu'en réalité, je ne suis\npas seul.", german="Dabei bin ich in Wirklichkeit\ngar nicht allein.", italian=" Ma, in realtà, non sono solo.", spanish=" Cuando en realidad no lo estoy."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" When, in fact, I'm not alone.", french="Alors qu'en réalité, je ne suis\npas seul.", german="Dabei bin ich in Wirklichkeit\ngar nicht allein.", italian=" Ma, in realtà, non sono solo.", spanish=" Cuando en realidad no lo estoy."})
  else
  SkySceneKit.say({english=" When, in fact, I'm not alone.", french="Alors qu'en réalité, je ne suis\npas seule.", german="Dabei bin ich in Wirklichkeit\ngar nicht allein.", italian=" Ma, in realtà, non sono sola.", spanish=" Cuando en realidad no lo estoy."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 340, 180, false, 2)
  GAME:WaitFrames(15)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I won't give up anymore.", french="Plus jamais je ne me laisserai\nabattre.", german=" Ich werde nicht mehr aufgeben.", italian=" Non mi abbatterò più.", spanish=" No volveré a rendirme."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I won't give up anymore.", french="Plus jamais je ne me laisserai\nabattre.", german=" Ich werde nicht mehr aufgeben.", italian=" Non mi abbatterò più.", spanish=" No volveré a rendirme."})
  else
  SkySceneKit.say({english=" I won't give up anymore.", french="Plus jamais je ne me laisserai\nabattre.", german=" Ich werde nicht mehr aufgeben.", italian=" Non mi abbatterò più.", spanish=" No volveré a rendirme."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Because you're by my side, I can\nbe brave, [hero].", french="C'est ta présence à mes côtés\nqui me rend courageux, [hero].", german="Ich kann stark sein, weil du\nan meiner Seite bist, [hero].", italian="Con te al mio fianco, posso\nessere coraggioso, [hero].", spanish="Contigo a mi lado, puedo ser\nvaliente, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Because you're by my side, I can\nbe brave, [hero].", french="C'est ta présence à mes côtés\nqui me rend courageux, [hero].", german="Ich kann stark sein, weil du\nan meiner Seite bist, [hero].", italian="Con te al mio fianco, posso\nessere coraggioso, [hero].", spanish="Cuando estás a mi lado me\nsiento valiente, [hero]."})
  else
  SkySceneKit.say({english="Because you're by my side, I can\nbe brave, [hero].", french="C'est ta présence à mes côtés\nqui me rend courageuse, [hero].", german="Ich kann stark sein, weil du\nan meiner Seite bist, [hero].", italian="Con te al mio fianco, posso\nessere coraggiosa, [hero].", spanish="Si te tengo a mi lado, puedo\nser valiente, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'm going to be fine now.", french=" Tout ira bien désormais.", german=" Jetzt ist alles in Ordnung.", italian=" Adesso sto bene.", spanish=" No pienso flaquear."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I'm going to be fine now.", french=" Tout ira bien désormais.", german=" Jetzt ist alles in Ordnung.", italian=" Adesso sto bene.", spanish=" No voy a flaquear más."})
  else
  SkySceneKit.say({english=" I'm going to be fine now.", french=" Tout ira bien désormais.", german=" Jetzt ist alles in Ordnung.", italian=" Adesso sto bene.", spanish=" Ya no flaquearé más."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So let's keep going,\n[hero].", french=" Accrochons-nous, [hero].", german="Also, machen wir weiter,\n[hero].", italian=" Quindi forza, [hero].", spanish="Así que... ¡sigamos adelante,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So let's keep going,\n[hero].", french=" Accrochons-nous, [hero].", german="Also, machen wir weiter,\n[hero].", italian=" Quindi forza, [hero].", spanish="Así que... ¡sigamos adelante,\n[hero]!"})
  else
  SkySceneKit.say({english="So let's keep going,\n[hero].", french=" Accrochons-nous, [hero].", german="Also, machen wir weiter,\n[hero].", italian=" Quindi forza, [hero].", spanish="Así que... ¡sigamos adelante,\n[hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's get back to our world...[K]\ntogether!", french="On va rentrer chez nous...[K]\nensemble!", german="Kehren wir in unsere Welt\nzurück![K] Und zwar gemeinsam!", italian="Torniamo nel presente...[K]\nInsieme!", spanish="Volvamos a nuestro mundo...[K]\n¡Juntos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's get back to our world...[K]\ntogether!", french="On va rentrer chez nous...[K]\nensemble!", german="Kehren wir in unsere Welt\nzurück![K] Und zwar gemeinsam!", italian="Torniamo nel presente...[K]\nInsieme!", spanish="Tenemos que volver a nuestro\nmundo...[K] ¡Hagámoslo juntos!"})
  else
  SkySceneKit.say({english="Let's get back to our world...[K]\ntogether!", french="On va rentrer chez nous...[K]\nensemble!", german="Kehren wir in unsere Welt\nzurück![K] Und zwar gemeinsam!", italian="Torniamo nel presente...[K]\nInsieme!", spanish="Tenemos que volver a nuestro\nmundo...[K] ¡Nada se interpondrá!"})
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
  pcall(function() SOUND:FadeOutBGM(180) end)
  GROUND:MoveToPosition(hero, 488, 204, false, 2)
  GAME:WaitFrames(10)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(24), p.Y+(0), false, 2) end
  GROUND:MoveToPosition(partner, 468, 204, false, 2)
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(90)
  end
  end
  end
  end
  end
  end
end
