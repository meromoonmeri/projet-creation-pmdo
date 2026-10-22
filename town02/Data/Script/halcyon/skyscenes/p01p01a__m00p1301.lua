-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/m00p1301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_P01P03A) [neutre/état moteur]
  -- supervision_StationCommon(7) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetOutputAttribute(128) [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  GAME:WaitFrames(30)
  -- ResetOutputAttribute(128) [neutre/état moteur]
  GROUND:MoveToPosition(hero, 236, 236, false, 2)
  GAME:WaitFrames(15)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 216, 120, Direction.Down, "NPC_CHIRIIN")
  GROUND:MoveToPosition(npc_npc_chiriin, 216, 204, false, 2)
  GAME:WaitFrames(20)
  -- ResetOutputAttribute(128) [neutre/état moteur]
  GROUND:MoveToPosition(partner, 200, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Up)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Oh, [hero]!", french=" Oh, [hero]!", german=" Oh, [hero]!", italian=" Oh, [hero]!", spanish=" ¡Anda, [hero]!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Were you just at the café?", french=" Tu sors du café?", german=" Warst du gerade im Café?", italian=" Stavi uscendo dal caffè, vero?", spanish=" ¿Estabas en la cafetería?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Perfect timing![K]\nThe truth is... I have something to ask you...", french="Tu tombes bien![K]\nEn fait... j'ai un truc à te demander...", german="Das trifft sich ja hervorragend![K]\nUm ehrlich zu sein, habe ich eine Bitte an dich.", italian="Tempismo perfetto![K]\nA dire il vero... dovrei chiederti una cosa...", spanish="¡Justo a tiempo![K]\nLo cierto es que... quiero pedirte una cosa..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="In the past, when you've wanted\nto take team members with you to explore,\nthey waited for you at this Watering Hole...", french="Avant, quand tu ajoutais des\nmembres à ton équipe d'exploration,\nceux-ci t'attendaient près du Point d'Eau...", german="Bisher haben Team-Mitglieder,\ndie du mit auf Erkundung nehmen wolltest,\nimmer bei diesem Wasserloch gewartet...", italian="In passato, quando sceglievi dei\nmembri da portare in esplorazione, loro ti\naspettavano qui al pozzo...", spanish="Antes, cuando querías llevar\na más miembros del equipo a explorar,\nte esperaban en esta fuente..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="But now that the café\nhas just opened...", french="Mais maintenant que le café\nvient d'ouvrir...", german="Aber jetzt, wo gerade das Café\neröffnet wurde...", italian="Ma ora che il caffè è stato\naperto...", spanish="Pero ahora que acaba de abrir\nla cafetería..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Everyone has been saying they'd\nlike to wait while relaxing at the café.", french="... tout le monde est d'avis que\nce serait mieux d'attendre tranquillement\nau café.", german="Da waren alle der Meinung, es\nwäre schöner, entspannt im Café zu warten.", italian="... tutti dicono che\npreferirebbero aspettare rilassandosi\nlì dentro.", spanish="Todos dicen que preferirían\nesperar pasando el rato en ella."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I completely understand that...[K]\nI mean, I understand how they feel.", french="C'est tout à fait\ncompréhensible...[K] Je veux dire,\nje comprends leur point de vue.", german="Das verstehe ich vollkommen...[K]\nIch meine, ich verstehe, dass sie das\nso sehen.", italian="Capisco benissimo che...[K]\nCioè, capisco come debbano sentirsi.", spanish="Y yo lo entiendo perfectamente...[K]\nVamos, que es lógico."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="So, [hero], what do\nyou think?", french="Et toi, [hero], qu'en\npenses-tu?", german="Nun, [hero], wie denkst\ndu darüber?", italian="Allora, [hero]... Cosa ne\ndici?", spanish="¿A ti qué te parece,\n[hero]?"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Would you like to meet up with\nyour team members waiting at the café?", french="Aimerais-tu que les membres de\nton équipe t'attendent au café?", german="Würdest du dich mit deinen\nTeam-Mitgliedern auch im Café treffen?", italian="Ti andrebbe di incontrare\ni membri della tua squadra al caffè?", spanish="¿Te gustaría reunirte con los\nmiembros de tu equipo en la cafetería?"})
  do local __choice = SkySceneKit.ask({{english="OK.", french="D'accord.", german="Aber natürlich.", italian="Certo.", spanish="Vale..."}, {english="No way.", french="Pas question.", german="Nicht mit mir.", italian="No.", spanish="¡Ni hablar!"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Thank you, [hero]!", french=" Merci, [hero]!", german=" Danke schön, [hero]!", italian=" Grazie, [hero]!", spanish=" ¡Gracias, [hero]!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I'll make sure to let\neveryone know!", french="Je m'occuperai de faire passer\nle mot à tout le monde!", german=" Ich werde es allen mitteilen!", italian="Spargerò la voce in modo che\nlo sappiano tutti!", spanish="Ya me encargo yo de que\nse entere todo el mundo."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I'm sure everyone will be happy\nto hear that!", french="Aucun doute qu'ils seront tous\nheureux d'entendre ça!", german="Ich bin mir sicher, sie werden\nsich alle darüber freuen!", italian="Sono sicura che questa notizia\nfarà felici tutti quanti!", spanish="¡Ya verás el alegrón\nque se van a llevar!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Oh! [K]I almost forgot!", french=" Oh! [K]J'allais oublier!", german=" Oh! [K]Fast hätte ich es vergessen!", italian=" Oh! [K]Quasi dimenticavo!", spanish=" ¡Ah![K] Casi se me olvida."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_chiriin, 272, 156, false, 2)
  GAME:WaitFrames(20)
  pcall(function() GAME:MoveCamera(216, 188, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 276, 196, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 232, 204, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I secretly placed a signpost\nhere...[K] Did you see it, [hero]?", french="J'ai placé une pancarte ici...[K]\nTu l'as vue, [hero]?", german="Ich habe hier ein\nSchild platziert...[K]\nHast du es schon gesehen, [hero]?", italian="Ho messo un cartello qui...[K]\nLo hai visto, [hero]?", spanish="He colocado una señal aquí...[K]\n¿La has visto ya, [hero]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" I...I knew it!", french=" Je... je le savais!", german=" Ich... Ich wusste es!", italian=" Lo... Lo sapevo!", spanish=" Si es que... ¡lo sabía!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I'm sorry, [hero].[K]\nI guess I should explain!", french="Pardon, [hero].[K]\nÇa mérite une explication, je pense!", german="Tut mir leid, [hero].[K]\nIch glaube, ich sollte es dir erklären!", italian="Mi spiace, [hero].[K]\nImmagino di doverti dare una spiegazione!", spanish="Lo siento, [hero].[K]\nSupongo que debería explicarme."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chiriin, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="If you ring the bell attached to\nthis sign...[K] I'll come here from the guild...", french="Si tu fais sonner cette cloche\nqui est attachée à la pancarte...[K]\nj'accours de la Guilde à toute vitesse...", german="Wenn du die Glocke an dem\nSchild läutest...[K] komme ich von der\nGilde hierher...", italian="Se suoni la campana attaccata\na questo cartello...[K] arriverò qui di filato\ndalla Gilda...", spanish="Si haces sonar la campana que\nestá sujeta a esta señal,[K] vendré\ndesde el [CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="You can still assemble your\nexploration team here!", french="Tu peux continuer à rassembler\nton équipe d'exploration ici!", german="Du kannst dein Team nach wie\nvor auch hier aufstellen!", italian="... e potrai organizzare\nla tua squadra di esplorazione!", spanish="Aún puedes reunir a tu\nequipo explorador aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="So when you want to assemble\nyour team, just ring this bell!", french="Donc, quand tu veux rassembler\nton équipe, il te suffit de faire sonner\nla cloche!", german="Wenn du dein Team\nalso aufstellen möchtest,\nläute einfach die Glocke!", italian="Quindi, se vuoi riunire i membri\ndella tua squadra, suona questa campanella!", spanish="Así que, cuando quieras reunirlo,\nhaz sonar esta campana y ya está."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="...[K]M-maybe you already\ndid ring the bell to summon me here before...", french="...[K] P-peut-être que tu as déjà\nfait sonner la cloche pour\nm'appeler auparavant...", german="...[K]H-hast du die Glocke nicht\nsogar schon einmal geläutet,\num mich hierherzurufen?", italian="...[K] F-Forse hai già suonato\nla campana per chiamarmi qui prima...", spanish="A...[K] A lo mejor es que ya habías\ntocado la campana para llamarme antes..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="...and you did assemble your\nteam here...", french="... et que tu as rassemblé\nton équipe ici...", german="Und du hast dein Team\nhier aufgestellt...", italian="... perché vedo che hai già\norganizzato la tua squadra...", spanish="Y ya has reunido aquí a tu\nequipo..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Regardless, you rather\ncarelessly answered my question\nwith a \"No.\"", french="Et que tu as quand même\nrépondu \"Non\" à ma question...", german="Dennoch hast du ziemlich\nunbedarft mit [F:S2]Nein[F:E2] geantwortet?!?", italian="Eppure hai sbadatamente\nrisposto con un \"No\" alla mia domanda.", spanish="En cualquier caso, me has\nrespondido con un \"no\" bastante borde.\n¿Te parece bonito? ¿Eh?"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Maybe you just wanted to see\nwhat would happen if you answered with\na \"No\"...", french="Peut-être que tu voulais\nsimplement voir ce que ça ferait\nde répondre \"Non\"...", german="Vielleicht wolltest du nur sehen,\nwas passiert, wenn du mit [F:S2]Nein[F:E2] antwortest...", italian="Forse volevi solo vedere cosa\nsarebbe accaduto in quel caso...", spanish="Supongo que querías ver\nqué pasaba si contestabas que no..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Anyway...[K] If you ring the bell\nhere, your team will assemble...", french="Quoi qu'il en soit...[K] Si tu fais\nsonner la cloche accrochée ici, ton équipe\nse rassemblera...", german="Wie dem auch sei...[K]\nWenn du hier die Glocke läutest, kannst du\ndein Team aufstellen...", italian="Ma non importa...[K] Se suoni\nla campana, potrai organizzare la tua squadra...", spanish="En fin, lo que te decía...[K] Que si\nhaces sonar la campana, tu equipo vendrá..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" So try it sometime and see!", french="Alors, à l'occasion,\nessaye pour voir!", german="Also probier's doch\neinfach mal aus!", italian=" Quindi provaci qualche volta!", spanish="¡Así que prueba a hacerlo\nalguna vez!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="That's all, [hero]![K]\nGood luck exploring!", french="C'est tout, [hero]![K]\nBonne chance pour ton exploration!", german="Das ist alles, [hero]![K]\nViel Erfolg auf deinen Erkundungen!", italian="È tutto, [hero]![K]\nBuona esplorazione!", spanish="Eso es todo, [hero].[K]\n¡Que explores bien!"})
  -- message_Close
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Of course you would,\n[hero]!", french="Bien sûr, tu l'as vue,\n[hero]!", german=" Oh natürlich, [hero]!", italian="Ma certo che sì,\n[hero]!", spanish="Ah, ¡claro que la has visto!\n¡Tienes vista de lince, [hero]!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="You must have rung the bell,\nbecause your team has assembled here already.", french="Tu as forcément fait sonner la\ncloche puisque ton équipe est déjà\nrassemblée ici.", german="Du musst die Glocke geläutet\nhaben, denn dein Team hat sich bereits\nversammelt.", italian="Devi aver suonato la campana\nperché la tua squadra si è già riunita qui.", spanish="Debes de haber hecho sonar la\ncampana, porque tu equipo ya está\nreunido aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chiriin, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="As you know, when you ring this\nbell...[K] I come here from the guild...", french="Comme tu le sais, quand tu fais\nsonner cette cloche...[K]\nj'accours de la Guilde à toute vitesse...", german="Du weißt schon, wenn du diese\nGlocke läutest...[K] Dann komme ich von der Gilde\nhierher...", italian="Come sai, quando suonerai questa\ncampana...[K] arriverò qui io dalla Gilda...", spanish="Como sabes, cuando tocas la\ncampana...[K] vengo corriendo del [CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="You can still assemble your\nexploration team here!", french="Tu peux continuer à rassembler\nton équipe d'exploration ici!", german="Du kannst dein Team nach wie\nvor auch hier aufstellen!", italian="... e potrai organizzare\nla tua squadra d'esplorazione!", spanish="Aún puedes reunir a tu equipo\nexplorador aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="So when you want to assemble\nyour team, just ring this bell!", french="Donc, quand tu veux rassembler\nton équipe, tu n'as qu'à faire sonner la cloche!", german="Wenn du dein Team\nalso aufstellen möchtest,\nläute einfach die Glocke!", italian="Quindi, se vuoi riunire i membri\ndella tua squadra, suona questa campanella!", spanish="Cuando quieras reunirlo,\nhaz sonar esta campana y ya está."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="That's all, [hero]![K]\nGood luck exploring!", french="C'est tout, [hero]![K]\nBonne chance pour ton exploration!", german="Das ist alles, [hero]![K]\nViel Erfolg auf deinen Erkundungen!", italian="È tutto, [hero]![K]\nBuona esplorazione!", spanish="Eso es todo, [hero].[K]\n¡Que explores bien!"})
  -- message_Close
  -- @label_4 [étiquette de flux ExplorerScript]
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(30)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:TeleportTo(hero, 276, 196, Direction.Down)
  GROUND:TeleportTo(partner, 248, 196, Direction.Down)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  GAME:FadeIn(30)
  end
  end
  else -- default/annulation
  -- @label_1 [étiquette de flux ExplorerScript]
  -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="W-what?![K]\nN-no...[K]way?!", french="C-comment?![K]\nP-pas...[K] question?!", german="W-was?!?[K]\nN-nicht...[K] mit dir?!?", italian="C-Come?! [K]\nN-[K]No?!", spanish="¡¿Có... cómo?![K]\n¡¿Que...[K] ni hablar?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Are you making fun of me,\n[hero]? You are! I know it!", french="Tu te moques de moi,\n[hero]? Bien sûr! C'est ça!", german="Veralberst du mich,\n[hero]? Komm schon! Ich weiß es!", italian="Mi stai prendendo in giro, vero\n[hero]? Ma certo! È così!", spanish="¿Estás de broma, [hero]?\n¡Ah, claro que es broma! ¡Ja, ja, qué bueno!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="You said \"No way\" to see\nhow I'd react, didn't you?", french="En fait, tu as juste dit\n\"Pas question\" pour voir ma réaction,\npas vrai?", german="Du hast [F:S2]Nicht mit mir[F:E2] gesagt,\nnur um meine Reaktion zu sehen, nicht wahr?", italian="Hai detto \"No\" per vedere come\navrei reagito, eh?", spanish="Has dicho \"ni hablar\" para ver\nqué cara se me quedaba, ¿verdad?"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" ...[K]I understand how you feel...", french="...[K]\nJe te comprends...", german=" ...[K]Ich verstehe dich...", italian=" ...[K] Capisco come ti senti...", spanish=" Bueno...[K] Es comprensible..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Even if you select a \"No,\" you\neventually have to select the \"Yes,\" so\nit always ends up the same anyway...", french="Même quand tu choisis de\nrépondre \"Non\", à la fin, c'est toujours la\nmême histoire: tu dois finir par dire \"Oui\"...", german="Selbst wenn du [F:S2]Nein[F:E2] wählst,\nmusst du letztendlich [F:S2]Ja[F:E2] antworten, daher\nläuft es eh aufs Gleiche hinaus, nicht wahr?", italian="Anche se scegli \"No\" alla fine\ndevi selezionare \"Sì\", quindi in un modo\no nell'altro il risultato è sempre lo stesso...", spanish="Por más que digas que no, ¡tarde\no temprano vas a tener que ceder! Así que\nal final tanto da que te empecines..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="That comes up frequently, that\nsort of thing...[K] But...", french="C'est quelque chose qui arrive\nfréquemment...[K] Néanmoins...", german="Das passiert schon häufiger,\nnun gut...[K] Aber...", italian="Questo genere di cose succede\nspesso...[K] Però...", spanish="Es natural sentirte un poco\nrebelde a veces...[K] pero es inútil."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" I'll ask you again, [hero].", french="... je te pose la question\nencore une fois, [hero].", german="Ich frage dich\nnoch einmal, [hero].", italian="... te lo chiederò un'altra volta,\n[hero].", spanish="Voy a preguntarte de nuevo,\n[hero]."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Would you like to meet up with\nyour team members waiting at the café?", french="Aimerais-tu que les membres de\nton équipe t'attendent au café?", german="Würdest du dich mit deinen\nTeam-Mitgliedern auch im Café treffen?", italian="Ti andrebbe di incontrare\ni membri della tua squadra al caffè?", spanish="¿Te gustaría encontrarte con los\nmiembros de tu equipo en la cafetería?"})
  do local __choice = SkySceneKit.ask({{english="OK!", french="D'accord!", german="Aber natürlich.", italian="Certo.", spanish="¡Vale!"}, {english="No way.", french="Pas question.", german="Nicht mir mir.", italian="No.", spanish="Ni hablar..."}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  else -- default/annulation
  -- break_loop [contrôle de boucle forever NDS: une itération compilée]
  end
  end
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
