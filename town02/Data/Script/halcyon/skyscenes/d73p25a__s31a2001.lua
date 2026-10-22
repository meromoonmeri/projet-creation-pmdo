-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P25A/s31a2001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D73P25A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_D73P25A, 'US31') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(11) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(12) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(9) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 232, 240, Direction.Down, "NPC_SHEIMI")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_kuchiito = SkySceneKit.spawn_npc("mawile", 216, 256, Direction.UpRight, "NPC_KUCHIITO")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_goorikii = SkySceneKit.spawn_npc("machoke", 184, 232, Direction.Up, "NPC_GOORIKII")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_kinogassa = SkySceneKit.spawn_npc("breloom", 248, 256, Direction.UpLeft, "NPC_KINOGASSA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOutAll
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOutAll
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Everyone wait a second!", french=" Que tout le monde se calme!", german=" Alle mal kurz innehalten!", italian=" Ascoltatemi tutti!", spanish=" ¡Esperad todos un momento!"})
  -- message_Close
  GAME:FadeIn(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  local npc_npc_masukippa2 = SkySceneKit.spawn_npc("carnivine", 168, 208, Direction.DownRight, "NPC_MASUKIPPA2")
  pcall(function() GROUND:CharSetEmote(npc_npc_masukippa2, "exclaim", 1) end)
  local npc_npc_masukippa = SkySceneKit.spawn_npc("carnivine", 232, 224, Direction.Down, "NPC_MASUKIPPA")
  pcall(function() GROUND:CharSetEmote(npc_npc_masukippa, "shock", 1) end)
  do local p=npc_npc_masukippa.Position; GROUND:MoveToPosition(npc_npc_masukippa, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  local npc_npc_masukippa5 = SkySceneKit.spawn_npc("carnivine", 256, 200, Direction.Down, "NPC_MASUKIPPA5")
  pcall(function() GROUND:CharSetEmote(npc_npc_masukippa5, "shock", 1) end)
  do local p=npc_npc_masukippa5.Position; GROUND:MoveToPosition(npc_npc_masukippa5, p.X+(0), p.Y+(-4), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharSetEmote(npc_npc_kuchiito, "shock", 1) end)
  do local p=npc_npc_kuchiito.Position; GROUND:MoveToPosition(npc_npc_kuchiito, p.X+(-8), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kinogassa, "shock", 1) end)
  do local p=npc_npc_kinogassa.Position; GROUND:MoveToPosition(npc_npc_kinogassa, p.X+(8), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_sheimi, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_goorikii, npc_npc_sheimi, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_masukippa2, npc_npc_sheimi, 4) end)
  GAME:WaitFrames(2)
  local npc_npc_masukippa4 = SkySceneKit.spawn_npc("carnivine", 192, 208, Direction.DownLeft, "NPC_MASUKIPPA4")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_masukippa4, npc_npc_sheimi, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_masukippa5, npc_npc_sheimi, 4) end)
  local npc_npc_masukippa3 = SkySceneKit.spawn_npc("carnivine", 280, 224, Direction.Down, "NPC_MASUKIPPA3")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_masukippa3, npc_npc_sheimi, 4) end)
  GAME:WaitFrames(3)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharTurnToCharAnimated(__slot, npc_npc_sheimi, 4) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharTurnToCharAnimated(__slot, npc_npc_sheimi, 4) end) end end
  GAME:WaitFrames(4)
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english=" Wh-what?!", french=" Qu-quoi?!", german=" W-was?!?", italian=" C-Come?!", spanish=" ¡¿Qué... Qué pasa?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_masukippa, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_masukippa) end)
  SkySceneKit.say({english=" Huh? You...", french=" Hein? Tu...", german=" Wie? Du...", italian=" Eh? Tu...", spanish=" ¿Eh? Eres..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_sheimi, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_masukippa, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_masukippa5, "exclaim", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_masukippa4, "exclaim", 1) end)
  GAME:WaitFrames(3)
  pcall(function() UI:SetSpeaker(npc_npc_masukippa) end)
  SkySceneKit.say({english="Oh!\nA [CS:N]Shaymin[CR] from the village! It's been a while!", french="Oh!\nUn [CS:N]Shaymin[CR] du village!\nÇa fait un bout de temps!", german="Oh! Ein [CS:N]Shaymin[CR] aus dem Dorf!\nIst schon ein Weilchen her!", italian="Oh! Ma guarda, [CS:N]Shaymin[CR]\ndel villaggio! Ne è passato di tempo!", spanish="¡Anda! ¡Una [CS:N]Shaymin[CR] de la aldea!\n¡Cuánto tiempo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" We owe you...", french="Je dois vous remercier pour les\nservices rendus par le passé...", german=" Nun...", italian=" Sono in debito con voi...", spanish=" Os debemos mucho..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="You haven't changed a bit,\n[CS:N]Carnivine[CR]!", french="Mais vous n'avez pas changé,\nvous, les [CS:N]Vortente[CR]!", german="Anscheinend habt ihr euch\nkein bisschen verändert, [CS:N]Venuflibis[CR]!", italian="Non siete cambiati affatto, eh,\n[CS:N]Carnivine[CR]?!", spanish="¡No habéis cambiado ni pizca,\n[CS:N]Carnivine[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We've asked you before to stop\nbothering the explorers, haven't we?!", french="On vous a pourtant déjà\ndemandé d'arrêter d'embêter les explorateurs,\npas vrai?", german="Wir haben euch doch bereits\ndarum gebeten, keine Erkunder mehr\nzu stören, oder etwa nicht?", italian="Vi avevamo già detto\ndi smetterla di importunare gli esploratori,\nnon è vero?!", spanish="No es la primera vez que os\npedimos que dejéis de incordiar a los\nexploradores, ¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_masukippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_masukippa) end)
  SkySceneKit.say({english="Yeah, but!\nThat [CS:N]Sneasel[CR] started it!", french="Ouais, mais...!\nC'est [CS:N]Farfuret[CR] qui a commencé!", german="Ja, aber...\n[CS:N]Sniebel[CR] hat angefangen!", italian="Sì, però...!\nÈ stato quello [CS:N]Sneasel[CR] a cominciare!", spanish="Ya, tienes razón, pero... ¡Fue él!\n¡Ese [CS:N]Sneasel[CR] fue quien lo empezó todo!"})
  pcall(function() UI:SetSpeaker(npc_npc_masukippa) end)
  SkySceneKit.say({english="We found some treasure earlier,\nand he snatched it right out from under\nour noses!", french="On a trouvé un trésor tout à\nl'heure, et il est venu nous le chiper\nsous notre nez!", german="Wir haben einen Schatz\ngefunden und er hat ihn uns direkt vor den\nBlättern weggeschnappt!", italian="Avevamo trovato un tesoro, ma\nlui è saltato fuori e ce l'ha fregato!", spanish="Antes encontramos un tesoro\ny nos lo quitó delante de nuestras narices."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(11010) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_masukippa4, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_masukippa) end)
  SkySceneKit.say({english=" !!![K] Where'd he go?!", french=" !!![K] Où est-il passé?!", german=" ...[K]Wo ist er überhaupt?!?", italian=" !!![K] Dov'è finito?!", spanish=" ¡Eh![K] ¡¿Adónde ha ido?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_goorikii, npc_npc_masukippa4, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_masukippa2, npc_npc_masukippa4, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sheimi, npc_npc_masukippa4, 4) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_masukippa, npc_npc_masukippa4, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kuchiito, npc_npc_masukippa4, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_masukippa5, npc_npc_masukippa4, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_masukippa3, npc_npc_masukippa4, 4) end)
  GAME:WaitFrames(3)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharTurnToCharAnimated(__slot, npc_npc_masukippa4, 4) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharTurnToCharAnimated(__slot, npc_npc_masukippa4, 4) end) end end
  GAME:WaitFrames(4)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_masukippa4, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_masukippa) end)
  SkySceneKit.say({english="That...!\nHe ran off in the confusion!", french="Grrrr... Ce...!\nIl a profité de la confusion pour s'enfuir!", german="So ein...\nEr hat sich im Trubel davongemacht!", italian="Quel...!\nNella confusione se l'è svignata!", spanish="¡Será...!\n¡Ha aprovechado todo este lío para huir!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_masukippa4, nil, 0) end) -- EFFECT_NONE
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_kinogassa, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english=" Huh...? Really...?", french=" Hein...? Vraiment...?", german=" Was? Im Ernst?", italian=" Uh...? Davvero...?", spanish=" ¿Pero...? ¿En serio...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kuchiito, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="We all thought you were the\nbad guys...", french="Dire qu'on vous a tous pris pour\nles méchants...", german="Wir alle dachten, ihr würdet\ndafür die Verantwortung tragen...", italian="Pensavamo che i cattivi\nfoste voi...", spanish="Pensábamos que vosotros erais\nlos malos de la película..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_goorikii) end)
  SkySceneKit.say({english=" .........", french=" ..........", german=" ..........", italian=" ..........", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_sheimi, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Well, you can't exactly say\nthey're the good guys, either...", french="Eh bien... on ne peut pas\nexactement dire que ce sont les gentils,\nnon plus...", german="Na ja, man kann auch nicht\nunbedingt das Gegenteil behaupten...", italian="Beh, non si può certo dire\nche siano dolci e gentili...", spanish="En fin, no es que se pueda decir\nque son los buenos, en realidad..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_sheimi, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_goorikii, npc_npc_sheimi, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_masukippa2, npc_npc_sheimi, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_masukippa4, npc_npc_sheimi, 4) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_masukippa, npc_npc_sheimi, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kuchiito, npc_npc_sheimi, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_masukippa5, npc_npc_sheimi, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_masukippa3, npc_npc_sheimi, 4) end)
  GAME:WaitFrames(3)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharTurnToCharAnimated(__slot, npc_npc_sheimi, 4) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharTurnToCharAnimated(__slot, npc_npc_sheimi, 4) end) end end
  GAME:WaitFrames(4)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_masukippa, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_masukippa) end)
  SkySceneKit.say({english="Hey!\nWe haven't seen you in so long, [CS:N]Shaymin[CR], and\nthis is how you treat us?!", french="Hé!\nOn se revoit après tout ce temps, [CS:N]Shaymin[CR],\net c'est comme ça que tu nous traites?!", german="He! Da haben wir uns so lange\nnicht gesehen, [CS:N]Shaymin[CR], und dann werden wir\nso behandelt?!?", italian="Ehi, [CS:N]Shaymin[CR]!\nÈ questo il modo di trattarci dopo che non\nci vediamo da così tanto tempo?!", spanish="Oye, [CS:N]Shaymin[CR], con todo el tiempo\nque hace que no nos vemos, ¿y así es como\nnos tratas?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sheimi, npc_npc_masukippa, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_masukippa, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_goorikii, npc_npc_masukippa, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_masukippa) end)
  SkySceneKit.say({english="Meh, it's fine.\nSince it's [CS:N]Shaymin[CR], we'll let it go.", french="Mmh, soit!\nÇa ira pour cette fois, mais c'est bien parce\nque c'est toi, [CS:N]Shaymin[CR].", german="Ach, ist schon okay.\nEs handelt sich um [CS:N]Shaymin[CR],\nalso belassen wir es dabei.", italian="Bah, non importa...\nPer questa volta lasciamo perdere, ma solo\nperché sei tu, [CS:N]Shaymin[CR].", spanish="Bueno, por esta vez, pase.\nPero solo porque eres tú, [CS:N]Shaymin[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_masukippa) end)
  SkySceneKit.say({english="The decision to climb the\nmountain is your own. But I don't like to let\nPokémon just do as they please.", french="Si un Pokémon veut gravir la\nmontagne, c'est son droit. Mais ce n'est pas\nune raison pour le laisser faire n'importe quoi.", german="Eure Entscheidung, den Berg zu\nbesteigen. Aber ich mag es nicht, wenn jedes\nPokémon einfach tut, wonach ihm gerade ist.", italian="La decisione di scalare\nla montagna è solo vostra, ma non mi piace\nche i Pokémon facciano quello che vogliono.", spanish="Normalmente no me gusta dejar\nque los Pokémon hagan lo que les plazca, pero\nla decisión de subir a la montaña es vuestra."})
  pcall(function() UI:SetSpeaker(npc_npc_masukippa) end)
  SkySceneKit.say({english=" See you!", french=" A la prochaine!", german=" Macht's gut!", italian=" Ci vediamo!", spanish=" ¡Nos vemos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(210) end)
  GROUND:EntTurn(npc_npc_goorikii, Direction.UpRight)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  GROUND:MoveToPosition(npc_npc_masukippa, 228, 84, false, 2)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_masukippa2, Direction.UpRight)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_masukippa3, Direction.UpLeft)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_masukippa4, Direction.UpRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_masukippa5, Direction.UpLeft)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_masukippa5, 228, 84, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(npc_npc_masukippa4, 228, 84, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(npc_npc_masukippa3, 228, 84, false, 2)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_masukippa2, 228, 84, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_sheimi, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Excuse me.", french=" Il faut les excuser.", german=" Entschuldigt ihr Verhalten.", italian=" Vi prego di scusarli.", spanish=" No se lo tengáis en cuenta."})
  -- message_KeyWait
  GROUND:EntTurn(npc_npc_goorikii, Direction.Right)
  GAME:WaitFrames(3)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(4)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Left) end end
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="The [CS:N]Carnivine[CR] have marked this\nas their territory.", french="Les [CS:N]Vortente[CR] ont décrété que\nce territoire était le leur.", german="Die [CS:N]Venuflibis[CR] haben das hier\nals ihr Gebiet beansprucht.", italian="I [CS:N]Carnivine[CR] considerano questo\nluogo come loro territorio.", spanish="Los [CS:N]Carnivine[CR] están convencidos\nde que este territorio les pertenece."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="They're really nice, but they can\nbe a little rough when they speak...", french="Ils sont vraiment gentils, mais\npeut-être parfois un peu rudes\ndans leur manière de parler...", german="Sie sind wirklich nett, aber\nmanchmal vergreifen sie sich im Ton...", italian="Sono molto gentili, ma hanno\nun modo di parlare un po' aggressivo...", spanish="Son muy majos, pero a veces\nson un poco brutos en el trato..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="We're also to blame here.\nRather than listening to them, we just jumped\nstraight into a fight...", french="C'est notre faute aussi. Au lieu\nde les écouter, on a foncé tête baissée\ndans la mêlée...", german="Wir sind auch ein wenig selbst\nschuld. Statt ihnen zuzuhören, haben wir uns\ndirekt in einen Kampf verwickeln lassen...", italian="Però la colpa è anche nostra.\nInvece di ascoltare le loro ragioni, abbiamo\nsubito cercato lo scontro...", spanish="Pero no toda la culpa es suya.\nEn vez de escucharles, quisimos meternos\ndirectamente en una pelea..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="That's why you shouldn't just\njudge by appearances...", french="Comme quoi, il ne faut jamais\nse fier aux apparences...", german="Man sollte eben nicht\nvorschnell sein Urteil fällen.", italian="Ecco perché non bisogna mai\ngiudicare qualcosa in base alle apparenze...", spanish="Eso nos enseña que no debemos\njuzgar por las apariencias..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_goorikii, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_goorikii) end)
  SkySceneKit.say({english=" .........[K] Sorry!", french=" ..........[K] Pardon!", german=" ..........[K] Entschuldigung!", italian=" ..........[K] Ci dispiace!", spanish=" Bueno...[K] ¡Perdón!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_sheimi, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="It's all right! As long as you\nunderstand.", french="Pas de problème! Le principal,\nc'est de comprendre son erreur.", german="Schon in Ordnung!\nSolange ihr versteht.", italian="È tutto a posto! Basta che\nabbiate capito.", spanish="No pasa nada, siempre y cuando\nhayáis aprendido la lección."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_sheimi, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Sky Peak Prairie.ogg", true) end)
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="So! Let's put this behind us and\nget back to climbing!", french="Allons! Oublions cet incident et\npoursuivons l'ascension!", german="Gut! Lassen wir das hinter uns\nund steigen weiter den Berg hinauf!", italian="Ok! Lasciamoci alle spalle tutto\nquanto e proseguiamo la nostra esplorazione!", spanish="Bueno, vamos a pasar página y\nsigamos ascendiendo."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="This is the 5th Station Clearing![K]\nWe're halfway to the summit!", french="C'est la trouée du 5[F:E] Relais.[K]\nOn est à mi-chemin du sommet!", german="Das hier ist die\n5. Zwischenlagerlichtung![K] Wir sind auf halbem\nWeg zum Gipfel!", italian="Ecco il Bivacco 5![K]\nSiamo a metà strada!", spanish="¡La Base del Quinto Puerto![K]\n¡Ya estamos a medio camino!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english=" Yeah!", french=" Ouais!", german=" Juchhu!", italian=" Sì!", spanish=" ¡Bieeen!"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
