-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m26a0611.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM BGM_MEMORIES_RETURNED non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(S04P01A) [décor sub chargé: Sub_s04p01a]
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  SkySubScreen.Show("s04p01a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoops! My stomach growled!", french="Oups! J'ai l'estomac qui\ngargouille!", german=" Huch! Mein Magen hat geknurrt!", italian="Oops! La mia pancia ha\nbrontolato!", spanish=" ¡Vaya! ¡Me rugen las tripas!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh! My stomach growled!", french="Oups! J'ai l'estomac qui\ngargouille!", german=" Oh! Mein Magen hat geknurrt!", italian="Oops! La mia pancia ha\nbrontolato!", spanish=" ¡Vaya! ¡Me ruge el estómago!"})
  else
  SkySceneKit.say({english=" Uh-oh! My stomach growled!", french="Oups! J'ai l'estomac qui\ngargouille!", german=" Oh-oh! Mein Magen hat geknurrt!", italian="Oops! La mia pancia ha\nbrontolato!", spanish=" ¡Vaya! ¡Me ruge el estómago!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Ha ha ha! Your stomach growled\ntoo, [hero]!", french="Ha ha ha! Toi aussi,\n[hero]!", german="Hahaha! Dein Magen hat auch\ngeknurrt, [hero]!", italian="Ah ah ah! Anche la tua pancia ha\nborbottato, [hero]!", spanish="¡Ja, ja, ja! ¡Y a ti también,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Ha ha ha! Your stomach growled\ntoo, [hero]!", french="Ha ha ha! Toi aussi,\n[hero]!", german="Hahaha! Dein Magen hat auch\ngeknurrt, [hero]!", italian="Ah ah ah! Anche la tua pancia ha\nborbottato, [hero]!", spanish="¡Ja, ja, ja! ¡Y a ti también,\n[hero]!"})
  else
  SkySceneKit.say({english="Ha ha ha! Your stomach growled\ntoo, [hero]!", french="Ha ha ha! Toi aussi,\n[hero]!", german="Hahaha! Dein Magen hat auch\ngeknurrt, [hero]!", italian="Ah ah ah! Anche la tua pancia ha\nborbottato, [hero]!", spanish="¡Ja, ja, ja! ¡Y a ti también,\n[hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I guess we must be starved!", french="Nos estomacs doivent crier\nfamine!", german=" Wir sind wohl am Verhungern!", italian=" Abbiamo una fame da leoni!", spanish="¡Supongo que tenemos un\nhambre atroz!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We must have worked up a\nbig appetite!", french="Nos estomacs doivent crier\nfamine!", german="Wir haben wohl einen ziemlichen\nKohldampf!", italian=" Abbiamo una fame da lupi!", spanish="¡Supongo que tenemos un\nhambre atroz!"})
  else
  SkySceneKit.say({english=" I guess we must be famished!", french="Nos estomacs doivent crier\nfamine!", german="Wir sind wohl schon ganz\nausgehungert!", italian=" Che fame ci è venuta!", spanish="¡Supongo que tenemos un\nhambre atroz!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We were so focused on rescuing\n[CS:N]Azurill[CR] that I didn't notice at all!", french="On était si absorbés par\nle sauvetage d'[CS:N]Azurill[CR] que je ne m'en étais\npas rendu compte!", german="Wir waren so auf die Rettung\nvon [CS:N]Azurill[CR] konzentriert, dass wir es gar nicht\ngemerkt haben!", italian="Eravamo così impegnati a\nsalvare [CS:N]Azurill[CR] che non me ne ero affatto\naccorto!", spanish="¡Como solo pensábamos en\nrescatar a [CS:N]Azurill[CR], no nos hemos dado\ncuenta hasta ahora!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We were so focused on rescuing\n[CS:N]Azurill[CR] that I didn't notice at all!", french="On était si absorbés par\nle sauvetage d'[CS:N]Azurill[CR] que je ne m'en étais\npas rendu compte!", german="Wir waren so auf die Rettung\nvon [CS:N]Azurill[CR] konzentriert, dass wir es gar nicht\ngemerkt haben!", italian="Eravamo così impegnati a\nsalvare [CS:N]Azurill[CR] che non me ne ero affatto\naccorto!", spanish="¡Como solo pensábamos en\nrescatar a [CS:N]Azurill[CR], no nos hemos dado\ncuenta hasta ahora!"})
  else
  SkySceneKit.say({english="We were so focused on rescuing\n[CS:N]Azurill[CR] that I didn't notice at all!", french="Le sauvetage d'[CS:N]Azurill[CR] a\ntellement monopolisé notre attention\nque je n'avais même pas remarqué!", german="Wir waren so auf die Rettung\nvon [CS:N]Azurill[CR] konzentriert, dass wir es gar nicht\ngemerkt haben!", italian="Abbiamo pensato così tanto a\ncome salvare [CS:N]Azurill[CR] che non me ne ero\naffatto accorta!", spanish="¡Como solo pensábamos en\nrescatar a [CS:N]Azurill[CR], no nos hemos dado\ncuenta hasta ahora!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But now I'm even hungrier!", french="Mais maintenant, j'ai encore plus\nfaim!", german="Aber jetzt habe ich umso\nmehr Hunger!", italian=" Ma adesso ho ancora più fame!", spanish="¡Y me está entrando aún más\nhambre!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But now I'm even hungrier!", french="Mais maintenant, j'ai encore plus\nfaim!", german="Aber jetzt habe ich umso\nmehr Hunger!", italian=" Ma adesso ho ancora più fame!", spanish="¡Y me está entrando aún más\nhambre!"})
  else
  SkySceneKit.say({english=" But now I'm even hungrier!", french="Mais maintenant, j'ai encore plus\nfaim!", german="Aber jetzt habe ich umso\nmehr Hunger!", italian=" Ma adesso ho ancora più fame!", spanish="¡Y me está entrando aún más\nhambre!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's go get dinner,\n[hero]!", french="Allez, on va manger,\n[hero]!", german="Gehen wir zum Abendessen,\n[hero]!", italian="Andiamo a mangiare,\n[hero]!", spanish=" ¡Vamos a cenar, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Come on, let's go get dinner,\n[hero]!", french="Allez, on va manger,\n[hero]!", german="Komm, gehen wir zum\nAbendessen, [hero]!", italian="Andiamo a mangiare,\n[hero]!", spanish=" ¡Vamos a cenar, [hero]!"})
  else
  SkySceneKit.say({english="Come on, let's go get dinner,\n[hero]!", french="Allez, on va manger,\n[hero]!", german="Komm, gehen wir zum\nAbendessen, [hero]!", italian="Andiamo a mangiare,\n[hero]!", spanish=" ¡Vamos a cenar, [hero]!"})
  end
  -- message_Close
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(partner, 364, 236, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 364, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(partner, 364, 180, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(hero, 364, 180, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:FadeOut(false, 30)
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:FadeIn(0) -- screen_FlushIn
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
