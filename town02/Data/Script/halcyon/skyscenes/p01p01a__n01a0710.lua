-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/n01a0710.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_P01P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  GAME:WaitFrames(30)
  local npc_npc_yukikaburi = SkySceneKit.spawn_npc("snover", 248, 200, Direction.Right, "NPC_YUKIKABURI")
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="We should make sure we\nprepare before going out exploring...", french="On devrait s'assurer d'avoir\ntout ce qu'il nous faut avant de partir\nà l'aventure...", german="Wir sollten uns gut vorbereiten,\nbevor wir auf Erkundung gehen.", italian="Dobbiamo prepararci bene prima\ndi partire per la nostra esplorazione...", spanish="Deberíamos asegurarnos de que\nestamos listos antes de irnos a explorar..."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="But I don't really want to do\nanything that would draw attention to me...", french="Mais je n'ai pas vraiment envie\nde me faire remarquer...", german="Aber ich möchte lieber nichts\ntun, was Aufmerksamkeit auf mich zieht.", italian="Ma non voglio fare niente che\npossa attirare l'attenzione su di me...", spanish="Pero no quiero hacer nada que\nllame la atención..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="[CS:N]Bagon[CR] and [CS:N]Gligar[CR] are still looking\nfor that map...", french="[CS:N]Draby[CR] et [CS:N]Scorplane[CR] sont encore\nà la recherche de cette carte...", german="[CS:N]Kindwurm[CR] und [CS:N]Skorgla[CR]\nsind immer noch hinter der Karte her...", italian="[CS:N]Bagon[CR] e [CS:N]Gligar[CR] sono ancora\nalla ricerca della mappa...", spanish="[CS:N]Bagon[CR] y [CS:N]Gligar[CR] siguen buscando\nese mapa..."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="They might be hanging around\nhere. It's kind of scaring me...[K] (Yikes...)", french="Ils traînent peut-être encore\ndans le coin, je ne suis pas rassuré...[K]\n(Mince...)", german="Und sie könnten hier noch immer\nauf mich lauern...[K] Bibber...", italian="Potrebbero aggirarsi da queste\nparti e al solo pensiero... mi viene una fifa![K]\n(Aaah...)", spanish="Puede que sigan merodeando\npor aquí, tiemblo solo de pensarlo...[K] (Horror...)"})
  -- SetAnimation(3) [anim idle native]
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(1)
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I've got it!", french=" Pas d'problème!", german=" Ich hab's!", italian=" Ci sono!", spanish=" ¡Ya sé!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="You just leave the exploration\npreparations to me. I can do it...", french="J'm'occupe des préparatifs pour\nl'exploration, t'en fais pas...", german="Überlass mir einfach die\nVorbereitungen. Das kann ich gut...", italian="Lascia a me i preparativi,\nci penso io...", spanish="Déjame a mí los preparativos\nde la exploración, puedo hacerlo yo..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="And you should hide somewhere,\n[CS:N]Snover[CR]. Stay out of sight.", french="Et toi tu d'vrais t'cacher\nen attendant, [CS:N]Blizzi[CR]. Te montre pas.", german="Und du versteckst dich besser,\n[CS:N]Shnebedeck[CR]. Lass dich nicht blicken.", italian="Tu pensa a nasconderti da\nqualche parte, [CS:N]Snover[CR]. Non dare\nnell'occhio.", spanish="Y tú deberías esconderte, [CS:N]Snover[CR].\nQue no te vea nadie."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="I'm sorry.[K] I'll find a hiding place\nright around here.", french="Désolé.[K] Je vais chercher\nune cachette dans le coin.", german="Danke dir.[K] Ich werde mir in\nder Nähe ein Versteck suchen.", italian="Mi dispiace.[K] Troverò un posto\ndove nascondermi qui intorno.", spanish="Siento no ser de ayuda,[K] pero\ntienes razón, voy a buscar un escondite."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="When you're ready to head to the\ndungeon, [CS:Y]Bidoof[CR]...[K] I'll slip away and join you.", french="Dès que tu seras prêt à partir\npour le donjon, [CS:Y]Keunotor[CR]...[K]\nje sortirai de ma cachette et je te rejoindrai.", german="Sobald du bereit für den\nDungeon bist, [CS:Y]Bidiza[CR],[K] komme ich heraus, um\ndich zu begleiten.", italian="E non appena sei pronto a partire\nper il dungeon, [CS:Y]Bidoof[CR]...[K] io scivolerò fuori\ndal mio nascondiglio e ti raggiungerò.", spanish="Cuando estés listo para ir al\nterritorio, [CS:Y]Bidoof[CR]...[K] Saldré y me uniré a ti."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="So once you've finished\npreparing, please head for the dungeon.", french="Alors, une fois tes préparatifs\nterminés, dirige-toi vers le donjon,\ns'il te plaît.", german="Also mach dich einfach auf zum\nDungeon, sobald du mit den Vorbereitungen\nfertig bist.", italian="Tutto chiaro? Quando hai finito\ndi prepararti, dirigiti al dungeon.", spanish="Así que, cuando estés listo,\ndirígete al territorio."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" See you later.", french=" A tout à l'heure.", german=" Wir sehen uns dann.", italian=" A dopo.", spanish=" Nos vemos luego."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_yukikaburi, 220, 200, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_yukikaburi, 220, 328, false, 2)
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(50)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Got it![K] All right, I need to head\ninto Treasure Town and get ready to explore.", french="Pigé![K] Très bien, faut qu'j'aille à\nBourg-Trésor pour préparer l'exploration.", german="Verstanden![K] Gut, dann werde ich\nmich mal nach Schatzstadt aufmachen, um\nalles vorzubereiten.", italian="Ok![K] Ora devo andare a Borgo\nTesoro e prepararmi per l'esplorazione.", spanish="¡Hasta luego![K] Bueno, tengo que\nir a Aldea Tesoro y prepararme para explorar."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I'll do my best!", french=" J'ferai d'mon mieux!", german=" Verlass dich drauf!", italian=" Ce la metterò tutta!", spanish=" ¡Lo haré lo mejor que pueda!"})
  -- message_Close
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[123] = 1 -- dungeon_mode(123) = DMODE_OPEN (ROM)
  SkySceneKit.cleanup_npcs()
end
