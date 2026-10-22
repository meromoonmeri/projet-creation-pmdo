-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D10P41A/m10a0903.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D10P41A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2', '0')
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  -- MoveHeight(2, 5) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(2, 5) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(90)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2', '0')
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  -- MoveHeight(2, 5) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(2, 5) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(15)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  SkySceneKit.say({english="GRROOOOOOH...GRROOOOOOH...!", french="GRROOOOOOH... GRROOOOOOH...!", german="GRROOOOOOH... GRROOOOOOH!", italian="GRROOOOOOH... GRROOOOOOH...!", spanish="¡GRRRRRRRR! ¡GRRRRRRRRRR!"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_guraadon = SkySceneKit.spawn_npc("groudon", 328, 96, Direction.Down, "NPC_GURAADON")
  do local p=npc_npc_guraadon.Position; GROUND:MoveToPosition(npc_npc_guraadon, p.X+(0), p.Y+(80), false, 1) end
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(10)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(10)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-what is that?!", french="Que... qu'est-ce que c'est\nque ça?!", german=" W-was ist das?!?", italian=" Eh? E quello chi è?", spanish=" ¿Qué... qué es eso?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaah! Wh-what is that?!", french="Que... qu'est-ce que c'est\nque ça?!", german=" Waaah! W-was ist das?!?", italian=" Waaah! Cos'è quello?", spanish=" ¿Qué... qué es eso?"})
  else
  SkySceneKit.say({english=" Waaah! Wh-what is that?!", french="Que... qu'est-ce que c'est\nque ça?!", german=" Waaah! W-was ist das?!?", italian=" Aaaah! C-Cos'è quello?", spanish=" ¿Qué... qué es eso?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It looks like the statue!", french=" On dirait la statue!", german=" Es sieht aus wie die Statue!", italian="È uguale a quella statua di\nprima!", spanish=" ¡Se parece a la estatua!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It looks like the statue!", french=" On dirait la statue!", german=" Es sieht aus wie die Statue!", italian="È uguale a quella statua di\nprima!", spanish=" ¡Se parece a la estatua!"})
  else
  SkySceneKit.say({english=" It looks like the statue!", french=" On dirait la statue!", german=" Es sieht aus wie die Statue!", italian="È uguale a quella statua di\nprima!", spanish=" ¡Se parece a la estatua!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Th-that Pokémon...[K]really exists?", french="Mais alors...[K] ce Pokémon existe\npour de vrai?", german="D-dieses Pokémon...[K] Es existiert\nwirklich?", italian="E così quel Pokémon...[K]\n... esiste davvero?", spanish="Ese... ese Pokémon...[K]\n¿es de verdad?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Th-that Pokémon...[K]really exists?", french="Mais alors...[K] ce Pokémon existe\npour de vrai?", german="D-dieses Pokémon...[K] Es existiert\nwirklich?", italian="Quel Pokémon...[K] esiste\ndavvero?", spanish="Ese... ese Pokémon...[K]\n¿es de verdad?"})
  else
  SkySceneKit.say({english=" Th-that Pokémon...[K]really exists?", french="Mais alors...[K] ce Pokémon existe\npour de vrai?", german="D-dieses Pokémon...[K] Es existiert\nwirklich?", italian="Quel Pokémon...[K] esiste\ndavvero?", spanish="Ese... ese Pokémon...[K]\n¿es de verdad?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(9) [anim idle native]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" GRROOOOOOH...GRROOOOOOH...!", french=" GRROOOOOOH... GRROOOOOOH...!", german=" GRROOOOOOH... GRROOOOOOH!", italian=" GRROOOOOOH... GRROOOOOOH...!", spanish=" ¡GRRRRRRRR! ¡GRRRRRRRRRR!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Eep!", french=" Brrr!", german=" Ieep!", italian=" Waah!", spanish=" ¡Aaay!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Eep!", french=" Brrr!", german=" Ieep!", italian=" Waah!", spanish=" ¡Aaay!"})
  else
  SkySceneKit.say({english=" Eep!", french=" Brrr!", german=" Ieep!", italian=" Waah!", spanish=" ¡Aaay!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_guraadon) end)
  SkySceneKit.say({english=" GRROOOOOOH...!", french=" GRROOOOOOH...!", german=" GRROOOOOOH!", italian=" VOI!", spanish=" ¡GRRRRRRRR!"})
  pcall(function() UI:SetSpeaker(npc_npc_guraadon) end)
  SkySceneKit.say({english="YOU! HAVE YOU COME TO DESECRATE\nTHIS PLACE?", french="VOUS! AVEZ-VOUS L'INTENTION\nDE PROFANER CE LIEU?", german="IHR! SEID IHR GEKOMMEN, UM DIESEN\nORT ZU ENTWEIHEN?", italian="COME OSATE PROFANARE QUESTO\nLUOGO?", spanish=" ¿CÓMO OSÁIS PROFANAR ESTE LUGAR?"})
  pcall(function() UI:SetSpeaker(npc_npc_guraadon) end)
  SkySceneKit.say({english=" DEPART NOW!", french=" PARTEZ SUR-LE-CHAMP!", german=" VERSCHWINDET!", italian=" SPARITE DALLA MIA VISTA!", spanish=" ¡MARCHAOS! ¡YA!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="B-but...[K] We just want to go to\n[CS:P]Fogbound Lake[CR]!", french="Mais...[K] on veut juste aller\nau [CS:P]Lac des Brumes[CR]!", german="A-aber...[K] Wir wollen nur zum\n[CS:P]Nebelsee[CR]!", italian="M-Ma...[K] noi vogliamo solo\nandare al [CS:P]Lago Foschia[CR]!", spanish="Pe... pero...[K] ¡Solo queremos\nir al [CS:P]Lago Velado[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="B-but...[K] All we want is to go to\n[CS:P]Fogbound Lake[CR]!", french="Mais...[K] on veut juste aller\nau [CS:P]Lac des Brumes[CR]!", german="A-aber...[K] Wir wollen doch nur\nzum [CS:P]Nebelsee[CR]!", italian="M-Ma...[K] noi vogliamo solo\nandare al [CS:P]Lago Foschia[CR]!", spanish="Pe... pero...[K] ¡Solo queremos\nir al [CS:P]Lago Velado[CR]!"})
  else
  SkySceneKit.say({english="B-b-but...[K] W-w-we only want to\ngo to [CS:P]Fogbound Lake[CR]!", french="Mais...[K] on veut juste aller\nau [CS:P]Lac des Brumes[CR]!", german="A-a-aber...[K] W-w-wir wollen\nnur zum [CS:P]Nebelsee[CR]!", italian="M-Ma...[K] noi vogliamo solo\nandare al [CS:P]Lago Foschia[CR]!", spanish="Pe... pero...[K] ¡Solo queremos\nir al [CS:P]Lago Velado[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_guraadon, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_guraadon) end)
  SkySceneKit.say({english=" WHAT?! [CS:P]FOGBOUND LAKE[CR]?!", french=" QUOI?! LE [CS:P]LAC DES BRUMES[CR]?!", german=" WAS?!? ZUM [CS:P]NEBELSEE[CR]?!?", italian=" COSA? IL [CS:P]LAGO FOSCHIA[CR]?", spanish=" ¡¿CÓMO?! ¡¿EL [CS:P]LAGO VELADO[CR]?!"})
  pcall(function() UI:SetSpeaker(npc_npc_guraadon) end)
  SkySceneKit.say({english="I AM THE GUARDIAN OF [CS:P]FOGBOUND\nLAKE[CR]![K] I AM [CS:N]GROUDON[CR]!", french="JE SUIS LE GARDIEN DU [CS:P]LAC DES BRUMES[CR]!\nMON NOM EST [CS:N]GROUDON[CR]!", german="ICH BEWACHE DEN [CS:P]NEBELSEE[CR]![K]\nICH BIN [CS:N]GROUDON[CR]!", italian="IO SONO [CS:N]GROUDON[CR]![K] SONO IL GUARDIANO\nDEL [CS:P]LAGO FOSCHIA[CR]!", spanish="¡YO SOY EL GUARDIÁN DEL\n[CS:P]LAGO VELADO[CR]![K] ¡SOY [CS:N]GROUDON[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_guraadon) end)
  SkySceneKit.say({english="YOU WILL NEVER LEAVE HERE\nALIVE, INTRUDERS!", french="VOUS ALLEZ REGRETTER\nVOTRE INTRUSION!", german="IHR WERDET DIESEN ORT NICHT\nLEBEND VERLASSEN, EINDRINGLINGE!", italian="GLI INTRUSI COME VOI VENGONO\nSPAZZATI VIA!", spanish="¡VAIS A PAGARLO CARO! ¡NO OS\nPERMITIRÉ SALIR DE AQUÍ CON VIDA!"})
  -- message_Close
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(15)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2', '0')
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  -- MoveHeight(2, 5) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(2, 5) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(15)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whaaat?!", french=" Quoi?!", german=" Waaaas?!?", italian=" Eeeeeh?", spanish=" ¡¿Quéeee?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Whaaat?!", french=" Quoi?!", german=" Waaaas?!?", italian=" Cooooosa?", spanish=" ¡¿Quéeee?!"})
  else
  SkySceneKit.say({english=" Whaaat?!", french=" Quoi?!", german=" Waaaas?!?", italian=" Cooooosa?", spanish=" ¡¿Quéeee?!"})
  end
  -- message_Close
  GAME:FadeOut(false, 15)
  SkySceneKit.cleanup_npcs()
end
