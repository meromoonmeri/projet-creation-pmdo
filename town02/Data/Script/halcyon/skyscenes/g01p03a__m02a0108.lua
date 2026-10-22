-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m02a0108.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 3 for actor ACTOR_NPC_KIMAWARI
    local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 464, 216, Direction.Up, "NPC_KIMAWARI")
    -- SetAnimation(2) [anim idle native]
    GAME:WaitFrames(30)
    -- @label_2 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    GROUND:EntTurn(npc_npc_kimawari, Direction.Left)
    pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
    GAME:WaitFrames(math.random(90, 180))
    pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
    GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
    GAME:WaitFrames(math.random(120, 180))
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_poppo = SkySceneKit.spawn_npc("pidgey", 392, 296, Direction.Right, "NPC_POPPO")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 432, 216, Direction.Up, "NPC_BIPPA")
  -- SetAnimation(4) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wow!", french=" Waouh!", german=" Wow!", italian=" Wow!", spanish=" ¡Vaya!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wow!", french=" Waouh!", german=" Wow!", italian=" Wow!", spanish=" ¡Vaya!"})
  else
  SkySceneKit.say({english=" Wow!", french=" Waouh!", german=" Wow!", italian=" Wow!", spanish=" ¡Vaya!"})
  end
  -- message_Close
  pcall(function() GAME:MoveCamera(348, 288, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 364, 284, false, 1)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 332, 284, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So this is [CS:N]Wigglytuff[CR]'s Guild!", french="C'est donc ça, la Guilde de\n[CS:N]Grodoudou[CR]!", german="Das ist also die\n[CS:N]Knuddeluff-Gilde[CR]!", italian="Quindi questa è la Gilda di\n[CS:N]Wigglytuff[CR]!", spanish="¡Así que este es el [CS:N]Pokégremio\nde Exploradores[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So this is [CS:N]Wigglytuff[CR]'s Guild!", french="C'est donc ça, la Guilde de\n[CS:N]Grodoudou[CR]!", german="Das ist also die\n[CS:N]Knuddeluff-Gilde[CR]!", italian="Quindi questa è la Gilda di\n[CS:N]Wigglytuff[CR]!", spanish="¡Así que este es el [CS:N]Pokégremio\nde Exploradores[CR]!"})
  else
  SkySceneKit.say({english=" So this is [CS:N]Wigglytuff[CR]'s Guild!", french="C'est donc ça, la Guilde de\n[CS:N]Grodoudou[CR]!", german="Das ist also die\n[CS:N]Knuddeluff-Gilde[CR]!", italian="Quindi questa è la Gilda di\n[CS:N]Wigglytuff[CR]!", spanish="¡Así que este es el [CS:N]Pokégremio\nde Exploradores[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="There sure are a lot of Pokémon\nhere. Are they all exploration teams?", french="Tous ces Pokémon! Je me\ndemande s'ils font tous partie d'une équipe\nd'exploration.", german="Hier gibt es aber viele Pokémon.\nOb alle zu Erkundungsteams gehören?", italian="Ci sono un sacco di Pokémon\nqui. Fanno tutti parte di squadre\nd'esplorazione?", spanish="Desde luego hay muchos\nPokémon aquí. ¿Pertenecen todos a equipos\nde exploración?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So many Pokémon! I wonder if\nthey're all on exploration teams?", french="Tous ces Pokémon! Je me\ndemande s'ils font tous partie d'une équipe\nd'exploration.", german="So viele Pokémon! Ob sie wohl\nalle zu Erkundungsteams gehören?", italian="Ci sono un sacco di Pokémon\nqui. Fanno tutti parte di squadre\nd'esplorazione?", spanish="¡Cuántos Pokémon! Me pregunto\nsi todos pertenecen a equipos de exploración..."})
  else
  SkySceneKit.say({english="There are sure a lot of Pokémon\nhere. Do they all belong to exploration teams?", french="Tous ces Pokémon! Je me\ndemande s'ils font tous partie d'une équipe\nd'exploration.", german="Hier gibt es aber viele Pokémon.\nOb alle zu Erkundungsteams gehören?", italian="Ci sono un sacco di Pokémon\nqui. Fanno tutti parte di squadre\nd'esplorazione?", spanish="Aquí hay un montón de Pokémon.\n¿Pertenecerán todos a equipos de exploración?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Excuse me!", french=" Excusez-moi!", german=" Verzeihung!", italian=" Chiedo scusa!", spanish=" ¡Disculpad!"})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(30)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  pcall(function() GAME:MoveCamera(348, 228, 60, false) end) -- performer/caméra
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 368, 184, Direction.Down, "NPC_PERAPPU")
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(45)
  pcall(function() GAME:MoveCamera(348, 288, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_perappu, 348, 252, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" It was you two that just came in, right?", french="C'est vous deux qui venez d'arriver,\nc'est ça?", german=" Ihr beide seid gerade hereingekommen, ja?", italian="Voi siete i due Pokémon che sono appena\nentrati, giusto?", spanish="Sois los Pokémon que acaban de entrar,\n¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Y-yes!", french=" O-oui!", german=" G-genau!", italian=" S-Sì!", spanish=" Esto... Sí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Y-yes!", french=" O-oui!", german=" G-genau!", italian=" S-Sì!", spanish=" Esto... Sí."})
  else
  SkySceneKit.say({english=" Y-yes!", french=" O-oui!", german=" G-genau!", italian=" S-Sì!", spanish=" Esto... Sí."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I'm [CS:N]Chatot[CR]! ♪[K] I'm the Pokémon in the\nknow around these parts!", french="Je suis [CS:N]Pijako[CR]! ♪[K] C'est moi qui suis\nau courant de tout par ici!", german="Ich heiße [CS:N]Plaudagei[CR]! ♪[K] Ich habe hier das\nSagen!", italian="Io sono [CS:N]Chatot[CR]! ♪[K] Sono il Pokémon che\ntiene d'occhio le cose qui!", spanish="¡Yo soy [CS:N]Chatot[CR]! ♪[K]\n¡El que mantiene todo bajo control!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I am Guildmaster [CS:N]Wigglytuff[CR]'s\nright-hand Pokémon! ♪", french="Je suis le bras droit de\n[CS:N]Grodoudou[CR], le Maître de la Guilde! ♪", german="Ich bin die rechte Hand von\nGildenmeister [CS:N]Knuddeluff[CR]! ♪", italian="Sono il braccio destro del\nCapitano [CS:N]Wigglytuff[CR]! ♪", spanish="¡La mano derecha de [CS:N]Wigglytuff[CR],\nel Gran Bluff! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Now, shoo! Leave the premises!\nWe have no time for salespeople or silly\nsurveys.[K] Off you go, if you please!", french="Allez, ouste! Quittez ces lieux!\nNous n'avons pas de temps pour les colporteurs\nou pour de stupides sondages.[K] Du balai!", german="Und nun, kusch! Verlasst unsere\nGilde! Wir haben keine Zeit für Vertreter und\nalberne Umfragen.[K] Wenn ich bitten darf!", italian="Adesso, sciò! Andatevene!\nNon abbiamo tempo per venditori e\nrappresentanti.[K] Andate via, per favore!", spanish="Ahora, ¡fuera de aquí!\n¡Abandonad el edificio! ¡No tenemos tiempo\npara vendedores o estúpidas encuestas![K] ¡Largo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" N-no! That's not why we're here!", french="N-non! Ce n'est pas pour ça\nque nous sommes ici!", german="N-nein! Das ist nicht der Grund,\nwarum wir hier sind!", italian=" N-No! Non siamo qui per quello!", spanish=" ¡No! ¡No hemos venido a eso!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" N-no! That's not why we're here!", french="N-non! Ce n'est pas pour ça\nque nous sommes ici!", german="N-nein! Das ist nicht der Grund,\nwarum wir hier sind!", italian=" N-No! Non siamo qui per quello!", spanish=" ¡No! ¡No hemos venido a eso!"})
  else
  SkySceneKit.say({english=" N-no! That's not why we're here!", french="N-non! Ce n'est pas pour ça\nque nous sommes ici!", german="N-nein! Das ist nicht der Grund,\nwarum wir hier sind!", italian=" N-No! Non siamo qui per quello!", spanish=" ¡No! ¡No hemos venido para eso!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We want to form an\nexploration team...", french="Nous voulons former une équipe\nd'exploration...", german="Wir wollen ein Erkundungsteam\ngründen...", italian="Vogliamo formare una\nsquadra d'esplorazione...", spanish="Queremos formar un equipo\nexplorador..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We want to form an\nexploration team...", french="Nous voulons former une équipe\nd'exploration...", german="Wir wollen ein Erkundungsteam\ngründen...", italian="Vogliamo formare una\nsquadra d'esplorazione...", spanish="Queremos formar un equipo\nexplorador..."})
  else
  SkySceneKit.say({english="We want to form an\nexploration team...", french="Nous voulons former une équipe\nd'exploration...", german="Wir wollen ein Erkundungsteam\ngründen...", italian="Vogliamo formare una\nsquadra d'esplorazione...", spanish="Queremos formar un equipo\nexplorador..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So we came here. We want to\nget proper training as an exploration team.", french="C'est pour ça que nous sommes\nici. Nous voulons recevoir un entraînement qui\nnous permettra d'en devenir une.", german="Deswegen sind wir hier. Wir\nwollen als Erkundungsteam trainiert werden.", italian="... e così siamo venuti qui.\nVogliamo allenarci per diventare una vera e\npropria squadra d'esplorazione.", spanish="Por eso estamos aquí. Queremos\nser entrenados como exploradores."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's why we came. We want\nto be trained as an exploration team.", french="C'est pour ça que nous sommes\nici. Nous voulons recevoir un entraînement qui\nnous permettra d'en devenir une.", german="Deswegen sind wir hier. Wir\nwollen als Erkundungsteam trainiert werden.", italian="... e così siamo venuti qui.\nVogliamo allenarci per diventare una vera e\npropria squadra d'esplorazione.", spanish="Por eso estamos aquí. Queremos\nser entrenados como exploradores."})
  else
  SkySceneKit.say({english="So we came here. We want to\nget proper training as an exploration team.", french="C'est pour ça que nous sommes\nici. Nous voulons recevoir un entraînement qui\nnous permettra d'en devenir une.", german="Deswegen sind wir hier. Wir\nwollen als Erkundungsteam trainiert werden.", italian="... e così siamo qui.\nVogliamo allenarci per diventare una vera e\npropria squadra d'esplorazione.", spanish="Por eso estamos aquí. Deseamos\nrecibir entrenamiento adecuado como\nexploradores."})
  end
  -- message_Close
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Wh-what?! Exploration team?", french="Q-quoi?! Une équipe\nd'exploration?", german=" W-was?!? Als Erkundungsteam?", italian="C-Cosa?! Una squadra\nd'esplorazione?", spanish=" ¿Qué? ¿Un equipo explorador?"})
  -- message_Close
  SkySceneKit.spin(npc_npc_perappu, 4, 1, 5)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It's rare to see a kid like this\nwant to apprentice at the guild.", french="C'est rare de voir un Pokémon\naussi jeune vouloir rejoindre les apprentis de\nla Guilde.", german="Es kommt selten vor, dass\nJungspunde wie ihr sich bei der Gilde\nbewerben.", italian="È raro vedere un Pokémon\ncosì giovane che vuole diventare un\napprendista alla Gilda.", spanish="Resulta muy raro ver a Pokémon\nde vuestro tipo que quieran ser aprendices\nde nuestro [CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Especially given how hard our\ntraining is!", french="Tout particulièrement quand\non connaît la difficulté de notre entraînement!", german="Kein Wunder, wenn man bedenkt,\nwie hart das Training ist!", italian="Soprattutto se si considera\nquanto è duro il nostro addestramento!", spanish="¡Sobre todo con lo duro que es\nel entrenamiento!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Surely the steady stream of\nPokémon that run away from our rigorous\ntraining proves how true that is!", french="Il suffit de voir les hordes\nde Pokémon qui s'enfuient d'ici à cause\nde notre entraînement très rigoureux!", german="Der nicht enden wollende Strom\nvon Pokémon, die wegen des harten Trainings\ndavonlaufen, ist der beste Beweis!", italian="Il gran numero di Pokémon che\nrinunciano dovrebbe essere una prova\nsufficiente!", spanish="¡La multitud de Pokémon que\nescapa continuamente de nuestro riguroso\nentrenamiento es la prueba fehaciente de ello!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey.", french=" Dites, excusez-moi.", german=" Hey.", italian=" Ehi.", spanish=" Esto..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Excuse me.", french=" Dites, excusez-moi.", german=" Verzeihung, aber...", italian=" Scusami.", spanish=" ¿Ah, sí?"})
  else
  SkySceneKit.say({english=" Excuse me.", french=" Dites, excusez-moi.", german=" Verzeihung, aber...", italian=" Scusami.", spanish=" ¿De verdad?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Is the exploration team training\nreally that strict?", french="L'entraînement des équipes\nd'exploration est vraiment si exigeant\nque ça?", german="Ist das Training für\nErkundungsteams wirklich so streng?", italian="L'addestramento è davvero così\ndifficile?", spanish="¿El entrenamiento de los\nexploradores es realmente tan estricto?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Is the exploration team training\nthat severe?", french="L'entraînement des équipes\nd'exploration est vraiment si exigeant\nque ça?", german="Ist das Training für\nErkundungsteams so anstrengend?", italian="L'addestramento è davvero così\ndifficile?", spanish="¿Tan severo es el entrenamiento\nde los equipos de exploración?"})
  else
  SkySceneKit.say({english="Is the exploration team training\nthat harsh?", french="L'entraînement des équipes\nd'exploration est vraiment si exigeant\nque ça?", german="Ist das Training für\nErkundungsteams so brutal?", italian="L'addestramento è davvero così\ndifficile?", spanish="¿Tan duro es el entrenamiento\nde los equipos de exploración?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(42) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Well...no! No, no, no!", french=" Euh... non! Non, non, non!", german=" Nun ja... Nein! Nein, nein, nein!", italian=" Beh... no! No, no, no!", spanish=" Esto... ¡qué va, qué va!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It's not true in the slightest![K]\nOur training program for exploration teams is\nas easy as can be!", french="Mais rien de tout cela n'est vrai,\nvoyons![K] Ha ha ha! Notre programme\nd'entraînement est on ne peut plus facile!", german="Nicht im Geringsten![K] Unser\nTrainingsprogramm für Erkundungsteams\nkönnte nicht leichter sein!", italian="Non è affatto vero![K]\nIl nostro programma d'addestramento è alla\nportata di tutti!", spanish="¡Para nada! ¡Qué va![K]\n¡Nuestro programa de entrenamiento para\nexploradores es lo más fácil posible!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(44) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Well, well, well! ♪[K] I wish you\nhad told me up front that you wanted to be\nan exploration team! ♪ Hee-heeee! ♪", french="Bien, bien! ♪[K] Vous auriez dû\nme dire dès le début que vous vouliez créer\nune équipe d'exploration! ♪ Hiii hiiiii! ♪", german="Tja, tja! ♪[K] Ich wünschte, ihr\nhättet gleich gesagt, dass ihr ein\nErkundungsteam gründen wollt! ♪ Hihihi! ♪", italian="Bene, bene, bene! ♪[K] Avreste\ndovuto dirmi subito che volevate formare una\nsquadra d'esplorazione! ♪ Eeh-eeeeh! ♪", spanish="¡Bueno, bueno, bueno! ♪[K]\nMe tenías que haber dicho antes que\nqueríais ser exploradores... ♪ ¡Ji, ji, ji! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" His attitude did an about-face...", french="Quel drôle de changement\nd'attitude de sa part, tout à coup...", german="Seine Meinung hat sich\nurplötzlich geändert...", italian="Il suo atteggiamento è\ncambiato...", spanish=" Menudo cambio de actitud..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="His attitude suddenly changed,\ndidn't it...?", french="Quel drôle de changement\nd'attitude de sa part, tout à coup...", german="Er hatte einen sehr plötzlichen\nSinneswandel, nicht wahr?", italian="Hai visto com'è cambiato il suo\natteggiamento?", spanish=" Menudo cambio de actitud..."})
  else
  SkySceneKit.say({english=" What a shift in attitude!", french="Quel drôle de changement\nd'attitude de sa part, tout à coup...", german=" Welch ein Sinneswandel!", italian="Com'è cambiato il suo\natteggiamento!", spanish=" ¡Vaya cambio de actitud!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="OK! Let's get your team signed\nup right away. Follow me! ♪", french="D'accord! Allons inscrire votre\néquipe. Suivez-moi! ♪", german="Okay! Lasst uns euer Team\nsofort einschreiben. Folgt mir! ♪", italian="Ok! Dovete iscrivervi subito.\nSeguitemi! ♪", spanish="¡Muy bien! ¡Hay que registrar\nvuestro equipo ahora mismo! ¡Seguidme! ♪"})
  -- message_Close
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(-40), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Oh, anything wrong? Come on!\nOver here! ♪[K] Quickly, please! ♪", french="Oh, qu'y a-t-il? Venez!\nPar ici! ♪[K] Dépêchons, s'il vous plaît! ♪", german="Oh, stimmt etwas nicht?\nKommt! Hierher! ♪[K] Beeilt euch, bitte! ♪", italian="Oh, c'è qualcosa che non va?\nForza! Da questa parte! ♪[K] Veloci! ♪", spanish="Eh, ¿os pasa algo? ¡Venga!\n¡Venid aquí! ♪[K] ¡Rápido, por favor! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_perappu, 364, 180, false, 2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-88), false, 2) end
  GAME:WaitFrames(25)
  GROUND:MoveToPosition(partner, 364, 180, false, 2)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(20)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
