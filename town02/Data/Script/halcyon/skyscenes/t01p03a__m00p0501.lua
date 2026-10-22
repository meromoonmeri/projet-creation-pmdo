-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P03A/m00p0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[12] = 1 -- $SCENARIO_MAIN_BIT_FLAG[12] = 1 (ROM)
  -- back_SetGround(LEVEL_T01P03A) [neutre/état moteur]
  -- supervision_StationCommon(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-32), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-40), false, 2) end
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  local npc_npc_garagara = SkySceneKit.spawn_npc("marowak", 256, 216, Direction.Down, "NPC_GARAGARA")
  pcall(function() GROUND:CharSetEmote(npc_npc_garagara, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" ...[K]V-[K]visitors...?", french="...[K] Hein? Des vi...[K]\ndes visiteurs...?", german=" ...[K]B-[K]besucher?", italian=" ...[K] C-[K]Clienti...?", spanish=" ¿Eh?[K] Vi...[K] ¿Visitantes?"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="F-finally...[K] M-my...[K]\nfirst visitors!", french="En-enfin...[K] M-mes...[K] premiers\nvisiteurs!", german="E-endlich...[K] M-meine...[K] ersten\nBesucher!", italian="F-Finalmente![K] È la prima\nvolta...[K] che vengono dei clienti!", spanish="Al... Al fin...[K] Mis...[K]\n¡Mis primeros visitantes!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_garagara, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_garagara, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(npc_npc_garagara, 252, 252, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="Welcome to [CS:K]Marowak[CR] Dojo.[K]\nThis is my place! It's dedicated to the training\nof exploration teams!", french="Bienvenue au [CS:K]Dojo Ossatueur[CR].[K]\nC'est chez moi! C'est un lieu consacré\nà l'entraînement des équipes d'exploration!", german="Willkommen im [CS:K]Knogga-Dojo[CR].[K]\nIch leite dieses Dojo, damit Erkundungsteams\nhier trainieren können!", italian="Questo è il Dojo [CS:K]Marowak[CR].[K]\nLo gestisco io! La sua funzione è addestrare le\nsquadre d'esplorazione!", spanish="Bienvenidos al [CS:K]Dojo Marowak[CR].[K]\n¡Este es mi negocio! ¡Aquí me ocupo del\nentrenamiento de equipos de exploración!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="The dojo went to rack and ruin,\nthen to a pile of rubble, but...[K]it has now\nrisen from the dust to its former glory!", french="Le dojo était en ruine, il ne\nrestait que des décombres, mais...[K] voilà\nque tel le phénix, il renaît de ses cendres!", german="Das Dojo ging den Bach runter\nund hat mich ruiniert, aber...[K] Nun ist es wieder\naufgebaut und erstrahlt in seinem alten Glanz!", italian="Dopo mille difficoltà, il dojo...[K]\nè tornato allo splendore di un tempo!", spanish="El dojo acabó en ruinas y no era\nmás que una pila de escombros, pero... [K]\n¡ha renacido para volver a ser lo que era!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" But...[K]I haven't had any visitors...", french="L'ennui...[K] c'est que je n'ai pas\nencore eu de visiteurs...", german="Nur...[K] Bisher waren noch keine\nBesucher hier...", italian="Ma...[K] finora non ho avuto alcun\ncliente...", spanish="Aunque...[K] No he tenido aún\nningún visitante..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_garagara, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="There hasn't been even one.[K]\nIt saddened me to my very marrow...[K] But then!", french="Pas l'ombre d'un visiteur.[K]\nComme je suis déçu... déçu jusqu'à l'os...[K]\nMais maintenant...", german="Nicht mal ein einziger![K]\nIch war aufs Tiefste betrübt...[K] Doch dann...", italian="Non è venuto proprio nessuno.[K]\nEro davvero triste...[K] ma adesso...", spanish="No ha venido ni uno solo.[K]\nEso me tenía entristecido...[K] ¡Pero ahora...!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" Along came you two!", french=" Vous voilà, vous deux!", german=" Dann kamt ihr beide!", italian="... avete varcato la soglia\nvoi due!", spanish=" ¡Dos! ¡Dos que me visitan!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="You are my first customers![K]\nFrom my very marrow, I'm feeling overjoyed!", french="Vous allez inaugurer mon dojo![K]\nJe suis tout excité, j'en crois pas mes os!", german="Ihr seid meine ersten Kunden![K]\nIch bin außer mir vor Freude!", italian="I miei primi clienti![K]\nSono strafelice!", spanish="¡Sois mis primeros clientes![K]\n¡Me siento radiante de felicidad!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="I don't even want money![K]\nKeep it! Just train here, that's all I ask!", french="Je ne veux même pas d'argent![K]\nGardez-le! Tout ce que je vous demande, c'est\nde vous entraîner ici!", german="Ich verlange nicht einmal Geld![K]\nBehaltet es! Trainiert einfach hier, mehr will\nich nicht!", italian="Non voglio neanche soldi![K]\nTeneteveli! Tutto ciò che vi chiedo è di\nallenarvi qui!", spanish="¡Ni siquiera quiero vuestro\ndinero![K] ¡Quedáoslo! ¡Lo único que os pido\nes que vengáis a entrenaros aquí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(252, 196, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_garagara, 252, 188, false, 2)
  GAME:WaitFrames(10)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-72), false, 2) end
  GAME:WaitFrames(5)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-72), false, 2) end
  GROUND:EntTurn(npc_npc_garagara, Direction.UpRight)
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="There's the entrance to the\ntraining mazes.", french="Voici l'entrée qui mène aux\ndédales d'entraînement.", german="Da ist der Eingang zu den Dojos,\nin denen ihr trainieren könnt.", italian="Da lì si entra nei dedali\nd'allenamento.", spanish="Esta es la entrada a los\ndojos de entrenamiento."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="I have to tell you one thing...[K]\nTraining mazes aren't like ordinary dungeons...", french="Il faut que je vous dise\nune chose...[K] Les dédales d'entraînement n'ont\nrien à voir avec des donjons ordinaires...", german="Eine Sache solltet ihr wissen...[K]\nDojos zum Trainieren sind keine gewöhnlichen\nDungeons...", italian="Devo dirvi una cosa...[K]\nI dedali d'allenamento non sono come i dungeon\nnormali.", spanish="Tengo que contaros una cosa.[K]\nLos dojos de entrenamiento no son como\nlos territorios convencionales."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="There's this icky part, you see.\nWhen you go in, you hand over everything\nthat's in your Treasure Bag.", french="Il y a un os, voyez-vous. Quand\nvous y pénétrez, vous devez remettre tout\nle contenu de votre Sac à Trésor.", german="Da gibt es diese eine recht\nunschöne Kleinigkeit: Bevor ihr reingeht, gebt\nihr den gesamten Inhalt eures Schatzbeutels ab.", italian="C'è un dettaglio sgradevole.\nQuando entrate, dovete consegnare il contenuto\ndella vostra Sacca dei tesori.", spanish="El mayor inconveniente es que\nal entrar tendréis que dejar fuera\nlo que llevéis en vuestra Bolsa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_garagara, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="To avoid losing the items in your\nTreasure Bag, put them in [CS:K]Kangaskhan[CR] Storage\nbefore you go in.", french="Pour éviter de perdre les objets\nde votre Sac à Trésor, laissez-les\nà la [CS:K]Réserve Kangourex[CR] avant d'entrer.", german="Das ist aber überhaupt kein\nProblem, wenn ihr vorher einfach alle Items\nzum [CS:K]Kangama-Lager[CR] bringt.", italian="Per non perdere il contenuto\ndella Sacca dei tesori, consegnate gli strumenti\nal Deposito [CS:K]Kangaskhan[CR] prima di entrare.", spanish="Para evitar perder los objetos,\nguardadlos en la [CS:K]Consigna Kangaskhan[CR] antes\nde entrar."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="There's more![K] If you get KO'd,\nyou don't lose the new money and items that\nyou found in the maze. You get to keep them!", french="Encore une chose![K] Si vous êtes\nK.O., vous ne perdrez ni l'argent, ni les objets\ntrouvés dans le dédale. Vous les garderez!", german="Und noch was![K] Auch wenn ihr\nK.O. geht, dürft ihr das Geld und die Items\nbehalten, die ihr beim Training gefunden habt!", italian="Ma c'è di più![K] Se andate KO,\nnon perderete i soldi e gli strumenti che avete\ntrovato nel dedalo. Potrete tenerli!", spanish="Por otro lado...[K] Si os vencen\nen el dojo, ¡no perderéis el dinero ni\nlos nuevos objetos que hayáis conseguido en él!"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="There's no risk to you, so you\ncan go all out while you train.", french="Vous ne risquez rien, donc vous\npouvez y aller à fond pendant l'entraînement.", german="Es besteht keinerlei Risiko für\neuch. Ihr könnt euch beim Training also so\nrichtig austoben!", italian="Non c'è alcun rischio per voi!\nPotete dare il massimo quando vi allenate.", spanish="No corréis realmente ningún\nriesgo, así que al entrenaros aquí\nos podéis emplear a fondo."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="So, yes, make me happy. Train\nyour team here.[K] How about it?", french="Allez, faites-moi plaisir.\nEntraînez votre équipe ici.[K]\nQu'en pensez-vous?", german="Also, trainiert mir zuliebe hier![K]\nWas sagt ihr?", italian="Quindi, fatemi felice. Allenatevi\nqui.[K] Cosa ne dite?", spanish="Venga, alegradme el día.\nEntrenad aquí vuestro equipo.[K] ¿Qué\nme decís?"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
