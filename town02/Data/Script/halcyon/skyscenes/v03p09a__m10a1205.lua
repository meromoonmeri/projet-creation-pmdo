-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P09A/m10a1205.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_TIME_GEAR non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_V03P09A) [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(360), g.ViewCenter.Y+(360), 120, false) end) -- back_SetBackScrollSpeed(3.0,3.0) px/frame -> caméra continue (pilote scroll)
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- back_SetEffect(7, 0) [transition couches décor NDS immédiate]
  -- back_SetBackEffect(2) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(............)", french="(............)", german="(............)", italian="(............)", spanish="(...)"})
  else
  SkySceneKit.say({english="(............)", french="(............)", german="(............)", italian="(............)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What could that be?)", french="(Qu'est-ce que ça peut bien être?)", german="(Was könnte das sein?)", italian="(E quello cosa sarà?)", spanish="(¿Qué será?)"})
  else
  SkySceneKit.say({english="(What could that be?)", french="(Qu'est-ce que ça peut bien être?)", german="(Was könnte das sein?)", italian="(E quello cosa sarà?)", spanish="(¿Qué podrá ser?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I can't figure it out...[K]but it's making my\nheart race!)", french="(Je l'ignore...[K] mais mon cœur bat la chamade!)", german="(Ich komme nicht darauf.[K] Aber es verursacht\nHerzrasen bei mir!)", italian="(Davvero non lo so...[K] ma guardarlo mi toglie\nil respiro!)", spanish="(No consigo verlo bien...[K] ¡pero está\nhaciendo que me palpite el corazón!)"})
  else
  SkySceneKit.say({english="(I can't figure it out...[K]but it's making my\nheart race!)", french="(Je l'ignore...[K] mais mon cœur bat la chamade!)", german="(Ich komme nicht darauf.[K] Aber es verursacht\nHerzrasen bei mir!)", italian="(Davvero non lo so...[K] ma guardarlo mi toglie\nil respiro!)", spanish="(No consigo verlo bien...[K] ¡pero está\nhaciendo que me palpite el corazón!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But why? Why should it stir me up so much?)", french="(Mais pourquoi? Pourquoi ça me fait un tel\neffet?)", german="(Aber warum? Warum bewegt es mich so?)", italian="(Perché? Chissà perché mi fa questo\neffetto...)", spanish="(Pero, ¿por qué me estará afectando tanto?)"})
  else
  SkySceneKit.say({english="(But why? Why should it stir me up so much?)", french="(Mais pourquoi? Pourquoi ça me fait un tel\neffet?)", german="(Aber warum? Warum bewegt es mich so?)", italian="(Perché? Chissà perché mi fa questo\neffetto...)", spanish="(Pero, ¿por qué me estará afectando tanto?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Why is my pulse speeding all of a sudden?)", french="(Pourquoi mon pouls s'accélère tout à coup?)", german="(Warum ist mein Puls plötzlich so schnell?)", italian="(Perché mi sento così?)", spanish="(¿Por qué se me ha acelerado el pulso de\nforma tan repentina?)"})
  else
  SkySceneKit.say({english="(Why is my pulse speeding all of a sudden?)", french="(Pourquoi mon pouls s'accélère tout à coup?)", german="(Warum ist mein Puls plötzlich so schnell?)", italian="(Perché mi sento così?)", spanish="(¿Por qué se me ha acelerado el pulso de\nforma tan repentina?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That's fantastic![K] But...", french=" C'est fantastique![K] Mais...", german=" Das ist fantastisch![K] Aber...", italian="Wow! È davvero fantastico![K]\nPerò...", spanish=" ¡Es fantástico![K] Pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's fantastic![K] But...", french=" C'est fantastique![K] Mais...", german=" Das ist fantastisch![K] Aber...", italian=" È bellissimo![K] Ma...", spanish=" ¡Es fantástico![K] Pero..."})
  else
  SkySceneKit.say({english=" That's fantastic![K] But...", french=" C'est fantastique![K] Mais...", german=" Das ist fantastisch![K] Aber...", italian=" È bellissimo![K] Ma...", spanish=" ¡Es fantástico![K] Pero..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What is that?", french=" Qu'est-ce que c'est?", german=" Was ist das?", italian=" Che cos'è?", spanish=" ¿Qué es eso?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What is that?", french=" Qu'est-ce que c'est?", german=" Was ist das?", italian=" Che cos'è?", spanish=" ¿Qué es eso?"})
  else
  SkySceneKit.say({english=" What is that?", french=" Qu'est-ce que c'est?", german=" Was ist das?", italian=" Che cos'è?", spanish=" ¿Qué es eso?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It has such a mysterious quality!", french="Une aura mystérieuse\ns'en dégage!", german=" Es hat eine so mysteriöse Aura!", italian="È davvero qualcosa di\nmisterioso!", spanish=" ¡Es algo misterioso!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It has such a mystical quality!", french="Une aura mystérieuse\ns'en dégage!", german=" Es hat eine so mysteriöse Aura!", italian=" Sembra...[K] così misterioso!", spanish=" ¡Parece algo misterioso!"})
  else
  SkySceneKit.say({english=" Oooh...[K]it seems so mystical!", french="Une aura mystérieuse\ns'en dégage!", german=" Uuuh![K] Es wirkt so mysteriös!", italian=" Sembra...[K] così misterioso!", spanish=" ¡Oooh![K] ¡Parece tan misterioso!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Uxie", true, "uxie", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YUKUSHII (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" That is...[K]a Time Gear.", french=" Ceci est...[K] un Rouage du Temps.", german="Das ist...[K] Das ist ein Zahnrad\nder Zeit.", italian="Quello...[K] è un Ingranaggio del\nTempo.", spanish=" Es...[K] un Engranaje del Tiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?![K] Really?![K] A Time Gear?!", french="Hein?! Vraiment?![K] Un Rouage\ndu Temps?!", german="Wie bitte?!?[K] Wirklich?!?[K]\nEin Zahnrad der Zeit?!?", italian="Eh?[K] Davvero?[K] Un Ingranaggio\ndel Tempo?", spanish="¡¿Qué?![K] ¡¿En serio?![K]\n¡¿Un Engranaje del Tiempo?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?![K] That's a Time Gear?!", french="Hein?! Vraiment?![K] Un Rouage\ndu Temps?!", german="Was?!?[K] Das ist ein Zahnrad der\nZeit?!?", italian="Cosa?[K] Un Ingranaggio\ndel Tempo?", spanish="¡¿Qué?![K] ¡¿Eso es\nun Engranaje del Tiempo?!"})
  else
  SkySceneKit.say({english="What?![K] Really and truly?![K]\nThat's a Time Gear?!", french="Hein?! Vraiment?![K] Un Rouage\ndu Temps?!", german="Was?!?[K] Wirklich und\nwahrhaftig?!?[K] Das ist ein Zahnrad der Zeit?!?", italian="Cosa?[K] Un Ingranaggio\ndel Tempo?", spanish="¡¿Qué?![K] ¡¿De verdad?![K]\n¡¿Un Engranaje del Tiempo?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Uxie", true, "uxie", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YUKUSHII (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Yes.", french=" Oui.", german=" Ja.", italian=" È così.", spanish=" En efecto."})
  pcall(function() UI:SetSpeaker("Uxie", true, "uxie", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YUKUSHII (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" I guard the Time Gear.", french="Pour ma part, ma mission ici\nconsiste à protéger ce Rouage du Temps.", german="Ich bewache das Zahnrad der\nZeit.", italian="Sono il custode dell'Ingranaggio\ndel Tempo.", spanish=" Yo custodio el Engranaje del Tiempo."})
  pcall(function() UI:SetSpeaker("Uxie", true, "uxie", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YUKUSHII (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" It's the sole reason I'm here.", french="C'est la seule et unique raison\nde ma présence ici.", german="Das ist der einzige Grund,\naus dem ich hier bin.", italian="Questa è la ragione della mia\npresenza qui.", spanish="Es la única razón por la que\nestoy aquí."})
  -- message_Close
  GAME:FadeOut(false,  60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
