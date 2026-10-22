-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P11A/us3118.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_kuchiito = SkySceneKit.spawn_npc("mawile", 280, 264, Direction.Up, "NPC_KUCHIITO")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kuchiito, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="I'd love to go on an expedition\nwith everyone again sometime!", french="J'adorerais repartir en\nexploration avec toute l'équipe un jour!", german="Ich würde so gerne noch einmal\nmit allen auf eine Expedition gehen!", italian="Non vedo l'ora di partire per\nun'altra spedizione con qualcuno!", spanish="¡Sería genial que fuéramos\ntodos de expedición otra vez!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 53] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kuchiito, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english=" Haven't had a break in a while...", french="Ça fait un bout de temps qu'on\nn'a pas fait de pause...", german="Schon lange keine Pause mehr\ngehabt...", italian="È da un po' che non faccio\nuna sosta...", spanish="Hace tiempo que no\nme tomo un respiro..."})
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="It's great to just relax and take\nyour time once in a while! Tee-hee-hee!", french="Prendre son temps et se\ndétendre, c'est si agréable! Youhouhou!", german="Es ist großartig, hin und wieder\neinfach nur zu entspannen und sich Zeit zu\nnehmen! Ji-chi-chi!", italian="Ogni tanto è così bello fare\nuna pausa e rilassarsi senza pensare\na nulla! Hi hi hi!", spanish="¡Con lo que mola relajarse\ny descansar de vez en cuando! ¡Ji, ji, ji!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 39] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kuchiito, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="Memories of exploring with\neveryone will last a lifetime! Tee-hee!", french="Les souvenirs de nos\nexplorations en équipe resteront\ngravés à jamais! Youhou!", german="Die Erinnerung daran, wie alle\nzusammen auf Erkundung waren, hält für\nimmer! Ji-chi!", italian="I ricordi delle esplorazioni che\nho fatto con i miei amici dureranno per\nsempre! Hi hi!", spanish="¡Los recuerdos de nuestras\nexploraciones perdurarán siempre! ¡Ji, ji!"})
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="I won't be able to forget the\nspectacular view from the summit, either...", french="En plus, je ne pourrai jamais\noublier la vue à couper le souffle\nqu'on a du sommet.", german="Auch die spektakuläre Aussicht\nvom Gipfel werde ich niemals vergessen...", italian="E non potrò nemmeno scordare\nil magnifico panorama che ho ammirato\ndalla cima della montagna...", spanish="Las espectaculares vistas desde\nla cima también son inolvidables, la verdad..."})
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="That's why I just can't stop\nexploring!", french="C'est pour ça que je ne peux pas\nm'arrêter d'explorer!", german="Deswegen krieg ich nicht genug\nvon Erkundungen!", italian="Ecco perché non riesco\na smettere di esplorare!", spanish="¡Por eso no puedo dejar\nde explorar!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="I wonder if [CS:N]Sneasel[CR] is\nall right...", french="J'espère que [CS:N]Farfuret[CR] va vite\ns'en remettre...", german="Ich frage mich, ob es [CS:N]Sniebel[CR]\ngut geht...", italian=" Chissà se [CS:N]Sneasel[CR] sta bene...", spanish="Me pregunto si [CS:N]Sneasel[CR]\nestará bien..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 25] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="Leave this to me. You go and\nhurry on ahead and get some help.", french="Laisse, je m'en occupe. Toi,\ndépêche-toi d'avancer et va chercher\nde l'aide.", german="Überlasst das mir. Ihr beeilt\neuch und holt Hilfe.", italian="Qui ci penso io. Voi andate\navanti e cercate aiuto.", spanish="Déjamelo a mí, tú ve corriendo\na buscar ayuda."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 23] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="We misunderstood earlier too.\nI wonder what that [CS:N]Sneasel[CR] was up\nto anyway!", french="On n'a pas bien compris, tout à\nl'heure. Je me demande ce que [CS:N]Farfuret[CR]\nmanigançait.", german="Wir haben das zuvor auch\nfalsch verstanden. Ich frage mich, was [CS:N]Sniebel[CR]\nüberhaupt vorhatte!", italian="Anche noi siamo stati tratti in\ninganno prima. Comunque mi chiedo cosa stesse\narchitettando quello [CS:N]Sneasel[CR]!", spanish="Antes nos hicimos un lío.\nMe pregunto qué tramaría ese [CS:N]Sneasel[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="He just ran off without saying\na word to anyone...", french="Il s'est enfui comme ça,\nsans rien dire à qui que ce soit...", german="Er ist einfach weggerannt, ohne\nirgendjemandem auch nur ein Wort zu sagen...", italian="È scappato via senza dire\nuna parola...", spanish="Se fue corriendo sin decir\nesta boca es mía..."})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 19] || scn($SCENARIO_MAIN) >= [2
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_fuwaraido = SkySceneKit.spawn_npc("drifblim", 280, 232, Direction.Down, "NPC_FUWARAIDO")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kuchiito, npc_npc_fuwaraido, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english=" This is [CS:K]Drifblim[CR]'s Gondola.", french=" C'est la [CS:K]Navette Grodrive[CR].", german="Das hier ist die\n[CS:K]Drifzepeli-Seilbahn[CR].", italian="Questa è l'Agenzia Viaggi\n[CS:K]Drifblim[CR].", spanish=" Esta es la [CS:K]Góndola Drifblim[CR]."})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kuchiito, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="It's really handy transportation,\nconnecting the [CS:P]Shaymin Village[CR] to the bases.", french="C'est un moyen de transport\ntrès pratique qui relie le [CS:P]Village Shaymin[CR]\naux différents campements.", german="Ein sehr komfortables\nTransportmittel, das [CS:P]Shaymin-Dorf[CR] mit den\nZwischenlagern verbindet.", italian="Offre un comodo sistema di\ntrasporto dal [CS:P]Villaggio Shaymin[CR] ai bivacchi.", spanish="Es un transporte superpráctico\nque enlaza [CS:P]Aldea Shaymin[CR] con las bases."})
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="Right now this only connects the\n2nd Station Clearing and the village...", french="Pour l'instant, il relie seulement\nla trouée du 2[F:E] Relais au village...", german="Bis jetzt verbindet sie nur die\n2. Zwischenlagerlichtung mit dem Dorf...", italian="Al momento collega solo\nil Bivacco 2 e il villaggio...", spanish="Ahora solo enlaza la Base del\nSegundo Puerto con la aldea..."})
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="Once a new base is established,\nwe should be able to travel there. Tee-hee!", french="Une fois qu'un nouveau\ncampement aura été établi, on devrait pouvoir\nl'atteindre par ce moyen. Yahou!", german="Aber sobald eine neue Basis\nerrichtet wurde, sollten wir dorthin reisen\nkönnen. Ji-chi!", italian="... ma quando si raggiunge\nun nuovo bivacco, è possibile viaggiare anche\nda lì. Hi hi!", spanish="Pero en cuanto haya una nueva\nbase se podrá viajar a ella. ¡Ji, ji!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 13] || scn($SCENARIO_MAIN) >= [2
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kuchiito, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="I'm [CS:N]Mawile[CR], a member of\nTeam [CS:X]Frontier[CR], the survey team.", french="Je suis [CS:N]Mysdibule[CR], membre de\nl'Equipe [CS:X]Eclaireurs[CR], l'équipe de reconnaissance.", german="Mein Name ist [CS:N]Flunkifer[CR],\nMitglied von Team [CS:X]Grenzland[CR], dem\nVermessungsteam.", italian="Mi chiamo [CS:N]Mawile[CR], sono un\nmembro del Team [CS:X]Pioniere[CR],\nla squadra d'indagine.", spanish="Soy [CS:N]Mawile[CR], miembro del\n[CS:X]Equipo Frontera[CR], el equipo de reconocimiento."})
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="It's kind of difficult getting\nup here...", french="C'est assez difficile\nde monter là-haut...", german="Ziemlich schwierig, hier hoch zu\nkommen.", italian="È piuttosto difficile arrivare\nfin qui...", spanish="Es bastante complicado llegar\nhasta aquí..."})
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="When we found the [CS:P]Shaymin\nVillage[CR], we jumped for joy. Tee-hee!\nOur weariness just vanished!", french="Quand nous avons trouvé le\n[CS:P]Village Shaymin[CR], on a sauté de joie. Yahou!\nNotre fatigue s'est envolée!", german="Als wir [CS:P]Shaymin-Dorf[CR] entdeckt\nhaben, haben wir vor Freude getanzt. Ji-chi!\nUnsere Erschöpfung war verschwunden!", italian="Quando abbiamo trovato il\n[CS:P]Villaggio Shaymin[CR], abbiamo fatto i salti di gioia.\nHi hi! La nostra stanchezza è svanita subito!", spanish="Cuando encontramos [CS:P]Aldea Shaymin[CR],\nsaltamos de alegría, ji, ji.\n¡Se nos fue el cansancio de golpe!"})
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="That's why I just can't stop\nexploring! Tee-hee-hee!", french="C'est pour ça que je ne peux pas\nm'arrêter d'explorer! Youhou!", german="Genau deswegen krieg ich nicht\ngenug von Erkundungen! Ji-chi-chi!", italian="Ecco perché non riesco\na smettere di esplorare! Hi hi hi!", spanish="Por eso no puedo dejar de explorar.\n¡Ji, ji, ji!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) or (SkyProg.cmp(20, 3) >= 0) or (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 8] || scn($SCENARIO_MAIN) >= [29
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
