-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D03P11A/m03a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- back_SetGround(LEVEL_D03P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Mt. Bristle.ogg", true) end)
  local npc_npc_mariru = SkySceneKit.spawn_npc("marill", 280, 312, Direction.Down, "NPC_MARIRU")
  GROUND:MoveToPosition(npc_npc_mariru, 276, 164, false, 2)
  GROUND:MoveToPosition(hero, 296, 188, false, 2)
  GROUND:MoveToPosition(partner, 256, 188, false, 2)
  GROUND:EntTurn(npc_npc_mariru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You're sure [CS:N]Drowzee[CR] and [CS:N]Azurill[CR]\nwent off in this direction?", french="Tu es sûr que [CS:N]Soporifik[CR] et\n[CS:N]Azurill[CR] sont partis dans cette direction?", german="Bist du dir sicher, dass\n[CS:N]Traumato[CR] und [CS:N]Azurill[CR] in diese Richtung\nverschwunden sind?", italian="Sei sicuro che [CS:N]Drowzee[CR] e [CS:N]Azurill[CR]\nsiano andati da questa parte?", spanish="¿Seguro que [CS:N]Drowzee[CR] y [CS:N]Azurill[CR]\nse fueron por aquí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You think [CS:N]Drowzee[CR] and [CS:N]Azurill[CR]\nwent in this direction?", french="Tu es sûr que [CS:N]Soporifik[CR] et\n[CS:N]Azurill[CR] sont partis dans cette direction?", german="Du glaubst, [CS:N]Traumato[CR] und [CS:N]Azurill[CR]\nsind in diese Richtung gegangen?", italian="Sei sicuro che [CS:N]Drowzee[CR] e [CS:N]Azurill[CR]\nsiano andati da questa parte?", spanish="¿Seguro que [CS:N]Drowzee[CR] y [CS:N]Azurill[CR]\nse fueron por aquí?"})
  else
  SkySceneKit.say({english="So you think that [CS:N]Drowzee[CR] and\n[CS:N]Azurill[CR] went off in this direction?", french="Tu es sûr que [CS:N]Soporifik[CR] et\n[CS:N]Azurill[CR] sont partis dans cette direction?", german="Du glaubst also, [CS:N]Traumato[CR] und\n[CS:N]Azurill[CR] sind in diese Richtung gegangen?", italian="Sei sicuro che [CS:N]Drowzee[CR] e [CS:N]Azurill[CR]\nsiano andati da questa parte?", spanish="¿Así que crees que [CS:N]Drowzee[CR] y\n[CS:N]Azurill[CR] se fueron por aquí?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Yes...", french=" Oui...", german=" Ja...", italian=" Sì...", spanish=" Sí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Oh, [hero]! The [CS:N]Drowzee[CR]\nand [CS:N]Azurill[CR] you saw in your dream...", french="Oh, [hero]! Quand tu as\nvu [CS:N]Soporifik[CR] et [CS:N]Azurill[CR] dans ton rêve...", german="Oh, [hero]! Als du\n[CS:N]Traumato[CR] und [CS:N]Azurill[CR] in deinem Traum gesehen\nhast...", italian="Oh, [hero]! Quando hai\nvisto [CS:N]Drowzee[CR] e [CS:N]Azurill[CR] nel tuo sogno...", spanish="¡[hero]! Cuando\nviste a [CS:N]Drowzee[CR] y a [CS:N]Azurill[CR] en tu sueño..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh, [hero]! The [CS:N]Drowzee[CR]\nand [CS:N]Azurill[CR] you saw in your dream...", french="Oh, [hero]! Quand tu as\nvu [CS:N]Soporifik[CR] et [CS:N]Azurill[CR] dans ton rêve...", german="Oh, [hero]! Als du\n[CS:N]Traumato[CR] und [CS:N]Azurill[CR] in deinem Traum gesehen\nhast...", italian="Oh, [hero]! Quando hai\nvisto [CS:N]Drowzee[CR] e [CS:N]Azurill[CR] nel tuo sogno...", spanish="¡[hero]! Cuando\nviste a [CS:N]Drowzee[CR] y a [CS:N]Azurill[CR] en tu sueño..."})
  else
  SkySceneKit.say({english="Oh, [hero]! The [CS:N]Drowzee[CR]\nand [CS:N]Azurill[CR] you saw in your dream...", french="Oh, [hero]! Quand tu as\nvu [CS:N]Soporifik[CR] et [CS:N]Azurill[CR] dans ton rêve...", german="Oh, [hero]! Als du\n[CS:N]Traumato[CR] und [CS:N]Azurill[CR] in deinem Traum gesehen\nhast...", italian="Oh, [hero]! Quando hai\nvisto [CS:N]Drowzee[CR] e [CS:N]Azurill[CR] nel tuo sogno...", spanish="¡[hero]! Cuando\nviste a [CS:N]Drowzee[CR] y a [CS:N]Azurill[CR] en tu sueño..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You said you saw them in a\nmountainous place, right?", french="... tu as bien dit qu'ils étaient\ndans un endroit montagneux?", german="Du meintest, sie waren in einer\nfelsigen Gegend, oder?", italian="Hai detto di averli visti in un\nluogo montuoso, giusto?", spanish="Estaban en un lugar montañoso,\n¿no?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You were saying you saw them\nin a mountainous place, right?", french="... tu as bien dit qu'ils étaient\ndans un endroit montagneux?", german="Du meintest, sie waren in einer\nfelsigen Gegend, oder?", italian="Hai detto di averli visti in un\nluogo montuoso, giusto?", spanish="Estaban en un lugar montañoso,\n¿verdad?"})
  else
  SkySceneKit.say({english="You said you saw them in a\nmountainous place, didn't you?", french="... tu as bien dit qu'ils étaient\ndans un endroit montagneux?", german="Du meintest, sie waren in einer\nfelsigen Gegend, oder?", italian="Hai detto di averli visti in un\nluogo montuoso, giusto?", spanish="Me dijiste que estaban\nen un lugar montañoso, ¿verdad?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I think the two of them are up\nahead here.", french="Je pense qu'ils sont entrés\nlà-dedans.", german="Ich glaube, sie sind in diese\nRichtung gegangen.", italian=" Penso che siano da quella parte.", spanish="Creo que los dos están\nallí arriba."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I get the feeling that they're\nup ahead here.", french="Je pense qu'ils sont entrés\nlà-dedans.", german="Ich habe das Gefühl, sie sind in\ndiese Richtung gegangen.", italian=" Penso che siano da quella parte.", spanish="Tengo la sensación de que\nlos dos están allí arriba."})
  else
  SkySceneKit.say({english=" I think they're up ahead here.", french="Je pense qu'ils sont entrés\nlà-dedans.", german="Ich glaube, sie sind in diese\nRichtung gegangen.", italian=" Penso che siano da quella parte.", spanish="Algo me dice que los dos\nestán allí arriba."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's roll, [hero]. Quick!", french=" Dépêchons-nous, [hero]!", german="Nichts wie los, [hero].\nSchnell!", italian=" Andiamo, [hero]. Presto!", spanish="¡A por ellos, [hero]!\n¡Rápido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's get going, [hero]!", french=" Dépêchons-nous, [hero]!", german=" Dann mal los, [hero]!", italian="Andiamo, [hero].\nSbrighiamoci!", spanish=" ¡En marcha, [hero]!"})
  else
  SkySceneKit.say({english=" Let's get going, [hero]!", french=" Dépêchons-nous, [hero]!", german=" Dann mal los, [hero]!", italian="Andiamo, [hero].\nFacciamo in fretta!", spanish=" ¡En marcha, [hero]!"})
  end
  -- message_Close
  GROUND:EntTurn(npc_npc_mariru, Direction.Up)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-32), false, 2) end
  GAME:WaitFrames(15)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-32), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(hero, 276, 76, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(partner, 276, 76, false, 2)
  GAME:WaitFrames(20)
  GAME:FadeOut(false, 30)
  SkyProg.set(4, 5) -- $SCENARIO_MAIN = scn[4,5] (ROM)
  -- main_EnterDungeon(4, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  SkySceneKit.cleanup_npcs()
end
