-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D39P41A/s22p0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D39P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_parukia = SkySceneKit.spawn_npc("palkia", 376, 296, Direction.Down, "NPC_PARUKIA")
  GROUND:EntTurn(npc_npc_parukia, Direction.DownRight)
  -- SetAnimation(44) [anim idle native]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1')
  GAME:FadeIn(30)
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" GRRR-OOOOO-AAAAH!", french=" GRRR-OOOOO-AAAAH!", german=" GRRR-OOOOO-AAAAH!", italian=" GRRR-OOOOO-AAAAH!", spanish=" GRRR... GRRR..."})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- SetAnimation(43) [anim idle native]
  GAME:WaitFrames(15)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" GRRR-OOOO...[K]AAAAAAH!", french=" GRRR-OOOO...[K] AAAAAAH!", german=" GRRR-OOOO...[K]AAAAAAH!", italian=" GRRR-OOOO...[K] AAAAAAH! ", spanish=" GRRR...[K] GRRRRRRRRR..."})
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_parukia, "shock", 1) end)
  GROUND:EntTurn(npc_npc_parukia, Direction.Down)
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_parukia, Direction.DownRight)
  -- SetAnimation(44) [anim idle native]
  GAME:WaitFrames(90)
  -- message_CloseEnforce
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- GAP: se_Play(6924) — id SE NDS sans portage PMDO identifié
  GROUND:EntTurn(npc_npc_parukia, Direction.Right)
  -- SetAnimation(24) [anim idle native]
  GAME:FadeIn(5) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...H-huh?", french=" ... Hein, quoi?", german=" ...H-hä?", italian=" ... E-Eh?", spanish=" ¿Eh?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...H-huh?", french=" ... Hein, quoi?", german=" ...H-hä?", italian=" ... E-Eh?", spanish=" ¿Eh?"})
  else
  SkySceneKit.say({english=" ...H-huh?", french=" ... Hein, quoi?", german=" ...H-hä?", italian=" ... E-Eh?", spanish=" ¿Eh?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Palkia[CR]...[K] [CS:N]Palkia[CR] has stopped\nmoving...", french=" [CS:N]Palkia[CR]...[K] il ne bouge plus...", german="[CS:N]Palkia[CR]...[K] [CS:N]Palkia[CR] bewegt sich nicht\nmehr...", italian="[CS:N]Palkia[CR]...[K] [CS:N]Palkia[CR] non si muove\npiù...", spanish=" [CS:N]Palkia[CR]...[K] [CS:N]Palkia[CR] no se mueve..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Palkia[CR]...[K] [CS:N]Palkia[CR] has stopped\nmoving...", french=" [CS:N]Palkia[CR]...[K] il ne bouge plus...", german="[CS:N]Palkia[CR]...[K] [CS:N]Palkia[CR] bewegt sich nicht\nmehr...", italian="[CS:N]Palkia[CR]...[K] [CS:N]Palkia[CR] non si muove\npiù...", spanish=" [CS:N]Palkia[CR]...[K] [CS:N]Palkia[CR] no se mueve..."})
  else
  SkySceneKit.say({english="[CS:N]Palkia[CR]...[K] [CS:N]Palkia[CR] has stopped\nmoving...", french=" [CS:N]Palkia[CR]...[K] il ne bouge plus...", german="[CS:N]Palkia[CR]...[K] [CS:N]Palkia[CR] bewegt sich nicht\nmehr...", italian="[CS:N]Palkia[CR]...[K] [CS:N]Palkia[CR] non si muove\npiù...", spanish=" [CS:N]Palkia[CR]...[K] [CS:N]Palkia[CR] no se mueve..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What's happening...?", french=" Mais qu'est-ce qui lui arrive...?", german=" Was geschieht hier?", italian=" Cosa sta succedendo?", spanish=" ¿Qué ha pasado...?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What happened to him...?", french=" Mais qu'est-ce qui lui arrive...?", german=" Was ist mit ihm passiert?", italian=" Cosa gli è successo?", spanish=" ¿Qué le habrá pasado?"})
  else
  SkySceneKit.say({english=" What happened to him...?", french=" Mais qu'est-ce qui lui arrive...?", german=" Was ist mit ihm passiert?", italian=" Cosa gli è successo?", spanish=" ¿Qué le habrá pasado?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" [CS:N]Palkia[CR] has been...", french=" [CS:N]Palkia[CR] a été...", german=" [CS:N]Palkia[CR] wurde...", italian=" [CS:N]Palkia[CR] è stato...", spanish=" [CS:N]Palkia[CR] se ha quedado..."})
  -- message_KeyWait
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:N]Palkia[CR] has been enveloped by\nthe nightmare.", french="[CS:N]Palkia[CR] a été happé\npar le cauchemar.", german=" [CS:N]Palkia[CR] wurde vom Albtraum eingehüllt.", italian="[CS:N]Palkia[CR] è rimasto imprigionato\nnell'incubo.", spanish="[CS:N]Palkia[CR] se ha quedado inmerso en la\npesadilla."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Just as [CS:N]Azurill[CR] has.", french=" Tout comme [CS:N]Azurill[CR].", german=" Genau wie [CS:N]Azurill[CR].", italian=" Proprio come [CS:N]Azurill[CR].", spanish=" Igual que [CS:N]Azurill[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_IN_THE_FUTURE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="A voice![K] Where is it coming\nfrom?", french=" Cette voix![K] D'où vient-elle?", german="Eine Stimme![K] Wo kommt sie\nher?", italian=" Una voce![K] Da dove viene?", spanish=" ¡Una voz![K] ¿De dónde sale?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="A voice![K] Where is it coming\nfrom?", french=" Cette voix![K] D'où vient-elle?", german="Eine Stimme![K] Wo kommt sie\nher?", italian=" Una voce![K] Da dove viene?", spanish=" ¡Una voz![K] ¿De dónde proviene?"})
  else
  SkySceneKit.say({english="A voice![K] Where is it coming\nfrom?", french=" Cette voix![K] D'où vient-elle?", german="Eine Stimme![K] Wo kommt sie\nher?", italian=" Una voce![K] Da dove viene?", spanish=" ¡Una voz![K] ¿De dónde viene?"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Who are you?", french=" Qui es-tu?", german=" Wer bist du?", italian=" Chi sei?", spanish=" ¿Quién eres?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Who are you?", french=" Qui es-tu?", german=" Wer bist du?", italian=" Chi sei?", spanish=" ¿Quién eres?"})
  else
  SkySceneKit.say({english=" Who are you?", french=" Qui es-tu?", german=" Wer bist du?", italian=" Chi sei?", spanish=" ¿Quién eres?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What do you mean, [CS:N]Palkia[CR] has\nbeen enveloped in a nightmare?", french="Happé par le cauchemar?\nQu'est-ce que tu entends par là?", german="Was meinst du damit, [CS:N]Palkia[CR]\nwurde in einen Albtraum eingehüllt?", italian="Cosa vuol dire che [CS:N]Palkia[CR] è\nrimasto imprigionato in un incubo?", spanish="¿Qué quieres decir con que\n[CS:N]Palkia[CR] está atrapado en una pesadilla?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What do you mean, [CS:N]Palkia[CR] has\nbeen enveloped in a nightmare?", french="Happé par le cauchemar?\nQu'est-ce que tu entends par là?", german="Was meinst du damit, [CS:N]Palkia[CR]\nwurde in einen Albtraum eingehüllt?", italian="Cosa vuol dire che [CS:N]Palkia[CR] è\nrimasto imprigionato in un incubo?", spanish="¿Qué quieres decir con que\n[CS:N]Palkia[CR] está atrapado en una pesadilla?"})
  else
  SkySceneKit.say({english="What do you mean, [CS:N]Palkia[CR] has\nbeen enveloped in a nightmare?", french="Happé par le cauchemar?\nQu'est-ce que tu entends par là?", german="Was meinst du damit, [CS:N]Palkia[CR]\nwurde in einen Albtraum eingehüllt?", italian="Cosa vuol dire che [CS:N]Palkia[CR] è\nrimasto imprigionato in un incubo?", spanish="¿Qué quieres decir con que\n[CS:N]Palkia[CR] está atrapado en una pesadilla?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="It means that the power of darkness has\nspread so much farther.", french="Ça signifie que le pouvoir de l'ombre s'est\nconsidérablement étendu.", german="Es bedeutet, dass sich die Macht der\nDunkelheit viel weiter ausgebreitet hat.", italian="Significa che il potere dell'oscurità si\nè diffuso ulteriormente.", spanish="Lo que significa es que el poder de la\noscuridad no hace sino aumentar."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="If its growth remains unchecked, the\nworld will become drowned in darkness.", french="Si ça continue à ce rythme, l'ombre finira\npar engloutir le monde entier.", german="Wenn ihrer Ausbreitung kein Einhalt\ngeboten wird, erstickt die Welt in Dunkelheit.", italian="Se la sua espansione non viene fermata,\nil mondo sarà avvolto dall'oscurità.", spanish="Si no se controla su expansión, el mundo\nquedará sumido en la oscuridad absoluta."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" But you two...", french=" Mais vous deux...", german=" Aber ihr beiden...", italian=" Ditemi...", spanish=" Seríais capaces de..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Would you two enter [CS:N]Palkia[CR]'s nightmare?", french="... oseriez-vous entrer dans le cauchemar\nde [CS:N]Palkia[CR]?", german="Würdet ihr den Albtraum von [CS:N]Palkia[CR]\nbetreten?", italian=" Volete entrare nell'incubo di [CS:N]Palkia[CR]?", spanish=" ¿De entrar en la pesadilla de [CS:N]Palkia[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?", french=" Quoi?", german=" Was?", italian=" Cosa?", spanish=" ¿Qué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?", french=" Quoi?", german=" Was?", italian=" Cosa?", spanish=" ¿Qué?"})
  else
  SkySceneKit.say({english=" What?", french=" Quoi?", german=" Was?", italian=" Cosa?", spanish=" ¿Qué?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Palkia[CR]'s[K] nightmare?!", french="Dans le cauchemar de\n[CS:N]Palkia[CR]?!", german=" Den Albtraum von [K][CS:N]Palkia[CR]?!?", italian=" L'incubo[K] di [CS:N]Palkia[CR]?!", spanish="¿Cómo?[K] ¡¿En la pesadilla de\n[CS:N]Palkia[CR]?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Palkia[CR]'s[K] nightmare?!", french="Dans le cauchemar de\n[CS:N]Palkia[CR]?!", german=" Den Albtraum von [K][CS:N]Palkia[CR]?!?", italian=" L'incubo[K] di [CS:N]Palkia[CR]?!", spanish="¿Cómo?[K] ¡¿En la pesadilla de\n[CS:N]Palkia[CR]?!"})
  else
  SkySceneKit.say({english=" [CS:N]Palkia[CR]'s[K] nightmare?!", french="Dans le cauchemar de\n[CS:N]Palkia[CR]?!", german=" Den Albtraum von [K][CS:N]Palkia[CR]?!?", italian=" L'incubo[K] di [CS:N]Palkia[CR]?!", spanish="¿Cómo?[K] ¡¿En la pesadilla de\n[CS:N]Palkia[CR]?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Yes.", french=" Oui.", german=" Ja.", italian=" Esatto.", spanish=" Sí."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" By entering his nightmare...", french=" En entrant dans son cauchemar...", german=" Wenn ihr seinen Albtraum betretet...", italian=" Entrando nell'incubo...", spanish=" Al entrar en su pesadilla..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" You will learn why [CS:N]Palkia[CR] attacked you.", french="... vous découvrirez pourquoi il s'en est\npris à vous.", german="Dann werdet ihr erfahren, warum [CS:N]Palkia[CR]\neuch angegriffen hat.", italian="... capirete perché [CS:N]Palkia[CR] continuava\nad attaccarvi.", spanish=" Comprenderéis por qué [CS:N]Palkia[CR] os atacó."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" So? What will you do?", french=" Alors? Que décidez-vous?", german=" Also? Was werdet ihr tun?", italian=" Ebbene? Cosa volete fare?", spanish=" ¿Qué vais a hacer?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What'll we do, [hero]?", french="Qu'est-ce qu'on fait,\n[hero]?", german="Was sollen wir tun,\n[hero]?", italian=" Cosa facciamo, [hero]?", spanish=" ¿Qué hacemos, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What'll we do, [hero]?", french="Qu'est-ce qu'on fait,\n[hero]?", german="Was sollen wir tun,\n[hero]?", italian=" Cosa facciamo, [hero]?", spanish=" ¿Qué hacemos, [hero]?"})
  else
  SkySceneKit.say({english=" What'll we do, [hero]?", french="Qu'est-ce qu'on fait,\n[hero]?", german="Was sollen wir tun,\n[hero]?", italian=" Cosa facciamo, [hero]?", spanish=" ¿Qué hacemos, [hero]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Should we go into the\nnightmare?", french="Tu crois qu'on doit entrer\ndans le cauchemar?", german="Sollen wir in den Albtraum\nhineingehen?", italian=" Dobbiamo entrare nell'incubo?", spanish=" ¿Entramos en la pesadilla?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Should we go into the\nnightmare?", french="Tu crois qu'on doit entrer\ndans le cauchemar?", german="Sollen wir in den Albtraum\nhineingehen?", italian=" Dobbiamo entrare nell'incubo?", spanish=" ¿Entramos en la pesadilla?"})
  else
  SkySceneKit.say({english="Should we go into the\nnightmare?", french="Tu crois qu'on doit entrer\ndans le cauchemar?", german="Sollen wir in den Albtraum\nhineingehen?", italian=" Dobbiamo entrare nell'incubo?", spanish=" ¿Entramos en la pesadilla?"})
  end
  -- @label_2 [étiquette de flux ExplorerScript]
  -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
  do local __choice = SkySceneKit.ask({{english="Enter the nightmare", french="Entrer dans le cauchemar", german="Den Albtraum betreten", italian="Accetta", spanish="Entrar en la pesadilla"}, {english="Refuse", french="Refuser", german="Ablehnen", italian="Rifiuta", spanish="Rechazar"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- break_loop [contrôle de boucle forever NDS: une itération compilée]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-what, you won't?", french=" Quoi, tu refuses d'y aller?", german=" W-was, du willst nicht?", italian=" C-Cosa? Non vuoi?", spanish=" ¿Cómo dices? ¿No?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-what, you won't go in?", french=" Quoi, tu refuses d'y aller?", german="W-was, du willst nicht\nhineingehen?", italian=" C-Cosa? Non vuoi entrare?", spanish=" ¿Cómo dices? ¿No?"})
  else
  SkySceneKit.say({english=" Wh-what, you won't go in?", french=" Quoi, tu refuses d'y aller?", german="W-was, du willst nicht\nhineingehen?", italian=" C-Cosa? Non vuoi entrare?", spanish=" ¿Cómo dices? ¿No?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But...[K]if we don't do anything...", french=" Mais...[K] si on ne fait rien...", german=" Aber...[K] Wenn wir nichts tun...", italian=" Ma...[K] se non facciamo niente...", spanish=" Pero...[K] si no hacemos algo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But...[K]if we don't do anything...", french=" Mais...[K] si on ne fait rien...", german=" Aber...[K] Wenn wir nichts tun...", italian=" Ma...[K] se non facciamo niente...", spanish=" Pero...[K] si no hacemos algo..."})
  else
  SkySceneKit.say({english=" But...[K]if we don't do anything...", french=" Mais...[K] si on ne fait rien...", german=" Aber...[K] Wenn wir nichts tun...", italian=" Ma...[K] se non facciamo niente...", spanish=" Pero...[K] si no hacemos algo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We will never be able to return\nto Treasure Town.", french="... jamais on ne pourra regagner\nBourg-Trésor.", german="Dann werden wir niemals mehr\nnach Schatzstadt zurückkehren können.", italian="Se non lo facciamo, non\nriusciremo mai a tornare a Borgo Tesoro.", spanish="No podremos regresar a Aldea\nTesoro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We will never be able to return\nto Treasure Town.", french="... jamais on ne pourra regagner\nBourg-Trésor.", german="Dann werden wir niemals mehr\nnach Schatzstadt zurückkehren können.", italian="Se non lo facciamo, non\nriusciremo mai a tornare a Borgo Tesoro.", spanish="No podremos regresar a Aldea\nTesoro."})
  else
  SkySceneKit.say({english="We will never be able to return\nto Treasure Town.", french="... jamais on ne pourra regagner\nBourg-Trésor.", german="Dann werden wir niemals mehr\nnach Schatzstadt zurückkehren können.", italian="Se non lo facciamo, non\nriusciremo mai a tornare a Borgo Tesoro.", spanish="No podremos regresar a Aldea\nTesoro."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have no choice. We have to\ngo into the nightmare.", french="On n'a pas le choix. Il faut\nqu'on entre dans le cauchemar.", german="Wir haben keine Wahl. Wir\nmüssen in den Albtraum hineingehen.", italian="Non abbiamo scelta. Dobbiamo\nentrare nell'incubo.", spanish="No tenemos elección. Hay que\nadentrarse en la pesadilla."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We don't have any choice.\nWe have to go into the nightmare.", french="On n'a pas le choix. Il faut\nqu'on entre dans le cauchemar.", german="Wir haben keine Wahl. Wir\nmüssen in den Albtraum hineingehen.", italian="Non abbiamo scelta. Dobbiamo\nentrare nell'incubo.", spanish="No tenemos elección. Hay que\nadentrarse en la pesadilla."})
  else
  SkySceneKit.say({english="We don't have any choice.\nWe have to go into the nightmare.", french="On n'a pas le choix. Il faut\nqu'on entre dans le cauchemar.", german="Wir haben keine Wahl. Wir\nmüssen in den Albtraum hineingehen.", italian="Non abbiamo scelta. Dobbiamo\nentrare nell'incubo.", spanish="No tenemos elección. Hay que\nadentrarse en la pesadilla."})
  end
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  end
  end
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Fine! You've decided!", french=" Votre décision est prise? Parfait!", german=" Schön! Ihr habt entschieden!", italian=" Bene! Avete deciso!", spanish=" ¡Perfecto! ¡Decidido!"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" I will send you into [CS:N]Palkia[CR]'s nightmare.", french="Je vais vous envoyer dans le cauchemar\nde [CS:N]Palkia[CR].", german="Ich schicke euch in den Albtraum\nvon [CS:N]Palkia[CR].", italian=" Vi farò entrare nell'incubo di [CS:N]Palkia[CR].", spanish=" Os enviaré a la pesadilla de [CS:N]Palkia[CR]."})
  -- message_Close
  GAME:WaitFrames(20)
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(8195) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_G01P07A1_108) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(60)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT = 25 -- $COMPULSORY_SAVE_POINT = 25 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
