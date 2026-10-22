-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P04A/um0606.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_herakurosu = SkySceneKit.spawn_npc("heracross", 224, 264, Direction.Right, "NPC_HERAKUROSU")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_herakurosu, 4) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="Whooooa!\nI'm ready to explore the whoooole world\nwith [CS:N]Zigzagoon[CR]!", french="Youhou!\nJe me sens prêt à explorer le monnnnde entier\navec [CS:N]Zigzaton[CR]!", german="Wooow!\nIch bin bereit, zusammen mit [CS:N]Zigzachs[CR]\ndie gaaaanze Welt zu erkunden!", italian="Uaaah!\nOra che [CS:N]Zigzagoon[CR] è con me, sono pronto\nad esplorare il mondo inteeero!", spanish="¡Bieeeen!\n¡Ya puedo explorar el mundo entero\ncon [CS:N]Zigzagoon[CR]!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- @label_131 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_herakurosu, 4) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="Whooooa!\nFinally back!!", french="Youhou!\nDe retour, enfin!!", german="Woooow!\nEndlich zurück!!!", italian="Uoooh!\nFinalmente a casa!!!", spanish="¡Bieeen!\n¡Al fin de vuelta!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 71] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="Whoa!\nWe've finally reached the top!", french="Youhou!\nOn a réussi, voilà le sommet!", german="Wow!\nEndlich sind wir oben!", italian="Uaaah!\nFinalmente abbiamo raggiunto la cima!", spanish="¡Córcholis!\nPor fin hemos alcanzado la cima."})
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="I met a friend, [CS:N]Zigzagoon[CR], at\nthe 7th Station Clearing! This is so greeeeat!!", french="J'ai rencontré un ami, [CS:N]Zigzaton[CR],\nà la trouée du 7[F:E] Relais! C'est trooooooop cool!", german="Auf der 7. Zwischenlagerlichtung\nhabe ich [CS:N]Zigzachs[CR], einen Freund von mir,\ngetroffen! Das ist so suuuper!!!", italian="Ho incontrato un amico,\n[CS:N]Zigzagoon[CR], al Bivacco 7!\nÈ troppo beeello!!!", spanish="Me he encontrado a [CS:N]Zigzagoon[CR] en\nla Base del Séptimo Puerto, ¡cómo mola!"})
  -- message_KeyWait
  GROUND:EntTurn(npc_npc_herakurosu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="Whooooa!\nYAHOOOO!!", french="Youhou!\nYOUHOUUUU!!", german="Woooow!\nJUCHHUUU!!!", italian="Uooooooh!\nYUHUUU!!!", spanish="¡Guaaaau!\n¡Yujuuuu!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, nil, 0) end) -- EFFECT_NONE
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="Whoa!\nWe caught up to [CS:N]Mr. Mime[CR]'s team!", french="Youhou!\nOn a rattrapé l'équipe de [CS:N]M. Mime[CR]!", german="Wow!\nWir haben das Team von [CS:N]Pantimos[CR] eingeholt!", italian="Sììì!\nAbbiamo raggiunto la squadra di [CS:N]Mr. Mime[CR]!", spanish="¡Anda!\nHemos alcanzado al equipo de [CS:N]Mr. Mime[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english=" This makes me haaaappy!!", french=" Je suis trooooop content!!", german=" Das macht mich froooh!!!", italian=" Sono così feliiice!!!", spanish=" ¡Qué felicidad tan grande!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 28] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1)
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="Whoa! Still the 3rd Station\nCleeeearing!!", french="On est qu'à la trouée du\n3[F:E] Relais!", german="Wow! Erst die\n3. Zwischenlagerliiichtung!!!", italian="Uaaah! Siamo ancora al\nBivaaacco 3!!!", spanish="¡Caramba! Aún en la Base del\nTercer Puerto."})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="I heard there's a gondola to\nthe 6th Station Clearing...", french="Il paraît qu'une navette permet\nd'atteindre la trouée du 6[F:E] Relais.", german="Ich habe von einer Seilbahn zur\n6. Zwischenlagerlichtung gehört...", italian="Ho sentito che c'è un modo per\narrivare direttamente al Bivacco 6...", spanish="He oído que hay una góndola en\nla Base del Sexto Puerto..."})
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="But! I want to climb\nthere myself!!", french="Mais je préfère grimper\nlà-haut tout seul!", german="Aber da möchte ich schon\nauf eigene Faust hinauf!!!", italian="Ma a me non interessa! Voglio\nfarcela con le mie sole forze!!!", spanish="¡Pero tengo que subir para verlo\ncon estos ojitos!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="Whoa!\nWhat willpower!!", french="Youhou!\nJ'ai une volonté à toute épreuve!!", german="Wow!\nWas für eine Willensstärke!!!", italian="Wow! Che forza di volontà\nincredibile!!!", spanish="¡Guau!\nEso sí que es tener fuerza de voluntad."})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, nil, 0) end) -- EFFECT_NONE
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 22] || scn($SCENARIO_MAIN) >= [2
  if ((SV.SkyScenarioBitFlags or {})[91] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[91]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="I will never forget yoooou!\nThank yoooou!!", french="Je ne t'oublierai jamais!\nMerci pour tout!!!", german="Ich werde iiiiimmer an euch\ndenken! Danke schööön!!!", italian="Non vi dimenticherò maaai!\nGraaazie!!!", spanish="Nunca te olvidaré,\n¡muchas gracias!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_ExecuteCommon(CORO_EVENT_S32_04) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 9) >= 0) or (SkyProg.cmp(29, 8) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 11] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_herakurosu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="Whoa! What kind of Pokémon is\n[CS:K]Shaymin[CR]?!", french="Waouh! C'est quel genre de\nPokémon, [CS:K]Shaymin[CR]?!", german="Wow! Was für ein Pokémon\n[CS:K]Shaymin[CR] wohl ist?!?", italian="Uaaah! Chissà che tipo di\nPokémon è [CS:K]Shaymin[CR]!", spanish="¡Anda! ¡¿Qué clase de Pokémon\nes [CS:K]Shaymin[CR]?!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english=" So curious!", french=" Comme c'est bizarre!", german=" Ich bin so neugierig!", italian=" Che curiosità!", spanish=" ¡Qué curioso!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, nil, 0) end) -- EFFECT_NONE
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 6] || scn($SCENARIO_MAIN) >= [29
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [24, 1] || scn($SCENARIO_MAIN) >= [24
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_herakurosu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="[hero], I'm jealous of you.\nYou've got a partner.", french="[hero], je suis jaloux.\nToi, tu as un partenaire.", german="Ich bin ein wenig neidisch auf\ndich, [hero]. Du hast einen Partner.", italian="Che invidia, [hero].\nHai trovato un compagno.", spanish="Me das una envidia,\n[hero]... Tú tienes acompañante."})
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english=" I want a partner, too...", french="Moi aussi, je veux\nun partenaire...", german=" Ich möchte auch einen Partner...", italian=" Anch'io ne vorrei uno...", spanish=" Yo también quiero..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [23, 1] || scn($SCENARIO_MAIN) >= [22
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_herakurosu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english=" Hey! Long time no see!", french=" Hé! Ça fait un bout de temps!", german=" Hey! Lange nicht gesehen!", italian="Ehilà! Ne è passato di tempo,\neh?!", spanish=" ¡Hola! ¡Cuánto tiempo!"})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [21, 2] || scn($SCENARIO_MAIN) >= [21
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_herakurosu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="I am back from the\nlonely expedition!", french="Je reviens d'une expédition\nen solitaire!", german="Ich bin zurück von der\neinsamen Expedition!", italian="Sono tornato dalla mia\nesplorazione solitaria!", spanish="¡Ya he vuelto de\nla expedición solitaria!"})
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="It was such a dangerous\nadventure, but I feel like it let me gain so\nmuch strength!", french="C'était une aventure périlleuse,\nmais elle m'a permis de gagner en force!", german="Es war ein wirklich brenzliges\nAbenteuer, aber ich habe das gute Gefühl,\nungeheuer an Stärke gewonnen zu haben!", italian="È stata un'avventura piena di\ninsidie, ma ora mi sento molto più forte\ndi prima!", spanish="Mira que ha sido una aventura\npeligrosa, pero creo que me ha hecho\nmucho más fuerte."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [13, 2] || scn($SCENARIO_MAIN) >= [13
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_herakurosu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="Now, I decided to join the\nexpedition, too!", french="C'est décidé, je vais\nparticiper à l'expédition, moi aussi!", german="So. Ich habe mich entschlossen,\nauf die Expedition mitzukommen!", italian="Ok, ho deciso che mi unirò\nanch'io alla spedizione!", spanish="Bueno, ya me he decidido, yo\ntambién me uno a la expedición."})
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english=" But I'm all by myself...", french=" Mais tout seul...", german="Aber ich bin ganz für\nmich allein...", italian=" Ma andrò per conto mio...", spanish=" Pero no tengo con quién ir..."})
  -- message_Close
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 7]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_herakurosu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="There's an exclusive survey\nteam called Team [CS:X]Frontier[CR] within Project P.", french="Une équipe de reconnaissance\nd'élite appelée Equipe [CS:X]Eclaireurs[CR]\nparticipe au Projet P.", german="Es gibt ein exklusives\nVermessungsteam von Projekt P\nnamens Team [CS:X]Grenzland[CR].", italian="C'è una squadra di indagine\nesclusiva che fa parte del Progetto P...\nSi chiama Team [CS:X]Pioniere[CR].", spanish="En el Proyecto P hay un equipo\nde reconocimiento llamado [CS:X]Equipo Frontera[CR]."})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="Whoa! So cooool!!\nI really want to join the teeeeam!!", french="Youhou! Trooop classe!\nJe veeeeux rejoindre cette équipe!!", german="Wow! Wie cooool!!!\nIch würde soooo gerne bei ihnen mitmachen!", italian="Wow! Troppo fooorte!!!\nVoglio essere un membro di quella squaaadra!!!", spanish="¡Jo, cómo mola!\n¡Yo también quiero unirme a ese equipo!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, nil, 0) end) -- EFFECT_NONE
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 6] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_herakurosu, 4) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english=" Whoa! Hoooopes and dreams!!", french="Ça alors!\nIci, vos rêves se réalisent!!", german=" Wow! Hoffen und Trääääumen!", italian=" Uaaah! Sooogni e speranze!!!", spanish=" ¡Guau! ¡De ensueño!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, nil, 0) end) -- EFFECT_NONE
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [8, 3] || scn($SCENARIO_MAIN) >= [8, 
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_herakurosu, 4) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="Wow!\nThis shop is increeedible!!", french="Youhou!\nCet endroit est excellent!!", german="Wow!\nDieser Laden ist unglaaaublich!", italian="Wow!\nQuesto posto è incrediiibile!!!", spanish="¡Caray!\n¡Qué pasada de tienda!"})
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="It's like a paradise for\nexploooorers!!", french="Un vrai petit paradis\npour les explorateurs!!", german="Geradezu ein Paradies\nfür Entdeeeecker!!!", italian="È il paradiso degli\nesploratooori!!!", spanish="¡Es como el paraíso de\nlos exploradores!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [7, 2] || scn($SCENARIO_MAIN) >= [7, 
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_131 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
