-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S01P01A/m08a0502.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetLevel(1) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(15) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetMark(184) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker("Chatot", true, "chatot", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERAPPU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="First off... This is where\n[CS:P]Fogbound Lake[CR] is said to be.", french="Tout d'abord... on dit que c'est\nlà que se situe le [CS:P]Lac des Brumes[CR].", german=" Hier soll der [CS:P]Nebelsee[CR] liegen.", italian="Innanzitutto... pare che il\n[CS:P]Lago Foschia[CR] si trovi qui.", spanish="Antes de nada... Aquí es donde\nse dice que está el [CS:P]Lago Velado[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- worldmap_SetArrow(15) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  pcall(function() UI:SetSpeaker("Chatot", true, "chatot", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERAPPU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="As an uncharted territory, the\narea is shown under a cloud cover.", french="Comme c'est un territoire\ninexploré, la région est recouverte de\nnuages.", german="Als unerforschtes Gebiet ist die\nGegend unter einer Wolkendecke verborgen.", italian="Dal momento che si tratta di un\nterritorio inesplorato, quest'area è coperta\nda nuvole.", spanish="Al ser un territorio inexplorado,\nesta zona aparece cubierta por nubes."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- worldmap_DeleteArrow [flèche carte moteur NDS]
  -- worldmap_MoveCamera(184) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  pcall(function() UI:SetSpeaker("Chatot", true, "chatot", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERAPPU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Our guild is here.", french=" Notre Guilde se trouve ici.", german=" Unsere Gilde befindet sich hier.", italian=" La nostra Gilda si trova qui.", spanish=" Nuestro [CS:N]Pokégremio[CR] está aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- worldmap_SetArrow(184) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker("Chatot", true, "chatot", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERAPPU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="As you can see, the lake is at a\nconsiderable distance from the guild.", french="Comme vous le voyez, le lac est\nà une distance considérable de la Guilde.", german="Wie ihr seht, liegt der See ein\ngutes Stück von der Gilde entfernt.", italian="Come potete vedere, il lago è\nmolto distante dalla Gilda.", spanish="Como podéis ver, el lago está\na una distancia considerable del [CS:N]Pokégremio[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- worldmap_DeleteArrow [flèche carte moteur NDS]
  -- worldmap_MoveCamera(13) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetArrow(13) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  pcall(function() UI:SetSpeaker("Chatot", true, "chatot", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERAPPU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Therefore, we will encamp\nat the foot of the highlands here. That will\nserve as our base camp.", french="Par conséquent, nous ferons\nune halte au pied de ces plateaux. Nous\ny établirons notre camp de base.", german="Darum werden wir am Fuß des\nHochlands hier unser Lager aufschlagen.\nDas wird unser Basislager sein.", italian="Per questo motivo, ci\naccamperemo ai piedi di questo altipiano.\nQuesto sarà il nostro Campo Base.", spanish="Por tanto, tendremos que\nacampar al pie de estas montañas.\nEse será nuestro campamento base."})
  pcall(function() UI:SetSpeaker("Chatot", true, "chatot", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERAPPU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="If we were to travel all at once\nin a single group to the base camp, our\nmobility would be restricted.", french="Mais si nous faisons le voyage\ngroupés jusqu'au camp de base, notre\nmobilité sera restreinte.", german="Würden alle auf einmal in nur\neiner Gruppe zum Basislager reisen, wären\nwir in unserer Mobilität eingeschränkt.", italian="Se viaggiassimo in un unico\ngruppo verso il Campo Base, la nostra\nmobilità ne risentirebbe.", spanish="Si viajáramos todos juntos\nal campamento base, perderíamos\nmucha movilidad."})
  pcall(function() UI:SetSpeaker("Chatot", true, "chatot", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_PERAPPU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="The strategy is to split up into\nseveral groups to travel to the base camp. ♪", french="La stratégie consistera donc\nà se diviser en petits groupes pour voyager\njusqu'au camp de base. ♪", german="Daher planen wir, in Gruppen\naufgeteilt zum Basislager zu reisen. ♪", italian="Quindi per raggiungere il Campo\nBase ci divideremo in vari gruppi. ♪", spanish="La estrategia consiste en\ndividirse en varios grupos para ir\nal campamento base. ♪"})
  -- message_Close
  -- GAP: se_Play(6667) — id SE NDS sans portage PMDO identifié
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
end
