-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D53P11A/n09a1208.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- switch(ProcessSpecial(4, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- back_SetGround(LEVEL_D53P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_yonowaaru_n9 = SkySceneKit.spawn_npc("dusknoir", 256, 160, Direction.Right, "NPC_YONOWAARU_N9")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_serebii = SkySceneKit.spawn_npc("celebi", 296, 152, Direction.Right, "NPC_SEREBII")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 224, 176, Direction.Right, "NPC_YAMIRAMI")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_yamirami2 = SkySceneKit.spawn_npc("sableye", 264, 200, Direction.Right, "NPC_YAMIRAMI2")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_yamirami3 = SkySceneKit.spawn_npc("sableye", 216, 208, Direction.Right, "NPC_YAMIRAMI3")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 168, 192, Direction.Right, "NPC_YAMIRAMI4")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GAME:MoveCamera(252, 180, 60, false) end) -- performer/caméra
  -- GAP: BGM BGM_TEMPORAL_PINNACLE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Did he really go this way?", french=" Est-il vraiment parti par là?", german=" Ist er wirklich hier entlang?", italian="È andato veramente da questa\nparte?", spanish=" ¿Seguro que se ha ido por aquí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru_n9, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami, npc_npc_yonowaaru_n9, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami2, npc_npc_yonowaaru_n9, 4) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami3, npc_npc_yonowaaru_n9, 4) end)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Y-yes.[K] There's no mistaking it.", french=" Oui.[K] Sans l'ombre d'un doute.", german=" J-ja.[K] Zweifellos.", italian=" S-Sì.[K] Non c'è dubbio.", spanish=" Sí.[K] No hay error posible."})
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="Master [CS:N]Dialga[CR] was enveloped in\nthis light...", french="Maître [CS:N]Dialga[CR] était entouré\nd'un halo de lumière...", german="Meister [CS:N]Dialga[CR] war\nin ein helles Licht getaucht...", italian="Il Maestro [CS:N]Dialga[CR] era avvolto\nda una strana luce...", spanish=" [CS:N]Dialga[CR] estaba envuelto en esa luz..."})
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="And then he vanished in the\ndirection of this awesomely\nvast mountain...", french="Ensuite, il a disparu en direction\nde ce vaste glacier...", german="Und dann verschwand er in\nRichtung dieses riesigen Berges...", italian="E poi è svanito in direzione\ndi questa montagna gigantesca...", spanish="Y luego desapareció en dirección a\nuna enorme montaña..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(3, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" It's hopeless...", french=" C'est sans espoir...", german=" Es ist hoffnungslos...", italian=" Non c'è speranza...", spanish=" No hay nada que hacer..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "exclaim", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "exclaim", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yamirami, Direction.UpRight)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami3, npc_npc_serebii, 4) end)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_yamirami2, Direction.UpRight)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.UpRight)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_serebii, 4) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru_n9, npc_npc_serebii, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" What's wrong, [CS:N]Celebi[CR]?", french=" Qu'y a-t-il, [CS:N]Celebi[CR]?", german=" Was ist los, [CS:N]Celebi[CR]?", italian=" Cosa succede, [CS:N]Celebi[CR]?", spanish=" ¿Qué pasa, [CS:N]Celebi[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_serebii, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(3, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="At the pinnacle of this\nmountain, there's a Passage of Time.", french="Il y a un Couloir du Temps\nau pinacle.", german="Auf der Spitze dieses Berges\ngibt es einen Zeittunnel.", italian="Sulla vetta di questa montagna\nc'è un Portale del Tempo.", spanish="En la cúspide de esa montaña\nhay un Pasaje del Tiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami3, "shock", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "exclaim", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- message_FacePositionOffset(3, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" You know what's strange!?", french=" Et c'est étrange...", german=" Weißt du, was eigenartig ist?!?", italian=" E sai cosa c'è di strano?!", spanish=" ¿Sabéis lo que me extraña?"})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="Even though I was caught,\nI never said where the Passage of Time was...", french="Je ne leur ai jamais révélé\nl'emplacement du Couloir du Temps...", german="Während meiner Gefangenschaft\nhabe ich den genauen Ort des Zeittunnels\nnicht preisgegeben...", italian="Anche dopo la mia cattura, non\nho mai rivelato dove si trovasse il Portale\ndel Tempo...", spanish="Aunque me atraparon, jamás revelé\ndónde estaba el Pasaje del Tiempo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Master [CS:N]Dialga[CR] went into even\nmore of a rampage.", french="Maître [CS:N]Dialga[CR] dévaste tout\nsur son passage.", german="Meister [CS:N]Dialga[CR]\nagierte geradezu tobsüchtig.", italian="Il Maestro [CS:N]Dialga[CR] è in preda\nalla furia più cieca.", spanish="[CS:N]Dialga[CR] ahora está más furioso\nque nunca."})
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami, npc_npc_yonowaaru_n9, 4) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami3, npc_npc_yonowaaru_n9, 4) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami2, npc_npc_yonowaaru_n9, 4) end)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.UpRight)
  GAME:WaitFrames(2)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_serebii, npc_npc_yonowaaru_n9, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" He's no longer acting rationally.", french=" Il a perdu la raison.", german="Er ist anscheinend nicht mehr\nHerr seiner Sinne.", italian="Ormai ha perso completamente\nla ragione.", spanish=" Ya no actúa racionalmente."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Maybe his instinct, pressed by\nhis increased ferociousness...", french="Guidé sans doute par son\ninstinct et sa férocité accrue...", german="Vielleicht wurde er von seinem\nInstinkt, angepeitscht durch die erhöhte\nWildheit, dazu bewegt...", italian="Forse il suo istinto, dominato\ndalla sua incontenibile ferocia...", spanish="Tal vez sea el instinto de\nsupervivencia, combinado con esa ferocidad..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Made him head for the\nPassage of Time.", french="... il est parti en direction du\nCouloir du Temps.", german="Sein Ziel ist offenbar\nder Zeittunnel.", italian="... lo ha guidato verso il\nPortale del Tempo.", spanish="Lo que le haya hecho dirigirse\ndirectamente al Pasaje del Tiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="If [CS:N]Dialga[CR] were to hit the\nPassage of Time while he's not\nin his right mind...", french="Si [CS:N]Dialga[CR] entrait dans le Couloir\ndu Temps dans cet état...", german="Wenn [CS:N]Dialga[CR] in seinem jetzigen,\nverwirrten Zustand den Zeittunnel angreift...", italian="Se [CS:N]Dialga[CR] dovesse raggiungerlo\nnelle condizioni in cui si trova...", spanish="Si [CS:N]Dialga[CR] llegase al Pasaje del Tiempo\nfuera de sus cabales..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" What would happen, [CS:N]Dusknoir[CR]?", french=" Que se passerait-il, [CS:N]Noctunoir[CR]?", german="Was, glaubst du, würde dann\npassieren, [CS:N]Zwirrfinst[CR]?", italian=" Che cosa accadrebbe, [CS:N]Dusknoir[CR]?", spanish=" ¿Qué ocurriría, [CS:N]Dusknoir[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru_n9, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" If that occurs...", french=" Eh bien...", german=" Wenn das passiert...", italian=" Se succedesse...", spanish=" Si eso ocurre..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Now that the world has finally\nstarted to move...[K]I don't know\nwhat would happen...", french="... maintenant que le monde a\nrecommencé à se mouvoir...[K] je ne sais ce qui\nse passerait...", german="Jetzt, da die Welt endlich\nwieder in Bewegung ist...[K] Ich kann mir nicht\nausmalen, was dann passieren würde...", italian="Ora che il mondo ha ricominciato\na muoversi...[K] non so cosa potrebbe accadere...", spanish="Ahora que el mundo al fin ha\ncomenzado a moverse...[K] No sé lo que pasaría."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" We need to stop him quickly...", french="Nous devons l'arrêter\nau plus vite...", german="Wir müssen das um jeden\nPreis verhindern.", italian=" Dobbiamo fermarlo in fretta...", spanish="Tenemos que pararle los pies\ncuanto antes."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_serebii, hero, 4) end)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="The light has gotten much\nbrighter, huh?", french="C'est moi ou la lumière est de\nplus en plus vive?", german="Seht! Das Licht ist viel heller\ngeworden, nicht wahr?", italian="La luce è diventata molto più\nluminosa, eh?", spanish="Ahora la luz brilla mucho más,\n¿verdad?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ... (The sun is rising.)", french=" ... (Le soleil se lève.)", german=" ...(Die Sonne geht auf.)", italian=" ... (Il sole sta sorgendo.)", spanish=" Ah... (Está saliendo el sol.)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" (Dawn is near.)", french=" (L'aube est proche.)", german=" (Bald bricht der Tag an.)", italian=" (L'alba si avvicina.)", spanish=" (Se acerca el amanecer.)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" It took a long time to recover.", french="Il a fallu du temps pour\nque ça se rétablisse.", german=" Die Erholung hat lange gedauert.", italian="Ci è voluto molto tempo\nper riprendersi.", spanish="Ha hecho falta mucho tiempo\npara que ocurriera."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_serebii, npc_npc_yonowaaru_n9, 4) end)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" From here on, [CS:Y]Grovyle[CR] and I...", french=" Désormais, [CS:Y]Massko[CR], moi...", german="[CS:Y]Reptain[CR] und ich\nwerden ab hier...", italian=" Da qui in avanti io, [CS:Y]Grovyle[CR]...", spanish=" A partir de aquí, [CS:Y]Grovyle[CR] y yo..."})
  GROUND:EntTurn(hero, Direction.UpLeft)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="And [CS:N]Celebi[CR], we'll move as a\ngroup of three.", french=" ... et [CS:N]Celebi[CR] ferons équipe.", german="Wir werden zusammen mit\n[CS:N]Celebi[CR] ein Dreierteam bilden.", italian="... e [CS:N]Celebi[CR] ci muoveremo\ninsieme.", spanish="¡Y también [CS:N]Celebi[CR]! Seguiremos\nadelante en un grupo de tres."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="We need to fight as hard as we\npossibly can to stop Master [CS:N]Dialga[CR]...", french="Nous devrons donner tout ce que\nnous avons pour arrêter Maître [CS:N]Dialga[CR]...", german="Wir müssen alles in unserer\nMacht Stehende tun, um\nMeister [CS:N]Dialga[CR] aufzuhalten...", italian="Dobbiamo lottare con tutte le\nnostre forze per fermare il Maestro [CS:N]Dialga[CR]...", spanish="Lucharemos con todas nuestras\nfuerzas para detener a [CS:N]Dialga[CR]..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="But, on the other hand, we'll be\nfar less mobile if we bring the [CS:N]Sableye[CR] along.", french="Emmener les [CS:N]Ténéfix[CR] ne ferait\nque nous ralentir.", german="Aber die [CS:N]Zobiris[CR] mitzunehmen\nwürde unsere Bewegungsfreiheit einschränken.", italian="D'altro canto, se portassimo\ni [CS:N]Sableye[CR] con noi, rischieremmo di essere\ntroppo lenti.", spanish="Está claro que seremos mucho menos\nágiles si llevamos a los [CS:N]Sableye[CR]."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="If we're not in time, then that's\nthe end.", french="Si nous n'arrivons pas à temps,\nce sera la fin.", german="Wenn wir es nicht rechtzeitig\nschaffen, wäre das das Ende.", italian="Se non faremo in tempo,\nsarà la fine.", spanish="Si no llegamos a tiempo,\nentonces sí que será el final."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Understood.", french=" Compris.", german=" Verstanden.", italian=" Ricevuto.", spanish=" Entendido."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru_n9, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="All right.[K] Let's prepare, and\nthen let's go.", french="Bien.[K] Préparons-nous\net allons-y.", german="Also gut.[K] Lasst uns die nötigen\nVorbereitungen treffen und dann nichts wie los.", italian=" Bene.[K] Prepariamoci e andiamo.", spanish="Veo que ha quedado claro.[K]\nAhora, prepárate rápidamente y sigamos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_yamirami2, 260, 188, false, 2)
  GAME:WaitFrames(3)
  GROUND:MoveToPosition(npc_npc_yamirami3, 228, 196, false, 2)
  GAME:WaitFrames(2)
  GROUND:MoveToPosition(npc_npc_yamirami4, 204, 188, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yamirami3, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yamirami4, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.DownLeft)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(npc_npc_serebii, Direction.DownLeft)
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- message_FacePositionOffset(3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Master [CS:N]Dusknoir[CR]!", french=" Maître [CS:N]Noctunoir[CR]!", german=" Meister [CS:N]Zwirrfinst[CR]!", italian=" Maestro [CS:N]Dusknoir[CR]!", spanish=" [CS:N]Dusknoir[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yamirami2, Direction.Right)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" [CS:Y]Grovyle[CR]! [CS:N]Celebi[CR] too!", french=" [CS:Y]Massko[CR] et [CS:N]Celebi[CR] aussi!", german=" [CS:Y]Reptain[CR]! [CS:N]Celebi[CR]!", italian=" E anche voi, [CS:Y]Grovyle[CR]! [CS:N]Celebi[CR]!", spanish=" [CS:Y]Grovyle[CR], [CS:N]Celebi[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" What is it?", french=" Que se passe-t-il?", german=" Was ist denn?", italian=" Che succede?", spanish=" ¿Qué pasa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yamirami4, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yamirami2, Direction.Up)
  -- message_FacePositionOffset(3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" We're ready too!", french=" Nous sommes prêts!", german=" Wir sind auch bereit!", italian=" Anche noi siamo pronti!", spanish=" ¡Nosotros también estamos listos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="For the future...[K] Master [CS:N]Dialga[CR]\nneeds to come to his senses!", french="Pour le futur...[K] Maître [CS:N]Dialga[CR]\ndoit revenir à la raison!", german="Für eine bessere Zukunft![K]\nMeister [CS:N]Dialga[CR] muss einfach wieder zu\nSinnen kommen!", italian="Per salvare il futuro...[K]\nil Maestro [CS:N]Dialga[CR] deve ritornare in sé!", spanish="Por el futuro...[K] ¡Tenemos que\nconseguir que [CS:N]Dialga[CR] entre en razón!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_VAST_ICE_MOUNTAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Yes, I understand.[K] This is the\nfinal fight.", french="Soit. Je comprends.[K]\nC'est l'ultime bataille.", german="Ja, ich verstehe.[K]\nDas wird der finale Kampf sein.", italian="Sì, capisco.[K] Questa sarà\nla battaglia finale.", spanish="Sí, lo entiendo.[K] Esta es la lucha\nfinal."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="We must bring Master [CS:N]Dialga[CR]\nback to his senses.", french="Nous devons faire en sorte que\nMaître [CS:N]Dialga[CR] retrouve la raison.", german="Wir müssen Meister [CS:N]Dialga[CR]\nwieder zur Vernunft bringen.", italian="Dobbiamo fare in modo che\nil Maestro [CS:N]Dialga[CR] recuperi la ragione.", spanish="Tenemos que hacer que [CS:N]Dialga[CR]\nrecupere la cordura."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="... (That's right.[K] This is what\nI've been fighting for all this time.)", french="... (Exact.[K] C'est pour cette\nraison que je me suis battu tout ce temps.)", german="...(Er hat recht.[K] Dafür habe ich\ndie ganze Zeit gekämpft.)", italian="... (Giusto.[K] È tutto ciò per cui\nho lottato finora.)", spanish="Ah... (Así es.[K] Hemos luchado\ntodo este tiempo para eso.)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" (Just a little more.)", french=" (Encore un petit effort.)", german=" (Noch ein kleines bisschen.)", italian=" (Ancora un piccolo sforzo.)", spanish=" (Aguantemos solo un poco más.)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(60)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...Huh?[K] What was that?", french=" ... Hein?[K] Que se passe-t-il?", german=" ...Nanu![K] Was war das?", italian=" ... Uh?[K] Cos'è quella?", spanish=" ¿Eh?[K] ¿Qué ha sido eso?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(60)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="D-don't...[K]tell me...[K]\n(Don't tell me this is...!)", french="Ne me dites pas que...[K]\n(Ne me dites pas que c'est...!)", german="S-sag...[K] bloß nicht...[K]\n(Sag mir bloß nicht...)", italian="N-Non...[K] ditemi...[K]\n(Non ditemi che...!)", spanish="No...[K] me digas...[K]\n(¡No me digas que esto es...!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_serebii, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(3, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" ...Huh?", french=" ... Hein?", german=" ...Hmmm?", italian=" ... Uh?", spanish=" ¿Eh?"})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" [CS:Y]Grovyle[CR],[K] what's wrong?", french=" [CS:Y]Massko[CR],[K] qu'y a-t-il?", german=" [CS:Y]Reptain[CR],[K] was ist passiert?", italian=" [CS:Y]Grovyle[CR],[K] che succede?", spanish=" [CS:Y]Grovyle[CR]...[K] ¿qué sucede?"})
  -- message_Close
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.DownRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami4, hero, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami3, hero, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami2, hero, 4) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...[K]No...[K]it's nothing...", french=" ...[K] Rien...[K] Ce n'est rien...", german=" ...[K]Ach,[K] gar nichts...", italian=" ...[K] No...[K] Niente...", spanish=" No...[K] Tranquila.[K] No es nada."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...[K] ([c_name:NPC_HERO_FIRST]...[K]\nJust a little more...)", french="...[K] ([c_name:NPC_HERO_FIRST]...[K]\nEncore un petit effort...)", german="...[K]([c_name:NPC_HERO_FIRST]...[K]\nNur noch ein kleines bisschen...)", italian="...[K] ([c_name:NPC_HERO_FIRST]...[K]\nmanca poco...)", spanish="Uf...[K] ([c_name:NPC_HERO_FIRST]...[K]\nHay que aguantar un poco más...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(Everything we've done\nso far...)", french="(Tout ce que nous avons\naccompli jusqu'ici...)", german="(Alles, was wir\nbis jetzt erreicht haben...)", italian="(Tutto quello che abbiamo fatto\nfinora...)", spanish="(Todo lo que hemos hecho hasta\nahora...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(Just a little more and we can\nachieve our goals...)", french="(Encore un petit effort et nous\naurons atteint notre but...)", german="(Nur noch ein kleines bisschen,\ndann haben wir unser Ziel erreicht...)", italian="(Ancora un piccolo sforzo\ne raccoglieremo i frutti dei nostri\nsacrifici...)", spanish="(Solo un poco más y podremos\nconseguir lo que queríamos...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(Until the end where I\ndisappear...[K]lend me your strength!)", french="(Jusqu'à ma disparition...[K]\nprête-moi ta force!)", german="(Jetzt noch einmal die letzten\nKraftreserven mobilisieren!)", italian="(Fino al momento in cui\nscomparirò...[K] donami la tua forza!)", spanish="(Tengo que aguantar hasta el final...[K]\n¡Préstame tu fuerza!)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ([c_name:NPC_HERO_FIRST]!)", french=" ([c_name:NPC_HERO_FIRST]!)", german=" ([c_name:NPC_HERO_FIRST]!)", italian=" ([c_name:NPC_HERO_FIRST]!)", spanish=" (¡[c_name:NPC_HERO_FIRST]!)"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
