-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P06B/m08a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_NPC_PUKURIN
    local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 368, 232, Direction.UpLeft, "NPC_PUKURIN")
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(5) -- Lock(5) NDS
    GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
    SkySceneKit.lock(6) -- Lock(6) NDS
    -- SetAnimation(5) [anim idle native]
    -- GAP: SetEffect EFFECT_APPLE_ON_HEAD — VFX sans émote PMDO équivalente
    -- @label_0 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    GROUND:EntTurn(npc_npc_pukurin, Direction.Up)
    GAME:WaitFrames(20)
    GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
    GAME:WaitFrames(20)
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(5123) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 320, 184, Direction.DownRight, "NPC_CHIRIIN")
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Everyone! It's time for\ndinner! ♪", french="A table, tout le monde! C'est\nl'heure du dîner! ♪", german="Kommt alle! Das Abendessen ist\nfertig! ♪", italian=" Ehi, gente! È ora di cena! ♪", spanish=" ¡Todos! ¡A cenar! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: Yeah!", french="[CS:N]Tous[CR]: Ouais!", german="[CS:N]Alle[CR]: Jaaa!", italian="[CS:N]Tutti[CR]: Evviva!", spanish="[CS:N]Todos[CR]: ¡BIEEEN!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: Let's get...", french="[CS:N]Tous[CR]: A LA...", german="[CS:N]Alle[CR]: Lasst uns...", italian="[CS:N]Tutti[CR]: Forza, cominciamo a...", spanish="[CS:N]Todos[CR]: ¡A COMER!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 344, 208, Direction.Left, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Everyone![K] Hold up!", french=" Vous tous![K] Un instant!", german=" Stopp![K] Alle herhören!", italian=" Gente![K] Aspettate un attimo!", spanish=" ¡Alto![K] ¡Escuchadme!"})
  -- message_Close
  -- back_SetGround(LEVEL_G01P06B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(20) [anim idle native]
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Ahem! Before we begin dinner\ntonight...", french="Hum, hum! Avant de commencer\nà dîner...", german="Ähem! Bevor wir heute zu\nAbend essen...", italian="Ahem! Stasera non si mangia\nsubito.", spanish="¡Ejem! Antes de empezar a cenar\nesta noche..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" I wish to make an announcement.", french="... je souhaiterais faire une\nannonce.", german="Ich habe eine Neuigkeit zu\nverkünden.", italian=" Prima devo fare un annuncio.", spanish=" Deseo comunicaros algo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6923) — id SE NDS sans portage PMDO identifié
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 248, 184, Direction.DownRight, "NPC_DOGOOMU")
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 296, 184, Direction.DownRight, "NPC_HEIGANI")
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "angry", 1) end)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 296, 232, Direction.UpRight, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "angry", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 248, 232, Direction.Right, "NPC_KIMAWARI")
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 192, 232, Direction.Right, "NPC_DOGAASU")
  pcall(function() GROUND:CharSetEmote(npc_npc_dogaasu, "angry", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey, heeeeeey!", french=" Saperlipopince!", german=" Hey, hey, heeeeeey!", italian=" Ehi, ehi, ehiiiiiiiiii!", spanish=" ¡Ay, ay, ay!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Well, spit it out already!\nLet's eat!", french="Allez, raconte, vite!\nOn a FAIM, nous!", german="Na, rück schon raus damit!\nWir wollen essen!", italian="Beh, sputa il rospo! Vogliamo\nMANGIARE!", spanish="¡Dilo de una vez!\n¡Queremos comer!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(4) [anim idle native]
  -- message_FacePositionOffset(4, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="You prevent us from eating\nwhat's in front of us? This is an outrage!", french="Nous avons toute cette\nnourriture sous les yeux et tu nous empêches\nde manger? C'est scandaleux!", german="Du hältst uns davon ab, dieses\nköstliche, vor uns liegende Essen zu vertilgen!\nIch bin entrüstet!", italian="Ci fai aspettare? È uno\nscandalo!", spanish="¿Quieres impedirnos comer justo\ncuando todo está servido? ¡Esto es un ultraje!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(4) [anim idle native]
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Eek! This is so unfair! I feel\nfaint from hunger!", french="Hiii! C'est vraiment trop injuste!\nJe vais tomber dans les pommes tellement j'ai\nfaim!", german="Ieek! Das ist so ungerecht!\nIch werde gleich ohnmächtig vor Hunger!", italian="Ehi! Non è giusto! Ho una fame\nda lupi!", spanish="¡Ayy! ¡Esto no es justo!\n¡Me voy a desmayar del hambre!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 320, 232, Direction.UpRight, "NPC_DIGUDA")
  -- SetAnimation(4) [anim idle native]
  -- message_FacePositionOffset(7, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Boooo! Boooo!", french=" Bouuuh! Bouuuuuuuh!", german=" Buuuuh! Buuuuh!", italian=" Buuuu! Buuuu!", spanish=" ¡Buuu! ¡Fueraaa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Order![K] I must have order!", french="Du calme![K] Du calme, s'il vous\nplaît!", german=" Ruhe![K] Es muss Ruhe herrschen!", italian=" Ordine![K] Ordine!", spanish=" ¡Orden![K] ¡Un poco de orden!"})
  -- message_Close
  -- se_FadeOut(6923, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogaasu, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Ahem! I'm sure the selection\nof the expedition members has been on\neveryone's minds.", french="Hum hum! Je suis sûr que le\nchoix des heureux élus pour l'expédition vous\na tous turlupinés toute la journée.", german="Ähem! Ich bin mir sicher, dass\ndie Auswahl der Expeditionsmitglieder euch alle\nbeschäftigt hat.", italian="Ahem! Sono certo che negli\nultimi giorni tutti voi avrete pensato molto\nalla selezione dei membri della spedizione.", spanish="¡Ejem! Estoy seguro de que la\nselección de miembros para la expedición\nha estado en la mente de todos."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Our Guildmaster has apparently\nmade his final decisions. ♪", french="Notre Maître a enfin pris\nsa décision. ♪", german="Unser Gildenmeister hat endlich\nseine endgültige Entscheidung getroffen. ♪", italian="Sembra che il nostro Capitano\nabbia finalmente preso una decisione. ♪", spanish="Al parecer, nuestro Gran Bluff\nha tomado la decisión final. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 272, 232, Direction.Right, "NPC_GUREGGURU")
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitSe
  -- bgm2_PlayFadeIn(BGM_WIGGLYTUFFS_GUILD_REMIX) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: WHOA!", french="[CS:N]Tous[CR]: WAOUH!", german="[CS:N]Alle[CR]: BOAH!", italian="[CS:N]Tutti[CR]: WOW!", spanish="[CS:N]Todos[CR]: ¡BIEEEN!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  GAME:WaitFrames(15)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 272, 184, Direction.DownRight, "NPC_BIPPA")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" By golly, it's finally settled.", french="Sapristi, v'là l'grand\nmoment.", german="Donnerwetter! Endlich steht es\nfest.", italian=" Ohibò, finalmente è deciso.", spanish=" Bueno, ¡al fin está decidido!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The members will be announced\nat tomorrow morning's briefing.", french="Les noms des membres choisis\nseront annoncés lors de la réunion de\ndemain matin.", german="Die Mitglieder werden bei der\nAnsprache morgen früh bekanntgegeben.", italian="I prescelti saranno annunciati\ndomani mattina.", spanish="Los miembros serán anunciados\nmañana por la mañana."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It's something to look\nforward to. ♪", french=" Réjouissez-vous d'avance. ♪", german="Ihr dürft euch darauf\nfreuen. ♪", italian="Scommetto che non vedete\nl'ora. ♪", spanish="Supongo que estaréis ansiosos\npor conocer su decisión. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Now, sorry to have kept\nyou waiting.", french="Désolé de vous avoir fait\nattendre.", german="So. Tut mir leid, dass ich euch\naufgehalten habe.", italian="Mi spiace avervi fatto\naspettare.", spanish="Y ahora, perdonad que\nos haya hecho esperar."})
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GROUND:EntTurn(npc_npc_bippa, Direction.Down)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Down)
  GROUND:EntTurn(npc_npc_heigani, Direction.Down)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 168, 208, Direction.Right, "NPC_SUKATANKU")
  GROUND:EntTurn(npc_npc_sukatanku, Direction.Right)
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 216, 232, Direction.Right, "NPC_ZUBATTO")
  GROUND:EntTurn(npc_npc_zubatto, Direction.Up)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Up)
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Without further ado... On your\nmarks...", french="Sans plus de commentaires...\nA vos fourchettes...", german="Ohne weitere Umschweife...\nLegt los!", italian="E ora, senza indugiare oltre...\nPronti... partenza...", spanish="Sin más preámbulos...\nEn sus marcas..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sukatanku, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_zubatto, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogaasu, "happy", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: LET'S EAT!", french="[CS:N]Tous[CR]: A LA BOUFFE!", german="[CS:N]Alle[CR]: LASST UNS ESSEN!", italian="[CS:N]Tutti[CR]: SI MANGIA!", spanish="[CS:N]Todos[CR]: ¡A COMER!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_sukatanku, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_zubatto, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogaasu, nil, 0) end) -- EFFECT_NONE
  -- GAP: BGM BGM_EATING non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- SetAnimation(64) [anim idle native]
  -- SetAnimation(64) [anim idle native]
  -- SetAnimation(43) [anim idle native]
  -- SetAnimation(42) [anim idle native]
  -- SetAnimation(42) [anim idle native]
  -- SetAnimation(42) [anim idle native]
  -- SetAnimation(42) [anim idle native]
  -- SetAnimation(42) [anim idle native]
  -- SetAnimation(42) [anim idle native]
  -- SetAnimation(42) [anim idle native]
  -- SetAnimation(42) [anim idle native]
  -- SetAnimation(43) [anim idle native]
  -- SetAnimation(43) [anim idle native]
  -- SetAnimation(42) [anim idle native]
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING_SLOW — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING_SLOW — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING_SLOW — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING_SLOW — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING_SLOW — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING_SLOW — VFX sans émote PMDO équivalente
  SkySceneKit.unlock(6) -- Unlock(6) NDS
  -- message_ResetActor() [neutre/état moteur]
  SkySceneKit.say({english="Crunch munch! Chomp chomp! Gobble gulp!\nCrunch munch! Chomp chomp! Gobble gulp!", french="Cronch cronch! Miam miam! Slurp slurp!\nCronch cronch! Miam miam! Slurp slurp!", german="Stopf-schling! Schmatz! Schlabber-schlürf!\nStopf-schling! Schmatz! Schlabber-schlürf!", italian="Crunch-munch! Ingurg ingurg! Snuffle-slurp!\nGnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem![K]\n¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  SkySceneKit.say({english="Crunch munch! Chomp chomp! Gobble gulp!\nCrunch munch! Chomp chomp! Gobble gulp!", french="Cronch cronch! Miam miam! Slurp slurp!\nCronch cronch! Miam miam! Slurp slurp!", german="Stopf-schling! Schmatz! Schlabber-schlürf!\nStopf-schling! Schmatz! Schlabber-schlürf!", italian="Crunch-munch! Ingurg ingurg! Snuffle-slurp!\nGnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem![K]\n¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  SkySceneKit.say({english="Crunch munch! Chomp chomp! Gobble gulp!\nCrunch munch! Chomp chomp! Gobble gulp!", french="Cronch cronch! Miam miam! Slurp slurp!\nCronch cronch! Miam miam! Slurp slurp!", german="Stopf-schling! Schmatz! Schlabber-schlürf!\nStopf-schling! Schmatz! Schlabber-schlürf!", italian="Crunch-munch! Ingurg ingurg! Snuffle-slurp!\nGnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem![K]\n¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  -- message_CloseEnforce
  pcall(function() SOUND:FadeOutBGM(120) end)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(2) -- join WaitBgm2
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
