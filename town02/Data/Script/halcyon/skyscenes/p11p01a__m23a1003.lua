-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P11P01A/m23a1003.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_P11P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's true.)", french="(C'est vrai.)", german="(Das stimmt.)", italian="(È vero.)", spanish="(Es cierto.)"})
  else
  SkySceneKit.say({english="(It's true.)", french="(C'est vrai.)", german="(Das stimmt.)", italian="(È vero.)", spanish="(Es cierto.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The sea is visible beyond the rock walls.)", french="(On aperçoit la mer derrière les murs\nde pierre.)", german="(Das Meer ist hinter den Felswänden zu\nsehen.)", italian="(Oltre i muri di roccia si vede il mare.)", spanish="(Se puede ver el mar más allá de\nlas paredes de roca.)"})
  else
  SkySceneKit.say({english="(The sea is visible beyond the rock walls.)", french="(On aperçoit la mer derrière les murs\nde pierre.)", german="(Das Meer ist hinter den Felswänden zu\nsehen.)", italian="(Oltre i muri di roccia si vede il mare.)", spanish="(Se puede ver el mar más allá de\nlas paredes de roca.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's nearly evening.[K] We didn't notice the time\ngo by.)", french="(Il fait presque nuit.[K] On n'a pas vu le temps\npasser.)", german="(Es ist fast Abend.[K] Wir haben nicht bemerkt,\nwie die Zeit vergeht.)", italian="(È quasi sera.[K] Non ci siamo accorti che il\ntempo passava.)", spanish="(Está anocheciendo.[K] No nos hemos dado cuenta\nde cómo ha pasado el tiempo.)"})
  else
  SkySceneKit.say({english="(It's nearly evening.[K] We didn't notice the time\ngo by.)", french="(Il fait presque nuit.[K] On n'a pas vu le temps\npasser.)", german="(Es ist fast Abend.[K] Wir haben nicht bemerkt,\nwie die Zeit vergeht.)", italian="(È quasi sera.[K] Non abbiamo notato che il\ntempo passava.)", spanish="(Está anocheciendo.[K] No nos hemos dado cuenta\nde cómo ha pasado el tiempo.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 256, 280, Direction.Left, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="The tide rises up to here from\nthat gap in the walls.", french="La marée monte jusqu'ici\npar les fissures dans la paroi.", german="Die Flut steigt bis hier durch\ndiese Spalte in der Wand.", italian="La marea si alza e arriva qui\npassando da quella breccia nelle pareti.", spanish=" La marea sube hasta aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Oh![K] That's...)", french="(Oh![K] C'est...)", german="(Oh![K] Das ist...)", italian="(Oh![K] Quello è...)", spanish="(¡Oh![K] Pero si es...)"})
  else
  SkySceneKit.say({english="(Oh![K] That's...)", french="(Oh![K] C'est...)", german="(Oh![K] Das ist...)", italian="(Oh![K] Quello è...)", spanish="(¡Oh![K] Pero si es...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 320, 284, false, 2)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? [hero], what's up?", french="Hein? [hero],\nqu'est-ce qui se passe?", german=" Häh? [hero], was ist los?", italian="Eh? [hero], cosa ti\nsuccede?", spanish=" ¿Eh? [hero], ¿qué pasa?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What? [hero], what's\nwrong?", french="Hein? [hero],\nqu'est-ce qui se passe?", german="Äh? [hero], was stimmt\ndenn nicht?", italian="Cosa? [hero], cosa c'è\nche non va?", spanish=" ¿Eh? [hero], ¿qué pasa?"})
  else
  SkySceneKit.say({english="What? [hero], what's the\nmatter?", french="Hein? [hero],\nqu'est-ce qui se passe?", german="Was? [hero], was gibt es\ndenn?", italian="Cosa? [hero], qual è il\nproblema?", spanish=" ¿Eh? [hero], ¿qué pasa?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_juputoru, Direction.Right)
  pcall(function() GAME:MoveCamera(288, 300, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 288, 296, false, 2)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! Look at this!", french=" Eh, regarde ça!", german=" Hey! Sieh dir das an!", italian=" Ehi! Guarda!", spanish=" ¡Eh! ¡Mirad eso!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! Look at this!", french=" Eh, regarde ça!", german=" Hey! Sieh dir das an!", italian=" Ehi! Guarda!", spanish=" ¡Eh! ¡Mirad eso!"})
  else
  SkySceneKit.say({english=" Hey! Look at this!", french=" Eh, regarde ça!", german=" Hey! Sieh dir das an!", italian=" Ehi! Guarda!", spanish=" ¡Eh! ¡Mirad eso!"})
  end
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V23P05A) [décor sub chargé: Sub_v23p05a]
  -- camera2_SetPositionMark(Position<'m3', 19.5, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v23p05a", 30, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Th-this is...[K]the same as the\npattern on my Relic Fragment.", french="C'est...[K] le même symbole\nque sur mon Fragment de Relique.", german="D-das ist...[K] das gleiche Muster\nwie auf dem Reliktfragment.", italian="Q-Questo...[K] è lo stesso disegno\nche c'è sul mio Frammento Antico.", spanish="Esto...[K] Esto es idéntico al dibujo\nde mi Reliquia de Piedra."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Th-this is...[K]the same as the\npattern on my Relic Fragment.", french="C'est...[K] le même symbole\nque sur mon Fragment de Relique.", german="D-das ist...[K] das gleiche Muster\nwie auf dem Reliktfragment.", italian="Q-Questo...[K] è lo stesso disegno\nche c'è sul mio Frammento Antico.", spanish="Esto...[K] Esto es idéntico al dibujo\nde mi Reliquia de Piedra."})
  else
  SkySceneKit.say({english="Th-this is...[K]the same as the\npattern on my Relic Fragment.", french="C'est...[K] le même symbole\nque sur mon Fragment de Relique.", german="D-das ist...[K] das gleiche Muster\nwie auf dem Reliktfragment.", italian="Q-Questo...[K] è lo stesso disegno\nche c'è sul mio Frammento Antico.", spanish="Esto...[K] Esto es idéntico al dibujo\nde mi Reliquia de Piedra."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I suppose that this is the pattern\nthat [CS:N]Chatot[CR] described.", french="Ça doit être le symbole\nqu'a décrit [CS:N]Pijako[CR].", german="Ich nehme an, das ist das\nMuster, das [CS:N]Plaudagei[CR] beschrieben hat.", italian="Suppongo che sia questo il\ndisegno di cui parlava [CS:N]Chatot[CR].", spanish="Supongo que este es el símbolo\nque había descrito [CS:N]Chatot[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I guess this is the same pattern\nthat [CS:N]Chatot[CR] described.", french="Ça doit être le symbole\nqu'a décrit [CS:N]Pijako[CR].", german="Ich nehme an, das ist das gleiche\nMuster, das [CS:N]Plaudagei[CR] beschrieben hat.", italian="Suppongo che sia questo il\ndisegno di cui parlava [CS:N]Chatot[CR].", spanish="Supongo que este es el símbolo\nque había descrito [CS:N]Chatot[CR]."})
  else
  SkySceneKit.say({english="I guess this is the same pattern\nthat [CS:N]Chatot[CR] described.", french="Ça doit être le symbole\nqu'a décrit [CS:N]Pijako[CR].", german="Ich nehme an, das ist das gleiche\nMuster, das [CS:N]Plaudagei[CR] beschrieben hat.", italian="Suppongo che sia questo il\ndisegno di cui parlava [CS:N]Chatot[CR].", spanish="Supongo que este es el símbolo\nque había descrito [CS:N]Chatot[CR]."})
  end
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'll bring out the Relic Fragment.", french="Attendez, je sors le Fragment\nde Relique.", german="Ich hole mal das Reliktfragment\nhervor.", italian=" Prendo il Frammento Antico.", spanish="Voy a sacar la Reliquia de\nPiedra."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let me bring out the Relic\nFragment.", french="Attendez, je sors le Fragment\nde Relique.", german="Lass mich mal das\nReliktfragment hervorholen.", italian="Fammi prendere il Frammento\nAntico.", spanish="Voy a sacar la Reliquia de\nPiedra."})
  else
  SkySceneKit.say({english=" I'll bring out the Relic Fragment.", french="Attendez, je sors le Fragment\nde Relique.", german="Ich hole mal das Reliktfragment\nhervor.", italian=" Prendo il Frammento Antico.", spanish="Voy a sacar la Reliquia de\nPiedra."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-8), false, 1) end
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(6410) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(8), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(60)
  -- GAP: se_Play(8454) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey![K] The Relic Fragment!", french="Oh, regardez ça![K] Le Fragment\nde Relique!", german=" Hey![K] Das Reliktfragment!", italian=" Ehi![K] Il Frammento Antico!", spanish=" ¡Eh![K] ¿Qué le pasa?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey![K] The Relic Fragment!", french="Oh, regardez ça![K] Le Fragment\nde Relique!", german=" Hey![K] Das Reliktfragment!", italian=" Ehi![K] Il Frammento Antico!", spanish=" ¡Eh![K] ¿Qué le pasa?"})
  else
  SkySceneKit.say({english=" Oh![K] The Relic Fragment!", french="Oh, regardez ça![K] Le Fragment\nde Relique!", german=" Oh![K] Das Reliktfragment!", italian=" Ah![K] Il Frammento Antico!", spanish=" ¡Eh![K] ¿Qué le pasa?"})
  end
  -- message_Close
  -- se_FadeOut(8454, 120) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  SkySubScreen.Show("v23p05a", 30, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  -- bgm2_PlayFadeIn(BGM_GLOWING_NOISE) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_Acting(2) [neutre/état moteur]
  -- GAP: SetEffect 668 — VFX sans émote PMDO équivalente
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Whoa! The pattern on the wall's\nglowing now?!", french="Waouh! Le symbole gravé sur\nle mur s'est mis à briller!", german="Wow! Das Muster an der Wand\nglüht jetzt!", italian="Wow! Il disegno sul muro si sta\nilluminando?!", spanish="¡Vaya! ¡El símbolo en la pared\nestá brillando!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wow! The pattern on the wall's\nglowing now?!", french="Waouh! Le symbole gravé sur\nle mur s'est mis à briller!", german="Wow! Das Muster an der Wand\nglüht jetzt!", italian="Wow! Il disegno sul muro si sta\nilluminando?!", spanish="¡Vaya! ¡El símbolo en la pared\nestá brillando!"})
  else
  SkySceneKit.say({english="Wow! The pattern on the wall's\nglowing now?!", french="Waouh! Le symbole gravé sur\nle mur s'est mis à briller!", german="Wow! Das Muster an der Wand\nglüht jetzt!", italian="Wow! Il disegno sul muro si sta\nilluminando?!", spanish="¡Vaya! ¡El símbolo en la pared\nestá brillando!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's as if...[K]it's reacting to the\nRelic Fragment!", french="On dirait...[K] qu'il réagit\nà la présence du Fragment de Relique!", german="Es ist, als ob...[K] Als ob es auf\ndas Reliktfragment reagiert!", italian="Sembra che...[K] reagisca alla\npresenza del Frammento Antico!", spanish="Es como si...[K]\n¡Como si reaccionara a la Reliquia de Piedra!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's as if...[K]it's reacting to the\nRelic Fragment!", french="On dirait...[K] qu'il réagit\nà la présence du Fragment de Relique!", german="Es ist, als ob...[K] Als ob es auf\ndas Reliktfragment reagiert!", italian="Sembra che...[K] reagisca alla\npresenza del Frammento Antico!", spanish="Es como si...[K]\n¡Como si reaccionara a la Reliquia de Piedra!"})
  else
  SkySceneKit.say({english="It's as if...[K]it's reacting to the\nRelic Fragment!", french="On dirait...[K] qu'il réagit\nà la présence du Fragment de Relique!", german="Es ist, als ob...[K] Als ob es auf\ndas Reliktfragment reagiert!", italian="Sembra che...[K] reagisca alla\npresenza del Frammento Antico!", spanish="Es como si...[K]\n¡Como si reaccionara a la Reliquia de Piedra!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- GAP: se_Play(7449) — id SE NDS sans portage PMDO identifié
  -- screen2_WhiteChange(0, 5, 256, 64) [variation d'alpha du sub déjà révélé: nappe maintenue - documenté]
  GAME:FadeIn(64) -- WhiteChange
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Uaaah!", italian=" Aaaah!", spanish=" ¡Aaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Uaaah!", italian=" Aaaah!", spanish=" ¡Aaaah!"})
  else
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Uaaah!", italian=" Aaaah!", spanish=" ¡Aaaah!"})
  end
  GAME:WaitFrames(60)
  -- message_CloseEnforce
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- GAP: se_Play(7444) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P11P01A2_145) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(5)
  -- se_FadeOut(7444, 120) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Left)
  GAME:WaitFrames(30)
  -- screen2_WhiteChange(0, 30, 64, 0) [variation d'alpha du sub déjà révélé: nappe maintenue - documenté]
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
