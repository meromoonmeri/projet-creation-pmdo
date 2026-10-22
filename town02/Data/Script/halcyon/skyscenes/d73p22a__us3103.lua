-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P22A/us3103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_goorikii = SkySceneKit.spawn_npc("machoke", 264, 216, Direction.UpRight, "NPC_GOORIKII")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_goorikii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_goorikii) end)
  SkySceneKit.say({english=" Until we meet again!", french=" A la revoyure!", german=" Bis zum nächsten Mal!", italian=" A presto!", spanish=" ¡Hasta la próxima!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 53] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_goorikii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_goorikii) end)
  SkySceneKit.say({english="I like to spend my days off by\nclimbing to the summit and greeting the\nmorning sun.", french="J'aime passer mes jours\nde congé à escalader la montagne jusqu'au\nsommet pour saluer le soleil levant.", german="Ich mag es, während meiner\nfreien Tage den Gipfel zu erklimmen, um die\nMorgensonne zu grüßen.", italian="Mi piace trascorrere il mio\ntempo libero scalando la montagna e\nammirare l'alba da lassù.", spanish="Me gusta pasar mi tiempo libre\nsubiendo hasta la cima para dar los buenos días\nal sol matutino."})
  pcall(function() UI:SetSpeaker(npc_npc_goorikii) end)
  SkySceneKit.say({english="It's a bit challenging, but that's\nwhy it can be so wonderful.", french="C'est un peu éprouvant, mais\nla récompense est à la hauteur du défi.", german="Es ist ein wenig fordernd, aber\ndas ist auch ein Grund dafür, warum es so\nwundervoll sein kann.", italian="È piuttosto impegnativo, ma è\nper questo che è così bello.", spanish="Es todo un reto, pero\neso lo convierte en algo maravilloso."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 39] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_goorikii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_goorikii) end)
  SkySceneKit.say({english=" That [CS:N]Shaymin[CR]...", french=" Ce [CS:N]Shaymin[CR]...", german=" Dieses [CS:N]Shaymin[CR]...", italian=" Quella [CS:N]Shaymin[CR]...", spanish=" Esa [CS:N]Shaymin[CR]..."})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_goorikii, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_goorikii) end)
  SkySceneKit.say({english="I had no idea that [CS:N]Shaymin[CR] could\nchange its Forme like that!", french="J'ignorais que [CS:N]Shaymin[CR]\npouvait changer de Forme comme ça!", german="Ich hatte keine Ahnung, dass\n[CS:N]Shaymin[CR] seine Form derart ändern kann!", italian="Non immaginavo che quella\n[CS:N]Shaymin[CR] potesse cambiare Forma in quel modo!", spanish="¡No tenía ni idea de que [CS:N]Shaymin[CR]\npudiera cambiar de forma así!"})
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_goorikii) end)
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ......", italian=" ..................", spanish=" ..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 25] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_goorikii) end)
  SkySceneKit.say({english=" Please.", french=" On compte sur toi.", german=" Wir verlassen uns auf euch.", italian=" Contiamo su di voi.", spanish=" Cuento contigo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 23] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_goorikii) end)
  SkySceneKit.say({english=" ...[K]Sorry!", french=" ...[K] Pardon!", german=" ...[K]Entschuldigung!", italian=" ...[K] Scusate!", spanish=" Esto...[K] ¡Perdón!"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_goorikii, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 19] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_goorikii) end)
  SkySceneKit.say({english="I'm [CS:N]Machoke[CR]. I'm the leader of\nTeam [CS:X]Frontier[CR], Project P's survey team.", french="Je suis [CS:N]Machopeur[CR].\nJe suis le meneur de l'Equipe [CS:X]Eclaireurs[CR],\nl'équipe de reconnaissance du Projet P.", german="Mein Name ist [CS:N]Maschok[CR]. Ich bin\nder Anführer von Team [CS:X]Grenzland[CR], dem\nVermessungsteam von Projekt P.", italian="Mi chiamo [CS:N]Machoke[CR]. Sono il\nleader del Team [CS:X]Pioniere[CR], la squadra\ndi indagine del Progetto P.", spanish="Soy [CS:N]Machoke[CR], el líder del\n[CS:X]Equipo Frontera[CR], el equipo de reconocimiento\ndel Proyecto P."})
  pcall(function() UI:SetSpeaker(npc_npc_goorikii) end)
  SkySceneKit.say({english="If you're ever in trouble,\njust let me know.", french="Si jamais tu te trouves\nen difficulté, fais-le-moi savoir.", german="Wenn ihr in Schwierigkeiten\nsteckt, lasst es mich wissen!", italian="Se doveste trovarvi nei guai,\nfatemelo sapere.", spanish="Si alguna vez te ves en apuros,\nházmelo saber."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 13] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_goorikii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_goorikii) end)
  SkySceneKit.say({english="I'm [CS:N]Machoke[CR]. I'm the leader of\nTeam [CS:X]Frontier[CR], Project P's survey team.", french="Je suis [CS:N]Machopeur[CR].\nJe suis le meneur de l'Equipe [CS:X]Eclaireurs[CR],\nl'équipe de reconnaissance du Projet P.", german="Mein Name ist [CS:N]Maschok[CR]. Ich bin\nder Anführer von Team [CS:X]Grenzland[CR], dem\nVermessungsteam von Projekt P.", italian="Mi chiamo [CS:N]Machoke[CR]. Sono il\nleader del Team [CS:X]Pioniere[CR], la squadra\ndi indagine del Progetto P.", spanish="Soy [CS:N]Machoke[CR], el líder del [CS:X]Equipo[CR]\n[CS:X]Frontera[CR], el equipo de reconocimiento\ndel Proyecto P."})
  pcall(function() UI:SetSpeaker(npc_npc_goorikii) end)
  SkySceneKit.say({english="If you're ever in trouble,\njust let me know.", french="Si jamais vous vous trouvez\nen difficulté, faites-le-moi savoir.", german="Wenn ihr in Schwierigkeiten\nsteckt, lasst es mich wissen!", italian="Se doveste trovarvi nei guai,\nfatemelo sapere.", spanish="Si alguna vez te ves en apuros,\nházmelo saber."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 8] || scn($SCENARIO_MAIN) >= [29
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
