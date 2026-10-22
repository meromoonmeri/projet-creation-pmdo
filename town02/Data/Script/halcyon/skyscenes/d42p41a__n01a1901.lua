-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D42P41A/n01a1901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=40, sub=5} -- $SCENARIO_SIDE = scn[40,5] (ROM)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(125, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D42P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 252, 276, false, 2)
  local npc_npc_yukikaburi = SkySceneKit.spawn_npc("snover", 256, 408, Direction.Up, "NPC_YUKIKABURI")
  GROUND:MoveToPosition(npc_npc_yukikaburi, 252, 308, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(252, 188, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 252, 196, false, 2)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...Huh?[K] This...[K]\nThis looks like a dead end.", french="... Hein?[K] C'est...[K]\nÇa ressemble à un cul-de-sac.", german="...Nanu![K] Das...[K] Das sieht wie\neine Sackgasse aus.", italian="Uh?[K] Questo...[K] sembra un vicolo\ncieco.", spanish="¿Eh?[K] Parece...[K]\nParece que no hay salida."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="This looks like the deepest\npart...[K] The depths of [CS:P]Star Cave[CR]...", french="On dirait qu'on est dans l'fond\ndu fond...[K] Les entrailles de la [CS:P]Caverne Etoile[CR]...", german="Anscheinend ist das der tiefste\nTeil...[K] Die Tiefen der [CS:P]Sternenhöhle[CR]...", italian="Ha tutta l'aria di essere\nla parte più remota...[K] Le profondità\ndella [CS:P]Caverna Stellata[CR]...", spanish="Parece el lugar más profundo...[K]\nLas profundidades de la [CS:P]Cueva Estrella[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Where's [CS:N]Jirachi[CR]?", french=" Et [CS:N]Jirachi[CR], où il est?", german=" Wo steckt [CS:N]Jirachi[CR]?", italian=" Dov'è [CS:N]Jirachi[CR]?", spanish=" ¿Dónde está [CS:N]Jirachi[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Heh-heh!", french=" Hé hé!", german=" Hehe!", italian=" Ih ih!", spanish=" ¡Jie, jie!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Heh-heh-heh-heh-heh!", french=" Hé hé hé hé hé hé hé!", german=" Hehehehehe!", italian=" Ih ih ih ih ih!", spanish=" ¡Jie, jie, jie, jie, jie!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(4), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Wh-who's there?!", french=" Qui... qui est là?!", german=" W-wer ist da?!?", italian=" Chi è là?!", spanish=" ¡¿Qui... quién anda ahí?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Gwah-ha-ha-ha-ha-ha-ha!", french=" Ouarf arf arf arf arf!", german=" Gwahahahahaha!", italian=" Muah ah ah ah ah!", spanish=" ¡Jua, ja, ja, ja, ja, ja, ja!"})
  -- message_Close
  pcall(function() SOUND:PlayBGM("Growing Anxiety.ogg", true) end)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Wh-who...[K]is that?!", french=" Qui...[K] qui c'est, ça?!", german=" W-wer...[K] ist das?!?", italian=" C-Chi...[K] c'è?!", spanish=" ¡¿Qui... quién...[K] está ahí?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Heh-heh-heh![K] You are really so gullible!", french="Hé hé hé![K]\nQu'est-ce que tu peux être crédule!", german="Hehehe![K]\nDu bist wirklich so leichtgläubig!", italian=" Ih ih ih![K] Sei davvero un credulone!", spanish=" ¡Jie, jie, jie![K] ¡Eres de lo más ingenuo!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" To come trustingly all the way here!", french="Venir jusqu'ici sans te méfier\nle moins du monde!", german="Den ganzen Weg voller Vertrauen\nhier herunterzukommen!", italian="Bersi tutte quelle frottole\ne venire fin qui!", spanish=" Mira que venir hasta aquí sin desconfiar..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7443) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  local npc_npc_tatsubei = SkySceneKit.spawn_npc("bagon", 232, 64, Direction.Down, "NPC_TATSUBEI")
  -- ResetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  local npc_npc_guraigaa = SkySceneKit.spawn_npc("gligar", 280, 32, Direction.Down, "NPC_GURAIGAA")
  -- ResetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(npc_npc_tatsubei, 228, 164, false, 2)
  GROUND:MoveToPosition(npc_npc_guraigaa, 276, 164, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(8), 4, false) end) -- MovePositionOffset performer/caméra
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="H-huhhh?!\nWh-who are you?!", french="Heiiin?!\nVous... vous êtes qui?!", german="W-was?!?\nW-was soll das?!?", italian="Uuuh?!\nC-Chi siete voi?!", spanish="¡¿Quéeee?!\n¡¿Qui... quién habla?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_tatsubei) end)
  SkySceneKit.say({english=" Heh-heh-heh![K] Long time no see!", french=" Hé hé hé![K] Ça fait un bail!", german=" Hehehe![K] Lange nicht gesehen!", italian=" Ih ih ih![K] Ne è passato di tempo!", spanish=" ¡Jie, jie, jie![K] ¡Cuánto tiempo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_guraigaa) end)
  SkySceneKit.say({english="Haven't seen you since we met\nat Treasure Town! Gwah-ha-ha!", french="On s'est plus vus depuis notre\ndernière rencontre à Bourg-Trésor!\nOuarf arf arf!", german="Um genau zu sein, seit unserem\nTreffen in Schatzstadt nicht mehr! Gwahaha!", italian="Non ci vediamo dal nostro\nbreve incontro a Borgo Tesoro!\nMuah ah ah!", spanish="No nos veíamos desde que nos\nconocimos en Aldea Tesoro. ¡Jua, ja, ja!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Wh-what...[K]are you doing here?!", french="Que...[K]\nQu'est-ce qu'vous faites ici?!", german=" W-was...[K] macht ihr denn hier?!?", italian=" C-Cosa...[K] ci fate voi qui?!", spanish=" ¡¿Pero... qué...[K] hacéis aquí?!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]Jirachi[CR]'s place in [CS:P]Star Cave[CR] is...", french="Normalement, la [CS:P]Caverne Etoile[CR]\noù vit [CS:N]Jirachi[CR], c'est...", german="Der Ort, an dem [CS:N]Jirachi[CR] in der\n[CS:P]Sternenhöhle[CR] leben soll, ist also...", italian=" La [CS:P]Caverna Stellata[CR] e [CS:N]Jirachi[CR]...", spanish="La guarida de [CS:N]Jirachi[CR] de la\n[CS:P]Cueva Estrella[CR]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I thought me and [CS:N]Snover[CR]\nwere the only ones who had the map and knew\nhow to get here...", french="J'pensais qu'[CS:N]Blizzi[CR] et moi,\non était les seuls à posséder la carte\nindiquant l'emplacement d'cet endroit...", german="Ich dachte, [CS:N]Shnebedeck[CR] und ich\nseien die Einzigen, die mithilfe der Karte\nwussten, wie man hierhergelangen kann...", italian="Pensavo che solo io e [CS:N]Snover[CR]\navessimo la mappa e fossimo a conoscenza\ndi questo posto...", spanish="Pensaba que [CS:N]Snover[CR] y yo éramos\nlos únicos que teníamos el mapa y sabíamos\nllegar hasta aquí..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Wh-why are you...[K]\nWhy are you here?", french="Pou-pourquoi vous...[K]\nPourquoi vous êtes là?", german="W-warum seid ihr...[K]\nWarum seid ihr dann hier?", italian="P-Perché voi...[K]\nPerché siete qui?", spanish="Por... Por qué estáis...[K]\n¿Por qué estáis aquí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end) -- message_SetActor(ACTOR_NPC_YUKIKABURI)
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" Humph![K] [CS:N]Jirachi[CR] was never here.", french="Humph![K] Il n'y a jamais eu de\n[CS:N]Jirachi[CR], ici.", german="Hmpf![K] [CS:N]Jirachi[CR] hat es hier\nnie gegeben.", italian="Bah![K] [CS:N]Jirachi[CR] non è mai\nesistito.", spanish=" ¡Ja![K] [CS:N]Jirachi[CR] nunca ha estado aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:TeleportTo(npc_npc_yukikaburi, 252, 308, Direction.Down)
  pcall(function() GAME:MoveCamera(252, 296, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Whaaaat?!", french=" Quoiiii?!", german=" Waaaas?!?", italian=" Cooosaaa?!", spanish=" ¡¿Quéeee?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  pcall(function() GAME:MoveCamera(252, 228, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_yukikaburi, 252, 244, false, 2)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="[CS:P]Star Cave[CR], [CS:N]Jirachi[CR], they were\nall made up.", french="La [CS:P]Caverne Etoile[CR], [CS:N]Jirachi[CR],\ntout ça, ça a été monté de toutes pièces.", german="Die [CS:P]Sternenhöhle[CR], [CS:N]Jirachi[CR], das\nist alles nur erfunden.", italian="La [CS:P]Caverna Stellata[CR], [CS:N]Jirachi[CR]...\nSono tutte invenzioni.", spanish="La historia de la [CS:P]Cueva Estrella[CR]\ny [CS:N]Jirachi[CR]... Es todo una patraña."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="They never were here from the\nstart.[K] That's what I'm saying.", french="Rien de tout ça n'a jamais\nexisté.[K] Point barre.", german="Hat es alles nie gegeben.[K]\nDas kannst du mir glauben.", italian="Non sono mai esistiti.[K]\nLo capisci adesso?", spanish="Ese Pokémon nunca ha estado\nen este sitio.[K] Entérate de una vez."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_tatsubei) end)
  SkySceneKit.say({english="You were tricked into coming\nhere...[K]by us...[K]you see...", french="On t'a attiré ici...[K] nous...[K]\nTu piges...?", german="Du wurdest hereingelegt, damit\ndu hierherkommst...[K] Von uns...[K] Verstehst du?", italian="Ti abbiamo attirato qui con\nl'inganno...[K] siamo stati noi...", spanish="Te engañamos para que vinieras\naquí...[K] Es todo cosa nuestra...[K] Ya ves..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Wh-whaaaa?![K]\n...U-us? What do you mean, \"us\"?!", french="QUOIIII?![K]\n... N-nous? Mais c'est qui, ça, \"nous\"?!", german="W-waaaas?!?[K] ...U-uns?\nWas meinst du damit, [F:S2]von uns[F:E2]?!?", italian="C-Cooosaaa?![K] ... N-Noi? Che\ncosa intendete con \"noi\"?!", spanish="¡¿Quéee?![K] ¿Qué quieres decir?...\n¡¿Qué es cosa vuestra?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_tatsubei) end)
  SkySceneKit.say({english="We're the band of thieves,\nTeam [CS:X]Rogue[CR]!", french="On est l'Equipe [CS:X]Canailles[CR],\nla bande de voleurs!", german="Wir sind eine Räuberbande! Man\nkennt uns als Team [CS:X]Schlingel[CR]!", italian="Siamo il Team [CS:X]Canaglia[CR],\nla banda di ladri!", spanish="Somos una banda de ladrones,\nel [CS:X]Equipo Canalla[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_guraigaa) end)
  SkySceneKit.say({english="We trick our marks and take\nwhat we want...", french="On embobine notre proie et on\nla dépouille comme ça nous chante...", german="Wir legen andere herein und\nnehmen uns dann, was wir wollen...", italian="Inganniamo la gente\nper prenderci quello che vogliamo...", spanish="Engañamos a nuestras víctimas\ny luego las desplumamos..."})
  pcall(function() UI:SetSpeaker(npc_npc_guraigaa) end)
  SkySceneKit.say({english="We're thieves! We're rogues!\nDo you get it yet? We're the bad guys!\nGwah-ha-ha-ha-ha!", french="On est des voleurs!\nOn est des canailles! Tu commences à capter?\nOn est les méchants! Ouarf arf arf arf!", german="Wir sind Diebe! Üble Lümmel!\nVerstehst du jetzt? Wir sind die Bösewichte!\nGwahahahaha!", italian="Siamo ladri! Siamo canaglie!\nL'hai capita adesso? Siamo i cattivi!\nMuah ah ah ah!", spanish="¡Somos ladrones! ¡Canallas!\n¿Lo pillas ya? ¡Somos los malos!\n¡Jua, ja, ja, ja, ja!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" And I am their leader...", french=" Et le meneur, c'est moi...", german=" Und ich bin der Anführer...", italian=" E io sono il loro leader...", spanish=" Y yo soy el líder..."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" The great [CS:N]Snover[CR]!", french=" Le grand [CS:N]Blizzi[CR]!", german=" Der großartige [CS:N]Shnebedeck[CR]!", italian=" Il grande [CS:N]Snover[CR]!", spanish=" ¡El gran [CS:N]Snover[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-4), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Eeeeeeeek!", french=" Aaaarrrrgh!", german=" Ieeeeeeek!", italian=" Aaaaaaaah!", spanish=" ¡Nooooo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" That time...", french=" L'autre fois...", german=" Neulich...", italian=" Quella volta...", spanish=" Aquel día..."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="When you were standing in front\nof [CS:K]Kecleon[CR]'s shop, stewing...", french="... quand tu étais en train de\nte morfondre devant le [CS:K]Marché Kecleon[CR]...", german="Als du vor dem [CS:K]Kecleon-Laden[CR]\nstandest, in Selbstmitleid versunken...", italian="Quando ti trovavi davanti\nal [CS:K]Kecleon[CR] Market a rimuginare...", spanish="Cuando estabas comiéndote el\ncoco en la [CS:K]Tienda Kecleon[CR]..."})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
