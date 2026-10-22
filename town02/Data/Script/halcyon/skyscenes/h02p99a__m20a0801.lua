-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/m20a0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 276, 168, false, 1)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 232, 192, Direction.Left, "NPC_JUPUTORU")
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'm back.[K] I got some news like\nyou wanted.", french="C'est moi.[K] J'ai réuni des infos\ncomme tu me l'as demandé.", german="Ich bin zurück.[K] Ich habe ein paar\nvon den Informationen, die du wolltest.", italian="Sono tornato.[K] Ho scoperto un\npo' di cose, come volevi.", spanish="He vuelto.[K] Y traigo noticias, tal\ny como me pediste."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm back.[K] I've got some news\nlike you wanted.", french="C'est moi.[K] J'ai réuni des infos\ncomme tu me l'as demandé.", german="Ich bin zurück.[K] Ich habe ein paar\nvon den Informationen, die du wolltest.", italian="Sono tornato.[K] Ho scoperto un\npo' di cose, come volevi.", spanish="He vuelto.[K] Y traigo noticias, tal\ny como me pediste."})
  else
  SkySceneKit.say({english="I'm back.[K] I've got some news\nlike you wanted.", french="C'est moi.[K] J'ai réuni des infos\ncomme tu me l'as demandé.", german="Ich bin zurück.[K] Ich habe ein paar\nvon den Informationen, die du wolltest.", italian="Sono tornata.[K] Ho scoperto un\npo' di cose, come volevi.", spanish="He vuelto.[K] Y traigo noticias, tal\ny como me pediste."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" What's the word?", french="Alors, quelles sont les\nnouvelles?", german=" Was wird denn so geredet?", italian=" Che notizie ci sono?", spanish=" ¿Y qué se dice por ahí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" The word is...[K]not very good.", french="Les nouvelles ne sont...[K] pas très\nbonnes.", german=" Nichts...[K] wirklich Gutes.", italian="Le notizie...[K] non sono molto\nbuone.", spanish=" Pues...[K] nada bueno."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" The word is...[K]not very good.", french="Les nouvelles ne sont...[K] pas très\nbonnes.", german=" Nichts...[K] wirklich Gutes.", italian="Le notizie...[K] non sono molto\nbuone.", spanish=" Pues...[K] nada bueno."})
  else
  SkySceneKit.say({english=" The word is...[K]not very good.", french="Les nouvelles ne sont...[K] pas très\nbonnes.", german=" Nichts...[K] wirklich Gutes.", italian="Le notizie...[K] non sono molto\nbuone.", spanish=" Pues...[K] nada bueno."})
  end
  -- message_KeyWait
  -- bgm2_ChangeVolume(120, 128) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" After we went to the future...", french="Après notre départ pour\nle futur...", german="Nachdem wir in die Zukunft\ngegangen sind...", italian="Dopo che siamo stati trascinati\nnel futuro...", spanish=" Cuando nos fuimos al futuro..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" After we went to the future...", french="Après notre départ pour\nle futur...", german="Nachdem wir in die Zukunft\ngegangen sind...", italian="Dopo che siamo stati trascinati\nnel futuro...", spanish=" Cuando nos fuimos al futuro..."})
  else
  SkySceneKit.say({english=" After we went to the future...", french="Après notre départ pour\nle futur...", german="Nachdem wir in die Zukunft\ngegangen sind...", italian="Dopo che siamo stati trascinati\nnel futuro...", spanish=" Cuando nos fuimos al futuro..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Uxie[CR] and his friends put back\nthe Time Gears in their original places.", french="... [CS:N]Créhelf[CR] et ses amis ont remis\nles Rouages du Temps à leur place.", german="Nun, [CS:N]Selfe[CR] und seine Freunde\nbrachten die Zahnräder der Zeit zurück an\nihre ursprünglichen Plätze.", italian="... [CS:N]Uxie[CR] e i suoi amici hanno\nrimesso al loro posto gli Ingranaggi del\nTempo.", spanish="[CS:N]Uxie[CR] y los demás devolvieron\nlos Engranajes del Tiempo a sus lugares\noriginales."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Uxie[CR] and his friends returned\nthe Time Gears to their rightful places.", french="... [CS:N]Créhelf[CR] et ses amis ont remis\nles Rouages du Temps à leur place.", german="Nun, [CS:N]Selfe[CR] und seine Freunde\nbrachten die Zahnräder der Zeit zurück an\nihre ursprünglichen Plätze.", italian="... [CS:N]Uxie[CR] e i suoi amici hanno\nriportato al loro posto gli Ingranaggi del\nTempo.", spanish="[CS:N]Uxie[CR] y los demás devolvieron\nlos Engranajes del Tiempo a sus lugares\noriginales."})
  else
  SkySceneKit.say({english="[CS:N]Uxie[CR] and his friends put back\nthe Time Gears in their original places.", french="... [CS:N]Créhelf[CR] et ses amis ont remis\nles Rouages du Temps à leur place.", german="Nun, [CS:N]Selfe[CR] und seine Freunde\nbrachten die Zahnräder der Zeit zurück an\nihre ursprünglichen Plätze.", italian="... [CS:N]Uxie[CR] e i suoi amici hanno\nriportato al loro posto gli Ingranaggi del\nTempo.", spanish="[CS:N]Uxie[CR] y los demás devolvieron\nlos Engranajes del Tiempo a sus lugares\noriginales."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Everyone was happy because\nthey thought time would return to normal.", french="Tout le monde se réjouissait\nen pensant que le temps allait reprendre\nson cours normal.", german="Jeder war glücklich, weil man\ndachte, die Zeit würde danach wieder normal\nfunktionieren.", italian="Erano tutti felici perché\npensavano che il tempo sarebbe tornato\na scorrere normalmente.", spanish="Todos se alegraron porque\ncreían que el tiempo volvería a la\nnormalidad."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Everyone was happy because\nthey thought time would return to normal.", french="Tout le monde se réjouissait\nen pensant que le temps allait reprendre\nson cours normal.", german="Jeder war glücklich, weil man\ndachte, die Zeit würde danach wieder normal\nfunktionieren.", italian="Erano tutti felici perché\npensavano che il tempo sarebbe tornato\na scorrere normalmente.", spanish="Todos se alegraron porque\ncreían que el tiempo volvería a la\nnormalidad."})
  else
  SkySceneKit.say({english="Everyone was happy because\nthey thought time would return to normal.", french="Tout le monde se réjouissait\nen pensant que le temps allait reprendre\nson cours normal.", german="Jeder war glücklich, weil man\ndachte, die Zeit würde danach wieder normal\nfunktionieren.", italian="Erano tutti felici perché\npensavano che il tempo sarebbe tornato\na scorrere normalmente.", spanish="Todos se alegraron porque\ncreían que el tiempo volvería a la\nnormalidad."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But time remained stuck in\nthose places.", french=" Mais le temps est resté figé.", german="Aber die Zeit stand weiter still\nan diesen Orten.", italian="Ma il tempo in quei luoghi è\nrimasto fermo.", spanish="Pero el flujo del tiempo no\nse repuso."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But the time remained stopped\nin those places.", french=" Mais le temps est resté figé.", german="Aber die Zeit stand weiter still\nan diesen Orten.", italian="Ma il tempo in quei luoghi è\nrimasto fermo.", spanish="Pero el flujo del tiempo no\nse repuso."})
  else
  SkySceneKit.say({english="But time stayed stopped in\nthose places.", french=" Mais le temps est resté figé.", german="Aber die Zeit stand weiter still\nan diesen Orten.", italian="Ma il tempo in quei luoghi è\nrimasto fermo.", spanish="Pero el flujo del tiempo no\nse repuso."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Even worse, it's spreading. Time\nis stopping in more and more places.", french="Pire encore, ça s'aggrave. Il y a\nde plus en plus d'endroits où le temps s'arrête.", german="Und damit nicht genug, so\nerzählt man sich auch noch, dass die Zeit an\nmehr und mehr Orten anhält.", italian="Peggio ancora, questa condizione\nsi sta diffondendo anche in altri luoghi.", spanish="Peor aún, el fenómeno se está\nextendiendo. El tiempo se está deteniendo\nen más sitios."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Even worse, it's spreading. Time\nis stopping in more places.", french="Pire encore, ça s'aggrave. Il y a\nde plus en plus d'endroits où le temps s'arrête.", german="Und damit nicht genug, so\nerzählt man sich auch noch, dass die Zeit an\nmehr und mehr Orten anhält.", italian="Peggio ancora, questa condizione\nsi sta diffondendo anche in altri luoghi.", spanish="Peor aún, el fenómeno se está\nextendiendo. El tiempo se está deteniendo\nen más sitios."})
  else
  SkySceneKit.say({english="Even worse, it's spreading. Time\nis stopping in more and more places.", french="Pire encore, ça s'aggrave. Il y a\nde plus en plus d'endroits où le temps s'arrête.", german="Und damit nicht genug, erzählt\nman sich auch noch, dass die Zeit an mehr\nund mehr Orten anhält.", italian="Peggio ancora, questa condizione\nsi sta diffondendo anche in altri luoghi.", spanish="Peor aún, el fenómeno se está\nextendiendo. El tiempo se está deteniendo\nen más sitios."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Is that true?", french=" C'est bien vrai?", german=" Stimmt das?", italian=" Davvero?", spanish=" ¿Es cierto eso?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yup.[K] Everyone's up in arms\nbecause no one can figure out what's going on.", french="Ouaip.[K] C'est la panique partout,\npersonne ne comprend ce qui se passe.", german="Jep.[K] Alle sind alarmiert, weil\nniemand weiß, was hier vor sich geht.", italian="Già.[K] Sono tutti molto turbati\nperché non riescono a immaginare cosa potrà\nsuccedere.", spanish="Sí.[K] Todo el mundo está\nalarmado porque nadie entiende lo que sucede."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yes.[K] Everyone's upset and\nconcerned because no one can figure out\nwhat the problem is.", french="Ouaip.[K] C'est la panique partout,\npersonne ne comprend ce qui se passe.", german="Ja.[K] Alle sind bestürzt und\nbesorgt, weil niemand weiß, woran das liegt.", italian="Già.[K] Sono tutti agitati e\npreoccupati perché non riescono a capire\nquale sia il problema.", spanish="Sí.[K] Todo el mundo está\nalarmado porque nadie entiende lo que sucede."})
  else
  SkySceneKit.say({english="Yep.[K] Everyone's upset because no\none can tell what's going on.", french="Ouaip.[K] C'est la panique partout,\npersonne ne comprend ce qui se passe.", german="Jep.[K] Alle sind bestürzt, weil\nniemand sagen kann, woran das liegt.", italian="Già.[K] Sono tutti preoccupati\nperché nessuno sa cosa riserverà loro il\nfuturo.", spanish="Sí.[K] Todo el mundo está\nalarmado porque nadie entiende lo que sucede."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Grovyle[CR], do you know what's\ngoing on?", french="[CS:N]Massko[CR], tu sais ce qui\nse passe, toi?", german="[CS:N]Reptain[CR], weißt du, was hier vor\nsich geht?", italian="[CS:N]Grovyle[CR], tu sai cosa sta\nsuccedendo?", spanish="[CS:N]Grovyle[CR], ¿sabes lo que está\npasando?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Grovyle[CR], do you know what\nthis means?", french="[CS:N]Massko[CR], tu sais ce qui\nse passe, toi?", german="[CS:N]Reptain[CR], weißt du, was das zu\nbedeuten hat?", italian="[CS:N]Grovyle[CR], tu sai cosa significa\ntutto questo?", spanish="[CS:N]Grovyle[CR], ¿sabes lo que está\npasando?"})
  else
  SkySceneKit.say({english="[CS:N]Grovyle[CR], do you know what\nthis means?", french="[CS:N]Massko[CR], tu sais ce qui\nse passe, toi?", german="[CS:N]Reptain[CR], weißt du, was das zu\nbedeuten hat?", italian="[CS:N]Grovyle[CR], tu sai cosa significa\ntutto questo?", spanish="[CS:N]Grovyle[CR], ¿sabes lo que está\npasando?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="If time is stopping in a\nspreading area...[K]it can only mean one thing.", french="Si les zones où le temps\ns'arrête s'étendent...[K] ça ne peut\nvouloir dire qu'une chose.", german="Wenn die Zeit in einem immer\ngrößer werdenden Gebiet anhält...[K] Dann kann\ndas nur eines bedeuten.", italian="Se il tempo si sta fermando su\nun'area sempre più estesa...[K] può voler\ndire solo una cosa.", spanish="Que el tiempo se esté deteniendo\nen una zona cada vez mayor...[K] solo puede\nsignificar una cosa."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="[CS:P]Temporal Tower[CR] is starting to\ncollapse.", french="La [CS:P]Tour du Temps[CR] commence\nà s'effondrer.", german="Der [CS:P]Zeitturm[CR] beginnt\nzusammenzubrechen.", italian="Che la [CS:P]Torre del Tempo[CR] sta\ncominciando a crollare.", spanish="La [CS:P]Torre del Tiempo[CR]\nha comenzado a derrumbarse."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:P]Temporal Tower[CR] is...[K]collapsing?", french=" La [CS:P]Tour du Temps[CR]...[K] s'effondre?", german="Der [CS:P]Zeitturm[CR]...[K] bricht\nzusammen?", italian="La [CS:P]Torre del Tempo[CR] sta...[K]\ncrollando?", spanish="¿La [CS:P]Torre del Tiempo[CR]...?[K]\n¿La [CS:P]Torre del Tiempo[CR] se está derrumbando?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:P]Temporal Tower[CR] is...[K]collapsing?", french=" La [CS:P]Tour du Temps[CR]...[K] s'effondre?", german="Der [CS:P]Zeitturm[CR]...[K] bricht\nzusammen?", italian="La [CS:P]Torre del Tempo[CR] sta...[K]\ncrollando?", spanish="¿La [CS:P]Torre del Tiempo[CR]...?[K]\n¿La [CS:P]Torre del Tiempo[CR] se está derrumbando?"})
  else
  SkySceneKit.say({english=" [CS:P]Temporal Tower[CR] is...[K]collapsing?", french=" La [CS:P]Tour du Temps[CR]...[K] s'effondre?", german="Der [CS:P]Zeitturm[CR]...[K] bricht\nzusammen?", italian="La [CS:P]Torre del Tempo[CR] sta...[K]\ncrollando?", spanish="¿La [CS:P]Torre del Tiempo[CR]...?[K]\n¿La [CS:P]Torre del Tiempo[CR] se está derrumbando?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Correct.[K] [CS:P]Temporal Tower[CR] gives\nstructure to time. So if it is starting to\ncollapse...", french="En effet. La [CS:P]Tour du Temps[CR]\nrégule le cours du temps. Alors si\nelle commence à s'effondrer...", german="Korrekt.[K] Der [CS:P]Zeitturm[CR] gibt der\nZeit Struktur. Wenn er also zusammenbricht...", italian="Proprio così.[K] La [CS:P]Torre del[CR]\n[CS:P]Tempo[CR] regge la struttura temporale. Quindi\nse sta cominciando a crollare...", spanish="Eso me temo.[K] El tiempo fluye\ndesde allí. Y si ha comenzado a derrumbarse..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="time itself will collapse in\never-widening areas.", french="... le cours du temps lui-même\nva s'effondrer, dans des zones de plus en plus\nétendues.", german="Dann bricht die Zeit selbst in\neinem sich ständig ausweitenden Gebiet\nzusammen.", italian="... anche il tempo continuerà a\nfermarsi in zone sempre più vaste.", spanish="El tiempo se detendrá en un área\ncada vez mayor."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="This is bad. The problem is\naccelerating.", french="C'est terrible. La situation\ns'aggrave d'heure en heure.", german="Das ist schlecht. Das Problem\nwird dringlicher.", italian="Questa è una brutta cosa.\nIl problema si fa più serio.", spanish="Eso no es bueno.\nEl proceso se está acelerando."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="The planet's paralysis is\ncoming on fast.", french="La Paralysie de la Planète\napproche à grands pas.", german="Die Lähmung des Planeten\nschreitet schnell voran.", italian="La paralisi del pianeta si\navvicina più velocemente.", spanish="La parálisis del planeta tendrá\nlugar dentro de poco."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?! But...", french=" Quoi?! Mais...", german=" Was? Aber...", italian=" Cosa?! Ma...", spanish=" ¡¿Qué?! Pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?! But...", french=" Quoi?! Mais...", german=" Was? Aber...", italian=" Cosa?! Ma...", spanish=" ¡¿Qué?! Pero..."})
  else
  SkySceneKit.say({english=" What?! But...", french=" Quoi?! Mais...", german=" Was? Aber...", italian=" Cosa?! Ma...", spanish=" ¡¿Qué?! Pero..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We have to hurry, then!", french=" Il faut qu'on se dépêche, alors!", german=" Dann müssen wir uns beeilen!", italian=" Dobbiamo sbrigarci, allora!", spanish=" ¡Entonces debemos darnos prisa!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We have to hurry, then!", french=" Il faut qu'on se dépêche, alors!", german=" Dann müssen wir uns beeilen!", italian=" Dobbiamo sbrigarci, allora!", spanish=" ¡Entonces debemos darnos prisa!"})
  else
  SkySceneKit.say({english=" We have to hurry, then!", french=" Il faut qu'on se dépêche, alors!", german=" Dann müssen wir uns beeilen!", italian=" Dobbiamo sbrigarci, allora!", spanish=" ¡Entonces debemos darnos prisa!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That's right. If we don't hurry,\nthe planet will become fully paralyzed.", french="C'est juste. Si on ne réagit pas\nau plus vite, la planète sera complètement\nparalysée.", german="Das stimmt. Wenn wir uns nicht\nbeeilen, ist der Planet bald völlig gelähmt.", italian="Hai ragione. Se non facciamo in\nfretta, il pianeta presto sarà completamente\nparalizzato.", spanish="Así es. Si no hacemos algo\npronto, todo el planeta quedará paralizado."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="There's only one way to stop the\ndestruction of time now.", french="Il n'y a plus qu'un moyen d'éviter\nque le temps ne soit détruit.", german="Es gibt jetzt nur einen Weg, wie\nwir die Zerstörung der Zeit aufhalten können.", italian="Ormai c'è solo un modo per\narrestare questo disastro.", spanish="Ahora solo hay una forma\nde detener la destrucción del tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We need to gather Time Gears...", french="Rassembler les Rouages du\nTemps...", german="Wir müssen die Zahnräder der\nZeit einsammeln...", italian="Dobbiamo trovare gli Ingranaggi\ndel Tempo...", spanish="Necesitamos reunir\nlos engranajes..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Then the Time Gears must be put\nin place in [CS:P]Temporal Tower[CR] where [CS:N]Dialga[CR] lives.", french="... et les remettre à leur place\ndans la [CS:P]Tour du Temps[CR], où habite [CS:N]Dialga[CR].", german="Und wir müssen sie in den\n[CS:P]Zeitturm[CR] einsetzen, wo [CS:N]Dialga[CR] lebt.", italian="Poi gli Ingranaggi del Tempo\nvanno collocati all'interno della [CS:P]Torre\ndel Tempo[CR], dove vive [CS:N]Dialga[CR].", spanish="Y, luego, debemos colocarlos\nen su sitio, en la [CS:P]Torre del Tiempo[CR], donde vive\n[CS:N]Dialga[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" But there is a problem.", french=" Il reste un problème, cependant.", german=" Aber es gibt ein Problem dabei.", italian=" Ma c'è un problema.", spanish=" Pero hay un problema."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="[CS:P]Temporal Tower[CR] is located in a\nplace called the [CS:P]Hidden Land[CR].", french="La [CS:P]Tour du Temps[CR] se trouve\ndans un lieu qu'on appelle les [CS:P]Terres Illusoires[CR].", german="Der [CS:P]Zeitturm[CR] liegt an einem Ort,\nwelcher das [CS:P]Verborgene Land[CR] genannt wird.", italian="La [CS:P]Torre del Tempo[CR] è situata\nin un posto che si chiama [CS:P]Terra Nascosta[CR].", spanish="La [CS:P]Torre del Tiempo[CR] está situada\nen un lugar llamado la [CS:P]Tierra Oculta[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="As the name suggests...[K]no one\nknows where the [CS:P]Hidden Land[CR] is.", french="Comme leur nom le suggère...[K]\npersonne ne sait où se situent les [CS:P]Terres\nIllusoires[CR].", german="Wie der Name schon andeutet...[K]\nNiemand weiß, wo dieses [CS:P]Verborgene Land[CR]\nist.", italian="Purtroppo...[K] nessuno sa dove si\ntrova la [CS:P]Terra Nascosta[CR].", spanish="Tal y como indica su nombre...[K]\nnadie sabe a ciencia cierta dónde está."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But...[K]there isn't any time!", french=" Mais...[K] on n'a plus le temps!", german="Aber...[K] Wir haben keine Zeit\nmehr!", italian="Ma...[K] non c'è tempo da\nperdere.", spanish=" Pero...[K] ¡ya no nos queda tiempo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But...[K]there isn't any time!", french=" Mais...[K] on n'a plus le temps!", german="Aber...[K] Wir haben keine Zeit\nmehr!", italian="Ma...[K] non c'è tempo da\nperdere.", spanish=" Pero...[K] ¡ya no nos queda tiempo!"})
  else
  SkySceneKit.say({english=" But...[K]there isn't any time!", french=" Mais...[K] on n'a plus le temps!", german="Aber...[K] Wir haben keine Zeit\nmehr!", italian="Ma...[K] non c'è tempo da\nperdere.", spanish=" Pero...[K] ¡ya no nos queda tiempo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  -- bgm2_ChangeVolume(120, 256) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That's right.[K] That's why I think\nwe need to split up for now.", french="C'est exact.[K] C'est pour ça que\nje crois qu'il faut nous séparer maintenant.", german="Das stimmt.[K] Darum sollten wir\nuns bis auf Weiteres aufteilen, denke ich.", italian="Hai ragione.[K] Infatti credo che\nsia meglio se per ora ci dividiamo.", spanish="Cierto.[K] Por eso, creo que\ndebemos separarnos."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" I'll go collect the Time Gears.", french="Je m'occupe des Rouages du\nTemps.", german="Ich werde die Zahnräder der\nZeit einsammeln.", italian="Io recupererò gli Ingranaggi del\nTempo.", spanish="Yo iré a buscar los Engranajes\ndel Tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="In the meantime, I want you two\nto search for the [CS:P]Hidden Land[CR].", french="Pendant ce temps, faites en\nsorte de localiser les [CS:P]Terres Illusoires[CR].", german="Ich möchte, dass ihr in der\nZwischenzeit nach dem [CS:P]Verborgenen Land[CR]\nsucht.", italian="Nel frattempo, voglio che voi\ndue cerchiate la [CS:P]Terra Nascosta[CR].", spanish="Mientras tanto, tenéis que tratar\nde encontrar la [CS:P]Tierra Oculta[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Gotcha.", french=" Entendu.", german=" Kapiert.", italian=" Afferrato.", spanish=" Comprendido."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Understood.", french=" Entendu.", german=" Verstanden.", italian=" Capito.", spanish=" Comprendido."})
  else
  SkySceneKit.say({english=" OK.", french=" Entendu.", german=" Okay.", italian=" Ok.", spanish=" Comprendido."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Are you OK with that,\n[hero]?", french=" Ça te convient, [hero]?", german="Bist du damit einverstanden,\n[hero]?", italian=" Ti va bene, [hero]?", spanish=" ¿Te parece bien, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Is that OK, [hero]?", french=" Ça te convient, [hero]?", german=" Ist das okay, [hero]?", italian=" Va bene, [hero]?", spanish=" ¿Te parece bien, [hero]?"})
  else
  SkySceneKit.say({english=" Is that OK, [hero]?", french=" Ça te convient, [hero]?", german=" Ist das okay, [hero]?", italian=" Va bene, [hero]?", spanish=" ¿Te parece bien, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" OK then. You're in charge.", french="Très bien. C'est toi qui\ncommandes.", german="Dann ist alles klar. Du gibst die\nKommandos.", italian="Ok, allora. Vi affido questo\nincarico.", spanish="De acuerdo.\nEsto queda en vuestras manos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="The [CS:P]Hidden Land[CR] is supposedly\nsomewhere in this world.", french="Les [CS:P]Terres Illusoires[CR] sont\ncensées se trouver quelque part dans\nce monde.", german="Das [CS:P]Verborgene Land[CR] liegt\nvermutlich irgendwo in dieser Welt.", italian="La [CS:P]Terra Nascosta[CR] dovrebbe\nessere da qualche parte in questo mondo.", spanish="La [CS:P]Tierra Oculta[CR] tiene que estar\nen algún lugar de este mundo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Unfortunately, there are no\nclues as to where it is exactly.", french="Malheureusement, on n'a aucun\nindice sur leur emplacement exact.", german="Leider gibt es keine Hinweise\ndarauf, wo es genau liegt.", italian="Sfortunatamente, non abbiamo\nnessun indizio sulla sua collocazione\nprecisa.", spanish="Por desgracia, nadie sabe dónde\nestá exactamente."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Considering that no one has\ndiscovered it yet...", french="Etant donné que personne ne les\na découvertes à ce jour...", german="Wenn man bedenkt, dass es bis\njetzt noch keiner entdeckt hat...", italian=" Nessuno l'ha mai trovata.", spanish="Dado que nadie la ha descubierto\ntodavía..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We should probably assume that\nit is quite far away.", french="... on peut supposer qu'elles sont\nloin de tout.", german="Man sollte wohl annehmen, dass\nes recht weit weg ist.", italian="Quindi dovrebbe essere piuttosto\nlontana.", spanish=" Podría estar muy lejos."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We must even consider crossing\nthe sea. And discover the means to do so!", french="Il faut même envisager d'avoir\nà traverser la mer! Et aussi découvrir\nle moyen d'y parvenir!", german="Vielleicht müssen wir sogar den\nOzean überqueren. Und Wege finden, wie\ndas zu bewerkstelligen ist!", italian="Probabilmente bisognerà\nattraversare il mare. E scoprire come\nfarlo!", spanish="Tal vez debamos incluso cruzar\nel mar. ¡Y encontrar la forma de hacerlo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Cross the sea...", french=" Traverser la mer...", german=" Den Ozean überqueren...", italian=" Attraversare il mare...", spanish=" Cruzar el mar..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Cross the sea...", french=" Traverser la mer...", german=" Den Ozean überqueren...", italian=" Attraversare il mare...", spanish=" Cruzar el mar..."})
  else
  SkySceneKit.say({english=" Cross the sea...", french=" Traverser la mer...", german=" Den Ozean überqueren...", italian=" Attraversare il mare...", spanish=" Cruzar el mar..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I'm sorry I don't have knowledge\nabout how to do that.[K] I'm counting on you.", french="Je suis désolé, mais je ne\nconnais pas le moyen d'y arriver.[K] Je compte\nsur vous.", german="Es tut mir leid, aber ich habe\nkeine Ahnung, wie das gehen könnte.[K]\nIch verlasse mich auf euch.", italian="Mi spiace, non ho la minima idea\ndi come si possa fare.[K] Conto su di voi.", spanish="Siento no poder aportar más\ninformación.[K] Espero que podáis descubrirlo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Well, I'll be off to gather the\nTime Gears.[K] Good luck.", french="Bon, je pars à la recherche des\nRouages du Temps.[K] Bonne chance.", german="Okay, ich mache mich auf, die\nZahnräder der Zeit einzusammeln.[K] Viel Glück.", italian="Bene, io vado a cercare gli\nIngranaggi del Tempo.[K] Buona fortuna.", spanish="Bueno, ahora debo marcharme a\nreunir los Engranajes del Tiempo.[K] Buena suerte."})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_juputoru, 276, 140, false, 2)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(15)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(90)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Now...", french=" Bon...", german=" Also...", italian=" Ora...", spanish=" Ahora..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Now...", french=" Bon...", german=" Also...", italian=" Ora...", spanish=" Ahora..."})
  else
  SkySceneKit.say({english=" Now...", french=" Bon...", german=" Also...", italian=" Ora...", spanish=" Ahora..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We should go searching too.[K]\nLet's find the [CS:P]Hidden Land[CR]!", french="On devrait se mettre en route,\nnous aussi.[K] Trouvons les [CS:P]Terres Illusoires[CR]!", german="Wir sollten uns auch auf die\nSuche machen.[K] Lass uns das [CS:P]Verborgene Land[CR]\nfinden!", italian="Dobbiamo metterci alla ricerca\nanche noi.[K] Troviamo la [CS:P]Terra Nascosta[CR]!", spanish="Nosotros también debemos\niniciar nuestra búsqueda.[K]\n¡Hay que encontrar la [CS:P]Tierra Oculta[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We should go searching too.[K]\nLet's find the [CS:P]Hidden Land[CR]!", french="On devrait se mettre en route,\nnous aussi.[K] Trouvons les [CS:P]Terres Illusoires[CR]!", german="Wir sollten uns auch auf die\nSuche machen.[K] Lass uns das [CS:P]Verborgene Land[CR]\nfinden!", italian="Dobbiamo metterci alla ricerca\nanche noi.[K] Troviamo la [CS:P]Terra Nascosta[CR]!", spanish="Nosotros también debemos\niniciar nuestra búsqueda.[K]\n¡Hay que encontrar la [CS:P]Tierra Oculta[CR]!"})
  else
  SkySceneKit.say({english="We should go searching too.[K]\nLet's find the [CS:P]Hidden Land[CR]!", french="On devrait se mettre en route,\nnous aussi.[K] Trouvons les [CS:P]Terres Illusoires[CR]!", german="Wir sollten uns auch auf die\nSuche machen.[K] Lass uns das [CS:P]Verborgene Land[CR]\nfinden!", italian="Dobbiamo metterci alla ricerca\nanche noi.[K] Troviamo la [CS:P]Terra Nascosta[CR]!", spanish="Nosotros también debemos\niniciar nuestra búsqueda.[K]\n¡Hay que encontrar la [CS:P]Tierra Oculta[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  else
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So...[K]where should we begin\nlooking?", french="Alors...[K] par où est-ce qu'on\ncommence les recherches?", german="Also...[K] Wo sollen wir mit der\nSuche beginnen?", italian="Dunque...[K] Da dove potremmo\ncominciare a cercare?", spanish="Entonces...[K]\n¿Por dónde empezamos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So...[K]where shall we begin\nlooking?", french="Alors...[K] par où est-ce qu'on\ncommence les recherches?", german="Also...[K] Wo sollen wir mit der\nSuche beginnen?", italian="Dunque...[K] Da dove potremmo\ncominciare a cercare?", spanish="Entonces...[K]\n¿Por dónde empezamos?"})
  else
  SkySceneKit.say({english="So...[K]where should we begin\nlooking?", french="Alors...[K] par où est-ce qu'on\ncommence les recherches?", german="Also...[K] Wo sollen wir mit der\nSuche beginnen?", italian="Dunque...[K] Da dove potremmo\ncominciare a cercare?", spanish="Entonces...[K]\n¿Por dónde empezamos?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Umm...", french=" Hmm...", german=" Ähm...", italian=" Uhm...", spanish=" Hum..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Umm...", french=" Hmm...", german=" Ähm...", italian=" Uhm...", spanish=" Hum..."})
  else
  SkySceneKit.say({english=" Umm...", french=" Hmm...", german=" Ähm...", italian=" Uhm...", spanish=" Hum..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="As a start, why don't we think\nabout how we can cross the sea?", french="Pour commencer, on pourrait\nréfléchir à un moyen de traverser la mer?", german="Warum denken wir fürs Erste\nnicht darüber nach, wie wir den Ozean\nüberqueren können?", italian="Per cominciare, perché non\npensiamo a come attraversare il mare?", spanish="¿Qué tal si primero averiguamos\ncómo se puede cruzar el mar?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="For the time being, why don't we\nconsider how we can cross the sea?", french="Pour commencer, on pourrait\nréfléchir à un moyen de traverser la mer?", german="Warum denken wir fürs Erste\nnicht darüber nach, wie wir über den Ozean\nkommen?", italian="Per cominciare, perché non\npensiamo a come attraversare il mare?", spanish="¿Qué tal si primero averiguamos\ncómo se puede cruzar el mar?"})
  else
  SkySceneKit.say({english="As a start, why don't we think\nabout how we can cross the sea?", french="Pour commencer, on pourrait\nréfléchir à un moyen de traverser la mer?", german="Warum denken wir fürs Erste\nnicht darüber nach, wie wir über den Ozean\nkommen?", italian="Per cominciare, perché non\npensiamo a come attraversare il mare?", spanish="¿Qué tal si primero averiguamos\ncómo se puede cruzar el mar?"})
  end
  -- message_Close
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  GAME:WaitFrames(2) -- join WaitBgm2
  SkySceneKit.cleanup_npcs()
end
