-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P01A/n04a0105.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_PLAYER_KIMAWARI
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(5) -- Lock(5) NDS
    GROUND:MoveToPosition(hero, 220, 244, false, 2)
    SkySceneKit.unlock(3) -- Unlock(3) NDS
    GROUND:MoveToPosition(hero, 220, 204, false, 2)
    SkySceneKit.lock(6) -- Lock(6) NDS
    GROUND:EntTurn(hero, Direction.DownRight)
    SkySceneKit.lock(7) -- Lock(7) NDS
    GROUND:EntTurn(hero, Direction.Right)
    SkySceneKit.lock(8) -- Lock(8) NDS
    GROUND:EntTurn(hero, Direction.DownRight)
    SkySceneKit.lock(9) -- Lock(9) NDS
    GROUND:EntTurn(hero, Direction.Down)
    GAME:WaitFrames(32)
    pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
    -- CallCommon CORO_JUMP_ANGRY_FUNC (fermeture/attente message: géré par say())
    SkySceneKit.lock(10) -- Lock(10) NDS
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 2 for actor ACTOR_NPC_HEIGANI
    local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 240, 152, Direction.Down, "NPC_HEIGANI")
    -- SetAnimation(2) [anim idle native]
    GROUND:MoveToPosition(npc_npc_heigani, 240, 220, false, 2)
    GROUND:EntTurn(npc_npc_heigani, Direction.UpLeft)
    pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
    GAME:WaitFrames(45)
    pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
    GAME:WaitFrames(15)
    GROUND:MoveToPosition(npc_npc_heigani, 240, 372, false, 2)
    -- Destroy() [neutre/état moteur]
  end)
  SkySceneKit.run_routine(function() -- def 3 for actor ACTOR_NPC_CHIRIIN
    local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 240, 152, Direction.Down, "NPC_CHIRIIN")
    -- SetAnimation(2) [anim idle native]
    GROUND:MoveToPosition(npc_npc_chiriin, 240, 204, false, 2)
    GROUND:EntTurn(npc_npc_chiriin, Direction.Left)
    SkySceneKit.unlock(7) -- Unlock(7) NDS
    pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
    GAME:WaitFrames(30)
    pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
    GAME:WaitFrames(15)
    GROUND:MoveToPosition(npc_npc_chiriin, 240, 372, false, 2)
    -- Destroy() [neutre/état moteur]
  end)
  SkySceneKit.run_routine(function() -- def 4 for actor ACTOR_NPC_BIPPA
    local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 240, 152, Direction.Down, "NPC_BIPPA")
    -- SetAnimation(2) [anim idle native]
    GROUND:MoveToPosition(npc_npc_bippa, 240, 180, false, 2)
    GROUND:EntTurn(npc_npc_bippa, Direction.DownLeft)
    GAME:WaitFrames(45)
    GROUND:MoveToPosition(npc_npc_bippa, 240, 220, false, 2)
    SkySceneKit.unlock(8) -- Unlock(8) NDS
    GROUND:EntTurn(npc_npc_bippa, Direction.UpLeft)
    GAME:WaitFrames(15)
    -- CallCommon CORO_JUMP_ANGRY_FUNC (fermeture/attente message: géré par say())
    GAME:WaitFrames(15)
    SkySceneKit.unlock(9) -- Unlock(9) NDS
    GROUND:MoveToPosition(npc_npc_bippa, 240, 372, false, 2)
    -- Destroy() [neutre/état moteur]
  end)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- back_SetGround(LEVEL_G01P01A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitLockLives
  GAME:FadeIn(30)
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(20)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(6) -- Unlock(6) NDS
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(20)
  -- supervision_Acting(3) [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Also, I really like the other\n[CN]apprentices in the guild!", french="[CN]En plus, j'aime trop les autres\n[CN]apprentis de la Guilde!", german="[CN]Ich mag die anderen\n[CN]Gildenlehrlinge wirklich sehr!", italian="[CN]E poi mi trovo davvero bene con tutti\n[CN]gli altri apprendisti della Gilda!", spanish="[CN]¡Por cierto, me caen superbién los demás\n[CN]aprendices del [CS:N]Pokégremio[CR]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]I enjoy being with them!", french="[CN]Je m'éclate trop avec eux!", german="[CN]Es macht Spaß, gemeinsam Zeit zu verbringen!", italian="[CN]Mi piace stare con loro!", spanish="[CN]¡Me encanta estar con ellos!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Everyone is such a dear friend to me!", french="[CN]Ce sont tous de super amis!", german="[CN]Alle hier sind sehr freundlich zu mir!", italian="[CN]Sono tutti dei cari amici!", spanish="[CN]¡Todos ellos son superamigos míos!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Anyhow, being able to train at this guild...", french="[CN]Bref, de pouvoir m'entraîner\n[CN]dans cette Guilde...", german="[CN]Dass ich in dieser Gilde trainieren darf...", italian="[CN]Insomma, potermi allenare in questa Gilda...", spanish="[CN]En fin, poder entrenar en el [CS:N]Pokégremio[CR]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Makes me very happy!", french="[CN]... ça me rend trop contente!", german="[CN]Das macht mich unbeschreiblich glücklich!", italian="[CN]... mi rende immensamente felice!", spanish="[CN]¡Me hace muy feliz!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]But...[K]\n[CN]About my friends...", french="[CN]Mais...[K]\n[CN]au sujet de mes amis...", german="[CN]Aber...[K]\n[CN]In Bezug auf meine Freunde...", italian="[CN]Eppure...[K]\n[CN]Parlando dei miei amici...", spanish="[CN]Pero...[K]\n[CN]Por lo que respecta a mis amigos..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Recently, something troublesome happened...", french="[CN]Dernièrement, quelque chose de fâcheux\n[CN]est arrivé...", german="[CN]Da gibt es etwas Besorgniserregendes\n[CN]zu berichten...", italian="[CN]Poco tempo fa è accaduto\n[CN]qualcosa di spiacevole...", spanish="[CN]Hace poco pasó algo que me molestó..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  -- supervision_Acting(4) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 240, 152, Direction.Down, "NPC_DOGOOMU")
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(0), p.Y+(12), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" ...HUMPH!", french=" ... HUMPH!", german=" ...HMPF!", italian=" ... UMPF!", spanish=" ¡Ejem!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-4), p.Y+(4), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...!! ([CS:N]L[CR]-[CS:N]Loudred[CR]!)", french=" ...!! ([CS:N]R[CR]-[CS:N]Ramboum[CR]!)", german=" ...([CS:N]K-Krakeelo[CR]!)", italian=" ...!!! ([CS:N]L-Loudred[CR]!)", spanish=" ¡Ah!... ([CS:N]Lo[CR]... [CS:N]Loudred[CR])"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Hm! HUMPH!", french=" Mmh! HUMPH!", german=" Hm! HMPF!!!", italian=" Mh! BAH!", spanish=" ¡Mm! ¡Jum!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Humph!", french=" Humph!", german=" Hmpf!", italian=" Ummmpf!", spanish=" ¡Jum!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(npc_npc_dogoomu, 240, 372, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Here is what's troublesome.", french="[CN]Voilà le problème.", german="[CN]Kommen wir zu dem, was mir Sorgen bereitet.", italian="[CN]Questo è il problema.", spanish="[CN]Esto es lo que no me gustó un pelo."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]I haven't been getting along with\n[CN][CS:N]Loudred[CR] too well lately...", french="[CN]Je ne m'entends pas bien avec\n[CN][CS:N]Ramboum[CR] ces derniers temps...", german="[CN]Ich bin in der letzten Zeit nicht sonderlich\n[CN]gut mit [CS:N]Krakeelo[CR] ausgekommen...", italian="[CN]Ultimamente non vado molto d'accordo\n[CN]con [CS:N]Loudred[CR]...", spanish="[CN]Últimamente no me llevo\n[CN]demasiado bien con [CS:N]Loudred[CR]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]And I've even gone on explorations\n[CN]with [CS:N]Loudred[CR] in the past...", french="[CN]Le souci, c'est que je suis partie quelques fois\n[CN]en exploration avec [CS:N]Ramboum[CR] par le passé...", german="[CN]Gemeinsamen Erkundungen mit [CS:N]Krakeelo[CR] bin\n[CN]ich sogar ferngeblieben...", italian="[CN]In passato, ho partecipato a\n[CN]un'esplorazione insieme a lui...", spanish="[CN]He ido algunas veces de exploración\n[CN]con [CS:N]Loudred[CR]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]At the time, [CS:N]Loudred[CR] wouldn't listen to my\n[CN]warnings and ran straight into dungeons...", french="[CN]A l'époque, [CS:N]Ramboum[CR] refusait d'écouter\n[CN]mes avertissements et fonçait tête baissée\n[CN]dans les donjons...", german="[CN][CS:N]Krakeelo[CR] ist einmal trotz meiner Warnungen\n[CN]blind in einen Dungeon hineingerannt...", italian="[CN]In quell'occasione, [CS:N]Loudred[CR] non ha voluto\n[CN]prestare ascolto ai miei consigli e si è\n[CN]lanciato nei dungeon senza riflettere...", spanish="[CN]Pero [CS:N]Loudred[CR] no hacía ni caso de\n[CN]mis advertencias y entraba a toda prisa\n[CN]en los territorios..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]And we were knocked out, just like that!", french="[CN]Et du coup, on finissait toujours par\n[CN]tomber K.O., pouf, comme ça!", german="[CN]Woraufhin wir beide K.O. gegangen sind!", italian="[CN]Così, senza neanche accorgercene,\n[CN]siamo stati sbattuti fuori!", spanish="[CN]Y claro, ¡así no llegábamos muy lejos!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]When I came to, I realized both of us\n[CN]had fainted!", french="[CN]En reprenant mes esprits, je réalisais que\n[CN]nous nous étions tous les deux évanouis!", german="[CN]Als ich zu mir kam, wurde mir klar, dass wir\n[CN]beide das Bewusstsein verloren hatten!", italian="[CN]Quando mi sono ripresa, ho capito\n[CN]che eravamo finiti entrambi KO!", spanish="[CN]Cuando volvía en mí, ¡veía que los dos\n[CN]nos habíamos debilitado!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]I couldn't believe it!", french="[CN]Je ne pouvais pas en croire mes pétales!", german="[CN]Trotz meiner Warnungen! Unglaublich!!!", italian="[CN]Non riuscivo a crederci!", spanish="[CN]¡Qué fuerte! ¡No me lo podía creer!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Since then, [CS:N]Loudred[CR] and I have not been\n[CN]able to see eye-to-eye.", french="[CN]Depuis, [CS:N]Ramboum[CR] et moi,\n[CN]on a un peu de mal à s'entendre.", german="[CN]Seit jenem Tag haben [CS:N]Krakeelo[CR] und ich\n[CN]uns nicht in die Augen blicken können.", italian="[CN]Da allora, [CS:N]Loudred[CR] e io non\n[CN]ci siamo più rivolti la parola.", spanish="[CN]Desde entonces, [CS:N]Loudred[CR] y yo no nos\n[CN]llevamos demasiado bien."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" It's...[K]a little troublesome...", french=" C'est...[K] c'est un peu fâcheux...", german=" Das...[K] macht mir Sorgen...", italian=" È...[K] un po' spiacevole...", spanish=" Me da...[K] algo de penita..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...![K] But--", french=" ...![K] Mais...", german=" ...[K]Aber...", italian=" ...![K] Però...", spanish=" ¡Jum![K] Pero es que..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" It's all [CS:N]Loudred[CR]'s fault!", french="Tout ça, c'est la faute\nde [CS:N]Ramboum[CR]!", german=" Es ist alles seine Schuld!", italian=" È tutta colpa di [CS:N]Loudred[CR]!", spanish=" ¡Es todo por culpa de [CS:N]Loudred[CR]!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="After his terrible behavior,\n[CS:N]Loudred[CR] hasn't even apologized!", french="Il a fait n'importe quoi,\nce [CS:N]Ramboum[CR], et il ne s'est\njamais excusé!", german="Nach diesem üblen Fehlverhalten\nhat sich [CS:N]Krakeelo[CR] nicht einmal entschuldigt!", italian="Dopo essersi comportato in quel\nmodo, non mi ha nemmeno chiesto scusa!", spanish="Con lo mal que se ha portado,\n¡y [CS:N]Loudred[CR] ni se ha disculpado!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I won't forgive that![K] Humph!", french="Je ne laisserai pas passer ça![K]\nEt toc!", german="Das ist einfach unverzeihlich![K]\nHmpf!", italian="Non posso perdonargliela![K]\nUmmmpf!", spanish="¡Eso no lo perdono![K] ¡Qué se\nhabrá creído!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "angry", 1) end)
  GAME:WaitFrames(45)
  pcall(function() SOUND:FadeOutBGM(150) end)
  -- supervision_Acting(5) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 240, 152, Direction.Down, "NPC_PERAPPU")
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- bgm2_PlayFadeIn(BGM_OCEAN2) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Oh![K] You're here, [CS:Y]Sunflora[CR]!", french=" Oh![K] Tu es là, [CS:Y]Héliatronc[CR]!", german=" Oh![K] Da bist du ja, [CS:Y]Sonnflora[CR]!", italian=" Oh![K] Eccoti qui, [CS:Y]Sunflora[CR]!", spanish=" ¡Anda![K] Si estás aquí, [CS:Y]Sunflora[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oh hi, [CS:N]Chatot[CR].", french=" Oh bonjour, [CS:N]Pijako[CR].", german=" Oh hallo, [CS:N]Plaudagei[CR].", italian=" Oh, ciao, [CS:N]Chatot[CR].", spanish=" Ah, hola, [CS:N]Chatot[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I've been looking for you.[K]\nThere's something I'd like to discuss with you.", french="Je te cherchais.[K]\nJ'aimerais discuter d'une chose avec toi.", german="Ich habe nach dir gesucht.[K]\nEs gibt da etwas, das ich mit dir\nbesprechen möchte.", italian="Ti stavo cercando.[K]\nC'è qualcosa di cui ti vorrei parlare.", spanish="Te andaba buscando.[K]\nQuiero hablar de algo contigo."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Please come with me.", french=" Suis-moi, s'il te plaît.", german=" Komm bitte mit.", italian=" Vieni con me, per favore.", spanish=" Acompáñame, por favor."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(-16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Discuss?", french=" Discuter?", german=" Besprechen?", italian=" Parlare?", spanish=" ¿Me habré metido en algún lío?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Gosh![K] I wonder what it could\nbe...", french="Ben mince alors![K] De quoi veut-il\nbien me parler...?", german=" Auweia![K] Was das wohl bedeutet?", italian=" Shock![K] Di che cosa si tratterà?", spanish="¡Qué mal![K] Jo, a saber de qué\nquerrá hablar conmigo..."})
  -- message_Close
  GROUND:MoveToPosition(hero, 240, 148, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitBgm2
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
