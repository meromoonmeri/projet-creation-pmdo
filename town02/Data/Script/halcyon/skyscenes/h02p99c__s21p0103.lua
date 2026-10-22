-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99C/s21p0103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P06A) [décor sub chargé: Sub_v02p06a]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v02p06a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(150)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_H02P99C) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.Left)
  -- SetAnimation(76) [anim idle native]
  -- SetAnimation(76) [anim idle native]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(............)", french="(............)", german="(............)", italian="(............)", spanish="(...)"})
  else
  SkySceneKit.say({english="(............)", french="(............)", german="(............)", italian="(............)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(... ...)"})
  else
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(... ...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(........................)", french="(........................)", german="(........................)", italian="(........................)", spanish="(... ... ...)"})
  else
  SkySceneKit.say({english="(........................)", french="(........................)", german="(........................)", italian="(........................)", spanish="(... ... ...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...Ugh.[K] Can't sleep...)", french="(... Argh.[K] Impossible de dormir...)", german="(...Umpf.[K] Kann nicht schlafen...)", italian="(... Ugh.[K] Non riesco a dormire...)", spanish="(Uf...[K] No puedo dormir...)"})
  else
  SkySceneKit.say({english="(...Ugh.[K] Can't sleep...)", french="(... Argh.[K] Impossible de dormir...)", german="(...Umpf.[K] Kann nicht schlafen...)", italian="(... Ugh.[K] Non riesco a dormire...)", spanish="(Uf...[K] No puedo dormir...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner] is...[K]already asleep, I guess.)", french="([partner]...[K] doit déjà dormir.)", german="([partner]...[K] schläft schon, nehme ich an.)", italian="([partner] starà...[K] già\ndormendo, immagino.)", spanish="([partner] está...[K] durmiendo, me imagino.)"})
  else
  SkySceneKit.say({english="([partner] is...[K]already asleep, I guess.)", french="([partner]...[K] doit déjà dormir.)", german="([partner]...[K] schläft schon, nehme ich an.)", italian="([partner] starà...[K] già\ndormendo, immagino.)", spanish="([partner] está...[K] durmiendo, me imagino.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...[K]But I have to wonder...)", french="(...[K] Mais il y a quelque chose que\nje ne comprends pas...)", german="(...[K]Aber ich muss mich fragen...)", italian="(...[K] Ma mi chiedo...)", spanish="(En fin...[K] No puedo dejar de preguntarme...)"})
  else
  SkySceneKit.say({english="(...[K]But I have to wonder...)", french="(...[K] Mais il y a quelque chose que\nje ne comprends pas...)", german="(...[K]Aber ich muss mich fragen...)", italian="(...[K] Ma mi chiedo...)", spanish="(En fin...[K] No puedo dejar de preguntarme...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I understand that we're causing the distortion\nof space...)", french="(Je comprends que ce soit nous qui causions\nla distorsion de l'espace...)", german="(Wie ich es verstehe, verursachen wir die\nVerzerrung des Raumes.)", italian="(Capisco che stiamo causando la distorsione\ndello spazio...)", spanish="(Veamos, comprendo que estamos causando\nla deformación del espacio...)"})
  else
  SkySceneKit.say({english="(I understand that we're causing the distortion\nof space...)", french="(Je comprends que ce soit nous qui causions\nla distorsion de l'espace...)", german="(Wie ich es verstehe, verursachen wir die\nVerzerrung des Raumes.)", italian="(Capisco che stiamo causando la distorsione\ndello spazio...)", spanish="(Veamos, comprendo que estamos causando\nla deformación del espacio...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But how that leads to the world's ruin...)", french="(Mais comment est-ce que cela peut mener\nle monde à sa perte...)", german="(Aber wieso treibt das die Welt in den\nAbgrund?)", italian="(Ma che ciò debba comportare la distruzione\ndel mondo...)", spanish="(Pero de ahí a que eso acabe con el mundo...)"})
  else
  SkySceneKit.say({english="(But how that leads to the world's ruin...)", french="(Mais comment est-ce que cela peut mener\nle monde à sa perte...)", german="(Aber wieso treibt das die Welt in den\nAbgrund?)", italian="(Ma che ciò debba comportare la distruzione\ndel mondo...)", spanish="(Pero de ahí a que eso acabe con el mundo...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I still can't believe it...)", french="(Je n'arrive pas à y croire...)", german="(Ich kann es immer noch nicht glauben.)", italian="(Mi è difficile crederlo...)", spanish="(Me cuesta creerlo.)"})
  else
  SkySceneKit.say({english="(I still can't believe it...)", french="(Je n'arrive pas à y croire...)", german="(Ich kann es immer noch nicht glauben.)", italian="(Mi è difficile crederlo...)", spanish="(Me cuesta creerlo.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I thought it was just merely something\nfrom a dream that first time...)", french="(Je pensais que c'était juste\nun rêve la première fois...)", german="(Beim ersten Mal dachte ich, es wäre alles nur\nein Traum gewesen.)", italian="(La prima volta ho pensato che si trattasse\nsemplicemente di un sogno...)", spanish="(La primera vez pensé que solo era un sueño.)"})
  else
  SkySceneKit.say({english="(I thought it was just merely something\nfrom a dream that first time...)", french="(Je pensais que c'était juste\nun rêve la première fois...)", german="(Beim ersten Mal dachte ich, es wäre alles nur\nein Traum gewesen.)", italian="(La prima volta ho pensato che si trattasse\nsemplicemente di un sogno...)", spanish="(La primera vez pensé que solo era un sueño.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But then with the second dream...[K] When I was\ntold about the distortion of space...)", french="(Mais lors du second rêve...[K] quand on m'a\nparlé de la distorsion de l'espace...)", german="(Aber nach diesem zweiten Traum,[K] als mir\nvon der Verzerrung des Raumes erzählt\nwurde...)", italian="(Ma poi c'è stato il secondo sogno...[K] quando\nho appreso della distorsione dello spazio...)", spanish="(Pero la segunda...[K] cuando supe lo que\nocurría con la deformación del espacio...)"})
  else
  SkySceneKit.say({english="(But then with the second dream...[K] When I was\ntold about the distortion of space...)", french="(Mais lors du second rêve...[K] quand on m'a\nparlé de la distorsion de l'espace...)", german="(Aber nach diesem zweiten Traum,[K] als mir\nvon der Verzerrung des Raumes erzählt\nwurde...)", italian="(Ma poi c'è stato il secondo sogno...[K] quando\nho appreso della distorsione dello spazio...)", spanish="(Pero la segunda...[K] cuando supe lo que\nocurría con la deformación del espacio...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That was when I started thinking that maybe\nit was true.)", french="(J'ai commencé à penser que c'était peut-être\nvrai.)", german="(Von da an begann ich zu denken,\ndass es vielleicht wahr sein könnte.)", italian="(È stato allora che ho iniziato a crederci.)", spanish="(Entonces empecé a pensar que tal vez fuera\ncierto.)"})
  else
  SkySceneKit.say({english="(That was when I started thinking that maybe\nit was true.)", french="(J'ai commencé à penser que c'était peut-être\nvrai.)", german="(Von da an begann ich zu denken,\ndass es vielleicht wahr sein könnte.)", italian="(È stato allora che ho iniziato a crederci.)", spanish="(Entonces empecé a pensar que tal vez fuera\ncierto.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...Hey![K] Come to think of it, the morning after\nI had that dream...)", french="(... Au fait![K] Maintenant que j'y pense, le\nlendemain de ce rêve...)", german="(...Hey![K] Dabei fällt mir ein, dass am Morgen,\nnachdem ich diesen Traum hatte...)", italian="(Ehi![K] A pensarci, la mattina dopo quel\nsogno...)", spanish="(¡Oye![K] Ahora que lo pienso, a la mañana\nsiguiente al sueño...)"})
  else
  SkySceneKit.say({english="(...Hey![K] Come to think of it, the morning after\nI had that dream...)", french="(... Au fait![K] Maintenant que j'y pense, le\nlendemain de ce rêve...)", german="(...Hey![K] Dabei fällt mir ein, dass am Morgen,\nnachdem ich diesen Traum hatte...)", italian="(Ehi![K] A pensarci, la mattina dopo quel\nsogno...)", spanish="(¡Oye![K] Ahora que lo pienso, a la mañana\nsiguiente al sueño...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner] said to me...)", french="([partner] m'a dit...)", german="([partner] sprach mit mir...)", italian="(... [partner] mi ha detto...)", spanish="([partner] me dijo...)"})
  else
  SkySceneKit.say({english="([partner] said to me...)", french="([partner] m'a dit...)", german="([partner] sprach mit mir...)", italian="(... [partner] mi ha detto...)", spanish="([partner] me dijo...)"})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(180) end)
  GAME:FadeOut(false, 30)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
