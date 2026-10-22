-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D19P11A/m18a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(19, 1) -- $SCENARIO_MAIN = scn[19,1] (ROM)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! [hero]!", french=" [hero], regarde!", german=" Hey! [hero]!", italian=" Ehi! [hero]!", spanish=" ¡Oye! ¡[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Look! [hero]!", french=" [hero], regarde!", german=" Sieh mal! [hero]!", italian=" Guarda! [hero]!", spanish=" ¡Mira! ¡[hero]!"})
  else
  SkySceneKit.say({english=" Look! [hero]!", french=" [hero], regarde!", german=" Sieh mal! [hero]!", italian=" Guarda! [hero]!", spanish=" ¡Mira! ¡[hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Is that the exit over there?", french="Est-ce que c'est la sortie,\nlà-bas?", german=" Ist das da drüben der Ausgang?", italian=" Quella laggiù è l'uscita?", spanish=" ¿Eso de allí será la salida?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Could that be the exit over\nthere?", french="Est-ce que c'est la sortie,\nlà-bas?", german="Könnte das da drüben der\nAusgang sein?", italian="Quella laggiù può essere\nl'uscita?", spanish=" ¿Eso de allí será la salida?"})
  else
  SkySceneKit.say({english="Could that be the exit over\nthere?", french="Est-ce que c'est la sortie,\nlà-bas?", german="Könnte das da drüben der\nAusgang sein?", italian="Quella laggiù può essere\nl'uscita?", spanish=" ¿Eso de allí será la salida?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's check it out!", french=" Allons voir!", german=" Sehen wir nach!", italian=" Andiamo a vedere!", spanish=" ¡Vamos a comprobarlo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go over there!", french=" Allons voir!", german=" Lass uns dorthin gehen!", italian=" Andiamo a vedere!", spanish=" ¡Vamos a echar un vistazo!"})
  else
  SkySceneKit.say({english=" Let's go check it!", french=" Allons voir!", german=" Lass uns nachsehen!", italian=" Andiamo a controllare!", spanish=" ¡Vamos a comprobarlo!"})
  end
  -- message_Close
  -- back_SetGround(LEVEL_D19P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_IN_THE_FUTURE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  GROUND:MoveToPosition(partner, 160, 172, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(hero, 136, 196, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huff-huff...[K] Huff-huff...", french=" Pff, pff...[K] Pff, pff...", german=" Keuch, keuch...[K] Keuch, keuch...", italian=" Uff-uff...[K] Uff-uff...", spanish=" Uf... Puf...[K] Uf... Puf..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huff-huff...[K] Huff-huff...", french=" Pff, pff...[K] Pff, pff...", german=" Keuch, keuch...[K] Keuch, keuch...", italian=" Uff-uff...[K] Uff-uff...", spanish=" Uf... Puf...[K] Uf... Puf..."})
  else
  SkySceneKit.say({english=" Huff-huff...[K] Huff-huff...", french=" Pff, pff...[K] Pff, pff...", german=" Keuch, keuch...[K] Keuch, keuch...", italian=" Uff-uff...[K] Uff-uff...", spanish=" Uf... Puf...[K] Uf... Puf..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Did we manage to stretch our\nlead over those [CS:N]Sableye[CR]? Huff-huff...", french="Est-ce qu'on a réussi à semer\nles [CS:N]Ténéfix[CR]? Pff, pff...", german="Haben wir unseren Vorsprung zu\nden [CS:N]Zobiris[CR] ein bisschen vergrößert?\nKeuch, keuch...", italian="Siamo riusciti a seminare quei\n[CS:N]Sableye[CR]? Pant-pant...", spanish="¿Hemos logrado dejar atrás a\nesos [CS:N]Sableye[CR]? Uf... Puf..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Did we put some distance\nbetween us and those [CS:N]Sableye[CR]? Huff-huff...", french="Est-ce qu'on a réussi à semer\nles [CS:N]Ténéfix[CR]? Pff, pff...", german="Haben wir unseren Vorsprung zu\nden [CS:N]Zobiris[CR] ein bisschen vergrößert?\nKeuch, keuch...", italian="Abbiamo messo un po' di distanza\ntra noi e quei [CS:N]Sableye[CR]? Pant-pant...", spanish="¿Hemos logrado dejar atrás a\nesos [CS:N]Sableye[CR]? Uf... Puf..."})
  else
  SkySceneKit.say({english="Did we gain some distance over\nthose [CS:N]Sableye[CR]? Huff-huff...", french="Est-ce qu'on a réussi à semer\nles [CS:N]Ténéfix[CR]? Pff, pff...", german="Haben wir unseren Vorsprung zu\nden [CS:N]Zobiris[CR] ein bisschen vergrößert?\nKeuch, keuch...", italian="Abbiamo guadagnato un po' di\ndistanza su quei [CS:N]Sableye[CR]? Pant-pant...", spanish="¿Hemos logrado dejar atrás a\nesos [CS:N]Sableye[CR]? Uf... Puf..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We should rest a bit here.", french="Arrêtons-nous ici pour nous\nreposer un peu.", german="Wir sollten uns hier etwas\nausruhen.", italian=" Dovremmo riposarci un po' qui.", spanish=" Deberíamos descansar un rato."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's rest a little now.", french="Arrêtons-nous ici pour nous\nreposer un peu.", german=" Ruhen wir uns jetzt etwas aus.", italian=" Ora riposiamoci un po'.", spanish=" Deberíamos descansar un rato."})
  else
  SkySceneKit.say({english=" We should rest a little now.", french="Arrêtons-nous ici pour nous\nreposer un peu.", german=" Lass uns jetzt etwas ausruhen.", italian=" Ora dovremmo riposarci un po'.", spanish=" Deberíamos descansar un rato."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! There's water there!", french=" Eh, regarde, de l'eau!", german=" Hey! Da ist Wasser!", italian=" Ehi! Là c'è dell'acqua!", spanish=" ¡Vaya! ¡Allí hay agua!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh! There's water there!", french=" Eh, regarde, de l'eau!", german=" Oh! Da ist Wasser!", italian=" Oh! Là c'è dell'acqua!", spanish=" ¡Vaya! ¡Allí hay agua!"})
  else
  SkySceneKit.say({english=" Look! There's water there!", french=" Eh, regarde, de l'eau!", german=" Sieh mal! Da ist Wasser!", italian=" Guarda! Là c'è dell'acqua!", spanish=" ¡Vaya! ¡Allí hay agua!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(316, 188, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 336, 172, false, 2)
  GROUND:MoveToPosition(hero, 296, 196, false, 2)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh...?", french=" Quoi...?", german=" Huch?", italian=" Eh...?", spanish=" ¿Qué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What...?", french=" Quoi...?", german=" Was?", italian=" Cosa...?", spanish=" ¿Qué?"})
  else
  SkySceneKit.say({english=" Wh-what...?", french=" Quoi...?", german=" W-was?", italian=" C-Cosa...?", spanish=" ¿Qué?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This waterfall...[K] The water's not\nflowing...", french="Cette cascade est bizarre...[K]\nl'eau ne coule pas...", german="Dieser Wasserfall...[K]\nDas Wasser fließt nicht...", italian="Questa cascata...[K] L'acqua non\nscorre...", spanish="En esta cascada...[K] ¡el agua no\nfluye!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This waterfall...[K] This water isn't\nflowing at all.", french="Cette cascade est bizarre...[K]\nl'eau ne coule pas...", german="Dieser Wasserfall...[K]\nDas Wasser fließt nicht...", italian="Questa cascata...[K] L'acqua è\nimmobile.", spanish="En esta cascada...[K] ¡el agua no\nfluye!"})
  else
  SkySceneKit.say({english="This waterfall...[K] The water's not\nflowing one bit...", french="Cette cascade est bizarre...[K]\nl'eau ne coule pas...", german="Dieser Wasserfall...[K]\nDas Wasser fließt nicht...", italian="Questa cascata...[K] L'acqua non\nscorre...", spanish="En esta cascada...[K] ¡el agua no\nfluye!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The gushing water is totally\nsuspended in space!", french="Le jet d'eau est carrément figé\ndans les airs!", german="Das Wasser ist mitten in der\nBewegung erstarrt!", italian="Gli zampilli d'acqua sono sospesi\nin aria!", spanish="¡El agua se ha quedado\nsuspendida en el aire!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The gushing water is totally\nsuspended in space!", french="Le jet d'eau est carrément figé\ndans les airs!", german="Das Wasser ist mitten in der\nBewegung erstarrt!", italian="Gli zampilli d'acqua sono sospesi\nin aria!", spanish="¡El agua se ha quedado\nsuspendida en el aire!"})
  else
  SkySceneKit.say({english="The gushing water is totally\nsuspended in space!", french="Le jet d'eau est carrément figé\ndans les airs!", german="Das Wasser ist mitten in der\nBewegung erstarrt!", italian="Gli zampilli d'acqua sono sospesi\nin aria!", spanish="¡El agua se ha quedado\nsuspendida en el aire!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Is [CS:N]Grovyle[CR] right after all?", french="[CS:N]Massko[CR] aurait-il raison,\nfinalement?", german=" Hat [CS:N]Reptain[CR] doch recht?", italian="Aveva ragione [CS:N]Grovyle[CR], alla\nfine?", spanish="¿Y si resulta que [CS:N]Grovyle[CR] tiene\nrazón?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Is [CS:N]Grovyle[CR] right after all?", french="[CS:N]Massko[CR] aurait-il raison,\nfinalement?", german=" Hat [CS:N]Reptain[CR] doch recht?", italian="Aveva ragione [CS:N]Grovyle[CR], alla\nfine?", spanish="¿Y si resulta que [CS:N]Grovyle[CR] tiene\nrazón?"})
  else
  SkySceneKit.say({english=" Is [CS:N]Grovyle[CR] right after all?", french="[CS:N]Massko[CR] aurait-il raison,\nfinalement?", german=" Hat [CS:N]Reptain[CR] doch recht?", italian="Aveva ragione [CS:N]Grovyle[CR], alla\nfine?", spanish="¿Y si resulta que [CS:N]Grovyle[CR] tiene\nrazón?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Has time really stopped in\nthe future?", french="Le temps se serait-il vraiment\narrêté dans le futur?", german="Ist die Zeit in der Zukunft\nwirklich stehen geblieben?", italian="Il tempo nel futuro si è davvero\nfermato?", spanish="¿Se ha detenido el tiempo en\nel futuro?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Has time really stopped in\nthe future?", french="Le temps se serait-il vraiment\narrêté dans le futur?", german="Ist die Zeit in der Zukunft\nwirklich stehen geblieben?", italian="Il tempo nel futuro si è davvero\nfermato?", spanish="¿Se ha detenido el tiempo en\nel futuro?"})
  else
  SkySceneKit.say({english="Has time really stopped in\nthe future?", french="Le temps se serait-il vraiment\narrêté dans le futur?", german="Ist die Zeit in der Zukunft\nwirklich stehen geblieben?", italian="Il tempo nel futuro si è davvero\nfermato?", spanish="¿Se ha detenido el tiempo en\nel futuro?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Why did [CS:N]Dusknoir[CR] bring us here?", french="Mais pourquoi [CS:N]Noctunoir[CR] nous\na-t-il fait venir ici?", german="Wieso hat [CS:N]Zwirrfinst[CR] uns\nan diesen Ort gebracht?", italian="Perché [CS:N]Dusknoir[CR] ci ha portato\nqui?", spanish="¿Por qué nos ha traído aquí\n[CS:N]Dusknoir[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Why did [CS:N]Dusknoir[CR] bring us here?", french="Mais pourquoi [CS:N]Noctunoir[CR] nous\na-t-il fait venir ici?", german="Wieso hat [CS:N]Zwirrfinst[CR] uns\nan diesen Ort gebracht?", italian="Perché [CS:N]Dusknoir[CR] ci ha portato\nqui?", spanish="¿Por qué nos ha traído aquí\n[CS:N]Dusknoir[CR]?"})
  else
  SkySceneKit.say({english=" Why did [CS:N]Dusknoir[CR] bring us here?", french="Mais pourquoi [CS:N]Noctunoir[CR] nous\na-t-il fait venir ici?", german="Wieso hat [CS:N]Zwirrfinst[CR] uns\nan diesen Ort gebracht?", italian="Perché [CS:N]Dusknoir[CR] ci ha portato\nqui?", spanish="¿Por qué nos ha traído aquí\n[CS:N]Dusknoir[CR]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The great [CS:N]Dusknoir[CR], who was so\nkind to us...", french="Le grand [CS:N]Noctunoir[CR], il était\nsi gentil avec nous...", german="Der große [CS:N]Zwirrfinst[CR], der so\nfreundlich zu uns war...", italian="Il grande [CS:N]Dusknoir[CR], che era\ncosì gentile con noi...", spanish="El gran [CS:N]Dusknoir[CR] había sido\ntan bueno con nosotros..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The great [CS:N]Dusknoir[CR], who was so\nkind to us...", french="Le grand [CS:N]Noctunoir[CR], il était\nsi gentil avec nous...", german="Der große [CS:N]Zwirrfinst[CR], der so\nfreundlich zu uns war...", italian="Il grande [CS:N]Dusknoir[CR], che era\ncosì gentile con noi...", spanish="El gran [CS:N]Dusknoir[CR] había sido\ntan bueno con nosotros..."})
  else
  SkySceneKit.say({english="The great [CS:N]Dusknoir[CR], who was so\nkind to us...", french="Le grand [CS:N]Noctunoir[CR], il était\nsi gentil avec nous...", german="Der große [CS:N]Zwirrfinst[CR], der so\nfreundlich zu uns war...", italian="Il grande [CS:N]Dusknoir[CR], che era\ncosì gentile con noi...", spanish="El gran [CS:N]Dusknoir[CR] nos había\ntratado tan bien..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I don't know what to believe\nanymore...", french="Je ne sais plus ce que je dois\ncroire...", german="Ich weiß nicht mehr, was ich\nglauben soll...", italian=" Non so più cosa credere...", spanish=" Ya no sé qué creer..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I don't know what to believe\nanymore...", french="Je ne sais plus ce que je dois\ncroire...", german="Ich weiß nicht mehr, was ich\nglauben soll...", italian=" Non so più cosa credere...", spanish=" Ya no sé qué creer..."})
  else
  SkySceneKit.say({english="I don't know what to believe\nanymore...", french="Je ne sais plus ce que je dois\ncroire...", german="Ich weiß nicht mehr, was ich\nglauben soll...", italian=" Non so più cosa credere...", spanish=" Ya no sé qué creer..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If only there were some way of\nfinding the truth...", french="Si seulement il y avait un moyen\nde démêler le vrai du faux...", german="Wenn wir nur irgendwie die\nWahrheit herausfinden könnten...", italian="Se solo ci fosse un modo per\nscoprire la verità...", spanish="Si hubiera alguna forma de\naveriguar la verdad..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If only there were some way of\nfinding the truth...", french="Si seulement il y avait un moyen\nde démêler le vrai du faux...", german="Wenn wir nur irgendwie die\nWahrheit herausfinden könnten...", italian="Se solo ci fosse un modo per\nscoprire la verità...", spanish="Si hubiera alguna forma de\naveriguar la verdad..."})
  else
  SkySceneKit.say({english="If only there were some way of\nfinding the truth...", french="Si seulement il y avait un moyen\nde démêler le vrai du faux...", german="Wenn wir nur irgendwie die\nWahrheit herausfinden könnten...", italian="Se solo ci fosse un modo per\nscoprire la verità...", spanish="Si hubiera alguna forma de\naveriguar la verdad..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh! I know!", french=" Oh! Je sais!", german=" Oh! Ich weiß, wie!", italian=" Ah! Ci sono!", spanish=" ¡Ah! ¡Ya sé!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh! I know!", french=" Oh! Je sais!", german=" Oh! Ich weiß, wie!", italian=" Ah! Ci sono!", spanish=" ¡Ah! ¡Ya sé!"})
  else
  SkySceneKit.say({english=" Oh! I know!", french=" Oh! Je sais!", german=" Oh! Ich weiß, wie!", italian=" Ah! Ci sono!", spanish=" ¡Ah! ¡Ya sé!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="There is a way of getting at the\ntruth, [hero]!", french=" Il y a un moyen, [hero]!", german="Es gibt einen Weg, die Wahrheit\nherauszufinden, [hero]!", italian="Un modo c'è, per scoprire la\nverità, [hero]!", spanish="¡Hay una manera de descubrir\nla verdad, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There is a way of getting at the\ntruth, [hero]!", french=" Il y a un moyen, [hero]!", german="Es gibt einen Weg, die Wahrheit\nherauszufinden, [hero]!", italian="Un modo c'è, per scoprire la\nverità, [hero]!", spanish="¡Hay una manera de descubrir\nla verdad, [hero]!"})
  else
  SkySceneKit.say({english="There is a way of getting at the\ntruth, [hero]!", french=" Il y a un moyen, [hero]!", german="Es gibt einen Weg, die Wahrheit\nherauszufinden, [hero]!", italian="Un modo c'è, per scoprire la\nverità, [hero]!", spanish="¡Hay una manera de descubrir\nla verdad, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Huh?)", french="(Ah bon?)", german="(Und wie?)", italian="(Eh?)", spanish="(¿Cuál?)"})
  else
  SkySceneKit.say({english="(Huh?)", french="(Ah bon?)", german="(Und wie?)", italian="(Eh?)", spanish="(¿Cuál?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
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
  pcall(function() SOUND:FadeOutBGM(180) end)
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
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
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
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" No, huh?", french=" Alors, rien?", german=" Nichts?", italian=" No, eh?", spanish=" ¿No?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" No, huh?", french=" Alors, rien?", german=" Nichts?", italian=" No, eh?", spanish=" ¿No?"})
  else
  SkySceneKit.say({english=" No, huh?", french=" Alors, rien?", german=" Nichts?", italian=" No, eh?", spanish=" ¿No?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Urf... That's too bad.[K] It would've\nmade me less worried if we could begin to\nunderstand what's happening...", french="Ah... dommage.[K] Ça m'aurait\nun peu soulagé d'y voir plus clair dans\ntout ça...", german="Uff, schade.[K] Ich würde mir\nweniger Sorgen machen, wenn wir auch nur\nannähernd verstehen würden, was los ist...", italian="Uff... Che brutta cosa.[K] Sarei\nmeno preoccupato se cominciassi a capire\ncosa sta succedendo...", spanish="Vaya, qué decepción...[K] No estaría\ntan preocupado si tuviéramos alguna forma de\nentender lo que está pasando."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Urf... That's disappointing.[K]\nIt would've been reassuring if we could begin\nto understand what's happening...", french="Ah... dommage.[K] Ça m'aurait\nun peu soulagé d'y voir plus clair dans\ntout ça...", german="Uff, schade.[K] Ich würde mir\nweniger Sorgen machen, wenn wir auch nur\nannähernd verstehen würden, was los ist...", italian="Uff... Che delusione.[K] Sarei\npiù tranquillo se cominciassi a capire cosa\nsta succedendo...", spanish="Vaya, qué decepción...[K] No estaría\ntan preocupado si tuviéramos alguna forma de\nentender lo que está pasando."})
  else
  SkySceneKit.say({english="Urf... That's disappointing.[K]\nIt would've been reassuring if we could begin\nto understand what's happening...", french="Ah... dommage.[K] Ça m'aurait\nun peu soulagée d'y voir plus clair dans\ntout ça...", german="Uff, schade.[K] Ich würde mir\nweniger Sorgen machen, wenn wir auch nur\nannähernd verstehen würden, was los ist...", italian="Uff... Che delusione.[K] Sarei\npiù tranquilla se cominciassi a capire cosa\nsta succedendo...", spanish="Vaya, qué decepción...[K] No estaría\ntan preocupada si tuviéramos alguna forma de\nentender lo que está pasando."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We didn't learn anything at all...", french=" On n'a rien appris de plus...", german=" Wir haben gar nichts erfahren...", italian=" Non abbiamo scoperto nulla...", spanish=" No hemos sacado nada en claro..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We didn't learn anything at all...", french=" On n'a rien appris de plus...", german=" Wir haben gar nichts erfahren...", italian=" Non abbiamo scoperto nulla...", spanish=" No hemos sacado nada en claro..."})
  else
  SkySceneKit.say({english=" We didn't learn anything at all...", french=" On n'a rien appris de plus...", german=" Wir haben gar nichts erfahren...", italian=" Non abbiamo scoperto nulla...", spanish=" No hemos sacado nada en claro..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We've spent a lot of time here.", french="On a passé beaucoup de temps\nici.", german="Wir haben hier viel Zeit\nverschwendet.", italian=" Siamo qui da un sacco di tempo.", spanish="Y encima, hemos pasado mucho\ntiempo aquí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We've spent a lot of time here.", french="On a passé beaucoup de temps\nici.", german="Wir haben hier viel Zeit\nverschwendet.", italian=" Siamo qui da un sacco di tempo.", spanish="Y encima, hemos pasado mucho\ntiempo aquí."})
  else
  SkySceneKit.say({english=" We've spent a lot of time here.", french="On a passé beaucoup de temps\nici.", german="Wir haben hier viel Zeit\nverschwendet.", italian=" Siamo qui da un sacco di tempo.", spanish="Y encima, hemos pasado mucho\ntiempo aquí."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If we don't hurry, those [CS:N]Sableye[CR]\nwill catch up to us.", french="Si on ne se dépêche pas,\nles [CS:N]Ténéfix[CR] vont nous rattraper.", german="Wenn wir uns nicht beeilen,\nholen uns die [CS:N]Zobiris[CR] ein.", italian="Se non ci sbrighiamo, quei\n[CS:N]Sableye[CR] ci raggiungeranno.", spanish="Si no nos damos prisa, esos\n[CS:N]Sableye[CR] nos alcanzarán."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If we don't hurry, those [CS:N]Sableye[CR]\nwill get to us.", french="Si on ne se dépêche pas,\nles [CS:N]Ténéfix[CR] vont nous rattraper.", german="Wenn wir uns nicht beeilen,\nholen uns die [CS:N]Zobiris[CR] ein.", italian="Se non ci sbrighiamo, quei\n[CS:N]Sableye[CR] ci raggiungeranno.", spanish="Si no nos damos prisa, esos\n[CS:N]Sableye[CR] nos alcanzarán."})
  else
  SkySceneKit.say({english="If we don't hurry, those [CS:N]Sableye[CR]\nwill catch up to us.", french="Si on ne se dépêche pas,\nles [CS:N]Ténéfix[CR] vont nous rattraper.", german="Wenn wir uns nicht beeilen,\nholen uns die [CS:N]Zobiris[CR] ein.", italian="Se non ci sbrighiamo, quei\n[CS:N]Sableye[CR] ci raggiungeranno.", spanish="Si no nos damos prisa, esos\n[CS:N]Sableye[CR] nos alcanzarán."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's get ready and go,\n[hero].", french="On part quand tu veux,\n[hero].", german="Machen wir uns auf die Beine,\n[hero].", italian="Prepariamoci e andiamo,\n[hero].", spanish="Prepárate cuanto antes y\nsigamos, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's get ready and go,\n[hero].", french="On part quand tu veux,\n[hero].", german="Machen wir uns auf die Beine,\n[hero].", italian="Prepariamoci e andiamo,\n[hero].", spanish="Prepárate cuanto antes y\nsigamos, [hero]."})
  else
  SkySceneKit.say({english="Let's get ready and go,\n[hero].", french="On part quand tu veux,\n[hero].", german="Machen wir uns auf die Beine,\n[hero].", italian="Prepariamoci e andiamo,\n[hero].", spanish="Prepárate cuanto antes y\nsigamos, [hero]."})
  end
  -- message_Close
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBGM("Dark Hill.ogg", true) end)
end
