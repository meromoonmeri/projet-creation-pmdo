-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D14P11A/m13a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(14, 5) -- $SCENARIO_MAIN = scn[14,5] (ROM)
  -- back_SetGround(LEVEL_D14P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(partner, 216, 284, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(hero, 248, 284, false, 2)
  GAME:WaitFrames(15)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 232, 324, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 204, 324, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Is this the deepest part of\nthe desert?", french="Est-ce que nous avons atteint\nle tréfonds du désert?", german="Sind wir am tiefsten Punkt der\nWüste?", italian=" Finisce qui il deserto?", spanish="¿Hemos llegado a lo más\nprofundo del desierto?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Is this the deepest part of\nthe desert?", french="Est-ce que nous avons atteint\nle tréfonds du désert?", german="Sind wir am tiefsten Punkt der\nWüste?", italian="Siamo arrivati nella parte più\nprofonda del deserto?", spanish="¿Hemos llegado a lo más\nprofundo del desierto?"})
  else
  SkySceneKit.say({english="Is this the deepest part of\nthe desert?", french="Est-ce que nous avons atteint\nle tréfonds du désert?", german="Sind wir am tiefsten Punkt der\nWüste?", italian="Siamo nella parte più\nprofonda del deserto?", spanish="¿Hemos llegado a lo más\nprofundo del desierto?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh no! It's quicksand!", french=" Attention! Des sables mouvants!", german=" Oh nein! Das ist Treibsand!", italian=" Oh no! Sabbie mobili!", spanish="¡Cuidado!\n¡Son arenas movedizas!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Watch out! It's quicksand!", french=" Attention! Des sables mouvants!", german=" Pass auf! Das ist Treibsand!", italian="Fai attenzione! Quelle sono\nsabbie mobili!", spanish="¡Cuidado!\n¡Son arenas movedizas!"})
  else
  SkySceneKit.say({english=" Waah! There's quicksand!", french=" Attention! Des sables mouvants!", german=" Waah! Das ist Treibsand!", italian="Fai attenzione! Quelle sono\nsabbie mobili!", spanish=" ¡Aaah! ¡Son arenas movedizas!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(232, 220, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 216, 228, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(hero, 248, 228, false, 2)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 196, 268, false, 2) end end
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 224, 276, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The sand's getting sucked down\nthere, and there, and there!", french="Le sable est aspiré par le fond\nlà, là et là!!", german="Der Sand wird überall nach\nunten gezogen!", italian="Guarda! La sabbia viene\nrisucchiata verso il fondo!", spanish=" ¡Mira cómo se traga la arena!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The sand's getting sucked down\nhere and there!", french="Le sable est aspiré par le fond\nlà, là et là!!", german="Der Sand wird überall nach\nunten gezogen!", italian="Guarda! La sabbia viene\nrisucchiata verso il fondo!", spanish=" ¡Mira cómo se traga la arena!"})
  else
  SkySceneKit.say({english="The sand's getting sucked down\nhere and there!", french="Le sable est aspiré par le fond\nlà, là et là!!", german="Der Sand wird überall nach\nunten gezogen!", italian="Guarda! La sabbia viene\nrisucchiata verso il fondo!", spanish=" ¡Mira cómo se traga la arena!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="They're like sand whirlpools, and\nwe'll be sucked down if we get close!", french="On dirait des tourbillons\nde sable! On va se faire aspirer si\non s'en approche!", german="Das sind Sandstrudel! Wenn wir\nzu nah herangehen, ziehen sie uns mit nach\nunten!", italian="Sono come dei vortici di sabbia.\nAnche noi verremo risucchiati se ci\navviciniamo troppo!", spanish="Son una especie de remolinos,\n¡si nos acercamos más nos succionarán!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="They're like sand whirlpools, and\nwe'll be pulled in if we get close!", french="On dirait des tourbillons\nde sable! On va se faire aspirer si\non s'en approche!", german="Das sind Sandstrudel! Wenn wir\nzu nah herangehen, werden wir hineingezogen!", italian="Sono come dei vortici di sabbia.\nAnche noi verremo risucchiati se ci\navviciniamo troppo!", spanish="Son una especie de remolinos,\n¡si nos acercamos más nos succionarán!"})
  else
  SkySceneKit.say({english="They're like sand whirlpools, and\nwe'll be pulled under if we get close!", french="On dirait des tourbillons\nde sable! On va se faire aspirer si\non s'en approche!", german="Das sind Sandstrudel! Wenn wir\nzu nah herangehen, werden wir nach unten\ngezogen!", italian="Sono come dei vortici di sabbia.\nRisucchieranno anche noi se ci avviciniamo\ntroppo!", spanish="Son una especie de remolinos,\n¡si nos acercamos más nos succionarán!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's dangerous here!", french=" C'est dangereux ici!", german=" Hier ist es gefährlich!", italian=" Sono molto pericolosi!", spanish=" Esto es muy peligroso."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's dangerous here!", french=" C'est dangereux ici!", german=" Hier ist es gefährlich!", italian=" Sono molto pericolosi!", spanish=" Esto es muy peligroso."})
  else
  SkySceneKit.say({english=" It's dangerous here!", french=" C'est dangereux ici!", german=" Hier ist es gefährlich!", italian=" Sono molto pericolosi!", spanish=" Esto es peligrosísimo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I don't see anything around here\nthat looks like a Time Gear!", french="Je ne vois rien qui ressemble\nà un Rouage du Temps dans le coin!", german="Ich sehe hier nichts, was ein\nZahnrad der Zeit sein könnte!", italian="Però non ho visto niente che\nassomigli a un Ingranaggio del Tempo!", spanish="No veo nada en este sitio que\nparezca un Engranaje del Tiempo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I don't see anything around here\nthat remotely looks like a Time Gear!", french="Je ne vois rien qui ressemble\nà un Rouage du Temps dans le coin!", german="Ich sehe hier nichts, was im\nEntferntesten wie ein Zahnrad der Zeit\naussieht!", italian="Però non vedo nessun\nIngranaggio del Tempo!", spanish="No veo nada en este sitio que\nparezca un Engranaje del Tiempo."})
  else
  SkySceneKit.say({english="I don't see anything around here\nthat even remotely looks like a Time Gear!", french="Je ne vois rien qui ressemble\nà un Rouage du Temps dans le coin!", german="Ich sehe hier nichts, was im\nEntferntesten wie ein Zahnrad der Zeit\naussieht!", italian="Però non vedo nessun\nIngranaggio del Tempo!", spanish="No veo nada en este sitio que\nparezca un Engranaje del Tiempo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I guess there's nothing here.", french=" Je suppose qu'il n'y a rien ici.", german=" Ich schätze, hier ist nichts.", italian=" Mi sa che non c'è niente qui.", spanish=" Supongo que aquí no hay nada."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Maybe there's nothing here.", french=" Je suppose qu'il n'y a rien ici.", german=" Vielleicht ist hier einfach nichts.", italian=" Forse non c'è nulla qui.", spanish=" Supongo que aquí no hay nada."})
  else
  SkySceneKit.say({english=" I guess there's nothing here.", french=" Je suppose qu'il n'y a rien ici.", german=" Ich schätze, hier ist nichts.", italian=" Forse non c'è nulla qui.", spanish=" Supongo que aquí no hay nada."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?[K] What's up, [hero]?", french="Hein?[K] Qu'est-ce qui se passe,\n[hero]?", german=" Äh?[K] Was ist, [hero]?", italian=" Mmm?[K] Che hai, [hero]?", spanish=" ¿Eh?[K] ¿Qué pasa, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh?[K] What's the matter,\n[hero]?", french="Hein?[K] Qu'est-ce qui se passe,\n[hero]?", german=" Oh![K] Was ist los, [hero]?", italian="Mmm?[K] Cosa succede,\n[hero]?", spanish=" ¿Eh?[K] ¿Qué pasa, [hero]?"})
  else
  SkySceneKit.say({english="Oh?[K] What's wrong,\n[hero]?", french="Hein?[K] Qu'est-ce qui se passe,\n[hero]?", german="Oh![K] Stimmt etwas nicht,\n[hero]?", italian="Mmm?[K] Cosa succede,\n[hero]?", spanish=" ¿Eh?[K] ¿Qué pasa, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...............)", french="(...............)", german="(...............)", italian="(...............)", spanish="(...)"})
  else
  SkySceneKit.say({english="(...............)", french="(...............)", german="(...............)", italian="(...............)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(This feeling...)", french="(Cette sensation...)", german="(Dieses Gefühl...)", italian="(Questa sensazione...)", spanish="(Esa sensación...)"})
  else
  SkySceneKit.say({english="(This feeling...)", french="(Cette sensation...)", german="(Dieses Gefühl...)", italian="(Questa sensazione...)", spanish="(Esa sensación...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's like the one I got at [CS:P]Fogbound Lake[CR]...)", french="(J'ai ressenti la même chose au [CS:P]Lac\ndes Brumes[CR]...)", german="(Dasselbe hatte ich am [CS:P]Nebelsee[CR].)", italian="(È come quella che ho avuto al [CS:P]Lago Foschia[CR]...)", spanish="(Es como la que tuve en el [CS:P]Lago Velado[CR].)"})
  else
  SkySceneKit.say({english="(It's like the one I got at [CS:P]Fogbound Lake[CR]...)", french="(J'ai ressenti la même chose au [CS:P]Lac\ndes Brumes[CR]...)", german="(Dasselbe hatte ich am [CS:P]Nebelsee[CR].)", italian="(È come quella che ho avuto al [CS:P]Lago Foschia[CR]...)", spanish="(Es como la que tuve en el [CS:P]Lago Velado[CR].)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I...[K]I know this place!)", french="(Je...[K] je connais cet endroit!)", german="(Ich...[K] Ich kenne diesen Ort!)", italian="(Io...[K] sono già stato qui!)", spanish="(Yo...[K] ¡conozco este lugar!)"})
  else
  SkySceneKit.say({english="(I...[K]I know this place!)", french="(Je...[K] je connais cet endroit!)", german="(Ich...[K] Ich kenne diesen Ort!)", italian="(Io...[K] sono già stata qui!)", spanish="(Yo...[K] ¡conozco este lugar!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Maybe I have only heard of this place...[K]but it\nseems like I've been here before...)", french="(Peut-être... peut-être que j'en ai seulement\nentendu parler...[K] mais j'ai le sentiment d'être\ndéjà venu avant...)", german="(Vielleicht habe ich nur von ihm gehört.[K]\nAber es kommt mir so vor, als wäre ich schon\neinmal hiergewesen.)", italian="(Potrei... sbagliarmi...[K] ma è come se\nfossi già stato qui...)", spanish="(Tal vez solo haya oído hablar de este lugar...[K]\npero es como si ya lo conociera.)"})
  else
  SkySceneKit.say({english="(Maybe I have only heard of this place...[K]but it\nseems like I've been here before...)", french="(Peut-être... peut-être que j'en ai seulement\nentendu parler...[K] mais j'ai le sentiment d'être\ndéjà venue avant...)", german="(Vielleicht habe ich nur von ihm gehört.[K]\nAber es kommt mir so vor, als wäre ich schon\neinmal hiergewesen.)", italian="(Potrei... sbagliarmi...[K] ma è come se\nfossi già stata qui...)", spanish="(Tal vez solo haya oído hablar de este lugar...[K]\npero es como si ya lo conociera.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I can't tell which...)", french="(Difficile à dire...)", german="(Ich weiß nicht, woher...)", italian="(Non riesco a capire...)", spanish="(No sé si será una cosa o la otra.)"})
  else
  SkySceneKit.say({english="(I can't tell which...)", french="(Difficile à dire...)", german="(Ich weiß nicht, woher...)", italian="(Non riesco a capire...)", spanish="(No sé si será una cosa o la otra.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Either way, I do know this place...)", french="(Mais quoi qu'il en soit, je connais cet\nendroit...)", german="(Auf jeden Fall kenne ich diesen Ort.)", italian="(In ogni caso, conosco questo posto...)", spanish="(De cualquier forma, conozco este sitio.)"})
  else
  SkySceneKit.say({english="(Either way, I do know this place...)", french="(Mais quoi qu'il en soit, je connais cet\nendroit...)", german="(Auf jeden Fall kenne ich diesen Ort.)", italian="(In ogni caso, conosco questo posto...)", spanish="(De cualquier forma, conozco este sitio.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [hero]!", french=" Dis, [hero]!", german=" Hey, [hero]!", italian=" Ehi, [hero]! Mi senti?", spanish=" Oye, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Listen, [hero]!", french=" Dis, [hero]!", german=" Hör mal, [hero]!", italian=" [hero]? Va tutto bene?", spanish=" Oye, [hero]."})
  else
  SkySceneKit.say({english=" Say, [hero]!", french=" Dis, [hero]!", german=" Du, [hero]!", italian=" [hero]? Va tutto bene?", spanish=" Oye, [hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You were daydreaming!\nWhat's up?", french="On aurait dit que tu étais\nailleurs! Il y a un problème?", german="Träumst du vor dich hin?\nWas ist los?", italian=" Ci sei? Stai dormendo in piedi!", spanish="Estabas en las nubes.\n¿Qué pasa?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What's the matter? You were\noff in your own thoughts there.", french="On aurait dit que tu étais\nailleurs! Il y a un problème?", german="Was ist los? Du warst gerade\nganz gedankenversunken.", italian="Cosa ti succede? Mi è sembrato\nche fossi assente...", spanish="¿Qué pasa? Parecías estar\npensando en otra cosa."})
  else
  SkySceneKit.say({english="What's wrong? You seemed to\nbe in a daze there.", french="On aurait dit que tu étais\nailleurs! Il y a un problème?", german="Stimmt etwas nicht? Du wirkst\nganz abwesend.", italian="Cosa ti succede? Mi è sembrato\nche fossi assente...", spanish=" ¿Qué pasa? Parecías ausente."})
  end
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I hate to say it, but there seems\nto be nothing here.", french="Ça me désole, mais je crois\nqu'il n'y a rien ici.", german="Ich sage es ungern, aber hier\ngibt es anscheinend nichts zu finden.", italian="Comunque, sembra che non ci sia\nniente qui.", spanish="Odio admitirlo, pero aquí no\nhay nada."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well, there seems to be nothing\nhere. How disappointing!", french="Ça me désole, mais je crois\nqu'il n'y a rien ici.", german="Hier gibt es anscheinend nichts\nzu finden. Wie schade!", italian="Comunque, temo che non ci sia\nniente qui.", spanish="Bueno, parece que aquí no\nhay nada. ¡Menuda faena!"})
  else
  SkySceneKit.say({english="Well, there seems to be nothing\nhere. How disappointing!", french="Ça me désole, mais je crois\nqu'il n'y a rien ici.", german="Hier gibt es anscheinend nichts\nzu finden. Wie schade!", italian="Comunque, temo che non ci sia\nniente qui.", spanish="Vaya, parece que aquí\nno hay nada. ¡Qué decepción!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's report our findings to the\nguild. Let's go home.", french="Allons faire notre rapport\nà la Guilde. Allez, rentrons.", german="Berichten wir der Gilde davon.\nLass uns heimgehen.", italian=" Andiamo a dirlo agli altri.", spanish="Tendremos que informar al\n[CS:N]Pokégremio[CR]. Vámonos de aquí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's report our findings to the\nguild. Let's go home.", french="Allons faire notre rapport\nà la Guilde. Allez, rentrons.", german="Berichten wir der Gilde davon.\nLass uns heimgehen.", italian="Andiamo a comunicarlo alla\nGilda.", spanish="Tendremos que informar al\n[CS:N]Pokégremio[CR]. Vámonos de aquí."})
  else
  SkySceneKit.say({english="Let's report our findings to the\nguild. Let's go home.", french="Allons faire notre rapport\nà la Guilde. Allez, rentrons.", german="Berichten wir der Gilde davon.\nLass uns heimgehen.", italian="Andiamo a comunicarlo alla\nGilda.", spanish="Tendremos que informar al\n[CS:N]Pokégremio[CR]. Vámonos de aquí."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(16), p.Y+(-16), false, 1) end
  GROUND:EntTurn(hero, Direction.Up)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  GROUND:MoveToPosition(partner, 248, 216, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Down)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(180), false, 1) end
  GAME:WaitFrames(5)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(180), false, 1) end
  GAME:WaitFrames(45)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Down) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Down) end end
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  -- worldmap_SetMode(3) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetLevel(2) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_ChangeLevel(3) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetCamera(21) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() SOUND:PlayFanfare("Fanfare/NewArea") end) -- me_Play(6) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]The clouds parted over the [CS:P]Northern Desert[CR]!", french="[CN]Les nuages se sont dissipés\n[CN]au-dessus du [CS:P]Désert du Nord[CR]!", german="[CN]Die Wolken über der [CS:P]Nordwüste[CR]\n[CN]haben sich verzogen!", italian="[CN]Le nuvole si sollevano dal [CS:P]Deserto del Nord[CR]!", spanish="[CN]¡Las nubes que cubrían\n[CN]el [CS:P]Desierto Norte[CR] se disiparon!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
end
