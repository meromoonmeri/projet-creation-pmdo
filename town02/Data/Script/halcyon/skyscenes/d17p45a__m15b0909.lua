-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D17P45A/m15b0909.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D17P45A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_agunomu = SkySceneKit.spawn_npc("azelf", 352, 216, Direction.Down, "NPC_AGUNOMU")
  GROUND:EntTurn(npc_npc_agunomu, Direction.DownRight)
  -- SetAnimation(42) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 352, 144, Direction.Up, "NPC_JUPUTORU")
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Th-this...", french=" C'est...", german=" D-der...", italian=" Il... lago...", spanish=" ¿Qué has hecho?"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="The lake is covered by\ncrystals...", french="Le lac est recouvert\nde cristaux...", german="Der See ist von lauter Kristallen\nbedeckt...", italian=" Il lago è coperto dai cristalli...", spanish="El lago se ha cubierto de\ncristales..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="There's no way of getting at the\nTime Gear!", french="Le Rouage du Temps est hors\nd'atteinte!", german="Es ist unmöglich, an das Zahnrad\nder Zeit heranzukommen!", italian="È impossibile raggiungere\nl'Ingranaggio del Tempo!", spanish="¡No hay forma de llegar\nal Engranaje del Tiempo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english=" [CS:N]Grovyle[CR]...", french=" [CS:N]Massko[CR]...", german=" [CS:N]Reptain[CR]...", italian=" [CS:N]Grovyle[CR]...", spanish=" [CS:N]Grovyle[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english="The Time Gear...[K] You'll never\nget it now...", french="Le Rouage du Temps...[K]\ntu ne mettras jamais la main dessus...", german="Das Zahnrad der Zeit...[K] Es ist\nfür dich jetzt unerreichbar...", italian="Non riuscirai mai...[K] a prendere\nl'Ingranaggio del Tempo...", spanish="El Engranaje del Tiempo...[K]\nAhora nunca lo alcanzarás."})
  pcall(function() UI:SetSpeaker(npc_npc_agunomu) end)
  SkySceneKit.say({english="Even in exchange for my\nlife...[K] You'll never...", french="Même si je dois le payer\nde ma vie...[K] jamais tu ne...", german="Selbst wenn du mich besiegst...[K]\nDu wirst niemals...", italian=" Eliminare me...[K] non ti servirà...", spanish="Nunca lo conseguirás...[K]\naunque me vaya la vida en ello."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, npc_npc_agunomu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Y-you!", french=" Toi!", german=" D-du!", italian=" Tu!", spanish=" ¡Basta!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I mean to have it, and I will\nget it![K] I need the Time Gear!", french="Je veux l'avoir et je l'aurai![K]\nJ'ai besoin de ce Rouage du Temps!", german="Ich muss es haben, und ich\nwerde es bekommen![K] Ich brauche dieses\nZahnrad der Zeit!", italian="Non me ne andrò da qui...[K] senza\nl'Ingranaggio del Tempo!", spanish="¡He venido a por él, y me lo voy\na llevar![K] ¡Necesito ese Engranaje del Tiempo!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Even if it means eliminating you,\n[CS:N]Azelf[CR]!", french="Même si je dois t'éliminer,\n[CS:N]Créfadet[CR]!", german="Selbst wenn ich dich dazu aus\ndem Weg räumen muss, [CS:N]Tobutz[CR]!", italian=" Mettitelo bene in testa, [CS:N]Azelf[CR]!", spanish="¡Aunque eso suponga tener que\neliminarte, [CS:N]Azelf[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hold it!", french=" Halte!", german=" Halt!", italian=" Basta!", spanish=" ¡Alto!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Stop!", french=" Halte!", german=" Stopp!", italian=" Basta!", spanish=" ¡Alto!"})
  else
  SkySceneKit.say({english=" Stop!", french=" Halte!", german=" Stopp!", italian=" Basta!", spanish=" ¡Alto!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(22) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_agunomu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(partner, 316, 204, false, 2)
  GROUND:MoveToPosition(hero, 380, 204, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 308, 212, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 384, 212, false, 2) end end
  GROUND:MoveToPosition(partner, 332, 188, false, 2)
  GROUND:MoveToPosition(hero, 364, 188, false, 2)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You're not taking the Time Gear,\n[CS:N]Grovyle[CR]!", french="Tu ne partiras pas avec\nle Rouage du Temps, [CS:N]Massko[CR]!", german="Du wirst das Zahnrad der Zeit\nnicht mitnehmen, [CS:N]Reptain[CR]!", italian="Non riuscirai a mettere le mani\nsull'Ingranaggio del Tempo, [CS:N]Grovyle[CR]!", spanish="¡No te llevarás el Engranaje del\nTiempo, [CS:N]Grovyle[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You're not stealing another\nTime Gear, [CS:N]Grovyle[CR]!", french="Tu ne partiras pas avec\nle Rouage du Temps, [CS:N]Massko[CR]!", german="Du wirst das Zahnrad der Zeit\nnicht stehlen, [CS:N]Reptain[CR]!", italian="Non riuscirai a mettere le mani\nsull'Ingranaggio del Tempo, [CS:N]Grovyle[CR]!", spanish="¡No robarás otro Engranaje del\nTiempo, [CS:N]Grovyle[CR]!"})
  else
  SkySceneKit.say({english="You're not taking the Time Gear,\n[CS:N]Grovyle[CR]!", french="Tu ne partiras pas avec\nle Rouage du Temps, [CS:N]Massko[CR]!", german="Du wirst das Zahnrad der Zeit\nnicht mitnehmen, [CS:N]Reptain[CR]!", italian="Non riuscirai a mettere le mani\nsull'Ingranaggio del Tempo, [CS:N]Grovyle[CR]!", spanish="¡No te llevarás el Engranaje del\nTiempo, [CS:N]Grovyle[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I have no quarrel with you.[K]\nOut of the way!", french="Vous n'avez rien à voir\ndans tout ça.[K] Hors de mon chemin!", german="Ich will euch nichts tun.[K]\nGeht mir aus dem Weg!", italian="Non ho niente da dire a voi due.[K]\nFuori dai piedi!", spanish="No tengo nada en contra vuestra.[K]\n¡Fuera de mi camino!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Never! You can't make me!", french="Jamais! Il faudra me passer\nsur le corps!", german=" Niemals! Ich gehe nicht!", italian=" No! Non ce ne andremo!", spanish="¡De eso ni hablar! ¡No pienso\nmoverme!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" No! I won't move!", french="Jamais! Il faudra me passer\nsur le corps!", german=" Nein! Ich gehe nicht!", italian=" No! Non ce ne andremo!", spanish=" ¡Me niego! ¡No pienso moverme!"})
  else
  SkySceneKit.say({english=" No way! You can't make me!", french="Jamais! Il faudra me passer\nsur le corps!", german=" Auf keinen Fall! Ich gehe nicht!", italian=" No! Non ce ne andremo!", spanish=" ¡Me niego! ¡No pienso moverme!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Are you serious?!", french=" Tu plaisantes?!", german=" Ist das dein Ernst?!?", italian=" Dite sul serio?!", spanish=" ¿Lo dices en serio?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5124) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Then if you won't stand aside...", french="Si vous refusez de vous\nécarter...", german="Wenn du mir nicht aus dem Weg\ngehst...", italian="Bene. Non volete farvi da parte\ncon le buone, eh?", spanish=" Si no queréis apartaros..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" You leave me with no choice!", french=" Vous ne me laissez pas le choix!", german=" Dann lässt du mir keine Wahl!", italian="Allora sarò costretto a usare la\nforza!", spanish=" ¡No me queda otra elección!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" I'll knock you out first!", french=" Je vais devoir vous anéantir!", german="Ich werde dich aus dem Weg\nräumen!", italian=" Ci siete?", spanish="¡Tendré que dejaros fuera de\ncombate!"})
  pcall(function() SOUND:FadeOutBGM(30) end)
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
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Just try to stop me!", french=" Essayez donc de m'arrêter!", german=" Versuch nur, mich aufzuhalten!", italian=" Fatevi sotto!", spanish=" ¡Intentad detenerme si podéis!"})
  -- message_Close
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(26, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
