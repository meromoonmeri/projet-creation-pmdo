-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S14P01A/s30a0303.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_SPINDAS_CAFE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_S14P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- @label_2 [étiquette de flux ExplorerScript]
  -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
  GAME:WaitFrames(30)
  -- supervision_Acting(1) [neutre/état moteur]
  -- GAP: se_Play(11026) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_S14P01A1_399) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(15)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker("Spinda", true, "spinda", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_PATCHIIRU) voix hors champ (espèce ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Right now at the Recycle Shop,\nyou trade several items in exchange for one of\nthe shop's items.", french="A l'heure actuelle, à la Bourse\nd'Echange, vous échangez plusieurs objets\ncontre un autre du magasin.", german="Zurzeit tauscht ihr im\nWiederverwertungsladen einige eurer\nItems gegen eines der Items des Ladens.", italian="Finora al Centro Riciclo\nsi consegnavano vari strumenti per\nottenerne uno del negozio.", spanish="Ahora, en el Reciclaje Explorador\nse intercambian varios objetos por uno de los\nde la tienda."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Thanks to everyone's continued\nrecycling efforts, we have gathered a lot of\nitems here at the shop.", french="Grâce à votre soutien pour\nnotre projet d'échanges, nous avons\nun énorme stock d'objets!", german="Da der Wiederverwertungsladen\nvon vielen genutzt wird, konnten wir eine\nMenge Items hier im Laden sammeln.", italian="Grazie ai vostri continui sforzi\nnel riciclare, il negozio ha raccolto\nmolti strumenti.", spanish="Gracias al esfuerzo de todos,\nhemos reunido muchísimos objetos\nen la tienda."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The service will continue to\noperate in the same manner...", french="Le service continuera d'opérer\nde la même manière.", german="Dieser Service wird wie\ngewohnt weiterlaufen...", italian="Il servizio continuerà\na funzionare nello stesso modo...", spanish="El servicio continuará\nfuncionando del mismo modo..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="And now with Project P\nestablished...", french="A présent, avec l'instauration\ndu Projet P...", german="Und jetzt, wo wir\nProjekt P starten...", italian="E ora che abbiamo istituito\nil Progetto P...", spanish=" Y ahora, con el nuevo Proyecto P..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(2) [neutre/état moteur]
  -- GAP: se_Play(11027) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(45)
  -- supervision_Acting(3) [neutre/état moteur]
  -- GAP: se_Play(11026) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_S14P01A2_400) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(15)
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker("Spinda", true, "spinda", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_PATCHIIRU) voix hors champ (espèce ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="You might be wondering how\nProject P fits into all this...", french="... vous vous demandez\npeut-être quel est le rapport...", german="Da fragt ihr euch sicher, wie\ndas Projekt P dort hineinpasst.", italian="Vi starete chiedendo cosa c'entra\nil Progetto P in tutto questo...", spanish="Seguramente os preguntéis cómo\nencaja el Proyecto P en todo esto..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="We'll use the accumulated items\nto explore unexplored areas!", french="Nous allons utiliser les objets\naccumulés pour explorer\ndes territoires inexplorés!", german="Ganz einfach: Wir nutzen die\ngesammelten Items, um unerforschte Gebiete\nzu erkunden!", italian="Utilizzeremo gli strumenti\naccumulati per esplorare luoghi sconosciuti!", spanish="Pues bien, ¡usaremos los objetos\nacumulados para explorar nuevos lugares!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="There are still so many places\naround the world that are waiting to be\nfound and explored.", french="Il y a encore tant d'endroits\nde par le monde qui attendent d'être\ndécouverts...", german="Es gibt noch so viele Gebiete auf\ndieser Welt, die im Verborgenen liegen und\nbisher nicht erkundet wurden.", italian="Nel mondo ci sono ancora così\ntanti posti che aspettano solo di essere\nscoperti ed esplorati.", spanish="Sigue habiendo muchos lugares\nen el mundo esperando ser hallados\ny explorados."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="So many secret treasures\nand challenging puzzles waiting to\nbe discovered...", french="Tant de trésors secrets à\ntrouver et tant d'énigmes à résoudre...", german="So viele geheime Schätze und\nherausfordernde Rätsel, die ihrer\nEntdeckung harren...", italian="Così tanti tesori nascosti\ned enigmi complicati che attendono\ndi essere riportati alla luce...", spanish="Hay tantos tesoros ocultos y\nmisterios desafiantes esperando\nser encontrados..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="So let's go out and find them!\nThat's what Project P is about!", french="Alors en avant, mes amis!\nPartons à leur recherche!\nVoilà l'essence même du Projet P!", german="Also lasst uns hinausziehen\nund sie ausfindig machen! Das ist der Sinn\nvon Projekt P!", italian="Quindi forza, mettiamoci\nalla ricerca! Ecco qual è lo scopo\ndel Progetto P!", spanish="¡Así que eso es lo que haremos!\n¡Eso es el Proyecto P!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Ah, the pursuit of knowledge...", french=" Ah, la soif de connaissance...", german=" Ah, das Streben nach Wissen...", italian=" Ah, la ricerca della conoscenza...", spanish=" Ah, la sed de conocimientos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" And continuing exploration...", french=" ... l'exploration perpétuelle...", german="Und nach andauernder\nErkundung...", italian="... e l'inesauribile desiderio\ndi esplorazione.", spanish=" Y de nuevas exploraciones..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(4) [neutre/état moteur]
  -- GAP: se_Play(11027) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  -- supervision_Acting(5) [neutre/état moteur]
  -- GAP: se_Play(11028) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_S14P01A3_401) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(15)
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker("Spinda", true, "spinda", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_PATCHIIRU) voix hors champ (espèce ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="We'll find dazzling treasures\nand new exploration areas! (Probably...)", french="Nous découvrirons de nouveaux\ntrésors étincelants et de nouvelles régions\ninexplorées! (Je l'espère...)", german="Wir werden schillernde Schätze\nund neue Erkundungsgebiete finden!\n(Vielleicht...)", italian="Scopriremo tesori sfavillanti\ne nuovi luoghi da visitare! (Forse...)", spanish="¡Encontraremos tesoros\ndeslumbrantes y nuevas zonas por explorar!\n(Se supone...)"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="And if you bring your\ndiscoveries back to the café...", french="Et en ramenant vos découvertes\nau café...", german="Und wenn ihr eure Entdeckungen\nmit zum Café bringt, wird sich das für euch\nlohnen.", italian="E se porterete le vostre\nscoperte qui al caffè...", spanish="Y, si traéis vuestros\nhallazgos a la cafetería..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(6) [neutre/état moteur]
  -- GAP: se_Play(11027) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(3) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker("Spinda", true, "spinda", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_PATCHIIRU) voix hors champ (espèce ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="You'll get a special deal at the\nRecycle Shop!", french="... vous pourrez profiter\nd'avantages spéciaux à la Bourse d'Echange!", german="Und zwar dadurch, dass sich\neure Konditionen im Wiederverwertungsladen\nverbessern!", italian="... otterrete qualcosa di speciale\nal Centro Riciclo!", spanish="¡Tendréis una oferta especial en\nel Reciclaje Explorador!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="This should keep items\ncirculating through the Recycle Shop.", french="De cette manière, les objets\ncontinueront de circuler à la Bourse d'Echange.", german="Auf diese Art sollten wir es\nschaffen, die Menge an frischen Items im\nWiederverwertungsladen hoch zu halten.", italian="In questo modo potremo\ncontinuare a riciclare gli strumenti.", spanish="Así los objetos del Reciclaje\nExplorador seguirán en circulación."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="The items at the Recycle Shop\nwill become more and more amazing!", french="Les objets proposés à la Bourse\nd'Echange deviendront de plus en plus fabuleux!", german="Die Items, die wir im\nWiederverwertungsladen anbieten, werden\nzunehmend toller!", italian="Gli strumenti del Centro Riciclo\ndiventeranno sempre più incredibili!", spanish="¡Los objetos del Reciclaje\nExplorador serán cada vez más sensacionales!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="What do you think?\nDo you understand?", french="Qu'en dites-vous?\nComprenez-vous toute la portée de ce projet?", german="Was haltet ihr davon?\nVersteht ihr, was ich meine?", italian="Che ne pensate?\nAvete capito?", spanish="¿Qué os parece?\n¿Entendéis el concepto?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- break_loop [contrôle de boucle forever NDS: une itération compilée]
  else -- default/annulation
  pcall(function() UI:SetSpeaker("Spinda", true, "spinda", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_PATCHIIRU) voix hors champ (espèce ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="OK, I'll explain again from the\nbeginning.", french="Ah, très bien, dans ce cas, je\nvais reprendre depuis le début...", german="Okay, ich werde es noch einmal\nvon Anfang an erklären.", italian=" Ok, ve lo spiego un'altra volta.", spanish="Bueno, pues lo vuelvo a explicar\ndesde el principio."})
  -- message_Close
  GAME:FadeOut(false, 30)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(6) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  GAME:FadeIn(30)
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  end
  end
  -- @label_0 [étiquette de flux ExplorerScript]
  -- message_Close
  GAME:FadeOut(false, 30)
end
