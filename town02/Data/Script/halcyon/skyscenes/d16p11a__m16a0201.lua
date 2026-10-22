-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D16P11A/m16a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D16P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(hero, 316, 140, false, 2)
  GROUND:MoveToPosition(partner, 284, 140, false, 2)
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Crystal Cave.ogg", true) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'm so curious, I had to come\nout here, but...", french="C'est la curiosité qui m'a\npoussé à venir ici, mais...", german="Ich war so neugierig, ich musste\neinfach hierherkommen, aber...", italian="Anch'io sono curioso. Volevo\ndavvero venire a dare un'occhiata, però...", spanish="Sentía tanta curiosidad que\nhe tenido que venir aquí, pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I got so curious, I had to come\nout here, but...", french="C'est la curiosité qui m'a\npoussé à venir ici, mais...", german="Ich war so neugierig, dass ich\neinfach herkommen musste, aber...", italian="Anch'io sono curioso. Volevo\ndavvero venire a dare un'occhiata, però...", spanish="Sentía tanta curiosidad que\nhe tenido que venir aquí, pero..."})
  else
  SkySceneKit.say({english="I got so curious, I couldn't help\ncoming out here, but...", french="C'est la curiosité qui m'a\npoussée à venir ici, mais...", german="Ich war so neugierig, dass ich\neinfach herkommen musste, aber...", italian="Anch'io sono curiosa. Volevo\ndavvero venire a dare un'occhiata, però...", spanish="Sentía tanta curiosidad que\nhe tenido que venir aquí, pero..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We shouldn't go in.", french=" ... on ne devrait pas entrer.", german=" Wir sollten nicht reingehen.", italian="No, penso che non dovremmo\nentrare.", spanish=" No deberíamos entrar."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We shouldn't go in.", french=" ... on ne devrait pas entrer.", german=" Wir sollten nicht reingehen.", italian="No, penso che non dovremmo\nentrare.", spanish=" No deberíamos entrar."})
  else
  SkySceneKit.say({english=" We shouldn't go in.", french=" ... on ne devrait pas entrer.", german=" Wir sollten nicht reingehen.", italian="No, penso che non dovremmo\nentrare.", spanish=" No deberíamos entrar."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The great [CS:N]Dusknoir[CR] told everyone\nto stay away.", french="Le grand [CS:N]Noctunoir[CR] a demandé\nà tout le monde de se tenir à l'écart.", german="Der große [CS:N]Zwirrfinst[CR] hat allen\ngesagt, dass sie sich fernhalten sollen.", italian="Il signor [CS:N]Dusknoir[CR] ha detto a\ntutti di non avvicinarsi.", spanish="El gran [CS:N]Dusknoir[CR] nos dijo bien\nclaro que no debíamos acercarnos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Didn't the great [CS:N]Dusknoir[CR] tell\neveryone to stay away?", french="Le grand [CS:N]Noctunoir[CR] a demandé\nà tout le monde de se tenir à l'écart.", german="Hat der große [CS:N]Zwirrfinst[CR] nicht\nallen gesagt, dass sie sich fernhalten sollen?", italian="Il signor [CS:N]Dusknoir[CR] ha detto a\ntutti di non avvicinarsi.", spanish="El gran [CS:N]Dusknoir[CR] nos dijo bien\nclaro que no debíamos acercarnos."})
  else
  SkySceneKit.say({english="Didn't the great [CS:N]Dusknoir[CR] tell\neveryone to stay away?", french="Le grand [CS:N]Noctunoir[CR] a demandé\nà tout le monde de se tenir à l'écart.", german="Hat der große [CS:N]Zwirrfinst[CR] nicht\nallen gesagt, dass sie sich fernhalten sollen?", italian="Il signor [CS:N]Dusknoir[CR] ha detto a\ntutti di non avvicinarsi.", spanish="El gran [CS:N]Dusknoir[CR] nos dijo bien\nclaro que no debíamos acercarnos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If we ignored that and went to\n[CS:P]Shining Lake[CR]...", french="Si on allait contre sa volonté\nen nous rendant au [CS:P]Lac Cristal[CR]...", german="Wenn wir das ignorieren und\nzum [CS:P]Kristallsee[CR] gehen...", italian="Se andassimo ugualmente al [CS:P]Lago[CR]\n[CS:P]di Cristallo[CR]...", spanish="Si no le hiciéramos caso y\nfuéramos al [CS:P]Lago Cristal[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If we defied that and went to\n[CS:P]Shining Lake[CR]...", french="Si on allait contre sa volonté\nen nous rendant au [CS:P]Lac Cristal[CR]...", german="Wenn wir trotzdem zum\n[CS:P]Kristallsee[CR] gehen...", italian="Se andassimo ugualmente al [CS:P]Lago[CR]\n[CS:P]di Cristallo[CR]...", spanish="Si no le hiciéramos caso y\nfuéramos al [CS:P]Lago Cristal[CR]..."})
  else
  SkySceneKit.say({english="If we ignored that and went to\n[CS:P]Shining Lake[CR]...", french="Si on allait contre sa volonté\nen nous rendant au [CS:P]Lac Cristal[CR]...", german="Wenn wir das ignorieren und\nzum [CS:P]Kristallsee[CR] gehen...", italian="Se andassimo ugualmente al [CS:P]Lago[CR]\n[CS:P]di Cristallo[CR]...", spanish="Si no le hiciéramos caso y\nfuéramos al [CS:P]Lago Cristal[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We'd end up ruining the plan!", french="On risquerait de tout faire\nrater!", german="Dann würden wir am Ende den\nPlan kaputt machen!", italian="... potremmo mandare a monte il\npiano!", spanish=" ¡Podríamos estropear el plan!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We may endanger the plan!", french="On risquerait de tout faire\nrater!", german="Dann könnten wir den Plan\ngefährden!", italian="... potremmo mettere a rischio il\npiano!", spanish="Podríamos poner el plan\nen peligro."})
  else
  SkySceneKit.say({english=" We might ruin the plan!", french="On risquerait de tout faire\nrater!", german="Dann könnten wir den Plan\nkaputt machen!", italian="... potremmo mettere a rischio il\npiano!", spanish=" ¡Podríamos arruinar el plan!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to stay out of this.\nLet's go back.", french="Mieux vaut ne pas s'en mêler.\nFaisons demi-tour.", german="Wir müssen uns raushalten.\nLass uns zurückgehen.", italian="È meglio se non c'immischiamo.\nTorniamo indietro.", spanish="Tenemos que alejarnos de aquí.\nDemos la vuelta."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We've got to stay out of this.\nLet's go back.", french="Mieux vaut ne pas s'en mêler.\nFaisons demi-tour.", german="Wir müssen uns raushalten.\nLass uns zurückgehen.", italian="È meglio se non c'immischiamo.\nTorniamo indietro.", spanish="Tenemos que alejarnos de aquí.\nDemos la vuelta."})
  else
  SkySceneKit.say({english="We have to stay out of this.\nLet's go back.", french="Mieux vaut ne pas s'en mêler.\nFaisons demi-tour.", german="Wir müssen uns raushalten.\nLass uns zurückgehen.", italian="È meglio se non c'immischiamo.\nTorniamo indietro.", spanish="Tenemos que alejarnos de aquí.\nDemos la vuelta."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(160) end)
  GROUND:MoveToPosition(partner, 284, 252, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 316, 252, false, 2)
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  -- main_SetGround(LEVEL_D16P11A) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterGround(LEVEL_P01P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
end
