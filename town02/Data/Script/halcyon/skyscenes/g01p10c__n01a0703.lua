-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P10C/n01a0703.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_G01P10C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 264, 200, Direction.Down, "NPC_DOGOOMU")
  -- SetAnimation(44) [anim idle native]
  GAME:WaitFrames(10)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 176, 200, Direction.Down, "NPC_HEIGANI")
  -- SetAnimation(45) [anim idle native]
  GROUND:EntTurn(hero, Direction.Right)
  GAME:FadeIn(30) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Right then...[K]that Pokémon\nhanded me something...", french="A c'moment-là...[K] l'Pokémon\nm'a donné un truc...", german="Genau in diesem Moment...[K]\nDa hat mir das Pokémon etwas gegeben...", italian="In quel momento...[K] quel Pokémon\nmi ha dato qualcosa...", spanish="En ese momento...[K] aquel\nPokémon me dio algo..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="And right afterward those two\nscary-looking Pokémon arrived...[K]I was so\nscared, I couldn't remember what happened.", french="Et juste après, les deux affreux\nont déboulé...[K] J'ai eu tellement peur\nque j'en ai oublié c'qui s'était passé.", german="Und kurz danach kamen die zwei\nfurchteinflößenden Pokémon vorbei.[K] Und ich\nhatte so eine Angst, dass ich das total vergaß!", italian="E subito dopo sono arrivati quei\ndue Pokémon dall'aria sinistra...[K] Ero così\nspaventato che non me lo ricordavo più.", spanish="Y justo después llegaron esos\ndos Pokémon espeluznantes...[K] Tenía tanto miedo\nque no me acuerdo de qué pasó."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But no matter how I try to\nfigure it out, I just can't...", french="Mais j'ai beau essayer de\ncomprendre, j'peux point...", german="Aber irgendwie kann ich\nmich immer noch nicht...", italian="Beh, è inutile che stia qui\na lambiccarmi il cervello...", spanish=" ¿A qué vendría todo eso?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I guess I should look and see.", french="J'devrais regarder ça\nd'plus près.", german="Vielleicht sollte ich es mir\neinfach mal ansehen.", italian="Forse è meglio che dia\nun'occhiata all'oggetto che ho ricevuto\nda quello strano Pokémon.", spanish="Supongo que debería echarle un vistazo\na lo que me dio."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6667) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(30)
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...[K]This is pretty old...[K]\nIt looks like a map.", french="...[K] Ça a l'air plutôt vieillot...[K]\nOn dirait une carte.", german="...[K]Ziemlich alt...[K]\nSieht wie eine Karte aus.", italian="...[K] Sembra una mappa...[K]\ned è piuttosto vecchia.", spanish="Es...[K] Es bastante antiguo...[K]\nParece un mapa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(15) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...Huh?[K] There's some kind of\nmark...[K] It looks like there's something written.", french="... Hein?[K] Y'a une sorte\nde croix... [K]Y'a un truc d'écrit, on dirait.", german="...Huch![K] Da ist eine Markierung...[K]\nUnd da steht etwas geschrieben.", italian="Uh?[K] C'è una specie di segno...[K]\nSembra che ci sia scritto qualcosa.", spanish="¿Eh?[K] Hay una especie de\nseñal...[K] Parece que hay algo escrito."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="What could be written here,\nI wonder?[K] Let's see...", french=" Un truc d'écrit...[K] Voyons voir...", german="Was da wohl geschrieben steht...[K]\nMomentchen, das haben wir gleich...", italian="Sì, sembra proprio così...\nMa cosa sarà?[K] Vediamo...", spanish="¿Es posible que haya algo\nescrito?[K] Vamos a ver..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:P]Star[CR]... [K][CS:P]Cave[CR]...?", french=" [CS:P]Caverne[CR]... [K][CS:P]Etoile[CR]...?", german=" [CS:P]Sternen[CR]...[K][CS:P]höhle[CR]?", italian=" [CS:P]Caverna[CR]... [K][CS:P]Stellata[CR]...?", spanish=" ¿La [CS:P]Cueva[CR]...[K] [CS:P]Estrella[CR]...?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="At this marked spot...[K]seems\nthere's a place called [CS:P]Star Cave[CR]?", french="A c't'emplacement marqué\npar une croix...[K] on dirait qu'y a un endroit\nappelé la [CS:P]Caverne Etoile[CR]...", german="An dieser Stelle[K] gibt es also\neinen Ort namens[CS:P] Sternenhöhle[CR]?", italian="In questo punto segnato\nsulla mappa...[K] pare che ci sia un posto\nchiamato [CS:P]Caverna Stellata[CR]...", spanish="El lugar señalado...[K] parece ser un sitio\nllamado la [CS:P]Cueva Estrella[CR]."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="However...[K][CS:P]Star Cave[CR]...[K]\nIt certainly sounds enticing...", french="Ma foi...[K] La [CS:P]Caverne Etoile[CR]...[K]\nÇa m'a l'air vachement alléchant...", german="Wie auch immer...\n[K][CS:P]Sternenhöhle[CR]...[K] Das klingt auf jeden\nFall verlockend...", italian="Però...[K] [CS:P]Caverna Stellata[CR]...[K]\nChe nome affascinante...", spanish="Pues...[K] [CS:P]Cueva Estrella[CR]...[K]\nLa verdad es que suena tentador..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Somehow I just get a feeling...[K]\nThere has to be something really special there.", french="Y doit y avoir un truc vraiment\nspécial là-bas...[K] Je l'sens...", german="Da muss sich etwas ganz\nBesonderes befinden...[K] Ich habe da so eine\nAhnung...", italian="Deve esserci qualcosa\ndi veramente speciale laggiù...[K]\nNon so perché, ma sono sicuro che sia così.", spanish="No sé por qué, pero tengo\nla sensación...[K] de que tiene que haber\nalgo muy especial en ese sitio..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Sniff...[K] Now I'm so excited,\nI can't sleep. Yup yup...", french="Snif...[K] Maintenant j'suis trop\nexcité, j'peux plus m'endormir... Ouaip.", german="Schnief...[K] Ich kann gar nicht\nmehr schlafen vor Aufregung. Jawollja...", italian="Sniff...[K] Ora sono così\nemozionato che non riesco a dormire.\nGià, già...", spanish="Buaa...[K] Ahora estoy tan nervioso\nque me he desvelado. Hay que ver..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...Nope.[K] I have to sleep if I\nwant to do any good at training tomorrow...", french="... Bof.[K] Faut qu'je dorme si\nj'veux réussir mon entraînement demain...", german="...Nein.[K] Ich muss schlafen, wenn\nich morgen erfolgreich trainieren möchte...", italian="... No.[K] Devo dormire, altrimenti\ndomani non riuscirò a svolgere\nil mio allenamento come si deve...", spanish="No, señor...[K] Tengo que dormir\npara poder darlo todo entrenando mañana..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6667) — id SE NDS sans portage PMDO identifié
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Sniff...[K] I really should sleep.[K]\nGood night, you all.", french="Snif...[K] Faut vraiment qu'je\ndorme.[K] Bonne nuit, tout l'monde.", german="Schnief...[K] Ich sollte wirklich\nschlafen.[K] Gute Nacht, allerseits.", italian="Sniff...[K] È ora di andare a nanna.[K]\nBuonanotte a tutti.", spanish="Snif...[K] Tengo que dormir.[K]\nBuenas noches a todos."})
  -- message_Close
  GROUND:EntTurn(hero, Direction.Left)
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- SetAnimation(46) [anim idle native]
  GAME:WaitFrames(60)
  -- GAP: se_Play(9217) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="GUGOGOGOGOGOoooooooooaahhh!\nGUGOGOGOGOGOoooooooooaaaaaaaaahhhhhhhhh!", french="RRROOONNNNNNZZZZZZblblblblbl!\nRORONRONBLBLBLZZZzzzzzROOOOOON!", german="GUGOGOGOGOGOoooooooooaah!\nGUGOGOGOGOGOoooooooooaaaaaaaaah!", italian="ZZZZZZZZZzzzzzzzzzZZZZZZ!\nRONFRONFAAAH!? RooonfAAAAAAAAAHHHHH...", spanish="¡Groooooooooooooooooonf!\n¡Fiiiiiiiiiiiiiiiiiiiuuuuuuuuuuuuuuuuuuuuuuuuuu!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="GUGOah![K] GUGOGOGOGOGO!\nGOGOGOGOGOGOGOooooooaaaaaaahhhhhhhhh!", french="RON![K] RONRONZZZZZZZZZZZZzzz!\nBLBLBLZZZZZZZzzzzzzzzZZZZROOOOOOOOON!", german="GUGOah![K] GUGOGOGOGOGO!\nGOGOGOGOGOGOGOooooooaaaaaaah!", italian="ZZZZZZZZZaaaaaaahhhh![K]\nROROOONFAAAAAAAaaaaaaahhhhhhh!", spanish="¡Groonf![K] ¡Grooooooooooonf!\n¡Fiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiuuuuuuuuuuuuuuuuu!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Sniff...[K] Sniff...", french=" Snif...[K] Snif...", german=" Schnief...[K] Schnief...", italian=" Sniff...[K] Sniff...", spanish=" Buaaaa...[K] Buaaaa..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" S-sleep.[K] Yup yup, sleepy time...", french=" D-dormir.[K] Ouaip ouaip... dodo...", german="Sch-schlafen...[K]\nJawollja, Schlafenszeit...", italian="B-Basta.[K] È ora di dormire,\ngià, già...", spanish=" A... A dormir.[K] Sí, que es tarde..."})
  -- message_Close
  GAME:WaitFrames(45)
  -- se_FadeOut(9217, 120) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:FadeOut(false, 120)
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
end
