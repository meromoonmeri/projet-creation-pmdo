-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s21p0208.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Oh, [hero].[K] I was just\nthinking...", french="Oh, [hero].[K] Je pensais\nà quelque chose...", german="Oh, [hero].[K] Ich überlege\ngerade...", italian="Oh, [hero].[K] Stavo\npensando...", spanish="Ah, [hero]...[K] He estado\npensando que..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh, [hero].[K] I was just\nthinking...", french="Oh, [hero].[K] Je pensais\nà quelque chose...", german="Oh, [hero].[K] Ich überlege\ngerade...", italian="Oh, [hero].[K] Stavo\npensando...", spanish="Ah, [hero]...[K] He estado\npensando que..."})
  else
  SkySceneKit.say({english="Oh, [hero].[K] I was just\nthinking...", french="Oh, [hero].[K] Je pensais\nà quelque chose...", german="Oh, [hero].[K] Ich überlege\ngerade...", italian="Oh, [hero].[K] Stavo\npensando...", spanish="Ah, [hero]...[K] He estado\npensando que..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It was time that was being\ndestroyed before, right?", french="La dernière fois, c'était le\ntemps qui allait être détruit, n'est-ce pas?", german="Vorher ging es darum, dass die\nZeit zerstört wurde, richtig?", italian="L'altra volta era il tempo che\nrischiava di essere distrutto, giusto?", spanish="Antes era el tiempo lo que se\nestaba destruyendo, ¿no?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It was time that was being\ndestroyed before, right?", french="La dernière fois, c'était le\ntemps qui allait être détruit, n'est-ce pas?", german="Vorher ging es darum, dass die\nZeit zerstört wurde, richtig?", italian="L'altra volta era il tempo che\nrischiava di essere distrutto, giusto?", spanish="Antes era el tiempo lo que se\nestaba destruyendo, ¿no?"})
  else
  SkySceneKit.say({english="It was time that was being\ndestroyed before, right?", french="La dernière fois, c'était le\ntemps qui allait être détruit, n'est-ce pas?", german="Vorher ging es darum, dass die\nZeit zerstört wurde, richtig?", italian="L'altra volta era il tempo che\nrischiava di essere distrutto, giusto?", spanish="Antes era el tiempo lo que se\nestaba destruyendo, ¿no?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And now the very fabric of\nspace is becoming distorted.", french="Et maintenant, c'est la trame de\nl'espace elle-même qui est menacée.", german="Und nun verzerrt sich das\nRaumgefüge.", italian="E adesso la struttura dello\nspazio viene distorta.", spanish="Y ahora es la estructura del\nespacio la que se está deformando."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And now the very fabric of\nspace is becoming distorted.", french="Et maintenant, c'est la trame de\nl'espace elle-même qui est menacée.", german="Und nun verzerrt sich das\nRaumgefüge.", italian="E adesso la struttura dello\nspazio viene distorta.", spanish="Y ahora es la estructura del\nespacio la que se está deformando."})
  else
  SkySceneKit.say({english="And now the very fabric of\nspace is becoming distorted.", french="Et maintenant, c'est la trame de\nl'espace elle-même qui est menacée.", german="Und nun verzerrt sich das\nRaumgefüge.", italian="E adesso la struttura dello\nspazio viene distorta.", spanish="Y ahora es la estructura del\nespacio la que se está deformando."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The destruction of time and the\ndistortion of space...[K] I can't begin to\nconceive of such things.", french="La destruction du temps et la\ndistorsion de l'espace...[K] ce sont des notions\nque j'ai du mal à concevoir.", german="Die Zerstörung der Zeit und die\nVerzerrung des Raumes...[K] Ich kann mir das gar\nnicht vorstellen.", italian="La distruzione del tempo e la\ndistorsione dello spazio...[K] Non riesco\na immaginare cose del genere.", spanish="La destrucción del tiempo y la\ndeformación del espacio...[K] Me cuesta\nimaginármelo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The destruction of time and the\ndistortion of space...[K] I can't begin to\nconceive of such things.", french="La destruction du temps et la\ndistorsion de l'espace...[K] ce sont des notions\nque j'ai du mal à concevoir.", german="Die Zerstörung der Zeit und die\nVerzerrung des Raumes...[K] Ich kann mir das gar\nnicht vorstellen.", italian="La distruzione del tempo e la\ndistorsione dello spazio...[K] Non riesco\na immaginare cose del genere.", spanish="La destrucción del tiempo y la\ndeformación del espacio...[K] Me cuesta\nimaginármelo."})
  else
  SkySceneKit.say({english="The destruction of time and the\ndistortion of space...[K] I can't begin to\nconceive of such things.", french="La destruction du temps et la\ndistorsion de l'espace...[K] ce sont des notions\nque j'ai du mal à concevoir.", german="Die Zerstörung der Zeit und die\nVerzerrung des Raumes...[K] Ich kann mir das gar\nnicht vorstellen.", italian="La distruzione del tempo e la\ndistorsione dello spazio...[K] Non riesco\na immaginare cose del genere.", spanish="La destrucción del tiempo y la\ndeformación del espacio...[K] Me cuesta\nimaginármelo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But these troubles of time and\nspace...[K] I have a feeling that they're related.", french="Ces destructions du temps et\nde l'espace...[K] j'ai le sentiment\nqu'elles sont étroitement liées.", german="Aber die Zerstörung von Zeit\nund Raum...[K] Das muss irgendwie\nzusammenhängen.", italian="Ma questi due fenomeni...[K]\nHo l'impressione che siano collegati.", spanish="Aunque tengo la sensación...[K]\nde que ambos problemas podrían estar\nrelacionados."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But these troubles of time and\nspace...[K] I have a feeling that they're related.", french="Ces destructions du temps et\nde l'espace...[K] j'ai le sentiment\nqu'elles sont étroitement liées.", german="Aber die Zerstörung von Zeit\nund Raum...[K] Das muss irgendwie\nzusammenhängen.", italian="Ma questi due fenomeni...[K]\nHo l'impressione che siano collegati.", spanish="Aunque tengo la sensación...[K]\nde que ambos problemas podrían estar\nrelacionados."})
  else
  SkySceneKit.say({english="But these troubles of time and\nspace...[K] I have a feeling that they're related.", french="Ces destructions du temps et\nde l'espace...[K] j'ai le sentiment\nqu'elles sont étroitement liées.", german="Aber die Zerstörung von Zeit\nund Raum...[K] Das muss irgendwie\nzusammenhängen.", italian="Ma questi due fenomeni...[K]\nHo l'impressione che siano collegati.", spanish="Aunque tengo la sensación...[K]\nde que ambos problemas podrían estar\nrelacionados."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Time and space...[K] A possible connection...?)", french="(Temps et espace...[K] y aurait-il un lien...?)", german="(Zeit und Raum...[K] Ein möglicher\nZusammenhang?)", italian="(Tempo e spazio...[K] Un possibile legame...?)", spanish="(El tiempo y el espacio...[K] ¿Conectados?)"})
  else
  SkySceneKit.say({english="(Time and space...[K] A possible connection...?)", french="(Temps et espace...[K] y aurait-il un lien...?)", german="(Zeit und Raum...[K] Ein möglicher\nZusammenhang?)", italian="(Tempo e spazio...[K] Un possibile legame...?)", spanish="(El tiempo y el espacio...[K] ¿Conectados?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Do you remember when time\nwas breaking down?", french="Tu te rappelles quand le temps\nse détraquait?", german="Erinnerst du dich, als die Zeit\nzusammenbrach?", italian="Ti ricordi quando il tempo\nrischiava di essere distrutto?", spanish="¿Te acuerdas de cuando el\ntiempo se estaba desmoronando?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Do you remember when time\nwas breaking down?", french="Tu te rappelles quand le temps\nse détraquait?", german="Erinnerst du dich, als die Zeit\nzusammenbrach?", italian="Ti ricordi quando il tempo\nrischiava di essere distrutto?", spanish="¿Te acuerdas de cuando el\ntiempo se estaba desmoronando?"})
  else
  SkySceneKit.say({english="Do you remember when time\nwas breaking down?", french="Tu te rappelles quand le temps\nse détraquait?", german="Erinnerst du dich, als die Zeit\nzusammenbrach?", italian="Ti ricordi quando il tempo\nrischiava di essere distrutto?", spanish="¿Te acuerdas de cuando el\ntiempo se estaba desmoronando?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Lapras[CR] gave us a lot of insight\ninto [CS:P]Temporal Tower[CR].", french="[CS:N]Lokhlass[CR] nous a expliqué\nbeaucoup de choses sur la [CS:P]Tour du Temps[CR].", german="[CS:N]Lapras[CR] gab uns viele Einblicke\nin den [CS:P]Zeitturm[CR].", italian="[CS:N]Lapras[CR] ci ha fatto capire molte\ncose riguardo la [CS:P]Torre del Tempo[CR].", spanish="[CS:N]Lapras[CR] nos lo hizo comprender\nen la [CS:P]Torre del Tiempo[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Lapras[CR] gave us a lot of insight\ninto [CS:P]Temporal Tower[CR].", french="[CS:N]Lokhlass[CR] nous a expliqué\nbeaucoup de choses sur la [CS:P]Tour du Temps[CR].", german="[CS:N]Lapras[CR] gab uns viele Einblicke\nin den [CS:P]Zeitturm[CR].", italian="[CS:N]Lapras[CR] ci ha fatto capire molte\ncose riguardo la [CS:P]Torre del Tempo[CR].", spanish="[CS:N]Lapras[CR] nos lo hizo comprender\nen la [CS:P]Torre del Tiempo[CR]."})
  else
  SkySceneKit.say({english="[CS:N]Lapras[CR] gave us a lot of insight\ninto [CS:P]Temporal Tower[CR].", french="[CS:N]Lokhlass[CR] nous a expliqué\nbeaucoup de choses sur la [CS:P]Tour du Temps[CR].", german="[CS:N]Lapras[CR] gab uns viele Einblicke\nin den [CS:P]Zeitturm[CR].", italian="[CS:N]Lapras[CR] ci ha dato tanti\nindizi sulla [CS:P]Torre del Tempo[CR].", spanish="[CS:N]Lapras[CR] nos lo hizo comprender\nen la [CS:P]Torre del Tiempo[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So about this distortion of\nspace...", french="Donc, en ce qui concerne la\ndistorsion de l'espace...", german="Also, was die Verzerrung des\nRaumes angeht...", italian="Quindi, in merito a questa\ndistorsione dello spazio...", spanish="En cuanto a la deformación del\nespacio..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So about this distortion of\nspace...", french="Donc, en ce qui concerne la\ndistorsion de l'espace...", german="Also, was die Verzerrung des\nRaumes angeht...", italian="Quindi, in merito a questa\ndistorsione dello spazio...", spanish="En cuanto a la deformación del\nespacio..."})
  else
  SkySceneKit.say({english="So about this distortion of\nspace...", french="Donc, en ce qui concerne la\ndistorsion de l'espace...", german="Also, was die Verzerrung des\nRaumes angeht...", italian="Quindi, in merito a questa\ndistorsione dello spazio...", spanish="En cuanto a la deformación del\nespacio..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Do you think [CS:N]Lapras[CR] might know\nsomething about it?", french="... tu crois que [CS:N]Lokhlass[CR] sait\nquelque chose aussi?", german="Denkst du, [CS:N]Lapras[CR] könnte\ndarüber etwas wissen?", italian="Pensi che [CS:N]Lapras[CR] potrebbe\nsaperne qualcosa?", spanish="¿Crees que [CS:N]Lapras[CR] podría saber\nalgo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Do you think [CS:N]Lapras[CR] might know\nsomething about it?", french="... tu crois que [CS:N]Lokhlass[CR] sait\nquelque chose aussi?", german="Denkst du, [CS:N]Lapras[CR] könnte\ndarüber etwas wissen?", italian="Pensi che [CS:N]Lapras[CR] potrebbe\nsaperne qualcosa?", spanish="¿Crees que [CS:N]Lapras[CR] podría saber\nalgo?"})
  else
  SkySceneKit.say({english="Do you think [CS:N]Lapras[CR] might know\nsomething about it?", french="... tu crois que [CS:N]Lokhlass[CR] sait\nquelque chose aussi?", german="Denkst du, [CS:N]Lapras[CR] könnte\ndarüber etwas wissen?", italian="Pensi che [CS:N]Lapras[CR] potrebbe\nsaperne qualcosa?", spanish="¿Crees que [CS:N]Lapras[CR] podría saber\nalgo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:N]Lapras[CR]...?)", french="([CS:N]Lokhlass[CR]...?)", german="([CS:N]Lapras[CR]?)", italian="([CS:N]Lapras[CR]...?)", spanish="(¿[CS:N]Lapras[CR]...?)"})
  else
  SkySceneKit.say({english="([CS:N]Lapras[CR]...?)", french="([CS:N]Lokhlass[CR]...?)", german="([CS:N]Lapras[CR]?)", italian="([CS:N]Lapras[CR]...?)", spanish="(¿[CS:N]Lapras[CR]...?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Well...[K] Actually...)", french="(Euh...[K] en fait...)", german="(Nun ja...[K] Eigentlich...)", italian="(Beh...[K] In realtà...)", spanish="(Bueno...[K] La verdad...)"})
  else
  SkySceneKit.say({english="(Well...[K] Actually...)", french="(Euh...[K] en fait...)", german="(Nun ja...[K] Eigentlich...)", italian="(Beh...[K] In realtà...)", spanish="(Bueno...[K] La verdad...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It wouldn't be unusual if [CS:N]Lapras[CR] did know\nsomething about this...)", french="(Je ne serais pas étonné si [CS:N]Lokhlass[CR] savait\nquelque chose à ce sujet...)", german="(Es wäre nicht verwunderlich, wenn [CS:N]Lapras[CR]\netwas darüber wüsste.)", italian="(Non sarebbe strano se [CS:N]Lapras[CR] ne sapesse\nqualcosa...)", spanish="(No sería de extrañar que [CS:N]Lapras[CR] supiera\nalgo de todo esto...)"})
  else
  SkySceneKit.say({english="(It wouldn't be unusual if [CS:N]Lapras[CR] did know\nsomething about this...)", french="(Je ne serais pas étonnée si [CS:N]Lokhlass[CR] savait\nquelque chose à ce sujet...)", german="(Es wäre nicht verwunderlich, wenn [CS:N]Lapras[CR]\netwas darüber wüsste.)", italian="(Non sarebbe strano se [CS:N]Lapras[CR] ne sapesse\nqualcosa...)", spanish="(No sería de extrañar que [CS:N]Lapras[CR] supiera\nalgo de todo esto...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yeah, you think so too,\n[hero].", french="Ouais! Je savais que tu\nserais d'accord avec moi,\n[hero].", german=" Nicht wahr, [hero]?", italian="Sì, penso tu sia d'accordo con\nme, [hero].", spanish="Sabía que estarías de acuerdo\nconmigo, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I thought you'd think so too,\n[hero].", french="Ouais! Je savais que tu\nserais d'accord avec moi,\n[hero].", german="Ich dachte mir, dass du so\ndenkst, [hero].", italian="Penso che tu sia d'accordo con\nme, [hero].", spanish="Sabía que estarías de acuerdo\nconmigo, [hero]."})
  else
  SkySceneKit.say({english="I knew you'd agree with me,\n[hero].", french="Ouais! Je savais que tu\nserais d'accord avec moi,\n[hero].", german="Ich wusste, du würdest mir\nzustimmen, [hero].", italian="Penso che tu sia d'accordo con\nme, [hero].", spanish="Sabía que estarías de acuerdo\nconmigo, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Then let's go see [CS:N]Lapras[CR]!", french=" Bien, alors allons voir [CS:N]Lokhlass[CR]!", german=" Gehen wir zu [CS:N]Lapras[CR]!", italian=" Allora andiamo a trovare [CS:N]Lapras[CR]!", spanish="¡Entonces vayamos a ver a\n[CS:N]Lapras[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well, then that settles it! Let's\ngo see [CS:N]Lapras[CR]!", french=" Bien, alors allons voir [CS:N]Lokhlass[CR]!", german="Okay, das wäre geregelt! Machen\nwir uns auf zu [CS:N]Lapras[CR]!", italian="Bene, allora è deciso! Andiamo a\ntrovare [CS:N]Lapras[CR]!", spanish="¡Entonces vayamos a ver a\n[CS:N]Lapras[CR]!"})
  else
  SkySceneKit.say({english="Well, that's that, then! Let's go\nsee [CS:N]Lapras[CR]!", french=" Bien, alors allons voir [CS:N]Lokhlass[CR]!", german="Okay, das wäre geklärt! Machen\nwir uns auf zu [CS:N]Lapras[CR]!", italian="Bene, allora è deciso! Andiamo a\ntrovare [CS:N]Lapras[CR]!", spanish="¡Entonces vayamos a ver a\n[CS:N]Lapras[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Lapras[CR] should be at the beach.", french="[CS:N]Lokhlass[CR] devrait être à la\nplage.", german=" [CS:N]Lapras[CR] sollte am Strand sein.", italian="[CS:N]Lapras[CR] dovrebbe\nessere in spiaggia.", spanish="[CS:N]Lapras[CR] debería de estar en\nla playa."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Lapras[CR] should be at the beach.", french="[CS:N]Lokhlass[CR] devrait être à la\nplage.", german=" [CS:N]Lapras[CR] sollte am Strand sein.", italian="[CS:N]Lapras[CR] dovrebbe\nessere in spiaggia.", spanish="[CS:N]Lapras[CR] debería de estar en\nla playa."})
  else
  SkySceneKit.say({english=" [CS:N]Lapras[CR] should be at the beach.", french="[CS:N]Lokhlass[CR] devrait être à la\nplage.", german=" [CS:N]Lapras[CR] sollte am Strand sein.", italian="[CS:N]Lapras[CR] dovrebbe\nessere in spiaggia.", spanish="[CS:N]Lapras[CR] debería de estar en\nla playa."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So let's hurry to the beach,\n[hero]!", french=" Dépêchons-nous, [hero]!", german="Ab zum Strand mit uns,\n[hero]!", italian="Forza, andiamo in spiaggia,\n[hero]!", spanish="¡Vámonos para allá,\n[hero]! ¡Deprisa!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So let's hurry to the beach,\n[hero]!", french=" Dépêchons-nous, [hero]!", german="Ab zum Strand mit uns,\n[hero]!", italian="Forza, andiamo in spiaggia,\n[hero]!", spanish="¡Vámonos para allá,\n[hero]! ¡Deprisa!"})
  else
  SkySceneKit.say({english="So let's hurry to the beach,\n[hero]!", french=" Dépêchons-nous, [hero]!", german="Ab zum Strand mit uns,\n[hero]!", italian="Forza, andiamo in spiaggia,\n[hero]!", spanish="¡Vámonos para allá,\n[hero]! ¡Deprisa!"})
  end
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
