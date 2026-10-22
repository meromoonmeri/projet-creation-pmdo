-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/um0313.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_nyorotono = SkySceneKit.spawn_npc("politoed", 272, 240, Direction.DownLeft, "NPC_NYOROTONO")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_nyorotono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english=" Exploring is always fun! ♪", french="L'exploration, c'est toujours un\nvisa pour l'aventure, pas vrai, les copains? ♪", german=" Erkunden macht immer Spaß! ♪", italian="Esplorare è sempre\ndivertente! ♪", spanish=" ¡Explorar es divertidísimo! ♪"})
  -- message_Close
  -- @label_131 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 93] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_nyorotono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english=" Go for it!", french=" Foncez!", german=" Haltet euch ran!", italian=" Forza!", spanish=" ¡Adelante con ello!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 85] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_nyorotono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english="A [CS:I]Wonder Gummi[CR] is a\nfantastic Gummi! ♪", french="La [CS:I]Gelée Miracle[CR],\nc'est une gelée fantastique! ♪", german="Ein [CS:I]Wundergummi[CR] ist ein\nfantastisches Gummi! ♪", italian="La [CS:I]Gommaincanto[CR] è\nbuonissima!", spanish="¡La [CS:I]Gomi Ingenio[CR] es una gomi\nfantástica! ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56] || scn($SCENARIO_MAIN) >= [2
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_togepii = SkySceneKit.spawn_npc("togepi", 248, 264, Direction.Up, "NPC_TOGEPII")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_rediba = SkySceneKit.spawn_npc("ledyba", 216, 224, Direction.UpRight, "NPC_REDIBA")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_nyorotono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english=" Oh, wow! How nice! ♪", french=" Oh, waaaouh! Super! ♪", german=" Oh, wow! Wie nett! ♪", italian=" Oh, wow! Che bello! ♪", spanish=" ¡Oh, vaya! ¡Qué chachi! ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_nyorotono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english="I'm so happy that we got to go\nto the [CS:P]Shaymin Village[CR]. ♪", french="Je suis content d'être allé\nau [CS:P]Village Shaymin[CR]. ♪", german="Ich bin so froh, dass wir\n[CS:P]Shaymin-Dorf[CR] erreicht haben. ♪", italian="Sono così felice di essere\narrivato al [CS:P]Villaggio Shaymin[CR]. ♪", spanish="Me alegro de que hayamos podido\nllegar a [CS:P]Aldea Shaymin[CR]. ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 41] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_nyorotono, 4) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_nyorotono, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english="How thoughtless of me!\nHa ha ha!", french="Quel étourdi je fais!\nHa ha ha!", german="Wie gedankenlos von mir!\nHa ha ha!", italian="Ma che sbadato che sono!\nAh ah ah!", spanish="¡Qué desconsiderado soy!\n¡Ja, ja, ja!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_nyorotono, nil, 0) end) -- EFFECT_NONE
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_nyorotono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english=" This place is so relaxing. ♪", french=" Cet endroit est si reposant. ♪", german=" Dieser Ort ist so entspannend. ♪", italian="Questo posto è così\nrilassante. ♪", spanish=" Este lugar es muy relajante. ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 26] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_nyorotono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english="It's a so-called secret, so it\nmust be hidden...", french="C'est soi-disant un secret,\nalors il doit être caché...", german="Es ist ein sogenanntes\nGeheimnis, also wird es wohl versteckt sein?", italian="Se è segreto allora significa\nche è nascosto...?", spanish="Dicen que es secreto, así que\nestará escondido, ¿no?"})
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english="It's hard to find, huh?\nHa ha ha. ♪", french="Pas facile à trouver, hein?\nHa ha ha. ♪", german="Wohl schwer zu finden, oder?\nHa ha ha. ♪", italian="È difficile da trovare, eh?\nAh ah ah. ♪", spanish="No es fácil de encontrar, ¿eh?\nJa, ja, ja. ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 20] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_nyorotono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english="[CS:N]Shaymin[CR] are so small\nand cute. ♪", french="Les [CS:N]Shaymin[CR] sont tout petits\net tout mignons! ♪", german="[CS:N]Shaymin[CR] sind so klein\nund süß. ♪", italian="Gli [CS:N]Shaymin[CR] sono così piccoli\ne carini. ♪", spanish="Los [CS:N]Shaymin[CR] son tan\npequeñitos y tan monos. ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 9) >= 0) or (SkyProg.cmp(29, 8) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 10] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_nyorotono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english=" Let's find some treasure... ♪", french=" Allons chercher les trésors! ♪", german=" Lasst uns Schätze finden... ♪", italian=" Scoviamo qualche tesoro... ♪", spanish=" Vamos a buscar tesoros... ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 6] || scn($SCENARIO_MAIN) >= [29
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_nyorotono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english=" You two are great! ♪", french=" Vous êtes super! ♪", german=" Ihr seid großartig! ♪", italian=" Siete forti! ♪", spanish=" ¡Sois lo mejor que hay! ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [25, 4] || scn($SCENARIO_MAIN) >= [25
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_nyorotono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english=" An Egg is...[K]sort of happy! ♪", french="Un Œuf, c'est... [K]c'est du\nbonheur à l'état pur, pas vrai? ♪", german=" Ein Ei ist[K] eigentlich glücklich! ♪", italian=" Un Uovo...[K] porta la felicità! ♪", spanish=" Un Huevo...[K] ¡Qué felicidad! ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [15, 1] || scn($SCENARIO_MAIN) >= [14
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_nyorotono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english=" I want to win big...", french=" Je veux gagner le gros lot...", german=" Ich möchte so gerne abräumen...", italian=" Voglio fare una grossa vincita...", spanish=" Quiero ganar un buen premio."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [13, 2] || scn($SCENARIO_MAIN) >= [13
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_nyorotono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english=" An expedition! ♪[K] I envy you! ♪", french="Une expédition! ♪[K] Comme je\nvous envie! ♪", german="Eine Expedition! ♪[K] Ich beneide\neuch! ♪", italian="Una spedizione! ♪[K]\nVi invidio! ♪", spanish="¡Una expedición! ♪[K]\n¡Qué envidia! ♪"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_nyorotono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english="I wonder if there's something\nspecial if you recycle a lot...", french="Je me demande si un truc\nspécial arrive si on échange beaucoup d'objets.", german="Ich frage mich, ob was Tolles\npassiert, wenn du besonders viel\nwiederverwertest...", italian="Chissà se succede qualcosa di\nspeciale quando ricicli tanti strumenti...", spanish="Me pregunto si te dan algo\npor reciclar mucho..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 3] || scn($SCENARIO_MAIN) >= [8, 
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_nyorotono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english=" Ha ha ha!", french=" Ha ha ha!", german=" Hahaha!", italian=" Ah ah ah!", spanish=" ¡Ja, ja, ja!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 1] || scn($SCENARIO_MAIN) >= [6, 
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_nyorotono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english=" I wish I could go to a pond.", french="Si seulement je pouvais me\ntrouver une petite mare sympa...", german="Ich wünschte, ich könnte an\neinen Teich gehen.", italian="Vorrei poter andare a un\nlaghetto.", spanish=" Desearía poder ir a un estanque."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 5] || scn($SCENARIO_MAIN) >= [4, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_nyorotono, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_nyorotono) end)
  SkySceneKit.say({english=" Worrying isn't for us!", french="Dans la vie, faut pas s'en\nfaire! T'inquiète pas, sois heureux, voilà\nnotre devise, pas vrai, les copains?", german=" Wozu sich Sorgen machen?", italian=" Preoccuparsi non fa per noi!", spanish="¡Preocuparse no es cosa\nnuestra!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 2] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
