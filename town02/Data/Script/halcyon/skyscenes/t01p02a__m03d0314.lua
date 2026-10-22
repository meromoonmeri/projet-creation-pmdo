-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/m03d0314.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_T01P02A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_T01P02A, 'UM03') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_kakureon1 = SkySceneKit.spawn_npc("kecleon", 328, 168, Direction.Down, "NPC_KAKUREON1")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_kakureon2 = SkySceneKit.spawn_npc("kecleon", 352, 168, Direction.Down, "NPC_KAKUREON2")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(5)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-8), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What was that?)", french="(C'était quoi?)", german="(Was war das?)", italian="(Cosa è stato?)", spanish="(¿Qué ha sido eso?)"})
  else
  SkySceneKit.say({english="(What was that?)", french="(C'était quoi?)", german="(Was war das?)", italian="(Cosa è stato?)", spanish="(¿Qué ha sido eso?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I'm sure I heard a shout for help just now...)", french="(Je suis certain d'avoir entendu un appel\nau secours à l'instant...)", german="(Ich habe doch gerade einen Hilfeschrei\ngehört...)", italian="(Sono sicuro di aver sentito qualcuno che\nchiedeva aiuto proprio adesso...)", spanish="(Juraría que acabo de oír un grito de\nauxilio...)"})
  else
  SkySceneKit.say({english="(I'm sure I heard a shout for help just now...)", french="(Je suis certaine d'avoir entendu un appel\nau secours à l'instant...)", german="(Ich habe doch gerade einen Hilfeschrei\ngehört...)", italian="(Sono sicura di aver sentito qualcuno che\nchiedeva aiuto proprio adesso...)", spanish="(Juraría que acabo de oír un grito de\nauxilio...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.spin(hero, 4, 2, 4)
  GAME:WaitFrames(30)
  SkySceneKit.spin(hero, 4, 1, 5)
  GAME:WaitFrames(30)
  SkySceneKit.spin(hero, 4, 2, 4)
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Did that shout come from you?)", french="(C'est toi qui as crié?)", german="(Kam der Schrei von dir?)", italian="(Sei stato tu?)", spanish="(¿Acaso has sido tú?)"})
  else
  SkySceneKit.say({english="(Did that shout come from you?)", french="(C'est toi qui as crié?)", german="(Kam der Schrei von dir?)", italian="(Sei stato tu?)", spanish="(¿Acaso has sido tú?)"})
  end
  -- message_Close
  pcall(function() SOUND:PlayBGM("Heartwarming.ogg", true) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  local npc_npc_ruriri = SkySceneKit.spawn_npc("azurill", 360, 200, Direction.Left, "NPC_RURIRI")
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Is something the matter?", french=" Tout va bien?", german=" Stimmt etwas nicht?", italian=" C'è qualcosa che non va?", spanish=" ¿Ocurre algo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_mariru = SkySceneKit.spawn_npc("marill", 488, 200, Direction.Left, "NPC_MARIRU")
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end) -- message_SetActor(ACTOR_NPC_MARIRU)
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="Hey, [CS:N]Azurill[CR]![K] What's going on?\nHurry home!", french="Hé, [CS:N]Azurill[CR]![K] Qu'est-ce qui\nt'arrive? Il faut qu'on se dépêche!", german="Hey, [CS:N]Azurill[CR]![K] Was ist los?\nBeeil dich!", italian="Ehi, [CS:N]Azurill[CR]![K] Cosa c'è?\nAndiamo a casa!", spanish="¡Eh, [CS:N]Azurill[CR]![K] ¿Qué pasa?\n¡Tenemos que volver a casa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_ruriri, npc_npc_mariru, 4) end)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Yup! I'm coming! Wait up!", french=" Ouais! J'arrive! Attends-moi!", german=" Ja! Ich komme! Warte!", italian=" Sì! Arrivo! Aspettami!", spanish=" ¡Sí! ¡Ya voy! ¡Espera!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_ruriri, hero, 4) end)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_kakureon1, Direction.Right)
  GROUND:EntTurn(npc_npc_kakureon2, Direction.Right)
  pcall(function() GAME:MoveCamera(424, 196, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_ruriri, 420, 196, false, 2)
  GROUND:MoveToPosition(npc_npc_mariru, 448, 196, false, 2)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Are you all right?", french=" Tout va bien?", german=" Ist alles in Ordnung?", italian=" Tutto bene?", spanish=" ¿Estás bien?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Yup!", french=" Ouais!", german=" Ja!", italian=" Sì!", spanish=" ¡Sí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="We're done with our shopping...\nNow we gotta look for an item we've lost!", french="Maintenant qu'on a fini les\ncourses, il faut qu'on cherche l'objet qu'on\na perdu!", german="Wir sind mit Einkaufen fertig.\nJetzt müssen wir ein Item suchen, das wir\nverloren haben!", italian="Abbiamo finito di fare la spesa...\nAdesso dobbiamo andare a cercare una\ncosa che abbiamo perso!", spanish="Ya hicimos las compras. Ahora\ntenemos que buscar el objeto que hemos\nperdido."})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Let's get going.", french=" On y va!", german=" Lass uns gehen.", italian=" Andiamo.", spanish=" Vamos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Yup! I'm coming!", french=" Ouais! J'arrive!", german=" Ja! Ich komme schon!", italian=" Andiamo!", spanish=" ¡Sí! ¡Ya voy!"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mariru, 576, 196, false, 2)
  GAME:WaitFrames(15)
  -- ResetHitAttribute(31) [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_ruriri, 576, 196, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ha! Those little guys are cute.", french="Ha! Comme ils sont mignons,\nces petits gars.", german="Ha! Diese kleinen Kerlchen sind\nja süß.", italian=" Ah! Che bei tipetti quei due!", spanish=" ¡Qué chiquillos tan simpáticos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ha! Those little guys are cute.", french="Ha! Comme ils sont mignons,\nces petits gars.", german="Ha! Diese kleinen Kerlchen sind\nja süß.", italian=" Ah, che simpatici quei due!", spanish=" ¡Qué chiquillos tan simpáticos!"})
  else
  SkySceneKit.say({english=" Ha! Those little guys are cute.", french="Ha! Comme ils sont mignons,\nces petits gars.", german="Ha! Diese kleinen Kerlchen sind\nja süß.", italian="Ah, che carini quei due\ncuccioletti!", spanish=" ¡Qué chiquillos tan simpáticos!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GROUND:EntTurn(npc_npc_kakureon1, Direction.Down)
  GROUND:EntTurn(npc_npc_kakureon2, Direction.DownLeft)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Huh?[K] What's wrong,\n[hero]?", french="Hein?[K] Qu'est-ce qu'il y a,\n[hero]?", german="Äh?[K] Was ist los,\n[hero]?", italian="Eh?[K] Cosa c'è che non va,\n[hero]?", spanish="¿Eh?[K] ¿Qué te pasa,\n[hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh?[K] What's the matter,\n[hero]?", french="Hein?[K] Qu'est-ce qu'il y a,\n[hero]?", german="Oh![K] Was ist mit dir,\n[hero]?", italian="Eh?[K] Cosa c'è che non va,\n[hero]?", spanish="¿Eh?[K] ¿Qué te ocurre,\n[hero]?"})
  else
  SkySceneKit.say({english="Huh?[K] What's the matter,\n[hero]?", french="Hein?[K] Qu'est-ce qu'il y a,\n[hero]?", german="Häh?[K] Was ist mit dir,\n[hero]?", italian="Eh?[K] Cosa c'è che non va,\n[hero]?", spanish="¿Eh?[K] ¿Qué te ocurre,\n[hero]?"})
  end
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Huh? Did I hear a shout for help\njust then?", french="Quoi? Si j'ai entendu\nun appel au secours à l'instant?", german="Äh? Ob ich vorhin einen\nHilfeschrei gehört habe?", italian="Eh? Se ho sentito qualcuno\nchiedere aiuto poco fa?", spanish="¿Cómo? ¿Que si he oído\nun grito de socorro?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Huh? Did I hear a shout for help\njust then?", french="Quoi? Si j'ai entendu\nun appel au secours à l'instant?", german="Äh? Ob ich vorhin einen\nHilfeschrei gehört habe?", italian="Eh? Se ho sentito qualcuno\nchiedere aiuto poco fa?", spanish="¿Qué dices? ¿Que si he oído\nun grito de socorro?"})
  else
  SkySceneKit.say({english="Pardon? Did I hear a shout for\nhelp just then?", french="Quoi? Si j'ai entendu\nun appel au secours à l'instant?", german="Äh? Ob ich vorhin einen\nHilfeschrei gehört habe?", italian="Eh? Se ho sentito qualcuno\nchiedere aiuto poco fa?", spanish="¿Qué? ¿Que si he oído\nun grito de socorro?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Uh, no... I didn't hear anything\nlike that!", french="Euh, non... je n'ai rien entendu\nde ce genre!", german="Äh, nein... Ich habe niemanden\nschreien gehört!", italian="Ehm, no... Non ho sentito\nniente del genere!", spanish=" No... Yo no he oído nada."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Uh, no... I didn't hear anything\nlike that!", french="Euh, non... je n'ai rien entendu\nde ce genre!", german="Äh, nein... Ich habe niemanden\nschreien gehört!", italian="Ehm, no... Non ho sentito\nniente del genere!", spanish=" No... Yo no he oído nada."})
  else
  SkySceneKit.say({english="Uh, no... I didn't hear anything\nlike that!", french="Euh, non... je n'ai rien entendu\nde ce genre!", german="Äh, nein... Ich habe niemanden\nschreien gehört!", italian="Ehm, no... Non ho sentito\nniente del genere!", spanish=" No... Yo no he oído nada."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kakureon1, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [CS:N]Kecleon[CR] brothers.", french=" Dites, les frères [CS:N]Kecleon[CR].", german=" Hey, Brüder [CS:N]Kecleon[CR].", italian=" Ehi, fratelli [CS:N]Kecleon[CR].", spanish=" Perdonen, hermanos [CS:N]Kecleon[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey, [CS:N]Kecleon[CR] brothers.", french=" Dites, les frères [CS:N]Kecleon[CR].", german=" Hey, Brüder [CS:N]Kecleon[CR].", italian=" Ehi, fratelli [CS:N]Kecleon[CR].", spanish=" Perdonen, hermanos [CS:N]Kecleon[CR]."})
  else
  SkySceneKit.say({english=" Say, [CS:N]Kecleon[CR] brothers.", french=" Dites, les frères [CS:N]Kecleon[CR]...", german=" Sagt mal, Brüder [CS:N]Kecleon[CR]...", italian=" Ehi, fratelli [CS:N]Kecleon[CR].", spanish=" Perdonen, hermanos [CS:N]Kecleon[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Did you hear anything strange\njust a moment ago?", french="... vous n'avez pas entendu\nun cri étrange à l'instant?", german="Habt ihr vorhin irgendetwas\nSeltsames gehört?", italian="Avete sentito qualcosa di strano\nun attimo fa?", spanish="¿Han oído algo raro hace\nun momento?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Did you hear anything strange\njust a moment ago?", french="... vous n'avez pas entendu\nun cri étrange à l'instant?", german="Habt ihr vorhin irgendetwas\nSeltsames gehört?", italian="Avete sentito qualcosa di strano\nun attimo fa?", spanish="¿Han oído algo extraño hace\nun momento?"})
  else
  SkySceneKit.say({english="Did you hear anything strange\njust a moment ago?", french="... vous n'avez pas entendu\nun cri étrange à l'instant?", german="Habt ihr vorhin irgendetwas\nSeltsames gehört?", italian="Avete sentito qualcosa di strano\nun attimo fa?", spanish="¿Han oído algo extraño hace\nun momento?"})
  end
  -- message_Close
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon1, "question", 1) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon2, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" No, nothing out of the ordinary.", french="Non, rien qui sorte de\nl'ordinaire.", german=" Nein, nichts Ungewöhnliches.", italian=" No, niente di strano.", spanish=" Pues no, yo no he oído nada raro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english=" I didn't hear anything odd either.", french="Je n'ai rien entendu d'étrange\nnon plus.", german="Ich habe auch nichts Auffälliges\ngehört.", italian=" Neanche io.", spanish="Yo tampoco he oído nada fuera\nde lo normal."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="See? The [CS:N]Kecleon[CR] brothers\ndidn't hear anything like that either.", french="Tu vois? Les frères [CS:N]Kecleon[CR]\nn'ont rien entendu non plus.", german="Siehst du? Die Brüder [CS:N]Kecleon[CR]\nhaben auch nichts dergleichen gehört.", italian="Visto? Neanche i fratelli [CS:N]Kecleon[CR]\nhanno sentito niente.", spanish="¿Ves? Los hermanos [CS:N]Kecleon[CR]\ntampoco han oído nada."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It sounds like the [CS:N]Kecleon[CR]\nbrothers didn't hear anything odd either.", french="Tu vois? Les frères [CS:N]Kecleon[CR]\nn'ont rien entendu non plus.", german="Die Brüder [CS:N]Kecleon[CR] haben\nanscheinend auch nichts dergleichen gehört.", italian="Visto? Neanche i fratelli [CS:N]Kecleon[CR]\nhanno sentito niente.", spanish="Parece que los hermanos [CS:N]Kecleon[CR]\ntampoco han oído nada raro."})
  else
  SkySceneKit.say({english="The [CS:N]Kecleon[CR] brothers didn't hear\nanything strange either.", french="Tu vois? Les frères [CS:N]Kecleon[CR]\nn'ont rien entendu non plus.", german="Die Brüder [CS:N]Kecleon[CR] haben\nauch nichts dergleichen gehört.", italian="Visto? Neanche i fratelli [CS:N]Kecleon[CR]\nhanno sentito niente.", spanish="Los hermanos [CS:N]Kecleon[CR]\ntampoco han oído nada."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You probably just imagined it,\n[hero].", french=" Tu as dû rêver, [hero].", german="Du hast es dir wahrscheinlich\nnur eingebildet, [hero].", italian="Sarà stata la tua immaginazione,\n[hero].", spanish="Serán imaginaciones tuyas,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You must have imagined it,\n[hero].", french=" Tu as dû rêver, [hero].", german="Du musst es dir eingebildet\nhaben, [hero].", italian="Sarà stata la tua immaginazione,\n[hero].", spanish="Serán imaginaciones tuyas,\n[hero]."})
  else
  SkySceneKit.say({english="You must have just imagined it,\n[hero].", french=" Tu as dû rêver, [hero].", german="Du musst es dir nur eingebildet\nhaben, [hero].", italian="Sarà stata la tua immaginazione,\n[hero].", spanish="Serán imaginaciones tuyas,\n[hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(No, I'm positive that I didn't imagine it.)", french="(Non, je suis sûr que je n'ai pas rêvé.)", german="(Nein, ich bin mir sicher, dass ich es mir\nnicht eingebildet habe.)", italian="(No, sono sicuro di non essermelo immaginato.)", spanish="(No, estoy seguro de que no me lo he\nimaginado.)"})
  else
  SkySceneKit.say({english="(No, I'm positive that I didn't imagine it.)", french="(Non, je suis sûre que je n'ai pas rêvé.)", german="(Nein, ich bin mir sicher, dass ich es mir\nnicht eingebildet habe.)", italian="(No, sono sicura di non essermelo immaginato.)", spanish="(No, estoy segura de que no me lo he\nimaginado.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I definitely heard it!)", french="(Je l'ai vraiment entendu!)", german="(Ich habe es ganz sicher gehört!)", italian="(L'ho sentito, ne sono certo!)", spanish="(¡Estoy seguro de haberlo oído!)"})
  else
  SkySceneKit.say({english="(I definitely heard it!)", french="(Je l'ai vraiment entendu!)", german="(Ich habe es ganz sicher gehört!)", italian="(L'ho sentito, ne sono certa!)", spanish="(¡Estoy segura de haberlo oído!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That shout that I heard...)", french="(Ce cri que j'ai entendu...)", german="(Dieser Schrei, den ich gehört habe...)", italian="(L'urlo che ho sentito...)", spanish="(Aquel grito...)"})
  else
  SkySceneKit.say({english="(That shout that I heard...)", french="(Ce cri que j'ai entendu...)", german="(Dieser Schrei, den ich gehört habe...)", italian="(L'urlo che ho sentito...)", spanish="(Aquel grito...)"})
  end
  -- message_Close
  GAME:FadeOut(false,  15)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]H-h-h...HELP!", french="[CN]A... A L'AIDE!", german="[CN]H-h-h...HILFE!", italian="[CN]A-A-Aiuto...!", spanish="[CN]¡So... socorro!"})
  -- message_Close
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(15)
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(There's no mistaking it...)", french="(Il n'y a aucun doute...)", german="(Es gibt gar keinen Zweifel.)", italian="(È impossibile sbagliarsi...)", spanish="(No me cabe ninguna duda.)"})
  else
  SkySceneKit.say({english="(There's no mistaking it...)", french="(Il n'y a aucun doute...)", german="(Es gibt gar keinen Zweifel.)", italian="(È impossibile sbagliarsi...)", spanish="(No me cabe ninguna duda.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That was [CS:N]Azurill[CR]'s scream!)", french="(C'était [CS:N]Azurill[CR] qui criait!)", german="(Dieser Schrei kam von [CS:N]Azurill[CR]!)", italian="(Era l'urlo di [CS:N]Azurill[CR]!)", spanish="(¡Quien gritaba era [CS:N]Azurill[CR]!)"})
  else
  SkySceneKit.say({english="(That was [CS:N]Azurill[CR]'s scream!)", french="(C'était [CS:N]Azurill[CR] qui criait!)", german="(Dieser Schrei kam von [CS:N]Azurill[CR]!)", italian="(Era l'urlo di [CS:N]Azurill[CR]!)", spanish="(¡Quien gritaba era [CS:N]Azurill[CR]!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Uh, are you daydreaming?", french="Alors, tu es dans la lune\nou quoi?", german=" Äh, träumst du etwa?", italian="Ehm, stai sognando a\nocchi aperti?", spanish=" ¿Estás soñando?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Uh, are you daydreaming?", french="Alors, tu es dans la lune\nou quoi?", german=" Äh, träumst du etwa?", italian="Ehm, stai sognando a\nocchi aperti?", spanish=" ¿Estás soñando?"})
  else
  SkySceneKit.say({english=" Uh, are you daydreaming?", french="Alors, tu es dans la lune\nou quoi?", german=" Äh, träumst du etwa?", italian="Ehm, stai sognando a\nocchi aperti?", spanish=" ¿Estás soñando?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go already, [hero]!", french=" On rentre, [hero]!", german=" Komm, wir gehen, [hero]!", italian=" Muoviamoci, [hero]!", spanish=" ¡Vámonos ya, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's move it, [hero]!", french=" On rentre, [hero]!", german=" Lass uns gehen, [hero]!", italian=" Muoviamoci, [hero]!", spanish=" ¡Vámonos, [hero]!"})
  else
  SkySceneKit.say({english=" Let's hustle, [hero]!", french=" On rentre, [hero]!", german=" Beeilen wir uns, [hero]!", italian=" Muoviamoci, [hero]!", spanish="¡Tenemos que irnos,\n[hero]!"})
  end
  -- message_Close
  GROUND:EntTurn(npc_npc_kakureon2, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  SkySceneKit.cleanup_npcs()
end
