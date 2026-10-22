-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/m03a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  SkyProg.set(4, 2) -- $SCENARIO_MAIN = scn[4,2] (ROM)
  local npc_npc_kakureon1 = SkySceneKit.spawn_npc("kecleon", 328, 168, Direction.Down, "NPC_KAKUREON1")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_kakureon2 = SkySceneKit.spawn_npc("kecleon", 352, 168, Direction.Down, "NPC_KAKUREON2")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_mariru = SkySceneKit.spawn_npc("marill", 512, 200, Direction.Left, "NPC_MARIRU")
  GROUND:MoveToPosition(npc_npc_mariru, 348, 196, false, 2)
  local npc_npc_ruriri = SkySceneKit.spawn_npc("azurill", 536, 216, Direction.Left, "NPC_RURIRI")
  GROUND:MoveToPosition(npc_npc_ruriri, 356, 212, false, 2)
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end) -- message_SetActor(ACTOR_NPC_MARIRU)
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Misters [CS:N]Kecleon[CR]!", french=" Bonjour, Messieurs [CS:N]Kecleon[CR]!", german=" Hallo, die Herren [CS:N]Kecleon[CR]!", italian=" Signori [CS:N]Kecleon[CR]!", spanish=" ¡Señores [CS:N]Kecleon[CR]!"})
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_kakureon1, Direction.DownRight)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_kakureon2, Direction.Right)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(90)
  -- message_CloseEnforce
  -- SetPositionLives(0) [cible objet/id de décor NDS non simulée - trace]
  -- camera_SetMyself() [neutre/état moteur]
  -- Move2PositionMark 0 [cible sans placement SSA zone: mouvement non joué]
  GROUND:MoveToPosition(hero, 312, 196, false, 2)
  GROUND:MoveToPosition(partner, 312, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(npc_npc_kakureon2, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_mariru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_ruriri, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Heartwarming.ogg", true) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon1, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon2, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="Ah! Little [CS:N]Marill[CR] and [CS:N]Azurill[CR]![K]\nWelcome, my young friends! ♪", french="Ah! Les petits [CS:N]Marill[CR] et [CS:N]Azurill[CR]![K]\nBienvenue, mes jeunes amis! ♪", german="Ah! Der kleine [CS:N]Marill[CR] und der\nkleine [CS:N]Azurill[CR]![K] Willkommen, meine kleinen\nFreunde! ♪", italian="Ah! I piccoli [CS:N]Marill[CR] e [CS:N]Azurill[CR]![K]\nBenvenuti, miei piccoli amici! ♪", spanish="¡Ah! ¡Los pequeños [CS:N]Marill[CR] y\n[CS:N]Azurill[CR]![K] ¡Bienvenidos, jovenzuelos! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon1, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon2, nil, 0) end) -- EFFECT_NONE
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Hello. May I buy an [CS:I]Apple[CR]?", french="Bonjour. Puis-je acheter une\n[CS:I]Pomme[CR]?", german="Hallo. Könnte ich bitte einen\n[CS:I]Apfel[CR] kaufen?", italian="Buongiorno. Vorrei comprare\nuna [CS:I]Mela[CR].", spanish="Hola. ¿Puedo comprar\nuna [CS:I]Manzanita[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" Oh, most certainly!", french=" Oh, mais bien sûr!", german=" Oh, aber natürlich!", italian=" Oh, sicuro!", spanish=" ¡Claro que sí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="[CN][CS:N]Marill[CR] and [CS:N]Azurill[CR] bought\n[CN]an [CS:I]Apple[CR] at [CS:K]Kecleon[CR] Market.", french="[CN][CS:N]Marill[CR] et [CS:N]Azurill[CR] achètent\n[CN]une [CS:I]Pomme[CR] au [CS:K]Marché Kecleon[CR].", german="[CN][CS:N]Marill[CR] und [CS:N]Azurill[CR] kaufen\n[CN]einen [CS:I]Apfel[CR] im [CS:K]Kecleon-Markt[CR].", italian="[CN][CS:N]Marill[CR] e [CS:N]Azurill[CR] comprano\n[CN]una [CS:I]Mela[CR] al [CS:K]Kecleon[CR] Market.", spanish="[CN][CS:N]Marill[CR] y [CS:N]Azurill[CR] compraron\n[CN]una [CS:I]Manzanita[CR] en el [CS:K]Bazar Kecleon[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_mariru, "happy", 1) end)
  -- message_FacePositionOffset(-3, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Thank you, Misters [CS:N]Kecleon[CR]!", french=" Merci, Messieurs [CS:N]Kecleon[CR]!", german=" Vielen Dank, die Herren [CS:N]Kecleon[CR]!", italian=" Grazie, signori [CS:N]Kecleon[CR]!", spanish=" ¡Gracias, señores [CS:N]Kecleon[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_mariru, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="No, thank you, my young friends!\nYou are to be admired! ♪", french="Non, merci à vous, mes jeunes\namis! Vous êtes si admirables! ♪", german="Nein, wir haben uns zu bedanken,\nmeine kleinen Freunde! Ihr seid zu\nliebenswert! ♪", italian="No, grazie a voi, miei giovani\namici! Siete eccezionali! ♪", spanish="Gracias a vosotros, jovenzuelos.\nSois encantadores. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kakureon1, Direction.Right)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_kakureon2, Direction.Right)
  GROUND:MoveToPosition(npc_npc_mariru, 528, 196, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(npc_npc_ruriri, 528, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_kakureon1, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_kakureon2, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.Up)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="You see, those delightful\nchildren are brothers.", french="Vous voyez, ces charmants\nenfants sont frères.", german="Wisst ihr, diese entzückenden\nKinder sind Brüder.", italian="Sapete, quei simpatici cuccioli\nsono fratelli.", spanish="Ustedes verán, estos chicos tan\nmajos son hermanos."})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="Lately, their poor mother has\nfallen sick. So those youngsters come and\ndo the shopping for her.", french="Leur pauvre mère est tombée\nmalade il y a peu. Alors ces jeunes garçons\nviennent faire les courses pour elle.", german="Seit Kurzem ist ihre arme\nMutter krank. Also kommen die beiden Kleinen\nund kaufen für sie ein.", italian="Poco tempo fa, la loro povera\nmadre si è ammalata. Quindi quei giovanotti\nvengono a fare la spesa per lei.", spanish="Su pobre madre está enferma.\nPor eso, estos jovencitos vienen a hacer\nla compra por ella."})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="It's quite remarkable. Though\nvery young, they've stepped up and\ntaken charge. ♪", french="C'est remarquable. Malgré leur\njeune âge, ils prennent des responsabilités\npour aider leur mère. ♪", german="Es ist wirklich bemerkenswert.\nObwohl sie so jung sind, übernehmen sie schon\nVerantwortung. ♪", italian="È davvero ammirevole. Anche se\nsono molto giovani, si sono rimboccati le\nmaniche e si danno un gran da fare. ♪", spanish="Es admirable. Incluso siendo\ntan jóvenes, son muy responsables. ♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mariru, 348, 196, false, 2)
  GAME:WaitFrames(20)
  -- SetAnimation(1024) [anim idle native]
  GROUND:MoveToPosition(npc_npc_ruriri, 356, 212, false, 2)
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon1, "exclaim", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end) -- message_SetActor(ACTOR_NPC_MARIRU)
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Misters [CS:N]Kecleon[CR]!", french=" Messieurs [CS:N]Kecleon[CR]!", german=" Die Herren [CS:N]Kecleon[CR]!", italian=" Signori [CS:N]Kecleon[CR]!", spanish=" ¡Señores [CS:N]Kecleon[CR]!"})
  GROUND:EntTurn(npc_npc_kakureon1, Direction.DownRight)
  GROUND:EntTurn(npc_npc_kakureon2, Direction.DownRight)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_kakureon2, Direction.Down)
  GROUND:EntTurn(npc_npc_mariru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_ruriri, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon1, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="Oh? What's the hurry? What\nmakes you return in such a rush?", french="Oh? Quel empressement!\nQu'est-ce qui vous fait revenir si vite?", german="Oh? Wieso die Eile? Warum\nkommt ihr so schnell zurückgelaufen?", italian="Oh? Come mai tanta fretta?\nChe è successo?", spanish="¿Por qué esas prisas?\n¿Qué os hace volver tan apurados?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" There was an extra [CS:I]Apple[CR]!", french=" Il y a une [CS:I]Pomme[CR] en trop!", german=" Es ist ein [CS:I]Apfel[CR] zu viel!", italian=" C'era una [CS:I]Mela[CR] in più!", spanish=" ¡Había una [CS:I]Manzanita[CR] de más!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-3, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" We didn't pay for this many.", french=" Nous ne l'avons pas payée.", german=" Für den haben wir nicht bezahlt.", italian=" Non l'abbiamo pagata.", spanish=" No habíamos pagado por esta."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="Oh, yes... That, young friends,\nis a gift from me and my brother.", french="Ah, oui... Voyez-vous, mes\njeunes amis, c'est un cadeau de la part\nde mon frère et moi-même.", german="Oh ja. Das, meine kleinen\nFreunde, ist ein Geschenk von mir und meinem\nBruder.", italian="Oh, sì... Quello, miei giovani\namici, è un regalo da parte mia e di mio\nfratello.", spanish="Ah, sí... Es un regalo\nde nuestra parte."})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="Please, share it among\nyourselves and do enjoy.", french=" Partagez-la et régalez-vous.", german="Bitte teilt ihn euch und lasst ihn\neuch schmecken.", italian=" Potete dividervela e gustarvela.", spanish="Por favor, compartidla\nentre vosotros y disfrutadla."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_mariru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  -- message_FacePositionOffset(-3, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Really?!", french=" Vraiment?!", german=" Wirklich?!?", italian=" Davvero?!", spanish=" ¡¿En serio?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english="Yay! Thank you, Mr. [CS:N]Kecleon[CR]\nand Mr. [CS:N]Kecleon[CR]!", french="Youpi! Merci, M. [CS:N]Kecleon[CR]\net M. [CS:N]Kecleon[CR]!", german="Jippie! Danke, Herr [CS:N]Kecleon[CR]\nund Herr [CS:N]Kecleon[CR]!", italian="Wow! Grazie, signor [CS:N]Kecleon[CR]\ne signor [CS:N]Kecleon[CR]!", spanish="¡Chachi!\n¡Gracias, señores [CS:N]Kecleon[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english="Oh, not to worry, my friends.\nDo take care on your way home. ♪", french="Oh, pas de quoi, mes amis.\nFaites attention en rentrant. ♪", german="Oh, keine Ursache, meine\nFreunde. Kommt gut nach Hause. ♪", italian="Oh, non c'è di che, amici miei.\nState attenti tornando a casa. ♪", spanish="Ah, no os preocupéis, muchachos.\nTened cuidado al volver a casa. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kakureon2, Direction.DownRight)
  GROUND:MoveToPosition(npc_npc_mariru, 488, 196, false, 2)
  GROUND:EntTurn(npc_npc_ruriri, Direction.Right)
  GAME:WaitFrames(30)
  -- SetAnimation(768) [anim idle native]
  GROUND:MoveToPosition(npc_npc_ruriri, 416, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- GAP: se_Play(6412) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon1, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kakureon2, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- message_FacePositionOffset(2, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Yowch!", french=" Ouille!", german=" Autsch!", italian=" Ups!", spanish=" ¡Ay!"})
  -- GAP: se_Play(6413) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(2) [neutre/état moteur]
  -- SlidePositionMark OBJECT_P03P02A1_128 [cible sans placement SSA zone: glissement non joué]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(npc_npc_kakureon1, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_kakureon2, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P03P02A1_128) [routine d'objet NDS non simulée - documenté]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(20), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  -- SetAnimation(2) [anim idle native]
  do local p=npc_npc_ruriri.Position; GROUND:MoveToPosition(npc_npc_ruriri, p.X+(-8), p.Y+(-16), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_ruriri, 360, 196, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english="W-we're sorry to bother you.\nThank you so much.", french="M-merci beaucoup... Pardon\npour le dérangement.", german="T-tut uns leid, dass wir gestört\nhaben. Vielen Dank.", italian="S-Scusi per il disturbo. Grazie\ntante.", spanish="Sentimos haberte molestado.\nMuchas gracias."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 344, 196, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english="[CN][hero] gave the [CS:I]Apple[CR]\n[CN]back to [CS:N]Azurill[CR].", french="[CN][hero] rend la [CS:I]Pomme[CR]\n[CN]à [CS:N]Azurill[CR].", german="[CN][hero] gibt [CS:N]Azurill[CR]\n[CN]den [CS:I]Apfel[CR] zurück.", italian="[CN][hero] restituisce la [CS:I]Mela[CR]\n[CN]ad [CS:N]Azurill[CR].", spanish="[CN][hero] devolvió\n[CN]la [CS:I]Manzanita[CR] a [CS:N]Azurill[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english="[CN]But then suddenly...", french="[CN]C'est à cet instant précis que...", german="[CN]Doch auf einmal...", italian="[CN]Ma poi, improvvisamente...", spanish="[CN]Pero de pronto..."})
  -- message_Close
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Huh? What was that?)", french="(Quoi? Qu'est-ce que c'était?)", german="(Äh? Was war das?)", italian="(Eh? Cosa è stato?)", spanish="(¿Eh? ¿Qué ha sido eso?)"})
  else
  SkySceneKit.say({english="(Huh? What was that?)", french="(Quoi? Qu'est-ce que c'était?)", german="(Äh? Was war das?)", italian="(Eh? Cosa è stato?)", spanish="(¿Eh? ¿Qué ha sido eso?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(D-dizzy? Or am I...?)", french="(J'ai des vertiges? Ou alors...?)", german="(Sch-schwindelig? Wirklich?)", italian="(U-Un capogiro? O sono...?)", spanish="(¿Es un mareo? ¿O qué me está...?)"})
  else
  SkySceneKit.say({english="(D-dizzy? Or am I...?)", french="(J'ai des vertiges? Ou alors...?)", german="(Sch-schwindelig? Wirklich?)", italian="(U-Un capogiro? O sono...?)", spanish="(¿Es un mareo? ¿O qué me está...?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:FadeOut(false,  5)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
