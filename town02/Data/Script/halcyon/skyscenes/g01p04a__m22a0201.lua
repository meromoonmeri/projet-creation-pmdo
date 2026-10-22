-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m22a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  local npc_npc_kootasu = SkySceneKit.spawn_npc("torkoal", 328, 216, Direction.Down, "NPC_KOOTASU")
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="Huff-huff...[K] Finally, I caught up\nwith you.", french="Humpf humpf...[K] Enfin,\nje vous retrouve.", german="Keuch, keuch...[K] Habe ich euch\nendlich eingeholt.", italian="Uff-uff...[K] Alla fine, sono\nriuscito a trovarvi.", spanish=" Uf, uf...[K] Al fin he llegado."})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="Huff-huff... Climbing up to this\nguild is hard on these old bones.", french="Humpf humpf... Faire de\nla grimpette jusqu'à la Guilde, c'est plus\nde mon âge.", german="Keuch, keuch... Diese Stufen zur\nGilde sind nichts für meine alten Knochen.", italian="Uff-uff... Per le mie vecchie\nossa è faticoso arrampicarsi fino alla Gilda.", spanish="Uf, uf... Subir hasta aquí va a\nacabar con mis pobres huesos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What brings you here, [CS:N]Torkoal[CR]?", french="Qu'est-ce qui t'amène ici,\n[CS:N]Chartor[CR]?", german=" Was führt dich hierher, [CS:N]Qurtel[CR]?", italian=" Cosa ti porta qui, [CS:N]Torkoal[CR]?", spanish=" ¿Qué te trae por aquí, [CS:N]Torkoal[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What brings you here, [CS:N]Torkoal[CR]?", french="Qu'est-ce qui t'amène ici,\n[CS:N]Chartor[CR]?", german=" Was führt dich hierher, [CS:N]Qurtel[CR]?", italian=" Cosa ti porta qui, [CS:N]Torkoal[CR]?", spanish=" ¿Cómo tú por aquí, [CS:N]Torkoal[CR]?"})
  else
  SkySceneKit.say({english=" What brings you here, [CS:N]Torkoal[CR]?", french="Qu'est-ce qui t'amène ici,\n[CS:N]Chartor[CR]?", german=" Was führt dich hierher, [CS:N]Qurtel[CR]?", italian=" Cosa ti porta qui, [CS:N]Torkoal[CR]?", spanish=" ¿Qué haces por aquí, [CS:N]Torkoal[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Did you...[K]maybe remember\nsomething?", french="Est-ce que...[K] tu te serais\nsouvenu de quelque chose, par hasard?", german="Hast du...[K] Hast du dich an etwas\nerinnert?", italian="Ti è...[K] tornato in mente\nqualcosa?", spanish="¿Quizás...?[K] ¿Has conseguido\nrecordar algo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Did you...[K]maybe remember\nsomething?", french="Est-ce que...[K] tu te serais\nsouvenu de quelque chose, par hasard?", german="Hast du...[K] Hast du dich an etwas\nerinnert?", italian="Ti è...[K] tornato in mente\nqualcosa?", spanish="¿Quizás...?[K] ¿Has conseguido\nrecordar algo?"})
  else
  SkySceneKit.say({english="Did you...[K]maybe remember\nsomething?", french="Est-ce que...[K] tu te serais\nsouvenu de quelque chose, par hasard?", german="Hast du...[K] Hast du dich an etwas\nerinnert?", italian="Ti è...[K] tornato in mente\nqualcosa?", spanish="¿Quizás...?[K] ¿Has conseguido\nrecordar algo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="Indeed, I did.[K] But I've recalled\nonly one more tiny thing, sorry to say...", french="En effet.[K] Mais c'est juste\nun détail infime, à vrai dire...", german="Das habe ich tatsächlich.[K] Aber\nmir ist leider nur noch eine winzige Kleinigkeit\neingefallen.", italian="A dire il vero, sì.[K] Ma è solo\nuna cosa di poca importanza, mi spiace...", spanish="Pues sí.[K] Pero lamento deciros\nque se trata de un detalle minúsculo..."})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="Yesterday, I contemplated the\nwaters of the Hot Spring for a long time.\nFinally, one recollection surfaced.", french="Hier, j'ai longtemps contemplé\nles eaux de la Source Chaude. Jusqu'à ce\nqu'enfin, un souvenir me revienne.", german="Gestern betrachtete ich die\nWasser der Heißen Quelle lange und eingehend.\nSchließlich kam eine Erinnerung wieder.", italian="Ieri, mentre contemplavo\nl'acqua della Sorgente Termale, mi è\ntornato alla mente un ricordo.", spanish="Ayer contemplé las aguas de\nla Terma un largo rato. Y, finalmente, algo\nme vino a la mente."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" But...[K]it really is something small.", french="Mais...[K] ce n'est vraiment pas\ngrand-chose.", german="Aber...[K] Es ist wirklich nur eine\nKleinigkeit.", italian="Ma...[K] è davvero una cosa da\npoco.", spanish=" Pero...[K] es una cosilla de nada."})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="I worry if it would be even\nworthwhile sharing with you.", french="Je me demande même si ça vaut\nla peine que je vous le dise.", german="Ich frage mich, ob es sich\nüberhaupt lohnt, sie euch mitzuteilen.", italian="Mi sono anche chiesto se valesse\nla pena venire fin qui per informarvi.", spanish="Ni siquiera sé si merece la pena\ncontárosla."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 360, 216, Direction.DownLeft, "NPC_PUKURIN")
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Not a worry! ♪", french=" Ne t'inquiète pas! ♪", german=" Kein Problem! ♪", italian=" Non preoccuparti! ♪", spanish=" ¡Claro que sí! ♪"})
  GROUND:EntTurn(npc_npc_kootasu, Direction.Right)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Every little bit of information\nhelps! However small! ♪", french="La moindre information peut\nnous aider! La moindre! ♪", german="Jede Information hilft uns\nweiter! Ganz egal, wie klein sie auch ist! ♪", italian="Ogni minima informazione ci può\nessere d'aiuto! Per quanto di poco conto! ♪", spanish="¡Cualquier información nos\nayudará, por pequeña que sea! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Please, say it! Say it! ♪", french="Allez, dis-nous! Dis-nous,\ns'il te plaît! ♪", german="Bitte sag schon! Rück raus\ndamit! ♪", italian=" Ti prego, dicci! Dicci tutto! ♪", spanish="¡Dínosla, por favor!\n¡Dínosla! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_kootasu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="When we spoke of travel to the\n[CS:P]Hidden Land[CR] yesterday...[K] I said that you needed\nproof of your qualification to go there.", french="Hier, quand nous avons parlé\nd'accéder aux [CS:P]Terres Illusoires[CR]...[K] Je vous ai\ndit qu'il faudrait une preuve de vos aptitudes.", german="Als wir gestern über die Reise\nzum [CS:P]Verborgenen Land[CR] sprachen...[K] Da sagte ich\neuch, dass ihr dazu einen Nachweis bräuchtet.", italian="Quando ieri abbiamo parlato del\nviaggio alla [CS:P]Terra Nascosta[CR]...[K] vi dissi che\nserviva una prova dei vostri requisiti.", spanish="Cuando ayer hablamos de viajar\na la [CS:P]Tierra Oculta[CR]...[K] Os dije que hacía falta\npasar una prueba para llegar allí."})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="I remembered a bit more about\nthat proof.", french="Je me suis souvenu de quelque\nchose au sujet de cette preuve.", german="Mir fiel noch etwas zu diesem\nNachweis ein.", italian="Mi sono ricordato qualcosa di più\na proposito della prova.", spanish="He recordado algo más sobre\nesa prueba."})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="The proof...[K]bears an inscription\nof a certain pattern.", french="Sur la preuve...[K] est gravé\nun symbole.", german="Der Nachweis...[K] Er trägt eine\nInschrift mit einem bestimmten Muster.", italian="La prova...[K] ha un'incisione\ncon un disegno particolare.", spanish="Tiene algo que ver...[K] con\nuna inscripción, un dibujo de una forma\ndeterminada."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" A certain pattern?", french=" Un symbole?", german=" Ein bestimmtes Muster?", italian=" Un disegno particolare?", spanish=" ¿Con una forma determinada?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" A certain pattern?", french=" Un symbole?", german=" Ein bestimmtes Muster?", italian=" Un disegno particolare?", spanish=" ¿Con una forma determinada?"})
  else
  SkySceneKit.say({english=" A certain pattern?", french=" Un symbole?", german=" Ein bestimmtes Muster?", italian=" Un disegno particolare?", spanish=" ¿Con una forma determinada?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 376, 256, Direction.UpLeft, "NPC_HEIGANI")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! So what kind of\npattern would that be?", french="Eh dis donc, quel genre de\nsymbole?", german="Hey, hey! Was für ein Muster\nsoll das denn sein?", italian=" Ehi, ehi! Che tipo di disegno?", spanish="¡Oye, oye!\n¿Y cuál es esa forma determinada?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" Er...[K] How can I describe it?", french=" Euh...[K] comment le décrire?", german="Ähm...[K] Wie kann ich es\nbeschreiben?", italian=" Ehm...[K] Come posso descriverlo?", spanish=" Esto...[K] ¿Cómo puedo describirla?"})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" It's difficult to describe it...", french=" Ce n'est pas facile à décrire...", german=" Es ist schwer zu beschreiben...", italian=" È difficile da spiegare...", spanish=" Es difícil hacerlo..."})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="But I can tell you that the\npattern is quite intricate and odd.", french="Mais je peux vous dire que c'est\nun symbole assez bizarre et compliqué.", german="Aber ich kann euch sagen, dass\ndas Muster recht kompliziert und ungewöhnlich\nist.", italian="Tutto quello che so è che si\ntratta di un disegno piuttosto strano e molto\ncomplicato.", spanish="Pero os puedo decir que es\nintrincada y bastante extraña."})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="It's a peculiar pattern. The kind\nof pattern you rarely see.", french="Un symbole étrange, comme\non en voit rarement.", german="Es ist ein seltsames Muster.\nEins von der Art, die man selten sieht.", italian="È un disegno particolare, che\nnon si vede tutti i giorni.", spanish="Un dibujo muy peculiar, no es\nalgo que se vea a menudo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 336, 272, Direction.Up, "NPC_BIPPA")
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" A pattern you rarely see...[K] Golly!", french="Un symbole qu'on voit pas\nsouvent...[K] Sapristi!", german="Von der Art, die man selten\nsieht...[K] Donnerwetter!", italian=" Un disegno raro...[K] Ohibò!", spanish="Una forma que no se ve a\nmenudo...[K] ¡Huyuyuy!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 264, 256, Direction.UpRight, "NPC_DOGOOMU")
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="You'd think I could think of\nsomething!", french="Alors moi, j'en sais rien\ndu tout, hein!", german="Man sollte meinen, ich könnte\nmir so etwas vorstellen!", italian="Se solo mi venisse in mente\nqualcosa!", spanish=" ¿Y a mí me preguntas?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 360, 272, Direction.UpLeft, "NPC_KIMAWARI")
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="But trying to think of such a\nthing! It's not easy when one tries!", french="Mais plus on réfléchit à ce\ngenre de choses, moins on a de chances de\ntrouver!", german="Aber sich so eine Vorstellung\nvorzustellen! Das ist nicht einfach, wenn man\nes versucht!", italian="Non è proprio facile...\nChissà di cosa si tratta!", spanish="¡No es nada fácil pensar en algo\nasí, por mucho que se intente!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 272, 240, Direction.UpRight, "NPC_CHIRIIN")
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Hmm...what could it be...?", french="Hmm... Qu'est-ce que ça pourrait\nbien être...?", german=" Hmm... Was könnte es sein?", italian=" Mmm... Cosa potrebbe essere...?", spanish=" Hum... ¿Cuál será...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  else
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The kind of pattern you rarely see...)", french="(Un symbole comme on en voit rarement...)", german="(Ein Muster von der seltenen Art...)", italian="(Un tipo di disegno raro...)", spanish="(Un dibujo que no se ve a menudo...)"})
  else
  SkySceneKit.say({english="(The kind of pattern you rarely see...)", french="(Un symbole comme on en voit rarement...)", german="(Ein Muster von der seltenen Art...)", italian="(Un tipo di disegno raro...)", spanish="(Un dibujo que no se ve a menudo...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What could a pattern like that look like...?)", french="(A quoi ça pourrait bien ressembler...?)", german="(Wie könnte ein solches Muster aussehen?)", italian="(Cosa potrebbe rappresentare un disegno\ndel genere...?)", spanish="(¿Cómo podría ser...?)"})
  else
  SkySceneKit.say({english="(What could a pattern like that look like...?)", french="(A quoi ça pourrait bien ressembler...?)", german="(Wie könnte ein solches Muster aussehen?)", italian="(Cosa potrebbe rappresentare un disegno\ndel genere...?)", spanish="(¿Cómo podría ser...?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(A pattern you rarely see...[K] A peculiar...)", french="(Un symbole comme on en voit rarement...[K]\nUn symbole particulier...)", german="(Ein Muster der seltenen Art...[K] Ein\nseltsames...)", italian="(Un disegno raro...[K] Particolare...)", spanish="(Un dibujo que no se ve a menudo...[K]\nDe forma extraña...)"})
  else
  SkySceneKit.say({english="(A pattern you rarely see...[K] A peculiar...)", french="(Un symbole comme on en voit rarement...[K]\nUn symbole particulier...)", german="(Ein Muster der seltenen Art...[K] Ein\nseltsames...)", italian="(Un disegno raro...[K] Particolare...)", spanish="(Un dibujo que no se ve a menudo...[K]\nDe forma extraña...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Wait a second![K] A peculiar pattern?)", french="(Mais![K] Un symbole particulier?)", german="(Warte mal![K] Ein seltsames Muster?)", italian="(Aspetta un attimo![K] Un disegno particolare?)", spanish="(¡Un momento![K] ¿Una forma extraña?)"})
  else
  SkySceneKit.say({english="(Wait a second![K] A peculiar pattern?)", french="(Mais![K] Un symbole particulier?)", german="(Warte mal![K] Ein seltsames Muster?)", italian="(Aspetta un attimo![K] Un disegno particolare?)", spanish="(¡Un momento![K] ¿Una forma extraña?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(A peculiar pattern![K] I remember that time...)", french="(Un symbole particulier![K] Je me souviens...)", german="(Ein seltsames Muster![K] Ich erinnere mich...\nDamals...)", italian="(Un disegno particolare![K] Mi ricordo quella\nvolta...)", spanish="(¡Un dibujo poco habitual![K]\nAcabo de recordar aquella ocasión en la que...)"})
  else
  SkySceneKit.say({english="(A peculiar pattern![K] I remember that time...)", french="(Un symbole particulier![K] Je me souviens...)", german="(Ein seltsames Muster![K] Ich erinnere mich...\nDamals...)", italian="(Un disegno particolare![K] Mi ricordo quella\nvolta...)", spanish="(¡Un dibujo poco habitual![K]\nAcabo de recordar aquella ocasión en la que...)"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
