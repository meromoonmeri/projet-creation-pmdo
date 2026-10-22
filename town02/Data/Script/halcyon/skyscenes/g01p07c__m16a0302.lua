-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m16a0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(17, 2) -- $SCENARIO_MAIN = scn[17,2] (ROM)
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
  GAME:WaitFrames(1)
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.Left)
  -- SetAnimation(76) [anim idle native]
  -- SetAnimation(76) [anim idle native]
  GAME:FadeIn(60) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...............", french=" ...............", german=" ...............", italian=" ...............", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...............", french=" ...............", german=" ...............", italian=" ...............", spanish=" ..."})
  else
  SkySceneKit.say({english=" ...............", french=" ...............", german=" ...............", italian=" ...............", spanish=" ..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...........................", french=" ...........................", german=" ...........................", italian=" ...........................", spanish=" ... ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...........................", french=" ...........................", german=" ...........................", italian=" ...........................", spanish=" ... ..."})
  else
  SkySceneKit.say({english=" ...........................", french=" ...........................", german=" ...........................", italian=" ...........................", spanish=" ... ..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Are you still awake,\n[hero]?", french=" Tu dors, [hero]?", german="Bist du noch wach,\n[hero]?", italian="Non riesci a dormire,\n[hero]?", spanish="¿Te has dormido ya,\n[hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Are you still awake,\n[hero]?", french=" Tu dors, [hero]?", german="Bist du noch wach,\n[hero]?", italian="Non riesci a dormire,\n[hero]?", spanish="¿Te has dormido ya,\n[hero]?"})
  else
  SkySceneKit.say({english="Are you still awake,\n[hero]?", french=" Tu dors, [hero]?", german="Bist du noch wach,\n[hero]?", italian="Non riesci a dormire,\n[hero]?", spanish="¿Te has dormido ya,\n[hero]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I have to admit that today was\nfull of surprises.", french="Il faut admettre que cette\njournée a été riche en surprises.", german="Ich muss schon sagen, heute\ngab es viele Überraschungen.", italian="In effetti, la giornata di oggi è\nstata davvero piena di sorprese.", spanish="Tengo que admitir que ha sido\nun día cargado de sorpresas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I have to admit that today was\nfull of surprises.", french="Il faut admettre que cette\njournée a été riche en surprises.", german="Ich muss schon sagen, heute\ngab es viele Überraschungen.", italian="In effetti, la giornata di oggi è\nstata davvero piena di sorprese.", spanish="Tengo que admitir que ha sido\nun día cargado de sorpresas."})
  else
  SkySceneKit.say({english="I have to admit that today was\nfull of surprises.", french="Il faut admettre que cette\njournée a été riche en surprises.", german="Ich muss schon sagen, heute\ngab es viele Überraschungen.", italian="In effetti, la giornata di oggi è\nstata davvero piena di sorprese.", spanish="Tengo que admitir que ha sido\nun día cargado de sorpresas."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The great [CS:N]Dusknoir[CR]'s talk about\nbeing from the future...", french="Le grand [CS:N]Noctunoir[CR] qui vient\ndu futur...", german="Als der große [CS:N]Zwirrfinst[CR] sagte,\ndass er aus der Zukunft kommt...", italian="Il signor [CS:N]Dusknoir[CR] ha rivelato di\nvenire dal futuro...", spanish="El gran [CS:N]Dusknoir[CR] nos ha contado\nque viene del futuro..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The great [CS:N]Dusknoir[CR]'s talk about\ncoming from the future...", french="Le grand [CS:N]Noctunoir[CR] qui vient\ndu futur...", german="Als der große [CS:N]Zwirrfinst[CR] sagte,\ndass er aus der Zukunft kommt...", italian="Il signor [CS:N]Dusknoir[CR] ha rivelato di\nvenire dal futuro...", spanish="El gran [CS:N]Dusknoir[CR] nos ha contado\nque viene del futuro..."})
  else
  SkySceneKit.say({english="The great [CS:N]Dusknoir[CR]'s talk about\ncoming from the future...", french="Le grand [CS:N]Noctunoir[CR] qui vient\ndu futur...", german="Als der große [CS:N]Zwirrfinst[CR] sagte,\ndass er aus der Zukunft kommt...", italian="Il signor [CS:N]Dusknoir[CR] ha rivelato di\nvenire dal futuro...", spanish="El gran [CS:N]Dusknoir[CR] nos ha contado\nque viene del futuro..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That was mind blowing.", french="Quelle révélation\népoustouflante!", german=" Das war total irre.", italian=" Roba da non credere!", spanish=" Ha sido alucinante."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That was mind boggling.", french="Quelle révélation\népoustouflante!", german=" Das war total irre.", italian=" Che cosa incredibile!", spanish=" Ha sido alucinante."})
  else
  SkySceneKit.say({english=" That was mind blowing.", french="Quelle révélation\népoustouflante!", german=" Das war total irre.", italian=" Che cosa incredibile!", spanish=" Ha sido alucinante."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Dusknoir[CR] chased [CS:N]Grovyle[CR] from\nthe future to our world.", french="[CS:N]Noctunoir[CR] a poursuivi [CS:N]Massko[CR]\njusqu'à notre monde.", german="[CS:N]Zwirrfinst[CR] hat [CS:N]Reptain[CR] aus der\nZukunft bis in unsere Welt gejagt.", italian="[CS:N]Dusknoir[CR] è partito addirittura\ndal futuro per inseguire [CS:N]Grovyle[CR].", spanish="[CS:N]Dusknoir[CR] ha venido del futuro\npara perseguir a [CS:N]Grovyle[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Dusknoir[CR] pursued [CS:N]Grovyle[CR] from\nthe future to our world.", french="[CS:N]Noctunoir[CR] a poursuivi [CS:N]Massko[CR]\njusqu'à notre monde.", german="[CS:N]Zwirrfinst[CR] hat [CS:N]Reptain[CR] aus der\nZukunft bis in unsere Welt verfolgt.", italian="[CS:N]Dusknoir[CR] è partito addirittura\ndal futuro per inseguire [CS:N]Grovyle[CR].", spanish="[CS:N]Dusknoir[CR] ha venido del futuro\npara perseguir a [CS:N]Grovyle[CR]."})
  else
  SkySceneKit.say({english="[CS:N]Dusknoir[CR] tracked [CS:N]Grovyle[CR] from\nthe future to our world.", french="[CS:N]Noctunoir[CR] a poursuivi [CS:N]Massko[CR]\njusqu'à notre monde.", german="[CS:N]Zwirrfinst[CR] hat [CS:N]Reptain[CR] aus der\nZukunft bis in unsere Welt verfolgt.", italian="[CS:N]Dusknoir[CR] è partito addirittura\ndal futuro per inseguire [CS:N]Grovyle[CR].", spanish="[CS:N]Dusknoir[CR] ha venido del futuro\npara perseguir a [CS:N]Grovyle[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="He came to catch that wicked\n[CS:N]Grovyle[CR].", french="Il est venu ici exprès pour\nl'appréhender...", german="Er ist gekommen, um diesen\nhinterhältigen [CS:N]Reptain[CR] zu schnappen.", italian=" E adesso si trova qui.", spanish="Está aquí para atrapar a ese\nmalvado [CS:N]Grovyle[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="He came to apprehend that\nwicked [CS:N]Grovyle[CR].", french="Il est venu ici exprès pour\nl'appréhender...", german="Er ist gekommen, um diesen\nhinterhältigen [CS:N]Reptain[CR] zu fangen.", italian=" E adesso si trova qui.", spanish="Está aquí para atrapar a ese\nmalvado [CS:N]Grovyle[CR]."})
  else
  SkySceneKit.say({english="He came to catch that wicked\n[CS:N]Grovyle[CR].", french="Il est venu ici exprès pour\nl'appréhender...", german="Er ist gekommen, um diesen\nhinterhältigen [CS:N]Reptain[CR] zu schnappen.", italian=" E adesso si trova qui.", spanish="Está aquí para atrapar a ese\nmalvado [CS:N]Grovyle[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And to take him back to\nthe future.", french="... et le ramener avec lui\ndans le futur.", german="Um ihn dann mit zurück in die\nZukunft zu nehmen.", italian="Vuole acciuffarlo e riportarlo\ncon sé nel futuro.", spanish=" Y llevarle de vuelta al futuro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And to take him back to\nthe future.", french="... et le ramener avec lui\ndans le futur.", german="Um ihn dann mit zurück in die\nZukunft zu nehmen.", italian="Vuole acciuffarlo e riportarlo\ncon sé nel futuro.", spanish=" Y llevarle de vuelta al futuro."})
  else
  SkySceneKit.say({english="And to take him back to\nthe future.", french="... et le ramener avec lui\ndans le futur.", german="Um ihn dann mit zurück in die\nZukunft zu nehmen.", italian="Vuole acciuffarlo e riportarlo\ncon sé nel futuro.", spanish=" Y llevarle de vuelta al futuro."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's why the job of capturing\n[CS:N]Grovyle[CR] belongs to him.", french="La capture de [CS:N]Massko[CR]\nest donc une mission qui lui revient de droit.", german="Darum ist es sein Job,\n[CS:N]Reptain[CR] zu fangen.", italian="Per questo dobbiamo lasciare\nche sia lui ad occuparsi di [CS:N]Grovyle[CR].", spanish="Por eso es su responsabilidad\ncapturar a [CS:N]Grovyle[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's why the job of capturing\n[CS:N]Grovyle[CR] is his responsibility.", french="La capture de [CS:N]Massko[CR]\nest donc une mission qui lui revient de droit.", german="Darum ist er dafür\nverantwortlich, dass [CS:N]Reptain[CR] geschnappt wird.", italian="Per questo dobbiamo lasciare\nche sia lui ad occuparsi di [CS:N]Grovyle[CR].", spanish="Por eso es su responsabilidad\ncapturar a [CS:N]Grovyle[CR]."})
  else
  SkySceneKit.say({english="That's why the job of capturing\n[CS:N]Grovyle[CR] falls to him.", french="La capture de [CS:N]Massko[CR]\nest donc une mission qui lui revient de droit.", german="Darum ist es sein Job,\n[CS:N]Reptain[CR] zu fangen.", italian="Per questo dobbiamo lasciare\nche sia lui ad occuparsi di [CS:N]Grovyle[CR].", spanish="Por eso es su responsabilidad\ncapturar a [CS:N]Grovyle[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to trust [CS:N]Dusknoir[CR]\nabout this.", french="Il faut faire confiance à\n[CS:N]Noctunoir[CR] dans cette affaire.", german="Wir müssen [CS:N]Zwirrfinst[CR]\nvertrauen.", italian=" Dobbiamo fidarci di [CS:N]Dusknoir[CR].", spanish="Tendremos que confiar en\n[CS:N]Dusknoir[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to trust [CS:N]Dusknoir[CR]\nabout this.", french="Il faut faire confiance à\n[CS:N]Noctunoir[CR] dans cette affaire.", german="Wir müssen [CS:N]Zwirrfinst[CR]\nvertrauen.", italian=" Dobbiamo fidarci di [CS:N]Dusknoir[CR].", spanish="Tendremos que confiar en\n[CS:N]Dusknoir[CR]."})
  else
  SkySceneKit.say({english="We have to trust [CS:N]Dusknoir[CR]\nabout this.", french="Il faut faire confiance à\n[CS:N]Noctunoir[CR] dans cette affaire.", german="Wir müssen [CS:N]Zwirrfinst[CR]\nvertrauen.", italian=" Dobbiamo fidarci di [CS:N]Dusknoir[CR].", spanish="Tendremos que confiar en\n[CS:N]Dusknoir[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Well, sure, I'd love it if we\ncould capture [CS:N]Grovyle[CR] ourselves.", french="Bien sûr, j'adorerais\nqu'on capture [CS:N]Massko[CR] nous-mêmes.", german="Tja, natürlich würde ich [CS:N]Reptain[CR]\nliebend gerne selbst fangen.", italian="Beh, certo! Se fossimo noi ad\narrestare [CS:N]Grovyle[CR] sarebbe mitico!", spanish="La verdad es que me encantaría\nque participásemos en la captura de [CS:N]Grovyle[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="To be honest, I would like to\ncapture [CS:N]Grovyle[CR] ourselves.", french="Bien sûr, j'adorerais\nqu'on capture [CS:N]Massko[CR] nous-mêmes.", german="Um ehrlich zu sein, ich würde\n[CS:N]Reptain[CR] zwar gerne selbst fangen.", italian="Devo ammettere che sarebbe\nfantastico se fossimo noi a consegnare\n[CS:N]Grovyle[CR] alla giustizia.", spanish="La verdad es que me encantaría\nque participásemos en la captura de [CS:N]Grovyle[CR]."})
  else
  SkySceneKit.say({english="I admit, it would be great if we\ncould capture [CS:N]Grovyle[CR] ourselves.", french="Bien sûr, j'adorerais\nqu'on capture [CS:N]Massko[CR] nous-mêmes.", german="Zugegeben, es wäre toll, wenn\nwir [CS:N]Reptain[CR] selbst fangen könnten.", italian="Devo ammettere che sarebbe\nfantastico se fossimo noi a consegnare\n[CS:N]Grovyle[CR] alla giustizia.", spanish="Admito que me encantaría\nque participásemos en la captura de [CS:N]Grovyle[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But I'm not good enough for the\njob yet.", french="Mais je ne suis pas encore\nde taille à remplir une telle mission.", german="Aber dafür bin ich noch nicht\ngut genug.", italian="Ma non sono ancora pronto per\nuna missione del genere...", spanish="Pero aún no estoy a la altura\nde esa misión."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But I'm not up to the task yet.", french="Mais je ne suis pas encore\nde taille à remplir une telle mission.", german="Aber der Aufgabe bin ich noch\nnicht gewachsen.", italian="Ma non sono ancora pronto per\nuna missione del genere...", spanish="Pero aún no estoy a la altura\nde esa misión."})
  else
  SkySceneKit.say({english=" But I'm not skilled enough yet.", french="Mais je ne suis pas encore\nde taille à remplir une telle mission.", german="Aber meine Fähigkeiten sind\nnoch nicht gut genug.", italian="Ma non sono ancora pronta per\nuna missione del genere...", spanish="Pero aún no estoy a la altura\nde esa misión."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to depend on [CS:N]Dusknoir[CR]\nafter all.", french="Il faut nous reposer sur\n[CS:N]Noctunoir[CR], nous n'avons pas le choix.", german="Letztendlich bleibt uns nichts\nanderes übrig, als uns auf [CS:N]Zwirrfinst[CR] zu\nverlassen.", italian="È tutto nelle mani del signor\n[CS:N]Dusknoir[CR].", spanish="No nos queda más remedio que\ndepender de [CS:N]Dusknoir[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We don't have any choice but to\ndepend on [CS:N]Dusknoir[CR] after all.", french="Il faut nous reposer sur\n[CS:N]Noctunoir[CR], nous n'avons pas le choix.", german="Letztendlich müssen wir uns\nauf [CS:N]Zwirrfinst[CR] verlassen.", italian="È tutto nelle mani del signor\n[CS:N]Dusknoir[CR].", spanish="No nos queda más remedio que\ndepender de [CS:N]Dusknoir[CR]."})
  else
  SkySceneKit.say({english="We have to depend on [CS:N]Dusknoir[CR]\nafter all.", french="Il faut nous reposer sur\n[CS:N]Noctunoir[CR], nous n'avons pas le choix.", german="Letztendlich müssen wir uns\nauf [CS:N]Zwirrfinst[CR] verlassen.", italian="È tutto nelle mani del signor\n[CS:N]Dusknoir[CR].", spanish="No nos queda más remedio que\ndepender de [CS:N]Dusknoir[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...[K][hero]?[K]\nI guess you're asleep...", french="...[K] [hero]?[K]\nTu dors sûrement déjà...", german="...[K][hero]?[K]\nDu schläfst wohl schon...", italian="...[K] [hero]?[K]\nBeh, direi che finalmente hai preso sonno...", spanish="Oye...[K] ¿[hero]?[K]\nSupongo que ya te has dormido..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...[K][hero]?[K]\nI guess you're asleep...", french="...[K] [hero]?[K]\nTu dors sûrement déjà...", german="...[K][hero]?[K]\nDu schläfst wohl schon...", italian="...[K] [hero]?[K]\nBeh, direi che finalmente hai preso sonno...", spanish="Oye...[K] ¿[hero]?[K]\nSupongo que ya te has dormido..."})
  else
  SkySceneKit.say({english="...[K][hero]?[K]\nI guess you're asleep...", french="...[K] [hero]?[K]\nTu dors sûrement déjà...", german="...[K][hero]?[K]\nDu schläfst wohl schon...", italian="...[K] [hero]?[K]\nBeh, direi che finalmente hai preso sonno...", spanish="Oye...[K] ¿[hero]?[K]\nSupongo que ya te has dormido..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'd better get to sleep too.", french="Je ferais mieux de dormir,\nmoi aussi.", german=" Ich sollte besser auch schlafen.", italian="Sarà meglio che riposi un po'\nanch'io.", spanish="Será mejor que duerma yo\ntambién."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I'd better get to sleep too.", french="Je ferais mieux de dormir,\nmoi aussi.", german=" Ich sollte besser auch schlafen.", italian="Sarà meglio che riposi un po'\nanch'io.", spanish="Será mejor que duerma yo\ntambién."})
  else
  SkySceneKit.say({english=" I'd better get to sleep too.", french="Je ferais mieux de dormir,\nmoi aussi.", german=" Ich sollte besser auch schlafen.", italian="Sarà meglio che riposi un po'\nanch'io.", spanish="Será mejor que duerma yo\ntambién."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It'd be great if [CS:N]Grovyle[CR] gets\ncaught soon...", french="J'espère que [CS:N]Massko[CR] sera vite\nsous les verrous...", german="Es wäre toll, wenn [CS:N]Reptain[CR] bald\ngeschnappt wird...", italian="Speriamo che [CS:N]Grovyle[CR] venga\ncatturato presto...", spanish="Esperemos que atrapen pronto\na [CS:N]Grovyle[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It would be great if [CS:N]Grovyle[CR]\ngets caught soon...", french="J'espère que [CS:N]Massko[CR] sera vite\nsous les verrous...", german="Es wäre toll, wenn [CS:N]Reptain[CR] bald\ngeschnappt wird...", italian="Speriamo che [CS:N]Grovyle[CR] venga\ncatturato presto...", spanish="Esperemos que atrapen pronto\na [CS:N]Grovyle[CR]..."})
  else
  SkySceneKit.say({english="I hope [CS:N]Grovyle[CR] gets caught\nsoon...", french="J'espère que [CS:N]Massko[CR] sera vite\nsous les verrous...", german="Ich hoffe, [CS:N]Reptain[CR] wird bald\ngeschnappt...", italian="Speriamo che [CS:N]Grovyle[CR] venga\ncatturato presto...", spanish="Esperemos que atrapen pronto\na [CS:N]Grovyle[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Good night, [hero].", french=" Bonne nuit, [hero].", german=" Gute Nacht, [hero].", italian=" Buonanotte, [hero].", spanish=" Buenas noches, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Good night, [hero].", french=" Bonne nuit, [hero].", german=" Gute Nacht, [hero].", italian=" Buonanotte, [hero].", spanish=" Buenas noches, [hero]."})
  else
  SkySceneKit.say({english=" Good night, [hero].", french=" Bonne nuit, [hero].", german=" Gute Nacht, [hero].", italian=" Buonanotte, [hero].", spanish=" Buenas noches, [hero]."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(30)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
