-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P01A/m12a0102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P01A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_G01P01A, 'UM12') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(2) [neutre/état moteur]
  local npc_npc_ruriri = SkySceneKit.spawn_npc("azurill", 224, 208, Direction.Up, "NPC_RURIRI")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_mariru = SkySceneKit.spawn_npc("marill", 256, 208, Direction.Up, "NPC_MARIRU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  -- bgm2_PlayFadeIn(BGM_OCEAN3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_mariru, "exclaim", 1) end)
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(5)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(12), false, 2) end
  GROUND:MoveToPosition(hero, 256, 176, false, 2)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(12), false, 2) end
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:MoveToPosition(partner, 224, 176, false, 2)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english="[partner] and [hero]!\nHi there!", french="Salut, [partner]\net [hero]!", german="[partner] und [hero]!\nHallo!", italian="[partner]! [hero]!\nBuongiorno!", spanish="¡[partner] y [hero]!\n¡Hola!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? It's you little guys...", french=" Ah, c'est vous, les petits gars...", german=" Huch? Oh, ihr seid es...", italian=" Eh? Ah! Siete voi piccoletti...", spanish=" ¿Eh? Mira quiénes están aquí..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh! It's you little guys...", french=" Ah, c'est vous, les petits gars...", german=" Oh! Ihr seid es...", italian=" Ehilà! Come va, piccoli?", spanish=" ¡Oh! Mira quiénes están aquí..."})
  else
  SkySceneKit.say({english=" Hey! It's you little guys...", french=" Ah, c'est vous, les petits gars...", german=" Hey! Ihr seid es...", italian="Buongiorno a voi! Come va,\npiccoli?", spanish=" ¡Eh! Mira quiénes están aquí..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We heard we have visitors.\nAre you our visitors?", french="Il paraît qu'on a de la visite.\nC'est de vous qu'il s'agit?", german="Wir haben gehört, dass wir\nBesuch haben. Seid ihr der Besuch?", italian="Ci hanno detto che c'era qualcuno\nquassù ad aspettarci. Siete forse voi?", spanish="Hemos oído que teníamos visita.\n¿Sois vosotros?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We heard we have visitors.\nAre you our visitors?", french="Il paraît qu'on a de la visite.\nC'est de vous qu'il s'agit?", german="Wir haben gehört, dass wir\nBesuch haben. Seid ihr der Besuch?", italian="Ci hanno detto che avremmo\ntrovato qualcuno che era venuto a farci\nvisita. Siete forse voi?", spanish="Hemos oído que teníamos visita.\n¿Sois vosotros?"})
  else
  SkySceneKit.say({english="We heard we have visitors. Are\nyou maybe those visitors?", french="Il paraît qu'on a de la visite.\nC'est de vous qu'il s'agit?", german="Wir haben gehört, dass wir\nBesuch haben. Seid ihr der Besuch?", italian="Ci hanno detto che avremmo\ntrovato qualcuno che era venuto a farci\nvisita. Siete forse voi?", spanish="Hemos oído que teníamos visita.\n¿Sois vosotros?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="Yep![K] We wanted to ask\nTeam [team:] for help.", french="Ouaip![K] On a besoin que l'Equipe\n[team:] nous vienne en aide.", german="Jep![K] Wir wollten\nTeam [team:] um Hilfe bitten.", italian="Siamo noi![K] Siamo venuti a\nchiedere un favore a voi del Team\n[team:]!", spanish="¡Sí![K] Venimos a pedir vuestra\nayuda, [CS:X]Equipo[CR] [team:]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_mariru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Help?", french=" Qu'on vous aide?", german=" Um Hilfe?", italian=" Un favore?", spanish=" ¿Ayuda?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Help?", french=" Qu'on vous aide?", german=" Um Hilfe?", italian=" Un favore?", spanish=" ¿Ayuda?"})
  else
  SkySceneKit.say({english=" Help?", french=" Qu'on vous aide?", german=" Um Hilfe?", italian=" Un favore?", spanish=" ¿Ayuda?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Yep!", french=" Ouaip!", german=" Jep!", italian=" Proprio così!", spanish=" Sí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english="We need your help finding a\n[CS:Z]Water Float[CR].", french="On a besoin de vous pour\ntrouver un [CS:Z]Hydroflotteur[CR].", german="Ihr müsst uns helfen, unseren\n[CS:Z]Schwimmreif[CR] zu finden.", italian="Ci serve il vostro aiuto per\ntrovare un'[CS:Z]Acquaboa[CR].", spanish="Necesitamos que nos ayudéis\na encontrar nuestro [CS:Z]Flotarill[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_ruriri, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" A [CS:Z]Water Float[CR]?", french=" Un [CS:Z]Hydroflotteur[CR]?", german=" Euren [CS:Z]Schwimmreif[CR]?", italian=" Un'[CS:Z]Acquaboa[CR]?", spanish=" ¿Vuestro [CS:Z]Flotarill[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" A [CS:Z]Water Float[CR]?", french=" Un [CS:Z]Hydroflotteur[CR]?", german=" Euren [CS:Z]Schwimmreif[CR]?", italian=" Un'[CS:Z]Acquaboa[CR]?", spanish=" ¿Vuestro [CS:Z]Flotarill[CR]?"})
  else
  SkySceneKit.say({english=" A [CS:Z]Water Float[CR]?", french=" Un [CS:Z]Hydroflotteur[CR]?", german=" Euren [CS:Z]Schwimmreif[CR]?", italian=" Un'[CS:Z]Acquaboa[CR]?", spanish=" ¿Vuestro [CS:Z]Flotarill[CR]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You've been searching for your\n[CS:Z]Water Float[CR], right?", french="Vous n'étiez pas en train de\nchercher le vôtre, la dernière fois?", german="Ihr habt doch nach eurem\n[CS:Z]Schwimmreif[CR] gesucht, oder?", italian="Ah già! Voi eravate alla ricerca\ndella vostra [CS:Z]Acquaboa[CR], giusto?", spanish="¿El mismo [CS:Z]Flotarill[CR] que lleváis\nbuscando todo este tiempo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Weren't you looking for that\nearlier?[K] A [CS:Z]Water Float[CR]?", french="Vous n'étiez pas en train de\nchercher le vôtre, la dernière fois?", german="Habt ihr nicht schon früher\ndanach gesucht?[K] Nach diesem [CS:Z]Schwimmreif[CR]?", italian="Ma voi due non avevate\nritrovato la vostra [CS:Z]Acquaboa[CR]?", spanish="¿El mismo [CS:Z]Flotarill[CR] que lleváis\nbuscando todo este tiempo?[K] ¿Ese?"})
  else
  SkySceneKit.say({english="Isn't that what you were looking\nfor earlier?[K] A [CS:Z]Water Float[CR]?", french="Vous n'étiez pas en train de\nchercher le vôtre, la dernière fois?", german="Habt ihr nicht schon früher\ndanach gesucht?[K] Nach eurem [CS:Z]Schwimmreif[CR]?", italian="Ma voi due non avevate\nritrovato la vostra [CS:Z]Acquaboa[CR]?", spanish="¿El mismo [CS:Z]Flotarill[CR] que lleváis\nbuscando todo este tiempo?[K] ¿Ese?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_mariru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="Yep! Someone said one was lying\non the beach. We went there looking for it!", french="Ouaip! Quand on a entendu dire\nqu'il y en avait un sur la plage, on est allés\nvoir!", german="Ja! Jemand hat gesagt, dass er\nam Strand liegt. Wir haben dort nachgesehen!", italian="Qualcuno ci ha detto di averne\nvista una sulla spiaggia, così siamo andati a\nvedere!", spanish="Así es. Alguien nos dijo que\nestaba en la playa, ¡así que fuimos a buscarlo!"})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="We didn't find it. Instead, this is\nwhat we found.", french="Mais on ne l'a pas trouvé. Voilà\nce qu'on a découvert à la place.", german="Aber er war nicht da.\nStattdessen haben wir das hier gefunden.", italian="Non l'abbiamo trovata. Ecco\ncos'abbiamo trovato invece.", spanish="Pero no estaba allí. En su lugar,\nesto fue lo que encontramos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_mariru.Position; GROUND:MoveToPosition(npc_npc_mariru, p.X+(-8), p.Y+(-8), false, 1) end
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(5124) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(3) [neutre/état moteur]
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_mariru.Position; GROUND:MoveToPosition(npc_npc_mariru, p.X+(8), p.Y+(8), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" This scrap of paper?", french=" Ce bout de papier?", german=" Dieses Stück Papier?", italian=" Un pezzo di carta?", spanish=" ¿Este trozo de papel?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" This scrap of paper?", french=" Ce bout de papier?", german=" Dieses Stück Papier?", italian=" Un pezzo di carta?", spanish=" ¿Este trozo de papel?"})
  else
  SkySceneKit.say({english=" This scrap of paper?", french=" Ce bout de papier?", german=" Dieses Stück Papier?", italian=" Un pezzo di carta?", spanish=" ¿Este trozo de papel?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" There's writing on it.", french="Il y a quelque chose d'écrit\ndessus.", german=" Es steht etwas darauf.", italian=" C'è scritto qualcosa!", spanish=" Tiene algo escrito."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" There's writing on it.", french="Il y a quelque chose d'écrit\ndessus.", german=" Es steht etwas darauf.", italian=" C'è scritto qualcosa!", spanish=" Tiene algo escrito."})
  else
  SkySceneKit.say({english=" There's writing on it.", french="Il y a quelque chose d'écrit\ndessus.", german=" Es steht etwas darauf.", italian=" C'è scritto qualcosa!", spanish=" Tiene algo escrito."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetOutputAttribute(2) [neutre/état moteur]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(8), p.Y+(8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(5124) — id SE NDS sans portage PMDO identifié
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-8), p.Y+(-8), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][partner] read the message\n[CN]on the scrap of paper.", french="[CN][partner] lit le message\n[CN]écrit sur le bout de papier.", german="[CN][partner] liest die Nachricht\n[CN]auf dem Stück Papier.", italian="[CN][partner] legge il messaggio\n[CN]scritto sul pezzo di carta.", spanish="[CN][partner] leyó el mensaje\n[CN]del trozo de papel."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's see. What does it say?[K]\n\"The [CS:Z]Water Float[CR] from the beach...\"", french="Voyons voir. Qu'est-ce qui est\nécrit?[K] \"L'[CS:Z]Hydroflotteur[CR] de la plage...", german="Mal sehen. Was steht da?[K]\n[F:S2]Der [CS:Z]Schwimmreif[CR], der am Strand lag...[F:E2]", italian="Vediamo cosa dice...[K]\n\"L'[CS:Z]Acquaboa[CR] che era in spiaggia...\"", spanish="Veamos. ¿Qué dice?[K]\n\"El [CS:Z]Flotarill[CR] de la playa...\""})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's see. What does it say?[K]\n\"The [CS:Z]Water Float[CR] from the beach...\"", french="Voyons voir. Qu'est-ce qui est\nécrit?[K] \"L'[CS:Z]Hydroflotteur[CR] de la plage...", german="Mal sehen. Was steht da?[K]\n[F:S2]Der [CS:Z]Schwimmreif[CR], der am Strand lag...[F:E2]", italian="Vediamo cosa dice...[K]\n\"L'[CS:Z]Acquaboa[CR] che era in spiaggia...\"", spanish="Veamos. ¿Qué dice?[K]\n\"El [CS:Z]Flotarill[CR] de la playa...\""})
  else
  SkySceneKit.say({english="Let's see. What does it say?[K]\n\"The [CS:Z]Water Float[CR] from the beach...\"", french="Voyons voir. Qu'est-ce qui est\nécrit?[K] \"L'[CS:Z]Hydroflotteur[CR] de la plage...", german="Mal sehen. Was steht da?[K]\n[F:S2]Der [CS:Z]Schwimmreif[CR], der am Strand lag...[F:E2]", italian="Vediamo cosa dice...[K]\n\"L'[CS:Z]Acquaboa[CR] che era in spiaggia...\"", spanish="Veamos. ¿Qué dice?[K]\n\"El [CS:Z]Flotarill[CR] de la playa...\""})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" \\\"...is now in our possession.\\\"", french=" ... est en notre possession.", german=" [F:S2]Er gehört jetzt uns.[F:E2]", italian=" \\\"... si trova in mano nostra.\\\"", spanish=" \\\"Lo tenemos nosotros.\\\""})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" \\\"...is now in our possession.\\\"", french=" ... est en notre possession.", german=" [F:S2]Er gehört jetzt uns.[F:E2]", italian=" \\\"... si trova in mano nostra.\\\"", spanish=" \\\"Lo tenemos nosotros.\\\""})
  else
  SkySceneKit.say({english=" \\\"...is now in our possession.\\\"", french=" ... est en notre possession.", german=" [F:S2]Er gehört jetzt uns.[F:E2]", italian=" \\\"... si trova in mano nostra.\\\"", spanish=" \\\"Lo tenemos nosotros.\\\""})
  end
  -- message_KeyWait
  pcall(function() SOUND:PlayBGM("Growing Anxiety.ogg", true) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="\"Just try to take it from us!\nWe'll wait in the deepest part of [CS:P]Amp Plains[CR].\"", french="Essayez donc de nous\nle reprendre! On vous attendra au fin fond\ndes [CS:P]Plaines Elek[CR].", german="[F:S2]Versucht doch, ihn uns\nabzunehmen! Wir warten im tiefsten Teil\nder [CS:P]Ampere-Ebene[CR] auf euch.[F:E2]", italian="\"Venitevela a prendere!\nVi aspettiamo nella parte più profonda delle\n[CS:P]Pianure Saetta[CR].\"", spanish="\"¡Intentad arrebatárnoslo\nsi podéis! Os estaremos esperando en lo más\nprofundo de la [CS:P]Pradera Destello[CR].\""})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="\"Just try to take it from us!\nWe'll wait in the deepest part of [CS:P]Amp Plains[CR].\"", french="Essayez donc de nous\nle reprendre! On vous attendra au fin fond\ndes [CS:P]Plaines Elek[CR].", german="[F:S2]Versucht doch, ihn uns\nabzunehmen! Wir warten im tiefsten Teil\nder [CS:P]Ampere-Ebene[CR] auf euch.[F:E2]", italian="\"Venitevela a prendere!\nVi aspettiamo nella parte più profonda delle\n[CS:P]Pianure Saetta[CR].\"", spanish="\"¡Intentad arrebatárnoslo\nsi podéis! Os estaremos esperando en lo más\nprofundo de la [CS:P]Pradera Destello[CR].\""})
  else
  SkySceneKit.say({english="\"Just try to take it from us!\nWe'll wait in the deepest part of [CS:P]Amp Plains[CR].\"", french="Essayez donc de nous\nle reprendre! On vous attendra au fin fond\ndes [CS:P]Plaines Elek[CR].", german="[F:S2]Versucht doch, ihn uns\nabzunehmen! Wir warten im tiefsten Teil\nder [CS:P]Ampere-Ebene[CR] auf euch.[F:E2]", italian="\"Venitevela a prendere!\nVi aspettiamo nella parte più profonda delle\n[CS:P]Pianure Saetta[CR].\"", spanish="\"¡Intentad arrebatárnoslo\nsi podéis! Os estaremos esperando en lo más\nprofundo de la [CS:P]Pradera Destello[CR].\""})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="\"But knowing how weak and puny\nyou are...\"", french="Mais on vous connaît, bande de\nmauviettes...", german="[F:S2]Aber ihr seid so schwächlich\nund schreckhaft...[F:E2]", italian="\"Ma siamo sicuri che delle\nschiappe come voi...\"", spanish="\"Pero sabiendo lo débiles\ny enclenques que sois...\""})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="\"But knowing how weak and puny\nyou are...\"", french="Mais on vous connaît, bande de\nmauviettes...", german="[F:S2]Aber ihr seid so schwächlich\nund schreckhaft...[F:E2]", italian="\"Ma siamo sicuri che delle\nschiappe come voi...\"", spanish="\"Pero sabiendo lo débiles\ny enclenques que sois...\""})
  else
  SkySceneKit.say({english="\"But knowing how weak and puny\nyou are...\"", french="Mais on vous connaît, bande de\nmauviettes...", german="[F:S2]Aber ihr seid so schwächlich\nund schreckhaft...[F:E2]", italian="\"Ma siamo sicuri che delle\nschiappe come voi...\"", spanish="\"Pero sabiendo lo débiles\ny enclenques que sois...\""})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="\"...I bet you can't even reach us!\nChaw-haw-haw!\"", french="... je parie que vous n'arriverez\nmême pas jusqu'à nous! Gnark gnark gnark!", german="[F:S2]Ihr könnt uns wahrscheinlich\nnicht einmal finden! Cha-ha-ha![F:E2]", italian="\"... non riusciranno mai ad\narrivare fino a noi! Ahr-ahr-ahr!\"", spanish="\"¡Seguro que ni siquiera\npodéis llegar hasta allí! ¡Jua, jua, jua!\""})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="\"...I bet you can't even reach us!\nChaw-haw-haw!\"", french="... je parie que vous n'arriverez\nmême pas jusqu'à nous! Gnark gnark gnark!", german="[F:S2]Ihr könnt uns wahrscheinlich\nnicht einmal finden! Cha-ha-ha![F:E2]", italian="\"... non riusciranno mai ad\narrivare fino a noi! Ahr-ahr-ahr!\"", spanish="\"¡Seguro que ni siquiera\npodéis llegar hasta allí! ¡Jua, jua, jua!\""})
  else
  SkySceneKit.say({english="\"...I bet you can't even reach us!\nChaw-haw-haw!\"", french="... je parie que vous n'arriverez\nmême pas jusqu'à nous! Gnark gnark gnark!", german="[F:S2]Ihr könnt uns wahrscheinlich\nnicht einmal finden! Cha-ha-ha![F:E2]", italian="\"... non riusciranno mai ad\narrivare fino a noi! Ahr-ahr-ahr!\"", spanish="\"¡Seguro que ni siquiera\npodéis llegar hasta allí! ¡Jua, jua, jua!\""})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="\"Can't handle it? Go cry to your\nbig-shot friends! Chaw-haw-haw!\"[K]\nHey! This note! It's a...", french="Vous êtes pas de taille! Allez\ndonc pleurnicher auprès de vos amis,\nles gros balèzes!\"[K] Eh, ce message! C'est...", german="[F:S2]Zu viel für euch? Dann rennt\ndoch zu euren großen Freunden und fleht sie\num Hilfe an![F:E2][K] Hey! Diese Nachricht ist...", italian="\"Pensate di non farcela? Andate\npure a piagnucolare dai vostri amichetti!\nAhr-ahr-ahr!\"[K] Ehi, ma questo...", spanish="\"¡Si no os atrevéis, id a llorarle\na ese equipo que siempre os saca las castañas\ndel fuego! ¡Jua, jua, jua!\"[K] ¡Eh!..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="\"Can't handle it? Go cry to your\nbig-shot friends! Chaw-haw-haw!\"[K]\nHey! This note! It's a...", french="Vous êtes pas de taille! Allez\ndonc pleurnicher auprès de vos amis,\nles gros balèzes!\"[K] Eh, ce message! C'est...", german="[F:S2]Zu viel für euch? Dann rennt\ndoch zu euren großen Freunden und fleht sie\num Hilfe an![F:E2][K] Hey! Diese Nachricht ist...", italian="\"Pensate di non farcela? Andate\npure a piagnucolare dai vostri amichetti!\nAhr-ahr-ahr!\"[K] Ehi, ma questo...", spanish="\"¡Si no os atrevéis, id a llorarle\na ese equipo que siempre os saca las castañas\ndel fuego! ¡Jua, jua, jua!\"[K] ¡Eh!..."})
  else
  SkySceneKit.say({english="\"Can't handle it? Go cry to your\nbig-shot friends! Chaw-haw-haw!\"[K]\nHey! This note! It's a...", french="Vous êtes pas de taille! Allez\ndonc pleurnicher auprès de vos amis,\nles gros balèzes!\"[K] Eh, ce message! C'est...", german="[F:S2]Zu viel für euch? Dann rennt\ndoch zu euren großen Freunden und fleht sie\num Hilfe an![F:E2][K] Hey! Diese Nachricht ist...", italian="\"Pensate di non farcela? Andate\npure a piagnucolare dai vostri amichetti!\nAhr-ahr-ahr!\"[K] Ehi, ma questo...", spanish="\"¡Si no os atrevéis, id a llorarle\na ese equipo que siempre os saca las castañas\ndel fuego! ¡Jua, jua, jua!\"[K] ¡Eh!..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's a ransom note! Isn't it?!", french=" C'est du chantage! Pas vrai?!", german="Es ist ein Erpresserbrief!\nOder etwa nicht?", italian=" ... è un ricatto bello e buono!", spanish="¡Parece una nota de chantaje,\n¿no?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's a ransom note! Isn't it?!", french=" C'est du chantage! Pas vrai?!", german="Es ist ein Erpresserbrief!\nOder etwa nicht?", italian=" ... è un ricatto bello e buono!", spanish="¡Parece una nota de chantaje,\n¿no?!"})
  else
  SkySceneKit.say({english=" It's a ransom note! Isn't it?!", french=" C'est du chantage! Pas vrai?!", german="Es ist ein Erpresserbrief!\nOder etwa nicht?", italian=" ... è un ricatto bello e buono!", spanish="¡Parece una nota de chantaje,\n¿no?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_mariru, 4) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You little guys shouldn't even\nthink about going!", french="N'envisagez même pas d'y aller,\nles petits gars!", german="Denkt nicht einmal daran,\nhinzugehen, ihr Kleinen!", italian="Voi piccoletti non dovete\nnemmeno pensare di andarci!", spanish=" ¡A vosotros ni se os ocurra ir!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You little guys! Promise me you\nwon't go yourself.", french="N'envisagez même pas d'y aller,\nles petits gars!", german="Ihr Kleinen, versprecht mir,\ndass ihr nicht selbst geht.", italian="Piccoli! Promettetemi che non\nci andrete!", spanish="¡A vosotros ni se os ocurra ir!\n¡Prometedme que no lo haréis!"})
  else
  SkySceneKit.say({english="You little guys! Please don't even\nthink about going.", french="N'envisagez même pas d'y aller,\nles petits gars!", german="Denkt nicht einmal daran,\ndahinzugehen, ihr Kleinen!", italian="Piccoli! Promettetemi che non\nci andrete!", spanish=" ¡A vosotros ni se os ocurra ir!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It could be a trap.", french=" C'est sûrement un piège.", german=" Es könnte eine Falle sein.", italian=" Sono sicuro che è una trappola!", spanish=" Podría ser una trampa."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I suspect a trap.", french=" C'est sûrement un piège.", german=" Ich vermute eine Falle.", italian=" Potrebbe essere una trappola.", spanish="Sospecho que se trata de\nuna trampa."})
  else
  SkySceneKit.say({english=" It's probably a trap!", french=" C'est sûrement un piège.", german=" Wahrscheinlich ist es eine Falle!", italian=" Potrebbe essere una trappola.", spanish=" Debe de ser una trampa."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="But the [CS:Z]Water Float[CR] is very\nimportant to us.", french="Mais l'[CS:Z]Hydroflotteur[CR] est très\nimportant pour nous.", german="Aber der [CS:Z]Schwimmreif[CR] bedeutet\nuns sehr viel.", italian="Ma l'[CS:Z]Acquaboa[CR] è troppo\nimportante per noi!", spanish="Pero el [CS:Z]Flotarill[CR]\nes muy importante para nosotros."})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" We really want to get it back.", french=" On veut vraiment le récupérer.", german="Wir wollen ihn unbedingt\nwiederhaben.", italian="La rivogliamo, costi quel che\ncosti.", spanish="Necesitamos recuperarlo\ncomo sea."})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="But I can't take [CS:N]Azurill[CR] to a\ndangerous place.", french="Mais je ne peux pas faire courir\nde risques à [CS:N]Azurill[CR].", german="Aber ich kann [CS:N]Azurill[CR] nicht an\neinen so gefährlichen Ort mitnehmen.", italian="Ma non posso portare [CS:N]Azurill[CR] in\nun posto così pericoloso.", spanish="Pero no puedo llevar a [CS:N]Azurill[CR]\na un lugar tan peligroso."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_PlayFadeIn(BGM_OCEAN3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" I said I would go too!", french="Je t'ai dit que je viendrai avec\ntoi!", german=" Ich habe gesagt, ich gehe mit!", italian="Ho detto che sarei venuto\nanch'io!", spanish=" ¡Si tú vas, yo también!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, npc_npc_ruriri, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_ruriri, npc_npc_mariru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="It's too much for you. I don't\nwant you getting into any scary scrapes.", french="C'est trop dangereux.\nJe ne veux pas qu'il t'arrive quoi que ce soit.", german="Es ist zu viel für dich. Ich will\nnicht, dass du in Gefahr gerätst.", italian="No! È troppo pericoloso e non\nvoglio che ti ficchi in qualche pasticcio!", spanish="Esto es muy arriesgado.\nNo quiero que corras peligro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_ruriri, partner, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" I went to [CS:P]Amp Plains[CR] by myself.", french="Je suis allé dans les [CS:P]Plaines Elek[CR]\ntout seul.", german="Ich ging alleine zur\n[CS:P]Ampere-Ebene[CR].", italian="Sono andato a dare un'occhiata\nalle [CS:P]Pianure Saetta[CR]...", spanish="Ya he intentado ir a la\n[CS:P]Pradera Destello[CR] yo solo."})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="But many Electric-type Pokémon\nlive there!", french="Mais c'est bourré de Pokémon\nde type Electrik!", german="Aber dort leben viele\nElektro-Pokémon!", italian="Ci sono molti Pokémon di tipo\nElettro laggiù!", spanish="Pero allí viven muchos\nPokémon de tipo Eléctrico."})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" I'm no match for them.", french="Je ne suis pas de taille à\nles vaincre.", german="Mit denen kann ich es nicht\naufnehmen.", italian="Non posso far niente contro di\nloro.", spanish=" Son demasiado para mí."})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="I tried going many times. But I\nget knocked out right away...", french="J'ai tenté ma chance plusieurs\nfois. Mais à chaque fois, je me fais mettre\nK.O. d'entrée...", german="Ich habe es oft versucht. Aber\nsie haben mich jedes Mal sofort besiegt...", italian="Ci ho provato molte volte...\nma senza successo...", spanish="Lo he intentado varias veces.\nPero no consigo ni pasar de la entrada..."})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="I just c-c-can't stand how weak\nI am...", french="Je suis trop faible,\nça me dégoûte...", german="Ich h-h-hasse es einfach,\ndass ich so schwach bin...", italian="Non riesco a sopportare il\npensiero di essere così debole...", spanish="No... No soporto lo débil\nque soy..."})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_mariru, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" No problem! I know what to do!", french="Pas de problème! Je sais quoi\nfaire!", german="Kein Problem! Ich weiß, was\nwir machen!", italian="Non preoccuparti, piccolo. Ho un\npiano!", spanish="No os preocupéis.\nSé lo que podemos hacer."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" No problem! I know what to do!", french="Pas de problème! Je sais quoi\nfaire!", german="Kein Problem! Ich weiß, was\nwir machen!", italian="Non preoccuparti, piccolo. Ho un\npiano!", spanish="No os preocupéis.\nSé lo que podemos hacer."})
  else
  SkySceneKit.say({english=" No problem! I know what to do!", french="Pas de problème! Je sais quoi\nfaire!", german="Kein Problem! Ich weiß, was\nwir machen!", italian="Non preoccuparti, piccolo. Ho un\npiano!", spanish="No os preocupéis.\nSé lo que podemos hacer."})
  end
  -- message_KeyWait
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We'll go and get the [CS:Z]Water Float[CR]\nback for you.", french="On va aller récupérer\nl'[CS:Z]Hydroflotteur[CR] pour toi.", german="Wir werden den [CS:Z]Schwimmreif[CR]\nfür euch holen.", italian="Andremo noi a recuperare\nl'[CS:Z]Acquaboa[CR].", spanish="Iremos a buscar vuestro\n[CS:Z]Flotarill[CR] por vosotros."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We'll go get the [CS:Z]Water Float[CR]\nback for you.", french="On va aller récupérer\nl'[CS:Z]Hydroflotteur[CR] pour toi.", german="Wir werden den [CS:Z]Schwimmreif[CR]\nfür euch holen.", italian="Andremo noi a recuperare\nl'[CS:Z]Acquaboa[CR].", spanish="Iremos a buscar vuestro\n[CS:Z]Flotarill[CR] por vosotros."})
  else
  SkySceneKit.say({english="We'll go get the [CS:Z]Water Float[CR]\nback for you.", french="On va aller récupérer\nl'[CS:Z]Hydroflotteur[CR] pour toi.", german="Wir werden den [CS:Z]Schwimmreif[CR]\nfür euch holen.", italian="Andremo noi a recuperare\nl'[CS:Z]Acquaboa[CR].", spanish="Iremos a buscar vuestro\n[CS:Z]Flotarill[CR] por vosotros."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Really?!", french=" Vraiment?!", german=" Wirklich?!?", italian=" Veramente?", spanish=" ¡¿De verdad?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" You will?!", french=" Vous feriez ça?!", german=" Das würdet ihr tun?!?", italian=" Lo fareste?", spanish=" ¡¿Lo haréis por nosotros?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup![K] So no more crying!", french=" Oui![K] Alors sèche tes larmes!", german="Na klar![K] Also, keine Tränen\nmehr!", italian="Ma certo![K] Quindi, basta\npiangere!", spanish=" Sí.[K] Así que no os preocupéis."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yep![K] So no more tears!", french=" Oui![K] Alors sèche tes larmes!", german="Na klar![K] Also, keine Tränen\nmehr!", italian="Ci pensiamo noi![K] Ora basta\npiangere!", spanish=" Sí.[K] Así que no os preocupéis."})
  else
  SkySceneKit.say({english=" Yep![K] So no more tears!", french=" Oui![K] Alors sèche tes larmes!", german="Na klar![K] Also, keine Tränen\nmehr!", italian="Ci pensiamo noi![K] Ora basta\npiangere!", spanish=" Sí.[K] Así que no os preocupéis."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="OK![K] W-we're sorry to bother\nyou about this. Thank you!", french="D'accord![K] On est désolés de\nvous embêter avec ça. Merci!", german="Okay![K] T-tut uns leid,\ndass wir euch damit belästigen. Danke!", italian="Grazie![K] Ci dispiace così tanto\nesservi di disturbo... Grazie di cuore!", spanish="¡De acuerdo![K] Sentimos...\nsentimos mucho las molestias.\n¡Muchas gracias!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You should see your faces!\nAll that crying and laughing... C'mon!", french="Si vous voyiez vos têtes!\nToutes ces larmes et ces rires... Allez!", german="Ihr solltet mal eure Gesichter\nsehen! So viel Weinen und Lachen...\nNa kommt schon!", italian="Dovreste vedere la\nvostra faccia! Quante lacrime...\nForza, tiratevi su!", spanish="Tendríais que veros...\nVenga, ¡arriba ese ánimo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You should see your faces!\nAll that crying and laughing... C'mon!", french="Si vous voyiez vos têtes!\nToutes ces larmes et ces rires... Allez!", german="Ihr solltet mal eure Gesichter\nsehen! So viel Weinen und Lachen...\nNa kommt schon!", italian="Dovreste vedere la\nvostra faccia! Quante lacrime...\nForza, tiratevi su!", spanish="Tendríais que veros...\nVenga, ¡arriba ese ánimo!"})
  else
  SkySceneKit.say({english="You should see your faces!\nAll that crying and laughing... C'mon!", french="Si vous voyiez vos têtes!\nToutes ces larmes et ces rires... Allez!", german="Ihr solltet mal eure Gesichter\nsehen! So viel Weinen und Lachen...\nNa kommt schon!", italian="Dovreste vedere la\nvostra faccia! Quante lacrime...\nForza, tiratevi su!", spanish="Tendríais que veros...\nVenga, ¡arriba ese ánimo!"})
  end
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Don't worry, though.[K] We'll get it\nback for you. Sure thing!", french="Mais ne vous en faites pas.[K]\nOn va le récupérer pour vous, c'est promis!", german="Aber keine Sorge.[K] Wir holen ihn\nzurück. Ganz bestimmt!", italian="Non preoccupatevi più.[K]\nPenseremo noi a riportarvi lo strumento!", spanish="No os preocupéis.[K]\nLo recuperaremos, lo prometo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Don't worry, though.[K] We'll get it\nback for you. It's a promise!", french="Mais ne vous en faites pas.[K]\nOn va le récupérer pour vous, c'est promis!", german="Aber keine Sorge.[K] Wir holen ihn\nzurück. Das ist ein Versprechen!", italian="Non preoccupatevi più.[K]\nPenseremo noi a riportarvi lo strumento!", spanish="No os preocupéis.[K]\nLo recuperaremos, lo prometo."})
  else
  SkySceneKit.say({english="Don't worry, though.[K] We'll get it\nback for you. We promise!", french="Mais ne vous en faites pas.[K]\nOn va le récupérer pour vous, c'est promis!", german="Aber keine Sorge.[K] Wir holen ihn\nzurück. Versprochen!", italian="Non preoccupatevi più.[K]\nPenseremo noi a riportarvi lo strumento!", spanish="No os preocupéis.[K]\nLo recuperaremos, lo prometo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's go, [hero]! Onward\nto [CS:P]Amp Plains[CR]!", french="On y va, [hero]! En route\npour les [CS:P]Plaines Elek[CR]!", german="Gehen wir, [hero]!\nAuf zur [CS:P]Ampere-Ebene[CR]!", italian="Andiamo, [hero]! Si va\nalle [CS:P]Pianure Saetta[CR]!", spanish="¡Vamos, [hero]!\n¡A la [CS:P]Pradera Destello[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go, [hero]! We're\noff to [CS:P]Amp Plains[CR]!", french="On y va, [hero]! En route\npour les [CS:P]Plaines Elek[CR]!", german="Gehen wir, [hero]!\nAuf zur [CS:P]Ampere-Ebene[CR]!", italian="Andiamo, [hero]! Si va\nalle [CS:P]Pianure Saetta[CR]!", spanish="¡Vamos, [hero]!\n¡A la [CS:P]Pradera Destello[CR]!"})
  else
  SkySceneKit.say({english="Let's go, [hero]! Let's get\nto [CS:P]Amp Plains[CR]!", french="On y va, [hero]! En route\npour les [CS:P]Plaines Elek[CR]!", german="Gehen wir, [hero]!\nAuf zur [CS:P]Ampere-Ebene[CR]!", italian="Andiamo, [hero]! Si va\nalle [CS:P]Pianure Saetta[CR]!", spanish="¡Vamos, [hero]!\n¡A la [CS:P]Pradera Destello[CR]!"})
  end
  -- message_Close
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_mariru, Direction.Left)
  GROUND:MoveToPosition(npc_npc_ruriri, 256, 224, false, 2)
  GROUND:EntTurn(npc_npc_ruriri, Direction.Left)
  GAME:WaitFrames(15)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[17] = 1 -- dungeon_mode(17) = DMODE_OPEN (ROM)
  SkySceneKit.cleanup_npcs()
end
