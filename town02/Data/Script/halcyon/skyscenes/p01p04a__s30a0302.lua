-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P04A/s30a0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_P01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_togepii = SkySceneKit.spawn_npc("togepi", 400, 232, Direction.Down, "NPC_TOGEPII")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_bariyaado = SkySceneKit.spawn_npc("mr_mime", 384, 208, Direction.Up, "NPC_BARIYAADO")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_okutan = SkySceneKit.spawn_npc("octillery", 416, 192, Direction.UpLeft, "NPC_OKUTAN")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_sutoraiku = SkySceneKit.spawn_npc("scyther", 296, 280, Direction.Up, "NPC_SUTORAIKU")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_jiguzaguma = SkySceneKit.spawn_npc("zigzagoon", 352, 208, Direction.Left, "NPC_JIGUZAGUMA")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_sandopan = SkySceneKit.spawn_npc("sandslash", 280, 216, Direction.DownRight, "NPC_SANDOPAN")
  -- SetAnimation(4) [anim idle native]
  -- GAP: se_Play(6669) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 368, 292, false, 2)
  GROUND:MoveToPosition(partner, 332, 292, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wow, there's quite a crowd.", french=" Oh, une foule s'est rassemblée.", german=" Wow, ganz schön viel los.", italian=" Wow, c'è una bella folla.", spanish=" Caray, qué gentío."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wow, there's a crowd.", french=" Oh, une foule s'est rassemblée.", german=" Wow, ganz schön viel los.", italian=" Wow, che folla.", spanish=" Caramba, cuánta gente."})
  else
  SkySceneKit.say({english=" Wow, there's a crowd.", french=" Oh, une foule s'est rassemblée.", german=" Wow, ganz schön viel los.", italian=" Wow, che folla.", spanish=" Vaya, qué gentío."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(348, 220, 60, false) end) -- performer/caméra
  GAME:WaitFrames(7)
  GROUND:MoveToPosition(hero, 368, 232, false, 2)
  GROUND:MoveToPosition(partner, 332, 232, false, 2)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(30)
  local npc_npc_patchiiru = SkySceneKit.spawn_npc("spinda", 352, 176, Direction.Down, "NPC_PATCHIIRU")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, "happy", 1) end)
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="May I have everyone's attention,\nplease! First of all, I'd like to thank you for\ntaking time out of your busy schedules!", french="Mes amis, votre attention,\ns'il vous plaît! Tout d'abord, merci à tous\nd'avoir pris un peu de votre temps pour venir.", german="Ich grüße euch alle zusammen!\nErst einmal danke, dass ihr euch Zeit\nfür diese Ansprache genommen habt!", italian="Posso avere la vostra attenzione\nper favore? Innanzitutto vi ringrazio di\nessere qui nonostante i vostri impegni!", spanish="¡Atención! ¡Atención, por favor!\nEn primer lugar, muchas gracias a todos por\nsacar tiempo de vuestras apretadas agendas."})
  -- se_FadeOut(6669, 90) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_pachirisu = SkySceneKit.spawn_npc("pachirisu", 304, 232, Direction.UpLeft, "NPC_PACHIRISU")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_pachirisu, nil, 0) end) -- EFFECT_NONE
  local npc_npc_nyorotono = SkySceneKit.spawn_npc("politoed", 432, 240, Direction.DownLeft, "NPC_NYOROTONO")
  pcall(function() GROUND:CharSetEmote(npc_npc_nyorotono, nil, 0) end) -- EFFECT_NONE
  local npc_npc_herakurosu = SkySceneKit.spawn_npc("heracross", 312, 208, Direction.Down, "NPC_HERAKUROSU")
  GROUND:EntTurn(npc_npc_herakurosu, Direction.Up)
  GROUND:EntTurn(npc_npc_pachirisu, Direction.UpRight)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_jiguzaguma, Direction.Up)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_bariyaado, Direction.Up)
  GAME:WaitFrames(6)
  GROUND:EntTurn(npc_npc_nyorotono, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_okutan, Direction.UpLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_togepii, Direction.UpLeft)
  GAME:WaitFrames(3)
  GROUND:MoveToPosition(npc_npc_sandopan, 272, 192, false, 2)
  local npc_npc_zanguusu = SkySceneKit.spawn_npc("zangoose", 296, 256, Direction.Down, "NPC_ZANGUUSU")
  GROUND:MoveToPosition(npc_npc_zanguusu, 252, 212, false, 2)
  GROUND:MoveToPosition(npc_npc_sutoraiku, 300, 252, false, 2)
  local npc_npc_rediba = SkySceneKit.spawn_npc("ledyba", 400, 264, Direction.UpRight, "NPC_REDIBA")
  GROUND:MoveToPosition(npc_npc_rediba, 404, 240, false, 2)
  GROUND:MoveToPosition(npc_npc_togepii, 436, 212, false, 2)
  GROUND:EntTurn(npc_npc_rediba, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_togepii, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_sandopan, Direction.UpRight)
  GROUND:EntTurn(npc_npc_zanguusu, Direction.UpRight)
  GROUND:EntTurn(npc_npc_sutoraiku, Direction.UpRight)
  GAME:WaitFrames(5)
  do local p=npc_npc_jiguzaguma.Position; GROUND:MoveToPosition(npc_npc_jiguzaguma, p.X+(0), p.Y+(-8), false, 2) end
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Today I would like to give you\nsome wonderful news of hopes\nand dreams!", french="Aujourd'hui, j'aimerais vous\nannoncer une excellente nouvelle, vos rêves\npourraient bien se réaliser.", german="Heute möchte ich euch einige\nwundervolle Neuigkeiten über das Hoffen und\nTräumen mitteilen.", italian="Oggi vorrei darvi delle notizie\nmeravigliose, ricche di sogni e di speranze!", spanish="Hoy me gustaría daros una\nnoticia tan maravillosa que espero\nque os parezca de ensueño."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5138) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_pachirisu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bariyaado, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_togepii, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(3)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(60)
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharSetEmote(npc_npc_pachirisu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_bariyaado, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_togepii, nil, 0) end) -- EFFECT_NONE
  -- se_FadeOut(5138, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(30)
  -- GAP: BGM BGM_SPINDAS_CAFE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" Ahem.", french=" Ahem...", german=" Ähem.", italian=" Ehm.", spanish=" Ejem."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="Thanks to your kind patronage,\nthis café has been quite popular...", french="Grâce à votre soutien,\nla renommée de ce café ne cesse de grandir...", german="Dank eurer regen Unterstützung\nläuft dieses Café recht erfolgreich...", italian="Grazie al vostro sostegno,\nil caffè è diventato piuttosto famoso...", spanish="Gracias a vuestras repetidas\nvisitas, esta cafetería se ha hecho\nbastante famosa..."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="We've been fortunate to have so\nmany wonderful customers!", french="Quelle chance nous avons d'avoir\npu accueillir tant de clients merveilleux!", german="Wir dürfen uns über eine aktive\nKundschaft freuen!", italian="Siamo fortunati ad avere\ndei clienti fantastici come voi!", spanish="¡Somos de lo más afortunados\nal tener tantos clientes maravillosos!"})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="This shop's pride and joy, the\nRecycle Shop, is fully operational and has\ncollected many items.", french="La fierté de ce magasin, la\nBourse d'Echange, tourne à plein régime et a\ndéjà amassé un nombre conséquent d'objets.", german="Und der Stolz dieses Cafés, der\nWiederverwertungsladen, ist nun bereit und\nhat dank euch bereits viele Items auf Lager.", italian="Il Centro Riciclo, orgoglio e gioia\ndi questo locale, è pienamente operativo e\nha raccolto molti strumenti.", spanish="La joya de este establecimiento,\nel Reciclaje Explorador, se encuentra\ntotalmente operativa y reúne muchos objetos."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="We would like to thank you for\nyour kind patronage...", french="Nous aimerions vous exprimer\nnotre reconnaissance pour votre\naimable soutien...", german="Wir möchten euch für eure\nUnterstützung ganz herzlich danken...", italian="Vorremmo esprimere la nostra\ngratitudine nei vostri confronti...", spanish="Nos gustaría daros las gracias\npor seguir visitándonos..."})
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" By opening a new service!", french="... en inaugurant un\nnouveau service!", german="Und zwar, indem wir ab sofort\neinen neuen Service anbieten!", italian="... inaugurando un nuovo\nservizio!", spanish=" ¡Inaugurando un nuevo servicio!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, "happy", 1) end)
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" We're calling it Project P!", french="Nous l'avons appelé\nle \"Projet P\"!", german=" Wir nennen ihn [F:S2]Projekt P[F:E2]!", italian=" Si chiamerà Progetto P!", spanish=" Lo llamamos \\\"Proyecto P\\\"."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_patchiiru, nil, 0) end) -- EFFECT_NONE
  -- GAP: se_Play(7944) — id SE NDS sans portage PMDO identifié
  local npc_npc_soonano = SkySceneKit.spawn_npc("wynaut", 328, 152, Direction.Down, "NPC_SOONANO")
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(10)
  local npc_npc_soonansu = SkySceneKit.spawn_npc("wobbuffet", 376, 152, Direction.Down, "NPC_SOONANSU")
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(10)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  -- se_FadeOut(7944, 60) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bariyaado, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(3, 3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english=" Project P?", french=" Le \\\"Projet P\\\"?", german=" Projekt P?", italian=" Progetto P?", spanish=" ¿Proyecto P?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english=" What's that?", french=" Qu'est-ce que c'est?", german=" Was ist das?", italian=" E cos'è?", spanish=" ¿Y eso qué es?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english="This project aims to use the\nitems gathered at the Recycle Shop in order to\nexplore unexplored places.", french="Ce projet vise à utiliser les\nobjets accumulés à la Bourse d'Echange pour\npermettre d'explorer de nouveaux territoires.", german="Dieses Projekt soll die Items\ndes Wiederverwertungsladens dazu verwenden,\nbisher unerforschte Gebiete zu erkunden.", italian="Lo scopo di questo progetto\nconsiste nell'usare gli strumenti raccolti al\nCentro Riciclo per esplorare luoghi sconosciuti.", spanish="Este proyecto pretende usar\nlos objetos recopilados en el Reciclaje\nExplorador para llegar a lugares inexplorados."})
  pcall(function() UI:SetSpeaker(npc_npc_patchiiru) end)
  SkySceneKit.say({english=" Allow me to explain.", french=" Je vous explique...", german=" Lasst es mich erklären.", italian=" Mi spiego meglio.", spanish=" Permitidme que lo explique."})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
