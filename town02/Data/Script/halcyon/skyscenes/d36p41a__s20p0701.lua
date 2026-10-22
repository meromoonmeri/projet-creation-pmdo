-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D36P41A/s20p0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(62, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  SkyProg.set(29, 75) -- $SCENARIO_MAIN = scn[29,75] (ROM)
  -- back_SetGround(LEVEL_D36P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(partner, 236, 292, false, 2)
  GROUND:MoveToPosition(hero, 268, 292, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey!", french=" Hé!", german=" Hey!", italian=" Ehi!", spanish=" ¡Oye!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey!", french=" Hé!", german=" Hey!", italian=" Ehi!", spanish=" ¡Oye!"})
  else
  SkySceneKit.say({english=" Oh!", french=" Hé!", german=" Oh!", italian=" Oh!", spanish=" ¡Eh!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Isn't that [CS:N]Drowzee[CR] over there?!", french=" Ce n'est pas [CS:N]Soporifik[CR] là-bas?!", german=" Ist das dort nicht [CS:N]Traumato[CR]?!?", italian=" Quello laggiù non è [CS:N]Drowzee[CR]?", spanish=" ¡¿No es ese [CS:N]Drowzee[CR]?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Isn't that [CS:N]Drowzee[CR] there?!", french=" Ce n'est pas [CS:N]Soporifik[CR] là-bas?!", german="Ist das dort drüben nicht\n[CS:N]Traumato[CR]?!?", italian=" Quello laggiù non è [CS:N]Drowzee[CR]?", spanish=" ¡¿No es ese [CS:N]Drowzee[CR]?!"})
  else
  SkySceneKit.say({english=" Isn't that [CS:N]Drowzee[CR] there?!", french=" Ce n'est pas [CS:N]Soporifik[CR] là-bas?!", german="Ist das dort drüben nicht\n[CS:N]Traumato[CR]?!?", italian=" Quello laggiù non è [CS:N]Drowzee[CR]?", spanish=" ¡¿No es ese [CS:N]Drowzee[CR]?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(252, 172, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(partner, 236, 188, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(hero, 268, 188, false, 2)
  GAME:WaitFrames(5)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Drowzee[CR]!", french=" [CS:N]Soporifik[CR]!", german=" [CS:N]Traumato[CR]!", italian=" [CS:N]Drowzee[CR]!", spanish=" ¡[CS:N]Drowzee[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Drowzee[CR]!", french=" [CS:N]Soporifik[CR]!", german=" [CS:N]Traumato[CR]!", italian=" [CS:N]Drowzee[CR]!", spanish=" ¡[CS:N]Drowzee[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]Drowzee[CR]!", french=" [CS:N]Soporifik[CR]!", german=" [CS:N]Traumato[CR]!", italian=" [CS:N]Drowzee[CR]!", spanish=" ¡[CS:N]Drowzee[CR]!"})
  end
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  local npc_npc_suriipu = SkySceneKit.spawn_npc("drowzee", 256, 152, Direction.Up, "NPC_SURIIPU")
  pcall(function() GROUND:CharSetEmote(npc_npc_suriipu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_suriipu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_suriipu, "sweating", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Wa-wah! You two?!", french=" Wouah! Vous deux?", german=" Ua-aah! Ihr zwei?!?", italian=" Wa-wah! Voi due?!", spanish=" ¡¿Pero qué hacéis aquí?!"})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" What did you come here for?!", french=" Qu'est-ce que vous faites là?", german="Warum seid ihr\nhierhergekommen?!?", italian=" Perché siete qui?!", spanish=" ¿A qué habéis venido?"})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="I... I've kept my nose clean! I've\nstayed out of a life of crime!", french="Je... j'ai fait amende honorable!\nJ'ai renié ma vie de criminel!", german="Ich... Ich habe meine Finger aus\nallem herausgehalten! Ich habe dem kriminellen\nLeben abgeschworen!", italian="Io... ho le mani pulite! Non ho\ncommesso altri crimini!", spanish="Estoy... ¡estoy limpio!\n¡No he cometido ningún delito!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa! Hold up, [CS:N]Drowzee[CR].", french=" Allons! Du calme, [CS:N]Soporifik[CR].", german=" Holla! Mal langsam, [CS:N]Traumato[CR].", italian=" Whoa! Calma, [CS:N]Drowzee[CR].", spanish=" ¡Oye! Espera, [CS:N]Drowzee[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" W-wait! That's not it, [CS:N]Drowzee[CR].", french=" Allons! Du calme, [CS:N]Soporifik[CR].", german="W-warte! Darum geht es nicht,\n[CS:N]Traumato[CR].", italian="A-Aspetta! Non siamo qui per\nquesto, [CS:N]Drowzee[CR].", spanish=" ¡Oye! No es eso, [CS:N]Drowzee[CR]."})
  else
  SkySceneKit.say({english="W-wait! Please listen,\n[CS:N]Drowzee[CR]!", french=" Allons! Du calme, [CS:N]Soporifik[CR].", german="W-warte! Hör erst mal zu,\n[CS:N]Traumato[CR]!", italian="A-Aspetta! Ascoltaci per favore,\n[CS:N]Drowzee[CR].", spanish=" ¡Oye! Espera, [CS:N]Drowzee[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We didn't come here to arrest\nyou, [CS:N]Drowzee[CR].", french="Nous ne sommes pas là pour\nt'arrêter.", german="Wir sind nicht gekommen, um\ndich festzunehmen, [CS:N]Traumato[CR].", italian="Non siamo qui per arrestarti,\n[CS:N]Drowzee[CR].", spanish="No hemos venido a arrestarte,\n[CS:N]Drowzee[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're not here to arrest you,\n[CS:N]Drowzee[CR].", french="Nous ne sommes pas là pour\nt'arrêter.", german="Wir sind nicht hier, um dich zu\nverhaften, [CS:N]Traumato[CR].", italian="Non siamo qui per arrestarti,\n[CS:N]Drowzee[CR].", spanish="No hemos venido a arrestarte,\n[CS:N]Drowzee[CR]."})
  else
  SkySceneKit.say({english="We didn't climb here to catch\nyou, [CS:N]Drowzee[CR].", french="Nous ne sommes pas là pour\nt'arrêter.", german="Wir sind nicht hier\nhochgeklettert, um dich zu fangen,\n[CS:N]Traumato[CR].", italian="Non siamo qui per arrestarti,\n[CS:N]Drowzee[CR].", spanish="No hemos venido a arrestarte,\n[CS:N]Drowzee[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But we did come for you.\nWe need your help, [CS:N]Drowzee[CR].", french="Mais pour te demander un\nservice. Nous avons besoin de ton aide,\n[CS:N]Soporifik[CR].", german="Aber wir wollten schon zu dir.\nWir brauchen deine Hilfe, [CS:N]Traumato[CR].", italian="Ma volevamo trovarti.\nAbbiamo bisogno del tuo aiuto, [CS:N]Drowzee[CR].", spanish="Pero sí que te estábamos\nbuscando. Necesitamos tu ayuda,\n[CS:N]Drowzee[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But we are here for you.\nWe need your help, [CS:N]Drowzee[CR].", french="Mais pour te demander un\nservice. Nous avons besoin de ton aide,\n[CS:N]Soporifik[CR].", german="Aber wir wollten dich treffen.\nWir brauchen deine Hilfe, [CS:N]Traumato[CR].", italian="Ma volevamo trovarti.\nAbbiamo bisogno del tuo aiuto, [CS:N]Drowzee[CR].", spanish="Pero sí que te estábamos\nbuscando. Necesitamos tu ayuda,\n[CS:N]Drowzee[CR]."})
  else
  SkySceneKit.say({english="But we did come here for you.\nWe need your help, [CS:N]Drowzee[CR].", french="Mais pour te demander un\nservice. Nous avons besoin de ton aide,\n[CS:N]Soporifik[CR].", german="Aber wir wollten schon zu dir.\nWir brauchen deine Hilfe, [CS:N]Traumato[CR].", italian="Ma volevamo trovarti.\nAbbiamo bisogno del tuo aiuto, [CS:N]Drowzee[CR].", spanish="Pero sí que te estábamos\nbuscando. Necesitamos tu ayuda,\n[CS:N]Drowzee[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_suriipu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" H-huh? Me?[K] You need my help?", french="Hein? Vraiment?[K]\nVous avez besoin de mon aide?", german="H-hä? Meine Hilfe?[K] Ihr braucht\nmeine Hilfe?", italian="E-Eh? Di me?[K] Avete\nbisogno di me?", spanish="¿Me buscabais?[K] ¿Necesitáis\nmi ayuda?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yup.[K] You remember that little\n[CS:N]Azurill[CR], right?", french="Oui.[K] Tu te souviens du petit\n[CS:N]Azurill[CR], n'est-ce pas?", german="Jep.[K] Du erinnerst dich doch an\nden kleinen [CS:N]Azurill[CR], oder?", italian="Già.[K] Ti ricordi del piccolo\n[CS:N]Azurill[CR], vero?", spanish="Sí.[K] Te acuerdas de [CS:N]Azurill[CR],\n¿verdad?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yes.[K] You remember that little\n[CS:N]Azurill[CR], right?", french="Oui.[K] Tu te souviens du petit\n[CS:N]Azurill[CR], n'est-ce pas?", german="Ja.[K] Erinnerst du dich noch an den\nkleinen [CS:N]Azurill[CR]?", italian="Sì.[K] Ti ricordi del piccolo\n[CS:N]Azurill[CR], vero?", spanish="Sí.[K] Te acuerdas de [CS:N]Azurill[CR],\n¿verdad?"})
  else
  SkySceneKit.say({english="Yep.[K] You remember that little\n[CS:N]Azurill[CR], right?", french="Oui.[K] Tu te souviens du petit\n[CS:N]Azurill[CR], n'est-ce pas?", german="Jep.[K] Du erinnerst dich doch an\nden kleinen [CS:N]Azurill[CR], oder?", italian="Già.[K] Ti ricordi del piccolo\n[CS:N]Azurill[CR], vero?", spanish="Sí.[K] Te acuerdas de [CS:N]Azurill[CR],\n¿verdad?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That [CS:N]Azurill[CR] has fallen asleep\nand won't wake up.", french="[CS:N]Azurill[CR] est tombé dans un\nprofond sommeil et il ne peut pas se réveiller.", german="[CS:N]Azurill[CR] ist eingeschlafen und\nwacht nicht mehr auf.", italian="[CS:N]Azurill[CR] si è addormentato e\nnon riusciamo a svegliarlo.", spanish="[CS:N]Azurill[CR] está dormido y no\nlogra despertarse."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That [CS:N]Azurill[CR] has been locked in\nsleep and won't wake up.", french="[CS:N]Azurill[CR] est tombé dans un\nprofond sommeil et il ne peut pas se réveiller.", german="[CS:N]Azurill[CR] ist in seinem Schlaf\ngefangen und wacht nicht mehr auf.", italian="[CS:N]Azurill[CR] è imprigionato nel\nsonno e non riusciamo a svegliarlo.", spanish="[CS:N]Azurill[CR] está dormido y no\nlogra despertarse."})
  else
  SkySceneKit.say({english="That [CS:N]Azurill[CR] has been sleeping\nfor days and won't wake up.", french="[CS:N]Azurill[CR] est tombé dans un\nprofond sommeil et il ne peut pas se réveiller.", german="[CS:N]Azurill[CR] schläft seit Tagen und\nwacht nicht mehr auf.", italian="[CS:N]Azurill[CR] dorme da giorni e\nnon riusciamo a svegliarlo.", spanish="[CS:N]Azurill[CR] está dormido y no\nlogra despertarse."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_suriipu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Huh? That [CS:N]Azurill[CR] tyke?", french=" Hein? [CS:N]Azurill[CR]? Le môme?", german=" Dieser [CS:N]Azurill[CR]-Bengel?", italian=" Eh? Quella birba di [CS:N]Azurill[CR]?", spanish=" ¿Qué? ¿Ese jovenzuelo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="No one knows why he won't\nwake up.", french="Personne ne sait pourquoi il\nne se réveille pas.", german="Niemand weiß, warum er\nnicht aufwacht.", italian="Nessuno sa perché non si\nsvegli.", spanish="Nadie sabe por qué no se\ndespierta."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="No one knows why he won't\nwake up.", french="Personne ne sait pourquoi il\nne se réveille pas.", german="Niemand weiß, warum er\nnicht aufwacht.", italian="Nessuno sa perché non si\nsvegli.", spanish="Nadie sabe por qué no se\ndespierta."})
  else
  SkySceneKit.say({english="No one knows why he won't\nwake up.", french="Personne ne sait pourquoi il\nne se réveille pas.", german="Niemand weiß, warum er\nnicht aufwacht.", italian="Nessuno sa perché non si\nsvegli.", spanish="Nadie sabe por qué no se\ndespierta."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's when we heard that you,\n[CS:N]Drowzee[CR], can possibly go into dreams.", french="Et nous avons entendu dire que\ntu pouvais visiter les rêves des autres.", german="Und dann hörten wir, dass du,\n[CS:N]Traumato[CR], in die Träume anderer eindringen\nkannst.", italian="Abbiamo sentito che tu,\n[CS:N]Drowzee[CR], forse puoi entrare nei sogni.", spanish="Y nos han dicho que tú puedes\npenetrar en los sueños ajenos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's when we heard that you,\n[CS:N]Drowzee[CR], can possibly enter dreams.", french="Et nous avons entendu dire que\ntu pouvais visiter les rêves des autres.", german="Und dann hörten wir, dass du,\n[CS:N]Traumato[CR], möglicherweise in Träume\neindringen kannst.", italian="Abbiamo sentito che tu,\n[CS:N]Drowzee[CR], forse puoi entrare nei sogni.", spanish="Y nos han dicho que tú puedes\npenetrar en los sueños ajenos."})
  else
  SkySceneKit.say({english="Then we heard maybe you can\ngo into dreams, [CS:N]Drowzee[CR].", french="Et nous avons entendu dire que\ntu pouvais visiter les rêves des autres.", german="Dann hörten wir, dass du\nvielleicht in Träume eindringen kannst,\n[CS:N]Traumato[CR].", italian="Abbiamo sentito che forse tu\npuoi entrare nei sogni, [CS:N]Drowzee[CR].", spanish="Y nos han dicho que tú puedes\npenetrar en los sueños ajenos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That's why we searched for you.", french=" C'est pour ça qu'on est là.", german="Darum haben wir dich\naufgesucht.", italian="È per questo che ti stavamo\ncercando.", spanish=" Por eso te estábamos buscando."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's why we searched for you.", french=" C'est pour ça qu'on est là.", german="Darum haben wir dich\naufgesucht.", italian="È per questo che ti stavamo\ncercando.", spanish=" Por eso te estábamos buscando."})
  else
  SkySceneKit.say({english=" That's why we searched for you.", french=" C'est pour ça qu'on est là.", german="Darum haben wir dich\naufgesucht.", italian="È per questo che ti stavamo\ncercando.", spanish=" Por eso te estábamos buscando."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [CS:N]Drowzee[CR]...", french=" Alors, [CS:N]Soporifik[CR]...", german=" Hey, [CS:N]Traumato[CR]...", italian=" Ehi, [CS:N]Drowzee[CR]...", spanish=" Bueno, [CS:N]Drowzee[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So, [CS:N]Drowzee[CR]...", french=" Alors, [CS:N]Soporifik[CR]...", german=" Also, [CS:N]Traumato[CR]...", italian=" Ehi, [CS:N]Drowzee[CR]...", spanish=" Bueno, [CS:N]Drowzee[CR]..."})
  else
  SkySceneKit.say({english=" Say, [CS:N]Drowzee[CR]...", french=" Alors, [CS:N]Soporifik[CR]...", german=" Sag mal, [CS:N]Traumato[CR]...", italian=" Ehi, [CS:N]Drowzee[CR]...", spanish=" Bueno, [CS:N]Drowzee[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What do you say?[K] Will you\nhelp us?", french="Qu'est-ce que tu en dis?[K]\nTu veux bien nous aider?", german=" Wie sieht es aus?[K] Hilfst du uns?", italian=" Cosa ne dici?[K] Vuoi aiutarci?", spanish="¿Qué opinas?[K] ¿Nos vas a\nayudar?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" How about it?[K] Will you help us?", french="Qu'est-ce que tu en dis?[K]\nTu veux bien nous aider?", german="Wie stehen die Dinge?[K] Hilfst du\nuns?", italian=" Cosa ne dici?[K] Vuoi aiutarci?", spanish="¿Qué opinas?[K] ¿Nos vas a\nayudar?"})
  else
  SkySceneKit.say({english="Well, what do you think?[K]\nWill you please help us?", french="Qu'est-ce que tu en dis?[K]\nTu veux bien nous aider?", german="Nun, was denkst du?[K]\nKannst du uns helfen, bitte?", italian=" Cosa ne dici?[K] Vuoi aiutarci?", spanish="¿Qué opinas?[K] ¿Nos vas a\nayudar?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_suriipu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" ...I...[K]I...", french=" ... Je...[K] je...", german=" ...Ich... [K]Ich...", italian=" Io...[K] Io...", spanish=" Yo...[K] Yo..."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="I did a rotten thing to that little\n[CS:N]Azurill[CR] way back when...", french="A l'époque, j'ai fait un mauvais\ncoup au petit [CS:N]Azurill[CR]...", german="Ich hab [CS:N]Azurill[CR] einmal etwas\nmächtig Gemeines angetan. Damals...", italian="Mi sono comportato male con\n[CS:N]Azurill[CR] quella volta...", spanish="Le hice algo malo a ese tal\n[CS:N]Azurill[CR] cuando..."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="I don't know if doing this would\never make up for it, but...", french="Je ne sais pas si cela suffira\nà réparer mes torts, mais...", german="Ich weiß nicht, ob ich das damit\njemals gutmachen könnte, aber...", italian="Non so se questo può bastare\na farmi perdonare, ma...", spanish="No sé si podré compensar\naquello, pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="If it would help [CS:N]Azurill[CR] even\na little...", french="... si mes pouvoirs peuvent aider\n[CS:N]Azurill[CR], ne serait-ce qu'un peu...", german="Wenn es [CS:N]Azurill[CR] nur ein wenig\nhelfen würde...", italian="Se può essere d'aiuto\nad [CS:N]Azurill[CR]...", spanish="Si pudiera ayudarle, aunque\nsolo sea una pizca..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_suriipu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="I don't know how useful I can\nbe, but...[K] I'd be glad to help, if you'll let me.", french="Je ne sais pas si je peux être\nvraiment utile mais...[K] je serai ravi d'essayer,\nsi vous acceptez.", german="Keine Ahnung, wie nützlich ich\nsein kann, aber...[K] ich helfe gerne, wenn ihr\nmich lasst.", italian="Non so quanto potrò fare, ma...[K]\nSarò felice di darvi una mano.", spanish="No sé si os seré útil, pero...[K]\nlo intentaré con mucho gusto, si me\ndejáis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Drowzee[CR]!", french=" Merci, [CS:N]Soporifik[CR]!", german=" [CS:N]Traumato[CR]!", italian=" [CS:N]Drowzee[CR]!", spanish=" ¡[CS:N]Drowzee[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Drowzee[CR]!", french=" Merci, [CS:N]Soporifik[CR]!", german=" [CS:N]Traumato[CR]!", italian=" [CS:N]Drowzee[CR]!", spanish=" ¡[CS:N]Drowzee[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]Drowzee[CR]!", french=" Merci, [CS:N]Soporifik[CR]!", german=" [CS:N]Traumato[CR]!", italian=" [CS:N]Drowzee[CR]!", spanish=" ¡[CS:N]Drowzee[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="Lead me back to [CS:N]Azurill[CR].\nLet's not waste time!", french="Conduisez-moi à [CS:N]Azurill[CR].\nNe perdons pas de temps!", german="Führt mich zu [CS:N]Azurill[CR].\nLasst uns keine Zeit verlieren!", italian="Portatemi da [CS:N]Azurill[CR].\nNon perdiamo altro tempo!", spanish="Llevadme donde [CS:N]Azurill[CR].\n¡Démonos prisa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" OK!", french=" D'accord!", german=" Okay!", italian=" Ok!", spanish=" ¡De acuerdo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK!", french=" D'accord!", german=" Okay!", italian=" Ok!", spanish=" ¡De acuerdo!"})
  else
  SkySceneKit.say({english=" OK!", french=" D'accord!", german=" Okay!", italian=" Ok!", spanish=" ¡De acuerdo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's this way! Quick!", french=" C'est par là! Vite!", german=" Hier geht es lang! Schnell!", italian=" Da questa parte! Presto!", spanish=" ¡Por aquí! ¡Deprisa!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's this way! Quick!", french=" C'est par là! Vite!", german=" Hier geht es lang! Schnell!", italian=" Da questa parte! Presto!", spanish=" ¡Por aquí! ¡Deprisa!"})
  else
  SkySceneKit.say({english=" It's this way! Let's hurry!", french=" C'est par là! Vite!", german=" Hier geht es lang! Schnell!", italian=" Da questa parte! Presto!", spanish=" ¡Por aquí! ¡Deprisa!"})
  end
  -- message_Close
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(180), false, 2) end
  GAME:WaitFrames(5)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(180), false, 2) end
  do local p=npc_npc_suriipu.Position; GROUND:MoveToPosition(npc_npc_suriipu, p.X+(0), p.Y+(180), false, 2) end
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT = 24 -- $COMPULSORY_SAVE_POINT = 24 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
