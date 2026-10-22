-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/s22p0305.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_T01P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:N]Darkrai[CR] told us to go to the [CS:P]Dark Crater[CR].)", french="([CS:N]Darkrai[CR] nous a lancé un défi: le rejoindre\nau [CS:P]Cratère Obscur[CR].)", german="([CS:N]Darkrai[CR] rief uns zum [CS:P]Dunkelkrater[CR].)", italian="([CS:N]Darkrai[CR] ci ha detto di andare al\n[CS:P]Cratere Oscuro[CR].)", spanish="([CS:N]Darkrai[CR] nos desafió a que fuéramos al\n[CS:P]Cráter Oscuro[CR].)"})
  else
  SkySceneKit.say({english="([CS:N]Darkrai[CR] told us to go to the [CS:P]Dark Crater[CR].)", french="([CS:N]Darkrai[CR] nous a lancé un défi: le rejoindre\nau [CS:P]Cratère Obscur[CR].)", german="([CS:N]Darkrai[CR] rief uns zum [CS:P]Dunkelkrater[CR].)", italian="([CS:N]Darkrai[CR] ci ha detto di andare al\n[CS:P]Cratere Oscuro[CR].)", spanish="([CS:N]Darkrai[CR] nos desafió a que fuéramos al\n[CS:P]Cráter Oscuro[CR].)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(And that he would be waiting for us.)", french="(Il nous y attend.)", german="(Es sagte, es würde dort auf uns warten.)", italian="(E che ci avrebbe aspettato.)", spanish="(Dijo que allí estaría esperándonos.)"})
  else
  SkySceneKit.say({english="(And that he would be waiting for us.)", french="(Il nous y attend.)", german="(Es sagte, es würde dort auf uns warten.)", italian="(E che ci avrebbe aspettato.)", spanish="(Dijo que allí estaría esperándonos.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, -2) [neutre/état moteur]
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 320, 184, Direction.Right, "NPC_PUKURIN")
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Cresselia[CR], you believe that he\ndemanded [partner] and [hero] come\nto him for a reason, don't you?", french="[CS:N]Cresselia[CR], tu crois que s'il a\nlancé ce défi à [partner] et [hero],\nc'est dans un but précis, n'est-ce pas?", german="[CS:N]Cresselia[CR], du glaubst, dass es\n[partner] und [hero] aus einem\nbestimmten Grund zu sich verlangt?", italian="[CS:N]Cresselia[CR], credi che abbia\nchiesto a [partner] e a [hero] di\nandare da lui per un motivo ben preciso, vero?", spanish="[CS:N]Cresselia[CR], tú crees que les dijo\neso a [partner] y [hero] por alguna\nrazón concreta, ¿verdad?"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Do you believe that it's a trap?", french=" Tu crois que c'est un piège?", german=" Glaubst du, es ist eine Falle?", italian=" Credi che sia un tranello?", spanish="¿Crees que se trata de una\ntrampa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 384, 176, Direction.DownLeft, "NPC_KURESERIA")
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Yes.[K] It's a trap. Without a doubt.", french="Oui.[K] C'en est un, sans l'ombre\nd'un doute.", german="Ja.[K] Es ist eine Falle. Ohne\nZweifel.", italian=" Sì.[K] È sicuramente una trappola.", spanish=" Sí.[K] Es una trampa, seguro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(30)
  -- SetAnimation(71) [anim idle native]
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: BGM BGM_THROUGH_THE_SEA_OF_TIME non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It doesn't matter if it's a trap\nor not!", french="Peu importe que ce soit un piège\nou pas!", german="Es macht keinen Unterschied,\nob Falle oder nicht!", italian=" Non importa se è una trappola!", spanish=" ¡Da igual que sea una trampa!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It doesn't matter if it's a trap\nor not!", french="Peu importe que ce soit un piège\nou pas!", german="Es macht keinen Unterschied,\nob Falle oder nicht!", italian=" Non importa se è una trappola!", spanish=" ¡Da igual que sea una trampa!"})
  else
  SkySceneKit.say({english="It doesn't matter if it's a trap\nor not!", french="Peu importe que ce soit un piège\nou pas!", german="Es macht keinen Unterschied,\nob Falle oder nicht!", italian=" Non importa se è una trappola!", spanish=" ¡Da igual que sea una trampa!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If we don't stop [CS:N]Darkrai[CR], the\nwhole world will be smothered by darkness.", french="Si on n'arrête pas [CS:N]Darkrai[CR],\nl'ombre engloutira le monde entier.", german="Wenn wir [CS:N]Darkrai[CR] nicht stoppen,\nverschleiert Dunkelheit bald die ganze Welt.", italian="Se non fermiamo [CS:N]Darkrai[CR], il\nmondo sarà inghiottito dall'oscurità.", spanish="Si no le paramos los pies a\n[CS:N]Darkrai[CR], el mundo entero quedará\nsumido en la oscuridad."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If we don't stop [CS:N]Darkrai[CR], he'll\nsmother the whole world with darkness.", french="Si on n'arrête pas [CS:N]Darkrai[CR],\nl'ombre engloutira le monde entier.", german="Wenn wir [CS:N]Darkrai[CR] nicht stoppen,\nverschleiert Dunkelheit bald die ganze Welt.", italian="Se non fermiamo [CS:N]Darkrai[CR], il\nmondo sarà inghiottito dall'oscurità.", spanish="Si no le paramos los pies a\n[CS:N]Darkrai[CR], el mundo entero quedará\nsumido en la oscuridad."})
  else
  SkySceneKit.say({english="If we don't stop [CS:N]Darkrai[CR], he'll\nsmother the whole world with darkness.", french="Si on n'arrête pas [CS:N]Darkrai[CR],\nl'ombre engloutira le monde entier.", german="Wenn wir [CS:N]Darkrai[CR] nicht stoppen,\nverschleiert Dunkelheit bald die ganze Welt.", italian="Se non fermiamo [CS:N]Darkrai[CR], il\nmondo sarà inghiottito dall'oscurità.", spanish="Si no le paramos los pies a\n[CS:N]Darkrai[CR], el mundo entero quedará\nsumido en la oscuridad."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We have to do something!", french=" Il faut faire quelque chose!", german=" Wir müssen etwas unternehmen!", italian=" Dobbiamo fare qualcosa!", spanish=" ¡Tenemos que hacer algo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We have to do something!", french=" Il faut faire quelque chose!", german=" Wir müssen etwas unternehmen!", italian=" Dobbiamo fare qualcosa!", spanish=" ¡Tenemos que hacer algo!"})
  else
  SkySceneKit.say({english=" We have to do something!", french=" Il faut faire quelque chose!", german=" Wir müssen etwas unternehmen!", italian=" Dobbiamo fare qualcosa!", spanish=" ¡Tenemos que hacer algo!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We're going to the [CS:P]Dark Crater[CR]!", french=" On va au [CS:P]Cratère Obscur[CR]!", german=" Wir gehen zum [CS:P]Dunkelkrater[CR]!", italian="Vogliamo andare al [CS:P]Cratere[CR]\n[CS:P]Oscuro[CR]!", spanish=" ¡Nos vamos al [CS:P]Cráter Oscuro[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We're going to the [CS:P]Dark Crater[CR]!", french=" On va au [CS:P]Cratère Obscur[CR]!", german=" Wir gehen zum [CS:P]Dunkelkrater[CR]!", italian="Vogliamo andare al [CS:P]Cratere[CR]\n[CS:P]Oscuro[CR]!", spanish=" ¡Nos vamos al [CS:P]Cráter Oscuro[CR]!"})
  else
  SkySceneKit.say({english=" We're going to the [CS:P]Dark Crater[CR]!", french=" On va au [CS:P]Cratère Obscur[CR]!", german=" Wir gehen zum [CS:P]Dunkelkrater[CR]!", italian="Vogliamo andare al [CS:P]Cratere[CR]\n[CS:P]Oscuro[CR]!", spanish=" ¡Nos vamos al [CS:P]Cráter Oscuro[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" ...OK.[K] I respect your decision.", french="... D'accord.[K] Je respecte votre\ndécision.", german="...Okay.[K] Ich respektiere eure\nEntscheidung.", italian="Ok.[K] Rispetto la vostra\ndecisione.", spanish=" Vale.[K] Respeto vuestra decisión."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" I will accompany you.", french=" Je vous accompagne.", german=" Ich werde euch begleiten.", italian=" Verrò con voi.", spanish=" Os acompañaré."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="I have long been aware of\n[CS:N]Darkrai[CR]'s scheme...[K] I have pursued him a long\ntime to thwart his plan.", french="Il y a bien longtemps que je suis\nau fait des projets de [CS:N]Darkrai[CR]...[K] Et depuis,\nje le poursuis pour déjouer ses plans.", german="Diese Intrige von [CS:N]Darkrai[CR] war\nmir seit Langem bekannt.[K] Ich verfolge es schon\nseit langer Zeit, um seinen Plan zu vereiteln!", italian="È da tempo che sono a\nconoscenza del piano di [CS:N]Darkrai[CR]...[K]\nL'ho inseguito a lungo per fermarlo.", spanish="Conozco bien las intenciones de\n[CS:N]Darkrai[CR]...[K] Le persigo desde hace mucho con\nintención de desbaratar sus planes."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="But every time I caught up to\nhim, he would elude me...[K] This time, he is\nwaiting for us.", french="Mais chaque fois que j'arrivais\nà retrouver sa piste, il m'échappait...[K]\nCette fois-ci, il nous attend.", german="Aber jedes Mal, wenn ich es\nfast hatte, ist es mir entkommen.[K] Diesmal\nwartet es auf uns.", italian="Ma ogni volta che lo\nraggiungevo, riusciva a scappare...[K] Questa\nvolta ci sta aspettando.", spanish="Pero cada vez que doy con él,\nse me escapa...[K] Y esta vez nos estará\nesperando."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="I would like to settle this once\nand for all.", french="Je veux en finir une bonne fois\npour toutes.", german="Ich möchte diese Sache ein für\nalle Mal klären.", italian="Vorrei fare i conti con lui\nuna volta per tutte.", spanish="Quiero acabar con esto de una\nvez por todas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_suriipu = SkySceneKit.spawn_npc("drowzee", 400, 232, Direction.Up, "NPC_SURIIPU")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" I'll go too!", french=" Moi aussi, je viens!", german=" Ich komme auch mit!", italian=" Verrò anch'io!", spanish=" ¡Yo iré también!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 352, 176, Direction.Right, "NPC_PERAPPU")
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Me too!", french=" Moi aussi!", german=" Und ich!", italian=" Anch'io!", spanish=" ¡Y yo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 304, 232, Direction.UpRight, "NPC_BIPPA")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Yup yup! I'll go, by golly!", french="Ouaip ouaip! J'suis avec vous,\nsapristi!", german="Jawollja! Ich gehe auch.\nDonnerwetter!", italian=" Sì, sì! E anch'io, ohibò!", spanish=" ¡Sí, señor! ¡Y yo, caramba!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kureseria, Direction.Down)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_kureseria, Direction.Left)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_kureseria, Direction.DownLeft)
  GAME:WaitFrames(45)
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="I'm delighted by everyone's\noffer to help.", french="Votre soutien me fait très\nplaisir.", german="Ich freue mich über die Hilfe\nvon jedem.", italian="Sono felice che tutti si\nsiano offerti di aiutarci.", spanish="Me alegro de que todos queráis\ncolaborar."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="I'm afraid that [CS:N]Darkrai[CR] would be\nscared off if too many of us were to go.", french="Mais je crains que [CS:N]Darkrai[CR]\nne prenne la fuite si nous sommes trop\nnombreux à y aller.", german="Allerdings fürchte ich, dass\n[CS:N]Darkrai[CR] verschreckt würde,\nwenn zu viele von uns kämen.", italian="Ma temo che [CS:N]Darkrai[CR]\nscapperebbe se andassimo in troppi.", spanish="Pero me temo que [CS:N]Darkrai[CR] se\nasustaría y huiría si fuéramos demasiados."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="This is a rare chance to corner\n[CS:N]Darkrai[CR] and stop his nefarious scheme.", french="C'est notre seule chance de le\ncoincer pour entraver son horrible projet.", german="Das ist die seltene Gelegenheit,\n[CS:N]Darkrai[CR] in die Ecke zu drängen und seinem\nruchlosen Treiben ein Ende zu machen.", italian="Questa è un'occasione più unica\nche rara per mettere [CS:N]Darkrai[CR] con le spalle\nal muro e fermare il suo malvagio piano.", spanish="Esta es nuestra oportunidad de\natrapar a [CS:N]Darkrai[CR] y acabar con sus planes."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="Please be content with just the\nthree of us going.", french="Contentons-nous d'y aller\nà trois.", german="Bitte seid zufrieden, wenn nur\nwir drei gehen werden.", italian="Per favore, lasciate andare solo\nnoi tre.", spanish=" Iremos solo tres."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Aww...[K] That's too bad...", french=" Bah...[K] C'est dommage...", german=" Ooh...[K] Das ist schade...", italian=" Ooh...[K] Che peccato...", spanish=" Ay...[K] Qué pena..."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="But I'd have to say you all are\nright...", french="Mais faut avouer qu'vous avez\nraison...", german="Aber ich muss sagen, dass ihr\nrecht habt.", italian="Ma devo ammettere che avete\nragione.", spanish="Pero tengo que admitir que\nestás en lo cierto..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, partner, 4) end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 296, 208, Direction.UpRight, "NPC_DOGOOMU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, partner, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, partner, 4) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 336, 248, Direction.Up, "NPC_CHIRIIN")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, partner, 4) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 376, 248, Direction.Up, "NPC_KIMAWARI")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, partner, 4) end)
  GAME:WaitFrames(5)
  local npc_npc_ruriri = SkySceneKit.spawn_npc("azurill", 376, 224, Direction.Up, "NPC_RURIRI")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_ruriri, partner, 4) end)
  local npc_npc_mariru = SkySceneKit.spawn_npc("marill", 376, 208, Direction.Up, "NPC_MARIRU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mariru, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_suriipu, partner, 4) end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 408, 192, Direction.UpLeft, "NPC_HEIGANI")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Don't worry, everyone![K] We'll be\nsure to defeat [CS:N]Darkrai[CR] and come back!", french="Ne vous inquiétez pas![K]\nNous réglerons son compte à [CS:N]Darkrai[CR] une\nbonne fois pour toutes, et nous reviendrons!", german="Macht euch keine Sorgen,\nLeute![K] Wir werden [CS:N]Darkrai[CR] ganz sicher\nbesiegen und wieder zurückkommen!", italian="Non preoccupatevi![K]\nSconfiggeremo [CS:N]Darkrai[CR] e torneremo qui da voi!", spanish="¡No os preocupéis![K]\n¡Derrotaremos a [CS:N]Darkrai[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Don't worry, everyone![K] We'll be\nsure to defeat [CS:N]Darkrai[CR] and come back!", french="Ne vous inquiétez pas![K]\nNous réglerons son compte à [CS:N]Darkrai[CR] une\nbonne fois pour toutes, et nous reviendrons!", german="Macht euch keine Sorgen,\nLeute![K] Wir werden [CS:N]Darkrai[CR] ganz sicher\nbesiegen und wieder zurückkommen!", italian="Non preoccupatevi![K]\nSconfiggeremo [CS:N]Darkrai[CR] e torneremo qui da voi!", spanish="¡No os preocupéis![K]\n¡Derrotaremos a [CS:N]Darkrai[CR]!"})
  else
  SkySceneKit.say({english="Don't worry, everyone![K] We'll be\nsure to defeat [CS:N]Darkrai[CR] and come back!", french="Ne vous inquiétez pas![K]\nNous réglerons son compte à [CS:N]Darkrai[CR] une\nbonne fois pour toutes, et nous reviendrons!", german="Macht euch keine Sorgen,\nLeute![K] Wir werden [CS:N]Darkrai[CR] ganz sicher\nbesiegen und wieder zurückkommen!", italian="Non preoccupatevi![K]\nSconfiggeremo [CS:N]Darkrai[CR] e torneremo qui da voi!", spanish="¡No os preocupéis![K]\n¡Derrotaremos a [CS:N]Darkrai[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Yes! You do that!", french=" Oui, je vous fais confiance!", german=" Ja! Ihr schafft das!", italian=" Sì! Dovete tornare!", spanish=" ¡Sí!"})
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.UpRight)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" If anyone can, it's you!", french="Si quelqu'un peut y arriver,\nc'est bien vous!", german=" Wenn es einer kann, dann ihr!", italian="Se qualcuno può farcela, siete\nvoi!", spanish=" ¡Seguro que lo lográis!"})
  GROUND:EntTurn(hero, Direction.DownRight)
  GROUND:EntTurn(partner, Direction.DownRight)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" You all take care, by golly!", french="Faites bien gaffe à vous,\npour sûr!", german="Passt auf euch auf,\nMenschenskind!", italian=" Fate attenzione, ohibò!", spanish=" ¡Huyuyuy! ¡Id con cuidado!"})
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(partner, Direction.DownLeft)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Thanks, everyone!", french=" Merci, tout le monde!", german=" Danke euch allen!", italian=" Grazie a tutti!", spanish=" ¡Muchas gracias a todos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Everyone, thank you!", french=" Merci, tout le monde!", german=" Ihr alle, vielen Dank!", italian=" Grazie a tutti!", spanish=" ¡Muchas gracias a todos!"})
  else
  SkySceneKit.say({english=" Everyone, thank you!", french=" Merci, tout le monde!", german=" Ihr alle, vielen Dank!", italian=" Grazie a tutti!", spanish=" ¡Muchas gracias a todos!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go, [hero]!", french=" En route, [hero]!", german=" Gehen wir, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Vámonos, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go, [hero]!", french=" En route, [hero]!", german=" Gehen wir, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Vámonos, [hero]!"})
  else
  SkySceneKit.say({english=" Let's go, [hero]!", french=" En route, [hero]!", german=" Gehen wir, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Vámonos, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's go to the [CS:P]Dark Crater[CR]...[K]\nwhere [CS:N]Darkrai[CR] awaits us!", french="Allons au [CS:P]Cratère Obscur[CR]...[K]\n[CS:N]Darkrai[CR] nous attend!", german="Lass uns zum [CS:P]Dunkelkrater[CR]\ngehen,[K] wo [CS:N]Darkrai[CR] uns erwartet!", italian="Andiamo al [CS:P]Cratere Oscuro[CR]...[K]\n[CS:N]Darkrai[CR] ci aspetta!", spanish="Vamos al [CS:P]Cráter Oscuro[CR]...[K]\n¡[CS:N]Darkrai[CR] nos está esperando!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go to the [CS:P]Dark Crater[CR]...[K]\nwhere [CS:N]Darkrai[CR] awaits us!", french="Allons au [CS:P]Cratère Obscur[CR]...[K]\n[CS:N]Darkrai[CR] nous attend!", german="Lass uns zum [CS:P]Dunkelkrater[CR]\ngehen,[K] wo [CS:N]Darkrai[CR] uns erwartet!", italian="Andiamo al [CS:P]Cratere Oscuro[CR]...[K]\n[CS:N]Darkrai[CR] ci aspetta!", spanish="Vamos al [CS:P]Cráter Oscuro[CR]...[K]\n¡[CS:N]Darkrai[CR] nos está esperando!"})
  else
  SkySceneKit.say({english="Let's go to the [CS:P]Dark Crater[CR]...[K]\nwhere [CS:N]Darkrai[CR] awaits us!", french="Allons au [CS:P]Cratère Obscur[CR]...[K]\n[CS:N]Darkrai[CR] nous attend!", german="Lass uns zum [CS:P]Dunkelkrater[CR]\ngehen,[K] wo [CS:N]Darkrai[CR] uns erwartet!", italian="Andiamo al [CS:P]Cratere Oscuro[CR]...[K]\n[CS:N]Darkrai[CR] ci aspetta!", spanish="Vamos al [CS:P]Cráter Oscuro[CR]...[K]\n¡[CS:N]Darkrai[CR] nos está esperando!"})
  end
  -- message_Close
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false,  60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
