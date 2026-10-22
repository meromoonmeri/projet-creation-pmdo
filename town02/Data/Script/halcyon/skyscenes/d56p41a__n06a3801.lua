-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D56P41A/n06a3801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(157, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D56P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(10) [anim idle native]
  -- bgm2_PlayFadeIn(BGM_CAVE_AMBIANCE) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 256, 424, Direction.Up, "NPC_SAANAITO")
  GROUND:MoveToPosition(npc_npc_saanaito, 256, 284, false, 2)
  GAME:WaitFrames(15)
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 200, 424, Direction.Up, "NPC_CHAAREMU")
  GROUND:MoveToPosition(npc_npc_chaaremu, 200, 284, false, 2)
  GAME:WaitFrames(24)
  GROUND:MoveToPosition(hero, 228, 304, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(6)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" There's no one here.", french=" Personne.", german=" Niemand da.", italian=" Qui non c'è nessuno.", spanish=" Aquí no hay nadie."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(228, 148, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_saanaito, 256, 136, false, 2)
  GAME:WaitFrames(9)
  GROUND:MoveToPosition(npc_npc_chaaremu, 200, 136, false, 2)
  GAME:WaitFrames(12)
  GROUND:MoveToPosition(hero, 228, 152, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_saanaito, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="...[K]I knew it, the treasure's just\nnot here...", french="...[K] Je le savais. Le trésor\nn'est pas ici...", german="...[K]Wusste ich es doch, der\nSchatz ist einfach nicht hier...", italian="...[K] Lo sapevo, il tesoro\nnon è qui...", spanish="Jo...[K] Lo sabía, el tesoro\nno está aquí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I bet there's some kind of secret\nto it.[K] Let's look.", french="Je parie qu'il y a un secret\nà découvrir.[K] Examinons les environs.", german="Ich wette, dass es da noch eine\nArt Geheimnis gibt.[K] Sehen wir uns das mal an.", italian="Scommetto che c'è un qualche\nmistero da risolvere.[K] Dobbiamo scoprirlo.", spanish="Seguro que encierra algún tipo\nde secreto.[K] Vamos a echar un vistazo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- message_ResetActor() [neutre/état moteur]
  local npc_npc_dorapion = SkySceneKit.spawn_npc("drapion", 264, 376, Direction.Up, "NPC_DORAPION")
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english=" They're here![K] Over there!", french=" Je les vois![K] Là-bas!", german=" Da sind sie wieder![K] Dort drüben!", italian=" Eccole![K] Laggiù!", spanish=" ¡Están aquí![K] ¡Venid!"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "exclaim", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "exclaim", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Down)
  GAME:WaitFrames(3)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  pcall(function() GAME:MoveCamera(228, 212, 60, false) end) -- performer/caméra
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_manyuura = SkySceneKit.spawn_npc("weavile", 232, 352, Direction.Up, "NPC_MANYUURA")
  GROUND:MoveToPosition(npc_npc_manyuura, 228, 224, false, 2)
  GAME:WaitFrames(12)
  GROUND:MoveToPosition(npc_npc_dorapion, 264, 228, false, 2)
  GAME:WaitFrames(12)
  local npc_npc_aabokku = SkySceneKit.spawn_npc("arbok", 192, 376, Direction.Up, "NPC_AABOKKU")
  GROUND:MoveToPosition(npc_npc_aabokku, 192, 232, false, 2)
  GAME:WaitFrames(24)
  GROUND:MoveToPosition(hero, 228, 180, false, 2)
  GAME:WaitFrames(9)
  GROUND:MoveToPosition(npc_npc_saanaito, 256, 172, false, 2)
  GAME:WaitFrames(9)
  GROUND:MoveToPosition(npc_npc_chaaremu, 200, 172, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english="They pretended to run away and\nhid over here insssstead!", french="Elles ont fait sssemblant de fuir\npour courir ssse cacher!", german="Sssie haben ssso getan, alsss\nob sssie sssich verdrückten und haben sssich\nssstatt dessssssen hier versssteckt!", italian="Hanno fatto finta di ssscappare\ne sssi sssono nassscossste da qualche\nparte!", spanish="Han fingido huir y ssse han\nessscondido aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english="But we're not going to fall for\nthat trick!", french="Mais on ne nous la fait pas,\nà nous!", german="Aber auf den Trick fallen wir\nnicht herein!", italian="Ma non cadremo di nuovo\nnello stesso tranello!", spanish="Pues no vamos a caer\nen la trampa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_TEAM_CHARMS_THEME non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hee-hee!", french=" Hi hi!", german=" Hi-hi!", italian=" Ih ih!", spanish=" ¡Ji, ji!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="You're pretty simple\nfellows, huh? [M:H8]", french="Vous êtes du genre simple\nd'esprit, non? [M:H8]", german="Ihr seid doch einfacher\ngestrickt als gedacht, oder? [M:H8]", italian="Siete proprio dei sempliciotti,\neh? [M:H8]", spanish=" Sois bastante simplones, ¿eh? [M:H8]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aabokku) end)
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Wasss-sss?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="You think we seriously\nran away?", french="Vous croyez vraiment qu'on a\npris la fuite?", german="Ihr habt wirklich geglaubt, wir\nseien davongelaufen?", italian="Pensavate davvero che fossimo\nfuggite?", spanish="¿De verdad os habéis creído\nque íbamos a huir?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" We didn't run away!", french=" Erreur!", german=" Wir sind nicht davongelaufen!", italian=" Non è affatto così!", spanish=" ¡No es nuestro estilo!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="We were waiting...[K]for you,\nTeam [CS:X]AWD[CR]!", french="Nous vous attendions...[K]\nEquipe [CS:X]DDA[CR]!", german="Wir warteten...[K] auf euch,\nTeam [CS:X]SPA[CR]!", italian="Stavamo aspettando...[K] proprio\nvoi, Team [CS:X]AWD[CR]!", spanish="Os estábamos esperando...[K]\n¿Qué os pensabais, [CS:X]Equipo WAD[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dorapion) end)
  SkySceneKit.say({english=" What are you saying?!", french=" Qu'est-ce que vous racontez?!", german=" Was sagst du da?!?", italian=" Ma cosa state dicendo?!", spanish=" ¡¿Qué estáis diciendo?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="We absolutely cannot forgive\nscoundrels like you!", french="Nous allons vous donner\nune bonne leçon, infâmes bandits!", german="Schuften wie euch können wir\nauf keinen Fall vergeben!", italian="Non possiamo assolutamente\nperdonare dei tipacci come voi!", spanish="De ningún modo podemos\nperdonar a unos bellacos como vosotros."})
  -- message_Close
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="We're the treasure hunters--\nTeam [CS:X]Charm[CR]!", french="Nous sommes les chasseuses de\ntrésor de l'Equipe [CS:X]Charme[CR]!", german="Wir sind die Schatzjäger\nTeam [CS:X]Charme[CR]!", italian="Noi siamo le cacciatrici\ndi tesori... il Team [CS:X]Malia[CR]!", spanish="Somos buscadoras de tesoros...\n¡El [CS:X]Equipo Carisma[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="You![K] We're going to punish you,\nso get ready!", french="En garde![K] Vous allez recevoir\nla correction que vous méritez!", german="Ihr da![K] Jetzt bekommt ihr\neine Lektion erteilt. Also macht euch bereit!", italian="Attenti a voi![K] Ora ve la faremo\npagare, quindi preparatevi!", spanish="¡Granujas![K] Os vamos a dar\nvuestro merecido. ¡Ya os podéis ir preparando!"})
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Down)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(27) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
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
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" Humph![K] Interesting!", french=" Pfff![K] J'aimerais bien voir ça!", german=" Humpf![K] Interessant!", italian=" Umpf![K] Interessante!", spanish=" ¡Bah![K] Muy gracioso..."})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="We let you run away last time\nwe fought...", french="On vous a laissées vous enfuir,\nla dernière fois...", german="Bei unserem letzten Kampf\nließen wir euch entkommen...", italian="L'ultima volta che ci siamo\nscontrati, siamo stati noi a lasciarvi\nscappare...", spanish="Os dejamos escapar la última\nvez que combatimos..."})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="You're not running away\nthis time!", french="... cette fois-ci, vous ne nous\néchapperez pas!", german="Dieses Mal werdet ihr uns\nnicht davonlaufen!", italian="Ma questa volta non vi andrà\ncosì bene!", spanish="¡Pero esta vez no os lo\npermitiremos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="[CS:N]Arbok[CR]! [CS:N]Drapion[CR]!\nLet's go!", french="[CS:N]Arbok[CR]! [CS:N]Drascore[CR]!\nA l'attaque!", german="[CS:N]Arbok[CR]! [CS:N]Piondragi[CR]!\nLos geht's!", italian="[CS:N]Arbok[CR]! [CS:N]Drapion[CR]!\nAddosso!", spanish="¡[CS:N]Arbok[CR], [CS:N]Drapion[CR]!\n¡A por ellas!"})
  -- message_Close
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
  -- message_Close
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
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="[CS:N]Medicham[CR]! [CS:Y]Lopunny[CR]!\nHere they come!", french="[CS:N]Charmina[CR]! [CS:Y]Lockpin[CR]!\nIls arrivent!", german="[CS:N]Meditalis[CR]! [CS:Y]Schlapor[CR]!\nNehmt euch in Acht, wir werden angegriffen!", italian="[CS:N]Medicham[CR]! [CS:Y]Lopunny[CR]!\nTenetevi pronte!", spanish="¡[CS:N]Medicham[CR], [CS:Y]Lopunny[CR]!\n¡Preparaos, que vienen!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Anytime!", french=" Je les attends de pied ferme!", german=" Allzeit bereit!", italian=" Mettiamocela tutta!", spanish=" ¡Venga!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="OK.\nLet's go! [M:H8]", french=" O.K. C'est parti! [M:H8]", german=" Auf geht's! [M:H8]", italian=" Ok. Andiamo! [M:H8]", spanish=" De acuerdo. ¡Vamos! [M:H8]"})
  -- message_Close
  -- supervision_SpecialActing(24, 0, 0) [cadrage NDS]
  -- supervision_SpecialActing(25, 0, 0) [cadrage NDS]
  -- GAP: se_Play(10249) — id SE NDS sans portage PMDO identifié
  -- supervision_SpecialActing(26, 0, 0) [cadrage NDS]
  GAME:WaitFrames(120)
  GAME:FadeOut(true, 30) -- screen_WhiteOutAll
  -- supervision_SpecialActing(3, 0, 0) [cadrage NDS]
  -- main_EnterDungeon(157, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  SkySceneKit.cleanup_npcs()
end
