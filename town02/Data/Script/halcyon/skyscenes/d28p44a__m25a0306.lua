-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D28P44A/m25a0306.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D28P44A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: SetEffect 653 — VFX sans émote PMDO équivalente
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" His last words...[K] Parting hurts...", french="Ses dernières paroles...[K]\n\"La séparation est toujours douloureuse...\"", german="Seine letzten Worte...[K] Trennung\nschmerzt...", italian="Le sue ultime parole...[K]\nGli addii sono dolorosi...", spanish="Sus últimas palabras...[K]\n\"Separarse es duro...\""})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" His last words...[K] Parting hurts...", french="Ses dernières paroles...[K]\n\"La séparation est toujours douloureuse...\"", german="Seine letzten Worte...[K] Trennung\nschmerzt...", italian="Le sue ultime parole...[K]\nGli addii sono dolorosi...", spanish="Sus últimas palabras...[K]\n\"Separarse es duro...\""})
  else
  SkySceneKit.say({english=" His last words...[K] Parting hurts...", french="Ses dernières paroles...[K]\n\"La séparation est toujours douloureuse...\"", german="Seine letzten Worte...[K] Trennung\nschmerzt...", italian="Le sue ultime parole...[K]\nGli addii sono dolorosi...", spanish="Sus últimas palabras...[K]\n\"Separarse es duro...\""})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I understand that feeling.\nI understand how it hurts.", french="Je comprends ce qu'il a ressenti.\nJe sais bien à quel point ça fait mal.", german="Ich kenne das Gefühl.\nIch verstehe, wie weh es tut.", italian="Credo di capire come si sentisse.\nCapisco quanto può far male.", spanish="Lo entiendo perfectamente. Sé lo\ndifícil que tiene que resultar."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I understand that feeling.\nI understand how it hurts.", french="Je comprends ce qu'il a ressenti.\nJe sais bien à quel point ça fait mal.", german="Ich kenne das Gefühl.\nIch verstehe, wie weh es tut.", italian="Credo di capire come si sentisse.\nCapisco quanto può far male.", spanish="Lo entiendo perfectamente. Sé lo\ndifícil que tiene que resultar."})
  else
  SkySceneKit.say({english="I understand that feeling.\nI understand how it hurts.", french="Je comprends ce qu'il a ressenti.\nJe sais bien à quel point ça fait mal.", german="Ich kenne das Gefühl.\nIch verstehe, wie weh es tut.", italian="Credo di capire come si sentisse.\nCapisco quanto può far male.", spanish="Lo entiendo perfectamente. Sé lo\ndifícil que tiene que resultar."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Grovyle[CR] was partners with\nyou for a long time, [hero].", french="[CS:N]Massko[CR] et toi avez été\npartenaires pendant longtemps, [hero].", german="[CS:N]Reptain[CR] war lange Zeit dein\nPartner, [hero].", italian="[CS:N]Grovyle[CR] ha passato tanto tempo\ncon te, [hero].", spanish="[CS:N]Grovyle[CR] y tú fuisteis\ncompañeros durante mucho tiempo,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Grovyle[CR] was partners with\nyou for a long time, [hero].", french="[CS:N]Massko[CR] et toi avez été\npartenaires pendant longtemps, [hero].", german="[CS:N]Reptain[CR] war lange Zeit dein\nPartner, [hero].", italian="[CS:N]Grovyle[CR] ha passato tanto tempo\ncon te, [hero].", spanish="[CS:N]Grovyle[CR] y tú fuisteis\ncompañeros durante mucho tiempo,\n[hero]."})
  else
  SkySceneKit.say({english="[CS:N]Grovyle[CR] was partners with\nyou for a long time, [hero].", french="[CS:N]Massko[CR] et toi avez été\npartenaires pendant longtemps, [hero].", german="[CS:N]Reptain[CR] war lange Zeit dein\nPartner, [hero].", italian="[CS:N]Grovyle[CR] ha passato tanto tempo\ncon te, [hero].", spanish="[CS:N]Grovyle[CR] y tú fuisteis\ncompañeros durante mucho tiempo,\n[hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I think it must have hurt\n[CS:N]Grovyle[CR] terribly to leave you.", french="Ça a dû être déchirant pour lui\nde te quitter.", german="Es muss [CS:N]Reptain[CR] fürchterlich\nwehgetan haben, dich zurückzulassen.", italian="Per [CS:N]Grovyle[CR] dev'essere stato\nterribile abbandonarti.", spanish="A [CS:N]Grovyle[CR] tiene que haberle\nresultado terriblemente duro separarse de ti."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I think it must have hurt\n[CS:N]Grovyle[CR] terribly to leave you.", french="Ça a dû être déchirant pour lui\nde te quitter.", german="Es muss [CS:N]Reptain[CR] fürchterlich\nwehgetan haben, dich zurückzulassen.", italian="Per [CS:N]Grovyle[CR] dev'essere stato\nterribile abbandonarti.", spanish="A [CS:N]Grovyle[CR] tiene que haberle\nresultado terriblemente duro separarse de ti."})
  else
  SkySceneKit.say({english="I think it must have hurt\n[CS:N]Grovyle[CR] terribly to leave you.", french="Ça a dû être déchirant pour lui\nde te quitter.", german="Es muss [CS:N]Reptain[CR] fürchterlich\nwehgetan haben, dich zurückzulassen.", italian="Per [CS:N]Grovyle[CR] dev'essere stato\nterribile abbandonarti.", spanish="A [CS:N]Grovyle[CR] tiene que haberle\nresultado terriblemente duro separarse de ti."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  else
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That may be what he meant...)", french="(C'est peut-être ça qu'il voulait dire...)", german="(Vielleicht hat er das gemeint...)", italian="(Forse si riferiva a questo...)", spanish="(Tal vez eso fuera lo que quería decir...)"})
  else
  SkySceneKit.say({english="(That may be what he meant...)", french="(C'est peut-être ça qu'il voulait dire...)", german="(Vielleicht hat er das gemeint...)", italian="(Forse si riferiva a questo...)", spanish="(Tal vez eso fuera lo que quería decir...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But no. That isn't it.)", french="(Non, je ne crois pas.)", german="(Aber nein. Das ist es nicht.)", italian="(Ma no. Non è così.)", spanish="(Pero no. No se trataba de eso.)"})
  else
  SkySceneKit.say({english="(But no. That isn't it.)", french="(Non, je ne crois pas.)", german="(Aber nein. Das ist es nicht.)", italian="(Ma no. Non è così.)", spanish="(Pero no. No se trataba de eso.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:N]Grovyle[CR]'s last words...)", french="(Les dernières paroles de [CS:N]Massko[CR]...)", german="(Die letzten Worte von [CS:N]Reptain[CR]...)", italian="(Le ultime parole di [CS:N]Grovyle[CR]...)", spanish="(Las últimas palabras de [CS:N]Grovyle[CR]...)"})
  else
  SkySceneKit.say({english="([CS:N]Grovyle[CR]'s last words...)", french="(Les dernières paroles de [CS:N]Massko[CR]...)", german="(Die letzten Worte von [CS:N]Reptain[CR]...)", italian="(Le ultime parole di [CS:N]Grovyle[CR]...)", spanish="(Las últimas palabras de [CS:N]Grovyle[CR]...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(They weren't about me and [CS:N]Grovyle[CR].)", french="(Elles ne concernaient pas mon amitié avec\n[CS:N]Massko[CR].)", german="(Sie waren nicht über mich und [CS:N]Reptain[CR].)", italian="(No, non riguardavano me e [CS:N]Grovyle[CR].)", spanish="(No se referían a [CS:N]Grovyle[CR] y a mí.)"})
  else
  SkySceneKit.say({english="(They weren't about me and [CS:N]Grovyle[CR].)", french="(Elles ne concernaient pas mon amitié avec\n[CS:N]Massko[CR].)", german="(Sie waren nicht über mich und [CS:N]Reptain[CR].)", italian="(No, non riguardavano me e [CS:N]Grovyle[CR].)", spanish="(No se referían a [CS:N]Grovyle[CR] y a mí.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(He meant me and [partner].)", french="(Il parlait de moi et [partner].)", german="(Er meinte mich und [partner].)", italian="(Lui si riferiva a me e a [partner].)", spanish="(Sino a [partner] y a mí.)"})
  else
  SkySceneKit.say({english="(He meant me and [partner].)", french="(Il parlait de moi et [partner].)", german="(Er meinte mich und [partner].)", italian="(Lui si riferiva a me e a [partner].)", spanish="(Sino a [partner] y a mí.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:N]Grovyle[CR] said what he did...[K]because he knew\nthat I would have to leave [partner]\neventually.)", french="([CS:N]Massko[CR] a dit ça...[K] parce qu'il savait\nque je devrais quitter [partner] un jour\nou l'autre.)", german="([CS:N]Reptain[CR] sagte das,[K] weil er wusste,\ndass ich [partner] irgendwann verlassen\nmuss.)", italian="([CS:N]Grovyle[CR] ha detto quelle parole...[K] perché\nsapeva che alla fine dovrò abbandonare\n[partner].)", spanish="(Dijo lo que dijo...[K] porque sabía que tarde\no temprano tendré que abandonar\na [partner].)"})
  else
  SkySceneKit.say({english="([CS:N]Grovyle[CR] said what he did...[K]because he knew\nthat I would have to leave [partner]\neventually.)", french="([CS:N]Massko[CR] a dit ça...[K] parce qu'il savait\nque je devrais quitter [partner] un jour\nou l'autre.)", german="([CS:N]Reptain[CR] sagte das,[K] weil er wusste,\ndass ich [partner] irgendwann verlassen\nmuss.)", italian="([CS:N]Grovyle[CR] ha detto quelle parole...[K] perché\nsapeva che alla fine dovrò abbandonare\n[partner].)", spanish="(Dijo lo que dijo...[K] porque sabía que tarde\no temprano tendré que abandonar\na [partner].)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(When history is changed...[K]I will disappear.)", french="(Quand on aura modifié le cours de\nl'histoire...[K] je disparaîtrai.)", german="(Wenn die Geschichte verändert wird,[K] werde\nich verschwinden.)", italian="(Quando cambieremo la storia...[K] io\nscomparirò.)", spanish="(Cuando cambie la historia...[K] desapareceré.)"})
  else
  SkySceneKit.say({english="(When history is changed...[K]I will disappear.)", french="(Quand on aura modifié le cours de\nl'histoire...[K] je disparaîtrai.)", german="(Wenn die Geschichte verändert wird,[K] werde\nich verschwinden.)", italian="(Quando cambieremo la storia...[K] io\nscomparirò.)", spanish="(Cuando cambie la historia...[K] desapareceré.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(My time together with [partner] is\nending...)", french="(Mon association avec [partner] touche\nà sa fin...)", german="(Meine Zeit mit [partner] geht ihrem Ende\nentgegen...)", italian="(Il tempo che ho a disposizione per stare\ninsieme a [partner] sta volgendo al\ntermine...)", spanish="(Mi tiempo con [partner] toca a su fin.)"})
  else
  SkySceneKit.say({english="(My time together with [partner] is\nending...)", french="(Mon association avec [partner] touche\nà sa fin...)", german="(Meine Zeit mit [partner] geht ihrem Ende\nentgegen...)", italian="(Il tempo che ho a disposizione per stare\ninsieme a [partner] sta volgendo al\ntermine...)", spanish="(Mi tiempo con [partner] toca a su fin.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(This is our last adventure.)", french="(C'est notre dernière aventure ensemble.)", german="(Dies ist unser letztes Abenteuer.)", italian="(Questa è la nostra ultima avventura.)", spanish="(Esta es nuestra última aventura.)"})
  else
  SkySceneKit.say({english="(This is our last adventure.)", french="(C'est notre dernière aventure ensemble.)", german="(Dies ist unser letztes Abenteuer.)", italian="(Questa è la nostra ultima avventura.)", spanish="(Esta es nuestra última aventura.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 276, 220, false, 2)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(268, 212, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [hero]!", french=" Eh, [hero]!", german=" Hey, [hero]!", italian=" Ehi, [hero]!", spanish=" ¡Oye, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey, [hero]!", french=" Eh, [hero]!", german=" Hey, [hero]!", italian=" Ehi, [hero]!", spanish=" ¡Oye, [hero]!"})
  else
  SkySceneKit.say({english=" Hey, [hero]!", french=" Eh, [hero]!", german=" Hey, [hero]!", italian=" Ehi, [hero]!", spanish=" ¡Oye, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to do this for [CS:N]Grovyle[CR]'s\nsake! Let's go to [CS:P]Temporal Tower[CR]!", french="Il faut qu'on y arrive,\npour [CS:N]Massko[CR]! C'est parti pour la [CS:P]Tour\ndu Temps[CR]!", german="Wir müssen das [CS:N]Reptain[CR] zuliebe\ntun! Gehen wir zum [CS:P]Zeitturm[CR]!", italian="Dobbiamo farlo per [CS:N]Grovyle[CR]!\nAndiamo alla [CS:P]Torre del Tempo[CR]!", spanish="¡Tenemos que hacer esto por\n[CS:N]Grovyle[CR]! ¡Vamos a la [CS:P]Torre del Tiempo[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to do this for [CS:N]Grovyle[CR]'s\nsake! Let's go to [CS:P]Temporal Tower[CR]!", french="Il faut qu'on y arrive,\npour [CS:N]Massko[CR]! C'est parti pour la [CS:P]Tour\ndu Temps[CR]!", german="Wir müssen das [CS:N]Reptain[CR] zuliebe\ntun! Gehen wir zum [CS:P]Zeitturm[CR]!", italian="Dobbiamo farlo per [CS:N]Grovyle[CR]!\nAndiamo alla [CS:P]Torre del Tempo[CR]!", spanish="¡Tenemos que hacer esto por\n[CS:N]Grovyle[CR]! ¡Vamos a la [CS:P]Torre del Tiempo[CR]!"})
  else
  SkySceneKit.say({english="We have to do this for [CS:N]Grovyle[CR]'s\nsake! Let's go to [CS:P]Temporal Tower[CR]!", french="Il faut qu'on y arrive,\npour [CS:N]Massko[CR]! C'est parti pour la [CS:P]Tour\ndu Temps[CR]!", german="Wir müssen das [CS:N]Reptain[CR] zuliebe\ntun! Gehen wir zum [CS:P]Zeitturm[CR]!", italian="Dobbiamo farlo per [CS:N]Grovyle[CR]!\nAndiamo alla [CS:P]Torre del Tempo[CR]!", spanish="¡Tenemos que hacer esto por\n[CS:N]Grovyle[CR]! ¡Vamos a la [CS:P]Torre del Tiempo[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  pcall(function() SOUND:FadeOutBGM(180) end)
  GAME:FadeOut(false,  90)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
end
