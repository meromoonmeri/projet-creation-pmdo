-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/n01a0106.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P04A, 'UN01') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 376, 256, Direction.UpRight, "NPC_GUREGGURU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 440, 272, Direction.Up, "NPC_DOGOOMU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 472, 272, Direction.Up, "NPC_DIGUDA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  GAME:WaitFrames(30)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 376, 272, Direction.UpRight, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 408, 256, Direction.Up, "NPC_CHIRIIN")
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 440, 256, Direction.Up, "NPC_KIMAWARI")
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: THREE![K] SMILES GO FOR MILES!", french="[CS:N]Tous[CR]: TROIS![K] GARDE LE SOURIRE POUR\nREUSSIR!", german="[CS:N]Alle[CR]: DRITTENS![K] MIT EINEM LACHEN\nWERDEN WIR ES MACHEN!", italian="[CS:N]Tutti[CR]: TRE![K] OGNI SORRISO VA CONDIVISO!", spanish="[CS:N]Todos[CR]: ¡TRES![K] ¡SONRISAS PARA TODOS\nY ENCONTRARÉIS MUCHOS TESOROS!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  -- message_Close
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" OK, Pokémon! Get to work! ♪", french="Allez, mes amis Pokémon!\nAu travail! ♪", german=" Gut, Pokémon! An die Arbeit! ♪", italian=" Ok, Pokémon! Al lavoro! ♪", spanish="¡De acuerdo, Pokémon!\n¡Ahora a trabajar! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  GAME:WaitFrames(1)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 408, 272, Direction.Up, "NPC_HEIGANI")
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(25) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: URRÀ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Down)
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_diguda, Direction.Down)
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 424, 208, Direction.Down, "NPC_PUKURIN")
  GROUND:MoveToPosition(npc_npc_pukurin, 420, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 224, 252, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 188, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 240, 272, false, 2)
  GROUND:MoveToPosition(npc_npc_kimawari, 388, 252, false, 2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-80), p.Y+(0), false, 2) end
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(hero, 356, 220, false, 2)
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Hey, [CS:Y]Bidoof[CR].", french=" Hé, [CS:Y]Keunotor[CR].", german=" Hey, [CS:Y]Bidiza[CR].", italian=" Ehi, [CS:Y]Bidoof[CR].", spanish=" Oye, [CS:Y]Bidoof[CR]."})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(hero, 412, 220, false, 2)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Yes![K]\nWhat is it?", french="Ouais![K]\nQu'est-ce qu'y a?", german=" Ja![K] Was gibt's?", italian="Sì! [K]\nCosa c'è?", spanish=" Dime.[K] ¿De qué se trata?"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Today's assignment. ♪", french=" Ton travail pour aujourd'hui. ♪", german=" Deine Aufgabe für heute. ♪", italian=" Il tuo incarico per oggi. ♪", spanish=" Te voy a decir tu tarea de hoy. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Please go to [CS:K]Kecleon[CR] Market and\nfind out how many [CS:I]Oran Berries[CR] they have for\nsale today. ♪", french="Va au [CS:K]Marché Kecleon[CR],\ns'il te plaît, et demande-leur combien\nils ont de [CS:I]Baies Oran[CR] à vendre aujourd'hui. ♪", german="Bitte gehe zum [CS:K]Kecleon-Markt[CR]\nund finde heraus, wie viele [CS:I]Sinelbeeren[CR] sie\nheute im Angebot haben. ♪", italian="Vai al [CS:K]Kecleon[CR] Market e scopri\nquante [CS:I]Baccarance[CR] hanno in vendita oggi. ♪", spanish="Por favor, acércate al [CS:K]Bazar Kecleon[CR]\ny averigua cuántas [CS:I]Bayas Aranja[CR] tienen hoy\na la venta. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" .........", french=" ..........", german=" ..........", italian=" ..........", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="........[K]Huh?[K]\nWhat's wrong, [CS:Y]Bidoof[CR]?", french="........[K] Hein?[K]\nQuel est le problème, [CS:Y]Keunotor[CR]?", german="........[K]Huch![K]\nStimmt etwas nicht, [CS:Y]Bidiza[CR]?", italian="........[K] Uh?[K]\nChe succede, [CS:Y]Bidoof[CR]?", spanish=" Eh...[K] ¿Ocurre algo?[K] ¿Qué pasa, [CS:Y]Bidoof[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You're always doing little\nerrands like this.[K] It's nothing too difficult. ♪", french="Tu as l'habitude de ce genre de\ncommissions, non?[K]\nÇa n'a rien de sorcier. ♪", german="Du erledigst doch immer kleine\nBotengänge wie diesen.[K]\nDas schaffst du schon. ♪", italian="È un piccolo incarico, come\nquelli che ti affido sempre.[K]\nNon è così complicato. ♪", spanish="Siempre haces recaditos de este\ntipo.[K] No es nada difícil. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Golly, it's not that...", french=" Sapristi, c'est pas ça...", german=" Donnerwetter. Das ist es nicht...", italian=" Ohibò, non si tratta di questo...", spanish=" Caramba, de eso se trata..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Just that I seem to always be\nrunning errands...", french="C'est juste que j'ai l'impression\nd'faire que ça, des commissions\nd'rien du tout...", german="Aber ich habe immer diese\nkleinen Botengänge zu erledigen...", italian="Solo che finisco per fare sempre\nquesti lavoretti...", spanish="Parece que soy el Pokémon\nde los recados..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="What I really want is to get\nexploration assignments. Yup yup...", french="Moi, c'que j'veux, c'est partir en\nexploration, pardi!", german="Ich würde viel lieber mal einen\nErkundungsauftrag bekommen. Jawollja...", italian="Invece ciò che più desidero\nè prendere parte a qualche missione\nd'esplorazione. Già, già...", spanish="Lo que quiero hacer son misiones\nde exploración. Sí, señor..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Don't you think I can do a job\nfrom the Job Bulletin Board sometime?", french="Tu penses pas que j'pourrais\nm'occuper d'une mission du\nTableau des Missions, un d'ces quatre?", german="Denkst du nicht, dass es an der\nZeit ist, dass ich einmal einen Job vom\nJob-Infobrett erledigen kann?", italian="Non pensi che qualche volta\npotrei scegliere una missione dalla Bacheca?", spanish="¿No crees que podría hacer\nalguna misioncilla del Tablón de Anuncios\nde vez en cuando? Alguna no muy difícil..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" What? [K]This isn't a joke!", french=" Quoi? [K]Tu parles sérieusement?", german="Was? [K]Darüber macht man\nkeine Witze!", italian="Cosa? [K]Guarda che non\nè uno scherzo!", spanish=" ¿Cómo?[K] ¡Será una broma!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="If I let you do one of those\nassignments right now...", french="Si je te laissais accomplir une\nde ces missions, aujourd'hui...", german="Wenn ich dich jetzt einen solchen\nAuftrag machen ließe...", italian="Se ti assegnassi uno di\nquegli incarichi adesso...", spanish="Si te dejara hacer una de esas\nmisiones ahora..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="How badly do you think you\nwould mess it up?!", french="... à ton avis, quel degré\npenses-tu que tu atteindrais sur l'échelle\ndes catastrophes?", german="Wie sehr würdest du es wohl\nverpatzen?!?", italian="... finiresti per combinare\nqualche pasticcio!", spanish="¿Cuánto crees que tardarías en\nmeter la pata hasta el fondo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Sniff...[K] Then I'll just...[K]\nI'll just...", french="Snif...[K] Bon, alors j'vais...[K]\nj'vais juste...", german="Schnüff...[K] Na, dann werde ich...[K]\nMuss ich eben...", italian="Sniff...[K] Ma allora io...[K]\nIo...", spanish="Buaa...[K] Pues entonces...[K]\nEntonces..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" The story of my life... Yup yup...", french="C'est toute l'histoire d'ma vie...\nOuaip...", german="Der Traum meines Lebens...\nSchnief...", italian="La mia vita non cambierà mai...\nGià, già...", spanish=" Me parece que tienes razón, jo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="...[K][CS:Y]Bidoof[CR].[K]\nDon't be so impatient.", french="... [K][CS:Y]Keunotor[CR].[K]\nNe sois pas si impatient.", german=" ...[K][CS:Y]Bidiza[CR]![K] Sei nicht so ungeduldig.", italian="...[K] [CS:Y]Bidoof[CR].[K]\nNon devi essere così impaziente.", spanish=" Oye...[K] [CS:Y]Bidoof[CR].[K] No seas tan impaciente."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You're just a little slower than\neveryone else.", french="Tu es un peu... plus lent que\nles autres, voilà tout.", german="Du bist nun eben ein bisschen\nlangsamer als die anderen.", italian="Hai solo bisogno di un po' più\ndi tempo rispetto agli altri, tutto qui.", spanish="Lo único que pasa es que eres\nun pelín más lento que los demás."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(3) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(1)
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Sniff...[K] Golly, you don't have to\nbe so direct...", french="Snif...[K] Nom d'une pipe, inutile\nd'être si direct...", german="Schnief...[K] Donnerwetter, du\nmusst ja nicht so direkt sein...", italian="Sniff...[K] Ohibò, non c'è bisogno\ndi essere così diretto...", spanish="Buaa...[K] Caramba, no hace falta\nque seas tan directo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But I know the day will come\nwhere you'll get to do exploration jobs.", french="Mais je sais bien qu'un jour\nviendra où tu pourras partir en\nmission d'exploration.", german="Aber ich weiß, der Tag wird\nkommen, an dem auch du Erkundungsjobs\nerledigen wirst.", italian="Ma sono sicuro che arriverà\nil giorno in cui potrai prendere parte\nalle missioni di esplorazione.", spanish="Pero sé que llegará un día en\nque podrás hacer misiones de exploración."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="If you want to be a top\nexplorer, you have to start somewhere.", french="Tout explorateur digne de ce\nnom doit commencer par accomplir des\ntâches mineures.", german="Wenn du ein großer Erkunder\nsein willst, musst du dich eben erst an die\nErkundungsjobs heranarbeiten.", italian="Se vuoi diventare un grande\nesploratore, devi pur cominciare in\nqualche modo.", spanish="Si quieres ser un explorador de\nélite tienes que empezar por alguna parte."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Do your best...[K]\nAnd work hard at your training.", french="Alors, fais de ton mieux...[K]\nEt entraîne-toi dur!", german="Gib dein Bestes...[K] Und lass dich\nbeim Training nicht hängen.", italian="Fai del tuo meglio...[K]\nE lavora sodo.", spanish=" Ve a por todas...[K] Y entrena duro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Sniff... So you're telling me I\njust need to be patient...", french="Snif... Donc, d'après toi,\nfaut juste que j'sois patient...", german="Schnief... Also sagst du mir,\ndass ich mich nur gedulden muss...", italian="Sniff... Quindi mi stai dicendo\nche devo solo avere pazienza...", spanish="Jo... Así que crees que solo\ndebo tener paciencia..."})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="By golly, I get it.[K]\nI'm gonna work hard. Yup yup!", french="Sapristi, j'ai compris.[K]\nJ'vais r'doubler d'efforts, pardi!", german="Donnerwetter, ich verstehe.[K]\nIch werde mir Mühe geben. Jawollja!", italian="Ohibò, ho capito. [K]\nMi allenerò duramente. Già, già!", spanish="Caramba, pues eso haré.[K]\nPienso trabajar duro. ¡Sí, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" That's right! Just like that!", french="Voilà! C'est comme ça qu'il\nfaut voir les choses!", german="Genau! Die Einstellung lobe\nich mir!", italian="Bravo! Questo è lo spirito\ngiusto!", spanish=" ¡Muy bien! ¡Así me gusta!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Now that you get it, if you could\ngo run that errand I mentioned...", french="Bien, puisque tu m'as l'air\nd'avoir compris, que dirais-tu de t'occuper\nde cette commission, maintenant?", german="Nun, da du verstehst, wärst du\nso freundlich, den Auftrag zu erledigen,\nvon dem wir gerade sprachen?", italian="Ora che hai capito, potresti\nsvolgere l'incarico di cui ti ho parlato?", spanish="Ahora que hemos aclarado esto,\nsi pudieras hacer ese recado..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Please go to [CS:K]Kecleon[CR] Market and\nfind out how many [CS:I]Oran Berries[CR] they have for\nsale today. ♪", french="Va au [CS:K]Marché Kecleon[CR],\ns'il te plaît, et demande-leur combien\nils ont de [CS:I]Baies Oran[CR] à vendre aujourd'hui. ♪", german="Bitte geh zum [CS:K]Kecleon-Markt[CR] und\nfinde heraus, wie viele [CS:I]Sinelbeeren[CR] sie heute\nim Angebot haben. ♪", italian="Vai al [CS:K]Kecleon[CR] Market e scopri\nquante [CS:I]Baccarance[CR] hanno in vendita oggi. ♪", spanish="Por favor, acércate al [CS:K]Bazar Kecleon[CR]\ny averigua cuántas [CS:I]Bayas Aranja[CR] tienen hoy\na la venta. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yes, sir! Yup yup!", french=" Bien reçu, chef! Ouaip ouaip!", german=" Verstanden, Sir! Jawollja!", italian=" Sissignore! Già, già!", spanish=" ¡Entendido! ¡Sí, señor!"})
  -- message_Close
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]The Special Episode\n[CN]\"Bidoof's Wish\"\n[CN]stars [CS:Y]Bidoof[CR] as the main character.", french="[CN][CS:Y]Keunotor[CR] est le personnage principal\n[CN]de l'Episode Spécial intitulé\n[CN]\"Le vœu de Keunotor\".", german="[CN]Die Bonusepisode\n[CN][F:S2]Der Wunsch von Bidiza[F:E2]\n[CN]mit [CS:Y]Bidiza[CR] in der Hauptrolle.", italian="[CN]L'episodio speciale\n[CN]\"Il desiderio di Bidoof\"\n[CN]ha come protagonista [CS:Y]Bidoof[CR].", spanish="[CN]El capítulo especial\n[CN]\"El deseo de Bidoof\"\n[CN]tiene a [CS:Y]Bidoof[CR] por protagonista."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]You will progress through the story with\n[CN][CS:Y]Bidoof[CR] as the playable character.", french="[CN]Vous incarnerez [CS:Y]Keunotor[CR].", german="[CN]Du wirst die Geschichte mit\n[CN][CS:Y]Bidiza[CR] als spielbarem Charakter bestreiten.", italian="[CN]In questa storia impersonerai [CS:Y]Bidoof[CR].", spanish="[CN]Avanzarás en la historia\n[CN]con [CS:Y]Bidoof[CR]."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]So, just as [CS:N]Chatot[CR] requested...", french="[CN]Donc, comme [CS:N]Pijako[CR] vous l'a demandé...", german="[CN]Begib dich also zum [CS:K]Kecleon-Markt[CR]\n[CN]in Schatzstadt...", italian="[CN]Quindi, come ha chiesto [CS:N]Chatot[CR]...", spanish="[CN]Así que, tal como pidió [CS:N]Chatot[CR]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Head to [CS:K]Kecleon[CR] Market in Treasure Town.", french="[CN]... rendez-vous au [CS:K]Marché Kecleon[CR]\n[CN]à Bourg-Trésor.", german="[CN]Genau wie [CS:N]Plaudagei[CR] es von dir verlangt hat.", italian="[CN]Vai al [CS:K]Kecleon[CR] Market a Borgo Tesoro.", spanish="[CN]Dirígete al [CS:K]Bazar Kecleon[CR] de Aldea Tesoro."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Also...", french="[CN]En outre...", german="[CN]Und noch etwas...", italian="[CN]Inoltre...", spanish="[CN]Por otra parte..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]You can save your progress\n[CN]at the Watering Hole or [CS:Y]Bidoof[CR]'s bed.", french="[CN]... sachez que vous pouvez sauvegarder votre\n[CN]aventure au Point d'Eau ou en rejoignant\n[CN]le lit de [CS:Y]Keunotor[CR].", german="[CN]Du kannst deinen Fortschritt beim Wasserloch\n[CN]oder im Bett von [CS:Y]Bidiza[CR] sichern.", italian="[CN]... puoi salvare i tuoi progressi\n[CN]al pozzo o nel letto di [CS:Y]Bidoof[CR].", spanish="[CN]Puedes guardar la partida en la fuente\n[CN]o en la cama de [CS:Y]Bidoof[CR]."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]The Watering Hole is at the intersection\n[CN]just down the stairs from the guild...", french="[CN]Le Point d'Eau se trouve au croisement,\n[CN]juste en bas des marches menant à la Guilde...", german="[CN]Das Wasserloch befindet sich an der Kreuzung\n[CN]geradewegs unterhalb des Ausgangs der Gilde...", italian="[CN]Il pozzo si trova fuori dalla Gilda, in fondo\n[CN]alle scale, dove c'è l'incrocio.", spanish="[CN]La fuente está en la intersección que hay al\n[CN]bajar las escaleras del [CS:N]Pokégremio[CR]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN][CS:Y]Bidoof[CR]'s bed is to the\n[CN]right and down in the crew rooms.", french="[CN]Le lit de [CS:Y]Keunotor[CR] se trouve à droite\n[CN]puis vers le bas dans le dortoir des membres.", german="[CN]Und das Bett von [CS:Y]Bidiza[CR] findest du in den\n[CN]Crewräumen der Gilde, indem du erst nach\n[CN]rechts und dann nach unten gehst.", italian="[CN]Il letto di [CS:Y]Bidoof[CR] si trova a destra\n[CN]e poi in basso nelle stanze degli apprendisti.", spanish="[CN]La cama de [CS:Y]Bidoof[CR] está en el dormitorio\n[CN]de abajo a la derecha."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]When you want to save your progress, please\n[CN]go to the Watering Hole or [CS:Y]Bidoof[CR]'s bed.", french="[CN]Dès que vous voulez sauvegarder votre\n[CN]aventure, allez au Point d'Eau ou rejoignez\n[CN]le lit de [CS:Y]Keunotor[CR].", german="[CN]Wenn du deinen Fortschritt sichern\n[CN]willst, gehe zum Wasserloch oder zum Bett\n[CN]von [CS:Y]Bidiza[CR].", italian="[CN]Quando vuoi salvare i tuoi progressi, vai\n[CN]al pozzo o nel letto di [CS:Y]Bidoof[CR].", spanish="[CN]Cuando quieras guardar la partida,\n[CN]ve a la fuente o a la cama de [CS:Y]Bidoof[CR]."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
