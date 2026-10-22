-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m13a0801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What...?!", french=" Quoi...?!", german=" Was?!?", italian=" Oh!", spanish=" ¡¿Cómo?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What...?!", french=" Quoi...?!", german=" Was?!?", italian=" Oh!", spanish=" ¡¿Cómo?!"})
  else
  SkySceneKit.say({english=" What...?!", french=" Quoi...?!", german=" Was?!?", italian=" Oh!", spanish=" ¡¿Cómo?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 352, 216, Direction.Down, "NPC_PERAPPU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, partner, 4) end)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 392, 224, Direction.Down, "NPC_PUKURIN")
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownLeft)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 384, 248, Direction.UpLeft, "NPC_BIPPA")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, partner, 4) end)
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 312, 216, Direction.DownRight, "NPC_YONOWAARU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru, partner, 4) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 352, 272, Direction.Up, "NPC_KIMAWARI")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, partner, 4) end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 296, 240, Direction.UpRight, "NPC_DOGOOMU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, partner, 4) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 408, 240, Direction.UpLeft, "NPC_CHIRIIN")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, partner, 4) end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 352, 248, Direction.Up, "NPC_HEIGANI")
  GROUND:EntTurn(npc_npc_heigani, Direction.DownLeft)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 376, 272, Direction.UpLeft, "NPC_GUREGGURU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, partner, 4) end)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 408, 264, Direction.UpLeft, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, partner, 4) end)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 320, 248, Direction.UpRight, "NPC_DIGUDA")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So everyone's back from their\nsearches...", french=" Alors tout le monde est rentré...", german="Es sind also alle von ihrer\nSuche zurück...", italian="Anche gli altri hanno terminato\nle loro ricerche.", spanish="Así que todos han regresado\nde sus exploraciones..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So everyone's back from their\nsearches...", french=" Alors tout le monde est rentré...", german="Es sind also alle von ihrer\nSuche zurück...", italian="Anche gli altri hanno terminato\nle loro ricerche.", spanish="Así que todos han regresado\nde sus exploraciones..."})
  else
  SkySceneKit.say({english="So everyone's back from their\nsearches...", french=" Alors tout le monde est rentré...", german="Es sind also alle von ihrer\nSuche zurück...", italian="Anche gli altri hanno terminato\nle loro ricerche.", spanish="Así que todos han regresado\nde sus exploraciones..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But nobody found anything?", french="Mais personne n'a découvert\nquoi que ce soit?", german="Aber niemand hat etwas\ngefunden?", italian="Possibile che nessuno abbia\ntrovato niente?", spanish=" ¿Pero nadie ha encontrado nada?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But nobody found anything?", french="Mais personne n'a découvert\nquoi que ce soit?", german="Aber niemand hat etwas\ngefunden?", italian="Possibile che nessuno abbia\ntrovato niente?", spanish=" ¿Pero nadie ha encontrado nada?"})
  else
  SkySceneKit.say({english=" But nobody found anything?", french="Mais personne n'a découvert\nquoi que ce soit?", german="Aber niemand hat etwas\ngefunden?", italian="Possibile che nessuno abbia\ntrovato niente?", spanish=" ¿Pero nadie ha encontrado nada?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Disappointing.", french=" Comme c'est décevant.", german=" Wie enttäuschend.", italian=" Che delusione.", spanish=" Vaya plan."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" That's what happened, all right!", french="Eh oui, on en est tous au même\npoint!", german=" Tja, so ist es!", italian=" Puoi dirlo forte!", spanish=" Eso es lo que ha pasado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! We went out to the\nEastern Forest, just like we were told!", french="Eh dis donc, on a suivi\nles ordres et on est allés dans la Forêt\nde l'Est.", german="Hey, hey! Wir waren in den\nÖstlichen Wäldern, ganz wie man es uns\naufgetragen hat!", italian="Ehi, ehi! Noi siamo andati alla\nForesta Orientale proprio come ci è stato\ndetto!", spanish="¡Oye, oye! Nosotros fuimos al\nBosque del Este tal y como nos dijeron."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="But, hey! There's nothing really\nthere but the forest!", french="Mais il n'y a rien d'autre que\nla forêt là-bas, saperlipopince!", german="Aber, hey! Da war, außer dem\nWald, überhaupt nichts zu finden!", italian="Però... Ehi! Non c'è proprio\nniente laggiù!", spanish="Pero, ¡oye! Allí lo único que\nhabía era árboles."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(4) [anim idle native]
  -- message_FacePositionOffset(2, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="And as for [CS:P]Crystal Cave[CR],\nyup yup, it was chock-full of crystals!", french="Quant à la [CS:P]Caverne Cristal[CR],\nelle était toute bourrée d'cristaux, pour sûr!", german="Und was die [CS:P]Kristallhöhle[CR]\nangeht, jawollja, sie war randvoll mit\nKristallen!", italian="Per quanto riguarda la [CS:P]Grotta di[CR]\n[CS:P]Cristallo[CR]... Ohibò, è davvero piena di cristalli!\nSissignore!", spanish="Y en cuanto a la [CS:P]Cueva Cristal[CR],\nsí, señor, ¡estaba repleta de cristales!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Mighty pretty cave, I tell you!", french="Une caverne qu'était vachement\nbelle, pardi!", german="Wenn das mal keine hübsche\nHöhle war!", italian="Davvero una bella grotta, se\nposso permettermi!", spanish="Una cueva muy vistosa, ya\nlo creo."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="It was so pretty that I just\ncouldn't help...[K]helping myself to a crystal.", french="C'était si beau que j'ai pas pu\nm'empêcher...[K] d'piquer un cristal.", german="Sie war so hübsch, dass ich\nnicht anders konnte,[K] als mir einen Kristall\nmitzunehmen.", italian="Non sono riuscito a resistere,\nohibò, e...[K] mi sono portato via un cristallo.", spanish="Era tan bonita que no pude\nevitarlo...[K] y me llevé un cristal."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.UpRight)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_bippa, 4) end)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.DownRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_bippa, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Ooh! When did you pick that up?", french="Ooh! Et on peut savoir quand\ntu as fait ça?", german="Uuh! Wann hast du den\ndenn aufgehoben?", italian=" Ooh! E quando è successo?", spanish=" Pero bueno, ¿cuándo lo cogiste?"})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="I was with you the whole time!\nI never noticed!", french="J'étais tout le temps avec toi!\nEt je n'ai rien vu!", german="Ich war die ganze Zeit bei dir!\nIch habe nichts gemerkt!", italian="Te lo sei portato dietro tutto\nquel tempo? Non me ne sono nemmeno accorta!", spanish="No me separé de ti ni un\nmomento y no me di cuenta de nada."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" [CS:N]Bidoof[CR]...", french=" [CS:N]Keunotor[CR]...", german=" [CS:N]Bidiza[CR]...", italian=" [CS:N]Bidoof[CR]...", spanish=" Desde luego, [CS:N]Bidoof[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_dagutorio, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Our objective was to find a\nTime Gear.", french="Notre objectif était de trouver\nun Rouage du Temps.", german="Unser Ziel war es, das Zahnrad\nder Zeit zu finden.", italian="Il nostro scopo era quello di\ntrovare l'Ingranaggio del Tempo.", spanish="Nuestro objetivo era encontrar\nun Engranaje del Tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="We all failed to achieve our\nobjective...", french=" Nous avons tous échoué...", german="Dieses Ziel zu erreichen, ist uns\nallen nicht gelungen.", italian="Non siamo riusciti a trovare\nniente...", spanish="Resulta que todos fracasamos\nen nuestro objetivo..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="But you had the nerve to collect\na souvenir, totally unrelated to the mission...", french="Mais toi, tu as quand même eu\nle culot de rapporter un petit souvenir, sans\naucun rapport avec la mission qui plus est...", german="Aber du hattest auch noch den\nNerv, ein Souvenir mitzunehmen, das mit der\nMission gar nichts zu tun hatte...", italian="... però ti è sembrato il caso di\nprendere un souvenir...", spanish="Pero tú vas y eres capaz de\nllevarte un recuerdo que no tiene nada\nque ver con la misión."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Who do you think you are?!", french=" Pour qui tu te prends?!", german=" Für wen hältst du dich?!?", italian=" Ma dove credi di essere?", spanish=" ¡¿Pero tú de qué vas?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Oof! Gosh, I'm sorry!", french=" Pfiou! Sapristi, j'm'excuse!", german=" Uff! Auweia, tut mir leid!", italian=" Puff! Ohibò, mi dispiace!", spanish=" ¡Huy! ¡Vaya, lo siento!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I just wanted a tiny treasure for\nmyself, that's all...", french="J'voulais juste un tout p'tit\ntrésor de rien du tout, rien d'plus...", german="Ich wollte einfach einen\nklitzekleinen Schatz haben, das ist alles...", italian="Volevo solo un piccolo tesoro,\ntutto per me...", spanish="Solo quería tener un pequeño\nrecuerdo, un tesoro para mí, nada más..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_yonowaaru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR], sir, I regret to say it.", french="Messire [CS:N]Noctunoir[CR], je suis\nau regret de vous annoncer...", german=" [CS:N]Zwirrfinst[CR], ich sage es ungern.", italian="Signor [CS:N]Dusknoir[CR], mi duole\nammetterlo...", spanish=" [CS:N]Dusknoir[CR], lamento decir esto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_pukurin, Direction.Left)
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  GROUND:EntTurn(npc_npc_diguda, Direction.UpRight)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  GROUND:EntTurn(npc_npc_guregguru, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Our search efforts ended\nfruitlessly.", french="... que nos recherches ont été\nvaines.", german="Unsere Anstrengungen haben\nkeine Früchte getragen.", italian="Le nostre ricerche non hanno\ndato alcun frutto.", spanish=" Nuestra búsqueda ha sido en vano."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Ah, this is vexing.", french="Diantre, voilà qui est fort\ncontrariant.", german=" Ah, wie ärgerlich.", italian=" Ah, ciò è davvero seccante.", spanish=" Vaya, esto es humillante."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I thought the search locations\nwe chose held promise.", french="Les lieux que nous avions\nsélectionnés me paraissaient toutefois\ndes plus prometteurs.", german="Ich habe geglaubt, wir hätten an\nvielversprechenden Orten gesucht.", italian="I posti che avevamo scelto\nsembravano davvero promettenti.", spanish="Creía que podríamos encontrar\nalgo en los lugares que había escogido."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I blame my lack of\nknowledge.[K] I am truly chastened.", french="Quel ignare je fais![K]\nCela me servira de leçon.", german="Ich gebe meinem eigenen\nUnwissen die Schuld.[K] Ich bin wirklich betrübt.", italian="È colpa della mia ignoranza.[K]\nSono sinceramente amareggiato.", spanish="Es culpa mía, por mi falta de\nconocimiento.[K] Os ruego que me disculpéis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="My goodness, no![K] You mustn't\nblame yourself!", french="Bien sûr que non![K] Ce n'est pas\nvotre faute!", german="Meine Güte, nein![K] Du darfst\ndir nicht selbst die Schuld geben!", italian="Ma cosa dice![K] Lei non ha certo\ncolpa!", spanish=" No, para nada.[K] No es culpa tuya."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Why, it was thanks only to your\nvast knowledge that we came up with our plan,\n[CS:N]Dusknoir[CR]!", french="C'est grâce à vous seul et à vos\nimmenses connaissances que nous avons pu\nmettre ce plan au point, [CS:N]Noctunoir[CR]!", german="Wir haben unseren Plan doch\ndeinem riesigen Wissen erst zu verdanken,\n[CS:N]Zwirrfinst[CR]!", italian="È solo grazie a lei, [CS:N]Dusknoir[CR] che\nsiamo riusciti ad escogitare questo piano!", spanish="Precisamente, gracias a lo que\nsabías hemos podido trazar este plan,\n[CS:N]Dusknoir[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Nonetheless, our efforts have\nended in failure. That's a fact.", french="Il n'en reste pas moins que nos\nrecherches se sont soldées par un échec.\nC'est un fait.", german="Nichtsdestotrotz waren unsere\nAnstrengungen umsonst. Das ist eine Tatsache.", italian="Resta il fatto che tutti i nostri\nsforzi sono stati vani.", spanish="Pese a ello, está bastante claro\nque nuestros intentos han fracasado."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="But being hard on ourselves\nis pointless.", french="Cela dit, il est vain de nous\naccabler de reproches.", german="Aber es ist sinnlos, uns selbst\ndie Schuld zu geben.", italian="Ma, avete ragione, non serve a\nnulla recriminare.", spanish="Pero lamentarnos no tiene\nsentido."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Let us reconsider our plan. We'll\ndevise a different strategy tomorrow!", french="Reconsidérons notre plan.\nNous concevrons une nouvelle stratégie\ndès demain!", german="Lasst uns den Plan überdenken.\nWir werden uns morgen eine andere Strategie\nüberlegen!", italian="Dobbiamo rivedere la strategia\nda adottare! Vedrete che domani troveremo\nuna strada migliore.", spanish="Vamos a reconsiderar nuestro\nplan. Mañana idearemos una estrategia\ndiferente."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Yes, let's do that! And may we\nfind success together!", french="Bien dit! Puissent nos efforts\ncommuns être couronnés de succès!", german="Ja, das werden wir! Auf dass\nwir das Problem gemeinsam lösen!", italian="Sì! Vedrete che insieme ce la\nfaremo!", spanish="Sí, eso haremos. ¡Y ojalá\ntengamos éxito!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.DownRight)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="That's how it stands, everyone!\nThat's enough work for today.", french="Voilà, tout le monde! Assez\ntravaillé pour aujourd'hui.", german="So sieht es aus, Pokémon!\nFür heute haben wir genug getan.", italian="Siamo tutti d'accordo, allora. Per\noggi basta così.", spanish="Ya conocéis la situación.\nBasta de trabajar por hoy."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Rest up! Prepare for tomorrow!", french="Reposez-vous et préparez-vous\npour demain!", german="Ruht euch aus! Bereitet euch auf\nmorgen vor!", italian=" Che domani sia un grande giorno!", spanish="¡A descansar!\nHay que prepararse para mañana."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: UNDERSTOOD!", french="[CS:N]Tous[CR]: COMPRIS!", german="[CS:N]Alle[CR]: VERSTANDEN!", italian="[CS:N]Tutti[CR]: SÌÌÌÌÌÌÌ!", spanish="[CS:N]Todos[CR]: ¡ENTENDIDO!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
