-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P04A/um1106.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- SetAnimation(2) [anim idle native]
  local npc_npc_nyuura = SkySceneKit.spawn_npc("sneasel", 272, 192, Direction.Up, "NPC_NYUURA")
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_nyuura, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyuura) end)
  SkySceneKit.say({english=" .........", french=" .........", german=" .........", italian=" .........", spanish=" ..."})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 25] || scn($SCENARIO_MAIN) >= [2
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_nyuura, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyuura) end)
  SkySceneKit.say({english=" Ugh... Oof...", french=" Argh... Ouf...", german=" Uff... Uuuff...", italian=" Urgh... Oooh...", spanish=" Ay... Uf..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 23] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_nyuura) end)
  SkySceneKit.say({english=" Huh? [CS:I]Sky Gift[CR]?", french=" Hein? Les [CS:I]Dons du Ciel[CR]?", german=" Wie? [CS:I]Himmelspräsent[CR]?", italian=" Eh? Un [CS:I]Dono Cielo[CR]?", spanish=" ¿Eh? ¿Un [CS:I]Regalo Cielo[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_nyuura) end)
  SkySceneKit.say({english=" It isn't really treasure...", french="Ce sont pas vraiment\ndes trésors...", german=" Das ist kein richtiger Schatz...", italian=" Ma non è affatto un tesoro...", spanish=" Es un tesoro de mentirijilla..."})
  pcall(function() UI:SetSpeaker(npc_npc_nyuura) end)
  SkySceneKit.say({english="There's no point in treasure if\nyou don't get to keep it yourself.", french="Ça n'a rien d'un trésor,\nsi tu ne peux pas le garder pour toi.", german="Schätze sind doch sinnlos,\nwenn man sie nicht behalten darf!", italian="Come si fa a definire tesoro\nqualcosa che non puoi tenere tutto per te?", spanish="¿Qué clase de tesoro va a ser si\nno te lo puedes quedar? ¡Menuda tontería!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 15] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_nyuura) end)
  SkySceneKit.say({english="Huh? That legendary treasure\nwill need to be found by someone of legend...\nI'd say that's me!", french="Hein? Pour trouver un trésor\nlégendaire, il faut quelqu'un de légendaire,\net ce quelqu'un, c'est moi!", german="Der legendäre Schatz wird von\njemand Legendärem gefunden werden...\nIch würde mal sagen, das bin ich!", italian="Uh? Quel tesoro leggendario può\nessere trovato solo da un esploratore\neccezionale... Cioè io!", spanish="¿Eh? Ese tesoro legendario debería\nencontrarlo alguien que cree leyenda...\n¡Quién mejor que yo!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 11] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_nyuura, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyuura) end)
  SkySceneKit.say({english="Heh-heh-heh...\nThe legendary treasure will be claimed by\n[CS:N]Sneasel[CR]!", french="Hé hé hé...\nC'est [CS:N]Farfuret[CR] qui pourra s'enorgueillir\nd'avoir trouvé le trésor légendaire!", german="Hehehe...\n[CS:N]Sniebel[CR] wird den legendären Schatz für sich\nbeanspruchen!", italian="Eh eh eh...\nSarò io, [CS:N]Sneasel[CR], a mettere le mani\nsu quel tesoro leggendario!", spanish="Je, je, je... ¡[CS:N]Sneasel[CR] encontrará\nel tesoro legendario!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 8] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_nyuura, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyuura) end)
  SkySceneKit.say({english="Heh-heh-heh. I found a so-called\n\"Secret Room\" earlier.", french="Hé hé hé. J'ai trouvé une\nsoi-disant \"Salle Secrète\", un peu plus tôt.", german="Hehehe. Ich habe vorhin einen\nsogenannten [F:S2]Geheimraum[F:E2] gefunden.", italian="Eh eh eh! Prima ho trovato una\ncosiddetta \"Sala Segreta\".", spanish="Je, je, je. Antes encontré\nuna de esas \"Cámaras Secretas\"."})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_nyuura, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_nyuura) end)
  SkySceneKit.say({english=" Huh? Where was it?", french=" Hein? Où ça?", german=" Äh? Wo das war?", italian="Eh? Vuoi sapere dove\nsi trovava?", spanish=" ¿Cómo? ¿Que dónde estaba?"})
  pcall(function() UI:SetSpeaker(npc_npc_nyuura) end)
  SkySceneKit.say({english="Ha ha ha! Like I'm going to tell\nyou that!", french="Ha ha ha! Comme si j'allais\nte le dire!", german="Ha ha ha! Als ob ich dir das\nsagen würde!", italian="Ah ah ah! E tu credi che venga\na dirlo a te?!", spanish="¡Como que te lo iba a decir a ti!\n¡Ja, ja, ja!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 1] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_nyuura, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyuura) end)
  SkySceneKit.say({english="I'm [CS:N]Sneasel[CR].\nI'm a one-Pokémon exploration team.", french="Je suis [CS:N]Farfuret[CR].\nJe suis une équipe d'exploration\nà moi tout seul.", german="Mein Name ist [CS:N]Sniebel[CR].\nIch bin ein Einzel-Pokémon-Erkundungsteam.", italian="Mi chiamo [CS:N]Sneasel[CR].\nSono un esploratore solitario.", spanish="Soy [CS:N]Sneasel[CR] y soy el único\nmiembro de mi equipo explorador."})
  pcall(function() UI:SetSpeaker(npc_npc_nyuura) end)
  SkySceneKit.say({english="I won't let anyone get in my\nway, ever.", french="Je laisserai jamais personne\ntraîner dans mes pattes.", german="Ich werde niemals zulassen,\ndass sich mir jemand in den Weg stellt.", italian="Non permetterò a nessuno di\nintralciarmi! Capito?", spanish="Nunca dejo que nadie\nse interponga en mi camino, jamás."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
