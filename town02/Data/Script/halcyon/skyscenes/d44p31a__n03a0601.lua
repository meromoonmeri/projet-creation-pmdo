-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D44P31A/n03a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=42, sub=4} -- $SCENARIO_SIDE = scn[42,4] (ROM)
  local npc_npc_aamarudo = SkySceneKit.spawn_npc("armaldo", 248, 552, Direction.Up, "NPC_AAMARUDO")
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" ...[K]We've come pretty far...", french="...[K] On a fait un bon bout\nde chemin...", german=" ...[K]Wir sind so weit gekommen...", italian="...[K] Abbiamo fatto parecchia\nstrada...", spanish=" Bueno...[K] Hemos avanzado bastante..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="The treasure...[K]I wonder\nwhere it is...", french="Le trésor...[K] Je me demande\noù il est...", german="Der Schatz...[K]\nWo mag er nur sein?", italian="Il tesoro...[K] Chissà dove\nsi trova...", spanish="Me pregunto...[K] dónde estará\nel tesoro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Oh![K] Can you see that light\nover there?!", french="Oh![K] Vous voyez cette lumière\nlà-bas?!", german="Oh![K] Kannst du das Licht dort\ndrüben sehen?!?", italian="Oh![K] Vedi anche tu quella\nluce laggiù?!", spanish=" ¡Anda![K] ¡¿Ves esa luz de ahí?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Let's go check it out!", french=" Allons voir ça de plus près!", german=" Lass es uns mal untersuchen!", italian=" Andiamo a dare un'occhiata!", spanish=" ¡Vamos a ver qué es!"})
  -- message_Close
  -- back_SetGround(LEVEL_D44P31A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 212, 428, false, 2)
  GROUND:MoveToPosition(npc_npc_aamarudo, 244, 428, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Wooooahhhh! ♪ Amaaaazing! ♪", french=" Ouuuuaaaah! ♪ C'est fouuuu! ♪", german=" Booooah! ♪ Unglaublich! ♪", italian=" Uoooahhh! ♪ Fantaaastico! ♪", spanish=" ¡Guaaaaaau! ♪ ¡Qué pasada! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Wh-what's...[K]this?!", french=" Qu'est-ce que...[K] c'est?!", german=" W-was...[K] ist das?!?", italian=" C-Cos'è...[K] questo?!", spanish=" Qué...[K] ¡¿Qué es esto?!"})
  -- message_Close
  -- bgm2_PlayFadeIn(BGM_FIRE_CRACKLING) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() GAME:MoveCamera(228, 192, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(90)
  GROUND:MoveToPosition(hero, 212, 316, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(npc_npc_aamarudo, 244, 316, false, 2)
  pcall(function() GAME:MoveCamera(228, 308, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Wow![K] This is so amazing! ♪", french="Ouah![K]\nC'est complètement fou! ♪", german=" Boah![K] Das ist so unglaublich! ♪", italian=" Wow![K] È favoloso! ♪", spanish=" ¡Guau![K] ¡Es increíble! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharTurnToCharAnimated(hero, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" There's a door on the front here.", french=" Il y a une porte, là.", german="Sieh nur!\nHier vorne ist eine Tür.", italian=" C'è una porta lì davanti a noi.", spanish=" Ahí hay una puerta."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I think the treasure's past that\ndoor, don't you?", french="Je pense que le trésor se\ntrouve derrière cette porte, pas vous?", german="Der Schatz wird sich wohl\nhinter der Tür befinden, oder?", italian="Secondo me il tesoro si nasconde\nlì dietro, che ne pensi?", spanish="Yo diría que el tesoro está\ntras esa puerta, ¿no crees?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hurry! Let's go! Let's go! ♪", french="Dépêchons-nous!\nEn avant! En avant! ♪", german="Nun los! Gehen wir!\nGehen wir! ♪", italian=" Presto! Andiamo! Andiamo! ♪", spanish=" ¡Deprisa! ¡Venga, vamos ya! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-24), false, 2) end
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "shock", 1) end)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" W-wait! Junior!", french=" A-attends! Petit!", german=" W-warte! Junior!", italian=" A-Aspetta, piccolo!", spanish=" Es... ¡espera, peque!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Whaaat?", french=" Quoiiii?", german=" Was denn?", italian=" Cooosa?", spanish=" ¿Qué pasa? ¡Estoy impaciente!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Didn't you notice the design of\nthis room?", french="N'as-tu pas remarqué la\nconfiguration particulière de cette pièce?", german="Ist dir an dem Aufbau dieses\nRaums gar nichts aufgefallen?", italian="Non hai visto com'è fatta\nquesta sala?", spanish="¿No te has fijado en la distribución\nde esta sala?"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Look carefully![K] There's some\nkind of trick to it!", french="Fais bien attention![K] Il doit y\navoir un truc derrière tout ça!", german="Sieh mal genau hin![K] Es gibt da\neine Art Trick!", italian="Guarda attentamente![K] Ci deve\nessere una specie di trabocchetto!", spanish="Mira con atención.[K] Tiene algún\ntipo de trampa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Trick?", french=" Un truc?", german=" Trick?", italian=" Trabocchetto?", spanish=" ¿Trampa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Yes.", french=" Oui.", german=" Ja.", italian=" Sì.", spanish=" Sí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="I'm pretty sure that there will\nbe treasure behind that door, but...", french="Je suis quasiment certain qu'un\ntrésor nous attend derrière\ncette porte, mais...", german="Ich bin mir ziemlich sicher, dass\nder Schatz sich hinter der Tür befindet, aber...", italian="Sono piuttosto sicuro che dietro\nquella porta ci sia un tesoro, ma...", spanish="Estoy bastante seguro de que\ntras esa puerta habrá algún tesoro, pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="The trouble is, we need to figure\nout how to open that door.", french="... le problème, c'est que nous\ndevons d'abord trouver comment l'ouvrir.", german="Nun, wir müssen herausfinden,\nwie wir diese Tür öffnen können.", italian="... prima dobbiamo capire\ncome aprirla.", spanish="El problema es que tenemos que\naveriguar cómo se abre."})
  -- message_Close
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  pcall(function() GAME:MoveCamera(228, 192, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end) -- message_SetActor(ACTOR_NPC_AAMARUDO)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Look above the door.[K] You see\nthat symbol that kind of looks like an eye?", french="Regarde au-dessus de la porte.[K]\nTu vois ce motif qui ressemble à un œil?", german="Schau mal, oberhalb der Tür.[K]\nSiehst du das augenähnliche Symbol dort?", italian="Guarda sopra la porta.[K] Vedi\nquel simbolo che assomiglia a un occhio?", spanish="Mira encima de la puerta.[K] ¿Ves\nese símbolo que parece como un ojo?"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="I think if we put some kind of\nrock or something in there, something will\nprobably happen...[K] But...", french="Je pense qu'en plaçant une\npierre ou autre à l'intérieur, quelque\nchose devrait se produire...[K] Mais...", german="Ich denke, wenn wir dort einen\nFels oder ähnliches hineinstecken, wird das\netwas auslösen...[K] Aber...", italian="Se ci inseriamo una roccia\no qualcosa di simile, forse attiveremo\nun congegno...[K] Però...", spanish="Creo que, si ponemos una piedra\no algo así, ahí pasará algo...[K] Pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="There's those giant logs on both\nsides...[K] And all these little openings\nin the floor have caught my attention...", french="... il y a aussi les deux rondins,\nde chaque côté...[K] Les trous au sol\nsont suspects aussi...", german="Dann gibt es dort noch die zwei\ngroßen Baumstämme auf beiden Seiten...[K] Und\ndiese Öffnungen im Boden sind verdächtig...", italian="Ci sono quei tronchi giganti su\nentrambi i lati...[K] E ho subito notato tutte\nquelle piccole aperture sul pavimento...", spanish="Luego están esos troncos gigantes\nde los lados...[K] Y todos esos orificios del suelo\nme escaman bastante..."})
  -- message_Close
  pcall(function() GAME:MoveCamera(180, 324, 60, false) end) -- performer/caméra
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Left)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end) -- message_SetActor(ACTOR_NPC_AAMARUDO)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="That pillar over there...[K]and a\nweird switch along the groove...", french="Ce pilier aussi...[K] Et il y a\nun étrange interrupteur au bord de\ncette fosse...", german="Der Pfeiler dort drüben...[K] Und\nein eigenartiger Schalter am Ende der Spalte...", italian="Quella colonna laggiù...[K] e quello\nstrano interruttore sulla scanalatura...", spanish="Esa columna de ahí...[K] Y ese\ninterruptor tan raro de la hendidura..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="If we move that pillar along\nthat track on top of the switch on the floor,\nsomething's gonna happen...", french="Si on déplace le pilier le long\nde la fosse pour le placer sur l'interrupteur,\nquelque chose devrait se produire...", german="Wenn wir diesen Pfeiler entlang\nder Bahn auf den Schalter bewegen, wird\nwohl etwas geschehen...", italian="Se spostiamo quella colonna\nlungo il solco in cima all'interruttore\nsul pavimento, accadrà qualcosa...", spanish="Si movemos la columna por\nla hendidura hasta encajarla encima del\ninterruptor, seguro que pasa algo..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="This is a pretty common layout...[K]\nThis kind of trap is usually easy to identify.", french="C'est classique...[K]\nCe genre de mécanisme est en général\nassez facile à identifier.", german="Eigentlich ist es ein geradezu\nklassischer Aufbau...[K] Diese Art Falle ist\nnormalerweise recht einfach zu erkennen.", italian="È uno schema piuttosto\ncomune...[K] Trappole come queste sono\nfacili da individuare.", spanish="Es una trampa muy habitual...[K]\nPor eso suele ser fácil de identificar."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="And...[K] These spikes here on the\nwall...[K] Look at them--they've definitely caught\nmy attention...", french="Et...[K] tu vois ces piques,\nsur le mur?[K] Regarde bien... Elles aussi,\nelles doivent servir à quelque chose.", german="Und...[K] Diese Stacheln in der\nWand...[K] Sieh sie dir an. Die sind mir gleich\nzu Anfang aufgefallen...", italian="E poi...[K] queste punte sul muro...[K]\nGuardale... mi sono insospettito appena\nle ho viste...", spanish="Y...[K] esos pinchos de la pared...[K]\nMíralos, la verdad es que son bastante\nsospechosos."})
  -- message_Close
  pcall(function() GAME:MoveCamera(284, 252, 60, false) end) -- performer/caméra
  GROUND:EntTurn(npc_npc_aamarudo, Direction.UpRight)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(hero) end) -- message_SetActor(ACTOR_PLAYER_PUPURIN)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" What's this crystal here?", french=" C'est quoi ce cristal, là?", german="Was ist das hier für ein\nKristall?", italian=" Cosa sarà questo cristallo?", spanish=" ¿Qué son esos cristales de ahí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end) -- message_SetActor(ACTOR_NPC_AAMARUDO)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="If you hit this crystal,\nsomething's gonna happen.", french="Si tu touches ce cristal,\nça déclenchera quelque chose.", german="Wenn du gegen diesen Kristall\nstößt, wird etwas passieren.", italian="Forse se lo colpisco succederà\nqualcosa.", spanish="Uf, si los golpeas, seguro que\nocurrirá algo."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="The crystal's color will probably\nchange and something will come up from the\nfloor...or something...", french="J'imagine que la couleur du\ncristal changera et que quelque chose\nsortira du sol... ou un truc dans le genre...", german="Vielleicht ändert sich die Farbe\ndes Kristalls und etwas taucht aus dem Boden\nauf oder so...", italian="Probabilmente il suo colore\ncambierà e spunterà fuori qualcosa dal\npavimento... o una roba simile...", spanish="Seguramente cambie el color del\ncristal y salga algo del suelo, por ejemplo."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" I think that's how it works.", french="Oui, je pense que c'est comme ça\nque ça fonctionne.", german="Ich glaube, so wird es\nfunktionieren.", italian="Credo che funzioni in questo\nmodo.", spanish="Gracias a mi dilatada experiencia\ncomo explorador, diría que funciona así."})
  -- message_Close
  pcall(function() GAME:MoveCamera(228, 276, 60, false) end) -- performer/caméra
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Up)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end) -- message_SetActor(ACTOR_NPC_AAMARUDO)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="And this...[K] It looks like this\ncontraption is important somehow...", french="Et ça...[K] Je pense que ce\nmachin-là doit aussi avoir son importance...", german="Und hier...[K] Sieht fast so aus,\nals sei diese Vorrichtung auch noch irgendwie\nwichtig...", italian="E questo...[K] Sembra che anche\nquesto aggeggio abbia una qualche funzione...", spanish="Y esto...[K] Este artilugio parece\nimportante, no sé por qué."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="It's pretty suspicious to find\nsuch a puzzling thing in a place like this.", french="C'est plutôt suspect de trouver\nun mécanisme aussi déconcertant\ndans un tel endroit.", german="Schon verdächtig, ein derart\nvertracktes Ding an einem solchen Ort zu\nfinden.", italian="È molto strano trovare qualcosa\ndi così elaborato in un posto del genere.", spanish="Me huele a chamusquina que haya\nalgo tan raro en un lugar como este."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="The more I think about it,\nthe more it seems like someone has gone to an\nawful lot of trouble to keep people out...", french="On dirait que quelqu'un s'est\nvraiment donné du mal pour empêcher les\nintrus d'entrer là-dedans...", german="Je mehr ich darüber nachdenke,\ndesto klarer wird, dass sich jemand wirklich\nMühe gegeben hat, das alles hier abzuriegeln...", italian="Più ci penso e più mi convinco\nche qualcuno si sia dato un gran disturbo\nper tenere alla larga i curiosi...", spanish="Cuanto más lo pienso, más claro\ntengo que parece que alguien se ha tomado\nmuchas molestias para que nadie pase."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(160) end)
  -- bgm2_PlayFadeIn(BGM_FIRE_CRACKLING) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() GAME:MoveCamera(228, 308, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="It takes a trained eye to spy out\nall these ingenious devices.", french="Il faut un œil aguerri pour\ndéceler tous les détails de cet\ningénieux mécanisme.", german="Es bedarf eines geübten Auges,\nall diese Mechanismen zu entdecken.", italian="Ci vuole un occhio allenato\nper riconoscere tutti questi dispositivi\ningegnosi.", spanish="Hace falta mucha perspicacia\npara advertir estos dispositivos tan ingeniosos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I see![K] So, we should go around\nand try everything! ♪", french="Compris![K] Alors il faut faire\ntout le tour et tout toucher! ♪", german="Verstehe![K] Also sollten wir\numhergehen und alles ausprobieren! ♪", italian="Ho capito![K] Allora dovremmo\nprovarle un po' tutte! ♪", spanish="¡Ya entiendo![K] ¡Pues habrá que\ntoquetearlo todo! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_aamarudo, Direction.UpLeft)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "sweating", 1) end)
  GROUND:EntTurn(hero, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="N-no![K] That might prevent the\ndoor from ever opening!", french="Non, malheureux![K] Ça pourrait\ncondamner la porte à jamais!", german="N-nein![K] Auf diese Art könnte die\nTür für immer verschlossen werden!", italian="N-No![K] In questo modo potremmo\nrischiare di non riuscire ad aprire la porta!", spanish="¡No, no![K] ¡Así quizá la puerta\nno se abra nunca!"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" There are traps too!", french=" Et en plus, il y a des pièges!", german=" Und dann noch die ganzen Fallen!", italian=" E poi ci sono delle trappole!", spanish=" ¡Y podríamos accionar las trampas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Is that so? I see...", french=" Ah bon? D'accord...", german=" Wirklich? Ich verstehe...", italian=" Ah sì? Capisco...", spanish=" ¿Ah, sí? Pues qué rollo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Anyway...[K] This room is full\nof dangers.", french="En somme...[K] ce lieu regorge\nde dangers.", german="Wie auch immer...[K] Dieser Raum\nsteckt voller Gefahren.", italian="Comunque...[K] Questa stanza\ntrabocca di pericoli.", spanish="Como no tienes mi experiencia,[K]\nte cuesta entender que esta sala está\nrepleta de peligros."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="We really need to proceed with\ncaution here.", french="Il nous faut procéder avec\nla plus extrême prudence.", german="Wir sollten wirklich vorsichtig\nweitermachen.", italian=" Dobbiamo fare molta attenzione.", spanish="Por eso tenemos que actuar\ncon la máxima cautela."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep. Got it! ♪", french=" Voui. Compris! ♪", german=" Ja. Verstanden! ♪", italian=" Ok. Capito! ♪", spanish=" Vale. ¡Entendido! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yay! ♪", french=" Youpla! ♪", german=" Juchhu! ♪", italian=" Oooh! ♪", spanish=" ¡Yupi! ♪"})
  GAME:WaitFrames(60)
  pcall(function() GAME:MoveCamera(228, 212, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 228, 180, false, 2)
  GAME:WaitFrames(20)
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "shock", 1) end)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Up)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Aaah! Huh... WHAT?!", french=" Aaah! Hein... QUOI?!", german=" Aaah! Ähh... WAS?!?", italian=" Aaah! Eh... COSA?!", spanish=" ¡Aaah! Espera... ¡¿Qué haces?!"})
  GAME:WaitFrames(60)
  -- message_CloseEnforce
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" YOOM...TAH!", french=" TA-DAAAAA!", german=" LUUUU... FIIII!", italian=" BADABUM!", spanish=" ¡Vaaaamos!"})
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- message_CloseEnforce
  GAME:WaitFrames(2) -- join WaitSe
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- GAP: se_Play(7435) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 15) -- screen_WhiteOut
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(90)
  GAME:FadeIn(30)
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(9734) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() GAME:MoveCamera(684, 212, 1, false) end) -- SetPositionMark performer/caméra
  GROUND:TeleportTo(hero, 684, 180, Direction.Down)
  GROUND:TeleportTo(npc_npc_aamarudo, 700, 316, Direction.Down)
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "shock", 1) end)
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I did it! ♪ I opened it! ♪", french="J'ai réussi! ♪\nJe l'ai ouverte! ♪", german="Geschafft! ♪\nIch habe sie geöffnet! ♪", italian=" Ce l'ho fatta! ♪ L'ho aperta! ♪", spanish="¡Lo he conseguido! ♪\n¡Se ha abierto! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_aamarudo, 700, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Wh-what the...?!", french=" P-par la barbe de...?!", german=" W-was zum...", italian=" M-Ma cosa...?!", spanish=" ¡¿Pero cómo...?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hurry! Let's go! ♪", french=" Vite, vite! On y va! ♪", german=" Beeilung! Gehen wir weiter! ♪", italian=" Forza! Andiamo! ♪", spanish=" ¡Venga, deprisa! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="... (What in the world IS\nthis kid?!)", french=" ... (Mais bon sang, qui est-il?!)", german="...(Was um alles in der Welt\nist los mit diesem Bengel?!?)", italian="... (Ma come... Ma chi è\nquesto bambino?!)", spanish="Increíble... (¡¿Pero qué misterio\nesconde este crío?!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hey, hurry! ♪", french=" Hé, vite, vite! ♪", german=" Nun mach schon! ♪", italian=" Ehi, sbrigati! ♪", spanish=" ¡Oye, date prisa! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" G-got it.", french=" D-d'accord.", german=" N-na klar.", italian=" V-Va bene.", spanish=" Va... vale."})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_aamarudo, 684, 140, false, 1)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 684, 140, false, 2)
  GAME:WaitFrames(45)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(60)
  GAME:WaitFrames(60)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT_SIDE = 4 -- $COMPULSORY_SAVE_POINT_SIDE = 4 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
