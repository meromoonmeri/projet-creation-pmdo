-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s03p2004.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The next morning...", french="[CN]Le lendemain matin...", german="[CN]Am nächsten Morgen...", italian="[CN]La mattina dopo...", spanish="[CN]Al día siguiente..."})
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:EntTurn(partner, Direction.Left)
  -- SetAnimation(76) [anim idle native]
  -- SetAnimation(76) [anim idle native]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(5)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Good morning, [hero]!", french=" Bonjour, [hero]!", german=" Guten Morgen, [hero]!", italian=" Buongiorno, [hero]!", spanish=" ¡Buenos días, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Good morning, [hero]!", french=" Bonjour, [hero]!", german=" Guten Morgen, [hero]!", italian=" Buongiorno, [hero]!", spanish=" ¡Buenos días, [hero]!"})
  else
  SkySceneKit.say({english=" Good morning, [hero]!", french=" Bonjour, [hero]!", german=" Guten Morgen, [hero]!", italian=" Buongiorno, [hero]!", spanish=" ¡Buenos días, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  else
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Manaphy[CR]...[K] The little guy's gone...", french="[CS:N]Manaphy[CR]...[K] il n'est plus là,\nle petit gars...", german="[CS:N]Manaphy[CR]...[K]\nDas kleine Kerlchen ist weg.", italian="[CS:N]Manaphy[CR]...[K] Il piccolo\nse ne è andato...", spanish=" [CS:N]Manaphy[CR]...[K] se ha ido..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Manaphy[CR]...[K] The little guy's gone...", french="[CS:N]Manaphy[CR]...[K] il n'est plus là,\nle petit gars...", german="[CS:N]Manaphy[CR]...[K]\nDas kleine Kerlchen ist weg.", italian="[CS:N]Manaphy[CR]...[K] Il piccolo\nse ne è andato...", spanish=" [CS:N]Manaphy[CR]...[K] se ha ido..."})
  else
  SkySceneKit.say({english="[CS:N]Manaphy[CR]...[K] The little\ncutie's gone...", french="[CS:N]Manaphy[CR]...[K] il n'est plus là,\nle petit gars...", german="[CS:N]Manaphy[CR]...[K]\nDas kleine Kerlchen ist weg.", italian="[CS:N]Manaphy[CR]...[K] Il piccolo\nse ne è andato...", spanish=" [CS:N]Manaphy[CR]...[K] se ha ido..."})
  end
  do local __choice = SkySceneKit.ask({{english=" It's sad...", french=" C'est triste...", german=" Es ist traurig...", italian=" È triste.", spanish=" Qué triste momento..."}, {english=" This is for the best...", french=" Ça valait mieux...", german=" Muss wohl so sein...", italian=" È la cosa migliore.", spanish=" Es por su bien."}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup...[K] You're right...", french=" C'est vrai...[K] tu as raison...", german=" Jep.[K] Du hast recht...", italian=" Sì...[K] Hai ragione...", spanish=" Sí...[K] Tienes razón..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes...[K] You're right...", french=" C'est vrai...[K] tu as raison...", german=" Ja.[K] Du hast recht...", italian=" Sì...[K] Hai ragione...", spanish=" Sí...[K] Tienes razón..."})
  else
  SkySceneKit.say({english=" Yes...[K] You're right...", french=" C'est vrai...[K] tu as raison...", german=" Ja.[K] Du hast recht...", italian=" Sì...[K] Hai ragione...", spanish=" Sí...[K] Tienes razón..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup...[K] But...", french=" Oui...[K] mais...", german=" Jep.[K] Aber...", italian=" Sì...[K] Ma...", spanish=" Sí...[K] Pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes...[K] But...", french=" Oui...[K] mais...", german=" Ja.[K] Aber...", italian=" Sì...[K] Ma...", spanish=" Sí...[K] Pero..."})
  else
  SkySceneKit.say({english=" Yes...[K] But...", french=" Oui...[K] mais...", german=" Ja.[K] Aber...", italian=" Sì...[K] Ma...", spanish=" Sí...[K] Pero..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- @label_2 [étiquette de flux ExplorerScript]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It was the right thing to do for\n[CS:N]Manaphy[CR].", french="C'était la meilleure chose à\nfaire pour [CS:N]Manaphy[CR].", german="Es war die richtige Entscheidung\nfür [CS:N]Manaphy[CR].", italian="È la cosa migliore per\n[CS:N]Manaphy[CR].", spanish="Hemos hecho lo mejor para\n[CS:N]Manaphy[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We did the only right thing for\n[CS:N]Manaphy[CR].", french="C'était la meilleure chose à\nfaire pour [CS:N]Manaphy[CR].", german="Wir haben das einzig Richtige\nfür [CS:N]Manaphy[CR] getan.", italian="È la cosa migliore per\n[CS:N]Manaphy[CR].", spanish="Hemos hecho lo mejor para\n[CS:N]Manaphy[CR]."})
  else
  SkySceneKit.say({english="It was the right thing to do for\n[CS:N]Manaphy[CR].", french="C'était la meilleure chose à\nfaire pour [CS:N]Manaphy[CR].", german="Es war die richtige Entscheidung\nfür [CS:N]Manaphy[CR].", italian="È la cosa migliore per\n[CS:N]Manaphy[CR].", spanish="Hemos hecho lo mejor para\n[CS:N]Manaphy[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'm sure [CS:N]Walrein[CR] will raise\nhim properly.", french="[CS:N]Kaimorse[CR] sera un bon tuteur\npour lui.", german="Ich bin sicher, bei [CS:N]Walraisa[CR]\nwird es gut aufwachsen.", italian="Sicuramente [CS:N]Walrein[CR] lo\ncrescerà nel modo migliore.", spanish="Seguro que [CS:N]Walrein[CR] sabrá\ncriarlo como es debido."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I think [CS:N]Walrein[CR] will raise\nhim properly.", french="[CS:N]Kaimorse[CR] sera un bon tuteur\npour lui.", german="Ich denke, dass [CS:N]Walraisa[CR] es gut\nerziehen wird.", italian="Sicuramente [CS:N]Walrein[CR] lo\ncrescerà nel modo migliore.", spanish="Seguro que [CS:N]Walrein[CR] sabrá\ncriarlo como es debido."})
  else
  SkySceneKit.say({english="I'm sure [CS:N]Walrein[CR] will raise\nhim properly.", french="[CS:N]Kaimorse[CR] sera un bon tuteur\npour lui.", german="Ich bin sicher, bei [CS:N]Walraisa[CR]\nwird es gut aufwachsen.", italian="Sicuramente [CS:N]Walrein[CR] lo\ncrescerà nel modo migliore.", spanish="Seguro que [CS:N]Walrein[CR] sabrá\ncriarlo como es debido."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" And maybe...", french=" Et peut-être...", german=" Und vielleicht...", italian=" E forse...", spanish=" Y tal vez..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" And maybe...", french=" Et peut-être...", german=" Und vielleicht...", italian=" E forse...", spanish=" Y tal vez..."})
  else
  SkySceneKit.say({english=" And maybe...", french=" Et peut-être...", german=" Und vielleicht...", italian=" E forse...", spanish=" Y tal vez..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Maybe, one day somewhere, we'll\nbe able to meet [CS:N]Manaphy[CR]...", french="Peut-être qu'un jour, nous\npourrons revoir [CS:N]Manaphy[CR]...", german="Vielleicht treffen wir [CS:N]Manaphy[CR]\neines Tages wieder.", italian="Forse un giorno, da qualche\nparte, incontreremo di nuovo [CS:N]Manaphy[CR]...", spanish="Tal vez algún día, en alguna\nparte, volvamos a encontrarnos con [CS:N]Manaphy[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Maybe, one day somewhere, we'll\nbe able to see [CS:N]Manaphy[CR] again...", french="Peut-être qu'un jour, nous\npourrons revoir [CS:N]Manaphy[CR]...", german="Vielleicht treffen wir [CS:N]Manaphy[CR]\neines Tages wieder.", italian="Forse un giorno, da qualche\nparte, incontreremo di nuovo [CS:N]Manaphy[CR]...", spanish="Tal vez algún día, en alguna\nparte, volvamos a encontrarnos con [CS:N]Manaphy[CR]..."})
  else
  SkySceneKit.say({english="Maybe, one day somewhere, we'll\nbe able to see [CS:N]Manaphy[CR] again...", french="Peut-être qu'un jour, nous\npourrons revoir [CS:N]Manaphy[CR]...", german="Vielleicht treffen wir [CS:N]Manaphy[CR]\neines Tages wieder.", italian="Forse un giorno, da qualche\nparte, incontreremo di nuovo [CS:N]Manaphy[CR]...", spanish="Tal vez algún día, en alguna\nparte, volvamos a encontrarnos con [CS:N]Manaphy[CR]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(120)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, [hero].", french=" Oh, [hero].", german=" Oh, [hero].", italian=" Oh, [hero].", spanish=" Oh, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, [hero].", french=" Oh, [hero].", german=" Oh, [hero].", italian=" Oh, [hero].", spanish=" Oh, [hero]."})
  else
  SkySceneKit.say({english=" Oh, [hero].", french=" Oh, [hero].", german=" Oh, [hero].", italian=" Oh, [hero].", spanish=" Oh, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We shouldn't go around feeling\nsorry and sad forever. I doubt [CS:N]Manaphy[CR] would\nwant that.", french="Nous ne devrions pas nous\nlamenter comme ça. Je pense que [CS:N]Manaphy[CR]\nne voudrait pas ça.", german="Wir sollten nicht für\nimmer traurig sein. Ich denke nicht, dass\n[CS:N]Manaphy[CR] das wollen würde.", italian="Non possiamo essere tristi per\nsempre. [CS:N]Manaphy[CR] non lo\nvorrebbe.", spanish="No podemos andar lamentándonos\ntodo el día. No creo que [CS:N]Manaphy[CR] quisiera eso."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We shouldn't go around feeling\nsorry and sad forever. I doubt [CS:N]Manaphy[CR] would\nwant that.", french="Nous ne devrions pas nous\nlamenter comme ça. Je pense que [CS:N]Manaphy[CR]\nne voudrait pas ça.", german="Wir sollten nicht für\nimmer traurig sein. Ich denke nicht, dass\n[CS:N]Manaphy[CR] das wollen würde.", italian="Non possiamo essere tristi per\nsempre. [CS:N]Manaphy[CR] non lo\nvorrebbe.", spanish="No podemos andar lamentándonos\ntodo el día. No creo que [CS:N]Manaphy[CR] quisiera eso."})
  else
  SkySceneKit.say({english="We shouldn't go around feeling\nsorry and sad forever. I doubt [CS:N]Manaphy[CR] would\nwant that.", french="Nous ne devrions pas nous\nlamenter comme ça. Je pense que [CS:N]Manaphy[CR]\nne voudrait pas ça.", german="Wir sollten nicht für\nimmer traurig sein. Ich denke nicht, dass\n[CS:N]Manaphy[CR] das wollen würde.", italian="Non possiamo essere tristi per\nsempre. [CS:N]Manaphy[CR] non lo\nvorrebbe.", spanish="No podemos andar lamentándonos\ntodo el día. No creo que [CS:N]Manaphy[CR] quisiera eso."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But it's not like I can shake this\noff so easily...", french="Mais j'ai tout simplement du mal\nà faire comme si rien ne s'était passé...", german="Aber ich kann dieses Gefühl\nnicht einfach so abschütteln...", italian=" Ma non è facile dimenticare...", spanish="Pero es que me cuesta...\nNo consigo sacármelo de la cabeza."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But I can't get back to feeling\nlike it's normal right away...", french="Mais j'ai tout simplement du mal\nà faire comme si rien ne s'était passé...", german="Aber ich kann nicht sofort so\ntun, als ob alles wie immer wäre...", italian=" Ma non è facile dimenticare...", spanish="Pero es que me cuesta...\nNo consigo sacármelo de la cabeza."})
  else
  SkySceneKit.say({english="But I don't think I can get over\nthis right away...", french="Mais j'ai tout simplement du mal\nà faire comme si rien ne s'était passé...", german="Aber ich kann nicht einfach so\ndarüber hinwegkommen...", italian=" Ma non è facile dimenticare...", spanish="Pero es que me cuesta...\nNo consigo sacármelo de la cabeza."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Still, we should try to be\npositive and keep moving forward...[K] All right?", french="Cependant, nous devons rester\noptimistes et aller de l'avant...[K] Pas vrai?", german="Trotzdem sollten wir versuchen,\npositiv zu denken und nach vorne zu\nschauen...[K] In Ordnung?", italian="Ad ogni modo, dovremmo avere\nun atteggiamento positivo e\nguardare al futuro...[K] Va bene?", spanish="Aun así, intentemos ver el lado\npositivo y seguir adelante...[K] ¿De acuerdo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Still, I think we should be\npositive and keep moving forward...[K] OK?", french="Cependant, nous devons rester\noptimistes et aller de l'avant...[K] Pas vrai?", german="Trotzdem sollten wir versuchen,\npositiv zu denken und nach vorne zu\nschauen...[K] Okay?", italian="Ad ogni modo, dovremmo avere\nun atteggiamento positivo e\nguardare al futuro...[K] Va bene?", spanish="Aun así, intentemos ver el lado\npositivo y seguir adelante...[K] ¿De acuerdo?"})
  else
  SkySceneKit.say({english="Still, we should try to be\npositive and keep moving forward...[K] OK?", french="Cependant, nous devons rester\noptimistes et aller de l'avant...[K] Pas vrai?", german="Trotzdem sollten wir versuchen,\npositiv zu denken und nach vorne zu\nschauen...[K] Okay?", italian="Ad ogni modo, dovremmo avere\nun atteggiamento positivo e\nguardare al futuro...[K] Va bene?", spanish="Aun así, intentemos ver el lado\npositivo y seguir adelante...[K] ¿De acuerdo?"})
  end
  -- message_Close
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.PERFORMANCE_PROGRESS_LIST = SV.SkyVars.PERFORMANCE_PROGRESS_LIST or {}; SV.SkyVars.PERFORMANCE_PROGRESS_LIST[24] = 1 -- $PERFORMANCE_PROGRESS_LIST[24] = 1 (ROM)
  end
  end
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
