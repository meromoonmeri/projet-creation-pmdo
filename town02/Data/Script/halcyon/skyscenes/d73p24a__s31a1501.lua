-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P24A/s31a1501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 18) -- $SCENARIO_MAIN = scn[29,18] (ROM)
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 232, 408, Direction.Up, "NPC_SHEIMI")
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We're almost to the 4th Station\nClearing! Come on!", french="Nous avons presque atteint\nla trouée du 4[F:E] Relais! Poursuivons!", german="Wir sind schon fast an der\n4. Zwischenlagerlichtung! Los, nur noch ein\nkleines Stück!", italian="Ancora un piccolo sforzo\ne saremo al Bivacco 4! Forza!", spanish="Ya casi hemos llegado a la Base\ndel Cuarto Puerto. ¡Venga!"})
  -- message_Close
  -- back_SetGround(LEVEL_D73P24A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_D73P24A, 'US31') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(9) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(40) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(9) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_tamatama = SkySceneKit.spawn_npc("exeggcute", 320, 256, Direction.Down, "NPC_TAMATAMA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_jiguzaguma = SkySceneKit.spawn_npc("zigzagoon", 152, 288, Direction.DownLeft, "NPC_JIGUZAGUMA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_okutan = SkySceneKit.spawn_npc("octillery", 232, 144, Direction.Down, "NPC_OKUTAN")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Sky Peak Prairie.ogg", true) end)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_sheimi, 228, 268, false, 2)
  GROUND:MoveToPosition(hero, 228, 300, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 252, 308, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 204, 308, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_jiguzaguma, Direction.DownRight)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  local npc_npc_kinogassa = SkySceneKit.spawn_npc("breloom", 184, 216, Direction.Up, "NPC_KINOGASSA")
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_kuchiito = SkySceneKit.spawn_npc("mawile", 288, 224, Direction.DownLeft, "NPC_KUCHIITO")
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GROUND:EntTurn(npc_npc_kinogassa, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_goorikii = SkySceneKit.spawn_npc("machoke", 264, 248, Direction.UpRight, "NPC_GOORIKII")
  GROUND:EntTurn(npc_npc_goorikii, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_kinogassa.Position; GROUND:MoveToPosition(npc_npc_kinogassa, p.X+(8), p.Y+(8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english=" Hey! Great job!", french=" Hé! Beau travail!", german=" He! Toll gemacht!", italian=" Ehi! Ottimo lavoro!", spanish=" ¡Eh, buen trabajo!"})
  GROUND:EntTurn(npc_npc_sheimi, Direction.UpLeft)
  GROUND:EntTurn(hero, Direction.UpLeft)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="We've also established a base at\nthe 4th Station Clearing. Feel free to use it.", french="Nous avons aussi établi un\ncampement à la trouée du 4[F:E] Relais.\nN'hésitez pas à l'utiliser.", german="Wir haben eine Basis auf der\n4. Zwischenlagerlichtung errichtet. Sie steht\nzu eurer Verfügung.", italian="Abbiamo creato un campo base\nanche al Bivacco 4. È a vostra disposizione,\nusatelo senza problemi.", spanish="También hemos levantado un\ncampamento en la Base del Cuarto Puerto.\nUsadlo cuanto queráis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Yes, thank you!", french=" Oui, merci!", german=" Ja, vielen Dank!", italian=" Sì, grazie!", spanish=" ¡Ah, muchas gracias!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sheimi, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  GAME:WaitFrames(5)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="So, you're probably tired? Let's\ntake a short break.", french="Alors, on fatigue?\nFaisons une petite pause.", german="Du bist wahrscheinlich müde,\noder? Lass uns eine kurze Pause einlegen.", italian="Immagino che la stanchezza\nsi stia facendo sentire, non è vero?\nFacciamo una piccola pausa.", spanish="Seguro que os caéis del\ncansancio, ¿no? Vamos a descansar un poco."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end) -- message_SetActor(ACTOR_NPC_OKUTAN)
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english=" HELP!!!", french=" AU SECOURS!!!", german=" HILFE!!!", italian=" AIUTO!!!", spanish=" ¡¡¡Socorro!!!"})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, "exclaim", 1) end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_kinogassa, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kuchiito, "exclaim", 1) end)
  GAME:WaitFrames(2)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sheimi, npc_npc_okutan, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kinogassa, npc_npc_okutan, 4) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kuchiito, npc_npc_okutan, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_goorikii, npc_npc_okutan, 4) end)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_jiguzaguma, Direction.UpRight)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_tamatama, Direction.UpLeft)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_okutan, 228, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sheimi, npc_npc_okutan, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kinogassa, npc_npc_okutan, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kuchiito, npc_npc_okutan, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_goorikii, npc_npc_okutan, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english=" Uhhn...huhhn...", french=" Ouffff... ouffff... pffff...", german=" Pfhhhh... Pfhhhh...", italian=" Pant... pant...", spanish=" Arf... arf..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_kuchiito.Position; GROUND:MoveToPosition(npc_npc_kuchiito, p.X+(-8), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kuchiito, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english=" What's wrong?!", french=" Que se passe-t-il?!", german=" Stimmt etwas nicht?", italian=" Che succede?!", spanish=" ¡¿Qué ocurre?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_okutan, npc_npc_kuchiito, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_okutan, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="The explorer [CS:N]Sneasel[CR]'s getting\npicked on by this strange group near the\n5th Station Clearing!", french="L'explorateur [CS:N]Farfuret[CR] a maille\nà partir avec des types louches près de la\ntrouée du 5[F:E] Relais.", german="Der Erkunder [CS:N]Sniebel[CR] wird von\neiner dubiosen Gruppe in der Nähe der\n5. Zwischenlagerlichtung drangsaliert!", italian="L'esploratore [CS:N]Sneasel[CR] è stato\nassalito da uno strano gruppo nelle vicinanze\ndel Bivacco 5!", spanish="¡Un grupo muy raro la ha tomado\ncon el explorador [CS:N]Sneasel[CR] cerca de la Base\ndel Quinto Puerto!"})
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="I'm not much help by myself, so\nplease, someone come with me to help!", french="Toute seule, je ne peux pas faire\ngrand-chose, alors, s'il vous plaît,\nallons lui porter secours ensemble!", german="Ich bin leider keine große Hilfe.\nWenn mich also bitte jemand begleiten könnte...", italian="Non posso aiutarlo da sola,\nquindi vi prego, qualcuno venga con me!", spanish="Yo sola no soy de mucha utilidad,\nasí que necesito que alguien venga a ayudarme."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_okutan, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_kinogassa, Direction.DownRight)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_kuchiito, Direction.DownLeft)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_okutan, Direction.DownRight)
  -- message_FacePositionOffset(-2, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_goorikii) end)
  SkySceneKit.say({english=" Move out!", french=" On bouge!", german=" Auf geht's!", italian=" Presto!", spanish=" ¡Vamos corriendo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english=" Roger! Let's go!", french=" Reçu! C'est parti!", german="Verstanden! Machen wir uns auf\nden Weg!", italian=" Ricevuto! Andiamo!", spanish=" ¡Entendido! ¡Vamos allá!"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_goorikii, 260, 204, false, 2)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_kuchiito, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_kinogassa, Direction.UpRight)
  GROUND:EntTurn(npc_npc_okutan, Direction.Up)
  GAME:WaitFrames(40)
  GROUND:MoveToPosition(npc_npc_kinogassa, 228, 172, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(npc_npc_kuchiito, 228, 172, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" The 5th Station Clearing...", french=" La trouée du 5[F:E] Relais...", german=" Die 5. Zwischenlagerlichtung...", italian=" Il Bivacco 5...", spanish=" La Base del Quinto Puerto..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Oh!\nDon't tell me...!", french="Oh!\nNe me dites pas que...!", german="Oh!\nSag nichts!", italian="Oh!\nNon ditemi che...!", spanish=" ¡Vaya! No me digas que..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_sheimi, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="[player]!\nWe should hurry too!", french="[player]!\nOn ferait mieux de se dépêcher, nous aussi!", german="[player]!\nWir sollten uns auch beeilen!", italian="[player]!\nMuoviamoci anche noi!", spanish="¡Deberíamos darnos prisa\ntambién, [player]!"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
