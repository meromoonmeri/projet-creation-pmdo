-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/un0105.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) or (SkyProg.cmp_side(40, 3) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7] || scn($SCENARIO_SIDE) >= [40
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp_side(40, 2) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 2]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_banebuu = SkySceneKit.spawn_npc("spoink", 384, 232, Direction.UpLeft, "NPC_BANEBUU")
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Hey, [CS:Y]Bidoof[CR]![K]\nHello!", french="Hé, [CS:Y]Keunotor[CR]![K]\nSalut!", german="Hey, [CS:Y]Bidiza[CR]![K]\nHallo!", italian="Ehi, [CS:Y]Bidoof[CR]![K]\nCiao!", spanish="¡Eh, [CS:Y]Bidoof[CR]![K]\n¡Hola!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" I've been doing well, but...", french=" Je vais bien, mais...", german=" Mir ging es gut, aber...", italian=" Sto bene, sì, ma...", spanish="Todo me sigue yendo de fábula,\nno es por quejarme, pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="I've been so happy, the pearl\non top of my head has started to come loose...", french="... je suis si joyeux que la perle\nsur ma tête commence à se détacher...", german="Nun, ich war so glücklich, dass\nsich meine Perle ein wenig gelockert hat...", italian="... sono così felice che a forza\ndi saltellare la mia perla inizia a scivolarmi\ndalla testa...", spanish="Con tanta felicidad, la perla de\nmi cabeza ha empezado a soltarse..."})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" I'm worried it might fall off...", french="J'ai peur qu'elle ne finisse\npar tomber...", german="Ich sorge mich, dass sie wohl\nabfallen könnte...", italian=" Ho paura che possa cadere...", spanish=" Y me preocupa que se me caiga..."})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" This pearl is everything to me.", french="Cette perle représente\ntout pour moi.", german=" Diese Perle bedeutet mir alles.", italian="Questa perla significa tutto\nper me.", spanish=" Sin esta perla no soy nadie."})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="It seems like more bad Pokémon\nare appearing lately...", french="On dirait que de méchants\nPokémon ont commencé à apparaître\ndernièrement...", german="Anscheinend tauchen seit\nKurzem vermehrt böse Pokémon auf...", italian="Sembra che ultimamente siano\ncomparsi molti Pokémon cattivi...", spanish="Y encima parece que últimamente\naparecen cada vez más Pokémon malvados..."})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" If my pearl gets stolen...", french="Si ma perle venait\nà être volée...", german="Wenn meine Perle\ngestohlen würde...", italian="Se qualcuno di loro dovesse\nrubare la mia perla...", spanish=" Si me roban la perla..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_banebuu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" I don't know what I would do!", french="... je ne sais pas ce que\nje ferais!", german="Ich weiß nicht, was ich\nmachen würde!", italian=" ... non so cosa farei!", spanish=" ¡No sé qué iba a ser de mí!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="...But maybe I'm just worrying\ntoo much.", french="... Mais peut-être que je\nme fais trop de mouron?", german="...Aber vielleicht mache ich mir\nauch nur zu viele Sorgen?", italian="Ma forse mi sto preoccupando\ntroppo...", spanish="Igual estoy sacando un poco\nlas cosas de quicio, ¿verdad?"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Worrying so much isn't good for\nmy health. That makes me worry even more.", french="Se faire trop de mouron n'est\npas bon pour la santé. Et du coup,\nje me fais du mouron pour ma santé.", german="Wenn ich mir so viele Sorgen\nmache, ist das nicht gut für meine Gesundheit.\nUnd das macht mir noch viel mehr Sorgen.", italian="Non credo mi faccia bene\npreoccuparmi così tanto. Cercherò di\nnon pensarci troppo.", spanish="He oído que preocuparse\ndemasiado hace que salgan arrugas...\n¡Qué preocupación!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_banebuu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english=" Ha-hahahaha!", french=" Ha-hahahaha!", german=" Ha-hahahaha!", italian=" Ah-ahahah!", spanish=" ¡Ja... ja, ja, ja, ja!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(npc_npc_banebuu, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Oh, hey! [CS:Y]Bidoof[CR]! Good to see\nyou![K] How are you?", french="Ohé! [CS:Y]Keunotor[CR]!\nContent de te voir![K] Comment vas-tu?", german="Oh, hey! [CS:Y]Bidiza[CR]! Schön, dich\nzu sehen![K] Wie geht es dir?", italian="Oh, ehi! [CS:Y]Bidoof[CR]! Che bello\nvederti![K] Come va?", spanish="¡Eh, hola, [CS:Y]Bidoof[CR]! ¡Me alegro\nde verte![K] ¿Qué tal estás?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Um...[K]\nWell... It's like...[K]yup.", french="Hum...[K]\nBen... Disons...[K] pas trop mal.", german="Hmmm...[K]\nAlso... So...[K] jawollja.", italian="Mmmh...[K]\nBeh, ecco...[K] Ohibò!", spanish=" Hum...[K] Pues no...[K] No estoy mal."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="By golly, how about you,\n[CS:N]Spoink[CR]?", french="Et toi, [CS:N]Spoink[CR].\nComment ça va, pardi?", german="Donnerwetter, und dir,\n[CS:N]Spoink[CR]?", italian="Già, [CS:N]Spoink[CR].\nTu piuttosto, come stai?", spanish=" Y tú, ¿cómo estás, [CS:N]Spoink[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="I'm doing great! Wonderful!\nSuperb![K] Just swimmingly!", french="Je vais super bien! La forme!\nLa pêche![K] Tout va à merveille!", german="Mir geht es super! Wunderbar!\nErstklassig![K] Glanzprächtig!", italian="Benissimo! Alla grande!!!\nMagnificamente![K] Va tutto liscio!", spanish="¡Sensacional! ¡De maravilla!\n¡Espléndidamente![K] ¡De perlas!"})
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="The pearl on top of my head is\nalso radiant!", french="La perle sur ma tête brille\nde mille feux, elle aussi!", german="Sogar die Perle auf meinem Kopf\nstrahlt vor Freude!", italian="Anche la perla che ho in testa\nè raggiante!", spanish="Hablando de perlas, la de mi cabeza\ntambién está de lo más radiante."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="That...[K] That's good, yup yup.[K]\nTo tell the truth, I'm a little jealous...", french="C'est...[K] tant mieux, ouaip ouaip.[K]\nA vrai dire, j'suis un peu jaloux...", german="Das...[K] Das ist ja schön, jawollja.[K]\nGanz unter uns: Ich bin ein wenig neidisch...", italian="Che...[K] Che bello, già, già.[K]\nA dire la verità, un pochino ti invidio...", spanish="Pues...[K] Eso mola, vaya que sí.[K]\nA decir verdad, me das un poco de pelusilla..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_banebuu) end)
  SkySceneKit.say({english="Oh, OK![K] I hope you feel better\nsoon, [CS:Y]Bidoof[CR]!", french="Ah, d'accord! [K]J'espère que ça\nira mieux pour toi prochainement, [CS:Y]Keunotor[CR]!", german="Oh, okay![K] Ich hoffe, du fühlst\ndich schon bald wieder besser, [CS:Y]Bidiza[CR]!", italian="Sgrunf![K] Spero che presto tu\npossa sentirti meglio, [CS:Y]Bidoof[CR]!", spanish="¡Bueno, bueno![K] Seguro que pronto\nte sientes mejor, [CS:Y]Bidoof[CR]."})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
