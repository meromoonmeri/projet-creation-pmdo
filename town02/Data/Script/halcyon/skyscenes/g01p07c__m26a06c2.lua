-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m26a06c2.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_MEMORIES_RETURNED non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It made me feel glad I became\nan exploration team member.", french="J'ai compris que j'ai pris\nla bonne décision en devenant membre\nd'une équipe d'exploration.", german="Da war ich froh, dass ich\nMitglied eines Erkundungsteams geworden bin.", italian="Mi ha fatto sentire felice di\nessere diventato membro di una squadra\nd'esplorazione.", spanish="La verdad es que me alegro de\nhaberme convertido en explorador."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It made me realize I made the\nright decision in joining an exploration team.", french="J'ai compris que j'ai pris\nla bonne décision en devenant membre\nd'une équipe d'exploration.", german="Da wurde mir klar, dass es\nrichtig war, Mitglied in einem Erkundungsteam\nzu werden.", italian="Mi ha fatto sentire felice di\nessere diventato membro di una squadra\nd'esplorazione.", spanish="Esto me ha hecho darme cuenta\nde lo mucho que me gusta ser explorador."})
  else
  SkySceneKit.say({english="I realized I did the right thing in\nbecoming an exploration team member.", french="J'ai compris que j'ai pris\nla bonne décision en devenant membre\nd'une équipe d'exploration.", german="Mir wurde klar, dass es richtig\nwar, Mitglied in einem Erkundungsteam zu\nwerden.", italian="Mi ha fatta sentire felice di\nessere diventata membro di una squadra\nd'esplorazione.", spanish="Me he dado cuenta de que ha\nsido muy buena idea hacerme exploradora."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetOutputAttribute(4) [neutre/état moteur]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(8), p.Y+(8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-8), p.Y+(-8), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="One day I'm sure I'll solve the\nsecret of my Relic Fragment.", french="Et je suis sûr qu'un jour, je\ndécouvrirai le secret de mon Fragment de\nRelique.", german="Ich bin mir sicher, dass ich\neines Tages das Geheimnis meines\nReliktfragments lösen werde.", italian="Sono sicuro che un giorno\nrisolverò il mistero del Frammento Antico.", spanish="Seguro que un día de estos\nresolveré el misterio de mi Reliquia de\nPiedra."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="One day I'm sure I'll solve the\nsecret of my Relic Fragment.", french="Et je suis sûr qu'un jour, je\ndécouvrirai le secret de mon Fragment de\nRelique.", german="Ich bin mir sicher, dass ich\neines Tages das Geheimnis meines\nReliktfragments lösen werde.", italian="Sono sicuro che un giorno\nrisolverò il mistero del Frammento Antico.", spanish="Seguro que un día de estos\nresolveré el misterio de mi Reliquia de\nPiedra."})
  else
  SkySceneKit.say({english="One day I'm sure I'll solve the\nsecret of my Relic Fragment.", french="Et je suis sûre qu'un jour, je\ndécouvrirai le secret de mon Fragment de\nRelique.", german="Ich bin mir sicher, dass ich\neines Tages das Geheimnis meines\nReliktfragments lösen werde.", italian="Sono sicura che un giorno\nrisolverò il mistero del Frammento Antico.", spanish="Seguro que un día de estos\nresolveré el misterio de mi Reliquia de\nPiedra."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That's my dream.", french=" C'est mon plus grand rêve.", german=" Davon träume ich.", italian=" È il mio sogno.", spanish=" Ese es mi sueño."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's the dream I have.", french=" C'est mon plus grand rêve.", german=" Das ist mein großer Traum.", italian=" È il mio sogno.", spanish=" Ese es mi mayor deseo."})
  else
  SkySceneKit.say({english=" That's my dream.", french=" C'est mon plus grand rêve.", german=" Das ist mein Traum.", italian=" È il mio sogno.", spanish=" Ese es mi sueño."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If it ever came true, I'd surely\nfaint from happiness!", french="S'il devenait réalité, je pense\nque j'en tomberais à la renverse tellement\nje serais heureux!", german="Wenn dieser Traum jemals\nwahr wird, falle ich vor Glück bestimmt in\nOhnmacht!", italian="Se riuscissi a realizzarlo, sono\nsicuro che sverrei dalla gioia!", spanish="Si consiguiera resolver el\nmisterio, ¡creo que me desmayaría de\nla felicidad!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If it ever came true, I'd surely\nfaint from sheer happiness!", french="S'il devenait réalité, je pense\nque j'en tomberais à la renverse tellement\nje serais heureux!", german="Wenn er jemals wahr wird,\nfalle ich vor lauter Freude bestimmt in\nOhnmacht!", italian="Se riuscissi a realizzarlo, sono\nsicuro che sverrei dalla gioia!", spanish="Si consiguiera resolver el\nmisterio, ¡creo que me desmayaría de\nla felicidad!"})
  else
  SkySceneKit.say({english="If it ever came true, I'd surely\nfaint from sheer happiness!", french="S'il devenait réalité, je pense\nque j'en tomberais à la renverse tellement\nje serais heureuse!", german="Wenn er jemals wahr wird,\nfalle ich vor lauter Freude bestimmt in\nOhnmacht!", italian="Se riuscissi a realizzarlo, sono\nsicura che sverrei dalla gioia!", spanish="Si consiguiera resolver el\nmisterio, ¡creo que me desmayaría de\nla felicidad!"})
  end
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ha ha ha ha!", french=" Ha ha ha ha!", german=" Hahahaha!", italian=" Ah ah ah ah!", spanish=" ¡Ja, ja, ja!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ha ha ha ha!", french=" Ha ha ha ha!", german=" Hahahaha!", italian=" Ah ah ah ah!", spanish=" ¡Ja, ja, ja!"})
  else
  SkySceneKit.say({english=" Ha ha ha ha!", french=" Ha ha ha ha!", german=" Hahahaha!", italian=" Ah ah ah ah!", spanish=" ¡Ja, ja, ja!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  GAME:WaitFrames(90)
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
end
