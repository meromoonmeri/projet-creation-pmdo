-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/s22p1501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_PLAYER
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(5) -- Lock(5) NDS
    GROUND:MoveToPosition(hero, 336, 220, false, 2)
    SkySceneKit.lock(6) -- Lock(6) NDS
    -- @label_12 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    GROUND:EntTurn(hero, Direction.DownRight)
    GAME:WaitFrames(30)
    GROUND:EntTurn(hero, Direction.Right)
    GAME:WaitFrames(60)
    GROUND:EntTurn(hero, Direction.DownLeft)
    GAME:WaitFrames(50)
    GROUND:EntTurn(hero, Direction.UpLeft)
    GAME:WaitFrames(50)
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  SkySceneKit.run_routine(function() -- def 2 for actor ACTOR_ATTENDANT1
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(8) -- Lock(8) NDS
    GROUND:MoveToPosition(partner, 272, 204, false, 2)
    SkySceneKit.unlock(3) -- Unlock(3) NDS
    SkySceneKit.lock(9) -- Lock(9) NDS
    GROUND:MoveToPosition(partner, 336, 204, false, 2)
    SkySceneKit.unlock(3) -- Unlock(3) NDS
    SkySceneKit.lock(10) -- Lock(10) NDS
    -- @label_13 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    GAME:WaitFrames(12)
    GROUND:EntTurn(partner, Direction.DownRight)
    GAME:WaitFrames(math.random(30, 60))
    GROUND:EntTurn(partner, Direction.UpRight)
    GAME:WaitFrames(math.random(60, 80))
    GROUND:EntTurn(partner, Direction.Down)
    GAME:WaitFrames(math.random(50, 70))
    GROUND:EntTurn(partner, Direction.Left)
    GAME:WaitFrames(50)
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  pcall(function() SOUND:StopBGM() end)
  -- GAP: BGM BGM_A_WISH_FOR_PEACE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  do local __sw = ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) -- switch($PARTNER_TALK_KIND) [GameVar PARTNER_TALK_KIND (genre partenaire)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]And that's how...", french="[CN]Et c'est ainsi...", german="[CN]Und so", italian="[CN]E così si conclude...", spanish="[CN]Y así..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]our fight against\n[CN][CS:N]Darkrai[CR] ended...", french="[CN]... que s'acheva notre combat\n[CN]contre [CS:N]Darkrai[CR]...", german="[CN]endete unser Kampf\n[CN]gegen [CS:N]Darkrai[CR]...", italian="[CN]... la nostra lotta con\n[CN][CS:N]Darkrai[CR].", spanish="[CN]Acabó nuestra pelea con\n[CN][CS:N]Darkrai[CR]..."})
  -- @label_3 [étiquette de flux ExplorerScript]
  -- message_Close
  -- back_SetGround(LEVEL_T01P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(30)
  GAME:WaitFrames(2) -- join WaitLockLives
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 288, 240, Direction.Left, "NPC_BIPPA")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 272, 192, Direction.Left, "NPC_HEIGANI")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_ruriri = SkySceneKit.spawn_npc("azurill", 416, 216, Direction.Left, "NPC_RURIRI")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 384, 208, Direction.Left, "NPC_KIMAWARI")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.unlock(8) -- Unlock(8) NDS
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  SkySceneKit.unlock(9) -- Unlock(9) NDS
  GROUND:EntTurn(npc_npc_heigani, Direction.DownRight)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 384, 176, Direction.DownLeft, "NPC_DIGUDA")
  GROUND:EntTurn(npc_npc_diguda, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpRight)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 384, 264, Direction.Left, "NPC_GUREGGURU")
  GROUND:EntTurn(npc_npc_guregguru, Direction.UpLeft)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 352, 168, Direction.DownLeft, "NPC_PUKURIN")
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 344, 248, Direction.Left, "NPC_DOGOOMU")
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  local npc_npc_suriipu = SkySceneKit.spawn_npc("drowzee", 392, 248, Direction.Left, "NPC_SURIIPU")
  GROUND:EntTurn(npc_npc_suriipu, Direction.UpLeft)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 320, 176, Direction.DownLeft, "NPC_PERAPPU")
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  local npc_npc_banebuu = SkySceneKit.spawn_npc("spoink", 328, 264, Direction.UpLeft, "NPC_BANEBUU")
  GROUND:EntTurn(npc_npc_banebuu, Direction.Up)
  SkySceneKit.lock(3) -- Lock(3) NDS
  GROUND:MoveToPosition(npc_npc_heigani, 304, 196, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 304, 220, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 352, 236, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_guregguru, 372, 244, false, 2)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 368, 240, Direction.UpLeft, "NPC_CHIRIIN")
  GROUND:MoveToPosition(npc_npc_chiriin, 372, 220, false, 2)
  GROUND:MoveToPosition(npc_npc_kimawari, 372, 204, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_pukurin, 352, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_perappu, 320, 184, false, 2)
  GROUND:MoveToPosition(npc_npc_banebuu, 324, 244, false, 2)
  GROUND:MoveToPosition(npc_npc_ruriri, 392, 216, false, 2)
  local npc_npc_mariru = SkySceneKit.spawn_npc("marill", 416, 200, Direction.Left, "NPC_MARIRU")
  GROUND:MoveToPosition(npc_npc_mariru, 392, 196, false, 2)
  GROUND:MoveToPosition(npc_npc_suriipu, 388, 236, false, 2)
  GROUND:EntTurn(npc_npc_heigani, Direction.DownRight)
  GROUND:EntTurn(npc_npc_bippa, Direction.Right)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  GROUND:EntTurn(npc_npc_guregguru, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Left)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Left)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GROUND:EntTurn(npc_npc_banebuu, Direction.Up)
  GROUND:EntTurn(npc_npc_suriipu, Direction.UpLeft)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_mariru, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_banebuu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  SkySceneKit.unlock(10) -- Unlock(10) NDS
  SkySceneKit.unlock(6) -- Unlock(6) NDS
  do local __sw = ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) -- switch($PARTNER_TALK_KIND) [GameVar PARTNER_TALK_KIND (genre partenaire)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]When we returned to Treasure Town...", french="[CN]A notre retour à Bourg-Trésor...", german="[CN]Wir kehrten nach Schatzstadt zurück.", italian="[CN]Al nostro ritorno a Borgo Tesoro...", spanish="[CN]Cuando regresamos a Aldea Tesoro..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]We were thrilled by how excited\n[CN]everyone was at our return!", french="[CN]... nous constatâmes avec bonheur que\n[CN]tout le monde était enchanté de nous revoir!", german="[CN]Wir waren begeistert darüber, wie aufgeregt\n[CN]alle unsere Rückkehr erwarteten!", italian="[CN]... proviamo una grande commozione per la\n[CN]calorosa accoglienza che ci attende!", spanish="[CN]¡Nos impresionó la expectación\n[CN]causada por nuestro regreso!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]We had been fully fooled\n[CN]by [CS:N]Darkrai[CR]...", french="[CN]Nous avions cru aux mensonges\n[CN]de [CS:N]Darkrai[CR]...", german="[CN]Wir waren gänzlich von\n[CN][CS:N]Darkrai[CR] getäuscht worden...", italian="[CN]Avevamo quasi dato ascolto alle subdole\n[CN]parole di [CS:N]Darkrai[CR]...", spanish="[CN][CS:N]Darkrai[CR] nos había engañado\n[CN]por completo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]So I had thought that neither [hero]\n[CN]nor I had a place in this world...", french="[CN]Au point de nous imaginer que ni [hero]\n[CN]ni moi n'avions notre place dans ce monde...", german="[CN]Deswegen dachte ich, dass weder für\n[CN][hero] noch für mich ein Platz in\n[CN]dieser Welt wäre...", italian="[CN]... arrivando a pensare che né [hero] né\n[CN]io ci meritassimo di stare in questo mondo.", spanish="[CN]Y pensaba que ni [hero]\n[CN]ni yo teníamos lugar en este mundo."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]But when everyone surrounded\n[CN]us and was glad to see us back...", french="[CN]Mais en voyant tout le monde accourir\n[CN]pour nous faire un chaleureux accueil...", german="[CN]Aber als sich alle um uns versammelten\n[CN]und froh waren, uns wiederzusehen...", italian="[CN]Ma vedere la gioia degli altri\n[CN]Pokémon al nostro ritorno...", spanish="[CN]Pero cuando todos nos rodearon\n[CN]y se alegraron de vernos..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]That's when I finally thought...[K]\n[CN]It's wonderful to be alive!", french="[CN]... je compris enfin...[K] que c'est\n[CN]merveilleux d'être en vie!", german="[CN]In dem Moment kam mir der Gedanke,[K]\n[CN]wie schön das Leben doch ist!", italian="[CN]... mi ha finalmente fatto capire...[K]\n[CN]che è bellissimo essere vivi!", spanish="[CN]Fue cuando pensé...[K]\n[CN]¡Qué maravilla estar aquí!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Little [CS:N]Azurill[CR] woke up\n[CN]from his nightmare...", french="[CN]Le petit [CS:N]Azurill[CR] fut tiré\n[CN]de son cauchemar...", german="[CN]Der kleine [CS:N]Azurill[CR] wachte\n[CN]aus seinem Albtraum auf...", italian="[CN]Il piccolo [CS:N]Azurill[CR] si è svegliato\n[CN]dal suo incubo.", spanish="[CN][CS:N]Azurill[CR] despertó\n[CN]de su pesadilla..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]I'm so glad that everyone was well.", french="[CN]Tout le monde allait bien.\n[CN]J'étais fou de joie.", german="[CN]Ich bin so froh, dass es allen gut geht.", italian="[CN]E sono felice di vedere che stanno tutti bene.", spanish="[CN]Me alegro tanto de que todos estén bien."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]I remember what [CS:N]Wigglytuff[CR] said...", french="[CN]Je me rappelle ce que\n[CN][CS:N]Grodoudou[CR] a dit...", german="[CN]Ich erinnere mich an die Worte\n[CN]von [CS:N]Knuddeluff[CR]...", italian="[CN]Mi ricordo le parole di [CS:N]Wigglytuff[CR]...", spanish="[CN]Recuerdo lo que dijo [CS:N]Wigglytuff[CR]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Every Pokémon in the\n[CN]world exists for a reason.", french="[CN]Chaque vie\n[CN]a un sens.", german="[CN]Jedes Pokémon hat seinen\n[CN]Platz in dieser Welt.", italian="[CN]Tutti i Pokémon in questo mondo\n[CN]esistono per un motivo.", spanish="[CN]Todos los Pokémon del mundo\n[CN]existen por una razón."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Even the ones that\n[CN]mean harm to others...", french="[CN]Même celle des Pokémon qui\n[CN]veulent du mal aux autres...", german="[CN]Sogar diejenigen,\n[CN]die anderen Übles wollen...", italian="[CN]Anche quelli che sono\n[CN]cattivi con gli altri...", spanish="[CN]Incluso los que desean\n[CN]el mal a los demás..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Even that [CS:N]Darkrai[CR].", french="[CN]Même celle de\n[CN][CS:N]Darkrai[CR].", german="[CN]Sogar [CS:N]Darkrai[CR].", italian="[CN]Persino [CS:N]Darkrai[CR].", spanish="[CN]Incluso [CS:N]Darkrai[CR]."})
  -- @label_7 [étiquette de flux ExplorerScript]
  -- message_Close
  GAME:FadeOut(false,  60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  do local __sw = ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) -- switch($PARTNER_TALK_KIND) [GameVar PARTNER_TALK_KIND (genre partenaire)]
  if __sw == 1 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]After all this...", french="[CN]Après toutes ces épreuves...", german="[CN]Nach allem, was geschehen ist,", italian="[CN]Dopo tutto quello che è successo...", spanish="[CN]Después de todo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]My adventures with\n[CN][hero] will continue...", french="[CN]... mes aventures avec [hero]\n[CN]ne font que commencer...", german="[CN]werden meine Abenteuer mit\n[CN][hero] weitergehen...", italian="[CN]... le mie avventure con\n[CN][hero] proseguiranno.", spanish="[CN]Mis aventuras con [hero] continuarán..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]We'll see many things...", french="[CN]Nous verrons des tas de choses...", german="[CN]Wir werden vieles sehen...", italian="[CN]Vedremo molte cose.", spanish="[CN]Veremos muchas cosas..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]And we'll make new discoveries.", french="[CN]... et ferons de grandes découvertes.", german="[CN]Und neue Entdeckungen machen.", italian="[CN]E faremo molte scoperte.", spanish="[CN]Haremos nuevos descubrimientos."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]We have gone back to\n[CN][CS:P]Luminous Spring[CR] since then...", french="[CN]Nous avons de nouveau tenté notre\n[CN]chance à la [CS:P]Source Lumineuse[CR]...", german="[CN]Wir sind seitdem zur\n[CN][CS:P]Glitzerquelle[CR] zurückgekehrt...", italian="[CN]Abbiamo fatto ritorno\n[CN]alla [CS:P]Sorgente Luccichio[CR].", spanish="[CN]Hemos vuelto al\n[CN][CS:P]Manantial Luminoso[CR]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Though we still can't evolve there.", french="[CN]... mais nous ne pouvons toujours pas évoluer.", german="[CN]Und das, obwohl wir uns dort immer\n[CN]noch nicht entwickeln können.", italian="[CN]Ma non possiamo ancora evolverci.", spanish="[CN]Pero seguimos sin poder evolucionar allí."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]However...", french="[CN]Cependant...", german="[CN]Wie auch immer...", italian="[CN]Tuttavia...", spanish="[CN]Sin embargo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]We can exist here!", french="[CN]... nous avons notre place dans ce monde!", german="[CN]Wir können hier existieren!", italian="[CN]Sì! Possiamo esistere in questo mondo!", spanish="[CN]¡Podemos existir!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]We can live here!", french="[CN]Nous pouvons y vivre!", german="[CN]Wir können hier leben!", italian="[CN]Possiamo rimanere qui!", spanish="[CN]¡Podemos vivir aquí!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]And that alone is something\n[CN]that we should be happy\n[CN]and grateful about!", french="[CN]Et rien que cela devrait\n[CN]suffire à nous remplir\n[CN]de joie et de gratitude!", german="[CN]Und schon dafür allein\n[CN]sollten wir glücklich\n[CN]und dankbar sein!", italian="[CN]E questo è sufficiente per farci sentire felici\n[CN]e pieni di gratitudine!", spanish="[CN]¡Y solo con eso\n[CN]ya podemos ser felices\n[CN]y mostrar agradecimiento!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]That's what I finally learned.", french="[CN]Voilà ce que j'ai enfin compris.", german="[CN]Das habe ich letztlich gelernt.", italian="[CN]Ecco cosa ho finalmente imparato.", spanish="[CN]Eso es lo que he aprendido."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Yes, [hero]!", french="[CN]Oui, [hero]!", german="[CN]Ja, [hero]!", italian="[CN]Sì, [hero]!", spanish="[CN]¡Sí, [hero]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Thank you for always being with me!", french="[CN]Merci d'être toujours à mes côtés!", german="[CN]Danke, dass du immer bei mir warst!", italian="[CN]Sono felice di averti al mio fianco!", spanish="[CN]¡Gracias por estar siempre a mi lado!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Let's keep on exploring!", french="[CN]Continuons à explorer!", german="[CN]Lass uns weiter auf Erkundung gehen!", italian="[CN]Continuiamo a esplorare!", spanish="[CN]¡Sigamos explorando!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]May our friendship last forever!", french="[CN]Puisse notre amitié durer toute l'éternité!", german="[CN]Möge unsere Freundschaft\n[CN]für immer bestehen!", italian="[CN]Che la nostra amicizia\n[CN]possa durare per sempre!", spanish="[CN]¡Y que nuestra amistad dure siempre!"})
  -- @label_11 [étiquette de flux ExplorerScript]
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(180) end)
  GAME:WaitFrames(180)
  SkyProg.set(29, 92) -- $SCENARIO_MAIN = scn[29,92] (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.REQUEST_CLEAR_COUNT = 0 -- $REQUEST_CLEAR_COUNT = 0 (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[44] = 3 -- dungeon_mode(44) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[46] = 3 -- dungeon_mode(46) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[47] = 3 -- dungeon_mode(47) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[50] = 3 -- dungeon_mode(50) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[51] = 3 -- dungeon_mode(51) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[54] = 3 -- dungeon_mode(54) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[62] = 3 -- dungeon_mode(62) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[64] = 3 -- dungeon_mode(64) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[67] = 3 -- dungeon_mode(67) = DMODE_OPEN_AND_REQUEST (ROM)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[5] = 1 -- $PERFORMANCE_PROGRESS_LIST[5] = 1 (ROM)
  GAME:WaitFrames(30)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  elseif __sw == 2 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]After all this...", french="[CN]Après toutes ces épreuves...", german="[CN]Nach allem, was geschehen ist,", italian="[CN]Dopo tutto quello che è successo...", spanish="[CN]Después de todo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]My adventures with\n[CN][hero] will continue...", french="[CN]... mes aventures avec [hero]\n[CN]ne font que commencer...", german="[CN]werden meine Abenteuer mit\n[CN][hero] weitergehen...", italian="[CN]... le mie avventure con\n[CN][hero] proseguiranno.", spanish="[CN]Mis aventuras con [hero] continuarán..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]We'll see many things...", french="[CN]Nous verrons des tas de choses...", german="[CN]Wir werden vieles sehen...", italian="[CN]Vedremo molte cose...", spanish="[CN]Veremos muchas cosas..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]And we'll make new discoveries.", french="[CN]... et ferons de grandes découvertes.", german="[CN]Und neue Entdeckungen machen.", italian="[CN]... e faremo molte scoperte.", spanish="[CN]Haremos nuevos descubrimientos."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]We have gone back to\n[CN][CS:P]Luminous Spring[CR] since then...", french="[CN]Nous avons de nouveau tenté notre\n[CN]chance à la [CS:P]Source Lumineuse[CR]...", german="[CN]Wir sind seitdem zur\n[CN][CS:P]Glitzerquelle[CR] zurückgekehrt...", italian="[CN]Abbiamo fatto nuovamente ritorno\n[CN]alla [CS:P]Sorgente Luccichio[CR].", spanish="[CN]Hemos vuelto al\n[CN][CS:P]Manantial Luminoso[CR]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Though we still can't evolve there.", french="[CN]... mais nous ne pouvons toujours pas évoluer.", german="[CN]Und das, obwohl wir uns dort immer\n[CN]noch nicht entwickeln können.", italian="[CN]Ma non possiamo ancora evolverci.", spanish="[CN]Pero seguimos sin poder evolucionar allí."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]However...", french="[CN]Cependant...", german="[CN]Wie auch immer...", italian="[CN]Tuttavia...", spanish="[CN]Sin embargo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]We can exist here!", french="[CN]... nous avons notre place dans ce monde!", german="[CN]Wir können hier existieren!", italian="[CN]... possiamo esistere in questo mondo!", spanish="[CN]¡Podemos existir!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]We can live here!", french="[CN]Nous pouvons y vivre!", german="[CN]Wir können hier leben!", italian="[CN]Possiamo rimanere qui!", spanish="[CN]¡Podemos vivir aquí!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]And that alone is something\n[CN]that we should be happy\n[CN]and grateful about!", french="[CN]Et rien que cela devrait\n[CN]suffire à nous remplir\n[CN]de joie et de gratitude!", german="[CN]Und schon dafür allein\n[CN]sollten wir glücklich\n[CN]und dankbar sein!", italian="[CN]E questo è sufficiente per farci sentire felici\n[CN]e pieni di gratitudine!", spanish="[CN]¡Y solo con eso\n[CN]ya podemos ser felices\n[CN]y mostrar agradecimiento!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]That's what I finally learned.", french="[CN]Voilà ce que j'ai enfin compris.", german="[CN]Das habe ich letztlich gelernt.", italian="[CN]Ecco cosa ho finalmente imparato.", spanish="[CN]Eso es lo que he aprendido."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Yes, [hero]!", french="[CN]Oui, [hero]!", german="[CN]Ja, [hero]!", italian="[CN]Sì, [hero]!", spanish="[CN]¡Sí, [hero]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Thank you for always being with me!", french="[CN]Merci d'être toujours à mes côtés!", german="[CN]Danke, dass du immer bei mir warst!", italian="[CN]Sono felice di averti al mio fianco!", spanish="[CN]¡Gracias por estar siempre a mi lado!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Let's keep on exploring!", french="[CN]Continuons à explorer!", german="[CN]Lass uns weiter auf Erkundung gehen!", italian="[CN]Continuiamo a esplorare!", spanish="[CN]¡Sigamos explorando!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]May our friendship last forever!", french="[CN]Puisse notre amitié durer toute l'éternité!", german="[CN]Möge unsere Freundschaft\n[CN]für immer bestehen!", italian="[CN]Che la nostra amicizia\n[CN]possa durare per sempre!", spanish="[CN]¡Y que nuestra amistad dure siempre!"})
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_10 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]After all this...", french="[CN]Après toutes ces épreuves...", german="[CN]Nach allem, was geschehen ist,", italian="[CN]Dopo tutto quello che è successo...", spanish="[CN]Después de todo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]My adventures with\n[CN][hero] will continue...", french="[CN]... mes aventures avec [hero]\n[CN]ne font que commencer...", german="[CN]werden meine Abenteuer mit\n[CN][hero] weitergehen...", italian="[CN]... le mie avventure con\n[CN][hero] proseguiranno.", spanish="[CN]Mis aventuras con [hero] continuarán..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]We'll see many things...", french="[CN]Nous verrons des tas de choses...", german="[CN]Wir werden vieles sehen...", italian="[CN]Vedremo molte cose.", spanish="[CN]Veremos muchas cosas..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]And we'll make new discoveries.", french="[CN]... et ferons de grandes découvertes.", german="[CN]und neue Entdeckungen machen.", italian="[CN]E faremo molte scoperte.", spanish="[CN]Haremos nuevos descubrimientos."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]We have gone back to\n[CN][CS:P]Luminous Spring[CR] since then...", french="[CN]Nous avons de nouveau tenté notre\n[CN]chance à la [CS:P]Source Lumineuse[CR]...", german="[CN]Wir sind seitdem zur\n[CN][CS:P]Glitzerquelle[CR] zurückgekehrt...", italian="[CN]Abbiamo visitato ancora la\n[CN][CS:P]Sorgente Luccichio[CR].", spanish="[CN]Hemos vuelto al\n[CN][CS:P]Manantial Luminoso[CR]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Though we still can't evolve there.", french="[CN]... mais nous ne pouvons toujours pas évoluer.", german="[CN]Und das, obwohl wir uns dort immer\n[CN]noch nicht entwickeln können.", italian="[CN]Ma non possiamo ancora evolverci.", spanish="[CN]Pero seguimos sin poder evolucionar allí."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]However...", french="[CN]Cependant...", german="[CN]Wie auch immer...", italian="[CN]Tuttavia...", spanish="[CN]Sin embargo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]We can exist here!", french="[CN]... nous avons notre place dans ce monde!", german="[CN]Wir können hier existieren!", italian="[CN]Sì! Possiamo esistere in questo mondo!", spanish="[CN]¡Podemos existir!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]We can live here!", french="[CN]Nous pouvons y vivre!", german="[CN]Wir können hier leben!", italian="[CN]Possiamo rimanere qui!", spanish="[CN]¡Podemos vivir aquí!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]And that alone is something\n[CN]that we should be happy\n[CN]and grateful about!", french="[CN]Et rien que cela devrait\n[CN]suffire à nous remplir\n[CN]de joie et de gratitude!", german="[CN]Und schon dafür allein\n[CN]sollten wir glücklich\n[CN]und dankbar sein!", italian="[CN]E questo è sufficiente per\n[CN]farci sentire felici e\n[CN]riconoscenti!", spanish="[CN]¡Y solo con eso\n[CN]ya podemos ser felices\n[CN]y mostrar agradecimiento!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]That's what I finally learned.", french="[CN]Voilà ce que j'ai enfin compris.", german="[CN]Das habe ich letztlich gelernt.", italian="[CN]Ecco cosa ho finalmente imparato.", spanish="[CN]Eso es lo que he aprendido."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Yes, [hero]!", french="[CN]Oui, [hero]!", german="[CN]Ja, [hero]!", italian="[CN]Sì, [hero]!", spanish="[CN]¡Sí, [hero]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Thank you for always being with me!", french="[CN]Merci d'être toujours à mes côtés!", german="[CN]Danke, dass du immer bei mir warst!", italian="[CN]Sono felice di averti al mio fianco!", spanish="[CN]¡Gracias por estar siempre a mi lado!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Let's keep on exploring!", french="[CN]Continuons à explorer!", german="[CN]Lass uns weiter auf Erkundung gehen!", italian="[CN]Continuiamo a esplorare!", spanish="[CN]¡Sigamos explorando!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]May our friendship last forever!", french="[CN]Puisse notre amitié durer toute l'éternité!", german="[CN]Möge unsere Freundschaft\n[CN]für immer bestehen!", italian="[CN]Che la nostra amicizia\n[CN]possa durare per sempre!", spanish="[CN]¡Y que nuestra amistad dure siempre!"})
  -- jump @label_11 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 2 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]When we returned to Treasure Town...", french="[CN]A notre retour à Bourg-Trésor...", german="[CN]Wir kehrten nach Schatzstadt zurück.", italian="[CN]Al nostro ritorno a Borgo Tesoro...", spanish="[CN]Cuando regresamos a Aldea Tesoro..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]We were thrilled by how excited\n[CN]everyone was at our return!", french="[CN]... nous constatâmes avec bonheur que\n[CN]tout le monde était enchanté de nous revoir!", german="[CN]Wir waren begeistert darüber, wie aufgeregt\n[CN]alle unsere Rückkehr erwarteten!", italian="[CN]... proviamo una grande commozione per la\n[CN]calorosa accoglienza che ci attende!", spanish="[CN]¡Nos impresionó la expectación\n[CN]causada por nuestro regreso!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]We had been fully fooled\n[CN]by [CS:N]Darkrai[CR]...", french="[CN]Nous avions cru aux mensonges\n[CN]de [CS:N]Darkrai[CR]...", german="[CN]Wir waren gänzlich von\n[CN][CS:N]Darkrai[CR] getäuscht worden...", italian="[CN]Avevamo quasi dato ascolto alle subdole\n[CN]parole di [CS:N]Darkrai[CR]...", spanish="[CN][CS:N]Darkrai[CR] nos había engañado\n[CN]por completo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]So I had thought that neither [hero]\n[CN]nor I had a place in this world...", french="[CN]Au point de nous imaginer que ni [hero]\n[CN]ni moi n'avions notre place dans ce monde...", german="[CN]Deswegen dachte ich, dass weder für\n[CN][hero] noch für mich ein Platz in\n[CN]dieser Welt wäre...", italian="[CN]... arrivando a pensare che né [hero] né\n[CN]io ci meritassimo di stare in questo mondo.", spanish="[CN]Y pensaba que ni [hero]\n[CN]ni yo teníamos lugar en este mundo."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]But when everyone surrounded\n[CN]us and was glad to see us back...", french="[CN]Mais en voyant tout le monde accourir\n[CN]pour nous faire un chaleureux accueil...", german="[CN]Aber als sich alle um uns versammelten\n[CN]und froh waren, uns wiederzusehen...", italian="[CN]Ma vedere la gioia degli altri\n[CN]Pokémon al nostro ritorno...", spanish="[CN]Pero cuando todos nos rodearon\n[CN]y se alegraron de vernos..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]That's when I finally thought...[K]\n[CN]It's wonderful to be alive!", french="[CN]... je compris enfin...[K] que c'est\n[CN]merveilleux d'être en vie!", german="[CN]In dem Moment kam mir der Gedanke,[K]\n[CN]wie schön das Leben doch ist!", italian="[CN]Mi ha finalmente fatto capire...[K]\n[CN]che è bellissimo essere vivi!", spanish="[CN]Fue cuando pensé...[K]\n[CN]¡Qué maravilla estar aquí!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Little [CS:N]Azurill[CR] woke up\n[CN]from his nightmare...", french="[CN]Le petit [CS:N]Azurill[CR] fut tiré\n[CN]de son cauchemar...", german="[CN]Der kleine [CS:N]Azurill[CR] wachte\n[CN]aus seinem Albtraum auf...", italian="[CN]Il piccolo [CS:N]Azurill[CR] si è svegliato\n[CN]dal suo incubo.", spanish="[CN][CS:N]Azurill[CR] despertó\n[CN]de su pesadilla..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]I'm so glad that everyone was well.", french="[CN]Tout le monde allait bien.\n[CN]J'étais fou de joie.", german="[CN]Ich bin so froh, dass es allen gut geht.", italian="[CN]E sono felice di vedere che stanno tutti bene.", spanish="[CN]Me alegro tanto de que todos estén bien."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]I remember what [CS:N]Wigglytuff[CR] said...", french="[CN]Je me rappelle ce que\n[CN][CS:N]Grodoudou[CR] a dit...", german="[CN]Ich erinnere mich an die Worte\n[CN]von [CS:N]Knuddeluff[CR]...", italian="[CN]Mi ricordo le parole di [CS:N]Wigglytuff[CR]...", spanish="[CN]Recuerdo lo que dijo [CS:N]Wigglytuff[CR]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Every Pokémon in the\n[CN]world exists for a reason.", french="[CN]Chaque vie\n[CN]a un sens.", german="[CN]Jedes Pokémon hat seinen\n[CN]Platz in dieser Welt.", italian="[CN]Tutti i Pokémon in questo mondo\n[CN]esistono per un motivo.", spanish="[CN]Todos los Pokémon del mundo\n[CN]existen por una razón."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Even the ones that\n[CN]mean harm to others...", french="[CN]Même celle des Pokémon qui\n[CN]veulent du mal aux autres...", german="[CN]Sogar diejenigen,\n[CN]die anderen Übles wollen...", italian="[CN]Anche quelli che sono\n[CN]cattivi con gli altri...", spanish="[CN]Incluso los que desean\n[CN]el mal a los demás..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Even that [CS:N]Darkrai[CR].", french="[CN]Même celle de\n[CN][CS:N]Darkrai[CR].", german="[CN]Sogar [CS:N]Darkrai[CR].", italian="[CN]Persino [CS:N]Darkrai[CR].", spanish="[CN]Incluso [CS:N]Darkrai[CR]."})
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_6 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]When we returned to Treasure Town...", french="[CN]A notre retour à Bourg-Trésor...", german="[CN]Wir kehrten nach Schatzstadt zurück.", italian="[CN]Al nostro ritorno a Borgo Tesoro...", spanish="[CN]Cuando regresamos a Aldea Tesoro..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]We were thrilled by how excited\n[CN]everyone was at our return!", french="[CN]... nous constatâmes avec bonheur que\n[CN]tout le monde était enchanté de nous revoir!", german="[CN]Wir waren begeistert darüber, wie aufgeregt\n[CN]alle unsere Rückkehr erwarteten!", italian="[CN]... proviamo una grande commozione per la\n[CN]calorosa accoglienza che ci attende!", spanish="[CN]¡Nos impresionó la expectación\n[CN]causada por nuestro regreso!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]We had been fully fooled\n[CN]by [CS:N]Darkrai[CR]...", french="[CN]Nous avions cru aux mensonges\n[CN]de [CS:N]Darkrai[CR]...", german="[CN]Wir waren gänzlich von\n[CN][CS:N]Darkrai[CR] getäuscht worden...", italian="[CN]Avevamo quasi dato ascolto alle subdole\n[CN]parole di [CS:N]Darkrai[CR]...", spanish="[CN][CS:N]Darkrai[CR] nos había engañado\n[CN]por completo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]So I had thought that neither [hero]\n[CN]nor I had a place in this world...", french="[CN]Au point de nous imaginer que ni [hero]\n[CN]ni moi n'avions notre place dans ce monde...", german="[CN]Deswegen dachte ich, dass weder für\n[CN][hero] noch für mich ein Platz in\n[CN]dieser Welt wäre...", italian="[CN]... arrivando a pensare che né [hero] né\n[CN]io ci meritassimo di stare in questo mondo.", spanish="[CN]Y pensaba que ni [hero]\n[CN]ni yo teníamos lugar en este mundo."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]But when everyone surrounded\n[CN]us and was glad to see us back...", french="[CN]Mais en voyant tout le monde accourir\n[CN]pour nous faire un chaleureux accueil...", german="[CN]Aber als sich alle um uns versammelten\n[CN]und froh waren, uns wiederzusehen...", italian="[CN]Ma vedere la gioia degli altri\n[CN]Pokémon al nostro ritorno...", spanish="[CN]Pero cuando todos nos rodearon\n[CN]y se alegraron de vernos..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]That's when I finally thought...[K]\n[CN]It's wonderful to be alive!", french="[CN]... je compris enfin...[K] que c'est\n[CN]merveilleux d'être en vie!", german="[CN]In dem Moment kam mir der Gedanke,[K]\n[CN]wie schön das Leben doch ist!", italian="[CN]... mi ha finalmente fatto capire...[K]\n[CN]che è bellissimo essere viva!", spanish="[CN]Fue cuando pensé...[K]\n[CN]¡Qué maravilla estar aquí!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Little [CS:N]Azurill[CR] woke up\n[CN]from his nightmare...", french="[CN]Le petit [CS:N]Azurill[CR] fut tiré\n[CN]de son cauchemar...", german="[CN]Der kleine [CS:N]Azurill[CR] wachte\n[CN]aus seinem Albtraum auf...", italian="[CN]Il piccolo [CS:N]Azurill[CR] si è svegliato\n[CN]dal suo incubo.", spanish="[CN][CS:N]Azurill[CR] despertó\n[CN]de su pesadilla..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]I'm so glad that everyone was well.", french="[CN]Tout le monde allait bien.\n[CN]J'étais folle de joie.", german="[CN]Ich bin so froh, dass es allen gut geht.", italian="[CN]E sono felice di vedere che stanno tutti bene.", spanish="[CN]Me alegro tanto de que todos estén bien."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]I remember what [CS:N]Wigglytuff[CR] said...", french="[CN]Je me rappelle ce que\n[CN][CS:N]Grodoudou[CR] a dit...", german="[CN]Ich erinnere mich an die Worte\n[CN]von [CS:N]Knuddeluff[CR]...", italian="[CN]Mi ricordo le parole di [CS:N]Wigglytuff[CR]...", spanish="[CN]Recuerdo lo que dijo [CS:N]Wigglytuff[CR]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Every Pokémon in the\n[CN]world exists for a reason.", french="[CN]Chaque vie\n[CN]a un sens.", german="[CN]Jedes Pokémon hat seinen\n[CN]Platz in dieser Welt.", italian="[CN]Tutti i Pokémon in questo mondo\n[CN]esistono per un motivo.", spanish="[CN]Todos los Pokémon del mundo\n[CN]existen por una razón."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Even the ones that\n[CN]mean harm to others...", french="[CN]Même celle des Pokémon qui\n[CN]veulent du mal aux autres...", german="[CN]Sogar diejenigen,\n[CN]die anderen Übles wollen...", italian="[CN]Anche quelli che sono\n[CN]cattivi con gli altri...", spanish="[CN]Incluso los que desean\n[CN]el mal a los demás..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Even that [CS:N]Darkrai[CR].", french="[CN]Même celle de\n[CN][CS:N]Darkrai[CR].", german="[CN]Sogar [CS:N]Darkrai[CR].", italian="[CN]Persino [CS:N]Darkrai[CR].", spanish="[CN]Incluso [CS:N]Darkrai[CR]."})
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 2 then
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]And that's how...", french="[CN]Et c'est ainsi...", german="[CN]Und so", italian="[CN]E così si conclude...", spanish="[CN]Y así..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]our fight against\n[CN][CS:N]Darkrai[CR] ended...", french="[CN]... que s'acheva notre combat\n[CN]contre [CS:N]Darkrai[CR]...", german="[CN]endete unser Kampf\n[CN]gegen [CS:N]Darkrai[CR]...", italian="[CN]... la nostra lotta con\n[CN][CS:N]Darkrai[CR].", spanish="[CN]Acabó nuestra pelea con\n[CN][CS:N]Darkrai[CR]..."})
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_2 [étiquette de flux ExplorerScript]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]And that's how...", french="[CN]Et c'est ainsi...", german="[CN]Und so", italian="[CN]E così si conclude...", spanish="[CN]Y así..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]our fight against\n[CN][CS:N]Darkrai[CR] ended...", french="[CN]... que s'acheva notre combat\n[CN]contre [CS:N]Darkrai[CR]...", german="[CN]endete unser Kampf\n[CN]gegen [CS:N]Darkrai[CR]...", italian="[CN]... la nostra lotta con\n[CN][CS:N]Darkrai[CR].", spanish="[CN]Acabó nuestra pelea con\n[CN][CS:N]Darkrai[CR]..."})
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
