-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m21a0203.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 368, 264, Direction.UpLeft, "NPC_KIMAWARI")
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" What [CS:N]Dusknoir[CR] did then...", french=" Ce qu'il a fait à ce moment-là...", german=" Was [CS:N]Zwirrfinst[CR] damals tat...", italian=" Quello che [CS:N]Dusknoir[CR] ha fatto...", spanish=" Lo que hizo [CS:N]Dusknoir[CR] entonces..."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="It was strange, any way you look\nat it...", french="C'était super bizarre, quand\nmême...", german="Es war seltsam. Egal, wie man\ndazu steht...", italian="Insomma, si è comportato in\nmodo strano, da ogni punto di vista...", spanish="Fue extraño. Se mire como se\nmire."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 328, 216, Direction.DownRight, "NPC_PERAPPU")
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Really? Do you think so?", french=" Ah vraiment, tu trouves?", german="Wirklich? Glaubst du das\ntatsächlich?", italian=" Davvero? La pensi così?", spanish=" ¿De verdad? ¿Eso crees?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Don't you think that [partner]\nand [hero] fell into the dimensional\nhole by accident?", french="Tu ne crois pas que la chute\nde [partner] et [hero] dans le\ngouffre dimensionnel était accidentelle?", german="Glaubst du nicht, dass\n[partner] und [hero] versehentlich\nin das dimensionale Loch gefallen sind?", italian="Non pensi che la caduta di\n[partner] e [hero] nel tunnel\ndimensionale sia stata accidentale?", spanish="¿No crees que [partner]\ny [hero] se cayeron en el agujero\ndimensional por accidente?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 288, 224, Direction.DownRight, "NPC_DOGOOMU")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 384, 216, Direction.Down, "NPC_PUKURIN")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_dogoomu, 4) end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 360, 224, Direction.Down, "NPC_HEIGANI")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_dogoomu, 4) end)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 376, 240, Direction.Down, "NPC_DIGUDA")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_dogoomu, 4) end)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 344, 272, Direction.UpRight, "NPC_BIPPA")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_dogoomu, 4) end)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 312, 272, Direction.Right, "NPC_GUREGGURU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_dogoomu, 4) end)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 280, 264, Direction.Right, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_dogoomu, 4) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 272, 240, Direction.Right, "NPC_CHIRIIN")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" NO WAY!", french=" IMPOSSIBLE!", german=" KEINESFALLS!", italian=" ASSOLUTAMENTE NO!", spanish=" ¡NI HABLAR!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="[CS:N]Dusknoir[CR] grabbed [partner]\nand [hero]! And YANKED them in!", french="[CS:N]Noctunoir[CR] a attrapé\n[partner] et [hero] pour les\nTIRER avec lui!", german="[CS:N]Zwirrfinst[CR] griff nach\n[partner] und [hero]! Und er zerrte\nsie hinein!", italian="[CS:N]Dusknoir[CR] ha afferrato\n[partner] e [hero]! È stato LUI!", spanish="¡[CS:N]Dusknoir[CR] agarró y arrastró\na [partner] y [hero]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! That's right![K] It looked\nthat way to me too!", french="Eh dis donc! C'est vrai![K] C'est\nl'impression que j'ai eue moi aussi!", german="Hey, hey! Das stimmt![K] So habe\nich es auch gesehen!", italian="Ehi, ehi! È vero![K] Anche a me\npare che sia andata così!", spanish="¡Oye, oye! ¡Es verdad![K]\n¡Yo también lo vi claramente!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! What happened was\nreally weird!", french="Saperlipopince! Ce qui s'est\npassé était vraiment étrange!", german="Hey, hey! Was passiert ist, war\nwirklich seltsam!", italian="Ehi, ehi! Quel che è successo è\ndavvero strano!", spanish="¡Oye, oye! ¡Lo que ocurrió fue\nrealmente raro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Gosh, I really had to wonder why\n[CS:N]Dusknoir[CR] did something like that!", french="Sapristi! C'est vrai! Même que\nj'me suis d'mandé pourquoi [CS:N]Noctunoir[CR] avait\nfait un truc pareil!", german="Meine Güte, ich habe mich echt\ngefragt, warum [CS:N]Zwirrfinst[CR] so etwas tat!", italian="Ohibò, mi chiedo davvero perché\n[CS:N]Dusknoir[CR] abbia fatto una cosa del genere!", spanish="Huyuyuy, ¡hace tiempo que me\npregunto por qué [CS:N]Dusknoir[CR] hizo algo así!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="If...[K] If what [partner] said\nis true...", french="Si...[K] si ce que dit [partner]\nest vrai...", german="Falls...[K] Falls wirklich zutrifft,\nwas [partner] gesagt hat...", italian="Se...[K] Se quello che ha detto\n[partner] è vero...", spanish="Si...[K] Si lo que ha dicho\n[partner] es verdad..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Then what [CS:N]Dusknoir[CR] did suddenly\nmakes perfect sense!", french="Alors ça explique l'attitude de\n[CS:N]Noctunoir[CR]!", german="Dann ergibt das Handeln von\n[CS:N]Zwirrfinst[CR] auf einmal Sinn!", italian="... quello che ha fatto [CS:N]Dusknoir[CR]\navrebbe perfettamente senso!", spanish="Entonces, lo que hizo [CS:N]Dusknoir[CR]\ntendría mucho sentido."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" What?[K] Wait a minute!", french=" Pardon?[K] Attendez une minute!", german=" Was?[K] Wartet mal!", italian=" Cosa?[K] Aspettate un minuto!", spanish=" ¿Qué?[K] ¡Un momento!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" So is that what you think now?", french=" Alors vous avez changé d'avis?", german=" Das denkt ihr jetzt also?", italian=" Quindi ora la pensate così?", spanish=" ¿Eso es lo que creéis ahora?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Are you actually saying that you\nnow believe what [partner] and\n[hero] are claiming?!", french="Vous êtes en train de dire que\nvous croyez l'histoire de [partner] et\n[hero]?!", german="Wollt ihr damit sagen, dass ihr\nden Behauptungen von [partner] und\n[hero] Glauben schenkt?", italian="State dicendo che ora credete\na quello che sostengono [partner] e\n[hero]?!", spanish="¡¿Me vais a decir que creéis\nlo que afirman [partner] y [hero]?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: ..............................", french="[CS:N]Tous[CR]: ..............................", german="[CS:N]Alle[CR]: ..............................", italian="[CS:N]Tutti[CR]: ..............................", spanish="[CS:N]Todos[CR]: ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Well, what's your answer?", french=" Alors, répondez!", german=" Nun, wie lautet die Antwort?", italian=" Beh, allora?", spanish=" Y bien, ¿cuál es la respuesta?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Uh...[K]I...[K]believe them...", french=" Euh...[K] Moi...[K] J'les crois...", german=" Äh...[K] Ich...[K] glaube ihnen.", italian="Ehm...[K] Io...[K] credo a quello\nche dicono...", spanish=" Esto...[K] Yo...[K] Yo les creo..."})
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_bippa, 4) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" What?! What did you say?!", french=" Pardon?! Qu'est-ce que tu dis?!", german=" Was? Was hast du gesagt?!?", italian=" Cosa?! Cosa hai detto?!", spanish=" ¡¿Qué?! ¡¿Qué has dicho?!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="So, [CS:N]Bidoof[CR], you're now claiming\nthat the great [CS:N]Dusknoir[CR] is a villain?", french="Ainsi, [CS:N]Keunotor[CR], tu oses\naffirmer que [CS:N]Noctunoir[CR] est une crapule?", german="So, [CS:N]Bidiza[CR], du behauptest also\njetzt, dass der große [CS:N]Zwirrfinst[CR] ein Bösewicht\nist?", italian="Allora, [CS:N]Bidoof[CR], stai sostenendo\nche il grande [CS:N]Dusknoir[CR] è un criminale?", spanish="[CS:N]Bidoof[CR], ¿afirmas, entonces,\nque el gran [CS:N]Dusknoir[CR] es un villano?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Oof![K] Golly, I surely did think\nhighly of the great [CS:N]Dusknoir[CR].", french="Pfiou![K] Moi aussi, j'avais\nune haute opinion d'[CS:N]Noctunoir[CR], pour sûr.", german="Uff![K] Donnerwetter, ich hatte\nsicherlich eine hohe Meinung vom großen\n[CS:N]Zwirrfinst[CR].", italian="Ooh![K] Ohibò, di sicuro pensavo\ngrandi cose del signor [CS:N]Dusknoir[CR].", spanish="¡Uf![K] Huyuyuy, yo tenía un gran\nconcepto del gran [CS:N]Dusknoir[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="The whole idea sounds troubling\nwhen you put it that way.", french="Dit comme ça, c'est sûr qu'c'est\nvachement inquiétant, pardi.", german="Die ganze Idee klingt\nabenteuerlich, wenn man so will.", italian="Se la metti in questo modo,\nohibò, sembra tutto molto strano.", spanish=" Dicho así, suena un poco fuerte."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="But there's something more\nimportant here!", french="Mais y'a quequ'chose de plus\nimportant!", german="Aber eine Sache ist hierbei\nwichtiger!", italian="Ma c'è qualcosa di più\nimportante!", spanish="Pero hay algo mucho más\nimportante aquí..."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Yup yup! [hero] and\n[partner] are more important!", french="Ouaip! [hero] et\n[partner] ont bien plus d'valeur pour\nnous!", german="Jawollja! [hero] und\n[partner] sind wichtiger!", italian="Sissignore! [hero] e\n[partner] sono più importanti!", spanish="¡Sí, señor! ¡[hero] y\n[partner] son mucho más importantes!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="That's why...[K]I believe what\n[hero] and [partner] have to say!", french="C'est pour ça que...[K] j'crois\n[hero] et [partner] sur parole!", german="Darum...[K] Darum glaube ich, was\n[hero] und [partner] zu sagen haben!", italian="È per questo...[K] che credo a\nquello che dicono [hero] e [partner]!", spanish="Por eso yo...[K] ¡Yo creo lo que\ndicen!"})
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Wh-wh-what!", french=" Que... pardon?!", german=" W-w-was!", italian=" C-C-Cosa!", spanish=" ¡¿Qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]B-Bidoof[CR]!", french=" [CS:N]K-Keunotor[CR]!", german=" [CS:N]B-Bidiza[CR]!", italian=" [CS:N]B-Bidoof[CR]!", spanish=" ¡[CS:N]Bidoof[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]B-Bidoof[CR]!", french=" [CS:N]K-Keunotor[CR]!", german=" [CS:N]B-Bidiza[CR]!", italian=" [CS:N]B-Bidoof[CR]!", spanish=" ¡[CS:N]Bidoof[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]B-Bidoof[CR]!", french=" [CS:N]K-Keunotor[CR]!", german=" [CS:N]B-Bidiza[CR]!", italian=" [CS:N]B-Bidoof[CR]!", spanish=" ¡[CS:N]Bidoof[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! I believe too!", french="Eh dis donc! Moi aussi, je les\ncrois!", german=" Hey, hey! Ich glaube ihnen auch!", italian=" Ehi, Ehi! Ci credo anch'io!", spanish=" ¡Oye, oye! ¡Yo también les creo!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_heigani, 4) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(4) [anim idle native]
  GROUND:EntTurn(partner, Direction.DownRight)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Me too! Oh my gosh![K] They're our\nguild colleagues, after all!", french="Moi aussi! Je les crois à fond![K]\nCe sont nos collègues de la Guilde, après tout!\nBen mince alors!", german="Ich auch! Auweia![K] Immerhin\nsind sie unsere Gildenkollegen!", italian="Anche io! Shock![K] Dopotutto,\nanche loro fanno parte della Gilda!", spanish="¡Y yo![K] Después de todo, ¡somos\nsupercamaradas del [CS:N]Pokégremio[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, [CS:N]Corphish[CR]![K] And [CS:N]Sunflora[CR]!", french="Oh, [CS:N]Ecrapince[CR]![K] Et [CS:N]Héliatronc[CR]\naussi!", german=" Oh, [CS:N]Krebscorps[CR]![K] Und [CS:N]Sonnflora[CR]!", italian=" Oh, [CS:N]Corphish[CR]![K] E [CS:N]Sunflora[CR]!", spanish=" ¡[CS:N]Corphish[CR]![K] ¡[CS:N]Sunflora[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, [CS:N]Corphish[CR]![K] And [CS:N]Sunflora[CR]!", french="Oh, [CS:N]Ecrapince[CR]![K] Et [CS:N]Héliatronc[CR]\naussi!", german=" Oh, [CS:N]Krebscorps[CR]![K] Und [CS:N]Sonnflora[CR]!", italian=" Oh, [CS:N]Corphish[CR]![K] E [CS:N]Sunflora[CR]!", spanish=" ¡[CS:N]Corphish[CR]![K] ¡[CS:N]Sunflora[CR]!"})
  else
  SkySceneKit.say({english=" Oh, [CS:N]Corphish[CR]![K] And [CS:N]Sunflora[CR]!", french="Oh, [CS:N]Ecrapince[CR]![K] Et [CS:N]Héliatronc[CR]\naussi!", german=" Oh, [CS:N]Krebscorps[CR]![K] Und [CS:N]Sonnflora[CR]!", italian=" Oh, [CS:N]Corphish[CR]![K] E [CS:N]Sunflora[CR]!", spanish=" ¡[CS:N]Corphish[CR]![K] ¡[CS:N]Sunflora[CR]!"})
  end
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kimawari, 4) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" I believe them!", french=" Je les crois!", german=" Ich glaube ihnen!", italian=" Io credo a quello che dicono!", spanish=" ¡Yo les creo!"})
  GROUND:EntTurn(partner, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_dogoomu, 4) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Me too!", french=" Moi aussi!", german=" Ich auch!", italian=" Pure io!", spanish=" ¡Yo también!"})
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diguda, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_diguda, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_diguda, 4) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" So do I!", french=" Et moi aussi!", german=" Und ich erst!", italian=" E anche io!", spanish=" ¡Y yo!"})
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Casting doubt on our colleagues\nis wrong! Trust is a must!", french="Ce n'est pas bien de douter ainsi\nde nos collègues! La confiance est une vertu\nprimordiale!", german="Es ist falsch, an unseren\nKollegen zu zweifeln! Wir bauen auf\nVertrauen!", italian="Nutrire dubbi sui nostri amici\nPokémon è sbagliato! Fidarsi è un dovere!", spanish="¡Dudar de nuestros camaradas\nestá mal! ¡La confianza es esencial!"})
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dagutorio, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_dagutorio, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_dagutorio, 4) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Squawk!", french=" Couac!", german=" Kreisch!", italian=" Squack!", spanish=" ¡Cruac!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urf...[K] Thank you, everyone...", french=" Snif...[K] Merci, tout le monde...", german=" Uff...[K] Danke, Leute...", italian=" Uh...[K] Grazie a tutti...", spanish=" Ay...[K] Muchas gracias a todos..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urf...[K] Thank you, everyone...", french=" Snif...[K] Merci, tout le monde...", german=" Uff...[K] Danke, Leute...", italian=" Uh...[K] Grazie a tutti...", spanish=" Ay...[K] Muchas gracias a todos..."})
  else
  SkySceneKit.say({english=" Urf...[K] Thank you, everyone...", french=" Snif...[K] Merci, tout le monde...", german=" Uff...[K] Danke, Leute...", italian=" Uh...[K] Grazie a tutti...", spanish=" Ay...[K] Muchas gracias a todos..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Thank you...[K]for believing us!", french=" Merci...[K] de nous croire!", german=" Danke,[K] dass ihr uns glaubt!", italian="Grazie...[K] per la fiducia che ci\ndimostrate!", spanish=" Gracias...[K] Gracias por creernos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Thank you...[K]for believing us!", french=" Merci...[K] de nous croire!", german=" Danke,[K] dass ihr uns glaubt!", italian="Grazie...[K] per la fiducia che ci\ndimostrate!", spanish=" Gracias...[K] Gracias por creernos."})
  else
  SkySceneKit.say({english=" Thank you...[K]for believing us!", french=" Merci...[K] de nous croire!", german=" Danke,[K] dass ihr uns glaubt!", italian="Grazie...[K] per la fiducia che ci\ndimostrate!", spanish=" Gracias...[K] Gracias por creernos."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(-8), p.Y+(0), false, 1) end
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Well, hiya!", french=" Amis un jour, amis toujours!", german=" So, hallöchen!", italian=" Bene, ullalà!", spanish=" Vaya, ¿qué hay?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_pukurin, 4) end)
  GROUND:EntTurn(partner, Direction.UpRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_pukurin, 4) end)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Sounds like we all agree! ♪", french="On dirait que nous sommes tous\nd'accord! ♪", german=" Dann sind wir uns einig! ♪", italian="Sembra che siamo tutti\nd'accordo! ♪", spanish="¡Parece que todos estamos de\nacuerdo! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HUH?!", french="[CS:N]Tous[CR]: HEIN?!", german="[CS:N]Alle[CR]: HUCH?!?", italian="[CS:N]Tutti[CR]: EH?!", spanish="[CS:N]Todos[CR]: ¿EH?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="We all believe our friends!\nThat's great! ♪", french="Nous sommes tous leurs amis,\net nous les croyons! C'est génial! ♪", german="Wir alle glauben unseren\nFreunden! Das ist super! ♪", italian="Crediamo tutti a quello che\ndicono! È grandioso! ♪", spanish="¡Todos creemos en nuestros\ncamaradas! ¡Genial! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Then let's begin searching for\nthe [CS:P]Hidden Land[CR]!", french="Mettons-nous à la recherche\ndes [CS:P]Terres Illusoires[CR]!", german="Dann lasst uns anfangen, nach\ndem [CS:P]Verborgenen Land[CR] zu suchen!", italian="Dunque cominciamo la ricerca\ndella [CS:P]Terra Nascosta[CR]!", spanish="Entonces, ¡hay que empezar a\nbuscar la [CS:P]Tierra Oculta[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Whoa! Just hold ON there,\nGuildmaster!", french="Ouah! Attendez une MINUTE,\nMaître!", german="Holla! Jetzt aber mal halblang,\nGildenmeister!", italian="Ehi! Solo un ATTIMO,\nCapitano!", spanish=" ¡Eh! ¡Un momento, Gran Bluff!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Hm? What's wrong?", french=" Hmm? Qu'est-ce qui se passe?", german=" Hm? Was stimmt nicht?", italian=" Eh? Cosa c'è che non va?", spanish=" ¿Eh? ¿Qué pasa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="We're not ALL in agreement yet,\nare we!", french="Nous ne sommes pas encore\nTOUS d'accord!", german="Wir sind uns nicht ALLE einig,\noder etwa doch?!?", italian="Non siamo ancora TUTTI\nd'accordo!", spanish="No todos estamos de acuerdo\naún, ¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Huh?", french=" Hein?", german=" Ähem?", italian=" Eh?", spanish=" ¿Eh?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" We're all good with the story...", french="On est tous d'accord sur\nla version de l'histoire...", german="Wir haben keine Probleme mit\nder Geschichte...", italian="Tutti noi crediamo alla loro\nstoria...", spanish=" Todos creemos la historia..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="But I suspect that [CS:N]Chatot[CR] isn't\nconvinced.", french="... mais je pense que [CS:N]Pijako[CR]\nn'est pas encore convaincu.", german="Aber vermutlich ist [CS:N]Plaudagei[CR]\nnicht überzeugt.", italian="Ma ho il sospetto che [CS:N]Chatot[CR]\nnon sia ancora convinto.", spanish="Pero me parece que [CS:N]Chatot[CR] aún\nno está muy convencido."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Oh? Is that all? ♪", french=" Oh? C'est tout? ♪", german=" Oh? Ist das alles? ♪", italian=" Oh? Tutto qui? ♪", spanish=" ¿Oh? ¿Eso es todo? ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You don't need to worry about\n[CS:N]Chatot[CR].", french="Ne vous inquiétez pas pour\n[CS:N]Pijako[CR].", german="Macht euch über [CS:N]Plaudagei[CR]\nkeine Gedanken.", italian="Non dovete preoccuparvi di\n[CS:N]Chatot[CR].", spanish="No tenéis que preocuparos por\n[CS:N]Chatot[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "question", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "question", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "question", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "question", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HUH?!", french="[CS:N]Tous[CR]: HEIN?!", german="[CS:N]Alle[CR]: WIE BITTE?!?", italian="[CS:N]Tutti[CR]: EH?!", spanish="[CS:N]Todos[CR]: ¿EH?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" [CS:N]Chatot[CR] is convinced...right?", french=" [CS:N]Pijako[CR] est convaincu... pas vrai?", german="[CS:N]Plaudagei[CR] ist überzeugt...\nRichtig?", italian=" [CS:N]Chatot[CR] è convinto... vero?", spanish="[CS:N]Chatot[CR] está convencido...\n¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HUH?!", french="[CS:N]Tous[CR]: HEIN?!", german="[CS:N]Alle[CR]: WIE BITTE?!?", italian="[CS:N]Tutti[CR]: EH?!", spanish="[CS:N]Todos[CR]: ¿EH?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Because [CS:N]Chatot[CR] believed\n[partner]'s story all along!", french="En fait, [CS:N]Pijako[CR] a tout de suite\ncru l'histoire de [partner]!", german="Weil [CS:N]Plaudagei[CR] die Geschichte\nvon [partner] von Anfang an geglaubt hat!", italian="Perché [CS:N]Chatot[CR] ha sempre\ncreduto alla storia di [partner]!", spanish="¡Porque [CS:N]Chatot[CR] ha creído la\nhistoria de [partner] desde el principio!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Right, [CS:N]Chatot[CR]? ♪", french=" Pas vrai, [CS:N]Pijako[CR]? ♪", german=" Richtig, [CS:N]Plaudagei[CR]? ♪", italian=" Vero, [CS:N]Chatot[CR]? ♪", spanish=" ¿No es así, [CS:N]Chatot[CR]? ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Hee...![K] Hee-hee...!", french=" Hi...![K] Hi hi...!", german=" Hi![K] Hihi!", italian=" Eeh...![K] Eeh-eeh...!", spanish=" ¡Ji![K] ¡Ji, ji, ji!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Hee-heeee!", french=" Hi hiii!", german=" Hihihi!", italian=" Eeh-eeeh!", spanish=" ¡Ji, ji, ji!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" WH-WHAT?", french=" QUOI?", german=" W-WAS?", italian=" C-COSA?", spanish=" ¡¿QUÉ?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" How peculiar!", french=" J'hallucine!", german=" Wie seltsam!", italian=" Che strano!", spanish=" ¡Jo, qué curioso!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Well, Guildmaster, there's no\nfooling you.[K] I admit it.", french="Eh bien, Maître, impossible\nde vous duper.[K] Je l'admets.", german="Nun, Gildenmeister, dich kann\nman einfach nicht täuschen.[K] Ich gebe es zu.", italian="Beh, Capitano, è impossibile\nprenderla in giro.[K] Lo ammetto.", spanish="Vaya, Gran Bluff...\nNo hay quien te engañe.[K] Lo admito."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Yes, I believed [hero] and\n[partner] right from the start.", french="En effet, j'ai tout de suite cru\nà l'histoire de [hero] et [partner].", german="Ja, ich habe [hero] und\n[partner] ihre Geschichte von Anfang an\ngeglaubt.", italian="Sì, ho creduto alla storia di\n[hero] e [partner] fin dall'inizio.", spanish="Sí, creí a [hero] y a\n[partner] desde el principio."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HUH? REALLY?!", french="[CS:N]Tous[CR]: HEIN? VRAIMENT?!", german="[CS:N]Alle[CR]: WAS?!? WIRKLICH?!?", italian="[CS:N]Tutti[CR]: EH? DAVVERO?!", spanish="[CS:N]Todos[CR]: ¿EN SERIO?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But if I would have said that I\nbelieved them right away...", french="Mais si je l'avais dit dès\nle départ...", german="Aber wenn ich sofort gesagt\nhätte, dass ich ihnen glaube...", italian="Ma se avessi detto che credevo\na quel che dicevano fin da subito...", spanish="Pero si hubiera dicho que les\ncreía desde el principio..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Everyone would have just gone\nalong with what I said.", french=" ... tout le monde m'aurait imité.", german="Dann wären mir einfach alle\ngefolgt.", italian="... sarebbero stati tutti d'accordo\ncon me.", spanish="Todo el mundo hubiera aceptado\nmi opinión sin rechistar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" ...What's all this...?", french=" ... Qu'est-ce que ça veut dire...?", german=" Was soll das alles?", italian=" Cosa significa...?", spanish=" ¿Qué quieres decir?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" That's why I was so contrary!", french="C'est pourquoi j'ai dit le\ncontraire!", german="Darum habe ich dagegen\nargumentiert!", italian="È per questo che facevo finta\ndi avere dei dubbi.", spanish=" Por eso me opuse tanto."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I wanted to put your friendship\nto the test!", french=" Pour tester votre amitié!", german="Ich wollte eure Freundschaft\nauf die Probe stellen!", italian="Volevo mettere alla prova la\nvostra amicizia!", spanish="¡Quería poner a prueba vuestra\namistad!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" ...Gosh, likely story...", french="... Mouais, c'est ça, on y croit\nvachement...", german=" Meine Güte, ganz bestimmt...", italian=" Ohibò, potrebbe essere...", spanish=" Ya, claro... Muy lógico..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But without a doubt, I was\nconvinced from the get-go!", french="Mais bien entendu, j'étais\nconvaincu dès le début!", german="Aber ohne Zweifel war ich von\nder ersten Minute an überzeugt!", italian="Ma senza alcun dubbio ero\nconvinto che dicessero il vero!", spanish="Pero, en realidad, ¡yo estuve\nconvencido todo el tiempo!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I knew everyone...[K]would surely\nbelieve their colleagues! ♪", french="Et je savais bien que...[K] vous\nauriez tous confiance en vos collègues! ♪", german="Ich wusste,[K] dass sicher alle\nihren Kollegen glauben würden! ♪", italian="È ovvio che tutti...[K]\ncrederebbero alle parole dei propri\namici Pokémon! ♪", spanish="Sabía que todos...[K]\n¡sin duda creerían a sus camaradas! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" ...Says you...", french=" ... Oh, l'autre, eh...", german=" ...Sagst du...", italian=" Se lo dici tu...", spanish=" Eso lo dices ahora..."})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Hee![K] Hee-heeee!", french=" Hi![K] Hi hiii!", german=" Hihi![K] Hihihi!", italian=" Eeh![K] Eeh-eeeeh!", spanish=" ¡Ji![K] ¡Ji, ji, ji!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(30)
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(-24), p.Y+(0), false, 1) end
  GAME:WaitFrames(10)
  do local p=npc_npc_heigani.Position; GROUND:MoveToPosition(npc_npc_heigani, p.X+(16), p.Y+(0), false, 2) end
  GROUND:EntTurn(npc_npc_heigani, Direction.Left)
  GROUND:MoveToPosition(npc_npc_pukurin, 348, 216, false, 1)
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_pukurin, 4) end)
  -- message_FacePositionOffset(1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" [hero]![K] [partner]!", french=" [hero]![K] [partner]!", german=" [hero]![K] [partner]!", italian=" [hero]![K] [partner]!", spanish=" ¡[hero]![K] ¡[partner]!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I believe you![K] You're my good\nfriends in guild membership! ♪", french="Je vous crois![K] Nous sommes\ntous unis par les liens de la Guilde! ♪", german="Ich glaube euch![K] Ihr seid meine\nguten Freunde und Gildenkollegen! ♪", italian="Io vi credo![K] Siete parte della\nGilda! ♪", spanish="¡Yo también os creo![K]\n¡Los miembros del [CS:N]Pokégremio[CR]\nnunca mienten! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Now listen, everyone!", french=" Bon écoutez-moi, tout le monde!", german=" Jetzt hört mal zu, Leute!", italian=" Ora ascoltate, tutti!", spanish=" Ahora, ¡escuchadme todos!"})
  -- message_FacePositionOffset(1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Time is stopping in more and\nmore places.", french="Le temps s'arrête un peu\npartout.", german="Die Zeit bleibt an immer mehr\nOrten stehen.", italian="Il tempo si sta fermando in\nsempre più luoghi.", spanish="El tiempo se está deteniendo\nen cada vez más sitios."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" From [partner]'s story...", french="D'après l'histoire de\n[partner]...", german="Wenn ich die Geschichte von\n[partner] richtig verstanden habe...", italian=" A quanto dice [partner]...", spanish="Según lo que ha dicho\n[partner]..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" We know our world is in danger.", french="... nous savons tous que\nnotre monde est en danger.", german=" Dann ist unsere Welt in Gefahr.", italian="... sappiamo che il nostro mondo\nè in pericolo.", spanish="Sabemos que nuestro mundo\ncorre un serio peligro."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="That means we have to do\nsomething! ♪", french="Nous devons absolument faire\nquelque chose! ♪", german="Das bedeutet, wir müssen\nhandeln! ♪", italian="Questo significa che dobbiamo\nfare qualcosa! ♪", spanish="¡Así que tenemos que hacer\nalgo! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" This is our time.", french=" Il est temps d'agir.", german=" Unsere Zeit ist gekommen.", italian=" Ora tocca a noi.", spanish=" Es nuestro turno."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="In the name of [CS:N]Wigglytuff[CR]'s\nGuild...", french="Au nom de la Guilde de\n[CS:N]Grodoudou[CR]...", german="Im Namen der [CS:N]Knuddeluff-Gilde[CR]...", italian="In nome della Gilda di\n[CS:N]Wigglytuff[CR]...", spanish=" En nombre del [CS:N]Pokégremio[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" We'll combine all our efforts!", french=" Unissons nos forces!", german="Wir werden unsere Kräfte\nvereinen!", italian=" Ce la metteremo tutta!", spanish=" ¡Aunaremos nuestros esfuerzos!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" We'll discover the [CS:P]Hidden Land[CR]!", french="Et trouvons les\n[CS:P]Terres Illusoires[CR]!", german="Wir werden das\n[CS:P]Verborgene Land[CR] entdecken!", italian=" Troveremo la [CS:P]Terra Nascosta[CR]!", spanish=" ¡Descubriremos la [CS:P]Tierra Oculta[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Let's do this, everyone!", french=" C'est parti, tout le monde!", german=" Das machen wir, Leute!", italian=" Ce la dobbiamo fare, gente!", spanish="¡Vamos a conseguirlo todos\njuntos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "happy", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: URRÀ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, nil, 0) end) -- EFFECT_NONE
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" [CS:N]Chatot[CR]!", french=" [CS:N]Pijako[CR]!", german=" [CS:N]Plaudagei[CR]!", italian=" [CS:N]Chatot[CR]!", spanish=" ¡[CS:N]Chatot[CR]!"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Y-yes, sir.", french=" Oui, Maître.", german=" J-jawohl!", italian=" S-Sì, signore.", spanish=" Sí, Gran Bluff..."})
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, hero, 4) end)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" OK, everyone!", french=" Allez, tout le monde!", german=" Okay, Leute!", italian=" Ok, tutti quanti!", spanish=" Muy bien, ¡escuchadme!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="From now on, we're shifting all\nour efforts to locating the [CS:P]Hidden Land[CR]!", french="A partir de maintenant, nous\nconsacrerons tous nos efforts à localiser\nles [CS:P]Terres Illusoires[CR]!", german="Ab sofort widmen wir unsere\nArbeit der Entdeckung des [CS:P]Verborgenen Landes[CR]!", italian="D'ora in avanti concentreremo\ntutti i nostri sforzi sulla ricerca della [CS:P]Terra[CR]\n[CS:P]Nascosta[CR]!", spanish="Desde ahora vamos a centrar\ntodos nuestros esfuerzos en la búsqueda de\nla [CS:P]Tierra Oculta[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We also have to let everyone\nknow what is happening in our world.", french="Il faut aussi mettre tout\nle monde au courant de ce qui se passe ici.", german="Wir müssen außerdem alle\nwissen lassen, was in unserer Welt geschieht.", italian="In più dobbiamo far sapere a\ntutti quello che sta succedendo nel nostro\nmondo.", spanish="También tenemos que informar\na todos de lo que está sucediendo en nuestro\nmundo."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It's going to get busy. We'll all\nhave to work hard!", french="Nous avons du pain sur\nla planche. Il faut travailler dur!", german="Es wird hektisch.\nWir müssen alle hart arbeiten!", italian="Dobbiamo fare un sacco di cose.\nDovremo tutti lavorare sodo!", spanish="Va a haber mucho que hacer.\n¡Debemos hacer todos un gran esfuerzo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" I sure will!", french=" Vous pouvez compter sur moi!", german=" Ich werde das ganz sicher!", italian=" Sono pronto!", spanish=" ¡Yo pienso hacerlo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I'll putter down to Treasure\nTown!", french=" J'vais à Bourg-Trésor illico!", german="Ich schau mal in Schatzstadt\nvorbei!", italian="Io mi dirigerò verso Borgo\nTesoro!", spanish="¡Yo saldré disparado a Aldea\nTesoro!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" I'll get the word out, by golly!", french="Histoire d'propager la nouvelle,\npardi!", german="Ich werde die Neuigkeiten\nüberall verbreiten, Donnerwetter!", italian=" Diffonderò la voce, ohibò!", spanish="¡Se lo diré a todo el mundo!\n¡Sí, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_bippa, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" I'll go too!", french=" Je t'accompagne!", german=" Ich gehe auch!", italian=" Io vado con lui!", spanish=" ¡Yo también iré!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="We have to let [CS:N]Azelf[CR] and his\nfriends know too!", french="Il faut aussi mettre [CS:N]Créfadet[CR]\net ses amis au courant!", german="Wir müssen [CS:N]Tobutz[CR] und seine\nFreunde informieren.", italian="Dobbiamo farlo sapere anche ad\n[CS:N]Azelf[CR] e ai suoi amici!", spanish="También tenemos que informar\na [CS:N]Azelf[CR] y los demás."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="If they're back at their lakes,\nthey may try to stop [CS:N]Grovyle[CR]!", french="S'ils sont retournés à leurs\nlacs respectifs, ils risquent d'essayer\nd'arrêter [CS:N]Massko[CR]!", german="Falls sie wieder zurück an ihren\nSeen sind, könnten sie versuchen, [CS:N]Reptain[CR]\naufzuhalten!", italian="Se sono tornati ai loro\nlaghi, proveranno di sicuro a fermare\n[CS:N]Grovyle[CR]!", spanish="Si ya han regresado a sus lagos,\n¡puede que intenten detener a [CS:N]Grovyle[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_diguda, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! Then I'll go tell them!", french="Eh dis donc, je vais aller leur\ndire!", german="Hey, hey! Dann werde ich es\nihnen erzählen!", italian=" Ehi, ehi! Allora andrò a dirglielo!", spanish="¡Oye, oye!\n¡Entonces yo iré a avisarles!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="OK. Everyone else, search for\nthe [CS:P]Hidden Land[CR], please.", french="D'accord. Les autres, cherchez\nles [CS:P]Terres Illusoires[CR].", german="Okay. Ihr anderen sucht bitte\nnach dem [CS:P]Verborgenen Land[CR].", italian="Ok. Tutti gli altri, per favore,\nvadano alla ricerca della [CS:P]Terra Nascosta[CR].", spanish="Muy bien. Os ruego a todos los\ndemás que busquéis la [CS:P]Tierra Oculta[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" YEAH!", french=" OUAIS!", german=" JAAA!", italian=" Sì!", spanish=" ¡SÍ!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Bidoof[CR], [CS:N]Sunflora[CR], and others,\nonce your errands are done, gather information\non the [CS:P]Hidden Land[CR].", french="[CS:N]Keunotor[CR], [CS:N]Héliatronc[CR]\net les autres, une fois ces tâches terminées,\ncherchez des indices sur les [CS:P]Terres Illusoires[CR].", german="[CS:N]Bidiza[CR], [CS:N]Sonnflora[CR] und ihr\nanderen! Wenn ihr fertig seid, dann sammelt\nbitte Informationen zum [CS:P]Verborgenen Land[CR].", italian="[CS:N]Bidoof[CR], [CS:N]Sunflora[CR] e gli altri,\nuna volta fatto quello che dovete, raccogliete\ninformazioni sulla [CS:P]Terra Nascosta[CR].", spanish="[CS:N]Bidoof[CR], [CS:N]Sunflora[CR] y los demás,\nen cuanto acabéis lo que tenéis entre manos\nbuscad información sobre la [CS:P]Tierra Oculta[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Yes, sir!", french=" A vos ordres, m'sieur!", german=" Ja, natürlich!", italian=" Sì, signore!", spanish=" ¡Sí, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" We'll hurry!", french=" On fera vite!", german=" Wir beeilen uns!", italian=" Faremo il più in fretta possibile!", spanish=" ¡Enseguida!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="We'll find the [CS:P]Hidden Land[CR]\ntogether!", french="Tous ensemble, on trouvera\nles [CS:P]Terres Illusoires[CR]!", german="Wir werden das [CS:P]Verborgene Land[CR]\nzusammen finden!", italian="Insieme troveremo la [CS:P]Terra[CR]\n[CS:P]Nascosta[CR]!", spanish="¡Encontraremos juntos\nla [CS:P]Tierra Oculta[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" YOOM...TAH!", french=" TA-DAAA!", german=" LUUU... FIII!", italian=" BADABUM!", spanish=" ¡GENIAL!"})
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "happy", 1) end)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_heigani, Direction.Down)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  -- SetAnimation(24) [anim idle native]
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Down)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: URRÀ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(npc_npc_heigani, Direction.Left)
  GROUND:EntTurn(npc_npc_diguda, Direction.Left)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(hero, Direction.UpLeft)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" All right! Let's show some guts!", french="Très bien! Faisons preuve\nde courage!", german="Alles klar! Zeigen wir, dass wir\nMumm in den Knochen haben!", italian="Va bene! Mostriamo un po' di\ncoraggio!", spanish="¡Muy bien! ¡Vamos a demostrar\nde lo que somos capaces!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey, hey!", french=" Eh dis donc!", german=" Hey, hey, hey!", italian=" Ehi, ehi, ehi!", spanish=" ¡Oye, oye, oye!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Right)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Left)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpRight)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_heigani, Direction.Down)
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpRight)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(4), false, 1) end
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_pukurin, 4) end)
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I'm sorry that I don't have any\ninformation on the [CS:P]Hidden Land[CR]...", french="Désolé, mais je ne sais rien\nà propos des [CS:P]Terres Illusoires[CR]...", german="Es tut mir leid, dass ich keine\nInformationen zum [CS:P]Verborgenen Land[CR] habe...", italian="Mi spiace di non avere alcuna\ninformazione sulla [CS:P]Terra Nascosta[CR]...", spanish="Siento no tener información\nsobre la [CS:P]Tierra Oculta[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="But maybe...[K]the wise [CS:N]Torkoal[CR],\nthe town elder, may know something.", french="Mais...[K] peut-être que\nle vénérable [CS:N]Chartor[CR], l'ancien du bourg,\nsaura quelque chose, lui.", german="Aber vielleicht weiß[K] der weise\n[CS:N]Qurtel[CR], der Dorfälteste, etwas.", italian="Ma forse...[K] il saggio [CS:N]Torkoal[CR],\nl'anziano della città, potrebbe saperne qualcosa.", spanish="Pero quizás...[K]\nEl sabio [CS:N]Torkoal[CR], el anciano de la aldea, podría\nsaber algo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Torkoal[CR], the town elder?", french=" [CS:N]Chartor[CR], l'ancien du bourg?", german=" [CS:N]Qurtel[CR], der Dorfälteste?", italian=" [CS:N]Torkoal[CR], l'anziano della città?", spanish=" ¿[CS:N]Torkoal[CR], el anciano de la aldea?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Torkoal[CR], the town elder?", french=" [CS:N]Chartor[CR], l'ancien du bourg?", german=" [CS:N]Qurtel[CR], der Dorfälteste?", italian=" [CS:N]Torkoal[CR], l'anziano della città?", spanish=" ¿[CS:N]Torkoal[CR], el anciano de la aldea?"})
  else
  SkySceneKit.say({english=" [CS:N]Torkoal[CR], the town elder?", french=" [CS:N]Chartor[CR], l'ancien du bourg?", german=" [CS:N]Qurtel[CR], der Dorfälteste?", italian=" [CS:N]Torkoal[CR], l'anziano della città?", spanish=" ¿[CS:N]Torkoal[CR], el anciano de la aldea?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="That would be the wisest and\noldest Pokémon of Treasure Town.", french="C'est le Pokémon le plus sage\net le plus vieux de Bourg-Trésor.", german="Das ist das älteste und\nweiseste Pokémon von Schatzstadt.", italian="È il più saggio e il più vecchio\ndi tutti i Pokémon di Borgo Tesoro.", spanish="Se trata del Pokémon más\nanciano y sabio de Aldea Tesoro."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="He loves the Hot Spring, so he's\nalways there.", french="Il adore la Source Chaude,\net y passe beaucoup de temps.", german="Er liebt die Heiße Quelle,\ndeswegen hält er sich immer dort auf.", italian="Ama la Sorgente Termale, quindi\nè sempre là.", spanish="Le encanta la Terma, así que se\npasa el día allí."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="In fact, I'm positive that you'll\nfind him at the Hot Spring! ♪", french="En fait, je suis prêt à parier\nque vous le trouverez à la Source Chaude! ♪", german="Ich bin sogar ziemlich\nzuversichtlich, dass ihr ihn bei der\nHeißen Quelle finden werdet! ♪", italian="Infatti, sono convinto che lo\ntroverete alla Sorgente Termale! ♪", spanish="De hecho, ¡estoy segurísimo de\nque estará allí ahora! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh![K] I remember!", french=" Oh![K] Je me souviens!", german=" Oh![K] Ich erinnere mich!", italian=" Ah![K] Mi ricordo!", spanish=" ¡Oh![K] ¡Ya lo recuerdo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh![K] I remember!", french=" Oh![K] Je me souviens!", german=" Oh![K] Ich erinnere mich!", italian=" Ah![K] Mi ricordo!", spanish=" ¡Oh![K] ¡Ya lo recuerdo!"})
  else
  SkySceneKit.say({english=" Oh![K] I remember!", french=" Oh![K] Je me souviens!", german=" Oh![K] Ich erinnere mich!", italian=" Ah![K] Mi ricordo!", spanish=" ¡Ah![K] ¡Ya me acuerdo de él!"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
