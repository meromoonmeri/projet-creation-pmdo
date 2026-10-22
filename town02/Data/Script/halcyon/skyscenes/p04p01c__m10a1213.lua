-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P04P01C/m10a1213.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- back_SetGround(LEVEL_P04P01C) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 160, 376, Direction.Up, "NPC_PUKURIN")
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" So sorry! To have disturbed you!", french="Nous sommes désolés de t'avoir\ndérangé!", german="Entschuldige bitte! Dass wir dich\ngestört haben!", italian="Scusaci tanto! ♪ Non volevamo\ndisturbarti! ♪", spanish="¡Sentimos mucho haberte\nmolestado!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Had a fantastic time! ♪[K]\nFriend! ♪ Friend! ♪ Friend! ♪", french="On a passé un moment féerique!\nAmi! ♪ Ami! ♪ Ami de moi! ♪", german="Es war fantastisch! ♪[K]\nFreund! ♪ Freund! ♪ Freund! ♪", italian="Ci siamo proprio divertiti! ♪[K]\nAmico! ♪ Amico! ♪ Amicissimo! ♪", spanish="¡Me lo he pasado genial! ♪[K]\n¡Amigo! ♪ ¡Amigo! ♪ ¡Amigo! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_yukushii = SkySceneKit.spawn_npc("uxie", 160, 352, Direction.Down, "NPC_YUKUSHII")
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="I shall not take away your\nmemories of this place.", french="Je ne vous priverai pas de vos\nsouvenirs de cet endroit.", german="Ich werde eure Erinnerungen an\ndiesen Ort nicht auslöschen.", italian="Non cancellerò i vostri ricordi\ndi questo posto.", spanish="No os arrebataré los recuerdos\nde este lugar."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english=" You have earned my trust.", french=" Vous avez gagné ma confiance.", german=" Ihr habt mein Vertrauen.", italian="Vi siete guadagnati la mia\nfiducia.", spanish=" Os habéis ganado mi confianza."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="But I must ask that you keep\nthis place a secret.", french="Mais je dois vous demander\nde garder le secret au sujet de ce lieu.", german="Aber ich muss euch bitten,\ndas Geheimnis um diesen Ort zu bewahren.", italian="Ma sono obbligato a chiedervi di\nnon parlarne con nessuno.", spanish="Pero debo pediros que guardéis\nen secreto la existencia de este sitio."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Surely! Thank you! We all know\nwhat we need to do!", french="Bien sûr! Merci! On sait tous\nce qu'on a à faire!", german="Sicher! Vielen Dank!\nWir wissen, was wir zu tun haben!", italian="Ma certo! Grazie ancora! ♪\nFaremo come dici!", spanish="¡Claro! ¡Gracias! Todos sabemos\nlo que debemos hacer."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You know, another Time Gear\nhas been stolen. This one must stay safe!", french="Tu sais, un autre Rouage\ndu Temps a été dérobé! Celui-ci doit rester\nen sûreté!", german="Weißt du, es wurde noch ein\nZahnrad der Zeit gestohlen. Dieses hier muss\nin Sicherheit bleiben!", italian="Devi sapere che è stato rubato\nun altro Ingranaggio del Tempo! Questo deve\nrestare al sicuro!", spanish="Dado que han robado otro\nEngranaje del Tiempo, ¡este hay que\nprotegerlo!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="We won't ever say a word about\nthis place!", french="Nous serons muets comme\ndes carpes!", german="Wir werden nie auch nur ein\nWort über diesen Ort verlieren!", italian="Non diremo a nessuno di questo\nposto! ♪", spanish="¡Jamás diremos nada sobre\neste lugar!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I swear it in the name of\n[CS:N]Wigglytuff[CR]'s Guild!", french="Je le jure sur l'honneur\nde la Guilde de [CS:N]Grodoudou[CR]!", german="Ich schwöre im Namen der\n[CS:N]Knuddeluff-Gilde[CR]!", italian="Te lo prometto sull'onore della\nGilda di [CS:N]Wigglytuff[CR]!", spanish="¡Lo prometo en nombre de mi\n[CS:N]Pokégremio[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english=" Please hold true to that promise.", french=" Tâchez de tenir parole.", german=" Bitte haltet dieses Versprechen.", italian="Vi prego di mantenere questa\npromessa.", spanish="Confío en que respetéis vuestra\npromesa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" OK![K] Let's be on our way!", french=" Entendu![K] Allez, en route!", german="Okay![K] Machen wir uns auf den\nWeg!", italian=" Ok![K] Gente! ♪ In marcia! ♪", spanish=" ¡De acuerdo![K] ¡Vámonos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" [CS:N]Chatot[CR], if you will!", french=" [CS:N]Pijako[CR], quand tu veux!", german=" [CS:N]Plaudagei[CR], wenn ich bitten darf!", italian=" [CS:N]Chatot[CR], fai strada!", spanish=" [CS:N]Chatot[CR], ¡adelante!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 184, 392, Direction.UpLeft, "NPC_PERAPPU")
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" I'll hop to it, Guildmaster!", french=" A vos ordres, Maître!", german=" Ich fliege schon, Gildenmeister!", italian=" Agli ordini, Capitano!", spanish=" ¡Ahora mismo, Gran Bluff!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(hero, Direction.Right)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 160, 408, Direction.Up, "NPC_HEIGANI")
  GROUND:EntTurn(npc_npc_heigani, Direction.UpRight)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 160, 432, Direction.Up, "NPC_CHIRIIN")
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpRight)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 128, 432, Direction.Up, "NPC_DIGUDA")
  GROUND:EntTurn(npc_npc_diguda, Direction.UpRight)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 224, 400, Direction.UpLeft, "NPC_KIMAWARI")
  GROUND:EntTurn(npc_npc_kimawari, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Everyone, we're going back to\nthe guild!", french="Allez vous autres, nous rentrons\nà la Guilde!", german="Pokémon, wir gehen zurück zur\nGilde!", italian=" Si torna alla Gilda! ♪", spanish=" ¡Es hora de volver al [CS:N]Pokégremio[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 104, 424, Direction.UpRight, "NPC_DOGOOMU")
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 224, 424, Direction.UpLeft, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 200, 408, Direction.UpLeft, "NPC_BIPPA")
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 184, 432, Direction.Up, "NPC_GUREGGURU")
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_heigani, Direction.Down)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_bippa, Direction.Down)
  -- SetAnimation(24) [anim idle native]
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_kimawari, Direction.Down)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  -- SetAnimation(25) [anim idle native]
  -- SetAnimation(66) [anim idle native]
  -- SetAnimation(66) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: URRÀ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
  -- message_Close
  GAME:WaitFrames(15)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]And so...", french="[CN]Et c'est ainsi que...", german="[CN]Marschrichtung Schatzstadt!", italian="[CN]E così...", spanish="[CN]Y así..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]The guild's long and challenging\n[CN]expedition finally came to an end...", french="[CN]... la longue et périlleuse expédition\n[CN]de la Guilde prit fin...", german="[CN]Die lange und abenteuerliche Expedition\n[CN]der Gilde geht zu Ende.", italian="[CN]La lunga e difficile spedizione della Gilda\n[CN]finalmente giunge al termine...", spanish="[CN]La larga y arriesgada expedición\n[CN]del [CS:N]Pokégremio[CR] llegó a su fin..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN][CS:N]Wigglytuff[CR] and the members\n[CN]safely returned to the guild...", french="[CN][CS:N]Grodoudou[CR] et les autres\n[CN]regagnèrent la Guilde sans encombre.", german="[CN][CS:N]Knuddeluff[CR] und die Gildenmitglieder\n[CN]kehren sicher zur Gilde zurück.", italian="[CN][CS:N]Wigglytuff[CR] e gli altri\n[CN]tornano alla Gilda...", spanish="[CN][CS:N]Wigglytuff[CR] y los miembros del [CS:N]Pokégremio[CR]\n[CN]regresaron a casa sanos y salvos..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]For [hero] and the apprentices...", french="[CN]Pour [hero] et les autres apprentis...", german="[CN]Für [hero] und die Lehrlinge beginnt\n[CN]erneut die Routine.", italian="[CN]Per [hero] e per tutti gli altri...", spanish="[CN]En cuanto a [hero] y los aprendices..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]Going to the guild meant taking up\n[CN]the standard training schedule...", french="[CN]... le retour à la Guilde impliquait\n[CN]la reprise de l'entraînement quotidien.", german="[CN]Das normale Trainingsprogramm ist\n[CN]wieder an der Tagesordnung.", italian="[CN]tornare significa ricominciare\n[CN]con l'allenamento...", spanish="[CN]Volver al [CS:N]Pokégremio[CR] supuso recuperar\n[CN]su rutina diaria de entrenamiento..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]It was life as usual back at the guild!", french="[CN]Ainsi, la vie reprit son cours\n[CN]à la Guilde!", german="[CN]In der Gilde kehrt der Alltag ein!", italian="[CN]La vita alla Gilda torna alla normalità!", spanish="[CN]Todo volvía a ser como siempre."})
  -- message_Close
  GAME:WaitFrames(60)
  -- worldmap_SetMode(3) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetLevel(1) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_ChangeLevel(2) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetCamera(15) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() SOUND:PlayFanfare("Fanfare/NewArea") end) -- me_Play(6) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]The clouds lifted from [CS:P]Fogbound Lake[CR]\n[CN]and its surrounding areas!", french="[CN]Les nuages se dissipent au-dessus du [CS:P]Lac\n[CN]des Brumes[CR] et de sa région!", german="[CN]Die Wolken, die über dem [CS:P]Nebelsee[CR] und überall\n[CN]um ihn herum hingen, sind verschwunden!", italian="[CN]Le nuvole si sollevano dal [CS:P]Lago Foschia[CR]\n[CN]e dalle aree circostanti!", spanish="[CN]Las nubes que cubrían el [CS:P]Lago Velado[CR]\n[CN]y sus inmediaciones se disiparon."})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SCENARIO_BALANCE_FLAG = 3 -- $SCENARIO_BALANCE_FLAG = 3 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SPECIAL_EPISODE_OPEN = SV.SkyVars.SPECIAL_EPISODE_OPEN or {}; SV.SkyVars.SPECIAL_EPISODE_OPEN[1] = 1 -- $SPECIAL_EPISODE_OPEN[1] = 1 (ROM)
  SkyProg.set(12, 0) -- $SCENARIO_MAIN = scn[12,0] (ROM)
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayFanfare("Fanfare/Note") end) -- me_Play(7) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]The Exploration Team Federation\n[CN]has sent a message...[W:30]", french="[CN]La Fédération des Equipes d'Exploration\n[CN]a envoyé un message...[W:30]", german="[CN]Der Erkundungsteamverband\n[CN]hat eine Nachricht geschickt...[W:30]", italian="[CN]Arriva un messaggio della Federazione\n[CN]Squadre d'Esplorazione![W:30]", spanish="[CN]La Federación de Exploradores\n[CN]ha enviado un mensaje...[W:30]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayFanfare("Fanfare/LevelUp") end) -- me_Play(1) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN][hero]'s team was rewarded!\n[CN]Its Treasure Bag is now bigger![W:100]", french="[CN]L'équipe de [hero] est récompensée!\n[CN]Son Sac à Trésor s'agrandit![W:100]", german="[CN]Das Team von [hero] wird belohnt!\n[CN]Sein Schatzbeutel wurde vergrößert![W:100]", italian="[CN]La squadra di [hero] riceve in premio\n[CN]una Sacca dei tesori più capiente![W:100]", spanish="[CN]¡El equipo de [hero] fue recompensado\n[CN]con una Bolsa mayor![W:100]"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]You can now carry more\n[CN]items than you could before!", french="[CN]Désormais, vous pouvez transporter\n[CN]plus d'objets qu'auparavant!", german="[CN]Du kannst jetzt mehr\n[CN]Items als bisher tragen!", italian="[CN]Adesso potrete trasportare molti più\n[CN]strumenti di prima!", spanish="[CN]¡Ahora puedes llevar\n[CN]más objetos que antes!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]Wait...[K]\n[CN]There's one more message.", french="[CN]Tiens...[K]\n[CN]Il y a un autre message.", german="[CN]Augenblick...[K]\n[CN]Da ist noch eine Nachricht.", italian="[CN]Un momento...[K]\n[CN]C'è un altro messaggio.", spanish="[CN]Espera...[K]\n[CN]Hay un mensaje más."})
  -- message_Close
  -- back_SetGround(LEVEL_P17P01A) [neutre/état moteur]
  -- supervision_Acting(10) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayFanfare("Fanfare/JoinTeam") end) -- me_Play(5) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]The Special Episode\n[CN]\"Igglybuff the Prodigy\"\n[CN]has been unlocked![W:90]", french="[CN]L'Episode Spécial\n[CN]\"Toudoudou le Surdoué\"\n[CN]est maintenant disponible![W:90]", german="[CN]Die Bonusepisode\n[CN][F:S2]Wundersamer Fluffeluff[F:E2]\n[CN]wurde freigeschaltet![W:90]", italian="[CN]L'episodio speciale\n[CN]\"Igglybuff il genio\"\n[CN]è ora disponibile![W:90]", spanish="[CN]Se ha desbloqueado\n[CN]el capítulo especial\n[CN]\"Igglybuff es un prodigio\".[W:90]"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]To play a Special Episode,\n[CN]select it from the Episode List\n[CN]on the Top Menu.", french="[CN]Pour jouer à un Episode Spécial,\n[CN]sélectionnez-le dans la Liste des épisodes\n[CN]à partir du menu principal.", german="[CN]Um eine Bonusepisode zu spielen,\n[CN]wähle sie in der Episodenliste\n[CN]im Hauptmenü aus.", italian="[CN]Per giocare a un episodio speciale,\n[CN]selezionalo dalla lista episodi\n[CN]nel menu principale.", spanish="[CN]Para jugar a un capítulo especial,\n[CN]elígelo en la lista de capítulos\n[CN]del menú principal."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN]If you would like to play the Special Episode,\n[CN]save your adventure progress, and\n[CN]return to the Top Menu.", french="[CN]Si vous souhaitez jouer à cet Episode Spécial,\n[CN]sauvegardez d'abord votre aventure\n[CN]puis retournez au menu principal.", german="[CN]Wenn du eine Bonusepisode spielen\n[CN]möchtest, speichere deinen Spielstand\n[CN]und kehre zum Hauptmenü zurück.", italian="[CN]Se vuoi giocare all'episodio speciale,\n[CN]salva i progressi della tua avventura\n[CN]e torna al menu principale.", spanish="[CN]Si quieres jugar al capítulo especial,\n[CN]guarda tu progreso y\n[CN]vuelve al menú principal."})
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(60)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
