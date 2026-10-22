-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/m12d1212.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Hidden Highland.ogg", true) end)
  -- back_SetGround(LEVEL_D01P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yep. With the memory\nof a name...", french="Oui, seul le souvenir de son nom\nlui restait...", german="Ja. Mit der Erinnerung an einen\nNamen...", italian="Esatto. Si ricordava soltanto\nil suo nome...", spanish=" Sí, aún recordaba su nombre..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yes. With the memory\nof a name...", french="Oui, seul le souvenir de son nom\nlui restait...", german="Ja. Mit der Erinnerung an einen\nNamen...", italian="Esatto. Si ricordava soltanto\nil suo nome...", spanish=" Sí, aún recordaba su nombre..."})
  else
  SkySceneKit.say({english="Yes. With the memory\nof a name...", french="Oui, seul le souvenir de son nom\nlui restait...", german="Ja. Mit der Erinnerung an einen\nNamen...", italian="Esatto. Si ricordava soltanto\nil suo nome...", spanish=" Sí, aún recordaba su nombre..."})
  end
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 344, 176, Direction.DownRight, "NPC_YONOWAARU")
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Right)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...and the memory of being a\nhuman before that!", french="... et celui d'avoir été\nun être humain avant!", german="Und daran, früher ein Mensch\ngewesen zu sein!", italian="... e che prima di allora, era un\nessere umano!", spanish="¡Y sabía que antes había sido\nun ser humano!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...and the memory of being a\nhuman before that!", french="... et celui d'avoir été\nun être humain avant!", german="Und daran, früher ein Mensch\ngewesen zu sein!", italian="... e che prima di allora, era un\nessere umano!", spanish="¡Y sabía que antes había sido\nun ser humano!"})
  else
  SkySceneKit.say({english="...and the memory of being a\nhuman before that!", french="... et celui d'avoir été\nun être humain avant!", german="Und daran, früher ein Mensch\ngewesen zu sein!", italian="... e che prima di allora, era un\nessere umano!", spanish="¡Y sabía que antes había sido\nun ser humano!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" I beg your pardon?![K] H-human?!", french="Je vous demande pardon?![K]\nUn être humain?!", german=" Wie bitte?!?[K] Ein M-mensch?!?", italian="Che cosa hai detto?[K]\nU-Un essere umano?!", spanish="¡¿Cómo dices?![K]\n¡¿Un ser... humano?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back_SetBackEffect(4) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CN]So, a former human...[K]\n[CN]With no memories...", french="[CN]Ainsi, un ancien être humain...[K]\n[CN]sans aucun souvenir...", german="[CN]Also, ein ehemaliger Mensch...[K]\n[CN]Ohne Erinnerungen...", italian="[CN]Una volta essere umano...[K]\n[CN]... ora senza più memoria...", spanish="[CN]Así que, un Pokémon que antes era humano...[K]\n[CN]Sin recuerdos..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CN]A human that possessed\n[CN]the Dimensional Scream...", french="[CN]Un être humain doté\n[CN]du Cri Dimensionnel...", german="[CN]Ein Mensch\n[CN]mit dem Dimensionalen Schrei...", italian="[CN]Un essere umano con il potere\n[CN]dello Squarcio Dimensionale...", spanish="[CN]Un humano que poseía\n[CN]la Percepción de Cronos..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CN]I became convinced then!", french="[CN]Il n'en fallait pas plus pour me convaincre!", german="[CN]Da war ich überzeugt!", italian="[CN]In quel momento mi convinsi!", spanish="[CN]¡Eso me convenció!"})
  -- message_Close
  -- back_SetBackEffect(5) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" You...are...?", french=" Tu... es...?", german=" Bist... du...", italian=" Tu... sei...?", spanish=" ¿Y... te llamas...?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="You said you know your name,\nat least?", french="Tu dis connaître au moins\nton nom?", german="Du sagtest, dass du zumindest\ndeinen Namen weißt, oder?", italian="Mi avete detto che almeno il tuo\nnome lo ricordi, giusto?", spanish="Todavía recuerdas tu nombre,\n¿no?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" And...[K]that name would be...?", french="Et peut-on savoir...[K] quel est\nce nom...?", german=" Und...[K] Wie lautet dein Name?", italian=" E...[K] quel nome è...?", spanish=" Dime...[K] ¿Cómo te llamas?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CN][hero] told the\n[CN]name to [CS:N]Dusknoir[CR].", french="[CN][hero] dit son nom\n[CN]à [CS:N]Noctunoir[CR].", german="[CN][hero] nennt [CS:N]Zwirrfinst[CR]\n[CN]den Namen.", italian="[CN][hero] dice il suo nome a\n[CN][CS:N]Dusknoir[CR].", spanish="[CN][hero] le dijo su nombre\n[CN]a [CS:N]Dusknoir[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Ah! I see...", french=" Ah, je vois...", german=" Ah! Ich verstehe...", italian=" Oh...", spanish=" Así que..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" You're...[K][hero]...", french=" ... tu t'appelles [hero]...", german=" Du bist...[K] [hero]...", italian=" ... [hero]...", spanish=" [hero]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Does that name ring a bell?", french="Il vous dit quelque chose,\nce nom?", german=" Sagt dir dieser Name was?", italian=" Le dice niente questo nome?", spanish=" ¿Te suena de algo ese nombre?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Does that name mean anything\nto you?", french="Il vous dit quelque chose,\nce nom?", german=" Sagt dir dieser Name etwas?", italian=" Ha già sentito questo nome?", spanish=" ¿Te dice algo ese nombre?"})
  else
  SkySceneKit.say({english=" Does that name ring a bell?", french="Il vous dit quelque chose,\nce nom?", german=" Sagt dir der Name irgendwas?", italian=" Ha già sentito questo nome?", spanish=" ¿Te suena de algo ese nombre?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" ...[K]No.", french=" ...[K] Non.", german=" ...[K]Nein.", italian=" ...[K] No.", spanish=" ¿Eh?[K] No."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="It means nothing to me,\nunfortunately.", french="Il ne m'évoque rien du tout,\nhélas.", german=" Leider sagt er mir nichts.", italian="Sfortunatamente... non ho mai\nsentito questo nome prima d'ora.", spanish="Por desgracia, no lo había oído\nen mi vida."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Uh, what?!)", french="(Hein, quoi?!)", german="(Wie? Was?!?)", italian="(Mmm... Cos'è stato?)", spanish="(¡¿Qué?!)"})
  else
  SkySceneKit.say({english="(Uh, what?!)", french="(Hein, quoi?!)", german="(Wie? Was?!?)", italian="(Mmm... Cos'è stato?)", spanish="(¡¿Qué?!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Did I just see...[K]the faintest...)", french="(Est-ce que j'ai bien vu...[K] l'esquisse...)", german="(War das gerade...[K] der Anflug eines...)", italian="(Per un attimo...[K] mi è sembrato...)", spanish="(Me parece...[K] que...)"})
  else
  SkySceneKit.say({english="(Did I just see...[K]the faintest...)", french="(Est-ce que j'ai bien vu...[K] l'esquisse...)", german="(War das gerade...[K] der Anflug eines...)", italian="(Per un attimo...[K] mi è sembrato...)", spanish="(Me parece...[K] que...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Did [CS:N]Dusknoir[CR] just hide the faintest of\nsmiles?)", french="([CS:N]Noctunoir[CR] viendrait-il de réprimer l'esquisse\nd'un sourire?)", german="(Hat [CS:N]Zwirrfinst[CR] nicht gerade\nein Lächeln unterdrückt?)", italian="([CS:N]Dusknoir[CR] stava sorridendo?)", spanish="(Me ha parecido ver a [CS:N]Dusknoir[CR] esbozar una\nsonrisa...)"})
  else
  SkySceneKit.say({english="(Did [CS:N]Dusknoir[CR] just hide the faintest of\nsmiles?)", french="([CS:N]Noctunoir[CR] viendrait-il de réprimer l'esquisse\nd'un sourire?)", german="(Hat [CS:N]Zwirrfinst[CR] nicht gerade\nein Lächeln unterdrückt?)", italian="([CS:N]Dusknoir[CR] stava sorridendo?)", spanish="(Me ha parecido ver a [CS:N]Dusknoir[CR] esbozar una\nsonrisa...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Or did I imagine that...?)", french="(Ou c'était juste mon imagination...?)", german="(Oder habe ich mir das eingebildet?)", italian="(L'ho solo immaginato...?)", spanish="(¿O serán imaginaciones mías?)"})
  else
  SkySceneKit.say({english="(Or did I imagine that...?)", french="(Ou c'était juste mon imagination...?)", german="(Oder habe ich mir das eingebildet?)", italian="(L'ho solo immaginato...?)", spanish="(¿O serán imaginaciones mías?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back_SetBackEffect(4) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]There was no doubt!", french="[CN]Aucun doute possible!", german="[CN]Es bestand kein Zweifel mehr!", italian="[CN]Non c'era alcun dubbio!", spanish="[CN]¡No había ninguna duda!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]This [hero] was the very\n[CN]one that I had been seeking!", french="[CN][hero] était bel et bien\n[CN]la personne que je cherchais!", german="[CN][hero] war die Person,\n[CN]die ich gesucht hatte!", italian="[CN]Era [hero]! Proprio chi stavo cercando!", spanish="[CN]¡[hero] era justo\n[CN]quien había estado buscando!"})
  -- message_Close
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
