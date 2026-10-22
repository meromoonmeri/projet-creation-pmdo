-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D19P11A/m18d0112.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D19P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Your Dimensional Scream!", french=" Ton Cri Dimensionnel!", german=" Dein Dimensionaler Schrei!", italian=" Il tuo Squarcio Dimensionale!", spanish=" ¡Tu Percepción de Cronos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Your Dimensional Scream!", french=" Ton Cri Dimensionnel!", german=" Dein Dimensionaler Schrei!", italian=" Il tuo Squarcio Dimensionale!", spanish=" ¡Tu Percepción de Cronos!"})
  else
  SkySceneKit.say({english=" Your Dimensional Scream!", french=" Ton Cri Dimensionnel!", german=" Dein Dimensionaler Schrei!", italian=" Il tuo Squarcio Dimensionale!", spanish=" ¡Tu Percepción de Cronos!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Use your Dimensional Scream,\n[hero]!", french="Sers-toi de ton Cri\nDimensionnel, [hero]!", german="Setze deinen Dimensionalen\nSchrei ein, [hero]!", italian="Usa il tuo Squarcio Dimensionale,\n[hero]!", spanish="¡Utiliza la Percepción de Cronos,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Use your Dimensional Scream,\n[hero]!", french="Sers-toi de ton Cri\nDimensionnel, [hero]!", german="Setze deinen Dimensionalen\nSchrei ein, [hero]!", italian="Usa il tuo Squarcio Dimensionale,\n[hero]!", spanish="¡Utiliza la Percepción de Cronos,\n[hero]!"})
  else
  SkySceneKit.say({english="Use your Dimensional Scream,\n[hero]!", french="Sers-toi de ton Cri\nDimensionnel, [hero]!", german="Setze deinen Dimensionalen\nSchrei ein, [hero]!", italian="Usa il tuo Squarcio Dimensionale,\n[hero]!", spanish="¡Utiliza la Percepción de Cronos,\n[hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Touch this frozen water!", french=" Touche l'eau!", german="Berühre dieses erstarrte\nWasser!", italian=" Tocca quest'acqua immobile!", spanish=" Toca el agua paralizada."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Touch this frozen water!", french=" Touche l'eau!", german="Berühre dieses erstarrte\nWasser!", italian=" Tocca quest'acqua immobile!", spanish=" Toca el agua paralizada."})
  else
  SkySceneKit.say({english=" Touch this frozen water!", french=" Touche l'eau!", german="Berühre dieses erstarrte\nWasser!", italian=" Tocca quest'acqua immobile!", spanish=" Toca el agua paralizada."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Who knows? You may see\nsomething!", french="Qui sait? Tu auras peut-être\nune vision!", german="Wer weiß? Vielleicht siehst du\nja etwas!", italian="Chi lo sa? Potresti vedere\nqualcosa!", spanish="¿Quién sabe? ¡Puede que\nveas algo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Who knows? You may see\nsomething!", french="Qui sait? Tu auras peut-être\nune vision!", german="Wer weiß? Vielleicht siehst du\nja etwas!", italian="Chi lo sa? Potresti vedere\nqualcosa!", spanish="¿Quién sabe? ¡Puede que\nveas algo!"})
  else
  SkySceneKit.say({english="Who knows? You may see\nsomething!", french="Qui sait? Tu auras peut-être\nune vision!", german="Wer weiß? Vielleicht siehst du\nja etwas!", italian="Chi lo sa? Potresti vedere\nqualcosa!", spanish="¿Quién sabe? ¡Puede que\nveas algo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Oh, I understand...)", french="(Oh, je vois...)", german="(Oh, ich verstehe.)", italian="(Ah, ho capito...)", spanish="(Ah, entiendo...)"})
  else
  SkySceneKit.say({english="(Oh, I understand...)", french="(Oh, je vois...)", german="(Oh, ich verstehe.)", italian="(Ah, ho capito...)", spanish="(Ah, entiendo...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That's true...[K] It's worth a try...)", french="(C'est vrai...[K] Ça vaut le coup d'essayer...)", german="(Das stimmt.[K] Einen Versuch ist es wert.)", italian="(È vero...[K] Vale la pena di fare un tentativo.)", spanish="(Es cierto...[K] Vale la pena intentarlo.)"})
  else
  SkySceneKit.say({english="(That's true...[K] It's worth a try...)", french="(C'est vrai...[K] Ça vaut le coup d'essayer...)", german="(Das stimmt.[K] Einen Versuch ist es wert.)", italian="(È vero...[K] Vale la pena di fare un tentativo.)", spanish="(Es cierto...[K] Vale la pena intentarlo.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Touching that frozen water...)", french="(Si je touche l'eau...)", german="(Wenn ich das erstarrte Wasser berühre...)", italian="(Potrei toccare quell'acqua immobile...)", spanish="(A lo mejor si toco el agua...)"})
  else
  SkySceneKit.say({english="(Touching that frozen water...)", french="(Si je touche l'eau...)", german="(Wenn ich das erstarrte Wasser berühre...)", italian="(Potrei toccare quell'acqua immobile...)", spanish="(A lo mejor si toco el agua...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It might give us clues about what's happening\nto us.)", french="(... j'en saurai peut-être plus sur ce qui\nnous arrive.)", german="(Dann erfahren wir vielleicht etwas darüber,\nwas hier geschieht.)", italian="(In questo modo potremmo trovare qualche\nindizio su quello che sta succedendo.)", spanish="(Conseguiré alguna pista sobre lo que está\npasando.)"})
  else
  SkySceneKit.say({english="(It might give us clues about what's happening\nto us.)", french="(... j'en saurai peut-être plus sur ce qui\nnous arrive.)", german="(Dann erfahren wir vielleicht etwas darüber,\nwas hier geschieht.)", italian="(In questo modo potremmo trovare qualche\nindizio su quello che sta succedendo.)", spanish="(Conseguiré alguna pista sobre lo que está\npasando.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We shouldn't waste any time.\nThose [CS:N]Sableye[CR] will catch up to us.", french="Ne perdons pas de temps.\nLes [CS:N]Ténéfix[CR] vont nous rattraper.", german="Wir sollten keine Zeit verlieren.\nDie [CS:N]Zobiris[CR] holen uns sonst ein.", italian="Non perdiamo tempo. Quei\n[CS:N]Sableye[CR] ci sono alle costole.", spanish="No perdamos más tiempo, o esos\n[CS:N]Sableye[CR] nos alcanzarán."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We can't dawdle. Those [CS:N]Sableye[CR]\nwill catch up to us.", french="Ne perdons pas de temps.\nLes [CS:N]Ténéfix[CR] vont nous rattraper.", german="Wir dürfen nicht trödeln. Diese\n[CS:N]Zobiris[CR] holen uns sonst ein.", italian="Non perdiamo tempo. Quei\n[CS:N]Sableye[CR] ci sono alle costole.", spanish="No perdamos más tiempo, o esos\n[CS:N]Sableye[CR] nos alcanzarán."})
  else
  SkySceneKit.say({english="We shouldn't waste any time.\nThose [CS:N]Sableye[CR] will catch up to us.", french="Ne perdons pas de temps.\nLes [CS:N]Ténéfix[CR] vont nous rattraper.", german="Wir sollten keine Zeit verlieren.\nDie [CS:N]Zobiris[CR] holen uns sonst ein.", italian="Non perdiamo tempo. Quei\n[CS:N]Sableye[CR] ci sono alle costole.", spanish="No perdamos más tiempo, o esos\n[CS:N]Sableye[CR] nos alcanzarán."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's do this quickly!", french=" Vas-y vite!", german=" Mach schnell!", italian=" Facciamo presto!", spanish=" ¡Hagámoslo cuanto antes!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's do this quickly!", french=" Vas-y vite!", german=" Mach schnell!", italian=" Facciamo presto!", spanish=" ¡Hagámoslo cuanto antes!"})
  else
  SkySceneKit.say({english=" Let's do this quickly!", french=" Vas-y vite!", german=" Mach schnell!", italian=" Facciamo presto!", spanish=" ¡Hagámoslo cuanto antes!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(24), p.Y+(24), false, 2) end
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 316, 172, false, 2)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][hero] touched the\n[CN]frozen spray of water.", french="[CN][hero] touche la gerbe\n[CN]d'eau figée.", german="[CN][hero] berührt den\n[CN]erstarrten Wasserstrahl.", italian="[CN][hero] tocca uno\n[CN]zampillo d'acqua immobile.", spanish="[CN][hero] tocó el agua."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(45)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[K]How's it going, [hero]?", french="...[K] Alors, qu'est-ce que ça donne,\n[hero]?", german=" ...[K]Alles klar, [hero]?", italian=" ...[K] Come va, [hero]?", spanish="Esto...[K] Dime,\n¿cómo va, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[K]Well, [hero]?", french="...[K] Alors, qu'est-ce que ça donne,\n[hero]?", german=" ...[K]Und, [hero]?", italian=" ...[K] Allora, [hero]?", spanish="Esto...[K] Y bien,\n¿cómo va, [hero]?"})
  else
  SkySceneKit.say({english=" ...[K]How's it going, [hero]?", french="...[K] Alors, qu'est-ce que ça donne,\n[hero]?", german=" ...[K]Alles klar, [hero]?", italian=" ...[K] Come va, [hero]?", spanish="Esto...[K] Dime,\n¿cómo va, [hero]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Can you see anything?", french=" Tu vois quelque chose?", german=" Kannst du etwas sehen?", italian=" Vedi qualcosa?", spanish=" ¿Ves algo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Can you see anything?", french=" Tu vois quelque chose?", german=" Kannst du etwas sehen?", italian=" Vedi qualcosa?", spanish=" ¿Ves algo?"})
  else
  SkySceneKit.say({english=" Can you see anything?", french=" Tu vois quelque chose?", german=" Kannst du etwas sehen?", italian=" Vedi qualcosa?", spanish=" ¿Ves algo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  else
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(..............................)", french="(..............................)", german="(..............................)", italian="(..............................)", spanish="(... ...)"})
  else
  SkySceneKit.say({english="(..............................)", french="(..............................)", german="(..............................)", italian="(..............................)", spanish="(... ...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(..........................................)", french="(..........................................)", german="(..........................................)", italian="(..........................................)", spanish="(... ... ...)"})
  else
  SkySceneKit.say({english="(..........................................)", french="(..........................................)", german="(..........................................)", italian="(..........................................)", spanish="(... ... ...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...No.[K] I'm not sensing anything.)", french="(... Non.[K] Je ne vois rien.)", german="(...Nein.[K] Ich sehe nichts.)", italian="(No.[K] Non avverto niente.)", spanish="(No.[K] No siento nada.)"})
  else
  SkySceneKit.say({english="(...No.[K] I'm not sensing anything.)", french="(... Non.[K] Je ne vois rien.)", german="(...Nein.[K] Ich sehe nichts.)", italian="(No.[K] Non avverto niente.)", spanish="(No.[K] No siento nada.)"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
end
