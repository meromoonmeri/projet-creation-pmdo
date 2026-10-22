-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/s03p0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 464, 232, Direction.DownRight, "NPC_PERAPPU")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_manafi = SkySceneKit.spawn_npc("manaphy", 496, 248, Direction.Down, "NPC_MANAFI")
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_manafi, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_manafi, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Weh...[K] Weh...[K] Waaaah!", french=" Ouin...[K] Ouin...[K] Ouiiiiiiiiiiiiiiin!", german=" Uäh...[K] Uäh...[K] Buuuuhuhu!", italian=" Weh...[K] Weh...[K] Waaaah!", spanish=" Snif...[K] snif...[K] ¡Buaaaa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english="[CN]Would you like to give\n[CN]a [CS:I]Blue Gummi[CR] to [CS:N]Manaphy[CR]?", french="[CN]Voulez-vous donner une\n[CN][CS:I]Gelée Bleue[CR] à [CS:N]Manaphy[CR]?", german="[CN]Möchtest du [CS:N]Manaphy[CR]\n[CN]ein [CS:I]Blaugummi[CR] geben?", italian="[CN]Vuoi dare una\n[CN][CS:I]Gommablu[CR] a [CS:N]Manaphy[CR]?", spanish="[CN]¿Quieres darle una [CS:I]Gomi Azul[CR]\n[CN]a [CS:N]Manaphy[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- message_Close
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_ITEMS_TYPE_IN_BAG, 121, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 30)
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:TeleportTo(hero, 496, 268, Direction.Down)
  GROUND:TeleportTo(partner, 464, 268, Direction.Down)
  GROUND:TeleportTo(npc_npc_perappu, 456, 228, Direction.Down)
  GROUND:TeleportTo(npc_npc_manafi, 496, 244, Direction.Down)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GROUND:EntTurn(npc_npc_manafi, Direction.Down)
  GAME:WaitFrames(30)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english="[CN][hero] gave a\n[CN][CS:I]Blue Gummi[CR] to [CS:N]Manaphy[CR].", french="[CN][hero] donne une\n[CN][CS:I]Gelée Bleue[CR] à [CS:N]Manaphy[CR].", german="[CN][hero] gibt [CS:N]Manaphy[CR]\n[CN]ein [CS:I]Blaugummi[CR].", italian="[CN][hero] dà una\n[CN][CS:I]Gommablu[CR] a [CS:N]Manaphy[CR].", spanish="[CN][hero] le dio una\n[CN][CS:I]Gomi Azul[CR] a [CS:N]Manaphy[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkyProg.set(29, 44) -- $SCENARIO_MAIN = scn[29,44] (ROM)
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Weh...[K] Wah?", french=" Ouin...[K] Ouin?", german=" Uäh...[K] Uah?", italian=" Weh...[K] Wah?", spanish=" Snif...[K] ¿Bua?"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Go on! Eat it. It's a [CS:I]Blue Gummi[CR].", french="Vas-y! Mange-la. C'est une\n[CS:I]Gelée Bleue[CR].", german="Los! Du kannst es ruhig essen.\nEs ist ein [CS:I]Blaugummi[CR].", italian=" Dai, mangiala! È una [CS:I]Gommablu[CR].", spanish="¡Vamos! Cómetela.\nEs una [CS:I]Gomi Azul[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Go on! Eat it. It's a [CS:I]Blue Gummi[CR].", french="Vas-y! Mange-la. C'est une\n[CS:I]Gelée Bleue[CR].", german="Los! Du kannst es ruhig essen.\nEs ist ein [CS:I]Blaugummi[CR].", italian=" Dai, mangiala! È una [CS:I]Gommablu[CR].", spanish="¡Vamos! Cómetela.\nEs una [CS:I]Gomi Azul[CR]."})
  else
  SkySceneKit.say({english=" Go on! Eat it. It's a [CS:I]Blue Gummi[CR].", french="Vas-y! Mange-la. C'est une\n[CS:I]Gelée Bleue[CR].", german="Los! Du kannst es ruhig essen.\nEs ist ein [CS:I]Blaugummi[CR].", italian=" Dai, mangiala! È una [CS:I]Gommablu[CR].", spanish="¡Vamos! Cómetela.\nEs una [CS:I]Gomi Azul[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" ...[K]Goomi?", french=" ...[K] Jélébleu?", german=" ...[K]Dummi?", italian=" ...[K] Gooma?", spanish=" Gu...[K] ¿Gumi?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Nibble, nibble...", french=" Miam miam...", german=" Knabber, knabber...", italian=" Gnam, gnam...", spanish=" Ñam, ñam..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" !", french=" !", german=" !", italian=" !", spanish=" (!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Goomi! Goomi!", french=" Jélébleu! Jélébleu!", german=" Dummi! Dummi!", italian=" Gooma! Gooma!", spanish=" ¡Gumi! ¡Gumi!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "happy", 1) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Heartwarming.ogg", true) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, whew![K] He ate the Gummi.", french=" Ouf![K] Il a mangé la gelée.", german="Oh, puh![K] Es hat das Gummi\ngegessen.", italian="Fiuuu![K] Ha mangiato la\nCaramella Gommosa.", spanish="¡Menos mal![K] Se ha comido la\ngomi."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, whew![K] He ate the Gummi.", french=" Ouf![K] Il a mangé la gelée.", german="Oh, puh![K] Es hat das Gummi\ngegessen.", italian="Fiuuu![K] Ha mangiato la\nCaramella Gommosa.", spanish="¡Menos mal![K] Se ha comido la\ngomi."})
  else
  SkySceneKit.say({english=" Oh, whew![K] He ate the Gummi.", french=" Ouf![K] Il a mangé la gelée.", german="Oh, puh![K] Es hat das Gummi\ngegessen.", italian="Fiuuu![K] Ha mangiato la\nCaramella Gommosa.", spanish="¡Menos mal![K] Se ha comido la\ngomi."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(0), p.Y+(12), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Goomi! ♪ Goomi! ♪", french=" Jélé! ♪ Jélé! ♪", german=" Dummi! ♪ Dummi! ♪", italian=" Gooma! ♪ Gooma! ♪", spanish=" ¡Gumi! ♪ ¡Gumi! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ha![K] He likes you, [hero]!", french=" Ha![K] Il t'adore, [hero]!", german=" Ha![K] Es mag dich, [hero]!", italian=" Ah![K] Gli piaci, [hero]!", spanish="¡Ja![K] ¡Le has gustado,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ha![K] He likes you, [hero]!", french=" Ha![K] Il t'adore, [hero]!", german=" Ha![K] Es mag dich, [hero]!", italian=" Ah![K] Gli piaci, [hero]!", spanish="¡Ja![K] ¡Le has gustado,\n[hero]!"})
  else
  SkySceneKit.say({english="Ha![K] He's become attached to\nyou, [hero]!", french=" Ha![K] Il t'adore, [hero]!", german="Ha![K] Es hängt an dir,\n[hero]!", italian="Ah![K] Si è affezionato a te,\n[hero]!", spanish="¡Ja![K] ¡Te ha cogido cariño,\n[hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" He's so cute.", french=" Il est si mignon.", german=" Es ist so süß!", italian=" È così carino.", spanish=" Qué mono."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" He's so cute.", french=" Il est si mignon.", german=" Es ist so süß!", italian=" È così carino.", spanish=" Qué mono."})
  else
  SkySceneKit.say({english=" Aww, what a cutie.", french=" Il est si mignon.", german=" Ooh, was für ein Schnuckelchen!", italian=" Oh, che carino.", spanish=" Qué monada."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [hero].", french=" Hé, [hero].", german=" Hey, [hero].", italian=" Ehi, [hero].", spanish=" Oye, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey, [hero].", french=" Hé, [hero].", german=" Hey, [hero].", italian=" Ehi, [hero].", spanish=" Oye, [hero]."})
  else
  SkySceneKit.say({english=" Say, [hero].", french=" Hé, [hero].", german=" Sag mal, [hero].", italian=" Ehi, [hero].", spanish=" Oye, [hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This guy's still a baby...[K]\nHow about we look after him for a while?", french="C'est encore un bébé...[K]\nEt si nous nous en occupions pendant un\nmoment?", german="Das Kleine ist noch ein Baby...[K]\nWie wäre es, wenn wir uns noch eine Weile\ndarum kümmern?", italian="È ancora un cucciolo...[K]\nCosa ne dici di prendercene cura per un po'?", spanish="No es más que un bebé...[K]\n¿Qué tal si lo cuidamos por un tiempo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This little guy's still a baby...[K]\nHow about we look after him for a while?", french="C'est encore un bébé...[K]\nEt si nous nous en occupions pendant un\nmoment?", german="Das Kleine ist noch ein Baby...[K]\nWie wäre es, wenn wir uns noch eine Weile\ndarum kümmern?", italian="È ancora un cucciolo...[K]\nCosa ne dici di prendercene cura per un po'?", spanish="No es más que un bebé...[K]\n¿Qué tal si lo cuidamos por un tiempo?"})
  else
  SkySceneKit.say({english="This little guy's still a baby...[K]\nCan we look after him for a while?", french="C'est encore un bébé...[K]\nEt si nous nous en occupions pendant un\nmoment?", german="Das Kleine ist noch ein Baby...[K]\nKönnen wir uns nicht noch eine Weile darum\nkümmern?", italian="È ancora un cucciolo...[K]\nCosa ne dici di prendercene cura per un po'?", spanish="No es más que un bebé...[K]\n¿Qué tal si lo cuidamos por un tiempo?"})
  end
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- @label_4 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right! Awesome! We'll do it!", french="Très bien! Génial! S'il le faut,\non lui donnera huit, dix gelées, voire douze!", german=" Okay! Spitze! So machen wir es!", italian=" Va bene! Che bello!", spanish="¡Estupendo! ¡Va a ser muy\ndivertido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK! Awesome! We'll do it!", french="Très bien! Génial! S'il le faut,\non lui donnera huit, dix gelées, voire douze!", german=" Okay! Super! So machen wir es!", italian=" Va bene! Che bello!", spanish="¡Genial! ¡Va a ser muy\ndivertido!"})
  else
  SkySceneKit.say({english=" Oh, thank you! We'll do it!", french="Très bien! Génial! S'il le faut,\non lui donnera huit, dix gelées, voire douze!", german=" Oh, danke! So machen wir es!", italian=" Oh, grazie! Che bello!", spanish="¡Qué bien nos lo vamos a pasar!\n¡Va a ser muy divertido!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(npc_npc_manafi, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Doodit! ♪", french=" Ouze! ♪", german=" Machenes! ♪", italian=" Belo! ♪", spanish=" ¡Tido, tido! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" I'm not sure this is a good idea...", french="Je ne suis pas sûr que ce soit\nune très bonne idée...", german="Ich bin mir nicht sicher, ob das\neine gute Idee ist...", italian="Non sono sicuro che sia una\nbuona idea...", spanish=" No sé si es una buena idea..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?", french=" Quoi?", german=" Hä?", italian=" Cosa?", spanish=" ¿Por?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?", french=" Quoi?", german=" Was?", italian=" Cosa?", spanish=" ¿Por?"})
  else
  SkySceneKit.say({english=" What?", french=" Quoi?", german=" Was?", italian=" Cosa?", spanish=" ¿Por?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="This child is a Pokémon that\nnormally would grow in the sea.", french="Ce petit est un Pokémon qui\ngrandit normalement dans la mer.", german="Dieses Kleine ist ein Pokémon,\ndas normalerweise im Meer aufwachsen\nwürde.", italian="Questo cucciolo è un Pokémon\nche normalmente cresce in mare.", spanish="Este Pokémon normalmente\ncrece en el mar."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="This environment is obviously\nunlike the sea...", french="Ici, ce n'est pas son\nenvironnement naturel...", german="Diese Umgebung ist\noffensichtlich anders als das Meer...", italian="Ovviamente, questo ambiente è\nmolto diverso dal mare.", spanish=" Este no es su hábitat..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Add to that, we know next to\nnothing about [CS:N]Manaphy[CR]...[K] Who knows what\ncould happen?", french="En plus, nous ne savons\nquasiment rien sur [CS:N]Manaphy[CR]...[K] Qui sait ce\nqu'il pourrait arriver?", german="Hinzu kommt noch, dass wir so\ngut wie nichts über [CS:N]Manaphy[CR] wissen...[K]\nWer weiß, was passieren kann?", italian="Inoltre, non sappiamo quasi\nnulla su [CS:N]Manaphy[CR]...[K] Chi sa cosa potrebbe\nsuccedere?", spanish="Además, apenas sabemos nada de\n[CS:N]Manaphy[CR]...[K] Podría pasar cualquier cosa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hmm...", french=" Hum...", german=" Hmm...", italian=" Mmm...", spanish=" Hum..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hmm...", french=" Hum...", german=" Hmm...", italian=" Mmm...", spanish=" Hum..."})
  else
  SkySceneKit.say({english=" Hmm...", french=" Hum...", german=" Hmm...", italian=" Mmm...", spanish=" Hum..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But...[K] It wouldn't be safe to just\nreturn the little guy to the sea.", french="Mais...[K] ce serait dangereux\nde renvoyer ce petit à la mer.", german="Aber...[K] Das Kleine wäre nicht\nsicher, wenn wir es einfach im Meer\naussetzen würden.", italian="Ma...[K] non sarebbe sicuro\nrimettere semplicemente il cucciolo in mare.", spanish="Pero...[K] sería peligroso\ndevolverlo al mar, así sin más."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But...[K] It wouldn't be safe to just\nreturn the little guy to the sea.", french="Mais...[K] ce serait dangereux\nde renvoyer ce petit à la mer.", german="Aber...[K] Das Kleine wäre nicht\nsicher, wenn wir es einfach im Meer\naussetzen würden.", italian="Ma...[K] non sarebbe sicuro\nrimettere semplicemente il cucciolo in mare.", spanish="Pero...[K] sería peligroso\ndevolverlo al mar, así sin más."})
  else
  SkySceneKit.say({english="But...[K] It wouldn't be safe to just\nreturn the little guy to the sea.", french="Mais...[K] ce serait dangereux\nde renvoyer ce petit à la mer.", german="Aber...[K] Das Kleine wäre nicht\nsicher, wenn wir es einfach im Meer\naussetzen würden.", italian="Ma...[K] non sarebbe sicuro\nrimettere semplicemente il cucciolo in mare.", spanish="Pero...[K] sería peligroso\ndevolverlo al mar, así sin más."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="How about we look after the\nlittle guy until he gets a bit bigger.[K] OK?", french="Pourquoi ne pas veiller sur lui\njusqu'à ce qu'il grandisse un peu?[K] D'accord?", german="Wie wäre es, wenn wir ein\nwenig auf das Kleine aufpassen, bis es etwas\ngrößer geworden ist.[K] Okay?", italian="Cosa ne dici se ce ne prendiamo\ncura finché non sarà cresciuto un po'?[K]\nSei d'accordo?", spanish="Cuidaremos de él hasta que\nhaya crecido un poco.[K] ¿Vale?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's look after the little guy\nuntil he gets a bit bigger.[K] Please?", french="Pourquoi ne pas veiller sur lui\njusqu'à ce qu'il grandisse un peu?[K] D'accord?", german="Lass uns auf das Kleine\naufpassen, bis es etwas größer ist.[K] Bitte!", italian="Cosa ne dici se ce ne prendiamo\ncura finché non sarà cresciuto un po'?[K]\nSei d'accordo?", spanish="Cuidaremos de él hasta que\nhaya crecido un poco.[K] ¿Vale?"})
  else
  SkySceneKit.say({english="Could we look after the little\nguy until he gets a bit bigger?[K] Please?", french="Pourquoi ne pas veiller sur lui\njusqu'à ce qu'il grandisse un peu?[K] D'accord?", german="Können wir nicht auf das Kleine\naufpassen, bis es etwas größer ist?[K] Bitte?", italian="Cosa ne dici se ce ne prendiamo\ncura finché non sarà cresciuto un po'?[K]\nSei d'accordo?", spanish="Cuidaremos de él hasta que\nhaya crecido un poco.[K] ¿Vale?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Hmmm...", french=" Hum...", german=" Hmmm...", italian=" Mmm...", spanish=" Hum..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We'll take good care of the little\nguy. We promise!", french="Nous en prendrons soin. C'est\npromis!", german="Wir passen gut auf das Kleine\nauf. Versprochen!", italian="Lo tratteremo bene. Te lo\nprometto!", spanish="Lo cuidaremos como es\ndebido, ¡lo prometo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We'll look after him properly.\nWe promise!", french="Nous en prendrons soin. C'est\npromis!", german="Wir werden uns gut um das\nKleine kümmern. Versprochen!", italian="Lo tratteremo bene. Te lo\nprometto!", spanish="Lo cuidaremos como es\ndebido, ¡lo prometo!"})
  else
  SkySceneKit.say({english="We'll take proper care of the\nlittle guy. We promise!", french="Nous en prendrons soin. C'est\npromis!", german="Wir kümmern uns anständig um\ndas Kleine. Versprochen!", italian="Lo tratteremo bene. Te lo\nprometto!", spanish="Lo cuidaremos como es\ndebido, ¡lo prometo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" ...[K]Fine. If you insist.", french=" ...[K] Très bien. Si vous insistez.", german="...[K]Schön. Wenn ihr darauf\nbesteht.", italian=" ...[K] Va bene. Se insistete.", spanish=" Bueno...[K] Si insistes..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You don't need to worry! You can\ncount on us!", french="Inutile de s'inquiéter! Tu peux\nnous faire confiance!", german="Du brauchst keine Angst zu\nhaben! Auf uns kannst du zählen!", italian="Non devi preoccuparti! Puoi\ncontare su di noi!", spanish="¡No te preocupes! ¡Todo irá\nbien!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You have nothing to worry\nabout! You can count on us!", french="Inutile de s'inquiéter! Tu peux\nnous faire confiance!", german="Du musst dir keine Sorgen\nmachen! Auf uns ist Verlass!", italian="Non devi preoccuparti! Puoi\ncontare su di noi!", spanish="¡No te preocupes! ¡Todo irá\nbien!"})
  else
  SkySceneKit.say({english=" Don't worry! You can rely on us!", french="Inutile de s'inquiéter! Tu peux\nnous faire confiance!", german="Keine Sorge! Auf uns kannst du\nzählen!", italian="Non devi preoccuparti! Puoi\ncontare su di noi!", spanish="¡No te preocupes! ¡Todo irá\nbien!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Right, [hero]?", french=" Pas vrai, [hero]?", german=" Nicht wahr, [hero]?", italian=" Vero, [hero]?", spanish=" ¿A que sí, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Right, [hero]?", french=" Pas vrai, [hero]?", german=" Nicht wahr, [hero]?", italian=" Vero, [hero]?", spanish=" ¿A que sí, [hero]?"})
  else
  SkySceneKit.say({english=" Right, [hero]?", french=" Pas vrai, [hero]?", german=" Nicht wahr, [hero]?", italian=" Vero, [hero]?", spanish=" ¿A que sí, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  else -- default/annulation
  -- @label_5 [étiquette de flux ExplorerScript]
  -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?!", french=" Quoi?!", german=" Hä?!?", italian=" Eh?!", spanish=" ¡¿Qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Eh?!", spanish=" ¡¿Qué?!"})
  else
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Eh?!", spanish=" ¡¿Qué?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We can't just leave the poor\nlittle guy here. He can't look after himself.", french="On ne peut pas l'abandonner!\nIl ne pourra jamais se débrouiller tout seul.", german="Wir können das kleine Kerlchen\nnicht einfach aussetzen. Es kann noch nicht\nauf sich selbst aufpassen.", italian="Non possiamo lasciarlo qui. Non\npuò ancora badare a se stesso.", spanish="No podemos abandonarlo, no\npuede cuidar de sí mismo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We can't just leave the poor\nlittle guy here. He can't fend for himself.", french="On ne peut pas l'abandonner!\nIl ne pourra jamais se débrouiller tout seul.", german="Wir können das kleine Kerlchen\nnicht einfach aussetzen. Es kann noch nicht\nfür sich selbst sorgen.", italian="Non possiamo lasciarlo qui. Non\npuò ancora badare a se stesso.", spanish="No podemos abandonarlo, no\npuede cuidar de sí mismo."})
  else
  SkySceneKit.say({english="We can't just leave the poor\nlittle guy here. He can't look after himself.", french="On ne peut pas l'abandonner!\nIl ne pourra jamais se débrouiller tout seul.", german="Wir können das kleine Kerlchen\nnicht einfach aussetzen. Es kann noch nicht\nauf sich selbst aufpassen.", italian="Non possiamo lasciarlo qui. Non\npuò ancora badare a se stesso.", spanish="No podemos abandonarlo, no\npuede cuidar de sí mismo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Come on, let's look after this\nlittle guy together.[K] Please?", french="Allez, occupons-nous-en\nensemble.[K] S'il te plaît?", german="Komm schon, passen wir noch\neine Weile zusammen auf das Kleine auf.[K]\nBitte!", italian="Dai, prendiamoci cura insieme di\nquesto cucciolo.[K] Che ne pensi?", spanish="Venga, cuidemos de él juntos.[K]\nPor favor..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Come on, let's look after this\nlittle guy together.[K] Please?", french="Allez, occupons-nous-en\nensemble.[K] S'il te plaît?", german="Komm schon, passen wir noch\neine Weile zusammen auf das Kleine auf.[K]\nBitte!", italian="Dai, prendiamoci cura insieme di\nquesto cucciolo.[K] Che ne pensi?", spanish="Venga, cuidemos de él juntos.[K]\nPor favor..."})
  else
  SkySceneKit.say({english="Aww, please, let's look after\nthis little guy together.[K] Pretty please?", french="Allez, occupons-nous-en\nensemble.[K] S'il te plaît?", german="Komm schon, passen wir noch\neine Weile zusammen auf das Kleine auf.[K]\nBitte, bitte!", italian="Dai, prendiamoci cura insieme di\nquesto cucciolo.[K] Che ne pensi?", spanish="Venga, cuidemos de él.[K]\nPor favor..."})
  end
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  else -- default/annulation
  -- break_loop [contrôle de boucle forever NDS: une itération compilée]
  end
  end
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  -- @label_3 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][hero] doesn't have a [CS:I]Blue Gummi[CR]...", french="[CN][hero] n'a pas de [CS:I]Gelée Bleue[CR]...", german="[CN][hero] hat kein [CS:I]Blaugummi[CR]...", italian="[CN][hero] non ha una [CS:I]Gommablu[CR]...", spanish="[CN][hero] no tiene ninguna [CS:I]Gomi Azul[CR]..."})
  -- message_Close
  end
  end
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Weh...[K] Weh...[K] Waaaah!", french=" Ouin...[K] Ouin...[K] Ouiiiiiiiiiiiiiiin!", german=" Uäh...[K] Uäh...[K] Buuuuhuhu!", italian=" Weh...[K] Weh...[K] Waaaah!", spanish=" Snif...[K] snif...[K] ¡Buaaaa!"})
  -- message_Close
  end
  end
  SkySceneKit.cleanup_npcs()
end
