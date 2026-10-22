-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D39P41A/s22p0204.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D39P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(3) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_daakurai = SkySceneKit.spawn_npc("darkrai", 376, 336, Direction.Down, "NPC_DAAKURAI")
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  local npc_npc_parukia = SkySceneKit.spawn_npc("palkia", 424, 312, Direction.DownLeft, "NPC_PARUKIA")
  pcall(function() GROUND:CharSetEmote(npc_npc_parukia, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(8), 3, false) end) -- MovePositionOffset performer/caméra
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_parukia.Position; GROUND:MoveToPosition(npc_npc_parukia, p.X+(16), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaaaah!", french=" Ouaaah!", german=" Uaaaaah!", italian=" Waaaaah!", spanish=" ¡Aaaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaaaah!", french=" Ouaaah!", german=" Uaaaaah!", italian=" Aaaaaah!", spanish=" ¡Aaaaah!"})
  else
  SkySceneKit.say({english=" Waaaaah!", french=" Ouaaah!", german=" Uaaaaah!", italian=" Aaaaaah!", spanish=" ¡Aaaaah!"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_parukia, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="WHAT?! WHAT IS THIS?!\nWHO IS THIS?!", french="QUOI?! QU'EST-CE QUE C'EST?!\nQUI VA LA?!", german="WAS?!? WAS IST DAS HIER?!?\nWER IST DAS?!?", italian="COSA?! COSA SUCCEDE?!\nCHI C'È?!", spanish=" ¿QUÉ? ¿QUIÉN ERES TÚ?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5135) — id SE NDS sans portage PMDO identifié
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 328, 320, Direction.DownRight, "NPC_KURESERIA")
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(20)
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(15)
  -- GAP: se_Play(5126) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- SetAnimation(11) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_daakurai, "shock", 1) end)
  GROUND:MoveToPosition(npc_npc_daakurai, 372, 300, false, 2) -- SlidePositionMark (glissement)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GROUND:EntTurn(npc_npc_parukia, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(44) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Excellent! I was just in time!", french="Excellent! J'arrive juste\nà temps!", german="Hervorragend! Ich bin genau\nrechtzeitig gekommen!", italian="Eccellente! Sono arrivata appena\nin tempo!", spanish="¡Excelente! ¡Llego justo a\ntiempo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(43) [anim idle native]
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" Blast you...[K] [CS:N]Cresselia[CR]!", french=" Sois maudite, [K][CS:N]Cresselia[CR]!", german=" Zum Kuckuck mit dir...[K] [CS:N]Cresselia[CR]!", italian=" Maledetta [K][CS:N]Cresselia[CR]!", spanish=" Maldición...[K] ¡[CS:N]Cresselia[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="I've been foiled! Just as I was about to\ndispose of those meddlers once and for all!", french="Tous mes plans si savamment élaborés...\nen vain! Alors que j'étais à deux doigts de les\nrayer de la carte pour de bon!", german="Mein Plan wurde durchkreuzt! Gerade als\nich diese zwei Einmischer ein für alle Mal\nloswerden wollte!", italian="Mi hanno fermato! Proprio mentre\nstavo per sbarazzarmi di loro una volta\nper tutte!", spanish="¡Has frustrado mis planes! ¡Ahora que\niba a rematar el asunto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Please listen, [hero],\n[partner], and [CS:N]Palkia[CR].", french="[hero], [partner] et\n[CS:N]Palkia[CR], écoutez-moi, s'il vous plaît.", german="Hört bitte zu, [hero],\n[partner] und [CS:N]Palkia[CR].", italian="Ascoltatemi, [hero],\n[partner] e [CS:N]Palkia[CR].", spanish="Escuchadme bien, [hero],\n[partner] y [CS:N]Palkia[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_parukia, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="You have been misled all\nthis time!", french=" On vous a dupés de bout en bout!", german="Ihr seid die ganze Zeit an der\nNase herumgeführt worden!", italian="Siete stati ingannati per\ntutto questo tempo...", spanish=" ¡Habéis sido engañados!"})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" By [CS:N]Darkrai[CR] there!", french="Et le responsable, le voilà: c'est\n[CS:N]Darkrai[CR]!", german=" Von [CS:N]Darkrai[CR] dort!", italian=" Da [CS:N]Darkrai[CR]!", spanish=" ¡Por [CS:N]Darkrai[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_parukia, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" WHAT?!", french=" QUOI?!", german=" WAS?!?", italian=" COSA?!", spanish=" ¡¿QUÉ?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="The [CS:N]Cresselia[CR] you thought you\nknew until now...[K]was not me!", french="La [CS:N]Cresselia[CR] que vous croyiez\nconnaître jusque-là...[K] ce n'était pas moi!", german="Die [CS:N]Cresselia[CR], die ihr bis jetzt\nzu kennen glaubtet...[K] Das war nicht ich!", italian="La [CS:N]Cresselia[CR] che avete visto\nfinora...[K] non ero io!", spanish="La [CS:N]Cresselia[CR] que creíais\nconocer...[K] ¡no era yo!"})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="That false [CS:N]Cresselia[CR] was nothing\nmore than an illusion made by [CS:N]Darkrai[CR]!", french="Cette fausse [CS:N]Cresselia[CR] n'était\nqu'une illusion créée par [CS:N]Darkrai[CR]!", german="Die falsche [CS:N]Cresselia[CR] war nichts\nals eine Illusion von [CS:N]Darkrai[CR]!", italian="Quella finta [CS:N]Cresselia[CR] era solo\nun'illusione creata da [CS:N]Darkrai[CR]!", spanish="¡Esa falsa [CS:N]Cresselia[CR] era una\nilusión creada por [CS:N]Darkrai[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" It was merely a mockery of me!", french="Rien qu'une imposture,\nune mascarade!", german="Es war nur ein Trugbild\nmeiner selbst!", italian=" Una mera presa in giro!", spanish=" ¡Una farsa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_parukia, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" WHAT?!", french=" QUOI?!", german=" WAS?!?", italian=" COSA?!", spanish=" ¡¿QUÉ?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The [CS:N]Cresselia[CR] we knew up to\nnow...[K]was just a fake?!", french="La [CS:N]Cresselia[CR] que nous avons\nconnue jusque-là...[K] n'était qu'une imposture?!", german="Die [CS:N]Cresselia[CR], die wir bis jetzt\nkannten...[K] Das war nur eine Fälschung?!?", italian="La [CS:N]Cresselia[CR] che abbiamo\nincontrato finora...[K] era finta?!", spanish="La [CS:N]Cresselia[CR] con la que hemos\ntratado hasta ahora...[K] ¿era una impostora?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The [CS:N]Cresselia[CR] we knew up to\nnow...[K]was just a fake?!", french="La [CS:N]Cresselia[CR] que nous avons\nconnue jusque-là...[K] n'était qu'une imposture?!", german="Die [CS:N]Cresselia[CR], die wir bis jetzt\nkannten...[K] Das war nur eine Fälschung?!?", italian="La [CS:N]Cresselia[CR] che abbiamo\nincontrato finora...[K] era finta?!", spanish="La [CS:N]Cresselia[CR] con la que hemos\ntratado hasta ahora...[K] ¿era una impostora?"})
  else
  SkySceneKit.say({english="The [CS:N]Cresselia[CR] we knew up to\nnow...[K]was just a fake?!", french="La [CS:N]Cresselia[CR] que nous avons\nconnue jusque-là...[K] n'était qu'une imposture?!", german="Die [CS:N]Cresselia[CR], die wir bis jetzt\nkannten...[K] Das war nur eine Fälschung?!?", italian="La [CS:N]Cresselia[CR] che abbiamo\nincontrato finora...[K] era finta?!", spanish="La [CS:N]Cresselia[CR] con la que hemos\ntratado hasta ahora...[K] ¿era una impostora?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_parukia, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" [CS:N]Darkrai[CR]!", french=" [CS:N]Darkrai[CR]!", german=" [CS:N]Darkrai[CR]!", italian=" [CS:N]Darkrai[CR]!", spanish=" ¡[CS:N]Darkrai[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Using an illusory duplicate of me\nto deceive others...[K]is so typical of you!", french="Te servir d'un pantin à mon\nimage pour duper les autres...[K] voilà qui ne\nm'étonne pas de toi!", german="Eine Kopie von mir in Form einer\nIllusion zu verwenden, um andere zu\ntäuschen...[K] Das ist so typisch für dich!", italian="Hai usato un'illusione con le mie\nsembianze per ingannare gli altri...[K] Cos'altro\nci si poteva aspettare da te?", spanish="Usar un duplicado de mí para\nengañar a los demás...[K] ¡es típico de ti!"})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="But you usually never bring your\nactual self out of hiding![K] You normally operate\nunder cover of darkness!", french="Mais tu n'as pas pour habitude\nde te montrer au grand jour![K] Tu es plutôt\ndu genre à tirer les ficelles dans l'ombre!", german="Sonst bringst du dein wahres\nSelbst nicht zum Vorschein![K] Normalerweise\nagierst du im Schutz der Dunkelheit!", italian="Ma di solito non ti mostri mai![K]\nTi piace agire nell'oscurità!", spanish="¡Aunque, normalmente, no te\nmuestras en persona![K] ¡Trabajas al amparo\nde la oscuridad!"})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="That you'd personally emerge\nfrom the shadows to dispose of these two...", french="Que tu te montres en personne\npour éliminer ces deux-là...", german="Dass du persönlich aus dem\nSchatten hervorkommst, um die beiden zu\nbeseitigen...", italian="Il fatto che tu sia emerso\ndall'oscurità per occuparti di questi due\nPokémon...", spanish="Que hayas salido de entre las\nsombras para acabar con estos Pokémon..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" That is so very unlike you!", french="... voilà qui est très étonnant\nde ta part!", german="Das sieht dir überhaupt nicht\nähnlich!", italian=" ... non è per niente da te!", spanish=" ¡No es propio de ti!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" You two, behind [CS:N]Cresselia[CR]...", french="Vous deux, qui vous cachez\nderrière [CS:N]Cresselia[CR]...", german=" Ihr beide, hinter [CS:N]Cresselia[CR]...", italian=" Voi due, dietro [CS:N]Cresselia[CR]...", spanish="Eh, parejita. No os escondáis\ndetrás de [CS:N]Cresselia[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-what, us?", french=" Q-qui, nous?", german=" W-was, wir?", italian=" C-Chi, noi?", spanish=" ¿Qui... quién, nosotros? "})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-what, us?", french=" Q-qui, nous?", german=" W-was, wir?", italian=" C-Chi, noi?", spanish=" ¿Qui... quién, nosotros? "})
  else
  SkySceneKit.say({english=" Wh-what, us?", french=" Q-qui, nous?", german=" W-was, wir?", italian=" C-Chi, noi?", spanish=" ¿Qui... quién, nosotros? "})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" Correct.[K] Pay close attention.", french=" Exact.[K] Faites bien attention.", german=" Korrekt.[K] Passt gut auf.", italian=" Esatto.[K] Fate molta attenzione.", spanish=" Quién si no.[K] Prestad atención."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="Now, the one truly responsible\nfor exploiting the space distortion...?[K]\nFor shrouding the world in nightmare...?", french="L'unique responsable de la\ndistorsion spatiale...[K] grâce à qui ce cauchemar\na recouvert le monde tel un linceul...", german="Also, der einzig Verantwortliche\nfür die Ausweitung der Raumverzerrung...[K]\nFür die Einhüllung der Welt in einen Albtraum...", italian="L'unico veramente responsabile\nper la distorsione del tempo?[K] Per aver\navvolto il mondo in un incubo?", spanish="El verdadero responsable de\nla deformación del espacio...[K] y de intentar\natrapar al mundo en una pesadilla..."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" It is my doing.[K] Mine alone.", french=" ... c'est moi.[K] Et moi seul.", german="Das bin ich! Es ist mein Werk.[K]\nMeins allein.", italian=" Sono io.[K] È tutto merito mio.", spanish="Soy yo.[K] Todo es obra mía. Solo\nmía."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_parukia, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?![K] Wh-what did you say?!", french=" Hein?![K] Tu peux répéter?!", german="Was?!?[K] W-was hast du\ngesagt?!?", italian=" Eh?![K] C-Cosa hai detto?!", spanish=" ¡¿Eh?![K] ¡¿Qué has dicho?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?![K] What did you say?!", french=" Hein?![K] Tu peux répéter?!", german="Was?!?[K] W-was hast du\ngesagt?!?", italian=" Come?![K] Cosa hai detto?!", spanish=" ¡¿Eh?![K] ¡¿Qué has dicho?!"})
  else
  SkySceneKit.say({english=" What?![K] What did you say?!", french=" Hein?![K] Tu peux répéter?!", german="Was?!?[K] W-was hast du\ngesagt?!?", italian=" Come?![K] Cosa hai detto?!", spanish=" ¡¿Eh?![K] ¡¿Qué has dicho?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="You are more than welcome to\ntry and stop me.", french="Tentez donc de m'arrêter, si\nvous en avez le pouvoir.", german="Ihr seid herzlich dazu\neingeladen zu versuchen, mich aufzuhalten.", italian="Potete benissimo provare\na fermarmi.", spanish="Ahora intentad detenerme si\npodéis."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" Come to me in the [CS:P]Dark Crater[CR].", french="Rendez-vous au [CS:P]Cratère\nObscur[CR].", german="Kommt zu mir in den\n[CS:P]Dunkelkrater[CR].", italian=" Venite al [CS:P]Cratere Oscuro[CR].", spanish="Venid a buscarme. Estaré\nen el [CS:P]Cráter Oscuro[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="You're not getting away,\n[CS:N]Darkrai[CR]!", french="Tu ne t'en tireras pas comme ça,\n[CS:N]Darkrai[CR]!", german="Du kommst nicht davon,\n[CS:N]Darkrai[CR]!", italian=" Non ti farò scappare, [CS:N]Darkrai[CR]!", spanish=" ¡No escaparás, [CS:N]Darkrai[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_kureseria.Position; GROUND:MoveToPosition(npc_npc_kureseria, p.X+(0), p.Y+(-32), false, 2) end
  GAME:WaitFrames(15)
  -- GAP: se_Play(7183) — id SE NDS sans portage PMDO identifié
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- supervision_Acting(4) [neutre/état moteur]
  GAME:WaitFrames(10)
  GAME:FadeOut(false, 15)
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(40)
  GAME:FadeIn(15)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D39P41A1_90) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_parukia, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]D-Darkrai[CR] vanished?!", french=" [CS:N]D-Darkrai[CR] a disparu?!", german=" [CS:N]D-Darkrai[CR] ist verschwunden?!?", italian=" [CS:N]D-Darkrai[CR] è scomparso?!", spanish=" [CS:N]Darkrai[CR]... ¿Se ha esfumado?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]D-Darkrai[CR] vanished?!", french=" [CS:N]D-Darkrai[CR] a disparu?!", german=" [CS:N]D-Darkrai[CR] ist verschwunden?!?", italian=" [CS:N]D-Darkrai[CR] è scomparso?!", spanish=" [CS:N]Darkrai[CR]... ¿Se ha esfumado?"})
  else
  SkySceneKit.say({english=" [CS:N]D-Darkrai[CR] vanished?!", french=" [CS:N]D-Darkrai[CR] a disparu?!", german=" [CS:N]D-Darkrai[CR] ist verschwunden?!?", italian=" [CS:N]D-Darkrai[CR] è scomparso?!", spanish=" [CS:N]Darkrai[CR]... ¿Se ha esfumado?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end) -- message_SetActor(ACTOR_NPC_DAAKURAI)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" You cannot catch me, [CS:N]Cresselia[CR]...", french="Tu ne peux m'attraper,\n[CS:N]Cresselia[CR].", german="Du fängst mich nicht,\n[CS:N]Cresselia[CR]...", italian=" Non puoi prendermi, [CS:N]Cresselia[CR].", spanish="[CS:N]Cresselia[CR], nunca lograrás\natraparme..."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" ...Not ever.", french=" Jamais tu ne le pourras.", german=" Niemals.", italian=" Non ci riuscirai mai.", spanish=" Nunca."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="You two...[K] I shall be waiting in\nthe [CS:P]Dark Crater[CR].", french="Vous deux...[K] je vous attendrai\nau [CS:P]Cratère Obscur[CR].", german="Ihr zwei.[K] Ich werde im\n[CS:P]Dunkelkrater[CR] warten.", italian="Voi due...[K] Vi aspetto al [CS:P]Cratere[CR]\n[CS:P]Oscuro[CR].", spanish="Pareja...[K] Os estaré esperando en\nel [CS:P]Cráter Oscuro[CR]."})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[K][CS:P]Dark[CR]...[K] [CS:P]Crater[CR]...", french=" ...[K] Le [CS:P]Cratère[CR]...[K] [CS:P]Obscur[CR]...", german=" ...[K][CS:P]Dunkelkrater[CR]...", italian=" ...[K] [CS:P]Cratere[CR]...[K] [CS:P]Oscuro[CR]...", spanish=" En el...[K] [CS:P]Cráter[CR]...[K] [CS:P]Oscuro[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[K][CS:P]Dark[CR]...[K] [CS:P]Crater[CR]...", french=" ...[K] Le [CS:P]Cratère[CR]...[K] [CS:P]Obscur[CR]...", german=" ...[K][CS:P]Dunkelkrater[CR]...", italian=" ...[K] [CS:P]Cratere[CR]...[K] [CS:P]Oscuro[CR]...", spanish=" En el...[K] [CS:P]Cráter[CR]...[K] [CS:P]Oscuro[CR]..."})
  else
  SkySceneKit.say({english=" ...[K][CS:P]Dark[CR]...[K] [CS:P]Crater[CR]...", french=" ...[K] Le [CS:P]Cratère[CR]...[K] [CS:P]Obscur[CR]...", german=" ...[K][CS:P]Dunkelkrater[CR]...", italian=" ...[K] [CS:P]Cratere[CR]...[K] [CS:P]Oscuro[CR]...", spanish=" En el...[K] [CS:P]Cráter[CR]...[K] [CS:P]Oscuro[CR]..."})
  end
  -- message_Close
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(30)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT = 26 -- $COMPULSORY_SAVE_POINT = 26 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
