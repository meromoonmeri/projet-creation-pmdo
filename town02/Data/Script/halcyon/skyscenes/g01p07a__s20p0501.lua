-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07A/s20p0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 72) -- $SCENARIO_MAIN = scn[29,72] (ROM)
  -- back_SetGround(LEVEL_G01P07A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_ruriri = SkySceneKit.spawn_npc("azurill", 208, 184, Direction.Right, "NPC_RURIRI")
  -- SetAnimation(45) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(partner, 104, 180, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(hero, 104, 180, false, 2)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 168, 184, Direction.Right, "NPC_BIPPA")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, partner, 4) end)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 152, 160, Direction.DownRight, "NPC_PUKURIN")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, partner, 4) end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 168, 216, Direction.UpRight, "NPC_HEIGANI")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, partner, 4) end)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 184, 160, Direction.DownRight, "NPC_PERAPPU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, partner, 4) end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 208, 216, Direction.Up, "NPC_DOGOOMU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, partner, 4) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 224, 200, Direction.UpLeft, "NPC_KIMAWARI")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, partner, 4) end)
  local npc_npc_koiru = SkySceneKit.spawn_npc("magnemite", 144, 208, Direction.Right, "NPC_KOIRU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_koiru, partner, 4) end)
  local npc_npc_mariru = SkySceneKit.spawn_npc("marill", 208, 168, Direction.Down, "NPC_MARIRU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, partner, 4) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 232, 176, Direction.Left, "NPC_CHIRIIN")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, partner, 4) end)
  GROUND:MoveToPosition(partner, 168, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 180, 212, false, 2)
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownRight)
  GROUND:MoveToPosition(hero, 168, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_heigani, 152, 212, false, 2)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpRight)
  GROUND:MoveToPosition(partner, 176, 176, false, 2)
  GROUND:MoveToPosition(npc_npc_koiru, 140, 188, false, 2)
  GROUND:MoveToPosition(hero, 176, 192, false, 2)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpRight)
  GROUND:EntTurn(npc_npc_koiru, Direction.Right)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_mariru, Direction.Down)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Left)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -3) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [CS:N]Azurill[CR]![K] Is he all right?", french=" Hé, [CS:N]Azurill[CR]![K] Est-ce qu'il va bien?", german=" Hey, [CS:N]Azurill[CR]![K] Geht es ihm gut?", italian=" Ehi, [CS:N]Azurill[CR]![K] Sta bene?", spanish="Eh, ¡[CS:N]Azurill[CR]![K] ¿Se encuentra\nbien?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey, [CS:N]Azurill[CR]![K] Is he all right?", french=" Hé, [CS:N]Azurill[CR]![K] Est-ce qu'il va bien?", german=" Hey, [CS:N]Azurill[CR]![K] Geht es ihm gut?", italian=" Ehi, [CS:N]Azurill[CR]![K] Sta bene?", spanish="Eh, ¡[CS:N]Azurill[CR]![K] ¿Se encuentra\nbien?"})
  else
  SkySceneKit.say({english=" Oh, [CS:N]Azurill[CR]![K] Is he all right?", french=" Hé, [CS:N]Azurill[CR]![K] Est-ce qu'il va bien?", german=" Oh, [CS:N]Azurill[CR]![K] Geht es ihm gut?", italian=" Ehi, [CS:N]Azurill[CR]![K] Sta bene?", spanish="Eh, ¡[CS:N]Azurill[CR]![K] ¿Se encuentra\nbien?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="There seems to be no danger to\nhis life, but...", french="Ses jours ne sont pas en danger,\nje pense, mais...", german="Er scheint nicht in Lebensgefahr\nzu sein, aber...", italian="La sua vita non sembra essere\nin pericolo, ma...", spanish=" Su vida no corre peligro, pero..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -3) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What happened to him?!", french=" Que lui est-il arrivé?!", german=" Was ist mit ihm geschehen?!?", italian=" Cosa gli è successo?!", spanish=" ¡¿Qué le ha pasado?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What happened to him?!", french=" Que lui est-il arrivé?!", german=" Was ist mit ihm geschehen?!?", italian=" Cosa gli è successo?!", spanish=" ¡¿Qué le ha pasado?!"})
  else
  SkySceneKit.say({english=" What happened to him?!", french=" Que lui est-il arrivé?!", german=" Was ist mit ihm geschehen?!?", italian=" Cosa gli è successo?!", spanish=" ¡¿Qué le ha pasado?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_mariru, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="He's been sleeping and sleeping\nand sleeping...[K] But he won't wake up.", french="Il dort sans interruption...[K] et\nil ne se réveille jamais.", german="Er schläft und schläft und\nschläft...[K] Aber er wacht nicht mehr auf.", italian="Dorme, dorme, dorme...[K]\nE non si sveglia.", spanish="No hace más que dormir...[K]\nNo se despierta."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -3) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?! He won't wake up?", french=" Hein?! Il ne se réveille jamais?", german=" Wie?!? Er wacht nicht auf?", italian=" Eh?! Non si sveglia?", spanish=" ¡¿Qué?! ¿No se despierta?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?! He won't wake up?", french=" Hein?! Il ne se réveille jamais?", german=" Was?!? Er wacht nicht auf?", italian=" Eh?! Non si sveglia?", spanish=" ¡¿Qué?! ¿No se despierta?"})
  else
  SkySceneKit.say({english=" What?! He won't wake up?", french=" Hein?! Il ne se réveille jamais?", german=" Was?!? Er wacht nicht auf?", italian=" Eh?! Non si sveglia?", spanish=" ¡¿Qué?! ¿No se despierta?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Yes...", french=" Non...", german=" Ja...", italian=" Esatto.", spanish=" No..."})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="I tried waking him over and\nover, but he's still asleep.", french="J'ai essayé de le réveiller\nplein de fois, mais ça ne marche pas.", german="Ich versuche die ganze Zeit,\nihn zu wecken, aber er schläft immer noch.", italian="Ho provato più e più volte\na svegliarlo, ma dorme ancora.", spanish="Lo he intentado varias veces,\npero no hay manera."})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="I got worried. So I brought him\nto the guild.", french="J'étais très inquiet, alors je l'ai\namené à la Guilde.", german="Ich habe Angst bekommen.\nDeshalb habe ich ihn zur Gilde gebracht.", italian="Mi sono preoccupato, quindi\nl'ho portato alla Gilda.", spanish="Me estaba preocupando mucho.\nPor eso le he traído al [CS:N]Pokégremio[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Urf...[K] Urrrfff...", french=" Ah...[K] Aaargh...", german=" Uff...[K] Urrrfff...", italian=" Urf...[K] Urrrfff...", spanish=" Hum...[K] Aaah..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpRight)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpRight)
  GROUND:EntTurn(npc_npc_koiru, Direction.Right)
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownRight)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_mariru, Direction.Down)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -3) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="He seems to be tormented by\nsomething...", french="On dirait que quelque chose\nle tourmente...", german="Anscheinend quält ihn\nirgendetwas...", italian="Sembra che ci sia qualcosa che\nlo tormenta...", spanish="Parece que algo le está\natormentando..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="He seems to be tormented by\nsomething...", french="On dirait que quelque chose\nle tourmente...", german="Anscheinend quält ihn\nirgendetwas...", italian="Sembra che ci sia qualcosa che\nlo tormenta...", spanish="Parece que algo le está\natormentando..."})
  else
  SkySceneKit.say({english="He seems to be tormented by\nsomething...", french="On dirait que quelque chose\nle tourmente...", german="Anscheinend quält ihn\nirgendetwas...", italian="Sembra esserci qualcosa che\nlo tormenta...", spanish="Parece que algo le está\natormentando..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="He's been like that the whole\ntime he's been asleep.", french="Il est comme ça depuis qu'il\ns'est endormi.", german="Er ist so, seit er\neingeschlafen ist.", italian="Fa così da quando si è\naddormentato.", spanish=" Ha estado así todo el rato."})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="It's like he's suffering...[K] Is he\nhaving a bad dream?", french="C'est comme s'il avait mal...[K]\nEst-ce qu'il fait un cauchemar?", german="Als ob er leiden würde...[K] Träumt\ner schlecht?", italian="È come se stesse soffrendo...[K]\nChe stia avendo un incubo?", spanish="Parece que sufre...[K]\n¿Estará teniendo una pesadilla?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey, that could be it.", french="Eh dis donc, ça y ressemble\nbien.", german=" Hey, hey, das könnte es sein.", italian=" Ehi, ehi, potrebbe essere.", spanish=" Podría ser."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="The way the little fellow is\ntossing and turning, it looks like he's having\na nightmare, hey, hey.", french="La façon dont le petit gars\ns'agite et se retourne, c'est comme s'il faisait\nun cauchemar, saperlipopince!", german="So, wie der Kleine sich wälzt\nund windet, scheint er einen Albtraum zu haben,\nhey, hey.", italian="Da come il piccolo si sta\nagitando, si direbbe che sia nel bel mezzo\ndi un incubo, ehi, ehi.", spanish="Por cómo se mueve, yo diría\nque está teniendo una pesadilla."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -3) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, [CS:N]Chatot[CR].[K] Is there any way of\nwaking [CS:N]Azurill[CR] up?", french="Dis, [CS:N]Pijako[CR].[K] Est-ce qu'il\ny a un moyen de réveiller [CS:N]Azurill[CR]?", german="Hey, [CS:N]Plaudagei[CR].[K] Gibt es\nirgendeinen Weg, [CS:N]Azurill[CR] aufzuwecken?", italian="Ehi, [CS:N]Chatot[CR].[K] C'è un modo\nper svegliare [CS:N]Azurill[CR]?", spanish="Oye, [CS:N]Chatot[CR].[K] ¿Hay alguna forma\nde despertar a [CS:N]Azurill[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hey, [CS:N]Chatot[CR].[K] Do you know how\nwe can wake up [CS:N]Azurill[CR]?", french="Dis, [CS:N]Pijako[CR].[K] Est-ce qu'il\ny a un moyen de réveiller [CS:N]Azurill[CR]?", german="Hey, [CS:N]Plaudagei[CR].[K] Weißt du, wie\nwir [CS:N]Azurill[CR] aufwecken könnten?", italian="Ehi, [CS:N]Chatot[CR].[K] C'è un modo\nper svegliare [CS:N]Azurill[CR]?", spanish="Oye, [CS:N]Chatot[CR].[K] ¿Hay alguna forma\nde despertar a [CS:N]Azurill[CR]?"})
  else
  SkySceneKit.say({english="Hey, [CS:N]Chatot[CR].[K] Do you have any\nidea about how we can wake up [CS:N]Azurill[CR]?", french="Dis, [CS:N]Pijako[CR].[K] Est-ce qu'il\ny a un moyen de réveiller [CS:N]Azurill[CR]?", german="Hey, [CS:N]Plaudagei[CR].[K] Hast du einen\nVorschlag, wie wir [CS:N]Azurill[CR] aufwecken könnten?", italian="Ehi, [CS:N]Chatot[CR].[K] C'è un modo\nper svegliare [CS:N]Azurill[CR]?", spanish="Oye, [CS:N]Chatot[CR].[K] ¿Hay alguna forma\nde despertar a [CS:N]Azurill[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_mariru, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Right)
  GROUND:EntTurn(npc_npc_koiru, Direction.UpRight)
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Hmm...[K] Unfortunately, I'm fresh\nout of ideas too.", french="Hum...[K] Malheureusement, je suis\nà court d'idées pour le moment.", german="Hmm...[K] Mir fehlt leider auch\neine Idee.", italian="Mmm...[K] Sfortunatamente non\nmi viene in mente niente.", spanish="Hum...[K] Pues no se me ocurre\nnada."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="To be locked in a nightmare...\nunable to wake for days on end... I've never\nheard of such a thing.", french="Etre enfermé dans un\ncauchemar... sans pouvoir se réveiller. C'est\nla première fois que je vois un cas pareil.", german="In einem Albtraum gefangen zu\nsein, ohne aufwachen zu können, tagelang...\nSo etwas habe ich noch nie gehört.", italian="Rimanere imprigionati in un\nincubo per giorni... Non ho mai sentito niente\ndel genere.", spanish="Sumido en una pesadilla sin\npoder despertarse en días... Nunca había\nvisto nada igual."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chiriin, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Since he's asleep, we can't feed\nhim anything like berries.", french="Comme il dort, on ne peut\npas le nourrir avec quoi que ce soit, même\npas des baies.", german="Wir können ihm auch keine\nBeeren oder so geben, wenn er schläft.", italian="Dal momento che dorme, non\npossiamo dargli Bacche o cose simili.", spanish="Como está dormido, no podemos\ndarle bayas ni nada parecido."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="We're at our wit's end trying to\ncome up with the cure.", french="Nous n'avons pas le moindre\nindice sur la façon de guérir ce mal.", german="Wir sind mit unserem Latein am\nEnde, ein Heilmittel zu finden.", italian="Siamo a corto di idee su come\ncurarlo.", spanish="Estamos aquí volviéndonos locos\npara encontrar una cura."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Who'd know a way of getting rid\nof a nightmare...? Hey, hey, hey...", french="Eh dis donc, qui connaîtrait le\nmoyen de se débarrasser d'un cauchemar...?", german="Wer könnte wissen, wie man\nAlbträume loswird? Hey, hey, hey...", italian="Chi potrebbe sapere come ci si\nlibera da un incubo...? Ehi, ehi, ehi...", spanish="Oye, oye... ¿Y quién va a saber\ncómo librarse de una pesadilla?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Uh... Um...[K] Uh, everyone, can I\nsay something?", french="Euh... hum, hum...[K] Dites voir,\nj'peux proposer quequ'chose?", german="Ähm, öh...[K] Äh, Leute, darf ich\nmal was sagen?", italian="Uh... Uhm...[K] Ehi, gente, posso\ndire una cosa?", spanish=" Esto...[K] ¿Puedo decir algo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_koiru, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_bippa, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" What is it, [CS:N]Bidoof[CR]?", french=" Qu'est-ce qu'il y a, [CS:N]Keunotor[CR]?", german=" Was denn, [CS:N]Bidiza[CR]?", italian=" Cosa c'è, [CS:N]Bidoof[CR]?", spanish=" ¿El qué, [CS:N]Bidoof[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_bippa, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I got to thinking... Since we\ncan't make the nightmare go away...", french="J'y réfléchis d'puis un bon bout\nd'temps... Puisqu'on peut pas l'chasser, ce\ncauchemar...", german="Mir ist ein Gedanke gekommen.\nDa wir den Albtraum nicht verschwinden\nlassen können...", italian="Stavo pensando... Visto che non\npossiamo far sparire l'incubo...", spanish="Estaba pensando que... ya que\nno podemos sacarle de la pesadilla..."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="If we somehow figure out what\nkind of nightmare he's having...", french="... il faudrait qu'on arrive\nà savoir quel genre d'cauchemar c'est...", german="Vielleicht könnten wir\nwenigstens herausfinden, was für einen\nAlbtraum er hat...", italian="Se riusciamo a capire che\ntipo di incubo sta avendo...", spanish="Tal vez podríamos averiguar\nqué clase de pesadilla tiene..."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Maybe we can figure out why\nthat little [CS:N]Azurill[CR] can't wake up, by golly.", french="Comme ça, on pourra p'têt'\nsavoir pourquoi [CS:N]Azurill[CR], il peut pas\ns'réveiller, pardi!", german="Dann finden wir vielleicht auch\nheraus, warum der kleine [CS:N]Azurill[CR] nicht\naufwachen kann, Menschenskind.", italian="Beh, forse potremmo renderci\nconto del perché il piccolo [CS:N]Azurill[CR] non riesce a\nsvegliarsi, ohibò.", spanish="Igual descubriríamos por qué\n[CS:N]Azurill[CR] no puede despertar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_mariru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Oh! RIGHT![K] So we should look\ninto [CS:N]Azurill[CR]'s dream!", french="Oh! Bon sang, mais c'est BIEN\nSUR![K] On n'a qu'à aller explorer le rêve\nd'[CS:N]Azurill[CR]!", german="Oh! RICHTIG![K] Wir sollten uns\nden Traum von [CS:N]Azurill[CR] ansehen!", italian="Oh! GIUSTO![K] Quindi dovremmo\ndare un'occhiata all'incubo di [CS:N]Azurill[CR]!", spanish="¡Claro![K] ¡Podríamos descifrar\nel sueño de [CS:N]Azurill[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" How do we do THAT?!", french="Mais tu peux me dire COMMENT\ntu comptes faire ÇA?!", german=" Wie soll DAS denn gehen?!?", italian=" COME facciamo?!", spanish=" ¿Pero cómo lo hacemos?"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Look inside a DREAM?!", french="Explorer un REVE?! N'importe\nquoi...", german=" In einen TRAUM reinschauen?!?", italian=" Dare un'occhiata a un SOGNO?!", spanish="¿Cómo podemos saber lo que\nestá soñando?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Yipes! Gosh, I'm sorry.", french="Ben quoi! J'suis vachement\ndésolé!", german="Herrje! Menschenskind, tut\nmir leid.", italian=" Aaah! Ohibò, mi spiace.", spanish=" ¡Huyuyuy! Lo siento..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Actually...[K]that might be possible.", french="A bien y réfléchir...[K] c'est\npeut-être faisable.", german="Eigentlich...[K] könnte das sogar\nmöglich sein.", italian="In realtà...[K] potrebbe\nessere possibile.", spanish=" En realidad...[K] tal vez sea posible."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_mariru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_koiru, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: WHAT?!", french="[CS:N]Tous[CR]: QUOI?!", german="[CS:N]Alle[CR]: WAS?!?", italian="[CS:N]Tutti[CR]: COSA?!", spanish="[CS:N]Todos[CR]: ¡¿QUÉEE?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey![K] How do you do that?!", french=" Eh dis donc![K] Comment on fait?!", german=" Hey, hey![K] Wie soll das gehen?!?", italian=" Ehi, ehi![K] Come si fa?!", spanish=" ¡Oye, oye![K] ¡¿Y cómo se hace?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We find [CS:N]Drowzee[CR].[K] If anyone can\ndo it, [CS:N]Drowzee[CR] can.", french="Allons trouver [CS:N]Soporifik[CR].[K]\nS'il y a quelqu'un qui peut y arriver, c'est bien\nlui.", german="Wir gehen zu [CS:N]Traumato[CR].[K] Wenn\nirgendjemand das kann, dann [CS:N]Traumato[CR].", italian="Dobbiamo trovare [CS:N]Drowzee[CR].[K] Se\nc'è qualcuno che lo può fare, è lui.", spanish="Busquemos a [CS:N]Drowzee[CR].[K]\nSi alguien puede hacerlo, es él."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -3) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Drowzee[CR]?[K] I've heard that name\nbefore...", french="[CS:N]Soporifik[CR]?[K] J'ai déjà entendu\nce nom-là quelque part...", german="[CS:N]Traumato[CR]?[K] Diesen Namen habe\nich schon einmal gehört...", italian="[CS:N]Drowzee[CR]?[K] Ho già sentito\nquel nome...", spanish="¿[CS:N]Drowzee[CR]?[K] Ya había oído\nhablar de él."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Drowzee[CR]?[K] I know that name\nsomehow...", french="[CS:N]Soporifik[CR]?[K] J'ai déjà entendu\nce nom-là quelque part...", german="[CS:N]Traumato[CR]?[K] Der Name kommt mir\nbekannt vor...", italian="[CS:N]Drowzee[CR]?[K] Ho già sentito\nquel nome...", spanish="¿[CS:N]Drowzee[CR]?[K] Me suena ese\nnombre..."})
  else
  SkySceneKit.say({english="[CS:N]Drowzee[CR]?[K] I think I've heard that\nbefore...", french="[CS:N]Soporifik[CR]?[K] J'ai déjà entendu\nce nom-là quelque part...", german="[CS:N]Traumato[CR]?[K] Den Namen kenne ich\nvon irgendwoher...", italian="[CS:N]Drowzee[CR]?[K] Ho già sentito\nquel nome...", spanish="¿[CS:N]Drowzee[CR]?[K] Me suena ese\nnombre..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownRight)
  GROUND:EntTurn(npc_npc_mariru, Direction.DownLeft)
  -- message_FacePositionOffset(-1, -3) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Th-that's it!", french=" C'est ça!", german=" D-das ist es!", italian=" C-Ci sono!", spanish=" ¡Ajá!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Th-that's it!", french=" C'est ça!", german=" D-das ist es!", italian=" C-Ci sono!", spanish=" ¡Ajá!"})
  else
  SkySceneKit.say({english=" Th-that's it!", french=" C'est ça!", german=" D-das ist es!", italian=" C-Ci sono!", spanish=" ¡Ajá!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Remember, [hero]? [K]\nWe know [CS:N]Drowzee[CR]!", french="Tu te souviens, [hero]?[K]\nNous connaissons [CS:N]Soporifik[CR]!", german="Erinnerst du dich,\n[hero]?[K] Gegen [CS:N]Traumato[CR] haben wir\ngekämpft!", italian="Ti ricordi, [hero]?[K]\nConosciamo [CS:N]Drowzee[CR]!", spanish="¿Te acuerdas, [hero]? [K]\n¡Claro que conocemos a [CS:N]Drowzee[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Remember, [hero]? [K]\nWe fought [CS:N]Drowzee[CR]!", french="Tu te souviens, [hero]?[K]\nNous connaissons [CS:N]Soporifik[CR]!", german="Erinnerst du dich,\n[hero]?[K] Wir kennen [CS:N]Traumato[CR]!", italian="Ti ricordi, [hero]?[K]\nConosciamo [CS:N]Drowzee[CR]!", spanish="¿Te acuerdas, [hero]? [K]\n¡Claro que conocemos a [CS:N]Drowzee[CR]!"})
  else
  SkySceneKit.say({english="Remember, [hero]? [K]\nWe know [CS:N]Drowzee[CR]!", french="Tu te souviens, [hero]?[K]\nNous connaissons [CS:N]Soporifik[CR]!", german="Erinnerst du dich,\n[hero]?[K] Wir kennen [CS:N]Traumato[CR]!", italian="Ti ricordi, [hero]?[K]\nConosciamo [CS:N]Drowzee[CR]!", spanish="¿Te acuerdas, [hero]? [K]\n¡Claro que conocemos a [CS:N]Drowzee[CR]!"})
  end
  -- message_Close
  GAME:FadeOut(false, 15)
  SkySceneKit.cleanup_npcs()
end
