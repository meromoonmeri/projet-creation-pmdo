-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/un0111.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 416, 248, Direction.DownLeft, "NPC_HEIGANI")
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! [CS:Y]Bidoof[CR]!", french=" Hé dis donc! [CS:Y]Keunotor[CR]!", german=" Hey, hey! [CS:Y]Bidiza[CR]!", italian=" Ehi, ehi! [CS:Y]Bidoof[CR]!", spanish=" ¡Oye, oye, [CS:Y]Bidoof[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Have a successful exploration!", french="Je te souhaite\nune bonne exploration!", german=" Viel Erfolg bei deiner Erkundung!", italian="Ti auguro il meglio per\nla tua esplorazione!", spanish=" ¡Mucha suerte en la exploración!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" I'm cheering for you! Hey, hey!", french=" Je me réjouis pour toi, dis donc!", german="Ich drücke dir die Daumen!\nHey, hey!", italian=" Faccio il tifo per te! Ehi, ehi!", spanish=" ¡Me alegro mucho por ti!"})
  -- message_Close
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp_side(40, 3) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 3]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="I wonder...[K]what kind of jobs we\nhave today? Hey, hey...", french="Tiens...[K] Quel genre de\ntravail on a à faire aujourd'hui, dis donc?", german="Ich frage mich,[K] welche Jobs\nwir wohl heute übernehmen werden. Hey, hey...", italian="Mi chiedo...[K] quali missioni\ndovremo affrontare oggi... Ehi, ehi!", spanish="Me pregunto...[K] qué tipo de\nmisiones tenemos hoy... Vete a saber, oye..."})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(40, 2) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 2]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! [CS:Y]Bidoof[CR]! I've heard!", french="Hé dis donc! [CS:Y]Keunotor[CR]!\nJe suis au courant!", german="Hey, hey! [CS:Y]Bidiza[CR]!\nWas habe ich da gehört?!?", italian="Ehi, ehi! [CS:Y]Bidoof[CR]!\nL'ho appena saputo!", spanish="¡Oye, oye, [CS:Y]Bidoof[CR]!\n¡Ya me he enterado!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="You're taking the day off, huh?\nHey, hey!", french="Tu prends quelques jours de\ncongé, c'est pas vrai?", german="Du hast ein Weilchen frei?\nHey, hey!", italian="Ti sei preso un po' di riposo,\nvero? Ehi, ehi!", spanish="Te has tomado vacaciones, ¿eh?\n¡Eres un suertudo, oye!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Nice...[K] I wonder if I can get a\nday off too...", french="Chouette, alors![K]\nJe me demande si je peux en avoir un,\nmoi aussi...", german="Wie schön...[K] Ob ich mir wohl\nauch einmal einen Tag freinehmen kann?", italian="Bello...[K] Chissà se posso farlo\nanch'io...", spanish="¡Qué guay!...[K] Me pregunto si me\ndejarían librar un día a mí también..."})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! [CS:Y]Bidoof[CR]![K]\nAre you headed out?", french="Hé dis donc! [CS:Y]Keunotor[CR]![K]\nTu vas faire un tour?", german="Hey, hey! [CS:Y]Bidiza[CR]![K]\nMachst du dich auf den Weg?", italian="Ehi, ehi! [CS:Y]Bidoof[CR]![K]\nStai uscendo?", spanish=" ¡Oye, [CS:Y]Bidoof[CR]![K] ¿Vas a algún sitio?"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="You've had a few setbacks\nso far, but no worries! Hey, hey, hey!", french="Tu as connu quelques déboires\njusque-là, mais ne te fais pas trop de soucis,\nsaperlipopince!", german="Es gab für dich vielleicht ein\npaar Rückschläge, aber mach dir keine Sorgen!\nHey, hey, hey!", italian="Finora non ti è andata molto\nbene, ma non abbatterti! Ehi, ehi, ehi!", spanish="Has tenido algunos contratiempos\nhasta ahora, ¡pero no te preocupes!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Incidentally...", french=" A propos...", german=" Übrigens...", italian=" A proposito...", spanish=" A propósito..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.turn_to_pos(npc_npc_heigani, 312, 104) -- Turn2DirectionMark
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Did you know that you can also\nmake a record of your adventure at the\nWatering Hole?", french="Tu savais que tu peux aussi\nsauvegarder ta partie au Point d'Eau?", german="Wusstest du, dass du den\nFortschritt deines Abenteuers auch beim\nWasserloch sichern kannst?", italian="Lo sapevi che puoi salvare\nla partita anche al pozzo?", spanish="¿Sabías que también puedes\nguardar la partida en la fuente?"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="You don't have to head all the\nway back to your bed. You can do that\nhere too! Hey, hey!", french="Tu n'as pas besoin de revenir\nà ton lit pour sauvegarder, tu peux le faire\nici aussi, dis donc!", german="Du musst nicht den ganzen Weg\nzurück zu deinem Bett. Das kannst du auch\nhier erledigen! Hey, hey!", italian="Non devi tornare al tuo letto per\nfarlo. Puoi salvare anche qui! Ehi, ehi!", spanish="No tienes que volverte a la\ncama para guardar, ¡puedes hacerlo aquí!\n¡Qué lujo, oye!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="It's convenient when you want to\nmake a record of your progress frequently,\nso don't forget! Hey, hey!", french="C'est pratique quand tu veux\nsauvegarder souvent, alors penses-y,\ndis donc!", german="Das ist praktisch, wenn du den\nFortschritt häufiger sichern möchtest. Vergiss\nes also nicht! Hey, hey!", italian="È molto utile quando vuoi\nsalvare spesso la partita, quindi non\ndimenticartelo! Ehi, ehi!", spanish="Es muy práctico si te gusta\nguardar la partida con frecuencia, ¡así que\nno lo olvides!"})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
