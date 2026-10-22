-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/un0406.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(43, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [43, 2]
  end
  -- @label_2 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_yadon = SkySceneKit.spawn_npc("slowpoke", 224, 224, Direction.UpRight, "NPC_YADON")
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english="We're Team [CS:X]Slacker[CR].[K] We're the\nzero-motivation exploration team.", french="On est l'Equipe [CS:X]Flemmards[CR].[K]\nL'équipe d'exploration avec zéro motivation.", german="Wir sind Team [CS:X]Faulenzer[CR].[K] Wir\nsind das Erkundungsteam, das nicht einmal über\ndie geringste Motivation verfügt.", italian="Noi siamo il Team [CS:X]Siesta[CR].[K]\nSiamo la squadra d'esplorazione con zero\nmotivazioni.", spanish="Somos el [CS:X]Equipo Gandul[CR].[K]\nUn equipo explorador sin motivación alguna."})
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english="You seem pretty motivated and\nhardworking.", french="Tu as l'air très motivée\net travailleuse.", german="Du scheinst hochmotiviert und\nsehr fleißig zu sein.", italian="Tu invece hai davvero un'aria\nmotivata e determinata.", spanish="Se te ve bastante motivada\ny trabajando duro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Well, it's only natural.", french=" Hé ben, rien de plus naturel.", german=" Na, das ist doch ganz natürlich.", italian=" Beh, mi sembra ovvio.", spanish=" Bueno, es lo normal."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'm on my way to take care of\na job.", french="Je suis en route pour aller\naccomplir une mission.", german="Ich bin gerade drauf und dran,\nmich um einen Job zu kümmern.", italian="Devo portare a termine\nuna missione.", spanish=" Voy de camino a una misión."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english=" Is that right...?[K] Do your best...", french="C'est vrai...?\nFais de ton mieux...", german=" Ist das wahr?[K] Viel Erfolg...", italian="Sul serio...?[K] Buona fortuna\nallora...", spanish=" ¿En serio?[K] Ve a darlo todo..."})
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english="Zero motivation, but we're an\nexploration team...", french="Zéro motivation, mais nous n'en\nsommes pas moins une équipe d'exploration...", german="Null Motivation, aber wir sind\nein Erkundungsteam...", italian="Noi avremo anche zero\nmotivazioni, ma siamo pur sempre\nuna squadra d'esplorazione...", spanish="No tenemos nada de motivación,\npero somos un equipo explorador..."})
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english="We came over here to\nthe Bulletin Board to look for jobs...", french="On est venus là pour chercher\nune mission sur le Tableau des Missions.", german="Wir sind hierhergekommen, um\nauf dem Infobrett nach Jobs zu suchen...", italian="Siamo venuti qui per dare\nun'occhiata alla Bacheca delle missioni...", spanish="Hemos venido a buscar misiones\nen el Tablón de Anuncios..."})
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english="But to move away from here...[K]\nTakes so much effort...", french="Mais maintenant il faut qu'on se\nbouge d'ici...[K]\nEt ça, c'est trop d'effort...", german="Aber uns dorthin zu bewegen...[K]\nDas ist so anstrengend...", italian="Ma mettersi all'opera...[K]\nè troppo faticoso.", spanish="Pero moverse de aquí...[K]\nsería un esfuerzo demasiado grande..."})
  -- message_Close
  -- @label_1 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.cleanup_npcs()
end
