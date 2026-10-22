-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99E/m20a0305.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- bgm2_PlayFadeIn(BGM_ON_THE_BEACH_AT_DUSK) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V21P02B) [décor sub chargé: Sub_v21p02b]
  -- back_SetGround(LEVEL_H01P99E) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 20, 18.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  SkySubScreen.Show("v21p02b", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  -- bgm_ChangeVolume(140,190) [volume BGM non scriptable en Lua PMDO: piste maintenue - documenté]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 224, 168, Direction.UpLeft, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="But when all seemed lost...[K]\nyou refused to give up.", french="Mais quand tout semblait\nperdu...[K] tu as refusé d'abandonner.", german="Aber als alles verloren\nschien...[K] Da hast du dich geweigert aufzugeben.", italian="Ma quando tutto sembrava\nperduto...[K] tu non hai voluto desistere.", spanish="Pero cuando todo parecía\nperdido...[K] tú te negaste a rendirte."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Even I had given up.", french=" Même moi, j'avais abandonné.", german="Sogar ich hatte schon\naufgegeben.", italian=" Sebbene io mi fossi arreso.", spanish="Incluso yo lo había dado todo por\nperdido."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" What compelled you?", french=" Qu'est-ce qui te motive?", german=" Was hat dich angetrieben?", italian=" Cosa ti ha spinto?", spanish=" ¿Cómo lo hiciste?"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="How did you manage...[K]to stay\nso strong?", french="Comment peux-tu...[K] rester\ninébranlable?", german="Wie hast du es geschafft?[K]\nWie konntest du so stark bleiben?", italian="Come hai fatto...[K] a trovare\nla forza?", spanish="¿Cómo te las arreglaste...?[K]\n¿Cómo encontraste las fuerzas?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Well...[K]I wonder too.", french="Ben...[K] moi aussi, je me le\ndemande.", german=" Nun...[K] Das frage ich mich auch.", italian=" Beh...[K] Me lo chiedo anch'io.", spanish="Bueno...[K] Yo también me lo\npregunto."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Well...[K]I wonder too.", french="Ben...[K] moi aussi, je me le\ndemande.", german=" Nun...[K] Das frage ich mich auch.", italian=" Beh...[K] Me lo chiedo anch'io.", spanish="Bueno...[K] Yo también me lo\npregunto."})
  else
  SkySceneKit.say({english=" Well...[K]I wonder too.", french="Ben...[K] moi aussi, je me le\ndemande.", german=" Nun...[K] Das frage ich mich auch.", italian=" Beh...[K] Me lo chiedo anch'io.", spanish="Bueno...[K] Yo también me lo\npregunto."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I really don't know...", french=" Je n'en ai aucune idée...", german=" Ich weiß es wirklich nicht...", italian=" Non lo so davvero...", spanish=" La verdad es que no lo sé..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I really don't know...", french=" Je n'en ai aucune idée...", german=" Ich weiß es wirklich nicht...", italian=" Non lo so davvero...", spanish=" La verdad es que no lo sé..."})
  else
  SkySceneKit.say({english=" I really don't know...", french=" Je n'en ai aucune idée...", german=" Ich weiß es wirklich nicht...", italian=" Non lo so davvero...", spanish=" La verdad es que no lo sé..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But maybe...", french=" Mais peut-être...", german=" Aber vielleicht...", italian=" Forse, però...", spanish=" Pero tal vez..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But maybe...", french=" Mais peut-être...", german=" Aber vielleicht...", italian=" Forse, però...", spanish=" Pero tal vez..."})
  else
  SkySceneKit.say({english=" But maybe...", french=" Mais peut-être...", german=" Aber vielleicht...", italian=" Forse, però...", spanish=" Pero tal vez..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Maybe it was because\n[hero] stood by me.", french="Peut-être que c'est grâce à\nla présence de [hero] à mes côtés.", german="Vielleicht war es, weil\n[hero] mir beigestanden hat.", italian="Forse perché [hero] era\nal mio fianco.", spanish="Tal vez se debió a que\n[hero] estaba allí conmigo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Maybe it was because\n[hero] stood by me.", french="Peut-être que c'est grâce à\nla présence de [hero] à mes côtés.", german="Vielleicht war es, weil\n[hero] mir beigestanden hat.", italian="Forse perché [hero] era\nal mio fianco.", spanish="Tal vez se debió a que\n[hero] estaba allí conmigo."})
  else
  SkySceneKit.say({english="Maybe it was because\n[hero] stood by me.", french="Peut-être que c'est grâce à\nla présence de [hero] à mes côtés.", german="Vielleicht war es, weil\n[hero] mir beigestanden hat.", italian="Forse perché [hero] era\nal mio fianco.", spanish="Tal vez se debió a que\n[hero] estaba allí conmigo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" [hero]...?", french=" [hero]...?", german=" [hero]?", italian=" [hero]?", spanish=" ¿[hero]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Take a look at this.", french=" Jette un coup d'œil à ça.", german=" Sieh dir das mal an.", italian=" Dai un'occhiata qui.", spanish=" Quiero enseñarte una cosa."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Take a look at this.", french=" Jette un coup d'œil à ça.", german=" Sieh dir das mal an.", italian=" Dai un'occhiata qui.", spanish=" Quiero enseñarte una cosa."})
  else
  SkySceneKit.say({english=" Have a look at this.", french=" Jette un coup d'œil à ça.", german=" Sieh dir das mal an.", italian=" Guarda qui.", spanish=" Quiero enseñarte una cosa."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(4), p.Y+(4), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(6410) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-4), p.Y+(-4), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(-8), p.Y+(-8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" This...[K] What could it be...?", french="Ça...[K] Qu'est-ce que ça peut bien\nêtre...?", german=" Das...[K] Was könnte es sein?", italian=" Che...[K] Che cos'è?", spanish="¿Qué crees...?[K] ¿Qué podría ser\nesto?"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="There's an odd pattern inscribed\non it.", french="Il y a un motif étrange gravé\ndessus.", german="Da ist ein seltsames Muster\ndrauf.", italian=" C'è inciso uno strano disegno.", spanish="Hay un extraño dibujo en\nla piedra."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I've never seen anything like\nit.[K] This pattern is new to me...", french="Je n'ai jamais rien vu de tel.[K]\nCe symbole m'est totalement inconnu...", german="So etwas habe ich noch nie\ngesehen.[K] Dieses Muster ist neu für mich.", italian="Non ho mai visto nulla del\ngenere.[K] Questa incisione è nuova per me...", spanish="Nunca he visto nada parecido.[K]\nEstas formas son nuevas para mí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This is my Relic Fragment.[K]\nIt's my personal treasure.", french="C'est mon Fragment de Relique.[K]\nMon précieux trésor.", german="Das ist mein Reliktfragment.[K]\nMein persönlicher Schatz.", italian="Questo è il mio Frammento\nAntico.[K] È il mio tesoro personale.", spanish="Esta es mi Reliquia de Piedra.[K]\nEs mi amuleto, mi tesoro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This is my Relic Fragment.[K]\nIt's my personal treasure.", french="C'est mon Fragment de Relique.[K]\nMon précieux trésor.", german="Das ist mein Reliktfragment.[K]\nMein persönlicher Schatz.", italian="Questo è il mio Frammento\nAntico.[K] È il mio tesoro personale.", spanish="Esta es mi Reliquia de Piedra.[K]\nEs mi amuleto, mi tesoro."})
  else
  SkySceneKit.say({english="This is my Relic Fragment.[K]\nIt's my personal treasure.", french="C'est mon Fragment de Relique.[K]\nMon précieux trésor.", german="Das ist mein Reliktfragment.[K]\nMein persönlicher Schatz.", italian="Questo è il mio Frammento\nAntico.[K] È il mio tesoro personale.", spanish="Esta es mi Reliquia de Piedra.[K]\nEs mi amuleto, mi tesoro."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's my dream to one day solve\nthe mystery of this fragment.", french="Mon rêve, c'est d'arriver\nun jour à déchiffrer l'énigme que renferme\nce fragment.", german="Es ist mein Traum, eines Tages\ndas Rätsel dieses Fragments zu lösen.", italian="Il mio sogno è di risolvere il\nmistero di questo frammento un giorno.", spanish="Mi sueño era, y sigue siendo,\ndesvelar algún día el misterio que esconde."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I have this dream of one day\nsolving the mystery behind this fragment.", french="Mon rêve, c'est d'arriver\nun jour à déchiffrer l'énigme que renferme\nce fragment.", german="Ich habe den Traum, eines Tages\nhinter das Rätsel dieses Fragments zu\nkommen.", italian="Il mio sogno è di risolvere il\nmistero di questo frammento un giorno.", spanish="Mi sueño era, y sigue siendo,\ndesvelar algún día el misterio que esconde."})
  else
  SkySceneKit.say({english="It's my dream to one day solve\nthe mystery behind this fragment.", french="Mon rêve, c'est d'arriver\nun jour à déchiffrer l'énigme que renferme\nce fragment.", german="Es ist mein Traum, eines Tages\nhinter das Rätsel dieses Fragments zu\ngelangen.", italian="Il mio sogno è di risolvere il\nmistero di questo frammento un giorno.", spanish="Mi sueño era, y sigue siendo,\ndesvelar algún día el misterio que esconde."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But I was such a coward...[K]\nI couldn't even work up enough courage to\nsee if I could apprentice at the guild.", french="Mais avant j'étais tellement\nlâche...[K] Je n'avais même pas le courage\nde tenter ma chance à la Guilde.", german="Aber ich war so ein Feigling...[K]\nIch konnte nicht mal genug Mut aufbringen, um\nals Lehrling bei der Gilde anzufangen.", italian="Ma ero un tale codardo...[K] Non\navevo neppure il coraggio di chiedere se\npotevo fare l'apprendistato alla Gilda.", spanish="Pero yo era tan cobarde que...[K]\nni siquiera tenía valor para apuntarme como\naprendiz en el [CS:N]Pokégremio[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But I was such a coward...[K]\nI couldn't work up the courage to go to the\nguild and apply as an apprentice.", french="Mais avant j'étais tellement\nlâche...[K] Je n'avais même pas le courage\nde tenter ma chance à la Guilde.", german="Aber ich war so ein Feigling...[K]\nIch konnte nicht mal genug Mut aufbringen, um\nals Lehrling bei der Gilde anzufangen.", italian="Ma ero un tale codardo...[K] Non\navevo neppure il coraggio di chiedere se\npotevo fare l'apprendistato alla Gilda.", spanish="Pero yo era tan cobarde que...[K]\nni siquiera tenía valor para apuntarme como\naprendiz en el [CS:N]Pokégremio[CR]."})
  else
  SkySceneKit.say({english="But I was scared so easily...[K]\nI didn't even have the courage to apply as an\napprentice at the guild.", french="Mais avant j'étais tellement\nlâche...[K] Je n'avais même pas le courage\nde tenter ma chance à la Guilde.", german="Aber ich war so ein Feigling...[K]\nIch hatte nicht mal genug Mut, um als Lehrling\nbei der Gilde anzufangen.", italian="Ma ero così paurosa...[K] Non\navevo neppure il coraggio di chiedere se\npotevo fare l'apprendistato alla Gilda.", spanish="Pero yo era tan cobarde que...[K]\nni siquiera tenía valor para apuntarme como\naprendiz en el [CS:N]Pokégremio[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It was then...[K]that I met\n[hero].", french="Et c'est à ce moment-là que...[K]\nj'ai rencontré [hero].", german="Genau in diesem Moment[K] traf\nich [hero].", italian="È stato allora...[K] che ho\nincontrato [hero].", spanish="Fue entonces...[K] cuando conocí\na [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It was then...[K]that I met\n[hero].", french="Et c'est à ce moment-là que...[K]\nj'ai rencontré [hero].", german="Genau in diesem Moment[K] traf\nich [hero].", italian="È stato allora...[K] che ho\nincontrato [hero].", spanish="Fue entonces...[K] cuando conocí\na [hero]."})
  else
  SkySceneKit.say({english="That was when...[K]I met\n[hero].", french="Et c'est à ce moment-là que...[K]\nj'ai rencontré [hero].", german=" Und dann[K] traf ich [hero].", italian="È stato allora...[K] che ho\nincontrato [hero].", spanish="Fue entonces...[K] cuando conocí\na [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [hero]...", french=" [hero]...", german=" [hero]...", italian=" [hero]...", spanish=" [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [hero]...", french=" [hero]...", german=" [hero]...", italian=" [hero]...", spanish=" [hero]..."})
  else
  SkySceneKit.say({english=" [hero]...", french=" [hero]...", german=" [hero]...", italian=" [hero]...", spanish=" [hero]..."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(140) end) -- bgm_ChangeVolume vers 0 (silence)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
