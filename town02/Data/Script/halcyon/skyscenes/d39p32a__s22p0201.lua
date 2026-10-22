-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D39P32A/s22p0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D39P32A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: se_Play(8201) — id SE NDS sans portage PMDO identifié
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_G01P07A1_108) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(90)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  local npc_npc_parukia = SkySceneKit.spawn_npc("palkia", 248, 224, Direction.Down, "NPC_PARUKIA")
  pcall(function() GROUND:CharSetEmote(npc_npc_parukia, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! [CS:N]Palkia[CR]!", french=" Eh, [CS:N]Palkia[CR]!", german=" Hey! [CS:N]Palkia[CR]!", italian=" Ehi! [CS:N]Palkia[CR]!", spanish=" ¡Eh! ¡[CS:N]Palkia[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! [CS:N]Palkia[CR]!", french=" Eh, [CS:N]Palkia[CR]!", german=" Hey! [CS:N]Palkia[CR]!", italian=" Ehi! [CS:N]Palkia[CR]!", spanish=" ¡Eh! ¡[CS:N]Palkia[CR]!"})
  else
  SkySceneKit.say({english=" Oh, [CS:N]Palkia[CR]!", french=" Eh, [CS:N]Palkia[CR]!", german=" Oh, [CS:N]Palkia[CR]!", italian=" Ehi! [CS:N]Palkia[CR]!", spanish=" ¡Eh! ¡[CS:N]Palkia[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" YOU TWO?!", french=" ENCORE VOUS?!", german=" IHR ZWEI?!?", italian=" VOI DUE?!", spanish=" ¿QUÉ?"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="WHAT ARE YOU DOING IN\nMY DREAMS?!", french="QUE VENEZ-VOUS FAIRE\nDANS MON REVE?!", german="WAS MACHT IHR IN MEINEN\nTRÄUMEN?!?", italian=" COSA CI FATE NEI MIEI SOGNI?!", spanish=" ¿QUÉ HACÉIS EN MIS SUEÑOS?"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" NO![K] I REMEMBER! WE BATTLED!", french="NON![K] JE ME SOUVIENS!\nNOUS ETIONS EN PLEIN COMBAT!", german="NEIN![K] ICH ERINNERE MICH!\nWIR HABEN GEKÄMPFT!", italian="NO![K] MI RICORDO! CI\nSIAMO AFFRONTATI!", spanish="¡NO![K] ¡YA ME ACUERDO!\n¡LUCHAMOS!"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" SO WHY AM I...[K]DREAMING?", french="MAIS ALORS POURQUOI SUIS-JE\nEN TRAIN DE...[K] REVER?", german=" ALSO WARUM...[K] TRÄUME ICH?", italian="QUINDI, PERCHÉ\nSTO...[K] SOGNANDO?", spanish="¿POR QUÉ...?[K]\n¿POR QUÉ ESTOY SOÑANDO?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_PLANETS_PARALYSIS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You've been enveloped by a\nnightmare, [CS:N]Palkia[CR]...", french="Tu as été happé par\nun cauchemar, [CS:N]Palkia[CR]...", german="Du wurdest in einen Albtraum\ngehüllt, [CS:N]Palkia[CR]...", italian="Sei imprigionato in un incubo,\n[CS:N]Palkia[CR]...", spanish="Estás atrapado en una pesadilla,\n[CS:N]Palkia[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You've been enveloped by a\nnightmare, [CS:N]Palkia[CR]...", french="Tu as été happé par\nun cauchemar, [CS:N]Palkia[CR]...", german="Du wurdest in einen Albtraum\ngehüllt, [CS:N]Palkia[CR]...", italian="Sei imprigionato in un incubo,\n[CS:N]Palkia[CR]...", spanish="Estás atrapado en una pesadilla,\n[CS:N]Palkia[CR]..."})
  else
  SkySceneKit.say({english="You've been enveloped by a\nnightmare, [CS:N]Palkia[CR]...", french="Tu as été happé par\nun cauchemar, [CS:N]Palkia[CR]...", german="Du wurdest in einen Albtraum\ngehüllt, [CS:N]Palkia[CR]...", italian="Sei imprigionato in un incubo,\n[CS:N]Palkia[CR]...", spanish="Estás atrapado en una pesadilla,\n[CS:N]Palkia[CR]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_parukia, "shock", 1) end)
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" WHAT...[K] WHAT DID YOU SAY?!", french=" QUOI...[K] QUE DITES-VOUS?!", german="WAS? [K]WAS HAST DU\nGESAGT?!?", italian=" COSA...[K] COSA HAI DETTO?!", spanish=" ¿QUÉ?[K] ¡¿QUÉ DICES?!"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" I'M...[K]IN A NIGHTMARE...?", french="JE SUIS...[K] DANS\nUN CAUCHEMAR...?", german=" ICH BIN...[K] IN EINEM ALBTRAUM?", italian=" SONO...[K] IN UN INCUBO...?", spanish=" ESTOY...[K] ¿EN UNA PESADILLA?"})
  -- message_KeyWait
  GROUND:EntTurn(npc_npc_parukia, Direction.DownRight)
  -- SetAnimation(44) [anim idle native]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" GRRR-OOOOOOOO!", french=" GRRR-OOOOOOOO!", german=" GRRR-OOOOOOOO!", italian=" GRRR-OOOOOOOO!", spanish=" ¡GRRR!"})
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(80)
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa!", french=" Ouaaah!", german=" Holla!", italian=" Waah!", spanish=" ¡Aaaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wa-waah!", french=" Ouaaah!", german=" Ua-aaah!", italian=" Wa-waah!", spanish=" ¡Aaaaah!"})
  else
  SkySceneKit.say({english=" Wa-waah!", french=" Ouaaah!", german=" Ua-aaah!", italian=" Wa-waah!", spanish=" ¡Aaaaah!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- camera_SetEffect(0): arrêt d'effet caméra
  GROUND:EntTurn(npc_npc_parukia, Direction.Down)
  -- SetAnimation(2) [anim idle native]
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" THIS PROVES IT!", french=" VOILA BIEN LA PREUVE!", german=" DAS IST DER BEWEIS!", italian=" QUESTA È LA PROVA!", spanish=" ¡ESTO LO DEMUESTRA!"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" YOU BOTH SHOULD NOT EXIST!", french=" VOUS NE DEVRIEZ PAS EXISTER!", german="IHR ZWEI SOLLTET NICHT\nEXISTIEREN!", italian="VOI DUE NON\nDOVRESTE ESISTERE!", spanish=" ¡NO DEBERÍAIS EXISTIR!"})
  -- message_KeyWait
  -- SetAnimation(22) [anim idle native]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" GRRR-OOOOOOOO!", french=" GRRR-OOOOOOOO!", german=" GRRR-OOOOOOOO!", italian=" GRRR-OOOOOOOO!", spanish=" ¡GRRR!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa! [CS:N]Palkia[CR]!", french=" Ouah! [CS:N]Palkia[CR]!", german=" Holla! [CS:N]Palkia[CR]!", italian=" Waah! [CS:N]Palkia[CR]!", spanish=" ¡Aaah! ¡[CS:N]Palkia[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah! [CS:N]Palkia[CR]!", french=" Ouah! [CS:N]Palkia[CR]!", german=" Uaah! [CS:N]Palkia[CR]!", italian=" Aaah! [CS:N]Palkia[CR]!", spanish=" ¡Aaah! ¡[CS:N]Palkia[CR]!"})
  else
  SkySceneKit.say({english=" Waah! [CS:N]Palkia[CR]!", french=" Ouah! [CS:N]Palkia[CR]!", german=" Uaah! [CS:N]Palkia[CR]!", italian=" Aaah! [CS:N]Palkia[CR]!", spanish=" ¡Aaah! ¡[CS:N]Palkia[CR]!"})
  end
  -- camera_SetEffect(0): arrêt d'effet caméra
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="W-wait a second![K] Can you\nanswer something for us?", french="Attends une minute![K] On peut\nte demander quelque chose?", german="W-warte mal kurz![K] Kannst du\nuns etwas beantworten?", italian="A-Aspetta un attimo![K] Puoi darci\ndelle risposte?", spanish="¡Espera un segundo![K] Tenemos\nque preguntarte algo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="W-wait a second![K] We want to\nask you something...", french="Attends une minute![K] On peut\nte demander quelque chose?", german="W-warte mal kurz![K] Wir\nmöchten dich etwas fragen.", italian="A-Aspetta un attimo![K] Puoi darci\ndelle risposte?", spanish="¡Espera un segundo![K] Tenemos\nque preguntarte algo..."})
  else
  SkySceneKit.say({english="W-wait a second![K] We have to\nask you something...", french="Attends une minute![K] On peut\nte demander quelque chose?", german="W-warte mal kurz![K] Wir\nmüssen dich etwas fragen.", italian="A-Aspetta un attimo![K] Puoi darci\ndelle risposte?", spanish="¡Espera un segundo![K] Tenemos\nque preguntarte algo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Palkia[CR], why are you trying to get\nrid of us?", french="[CS:N]Palkia[CR], pourquoi est-ce que\ntu t'acharnes à vouloir nous éliminer?", german="[CS:N]Palkia[CR], warum versuchst du uns\nloszuwerden?", italian="[CS:N]Palkia[CR], perché stai cercando di\neliminarci?", spanish="[CS:N]Palkia[CR], ¿por qué quieres\nquitarnos de en medio?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Palkia[CR], why are you trying to get\nrid of us?", french="[CS:N]Palkia[CR], pourquoi est-ce que\ntu t'acharnes à vouloir nous éliminer?", german="[CS:N]Palkia[CR], warum versuchst du uns\nloszuwerden?", italian="[CS:N]Palkia[CR], perché stai cercando di\neliminarci?", spanish="[CS:N]Palkia[CR], ¿por qué quieres\nquitarnos de en medio?"})
  else
  SkySceneKit.say({english="[CS:N]Palkia[CR], why are you trying to get\nrid of us?", french="[CS:N]Palkia[CR], pourquoi est-ce que\ntu t'acharnes à vouloir nous éliminer?", german="[CS:N]Palkia[CR], warum versuchst du uns\nloszuwerden?", italian="[CS:N]Palkia[CR], perché stai cercando di\neliminarci?", spanish="[CS:N]Palkia[CR], ¿por qué quieres\nquitarnos de en medio?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="YOU DARE PRETEND THAT YOU\nDON'T KNOW?!", french="VOUS OSEZ FEINDRE\nL'IGNORANCE?!", german="IHR WAGT ES, DIE\nUNWISSENDEN ZU SPIELEN?!?", italian="OSATE FAR FINTA DI\nNON SAPERLO?!", spanish="¡Y AHORA FINGÍS NO SABER\nNADA!"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="YOU ARE DISTORTING SPACE\nWITH RECKLESS ABANDON!", french="ALORS QUE VOUS DISTORDEZ\nL'ESPACE DE MANIERE EHONTEE!", german="IHR VERZERRT DEN RAUM MIT\nSKRUPELLOSER HEMMUNGSLOSIGKEIT!", italian="STATE CAUSANDO UNA\nDISTORSIONE DELLO SPAZIO SENZA\nPREOCCUPARVENE MINIMAMENTE!", spanish="¡ESTÁIS DEFORMANDO EL\nESPACIO CON VUESTRA IMPRUDENCIA!"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="IF THE DISTORTION SPREADS,\nTHE POWER OF DARKNESS WILL GROW!", french="SI LA DISTORSION PREND\nDE L'AMPLEUR, LE POUVOIR DE L'OMBRE\nS'ETENDRA!", german="WENN DIE VERZERRUNG UM SICH\nGREIFT, WÄCHST DIE MACHT DER DUNKELHEIT!", italian="SE LA DISTORSIONE SI\nDIFFONDE, IL POTERE DELL'OSCURITÀ\nAUMENTERÀ!", spanish="SI LA DEFORMACIÓN AUMENTA,\n¡EL PODER DE LA OSCURIDAD CRECERÁ CON\nELLA!"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="THE WORLD WILL BE DROWNED\nIN THIS NIGHTMARE OF DARKNESS!", french="ET LE MONDE SERA\nA JAMAIS ENGLOUTI DANS CETTE\nOMBRE CAUCHEMARDESQUE!", german="DIE WELT WIRD IN DIESEM\nALBTRAUM AUS DUNKELHEIT ERTRINKEN!", italian="IL MONDO VERRÀ IMPRIGIONATO\nIN QUESTO INCUBO DI OSCURITÀ!", spanish="¡EL MUNDO ENTERO QUEDARÁ\nATRAPADO EN ESTA OSCURA PESADILLA!"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="TO PREVENT IT...[K]YOU MUST BE\nWIPED FROM THIS EXISTENCE!", french="LA SEULE FAÇON DE\nL'EMPECHER...[K] C'EST DE VOUS ELIMINER!", german="UM DIES ZU VERHINDERN,[K] MUSS\nDIESE EURE EXISTENZ AUSGELÖSCHT WERDEN!", italian="PER EVITARLO...[K] È\nNECESSARIO ELIMINARVI!", spanish="PARA IMPEDIRLO...[K] ¡DEBO\nHACEROS DESAPARECER!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk![K] But there has to be...", french=" Argh![K] Mais il y a forcément...", german=" Umpf![K] Aber es muss doch...", italian=" Ehi![K] Ma ci deve essere...", spanish=" Pero...[K] Pero tiene que haber..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk![K] But there must be...", french=" Argh![K] Mais il y a forcément...", german=" Umpf![K] Aber es muss doch...", italian=" Ah![K] Ma ci deve essere...", spanish=" Pero...[K] Pero tiene que haber..."})
  else
  SkySceneKit.say({english=" Urk![K] But there must be...", french=" Argh![K] Mais il y a forcément...", german=" Umpf![K] Aber es muss doch...", italian=" Ah![K] Ma ci deve essere...", spanish=" Pero...[K] Pero tiene que haber..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" There must be some other way!", french="Il y a forcément un autre\nmoyen!", german="Es muss doch einen anderen Weg\ngeben!", italian=" Ci deve essere un altro modo!", spanish=" ¡Tiene que haber otra solución!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" There must be some other way!", french="Il y a forcément un autre\nmoyen!", german="Es muss doch einen anderen Weg\ngeben!", italian=" Ci deve essere un altro modo!", spanish=" ¡Tiene que haber otra solución!"})
  else
  SkySceneKit.say({english=" There must be some other way!", french="Il y a forcément un autre\nmoyen!", german="Es muss doch einen anderen Weg\ngeben!", italian=" Ci deve essere un altro modo!", spanish=" ¡Tiene que haber otra solución!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You govern space and dimension,\ndon't you, [CS:N]Palkia[CR]?", french="Tu es le maître de l'espace et\ndes dimensions, n'est-ce pas, [CS:N]Palkia[CR]?", german="Du herrschst doch über Raum\nund Dimensionen, [CS:N]Palkia[CR], richtig?", italian="Tu governi lo spazio e la\ndimensione, non è così, [CS:N]Palkia[CR]?", spanish="Tú gobiernas el espacio y las\ndimensiones, ¿no, [CS:N]Palkia[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You govern space and dimension,\ndon't you, [CS:N]Palkia[CR]?", french="Tu es le maître de l'espace et\ndes dimensions, n'est-ce pas, [CS:N]Palkia[CR]?", german="Du herrschst doch über Raum\nund Dimensionen, [CS:N]Palkia[CR], richtig?", italian="Tu governi lo spazio e la\ndimensione, non è così, [CS:N]Palkia[CR]?", spanish="Tú gobiernas el espacio y las\ndimensiones, ¿no, [CS:N]Palkia[CR]?"})
  else
  SkySceneKit.say({english="You govern space and dimension,\ndon't you, [CS:N]Palkia[CR]?", french="Tu es le maître de l'espace et\ndes dimensions, n'est-ce pas, [CS:N]Palkia[CR]?", german="Du herrschst doch über Raum\nund Dimensionen, [CS:N]Palkia[CR], richtig?", italian="Tu governi lo spazio e la\ndimensione, non è così, [CS:N]Palkia[CR]?", spanish="Tú gobiernas el espacio y las\ndimensiones, ¿no, [CS:N]Palkia[CR]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Why can't you fix the distortion\nof space yourself?", french="Tu ne pourrais pas remédier\ntoi-même à la distorsion de l'espace?", german="Warum kannst du die Verzerrung\ndes Raumes nicht selbst beheben?", italian="Non sei in grado di sistemare la\ndistorsione dello spazio in qualche modo?", spanish=" ¿No puedes corregirlo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Can't you correct the distortion\nof space yourself?", french="Tu ne pourrais pas remédier\ntoi-même à la distorsion de l'espace?", german="Kannst du die Verzerrung des\nRaumes nicht selbst beheben?", italian="Non sei in grado di sistemare la\ndistorsione dello spazio in qualche modo?", spanish=" ¿No puedes corregirlo?"})
  else
  SkySceneKit.say({english="Can't you mend the distortion of\nspace yourself?", french="Tu ne pourrais pas remédier\ntoi-même à la distorsion de l'espace?", german="Kannst du die Verzerrung des\nRaumes nicht selbst flicken?", italian="Non sei in grado di sistemare la\ndistorsione dello spazio in qualche modo?", spanish=" ¿No puedes corregirlo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="IT IS TRUE THAT I CAN BEND\nSPACE TO MY WILL...[K] BUT...", french="IL EST VRAI QUE L'ESPACE\nSE PLIE A MA VOLONTE.[K] POURTANT...", german="ES STIMMT, DASS ICH DEN\nRAUM NACH BELIEBEN BIEGEN KANN.[K] ABER...", italian="È VERO CHE POSSO PIEGARE\nLO SPAZIO COME VOGLIO...[K] MA...", spanish="ES CIERTO QUE PUEDO ALTERAR\nEL ESPACIO A MI VOLUNTAD...[K] PERO..."})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="FOR THE FIRST TIME EVER, I AM\nUNABLE TO CONTROL A PART OF SPACE!", french="... POUR LA PREMIERE FOIS,\nUNE PARTIE DE L'ESPACE ECHAPPE A\nMON CONTROLE!", german="ZUM ERSTEN MAL ÜBERHAUPT\nKANN ICH EINEN TEIL DES RAUMES NICHT\nKONTROLLIEREN!", italian="... PER LA PRIMA VOLTA NELLA\nMIA VITA, NON RIESCO A CONTROLLARE UNA\nPARTE DELLO SPAZIO!", spanish="¡POR PRIMERA VEZ SOY\nINCAPAZ DE CONTROLAR UNA PARTE DEL\nESPACIO!"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="WORSE STILL, THE DISTORTION\nOF SPACE IS AMPLIFYING!", french="PIRE ENCORE, LA DISTORSION\nDE L'ESPACE PREND DE L'AMPLEUR!", german="UND NOCH SCHLIMMER: DIE\nVERZERRUNG DES RAUMES VERSTÄRKT SICH!", italian="E COME SE NON FOSSE\nABBASTANZA, LA DISTORSIONE DELLO SPAZIO\nSTA AUMENTANDO!", spanish="Y LO QUE ES AÚN PEOR, ¡LA\nDEFORMACIÓN SIGUE AUMENTANDO!"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" THIS IS ALL YOUR DOING!", french=" TOUT EST VOTRE FAUTE!", german=" DAS IST ALLES EUER WERK!", italian=" È TUTTA COLPA VOSTRA!", spanish=" ¡Y ES TODO CULPA VUESTRA!"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="THERE IS NOW BUT ONE WAY TO\nSAVE THE WORLD...", french="IL N'Y A PLUS QU'UN SEUL\nMOYEN DE SAUVER LE MONDE...", german="ES BLEIBT NUR NOCH EIN WEG,\nDIE WELT ZU RETTEN!", italian="ADESSO È RIMASTO UN SOLO\nMODO PER SALVARE IL MONDO...", spanish="SOLO HAY UNA FORMA DE\nSALVAR EL MUNDO..."})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="AND THAT IS FOR YOU TO BE\nERASED FROM THIS WORLD FOREVER!", french="ET C'EST DE VOUS FAIRE\nDISPARAITRE A JAMAIS DE CE MONDE!", german="UND DER SIEHT VOR, EUCH FÜR\nIMMER VON DIESER WELT ZU TILGEN!", italian="VALE A DIRE ELIMINARVI\nPER SEMPRE DA QUESTO PIANETA!", spanish="¡Y ES QUITAROS DE EN MEDIO\nDE UNA VEZ POR TODAS!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk...!", french=" Argh...!", german=" Uff!", italian=" Ugh...!", spanish=" ¡Glup!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk...!", french=" Argh...!", german=" Uff!", italian=" Ugh...!", spanish=" ¡Glup!"})
  else
  SkySceneKit.say({english=" Urk...!", french=" Argh...!", german=" Uff!", italian=" Ugh...!", spanish=" ¡Glup!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Palkia[CR] is saying exactly what\n[CS:N]Cresselia[CR] said...", french="Les dires de [CS:N]Palkia[CR] confirment\nl'histoire que nous a racontée [CS:N]Cresselia[CR]...", german="[CS:N]Palkia[CR] sagt exakt das Gleiche\nwie [CS:N]Cresselia[CR] vor ihm.", italian="[CS:N]Palkia[CR] sta ripetendo quello\nche ci ha detto [CS:N]Cresselia[CR].", spanish="[CS:N]Palkia[CR] está diciendo lo mismo\nque [CS:N]Cresselia[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Palkia[CR] is saying the same thing\n[CS:N]Cresselia[CR] said...", french="Les dires de [CS:N]Palkia[CR] confirment\nl'histoire que nous a racontée [CS:N]Cresselia[CR]...", german="[CS:N]Palkia[CR] sagt exakt das Gleiche\nwie [CS:N]Cresselia[CR] vor ihm.", italian="[CS:N]Palkia[CR] sta ripetendo quello\nche ci ha detto [CS:N]Cresselia[CR].", spanish="[CS:N]Palkia[CR] está diciendo lo mismo\nque [CS:N]Cresselia[CR]..."})
  else
  SkySceneKit.say({english="[CS:N]Palkia[CR] is saying the same thing\n[CS:N]Cresselia[CR] said...", french="Les dires de [CS:N]Palkia[CR] confirment\nl'histoire que nous a racontée [CS:N]Cresselia[CR]...", german="[CS:N]Palkia[CR] sagt exakt das Gleiche\nwie [CS:N]Cresselia[CR] vor ihm.", italian="[CS:N]Palkia[CR] sta ripetendo quello\nche ci ha detto [CS:N]Cresselia[CR].", spanish="[CS:N]Palkia[CR] está diciendo lo mismo\nque [CS:N]Cresselia[CR]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, [hero]...", french=" Oh, [hero]...", german=" Oh, [hero]...", italian=" Oh, [hero]...", spanish=" Oh, [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, [hero]...", french=" Oh, [hero]...", german=" Oh, [hero]...", italian=" Oh, [hero]...", spanish=" Oh, [hero]..."})
  else
  SkySceneKit.say({english=" Oh, [hero]...", french=" Oh, [hero]...", german=" Oh, [hero]...", italian=" Oh, [hero]...", spanish=" Oh, [hero]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What [CS:N]Cresselia[CR] told us was the\ntruth after all...", french="On dirait que [CS:N]Cresselia[CR] nous a\nbien dit la vérité...", german="Was uns [CS:N]Cresselia[CR] sagte, war\nletztendlich doch die Wahrheit...", italian="Allora [CS:N]Cresselia[CR] ci ha detto\nla verità...", spanish="Lo que [CS:N]Cresselia[CR] nos contó era\nverdad..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Cresselia[CR] was telling us the\ntruth after all...", french="On dirait que [CS:N]Cresselia[CR] nous a\nbien dit la vérité...", german="[CS:N]Cresselia[CR] sagte uns also doch die\nWahrheit...", italian="Allora [CS:N]Cresselia[CR] ci ha detto\nla verità...", spanish="Lo que [CS:N]Cresselia[CR] nos contó era\nverdad..."})
  else
  SkySceneKit.say({english="[CS:N]Cresselia[CR] told us the truth\nafter all...", french="On dirait que [CS:N]Cresselia[CR] nous a\nbien dit la vérité...", german="[CS:N]Cresselia[CR] sagte uns also doch die\nWahrheit...", italian="Allora [CS:N]Cresselia[CR] ci ha detto\nla verità...", spanish="Lo que [CS:N]Cresselia[CR] nos contó era\nverdad..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Maybe they're right about us...", french="Peut-être bien qu'ils ont raison\nà notre sujet...", german="Vielleicht haben sie recht mit\nuns...", italian=" Forse hanno ragione su di noi...", spanish=" Tal vez tengan razón..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Maybe they're right about us...", french="Peut-être bien qu'ils ont raison\nà notre sujet...", german="Vielleicht haben sie recht mit\nuns...", italian=" Forse hanno ragione su di noi...", spanish=" Tal vez tengan razón..."})
  else
  SkySceneKit.say({english=" Maybe they're right about us...", french="Peut-être bien qu'ils ont raison\nà notre sujet...", german="Vielleicht haben sie recht mit\nuns...", italian=" Forse hanno ragione su di noi...", spanish=" Tal vez tengan razón..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Maybe we do have to disappear.", french="Peut-être qu'il faut vraiment\nqu'on disparaisse.", german="Vielleicht müssen wir\nverschwinden.", italian=" Forse dobbiamo davvero sparire.", spanish=" Tal vez debamos desaparecer."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Maybe we do have to disappear.", french="Peut-être qu'il faut vraiment\nqu'on disparaisse.", german="Vielleicht müssen wir\nverschwinden.", italian=" Forse dobbiamo davvero sparire.", spanish=" Tal vez debamos desaparecer."})
  else
  SkySceneKit.say({english=" Maybe we do have to disappear.", french="Peut-être qu'il faut vraiment\nqu'on disparaisse.", german="Vielleicht müssen wir\nverschwinden.", italian=" Forse dobbiamo davvero sparire.", spanish=" Tal vez debamos desaparecer."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner]!)", french="([partner]!)", german="([partner]!)", italian="([partner]!)", spanish="(¡[partner]!)"})
  else
  SkySceneKit.say({english="([partner]!)", french="([partner]!)", german="([partner]!)", italian="([partner]!)", spanish="(¡[partner]!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" I FEEL SORRY FOR YOU.", french=" JE SUIS DESOLE POUR VOUS.", german=" ES TUT MIR LEID FÜR EUCH.", italian=" MI DISPIACE PER VOI.", spanish=" LO SIENTO."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_parukia, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_parukia, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="BUT THIS MUST BE DONE TO\nPRESERVE PEACE.[K] PLEASE UNDERSTAND.", french="MAIS C'EST LE SEUL MOYEN DE\nPRESERVER LA PAIX.[K] JE SUIS SUR QUE VOUS\nCOMPRENEZ.", german="DIES GESCHIEHT NUR UM DER\nERHALTUNG DES FRIEDENS WILLEN.[K]\nBITTE VERSTEHT DAS.", italian="MA È NECESSARIO PER\nRIPORTARE IL MONDO ALLA NORMALITÀ.[K]\nCERCATE DI CAPIRE.", spanish="PERO DEBO HACER ESTO PARA\nPRESERVAR LA PAZ.[K] ENTENDEDME."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]P-Palkia[CR]...", french=" [CS:N]P-Palkia[CR]...", german=" [CS:N]P-Palkia[CR]...", italian=" [CS:N]P-Palkia[CR]...", spanish=" [CS:N]Palkia[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]P-Palkia[CR]...", french=" [CS:N]P-Palkia[CR]...", german=" [CS:N]P-Palkia[CR]...", italian=" [CS:N]P-Palkia[CR]...", spanish=" [CS:N]Palkia[CR]..."})
  else
  SkySceneKit.say({english=" [CS:N]P-Palkia[CR]...", french=" [CS:N]P-Palkia[CR]...", german=" [CS:N]P-Palkia[CR]...", italian=" [CS:N]P-Palkia[CR]...", spanish=" [CS:N]Palkia[CR]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Ah, here you are...[K] I've found you at last.", french=" Ah, vous voilà...[K] enfin je vous trouve.", german="Ah, hier seid ihr ja...[K] Hab ich euch endlich\ngefunden.", italian="Ah, eccovi qui...[K] Finalmente\nsono riuscita a trovarvi.", spanish=" Ajá, aquí estáis...[K] Os he encontrado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5125) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:WaitFrames(60)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:FadeIn(15)
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 248, 176, Direction.Down, "NPC_KURESERIA")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_parukia, npc_npc_kureseria, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_parukia, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]C-Cresselia[CR]!", french=" [CS:N]C-Cresselia[CR]!", german=" [CS:N]C-Cresselia[CR]!", italian=" [CS:N]C-Cresselia[CR]!", spanish=" ¡[CS:N]Cresselia[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]C-Cresselia[CR]!", french=" [CS:N]C-Cresselia[CR]!", german=" [CS:N]C-Cresselia[CR]!", italian=" [CS:N]C-Cresselia[CR]!", spanish=" ¡[CS:N]Cresselia[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]C-Cresselia[CR]!", french=" [CS:N]C-Cresselia[CR]!", german=" [CS:N]C-Cresselia[CR]!", italian=" [CS:N]C-Cresselia[CR]!", spanish=" ¡[CS:N]Cresselia[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kureseria, Direction.DownLeft)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_kureseria, Direction.DownRight)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_kureseria, Direction.Down)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="The spreading darkness engulfs\neven this place!", french="L'ombre s'étend et n'épargne\nrien ni personne, pas même cet endroit!", german="Die sich ausbreitende Dunkelheit\nhat sogar diesen Ort verschlungen!", italian="L'oscurità avvolge anche questo\nluogo!", spanish="¡La oscuridad ha llegado incluso\nhasta aquí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_parukia, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_parukia.Position; GROUND:MoveToPosition(npc_npc_parukia, p.X+(16), p.Y+(16), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(npc_npc_parukia, Direction.Left)
  GROUND:MoveToPosition(npc_npc_parukia, 296, 240, false, 2) -- SlidePositionMark (glissement)
  do local p=npc_npc_kureseria.Position; GROUND:MoveToPosition(npc_npc_kureseria, p.X+(0), p.Y+(32), false, 2) end
  GROUND:EntTurn(npc_npc_parukia, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- GAP: BGM BGM_SEALED_RUIN_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="You must be eliminated as soon\nas possible...", french="Il faut vous éliminer au plus\nvite...", german="Ihr müsst so schnell wie\nmöglich aus dem Weg geräumt werden...", italian="Devo eliminarvi il prima\npossibile...", spanish="Hay que eliminaros lo antes\nposible..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_kureseria.Position; GROUND:MoveToPosition(npc_npc_kureseria, p.X+(0), p.Y+(16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(8), 10, false) end) -- MovePositionOffset performer/caméra
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Before we finally pass the point\nof no return.", french="... avant que nous n'atteignions\nle point de non-retour.", german="Auf jeden Fall bevor wir\nendgültig an den Punkt gelangen, an dem alles\nzu spät ist.", italian="Prima di oltrepassare il\npunto di non ritorno.", spanish="Antes de que el proceso sea\nirreversible."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_kureseria.Position; GROUND:MoveToPosition(npc_npc_kureseria, p.X+(0), p.Y+(16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(8), 10, false) end) -- MovePositionOffset performer/caméra
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk... [hero]...", french=" Argh... [hero]...", german=" Uff! [hero]...", italian=" Ugh... [hero]...", spanish=" Uf... [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk... [hero]...", french=" Argh... [hero]...", german=" Uff! [hero]...", italian=" Ugh... [hero]...", spanish=" Uf... [hero]..."})
  else
  SkySceneKit.say({english=" Urk... [hero]...", french=" Argh... [hero]...", german=" Uff! [hero]...", italian=" Ugh... [hero]...", spanish=" Uf... [hero]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We refused to give up. We did\nwhat we could.", french="On a toujours fait de notre\nmieux, sans jamais se laisser abattre.", german="Wir gaben nicht auf. Wir haben\ngetan, was wir konnten.", italian="Non abbiamo ceduto. Abbiamo\nfatto il possibile.", spanish="No nos rendimos. Hicimos todo\nlo que pudimos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We refused to give up. We did\nwhat we could.", french="On a toujours fait de notre\nmieux, sans jamais se laisser abattre.", german="Wir gaben nicht auf. Wir haben\ngetan, was wir konnten.", italian="Non abbiamo ceduto. Abbiamo\nfatto il possibile.", spanish="No nos rendimos. Hicimos todo\nlo que pudimos."})
  else
  SkySceneKit.say({english="We refused to give up. We did\nwhat we could.", french="On a toujours fait de notre\nmieux, sans jamais se laisser abattre.", german="Wir gaben nicht auf. Wir haben\ngetan, was wir konnten.", italian="Non abbiamo ceduto. Abbiamo\nfatto il possibile.", spanish="No nos rendimos. Hicimos todo\nlo que pudimos."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_kureseria.Position; GROUND:MoveToPosition(npc_npc_kureseria, p.X+(0), p.Y+(8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(8), 10, false) end) -- MovePositionOffset performer/caméra
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="After everything we did...[K]\nwas it all for nothing?", french="Tous ces efforts...[K] C'était\nen vain?", german="Nach allem, was wir getan\nhaben,[K] war alles umsonst?", italian="Quello che abbiamo fatto...[K] è\nstato tutto invano?", spanish="Y parece que al final...[K] todo ha\nsido en vano..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="After everything we did...[K]\nwas it all for nothing?", french="Tous ces efforts...[K] C'était\nen vain?", german="Nach allem, was wir getan\nhaben,[K] war alles umsonst?", italian="Quello che abbiamo fatto...[K] è\nstato tutto invano?", spanish="Y parece que al final...[K] todo ha\nsido en vano..."})
  else
  SkySceneKit.say({english="After everything we did...[K]\nwas it all for nothing?", french="Tous ces efforts...[K] C'était\nen vain?", german="Nach allem, was wir getan\nhaben,[K] war alles umsonst?", italian="Quello che abbiamo fatto...[K] è\nstato tutto invano?", spanish="Y parece que al final...[K] todo ha\nsido en vano..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_kureseria.Position; GROUND:MoveToPosition(npc_npc_kureseria, p.X+(0), p.Y+(8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(8), 10, false) end) -- MovePositionOffset performer/caméra
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Was all our effort...[K]a waste?", french="Tout ce qu'on a fait...[K] n'a donc\nservi à rien?", german="War all unsere Mühe...[K]\nvollkommen umsonst?", italian="Tutti i nostri sforzi...[K] sono\nstati inutili?", spanish="Todos nuestros esfuerzos...[K]\n¿No han servido para nada?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Was all our effort...[K]a waste?", french="Tout ce qu'on a fait...[K] n'a donc\nservi à rien?", german="War all unsere Mühe...[K]\nvollkommen umsonst?", italian="Tutti i nostri sforzi...[K] sono\nstati inutili?", spanish="Todos nuestros esfuerzos...[K]\n¿No han servido para nada?"})
  else
  SkySceneKit.say({english=" Was all our effort...[K]a waste?", french="Tout ce qu'on a fait...[K] n'a donc\nservi à rien?", german="War all unsere Mühe...[K]\nvollkommen umsonst?", italian="Tutti i nostri sforzi...[K] sono\nstati inutili?", spanish="Todos nuestros esfuerzos...[K]\n¿No han servido para nada?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_kureseria.Position; GROUND:MoveToPosition(npc_npc_kureseria, p.X+(0), p.Y+(8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" So are you ready for your end?", french=" Alors, peut-on en finir?", german="Seid ihr jetzt bereit für euer\nEnde?", italian="Avete altro da dire prima di\nsparire?", spanish=" Preparaos para desaparecer."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk... [CS:N]Cresselia[CR]...[K] One moment!", french=" Argh... [CS:N]Cresselia[CR]...[K] Un instant!", german=" Uff! [CS:N]Cresselia[CR]...[K] Einen Moment!", italian=" Ah... [CS:N]Cresselia[CR]...[K] Un attimo!", spanish=" Hum... [CS:N]Cresselia[CR]...[K] ¡Un momento!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk... [CS:N]Cresselia[CR]...[K] One moment!", french=" Argh... [CS:N]Cresselia[CR]...[K] Un instant!", german=" Uff! [CS:N]Cresselia[CR]...[K] Einen Moment!", italian=" Ah... [CS:N]Cresselia[CR]...[K] Un attimo!", spanish=" Hum... [CS:N]Cresselia[CR]...[K] ¡Un momento!"})
  else
  SkySceneKit.say({english=" Urk... [CS:N]Cresselia[CR]...[K] One moment!", french=" Argh... [CS:N]Cresselia[CR]...[K] Un instant!", german=" Uff! [CS:N]Cresselia[CR]...[K] Einen Moment!", italian=" Uh... [CS:N]Cresselia[CR]...[K] Un attimo!", spanish=" Hum... [CS:N]Cresselia[CR]...[K] ¡Un momento!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Tell us one last thing.", french=" Juste une dernière chose.", german="Sag uns noch eines zum\nAbschluss.", italian=" Dicci un'ultima cosa.", spanish=" Una última cosa."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Tell us one last thing.", french=" Juste une dernière chose.", german="Sag uns noch eines zum\nAbschluss.", italian=" Dicci un'ultima cosa.", spanish=" Una última cosa."})
  else
  SkySceneKit.say({english=" Tell us one last thing.", french=" Juste une dernière chose.", german="Sag uns noch eines zum\nAbschluss.", italian=" Dicci un'ultima cosa.", spanish=" Una última cosa."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If we disappear...[K]will the world\nreally and truly be saved?", french="Si on disparaît...[K] Est-ce que\nle monde sera sauvé pour de bon?", german="Falls wir verschwänden...[K] Wäre\ndie Welt dann wirklich gerettet?", italian="Se sparissimo...[K] il mondo si\nsalverebbe davvero?", spanish="Si desaparecemos...[K] ¿se salvará\nel mundo de verdad?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If we disappear...[K]will the world\nreally and truly be saved?", french="Si on disparaît...[K] Est-ce que\nle monde sera sauvé pour de bon?", german="Falls wir verschwänden...[K] Wäre\ndie Welt dann wirklich gerettet?", italian="Se sparissimo...[K] il mondo si\nsalverebbe davvero?", spanish="Si desaparecemos...[K] ¿se salvará\nel mundo de verdad?"})
  else
  SkySceneKit.say({english="If we disappear...[K]will the world\nreally and truly be saved?", french="Si on disparaît...[K] Est-ce que\nle monde sera sauvé pour de bon?", german="Falls wir verschwänden...[K] Wäre\ndie Welt dann wirklich gerettet?", italian="Se sparissimo...[K] il mondo si\nsalverebbe davvero?", spanish="Si desaparecemos...[K] ¿se salvará\nel mundo de verdad?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Yes.[K] It absolutely will.", french=" Oui.[K] C'est sûr et certain.", german=" Ja.[K] Ein absolutes Ja.", italian=" Sì.[K] Certamente.", spanish=" Sí.[K] Por supuesto."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="The world will be saved.\nIt's beyond a shadow of a doubt.", french="Le monde sera sauvé, sans\nl'ombre d'un doute.", german="Die Welt wäre gerettet, daran\nbesteht nicht der Hauch eines Zweifels.", italian="Il mondo si salverà,\nè una cosa assolutamente certa.", spanish="El mundo se salvará, sin lugar\na dudas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Are you finally satisfied?", french=" Cela suffit-il à votre bonheur?", german=" Seid ihr endlich zufrieden?", italian=" È tutto?", spanish=" ¿Os satisface mi respuesta?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[K]Yes.", french=" ...[K] Oui.", german=" ...[K]Ja.", italian=" ...[K] Sì.", spanish=" Pues...[K] sí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[K]Yes.", french=" ...[K] Oui.", german=" ...[K]Ja.", italian=" ...[K] Sì.", spanish=" Pues...[K] sí."})
  else
  SkySceneKit.say({english=" ...[K]Yes.", french=" ...[K] Oui.", german=" ...[K]Ja.", italian=" ...[K] Sì.", spanish=" Pues...[K] sí."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If we must...[K] If we really must\ndisappear...", french="S'il faut...[K] s'il faut vraiment\nqu'on disparaisse...", german="Wenn wir es müssen...[K] Wenn\nwir wirklich verschwinden müssen...", italian="Se dobbiamo...[K] Se dobbiamo\ndavvero sparire...", spanish="Si debemos...[K] Si realmente\ndebemos desaparecer..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If we must...[K] If we really must\ndisappear...", french="S'il faut...[K] s'il faut vraiment\nqu'on disparaisse...", german="Wenn wir es müssen...[K] Wenn\nwir wirklich verschwinden müssen...", italian="Se dobbiamo...[K] Se dobbiamo\ndavvero sparire...", spanish="Si debemos...[K] Si realmente\ndebemos desaparecer..."})
  else
  SkySceneKit.say({english="If we must...[K] If we really must\ndisappear...", french="S'il faut...[K] s'il faut vraiment\nqu'on disparaisse...", german="Wenn wir es müssen...[K] Wenn\nwir wirklich verschwinden müssen...", italian="Se dobbiamo...[K] Se dobbiamo\ndavvero sparire...", spanish="Si debemos...[K] Si realmente\ndebemos desaparecer..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" If that will save the world...", french="... si c'est le seul moyen\nde sauver le monde...", german=" Wenn das die Welt retten wird...", italian="Se è necessario per salvare il\nmondo...", spanish="Si, con eso, se va a salvar el\nmundo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" If that will save the world...", french="... si c'est le seul moyen\nde sauver le monde...", german=" Wenn das die Welt retten wird...", italian="Se è necessario per salvare il\nmondo...", spanish="Si, con eso, se va a salvar el\nmundo..."})
  else
  SkySceneKit.say({english=" If that will save the world...", french="... si c'est le seul moyen\nde sauver le monde...", german=" Wenn das die Welt retten wird...", italian="Se è necessario per salvare il\nmondo...", spanish="Si, con eso, se va a salvar el\nmundo..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...[K]After so much...)", french="(...[K] Après toutes ces épreuves...)", german="(...[K]Nach all diesen Taten...)", italian="(...[K] Dopo tutto quello che è successo...)", spanish="(Después de...[K] Después de todo...)"})
  else
  SkySceneKit.say({english="(...[K]After so much...)", french="(...[K] Après toutes ces épreuves...)", german="(...[K]Nach all diesen Taten...)", italian="(...[K] Dopo tutto quello che è successo...)", spanish="(Después de...[K] Después de todo...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner]'s will...[K]is starting to sway.)", french="(... la volonté de [partner]...[K] commence\nà être ébranlée.)", german="(Und nach all dieser Zeit, verliert\n[partner][K] seinen Willen...)", italian="(Ora la volontà di [partner]...[K] sta\niniziando a cedere.)", spanish="(La determinación de [partner]...[K] empieza\na tambalearse...)"})
  else
  SkySceneKit.say({english="([partner]'s will...[K]is starting to sway.)", french="(... la volonté de [partner]...[K] commence\nà être ébranlée.)", german="(Und nach all dieser Zeit, verliert\n[partner][K] seinen Willen...)", italian="(Ora la volontà di [partner]...[K] sta\niniziando a cedere.)", spanish="(La determinación de [partner]...[K] empieza\na tambalearse...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(And...[K]so is mine...)", french="(Et...[K] la mienne aussi...)", german="(Und[K] auch mir geht es nicht anders...)", italian="(E...[K] anche la mia.)", spanish="(Y...[K] la mía también...)"})
  else
  SkySceneKit.say({english="(And...[K]so is mine...)", french="(Et...[K] la mienne aussi...)", german="(Und[K] auch mir geht es nicht anders...)", italian="(E...[K] anche la mia.)", spanish="(Y...[K] la mía también...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But is this...[K]truly and absolutely the\ncorrect course of action?)", french="(Mais est-ce...[K] vraiment la bonne solution?)", german="(Aber ist das wirklich[K] das absolut richtige\nVorgehen?)", italian="(Ma è davvero questo...[K] il modo migliore\nper risolvere la situazione?)", spanish="(Pero...[K] ¿será este de verdad el curso\ncorrecto de los acontecimientos?)"})
  else
  SkySceneKit.say({english="(But is this...[K]truly and absolutely the\ncorrect course of action?)", french="(Mais est-ce...[K] vraiment la bonne solution?)", german="(Aber ist das wirklich[K] das absolut richtige\nVorgehen?)", italian="(Ma è davvero questo...[K] il modo migliore\nper risolvere la situazione?)", spanish="(Pero...[K] ¿será este de verdad el curso\ncorrecto de los acontecimientos?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" WAIT, [CS:N]CRESSELIA[CR].", french=" ATTENDS, [CS:N]CRESSELIA[CR].", german=" WARTE, [CS:N]CRESSELIA[CR].", italian=" ASPETTA, [CS:N]CRESSELIA[CR].", spanish=" ESPERA, [CS:N]CRESSELIA[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="BLINDED BY FURY, I ATTACKED\nTHEM EARLIER...", french="JE M'EN SUIS PRIS A EUX\nAUPARAVANT, ALORS QUE J'ETAIS AVEUGLE\nPAR LA RAGE...", german="ICH WAR BLIND VOR WUT, ALS\nICH DIE BEIDEN VORHIN ANGRIFF...", italian="ACCECATO DALLA FURIA, PRIMA\nHO ATTACCATO...", spanish="ANTES LANCÉ MI ATAQUE\nCEGADO POR LA FURIA..."})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" BUT, UPON SEEING THEM NOW...", french="... MAIS COMME JE LES VOIS\nMAINTENANT...", german=" ABER JETZT, DA ICH SIE SEHE...", italian="MA ORA CHE GUARDO MEGLIO\nQUESTI POKÉMON...", spanish=" PERO AHORA VEO..."})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="THEY DO NOT SEEM DRIVEN BY\nMALICE OR WICKEDNESS.", french="... CES POKEMON NE SEMBLENT\nPAS ANIMES DE MAUVAISES INTENTIONS.", german="SIE SCHEINEN NICHT VON\nBOSHEIT ODER NIEDERTRACHT GETRIEBEN ZU\nSEIN.", italian="NON MI SEMBRANO SPINTI\nDALLA CATTIVERIA O DALLA MALVAGITÀ.", spanish="QUE NO SE GUÍAN POR MALDAD\nNI NADA PARECIDO."})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="IN MY DREAMS, [CS:N]CRESSELIA[CR],\nYOU INSISTED THAT THEY WERE BAD...", french="[CS:N]CRESSELIA[CR], DANS MES REVES,\nTU AS BIEN INSISTE SUR LEUR MECHANCETE...", german="IN MEINEN TRÄUMEN,\n[CS:N]CRESSELIA[CR], BESTANDEST DU DARAUF, DASS\nSIE BÖSE SEIEN...", italian="NEI MIEI SOGNI, [CS:N]CRESSELIA[CR],\nMI DICEVI CHE ERANO CATTIVI...", spanish="[CS:N]CRESSELIA[CR], EN MIS SUEÑOS\nINSISTÍAS EN QUE ERAN POKÉMON MALVADOS."})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" BUT ARE THEY TRULY BAD?", french="MAIS SONT-ILS VRAIMENT\nMECHANTS?", german=" ABER SIND SIE WIRKLICH BÖSE?", italian=" MA LO SONO DAVVERO?", spanish=" ¿PERO LO SON DE VERDAD?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:N]C-Cresselia[CR] said that about us?![K] In [CS:N]Palkia[CR]'s\ndreams?!)", french="([CS:N]C-Cresselia[CR] a vraiment dit ça de nous?![K]\nDans les rêves de [CS:N]Palkia[CR]?!)", german="([CS:N]C-Cresselia[CR] hat das über uns gesagt?!?[K]\nIn den Träumen von [CS:N]Palkia[CR]?!?)", italian="([CS:N]C-Cresselia[CR] ha detto questo di noi?![K] L'ha\ndetto a [CS:N]Palkia[CR] in sogno?!)", spanish="(¿[CS:N]Cresselia[CR] dijo eso?[K] ¿En los sueños de\n[CS:N]Palkia[CR]?)"})
  else
  SkySceneKit.say({english="([CS:N]C-Cresselia[CR] said that about us?![K] In [CS:N]Palkia[CR]'s\ndreams?!)", french="([CS:N]C-Cresselia[CR] a vraiment dit ça de nous?![K]\nDans les rêves de [CS:N]Palkia[CR]?!)", german="([CS:N]C-Cresselia[CR] hat das über uns gesagt?!?[K]\nIn den Träumen von [CS:N]Palkia[CR]?!?)", italian="([CS:N]C-Cresselia[CR] ha detto questo di noi?![K] L'ha\ndetto a [CS:N]Palkia[CR] in sogno?!)", spanish="(¿[CS:N]Cresselia[CR] dijo eso?[K] ¿En los sueños de\n[CS:N]Palkia[CR]?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Don't be fooled by appearances,\n[CS:N]Palkia[CR].", french="Ne te laisse pas abuser par\nles apparences, [CS:N]Palkia[CR].", german="Lass dich nicht von\nÄußerlichkeiten täuschen, [CS:N]Palkia[CR].", italian="Non farti ingannare dalle\napparenze, [CS:N]Palkia[CR].", spanish="Que no te engañen las\napariencias, [CS:N]Palkia[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="If we get rid of them now...[K]\nall will be saved.", french="Si nous nous en débarrassons\nmaintenant...[K] c'est le monde entier que\nnous sauverons.", german="Wenn wir sie jetzt loswerden...[K]\nDann sind wir alle gerettet.", italian="Se ci sbarazziamo di loro\nadesso...[K] il mondo si salverà.", spanish="Todo se salvará...[K] si acabamos\ncon estos Pokémon."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(So, just like we did, [CS:N]Palkia[CR] met [CS:N]Cresselia[CR] in\nhis dreams...)", french="(Alors tout comme nous, [CS:N]Palkia[CR] a rencontré\n[CS:N]Cresselia[CR] en rêve...)", german="(Dann hat auch [CS:N]Palkia[CR] [CS:N]Cresselia[CR] in\nseinen Träumen getroffen...)", italian="(Allora, proprio come noi, [CS:N]Palkia[CR] ha incontrato\n[CS:N]Cresselia[CR] nei suoi sogni.)", spanish="(Así que también [CS:N]Palkia[CR] se encontró con\n[CS:N]Cresselia[CR] en sus sueños...)"})
  else
  SkySceneKit.say({english="(So, just like we did, [CS:N]Palkia[CR] met [CS:N]Cresselia[CR] in\nhis dreams...)", french="(Alors tout comme nous, [CS:N]Palkia[CR] a rencontré\n[CS:N]Cresselia[CR] en rêve...)", german="(Dann hat auch [CS:N]Palkia[CR] [CS:N]Cresselia[CR] in\nseinen Träumen getroffen...)", italian="(Allora, proprio come noi, [CS:N]Palkia[CR] ha incontrato\n[CS:N]Cresselia[CR] nei suoi sogni.)", spanish="(Así que también [CS:N]Palkia[CR] se encontró con\n[CS:N]Cresselia[CR] en sus sueños...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But now [CS:N]Palkia[CR] is growing suspicious...[K]\nSomething is very wrong here!)", french="(Mais on dirait que [CS:N]Palkia[CR] a des doutes...[K]\nDécidément, il y a quelque chose qui cloche!)", german="(Aber jetzt wird [CS:N]Palkia[CR] misstrauisch...[K]\nIrgendetwas stimmt hier absolut nicht!)", italian="(Ma adesso [CS:N]Palkia[CR] sta iniziando ad avere\ndei sospetti...[K] Qui c'è qualcosa che non va!)", spanish="(Pero ahora [CS:N]Palkia[CR] empieza a sospechar...[K]\n¡Aquí pasa algo raro!)"})
  else
  SkySceneKit.say({english="(But now [CS:N]Palkia[CR] is growing suspicious...[K]\nSomething is very wrong here!)", french="(Mais on dirait que [CS:N]Palkia[CR] a des doutes...[K]\nDécidément, il y a quelque chose qui cloche!)", german="(Aber jetzt wird [CS:N]Palkia[CR] misstrauisch...[K]\nIrgendetwas stimmt hier absolut nicht!)", italian="(Ma adesso [CS:N]Palkia[CR] sta iniziando ad avere\ndei sospetti...[K] Qui c'è qualcosa che non va!)", spanish="(Pero ahora [CS:N]Palkia[CR] empieza a sospechar...[K]\n¡Aquí pasa algo raro!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(All this is based on what [CS:N]Cresselia[CR] claims!)", french="(Toute cette histoire ne repose que sur\nles affirmations de [CS:N]Cresselia[CR]!)", german="(All das basiert auf den Behauptungen\nvon [CS:N]Cresselia[CR]!)", italian="(Tutto si basa sulle affermazioni\ndi [CS:N]Cresselia[CR]!)", spanish="(¡Todo esto se basa en las afirmaciones de\n[CS:N]Cresselia[CR]!)"})
  else
  SkySceneKit.say({english="(All this is based on what [CS:N]Cresselia[CR] claims!)", french="(Toute cette histoire ne repose que sur\nles affirmations de [CS:N]Cresselia[CR]!)", german="(All das basiert auf den Behauptungen\nvon [CS:N]Cresselia[CR]!)", italian="(Tutto si basa sulle affermazioni\ndi [CS:N]Cresselia[CR]!)", spanish="(¡Todo esto se basa en las afirmaciones de\n[CS:N]Cresselia[CR]!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Enough! I will be rid of you now!", french="Cela suffit! Je m'en vais vous\néliminer!", german="Das reicht! Ich werde euch\njetzt beseitigen!", italian="Basta così! Adesso mi\nsbarazzerò di voi!", spanish=" ¡Basta! ¡Acabaré con esto ahora!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner]!)", french="([partner]!)", german="([partner]!)", italian="([partner]!)", spanish="(¡[partner]!)"})
  else
  SkySceneKit.say({english="([partner]!)", french="([partner]!)", german="([partner]!)", italian="([partner]!)", spanish="(¡[partner]!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Don't abandon hope!)", french="(Garde espoir!)", german="(Nicht die Hoffnung aufgeben!)", italian="(Non disperare!)", spanish="(¡No pierdas la esperanza!)"})
  else
  SkySceneKit.say({english="(Don't abandon hope!)", french="(Garde espoir!)", german="(Nicht die Hoffnung aufgeben!)", italian="(Non disperare!)", spanish="(¡No pierdas la esperanza!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Now take this!", french=" Prenez ça!", german=" Nehmt das!", italian=" Prendete questo!", spanish=" ¡Ahora veréis!"})
  -- message_Close
  -- SetAnimation(12) [anim idle native]
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 5)
  SkySceneKit.cleanup_npcs()
end
