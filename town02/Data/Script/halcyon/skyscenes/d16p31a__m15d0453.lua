-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D16P31A/m15d0453.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D16P31A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(8) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- supervision_StationCommon(28) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(23) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(21) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(5)
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(2, 1) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That was...)", french="(Voilà qui était...)", german="(Das war...)", italian="(Questa volta...)", spanish="(Esta no ha sido...)"})
  else
  SkySceneKit.say({english="(That was...)", french="(Voilà qui était...)", german="(Das war...)", italian="(Questa volta...)", spanish="(Esta no ha sido...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Unlike my earlier experiences!)", french="(... différent des fois précédentes!)", german="(Das war ganz anders als in meinen vorherigen\nVisionen!)", italian="(... non è stata come le altre...)", spanish="(¡No ha sido como mis experiencias\nanteriores!)"})
  else
  SkySceneKit.say({english="(Unlike my earlier experiences!)", french="(... différent des fois précédentes!)", german="(Das war ganz anders als in meinen vorherigen\nVisionen!)", italian="(... non è stata come le altre...)", spanish="(¡No ha sido como mis experiencias\nanteriores!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(All I heard was a voice.)", french="(J'ai juste entendu une voix.)", german="(Ich habe nur eine Stimme gehört.)", italian="(Sono soltanto riuscito a sentire una voce.)", spanish="(Solo he oído una voz.)"})
  else
  SkySceneKit.say({english="(All I heard was a voice.)", french="(J'ai juste entendu une voix.)", german="(Ich habe nur eine Stimme gehört.)", italian="(Sono soltanto riuscita a sentire una voce.)", spanish="(Solo he oído una voz.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(No.[K] That's wrong.)", french="(Non.[K] C'est faux.)", german="(Nein.[K] Das stimmt nicht.)", italian="(No.[K] Non è così.)", spanish="(No.[K] Me equivoco.)"})
  else
  SkySceneKit.say({english="(No.[K] That's wrong.)", french="(Non.[K] C'est faux.)", german="(Nein.[K] Das stimmt nicht.)", italian="(No.[K] Non è così.)", spanish="(No.[K] Me equivoco.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(This...[K]this happened once before.)", french="(Ça...[K] ça s'est déjà produit une fois.)", german="(Es...[K] war schon einmal so.)", italian="(È...[K] già successo una volta.)", spanish="(Esto...[K] ya me había pasado antes.)"})
  else
  SkySceneKit.say({english="(This...[K]this happened once before.)", french="(Ça...[K] ça s'est déjà produit une fois.)", german="(Es...[K] war schon einmal so.)", italian="(È...[K] già successo una volta.)", spanish="(Esto...[K] ya me había pasado antes.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It was...[K] It was at Groudon's statue!)", french="(Devant...[K] devant la statue de Groudon!)", german="(Das war...[K] bei der Statue von Groudon!)", italian="(È stato...[K] vicino alla statua di Groudon!)", spanish="(Fue...[K] ¡junto a la estatua de Groudon!)"})
  else
  SkySceneKit.say({english="(It was...[K] It was at Groudon's statue!)", french="(Devant...[K] devant la statue de Groudon!)", german="(Das war...[K] bei der Statue von Groudon!)", italian="(È stato...[K] vicino alla statua di Groudon!)", spanish="(Fue...[K] ¡junto a la estatua de Groudon!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I heard only a voice that time too.)", french="(Là-bas aussi, je n'ai entendu qu'une voix.)", german="(Damals hörte ich auch nur eine Stimme.)", italian="(Anche allora ho solo sentito una voce.)", spanish="(Aquella vez también escuché solo una voz.)"})
  else
  SkySceneKit.say({english="(I heard only a voice that time too.)", french="(Là-bas aussi, je n'ai entendu qu'une voix.)", german="(Damals hörte ich auch nur eine Stimme.)", italian="(Anche allora ho solo sentito una voce.)", spanish="(Aquella vez también escuché solo una voz.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But why does that happen?)", french="(Comment ça se fait?)", german="(Aber warum war das so?)", italian="(Perché succede questo?)", spanish="(¿Pero por qué ha ocurrido?)"})
  else
  SkySceneKit.say({english="(But why does that happen?)", french="(Comment ça se fait?)", german="(Aber warum war das so?)", italian="(Perché succede questo?)", spanish="(¿Pero por qué ha ocurrido?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Why did I hear only a voice then...and now?)", french="(Pourquoi je n'ai entendu qu'une voix là-bas...\net ici?)", german="(Warum habe ich damals nur eine Stimme\ngehört... Und jetzt erneut?)", italian="(Perché in entrambe le occasioni, si è solo\nudita una voce?)", spanish="(¿Por qué solo he escuchado una voz en estas\ndos ocasiones?)"})
  else
  SkySceneKit.say({english="(Why did I hear only a voice then...and now?)", french="(Pourquoi je n'ai entendu qu'une voix là-bas...\net ici?)", german="(Warum habe ich damals nur eine Stimme\ngehört... Und jetzt erneut?)", italian="(Perché in entrambe le occasioni, si è solo\nudita una voce?)", spanish="(¿Por qué solo he escuchado una voz en estas\ndos ocasiones?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? What's up, [hero]?", french="Qu'est-ce qui t'arrive,\n[hero]?", german=" Huch? Was ist, [hero]?", italian="Uh? Che ti succede,\n[hero]?", spanish=" ¿Eh? ¿Qué pasa, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hey, what's the matter,\n[hero]?", french="Qu'est-ce qui t'arrive,\n[hero]?", german=" Hey, was ist los, [hero]?", italian=" Ehi, tutto bene, [hero]?", spanish=" Eh, ¿qué pasa, [hero]?"})
  else
  SkySceneKit.say({english="Hey, is there something wrong,\n[hero]?", french="Qu'est-ce qui t'arrive,\n[hero]?", german="Hey, stimmt etwas nicht,\n[hero]?", italian="Ehi, qualcosa non va,\n[hero]?", spanish=" Oye, ¿qué pasa, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh! Did you have another vision?", french=" Tu as eu une autre vision?", german="Oh! Hattest du wieder eine\nVision?", italian=" Oh! Hai avuto un'altra visione?", spanish=" ¡Oh! ¿Has tenido otra visión?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh! Did you have another vision?", french=" Tu as eu une autre vision?", german="Oh! Hattest du wieder eine\nVision?", italian=" Oh! Hai avuto un'altra visione?", spanish=" ¡Oh! ¿Has tenido otra visión?"})
  else
  SkySceneKit.say({english=" Oh! Did you have another vision?", french=" Tu as eu une autre vision?", german="Oh! Hattest du wieder eine\nVision?", italian=" Oh! Hai avuto un'altra visione?", spanish=" ¡Oh! ¿Has tenido otra visión?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Did another Dimensional Scream\ncome to you?", french="C'est encore le Cri\nDimensionnel?", german="Hat sich wieder ein\nDimensionaler Schrei ereignet?", italian="Hai avvertito lo Squarcio\nDimensionale?", spanish="¿Has sentido de nuevo\nla Percepción de Cronos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Did another Dimensional Scream\ncome to you?", french="C'est encore le Cri\nDimensionnel?", german="Hat sich wieder ein\nDimensionaler Schrei ereignet?", italian="Hai avvertito lo Squarcio\nDimensionale?", spanish="¿Has sentido de nuevo\nla Percepción de Cronos?"})
  else
  SkySceneKit.say({english="Did another Dimensional Scream\ncome to you?", french="C'est encore le Cri\nDimensionnel?", german="Hat sich wieder ein\nDimensionaler Schrei ereignet?", italian="Hai avvertito lo Squarcio\nDimensionale?", spanish="¿Has sentido de nuevo\nla Percepción de Cronos?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I knew it!", french=" Je le savais!", german=" Ich wusste es!", italian=" Me lo sentivo!", spanish=" ¡Lo sabía!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I knew it!", french=" Je le savais!", german=" Ich wusste es!", italian=" Me lo sentivo!", spanish=" ¡Lo sabía!"})
  else
  SkySceneKit.say({english=" I knew it!", french=" Je le savais!", german=" Ich wusste es!", italian=" Me lo sentivo!", spanish=" ¡Lo sabía!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" S-so what did you see?!", french="Alors, qu'est-ce que tu as vu\ncette fois?!", german=" W-was hast du gesehen?!?", italian=" Dai racconta, cos'hai visto?", spanish=" ¡¿Y qué viste?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" S-so what did you see?!", french="Alors, qu'est-ce que tu as vu\ncette fois?!", german=" W-was hast du gesehen?!?", italian="Cos'hai visto? Hai scoperto\nqualcosa?", spanish=" ¡¿Y qué viste?!"})
  else
  SkySceneKit.say({english=" S-so what did you see?!", french="Alors, qu'est-ce que tu as vu\ncette fois?!", german=" W-was hast du gesehen?!?", italian="Cos'hai visto? Hai scoperto\nqualcosa?", spanish=" ¡¿Y qué viste?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(180) end)
  -- message_FacePositionOffset(2, 1) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(According to that voice...)", french="(D'après la voix...)", german="(Die Stimme hat gesagt...)", italian="(Quella voce diceva...)", spanish="(Según esa voz...)"})
  else
  SkySceneKit.say({english="(According to that voice...)", french="(D'après la voix...)", german="(Die Stimme hat gesagt...)", italian="(Quella voce diceva...)", spanish="(Según esa voz...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:N]Azelf[CR] is the Being of Willpower.)", french="([CS:N]Créfadet[CR] est l'être de la volonté.)", german="([CS:N]Tobutz[CR] sei das Starke Wesen.)", italian="(Diceva che [CS:N]Azelf[CR] è l'Essere della volontà.)", spanish="([CS:N]Azelf[CR] es el ser de la voluntad.)"})
  else
  SkySceneKit.say({english="([CS:N]Azelf[CR] is the Being of Willpower.)", french="([CS:N]Créfadet[CR] est l'être de la volonté.)", german="([CS:N]Tobutz[CR] sei das Starke Wesen.)", italian="(Diceva che [CS:N]Azelf[CR] è l'Essere della volontà.)", spanish="([CS:N]Azelf[CR] es el ser de la voluntad.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The voice said the crystals should all be made\none color.)", french="(La voix a dit que les cristaux devaient tous\nêtre en harmonie.)", german="(Die Stimme sagte, dass die Farben der\nKristalle eins werden müssten.)", italian="(E che la nostra volontà ci ha permesso di\ndiventare una cosa sola.)", spanish="(La voz dijo que todos los cristales tendrían\nque tener el mismo color.)"})
  else
  SkySceneKit.say({english="(The voice said the crystals should all be made\none color.)", french="(La voix a dit que les cristaux devaient tous\nêtre en harmonie.)", german="(Die Stimme sagte, dass die Farben der\nKristalle eins werden müssten.)", italian="(E che la nostra volontà ci ha permesso di\ndiventare una cosa sola.)", spanish="(La voz dijo que todos los cristales tendrían\nque tener el mismo color.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Make the crystals one color...)", french="(Tous les cristaux en harmonie...)", german="(Die Farben müssen eins werden...)", italian="(Una cosa sola... I diversi colori dei\ncristalli...)", spanish="(¡Cambiar los cristales a un mismo color!)"})
  else
  SkySceneKit.say({english="(Make the crystals one color...)", french="(Tous les cristaux en harmonie...)", german="(Die Farben müssen eins werden...)", italian="(Una cosa sola... I diversi colori dei\ncristalli...)", spanish="(¡Cambiar los cristales a un mismo color!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 1) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That's it![K] I need to match the color!)", french="(C'est ça![K] Je dois toucher les cristaux pour\nqu'ils prennent une seule et même couleur!)", german="(Das ist es![K] Die Farben sollen gleich sein!)", italian="(Ho capito![K] Devo fare in modo che\ni cristalli...)", spanish="(¡Eso es![K] ¡Los colores tienen que ser iguales!)"})
  else
  SkySceneKit.say({english="(That's it![K] I need to match the color!)", french="(C'est ça![K] Je dois toucher les cristaux pour\nqu'ils prennent une seule et même couleur!)", german="(Das ist es![K] Die Farben sollen gleich sein!)", italian="(Ho capito![K] Devo fare in modo che\ni cristalli...)", spanish="(¡Eso es![K] ¡Los colores tienen que ser iguales!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(These three crystals need to be all the\nsame color!)", french="(Les trois cristaux doivent être de la même\ncouleur!)", german="(Die drei Kristalle müssen die gleiche Farbe\nhaben!)", italian="(... diventino tutti dello stesso colore!)", spanish="(¡Los tres tienen que ser del mismo color!)"})
  else
  SkySceneKit.say({english="(These three crystals need to be all the\nsame color!)", french="(Les trois cristaux doivent être de la même\ncouleur!)", german="(Die drei Kristalle müssen die gleiche Farbe\nhaben!)", italian="(... diventino tutti dello stesso colore!)", spanish="(¡Los tres tienen que ser del mismo color!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(10)
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'm guessing you have an\nidea now.", french="J'ai comme l'impression que\ntu as une idée de la marche à suivre.", german=" Du hast wohl eine Idee?", italian="Mmm... Secondo me hai capito\nqualcosa...", spanish=" Me da que tienes una idea."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I guess you have an idea about\nwhat to do.", french="J'ai comme l'impression que\ntu as une idée de la marche à suivre.", german="Du hast wohl eine Idee, was wir\ntun müssen?", italian="Mmm... Secondo me hai capito\nqualcosa...", spanish=" Me da que tienes una idea."})
  else
  SkySceneKit.say({english="I guess you got an idea about\nwhat to do.", french="J'ai comme l'impression que\ntu as une idée de la marche à suivre.", german="Du hast wohl eine Idee, was wir\ntun müssen?", italian="Mmm... Secondo me hai capito\nqualcosa...", spanish=" Me da que tienes una idea."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(60)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 1) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Now, what's the color supposed to be?)", french="(Alors, quelle couleur choisir?)", german="(Welche Farbe sollen sie wohl haben?)", italian="(Va bene, lo stesso colore... Ma quale?)", spanish="(Ahora, la pregunta es: ¿Qué color ponemos?)"})
  else
  SkySceneKit.say({english="(Now, what's the color supposed to be?)", french="(Alors, quelle couleur choisir?)", german="(Welche Farbe sollen sie wohl haben?)", italian="(Va bene, lo stesso colore... Ma quale?)", spanish="(Ahora, la pregunta es: ¿Qué color ponemos?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The color of willpower...)", french="(La couleur de la volonté...)", german="(Die Farbe der Stärke...)", italian="(Il colore della volontà...)", spanish="(El color de la fuerza de voluntad.)"})
  else
  SkySceneKit.say({english="(The color of willpower...)", french="(La couleur de la volonté...)", german="(Die Farbe der Stärke...)", italian="(Il colore della volontà...)", spanish="(El color de la fuerza de voluntad.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That must mean the color of [CS:N]Azelf[CR]'s spirit...)", french="(Autrement dit, la couleur de l'esprit\nde [CS:N]Créfadet[CR]...)", german="(Das muss die Farbe des Elements von [CS:N]Tobutz[CR]\nsein.)", italian="(... dev'essere il colore dello spirito di\n[CS:N]Azelf[CR]...)", spanish="(Ese tiene que ser el color del espíritu de\n[CS:N]Azelf[CR].)"})
  else
  SkySceneKit.say({english="(That must mean the color of [CS:N]Azelf[CR]'s spirit...)", french="(Autrement dit, la couleur de l'esprit\nde [CS:N]Créfadet[CR]...)", german="(Das muss die Farbe des Elements von [CS:N]Tobutz[CR]\nsein.)", italian="(... dev'essere il colore dello spirito di\n[CS:N]Azelf[CR]...)", spanish="(Ese tiene que ser el color del espíritu de\n[CS:N]Azelf[CR].)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:N]Azelf[CR] lives at [CS:P]Shining Lake[CR].)", french="([CS:N]Créfadet[CR] vit dans le [CS:P]Lac Cristal[CR].)", german="([CS:N]Tobutz[CR] lebt am [CS:P]Kristallsee[CR].)", italian="([CS:N]Azelf[CR] vive presso il [CS:P]Lago di Cristallo[CR].)", spanish="([CS:N]Azelf[CR] vive en el [CS:P]Lago Cristal[CR].)"})
  else
  SkySceneKit.say({english="([CS:N]Azelf[CR] lives at [CS:P]Shining Lake[CR].)", french="([CS:N]Créfadet[CR] vit dans le [CS:P]Lac Cristal[CR].)", german="([CS:N]Tobutz[CR] lebt am [CS:P]Kristallsee[CR].)", italian="([CS:N]Azelf[CR] vive presso il [CS:P]Lago di Cristallo[CR].)", spanish="([CS:N]Azelf[CR] vive en el [CS:P]Lago Cristal[CR].)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:P]Crystal Cave[CR]...[K]and [CS:P]Shining Lake[CR]...)", french="(La [CS:P]Caverne Cristal[CR]...[K] et le [CS:P]Lac Cristal[CR]...)", german="([CS:P]Kristallhöhle[CR]...[K] und [CS:P]Kristallsee[CR]...)", italian="(La [CS:P]Grotta di Cristallo[CR]...[K] Il [CS:P]Lago di[CR]\n[CS:P]Cristallo[CR]...)", spanish="(La [CS:P]Cueva Cristal[CR]...[K] y el [CS:P]Lago Cristal[CR]...)"})
  else
  SkySceneKit.say({english="([CS:P]Crystal Cave[CR]...[K]and [CS:P]Shining Lake[CR]...)", french="(La [CS:P]Caverne Cristal[CR]...[K] et le [CS:P]Lac Cristal[CR]...)", german="([CS:P]Kristallhöhle[CR]...[K] und [CS:P]Kristallsee[CR]...)", italian="(La [CS:P]Grotta di Cristallo[CR]...[K] Il [CS:P]Lago di[CR]\n[CS:P]Cristallo[CR]...)", spanish="(La [CS:P]Cueva Cristal[CR]...[K] y el [CS:P]Lago Cristal[CR]...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Is [CS:N]Azelf[CR]'s spirit...[K]as clear as crystal...?)", french="(L'esprit de [CS:N]Créfadet[CR] serait-il...[K] limpide\ncomme le cristal...?)", german="(Ist das Element von [CS:N]Tobutz[CR][K] vielleicht\nkristallklar?)", italian="(Che lo spirito di [CS:N]Azelf[CR]...[K] sia chiaro come un\ncristallo...?)", spanish="(El espíritu de [CS:N]Azelf[CR] será...[K] ¿Será tan claro\ncomo el cristal?)"})
  else
  SkySceneKit.say({english="(Is [CS:N]Azelf[CR]'s spirit...[K]as clear as crystal...?)", french="(L'esprit de [CS:N]Créfadet[CR] serait-il...[K] limpide\ncomme le cristal...?)", german="(Ist das Element von [CS:N]Tobutz[CR][K] vielleicht\nkristallklar?)", italian="(Che lo spirito di [CS:N]Azelf[CR]...[K] sia chiaro come un\ncristallo...?)", spanish="(El espíritu de [CS:N]Azelf[CR] será...[K] ¿Será tan claro\ncomo el cristal?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Or, no...[K]could it be the color of cold water?)", french="(Ou plutôt...[K] de la couleur d'une eau\ncristalline?)", german="(Oder...[K] Hat es vielleicht die Farbe von\nWasser?)", italian="(O forse...[K] Che sia del colore del lago?)", spanish="(O...[K] ¿tendrá el color del agua fría?)"})
  else
  SkySceneKit.say({english="(Or, no...[K]could it be the color of cold water?)", french="(Ou plutôt...[K] de la couleur d'une eau\ncristalline?)", german="(Oder...[K] Hat es vielleicht die Farbe von\nWasser?)", italian="(O forse...[K] Che sia del colore del lago?)", spanish="(O...[K] ¿tendrá el color del agua fría?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I guess you really are onto\nsomething.", french=" On dirait que tu es sur une piste.", german="Du scheinst einen echten\nGeistesblitz zu haben!", italian="Sì, sì. Hai già una pista,\nscommetto.", spanish="Veo que has dado con algo\ninteresante."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I guess you really have an idea\nabout what to do.", french=" On dirait que tu es sur une piste.", german="Du bist wohl wirklich auf einen\nguten Gedanken gekommen, was?", italian="Sì, sì. Hai già una pista,\nscommetto.", spanish=" Veo que tienes las cosas claras."})
  else
  SkySceneKit.say({english="I guess you're really\nconvinced now.", french=" On dirait que tu es sur une piste.", german="Du scheinst dir deiner Sache\nsicher zu sein!", italian="Sì, sì. Hai già una pista,\nscommetto.", spanish="Veo que tienes claro lo que\ndebemos hacer."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="All right. This is your call,\n[hero].", french="D'accord. Je te laisse faire,\n[hero].", german="Okay. Jetzt bist du dran,\n[hero].", italian="Va bene. Questa volta, lascio\ntutto nelle tue mani, [hero].", spanish="Muy bien. En tus manos queda,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="OK. I'll leave it up to you,\n[hero].", french="D'accord. Je te laisse faire,\n[hero].", german="Okay. Ich überlasse es dir,\n[hero].", italian="Ok. Lascio fare a te,\n[hero].", spanish="Muy bien. Lo dejo en tus manos,\n[hero]."})
  else
  SkySceneKit.say({english="OK. You should do whatever you\nneed to, [hero].", french="D'accord. Je te laisse faire,\n[hero].", german="Okay. Tu, was du tun musst,\n[hero].", italian="Ok. Lascio fare a te,\n[hero].", spanish="Muy bien. Haz lo que debas,\n[hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Go on and solve the secret of\nthe three crystals!", french="A toi de jouer, résous l'énigme\ndes trois cristaux!", german=" Löse das Rätsel dieser Kristalle!", italian="Sono sicuro che saprai risolvere\nil mistero dei tre cristalli!", spanish="¡Intenta resolver el secreto de\nlos tres cristales!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="See if you can solve the secret\nof the three crystals!", french="A toi de jouer, résous l'énigme\ndes trois cristaux!", german="Mal sehen, ob du das Rätsel der\nKristalle lösen kannst!", italian="Sono sicuro che saprai risolvere\nil mistero dei tre cristalli!", spanish="¡A ver si puedes desvelar el\nsecreto de los tres cristales!"})
  else
  SkySceneKit.say({english="Try solving the secret of the\nthree crystals!", french="A toi de jouer, résous l'énigme\ndes trois cristaux!", german="Versuche, das Rätsel der\nKristalle zu lösen!", italian="Sono sicura che saprai risolvere\nil mistero dei tre cristalli!", spanish="¡Intenta resolver el secreto de\nlos tres cristales!"})
  end
  -- message_Close
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.CRYSTAL_COLOR_01 = 1 -- $CRYSTAL_COLOR_01 = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.CRYSTAL_COLOR_02 = 3 -- $CRYSTAL_COLOR_02 = 3 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.CRYSTAL_COLOR_03 = 0 -- $CRYSTAL_COLOR_03 = 0 (ROM)
end
