-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D37P41A/s20p1101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(63, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D37P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GROUND:MoveToPosition(partner, 212, 236, false, 2)
  GROUND:MoveToPosition(hero, 244, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We've gone pretty deep in here,\n[hero].", french="Nous avons bien avancé,\n[hero].", german="Wir sind ganz schön weit\nvorgedrungen, [hero].", italian="Siamo molto in profondità,\n[hero].", spanish="Nos hemos adentrado bastante,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We've gone pretty deep in here,\n[hero].", french="Nous avons bien avancé,\n[hero].", german="Wir sind ganz schön weit\nvorgedrungen, [hero].", italian="Siamo molto in profondità,\n[hero].", spanish="Nos hemos adentrado bastante,\n[hero]."})
  else
  SkySceneKit.say({english="We've come a long way here,\n[hero].", french="Nous avons bien avancé,\n[hero].", german="Wir sind ganz schön weit\nvorgestoßen, [hero].", italian="Siamo molto in profondità,\n[hero].", spanish="Nos hemos adentrado bastante,\n[hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It looks like it's just one long\npath from here...", french="Apparemment, il n'y a qu'un seul\nlong chemin...", german="Ab jetzt führt nur noch ein\neinzelner langer Pfad weiter, wie es scheint.", italian="Sembra che da qui parta\nun sentiero molto lungo.", spanish="Solo parece haber un camino y\nmuy largo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It appears as if it's just one\nlong path from here...", french="Apparemment, il n'y a qu'un seul\nlong chemin...", german="Ab jetzt führt nur noch ein\neinzelner langer Pfad weiter, wie es scheint.", italian="Sembra che da qui parta\nun sentiero molto lungo.", spanish="Solo parece haber un camino y\nmuy largo..."})
  else
  SkySceneKit.say({english="It appears as if it's just one\nlong path from here...", french="Apparemment, il n'y a qu'un seul\nlong chemin...", german="Ab jetzt führt nur noch ein\neinzelner langer Pfad weiter, wie es scheint.", italian="Sembra che da qui parta\nun sentiero molto lungo.", spanish="Solo parece haber un camino y\nmuy largo..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's keep going some more.", french=" Avançons encore un peu.", german="Gehen wir noch ein bisschen\nweiter.", italian=" Avanziamo un altro po'.", spanish=" Continuemos un poco más."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's keep going a little more.", french=" Avançons encore un peu.", german=" Gehen wir noch etwas weiter.", italian=" Avanziamo un altro po'.", spanish=" Continuemos un poco más."})
  else
  SkySceneKit.say({english=" Let's keep going some more.", french=" Avançons encore un peu.", german="Gehen wir noch ein bisschen\nweiter.", italian=" Avanziamo un altro po'.", spanish=" Continuemos un poco más."})
  end
  -- message_Close
  -- GAP: se_Play(6922) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 2)
  GAME:WaitFrames(3)
  GAME:FadeIn(2)
  GAME:WaitFrames(2)
  GAME:FadeOut(false, 2)
  GAME:WaitFrames(5)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 2)
  GAME:WaitFrames(3)
  GAME:FadeIn(2)
  GAME:WaitFrames(2)
  GAME:FadeOut(false, 2)
  GAME:WaitFrames(5)
  GAME:FadeIn(2)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: se_Play(6925) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waah! What's going on?!", french=" Ouaaah! Que se passe-t-il?!", german=" Uaah! Was passiert hier?!?", italian=" Waah! Cosa succede?!", spanish=" ¡Aaah! ¡¿Qué está pasando?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah! What's happening?!", french=" Ouaaah! Que se passe-t-il?!", german=" Uaah! Was passiert hier?!?", italian=" Waah! Cosa succede?!", spanish=" ¡Aaah! ¡¿Qué está pasando?!"})
  else
  SkySceneKit.say({english=" Waah! What's happening?!", french=" Ouaaah! Que se passe-t-il?!", german=" Uaah! Was passiert hier?!?", italian=" Waah! Cosa succede?!", spanish=" ¡Aaah! ¡¿Qué está pasando?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" .........[K] You...", french=" ..........[K] Vous...", german=" .........[K] Du...", italian=" .........[K] Voi...", spanish=" Eh...[K] Un momento..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" How did...[K] How did you get here?", french="Comment...[K] comment avez-vous fait pour\nvenir jusqu'ici?", german=" Wie...[K] Wie seid ihr hier reingekommen?", italian="Come...[K] Come avete fatto ad arrivare\nfin qui?", spanish=" ¿Cómo...?[K] ¿Cómo habéis entrado aquí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="There's someone here,\n[hero]!", french="Il y a quelqu'un ici,\n[hero]!", german="Es ist jemand hier,\n[hero]!", italian="C'è qualcuno qui,\n[hero]!", spanish=" ¡Aquí hay alguien, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There's someone here,\n[hero]!", french="Il y a quelqu'un ici,\n[hero]!", german="Es ist jemand hier,\n[hero]!", italian="C'è qualcuno qui,\n[hero]!", spanish=" ¡Aquí hay alguien, [hero]!"})
  else
  SkySceneKit.say({english="There's someone here,\n[hero]!", french="Il y a quelqu'un ici,\n[hero]!", german="Es ist jemand hier,\n[hero]!", italian="C'è qualcuno qui,\n[hero]!", spanish=" ¡Aquí hay alguien, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Who is it?![K] Where are you?", french=" Qui est là?![K] Où êtes-vous?", german=" Wer ist das?!?[K] Wo bist du?", italian=" Chi è là?![K] Dove sei?", spanish="¡¿Quién está ahí?![K]\n¿Dónde estás?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Who is it?![K] Where are you?", french=" Qui est là?![K] Où êtes-vous?", german=" Wer ist das?!?[K] Wo bist du?", italian=" Chi è là?![K] Dove sei?", spanish="¡¿Quién está ahí?![K]\n¿Dónde estás?"})
  else
  SkySceneKit.say({english=" Who is it?![K] Where are you?", french=" Qui est là?![K] Où êtes-vous?", german=" Wer ist das?!?[K] Wo bist du?", italian=" Chi è là?![K] Dove sei?", spanish="¡¿Quién está ahí?![K]\n¿Dónde estás?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Show yourself!", french=" Montrez-vous!", german=" Zeig dich!", italian=" Fatti vedere!", spanish=" ¡Sal que te veamos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Show yourself!", french=" Montrez-vous!", german=" Zeig dich!", italian=" Fatti vedere!", spanish=" ¡Sal que te veamos!"})
  else
  SkySceneKit.say({english=" Show yourself!", french=" Montrez-vous!", german=" Zeig dich!", italian=" Fatti vedere!", spanish=" ¡Sal que te veamos!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" I am...", french=" Je suis...", german=" Ich bin...", italian=" Io sono...", spanish=" Soy..."})
  -- message_Close
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(0)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(3)
  GAME:FadeIn(2)
  GAME:WaitFrames(50)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(3)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(5)
  GAME:FadeIn(2)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(10)
  GAME:WaitFrames(2) -- join WaitSe
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(8), 3, false) end) -- MovePositionOffset performer/caméra
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(5)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What...?!)", french="(Quoi...?!)", german="(Was?!?)", italian="(Cosa...?!)", spanish="(¡¿Qué?!)"})
  else
  SkySceneKit.say({english="(What...?!)", french="(Quoi...?!)", german="(Was?!?)", italian="(Cosa...?!)", spanish="(¡¿Qué?!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You![K] You're...?!", french=" Toi![K] Tu es...?!", german=" Du![K] Du bist...", italian=" Tu![K] Tu sei...?!", spanish=" ¡Tú![K] ¿Tú eres...?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You![K] You're...?!", french=" Toi![K] Tu es...?!", german=" Du![K] Du bist...", italian=" Tu![K] Tu sei...?!", spanish=" ¡Tú![K] ¿Tú eres...?"})
  else
  SkySceneKit.say({english=" You![K] You're...?!", french=" Toi![K] Tu es...?!", german=" Du![K] Du bist...", italian=" Tu![K] Tu sei...?!", spanish=" ¡Tú![K] ¿Tú eres...?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_WELCOME_TO_THE_WORLD_OF_POKEMON non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 232, 216, Direction.Down, "NPC_KURESERIA")
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" I am...[K] [CS:N]Cresselia[CR]!", french=" Je suis...[K] [CS:N]Cresselia[CR]!", german=" Ich bin...[K] [CS:N]Cresselia[CR]!", italian=" Io sono...[K] [CS:N]Cresselia[CR]!", spanish=" ¡Yo soy...[K] [CS:N]Cresselia[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:N]C-Cresselia[CR]...!)", french="([CS:N]Cresselia[CR]...!)", german="([CS:N]C-Cresselia[CR]!)", italian="([CS:N]C-Cresselia[CR]...!)", spanish="([CS:N]Cresselia[CR]...)"})
  else
  SkySceneKit.say({english="([CS:N]C-Cresselia[CR]...!)", french="([CS:N]Cresselia[CR]...!)", german="([CS:N]C-Cresselia[CR]!)", italian="([CS:N]C-Cresselia[CR]...!)", spanish="([CS:N]Cresselia[CR]...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's [CS:N]Cresselia[CR]...[K] The one from my dreams...)", french="(C'est [CS:N]Cresselia[CR]...[K] le Pokémon que j'ai vu\nen rêve...)", german="(Es ist [CS:N]Cresselia[CR]...[K] Das Pokémon aus\nmeinen Träumen...)", italian="(È [CS:N]Cresselia[CR]...[K] Il Pokémon del mio sogno...)", spanish="(Es [CS:N]Cresselia[CR]...[K] Estaba en mis sueños...)"})
  else
  SkySceneKit.say({english="(It's [CS:N]Cresselia[CR]...[K] The one from my dreams...)", french="(C'est [CS:N]Cresselia[CR]...[K] le Pokémon que j'ai vu\nen rêve...)", german="(Es ist [CS:N]Cresselia[CR]...[K] Das Pokémon aus\nmeinen Träumen...)", italian="(È [CS:N]Cresselia[CR]...[K] Il Pokémon del mio sogno...)", spanish="(Es [CS:N]Cresselia[CR]...[K] Estaba en mis sueños...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="I cannot fathom how you've\ncome here, but...", french="J'ignore comment vous avez\nréussi à arriver ici mais...", german="Ich kann mir nicht erklären, wie\nihr hierhergekommen seid, aber...", italian="Non capisco come abbiate fatto\nad arrivare qui.", spanish="No logro entender cómo\nhabéis llegado hasta aquí, pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="I find your visit ever so\nconvenient!", french="Je trouve que votre visite\ntombe à point nommé!", german="Ich finde euren Besuch äußerst\npraktisch!", italian="Però la vostra visita capita\nal momento giusto!", spanish="¡Vuestra visita es de lo más\noportuna!"})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" I've longed to meet both of you!", french="Cela fait longtemps que je\nsouhaite vous rencontrer!", german="Ich wollte euch beide schon\nlange mal treffen!", italian="È da tempo che\nvolevo incontrarvi!", spanish=" ¡Estaba deseando encontraros!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]C-Cresselia[CR]...", french=" [CS:N]C-Cresselia[CR]...", german=" [CS:N]C-Cresselia[CR]...", italian=" [CS:N]C-Cresselia[CR]...", spanish=" [CS:N]Cre[CR]... [CS:N]Cresselia[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]C-Cresselia[CR]...", french=" [CS:N]C-Cresselia[CR]...", german=" [CS:N]C-Cresselia[CR]...", italian=" [CS:N]C-Cresselia[CR]...", spanish=" [CS:N]Cre[CR]... [CS:N]Cresselia[CR]..."})
  else
  SkySceneKit.say({english=" [CS:N]C-Cresselia[CR]...", french=" [CS:N]C-Cresselia[CR]...", german=" [CS:N]C-Cresselia[CR]...", italian=" [CS:N]C-Cresselia[CR]...", spanish=" [CS:N]Cre[CR]... [CS:N]Cresselia[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So my dreams...[K] They weren't\njust ordinary dreams after all...", french="Alors mes rêves...[K] n'avaient\nrien d'ordinaire, finalement...", german="Also waren meine Träume...[K] Sie\nwaren doch keine gewöhnlichen Träume...", italian="Quindi i miei sogni...[K] Allora\nnon erano sogni normali...", spanish=" Así que...[K] no eran solo sueños..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So my dreams...[K] They weren't\njust ordinary dreams after all...", french="Alors mes rêves...[K] n'avaient\nrien d'ordinaire, finalement...", german="Also waren meine Träume...[K] Sie\nwaren doch keine gewöhnlichen Träume...", italian="Quindi i miei sogni...[K] Allora\nnon erano sogni normali...", spanish=" Así que...[K] no eran solo sueños..."})
  else
  SkySceneKit.say({english="So my dreams...[K] They weren't\njust ordinary dreams after all...", french="Alors mes rêves...[K] n'avaient\nrien d'ordinaire, finalement...", german="Also waren meine Träume...[K] Sie\nwaren doch keine gewöhnlichen Träume...", italian="Quindi i miei sogni...[K] Allora\nnon erano sogni normali...", spanish=" Así que...[K] no eran solo sueños..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What?!)", french="(Quoi?!)", german="(Was?!?)", italian="(Cosa?!)", spanish="(¡¿Qué?!)"})
  else
  SkySceneKit.say({english="(What?!)", french="(Quoi?!)", german="(Was?!?)", italian="(Cosa?!)", spanish="(¡¿Qué?!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Then what I saw in my\ndreams...", french="Mais alors ce que j'ai vu\ndans mes rêves...", german="Was ich in meinen Träumen\ngesehen habe...", italian="Quindi quello che ho visto\nnei miei sogni...", spanish=" Entonces, lo que vi en ellos..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Then what I saw in my\ndreams...", french="Mais alors ce que j'ai vu\ndans mes rêves...", german="Was ich in meinen Träumen\ngesehen habe...", italian="Quindi quello che ho visto\nnei miei sogni...", spanish=" Entonces, lo que vi en ellos..."})
  else
  SkySceneKit.say({english="Then what I saw in my\ndreams...", french="Mais alors ce que j'ai vu\ndans mes rêves...", german="Was ich in meinen Träumen\ngesehen habe...", italian="Quindi quello che ho visto\nnei miei sogni...", spanish=" Entonces, lo que vi en ellos..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Yes.", french=" Oui.", german=" Ja.", italian=" Sì.", spanish=" Sí."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="What I told you in your dreams\nis true...", french="Ce que je t'ai dit dans tes\nrêves est la stricte vérité...", german="Was ich dir in deinen Träumen\nerzählt habe, ist die Wahrheit...", italian="Quello che vi ho detto\nnei vostri sogni è vero.", spanish="Lo que te dije en tus sueños es\ncierto..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="You two are not supposed to\nexist in this world.", french="Vous deux n'avez pas votre\nplace dans ce monde. Vous ne devriez même\npas exister.", german="Ihr beiden solltet in dieser Welt\nnicht existieren.", italian="Voi due non dovreste esistere\nin questo mondo.", spanish="No deberíais existir en este\nmundo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What? You...[K]two?!)", french="(Quoi? Nous...[K] deux?!)", german="(Was? Ihr... [K]beiden?!?)", italian="(Cosa? Voi...[K] due?!)", spanish="(¿Qué?[K] ¿Os conocíais?)"})
  else
  SkySceneKit.say({english="(What? You...[K]two?!)", french="(Quoi? Nous...[K] deux?!)", german="(Was? Ihr... [K]beiden?!?)", italian="(Cosa? Voi...[K] due?!)", spanish="(¿Qué?[K] ¿Os conocíais?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I suspected this...", french=" Je me doutais...", german=" Das habe ich vermutet...", italian=" Sospettavo...", spanish=" Me lo estaba imaginando..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I suspected this...", french=" Je me doutais...", german=" Das habe ich vermutet...", italian=" Sospettavo...", spanish=" Me lo estaba imaginando..."})
  else
  SkySceneKit.say({english=" I suspected this...", french=" Je me doutais...", german=" Das habe ich vermutet...", italian=" Sospettavo...", spanish=" Me lo estaba imaginando..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That you and I were having the\nsame dreams, [hero].", french="... que toi et moi avions eu\nles mêmes rêves, [hero].", german="Dass du und ich die gleichen\nTräume haben, [hero].", italian="Sospettavo che tu e io facessimo\ngli stessi sogni, [hero].", spanish="Hemos estado soñando lo mismo,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That you and I were having the\nsame dreams, [hero].", french="... que toi et moi avions eu\nles mêmes rêves, [hero].", german="Dass du und ich die gleichen\nTräume haben, [hero].", italian="Sospettavo che tu e io facessimo\ngli stessi sogni, [hero].", spanish="Hemos estado soñando lo mismo,\n[hero]."})
  else
  SkySceneKit.say({english="That you and I were having the\nsame dreams, [hero].", french="... que toi et moi avions eu\nles mêmes rêves, [hero].", german="Dass du und ich die gleichen\nTräume haben, [hero].", italian="Sospettavo che tu e io facessimo\ngli stessi sogni, [hero].", spanish="Hemos estado soñando lo mismo,\n[hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I went to the future...", french=" Je suis allé dans le futur...", german=" Ich ging in die Zukunft...", italian=" Sono stato nel futuro...", spanish=" Fuimos al futuro..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I went to the future...", french=" Je suis allé dans le futur...", german=" Ich ging in die Zukunft...", italian=" Sono stato nel futuro...", spanish=" Fuimos al futuro..."})
  else
  SkySceneKit.say({english=" I went to the future...", french=" Je suis allée dans le futur...", german=" Ich ging in die Zukunft...", italian=" Sono stata nel futuro...", spanish=" Fuimos al futuro..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Then I came back to this world...", french="... puis je suis revenu dans\nce monde...", german="Dann kam ich zurück in diese\nWelt...", italian=" E poi sono tornato nel presente.", spanish="Y, después, regresamos a este\nmundo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Then I came back to this world...", french="... puis je suis revenu dans\nce monde...", german="Dann kam ich zurück in diese\nWelt...", italian=" E poi sono tornato nel presente.", spanish="Y, después, regresamos a este\nmundo..."})
  else
  SkySceneKit.say({english=" Then I came back to this world...", french="... puis je suis revenue dans\nce monde...", german="Dann kam ich zurück in diese\nWelt...", italian=" E poi sono tornata nel presente.", spanish="Y, después, regresamos a este\nmundo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And it's causing the destruction\nof this world.", french="... et c'est ce qui est en train de\ncauser sa destruction.", german="Und das verursacht die\nZerstörung dieser Welt.", italian="Tutto ciò sta causando la\ndistruzione di questo mondo.", spanish="Y, ahora, estamos causando su\ndestrucción..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And it's causing the destruction\nof this world.", french="... et c'est ce qui est en train de\ncauser sa destruction.", german="Und das verursacht die\nZerstörung dieser Welt.", italian="Tutto ciò sta causando la\ndistruzione di questo mondo.", spanish="Y, ahora, estamos causando su\ndestrucción..."})
  else
  SkySceneKit.say({english="And it's causing the destruction\nof this world.", french="... et c'est ce qui est en train de\ncauser sa destruction.", german="Und das verursacht die\nZerstörung dieser Welt.", italian="Tutto ciò sta causando la\ndistruzione di questo mondo.", spanish="Y, ahora, estamos causando su\ndestrucción..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So [CS:N]Cresselia[CR] said in my dreams.", french="C'est ce que [CS:N]Cresselia[CR] m'a dit\nen rêve.", german="Das sagte mir [CS:N]Cresselia[CR] in\nmeinen Träumen.", italian="Questo è quello che ha detto\n[CS:N]Cresselia[CR] nei miei sogni.", spanish=" Eso dijo [CS:N]Cresselia[CR] en mis sueños."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So [CS:N]Cresselia[CR] said in my dreams.", french="C'est ce que [CS:N]Cresselia[CR] m'a dit\nen rêve.", german="Das sagte mir [CS:N]Cresselia[CR] in\nmeinen Träumen.", italian="Questo è quello che ha detto\n[CS:N]Cresselia[CR] nei miei sogni.", spanish=" Eso dijo [CS:N]Cresselia[CR] en mis sueños."})
  else
  SkySceneKit.say({english=" So [CS:N]Cresselia[CR] said in my dreams.", french="C'est ce que [CS:N]Cresselia[CR] m'a dit\nen rêve.", german="Das sagte mir [CS:N]Cresselia[CR] in\nmeinen Träumen.", italian="Questo è quello che ha detto\n[CS:N]Cresselia[CR] nei miei sogni.", spanish=" Eso dijo [CS:N]Cresselia[CR] en mis sueños."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(So it wasn't just me that had those dreams!)", french="(Alors, ces rêves n'arrivaient pas qu'à moi!)", german="(Also hatte nicht nur ich diese Träume!)", italian="(Quindi non sono stato l'unico\na fare quei sogni!)", spanish="(¡Así que no solo yo he tenido esos sueños!)"})
  else
  SkySceneKit.say({english="(So it wasn't just me that had those dreams!)", french="(Alors, ces rêves n'arrivaient pas qu'à moi!)", german="(Also hatte nicht nur ich diese Träume!)", italian="(Quindi non sono stata l'unica\na fare quei sogni!)", spanish="(¡Así que no solo yo he tenido esos sueños!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(And [partner] is the same as I am...)", french="(Et [partner] est comme moi...)", german="(Und [partner] ist genau wie ich...)", italian="(E anche [partner], come me, è...)", spanish="(Y [partner], como yo,...)"})
  else
  SkySceneKit.say({english="(And [partner] is the same as I am...)", french="(Et [partner] est comme moi...)", german="(Und [partner] ist genau wie ich...)", italian="(E anche [partner], come me, è...)", spanish="(Y [partner], como yo,...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner] is another presence that must\nnot exist in this world.)", french="(Tout comme la mienne, la présence\nde [partner] dans ce monde est une\nerreur.)", german="([partner] ist auch eine Existenz, die es\nin dieser Welt nicht geben darf.)", italian="(... un'altra presenza che non deve\nesistere in questo mondo.)", spanish="([partner] tampoco debería existir en este\nmundo.)"})
  else
  SkySceneKit.say({english="([partner] is another presence that must\nnot exist in this world.)", french="(Tout comme la mienne, la présence\nde [partner] dans ce monde est une\nerreur.)", german="([partner] ist auch eine Existenz, die es\nin dieser Welt nicht geben darf.)", italian="(... un'altra presenza che non deve\nesistere in questo mondo.)", spanish="([partner] tampoco debería existir en este\nmundo.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:N]Cresselia[CR] said that to [partner] too!)", french="([CS:N]Cresselia[CR] l'a dit aussi à [partner]!)", german="([CS:N]Cresselia[CR] hat das auch zu\n[partner] gesagt!)", italian="([CS:N]Cresselia[CR] l'ha detto anche a [partner]!)", spanish="(¡[CS:N]Cresselia[CR] también se lo dijo!)"})
  else
  SkySceneKit.say({english="([CS:N]Cresselia[CR] said that to [partner] too!)", french="([CS:N]Cresselia[CR] l'a dit aussi à [partner]!)", german="([CS:N]Cresselia[CR] hat das auch zu\n[partner] gesagt!)", italian="([CS:N]Cresselia[CR] l'ha detto anche a [partner]!)", spanish="(¡[CS:N]Cresselia[CR] también se lo dijo!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, [CS:N]Cresselia[CR], can you explain\nsomething?", french="S'il te plaît, [CS:N]Cresselia[CR], peux-tu\nnous expliquer quelque chose?", german="Hey, [CS:N]Cresselia[CR], kannst du uns\netwas erklären?", italian="Ehi, [CS:N]Cresselia[CR], puoi spiegarci\nuna cosa?", spanish="Oye, [CS:N]Cresselia[CR], ¿puedes\nexplicarnos algo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Excuse me, [CS:N]Cresselia[CR]. Could you\nexplain something for us?", french="S'il te plaît, [CS:N]Cresselia[CR], peux-tu\nnous expliquer quelque chose?", german="Verzeihung, [CS:N]Cresselia[CR]. Könntest\ndu uns etwas erläutern?", italian="Scusa, [CS:N]Cresselia[CR], puoi spiegarci\nuna cosa?", spanish="Perdona, [CS:N]Cresselia[CR], ¿puedes\nexplicarnos algo?"})
  else
  SkySceneKit.say({english="Say, [CS:N]Cresselia[CR], could you explain\nsomething?", french="S'il te plaît, [CS:N]Cresselia[CR], peux-tu\nnous expliquer quelque chose?", german="Sag mal, [CS:N]Cresselia[CR], kannst du\nuns etwas erklären?", italian="Senti, [CS:N]Cresselia[CR], puoi spiegarci\nuna cosa?", spanish="Oye, [CS:N]Cresselia[CR], ¿puedes\nexplicarnos algo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I traveled to the future and\ncame back again...", french="J'ai fait un aller-retour dans\nle futur...", german="Ich bin in die Zukunft und\nwieder zurückgereist...", italian="Sono stato nel futuro e\nsono tornato indietro...", spanish=" Yo viajé al futuro y regresé..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I traveled to the future and\ncame back again...", french="J'ai fait un aller-retour dans\nle futur...", german="Ich bin in die Zukunft und\nwieder zurückgereist...", italian="Sono stato nel futuro e\nsono tornato indietro...", spanish=" Yo viajé al futuro y regresé..."})
  else
  SkySceneKit.say({english="I traveled to the future and\ncame back again...", french="J'ai fait un aller-retour dans\nle futur...", german="Ich bin in die Zukunft und\nwieder zurückgereist...", italian="Sono stata nel futuro e\nsono tornata indietro...", spanish=" Yo viajé al futuro y regresé..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And [hero] was a human\nwho came from the future...", french="... et [hero] est un\nêtre humain qui vient du futur...", german="Und [hero] war ein\nMensch, der aus der Zukunft gekommen ist...", italian="... e [hero] era un essere\numano proveniente dal futuro.", spanish="Y [hero] viene del futuro,\ny, además, es un ser humano..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And [hero] was a human\nwho came from the future...", french="... et [hero] est un\nêtre humain qui vient du futur...", german="Und [hero] war ein\nMensch, der aus der Zukunft gekommen ist...", italian="... e [hero] era un essere\numano proveniente dal futuro.", spanish="Y [hero] viene del futuro,\ny, además, es un ser humano..."})
  else
  SkySceneKit.say({english="And [hero] was a human\nwho came from the future...", french="... et [hero] est un\nêtre humain qui vient du futur...", german="Und [hero] war ein\nMensch, der aus der Zukunft gekommen ist...", italian="... e [hero] era un essere\numano proveniente dal futuro.", spanish="Y [hero] viene del futuro,\ny, además, es un ser humano..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You said that we're causing the\ndistortion in the fabric of space in our world.", french="Tu as dit que nous sommes la\ncause de la distorsion de la trame de l'espace\ndans notre monde.", german="Du sagtest, dass wir die\nVerzerrung des Raumgefüges in unserer Welt\nverursachen würden.", italian="Hai detto che stiamo\ncausando la distorsione della struttura dello\nspazio nel nostro mondo.", spanish="Dijiste que estamos causando\nla deformación del espacio en nuestro\nmundo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You said that we're causing the\ndistortion in the fabric of space in our world.", french="Tu as dit que nous sommes la\ncause de la distorsion de la trame de l'espace\ndans notre monde.", german="Du sagtest, dass wir die\nVerzerrung des Raumgefüges in unserer Welt\nverursachen würden.", italian="Hai detto che stiamo\ncausando la distorsione della struttura dello\nspazio nel nostro mondo.", spanish="Dijiste que estamos causando\nla deformación del espacio en nuestro\nmundo."})
  else
  SkySceneKit.say({english="You said that we're causing the\ndistortion in the fabric of space in our world.", french="Tu as dit que nous sommes la\ncause de la distorsion de la trame de l'espace\ndans notre monde.", german="Du sagtest, dass wir die\nVerzerrung des Raumgefüges in unserer Welt\nverursachen würden.", italian="Hai detto che stiamo\ncausando la distorsione della struttura dello\nspazio nel nostro mondo.", spanish="Dijiste que estamos causando\nla deformación del espacio en nuestro\nmundo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If space itself becomes\ndistorted...[K]why will the world be destroyed?", french="Si l'espace lui-même est\ndistordu...[K] quel est le rapport avec\nla destruction du monde?", german="Wenn der Raum selbst sich\nverzerrt...[K] Warum wird die Welt dadurch\nzerstört?", italian="Se lo spazio stesso viene\ndistorto...[K] perché il mondo si distruggerà?", spanish="¿Qué tiene que ver que el\nespacio se deforme con que se destruya\nel mundo?[K] ¿Eh?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If space itself becomes\ndistorted...[K]why will the world be destroyed?", french="Si l'espace lui-même est\ndistordu...[K] quel est le rapport avec\nla destruction du monde?", german="Wenn der Raum selbst sich\nverzerrt...[K] Warum wird die Welt dadurch\nzerstört?", italian="Se lo spazio stesso viene\ndistorto...[K] perché il mondo si distruggerà?", spanish="¿Qué tiene que ver que el\nespacio se deforme con que se destruya\nel mundo?[K] ¿Eh?"})
  else
  SkySceneKit.say({english="If space itself becomes\ndistorted...[K]why will the world be destroyed?", french="Si l'espace lui-même est\ndistordu...[K] quel est le rapport avec\nla destruction du monde?", german="Wenn der Raum selbst sich\nverzerrt...[K] Warum wird die Welt dadurch\nzerstört?", italian="Se lo spazio stesso viene\ndistorto...[K] perché il mondo si distruggerà?", spanish="¿Qué tiene que ver que el\nespacio se deforme con que se destruya\nel mundo?[K] ¿Eh?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="...[K]If the distortion in the\nfabric of space expands, the power of\ndarkness will expand as well.", french="...[K] Si la distorsion de la\ntrame de l'espace s'étend, le pouvoir de\nl'ombre va s'étendre aussi.", german="...[K]Wenn die Verzerrung des\nRaumgefüges expandiert, dann expandieren\nauch die Mächte der Dunkelheit.", italian="...[K] Se la distorsione della\nstruttura dello spazio aumenta, la\npotenza dell'oscurità aumenterà a sua volta.", spanish="Si aumenta...[K] Si aumenta la\ndeformación del espacio, también lo hará\nel poder de la oscuridad."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Eventually...[K]the world will\nbecome enveloped within a nightmare.", french="Et à terme...[K] le monde entier\nsera enveloppé dans un cauchemar.", german="Und irgendwann...[K] wird die Welt\nin einen Albtraum gehüllt.", italian="Alla fine...[K] il mondo sarà\nintrappolato in un incubo.", spanish="Hasta que el mundo...[K] quede\natrapado en una gran pesadilla."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Enveloped within a nightmare...?", french=" Enveloppé dans un cauchemar...?", german=" In einen Albtraum gehüllt?", italian=" Intrappolato in un incubo...?", spanish=" ¿Atrapado en una pesadilla?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Enveloped within a nightmare...?", french=" Enveloppé dans un cauchemar...?", german=" In einen Albtraum gehüllt?", italian=" Intrappolato in un incubo...?", spanish=" ¿Atrapado en una pesadilla?"})
  else
  SkySceneKit.say({english=" Enveloped within a nightmare...?", french=" Enveloppé dans un cauchemar...?", german=" In einen Albtraum gehüllt?", italian=" Intrappolato in un incubo...?", spanish=" ¿Atrapado en una pesadilla?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Yes.", french=" Oui.", german=" Ja.", italian=" Sì.", spanish=" Sí."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Do you know where we are at\nthis very moment?", french="Savez-vous où nous sommes\nen ce moment même?", german="Wisst ihr, wo wir uns in genau\ndiesem Moment befinden?", italian="Sapete dove ci troviamo in\nquesto preciso istante?", spanish="¿Sabéis dónde estamos ahora\nmismo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Well...[K]we're in [CS:N]Azurill[CR]'s dream,\naren't we?", french="Eh bien...[K] nous sommes dans le\nrêve d'[CS:N]Azurill[CR], n'est-ce pas?", german="Nun,[K] wir befinden uns in dem\nTraum von [CS:N]Azurill[CR], oder etwa nicht?", italian="Beh...[K] siamo nel sogno di\n[CS:N]Azurill[CR], non è così?", spanish="Pues...[K] en el sueño de [CS:N]Azurill[CR],\n¿no?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well...[K]we're in [CS:N]Azurill[CR]'s dream,\naren't we?", french="Eh bien...[K] nous sommes dans le\nrêve d'[CS:N]Azurill[CR], n'est-ce pas?", german="Nun,[K] wir befinden uns in dem\nTraum von [CS:N]Azurill[CR], oder etwa nicht?", italian="Beh...[K] siamo nel sogno di\n[CS:N]Azurill[CR], non è così?", spanish="Pues...[K] en el sueño de [CS:N]Azurill[CR],\n¿no?"})
  else
  SkySceneKit.say({english="Well...[K]we're in [CS:N]Azurill[CR]'s dream,\naren't we?", french="Eh bien...[K] nous sommes dans le\nrêve d'[CS:N]Azurill[CR], n'est-ce pas?", german="Nun,[K] wir befinden uns in dem\nTraum von [CS:N]Azurill[CR], oder etwa nicht?", italian="Beh...[K] siamo nel sogno di\n[CS:N]Azurill[CR], non è così?", spanish="Pues...[K] en el sueño de [CS:N]Azurill[CR],\n¿no?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="That is correct.[K] More precisely,\nwe are in [CS:N]Azurill[CR]'s [CS:P]nightmare[CR].", french="C'est exact.[K] Plus précisément,\ndans son [CS:P]Cauchemar[CR].", german="Das ist korrekt.[K] Um genau zu\nsein, befinden wir uns in dem [CS:P]Albtraum[CR] von\n[CS:N]Azurill[CR].", italian="Esatto.[K] Più precisamente,\nsiamo nell'[CS:P]Incubo[CR] di [CS:N]Azurill[CR].", spanish="Correcto.[K] Para ser más exactos,\nen la [CS:P]pesadilla[CR] de [CS:N]Azurill[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[CS:N]Azurill[CR] will remain trapped by\nthe nightmare...", french="[CS:N]Azurill[CR] va rester enfermé\nà l'intérieur...", german="[CS:N]Azurill[CR] wird in dem Albtraum\ngefangen bleiben...", italian="[CS:N]Azurill[CR] rimarrà intrappolato\nnell'incubo...", spanish="[CS:N]Azurill[CR] seguirá sumido en esta\npesadilla..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" never to awaken again.", french=" ... et ne jamais se réveiller.", german="Und er wird nie wieder\naufwachen.", italian="... senza più riuscire\na svegliarsi.", spanish=" Y no despertará nunca."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="This nightmare will eventually\ncreep across the world.", french="Ce cauchemar va finir par se\nrépandre à travers le monde.", german="Dieser Albtraum wird\nirgendwann über die ganze Welt gekrochen\nkommen.", italian="Col passare del tempo, questo\nincubo avvolgerà tutto il mondo.", spanish="Además, la pesadilla terminará\npor extenderse al mundo entero."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="For now, only [CS:N]Azurill[CR] is afflicted\nwith this nightmare.", french="Pour l'instant, seul [CS:N]Azurill[CR]\nen est frappé.", german="Im Moment ist nur [CS:N]Azurill[CR] von\ndiesem Albtraum betroffen.", italian="Per il momento, solo [CS:N]Azurill[CR] è\nstato colpito.", spanish="De momento, solo le afecta a\n[CS:N]Azurill[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="But soon other Pokémon will be\ndrawn in by the nightmare's widening web.", french="Mais bientôt d'autres Pokémon\nvont être happés à mesure que la toile de\nce cauchemar s'étendra.", german="Aber bald werden sich auch\nandere Pokémon in dem Netz verfangen, das\nder Albtraum auslegt.", italian="Ma presto anche altri Pokémon\nverranno avvolti dalla ragnatela sempre più\ngrande dell'incubo.", spanish="Pero pronto afectará a otros\nPokémon."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="More and more Pokémon will\nfall into the unending sleep.", french="De plus en plus de Pokémon vont\ntomber dans un sommeil sans fin.", german="Immer mehr Pokémon werden in\neinen nicht enden wollenden Schlaf fallen.", italian="Un numero sempre maggiore di\nPokémon cadrà in un sonno senza fine.", spanish="Poco a poco, todos irán cayendo\nen una pesadilla eterna."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="And, ultimately, all Pokémon will\nbe locked in this nightmare without end.", french="Et pour finir, tous les Pokémon\nseront enfermés dans cet interminable\ncauchemar.", german="Und letztendlich werden alle\nPokémon in diesem Albtraum ohne Ende\ngefangen sein.", italian="E in breve tempo, tutti i\nPokémon si ritroveranno imprigionati in\nquesto incubo eterno.", spanish="Y finalmente, quedarán\natrapados en ella."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(A-all Pokémon...)", french="(Tous... tous les Pokémon...)", german="(A-alle Pokémon...)", italian="(T-Tutti i Pokémon...)", spanish="(To... todos los Pokémon...)"})
  else
  SkySceneKit.say({english="(A-all Pokémon...)", french="(Tous... tous les Pokémon...)", german="(A-alle Pokémon...)", italian="(T-Tutti i Pokémon...)", spanish="(To... todos los Pokémon...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(180) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" H-hey, [CS:N]Cresselia[CR].", french=" D... dis, [CS:N]Cresselia[CR].", german=" H-hey, [CS:N]Cresselia[CR].", italian=" E-Ehi, [CS:N]Cresselia[CR].", spanish=" O... oye, [CS:N]Cresselia[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" H-hey, [CS:N]Cresselia[CR].", french=" D... dis, [CS:N]Cresselia[CR].", german=" H-hey, [CS:N]Cresselia[CR].", italian=" E-Ehi, [CS:N]Cresselia[CR].", spanish=" O... oye, [CS:N]Cresselia[CR]."})
  else
  SkySceneKit.say({english=" H-hey, [CS:N]Cresselia[CR].", french=" D... dis, [CS:N]Cresselia[CR].", german=" H-hey, [CS:N]Cresselia[CR].", italian=" E-Ehi, [CS:N]Cresselia[CR].", spanish=" O... oye, [CS:N]Cresselia[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What will it take...[K]to get rid\nof the distortion in the fabric of space?", french="Qu'est-ce qu'il faut...[K] pour se\ndébarrasser de cette distorsion de la trame de\nl'espace?", german="Was muss getan werden,[K] um\ndie Verzerrung im Raumgefüge zu überwinden?", italian="Cosa bisogna fare...[K] per\nbloccare la distorsione della struttura\ndello spazio?", spanish="¿Qué habría que hacer...?[K]\n¿Qué habría que hacer para acabar con\nla deformación del espacio?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What will it take...[K]to get rid\nof the distortion in the fabric of space?", french="Qu'est-ce qu'il faut...[K] pour se\ndébarrasser de cette distorsion de la trame de\nl'espace?", german="Was muss getan werden,[K] um\ndie Verzerrung im Raumgefüge zu überwinden?", italian="Cosa bisogna fare...[K] per\nbloccare la distorsione della struttura\ndello spazio?", spanish="¿Qué habría que hacer...?[K]\n¿Qué habría que hacer para acabar con\nla deformación del espacio?"})
  else
  SkySceneKit.say({english="What will it take...[K]to get rid\nof the distortion in the fabric of space?", french="Qu'est-ce qu'il faut...[K] pour se\ndébarrasser de cette distorsion de la trame de\nl'espace?", german="Was muss getan werden,[K] um\ndie Verzerrung im Raumgefüge zu überwinden?", italian="Cosa bisogna fare...[K] per\nbloccare la distorsione della struttura\ndello spazio?", spanish="¿Qué habría que hacer...?[K]\n¿Qué habría que hacer para acabar con\nla deformación del espacio?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="How can the space distortion be\neliminated?", french=" Comment peut-on l'éliminer?", german="Wie kann die Raumverzerrung\nbeseitigt werden?", italian=" Come la si può arrestare?", spanish=" ¿Cómo se puede acabar con ella?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="How can the space distortion be\neliminated?", french=" Comment peut-on l'éliminer?", german="Wie kann die Raumverzerrung\nbeseitigt werden?", italian=" Come la si può arrestare?", spanish=" ¿Cómo se puede acabar con ella?"})
  else
  SkySceneKit.say({english="How can the space distortion be\neliminated?", french=" Comment peut-on l'éliminer?", german="Wie kann die Raumverzerrung\nbeseitigt werden?", italian=" Come la si può arrestare?", spanish=" ¿Cómo se puede acabar con ella?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="There is but one way to\neliminate the distortion.", french="Pour cela, il n'existe qu'un seul\nmoyen.", german="Es gibt nur einen Weg, die\nVerzerrung zu beseitigen.", italian=" C'è un solo modo.", spanish=" Solo hay una forma de hacerlo."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" That is...[K]for you to disappear!", french=" Il faut...[K] que vous disparaissiez!", german=" ...[K]Ihr müsst verschwinden!", italian=" Voi due...[K] dovete sparire!", spanish=" Y es...[K] ¡que desaparezcáis!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?! Disappear? Us?", french=" Quoi?! Nous devons disparaître?", german=" Was?!? Verschwinden? Wir?", italian=" Cosa?! Sparire? Noi?", spanish=" ¿Qué? ¿Que desaparezcamos? "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?! Disappear? Us?", french=" Quoi?! Nous devons disparaître?", german=" Was?!? Verschwinden? Wir?", italian=" Cosa?! Sparire? Noi?", spanish=" ¿Qué? ¿Que desaparezcamos? "})
  else
  SkySceneKit.say({english=" What?! Disappear? Us?", french=" Quoi?! Nous devons disparaître?", german=" Was?!? Verschwinden? Wir?", italian=" Cosa?! Sparire? Noi?", spanish=" ¿Qué? ¿Que desaparezcamos? "})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="I have been waiting for this\nopportunity.", french="Cela fait longtemps que j'attends\npareille occasion.", german="Ich habe auf diese Gelegenheit\ngewartet.", italian="È da tempo che aspetto questa\noccasione.", spanish="Llevo tiempo esperando esta\noportunidad."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_kureseria.Position; GROUND:MoveToPosition(npc_npc_kureseria, p.X+(0), p.Y+(8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="The opportunity...[K]to make you\ndisappear!", french="L'occasion...[K] de vous faire\ndisparaître!", german="Die Gelegenheit...[K] euch\nverschwinden zu lassen!", italian="L'occasione per...[K] farvi\nsparire!", spanish="La oportunidad...[K] ¡de haceros\ndesaparecer!"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What...?[K] Wait a second!", french=" Quoi...?[K] Attends une seconde!", german=" Was...[K] Eine Sekunde mal!", italian=" Cosa...?[K] Aspetta un attimo!", spanish=" ¿Qué?[K] ¡Espera un segundo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What...?[K] Wait a second!", french=" Quoi...?[K] Attends une seconde!", german=" Was...[K] Eine Sekunde mal!", italian=" Cosa...?[K] Aspetta un attimo!", spanish=" ¿Qué?[K] ¡Espera un segundo!"})
  else
  SkySceneKit.say({english=" What...?[K] Wait a second!", french=" Quoi...?[K] Attends une seconde!", german=" Was...[K] Eine Sekunde mal!", italian=" Cosa...?[K] Aspetta un attimo!", spanish=" ¿Qué?[K] ¡Espera un segundo!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We don't want to disappear!\nWe want to know more about what's happening!", french="Nous ne voulons pas disparaître!\nNous voulons simplement comprendre ce qui\nse passe!", german="Wir wollen nicht verschwinden!\nWir möchten mehr darüber erfahren, was\npassiert!", italian="Non vogliamo sparire!\nVogliamo capire meglio quanto sta accadendo!", spanish="¡No queremos desaparecer!\n¡Queremos saber qué está ocurriendo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We don't want to disappear!\nWe want to know more about what's happening!", french="Nous ne voulons pas disparaître!\nNous voulons simplement comprendre ce qui\nse passe!", german="Wir wollen nicht verschwinden!\nWir möchten mehr darüber erfahren, was\npassiert!", italian="Non vogliamo sparire!\nVogliamo capire meglio quanto sta accadendo!", spanish="¡No queremos desaparecer!\n¡Queremos saber qué está ocurriendo!"})
  else
  SkySceneKit.say({english="We don't want to disappear!\nWe want to know more about what's happening!", french="Nous ne voulons pas disparaître!\nNous voulons simplement comprendre ce qui\nse passe!", german="Wir wollen nicht verschwinden!\nWir möchten mehr darüber erfahren, was\npassiert!", italian="Non vogliamo sparire!\nVogliamo capire meglio quanto sta accadendo!", spanish="¡No queremos desaparecer!\n¡Queremos saber qué está ocurriendo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="So you would rather see all\nPokémon swallowed up by the nightmare?", french="Vous préférez donc voir tous\nles Pokémon avalés par ce cauchemar?", german="Dann wollt ihr lieber, dass alle\nPokémon von einem Albtraum verschluckt\nwerden?", italian="Quindi preferireste che tutti\ni Pokémon venissero imprigionati dall'incubo?", spanish="¿Así que preferís que esta\npesadilla acabe por engullir a todos\nlos Pokémon?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's not...[K] That's not what I\nwant...", french="Ce n'est pas...[K] ce que je veux\ndire...", german="Das ist...[K] Das ist nicht das, was\nich will...", italian="Non è...[K] Non è quello che\nvoglio...", spanish=" No...[K] Eso no es lo que quiero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's not...[K] That isn't what I\nwant...", french="Ce n'est pas...[K] ce que je veux\ndire...", german="Das ist...[K] Das ist nicht das, was\nich will...", italian="Non è...[K] Non è quello che\nvoglio...", spanish=" No...[K] Eso no es lo que quiero..."})
  else
  SkySceneKit.say({english="That's not...[K] That's not what I\nwant...", french="Ce n'est pas...[K] ce que je veux\ndire...", german="Das ist...[K] Das ist nicht das, was\nich will...", italian="Non è...[K] Non è quello che\nvoglio...", spanish=" No...[K] Eso no es lo que quiero..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]C-Cresselia[CR].[K] Is this really true?", french="[CS:N]C-Cresselia[CR].[K] Est-ce que c'est\nvrai?", german="[CS:N]C-Cresselia[CR].[K] Ist das wirklich\nwahr?", italian=" [CS:N]C-Cresselia[CR].[K] È proprio vero?", spanish="[CS:N]Cresselia[CR]... [K]¿Realmente es\ncierto?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]C-Cresselia[CR].[K] Is this really true?", french="[CS:N]C-Cresselia[CR].[K] Est-ce que c'est\nvrai?", german="[CS:N]C-Cresselia[CR].[K] Ist das wirklich\nwahr?", italian=" [CS:N]C-Cresselia[CR].[K] È proprio vero?", spanish="[CS:N]Cresselia[CR]... [K]¿Realmente es\ncierto?"})
  else
  SkySceneKit.say({english=" [CS:N]C-Cresselia[CR].[K] Is this really true?", french="[CS:N]C-Cresselia[CR].[K] Est-ce que c'est\nvrai?", german="[CS:N]C-Cresselia[CR].[K] Ist das wirklich\nwahr?", italian=" [CS:N]C-Cresselia[CR].[K] È proprio vero?", spanish="[CS:N]Cresselia[CR]... [K]¿Realmente es\ncierto?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" If we disappear...", french=" Si nous disparaissons...", german=" Wenn wir verschwänden...", italian=" Se scompariamo...", spanish=" Si desaparecemos..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" If we disappear...", french=" Si nous disparaissons...", german=" Wenn wir verschwänden...", italian=" Se scompariamo...", spanish=" Si desaparecemos..."})
  else
  SkySceneKit.say({english=" If we disappear...", french=" Si nous disparaissons...", german=" Wenn wir verschwänden...", italian=" Se scompariamo...", spanish=" Si desaparecemos..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Will the world...[K]really be saved?", french="... est-ce que le monde sera...[K]\nvraiment sauvé?", german="Würde die Welt...[K] wirklich\ngerettet werden?", italian="... il mondo[K] si salverà\ndavvero?", spanish=" Se salvará...[K] ¿el mundo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Will the world...[K]really be saved?", french="... est-ce que le monde sera...[K]\nvraiment sauvé?", german="Würde die Welt...[K] wirklich\ngerettet werden?", italian="... il mondo[K] si salverà\ndavvero?", spanish=" Se salvará...[K] ¿el mundo?"})
  else
  SkySceneKit.say({english=" Will the world...[K]really be saved?", french="... est-ce que le monde sera...[K]\nvraiment sauvé?", german="Würde die Welt...[K] wirklich\ngerettet werden?", italian="... il mondo[K] si salverà\ndavvero?", spanish=" Se salvará...[K] ¿el mundo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Yes. It will be saved.", french=" Oui. Il sera sauvé.", german=" Ja. Sie würde gerettet werden.", italian=" Sì. È così.", spanish=" Sí. Se salvará."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" For it is only your existence...", french="Parce que c'est uniquement\nvotre existence...", german=" Denn es ist nur eure Existenz...", italian="Perché è solo la\nvostra esistenza...", spanish="Puesto que es vuestra\nexistencia..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" that is driving the world to ruin!", french="... qui mène le monde\nà sa perte!", german="Nur sie lässt die Welt auf den\nAbgrund zutreiben!", italian=" ... a minacciarlo!", spanish=" ¡La que está acabando con él!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk...!", french=" Argh...!", german=" Uff!", italian=" Urk...!", spanish=" ¡Uf!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk...!", french=" Argh...!", german=" Uff!", italian=" Urk...!", spanish=" ¡Uf!"})
  else
  SkySceneKit.say({english=" Urk...!", french=" Argh...!", german=" Uff!", italian=" Urk...!", spanish=" ¡Uf!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_kureseria.Position; GROUND:MoveToPosition(npc_npc_kureseria, p.X+(0), p.Y+(8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="I'm very sorry that I must do\nthis...[K] Prepare to disappear!", french="Vous me voyez profondément\nnavrée de devoir faire ça...[K] Préparez-vous\nà disparaître!", german="Ich bedauere sehr, dass ich das\ntun muss...[K] Bereitet euch darauf vor,\nzu verschwinden!", italian="Mi spiace molto\ndoverlo fare, ma...[K] preparatevi a sparire!", spanish="Siento mucho tener que hacer\nesto...[K] ¡Pero os voy a volatilizar!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(0)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(3)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="It must be done![K] The world must\nbe saved!", french="Je n'ai pas le choix![K] Je dois\nsauver le monde!", german="Es muss getan werden![K] Die Welt\nmuss gerettet werden!", italian="Devo farlo![K] Devo salvare\nil mondo!", spanish="¡Debo hacerlo![K] ¡Tengo que salvar\nel mundo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(3)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaaah!", french=" Ouaaaah!", german=" Uaaaah!", italian=" Waaaah!", spanish=" ¡Aaaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaaah!", french=" Ouaaaah!", german=" Uaaaah!", italian=" Aaaaah!", spanish=" ¡Aaaaah!"})
  else
  SkySceneKit.say({english=" Waaaah!", french=" Ouaaaah!", german=" Uaaaah!", italian=" Aaaaah!", spanish=" ¡Aaaaah!"})
  end
  GAME:WaitFrames(30)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(3)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(5)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Heeeeeey!", french=" Hééééééé!", german=" Heeeeeey!", italian=" Ehiiiiiiii!", spanish=" ¡Oyeeee!"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Hello, [hero]?[K]\nAnd, [partner]?[K]\nWhere are you?", french="[hero]?[K]\n[partner]?[K]\nOù êtes-vous?", german="Hallo, [hero]?[K]\n[partner]?[K] Wo seid ihr?", italian="Ciao, [hero]?[K]\nE [partner]?[K]\nDove siete?", spanish="Hola, ¿[hero]?[K]\n¿Y, [partner]?[K]\n¿Dónde estáis?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Gah![K] Interrupted! And my work\nhere was nearly finished!", french="Gah![K] Une interruption! Alors que\nmon travail ici était presque fini!", german="Gah![K] Wir sind unterbrochen\nworden! Und dabei wäre mein Werk fast\nvollbracht gewesen!", italian="Aah![K] Un'interruzione! E\nce l'avevo quasi fatta!", spanish="¡Nooo![K] ¡Se ha interrumpido!\n¡Y casi había cumplido mi misión!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_kureseria.Position; GROUND:MoveToPosition(npc_npc_kureseria, p.X+(0), p.Y+(-16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="I was interrupted this time...[K]\nBut I will see to it that you two disappear!", french="On m'a interrompue pour cette\nfois...[K] Mais je tâcherai de vous faire\ndisparaître!", german="Ich wurde diesmal\nunterbrochen...[K] Aber ich werde dafür sorgen,\ndass ihr beiden verschwindet!", italian="Questa volta mi hanno\ninterrotta...[K] Ma mi assicurerò che voi\ndue spariate!", spanish="Esta vez no he podido...[K]\n¡Pero no os salvaréis la próxima vez!"})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Of course, if you wish to save\nthe world on your own...", french="Bien sûr, si vous voulez sauver\nle monde par vous-mêmes...", german="Wenn ihr die Welt natürlich\nselbst retten wollt...", italian="Certo, se desiderate salvare\nil mondo con le vostre forze...", spanish="Por supuesto, si decidís salvar\nel mundo por vuestra cuenta..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="You should consider making\nyourselves disappear first.", french="... vous devez avant tout\nenvisager votre propre disparition.", german="Dann solltet ihr euch mit dem\nGedanken anfreunden, euch selbst verschwinden\nzu lassen.", italian="... dovreste trovare il\ncoraggio di sparire.", spanish=" No os queda sino desaparecer."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Farewell.", french=" Adieu.", german=" Lebt wohl.", italian=" Addio.", spanish=" Adiós."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6922) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitSe
  GROUND:EntTurn(hero, Direction.Left)
  -- SetAnimation(72) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whew![K] Th-that was close...", french=" Pfiou![K] C'était moins une...", german=" Puh![K] D-das war knapp...", italian=" Fiuuu![K] C'è mancato poco...", spanish=" ¡Fiu![K] Ha faltado poco..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Whew![K] Th-that was close...", french=" Pfiou![K] C'était moins une...", german=" Puh![K] D-das war knapp...", italian=" Fiuuu![K] C'è mancato poco...", spanish=" ¡Fiu![K] Ha faltado poco..."})
  else
  SkySceneKit.say({english=" Whew![K] Th-that was close...", french=" Pfiou![K] C'était moins une...", german=" Puh![K] D-das war knapp...", italian=" Fiuuu![K] C'è mancato poco...", spanish=" ¡Fiu![K] Ha faltado poco..."})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Hey! So here you are!", french=" Ha! Vous voilà!", german=" Hey! Hier seid ihr also!", italian=" Ehi! Eccovi qui!", spanish=" ¡Por fin! ¡Aquí estáis!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(1)
  pcall(function() GAME:MoveCamera(228, 292, 60, false) end) -- performer/caméra
  local npc_npc_suriipu = SkySceneKit.spawn_npc("drowzee", 232, 408, Direction.Up, "NPC_SURIIPU")
  GROUND:MoveToPosition(npc_npc_suriipu, 228, 296, false, 2)
  GAME:WaitFrames(45)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]D-Drowzee[CR]!", french=" [CS:N]S-Soporifik[CR]!", german=" [CS:N]T-Traumato[CR]!", italian=" [CS:N]D-Drowzee[CR]!", spanish=" ¡[CS:N]Drowzee[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]D-Drowzee[CR]!", french=" [CS:N]S-Soporifik[CR]!", german=" [CS:N]T-Traumato[CR]!", italian=" [CS:N]D-Drowzee[CR]!", spanish=" ¡[CS:N]Drowzee[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]D-Drowzee[CR]!", french=" [CS:N]S-Soporifik[CR]!", german=" [CS:N]T-Traumato[CR]!", italian=" [CS:N]D-Drowzee[CR]!", spanish=" ¡[CS:N]Drowzee[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What are you doing here?", french=" Qu'est-ce que tu fais là?", german=" Was machst du hier?", italian=" Cosa ci fai qui?", spanish=" ¿Qué haces aquí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Why are you here?", french=" Qu'est-ce que tu fais là?", german=" Warum bist du hier?", italian=" Cosa ci fai qui?", spanish=" ¿Qué haces aquí?"})
  else
  SkySceneKit.say({english=" Why did you come?", french=" Qu'est-ce que tu fais là?", german=" Warum bist du gekommen?", italian=" Cosa ci fai qui?", spanish=" ¿Qué haces aquí?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="You were taking so long to come\nback. I got worried.", french="Vous mettiez du temps à\nrevenir. Je m'inquiétais.", german="Ihr wart so lange weg. Ich habe\nmir Sorgen gemacht.", italian="Ci stavate mettendo troppo\na tornare. Mi sono preoccupato.", spanish="Estabais tardando tanto en\nvolver que ya me estaba preocupando."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="I decided to be brave and came\nlooking for you.", french="J'ai décidé de prendre mon\ncourage à deux mains et de venir vous\nchercher.", german="Ich habe mich entschieden,\ntapfer zu sein und nach euch zu suchen.", italian="Ho deciso di farmi coraggio\ne di venire a cercarvi.", spanish="Decidí echarle agallas y venir\na buscaros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="There's something dangerous\nabout this place. We shouldn't stay here.", french="Cet endroit est dangereux.\nVous ne devriez pas rester ici.", german="Dieser Ort hat etwas\nGefährliches an sich. Wir sollten hier nicht\nbleiben.", italian="Questo posto sembra\npericoloso. Non dovremmo rimanere qui.", spanish="Hay algo peligroso por aquí.\nNo deberíamos quedarnos en este lugar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_suriipu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="Let's go back to the guild for\nthe time being.", french="Rentrons à la Guilde pour\nl'instant.", german="Gehen wir fürs Erste zurück\nzur Gilde.", italian="Per il momento, è meglio\ntornare alla Gilda.", spanish=" Volvamos al [CS:N]Pokégremio[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(90) end)
  -- GAP: se_Play(8195) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_G01P07A1_108) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(60)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SkyProg.set(29, 77) -- $SCENARIO_MAIN = scn[29,77] (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
