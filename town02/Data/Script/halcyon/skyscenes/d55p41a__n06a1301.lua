-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D55P41A/n06a1301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=45, sub=7} -- $SCENARIO_SIDE = scn[45,7] (ROM)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(152, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D55P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  -- bgm2_PlayFadeIn(BGM_HEAVY_WIND5) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GROUND:MoveToPosition(hero, 252, 228, false, 2)
  GAME:WaitFrames(9)
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 224, 408, Direction.Down, "NPC_CHAAREMU")
  GROUND:MoveToPosition(npc_npc_chaaremu, 220, 244, false, 2)
  GAME:WaitFrames(12)
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 288, 400, Direction.Left, "NPC_SAANAITO")
  GROUND:MoveToPosition(npc_npc_saanaito, 284, 244, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(9)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Huh?[K] Something about this place\nseems different somehow.", french="Hein?[K] Cet endroit a quelque\nchose de différent.", german="Hmmm...[K] Irgendetwas an diesem\nOrt ist anders.", italian="Uh?[K] C'è qualcosa di strano\nin questo posto.", spanish="Hum...[K] No sé qué es, pero\nhay algo que parece diferente en este lugar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="So far the path has been pretty\nstraight without ever diverging...", french="Jusqu'ici, il n'y avait qu'un seul\nchemin possible, on n'a pas pu se perdre...", german="Bis hierhin verlief der Weg\neher geradeaus. Verirren unwahrscheinlich,\nwenn ihr mich fragt...", italian="Finora il sentiero è sempre stato\npiuttosto lineare, senza deviazioni...", spanish="Hasta ahora el camino ha sido\nbastante recto, parece difícil perderse..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Maybe we got lost without\nrealizing it...", french="Qui sait, peut-être nous\nsommes-nous égarées sans nous en\nrendre compte...", german="Aber wer weiß, vielleicht haben\nwir uns bereits verirrt, ohne es\nmitzubekommen...", italian="Non ci saremo mica perse\nsenza rendercene conto?!", spanish="Quién sabe, igual nos hemos\nperdido sin darnos cuenta..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Oh no![K] Don't tell me we're lost!?", french="Oh non![K] Ne me dites pas\nqu'on est perdues!?", german="Oh nein![K] Sag bloß nicht, dass\nwir uns verlaufen haben?!?", italian=" Oh no![K] Non ditemi che è così!", spanish="¡No![K] ¡¿No me digas que\nnos hemos perdido?!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="What do we do...?[K] We should\njust try to keep moving forward, right...?", french="Que faire...?[K] Continuons à\navancer. On arrivera bien quelque part,\npas vrai?", german="Was sollen wir machen?[K]\nIch denke, wir sollten einfach versuchen,\nvoranzukommen, nicht wahr?", italian="Cosa facciamo...?[K] Dovremmo\ncontinuare ad andare avanti, no...?", spanish="¿Y ahora qué hacemos?...[K]\nDeberíamos intentar avanzar, ¿no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Before we entered...[K]those other\nexploration teams told us about this.", french="Avant qu'on entre...[K] les autres\néquipes d'exploration nous ont prévenues.", german="Bevor wir den Dungeon\nbetraten...[K] Da hatten uns die anderen\nErkundungsteams bereits davon erzählt.", italian="Prima di entrare...[K] le altre\nsquadre d'esplorazione ci avevano avvertite\ndi questa cosa.", spanish="Antes de que entráramos...[K] esos\nequipos exploradores ya nos avisaron de esto."})
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, hero, 4) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="This is probably the\ncomplex labyrinth.", french="Ce doit être le fameux\nlabyrinthe dont ils parlaient.", german="Das hier ist möglicherweise\nbereits jenes komplexe Labyrinth.", italian="Probabilmente si tratta di quel\nlabirinto intricato di cui ci hanno parlato.", spanish="Este debe de ser ese\nlaberinto tan intrincado."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="So rather than getting worried\nabout being lost...", french="Plutôt que de nous inquiéter à\nl'idée d'être perdues...", german="Wir sollten uns also nicht gleich\ndarüber Sorgen machen, ob wir uns bereits\nverlaufen haben oder nicht...", italian="Quindi, piuttosto che\npreoccuparci di esserci perse o meno...", spanish="Así que, en vez de preocuparnos\nde si nos perdemos..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Think that this is a place where\neveryone gets lost, so it's only natural\nthat you'll get lost...", french="... gardons à l'esprit que nous ne\nsommes pas les seules à nous être égarées\ndans cet endroit...", german="Es könnte doch auch sein, dass\ndas ganz normal ist, da es allen passiert.\nVersuchen wir, es mal so zu sehen!", italian="... riflettiamo sul fatto che\nquesto è un posto dove è facile perdersi,\nquindi è normale che succeda una cosa simile...", spanish="Pensad que este es un lugar en\nel que todos se pierden, así que extraviarse\nes lo más natural del mundo..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Wouldn't that help\nyou relax? [M:H8]", french=" Rassurées? [M:H8]", german="Hilft das, euch ein wenig zu\nberuhigen? [M:H8]", italian="Se ragioniamo in questo\nmodo, non dobbiamo agitarci troppo...\nnon credete? [M:H8]", spanish=" ¿No iríais más relajadas así? [M:H8]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Sounds about right. ♪", french=" Tu as raison. ♪", german="Stimmt, so kann man das\nauch sehen. ♪", italian=" Sì, hai ragione. ♪", spanish=" Tienes toda la razón. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" I think this might be a detour...", french=" C'est peut-être juste un détour...", german="Ich bin mir sicher, dass das\nnicht einfach werden wird...", italian="Secondo me si tratta di\nuna deviazione...", spanish=" Esto parece dar un rodeo..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="But eventually we'll figure it\nout...I think.", french="... mais nous finirons bien par\nen venir à bout... non?", german="Aber letzten Endes werden wir\nschon herausfinden, was dahinter steckt...\nGlaube ich.", italian="Ma alla fine troveremo\nla strada giusta... credo.", spanish="Pero al final lo comprenderemos.\nO eso quiero pensar."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Anyway, let's keep going\nand see.", french=" Continuons, nous verrons bien.", german="Wie auch immer. Gehen wir\nweiter und finden es heraus!", italian="In ogni caso possiamo solo\nandare avanti e vedere cosa succede.", spanish=" En fin, sigamos a ver qué pasa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Wait![K] You!", french=" Attendez![K] Vous, là-bas!", german=" Wartet![K] Ihr da!", italian=" Ehi![K] Aspettate!", spanish=" ¡Eh![K] ¡Esperad!"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  -- bgm2_PlayFadeIn(BGM_ON_THE_CEILING) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" You! Where did you come from?!", french=" D'où sortez-vous?!", german=" Ihr! Woher kommt ihr?!?", italian=" Voi! Da dove venite?!", spanish=" ¡Eh, vosotras! ¡¿De dónde habéis salido?!"})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="This is my...[K] How could you not know\nthis is [CS:N]Aggron[CR]'s territory?!", french="Ceci est mon territoire...[K] Vous osez\npénétrer dans le territoire de [CS:N]Galeking[CR]?!", german="Das hier ist...[K] Wie konntet ihr übersehen,\ndass dieses Gebiet [CS:N]Stolloss[CR] gehört?!?", italian="Questo è...[K] Come fate a non sapere che\nquesto è il territorio di [CS:N]Aggron[CR]?!", spanish="Estáis en mis...[K] ¡¿Cómo es posible que no\nsepáis que estos son los dominios de [CS:N]Aggron[CR]?!"})
  -- message_Close
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Really?[K] We didn't know.", french="Ah bon?[K] On n'était pas\nau courant.", german=" Echt?[K] Das wussten wir nicht.", italian=" Davvero?[K] Non lo sapevamo.", spanish=" ¿En serio?[K] Pues ni idea."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_bosugodora = SkySceneKit.spawn_npc("aggron", 256, 184, Direction.Down, "NPC_BOSUGODORA")
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english="Graa-ha-ha-ha-ha![K]\nYou didn't know...", french="Gra ha ha ha ha![K]\nPas au courant...", german="Graa-ha-ha-ha-ha![K]\nDas wusstet ihr also nicht...", italian="Graaa-ah-ah-ah-ah![K]\nNon lo sapevate...", spanish=" ¡Jaaa, ja, ja, ja, ja, ja![K] No lo sabíais."})
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english="If you didn't know...[K]then allow\nme to teach you...", french="Puisque c'est ainsi...[K] alors\nje vais vous apprendre...", german="Wenn das so ist...[K] Dann zeige\nich euch mal etwas...", italian="Beh, se è così...[K] permettetemi\ndi mostrarvi...", spanish="Ya que no lo sabíais...[K] permitidme\nque os enseñe..."})
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english="What happens...to those who\ntrespass here!", french="... ce qui arrive aux intrus qui\nont l'audace de s'aventurer dans mon repaire!!", german="Und zwar, was mit jenen\npassiert, die sich hier unbefugt Zutritt\nverschaffen!!!", italian="... cosa succede a chi mette\npiede in questo posto senza permesso!!!", spanish=" Lo que les ocurre... ¡¡a los intrusos!!"})
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english=" Come on out![K] [CS:N]Lairon[CR]!", french=" Montrez-vous![K] [CS:N]Galegon[CR]!", german=" Kommt heraus![K] [CS:N]Stollrak[CR]!", italian=" Venite fuori![K] [CS:N]Lairon[CR]!", spanish=" ¡Salid...[K] [CS:N]Lairon[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english="[CS:N]Lairon[CR]: Groooaaahh!", french="[CS:N]Galegon[CR]: Groooaaahh!", german="[CS:N]Stollrak[CR]: Groooaaah!", italian="[CS:N]Lairon[CR]: Groooaaahhh!", spanish="[CS:N]Lairon[CR]: ¡Grooooooah!"})
  -- message_Close
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  -- GAP: BGM BGM_OH_NO non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- GAP: se_Play(5130) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '0', '1', '0')
  GAME:WaitFrames(6)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('1', '1', '0', '1', '0')
  -- GAP: se_Play(10247) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(21) [anim idle native]
  GAME:WaitFrames(6)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "shock", 1) end)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 1, 30)) end) -- camera_SetEffect('2', '0', '5', '0', '5')
  pcall(function() GAME:MoveCamera(252, 256, 60, false) end) -- performer/caméra
  local npc_npc_kodora = SkySceneKit.spawn_npc("lairon", 352, 216, Direction.DownLeft, "NPC_KODORA")
  GROUND:MoveToPosition(npc_npc_kodora, 304, 268, false, 2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-4), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2)
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(-4), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(npc_npc_chaaremu, Direction.DownRight)
  GAME:WaitFrames(2)
  do local p=npc_npc_saanaito.Position; GROUND:MoveToPosition(npc_npc_saanaito, p.X+(-4), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(npc_npc_saanaito, Direction.DownRight)
  GAME:WaitFrames(2)
  local npc_npc_kodora2 = SkySceneKit.spawn_npc("lairon", 352, 216, Direction.DownLeft, "NPC_KODORA2")
  GROUND:MoveToPosition(npc_npc_kodora2, 308, 268, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_kodora, Direction.Up)
  GROUND:EntTurn(npc_npc_kodora2, Direction.UpLeft)
  local npc_npc_kodora3 = SkySceneKit.spawn_npc("lairon", 352, 216, Direction.DownLeft, "NPC_KODORA3")
  GROUND:MoveToPosition(npc_npc_kodora3, 328, 252, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_kodora3, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D55P41A1_466) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(30)
  -- GAP: se_Play(5130) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '0', '1', '0')
  GAME:WaitFrames(6)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('1', '1', '0', '1', '0')
  -- GAP: se_Play(10247) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(6)
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "shock", 1) end)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 1, 30)) end) -- camera_SetEffect('2', '0', '5', '0', '5')
  local npc_npc_kodora4 = SkySceneKit.spawn_npc("lairon", 168, 216, Direction.DownRight, "NPC_KODORA4")
  GROUND:MoveToPosition(npc_npc_kodora4, 200, 268, false, 2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(4), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2)
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(4), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(npc_npc_chaaremu, Direction.DownLeft)
  GAME:WaitFrames(2)
  do local p=npc_npc_saanaito.Position; GROUND:MoveToPosition(npc_npc_saanaito, p.X+(4), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(npc_npc_saanaito, Direction.DownLeft)
  GAME:WaitFrames(2)
  local npc_npc_kodora5 = SkySceneKit.spawn_npc("lairon", 168, 216, Direction.DownRight, "NPC_KODORA5")
  GROUND:MoveToPosition(npc_npc_kodora5, 200, 268, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_kodora4, Direction.Up)
  GROUND:EntTurn(npc_npc_kodora5, Direction.UpRight)
  local npc_npc_kodora6 = SkySceneKit.spawn_npc("lairon", 168, 216, Direction.DownRight, "NPC_KODORA6")
  GROUND:MoveToPosition(npc_npc_kodora6, 176, 252, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_kodora6, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D55P41A1_465) [routine d'objet NDS non simulée - documenté]
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english="GRAA-HAHAHAHA-HAHAHAHA!![K]\nGRAA-HAHAHAHA-HAHAHAHA-HAHAHAHA!!", french="GRA HA HA HA HA HA HA HA!![K]\nGRA HA HA HA HA HA HA HA!!", german="GRAA-HAHAHAHA-HAHAHAHA!!![K]\nGRAA-HAHAHAHA-HAHAHAHA-HAHAHAHA!!!", italian="GRAAA-AHAHAHAH-AHAHAHAH!!![K]\nGRAAA-AHAHAHAH-AHAHAHAH!!!", spanish="¡¡Jaaa, ja, ja, ja, ja, ja, ja, ja!![K]\n¡¡Jaaa, ja, ja, ja, ja, ja, ja, ja!!"})
  -- message_Close
  -- GAP: se_Play(5130) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '0', '1', '0')
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('1', '1', '0', '1', '0')
  -- GAP: se_Play(10247) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetAnimation(23) [anim idle native]
  GROUND:MoveToPosition(npc_npc_bosugodora, 252, 192, false, 2) -- SlidePositionMark (glissement)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_bosugodora, 4) end)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(10), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(1)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_bosugodora, 4) end)
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(0), p.Y+(12), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(1)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "shock", 1) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_bosugodora, 4) end)
  do local p=npc_npc_saanaito.Position; GROUND:MoveToPosition(npc_npc_saanaito, p.X+(0), p.Y+(12), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english="We show no mercy to those who\ninvade our territory!", french=" Pas de quartier!", german="Wir zeigen keine Gnade bei\nunerlaubtem Eindringen in unser Gebiet!", italian="Non abbiamo pietà con chi\ninvade il nostro territorio!", spanish="¡No hay piedad para quien\ninvade nuestros dominios!"})
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english=" That's the law of this land!", french="Les envahisseurs doivent\nêtre punis! C'est la loi!", german="So lauten die Gesetze dieses\nLandes!", italian=" È la nostra legge!", spanish=" ¡Esa es nuestra ley!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Huh?[K] We apologize that\nwe wandered into your territory, but we\ndidn't know...", french="Hein?[K] Désolées d'avoir empiété\nsur votre territoire, on ne savait pas...", german="Oh![K] Entschuldigt, dass wir\neuer Gebiet betreten haben. Aber wir hatten\nkeine Ahnung...", italian="Uh?[K] Siamo desolate di essere\nfinite nel vostro territorio, ma non era\nnostra intenzione...", spanish="¿Eh?[K] Pues sentimos mucho\nhaber llegado hasta tus dominios, pero no\nteníamos ni idea..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But regardless, don't you think\nit's a little unreasonable to attack us without\nlistening to our reason?", french="Tu ne trouves pas que c'est\nun peu prématuré de nous attaquer sans\nmême écouter nos explications?", german="Aber davon abgesehen, glaubt ihr\nnicht, dass es etwas vorschnell ist, einfach\nanzugreifen, ohne uns vorher anzuhören?", italian="A parte questo, non credete che\nsia un po' avventato attaccarci senza aver\nprima ascoltato le nostre ragioni?", spanish="En cualquier caso, ¿no te\nparece poco razonable querer atacarnos\nsin atender a razones?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="We haven't done anything to\nthis place...", french=" Nous n'avons rien fait de mal...", german="Wir haben diesem Ort\nnichts getan...", italian="Non abbiamo fatto niente\ndi male...", spanish="No le hemos hecho nada\na este sitio..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" And we don't intend to fight.", french="... et nous n'avons pas l'intention\nde nous battre.", german="Und wir kommen nicht mit der\nAbsicht, zu kämpfen.", italian="E non abbiamo intenzione\ndi lottare.", spanish="Y no venimos con intención\nde combatir."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_TEAM_CHARMS_THEME non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="But...[K] If you're going to insist\non fighting...", french=" Bien sûr...[K] si tu insistes...", german="Aber...[K] Wenn ihr auf einen\nKampf besteht...", italian=" Tuttavia...[K] se insistete...", spanish=" Pero...[K] si insistes en luchar..."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Then we have no choice![K]\nWe'll be your opponents!", french="Tu ne nous laisses pas\nle choix![K] En garde!", german="Dann bleibt uns keine andere\nWahl![K] Dann werden wir würdige Gegner sein!", italian="Allora non abbiamo scelta![K]\nPreparatevi a lottare!", spanish="¡No nos dejas elección![K]\n¡Seremos tus oponentes!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english="Humph![K] You ladies are\nconsiderably cheerful!", french="Pfff![K] Un peu de modestie,\nmesdames!", german="Humpf![K] Ihr seid zweifellos ein\npaar gutgelaunte Damen!", italian="Umpf![K] Siete davvero combattive,\nragazze!", spanish="¡Ja![K] ¡Estáis hechas\nunas buenas piezas!"})
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english=" However!", french=" Méfiez-vous!", german=" Aber!", italian=" In ogni caso...", spanish=" Sin embargo..."})
  -- message_Close
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english="That composure...[K] How long can\nyou keep it up?!", french="Nous allons vous faire ravaler\nvotre fierté!", german="Eure Gelassenheit...[K] Wie lange\nkönnt ihr sie wohl aufrecht halten?!?", italian="Quella calma...[K] per quanto tempo\npensate di riuscire a mantenerla?!", spanish="Esa calma...[K] ¡¿cuánto\ntiempo podréis mantenerla?!"})
  -- message_Close
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english="Let's go! [CS:N]Lairon[CR]![K]\nGet them!!", french="A l'attaque! [CS:N]Galegon[CR]![K]\nChargez!!", german="Zum Angriff! [CS:N]Stollrak[CR]![K]\nAuf sie!!!", italian="Forza, [CS:N]Lairon[CR]![K]\nAddosso!!!", spanish="¡Venga, [CS:N]Lairon[CR]![K]\n¡¡A por ellas!!"})
  -- message_Close
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(3)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(3)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora5, "happy", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora3, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora4, "happy", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora2, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora6, "happy", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english="[CS:N]Lairon[CR]: Groooaaahh!", french="[CS:N]Galegon[CR]: Groooaaahh!", german="[CS:N]Stollrak[CR]: Groooaaah!", italian="[CS:N]Lairon[CR]: Groooaaahhh!", spanish="[CS:N]Lairon[CR]: ¡Grooooooah!"})
  GAME:WaitFrames(24)
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora5, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora4, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora2, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora3, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora6, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_saanaito, Direction.DownRight)
  do local p=npc_npc_saanaito.Position; GROUND:MoveToPosition(npc_npc_saanaito, p.X+(-4), p.Y+(-4), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.DownLeft)
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(4), p.Y+(-4), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(18)
  -- SetAnimation(27) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="[CS:N]Medicham[CR]! [CS:Y]Lopunny[CR]!\nHere they come!", french="[CS:N]Charmina[CR]! [CS:Y]Lockpin[CR]!\nIls vont attaquer!", german="[CS:N]Meditalis[CR]! [CS:Y]Schlapor[CR]!\nNehmt euch in Acht, wir werden angegriffen!", italian="[CS:N]Medicham[CR]! [CS:Y]Lopunny[CR]!\nTenetevi pronte!", spanish="¡[CS:N]Medicham[CR], [CS:Y]Lopunny[CR]!\n¡Preparaos, que vienen!"})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  -- SetAnimation(24) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Anytime!", french=" Je les attends de pied ferme!", german=" Allzeit bereit!", italian=" Mettiamocela tutta!", spanish=" ¡Venga!"})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(24) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="OK.\nLet's go! [M:H8]", french=" O.K. C'est parti! [M:H8]", german=" Auf geht's! [M:H8]", italian=" Ok. Andiamo! [M:H8]", spanish=" De acuerdo. ¡Vamos! [M:H8]"})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  -- supervision_SpecialActing(24, 0, 0) [cadrage NDS]
  -- supervision_SpecialActing(25, 0, 0) [cadrage NDS]
  -- GAP: se_Play(10249) — id SE NDS sans portage PMDO identifié
  -- supervision_SpecialActing(26, 0, 0) [cadrage NDS]
  GAME:WaitFrames(120)
  GAME:FadeOut(true, 30) -- screen_WhiteOutAll
  -- supervision_SpecialActing(3, 0, 0) [cadrage NDS]
  -- main_EnterDungeon(152, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
