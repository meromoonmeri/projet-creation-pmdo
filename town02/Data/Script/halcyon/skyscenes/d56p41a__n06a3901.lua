-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D56P41A/n06a3901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D56P41A) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(228, 308, 1, false) end) -- SetPositionMark performer/caméra
  -- SetAnimation(10) [anim idle native]
  -- bgm2_PlayFadeIn(BGM_CAVE_AMBIANCE) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GAME:WaitFrames(10)
  local npc_npc_manyuura = SkySceneKit.spawn_npc("weavile", 232, 320, Direction.Up, "NPC_MANYUURA")
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(9)
  local npc_npc_dorapion = SkySceneKit.spawn_npc("drapion", 264, 320, Direction.Up, "NPC_DORAPION")
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(9)
  local npc_npc_aabokku = SkySceneKit.spawn_npc("arbok", 192, 328, Direction.Up, "NPC_AABOKKU")
  -- SetAnimation(22) [anim idle native]
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english=" Ssssoooghh...", french=" Au sssecouuuurs...", german=" Oooouuuuuh...", italian=" Sssooorgh...", spanish=" Gluuuupsss..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english=" B-blast...", french=" Bon sang de bonsoir...", german=" V-verflixt...", italian=" N-Nooo...", spanish=" Ca... caramba..."})
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english=" They're...[K] Pretty strong...", french=" Elles sont...[K] redoutables...", german=" Sie sind...[K] Ganz schön stark...", italian=" Sono...[K] davvero forti...", spanish=" Son...[K] fuertecillas..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" Guh...[K] You did pretty well...", french="Argh...[K] Vous ne vous en êtes\npas mal sorties...", german="Uff...[K]\nDas habt ihr überraschend gut gemacht...", italian=" Guh...[K] Ve la siete cavata bene...", spanish=" Uf...[K] No habéis estado mal..."})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" But...[K] Don't underestimate us!", french="Mais...[K] ne nous sous-estimez\npas!", german=" Aber...[K] Unterschätzt uns nicht!", italian=" Ma...[K] non sottovalutateci!", spanish=" Pero...[K] ¡no nos subestiméis!"})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="Team [CS:X]AWD[CR]'s true power...[K]\nThis isn't all of it!", french="Vous n'avez pas encore vu...[K]\ntoute l'étendue des pouvoirs de l'Equipe [CS:X]DDA[CR]!", german="Die wirkliche Kraft von Team\n[CS:X]SPA[CR]...[K] Die habt ihr noch nicht zu spüren\nbekommen!", italian="Non avete ancora visto...[K] il vero\npotere del Team [CS:X]AWD[CR]!", spanish="Todo el peso del [CS:X]Equipo WAD[CR]...[K]\n¡va a caer sobre vosotras!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" You guys![K] Let's go!", french=" Hé, les gars![K] Allons-y!", german=" Okay, Kollegen![K] Auf geht's!", italian=" Forza ragazzi![K] Addosso!", spanish=" ¡Venga![K] ¡Vamos a por ellas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(15)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(3)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, "happy", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="[CS:N]Arbok[CR] & [CS:N]Drapion[CR]: YEAH!", french="[CS:N]Arbok[CR] & [CS:N]Drascore[CR]: OUAIS!", german="[CS:N]Arbok[CR] und [CS:N]Piondragi[CR]: JUCHHU!", italian="[CS:N]Arbok[CR] e [CS:N]Drapion[CR]: SÌ!", spanish="[CS:N]Arbok[CR] y [CS:N]Drapion[CR]: ¡Eso!"})
  GAME:WaitFrames(18)
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, nil, 0) end) -- EFFECT_NONE
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(24) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:N]Gardevoir[CR]! [CS:N]Medicham[CR]![K]\nHere it comes! Be careful!", french="[CS:N]Gardevoir[CR]! [CS:N]Charmina[CR]![K]\nPréparez-vous!", german="[CS:N]Guardevoir[CR]! [CS:N]Meditalis[CR]![K]\nDa kommen sie! Aufgepasst!", italian="[CS:N]Gardevoir[CR]! [CS:N]Medicham[CR]![K]\nArrivano! Fate attenzione!", spanish="¡[CS:N]Gardevoir[CR], [CS:N]Medicham[CR]![K]\n¡Tened cuidado, que vienen!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 264, 256, Direction.Down, "NPC_SAANAITO")
  -- SetAnimation(27) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Let's take care of it!", french=" On s'en occupe!", german=" Wir kümmern uns darum!", italian=" Facciamogliela vedere!", spanish=" ¡Vamos a ocuparnos de esto!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 200, 256, Direction.Down, "NPC_CHAAREMU")
  -- SetAnimation(24) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Let's beat them at their\nown game!", french="On va les battre à leur propre\njeu!", german="Wir schlagen sie mit ihren\neigenen Waffen!", italian="Dimostriamogli chi è\nil più forte!", spanish=" ¡Esta vez sí que se van a enterar!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="[CS:N]Arbok[CR] & [CS:N]Drapion[CR]: Woooooaaaahh!!", french="[CS:N]Arbok[CR] & [CS:N]Drascore[CR]: Ouaaaaaaaaaah!!", german="[CS:N]Arbok[CR] und [CS:N]Piondragi[CR]: Boooooaaaah!!!", italian="[CS:N]Arbok[CR] e [CS:N]Drapion[CR]: Uooooooaaahhh!!", spanish="[CS:N]Arbok[CR] y [CS:N]Drapion[CR]: ¡¡Uaaaaaah!!"})
  do local p=npc_npc_manyuura.Position; GROUND:MoveToPosition(npc_npc_manyuura, p.X+(0), p.Y+(-14), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(12), false, 2) end
  do local p=npc_npc_dorapion.Position; GROUND:MoveToPosition(npc_npc_dorapion, p.X+(0), p.Y+(-14), false, 2) end
  do local p=npc_npc_saanaito.Position; GROUND:MoveToPosition(npc_npc_saanaito, p.X+(0), p.Y+(12), false, 2) end
  do local p=npc_npc_aabokku.Position; GROUND:MoveToPosition(npc_npc_aabokku, p.X+(0), p.Y+(-14), false, 2) end
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(0), p.Y+(12), false, 2) end
  -- message_CloseEnforce
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(true, 5) -- screen_WhiteOut
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(11)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(11)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" YOOM...TAH!", french=" TA-DAAAAAAA!", german=" LUUUU... FIIII!", italian=" BADABUM!", spanish=" ¡Aaaalto!"})
  -- message_Close
  -- GAP: se_Play(7180) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 232, 264, Direction.Down, "NPC_PUKURIN")
  -- ResetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  -- SetOutputAttribute(2) [neutre/état moteur]
  GAME:FadeIn(5)
  GAME:WaitFrames(1)
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(28), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-14), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "exclaim", 1) end)
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(0), p.Y+(-14), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, "exclaim", 1) end)
  do local p=npc_npc_dorapion.Position; GROUND:MoveToPosition(npc_npc_dorapion, p.X+(0), p.Y+(14), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "shock", 1) end)
  do local p=npc_npc_saanaito.Position; GROUND:MoveToPosition(npc_npc_saanaito, p.X+(0), p.Y+(-14), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_manyuura, "shock", 1) end)
  do local p=npc_npc_manyuura.Position; GROUND:MoveToPosition(npc_npc_manyuura, p.X+(0), p.Y+(14), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, "shock", 1) end)
  do local p=npc_npc_aabokku.Position; GROUND:MoveToPosition(npc_npc_aabokku, p.X+(0), p.Y+(14), false, 2) end -- SlidePositionOffset
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dorapion, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_aabokku, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english=" Wh-what?![K] Who are you?!", french=" Quoi?![K] Qui es-tu, au juste?!", german=" W-wasss?!?[K] Wer bissst du?!?", italian=" C-Cosa?![K] E tu chi sei?!", spanish=" ¡¿Qué?![K] ¡¿Y tú quién eresss?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]W[CR]-[CS:N]Wigglytuff[CR]?!", french=" [CS:N]G[CR]-[CS:N]Grodoudou[CR]?!", german=" [CS:N]K-Knuddeluff[CR]?!?", italian=" [CS:N]W-Wigglytuff[CR]?!", spanish=" ¡¿[CS:N]Wi[CR]... [CS:N]Wigglytuff[CR]?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_PlayFadeIn(BGM_CAVE_AMBIANCE) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="This is [CS:N]Wigglytuff[CR]?[K]\nTh-this guy?!", french=" C'est [CS:N]Grodoudou[CR]?[K] Lui?!", german="Das ist [CS:N]Knuddeluff[CR]?[K]\nDieser Typ?!?", italian="Questo è [CS:N]Wigglytuff[CR]?[K]\nQ-Questo tizio?!", spanish="¿Este es [CS:N]Wigglytuff[CR]?[K]\n¡¿Es... esta bolita?!"})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="In recent years he's made quite\na name for himself, despite how young he is...", french="Malgré son jeune âge, il s'est\nfait un nom, ces dernières années...", german="Er hat sich die letzten Jahre\nüber einen guten Namen erarbeitet, obwohl er\nnoch so jung ist...", italian="Negli ultimi anni si è costruito\nuna certa reputazione nonostante la\ngiovane età...", spanish="En los últimos años se ha forjado\nun nombre a pesar de su juventud..."})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="The exploration prodigy...[K] That\n[CS:N]Wigglytuff[CR]?! This is him?!", french="On l'appelle le surdoué de\nl'exploration...[K] Alors, c'est lui, [CS:N]Grodoudou[CR]?!", german="Das Erkunder-Naturtalent...[K] Der\nberühmte [CS:N]Knuddeluff[CR]?!? So sieht er also\naus?!?", italian="Il genio dell'esplorazione...[K]\nQuel [CS:N]Wigglytuff[CR]?! È lui?!", spanish="El prodigio de la exploración...[K]\n¡¿Ese [CS:N]Wigglytuff[CR]?! ¡¿Es este?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Everyone wait a moment![K]\nBoth of you, please stop fighting!", french="Attendez un moment![K]\nArrêtez de vous battre!", german="Alle mal herhören![K]\nBeide Teams! Hört bitte auf zu kämpfen!", italian="Fermi tutti![K] Per favore,\nsmettetela di lottare!", spanish="¡Esperad todos un momento![K]\n¡Dejad de luchar un momento, por favor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Wh-why should we stop?\n[CS:N]Wigglytuff[CR]?!", french=" En quel honneur, [CS:N]Grodoudou[CR]?!", german="W-warum sollten wir aufhören?\n[CS:N]Knuddeluff[CR]?!?", italian="P-Perché mai dovremmo\nsmetterla, [CS:N]Wigglytuff[CR]?!", spanish="¡¿Por... Por qué íbamos a parar,\n[CS:N]Wigglytuff[CR]?!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" They're bad guys, you know?!", french=" Ce sont des bandits, tu sais?!", german="Sie sind hier die Bösewichte,\nweißt du?!?", italian="Quelli sono dei tipacci,\nnon lo sai?!", spanish="Son mala gente, por si\nno lo sabías."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="That may be true...[K]but fighting\nisn't good. ♪", french="Peut-être...[K] mais la violence\nne mène à rien. ♪", german="Das mag stimmen...[K]\nAber Kämpfen ist nicht gut. ♪", italian="Può darsi che sia così...[K] ma\nlottare non va mai bene. ♪", spanish="Puede que tengas razón...[K] Pero\nno está bien pelearse. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Besides...", french=" De plus...", german=" Und ganz nebenbei...", italian=" Inoltre...", spanish=" Además..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(24)
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(24)
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(24)
  GROUND:EntTurn(npc_npc_pukurin, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(24)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(24)
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You...[K]you got caught in the trap\nto bring you to battle.", french="On...[K] on vous a tendu un piège,\npour que vous vous battiez!", german="Ihr...[K] Ihr seid in die Falle\ngetappt und der Verlockung des Kampfes\nerlegen.", italian="Voi...[K] siete caduti tutti in\nuna trappola. Questo scontro è stato\narchitettato a vostra insaputa.", spanish="Habéis...[K] Habéis caído en la\ntrampa. Este combate ya estaba preparado."})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, "exclaim", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "exclaim", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_manyuura, "shock", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "shock", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" Wh-what did you say?!", french="Qu'est-ce que c'est que\ncette histoire?!", german=" W-was hast du da gesagt?!?", italian=" C-Cosa hai detto?!", spanish=" ¡¿Pe... pero qué dices?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" This fight...", french=" Ce combat...", german=" Dieser Kampf...", italian=" Lo scontro...", spanish=" Que este combate..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Was planned?!", french=" ... était prévu?!", german=" Er war geplant?!?", italian="... è stato architettato\na nostra insaputa?!", spanish=" ¡¿Estaba planeado?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Yes.[K] This fight was set up...", french=" Oui.[K] Monté de toutes pièces...", german=" Ja.[K] Dieser Kampf war geplant...", italian=" Esatto.[K] È proprio così...", spanish=" Sí.[K] Este combate era una trampa..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Th-that's...", french=" C'est...", german=" D-das ist doch...", italian=" M-Ma come...", spanish=" Pe... pero eso es..."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Who did?!", french=" Qui s'est servi de nous?!", german=" Wer steckt dahinter?!?", italian=" Chi è stato?!", spanish=" ¡¿Quién ha sido?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="The one who planned it...[K]is the\nboss who lives in this limestone cave.", french="Le Pokémon qui a mis au point\nce scénario...[K] c'est le boss qui habite cette\ncaverne.", german="Der, der sich das ausgedacht hat,[K]\nist der Boss dieser Kalksteinhöhle.", italian="Il responsabile di tutto questo...[K]\nè il boss che vive in questa caverna calcarea.", spanish="Quien lo planeó...[K] es el jefe\nque habita en esta caverna de caliza."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I don't know why he did it...[K]\nBut...", french="Ses motivations me sont\ninconnues...[K] Mais...", german="Warum er das tat...[K] Das weiß\nich auch nicht.", italian="Non so perché l'abbia fatto...[K]\nma...", spanish="No estoy seguro de por qué...[K]\nPero..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="He wanted Team [CS:X]Charm[CR] and\nTeam [CS:X]AWD[CR] to knock each other out...", french="... il voulait que les Equipes\n[CS:X]Charme[CR] et [CS:X]DDA[CR] s'entre-déchirent...", german="Aber er wollte, dass\nTeam [CS:X]Charme[CR] und Team [CS:X]SPA[CR] sich gegenseitig\nausschalten...", italian="Voleva che il Team [CS:X]Malia[CR] e il\nTeam [CS:X]AWD[CR] si sconfiggessero a vicenda...", spanish="Quería que el [CS:X]Equipo Carisma[CR] y el\n[CS:X]Equipo WAD[CR] se quitaran de en medio entre sí..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="And by making you all focus on\nthe battle...", french="En vous occupant avec\nle combat...", german="Und aus der Tatsache, dass er\neuch mit dem Kampf ablenken wollte, kann man\nnoch etwas schließen...", italian="E spingendovi a concentrarvi\nsulla lotta...", spanish="Y al hacer que os centrarais\nen el combate..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I think someone is going\nto great lengths to hide something.", french="... je pense qu'il espérait\ndétourner votre attention et vous cacher\nquelque chose à tout prix.", german="Und zwar, dass er etwas zu\nverbergen hat.", italian="... ha cercato in tutti i modi\ndi nascondere qualcosa.", spanish="Creo que alguien se está tomando\nmuchas molestias para ocultar algo."})
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="He probably...[K]just wanted\nto protect the treasure, I think.", french="Selon toute probabilité...[K]\nil voulait juste protéger le trésor.", german="Vielleicht wollte er...[K]\nDen Schatz auch nur behüten.", italian="Forse...[K] voleva solo proteggere\nil tesoro, credo.", spanish="Probablemente...[K] solo pretendía\nproteger el tesoro, diría yo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" This treasure...", french=" Le trésor...", german=" Diesen Schatz...", italian=" Questo tesoro...", spanish=" El tesoro..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" Just protect it?", french=" Le protéger?", german=" Ihn behüten?", italian=" Proteggerlo?", spanish=" ¿Solo quería protegerlo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_manyuura, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Yep.[K] But...", french=" Ouaip.[K] Mais...", german=" Genau.[K] Aber...", italian=" Già.[K] Però...", spanish=" Sí.[K] Pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="What I've said so far...[K]\nEverything is only a guess.", french=" Tout ceci reste...[K] une hypothèse.", german="Alles was bis hierhin gesagt\nwurde...[K] Das sind nur Vermutungen.", italian="Tutto ciò che ho detto finora...[K]\nè solo un'ipotesi.", spanish="Lo que acabo de decir...[K]\nes solo una suposición."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="That's why you won't know\nthe truth...[K]unless you ask. ♪", french="Vous n'aurez jamais la réponse\nà tout ça...[K] si vous ne posez pas\nla question. ♪", german="Deswegen werdet ihr die\nWahrheit nicht erfahren...[K] Ihr müsst schon\nfragen. ♪", italian="Non sapremo mai la verità...[K]\na meno che non lo chiediamo direttamente\na lui. ♪", spanish="No podréis saber la verdad...[K]\na menos que preguntéis. ♪"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_pukurin, 228, 256, false, 2)
  pcall(function() GAME:MoveCamera(228, 148, 60, false) end) -- performer/caméra
  -- ResetOutputAttribute(2) [neutre/état moteur]
  GROUND:MoveToPosition(hero, 260, 272, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_pukurin, 228, 164, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-32), p.Y+(0), false, 2) end
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Up)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Up)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_aabokku, Direction.Up)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_dorapion, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(6)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Right. ♪", french=" Eh oui. ♪", german=" So sieht das aus. ♪", italian=" Bene. ♪", spanish=" Eso es. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="What I said...[K]you were\nlistening, weren't you?", french="Tu as écouté tout ce que j'ai dit,\nn'est-ce pas?", german="Du hast mir auch aufmerksam\nzugehört,[K] nicht wahr?", italian="Quello che ho detto...[K] Mi stavi\nascoltando, non è vero?", spanish="Lo que acabo de decir...[K] lo\nhas escuchado, ¿verdad?"})
  -- message_Close
  pcall(function() GAME:MoveCamera(228, 308, 60, false) end) -- performer/caméra
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, "shock", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "exclaim", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_manyuura, "shock", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" [CS:N]W[CR]-[CS:N]Wigglytuff[CR]?!", french=" [CS:N]G[CR]-[CS:N]Grodoudou[CR]?!", german=" [CS:N]K-Knuddeluff[CR]?!?", italian=" [CS:N]W-Wigglytuff[CR]?!", spanish=" ¡¿[CS:N]Wi[CR]... [CS:N]Wigglytuff[CR]?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Is [CS:N]Wigglytuff[CR] talking to the\ntreasure chest?!", french="Je rêve ou [CS:N]Grodoudou[CR] s'adresse\nau coffre au trésor?!", german="Hat [CS:N]Knuddeluff[CR] etwa gerade mit\nder Schatztruhe gesprochen?!?", italian="[CS:N]Wigglytuff[CR] sta parlando\nal forziere!", spanish="¡¿[CS:N]Wigglytuff[CR] le está hablando\nal cofre?!"})
  -- message_Close
  pcall(function() GAME:MoveCamera(228, 148, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Hey, was that the truth?[K]\nTell me. ♪", french="Alors, c'est quoi la vérité?[K]\nDis-le-moi, ne sois pas timide. ♪", german="Hey, sind meine Vermutungen\nrichtig?[K] Nun sag schon. ♪", italian="Ehi, è così che sono andate\nle cose?[K] Dai, dimmelo. ♪", spanish="Oye, ¿me equivoco o no?[K]\nDímelo. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Treasure Chest[CR]: .....................................", french="[CS:N]Coffre au trésor[CR]: .....................................", german="[CS:N]Schatztruhe[CR]: .....................................", italian="[CS:N]Forziere[CR]: .....................................", spanish="[CS:N]Cofre[CR]: ..."})
  -- message_Close
  -- GAP: se_Play(10255) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(3) [anim idle native]
  GAME:WaitFrames(60)
  pcall(function() GAME:MoveCamera(228, 308, 60, false) end) -- performer/caméra
  pcall(function() GROUND:CharSetEmote(npc_npc_manyuura, "shock", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, "exclaim", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "exclaim", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english=" Whaat?![K] The treasure chest!", french=" Quoi?![K] Le coffre!", german=" Waaas?!?[K] Die Schatztruhe!", italian=" Eeeh?![K] Il forziere!", spanish=" ¡¿Quéee?![K] ¡El cofre!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english=" It's shaking and rattling!", french="Il tremble et fait un bruit\nbizarre!", german="Sssie wackelt und\nrasssssselt?!?", italian="Si sta muovendo da una parte\nall'altra!", spanish=" ¡Essstá vibrando y agitándossse!"})
  -- message_Close
  pcall(function() GAME:MoveCamera(228, 160, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_saanaito, 256, 116, false, 2)
  GAME:WaitFrames(3)
  GROUND:MoveToPosition(npc_npc_chaaremu, 200, 116, false, 2)
  GAME:WaitFrames(9)
  GROUND:MoveToPosition(hero, 228, 244, false, 2)
  GAME:WaitFrames(6)
  GROUND:MoveToPosition(npc_npc_manyuura, 192, 252, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_manyuura, 192, 140, false, 2)
  GROUND:MoveToPosition(npc_npc_aabokku, 200, 168, false, 2)
  GAME:WaitFrames(7)
  GROUND:MoveToPosition(npc_npc_dorapion, 260, 168, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_saanaito, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_chaaremu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_manyuura, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_aabokku, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dorapion, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- se_FadeOut(10255, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(30)
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(20) [anim idle native]
  GAME:WaitFrames(20)
  -- GAP: se_Play(10256) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(130)
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:WaitFrames(45)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(3) [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aabokku, "shock", 1) end)
  do local p=npc_npc_aabokku.Position; GROUND:MoveToPosition(npc_npc_aabokku, p.X+(-4), p.Y+(4), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "shock", 1) end)
  do local p=npc_npc_saanaito.Position; GROUND:MoveToPosition(npc_npc_saanaito, p.X+(4), p.Y+(-4), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_manyuura, "exclaim", 1) end)
  do local p=npc_npc_manyuura.Position; GROUND:MoveToPosition(npc_npc_manyuura, p.X+(-4), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(-4), p.Y+(-4), false, 2) end -- SlidePositionOffset
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(4), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_dorapion, "shock", 1) end)
  do local p=npc_npc_dorapion.Position; GROUND:MoveToPosition(npc_npc_dorapion, p.X+(4), p.Y+(4), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english=" What the...?!", french=" Qu'est-ce que c'est que ça?!", german=" Ist das etwa...", italian=" Ma cosa...?!", spanish=" ¡¿Pero qué...?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Is that...[K]a Pokémon?!", french=" Serait-ce...[K] un Pokémon?!", german=" Ist es ein...[K] Pokémon?!?", italian=" È...[K] un Pokémon?!", spanish=" Es...[K] ¡¿un Pokémon?!"})
  -- message_Close
  local npc_npc_metamon = SkySceneKit.spawn_npc("ditto", 232, 136, Direction.Down, "NPC_METAMON")
  pcall(function() UI:SetSpeaker(npc_npc_metamon) end)
  SkySceneKit.say({english=" .........", french=" .........", german=" .........", italian=" .........", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="His name is [CS:N]Ditto[CR]...[K] He's a\nPokémon who can use the move [CS:M]Transform[CR]...", french="Je vous présente [CS:N]Métamorph[CR]...[K]\nC'est un Pokémon qui peut utiliser la capacité\n[CS:M]Morphing[CR]...", german="Sein Name ist [CS:N]Ditto[CR].[K]\nEs beherrscht die Attacke [CS:M]Wandler[CR].", italian="Il suo nome è [CS:N]Ditto[CR]...[K] È\nun Pokémon in grado di usare la mossa\n[CS:M]Trasformazione[CR]...", spanish="Se llama [CS:N]Ditto[CR]...[K] Es un Pokémon\nque puede usar el movimiento [CS:M]Transform.[CR]\na placer..."})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_ILLUSION_STONE_CHAMBER non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" [CS:M]T[CR]-[CS:M]Transform[CR]?!", french=" [CS:M]M[CR]-[CS:M]Morphing[CR]?!", german=" [CS:M]W-Wandler[CR]?!?", italian=" [CS:M]T-Trasformazione[CR]?!", spanish=" ¡¿[CS:M]Tra[CR]... [CS:M]Transform.[CR]?!"})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="So, you used [CS:M]Transform[CR] to\nturn into a treasure chest?", french="Ainsi, tu as utilisé [CS:M]Morphing[CR]\npour te transformer en coffre au trésor?", german="Also hast du [CS:M]Wandler[CR]\nverwendet, um eine Schatztruhe zu werden?", italian="Quindi hai usato [CS:M]Trasformazione[CR]\nper tramutarti in un forziere?", spanish="¿Entonces has usado el\nmovimiento [CS:M]Transform.[CR] para convertirte\nen un cofre?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_metamon, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_metamon) end)
  SkySceneKit.say({english=" ...Treasure chest...[K] Yes...", french=" ... Exact...[K] En coffre au trésor...", german=" ...Schatztruhe...[K] Genau...", italian=" ... Un forziere...[K] Sì...", spanish=" En un cofre.[K] Eso es..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="When my food was stolen in\n[CS:P]Southern Jungle[CR]...", french="Quand on m'a volé toutes mes\nprovisions dans la [CS:P]Jungle Méridionale[CR]...", german="Als mir mein Essen im\n[CS:P]Süddschungel[CR] gestohlen wurde...", italian="Quando mi hanno rubato il cibo\nnella [CS:P]Giungla Meridionale[CR]...", spanish="Cuando me robaron la comida en\nla [CS:P]Selva Meridional[CR]..."})
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_metamon, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" That was you, wasn't it?", french=" C'était toi, n'est-ce pas?", german=" Das warst du, nicht wahr?", italian=" Sei stato tu, vero?", spanish=" Fuiste tú, ¿no es así?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_metamon) end)
  SkySceneKit.say({english="...Wasn't it...? Yeah...[K]\nThat's right...", french="... Moi...? Oui...[K]\nC'était moi...", german="...Nicht wahr? Doch...[K]\nSchon...", italian=" Vero...? Sì...[K] È così...", spanish=" Pues...[K] Sí, has acertado..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon) end)
  SkySceneKit.say({english=" I did that...[K] I'm really sorry...", french="Je suis coupable...[K]\nEt je te présente mes excuses...", german="Ich war das...[K]\nTut mir echt leid...", italian="Sono stato io...[K] Mi dispiace\ntanto...", spanish=" Fui yo...[K] Lo siento mucho..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon) end)
  SkySceneKit.say({english=" And...", french=" Et...", german=" Und...", italian=" E...", spanish=" Y..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_metamon, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_metamon, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_metamon, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_metamon) end)
  SkySceneKit.say({english=" Team [CS:X]Charm[CR]...", french=" Equipe [CS:X]Charme[CR]...", german=" Team [CS:X]Charme[CR]...", italian=" Team [CS:X]Malia[CR]...", spanish=" [CS:X]Equipo Carisma[CR]..."})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(4)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(4)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_metamon) end)
  SkySceneKit.say({english="I deceived you many times,\nTeam [CS:X]Charm[CR]...[K] I'm sorry.", french="Je vous ai dupées maintes fois,\nEquipe [CS:X]Charme[CR]...[K] Désolé.", german="Ich habe euch viele Male\ngetäuscht, Team [CS:X]Charme[CR]...[K] Das tut mir leid.", italian="Vi ho ingannate molte volte,\nTeam [CS:X]Malia[CR]...[K] Scusatemi.", spanish="Os he engañado muchas veces,\n[CS:X]Equipo Carisma[CR]...[K] Lo siento."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Huh?[K] Deceived?", french=" Hein?[K] Dupées?", german=" Was?[K] Getäuscht?", italian=" Uh?[K] Ingannate?", spanish=" ¿Eh?[K] ¿Que nos has engañado?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Deceived...", french=" Dupées...", german=" Getäuscht...", italian=" Ingannate...", spanish=" Nos has engañado..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_metamon) end)
  SkySceneKit.say({english="...Deceived... As you saw...[K]\nI have the power to use the move\n[CS:M]Transform[CR]...", french="... Oui, dupées... Comme vous\nle voyez...[K] je peux utiliser la capacité\n[CS:M]Morphing[CR]...", german="...Getäuscht... Wie ihr sehen\nkonntet...[K] Ich habe die Macht, die Attacke\n[CS:M]Wandler[CR] zu verwenden...", italian="Ingannate... Come avete visto...[K]\nho il potere di usare la mossa\n[CS:M]Trasformazione[CR]...", spanish="Sí, eso es... Como habéis visto...[K]\nPuedo usar el movimiento [CS:M]Transform.[CR]\ncuando quiero..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon) end)
  SkySceneKit.say({english="I was a treasure chest earlier,\nbut that's not all...", french="Tout à l'heure, je m'étais\ntransformé en coffre au trésor, mais\nce n'est pas tout...", german="Ich war eine Schatztruhe,\naber das ist noch nicht alles...", italian="Prima ero un forziere, ma\nla mia abilità non si esaurisce qui...", spanish="Hace un momento era un cofre,\npero eso no es todo..."})
  pcall(function() UI:SetSpeaker(npc_npc_metamon) end)
  SkySceneKit.say({english="I can also...[K][CS:M]Transform[CR]\ninto Pokémon...", french="Je peux aussi utiliser [CS:M]Morphing[CR][K]\npour prendre l'apparence d'autres Pokémon...", german="Ich kann...[K] [CS:M]Wandler[CR] auch\nverwenden, um wie andere Pokémon\nauszusehen...", italian="Posso anche...[K] trasformarmi\nin un altro Pokémon...", spanish="También puedo...[K] usar el movimiento\n[CS:M]Transform.[CR] para convertirme\nen otros Pokémon..."})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...![K] I-is that true?!", french=" ...![K] Sérieusement?!", german=" Wow![K] Wirklich?!?", italian=" ...![K] S-Sul serio?!", spanish=" ¡¿Qué...?![K] Es... ¡¿Es eso cierto?!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Don't tell me. Back then?!", french=" Ne me dis pas que c'était toi...", german=" Sag bloß, an der Stelle...", italian=" Non mi dire. Quella volta...", spanish="No me lo digas, creo que ya sé\ncuándo ha sido..."})
  -- message_Close
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
