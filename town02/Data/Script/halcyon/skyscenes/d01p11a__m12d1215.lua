-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/m12d1215.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D01P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 344, 176, Direction.Right, "NPC_YONOWAARU")
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I'm sincerely sorry I couldn't\nhelp you with that...", french="Je suis sincèrement désolé de\nne pouvoir vous aider davantage...", german="Es tut mir wirklich leid, dass ich\neuch nicht weiterhelfen kann...", italian="Sono desolato... Non sono stato\ndi nessun aiuto...", spanish="Lamento profundamente no poder\nayudaros con esto."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" However...", french=" Cependant...", german=" Aber...", italian=" Tuttavia...", spanish=" Sin embargo..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I do know about the ability that\n[hero] possesses.", french="Je connais cette faculté\nspéciale que détient [hero].", german="Ich weiß über die Fähigkeit\nvon [hero] Bescheid.", italian="So qualcosa del potere\ndi [hero].", spanish="Sí que conozco la habilidad que\nposee [hero]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Really?! What is it?!", french=" Vraiment?! Qu'est-ce que c'est?!", german=" Wirklich?!? Was ist sie?!?", italian=" Davvero? Di che si tratta?", spanish=" ¡¿Sí?! ¡¿De qué se trata?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, really?! What is it?!", french=" Vraiment?! Qu'est-ce que c'est?!", german=" Oh, wirklich?!? Was ist sie?!?", italian=" Davvero? Di che si tratta?", spanish=" ¡¿En serio?! ¡¿De qué se trata?!"})
  else
  SkySceneKit.say({english=" Oh, really?! What is it?!", french=" Vraiment?! Qu'est-ce que c'est?!", german=" Oh, wirklich?!? Was ist sie?!?", italian=" Davvero? Di che si tratta?", spanish=" ¡¿Sí?! ¡¿De qué se trata?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="The ability to see the future or\nthe past by touching something...", french="La faculté de voir le futur ou\nle passé en touchant quelque chose...", german="Die Fähigkeit, in die Zukunft\noder die Vergangenheit zu blicken, indem man\netwas berührt...", italian="Il potere di vedere nel passato o\nnel futuro...", spanish="La capacidad de ver el futuro\no el pasado mediante el tacto..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="That ability is known as the\nDimensional Scream.", french="... porte un nom: le Cri\nDimensionnel.", german="Diese Fähigkeit nennt sich\nDimensionaler Schrei.", italian="... viene chiamato Squarcio\nDimensionale.", spanish="Es una habilidad conocida como\nla Percepción de Cronos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Dimensional...[K] Scream?", french=" Le Cri...[K] Dimensionnel?", german=" Dimensionaler...[K] Schrei?", italian=" Squarcio...[K] Dimensionale?", spanish="¿Cómo?[K]\n¿La Percepción de Cronos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Dimensional...[K] Scream?", french=" Le Cri...[K] Dimensionnel?", german=" Dimensionaler...[K] Schrei?", italian=" Squarcio...[K] Dimensionale?", spanish="¿Cómo?[K]\n¿La Percepción de Cronos?"})
  else
  SkySceneKit.say({english=" Dimensional...[K] Scream?", french=" Le Cri...[K] Dimensionnel?", german=" Dimensionaler...[K] Schrei?", italian=" Squarcio...[K] Dimensionale?", spanish="¿Cómo?[K]\n¿La Percepción de Cronos?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Indeed.", french=" Exact.", german=" Genau.", italian=" Precisamente.", spanish=" Así es."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="How such an ability is learned,\nthat is unknown.", french="Nul ne sait comment\non l'acquiert.", german="Woher solch eine Fähigkeit\nkommt, ist nicht bekannt.", italian="Come si possa acquisire questo\npotere è ancora sconosciuto.", spanish="Nadie sabe cómo se adquiere\ndicha habilidad."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="But sounds and images slice\nacross the boundaries of time, breaching\nobjects and reaching into Pokémon...", french="Mais des sons et des images\ntraversent les frontières du temps et sont\ntransmis à des Pokémon via certains objets...", german="Doch Geräusche und Bilder\nreichen über Zeit und Raum hinweg bis\nin manche Pokémon...", italian="Quello che so è che i suoni e le\nimmagini attraversano i confini del tempo e\ndello spazio, raggiungono i Pokémon...", spanish="Un torrente de imágenes y\nsonidos atraviesa las barreras del tiempo, y\npueden pasar de los objetos a un Pokémon..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" To manifest as visions...", french=" ... sous forme de visions.", german="Um als Visionen Gestalt\nanzunehmen...", italian=" ... e diventano visioni...", spanish=" Manifestándose como visiones..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="And that is all I know about the\nextraordinary ability.", french="Voilà tout ce que je sais au sujet\nde ce pouvoir extraordinaire.", german="Das ist alles, was ich über diese\naußergewöhnliche Fähigkeit weiß.", italian="È tutto quel che so su questo\npotere straordinario.", spanish="Eso es todo lo que sé sobre\nesta extraordinaria habilidad."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So [hero] has an ability\nas special as the Dimensional Scream...", french="Alors comme ça, [hero]\ndétient un pouvoir aussi stupéfiant que\nle Cri Dimensionnel...", german="[hero] hat also mit\ndiesem Dimensionalen Schrei eine unglaublich\nspezielle Fähigkeit...", italian="[hero] possiede lo\nSquarcio Dimensionale...", spanish="Así que [hero] tiene una\nhabilidad tan especial como la Percepción\nde Cronos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So [hero] has an ability\nas special as the Dimensional Scream...", french="Alors comme ça, [hero]\ndétient un pouvoir aussi stupéfiant que\nle Cri Dimensionnel...", german="[hero] hat also mit\ndiesem Dimensionalen Schrei eine unglaublich\nspezielle Fähigkeit...", italian="E così, [hero] ha il dono\ndello Squarcio Dimensionale...", spanish="Así que [hero] tiene una\nhabilidad tan especial como la Percepción\nde Cronos."})
  else
  SkySceneKit.say({english="So [hero] has an ability\nas special as the Dimensional Scream...", french="Alors comme ça, [hero]\ndétient un pouvoir aussi stupéfiant que\nle Cri Dimensionnel...", german="[hero] hat also mit\ndiesem Dimensionalen Schrei eine unglaublich\nspezielle Fähigkeit...", italian="E così, [hero] ha il dono\ndello Squarcio Dimensionale...", spanish="Así que [hero] tiene una\nhabilidad tan especial como la Percepción\nde Cronos."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  else
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Well, perhaps this is why we\nbecame friends.", french="Ma foi, c'est peut-être pour\ncela que nous nous sommes liés d'amitié.", german="Nun ja, vielleicht sind wir\naus diesem Grund Freunde geworden.", italian="Beh... Forse è questo il motivo\nper cui ci siamo incontrati.", spanish="Bueno, quizás por eso somos\namigos."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="To help unravel the secret of\n[hero]'s transformation into a Pokémon!", french="Afin de percer le mystère\nde la métamorphose de [hero]\nen Pokémon!", german="Um das Geheimnis um die\nVerwandlung von [hero] in ein Pokémon\nzu lüften!", italian="Per svelare il mistero della\ntrasformazione di [hero] in Pokémon!", spanish="¡Para poder descubrir el secreto\nde la transformación en Pokémon de\n[hero]!"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" I offer you my full cooperation!", french="Permettez-moi de vous offrir\nmon entière collaboration!", german="Ich biete euch meine volle\nZusammenarbeit an!", italian="Vi offro la mia completa\ncollaborazione!", spanish=" Os ayudaré todo lo que pueda."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh! You will?!", french=" Oh! Vous feriez ça?!", german=" Oh! wirklich?!?", italian=" Oh! Davvero?", spanish=" ¡¿De verdad?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh! You will?!", french=" Oh! Vous feriez ça?!", german=" Oh! wirklich?!?", italian=" Oh! Dice sul serio?", spanish=" ¡¿De verdad?!"})
  else
  SkySceneKit.say({english=" Oh! You will?!", french=" Oh! Vous feriez ça?!", german=" Oh! wirklich?!?", italian=" Oh! Dice sul serio?", spanish=" ¡¿De verdad?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Yes. To be perfectly candid...", french="Certes. Pour être tout à fait\nfranc...", german=" Ja. Um offen zu sein...", italian="Certamente. Devo essere sincero\ncon voi...", spanish=" Sí. Para serte muy sincero..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I can't stand knowing that\nthere's something I don't know!", french="Je ne tolère point de savoir\nque quelque chose m'échappe!", german="Ich kann es nicht ertragen, wenn\nich etwas nicht weiß!", italian="Non sopporto quando scopro\ndi non sapere qualcosa!", spanish="¡No soporto saber que hay algo\nque desconozco!"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Quite honestly, that is the full\ntruth of it!", french="Voilà la pure vérité, je le\nconfesse...", german="Ernsthaft, das ist die reine\nWahrheit!", italian=" Ecco, l'ho detto.", spanish=" Esa es la verdad."})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Ha-ha-ha! Hoo-hoo-ha!", french=" Ha ha ha! Ho ho ha!", german=" Baaahahahaha!", italian=" Uh-ah-ah-ah!", spanish=" ¡Ja, ja, ja, ja, ja!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's great to know that we\nhave your help, [CS:N]Dusknoir[CR], sir!", french="C'est si rassurant de savoir que\nvous allez nous aider, messire [CS:N]Noctunoir[CR]!", german="Es ist toll zu wissen, dass wir\nauf deine Hilfe zählen können, [CS:N]Zwirrfinst[CR]!", italian="Wow! È davvero fantastico\nsapere che possiamo contare su di lei, signor\n[CS:N]Dusknoir[CR]!", spanish="¡Es estupendo saber que\ncontamos con tu ayuda, [CS:N]Dusknoir[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's thrilling to know that we\nhave your help, [CS:N]Dusknoir[CR], sir!", french="C'est si rassurant de savoir que\nvous allez nous aider, messire [CS:N]Noctunoir[CR]!", german="Es ist großartig, dass wir auf\ndeine Hilfe zählen können, [CS:N]Zwirrfinst[CR]!", italian="Sapere che possiamo contare su\ndi lei, signor [CS:N]Dusknoir[CR], ci è di grande conforto!", spanish="¡Es estupendo saber que\ncontamos con tu ayuda, [CS:N]Dusknoir[CR]!"})
  else
  SkySceneKit.say({english="It's reassuring to know that we\nhave your help, [CS:N]Dusknoir[CR], sir!", french="C'est si rassurant de savoir que\nvous allez nous aider, messire [CS:N]Noctunoir[CR]!", german="Es ist beruhigend, dass wir\nauf deine Hilfe zählen können, [CS:N]Zwirrfinst[CR]!", italian="Sapere che possiamo contare su\ndi lei, signor [CS:N]Dusknoir[CR], ci è di grande conforto!", spanish="¡Es estupendo saber que\ncontamos con tu ayuda, [CS:N]Dusknoir[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Isn't this awesome,\n[hero]?", french="C'est pas formidable,\n[hero]?", german="Ist das nicht super,\n[hero]?", italian=" Non è fantastico, [hero]?", spanish=" ¿No es increíble, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Isn't this great, [hero]?", french="C'est pas formidable,\n[hero]?", german=" Ist das nicht toll, [hero]?", italian=" Non è fantastico, [hero]?", spanish="¿No te parece genial,\n[hero]?"})
  else
  SkySceneKit.say({english=" Isn't this great, [hero]?", french="C'est pas formidable,\n[hero]?", german=" Ist das nicht toll, [hero]?", italian=" Non è fantastico, [hero]?", spanish="¿No te parece genial,\n[hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: SetEffect EFFECT_LAPRAS_WATER_SHADOW — VFX sans émote PMDO équivalente
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-400), g.ViewCenter.Y+(0), 67, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(30)
  -- GAP: SetEffect EFFECT_LAPRAS_WATER_SHADOW — VFX sans émote PMDO équivalente
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-400), g.ViewCenter.Y+(0), 67, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(73) [anim idle native]
  -- SetAnimation(73) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? Look at all the [CS:N]Pelipper[CR]!", french=" Hein? Regarde tous ces [CS:N]Bekipan[CR]!", german="Hey! Sieh dir die vielen [CS:N]Pelipper[CR]\nan!", italian="Uh? Oh! Guardate quanti\n[CS:N]Pelipper[CR]!", spanish="¿Eh? ¡Mirad a todos esos\n[CS:N]Pelipper[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! Look at all the [CS:N]Pelipper[CR]!", french=" Hein? Regarde tous ces [CS:N]Bekipan[CR]!", german="Hey! Sieh dir die vielen [CS:N]Pelipper[CR]\nan!", italian="Uh? Oh! Guardate quanti\n[CS:N]Pelipper[CR]!", spanish="¿Eh? ¡Mirad a todos esos\n[CS:N]Pelipper[CR]!"})
  else
  SkySceneKit.say({english=" Hey! Look at all the [CS:N]Pelipper[CR]!", french=" Hein? Regarde tous ces [CS:N]Bekipan[CR]!", german="Hey! Sieh dir die vielen [CS:N]Pelipper[CR]\nan!", italian="Uh? Oh! Guardate quanti\n[CS:N]Pelipper[CR]!", spanish="¿Eh? ¡Mirad a todos esos\n[CS:N]Pelipper[CR]!"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
