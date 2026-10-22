-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D09P11A/m10a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetBanner2(LEVEL_V09P04A, 0, 156, 140, 9,) [bannière 2e écran NDS: information dupliquée du menu, hors canvas unique - documenté]
  GAME:FadeIn(45)
  GAME:WaitFrames(160)
  GAME:FadeOut(false, 45)
  GAME:WaitFrames(15)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[14] = 1 -- dungeon_mode(14) = DMODE_OPEN (ROM)
  SkyProg.set(11, 1) -- $SCENARIO_MAIN = scn[11,1] (ROM)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey![K] There it is, [hero]!", french=" Eh![K] La voilà, [hero]!", german=" Hey![K] Da ist es, [hero]!", italian="Ehi![K] Guarda, [hero]!\nEccolo là!", spanish=" ¡Mira, [hero]![K] ¡Allí está!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey![K] I see it, [hero]!", french=" Eh![K] La voilà, [hero]!", german=" Hey![K] Ich sehe es, [hero]!", italian="Ehi![K] Guarda, [hero]!\nEccolo là!", spanish=" ¡Mira, [hero]![K] ¡Allí está!"})
  else
  SkySceneKit.say({english=" Oh![K] I see it, [hero]!", french=" Eh![K] La voilà, [hero]!", german=" Oh![K] Ich sehe es, [hero]!", italian="Ehi![K] Guarda, [hero]!\nEccolo là!", spanish=" ¡Mira, [hero]![K] ¡Allí está!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" There! There's a big fissure!", french=" Là, il y a un passage!", german=" Da! Da ist ein großer Riss!", italian=" Guarda! C'è un bel buco, lì!", spanish=" ¡Allí! ¡Hay una grieta enorme!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" See? There's a big fissure.", french=" Là, il y a un passage!", german="Siehst du? Da ist ein großer\nRiss.", italian=" Vedi? C'è un passaggio!", spanish=" ¿Ves esa grieta enorme?"})
  else
  SkySceneKit.say({english=" There! A big fissure is open!", french=" Là, il y a un passage!", german=" Da! Da ist ein großer Riss!", italian=" Vedi? C'è un passaggio!", spanish=" ¡Allí! ¡Hay una grieta enorme!"})
  end
  -- message_Close
  -- back_SetGround(LEVEL_D09P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Steam Cave.ogg", true) end)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 268, 316, false, 2)
  GROUND:MoveToPosition(partner, 240, 300, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(hero, 268, 252, false, 2)
  GROUND:MoveToPosition(partner, 240, 252, false, 2)
  pcall(function() GAME:MoveCamera(252, 252, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It looks like we can go in\nthrough here.", french="On dirait qu'on peut entrer\npar là.", german="Es sieht so aus, als könnten wir\ndurchgehen.", italian="Forse possiamo entrare\npassandoci attraverso.", spanish="Parece que podemos entrar\npor aquí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I guess we can enter\nthrough here.", french="On dirait qu'on peut entrer\npar là.", german="Ich glaube, wir können da\ndurchgehen.", italian="Forse possiamo entrare\npassandoci attraverso.", spanish="Supongo que podemos entrar\npor aquí."})
  else
  SkySceneKit.say({english="We can go in through here,\nI think.", french="On dirait qu'on peut entrer\npar là.", german="Wir können da durchgehen,\nglaube ich.", italian="Forse possiamo entrare\npassandoci attraverso.", spanish="Creo que podemos entrar\npor aquí."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(252, 204, 60, false) end) -- performer/caméra
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(80)
  pcall(function() GAME:MoveCamera(252, 252, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Is that steam?", french=" Est-ce que c'est de la vapeur?", german=" Ist das Dampf?", italian=" È vapore, quello?", spanish=" ¿Eso de ahí es vapor?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Is that steam?", french=" Est-ce que c'est de la vapeur?", german=" Ist das Dampf?", italian=" È vapore, quello?", spanish=" ¿Eso de ahí es vapor?"})
  else
  SkySceneKit.say({english=" Is that steam?", french=" Est-ce que c'est de la vapeur?", german=" Ist das Dampf?", italian=" È vapore, quello?", spanish=" ¿Eso de ahí es vapor?"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I bet that it's going to be really\nhot in there!", french="Je parie que ça va être\nla fournaise là-dedans!", german="Es ist bestimmt total heiß da\ndrin.", italian="Mi sa che lì dentro fa un caldo\ninfernale!", spanish="Tiene pinta de que aquí dentro\nva a hacer mucho calor."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I wonder if it's going to be\nreally hot in there.", french="Je parie que ça va être\nla fournaise là-dedans!", german="Ich frage mich, ob es da drin\nsehr heiß sein wird.", italian="Deve fare proprio caldo lì\ndentro!", spanish="Me imagino que va a hacer\nmucho calor aquí dentro."})
  else
  SkySceneKit.say({english="I guess it's going to be really\nhot in there.", french="Je parie que ça va être\nla fournaise là-dedans!", german="Ich schätze, da drin wird es\nsehr heiß sein.", italian="Penso che lì dentro faccia\nveramente caldo.", spanish="Supongo que va a hacer mucho\ncalor aquí dentro."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But it's too late to get cold feet.", french="Mais il est trop tard pour avoir\nfroid aux yeux.", german="Aber es ist jetzt zu spät, um\nkalte Füße zu bekommen.", italian="Beh, è troppo tardi per tirarsi\nindietro ora!", spanish="Pero ahora no nos lo podemos\npensar dos veces."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But it's too late to get cold feet.", french="Mais il est trop tard pour avoir\nfroid aux yeux.", german="Aber es ist jetzt zu spät, um\nkalte Füße zu bekommen.", italian="Comunque, è troppo tardi per\ntirarsi indietro.", spanish="Pero ahora es demasiado\ntarde para echarse atrás."})
  else
  SkySceneKit.say({english="But it's too late for second\nthoughts.", french="Mais il est trop tard pour avoir\nfroid aux yeux.", german="Aber es ist jetzt zu spät, um\neinen Rückzieher zu machen.", italian="In ogni caso, è troppo tardi per\ntirarsi indietro.", spanish="Pero ahora es demasiado\ntarde para echarse atrás."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(20)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'm getting stoked about this,\n[hero]!", french=" Je suis surexcité, [hero]!", german="Ich bin schon ganz hibbelig,\n[hero]!", italian="Wow, [hero], non sto più\nnella pelle!", spanish="Me pica la curiosidad por saber\nlo que nos espera, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm shaking with anticipation,\n[hero]!", french=" Je suis surexcité, [hero]!", german="Ich zittere schon vor Spannung,\n[hero]!", italian=" Che emozione, [hero]!", spanish="Me muero de ganas por saber\nlo que va a pasar, [hero]."})
  else
  SkySceneKit.say({english="Oooh, [hero]! I'm about to\nburst with anticipation!", french="Je suis surexcitée,\n[hero]!", german="Uuuh, [hero]! Ich platze\ngleich vor Spannung!", italian="Oooh, [hero]! Tremo\ndall'emozione!", spanish="[hero], ¿no tienes nervios\ntú también?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What awaits inside?", french="Qu'est-ce qui nous attend\nà l'intérieur?", german=" Was uns da drin wohl erwartet?", italian=" Cosa ci aspetterà lì dentro?", spanish=" ¿Qué nos esperará dentro?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What awaits inside?", french="Qu'est-ce qui nous attend\nà l'intérieur?", german=" Was uns da drin wohl erwartet?", italian=" Cosa ci aspetterà lì dentro?", spanish=" ¿Qué nos esperará dentro?"})
  else
  SkySceneKit.say({english=" What awaits inside?", french="Qu'est-ce qui nous attend\nà l'intérieur?", german=" Was uns drinnen wohl erwartet?", italian=" Cosa ci aspetterà lì dentro?", spanish=" ¿Qué nos esperará dentro?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And what awaits us on the top?\nI can't even guess what's ahead for us!", french="Et au sommet? Je n'arrive\nmême pas à imaginer ce qui pourrait\nnous tomber dessus!", german="Und was uns wohl auf dem\nGipfel erwartet? Ich kann es mir nicht einmal\nvorstellen!", italian="E cosa troveremo quando\narriveremo in cima? Non riesco proprio a\nimmaginarlo!", spanish="¿Y en la cima? ¡No puedo\nni imaginarlo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And what awaits us on the top?\nI can't even imagine what's in store for us.", french="Et au sommet? Je n'arrive\nmême pas à imaginer ce qui pourrait\nnous tomber dessus!", german="Und was uns wohl auf dem\nGipfel erwartet? Ich kann mir nicht im\nEntferntesten vorstellen, was uns bevorsteht!", italian="E cosa troveremo quando\narriveremo in cima? Non riesco proprio a\nimmaginarlo!", spanish="¿Y en la cima? ¡No puedo\nni imaginarlo!"})
  else
  SkySceneKit.say({english="And what awaits us on the top?\nI can barely imagine what's in store for us!", french="Et au sommet? Je n'arrive\nmême pas à imaginer ce qui pourrait\nnous tomber dessus!", german="Und was uns wohl auf dem\nGipfel erwartet? Ich kann mir kaum\nvorstellen, was uns bevorsteht!", italian="E cosa troveremo quando\narriveremo in cima? Non riesco proprio a\nimmaginarlo!", spanish="¿Y en la cima? ¡No puedo\nni imaginarlo!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We're heading into a place where\nno one has ever gone before!", french="Tu te rends compte, on entre\ndans un lieu encore inexploré à ce jour!", german="Wir betreten gleich einen Ort,\nan dem noch niemand vorher war!", italian="Stiamo per andare dove nessuno\nè mai stato prima!", spanish="¡Vamos a un sitio al que nadie\nha ido nunca!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're heading into a place where\nno one has ever gone before!", french="Tu te rends compte, on entre\ndans un lieu encore inexploré à ce jour!", german="Wir betreten gleich einen Ort,\nan dem noch niemand vorher war!", italian="Stiamo per andare dove nessuno\nè mai stato prima!", spanish="¡Vamos a un sitio al que nadie\nha ido nunca!"})
  else
  SkySceneKit.say({english="We're heading into a place where\nno one has ever gone before!", french="Tu te rends compte, on entre\ndans un lieu encore inexploré à ce jour!", german="Wir betreten gleich einen Ort,\nan dem noch niemand vorher war!", italian="Stiamo per andare dove nessuno\nè mai stato prima!", spanish="¡Vamos a un sitio al que nadie\nha ido nunca!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That gets my pulse pounding!", french=" J'ai le cœur qui bat la chamade!", german="Bei dem Gedanken schlägt mein\nPuls wie verrückt!", italian=" Che botta di adrenalina!", spanish=" ¡Qué nervios!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That makes my pulse race!", french=" J'ai le cœur qui bat la chamade!", german="Bei dem Gedanken rast mein\nPuls!", italian=" Che emozione fortissima!", spanish=" ¡Qué nervios!"})
  else
  SkySceneKit.say({english=" That makes my heart flutter!", french=" J'ai le cœur qui bat la chamade!", german="Bei dem Gedanken bekomme ich\nHerzrasen!", italian=" Il cuore mi batte all'impazzata!", spanish=" ¡Estoy hecha un flan!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(10)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's go, [hero]![K] Let's go\ninside and climb upward!", french="C'est parti, [hero]![K]\nEntrons et entamons notre ascension!", german="Gehen wir, [hero]![K] Lass\nuns reingehen und nach oben steigen!", italian="Vieni, [hero]![K] Entriamo\ne raggiungiamo la vetta!", spanish="¡Venga, [hero]![K]\n¡Vamos a entrar y a subir!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go, [hero]![K] Let's go\ninside and climb upward!", french="C'est parti, [hero]![K]\nEntrons et entamons notre ascension!", german="Gehen wir, [hero]![K] Lass\nuns hineingehen und dann nach oben steigen!", italian="Forza, [hero]![K] Entriamo\ne raggiungiamo la vetta!", spanish="¡Venga, [hero]![K]\n¡Vamos a entrar y a subir!"})
  else
  SkySceneKit.say({english="Let's go, [hero]![K] Let's go\ninside and climb upward!", french="C'est parti, [hero]![K]\nEntrons et entamons notre ascension!", german="Gehen wir, [hero]![K] Lass\nuns hineingehen und dann nach oben steigen!", italian="Andiamo, [hero]![K]\nEntriamo e raggiungiamo la vetta!", spanish="¡Venga, [hero]![K]\n¡Vamos a entrar y a subir!"})
  end
  -- message_Close
end
