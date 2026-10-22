-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S01P01A/m13a0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetLevel(2) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(21) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(30)
  -- worldmap_SetMark(21) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetArrow(21) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  pcall(function() UI:SetSpeaker("Chatot", true, "chatot", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERAPPU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" See? This area.", french=" Vous voyez? C'est là.", german=" Seht ihr? Dieses Gebiet.", italian=" Vedete? Si trova qui.", spanish=" ¿Veis esta área?"})
  pcall(function() UI:SetSpeaker("Chatot", true, "chatot", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERAPPU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="The area on the map is obscured\nby clouds...", french="La zone est dissimulée\npar des nuages...", german="Das Gebiet ist auf der Karte von\nWolken verdeckt...", italian="Quest'area, sulla Mappa delle\nmeraviglie, è coperta dalle nuvole perché è\nancora sconosciuta.", spanish="Las nubes cubren esta parte del\nmapa..."})
  pcall(function() UI:SetSpeaker("Chatot", true, "chatot", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERAPPU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="But the dry terrain starts in this\narea here.", french="... mais la région sèche\ncommence par là.", german="Aber die trockene Zone beginnt\nin dieser Gegend hier.", italian="Il terreno desertico comincia\nqui.", spanish="Pero, en esta zona de aquí, el\nterreno empieza a ser más seco."})
  pcall(function() UI:SetSpeaker("Chatot", true, "chatot", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERAPPU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="That's why it's rumored that a\nvast desert extends from that point onward.", french="C'est pourquoi le bruit court\nqu'un vaste désert s'étend à partir de là.", german="Darum wird vermutet, dass an\ndiesem Punkt eine riesige Wüste beginnt.", italian="Questo sembrerebbe indicare la\npresenza di un deserto molto vasto.", spanish="Por eso, suponemos que a partir\nde aquí hay un gran desierto."})
  pcall(function() UI:SetSpeaker("Chatot", true, "chatot", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERAPPU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="We suspect that a Time Gear is\nhidden in the depths of the desert.", french="Nous soupçonnons la présence\nd'un Rouage du Temps dans les profondeurs\nde ce désert.", german="Wir vermuten, dass tief in der\nWüste ein Zahnrad der Zeit versteckt ist.", italian="Sospettiamo che un Ingranaggio\ndel Tempo possa trovarsi nelle profondità di\nquesto deserto.", spanish="Sospechamos que podría haber\nun Engranaje del Tiempo en lo más profundo\nde ese desierto."})
  pcall(function() UI:SetSpeaker("Chatot", true, "chatot", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERAPPU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="That is where we're sending you\nto investigate.", french="C'est pour ça qu'on vous\ny envoie.", german="Dort sollt ihr eure Erkundungen\nanstellen.", italian="Per questo vi ho assegnato\nall'esplorazione di quest'area.", spanish="Y ese es el motivo por el que os\nenviamos allí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yep! Gotcha!", french=" Oui, pigé!", german=" Okay, alles klar!", italian=" Ok! Messaggio ricevuto!", spanish=" Vale, ¡entendido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK! We understand!", french=" Oui, pigé!", german=" Okay! Verstanden!", italian=" D'accordo! Ci pensiamo noi!", spanish=" Vale, ¡entendido!"})
  else
  SkySceneKit.say({english=" OK! We understand!", french=" Oui, pigé!", german=" Okay! Verstanden!", italian=" D'accordo! Ci pensiamo noi!", spanish=" Vale, ¡entendido!"})
  end
  -- message_Close
  -- GAP: se_Play(6667) — id SE NDS sans portage PMDO identifié
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
end
