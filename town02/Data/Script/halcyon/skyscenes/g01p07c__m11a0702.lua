-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m11a0702.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P06A) [décor sub chargé: Sub_v02p06a]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v02p06a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(150)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(60)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Just before dinner, [CS:N]Chatot[CR] said\nanother Time Gear was stolen.", french="Juste avant le dîner, [CS:N]Pijako[CR]\na annoncé qu'un autre Rouage du Temps avait\ndisparu.", german="Vor dem Essen sagte [CS:N]Plaudagei[CR],\ndass noch ein Zahnrad der Zeit gestohlen\nwurde.", italian="Prima di cena, [CS:N]Chatot[CR] ha detto\nche un altro Ingranaggio del Tempo è stato\nrubato.", spanish="Justo antes de la cena, [CS:N]Chatot[CR]\nnos contó que han robado otro Engranaje del\nTiempo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Just before dinner, [CS:N]Chatot[CR] said\nanother Time Gear was stolen.", french="Juste avant le dîner, [CS:N]Pijako[CR]\na annoncé qu'un autre Rouage du Temps avait\ndisparu.", german="Vor dem Essen sagte [CS:N]Plaudagei[CR],\ndass noch ein Zahnrad der Zeit gestohlen\nwurde.", italian="Prima di cena, [CS:N]Chatot[CR] ha detto\nche un altro Ingranaggio del Tempo è stato\nrubato.", spanish="Justo antes de la cena, [CS:N]Chatot[CR]\nnos contó que han robado otro Engranaje del\nTiempo."})
  else
  SkySceneKit.say({english="Just before dinner, [CS:N]Chatot[CR] said\nanother Time Gear was stolen.", french="Juste avant le dîner, [CS:N]Pijako[CR]\na annoncé qu'un autre Rouage du Temps avait\ndisparu.", german="Vor dem Essen sagte [CS:N]Plaudagei[CR],\ndass noch ein Zahnrad der Zeit gestohlen\nwurde.", italian="Prima di cena, [CS:N]Chatot[CR] ha detto\nche un altro Ingranaggio del Tempo è stato\nrubato.", spanish="Justo antes de la cena, [CS:N]Chatot[CR]\nnos contó que han robado otro Engranaje del\nTiempo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That makes two now! Who'd go\naround stealing them?", french="Ça en fait deux maintenant!\nMais qui peut bien s'amuser à les voler?", german="Das macht schon zwei!\nWer stiehlt die bloß?", italian="Ne hanno rubati due, per ora!\nMa chi sarà stato?", spanish="Ya van dos. ¿Quién los habrá\nrobado?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's two now! I can't imagine\nwho'd be stealing them!", french="Ça en fait deux maintenant!\nMais qui peut bien s'amuser à les voler?", german="Jetzt sind es schon zwei!\nIch kann mir nicht vorstellen, wer sie stiehlt!", italian="Ne hanno rubati due, per ora!\nMa chi potrebbe essere?", spanish="Ya van dos. No puedo ni\nimaginarme quién puede estar detrás\nde algo así."})
  else
  SkySceneKit.say({english="That's two now! I can't imagine\nwho'd be stealing them!", french="Ça en fait deux maintenant!\nMais qui peut bien s'amuser à les voler?", german="Jetzt sind es schon zwei!\nIch kann mir nicht vorstellen, wer sie stiehlt!", italian="Ne hanno rubati due, per ora!\nMa chi potrebbe essere?", spanish="Ya van dos. No me entra\nen la cabeza que alguien pudiera hacer\nalgo así."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What would anyone want with\nthe Time Gears anyway?", french="Qu'est-ce qu'on peut bien\nen faire de toute façon?", german="Was sollte irgendwer überhaupt\nmit Zahnrädern der Zeit anstellen wollen?", italian="Cosa potrebbero mai farsene\ndegli Ingranaggi del Tempo?", spanish="¿Para qué querría nadie\nllevarse los Engranajes del Tiempo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What would anyone want with\nthe Time Gears anyway?", french="Qu'est-ce qu'on peut bien\nen faire de toute façon?", german="Was sollte irgendwer überhaupt\nmit Zahnrädern der Zeit anstellen wollen?", italian="A che scopo rubare gli\nIngranaggi del Tempo?", spanish="¿Para qué querría nadie\nllevarse los Engranajes del Tiempo?"})
  else
  SkySceneKit.say({english="What would anyone want with\nthe Time Gears anyway?", french="Qu'est-ce qu'on peut bien\nen faire de toute façon?", german="Was sollte irgendwer überhaupt\nmit Zahnrädern der Zeit anstellen wollen?", italian="A che scopo rubare gli\nIngranaggi del Tempo?", spanish="¿Para qué querría nadie\nllevarse los Engranajes del Tiempo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I just don't know...", french=" Ça me dépasse...", german=" Ich weiß es nicht...", italian=" Boh? Davvero non capisco...", spanish=" No lo entiendo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I just don't understand...", french=" Ça me dépasse...", german=" Ich verstehe das nicht...", italian=" Non riesco proprio a capire...", spanish=" No lo entiendo..."})
  else
  SkySceneKit.say({english=" I just can't figure it out...", french=" Ça me dépasse...", german=" Ich kapiere es einfach nicht...", italian=" Non riesco proprio a capire...", spanish=" No lo entiendo..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  else
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I don't know either...)", french="(Moi aussi, ça me dépasse...)", german="(Ich weiß es auch nicht...)", italian="(Nemmeno io riesco a capire il motivo.)", spanish="(Yo tampoco...)"})
  else
  SkySceneKit.say({english="(I don't know either...)", french="(Moi aussi, ça me dépasse...)", german="(Ich weiß es auch nicht...)", italian="(Nemmeno io riesco a capire il motivo.)", spanish="(Yo tampoco...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But when I was at [CS:P]Fogbound Lake[CR] and saw a\nTime Gear for the first time...)", french="(Mais au [CS:P]Lac des Brumes[CR], quand j'ai vu\nun Rouage du Temps pour la première fois...)", german="(Aber als ich am [CS:P]Nebelsee[CR] zum ersten Mal ein\nZahnrad der Zeit sah...)", italian="(Ma quella volta al [CS:P]Lago Foschia[CR], quando ho\nvisto l'Ingranaggio del Tempo per la prima\nvolta...)", spanish="(Pero cuando estuve en el [CS:P]Lago Velado[CR] y vi\nun Engranaje del Tiempo por primera vez...)"})
  else
  SkySceneKit.say({english="(But when I was at [CS:P]Fogbound Lake[CR] and saw a\nTime Gear for the first time...)", french="(Mais au [CS:P]Lac des Brumes[CR], quand j'ai vu\nun Rouage du Temps pour la première fois...)", german="(Aber als ich am [CS:P]Nebelsee[CR] zum ersten Mal ein\nZahnrad der Zeit sah...)", italian="(Ma quella volta al [CS:P]Lago Foschia[CR], quando ho\nvisto l'Ingranaggio del Tempo per la prima\nvolta...)", spanish="(Pero cuando estuve en el [CS:P]Lago Velado[CR] y vi\nun Engranaje del Tiempo por primera vez...)"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
