-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D32P14A/s04p1902.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM BGM_EARTHQUAKE2 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- bgm2_PlayFadeIn(BGM_EARTHQUAKE3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back_SetGround(LEVEL_D32P14A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 424, 176, Direction.Left, "NPC_CHAAREMU")
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_mimiroppu = SkySceneKit.spawn_npc("lopunny", 472, 176, Direction.Left, "NPC_MIMIROPPU")
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 496, 208, Direction.Left, "NPC_SAANAITO")
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_chaaremu, 316, 172, false, 2)
  GROUND:MoveToPosition(npc_npc_mimiroppu, 220, 172, false, 2)
  GROUND:MoveToPosition(npc_npc_saanaito, 204, 204, false, 2)
  GROUND:MoveToPosition(hero, 244, 188, false, 2)
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 268, 176, false, 2) end end
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 276, 204, false, 2) end end
  GAME:WaitFrames(10)
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 300, 188, false, 2) end end
  pcall(function() SOUND:FadeOutBGM(210) end)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeIn(30)
  GROUND:MoveToPosition(npc_npc_chaaremu, 188, 172, false, 2)
  pcall(function() GAME:MoveCamera(236, 196, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_saanaito, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_chaaremu, Direction.DownRight)
  GROUND:EntTurn(npc_npc_mimiroppu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Is everyone all right?", french="Est-ce que tout le monde va\nbien?", german=" Seid ihr alle in Ordnung?", italian=" State bene?", spanish=" ¿Está todo el mundo bien?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Seems that way.\nEveryone's here.", french=" On dirait. Tout le monde est là.", german=" Sieht so aus. Alle sind hier.", italian="Sembra di sì. Non manca nessuno\nall'appello.", spanish=" Eso parece."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Thank goodness...", french=" Quel soulagement...", german=" Ein Glück...", italian=" Meno male...", spanish=" Menos mal..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_mimiroppu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(4, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" ...[K]But the treasures...", french=" Mais...[K] les trésors...", german=" ...[K]Aber die Schätze...", italian=" ...[K] Ma i tesori...", spanish=" Pero...[K] Pero los tesoros..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_saanaito, Direction.Right)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Right)
  GROUND:EntTurn(hero, Direction.Right)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Right) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Right) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:EntTurn(__slot, Direction.Right) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Yes... Quite disheartening...", french=" Oui... c'est plutôt démoralisant...", german=" Ja. Sehr entmutigend...", italian=" Già... Che delusione...", spanish=" Sí... qué decepción..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Oh!", french=" Oh!", german=" Oh!", italian=" Oh!", spanish=" ¡Oh!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "exclaim", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Look at that!", french=" Regardez ça!", german=" Seht mal!", italian=" Date un'occhiata!", spanish=" ¡Mirad eso!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_mimiroppu, Direction.Up)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.Up)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V28P01A) [décor sub chargé: Sub_v28p01a]
  -- camera2_SetPositionMark(Position<'m9', 18.5, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v28p01a", 60, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  pcall(function() SOUND:PlayBGM("Hidden Land.ogg", true) end)
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "exclaim", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(4, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" Oh![K] That's...!", french=" Oh![K] C'est...!", german=" Oh![K] Das ist...", italian=" Oh![K] È...!", spanish=" ¡Oh![K] ¡Es...!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="The ground heaved up! And a gap\nopened in the face of the cliff!", french="Le sol s'est soulevé! Et une\nfaille s'est ouverte dans la falaise!", german="Der Boden hat sich gehoben! Und\nes hat sich ein Spalt in der Klippe aufgetan!", italian="Il suolo si è sollevato! E si è\naperto un passaggio sulla facciata del dirupo!", spanish="¡El suelo se mueve!\n¡Se ha abierto un agujero en el acantilado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" That tremor earlier...", french=" Cette secousse tout à l'heure...", german=" Diese Erschütterungen vorhin...", italian=" Quella scossa di prima...", spanish=" El temblor de antes..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="What [CS:N]Regigigas[CR] and the others\nwere protecting...[K] This must have been it!", french="[CS:N]Regigigas[CR] et les autres\nprotégeaient quelque chose...[K] C'était\nsûrement ça!", german="Was [CS:N]Regigigas[CR] und die anderen\nbeschützt haben...[K] Es muss das hier gewesen\nsein!", italian="Ecco cosa [CS:N]Regigigas[CR] e gli altri\nstavano proteggendo...[K] Dev'essere così!", spanish="Lo que estaban protegiendo\n[CS:N]Regigigas[CR] y los demás...[K]\n¡Debe de ser esto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="I get it now! That's where they\nhid the treasures! And they're undisturbed!", french="J'ai compris! C'est là qu'ils\ncachaient les trésors! Et ils sont intacts!", german="Jetzt wird mir alles klar! Hier\nhaben sie die Schätze versteckt! Und sie\nsind noch unberührt!", italian="Adesso capisco! È lì che hanno\nnascosto i tesori! E sono indisturbati!", spanish="¡Ahora lo entiendo! ¡Aquí\nescondían los tesoros! ¡Y están intactos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  -- message_FacePositionOffset(4, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="Wonderful![K] This exploration\nturned out to be a huge success after all!", french="Magnifique![K] Cette exploration\ns'avère être un succès en fin de compte!", german="Wunderbar![K] Diese Erkundung\nist doch noch ein Erfolg geworden!", italian="Fantastico![K] Alla fine questa\nesplorazione si è rivelata un grande successo!", spanish="¡Estupendo![K] ¡Esta expedición\nha resultado todo un éxito!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Ha ha! Yeah!", french=" Ha ha! Oui!", german=" Ha ha! Ja!", italian=" Ah ah! Già!", spanish=" ¡Ja, ja! ¡Sí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chaaremu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_mimiroppu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "happy", 1) end)
  GROUND:EntTurn(hero, Direction.Left)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Left) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Left) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:EntTurn(__slot, Direction.Left) end end
  GAME:WaitFrames(90)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(30)
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="But the credit doesn't belong to\nus this time.", french="Mais cette fois, le mérite\nne nous en revient pas.", german="Aber das ist diesmal nicht unser\nVerdienst.", italian="Ma questa volta il merito non è\nnostro.", spanish="Aunque el mérito no ha sido\nnuestro esta vez..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_saanaito, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_mimiroppu, Direction.DownRight)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Team [team:].[K] The credit\nbelongs entirely to you.", french="Chère Equipe [team:],[K]\nc'est à vous que revient le mérite de cette\ndécouverte.", german="Team [team:].[K] Das war\nganz allein euer Verdienst.", italian="Team [team:],[K] il merito\nè tutto vostro.", spanish="[CS:X]Equipo[CR] [team:]...[K]\nHa sido gracias a vuestro empeño."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="I'd say it does![K] The treasures in\nthere, all of it belongs to you!", french="Et comment![K] Les trésors\nlà-dedans vous appartiennent en totalité!", german="Das würde ich auch sagen![K]\nDie Schätze da drinnen gehören alle euch!", italian="Proprio così![K] Quei tesori sono\ntutti vostri!", spanish="¡Y tanto![K] ¡Todos esos tesoros\nos pertenecen!"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="My word, weren't you\nsomething special!", french="Ma parole, si j'avais pensé que\nvous étiez aussi extraordinaires!", german="Meine Güte, ihr seid wirklich\nwas Besonderes!", italian="Devo proprio ammettere che\nsiete una squadra grandiosa!", spanish=" ¡Ha sido algo muy especial!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="It was like seeing [CS:N]Wigglytuff[CR]\nin action in the old days!", french="J'ai eu l'impression de voir\n[CS:N]Grodoudou[CR] en action, comme au bon vieux\ntemps!", german="Das war wie [CS:N]Knuddeluff[CR]\nzu seinen besten Zeiten!", italian="Mi è sembrato di rivedere\n[CS:N]Wigglytuff[CR] in azione, come ai vecchi tempi!", spanish="Casi como ver a [CS:N]Wigglytuff[CR]\nen acción en los viejos tiempos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "happy", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "happy", 1) end) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "happy", 1) end) end end
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HA HA HA!", french="[CS:N]Tous[CR]: HA HA HA!", german="[CS:N]Alle[CR]: HA HA HA!", italian="[CS:N]Tutti[CR]: AH AH AH!", spanish="[CS:N]Todos[CR]: ¡JA, JA, JA!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, nil, 0) end) -- EFFECT_NONE end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, nil, 0) end) -- EFFECT_NONE end end
  do local __slot = SkySceneKit.team_member(3); if __slot then pcall(function() GROUND:CharSetEmote(__slot, nil, 0) end) -- EFFECT_NONE end end
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="So, shall we go on to our next\nadventure, old friends?", french="Alors, prêtes à embarquer pour\nde nouvelles aventures, mes amies?", german="Sollen wir dann unser nächstes\nAbenteuer angehen, meine alten Freunde?", italian="Allora, cosa ne dite di partire\nper la prossima avventura?", spanish="Bueno, ¿continuamos?\n¡A por la próxima aventura!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_mimiroppu, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(4, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" Yes, let's do that!", french=" Oui, en route!", german=" Ja, machen wir das!", italian=" Sì, ci sto!", spanish=" Sí, ¡a por ella!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_saanaito, Direction.Right)
  GROUND:EntTurn(npc_npc_mimiroppu, Direction.DownRight)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(4, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="We enjoyed ourselves very\nmuch, Team [team:]. It was fun\nexploring with you!", french="Nous nous sommes bien amusées\nau cours de cette exploration à vos côtés,\nchère Equipe [team:]!", german="Wir haben sehr viel Spaß\ngehabt, Team [team:]. Es war toll, mit\neuch auf Erkundung zu gehen!", italian="Ci siamo divertite un mondo,\nTeam [team:]. È stato bello esplorare\ncon voi!", spanish="Lo hemos pasado muy bien,\n[CS:X]Equipo[CR] [team:]. ¡Ha sido muy\ndivertido explorar en vuestra compañía!"})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="If we keep up our explorations,\nwe may run into each other someday.", french="Il se pourrait que nos chemins\nse croisent à nouveau lors d'une prochaine\nexploration.", german="Wenn wir das Erkunden nicht\nan den Nagel hängen, werden wir uns eines\nTages bestimmt wieder über den Weg laufen.", italian="Se continuiamo a esplorare,\npotremmo incontrarci di nuovo, in futuro.", spanish="Tal vez algún día volvamos a\nencontrarnos."})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="But next time, we'll beat you to\nthe treasure!", french="Mais la prochaine fois,\nnous obtiendrons le trésor, aucun doute\nlà-dessus!", german="Aber das nächste Mal sind wir\nschneller beim Schatz als ihr!", italian="Ma la prossima volta,\narriveremo noi per prime al tesoro!", spanish="¡Pero, la próxima vez, nosotras\nencontraremos el tesoro!"})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="Take care! Send our love to\n[CS:N]Wigglytuff[CR]!", french="Prenez soin de vous! Faites\nnos amitiés à notre cher [CS:N]Grodoudou[CR]!", german="Macht es gut! Grüßt uns\n[CS:N]Knuddeluff[CR] recht herzlich!", italian="In bocca al lupo! Date un\nbacio da parte nostra a [CS:N]Wigglytuff[CR]!", spanish="¡Cuidaos mucho!\n¡Y dadle recuerdos a [CS:N]Wigglytuff[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_mimiroppu.Position; GROUND:MoveToPosition(npc_npc_mimiroppu, p.X+(-120), p.Y+(0), false, 2) end
  do local p=npc_npc_saanaito.Position; GROUND:MoveToPosition(npc_npc_saanaito, p.X+(-120), p.Y+(0), false, 2) end
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(-120), p.Y+(0), false, 2) end
  GAME:WaitFrames(60)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(30)
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(71) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetArrow(71) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  -- worldmap_BlinkMark(71) [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayFanfare("Fanfare/NewArea") end) -- me_Play(6) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="[CN]You can now go to\n[CN]the [CS:P]Concealed Ruins[CR]!", french="[CN]Désormais, vous pouvez accéder\n[CN]aux [CS:P]Ruines Cachées[CR]!", german="[CN]Du kannst jetzt zu\n[CN]den [CS:P]Verborgenen Ruinen[CR] gehen!", italian="[CN]Adesso potete andare\n[CN]alle [CS:P]Rovine Nascoste[CR]!", spanish="[CN]¡Ahora puedes ir\n[CN]a las [CS:P]Ruinas Camufladas[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[70] = 3 -- dungeon_mode(70) = DMODE_OPEN_AND_REQUEST (ROM)
  SkyProg.set(29, 67) -- $SCENARIO_MAIN = scn[29,67] (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.REQUEST_CLEAR_COUNT = 0 -- $REQUEST_CLEAR_COUNT = 0 (ROM)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
