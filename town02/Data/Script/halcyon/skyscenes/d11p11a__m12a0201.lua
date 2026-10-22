-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D11P11A/m12a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(13, 2) -- $SCENARIO_MAIN = scn[13,2] (ROM)
  -- back_SetGround(LEVEL_D11P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Amp Plains.ogg", true) end)
  GROUND:MoveToPosition(partner, 212, 196, false, 2)
  GROUND:MoveToPosition(hero, 244, 196, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So this is the entrance to\n[CS:P]Amp Plains[CR], huh?", french="Voilà sûrement l'entrée\ndes [CS:P]Plaines Elek[CR].", german="Das ist also der Eingang zur\n[CS:P]Ampere-Ebene[CR], was?", italian="E così questo è l'ingresso delle\n[CS:P]Pianure Saetta[CR], eh?", spanish="Así que esta es la entrada\na la [CS:P]Pradera Destello[CR], ¿eh?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This must be the entrance to\n[CS:P]Amp Plains[CR].", french="Voilà sûrement l'entrée\ndes [CS:P]Plaines Elek[CR].", german="Das muss der Eingang zur\n[CS:P]Ampere-Ebene[CR] sein.", italian="Questo dev'essere l'ingresso\ndelle [CS:P]Pianure Saetta[CR].", spanish="Esta debe de ser la entrada\na la [CS:P]Pradera Destello[CR]."})
  else
  SkySceneKit.say({english="This must be the entrance to\n[CS:P]Amp Plains[CR].", french="Voilà sûrement l'entrée\ndes [CS:P]Plaines Elek[CR].", german="Das muss der Eingang zur\n[CS:P]Ampere-Ebene[CR] sein.", italian="Questo dev'essere l'ingresso\ndelle [CS:P]Pianure Saetta[CR].", spanish="Esta tiene que ser la entrada\na la [CS:P]Pradera Destello[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I don't know what sort of\ncreeps would do something like this...", french="Il faut vraiment être un vaurien\npour faire une chose pareille...", german="Ich weiß nicht, welche Sorte\nFiesling so etwas tun würde...", italian="Bisogna proprio essere dei\nfurfanti per architettare una cosa del genere...", spanish="No sé quién podría rebajarse\na hacer algo así..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I can't imagine what sort of\nbullies would do something like this...", french="Il faut vraiment être un vaurien\npour faire une chose pareille...", german="Ich kann mir nicht vorstellen,\nwelche Rohlinge so etwas tun würden...", italian="Bisogna proprio essere dei\nfurfanti per architettare una cosa del genere...", spanish="No sé quién podría rebajarse\na hacer algo así..."})
  else
  SkySceneKit.say({english="I can't imagine what sort of\ncreeps would do something like this...", french="Il faut vraiment être un vaurien\npour faire une chose pareille...", german="Ich weiß nicht, welche Sorte\nFiesling so etwas tun würde...", italian="Bisogna proprio essere dei\nfurfanti per architettare una cosa del genere...", spanish="No sé quién podría rebajarse\na hacer algo así..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I mean, threatening little kids\nlike those brothers really stinks.", french="C'est vrai, c'est moche\nde menacer des enfants comme ça.", german="Ich meine, kleine Kinder wie\ndie beiden Brüder zu bedrohen, ist wirklich\neine Gemeinheit.", italian="Come si può fare questo a dei\npiccoli indifesi come quei due fratellini?", spanish="Amenazar a unos chiquillos\ncomo estos es caer muy bajo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I mean, threatening little kids\nlike those brothers really stinks.", french="C'est vrai, c'est moche\nde menacer des enfants comme ça.", german="Ich meine, kleine Kinder wie\ndie beiden Brüder zu bedrohen, ist wirklich\neine Gemeinheit.", italian="Come si può fare questo a dei\npiccoli indifesi come quei due fratellini?", spanish="Amenazar a unos chiquillos\ncomo estos no tiene perdón."})
  else
  SkySceneKit.say({english="I mean, threatening little kids\nlike those brothers really stinks.", french="C'est vrai, c'est moche\nde menacer des enfants comme ça.", german="Ich meine, kleine Kinder wie\ndie beiden Brüder zu bedrohen, ist wirklich\neine Gemeinheit.", italian="Come si può fare questo a dei\npiccoli indifesi come quei due fratellini?", spanish="Amenazar a unos chiquillos\ncomo estos no tiene perdón."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We've got to get their [CS:Z]Water\nFloat[CR] back for sure, [hero]!", french="Il faut absolument\nqu'on récupère leur [CS:Z]Hydroflotteur[CR],\n[hero]!", german="Wir müssen ihren [CS:Z]Schwimmreif[CR]\nauf jeden Fall zurückholen, [hero]!", italian="Dobbiamo recuperare la loro\n[CS:Z]Acquaboa[CR] a tutti i costi, [hero]!", spanish="¡Hay que recuperar su [CS:Z]Flotarill[CR]\ncomo sea, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to get their [CS:Z]Water\nFloat[CR] back, [hero]!", french="Il faut absolument\nqu'on récupère leur [CS:Z]Hydroflotteur[CR],\n[hero]!", german="Wir müssen ihren [CS:Z]Schwimmreif[CR]\nzurückholen, [hero]!", italian="Dobbiamo recuperare la loro\n[CS:Z]Acquaboa[CR] a tutti i costi, [hero]!", spanish="¡Hay que recuperar su [CS:Z]Flotarill[CR]\ncomo sea, [hero]!"})
  else
  SkySceneKit.say({english="Let's make sure we get their\n[CS:Z]Water Float[CR] back, [hero]!", french="Il faut absolument\nqu'on récupère leur [CS:Z]Hydroflotteur[CR],\n[hero]!", german="Holen wir ihren [CS:Z]Schwimmreif[CR]\nauf jeden Fall zurück, [hero]!", italian="Dobbiamo recuperare la loro\n[CS:Z]Acquaboa[CR] a tutti i costi, [hero]!", spanish="¡Hay que recuperar su [CS:Z]Flotarill[CR]\ncomo sea, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 212, 132, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 244, 132, false, 2)
  GAME:WaitFrames(20)
  -- main_EnterDungeon(17, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
end
