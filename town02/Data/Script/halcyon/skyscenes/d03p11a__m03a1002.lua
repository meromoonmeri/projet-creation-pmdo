-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D03P11A/m03a1002.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D03P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_jibakoiru = SkySceneKit.spawn_npc("magnezone", 280, 216, Direction.Down, "NPC_JIBAKOIRU")
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! I am [CS:N]Magnezone[CR], the\nprimary officer in this region! ZZZT!", french="ZZZT! Je suis [CS:N]Magnézone[CR],\nle shérif de la région! ZZZT!", german="ZZZT! Ich bin [CS:N]Magnezone[CR], der\nOberwachtmeister der Gegend! ZZZT!", italian="ZZZT! Sono [CS:N]Magnezone[CR],\nil Commissario di questa regione! ZZZT!", spanish="¡Bzz! ¡Soy [CS:N]Magnezone[CR], el\nrepresentante de la ley en esta región! ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english=" ZZZT! Thanks to you...", french=" ZZZT! Grâce à vous...", german=" ZZZT! Vielen Dank!", italian=" ZZZT! Grazie a voi...", spanish=" ¡Bzz! Gracias a vuestro equipo..."})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="We have been able to arrest a\nwanted outlaw! ZZZT!", french="Nous avons pu arrêter un\ncriminel recherché! ZZZT!", german="Dank euch konnten wir einen\ngesuchten Verbrecher fassen! ZZZT!", italian="Siamo riusciti ad arrestare un\nricercato! ZZZT!", spanish="¡Hemos podido arrestar\na un peligroso malhechor! ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! We owe you great thanks\nfor your cooperation! ZZZT!", french="ZZZT! Merci beaucoup de votre\ncoopération! ZZZT!", german="ZZZT! Wir sind euch für eure\nMitarbeit zu großem Dank verpflichtet! ZZZT!", italian="ZZZT! Grazie mille per la vostra\ncollaborazione! ZZZT!", spanish="¡Bzz! ¡Estamos muy agradecidos\npor vuestra colaboración! ¡Bzz!"})
  -- message_Close
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6418) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_jibakoiru, "happy", 1) end)
  local npc_npc_koiru = SkySceneKit.spawn_npc("magnemite", 296, 192, Direction.Down, "NPC_KOIRU")
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru, "happy", 1) end)
  local npc_npc_koiru2 = SkySceneKit.spawn_npc("magnemite", 264, 192, Direction.Down, "NPC_KOIRU2")
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru2, "happy", 1) end)
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_jibakoiru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru2, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! We will send the reward\nto your guild. Thank you again! ZZZT!", french="ZZZT! Nous remettrons la\nrécompense à votre Guilde. Merci\nencore! ZZZT!", german="ZZZT! Wir lassen die Belohnung\neurer Gilde zukommen. Nochmals danke! ZZZT!", italian="ZZZT! Manderemo la ricompensa\nalla Gilda. Grazie ancora! ZZZT!", spanish="¡Bzz! Enviaremos la recompensa\na vuestro [CS:N]Pokégremio[CR].\n¡Muchísimas gracias por todo! ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_suriipu = SkySceneKit.spawn_npc("drowzee", 280, 192, Direction.Down, "NPC_SURIIPU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_jibakoiru, npc_npc_suriipu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english=" ZZZT! Now come with us! ZZZT!", french=" ZZZT! Viens avec nous! ZZZT!", german=" ZZZT! Jetzt komm mit! ZZZT!", italian="ZZZT! Adesso vieni\ncon noi! ZZZT!", spanish="¡Bzz! Ahora, ¡ven con nosotros!\n¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_suriipu, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Awww...", french=" Aïe...", german=" Grmpf...", italian=" Awww...", spanish=" ¡Ay!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_jibakoiru.Position; GROUND:MoveToPosition(npc_npc_jibakoiru, p.X+(200), p.Y+(0), false, 2) end
  GAME:WaitFrames(15)
  GROUND:EntTurn(partner, Direction.UpRight)
  local npc_npc_ruriri = SkySceneKit.spawn_npc("azurill", 280, 256, Direction.Up, "NPC_RURIRI")
  GROUND:EntTurn(npc_npc_ruriri, Direction.UpRight)
  GROUND:EntTurn(npc_npc_koiru, Direction.Right)
  do local p=npc_npc_suriipu.Position; GROUND:MoveToPosition(npc_npc_suriipu, p.X+(16), p.Y+(16), false, 2) end
  do local p=npc_npc_koiru2.Position; GROUND:MoveToPosition(npc_npc_koiru2, p.X+(32), p.Y+(32), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(npc_npc_suriipu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(npc_npc_ruriri, Direction.Right)
  do local p=npc_npc_koiru.Position; GROUND:MoveToPosition(npc_npc_koiru, p.X+(200), p.Y+(0), false, 2) end
  do local p=npc_npc_suriipu.Position; GROUND:MoveToPosition(npc_npc_suriipu, p.X+(200), p.Y+(0), false, 2) end
  do local p=npc_npc_koiru2.Position; GROUND:MoveToPosition(npc_npc_koiru2, p.X+(200), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  local npc_npc_mariru = SkySceneKit.spawn_npc("marill", 280, 336, Direction.Up, "NPC_MARIRU")
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end) -- message_SetActor(ACTOR_NPC_MARIRU)
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" [CS:N]Azurill[CR]!", french=" [CS:N]Azurill[CR]!", german=" [CS:N]Azurill[CR]!", italian=" [CS:N]Azurill[CR]!", spanish=" ¡[CS:N]Azurill[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_ruriri, npc_npc_mariru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_mariru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_mariru, 4) end)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(80), 53, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" [CS:N]Marill[CR]!", french=" [CS:N]Marill[CR]!", german=" [CS:N]Marill[CR]!", italian=" [CS:N]Marill[CR]!", spanish=" ¡[CS:N]Marill[CR]!"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_mariru, 276, 292, false, 2)
  GROUND:MoveToPosition(npc_npc_ruriri, 276, 276, false, 2)
  pcall(function() GAME:MoveCamera(280, 276, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBGM("Heartwarming.ogg", true) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "sweating", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Waaaaah!", french=" Ouiiin!", german=" Waaaaah!", italian=" Waaaaah!", spanish=" ¡Buaaa!"})
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" [CS:N]Marill[CR]![K] It was so scary!", french=" [CS:N]Marill[CR]![K] J'ai eu si peur!", german=" [CS:N]Marill[CR]![K] Ich hatte solche Angst!", italian=" [CS:N]Marill[CR]![K] Ho avuto tanta paura!", spanish="¡[CS:N]Marill[CR]![K]\n¡Qué miedo he pasado!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "sweating", 1) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" You OK, [CS:N]Azurill[CR]?[K] Are you hurt?", french=" Ça va, [CS:N]Azurill[CR]?[K] Tu es blessé?", german="Alles okay, [CS:N]Azurill[CR]?[K] Bist du\nverletzt?", italian=" Stai bene, [CS:N]Azurill[CR]?[K] Sei ferito?", spanish="¿Estás bien, [CS:N]Azurill[CR]?[K]\n¿No te has hecho daño?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(8), false, 2) end
  GAME:WaitFrames(15)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="He's fine. The little guy's not\nhurt at all.", french="Il va bien. Le petit bonhomme\nest sain et sauf.", german="Es geht ihm gut. Der kleine Kerl\nist nicht verletzt.", italian="Sta bene. Non ha neanche un\ngraffio.", spanish="Está bien. No tiene ni un\nrasguño."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="He's fine. The little guy hasn't\nbeen harmed in any way.", french="Il va bien. Le petit bonhomme\nest sain et sauf.", german="Es geht ihm gut. Der kleine Kerl\nist unversehrt.", italian="Sta bene. Non ha neanche un\ngraffio.", spanish="Está bien. No tiene ni un\nrasguño."})
  else
  SkySceneKit.say({english="He's fine. The little guy's not\nhurt in any way.", french="Il va bien. Le petit bonhomme\nest sain et sauf.", german="Es geht ihm gut. Der kleine Kerl\nist unversehrt.", italian="Sta bene. Non ha neanche un\ngraffio.", spanish="Está bien. No tiene ni un\nrasguño."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Really?", french=" Vraiment?", german=" Wirklich?", italian=" Davvero?", spanish=" ¿De verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" That's a relief!", french=" Ouf, je suis soulagé!", german=" Ich bin so erleichtert!", italian=" Per fortuna!", spanish=" ¡Menos mal!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_mariru, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Oh, [CS:N]Azurill[CR]...[K][CS:N]Azurill[CR]...", french=" Oh, [CS:N]Azurill[CR]... [K][CS:N]Azurill[CR]...", german=" Oh, [CS:N]Azurill[CR]...[K] [CS:N]Azurill[CR]...", italian=" Oh, [CS:N]Azurill[CR]...[K] [CS:N]Azurill[CR]...", spanish=" [CS:N]Azurill[CR]. [K]¡[CS:N]Azurill[CR]!"})
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "sweating", 1) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'm really glad for you guys.", french=" Je suis content pour vous.", german="Ich freue mich wirklich für\neuch zwei.", italian=" Sono davvero felice per voi.", spanish=" Me alegro mucho por vosotros."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I'm glad you kids are happy!", french=" Je suis content pour vous.", german=" Ich freue mich so für euch!", italian=" Sono davvero felice per voi.", spanish=" Me alegro mucho por los dos."})
  else
  SkySceneKit.say({english=" I'm truly happy for you two!", french=" Je suis contente pour vous.", german="Ich freue mich wirklich für\neuch beide!", italian=" Sono davvero felice per voi.", spanish=" ¡Me alegro mucho por ambos!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_mariru.Position; GROUND:MoveToPosition(npc_npc_mariru, p.X+(-16), p.Y+(-16), false, 2) end
  do local p=npc_npc_ruriri.Position; GROUND:MoveToPosition(npc_npc_ruriri, p.X+(16), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_mariru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_ruriri, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="You did this all for us,\n[partner] and [hero].", french="Vous avez fait tout ça pour\nnous, [partner] et [hero].", german="Ihr habt das nur für uns getan,\n[partner] und [hero].", italian="Avete fatto tutto questo solo per\nnoi, [partner] e [hero].", spanish="[partner] y [hero],\nno tenemos palabras."})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="We won't forget what you did\nfor us.[K] Thank you so much.", french="Nous n'oublierons jamais votre\ngentillesse. Merci beaucoup.", german="Wir werden das niemals\nvergessen.[K] Vielen, vielen Dank.", italian="Non lo dimenticheremo.[K]\nGrazie mille.", spanish="No olvidaremos lo que habéis\nhecho por nosotros.[K] Muchísimas gracias."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, npc_npc_ruriri, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_ruriri, npc_npc_mariru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Come on, [CS:N]Azurill[CR]. You too.", french=" Allez, [CS:N]Azurill[CR]. Toi aussi.", german=" Komm schon, [CS:N]Azurill[CR]. Jetzt du.", italian="Forza, [CS:N]Azurill[CR]. Ringrazia anche\ntu.", spanish=" Venga, [CS:N]Azurill[CR]. Díselo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english=" Yup...", french=" Ouais...", german=" Ja...", italian=" Sì...", spanish=" Sí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_ruriri, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_mariru, Direction.Up)
  pcall(function() UI:SetSpeaker(npc_npc_ruriri) end)
  SkySceneKit.say({english="Thank you very much![K] Thank you\nfor rescuing me!", french="Merci mille fois![K] Merci de\nm'avoir sauvé!", german="Vielen, vielen Dank![K] Danke, dass\nihr mich gerettet habt!", italian="Grazie![K] Grazie per\navermi salvato!", spanish="¡Muchísimas gracias![K]\n¡Gracias por rescatarme!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english=" Really...[K] Really, thank you!", french=" Vraiment...[K] merci!", german=" Wirklich![K] Vielen, vielen Dank!", italian=" Davvero...[K] Grazie di cuore!", spanish=" De verdad...[K] ¡Muchas gracias!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayFanfare("Fanfare/Note") end) -- me_Play(7) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="[CN]The Exploration Team Federation\n[CN]has sent a message...[W:30]", french="[CN]La Fédération des Equipes d'Exploration\n[CN]a envoyé un message...[W:30]", german="[CN]Der Erkundungsteamverband\n[CN]hat eine Nachricht geschickt.[W:30]", italian="[CN]Arriva un messaggio della Federazione\n[CN]Squadre d'Esplorazione![W:30]", spanish="[CN]La Federación de Exploradores\n[CN]ha enviado un mensaje...[W:30]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayFanfare("Fanfare/LevelUp") end) -- me_Play(1) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="[CN][hero]'s team was rewarded\n[CN]with an enlarged Treasure Bag![W:100]", french="[CN]L'équipe de [hero] est récompensée\n[CN]par un Sac à Trésor plus grand![W:100]", german="[CN]Das Team von [hero] erhält zur\n[CN]Belohnung einen größeren Schatzbeutel![W:100]", italian="[CN]La squadra di [hero] riceve in premio\n[CN]una Sacca dei tesori più capiente![W:100]", spanish="[CN]¡El equipo de [hero] fue recompensado\n[CN]con una Bolsa mayor![W:100]"})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="[CN]You can now carry more\n[CN]items than you could before!", french="[CN]Dorénavant, vous pourrez\n[CN]transporter plus d'objets!", german="[CN]Du kannst jetzt mehr\n[CN]Items als bisher tragen!", italian="[CN]Adesso potrete trasportare molti più\n[CN]strumenti di prima!", spanish="[CN]¡Ahora puedes llevar\n[CN]más objetos que antes!"})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="[CN]Wait...[K]\n[CN]There's one more message.", french="[CN]Tiens...[K]\n[CN]Il y a un autre message.", german="[CN]Augenblick...[K]\n[CN]Da ist noch eine Nachricht.", italian="[CN]Un momento...[K]\n[CN]C'è un altro messaggio.", spanish="[CN]Espera...[K]\n[CN]Hay un mensaje más."})
  -- message_Close
  -- back_SetGround(LEVEL_P15P01A) [neutre/état moteur]
  -- supervision_Acting(10) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- back_SetBackEffect(4) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayFanfare("Fanfare/JoinTeam") end) -- me_Play(5) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="[CN]The Special Episode\n[CN]\"Bidoof's Wish\"\n[CN]has been unlocked![W:90]", french="[CN]L'Episode Spécial\n[CN]\"Le vœu de Keunotor\"\n[CN]est maintenant disponible![W:90]", german="[CN]Die Bonusepisode\n[CN][F:S2]Der Wunsch von Bidiza[F:E2]\n[CN]wurde freigeschaltet![W:90]", italian="[CN]L'episodio speciale\n[CN]\"Il desiderio di Bidoof\"\n[CN]è ora disponibile![W:90]", spanish="[CN]Se ha desbloqueado\n[CN]el capítulo especial\n[CN]\"El deseo de Bidoof\".[W:90]"})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="[CN]To play a Special Episode,\n[CN]select it from the Episode List\n[CN]on the Top Menu.", french="[CN]Pour jouer à un Episode Spécial,\n[CN]sélectionnez-le dans la Liste des épisodes\n[CN]à partir du menu principal.", german="[CN]Um eine Bonusepisode zu spielen,\n[CN]wähle sie in der Episodenliste\n[CN]im Hauptmenü aus.", italian="[CN]Per giocare a un episodio speciale,\n[CN]selezionalo dalla lista episodi\n[CN]nel menu principale.", spanish="[CN]Para jugar a un capítulo especial,\n[CN]elígelo en la lista de capítulos\n[CN]del menú principal."})
  pcall(function() UI:SetSpeaker(npc_npc_mariru) end)
  SkySceneKit.say({english="[CN]If you would like to play the Special Episode,\n[CN]save your adventure progress, and\n[CN]return to the Top Menu.", french="[CN]Si vous souhaitez jouer à cet Episode Spécial,\n[CN]sauvegardez d'abord votre aventure\n[CN]puis retournez au menu principal.", german="[CN]Wenn du eine Bonusepisode spielen\n[CN]möchtest, speichere deinen Spielstand\n[CN]und kehre zum Hauptmenü zurück.", italian="[CN]Se vuoi giocare all'episodio speciale,\n[CN]salva i progressi della tua avventura\n[CN]e torna al menu principale.", spanish="[CN]Si quieres jugar al capítulo especial,\n[CN]guarda tu progreso y\n[CN]vuelve al menú principal."})
  -- message_Close
  GAME:FadeOut(false, 30)
  -- back_SetBackEffect(5) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
