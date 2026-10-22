-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P03P02A/m10a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Steam Cave.ogg", true) end)
  SkyProg.set(11, 2) -- $SCENARIO_MAIN = scn[11,2] (ROM)
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Meanwhile...", french="[CN]Pendant ce temps...", german="[CN]Währenddessen...", italian="[CN]Nel frattempo...", spanish="[CN]Mientras tanto..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]back at the Groudon statue...", french="[CN]à la statue de Groudon...", german="[CN]An der Statue von Groudon...", italian="[CN]... presso la statua di Groudon...", spanish="[CN]Junto a la estatua de Groudon..."})
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_P03P02A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitBgm
  -- GAP: BGM BGM_RAIN2 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 408, 488, Direction.DownLeft, "NPC_ZUBATTO")
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Psst... Hey, Chief![K] What's going\non? Something wrong?", french="Psst... Eh, chef![K] Qu'est-ce qui\nse passe? Il y a un problème?", german="Psst... Hey, Boss![K] Was ist los?\nStimmt etwas nicht?", italian="Psst... Ehi, capo![K] Che succede?\nQualcosa non va?", spanish=" Pss... ¡Eh, Jefe![K] ¿Qué pasa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 360, 504, Direction.Down, "NPC_DOGAASU")
  GROUND:EntTurn(npc_npc_dogaasu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Chief... Hey, Chief... You've been\nstaring him down for how long now...?", french="Chef... Eh, chef... Ça fait\ncombien de temps que vous le fixez du regard\ncomme ça...?", german="Boss... Hey, Boss. Wie lange\nstarrst du ihn jetzt schon an?", italian="Capo... Ehi, capo! L'hai fissato\nabbastanza, non credi?", spanish="Jefe... ¡Jefe!\n¿Cuánto tiempo llevas mirándolo fijamente?"})
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="C'mon...let's you and I give him\na double dose of the ol' noxious gas...", french="Allez... on a qu'à lui balancer\nune double dose de notre bon vieux gaz\nnauséabond...", german="Komm schon, nebeln wir ihn\nso richtig mit unserer guten alten\nSpezial-Kombo ein...", italian="Eddai... diamogli una bella dose\ndel nostro buon vecchio gas!", spanish="¡Venga! Vamos a darle una buena\nración de gases nocivos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 384, 504, Direction.Down, "NPC_SUKATANKU")
  pcall(function() GROUND:CharSetEmote(npc_npc_sukatanku, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" Shhh! Shut your yap!", french=" Chut! Ferme ton clapet!", german=" Psst! Halt die Klappe!", italian=" Shhh! Chiudi quella boccaccia!", spanish=" ¡Chist! ¡A callar!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 368, 544, Direction.Up, "NPC_PUKURIN")
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Down)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Dear friends! What's wrong?[K]\nYou've been making such scary faces at me!", french="Que se passe-t-il, mes bons\namis?[K] C'est la soupe à la grimace ou quoi?", german="Liebe Freunde! Was ist los?[K]\nIhr seht mich die ganze Zeit so unheimlich an!", italian="Cari amici! Qualcosa non va?[K]\nAvete certe facce!", spanish="¡Amigos míos! ¿Qué pasa?[K]\n¡Vaya caras de susto que tenéis!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_sukatanku, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Bah...[K]this guy's tough...[K]\nreally tough...", french="Bah...[K] c'est un coriace...[K]\nil est vraiment balaise...", german="Bah...[K] Der Typ ist eine harte\nNuss...[K] Echt hart...", italian="Bah...[K] Questo è davvero...[K]\nun tipo tosto...", spanish="Madre mía...[K] Este tipo es duro...[K]\nMuy duro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="I get it![K] You're trying to make\nme laugh with silly faces!", french="J'ai compris![K] Vous essayez\nde me faire rire avec vos grimaces!", german="Jetzt verstehe ich![K] Ihr wollt\nmich mit lustigen Grimassen zum Lachen\nbringen!", italian="Ho capito! ♪[K] È una gara a chi\nride per primo, vero? ♪", spanish="¡Ahora lo pillo![K] ¡Estáis poniendo\nesas caras para que me ría!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" I bet I can make you laugh too!", french="Je parie que je peux vous faire\nrire, moi aussi!", german="Ich wette, ich kann euch auch\nzum Lachen bringen!", italian="Adesso mi metto anch'io a farvi\ndelle smorfie!", spanish="Seguro que yo también puedo\nhaceros reír."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Blabba! ♪ Blabba! ♪ Blapp! ♪", french=" Blabba! ♪ Blabba! ♪ Blapp! ♪", german=" Blabba! ♪ Blabba! ♪ Blapp! ♪", italian=" Blabba! ♪ Blabba! ♪ Blapp! ♪", spanish=" ¡Blabla! ♪ ¡Blabla! ♪ ¡Bla! ♪"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Blobba! ♪ Blobba! ♪ Blopp! ♪", french=" Blobba! ♪ Blobba! ♪ Blopp! ♪", german=" Blobba! ♪ Blobba! ♪ Blopp! ♪", italian=" Blobba! ♪ Blobba! ♪ Blopp! ♪", spanish=" ¡Blubla! ♪ ¡Blubla! ♪ ¡Blo! ♪"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogaasu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dogaasu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" C'mon, Chief...!", french=" Allez, chef...!", german=" Komm schon, Boss!", italian=" Eddai capo...!", spanish=" ¡Ya está bien, Jefe!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="I can't take this...this whole\nweird scene is freaking me out...", french="C'en est trop... toutes\nces bizarreries me flanquent la frousse...", german="Ich halte das nicht aus. Diese\nschräge Szene macht mich wahnsinnig...", italian="Non ne posso più... Questa\nscenetta è troppo stupida...!", spanish="Ya no lo aguanto más.\nToda esta escenita me está volviendo loco."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="OK, then...this isn't working, and\nwe're out of options...", french="Bon, je vois... ça ne marche pas,\net on n'a pas d'autre solution...", german="Na gut. Es klappt nicht und wir\nhaben keine andere Wahl mehr...", italian="Mmm... Non sta funzionando.\nDevo farmi venire in mente qualcosa...", spanish="Vale, evidentemente esto no\nestá funcionando, y ya no nos quedan más\nopciones."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Down)
  pcall(function() SOUND:FadeOutBGM(30) end)
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" Hey, [CS:N]Wigglytuff[CR]!", french=" Eh, [CS:N]Grodoudou[CR]!", german=" Hey, [CS:N]Knuddeluff[CR]!", italian=" Ehi, [CS:N]Wigglytuff[CR]!", spanish=" ¡Eh, [CS:N]Wigglytuff[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Whatiswhatiswhatis...what is it?", french="Quesquiquesquiquesqui...\nqu'est-ce qui se passe?", german="Wasistwasistwasist... was\ndenn?", italian=" Cosacosacosa... cosa c'è?", spanish=" ¿Qué? ¿Qué? ¿Qué pasa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Hey, no hard feelings, but...[K]\nYou're going down!", french="Eh, ça n'a rien de personnel\nmais...[K] on va te mettre une raclée!", german="Hey, nichts für ungut, aber...[K]\nJetzt bist du dran!", italian="Niente di personale, vecchio mio,\nma...[K] Ora te la facciamo vedere noi!", spanish="No nos guardes rencor, pero...[K]\n¡vamos a acabar contigo!"})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Take this![K] A noxious-gas special!\nStraight from me and [CS:N]Koffing[CR]!", french="Prends ça![K] La spécialité maison!\nUn cocktail au gaz nauséabond! De notre part,\nà [CS:N]Smogo[CR] et moi!", german="Nimm das![K] Eine giftige\nGas-Spezial-Kombo von mir und [CS:N]Smogon[CR]!", italian="Beccati questa![K] Una bella dose\ndi gas puzzolente dal sottoscritto e dal buon\nvecchio [CS:N]Koffing[CR]!", spanish="¡Aquí tienes![K] ¡[CS:N]Koffing[CR] y yo te\ndedicamos esta combinación de gases nocivos!"})
  -- message_Close
  -- SetAnimation(12) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  -- GAP: se_Play(6913) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_G01P03A2_104) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  -- se_FadeOut(6913, 120) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  SkySubScreen.Hide(30) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:WaitFrames(90)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  SkySubScreen.Hide(0) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:WaitFrames(2) -- join WaitSe
  -- main_EnterDungeon(14, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
