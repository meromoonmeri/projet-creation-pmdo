-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07A/m02a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The next morning...", french="[CN]Le lendemain matin...", german="[CN]Am nächsten Morgen...", italian="[CN]La mattina dopo...", spanish="[CN]A la mañana siguiente..."})
  -- message_Close
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" HEY![K] HEY THERE!", french=" HEP![K] HOP HOP HOP, VOUS DEUX!", german=" HEY![K] HEY, IHR!", italian=" EHI![K] EHI VOI!", spanish=" ¡VENGA![K] ¡ARRIBA!"})
  -- message_KeyWait
  -- GAP: se_Play(8970) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" RISE AND SHINE!", french=" DEBOUT LA-DEDANS!", german=" RAUS AUS DEN FEDERN!", italian=" È ORA DI ALZARSI!", spanish=" ¡HORA DE LEVANTARSE!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Ugh!)", french="(Argh!)", german="(Umpf!)", italian="(Ugh!)", spanish="(¡Ah!)"})
  else
  SkySceneKit.say({english="(Ugh!)", french="(Argh!)", german="(Umpf!)", italian="(Ugh!)", spanish="(¡Uf!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(M-my head is pounding!)", french="(Ah... ma... ma tête! Ça fait mal!)", german="(M-mir brummt der Schädel!)", italian="(Mi rimbomba la testa!)", spanish="(¡Tengo la cabeza como un bombo!)"})
  else
  SkySceneKit.say({english="(M-my head is pounding!)", french="(Ah... ma... ma tête! Ça fait mal!)", german="(M-mir brummt der Schädel!)", italian="(Mi rimbomba la testa!)", spanish="(¡Qué susto!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Wh-what a ridiculously loud voice! It almost\nblasted my eardrums!)", french="(Quelle voix ridiculement forte! Pourquoi\nil crie comme ça? J'ai l'impression qu'il\nm'a perforé les tympans!)", german="(W-was für eine lächerlich laute Stimme!\nMir ist fast das Trommelfell geplatzt!)", italian="(Mai sentita una voce così! Mi ha quasi\nspaccato i timpani!)", spanish="(¡Menudo vozarrón! ¡Casi me rompe\nlos tímpanos!)"})
  else
  SkySceneKit.say({english="(Wh-what a ridiculously loud voice! It almost\nblasted my eardrums!)", french="(Quelle voix ridiculement forte! Pourquoi\nil crie comme ça? J'ai l'impression qu'il\nm'a perforé les tympans!)", german="(W-was für eine lächerlich laute Stimme!\nMir ist fast das Trommelfell geplatzt!)", italian="(Mai sentita una voce così! Mi ha quasi\nspaccato i timpani!)", spanish="(¡Vaya vozarrón! ¡Casi me rompe\nlos tímpanos!)"})
  end
  -- message_Close
  -- back_SetGround(LEVEL_G01P07A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(68) [anim idle native]
  -- SetAnimation(68) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 112, 184, Direction.Right, "NPC_DOGOOMU")
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Why are you still ASLEEP?![K] WAKE UP!", french=" Vous dormez ENCORE?![K] DEBOUT!", german="Wieso seid ihr noch IM BETT?!?[K]\nWACHT AUF!", italian=" Cosa ci fate ancora A LETTO?![K] SVEGLIA!", spanish="¿CÓMO PODÉIS ESTAR DURMIENDO?[K]\n¡VAMOS, ARRIBA!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Ugh!)", french="(Argh!)", german="(Umpf!)", italian="(Ugh!)", spanish="(¡Uf!)"})
  else
  SkySceneKit.say({english="(Ugh!)", french="(Argh!)", german="(Umpf!)", italian="(Ugh!)", spanish="(¡Ah!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" M-my ears...", french=" M-mes oreilles...", german=" M-meine Ohren...", italian=" L-Le mie orecchie...", spanish=" Mis oídos..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" M-my poor ears...", french=" M-mes oreilles...", german=" M-meine armen Ohren...", italian=" L-Le mie povere orecchie...", spanish=" Mis pobres oídos..."})
  else
  SkySceneKit.say({english=" M-my poor ears...", french=" M-mes oreilles...", german=" M-meine armen Ohren...", italian=" L-Le mie povere orecchie...", spanish=" Mis pobres oídos..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" C'mon! Snap OUT of it!", french=" Allez! SECOUEZ-vous! HOP HOP HOP!", german=" Na los! RAUS aus der Falle!", italian=" Forza! IN PIEDI!", spanish=" ¡DESPERTAD DE UNA VEZ!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" I'm [CS:N]Loudred[CR]![K] And I'm a fellow apprentice!", french="Moi c'est [CS:N]Ramboum[CR]![K] Et je suis\napprenti comme vous!", german=" Ich bin [CS:N]Krakeelo[CR]![K] Ich bin auch ein Lehrling!", italian="Mi chiamo [CS:N]Loudred[CR]![K] E sono\nanch'io un apprendista!", spanish=" ¡Soy [CS:N]Loudred[CR]![K] ¡Yo también soy aprendiz!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="If you're late for our morning\nbriefing, you'll be SORRY! So MOVE it!", french="Si vous êtes en retard pour\nla réunion du matin, ça va BARDER pour\nvous! Alors on se GROUILLE!", german="Wenn ihr zu spät zur\nmorgendlichen Einweisung kommt, werdet ihr\nes BEREUEN! Also LOS!", italian="Se arrivate in ritardo per la\nriunione mattutina, saranno GUAI! Quindi\nDATEVI UNA MOSSA!!", spanish="Si llegáis tarde a la reunión de\nesta mañana... ¡LO VAIS A LAMENTAR!\nVENGA... ¡LEVANTAOS!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Guildmaster [CS:N]Wigglytuff[CR] has got\na BIG temper. If you make him lose it...", french="Le Maître de la Guilde,\n[CS:N]Grodoudou[CR], est très SOUPE AU LAIT!\nSi vous le mettez en colère...", german="Unser Gildenmeister [CS:N]Knuddeluff[CR]\nist SEHR temperamentvoll. Wenn ihr ihn\nreizt...", italian="Il Capitano [CS:N]Wigglytuff[CR] ha un\nCARATTERACCIO. Se perde le staffe...", spanish="El Gran Bluff tiene mucho carácter.\nComo pierda la paciencia..."})
  -- message_Close
  SkySceneKit.spin(npc_npc_dogoomu, 4, 10, 5)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="YOWEEE! That would be one very\nscary scene!", french="OUILLE! Vous auriez de gros\nproblèmes, c'est moi qui vous le dis!", german="OH MANN! Das wäre vielleicht\neine gruselige Szene!", italian="IIIIIIHHHH! Quella sì che\nsarebbe una scena spaventosa!", spanish=" ¡No me gustaría estar presente!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  -- SetAnimation(9) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="I've got goose bumps just\nthinking about it! YEESH!", french="Rien que d'y penser, j'en ai\nla chair de poule! OUAIS!", german="Schon bei der Vorstellung kriege\nich Gänsehaut! AU BACKE!", italian="Mi viene la pelle d'oca solo a\npensarci!", spanish="¡Me dan escalofríos de pensarlo!\n¡YA LO CREO!"})
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  SkySceneKit.spin(npc_npc_dogoomu, 1, 10, 5)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" So ANYWAY...", french=" Enfin BREF!", german=" Aber WIE AUCH IMMER...", italian=" Beh, IN OGNI CASO...", spanish=" Así que..."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="I'm not about to get in trouble\nbecause you rookies got up LATE!", french="Je vais pas m'attirer des ennuis\ntout ça parce que vous, les novices, vous\nêtes en RETARD!", german="Ich werde mir keinen Ärger\neinhandeln, weil ihr Neulinge zu SPÄT kommt!", italian="Non ho alcuna intenzione di\nfinire nei guai perché voi due avete\ndormito TROPPO!", spanish="¡No pienso meterme en un lío\nsi llegáis tarde!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" SO GET IT IN GEAR!", french=" ALORS REMUEZ-VOUS!", german=" ALSO KOMMT IN DIE GÄNGE!", italian=" QUINDI DATEVI UNA MOSSA!", spanish=" ¡PREPARAOS!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(-96), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk! My ears are still ringing...", french="Argh! Mes oreilles\nen bourdonnent encore...", german="Urgs! Meine Ohren klingeln\nimmer noch...", italian="Ugh... Le orecchie mi fanno\nancora male.", spanish="Uf... Todavía me zumban\nlos oídos..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk! My ears are still ringing...", french="Argh! Mes oreilles\nen bourdonnent encore...", german="Urgs! Meine Ohren klingeln\nimmer noch...", italian="Ugh... Le orecchie mi fanno\nancora male.", spanish="Uf... Todavía me zumban\nlos oídos..."})
  else
  SkySceneKit.say({english=" Urk! My ears are still ringing...", french="Argh! Mes oreilles\nen bourdonnent encore...", german="Urgs! Meine Ohren klingeln\nimmer noch...", italian="Ugh... Le orecchie mi fanno\nancora male.", spanish="Uf... Todavía me zumban\nlos oídos..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What did he say? Something\nabout getting ready?", french="Qu'est-ce qu'il a dit?\n\"Préparez-vous\", ou quelque chose comme ça?", german="Von was hat er geredet?\nIrgendwas von Aufstehen?", italian="Cos'ha detto? Dobbiamo\nprepararci?", spanish="¿Tú te has enterado?\n¿Ha dicho algo de prepararse?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What did he say? Something\nabout getting ready?", french="Qu'est-ce qu'il a dit?\n\"Préparez-vous\", ou quelque chose comme ça?", german="Von was hat er geredet?\nIrgendwas von Aufstehen?", italian="Cos'ha detto? Dobbiamo\nprepararci?", spanish="¿Tú te has enterado?\n¿Nos ha dicho que nos preparemos?"})
  else
  SkySceneKit.say({english="What did he say? Something\nabout getting ready?", french="Qu'est-ce qu'il a dit?\n\"Préparez-vous\", ou quelque chose comme ça?", german="Von was hat er geredet?\nIrgendwas von Aufstehen?", italian="Cos'ha detto? Dobbiamo\nprepararci?", spanish="¿Tú le has entendido?\n¿Ha dicho algo sobre prepararse?"})
  end
  -- message_Close
  GAME:WaitFrames(20)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Er...[K] Oh yeah!", french=" Euh...[K] Ah oui!", german=" Ähem...[K] Oh ja!", italian=" Ehm...[K] Oh, già!", spanish=" Esto...[K] ¡Ah, sí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Er...[K] Oh yeah!", french=" Euh...[K] Ah oui!", german=" Ähem...[K] Oh ja!", italian=" Ehm...[K] Oh, già!", spanish=" Esto...[K] ¡Ah, sí!"})
  else
  SkySceneKit.say({english=" Er...[K] Oh yeah!", french=" Euh...[K] Ah oui!", german=" Ähem...[K] Oh ja!", italian=" Ehm...[K] Oh, già!", spanish=" Esto...[K] ¡Ah, sí!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We signed up as apprentices at\n[CS:N]Wigglytuff[CR]'s guild, that's right!", french="C'est vrai, ils ont accepté notre\ninscription parmi les apprentis de la Guilde\nde [CS:N]Grodoudou[CR]!", german="Wir haben uns ja bei der\n[CS:N]Knuddeluff-Gilde[CR] als Lehrlinge eingeschrieben!", italian="È vero, siamo apprendisti alla\nGilda di [CS:N]Wigglytuff[CR]!", spanish="¡Claro, ayer nos apuntamos como\naprendices en el [CS:N]Pokégremio de Exploradores[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We signed up as apprentices at\n[CS:N]Wigglytuff[CR]'s guild, that's right!", french="C'est vrai, ils ont accepté notre\ninscription parmi les apprentis de la Guilde\nde [CS:N]Grodoudou[CR]!", german="Wir haben uns ja bei der\n[CS:N]Knuddeluff-Gilde[CR] als Lehrlinge eingeschrieben!", italian="È vero, siamo apprendisti alla\nGilda di [CS:N]Wigglytuff[CR]!", spanish="¡Claro, ayer nos apuntamos como\naprendices en el [CS:N]Pokégremio de Exploradores[CR]!"})
  else
  SkySceneKit.say({english="We signed up as apprentices at\n[CS:N]Wigglytuff[CR]'s guild, that's right!", french="C'est vrai, ils ont accepté notre\ninscription parmi les apprentis de la Guilde\nde [CS:N]Grodoudou[CR]!", german="Wir haben uns ja bei der\n[CS:N]Knuddeluff-Gilde[CR] als Lehrlinge eingeschrieben!", italian="È vero, siamo Pokémon\napprendisti alla Gilda di [CS:N]Wigglytuff[CR]!", spanish="¡Claro, ayer nos apuntamos como\naprendices en el [CS:N]Pokégremio de Exploradores[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But that means...", french=" Mais alors, dans ce cas...", german=" Aber das heißt ja...", italian=" Questo vuol dire...", spanish=" Pero entonces..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But that means...", french=" Mais alors, dans ce cas...", german=" Aber das heißt ja...", italian=" Questo vuol dire...", spanish=" Pero eso significa que..."})
  else
  SkySceneKit.say({english=" But that means...", french=" Mais alors, dans ce cas...", german=" Aber das heißt ja...", italian=" Questo vuol dire...", spanish=" Pero eso quiere decir que..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Oh no! We totally overslept!\nHurry up, [hero]!", french="Oh non! On a dormi trop\nlongtemps! Dépêche-toi, [hero]!", german="Oh nein! Wir haben total\nverschlafen, [hero]! Beeile dich!", italian="Oh, no! Abbiamo dormito troppo!\nSbrighiamoci, [hero]!", spanish="¡Oh, no! ¡Nos hemos quedado\ndormidos! ¡Rápido, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Waaaah! We totally overslept!\nWe've got to hurry, [hero]!", french="Oh non! On a dormi trop\nlongtemps! Dépêche-toi, [hero]!", german="Waaaah! Wir haben verschlafen!\nWir müssen uns beeilen, [hero]!", italian="Oh, no! Abbiamo dormito troppo!\nSbrighiamoci, [hero]!", spanish="¡Oh, no! ¡Nos hemos quedado\ndormidos! ¡Hay que apresurarse, [hero]!"})
  else
  SkySceneKit.say({english="Waaaah! We overslept!\nCome on, [hero]!", french="Oh non! On a dormi trop\nlongtemps! Dépêche-toi, [hero]!", german="Waaaah! Wir haben verschlafen!\nKomm schon, [hero]!", italian="Oh, no! Abbiamo dormito troppo!\nSbrighiamoci, [hero]!", spanish="¡Oh, no! ¡Hemos dormido más de\nla cuenta! ¡Vamos, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-180), p.Y+(0), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-160), p.Y+(0), false, 2) end
  GAME:WaitFrames(45)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
