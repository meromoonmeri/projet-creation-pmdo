-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D47P11A/n08a1108.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V17P01A) [décor sub chargé: Sub_v17p01a]
  -- back_SetGround(LEVEL_D47P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 21.5, 17>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n8 = SkySceneKit.spawn_npc("dusknoir", 416, 144, Direction.Left, "NPC_YONOWAARU_N8")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  SkySubScreen.Show("v17p01a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DARK_WASTELAND non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 232, 168, false, 2)
  GROUND:MoveToPosition(npc_npc_yonowaaru_n8, 232, 140, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:EntTurn(hero, Direction.Up)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Once we're through this\nwasteland, we should be close to\n[CS:P]Temporal Tower[CR].", french="Une fois que nous aurons passé\nce désert, la [CS:P]Tour du Temps[CR] ne sera plus\ntrès loin.", german="Wenn wir erst dieses Ödland\ndurchquert haben, sollten wir bereits nah am\n[CS:P]Zeitturm[CR] sein.", italian="Dopo aver superato questa zona\ndesolata, dovremmo essere in vista\ndella [CS:P]Torre del Tempo[CR].", spanish="En cuanto salgamos de este páramo,\nestaremos cerca de la [CS:P]Torre del Tiempo[CR]."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Let's get a move on!", french=" Dépêchons!", german=" Nun lass uns schon aufbrechen!", italian=" Sbrighiamoci!", spanish=" ¡Hay que seguir avanzando!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Down)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Compose yourself.[K] We need\nto prepare before we go.", french="Du calme et du sang-froid.[K]\nNous devons nous préparer avant de partir.", german="Sei ruhig und entspanne dich.[K]\nWir sollten gut vorbereitet weiterziehen.", italian="Datti una calmata.[K] Prima\ndi partire dobbiamo prepararci.", spanish="No te lances tanto.[K] Sería mejor\nprepararnos antes de continuar."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="If you rush too much,\nyou'll fail.", french=" La précipitation sera ta perte.", german="Wenn du dich zu sehr sputest,\nwirst du mit Sicherheit scheitern.", italian="Se ci facciamo prendere\ndalla fretta, rischiamo di non farcela.", spanish=" Si te precipitas, fracasarás."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Keep a leash on your impatience.", french="Tâche de maîtriser ton\nimpatience.", german=" Zügele deine Ungeduld.", italian=" Tieni a freno la tua impazienza.", spanish="La impaciencia no es buena.\nDebes contenerte."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Hah![K] Don't boss me around,\n[CS:N]Dusknoir[CR]!", french="Rhaaa![K] Arrête de jouer au petit\nchef, [CS:N]Noctunoir[CR]!", german="Ha![K] Du musst mir nichts\nerklären, [CS:N]Zwirrfinst[CR]!", italian="Ah![K] Non dirmi cosa devo fare,\n[CS:N]Dusknoir[CR]!", spanish="¡Ja![K] ¿Quién te has creído\nque eres para darme consejos, [CS:N]Dusknoir[CR]?"})
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
