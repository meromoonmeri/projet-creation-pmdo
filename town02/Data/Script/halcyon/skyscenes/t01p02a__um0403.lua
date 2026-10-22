-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/um0403.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- SetAnimation(2) [anim idle native]
  local npc_npc_manyuura = SkySceneKit.spawn_npc("weavile", 312, 288, Direction.Up, "NPC_MANYUURA")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_aabokku = SkySceneKit.spawn_npc("arbok", 288, 256, Direction.DownRight, "NPC_AABOKKU")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_dorapion = SkySceneKit.spawn_npc("drapion", 336, 256, Direction.DownLeft, "NPC_DORAPION")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_manyuura, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="You're making our Team [CS:X]AWD[CR]\nlook bad!", french="A cause de vos exploits, vous\njetez le discrédit sur notre Equipe [CS:X]DDA[CR]!", german="Ihr lasst unser Team [CS:X]SPA[CR]\nschlecht aussehen!", italian="State mettendo in cattiva luce il\nTeam [CS:X]AWD[CR]!", spanish="¡El [CS:X]Equipo WAD[CR] no está a\nla altura de vuestro equipo! ¡Qué palo!"})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" The glory is ours next time!", french="La prochaine fois, à nous la\ngloire!", german="Nächstes Mal werden wir\ntriumphieren!", italian="La prossima volta saremo noi a\nprimeggiare!", spanish="¡Pero os superaremos la\npróxima vez!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 56] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_manyuura, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="Well if it isn't you two.[K]\nIt's been a long time.", french="C'est vous.[K] Ça faisait\nlongtemps.", german="Wenn das mal nicht ihr zwei\nseid. [K]Ist schon eine Weile her.", italian="Ma siete proprio voi due![K]\nNe è passato di tempo!", spanish="Mira a quién tenemos aquí.[K]\nHa pasado mucho tiempo."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 4] || scn($SCENARIO_MAIN) >= [29
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_manyuura, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="Then we failed to find clues\nhere too...", french="Ici aussi, nous avons donc\néchoué dans notre quête d'indices...", german="Dann haben wir es auch hier\nnicht geschafft, Hinweise zu finden.", italian="Non abbiamo trovato indizi\nneanche qui...", spanish="Entonces tampoco hemos\nencontrado ninguna pista aquí..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [10, 2] || scn($SCENARIO_MAIN) >= [10
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_manyuura, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="Hey, you two![K] Are you from\naround here?", french="Hé, vous deux![K]\nVous êtes du coin?", german="Hey, ihr zwei![K] Kommt ihr aus\ndieser Gegend?", italian="Ehi, voi due![K] Siete di queste\nparti?", spanish=" ¡Eh, pareja![K] ¿Sois de por aquí?"})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" Then let me ask you...", french=" Alors dites-moi...", german=" Dann verratet mir...", italian=" Posso chiedervi...", spanish="Entonces, dejadme que os\npregunte una cosa..."})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="Somewhere in this area...[K]\nthere should be a place called [CS:P]Zero Isle[CR]...", french="Quelque part par ici...[K]\nil devrait y avoir un endroit qu'on appelle\nl'[CS:P]Ile Zéro[CR]...", german="Irgendwo in dieser Gegend[K] soll\nes einen Ort namens [CS:P]Null-Insel[CR] geben.", italian="Qui intorno da qualche parte...[K]\nCi dovrebbe essere un posto chiamato\n[CS:P]Isola Zero[CR]...", spanish="En algún lugar de esta zona...[K]\nhay un sitio llamado la [CS:P]Isla Cero[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english=" Do you know of it?", french="En avez-vous déjà entendu\nparler?", german=" Kennt ihr ihn?", italian=" La conoscete?", spanish=" ¿Lo conocéis?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:P]Zero Isle[CR]?", french=" L'[CS:P]Ile Zéro[CR]?", german=" Die [CS:P]Null-Insel[CR]?", italian=" L'[CS:P]Isola Zero[CR]?", spanish=" ¿La [CS:P]Isla Cero[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:P]Zero Isle[CR]?", french=" L'[CS:P]Ile Zéro[CR]?", german=" Die [CS:P]Null-Insel[CR]?", italian=" L'[CS:P]Isola Zero[CR]?", spanish=" ¿La [CS:P]Isla Cero[CR]?"})
  else
  SkySceneKit.say({english=" [CS:P]Zero Isle[CR]?", french=" L'[CS:P]Ile Zéro[CR]?", german=" Die [CS:P]Null-Insel[CR]?", italian=" L'[CS:P]Isola Zero[CR]?", spanish=" ¿La [CS:P]Isla Cero[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" No. Should I?", french="Non, jamais entendu parler.\nPourquoi?", german="Nein. Sollte ich diesen Ort\nkennen?", italian=" No. Dovrei conoscerla?", spanish=" No. ¿Debería?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" No. Should I?", french="Non, jamais entendu parler.\nPourquoi?", german="Nein. Sollte ich diesen Ort\nkennen?", italian=" No. Dovrei conoscerla?", spanish=" No. ¿Debería?"})
  else
  SkySceneKit.say({english=" No. Should I?", french="Non, jamais entendu parler.\nPourquoi?", german="Nein. Sollte ich diesen Ort\nkennen?", italian=" No. Dovrei conoscerla?", spanish=" No. ¿Debería?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manyuura) end)
  SkySceneKit.say({english="Hmmm...[K] So that's the case?[K]\nFine. Be that way.", french="Hmmm...[K] Dans ce cas...[K] Bien.\nD'accord.", german="Hmm...[K] So ist das also, wie?[K]\nGut, dann eben nicht.", italian="Mmm...[K] Se le cose stanno\ncosì...", spanish="Hum...[K] ¿Seguro?[K]\nEn fin, si tú lo dices..."})
  -- message_Close
  GROUND:EntTurn(npc_npc_manyuura, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [4, 7] || scn($SCENARIO_MAIN) >= [4, 
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
