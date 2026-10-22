-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11B/s03p2003.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V01P03B) [décor sub chargé: Sub_v01p03b]
  -- back_SetGround(LEVEL_D01P11B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 33, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  SkySubScreen.Show("v01p03b", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 512, 176, Direction.DownLeft, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The Guildmaster and I decided to\ninvite [CS:N]Walrein[CR] from the Northern Sea.", french="Le Maître de la Guilde et\nmoi-même avons décidé de convier\n[CS:N]Kaimorse[CR] de la Mer du Nord.", german="Der Gildenmeister und ich haben\nentschieden, [CS:N]Walraisa[CR] aus dem Nordmeer\neinzuladen.", italian="Il Capitano e io abbiamo deciso\ndi invitare [CS:N]Walrein[CR] dal Mare Settentrionale.", spanish="El Gran Bluff y yo hemos\ninvitado a [CS:N]Walrein[CR], del Mar del Norte."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We felt that [CS:N]Walrein[CR] would be\nideal for looking after [CS:N]Manaphy[CR].", french="Nous pensons que [CS:N]Kaimorse[CR]\nsera le Pokémon idéal pour s'occuper de\n[CS:N]Manaphy[CR].", german="Unser Gefühl sagte uns, dass\n[CS:N]Walraisa[CR] die richtige Wahl sein würde, um\nauf [CS:N]Manaphy[CR] aufzupassen.", italian="Abbiamo pensato che [CS:N]Walrein[CR]\nè il Pokémon ideale per occuparsi di [CS:N]Manaphy[CR].", spanish="Pensamos que [CS:N]Walrein[CR] podría\nocuparse de [CS:N]Manaphy[CR] como es debido."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_todozeruga = SkySceneKit.spawn_npc("walrein", 496, 160, Direction.DownLeft, "NPC_TODOZERUGA")
  pcall(function() UI:SetSpeaker(npc_npc_todozeruga) end)
  SkySceneKit.say({english="Aye.[K] I've heard all I need to\nhear from your [CS:N]Wigglytuff[CR].", french="En effet.[K] [CS:N]Grodoudou[CR] m'a expliqué\ntout ce que je devais savoir à ce sujet.", german="Ja.[K] Euer [CS:N]Knuddeluff[CR] hat mir\nalles erzählt, was ich wissen muss.", italian="Già.[K] [CS:N]Wigglytuff[CR] mi ha\nspiegato tutto.", spanish="Sí.[K] [CS:N]Wigglytuff[CR] ya me ha puesto\nal corriente de todo."})
  pcall(function() UI:SetSpeaker(npc_npc_todozeruga) end)
  SkySceneKit.say({english="You've my word. I'll take full\nresponsibility for raising [CS:N]Manaphy[CR].", french="Vous avez ma parole. Je prends\nla responsabilité d'élever [CS:N]Manaphy[CR].", german="Ihr habt mein Wort. Ich\nübernehme die volle Verantwortung für die\nErziehung von [CS:N]Manaphy[CR].", italian="Avete la mia parola. Mi occuperò\na tempo pieno di [CS:N]Manaphy[CR].", spanish="Tenéis mi palabra. Me encargaré\nde criar a [CS:N]Manaphy[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Take good care of the little guy.", french="Prends bien soin de ce petit\ngars, d'accord?", german="Pass gut auf das kleine Kerlchen\nauf.", italian=" Prenditi cura di questo cucciolo.", spanish=" Cuídalo bien."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Please take good care of the\nlittle guy.", french="Prends bien soin de ce petit\ngars, d'accord?", german="Bitte pass gut auf das kleine\nKerlchen auf.", italian=" Prenditi cura di questo cucciolo.", spanish=" Cuídalo bien, por favor."})
  else
  SkySceneKit.say({english="Please take good care of the\nlittle cutie.", french="Prends bien soin de ce petit\ngars, d'accord?", german="Bitte pass gut auf das kleine\nKerlchen auf.", italian=" Prenditi cura di questo cucciolo.", spanish=" Cuídalo bien, por favor."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_IN_THE_HANDS_OF_FATE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Manaphy[CR].[K] From now on, I want\nyou to be good and obey [CS:N]Walrein[CR].", french="[CS:N]Manaphy[CR].[K] Maintenant, sois bien\ngentil et écoute toujours [CS:N]Kaimorse[CR].", german="[CS:N]Manaphy[CR].[K] Ich möchte,\ndass du jetzt artig bist und [CS:N]Walraisa[CR]\ngehorchst.", italian="[CS:N]Manaphy[CR].[K] D'ora in poi voglio\nche tu faccia il bravo e obbedisca a [CS:N]Walrein[CR].", spanish="[CS:N]Manaphy[CR].[K] A partir de ahora,\nquiero que te portes bien y obedezcas a\n[CS:N]Walrein[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Manaphy[CR].[K] From now on, I want\nyou to be good and listen to [CS:N]Walrein[CR].", french="[CS:N]Manaphy[CR].[K] Maintenant, sois bien\ngentil et écoute toujours [CS:N]Kaimorse[CR].", german="[CS:N]Manaphy[CR].[K] Ich möchte,\ndass du jetzt artig bist und [CS:N]Walraisa[CR]\ngehorchst.", italian="[CS:N]Manaphy[CR].[K] D'ora in poi voglio\nche tu faccia il bravo e obbedisca a [CS:N]Walrein[CR].", spanish="[CS:N]Manaphy[CR].[K] A partir de ahora,\nquiero que te portes bien y obedezcas a\n[CS:N]Walrein[CR]."})
  else
  SkySceneKit.say({english="[CS:N]Manaphy[CR].[K] From now on, I want\nyou to be good and listen to [CS:N]Walrein[CR].", french="[CS:N]Manaphy[CR].[K] Maintenant, sois bien\ngentil et écoute toujours [CS:N]Kaimorse[CR].", german="[CS:N]Manaphy[CR].[K] Ich möchte,\ndass du jetzt artig bist und [CS:N]Walraisa[CR]\ngehorchst.", italian="[CS:N]Manaphy[CR].[K] D'ora in poi voglio\nche tu faccia il bravo e obbedisca a [CS:N]Walrein[CR].", spanish="[CS:N]Manaphy[CR].[K] A partir de ahora,\nquiero que te portes bien y obedezcas a\n[CS:N]Walrein[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And grow strong and healthy in\nthe sea...", french="Et grandis en bonne santé dans\nla mer...", german="Und dass du im Meer groß und\nstark wirst!", italian="E cresci forte e in salute\nnel mare...", spanish="Y que crezcas, sano y fuerte,\nen el mar..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And grow strong and healthy in\nthe sea...", french="Et grandis en bonne santé dans\nla mer...", german="Und dass du im Meer groß und\nstark wirst!", italian="E cresci forte e in salute\nnel mare...", spanish="Y que crezcas, sano y fuerte,\nen el mar..."})
  else
  SkySceneKit.say({english="And grow strong and healthy in\nthe sea...", french="Et grandis en bonne santé dans\nla mer...", german="Und dass du im Meer groß und\nstark wirst!", italian="E cresci forte e in salute\nnel mare...", spanish="Y que crezcas, sano y fuerte,\nen el mar..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  local npc_npc_manafi = SkySceneKit.spawn_npc("manaphy", 456, 160, Direction.Down, "NPC_MANAFI")
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "question", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" ?", french=" ?", german=" ?", italian=" ?", spanish=" (?)"})
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Urf...[K] As you get older...[K]\nDon't forget us...", french="Ah...[K] Et même en grandissant...\nne nous oublie pas...", german="Hmpf...[K] Wenn du älter\nwirst...[K] Vergiss uns nicht...", italian="Uh...[K] Crescendo...[K]\nnon scordarti di noi...", spanish="Glup...[K] Cuando crezcas...[K]\nNo nos olvides..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Urf...[K] As you get older...[K]\nDon't forget us...", french="Ah...[K] Et même en grandissant...\nne nous oublie pas...", german="Hmpf...[K] Wenn du älter\nwirst...[K] Vergiss uns nicht...", italian="Uh...[K] Crescendo...[K]\nnon scordarti di noi...", spanish="Glup...[K] Cuando crezcas...[K]\nNo nos olvides..."})
  else
  SkySceneKit.say({english="Urf...[K] As you get older...[K]\nPlease don't forget us...", french="Ah...[K] Et même en grandissant...\nne nous oublie pas...", german="Hmpf...[K] Wenn du älter\nwirst...[K] Vergiss uns nicht...", italian="Uh...[K] Crescendo...[K]\nnon scordarti di noi...", spanish="Esto...[K] Cuando crezcas...[K]\nNo nos olvides..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_manafi, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "question", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" ...?[K] [partner]?", french=" ...?[K] [partner]?", german=" ...[K][partner]?", italian=" ...?[K] [partner]?", spanish=" ¿Eh?[K] ¿[partner]?"})
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_manafi, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" ...[hero]?", french=" ... [hero]?", german=" ...[hero]?", italian=" [hero]?", spanish=" ¿[hero]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Prolonging this will only make\nit worse...", french="Faire durer ce moment ne va\npas arranger les choses...", german="Es wird nur schlimmer, je länger\nwir es herauszögern...", italian="Tirarla per le lunghe ci farà\nsolo sentire peggio...", spanish=" No servirá de nada prolongarlo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" [CS:N]Walrein[CR], please...", french=" [CS:N]Kaimorse[CR], je te prie...", german="[CS:N]Walraisa[CR], bitte...", italian=" [CS:N]Walrein[CR], per favore...", spanish=" [CS:N]Walrein[CR], por favor..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_todozeruga, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_todozeruga) end)
  SkySceneKit.say({english=" Aye.", french=" Oui.", german=" Ja.", italian=" Sì.", spanish=" Sí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_todozeruga, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_todozeruga) end)
  SkySceneKit.say({english=" We're going, [CS:N]Manaphy[CR].", french=" Nous partons, [CS:N]Manaphy[CR].", german=" Wir gehen, [CS:N]Manaphy[CR].", italian=" Andiamo, [CS:N]Manaphy[CR].", spanish=" Nos vamos, [CS:N]Manaphy[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_manafi, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" ...?", french=" ...?", german=" ...", italian=" ...?", spanish=" (?)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_todozeruga.Position; GROUND:MoveToPosition(npc_npc_todozeruga, p.X+(-16), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" ...???", french=" ...???", german=" ......", italian=" ...???", spanish=" (!) (?)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_manafi, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" ...[hero]?", french=" ... [hero]?", german=" ...[hero]?", italian=" ... [hero]?", spanish=" ¿[hero]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_manafi, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" ...[partner]?", french=" ... [partner]?", german=" ...[partner]?", italian=" ... [partner]?", spanish=" ¿[partner]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_todozeruga, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- SetAnimation(42) [anim idle native]
  -- SetAnimation(48) [anim idle native]
  do local p=npc_npc_todozeruga.Position; GROUND:MoveToPosition(npc_npc_todozeruga, p.X+(0), p.Y+(-104), false, 1) end -- SlidePositionOffset
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(0), p.Y+(-104), false, 1) end -- SlidePositionOffset
  -- message_SetWaitMode(180, 90) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" ...[hero]![K] ...[partner]!", french="... [hero]![K]\n... [partner]!", german=" ...[hero]![K] ...[partner]!", italian="... [hero]![K]\n... [partner]!", spanish="¡Eh, [hero]!\n[K]¡[partner]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_SetWaitMode(-1, -1) [neutre/état moteur]
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Sniffle...", french=" Snif...", german=" Schnief...", italian=" Sniff...", spanish=" Snif..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Sniffle...", french=" Snif...", german=" Schnief...", italian=" Sniff...", spanish=" Snif..."})
  else
  SkySceneKit.say({english=" Sniffle...", french=" Snif...", german=" Schnief...", italian=" Sniff...", spanish=" Snif..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Take care...[K] [CS:N]Manaphy[CR].", french="Prends bien soin de toi...[K]\n[CS:N]Manaphy[CR].", german=" Lebe wohl...[K] [CS:N]Manaphy[CR].", italian=" Abbi cura di te...[K] [CS:N]Manaphy[CR].", spanish=" Cuídate...[K] [CS:N]Manaphy[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Take care...[K] [CS:N]Manaphy[CR].", french="Prends bien soin de toi...[K]\n[CS:N]Manaphy[CR].", german=" Lebe wohl...[K] [CS:N]Manaphy[CR].", italian=" Abbi cura di te...[K] [CS:N]Manaphy[CR].", spanish=" Cuídate...[K] [CS:N]Manaphy[CR]."})
  else
  SkySceneKit.say({english=" Take care...[K] [CS:N]Manaphy[CR].", french="Prends bien soin de toi...[K]\n[CS:N]Manaphy[CR].", german=" Lebe wohl...[K] [CS:N]Manaphy[CR].", italian=" Abbi cura di te...[K] [CS:N]Manaphy[CR].", spanish=" Cuídate...[K] [CS:N]Manaphy[CR]."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(180) end)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  SkySubScreen.Hide(90) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 90)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(2) -- join WaitBgm2
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
