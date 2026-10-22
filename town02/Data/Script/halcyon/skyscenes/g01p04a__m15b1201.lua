-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m15b1201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.DownLeft, "NPC_PERAPPU")
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.UpRight)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 424, 216, Direction.Down, "NPC_PUKURIN")
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownRight)
  local npc_npc_agunomu = SkySceneKit.spawn_npc("azelf", 392, 216, Direction.Down, "NPC_AGUNOMU")
  GROUND:EntTurn(npc_npc_agunomu, Direction.Right)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 376, 232, Direction.DownRight, "NPC_DAGUTORIO")
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Right)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 464, 272, Direction.UpLeft, "NPC_KIMAWARI")
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 472, 248, Direction.Left, "NPC_GUREGGURU")
  GROUND:EntTurn(npc_npc_guregguru, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" What?![K] What did you say?!", french=" Quoi?![K] Tu peux répéter?!", german=" Was?!?[K] Was hast du gesagt?!?", italian=" Cosa?![K] Davvero?!", spanish=" ¡¿Cómo?![K] ¡¿Qué has dicho?!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You're saying that the great\n[CS:N]Dusknoir[CR] and [CS:N]Grovyle[CR]...", french=" Le grand [CS:N]Noctunoir[CR] et [CS:N]Massko[CR]...", german="Du sagst, dass der große\n[CS:N]Zwirrfinst[CR] und [CS:N]Reptain[CR]...", italian=" Il grande [CS:N]Dusknoir[CR] e [CS:N]Grovyle[CR]...", spanish=" Dices que [CS:N]Dusknoir[CR] y [CS:N]Grovyle[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="They may have known each other\nfrom before all this?!", french="... ils se connaissaient déjà\navant toute cette histoire?!", german="Du sagst, sie haben sich\nvielleicht schon vor all dem gekannt?!?", italian=" Quei due si conoscevano già?!", spanish=" ¡¿Ya se conocían?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yep. It sounded that way when\nthey were getting ready to fight!", french=" Oui. Ça en avait tout l'air!", german="Ja. Es hörte sich so an, als sie\nkurz vor dem Kampf miteinander sprachen!", italian="Sì, sembrava proprio così dal\nmodo in cui si sono parlati...", spanish="Sí. Al menos eso parecía por lo\nque se dijeron antes de luchar."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yes! It sounded that way when\nthey were getting ready to fight!", french=" Oui. Ça en avait tout l'air!", german="Ja. Es hörte sich so an, als sie\nkurz vor dem Kampf miteinander sprachen!", italian="Sì, sembrava proprio così dal\nmodo in cui si sono parlati...", spanish="Sí. Al menos eso parecía por lo\nque se dijeron antes de luchar."})
  else
  SkySceneKit.say({english="Yes! It sounded that way when\nthey were getting ready to fight!", french=" Oui. Ça en avait tout l'air!", german="Ja. Es hörte sich so an, als sie\nkurz vor dem Kampf miteinander sprachen!", italian="Sì, sembrava proprio così dal\nmodo in cui si sono parlati...", spanish="Sí. Al menos eso parecía por lo\nque se dijeron antes de luchar."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_dagutorio, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Well, then...", french=" Mais alors...", german=" Also, und was...", italian=" Mmm, a proposito...", spanish=" Pero entonces..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_agunomu, Direction.Down)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 392, 272, Direction.UpRight, "NPC_HEIGANI")
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 448, 272, Direction.Up, "NPC_BIPPA")
  GROUND:EntTurn(npc_npc_bippa, Direction.UpLeft)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 416, 280, Direction.Up, "NPC_CHIRIIN")
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" What became of [CS:N]Dusknoir[CR]?", french=" ... qu'est-il advenu de [CS:N]Noctunoir[CR]?", german="Und was ist dann aus [CS:N]Zwirrfinst[CR]\ngeworden?", italian=" Cosa ne è stato di [CS:N]Dusknoir[CR]?", spanish=" ¿Dónde está [CS:N]Dusknoir[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Well, [CS:N]Grovyle[CR] escaped...", french=" Eh bien, [CS:N]Massko[CR] s'est enfui...", german=" Tja, [CS:N]Reptain[CR] ist entkommen...", italian=" Beh, [CS:N]Grovyle[CR] se l'è svignata...", spanish=" Me parece que [CS:N]Grovyle[CR] escapó..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Well, [CS:N]Grovyle[CR] escaped...", french=" Eh bien, [CS:N]Massko[CR] s'est enfui...", german=" Tja, [CS:N]Reptain[CR] ist entkommen...", italian=" Beh, [CS:N]Grovyle[CR] è scappato...", spanish=" Me parece que [CS:N]Grovyle[CR] escapó..."})
  else
  SkySceneKit.say({english=" Well, [CS:N]Grovyle[CR] escaped...", french=" Eh bien, [CS:N]Massko[CR] s'est enfui...", german=" Tja, [CS:N]Reptain[CR] ist entkommen...", italian=" Beh, [CS:N]Grovyle[CR] è scappato...", spanish=" Me parece que [CS:N]Grovyle[CR] escapó..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So, I think he took off after\nthe thief.", french="... et je crois bien qu'il s'est\nlancé aux trousses de ce voleur.", german="Also glaube ich, dass er dem\nDieb gefolgt ist.", italian="Penso che sia partito al suo\ninseguimento.", spanish=" Y creo que se fue tras él."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I think he went off in pursuit.", french="... et je crois bien qu'il s'est\nlancé aux trousses de ce voleur.", german="Ich glaube, er hat die Verfolgung\naufgenommen.", italian="Immagino che sia partito al\nsuo inseguimento.", spanish=" Y creo que se fue tras él."})
  else
  SkySceneKit.say({english=" I think he went after the thief.", french="... et je crois bien qu'il s'est\nlancé aux trousses de ce voleur.", german="Ich glaube, er ist dem Dieb\ngefolgt.", italian="Immagino che sia partito al\nsuo inseguimento.", spanish=" Y creo que se fue tras él."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7182) — id SE NDS sans portage PMDO identifié
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 368, 264, Direction.UpRight, "NPC_DOGOOMU")
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_agunomu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dagutorio, Direction.DownLeft)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" What?! The EMERGENCY siren!", french=" Quoi?! La sirène d'ALARME!", german=" Was?!? Der NOTALARM?!?", italian=" Che succede?! Ehi! È l'allarme!", spanish="¡¿Cómo?! ¡Es la sirena de\nemergencia!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownLeft)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.Left)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Left)
  GROUND:EntTurn(npc_npc_agunomu, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_heigani, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownLeft)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Hey, [CS:N]Diglett[CR]![K] What's the matter?", french="Eh, [CS:N]Taupiqueur[CR]![K] C'est quoi\nle problème?", german=" Hey, [CS:N]Digda[CR]![K] Was ist los?", italian=" Ehi, [CS:N]Diglett[CR]![K] Cosa succede?", spanish=" ¡Eh, [CS:N]Diglett[CR]![K] ¿Qué ocurre?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GAME:MoveCamera(240, 252, 60, false) end) -- performer/caméra
  pcall(function() GAME:MoveCamera(240, 308, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(15)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 216, 296, Direction.UpLeft, "NPC_DIGUDA")
  GROUND:EntTurn(npc_npc_diguda, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" It's an alert from [CS:N]Magnemite[CR].", french="C'est [CS:N]Magnéti[CR] qui a lancé\nl'alerte.", german=" [CS:N]Magnetilo[CR] hat Alarm geschlagen.", italian=" [CS:N]Magnemite[CR] ha dato l'allarme.", spanish=" [CS:N]Magnemite[CR] ha dado la alerta."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="I'm told it's an emergency call\nsent out by Officer [CS:N]Magnezone[CR]!", french="Il paraît que le shérif\n[CS:N]Magnézone[CR] a émis un appel d'urgence!", german="Oberwachtmeister [CS:N]Magnezone[CR]\nruft den Notfall aus!", italian="Mi è stato detto che è un ordine\ndel Commissario [CS:N]Magnezone[CR]!", spanish="Parece que hay un aviso de\nemergencia del agente [CS:N]Magnezone[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(npc_npc_diguda, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Deputy [CS:N]Magnemite[CR]![K] Please shout\nyour message down to the sentry post!", french="Adjoint [CS:N]Magnéti[CR]![K] Hurlez\nvotre message par le poste de garde!", german="Wachtmeister [CS:N]Magnetilo[CR]![K]\nRuf mir zu, worum es geht!", italian="Agente [CS:N]Magnemite[CR]![K] Per favore,\nci riferisca il suo messaggio.", spanish="Ayudante [CS:N]Magnemite[CR]...[K] dinos\ntu mensaje por la rejilla de vigilancia."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Please speak clearly!", french=" Veillez à bien articuler!", german=" Sprich deutlich, bitte!", italian="La prego di parlare con\nchiarezza!", spanish=" Habla claro, por favor."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  local npc_npc_koiru = SkySceneKit.spawn_npc("magnemite", 400, 200, Direction.Down, "NPC_KOIRU")
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end) -- message_SetActor(ACTOR_NPC_KOIRU)
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english=" Zzzt! Can you hear me? Zzzt!", french=" Zzzt! Vous me recevez? Zzzt!", german=" Zzzt! Hört ihr mich? Zzzt!", italian=" Zzzt! Mi sentite? Zzzt!", spanish=" ¡Bzz! ¿Me oís? ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english="Zzzt! This is about an important\nannouncement from Officer [CS:N]Magnezone[CR]! Zzzt!", french="Zzzt! Annonce de première\nimportance du shérif [CS:N]Magnézone[CR]! Zzzt!", german="Zzzt! Dies ist eine wichtige\nNachricht von Oberwachtmeister [CS:N]Magnezone[CR]!\nZzzt!", italian="Zzzt! Questo è un annuncio\nimportante da parte del Commissario\n[CS:N]Magnezone[CR]! Zzzt!", spanish="¡Bzz! ¡Este es un aviso\nimportante del agente [CS:N]Magnezone[CR]! ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(240, 252, 60, false) end) -- performer/caméra
  pcall(function() GAME:MoveCamera(420, 252, 60, false) end) -- performer/caméra
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english="Zzzt! Everyone, please gather\nat the main square in Treasure Town! Zzzt!", french="Zzzt! Rassemblement général\nsur la grand-place de Bourg-Trésor! Zzzt!", german="Zzzt! Alle Pokémon sollen sich\nam Hauptplatz von Schatzstadt versammeln!\nZzzt!", italian="Zzzt! Siete pregati di riunirvi\ntutti nella piazza principale di Borgo Tesoro!\nZzzt!", spanish="¡Bzz! ¡Venid todos a la plaza\nde Aldea Tesoro! ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english="Zzzt! He will have a major\nannouncement to make to everyone! Zzzt!", french="Zzzt! Il a une annonce capitale\nà faire devant tout le monde! Zzzt!", german="Zzzt! Er hat eine wichtige\nNachricht an alle! Zzzt!", italian="Zzzt! Il Commissario ha un\nannuncio importante per tutti voi! Zzzt!", spanish="¡Bzz! ¡Tiene un importantísimo\ncomunicado que todos tenéis que oír! ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english="Zzzt! All Pokémon in the area\nhave been called for this town meeting, not\njust those in the guild! Zzzt!", french="Zzzt! Tous les Pokémon\nde la région ont été convoqués, pas seulement\nceux de la Guilde! Zzzt!", german="Zzzt! Alle Pokémon in der\nGegend werden zu diesem Treffen gerufen!\nNicht nur die Gilde! Zzzt!", italian="Zzzt! Tutti i Pokémon della zona\nsono chiamati a partecipare! Non solamente i\nmembri della Gilda! Zzzt!", spanish="¡Bzz! ¡Todos los Pokémon de la\nzona están convocados a esta reunión!\n¡No solamente los del [CS:N]Pokégremio[CR]! ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english="Zzzt! That is all! We hope for\nyour cooperation! Thank you. Zzzt!", french="Zzzt! C'est tout! Nous comptons\nsur votre coopération! Merci de votre\nattention. Zzzt!", german="Zzzt! Das ist alles! Wir hoffen,\ndass ihr erscheint! Vielen Dank. Zzzt!", italian="Zzzt! È tutto! Grazie per la\nvostra cooperazione! Zzzt!", spanish="¡Bzz! ¡Eso es todo!\n¡Esperamos vuestra colaboración!\nGracias. ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpRight)
  GROUND:EntTurn(npc_npc_heigani, Direction.Right)
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_agunomu, Direction.DownRight)
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Down)
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I wonder what's going on?", french=" De quoi peut-il s'agir?", german=" Was da wohl los ist?", italian=" Chissà di che si tratta...", spanish=" Me pregunto qué ocurrirá..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What's happening now?", french=" De quoi peut-il s'agir?", german=" Was da wohl vor sich geht?", italian=" Chissà di che si tratta...", spanish=" ¿Y ahora qué pasa?"})
  else
  SkySceneKit.say({english=" I wonder what this is about?", french=" De quoi peut-il s'agir?", german=" Um was es wohl geht?", italian=" Chissà di che si tratta...", spanish=" ¿Qué estará ocurriendo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="An important announcement?\nWhat might it be?", french="Une annonce capitale?\nQu'est-ce que ça peut bien être?", german="Eine wichtige Nachricht?\nWas kann das sein?", italian="Shock! Un annuncio importante?\nCosa sarà mai?", spanish="¿Un comunicado muy importante?\n¿Qué podrá ser?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(npc_npc_heigani, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.Down)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GROUND:EntTurn(npc_npc_bippa, Direction.Left)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Left)
  GROUND:EntTurn(npc_npc_agunomu, Direction.Down)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.DownRight)
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownLeft)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! No point in wondering.\nLet's go get the answer!", french="Eh dis donc, pas la peine\nde se creuser les méninges. Allons-y,\non verra bien!", german="Hey, hey! Spekulieren bringt\nnichts. Gehen wir einfach hin!", italian="Ehi, ehi! È inutile tirare a\nindovinare! Andiamo e lo scopriremo!", spanish="¡Oye, oye! No sirve de nada\nimaginarse cosas. ¡Vamos a ver lo que pasa!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! Let's get a move on\nto Treasure Town's main square!", french="Saperlipopince, rendons-nous\nvite sur la grand-place de Bourg-Trésor!", german="Hey, hey! Machen wir uns auf\ndie Socken zum Hauptplatz von Schatzstadt!", italian=" Tutti in piazza! Ehi, ehi!", spanish="¡Oye, oye! ¡Vamos cuanto antes\na la plaza de Aldea Tesoro!"})
  -- message_Close
  GAME:FadeOut(false, 60)
  SkyProg.set(17, 0) -- $SCENARIO_MAIN = scn[17,0] (ROM)
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
