-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m14a0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetBanner2(LEVEL_V03P09A, 0, 156, 140, 12) [bannière 2e écran NDS: information dupliquée du menu, hors canvas unique - documenté]
  -- back_SetEffect(5, 0) [transition couches décor NDS immédiate]
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(45)
  GAME:WaitFrames(160)
  GAME:FadeOut(false,  45)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- supervision_Acting(3) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  local npc_npc_jibakoiru = SkySceneKit.spawn_npc("magnezone", 424, 208, Direction.Down, "NPC_JIBAKOIRU")
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! Thank you for helping\nwith our criminal investigation! ZZZT!", french="ZZZT! Merci de votre\ncontribution à cette enquête! ZZZT!", german="ZZZT! Vielen Dank für eure\nHilfe bei den Ermittlungen! ZZZT!", italian="ZZZT! Grazie per il vostro aiuto\nnelle indagini! ZZZT!", spanish="¡Bzz! ¡Gracias por la ayuda\nque habéis prestado en la investigación!\n¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! We have [CS:N]Mesprit[CR] under\nprotection. Her safety is assured. ZZZT!", french="ZZZT! [CS:N]Créfollet[CR] est sous\nnotre protection. Nous assurons sa sécurité.\nZZZT!", german="ZZZT! [CS:N]Vesprit[CR] steht jetzt unter\nunserem Schutz. Wir garantieren für seine\nSicherheit. ZZZT!", italian="ZZZT! Al momento [CS:N]Mesprit[CR] è\nsotto la nostra protezione. Non temete. ZZZT!", spanish="¡Bzz! Tenemos a [CS:N]Mesprit[CR]\nbajo nuestra protección. Su seguridad\nestá garantizada. ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! We are dedicating all\nresources to the pursuit of [CS:N]Grovyle[CR]. ZZZT!", french="ZZZT! Nous consacrons toutes\nnos forces à la capture de [CS:N]Massko[CR]. ZZZT!", german="ZZZT! Wir konzentrieren unsere\ngesamte Energie auf die Jagd nach [CS:N]Reptain[CR].\nZZZT!", italian="ZZZT! Al momento tutte le unità\nsono impegnate nella ricerca di [CS:N]Grovyle[CR]. ZZZT!", spanish="¡Bzz! Estamos dedicando\ntodos nuestros recursos a atrapar\na [CS:N]Grovyle[CR]. ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! If you come across any\ninformation related to this case, please let\nus know. ZZZT!", french="ZZZT! Si vous découvrez quoi\nque ce soit à ce sujet, merci de nous informer\nimmédiatement. ZZZT!", german="ZZZT! Wenn euch irgendwelche\nfür den Fall relevanten Informationen zu\nOhren kommen, sagt uns Bescheid. ZZZT!", italian="ZZZT! Se doveste venire in\npossesso di informazioni riguardanti questo\ncaso, vi prego di informarci. ZZZT!", spanish="¡Bzz! Informadnos si descubrís\ncualquier cosa relacionada con el caso. ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! We must all cooperate to\nbring this criminal to justice. ZZZT!", french="ZZZT! Nous devons tous\ncoopérer pour mettre ce criminel sous\nles verrous. ZZZT!", german="ZZZT! Wir müssen diesen\nVerbrecher mit vereinten Kräften zur\nRechenschaft ziehen. ZZZT!", italian="ZZZT! Abbiamo bisogno dell'aiuto\ndi tutti per riuscire a consegnare questo\ncriminale alla giustizia. ZZZT!", spanish="¡Bzz! Todos debemos colaborar\npara poner a este delincuente en manos de la\njusticia. ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! That is all. Now please\nexcuse us! ZZZT!", french="ZZZT! C'est tout. Et maintenant,\nveuillez nous excuser! ZZZT!", german="ZZZT! Das ist alles. Nun\nentschuldigt uns! ZZZT!", italian="ZZZT! Per ora è tutto. Vi prego\ndi scusarci! ZZZT!", spanish="¡Bzz! Eso es todo.\nAhora debemos marcharnos. ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_jibakoiru.Position; GROUND:MoveToPosition(npc_npc_jibakoiru, p.X+(-96), p.Y+(0), false, 2) end
  local npc_npc_koiru = SkySceneKit.spawn_npc("magnemite", 400, 200, Direction.Down, "NPC_KOIRU")
  GROUND:EntTurn(npc_npc_koiru, Direction.Left)
  local npc_npc_koiru2 = SkySceneKit.spawn_npc("magnemite", 440, 200, Direction.Down, "NPC_KOIRU2")
  GROUND:EntTurn(npc_npc_koiru2, Direction.Left)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 232, Direction.UpLeft, "NPC_PERAPPU")
  GROUND:MoveToPosition(npc_npc_perappu, 432, 220, false, 1)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Left)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 448, 256, Direction.Up, "NPC_KIMAWARI")
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 448, 272, Direction.Up, "NPC_DIGUDA")
  GROUND:EntTurn(npc_npc_diguda, Direction.UpLeft)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 424, 256, Direction.Up, "NPC_BIPPA")
  GROUND:EntTurn(npc_npc_bippa, Direction.UpLeft)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Up, "NPC_DOGOOMU")
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpLeft)
  GAME:WaitFrames(10)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 392, 256, Direction.Up, "NPC_CHIRIIN")
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpLeft)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 392, 272, Direction.Up, "NPC_HEIGANI")
  GROUND:EntTurn(npc_npc_heigani, Direction.UpLeft)
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 368, 232, Direction.UpRight, "NPC_YONOWAARU")
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.UpLeft)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  GROUND:EntTurn(npc_npc_guregguru, Direction.UpLeft)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 360, 272, Direction.UpRight, "NPC_DAGUTORIO")
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpLeft)
  GAME:WaitFrames(20)
  do local p=npc_npc_koiru.Position; GROUND:MoveToPosition(npc_npc_koiru, p.X+(-76), p.Y+(0), false, 2) end
  do local p=npc_npc_koiru2.Position; GROUND:MoveToPosition(npc_npc_koiru2, p.X+(-116), p.Y+(0), false, 2) end
  GROUND:MoveToPosition(npc_npc_jibakoiru, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_koiru, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_koiru2, 324, 132, false, 2)
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 480, 216, Direction.Left, "NPC_PUKURIN")
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_perappu, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_perappu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="My, my! I'm absolutely\nastonished!", french="Mes aïeux! Je n'arrive pas à y\ncroire!", german="So was aber auch! Ich staune\nnicht schlecht!", italian="Wow! Sono davvero senza\nparole!", spanish="¡Increíble! Me habéis dejado\nde piedra."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="So there was a lake deep\nunder the [CS:P]Northern Desert[CR]?", french="Alors, il y avait un lac enfoui\ndans les profondeurs du [CS:P]Désert du Nord[CR]?", german="Es gab also tief unter der\n[CS:P]Nordwüste[CR] einen See?", italian="Avete scoperto un lago sotto al\n[CS:P]Deserto del Nord[CR]?", spanish="¿Así que había un lago bajo\nel [CS:P]Desierto Norte[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And that wasn't all? A Time Gear\nwas also down there?", french="Et ce n'est pas tout? Un Rouage\ndu Temps y était caché?", german="Und dort gab es auch noch ein\nZahnrad der Zeit?", italian="E che laggiù era situato pure\nun Ingranaggio del Tempo?", spanish="¿Donde además se ocultaba\nun Engranaje del Tiempo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, partner, 4) end)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.DownRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yep. But about that Time Gear...", french="Oui. Mais en parlant de\nce Rouage du Temps...", german="Genau. Aber was das Zahnrad\nder Zeit angeht...", italian=" Già. A proposito...", spanish="Sí, pero ese Engranaje del\nTiempo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes. But about that Time Gear...", french="Oui. Mais en parlant de\nce Rouage du Temps...", german="Genau. Aber was das Zahnrad\nder Zeit angeht...", italian="Proprio così. E a proposito\ndell'Ingranaggio del Tempo...", spanish="Sí, pero ese Engranaje del\nTiempo..."})
  else
  SkySceneKit.say({english=" Yes. But about that Time Gear...", french="Oui. Mais en parlant de\nce Rouage du Temps...", german="Genau. Aber was das Zahnrad\nder Zeit angeht...", italian="Proprio così. E a proposito\ndell'Ingranaggio del Tempo...", spanish="Sí, pero ese Engranaje del\nTiempo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Grovyle[CR] took off with it...", french=" [CS:N]Massko[CR] s'est enfui avec...", german=" [CS:N]Reptain[CR] ist damit abgehauen.", italian="[CS:N]Grovyle[CR] è riuscito a portarlo\nvia...", spanish=" Ha sido robado por [CS:N]Grovyle[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Grovyle[CR] stole it...", french=" [CS:N]Massko[CR] s'est enfui avec...", german=" [CS:N]Reptain[CR] hat es gestohlen.", italian="[CS:N]Grovyle[CR] è riuscito a portarlo\nvia...", spanish=" Ha sido robado por [CS:N]Grovyle[CR]."})
  else
  SkySceneKit.say({english=" [CS:N]Grovyle[CR] took off with it...", french=" [CS:N]Massko[CR] s'est enfui avec...", german=" [CS:N]Reptain[CR] ist damit abgehauen.", italian="[CS:N]Grovyle[CR] è riuscito a portarlo\nvia...", spanish=" Ha sido robado por [CS:N]Grovyle[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And we couldn't even slow down\n[CS:N]Grovyle[CR]...", french="Et on n'a même pas été capables\nde le ralentir...", german="Und wir haben [CS:N]Reptain[CR] nicht\neinmal lange aufgehalten.", italian="Non siamo riusciti a fare nulla\nper fermare [CS:N]Grovyle[CR]...", spanish=" Ni siquiera pudimos frenarle."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And we failed to even slow\ndown [CS:N]Grovyle[CR]...", french="Et on n'a même pas été capables\nde le ralentir...", german="Und wir haben es nicht einmal\ngeschafft, [CS:N]Reptain[CR] länger aufzuhalten.", italian="Non siamo riusciti a fare nulla\nper fermare [CS:N]Grovyle[CR]...", spanish=" Ni siquiera pudimos frenarle."})
  else
  SkySceneKit.say({english="And we couldn't even slow down\n[CS:N]Grovyle[CR]...", french="Et on n'a même pas été capables\nde le ralentir...", german="Und wir haben [CS:N]Reptain[CR] nicht\neinmal lange aufgehalten.", italian="Non abbiamo potuto fare nulla\nper fermare [CS:N]Grovyle[CR]...", spanish=" Ni siquiera pudimos frenarle."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's the same as doing\nnothing at all!", french="Résultat: on est revenus au\npoint de départ!", german="Das ist so gut, als hätten wir\ngar nichts getan!", italian=" È stato tutto inutile!", spanish="¡Es como si no hubiéramos\nhecho nada!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="In the end, that's the same as\ndoing nothing at all!", french="Résultat: on est revenus au\npoint de départ!", german="Letztendlich ist das so,\nals hätten wir gar nichts gemacht!", italian=" È stato tutto inutile!", spanish="¡Es como si no hubiéramos\nhecho nada!"})
  else
  SkySceneKit.say({english="Which is just the same as not\ngetting anything done at all!", french="Résultat: on est revenus au\npoint de départ!", german="Das ist so, als hätten wir\ntatenlos danebengestanden!", italian=" È stato tutto inutile!", spanish="¡Es como si no hubiéramos\nhecho nada!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" That's not true, by golly!", french=" Mais dites pas ça, sapristi!", german="Das ist nicht wahr, nein,\nwirklich nicht!", italian=" Non dovete parlare così, ohibò!", spanish=" ¡Huy, eso no es verdad!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" You all did great work!", french=" Z'avez fait du bon boulot!", german=" Ihr habt tolle Arbeit geleistet!", italian="Voi due ce l'avete messa tutta,\nsissignore!", spanish=" ¡Lo habéis hecho muy bien!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_bippa, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_heigani, 4) end)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_heigani, 4) end)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.DownRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_heigani, 4) end)
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! I think so too!\nTeam [team:] can be really proud!", french="Eh dis donc, moi aussi, je suis\nde cet avis! L'Equipe [team:] peut\nvraiment être fière de sa découverte!", german="Hey, hey! Das finde ich auch!\nTeam [team:] kann stolz auf sich sein!", italian="Ehi, ehi! Anch'io la penso così!\nDobbiamo essere tutti orgogliosi del Team\n[team:]!", spanish="¡Oye, oye! ¡Yo también lo creo!\n¡El [CS:X]Equipo[CR] [team:] puede estar orgulloso!"})
  -- message_KeyWait
  pcall(function() SOUND:FadeOutBGM(180) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="But it's a shame about this\nwhole thing...", french="Quel dommage que ça se soit\nfini comme ça...", german=" Aber was wirklich schade ist...", italian="Certo, tutta questa storia è un\nvero problema...", spanish="Pero lo ocurrido me da mucha\npena."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="There's no clue telling us what\nwe should do next, right?", french="Et on n'a rien pour nous indiquer\nla marche à suivre maintenant, pas vrai?", german="Wir haben keinen blassen\nSchimmer, was wir als Nächstes tun sollen,\noder?", italian="Non sappiamo nemmeno dove\nsbattere la testa adesso, non è così?", spanish="Ahora no hay forma de saber\nlo que deberíamos hacer, ¿verdad?"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! If we had only one\ntiny hint...", french="Eh dis donc, si seulement\non avait un petit indice...", german="Hey, hey! Wenn wir nur einen\nHinweis hätten...", italian="Ehi, ehi! Se solo avessimo\nqualche indizio...", spanish="¡Eso, eso! Si al menos\ntuviéramos alguna pequeña pista..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" I must agree.", french="Nous ne pouvons qu'abonder\ndans ce sens.", german=" Da muss ich zustimmen.", italian=" Eh sì...", spanish=" Ahí tienes razón."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Where will [CS:N]Grovyle[CR] strike next?", french="Où donc [CS:N]Massko[CR] frappera-t-il\nla prochaine fois?", german="Wo wird [CS:N]Reptain[CR] als Nächstes\nzuschlagen?", italian="Se solo sapessimo quale sarà il\nprossimo obiettivo di [CS:N]Grovyle[CR]!", spanish="¿Dónde será el próximo robo\nde [CS:N]Grovyle[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" We have no way of knowing.", french=" Il est impossible de le deviner.", german=" Wir wissen es einfach nicht.", italian=" Non c'è modo di saperlo.", spanish=" No hay forma de saberlo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-3, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="It's too bad that the opportunity\nto catch him slipped away.", french="Dommage qu'il nous ait filé\nentre les doigts, celui-là.", german="Es ist zu schade, dass er\nentkommen ist, als die Chance da war, ihn zu\nfangen.", italian="È davvero un peccato che\nl'occasione di acciuffarlo sia sfumata così.", spanish="Es una pena que perdiésemos\nla oportunidad de atraparle."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" We're back to square one!", french=" Retour à la case départ!", german="Wir müssen wieder ganz von\nvorne anfangen!", italian="Siamo tornati al punto di\npartenza!", spanish="Estamos otra vez donde\nempezamos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Maybe not.[K] Not necessarily.", french="Peut-être pas.[K] Pas\nnécessairement.", german=" Vielleicht nicht.[K] Nicht unbedingt.", italian="Forse no.[K] Non è detta l'ultima\nparola.", spanish=" Tal vez no.[K] No necesariamente."})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_yonowaaru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR], sir!", french=" Messire [CS:N]Noctunoir[CR]!", german=" [CS:N]Zwirrfinst[CR]!", italian=" Signor [CS:N]Dusknoir[CR]?", spanish=" ¡[CS:N]Dusknoir[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_yonowaaru, 388, 228, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_diguda, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_yonowaaru, 4) end)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- message_FacePositionOffset(3, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" There are some clues.", french="Nous avons glané quelques\nindices, en vérité.", german=" Es gibt einige Hinweise.", italian=" In effetti, degli indizi ci sono.", spanish=" Tenemos algunas pistas."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="One Time Gear was at [CS:P]Fogbound\nLake[CR], guarded by [CS:N]Uxie[CR], correct?", french="Un des Rouages du Temps\nse trouvait au [CS:P]Lac des Brumes[CR], sous\nla protection de [CS:N]Créhelf[CR], n'est-il pas?", german="Ein Zahnrad der Zeit war am\n[CS:P]Nebelsee[CR] und wurde von [CS:N]Selfe[CR] bewacht, oder?", italian="Pensiamoci bene. Un Ingranaggio\ndel Tempo si trovava al [CS:P]Lago Foschia[CR] ed era\ncustodito da [CS:N]Uxie[CR]. Non è così?", spanish="Había un Engranaje del Tiempo\nen el [CS:P]Lago Velado[CR], custodiado por [CS:N]Uxie[CR],\n¿correcto?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Another Time Gear was at the\n[CS:P]Underground Lake[CR], guarded by [CS:N]Mesprit[CR].", french="Le second Rouage du Temps\nétait au [CS:P]Lac Souterrain[CR], sous la protection\nde [CS:N]Créfollet[CR].", german="Ein weiteres war am\n[CS:P]Untergrundsee[CR] und wurde von [CS:N]Vesprit[CR] bewacht.", italian="Un altro Ingranaggio del Tempo\nsi trovava al [CS:P]Lago Sotterraneo[CR] e lo custodiva\n[CS:N]Mesprit[CR].", spanish="Otro Engranaje del Tiempo\nestaba en el [CS:P]Lago Subterráneo[CR], protegido\npor [CS:N]Mesprit[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Oh, that reminds me! [CS:N]Mesprit[CR]\ntold us something interesting!", french="Au fait, j'allais oublier! [CS:N]Créfollet[CR]\nnous a dit quelque chose d'intéressant!", german="Oh, das erinnert mich daran,\ndass [CS:N]Vesprit[CR] uns etwas Interessantes erzählt\nhat!", italian="È così! Inoltre, [CS:N]Mesprit[CR] ci ha\ndetto una cosa interessante!", spanish="Ahora que lo pienso, [CS:N]Mesprit[CR]\nnos dijo algo interesante."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh, that reminds me! [CS:N]Mesprit[CR]\ntold us something interesting!", french="Au fait, j'allais oublier! [CS:N]Créfollet[CR]\nnous a dit quelque chose d'intéressant!", german="Oh, das erinnert mich daran,\ndass [CS:N]Vesprit[CR] uns etwas Interessantes erzählt\nhat!", italian="È così! Inoltre, [CS:N]Mesprit[CR] ci ha\ndetto una cosa interessante!", spanish="Ahora que lo pienso, [CS:N]Mesprit[CR]\nnos dijo algo interesante."})
  else
  SkySceneKit.say({english="Oh, that reminds me! [CS:N]Mesprit[CR]\ntold us something interesting!", french="Au fait, j'allais oublier! [CS:N]Créfollet[CR]\nnous a dit quelque chose d'intéressant!", german="Oh, das erinnert mich daran,\ndass [CS:N]Vesprit[CR] uns etwas Interessantes erzählt\nhat!", italian="È così! Inoltre, [CS:N]Mesprit[CR] ci ha\ndetto una cosa interessante!", spanish="Ahora que lo pienso, [CS:N]Mesprit[CR]\nnos dijo algo interesante."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Mesprit[CR] knew that the Time\nGear from [CS:P]Fogbound Lake[CR] was stolen!", french="[CS:N]Créfollet[CR] savait qu'on avait volé\nle Rouage du Temps du [CS:P]Lac des Brumes[CR].", german="[CS:N]Vesprit[CR] wusste, dass das\nZahnrad der Zeit vom [CS:P]Nebelsee[CR] gestohlen\nwurde.", italian="[CS:N]Mesprit[CR] ci ha raccontato di\nsapere del furto dell'Ingranaggio del Tempo\nal [CS:P]Lago Foschia[CR].", spanish="[CS:N]Mesprit[CR] ya sabía que habían\nrobado el Engranaje del Tiempo del [CS:P]Lago Velado[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Mesprit[CR] knew that the Time\nGear from [CS:P]Fogbound Lake[CR] was stolen!", french="[CS:N]Créfollet[CR] savait qu'on avait volé\nle Rouage du Temps du [CS:P]Lac des Brumes[CR].", german="[CS:N]Vesprit[CR] wusste, dass das\nZahnrad der Zeit vom [CS:P]Nebelsee[CR] gestohlen\nwurde.", italian="[CS:N]Mesprit[CR] ci ha raccontato di\nsapere del furto dell'Ingranaggio del Tempo\nal [CS:P]Lago Foschia[CR].", spanish="[CS:N]Mesprit[CR] ya sabía que habían\nrobado el Engranaje del Tiempo del [CS:P]Lago Velado[CR]."})
  else
  SkySceneKit.say({english="[CS:N]Mesprit[CR] knew that the Time\nGear from [CS:P]Fogbound Lake[CR] was stolen!", french="[CS:N]Créfollet[CR] savait qu'on avait volé\nle Rouage du Temps du [CS:P]Lac des Brumes[CR].", german="[CS:N]Vesprit[CR] wusste, dass das\nZahnrad der Zeit vom [CS:P]Nebelsee[CR] gestohlen\nwurde.", italian="[CS:N]Mesprit[CR] ci ha raccontato di\nsapere del furto dell'Ingranaggio del Tempo\nal [CS:P]Lago Foschia[CR].", spanish="[CS:N]Mesprit[CR] ya sabía que habían\nrobado el Engranaje del Tiempo del [CS:P]Lago Velado[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Uxie[CR] told her by using telepathy!", french="[CS:N]Créhelf[CR] l'avait prévenue\npar télépathie!", german="[CS:N]Selfe[CR] hat es per Telepathie\ngewarnt!", italian="[CS:N]Uxie[CR] gliel'ha comunicato con la\ntelepatia!", spanish=" ¡[CS:N]Uxie[CR] se lo dijo telepáticamente!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Uxie[CR] alerted her by telepathy!", french="[CS:N]Créhelf[CR] l'avait prévenue\npar télépathie!", german="[CS:N]Selfe[CR] hat es per Telepathie\ngewarnt!", italian="[CS:N]Uxie[CR] gliel'ha comunicato con la\ntelepatia!", spanish=" ¡[CS:N]Uxie[CR] se lo dijo telepáticamente!"})
  else
  SkySceneKit.say({english=" [CS:N]Uxie[CR] alerted her by telepathy!", french="[CS:N]Créhelf[CR] l'avait prévenue\npar télépathie!", german="[CS:N]Selfe[CR] hat es per Telepathie\ngewarnt!", italian="[CS:N]Uxie[CR] gliel'ha comunicato con la\ntelepatia!", spanish=" ¡[CS:N]Uxie[CR] se lo dijo telepáticamente!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Incredible!", french=" Incroyable!", german=" Unglaublich!", italian=" Incredibile!", spanish=" ¡Increíble!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Now that IS really something!", french=" ÇA, c'est quelque chose!", german=" Ich FASSE es nicht!", italian=" Davvero sconvolgente!", spanish=" Eso sí que es útil."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(3, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" I should have known.", french=" J'aurais dû m'en douter.", german=" Ich hätte es wissen sollen.", italian=" Avrei dovuto immaginarlo.", spanish=" Tendría que haberlo sabido."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_diguda, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_yonowaaru, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_yonowaaru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" There is an ancient legend...", french=" Il existe une vieille légende...", german=" Es gibt eine uralte Legende...", italian=" Si narra, in un'antica leggenda...", spanish=" Hay una antigua leyenda..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="It is believed that [CS:N]Uxie[CR] is the\nBeing of Knowledge.[K] And that [CS:N]Mesprit[CR] is the\nBeing of Emotion.", french="Il est dit que [CS:N]Créhelf[CR] est l'être\ndu savoir.[K] Et [CS:N]Créfollet[CR], l'être de l'émotion.", german="Von [CS:N]Selfe[CR] sagt man, es sei das\nWissende Wesen.[K] Und von [CS:N]Vesprit[CR], es sei das\nFühlende Wesen.", italian="... che [CS:N]Uxie[CR] sia l'Essere della\nconoscenza.[K] [CS:N]Mesprit[CR] invece viene chiamata\nl'Essere delle emozioni.", spanish="Que cuenta que [CS:N]Uxie[CR] es el\nser de la sabiduría.[K] Y que [CS:N]Mesprit[CR]\nes el ser de la emoción."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="But three Pokémon in total\nrepresent the spiritual world...[K]and are said to\nkeep the world in balance.", french="Mais en fait, il y a trois\nPokémon qui représentent le monde spirituel...\net sont censés préserver l'équilibre du monde.", german="Doch es sind drei Pokémon, die\ndie spirituelle Welt repräsentieren...[K] Und die\nWelt im Gleichgewicht halten.", italian="Questi sono due dei tre Pokémon\nche rappresentano il mondo spirituale...[K] e si\ndice mantengano l'equilibrio nel nostro mondo.", spanish="Son tres los Pokémon que\nrepresentan el mundo espiritual...[K] y\nse dice que mantienen el equilibrio del planeta."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Th-three?", french=" Trois?", german=" D-drei?", italian=" T-Tre?", spanish=" ¡¿Tres?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Th-three?", french=" Trois?", german=" D-drei?", italian=" T-Tre?", spanish=" ¡¿Tres?!"})
  else
  SkySceneKit.say({english=" Th-three?", french=" Trois?", german=" D-drei?", italian=" T-Tre?", spanish=" ¡¿Tres?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So besides [CS:N]Uxie[CR] and [CS:N]Mesprit[CR]...", french="Donc, en plus de [CS:N]Créhelf[CR]\net [CS:N]Créfollet[CR]...", german="Wir sprachen von [CS:N]Selfe[CR] und\n[CS:N]Vesprit[CR]...", italian="Questo vuol dire che oltre a [CS:N]Uxie[CR]\ne a [CS:N]Mesprit[CR]...", spanish="Entonces, además de [CS:N]Uxie[CR]\ny [CS:N]Mesprit[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So besides [CS:N]Uxie[CR] and [CS:N]Mesprit[CR]...", french="Donc, en plus de [CS:N]Créhelf[CR]\net [CS:N]Créfollet[CR]...", german="Wir sprachen von [CS:N]Selfe[CR] und\n[CS:N]Vesprit[CR]...", italian="Questo significa che oltre a [CS:N]Uxie[CR]\ne a [CS:N]Mesprit[CR]...", spanish="Entonces, además de [CS:N]Uxie[CR]\ny [CS:N]Mesprit[CR]..."})
  else
  SkySceneKit.say({english=" So besides [CS:N]Uxie[CR] and [CS:N]Mesprit[CR]...", french="Donc, en plus de [CS:N]Créhelf[CR]\net [CS:N]Créfollet[CR]...", german="Wir sprachen von [CS:N]Selfe[CR] und\n[CS:N]Vesprit[CR]...", italian="Questo significa che oltre a [CS:N]Uxie[CR]\ne a [CS:N]Mesprit[CR]...", spanish="Entonces, además de [CS:N]Uxie[CR]\ny [CS:N]Mesprit[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" There's one other Pokémon?", french=" ... il y en a un autre?", german="Also gibt es noch ein drittes\nPokémon?", italian=" ... c'è un altro Pokémon?", spanish=" ¿Hay otro Pokémon más?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There's another Pokémon like\nthem?", french=" ... il y en a un autre?", german="Also gibt es noch ein drittes\nPokémon?", italian=" ... c'è un altro Pokémon?", spanish=" ¿Hay otro Pokémon más?"})
  else
  SkySceneKit.say({english="There's another Pokémon like\nthem?", french=" ... il y en a un autre?", german="Also gibt es noch ein drittes\nPokémon?", italian=" ... c'è un altro Pokémon?", spanish=" ¿Hay otro Pokémon más?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(180) end)
  -- message_FacePositionOffset(3, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Yes.", french=" Oui, certes.", german=" Ja.", italian=" È così.", spanish=" Sí."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="The last of the trio is [CS:N]Azelf[CR],\nknown as the Being of Willpower.", french="Le dernier s'appelle [CS:N]Créfadet[CR],\nl'être de la volonté.", german="Der dritte Teil des Trios ist\n[CS:N]Tobutz[CR], das als das Starke Wesen bekannt ist.", italian="Si tratta di [CS:N]Azelf[CR], l'Essere della\nvolontà.", spanish="El último del trío es [CS:N]Azelf[CR],\nconocido como el ser de la voluntad."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CS:N]Uxie[CR] and [CS:N]Mesprit[CR] both guarded\nTime Gears...", french="[CS:N]Créhelf[CR] et [CS:N]Créfollet[CR]\nprotégeaient tous les deux des Rouages\ndu Temps...", german="[CS:N]Selfe[CR] und [CS:N]Vesprit[CR] haben beide\nZahnräder der Zeit bewacht...", italian="[CS:N]Uxie[CR] e [CS:N]Mesprit[CR] erano entrambi\na guardia di un Ingranaggio del Tempo...", spanish="Tanto [CS:N]Uxie[CR] como [CS:N]Mesprit[CR]\ncustodiaban Engranajes del Tiempo..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Therefore, [CS:N]Azelf[CR] may likewise\nbe protecting a Time Gear.", french="On peut donc en déduire qu'il\nen va de même pour [CS:N]Créfadet[CR].", german="Also wird [CS:N]Tobutz[CR] womöglich\nauch ein Zahnrad der Zeit bewachen.", italian="Questo significa che anche [CS:N]Azelf[CR]\npotrebbe essere a guardia di un Ingranaggio del\nTempo.", spanish="Por tanto, puede que [CS:N]Azelf[CR]\ntambién proteja otro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Oh, I see!", french=" Ah, je vois!", german=" Oh, verstehe!", italian=" Ma certo!", spanish="Ahora entiendo lo que quieres\ndecir."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" If we could locate [CS:N]Azelf[CR]...", french="Si on arrivait à localiser\n[CS:N]Créfadet[CR]...", german=" Könnten wir [CS:N]Tobutz[CR] finden...", italian=" Se riuscissimo a trovare [CS:N]Azelf[CR]...", spanish=" Si encontrásemos a [CS:N]Azelf[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="We may find a Time Gear with\nthe Pokémon.", french="... on localiserait l'emplacement\nd'un Rouage du Temps par la même occasion.", german="Dann könnten wir vielleicht ein\nweiteres Zahnrad der Zeit finden.", italian="... potremmo localizzare un altro\nIngranaggio del Tempo.", spanish="Puede que demos también con\nun Engranaje del Tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="And we may have a chance at\nseeing that thief [CS:N]Grovyle[CR] appear!", french="Et [CS:N]Massko[CR] va sûrement\ns'y rendre!", german="Und es besteht auch die\nMöglichkeit, dass der Dieb [CS:N]Reptain[CR] auftaucht!", italian="E in quel caso, avremmo la\npossibilità di catturare [CS:N]Grovyle[CR]!", spanish="¡Y así tendríamos la posibilidad\nde sorprender a [CS:N]Grovyle[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru, npc_npc_chiriin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(3, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" That's correct.", french=" Exact.", german=" Genau.", italian=" Esattamente.", spanish=" Exactamente."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Those three Pokémon, [CS:N]Uxie[CR],\n[CS:N]Mesprit[CR], and [CS:N]Azelf[CR]...", french="Ces trois Pokémon, [CS:N]Créhelf[CR],\n[CS:N]Créfollet[CR] et [CS:N]Créfadet[CR]...", german="Diese drei Pokémon, [CS:N]Selfe[CR],\n[CS:N]Vesprit[CR] und [CS:N]Tobutz[CR]...", italian="Si dice che [CS:N]Uxie[CR],\n[CS:N]Mesprit[CR] e [CS:N]Azelf[CR]...", spanish="Se dice que estos tres Pokémon:\n[CS:N]Uxie[CR], [CS:N]Mesprit[CR] y [CS:N]Azelf[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="All three are said to dwell\nat lakes.", french="... ont tous trois la réputation\nde résider près d'un lac.", german="Sie sollen alle drei an Seen\nleben.", italian="... si trovino tutti in prossimità\ndi un lago.", spanish=" Habitan en lagos."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="It's a fact that both [CS:N]Uxie[CR] and\n[CS:N]Mesprit[CR] were encountered at lakes.", french="Nous savons d'ores et déjà que\nc'est bien le cas de [CS:N]Créhelf[CR] et [CS:N]Créfollet[CR].", german="Tatsächlich wurden sowohl [CS:N]Selfe[CR]\nals auch [CS:N]Vesprit[CR] an Seen angetroffen.", italian="Non a caso, sia [CS:N]Uxie[CR] che [CS:N]Mesprit[CR]\nsi trovavano presso un lago.", spanish="Ya hemos comprobado que tanto\n[CS:N]Uxie[CR] como [CS:N]Mesprit[CR] vivían en uno."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="As such, I believe that [CS:N]Azelf[CR]\nwill be found at a lake somewhere.", french="Je suis donc enclin à penser\nque nous avons toutes nos chances de trouver\n[CS:N]Créfadet[CR] quelque part près d'un lac.", german="Daher glaube ich, dass [CS:N]Tobutz[CR]\nsich auch an einem See aufhält.", italian="Considerato questo, dobbiamo\ndedurre che anche [CS:N]Azelf[CR] si trovi nei pressi di\nun lago.", spanish="Por tanto, creo que [CS:N]Azelf[CR]\ntambién tiene que estar cerca de algún\nlago."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Let's keep something in mind.\n[CS:N]Uxie[CR]'s lake was located on a high plateau.", french="Il est une chose qu'il ne faut\npoint perdre de vue. Le lac de [CS:N]Créhelf[CR] était\nsitué en altitude.", german="Vergessen wir Folgendes nicht.\nDer See, an dem [CS:N]Selfe[CR] lebt, liegt auf einem\nhochgelegenen Plateau.", italian="Inoltre, vi prego di considerare\nche il lago dove si trovava [CS:N]Uxie[CR] è situato su\nun altopiano.", spanish="Vamos a pensar en esto.\nEl lago de [CS:N]Uxie[CR] estaba en lo alto de\nuna meseta."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CS:N]Mesprit[CR]'s lake was hidden far\nbeneath a desert.", french="Celui de [CS:N]Créfollet[CR] était enfoui\ndans les profondeurs d'un désert.", german="Der See, an dem [CS:N]Vesprit[CR] lebt,\nliegt unter einer Wüste versteckt.", italian="[CS:N]Mesprit[CR] invece si trovava nei\npressi di un lago nascosto nelle profondità del\ndeserto.", spanish="El lago de [CS:N]Mesprit[CR] estaba\nescondido bajo las dunas del desierto."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="In both cases, the lakes were in\nunusual places.", french="En d'autres termes, des lieux\ninattendus, dans les deux cas.", german="In beiden Fällen befinden sich\ndie Seen an ungewöhnlichen Orten.", italian="In sostanza, entrambi i laghi si\ntrovano in posti altamente inusuali.", spanish="En ambos casos, los lagos se\nencontraban en lugares inusuales."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" So the lake where [CS:N]Azelf[CR] lives...", french="Par conséquent, le lac de\n[CS:N]Créfadet[CR]...", german=" Der See, an dem [CS:N]Tobutz[CR] lebt...", italian="Possiamo quindi dedurre che\nanche [CS:N]Azelf[CR] si trovi...", spanish="Así que el lago en el que viva\n[CS:N]Azelf[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="It will be somewhere that we\nleast expect it to be.", french="... doit également se trouver\nquelque part où on ne l'attend point.", german="Er wird irgendwo sein, wo wir\nes am wenigsten erwarten.", italian=" ... in un posto fuori del comune.", spanish="Sin duda estará donde menos\nlo esperemos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="I get it NOW![K] You're saying we\nshouldn't look for water in the usual places!", french="Ça y est, j'ai COMPRIS![K] Vous\npensez qu'on doit chercher dans des endroits\noù il n'y a pas d'eau en temps normal!", german="JETZT verstehe ich es![K]\nDu meinst, wir sollen dort suchen, wo man\nnormalerweise kein Wasser erwarten würde!", italian="Ora capisco![K] Quello che ci\nvuole dire è che dobbiamo cercare dove\nnon ci aspetteremmo di trovare un lago!", spanish="¡Ahora lo pillo![K]\n¡Debemos buscar agua en lugares extraños!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" My, my, my! ♪", french=" Mince alors! ♪", german=" So was aber auch! ♪", italian=" Perdindirindina!", spanish=" ¡Vaya, vaya, vaya! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I commend you on your wisdom,\n[CS:N]Dusknoir[CR], sir!", french="Vous êtes si brillant que j'en\nsuis ébloui, messire [CS:N]Noctunoir[CR]!", german="Deine Weisheit ist\nbeeindruckend, [CS:N]Zwirrfinst[CR]!", italian="Come immaginavo, la sua\nsaggezza è davvero sconfinata, signor\n[CS:N]Dusknoir[CR]!", spanish="Tu sabiduría es digna de elogio,\n[CS:N]Dusknoir[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I feel renewed admiration\nfor you! ♪", french=" J'en reste coi d'admiration! ♪", german="Meine Bewunderung ist größer\ndenn je! ♪", italian="Lei è una fonte d'ispirazione per\ntutti noi!", spanish="¡Cada día siento más admiración\npor ti! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(3, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Thank you...[K] It's really nothing...", french=" Merci...[K] C'est tout naturel...", german="Vielen Dank.[K]\nEs ist nicht der Rede wert.", italian="Grazie...[K] Davvero, non ho fatto\nniente...", spanish=" Gracias...[K] No tiene importancia..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" No, no! We, too, revere you!", french="Non, non! Nous aussi, nous avons\nbeaucoup d'admiration pour vous!", german="Oh doch! Ich bewundere dich\nauch!", italian="No, no! Ha ragione! Lei è un\ngrande!", spanish="Sí que la tiene. También eres\nnuestro ídolo."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="First it was you, [CS:N]Dusknoir[CR], sir,\nwho directed us to the [CS:P]Northern Desert[CR].", french="C'est vous, messire [CS:N]Noctunoir[CR],\nqui avez le premier orienté les recherches\nvers le [CS:P]Désert du Nord[CR].", german="Du warst es ja, [CS:N]Zwirrfinst[CR], der\nuns zuerst zur [CS:P]Nordwüste[CR] geführt hat.", italian="È stato lei, signor [CS:N]Dusknoir[CR], a\nsuggerire che avremmo dovuto recarci al\n[CS:P]Deserto del Nord[CR].", spanish="Fuiste tú, [CS:N]Dusknoir[CR], quien nos\nhizo buscar en el [CS:P]Desierto Norte[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="It turned out that there was a\nTime Gear far below the desert.", french="Il s'est avéré qu'il y avait bel\net bien un Rouage du Temps dans les tréfonds\nde ce désert.", german="Wie sich herausgestellt hat, lag\nunter der Wüste ein Zahnrad der Zeit.", italian="E l'Ingranaggio del Tempo si\ntrovava proprio sotto quel deserto.", spanish="Y al final resultó que había\nun Engranaje del Tiempo bajo las dunas\ndel desierto."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="So, [CS:N]Dusknoir[CR], sir, your insight\nwas entirely correct.", french="Ainsi, messire [CS:N]Noctunoir[CR],\nvotre intuition était avérée.", german="Deine Vermutungen, [CS:N]Zwirrfinst[CR],\nsind voll und ganz korrekt.", italian="Signor [CS:N]Dusknoir[CR], il suo intuito si\nè rivelato infallibile.", spanish="Por tanto, [CS:N]Dusknoir[CR], tu intuición\nresultó ser totalmente correcta."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Ooooh! So maybe the other\nplaces we searched... The Eastern Forest and\n[CS:P]Crystal Cave[CR]...", french="Ben mince alors! Si ça se\ntrouve, les endroits qu'on a explorés...\nla Forêt de l'Est et la [CS:P]Caverne Cristal[CR]...", german="Ooooh! Ich muss an die anderen\nOrte denken, an denen wir suchten... Die\nÖstlichen Wälder und die [CS:P]Kristallhöhle[CR]...", italian="Ooooh! Allora, gli altri posti\ndove abbiamo cercato... la Foresta Orientale e\nla [CS:P]Grotta di Cristallo[CR]...", spanish="¡Ay, ay, ay! Entonces, quizás\nlos otros sitios en los que hemos buscado...\nel Bosque del Este y la [CS:P]Cueva Cristal[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Those places could still be hiding\ntheir secrets from us!", french="On n'a peut-être pas percé leur\nmystère!", german="Diese Orte halten vielleicht noch\ndas ein oder andere Geheimnis vor uns\nversteckt!", italian="... potrebbero ancora nascondere\ndei segreti!", spanish="Quizás esos lugares todavía\noculten algún secreto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(3, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Ah, I have an idea.", french=" Eurêka.", german=" Ah, ich habe eine Idee.", italian=" Ho un'idea.", spanish=" Ah, tengo una idea."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru, npc_npc_bippa, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" [CS:N]Bidoof[CR]...", french=" [CS:N]Keunotor[CR]...", german=" [CS:N]Bidiza[CR]...", italian=" [CS:N]Bidoof[CR]...", spanish=" [CS:N]Bidoof[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_bippa, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_bippa, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_bippa, 4) end)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Yup yup, you want me?", french=" Vous m'avez demandé, pardi?", german=" Jawollja? Ich wurde gerufen?", italian=" Sissignore! Dice a me, signore?", spanish=" ¿Sí, señor?"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" What can I do for you?", french="Qu'est-ce que j'peux faire pour\nvot' bon plaisir?", german=" Was kann ich für dich tun?", italian=" Cosa posso fare per lei?", spanish=" ¿Qué quiere de mí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(3, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" I have a request.", french="J'ai quelque chose à\nte demander.", german=" Ich habe eine Bitte.", italian=" Avrei un favore da chiederti.", spanish=" Debo pedirte algo."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="That crystal you picked up\npreviously...", french=" Le cristal que tu as ramassé...", german="Der Kristall, den du kürzlich\ngefunden hast...", italian=" Il cristallo che hai raccolto...", spanish=" Ese cristal que habías cogido..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" May I borrow it briefly?", french="Puis-je te l'emprunter\nbrièvement?", german=" Darf ich ihn mir kurz ausleihen?", italian=" Potrei prenderlo in prestito?", spanish=" ¿Puedes prestármelo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" My crystal?!", french=" Mon cristal?!", german=" Meinen Kristall?!?", italian=" Il cristallo?!", spanish=" ¡¿Mi cristal?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" N-no! No sirree!", french=" Non! Pas mon cristal, sapristi!", german=" N-nein! Nein, wirklich nicht!", italian=" Oh no! Vi prego no! Nossignore!", spanish=" ¡No! ¡No, señor!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="That's my precious treasure,\nby golly!", french="C'est mon précieux trésor,\npour sûr!", german="Das ist mein kostbarer Schatz!\nJawollja!", italian="Quello è il mio piccolo tesoro,\nohibò!", spanish=" ¡Huy, es mi valioso tesoro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(3, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Of course. [K]But rest assured we\nwon't take it away. Or do anything of the sort.", french="Bien entendu.[K] Rassure-toi,\nje te le rendrai.", german="Natürlich. [K]Ich versichere dir,\ndass wir ihn dir nicht wegnehmen.\nOder irgendetwas dergleichen.", italian="Ma certo.[K] Ti posso assicurare\nche non te lo porteremo via. Non faremo\nniente del genere.", spanish="Ya lo sé.[K] Pero tranquilízate,\nque nadie va a quitártelo ni nada parecido."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Now, [hero]...", french=" Quant à toi, [hero]...", german=" Und nun, [hero]...", italian=" Ora, [hero]...", spanish=" Ahora, [hero]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(180) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="There is something I would like\nyou to do, [hero].", french="... il y a quelque chose que\nj'aimerais que tu fasses.", german="Es gibt da etwas, um das ich\ndich bitten will, [hero].", italian="C'è qualcosa che vorrei che\nfacessi, [hero].", spanish="Hay algo que me gustaría que\nhicieras, [hero]."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Please touch [CS:N]Bidoof[CR]'s crystal.", french=" Touche le cristal de [CS:N]Keunotor[CR].", german="Bitte berühre den Kristall von\n[CS:N]Bidiza[CR].", italian="Vorrei che toccassi il cristallo di\n[CS:N]Bidoof[CR].", spanish=" Toca el cristal de [CS:N]Bidoof[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...!)", french="(...!)", german="(Puh!)", italian="(...!)", spanish="(...)"})
  else
  SkySceneKit.say({english="(...!)", french="(...!)", german="(Puh!)", italian="(...!)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I should touch the crystal...?)", french="(Que je touche le cristal...?)", german="(Ich soll den Kristall anfassen?)", italian="(Vuole che tocchi il cristallo...?)", spanish="(¿Quiere que toque el cristal?)"})
  else
  SkySceneKit.say({english="(I should touch the crystal...?)", french="(Que je touche le cristal...?)", german="(Ich soll den Kristall anfassen?)", italian="(Vuole che tocchi il cristallo...?)", spanish="(¿Quiere que toque el cristal?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(3, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="If a secret remains hidden in\n[CS:P]Crystal Cave[CR]...", french="Si jamais la [CS:P]Caverne Cristal[CR]\nn'a pas révélé tous ses secrets...", german="Wenn die [CS:P]Kristallhöhle[CR] noch ein\nGeheimnis birgt...", italian="Se c'è un segreto nella [CS:P]Grotta di[CR]\n[CS:P]Cristallo[CR]...", spanish="Si hay algún secreto oculto\nen la [CS:P]Cueva Cristal[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="If [hero] touches the\ncrystal...", french="Quand [hero] touchera\nle cristal...", german="Und wenn [hero] den\nKristall berührt...", italian="... quando [hero] toccherà\nil cristallo...", spanish=" Si [hero] toca el cristal..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="It may trigger the Dimensional\nScream. It may trigger a vision!", french="... cela déclenchera peut-être\nle Cri Dimensionnel! Une vision qui nous\nen apprendra davantage!", german="Dann wird vielleicht der\nDimensionale Schrei ausgelöst.\nVielleicht wird eine Vision ausgelöst!", italian="... è possibile che venga attivato\nlo Squarcio Dimensionale.", spanish="Igual puede utilizar la\nPercepción de Cronos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I see. That's what this is about...)", french="(Je vois. C'est donc de ça qu'il s'agit...)", german="(Ich verstehe. Darum geht es also...)", italian="(Adesso capisco. Ecco il perché...)", spanish="(Ya veo lo que pretende.)"})
  else
  SkySceneKit.say({english="(I see. That's what this is about...)", french="(Je vois. C'est donc de ça qu'il s'agit...)", german="(Ich verstehe. Darum geht es also...)", italian="(Adesso capisco. Ecco il perché...)", spanish="(Ya veo lo que pretende.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Dimensional Scream?[K]\nWhat's THAT?", french="Le Cri Dimensionnel?[K] C'est QUOI,\nça?", german="Dimensionaler Schrei?[K]\nWas ist DAS?", italian="Squarcio Dimensionale?[K] E che\nsarebbe?", spanish="¿La Percepción de Cronos?[K]\n¿Qué es eso?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Left)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's a special ability that\n[hero] has.", french="C'est une faculté particulière\nque détient [hero].", german="Es ist eine besondere Fähigkeit\nvon [hero].", italian="È il nome di un potere posseduto\nda [hero].", spanish="Es una habilidad especial de\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's a special ability that\n[hero] has.", french="C'est une faculté particulière\nque détient [hero].", german="Es ist eine besondere Fähigkeit\nvon [hero].", italian="È il nome di un potere posseduto\nda [hero].", spanish="Es una habilidad especial de\n[hero]."})
  else
  SkySceneKit.say({english="It's a special ability that\n[hero] has.", french="C'est une faculté particulière\nque détient [hero].", german="Es ist eine besondere Fähigkeit\nvon [hero].", italian="È il nome di un potere posseduto\nda [hero].", spanish="Es una habilidad especial de\n[hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Sometimes, when [hero]\ntouches something...", french="Parfois, quand [hero]\ntouche quelque chose...", german="Manchmal, wenn [hero]\netwas berührt...", italian="A volte, quando [hero]\ntocca qualcosa...", spanish="A veces, cuando [hero]\ntoca algo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Sometimes, when [hero]\ntouches something...", french="Parfois, quand [hero]\ntouche quelque chose...", german="Manchmal, wenn [hero]\netwas berührt...", italian="A volte, quando [hero]\ntocca qualcosa...", spanish="A veces, cuando [hero]\ntoca algo..."})
  else
  SkySceneKit.say({english="Sometimes, when [hero]\ntouches something...", french="Parfois, quand [hero]\ntouche quelque chose...", german="Manchmal, wenn [hero]\netwas berührt...", italian="A volte, quando [hero]\ntocca qualcosa...", spanish="A veces, cuando [hero]\ntoca algo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Then [hero] has a vision\nof an event in the past or the future that\ninvolves it.", french="... cela lui permet de voir\ndes événements passés ou futurs liés à l'objet\nen question!", german="Dann hat [hero] eine\nVision von einem Ereignis aus der\nVergangenheit... Oder der Zukunft!", italian="... è in grado di vedere un\nevento passato o futuro in qualche modo\ncollegato a quell'oggetto.", spanish="Tiene una visión relacionada\ncon el pasado o el futuro de lo que ha tocado,\n¿verdad, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Then [hero] has a vision\nof an event in the past or the future that\ninvolves it.", french="... cela lui permet de voir\ndes événements passés ou futurs liés à l'objet\nen question!", german="Dann hat [hero] eine\nVision von einem Ereignis aus der\nVergangenheit... Oder der Zukunft!", italian="... è in grado di vedere un\nevento passato o futuro in qualche modo\ncollegato a quell'oggetto.", spanish="Tiene una visión relacionada\ncon el pasado o el futuro de lo que ha tocado,\n¿verdad, [hero]?"})
  else
  SkySceneKit.say({english="Then [hero] has a vision\nof an event in the past or the future that\ninvolves it.", french="... cela lui permet de voir\ndes événements passés ou futurs liés à l'objet\nen question!", german="Dann hat [hero] eine\nVision von einem Ereignis aus der\nVergangenheit... Oder der Zukunft!", italian="... è in grado di vedere un\nevento passato o futuro in qualche modo\ncollegato a quell'oggetto.", spanish="Tiene una visión relacionada\ncon el pasado o el futuro de lo que ha tocado,\n¿verdad, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  -- message_FacePositionOffset(-3, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Oh my gosh! Really?", french=" Ben mince alors! C'est vrai?", german=" Auweia! Wirklich?", italian=" Oooh, davvero?", spanish=" ¿No me digas? O sea, ¿en serio?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey, hey! There's really\nan ability like that?", french="Eh dis donc, ça existe vraiment,\nun tel pouvoir?", german="Hey, hey, hey! So eine Fähigkeit\ngibt es wirklich?", italian="Ehi, ehi, ehi! Ma c'è davvero un\npotere che lo rende possibile?", spanish="¡Oye, oye, oye!\n¿Realmente existe esa habilidad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru, npc_npc_bippa, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(3, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I desperately wish to borrow the\ncrystal because of [hero]'s ability.", french="C'est pour cette raison que\nje souhaite ardemment emprunter le cristal.", german="Wegen dieser Fähigkeit von\n[hero] will ich den Kristall unbedingt\nausleihen.", italian="È per cercare di sfruttare il\npotere di [hero] che ho chiesto in\nprestito il cristallo.", spanish="Por eso es imprescindible que\nutilicemos la habilidad de [hero] con\nese cristal."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Please, may we?", french=" Si tu me permets?", german=" Bitte, leihst du ihn uns?", italian=" Ti prego, ce lo presteresti?", spanish=" ¿Nos permites?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_bippa, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_bippa, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_bippa, 4) end)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  GROUND:EntTurn(npc_npc_bippa, Direction.Down)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  GROUND:EntTurn(npc_npc_bippa, Direction.Left)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  GROUND:EntTurn(npc_npc_bippa, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Oof...[K] OK, I can't refuse a\nreason like that!", french="Pfiou...[K] Impossible d'refuser\navec une raison pareille!", german="Uff...[K] Okay, zu so einer\nBegründung kann ich nicht nein sagen!", italian="Puff...[K] D'accordo, ohibò. Non\nposso proprio dire di no.", spanish="Uf...[K] De acuerdo,\n¡no puedo negarme con una razón así!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_bippa, 460, 232, false, 1)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_perappu, 432, 212, false, 2) -- SlidePositionMark (glissement)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_bippa, Direction.DownRight)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(6410) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="[CN][CS:N]Bidoof[CR] turned over\n[CN]the crystal to [hero].", french="[CN][CS:N]Keunotor[CR] confie\n[CN]le cristal à [hero].", german="[CN][CS:N]Bidiza[CR] reicht\n[CN][hero] den Kristall.", italian="[CN][CS:N]Bidoof[CR] consegna il cristallo a [hero].", spanish="[CN][CS:N]Bidoof[CR] entregó\n[CN]el cristal a [hero]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(This crystal...)", french="(Ce cristal...)", german="(Dieser Kristall...)", italian="(Il cristallo...)", spanish="(Este cristal...)"})
  else
  SkySceneKit.say({english="(This crystal...)", french="(Ce cristal...)", german="(Dieser Kristall...)", italian="(Il cristallo...)", spanish="(Este cristal...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What will it reveal...?)", french="(Que va-t-il nous apprendre...?)", german="(Was wird er mir zeigen?)", italian="(Cosa rivelerà il cristallo?)", spanish="(¿Qué revelará?)"})
  else
  SkySceneKit.say({english="(What will it reveal...?)", french="(Que va-t-il nous apprendre...?)", german="(Was wird er mir zeigen?)", italian="(Cosa rivelerà il cristallo?)", spanish="(¿Qué revelará?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(45)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(45)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(45)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Everyone's watching...)", french="(Tous les regards sont tournés vers moi...)", german="(Alle sehen mir zu...)", italian="(Mi stanno guardando tutti...)", spanish="(Todos me están mirando...)"})
  else
  SkySceneKit.say({english="(Everyone's watching...)", french="(Tous les regards sont tournés vers moi...)", german="(Alle sehen mir zu...)", italian="(Mi stanno guardando tutti...)", spanish="(Todos me están mirando...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I don't know if I will see anything, but...)", french="(Je ne sais pas si je vais avoir une vision\nou pas, mais...)", german="(Ich weiß nicht, ob ich etwas sehen werde,\naber...)", italian="(Non so se sarò in grado di vedere\nqualcosa...)", spanish="(No sé si veré algo, pero...)"})
  else
  SkySceneKit.say({english="(I don't know if I will see anything, but...)", french="(Je ne sais pas si je vais avoir une vision\nou pas, mais...)", german="(Ich weiß nicht, ob ich etwas sehen werde,\naber...)", italian="(Non so se sarò in grado di vedere\nqualcosa...)", spanish="(No sé si veré algo, pero...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I need to concentrate...)", french="(... il faut que je me concentre...)", german="(Ich muss mich konzentrieren...)", italian="(Devo concentrarmi...)", spanish="(Necesito concentrarme.)"})
  else
  SkySceneKit.say({english="(I need to concentrate...)", french="(... il faut que je me concentre...)", german="(Ich muss mich konzentrieren...)", italian="(Devo concentrarmi...)", spanish="(Necesito concentrarme.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...............)", french="(...............)", german="(...............)", italian="(...............)", spanish="(...)"})
  else
  SkySceneKit.say({english="(...............)", french="(...............)", german="(...............)", italian="(...............)", spanish="(...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 4) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Well, [hero]?", french=" Alors, [hero]?", german=" Nun, [hero]?", italian=" Beh, [hero]?", spanish=" ¿Y bien, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Well, [hero]?", french=" Alors, [hero]?", german=" Nun, [hero]?", italian=" Allora, [hero]?", spanish=" ¿Y bien, [hero]?"})
  else
  SkySceneKit.say({english=" Well, [hero]?", french=" Alors, [hero]?", german=" Nun, [hero]?", italian=" Allora, [hero]?", spanish=" ¿Y bien, [hero]?"})
  end
  -- message_Close
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Here it comes...)", french="(Ça vient...)", german="(Es geht los...)", italian="(Ecco che arriva...)", spanish="(Noto algo.)"})
  else
  SkySceneKit.say({english="(Here it comes...)", french="(Ça vient...)", german="(Es geht los...)", italian="(Ecco che arriva...)", spanish="(Noto algo.)"})
  end
  -- message_Close
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The dizziness is starting...)", french="(Je commence à perdre mes esprits...)", german="(Das Schwindelgefühl kommt...)", italian="(Comincio ad avvertire il capogiro...)", spanish="(Me estoy empezando a marear.)"})
  else
  SkySceneKit.say({english="(The dizziness is starting...)", french="(Je commence à perdre mes esprits...)", german="(Das Schwindelgefühl kommt...)", italian="(Comincio ad avvertire il capogiro...)", spanish="(Me estoy empezando a marear.)"})
  end
  -- message_Close
  GAME:FadeOut(false, 5)
  SkySceneKit.cleanup_npcs()
end
