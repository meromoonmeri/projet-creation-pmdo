-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D21P41A/m18b0902.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 160, 240, Direction.Right, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end) -- message_SetActor(ACTOR_NPC_JUPUTORU)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I've gone quite deep.[K] There's not\nmuch farther now.", french="Ça fait un bon moment que\nj'avance.[K] Le fond ne doit plus être loin.", german="Ich bin schon ziemlich weit.[K]\nJetzt bin ich bald da.", italian="Ho fatto un bel po' di strada.[K]\nNon dovrebbe mancare molto ormai.", spanish="Llevo mucho camino andado.[K]\nNo puede quedar mucho ya."})
  -- message_Close
  -- back_SetGround(LEVEL_D21P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_juputoru, 288, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" If I get through here...", french=" Si j'arrive à sortir d'ici...", german=" Wenn ich hier durchkomme...", italian=" Dovrei passare per di qui.", spanish=" Si paso por aquí..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" I should be at the forest.", french="... je devrais arriver\ndirectement dans la forêt.", german=" Dann müsste ich im Wald sein.", italian="In questo modo mi ritroverò\ndi sicuro nella foresta.", spanish=" Podré llegar al bosque."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="The [CS:N]Sableye[CR] are coming.[K]\nThere's no time to waste.", french="Les [CS:N]Ténéfix[CR] approchent.[K]\nIl n'y a pas une seconde à perdre.", german="Die [CS:N]Zobiris[CR] kommen.[K]\nIch darf keine Zeit verlieren.", italian="Stanno arrivando i [CS:N]Sableye[CR].[K]\nNon c'è tempo da perdere.", spanish="Los [CS:N]Sableye[CR] me persiguen.[K]\nNo hay tiempo que perder."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That reminds me...[K] I wonder\nhow those two are doing?", french="Tiens, au fait...[K] je me demande\noù en sont les deux autres.", german="Da fällt mir ein...[K]\nWie es wohl den anderen beiden geht?", italian="A proposito...[K] Chissà come\nse la stanno cavando quei due Pokémon...", spanish="Por cierto...[K] Me pregunto cómo\nle habrá ido a esa pareja..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Have they eluded the [CS:N]Sableye[CR]?", french="Le duo a-t-il réussi à semer\nles [CS:N]Ténéfix[CR]?", german="Ob sie den [CS:N]Zobiris[CR] entwischt\nsind?", italian=" Avranno evitato i [CS:N]Sableye[CR]?", spanish="¿Habrán logrado escapar de\nlos [CS:N]Sableye[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Oh, forget it. This isn't the time!", french="Oh, peu importe! Le moment est\nmal choisi!", german="Wie auch immer. Dafür ist jetzt\nkeine Zeit!", italian="Oh, non ci devo pensare. Non è il\nmomento!", spanish="Será mejor que me olvide.\nNo es momento para pensar en eso."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I have to give priority to my\nown mission no matter what!", french="Ma mission doit passer avant\ntout le reste!", german="Ich muss mich auf meine eigene\nMission konzentrieren, egal was kommt!", italian="Devo dare ad ogni costo la\npriorità alla mia missione!", spanish="¡Mi misión tiene prioridad sobre\ncualquier otra cosa!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I vowed to complete it even if\nit means making sacrifices!", french="J'ai juré de l'accomplir, quels\nqu'en soient les sacrifices!", german="Ich habe geschworen, sie zu\nEnde zu führen, selbst wenn ich dazu Opfer\nbringen muss!", italian="Ho promesso di portarla a\ntermine anche a costo di fare dei\nsacrifici!", spanish="¡Prometí llevarla a cabo\nindependientemente de los sacrificios\nque tuviera que hacer!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Time to go.", french=" C'est le moment de partir.", german=" Zeit zu gehen.", italian=" È ora di andare.", spanish=" Tengo que irme."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_juputoru, 324, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" You there! STOP!", french=" Toi là-bas! HALTE!", german=" Du da! STOPP!", italian=" Ehi tu! FERMATI!", spanish=" ¡TÚ! ¡DETENTE!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Hmm?", french=" Hum?", german=" Hmm?", italian=" Mmm?", spanish=" ¿Eh?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Who's there?!", french=" Qui va là?!", german=" Wer ist da?!?", italian=" Chi c'è?!", spanish=" ¡¿Quién está ahí?!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_KeyWait
  -- GAP: BGM BGM_PLANETS_PARALYSIS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" You INVADE this place with no warning!", french=" Tu PROFANES cet endroit sans crier gare!", german=" Du DRINGST ohne Vorwarnung hier EIN!", italian="Hai INVASO questo posto senza chiederci\nil permesso!", spanish="¡Primero invades este lugar sin previo\naviso!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Then you DISTURB our slumber!", french=" Et en plus, tu PERTURBES notre sommeil!", german=" Dann STÖRST du unseren Schlaf!", italian=" Hai DISTURBATO il nostro sonno!", spanish=" ¡Después perturbas nuestro sueño!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Then, without APOLOGY, you try to leave?", french="Et pour couronner le tout, tu tentes\nde t'enfuir, SANS MEME T'EXCUSER?", german="Dann willst du ohne ein Wort der\nENTSCHULDIGUNG gehen?", italian=" Ora, senza SCUSARTI, provi ad andartene?", spanish=" Y luego, ¿tratas de irte sin disculparte?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Who's there?![K] Who are you?!", french=" Qui va là?![K] Qui êtes-vous?!", german=" Wer ist da?!?[K] Wer seid ihr?!?", italian=" Chi è là?![K] Chi siete?!", spanish="¡¿Quiénes sois?![K]\n¡¿Dónde estáis?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" You DARE to anger us!", french=" Tu OSES nous mettre en colère!", german=" Du WAGST es, uns zu erzürnen!", italian=" Come OSI indispettirci!", spanish=" ¡Cómo osas contrariarnos!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We expect you to PAY for these insults!", french=" Tu vas PAYER pour cet affront!", german=" Für diese Beleidigung wirst du ZAHLEN!", italian=" PAGHERAI per questi affronti!", spanish=" ¡Tendrás que pagar por estos insultos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Where are you?![K] Quit hiding and\nreveal yourself!", french="Où êtes-vous?![K] Sortez de votre\ncachette et montrez-vous!", german="Wo seid ihr?!?[K] Hört auf, euch\nzu verstecken, und zeigt euch!", italian="Dove siete?![K] Smettete di\nnascondervi e fatevi vedere!!", spanish="¡¿Dónde estáis?![K] ¡Dejad de\nesconderos y salid donde os vea!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" You ACCUSE us of hiding?", french=" Tu INSINUES que nous nous cachons?", german=" Du BEHAUPTEST, wir verstecken uns? ", italian=" Ci ACCUSI di nasconderci?", spanish=" ¿Te atreves a acusarnos de escondernos?"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We do NOT hide.", french=" Nous ne nous cachons PAS.", german=" Wir verstecken uns NICHT.", italian=" Noi NON siamo nascosti.", spanish=" Nosotros no nos escondemos."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We are...[K] We are HERE!", french=" Nous sommes...[K] nous sommes ICI!", german=" Wir sind...[K] HIER!", italian=" Noi siamo...[K] Noi siamo QUI!", spanish=" Estamos...[K] ¡aquí mismo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6925) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 15)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We are [CS:N]SPIRITOMB[CR]!", french=" Nous sommes [CS:N]SPIRITOMB[CR]!", german=" Wir sind [CS:N]KRYPPUK[CR]!", italian=" Noi siamo [CS:N]SPIRITOMB[CR]!", spanish=" ¡Somos los [CS:N]Spiritomb[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_mikaruge = SkySceneKit.spawn_npc("spiritomb", 328, 200, Direction.Down, "NPC_MIKARUGE")
  pcall(function() UI:SetSpeaker(npc_npc_mikaruge) end)
  SkySceneKit.say({english="There is NO MERCY for those\nwho transgress against us!", french="PAS DE QUARTIER pour\nles intrus!", german="Es gibt KEINE GNADE für jene,\ndie uns missachten!", italian="Chi trasgredisce le nostre regole\nnon merita NESSUNA PIETÀ!", spanish="¡NO HAY PIEDAD PARA QUIENES\nNOS OFENDEN!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7425) — id SE NDS sans portage PMDO identifié
  pcall(function() SOUND:FadeOutBGM(160) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Gaaaah!", french=" Gaaaah!", german=" Gaaaah!", italian=" Aaaaah!", spanish=" ¡Aaaaah!"})
  GAME:WaitFrames(15)
  GAME:FadeOut(false,  90)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitBgm
  -- main_EnterDungeon(30, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
