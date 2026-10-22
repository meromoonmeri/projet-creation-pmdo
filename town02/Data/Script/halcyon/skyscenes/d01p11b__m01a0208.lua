-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11B/m01a0208.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM BGM_ON_THE_BEACH_AT_DUSK non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V01P03B) [décor sub chargé: Sub_v01p03b]
  -- back_SetGround(LEVEL_D01P11B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 33, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(76) [anim idle native]
  -- supervision_SpecialActing(21, 600, 0) [cadrage NDS]
  -- supervision2_SpecialActing(21, 600, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  SkySubScreen.Show("v01p03b", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ............", french=" ............", german=" ............", italian=" ............", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ............", french=" ............", german=" ............", italian=" ............", spanish=" ..."})
  else
  SkySceneKit.say({english=" ............", french=" ............", german=" ............", italian=" ............", spanish=" ..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This is where I always end up\nwhen I'm feeling sorry for myself.", french="C'est ici que je viens quand\nje m'apitoie sur mon sort.", german="Hier komme ich immer her,\nwenn ich mich elend fühle.", italian="Vengo sempre qui quando\nmi sento giù.", spanish="Siempre acabo viniendo a este\nlugar cuando siento lástima de mí mismo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This is where I always come\nwhen I'm feeling sorry for myself.", french="C'est ici que je viens quand\nje m'apitoie sur mon sort.", german="Hier komme ich immer her,\nwenn ich mich elend fühle.", italian="Vengo sempre qui quando\nmi sento giù.", spanish="Siempre acabo viniendo a este\nlugar cuando siento lástima de mí mismo."})
  else
  SkySceneKit.say({english="This is where I always come\nwhen I'm feeling down on myself.", french="C'est ici que je viens quand\nje m'apitoie sur mon sort.", german="Hier komme ich immer her,\nwenn ich deprimiert bin.", italian="Vengo sempre qui quando\nmi sento giù.", spanish="Siempre acabo viniendo a\neste lugar cuando me siento abatida."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But it makes me feel good to be\nhere, like always.", french="Je me sens mieux quand je suis\nsur cette plage.", german="Immer, wenn ich hier bin, fühle\nich mich wieder gut.", italian=" Di solito mi fa sentire meglio.", spanish="Pero una vez aquí me siento\nbien, como siempre."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But it makes me feel good to be\nhere, like always.", french="Je me sens mieux quand je suis\nsur cette plage.", german="Immer, wenn ich hier bin, fühle\nich mich wieder gut.", italian=" Di solito mi fa sentire meglio.", spanish="Pero una vez aquí me siento\nbien, como siempre."})
  else
  SkySceneKit.say({english="But it makes me feel good to be\nhere, like always.", french="Je me sens mieux quand je suis\nsur cette plage.", german="Immer, wenn ich hier bin, fühle\nich mich wieder gut.", italian=" Di solito mi fa sentire meglio.", spanish="Pero una vez aquí me siento\nbien, como siempre."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Coming here cheers me up.", french="Cet endroit me remonte\nle moral.", german="Dieser Ort bessert meine Laune\nungemein.", italian=" Questo posto riesce a tirarmi su.", spanish=" Venir aquí me sube la moral."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Coming here is uplifting. It\ncheers me up.", french="Cet endroit me remonte\nle moral.", german="Dieser Ort heitert mich auf. Ich\nbin schon besser gelaunt.", italian="Venire qui mi tira su. Dopo mi\nsento sempre meglio.", spanish="Venir aquí me anima. Este sitio\nme reconforta."})
  else
  SkySceneKit.say({english=" Coming here heals my spirits.", french="Cet endroit me remonte\nle moral.", german="Dieser Ort ist Balsam für\nmeine Seele.", italian="Venire qui è un toccasana per\nlo spirito.", spanish=" Venir aquí me anima."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(60)
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey...[K]what's that?[K] What's going\non over there?", french="Hé...[K] Qu'est-ce que c'est?[K]\nQue se passe-t-il là-bas?", german="Hey...[K] Was ist das?[K] Was ist\ndenn da drüben los?", italian="Ehi...[K] Ma cos'è?[K] Cosa sta\nsuccedendo laggiù?", spanish="Eh...[K] ¿Qué es eso?[K] Parece que\nhay algo en la arena..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hey...[K]what's that?[K] What's going\non over there?", french="Hé...[K] Qu'est-ce que c'est?[K]\nQue se passe-t-il là-bas?", german="Hey...[K] Was ist das?[K] Was ist\ndenn da drüben los?", italian="Ehi...[K] Ma cos'è?[K] Cosa sta\nsuccedendo laggiù?", spanish="Eh...[K] ¿Qué es eso?[K] Parece que\nhay algo en la arena..."})
  else
  SkySceneKit.say({english="Hey...[K]what's that?[K] What's going\non over there?", french="Hé...[K] Qu'est-ce que c'est?[K]\nQue se passe-t-il là-bas?", german="Hey...[K] Was ist das?[K] Was ist\ndenn da drüben los?", italian="Ehi...[K] Ma cos'è?[K] Cosa sta\nsuccedendo laggiù?", spanish="Eh...[K] ¿Qué es eso?[K] Parece que\nhay algo en la arena..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(416, 176, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 416, 172, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Waah![K] Someone has collapsed on\nthe sand!", french="Aaah![K] Quelqu'un vient de\ns'effondrer sur le sable!", german="Waah![K] Da ist jemand im Sand\nzusammengebrochen!", italian="Waah![K] Qualcuno è svenuto sulla\nsabbia!", spanish=" ¡Aaah![K] ¡Alguien se ha desmayado!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Waah![K] Someone has collapsed on\nthe sand!", french="Aaah![K] Quelqu'un vient de\ns'effondrer sur le sable!", german="Waah![K] Da ist jemand im Sand\nzusammengebrochen!", italian="Aaah![K] Qualcuno è svenuto sulla\nsabbia!", spanish=" ¡Aaah![K] ¡Alguien se ha desmayado!"})
  else
  SkySceneKit.say({english="Waah![K] Someone has collapsed on\nthe sand!", french="Aaah![K] Quelqu'un vient de\ns'effondrer sur le sable!", german="Waah![K] Da ist jemand im Sand\nzusammengebrochen!", italian="Aaah![K] Qualcuno è svenuto sulla\nsabbia!", spanish=" ¡Aaah![K] ¡Alguien se ha desmayado!"})
  end
  -- message_Close
  pcall(function() GAME:MoveCamera(308, 176, 60, false) end) -- performer/caméra
  -- SetAnimation(1024) [anim idle native]
  GROUND:MoveToPosition(partner, 312, 172, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(768) [anim idle native]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What happened?![K] Are you OK?", french=" Que s'est-il passé?![K] Ça va?", german=" Was ist passiert?!?[K] Alles okay?", italian=" Cos'è successo?![K] Stai bene?", spanish=" ¿Qué ha ocurrido?[K] ¿Estás bien?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What happened?![K] Are you OK?", french=" Que s'est-il passé?![K] Ça va?", german=" Was ist passiert?!?[K] Alles okay?", italian=" Cos'è successo?![K] Stai bene?", spanish=" ¿Qué ha ocurrido?[K] ¿Estás bien?"})
  else
  SkySceneKit.say({english=" What happened?![K] Are you OK?", french=" Que s'est-il passé?![K] Ça va?", german=" Was ist passiert?!?[K] Alles okay?", italian=" Cos'è successo?![K] Stai bene?", spanish=" ¿Qué ha ocurrido?[K] ¿Estás bien?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...Ugh...)", french="(... Aaah...)", german="(...Umpf...)", italian="(Ugh...)", spanish="(¡Uf!)"})
  else
  SkySceneKit.say({english="(...Ugh...)", french="(... Aaah...)", german="(...Umpf...)", italian="(Ugh...)", spanish="(¡Uf!)"})
  end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Great![K] You're awake!", french="Tu ouvres les yeux![K]\nQuel soulagement!", german=" Sehr gut![K] Du bist wach!", italian=" Meno male![K] Hai ripreso i sensi!", spanish="¡Estupendo![K] ¡Al fin te has\ndespertado!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You're awake![K] That's a relief!", french="Tu ouvres les yeux![K]\nQuel soulagement!", german="Oh, gut![K] Du kommst zu dir! Ich\nbin erleichtert!", italian=" Meno male![K] Hai ripreso i sensi!", spanish="¡Estupendo![K] ¡Al fin te has\ndespertado!"})
  else
  SkySceneKit.say({english=" You're awake![K] Thank goodness!", french="Tu ouvres les yeux![K]\nQuel soulagement!", german=" Du bist wach![K] Zum Glück!", italian=" Meno male![K] Hai ripreso i sensi!", spanish=" ¡Te has despertado![K] ¡Menos mal!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.spin(hero, 4, 1, 3)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(16), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  SkySceneKit.spin(hero, 4, 2, 5)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  SkySceneKit.spin(hero, 4, 1, 5)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  SkySceneKit.spin(hero, 4, 2, 4)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Where...where am I...?)", french="(Mais où... où suis-je...?)", german="(Wo... Wo bin ich?)", italian="(Dove... Dove mi trovo...?)", spanish="(¿Dónde...? ¿Dónde estoy?)"})
  else
  SkySceneKit.say({english="(Where...where am I...?)", french="(Mais où... où suis-je...?)", german="(Wo... Wo bin ich?)", italian="(Dove... Dove mi trovo...?)", spanish="(¿Dónde...? ¿Dónde estoy?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You weren't moving. You really\nhad me worried there!", french="Tu ne bougeais plus du tout.\nJ'étais vraiment inquiet pour toi!", german="Du hast dich kein bisschen\ngerührt. Ich habe mir schon Sorgen gemacht!", italian="Non sembravi affatto in forma!\nStavo iniziando a preoccuparmi!", spanish="No te movías. ¡Me tenías\nmuy preocupado!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You weren't moving at all. I was\nseriously worried!", french="Tu ne bougeais plus du tout.\nJ'étais vraiment inquiet pour toi!", german="Du lagst ganz reglos da. Ich habe\nmir wirklich Sorgen gemacht!", italian="Eri così immobile... Mi stavo\ndavvero preoccupando!", spanish="No te movías. ¡Estaba\nmuy preocupado!"})
  else
  SkySceneKit.say({english="You wouldn't move at all. I was\nreally scared for you!", french="Tu ne bougeais plus du tout.\nJ'étais vraiment inquiète pour toi!", german="Du lagst ganz reglos da. Ich\nhatte wirklich Angst um dich!", italian="Eri così immobile. Ero davvero\npreoccupata!", spanish="No te movías. ¡Estaba\nmuy preocupada!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="How did you wind up unconscious\nout here?", french="Tu te rappelles comment tu as\néchoué ici, sans connaissance?", german="Wie ist es dazu gekommen, dass\ndu hier ohnmächtig wurdest?", italian="Come hai fatto a finire qui\nin queste condizioni?", spanish="¿Cómo es que te has desmayado\naquí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Do you remember how you ended\nup unconscious out here?", french="Tu te rappelles comment tu as\néchoué ici, sans connaissance?", german="Erinnerst du dich, wie du hier\nohnmächtig geworden bist?", italian="Ricordi come hai fatto a finire\nqui in queste condizioni?", spanish="¿Qué te ha pasado?\n¿Por qué te has desmayado?"})
  else
  SkySceneKit.say({english="Do you have any idea how you\nended up unconscious out here?", french="Tu te rappelles comment tu as\néchoué ici, sans connaissance?", german="Hast du eine Ahnung, wie du hier\nohnmächtig geworden bist?", italian="Come hai fatto a finire qui\nin queste condizioni?", spanish="¿Qué te ha pasado?\n¿Por qué te has desmayado?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I... I was unconscious?[K] What happened...?)", french="(Je... j'ai perdu connaissance?[K] Mais qu'est-ce\nqui a pu se passer...?)", german="(Ich... Ich war ohnmächtig?[K]\nWas ist passiert?)", italian="(Avevo... Avevo perso conoscenza?[K]\nCosa è successo...?)", spanish="(Me... ¿Me he desmayado?[K]\n¿Qué ha ocurrido...?)"})
  else
  SkySceneKit.say({english="(I... I was unconscious?[K] What happened...?)", french="(Je... j'ai perdu connaissance?[K] Mais qu'est-ce\nqui a pu se passer...?)", german="(Ich... Ich war ohnmächtig?[K]\nWas ist passiert?)", italian="(Avevo... Avevo perso conoscenza?[K]\nCosa è successo...?)", spanish="(Me... ¿Me he desmayado?[K]\n¿Qué ha ocurrido...?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Anyway, I'm [partner].[K]\nGlad to meet you!", french="En tout cas, moi je m'appelle\n[partner].[K]\nRavi de faire ta connaissance!", german="Ich bin jedenfalls [partner].[K]\nFreut mich, dich kennenzulernen!", italian="Ad ogni modo, io sono\n[partner].[K] Piacere!", spanish="Bueno, yo soy [partner].[K]\n¡Encantado de conocerte!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well, I'm [partner].[K]\nGlad to meet you!", french="En tout cas, moi je m'appelle\n[partner].[K]\nRavi de faire ta connaissance!", german="Also, ich bin [partner].[K]\nFreut mich, dich kennenzulernen!", italian="Ad ogni modo, io sono\n[partner].[K] Piacere di conoscerti!", spanish="Yo soy [partner].[K]\n¡Encantado de conocerte!"})
  else
  SkySceneKit.say({english="Anyway, I'm [partner].[K]\nHappy to meet you!", french="En tout cas, moi je m'appelle\n[partner].[K]\nRavie de faire ta connaissance!", german="Ich bin jedenfalls [partner].[K]\nFreut mich sehr, dich kennenzulernen!", italian="Ad ogni modo, io sono\n[partner].[K] Piacere di conoscerti!", spanish="Bueno, yo soy [partner].[K]\n¡Encantada de conocerte!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So who might you be?", french=" Et toi, comment tu t'appelles?", german=" Und wer bist du?", italian=" E tu chi sei?", spanish=" ¿Y tú quién eres?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" And who are you?", french=" Et toi, comment tu t'appelles?", german=" Und wer bist du?", italian=" E tu chi sei?", spanish=" ¿Quién eres tú?"})
  else
  SkySceneKit.say({english=" And who are you?", french=" Et toi, comment tu t'appelles?", german=" Und wer bist du?", italian=" E tu chi sei?", spanish=" ¿Y tú?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I don't think I've seen your face\naround here.", french="Je crois que c'est la première\nfois que je te vois dans le coin!", german="Dein Gesicht kommt mir nicht\nbekannt vor.", italian=" Non mi sembra di conoscerti.", spanish=" Nunca te había visto por aquí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I've never seen you\naround before.", french="Je crois que c'est la première\nfois que je te vois dans le coin!", german="Ich habe dich hier noch nie\ngesehen.", italian=" Non mi sembra di conoscerti.", spanish="No me suena haberte visto\nnunca por aquí."})
  else
  SkySceneKit.say({english="I don't think I've seen you\naround before.", french="Je crois que c'est la première\nfois que je te vois dans le coin!", german="Ich glaube nicht, dass ich dich\nschon mal gesehen habe.", italian=" Non mi sembra di conoscerti.", spanish="No recuerdo haberte visto\npor aquí."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?[K] You say you're a human?", french="Quoi?[K] Tu dis que tu es\nun être humain?", german=" Häh?[K] Du bist ein Mensch?", italian="Cosa?[K] Tu saresti un essere\numano?", spanish="¿Qué?[K] ¿Dices que eres un\nser humano?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?[K] You say you're a human?", french="Quoi?[K] Tu dis que tu es\nun être humain?", german=" Was?[K] Du bist ein Mensch?", italian="Cosa?[K] Tu saresti un essere\numano?", spanish="¿Qué?[K] ¿Dices que eres un\nser humano?"})
  else
  SkySceneKit.say({english=" What?[K] You say you're a human?", french="Quoi?[K] Tu dis que tu es\nun être humain?", german=" Wie?[K] Du bist ein Mensch?", italian="Cosa?[K] Tu saresti un essere\numano?", spanish="¿Qué?[K] ¿Dices que eres un\nser humano?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You look like a totally normal\n[c_kind:PLAYER] to me!", french="Si tu veux mon avis, tu as l'air\nd'un [c_kind:PLAYER] tout à fait normal!", german="Du siehst für mich wie ein ganz\nnormales [c_kind:PLAYER] aus!", italian="A me sembri un normalissimo\n[c_kind:PLAYER]!", spanish="¡A mí me pareces un\n[c_kind:PLAYER] completamente normal!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You look like a totally normal\n[c_kind:PLAYER] to me!", french="Si tu veux mon avis, tu as l'air\nd'un [c_kind:PLAYER] tout à fait normal!", german="Du siehst für mich wie ein ganz\nnormales [c_kind:PLAYER] aus!", italian="A me sembri un normalissimo\n[c_kind:PLAYER]!", spanish="¡A mí me pareces un\n[c_kind:PLAYER] completamente normal!"})
  else
  SkySceneKit.say({english="You look like a totally normal\n[c_kind:PLAYER] to me!", french="Si tu veux mon avis, tu as l'air\nd'un [c_kind:PLAYER] tout à fait normal!", german="Du siehst für mich wie ein ganz\nnormales [c_kind:PLAYER] aus!", italian="A me sembri un normalissimo\n[c_kind:PLAYER]!", spanish="¡A mí me pareces un\n[c_kind:PLAYER] completamente normal!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.spin(hero, 4, 2, 4)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  SkySceneKit.spin(hero, 4, 1, 5)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  SkySceneKit.spin(hero, 4, 2, 5)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  SkySceneKit.spin(hero, 4, 1, 3)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's...it's true!)", french="(C'est... c'est vrai!)", german="(Es ist... Es ist wahr!)", italian="(È... È vero!)", spanish="(Es... ¡es cierto!)"})
  else
  SkySceneKit.say({english="(It's...it's true!)", french="(C'est... c'est vrai!)", german="(Es ist... Es ist wahr!)", italian="(È... È vero!)", spanish="(Es... ¡es cierto!)"})
  end
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_HERO_KIND"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_HERO_KIND, 0, 0) [ProcessSpecial(PROCESS_SPECIAL_GET_HERO_KIND): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 17 then
  -- @label_0 [étiquette de flux ExplorerScript]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I've turned into an [c_kind:PLAYER]!)", french="(Je me suis changé en [c_kind:PLAYER]!)", german="(Ich bin zu einem [c_kind:PLAYER] geworden!)", italian="(Sono diventato un Pokémon, un esemplare di\n[c_kind:PLAYER]!)", spanish="(¡Me he convertido en un [c_kind:PLAYER]!)"})
  else
  SkySceneKit.say({english="(I've turned into an [c_kind:PLAYER]!)", french="(Je me suis changée en [c_kind:PLAYER]!)", german="(Ich bin zu einem [c_kind:PLAYER] geworden!)", italian="(Mi sono trasformata in un Pokémon, un\nesemplare di [c_kind:PLAYER]!)", spanish="(¡Me he convertido en una [c_kind:PLAYER]!)"})
  end
  -- @label_1 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...But how did this happen?[K] I don't remember\nanything...)", french="(... Que s'est-il passé?[K] Je ne me souviens\nde rien...)", german="(...Aber wie ist das geschehen?[K] Ich kann mich\nan nichts erinnern...)", italian="(Ma come è successo?[K] Non mi ricordo\nniente...)", spanish="(¿Cómo ha podido ocurrir?[K] No recuerdo nada.)"})
  else
  SkySceneKit.say({english="(...But how did this happen?[K] I don't remember\nanything...)", french="(... Que s'est-il passé?[K] Je ne me souviens\nde rien...)", german="(...Aber wie ist das geschehen?[K] Ich kann mich\nan nichts erinnern...)", italian="(Ma come è successo?[K] Non mi ricordo\nniente...)", spanish="(¿Cómo ha podido ocurrir?[K] No recuerdo nada.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You're...[K]a little odd...", french="Tu es...[K] un peu bizarre,\nquand même...", german=" Du bist...[K] etwas merkwürdig...", italian="Mi sembri...[K] davvero un tipo\nstrano...", spanish=" Eres...[K] un Pokémon un poco raro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You're...[K]a little odd...", french="Tu es...[K] un peu bizarre,\nquand même...", german=" Du bist...[K] etwas merkwürdig...", italian="Mi sembri...[K] davvero un tipo\nstrano...", spanish=" Eres...[K] un Pokémon un poco raro."})
  else
  SkySceneKit.say({english=" You're...[K]a little odd...", french="Tu es...[K] un peu bizarre,\nquand même...", german=" Du bist...[K] etwas merkwürdig...", italian="Mi sembri...[K] davvero un tipo\nstrano...", spanish=" Eres...[K] un Pokémon un poco raro."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Are you pulling some kind of\ntrick on me?", french="Tu es en train de me faire\nune blague?", german=" Soll das irgendein Streich sein?", italian=" Non mi starai prendendo in giro?", spanish="¿No me estarás gastando\nuna broma?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Are you pulling some kind of\ntrick on me?", french="Tu es en train de me faire\nune blague?", german=" Soll das irgendein Streich sein?", italian=" Non mi starai prendendo in giro?", spanish="¿No me estarás gastando\nuna broma?"})
  else
  SkySceneKit.say({english="Are you pulling some kind of\ntrick on me?", french="Tu es en train de me faire\nune blague?", german=" Soll das irgendein Streich sein?", italian=" Non mi starai prendendo in giro?", spanish="¿No me estarás gastando\nuna broma?"})
  end
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You're telling me the truth?", french=" Tu me dis la vérité?", german=" Du hast die Wahrheit gesagt?", italian=" Mi stai dicendo la verità?", spanish=" ¿Me estás diciendo la verdad?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You're telling me the truth?", french=" Tu me dis la vérité?", german=" Du hast die Wahrheit gesagt?", italian=" Mi stai dicendo la verità?", spanish=" ¿Me estás diciendo la verdad?"})
  else
  SkySceneKit.say({english=" You're telling me the truth?", french=" Tu me dis la vérité?", german=" Du hast die Wahrheit gesagt?", italian=" Mi stai dicendo la verità?", spanish=" ¿Me estás diciendo la verdad?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="OK, then what's your name?[K]\nWhat do you call yourself?", french="Bon, d'accord. C'est quoi ton\nnom alors?[K] Quel est ton nom?", german="Okay, wie heißt du?[K]\nWie ist dein Name?", italian="Ok, allora qual è il tuo nome?[K]\nCome ti chiami?", spanish="Bueno, ¿y cómo te llamas?[K]\n¿Cuál es tu nombre?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="All right, then. Your name?[K]\nWhat's your name?", french="Bon, d'accord. C'est quoi ton\nnom alors?[K] Quel est ton nom?", german="Na gut. Und wie heißt du?[K]\nWie ist dein Name?", italian="Ok, allora qual è il tuo nome?[K]\nCome ti chiami?", spanish="Bueno, ¿me podrías decir\ncómo te llamas?[K] ¿Cuál es tu nombre?"})
  else
  SkySceneKit.say({english="OK, how about your name?[K]\nWhat's your name?", french="Bon, d'accord. C'est quoi ton\nnom alors?[K] Quel est ton nom?", german="Okay, wie heißt du?[K]\nWie ist dein Name?", italian="Ok, allora qual è il tuo nome?[K]\nCome ti chiami?", spanish="Bueno... ¿Y cómo te llamas?[K]\n¿Cuál es tu nombre?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(My name?[K] That's right, my name is...)", french="(Mon nom?[K] Ah oui, je m'appelle...)", german="(Mein Name?[K] Ach ja... Mein Name ist...)", italian="(Il mio nome?[K] Giusto, il mio nome è...)", spanish="(¿Mi nombre?[K] Eso es. Me llamo...)"})
  else
  SkySceneKit.say({english="(My name?[K] That's right, my name is...)", french="(Mon nom?[K] Ah oui, je m'appelle...)", german="(Mein Name?[K] Ach ja... Mein Name ist...)", italian="(Il mio nome?[K] Giusto, il mio nome è...)", spanish="(¿Mi nombre?[K] Eso es. Me llamo...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(message_Menu(MENU_PLAYER_NAME)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, [hero] is your name?", french="Alors comme ça, tu t'appelles\n[hero]?", german=" Oh, du heißt [hero]?", italian=" Oh, ti chiami [hero]?", spanish=" Así que te llamas [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, [hero] is your name?", french="Alors comme ça, tu t'appelles\n[hero]?", german=" Oh, du heißt [hero]?", italian=" Oh, ti chiami [hero]?", spanish=" Ah, ¿te llamas [hero]?"})
  else
  SkySceneKit.say({english=" So you're named [hero]?", french="Alors comme ça, tu t'appelles\n[hero]?", german=" Du heißt [hero]?", italian=" Oh, ti chiami [hero]?", spanish=" ¿Te llamas [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="OK.[K] Well, you don't seem to be a\nbad Pokémon, at least.", french="D'accord.[K] Après tout, tu n'as pas\nl'air d'être un méchant Pokémon.", german="Okay.[K] Nun, zumindest scheinst du\nkein bösartiges Pokémon zu sein.", italian="Ok.[K] Beh, perlomeno non sembri\nessere un Pokémon cattivo.", spanish="Vale.[K] Bueno, al menos no pareces\nun Pokémon malvado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="OK.[K] Well, you don't seem to be a\nbad Pokémon, at least.", french="D'accord.[K] Après tout, tu n'as pas\nl'air d'être un méchant Pokémon.", german="Okay.[K] Nun, zumindest scheinst du\nkein bösartiges Pokémon zu sein.", italian="Ok.[K] Beh, perlomeno non sembri\nessere un Pokémon cattivo.", spanish="Vale.[K] Bueno, al menos no pareces\nun Pokémon malvado."})
  else
  SkySceneKit.say({english="OK.[K] Well, you don't seem to be a\nbad Pokémon, at least.", french="D'accord.[K] Après tout, tu n'as pas\nl'air d'être un méchant Pokémon.", german="Okay.[K] Nun, zumindest scheinst du\nkein bösartiges Pokémon zu sein.", italian="Ok.[K] Beh, perlomeno non sembri\nessere un Pokémon cattivo.", spanish="Vale.[K] Bueno, al menos no pareces\nun Pokémon malvado."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Sorry that I doubted you.", french="Je suis désolé d'avoir douté\nde toi.", german="Tut mir leid, dass ich dir nicht\ngeglaubt habe.", italian=" Mi spiace aver dubitato di te.", spanish=" Siento haber dudado de ti."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Sorry that I doubted you.", french="Je suis désolé d'avoir douté\nde toi.", german="Tut mir leid, dass ich dir nicht\ngeglaubt habe.", italian=" Mi spiace aver dubitato di te.", spanish=" Siento haber dudado de ti."})
  else
  SkySceneKit.say({english=" Sorry that I doubted you.", french="Je suis désolée d'avoir douté\nde toi.", german="Tut mir leid, dass ich dir nicht\ngeglaubt habe.", italian=" Mi spiace aver dubitato di te.", spanish=" Siento haber dudado de ti."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="More and more bad Pokémon\nhave been turning up lately, you see!", french="Tu comprends, il y a de plus en\nplus de Pokémon méchants ces derniers temps.", german="Weißt du, neuerdings gibt es\nimmer mehr bösartige Pokémon!", italian="Sai, ultimamente ci sono in giro\nparecchi Pokémon cattivi!", spanish="Últimamente cada vez hay más\nPokémon malvados."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="More and more bad Pokémon\nhave been turning up lately, you see!", french="Tu comprends, il y a de plus en\nplus de Pokémon méchants ces derniers temps.", german="Weißt du, neuerdings gibt es\nimmer mehr bösartige Pokémon!", italian="Sai, ultimamente si vedono in\ngiro moltissimi Pokémon cattivi!", spanish="Últimamente han ido apareciendo\nmuchos Pokémon malvados."})
  else
  SkySceneKit.say({english="More and more bad Pokémon\nhave been turning up lately, you see!", french="Tu comprends, il y a de plus en\nplus de Pokémon méchants ces derniers temps.", german="Weißt du, neuerdings gibt es\nimmer mehr bösartige Pokémon!", italian="Sai, ultimamente si incontrano in\ngiro molti Pokémon cattivi!", spanish="Últimamente cada vez hay más\nPokémon malvados."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="A lot of Pokémon have started\nbeing aggressive lately.[K] Things have\ngotten wild for some reason...", french="Beaucoup de Pokémon deviennent\nagressifs ces temps-ci.[K] On ne se sent\nplus en sécurité comme avant.", german="Viele Pokémon sind in letzter\nZeit aggressiv geworden.[K] Die Dinge sind\nirgendwie außer Kontrolle geraten...", italian="Negli ultimi tempi molti Pokémon\nsi stanno comportando in maniera aggressiva\nsenza una ragione...", spanish="Muchos Pokémon se han vuelto\nagresivos.[K] Debe de haber algún motivo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Many Pokémon have gotten\naggressive lately.[K] Things have grown\nsomewhat lawless...", french="Beaucoup de Pokémon deviennent\nagressifs ces temps-ci.[K] On ne se sent\nplus en sécurité comme avant.", german="Viele Pokémon sind in letzter\nZeit aggressiv geworden.[K] Alles ist ziemlich\nchaotisch...", italian="Molti Pokémon sono diventati\naggressivi negli ultimi tempi.[K] Le cose sono\nun po' confuse...", spanish="Muchos Pokémon se han vuelto\nagresivos.[K] Las cosas se han descontrolado\npor aquí..."})
  else
  SkySceneKit.say({english="A lot of Pokémon have gotten\naggressive lately.[K] It's just not\nsafe anymore...", french="Beaucoup de Pokémon deviennent\nagressifs ces temps-ci.[K] On ne se sent\nplus en sécurité comme avant.", german="Viele Pokémon sind in letzter\nZeit aggressiv geworden.[K] Man kann sich nicht\nmehr sicher fühlen...", italian="Molti Pokémon sono diventati\naggressivi negli ultimi tempi.[K] Non mi sento\npiù molto al sicuro...", spanish="Muchos Pokémon se han vuelto\nagresivos.[K] Una ya no se siente segura\nen ninguna parte..."})
  end
  -- message_Close
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 432, 176, Direction.Left, "NPC_ZUBATTO")
  -- SetOutputAttribute(2) [neutre/état moteur]
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 440, 200, Direction.Left, "NPC_DOGAASU")
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_zubatto, 348, 172, false, 2)
  GROUND:MoveToPosition(npc_npc_dogaasu, 348, 196, false, 2)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- bgm2_Stop [canal BGM sub: voir bgm2_Play]
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(15)
  -- SetAnimation(11) [anim idle native]
  GROUND:MoveToPosition(partner, 280, 172, false, 2) -- SlidePositionMark (glissement)
  -- message_FacePositionOffset(2, 1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ow!", french=" Aïe!", german=" Au!", italian=" Ouch!", spanish=" ¡Ah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ouch!", french=" Aïe!", german=" Autsch!", italian=" Ouch!", spanish=" ¡Ay!"})
  else
  SkySceneKit.say({english=" Yowch!", french=" Aïe!", german=" Aua!", italian=" Ahi!", spanish=" ¡Ay!"})
  end
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(hero, 248, 172, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- SetAnimation(68) [anim idle native]
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- MovePositionOffset<object OBJECT_G01P01A1_93> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_G01P01A1_93> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionMark OBJECT_G01P01A1_93 [cible sans placement SSA zone: mouvement non joué]
  -- SetAnimation(2) [anim idle native]
  -- MoveHeight(2, 10) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Well, I do beg your pardon.", french=" Oups! Désolé.", german=" Och, das tut mir aber leid.", italian=" Oh, chiedo scusa.", spanish=" Mil perdones..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.Right)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(partner, "angry", 1) end)
  -- message_FacePositionOffset(2, 1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! Why'd you do that?!", french=" Hé! Pourquoi t'as fait ça?!", german="Hey! Warum hast du das\ngemacht?!?", italian=" Ehi, perché l'hai fatto?!", spanish=" ¡Eh! ¿Por qué habéis hecho eso?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! Why'd you do that?!", french=" Hé! Pourquoi t'as fait ça?!", german="Hey! Warum hast du das\ngemacht?!?", italian=" Ehi, perché l'hai fatto?!", spanish=" ¡Eh! ¿Por qué habéis hecho eso?"})
  else
  SkySceneKit.say({english=" Hey! Why'd you do that?!", french=" Hé! Pourquoi t'as fait ça?!", german="Hey! Warum hast du das\ngemacht?!?", italian=" Ehi, perché l'hai fatto?!", spanish=" ¡Eh! ¿Por qué habéis hecho eso?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Heh-heh-heh! Can't figure it out?", french="Hin hin hin! T'as pas une\npetite idée?", german="Hehehe! Kommst du nicht\nselbst drauf?", italian=" Eh-eh-eh! Non ci arrivi?", spanish=" ¡Jue, jue, jue! ¿No te lo imaginas?"})
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="We wanted to mess with you!\nCan't face up to us, can you?!", french="On veut juste vous embêter!\nVous faites pas le poids, de toute façon!", german="Wir wollen Ärger machen!\nDu hast wohl nicht den Mumm dazu, dich zu\nwehren?", italian="Volevamo azzuffarci un po' con\nte! Non hai il coraggio di affrontarci, vero?", spanish="¡Porque queríamos meternos contigo!\nY no vas a hacer nada al respecto, ¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- message_FacePositionOffset(2, 1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-what?!", french=" Q-quoi?!", german=" W-was?!?", italian=" C-Cosa?!", spanish=" ¡¿Qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-what?!", french=" Q-quoi?!", german=" W-was?!?", italian=" C-Cosa?!", spanish=" ¡¿Qué?!"})
  else
  SkySceneKit.say({english=" Wh-what?!", french=" Q-quoi?!", german=" W-was?!?", italian=" C-Cosa?!", spanish=" ¡¿Qué?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_zubatto, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" That's yours, isn't it?", french=" C'est à toi, ça, non?", german=" Das gehört dir, oder?", italian=" Questo è tuo, giusto?", spanish=" Esto es tuyo, ¿no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownRight)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  -- message_FacePositionOffset(2, 1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! That's...!", french=" Non! C'est...!", german=" Hey! Das ist...", italian=" Ehi! Quello è...!", spanish=" ¡Eh! ¡Eso es mi...!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" No! That's...!", french=" Non! C'est...!", german=" Nein! Das ist...", italian=" No! Quello è...!", spanish=" ¡No! ¡Eso es mi...!"})
  else
  SkySceneKit.say({english=" Oh! That's...!", french=" Non! C'est...!", german=" Oh! Das ist...", italian=" Oh! Quello è...!", spanish=" ¡Oh! ¡Eso es mi...!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Sorry, kiddo. We'll take that!", french="Désolé, mon chou. On va te\nle prendre!", german="Sorry, du Zwerg. Aber das\nnehmen wir!", italian=" Questo ce lo prendiamo noi!", spanish="Lo siento, colega.\n¡Nos lo quedamos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_zubatto.Position; GROUND:MoveToPosition(npc_npc_zubatto, p.X+(-28), p.Y+(24), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- message_FacePositionOffset(2, 1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Aaaah!", french=" Aaah!", german=" Aaaah!", italian=" Aaaah!", spanish=" ¡Aaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Aaaah!", french=" Aaah!", german=" Aaaah!", italian=" Aaaah!", spanish=" ¡Aaah!"})
  else
  SkySceneKit.say({english=" Aaaah!", french=" Aaah!", german=" Aaaah!", italian=" Aaaah!", spanish=" ¡Aaah!"})
  end
  GAME:WaitFrames(10)
  do local p=npc_npc_zubatto.Position; GROUND:MoveToPosition(npc_npc_zubatto, p.X+(28), p.Y+(-24), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_zubatto, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_zubatto, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_zubatto, 4) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Whoa-ho-ho![K] Not gonna make a\nmove to get that back?[K] What's the matter?[K]\nToo scared?", french="Mouarf![K] Tu lèves même pas\nle petit doigt pour le récupérer?[K] Qu'est-ce qui\nt'arrive?[K] T'as trop peur?", german="Whoahoho![K] Willst du es dir\nnicht zurückholen?[K] Was ist los?[K]\nHast du etwa Angst?", italian="Ooooh![K] Non provi a\nriprendertelo?[K] Cosa c'è?[K]\nTroppa fifa?", spanish="¡Jo, jo, jo![K] ¿Es que no vas a\nmover ni un dedo para recuperarlo?[K]\n¿Qué te pasa?[K] ¿Tienes miedo?"})
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="I didn't expect that you'd be such\na big coward!", french="Je pensais pas avoir affaire\nà une poule mouillée pareille!", german="Ich hätte nicht gedacht, dass du\nso ein Angsthase bist!", italian="Non pensavo che avresti avuto\ncosì tanta paura!", spanish="¡No me esperaba que fueras\ntan cobarde!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogaasu, npc_npc_zubatto, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, npc_npc_dogaasu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Come on. Let's get out of here.", french=" Allez, on s'en va!", german=" Komm schon. Hauen wir ab.", italian=" Forza, andiamocene via di qua.", spanish=" Venga. Vámonos de aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogaasu, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="See you around, chicken.[K]\nHeh-heh-heh.", french="A bientôt, poule mouillée.[K]\nHin hin hin!", german="Bis irgendwann, du Memme.[K]\nHehehe.", italian="Ci vediamo, pusillanime.[K]\nEh-eh-eh.", spanish="Nos vemos, gallina.[K]\nJue, jue, jue."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GAME:MoveCamera(264, 176, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_dogaasu, 96, 212, false, 2)
  GROUND:EntTurn(npc_npc_zubatto, Direction.DownLeft)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_zubatto, 104, 212, false, 2)
  GAME:WaitFrames(20)
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[K]Ohhh...", french=" ...[K] Oooh...", german=" ...[K]Ohhh...", italian=" ...[K] Ohhh...", spanish=" Oh...[K] no..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[K]Ohhh...", french=" ...[K] Oooh...", german=" ...[K]Ohhh...", italian=" ...[K] Ohhh...", spanish=" Oh...[K] no..."})
  else
  SkySceneKit.say({english=" ...[K]Ohhh...", french=" ...[K] Oooh...", german=" ...[K]Ohhh...", italian=" ...[K] Ohhh...", spanish=" Oh...[K] no..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-what should I do?", french=" Que... que dois-je faire?", german=" W-was soll ich nur tun?", italian=" Cosa faccio adesso?", spanish=" Y ahora... ¿qué hago?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-what should I do?", french=" Que... que dois-je faire?", german=" W-was soll ich nur tun?", italian=" Cosa faccio adesso?", spanish=" ¿Qué... qué hago?"})
  else
  SkySceneKit.say({english=" Wh-what should I do?", french=" Que... que dois-je faire?", german=" W-was soll ich nur tun?", italian=" Cosa faccio adesso?", spanish=" ¿Qué... qué hago?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's my personal treasure.\nIt means everything to me.", french="C'est mon trésor. Pour moi,\nil a une valeur inestimable.", german="Das war mein Schatz.\nEr bedeutet mir alles.", italian="Quello è il mio tesoro. Significa\ntutto per me.", spanish="Es mi talismán.\nSignifica mucho para mí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's my personal treasure.\nIt means everything to me.", french="C'est mon trésor. Pour moi,\nil a une valeur inestimable.", german="Das war mein Schatz.\nEr bedeutet mir alles.", italian="Quello è il mio tesoro. Significa\ntutto per me.", spanish="Es mi talismán.\nSignifica mucho para mí."})
  else
  SkySceneKit.say({english="That's my personal treasure.\nIt means everything to me.", french="C'est mon trésor. Pour moi,\nil a une valeur inestimable.", german="Das war mein Schatz.\nEr bedeutet mir alles.", italian="Quello è il mio tesoro. Significa\ntutto per me.", spanish="Es mi talismán.\nSignifica mucho para mí."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" If I lose that...", french=" Si jamais je le perds...", german=" Ihn zu verlieren...", italian=" Se lo perdo...", spanish=" Si lo pierdo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" If I lose that...", french=" Si jamais je le perds...", german=" Ihn zu verlieren...", italian=" Se lo perdo...", spanish=" Si lo pierdo..."})
  else
  SkySceneKit.say({english=" If I lose that...", french=" Si jamais je le perds...", german=" Ihn zu verlieren...", italian=" Se lo perdo...", spanish=" Si lo pierdo..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" No! There's no time to waste!", french=" Non! Pas de temps à perdre!", german=" Nein! Keine Zeit zum Grübeln!", italian=" No! Non c'è tempo da perdere!", spanish=" ¡No! ¡No hay tiempo que perder!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" No! There's no time to waste!", french=" Non! Pas de temps à perdre!", german=" Nein! Keine Zeit zum Grübeln!", italian=" No! Non c'è tempo da perdere!", spanish=" ¡No! ¡No hay tiempo que perder!"})
  else
  SkySceneKit.say({english=" No! There's no time to waste!", french=" Non! Pas de temps à perdre!", german=" Nein! Keine Zeit zum Grübeln!", italian=" No! Non c'è tempo da perdere!", spanish=" ¡No! ¡No hay tiempo que perder!"})
  end
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I have to get it back![K] Hey, will\nyou help me?", french="Il faut que je le récupère![K] Hé,\ntu veux m'aider?", german="Ich muss ihn zurückholen![K]\nHey, hilfst du mir?", italian="Devo assolutamente\nriprendermelo![K] Ehi, tu! Mi aiuteresti?", spanish="¡Tengo que recuperarlo![K]\nOye, ¿puedo contar con tu ayuda?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I've got to get it back![K] Hey, can\nI get you to help me?", french="Il faut que je le récupère![K] Hé,\ntu veux m'aider?", german="Ich muss ihn zurückholen![K]\nHey, hilfst du mir?", italian="Devo assolutamente\nriprendermelo![K] Ehi, tu! Mi aiuteresti?", spanish="¡Tengo que recuperarlo![K]\nOye, ¿querrías ayudarme?"})
  else
  SkySceneKit.say({english="I have to get it back![K] Say, can\nyou please help me?", french="Il faut que je le récupère![K] Hé,\ntu veux m'aider?", german="Ich muss ihn zurückholen![K]\nKönntest du mir vielleicht helfen?", italian="Devo assolutamente\nriprendermelo![K] Ehi, tu! Mi aiuteresti?", spanish="¡Debo recuperarlo![K]\n¿Podrías ayudarme?"})
  end
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}, {english="Wh-what should I do?", french="Que... que faire?", german="W-was soll ich machen?", italian="Cosa faccio adesso?", spanish="¿Qué... Qué debería hacer?"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- @label_2 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="R-really?[K]\nYou'll really help?!", french="V-vraiment?[K]\nTu vas vraiment m'aider?!", german="W-wirklich?[K]\nDu hilfst mir wirklich?!?", italian="S-Sul serio?[K]\nMi aiuterai davvero?!", spanish="¿En... En serio?[K]\n¡¿Me vas a ayudar de verdad?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="R-really?[K]\nYou'll really help?!", french="V-vraiment?[K]\nTu vas vraiment m'aider?!", german="W-wirklich?[K]\nDu hilfst mir wirklich?!?", italian="S-Sul serio?[K]\nMi aiuterai davvero?!", spanish="¿De... De verdad?[K]\n¡¿Me vas a ayudar?!"})
  else
  SkySceneKit.say({english="R-really?[K]\nYou'll really help?!", french="V-vraiment?[K]\nTu vas vraiment m'aider?!", german="W-wirklich?[K]\nDu hilfst mir wirklich?!?", italian="S-Sul serio?[K]\nMi aiuterai davvero?!", spanish="¿Lo dices... en serio?[K]\n¡¿Me vas a ayudar de verdad?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Th-thank you! Let's go quickly!", french="Oh... merci! Vite, allons-y tout\nde suite!", german=" D-danke! Schnell, gehen wir!", italian=" G-Grazie! Presto, andiamo!", spanish="¡Gracias!\n¡Vayamos cuanto antes!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Th-thank you! Let's go quickly!", french="Oh... merci! Vite, allons-y tout\nde suite!", german=" D-danke! Schnell, gehen wir!", italian=" G-Grazie! Presto, andiamo!", spanish="¡Gracias!\n¡Vayamos cuanto antes!"})
  else
  SkySceneKit.say({english="Th-thanks! Can we go take\ncare of it right now?", french="Oh... merci! Vite, allons-y tout\nde suite!", german="D-danke! Können wir uns jetzt\nsofort darum kümmern?", italian="G-Grazie! Possiamo andare\nsubito?", spanish="¡Gracias! ¿Podemos ir tras ellos\nahora mismo?"})
  end
  -- message_Close
  GROUND:MoveToPosition(partner, 112, 212, false, 2)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:MoveToPosition(hero, 112, 212, false, 2)
  GAME:WaitFrames(60)
  pcall(function() SOUND:FadeOutBGM(60) end)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitBgm
  SkyProg.set(2, 2) -- $SCENARIO_MAIN = scn[2,2] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[1] = 1 -- dungeon_mode(1) = DMODE_OPEN (ROM)
  -- main_EnterDungeon(1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 3 then
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_3 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?! You won't help me?", french=" Quoi?! Tu ne veux pas m'aider?", german=" Häh?!? Du hilfst mir nicht?", italian=" Eh?! Non vuoi aiutarmi?", spanish=" ¡¿Qué?! ¿No me vas a ayudar?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?! You won't help me?", french=" Quoi?! Tu ne veux pas m'aider?", german=" Was?!? Du hilfst mir nicht?", italian=" Cosa?! Non vuoi aiutarmi?", spanish=" ¡¿Qué?! ¿No quieres ayudarme?"})
  else
  SkySceneKit.say({english=" Awww! You won't help me?", french=" Quoi?! Tu ne veux pas m'aider?", german=" Och, du hilfst mir nicht?", italian=" Aah! Non vuoi aiutarmi?", spanish=" ¡¿Cómo?! ¿No vas a ayudarme?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That thing is really, really\nimportant to me!", french="Cet objet représente vraiment\ntout pour moi!", german="Dieses Ding ist mir wirklich,\nwirklich wichtig!", italian="Si tratta di una cosa molto,\nmolto importante per me!", spanish="¡Ese objeto es importantísimo\npara mí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That thing really means\neverything to me!", french="Cet objet représente vraiment\ntout pour moi!", german="Dieses Ding ist mir wirklich,\nwirklich wichtig!", italian="Quella cosa mi sta davvero a\ncuore!", spanish="¡Ese objeto es realmente\nimportante para mí!"})
  else
  SkySceneKit.say({english=" That thing is important to me!", french="Cet objet représente vraiment\ntout pour moi!", german="Dieses Ding ist mir wirklich,\nwirklich wichtig!", italian="Quella cosa è importante\nper me!", spanish="¡Ese objeto es muy importante\npara mí!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" If I can't get it back...", french="Si je n'arrive pas à le leur\nreprendre...", german="Wenn ich es nicht zurückholen\nkann...", italian=" Se non la posso riavere...", spanish=" Si no lo recupero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" If I can't get it back...", french="Si je n'arrive pas à le leur\nreprendre...", german="Wenn ich es nicht zurückholen\nkann...", italian=" Se non la posso riavere...", spanish=" Si no logro recuperarlo..."})
  else
  SkySceneKit.say({english=" If I can't get it back...", french="Si je n'arrive pas à le leur\nreprendre...", german="Wenn ich es nicht zurückholen\nkann...", italian=" Se non la posso riavere...", spanish=" Si no lograse recuperarlo..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Come on, please?[K] Please help me\nget that treasure of mine back!", french="Oh, s'il te plaît?[K] Je t'en prie,\naide-moi à reprendre mon trésor à ces\nvoyous!", german="Komm schon, bitte![K] Bitte hilf\nmir, meinen Schatz zurückzuholen!", italian="Dai, per favore![K] Aiutami a\nriprendere il mio tesoro!", spanish="¡Hablo en serio! Por favor...[K]\n¡Ayúdame a recuperar mi talismán!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm serious! Please?[K] Please help\nme get that treasure of mine back!", french="Oh, s'il te plaît?[K] Je t'en prie,\naide-moi à reprendre mon trésor à ces\nvoyous!", german="Ich meine es ernst! Bitte![K]\nBitte hilf mir, meinen Schatz zurückzuholen!", italian="Dico sul serio! Per favore![K]\nAiutami a riprendere il mio tesoro!", spanish="Por favor... [K]¡Ayúdame\na recuperar mi talismán!"})
  else
  SkySceneKit.say({english="Oh, please?[K] Please help me get\nthat treasure of mine back from those guys!", french="Oh, s'il te plaît?[K] Je t'en prie,\naide-moi à reprendre mon trésor à ces\nvoyous!", german="Ach bitte![K] Bitte hilf mir,\ndiesen Typen den Schatz wieder abzunehmen!", italian="Oh, ti prego![K] Aiutami a\nriprendere il tesoro da quei tipacci!", spanish="Por favor... [K]¡Ayúdame\na recuperar mi talismán!"})
  end
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}, {english="Wh-what should I do?", french="Que... que faire?", german="W-was soll ich machen?", italian="Cosa faccio adesso?", spanish="¿Qué... Qué debería hacer?"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_4 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We...we don't have time for\nthis! Come on!", french="Nous... nous n'avons pas\nde temps à perdre, allons-y!", german="Wir... Wir haben keine Zeit für\nso was! Komm schon!", italian="Non... Non abbiamo tempo\nper queste cose! Forza!", spanish="Venga... ¡Que no tenemos tiempo\npara esto! ¡Deprisa!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We don't have time to waste.\nCome on!", french="Nous... nous n'avons pas\nde temps à perdre, allons-y!", german="Wir haben keine Zeit zu\nverlieren. Komm schon!", italian="Non abbiamo tempo da perdere.\nMuoviamoci!", spanish="No hay tiempo que perder,\n¡vamos!"})
  else
  SkySceneKit.say({english="We don't have any time\nto waste! Let's go!", french="Nous... nous n'avons pas\nde temps à perdre, allons-y!", german="Wir haben keine Zeit zu\nverlieren! Lass uns gehen!", italian="Non abbiamo tempo da perdere.\nAndiamo!", spanish=" ¡No perdamos tiempo! ¡Vamos!"})
  end
  do local __choice = SkySceneKit.ask({{english="G-got it!", french="Je... je comprends!", german="K-klaro!", italian="V-Va bene!", spanish="¡Lo... Lo tengo!"}, {english="But you can't just... ", french="Mais tu ne peux pas juste...", german="Aber du kannst doch nicht...", italian="Ma non puoi...", spanish="Pero no puedes... "}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That's my precious treasure...", french=" C'est mon précieux trésor...", german=" Mein wertvoller Schatz...", italian=" Quello è il mio prezioso tesoro...", spanish=" Es mi querido tesoro..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's my precious treasure...", french=" C'est mon précieux trésor...", german=" Mein wertvoller Schatz...", italian=" Quello è il mio prezioso tesoro...", spanish=" Es mi tesoro adorado..."})
  else
  SkySceneKit.say({english=" That's my precious treasure...", french=" C'est mon précieux trésor...", german=" Mein wertvoller Schatz...", italian=" Quello è il mio prezioso tesoro...", spanish=" Es mi amado tesoro..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" If that disappeared, then I'd...", french=" S'il venait à disparaître, je...", german=" Würde der verschwinden, ich...", italian=" Se dovessi perderlo, io...", spanish=" Si desapareciera, yo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" If that disappeared, then I'd...", french=" S'il venait à disparaître, je...", german=" Würde der verschwinden, ich...", italian=" Se dovessi perderlo, io...", spanish=" Si desapareciera, yo..."})
  else
  SkySceneKit.say({english=" If that disappeared, then I'd...", french=" S'il venait à disparaître, je...", german=" Würde der verschwinden, ich...", italian=" Se dovessi perderlo, io...", spanish=" Si desapareciera, yo..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Come on, I'm begging![K]\nPlease help!", french="Allez, je t'en prie![K]\nAide-moi, s'il te plaît!", german="Komm schon, ich flehe dich an![K]\nBitte hilf!", italian="Dai, per favore![K]\nDammi una mano!", spanish="¡Venga, te lo suplico![K]\n¡Ayúdame, por favor!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Please![K]\nPlease help!", french="Allez, je t'en prie![K]\nAide-moi, s'il te plaît!", german="Bitte![K]\nZu Hilfe!", italian="Ti prego![K]\nAiutami!", spanish="¡Por favor![K]\n¡Tienes que ayudarme!"})
  else
  SkySceneKit.say({english="Please![K]\nPlease help!", french="Allez, je t'en prie![K]\nAide-moi, s'il te plaît!", german="Bitte![K]\nZu Hilfe!", italian="Te lo chiedo per favore![K]\nAiutami!", spanish="¡Por favor![K]\n¡Te ruego que me ayudes!"})
  end
  do local __choice = SkySceneKit.ask({{english="G-got it!", french="Je... je comprends!", german="S-schon klar!", italian="V-Va bene!", spanish="¡Lo... Lo tengo!"}, {english="But I have no memory...", french="Mais je n'ai aucun souvenir...", german="Ich erinnere mich nicht...", italian="Ma io ho perso la memoria...", spanish="Pero no recuerdo..."}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I know it's difficult...but hurry!", french="Je sais que c'est dur...\nmais dépêchons-nous!", german="Es mag schwierig sein, aber\nbitte beeile dich!", italian="So che è difficile...\nMa dobbiamo sbrigarci!", spanish="Ya sé que es difícil...\n¡pero corre!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I know it's difficult...but hurry!", french="Je sais que c'est dur...\nmais dépêchons-nous!", german="Es mag schwierig sein, aber\nbitte beeile dich!", italian="So che è difficile...\nMa dobbiamo sbrigarci!", spanish="Ya sé que es difícil...\n¡pero date prisa!"})
  else
  SkySceneKit.say({english=" I know it's difficult...but hurry!", french="Je sais que c'est dur...\nmais dépêchons-nous!", german="Es mag schwierig sein, aber\nbitte beeile dich!", italian="So che è difficile...\nMa dobbiamo sbrigarci!", spanish="Ya sé que es difícil...\n¡pero tienes que darte prisa!"})
  end
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It doesn't matter if you have no\nmemory. You can still help! Please!", french="Peu importe que tu n'aies aucun\nsouvenir. Tu peux quand même apporter\nton aide! S'il te plaît!", german="Es kommt nicht drauf an, ob du\ndich erinnerst! Du kannst doch trotzdem\nhelfen! Bitte!", italian="Non importa se hai perso\nla memoria. Mi puoi aiutare lo stesso!\nPer favore!", spanish="No importa que no te acuerdes.\n¡Todavía puedes ayudar! ¡Venga!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It doesn't matter if you have no\nmemory. You can still help! Please!", french="Peu importe que tu n'aies aucun\nsouvenir. Tu peux quand même apporter\nton aide! S'il te plaît!", german="Es kommt nicht drauf an, ob du\ndich erinnerst! Du kannst doch trotzdem\nhelfen! Bitte!", italian="Non importa se hai perso\nla memoria. Mi puoi aiutare lo stesso!\nPer favore!", spanish="No importa que no te acuerdes,\n¡Aún puedes ser de ayuda! ¡Por favor!"})
  else
  SkySceneKit.say({english="It doesn't matter if you have no\nmemory. You can still help! Please!", french="Peu importe que tu n'aies aucun\nsouvenir. Tu peux quand même apporter\nton aide! S'il te plaît!", german="Es kommt nicht drauf an, ob du\ndich erinnerst! Du kannst doch trotzdem\nhelfen! Bitte!", italian="Non importa se hai perso\nla memoria. Mi puoi aiutare lo stesso!\nPer favore!", spanish="No importa que no te acuerdes.\n¡Todavía puedes ayudar! ¡Te lo pido por favor!"})
  end
  do local __choice = SkySceneKit.ask({{english="G-got it!", french="Je... je comprends!", german="V-verstanden!", italian="V-Va bene!", spanish="¡Lo... Lo tengo!"}, {english="But I'm sure I was a human...", french="Mais j'étais un être humain...", german="Nur war ich sicher ein Mensch...", italian="Ma io ero un essere umano...", spanish="Pero sé que era un ser humano."}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(partner, "angry", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Argh! [K]Human, ghost, it doesn't\nmatter. You can still help! Please!", french="Bah! [K]Etre humain, fantôme...\npeu importe! Tu peux apporter ton aide,\nmalgré tout! S'il te plaît!", german="Argh! [K]Mensch, Gespenst,\ndas tut jetzt nichts zur Sache.\nDu kannst mir helfen! Bitte!", italian="Argh![K] Umano, fantasma,\nnon importa. Puoi aiutarmi lo stesso! Ti prego!", spanish="¡Arg![K] Humano, fantasma... ¿Qué\nmás da? ¡Aún puedes ayudar! ¡Por favor!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Argh! [K]Human, ghost, it doesn't\nmatter. You can still help! Please!", french="Bah! [K]Etre humain, fantôme...\npeu importe! Tu peux apporter ton aide,\nmalgré tout! S'il te plaît!", german="Argh! [K]Mensch, Gespenst,\ndas tut jetzt nichts zur Sache.\nDu kannst mir helfen! Bitte!", italian="Argh![K] Umano, fantasma,\nnon importa. Puoi aiutarmi lo stesso! Ti prego!", spanish="¡Arg![K] ¡Da igual que fueras\nhumano o fantasma! ¡Tú puedes ayudar!"})
  else
  SkySceneKit.say({english="Argh! [K]Human, ghost, it doesn't\nmatter. You can still help! Please!", french="Bah! [K]Etre humain, fantôme...\npeu importe! Tu peux apporter ton aide,\nmalgré tout! S'il te plaît!", german="Argh! [K]Mensch, Gespenst,\ndas tut jetzt nichts zur Sache.\nDu kannst mir helfen! Bitte!", italian="Argh![K] Umano, fantasma,\nnon importa. Puoi aiutarmi lo stesso! Ti prego!", spanish="¡Arg![K] No importa que fueras\nhumano o fantasma. ¡Todavía puedes ayudar!"})
  end
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  do local __choice = SkySceneKit.ask({{english="G-got it!", french="Je... je comprends!", german="V-verstanden!", italian="V-Va bene!", spanish="¡Lo... Lo tengo!"}, {english="O-OK!", french="Très... très bien!", german="O-okay!", italian="O-OK!", spanish="¡De... De acuerdo!"}}) -- message_SwitchMenu(0, 1) ROM
  if true then -- default
  end
  end
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  end
  end
  end
  end
  elseif true then -- default
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I've turned into a [c_kind:PLAYER]!)", french="(Je me suis changé en [c_kind:PLAYER]!)", german="(Ich bin zu einem [c_kind:PLAYER] geworden!)", italian="(Sono diventato un Pokémon, un esemplare di\n[c_kind:PLAYER]!)", spanish="(¡Me he convertido en un [c_kind:PLAYER]!)"})
  else
  SkySceneKit.say({english="(I've turned into a [c_kind:PLAYER]!)", french="(Je me suis changée en [c_kind:PLAYER]!)", german="(Ich bin zu einem [c_kind:PLAYER] geworden!)", italian="(Mi sono trasformata in un Pokémon, un\nesemplare di [c_kind:PLAYER]!)", spanish="(¡Me he convertido en un [c_kind:PLAYER]!)"})
  end
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
