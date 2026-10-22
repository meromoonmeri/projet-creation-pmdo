-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/n01a0503.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  -- back_SetGround(LEVEL_T01P02A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(4) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_kakureon1 = SkySceneKit.spawn_npc("kecleon", 328, 168, Direction.Down, "NPC_KAKUREON1")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_kakureon2 = SkySceneKit.spawn_npc("kecleon", 352, 168, Direction.Down, "NPC_KAKUREON2")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- bgm_ChangeVolume(60,256) [volume BGM non scriptable en Lua PMDO: piste maintenue - documenté]
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Sniff...[K] This is the emergency\nmoney I got from Mama.", french="Snif...[K] C'est l'argent que m'man\nm'a filé en cas de coup dur.", german="Schnief...[K] Das ist der\nNotgroschen von meiner Mama.", italian="Sniff...[K] Questi sono i soldi che\nla mamma mi ha dato in caso di emergenza.", spanish="Así es...[K] Este es el dinero para\nemergencias que me dio mamá."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I can't just spend it carelessly...", french="J'peux pas m'permettre de\nl'dépenser sans r'garder.", german="Den kann ich nicht einfach\nso ausgeben...", italian="Non posso sperperarli\ninutilmente...", spanish=" No puedo gastarlo a la ligera..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8713) — id SE NDS sans portage PMDO identifié
  -- supervision_RemoveActing(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I considered it...[K]but I'll have to\npass on buying it.", french="Tout bien considéré...[K]\nj'vais pas pouvoir l'acheter.", german="Ich habe darüber nachgedacht,[K]\naber ich kann mir diesen Kauf nicht erlauben.", italian="Ci ho pensato...[K] ma temo che\ndovrò rinunciare all'acquisto.", spanish="Me lo he estado pensando...[K]\nNo voy a poder comprarla."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="Is that so...[K]\nThat's too bad...", french="Vraiment?[K]\nC'est bien dommage...", german="Na, wenn das so ist...[K]\nZu schade...", italian="Capisco...[K]\nPeccato...", spanish=" Vaya...[K] Es una lástima..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Thank you so much for listening\nto me...[K] See you.", french="Merci quand même d'm'avoir\nécouté...[K] A plus.", german="Vielen Dank für deine\nAufmerksamkeit...[K] Bis bald.", italian="Vi ringrazio molto di avermi\nascoltato...[K] Ci vediamo.", spanish="Muchísimas gracias por escucharme.[K]\nHasta luego."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(40), g.ViewCenter.Y+(0), 80, false) end) -- MovePositionOffset performer/caméra
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(40), p.Y+(0), false, 1) end
  GROUND:EntTurn(npc_npc_kakureon1, Direction.DownRight)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_kakureon2, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(5)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english=" Anytime!", french=" Au plaisir!", german=" Wann immer du willst!", italian=" A presto!", spanish=" ¡No hay de qué!"})
  pcall(function() UI:SetSpeaker(npc_npc_kakureon2) end)
  SkySceneKit.say({english="If you change your mind, come\nback anytime. ♪", french="N'hésite pas à repasser, si\njamais tu changes d'avis. ♪", german="Komm wieder, wenn du dich\numentscheiden solltest. ♪", italian="Se cambi idea, torna pure\nquando vuoi. ♪", spanish="Si cambia de opinión, vuelva\ncuando quiera. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...[K]Sniff...[K] Now that you've said\nthat, how can I ever make up my mind\nfor sure? Yup yup...", french="...[K] Snif...[K] Ne m'dis pas ça,\nj'pourrais rev'nir sur ma décision... ouaip...", german="...[K]Schnüff...[K] Ich lasse es mir\nnoch mal durch den Kopf gehen... Jawollja...", italian="...[K] Sniff...[K] Se mi dici così,\ndivento più indeciso di prima... Già, già...", spanish="Jo...[K] Buaa...[K] Si me dices eso,\n¿cómo voy a decidirme del todo? Ay..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But...[K] It's fine...[K]\nImpulse buying isn't good.", french="Mais...[K] non, c'est décidé...[K]\nAcheter sur un coup d'tête, c'est pas bon...", german="Aber...[K] Vielleicht ist es besser\nso...[K] Spontankäufe sind so eine Sache...", italian="Ma...[K] è meglio di no...[K]\nSpendere soldi senza riflettere è sbagliato.", spanish="Pero...[K] No pasa nada...[K]\nNo es bueno comprar de forma impulsiva."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="It's too bad...[K]but I'm going to\ngive up on the TM...", french="C'est trop bête...[K]\nmais faut qu'j'oublie cette histoire de CT...", german="Wirklich schade...[K] Aber aus der\nTM wird wohl nix.", italian="È un peccato...[K] ma dovrò\nrinunciare alla MT...", spanish="Es una pena...[K] pero voy a tener\nque olvidarme de la MT."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() GAME:MoveCamera(424, 196, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 424, 192, false, 1)
  GAME:WaitFrames(45)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_yukikaburi = SkySceneKit.spawn_npc("snover", 544, 216, Direction.Left, "NPC_YUKIKABURI")
  GROUND:MoveToPosition(npc_npc_yukikaburi, 472, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(3) [anim idle native]
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(1)
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" Erk...[K] Scary...", french=" Je tremble...[K] J'ai peur...", german=" Bibber...[K] Ich habe Angst...", italian=" Brrr...[K] Che paura...", spanish=" Qué escalofrío...[K] Qué miedo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yukikaburi, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" Umm...[K] Umm... What should I do...", french=" Mmmh...[K] Mmmh... Que faire...?", german=" Oh...[K] Oh... Was soll ich nur machen...", italian=" Uhm...[K] Uhm... Cosa devo fare...", spanish=" Hum...[K] Hum... Qué hago..."})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukikaburi, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yukikaburi, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukikaburi, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_yukikaburi, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(npc_npc_yukikaburi, 424, 212, false, 2)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(npc_npc_yukikaburi, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukikaburi, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" Excuse me! [K]H-hold this!", french=" Excuse-moi! [K]T-tiens ça!", german=" Entschuldige![K] N-nimm das bitte!", italian=" Scusami![K] P-Prendi questo!", spanish=" ¡Disculpa![K] ¡Sujétame esto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="[CN][CS:Y]Bidoof[CR] received something\n[CN]from the strange Pokémon.", french="[CN]Un étrange Pokémon\n[CN]donne quelque chose à [CS:Y]Keunotor[CR].", german="[CN][CS:Y]Bidiza[CR] erhielt etwas von\n[CN]dem sonderbaren Pokémon.", italian="[CN][CS:Y]Bidoof[CR] riceve qualcosa\n[CN]da uno strano Pokémon.", spanish="[CN][CS:Y]Bidoof[CR] ha recibido algo\n[CN]del Pokémon desconocido."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Huh...[K] Golly, what is this?", french=" Hein...[K] Sapristi, c'est quoi, ça?", german="Nanu![K]\nDonnerwetter, was ist los?", italian=" Uh...[K] Ohibò, cos'è questo?", spanish=" ¿Eh?...[K] Caramba, ¿qué es esto?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yukikaburi, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(-200), p.Y+(0), false, 2) end
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_kakureon2, Direction.Left)
  GROUND:EntTurn(npc_npc_kakureon1, Direction.Left)
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hey! [K]You...[K]wait!", french=" Hé! [K]Toi...[K] attends un peu!", german=" Hey! [K]Du...[K] Warte!", italian=" Ehi![K] Tu...[K] Aspetta!", spanish=" ¡Eh![K] ¡Tú!...[K] ¡Espera!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...[K]Just now...[K]\nWhat was that, anyway...?", french="...[K] Ça alors...[K]\nC'est quoi, c't'histoire...?", german="...[K]Aber...[K] Was war das\ndenn gerade?", italian="...[K] E adesso?[K]\nMa chi era quello...?", spanish=" Eeeh...[K] Pero...[K] ¿a qué ha venido eso?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_tatsubei = SkySceneKit.spawn_npc("bagon", 576, 216, Direction.Left, "NPC_TATSUBEI")
  GROUND:MoveToPosition(npc_npc_tatsubei, 472, 212, false, 2)
  GAME:WaitFrames(15)
  -- supervision_Acting(3) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_guraigaa = SkySceneKit.spawn_npc("gligar", 576, 216, Direction.Left, "NPC_GURAIGAA")
  GROUND:MoveToPosition(npc_npc_guraigaa, 504, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_AIR_OF_UNEASE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_guraigaa) end)
  SkySceneKit.say({english=" Do you see him...? [CS:N]Bagon[CR]!", french=" Tu le vois...? [CS:N]Draby[CR]!", german=" Siehst du ihn? [CS:N]Kindwurm[CR]!", italian=" [CS:N]Bagon[CR]! Lo vedi...?", spanish=" [CS:N]Bagon[CR], ¿lo ves por algún lado?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_tatsubei) end)
  SkySceneKit.say({english=" Nope. [K]Lost sight of him.", french=" Non. [K]Perdu de vue.", german="Nein.[K] Habe ihn aus den Augen\nverloren.", italian=" No.[K] L'ho perso di vista.", spanish=" Pues no.[K] Le he perdido la pista."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_guraigaa) end)
  SkySceneKit.say({english=" Blast! [K]Where'd he disappear to?!", french="Malédiction![K]\nOù est-ce qu'il a bien pu disparaître?!", german=" So was![K] Wohin ist er nur verschwunden?", italian=" Diamine![K] Dov'è finito?!", spanish=" ¿Dónde está?[K] ¡¿Adónde ha ido?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(npc_npc_tatsubei, 424, 212, false, 2)
  GROUND:EntTurn(npc_npc_tatsubei, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_tatsubei) end)
  SkySceneKit.say({english=" Hey! You!", french=" Hé! Toi!", german=" Hey! Du!", italian=" Ehi! Tu!", spanish=" ¡Eh, tú!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_kakureon1, Direction.DownRight)
  GROUND:EntTurn(npc_npc_kakureon2, Direction.DownRight)
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yes?", french=" Oui?", german=" Ja?", italian=" Sì?", spanish=" ¿Sí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_guraigaa, 448, 212, false, 2)
  GROUND:EntTurn(npc_npc_guraigaa, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_tatsubei) end)
  SkySceneKit.say({english="Did you just see a lone Pokémon\nrun through here?", french="Tu as vu un Pokémon tout seul\npasser par ici en courant?", german="Hast du gerade ein einzelnes\nPokémon hier vorbeilaufen sehen?", italian="Hai visto un Pokémon solitario\npassare di qua?", spanish="¿Por casualidad no habrás visto\na un Pokémon solo corriendo por aquí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" A Pokémon...?[K] Let me see...", french="Un Pokémon...?[K]\nBen, attends voir...", german="Ein Pokémon?[K]\nEinen Augenblick...", italian=" Un Pokémon...?[K] Fatemi pensare...", spanish=" ¿Un Pokémon?[K] A ver que piense..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guraigaa, "angry", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:EntTurn(hero, Direction.DownRight)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_guraigaa) end)
  SkySceneKit.say({english=" Come on! We're in a hurry!", french=" Dépêche! On n'a pas toute la journée!", german=" Nun mach schon! Wir haben es eilig!", italian=" Muoviti! Abbiamo fretta!", spanish=" ¡Venga! ¡Tenemos prisa!"})
  pcall(function() UI:SetSpeaker(npc_npc_guraigaa) end)
  SkySceneKit.say({english="Quit taking your time and just spit it\nout already!", french="Arrête de nous faire perdre notre temps\net crache le morceau!", german=" Nun mach schon und spuck es aus!", italian="Smettila di perdere tempo e dicci\nquello che sai!", spanish="¡Deja ya de pensártelo y suéltalo\nde una vez, que ya tardas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-4), p.Y+(-4), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Eee...[K] Eeeeeeeeeeeeek![K]\nS-scary!", french="Hiii...[K] Hiiiiiiiiiiiiiiiiiiiii![K]\nLa... la trouille!", german=" Iee...[K] Ieeeeeeeeeeeek![K] H-hilfe!", italian="Aaa...[K] Aaaaaaah![K]\nC-Che paura!", spanish=" Aaaah...[K] ¡Aaaaaay![K] ¡Vale, vale!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_tatsubei, npc_npc_guraigaa, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_tatsubei) end)
  SkySceneKit.say({english=" Hey, hold on, [CS:N]Gligar[CR].", french="Holà, maîtrise-toi un peu,\n[CS:N]Scorplane[CR].", german=" Hey, mal langsam, [CS:N]Skorgla[CR].", italian=" Ehi, calmati, [CS:N]Gligar[CR].", spanish=" Eh, cálmate, [CS:N]Gligar[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_guraigaa, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_tatsubei, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_tatsubei) end)
  SkySceneKit.say({english="White body, looking kind of\nnervous.[K] Did you see him?", french="Tout blanc, l'air nerveux.[K]\nAlors, tu l'as vu ou pas?", german="Weißer Körper, ein wenig\nnervös,[K] hast du so einen gesehen?", italian="Corpo bianco, aria nervosa...[K]\nLo hai visto?", spanish="Cuerpo blanco, con pinta de\nandar nervioso...[K] ¿Lo has visto?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Um...[K] Uh...[K] Th-that is...", french=" Heu...[K] B-ben...[K] C-c'est que...", german="Ähm...[K] Öh...[K]\nAlso, um genau zu sein...", italian=" Uhm...[K] Uh...[K] Ma è...", spanish=" Hum...[K] Eh...[K] Pues..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" He went that way...", french=" Il est parti par là...", german=" Er ist dort lang...", italian=" È andato da quella parte...", spanish=" Se ha ido por ahí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guraigaa, npc_npc_tatsubei, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_tatsubei, npc_npc_guraigaa, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_guraigaa) end)
  SkySceneKit.say({english=" Let's go!", french=" En avant!", german=" Auf geht's!", italian=" Andiamo!", spanish=" ¡Vamos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_tatsubei) end)
  SkySceneKit.say({english=" Yeah!", french=" Ouais!", german=" Jawoll!", italian=" Sì!", spanish=" ¡Sí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(160) end)
  do local p=npc_npc_tatsubei.Position; GROUND:MoveToPosition(npc_npc_tatsubei, p.X+(-200), p.Y+(0), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_guraigaa.Position; GROUND:MoveToPosition(npc_npc_guraigaa, p.X+(-200), p.Y+(0), false, 2) end
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_kakureon2, Direction.Left)
  GROUND:EntTurn(npc_npc_kakureon1, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(90)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Sniff...[K] They were pretty scary.", french="Snif...[K] Y z'étaient affreux,\nces types.", german="Schnüff...[K]\nDie waren ganz schön furchteinflößend.", italian="Sniff...[K] Che paura mi hanno\nfatto.", spanish=" Jo...[K] Daban bastante miedito."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'm not very brave, so I don't\nwant to have anything to do with Pokémon\nlike them...[K] Sniff...", french="J'suis pas bien courageux, alors\nj'veux pas avoir quoi qu'ce soit à faire avec\ndes Pokémon comme ça...[K] Snif...", german="Mit Pokémon wie diesen möchte\nich lieber nichts zu tun haben, dafür habe ich\nzu viel Angst...[K] Schnüff...", italian="Non sono molto coraggioso,\nquindi non voglio avere niente a che\nfare con Pokémon simili...[K] Sniff...", spanish="No soy muy valiente, así que\nno quiero tener nada que ver con Pokémon\nde esa calaña...[K] Ay..."})
  -- message_Close
  GAME:FadeOut(false,  90)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT_SIDE = 0 -- $COMPULSORY_SAVE_POINT_SIDE = 0 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
