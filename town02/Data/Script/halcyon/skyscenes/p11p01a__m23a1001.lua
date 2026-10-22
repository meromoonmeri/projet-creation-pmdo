-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P11P01A/m23a1001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Grovyle[CR], how did you end up\ncoming here?", french="[CS:N]Massko[CR], comment est-ce que\ntu as su où nous trouver?", german="[CS:N]Reptain[CR], wie bist du denn hier\ngelandet?", italian="[CS:N]Grovyle[CR], com'è che alla fine sei\nvenuto qui?", spanish="[CS:N]Grovyle[CR], ¿cómo es que has\nvenido aquí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Grovyle[CR], how did you know to\njoin us here?", french="[CS:N]Massko[CR], comment est-ce que\ntu as su où nous trouver?", german="[CS:N]Reptain[CR], woher wusstest du,\ndass du uns hier findest?", italian="[CS:N]Grovyle[CR], come hai fatto a sapere\nche eravamo qui?", spanish="[CS:N]Grovyle[CR], ¿cómo es que has\nvenido aquí?"})
  else
  SkySceneKit.say({english="[CS:N]Grovyle[CR], how did you end up\ncoming here?", french="[CS:N]Massko[CR], comment est-ce que\ntu as su où nous trouver?", german="[CS:N]Reptain[CR], wie bist du denn hier\ngelandet?", italian="[CS:N]Grovyle[CR], com'è che alla fine sei\nvenuto qui?", spanish="[CS:N]Grovyle[CR], ¿cómo es que has\nvenido aquí?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 264, 536, Direction.Up, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" [CS:N]Wigglytuff[CR] brought me.", french="C'est [CS:N]Grodoudou[CR] qui m'a\naccompagné.", german="[CS:N]Knuddeluff[CR] hat mich\nhierhergebracht.", italian=" Mi ci ha portato [CS:N]Wigglytuff[CR].", spanish=" [CS:N]Wigglytuff[CR] me trajo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? [CS:N]Wigglytuff[CR] did?", french=" Hein? [CS:N]Grodoudou[CR] a fait ça?", german=" Häh? [CS:N]Knuddeluff[CR] war das?", italian=" Eh? Ti ci ha portato [CS:N]Wigglytuff[CR]?", spanish=" ¿Eh? ¿[CS:N]Wigglytuff[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What? [CS:N]Wigglytuff[CR] did?", french=" Hein? [CS:N]Grodoudou[CR] a fait ça?", german=" Was? [CS:N]Knuddeluff[CR] war das?", italian="Cosa? Ti ci ha portato\n[CS:N]Wigglytuff[CR]?", spanish=" ¿Eh? ¿[CS:N]Wigglytuff[CR]?"})
  else
  SkySceneKit.say({english=" Pardon? [CS:N]Wigglytuff[CR] did?", french=" Hein? [CS:N]Grodoudou[CR] a fait ça?", german=" Bitte? [CS:N]Knuddeluff[CR] war das?", italian="Scusa? Ti ci ha portato\n[CS:N]Wigglytuff[CR]?", spanish=" ¿Eh? ¿[CS:N]Wigglytuff[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That's right. [CS:N]Wigglytuff[CR] had been\nlooking for me.", french=" Exact. [CS:N]Grodoudou[CR] me cherchait.", german="Das stimmt. [CS:N]Knuddeluff[CR] hatte\nnach mir gesucht.", italian="Proprio così. [CS:N]Wigglytuff[CR] è\nvenuto a cercarmi.", spanish="Exacto. [CS:N]Wigglytuff[CR] fue a\nbuscarme."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="As soon as he found me, he\nasked me to go with him. He said you were\nclose to finding the [CS:P]Hidden Land[CR].", french="Dès qu'il m'a trouvé, il m'a dit\nde le suivre parce que vous étiez sur le point\nde trouver les [CS:P]Terres Illusoires[CR].", german="Sobald er mich gefunden hatte,\nbat er mich, mitzukommen. Er sagte, ihr wärt\nkurz davor, das [CS:P]Verborgene Land[CR] zu finden.", italian="Quando mi ha trovato, mi ha\nchiesto di seguirlo. Diceva che presto avreste\nscoperto la [CS:P]Terra Nascosta[CR].", spanish="Cuando me encontró, me pidió\nque le acompañara. Dijo que estabais a punto\nde encontrar la [CS:P]Tierra Oculta[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="It worked out fine, because I\nplanned to join you anyway.", french="Ça m'arrangeait bien, puisque\nj'avais l'intention de vous rejoindre de toute\nfaçon.", german="Das war praktisch, denn ich\nwollte sowieso wieder zu euch stoßen.", italian="Andava bene, perché in ogni caso\navevo già pensato di unirmi a voi.", spanish="Fue muy oportuno, porque quería\nque nos reuniéramos de todas formas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Planned to join us...?[K]\nWait, does that mean...?", french="Tu avais l'intention de nous\nrejoindre...?[K] Attends, est-ce que ça signifie...?", german="Wieder zu uns stoßen?[K]\nWarte mal, heißt das etwa...", italian="Di unirti a noi...?[K]\nAspetta, vuoi dire...?", spanish="¿Que nos reuniéramos...?[K]\nEspera, ¿quieres decir que...?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Planned to join us...?[K]\nWait, does that mean...?", french="Tu avais l'intention de nous\nrejoindre...?[K] Attends, est-ce que ça signifie...?", german="Wieder zu uns stoßen?[K]\nWarte mal, heißt das etwa...", italian="Di unirti a noi...?[K]\nAspetta, vuoi dire...?", spanish="¿Que nos reuniéramos...?[K]\nEspera, ¿quieres decir que...?"})
  else
  SkySceneKit.say({english="Planned to join us...?[K]\nWait, does that mean...?", french="Tu avais l'intention de nous\nrejoindre...?[K] Attends, est-ce que ça signifie...?", german="Wieder zu uns stoßen?[K]\nWarte mal, heißt das etwa...", italian="Di unirti a noi...?[K]\nAspetta, vuoi dire...?", spanish="¿Que nos reuniéramos...?[K]\nEspera, ¿quieres decir que...?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That's right.[K] I've collected all\nthe necessary Time Gears.", french="Tout juste.[K] J'ai récupéré tous\nles Rouages du Temps.", german="So ist es.[K] Ich habe alle\nnotwendigen Zahnräder der Zeit eingesammelt.", italian="Sì.[K] Ho già trovato tutti\ngli Ingranaggi del Tempo.", spanish="Justo lo que estás pensando.[K]\nYa tengo todos los Engranajes del Tiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Awesome!", french=" Super!", german=" Spitzenmäßig!", italian=" Fantastico!", spanish=" ¡Genial!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes!", french=" Super!", german=" Juchhu!", italian=" Sì!", spanish=" ¡Perfecto!"})
  else
  SkySceneKit.say({english=" Yes!", french=" Super!", german=" Juchhu!", italian=" Sì!", spanish=" ¡Qué bien!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Now all we have to do is get to\nthe [CS:P]Hidden Land[CR]!", french="Tout ce qu'il nous reste à faire\nà présent, c'est nous rendre dans les [CS:P]Terres\nIllusoires[CR]!", german="Jetzt müssen wir nur noch\nzum [CS:P]Verborgenen Land[CR] gelangen!", italian="Non ci resta che andare alla\n[CS:P]Terra Nascosta[CR]!", spanish="¡Ahora solo tenemos que llegar\na la [CS:P]Tierra Oculta[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="All we have to do now is get to\nthe [CS:P]Hidden Land[CR]!", french="Tout ce qu'il nous reste à faire\nà présent, c'est nous rendre dans les [CS:P]Terres\nIllusoires[CR]!", german="Jetzt müssen wir nur noch\nzum [CS:P]Verborgenen Land[CR] gelangen!", italian="Non ci resta che andare alla\n[CS:P]Terra Nascosta[CR]!", spanish="¡Ahora solo tenemos que llegar\na la [CS:P]Tierra Oculta[CR]!"})
  else
  SkySceneKit.say({english="All we have to do now is get to\nthe [CS:P]Hidden Land[CR]!", french="Tout ce qu'il nous reste à faire\nà présent, c'est nous rendre dans les [CS:P]Terres\nIllusoires[CR]!", german="Jetzt müssen wir nur noch\nzum [CS:P]Verborgenen Land[CR] gelangen!", italian="Non ci resta che andare alla\n[CS:P]Terra Nascosta[CR]!", spanish="¡Ahora solo tenemos que llegar\na la [CS:P]Tierra Oculta[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So let's find the place with\nthe strange pattern!", french=" Trouvons vite le symbole!", german="Lasst uns also den Ort mit dem\nseltsamen Muster finden!", italian="Forza, troviamo quello strano\ndisegno!", spanish="¡Entonces tenemos que encontrar\nel símbolo de la reliquia!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So let's find that place with the\nstrange pattern now!", french=" Trouvons vite le symbole!", german="Lasst uns also den Ort mit dem\nseltsamen Muster finden!", italian="Forza, troviamo quello strano\ndisegno!", spanish="¡Entonces tenemos que encontrar\nel símbolo de la reliquia!"})
  else
  SkySceneKit.say({english="So let's get to the place with\nthat strange pattern!", french=" Trouvons vite le symbole!", german="Lasst uns also den Ort mit dem\nseltsamen Muster finden!", italian="Forza, troviamo quello strano\ndisegno!", spanish="¡Entonces tenemos que encontrar\nel símbolo de la reliquia!"})
  end
  -- message_Close
  -- back_SetGround(LEVEL_P11P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_juputoru, 256, 340, false, 2)
  GROUND:MoveToPosition(partner, 232, 348, false, 2)
  GROUND:MoveToPosition(hero, 280, 380, false, 2)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(partner, 216, 332, false, 1)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpLeft)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa! There's water here!", french=" Ouah! Il y a de l'eau ici!", german=" Huah! Hier ist Wasser!", italian=" Ehi! Qui c'è dell'acqua!", spanish=" ¡Vaya! Aquí hay agua."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wow! There's water here!", french=" Ouah! Il y a de l'eau ici!", german=" Wow! Hier ist Wasser!", italian=" Wow! Qui c'è dell'acqua!", spanish=" ¡Vaya! Aquí hay agua."})
  else
  SkySceneKit.say({english=" Wow! There's water here!", french=" Ouah! Il y a de l'eau ici!", german=" Wow! Hier ist Wasser!", italian=" Wow! Qui c'è dell'acqua!", spanish=" ¡Vaya! Aquí hay agua."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...Wait a second. It's seawater!", french="... Attendez. C'est de l'eau\nde mer!", german="Eine Sekunde mal. Das ist\nMeerwasser!", italian="Aspetta un secondo. È acqua\ndi mare!", spanish=" Un momento. ¡Es agua de mar!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...Hold on. This is seawater!", french="... Attendez. C'est de l'eau\nde mer!", german="Warte mal. Das ist\nMeerwasser!", italian=" Aspetta. È acqua di mare!", spanish=" Un momento. ¡Es agua de mar!"})
  else
  SkySceneKit.say({english=" ...Hold on. This is seawater!", french="... Attendez. C'est de l'eau\nde mer!", german="Warte mal. Das ist\nMeerwasser!", italian=" Aspetta. È acqua di mare!", spanish=" Un momento. ¡Es agua de mar!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(232, 300, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 224, 296, false, 1)
  GROUND:MoveToPosition(npc_npc_juputoru, 256, 280, false, 2)
  GROUND:MoveToPosition(hero, 280, 300, false, 2)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Left)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Look at that, [hero]!", french="Regarde un peu ça,\n[hero]!", german=" Sieh mal, [hero]!", italian=" Guarda, [hero]!", spanish=" ¡Mira eso, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Look at that, [hero]!", french="Regarde un peu ça,\n[hero]!", german=" Sieh mal, [hero]!", italian=" Guarda, [hero]!", spanish=" ¡Mira eso, [hero]!"})
  else
  SkySceneKit.say({english=" Look at that, [hero]!", french="Regarde un peu ça,\n[hero]!", german=" Sieh mal, [hero]!", italian=" Guarda, [hero]!", spanish=" ¡Mira eso, [hero]!"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
