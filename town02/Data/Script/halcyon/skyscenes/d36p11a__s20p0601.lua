-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D36P11A/s20p0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 74) -- $SCENARIO_MAIN = scn[29,74] (ROM)
  -- back_SetGround(LEVEL_D36P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Mt. Travail.ogg", true) end)
  GROUND:MoveToPosition(partner, 188, 148, false, 2)
  GROUND:MoveToPosition(hero, 220, 148, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So this is [CS:P]Mt. Travail[CR].", french="C'est donc ça\nle [CS:P]Mt Labeur[CR].", german=" Das ist also der [CS:P]Mühsalberg[CR].", italian=" Quindi questo è il [CS:P]Monte Odissea[CR].", spanish="Así que esto es el [CS:P]Monte[CR]\n[CS:P]Tribulaciones[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So this is [CS:P]Mt. Travail[CR].", french="C'est donc ça\nle [CS:P]Mt Labeur[CR].", german=" Das ist also der [CS:P]Mühsalberg[CR].", italian=" Quindi questo è il [CS:P]Monte Odissea[CR].", spanish="Así que esto es el [CS:P]Monte[CR]\n[CS:P]Tribulaciones[CR]."})
  else
  SkySceneKit.say({english=" This must be [CS:P]Mt. Travail[CR].", french="C'est donc ça\nle [CS:P]Mt Labeur[CR].", german=" Das muss der [CS:P]Mühsalberg[CR] sein.", italian=" Quindi questo è il [CS:P]Monte Odissea[CR].", spanish="Así que esto es el [CS:P]Monte[CR]\n[CS:P]Tribulaciones[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We need [CS:N]Drowzee[CR] to help us\nfigure out why [CS:N]Azurill[CR] won't wake up.", french="Nous devons trouver [CS:N]Soporifik[CR]\npour comprendre pourquoi [CS:N]Azurill[CR] ne se\nréveille pas.", german="Wir brauchen [CS:N]Traumato[CR], damit\ner uns hilft herauszufinden, warum [CS:N]Azurill[CR]\nnicht aufwacht.", italian="Abbiamo bisogno di [CS:N]Drowzee[CR] per\ncapire perché [CS:N]Azurill[CR] non si sveglia.", spanish="Necesitamos que [CS:N]Drowzee[CR] nos\nayude a descubrir por qué [CS:N]Azurill[CR] no logra\ndespertarse."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We need [CS:N]Drowzee[CR] to help us\nfigure out why [CS:N]Azurill[CR] won't wake up.", french="Nous devons trouver [CS:N]Soporifik[CR]\npour comprendre pourquoi [CS:N]Azurill[CR] ne se\nréveille pas.", german="Wir brauchen [CS:N]Traumato[CR], damit\ner uns hilft herauszufinden, warum [CS:N]Azurill[CR]\nnicht aufwacht.", italian="Abbiamo bisogno di [CS:N]Drowzee[CR] per\ncapire perché [CS:N]Azurill[CR] non si sveglia.", spanish="Necesitamos que [CS:N]Drowzee[CR] nos\nayude a descubrir por qué [CS:N]Azurill[CR] no logra\ndespertarse."})
  else
  SkySceneKit.say({english="We need [CS:N]Drowzee[CR] to help us\nfigure out why [CS:N]Azurill[CR] won't wake up.", french="Nous devons trouver [CS:N]Soporifik[CR]\npour comprendre pourquoi [CS:N]Azurill[CR] ne se\nréveille pas.", german="Wir brauchen [CS:N]Traumato[CR], damit\ner uns hilft herauszufinden, warum [CS:N]Azurill[CR]\nnicht aufwacht.", italian="Abbiamo bisogno di [CS:N]Drowzee[CR] per\ncapire perché [CS:N]Azurill[CR] non si sveglia.", spanish="Necesitamos que [CS:N]Drowzee[CR] nos\nayude a descubrir por qué [CS:N]Azurill[CR] no logra\ndespertarse."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's not waste any time finding\n[CS:N]Drowzee[CR]!", french="Ne perdons pas de temps.\nTrouvons vite [CS:N]Soporifik[CR]!", german="Finden wir [CS:N]Traumato[CR] so schnell\nwie möglich!", italian="Sbrighiamoci a trovare\n[CS:N]Drowzee[CR]!", spanish="¡No perdamos el tiempo!\n¡Hay que dar con [CS:N]Drowzee[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to hurry finding\n[CS:N]Drowzee[CR]!", french="Ne perdons pas de temps.\nTrouvons vite [CS:N]Soporifik[CR]!", german="Wir müssen [CS:N]Traumato[CR]\nschnellstmöglich finden!", italian="Sbrighiamoci a trovare\n[CS:N]Drowzee[CR]!", spanish="¡No perdamos el tiempo!\n¡Hay que dar con [CS:N]Drowzee[CR]!"})
  else
  SkySceneKit.say({english="There's no time to spare finding\n[CS:N]Drowzee[CR]!", french="Ne perdons pas de temps.\nTrouvons vite [CS:N]Soporifik[CR]!", german="Wir haben keine Zeit zu\nverlieren bei der Suche nach [CS:N]Traumato[CR]!", italian="Sbrighiamoci a trovare\n[CS:N]Drowzee[CR]!", spanish="¡No perdamos el tiempo!\n¡Hay que dar con [CS:N]Drowzee[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to try our best,\n[hero]!", french="Faisons de notre mieux,\n[hero]!", german="Wir müssen unser Bestes\nversuchen, [hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Tenemos que esforzarnos,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We've got to be at our best,\n[hero]!", french="Faisons de notre mieux,\n[hero]!", german="Wir müssen alles geben,\n[hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Hagámoslo lo mejor posible,\n[hero]!"})
  else
  SkySceneKit.say({english="Let's do our very best,\n[hero]!", french="Faisons de notre mieux,\n[hero]!", german="Geben wir alles,\n[hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Hagámoslo lo mejor posible,\n[hero]!"})
  end
  -- message_Close
  GROUND:MoveToPosition(hero, 204, 84, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(partner, 204, 84, false, 2)
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  -- main_EnterDungeon(62, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
end
