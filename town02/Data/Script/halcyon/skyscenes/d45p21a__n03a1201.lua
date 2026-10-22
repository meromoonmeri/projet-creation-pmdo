-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D45P21A/n03a1201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=42, sub=7} -- $SCENARIO_SIDE = scn[42,7] (ROM)
  -- back_SetGround(LEVEL_D45P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_aamarudo = SkySceneKit.spawn_npc("armaldo", 248, 424, Direction.Up, "NPC_AAMARUDO")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_FORTUNE_RAVINE_DEPTHS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 208, 292, false, 2)
  GROUND:MoveToPosition(npc_npc_aamarudo, 244, 292, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Master, where is this?", french=" Maître, où on est, là?", german=" Meister, wo sind wir?", italian=" Maestro, dove siamo?", spanish=" Maestro, ¿dónde estamos?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" This is a dungeon waypoint...", french=" C'est un passage intermédiaire...", german="Das ist eine Wegmarkierung\nfür den Dungeon...", italian="Questo è un passaggio intermedio\ndel dungeon...", spanish=" Es un territorio de paso..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="It connects to the depths of\n[CS:P]Fortune Ravine[CR]...[K] It's a waypoint area.", french="Il mène tout droit aux\nentrailles du [CS:P]Ravin Aubaine[CR]...", german="Von hier aus geht es in die\nTiefen der [CS:P]Schicksalsschlucht[CR]...[K] Sie dient als\nWegmarkierung.", italian="Collega questa zona al punto più\nprofondo della [CS:P]Gola del Tesoro[CR]...", spanish="Se comunica...[K] con las profundidades\ndel [CS:P]Risco Fortuna[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I see. ♪", french=" Je vois. ♪", german=" Ach so. ♪", italian=" Capisco. ♪", spanish=" Entiendo. ♪"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="So we'll be in the depths\nsoon, then. ♪", french="On devrait atteindre bientôt\nles entrailles du donjon, alors. ♪", german="Also werden wir bald die Tiefen\nerreichen. ♪", italian="Quindi presto arriveremo\nin fondo al dungeon. ♪", spanish="Así que pronto habremos llegado\na la zona más profunda. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" That's right...[K] I'm sure of it...", french=" C'est exact...[K] J'en suis sûr...", german="Ganz genau.[K]\nDa bin ich mir sicher...", italian=" Esatto...[K] Ne sono sicuro...", spanish=" Exacto...[K] No me cabe duda..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="While we're on the subject of\nwaypoints in dungeons...", french="En parlant de passages\nintermédiaires dans les donjons...", german="Wo wir uns gerade über\nWegmarkierungen in Dungeons unterhalten...", italian="E a proposito dei punti di\ncollegamento dei dungeon...", spanish="Ahora que hablamos de las zonas\nde paso de los territorios..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Finding a waypoint usually\nmeans that something awaits you at the end.", french="Quand tu trouves un tel passage,\nça veut dire en général que quelque chose\nt'attend au-delà.", german="Wegmarkierungen zu erreichen,\nbedeutet in der Regel, dass dich am Ende\nirgendetwas erwartet.", italian="Quando si arriva in un luogo del\ngenere, di solito c'è qualcosa che si nasconde\nin fondo.", spanish="Encontrarlas suele querer decir\nque hay algo aguardando al final."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Something awaits...[K] Like what?", french="Que quelque chose m'attend...[K]\nComme quoi?", german="Etwas erwartet uns...[K]\nWas kann das sein?", italian=" Qualcosa che si nasconde...[K] Tipo?", spanish=" Algo aguardando...[K] ¿Como qué?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="For example...[K] The boss of\nthis dungeon.", french="Par exemple...[K]\nLe boss d'un donjon.", german="Zum Beispiel...[K] Der Boss dieses\nDungeons.", italian="Ad esempio...[K] il boss\ndi questo dungeon.", spanish="Por ejemplo...[K] El jefe de este\nterritorio."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Boss?", french=" Le boss?", german=" Boss?", italian=" Il boss?", spanish=" ¿El jefe?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Yes, that's right.", french=" Oui, c'est ça.", german=" Ja, ganz genau.", italian=" Già, proprio così.", spanish=" Sí, eso mismo."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="If there's a boss in the dungeon,\ntread carefully.", french="S'il y a un boss dans un donjon,\navance prudemment.", german="Gibt es in einem Dungeon einen\nBoss, schreitet man lieber mit Vorsicht voran.", italian="Se nel dungeon si nasconde\nun boss, devi procedere con cautela.", spanish="Si el territorio tiene un jefe,\nhay que ir con cuidado."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="They might misunderstand what\nyou're doing here and wonder whether you're\ntrying to take over their territory...", french="Il pourrait se méprendre sur la\nraison de ta présence et s'imaginer que tu\ncherches à t'approprier son territoire...", german="Bosse könnten deine Anwesenheit\nleicht fehlinterpretieren und denken, dass du\nihnen ihr Gebiet streitig machen willst...", italian="Potrebbe fraintendere il motivo\nper cui ti trovi lì e chiedersi se magari non\nstia cercando di invadere il suo territorio...", spanish="Puede interpretar mal tus\nintenciones y pensar que intentas apoderarte\nde sus dominios..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="They probably won't listen to\nwhat you're saying...", french="Il n'écoutera probablement pas\ntes explications...", german="Sie sind meistens nicht gewillt,\ndir zuzuhören...", italian="Probabilmente non ascolterà\nle tue ragioni...", spanish="Probablemente no atienda a\nexplicaciones..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="You're likely to be\nattacked often.", french="Tu risques d'être\nattaqué souvent.", german="Es besteht ein hohes Risiko,\nangegriffen zu werden.", italian="Nella maggior parte dei casi,\ndevi essere pronto a subire un attacco.", spanish=" Seguramente te ataque."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Hmmm...[K] Seems like dungeon\nbosses don't have much patience.", french="Mmmh...[K] On dirait qu'ils ne\nsont pas très patients, les boss des donjons.", german="Hmmm...[K] Bosse von Dungeons\nscheinen nicht viel Geduld zu haben.", italian="Mmh...[K] Sembra che i boss\ndei dungeon non abbiano molta pazienza.", spanish="Hum...[K] No parece que los jefes\nde los territorios tengan mucha paciencia."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="I don't know whether or not they\nhave patience...", french="Sont-ils patients ou non?\nJe l'ignore...", german="Ich weiß nicht, ob sie überhaupt\nGeduld haben...", italian="Non so se abbiano pazienza\noppure no...", spanish=" No sé si tienen paciencia o no."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Anyway, we need to brace\nourselves for what we'll find from here on.", french="Quoi qu'il en soit, nous devons\nnous préparer à affronter ce que nous\ntrouverons plus loin.", german="Wie auch immer, wir sollten\nuns noch kurz stärken, bevor wir\nweiter vordringen.", italian="Comunque dobbiamo farci forza\nper essere pronti ad affrontare quello che\ntroveremo d'ora in poi.", spanish="Solo sé que debemos prepararnos\npara lo que podamos hallar a partir de aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Yes, Master. ♪[K]\nHappy, happy! ♪", french="Voui, Maître. ♪[K]\nYoupi, youpi! ♪", german="Ja, Meister. ♪[K]\nLalala! ♪", italian="Sì, maestro. ♪[K]\nChe felicità! ♪", spanish="Vale, maestro. ♪[K]\n¡Vamos, vamos! ♪"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
