-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D10P21A/m10a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(11, 4) -- $SCENARIO_MAIN = scn[11,4] (ROM)
  -- back_SetGround(LEVEL_D10P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: se_Play(6933) — id SE NDS sans portage PMDO identifié
  SkySceneKit.say({english="GRROOOOOOH...!", french="GRROOOOOOH...!", german="GRROOOOOOH!", italian="GRROOOOOOH...!", spanish="¡GRRRRRRRR!"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Did you hear that,\n[hero]?!", french="Tu as entendu ça,\n[hero]?!", german="Hast du das gehört,\n[hero]?!?", italian=" Hai sentito, [hero]?", spanish=" ¡¿Has oído eso, [hero]?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Did you hear that,\n[hero]?!", french="Tu as entendu ça,\n[hero]?!", german="Hast du das gehört,\n[hero]?!?", italian="Hai sentito anche tu,\n[hero]?", spanish=" ¡¿Has oído eso, [hero]?!"})
  else
  SkySceneKit.say({english="Did you hear that,\n[hero]?!", french="Tu as entendu ça,\n[hero]?!", german="Hast du das gehört,\n[hero]?!?", italian="Hai sentito anche tu,\n[hero]?", spanish=" ¡¿Has oído eso, [hero]?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So, I didn't imagine that sound\nafter all!", french="Alors, je n'ai pas rêvé,\nfinalement!", german="Also habe ich mir das Geräusch\ndoch nicht eingebildet!", italian="Allora quel rumore non era solo\nnella mia testa!", spanish="¡Supongo que después de todo no\neran imaginaciones mías!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So, I didn't imagine that sound\nafter all!", french="Alors, je n'ai pas rêvé,\nfinalement!", german="Also habe ich mir das Geräusch\ndoch nicht eingebildet!", italian="Allora quel suono non era solo\nnella mia testa!", spanish="¡Supongo que después de todo no\neran imaginaciones mías!"})
  else
  SkySceneKit.say({english="So, that sound wasn't just in\nmy head!", french="Alors, je n'ai pas rêvé,\nfinalement!", german="Also habe ich mir das Geräusch\ndoch nicht eingebildet!", italian="Allora quel suono non era solo\nnella mia testa!", spanish="¡Supongo que después de todo no\neran imaginaciones mías!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It sounded like a roar!", french="On aurait dit une sorte de\nrugissement!", german="Es hat sich wie ein lautes\nBrüllen angehört!", italian=" Sembrava un ruggito!", spanish=" ¡Parecía un rugido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It was like some sort of roar!", french="On aurait dit une sorte de\nrugissement!", german="Es hat sich wie eine Art\nBrüllen angehört!", italian=" Sembrava un ruggito!", spanish=" ¡Parecía un rugido!"})
  else
  SkySceneKit.say({english=" It was like some sort of roar!", french="On aurait dit une sorte de\nrugissement!", german="Es hat sich wie eine Art\nBrüllen angehört!", italian=" Sembrava un ruggito!", spanish=" ¡Parecía un rugido!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But I wonder what it could be!", french="Je me demande ce que ça peut\nbien être!", german="Aber ich frage mich, was es\nsein kann!", italian=" Ma che sarà?", spanish=" Me pregunto qué será."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But I wonder what it could be!", french="Je me demande ce que ça peut\nbien être!", german="Aber ich frage mich, was es\nsein kann!", italian=" Cosa sarà mai?", spanish=" Me pregunto qué será."})
  else
  SkySceneKit.say({english=" But I wonder what it could be!", french="Je me demande ce que ça peut\nbien être!", german="Aber ich frage mich, was es\nsein kann!", italian=" Cosa sarà mai?", spanish=" Me pregunto qué será."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" There's no telling what's ahead!", french=" Qui sait ce qui nous attend?", german="Es ist unmöglich zu sagen, was\nuns bevorsteht!", italian="Beh, c'è solo un modo per\nscoprirlo!", spanish=" ¡Quién sabe lo que nos espera!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Who knows what's ahead?", french=" Qui sait ce qui nous attend?", german=" Wer weiß, was uns erwartet?", italian=" Chissà cosa ci aspetta...", spanish=" ¡Quién sabe lo que nos espera!"})
  else
  SkySceneKit.say({english=" Who can say what's ahead?", french=" Qui sait ce qui nous attend?", german=" Wer weiß, was uns bevorsteht?", italian=" Chissà cosa ci aspetta...", spanish=" ¡Quién sabe lo que nos espera!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But we have to tough it out!\nWe have to keep moving!", french="Mais il faut tenir bon!\nContinuons!", german="Aber wir müssen es\ndurchstehen! Wir müssen weitergehen!", italian="Andiamo fino in fondo!\nSu! Muoviamoci!", spanish="Pero hay que ser valientes.\nTenemos que seguir avanzando."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But let's be brave! And let's\nkeep going on!", french="Mais il faut tenir bon!\nContinuons!", german="Aber seien wir tapfer!\nUnd gehen wir weiter!", italian="Beh, forza e coraggio! Andiamo\ne raggiungiamo la vetta!", spanish="Pero hay que ser valientes.\nTenemos que seguir avanzando."})
  else
  SkySceneKit.say({english="Oooh, we have to be brave!\nWe need to keep going on!", french="Mais il faut tenir bon!\nContinuons!", german="Uuuh, wir müssen tapfer sein!\nWir müssen weitergehen!", italian="Beh, forza e coraggio! Andiamo\ne raggiungiamo la vetta!", spanish="Pero hay que ser valientes.\nTenemos que seguir avanzando."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Not far to go now.[K] Let's do this!", french="On approche du but.[K]\nFinissons-en!", german="Es ist nicht mehr weit.[K]\nWir schaffen das!", italian=" Non manca molto.[K] Forza!", spanish=" Ya no queda mucho.[K] ¡Sigamos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We're nearly there.[K] Let's go!", french="On approche du but.[K]\nFinissons-en!", german=" Wir sind fast da.[K] Gehen wir!", italian="Ci siamo quasi, ormai.[K]\nAndiamo!", spanish=" Ya casi hemos llegado.[K] ¡Sigamos!"})
  else
  SkySceneKit.say({english="Almost there, I think![K] So let's\ndo this!", french="On approche du but.[K]\nFinissons-en!", german="Ich glaube, wir sind fast da![K]\nLass es uns anpacken!", italian="Ci siamo quasi, ormai.[K]\nAndiamo!", spanish=" Ya no queda mucho.[K] ¡Sigamos!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 212, 4, false, 2)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Yes.[K] We are nearly there.)", french="(Oui.[K] On y est presque.)", german="(Ja.[K] Wir sind beinahe da.)", italian="(È vero.[K] Ci siamo quasi.)", spanish="(Sí.[K] Ya casi estamos.)"})
  else
  SkySceneKit.say({english="(Yes.[K] We are nearly there.)", french="(Oui.[K] On y est presque.)", german="(Ja.[K] Wir sind beinahe da.)", italian="(È vero.[K] Ci siamo quasi.)", spanish="(Sí.[K] Ya casi estamos.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(And when we reach the top...)", french="(Et une fois au sommet...)", german="(Und wenn wir den Gipfel erreichen...)", italian="(Quando arriveremo in cima...)", spanish="(Y cuando lleguemos arriba...)"})
  else
  SkySceneKit.say({english="(And when we reach the top...)", french="(Et une fois au sommet...)", german="(Und wenn wir den Gipfel erreichen...)", italian="(Quando arriveremo in cima...)", spanish="(Y cuando lleguemos arriba...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(We may meet [CS:N]Uxie[CR] at last.)", french="(Peut-être qu'on trouvera enfin [CS:N]Créhelf[CR].)", german="(Dann treffen wir vielleicht endlich [CS:N]Selfe[CR].)", italian="(Finalmente potremo incontrare [CS:N]Uxie[CR].)", spanish="(Tal vez encontremos por fin a [CS:N]Uxie[CR].)"})
  else
  SkySceneKit.say({english="(We may meet [CS:N]Uxie[CR] at last.)", french="(Peut-être qu'on trouvera enfin [CS:N]Créhelf[CR].)", german="(Dann treffen wir vielleicht endlich [CS:N]Selfe[CR].)", italian="(Finalmente potremo incontrare [CS:N]Uxie[CR].)", spanish="(Tal vez encontremos por fin a [CS:N]Uxie[CR].)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It may answer my big question! Who am I?)", french="(Il répondra peut-être à ma question\nexistentielle! Qui suis-je?)", german="(Vielleicht bekomme ich von ihm eine Antwort\nauf meine große Frage! Wer bin ich?)", italian="(Forse riuscirà a dirmi chi sono.)", spanish="(Puede que responda a mi gran pregunta:\n¿Quién soy?)"})
  else
  SkySceneKit.say({english="(It may answer my big question! Who am I?)", french="(Il répondra peut-être à ma question\nexistentielle! Qui suis-je?)", german="(Vielleicht bekomme ich von ihm eine Antwort\nauf meine große Frage! Wer bin ich?)", italian="(Forse riuscirà a dirmi chi sono.)", spanish="(Puede que responda a mi gran pregunta:\n¿Quién soy?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That is, who was I...before I lost my\nmemory?)", french="(Ou plutôt, qui étais-je... avant de perdre\nla mémoire?)", german="(Das heißt, wer war ich, bevor ich mein\nGedächtnis verlor?)", italian="(O meglio... chi ero... prima di perdere la\nmemoria.)", spanish="(Es decir, quién era antes de perder\nla memoria...)"})
  else
  SkySceneKit.say({english="(That is, who was I...before I lost my\nmemory?)", french="(Ou plutôt, qui étais-je... avant de perdre\nla mémoire?)", german="(Das heißt, wer war ich, bevor ich mein\nGedächtnis verlor?)", italian="(O meglio... chi ero... prima di perdere la\nmemoria.)", spanish="(Es decir, quién era antes de perder\nla memoria...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That reminds me...[K] I still haven't said a word\nabout this to [partner].)", french="(Ça me rappelle que...[K] je n'ai toujours pas dit\nun mot de tout ça à [partner].)", german="(Da fällt mir ein...[K] Ich habe [partner] noch\nimmer kein Wort davon erzählt.)", italian="(Ora che ci penso...[K] non ho ancora parlato di\nquesto a [partner].)", spanish="(Eso me recuerda que...[K] aún no le he contado\nnada de esto a [partner].)"})
  else
  SkySceneKit.say({english="(That reminds me...[K] I still haven't said a word\nabout this to [partner].)", french="(Ça me rappelle que...[K] je n'ai toujours pas dit\nun mot de tout ça à [partner].)", german="(Da fällt mir ein...[K] Ich habe [partner] noch\nimmer kein Wort davon erzählt.)", italian="(Ora che ci penso...[K] non ho ancora parlato di\nquesto a [partner].)", spanish="(Eso me recuerda que...[K] aún no le he contado\nnada de esto a [partner].)"})
  end
  -- message_Close
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(partner, 212, 92, false, 2)
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Huh?[K] What's on your mind,\n[hero]?", french="Hein?[K] Qu'est-ce que tu as\nsur le cœur, [hero]?", german="Ähem?[K] An was denkst du,\n[hero]?", italian="Uh?[K] A che stai pensando,\n[hero]?", spanish="Oye...[K] ¿En qué estás pensando,\n[hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes?[K] What is it, [hero]?", french="Hein?[K] Qu'est-ce que tu as\nsur le cœur, [hero]?", german="Ähem?[K] An was denkst du,\n[hero]?", italian=" Eh?[K] Che cos'hai, [hero]?", spanish=" Oye...[K] ¿Qué pasa, [hero]?"})
  else
  SkySceneKit.say({english=" Yes?[K] What is it, [hero]?", french="Hein?[K] Qu'est-ce que tu as\nsur le cœur, [hero]?", german="Ja?[K] Was ist denn,\n[hero]?", italian=" Eh?[K] Che cos'hai, [hero]?", spanish=" Oye...[K] ¿Qué pasa, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You want to tell me something?", french=" Tu as quelque chose à me dire?", german=" Willst du mir etwas sagen?", italian=" C'è qualcosa che vuoi dirmi?", spanish=" ¿Quieres contarme algo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You have something to tell me?", french=" Tu as quelque chose à me dire?", german=" Du musst mir etwas sagen?", italian=" C'è qualcosa che vuoi dirmi?", spanish=" ¿Tienes algo que contarme?"})
  else
  SkySceneKit.say({english="Hmm? You have something\nimportant to tell me?", french=" Tu as quelque chose à me dire?", german="Hmm? Du musst mir etwas\nWichtiges sagen?", italian=" C'è qualcosa che vuoi dirmi?", spanish="¿Quieres contarme algo\nimportante?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yeah? Go ahead!", french=" Vas-y, dis-moi!", german=" Ja? Schieß los!", italian=" È così? Spara!", spanish=" ¿Sí? Dime."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What is it?", french=" Vas-y, dis-moi!", german=" Was ist es?", italian=" Cosa c'è?", spanish=" ¿De qué se trata?"})
  else
  SkySceneKit.say({english=" OK, go ahead!", french=" Vas-y, dis-moi!", german=" Okay, schieß los!", italian=" Dimmi pure!", spanish=" ¡Venga, adelante!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 212, 124, false, 2)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][hero] confessed what happened\n[CN]since arriving at base camp...", french="[CN][hero] raconte ce qui s'est passé\n[CN]depuis l'arrivée au camp de base...", german="[CN][hero] berichtet, was geschehen ist,\n[CN]seit sie das Basislager erreicht haben.", italian="[CN][hero] racconta cosa è successo\n[CN]dal loro arrivo al Campo Base...", spanish="[CN][hero] le contó lo sucedido\n[CN]tras llegar al campamento base..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Uh...[K]you what?!", french=" Hein...[K] tu quoi?!", german=" Äh...[K] du hast was?!?", italian=" ...[K] COSA?!", spanish=" Esto...[K] ¡¿Qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You...[K]you what?", french=" Hein...[K] tu quoi?!", german=" Äh...[K] du hast was?!?", italian=" Che...[K] Che cosa?", spanish=" Eh...[K] ¿Qué me estás contando?"})
  else
  SkySceneKit.say({english=" I beg...[K]I beg your pardon?", french=" Hein...[K] tu quoi?!", german=" Wie war...[K] Wie war das eben?", italian=" ...[K] Come?", spanish=" ¿Cómo?[K] ¿Cómo dices?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ever since we hit base camp...", french="Depuis qu'on a rejoint le camp\nde base...", german=" Seit wir im Basislager sind...", italian="Da quando siamo arrivati al\nCampo Base...", spanish="Desde que llegamos al\ncampamento base..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Ever since we reached\nbase camp...", french="Depuis qu'on a rejoint le camp\nde base...", german="Seit wir das Basislager erreicht\nhaben...", italian="Da quando siamo arrivati al\nCampo Base...", spanish="Desde que llegamos al\ncampamento base..."})
  else
  SkySceneKit.say({english="Ever since we arrived at\nbase camp...", french="Depuis qu'on a rejoint le camp\nde base...", german="Seit wir im Basislager\nangekommen sind...", italian="È da quando eravamo al\nCampo Base...", spanish="Desde que llegamos al\ncampamento base..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You've had the strange feeling\nthat you know this place?!", french="... tu as le sentiment étrange\nd'avoir déjà vu cet endroit auparavant?!", german="Seither hast du das seltsame\nGefühl, diesen Ort zu kennen?!?", italian="... hai avuto la sensazione di\nconoscere questo posto?!", spanish="¿Has tenido la extraña\nsensación de que conoces este lugar?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You've had a feeling that you\nsomehow know this place?", french="... tu as le sentiment étrange\nd'avoir déjà vu cet endroit auparavant?!", german="Seither hast du das Gefühl,\ndiesen Ort irgendwie zu kennen?", italian="... hai avuto la sensazione di\nconoscere questo posto?", spanish="¿Has tenido la extraña\nsensación de que conoces este lugar?"})
  else
  SkySceneKit.say({english="You've felt as if you know this\nplace somehow?", french="... tu as le sentiment étrange\nd'avoir déjà vu cet endroit auparavant?!", german="Seither kommt es dir vor, als ob\ndu diesen Ort irgendwie kennst?", italian="... che hai la sensazione di\nconoscere questo posto?", spanish="¿Has tenido la extraña\nsensación de que conoces este lugar?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And you also heard about the\nPokémon that lives at [CS:P]Fogbound Lake[CR]?!", french="Et tu as aussi entendu parler\ndu Pokémon qui vit au [CS:P]Lac des Brumes[CR]?!", german="Und du hast auch von dem\nPokémon gehört, das am [CS:P]Nebelsee[CR] lebt?!?", italian="E sapevi anche del Pokémon che\nvive al [CS:P]Lago Foschia[CR]?!", spanish="¿Y ya habías oído hablar del\nPokémon que vive en el [CS:P]Lago Velado[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And you also learned about the\nPokémon that lives at [CS:P]Fogbound Lake[CR]?", french="Et tu as aussi entendu parler\ndu Pokémon qui vit au [CS:P]Lac des Brumes[CR]?!", german="Und du hast auch von dem\nPokémon erfahren, das am [CS:P]Nebelsee[CR] lebt?!?", italian="E sapevi anche del Pokémon che\nvive al [CS:P]Lago Foschia[CR]?", spanish="¿Y ya habías oído hablar del\nPokémon que vive en el [CS:P]Lago Velado[CR]?"})
  else
  SkySceneKit.say({english="And you also heard about the\nPokémon that lives at [CS:P]Fogbound Lake[CR]?", french="Et tu as aussi entendu parler\ndu Pokémon qui vit au [CS:P]Lac des Brumes[CR]?!", german="Und du hast auch von dem\nPokémon gehört, das am [CS:P]Nebelsee[CR] lebt?!?", italian="E sapevi anche del Pokémon che\nvive al [CS:P]Lago Foschia[CR]?", spanish="¿Y ya habías oído hablar del\nPokémon que vive en el [CS:P]Lago Velado[CR]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Uxie[CR], huh? So the legends say\nthat it wipes the memory of those who visit?", french="[CS:N]Créhelf[CR], hein? Et la légende\nraconte qu'il efface la mémoire de ceux qui\nparviennent jusqu'à lui!", german="[CS:N]Selfe[CR], ja? Der Legende nach\nlöscht es also das Gedächtnis von denen, die\ndort vorbeikommen?", italian="E così questo [CS:N]Uxie[CR] cancellerebbe\nla memoria di quelli che lo incontrano, eh?", spanish="Se llama [CS:N]Uxie[CR], ¿no? Y dicen que\nborra la memoria a quienes visitan el lago."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And that's [CS:N]Uxie[CR], right? So the\nlegend says it erases visitors' memories?", french="[CS:N]Créhelf[CR], hein? Et la légende\nraconte qu'il efface la mémoire de ceux qui\nparviennent jusqu'à lui!", german="Das ist [CS:N]Selfe[CR], oder? Der Legende\nnach löscht es also das Gedächtnis von denen,\ndie dort vorbeikommen?", italian="[CS:N]Uxie[CR], giusto? E la leggenda dice\nche cancella la memoria di quelli che lo\nincontrano?", spanish="Se llama [CS:N]Uxie[CR], ¿no? Y dicen que\nborra la memoria a quienes visitan el lago."})
  else
  SkySceneKit.say({english="And that's [CS:N]Uxie[CR], right? And the\nlegends say it takes visitors' memories?", french="[CS:N]Créhelf[CR], hein? Et la légende\nraconte qu'il efface la mémoire de ceux qui\nparviennent jusqu'à lui!", german="Das ist [CS:N]Selfe[CR], oder? Der Legende\nnach löscht es also das Gedächtnis von denen,\ndie dort vorbeikommen?", italian="[CS:N]Uxie[CR], giusto? E la leggenda dice\nche cancella la memoria di quelli che lo\nincontrano?", spanish="Se llama [CS:N]Uxie[CR], ¿no? Y dicen que\nborra la memoria a quienes visitan el lago."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So, you think you've been here\nbefore, [hero]?", french="Alors tu crois que ce n'est pas\nla première fois que tu viens ici,\n[hero]?", german="Du glaubst also, dass du schon\neinmal hier warst, [hero]?", italian="E così, [hero], pensi di\naver già visto questo posto, eh?", spanish="¿Entonces crees que ya\nhas estado aquí antes, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So, you suspect you've been here\nbefore, [hero]?", french="Alors tu crois que ce n'est pas\nla première fois que tu viens ici,\n[hero]?", german="Du vermutest also, dass du\nschon einmal hier warst, [hero]?", italian="E così, [hero], pensi di\naver già visto questo posto.", spanish="¿Entonces sospechas que ya\nhas estado aquí antes, [hero]?"})
  else
  SkySceneKit.say({english="So, you suspect you've been here\nbefore, [hero]?", french="Alors tu crois que ce n'est pas\nla première fois que tu viens ici,\n[hero]?", german="Du vermutest also, dass du\nschon einmal hier warst, [hero]?", italian="E così, [hero], pensi di\naver già visto questo posto.", spanish="¿Entonces sospechas que ya\nhas estado en este lugar, [hero]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You think you had a run-in with\n[CS:N]Uxie[CR], who then took your memory!", french="Tu crois que tu as rencontré\n[CS:N]Créhelf[CR], et qu'il t'a effacé la mémoire!", german="Du glaubst, dass du [CS:N]Selfe[CR] über\nden Weg gelaufen bist und es dein Gedächtnis\ngelöscht hat!", italian="E questo [CS:N]Uxie[CR] ti avrebbe\ncancellato la memoria!", spanish="¿Crees que te encontraste con\n[CS:N]Uxie[CR] y este te robó la memoria?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You think you encountered [CS:N]Uxie[CR],\nwho then took your memory?", french="Tu crois que tu as rencontré\n[CS:N]Créhelf[CR], et qu'il t'a effacé la mémoire!", german="Du glaubst, dass dir [CS:N]Selfe[CR]\nbegegnet ist und dein Gedächtnis gelöscht hat?", italian="E pensi di aver incontrato [CS:N]Uxie[CR],\nche ti avrebbe cancellato la memoria?", spanish="¿Crees que te encontraste con\n[CS:N]Uxie[CR] y este te robó la memoria?"})
  else
  SkySceneKit.say({english="You think you encountered [CS:N]Uxie[CR],\nwho then took your memory?", french="Tu crois que tu as rencontré\n[CS:N]Créhelf[CR], et qu'il t'a effacé la mémoire!", german="Du glaubst, dass dir [CS:N]Selfe[CR]\nbegegnet ist und dein Gedächtnis gelöscht hat?", italian="E pensi di aver incontrato [CS:N]Uxie[CR],\nche ti avrebbe cancellato la memoria?", spanish="¿Crees que te encontraste con\n[CS:N]Uxie[CR] y este te robó la memoria?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I see![K] So that's what has been\nbothering you, [hero]!", french="Je vois![K] Alors c'est ça qui te\ntracassait, [hero]!", german="Verstehe![K] Daran denkst du also\ndie ganze Zeit, [hero]!", italian="Ho capito![K] Così era questo che\nti preoccupava, [hero]!", spanish="Ahora lo entiendo.[K] ¡Así que era\neso lo que te preocupaba, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I see...[K] So that's what has been\non your mind, [hero]!", french="Je vois![K] Alors c'est ça qui te\ntracassait, [hero]!", german="Verstehe.[K] Das beschäftigt dich\nalso die ganze Zeit, [hero]!", italian="Ho capito.[K] Ecco perché avevi\nl'aria così preoccupata, [hero]!", spanish="¡Ya entiendo![K] ¡Así que era eso\nlo que te preocupaba, [hero]!"})
  else
  SkySceneKit.say({english="I see![K] So that's what has been\nbothering you, [hero]!", french="Je vois![K] Alors c'est ça qui te\ntracassait, [hero]!", german="Verstehe![K] Daran denkst du also\ndie ganze Zeit, [hero]!", italian="Ho capito.[K] Ecco perché avevi\nl'aria così preoccupata, [hero]!", spanish="¡Ya entiendo![K] ¡Así que era eso\nlo que te preocupaba, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(90) end)
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hmmm...[K] [hero]!", french=" Hum...[K] [hero]!", german=" Hmmm...[K] [hero]!", italian=" Mmm...[K] [hero]!", spanish=" Hum...[K] Pues nada, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hmmm...[K] [hero]!", french=" Hum...[K] [hero]!", german=" Hmmm...[K] [hero]!", italian=" Mmm...[K] [hero]!", spanish=" Hum...[K] Pues nada, [hero]."})
  else
  SkySceneKit.say({english=" Hmmm...[K] [hero]!", french=" Hum...[K] [hero]!", german=" Hmmm...[K] [hero]!", italian=" Mmm...[K] [hero]!", spanish=" Hum...[K] Pues nada, [hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitBgm
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That settles it! Now we really\nhave to get to the top!", french="Maintenant c'est décidé! Il faut\nvraiment qu'on atteigne le sommet!", german="Jetzt ist erst recht klar, dass\nwir bis zum Gipfel müssen!", italian="Beh, non ci resta che arrivare in\ncima!", spanish="¡Todo aclarado! ¡Ahora sí que\ntenemos que llegar a la cima como sea!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well, now we have just one\nmore reason to get to the top!", french="Maintenant c'est décidé! Il faut\nvraiment qu'on atteigne le sommet!", german="Tja, das ist ein Grund mehr, bis\nzum Gipfel zu gehen!", italian="Se le cose stanno così, dobbiamo\nveramente arrivare sulla vetta!", spanish="Bueno, ¡ahora tenemos\nuna razón más para llegar a la cima!"})
  else
  SkySceneKit.say({english="That settles it! Now we really\nhave to get to the top!", french="Maintenant c'est décidé! Il faut\nvraiment qu'on atteigne le sommet!", german="Jetzt ist erst recht klar, dass\nwir bis zum Gipfel müssen!", italian="Se le cose stanno così, dobbiamo\nveramente arrivare sulla vetta!", spanish="Tiene sentido. ¡Ahora sí que\ntenemos que llegar a la cima!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to meet [CS:N]Uxie[CR] and get at\nthe truth!", french="On doit parler à [CS:N]Créhelf[CR]\npour connaître la vérité!", german="Wir müssen [CS:N]Selfe[CR] treffen\nund die Wahrheit herausfinden!", italian="Dobbiamo incontrare [CS:N]Uxie[CR] e\nscoprire la verità!", spanish="Tenemos que dar con [CS:N]Uxie[CR]\ny descubrir la verdad."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to meet [CS:N]Uxie[CR] and find\nout what really happened!", french="On doit parler à [CS:N]Créhelf[CR]\npour connaître la vérité!", german="Wir müssen [CS:N]Selfe[CR] treffen\nund herausfinden, was wirklich geschehen ist!", italian="Dobbiamo incontrare [CS:N]Uxie[CR] e\nscoprire cos'è successo veramente!", spanish="Hay que encontrar a [CS:N]Uxie[CR]\ny descubrir lo que ocurrió realmente."})
  else
  SkySceneKit.say({english="We have to meet [CS:N]Uxie[CR].[K] We have\nto find out the truth!", french="On doit parler à [CS:N]Créhelf[CR]\npour connaître la vérité!", german="Wir müssen [CS:N]Selfe[CR] treffen.[K]\nWir müssen die Wahrheit herausfinden!", italian="Dobbiamo incontrare [CS:N]Uxie[CR] e\nscoprire cos'è successo veramente!", spanish="Hay que hablar con [CS:N]Uxie[CR].[K]\nTenemos que descubrir la verdad."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I wonder what you were like\nbefore you lost your memory, [hero]...", french="Je me demande comment\ntu étais avant de perdre la mémoire,\n[hero]...", german="Ich frage mich, wie du warst,\nbevor du dein Gedächtnis verloren hast,\n[hero].", italian="Chissà che tipo eri prima di\nperdere la memoria, [hero]...", spanish="Me pregunto cómo eras antes\nde perder la memoria, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I wonder what you were like\nbefore you lost your memory, [hero]...", french="Je me demande comment\ntu étais avant de perdre la mémoire,\n[hero]...", german="Ich frage mich, wie du warst,\nbevor du dein Gedächtnis verloren hast,\n[hero].", italian="Mi chiedo che tipo fossi prima di\nperdere la memoria, [hero]...", spanish="Me pregunto cómo eras antes\nde perder la memoria, [hero]."})
  else
  SkySceneKit.say({english="I wonder what you were like\nbefore you lost your memory, [hero]...", french="Je me demande comment\ntu étais avant de perdre la mémoire,\n[hero]...", german="Ich frage mich, wie du warst,\nbevor du dein Gedächtnis verloren hast,\n[hero].", italian="Mi chiedo che tipo fossi prima di\nperdere la memoria, [hero]...", spanish="Me pregunto cómo eras antes\nde perder la memoria, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Maybe [CS:N]Uxie[CR] can answer\nsome questions.", french="[CS:N]Créhelf[CR] pourra peut-être nous\napporter quelques réponses.", german="Vielleicht kann [CS:N]Selfe[CR] ein\npaar Fragen beantworten.", italian="Forse [CS:N]Uxie[CR] potrà aiutarci\na scoprirlo.", spanish="Tal vez [CS:N]Uxie[CR] pueda ofrecernos\nalguna respuesta."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Perhaps [CS:N]Uxie[CR] can provide\nthe answers.", french="[CS:N]Créhelf[CR] pourra peut-être nous\napporter quelques réponses.", german="Vielleicht kann [CS:N]Selfe[CR] unsere\nFragen beantworten.", italian="Forse [CS:N]Uxie[CR] potrà aiutarci\na scoprirlo.", spanish="Tal vez [CS:N]Uxie[CR] pueda ofrecernos\nalguna respuesta."})
  else
  SkySceneKit.say({english="If we meet [CS:N]Uxie[CR], maybe you'll\nget your answers at last!", french="[CS:N]Créhelf[CR] pourra peut-être nous\napporter quelques réponses.", german="Vielleicht bekommst du endlich\nAntworten auf deine Fragen, wenn wir [CS:N]Selfe[CR]\ntreffen!", italian="Forse [CS:N]Uxie[CR] potrà aiutarci\na scoprirlo.", spanish="Tal vez [CS:N]Uxie[CR] tenga la respuesta\na nuestras preguntas."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's go! Let's get to the top,\n[hero]!", french="C'est parti! Continuons jusqu'au\nsommet, [hero]!", german="Na los! Gehen wir bis zum\nGipfel, [hero]!", italian="Via! Verso la cima,\n[hero]!", spanish="¡Vamos allá! ¡Hay que llegar\na la cima, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go! Let's make our way to\nthe top, [hero]!", french="C'est parti! Continuons jusqu'au\nsommet, [hero]!", german="Na los! Machen wir uns auf den\nWeg zum Gipfel, [hero]!", italian="Andiamo! Raggiungiamo la vetta,\n[hero]!", spanish="¡Vamos allá! ¡Hay que llegar\na la cima, [hero]!"})
  else
  SkySceneKit.say({english=" OK! Let's go up, [hero]!", french="C'est parti! Continuons jusqu'au\nsommet, [hero]!", german="Okay! Lass uns hochgehen,\n[hero]!", italian="Andiamo! Raggiungiamo la vetta,\n[hero]!", spanish="¡Vamos allá!\n¡Subamos, [hero]!"})
  end
  -- message_Close
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-120), false, 2) end
  GAME:WaitFrames(5)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-120), false, 2) end
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  -- main_EnterDungeon(15, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
end
