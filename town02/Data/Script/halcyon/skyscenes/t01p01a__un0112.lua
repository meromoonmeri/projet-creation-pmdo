-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/un0112.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) or (SkyProg.cmp_side(40, 3) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7] || scn($SCENARIO_SIDE) >= [40
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_okorizaru = SkySceneKit.spawn_npc("primeape", 296, 256, Direction.UpLeft, "NPC_OKORIZARU")
  pcall(function() UI:SetSpeaker(npc_npc_okorizaru) end)
  SkySceneKit.say({english="I heard that there's a Hot Spring\naround here somewhere...", french="J'ai entendu dire qu'il y avait\nune Source Chaude dans le coin...", german="Ich habe gehört, hier soll es\nirgendwo eine Heiße Quelle geben...", italian="Ho sentito che da qualche parte\nqui intorno c'è una Sorgente Termale...", spanish="He oído que en algún sitio de\npor aquí hay una Terma..."})
  pcall(function() UI:SetSpeaker(npc_npc_okorizaru) end)
  SkySceneKit.say({english=" Do you know where it is?", french=" Tu sais où elle se trouve?", german=" Weißt du, wo sie ist?", italian=" Tu sai dove si trova?", spanish=" ¿No sabrás dónde está?"})
  pcall(function() UI:SetSpeaker(npc_npc_okorizaru) end)
  SkySceneKit.say({english="I've always got my arms up, so\nmy shoulders get so stiff...", french="J'ai toujours les bras en l'air,\ndu coup j'ai mal aux épaules...", german="Meine Arme zeigen immer nach\noben, daher habe ich häufig steife Schultern...", italian="Tengo sempre le braccia alzate\ne così le mie spalle sono tutte indolenzite.", spanish="Como siempre tengo los brazos\nen alto, los hombros se me acalambran..."})
  pcall(function() UI:SetSpeaker(npc_npc_okorizaru) end)
  SkySceneKit.say({english="So...I'd like to get well by\nsoaking in the Hot Spring.", french="Alors... j'aimerais prendre\nun bon bain dans la Source Chaude.", german="Deswegen würde ich mich gerne\nein wenig im Wasser der Heißen Quelle\nentspannen.", italian="Quindi... mi piacerebbe fare un\nbel bagno rilassante nella Sorgente Termale.", spanish="Por eso... me gustaría\nrecuperarme con un bañito en la Terma."})
  pcall(function() UI:SetSpeaker(npc_npc_okorizaru) end)
  SkySceneKit.say({english="I'm thinking, once I find the Hot\nSpring, I'll ask my sparring partner [CS:N]Mankey[CR] to\njoin me.", french="Quand j'aurai trouvé la Source\nChaude, je demanderai à [CS:N]Férosinge[CR], mon\npartenaire d'entraînement, de me rejoindre.", german="Wenn ich die Heiße Quelle\ngefunden habe, werde ich meinen Trainings-\npartner [CS:N]Menki[CR] fragen, ob er mit mir kommt.", italian="Quando troverò la Sorgente\nTermale chiederò al mio compagno di squadra\n[CS:N]Mankey[CR] di venire con me.", spanish="Creo que, en cuanto encuentre la\nTerma, le diré a mi compañero de fatigas\n[CS:N]Mankey[CR] que se venga conmigo."})
  -- message_Close
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp_side(40, 2) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 2]
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
