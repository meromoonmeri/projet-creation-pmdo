-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P05P03A/m17a0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_P05P03A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(78) [anim idle native]
  GAME:FadeIn(120)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-where is this?!", french=" Où... où est-ce qu'on est?!", german=" W-wo bin ich?!?", italian=" D-Dove siamo?!", spanish=" ¡¿Qué lugar es este?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-where is this?!", french=" Où... où est-ce qu'on est?!", german=" W-wo bin ich?!?", italian=" D-Dove siamo?!", spanish=" ¡¿Qué lugar es este?!"})
  else
  SkySceneKit.say({english=" Wh-where is this?!", french=" Où... où est-ce qu'on est?!", german=" W-wo bin ich?!?", italian=" D-Dove siamo?!", spanish=" ¡¿Qué lugar es este?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="They have me trussed up.\nI can't move...", french="Ils m'ont ligoté. Je ne peux plus\nbouger...", german="Sie haben mich gefesselt.\nIch kann mich nicht bewegen.", italian="Mi hanno legato... Non riesco a\nmuovermi...", spanish="Deben de haberme atado.\nNo puedo moverme."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="They have me trussed up.\nI can't move...", french="Ils m'ont ligoté. Je ne peux plus\nbouger...", german="Sie haben mich gefesselt.\nIch kann mich nicht bewegen.", italian="Mi hanno legato... Non riesco a\nmuovermi...", spanish="Deben de haberme atado.\nNo puedo moverme."})
  else
  SkySceneKit.say({english="They have me trussed up.\nI can't move...", french="Ils m'ont ligotée. Je ne peux\nplus bouger...", german="Sie haben mich gefesselt.\nIch kann mich nicht bewegen.", italian="Mi hanno legata... Non riesco a\nmuovermi...", spanish="Deben de haberme atado.\nNo puedo moverme."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-why is this happening?", french="Mais qu'est-ce qui se passe\nà la fin?", german=" W-warum passiert das alles?", italian=" P-Perché tutto questo?", spanish=" ¿Por qué está ocurriendo esto?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-why is this happening?", french="Mais qu'est-ce qui se passe\nà la fin?", german=" W-warum passiert das alles?", italian=" P-Perché tutto questo?", spanish=" ¿Por qué está ocurriendo esto?"})
  else
  SkySceneKit.say({english=" Wh-why is this happening?", french="Mais qu'est-ce qui se passe\nà la fin?", german=" W-warum passiert das alles?", italian=" P-Perché tutto questo?", spanish=" ¿Por qué está ocurriendo esto?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8711) — id SE NDS sans portage PMDO identifié
  -- supervision_RemoveActing(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(78) [anim idle native]
  -- SetAnimation(78) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey!", french=" Eh!", german=" Hey!", italian=" Ehi!", spanish=" ¡Oye!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey!", french=" Eh!", german=" Hey!", italian=" Ehi!", spanish=" ¡Oye!"})
  else
  SkySceneKit.say({english=" Oh!", french=" Eh!", german=" Oh!", italian=" Ehi!", spanish=" ¡Oye!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner]!)", french="([partner]!)", german="([partner]!)", italian="([partner]!)", spanish="(¡[partner]!)"})
  else
  SkySceneKit.say({english="([partner]!)", french="([partner]!)", german="([partner]!)", italian="([partner]!)", spanish="(¡[partner]!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Am I glad to see you![K]\nYou're OK, right?", french="Ce que je suis content de\nte voir![K] Tu vas bien, pas vrai?", german="Bin ich froh, dich zu sehen![K]\nIst alles in Ordnung?", italian="Sono felice di vederti![K]\nStai bene, vero?", spanish="¡Me alegro de verte![K]\nEstás bien, ¿verdad?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Am I glad to see you![K]\nYou're OK, right?", french="Ce que je suis content de\nte voir![K] Tu vas bien, pas vrai?", german="Bin ich froh, dich zu sehen![K]\nIst alles in Ordnung?", italian="Sono felice di vederti![K]\nStai bene, vero?", spanish="¡Me alegro de verte![K]\nEstás bien, ¿verdad?"})
  else
  SkySceneKit.say({english="Am I glad to see you![K]\nYou're OK, right?", french="Ce que je suis contente de\nte voir![K] Tu vas bien, pas vrai?", german="Bin ich froh, dich zu sehen![K]\nIst alles in Ordnung?", italian="Sono felice di vederti![K]\nStai bene, vero?", spanish="¡Me alegro de verte![K]\nEstás bien, ¿verdad?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Humph!", french=" Pfff!", german=" Hrmpf!", italian=" Humph!", spanish=" ¡Ja!"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="You're clueless about what's going to\nhappen...", french="Vous n'avez pas la moindre idée\nde ce qui va nous arriver...", german="Ihr habt keine Ahnung,\nwas euch erwartet...", italian=" Non avete idea di cosa stia succedendo...", spanish=" No tenéis ni idea de lo que va a suceder..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="I guess you can afford to be nonchalant\nabout it.", french="Si vous le saviez, vous ne seriez\npas aussi calmes.", german="Ihr könnt es euch wohl leisten,\nso ruhig zu bleiben.", italian="Mi chiedo come facciate a essere così\nsuperficiali.", spanish="Supongo que esto no os puede dejar\nindiferentes."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?!", french=" Pardon?!", german=" Häh?!?", italian=" Eh?!", spanish=" ¡¿Qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh?!", french=" Pardon?!", german=" Häh?!?", italian=" Eh?!", spanish=" ¡¿Qué?!"})
  else
  SkySceneKit.say({english=" Pardon?!", french=" Pardon?!", german=" Wie?!?", italian=" Scusa?!", spanish=" ¡¿Qué?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That voice came from over there...)", french="(Cette voix vient de par là...)", german="(Die Stimme kam von dort drüben...)", italian="(Quella voce veniva da laggiù...)", spanish="(Esa voz vino de allí...)"})
  else
  SkySceneKit.say({english="(That voice came from over there...)", french="(Cette voix vient de par là...)", german="(Die Stimme kam von dort drüben...)", italian="(Quella voce veniva da laggiù...)", spanish="(Esa voz vino de allí...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_IN_THE_FUTURE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- GAP: se_Play(8711) — id SE NDS sans portage PMDO identifié
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetAnimation(78) [anim idle native]
  -- SetAnimation(78) [anim idle native]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 1096, 160, Direction.Down, "NPC_JUPUTORU")
  -- SetAnimation(34) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Grovyle[CR]!", french=" [CS:N]Massko[CR]!", german=" [CS:N]Reptain[CR]!", italian=" [CS:N]Grovyle[CR]!", spanish=" ¡[CS:N]Grovyle[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Grovyle[CR]!", french=" [CS:N]Massko[CR]!", german=" [CS:N]Reptain[CR]!", italian=" [CS:N]Grovyle[CR]!", spanish=" ¡[CS:N]Grovyle[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]Grovyle[CR]!", french=" [CS:N]Massko[CR]!", german=" [CS:N]Reptain[CR]!", italian=" [CS:N]Grovyle[CR]!", spanish=" ¡[CS:N]Grovyle[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="You two...[K] Do you have any\ninkling about where you are?", french="Vous deux...[K] Avez-vous\nla moindre petite idée de l'endroit\noù vous vous trouvez?", german="Ihr zwei...[K] Habt ihr auch nur\neinen Schimmer, wo ihr seid?", italian="Voi due...[K] Avete la minima idea\ndi dove siete?", spanish="No tenéis...[K] ni la menor idea de\nlo que estáis haciendo aquí, ¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" N-no...", french=" Euh, non...", german=" N-nein...", italian=" N-No...", spanish=" Pues... no..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" N-no...", french=" Euh, non...", german=" N-nein...", italian=" N-No...", spanish=" Pues... no..."})
  else
  SkySceneKit.say({english=" N-no...", french=" Euh, non...", german=" N-nein...", italian=" N-No...", spanish=" Pues... no..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="This is a stockade...[K] They're\npreparing to get rid of us for good.", french="C'est la Cour des Condamnés...\nIls s'apprêtent à se débarrasser de nous\npour de bon.", german="Ihr seid in einem\nGefangenenraum.[K] Sie wollen uns ein für\nalle Mal aus dem Weg räumen.", italian="Questa è una Sala Punizioni...[K]\nSi vogliono sbarazzare di noi una volta per\ntutte.", spanish="Nos han sacado a la palestra...[K]\nporque quieren librarse de nosotros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?![K] G-get rid of us?!", french=" Quoi?![K] Se débarrasser de nous?!", german="Was?!?[K] U-uns aus dem Weg\nräumen?!?", italian=" Cosa?![K] S-Sbarazzarsi di noi?!", spanish="¡¿Qué?![K]\n¡¿Librarse de nosotros?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?![K] G-get rid of us?!", french=" Quoi?![K] Se débarrasser de nous?!", german="Was?!?[K] U-uns aus dem Weg\nräumen?!?", italian=" Cosa?![K] S-Sbarazzarsi di noi?!", spanish="¡¿Qué?![K]\n¡¿Librarse de nosotros?!"})
  else
  SkySceneKit.say({english=" What?![K] G-get rid of us?!", french=" Quoi?![K] Se débarrasser de nous?!", german="Was?!?[K] U-uns aus dem Weg\nräumen?!?", italian=" Cosa?![K] S-Sbarazzarsi di noi?!", spanish="¡¿Qué?![K]\n¡¿Librarse de nosotros?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wait a second.", french=" Attends deux secondes.", german=" Moment mal.", italian=" Aspetta un secondo.", spanish=" Espera un momento."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wait a second.", french=" Attends deux secondes.", german=" Moment mal.", italian=" Aspetta un secondo.", spanish=" Espera un momento."})
  else
  SkySceneKit.say({english=" Wait a second.", french=" Attends deux secondes.", german=" Moment mal.", italian=" Aspetta un secondo.", spanish=" Espera un momento."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I can understand why they want\nto get rid of you, [CS:N]Grovyle[CR].", french="Je peux comprendre\nqu'ils veuillent se débarrasser de toi, [CS:N]Massko[CR].", german="Ich kann verstehen, warum sie\ndich loswerden wollen, [CS:N]Reptain[CR].", italian="Posso capire perché vogliano\nliberarsi di te, [CS:N]Grovyle[CR].", spanish="Entiendo que quieran vengarse\nde ti, [CS:N]Grovyle[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's easy to understand why\nthey'd want to get rid of you, [CS:N]Grovyle[CR].", french="Je peux comprendre\nqu'ils veuillent se débarrasser de toi, [CS:N]Massko[CR].", german="Es ist nicht schwer zu\nverstehen, warum sie dich loswerden wollen,\n[CS:N]Reptain[CR].", italian="È facile capire perché vogliano\nliberarsi di te, [CS:N]Grovyle[CR].", spanish="Entiendo que quieran vengarse\nde ti, [CS:N]Grovyle[CR]."})
  else
  SkySceneKit.say({english="I can understand why they want\nto get rid of you, [CS:N]Grovyle[CR].", french="Je peux comprendre\nqu'ils veuillent se débarrasser de toi, [CS:N]Massko[CR].", german="Es ist nicht schwer zu\nverstehen, warum sie dich loswerden wollen,\n[CS:N]Reptain[CR].", italian="Posso capire perché vogliano\nliberarsi di te, [CS:N]Grovyle[CR].", spanish="Entiendo que quieran vengarse\nde ti, [CS:N]Grovyle[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But why us?!", french=" Mais pourquoi nous?!", german=" Aber warum uns?!?", italian=" Ma noi cosa c'entriamo?!", spanish="¡¿Pero por qué estamos\nnosotros aquí?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But why us?!", french=" Mais pourquoi nous?!", german=" Aber warum uns?!?", italian=" Ma noi cosa c'entriamo?!", spanish="¡¿Pero por qué estamos\nnosotros aquí?!"})
  else
  SkySceneKit.say({english=" But why us?!", french=" Mais pourquoi nous?!", german=" Aber warum uns?!?", italian=" Ma noi cosa c'entriamo?!", spanish="¡¿Pero qué hacemos aquí los\ntres?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We haven't done anything wrong!", french=" On n'a rien fait de mal!", german="Wir haben nichts falsch\ngemacht!", italian="Non abbiamo fatto nulla di\nsbagliato!", spanish=" ¿Qué les hemos hecho?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We haven't done anything wrong!", french=" On n'a rien fait de mal!", german="Wir haben nichts falsch\ngemacht!", italian="Non abbiamo fatto nulla di\nsbagliato!", spanish=" ¿Qué les hemos hecho?"})
  else
  SkySceneKit.say({english=" We haven't done anything wrong!", french=" On n'a rien fait de mal!", german="Wir haben nichts falsch\ngemacht!", italian="Non abbiamo fatto nulla di\nsbagliato!", spanish=" ¿Qué les hemos hecho?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Humph![K] I couldn't care less.", french="Pfff![K] De toute façon, je m'en\nfiche pas mal.", german="Hrmpf![K] Das ist mir so was von\negal.", italian="Bah![K] Non me ne potrebbe\nimportare di meno.", spanish=" ¡Ja![K] ¿A mí qué me cuentas?"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="You must have done something\nthey can't tolerate.", french="Vous avez dû faire quelque\nchose qui leur a déplu.", german="Irgendetwas müsst ihr getan\nhaben, das sie nicht dulden können.", italian="Dovete aver fatto qualcosa che\nnon potevano tollerare.", spanish="Sin duda, les habéis provocado\npor algo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(partner, "angry", 1) end)
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  else
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We haven't done anything bad!", french=" Mais on n'a rien fait de mal!", german=" Wir haben nichts Falsches getan!", italian="Non abbiamo fatto niente di\nmale!", spanish=" ¡No hemos hecho nada malo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We haven't done anything bad!", french=" Mais on n'a rien fait de mal!", german=" Wir haben nichts Falsches getan!", italian="Non abbiamo fatto niente di\nmale!", spanish=" ¡No hemos hecho nada malo!"})
  else
  SkySceneKit.say({english=" We haven't done anything bad!", french=" Mais on n'a rien fait de mal!", german=" Wir haben nichts Falsches getan!", italian="Non abbiamo fatto niente di\nmale!", spanish=" ¡No hemos hecho nada malo!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Don't think that we're like you!", french="Ne va pas t'imaginer qu'on est\ncomme toi!", german="Denk bloß nicht, dass wir wie\ndu sind!", italian=" Non pensare che siamo come te!", spanish=" ¡No creas que somos como tú!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Don't think that we're like you!", french="Ne va pas t'imaginer qu'on est\ncomme toi!", german="Denk bloß nicht, dass wir wie\ndu sind!", italian=" Non pensare che siamo come te!", spanish=" ¡No creas que somos como tú!"})
  else
  SkySceneKit.say({english=" Don't think that we're like you!", french="Ne va pas t'imaginer qu'on est\ncomme toi!", german="Denk bloß nicht, dass wir wie\ndu sind!", italian=" Non pensare che siamo come te!", spanish=" ¡No creas que somos como tú!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" I don't care.", french=" Ça m'est égal.", german=" Es ist mir egal.", italian=" Non m'importa.", spanish="Como si a mí me importara lo\nque decís."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="You're wasting time losing your\ncool. Meanwhile, look...", french="Tiens regarde... pendant que\ntu perdais ton temps à t'énerver. Tu vois?", german="Tja, während du noch dabei bist,\nauszuflippen, sind sie bereits auf dem Weg...", italian="E così mentre stavate\ndiscutendo... Avete visto?", spanish="Estáis perdiendo valiosos\nsegundos. Sería mejor que abrieseis bien\nlos ojos."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Here they come.", french=" Ils arrivent.", german=" Und da sind sie auch schon.", italian=" Stanno arrivando.", spanish=" Ahí vienen."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Down)
  -- GAP: se_Play(7187) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(30)
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetAnimation(78) [anim idle native]
  -- SetAnimation(78) [anim idle native]
  -- SetAnimation(34) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(60)
  pcall(function() GAME:MoveCamera(228, 772, 60, false) end) -- performer/caméra
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 208, 920, Direction.Up, "NPC_YAMIRAMI")
  GROUND:MoveToPosition(npc_npc_yamirami, 208, 788, false, 2)
  local npc_npc_yamirami2 = SkySceneKit.spawn_npc("sableye", 240, 920, Direction.Left, "NPC_YAMIRAMI2")
  GROUND:MoveToPosition(npc_npc_yamirami2, 244, 788, false, 2)
  local npc_npc_yamirami3 = SkySceneKit.spawn_npc("sableye", 208, 936, Direction.Right, "NPC_YAMIRAMI3")
  GROUND:MoveToPosition(npc_npc_yamirami3, 208, 788, false, 2)
  local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 240, 936, Direction.Up, "NPC_YAMIRAMI4")
  GROUND:MoveToPosition(npc_npc_yamirami4, 244, 788, false, 2)
  local npc_npc_yamirami5 = SkySceneKit.spawn_npc("sableye", 208, 952, Direction.Down, "NPC_YAMIRAMI5")
  GROUND:MoveToPosition(npc_npc_yamirami5, 208, 788, false, 2)
  local npc_npc_yamirami6 = SkySceneKit.spawn_npc("sableye", 248, 952, Direction.Right, "NPC_YAMIRAMI6")
  GROUND:MoveToPosition(npc_npc_yamirami6, 244, 788, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami, 164, 728, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami2, 292, 728, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami3, 188, 728, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami4, 268, 728, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami5, 212, 728, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami6, 244, 728, false, 2)
  GROUND:EntTurn(npc_npc_yamirami, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami2, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami3, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_yamirami, Direction.Down)
  GROUND:EntTurn(npc_npc_yamirami2, Direction.Down)
  GROUND:EntTurn(npc_npc_yamirami3, Direction.Down)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Down)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Down)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  -- GAP: se_Play(7188) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_yamirami, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami2, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami3, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() GAME:MoveCamera(228, 712, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waah! Who are they?!", french=" Ouaaah! Mais qui c'est?!", german=" Waah! Wer ist das?!?", italian=" Aaah! Chi sono quelli?!", spanish=" ¡Aaah! ¡¿Quiénes son?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah! Who are they?!", french=" Ouaaah! Mais qui c'est?!", german=" Waah! Wer ist das?!?", italian=" Aaah! Chi sono quelli?!", spanish=" ¡Aaah! ¡¿Quiénes son?!"})
  else
  SkySceneKit.say({english=" Waah! Who are they?!", french=" Ouaaah! Mais qui c'est?!", german=" Waah! Wer ist das?!?", italian=" Aaah! Chi sono quelli?!", spanish=" ¡Aaah! ¡¿Quiénes son?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="They're the jailers who do all\nthe dirty work around here.", french="Ce sont nos geôliers, ils sont\nchargés du sale boulot.", german="Das sind die Gefängniswärter,\ndie hier die schmutzigen Jobs verrichten.", italian="Sono i carcerieri che qui fanno\ntutto il lavoro sporco.", spanish="Son los carceleros que se\nencargan de hacer el trabajo sucio en\neste sitio."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="They also happen to be\n[CS:N]Dusknoir[CR]'s underlings.", french="Et accessoirement, ce sont aussi\nles sbires de [CS:N]Noctunoir[CR].", german="Zufällig sind sie auch die\nUntergebenen von [CS:N]Zwirrfinst[CR].", italian="Sono anche loro degli scagnozzi\ndi [CS:N]Dusknoir[CR].", spanish="Y resulta que también son\nlos sicarios de [CS:N]Dusknoir[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?![K] The great [CS:N]Dusknoir[CR]'s?!", french=" Quoi?![K] Le grand [CS:N]Noctunoir[CR]?!", german="Was?!?[K] Untergebene des großen\n[CS:N]Zwirrfinst[CR]?", italian=" Cosa?![K] Il grande [CS:N]Dusknoir[CR]?!", spanish="¡¿Qué?![K]\n¡¿Sicarios del gran [CS:N]Dusknoir[CR]?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?![K] The great [CS:N]Dusknoir[CR]'s?!", french=" Quoi?![K] Le grand [CS:N]Noctunoir[CR]?!", german="Was?!?[K] Untergebene des großen\n[CS:N]Zwirrfinst[CR]?", italian=" Cosa?![K] Il grande [CS:N]Dusknoir[CR]?!", spanish="¡¿Qué?![K]\n¡¿Sicarios del gran [CS:N]Dusknoir[CR]?!"})
  else
  SkySceneKit.say({english=" What?![K] The great [CS:N]Dusknoir[CR]'s?!", french=" Quoi?![K] Le grand [CS:N]Noctunoir[CR]?!", german="Was?!?[K] Untergebene des großen\n[CS:N]Zwirrfinst[CR]?", italian=" Cosa?![K] Il grande [CS:N]Dusknoir[CR]?!", spanish="¡¿Qué?![K]\n¡¿Sicarios del gran [CS:N]Dusknoir[CR]?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(228, 772, 60, false) end) -- performer/caméra
  -- supervision_Acting(4) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 232, 880, Direction.Up, "NPC_YONOWAARU")
  GROUND:MoveToPosition(npc_npc_yonowaaru, 228, 788, false, 2)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami2, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami3, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami4, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami5, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami6, npc_npc_yonowaaru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(160) end)
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! It's [CS:N]Dusknoir[CR]!", french=" Eh! C'est [CS:N]Noctunoir[CR]!", german=" Hey! Da ist [CS:N]Zwirrfinst[CR]!", italian=" Ehi! È [CS:N]Dusknoir[CR]!", spanish=" ¡Mira! ¡Es [CS:N]Dusknoir[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! It's [CS:N]Dusknoir[CR]!", french=" Eh! C'est [CS:N]Noctunoir[CR]!", german=" Hey! Da ist [CS:N]Zwirrfinst[CR]!", italian=" Ehi! È [CS:N]Dusknoir[CR]!", spanish=" ¡Mira! ¡Es [CS:N]Dusknoir[CR]!"})
  else
  SkySceneKit.say({english=" Hey! It's [CS:N]Dusknoir[CR]!", french=" Eh! C'est [CS:N]Noctunoir[CR]!", german=" Hey! Da ist [CS:N]Zwirrfinst[CR]!", italian=" Ehi! È [CS:N]Dusknoir[CR]!", spanish=" ¡Mira! ¡Es [CS:N]Dusknoir[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="Lord [CS:N]Dusknoir[CR].[K] The three have\nbeen tied to the stakes.", french="Messire [CS:N]Noctunoir[CR].[K] Les trois\ncondamnés ont été ligotés à des pieux.", german="Werter [CS:N]Zwirrfinst[CR].[K] Die drei\nwurden an die Pfähle gebunden.", italian="Lord [CS:N]Dusknoir[CR].[K] I tre sono\nstati legati ai pali.", spanish="Poderoso [CS:N]Dusknoir[CR]...[K]\nLos tres están atados."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Good.", french=" Fort bien.", german=" Gut.", italian=" Bene.", spanish=" Estupendo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Dusknoir[CR], sir![K]\nIt's me, [partner]!", french="Messire [CS:N]Noctunoir[CR]![K]\nC'est moi, [partner]!", german="[CS:N]Zwirrfinst[CR]![K] Ich bin es,\n[partner]!", italian="[CS:N]Dusknoir[CR], signore![K] Sono io,\n[partner]!", spanish="¡[CS:N]Dusknoir[CR]![K]\n¡Soy yo, [partner]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Dusknoir[CR], sir![K]\nIt's me, [partner]!", french="Messire [CS:N]Noctunoir[CR]![K]\nC'est moi, [partner]!", german="[CS:N]Zwirrfinst[CR]![K] Ich bin es,\n[partner]!", italian="[CS:N]Dusknoir[CR], signore![K] Sono io,\n[partner]!", spanish="¡[CS:N]Dusknoir[CR]![K]\n¡Soy yo, [partner]!"})
  else
  SkySceneKit.say({english="[CS:N]Dusknoir[CR], sir![K]\nIt's me, [partner]!", french="Messire [CS:N]Noctunoir[CR]![K]\nC'est moi, [partner]!", german="[CS:N]Zwirrfinst[CR]![K] Ich bin es,\n[partner]!", italian="[CS:N]Dusknoir[CR], signore![K] Sono io,\n[partner]!", spanish="¡[CS:N]Dusknoir[CR]![K]\n¡Soy yo, [partner]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_yonowaaru, 228, 768, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Very well. [CS:N]Sableye[CR].", french=" Très bien. [CS:N]Ténéfix[CR].", german=" Sehr gut, [CS:N]Zobiris[CR].", italian=" Molto bene. [CS:N]Sableye[CR].", spanish=" Muy bien, [CS:N]Sableye[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Those three... We need to be rid\nof them.", french="Débarrassez-moi de\nces trois-là.", german="Diese drei... Sie müssen aus dem\nWeg geschafft werden.", italian=" Dobbiamo liberarci di questi tre.", spanish="Tenemos que librarnos de esos\ntres."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_OH_NO non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  else
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Pay them no heed.[K] You may\nget ready.", french="Ne les écoutez pas.[K] Vous pouvez\nvous préparer.", german="Beachtet sie nicht.[K] Macht euch\nbereit.", italian=" Non dategli retta.[K] Preparatevi.", spanish="No les prestéis atención.[K]\nPodéis prepararos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CS:N]Sableye[CR]: Wheh-heh-heh!", french="[CS:N]Ténéfix[CR]: Whé hé hé!", german="[CS:N]Zobiris[CR]: Wähähäh!", italian="[CS:N]Sableye[CR]: Meh-eh-eh-eh!", spanish="[CS:N]Sableye[CR]: ¡Je, je, je, je!"})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  -- GAP: se_Play(7188) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  pcall(function() GAME:MoveCamera(228, 676, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_yamirami, 156, 696, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami2, 300, 696, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami3, 180, 704, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami4, 276, 704, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami5, 212, 704, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami6, 244, 704, false, 2)
  GROUND:EntTurn(npc_npc_yamirami, Direction.UpRight)
  GROUND:EntTurn(npc_npc_yamirami2, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_yamirami3, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Up)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" W-wait a minute! [CS:N]Dusknoir[CR], sir!", french="Attendez une minute! Messire\n[CS:N]Noctunoir[CR]!", german=" W-wartet! [CS:N]Zwirrfinst[CR]!", italian="A-Aspettate un minuto! [CS:N]Dusknoir[CR],\nsignore!", spanish=" ¡Un momento! ¡[CS:N]Dusknoir[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" W-wait a minute! [CS:N]Dusknoir[CR], sir!", french="Attendez une minute! Messire\n[CS:N]Noctunoir[CR]!", german=" W-wartet! [CS:N]Zwirrfinst[CR]!", italian="A-Aspettate un minuto! [CS:N]Dusknoir[CR],\nsignore!", spanish=" ¡Un momento! ¡[CS:N]Dusknoir[CR]!"})
  else
  SkySceneKit.say({english=" W-wait a minute! [CS:N]Dusknoir[CR], sir!", french="Attendez une minute! Messire\n[CS:N]Noctunoir[CR]!", german=" W-wartet! [CS:N]Zwirrfinst[CR]!", italian="A-Aspettate un minuto! [CS:N]Dusknoir[CR],\nsignore!", spanish=" ¡Un momento! ¡[CS:N]Dusknoir[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What's wrong with you?!", french=" Qu'est-ce qui vous prend?!", german=" Was ist mit dir los?!?", italian=" Cosa le succede?!", spanish=" ¡¿Qué te pasa?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What's wrong with you?!", french=" Qu'est-ce qui vous prend?!", german=" Was ist mit dir los?!?", italian=" Cosa le succede?!", spanish=" ¡¿Qué te pasa?!"})
  else
  SkySceneKit.say({english=" What's happened to you?!", french=" Qu'est-ce qui vous prend?!", german=" Was ist mit dir passiert?!?", italian=" Cosa le è successo?!", spanish=" ¡¿Qué te pasa?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Why are you doing this to us?!", french="Pourquoi est-ce que vous nous\nfaites ça?!", german=" Warum tust du uns das an?!?", italian=" Perché ci sta facendo questo?!", spanish="¡¿Por qué nos estás haciendo\nesto?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Why are you doing this to us?!", french="Pourquoi est-ce que vous nous\nfaites ça?!", german=" Warum tust du uns das an?!?", italian=" Perché ci sta facendo questo?!", spanish="¡¿Por qué nos estás haciendo\nesto?!"})
  else
  SkySceneKit.say({english=" Why are you doing this to us?!", french="Pourquoi est-ce que vous nous\nfaites ça?!", german=" Warum tust du uns das an?!?", italian=" Perché ci sta facendo questo?!", spanish="¡¿Por qué nos estás haciendo\nesto?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Don't waste your breath...[K]\nInstead...shhhh...", french="Ne gaspille pas ta salive...[K]\nTu ferais mieux de te taire...", german="Spart euch euren Atem...[K]\nSeid lieber still... Psst...", italian="Non sprecate il fiato...[K]\nShhhh... fate silenzio...", spanish="No malgastéis saliva...[K]\nY bajad la voz..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="...Keep your voices down so\nthey can't hear you...", french="Mets-la plutôt en sourdine\npour qu'ils ne t'entendent pas...", german="Sprecht leise, damit sie euch\nnicht hören können...", italian="Abbassate la voce in modo\nche non vi possano sentire...", spanish="No habléis muy alto, si no\nnos oirán..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk...! Keep...my voice down?", french="Argh...! Que je la mette...\nen sourdine?", german=" Argh! Leise sprechen?", italian=" Uh...! Abbassare... la voce?", spanish="¿Qué? ¿Cómo que no hable muy\nalto?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk...! Keep...my voice down?", french="Argh...! Que je la mette...\nen sourdine?", german=" Argh! Leise sprechen?", italian=" Uh...! Abbassare... la voce?", spanish="¿Qué? ¿Cómo que no hable muy\nalto?"})
  else
  SkySceneKit.say({english=" Urk...! Keep...my voice down?", french="Argh...! Que je la mette...\nen sourdine?", german=" Argh! Leise sprechen?", italian=" Uh...! Abbassare... la voce?", spanish="¿Qué? ¿Cómo que no hable muy\nalto?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="You two...[K] If you want to\nget away...", french="Si vous voulez vous échapper...[K]\nvous deux...", german="Ihr zwei...[K] Wenn ihr hier\nrauskommen wollt...", italian=" Se volete scappare,[K] voi due...", spanish="Escuchadme...[K]\nSi queréis salir con vida de aquí..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" ...give me your full cooperation.", french=" ... faites-moi confiance.", german="Dann müssen wir\nzusammenarbeiten.", italian="... dovete darmi la vostra\ncompleta collaborazione.", spanish="Necesito vuestra plena\ncooperación."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What...?[K] Help you, [CS:N]Grovyle[CR]...?", french="Quoi...?[K] Qu'on te fasse confiance,\nà toi, [CS:N]Massko[CR]...?", german=" Was?[K] Mit dir, [CS:N]Reptain[CR]?", italian=" Cosa...?[K] Aiutare te, [CS:N]Grovyle[CR]...?", spanish="¿Qué?[K] ¿Ayudarte a ti,\n[CS:N]Grovyle[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What...?[K] Help you, [CS:N]Grovyle[CR]...?", french="Quoi...?[K] Qu'on te fasse confiance,\nà toi, [CS:N]Massko[CR]...?", german=" Was?[K] Mit dir, [CS:N]Reptain[CR]?", italian=" Cosa...?[K] Aiutare te, [CS:N]Grovyle[CR]...?", spanish="¿Qué?[K] ¿Ayudarte a ti,\n[CS:N]Grovyle[CR]?"})
  else
  SkySceneKit.say({english=" What...?[K] Help you, [CS:N]Grovyle[CR]...?", french="Quoi...?[K] Qu'on te fasse confiance,\nà toi, [CS:N]Massko[CR]...?", german=" Was?[K] Mit dir, [CS:N]Reptain[CR]?", italian=" Cosa...?[K] Aiutare te, [CS:N]Grovyle[CR]...?", spanish="¿Qué?[K] ¿Ayudarte a ti,\n[CS:N]Grovyle[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="There's no time to think...[K]\nor would you prefer to stick around for them?", french="Pas le temps de tergiverser...[K]\nà moins que tu ne préfères rester ici\nà les attendre?", german="Ihr habt keine Zeit, lange zu\nüberlegen...[K] Oder wollt ihr lieber hierbleiben?", italian="Non c'è tempo per pensare...[K]\nMi aiutate o preferite rimanere nelle loro\ngrinfie?", spanish="No hay tiempo para pensar...[K]\n¿O preferís quedar en sus manos?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Psst...hey! You there...", french=" Psst... Eh, toi, là-bas!", german=" Psst... hey! Du da...", italian=" Psst... Ehi! Tu...", spanish=" Pss... ¡Oye! ¡Oye, tú!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...!)", french="(...!)", german="(Huch!)", italian="(...!)", spanish="(¿?)"})
  else
  SkySceneKit.say({english="(...!)", french="(...!)", german="(Huch!)", italian="(...!)", spanish="(¿?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" ...Tell me...", french=" ... Dis-moi...", german=" ...Sag mal...", italian=" Dimmi...", spanish=" Dime..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" ...What can you do right now?", french="... Fais quelque chose\nmaintenant!", german="Fällt dir irgendetwas ein, das\ndu tun könntest?", italian=" Ora cosa faresti?", spanish="¿Qué puedes hacer en este\nmomento?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What?[K] What can I do?)", french="(Hein?[K] Mais faire quoi au juste?)", german="(Was?[K] Was ich tun könnte?)", italian="(Cosa?[K] Cosa farei?)", spanish="(¿Qué?[K] ¿Cómo que qué puedo hacer?)"})
  else
  SkySceneKit.say({english="(What?[K] What can I do?)", french="(Hein?[K] Mais faire quoi au juste?)", german="(Was?[K] Was ich tun könnte?)", italian="(Cosa?[K] Cosa farei?)", spanish="(¿Qué?[K] ¿Cómo que qué puedo hacer?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(You ask me that out of nowhere...![K] Umm...)", french="(Tu me prends au dépourvu...![K] Hum...)", german="(Was ist denn das für eine Frage?!?[K] Ähem...)", italian="(Me lo chiedi così all'improvviso...![K] Mmm...)", spanish="(¡Me lo preguntas, así, por las buenas![K] Hum...)"})
  else
  SkySceneKit.say({english="(You ask me that out of nowhere...![K] Umm...)", french="(Tu me prends au dépourvu...![K] Hum...)", german="(Was ist denn das für eine Frage?!?[K] Ähem...)", italian="(Me lo chiedi così all'improvviso...![K] Mmm...)", spanish="(¡Me lo preguntas, así, por las buenas![K] Hum...)"})
  end
  -- @label_3 [étiquette de flux ExplorerScript]
  -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Wh-what to do...?)", french="(Que... que faire?)", german="(W-was tun?)", italian="(C-Che fare...?)", spanish="(¿Qué puedo hacer?)"})
  else
  SkySceneKit.say({english="(Wh-what to do...?)", french="(Que... que faire?)", german="(W-was tun?)", italian="(C-Che fare...?)", spanish="(¿Qué puedo hacer?)"})
  end
  do local __choice = SkySceneKit.ask({{english="Use an item!", french="Un objet!", german="Item einsetzen!", italian="Usa strumento!", spanish="Usar un objeto"}, {english="Use a move!", french="Une capacité!", german="Attacke nutzen!", italian="Usa mossa!", spanish="Un movimiento"}, {english="Attack!", french="Attaquer!", german="Angreifen!", italian="Attacca!", spanish="¡Atacar!"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="...A move...?[K] That could work,\nbut...", french="... Une capacité...?[K] Ça pourrait\nmarcher, mais...", german="Eine Attacke?[K] Das könnte\nklappen, aber...", italian="Una mossa...?[K] Potrebbe\nfunzionare, ma...", spanish="¿Un movimiento?[K]\nPodría funcionar, pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" ...No! That's no good...", french=" ... Non! Ça ne servira à rien...", german=" Nein! Das bringt nichts.", italian=" No! Non va bene...", spanish=" ¡No! No serviría de nada..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="...We're trussed up...so we\ncan't move...", french="... On est attachés... alors on ne\npeut pas bouger...", german="Wir sind gefesselt... Und wir\nkönnen uns nicht bewegen.", italian="Siamo legati e non possiamo\nmuoverci...", spanish="Estamos atados, así que no\npodemos movernos."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="...It has to be something you can\ndo instantaneously...", french="... il faut que ce soit faisable\nimmédiatement...", german="Es sollte etwas sein, das man\nsofort einsetzen kann.", italian="Ci dev'essere qualcosa che puoi\nfare nell'immediato...", spanish="Tiene que ser algo que pueda\nhacerse de forma instantánea."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="...It doesn't need to be flashy...\nCan't you do anything more basic...?", french="On n'est pas forcés d'utiliser\nles grands moyens... juste quelque chose de\nsimple et efficace...", german="Es muss nichts Ausgefallenes\nsein. Fällt dir nichts Einfacheres ein?", italian="Non dev'essere qualcosa di\ncomplesso... Puoi fare una cosa più semplice?", spanish="No hace falta que sea\nespectacular... Tiene que ser algo\nmás básico."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Urk...! You're not helping...[K] Ummm...)", french="(Argh...! Alors ça, ça m'aide beaucoup...[K]\nHum...)", german="(Urk! Du bist keine große Hilfe...[K] Ähmmm...)", italian="(Uh...! Non sei molto d'aiuto...[K] Mmmm...)", spanish="(Eso no me ayuda mucho...[K] Hum...)"})
  else
  SkySceneKit.say({english="(Urk...! You're not helping...[K] Ummm...)", french="(Argh...! Alors ça, ça m'aide beaucoup...[K]\nHum...)", german="(Urk! Du bist keine große Hilfe...[K] Ähmmm...)", italian="(Uh...! Non sei molto d'aiuto...[K] Mmmm...)", spanish="(Eso no me ayuda mucho...[K] Hum...)"})
  end
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  elseif __choice == 3 then
  -- break_loop [contrôle de boucle forever NDS: une itération compilée]
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" ...No. An item's no good...", french="... Non, un objet ne sera d'aucune\nutilité...", german=" Nein. Ein Item bringt nichts.", italian=" No. Uno strumento non va bene...", spanish=" No. Un objeto no sirve de nada."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="...We're tied up...and unable\nto move...", french="... On est ligotés... pas moyen\nde bouger...", german="Wir sind gefesselt... Und wir\nkönnen uns nicht bewegen.", italian="Siamo legati e non possiamo\nmuoverci.", spanish="Estamos atados y no podemos\nmovernos."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="...It should be something you can\ndo instantaneously...", french="... Improvise, pense à quelque\nchose que tu peux faire instantanément...", german="Es sollte etwas sein, das man\nsofort einsetzen kann.", italian="Ci dev'essere qualcosa che puoi\nfare nell'immediato...", spanish="Tendría que ser algo que puedas\nhacer instantáneamente."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Urk...! That's easy for you to say...[K] Ummm...)", french="(Argh...! Facile à dire...[K] Hum...)", german="(Urk! Das sagt sich leicht...[K] Ähmmm...)", italian="(Uh...! Facile a dirsi...[K] Mmmm...)", spanish="(Como si fuera tan fácil...[K] Hum...)"})
  else
  SkySceneKit.say({english="(Urk...! That's easy for you to say...[K] Ummm...)", french="(Argh...! Facile à dire...[K] Hum...)", german="(Urk! Das sagt sich leicht...[K] Ähmmm...)", italian="(Uh...! Facile a dirsi...[K] Mmmm...)", spanish="(Como si fuera tan fácil...[K] Hum...)"})
  end
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  end
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" ...! That's it... That'll do...", french=" ...! Oui, c'est ça... ça ira...", german=" Das ist es! Das klappt!", italian=" Sì! Può funzionare...", spanish="¡Sí, eso es! Creo que podría\nfuncionar..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...If it's just a regular attack,\nI can help too...", french="Si c'est juste une attaque\nordinaire, je peux t'aider, moi aussi...", german="Wenn es nur ein regulärer\nAngriff ist, kann ich auch mitmachen.", italian="Se usi solo un attacco normale,\nposso aiutarti anch'io...", spanish="Si basta con un ataque normal,\nyo también puedo intentarlo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...If it's just a regular attack,\nI can help too...", french="Si c'est juste une attaque\nordinaire, je peux t'aider, moi aussi...", german="Wenn es nur ein regulärer\nAngriff ist, kann ich auch mitmachen.", italian="Se usi solo un attacco normale,\nposso aiutarti anch'io...", spanish="Si basta con un ataque normal,\nyo también puedo intentarlo..."})
  else
  SkySceneKit.say({english="...If it's just a regular attack,\nI can help too...", french="Si c'est juste une attaque\nordinaire, je peux t'aider, moi aussi...", german="Wenn es nur ein regulärer\nAngriff ist, kann ich auch mitmachen.", italian="Se usi solo un attacco normale,\nposso aiutarti anch'io...", spanish="Si basta con un ataque normal,\nyo también puedo intentarlo..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" ...Good.", french=" Bien.", german=" Gut.", italian=" Bene.", spanish=" Estupendo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(228, 772, 60, false) end) -- performer/caméra
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami2, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami3, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami4, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami5, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yamirami6, npc_npc_yonowaaru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Then we are ready to begin!", french="Nous sommes prêts à\ncommencer!", german=" Wir sind jetzt bereit!", italian=" Possiamo cominciare!", spanish=" ¡Estamos listos para empezar!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7196) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- se_Stop(7196) [SE one-shot PMDO déjà terminé: arrêt sans objet, canal SE V2]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Very well.", french=" Excellent.", german=" Sehr gut.", italian=" Molto bene.", spanish=" Muy bien."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="But be vigilant to the end. Don't\ntake your eyes off them.", french="Mais soyez vigilants\njusqu'au bout. Ne les quittez point des yeux.", german="Aber seid bis zum Ende\nwachsam. Lasst sie nicht aus den Augen.", italian="Ma mi raccomando. Non\ntoglietegli gli occhi di dosso.", spanish="No os despistéis ni un instante.\nNo les perdáis de vista hasta el final."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Especially that [CS:N]Grovyle[CR].", french=" Surtout ce [CS:N]Massko[CR].", german=" Vor allem nicht diesen [CS:N]Reptain[CR].", italian=" Specialmente da quel [CS:N]Grovyle[CR].", spanish=" Sobre todo a ese [CS:N]Grovyle[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CS:N]Sableye[CR]: Wheh-heh-heh!", french="[CS:N]Ténéfix[CR]: Whé hé hé!", german="[CS:N]Zobiris[CR]: Wähähäh!", italian="[CS:N]Sableye[CR]: Meh-eh-eh-eh!", spanish="[CS:N]Sableye[CR]: ¡Je, je, je, je!"})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  -- GAP: se_Play(7188) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_yamirami, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami2, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami3, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami4, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami5, Direction.Up)
  GROUND:EntTurn(npc_npc_yamirami6, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_yonowaaru, p.X+(0), p.Y+(16), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Commence...[K]now!", french=" Que l'exécution...[K] commence!", german=" Beginnt...[K] jetzt!", italian=" Cominciate...[K] Subito!", spanish=" Comenzad...[K] ¡Ya!"})
  -- message_Close
  pcall(function() GAME:MoveCamera(228, 676, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CS:N]Sableye[CR]: Wheh-heh-heh!", french="[CS:N]Ténéfix[CR]: Whé hé hé!", german="[CS:N]Zobiris[CR]: Wähähäh!", italian="[CS:N]Sableye[CR]: Meh-eh-eh-eh!", spanish="[CS:N]Sableye[CR]: ¡Je, je, je, je!"})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(0), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami2.Position; GROUND:MoveToPosition(npc_npc_yamirami2, p.X+(0), p.Y+(-8), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_yamirami3.Position; GROUND:MoveToPosition(npc_npc_yamirami3, p.X+(0), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(0), p.Y+(-8), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(0), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami6.Position; GROUND:MoveToPosition(npc_npc_yamirami6, p.X+(0), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GROUND:EntTurn(npc_npc_yamirami, Direction.UpRight)
  GROUND:EntTurn(npc_npc_yamirami2, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...! They're coming...", french=" ...! Ils arrivent...", german=" Sie kommen...", italian=" Stanno arrivando...", spanish=" ¡Ahí vienen!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...! They're coming...", french=" ...! Ils arrivent...", german=" Sie kommen...", italian=" Stanno arrivando...", spanish=" ¡Ahí vienen!"})
  else
  SkySceneKit.say({english=" ...! They're coming...", french=" ...! Ils arrivent...", german=" Sie kommen...", italian=" Stanno arrivando...", spanish=" ¡Ahí vienen!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" ...Listen carefully...", french=" ... Ecoutez-moi bien...", german=" ...Hört gut zu...", italian=" Ascoltate attentamente...", spanish=" Escuchad con atención..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" ...[CS:N]Sableye[CR] use claws to strike...", french="... Les [CS:N]Ténéfix[CR] attaquent\nà coups de griffes...", german="[CS:N]Zobiris[CR] schlagen mit ihren\nKlauen zu...", italian="I [CS:N]Sableye[CR] usano gli artigli per\ncolpire...", spanish="Los [CS:N]Sableye[CR] usan las garras\npara atacar..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...! Yikes...that sounds scary!", french=" ...! Gloups... Quelle horreur!", german=" Oje, das klingt scheußlich!", italian=" Iiiih... È spaventoso!", spanish=" ¡Ay! ¡Eso no suena nada bien!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...! Yikes...that sounds scary!", french=" ...! Gloups... Quelle horreur!", german=" Oje, das klingt scheußlich!", italian=" Iiiih... È spaventoso!", spanish="¡Ay! ¡Se me están poniendo\nlos pelos de punta!"})
  else
  SkySceneKit.say({english=" ...! Yikes...that sounds scary!", french=" ...! Gloups... Quelle horreur!", german=" Oje, das klingt scheußlich!", italian=" Iiiih... È spaventoso!", spanish="¡Ay! ¡Se me están poniendo\nlos pelos de punta!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(0), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami2.Position; GROUND:MoveToPosition(npc_npc_yamirami2, p.X+(0), p.Y+(-8), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_yamirami3.Position; GROUND:MoveToPosition(npc_npc_yamirami3, p.X+(0), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(0), p.Y+(-8), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(0), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami6.Position; GROUND:MoveToPosition(npc_npc_yamirami6, p.X+(0), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GROUND:EntTurn(npc_npc_yamirami, Direction.UpRight)
  GROUND:EntTurn(npc_npc_yamirami2, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="...And that might just open one\navenue for escape...", french="... mais ça va peut-être nous\ndonner l'occasion de nous échapper...", german="Und genau das könnte uns\ndie Flucht ermöglichen...", italian="Questo può aprirci una via di\nfuga.", spanish="Y eso podría abrirnos una vía\nde escape."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="...The [CS:N]Sableye[CR] will unleash their\n[CS:M]Fury Swipes[CR] in a frenzy...[K] That's our chance.", french="Les [CS:N]Ténéfix[CR] vont se jeter sur\nnous et déchaîner une pluie de [CS:M]Combo-Griffes[CR].\nC'est là qu'il faudra saisir notre chance.", german="Die [CS:N]Zobiris[CR] werden ihre\n[CS:M]Kratzfurie[CR] einsetzen.[K] Das ist unsere Chance.", italian="I [CS:N]Sableye[CR] useranno con impeto le\nloro [CS:M]Sfuriate[CR]...[K] È la nostra unica possibilità.", spanish="Los [CS:N]Sableye[CR] entrarán en\nun frenesí de [CS:M]Golpes Furia[CR]...[K]\nEsa será nuestra oportunidad."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="...If even one of their attacks\nwere to hit the ropes binding us...", french="Il suffirait qu'une seule de leurs\nattaques atteigne nos liens...", german="Wenn sie uns angreifen und\ndabei die Seile treffen, mit denen wir\ngefesselt sind...", italian="Se anche solo uno dei loro\nattacchi colpisse le corde che ci tengono\nlegati...", spanish="Si alguno de sus golpes alcanzase\nlas cuerdas que nos atan..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...Oh, right...![K] The ropes might\ncome loose!", french="Oh, mais oui...![K] Ça pourrait\ncouper les cordes!", german="Oh, genau![K] Die Seile könnten\nsich lösen!", italian="Ah, è vero...![K] Le corde si\nallenterebbero!", spanish="¡Ya entiendo![K]\n¡Las cuerdas podrían soltarse!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...Oh, right...![K] The ropes might\ncome loose!", french="Oh, mais oui...![K] Ça pourrait\ncouper les cordes!", german="Oh, genau![K] Die Seile könnten\nsich lösen!", italian="Ah, è vero...![K] Le corde si\nallenterebbero!", spanish="¡Ya entiendo![K]\n¡Las cuerdas podrían soltarse!"})
  else
  SkySceneKit.say({english="...Oh, right...![K] The ropes might\ncome loose!", french="Oh, mais oui...![K] Ça pourrait\ncouper les cordes!", german="Oh, genau![K] Die Seile könnten\nsich lösen!", italian="Ah, è vero...![K] Le corde si\nallenterebbero!", spanish="¡Ya entiendo![K]\n¡Las cuerdas podrían soltarse!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="...Exactly...[K]and if that happens,\nlash out with an attack, then flee!", french="... Exact...[K] si jamais ça se\nproduit, dégagez le passage avec une attaque\net fuyez!", german="Genau.[K] Und wenn das passiert,\nstartet einen Angriff und flieht!", italian="Proprio così...[K] E se succede,\nusiamo un attacco e scappiamo!", spanish="Exactamente.[K] Y si eso ocurre,\n¡lanzad un ataque y, después, salid corriendo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(8), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami2.Position; GROUND:MoveToPosition(npc_npc_yamirami2, p.X+(-8), p.Y+(-8), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_yamirami3.Position; GROUND:MoveToPosition(npc_npc_yamirami3, p.X+(0), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(0), p.Y+(-8), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(0), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami6.Position; GROUND:MoveToPosition(npc_npc_yamirami6, p.X+(0), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GROUND:EntTurn(npc_npc_yamirami, Direction.UpRight)
  GROUND:EntTurn(npc_npc_yamirami2, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...B-b-but...", french=" ... M-m-mais...", german=" A-a-aber...", italian=" M-M-Ma...", spanish=" Pe... pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...B-b-but...", french=" ... M-m-mais...", german=" A-a-aber...", italian=" M-M-Ma...", spanish=" Pe... pero..."})
  else
  SkySceneKit.say({english=" ...B-b-but...", french=" ... M-m-mais...", german=" A-a-aber...", italian=" M-M-Ma...", spanish=" Pe... pero..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...What if their [CS:M]Fury Swipes[CR]\ndon't slash the ropes...?", french="... Et si jamais ce ne sont pas\nles cordes que leurs [CS:M]Combo-Griffes[CR]\nlacèrent...?", german="Was, wenn ihre [CS:M]Kratzfurie[CR]\ndie Seile nicht zerschneidet?", italian="Cosa succede se le loro\n[CS:M]Sfuriate[CR] non colpiscono le corde...?", spanish="¿Qué pasa si sus [CS:M]Golpes Furia[CR]\nno cortan las cuerdas?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...What if their [CS:M]Fury Swipes[CR]\ndon't slash the ropes...?", french="... Et si jamais ce ne sont pas\nles cordes que leurs [CS:M]Combo-Griffes[CR]\nlacèrent...?", german="Was, wenn ihre [CS:M]Kratzfurie[CR]\ndie Seile nicht zerschneidet?", italian="Cosa succede se le loro\n[CS:M]Sfuriate[CR] non colpiscono le corde...?", spanish="¿Qué pasa si sus [CS:M]Golpes Furia[CR]\nno cortan las cuerdas?"})
  else
  SkySceneKit.say({english="...What if their [CS:M]Fury Swipes[CR]\ndon't slash the ropes...?", french="... Et si jamais ce ne sont pas\nles cordes que leurs [CS:M]Combo-Griffes[CR]\nlacèrent...?", german="Was, wenn ihre [CS:M]Kratzfurie[CR]\ndie Seile nicht zerschneidet?", italian="Cosa succede se le loro\n[CS:M]Sfuriate[CR] non colpiscono le corde...?", spanish="¿Qué pasa si sus [CS:M]Golpes Furia[CR]\nno cortan las cuerdas?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(0), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami2.Position; GROUND:MoveToPosition(npc_npc_yamirami2, p.X+(0), p.Y+(-8), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_yamirami3.Position; GROUND:MoveToPosition(npc_npc_yamirami3, p.X+(0), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(0), p.Y+(-8), false, 1) end -- Move2PositionOffset
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(0), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_yamirami6.Position; GROUND:MoveToPosition(npc_npc_yamirami6, p.X+(0), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GROUND:EntTurn(npc_npc_yamirami, Direction.UpRight)
  GROUND:EntTurn(npc_npc_yamirami2, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...And what if...[K] What if the\n[CS:N]Sableye[CR] don't use [CS:M]Fury Swipes[CR] at all...?", french="... Et si...[K] si les [CS:N]Ténéfix[CR]\nn'ont pas recours à leurs [CS:M]Combo-Griffes[CR]...?", german="Und was, wenn...[K] Was, wenn die\n[CS:N]Zobiris[CR] gar keine [CS:M]Kratzfurie[CR] einsetzen?", italian="E cosa accade se...[K] Cosa\naccade se i [CS:N]Sableye[CR] non usano [CS:M]Sfuriate[CR]?", spanish="¿Y qué pasa si...?[K]\n¿Qué pasa si los [CS:N]Sableye[CR] deciden no usar\nsus [CS:M]Golpes Furia[CR] en absoluto?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...And what if...[K] What if the\n[CS:N]Sableye[CR] don't use [CS:M]Fury Swipes[CR] at all...?", french="... Et si...[K] si les [CS:N]Ténéfix[CR]\nn'ont pas recours à leurs [CS:M]Combo-Griffes[CR]...?", german="Und was, wenn...[K] Was, wenn die\n[CS:N]Zobiris[CR] gar keine [CS:M]Kratzfurie[CR] einsetzen?", italian="E cosa accade se...[K] Cosa\naccade se i [CS:N]Sableye[CR] non usano [CS:M]Sfuriate[CR]?", spanish="¿Y qué pasa si...?[K]\n¿Qué pasa si los [CS:N]Sableye[CR] deciden no usar\nsus [CS:M]Golpes Furia[CR] en absoluto?"})
  else
  SkySceneKit.say({english="...And what if...[K] What if the\n[CS:N]Sableye[CR] don't use [CS:M]Fury Swipes[CR] at all...?", french="... Et si...[K] si les [CS:N]Ténéfix[CR]\nn'ont pas recours à leurs [CS:M]Combo-Griffes[CR]...?", german="Und was, wenn...[K] Was, wenn die\n[CS:N]Zobiris[CR] gar keine [CS:M]Kratzfurie[CR] einsetzen?", italian="E cosa accade se...[K] Cosa\naccade se i [CS:N]Sableye[CR] non usano [CS:M]Sfuriate[CR]?", spanish="¿Y qué pasa si...?[K]\n¿Qué pasa si los [CS:N]Sableye[CR] deciden no usar\nsus [CS:M]Golpes Furia[CR] en absoluto?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7194) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:N]Sableye[CR]: Wheh-heh-heh!", french="[CS:N]Ténéfix[CR]: Whé hé hé!", german="[CS:N]Zobiris[CR]: Wähähäh!", italian="[CS:N]Sableye[CR]: Meh-eh-eh-eh!", spanish="[CS:N]Sableye[CR]: ¡Je, je, je, je!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="If that happens...[K]don't even think\nabout it.", french="Dans ce cas...[K]\nMieux vaut ne pas y penser.", german="Wenn das passiert...[K]\nNicht auszudenken...", italian="Se succede...[K] No, non voglio\nnemmeno pensarci.", spanish=" Si es así...[K] no quiero ni pensarlo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7196) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(8) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  -- SetAnimation(45) [anim idle native]
  -- SetAnimation(45) [anim idle native]
  -- SetAnimation(45) [anim idle native]
  -- SetAnimation(45) [anim idle native]
  -- SetAnimation(45) [anim idle native]
  -- SetAnimation(45) [anim idle native]
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Left)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" WAAAAAAH!", french=" OUAAAAH!", german=" WAAAAAAH!", italian=" AAAAAAAH!", spanish=" ¡AAAAAAH!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" WAAAAAAH!", french=" OUAAAAH!", german=" WAAAAAAH!", italian=" AAAAAAAH!", spanish=" ¡AAAAAAH!"})
  else
  SkySceneKit.say({english=" WAAAAAAH!", french=" OUAAAAH!", german=" WAAAAAAH!", italian=" AAAAAAAH!", spanish=" ¡AAAAAAH!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Urggh!)", french="(Arggh!)", german="(Uarggh!)", italian="(Urggh!)", spanish="(¡Glup!)"})
  else
  SkySceneKit.say({english="(Urggh!)", french="(Arggh!)", german="(Uarggh!)", italian="(Urggh!)", spanish="(¡Glup!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="En...en...endure it![K] Wait for\nyour chance!", french="Cou... courage![K] Guettez le bon\nmoment!", german="H-haltet durch![K] Wartet auf\neure Chance!", italian="Re... Resistete![K] Aspettate\nla vostra occasione!", spanish="¡Intentad... aguantar![K]\n¡Esperad al momento adecuado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But if they keep going...", french=" S'ils continuent comme ça...", german=" Aber wenn sie weitermachen...", italian=" Ma se continuano così...", spanish=" Si siguen así..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But if they keep going...", french=" S'ils continuent comme ça...", german=" Aber wenn sie weitermachen...", italian=" Ma se continuano così...", spanish=" Si siguen así..."})
  else
  SkySceneKit.say({english=" But if they keep going...", french=" S'ils continuent comme ça...", german=" Aber wenn sie weitermachen...", italian=" Ma se continuano così...", spanish=" Si siguen así..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We'll be down before our\nchance comes!", french="... tout sera fini pour nous avant\nque l'occasion se présente!", german="Dann sind wir erledigt, bevor\nunsere Chance kommt!", italian="... andremo KO prima di avere\nun'opportunità!", spanish="¡Estaremos fuera de combate\nantes de tener ninguna oportunidad!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We'll be finished before our\nchance comes!", french="... tout sera fini pour nous avant\nque l'occasion se présente!", german="Dann sind wir erledigt, bevor\nunsere Chance kommt!", italian="... andremo KO prima di avere\nun'opportunità!", spanish="¡Estaremos acabados\nantes de tener ninguna oportunidad!"})
  else
  SkySceneKit.say({english="We'll be down before our\nchance comes!", french="... tout sera fini pour nous avant\nque l'occasion se présente!", german="Dann sind wir erledigt, bevor\nunsere Chance kommt!", italian="... andremo KO prima di avere\nun'opportunità!", spanish="¡Estaremos fuera de combate\nantes de tener ninguna oportunidad!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(18) [anim idle native]
  SkySceneKit.offset_pos(hero, 0, 2)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P05P03A1_136) [routine d'objet NDS non simulée - documenté]
  GROUND:EntTurn(partner, Direction.Down)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey!", french=" Eh!", german=" Hey!", italian=" Ehi!", spanish=" ¡Eh!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey!", french=" Eh!", german=" Hey!", italian=" Ehi!", spanish=" ¡Eh!"})
  else
  SkySceneKit.say({english=" Hey!", french=" Eh!", german=" Hey!", italian=" Ehi!", spanish=" ¡Eh!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(18) [anim idle native]
  SkySceneKit.offset_pos(partner, 0, 2)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P05P03A1_135) [routine d'objet NDS non simulée - documenté]
  GROUND:EntTurn(hero, Direction.Down)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(There's a break in the rope!)", french="(La corde est tailladée!)", german="(Da ist ein Riss im Seil!)", italian="(La corda è sfilacciata!)", spanish="(¡Se ha roto una cuerda!)"})
  else
  SkySceneKit.say({english="(There's a break in the rope!)", french="(La corde est tailladée!)", german="(Da ist ein Riss im Seil!)", italian="(La corda è sfilacciata!)", spanish="(¡Se ha roto una cuerda!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(18) [anim idle native]
  SkySceneKit.offset_pos(npc_npc_juputoru, 0, 2)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P05P03A1_137) [routine d'objet NDS non simulée - documenté]
  GROUND:EntTurn(npc_npc_juputoru, Direction.Down)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Now![K] Attack!", french=" Maintenant![K] Chargez!", german=" Jetzt![K] Angreifen!", italian=" Ora![K] Attacca!", spanish=" ¡Ahora![K] ¡Atacad!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Go!", french=" On fonce!", german=" Los!", italian=" Vai!", spanish=" ¡Vamos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Go!", french=" On fonce!", german=" Los!", italian=" Vai!", spanish=" ¡Vamos!"})
  else
  SkySceneKit.say({english=" Go!", french=" On fonce!", german=" Los!", italian=" Vai!", spanish=" ¡Vamos!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- se_FadeOut(7196, 10) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- Destroy() [neutre/état moteur]
  -- SetAnimation(19) [anim idle native]
  -- SetAnimation(19) [anim idle native]
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(hero, 228, 668, false, 2)
  GROUND:MoveToPosition(partner, 276, 668, false, 2)
  GROUND:MoveToPosition(npc_npc_juputoru, 180, 668, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P05P03A1_135) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5126) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(13) [anim idle native]
  -- SetAnimation(13) [anim idle native]
  -- SetAnimation(12) [anim idle native]
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Gwah!", french=" Gwah!", german=" Gwah!", italian=" Aaah!", spanish=" ¡Ah!"})
  -- Move2PositionMark 0 [cible sans placement SSA zone: mouvement non joué]
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  -- SetAnimation(14) [anim idle native]
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(-8), p.Y+(32), false, 2) end -- Slide2PositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami2, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami3, "shock", 1) end)
  -- SetAnimation(14) [anim idle native]
  do local p=npc_npc_yamirami2.Position; GROUND:MoveToPosition(npc_npc_yamirami2, p.X+(8), p.Y+(32), false, 2) end -- Slide2PositionOffset
  -- SetAnimation(14) [anim idle native]
  do local p=npc_npc_yamirami3.Position; GROUND:MoveToPosition(npc_npc_yamirami3, p.X+(0), p.Y+(32), false, 2) end -- Slide2PositionOffset
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "shock", 1) end)
  -- SetAnimation(14) [anim idle native]
  do local p=npc_npc_yamirami4.Position; GROUND:MoveToPosition(npc_npc_yamirami4, p.X+(0), p.Y+(32), false, 2) end -- Slide2PositionOffset
  -- SetAnimation(14) [anim idle native]
  do local p=npc_npc_yamirami5.Position; GROUND:MoveToPosition(npc_npc_yamirami5, p.X+(0), p.Y+(32), false, 2) end -- Slide2PositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "shock", 1) end)
  -- SetAnimation(14) [anim idle native]
  do local p=npc_npc_yamirami6.Position; GROUND:MoveToPosition(npc_npc_yamirami6, p.X+(0), p.Y+(32), false, 2) end -- Slide2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(228, 776, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Wh-what is this?!", french=" Que... que se passe-t-il?!", german=" W-was ist das?!?", italian=" C-Cosa succede?!", spanish=" ¡¿Qué... qué es esto?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- Move2PositionMark 0 [cible sans placement SSA zone: mouvement non joué]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" There!", french=" Prenez ça!", german=" Da!", italian=" Ecco!", spanish=" ¡Ahí tenéis!"})
  -- message_Close
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(7191) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(27) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeOut(true, 5) -- screen_WhiteOut
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" Gaaaah!", french=" Aaaaaah!", german=" Gaaaah!", italian=" AAAAAAH!", spanish=" ¡AAAAAH!"})
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english=" We can't see!", french=" Je n'y vois plus rien!", german=" Wir können nichts sehen!", italian=" Non si vede più niente!", spanish=" ¡No veo nada!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Compose yourselves![K] It's only a\n[CS:I]Luminous Orb[CR]!", french="Enfin, reprenez-vous![K] Ce n'est\nrien qu'une [CS:I]Lumiorbe[CR]!", german="Reißt euch zusammen![K] Es ist\nnur ein [CS:I]Strahlorb[CR]!", italian="State calmi![K] È solo una\n[CS:I]Lumisfera[CR]!", spanish="¡No perdáis la calma![K]\n¡Solo es una [CS:I]Luminosfera[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Its effect wears off quickly!", french=" Son effet est de courte durée!", german=" Der Effekt lässt bald nach!", italian="Il suo effetto svanisce in\nfretta!", spanish=" ¡El efecto no durará mucho!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GAME:FadeIn(60)
  GAME:WaitFrames(15)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami2, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami3, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami5, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami6, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(3)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(228, 776, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" B-blast it!", french=" Malédiction!", german=" V-verflucht!", italian=" M-Maledizione!", spanish=" ¡Maldición!"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="That [CS:N]Grovyle[CR]![K] He fled using the\nflash from that [CS:I]Luminous Orb[CR] as cover!", french="Quel pendard, ce [CS:N]Massko[CR]![K] Il s'est\nservi de la [CS:I]Lumiorbe[CR] comme diversion pour\nprendre la fuite!", german="Dieser [CS:N]Reptain[CR]![K] Er ist unter\nder Deckung des Lichts aus dem [CS:I]Strahlorb[CR]\ngeflohen!", italian="Quel [CS:N]Grovyle[CR]![K] È scappato\nusando il bagliore della [CS:I]Lumisfera[CR] come\ncopertura!", spanish="¡Ese [CS:N]Grovyle[CR]![K] ¡Se ha escapado\naprovechando el destello de la [CS:I]Luminosfera[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="They won't get away with this!\nCome!", french="Ils ne s'en sortiront pas comme\nça! Suivez-moi!", german=" Damit kommen sie nicht davon!", italian="Non fuggiranno così facilmente!\nVenite!", spanish="¡No se saldrán con la suya!\n¡Venid!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CS:N]Sableye[CR]: Wheh-heh-heh!", french="[CS:N]Ténéfix[CR]: Whé hé hé!", german="[CS:N]Zobiris[CR]: Wähähäh!", italian="[CS:N]Sableye[CR]: Meh-eh-eh-eh!", spanish="[CS:N]Sableye[CR]: ¡Je, je, je, je!"})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_yonowaaru, 228, 932, false, 2)
  GAME:WaitFrames(10)
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_yamirami6, 244, 916, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami5, 212, 916, false, 2)
  GAME:WaitFrames(10)
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_yamirami4, 244, 916, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami3, 212, 916, false, 2)
  GAME:WaitFrames(8)
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_yamirami2, 244, 916, false, 2)
  GROUND:MoveToPosition(npc_npc_yamirami, 212, 916, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(60)
  pcall(function() GAME:MoveCamera(228, 712, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(60)
  -- GAP: se_Play(7192) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(5) [neutre/état moteur]
  -- GAP: SetEffect EFFECT_ROCKS_HITTING — VFX sans émote PMDO équivalente
  -- SetAnimation(28) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  -- GAP: se_Play(7192) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(6) [neutre/état moteur]
  -- GAP: SetEffect EFFECT_ROCKS_HITTING — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  -- GAP: SetEffect EFFECT_SMOKE_PUFF_SMALL — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  -- GAP: se_Play(7192) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(7) [neutre/état moteur]
  -- GAP: SetEffect EFFECT_ROCKS_HITTING — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  -- GAP: SetEffect EFFECT_SMOKE_PUFF_SMALL — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  GAME:WaitFrames(60)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Blecch! I got dirt in my mouth...", french="Beurk! J'ai de la terre plein\nla bouche...", german=" Buäh! Ich habe Dreck im Mund...", italian=" Bleah! Ho della terra in bocca...", spanish=" ¡Puaj! Tengo tierra en la boca..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Blecch! I got dirt in my mouth...", french="Beurk! J'ai de la terre plein\nla bouche...", german=" Buäh! Ich habe Dreck im Mund...", italian=" Bleah! Ho della terra in bocca...", spanish=" ¡Puaj! Tengo tierra en la boca..."})
  else
  SkySceneKit.say({english=" Blecch! I got dirt in my mouth...", french="Beurk! J'ai de la terre plein\nla bouche...", german=" Buäh! Ich habe Dreck im Mund...", italian=" Bleah! Ho della terra in bocca...", spanish=" ¡Puaj! Tengo tierra en la boca..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(We're...[K] We're safe...)", french="(Ouf...[K] On s'en est sortis...)", german="(Wir sind...[K] in Sicherheit...)", italian="(Ce...[K] Ce l'abbiamo fatta...)", spanish="(Estamos...[K] ¡Estamos a salvo!)"})
  else
  SkySceneKit.say({english="(We're...[K] We're safe...)", french="(Ouf...[K] On s'en est sortis...)", german="(Wir sind...[K] in Sicherheit...)", italian="(Ce...[K] Ce l'abbiamo fatta...)", spanish="(Estamos...[K] ¡Estamos a salvo!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(So [CS:N]Grovyle[CR] can use [CS:M]Dig[CR]?)", french="(Alors comme ça, [CS:N]Massko[CR] connaît la capacité\n[CS:M]Tunnel[CR]?)", german="([CS:N]Reptain[CR] beherrscht also die Attacke\n[CS:M]Schaufler[CR]?)", italian="(Allora [CS:N]Grovyle[CR] può usare la mossa [CS:M]Fossa[CR]?)", spanish="(¿Así que [CS:N]Grovyle[CR] sabe usar [CS:M]Excavar[CR]?)"})
  else
  SkySceneKit.say({english="(So [CS:N]Grovyle[CR] can use [CS:M]Dig[CR]?)", french="(Alors comme ça, [CS:N]Massko[CR] connaît la capacité\n[CS:M]Tunnel[CR]?)", german="([CS:N]Reptain[CR] beherrscht also die Attacke\n[CS:M]Schaufler[CR]?)", italian="(Allora [CS:N]Grovyle[CR] può usare la mossa [CS:M]Fossa[CR]?)", spanish="(¿Así que [CS:N]Grovyle[CR] sabe usar [CS:M]Excavar[CR]?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(He sure knows many moves.)", french="(Il connaît des tas de capacités.)", german="(Er kennt wirklich viele Attacken.)", italian="(Di sicuro conosce molte mosse.)", spanish="(Conoce muchos movimientos.)"})
  else
  SkySceneKit.say({english="(He sure knows many moves.)", french="(Il connaît des tas de capacités.)", german="(Er kennt wirklich viele Attacken.)", italian="(Di sicuro conosce molte mosse.)", spanish="(Conoce muchos movimientos.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We got out of that scrape...[K]\nBut we're not out of the woods yet.", french="On a réussi à leur échapper\ncette fois-ci...[K] Mais on n'est pas encore tirés\nd'affaire.", german="Wir sind entkommen...[K]\nAber wir sind noch lange nicht in Sicherheit.", italian="L'abbiamo scampata bella...[K] ma\nnon siamo ancora fuori dai guai.", spanish="Hemos escapado por los pelos.[K]\nPero aún no hemos salido de esta."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Let's get out of here, and fast.", french=" Sortons d'ici, et vite.", german=" Lasst uns abhauen, aber schnell.", italian=" Usciamo da qui, e in fretta.", spanish=" Vámonos de aquí cuanto antes."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(228, 832, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_juputoru, 192, 796, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(partner, 264, 796, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 264, 772, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_juputoru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(180) end)
  GROUND:MoveToPosition(npc_npc_juputoru, 228, 932, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(partner, 228, 932, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 228, 932, false, 2)
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(80)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT = 14 -- $COMPULSORY_SAVE_POINT = 14 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
