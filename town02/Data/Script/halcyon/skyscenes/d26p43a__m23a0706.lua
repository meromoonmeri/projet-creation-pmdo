-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D26P43A/m23a0706.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D26P43A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_OH_NO non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 280, 328, Direction.Up, "NPC_PERAPPU")
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[partner]! [hero]!\nBe careful!", french="[partner]! [hero]!\nAttention à vous!", german="[partner]! [hero]!\nPasst auf!", italian="[partner]! [hero]!\nFate attenzione!", spanish="¡[partner]! ¡[hero]!\n¡Tened cuidado!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" They're above us!", french=" Ils sont au-dessus de nous!", german=" Sie sind über uns!", italian=" Sono sopra di noi!", spanish=" ¡Están sobre nosotros!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  else
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  local npc_npc_kabutopusu = SkySceneKit.spawn_npc("kabutops", 280, 208, Direction.Down, "NPC_KABUTOPUSU")
  -- SetAnimation(3) [anim idle native]
  local npc_npc_omusutaa = SkySceneKit.spawn_npc("omastar", 248, 208, Direction.Down, "NPC_OMUSUTAA")
  -- SetAnimation(3) [anim idle native]
  local npc_npc_omusutaa2 = SkySceneKit.spawn_npc("omastar", 312, 208, Direction.Down, "NPC_OMUSUTAA2")
  -- SetAnimation(3) [anim idle native]
  -- GAP: se_Play(7443) — id SE NDS sans portage PMDO identifié
  -- ResetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  -- ResetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  -- ResetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  GROUND:MoveToPosition(npc_npc_omusutaa, 244, 284, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_omusutaa2, 308, 284, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_kabutopusu, 276, 284, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(partner, 260, 308, false, 2) -- SlidePositionMark (glissement)
  -- SetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(hero, 292, 308, false, 2) -- SlidePositionMark (glissement)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  -- SetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '0', '2', '0')
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(20)
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wah...", french=" Ouah...", german=" Uaaah...", italian=" Aah...", spanish=" ¡Aaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wah...", french=" Ouah...", german=" Uaaah...", italian=" Aah...", spanish=" ¡Aaah!"})
  else
  SkySceneKit.say({english=" Wah...", french=" Ouah...", german=" Uaaah...", italian=" Aah...", spanish=" ¡Aaah!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(partner, 260, 316, false, 2) -- SlidePositionMark (glissement)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(hero, 292, 316, false, 2) -- SlidePositionMark (glissement)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GROUND:MoveToPosition(npc_npc_kabutopusu, 276, 292, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" I am [CS:N]Kabutops[CR]!", french=" Je m'appelle [CS:N]Kabutops[CR]!", german=" Ich bin [CS:N]Kabutops[CR]!", italian=" Io sono [CS:N]Kabutops[CR]!", spanish=" ¡Yo soy [CS:N]Kabutops[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_omusutaa, 244, 292, false, 2)
  GROUND:MoveToPosition(npc_npc_omusutaa2, 308, 292, false, 2)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(partner, 260, 332, false, 2) -- SlidePositionMark (glissement)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(hero, 292, 332, false, 2) -- SlidePositionMark (glissement)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(npc_npc_omusutaa, Direction.DownRight)
  GROUND:EntTurn(npc_npc_omusutaa2, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" And the [CS:N]Omastar[CR] brothers!", french=" Et nous sommes les frères [CS:N]Amonistar[CR]!", german=" Und wir die Gebrüder [CS:N]Amoroso[CR]!", italian=" E noi i fratelli [CS:N]Omastar[CR]!", spanish=" ¡Y nosotros los hermanos [CS:N]Omastar[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kabutopusu) end)
  SkySceneKit.say({english="All trespassers need to be\ntaught a lesson![K] Take that!", french="Tous les intrus ont besoin\nd'une leçon![K] Prenez ça!", german="Allen Eindringlingen muss eine\nLektion erteilt werden![K] Nehmt das!", italian="Gli intrusi devono essere puniti![K]\nPrendete questo!", spanish="¡Los intrusos deben recibir\nuna lección![K] ¡Tomad esto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(18) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- GAP: se_Play(7690) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 5) -- screen_WhiteOut
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaaaah!", french=" Ouaaaaah!", german=" Uaaaaah!", italian=" Aaaaaah!", spanish=" ¡Aaaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaaaah!", french=" Ouaaaaah!", german=" Uaaaaah!", italian=" Aaaaaah!", spanish=" ¡Aaaaah!"})
  else
  SkySceneKit.say({english=" Waaaaah!", french=" Ouaaaaah!", german=" Uaaaaah!", italian=" Aaaaaah!", spanish=" ¡Aaaaah!"})
  end
  GAME:WaitFrames(90)
  -- message_CloseEnforce
  GROUND:TeleportTo(npc_npc_perappu, 276, 316, Direction.Down)
  GROUND:EntTurn(npc_npc_perappu, Direction.Up)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(52) [anim idle native]
  GAME:FadeIn(15)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Urrgghh...", french=" Arrgghh...", german=" Urrgghh...", italian=" Urrgghh...", spanish=" Ay..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Ch-Chatot[CR]!", french=" [CS:N]P-Pijako[CR]!", german=" [CS:N]P-Plaudagei[CR]!", italian=" [CS:N]Ch-Chatot[CR]!", spanish=" ¡[CS:N]Chatot[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Ch-Chatot[CR]!", french=" [CS:N]P-Pijako[CR]!", german=" [CS:N]P-Plaudagei[CR]!", italian=" [CS:N]Ch-Chatot[CR]!", spanish=" ¡[CS:N]Chatot[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]Ch-Chatot[CR]!", french=" [CS:N]P-Pijako[CR]!", german=" [CS:N]P-Plaudagei[CR]!", italian=" [CS:N]Ch-Chatot[CR]!", spanish=" ¡[CS:N]Chatot[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kabutopusu) end)
  SkySceneKit.say({english=" Wh-what?!", french=" Que... quoi?!", german=" W-was?!?", italian=" C-Cosa?!", spanish=" ¡¿Qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Urrgghh...![K] I won't let you\nget away with this...", french="Arrgghh...![K] Vous ne l'emporterez\npas au paradis...", german="Urrgghh![K] Damit lasse ich euch\nnicht davonkommen...", italian="Urrgghh...![K] Non la farete\nfranca così...", spanish="¡Nooo![K] No os permitiré que os\nsalgáis con la vuestra..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kabutopusu) end)
  SkySceneKit.say({english="How do you like that? That hero\nshielded his buddies with his body.", french="Qu'est-ce que vous pensez\nde ça? C'est un héros, il s'est interposé pour\nprotéger ses camarades.", german="Was haltet ihr davon? Dieser\nHeld hat seine Kameraden mit seinem Körper\ngeschützt.", italian="Come è possibile? Quell'eroe ha\nfatto da scudo alla sua squadra col suo corpo.", spanish="¿Qué os parece? Se hace el\nhéroe. Intenta proteger a sus camaradas\ncon su cuerpecillo."})
  pcall(function() UI:SetSpeaker(npc_npc_kabutopusu) end)
  SkySceneKit.say({english=" That's not what I'd call smart.", french=" Ça n'est pas très malin.", german=" Das ist nicht wirklich klug.", italian="Non la definirei un'azione\nintelligente...", spanish=" Eso no ha sido nada inteligente."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_omusutaa, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_omusutaa) end)
  SkySceneKit.say({english=" Hey! I remember!", french=" Eh, ça me revient!", german=" Hey! Ich erinnere mich!", italian=" Ehi! Mi ricordo!", spanish=" ¡Eh! ¡Ahora lo recuerdo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_omusutaa, npc_npc_kabutopusu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_omusutaa) end)
  SkySceneKit.say({english="[CS:N]Kabutops[CR]![K] That big hero's been\nhere before!", french="[CS:N]Kabutops[CR]![K] On l'a déjà vu,\nce héros-là!", german="[CS:N]Kabutops[CR]![K] Dieser große Held\nwar schon einmal hier!", italian="[CS:N]Kabutops[CR]![K] Quel grande eroe è\ngià stato qui!", spanish="¡[CS:N]Kabutops[CR]![K]\n¡Este \"héroe\" ya estuvo aquí!"})
  pcall(function() UI:SetSpeaker(npc_npc_omusutaa) end)
  SkySceneKit.say({english="We knocked him out the same\nway too!", french="Et la dernière fois, on l'a mis\nK.O. de la même manière!", german="Wir haben ihn auf die gleiche\nWeise umgehauen!", italian="L'avevamo sconfitto nello stesso\nmodo.", spanish="Y le dejamos fuera de combate\nen una situación parecida."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_omusutaa, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_kabutopusu) end)
  SkySceneKit.say({english="This is the second time he's done\nthat?[K] That really takes a whole lot of smarts!", french="Un récidiviste?[K] Il faut croire\nqu'il n'est vraiment pas fin, celui-là!", german="Das hat er schon zum zweiten\nMal gemacht?[K] Dafür muss man schon reichlich\ndoof sein!", italian="È la seconda volta che lo fa?[K]\nBisogna essere proprio furbi!", spanish="¿Esta ya es la segunda vez que\nlo hace?[K] ¡Desde luego no es muy listo!"})
  pcall(function() UI:SetSpeaker(npc_npc_kabutopusu) end)
  SkySceneKit.say({english=" Ha ha ha!", french=" Ha ha ha!", german=" Ha ha ha!", italian=" Ah ah ah!", spanish=" ¡Ja, ja, ja!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Urrgghh...[K] Say what you will...", french="Arrgghh...[K] Vous pouvez bien vous\nmoquer...", german=" Urrgghh...[K] Sagt, was ihr wollt...", italian="Urrgghh...[K] Dite quello che\nvolete...", spanish="¡Cruaac![K]\nPodéis decir lo que queráis..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" They're...[K]our prized recruits!", french="Ce sont...[K] de précieuses\nrecrues!", german="Diese beiden...[K] Sie sind unsere\nbesten Rekruten!", italian="Loro sono...[K] le nostre preziose\nreclute!", spanish="Pero son...[K]\n¡aprendices de nuestro [CS:N]Pokégremio[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" I won't let you harm them!", french="Je ne vous laisserai pas\nleur faire du mal!", german="Ich lasse nicht zu, dass ihnen\netwas zustößt!", italian="Non permetterò che facciate\nloro del male.", spanish=" ¡No dejaré que les hagáis daño!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Ch-Chatot[CR]...", french=" [CS:N]P-Pijako[CR]...", german=" [CS:N]P-Plaudagei[CR]...", italian=" [CS:N]Ch-Chatot[CR]...", spanish=" [CS:N]Chatot[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Ch-Chatot[CR]...", french=" [CS:N]P-Pijako[CR]...", german=" [CS:N]P-Plaudagei[CR]...", italian=" [CS:N]Ch-Chatot[CR]...", spanish=" [CS:N]Chatot[CR]..."})
  else
  SkySceneKit.say({english=" [CS:N]Ch-Chatot[CR]...", french=" [CS:N]P-Pijako[CR]...", german=" [CS:N]P-Plaudagei[CR]...", italian=" [CS:N]Ch-Chatot[CR]...", spanish=" [CS:N]Chatot[CR]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Urrgghh...", french=" Arrgghh...", german=" Urrgghh...", italian=" Urrgghh...", spanish=" Grrr..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(31) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  -- GAP: se_Play(7185) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(34) [anim idle native]
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Chatot[CR]!", french=" [CS:N]Pijako[CR]!", german=" [CS:N]P-Plaudagei[CR]!", italian=" [CS:N]Chatot[CR]!", spanish=" ¡[CS:N]Chatot[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Chatot[CR]!", french=" [CS:N]Pijako[CR]!", german=" [CS:N]P-Plaudagei[CR]!", italian=" [CS:N]Chatot[CR]!", spanish=" ¡[CS:N]Chatot[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]Chatot[CR]!", french=" [CS:N]Pijako[CR]!", german=" [CS:N]P-Plaudagei[CR]!", italian=" [CS:N]Chatot[CR]!", spanish=" ¡[CS:N]Chatot[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kabutopusu) end)
  SkySceneKit.say({english=" Ha ha ha!", french=" Ha ha ha!", german=" Ha ha ha!", italian=" Ah ah ah!", spanish=" ¡Ja, ja, ja!"})
  pcall(function() UI:SetSpeaker(npc_npc_kabutopusu) end)
  SkySceneKit.say({english=" It's your turn next!", french=" C'est à votre tour maintenant!", german=" Ihr seid als Nächstes dran!", italian=" Adesso tocca a voi!", spanish=" ¡Ahora es vuestro turno!"})
  pcall(function() UI:SetSpeaker(npc_npc_kabutopusu) end)
  SkySceneKit.say({english=" Take THIS!", french=" Prenez ÇA!", german=" Nehmt DAS!", italian=" Prendete QUESTO!", spanish=" ¡Tomad esto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(37, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
