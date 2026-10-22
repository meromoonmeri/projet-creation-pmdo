-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P01B/m21a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetBanner2(LEVEL_V01P08B, 0, 128, 156, 17) [bannière 2e écran NDS: information dupliquée du menu, hors canvas unique - documenté]
  GAME:FadeIn(45)
  GAME:WaitFrames(160)
  GAME:FadeOut(false, 45)
  GAME:WaitFrames(15)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[212] = 1 -- dungeon_mode(212) = DMODE_OPEN (ROM)
  SkyProg.set(22, 1) -- $SCENARIO_MAIN = scn[22,1] (ROM)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P01A) [décor sub chargé: Sub_v02p01a]
  -- back_SetGround(LEVEL_G01P01B) [neutre/état moteur]
  -- supervision_Acting(11) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(9) [anim idle native]
  -- GAP: BGM BGM_FIRE_CRACKLING_LOUDER non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v02p01a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(90)
  pcall(function() GAME:MoveCamera(240, 196, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Here we are, [hero].\n[CS:N]Wigglytuff[CR]'s Guild.", french="Nous y voilà, [hero].\nLa Guilde de [CS:N]Grodoudou[CR].", german="Da wären wir, [hero].\nDie [CS:N]Knuddeluff-Gilde[CR].", italian="Eccoci, [hero]. La Gilda di\n[CS:N]Wigglytuff[CR].", spanish="Aquí estamos, [hero].\nDe vuelta en el [CS:N]Pokégremio de Exploradores[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Here we are, [hero].\n[CS:N]Wigglytuff[CR]'s Guild.", french="Nous y voilà, [hero].\nLa Guilde de [CS:N]Grodoudou[CR].", german="Da wären wir, [hero].\nDie [CS:N]Knuddeluff-Gilde[CR].", italian="Eccoci, [hero]. La Gilda di\n[CS:N]Wigglytuff[CR].", spanish="Aquí estamos, [hero].\nDe vuelta en el [CS:N]Pokégremio de Exploradores[CR]."})
  else
  SkySceneKit.say({english="Here we are, [hero].\n[CS:N]Wigglytuff[CR]'s Guild.", french="Nous y voilà, [hero].\nLa Guilde de [CS:N]Grodoudou[CR].", german="Da wären wir, [hero].\nDie [CS:N]Knuddeluff-Gilde[CR].", italian="Eccoci, [hero]. La Gilda di\n[CS:N]Wigglytuff[CR].", spanish="Aquí estamos, [hero].\nDe vuelta en el [CS:N]Pokégremio de Exploradores[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It feels like we've been gone\na long time.", french="J'ai l'impression que ça fait\ndes années...", german="Es fühlt sich an, als wären wir\nlange weg gewesen.", italian="Mi sembra che sia passato così\ntanto tempo...", spanish="Me siento como si hubiéramos\npasado una eternidad fuera."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It feels as if we were gone\na long time.", french="J'ai l'impression que ça fait\ndes années...", german="Es fühlt sich an, als wären wir\nlange weg gewesen.", italian="Mi sembra sia passato un sacco\ndi tempo.", spanish="Me siento como si hubiéramos\npasado una eternidad fuera."})
  else
  SkySceneKit.say({english="It feels like we haven't been\nhere in a long time.", french="J'ai l'impression que ça fait\ndes années...", german="Es fühlt sich an, als wären wir\nlange weg gewesen.", italian="Mi sembra che sia passato così\ntanto tempo...", spanish="Me siento como si hubiéramos\nestado muchísimo tiempo fuera."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But...", french=" Et pourtant...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But...", french=" Et pourtant...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  else
  SkySceneKit.say({english=" But...", french=" Et pourtant...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  end
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Now that we're here, it's kind of\nhard to go in.", french="... maintenant qu'on est là, c'est\ndifficile de se décider à entrer.", german="Jetzt, da wir hier sind, ist es\nirgendwie schwer, da hineinzugehen.", italian="Ora che siamo qui, non è così\nfacile entrare.", spanish="Ahora que estamos aquí, casi\nme cuesta entrar."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Now that we're here, it's kind of\nawkward to go in.", french="... maintenant qu'on est là, c'est\ndifficile de se décider à entrer.", german="Jetzt, da wir hier sind, ist es\nirgendwie schwer, da hineinzugehen.", italian="Ora che siamo qui, non è così\nfacile entrare.", spanish="Ahora que estamos aquí, me\nresulta un poco embarazoso entrar."})
  else
  SkySceneKit.say({english="Now that we're here, it feels\nkind of awkward to go in.", french="... maintenant qu'on est là, c'est\ndifficile de se décider à entrer.", german="Jetzt, da wir hier sind, ist es\nirgendwie schwer, da hineinzugehen.", italian="Ora che siamo qui, faccio fatica\na entrare.", spanish="Ahora que estamos aquí, me\nsiento un tanto rara."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You know, how we suddenly\ndisappeared and all...", french="C'est vrai, on a disparu tout\nd'un coup et tout ça...", german="Weißt du, wie wir plötzlich\nverschwunden sind und so...", italian="Sai, siamo spariti così\nall'improvviso...", spanish="Al fin y al cabo, nos esfumamos\ndelante de todo el mundo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="After all, we were suddenly\ntaken away in front of everyone...", french="C'est vrai, on a disparu tout\nd'un coup et tout ça...", german="Immerhin wurden wir plötzlich\nallen entrissen, die zugeschaut haben...", italian="Del resto, siamo spariti\nall'improvviso davanti a tutti...", spanish="Al fin y al cabo, nos esfumamos\ndelante de todo el mundo..."})
  else
  SkySceneKit.say({english="After all, we did vanish in\nfront of everyone in a mysterious way...", french="C'est vrai, on a disparu tout\nd'un coup et tout ça...", german="Immerhin sind wir vor\njedermanns Augen auf mysteriöse Weise\nverschwunden...", italian="Del resto, ci hanno\nmisteriosamente trascinato via davanti a\ntutti...", spanish="Al fin y al cabo, nos esfumamos\ndelante de todo el mundo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It'd be kind of strange to just\nwalk in and say, \"Hi, we're home!\"", french="Ça ferait bizarre d'entrer sans\ncrier gare en disant: \"Salut, nous revoilà!\"", german="Es wäre etwas seltsam, einfach\nso zurückzukommen und Hallo zu sagen.", italian="Sarebbe un po' strano entrare\ne dire: \"Ciao, siamo a casa!\"", spanish="Resultaría muy raro entrar por\nlas buenas y decir: \"Hola, ¡aquí estamos!\"."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It would be sort of strange to\nsuddenly show up.", french="Ça ferait bizarre d'entrer sans\ncrier gare en disant: \"Salut, nous revoilà!\"", german="Es wäre irgendwie seltsam,\neinfach so aufzukreuzen.", italian="È strano farsi rivedere così\nall'improvviso.", spanish="Resultaría muy raro entrar por\nlas buenas y decir: \"Hola, ¡aquí estamos!\"."})
  else
  SkySceneKit.say({english="It would be sort of awkward,\neven embarrassing, to walk in out of the blue!", french="Ça ferait bizarre d'entrer sans\ncrier gare en disant: \"Salut, nous revoilà!\"", german="Es wäre schon etwas komisch,\nund vielleicht sogar peinlich, aus heiterem\nHimmel wieder aufzukreuzen.", italian="È un po' difficile, e anche\nimbarazzante, entrare come se niente fosse.", spanish="Resultaría muy raro entrar por\nlas buenas y decir: \"Hola, ¡aquí estamos!\"."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="No.[K] We can't be feeling\nembarrassed now.", french="Non.[K] Ce n'est pas le moment\nde jouer les timides.", german="Nein.[K] Wir dürfen uns jetzt nicht\nso anstellen.", italian="No.[K] Non dobbiamo farci\nprendere dall'imbarazzo proprio adesso.", spanish="No.[K] No es momento para\nandar avergonzándose."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="No.[K] We can't be acting all\nbashful now.", french="Non.[K] Ce n'est pas le moment\nde jouer les timides.", german="Nein.[K] Wir sollten uns jetzt nicht\nso anstellen.", italian="No.[K] Non possiamo fare i timidi\nproprio adesso.", spanish="No.[K] No es momento para\nandar avergonzándose."})
  else
  SkySceneKit.say({english="No.[K] We can't go around acting\nembarrassed now.", french="Non.[K] Ce n'est pas le moment\nde jouer les timides.", german="Nein.[K] Wir können uns jetzt nicht\nso anstellen.", italian="No.[K] Non dobbiamo farci\nprendere dall'imbarazzo proprio adesso.", spanish="No.[K] No es momento para\nandar avergonzándose."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We've got to see everyone and\ntell them the truth.", french="On doit aller les voir pour\nleur dire la vérité.", german="Wir müssen uns mit allen\ntreffen und ihnen die Wahrheit erzählen.", italian="Dobbiamo vedere tutti gli altri e\nraccontare la verità.", spanish=" Tenemos que hablar con ellos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to see everyone and\ntell them the truth.", french="On doit aller les voir pour\nleur dire la vérité.", german="Wir müssen uns mit allen\ntreffen und ihnen die Wahrheit erzählen.", italian="Dobbiamo vedere tutti gli altri e\nraccontare la verità.", spanish=" Tenemos que hablar con ellos."})
  else
  SkySceneKit.say({english="We have to see everyone and\ntell them the truth.", french="On doit aller les voir pour\nleur dire la vérité.", german="Wir müssen uns mit allen\ntreffen und ihnen die Wahrheit erzählen.", italian="Dobbiamo vedere tutti gli altri e\nraccontare la verità.", spanish=" Tenemos que hablar con ellos."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  pcall(function() SOUND:FadeOutBGM(180) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right.", french=" D'accord.", german=" Alles klar.", italian=" Va bene.", spanish=" De acuerdo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK.", french=" D'accord.", german=" Okay.", italian=" Ok.", spanish=" De acuerdo."})
  else
  SkySceneKit.say({english=" OK.", french=" D'accord.", german=" Okay.", italian=" Ok.", spanish=" De acuerdo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'll stand above the sentry post.", french="Je vais me placer sur la grille\ndu poste de garde.", german="Ich stelle mich über den\nWachposten.", italian=" Mi metto sopra la grata.", spanish="Voy a ponerme sobre la reja del\npuesto de vigía."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I'll stand above the sentry post.", french="Je vais me placer sur la grille\ndu poste de garde.", german="Ich stelle mich über den\nWachposten.", italian=" Mi metto sopra la grata.", spanish="Voy a ponerme sobre la reja del\npuesto de vigía."})
  else
  SkySceneKit.say({english=" I'll stand above the sentry post.", french="Je vais me placer sur la grille\ndu poste de garde.", german="Ich stelle mich über den\nWachposten.", italian=" Mi metto sopra la grata.", spanish="Voy a ponerme sobre la reja del\npuesto de vigía."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 240, 176, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 200, 168, Direction.Down, "NPC_DIGUDA")
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end) -- message_SetActor(ACTOR_NPC_DIGUDA)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Pokémon detected![K]\nPokémon detected!", french="Pokémon détecté![K]\nPokémon détecté!", german="Pokémon entdeckt![K] Pokémon\nentdeckt!", italian="Pokémon in arrivo![K] Pokémon in\narrivo!", spanish="¡Pokémon detectado![K]\n¡Pokémon detectado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 240, 152, Direction.Down, "NPC_DOGOOMU")
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end) -- message_SetActor(ACTOR_NPC_DOGOOMU)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Whose footprint?[K]\nWhose footprint?", french="Identification empreinte...[K]\nIdentification empreinte...", german="Wessen Fußabdruck?[K]\nWessen Fußabdruck?", italian="A chi corrisponde la forma della\nzampa?[K] A chi corrisponde la forma della\nzampa?", spanish="¿De quién es la huella?[K]\n¿De quién es la huella?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end) -- message_SetActor(ACTOR_NPC_DIGUDA)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" The footprint belongs to...", french=" L'empreinte appartient à...", german=" Der Fußabdruck ist von...", italian=" È la zampa di...", spanish=" La huella es de..."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" The f-f-footprint belongs to...", french=" Euh... l'empreinte appartient à...", german=" Der F-f-fußabdruck ist von...", italian=" È la z-z-zampa di...", spanish=" La huella... La huella es de..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end) -- message_SetActor(ACTOR_NPC_DOGOOMU)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="What's wrong, [CS:N]Diglett[CR]?![K]\nRespond! Respond!", french="Il y a un problème,\n[CS:N]Taupiqueur[CR]?![K] Réponds! Mais réponds!", german="Stimmt etwas nicht, [CS:N]Digda[CR]?[K]\nAntworte! Antworte!", italian="Cosa c'è che non va, [CS:N]Diglett[CR]?![K]\nRispondi! Rispondi!", spanish="¡¿Qué pasa, [CS:N]Diglett[CR]?![K]\n¡Responde! ¡Responde!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6662) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end) -- message_SetActor(ACTOR_NPC_DOGOOMU)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" What...?[K] HEY, [CS:N]Diglett[CR]!", french=" Que...?[K] EH, [CS:N]Taupiqueur[CR]!", german=" Was...[K] HEY, [CS:N]Digda[CR]!", italian=" Cosa...?[K] EHI, [CS:N]Diglett[CR]!", spanish=" ¿Qué...?[K] ¡Oye, [CS:N]Diglett[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Where do you think you're\nburrowing off to?", french="Jusqu'où est-ce que tu comptes\nCREUSER comme ça?", german=" Wohin verkriechst du dich denn?", italian="A cosa pensi che serva la fossa\nin cui ti trovi?", spanish="¿Estás abandonando el puesto de\nvigía?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end) -- message_SetActor(ACTOR_NPC_DIGUDA)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" That...[K] That footprint...", french=" Cette...[K] cette empreinte...", german=" Dieser...[K] Dieser Fußabdruck...", italian=" Quella...[K] zampa...", spanish=" Esa...[K] Esa huella..."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" It's [partner]!", french=" ... c'est celle de [partner]!", german=" Es ist [partner]!", italian=" È [partner]!", spanish=" ¡Es de [partner]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 240, 152, Direction.Down, "NPC_BIPPA")
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end) -- message_SetActor(ACTOR_NPC_BIPPA)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" What...?", french=" Heiiin...?", german=" Was...", italian=" Cosa...?", spanish=" ¿Qué...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 240, 152, Direction.Down, "NPC_KIMAWARI")
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end) -- message_SetActor(ACTOR_NPC_KIMAWARI)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Wha...?", french=" Qu...?", german=" Wa...", italian=" Co...?", spanish=" ¿Qué...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: WHAT?!", french="[CS:N]Tous[CR]: QUOI?!", german="[CS:N]Alle[CR]: WAS?!?", italian="[CS:N]Tutti[CR]: COSA?!", spanish="[CS:N]Todos[CR]: ¡¿QUÉ?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(1) [neutre/état moteur]
  -- GAP: se_Play(6414) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(15)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  GROUND:EntTurn(partner, Direction.UpLeft)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:EntTurn(hero, Direction.UpLeft)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_diguda, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" It is [partner]!", french=" C'est [partner]!", german=" Es ist [partner]!", italian=" È [partner]!", spanish=" ¡Es [partner]!"})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" And [hero] too!", french=" Avec [hero]!", german=" Und [hero] ist auch da!", italian=" E c'è anche [hero]!", spanish=" ¡Y [hero]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Diglett[CR]![K] Long time no see!", french="[CS:N]Taupiqueur[CR]![K] Ça faisait\nlongtemps!", german=" [CS:N]Digda[CR]![K] Lange nicht gesehen!", italian="[CS:N]Diglett[CR]![K] Non ci si vede da\nun po', eh?!", spanish=" ¡[CS:N]Diglett[CR]![K] ¡Cuánto tiempo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Diglett[CR]![K] Long time no see!", french="[CS:N]Taupiqueur[CR]![K] Ça faisait\nlongtemps!", german=" [CS:N]Digda[CR]![K] Lange nicht gesehen!", italian="[CS:N]Diglett[CR]![K] Da quanto tempo non\nci vediamo!", spanish=" ¡[CS:N]Diglett[CR]![K] ¡Cuánto tiempo!"})
  else
  SkySceneKit.say({english=" [CS:N]Diglett[CR]![K] Long time no see!", french="[CS:N]Taupiqueur[CR]![K] Ça faisait\nlongtemps!", german=" [CS:N]Digda[CR]![K] Lange nicht gesehen!", italian="[CS:N]Diglett[CR]![K] Da quanto tempo non\nci vediamo!", spanish=" ¡[CS:N]Diglett[CR]![K] ¡Cuánto tiempo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5131) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa! What is that?", french=" Ouah! Qu'est-ce que c'est?", german=" Holla! Was ist das denn?", italian=" Aaah! Cos'è stato?", spanish=" ¡Vaya! ¿Qué es eso?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah! What is that?!", french=" Ouah! Qu'est-ce que c'est?", german=" Uaah! Was ist das?!?", italian=" Aaah! Cos'è stato?!", spanish=" ¡Vaya! ¿Qué es eso?"})
  else
  SkySceneKit.say({english=" Waah! What is that?!", french=" Ouah! Qu'est-ce que c'est?", german=" Uaah! Was ist das?!?", italian=" Aaah! Cos'è stato?!", spanish=" ¡Vaya! ¿Qué es eso?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- se_Stop(5131) [SE one-shot PMDO déjà terminé: arrêt sans objet, canal SE V2]
  -- GAP: se_Play(6408) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_G01P01A3_95) [routine d'objet NDS non simulée - documenté]
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(5)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(hero, 256, 204, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  GAME:WaitFrames(15)
  -- GAP: se_Play(6916) — id SE NDS sans portage PMDO identifié
  GROUND:MoveToPosition(npc_npc_dogoomu, 240, 188, false, 2)
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(partner, 224, 204, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- supervision_Acting(3) [neutre/état moteur]
  -- ResetHitAttribute(31) [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_bippa, 240, 172, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 276, 204, false, 2)
  -- supervision_Acting(4) [neutre/état moteur]
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 240, 152, Direction.Down, "NPC_CHIRIIN")
  -- ResetHitAttribute(31) [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_chiriin, 240, 172, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 204, 204, false, 2)
  GROUND:EntTurn(npc_npc_bippa, Direction.Left)
  -- supervision_Acting(5) [neutre/état moteur]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 240, 152, Direction.Down, "NPC_HEIGANI")
  -- ResetHitAttribute(31) [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_heigani, 240, 172, false, 2)
  GROUND:MoveToPosition(npc_npc_heigani, 264, 188, false, 2)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Right)
  -- supervision_Acting(6) [neutre/état moteur]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 240, 152, Direction.Down, "NPC_GUREGGURU")
  -- ResetHitAttribute(31) [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_guregguru, 240, 172, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 216, 188, false, 2)
  GROUND:EntTurn(npc_npc_heigani, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownRight)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! It's true!", french=" Eh dis donc! C'est vrai!", german=" Hey, hey! Es stimmt!", italian=" Ehi, ehi! È vero!", spanish=" ¡Oye, oye! ¡Es verdad!"})
  -- supervision_Acting(7) [neutre/état moteur]
  -- GAP: se_Play(6414) — id SE NDS sans portage PMDO identifié
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 280, 168, Direction.Down, "NPC_DAGUTORIO")
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.DownLeft)
  -- SetAnimation(4) [anim idle native]
  -- supervision_Acting(8) [neutre/état moteur]
  -- ResetHitAttribute(31) [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_kimawari, 256, 172, false, 2)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Down)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Oh my gosh! It really is\n[hero] and [partner]!", french="Ben mince alors! C'est vraiment\n[hero] et [partner]!", german="Auweia! Es sind wirklich\n[hero] und [partner]!", italian="Shock! Sono davvero\n[hero] e [partner]!", spanish="¡No me lo puedo creer!\n¡Realmente son [hero] y [partner]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" You're both ALIVE!", french=" Vous êtes EN VIE!", german=" Ihr beide LEBT!", italian=" Siete ancora in VITA!", spanish=" ¡Seguís con vida!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" We worried so much about you!", french=" On était si inquiets pour vous!", german="Wir haben uns solche Sorgen um\neuch gemacht!", italian="Eravamo così preoccupati per\nvoi!", spanish=" ¡Estábamos muy preocupados!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_bippa, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" I...I...[K]I was...[K]by golly!", french=" Je...[K] j'étais...[K] Sapristi!", german="Ich... Ich...[K] Ich bin...[K]\nDonnerwetter!", italian=" Io... io...[K] io ero...[K] ohibò!", spanish=" Yo...[K] Yo lo estaba...[K] ¡Y mucho!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(15)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" E-everyone...[K] We're home...", french="Sa... salut tout le monde...[K]\nNous revoilà...", german=" L-leute...[K] Wir sind zu Hause...", italian=" C-Ciao a tutti...[K] Siamo a casa...", spanish=" Al fin...[K] estamos en casa..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" E-everyone...[K] We're home...", french="Sa... salut tout le monde...[K]\nNous revoilà...", german=" L-leute...[K] Wir sind zu Hause...", italian=" C-Ciao a tutti...[K] Siamo a casa...", spanish=" Al fin...[K] estamos en casa..."})
  else
  SkySceneKit.say({english=" E-everyone...[K] We're home...", french="Sa... salut tout le monde...[K]\nNous revoilà...", german=" L-leute...[K] Wir sind zu Hause...", italian=" C-Ciao a tutti...[K] Siamo a casa...", spanish=" Al fin...[K] estamos en casa..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  -- supervision_Acting(9) [neutre/état moteur]
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 240, 152, Direction.Down, "NPC_PERAPPU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  GAME:WaitFrames(60)
  GROUND:MoveToPosition(npc_npc_kimawari, 288, 188, false, 2)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Left)
  GROUND:MoveToPosition(npc_npc_guregguru, 192, 188, false, 2)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Right)
  GROUND:MoveToPosition(npc_npc_dogoomu, 216, 188, false, 2)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Right)
  GROUND:MoveToPosition(npc_npc_perappu, 264, 172, false, 1)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GAME:WaitFrames(60)
  -- supervision_Acting(10) [neutre/état moteur]
  GAME:WaitFrames(45)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 240, 152, Direction.Down, "NPC_PUKURIN")
  -- ResetHitAttribute(31) [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_pukurin, 240, 188, false, 1)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_diguda, Direction.DownRight)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  GROUND:EntTurn(npc_npc_heigani, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownRight)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Right)
  GROUND:EntTurn(npc_npc_bippa, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Welcome home! ♪[K]\n[partner]! ♪ [K][hero]! ♪", french="Bienvenue! ♪[K]\n[partner]! ♪[K] [hero]! ♪", german="Willkommen daheim! ♪[K]\n[partner]! ♪[K] [hero]! ♪", italian="Di nuovo a casa! ♪[K]\n[partner]! ♪[K] [hero]! ♪", spanish="¡Os damos la bienvenida! ♪[K]\n¡[partner]! ♪[K] ¡[hero]! ♪"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
