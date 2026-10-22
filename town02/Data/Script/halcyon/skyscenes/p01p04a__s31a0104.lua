-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P04A/s31a0104.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_SPINDAS_CAFE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_P01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_patchiiru = SkySceneKit.spawn_npc("spinda", 352, 176, Direction.Down, "NPC_PATCHIIRU")
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Yes, that's absolutely right. You\nsure do know your stuff.", french="Oui, c'est exactement ça.\nJe suis impressionné.", german="Ja, das stimmt absolut! Da hat\naber jemand seine Hausaufgaben gemacht.", italian="Sì, è proprio così! Sei davvero\nben informato.", spanish="Sí, estás en lo cierto. Veo que\nestás bien informado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_bariyaado = SkySceneKit.spawn_npc("mr_mime", 296, 208, Direction.Right, "NPC_BARIYAADO")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bariyaado, npc_npc_patchiiru, 4) end)
  local npc_npc_nyuura = SkySceneKit.spawn_npc("sneasel", 272, 192, Direction.DownRight, "NPC_NYUURA")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_nyuura, npc_npc_patchiiru, 4) end)
  local npc_npc_rediba = SkySceneKit.spawn_npc("ledyba", 264, 224, Direction.UpRight, "NPC_REDIBA")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_rediba, npc_npc_patchiiru, 4) end)
  GAME:WaitFrames(3)
  local npc_npc_nyorotono = SkySceneKit.spawn_npc("politoed", 288, 232, Direction.Up, "NPC_NYOROTONO")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_nyorotono, npc_npc_patchiiru, 4) end)
  local npc_npc_sutoraiku = SkySceneKit.spawn_npc("scyther", 392, 256, Direction.UpLeft, "NPC_SUTORAIKU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sutoraiku, npc_npc_patchiiru, 4) end)
  GAME:WaitFrames(4)
  local npc_npc_togepii = SkySceneKit.spawn_npc("togepi", 320, 216, Direction.UpLeft, "NPC_TOGEPII")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_togepii, npc_npc_patchiiru, 4) end)
  local npc_npc_jiguzaguma = SkySceneKit.spawn_npc("zigzagoon", 352, 208, Direction.Left, "NPC_JIGUZAGUMA")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_jiguzaguma, npc_npc_patchiiru, 4) end)
  local npc_npc_herakurosu = SkySceneKit.spawn_npc("heracross", 376, 216, Direction.Left, "NPC_HERAKUROSU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_herakurosu, npc_npc_patchiiru, 4) end)
  local npc_npc_zanguusu = SkySceneKit.spawn_npc("zangoose", 352, 248, Direction.UpLeft, "NPC_ZANGUUSU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zanguusu, npc_npc_patchiiru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_patchiiru, 4) end)
  GAME:WaitFrames(5)
  local npc_npc_sandopan = SkySceneKit.spawn_npc("sandslash", 312, 256, Direction.Up, "NPC_SANDOPAN")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sandopan, npc_npc_patchiiru, 4) end)
  local npc_npc_okutan = SkySceneKit.spawn_npc("octillery", 408, 200, Direction.Left, "NPC_OKUTAN")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_okutan, npc_npc_patchiiru, 4) end)
  local npc_npc_pachirisu = SkySceneKit.spawn_npc("pachirisu", 424, 192, Direction.Left, "NPC_PACHIRISU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pachirisu, npc_npc_patchiiru, 4) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_patchiiru, 4) end)
  local npc_npc_yamikarasu = SkySceneKit.spawn_npc("murkrow", 424, 232, Direction.Left, "NPC_YAMIKARASU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamikarasu, npc_npc_patchiiru, 4) end)
  local npc_npc_kagebouzu = SkySceneKit.spawn_npc("shuppet", 440, 216, Direction.Left, "NPC_KAGEBOUZU")
  GROUND:EntTurn(npc_npc_kagebouzu, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Just as [CS:N]Mr. Mime[CR] said,\n[CS:P]Sky Peak[CR] has not been fully explored...", french="Comme [CS:N]M. Mime[CR] vient de le\ndire, le [CS:P]Pic Céleste[CR] n'a pas encore été\nentièrement exploré.", german="Genau wie [CS:N]Pantimos[CR] gerade\ngesagt hat, wurde der [CS:P]Himmelsgipfel[CR] noch\nnicht vollkommen erkundet...", italian="Come ha detto [CS:N]Mr. Mime[CR],\nil [CS:P]Picco del Cielo[CR] non è stato ancora\nesplorato del tutto...", spanish="Como ha dicho [CS:N]Mr. Mime[CR], la\n[CS:P]Cumbre del Cielo[CR] no se ha explorado\nen su totalidad..."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="So it still holds\nmany mysteries.", french="Il recèle donc encore\nbien des mystères.", german="Daher birgt er noch viele\nGeheimnisse.", italian="Quindi nasconde ancora\nmolti misteri.", spanish=" Así que aún encierra muchos misterios."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="High enough to reach beyond the\nsky![K] A mysterious mountain that still holds\nmany secrets...", french="Un sommet si haut qu'il touche\nle ciel![K] Une mystérieuse montagne qui recèle\nencore bien des secrets...", german="Hoch genug, um über den Himmel\nhinauszuragen![K] Ein mysteriöser Berg\nvoller Geheimnisse...", italian="Una montagna misteriosa che\nnasconde ancora molti segreti...[K] Talmente\nalta da superare addirittura le nuvole!", spanish="¡Es tan alta que se eleva más allá del\ncielo![K] Se trata de una montaña misteriosa\nque aún oculta innumerables secretos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, "happy", 1) end)
  -- SetAnimation(26) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="That sounds like enough to catch\nthe interest of any explorer!", french="Voilà qui est suffisant pour\npiquer la curiosité de n'importe\nquel explorateur!", german="Das klingt doch nach dem Stoff,\naus dem Erkunder-Träume sind!", italian="Mi pare che ce ne sia\nabbastanza per solleticare la curiosità\ndi qualsiasi esploratore!", spanish="¡Con eso ya se debería captar\nel interés de cualquier explorador!"})
  -- message_KeyWait
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Let's go and see!\nSee for ourselves!", french="Allons l'explorer!\nDécouvrons ses mystères!", german="Lasst uns aufbrechen und es\nherausfinden! Auf eigene Faust!", italian="Andiamo a vedere con i nostri\nocchi!", spanish="¡Hay que ir a verla con nuestros\npropios ojos!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="If that's what you're thinking,\nthen we are ready to fulfill that wish\nthrough Project P...", french="Si c'est bien là votre souhait,\nalors le Projet P va vous permettre\nde le réaliser!", german="Wenn ihr auch der Meinung seid,\ndann sind wir bereit, diesen Wunsch mithilfe\nvon Projekt P zu erfüllen.", italian="Se è quello a cui state pensando,\nallora possiamo realizzare il vostro desiderio\ngrazie al Progetto P...", spanish="Si eso es lo que estáis pensando,\nese deseo puede hacerse realidad gracias al\nProyecto P..."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="We've been working on\nreclaiming the path to [CS:P]Sky Peak[CR]...", french="Nous avons passé du temps à\nouvrir une voie vers le [CS:P]Pic Céleste[CR]...", german="Wir waren damit beschäftigt,\nden Pfad zum [CS:P]Himmelsgipfel[CR] wieder passierbar\nzu machen...", italian="Abbiamo lavorato per\nripristinare il sentiero che conduce\nal [CS:P]Picco del Cielo[CR]...", spanish="Hemos trabajado muy duro para\nrecuperar el sendero que lleva hasta\nla [CS:P]Cumbre del Cielo[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(26) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="And finally, a couple of days\nago...[K]we succeeded!", french="Et il y a seulement quelques\njours...[K] nous avons enfin atteint notre but!", german="Und nun, vor ein paar Tagen...[K]\nDa ist es uns gelungen!", italian="E un paio di giorni fa...[K]\nci siamo finalmente riusciti!", spanish="Y por fin, hace solo un par de días...[K]\n¡lo logramos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, nil, 0) end) -- EFFECT_NONE
  -- GAP: se_Play(6669) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_nyorotono, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamikarasu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, "happy", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: URRÀ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- se_FadeOut(6669, 60) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  pcall(function() GROUND:CharSetEmote(npc_npc_nyorotono, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_yamikarasu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(30)
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" Furthermore! Fur-ther-more!", french="Mais ce n'est pas tout!\nIl y a MIEUX!", german="Darüber hinaus!\nDa-rü-ber hi-naus!", italian=" Un momento! Un mo-men-to!", spanish=" Y eso no es todo... ¡Además!..."})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Not only did we succeed in\nreclaiming the path...", french="Nous n'avons pas uniquement\nouvert une nouvelle voie...", german="Wir haben nicht nur den Pfad\nwieder passierbar gemacht...", italian="Non solo siamo riusciti\na ripristinare il sentiero...", spanish="No solo hemos conseguido recuperar\nel sendero..."})
  -- message_KeyWait
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(26) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="We also made a discovery! At\nthe base of the mountain, we found a small,\nhidden village!", french="Nous avons également fait une\ndécouverte majeure! Au pied de la montagne\nse niche un petit village caché!", german="Wir haben auch eine Entdeckung\ngemacht! Am Fuße des Berges haben wir ein\nkleines, verstecktes Dorf gefunden!", italian="... ma abbiamo anche fatto una\nscoperta! Alla base della montagna, abbiamo\nrinvenuto un piccolo villaggio nascosto!", spanish="¡También hemos hallado algo!\nAl pie de la montaña hemos encontrado una\naldea oculta."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6669) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_rediba, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_togepii, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sutoraiku, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sandopan, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamikarasu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: URRÀ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- se_FadeOut(6669, 60) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  pcall(function() GROUND:CharSetEmote(npc_npc_rediba, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_togepii, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_sutoraiku, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_sandopan, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_yamikarasu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="A hidden village!\nThat makes me think of ninjas or something!", french="Un village caché!\nÇa me fait penser à un repaire de brigands ou\nquelque chose comme ça!", german="Ein verstecktes Dorf! Das lässt\nmich an Ninjas denken! Oder so was Ähnliches!", italian="Un villaggio nascosto!\nMagari ci vivono dei ninja o qualcosa di simile!", spanish="¡Una aldea oculta!\n¡A lo mejor hay ninjas escondidos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Yep! Of course, it's not a\nvillage of ninjas...", french="Oui, naturellement, il ne s'agit\npas d'un repaire de brigands...", german="Ja! Aber natürlich ist es kein\nDorf voller Ninjas...", italian="Bah! Non è affatto un villaggio\ndi ninja...", spanish="¡Sí! Bueno, no, por supuesto,\nno se trata de ninguna aldea de ninjas..."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Instead, some very rare\nPokémon known as [CS:K]Shaymin[CR] live there.", french="Ce lieu abrite des Pokémon très\nrares, connus sous le nom de [CS:K]Shaymin[CR].", german="Dort leben sehr seltene\nPokémon namens [CS:K]Shaymin[CR].", italian="Al contrario, ci vivono dei\nPokémon molto rari, noti come [CS:K]Shaymin[CR].", spanish="Pero sí que está habitada por unos\nPokémon poco comunes que se llaman [CS:K]Shaymin[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_nyorotono, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english=" [CS:K]Shaymin[CR]?", french=" Des [CS:K]Shaymin[CR]?", german=" [CS:K]Shaymin[CR]?", italian=" [CS:K]Shaymin[CR]?", spanish=" ¿[CS:K]Shaymin[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Yes. I'm afraid I don't\nknow much about them either...", french="Oui. J'ai bien peur de ne pas\nposséder beaucoup d'informations\nà leur sujet...", german="Genau. Leider weiß ich auch\nnicht sehr viel über sie.", italian="Già. Nemmeno io ne so molto\nsu di loro...", spanish="Sí, pero me temo que yo\ntampoco sé mucho sobre ellos..."})
  -- message_KeyWait
  -- SetAnimation(5) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" But they are incredibly cute! ♪", french="... mais ils sont adorables\ncomme tout! ♪", german="Abgesehen davon, dass sie\nunsagbar süß sind! ♪", italian="Ma sono assolutamente\nadorabili! ♪", spanish=" Eso sí, ¡son monísimos! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english=" C-cute...", french=" Adorables...", german=" S-süß...", italian=" A-Adorabili...", spanish=" Mo... monos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_sandopan.Position; GROUND:MoveToPosition(npc_npc_sandopan, p.X+(0), p.Y+(-12), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english=" I-I'm interested...", french=" Mmh... intéressant...", german=" D-die möchte ich sehen...", italian=" I-Interessante...", spanish=" Eso... me interesa..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" Furthermore!", french=" En outre!", german=" Darüber hinaus!", italian=" Ma non è finita!", spanish=" ¡Por si fuera poco!..."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="According to the survey\nteam's report...", french="Si l'on en croit le rapport\nde l'équipe de reconnaissance...", german="Es gibt einen Report des\nVermessungsteams...", italian="Secondo il rapporto\ndella squadra di indagine...", spanish="Según el informe del equipo\nde reconocimiento..."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="On the outskirts of the [CS:P]Shaymin[CR]\n[CS:P]Village[CR], they've found a mountain path to the\n[CS:P]Sky Peak[CR] Summit!", french="... aux abords du\n[CS:P]Village Shaymin[CR], se trouverait un chemin\nmenant au [CS:P]Sommet du Pic Céleste[CR]!", german="Diesem zufolge haben sie am\nRand von [CS:P]Shaymin-Dorf[CR] einen Pfad zur Spitze\ndes [CS:P]Himmelsgipfels[CR] entdeckt!", italian="Ai margini del [CS:P]Villaggio Shaymin[CR]\nè stato scoperto un sentiero che conduce\nsulla cima del [CS:P]Picco del Cielo[CR]!", spanish="A las afueras de [CS:P]Aldea Shaymin[CR],\n¡han hallado un sendero alpino que conduce\na la mismísima cima de la [CS:P]Cumbre del Cielo[CR]!"})
  -- message_KeyWait
  -- SetAnimation(5) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" This is a huge discovery!", french=" C'est une découverte colossale!", german=" Das ist eine riesige Entdeckung!", italian="Si tratta di una\nscoperta sensazionale!", spanish=" ¡Es un gran hallazgo!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="This mountain has not been\nproperly surveyed in some time...", french="Cette montagne n'ayant pas été\ninspectée de fond en comble depuis\nbien longtemps...", german="Dieser Berg wurde noch niemals\nvernünftig erschlossen.", italian="Questa montagna non è stata\noggetto di esplorazioni per molto tempo...", spanish="Hace tiempo que no se explora\ndebidamente esa montaña."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Piles of treasure![K]\nOpportunities for new discoveries![K]\nSo I think!", french="... il faut s'attendre...[K] à trouver\ndes trésors en pagaille![K] A faire des\ndécouvertes sensationnelles! C'est mon avis!", german="Schätze in Massen![K]\nMöglichkeiten für neue Entdeckungen![K] Daran\ndenke ich!", italian="Montagne di tesori![K]\nPossibilità di fare nuove scoperte![K]\nÈ così che la vedo io!", spanish="¡Puede haber montones de tesoros![K]\n¡Y muchas cosas nuevas por descubrir![K]\nAl menos, eso es lo que pienso..."})
  -- message_KeyWait
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Furthermore, legend says that\nthere is an incredible treasure hidden\nthere that rivals all other treasure!", french="En outre, une légende dit qu'un\ntrésor extraordinaire y est caché, qui\nsurpasserait les plus beaux trésors!", german="Darüber hinaus existiert eine\nLegende, laut der sich auf dem Berg ein Schatz\nbefindet, der prächtiger ist als alle anderen!", italian="Inoltre, la leggenda narra che ci\nsia un tesoro nascosto talmente incredibile\nda far impallidire tutti gli altri!", spanish="Además, cuenta la leyenda que\nhay un tesoro sensacional escondido allí,\ncomo ningún otro del que hayáis oído hablar."})
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5138) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_rediba, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_togepii, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sutoraiku, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sandopan, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamikarasu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: URRÀ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_okutan, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english=" Treasure!", french=" Des trésors en pagaille!", german=" Schätze!", italian=" Tesori!", spanish=" ¡Montones de tesoros!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_okutan, nil, 0) end) -- EFFECT_NONE
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english=" Discoveries!", french=" Des découvertes sensationnelles!", german=" Entdeckungen!", italian=" Scoperte!", spanish=" ¡Y cosas por descubrir!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english=" Woooonderful!", french=" Fabuleuuuuux!", german=" Wuuundervoll!", italian=" Grandioooso!", spanish=" ¡Qué maravilla!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Yes!\nAnd it is all waiting for you!", french="Oui, mes amis!\nEt toutes ces merveilles n'attendent que vous!", german="Genau!\nUnd all das wartet auf euch!", italian="Sì! E non aspettano altro che\nil vostro arrivo!", spanish=" ¡Sí, sí! ¡Y todo eso os está esperando!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="I'll show you the location of the\n[CS:P]Shaymin Village[CR]!", french="Laissez-moi vous indiquer\nl'emplacement du [CS:P]Village Shaymin[CR]!", german="Ich werde euch die Position von\n[CS:P]Shaymin-Dorf[CR] zeigen!", italian="Vi mostrerò la posizione\ndel [CS:P]Villaggio Shaymin[CR]!", spanish="Voy a mostraros dónde está\n[CS:P]Aldea Shaymin[CR]."})
  -- se_FadeOut(5138, 60) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- message_Close
  GAME:FadeOut(false, 30)
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(176) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetArrow(176) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  -- worldmap_BlinkMark(176) [neutre/état moteur]
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[175] = 1 -- dungeon_mode(175) = DMODE_OPEN (ROM)
  pcall(function() SOUND:PlayFanfare("Fanfare/NewArea") end) -- me_Play(6) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CN]You can now go to\n[CN]the [CS:P]Shaymin Village[CR]!", french="[CN]Désormais, vous pouvez accéder\n[CN]au [CS:P]Village Shaymin[CR]!", german="[CN]Du kannst nun nach\n[CN][CS:P]Shaymin-Dorf[CR] gelangen!", italian="[CN]Ora potete andare\n[CN]al [CS:P]Villaggio Shaymin[CR]!", spanish="[CN]¡Ahora ya puedes ir a\n[CN][CS:P]Aldea Shaymin[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  pcall(function() GROUND:CharSetEmote(npc_npc_rediba, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_togepii, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_sutoraiku, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_sandopan, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_yamikarasu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="For more details, please direct\nyour requests to the Project P survey team\nalready on location.", french="Pour de plus amples\ninformations, adressez-vous à l'équipe\nde reconnaissance du Projet P déjà sur place.", german="Für weitere Details wendet euch\nbitte an das Projekt P-Vermessungsteam,\nwelches sich bereits vor Ort befindet.", italian="Per maggiori informazioni,\nmettetevi in contatto con la squadra di indagine\ndel Progetto P che si trova già sul luogo.", spanish="El equipo de reconocimiento\ndel Proyecto P, que ya está en la zona,\nos dará más detalles."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="So, everyone, let's get moving,\nwith hopes and dreams on our minds and\nsmiles on our faces!", french="Ainsi, mes amis, mettons-nous\nen route, des rêves plein la tête et le sourire\naux lèvres!", german="Nun gut, alle miteinander! Macht\neuch auf, voller Hoffnungen und Träume, und\nmit einem Lächeln auf dem Gesicht!", italian="Forza! Mettiamoci in cammino,\ncon i cuori gonfi di sogni e di speranze\ne i volti illuminati da un sorriso!", spanish="¡Así que vamos allá, con una sonrisa\nen el rostro, a buscar tesoros de ensueño!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5138) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(27) [anim idle native]
  local npc_npc_soonano = SkySceneKit.spawn_npc("wynaut", 328, 152, Direction.Down, "NPC_SOONANO")
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_soonansu = SkySceneKit.spawn_npc("wobbuffet", 376, 152, Direction.Down, "NPC_SOONANSU")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_rediba, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_togepii, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sutoraiku, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sandopan, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamikarasu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(3)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: URRÀ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(npc_npc_sutoraiku, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_sandopan, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(npc_npc_zanguusu, Direction.Down)
  GROUND:EntTurn(npc_npc_sutoraiku, Direction.Left)
  GROUND:EntTurn(npc_npc_sandopan, Direction.Right)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_bariyaado, Direction.Down)
  GROUND:EntTurn(npc_npc_nyorotono, Direction.Up)
  GROUND:EntTurn(npc_npc_togepii, Direction.Left)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_jiguzaguma, Direction.Right)
  GROUND:EntTurn(npc_npc_herakurosu, Direction.Left)
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_okutan, Direction.UpRight)
  GROUND:EntTurn(npc_npc_pachirisu, Direction.DownLeft)
  GAME:WaitFrames(7)
  GROUND:EntTurn(npc_npc_yamikarasu, Direction.Up)
  GROUND:EntTurn(npc_npc_kagebouzu, Direction.DownLeft)
  -- se_FadeOut(5138, 90) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GROUND:MoveToPosition(npc_npc_zanguusu, 348, 340, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_sutoraiku, 348, 340, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_sandopan, 348, 340, false, 2)
  GROUND:EntTurn(npc_npc_nyuura, Direction.DownRight)
  GAME:WaitFrames(40)
  do local p=npc_npc_nyuura.Position; GROUND:MoveToPosition(npc_npc_nyuura, p.X+(-88), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(16), 32, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" This is awesome, [hero]!", french=" C'est génial, [hero]!", german=" Das ist spitze, [hero]!", italian=" È fantastico, [hero]!", spanish=" ¡Qué pasada, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" This is so cool, [hero]!", french=" C'est génial, [hero]!", german=" Das ist so cool, [hero]!", italian=" Grandioso, [hero]!", spanish=" ¡Cómo mola, [hero]!"})
  else
  SkySceneKit.say({english=" This is so cool, [hero]!", french=" C'est génial, [hero]!", german=" Das ist so cool, [hero]!", italian=" Grandioso, [hero]!", spanish=" ¡Es genial, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Did you hear that?\nPiles of treasure! New discoveries!", french="Tu as entendu ça?\nDes tonnes de trésors et de découvertes!", german="Hast du das gehört?\nBerge an Schätzen und neue Entdeckungen!", italian="Hai sentito?\nMontagne di tesori e nuove scoperte!", spanish="¿Lo has oído?\n¡Montones de tesoros y cosas por descubrir!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Did you hear that?\nPiles of treasure! New discoveries!", french="Tu as entendu ça?\nDes tonnes de trésors et de découvertes!", german="Hast du das gehört?\nBerge an Schätzen und neue Entdeckungen!", italian="Hai sentito?\nMontagne di tesori e nuove scoperte!", spanish="¿Lo has oído?\n¡Montones de tesoros y cosas por descubrir!"})
  else
  SkySceneKit.say({english="Did you hear that?\nPiles of treasure! New discoveries!", french="Tu as entendu ça?\nDes tonnes de trésors et de découvertes!", german="Hast du das gehört?\nBerge an Schätzen und neue Entdeckungen!", italian="Hai sentito?\nMontagne di tesori e nuove scoperte!", spanish="¿Lo has oído?\n¡Montones de tesoros y cosas por descubrir!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'd really like to meet these\n[CS:K]Shaymin[CR], so we should go!", french="J'aimerais vraiment rencontrer\nces [CS:K]Shaymin[CR], alors on devrait y aller!", german="Ich möchte wirklich gerne\ndiese [CS:K]Shaymin[CR] treffen, also lass uns gehen!", italian="Forza, andiamo! Non vedo l'ora\ndi incontrare questi Pokémon [CS:K]Shaymin[CR]...", spanish="Me encantaría conocer\na los [CS:K]Shaymin[CR], ¡deberíamos ir!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm really interested in meeting\nthese [CS:K]Shaymin[CR], so we should go!", french="J'aimerais vraiment rencontrer\nces [CS:K]Shaymin[CR], alors on devrait y aller!", german="Diese [CS:K]Shaymin[CR] zu treffen klingt\nwirklich interessant, also lass uns gehen!", italian="Forza, andiamo! Sono proprio\ncurioso di conoscere i Pokémon [CS:K]Shaymin[CR]...", spanish="Me interesaría mucho conocer a\nlos [CS:K]Shaymin[CR], ¡podríamos ir!"})
  else
  SkySceneKit.say({english="I'd love to meet these [CS:K]Shaymin[CR]!\nLet's go!", french="J'aimerais vraiment rencontrer\nces [CS:K]Shaymin[CR], alors on devrait y aller!", german="Ich möchte so gerne diese\n[CS:K]Shaymin[CR] treffen, also lass uns gehen!", italian="Vorrei tanto incontrare\ni Pokémon [CS:K]Shaymin[CR]! Andiamo!", spanish="Me encantaría conocer a\nlos [CS:K]Shaymin[CR], ¿por qué no vamos?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 60)
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  GROUND:TeleportTo(hero, 360, 268, Direction.Down)
  GROUND:TeleportTo(partner, 332, 268, Direction.Down)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(30)
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_P01P04A, 'US31') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(11) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(12) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(13) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:FadeIn(30)
  SkySceneKit.cleanup_npcs()
end
