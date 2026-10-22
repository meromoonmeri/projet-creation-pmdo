-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07A/m15b1101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  GAME:WaitFrames(60)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 184, 160, Direction.Down, "NPC_CHIRIIN")
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Oh![K] Are you awake?", french="Oh![K] Vous avez enfin repris\nconnaissance?", german=" Oh![K] Bist du wach?", italian=" Oh![K] Come vi sentite?", spanish=" ¡Vaya![K] ¿Os habéis despertado?"})
  -- message_Close
  -- back_SetGround(LEVEL_G01P07A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(76) [anim idle native]
  -- SetAnimation(76) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(60)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-where...?", french=" Où... où...?", german=" W-wo?", italian=" D-Dove...?", spanish=" ¿Dónde?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-where...?", french=" Où... où...?", german=" W-wo?", italian=" D-Dove...?", spanish=" ¿Dónde?"})
  else
  SkySceneKit.say({english=" Wh-where...?", french=" Où... où...?", german=" W-wo?", italian=" D-Dove...?", spanish=" ¿Dónde?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chiriin, Direction.DownLeft)
  GROUND:EntTurn(partner, Direction.UpRight)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, hero, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" You're in your room at the guild.", french="Vous êtes dans votre dortoir\nà la Guilde.", german="Ihr seid in eurem Crewraum in\nder Gilde.", italian="Nella vostra stanza. Siete di\nnuovo alla Gilda.", spanish="Estáis en vuestra habitación\ndel [CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="You were both hurt. You've been\nsleeping all this time.", french="Vous étiez en piteux état.\nCela fait pas mal de temps que vous dormez.", german="Ihr wart beide verletzt. Ihr habt\ndie ganze Zeit geschlafen.", italian="Ce l'avete fatta per miracolo.\nAvete dormito per un sacco di tempo.", spanish="Acabasteis muy mal.\nLleváis durmiendo todo este tiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Are you all right, [hero]?", french=" Tu vas bien, [hero]?", german=" Geht es dir gut, [hero]?", italian=" Come ti senti, [hero]?", spanish=" ¿Estás bien, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are you all right, [hero]?", french=" Tu vas bien, [hero]?", german=" Geht es dir gut, [hero]?", italian=" Come ti senti, [hero]?", spanish=" ¿Estás bien, [hero]?"})
  else
  SkySceneKit.say({english=" Are you all right, [hero]?", french=" Tu vas bien, [hero]?", german=" Geht es dir gut, [hero]?", italian=" Come ti senti, [hero]?", spanish=" ¿Estás bien, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whew! Am I glad!", french=" Ouf! Soulagé de l'entendre!", german=" Puh! Zum Glück!", italian=" Fiuu! Meno male!", spanish=" ¡Menos mal! ¡Cómo me alegro!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Whew! Am I glad to hear it!", french=" Ouf! Soulagé de l'entendre!", german=" Puh! Bin ich froh!", italian=" Fiuu! Sono contento di sentirlo!", spanish=" ¡Menos mal! ¡Cómo me alegro!"})
  else
  SkySceneKit.say({english=" Whew! Am I glad to hear it!", french=" Ouf! Soulagée de l'entendre!", german=" Puh! Bin ich froh!", italian=" Fiuu! Sono contenta di sentirlo!", spanish=" ¡Menos mal! ¡Cómo me alegro!"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I remember fainting at\n[CS:P]Shining Lake[CR]...", french="Je me rappelle m'être évanoui\nau [CS:P]Lac Cristal[CR]...", german="Ich weiß noch, dass ich am\n[CS:P]Kristallsee[CR] ohnmächtig wurde...", italian="Ricordo che abbiamo perso i\nsensi al [CS:P]Lago di Cristallo[CR]...", spanish="Recuerdo haberme debilitado\nen el [CS:P]Lago Cristal[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I remember passing out at\n[CS:P]Shining Lake[CR]...", french="Je me rappelle m'être évanoui\nau [CS:P]Lac Cristal[CR]...", german="Ich weiß noch, dass ich am\n[CS:P]Kristallsee[CR] ohnmächtig wurde...", italian="Ricordo che abbiamo perso i\nsensi al [CS:P]Lago di Cristallo[CR]...", spanish="Recuerdo haberme debilitado\nen el [CS:P]Lago Cristal[CR]."})
  else
  SkySceneKit.say({english="I remember passing out at\n[CS:P]Shining Lake[CR]...", french="Je me rappelle m'être évanouie\nau [CS:P]Lac Cristal[CR]...", german="Ich weiß noch, dass ich am\n[CS:P]Kristallsee[CR] ohnmächtig wurde...", italian="Ricordo che abbiamo perso i\nsensi al [CS:P]Lago di Cristallo[CR]...", spanish="Recuerdo haberme debilitado\nen el [CS:P]Lago Cristal[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It seems like I can speak again...", french="Tiens, on dirait que j'ai retrouvé\nla parole...", german="Anscheinend kann ich wieder\nsprechen...", italian="Adesso riesco di nuovo a\nparlare...", spanish="Parece que ya he recuperado\nel habla."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It seems like I can speak again...", french="Tiens, on dirait que j'ai retrouvé\nla parole...", german="Anscheinend kann ich wieder\nsprechen...", italian="Adesso riesco di nuovo a\nparlare...", spanish="Parece que ya he recuperado\nel habla."})
  else
  SkySceneKit.say({english=" It seems like I can speak again...", french="Tiens, on dirait que j'ai retrouvé\nla parole...", german="Anscheinend kann ich wieder\nsprechen...", italian="Adesso riesco di nuovo a\nparlare...", spanish="Parece que ya he recuperado\nel habla."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh yeah! What about [CS:N]Azelf[CR]?!", french=" Au fait, et [CS:N]Créfadet[CR]?!", german=" Ach ja! Was ist mit [CS:N]Tobutz[CR]?!?", italian="Aspetta! Che ne è stato di\n[CS:N]Azelf[CR]?!", spanish="¡Se me olvidaba!\n¿Qué ha pasado con [CS:N]Azelf[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh! What about [CS:N]Azelf[CR]?!", french=" Au fait, et [CS:N]Créfadet[CR]?!", german=" Oh! Was ist mit [CS:N]Tobutz[CR]?!?", italian=" Un momento! Come sta [CS:N]Azelf[CR]?", spanish="¡Se me olvidaba!\n¿Qué ha pasado con [CS:N]Azelf[CR]?"})
  else
  SkySceneKit.say({english="Oh, that's right! What happened\nto [CS:N]Azelf[CR]?!", french=" Au fait, et [CS:N]Créfadet[CR]?!", german=" Ach ja! Was ist mit [CS:N]Tobutz[CR]?!?", italian=" Un momento! Come sta [CS:N]Azelf[CR]?", spanish="¡Ah, es verdad!\n¿Qué ha pasado con [CS:N]Azelf[CR]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Is [CS:N]Azelf[CR] all right?", french=" Est-ce qu'il va bien?", german=" Geht es [CS:N]Tobutz[CR] gut?", italian=" Sta bene?", spanish=" ¿Está bien [CS:N]Azelf[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Is [CS:N]Azelf[CR] OK?", french=" Est-ce qu'il va bien?", german=" Geht es [CS:N]Tobutz[CR] gut?", italian=" Qualcuno ha notizie di [CS:N]Azelf[CR]?", spanish=" ¿Está bien [CS:N]Azelf[CR]?"})
  else
  SkySceneKit.say({english=" Is [CS:N]Azelf[CR] OK?", french=" Est-ce qu'il va bien?", german=" Geht es [CS:N]Tobutz[CR] gut?", italian=" Qualcuno ha notizie di [CS:N]Azelf[CR]?", spanish=" ¿Está bien [CS:N]Azelf[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" He's fine.", french=" Oui, il va bien.", german=" Es geht ihm gut.", italian=" Sì, sta bene.", spanish=" No os preocupéis."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="[partner], compared to you\ntwo, his injuries weren't that severe.", french="[partner], comparées\naux vôtres, ses blessures étaient\nsuperficielles.", german="[partner], im Vergleich zu\neuch war es nicht schwer verletzt.", italian="Non era messo male come voi,\n[partner].", spanish="[partner], comparado con las\nvuestras, sus heridas no eran tan serias."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="He regained consciousness\nearlier. He's in the guild now.", french="Il est revenu à lui il y a\nun moment. Il est à la Guilde\nen ce moment même.", german="Es ist früher wieder zu sich\ngekommen und ist jetzt in der Gilde.", italian="Si è risvegliato poco fa. Si\ntrova qui alla Gilda.", spanish="Recuperó la consciencia hace\nun rato. Ahora está en el [CS:N]Pokégremio[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, that's great!", french=" Excellente nouvelle!", german=" Oh, großartig!", italian=" Meno male!", spanish=" ¡Vaya, me alegro!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, excellent!", french=" Excellente nouvelle!", german=" Oh, das ist gut!", italian=" Bene!", spanish=" ¡Excelente!"})
  else
  SkySceneKit.say({english=" Oh, I'm glad to hear that!", french=" Excellente nouvelle!", german=" Oh, da bin ich erleichtert!", italian=" Bene!", spanish=" ¡Me alegra saberlo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I'm glad you're OK too,\n[partner] and [hero]!", french="Je suis contente que vous alliez\nbien, [partner] et [hero]!", german="Ich bin froh, dass es euch auch\ngut geht, [partner] und [hero]!", italian="[partner]! [hero]!\nSiamo stati in pensiero per voi.\nPer fortuna adesso state bene!", spanish="Me alegro de que también\nestéis bien, [partner] y [hero]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chiriin, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I should let the guild know\nyou're awake.", french="Je vais prévenir tout le monde\nque vous avez repris connaissance.", german="Ich sollte den anderen sagen,\ndass ihr wach seid.", italian=" Devo farlo sapere a tutti.", spanish="Voy a decirles a los demás\nque os habéis despertado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5123) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitSe
  GROUND:EntTurn(npc_npc_chiriin, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Everyone! They're awake!", french="Eh tout le monde! Ces deux-là\nont repris connaissance!", german=" Leute! Sie sind wach!", italian=" Ehi gente! Hanno ripreso i sensi!", spanish="¡Atención!\n¡Ya se han despertado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6916) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- supervision_Acting(1) [neutre/état moteur]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 16, 184, Direction.Right, "NPC_DOGOOMU")
  GROUND:MoveToPosition(npc_npc_dogoomu, 128, 180, false, 2)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 16, 184, Direction.Right, "NPC_BIPPA")
  GROUND:MoveToPosition(npc_npc_bippa, 128, 180, false, 2)
  GAME:WaitFrames(10)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 16, 184, Direction.Right, "NPC_KIMAWARI")
  GROUND:MoveToPosition(npc_npc_kimawari, 128, 180, false, 2)
  GAME:WaitFrames(10)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 16, 184, Direction.Right, "NPC_HEIGANI")
  GROUND:MoveToPosition(npc_npc_heigani, 128, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 176, 180, false, 2)
  GAME:WaitFrames(5)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(partner, 208, 180, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 208, 200, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 176, 204, false, 2)
  GROUND:MoveToPosition(npc_npc_kimawari, 152, 164, false, 2)
  GROUND:EntTurn(hero, Direction.Left)
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(npc_npc_heigani, 152, 180, false, 2)
  GROUND:EntTurn(npc_npc_chiriin, Direction.DownRight)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownRight)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(15)
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- se_Stop(6916) [SE one-shot PMDO déjà terminé: arrêt sans objet, canal SE V2]
  GROUND:EntTurn(partner, Direction.DownLeft)
  GROUND:EntTurn(hero, Direction.Left)
  -- GAP: se_Play(6414) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(2) [neutre/état moteur]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 144, 200, Direction.Down, "NPC_DIGUDA")
  -- SetAnimation(23) [anim idle native]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 16, 184, Direction.Right, "NPC_GUREGGURU")
  GROUND:MoveToPosition(npc_npc_guregguru, 128, 180, false, 2)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.DownLeft)
  -- SetAnimation(4) [anim idle native]
  GROUND:EntTurn(npc_npc_diguda, Direction.Right)
  -- GAP: se_Play(6414) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(3) [neutre/état moteur]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 208, 160, Direction.Down, "NPC_DAGUTORIO")
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Down)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" R-really?! AWESOME!", french=" Vraiment?! SUPER!", german=" W-wirklich?!? WUNDERBAR!", italian=" S-Sul serio?! GRANDE!", spanish=" ¡¿En... en serio?! ¡Genial!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Oh my gosh! That's wonderful\nnews!", french="Ben mince alors! Excellente\nnouvelle!", german="Auweia! Das sind wunderbare\nNeuigkeiten!", italian=" Shock! Che bella notizia!", spanish=" ¡Es una noticia superestupenda!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Oof! I'm mighty glad!", french=" Pfiou! J'suis hyper content!", german=" Uff! Bin ich froh!", italian=" Ooh! È fantastico, sissignore!", spanish=" ¡Uf! Me alegro, menos mal."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="If anything would've happened\nto you all...", french="S'il vous était arrivé quoi\nqu'ce soit...", german="Wenn euch etwas zugestoßen\nwäre...", italian="Se vi fosse mai successo\nqualcosa...", spanish=" Si os hubiera pasado algo malo..."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" I'd...[K] I'd...[K] Oof...", french=" Je...[K] je...[K] Pfiou...", german=" Ich...[K] Ich wäre...[K] Uff...", italian=" Io...[K] Io...[K] Ohibò...", spanish=" Yo...[K] Yo...[K] Uf..."})
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Oh, come on, you guys. Don't get\nso emotional over this.", french="Oh, allez les gars, vous n'allez\npas pleurer quand même.", german="Ach, kommt schon, Leute. Macht\neuch keine Sorgen!", italian="Eddai, gente. Cerchiamo di non\nfare gli sdolcinati, adesso!", spanish="Venga, chicos... No os pongáis\ntan sentimentales por esto."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You guys are getting so\nemotional about this!", french="Oh, allez les gars, vous n'allez\npas pleurer quand même.", german="Ihr habt euch ja wirklich Sorgen\ngemacht!", italian="Grazie ragazzi, ma vi prego,\nnon esagerate!", spanish=" ¡Tampoco es para tanto!"})
  else
  SkySceneKit.say({english="You guys are getting so\nemotional about this!", french="Oh, allez les gars, vous n'allez\npas pleurer quand même.", german="Ihr habt euch ja wirklich Sorgen\ngemacht!", italian="Grazie ragazzi, ma vi prego,\nnon esagerate!", spanish=" ¡Tampoco es para tanto!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(30) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh! That's right!", french=" Oh, j'ai failli oublier!", german=" Da fällt mir etwas ein!", italian=" Oh! Aspetta, ora che ci penso...", spanish=" ¡Ah! ¡Es verdad!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh! That's right!", french=" Oh, j'ai failli oublier!", german=" Da fällt mir etwas ein!", italian=" Oh! Aspetta, ora che ci penso...", spanish=" ¡Ah! ¡Es verdad!"})
  else
  SkySceneKit.say({english=" Oh! That's right!", french=" Oh, j'ai failli oublier!", german=" Da fällt mir etwas ein!", italian=" Oh! Aspetta, ora che ci penso...", spanish=" ¡Ah! ¡Es verdad!"})
  end
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="There's something that I need to\ntell everyone!", french=" J'ai quelque chose à vous dire!", german=" Ich muss euch etwas sagen!", italian=" C'è qualcosa che devo dirvi!", spanish="Hay algo que tengo que contaros\na todos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There's something that I need to\nshare with everyone!", french=" J'ai quelque chose à vous dire!", german=" Ich muss euch etwas sagen!", italian=" C'è qualcosa che devo dirvi!", spanish="Hay algo que tengo que contaros\na todos."})
  else
  SkySceneKit.say({english="There's something that I need to\ntell everyone!", french=" J'ai quelque chose à vous dire!", german=" Ich muss euch etwas sagen!", italian=" C'è qualcosa che devo dirvi!", spanish="Hay algo que tengo que contaros\na todos."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey...?", french=" Eh dis donc, ben dis donc...", german=" Hey, hey?", italian=" Ehi, ehi...?", spanish=" ¡Oye, oye!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" And what would that be?", french=" Qu'y a-t-il?", german=" Und was wäre das?", italian=" Shock! Cosa sarà mai?", spanish=" ¿Y de qué se trata?"})
  -- message_Close
  GAME:FadeOut(false, 60)
  SkySceneKit.cleanup_npcs()
end
