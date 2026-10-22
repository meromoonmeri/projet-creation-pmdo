-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P01C/m11a0303.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P06A) [décor sub chargé: Sub_v02p06a]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v02p06a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(150)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_G01P01C) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_FIRE_CRACKLING_LOUDER non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  GAME:WaitFrames(30)
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 240, 328, Direction.Up, "NPC_SUKATANKU")
  GROUND:MoveToPosition(npc_npc_sukatanku, 240, 212, false, 2)
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 216, 368, Direction.Up, "NPC_ZUBATTO")
  GROUND:MoveToPosition(npc_npc_zubatto, 216, 236, false, 2)
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 264, 352, Direction.Up, "NPC_DOGAASU")
  GROUND:MoveToPosition(npc_npc_dogaasu, 264, 236, false, 2)
  GAME:WaitFrames(30)
  pcall(function() GAME:MoveCamera(240, 220, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_zubatto, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, npc_npc_sukatanku, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Ch-Ch-Chief...[K] We were really\nput in our place on that last expedition...[K] Urk!", french="Ch... chef...[K] On s'est\nvraiment fait remettre à notre place\npendant la dernière expédition...[K] Argh!", german="B-b-boss...[K] Auf der letzten\nExpedition haben wir unser Fett wirklich\nwegbekommen...[K] Urk!", italian="C-C-Capo...[K] le abbiamo proprio\nprese in quella spedizione...[K] Ohi!", spanish="Je... Je... Jefe...[K]\nRealmente nos han dado para el pelo\nen la última expedición...[K] ¡Ay!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- MoveHeight(1, 2) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(1, 0) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2)
  -- MoveHeight(1, 2) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(1, 0) [élévation d'objet NDS non simulée - documenté]
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Chaw-haw-haw... [CS:N]Wigglytuff[CR]\nwrecked us...", french="Gnark gnark gnark... [CS:N]Grodoudou[CR]\nnous a démolis...", german="Cha-ha-ha... [CS:N]Knuddeluff[CR] hat uns\nden Rest gegeben...", italian="Ohi ohi ohi... [CS:N]Wigglytuff[CR] ci ha\ndato una bella lezione.", spanish="¡Ay!... [CS:N]Wigglytuff[CR] nos ha dado\nuna buena paliza."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="And I'm not about to let it go!\nSo humiliating! I need payback...[K]one way\nor another.", french="Et je n'ai pas l'intention de\nlaisser passer ça! Quelle humiliation! Il faut\nque je me venge...[K] coûte que coûte.", german="Und ich denke nicht daran, es zu\nvergessen! Wie erniedrigend! Ich will Rache.[K]\nAuf die eine oder andere Weise. Ganz egal wie!", italian="Però non sono disposto ad\narrendermi! Che umiliazione! Avrò la mia\nvendetta...[K] in un modo o nell'altro.", spanish="¡No pienso dejarlo estar!\n¡Qué humillación! Necesito vengarme...[K]\n¡Como sea!"})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="But, to be brutally honest, we\ndon't stand a chance against [CS:N]Wigglytuff[CR].", french="Mais, pour être tout à fait\nhonnête, on n'a aucune chance contre\n[CS:N]Grodoudou[CR].", german="Aber um ehrlich zu sein, wir\nhaben keine Chance gegen [CS:N]Knuddeluff[CR].", italian="Devo dire la verità...[K] Non\nabbiamo speranza di battere [CS:N]Wigglytuff[CR].", spanish="Pero, para qué engañarnos...\nNo tenemos ni la menor oportunidad\ncontra [CS:N]Wigglytuff[CR]."})
  -- message_KeyWait
  -- MoveHeight(1, 2) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(1, 0) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2)
  -- MoveHeight(1, 2) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(1, 0) [élévation d'objet NDS non simulée - documenté]
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Grrrrr![K] I'm so furious! It's\nburning me up!", french="Grrrrr![K] J'enrage!\nÇa me rend fou!", german="Grrrrr![K] Ich bin so wütend!\nEs frisst mich auf!", italian="Grrrrr![K] E questo mi rende\nancora più furioso!", spanish="¡Grrr![K] ¡Qué rabia me da!\n¡Esto me está amargando!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_sukatanku, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogaasu, npc_npc_sukatanku, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Whoa-ho-ho! There's gotta be\nsome way we can get back at 'em!", french="Mouarf mouarf mouarf! Il y a\nforcément un moyen de prendre notre\nrevanche!", german="Whoahoho! Es muss einen Weg\ngeben, es ihm heimzuzahlen!", italian="Uooh-oh-oh! Ci dev'essere un\nmodo per fargliela pagare!", spanish="Tiene que haber alguna forma\nde vengarnos de ellos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Heh-heh-heh! I'd settle for\npicking on wimps. Oh! Hey!", french="Hin hin hin! Je suggère qu'on\naille s'amuser en persécutant des avortons!\nOh, je sais!", german="Hehehe! Ich würde lieber nur\nauf Schwächlingen herumhacken. Oh! Hey!", italian="Eh-eh-eh! Secondo me è\nmeglio prendersela con i più deboli!", spanish="¡Jue, jue, jue! A mí me basta\ncon meterme con los debiluchos. ¡Ah!\n¡Oídme!"})
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Instead of [CS:N]Wigglytuff[CR],\nhow about we take revenge on the wimps in\nthat Team [team:]?", french="Et si on se vengeait sur\nles poules mouillées de l'Equipe [team:]\nplutôt que sur [CS:N]Grodoudou[CR]?", german="Wie wäre es, wenn wir uns an\nden Schwächlingen von Team [team:]\nrächen, anstatt an [CS:N]Knuddeluff[CR]?", italian="Lasciamo perdere [CS:N]Wigglytuff[CR] e\nprendiamocela con quei pivelli del\nTeam [team:]!", spanish="En vez de enfrentarnos a\n[CS:N]Wigglytuff[CR], ¿por qué no nos metemos\ncon el [CS:X]Equipo[CR] [team:]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_sukatanku, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_sukatanku, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" Chaw-haw![K] Great idea!", french=" Gnark gnark![K] Excellente idée!", german=" Cha-ha![K] Tolle Idee!", italian=" Ahr-ahr-ahr![K] Ottima idea!", spanish=" ¡Jua, jua![K] ¡Buena idea!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Whoa-ho-ho! And we know that\nTeam [team:] is wimpy!", french="Mouarf mouarf mouarf!\nEt en plus, avec l'Equipe [team:],\non prend pas de risques!", german="Whoahoho! Und wir wissen ja,\ndass Team [team:] aus Feiglingen besteht!", italian="Uooh-oh-oh! È vero! Quelle\nschiappe del Team [team:]!", spanish="¡Jo, jo! ¡Y ya sabemos lo flojo\nque es el [CS:X]Equipo[CR] [team:]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Time to do some plotting, boys!\nChaw-haw-haw!", french="C'est le moment de préparer\nun mauvais coup! Gnark gnark gnark!", german="Es ist Zeit, einen Plan zu\nschmieden, Jungs! Cha-ha-ha!", italian="Andiamo a combinare un po' di\ndanni, ragazzi! Ahr-ahr-ahr!", spanish="Es hora de tramar algo,\nmuchachos. ¡Jua, jua, jua!"})
  -- message_Close
  do local p=npc_npc_sukatanku.Position; GROUND:MoveToPosition(npc_npc_sukatanku, p.X+(0), p.Y+(150), false, 2) end
  GROUND:EntTurn(npc_npc_zubatto, Direction.Down)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Down)
  GAME:WaitFrames(45)
  do local p=npc_npc_zubatto.Position; GROUND:MoveToPosition(npc_npc_zubatto, p.X+(0), p.Y+(150), false, 2) end
  GAME:WaitFrames(10)
  do local p=npc_npc_dogaasu.Position; GROUND:MoveToPosition(npc_npc_dogaasu, p.X+(0), p.Y+(150), false, 2) end
  GAME:WaitFrames(45)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
