-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P06B/m11a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_NPC_PUKURIN
    local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 368, 232, Direction.Down, "NPC_PUKURIN")
    -- SetAnimation(2) [anim idle native]
    local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 344, 208, Direction.Left, "NPC_PERAPPU")
    pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_perappu, 4) end)
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
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 320, 184, Direction.Down, "NPC_CHIRIIN")
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Everyone! Time for dinner! ♪", french=" Allez tout le monde! A table! ♪", german="Alles herkommen! Zeit fürs\nAbendessen! ♪", italian=" Ehilà, gente! È ora di cena! ♪", spanish=" ¡Atención! ¡Hora de cenar! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: YEAH!", french="[CS:N]Tous[CR]: OUAIS!", german="[CS:N]Alle[CR]: JAAAA!", italian="[CS:N]Tutti[CR]: SÌÌÌÌÌÌÌ!", spanish="[CS:N]Todos[CR]: ¡BIEN!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: Let's get...", french="[CS:N]Tous[CR]: Allons...", german="[CS:N]Alle[CR]: Lasst uns...", italian="[CS:N]Tutti[CR]: Buon appeti...", spanish="[CS:N]Todos[CR]: VAMOS A..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Hold on, everyone!", french=" Attendez, vous autres!", german=" Stopp, Pokémon!", italian=" Un momento!", spanish=" ¡Esperad un momento!"})
  -- message_Close
  -- back_SetGround(LEVEL_G01P06B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 272, 184, Direction.Down, "NPC_BIPPA")
  GROUND:EntTurn(npc_npc_bippa, Direction.DownRight)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 248, 184, Direction.Down, "NPC_DOGOOMU")
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 248, 232, Direction.Up, "NPC_KIMAWARI")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 320, 232, Direction.Up, "NPC_DIGUDA")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 296, 232, Direction.Up, "NPC_DAGUTORIO")
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 296, 184, Direction.Down, "NPC_HEIGANI")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_perappu, 4) end)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 272, 232, Direction.Up, "NPC_GUREGGURU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  GROUND:EntTurn(npc_npc_chiriin, Direction.DownRight)
  GAME:FadeIn(15)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Ahem![K] Before we start dinner...", french="Hum![K] Avant de nous mettre\nà table...", german="Ähem![K] Bevor wir zu Abend\nessen...", italian=" Ahem![K] Prima di cena...", spanish="¡Ejem![K] Antes de que empecemos\na cenar..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="There is something I must\nshare with you.", french="... j'ai quelque chose à vous\nannoncer.", german="Es gibt da noch etwas, das ich\neuch mitteilen will.", italian=" ... c'è qualcosa che devo dirvi.", spanish=" Hay algo que debo comunicaros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6923) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "angry", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "angry", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey, hey!", french=" Eh dis donc!", german=" Hey, hey, hey!", italian=" Ehi, ehi, ehi!", spanish=" ¡Oye, oye!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Come on! Out with it! Let us\neat already!", french="Allez, dépêche et laisse-nous\nmanger TRANQUILLES!", german="Komm schon! Raus damit! Lass\nuns endlich essen!", italian="Eh no! Su certe cose non si\nscherza! Abbiamo fame!!!", spanish="¡Venga! ¡Suéltalo ya!\n¡Queremos comer de una vez!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Quiet, please!", french=" Du calme, s'il vous plaît!", german=" Ruhe, bitte!", italian=" Silenzio, per favore!", spanish=" ¡Silencio, por favor!"})
  -- message_Close
  -- se_FadeOut(6923, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Ahem.[K] Now we just received\nword of this...", french="Hum.[K] Nous venons juste de\nl'apprendre...", german="Ähem.[K] Wie wir gerade erfahren\nhaben...", italian="Ahem.[K] Proprio in questo\nmomento ci è giunta notizia...", spanish="Ejem.[K] Me acaban de informar de\nque..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Another Time Gear was stolen!", french="Un autre Rouage du Temps a été\ndérobé!", german="Es wurde noch ein Zahnrad der\nZeit gestohlen!", italian="... che un altro Ingranaggio del\nTempo è stato rubato!", spanish="¡Han robado otro Engranaje del\nTiempo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: WHAT?!", french="[CS:N]Tous[CR]: QUOI?!", german="[CS:N]Alle[CR]: WAS?!?", italian="[CS:N]Tutti[CR]: COSA???", spanish="[CS:N]Todos[CR]: ¡¿QUÉ?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Another Time Gear?", french=" Un autre Rouage du Temps?", german=" Noch ein Zahnrad der Zeit?", italian=" Un altro Ingranaggio del Tempo?", spanish=" ¿Otro Engranaje del Tiempo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" ANOTHER one got stolen?!", french=" On en a volé un AUTRE?!", german=" Es wurde NOCH EINS gestohlen?", italian=" Ne hanno rubato UN ALTRO???", spanish=" ¡¿Otro más?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Uh, is it...[K]maybe...[K]the one in\n[CS:P]Fogbound Lake[CR]?", french="Euh, p'têt'...[K] qu'c'est...[K] çui\ndu [CS:P]Lac des Brumes[CR]?", german="Äh, ist es...[K] vielleicht...[K] das vom\n[CS:P]Nebelsee[CR]?", italian="Non sarà...[K] per caso...[K] quello\ndel [CS:P]Lago Foschia[CR], vero?", spanish="Esto...[K] No será...[K] ¿No será el\nque había en el [CS:P]Lago Velado[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" No, it wasn't.", french=" Non, pas celui-là.", german=" Nein, ist es nicht.", italian=" No. Non si tratta di quello.", spanish=" No, ese no."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The stolen Time Gear was not\nfrom [CS:P]Fogbound Lake[CR].", french="Ce n'était pas celui du [CS:P]Lac\ndes Brumes[CR].", german="Das gestohlene Zahnrad der Zeit\nist nicht das vom [CS:P]Nebelsee[CR].", italian="L'Ingranaggio del Tempo che è\nstato rubato non è quello del [CS:P]Lago Foschia[CR].", spanish="El Engranaje del Tiempo que\nha desaparecido no es el del [CS:P]Lago Velado[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" It's apparently from elsewhere.", french="Apparemment, il s'agit d'un autre\nRouage du Temps.", german=" Anscheinend war es ein anderes.", italian="A quanto pare, proviene da\nqualche altra parte.", spanish="Parece ser que estaba en otra\nparte."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But that's the second Time Gear\nto be stolen.", french="Mais c'est déjà le deuxième\nà disparaître.", german="Aber das ist bereits das zweite\nZahnrad der Zeit, das gestohlen wurde.", italian="Ma si tratta del secondo\nIngranaggio del Tempo che viene rubato.", spanish="Pero ya es el segundo Engranaje\ndel Tiempo que han robado."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It would be extremely bad if\na third were to be taken.", french="Si jamais on en volait\nun troisième, la situation serait dramatique.", german="Es wäre ausgesprochen schlimm,\nwenn ein Drittes gestohlen werden würde.", italian="Sarebbe gravissimo se ne\nvenisse rubato un terzo.", spanish="Si roban alguno más, las\nconsecuencias serán terribles."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Now, rest assured that I have\nfull confidence in you all.[K] But I must make one\nthing very clear.", french="Soyez bien sûrs que j'ai\nune totale confiance en vous.[K]\nMais que les choses soient claires.", german="Seid versichert, dass ich euch\nallen voll und ganz vertraue.[K] Aber ich muss\neines klarstellen.", italian="Ora, vorrei rassicurarvi e\nricordarvi che ho fiducia in tutti voi.[K] Ma è\nnecessario che chiarisca un punto.", spanish="Por supuesto, tengo plena\nconfianza en todos vosotros.[K]\nPero una cosa tiene que quedar clara."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You must never tell anyone what\nyou witnessed during our expedition!", french="Vous ne devez jamais révéler\nà qui que ce soit ce que vous avez vu pendant\nl'expédition!", german="Ihr dürft niemals irgendwem\nerzählen, was ihr auf unserer Expedition\ngesehen habt!", italian="Dovete mantenere il segreto\nassoluto su ciò che abbiamo visto durante la\nnostra spedizione!", spanish="¡Bajo ningún concepto debéis\ncontarle a nadie lo que vimos en la expedición!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Understood?", french=" Compris?", german=" Verstanden?", italian=" Intesi?", spanish=" ¿Entendido?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6923) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "angry", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "angry", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Of course!", french=" Bien sûr!", german=" Natürlich!", italian=" Certo!", spanish=" ¡Por supuesto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" I don't have a big mouth!", french=" Je sais tenir ma LANGUE!", german=" Ich habe keine große Klappe!", italian=" So tenere la bocca chiusa, io!", spanish=" ¡Yo no soy un bocazas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Eeek! I would never forget the\npromise we made to [CS:N]Uxie[CR]!", french="Hiii! Jamais je n'oublierai\nla promesse que nous avons faite à [CS:N]Créhelf[CR]!", german="Ieeek! Ich würde das\nVersprechen an [CS:N]Selfe[CR] nie vergessen!", italian="Ehi! Come potrei dimenticare la\npromessa che abbiamo fatto a [CS:N]Uxie[CR]?", spanish="¡Jamás olvidaría la promesa que\nle hicimos a [CS:N]Uxie[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" OK! OK![K] Quiet, everyone!", french=" Très bien, très bien![K] Du calme!", german=" Okay! Okay![K] Seid alle still!", italian=" Ok! Ok![K] Silenzio, per favore!", spanish=" ¡Vale, vale![K] ¡Silencio todos!"})
  -- message_Close
  -- se_FadeOut(6923, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Sorry to keep you waiting.", french="Désolé de vous avoir fait\nattendre.", german="Es tut mir leid, dass ich euch\naufgehalten habe.", italian=" Scusatemi per l'attesa.", spanish=" Siento haberos hecho esperar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
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
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Without further ado...[K] On your\nmarks...get set...", french="Sans plus tarder...[K]\nA vos marques... prêts...", german="Ohne weitere Umschweife...[K]\nAuf die Plätze... fertig...", italian="Senza aggiungere altro...[K]\nPronti... Ai posti...", spanish="Sin más preámbulos...[K]\nPreparados... Listos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: CHOW!", french="[CS:N]Tous[CR]: BAFREZ!", german="[CS:N]Alle[CR]: JAMM!", italian="[CS:N]Tutti[CR]: BUON APPETITO!", spanish="[CS:N]Todos[CR]: ¡A COMER!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
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
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(6) -- Unlock(6) NDS
  -- message_ResetActor() [neutre/état moteur]
  SkySceneKit.say({english="Crunch-munch! Chew-chew! Snuffle-slurp!\nCrunch-munch! Chew-chew! Snuffle-slurp!", french="Cronch cronch! Miam miam! Slurp slurp!\nCronch cronch! Miam miam! Slurp slurp!", german="Stopf-schling! Schmatz! Schlabber-schlürf!\nStopf-schling! Schmatz! Schlabber-schlürf!", italian="Gnam-gnam! Ingurg-ingurg! Slurp-slurp!\nGnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!\n¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  SkySceneKit.say({english="Crunch-munch! Chew-chew! Snuffle-slurp!\nCrunch-munch! Chew-chew! Snuffle-slurp!", french="Cronch cronch! Miam miam! Slurp slurp!\nCronch cronch! Miam miam! Slurp slurp!", german="Stopf-schling! Schmatz! Schlabber-schlürf!\nStopf-schling! Schmatz! Schlabber-schlürf!", italian="Gnam-gnam! Ingurg-ingurg! Slurp-slurp!\nGnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!\n¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  SkySceneKit.say({english="Crunch-munch! Chew-chew! Snuffle-slurp!\nCrunch-munch! Chew-chew! Snuffle-slurp!", french="Cronch cronch! Miam miam! Slurp slurp!\nCronch cronch! Miam miam! Slurp slurp!", german="Stopf-schling! Schmatz! Schlabber-schlürf!\nStopf-schling! Schmatz! Schlabber-schlürf!", italian="Gnam-gnam! Ingurg-ingurg! Slurp-slurp!\nGnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!\n¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  -- message_CloseEnforce
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
