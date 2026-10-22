-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/s02p0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  SkyProg.set(29, 33) -- $SCENARIO_MAIN = scn[29,33] (ROM)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_bariyaado = SkySceneKit.spawn_npc("mr_mime", 176, 208, Direction.Down, "NPC_BARIYAADO")
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bariyaado, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_bariyaado, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bariyaado, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="Hello! You have been exploring\ntoday as usual, yes? So very energetic!", french="Oh, hello! Vous êtes encore en\nexploration, n'est-il pas? Pour moi, c'est\nformidable!", german="Hallo! Ihr habt den Tag wie\nimmer mit Erkunden verbracht, ja? Wie\nüberaus tatkräftig!", italian="Ciao! Avete passato anche oggi\nla giornata a esplorare? Siete instancabili!", spanish="¡Hola! Lleváis todo el día\nexplorando, ¿verdad? ¡Qué energía\nla vuestra!"})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="Have you heard? The tale of the\nfamous explorer [CS:N]Scizor[CR]?", french="Avez-vous déjà entendu parler\ndu very célèbre explorateur [CS:N]Cizayox[CR]?\nC'est une véritable légende!", german="Schon gehört? Die Geschichte\ndes großen Erkunders [CS:N]Scherox[CR]?", italian="Avete mai sentito la leggenda del\nfamoso esploratore [CS:N]Scizor[CR]?", spanish="¿Conocéis el relato del famoso\nexplorador [CS:N]Scizor[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="[CS:N]Scizor[CR] was an explorer\nextraordinaire whose fame stretched across\nthis very world.", french="[CS:N]Cizayox[CR] était un\nexplorateur extraordinaire dont la notoriété\nétait immense.", german="[CS:N]Scherox[CR] war ein Erkunder der\nExtraklasse, dessen Ruf sich weit über diese\nWelt hinaus verbreitet hat.", italian="[CS:N]Scizor[CR] era un esploratore\nfenomenale, la cui fama ha raggiunto ogni\nangolo del mondo.", spanish="[CS:N]Scizor[CR] era un extraordinario\nexplorador, famoso a lo largo y ancho de este\nmundo."})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="Truly, he had a reputation that\nall explorers aspired toward.", french="Comparés à lui, tous les\nexplorateurs se trouvaient si minables,\ntous aspiraient à devenir comme lui. Yes!", german="Wohl wahr, er hatte einen Ruf,\ndem alle Erkunder nacheiferten.", italian="Aveva davvero una reputazione\ninvidiata da tutti gli altri esploratori.", spanish="Todos aspiraban a alcanzar,\nalgún día, una reputación como la suya."})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="But this great explorer, he went\nmissing while he was exploring [CS:P]Blizzard Island[CR],\nfar in the southwest.", french="Mais un jour, ce great\nexplorateur disparut alors qu'il explorait\nl'[CS:P]Ile Blizzard[CR], loin au sud-ouest.", german="Aber dieser große Erkunder\nwurde als vermisst gemeldet, als er die\n[CS:P]Blizzardinsel[CR] tief im Südwesten erkundete.", italian="Ma di questo grande esploratore\nsi è persa ogni traccia da quando è partito alla\nvolta dell'[CS:P]Isola Tormenta[CR], a sud-ovest da qui.", spanish="Pero este gran explorador se\nperdió en una salida a la [CS:P]Isla Ventisca[CR], que\nse encuentra muy lejos de aquí, al suroeste."})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="Many an exploration team set\nout to rescue the great explorer.", french="De nombreuses équipes se\nlancèrent au secours du grand explorateur,\ncanailles comme héros.", german="Viele Erkundungsteams machten\nsich auf, um diesen großen Erkunder zu retten.", italian="Moltissime squadre\nd'esplorazione sono partite alla sua ricerca.", spanish="Muchos equipos de exploración\nfueron al rescate de [CS:N]Scizor[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="But one and all, they were\nturned back by the bitter cold and swirling\nblizzards till none dared try again.", french="Mais elles furent toutes\nrepoussées par le glacial froid et les cinglants\nblizzards. Personne n'osait plus y aller, no, no!", german="Doch ein Team nach dem anderen\ngab durch die bitterkalten, wirbelnden\nBlizzards auf, bis sich kein Team mehr wagte.", italian="Ma hanno tutte dovuto rinunciare\na causa del freddo e delle impetuose tormente.\nNessuno ha più osato andarci.", spanish="Pero las ventiscas y el frío\natroz terminaban doblegándolos y nadie\nse atrevía a volver."})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="It is a tale from many\nyears ago.", french="Cette légende remonte à de\nnombreuses années.", german="Diese Geschichte liegt viele\nJahre zurück.", italian=" È un racconto di molti anni fa.", spanish=" Es una historia muy antigua."})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="There also have been rumors.\nThey say that the explorer [CS:N]Scizor[CR] was\nsearching for an amazing treasure.", french="Il y a eu aussi des rumeurs.\nOn dit que l'explorateur [CS:N]Cizayox[CR] cherchait\nun trésor fabuleux. Oh my!", german="Dazu kamen viele Gerüchte. Eins\nlautete, dass der Erkunder [CS:N]Scherox[CR] nach einem\nunglaublichen Schatz gesucht habe.", italian="Alcuni sostengono che [CS:N]Scizor[CR]\nfosse alla ricerca di un fantastico tesoro.", spanish="También corrían rumores de\nque [CS:N]Scizor[CR] iba buscando un gran tesoro."})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="You're an incredible team,\nTeam [team:], what with saving the\nworld and all.", french="Vous êtes une équipe incroyable,\nEquipe [team:], vous avez sauvé le\nmonde et tout ça.", german="Ihr seid unglaublich, Team\n[team:], rettet die Welt und so.", italian="Siete davvero una squadra\nincredibile, Team [team:]! Se penso\na come avete salvato il mondo...", spanish="Sois increíbles, [CS:X]Equipo[CR]\n[team:], ¡y no solo por lo de\nsalvar el mundo!"})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="No exploration teams have gone\nto [CS:P]Blizzard Island[CR] since the rescue efforts\nwere called off years ago.", french="Aucune équipe ne\ns'est rendue sur l'[CS:P]Ile Blizzard[CR] depuis le\nrappel des sauveteurs il y a des années.", german="Kein Erkundungsteam hat sich\nauf die [CS:P]Blizzardinsel[CR] gewagt, seitdem die\nRettungsversuche damals scheiterten.", italian="Nessuna squadra d'esplorazione\nè stata all'[CS:P]Isola Tormenta[CR] da quando le\noperazioni di ricerca si sono interrotte anni fa.", spanish="Ningún equipo explorador ha ido\na la [CS:P]Isla Ventisca[CR] en muchos años, desde que\nse suspendió todo intento de rescate."})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="By any chance, would you be\nwilling to go, Team [team:]?", french="Vous n'auriez pas envie d'y aller,\npar hasard, Equipe [team:]?", german="Wäre das vielleicht etwas für\neuch, Team [team:]?", italian="A proposito, ve la sentireste\ndi andare, Team [team:]?", spanish="¿Por casualidad os apetecería ir,\n[CS:X]Equipo[CR] [team:]?"})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="I hear that [CS:P]Blizzard Island[CR] is in\nthe southwest of the map.", french="J'ai entendu dire que l'[CS:P]Ile\nBlizzard[CR] est au sud-ouest de la carte.", german="Wie ich gehört habe, liegt\ndie [CS:P]Blizzardinsel[CR] im\nSüdwesten der Karte.", italian="Ho sentito che l'[CS:P]Isola Tormenta[CR]\nsi trova a sud-ovest.", spanish="Creo que la [CS:P]Isla Ventisca[CR] está al\nsuroeste."})
  -- message_Close
  GAME:FadeOut(false,  15)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- worldmap_SetMode(3) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetLevel(6) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_ChangeLevel(7) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetCamera(47) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="[CN]The clouds lifted over the\n[CN][CS:P]Icy Area[CR] and its vicinities!", french="[CN]Les nuages se sont levés sur\n[CN]la [CS:P]Région Gelée[CR] et ses alentours.", german="[CN]Die Wolken haben sich über dem [CS:P]Eisgebiet[CR]\n[CN]und seiner Umgebung verzogen!", italian="[CN]Le nuvole si sollevano dalla\n[CN][CS:P]Zona Ghiacciata[CR] e dalle aree circostanti!", spanish="[CN]¡Las nubes que cubrían la\n[CN][CS:P]zona glacial[CR] y alrededores se han disipado!"})
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="[CN]And...", french="[CN]En outre...", german="[CN]Damit ist es möglich,", italian="[CN]E così...", spanish="[CN]Y..."})
  -- message_Close
  -- worldmap_BlinkMark(47) [neutre/état moteur]
  -- worldmap_SetArrow(47) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  pcall(function() SOUND:PlayFanfare("Fanfare/NewArea") end) -- me_Play(6) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="[CN]You can now go to\n[CN][CS:P]Blizzard Island[CR]!", french="[CN]Désormais, vous pouvez vous rendre\n[CN]sur l'[CS:P]Ile Blizzard[CR]!", german="[CN]dass du jetzt auf die\n[CN][CS:P]Blizzardinsel[CR] gelangen kannst!", italian="[CN]Ora potete andare\n[CN]all'[CS:P]Isola Tormenta[CR]!", spanish="[CN]¡Ahora puedes ir\n[CN]a la [CS:P]Isla Ventisca[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[46] = 1 -- dungeon_mode(46) = DMODE_OPEN (ROM)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(30)
  -- worldmap_SetLevel(8) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  SkySceneKit.cleanup_npcs()
end
