-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D10P41A/m10a1101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D10P41A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_guraadon = SkySceneKit.spawn_npc("groudon", 328, 168, Direction.Down, "NPC_GURAADON")
  -- SetAnimation(42) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: se_Play(6917) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect 244 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GAME:MoveCamera(352, 156, 1, false) end) -- SetPositionMark performer/caméra
  -- GAP: se_Play(6917) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect 244 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GAME:MoveCamera(324, 188, 1, false) end) -- SetPositionMark performer/caméra
  -- GAP: se_Play(6917) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect 244 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_guraadon) end)
  SkySceneKit.say({english=" GRROOOoooh...[K]oooooh...", french=" GRROOOoooh...[K] oooooh...", german=" GRROOOoooh...[K]oooooh...", italian=" GRROOOoooh...[K] oooooh...", spanish=" Grrrrr...[K] Grrrr..."})
  -- message_KeyWait
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_guraadon) end)
  SkySceneKit.say({english=" GRROOOOOOH!", french=" GRROOOOOOH!", german=" GRROOOOOOH!", italian=" GRROOOOOOH!", spanish=" ¡GRRRRRRR!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(80)
  -- GAP: se_Play(6918) — id SE NDS sans portage PMDO identifié
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
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We did it! We KO'd [CS:N]Groudon[CR]!", french="On a réussi! On a vaincu\n[CS:N]Groudon[CR]!", german="Wir haben es geschafft!\nWir haben [CS:N]Groudon[CR] kampfunfähig gemacht!", italian="Sì![K] Abbiamo sconfitto\n[CS:N]Groudon[CR]!", spanish="¡Lo logramos! ¡Hemos vencido\na [CS:N]Groudon[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We did it! We defeated [CS:N]Groudon[CR]!", french="On a réussi! On a vaincu\n[CS:N]Groudon[CR]!", german="Wir haben es geschafft!\nWir haben [CS:N]Groudon[CR] besiegt!", italian="Ce l'abbiamo fatta![K] Abbiamo\nsconfitto [CS:N]Groudon[CR]!", spanish="¡Lo logramos! ¡Hemos vencido\na [CS:N]Groudon[CR]!"})
  else
  SkySceneKit.say({english="We did it! We actually defeated\n[CS:N]Groudon[CR]!", french="On a réussi! On a vaincu\n[CS:N]Groudon[CR]!", german="Wir haben es geschafft!\nWir haben [CS:N]Groudon[CR] tatsächlich besiegt!", italian="Non ci posso credere![K] Abbiamo\ndavvero sconfitto [CS:N]Groudon[CR]?", spanish="¡Lo logramos! ¡Hemos vencido\na [CS:N]Groudon[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But...[K]is it really...?", french="Mais...[K] est-ce qu'il est\nvraiment...?", german=" Aber...[K] ist das wirklich?", italian=" Aspetta...[K] sarà veramente...?", spanish="Pero...[K] ¿lo hemos vencido?\n¿De verdad?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But...[K]is it really...?", french="Mais...[K] est-ce qu'il est\nvraiment...?", german=" Aber...[K] ist das wirklich?", italian=" Aspetta...[K] sarà veramente...?", spanish="Pero...[K] ¿lo hemos vencido?\n¿De verdad?"})
  else
  SkySceneKit.say({english=" But...[K]is it really...?", french="Mais...[K] est-ce qu'il est\nvraiment...?", german=" Aber...[K] ist das wirklich?", italian=" Oh...[K] sarà davvero...?", spanish="Pero...[K] ¿lo hemos vencido?\n¿De verdad?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: se_Play(6919) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(56)
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Waaah!", italian=" Eeeeh?", spanish=" ¡Aaaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Waaah!", italian=" Waaah!", spanish=" ¡Aaaaah!"})
  else
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Waaah!", italian=" Waaah!", spanish=" ¡Aaaaah!"})
  end
  GAME:FadeOut(true, 60) -- screen_WhiteOutAll
  -- Destroy() [neutre/état moteur]
  -- message_CloseEnforce
  GAME:WaitFrames(45)
  GAME:FadeIn(0)
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?[K] Where did [CS:N]Groudon[CR] go?!", french=" Hein?[K] [CS:N]Groudon[CR] a disparu?!", german=" Huch?[K] Wo ist [CS:N]Groudon[CR] hin?!?", italian=" Eh?[K] E dov'è andato [CS:N]Groudon[CR]?", spanish=" ¿Eh?[K] ¡¿Adónde ha ido [CS:N]Groudon[CR]?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh?[K] [CS:N]Groudon[CR] disappeared?!", french=" Hein?[K] [CS:N]Groudon[CR] a disparu?!", german=" Huch?[K] [CS:N]Groudon[CR] ist weg?!?", italian=" Eh?[K] [CS:N]Groudon[CR] è scomparso!", spanish=" ¿Eh?[K] ¡¿Adónde ha ido [CS:N]Groudon[CR]?!"})
  else
  SkySceneKit.say({english=" Huh?[K] [CS:N]Groudon[CR] vanished?!", french=" Hein?[K] [CS:N]Groudon[CR] a disparu?!", german="Huch?[K] [CS:N]Groudon[CR] ist\nverschwunden?", italian=" Oh![K] [CS:N]Groudon[CR] è sparito?", spanish=" ¿Eh?[K] ¡¿Adónde ha ido [CS:N]Groudon[CR]?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" That was...", french=" Ça n'était pas...", german=" Das war...", italian=" Quello...", spanish=" Aquel..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" That was not [CS:N]Groudon[CR].", french=" Ça n'était pas [CS:N]Groudon[CR].", german=" Das war nicht [CS:N]Groudon[CR].", italian=" Quello non era [CS:N]Groudon[CR].", spanish=" Aquel no era [CS:N]Groudon[CR]."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="That [CS:N]Groudon[CR] was nothing more than an\nillusion that I conjured.", french="Ce [CS:N]Groudon[CR]-là n'était qu'une illusion\nque j'ai fait apparaître.", german="[CS:N]Groudon[CR] war nichts weiter als\neine Illusion, die ich heraufbeschworen habe.", italian="Il [CS:N]Groudon[CR] contro il quale avete\nlottato non era altro che un'illusione,\ncreata da me.", spanish="Ese [CS:N]Groudon[CR] no era más que una ilusión\nque yo había creado."})
  -- message_Close
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" OK, who said that?!", french=" Qui a dit ça?!", german=" Okay, wer hat das gesagt?!?", italian=" Ok, chi ha parlato?", spanish=" ¡¿Quién ha dicho eso?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Who said that?", french=" Qui a dit ça?!", german=" Wer hat das gesagt?", italian=" Chi ha parlato?", spanish=" ¿Quién ha dicho eso?"})
  else
  SkySceneKit.say({english=" Who...who said that?", french=" Qui a dit ça?!", german=" Wer... Wer hat das gesagt?", italian=" Chi... Chi ha parlato?", spanish=" ¿Quién... quién ha dicho eso?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
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
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Like I said earlier, I am the guardian here.", french="Comme je vous l'ai dit, je suis le gardien\nde ces lieux.", german="Wie ich bereits sagte, bewache ich\ndiesen Ort.", italian="Come vi ho detto in precedenza, io sono il\nguardiano di questo luogo.", spanish="Tal y como os dije antes, soy el guardián\nde este lugar."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" And I cannot allow you to pass.", french=" Et je ne peux pas vous laisser passer.", german=" Und ich kann euch nicht durchlassen.", italian=" E non posso permettervi di passare.", spanish=" Y no puedo permitir que paséis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wait!", french=" Attendez!", german=" Warte!", italian=" Aspetta!", spanish=" ¡Espera!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wait, please!", french=" Attendez!", german=" Warte, bitte!", italian=" Un momento, per favore!", spanish=" ¡Espera, por favor!"})
  else
  SkySceneKit.say({english=" W-wait, please!", french=" Attendez!", german=" W-warte, bitte!", italian=" P-Per piacere, un attimo!", spanish=" ¡Espera, por favor!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We didn't come to make trouble!", french="On n'est pas là pour créer\ndes ennuis!", german="Wir kommen nicht, um Ärger\nzu machen!", italian=" Non abbiamo cattive intenzioni!", spanish="¡No hemos venido a causar\nproblemas!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We're not here to cause trouble!", french="On n'est pas là pour créer\ndes ennuis!", german="Wir haben nicht die Absicht,\nÄrger zu machen!", italian=" Non abbiamo cattive intenzioni!", spanish="¡No estamos aquí para causar\nproblemas!"})
  else
  SkySceneKit.say({english="We don't mean to cause\nany trouble!", french="On n'est pas là pour créer\ndes ennuis!", german="Wir wollen überhaupt keinen\nÄrger machen!", italian=" Non abbiamo cattive intenzioni!", spanish="¡No pretendemos causar ningún\nproblema!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We came only to get some\ninformation! That's all!", french="On veut juste des informations!\nC'est tout!", german="Wir kommen nur, um\nInformationen zu erhalten! Das ist alles!", italian="Vogliamo solo delle informazioni!\nTutto qui!", spanish="¡Solo hemos venido a buscar\ninformación! ¡Eso es todo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We came only for information!", french="On veut juste des informations!\nC'est tout!", german=" Wir wollen nur Informationen!", italian="Vogliamo solo delle informazioni!\nTutto qui!", spanish="¡Solo hemos venido a buscar\ninformación!"})
  else
  SkySceneKit.say({english="We came only to get a little\ninformation! Th-that's all!", french="On veut juste des informations!\nC'est tout!", german="Wir wollen nur ein paar\nInformationen! D-das ist alles!", italian="Vogliamo solo delle informazioni!\nTutto qui!", spanish="¡Solo hemos venido a buscar\nun poco de información! ¡Eso es todo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Information, you say?", french=" Des informations, dites-vous?", german=" Informationen, sagt ihr?", italian=" Informazioni, dite?", spanish=" ¿Información, decís?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yes! That's all. No lie!", french=" Oui, c'est tout. Sans mentir!", german=" Ja! Das ist alles. Ungelogen!", italian=" Sì! È così. Sul serio!", spanish=" ¡Sí! Nada más. ¡No mentimos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes! That's the honest truth!", french=" Oui, c'est tout. Sans mentir!", german=" Ja! Das ist die reine Wahrheit!", italian=" Sì! È la verità!", spanish=" ¡Sí! ¡Decimos la verdad!"})
  else
  SkySceneKit.say({english=" We're telling the total truth!", french=" Oui, c'est tout. Sans mentir!", german=" Wir sagen die reine Wahrheit!", italian=" È così! Devi crederci!", spanish=" ¡Estamos diciendo la verdad!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="OK, OK! We're an exploration\nteam, sure...", french="D'accord, d'accord! La vérité,\nc'est qu'on est une équipe d'exploration...", german="Okay, okay! Wir sind ein\nErkundungsteam. Das stimmt...", italian="Ok, ok! È vero che siamo una\nsquadra d'esplorazione...", spanish="Bueno, lo cierto es que somos\nun equipo explorador."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well, we admit that we're an\nexploration team...", french="D'accord, d'accord! La vérité,\nc'est qu'on est une équipe d'exploration...", german="Na ja, zugegeben, wir sind ein\nErkundungsteam...", italian="D'accordo, ammetto che siamo\nuna squadra d'esplorazione...", spanish="Bueno, admito que somos\nun equipo explorador."})
  else
  SkySceneKit.say({english="Well, the totally total truth is\nthat we're an exploration team...", french="D'accord, d'accord! La vérité,\nc'est qu'on est une équipe d'exploration...", german="Na ja, die reine Wahrheit ist,\nwir sind ein Erkundungsteam...", italian="D'accordo, ammetto che siamo\nuna squadra d'esplorazione...", spanish="Bueno, la verdad es que somos\nun equipo explorador."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And we'd like to score a\ntreasure for coming all this way!", french="Et on aimerait bien repartir avec\nun trésor après tous les efforts qu'on a faits\npour arriver jusqu'ici!", german="Und dafür, dass wir den ganzen\nWeg gekommen sind, würden wir gerne einen\nSchatz mitnehmen!", italian="... e ci piacerebbe trovare un bel\ntesoro dopo aver fatto tutta questa strada!", spanish="¡Y nos gustaría conseguir algún\ntipo de tesoro por el esfuerzo de haber\nllegado hasta aquí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And we'd like to leave with\ntreasure after all our effort!", french="Et on aimerait bien repartir avec\nun trésor après tous les efforts qu'on a faits\npour arriver jusqu'ici!", german="Und nach all den Anstrengungen\nwürden wir gerne einen Schatz mitnehmen!", italian="... e non ci dispiacerebbe affatto\nse, dopo aver fatto tanta strada, riuscissimo\na mettere le mani su un bel tesoro!", spanish="¡Y nos gustaría marcharnos con\nalgún tipo de tesoro como recompensa por el\nesfuerzo que hemos hecho para llegar aquí!"})
  else
  SkySceneKit.say({english="And we really would love to\nleave with a treasure after all this work!", french="Et on aimerait bien repartir avec\nun trésor après tous les efforts qu'on a faits\npour arriver jusqu'ici!", german="Und nach all den Anstrengungen\nwürden wir wirklich gerne einen Schatz\nmitnehmen!", italian="... e non ci dispiacerebbe affatto\nse, dopo aver fatto tanta strada, riuscissimo\na mettere le mani su un bel tesoro!", spanish="¡Y nos gustaría marcharnos con\nalgún tesoro después de lo mucho que nos\nhemos esforzado!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But if you have a big problem\nwith that, we'll leave without treasure!", french="Mais si ça vous pose problème,\non repartira les mains vides!", german="Aber wenn du damit ein großes\nProblem hast, gehen wir eben ohne Schatz!", italian="Ma non è un problema! Possiamo\nanche farne a meno! Se c'è un tesoro, lo\nlasciamo dov'è, ok?", spanish="Pero si hay algún problema con\neso, nos iremos sin tesoro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But we'll leave without any if\nyou have a problem with that.", french="Mais si ça vous pose problème,\non repartira les mains vides!", german="Aber wir gehen auch ohne, wenn\ndu damit ein Problem hast.", italian="Ma non vogliamo causare\nproblemi! Se c'è un tesoro, lo lasceremo\ndov'è, d'accordo?", spanish="Pero si no te parece bien, nos\niremos sin tesoro."})
  else
  SkySceneKit.say({english="But we don't want any if that's\ngoing to cause trouble!", french="Mais si ça vous pose problème,\non repartira les mains vides!", german="Aber wir wollen keinen, wenn\nuns das in Schwierigkeiten bringt!", italian="Ma non vogliamo causare\nproblemi! Se c'è un tesoro, lo lasceremo\ndov'è, d'accordo?", spanish="Pero si eso va a causar\nproblemas, nos iremos sin él."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We'll have to be satisfied with\njust making it this far!", french="On aura déjà la satisfaction\nd'avoir atteint cet endroit!", german="Dann müssen wir uns damit\nzufriedengeben, so weit gekommen zu sein!", italian="Per noi va bene anche solo\nessere arrivati fin qui!", spanish="Nos bastará la satisfacción de\nhaber podido llegar hasta aquí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We'll be happy to say that we\njust made it this far.", french="On aura déjà la satisfaction\nd'avoir atteint cet endroit!", german="Wir sind auch zufrieden damit,\nso weit gekommen zu sein.", italian="Il nostro tesoro sarà essere\narrivati fino in fondo!", spanish="Nos bastará la satisfacción de\nhaber podido llegar hasta aquí."})
  else
  SkySceneKit.say({english="We'll be delighted to say that we\njust made it this far!", french="On aura déjà la satisfaction\nd'avoir atteint cet endroit!", german="Wir sind schon froh, sagen zu\nkönnen, dass wir so weit gekommen sind!", italian="Il nostro tesoro sarà avere\nraggiunto questo posto!", spanish="Nos bastará la satisfacción de\nhaber podido llegar hasta aquí."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" C'mon! You have to believe me!", french=" Allez, vous devez me croire!", german="Komm schon! Das musst du mir\nglauben!", italian=" E dai! Devi crederci!", spanish=" ¡Por favor, tienes que creernos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Please! Please believe us!", french=" Allez, vous devez me croire!", german=" Bitte! Bitte glaube uns!", italian=" Per favore! Devi crederci!", spanish=" ¡Por favor, tienes que creernos!"})
  else
  SkySceneKit.say({english="Oh, please! You simply must\nbelieve me!", french=" Allez, vous devez me croire!", german="Oh, bitte! Du musst mir einfach\nglauben!", italian=" Per favore! Devi crederci!", spanish=" ¡Por favor, tienes que creernos!"})
  end
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Hmm...", french=" Hum...", german=" Hmm...", italian=" Mmm...", spanish=" Hum."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Well...[K]OK, I believe you.", french=" Soit...[K] Je vous crois.", german=" Nun...[K] Okay, ich glaube euch.", italian=" D'accordo...[K] Voglio credervi.", spanish=" Bueno...[K] De acuerdo, os creo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
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
  -- GAP: se_Play(6920) — id SE NDS sans portage PMDO identifié
  pcall(function() GAME:MoveCamera(324, 168, 1, false) end) -- SetPositionMark performer/caméra
  -- GAP: SetEffect EFFECT_LIGHT_ENGULFING2 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(154)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitSe
  local npc_npc_yukushii = SkySceneKit.spawn_npc("uxie", 328, 184, Direction.Down, "NPC_YUKUSHII")
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english=" Let me welcome you, then.", french=" Permettez-moi de me présenter.", german=" Dann lasst mich euch willkommen heißen.", italian=" Lasciate che mi presenti.", spanish="Entonces, permitidme que os dé\nla bienvenida."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="I am [CS:N]Uxie[CR], the guardian of\n[CS:P]Fogbound Lake[CR].", french="Je m'appelle [CS:N]Créhelf[CR], et je suis le gardien\ndu [CS:P]Lac des Brumes[CR].", german=" Ich bin [CS:N]Selfe[CR], Wächter des [CS:P]Nebelsees[CR].", italian=" Io sono [CS:N]Uxie[CR], il guardiano del [CS:P]Lago Foschia[CR].", spanish=" Soy [CS:N]Uxie[CR], el guardián del [CS:P]Lago Velado[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" No way! [K]Did you say [CS:N]Uxie[CR]?!", french="Pas possible![K] [CS:N]Créhelf[CR],\ntu dis?!", german=" Was?!? [K]Sagtest du [CS:N]Selfe[CR]?!?", italian=" No! Davvero?[K] Hai detto [CS:N]Uxie[CR]?", spanish="¡No puede ser![K]\n¡¿Has dicho [CS:N]Uxie[CR]?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?![K] Did you say [CS:N]Uxie[CR]?!", french="Pas possible![K] [CS:N]Créhelf[CR],\ntu dis?!", german=" Was?!? [K]Sagtest du [CS:N]Selfe[CR]?!?", italian=" Veramente?[K] Hai detto [CS:N]Uxie[CR]?", spanish=" ¡¿Qué?![K] ¡¿Has dicho [CS:N]Uxie[CR]?!"})
  else
  SkySceneKit.say({english=" P-pardon?![K] Did you say [CS:N]Uxie[CR]?!", french="Pas possible![K] [CS:N]Créhelf[CR],\ntu dis?!", german=" B-bitte?!? [K]Sagtest du [CS:N]Selfe[CR]?!?", italian=" C-Come?[K] Hai detto [CS:N]Uxie[CR]?", spanish=" ¡¿Cómo?![K] ¡¿Has dicho [CS:N]Uxie[CR]?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english=" Yes, truly.", french=" Absolument.", german=" Ja, das habe ich gesagt.", italian=" Sono io.", spanish=" Así es."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="I stand guard over something\nspecial...[K]that lies in [CS:P]Fogbound Lake[CR].", french="Je protège un objet très\nprécieux...[K] qui repose au fond du [CS:P]Lac\ndes Brumes[CR].", german="Ich bewache etwas\nBesonderes...[K] Etwas, das im [CS:P]Nebelsee[CR] liegt.", italian="Custodisco il segreto...[K] che\ngiace sul fondo del [CS:P]Lago Foschia[CR].", spanish="Custodio algo muy especial...[K]\nque se encuentra en el [CS:P]Lago Velado[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="Now, let me escort you to\n[CS:P]Fogbound Lake[CR].", french="Laissez-moi vous escorter\njusqu'au [CS:P]Lac des Brumes[CR].", german="Lasst mich euch nun zum\n[CS:P]Nebelsee[CR] bringen.", italian="Lasciate ora che vi accompagni\nal [CS:P]Lago Foschia[CR].", spanish="Ahora, permitidme que os\nacompañe al [CS:P]Lago Velado[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english=" Please, come this way.", french=" Si vous voulez bien me suivre.", german=" Bitte, hier entlang.", italian=" Prego, da questa parte.", spanish=" Seguidme, por favor."})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_yukushii, 324, 84, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  GROUND:MoveToPosition(partner, 304, 84, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 344, 84, false, 2)
  GAME:WaitFrames(20)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT = 9 -- $COMPULSORY_SAVE_POINT = 9 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
