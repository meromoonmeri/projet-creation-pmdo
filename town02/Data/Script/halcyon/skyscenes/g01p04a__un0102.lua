-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/un0102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Meh-heh-heh! [K]I sit here and\nstare at my Swap Cauldron and...", french="Mwé hé hé! [K]Je m'assois là et je\ncontemple mon Chaudron-Troc...", german="Mehehe! [K]Ich sitze hier, starre\nmeinen Tauschkessel an, und...", italian="Eh eh eh! [K]Rimango seduto qui\na fissare il mio Pentolone dei Cambi...", spanish="¡Je, je, je![K] Me siento a observar\nla perfección de mi Caldero de Trueque y..."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english=" I wait for good news!", french=" J'attends une bonne nouvelle!", german=" Und warte auf gute Neuigkeiten!", italian="... in attesa di ricevere buone\nnotizie!", spanish=" ¡Espero buenas noticias!"})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Good luck! Do your best!\nMeh-heh-heh!", french="Bonne chance! Fais de ton mieux!\nMwé hé hé!", german="Viel Erfolg! Gib dein Bestes!\nMehehe!", italian="Buona fortuna! Fai del tuo\nmeglio! Eh eh eh!", spanish="¡Buena suerte! ¡A por todas!\n¡Je, je, je!"})
  -- message_Close
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp_side(40, 3) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 3]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="My Swap Cauldron is the best!\nMeh-heh-heh!", french="Mon Chaudron-Troc\nest le meilleur! Mwé hé hé!", german="Mein Tauschkessel ist der beste!\nMehehehe!", italian="Il mio Pentolone dei Cambi\nè il massimo! Eh eh eh!", spanish="¡Mi Caldero de Trueque es\nel mejor! ¡Je, je, je!"})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="But it's being repaired right now,\nso it's unusable... Meh-heh-heh...", french="Mais il est en réparation pour\nl'instant, et donc inutilisable... Mwé hé hé...", german="Aber da er gerade in Reparatur\nist, kann ich ihn nicht verwenden... Mehehe...", italian="Ma ora è a riparare, quindi non\nposso utilizzarlo... Eh eh eh!", spanish="Pero me lo están arreglando, así\nque está inservible... Je, je, je..."})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(40, 2) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 2]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english=" Meh-heh-heh. Vacation, huh?", french=" Mwé hé hé... Quoi? Congé?", german=" Mehehe. Urlaub, wie?", italian=" Eh eh eh! In vacanza, dici?", spanish=" Je, je, je. De vacaciones, ¿eh?"})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english=" I'm not jealous at all.", french="Je ne suis pas jaloux,\npas du tout.", german="Dafür beneide ich dich\nüberhaupt nicht.", italian=" Non sono affatto invidioso.", spanish=" No me das ninguna envidia."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english=" Because...", french=" Parce que...", german=" Denn...", italian=" E sai perché?", spanish=" Porque..."})
  -- message_Close
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(8)
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Because I've got this\nSwap Cauldron.", french=" Parce que j'ai ce Chaudron-Troc.", german="Denn ich habe diesen\nTauschkessel.", italian="Perché io ho questo\nPentolone dei Cambi.", spanish="Porque tengo este\nCaldero de Trueque tan molón."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="I just love my Swap Cauldron\nso much. It's good! Meh-heh-heh!", french="J'aime mon Chaudron-Troc,\nc'est fou comme je l'aime. Mwé hé hé!", german="Ich mag meinen Tauschkessel so\nsehr. Er ist gut! Mehehehe!", italian="Adoro il mio Pentolone dei\nCambi. È così bello! Eh eh eh!", spanish="Le tengo un cariño indecible a mi\nCaldero de Trueque. ¡Es genial! ¡Je, je, je!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "happy", 1) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="But...[K]it's being repaired right\nnow, so I can't use it. Meh-heh-heh.", french="Mais...[K] il est en réparation en ce\nmoment, alors je ne peux pas l'utiliser.\nMwé hé hé.", german="Nur...[K] wird er gerade repariert,\ndaher kann ich ihn nicht verwenden. Mehehe.", italian="Ma...[K] adesso l'ho portato\na riparare, quindi non posso usarlo. Eh eh eh!", spanish="Pero resulta...[K] que me lo\nestán arreglando y no puedo usarlo. Je, je, je."})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Meh-heh-heh. Today seems to be\nanother long day.", french="Mwé hé hé... Une nouvelle\njournée sans fin qui s'annonce, pas vrai?", german="Mehehe. Scheint ein\nweiterer langer Tag zu sein.", italian="Eh eh eh! Pare che anche oggi\nsarà una lunga giornata.", spanish="Je, je, je. Hoy parece que\nva a ser otro largo día."})
  pcall(function() UI:SetSpeaker(npc_npc_guregguru) end)
  SkySceneKit.say({english="Well, don't just loaf around.\nTake care of your chores. Meh-heh-heh!", french="Hé bien, ne reste pas planté là,\ntu as du travail à faire... Mwé hé hé!", german="Lungere nur nicht herum,\nsondern nimm deine Pflichten ernst. Mehehe!", italian="Beh, smettila di bighellonare\ne torna alle tue faccende. Eh eh eh!", spanish="Bueno, nada de holgazanear,\nocúpate de tus tareas. ¡Je, je, je!"})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
