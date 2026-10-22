-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m05a0811.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It... It's true...)", french="(C'est... c'est vrai...)", german="(Es... Es stimmt.)", italian="(È... È vero...)", spanish="(Es... es verdad.)"})
  else
  SkySceneKit.say({english="(It... It's true...)", french="(C'est... c'est vrai...)", german="(Es... Es stimmt.)", italian="(È... È vero...)", spanish="(Es... es verdad.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It was always after touching something!\nThat's when I got those dizzy spells!)", french="(C'est toujours après avoir touché\nquelque chose que j'ai des vertiges!)", german="(Es passiert immer, nachdem ich etwas\nberührt habe! Dann bekomme ich diese\nSchwindelanfälle!)", italian="(Stavo sempre toccando qualcosa quando si\nsono verificati i capogiri!)", spanish="(¡Siempre sentí esos mareos al tocar algo!)"})
  else
  SkySceneKit.say({english="(It was always after touching something!\nThat's when I got those dizzy spells!)", french="(C'est toujours après avoir touché\nquelque chose que j'ai des vertiges!)", german="(Es passiert immer, nachdem ich etwas\nberührt habe! Dann bekomme ich diese\nSchwindelanfälle!)", italian="(Stavo sempre toccando qualcosa quando si\nsono verificati i capogiri!)", spanish="(¡Siempre me han dado los mareos después\nde tocar algo!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(When I touch something, I see something\nconnected to it...[K] Right?)", french="(En touchant un objet, je vois quelque\nchose qui s'y rapporte...[K] C'est bien ça?)", german="(Wenn ich etwas berühre, sehe ich etwas, das\ndamit in Verbindung steht...[K] Oder?)", italian="(Quando tocco qualcosa, ho una visione\ncollegata ad essa...[K] Giusto?)", spanish="(Cuando toco una cosa, tengo una visión\nrelacionada con ella...[K] ¿Verdad?)"})
  else
  SkySceneKit.say({english="(When I touch something, I see something\nconnected to it...[K] Right?)", french="(En touchant un objet, je vois quelque\nchose qui s'y rapporte...[K] C'est bien ça?)", german="(Wenn ich etwas berühre, sehe ich etwas, das\ndamit in Verbindung steht...[K] Oder?)", italian="(Quando tocco qualcosa, ho una visione\ncollegata ad essa...[K] Giusto?)", spanish="(Cuando toco una cosa, tengo una visión\nrelacionada con ella...[K] ¿Verdad?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" There's another thing.", french=" Il y a autre chose.", german=" Da ist noch etwas.", italian=" C'è un'altra cosa.", spanish=" Una cosa más..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" There's one more thing.", french=" Il y a autre chose.", german=" Da ist noch eine Sache.", italian=" C'è un'altra cosa.", spanish=" Una cosa más..."})
  else
  SkySceneKit.say({english=" There's another thing.", french=" Il y a autre chose.", german=" Da ist noch etwas.", italian=" C'è un'altra cosa.", spanish=" Una cosa más..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The time we rescued [CS:N]Azurill[CR], you\nsaw something in the future...", french="Quand nous avons sauvé [CS:N]Azurill[CR],\ntu as eu une vision du futur...", german="Als wir [CS:N]Azurill[CR] gerettet haben,\nhattest du etwas aus der Zukunft gesehen.", italian="Quando abbiamo salvato [CS:N]Azurill[CR],\nhai visto qualcosa nel futuro...", spanish="Cuando tuviste la visión de\n[CS:N]Azurill[CR], viste algo que ocurrió después..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="When we rescued [CS:N]Azurill[CR], you\nhad a vision of the future...", french="Quand nous avons sauvé [CS:N]Azurill[CR],\ntu as eu une vision du futur...", german="Als wir [CS:N]Azurill[CR] gerettet haben,\nhattest du eine Vision aus der Zukunft.", italian="Quando abbiamo salvato [CS:N]Azurill[CR],\nhai visto qualcosa nel futuro...", spanish="Cuando tuviste la visión de\n[CS:N]Azurill[CR], viste algo que ocurrió después..."})
  else
  SkySceneKit.say({english="When we rescued [CS:N]Azurill[CR], you\nhad a vision of the future...", french="Quand nous avons sauvé [CS:N]Azurill[CR],\ntu as eu une vision du futur...", german="Als wir [CS:N]Azurill[CR] gerettet haben,\nhattest du eine Vision aus der Zukunft.", italian="Quando abbiamo salvato [CS:N]Azurill[CR],\nhai visto qualcosa nel futuro...", spanish="Cuando tuviste la visión de\n[CS:N]Azurill[CR], viste algo que ocurrió después..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But this time, you saw\n[CS:N]Wigglytuff[CR] going into the cave, right?", french="Mais cette fois, tu as vu\n[CS:N]Grodoudou[CR] aller dans la grotte, non?", german="Aber diesmal hast du [CS:N]Knuddeluff[CR]\nin die Höhle gehen sehen, richtig?", italian="Ma questa volta, hai visto\n[CS:N]Wigglytuff[CR] che entrava nella caverna, vero?", spanish="Pero en la cascada viste que\n[CS:N]Wigglytuff[CR] había entrado en la cueva, ¿no?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But this time, you saw\n[CS:N]Wigglytuff[CR] going into the cave, right?", french="Mais cette fois, tu as vu\n[CS:N]Grodoudou[CR] aller dans la grotte, non?", german="Aber diesmal hast du [CS:N]Knuddeluff[CR]\nin die Höhle gehen sehen, richtig?", italian="Ma questa volta, hai visto\n[CS:N]Wigglytuff[CR] che entrava nella caverna, vero?", spanish="Pero en la cascada viste que\n[CS:N]Wigglytuff[CR] había entrado en la cueva, ¿no?"})
  else
  SkySceneKit.say({english="But this time, you saw\n[CS:N]Wigglytuff[CR] going into the cave, right?", french="Mais cette fois, tu as vu\n[CS:N]Grodoudou[CR] aller dans la grotte, non?", german="Aber diesmal hast du [CS:N]Knuddeluff[CR]\nin die Höhle gehen sehen, richtig?", italian="Ma questa volta, hai visto\n[CS:N]Wigglytuff[CR] che entrava nella caverna, vero?", spanish="Pero en la cascada viste que\n[CS:N]Wigglytuff[CR] había entrado en la cueva, ¿no?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So that means...", french=" Cela signifie...", german=" Das heißt also...", italian=" Il che significa...", spanish=" Y eso quiere decir que..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So that means...", french=" Cela signifie...", german=" Das heißt also...", italian=" Il che significa...", spanish=" Y eso quiere decir que..."})
  else
  SkySceneKit.say({english=" So that means...", french=" Cela signifie...", german=" Das heißt also...", italian=" Il che significa...", spanish=" Y eso quiere decir que..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This time, you saw something\nthat happened in the past.", french="... que cette fois, tu as vu\nun événement qui appartient au passé.", german="Diesmal hast du etwas aus der\nVergangenheit gesehen.", italian="... che questa volta hai visto\nqualcosa che è avvenuto nel passato.", spanish="Esta vez viste algo que ya había\nocurrido."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This time, you saw an event\nthat occurred in the past.", french="... que cette fois, tu as vu\nun événement qui appartient au passé.", german="Diesmal hast du etwas gesehen,\ndas in der Vergangenheit passiert ist.", italian="... che questa volta hai visto\nqualcosa che è avvenuto nel passato.", spanish="Esta vez viste algo que ya había\nocurrido."})
  else
  SkySceneKit.say({english="This time, you saw something\nthat took place in the past.", french="... que cette fois, tu as vu\nun événement qui appartient au passé.", german="Diesmal hast du etwas gesehen,\ndas in der Vergangenheit passiert ist.", italian="... che questa volta hai visto\nqualcosa che è avvenuto nel passato.", spanish="Esta vez viste algo que ya había\nocurrido."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Th-that's true!)", french="(En effet!)", german="(D-das stimmt!)", italian="(È v-vero!)", spanish="(¡Es cierto!)"})
  else
  SkySceneKit.say({english="(Th-that's true!)", french="(En effet!)", german="(D-das stimmt!)", italian="(È v-vero!)", spanish="(¡Es cierto!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" In other words, [hero]...", french=" Autrement dit, [hero]...", german=" Anders gesagt, [hero]...", italian=" In altre parole, [hero]...", spanish="En otras palabras,\n[hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" In other words, [hero]...", french=" Autrement dit, [hero]...", german=" Anders gesagt, [hero]...", italian=" In altre parole, [hero]...", spanish="En otras palabras,\n[hero]..."})
  else
  SkySceneKit.say({english=" In other words, [hero]...", french=" Autrement dit, [hero]...", german=" Anders gesagt, [hero]...", italian=" In altre parole, [hero]...", spanish="En otras palabras,\n[hero]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If you touch something, you see\nits past or future.", french="Si tu touches quelque chose,\ntu vois son passé ou son futur.", german="Wenn du eine Person oder einen\nGegenstand, der ihr gehört, berührst, siehst\ndu etwas aus der Vergangenheit oder Zukunft.", italian="Se tocchi qualcosa, ne vedi il\npassato o il futuro.", spanish="Si tocas algo, puedes ver tanto\nel pasado como el futuro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If you touch something, you see\nits past or future.", french="Si tu touches quelque chose,\ntu vois son passé ou son futur.", german="Wenn du eine Person oder einen\nGegenstand, der ihr gehört, berührst, siehst\ndu etwas aus der Vergangenheit oder Zukunft.", italian="Se tocchi qualcosa, ne vedi il\npassato o il futuro.", spanish="Si tocas algo, puedes ver tanto\nel pasado como el futuro."})
  else
  SkySceneKit.say({english="If you touch something, you see\nits past or future.", french="Si tu touches quelque chose,\ntu vois son passé ou son futur.", german="Wenn du eine Person oder einen\nGegenstand, der ihr gehört, berührst, siehst\ndu etwas aus der Vergangenheit oder Zukunft.", italian="Se tocchi qualcosa, ne vedi il\npassato o il futuro.", spanish="Si tocas algo, puedes ver tanto\nel pasado como el futuro."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You must have that kind of\nspecial ability!", french="Tu dois posséder une sorte\nde don!", german="Du musst eine besondere\nFähigkeit haben!", italian=" Hai un'abilità tutta particolare!", spanish=" ¡Debes de tener esa capacidad!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You must have that kind of\nspecial ability!", french="Tu dois posséder une sorte\nde don!", german="Du musst eine besondere\nFähigkeit haben!", italian=" Hai un'abilità tutta particolare!", spanish=" ¡Debes de tener esa capacidad!"})
  else
  SkySceneKit.say({english="You must have that kind of\nspecial ability!", french="Tu dois posséder une sorte\nde don!", german="Du musst eine besondere\nFähigkeit haben!", italian=" Hai un'abilità tutta particolare!", spanish=" ¡Debes de tener esa capacidad!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This could be something totally\nawesome!", french="Il pourrait nous rendre de\ngrands services!", german="Das könnte wirklich etwas\nTolles sein!", italian="Potrebbe rivelarsi una cosa\neccezionale!", spanish=" ¡Sería tremendo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This could be something totally\nincredible!", french="Il pourrait nous rendre de\ngrands services!", german="Das könnte wirklich etwas\nganz Außergewöhnliches sein!", italian="Credo che potrebbe essere\nuna cosa importante.", spanish=" ¡Sería increíble!"})
  else
  SkySceneKit.say({english="This could be something totally\namazing!", french="Il pourrait nous rendre de\ngrands services!", german="Das könnte wirklich etwas\nganz Wunderbares sein!", italian="Potrebbe essere una cosa\neccezionale!", spanish=" ¡Sería asombroso!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You could use it in lots of ways!", french="Tu peux l'utiliser de plein\nde façons!", german="Du könntest sie für Vieles\nverwenden!", italian="Potresti usarla in un sacco di\nmodi!", spanish="¡Puede ser una habilidad\nextremadamente útil!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You could use it in lots of ways!", french="Tu peux l'utiliser de plein\nde façons!", german="Du könntest sie für Vieles\nverwenden!", italian="Potresti usarla in un sacco di\nmodi!", spanish="¡Puede ser una habilidad\nextremadamente útil!"})
  else
  SkySceneKit.say({english=" You could use it in lots of ways!", french="Tu peux l'utiliser de plein\nde façons!", german="Du könntest sie für Vieles\nverwenden!", italian="Potresti usarla in un sacco di\nmodi!", spanish="¡Puede ser una habilidad\nextremadamente útil!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Not just for exploring, either!\nThe ability could be useful for many things!", french="Pas seulement pour les\nexplorations! Ce don peut être pratique\npour tellement de choses!", german="Nicht nur für Erkundungen!\nDiese Fähigkeit könnte für alles Mögliche\nnützlich sein!", italian="E non solo per esplorare!\nQuest'abilità potrebbe tornare utile per molte\ncose!", spanish="¡Y no solo para explorar!\n¡Seguro que sirve para muchas cosas más!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Not just for exploring, either!\nThe ability could be useful for many things!", french="Pas seulement pour les\nexplorations! Ce don peut être pratique\npour tellement de choses!", german="Nicht nur für Erkundungen!\nDiese Fähigkeit könnte für alles Mögliche\nnützlich sein!", italian="E non solo per esplorare!\nQuest'abilità potrebbe tornare utile in molte\nsituazioni.", spanish="¡Y no solo para explorar!\n¡Seguro que sirve para muchas cosas más!"})
  else
  SkySceneKit.say({english="Not just for exploring, either!\nThe ability could be useful for many things!", french="Pas seulement pour les\nexplorations! Ce don peut être pratique\npour tellement de choses!", german="Nicht nur für Erkundungen!\nDiese Fähigkeit könnte für alles Mögliche\nnützlich sein!", italian="E non solo per esplorare!\nQuest'abilità potrebbe risultare utile in\ndiverse situazioni.", spanish="¡Y no solo para explorar!\n¡Seguro que sirve para muchas cosas más!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" This is awesome, [hero]!", french=" C'est super, [hero]!", german=" Das ist super, [hero]!", italian=" È fantastico, [hero]!", spanish=" ¡Esto es la caña, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's fantastic, [hero]!", french=" C'est super, [hero]!", german=" Es ist fantastisch, [hero]!", italian=" È fantastico, [hero]!", spanish=" ¡Es fantástico, [hero]!"})
  else
  SkySceneKit.say({english=" It's amazing, [hero]!", french=" C'est super, [hero]!", german="Das ist verblüffend,\n[hero]!", italian=" È fantastico, [hero]!", spanish=" ¡Es increíble, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(W-well, yes! I guess that's true...)", french="(Eh bien oui, je suppose...)", german="(N-na ja! D-das stimmt wohl.)", italian="(B-Beh, sì! Immagino sia così...)", spanish="(¡Vaya! Supongo que es verdad.)"})
  else
  SkySceneKit.say({english="(W-well, yes! I guess that's true...)", french="(Eh bien oui, je suppose...)", german="(N-na ja! D-das stimmt wohl.)", italian="(B-Beh, sì! Immagino sia così...)", spanish="(¡Vaya! Supongo que es verdad.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But that doesn't mean I always get a vision\nevery time I touch something...)", french="(Pour autant, je n'ai pas toujours une vision\nà chaque fois que je touche quelque chose...)", german="(Aber das heißt nicht, dass ich jedes Mal eine\nVision bekomme, wenn ich etwas berühre.)", italian="(Ma non significa che io abbia una visione\nogni volta che tocco qualcosa...)", spanish="(Pero eso tampoco quiere decir que tenga\nuna visión cada vez que toco algo.)"})
  else
  SkySceneKit.say({english="(But that doesn't mean I always get a vision\nevery time I touch something...)", french="(Pour autant, je n'ai pas toujours une vision\nà chaque fois que je touche quelque chose...)", german="(Aber das heißt nicht, dass ich jedes Mal eine\nVision bekomme, wenn ich etwas berühre.)", italian="(Ma non significa che io abbia una visione\nogni volta che tocco qualcosa...)", spanish="(Pero eso tampoco quiere decir que tenga\nuna visión cada vez que toco algo.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It would be useful if I could have visions\nwhen I wanted, but...)", french="(Ce serait pratique d'avoir des visions à\nvolonté, mais...)", german="(Es wäre nützlich, wenn ich Visionen haben\nkönnte, wann immer ich will, aber...)", italian="(Sarebbe utile se potessi avere visioni a\ncomando, ma...)", spanish="(Sería muy útil tener una visión siempre\nque quisiera, pero...)"})
  else
  SkySceneKit.say({english="(It would be useful if I could have visions\nwhen I wanted, but...)", french="(Ce serait pratique d'avoir des visions à\nvolonté, mais...)", german="(Es wäre nützlich, wenn ich Visionen haben\nkönnte, wann immer ich will, aber...)", italian="(Sarebbe utile se potessi avere visioni a\ncomando, ma...)", spanish="(Sería muy útil tener una visión siempre\nque quisiera, pero...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 8, 184, Direction.Down, "NPC_PERAPPU")
  GROUND:MoveToPosition(npc_npc_perappu, 120, 180, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Hey, you two!", french=" Hé, vous deux!", german=" Hey, ihr zwei!", italian=" Ehi, voi due!", spanish=" ¡Atención! Necesito que vengáis."})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(5)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The Guildmaster wants to see\nyou right away.", french="Le Maître de la Guilde voudrait\nvous voir immédiatement.", german="Der Gildenmeister will euch\nsofort sehen.", italian="Il Capitano vi vuole\nvedere immediatamente.", spanish="El Gran Bluff quiere veros\nahora mismo."})
  -- message_Close
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
