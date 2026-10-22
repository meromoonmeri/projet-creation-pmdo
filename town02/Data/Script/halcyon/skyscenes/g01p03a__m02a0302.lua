-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m02a0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 368, 184, Direction.Down, "NPC_PERAPPU")
  GROUND:MoveToPosition(npc_npc_perappu, 272, 212, false, 2)
  GAME:WaitFrames(30)
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(partner, 236, 244, false, 2)
  GAME:WaitFrames(30)
  -- supervision_Acting(3) [neutre/état moteur]
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 268, 244, false, 2)
  pcall(function() GAME:MoveCamera(252, 228, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" You're just beginners.", french=" Vous venez à peine d'arriver.", german=" Ihr seid Anfänger.", italian=" Voi siete due principianti.", spanish=" Como sois principiantes..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We'll have you start off with\nthis assignment. ♪", french="Alors vous allez commencer\npar vous choisir une mission. ♪", german="Wir geben euch zum Anfang\neinen Auftrag. ♪", italian="Per iniziare, vi assegnerò un\ncompito. ♪", spanish="Empezaréis con algún\nencargo. ♪"})
  -- message_Close
  GROUND:EntTurn(npc_npc_perappu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="This is the Job Bulletin Board.\nPokémon from various regions post job\nrequests here.", french="Voici le Tableau des Missions.\nDes Pokémon de différentes régions envoient\ndes offres de missions ici.", german="Dies ist das Job-Infobrett.\nPokémon aus unterschiedlichen Regionen\nhängen hier Jobangebote aus.", italian="Questa è la Bacheca delle\nmissioni. I Pokémon di varie regioni\nappendono qui le loro richieste.", spanish="Este es el Tablón de Anuncios.\nAquí aparecen las misiones que nos encargan\nlos Pokémon de distintos lugares."})
  -- message_Close
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You're aware that bad Pokémon\nare cropping up in greater numbers, right?", french="Vous savez qu'il y a de plus en\nplus de méchants Pokémon, n'est-ce pas?", german="Ihr wisst, dass zurzeit immer\nmehr bösartige Pokémon auftauchen, nicht\nwahr?", italian="Sapete che ultimamente ci sono\nsempre più Pokémon cattivi in giro, vero?", spanish="Sin duda sabréis que el número\nde Pokémon malvados está aumentando\núltimamente de forma considerable, ¿no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yup.[K] Because the flow of time is\ngetting messed up. It's wreaking havoc, right?", french="Oui.[K] Car quelque chose perturbe\nl'écoulement du temps. Et cela fait\ndes ravages, c'est bien ça?", german="Ja.[K] Weil der Fluss der Zeit\ndurcheinandergerät, entsteht Chaos, richtig?", italian="Eh sì.[K] Dipende dal fatto che il\nflusso del tempo è disturbato. Sta causando un\nbel po' di danni, giusto?", spanish="Sí.[K] Porque hay problemas\ncon el tiempo, ¿verdad? Y todo se está\nvolviendo un caos..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yup.[K] Because the flow of time is\ngetting messed up. It's wreaking havoc, right?", french="Oui.[K] Car quelque chose perturbe\nl'écoulement du temps. Et cela fait\ndes ravages, c'est bien ça?", german="Ja.[K] Weil der Fluss der Zeit\ndurcheinandergerät, entsteht Chaos, richtig?", italian="Eh sì.[K] Dipende dal fatto che il\nflusso del tempo è disturbato. Sta causando un\nbel po' di danni, giusto?", spanish="Sí.[K] Porque hay problemas\ncon el tiempo, ¿verdad? Y todo se está\nvolviendo un caos..."})
  else
  SkySceneKit.say({english="Yup.[K] Because the flow of time is\ngetting messed up. It's wreaking havoc, right?", french="Oui.[K] Car quelque chose perturbe\nl'écoulement du temps. Et cela fait\ndes ravages, c'est bien ça?", german="Ja.[K] Weil der Fluss der Zeit\ndurcheinandergerät, entsteht Chaos, richtig?", italian="Eh sì.[K] Dipende dal fatto che il\nflusso del tempo è disturbato. Sta causando un\nbel po' di danni, giusto?", spanish="Sí.[K] Porque hay problemas\ncon el tiempo, ¿verdad? Y todo se está\nvolviendo un caos..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Which is why lots of bad\nPokémon are appearing!", french="Ce qui explique pourquoi\nbeaucoup de méchants Pokémon apparaissent!", german="Und darum tauchen so viele\nbösartige Pokémon auf!", italian="È per questo che ci sono in giro\nun sacco di Pokémon cattivi!", spanish="Y eso está afectando a\nmuchos Pokémon."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Which is why lots of bad\nPokémon are appearing!", french="Ce qui explique pourquoi\nbeaucoup de méchants Pokémon apparaissent!", german="Und darum tauchen so viele\nbösartige Pokémon auf!", italian="È per questo che ci sono così\ntanti Pokémon cattivi in giro!", spanish="Y eso está afectando a\nmuchos Pokémon."})
  else
  SkySceneKit.say({english="Which is why lots of bad\nPokémon are appearing!", french="Ce qui explique pourquoi\nbeaucoup de méchants Pokémon apparaissent!", german="Und darum tauchen so viele\nbösartige Pokémon auf!", italian="Per questo motivo ci sono\nparecchi Pokémon cattivi in giro ultimamente.", spanish="Y eso está afectando a\nmuchos Pokémon."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The flow of time is getting messed up?)", french="(L'écoulement du temps est perturbé?)", german="(Der Fluss der Zeit gerät durcheinander?)", italian="(Il flusso del tempo è disturbato?)", spanish="(¿Así que hay problemas con el tiempo?)"})
  else
  SkySceneKit.say({english="(The flow of time is getting messed up?)", french="(L'écoulement du temps est perturbé?)", german="(Der Fluss der Zeit gerät durcheinander?)", italian="(Il flusso del tempo è disturbato?)", spanish="(¿Así que hay problemas con el tiempo?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Time? As in hours and minutes?[K] Do they mean\nsomething has gone wrong with time here?)", french="(Le temps? Les heures, les minutes?[K]\nVeulent-ils dire qu'il y a un problème avec\nle temps ici?)", german="(Zeit? Also Stunden und Minuten?[K] Soll das\nheißen, hier ist etwas mit der Zeit\nschiefgegangen?)", italian="(Il tempo? Nel senso di ore e minuti?[K] Stanno\ndicendo che qui qualcosa non va con il tempo?)", spanish="(¿El tiempo? ¿El tiempo cronológico?[K]\n¡Pero eso sería muy grave!)"})
  else
  SkySceneKit.say({english="(Time? As in hours and minutes?[K] Do they mean\nsomething has gone wrong with time here?)", french="(Le temps? Les heures, les minutes?[K]\nVeulent-ils dire qu'il y a un problème avec\nle temps ici?)", german="(Zeit? Also Stunden und Minuten?[K] Soll das\nheißen, hier ist etwas mit der Zeit\nschiefgegangen?)", italian="(Il tempo? Nel senso di ore e minuti?[K] Stanno\ndicendo che qui qualcosa non va con il tempo?)", spanish="(¿El tiempo? ¿El tiempo cronológico?[K]\n¡Pero eso sería muy grave!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(And, because of that, more and more bad\nPokémon are popping up?)", french="(Et qu'à cause de cela, on voit apparaître\nde plus en plus de méchants Pokémon?)", german="(Und deswegen gibt es immer mehr bösartige\nPokémon?)", italian="(E che per questo un sacco di Pokémon cattivi\nstanno facendo la loro comparsa?)", spanish="(¿Y por culpa de eso cada vez están\napareciendo más Pokémon malvados?)"})
  else
  SkySceneKit.say({english="(And, because of that, more and more bad\nPokémon are popping up?)", french="(Et qu'à cause de cela, on voit apparaître\nde plus en plus de méchants Pokémon?)", german="(Und deswegen gibt es immer mehr bösartige\nPokémon?)", italian="(E che per questo un sacco di Pokémon cattivi\nstanno facendo la loro comparsa?)", spanish="(¿Y por culpa de eso cada vez están\napareciendo más Pokémon malvados?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What's going on here?!)", french="(Mais que se passe-t-il ici?!)", german="(Was geht hier nur vor?!?)", italian="(Cosa sta succedendo qui?!)", spanish="(¿Qué está pasando?)"})
  else
  SkySceneKit.say({english="(What's going on here?!)", french="(Mais que se passe-t-il ici?!)", german="(Was geht hier nur vor?!?)", italian="(Cosa sta succedendo qui?!)", spanish="(¿Qué está pasando?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Precisely.[K] Time getting out of\nwhack has caused an outbreak of bad Pokémon.\nPerhaps because of all that...", french="Précisément.[K] Le temps étant\nperturbé, les apparitions de méchants Pokémon\nse font plus fréquentes.", german="Genau.[K] Weil die Zeit aus dem\nGleichgewicht gerät, gibt es eine Flut von\nbösartigen Pokémon. Vielleicht liegt es daran...", italian="Esattamente.[K] Questo disturbo\ndel tempo ha causato l'epidemia di Pokémon\ncattivi. Potrebbe essere la ragione per cui...", spanish="Exactamente.[K] El tiempo está\ndescontrolándose y por eso ha aparecido tanto\nPokémon malvado. Precisamente por eso..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We have noticed an increase\nin the number of jobs.", french="C'est peut-être pour ça... que\nnous constatons une augmentation du nombre\nde missions.", german="Wir haben einen Anstieg bei den\nangebotenen Jobs bemerkt.", italian="... abbiamo notato un aumento del\nnumero di missioni.", spanish="Hemos notado que el número de\nmisiones está aumentando."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="In addition...and it's unknown if\nthis is because of time's influence...", french="Il y a autre chose... mais nous\nne savons pas si c'est lié à l'influence\ndu temps...", german="Und dann ist da noch etwas. Man\nweiß nicht, ob es auch mit der Zeit zu tun\nhat...", italian="Inoltre... e non sappiamo se\nquesto abbia a che fare con il tempo...", spanish="Además, ha pasado otra cosa\ncuriosa, aunque no se sabe si es por culpa\nde lo que pasa con el tiempo o no..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="There has also been a mass\noutbreak of...[K]mystery dungeons.", french="Il y a une recrudescence\nimportante du nombre de...[K] donjons mystères.", german="Es gibt eine regelrechte Flut\nvon...[K] Mystery Dungeons.", italian="... sono aumentati anche...[K]\ni dungeon misteriosi.", spanish="Han aparecido muchos...[K]\nterritorios misteriosos en el mundo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Mystery dungeons?!)", french="(Des donjons mystères?!)", german="(Mystery Dungeons?!?)", italian="(Dungeon misteriosi?!)", spanish="(¿Territorios misteriosos?)"})
  else
  SkySceneKit.say({english="(Mystery dungeons?!)", french="(Des donjons mystères?!)", german="(Mystery Dungeons?!?)", italian="(Dungeon misteriosi?!)", spanish="(¿Territorios misteriosos?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So, [hero]!", french=" Dis, [hero]!", german=" Also, [hero]!", italian=" Allora, [hero]!", spanish=" ¡Oye, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So, [hero]!", french=" Dis, [hero]!", german=" Also, [hero]!", italian=" Allora, [hero]!", spanish=" ¡Oye, [hero]!"})
  else
  SkySceneKit.say({english=" So, [hero]!", french=" Dis, [hero]!", german=" Also, [hero]!", italian=" Allora, [hero]!", spanish=" ¡Una cosa, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You know how we got my Relic\nFragment back yesterday?", french="Tu te rappelles quand on a\nrécupéré mon Fragment de Relique hier?", german="Erinnerst du dich an gestern, als\nwir mein Reliktfragment zurückgeholt haben?", italian="Ti ricordi come abbiamo\nrecuperato il mio Frammento Antico, ieri?", spanish="¿Te acuerdas de cuando\nrecuperamos mi Reliquia de Piedra?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You know how we got my Relic\nFragment back yesterday?", french="Tu te rappelles quand on a\nrécupéré mon Fragment de Relique hier?", german="Erinnerst du dich an gestern, als\nwir mein Reliktfragment zurückgeholt haben?", italian="Ti ricordi come abbiamo\nrecuperato il mio Frammento Antico, ieri?", spanish="¿Te acuerdas de ayer, cuando\nrecuperamos mi Reliquia de Piedra?"})
  else
  SkySceneKit.say({english="You know how we got my Relic\nFragment back yesterday?", french="Tu te rappelles quand on a\nrécupéré mon Fragment de Relique hier?", german="Erinnerst du dich an gestern, als\nwir mein Reliktfragment zurückgeholt haben?", italian="Ti ricordi come abbiamo\nrecuperato il mio Frammento Antico, ieri?", spanish="¿Te acuerdas de ayer, cuando\nrecuperamos mi Reliquia de Piedra?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The place where we found it\nwas a mystery dungeon.", french="L'endroit où nous l'avons trouvé\nétait un donjon mystère.", german="Der Ort, an dem wir es gefunden\nhaben, war ein Mystery Dungeon.", italian="Il luogo dove l'abbiamo trovato\nera un dungeon misterioso.", spanish="El sitio en el que la encontramos\nera un territorio misterioso."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The place where we found it\nwas a mystery dungeon.", french="L'endroit où nous l'avons trouvé\nétait un donjon mystère.", german="Der Ort, an dem wir es gefunden\nhaben, war ein Mystery Dungeon.", italian="Il luogo dove l'abbiamo trovato\nera un dungeon misterioso.", spanish="El sitio en el que la recobramos\nera un territorio misterioso."})
  else
  SkySceneKit.say({english="The place where we found it\nwas a mystery dungeon.", french="L'endroit où nous l'avons trouvé\nétait un donjon mystère.", german="Der Ort, an dem wir es gefunden\nhaben, war ein Mystery Dungeon.", italian="Il luogo dove l'abbiamo trovato\nera un dungeon misterioso.", spanish="El sitio en el que la recuperamos\nera un territorio misterioso."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="A mystery dungeon changes each\ntime you go into it. There's a different layout\nand different items every time you enter!", french="Un donjon mystère change à\nchaque fois que l'on s'y rend. Son apparence\net les objets y sont toujours différents!", german="Ein Mystery Dungeon ändert sich\njedes Mal, wenn man ihn betritt. Jedes Mal\nsieht er anders aus und enthält andere Items!", italian="Un dungeon misterioso cambia\nogni volta che ci entri. Ha una forma diversa\ne contiene strumenti differenti ogni volta!", spanish="Un territorio misterioso\nse transforma cada vez que lo visitas.\nTodo es diferente... ¡incluso hay otros objetos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="A mystery dungeon changes each\ntime you go into it. There's a different layout\nand different items every time you enter!", french="Un donjon mystère change à\nchaque fois que l'on s'y rend. Son apparence\net les objets y sont toujours différents!", german="Ein Mystery Dungeon ändert sich\njedes Mal, wenn man ihn betritt. Jedes Mal\nsieht er anders aus und enthält andere Items!", italian="Un dungeon misterioso cambia\nogni volta che ci entri. Ha una forma diversa\ne contiene strumenti differenti ogni volta!", spanish="Un territorio misterioso\nse transforma cada vez que lo visitas.\nTodo es diferente... ¡incluso hay otros objetos!"})
  else
  SkySceneKit.say({english="A mystery dungeon changes each\ntime you go into it. There's a different layout\nand different items every time you enter!", french="Un donjon mystère change à\nchaque fois que l'on s'y rend. Son apparence\net les objets y sont toujours différents!", german="Ein Mystery Dungeon ändert sich\njedes Mal, wenn man ihn betritt. Jedes Mal\nsieht er anders aus und enthält andere Items!", italian="Un dungeon misterioso cambia\nogni volta che ci entri. Ha una forma diversa\ne contiene strumenti differenti ogni volta!", spanish="Un territorio misterioso\nse transforma cada vez que lo visitas.\nTodo es diferente... ¡incluso hay otros objetos!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If you faint in the middle of a\ndungeon, you lose half of your money...", french="Si tu tombes K.O. dans un\ndonjon, tu perds la moitié de ton argent...", german="Gehst du in einem Dungeon K.O.,\nverlierst du die Hälfte deines Geldes...", italian="Se finisci KO dentro un dungeon,\nperdi metà dei tuoi soldi...", spanish="Si te debilitas estando en un\nterritorio, perderás la mitad de tu dinero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If you faint in the middle of a\ndungeon, you lose half of your money...", french="Si tu tombes K.O. dans un\ndonjon, tu perds la moitié de ton argent...", german="Gehst du in einem Dungeon K.O.,\nverlierst du die Hälfte deines Geldes...", italian="Se finisci KO dentro un dungeon,\nperdi metà dei tuoi soldi...", spanish="Si te debilitas estando en un\nterritorio, pierdes la mitad de tu dinero..."})
  else
  SkySceneKit.say({english="If you faint in the middle of a\ndungeon, you lose half of your money...", french="Si tu tombes K.O. dans un\ndonjon, tu perds la moitié de ton argent...", german="Gehst du in einem Dungeon K.O.,\nverlierst du die Hälfte deines Geldes...", italian="Se finisci KO dentro un dungeon,\nperdi metà dei tuoi soldi...", spanish="Si te debilitas estando en un\nterritorio, pierdes la mitad de tu dinero..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You can even lose half your\nitems or more...", french="On peut même perdre la moitié\nde ses objets, voire plus...", german="Du kannst sogar die Hälfte\ndeiner Items oder mehr verlieren...", italian="Puoi anche perdere metà dei tuoi\nstrumenti o addirittura di più!", spanish="También es muy posible que se\npierdan la mitad de los objetos, o más..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You can even lose half your\nitems or more...", french="On peut même perdre la moitié\nde ses objets, voire plus...", german="Du kannst sogar die Hälfte\ndeiner Items oder mehr verlieren...", italian="Puoi anche perdere metà dei tuoi\nstrumenti o addirittura di più!", spanish="También es muy posible que\npierdas la mitad de los objetos, o más..."})
  else
  SkySceneKit.say({english="You can even lose half your\nitems or more...", french="On peut même perdre la moitié\nde ses objets, voire plus...", german="Du kannst sogar die Hälfte\ndeiner Items oder mehr verlieren...", italian="Puoi anche perdere metà dei tuoi\nstrumenti o addirittura di più!", spanish="También es muy posible que se\npierdan la mitad de los objetos, o más..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Finally, you get kicked right out.\nThey're very strange places.", french="Et puis, on se fait expulser\ndu donjon. Ce sont des endroits très\nétranges.", german="Und du wirst aus dem Dungeon\ngeworfen. Diese Orte sind sehr seltsam.", italian="E ti ritrovi fuori dal dungeon.\nSono dei luoghi molto bizzarri.", spanish="Y, además, luego apareces fuera.\nLo cierto es que son unos sitios muy raros."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Finally, you get kicked right out.\nThey're very strange places.", french="Et puis, on se fait expulser\ndu donjon. Ce sont des endroits très\nétranges.", german="Und du wirst aus dem Dungeon\ngeworfen. Diese Orte sind sehr seltsam.", italian="E ti ritrovi fuori dal dungeon.\nSono dei luoghi molto bizzarri.", spanish="Y, además, luego aparecerás\nfuera. La verdad es que son unos sitios\nmuy raros."})
  else
  SkySceneKit.say({english="Finally, you get kicked right out.\nThey're very strange places.", french="Et puis, on se fait expulser\ndu donjon. Ce sont des endroits très\nétranges.", german="Und du wirst aus dem Dungeon\ngeworfen. Diese Orte sind sehr seltsam.", italian="E ti ritrovi fuori dal dungeon.\nSono dei luoghi molto bizzarri.", spanish="Y, además, luego apareces fuera.\n¡Son unos lugares muy extraños!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But every time you go inside\none, there are always new things to discover!", french="Mais à chaque fois qu'on va\ndans un donjon, il y a de nouvelles choses\nà découvrir!", german="Aber jedes Mal, wenn du einen\nbetrittst, gibt es neue Dinge zu entdecken!", italian="Ma ogni volta che ci entri,\nci sono sempre nuove cose da scoprire!", spanish="¡Pero también es cierto que\ncada vez que entras aparecen cosas nuevas!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But every time you go inside\none, there are always new things to discover!", french="Mais à chaque fois qu'on va\ndans un donjon, il y a de nouvelles choses\nà découvrir!", german="Aber jedes Mal, wenn du einen\nbetrittst, gibt es neue Dinge zu entdecken!", italian="Ma ogni volta che ci entri,\nci sono sempre nuove cose da scoprire!", spanish="¡Pero también es cierto que\ncada vez que entras aparecen cosas nuevas!"})
  else
  SkySceneKit.say({english="But every time you go inside\none, there are always new things to discover!", french="Mais à chaque fois qu'on va\ndans un donjon, il y a de nouvelles choses\nà découvrir!", german="Aber jedes Mal, wenn du einen\nbetrittst, gibt es neue Dinge zu entdecken!", italian="Ma ogni volta che ci entri,\nci sono sempre nuove cose da scoprire!", spanish="¡Pero también es cierto que\ncada vez que entras aparecen cosas nuevas!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="They're really awesome places\nto explore!", french="Ce sont des endroits vraiment\ngéniaux à explorer!", german=" Sie sind super zum Erkunden!", italian="Ci sono dei posti incredibili\nda esplorare!", spanish="¡Y por eso merece la pena\nexplorarlos una y otra vez!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="They really are fantastic places\nto go exploring!", french="Ce sont des endroits vraiment\ngéniaux à explorer!", german="Sie eignen sich hervorragend\nzum Erkunden!", italian="Ci sono dei posti davvero\nfantastici da esplorare!", spanish="¡Eso hace que merezca\nla pena ir a explorarlos de vez en cuando!"})
  else
  SkySceneKit.say({english="They really are fantastic places\nto go explore!", french="Ce sont des endroits vraiment\ngéniaux à explorer!", german="Sie eignen sich fantastisch\nzum Erkunden!", italian="Ci sono dei posti davvero\nfavolosi da esplorare!", spanish="¡Son un lugar increíble\npara ir de exploración!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Well! You're quite informed,\naren't you! ♪", french="Eh bien! Tu es bien au courant,\ndis-moi! ♪", german="Tja! Du bist ganz gut informiert,\nnicht wahr? ♪", italian="Beh! Vedo che sai parecchie\ncose! ♪", spanish="Vaya, veo que te han informado\nbien. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="That makes things much easier\nfor me to explain! ♪", french="Cela me facilite la tâche! J'ai\nmoins de choses à vous expliquer! ♪", german="Das erleichtert mir die\nErklärung um einiges! ♪", italian="Mi rende più facile spiegare\nil resto! ♪", spanish="Eso me facilita las cosas\npara explicaros todo esto. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Jobs all take place in\nmystery dungeons.", french="Toutes les missions ont lieu dans\nles donjons mystères.", german="Alle Jobs finden in Mystery\nDungeons statt.", italian="Tutte le missioni si svolgono\nall'interno di dungeon misteriosi.", spanish="Las misiones tienen lugar\nen territorios misteriosos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="So...[K]let's look for a job that you\nshould perform! ♪", french="Alors...[K] Cherchons une mission\nqui vous conviendrait! ♪", german="Also...[K] Lasst uns einen Job für\neuch suchen! ♪", italian="Allora...[K] Scegliamo una\nmissione per voi! ♪", spanish="Así que...[K] ¡Vamos a ver si hay\nuna misión adecuada para vuestro equipo! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Ah, yes. ♪ Maybe this will do?", french="Ah, oui. ♪ Celle-là devrait\nfaire l'affaire.", german=" Ah, ja. ♪ Vielleicht dieser?", italian=" Ah, sì. ♪ Andrà bene questa?", spanish=" Ah, sí. ♪ Esta nos servirá."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if true --[[BranchVariation: ROM Sky EU]] then -- if ROM: variation
  end
  -- @label_0 [étiquette de flux ExplorerScript]
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(-16), p.Y+(16), false, 2) end -- Move2PositionOffset
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5124) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(45)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(16), p.Y+(-16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.Left)
  pcall(function() SOUND:FadeOutBGM(120) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, yeah? Let's read it!", french=" Oh, vraiment? Lisons-la!", german=" Wirklich? Lass es uns lesen!", italian=" Oh, sì? Leggiamo!", spanish=" ¿Ah, sí? ¡Veamos el anuncio!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, really? Let's read it!", french=" Oh, vraiment? Lisons-la!", german=" Oh, wirklich? Lass es uns lesen!", italian=" Oh, sì? Leggiamo!", spanish=" ¿Ah, sí? ¡Leamos el anuncio!"})
  else
  SkySceneKit.say({english=" Oh, really? Let's read it!", french=" Oh, vraiment? Lisons-la!", german=" Oh, wirklich? Lass es uns lesen!", italian=" Oh, sì? Leggiamo!", spanish=" ¿Sí? ¡Vamos a leer el anuncio!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\\\"Hello! My name is [CS:N]Spoink[CR]!\\\"", french="\\\"Bonjour! Mon nom est [CS:N]Spoink[CR]!", german="[F:S2]Hallo! Mein Name ist [CS:N]Spoink[CR]![F:E2]", italian="\\\"Ciao! Mi chiamo [CS:N]Spoink[CR]!\\\"", spanish="\\\"¡Hola! Me llamo [CS:N]Spoink[CR].\\\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\"An outlaw has run off with my most prized\npossession. My precious pearl!\"", french="Un hors-la-loi s'est enfui avec mon bien\nle plus cher. Ma perle précieuse!", german="[F:S2]Ein Ganove ist mit meinem wertvollsten\nBesitz abgehauen, mit meiner kostbaren\nPerle![F:E2]", italian="\"Un ricercato è scappato con la cosa più\npreziosa che ho. La mia perla!\"", spanish="\"Un desaprensivo se ha escapado con mi\nposesión más preciada... ¡Mi valiosa perla!\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\\\"That pearl is life itself...to me!\\\"", french="Cette perle... est tout pour moi!", german="[F:S2]Diese Perle bedeutet mir so viel wie mein\nLeben![F:E2]", italian="\\\"Quella perla è tutta la mia vita!\\\"", spanish="\\\"¡Esa perla es... mi vida!\\\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\"I just can't seem to settle down if that pearl\nisn't in its proper place atop my head!\"", french="Je ne peux pas retrouver mon calme tant que\ncette perle n'est pas à sa place, c'est-à-dire\nsur ma tête!", german="[F:S2]Ich kann mich einfach nicht beruhigen, solange\ndiese Perle nicht auf meinem Kopf ist. Da, wo\nsie hingehört![F:E2]", italian="\"Non riesco proprio a stare tranquillo se non\nho quella perla sulla testa!\"", spanish="\\\"No me siento capaz de hacer nada sin ella.\\\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\\\"But I've heard my pearl has been sighted!\\\"", french="J'ai entendu dire qu'on a vu ma perle!", german="[F:S2]Doch ich habe gehört, dass meine Perle\ngesehen wurde![F:E2]", italian="\\\"Ma ho sentito dire che qualcuno l'ha vista!\\\"", spanish="\"Me han llegado rumores sobre dónde podría\nestar.\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\"It's said to be on a rocky bluff. But this bluff\nis reported to be extremely unsafe.\"", french="On dit l'avoir vue sur une falaise rocheuse.\nMais on dit aussi que cette falaise est très\ndangereuse.", german="[F:S2]Sie soll sich auf einer felsigen Klippe\nbefinden, und diese Klippe soll sehr gefährlich\nsein.[F:E2]", italian="\"Dovrebbe trovarsi in un luogo paludoso.\nMa pare sia molto pericoloso.\"", spanish="\"He oído que se encuentra en una especie de\nacantilado, pero parece ser un lugar muy\npeligroso.\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\\\"I could never go somewhere so frightening!\\\"", french="Je ne pourrai jamais aller dans un endroit\naussi effrayant!", german="[F:S2]An einen so furchterregenden Ort könnte ich\nniemals gehen![F:E2]", italian="\"Non potrei mai andare in un posto così\nspaventoso!\"", spanish="\"Me siento incapaz de arriesgarme a ir\nen mi estado actual.\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\"Oh, friendly readers! Would you be so kind as\nto go to the bluff and get my pearl?\"", french="Oh, chers lecteurs! Auriez-vous la bonté\nd'aller à cette falaise pour récupérer\nma perle?", german="[F:S2]Oh liebe Leser! Wärt ihr so freundlich, zu\ndieser Klippe zu gehen und meine Perle\nzurückzuholen?[F:E2]", italian="\"Oh, cari lettori! Sareste così gentili da\nandare laggiù per recuperare la mia perla?\"", spanish="\"¡Oh, simpáticos lectores! ¿Seríais tan\namables de ir al risco a buscar mi perla?\""})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="\"I beg your help, exploration team members!\"\nFrom [CS:N]Spoink[CR]", french="J'implore votre aide, explorateurs!\"\n[CS:N]Spoink[CR]", german="[F:S2]Ich flehe um eure Hilfe, Erkundungsteams!\nVon [CS:N]Spoink[CR][F:E2]", italian="\"Aiutatemi, membri delle squadre\nd'esplorazione!\"\n- [CS:N]Spoink[CR] -", spanish="\"¡Os ruego que me ayudéis, exploradores!\"\nFirmado: [CS:N]Spoink[CR]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hold on a second!", french=" Attends une minute!", german=" Eine Sekunde!", italian=" Aspetta un attimo!", spanish=" ¡Un segundo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wait a second...", french=" Attends une minute!", german=" Moment mal...", italian=" Aspetta un attimo...", spanish=" ¡Un momento!"})
  else
  SkySceneKit.say({english=" Wait a second...", french=" Attends une minute!", german=" Moment mal...", italian=" Aspetta un attimo...", spanish=" ¡Un momento!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: SetEffect EFFECT_ANGRY_MIRRORED — VFX sans émote PMDO équivalente
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We're only going to fetch an\nitem that someone dropped?", french="On doit se contenter d'aller\nchercher un objet que quelqu'un a fait\ntomber?", german="Wir sollen nur ein Item holen,\ndas jemand verloren hat?", italian="Dobbiamo solo recuperare\nuna cosa che qualcuno ha perso?", spanish="¿Es que vamos a ir a buscar\nun objeto que se le ha caído a alguien?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're going to fetch an item\nthat someone dropped?", french="On doit se contenter d'aller\nchercher un objet que quelqu'un a fait\ntomber?", german="Wir holen ein Item zurück,\ndas jemand verloren hat?", italian="Dobbiamo recuperare\nuna cosa che qualcuno ha perso?", spanish="¿Vamos a ir a buscar\nun objeto que haya perdido alguien?"})
  else
  SkySceneKit.say({english="We're going to fetch an item\nthat someone dropped?", french="On doit se contenter d'aller\nchercher un objet que quelqu'un a fait\ntomber?", german="Wir holen ein Item zurück,\ndas jemand verloren hat?", italian="Dobbiamo recuperare\nuna cosa che qualcuno ha perso?", spanish="¿Vamos a ir a buscar\nun objeto que se le haya caído a alguien?"})
  end
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's hardly an adventure\nat all!", french=" Ça n'a rien d'une aventure!", german=" Das ist doch kein Abenteuer!", italian="Ma che razza di avventura\nsarebbe?", spanish="¡Eso a mí no me parece\nuna aventura precisamente!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I would rather do something\nthat's more of an adventure.", french=" Ça n'a rien d'une aventure!", german="Ich würde lieber etwas\nAbenteuerlicheres tun.", italian="Non c'è un compito più\navventuroso?", spanish="¡Preferiría hacer algo que\nse pareciera más a una aventura!"})
  else
  SkySceneKit.say({english="I'd rather go on a bigger\nadventure than that.", french=" Ça n'a rien d'une aventure!", german="Ich würde gerne ein größeres\nAbenteuer erleben.", italian="Preferirei un compito più\navventuroso.", spanish="Tiene que haber una aventura\nmás emocionante que esa."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'd rather look for treasure or\nexplore unknown places. Things like that!", french="Je préférerais aller chercher\ndes trésors ou explorer des endroits inconnus.\nQuelque chose de passionnant, quoi!", german="Ich würde lieber Schätze suchen\noder unbekannte Orte erkunden. Solche Sachen!", italian="Vorrei andare in cerca di\ntesori o luoghi sconosciuti. Cose del genere!", spanish="Preferiría ir a buscar un tesoro\no a explorar sitios desconocidos. ¡Algo así!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'd rather look for treasure or\nexplore unknown places. Things like that!", french="Je préférerais aller chercher\ndes trésors ou explorer des endroits inconnus.\nQuelque chose de passionnant, quoi!", german="Ich würde lieber Schätze suchen\noder unbekannte Orte erkunden. Solche Sachen!", italian="Vorrei andare in cerca di\ntesori o luoghi sconosciuti. Cose del genere!", spanish="Preferiría ir a buscar tesoros\no de exploración. ¡Cosas así!"})
  else
  SkySceneKit.say({english="I'd rather look for treasure or\nexplore unknown places. Things like that!", french="Je préférerais aller chercher\ndes trésors ou explorer des endroits inconnus.\nQuelque chose de passionnant, quoi!", german="Ich würde lieber Schätze suchen\noder unbekannte Orte erkunden. Solche Sachen!", italian="Vorrei andare in cerca di\ntesori o luoghi sconosciuti. Cose del genere!", spanish="Preferiría ir a buscar un tesoro\no a explorar sitios desconocidos. ¡Algo así!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Hush!", french=" Silence!", german=" Kusch!", italian=" Shhh!", spanish=" ¡Silencio!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yikes!", french=" Oups!", german=" Oh Mann!", italian=" Gasp!", spanish=" ¡Huy!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yikes!", french=" Oups!", german=" Oh Mann!", italian=" Gasp!", spanish=" ¡Huy!"})
  else
  SkySceneKit.say({english=" Yikes!", french=" Oups!", german=" Oh Mann!", italian=" Gulp!", spanish=" ¡Huy!"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It's important that you rookies\npay your dues!", french="Vous êtes des novices, vous\ndevez d'abord faire vos preuves, c'est\nimportant!", german="Es ist wichtig, dass ihr Neulinge\neure Pflicht tut!", italian="È importante che i principianti\ncome voi vadano per gradi!", spanish="¡Los novatos tenéis que cumplir\ncon vuestras responsabilidades antes que nada!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Now pay attention![K] I'll repeat\nthe warnings again to make sure they stick!", french="Maintenant, écoutez-moi![K]\nJe vais répéter les recommandations pour\nêtre bien certain que vous avez compris!", german="Jetzt passt auf![K] Ich wiederhole\nmeine Warnungen, damit ihr sie auch behaltet!", italian="Adesso fate attenzione![K]\nRipeterò ancora gli avvertimenti per essere\nsicuro che non ve li dimentichiate!", spanish="¡Y ahora prestad atención![K]\nVolveré a advertiros para que no os olvidéis."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You'll be forced out of a dungeon\nand sent back here if either of you faints.", french="Il suffit que [hero] ou\n[partner] tombe K.O. pour que les deux se\nfassent expulser d'un donjon et renvoyer ici.", german="Ihr werdet aus einem Dungeon\ngeworfen und zurückgeschickt, wenn einer von\neuch besiegt wird.", italian="Se uno dei due va KO in un\ndungeon, vi ritroverete qui.", spanish="Procurad no debilitaros. Si el\nlíder o el acompañante se debilitan, el\nequipo será expulsado del territorio."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You'll lose half your money![K]\nAnd you could lose half your items or more.\nYou'd best be careful!", french="Vous perdez alors la moitié de\nvotre argent![K] Et vous pourriez perdre la\nmoitié de vos objets, voire plus. Attention!", german="Ihr verliert die Hälfte eures\nGeldes![K] Und ihr riskiert, die Hälfte oder sogar\nmehr eurer Items zu verlieren. Gebt also acht!", italian="Perderete metà dei vostri\nsoldi![K] E potreste perdere metà dei vostri\nstrumenti o anche di più. Fate attenzione!", spanish="¡Perderéis la mitad del dinero![K]\nY podríais perder la mitad de los objetos o\nincluso más, ¡así que id con cuidado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="If you've understood all that,\nI suggest you get on with the job! ♪", french="Si vous avez tout compris,\nje vous suggère d'aller travailler! ♪", german="Habt ihr alles verstanden?\nDann schlage ich vor, ihr nehmt den Job in\nAngriff! ♪", italian="Se avete capito tutto,\nvi consiglio di mettervi al lavoro! ♪", spanish="Si no tenéis más preguntas, os\nsugiero que os pongáis manos a la obra. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hmm...", french=" Hmm...", german=" Hmm...", italian=" Mmm...", spanish=" Hum..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hmm...", french=" Hmm...", german=" Hmm...", italian=" Mmm...", spanish=" Hum..."})
  else
  SkySceneKit.say({english=" Hmm...", french=" Hmm...", german=" Hmm...", italian=" Mmm...", spanish=" Vaya..."})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[3] = 1 -- dungeon_mode(3) = DMODE_OPEN (ROM)
  SkySceneKit.cleanup_npcs()
end
