-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D28P33A/m24a0803.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Hidden Highland.ogg", true) end)
  -- back_SetGround(LEVEL_D28P33A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  GAME:FadeIn(30)
  -- SetAnimation(5) [anim idle native]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 136, 240, Direction.Right, "NPC_JUPUTORU")
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(partner, 224, 196, false, 2) -- Slide2PositionMark (glissement)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_juputoru, 224, 180, false, 2) -- Slide2PositionMark (glissement)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(hero, 224, 212, false, 2) -- Slide2PositionMark (glissement)
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(partner, 264, 196, false, 2)
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(npc_npc_juputoru, 244, 180, false, 2)
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(hero, 248, 212, false, 2)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Up)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" This appears to be the top.", french="On dirait qu'on est arrivés\nau sommet.", german=" Höher scheint es nicht zu gehen.", italian=" Dovremmo essere in cima.", spanish=" Parece que hemos llegado arriba."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Right)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! Look here!", french=" Eh, regardez ça!", german=" Hey! Seht mal hier!", italian=" Ehi! Guardate qui!", spanish=" ¡Eh! ¡Mirad esto!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! Look here!", french=" Eh, regardez ça!", german=" Hey! Seht mal hier!", italian=" Ehi! Guardate qui!", spanish=" ¡Eh! ¡Mirad esto!"})
  else
  SkySceneKit.say({english=" Hey! Look here!", french=" Eh, regardez ça!", german=" Hey! Seht mal hier!", italian=" Ehi! Guardate qui!", spanish=" ¡Eh! ¡Mirad esto!"})
  end
  -- message_Close
  GROUND:MoveToPosition(partner, 272, 196, false, 1)
  GROUND:MoveToPosition(npc_npc_juputoru, 280, 180, false, 2)
  GROUND:MoveToPosition(hero, 308, 212, false, 2)
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownRight)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" The strange pattern is here too.", french=" Encore ce symbole étrange.", german="Hier gibt es auch dieses\nseltsame Muster.", italian=" C'è anche qui lo strano disegno.", spanish="Ese extraño símbolo también\nestá aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="There's a small, hollow spot in\nthe middle.", french=" Il y a un petit trou au milieu.", german="Da ist eine kleine, runde Stelle\nin der Mitte.", italian="C'è una piccola cavità nel\nmezzo.", spanish="Hay un pequeño hueco en\nel centro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There's a small indentation in\nthe middle.", french=" Il y a un petit trou au milieu.", german="Da ist eine kleine Delle in der\nMitte.", italian="C'è una piccola cavità nel\nmezzo.", spanish="Hay un pequeño hueco en\nel centro."})
  else
  SkySceneKit.say({english="There's a small, hollow spot in\nthe middle.", french=" Il y a un petit trou au milieu.", german="Da ist eine kleine Delle in der\nMitte.", italian="C'è una piccola cavità nel\nmezzo.", spanish="Hay un pequeño hueco en\nel centro."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What's it for...?", french=" Je me demande à quoi ça sert...", german=" Wofür sie wohl da ist?", italian=" A cosa serve...?", spanish=" ¿Para qué será?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I wonder what it's for...?", french=" Je me demande à quoi ça sert...", german=" Ich frag mich, wozu sie da ist?", italian=" A cosa servirà?", spanish=" ¿Para qué será?"})
  else
  SkySceneKit.say({english=" I wonder what it's for...?", french=" Je me demande à quoi ça sert...", german=" Ich frag mich, wozu sie da ist?", italian=" A cosa servirà?", spanish=" ¿Para qué será?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Oh?[K] What's that...?)", french="(Oh?[K] Qu'est-ce que...?)", german="(Oh?[K] Was ist das?)", italian="(Eh?[K] Cos'è quella...?)", spanish="(¿Eh?[K] ¿Qué es eso?)"})
  else
  SkySceneKit.say({english="(Oh?[K] What's that...?)", french="(Oh?[K] Qu'est-ce que...?)", german="(Oh?[K] Was ist das?)", italian="(Eh?[K] Cos'è quella...?)", spanish="(¿Eh?[K] ¿Qué es eso?)"})
  end
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-24), false, 2) end
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:MoveToPosition(hero, 300, 168, false, 2)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Hm? What is it, [hero]?", french="Hmm? Qu'est-ce qu'il y a,\n[hero]?", german=" Hm? Was gibt es, [hero]?", italian=" Eh? Cosa c'è, [hero]?", spanish="¿Eh? ¿Qué has encontrado,\n[hero]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(300, 164, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_juputoru, 272, 164, false, 2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(20), p.Y+(0), false, 2) end
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpRight)
  GROUND:MoveToPosition(partner, 324, 164, false, 2)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(There's a stone tablet...)", french="(Sur la tablette de pierre, là...)", german="(Da ist eine Steintafel.)", italian="(C'è una stele di pietra...)", spanish="(Hay una losa de piedra.)"})
  else
  SkySceneKit.say({english="(There's a stone tablet...)", french="(Sur la tablette de pierre, là...)", german="(Da ist eine Steintafel.)", italian="(C'è una stele di pietra...)", spanish="(Hay una losa de piedra.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(There seems to be something inscribed here.)", french="(On dirait que quelque chose y est gravé.)", german="(Und auf ihr scheint eine Inschrift zu sein.)", italian="(C'è inciso qualcosa.)", spanish="(Parece haber algo inscrito en ella.)"})
  else
  SkySceneKit.say({english="(There seems to be something inscribed here.)", french="(On dirait que quelque chose y est gravé.)", german="(Und auf ihr scheint eine Inschrift zu sein.)", italian="(C'è inciso qualcosa.)", spanish="(Parece haber algo inscrito en ella.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What are these...?[K] These strange runes...?)", french="(Qu'est-ce que...?[K] Ces runes étranges...?)", german="(Was sind das für...[K] für seltsame Runen?)", italian="(Cos'è questa...?[K] Questa strana scrittura...?)", spanish="(Vaya...[K] ¿Qué serán estas extrañas\ninscripciones?)"})
  else
  SkySceneKit.say({english="(What are these...?[K] These strange runes...?)", french="(Qu'est-ce que...?[K] Ces runes étranges...?)", german="(Was sind das für...[K] für seltsame Runen?)", italian="(Cos'è questa...?[K] Questa strana scrittura...?)", spanish="(Vaya...[K] ¿Qué serán estas extrañas\ninscripciones?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="This is inscribed with [CS:K]Unown[CR]\nletters.", french=" Ce sont des lettres [CS:K]Zarbi[CR].", german="Da ist eine Inschrift aus\n[CS:K]Icognito[CR]-Buchstaben drauf.", italian=" Sembrano caratteri [CS:K]Unown[CR].", spanish="Esto está escrito en la lengua\nde los [CS:K]Unown[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="It's written in an ancient\nlanguage.", french=" C'est une langue antique.", german="Sie ist in einer alten Sprache\ngeschrieben.", italian=" È una lingua antica.", spanish="Se trata de un lenguaje muy\nantiguo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_juputoru, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Can you read it, [CS:N]Grovyle[CR]?", french=" Tu peux la déchiffrer, [CS:N]Massko[CR]?", german=" Kannst du das lesen, [CS:N]Reptain[CR]?", italian=" Riesci a decifrarla, [CS:N]Grovyle[CR]?", spanish=" ¿Puedes leerlo, [CS:N]Grovyle[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Can you read it, [CS:N]Grovyle[CR]?", french=" Tu peux la déchiffrer, [CS:N]Massko[CR]?", german=" Kannst du das lesen, [CS:N]Reptain[CR]?", italian=" Riesci a decifrarla, [CS:N]Grovyle[CR]?", spanish=" ¿Puedes leerlo, [CS:N]Grovyle[CR]?"})
  else
  SkySceneKit.say({english=" You can read that, [CS:N]Grovyle[CR]?", french=" Tu peux la déchiffrer, [CS:N]Massko[CR]?", german=" Du kannst das lesen, [CS:N]Reptain[CR]?", italian=" Tu puoi decifrarla, [CS:N]Grovyle[CR]?", spanish=" ¿Puedes leerlo, [CS:N]Grovyle[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Yes. I've researched extensively\nto learn about this.", french="Oui, j'ai fait beaucoup\nde recherches à ce sujet.", german="Ja. Ich habe intensiv geforscht,\num mehr darüber zu lernen.", italian="Sì, ho fatto approfondite\nricerche per imparare questo tipo di scrittura.", spanish="Sí. Investigué mucho antes de\nvenir. Quería estar preparado por si ocurría\nalgo así."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Really?![K] Awesome![K] Quick!\nRead it!", french="Vraiment?![K] Génial![K] Lis\nce message, vite!", german="Wirklich?!?[K] Spitze![K] Schnell!\nLies vor!", italian="Davvero?![K] Fantastico![K]\nPresto! Leggila!", spanish="¿En serio?[K] ¡Genial![K]\n¡Rápido! ¡Léelo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Really?![K] Great![K] Quick! Read it!", french="Vraiment?![K] Génial![K] Lis\nce message, vite!", german="Wirklich?!?[K] Klasse![K] Schnell!\nLies vor!", italian="Davvero?![K] Grandioso![K] Presto!\nLeggila!", spanish="¿En serio?[K] ¡Qué casualidad![K]\n¡Rápido! ¡Léelo!"})
  else
  SkySceneKit.say({english=" Really?![K] Great![K] Quick! Read it!", french="Vraiment?![K] Génial![K] Lis\nce message, vite!", german="Wirklich?!?[K] Klasse![K] Schnell!\nLies vor!", italian="Davvero?![K] Grandioso![K] Presto!\nLeggila!", spanish="¿En serio?[K] ¡Qué suerte![K]\n¡Rápido! ¡Léelo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Don't be so impatient. Give me\na minute.", french=" Patience, laisse-moi une minute.", german="Nicht so ungeduldig. Gib mir eine\nMinute Zeit.", italian="Non essere impaziente. Dammi un\nminuto.", spanish="No seas tan impaciente. Espera\nun poco."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="............................................[K]\n...........................................................", french="............................................[K]\n..................................................................", german="............................................[K]\n...........................................................", italian="............................................[K]\n.........................................................", spanish=" ...[K] ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...So, [CS:N]Grovyle[CR]?", french=" ... Alors, [CS:N]Massko[CR], ça dit quoi?", german=" Also, [CS:N]Reptain[CR]?", italian=" Allora, [CS:N]Grovyle[CR]?", spanish=" ¿Y bien, [CS:N]Grovyle[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...So, [CS:N]Grovyle[CR]?", french=" ... Alors, [CS:N]Massko[CR], ça dit quoi?", german=" Also, [CS:N]Reptain[CR]?", italian=" Allora, [CS:N]Grovyle[CR]?", spanish=" ¿Y bien, [CS:N]Grovyle[CR]?"})
  else
  SkySceneKit.say({english=" ...So, [CS:N]Grovyle[CR]?", french=" ... Alors, [CS:N]Massko[CR], ça dit quoi?", german=" Also, [CS:N]Reptain[CR]?", italian=" Allora, [CS:N]Grovyle[CR]?", spanish=" ¿Y bien, [CS:N]Grovyle[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="............................................[K]\n...I've got it.", french="............................................[K]\n... Ça y est, j'ai compris.", german="............................................[K]\n...Ich habe es.", italian="............................................[K]\n... Ci sono.", spanish=" Hum...[K] Ya lo tengo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="It appears this place itself...[K]\nThis is the Rainbow Stoneship.", french="Ça raconte que cet endroit\nlui-même...[K] est le Vaisseau Arc-en-Ciel.", german="Es scheint dieser Ort selbst zu\nsein...[K] Das ist das Regenbogen-Steinschiff.", italian="È questo...[K] Questo è il Vascello\nArcobaleno.", spanish="Parece que este sitio es...[K]\nEsto es la Barca Arcoiris."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?! This is it?!", french=" Hein?! C'est ça?!", german=" Äh? Das hier soll es sein?!?", italian=" Eh?! È questo?!", spanish=" ¿Cómo? ¿Seguro?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?! This is it?!", french=" Hein?! C'est ça?!", german=" Was? Das hier soll es sein?!?", italian=" Eh?! È questo?!", spanish=" ¿Cómo? ¿Seguro?"})
  else
  SkySceneKit.say({english=" Pardon?! This is it?!", french=" Hein?! C'est ça?!", german=" Äh? Das hier soll es sein?!?", italian=" Eh?! È questo?!", spanish=" ¿Cómo? ¿Seguro?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Yeah. That's right.", french=" Ouais, c'est exact.", german=" Ja, genau.", italian=" Sì. Proprio così.", spanish=" Sí, así es."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.DownLeft)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" There is an indentation there.", french=" Ce trou, là.", german=" Hier ist eine Vertiefung.", italian=" C'è una cavità qui.", spanish=" Hay un hueco aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(300, 204, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_juputoru, 272, 192, false, 1)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 300, 180, false, 1)
  GROUND:MoveToPosition(partner, 324, 192, false, 1)
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownRight)
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Here it is.", french=" Juste ici.", german=" Hier ist sie.", italian=" Eccola.", spanish=" Aquí está."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" [partner].", french=" [partner].", german=" [partner].", italian=" [partner].", spanish=" [partner]."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" This is where it goes.", french=" C'est là que tout se joue.", german=" Da gehört es hinein.", italian=" Questo va messo qui.", spanish=" Ahí es donde va."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Fit that fragment with the\nstrange pattern on it into the indentation.", french="Place ton Fragment de Relique\nà l'étrange symbole dans cette cavité.", german="Steck das Fragment mit dem\nsonderbaren Muster in die Vertiefung.", italian="Metti il frammento con\nlo strano disegno nell'incavatura.", spanish="Encaja el fragmento del dibujo\nextraño en la hendidura."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Huh? Put the Relic Fragment in\nthere?", french="Pardon? Tu veux que je mette\nle Fragment de Relique là-dedans?", german="Äh? Das Reliktfragment\ndahinein?", italian="Eh? Devo mettere lì\nil Frammento Antico?", spanish=" ¿Que la meta ahí dentro?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What? You want me to put the\nRelic Fragment in there?", french="Pardon? Tu veux que je mette\nle Fragment de Relique là-dedans?", german="Was? Du möchtest, dass ich das\nReliktfragment da hineinstecke?", italian="Come? Vuoi che inserisca lì\nil Frammento Antico?", spanish="¿Que meta ahí la Reliquia de\nPiedra?"})
  else
  SkySceneKit.say({english="What? Put the Relic Fragment\nin there?", french="Pardon? Tu veux que je mette\nle Fragment de Relique là-dedans?", german="Was? Du möchtest, dass ich das\nReliktfragment da hineinstecke?", italian="Come? Vuoi che metta lì\nil Frammento Antico?", spanish="¿Que meta ahí la Reliquia de\nPiedra?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That's right.[K] That will activate\nthe Rainbow Stoneship.", french="Exact.[K] C'est comme ça qu'on\nactivera le Vaisseau Arc-en-Ciel.", german="So ist es.[K] Dadurch wird das\nRegenbogen-Steinschiff aktiviert.", italian="Proprio così.[K] Attiva il Vascello\nArcobaleno.", spanish="Eso es.[K]\nEso activará la Barca Arcoiris."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We can ride it to [CS:P]Temporal\nTower[CR]...[K] That's what it said on the tablet.", french="Et il nous conduira à la [CS:P]Tour\ndu Temps[CR]...[K] C'est ce qui est écrit sur\nla tablette.", german="Damit können wir zum [CS:P]Zeitturm[CR]\nfahren...[K] Das steht auf der Tafel geschrieben.", italian="Ci porterà alla [CS:P]Torre del[CR]\n[CS:P]Tempo[CR]...[K] C'era scritto sulla stele.", spanish="Así podremos ir en ella a\nla [CS:P]Torre del Tiempo[CR]...[K]\nEso es lo que dice en la inscripción."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Really?!", french=" Vraiment?!", german=" Wirklich?!?", italian=" Davvero?!", spanish=" ¿En serio?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Really?!", french=" Vraiment?!", german=" Wirklich?!?", italian=" Davvero?!", spanish=" ¿En serio?"})
  else
  SkySceneKit.say({english=" Really?!", french=" Vraiment?!", german=" Wirklich?!?", italian=" Davvero?!", spanish=" ¿En serio?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Try it and see.", french=" Essaie pour voir.", german=" Probieren wir es aus.", italian=" Proviamo e vediamo.", spanish=" Prueba y verás."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" OK!", french=" Entendu!", german=" Okay!", italian=" Ok!", spanish=" Vale."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK!", french=" Entendu!", german=" Okay!", italian=" Ok!", spanish=" Venga."})
  else
  SkySceneKit.say({english=" OK!", french=" Entendu!", german=" Okay!", italian=" Ok!", spanish=" De acuerdo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-8), p.Y+(8), false, 1) end
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'll fit it into this hollow spot!", french=" Je vais le mettre dans le creux!", german="Ich werde es in diesen\nHohlraum setzen!", italian=" Lo inserisco nella cavità!", spanish=" La encajaré en el hueco."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I'll fit it into this hollow spot!", french=" Je vais le mettre dans le creux!", german="Ich werde es in diesen\nHohlraum setzen!", italian=" Lo inserisco nella cavità!", spanish=" La encajaré en el hueco."})
  else
  SkySceneKit.say({english=" I'll fit it into this hollow spot!", french=" Je vais le mettre dans le creux!", german="Ich werde es in diesen\nHohlraum setzen!", italian=" Lo inserisco nella cavità!", spanish=" La encajaré en el hueco."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "exclaim", 1) end)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" That's quite enough of that.", french=" Il suffit.", german=" Genug davon.", italian=" Ne ho abbastanza.", spanish=" Se acabaron los jueguecitos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Who...who's there?!", french=" Qui... qui va là?!", german=" Wer... Wer ist da?", italian=" Chi... Chi è?!", spanish=" ¿Quién...? ¿Quién está ahí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 136, 240, Direction.Right, "NPC_YAMIRAMI")
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end) -- message_SetActor(ACTOR_NPC_YAMIRAMI)
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Wheh-heh-heh.", french=" Whé hé hé.", german=" Wähähäh.", italian=" Meh-eh-eh-eh.", spanish=" Je, je, je, je."})
  GROUND:EntTurn(hero, Direction.DownRight)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Left)
  -- message_Close
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- GAP: se_Play(6420) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(5) [anim idle native]
  local npc_npc_yamirami2 = SkySceneKit.spawn_npc("sableye", 136, 272, Direction.Right, "NPC_YAMIRAMI2")
  -- SetAnimation(5) [anim idle native]
  local npc_npc_yamirami5 = SkySceneKit.spawn_npc("sableye", 464, 272, Direction.Left, "NPC_YAMIRAMI5")
  -- SetAnimation(5) [anim idle native]
  local npc_npc_yamirami6 = SkySceneKit.spawn_npc("sableye", 464, 240, Direction.Left, "NPC_YAMIRAMI6")
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_yamirami, 224, 180, false, 2) -- Slide2PositionMark (glissement)
  GROUND:MoveToPosition(npc_npc_yamirami2, 224, 212, false, 2) -- Slide2PositionMark (glissement)
  GROUND:MoveToPosition(npc_npc_yamirami5, 368, 212, false, 2) -- Slide2PositionMark (glissement)
  GROUND:MoveToPosition(npc_npc_yamirami6, 368, 180, false, 2) -- Slide2PositionMark (glissement)
  local npc_npc_yamirami3 = SkySceneKit.spawn_npc("sableye", 280, 312, Direction.Up, "NPC_YAMIRAMI3")
  GROUND:MoveToPosition(npc_npc_yamirami3, 280, 228, false, 2)
  local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 320, 312, Direction.Up, "NPC_YAMIRAMI4")
  GROUND:MoveToPosition(npc_npc_yamirami4, 320, 228, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami, 264, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami2, 264, 212, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami5, 336, 212, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami6, 336, 180, false, 2)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  GROUND:EntTurn(hero, Direction.Down)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-8), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.DownRight)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(8), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" The [CS:N]Sableye[CR]!", french=" Les [CS:N]Ténéfix[CR]!", german=" Die [CS:N]Zobiris[CR]!", italian=" I [CS:N]Sableye[CR]!", spanish=" ¡Los [CS:N]Sableye[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" The [CS:N]Sableye[CR]!", french=" Les [CS:N]Ténéfix[CR]!", german=" Die [CS:N]Zobiris[CR]!", italian=" I [CS:N]Sableye[CR]!", spanish=" ¡Los [CS:N]Sableye[CR]!"})
  else
  SkySceneKit.say({english=" The [CS:N]Sableye[CR]!", french=" Les [CS:N]Ténéfix[CR]!", german=" Die [CS:N]Zobiris[CR]!", italian=" I [CS:N]Sableye[CR]!", spanish=" ¡Los [CS:N]Sableye[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 464, 256, Direction.Left, "NPC_YONOWAARU")
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end) -- message_SetActor(ACTOR_NPC_YONOWAARU)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Ha-ha-ha! Hoo-hoo-ha!", french=" Ha ha ha! Ho ho ha!", german=" Ha-ha-ha! Ho-ho-ha!", italian=" Ah-ah-ah! Ooh-oh-oh!", spanish=" ¡Ja, ja, ja! ¡Jua, jua, jua!"})
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "exclaim", 1) end)
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Right)
  -- message_Close
  -- GAP: BGM BGM_THE_POWER_OF_DARKNESS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_yonowaaru, 368, 196, false, 2) -- Slide2PositionMark (glissement)
  GAME:WaitFrames(30)
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  GROUND:MoveToPosition(npc_npc_yonowaaru, 356, 196, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]D-Dusknoir[CR]!", french=" [CS:N]N-Noctunoir[CR]!", german=" [CS:N]Z-Zwirrfinst[CR]!", italian=" [CS:N]D-Dusknoir[CR]!", spanish=" ¡[CS:N]Dusknoir[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]D-Dusknoir[CR]!", french=" [CS:N]N-Noctunoir[CR]!", german=" [CS:N]Z-Zwirrfinst[CR]!", italian=" [CS:N]D-Dusknoir[CR]!", spanish=" ¡[CS:N]Dusknoir[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]D-Dusknoir[CR]!", french=" [CS:N]N-Noctunoir[CR]!", german=" [CS:N]Z-Zwirrfinst[CR]!", italian=" [CS:N]D-Dusknoir[CR]!", spanish=" ¡[CS:N]Dusknoir[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" How did you get here?!", french="Comment est-ce que tu es\narrivé là?!", german=" Wie bist du hierhergekommen?", italian=" Come hai fatto ad arrivare qui?!", spanish="¡¿Cómo has podido llegar hasta\naquí?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Humph...[K] Quite simple, actually.", french=" Pfff...[K] Un jeu d'enfant.", german=" Grmpf...[K] Sehr einfach, eigentlich.", italian="Bah...[K] A dire il vero, è stato\npiuttosto semplice.", spanish=" Bah...[K] En realidad fue muy fácil."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I had Master [CS:N]Dialga[CR] warp us\nhere directly.", french="J'ai demandé à Maître [CS:N]Dialga[CR]\nde nous téléporter.", german="Meister [CS:N]Dialga[CR] hat uns direkt\nhierher teleportiert.", italian="Il Grande [CS:N]Dialga[CR] ci ha\ntrasportato direttamente qui.", spanish="Le pedí al poderoso [CS:N]Dialga[CR] que\nnos enviase aquí directamente."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="After all, I knew that you would\ninevitably come here.", french="Après tout, je savais que vous\nfiniriez par venir ici, c'était inévitable.", german="Immerhin wusste ich, dass ihr\nunweigerlich herkommen würdet.", italian="Dopotutto, sapevo che sareste\nvenuti qui.", spanish="Después de todo, tarde o\ntemprano acabaríais viniendo a este\nlugar."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Waiting here spared us the\nbother of having to search for you.", french="En attendant ici, nous nous\nsommes épargné la peine de vous chercher.", german="Hier zu warten, ersparte uns die\nArbeit, nach euch zu suchen.", italian="Aspettare qui ci ha risparmiato\nla fatica di cercarvi.", spanish="Esperaros aquí nos ha ahorrado\nla molestia de tener que ir a buscaros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Urgh...", french=" Argh...", german=" Umpf...", italian=" Uh...", spanish=" Grr..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Hoo-hoo-ha![K] Unfortunately, you\nare coming back to the future with me.", french="Ha ha ha![K] Je suis au regret\nde vous annoncer que vous repartez\ndans le futur avec moi.", german="Ho-ho-ha![K] Leider müsst ihr\nwieder mit mir in die Zukunft kommen.", italian="Ooh-ooh-oh![K] Sfortunatamente,\nvi tocca tornare nel futuro con me.", spanish="¡Ja, jua, jua![K] Por desgracia\npara vosotros, volveréis al futuro conmigo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.DownLeft)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.UpLeft)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CS:N]Sableye[CR]![K] Take them to the\ndimensional hole!", french="[CS:N]Ténéfix[CR]![K] Emmenez-les jusqu'au\ngouffre dimensionnel!", german="[CS:N]Zobiris[CR]![K]\nBringt sie zum dimensionalen Loch!", italian="[CS:N]Sableye[CR]![K] Portateli al tunnel\ndimensionale!", spanish="¡[CS:N]Sableye[CR]![K]\n¡Llevadles al agujero dimensional!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CS:N]Sableye[CR]: Wheh-heh-heh!", french="[CS:N]Ténéfix[CR]: Whé hé hé!", german="[CS:N]Zobiris[CR]: Wähähäh!", italian="[CS:N]Sableye[CR]: Meh-eh-eh-eh!", spanish="[CS:N]Sableye[CR]: ¡Je, je, je, je!"})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
