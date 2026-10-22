-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D53P21A/enter09.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 113 or __sw == 114 or __sw == 117 or __sw == 118 or __sw == 119 or __sw == 50 or __sw == 121 or __sw == 122 or __sw == 123 or __sw == 125 then
  -- @label_12 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 129 then
  if (SkyProg.cmp_side(48, 9) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [48, 9]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_serebii = SkySceneKit.spawn_npc("celebi", 208, 288, Direction.Up, "NPC_SEREBII")
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="I can feel the world is slowly\nchanging.", french="Je sens que le monde est\nen train de changer tout doucement.", german="Ich kann fühlen, wie sich die\nWelt langsam verändert.", italian="Sento che il mondo\nsta lentamente cambiando.", spanish="Siento cómo cambia el mundo\nlentamente."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Let's hurry, [CS:Y]Grovyle[CR]!", french=" Dépêchons-nous, [CS:Y]Massko[CR]!", german=" Beeilung, [CS:Y]Reptain[CR]!", italian=" Muoviamoci, [CS:Y]Grovyle[CR]!", spanish=" ¡Deprisa, [CS:Y]Grovyle[CR]!"})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(48, 6) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [48, 6]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="We'll definitely catch up with\n[CS:N]Dialga[CR] this time, [CS:Y]Grovyle[CR]!", french="Nous allons rattraper [CS:N]Dialga[CR]\ncette fois-ci, c'est sûr, [CS:Y]Massko[CR]!", german="Wir werden [CS:N]Dialga[CR] dieses Mal\nauf jeden Fall erwischen, [CS:Y]Reptain[CR]!", italian="[CS:Y]Grovyle[CR], questa volta\nraggiungeremo sicuramente [CS:N]Dialga[CR]!", spanish="Esta vez alcanzaremos a\n[CS:N]Dialga[CR], [CS:Y]Grovyle[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" To protect the future!", french=" Pour protéger le futur!", german=" Um die Zukunft zu retten!", italian=" Per proteggere il futuro!", spanish=" ¡Para proteger el futuro!"})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:N]Celebi[CR]...[K]I never thought\nyou would be caught like this.", french="[CS:N]Celebi[CR]...[K] Je ne pensais pas que\ntu te ferais attraper comme ça.", german="[CS:N]Celebi[CR]...[K] Dass du einmal\ngefangen genommen würdest...", italian="[CS:N]Celebi[CR]...[K] Non avrei mai creduto\nche ti saresti fatta catturare!", spanish="[CS:N]Celebi[CR]...[K] Nunca pensé que\nte atraparían así."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="Oh, I didn't imagine that I'd get\ncaught either.", french="Oh, je ne pensais pas non plus\nme faire attraper.", german="Oh, ich hätte auch nicht gedacht,\ndass man mich fangen würde.", italian="Oh, nemmeno io l'avrei mai\nimmaginato.", spanish="Ya, yo tampoco podía imaginarme\nque iban a atraparme."})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="I really didn't think [CS:N]Dialga[CR]\nhimself would come after me...", french="J'étais loin d'imaginer que [CS:N]Dialga[CR]\nen personne viendrait me chercher...", german="Ich hatte wirklich nicht geahnt,\ndass mir [CS:N]Dialga[CR] persönlich nachjagen würde...", italian="Non pensavo che [CS:N]Dialga[CR]\nin persona sarebbe venuto a cercarmi...", spanish="Nunca se me ocurrió pensar que\nel mismo [CS:N]Dialga[CR] vendría a por mí..."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="By the way, I didn't think you'd\nbe coming back to this world, [CS:Y]Grovyle[CR].", french="A propos, je ne pensais pas que\ntu reviendrais dans ce monde, [CS:Y]Massko[CR].", german="Übrigens habe ich nicht\nerwartet, dass du in diese Welt zurückkehren\nwürdest, [CS:Y]Reptain[CR].", italian="A proposito, non credevo che\nsaresti tornato in questo mondo, [CS:Y]Grovyle[CR].", spanish="Por cierto, tampoco creía que\nfueras a volver a este mundo, [CS:Y]Grovyle[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="I was worried that you had\nfailed again, you know? Hee-hee-hee!", french="Je craignais que tu n'aies\nencore échoué, tu sais? Hi hi hi!", german="Ich war besorgt, dass du wieder\ngescheitert seist, weißt du? Hihihi!", italian="Sai, temevo che avessi fallito\ndi nuovo... Hi hi hi!", spanish="Me preocupaba que hubieras\nvuelto a fracasar, ¿sabes? ¡Ji, ji, ji!"})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" (But...[K]I got to see you again!)", french="(Mais... [K]j'ai la chance\nde te revoir!)", german=" (Aber...[K] Hier bist du ja!)", italian=" (Ma...[K] è bello rivederti!)", spanish=" (Pero...[K] ¡nos volvemos a ver!)"})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" (I'm so happy!)", french=" (Je suis si heureuse!)", german=" (Ich bin so froh!)", italian=" (Sono così felice!)", spanish=" (¡Me hace tan feliz!)"})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif __sw == 131 then
  if (SkyProg.cmp_side(48, 9) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [48, 9]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" I'm fine, [CS:Y]Grovyle[CR].", french=" Je vais bien, [CS:Y]Massko[CR].", german=" Mir geht es gut, [CS:Y]Reptain[CR].", italian=" Sto bene, [CS:Y]Grovyle[CR].", spanish=" Estoy bien, [CS:Y]Grovyle[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="I've said this before.[K]\nI'm prepared for this.", french="Je l'ai déjà dit.[K]\nJe suis préparée pour affronter ça.", german="Wie ich gesagt habe.[K]\nIch bin bereit.", italian="Te l'ho già detto.[K]\nSono pronta a tutto questo.", spanish="Ya lo he dicho antes.[K]\nEstoy preparada para esto."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="Let's hurry![K]\nTo the top!", french="Dépêchons-nous![K]\nMontons jusqu'au sommet!!", german="Beeilen wir uns![K]\nSchnell nach oben!", italian="Muoviamoci![K]\nRaggiungiamo la vetta!", spanish="¡Deprisa![K]\n¡A la cima!"})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(48, 8) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [48, 8]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="At the pinnacle, we'll find the\nPassage of Time.", french="Au pinacle, nous trouverons\nle Couloir du Temps.", german="In der Kuppel werden wir den\nZeittunnel finden.", italian="Sulla vetta troveremo\nil Portale del Tempo.", spanish="En la cima encontraremos el Pasaje\ndel Tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="As long as [CS:N]Dialga[CR] hasn't\ndestroyed it...", french=" Si [CS:N]Dialga[CR] ne l'a pas détruit...", german="Solange [CS:N]Dialga[CR] ihn noch nicht\nzerstört hat...", italian="A meno che [CS:N]Dialga[CR]\nnon l'abbia distrutto...", spanish="Siempre y cuando [CS:N]Dialga[CR]\nno lo haya destruido..."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="At the pinnacle, we'll find the\nPassage of Time.", french="Au pinacle, nous trouverons\nle Couloir du Temps.", german="In der Kuppel werden wir den\nZeittunnel finden.", italian="Sulla vetta troveremo\nil Portale del Tempo.", spanish="En la cima encontraremos el Pasaje\ndel Tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="As long as [CS:N]Dialga[CR] hasn't\ndestroyed it...", french=" Si [CS:N]Dialga[CR] ne l'a pas détruit...", german="Solange [CS:N]Dialga[CR] ihn noch nicht\nzerstört hat...", italian="A meno che [CS:N]Dialga[CR]\nnon l'abbia distrutto...", spanish="Siempre y cuando [CS:N]Dialga[CR]\nno lo haya destruido..."})
  -- message_Close
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
