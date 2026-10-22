-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P08P01A/m19a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(32, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_P08P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_FUTURE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 280, 408, Direction.Up, "NPC_JUPUTORU")
  GROUND:MoveToPosition(npc_npc_juputoru, 276, 248, false, 2)
  GROUND:MoveToPosition(partner, 248, 268, false, 2)
  GROUND:MoveToPosition(hero, 304, 268, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_juputoru, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Is this...[K] Is this where [CS:N]Celebi[CR]'s\nsupposed to be?", french="C'est...[K] c'est là que [CS:N]Celebi[CR]\nest censée se trouver?", german="Ist das...[K] Ist das der Ort, an\ndem [CS:N]Celebi[CR] sich aufhalten soll?", italian="È qui?[K] [CS:N]Celebi[CR] dovrebbe essere\nqui?", spanish="¿Es aquí...?[K] ¿Es este el sitio\ndonde tendría que estar [CS:N]Celebi[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Is this...[K] Is this where [CS:N]Celebi[CR] is\nsupposed to be?", french="C'est...[K] c'est là que [CS:N]Celebi[CR]\nest censée se trouver?", german="Ist das...[K] Ist das der Ort, an\ndem [CS:N]Celebi[CR] sich aufhalten soll?", italian="È qui?[K] [CS:N]Celebi[CR] dovrebbe essere\nqui?", spanish="¿Es aquí...?[K] ¿Es este el sitio\ndonde tendría que estar [CS:N]Celebi[CR]?"})
  else
  SkySceneKit.say({english="Is this...[K] Is [CS:N]Celebi[CR] supposed to\nbe here?", french="C'est...[K] c'est là que [CS:N]Celebi[CR]\nest censée se trouver?", german="Ist das...[K] Ist das der Ort, an\ndem [CS:N]Celebi[CR] sein soll?", italian="È qui?[K] [CS:N]Celebi[CR] dovrebbe essere\nqui?", spanish="¿Es aquí...?[K] ¿Es este el sitio\ndonde tendría que estar [CS:N]Celebi[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That's right. It was around here\nthat I met her the last time.", french="C'est exact. C'est dans les\nenvirons que je l'ai rencontrée la dernière\nfois.", german="So ist es. Es war hier\nirgendwo, als ich es das letzte Mal traf.", italian="Proprio così. L'ultima volta l'ho\nincontrata da queste parti.", spanish="En efecto. Por aquí fue donde\nla vi la última vez."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="But if Primal [CS:N]Dialga[CR] knows of\nthis place...", french="Mais si [CS:N]Dialga[CR] Primal a entendu\nparler de cet endroit...", german="Aber falls auch [CS:N]Schatten-Dialga[CR]\ndiesen Ort kennt...", italian="Ma se [CS:N]Dialga[CR] Oscuro conosce\nquesto posto...", spanish="Pero si el [CS:N]Dialga Primario[CR]\nconoce este paraje..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" [CS:N]Celebi[CR] will have fled from here.", french="... alors [CS:N]Celebi[CR] se sera réfugiée\nailleurs.", german="Dann wird [CS:N]Celebi[CR] von hier\ngeflohen sein.", italian=" [CS:N]Celebi[CR] sarà scappata.", spanish=" [CS:N]Celebi[CR] se habrá marchado."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="If this place isn't known to our\npursuers, however...", french="Cependant, si cet endroit reste\ninconnu de nos ennemis...", german="Wenn dieser Ort unseren\nVerfolgern jedoch nicht bekannt ist...", italian="Ma i nostri inseguitori\npotrebbero anche non conoscere questo posto.", spanish="Si nuestros perseguidores aún\nno saben de este lugar..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Then [CS:N]Celebi[CR] should still be here.", french="... alors [CS:N]Celebi[CR] devrait toujours\ny être.", german=" Dann sollte [CS:N]Celebi[CR] noch hier sein.", italian="In questo caso [CS:N]Celebi[CR] dovrebbe\nessere ancora qui.", spanish="[CS:N]Celebi[CR] tendría que seguir por\naquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Hello? [CS:N]Celebi[CR]?", french=" Ohé? [CS:N]Celebi[CR]?", german=" Hallo? [CS:N]Celebi[CR]?", italian=" Ehi? [CS:N]Celebi[CR]?", spanish=" [CS:N]Celebi[CR], ¿me oyes?"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" It's me! [CS:N]Grovyle[CR]!", french=" C'est moi! [CS:N]Massko[CR]!", german=" Ich bin es! [CS:N]Reptain[CR]!", italian=" Sono io! [CS:N]Grovyle[CR]!", spanish=" ¡Soy yo! ¡[CS:N]Grovyle[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Reveal yourself...if you're here!", french=" Montre-toi... si tu es là!", german=" Zeig dich... falls du hier bist!", italian=" Se ci sei... fatti vedere!", spanish=" ¡Déjate ver si estás aquí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(45)
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" She's...[K]not coming out...", french=" Elle...[K] ne se montre pas...", german=" Es...[K] zeigt sich nicht...", italian=" Non...[K] si fa vedere...", spanish=" No...[K] No sale nadie."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" She's...[K]not coming out...", french=" Elle...[K] ne se montre pas...", german=" Es...[K] zeigt sich nicht...", italian=" Non...[K] si fa vedere...", spanish=" No...[K] No sale nadie."})
  else
  SkySceneKit.say({english=" She's...[K]not coming out...", french=" Elle...[K] ne se montre pas...", german=" Es...[K] zeigt sich nicht...", italian=" Non...[K] si fa vedere...", spanish=" No...[K] No sale nadie."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Did Primal [CS:N]Dialga[CR] chase her off?", french="Est-ce que [CS:N]Dialga[CR] Primal l'aurait\nfait fuir?", german=" Hat [CS:N]Schatten-Dialga[CR] es verjagt?", italian="[CS:N]Dialga[CR] Oscuro l'avrà\nfatta fuggire?", spanish="¿Habrá huido del\n[CS:N]Dialga Primario[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Did she get frightened off by\nPrimal [CS:N]Dialga[CR]?", french="Est-ce que [CS:N]Dialga[CR] Primal l'aurait\nfait fuir?", german="Wurde es von [CS:N]Schatten-Dialga[CR]\nverscheucht?", italian="Avrà avuto paura di [CS:N]Dialga[CR]\nOscuro?", spanish="¿Habrá escapado del\n[CS:N]Dialga Primario[CR]?"})
  else
  SkySceneKit.say({english="Do you think that she got chased\noff by Primal [CS:N]Dialga[CR]?", french="Est-ce que [CS:N]Dialga[CR] Primal l'aurait\nfait fuir?", german="Glaubst du, es wurde von\n[CS:N]Schatten-Dialga[CR] verjagt?", italian="Pensi che [CS:N]Dialga[CR] Oscuro\nl'abbia fatta fuggire?", spanish="¿Habrá huido del\n[CS:N]Dialga Primario[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What if...", french=" Et si...", german=" Was wäre...", italian=" E se...", spanish=" ¿Y qué pasa si...?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What if...", french=" Et si...", german=" Was wäre...", italian=" E se...", spanish=" ¿Y qué pasa si...?"})
  else
  SkySceneKit.say({english=" What if...", french=" Et si...", german=" Was wäre...", italian=" E se...", spanish=" ¿Y qué pasa si...?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What if she's...[K]been captured by\nPrimal [CS:N]Dialga[CR]?", french="Et si...[K] [CS:N]Dialga[CR] Primal l'avait\nfaite prisonnière?", german="Was wäre, wenn[K] es von\n[CS:N]Schatten-Dialga[CR] gefangen genommen wurde?", italian="E se...[K] fosse stata catturata\nda [CS:N]Dialga[CR] Oscuro?", spanish="¿Qué pasa si la han capturado?[K]\nLa ha podido capturar el [CS:N]Dialga Primario[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What if she's...[K]been captured by\nPrimal [CS:N]Dialga[CR]?", french="Et si...[K] [CS:N]Dialga[CR] Primal l'avait\nfaite prisonnière?", german="Was wäre, wenn[K] es von\n[CS:N]Schatten-Dialga[CR] gefangen genommen wurde?", italian="E se...[K] fosse stata catturata\nda [CS:N]Dialga[CR] Oscuro?", spanish="¿Qué pasa si la han capturado?[K]\nLa ha podido capturar el [CS:N]Dialga Primario[CR]..."})
  else
  SkySceneKit.say({english="What if she's...[K]been captured by\nPrimal [CS:N]Dialga[CR]?", french="Et si...[K] [CS:N]Dialga[CR] Primal l'avait\nfaite prisonnière?", german="Was wäre, wenn[K] es von\n[CS:N]Schatten-Dialga[CR] gefangen genommen wurde?", italian="E se...[K] fosse stata catturata\nda [CS:N]Dialga[CR] Oscuro?", spanish="¿Qué pasa si la han capturado?[K]\nLa ha podido capturar el [CS:N]Dialga Primario[CR]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Captured?", french=" Prisonnière?", german=" Gefangen genommen?", italian=" Catturata?", spanish=" ¿Capturada?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa! Who said that?!", french=" Ouaaaah! D'où vient cette voix?!", german=" Hua! Wer hat das gesagt?", italian=" Ehi! Chi ha parlato?!", spanish=" ¡Hum! ¡¿Quién ha dicho eso?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wah! Where'd that voice\ncome from?!", french=" Ouaaaah! D'où vient cette voix?!", german="Uaaah! Wo kam diese Stimme\nher?", italian="Ehi! Da dove veniva quella\nvoce?!", spanish="¡Ah! ¡¿De dónde ha salido esa\nvoz?!"})
  else
  SkySceneKit.say({english=" Wah! Who said that?!", french=" Ouaaaah! D'où vient cette voix?!", german=" Uah! Wer hat das gesagt?", italian=" Ehi! Chi ha parlato?!", spanish=" ¡Ah! ¡¿Quién ha dicho eso?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But now...[K]I don't hear anything.", french="Tiens...[K] je n'entends plus rien,\nmaintenant.", german="Aber jetzt...[K] höre ich nichts\nmehr.", italian=" Ora...[K] non sento più niente.", spanish=" Bueno...[K] Ya no oigo nada."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But now...[K]I don't hear anything.", french="Tiens...[K] je n'entends plus rien,\nmaintenant.", german="Aber jetzt...[K] höre ich nichts\nmehr.", italian=" Ora...[K] non sento più niente.", spanish=" Bueno...[K] Ya no oigo nada."})
  else
  SkySceneKit.say({english=" But now...[K]I don't hear anything.", french="Tiens...[K] je n'entends plus rien,\nmaintenant.", german="Aber jetzt...[K] höre ich nichts\nmehr.", italian=" Ora...[K] non sento più niente.", spanish=" Bueno...[K] Ya no oigo nada."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That voice...[K] Did I imagine it?", french="Cette voix...[K] c'était juste mon\nimagination qui me jouait des tours?", german="Diese Stimme...[K] Habe ich mir das\neingebildet?", italian="Quella voce...[K] Me la sarò\nimmaginata?", spanish="Esa voz...[K] ¿Habrá sido mi\nimaginación?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That voice...[K] Was I just\nhearing things?", french="Cette voix...[K] c'était juste mon\nimagination qui me jouait des tours?", german="Diese Stimme...[K] Habe ich mir das\neingebildet?", italian="Quella voce...[K] L'ho sentita solo\nio?", spanish="Esa voz...[K] ¿Habrá sido mi\nimaginación?"})
  else
  SkySceneKit.say({english="That voice...[K] Was I just\nhearing things?", french="Cette voix...[K] c'était juste mon\nimagination qui me jouait des tours?", german="Diese Stimme...[K] Habe ich mir das\neingebildet?", italian="Quella voce...[K] L'ho sentita solo\nio?", spanish="Esa voz...[K] ¿Habrá sido mi\nimaginación?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Tee-hee! You didn't imagine it!", french="Hi hi! Non, ce n'était pas ton\nimagination!", german=" Hihi! Das war keine Einbildung!", italian=" Eeh-eeh! Non l'hai immaginata!", spanish=" ¡Ji, ji! ¡No te lo has imaginado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Me? Captured?", french=" Moi? Prisonnière?", german=" Ich? Gefangen genommen?", italian=" Io? Catturata?", spanish=" ¿Yo? ¿Capturada?"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" How insulting![K] Captured?!", french=" Quelle impudence![K] Prisonnière?!", german="Was für eine Beleidigung![K] Gefangen\ngenommen?!?", italian=" Che affronto![K] Catturata?!", spanish=" ¡Qué insultante![K] ¡Capturada!"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Impossible, that's for sure! Tee-hee!", french=" C'est tout bonnement impossible! Hi hi!", german=" Unmöglich, das steht fest! Hihi!", italian=" Impossibile, poco ma sicuro! Eeh-eeh!", spanish=" ¡Eso es imposible! ¡Ji, ji!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpRight)
  -- GAP: SetEffect 645 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(20)
  -- GAP: se_Play(7433) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(134)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(60)
  -- GAP: BGM BGM_WELCOME_TO_THE_WORLD_OF_POKEMON non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  local npc_npc_serebii = SkySceneKit.spawn_npc("celebi", 280, 208, Direction.Down, "NPC_SEREBII")
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" It's been too long, my dear [CS:N]Grovyle[CR]!", french="Ça faisait bien longtemps, mon cher\n[CS:N]Massko[CR]!", german="Wir haben uns zu lange nicht gesehen,\nmein lieber [CS:N]Reptain[CR]!", italian=" Ne è passato di tempo, mio caro [CS:N]Grovyle[CR]!", spanish="¡Cuánto tiempo sin verte, mi querido\n[CS:N]Grovyle[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Yes. It has been a while, [CS:N]Celebi[CR].", french=" Oui. En effet, [CS:N]Celebi[CR].", german=" Ja. Es ist eine Weile her, [CS:N]Celebi[CR].", italian="Sì. È passato un po' di tempo,\n[CS:N]Celebi[CR].", spanish="Sí. Ha pasado mucho tiempo,\n[CS:N]Celebi[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?![K] This tiny thing is [CS:N]Celebi[CR]?", french="Hein?![K] Cette minuscule créature,\nc'est [CS:N]Celebi[CR]?", german="Huch?!?[K] Dieses kleine Ding ist\n[CS:N]Celebi[CR]?", italian=" Eh?![K] Quella cosina è [CS:N]Celebi[CR]?", spanish=" ¡¿Eh?![K] ¿Esa cosita es [CS:N]Celebi[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?![K] This tiny thing is [CS:N]Celebi[CR]?", french="Hein?![K] Cette minuscule créature,\nc'est [CS:N]Celebi[CR]?", german="Was?!?[K] Dieses kleine Ding ist\n[CS:N]Celebi[CR]?", italian=" Eh?![K] Quella cosina è [CS:N]Celebi[CR]?", spanish=" ¡¿Eh?![K] ¿Esa cosita es [CS:N]Celebi[CR]?"})
  else
  SkySceneKit.say({english=" What?![K] This tiny thing is [CS:N]Celebi[CR]?", french="Hein?![K] Cette minuscule créature,\nc'est [CS:N]Celebi[CR]?", german="Was?!?[K] Dieses kleine Ding ist\n[CS:N]Celebi[CR]?", italian=" Eh?![K] Quella cosina è [CS:N]Celebi[CR]?", spanish=" ¡¿Eh?![K] ¿Esa cosita es [CS:N]Celebi[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_serebii, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Now that is downright rude!", french=" Décidément, quelle impolitesse!", german="Das ist jetzt aber wirklich\nunverschämt!", italian=" Che maleducazione!", spanish=" Vaya, ¡menudos modales!"})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="How inappropriate! To poke fun\nat my petite proportions...", french="Se moquer de ma petite taille...\nComme c'est déplacé!", german="Wie ungezogen! Sich über\nmeine zierlichen Proportionen lustig zu\nmachen...", italian="E quant'è inappropriato!\nFarsi gioco di me perché sono così... piccina!", spanish="¡Qué insensible! Reírse así de\nmi figura..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Uh...[K]I'm sorry.", french=" Euh...[K] je m'excuse.", german=" Äh...[K] Tut mir leid.", italian=" Uh...[K] Mi dispiace.", spanish=" Esto...[K] Lo siento."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Uh...[K]I'm sorry.", french=" Euh...[K] je m'excuse.", german=" Äh...[K] Tut mir leid.", italian=" Uh...[K] Mi dispiace.", spanish=" Esto...[K] Lo siento."})
  else
  SkySceneKit.say({english=" Uh...[K]I'm sorry.", french=" Euh...[K] je m'excuse.", german=" Äh...[K] Tut mir leid.", italian=" Uh...[K] Mi dispiace.", spanish=" Esto...[K] Lo siento."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I heard you have the ability to\ncross time...", french="Il paraît que tu peux\nvoyager dans le temps...", german="Ich habe gehört, dass du die Zeit\ndurchqueren kannst...", italian="Ho sentito che sai come si fa a\nviaggiare nel tempo.", spanish="Me habían dicho que tienes\nla capacidad de cruzar el tiempo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I heard you have the ability to\ncross time...", french="Il paraît que tu peux\nvoyager dans le temps...", german="Ich habe gehört, dass du die Zeit\ndurchqueren kannst...", italian="Ho sentito che sai come si fa a\nviaggiare nel tempo.", spanish="He oído que tienes la capacidad\nde cruzar el tiempo."})
  else
  SkySceneKit.say({english="I was told you have the ability\nto cross time...", french="Il paraît que tu peux\nvoyager dans le temps...", german="Ich habe gehört, dass du die Zeit\ndurchqueren kannst...", italian="Ho sentito che sai come si fa a\nviaggiare nel tempo.", spanish="Según he oído, puedes cruzar\nel tiempo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So I was expecting to see some\nkind of an awesome-looking Pokémon...", french="... alors je m'attendais à\nun Pokémon à l'allure imposante...", german="Deswegen habe ich ein äußerlich\nmehr Eindruck schindendes Pokémon erwartet...", italian="Così mi aspettavo di vedere un\nPokémon... come dire... imponente.", spanish="Así que me esperaba un Pokémon\nde aspecto impresionante..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So I expected you to be some\nawe-inspiring Pokémon...", french="... alors je m'attendais à\nun Pokémon à l'allure imposante...", german="Deswegen erwartete ich, dass\ndu ein sehr ehrfurchterregendes Pokémon\nsein würdest...", italian="Così mi aspettavo che fossi un\nPokémon di una certa imponenza...", spanish="Así que me esperaba un Pokémon\nde aspecto impresionante..."})
  else
  SkySceneKit.say({english="So I imagined you to be an\nawe-inspiring Pokémon...", french="... alors je m'attendais à\nun Pokémon à l'allure imposante...", german="Deswegen erwartete ich, dass\ndu ein sehr ehrfurchterregendes Pokémon\nsein würdest...", italian="Così ti ho immaginata un\nPokémon di una certa imponenza...", spanish="Así que me esperaba un Pokémon\nde aspecto impresionante..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="How uncouth![K] Never judge\nsomeone by appearance!", french="Que d'indélicatesse![K]\nLes apparences sont trompeuses, tu devrais\nle savoir!", german="Wie ungehobelt![K] Man sollte\nniemanden nach seinem Äußeren beurteilen!", italian="Che villania![K] Non si\ngiudica mai dall'apparenza!", spanish="¡Qué grosería![K] ¡No deberías\njuzgar a nadie por su aspecto!"})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" But...[K]I forgive you.", french=" Mais... [K]je te pardonne.", german=" Aber...[K] Ich vergebe dir.", italian=" Ma...[K] ti perdono.", spanish=" Aunque...[K] te perdono."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" After all...", french=" Après tout...", german=" Schließlich...", italian=" Dopotutto...", spanish=" Al fin y al cabo..."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="You must find me cuter and\nmore special than you imagined![K] Tee-hee!", french="... vous devez me trouver plus\nmignonne et surprenante que vous ne\nl'imaginiez![K] Hi hi!", german="Nun, du findest mich bestimmt\nniedlicher und außergewöhnlicher als erwartet.\n[K]Hihi!", italian="Credo proprio che mi trovi più\ncarina e speciale di quanto immaginassi![K]\nEeh-eeh!", spanish="¡Supongo que no contabas con\nencontrarte un Pokémon tan bello y especial![K]\n¡Ji, ji!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Uh, yeah...", french=" Euh, oui...", german=" Äh, ja...", italian=" Ehm, certo...", spanish=" Si tú lo dices..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Um, yes.", french=" Euh, oui...", german=" Öhm, ja.", italian=" Ehm, sì.", spanish=" Esto... Sí..."})
  else
  SkySceneKit.say({english=" Well, yes.", french=" Euh, oui...", german=" Nun, ja.", italian=" Beh, sicuro.", spanish=" Esto... Sí..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(0), p.Y+(-8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" [CS:N]Celebi[CR].[K] I need your help again.", french="[CS:N]Celebi[CR].[K] J'ai à nouveau besoin\nde ton aide.", german="[CS:N]Celebi[CR].[K] Ich brauche wieder deine\nHilfe.", italian="[CS:N]Celebi[CR].[K] Ho di nuovo bisogno del\ntuo aiuto.", spanish="[CS:N]Celebi[CR]...[K] Necesito tu ayuda\nde nuevo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_serebii, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" I know.", french=" Je sais.", german=" Ich weiß.", italian=" Lo so.", spanish=" Lo sé."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="Seeing you back here, my dear\n[CS:N]Grovyle[CR], tells me everything I need to know.", french="Ton retour ici suffit à me\nmettre la puce à l'oreille, mon cher [CS:N]Massko[CR].", german="Dich hier zu sehen, mein lieber\n[CS:N]Reptain[CR], verrät mir alles, was ich wissen\nmuss.", italian="Vederti tornare qui, mio caro\n[CS:N]Grovyle[CR], mi dice già tutto quello che\nho bisogno di sapere.", spanish="Verte aquí, mi querido [CS:N]Grovyle[CR],\nme dice todo lo que necesito saber."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="You're back because you failed\nin your mission in the past, yes?", french="Tu es revenu parce que tu n'as\npas pu remplir ta mission dans le passé,\nn'est-ce pas?", german="Du bist zurückgekommen, weil\ndeine Mission in der Vergangenheit gescheitert\nist, ja?", italian="Sei tornato perché la tua\nmissione nel passato è fallita, vero?", spanish="Has vuelto porque tu misión\nen el pasado fracasó, ¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "sweatdrop", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Urk...[K] Yes, it's true.", french=" Euh...[K] Oui, c'est vrai.", german=" Uff...[K] Ja, das stimmt.", italian=" Uh...[K] Sì, è vero.", spanish=" Hum...[K] Sí, es cierto."})
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="I hope you manage this time.[K]\nI've quite had enough of this.", french="J'espère que tu réussiras\ncette fois-ci.[K] J'en ai assez de tout ça.", german="Ich hoffe, dass du es dieses Mal\nschaffst.[K] Ich habe langsam genug hiervon.", italian="Spero che questa volta ce la\nfarai.[K] Ne ho abbastanza di questa storia.", spanish="Ojalá esta vez salga mejor.[K]\nYa estoy cansada de todo esto."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="Living in this dark and dreary\nworld is so depressing.", french="C'est si déprimant de vivre dans\nce monde obscur et sinistre.", german="In dieser dunklen und trostlosen\nWelt zu leben, ist ziemlich deprimierend.", italian="Vivere in questo mondo\noscuro e monotono è davvero deprimente.", spanish="Vivir en un mundo tan oscuro y\nsiniestro es deprimente."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Sorry, no time to chat...", french="Désolé, pas le temps de\nbavarder...", german="Tut mir leid, keine Zeit für\nSchwätzchen...", italian="Perdonami, non c'è tempo per\nle parole...", spanish="Lo siento pero no hay tiempo\npara charlas."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" The [CS:N]Sableye[CR] are tracking us.", french="Les [CS:N]Ténéfix[CR] sont\nà nos trousses.", german=" Die [CS:N]Zobiris[CR] verfolgen uns.", italian="I [CS:N]Sableye[CR] ci stanno alle\ncostole.", spanish=" Los [CS:N]Sableye[CR] nos están siguiendo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="If we don't leave soon, we'll\nhave brought trouble to you.", french="Si on ne repart pas très vite,\non va les mettre sur ta piste.", german="Wenn wir nicht bald gehen,\nhandeln wir dir Ärger ein.", italian="Se non ce ne andiamo in fretta,\nti creeremo solo problemi.", spanish="Si no nos vamos enseguida, te\nmeteremos en un buen lío."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="Tee-hee![K] It's quite fine. There\nis no need to be worried.", french="Hi hi![K] Tout va bien, ne t'inquiète\npas pour moi.", german="Hihi![K] Nicht weiter tragisch. Kein\nGrund zur Beunruhigung.", italian="Eeh-eeh![K] Va bene così. Non\nc'è bisogno di preoccuparsi.", spanish="¡Ji, ji![K] No pasa nada.\nNo hay de qué preocuparse."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="Let those [CS:N]Sableye[CR] come. They're\nof no concern to me.", french="Qu'ils viennent, ces [CS:N]Ténéfix[CR]!\nIls ne me font pas peur.", german="Lass diese [CS:N]Zobiris[CR] nur kommen.\nDarüber mache ich mir keine Gedanken.", italian="Lascia che questi [CS:N]Sableye[CR]\nvengano. Non mi preoccupano per nulla.", spanish="Que vengan esos [CS:N]Sableye[CR]...\nNo me preocupan lo más mínimo."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="Besides, if you would be so kind\nas to prevent the planet's paralysis...", french="Par ailleurs, si tu pouvais faire\nen sorte que la planète ne soit pas paralysée...", german="Wenn ihr dann so nett wärt, die\nLähmung des Planeten aufzuhalten...", italian="Inoltre, se vorrete essere così\ngentili da prevenire la paralisi del pianeta...", spanish="Si lograras evitar la parálisis\ndel planeta..."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="We'll finally be spared the agony\nof this world of darkness.", french="Ça nous épargnerait les\nsouffrances de ce monde envahi par\nl'ombre.", german="Das würde uns das Elend dieser\nWelt der Dunkelheit ersparen.", italian="... finalmente potrete\nrisparmiarci l'agonia di questo mondo\ndi oscurità.", spanish="Escaparíamos, por fin, de\nla angustia de este mundo de oscuridad."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="My dear [CS:N]Grovyle[CR], I will devote\nmy whole life to achieve that end!", french="Mon cher [CS:N]Massko[CR], je serais\nprête à donner ma vie pour que cela n'arrive\npas!", german="Mein lieber [CS:N]Reptain[CR], diesem Ziel\nwerde ich mein ganzes Leben widmen!", italian="Mio caro [CS:N]Grovyle[CR], darei la mia\nvita per raggiungere quest'obiettivo!", spanish="Mi querido [CS:N]Grovyle[CR],\n¡daría mi vida por cumplir ese objetivo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="All right...[K] Where is the Passage\nof Time?", french="D'accord, d'accord...[K] Où est\nle Couloir du Temps?", german="Alles klar...[K] Wo ist der\nZeittunnel?", italian="Va bene...[K] Dov'è il Portale del\nTempo?", spanish="Muy bien...[K]\n¿Dónde está el Pasaje del Tiempo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" It's ready.[K] It is nearby.", french="Tout près d'ici.[K] Et il est prêt\nà vous accueillir.", german="Der steht bereit.[K] Er ist hier in\nder Nähe.", italian=" È pronto.[K] È qui vicino.", spanish="Ya está listo.[K]\nNo está muy lejos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_serebii, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="The Passage of Time is on a\nplateau above this forest.", french="Le Couloir du Temps se trouve\nsur un plateau qui surplombe cette forêt.", german="Der Zeittunnel liegt auf einer\nHochebene über diesem Wald.", italian="Il Portale del Tempo è su un\naltopiano oltre questa foresta.", spanish="Está en una especie de explanada\nque asoma al bosque."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" That's good.[K] Can you guide us?", french=" Parfait.[K] Tu peux nous guider?", german="Das ist gut.[K] Kannst du uns dort\nhinführen?", italian=" Va bene.[K] Ci puoi guidare?", spanish=" Estupendo.[K] ¿Puedes guiarnos?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_serebii, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Yes!", french=" Oui!", german=" Ja!", italian=" Sì!", spanish=" Sí, cómo no."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="Are all three of you taking the\nPassage of Time?", french="Vous allez emprunter le Couloir\ndu Temps tous les trois?", german="Wollt ihr alle drei den Zeittunnel\nverwenden?", italian="Userete tutti e tre il Portale del\nTempo?", spanish="¿Vais a cruzar el Pasaje del\nTiempo los tres?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Yeah. That's right.", french=" Ouais, c'est exact.", german=" Ja. So ist es.", italian=" Sì. È così.", spanish=" Sí, así es."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_serebii, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Oh?! What's...[K]this? Your friend!", french="Oh?! Qu'est-ce que...[K] Qui est-ce?\nCe Pokémon, il fait partie de vos amis?", german="Oh?!? Was ist...[K] das?\nDein Freund!", italian="Oh?! Che...[K] cosa?!\nQuel Pokémon...", spanish="¿Eh? ¿Qué...?[K]\n¿Cómo es posible? ¡Tu acompañante!"})
  pcall(function() SOUND:FadeOutBGM(180) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, hero, 4) end)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What...?[K] What...?)", french="(Quoi...?[K] Quoi...?)", german="(Was?[K] Was...)", italian="(Cosa...?[K] Cosa...?)", spanish="(¿Quién?[K] ¿Yo?)"})
  else
  SkySceneKit.say({english="(What...?[K] What...?)", french="(Quoi...?[K] Quoi...?)", german="(Was?[K] Was...)", italian="(Cosa...?[K] Cosa...?)", spanish="(¿Quién?[K] ¿Yo?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" ........................", french=" ........................", german=" ........................", italian=" ........................", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" No...[K] That can't be...", french=" Non...[K] C'est impossible...", german=" Nein...[K] Das kann nicht sein...", italian=" No...[K] Non può essere...", spanish=" No...[K] No puede ser..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, npc_npc_serebii, 4) end)
  GAME:WaitFrames(45)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, hero, 4) end)
  GAME:WaitFrames(45)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, npc_npc_serebii, 4) end)
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Is something the matter, [CS:N]Celebi[CR]?", french=" Il y a un problème, [CS:N]Celebi[CR]?", german=" Stimmt irgendwas nicht, [CS:N]Celebi[CR]?", italian=" Qual è il problema, [CS:N]Celebi[CR]?", spanish=" ¿Algún problema, [CS:N]Celebi[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_serebii, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_serebii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" No...[K] It's nothing.", french=" Non...[K] ce n'est rien.", german=" Nein...[K] Es ist nichts.", italian=" No...[K] Non è niente.", spanish=" No...[K] No pasa nada."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_serebii, Direction.DownLeft)
  GAME:WaitFrames(60)
  GROUND:EntTurn(npc_npc_serebii, Direction.DownRight)
  GAME:WaitFrames(60)
  GROUND:EntTurn(npc_npc_serebii, Direction.Down)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="Well then.[K] Shall we? Off to the\nPassage of Time.", french="Bon.[K] Si vous voulez bien me\nsuivre... En route pour le Couloir du Temps.", german="Nun denn.[K] Wollen wir? Auf zum\nZeittunnel!", italian="Bene allora.[K] Andiamo? Verso il\nPortale del Tempo!", spanish="Sigamos, entonces.[K]\nSi os parece, es hora de adentrarnos en\nel Pasaje del Tiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_serebii.Position; GROUND:MoveToPosition(npc_npc_serebii, p.X+(0), p.Y+(-160), false, 2) end
  GAME:WaitFrames(10)
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(0), p.Y+(-160), false, 2) end
  GAME:WaitFrames(15)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-160), false, 2) end
  GAME:WaitFrames(5)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-160), false, 2) end
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(80)
  SkySceneKit.cleanup_npcs()
end
