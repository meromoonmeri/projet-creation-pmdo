-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/um1608.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_oosubame = SkySceneKit.spawn_npc("swellow", 320, 288, Direction.UpLeft, "NPC_OOSUBAME")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_oosubame, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="My partner was terrified of\nme, and I didn't know it...", french="Mon partenaire avait une\npeur panique de moi, et je ne le savais\nmême pas...", german="Mein Partner hatte schreckliche\nAngst vor mir, und ich wusste nichts davon.", italian="Terrorizzavo il mio compagno, e\nnon lo sapevo...", spanish="Mi compañero me tenía pánico...\ny yo no tenía ni idea..."})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" As a leader...[K]I must be a failure.", french="Je dois être indigne... [K]d'être\nmeneur.", german="Als Anführer[K] muss ich ein\nechter Versager sein.", italian="Come leader...[K] sono proprio un\nfallimento.", spanish="Como líder...[K] debo de ser\nun fracaso."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_oosubame, 4) end)
  local npc_npc_kemusso = SkySceneKit.spawn_npc("wurmple", 296, 272, Direction.DownRight, "NPC_KEMUSSO")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_oosubame, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" What...[K]what are you suggesting?", french="Quoi... [K]mais qu'est-ce que\ntu sous-entends?", german="Was...[K] Was willst du damit\nandeuten?", italian="Cosa...[K]\nCosa avevi capito?", spanish=" ¿Qué...?[K] ¿Qué quieres decir?"})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" Me? Eat you? Are you kidding?", french="Moi? Te manger, toi?\nTu rigoles ou quoi?", german="Ich dich essen? Machst du\nWitze?", italian="Io? Mangiare te? Stai\nscherzando?", spanish="¿Crees que te comería a ti?\n¿Estás de guasa?"})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="[CS:N]Wurmple[CR]![K] You're my\ntrusted partner.", french="[CS:N]Chenipotte[CR]![K] Tu es mon fidèle\npartenaire.", german="[CS:N]Waumpel[CR]![K] Du bist mein\nzuverlässiger Partner.", italian="[CS:N]Wurmple[CR]![K] Tu sei il mio\nfido compagno.", spanish="¡[CS:N]Wurmple[CR]![K] Eres mi fiel\ncompañero."})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="You're my one...[K]and only partner.\nThere's no replacing you!", french="Mon seul... [K]et unique partenaire.\nTu es irremplaçable!", german="Du bist mein einziger,[K] mein\nwirklich einziger Partner. Du bist unersetzbar!", italian="Sei il mio solo...[K] e unico\ncompagno. Sei insostituibile!", spanish="Eres mi único...[K] compañero.\n¿Dónde iba a encontrar a alguien como tú?"})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="You and me, we're going to keep\non exploring together like we've always done.", french="Toi et moi, on va continuer à\nexplorer ensemble comme on l'a toujours fait.", german="Du und ich, wir werden weiter\nzusammen auf Erkundung gehen, wie wir es\nseit jeher getan haben.", italian="Tu e io continueremo ad andare a\nesplorare insieme come abbiamo sempre fatto.", spanish="Los dos vamos a seguir\nexplorando juntos, igual que siempre."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kemusso, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_oosubame, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" Hm?[K] Why are you crying?", french="Hein?[K] Pourquoi est-ce que\ntu pleures?", german=" Nanu?[K] Warum weinst du?", italian=" Mmm?[K] Perché piangi?", spanish=" ¿Eh?[K] ¿Por qué lloras?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- @label_66 [étiquette de flux ExplorerScript]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_oosubame, 4) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" Hey, [CS:N]Wurmple[CR]!", french=" Hé, [CS:N]Chenipotte[CR]!", german=" Hey, [CS:N]Waumpel[CR]!", italian=" Ehi, [CS:N]Wurmple[CR]!", spanish=" ¡Oye, [CS:N]Wurmple[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="Isn't it great? The world's back\nto peace and all.", french="C'est pas génial? Le monde est à\nnouveau en paix.", german="Ist das nicht großartig? Es ist\nwieder Frieden auf der Welt eingekehrt.", italian="Non è magnifico? Nel mondo\nè tornata la pace.", spanish="¿No es genial? El mundo vuelve\na recobrar la tranquilidad."})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" When things are this mellow...", french=" Quand tout va bien comme ça...", german="Wenn die Dinge so heiter\nsind...", italian="Quando gli eventi prendono una\npiega positiva...", spanish="Cuando las cosas marchan tan\nbien..."})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="Don't you find yourself\ngetting hungry?", french="Ça ne te donne pas faim, toi?\nMoi, en tout cas...", german="Wirst du nicht auch irgendwie\nhungrig?", italian="Non sentite anche voi un\nlanguorino?", spanish="¿Nunca te ha pasado que te\nentran ganas de zamparte algo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kemusso, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english=" Wh-what?! H-hungry?!", french=" Q-quoi?! F-faim?!", german=" W-was?!? H-hungrig?!?", italian=" Languorino, hai detto...?!", spanish=" ¡¿Qué?! ¡¿Zamparte algo?!"})
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english=" Eeep! Y-y-yeesh!", french=" Gloups! Pauvre de moi!", german=" Urgs! W-w-waaaaah!", italian=" Aaah! G-G-Già!", spanish=" ¡Aaaay!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" So let me ask you a question.", french="Laisse-moi te poser une\nquestion.", german=" Lass mich dir eine Frage stellen.", italian=" Vorrei chiederti una cosa.", spanish="Entonces déjame que te pregunte\nuna cosa."})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="Try to guess...[K]what I really\nwant to eat right now!", french="Devine... [K]qu'est-ce que\nje meurs d'envie de manger, là, maintenant,\ntout de suite?", german="Rate mal,[K] was ich jetzt wirklich\ngerne essen würde!", italian="Prova a immaginare...[K] cosa\navrei davvero voglia di mangiare adesso!", spanish="Intenta adivinar...[K] ¡lo que me\ngustaría zamparme ahora mismo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kemusso, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english=" Y-y-yeesh!", french=" Gloups!", german=" W-w-waaaaah!", italian=" S-S-Sì!", spanish=" ¡Esto...!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="[CS:N]Wurmple[CR].[K] Can you guess what I\nmost want to eat right now?", french="[CS:N]Chenipotte[CR]...[K] Tu sais ce que\nj'ai envie de manger, là, tout de suite?", german="[CS:N]Waumpel[CR].[K] Hast du eine Idee, was\nich jetzt gerne essen würde?", italian="[CS:N]Wurmple[CR],[K] sai cosa mi\nmangerei adesso?", spanish="[CS:N]Wurmple[CR].[K] ¿Sabes lo que me\ngustaría comerme en este momento?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english=" Eeeep!", french=" Gloups!", german=" W-w-waaaaah!", italian=" Aaaah!", spanish=" ¡Aaaay!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_oosubame, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="What? What?\nDid something happen?", french="Hein? Quoi?\nIl s'est passé quelque chose?", german="Was? Was?\nIst etwas passiert?", italian="Come, come?\nÈ successo qualcosa?", spanish="¿Qué? ¿¿Qué??\n¿Ha ocurrido algo?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 8] || scn($SCENARIO_MAIN) >= [29
  -- jump @label_66 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_oosubame, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" Go for it, Team [team:]!", french=" Foncez, Equipe [team:]!", german="Haltet euch ran,\nTeam [team:]!", italian=" Forza, Team [team:]!", spanish=" ¡Adelante, [CS:X]Equipo[CR] [team:]!"})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="Take the Time Gears back to\n[CS:P]Temporal Tower[CR]!", french="Rapportez les Rouages du Temps\nà la [CS:P]Tour du Temps[CR]!", german="Bringt die Zahnräder der Zeit\nzurück zum [CS:P]Zeitturm[CR]!", italian="Riportate gli Ingranaggi del\nTempo nella [CS:P]Torre del Tempo[CR]!", spanish="¡Llevad los engranajes a la\n[CS:P]Torre del Tiempo[CR]!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_oosubame, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="Doing nothing but waiting is\nfrustrating, but...[K]it's the great [CS:N]Dusknoir[CR]'s call.", french="Attendre là sans rien faire,\nc'est frustrant, mais... [K]c'est la volonté\ndu grand [CS:N]Noctunoir[CR].", german="Diese dumpfe Warterei ist\necht frustrierend, aber[K] es ist die\nEntscheidung des großen [CS:N]Zwirrfinst[CR].", italian="Non far altro che aspettare è\nfrustrante, ma...[K] è una richiesta del grande\n[CS:N]Dusknoir[CR].", spanish="Esperar sin hacer nada es\nfrustrante, pero...[K] la situación está en\nmanos del gran [CS:N]Dusknoir[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" We have to trust him to do it.", french="Nous devons lui faire confiance\npour accomplir cette mission.", german="Wir müssen darauf vertrauen,\ndass er es schafft.", italian=" Dobbiamo credere in lui.", spanish=" Tenemos que confiar en él."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 1] || scn($SCENARIO_MAIN) >= [16
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_oosubame, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="[CS:N]Grovyle[CR], huh...?[K] Can't say I've\nheard of him, to be honest.", french="[CS:N]Massko[CR], hein...?[K] Jamais\nentendu parler.", german="[CS:N]Reptain[CR], wie?[K] Kann nicht\nbehaupten, schon von ihm gehört zu haben, um\nehrlich zu sein.", italian="[CS:N]Grovyle[CR], eh...?[K] No, mi pare\ndi non averne mai sentito parlare.", spanish="¿[CS:N]Grovyle[CR]?[K] La verdad es que\nnunca he oído hablar de él."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 4] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_oosubame, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="I heard that the different kinds\nof [CS:I]Prize Tickets[CR] have something\nto do with your Explorer Rank...", french="Il paraît que les différentes\nsortes de [CS:I]Tickets Magot[CR] ont un rapport\navec ton Grade d'Explorateur...", german="Ich hörte, die verschiedenen\n[CS:I]Preistickets[CR] hängen mit eurem\nErkunderrang zusammen...", italian="A quanto si dice, i vari tipi di\n[CS:I]Buoni Premio[CR] avrebbero qualcosa a che fare\ncon il Rango Esploratore...", spanish="Creo que los diferentes tipos de\n[CS:I]boletos[CR] tienen algo que ver\ncon el rango del equipo..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 4] || scn($SCENARIO_MAIN) >= [12
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_oosubame, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" Hey, [CS:N]Wurmple[CR]!", french=" Hé, [CS:N]Chenipotte[CR]!", german=" Hey, [CS:N]Waumpel[CR]!", italian=" Ehi, [CS:N]Wurmple[CR]!", spanish=" ¡Oye, [CS:N]Wurmple[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english=" Y-yes!", french=" O-oui!", german=" J-ja!", italian=" S-Sì!", spanish=" ¿Sí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" The weather's good today.", french=" Il fait beau aujourd'hui.", german=" Das Wetter ist schön heute.", italian=" Che bella giornata è oggi!", spanish=" Hoy hace buen tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="On nice days like this...[K] I really\nwork up an appetite!", french="Un temps pareil...[K] Ça m'ouvre\nl'appétit! Et quand l'appétit va, tout va!", german="An schönen Tagen wie diesem[K]\nbekomme ich immer ganz schön Hunger!", italian="Il bel tempo...[K] mi stimola\nl'appetito!", spanish="En días así...[K] ¡se me abre el\napetito!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kemusso, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english=" Huh?[K] Really?![K] Eeep! Y-y-yeesh!", french="Ah... [K]Ah bon? Vraiment?![K]\nGloups... pauvre de moi...", german="Wie?[K] Ehrlich?!?[K] Urgs!\nW-w-waaaaah!", italian="Eh?[K] Davvero?![K] Aaah!\nG-G-Già!", spanish=" ¿Eh?[K] ¿Ah, sí?[K] ¡Aaaay!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 7]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_oosubame, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_oosubame, hero, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="What's that?[K] You want me to\nexplain how the Job Bulletin Board works?", french="Quoi?[K] Vous voulez que je vous\nexplique comment marche le Tableau des\nMissions?", german="Was gibt es denn?[K] Ihr wollt,\ndass ich erkläre, wie das Job-Infobrett\nfunktioniert?", italian="Come?[K] Vuoi sapere\ncome funziona la Bacheca delle missioni?", spanish="¿Qué?[K] ¿Quieres que te explique\ncómo funciona el Tablón de Anuncios?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" ...Oh. You're not interested...", french="... Ah. Dans ce cas, si ça ne\nvous intéresse pas...", german="Oh, ihr seid nicht\ninteressiert.", italian=" Ah. Non ti interessa...", spanish=" Oh. No te interesa..."})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" It's fun to do jobs, but...", french="C'est amusant de partir en\nmission, mais...", german="Es macht Spaß, Jobs zu\nerledigen, aber...", italian="È divertente fare le missioni,\nma...", spanish="Es divertido cumplir misiones,\npero..."})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" Incidentally...", french=" A propos...", german=" Übrigens...", italian=" A proposito...", spanish=" A propósito..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_oosubame, npc_npc_kemusso, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" Hey, [CS:N]Wurmple[CR]!", french=" Hé, [CS:N]Chenipotte[CR]!", german=" Hey, [CS:N]Waumpel[CR]!", italian=" Ehi, [CS:N]Wurmple[CR]!", spanish=" ¡Oye, [CS:N]Wurmple[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="I was checking out the Job\nBulletin Board. I found a great job.", french="J'ai consulté le Tableau des\nMissions et j'ai trouvé une super mission.", german="Ich habe das Job-Infobrett\ndurchgesehen. Ich habe einen prima Job\ngefunden.", italian="Stavo controllando la Bacheca\ndelle missioni. Ne ho trovata una grandiosa.", spanish="Estaba echando un vistazo al\nTablón de Anuncios y he encontrado una\nmisión estupenda."})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="It's an easy job, plus it\npays well.", french=" Facile et bien payée.", german="Es ist ein leichter Job und die\nBezahlung ist auch gut.", italian=" È facile e anche ben pagata!", spanish="Es fácil, y además la paga es\njugosa."})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" Sounds real tasty!", french="Bref, un régal en perspective!\nMiam-miam!", german=" Klingt richtig schmackhaft!", italian=" Sembra davvero appetitosa!", spanish="Jugosa... Hum, ¡ya se me ha\nabierto el apetito!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kemusso, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kemusso) end)
  SkySceneKit.say({english=" T-t-tasty...?![K] S-s-sheesh...", french="Q-quoi? Miam-miam?![K]\nGloups!", german="Sch-sch-schmackhaft?!?[K]\nG-g-grundgütiger!", italian=" A-A-Appetitosa...?![K] C-C-Certo...", spanish=" El... ¿el apetito?[K] Aaaay..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english=" Well, all right![K] Let me explain!", french=" Très bien![K] Je vous explique!", german=" Also gut![K] Lasst mich erklären!", italian="Ok, va bene![K] Lascia che ti\nspieghi!", spanish=" ¡Muy bien![K] ¡Te lo explicaré!"})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="First, you want to stand in front\nof the Job Bulletin Board, then press [M:B2].", french="D'abord, placez-vous devant le\nTableau des Missions et appuyez sur [M:B2].", german="Stellt euch zuerst vor das\nJob-Infobrett und drückt dann [M:B2].", italian="Come prima cosa, avvicinati alla\nBacheca delle missioni e premi [M:B2].", spanish="Primero, ponte delante del\nTablón de Anuncios y pulsa [M:B2]."})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="You can choose jobs you want to\ndo by using the Job Bulletin Board.", french="Ensuite, choisissez les missions\nque vous voulez accomplir.", german="Ihr könnt diejenigen Jobs, die ihr\nerledigen wollt, auswählen, indem ihr das\nJob-Infobrett verwendet.", italian="Dalla Bacheca puoi scegliere le\nmissioni che ti interessano.", spanish="Puedes escoger, entonces, todas\nlas misiones que quieras realizar del tablón."})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="You'll get a letter describing\neach job you choose. Those letters will show up\non your Job List in the menu.", french="Pour chaque mission choisie,\nvous recevez une lettre qui la décrit. Elle\napparaît dans la Liste de Missions.", german="In der Jobliste im Menü werdet\nihr Buchstaben bemerken, die die Schwierigkeit\neines jeden Jobs, den ihr annehmt, beschreiben.", italian="A ogni missione è associata una\nlettera, che vedrai anche nella tua lista delle\nmissioni.", spanish="Recibirás una carta de cada una\nde las misiones elegidas con su descripción.\nLas verás en tu lista de misiones en el menú."})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="To actually start a job, you must\nuse the Take Job command in your Job List.[K]\nThen you can do the job in the dungeon!", french="Pour accomplir une mission,\nutilisez la commande Accepter de votre menu.[K]\nEnfin, rendez-vous dans le donjon voulu!", german="Um einen Job tatsächlich zu\nbeginnen, wählt AUSÜBEN auf der Jobliste.[K]\nDann könnt ihr den Job im Dungeon erledigen!", italian="Per attivare le missioni nella\nlista, seleziona il comando Attiva.[K] Poi puoi\nandare nel dungeon e iniziare la missione.", spanish="Para iniciar una misión, elígela\nen la lista de misiones y selecciona Aceptar.[K]\n¡Después podrás cumplir la misión!"})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="You must use Take Job before\nstarting a job. Or else you can't do it, even if\nyou go to the correct dungeon!", french="N'oubliez pas d'accepter la\nmission avant de partir. Sinon vous ne pourrez\npas l'accomplir, même en allant dans le donjon!", german="Ihr müsst AUSÜBEN wählen,\nbevor ihr einen Job beginnen könnt. Sonst\nkönnt ihr ihn nicht erledigen!", italian="Se vuoi portare a termine una\nmissione, devi attivarla, altrimenti non potrai\nsvolgerla anche se sei nel dungeon giusto.", spanish="Antes de emprender una misión,\ntendrás que activarla con la opción Aceptar ¡o\nno podrás cumplirla aunque vayas al territorio!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_oosubame, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="Our exploration team is called\nTeam [CS:X]Tasty[CR]!", french="Notre équipe d'exploration\ns'appelle l'Equipe [CS:X]Miam-Miam[CR]!", german="Unser Erkundungsteam heißt\nTeam [CS:X]Schmackhaft[CR]!", italian="La nostra squadra d'esplorazione\nsi chiama Team [CS:X]Mangio[CR]!", spanish="¡Nuestro equipo explorador\nse llama [CS:X]Equipo Sabroso[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="That cool name was thought up\nby my partner [CS:N]Wurmple[CR] next to me!", french="C'est mon partenaire [CS:N]Chenipotte[CR]\nqui a trouvé ce nom, c'est la classe!", german="Diesen coolen Namen hat sich\nmein Partner [CS:N]Waumpel[CR] neben mir\nausgedacht!", italian="Questo fantastico nome è tutta\nfarina del sacco di [CS:N]Wurmple[CR], qua vicino a me!", spanish="¡Ese nombre tan chachi se le\nocurrió a mi compañero [CS:N]Wurmple[CR], aquí\npresente!"})
  pcall(function() UI:SetSpeaker(npc_npc_oosubame) end)
  SkySceneKit.say({english="What do you think? Cool name,\nam I right?!", french="Qu'est-ce que tu en penses?\nC'est la classe, hein?!", german="Was meint ihr? Cooler Name,\noder?", italian="Cosa ne pensate? Gran bel nome,\nvero?", spanish="¿Qué te parece? Un nombre\ngenial, ¿a que sí?"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 0] || scn($SCENARIO_MAIN) >= [3, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
