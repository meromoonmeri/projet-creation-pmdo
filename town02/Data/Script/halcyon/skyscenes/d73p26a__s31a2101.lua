-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P26A/s31a2101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 22) -- $SCENARIO_MAIN = scn[29,22] (ROM)
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 232, 408, Direction.Up, "NPC_SHEIMI")
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We're almost to the\n6th Station Clearing! Keep going!", french="Nous avons presque atteint\nla trouée du 6[F:E] Relais! Poursuivons!", german="Wir sind schon fast bei der\n6. Zwischenlagerlichtung! Haltet durch!", italian="Siamo in vista del Bivacco 6!\nNon fermiamoci!", spanish="Ya casi estamos en la Base del\nSexto Puerto. ¡Sigamos!"})
  -- message_Close
  -- back_SetGround(LEVEL_D73P26A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_D73P26A, 'US31') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(13) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(43) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(9) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_kinogassa = SkySceneKit.spawn_npc("breloom", 216, 224, Direction.DownRight, "NPC_KINOGASSA")
  pcall(function() GROUND:CharSetEmote(npc_npc_kinogassa, "happy", 1) end)
  GAME:FadeIn(30)
  -- GAP: BGM BGM_SKY_PEAK_SNOWFIELD non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(npc_npc_kinogassa, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_sheimi, 228, 268, false, 2)
  GROUND:MoveToPosition(hero, 228, 300, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 252, 308, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 204, 308, false, 2) end end
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_kinogassa, nil, 0) end) -- EFFECT_NONE
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_kuchiito = SkySceneKit.spawn_npc("mawile", 248, 248, Direction.UpLeft, "NPC_KUCHIITO")
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GROUND:EntTurn(npc_npc_kinogassa, Direction.Down)
  GAME:WaitFrames(10)
  local npc_npc_goorikii = SkySceneKit.spawn_npc("machoke", 256, 224, Direction.Left, "NPC_GOORIKII")
  GROUND:EntTurn(npc_npc_goorikii, Direction.Down)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_kuchiito, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english=" Yeah! We're here!", french=" Ouais! Nous sommes là!", german=" Juchhu! Wir sind hier!", italian=" Sì! Eccoci qua!", spanish=" ¡Sí, ya estamos!"})
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="We reached the 6th Station\nClearing before you, so we made another base!", french="On est arrivés à la trouée du\n6[F:E] Relais avant vous, alors on a\nétabli un autre campement.", german="Wir haben hier auf der\n6. Zwischenlagerlichtung eine Basis errichtet!", italian="Abbiamo raggiunto il Bivacco 6\nprima di voi e così abbiamo costruito un altro\ncampo base!", spanish="Llegamos a la Base del Sexto\nPuerto primero, así que hemos levantado\notro campamento."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Yes!\nThank you so much, as always!", french="Merveilleux!\nMerci beaucoup, encore une fois!", german="Jawoll!\nVielen Dank euch! Wie immer!", italian="Evviva!\nGrazie mille, come sempre!", spanish="Es cierto.\nComo siempre, ¡muchas gracias!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="But you know...from here on, the\nmountain is covered with snow. We can't\nreally set up any more bases.", french="Mais vous savez... ici, la neige\ncommence à tout recouvrir, alors on ne peut\nplus établir de nouveau campement.", german="Aber wisst ihr... Von hier an\nist der Berg mit Schnee bedeckt. Daher können\nwir keine weitere Basis errichten.", italian="Però... da questo punto in poi\nil sentiero è coperto di neve, quindi non\npossiamo più costruirne altri.", spanish="Lo que pasa es que a partir de aquí\nla montaña está cubierta de nieve, así que\nno podemos levantar más campamentos."})
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="So from here on, you have to\nclimb on your own. Sorry.", french="A partir d'ici, vous ne pourrez\ncompter que sur vous-mêmes. Désolé.", german="Daher seid ihr von hier an\nauf euch allein gestellt. Tut mir leid.", italian="Da qui in poi dovrete proseguire\nper conto vostro. Ci dispiace!", spanish="Así que a partir de aquí tendréis\nque ascender sin nuestra ayuda. Lo siento."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="No problem at all. We're glad\nyou were able to make bases up to this point.\nThey'll be a great help.", french="Pas de problème. Nous vous\nsommes déjà reconnaissants d'avoir établi des\ncampements jusqu'ici. Ils sont très utiles.", german="Überhaupt kein Problem. Wir\nsind froh, dass ihr überhaupt Basen errichtet\nhabt. Sie werden gute Dienste leisten.", italian="Non c'è nessun problema. Vi\nringraziamo di aver costruito dei campi base\nfino a qui. Ci sono stati di grande aiuto.", spanish="No hay problema. Bastante\nhabéis hecho levantando campamentos\nhasta aquí. ¡Nos serán de gran ayuda!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english=" Heh-heh. You're welcome.", french=" Hé hé. C'était un plaisir.", german=" Hihi. War uns eine Ehre.", italian=" Eh eh. Non c'è di che.", spanish=" Je, je... Ha sido un placer."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kinogassa, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="Oh, that's right. From here on,\nwe're going to make a serious effort to reach\nthe summit.", french="Bien, trêve de bavardage.\nA partir d'ici, nous allons redoubler d'efforts\npour atteindre le sommet.", german="Oh, das stimmt.\nVon hier an werden wir uns wirklich\nanstrengen, den Gipfel zu erreichen.", italian="Oh, già. Da qui in poi,\nci impegneremo al massimo\nper raggiungere la cima.", spanish="Lo cierto es que a partir de\naquí tendremos que esforzarnos mucho para\nllegar hasta la cima."})
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english=" See you along the path!", french=" On se reverra en chemin!", german=" Wir sehen uns auf dem Weg!", italian=" Ci vediamo in giro!", spanish=" ¡Ya nos veremos por el camino!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Yep! See you there!", french=" Oui! A bientôt!", german=" Jau! Bis dahin!", italian=" Sì! A presto!", spanish=" ¡Sí, nos vemos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english=" All right, we're off!", french=" Allez, on y va!", german=" Okay, lasst uns gehen!", italian=" Bene, andiamo!", spanish=" Bueno, pues nosotros nos vamos."})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_goorikii, 228, 172, false, 2)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_kuchiito, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_kinogassa, Direction.UpRight)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(npc_npc_kinogassa, 228, 172, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_kuchiito, 228, 172, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 284, 324, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 172, 324, false, 2) end end
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.cleanup_npcs()
end
