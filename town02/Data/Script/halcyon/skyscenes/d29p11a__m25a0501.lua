-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D29P11A/m25a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(26, 2) -- $SCENARIO_MAIN = scn[26,2] (ROM)
  -- back_SetGround(LEVEL_D29P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Temporal Tower.ogg", true) end)
  GAME:WaitFrames(60)
  pcall(function() GAME:MoveCamera(300, 276, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 284, 276, false, 2)
  GROUND:MoveToPosition(hero, 316, 276, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This is...[K] This is the entrance to\n[CS:P]Temporal Tower[CR].", french="Voici...[K] voici l'entrée de la [CS:P]Tour\ndu Temps[CR].", german="Das ist[K] der Eingang zum\n[CS:P]Zeitturm[CR].", italian="Questo è...[K] l'ingresso della\n[CS:P]Torre del Tempo[CR].", spanish="Esta es...[K] Esta es la entrada de\nla [CS:P]Torre del Tiempo[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This is...[K] This is the entrance to\n[CS:P]Temporal Tower[CR].", french="Voici...[K] voici l'entrée de la [CS:P]Tour\ndu Temps[CR].", german="Das ist[K] der Eingang zum\n[CS:P]Zeitturm[CR].", italian="Questo è...[K] l'ingresso della\n[CS:P]Torre del Tempo[CR].", spanish="Esta es...[K] Esta es la entrada de\nla [CS:P]Torre del Tiempo[CR]."})
  else
  SkySceneKit.say({english="This is...[K] This is the entrance to\n[CS:P]Temporal Tower[CR].", french="Voici...[K] voici l'entrée de la [CS:P]Tour\ndu Temps[CR].", german="Das ist[K] der Eingang zum\n[CS:P]Zeitturm[CR].", italian="Questo è...[K] l'ingresso della\n[CS:P]Torre del Tempo[CR].", spanish="Esta es...[K] Esta es la entrada de\nla [CS:P]Torre del Tiempo[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5131) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa! Earthquake!", french=" Ouah! Le sol tremble!", german=" Ein Erdbeben!", italian=" Aaah! Un terremoto!", spanish=" ¡Vaya! ¡Un terremoto!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah! The ground's shaking!", french=" Ouah! Le sol tremble!", german=" Waah! Der Boden wackelt!", italian=" Aaah! La terra sta tremando!", spanish="¡Vaya!\n¡La tierra está temblando!"})
  else
  SkySceneKit.say({english=" Waah! The ground's shaking!", french=" Ouah! Le sol tremble!", german=" Waah! Der Boden wackelt!", italian=" Aaah! La terra sta tremando!", spanish=" ¡Vaya! ¡Un temblor de tierra!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  -- se_FadeOut(5131, 60) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[K]Did it settle down...?", french=" ...[K] Ça s'est calmé...?", german=" ...[K]Ist es vorbei?", italian=" ...[K] È finito...?", spanish=" Uf...[K] ¿Ya ha parado?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[K]Did it settle down...?", french=" ...[K] Ça s'est calmé...?", german=" ...[K]Ist es vorbei?", italian=" ...[K] Ha smesso di tremare...?", spanish=" Uf...[K] ¿Ya ha parado?"})
  else
  SkySceneKit.say({english=" ...[K]Did it settle down...?", french=" ...[K] Ça s'est calmé...?", german=" ...[K]Ist es vorbei?", italian=" ...[K] Ha smesso di tremare...?", spanish=" Uf...[K] ¿Ya ha parado?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What was that earthquake,\nanyway?", french="C'était quoi, d'abord,\ncette secousse?", german="Woher kam dieses Erdbeben\ndenn überhaupt?", italian=" Cos'è stato quel terremoto?", spanish=" ¿A qué se debería ese temblor?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What was that tremor, anyway?", french="C'était quoi, d'abord,\ncette secousse?", german="Woher kam diese Erschütterung\neigentlich?", italian=" Cosa saranno stati quei tremori?", spanish="¿A qué se debería ese\nterremoto?"})
  else
  SkySceneKit.say({english=" What was that tremor, anyway?", french="C'était quoi, d'abord,\ncette secousse?", german="Woher kam diese Erschütterung\neigentlich?", italian=" Cosa saranno stati quei tremori?", spanish="¿A qué se debería ese\nterremoto?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! That reminds me!", french="Eh, ça me rappelle quelque\nchose!", german="Hey! Das erinnert mich an\netwas!", italian=" Ehi! Ora ricordo!", spanish="Espera, ¡eso me recuerda\nuna cosa!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! That reminds me!", french="Eh, ça me rappelle quelque\nchose!", german="Hey! Das erinnert mich an\netwas!", italian=" Ehi! Ora ricordo!", spanish="Espera, ¡eso me recuerda\nuna cosa!"})
  else
  SkySceneKit.say({english=" Oh! That reminds me!", french="Eh, ça me rappelle quelque\nchose!", german="Hey! Das erinnert mich an\netwas!", italian=" Oh! Ora ricordo!", spanish="Espera, ¡eso me recuerda\nuna cosa!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Grovyle[CR] once said something\nabout this!", french="[CS:N]Massko[CR] en a parlé\nl'autre fois!", german="[CS:N]Reptain[CR] hat mal etwas darüber\ngesagt!", italian="[CS:N]Grovyle[CR] una volta ce ne ha\nparlato!", spanish="[CS:N]Grovyle[CR] comentó en cierta\nocasión algo sobre esto."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Grovyle[CR] once said something\nabout this!", french="[CS:N]Massko[CR] en a parlé\nl'autre fois!", german="[CS:N]Reptain[CR] hat mal etwas darüber\ngesagt!", italian="[CS:N]Grovyle[CR] una volta ce ne ha\nparlato!", spanish="[CS:N]Grovyle[CR] comentó en cierta\nocasión algo sobre esto."})
  else
  SkySceneKit.say({english="[CS:N]Grovyle[CR] once said something\nabout this!", french="[CS:N]Massko[CR] en a parlé\nl'autre fois!", german="[CS:N]Reptain[CR] hat mal etwas darüber\ngesagt!", italian="[CS:N]Grovyle[CR] una volta ce ne ha\nparlato!", spanish="[CS:N]Grovyle[CR] comentó en cierta\nocasión algo sobre esto."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="He said that time started going\nout of control when [CS:P]Temporal Tower[CR] began\nto collapse.", french="Il a dit que le temps s'était mis\nà se détraquer quand la [CS:P]Tour du Temps[CR] avait\ncommencé à s'effondrer.", german="Er sagte, die Zeit sei außer\nKontrolle geraten, weil der [CS:P]Zeitturm[CR]\neinzustürzen begann.", italian="Ci ha detto che il tempo ha\niniziato a sfuggire al controllo nel momento in\ncui la [CS:P]Torre del Tempo[CR] ha iniziato a crollare.", spanish="Dijo que el tiempo comenzó a\nquedar fuera de control cuando empezó a\nderrumbarse la [CS:P]Torre del Tiempo[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="He said that time started going\nout of control everywhere because [CS:P]Temporal\nTower[CR] began collapsing.", french="Il a dit que le temps s'était mis\nà se détraquer quand la [CS:P]Tour du Temps[CR] avait\ncommencé à s'effondrer.", german="Er sagte, die Zeit sei außer\nKontrolle geraten, weil der [CS:P]Zeitturm[CR]\neinzustürzen begann.", italian="Ci ha detto che il tempo ha\niniziato a sfuggire al controllo nel momento in\ncui la [CS:P]Torre del Tempo[CR] ha iniziato a crollare.", spanish="Dijo que el tiempo comenzó a\nquedar fuera de control cuando empezó a\nderrumbarse la [CS:P]Torre del Tiempo[CR]."})
  else
  SkySceneKit.say({english="He said that time started going\nout of control everywhere because [CS:P]Temporal\nTower[CR] began collapsing.", french="Il a dit que le temps s'était mis\nà se détraquer quand la [CS:P]Tour du Temps[CR] avait\ncommencé à s'effondrer.", german="Er sagte, die Zeit sei außer\nKontrolle geraten, weil der [CS:P]Zeitturm[CR]\neinzustürzen begann.", italian="Ci ha detto che il tempo ha\niniziato a sfuggire al controllo nel momento in\ncui la [CS:P]Torre del Tempo[CR] ha iniziato a crollare.", spanish="Dijo que el tiempo comenzó a\nquedar fuera de control cuando empezó a\nderrumbarse la [CS:P]Torre del Tiempo[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So that quake we just felt...", french="Alors cette secousse tout\nà l'heure...", german="Das Beben, das wir gerade\ngespürt haben...", italian="Quindi quelle scosse che\nabbiamo appena sentito...", spanish="Así que ese terremoto que\nacabamos de sentir..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So that tremor we just felt...", french="Alors cette secousse tout\nà l'heure...", german="Die Erschütterung, die wir\ngerade gespürt haben...", italian="Quindi quei tremori che abbiamo\nappena sentito...", spanish="Así que ese terremoto que\nacabamos de sentir..."})
  else
  SkySceneKit.say({english=" So that tremor we just felt...", french="Alors cette secousse tout\nà l'heure...", german="Die Erschütterung, die wir\ngerade gespürt haben...", italian="Quindi quei tremori che abbiamo\nappena sentito...", spanish="Así que ese terremoto que\nacabamos de sentir..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:P]Temporal Tower[CR] might be falling\napart as we speak...", french="Si ça se trouve, la [CS:P]Tour\ndu Temps[CR] est en train de s'écrouler\nen ce moment même...", german="Der [CS:P]Zeitturm[CR] könnte bereits\neinstürzen, während wir uns hier unterhalten...", italian="La [CS:P]Torre del Tempo[CR] potrebbe\ncrollare da un momento all'altro...", spanish="La [CS:P]Torre del Tiempo[CR] debe de\nestar comenzando a desplomarse..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:P]Temporal Tower[CR] could be\ncollapsing as we speak...", french="Si ça se trouve, la [CS:P]Tour\ndu Temps[CR] est en train de s'écrouler\nen ce moment même...", german="Der [CS:P]Zeitturm[CR] könnte bereits\neinstürzen, während wir uns hier unterhalten...", italian="La [CS:P]Torre del Tempo[CR] potrebbe\ncrollare da un momento all'altro...", spanish="La [CS:P]Torre del Tiempo[CR] debe de\nestar comenzando a desplomarse..."})
  else
  SkySceneKit.say({english="[CS:P]Temporal Tower[CR] could be falling\napart even as we speak...", french="Si ça se trouve, la [CS:P]Tour\ndu Temps[CR] est en train de s'écrouler\nen ce moment même...", german="Der [CS:P]Zeitturm[CR] könnte bereits\neinstürzen, während wir uns hier unterhalten...", italian="La [CS:P]Torre del Tempo[CR] potrebbe\ncrollare da un momento all'altro...", spanish="La [CS:P]Torre del Tiempo[CR] debe de\nestar comenzando a desplomarse..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We've got to hurry,\n[hero]!", french="Il faut faire vite,\n[hero]!", german="Beeilen wir uns,\n[hero]!", italian="Dobbiamo sbrigarci,\n[hero]!", spanish="¡Hay que darse prisa,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to hurry,\n[hero]!", french="Il faut faire vite,\n[hero]!", german="Wir müssen uns beeilen,\n[hero]!", italian="Dobbiamo sbrigarci,\n[hero]!", spanish="¡Hay que darse prisa,\n[hero]!"})
  else
  SkySceneKit.say({english=" Hurry, [hero]!", french="Il faut faire vite,\n[hero]!", german=" Beeilung, [hero]!", italian=" Presto, [hero]!", spanish="¡Hay que darse prisa,\n[hero]!"})
  end
  -- message_Close
end
