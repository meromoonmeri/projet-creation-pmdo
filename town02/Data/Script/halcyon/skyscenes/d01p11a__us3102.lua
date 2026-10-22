-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/us3102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 432, 192, Direction.Down, "NPC_DAGUTORIO")
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
  local npc_npc_erureido = SkySceneKit.spawn_npc("gallade", 352, 216, Direction.Up, "NPC_ERUREIDO")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_erureido, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="While we floundered...[K]we were\nthankfully rescued by these kindly strangers.", french="Nous pataugions péniblement...[K]\nQuand ces bienveillants étrangers nous ont\nporté secours.", german="Als ich ins Schwimmen geriet,[K]\nwurde ich dankenswerterweise von diesen\nfreundlichen Fremden gerettet.", italian="Mentre ci dibattevamo\nnell'acqua...[K] fortunatamente siamo stati\nsoccorsi da questi gentili sconosciuti.", spanish="Mientras luchábamos por\nmantenernos a flote...[K] unos amables\ndesconocidos nos rescataron."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
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
  end
  SkySceneKit.cleanup_npcs()
end
