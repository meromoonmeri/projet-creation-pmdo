-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99A/um1202.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 176, 136, Direction.Left, "NPC_DAGUTORIO")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dagutorio, 4) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Gwah![K] Gwargh![K] Gwagagah!", french="Gwah![K] Gwaaaah![K]\nGwaaaaahgaaaaah!", german=" Gwah![K] Gwargh![K] Gwagagah!", italian=" Uh![K] Argh![K] Aaaargh!", spanish=" ¡Ah![K] ¡Aaah![K] ¡Aaaaaaaah!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" We thought we were a goner!", french="Nous avons cru que c'en\nétait fini de nous!", german=" Ich dachte, ich sei erledigt!", italian=" Pensavamo di essere spacciati!", spanish="¡Ya creíamos que no íbamos a\nsalir de esa!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="While training here...[K]the waves\ncarried us off!", french="Nous étions en train de nous\nentraîner...[K] quand les flots nous ont emportés!", german="Während meines Trainings hier[K]\ntrugen die Wellen mich hinfort!", italian="Mentre ci allenavamo qui...[K]\nLe onde ci hanno trascinato via!", spanish="Mientras entrenábamos...[K] ¡las\nolas nos arrastraron!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="For months, we drifted on the\nwaves, cut off from all contact...", french="Des mois durant, nous avons\ndérivé au gré des courants marins, coupés\ndu monde...", german="Über Monate trieb ich auf den\nWellen dahin, abgeschnitten von jeglichem\nKontakt...", italian="Le onde ci hanno portato per\nmesi alla deriva, tagliati fuori da tutto e da\ntutti...", spanish="Durante meses hemos ido a la\nderiva, sin contacto alguno..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="...In all truth, that is really an\nexaggeration.[K] We were merely splashed by\nwaves on the shore...", french="... A vrai dire, nous exagérons\nun peu.[K] Nous avons juste été éclaboussés\npar les embruns...", german="...Bei aller Ehrlichkeit, das ist\nnun wirklich eine Übertreibung.[K] Ich wurde\nlediglich von den Wellen an die Küste gespült...", italian="A dirla tutta, abbiamo un po'\nesagerato.[K] Siamo stati semplicemente\nsbattuti sulla spiaggia dalle onde...", spanish="Bueno, hemos exagerado un poco.[K]\nSimplemente nos salpicaron las olas en\nla orilla..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- Turn2DirectionLives vers ACTOR_NPC_ERUREIDO [cible sans placement SSA dans la zone (spawn moteur NDS) : orientation non jouée]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="While we floundered...[K]we were\nthankfully rescued by these kindly strangers.", french="Nous pataugions péniblement...[K]\nQuand ces bienveillants étrangers nous ont\nporté secours.", german="Als ich ins Schwimmen geriet,[K]\nwurde ich dankenswerterweise von diesen\nfreundlichen Fremden gerettet.", italian="Mentre ci dibattevamo\nnell'acqua...[K] fortunatamente siamo stati\nsoccorsi da questi gentili sconosciuti.", spanish="Mientras luchábamos por\nmantenernos a flote...[K] unos amables\ndesconocidos nos rescataron."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 93] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dagutorio, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="We are testing to see how close\nwe can get to the sea.", french="Nous essayons de nous approcher\nle plus possible de la mer.", german="Ich führe Tests durch, um zu\nsehen, wie nahe ich ans Meer gelangen kann.", italian="Stiamo provando a vedere\nquanto riusciamo ad avvicinarci al mare.", spanish="Estamos probando a ver cuánto\nnos podemos acercar al mar."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="We are weak against water.[K]\nBut we seek to overcome that shortcoming!", french="Nous sommes vulnérables\nà l'eau.[K] Mais nous cherchons à surmonter\nce défaut!", german="Ich bin anfällig gegenüber\nWasser.[K] Aber ich versuche, diese Schwäche\nzu überwinden!", italian="Siamo deboli contro l'acqua.[K]\nMa stiamo cercando di colmare questa lacuna!", spanish="Somos débiles frente al agua.[K]\n¡Pero intentamos superar nuestros\ndefectos!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" That will shape us into a hero!", french="C'est ainsi que nous deviendrons\ndes héros!", german="Das wird mich zu einem Helden\nformen!", italian=" Questo ci trasformerà in eroi!", spanish=" ¡Eso nos convertirá en héroes!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" O sea! Come![K] We dare you!", french="Ô mer! Viens à nous![K]\nNous te mettons au défi!", german="Oh Meer! Komm![K] Ich fordere\ndich heraus!", italian=" O mare! Vieni![K] Noi ti sfidiamo!", spanish=" ¡Oh, mar! ¡Ven![K] ¡Te desafiamos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" O sea, hear me! Teach me!", french="Ô mer, entends-nous!\nMontre-nous la voie!", german="Oh Meer, erhöre mich! Lehre\nmich!", italian="O mare, ascoltaci! Insegnaci!\nComprendici!", spanish="¡Oh, mar! ¡Escúchanos!\n¡Enséñanos!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dagutorio, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 3] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dagutorio, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="What?![K] Do I know the grand\nmaster of all things bad?!", french="Quoi?![K] Si nous connaissons\nle grand maître de tous les maux?!", german="Was?!?[K] Ob ich den\nGroßmeister allen Übels kenne?!?", italian="Cosa?![K] Se conosciamo Sua\nMalvagità?!", spanish="¿Qué? [K]¿Que si hemos oído\nhablar del gran malo requetemalo?"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Of course![K] You think that we\nare ignorant of such things?!", french="Bien entendu![K] Vous nous croyez\ndonc ignorants à ce point?!", german="Natürlich![K] Glaubst du etwa, dass\nich über solche Dinge nicht Bescheid weiß?!?", italian="Certo![K] Non siamo poi così\nignoranti!", spanish="¡Por supuesto![K] Os pensáis que\nsomos unos ignorantes, ¿no?"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="...[K]What?[K] You wish to know\nwhat we know?", french="...[K] Quoi?[K] Vous désirez savoir\nce que nous savons?", german="...[K]Wie bitte?[K] Du willst wissen,\nwas ich weiß?", italian="...[K] Cosa?[K] Volete sapere cosa\nsappiamo?", spanish="¿Eh?[K] ¿Qué?[K] ¿Queréis saber\nlo que sabemos?"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Before the graduation exam?[K]\nWe should tell you that, of all things?!", french="C'est de ça dont vous voulez\nparler, et maintenant en plus?![K]\nAvant l'examen de la Guilde?", german="Vor der Abschlussprüfung?[K] Ich\nsoll dir ausgerechnet DAS erzählen?", italian="Prima dell'esame della Gilda?[K]\nDovremmo dirvi tutto?!", spanish="¿Antes de afrontar el reto?[K]\n¿Pretendéis que os lo contemos?"})
  -- message_KeyWait
  -- SetAnimation(9) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Nooooooo!", french=" Noooooon!", german=" Neiiiiiiin!", italian=" Nooooooo!", spanish=" ¡Nooooooo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" ...[K]Gasp-gasp...", french=" ...[K] Pff... pff...", german=" ...[K]Schnauf-schnauf...", italian=" ...[K] Gasp-gasp...", spanish=" Uf...[K] Uf, uf..."})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dagutorio, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" You have our support too!", french=" Vous avez tout notre soutien!", german="Meine Unterstützung habt ihr\nebenfalls!", italian=" Avete anche il nostro appoggio!", spanish=" ¡Contad con nuestro apoyo!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" O sea! You too!", french=" Ô mer! Toi aussi!", german=" Oh Meer! Du auch!", italian=" O mare! Anche tu!", spanish=" ¡Oh, mar! ¡El tuyo también!"})
  -- message_Close
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" O sea![K] You agree!", french="Ô mer![K] Tu approuves\nnos choix!", german=" Oh Meer![K] Du stimmst zu!", italian=" O mare![K] Sei d'accordo!", spanish=" ¡Oh, mar![K] ¡Estás de acuerdo!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" You offer encouragement too!", french="Et tu nous transmets également\nta force!", german=" Du bietest auch Ermutigung!", italian="Offri anche il tuo\nincoraggiamento!", spanish=" ¡También ofreces tu apoyo!"})
  -- message_Close
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="[CN]SPLAAAASH...", french="[CN]SPLAAAASH...", german="[CN]PLATSCH...", italian="[CN]SPLAAAASH...", spanish="[CN]CHAAAAAF..."})
  -- message_KeyWait
  -- GAP: se_Play(6675) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="[CN]SPLOOOOSH...", french="[CN]PLOUUUFFF...", german="[CN]PLITSCH...", italian="[CN]SPLOOOOSH...", spanish="[CN]CHOOOOOF..."})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" See?![K] Now do your best!", french="Vous voyez?![K] Alors faites de\nvotre mieux!", german="Seht ihr?!?[K] Nun gebt euer\nBestes!", italian=" Visto?![K] Ora dateci dentro!", spanish="¿Lo veis?[K] ¡Ahora esforzaos\ntodo lo que podáis!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dagutorio, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Wrooooah![K] We failed to get\nthrough the dungeon! It is a travesty!", french="Sniiif![K] Nous avons échoué\ndans la traversée du donjon!\nC'est une mascarade!", german="Wrooooah![K] Ich habe es nicht\ngeschafft, durch den Dungeon zu gelangen! Es\nist ein Hohn!", italian="Uaaaaah![K] Non siamo riusciti a\nsuperare il dungeon! Che disgrazia!", spanish="No...[K] ¡No logramos atravesar\nel territorio! ¡Y nos avergonzamos!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="It must have been a mistake of\nsome sort!", french="Il a dû y avoir une erreur\nquelque part!", german="Da muss sich irgendein Fehler\neingeschlichen haben!", italian="Ci deve essere stato qualche\nerrore!", spanish=" Debimos de cometer un error."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="We are off once again![K]\nThis time, we won't fail!", french="Nous y retournons![K]\nEt cette fois, nous n'échouerons pas!", german="Ich bin erneut unterwegs![K]\nDieses Mal wird es kein Versagen geben!", italian="Siamo di nuovo in partenza![K]\nQuesta volta non falliremo!", spanish="¡Lo intentaremos de nuevo![K]\n¡Y esta vez lo conseguiremos!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 3] || scn($SCENARIO_MAIN) >= [23
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 3]
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[24] = 1 -- $SCENARIO_TALK_BIT_FLAG[24] = 1 (ROM)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dagutorio, 4) end)
  -- supervision_ExecuteCommon(CORO_EVENT_M00_04) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 1]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dagutorio, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" O sea![K] Hear us!", french=" Ô mer![K] Entends nos paroles!", german=" Oh Meer![K] Erhöre mich!", italian=" O mare![K] Ascoltaci!", spanish=" ¡Oh, mar![K] ¡Escúchanos!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Our journey has been delayed![K]\nAnd our effort to capture [CS:N]Grovyle[CR] has also\nbeen postponed!", french="Notre départ est ajourné![K]\nEt notre participation à la capture de [CS:N]Massko[CR]\nest, elle aussi, ajournée!", german="Die Reise wurde\naufgeschoben![K] Und alle Bemühungen, [CS:N]Reptain[CR]\ngefangen zu nehmen, wurden auch verschoben!", italian="Il nostro viaggio è stato\nrimandato![K] Ed è stata posticipata anche la\ncattura di [CS:N]Grovyle[CR]!", spanish="¡Nuestro viaje ha sido retrasado![K]\n¡También se ha aplazado la captura de [CS:N]Grovyle[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="In all truth, \"postponed\" isn't the\nright word for the latter.[K] The great [CS:N]Dusknoir[CR]\nwill handle the capture by himself.", french="En toute honnêteté, \"ajournée\"\nn'est pas l'exacte vérité.[K] Le grand [CS:N]Noctunoir[CR]\nva se charger de la capture tout seul.", german="Verschoben trifft es vielleicht\nnicht genau.[K] Der große [CS:N]Zwirrfinst[CR] selbst wird\nsich um die Gefangennahme kümmern.", italian="A dire il vero, \"posticipata\" non\nè la parola più adatta.[K] Il grande [CS:N]Dusknoir[CR]\nvuole occuparsi da solo della cattura.", spanish="A decir verdad, \"aplazado\" tal\nvez no sea muy exacto.[K] El gran [CS:N]Dusknoir[CR]\nen persona se ocupará de capturar a [CS:N]Grovyle[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="It's a little difficult, but\nunderstand us![K] O sea!", french="C'est un peu délicat, mais fais\npreuve de mansuétude![K] Ô vaste mer!", german="Es ist etwas schwierig, aber\nbitte versteh mich![K] Oh Meer!", italian="È un po' difficile, ma cerca di\ncapirci![K] O mare!", spanish="¡Oh, mar![K] ¡Nos es difícil, pero\nentiéndenos!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [16, 2] || scn($SCENARIO_MAIN) >= [16
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dagutorio, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" O sea![K] Hear us!", french=" Ô mer![K] Entends nos paroles!", german=" Oh Meer![K] Erhöre mich!", italian=" O mare![K] Ascoltaci!", spanish=" ¡Oh, mar![K] ¡Escúchanos!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" We must postpone our journey!", french="Il nous faut ajourner notre\ndépart!", german="Die Reise muss verschoben\nwerden!", italian="Dobbiamo posticipare il nostro\nviaggio!", spanish="¡Tenemos que aplazar nuestro\nviaje!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="We must participate in the\ncapture of [CS:N]Grovyle[CR]!", french="Nous devons participer à la\ncapture de [CS:N]Massko[CR]!", german="Ich muss mich an der\nGefangennahme von [CS:N]Reptain[CR] beteiligen!", italian="Dobbiamo partecipare alla\ncattura di [CS:N]Grovyle[CR]!", spanish="¡Tenemos que ayudar a capturar\na[CS:N] Grovyle[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="We will...[K] We will capture\n[CS:N]Grovyle[CR] without fail!", french="Nous...[K] nous capturerons\n[CS:N]Massko[CR] sans faute!", german="Ich werde...[K] Ich werde\n[CS:N]Reptain[CR] fangen!", italian="Noi...[K] ce la faremo a catturare\n[CS:N]Grovyle[CR]!", spanish="Tenemos...[K] ¡Debemos capturar a\n[CS:N]Grovyle[CR] como sea!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Though it is frightening...[K]\nWe will do our best!", french="Bien que cela soit effrayant...[K]\nNous ferons de notre mieux!", german="Obwohl es furchterregend ist...[K]\nIch werde mein Bestes tun!", italian="Malgrado ci intimorisca...[K]\nFaremo del nostro meglio!", spanish="Estamos un poco asustados...[K]\n¡pero nos esforzaremos al máximo!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="We need encouragement![K]\nO vaaaast sea!", french="Nous t'implorons de nous\naccorder ton soutien![K] Ô vaste mer!", german="Ich brauche Ermutigung![K]\nOh rieeeeesiges Meer!", italian="Abbiamo bisogno di un\nincoraggiamento![K] Oh immeeenso mare!", spanish="¡Necesitamos tus ánimos![K]\n¡Oh, inmenso mar!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [14, 1] || scn($SCENARIO_MAIN) >= [13
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[23] = 1 -- $SCENARIO_TALK_BIT_FLAG[23] = 1 (ROM)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dagutorio, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" O sea![K] Hear us!", french=" Ô mer![K] Entends nos paroles!", german=" Oh Meer![K] Erhöre mich!", italian=" O mare![K] Ascoltaci!", spanish=" ¡Oh, mar![K] ¡Escúchanos!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="We have given a topic much\nthought![K] How we can reach the great\n[CS:N]Dusknoir[CR]'s lofty standards?", french="Comment égaler la magnificence\nd'un héros tel que [CS:N]Noctunoir[CR]?[K]\nNous y avons beaucoup réfléchi!", german="Ich habe viel über ein Thema\nnachgedacht:[K] Wie kann ich das erhabene\nNiveau von [CS:N]Zwirrfinst[CR] erreichen?", italian="Ci abbiamo pensato molto\nseriamente![K] Cosa si può fare per raggiungere\nil livello di [CS:N]Dusknoir[CR]?", spanish="¡Hemos estado pensando mucho![K]\n¿Cómo podemos alcanzar la excelencia\nde [CS:N]Dusknoir[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" And...[K]after soul-searching...", french="Ainsi donc...[K] après un long\nexamen de conscience...", german="Ich verbrachte Zeit damit,[K] in\nmich zu gehen...", italian="E...[K] dopo una ricerca\ninteriore...", spanish=" Y...[K] tras mucha meditación..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" arrived at a single conclusion!", french="... nous sommes parvenus\nà une conclusion, une seule!", german="Und kam dann zu folgendem\nErgebnis:", italian="Siamo giunti a un'unica\nconclusione!", spanish=" ¡Hemos llegado a una conclusión!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="We will...[K]leave the guild to go\non a journey!", french="Nous allons...[K] quitter la Guilde\net voyager!", german="Ich werde...[K] die Gilde\nverlassen und mich auf eine Reise begeben!", italian="Noi...[K] lasceremo la Gilda per\nintraprendere un viaggio!", spanish="Hemos decidido...[K] ¡abandonar\nel [CS:N]Pokégremio[CR] para hacer un viaje!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="We wish to travel the world\nand experience what it has to offer!", french="Nous voyagerons de par\nle monde à la découverte de tout ce\nqu'il a à offrir!", german="Es ist mein Wunsch, die Welt\nzu bereisen, und zu erfahren, was sie zu bieten\nhat!", italian="Vogliamo viaggiare per il mondo\ne scoprire cos'ha da offrirci!", spanish="¡Queremos viajar por el mundo\ny ver qué experiencias podemos vivir!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="On a path of self-discovery![K]\nWait! Do I mean paths of self-discovery?[K]\nOr a path of self-discoveries?", french="Nous emprunterons le chemin\nde la découverte de soi![K] A moins que\nce ne soit le chemin qui nous emprunte...", german="Der Pfad der Selbstentdeckung![K]\nÄh... Meine ich Pfade der Selbstentdeckung?[K]\nOder einen Pfad voller Selbstentdeckungen?", italian="Un percorso per scoprire\nse stessi![K] Aspetta! Scoperte personali?[K]\nO un sentiero di scoperte interiori?", spanish="¡Queremos caminar y aprender![K]\n¡Espera! ¿O mejor aprender y caminar?[K]\n¿O aprender caminando?"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="O sea! What say you?![K]\nGive us your reply!", french="Ô mer! Qu'en dis-tu?![K]\nNous attendons ton verdict!", german="Oh Meer! Was sagst du\ndazu?!?[K] Teile mir deine Antwort mit!", italian="O mare! Cosa ne pensi?![K]\nDacci una risposta!", spanish="¡Oh, mar! ¿Tú qué opinas?[K]\n¡Danos tu contestación!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Answer us![K]\nO vaaaast sea!", french=" Réponds-nous![K] Ô vaste mer!", german="Antworte mir![K]\nOh rieeeeesiges Meer!", italian="Rispondici![K]\nO immeeeenso mare!", spanish="¡Respóndenos![K]\n¡Oh, inmenso mar!"})
  -- message_Close
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="[CN]SPLAAAASH...", french="[CN]SPLAAAASH...", german="[CN]PLATSCH...", italian="[CN]SPLAAAASH...", spanish="[CN]CHAAAAAF..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="[CN]SPLOOOOSH...", french="[CN]PLOUUUF...", german="[CN]PLITSCH...", italian="[CN]SPLOOOOSH...", spanish="[CN]CHOOOOOF..."})
  -- message_KeyWait
  -- GAP: se_Play(6675) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="[CN]SPLOOOOSH...SPLAAAASH!", french="[CN]PLOUUUF... SPLAAAASH!", german="[CN]PLITSCH... PLATSCH!", italian="[CN]SPLOOOOSH... SPLAAAASH!", spanish="[CN]CHAAAAAF... ¡CHOOOOF!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" O sea![K] You will allow it!", french="Ô mer![K] Ainsi, tu nous as\naccordé ta bénédiction!", german=" Oh Meer![K] Du erlaubst es!", italian="O mare![K] Tu renderai possibile\ntutto ciò!", spanish=" ¡Oh, mar![K] ¡Estás de acuerdo!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Th-thank you, great sea!", french=" Mille mercis, ô mer vénérée!", german=" H-hab Dank, großes Meer!", italian=" G-Grazie, grande mare!", spanish=" ¡Gracias, mar!"})
  -- message_Close
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" ...And that's the way of it.", french=" ... Qu'il en soit ainsi.", german=" ...Und so soll es geschehen.", italian=" ... Così stanno le cose.", spanish=" Y así será."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="We will leave on our\njourney soon.", french=" Nous partirons sous peu.", german="Ich werde mich bald auf die\nReise begeben.", italian="Partiremo presto per il nostro\nviaggio.", spanish="Pronto emprenderemos\nnuestro viaje."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="I trust you will pick up the slack\nin our absence.", french="Nous te faisons confiance\npour reprendre le flambeau en notre absence.", german="Ich vertraue darauf, dass du\nwährend meiner Abwesenheit das Ruder\nübernimmst.", italian="Confido che in nostra assenza\nterrai tutto sotto controllo.", spanish="Confío en que tomes las riendas\nen nuestra ausencia."})
  -- message_Close
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="We must return to the guild and\nprepare for our journey!", french="A présent, il nous faut regagner\nla Guilde et nous préparer à notre long\npériple!", german="Ich muss zur Gilde\nzurückkehren und mich auf die Reise\nvorbereiten!", italian="Dobbiamo tornare alla Gilda e\nprepararci per il viaggio!", spanish="¡Debemos volver al [CS:N]Pokégremio[CR]\ny prepararnos para el viaje!"})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Farewell!", french=" Adieu!", german=" Leb wohl!", italian=" Addio!", spanish=" ¡Adiós!"})
  -- message_Close
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Down)
  -- GAP: se_Play(6422) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 4]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dagutorio, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" O sea![K] Hear us!", french=" Ô mer![K] Ecoute-nous!", german=" Oh Meer![K] Erhöre mich!", italian=" O mare![K] Ascoltaci!", spanish=" ¡Oh, mar![K] ¡Escúchanos!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="We have met a Pokémon that\ninspires us deeply!", french="En chemin, nous avons fait\nla connaissance d'un Pokémon qui nous\ninspire beaucoup!", german="Ich habe ein Pokémon\ngetroffen, das mich zutiefst inspiriert hat!", italian="Abbiamo conosciuto un Pokémon\nche ci ispira molto!", spanish="¡Hemos conocido a un Pokémon\nque nos causa una profunda admiración!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="A great Pokémon that goes by\nthe name of [CS:N]Dusknoir[CR]!", french="Un Pokémon héroïque répondant\nau nom de [CS:N]Noctunoir[CR]!", german="Ein großes Pokémon namens\n[CS:N]Zwirrfinst[CR]!", italian="Un grande Pokémon conosciuto\ncol nome di [CS:N]Dusknoir[CR]!", spanish="¡Un gran Pokémon llamado\n[CS:N]Dusknoir[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="O sea! The world is huge![K]\nAnd there are Pokémon beyond number!", french="Ô mer! Comme le monde est\nimmense![K] Et comme il regorge d'innombrables\nPokémon!", german="Oh Meer! Die Welt ist\ngigantisch![K] Und es gibt zahllose Pokémon!", italian="O mare! Il mondo è immenso![K]\nE i Pokémon sono tantissimi!", spanish="¡Oh, mar! ¡El mundo es enorme![K]\n¡Y hay tantísimos Pokémon!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Our meager knowledge and\nexperience is no match for the great\n[CS:N]Dusknoir[CR]'s...[K] However...!", french="Nos connaissances et notre\nexpérience dérisoires sont sans commune\nmesure avec celles de [CS:N]Noctunoir[CR]...[K] Pourtant...!", german="Mein dürftiges Wissen und\nmeine spärliche Erfahrung sind nichts im\nVergleich zum großen [CS:N]Zwirrfinst[CR]...[K] Aber...", italian="Le nostre scarne conoscenze ed\nesperienze non sono paragonabili a quelle del\ngrande [CS:N]Dusknoir[CR]...[K] Tuttavia...!", spanish="Nuestra exigua sabiduría y\nexperiencia no tienen comparación\ncon las de [CS:N]Dusknoir[CR]...[K] Sin embargo..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" We will...[K]one day...[K]be like him...", french="Un jour...[K] nous aussi, nous\nserons...[K] comme lui...", german="Ich werde...[K] eines Tages...[K] wie\ner sein...", italian="Un giorno...[K] noi...[K] saremo\ncome lui...", spanish=" Algún día...[K] seremos...[K] como él..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(9) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Woooaaah!", french=" Ouaaaaaaaaaaah!", german=" Woooaaah!", italian=" Uaaaaaah!", spanish=" ¡Aaaah!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" ...[K]Gasp-gasp...", french=" ...[K] Pff... pff...", german=" ...[K]Schnauf-schnauf...", italian=" ...[K] Gasp-gasp...", spanish=" Uf...[K] Uf, uf..."})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [12, 3] || scn($SCENARIO_MAIN) >= [12
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dagutorio, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" O sea![K] We have returned!", french=" Ô mer![K] Nous sommes de retour!", german=" Oh Meer![K] Ich bin zurückgekehrt!", italian=" O mare![K] Siamo tornati!", spanish=" ¡Oh, mar![K] ¡Hemos regresado!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="We have returned from the\nexpedition! We have learned and grown!", french="Nous sommes revenus de\nl'expédition! Nous en revenons plus sages\net grandis!", german="Ich bin von der Expedition\nzurückgekehrt! Ich habe gelernt und bin\ngewachsen!", italian="Siamo tornati dalla spedizione!\nAbbiamo imparato e siamo cresciuti!", spanish="¡Hemos regresado, por fin, de la\nexpedición! ¡Hemos aprendido y madurado!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="How we have grown...[K] Bear\nwitness to it!", french="Notre grandeur nouvelle, vois\npar toi-même...[K] Sois-en le majestueux\ntémoin!", german="Und wie ich gewachsen bin...[K]\nSeht nur!", italian="Come siamo cresciuti...[K] Il\nmare ne è testimone!", spanish="De cuánto hemos madurado...[K]\n¡Ahora podrás ser testigo!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="O sea![K] O sea!!![K]\nO vaaaast sea!", french="Ô mer![K] Ô mer!!![K]\nÔ mer à nulle autre pareille!", german="Oh Meer![K] Oh Meer!!![K]\nOh rieeeeesiges Meer!", italian="O mare![K] O mare!!![K]\nO immenso mare!", spanish="¡Oh, mar![K] ¡Oh, mar![K]\n¡Oh, inmenso mar!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" ...[K]Gasp-gasp...", french=" ...[K] Pff... pff...", german=" ...[K]Schnauf-schnauf...", italian=" ...[K] Gasp-gasp...", spanish=" Uf...[K] Uf, uf..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dagutorio, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="O sea![K] We've come to bid you\na brief farewell!", french="Ô vénérée mer![K]\nNous sommes venus te faire nos adieux,\nque nous espérons courts!", german="Oh Meer![K] Ich bin gekommen,\num dir ein kurzes Lebewohl zu sagen!", italian="O mare![K] Siamo venuti a dirti\naddio per un po'!", spanish="¡Oh, mar![K] ¡Hemos venido a\ndecirte adiós!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="We have been chosen for the\nexpedition! (Though that was a given.)", french="Nous avons été jugés dignes de\nfaire partie de l'expédition! (Ce qui n'a\ncertes rien d'étonnant...)", german="Ich bin für die Expedition\nausgewählt worden! (Obwohl das von\nvornherein klar war.)", italian="Siamo stati scelti per la\nspedizione! Non poteva essere altrimenti!", spanish="¡Nos han escogido para la\nexpedición! (Aunque era de esperar.)"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="We therefore must take leave\nof this place for a short while!", french="Ainsi donc, nous nous voyons\ncontraints de prendre congé de toi pour\nquelque temps!", german="Daher muss ich diesen Ort\nfür eine kurze Weile verlassen!", italian="Dunque dobbiamo andarcene\nda qui per un po' di tempo!", spanish="¡Tendremos que ausentarnos\nunos días!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" However...[K] When we return...", french=" Toutefois...[K] A notre retour...", german="Allerdings...[K] Wenn ich\nzurückkomme...", italian="Comunque...[K] quando saremo\ndi ritorno...", spanish="Sin embargo...[K] Cuando\nregresemos..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="You will see that we have grown\nin every way!", french="Tu constateras que nous\naurons en tous points grandi!", german="Wirst du sehen, dass ich in\njederlei Hinsicht gewachsen bin!", italian="Saremo cresciuti, in tutti i\nsensi!", spanish="¡Verás que hemos madurado en\ntodos los sentidos!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Look forward to that day!", french=" Dans l'attente de ce jour...", german=" Freu dich auf jenen Tag!", italian="Non vediamo l'ora che arrivi quel\ngiorno!", spanish="¡Tengo tantas ganas de que\nllegue ese día!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="O sea![K] O sea!!![K]\nO vaaaast sea!", french="Ô mer![K] Ô mer adorée!!![K]\nÔ mer incommensurable!", german="Oh Meer![K] Oh Meer!!![K]\nOh rieeeeesiges Meer!", italian="O mare![K] O mare!!![K]\nO immenso mare!", spanish="¡Oh, mar![K] ¡Oh, mar![K]\n¡Oh, inmenso mar!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" ...[K]Gasp-gasp...", french=" ...[K] Pff... pff...", german=" ...[K]Schnauf-schnauf...", italian=" ...[K] Gasp-gasp...", spanish=" Uf...[K] Uf, uf..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dagutorio, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="...[K]The expedition is coming up\nquickly.", french="...[K] L'expédition commencera\ntrès bientôt.", german="...[K]Die Expedition rückt rasch\nnäher.", italian="...[K] La spedizione è sempre più\nvicina.", spanish="Por cierto...[K] La expedición\ntendrá lugar muy pronto."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="It would be nice to see you two\nchosen as members too.", french="Ce serait bien qu'ils vous\nsélectionnent, n'est-ce pas?", german="Es wäre schön zu sehen, wenn\nihr beide auch als Mitglieder ausgewählt\nwerden würdet.", italian="Sarebbe bello se scegliessero\nanche voi come membri.", spanish=" Espero que os dejen participar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" ...[K]Oh?[K] As for us?", french=" ...[K] Comment?[K] Nous?", german=" ...[K]Oh?[K] Was mich betrifft?", italian=" ...[K] Oh?[K] Noi?", spanish=" ¿Eh?...[K] ¿Qué?[K] ¡Claro!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="It goes without saying that we'll\nbe among the chosen!", french="Il va sans dire que nous ferons\npartie des élus!", german="Es steht außer Frage, dass ich\ndabei sein werde!", italian="Beh, è chiaro che saremo scelti,\nno?", spanish="¡Claro que estaremos entre\nlos elegidos!"})
  -- message_KeyWait
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="What...[K] What do you take us\nfor? Grr-rumble...", french="Que...[K] Pour qui vous nous\nprenez? Grrrrr...", german="Was...[K] Für wen haltet ihr mich?\nGrr-rummel...", italian="Come...[K] Come osate...?\nGrrrrr...", spanish="Por...[K] ¿Por quién nos tomas?\nGrr..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="How very insulting of you![K]\nGrrr-rumble...", french="Quelle impudence![K]\nGrrrrr...", german="Wie beleidigend von euch![K]\nGrrr-rummel...", italian="È davvero offensivo da parte\nvostra![K] Grrrrr...", spanish="¿Cómo se te ocurre?[K]\nGrrr..."})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 2] || scn($SCENARIO_MAIN) >= [8, 
  if ((SV.SkyTalkBitFlags or {})[26] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[26]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dagutorio, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Oh, for crying out loud...[K] I wish\nyou hadn't seen that.", french="Oh, tristesse infinie...[K]\nNous aurions préféré que vous n'assistiez pas\nà ça.", german="Ach du Schande...[K] Ich wünschte,\ndu hättest das nicht mitangesehen.", italian="Oh, che tristezza...[K]\nAvremmo preferito non farvi assistere a\nquesta scena.", spanish="¡Pero bueno...![K] Ojalá no\nhubierais visto eso."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Raising a child is the hardest\nthing I've ever done...[K] Aha-ha-ha...", french="Elever un enfant est la chose\nla plus difficile que nous ayons faite dans\nnotre vie...[K] Ah là là...", german="Ein Kind großzuziehen, ist die\nschwerste Aufgabe, der ich mich je gestellt\nhabe...[K] Aha-ha-ha...", italian="Crescere un figlio è la cosa più\ndifficile che abbiamo mai fatto...[K] Aha-ha-ha...", spanish="Educar a un hijo es lo más\ncomplicado que he hecho nunca...[K] Ja, ja, ja..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="But I'd like to imagine that my\nson will one day understand.", french="Mais nous voulons croire qu'un\njour notre fils comprendra.", german="Aber ich hoffe, dass mein Sohn\nes eines Tages verstehen wird.", italian="Ma è bello immaginare che un\ngiorno capirà.", spanish=" Pero algún día lo entenderá."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="The way that we have chosen\nto live...", french="La vie que nous avons choisie...\nest semée d'embûches...", german="Der Weg, den wir als unseren\nLebensweg gewählt haben...", italian="La scelta di vita che abbiamo\nfatto...", spanish="El modo de vida que hemos\nescogido..."})
  -- message_Close
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[26] = 1 -- $SCENARIO_TALK_BIT_FLAG[26] = 1 (ROM)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 400, 184, Direction.Down, "NPC_DIGUDA")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dagutorio, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" My son.", french=" Notre fils.", german=" Mein Sohn.", italian=" Figlio.", spanish=" Hijo mío."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_dagutorio, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Yes, Dad?", french=" Oui, père?", german=" Ja, Papa?", italian=" Sì, papà?", spanish=" ¿Sí, papá?"})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Why did you call me out here?", french="Pourquoi est-ce que tu m'as fait\nvenir ici?", german="Warum hast du mich hierher\nbestellt?", italian=" Perché mi hai fatto venire qui?", spanish="¿Para qué me has hecho venir\naquí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" See?[K] The sea is vast.", french="Tu vois?[K] Contemple comme\nla mer est vaste.", german=" Siehst du?[K] Das Meer ist riesig.", italian=" Vedi?[K] Il mare è immenso.", spanish=" ¿Ves?[K] El mar es inmenso."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Um, yes... But why are you\ntelling me this?", french="Euh, oui... Mais pourquoi est-ce\nque tu me racontes tout ça?", german="Ähm, ja... Aber warum erzählst\ndu mir das?", italian="Uhm, sì... Ma perché mi dici\nquesto?", spanish="Hum, sí... Pero, ¿a qué viene\nesto?"})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" I'm supposed to be working, Dad.", french="Je devrais retourner au travail,\npère.", german="Ich sollte bei der Arbeit sein,\nPapa.", italian=" Dovrei essere al lavoro, papà.", spanish=" Debería estar trabajando, papá."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="If I don't go back soon, I'll get\nan earful from [CS:N]Loudred[CR].", french="Si je n'y retourne pas très vite,\n[CS:N]Ramboum[CR] va me passer un savon.\nIl va encore crier comme un sourd!", german="Wenn ich nicht bald zurückgehe,\nbekomme ich Ärger mit [CS:N]Krakeelo[CR].", italian="Se non torno presto, [CS:N]Loudred[CR] mi\nfarà una lavata di capo.", spanish="Si no vuelvo pronto, [CS:N]Loudred[CR] me\nechará la bronca."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" You'll be scolded?", french=" Un savon?", german=" Man wird dich ausschimpfen?", italian=" Una lavata di capo?", spanish=" ¿Te van a regañar?"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Why let such a paltry matter\ncloud your thoughts?", french="Pourquoi laisser un problème si\ndérisoire assombrir tes pensées?", german="Warum lässt du deine Gedanken\nvon solch einer geringfügigen Angelegenheit\neinhüllen?", italian="Perché farsi annebbiare la\nmente da un pensiero così banale?", spanish="¿Por qué dejar que una cuestión\ntan irrelevante te nuble las ideas?"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Broaden your perspective...[K]\nLike the sea before you.", french="Ouvre ton esprit...[K]\nComme la mer devant toi.", german="Erweitere deine Perspektive...[K]\nSo wie das Meer vor dir.", italian="Amplia la tua prospettiva...[K]\nCome il mare di fronte a te.", spanish="Expande tus horizontes...[K] como\nel mar ante ti."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" I don't know what that means!", french="Mais j'y comprends rien à ton\ntruc, moi, père!", german="Ich weiß nicht, was das\nbedeuten soll!", italian=" Non capisco cosa vuoi dire!", spanish="No entiendo lo que me quieres\ndecir."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="I'm going back to the guild.[K]\nI want to be chosen for the expedition.", french="Je retourne à la Guilde.[K] Je veux\nêtre sélectionné pour l'expédition, moi!", german="Ich gehe zurück zur Gilde.[K] Ich\nwill für die Expedition ausgewählt werden.", italian="Torno alla Gilda.[K] Voglio essere\nscelto per la spedizione.", spanish="Me vuelvo al [CS:N]Pokégremio[CR].[K]\nQuiero que me elijan para la expedición."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Dad, you should quit wasting\ntime here and get back to work.[K] See you.", french="Père, arrête de perdre ton\ntemps ici et retourne à ton poste.[K] A plus.", german="Papa, du solltest aufhören, hier\ndeine Zeit zu verschwenden, und wieder zurück\nan die Arbeit gehen.[K] Bis später.", italian="Papà, dovresti smetterla di star\nqui a perdere tempo e tornare al lavoro.[K]\nCi vediamo.", spanish="Papá, deberías dejar de perder\nel tiempo y ponerte a trabajar.[K] Adiós."})
  -- message_Close
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  -- GAP: se_Play(6422) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 6] || scn($SCENARIO_MAIN) >= [7, 
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dagutorio, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" ...", french=" ...", german=" ...", italian=" ...", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" ......", french=" ......", german=" ......", italian=" ......", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" .........", french=" .........", german=" .........", italian=" .........", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Ah, you ask why we are here\nall the time...?[K] It is because...", french="Ah, vous voulez savoir pourquoi\nnous venons ici tout le temps...?[K]\nC'est que...", german="Ah, du möchtest wissen, warum\nich die ganze Zeit über hier bin?[K] Der Grund\nist...", italian="Ah, perché stiamo sempre qua?[K]\nPerché...", spanish="¿Que por qué estamos aquí\nsiempre?[K] Porque..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="We learn much from the sea.\nTo be deep and expansive.", french="La mer a beaucoup de choses à\nnous enseigner. Comme elle, nous devons être\nimmenses, insondables et chaleureux.", german="Nun, das Meer lehrt uns viele\nDinge: Tiefgründig und weitreichend zu sein.", italian="Impariamo un sacco dal mare.\nAd essere profondi, espansivi e coraggiosi.", spanish="Se aprende mucho del mar.\nEs inabarcable e inmenso."})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Don't think that we're shirking\nour work. That isn't our intention!", french="Nous ne tirons pas au flanc!\nCe n'est pas notre intention!", german="Ich drücke mich nicht vor\nmeiner Arbeit! Das ist nicht meine Absicht!", italian="Non stiamo evitando il lavoro!\nNon è questa la nostra intenzione!", spanish="No penséis que holgazaneamos\nen el trabajo. ¡No es nuestra intención!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="We insist that you understand\nus clearly on that point!", french="Permettez-nous d'insister!\nNe vous méprenez pas à notre sujet!", german="Ich bestehe darauf, dass dieser\nPunkt nicht falsch verstanden wird!", italian="Insistiamo, non dovete farvi\nun'opinione sbagliata!", spanish="¡Insistimos en que entendáis\nbien ese punto!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" O sea, hear me!", french="Ô onde azur comme le ciel!\nEntends notre appel!", german=" Oh Meer, hör mich an!", italian=" O mare, ascoltaci!", spanish=" ¡Oh, mar! ¡Escúchame!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" O sea, teach me!", french="Ô onde azur enchanteresse!\nTransmets-nous ta sagesse!", german=" Oh Meer, lehre mich!", italian=" O mare, insegnaci!", spanish=" ¡Oh, mar! ¡Enséñame!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" O sea, understand me!", french="Ô onde azur qui nous met\nen émoi!\nEcoute nos voix!", german=" Oh Meer, verstehe mich!", italian=" O mare, comprendici!", spanish=" ¡Oh, mar! ¡Entiéndeme!"})
  -- message_Close
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 1] || scn($SCENARIO_MAIN) >= [6, 
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dagutorio, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" ...", french=" ...", german=" ...", italian=" ...", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" ...[K]The sea...[K]is so vast...", french=" ... La mer...[K] est si vaste...", german=" ...[K]Das Meer...[K] ist so riesig...", italian="...[K] Il mare...[K] è così\nimmenso...", spanish=" Oh...[K] El mar...[K] es inmenso..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="We wish that we were like the\nsea before us.", french="Nous souhaiterions tant être\npareils à cette mer qui s'étend devant nous.", german="Ich wünsche mir, so wie das\nMeer vor mir zu sein:", italian="Vorremmo poter essere come il\nmare che abbiamo di fronte.", spanish=" Ojalá fuéramos como el mar."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Expansive. Deep of heart.", french="Immense. Insondable.\nChaleureuse.", german="Weitreichend und tiefgründigen\nHerzens.", italian="Espansivi. Con un cuore\nprofondo.", spanish=" Inmenso. Inabarcable."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" O sea, hear me!", french="Ô onde azur comme le ciel!\nEntends notre appel!", german=" Oh Meer, hör mich an!", italian=" O mare, ascoltaci!", spanish=" ¡Oh, mar! ¡Escúchame!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" O sea, teach me!", french="Ô onde azur enchanteresse!\nTransmets-nous ta sagesse!", german=" Oh Meer, lehre mich!", italian=" O mare, insegnaci!", spanish=" ¡Oh, mar! ¡Enséñame!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" O sea, understand me!", french="Ô onde azur qui nous met\nen émoi!\nEcoute nos voix!", german=" Oh Meer, verstehe mich!", italian=" O mare, comprendici!", spanish=" ¡Oh, mar! ¡Entiéndeme!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [5, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dagutorio, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" ...", french=" ...", german=" ...", italian=" ...", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" ......", french=" ......", german=" ......", italian=" ......", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" .........", french=" .........", german=" .........", italian=" .........", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" ...[K]The sea...[K]is so vast...", french=" ...[K] La mer...[K] est si vaste...", german=" ...[K]Das Meer...[K] ist so riesig...", italian="...[K] Il mare...[K] è così\nimmenso...", spanish=" Oh...[K] El mar...[K] es inmenso..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="..................................................\n....................................................................\n....................................................................", french="................................................\n...............................................................\n...............................................................", german="................................................\n......................................................................\n......................................................................", italian="................................................\n......................................................................\n......................................................................", spanish=" ..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
