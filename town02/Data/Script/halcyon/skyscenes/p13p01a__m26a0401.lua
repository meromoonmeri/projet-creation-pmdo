-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P13P01A/m26a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_P13P01A) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- supervision_Acting(3) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(600), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(5.0,0.0) px/frame -> caméra continue (pilote scroll)
  -- SetAnimation(512) [anim idle native]
  -- SetAnimation(512) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- GAP: BGM BGM_HEAVY_FEELING non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(180)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- back_SetBackScrollSpeed(0,0): arrêt du défilement
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What's up, [hero]?", french="Il y a un problème,\n[hero]?", german=" Was ist los, [hero]?", italian="Che cosa ti prende,\n[hero]?", spanish=" ¿Qué pasa, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What's the matter,\n[hero]?", french="Il y a un problème,\n[hero]?", german="Was ist mit dir,\n[hero]?", italian=" Che succede, [hero]?", spanish=" ¿Qué pasa, [hero]?"})
  else
  SkySceneKit.say({english=" What's wrong, [hero]?", french="Il y a un problème,\n[hero]?", german="Stimmt etwas nicht,\n[hero]?", italian="Cosa c'è che non va,\n[hero]?", spanish=" ¿Qué pasa, [hero]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's pick up the pace.", french=" Dépêchons-nous.", german=" Lass uns einen Schritt zulegen.", italian=" Facciamo presto.", spanish=" Démonos prisa."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's hurry.", french=" Dépêchons-nous.", german=" Beeilen wir uns.", italian=" Facciamo in fretta.", spanish=" Démonos prisa."})
  else
  SkySceneKit.say({english=" Let's hurry.", french=" Dépêchons-nous.", german=" Beeilen wir uns.", italian=" Facciamo in fretta.", spanish=" Démonos prisa."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(480), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(4.0,0.0) px/frame -> caméra continue (pilote scroll)
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(............)", french="(............)", german="(............)", italian="(............)", spanish="(...)"})
  else
  SkySceneKit.say({english="(............)", french="(............)", german="(............)", italian="(............)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(........................)", french="(........................)", german="(........................)", italian="(........................)", spanish="(...)"})
  else
  SkySceneKit.say({english="(........................)", french="(........................)", german="(........................)", italian="(........................)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(My body...[K]feels heavy...)", french="(Je me sens...[K] lourd...)", german="(Mein Körper...[K] fühlt sich schwer an...)", italian="(Il mio corpo...[K] mi sento pesante...)", spanish="(Siento el cuerpo...[K] muy pesado...)"})
  else
  SkySceneKit.say({english="(My body...[K]feels heavy...)", french="(Je me sens...[K] lourde...)", german="(Mein Körper...[K] fühlt sich schwer an...)", italian="(Il mio corpo...[K] mi sento pesante...)", spanish="(Siento el cuerpo...[K] muy pesado...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What's wrong...?[K] Why am I struggling to\nmove...?)", french="(Qu'est-ce qui se passe...?[K] Pourquoi j'ai tant\nde mal à bouger...?)", german="(Was ist los?[K] Warum habe ich solche\nMühe, mich zu bewegen?)", italian="(Cosa succede...?[K] Perché faccio fatica a\nmuovermi...?)", spanish="(¿Qué pasa...?[K] ¿Por qué no puedo moverme?)"})
  else
  SkySceneKit.say({english="(What's wrong...?[K] Why am I struggling to\nmove...?)", french="(Qu'est-ce qui se passe...?[K] Pourquoi j'ai tant\nde mal à bouger...?)", german="(Was ist los?[K] Warum habe ich solche\nMühe, mich zu bewegen?)", italian="(Cosa succede...?[K] Perché faccio fatica a\nmuovermi...?)", spanish="(¿Qué pasa...?[K] ¿Por qué no puedo moverme?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's like...[K]my legs are weighed down...)", french="(J'ai l'impression...[K] que mes jambes sont\nen plomb...)", german="(Als ob[K] meine Beine von einem Gewicht\nheruntergezogen würden...)", italian="(È come se...[K] le mie gambe fossero\nappesantite...)", spanish="(Es como si...[K] tuviera las piernas clavadas\nen el suelo.)"})
  else
  SkySceneKit.say({english="(It's like...[K]my legs are weighed down...)", french="(J'ai l'impression...[K] que mes jambes sont\nen plomb...)", german="(Als ob[K] meine Beine von einem Gewicht\nheruntergezogen würden...)", italian="(È come se...[K] le mie gambe fossero\nappesantite...)", spanish="(Es como si...[K] tuviera las piernas clavadas\nen el suelo.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Maybe...[K]now that we changed the future...)", french="(Peut-être que...[K] maintenant qu'on a modifié\nle cours de l'histoire...)", german="(Jetzt,[K] da wir die Zukunft verändert haben...)", italian="(Forse...[K] ora che abbiamo cambiato il\nfuturo...)", spanish="(Tal vez...[K] ahora que hemos cambiado\nel futuro...)"})
  else
  SkySceneKit.say({english="(Maybe...[K]now that we changed the future...)", french="(Peut-être que...[K] maintenant qu'on a modifié\nle cours de l'histoire...)", german="(Jetzt,[K] da wir die Zukunft verändert haben...)", italian="(Forse...[K] ora che abbiamo cambiato il\nfuturo...)", spanish="(Tal vez...[K] ahora que hemos cambiado\nel futuro...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(My own disappearance...[K]is drawing near...)", french="(Ma propre disparition...[K] approche...)", german="(Vielleicht...[K] Vielleicht rückt jetzt auch mein\neigenes Entschwinden näher...)", italian="(... si avvicina il momento...[K] in cui\nscomparirò...)", spanish="(Mi propia desaparición...[K] sea inminente.)"})
  else
  SkySceneKit.say({english="(My own disappearance...[K]is drawing near...)", french="(Ma propre disparition...[K] approche...)", german="(Vielleicht...[K] Vielleicht rückt jetzt auch mein\neigenes Entschwinden näher...)", italian="(... si avvicina il momento...[K] in cui\nscomparirò...)", spanish="(Mi propia desaparición...[K] sea inminente.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5131) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- back_SetBackScrollSpeed(0,0): arrêt du défilement
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Quake!", french=" Un tremblement de terre!", german=" Ein Beben!", italian=" Scosse!", spanish=" ¡Un terremoto!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Tremors!", french=" Un tremblement de terre!", german=" Erschütterungen!", italian=" Scosse!", spanish=" ¡Un terremoto!"})
  else
  SkySceneKit.say({english=" Tremors!", french=" Un tremblement de terre!", german=" Erschütterungen!", italian=" Scosse!", spanish=" ¡Un terremoto!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  -- se_FadeOut(5131, 70) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(70)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's stopped shaking...", french=" Ça s'est calmé...", german=" Das Schwanken hat aufgehört.", italian=" Sono finite...", spanish=" Han parado los temblores."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's settled down...", french=" Ça s'est calmé...", german=" Sie sind schwächer geworden.", italian=" Sono finite...", spanish=" Han parado los temblores."})
  else
  SkySceneKit.say({english=" It's settled down...", french=" Ça s'est calmé...", german=" Sie sind schwächer geworden.", italian=" Sono finite...", spanish=" Han parado los temblores."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Maybe things are still settling\nback to normal...", french="Peut-être que les choses sont\nencore en train de se remettre en place...", german="Vielleicht ist es ein Nachbeben,\nwährend sich die Dinge weiter normalisieren...", italian="Forse le cose non sono ancora\ntornate del tutto alla normalità...", spanish="Supongo que las cosas todavía\ntienen que ir volviendo a la normalidad."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I guess things are still settling\nback to normal...", french="Peut-être que les choses sont\nencore en train de se remettre en place...", german="Vielleicht ist es ein Nachbeben,\nwährend sich die Dinge weiter normalisieren...", italian="Forse le cose non sono ancora\ntornate del tutto alla normalità...", spanish="Supongo que las cosas todavía\ntienen que ir volviendo a la normalidad."})
  else
  SkySceneKit.say({english="Maybe things are still settling\nback to normal...", french="Peut-être que les choses sont\nencore en train de se remettre en place...", german="Vielleicht ist es ein Nachbeben,\nwährend sich die Dinge weiter normalisieren...", italian="Forse le cose non sono ancora\ntornate del tutto alla normalità...", spanish="Supongo que las cosas todavía\ntienen que ir volviendo a la normalidad."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go, [hero].", french=" On y va, [hero].", german=" Gehen wir, [hero].", italian=" Andiamo, [hero].", spanish=" Vamos, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go, [hero].", french=" On y va, [hero].", german=" Gehen wir, [hero].", italian=" Andiamo, [hero].", spanish=" Vamos, [hero]."})
  else
  SkySceneKit.say({english=" Let's go, [hero].", french=" On y va, [hero].", german=" Gehen wir, [hero].", italian=" Andiamo, [hero].", spanish=" Vamos, [hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- SetAnimation(768) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(144), p.Y+(32), false, 2) end -- Slide2PositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(24), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitBgm
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(5)
  -- bgm2_PlayFadeIn(BGM_DONT_EVER_FORGET) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...!)", french="(...!)", german="(...)", italian="(...!)", spanish="(...)"})
  else
  SkySceneKit.say({english="(...!)", french="(...!)", german="(...)", italian="(...!)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(This...[K] This light...)", french="(Cette...[K] cette lumière...)", german="(Dieses...[K] Dieses Licht...)", italian="(Questa...[K] questa luce...)", spanish="(Esto...[K] Esta luz...)"})
  else
  SkySceneKit.say({english="(This...[K] This light...)", french="(Cette...[K] cette lumière...)", german="(Dieses...[K] Dieses Licht...)", italian="(Questa...[K] questa luce...)", spanish="(Esto...[K] Esta luz...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...[K]All right...)", french="(... Je vois...)", german="(...[K]Ich verstehe...)", italian="(...[K] Va bene...)", spanish="(De...[K] de acuerdo.)"})
  else
  SkySceneKit.say({english="(...[K]OK...)", french="(... Je vois...)", german="(...[K]Okay...)", italian="(...[K] Ok...)", spanish="(De...[K] de acuerdo.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Finally...)", french="(Enfin...)", german="(Es ist so weit...)", italian="(Alla fine...)", spanish="(Al fin...)"})
  else
  SkySceneKit.say({english="(Finally...)", french="(Enfin...)", german="(Es ist so weit...)", italian="(Alla fine...)", spanish="(Al fin...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The time has finally arrived...)", french="(Le moment est venu...)", german="(Die Zeit ist letztendlich gekommen...)", italian="(Alla fine è arrivato il momento...)", spanish="(Ha llegado la hora.)"})
  else
  SkySceneKit.say({english="(The time has finally arrived...)", french="(Le moment est venu...)", german="(Die Zeit ist letztendlich gekommen...)", italian="(Alla fine è arrivato il momento...)", spanish="(Ha llegado la hora.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(My time with [partner]...[K]ends now.)", french="(Mon association avec [partner]...[K] touche\nà sa fin.)", german="(Meine Zeit mit [partner]...[K] endet hier.)", italian="(Il tempo a mia disposizione per stare con\n[partner]...[K] sta per finire.)", spanish="(Mis aventuras con [partner]...[K] terminan\naquí.)"})
  else
  SkySceneKit.say({english="(My time with [partner]...[K]ends now.)", french="(Mon association avec [partner]...[K] touche\nà sa fin.)", german="(Meine Zeit mit [partner]...[K] endet hier.)", italian="(Il tempo a mia disposizione per stare con\n[partner]...[K] sta per finire.)", spanish="(Mis aventuras con [partner]...[K] terminan\naquí.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey![K] [hero].", french=" Eh![K] [hero].", german=" Hey![K] [hero].", italian=" Ehi![K] [hero].", spanish=" ¡Eh![K] [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey![K] [hero].", french=" Eh![K] [hero].", german=" Hey![K] [hero].", italian=" Ehi![K] [hero].", spanish=" ¡Eh![K] [hero]."})
  else
  SkySceneKit.say({english=" Hey![K] [hero].", french=" Eh![K] [hero].", german=" Hey![K] [hero].", italian=" Ehi![K] [hero].", spanish=" ¡Eh![K] [hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Left)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-88), p.Y+(-24), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?[K] [hero]...", french=" Hein?[K] [hero]...", german=" Ähem?[K] [hero]...", italian=" Eh?[K] [hero]...", spanish=" ¿Cómo?[K] [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh?[K] [hero]...", french=" Hein?[K] [hero]...", german=" Ähem?[K] [hero]...", italian=" Eh?[K] [hero]...", spanish=" ¿Cómo?[K] [hero]."})
  else
  SkySceneKit.say({english=" Huh?[K] [hero]...", french=" Hein?[K] [hero]...", german=" Ähem?[K] [hero]...", italian=" Eh?[K] [hero]...", spanish=" ¿Cómo?[K] [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What is it?[K] What's happening to\nyou...?", french="Il y a un problème?[K] Qu'est-ce\nqui t'arrive...?", german="Was ist los?[K] Was geschieht mit\ndir?", italian="Cosa c'è?[K] Cosa ti succede...?", spanish="¿Qué pasa?[K] ¿Qué te está\nocurriendo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What is it?[K] What's wrong with\nyou...?", french="Il y a un problème?[K] Qu'est-ce\nqui t'arrive...?", german="Was ist los?[K] Was stimmt mit\ndir nicht?", italian="Cosa c'è?[K] Cos'hai che non\nva...?", spanish="¿Qué pasa?[K] ¿Qué te está\nocurriendo?"})
  else
  SkySceneKit.say({english="What is it?[K] What's happening to\nyou...?", french="Il y a un problème?[K] Qu'est-ce\nqui t'arrive...?", german="Was ist los?[K] Was geschieht mit\ndir?", italian="Cosa c'è?[K] Cosa ti succede...?", spanish="¿Qué pasa?[K] ¿Qué te está\nocurriendo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="...Sorry, [partner].[K] I kept this to myself\nfor a long time...", french="... Désolé, [partner].[K] J'ai gardé ça pour\nmoi pendant longtemps...", german="Es tut mir leid, [partner].[K] Ich habe es so\nlange für mich behalten...", italian="Perdonami, [partner].[K] Me lo sono tenuto\nper me per lungo tempo...", spanish="Lo siento, [partner].[K] Te lo he ocultado\ndurante mucho tiempo."})
  else
  SkySceneKit.say({english="...Sorry, [partner].[K] I kept this to myself\nfor a long time...", french="... Désolée, [partner].[K] J'ai gardé ça pour\nmoi pendant longtemps...", german="Es tut mir leid, [partner].[K] Ich habe es so\nlange für mich behalten...", italian="Perdonami, [partner].[K] Me lo sono tenuto\nper me per lungo tempo...", spanish="Lo siento, [partner].[K] Te lo he ocultado\ndurante mucho tiempo."})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="It looks like...[K]I have to say good-bye...", french="On dirait...[K] que le moment est venu de se dire\nadieu...", german="Wie es aussieht,[K] muss ich Lebewohl sagen...", italian="Pare proprio che...[K] io ti debba dire addio...", spanish="Parece que...[K] tengo que despedirme."})
  else
  SkySceneKit.say({english="It looks like...[K]I have to say good-bye...", french="On dirait...[K] que le moment est venu de se dire\nadieu...", german="Wie es aussieht,[K] muss ich Lebewohl sagen...", italian="Pare proprio che...[K] io ti debba dire addio...", spanish="Parece que...[K] tengo que despedirme."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?![K] Good-bye?!", french=" Hein?![K] Adieu?!", german=" Wie bitte?[K] Lebewohl?!?", italian=" Eh?![K] Addio?!", spanish=" ¡¿Qué?![K] ¡¿Despedirte?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?![K] Good-bye?!", french=" Hein?![K] Adieu?!", german=" Wie bitte?[K] Lebewohl?!?", italian=" Cosa?![K] Addio?!", spanish=" ¡¿Qué?![K] ¡¿Despedirte?!"})
  else
  SkySceneKit.say({english=" What?![K] Good-bye?!", french=" Hein?![K] Adieu?!", german=" Wie bitte?[K] Lebewohl?!?", italian=" Cosa?![K] Addio?!", spanish=" ¡¿Qué?![K] ¡¿Despedirte?!"})
  end
  -- message_KeyWait
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-16), p.Y+(-8), false, 2) end -- Slide2PositionOffset
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What are you saying?!", french=" Mais qu'est-ce que tu racontes?!", german=" Was willst du damit sagen?", italian=" Che cosa stai dicendo?!", spanish=" ¡¿Qué quieres decir?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What do you mean?!", french=" Mais qu'est-ce que tu racontes?!", german=" Was meinst du damit?", italian=" Cosa intendi dire?!", spanish=" ¡¿Qué quieres decir?!"})
  else
  SkySceneKit.say({english=" What are you saying?!", french=" Mais qu'est-ce que tu racontes?!", german=" Was willst du damit sagen?", italian=" Che cosa stai dicendo?!", spanish=" ¡¿Qué quieres decir?!"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[CS:N]Dusknoir[CR] told me.", french="[CS:N]Noctunoir[CR] m'avait prévenu.", german="[CS:N]Zwirrfinst[CR] sagte mir das.", italian="Me l'ha detto [CS:N]Dusknoir[CR].", spanish="[CS:N]Dusknoir[CR] me lo dijo."})
  else
  SkySceneKit.say({english="[CS:N]Dusknoir[CR] told me.", french="[CS:N]Noctunoir[CR] m'avait prévenue.", german="[CS:N]Zwirrfinst[CR] sagte mir das.", italian="Me l'ha detto [CS:N]Dusknoir[CR].", spanish="[CS:N]Dusknoir[CR] me lo dijo."})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="If we changed the future, the Pokémon from\nthe future would disappear...", french="Modifier le cours de l'histoire implique\nla disparition des Pokémon du futur...", german="Wenn wir die Zukunft verändern würden,\nverschwänden alle Pokémon aus der\nZukunft...", italian="Qualora avessimo cambiato la storia, i\nPokémon provenienti dal futuro sarebbero\nscomparsi...", spanish="Si interferíamos en la historia, los Pokémon\ndel futuro desaparecerían."})
  else
  SkySceneKit.say({english="If we changed the future, the Pokémon from\nthe future would disappear...", french="Modifier le cours de l'histoire implique\nla disparition des Pokémon du futur...", german="Wenn wir die Zukunft verändern würden,\nverschwänden alle Pokémon aus der\nZukunft...", italian="Qualora avessimo cambiato la storia, i\nPokémon provenienti dal futuro sarebbero\nscomparsi...", spanish="Si interferíamos en la historia, los Pokémon\ndel futuro desaparecerían."})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="That's why...[K]I'm destined to disappear too.", french="C'est pourquoi...[K] je suis voué à disparaître.", german="Deswegen[K] bin auch ich zum Verschwinden\nverurteilt.", italian="È per questo che...[K] anch'io sono destinato a\nscomparire.", spanish="Por eso...[K] mi destino también es desaparecer."})
  else
  SkySceneKit.say({english="That's why...[K]I'm destined to disappear too.", french="C'est pourquoi...[K] je suis vouée à disparaître.", german="Deswegen[K] bin auch ich zum Verschwinden\nverurteilt.", italian="È per questo che...[K] anch'io sono destinata a\nscomparire.", spanish="Por eso...[K] mi destino también es desaparecer."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?[K] What?[K] Wh-why?", french=" Hein?[K] Quoi?[K] Mais pourquoi?", german=" Äh?[K] Was?[K] W-warum?", italian=" Eh?[K] Cosa?[K] P-Perché?", spanish=" ¿Eh?[K] ¿Qué?[K] ¿Pero por qué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh?[K] What?[K] Wh-why?", french=" Hein?[K] Quoi?[K] Mais pourquoi?", german=" Äh?[K] Was?[K] W-warum?", italian=" Eh?[K] Cosa?[K] P-Perché?", spanish=" ¿Eh?[K] ¿Qué?[K] ¿Pero por qué?"})
  else
  SkySceneKit.say({english=" Huh?[K] What?[K] Wh-why?", french=" Hein?[K] Quoi?[K] Mais pourquoi?", german=" Äh?[K] Was?[K] W-warum?", italian=" Eh?[K] Cosa?[K] P-Perché?", spanish=" ¿Eh?[K] ¿Qué?[K] ¿Pero por qué?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-why...?[K] I don't understand!", french="Pourquoi...?[K] Je ne comprends\npas!", german="W-warum?[K] Ich verstehe das\nnicht!", italian=" P-Perché...?[K] Non capisco!", spanish=" ¿Por qué...?[K] ¡No lo entiendo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-why...?[K] I don't understand!", french="Pourquoi...?[K] Je ne comprends\npas!", german="W-warum?[K] Ich verstehe das\nnicht!", italian=" P-Perché...?[K] Non capisco!", spanish=" ¿Por qué...?[K] ¡No lo entiendo!"})
  else
  SkySceneKit.say({english=" Wh-why...?[K] I don't understand!", french="Pourquoi...?[K] Je ne comprends\npas!", german="W-warum?[K] Ich verstehe das\nnicht!", italian=" P-Perché...?[K] Non capisco!", spanish=" ¿Por qué...?[K] ¡No lo entiendo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="Thank you for everything.", french="Merci pour tout.", german="Danke für alles.", italian="Grazie di tutto.", spanish="Gracias por todo."})
  else
  SkySceneKit.say({english="Thank you for everything.", french="Merci pour tout.", german="Danke für alles.", italian="Grazie di tutto.", spanish="Gracias por todo."})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="I'm going to disappear from here now...", french="Je vais disparaître maintenant...", german="Ich werde jetzt von hier verschwinden...", italian="Presto scomparirò...", spanish="Creo que ya queda poco..."})
  else
  SkySceneKit.say({english="I'm going to disappear from here now...", french="Je vais disparaître maintenant...", german="Ich werde jetzt von hier verschwinden...", italian="Presto scomparirò...", spanish="Creo que ya queda poco..."})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="But, [partner]...[K] I'll never forget you.", french="Mais, [partner]...[K] Sache que jamais\nje ne t'oublierai.", german="Aber [partner]...[K] Ich werde dich niemals\nvergessen.", italian="Ma non ti dimenticherò mai...[K] [partner].", spanish="[partner]...[K] Nunca te olvidaré."})
  else
  SkySceneKit.say({english="But, [partner]...[K] I'll never forget you.", french="Mais, [partner]...[K] Sache que jamais\nje ne t'oublierai.", german="Aber [partner]...[K] Ich werde dich niemals\nvergessen.", italian="Ma non ti dimenticherò mai...[K] [partner].", spanish="[partner]...[K] Nunca te olvidaré."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(768) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-24), p.Y+(0), false, 1) end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" W-wait a second...", french=" Attends... attends une seconde...", german=" E-einen Moment mal...", italian=" A-Aspetta un attimo...", spanish=" Es... espera..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" W-wait a second...", french=" Attends... attends une seconde...", german=" E-einen Moment mal...", italian=" A-Aspetta un attimo...", spanish=" Es... espera..."})
  else
  SkySceneKit.say({english=" W-wait a second...", french=" Attends... attends une seconde...", german=" E-einen Moment mal...", italian=" A-Aspetta un attimo...", spanish=" Es... espera..."})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I managed to make it all this\nway because you were with me, [hero].", french="Si je suis arrivé jusqu'ici,\nc'est parce que tu étais avec moi,\n[hero].", german="Ich bin überhaupt nur so weit\ngekommen, weil du bei mir warst,\n[hero].", italian="Sono riuscito a fare tutto questo\nsolo perché eri con me, [hero].", spanish="He podido llegar hasta aquí\nporque estabas conmigo, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I only made it this far because\nyou were with me, [hero].", french="Si je suis arrivé jusqu'ici,\nc'est parce que tu étais avec moi,\n[hero].", german="Ich habe es nur so weit\ngebracht, weil du bei mir warst,\n[hero].", italian="Ce l'ho fatta solo perché c'eri tu\ncon me, [hero].", spanish="He podido llegar hasta aquí\nporque estabas conmigo, [hero]."})
  else
  SkySceneKit.say({english="I managed to make it this far\nonly because you were with me, [hero].", french="Si je suis arrivée jusqu'ici,\nc'est parce que tu étais avec moi,\n[hero].", german="Ich bin überhaupt nur so weit\ngekommen, weil du bei mir warst,\n[hero].", italian="Sono riuscita a fare tutto questo\nsolo perché eri con me, [hero].", spanish="He podido llegar hasta aquí\nporque estabas conmigo, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Don't you understand...?[K]\nYou made me strong, [hero]...", french="Tu ne comprends pas...?[K]\nC'est toi qui m'as donné le courage d'accomplir\ntout ça, [hero]...", german="Verstehst du das nicht?[K]\nDu hast mich stark gemacht, [hero]...", italian="Non capisci...?[K] Tu mi hai reso\nforte, [hero]...", spanish="¿No lo entiendes...?[K] Tú me has\ndado fuerzas, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Don't you understand...?[K]\nYou made me strong, [hero]...", french="Tu ne comprends pas...?[K]\nC'est toi qui m'as donné le courage d'accomplir\ntout ça, [hero]...", german="Verstehst du das nicht?[K]\nDu hast mich stark gemacht, [hero]...", italian="Non capisci...?[K] Tu mi hai reso\nforte, [hero]...", spanish="¿No lo entiendes...?[K] Tú me has\ndado fuerzas, [hero]."})
  else
  SkySceneKit.say({english="Don't you understand...?[K]\nYou made me strong, [hero]...", french="Tu ne comprends pas...?[K]\nC'est toi qui m'as donné le courage d'accomplir\ntout ça, [hero]...", german="Verstehst du das nicht?[K]\nDu hast mich stark gemacht, [hero]...", italian="Non capisci...?[K] Tu mi hai reso\nforte, [hero]...", spanish="¿No lo entiendes...?[K] Tú me has\ndado fuerzas, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" If you go, [hero]...[K] I...", french="Si tu t'en vas, [hero]...[K]\nje...", german="Wenn du gehst, [hero]...[K]\nDann...", italian="Se te ne andrai, [hero]...[K]\nio...", spanish=" Si te vas, [hero]...[K] yo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" If you go, [hero]...[K] I...", french="Si tu t'en vas, [hero]...[K]\nje...", german="Wenn du gehst, [hero]...[K]\nDann...", italian="Se te ne andrai, [hero]...[K]\nio...", spanish=" Si te vas, [hero]...[K] yo..."})
  else
  SkySceneKit.say({english=" If you go, [hero]...[K] I...", french="Si tu t'en vas, [hero]...[K]\nje...", german="Wenn du gehst, [hero]...[K]\nDann...", italian="Se te ne andrai, [hero]...[K]\nio...", spanish=" Si te vas, [hero]...[K] yo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I don't know...[K]what I would...", french="Je ne sais pas...[K]\nce que je ferai...", german=" Ich weiß nicht,[K] was ich dann...", italian=" Non so...[K] come farò...", spanish=" No sé...[K] lo que..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I don't know...[K]what I would...", french="Je ne sais pas...[K]\nce que je ferai...", german=" Ich weiß nicht,[K] was ich dann...", italian=" Non so...[K] come farò...", spanish=" No sé...[K] lo que..."})
  else
  SkySceneKit.say({english=" I don't know...[K]what I would...", french="Je ne sais pas...[K]\nce que je ferai...", german=" Ich weiß nicht,[K] was ich dann...", italian=" Non so...[K] come farò...", spanish=" No sé...[K] lo que..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="No, [partner].[K] You have to be strong on\nyour own. You have to live!", french="Non, [partner].[K] Il faut que tu tiennes bon\net que tu continues à vivre!", german="Nein, [partner].[K] Du musst selbst stark sein.\nDu musst leben!", italian="No, [partner].[K] Devi riuscire a essere\nforte anche senza di me. Devi sopravvivere!", spanish="No, [partner].[K] Tienes que ser fuerte\nsin mí. ¡Tienes que seguir adelante!"})
  else
  SkySceneKit.say({english="No, [partner].[K] You have to be strong on\nyour own. You have to live!", french="Non, [partner].[K] Il faut que tu tiennes bon\net que tu continues à vivre!", german="Nein, [partner].[K] Du musst selbst stark sein.\nDu musst leben!", italian="No, [partner].[K] Devi riuscire a essere\nforte anche senza di me. Devi sopravvivere!", spanish="No, [partner].[K] Tienes que ser fuerte\nsin mí. ¡Tienes que seguir adelante!"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="You have to go home...", french="Rentre chez nous...", german="Du musst nach Hause gehen.", italian="Devi tornare a casa...", spanish="Tienes que volver a casa."})
  else
  SkySceneKit.say({english="You have to go home...", french="Rentre chez nous...", german="Du musst nach Hause gehen.", italian="Devi tornare a casa...", spanish="Tienes que volver a casa."})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="Tell everyone about what happened here.", french="Raconte à tout le monde ce qui s'est passé ici.", german="Erzähle allen von dem, was hier passiert ist.", italian="Raccontare a tutti quello che è successo qui.", spanish="Cuéntales a todos lo que ocurrió aquí."})
  else
  SkySceneKit.say({english="Tell everyone about what happened here.", french="Raconte à tout le monde ce qui s'est passé ici.", german="Erzähle allen von dem, was hier passiert ist.", italian="Raccontare a tutti quello che è successo qui.", spanish="Cuéntales a todos lo que ocurrió aquí."})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="So that...[K]nothing like this happens ever again.", french="Pour que...[K] plus jamais une telle chose\nne se reproduise.", german="Damit...[K] Damit so etwas wie das hier niemals\nwieder geschieht.", italian="In modo che...[K] non succeda mai più nulla del\ngenere.", spanish="Para que algo así...[K] no vuelva a ocurrir nunca."})
  else
  SkySceneKit.say({english="So that...[K]nothing like this happens ever again.", french="Pour que...[K] plus jamais une telle chose\nne se reproduise.", german="Damit...[K] Damit so etwas wie das hier niemals\nwieder geschieht.", italian="In modo che...[K] non succeda mai più nulla del\ngenere.", spanish="Para que algo así...[K] no vuelva a ocurrir nunca."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk...[K] [hero]...", french=" Argh...[K] [hero]...", german=" Oh...[K] [hero]...", italian=" Uh...[K] [hero]...", spanish=" Ay...[K] [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk...[K] [hero]...", french=" Argh...[K] [hero]...", german=" Oh...[K] [hero]...", italian=" Uh...[K] [hero]...", spanish=" Ay...[K] [hero]..."})
  else
  SkySceneKit.say({english=" Urk...[K] [hero]...", french=" Argh...[K] [hero]...", german=" Oh...[K] [hero]...", italian=" Uh...[K] [hero]...", spanish=" Ay...[K] [hero]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8454) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(3) [anim idle native]
  GAME:WaitFrames(95)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...![K] The light...)", french="(...! La lumière...)", german="(...[K]Das Licht!...)", italian="(...![K] La luce...)", spanish="(Aquí está...[K] La luz...)"})
  else
  SkySceneKit.say({english="(...![K] The light...)", french="(...! La lumière...)", german="(...[K]Das Licht!...)", italian="(...![K] La luce...)", spanish="(Aquí está...[K] La luz...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The light is getting brighter...)", french="(La lumière devient plus vive...)", german="(Das Licht wird heller...)", italian="(La luce è sempre più forte...)", spanish="(La luz se vuelve más intensa.)"})
  else
  SkySceneKit.say({english="(The light is getting brighter...)", french="(La lumière devient plus vive...)", german="(Das Licht wird heller...)", italian="(La luce è sempre più forte...)", spanish="(La luz se vuelve más intensa.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Don't, [hero]!", french=" Non, [hero]!", german=" Nicht, [hero]!", italian=" No, [hero]!", spanish=" [hero], ¡no!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Don't, [hero]!", french=" Non, [hero]!", german=" Nicht, [hero]!", italian=" No, [hero]!", spanish=" [hero], ¡no!"})
  else
  SkySceneKit.say({english=" Don't, [hero]!", french=" Non, [hero]!", german=" Nicht, [hero]!", italian=" No, [hero]!", spanish=" [hero], ¡no!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Don't...[K] Don't go...", french=" Non...[K] Ne pars pas...", german=" Geh nicht...[K] Geh nicht...", italian=" No...[K] Resta con me...", spanish=" No...[K] No te vayas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Don't...[K] Don't go...", french=" Non...[K] Ne pars pas...", german=" Geh nicht...[K] Geh nicht...", italian=" No...[K] Resta con me...", spanish=" No...[K] No te vayas."})
  else
  SkySceneKit.say({english=" Don't...[K] Don't go...", french=" Non...[K] Ne pars pas...", german=" Geh nicht...[K] Geh nicht...", italian=" No...[K] Resta con me...", spanish=" No...[K] No te vayas."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="Thank you for everything, [partner].", french="Merci pour tout, [partner].", german="Vielen Dank für alles, [partner].", italian="Grazie di tutto, [partner].", spanish="Gracias por todo, [partner]."})
  else
  SkySceneKit.say({english="Thank you for everything, [partner].", french="Merci pour tout, [partner].", german="Vielen Dank für alles, [partner].", italian="Grazie di tutto, [partner].", spanish="Gracias por todo, [partner]."})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="I'm glad we got to train together at the guild...", french="Je suis content qu'on ait fait équipe\nà la Guilde...", german="Ich bin froh, dass wir in der Gilde zusammen\ntrainieren konnten.", italian="Sono felice di essermi allenato con te alla\nGilda...", spanish="Me alegro de haberme entrenado contigo\nen el [CS:N]Pokégremio[CR]."})
  else
  SkySceneKit.say({english="I'm glad we got to train together at the guild...", french="Je suis contente qu'on ait fait équipe\nà la Guilde...", german="Ich bin froh, dass wir in der Gilde zusammen\ntrainieren konnten.", italian="Sono felice di essermi allenata con te alla\nGilda...", spanish="Me alegro de haberme entrenado contigo\nen el [CS:N]Pokégremio[CR]."})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="I'm glad we got to go on adventures together...", french="... et aussi qu'on ait partagé tant d'aventures\nensemble...", german="Ich bin froh, dass wir zusammen auf\nAbenteuer gehen konnten.", italian="È stato bello andare insieme all'avventura...", spanish="Me alegro de que hayamos compartido\ntodas estas aventuras."})
  else
  SkySceneKit.say({english="I'm glad we got to go on adventures together...", french="... et aussi qu'on ait partagé tant d'aventures\nensemble...", german="Ich bin froh, dass wir zusammen auf\nAbenteuer gehen konnten.", italian="È stato bello andare insieme all'avventura...", spanish="Me alegro de que hayamos compartido\ntodas estas aventuras."})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="I'm glad...[K]I got to know you, [partner].", french="Je suis heureux...[K] d'avoir eu la chance\nde te connaître, [partner].", german="Ich bin sehr froh,[K] dass ich dich kennenlernen\ndurfte, [partner].", italian="Sono felice...[K] Voglio che tu lo sappia,\n[partner].", spanish="Me alegro...[K] de haberte conocido, [partner]."})
  else
  SkySceneKit.say({english="I'm glad...[K]I got to know you, [partner].", french="Je suis heureuse...[K] d'avoir eu la chance\nde te connaître, [partner].", german="Ich bin sehr froh,[K] dass ich dich kennenlernen\ndurfte, [partner].", italian="Sono felice...[K] Voglio che tu lo sappia,\n[partner].", spanish="Me alegro...[K] de haberte conocido, [partner]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wait...[hero]...", french=" Attends... [hero]...", german=" Warte... [hero]...", italian=" Aspetta... [hero]...", spanish=" Espera... [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wait...[hero]...", french=" Attends... [hero]...", german=" Warte... [hero]...", italian=" Aspetta... [hero]...", spanish=" Espera... [hero]..."})
  else
  SkySceneKit.say({english=" Please, wait...[hero]...", french=" Attends... [hero]...", german=" Bitte warte... [hero]...", italian="Ti prego, aspetta...\n[hero]...", spanish=" Espera... [hero]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="I'm sorry.", french="Je suis désolé.", german="Es tut mir leid.", italian="Mi dispiace.", spanish="Lo siento."})
  else
  SkySceneKit.say({english="I'm sorry.", french="Je suis désolée.", german="Es tut mir leid.", italian="Mi dispiace.", spanish="Lo siento."})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="I'm so lucky that you were my friend...", french="J'ai tellement de chance d'avoir pu être\nton ami...", german="Ich hatte solches Glück, jemanden wie dich zu\nfinden...", italian="Sono stato davvero fortunato a incontrarti...", spanish="Ha sido una suerte haber sido amigo tuyo."})
  else
  SkySceneKit.say({english="I'm so lucky that you were my friend...", french="J'ai tellement de chance d'avoir pu être\nton amie...", german="Ich hatte solches Glück, jemanden wie dich zu\nfinden...", italian="Sono stata davvero fortunata a incontrarti...", spanish="Ha sido una suerte haber sido amiga tuya."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I feel the same, [hero]!\nTo me, [hero], you're...", french="Moi aussi, je ressens la même\nchose, [hero]! Pour moi, [hero],\ntu...", german="Ich empfinde dasselbe,\n[hero]! Für mich bist du,\n[hero]...", italian="Anch'io, [hero]! Per me,\n[hero], tu sei...", spanish="¡Yo siento lo mismo,\n[hero]! Para mí, eres..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I feel the same, [hero]!\nTo me, [hero], you're...", french="Moi aussi, je ressens la même\nchose, [hero]! Pour moi, [hero],\ntu...", german="Ich empfinde dasselbe,\n[hero]! Für mich bist du,\n[hero]...", italian="Anch'io, [hero]! Per me,\n[hero], tu sei...", spanish="¡Yo siento lo mismo,\n[hero]! Para mí, eres..."})
  else
  SkySceneKit.say({english="I feel the same, [hero]!\nTo me, [hero], you're...", french="Moi aussi, je ressens la même\nchose, [hero]! Pour moi, [hero],\ntu...", german="Ich empfinde dasselbe,\n[hero]! Für mich bist du,\n[hero]...", italian="Anch'io, [hero]! Per me,\n[hero], tu sei...", spanish="¡Yo siento lo mismo,\n[hero]! Para mí, eres..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" More important than anything...", french="... comptes plus que tout\nau monde...", german="Du bist wichtiger als alles\nandere...", italian="... più importante di ogni altra\ncosa...", spanish=" Lo más importante del mundo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" More important than anything...", french="... comptes plus que tout\nau monde...", german="Du bist wichtiger als alles\nandere...", italian="... più importante di ogni altra\ncosa...", spanish=" Lo más importante del mundo..."})
  else
  SkySceneKit.say({english=" More important than anything...", french="... comptes plus que tout\nau monde...", german="Du bist wichtiger als alles\nandere...", italian="... più importante di ogni altra\ncosa...", spanish=" Lo más importante del mundo..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="Yes...[K]I feel the same way.", french="Oui...[K] pour moi aussi.", german="Ja...[K] Ich fühle auch so.", italian="Sì...[K] Anche per me è così.", spanish="Sí...[K] Yo siento lo mismo."})
  else
  SkySceneKit.say({english="Yes...[K]I feel the same way.", french="Oui...[K] pour moi aussi.", german="Ja...[K] Ich fühle auch so.", italian="Sì...[K] Anche per me è così.", spanish="Sí...[K] Yo siento lo mismo."})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[partner]...", french="[partner]...", german="[partner]...", italian="[partner]...", spanish="[partner]..."})
  else
  SkySceneKit.say({english="[partner]...", french="[partner]...", german="[partner]...", italian="[partner]...", spanish="[partner]..."})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="Even after I disappear from here...[K] I will\nnever forget you...", french="Même après avoir disparu...[K] je ne t'oublierai\njamais...", german="Sogar wenn ich von hier verschwunden bin...[K]\nIch werde dich niemals vergessen...", italian="Anche se non sarò più qui...[K] non ti\ndimenticherò mai...", spanish="No te olvidaré...[K] nunca..."})
  else
  SkySceneKit.say({english="Even after I disappear from here...[K] I will\nnever forget you...", french="Même après avoir disparu...[K] je ne t'oublierai\njamais...", german="Sogar wenn ich von hier verschwunden bin...[K]\nIch werde dich niemals vergessen...", italian="Anche se non sarò più qui...[K] non ti\ndimenticherò mai...", spanish="No te olvidaré...[K] nunca..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8459) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(3)
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  GAME:WaitFrames(2)
  -- supervision_Acting(4) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(3)
  -- SetAnimation(4) [anim idle native]
  -- SetOutputAttribute(64) [neutre/état moteur]
  GAME:WaitFrames(90) -- back_SetEffect(12, 90) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  GAME:WaitFrames(90)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  -- SetAnimation(3) [anim idle native]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(25)
  -- SetAnimation(2) [anim idle native]
  -- supervision_RemoveActing(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-24), p.Y+(0), false, 2) end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[hero]...[W:45][hero]!", french=" ... [hero]...[W:45] [hero]!", german=" ...[hero]...[W:45] [hero]!", italian=" [hero]...[W:45] [hero]!", spanish=" [hero]...[W:45] ¡[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[hero]...[W:45][hero]!", french=" ... [hero]...[W:45] [hero]!", german=" ...[hero]...[W:45] [hero]!", italian=" [hero]...[W:45] [hero]!", spanish=" [hero]...[W:45] ¡[hero]!"})
  else
  SkySceneKit.say({english=" ...[hero]...[W:45][hero]!", french=" ... [hero]...[W:45] [hero]!", german=" ...[hero]...[W:45] [hero]!", italian=" [hero]...[W:45] [hero]!", spanish=" [hero]...[W:45] ¡[hero]!"})
  end
  GROUND:EntTurn(partner, Direction.Up)
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(15)
  GROUND:EntTurn(partner, Direction.DownLeft)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(15)
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(45)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  -- SetAnimation(81) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[hero]!!", french=" ... [hero]!!", german=" ...[hero]!!!", italian=" ... [hero]!!", spanish=" ¡[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[hero]!!", french=" ... [hero]!!", german=" ...[hero]!!!", italian=" ... [hero]!!", spanish=" ¡[hero]!"})
  else
  SkySceneKit.say({english=" ...[hero]!!", french=" ... [hero]!!", german=" ...[hero]!!!", italian=" ... [hero]!!", spanish=" ¡[hero]!"})
  end
  -- message_Close
  GAME:WaitFrames(30)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(false, 120)
  GAME:WaitFrames(180)
  -- GAP: BGM BGM_HAVE_TO_GET_HOME non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(90)
end
