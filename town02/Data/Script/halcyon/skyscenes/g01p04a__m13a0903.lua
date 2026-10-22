-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m13a0903.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P04A, 'UM13') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(6) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.DownLeft, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 432, 240, Direction.UpRight, "NPC_YONOWAARU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Yes![K] That's right!)", french="(Oui![K] C'est ça!)", german="(Ja![K] Das ist es!)", italian="(Sì![K] Ma certo!)", spanish="(¡Sí![K] ¡Eso es!)"})
  else
  SkySceneKit.say({english="(Yes![K] That's right!)", french="(Oui![K] C'est ça!)", german="(Ja![K] Das ist es!)", italian="(Sì![K] Ma certo!)", spanish="(¡Sí![K] ¡Eso es!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Yesterday at the quicksand pits, we assumed\nthat it was a dead end for our search...)", french="(Hier on s'est arrêtés aux sables mouvants,\npensant que c'était un cul-de-sac...)", german="(Gestern bei den Treibsandstrudeln dachten\nwir, wir sind in einer Sackgasse.)", italian="(Ieri, quando ci siamo trovati di fronte alle\nsabbie mobili, abbiamo pensato che si trattasse\ndi un vicolo cieco.)", spanish="(Ayer, cuando llegamos a las arenas movedizas\ndimos por hecho que estábamos en un callejón\nsin salida...)"})
  else
  SkySceneKit.say({english="(Yesterday at the quicksand pits, we assumed\nthat it was a dead end for our search...)", french="(Hier, on a supposé que les sables mouvants\nétaient un cul-de-sac...)", german="(Gestern bei den Treibsandstrudeln dachten\nwir, wir sind in einer Sackgasse.)", italian="(Ieri, quando abbiamo raggiunto le sabbie\nmobili, abbiamo pensato che si trattasse di un\nvicolo cieco.)", spanish="(Ayer, cuando llegamos a las arenas movedizas\ndimos por hecho que estábamos en un callejón\nsin salida...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But maybe there really are secrets there...)", french="(Mais peut-être qu'ils dissimulent un secret...)", german="(Aber vielleicht liegt dort doch ein\nGeheimnis verborgen.)", italian="(Ma non tutto è come sembra...)", spanish="(Pero tal vez oculten algo.)"})
  else
  SkySceneKit.say({english="(But maybe there really are secrets there...)", french="(Mais peut-être qu'ils dissimulent un secret...)", german="(Aber vielleicht liegt dort doch ein\nGeheimnis verborgen.)", italian="(Ma non tutto è come sembra...)", spanish="(Pero tal vez oculten algo.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What's up?[K] Are you daydreaming\nagain?", french="Qu'est-ce qui se passe?[K] Tu es\nencore dans la lune?", german="Was ist?[K] Hast du wieder einen\nTagtraum?", italian="Ehi![K] Che succede? Stai di nuovo\ndormendo in piedi?", spanish=" ¿Qué pasa?[K] ¿Otra vez en Babia?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What's the matter?[K] Are you off\nin another daydream?", french="Qu'est-ce qui se passe?[K] Tu es\nencore dans la lune?", german="Was ist los?[K] Steckst du schon\nwieder in einem Tagtraum?", italian="Ehi, tutto bene?[K] Hai\nricominciato a perderti nei tuoi pensieri?", spanish=" ¿Qué pasa?[K] ¿Otra vez en Babia?"})
  else
  SkySceneKit.say({english="What's wrong?[K] You seem to be\nin a daze again!", french="Qu'est-ce qui se passe?[K] Tu es\nencore dans la lune?", german="Stimmt etwas nicht?[K] Du wirkst\nschon wieder ganz abwesend!", italian="Ehi, tutto bene?[K] Hai\nricominciato a perderti nei tuoi pensieri?", spanish=" ¿Qué pasa?[K] ¿Otra vez en Babia?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Huh? You want to go back to\n[CS:P]Quicksand Desert[CR]?", french="Pardon? Tu veux retourner au\n[CS:P]Désert Sables Mouvants[CR]?", german="Was? Du willst noch einmal zur\n[CS:P]Mahlsandwüste[CR]?", italian="Eh? Vuoi tornare al [CS:P]Deserto[CR]\n[CS:P]delle Sabbie Mobili[CR]?", spanish="¿Qué? ¿Que quieres volver a las\n[CS:P]Arenas Movedizas[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What? You want to go back to\n[CS:P]Quicksand Desert[CR]?", french="Pardon? Tu veux retourner au\n[CS:P]Désert Sables Mouvants[CR]?", german="Wie? Du willst noch einmal zur\n[CS:P]Mahlsandwüste[CR]?", italian="Cosa? Vuoi tornare al\n[CS:P]Deserto delle Sabbie Mobili[CR]?", spanish="¿Qué? ¿Que quieres volver a las\n[CS:P]Arenas Movedizas[CR]?"})
  else
  SkySceneKit.say({english="Pardon? You want us to go back\nto [CS:P]Quicksand Desert[CR]?", french="Pardon? Tu veux retourner au\n[CS:P]Désert Sables Mouvants[CR]?", german="Wie bitte? Du willst noch einmal\nzur [CS:P]Mahlsandwüste[CR]?", italian="Cosa? Vuoi tornare al\n[CS:P]Deserto delle Sabbie Mobili[CR]?", spanish="¿Qué? ¿Que quieres volver a las\n[CS:P]Arenas Movedizas[CR]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But we were there yesterday!\nThere wasn't anything there.", french="Mais hier il n'y avait rien\nlà-bas!", german="Aber wir waren gestern erst da!\nDa war nichts.", italian="Ma se ci siamo stati ieri! Non\nc'era un bel niente laggiù.", spanish="Pero si ya estuvimos ayer y\nno había nada."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But we were there yesterday!\nWe didn't find anything!", french="Mais hier il n'y avait rien\nlà-bas!", german="Aber wir waren gestern erst da!\nWir haben nichts gefunden!", italian=" Ma laggiù non c'è niente!", spanish="Pero si ya estuvimos ayer y\nno había nada."})
  else
  SkySceneKit.say({english="But we were there yesterday!\nWe didn't find anything!", french="Mais hier il n'y avait rien\nlà-bas!", german="Aber wir waren gestern erst da!\nWir haben nichts gefunden!", italian=" Ma laggiù non c'è niente!", spanish="Pero si ya estuvimos ayer y\nno había nada."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Huh?! When we were at\n[CS:P]Quicksand Desert[CR]...", french="Hein?! Quand on était au\n[CS:P]Désert Sables Mouvants[CR]...", german="Huch?!? Als wir in der\n[CS:P]Mahlsandwüste[CR] waren...", italian="Eh?! E così, mentre ci\ntrovavamo nel [CS:P]Deserto delle Sabbie Mobili[CR]...", spanish="¿Cómo dices? Cuando estuvimos\nen las [CS:P]Arenas Movedizas[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What?! When we were at\n[CS:P]Quicksand Desert[CR]...", french="Hein?! Quand on était au\n[CS:P]Désert Sables Mouvants[CR]...", german="Was?!? Als wir in der\n[CS:P]Mahlsandwüste[CR] waren...", italian="Come? Dici che mentre ci\ntrovavamo nel [CS:P]Deserto delle Sabbie Mobili[CR]...", spanish="¿Cómo dices? Cuando estuvimos\nen las [CS:P]Arenas Movedizas[CR]..."})
  else
  SkySceneKit.say({english="What?![K] When we were at\n[CS:P]Quicksand Desert[CR]...", french="Hein?! Quand on était au\n[CS:P]Désert Sables Mouvants[CR]...", german="Was?!?[K] Als wir in der\n[CS:P]Mahlsandwüste[CR] waren...", italian="Come?[K] Dici che mentre ci\ntrovavamo nel [CS:P]Deserto delle Sabbie Mobili[CR]...", spanish="¿Cómo dices? Cuando estuvimos\nen las [CS:P]Arenas Movedizas[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You had the same sensation that\nyou had at [CS:P]Fogbound Lake[CR]?!", french="Tu as ressenti la même\nsensation qu'au [CS:P]Lac des Brumes[CR]?!", german="Du hattest dort dasselbe Gefühl\nwie am [CS:P]Nebelsee[CR]?!?", italian="... hai avuto la stessa sensazione\ndi quando eravamo al [CS:P]Lago Foschia[CR]?", spanish="¡¿Tuviste la misma sensación\nque en el [CS:P]Lago Velado[CR]?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You experienced the same\nsensation that you had at [CS:P]Fogbound Lake[CR]?!", french="Tu as ressenti la même\nsensation qu'au [CS:P]Lac des Brumes[CR]?!", german="Du hattest dort dasselbe Gefühl\nwie am [CS:P]Nebelsee[CR]?!?", italian="... hai avuto la stessa sensazione\ndi quando eravamo al [CS:P]Lago Foschia[CR]?", spanish="¡¿Tuviste la misma sensación\nque en el [CS:P]Lago Velado[CR]?!"})
  else
  SkySceneKit.say({english="You had the same sensations that\nyou had at [CS:P]Fogbound Lake[CR]?!", french="Tu as ressenti la même\nsensation qu'au [CS:P]Lac des Brumes[CR]?!", german="Du hattest dort dasselbe Gefühl\nwie am [CS:P]Nebelsee[CR]?!?", italian="... hai avuto la stessa sensazione\ndi quando eravamo al [CS:P]Lago Foschia[CR]?", spanish="¡¿Tuviste la misma sensación\nque en el [CS:P]Lago Velado[CR]?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(90)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" OK, [hero]. If you say so!", french="Bon, d'accord, [hero].\nSi tu le dis.", german="Okay, [hero]. Wenn du\ndas sagst!", italian="Afferrato, [hero]. Se lo\ndici tu, ci credo!", spanish="De acuerdo, [hero].\nSi tú lo dices..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well then, that's settled,\n[hero]. What you say must be true.", french="Bon, d'accord, [hero].\nSi tu le dis.", german="Na dann, okay, [hero].\nWas du sagst, wird stimmen.", italian=" Ho capito, [hero].", spanish="Pues entonces allá vamos,\n[hero]. Lo que dices debe de ser cierto."})
  else
  SkySceneKit.say({english="OK, I getcha, [hero]! It\nmust be true.", french="Bon, d'accord, [hero].\nSi tu le dis.", german="Okay, schon klar, [hero]!\nDu wirst recht haben.", italian=" Ho capito, [hero].", spanish="Entendido, [hero].\nSi lo dices es que será verdad."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's go out there again! Back to\n[CS:P]Quicksand Desert[CR]!", french="C'est reparti! On retourne au\n[CS:P]Désert Sables Mouvants[CR]!", german="Gehen wir noch einmal hin!\nZurück zur [CS:P]Mahlsandwüste[CR]!", italian="Se vuoi, allora si torna nel\n[CS:P]Deserto delle Sabbie Mobili[CR]!", spanish="¡Volvamos allí de nuevo!\n¡Otra vez a las [CS:P]Arenas Movedizas[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go there again! Back to\n[CS:P]Quicksand Desert[CR]!", french="C'est reparti! On retourne au\n[CS:P]Désert Sables Mouvants[CR]!", german="Gehen wir noch einmal hin!\nZurück zur [CS:P]Mahlsandwüste[CR]!", italian="Torniamo laggiù, allora! Si parte\nper il [CS:P]Deserto delle Sabbie Mobili[CR]!", spanish="¡Volvamos allí de nuevo!\n¡Otra vez a las [CS:P]Arenas Movedizas[CR]!"})
  else
  SkySceneKit.say({english="Let's go there again! Back to\n[CS:P]Quicksand Desert[CR]!", french="C'est reparti! On retourne au\n[CS:P]Désert Sables Mouvants[CR]!", german="Gehen wir noch einmal hin!\nZurück zur [CS:P]Mahlsandwüste[CR]!", italian="Torniamo laggiù, allora! Si parte\nper il [CS:P]Deserto delle Sabbie Mobili[CR]!", spanish="¡Volvamos allí de nuevo!\n¡Otra vez a las [CS:P]Arenas Movedizas[CR]!"})
  end
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[21] = 1 -- dungeon_mode(21) = DMODE_OPEN (ROM)
  SkyProg.set(14, 6) -- $SCENARIO_MAIN = scn[14,6] (ROM)
  SkySceneKit.cleanup_npcs()
end
