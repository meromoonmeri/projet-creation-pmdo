-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D42P41A/n01a1903.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  -- back_SetGround(LEVEL_D42P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_yukikaburi = SkySceneKit.spawn_npc("snover", 256, 248, Direction.Up, "NPC_YUKIKABURI")
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" I suddenly had an idea.", french=" Alors j'ai soudain eu une idée.", german=" Da kam mir spontan eine Idee.", italian="Improvvisamente ho avuto\nun'idea.", spanish=" Enseguida me vino la inspiración."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="I thought that money was\nours to take.", french="Je me suis dis que cet argent,\nil nous était destiné.", german="Ohne Zweifel gehört das Geld in\nunsere Taschen.", italian="Ho pensato che quei soldi\ndovevano essere nostri.", spanish="Supe que teníamos que quedarnos\ncon toda esa pasta."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="But...[K]if we mugged you\nright then and there, there would have been\nan uproar.", french="Mais...[K] si on t'en avait délesté\nà ce moment et à cet endroit-là, il y\naurait eu du chahut.", german="Aber...[K] Dich dort vor Ort\nin die Zange zu nehmen... Das hätte nur für\nunnötiges Aufsehen gesorgt.", italian="Ma...[K] se ti avessimo aggredito\ne derubato proprio in quel momento,\navremmo attirato troppo l'attenzione.", spanish="Pero...[K] si te hubiéramos robado\nen ese momento, se habría liado una buena."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="That's why we put on this little\nshow...[K]to lure you out here...", french="C'est pour ça qu'on a imaginé\ncette petite mise en scène...[K] pour\nt'attirer dans ce piège...", german="Deswegen haben wir unsere\nkleine Show gestartet,[K] um dich zu ködern.", italian="Ecco perché abbiamo architettato\nquesta messinscena...[K] per attirarti qui...", spanish="Por eso montamos este\nnumerito...[K] Para atraerte hasta aquí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Sniff...[K] Th-then...", french=" Snif...[K] A-alors...", german=" Schnief...[K] D-das heißt...", italian=" Sniff...[K] A-Allora...", spanish=" Snif...[K] E... entonces..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="The story about [CS:P]Star Cave[CR] and\n[CS:N]Jirachi[CR] is...?", french="Cette histoire de [CS:P]Caverne Etoile[CR]\net de [CS:N]Jirachi[CR], c'était...", german="Die Geschichte über die\n[CS:P]Sternenhöhle[CR] und [CS:N]Jirachi[CR] ist...", italian="Tutte quelle storie sulla\n[CS:P]Caverna Stellata[CR] e [CS:N]Jirachi[CR] sono...?", spanish="¿La historia sobre la [CS:P]Cueva[CR]\n[CS:P]Estrella[CR] y [CS:N]Jirachi[CR] es...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" A complete fabrication.", french=" Une pure invention.", german=" Komplett erfunden. Haargenau.", italian=" Totalmente inventate.", spanish=" Toda inventada."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="You see, we were pretty excited\nwhen we laid our hands on that Ancient Map...", french="Tu vois, on était plutôt excités\nquand on a mis la main sur cette\nCarte Ancienne...", german="Na ja, nicht ganz. Als wir die\nUralte Karte erbeuteten, waren wir ganz\nschön aufgeregt...", italian="Vedi, eravamo piuttosto\nemozionati quando abbiamo messo\nle mani su quella mappa antica...", spanish="Nos emocionamos la tira cuando\nel Mapa Antiguo cayó en nuestras manos..."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="Wishes come true here, so\nwe heard.[K] We could get rich!", french="On avait entendu dire que les\nvœux pouvaient se réaliser, ici.[K]\nLa fortune assurée!", german="Diese Legende über Wünsche,\ndie erfüllt werden.[K] Das hätte Reichtum\nbedeutet!", italian="Avevamo sentito che qui\ni desideri si avverano.[K] Potevamo\ndiventare ricchi!", spanish="Oímos que los deseos se hacían\nrealidad.[K] ¡Por fin íbamos a ser ricos!"})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" So...[K] We came here to find out!", french="Alors...[K] on est venus ici\npour voir!", german="Also waren wir hier,[K] um es\nherauszufinden!", italian="Così...[K] siamo venuti qui\nper scoprire se era vero!", spanish=" Y...[K] vinimos a ver si era cierto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yukikaburi, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_yukikaburi, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_yukikaburi, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="But there's nothing here.[K]\nIt's just a dead end.", french="Mais y'a que dalle, ici.[K]\nC'est une impasse, rien de plus.", german="Nur ist hier gar nichts.[K]\nEine Sackgasse, mehr nicht.", italian="Ma qui non c'è nulla.[K]\nÈ solo un vicolo cieco.", spanish="Pero aquí no había nada.[K]\nEste era el final, no había salida alguna."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="We were so disappointed.[K]\nIt's just a fake. The map, that is.", french="Imagine notre déception.[K]\nC'est du bidon. La carte, tout ça.", german="Wie enttäuschend.[K] Nur eine\nFälschung, diese Karte. Das ist alles.", italian="Eravamo così delusi.[K]\nQuesta mappa è solo un falso.", spanish="Menudo chasco.[K]\nEra falso. El mapa, quiero decir."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="Still angry, we came to\nTreasure Town...[K]and there you were.", french="La rage au ventre, on s'est\nrendus à Bourg-Trésor...[K]\net c'est là qu'on t'a trouvé.", german="Immer noch erbost, kamen wir\nnach Schatzstadt...[K] Und da warst du.", italian="Ancora pieni di rabbia, siamo\nvenuti a Borgo Tesoro...[K] e tu eri lì.", spanish="Volvimos muy enfadados a\nAldea Tesoro...[K] y te vimos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(0), p.Y+(-8), false, 1) end
  GAME:WaitFrames(2)
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-4), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(5)
  local npc_npc_tatsubei = SkySceneKit.spawn_npc("bagon", 232, 168, Direction.Down, "NPC_TATSUBEI")
  do local p=npc_npc_tatsubei.Position; GROUND:MoveToPosition(npc_npc_tatsubei, p.X+(0), p.Y+(8), false, 1) end
  GAME:WaitFrames(7)
  -- SetAnimation(2) [anim idle native]
  local npc_npc_guraigaa = SkySceneKit.spawn_npc("gligar", 280, 168, Direction.Down, "NPC_GURAIGAA")
  do local p=npc_npc_guraigaa.Position; GROUND:MoveToPosition(npc_npc_guraigaa, p.X+(0), p.Y+(8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(45)
  do local p=npc_npc_guraigaa.Position; GROUND:MoveToPosition(npc_npc_guraigaa, p.X+(0), p.Y+(8), false, 1) end
  GAME:WaitFrames(5)
  do local p=npc_npc_tatsubei.Position; GROUND:MoveToPosition(npc_npc_tatsubei, p.X+(0), p.Y+(8), false, 1) end
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(4), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(0), p.Y+(-8), false, 1) end
  GAME:WaitFrames(2)
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  do local p=npc_npc_tatsubei.Position; GROUND:MoveToPosition(npc_npc_tatsubei, p.X+(0), p.Y+(8), false, 1) end
  GAME:WaitFrames(7)
  do local p=npc_npc_guraigaa.Position; GROUND:MoveToPosition(npc_npc_guraigaa, p.X+(0), p.Y+(8), false, 1) end
  GROUND:EntTurn(npc_npc_tatsubei, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_guraigaa, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yukikaburi, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Sniff...", french=" Snif...", german=" Schnüff...", italian=" Sniff...", spanish=" Buaa..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" Too bad...", french=" Ça me fait de la peine, mais...", german=" Pech gehabt...", italian=" Mi dispiace...", spanish=" Es lo que hay..."})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" Your money...[K]we're taking it!", french="... ton argent...[K]\nc'est le nôtre, maintenant!", german=" Dein Geld...[K] Das nehmen wir!", italian="... ma i tuoi soldi...[K] finiranno\nnelle nostre tasche!", spanish="Bueno, ese dinero que tenías...[K]\n¡Ya nos lo estás dando!"})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" Prepare yourself!", french=" En garde!", german=" Mach dich bereit!", italian=" Preparati!", spanish=" ¡Venga, afloja la cartera!"})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Eeeeeeeeeek!!", french=" Aaaaarrrgh!!", german=" Ieeeeeeeek!!!", italian=" Aaaaaaah!!!", spanish=" ¡¡Aaaaay!!"})
  -- message_Close
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(125, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
