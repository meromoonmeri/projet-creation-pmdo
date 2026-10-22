-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P17P02C/n02a0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P06A) [décor sub chargé: Sub_v02p06a]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v02p06a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(150)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_P17P02C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m1', 19, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  -- SetAnimation(42) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  GAME:WaitFrames(30)
  local npc_npc_pukurin_mama = SkySceneKit.spawn_npc("wigglytuff", 200, 152, Direction.DownLeft, "NPC_PUKURIN_MAMA")
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english="Sleep now sweet, little child. ♪[K]\nYou are truly adorable. ♪", french="Fais dodo, maintenant,\nmon garçon. ♪[K]\nTu es vraiment trop mignon. ♪", german="Schlafe, mein Kind, und träume\nsüß. ♪[K] Ach, was bist du knuddelig. ♪", italian="Dormi piccino. ♪[K]\nDormi tesoro. ♪", spanish="Duérmete chiquitín, duérmete ya. ♪[K]\nNaninonino, naninoná. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" Sleep now sweet, little child. ♪", french="Fais dodo, maintenant,\nmon garçon. ♪", german="Schlafe, mein Kind,\nund träume süß. ♪", italian=" La tua mammina, ti cullerà. ♪", spanish=" Duérmete chiquitín, duérmete ya. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end) -- message_SetActor(ACTOR_PLAYER_PUPURIN)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...[K]Mmmmmm... [K]Mmmmmmmm...", french=" ...[K] ZZzzzmmmm... [K]Zzzzmmmm...", german=" ...[K]Mmmmmm... [K]Mmmmmmmm...", italian=" ...[K] Ronf... fiii...[K] Ronf.. fiii...", spanish=" Zz...[K] Zzz...[K] Zzzzzz..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P17P02C1_547) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" ...[K]All right, he's sleeping.", french=" ...[K] C'est bon, il s'est endormi.", german=" ...[K]So, gut. Er schläft jetzt.", italian=" ...[K] Bene, si è addormentato.", spanish=" Bueno...[K] Muy bien, ya está dormido."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english="Hey, [CS:N]Papa[CR].[K] I've been worried\nabout something...", french="Dis, [CS:N]Papa[CR].[K]\nQuelque chose me préoccupe...", german="Hey, [CS:N]Papa[CR].[K] Ich habe mir wegen\neiner Sache Gedanken gemacht...", italian="Ehi, [CS:N]papà[CR].[K] C'è qualcosa che mi\npreoccupa un po'...", spanish=" Oye, cariño...[K] Hay algo que me preocupa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_pukurin_papa = SkySceneKit.spawn_npc("wigglytuff", 320, 208, Direction.Left, "NPC_PUKURIN_PAPA")
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english=" Huh?[K] What is it, [CS:N]Mama[CR]?", french=" Hein?[K] Quoi donc, [CS:N]Maman[CR]?", german=" Ehrlich?[K] Worüber denn, [CS:N]Mama[CR]?", italian=" Uh?[K] Che succede, [CS:N]mamma[CR]?", spanish=" ¿Y eso?[K] ¿De qué se trata?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(150) end)
  -- Move2PositionMark 0 [cible sans placement SSA zone: mouvement non joué]
  GROUND:MoveToPosition(npc_npc_pukurin_mama, 256, 208, false, 2)
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.Left)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- bgm2_PlayFadeIn(BGM_FIRE_CRACKLING3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:WaitFrames(15)
  -- message_FacePositionOffset(3, -5) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english="I heard from [CS:Y]Igglybuff[CR]'s\nfriends today...", french="Les amis de [CS:Y]Toudoudou[CR] m'ont\nraconté aujourd'hui...", german="Die Freunde von [CS:Y]Fluffeluff[CR] haben\nmir heute etwas erzählt.", italian=" Oggi, gli amici di [CS:Y]Igglybuff[CR]...", spanish=" Los amigos de [CS:Y]Igglybuff[CR] me han dicho..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english="[CS:Y]Igglybuff[CR][K] is being manipulated\nby some bullies.", french="... qu'une bande de brutes[K]\nle manipule.", german="[CS:Y]Fluffeluff[CR][K] wurde von ein paar\nSchlitzohren ausgenutzt.", italian="... mi hanno detto che dei\nprepotenti si approfittano di lui.", spanish="Que [CS:Y]Igglybuff[CR]...[K] se deja manipular\npor unos abusones."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english=" Some bullies?", french=" Une bande de brutes?", german=" Schlitzohren, wie?", italian=" Dei prepotenti?", spanish=" ¿Unos abusones?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(3, -5) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english="Yeah.[K] [CS:Y]Igglybuff[CR]'s friends came\nto talk to me about it...", french="Oui.[K] Les amis de [CS:Y]Toudoudou[CR]\nsont venus m'en parler.", german="Genau.[K] Die Freunde von\n[CS:Y]Fluffeluff[CR] kamen, um mir davon zu\nberichten...", italian="Sì.[K] Me lo hanno raccontato\ngli amici di [CS:Y]Igglybuff[CR]...", spanish="Sí.[K] Los amiguitos de [CS:Y]Igglybuff[CR]\nhan venido a decírmelo..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english="Hey, [CS:N]Papa[CR].[K] You don't think\nhe'd become like them, do you?", french="Dis, [CS:N]Papa[CR].[K] Tu penses qu'ils\nrisquent d'avoir une mauvaise influence\nsur lui?", german="Sag, [CS:N]Papa[CR],[K] meinst du, dass er\ndadurch schlechte Manieren annehmen und so\nwie die Schlitzohren werden könnte?", italian="Ehi, [CS:N]papà[CR].[K] Pensi che possa\ndiventare come loro?", spanish="Cariño,[K] no crees que acabe\nvolviéndose como ellos, ¿verdad?"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english="Sometimes, I really have no clue\nwhat that child is thinking...", french="Parfois, cet enfant me\ndéconcerte complètement...", german="Manchmal frage ich mich, was\nim Kopf dieses Kindes wohl so vor sich geht...", italian="A volte non so cosa passi\nper la testa di quel ragazzo...", spanish="A veces no tengo ni idea de lo\nque le pasa por la cabeza..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_mama, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(3, -5) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" So I'm a little worried...", french=" Alors, je suis un peu inquiète...", german="Ich mache mir ein\nwenig Sorgen...", italian=" Quindi sono un po' preoccupata...", spanish=" Y eso me tiene algo preocupada."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="Yeah...[K] That does seem\ntroublesome...", french="Mmoui...[K] Ça a l'air préoccupant,\nen effet...", german="Ja...[K] Das ist in der Tat\nbesorgniserregend...", italian="Già...[K] Non c'è da stare molto\ntranquilli...", spanish="Sí,[K] la verdad es que es un poco\npreocupante."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english=" But...", french=" Mais...", german=" Aber...", italian=" Però...", spanish=" Pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english=" But I think it's all right.", french="... je pense qu'il ne faut\npas s'en faire.", german=" Aber ich denke, es ist okay.", italian=" Penso che non ci siano problemi.", spanish=" Creo que no pasará nada."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english=" [CS:Y]Igglybuff[CR] is still so cheerful...", french="[CS:Y]Toudoudou[CR] est toujours\naussi joyeux...", german="[CS:Y]Fluffeluff[CR] ist immer\nso gutgelaunt und aufgekratzt...", italian="[CS:Y]Igglybuff[CR] è sempre\ncosì allegro...", spanish=" [CS:Y]Igglybuff[CR] siempre está tan contento."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="No matter how he may seem,\ndeep down, he has a good heart.", french="Il a bon cœur, je ne me fais pas\nde souci pour lui.", german="Ganz gleich, welchen Eindruck er\nauf andere macht, im Grunde seines Herzens\nist er rein und gut.", italian="Le apparenze non contano...\nLui ha un'indole buona e gentile.", spanish="Pase lo que pase, en el fondo\ntiene un corazón de oro."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="Besides...[K] Didn't we have this\ndiscussion before...", french="En plus...[K] il me semble qu'on en\na déjà discuté par le passé...", german="Und ganz nebenbei...[K] Hatten wir\ndiese Diskussion nicht schon einmal...", italian="E poi...[K] Abbiamo già affrontato\nquesto discorso in passato...", spanish="Además,[K] creo que ya habíamos\nhablado de este tema."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="Back when...[K] I climbed that\nmountain with [CS:Y]Igglybuff[CR]. On our way home...", french="Le jour où...[K] j'ai gravi cette\nmontagne avec [CS:Y]Toudoudou[CR].\nQuand on est rentrés...", german="Damals,[K] als ich zusammen mit\n[CS:Y]Fluffeluff[CR] auf den Berg gestiegen bin?\nAuf unserem Rückweg...", italian="È stato quando...[K] ho scalato\nquella montagna con [CS:Y]Igglybuff[CR]. Tornando\na casa...", spanish="Cuando...[K] subí a aquella montaña con\n[CS:Y]Igglybuff[CR]. De camino a casa..."})
  -- message_Close
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(false, 60)
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
