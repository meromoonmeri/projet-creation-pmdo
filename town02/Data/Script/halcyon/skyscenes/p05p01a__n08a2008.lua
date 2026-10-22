-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P05P01A/n08a2008.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="All right![K] Made it through\nthe dungeon!", french="Victoire![K] Nous voilà sortis\nde ce donjon.", german="Sehr gut![K]\nDen Dungeon hätten wir geschafft!", italian="Bene![K] Siamo arrivati in fondo\nal dungeon!", spanish="¡Muy bien![K] ¡Hemos superado\nel territorio!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 208, 232, Direction.Up, "NPC_YONOWAARU")
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="What you see over there is\nthe pinnacle, [CS:Y]Grovyle[CR].", french="Regarde. Le pinacle est là-bas,\n[CS:Y]Massko[CR].", german="Dort drüben kannst du die Spitze\nsehen, [CS:Y]Reptain[CR].", italian="Quella che vedi lassù, [CS:Y]Grovyle[CR],\nè la vetta.", spanish="Lo que se ve allí es la cúspide,\n[CS:Y]Grovyle[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Got it![K] Let's go!", french=" Compris![K] Allons-y!", german=" Alles klar![K] Dann mal los!", italian=" Bene![K] Andiamo!", spanish=" ¡Entendido![K] ¡Vamos allá!"})
  -- message_Close
  -- back_SetGround(LEVEL_P05P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  -- SetOutputAttribute(8) [neutre/état moteur]
  local npc_npc_yonowaaru_n8 = SkySceneKit.spawn_npc("dusknoir", 224, 472, Direction.Up, "NPC_YONOWAARU_N8")
  -- SetOutputAttribute(8) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- bgm2_PlayFadeIn(BGM_ON_THE_CEILING) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 180, 308, false, 2)
  GAME:WaitFrames(55)
  GROUND:MoveToPosition(npc_npc_yonowaaru_n8, 220, 332, false, 2)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(50)
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Down)
  GAME:WaitFrames(25)
  pcall(function() GAME:MoveCamera(204, 248, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 180, 252, false, 2)
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.DownRight)
  GAME:WaitFrames(50)
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.DownLeft)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Down)
  GAME:WaitFrames(10)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_yonowaaru_n8.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n8, p.X+(0), p.Y+(-14), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(40)
  GROUND:MoveToPosition(npc_npc_yonowaaru_n8, 220, 252, false, 2)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(50)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(40)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...[K]Nobody's...[K]here, huh...", french=" ...[K] Il n'y a...[K] personne...", german=" ...[K]Hier ist...[K] niemand...", italian="... Uh?[K] Ma qui...[K] non c'è\nnessuno...", spanish=" ¡Pero bueno!...[K] Aquí no hay...[K] nadie."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yonowaaru_n8.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n8, p.X+(8), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.UpRight)
  GAME:WaitFrames(40)
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.DownRight)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" That's very strange...", french=" Voilà qui est fort étrange...", german=" Das ist sehr merkwürdig...", italian=" È molto strano...", spanish=" Qué raro..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Right)
  GAME:WaitFrames(6)
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.UpRight)
  GAME:WaitFrames(6)
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Up)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Master [CS:N]Dialga[CR] is always\nover there.", french="Maître [CS:N]Dialga[CR] ne quitte jamais\ncet endroit, d'habitude.", german="Dort drüben residiert\nMeister [CS:N]Dialga[CR].", italian=" Il Maestro [CS:N]Dialga[CR] è sempre qui.", spanish=" [CS:N]Dialga[CR] siempre está ahí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Why isn't [CS:N]Dialga[CR]\nthere now?", french="Comment se fait-il qu'il ne soit\npas là?", german=" Warum ist [CS:N]Dialga[CR] jetzt nicht da?", italian=" E come mai ora non c'è?", spanish=" ¿Dónde puede estar ahora mismo?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:N]Sableye[CR] said that [CS:N]Dialga[CR] would\nsend a final agent.", french="[CS:N]Ténéfix[CR] a dit que [CS:N]Dialga[CR]\nallait envoyer un dernier agent.", german="[CS:N]Zobiris[CR] hat gesagt, dass [CS:N]Dialga[CR]\neinen letzten Zeitreisenden schicken wollte.", italian="I [CS:N]Sableye[CR] hanno detto che [CS:N]Dialga[CR]\navrebbe scelto un agente per affidargli\nuna missione decisiva.", spanish="Ese [CS:N]Sableye[CR] dijo que [CS:N]Dialga[CR]\nenviaría a tu sustituto al pasado."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But to send another agent back\nto the past...", french="Mais, pour envoyer un autre\nserviteur dans le passé...", german="Aber ein weiteres Pokémon\nin die Vergangenheit zu schicken...", italian=" Ma per rispedirlo nel passato...", spanish="Pero enviar otro Pokémon\nal pasado..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I expect it would take an\nenormous amount of power.", french="... il va avoir besoin d'une\nénorme réserve de puissance.", german="Das dürfte eine enorme Menge\nKraft kosten.", italian="... è necessaria un'enorme\nquantità di energia.", spanish="Supongo que requeriría\nuna inmensa cantidad de energía."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="To generate that kind of power...[K]\n[CS:N]Dialga[CR] would have to hold still for some time...", french="Et pour générer une telle\npuissance...[K] [CS:N]Dialga[CR] a besoin de se ménager\nun certain temps au préalable...", german="Um eine derartige Kraft zu\nerzeugen...[K] muss sich [CS:N]Dialga[CR]\nfür einige Zeit zurückziehen...", italian="Per generarla...[K] [CS:N]Dialga[CR] dovrebbe\nrimanere immobile per un certo periodo\ndi tempo...", spanish="Para generar toda esa energía...[K]\n[CS:N]Dialga[CR] tendría que estar parado un tiempo..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I thought he was in\n[CS:P]Temporal Tower[CR]...", french="Je le croyais à la [CS:P]Tour\ndu Temps[CR]...", german="Ich bin davon ausgegangen,\nihm im [CS:P]Zeitturm[CR] zu begegnen...", italian="Quindi pensavo che si trovasse\nnella [CS:P]Torre del Tempo[CR]...", spanish="Pensaba que estaría en la\n[CS:P]Torre del Tiempo[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Your guess is correct.[K]\nI thought so too...", french="A raison, d'ailleurs.[K]\nJe le croyais, moi aussi...", german="Diese Ahnung war naheliegend.[K]\nAuch ich habe das erwartet...", italian=" Hai ragione.[K] Lo pensavo anch'io...", spanish="Eso sería lo lógico.[K]\nYo también lo esperaba..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I thought so...[K]\nThat should be right...", french="Je le croyais et...[K]\nce devrait être le cas...", german="Das dachte ich...[K]\nEs ist so naheliegend...", italian="Infatti...[K]\nDovrebbe essere così...", spanish=" Eso creía...[K] Así tendría que ser."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" ...[K]However...", french=" ...[K] Cependant...", german=" ...[K]Aber...", italian=" ...[K] Comunque...", spanish=" Aunque...[K] ahora que lo pienso..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="If he's going to send an agent\nback to the past...[K]there's another method.", french="... s'il cherche à envoyer un\nautre serviteur dans le passé...[K] il existe\nun autre moyen de le faire.", german="Wenn es einen Gehilfen in die\nVergangenheit schicken will,[K]\ngibt es auch eine andere Methode.", italian="Se vuole inviare un agente\nnel passato...[K] esiste un altro metodo.", spanish="Si va a mandar un Pokémon al\npasado...[K] lo puede hacer de otra forma."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Back to the past...[K]\nAnother method?", french="Dans le passé...[K]\nQuel autre moyen?", german="In die Vergangenheit zurück...[K]\nEine andere Methode?", italian="Nel passato...[K]\nUn altro metodo?", spanish="¿Cómo?[K] ¿Hay otra forma de hacer\nun viaje en el tiempo?"})
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Left)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="That's right...[K] If he needs to\nsend the agent through time...", french="Eh bien...[K] cela me paraît\npourtant clair...", german="So ist es...[K] Wenn ein\nPokémon von ihm durch die Zeit geschickt\nwerden muss...", italian="Esatto...[K] Per organizzare\nun viaggio nel tempo...", spanish="En efecto...[K] Si necesita mandar\na mi sustituto al pasado..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CS:Y]Grovyle[CR]...[K]you should know what\nmethod I'm talking about.", french="[CS:Y]Massko[CR]...[K] S'il y a bien quelqu'un\nqui devrait le savoir, c'est toi.", german="[CS:Y]Reptain[CR]...[K] Eigentlich solltest du\nwissen, von welcher Methode ich rede.", italian="[CS:Y]Grovyle[CR]...[K] dovresti sapere\ndi quale metodo sto parlando.", spanish="[CS:Y]Grovyle[CR]...[K] Precisamente tú\ndeberías saber de qué método estoy hablando."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I-I...[K]should know what method?", french="Moi?[K] Qu'est-ce que je devrais\nsavoir?", german="I-ich...[K]\nIch soll die andere Methode kennen?", italian=" I-Io...[K] dovrei saperlo?", spanish=" Yo...[K] ¿debería saberlo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" N-no...[K] It can't be!", french=" Non...[K] Ne me dis pas...!", german=" N-nein...[K] Das kann nicht sein!", italian=" N-No...[K] Non può essere!", spanish=" No...[K] ¡No me lo digas!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" The Passage of Time!?", french=" Le Couloir du Temps?!", german=" Der Zeittunnel?!?", italian=" Il Portale del Tempo?!", spanish=" ¡¿El Pasaje del Tiempo?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Yes.[K] The Passage of Time.", french=" Tout juste.[K] Le Couloir du Temps.", german=" Ja.[K] Der Zeittunnel.", italian=" Esatto.[K] Il Portale del Tempo.", spanish=" Sí.[K] El Pasaje del Tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Rather than waiting for Master\n[CS:N]Dialga[CR] to regenerate...", french="Plutôt que d'attendre que Maître\n[CS:N]Dialga[CR] ait repris des forces...", german="Anstatt darauf zu warten, dass\ndie Kräfte von Meister [CS:N]Dialga[CR] wieder\nausreichend hergestellt sind...", italian="Invece di aspettare che\nil Maestro [CS:N]Dialga[CR] recuperi le sue energie...", spanish="En lugar de esperar a que [CS:N]Dialga[CR]\nacumule energía..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="They will most likely look for\n[CS:N]Celebi[CR] and use the Passage of Time\nto send the agent back to the past.", french="... ils vont sans doute chercher\n[CS:N]Celebi[CR] pour envoyer le nouveau serviteur\ndans le passé via le Couloir du Temps.", german="Sie werden wohl eher [CS:N]Celebi[CR]\nsuchen und den Zeittunnel verwenden, um den\nZeitreisenden in die Vergangenheit zu schicken.", italian="... è più probabile che cerchino\n[CS:N]Celebi[CR] e usino il Portale del Tempo per spedire\nl'agente nel passato.", spanish="Probablemente buscarán a\n[CS:N]Celebi[CR] y querrán usar el Pasaje del Tiempo\npara enviar a mi sustituto al pasado."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" I'm sure of it.", french=" J'en ai la certitude.", german=" Da bin ich mir sicher.", italian=" Ne sono sicuro.", spanish=" Estoy convencido de ello."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Master [CS:N]Dialga[CR]...[K]probably left\nhere to catch [CS:N]Celebi[CR].", french="Maître [CS:N]Dialga[CR]...[K] est sûrement\naux trousses de [CS:N]Celebi[CR] en ce moment même.", german="Meister [CS:N]Dialga[CR]...[K] dürfte\naufgebrochen sein, um [CS:N]Celebi[CR] zu fangen.", italian="Forse il Maestro [CS:N]Dialga[CR]...[K] ha\nlasciato questo posto per catturare [CS:N]Celebi[CR].", spanish="[CS:N]Dialga[CR]...[K] sin duda se ha marchado\npara atrapar a [CS:N]Celebi[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:N]D-Dialga[CR]...left to catch\n[CS:N]Celebi[CR]!?", french="[CS:N]D-Dialga[CR]... aux trousses\nde [CS:N]Celebi[CR]!?", german="[CS:N]D-Dialga[CR]... auf dem Weg,\n[CS:N]Celebi[CR] zu fangen?!?", italian="[CS:N]D-Dialga[CR]... se n'è andato\nper catturare [CS:N]Celebi[CR]!?", spanish="[CS:N]Di[CR]... [CS:N]Dialga[CR]... ¡¿se ha ido\npara atrapar a [CS:N]Celebi[CR]?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="B-but...[K] I don't think it will be\nthat easy to catch [CS:N]Celebi[CR]...", french="Mais...[K] il est impossible\nde capturer [CS:N]Celebi[CR]...", german="A-aber...[K] Ich glaube nicht, dass\nes so einfach ist, [CS:N]Celebi[CR] zu fangen...", italian="M-Ma...[K] non credo che sia così\nfacile catturare [CS:N]Celebi[CR]...", spanish="Pero...[K] no creo que sea tan fácil\natrapar a [CS:N]Celebi[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="If it were just the [CS:N]Sableye[CR],\nyou'd be right...", french="Certes, s'il n'y avait que les\n[CS:N]Ténéfix[CR] à la poursuivre...", german="Die [CS:N]Zobiris[CR] stellen keine\nnennenswerte Gefahr für es dar...", italian="Se si trattasse solo dei [CS:N]Sableye[CR],\nti darei ragione...", spanish="Si fueran solo los [CS:N]Sableye[CR]\nno te lo discutiría..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="However, it is a different story\nif Master [CS:N]Dialga[CR] himself went to catch her.", french="Cela dit, si Maître [CS:N]Dialga[CR] s'en\nmêle... ce ne sera pas la même histoire.", german="Aber wenn sich Meister [CS:N]Dialga[CR]\nselbst auf den Weg gemacht hat, es zu fangen,\nsieht die Sache schon wieder anders aus.", italian="... ma se è il Maestro [CS:N]Dialga[CR]\nin persona a mettersi sulle sue tracce, allora\nla situazione cambia radicalmente.", spanish="Sin embargo, sería muy distinto\nsi fuese el mismísimo [CS:N]Dialga[CR] el que saliera\na atraparla."})
  -- message_KeyWait
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="And that new henchman...[K]\nI'm worried about their ability...", french="Quant au nouveau bras droit,[K]\nje me pose bien des questions au sujet de\nses \"multiples talents\"...", german="Und dann dieser neue Gehilfe...[K]\nIch mache mir Sorgen, was sie zusammen\nanstellen könnten...", italian="E poi c'è il nuovo servitore...[K]\nSono preoccupato per quello che può essere\nin grado di fare...", spanish="Y su nueva mano derecha...[K]\nMe preocupa lo que puedan hacer..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:P]Dusk Forest[CR]!", french=" La [CS:P]Forêt Crépuscule[CR]!", german=" [CS:P]Düsterwald[CR]!", italian=" La [CS:P]Foresta Oscura[CR]!", spanish=" ¡El [CS:P]Bosque Sombrío[CR]!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I always met [CS:N]Celebi[CR] in\n[CS:P]Dusk Forest[CR]!", french="J'y ai toujours trouvé [CS:N]Celebi[CR],\nchaque fois que je la cherchais!", german="Ich bin [CS:N]Celebi[CR] immer im\n[CS:P]Düsterwald[CR] begegnet!", italian="Mi sono sempre incontrato\ncon [CS:N]Celebi[CR] nella [CS:P]Foresta Oscura[CR]!", spanish="¡Siempre me he encontrado con\n[CS:N]Celebi[CR] en el [CS:P]Bosque Sombrío[CR]!"})
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(160), false, 2) end
  GAME:WaitFrames(8)
  do local p=npc_npc_yonowaaru_n8.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n8, p.X+(0), p.Y+(160), false, 2) end
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
