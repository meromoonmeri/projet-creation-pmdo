-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/s03p0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SkyProg.set(29, 41) -- $SCENARIO_MAIN = scn[29,41] (ROM)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 320, 232, Direction.Down, "NPC_KIMAWARI")
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Have you two heard about the\n[CS:P]Surrounded Sea[CR]?", french="Avez-vous déjà entendu parler\nde la [CS:P]Mer Fermée[CR]?", german="Habt ihr beide schon mal etwas\nvom [CS:P]Ringmeer[CR] gehört?", italian="Avete sentito parlare del\n[CS:P]Mar Cinto[CR]?", spanish="¿Habéis oído hablar del [CS:P]Mar[CR]\n[CS:P]Circundante[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="The [CS:P]Surrounded Sea[CR] is a sea\nfar in the south.", french="La [CS:P]Mer Fermée[CR] est loin\nau sud.", german="Das [CS:P]Ringmeer[CR] ist ein Meer\ntief im Süden.", italian="Il [CS:P]Mar Cinto[CR] è un mare\nche si trova a sud, lontano da qui.", spanish="El [CS:P]Mar Circundante[CR] es un mar\nmeridional."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="It's an uncharted part of the\nocean. And can you imagine? It's been encased\nin ice over tens of thousands of years.", french="C'est une partie inexplorée de\nl'océan, restée gelée pendant des dizaines\nde milliers d'années. Hallucinant, non?", german="Es liegt im unkartografierten\nTeil des Ozeans. Und, stellt euch vor, es war\nZehntausende von Jahren mit Eis bedeckt.", italian="È una parte inesplorata\ndell'oceano. E indovinate un po'? È ricoperto\ndai ghiacci da più di diecimila anni.", spanish="Es una parte aún inexplorada del\nocéano. ¿Os imagináis? Ha estado congelada\ndurante miles de años."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="But word is spreading about a\nrecent discovery there! They say that there's\nnow a break in the ice!", french="Mais à en croire la rumeur, il y\na eu de nouvelles découvertes! Une ouverture\nse serait creusée dans la glace!", german="Aber es macht das Wort von\neiner Entdeckung die Runde! Es heißt, es\ngebe dort jetzt einen Riss im Eis!", italian="Ma gira voce che sia stata fatta\nuna scoperta eccezionale da quelle parti! Si\ndice che adesso ci sia una crepa nel ghiaccio!", spanish="Corre el rumor de que el hielo\nse está resquebrajando."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="That gap opened a way for\nexplorers to go into that enclosed sea!", french="Cette faille permet aux\nexplorateurs d'entrer dans cette mer close!", german="Diese Spalte hat für Erkunder\neinen Einstieg in das eingeschlossene Meer\neröffnet!", italian="Questa crepa ha aperto una\nstrada per arrivare al [CS:P]Mar Cinto[CR].", spanish="Hay una grieta por la que los\nexploradores pueden adentrarse en esa\nzona."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Oh my gosh! Can you imagine it?\nA world that no one has seen for tens of\nthousands of years!", french="Ben mince alors! Vous imaginez?\nUn monde que nul n'a jamais contemplé pendant\ndes dizaines de milliers d'années!", german="Auweia! Könnt ihr euch das\nvorstellen? Eine Welt, die seit Zehntausenden\nvon Jahren niemand erblickt hat!", italian="Shock! Riuscite a crederci?\nUn mondo che nessuno vede da più\ndi diecimila anni!", spanish="¿Te lo imaginas? ¡Un lugar\nque nadie ha visto en miles de años!"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="This is the stuff of sweeping\nepics! So dreamy and adventurous!", french="C'est comme ça que commencent\ntous les bons récits d'aventure! Ça doit être\nun endroit hyper exotique! Le rêve, quoi!", german="Das ist der Stoff, aus dem\nepische Abenteuer gestrickt sind!\nSo fantastisch und abenteuerlich!", italian="Una cosa davvero epica!\nUn'avventura da sogno!", spanish="¡Es algo épico! ¡Una aventura de\nensueño!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Oh, but that's not all! No, no, no!\nApparently, the world's ocean currents all\ncourse through the [CS:P]Surrounded Sea[CR].", french="Oh, mais ce n'est pas tout! Non,\nnon, non! Tous les courants océaniques du\nmonde passent par la [CS:P]Mer Fermée[CR].", german="Oh, das ist noch nicht alles!\nNein, nein, nein! Anscheinend fließen alle\nOzeanströmungen der Welt durchs [CS:P]Ringmeer[CR].", italian="Oh, ma non è tutto! No, no, no!\nPare che le correnti dell'oceano passino\ntutte dal [CS:P]Mar Cinto[CR].", spanish="¡Y eso no es todo! Al parecer,\ntodas las corrientes oceánicas atraviesan\nel [CS:P]Mar Circundante[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="I've heard rumors that many\nrare treasures are carried there by\nthe currents!", french="J'ai entendu dire que des\ntrésors rares sont charriés par ces courants!", german="Ich habe Gerüchte gehört, dass\nviele seltene Schätze von den Strömungen\ndorthin getragen werden!", italian="Ho sentito dire che le\ncorrenti trascinano molti preziosi tesori!", spanish="He oído rumores de que muchos\ntesoros poco comunes son transportados\npor las corrientes..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Oh my gosh! Just thinking that\nis enough to make me feel faint!", french="Ben mince alors! Rien que d'y\npenser, j'en attrape des vertiges! Oh là là!", german="Auweia! Allein der\nGedanke daran lässt mich fast ohnmächtig\nwerden!", italian="Shock! Il solo pensiero\nè sufficiente a farmi svenire!", spanish="¡Supergenial! ¡Casi me desmayo\ncon solo pensarlo!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="The [CS:P]Surrounded Sea[CR]'s entrance\nis supposedly east of [CS:P]Blizzard Island[CR].", french="D'après les rumeurs, l'entrée de\nla [CS:P]Mer Fermée[CR] se trouverait à l'est de l'[CS:P]Ile\nBlizzard[CR].", german="Der Eingang zum [CS:P]Ringmeer[CR]\nsoll östlich der [CS:P]Blizzardinsel[CR] liegen.", italian="L'ingresso che conduce al [CS:P]Mar\nCinto[CR] si troverebbe ad est dell'[CS:P]Isola Tormenta[CR].", spanish="El acceso al [CS:P]Mar Circundante[CR]\nestá, en teoría, al este de la [CS:P]Isla Ventisca[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="You should go for a look\nyourselves!", french="Vous devriez aller y jeter un\npetit coup d'œil par vous-mêmes! Et alors,\nqu'est-ce qu'on dit?", german="Ihr solltet euch das mal selbst\nansehen!", italian="Dovreste andare a dare\nun'occhiata da quelle parti!", spanish=" ¡Deberíais ir a echar un vistazo!"})
  -- message_Close
  GAME:FadeOut(false, 30)
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetLevel(8) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(51) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetArrow(51) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  -- worldmap_BlinkMark(51) [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayFanfare("Fanfare/NewArea") end) -- me_Play(6) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="[CN]You can now go to\n[CN]the [CS:P]Surrounded Sea[CR]!", french="[CN]Désormais, vous pouvez vous rendre\n[CN]à la [CS:P]Mer Fermée[CR]!", german="[CN]Du kannst jetzt zum\n[CN][CS:P]Ringmeer[CR] gehen!", italian="[CN]Adesso potete andare\n[CN]al [CS:P]Mar Cinto[CR]!", spanish="[CN]¡Ahora ya puedes ir\n[CN]al [CS:P]Mar Circundante[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[50] = 1 -- dungeon_mode(50) = DMODE_OPEN (ROM)
  GAME:FadeIn(30)
  SkySceneKit.cleanup_npcs()
end
