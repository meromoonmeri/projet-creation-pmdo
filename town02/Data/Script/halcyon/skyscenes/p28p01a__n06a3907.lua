-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P28P01A/n06a3907.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- back_SetGround(LEVEL_P28P01A) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(150) end)
  local npc_npc_manyuura = SkySceneKit.spawn_npc("weavile", 160, 208, Direction.Up, "NPC_MANYUURA")
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" ...[K]A Time Gear, huh...?", french=" ...[K] Un Rouage du Temps, hein...?", german=" ...[K]Ein Zahnrad der Zeit also...", italian="...[K] Un Ingranaggio del Tempo,\neh...?", spanish=" Ah,[K] conque un Engranaje del Tiempo..."})
  -- bgm2_PlayFadeIn(BGM_CAVE_AMBIANCE) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="Tsk.[K] I guess we don't have\nany choice.", french=" Tsss.[K] Nous n'avons pas le choix.", german="Tsss.[K] Uns bleibt wohl keine\nandere Wahl.", italian="Tsk.[K] Mi sa che non abbiamo\nscelta.", spanish="Vaya.[K] Parece que no tenemos\nelección."})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="[CS:N]Arbok[CR]! [CS:N]Drapion[CR]![K]\nWe're going home!", french="[CS:N]Arbok[CR]! [CS:N]Drascore[CR]![K]\nOn rentre!", german="[CS:N]Arbok[CR]! [CS:N]Piondragi[CR]![K]\nKommt schon, wir gehen!", italian="[CS:N]Arbok[CR]! [CS:N]Drapion[CR]![K]\nAndiamocene!", spanish="[CS:N]Arbok[CR], [CS:N]Drapion[CR]...[K]\nNos vamos a casa."})
  -- message_Close
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 128, 184, Direction.UpRight, "NPC_CHAAREMU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_manyuura, 4) end)
  GAME:WaitFrames(6)
  local npc_npc_aabokku = SkySceneKit.spawn_npc("arbok", 128, 208, Direction.Up, "NPC_AABOKKU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_aabokku, npc_npc_manyuura, 4) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_manyuura, 4) end)
  GAME:WaitFrames(6)
  local npc_npc_dorapion = SkySceneKit.spawn_npc("drapion", 192, 208, Direction.Up, "NPC_DORAPION")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dorapion, npc_npc_manyuura, 4) end)
  GAME:WaitFrames(9)
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 184, 184, Direction.UpLeft, "NPC_SAANAITO")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_manyuura, 4) end)
  GAME:WaitFrames(4)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 160, 224, Direction.Up, "NPC_PUKURIN")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_manyuura, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Huh?![K] W-wait up, you!", french=" Hein?![K] Attends un peu, toi!", german=" Hmmm?[K] Jetzt wartet aber mal!", italian=" Uh?![K] E-Ehi voi, aspettate!", spanish=" ¡¿Eh?![K] ¡Pe... pero esperad!"})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_manyuura, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(6)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(6)
  GROUND:EntTurn(npc_npc_aabokku, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" What?", french=" Quoi?", german=" Was?", italian=" Cosa?", spanish=" ¿Qué pasa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="You're a band of thieves that\ndoes bad things, aren't you?", french="Vous êtes une bande de voleurs\nspécialistes des mauvais coups, n'est-ce pas?", german="Ihr seid doch eine Diebesbande,\ndie böse Dinge tut, oder nicht?", italian="Ma non siete una banda di ladri\npronti a tutto pur di ottenere quello che\nvolete?", spanish="Sois una banda de ladrones que\nrobáis cualquier cosa de valor, ¿no?"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="So you're just going to go home\nwithout stealing anything?", french="Et vous voulez nous faire croire\nque vous allez rentrer chez vous sans avoir\nvolé quoi que ce soit?", german="Warum geht ihr dann einfach\nnach Hause, ohne irgendetwas zu stehlen?", italian="E come mai adesso ve ne andate\nsenza rubare nulla?", spanish="¿Y os vais a ir a casa\nsin intentar nada?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="Humph![K] If it were some other\ntreasure, it'd be fine...", french="Pfff![K] Nous n'aurions eu aucun\nscrupule à faire main basse sur n'importe quel\nautre trésor...", german="Humpf![K] Wenn es sich um\nirgendeinen anderen Schatz handeln würde,\ngerne...", italian="Umpf![K] Se si trattasse di\nun altro tesoro, non ci sarebbero problemi...", spanish="¡Ja![K] Si se tratara de cualquier\notro tesoro, claro que nos lo llevaríamos..."})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="But you can't just steal a\nTime Gear and take it with you.", french="Mais on ne vole pas un Rouage\ndu Temps. C'est sacré.", german="Aber du kannst nicht einfach ein\nZahnrad der Zeit entwenden und mitnehmen.", italian="Ma non si può rubare un\nIngranaggio del Tempo e portarselo\nvia come niente.", spanish="Pero no se roba un\nEngranaje del Tiempo por las buenas."})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="Even though we're scoundrels,\nwe at least know that much.", french="On est peut-être des bandits,\nmais on ne jouerait pas à ça.", german="Auch wenn wir Halunken sind,\nso viel Wissen haben selbst wir.", italian="Anche se siamo delle canaglie,\nnemmeno noi potremmo farlo.", spanish=" Somos granujas, pero no tanto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" I-is that so?", french=" Vraiment?", german=" A-ach, so ist das?", italian=" D-Davvero?", spanish=" ¿E... en serio?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" Yeah...", french=" Ouais...", german=" Ja...", italian=" Certo...", spanish=" Claro..."})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="There are some things you just\ncan't take.", french="Il y a certaines choses\nauxquelles il ne faut pas toucher.", german="Es gibt Dinge, die man einfach\nnicht nehmen kann.", italian="Ci sono delle cose che non\nsi possono prendere.", spanish="Hay ciertas cosas que\nno se pueden robar."})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" Like a Time Gear...", french="Les Rouages du Temps en font\npartie...", german=" So wie ein Zahnrad der Zeit...", italian=" Come un Ingranaggio del Tempo...", spanish=" Como un Engranaje del Tiempo..."})
  -- message_Close
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
end
