-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P14P01A/s01p1001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_P14P01A2) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(partner, 284, 432, false, 2)
  GROUND:MoveToPosition(hero, 316, 432, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! [CS:N]Teddiursa[CR] and [CS:N]Ursaring[CR]!", french=" Hé! [CS:N]Teddiursa[CR] et [CS:N]Ursaring[CR]!", german=" Hey! [CS:N]Teddiursa[CR] und [CS:N]Ursaring[CR]!", italian=" Ehi! [CS:N]Teddiursa[CR] e [CS:N]Ursaring[CR]!", spanish=" ¡Hola! ¡[CS:N]Teddiursa[CR] y [CS:N]Ursaring[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! [CS:N]Teddiursa[CR] and [CS:N]Ursaring[CR]!", french=" Hé! [CS:N]Teddiursa[CR] et [CS:N]Ursaring[CR]!", german=" Hey! [CS:N]Teddiursa[CR] und [CS:N]Ursaring[CR]!", italian=" Ehi! [CS:N]Teddiursa[CR] e [CS:N]Ursaring[CR]!", spanish=" ¡Hola! ¡[CS:N]Teddiursa[CR] y [CS:N]Ursaring[CR]!"})
  else
  SkySceneKit.say({english=" Hi! [CS:N]Teddiursa[CR] and [CS:N]Ursaring[CR]!", french=" Hé! [CS:N]Teddiursa[CR] et [CS:N]Ursaring[CR]!", german=" Hi! [CS:N]Teddiursa[CR] und [CS:N]Ursaring[CR]!", italian=" Ehi! [CS:N]Teddiursa[CR] e [CS:N]Ursaring[CR]!", spanish=" ¡Hola! ¡[CS:N]Teddiursa[CR] y [CS:N]Ursaring[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_ringuma = SkySceneKit.spawn_npc("ursaring", 328, 400, Direction.Left, "NPC_RINGUMA")
  GROUND:EntTurn(npc_npc_ringuma, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_himeguma = SkySceneKit.spawn_npc("teddiursa", 280, 400, Direction.Right, "NPC_HIMEGUMA")
  GROUND:EntTurn(npc_npc_himeguma, Direction.Down)
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Oh, it's you!", french=" Oh, c'est vous!", german=" Oh, ihr seid es!", italian=" Oh, siete voi!", spanish=" ¡Hombre, aquí estáis!"})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="What happened to you two?[K]\nI thought you two were tagging along right\nbehind us...", french="Que vous est-il arrivé\nà vous deux?[K]\nJe croyais que vous nous suiviez...", german="Was ist euch denn passiert?[K]\nIch dachte, ihr würdet direkt hinter uns\nherlaufen...", italian="Cosa vi è successo?[K]\nPensavamo che foste appena dietro di noi...", spanish="¿Qué os ha pasado?[K]\nPensé que nos seguíais..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Uh... Er, something came up.", french="Hum... euh, il y a eu comme\nun petit contretemps.", german="Ähm, öh, da ist etwas\ndazwischengekommen.", italian=" Eh... Ehm, è successa una cosa.", spanish="Tuvimos un pequeño\ncontratiempo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Uh... Something held us up.", french="Hum... euh, il y a eu comme\nun petit contretemps.", german=" Öh, wir wurden aufgehalten.", italian=" Eh... Ehm, è successa una cosa.", spanish="Tuvimos un pequeño\ncontratiempo."})
  else
  SkySceneKit.say({english="Uh... There was just...um...\nsomething came up.", french="Hum... euh, il y a eu comme\nun petit contretemps.", german="Äh, es gab da ein, ähem...\nEtwas kam dazwischen.", italian=" Eh... Ehm, è successa una cosa.", spanish="Tuvimos un pequeño\ncontratiempo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Anyway...[K]what's up?", french=" Alors...[K] du nouveau?", german=" Egal...[K] Was liegt an?", italian=" Ad ogni modo...[K] Cosa fate?", spanish=" Bueno, y...[K] ¿qué tal?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Anyway...[K]what's going on?", french=" Alors...[K] du nouveau?", german=" Egal...[K] Was steht an?", italian=" Ad ogni modo...[K] Cosa fate?", spanish=" Bueno, y...[K] ¿qué hacéis?"})
  else
  SkySceneKit.say({english=" Anyway...[K]what are you doing?", french=" Alors...[K] du nouveau?", german="Egal...[K] Was macht ihr denn\ngerade?", italian=" Ad ogni modo...[K] Cosa fate?", spanish=" Bueno, y...[K] ¿qué hacéis?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_ringuma, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="Well, see, there's a treasure\nbox here.", french="Regardez, il y a un Coffre au\nTrésor ici.", german="Nun, ähem, hier liegt eine\nSchatzbox.", italian=" Beh, vedete, qui c'è un forziere.", spanish=" ¡Mirad! El cofre de un tesoro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="There wasn't a treasure box\nhere before.", french=" Il ne s'y trouvait pas avant.", german="Hier war vorher keine\nSchatzbox.", italian=" Prima non c'era.", spanish=" Antes no estaba."})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="I want to open it, but I'm also\ngetting a creepy feeling from it.", french="Je voudrais l'ouvrir, mais\nj'ai un horrible pressentiment.", german="Ich möchte sie öffnen, aber\nandererseits habe ich ein mulmiges Gefühl\ndabei.", italian="Vorrei aprirlo, ma mi fa un po'\npaura.", spanish="Quiero abrirlo, pero me da mala\nespina."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_ringuma, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="You know, it'd be nasty if it's a\nbooby trap or something.", french="Ça pourrait mal se terminer\nsi jamais c'est un de ces pièges sournois.", german="Weißt du, es wäre übel, wenn\nda zum Beispiel eine Springfalle drin wäre.", italian="Sapete, potrebbe essere un\ntrabocchetto!", spanish="Podría ser una trampa o algo\nasí."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="So we've been debating whether\nwe should open it or leave it be.", french="Nous étions en train de\ndébattre pour savoir si nous devions\nl'ouvrir ou pas.", german="Also haben wir darüber\ndiskutiert, ob wir die Box öffnen oder es sein\nlassen sollten.", italian="Quindi stavamo discutendo se\naprirlo o meno.", spanish="Estábamos planteándonos si\nabrirlo o dejarlo ahí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Well then![K] We'll open it!", french="Puisque c'est comme ça...[K] on va\nl'ouvrir, nous!", german=" Also dann![K] Wir öffnen sie!", italian=" Bene![K] Lo apriremo noi!", spanish=" ¡Bueno![K] ¡Abrámoslo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Well then![K] We'll open it!", french="Puisque c'est comme ça...[K] on va\nl'ouvrir, nous!", german=" Also dann![K] Wir öffnen sie!", italian=" Bene![K] Lo apriremo noi!", spanish=" ¡Bueno![K] ¡Abrámoslo!"})
  else
  SkySceneKit.say({english=" Well then![K] We'll open it!", french="Puisque c'est comme ça...[K] on va\nl'ouvrir, nous!", german=" Also dann![K] Wir öffnen sie!", italian=" Bene![K] Lo apriremo noi!", spanish=" ¡Bueno![K] ¡Abrámoslo!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You see, we got sent here for\nthe guild's graduation exam.", french="C'est la Guilde qui nous envoie\nici dans le cadre de notre examen.", german="Wisst ihr, wir wurden hier für\nunsere Gildenabschlussprüfung hergeschickt.", italian="Sapete, ci hanno mandato qui\nper l'esame della Gilda.", spanish="Nos enviaron aquí para\nafrontar el gran reto del [CS:N]Pokégremio[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You see, we got sent here for\nthe guild's graduation exam.", french="C'est la Guilde qui nous envoie\nici dans le cadre de notre examen.", german="Wisst ihr, wir wurden hier für\nunsere Gildenabschlussprüfung hergeschickt.", italian="Sapete, ci hanno mandato qui\nper l'esame della Gilda.", spanish="Nos enviaron aquí para\nafrontar el gran reto del [CS:N]Pokégremio[CR]."})
  else
  SkySceneKit.say({english="You see, we were told to come\nhere for the guild's graduation exam.", french="C'est la Guilde qui nous envoie\nici dans le cadre de notre examen.", german="Wisst ihr, wir wurden hier für\nunsere Gildenabschlussprüfung hergeschickt.", italian="Sapete, ci hanno mandato qui\nper l'esame della Gilda.", spanish="Nos enviaron aquí para\nafrontar el gran reto del [CS:N]Pokégremio[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="They told us to bring back the\ntreasure from here.", french="Ils nous ont dit de rapporter\nun trésor d'ici.", german="Uns wurde gesagt, wir sollten\nmit dem Schatz von hier zurückkehren.", italian="Ci hanno detto di riportare il\ntesoro che si trova qui.", spanish="Nos dijeron que debíamos\nregresar con el tesoro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We were told to bring back the\ntreasure from here.", french="Ils nous ont dit de rapporter\nun trésor d'ici.", german="Uns wurde gesagt, wir sollten\nmit dem Schatz von hier zurückkehren.", italian="Ci hanno detto di riportare il\ntesoro che si trova qui.", spanish="Nos dijeron que debíamos\nregresar con el tesoro."})
  else
  SkySceneKit.say({english="They said to bring back the\ntreasure from here.", french="Ils nous ont dit de rapporter\nun trésor d'ici.", german="Wir wurden angewiesen, von\nhier mit dem Schatz zurückzukehren.", italian="Ci hanno detto di riportare il\ntesoro che si trova qui.", spanish="Nos dijeron que debíamos\nregresar con el tesoro."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="That's it![K] That box must have\nsomething to do with your exam.", french="C'est ça![K] Ce coffre doit avoir\nun rapport avec votre examen.", german="Das ist es![K] Diese Box muss\nirgendetwas mit eurer Prüfung zu tun haben.", italian="Ho capito![K] Questo forziere\ndeve avere qualcosa a che fare con il\nvostro esame.", spanish="¡Claro![K] Ese cofre seguro que\ntiene que ver con el reto."})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" You guys should open it.", french="C'est vous qui devriez l'ouvrir,\nalors.", german=" Ihr solltet sie öffnen, Leute.", italian=" Dovreste aprirlo voi.", spanish=" Deberíais abrirlo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Can you check this,\n[hero]?", french="Tu veux bien d'abord vérifier,\n[hero]?", german="Kannst du das überprüfen,\n[hero]?", italian="Puoi occupartene tu,\n[hero]?", spanish="¿Haces los honores,\n[hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Can I get you to do this,\n[hero]?", french="Tu veux bien d'abord vérifier,\n[hero]?", german="Kann ich dich dazu überreden,\ndas zu tun, [hero]?", italian="Puoi occupartene tu,\n[hero]?", spanish="¿Puedes encargarte tú,\n[hero]?"})
  else
  SkySceneKit.say({english="Can you check this,\n[hero]?", french="Tu veux bien d'abord vérifier,\n[hero]?", german="Kannst du das überprüfen,\n[hero]?", italian="Puoi occupartene tu,\n[hero]?", spanish=" ¿Lo haces tú, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 300, 412, false, 1)
  GAME:WaitFrames(5)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-8), p.Y+(0), false, 1) end
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(npc_npc_himeguma, Direction.DownRight)
  GROUND:EntTurn(npc_npc_ringuma, Direction.DownLeft)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:FadeOutBGM(160) end)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I think it probably would be OK...)", french="(Je pense que ça vaut mieux...)", german="(Ich denke, das wäre schon okay...)", italian="(Probabilmente non succederà niente...)", spanish="(No creo que haya ningún problema.)"})
  else
  SkySceneKit.say({english="(I think it probably would be OK...)", french="(Je pense que ça vaut mieux...)", german="(Ich denke, das wäre schon okay...)", italian="(Probabilmente non succederà niente...)", spanish="(No creo que haya ningún problema.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But you never know. It could be a trap.)", french="(On ne sait jamais. C'est peut-être un piège.)", german="(Aber man weiß nie. Es könnte auch eine Falle\nsein.)", italian="(Ma non si sa mai. Potrebbe essere\nuna trappola.)", spanish="(Pero nunca se sabe. Podría ser una trampa.)"})
  else
  SkySceneKit.say({english="(But you never know. It could be a trap.)", french="(On ne sait jamais. C'est peut-être un piège.)", german="(Aber man weiß nie. Es könnte auch eine Falle\nsein.)", italian="(Ma non si sa mai. Potrebbe essere\nuna trappola.)", spanish="(Pero nunca se sabe. Podría ser una trampa.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(If I can get the Dimensional Scream\nto activate...)", french="(Si j'arrive à déclencher le Cri\nDimensionnel...)", german="(Wenn ich nur irgendwie den Dimensionalen\nSchrei aktivieren könnte...)", italian="(Proverò ad attivare lo Squarcio\nDimensionale.)", spanish="(Si consigo activar la Percepción de Cronos...)"})
  else
  SkySceneKit.say({english="(If I can get the Dimensional Scream\nto activate...)", french="(Si j'arrive à déclencher le Cri\nDimensionnel...)", german="(Wenn ich nur irgendwie den Dimensionalen\nSchrei aktivieren könnte...)", italian="(Proverò ad attivare lo Squarcio\nDimensionale.)", spanish="(Si consigo activar la Percepción de Cronos...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That may give me a better idea if this\ntreasure box is safe or not.)", french="(Ça m'indiquera si le coffre est dangereux\nou pas.)", german="(Dann hätte ich eine bessere Vorstellung\ndavon, ob diese Box sicher ist oder nicht.)", italian="(Forse così capirò se è sicuro aprire il\nforziere.)", spanish="(Podría saber si es peligroso o no.)"})
  else
  SkySceneKit.say({english="(That may give me a better idea if this\ntreasure box is safe or not.)", french="(Ça m'indiquera si le coffre est dangereux\nou pas.)", german="(Dann hätte ich eine bessere Vorstellung\ndavon, ob diese Box sicher ist oder nicht.)", italian="(Forse così capirò se è sicuro aprire il\nforziere.)", spanish="(Podría saber si es peligroso o no.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-4), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN][hero] touched the\n[CN]treasure box.", french="[CN][hero] touche\n[CN]le Coffre au Trésor.", german="[CN][hero] berührt\n[CN]die Schatzbox.", italian="[CN][hero] tocca\n[CN]il forziere.", spanish="[CN]Entonces [hero] tocó\n[CN]el cofre del tesoro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The dizziness...)", french="(Les vertiges...)", german="(Das Schwindelgefühl...)", italian="(Il capogiro...)", spanish="(El mareo...)"})
  else
  SkySceneKit.say({english="(The dizziness...)", french="(Les vertiges...)", german="(Das Schwindelgefühl...)", italian="(Il capogiro...)", spanish="(El mareo...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The dizziness is starting...)", french="(Les vertiges commencent...)", german="(Das Schwindelgefühl setzt ein.)", italian="(Il capogiro sta iniziando...)", spanish="(Está comenzando...)"})
  else
  SkySceneKit.say({english="(The dizziness is starting...)", french="(Les vertiges commencent...)", german="(Das Schwindelgefühl setzt ein.)", italian="(Il capogiro sta iniziando...)", spanish="(Está comenzando...)"})
  end
  -- message_Close
  GAME:FadeOut(false, 5)
  SkySceneKit.cleanup_npcs()
end
