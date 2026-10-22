-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D39P21A/s21p1501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urggh...[K] We blew it...", french="Argh...[K] On a manqué notre\ncoup...", german=" Urks...[K] Das ging daneben...", italian="Urggh...[K] Non ce l'abbiamo\nfatta...", spanish=" Uf...[K] Fracasamos..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urggh...[K] That was a mess...", french="Argh...[K] On a manqué notre\ncoup...", german=" Urks...[K] Das war gar nicht gut...", italian="Urggh...[K] Non ce l'abbiamo\nfatta...", spanish=" Uf...[K] Fracasamos..."})
  else
  SkySceneKit.say({english=" Urggh...[K] That ended poorly...", french="Argh...[K] On a manqué notre\ncoup...", german="Urks...[K] Das ist schlecht\nausgegangen...", italian=" Urggh...[K] È andata male...", spanish=" Uf...[K] No ha acabado nada bien..."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D39P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Sealed Ruin.ogg", true) end)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk![K] This is rough...", french="Argh![K] Ça commence\nà se corser...", german=" Uff![K] Ganz schön hart...", italian=" Uh![K] È davvero dura...", spanish="Está resultando duro...[K] Más de\nlo que pensaba..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk![K] This is so hard...", french="Argh![K] Ça commence\nà se corser...", german=" Uff![K] Das ist so schwer...", italian=" Uh![K] È così difficile...", spanish="Está resultando duro...[K] Más de\nlo que pensaba..."})
  else
  SkySceneKit.say({english=" Urk![K] This is difficult...", french="Argh![K] Ça commence\nà se corser...", german=" Uff![K] Sehr schwierig...", italian=" Uh![K] È difficile...", spanish="Está resultando duro...[K] Más de\nlo que pensaba..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But we have to keep struggling\nto the very end...", french="... mais nous devons faire\nfront... jusqu'au bout...", german="Aber wir müssen bis zum\nbitteren Ende kämpfen...", italian="Ma dobbiamo mettercela tutta\nfino alla fine.", spanish="Pero tenemos que luchar hasta\nel final..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But we have no choice. We have\nto keep struggling to the end.", french="... mais nous devons faire\nfront... jusqu'au bout...", german="Aber uns bleibt keine Wahl. Wir\nmüssen bis zum Ende kämpfen.", italian="Ma dobbiamo mettercela tutta\nfino alla fine.", spanish="Pero no tenemos elección. Hay\nque luchar hasta el final."})
  else
  SkySceneKit.say({english="But we have no other choice.\nWe have to keep struggling to the end.", french="... mais nous devons faire\nfront... jusqu'au bout...", german="Aber uns bleibt keine andere\nWahl. Wir müssen bis zum Ende kämpfen.", italian="Ma dobbiamo mettercela tutta\nfino alla fine.", spanish="Pero no tenemos elección. Hay\nque luchar hasta el final."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to force [CS:N]Palkia[CR] to tell\nus what we need to know!", french="De gré ou de force, il faut que\n[CS:N]Palkia[CR] nous dise ce qu'on veut savoir!", german="Wir müssen [CS:N]Palkia[CR] zwingen,\nuns zu sagen, was wir wissen müssen!", italian="Dobbiamo costringere [CS:N]Palkia[CR] a\nrivelarci ciò che abbiamo bisogno di sapere!", spanish="¡Hay que obligar a [CS:N]Palkia[CR]\na contarnos lo que necesitamos saber!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to force [CS:N]Palkia[CR] to tell\nus what we need to know!", french="De gré ou de force, il faut que\n[CS:N]Palkia[CR] nous dise ce qu'on veut savoir!", german="Wir müssen [CS:N]Palkia[CR] zwingen,\nuns zu sagen, was wir wissen müssen!", italian="Dobbiamo costringere [CS:N]Palkia[CR] a\nrivelarci ciò che abbiamo bisogno di sapere!", spanish="¡Hay que obligar a [CS:N]Palkia[CR]\na contarnos lo que necesitamos saber!"})
  else
  SkySceneKit.say({english="We have to force [CS:N]Palkia[CR] to tell\nus what we need to know!", french="De gré ou de force, il faut que\n[CS:N]Palkia[CR] nous dise ce qu'on veut savoir!", german="Wir müssen [CS:N]Palkia[CR] zwingen,\nuns zu sagen, was wir wissen müssen!", italian="Dobbiamo costringere [CS:N]Palkia[CR] a\nrivelarci ciò che abbiamo bisogno di sapere!", spanish="¡Hay que obligar a [CS:N]Palkia[CR]\na contarnos lo que necesitamos saber!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We really have to find a way\nout of here!", french="Il faut qu'on trouve la sortie!\nCoûte que coûte!", german="Wir müssen wirklich einen Weg\nhier heraus finden!", italian="Dobbiamo davvero trovare un\nmodo per uscire da qui!", spanish=" ¡Hay que encontrar la salida!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We really have to find a way\nout of here!", french="Il faut qu'on trouve la sortie!\nCoûte que coûte!", german="Wir müssen wirklich einen Weg\nhier heraus finden!", italian="Dobbiamo davvero trovare un\nmodo per uscire da qui!", spanish=" ¡Hay que encontrar la salida!"})
  else
  SkySceneKit.say({english="We really have to find a way\nout of here!", french="Il faut qu'on trouve la sortie!\nCoûte que coûte!", german="Wir müssen wirklich einen Weg\nhier heraus finden!", italian="Dobbiamo davvero trovare un\nmodo per uscire da qui!", spanish=" ¡Hay que encontrar la salida!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's roll, [hero]!", french=" En route, [hero]!", german=" Legen wir los, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Vamos allá, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go, [hero]!", french=" En route, [hero]!", german=" Legen wir los, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Vamos allá, [hero]!"})
  else
  SkySceneKit.say({english=" Let's go, [hero]!", french=" En route, [hero]!", german=" Legen wir los, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Vamos allá, [hero]!"})
  end
  -- message_Close
end
