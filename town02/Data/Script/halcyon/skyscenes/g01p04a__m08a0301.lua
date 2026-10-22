-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m08a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SkyProg.set(9, 1) -- $SCENARIO_MAIN = scn[9,1] (ROM)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P04A, 'UM08') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Ahem! Now then.", french=" Hum hum! L'heure est venue!", german=" Ähem! Nun dann.", italian=" Ahem! Bene.", spanish=" ¡Ejem! Veamos."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I shall announce the expedition\nmembers at this time.", french="Je vais annoncer les noms des\nmembres de l'expédition.", german="Ich werde nun die\nExpeditionsmitglieder bekanntgeben.", italian="Sto per annunciare i nomi di\ncoloro che parteciperanno alla spedizione.", spanish="Voy a anunciar ahora mismo\nlos miembros de la expedición."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(-16), p.Y+(0), false, 2) end
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 424, 208, Direction.Down, "NPC_PUKURIN")
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Guildmaster, the memo, please.", french=" Maître, la liste, je vous prie.", german=" Gildenmeister, die Liste, bitte.", italian=" Capitano, l'elenco, per favore.", spanish="Gran Bluff... El informe,\npor favor."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CN][CS:N]Chatot[CR] accepted the memo\n[CN]bearing the names of the expedition\n[CN]members from [CS:N]Wigglytuff[CR].", french="[CN][CS:N]Grodoudou[CR] donne à [CS:N]Pijako[CR] la liste sur\n[CN]laquelle sont notés les noms des membres\n[CN]qui participeront à l'expédition.", german="[CN][CS:N]Plaudagei[CR] nimmt die Liste mit den\n[CN]Namen der Expeditionsmitglieder\n[CN]von [CS:N]Knuddeluff[CR] entgegen.", italian="[CN][CS:N]Chatot[CR] riceve l'elenco con i nomi\n[CN]dei partecipanti alla spedizione\n[CN]da [CS:N]Wigglytuff[CR].", spanish="[CN][CS:N]Chatot[CR] cogió el informe con los miembros\n[CN]de la expedición de [CS:N]Wigglytuff[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(28), p.Y+(0), false, 2) end
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- GAP: se_Play(5124) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(28) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The chosen members are written\non this memo.", french="Les noms des membres choisis\nsont notés sur cette liste.", german="Die ausgewählten Mitglieder sind\nhier aufgelistet.", italian="I nomi dei Pokémon prescelti\nsono scritti su quest'elenco.", spanish="Los nombres de los seleccionados\nestán en este informe."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Step forward if your name\nis called.", french="A l'annonce de votre nom,\navancez de quelques pas.", german="Tretet vor, wenn euer Name\naufgerufen wird.", italian="Se sentite il vostro nome,\nfate un passo avanti.", spanish="Dad un paso al frente cuando\ndiga vuestro nombre."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:FadeOutBGM(120) end)
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(hero, Direction.Left)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 424, 256, Direction.Up, "NPC_BIPPA")
  GROUND:EntTurn(npc_npc_bippa, Direction.DownRight)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 456, 256, Direction.Up, "NPC_KIMAWARI")
  GROUND:EntTurn(npc_npc_kimawari, Direction.Down)
  GAME:WaitFrames(5)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 456, 272, Direction.Up, "NPC_DIGUDA")
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Up, "NPC_DOGOOMU")
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 392, 256, Direction.Up, "NPC_CHIRIIN")
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  GAME:WaitFrames(5)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 392, 272, Direction.Up, "NPC_HEIGANI")
  GROUND:EntTurn(npc_npc_heigani, Direction.Left)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 360, 272, Direction.UpRight, "NPC_DAGUTORIO")
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Right)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownRight)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Ooh... It's finally happening.", french="Oooh... Ça y est, c'est le grand\nmoment. Ben mince alors, je suis trop\nnerveuse!", german=" Uuh... Endlich ist es so weit.", italian=" Ooh... Finalmente.", spanish=" Ooh... ¡Por fin llegó el momento!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" My heart's a-pounding, by golly.", french="Sapristi, j'ai l'cœur qui bat\nà toute vitesse.", german="Mein Herz schlägt wie verrückt,\nMenschenskind!", italian=" Ohibò, mi batte forte il cuore.", spanish=" Huy, cómo me late el corazón."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitBgm
  -- SetAnimation(29) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Without further ado, I will\nannounce those who've been chosen.", french="Sans plus attendre, voici les\nheureux élus.", german="Ich werde ohne weitere\nUmschweife bekanntgeben, wer ausgewählt\nwurde.", italian="Senza ulteriore indugio, ecco\ni nomi.", spanish="Sin más preámbulos, anunciaré\nlos nombres de los elegidos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownRight)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 336, 232, Direction.Right, "NPC_SUKATANKU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sukatanku, npc_npc_perappu, 4) end)
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 312, 224, Direction.DownRight, "NPC_ZUBATTO")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, npc_npc_perappu, 4) end)
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 312, 248, Direction.Right, "NPC_DOGAASU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogaasu, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Our first member...[K][CS:N]Loudred[CR]! ♪", french="Le premier membre...[K]\n[CS:N]Ramboum[CR]! ♪", german="Unser erstes Mitglied ist...\n[K][CS:N]Krakeelo[CR]! ♪", italian="Il primo è...\n[K][CS:N]Loudred[CR]! ♪", spanish="Nuestro primer miembro es...[K]\n¡[CS:N]Loudred[CR]! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sukatanku, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, npc_npc_dogoomu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogaasu, npc_npc_dogoomu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Y-yes! I DID IT!", french=" Ouais! J'AI REUSSI!", german=" J-ja! GESCHAFFT!", italian=" S-Sì! CE L'HO FATTA!", spanish=" ¡Sí! ¡LO CONSEGUÍ!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(-24), p.Y+(-24), false, 2) end -- Move2PositionOffset
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_diguda, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  GROUND:EntTurn(npc_npc_guregguru, Direction.UpRight)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GROUND:EntTurn(npc_npc_sukatanku, Direction.UpRight)
  GROUND:MoveToPosition(npc_npc_dogoomu, 392, 204, false, 2)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="But if you really think about it,\nit's only NATURAL that I would get picked!", french="Mais bon, après tout, c'était\nEVIDENT que j'allais être choisi!", german="Aber wenn ich darüber\nnachdenke, war ja KLAR, dass ich ausgewählt\nwerden würde!", italian="Ma a pensarci bene, la\ncosa è abbastanza OVVIA!", spanish="Pero, pensándolo bien, ¡era\ncompletamente lógico que me escogieran!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" WOO-HOOOO!", french=" YOUHOU!", german=" JUCH-HUUU!", italian=" WOO-HOOOO!", spanish=" ¡Qué bien!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "sweatdrop", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "sweatdrop", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweatdrop", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "sweatdrop", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" (Says you...)", french=" (Pff... C'est toi qui le dis...)", german=" (Das sagst du...)", italian=" (Questo lo pensi tu...)", spanish=" (Ya, ya...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" (Big talker, yup yup.)", french=" (Vantard, ouais!)", german=" (Angeber, jawollja.)", italian=" (Che sbruffone, già, già.)", spanish=" (Todo un bocazas. Sí, señor.)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="(Is he saying that he wasn't\neven nervous?)", french="(Il veut nous faire croire qu'il\nn'était pas du tout nerveux? Mais bien sûr...)", german="(Soll das heißen, dass er nicht\nmal nervös war?)", italian="(Vuole farci credere che non era\nneanche un po' nervoso?)", spanish="(¿Quiere que nos creamos que\nno estaba ni un poco nervioso?)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Next up is...[K][CS:N]Corphish[CR]! ♪", french=" Le suivant est...[K] [CS:N]Ecrapince[CR]! ♪", german="Als Nächstes kommt...\n[K][CS:N]Krebscorps[CR]! ♪", italian=" Il prossimo è...[K] [CS:N]Corphish[CR]! ♪", spanish=" El siguiente es... [K]¡[CS:N]Corphish[CR]! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sukatanku, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogaasu, npc_npc_heigani, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey, hey! Got it!", french=" Saperlipopince! J'ai réussi!", german=" Hey, hey, hey! Geschafft!", italian=" Ehi, ehi, ehi! Ce l'ho fatta!", spanish=" ¡Mira, mira! ¡Lo logré!"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="I got picked! Hey, hey![K]\n(Whew, that's a relief...)", french="J'ai été choisi, dis donc![K]\n(Waouh, quel soulagement...)", german="Ich wurde ausgewählt!\nHey, hey![K] (Puh, bin ich erleichtert.)", italian="Sono stato scelto! Ehi, ehi![K]\n(Fiuuu, che sollievo...)", spanish="¡Oye, oye! ¡Me han elegido![K]\n(Uf, qué alivio...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_heigani.Position; GROUND:MoveToPosition(npc_npc_heigani, p.X+(-16), p.Y+(-16), false, 2) end -- Move2PositionOffset
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_diguda, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  GROUND:EntTurn(npc_npc_guregguru, Direction.UpRight)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GROUND:EntTurn(npc_npc_sukatanku, Direction.UpRight)
  GROUND:MoveToPosition(npc_npc_heigani, 368, 204, false, 2)
  GROUND:EntTurn(npc_npc_heigani, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Next is...[K] Oh, what's this?", french=" Ensuite...[K] tiens donc?", german=" Der Nächste...[K] Oh, was ist das?", italian="Il prossimo...[K] Oh, e questo\ncos'è?", spanish=" El siguiente es...[K] ¿Cómo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownRight)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sukatanku, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogaasu, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Well this is a surprise![K]\nOur next member is [CS:N]Bidoof[CR]! ♪", french="Eh bien, quelle surprise![K]\nLe membre suivant est [CS:N]Keunotor[CR]! ♪", german="Was für eine Überraschung![K]\nUnser nächstes Mitglied ist [CS:N]Bidiza[CR]! ♪", italian="Ma che sorpresa![K]\nIl prossimo è [CS:N]Bidoof[CR]! ♪", spanish="Bueno, ¡vaya sorpresa![K]\nNuestro siguiente miembro es... ¡[CS:N]Bidoof[CR]! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sukatanku, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogaasu, npc_npc_bippa, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Really?![K] Really and truly?!", french=" Vraiment?![K] Vrai de vrai?!", german="Wirklich?!?[K] Wirklich\nund wahrhaftig?!?", italian=" Davvero?![K] Davvero davvero?!", spanish="¡¿En serio?![K]\n¡¿De verdad de la buena?!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Golly...[K] Me?! I'm going on the\nexpedition?!", french="Sapristi...[K] Moi?! Faire\npartie d'l'expédition?!", german="Menschenskind...[K] Ich?!? Ich gehe\nauf Expedition?!?", italian="Ohibò...[K] Io?! Prendo parte alla\nspedizione?!", spanish="¡Huyuyuy![K] ¡¿Yo?!\n¡¿Voy a ir a la expedición?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_bippa, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Hm?[K] Is anything the matter,\n[CS:N]Bidoof[CR]?", french="Pardon?[K] Il y a un problème,\n[CS:N]Keunotor[CR]?", german=" Hmm?[K] Ist irgendetwas, [CS:N]Bidiza[CR]?", italian="Eh?[K] C'è qualcosa che non va,\n[CS:N]Bidoof[CR]?", spanish=" Hum...[K] ¿Pasa algo, [CS:N]Bidoof[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Come on, step forward.", french=" Allez, avance un peu.", german=" Komm schon, tritt vor.", italian=" Forza, fai un passo avanti.", spanish=" Venga, da un paso al frente."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Urf...[K] I sure want to step up,\nI truly do, but...", french="Arf...[K] Ben j'veux bien avancer,\npour sûr, mais...", german="Urf...[K] Ich will ja vortreten,\nwirklich, aber...", italian="Urf...[K] Vorrei fare un passo\navanti, davvero, ma...", spanish="Uf...[K] Eso quisiera, de verdad,\npero es que..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I'm feeling a might overwhelmed\nhere. My legs aren't moving...", french="... j'suis tellement ému que\nmes pattes veulent pas bouger...", german="Ich bin gerade ganz überwältigt.\nMeine Beine wollen sich nicht bewegen.", italian="Mi sento così sopraffatto\ndall'emozione che... non riesco a muovere\nle zampe.", spanish="Me siento abrumado por la\nemoción. Las piernas no me responden..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="So be it. We'll ignore it and\nmove on.", french="Soit. Peu importe...\nContinuons.", german="Meinetwegen. Ignorieren wir es\nund fahren fort.", italian="Come vuoi. Faremo finta di\nniente e passeremo al prossimo.", spanish="No pasa nada. Fingiremos que\nhas dado un paso al frente... Seguimos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(29) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sukatanku, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogaasu, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Next we have [CS:N]Sunflora[CR] and\n[CS:N]Chimecho[CR]! ♪", french="Ensuite nous avons choisi\n[CS:N]Héliatronc[CR] et [CS:N]Eoko[CR]! ♪", german="Als Nächstes haben wir\n[CS:N]Sonnflora[CR] und [CS:N]Palimpalim[CR]! ♪", italian="I prossimi sono [CS:N]Sunflora[CR] e\n[CS:N]Chimecho[CR]! ♪", spanish="¡A continuación tenemos a\n[CS:N]Sunflora[CR] y a [CS:N]Chimecho[CR]! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(npc_npc_bippa, Direction.Right)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_kimawari, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Oh? Us too?", french=" Oh? Nous aussi?", german=" Oh? Wir auch?", italian=" Oh? Anche noi?", spanish=" ¿Eh? ¿Nosotras también?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Eeek! Oh my gosh!", french="Hiii! J'en crois pas mes pétales!\nGénial! Trop cool!", german=" Ieek! Auweia!", italian=" Ehi! Shock!", spanish="¡Ay, que me da!\n¡Estoy supercontenta!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_chiriin, 376, 228, false, 2)
  GROUND:MoveToPosition(npc_npc_kimawari, 400, 228, false, 2)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_diguda, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_guregguru, Direction.UpRight)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GROUND:EntTurn(npc_npc_sukatanku, Direction.Right)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(190) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Erm, yes... And there we have\nthe expedition party members!", french="Hum, oui... Et voilà, les\nmembres de l'expédition ont été nommés!", german="Äh, ja... Und damit ist das\nExpeditionsteam komplett!", italian="Ehm, sì... E questi sono i membri\ndella spedizione!", spanish="Hum, sí... ¡Y esos son\nlos miembros de la expedición!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sukatanku, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogaasu, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urf...", french=" Argh...", german=" Urf...", italian=" Urf...", spanish=" Ay..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urf...", french=" Argh...", german=" Urf...", italian=" Urf...", spanish=" Ay..."})
  else
  SkySceneKit.say({english=" Urf...", french=" Argh...", german=" Urf...", italian=" Urf...", spanish=" Ay..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(360, 252, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="(Chaw-haw-haw! Looks like\nthose losers are out.)", french="(Gnark gnark gnark! On dirait\nque les mauviettes sont hors jeu.)", german="(Cha-ha-ha! Wie es aussieht,\nsind diese Nieten ausgeschieden.)", italian="(Ahr-ahr-ahr! Quelle mezze\ncalzette non ce l'hanno fatta.)", spanish="(¡Jua, jua, jua! Ya está\nclarísimo quiénes se han quedado fuera.)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" (Heh-heh. Serves them right!)", french="(Hin hin. Ça leur fera les\npieds!)", german=" (Hehe. Geschieht ihnen recht!)", italian=" (Eh-eh. Ben gli sta!)", spanish="(Jue, jue... ¡Les está bien\nempleado!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="(Whoa-ho-ho! They had\nit coming.)", french="(Mouarf mouarf mouarf! Ça\nleur apprendra.)", german="(Whoahoho! Sie haben es sich\nverdient.)", italian="(Uooh-ho-ho! Dovevano\naspettarselo.)", spanish=" (¡Jo, jo, jo! Se lo merecían.)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(420, 252, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="So that's it for the expedition\nmembers...[K] Erm... What's this...?", french="Voilà, c'est tout en ce qui\nconcerne les membres de l'expédition...[K] Hum...\nTiens donc...?", german="Damit hätten wir die\nExpeditionsmitglieder...[K] Äh, was ist das?", italian="Quindi, come dicevo, questo è\ntutto per quanto riguarda i partecipanti alla\nspedizione...[K] Eh... Cosa c'è qui...?", spanish="Así que esa es la lista de los\nmiembros...[K] Un momento. ¿Qué es esto?"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownRight)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sukatanku, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogaasu, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="(There's something scribbled on\nthe margins of this memo...)", french="(Il y a des gribouillis dans la\nmarge de la liste...)", german="(Da ist noch etwas auf den Rand\ngekritzelt.)", italian="(C'è un'annotazione a margine di\nquest'elenco...)", spanish="(Hay algo garabateado en\nlos márgenes del informe...)"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="(The Guildmaster's writing is\nsuch a messy scrawl...)", french="(L'écriture du Maître est\nvraiment illisible...)", german="(Der Gildenmeister hat wirklich\neine krakelige Handschrift.)", italian="(La calligrafia del Capitano è\ncosì difficile da decifrare...)", spanish="(Hay que reconocer que\nel Gran Bluff escribe fatal...)"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" (This is so hard to decipher...)", french=" (De vraies pattes de mouche...)", german=" (Das ist kaum zu entziffern.)", italian=" (È difficile da leggere...)", spanish=" (Esto es casi indescifrable...)"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="(Erk! If I said that aloud, the\nconsequences wouldn't be pretty. Best to keep\na stiff upper beak and swallow those words.)", french="(Oups! Si je dis ça à voix haute,\nça va barder pour moi. Mieux vaut se taire.\nEvitons les prises de bec.)", german="(Argh! Würde ich laut sagen,\nwas ich jetzt denke, hätte es unschöne Folgen.\nAm besten halte ich einfach den Schnabel.)", italian="(Erk! Ma se lo dicessi ad alta\nvoce, le conseguenze non sarebbero simpatiche.\nSarà meglio far finta di niente.)", spanish="(¡Ay! Si dijera eso en voz alta,\nquién sabe lo que podría pasar. Será mejor\nque me guarde eso para mí y siga leyendo...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- SetAnimation(29) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Erm... It appears that there are\nmore expedition members.", french="Hum... apparemment, l'expédition\ncomportera aussi d'autres membres.", german="Ähm... Wie es aussieht, gibt es\nnoch mehr Expeditionsmitglieder.", italian="Erm... Sembra che ci siano\naltri nomi scritti qui.", spanish="Esto... Parece que hay más\nmiembros para la expedición."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The others are...[K][CS:N]Diglett[CR], [CS:N]Dugtrio[CR],\nand [CS:N]Croagunk[CR].[K] Oh, and [partner] and\n[hero]. ♪", french="Il s'agit de...[K] [CS:N]Taupiqueur[CR],\n[CS:N]Triopikeur[CR] et [CS:N]Cradopaud[CR].[K] Oh, et aussi\n[partner] et [hero]. ♪", german="Und zwar... [K][CS:N]Digda[CR], [CS:N]Digdri[CR]\nund [CS:N]Glibunkel[CR].[K] Oh, und [partner] und\n[hero]. ♪", italian="Gli altri sono...[K] [CS:N]Diglett[CR], [CS:N]Dugtrio[CR]\ne [CS:N]Croagunk[CR].[K] Oh, e anche [partner] e\n[hero]. ♪", spanish="Los otros son... [K][CS:N]Diglett[CR], [CS:N]Dugtrio[CR]\ny [CS:N]Croagunk[CR]. [K]Ah, también [partner] y\n[hero]. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sukatanku, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_zubatto, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogaasu, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="That is all.[K] Wait a second!\nWhat?!", french="C'est tout.[K] Attendez une minute!\nQuoi?!", german="Das ist alles.[K] Moment mal!\nWas?!?", italian="Questo è tutto.[K] Un secondo!\nCosa?!", spanish="Eso es todo.[K] ¡Un momento!\n¡¿Pero qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" What?![K] Whaaaat?!", french=" Quoi?![K] Quoi?!", german=" Was?!?[K] Waaaas?!?", italian=" Cosa?![K] Cooosa?!", spanish=" ¡¿Qué?![K] ¡¿Quéeee?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Guildmaster! This list seems\nto include...", french="Maître! On dirait que cette liste\ninclut...", german="Gildenmeister! Ich glaube, auf\ndieser Liste steht...", italian="Capitano! Sembra che questa\nlista includa...", spanish="¡Gran Bluff! Pero si en la lista\nestán..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Every member of the guild!", french="... tous les membres de la\nGuilde!", german="Da steht jedes einzelne\nGildenmitglied!", italian=" Tutti i membri della Gilda!", spanish="¡Todos los miembros\ndel [CS:N]Pokégremio[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Yup! That's right!", french=" Yep! C'est exact!", german=" Jep! Das stimmt!", italian=" Già! Proprio così!", spanish=" ¡Sí! ¡Así es!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(-24), p.Y+(0), false, 2) end
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(42) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Well then! It seems that the\nwhole selection process was meaningless.", french="Eh bien! Tout le processus de\nsélection a donc été vain.", german="Nun gut! Wie es aussieht, war\ndas ganze Auswahlverfahren sinnlos.", italian="Beh! Si direbbe che l'intero\nprocesso di selezione sia stato inutile.", spanish="¡Bueno! Parece entonces que\ntodo el proceso de selección fue inútil."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Moreover, if we were to all go,\nwe would be leaving the guild empty!", french="De plus, si nous partons tous,\nles locaux de la Guilde seront vides!", german="Außerdem müssten wir die Gilde\nleer zurücklassen, wenn wirklich alle gehen!", italian="Se andiamo tutti, la Gilda\nrimarrà incustodita.", spanish="Es más, si vamos todos... ¡el\n[CS:N]Pokégremio[CR] se quedará completamente vacío!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Are you sure it will be all right\nto leave with no one to look after the guild?", french="Etes-vous sûr que ça ira\nsi personne ne reste ici pour surveiller la\nGuilde?", german="Bist du sicher, dass wir gehen\nsollten, ohne dass jemand hierbleibt, um auf die\nGilde aufzupassen?", italian="È sicuro che sia una cosa\nsaggia non lasciare nessuno a occuparsi\ndella Gilda?", spanish="¿Seguro que no va a pasar nada\nsi no dejamos a nadie a cargo del [CS:N]Pokégremio[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="It'll be fine. We'll lock\nup properly. ♪", french="Tout ira bien. Nous fermerons\ntout à clé. ♪", german="Es wird schon okay sein.\nWir werden gut abschließen. ♪", italian="Andrà tutto bene. Chiuderemo\ntutto a doppia mandata. ♪", spanish="No pasará nada.\nCerraremos bien la puerta. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_sukatanku.Position; GROUND:MoveToPosition(npc_npc_sukatanku, p.X+(16), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Guildmaster, I also have\nsome misgivings.", french="Maître, j'ai aussi quelques\ncraintes à formuler.", german="Gildenmeister, ich habe auch\nein paar Bedenken.", italian=" Capitano, anch'io ho dei dubbi.", spanish="Gran Bluff, también tengo\nmis dudas sobre esto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_sukatanku, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_sukatanku, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sukatanku, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_sukatanku, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_sukatanku, 4) end)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_sukatanku, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_sukatanku, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_sukatanku, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_sukatanku, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_sukatanku, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Do you think perhaps we may\nhave too many members for an expedition?", french="Ne croyez-vous pas qu'il y ait\ntrop de membres pour cette expédition?", german="Glaubst du nicht, dass vielleicht\nzu viele Mitglieder auf die Expedition gehen?", italian="Non pensi che ci siano troppi\nPokémon per una spedizione di questo tipo?", spanish="¿No crees que quizás haya\ndemasiados miembros en la expedición?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Hmm... When a friend asks\nsomething like that, I have to wonder why...", french="Hum... qu'un ami me pose une\ntelle question... ça m'interpelle forcément.\nQue veux-tu dire?", german="Hmm... Wenn ein Freund so\netwas fragt, muss ich mich schon fragen,\nwieso.", italian="Mmm... Quando un amico chiede\nuna cosa del genere, bisogna chiedersi il\nperché.", spanish="Hum... Cuando un amigo pregunta\nalgo así, tengo que preguntarme por qué..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="I mean, first of all, why does\neveryone have to go?", french="Premièrement, pourquoi faut-il\nabsolument que tout le monde vienne avec\nnous?", german="Ich meine, wieso müssen\nüberhaupt alle gehen?", italian="Voglio dire, perché devono\nandare tutti?", spanish="En realidad, ¿por qué tiene\nque ir todo el mundo?"})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="What's the point in having\neveryone participate?", french="Ça ne sert strictement à rien\nde les faire tous participer!", german="Was hat es für einen Sinn, dass\njeder mitmacht?", italian="Che senso ha che\npartecipino tutti?", spanish="¿Hay alguna razón por la que\ntengan que ir todos?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Huh?! Of course there's a point!", french="Hein?! Mais bien sûr que ça\nsert à quelque chose!", german=" Äh?!? Natürlich ergibt das Sinn!", italian=" Eh?! Ma certo che c'è un senso!", spanish="¡¿Qué?! ¡Por supuesto que\nla hay!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" That is...", french=" Ben oui...", german=" Ich meine...", italian=" Ed è...", spanish=" Y es que..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="If everyone went, it would be\nmore fun!", french="Si tout le monde vient, ce sera\nplus rigolo, pas vrai?", german="Wenn alle gehen, macht es\ndoch mehr Spaß!", italian="Se andiamo tutti sarà più\ndivertente!", spanish="¡Así nos divertiremos mucho\nmás!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_sukatanku, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_sukatanku.Position; GROUND:MoveToPosition(npc_npc_sukatanku, p.X+(-8), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="We'll be noisy and excited and\nhaving fun! I started thinking about it, and it\nmade me so excited, I couldn't sleep! ♪", french="On va faire la fête, on va bien\nrigoler! Quand j'ai eu cette idée, j'étais si\nexcité que je n'arrivais plus à dormir! ♪", german="Es wird ganz laut und aufregend\nund lustig werden! Als mir die Idee kam,\nkonnte ich vor Aufregung nicht einschlafen! ♪", italian="Faremo baldoria e ci divertiremo\nun sacco! Ci ho pensato e non ho dormito per\nl'emozione! ♪", spanish="¡Nos reiremos más todos juntos!\n¡Cantaremos y lo pasaremos muy bien! ¡Solo\nde pensarlo no he podido ni dormir! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_sukatanku, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" What...?", french=" Quoi...?", german=" Was?", italian=" Cosa...?", spanish=" ¿Qué...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_pukurin, 4) end)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="So that's how it is, everyone!\nWe're all going on the expedition, and it will\nbe fun, fun, fun! ♪", french="C'est comme ça, tout le monde!\nOn part tous en expédition et ça va être\nrigolo, rigolo, rigolo! ♪", german="So sieht es aus, Freunde!\nWir gehen alle auf die Expedition, und es wird\nein riesen-, riesen-, riesengroßer Spaß! ♪", italian="Questo è quanto, gente!\nParteciperemo tutti alla spedizione e sarà\ndivertentissimo! ♪", spanish="¡Y por eso vamos a ir todos!\nVamos a ir a la expedición, ¡y lo pasaremos\ngenial! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Let's all do our best! ♪", french="Donnons le meilleur de\nnous-mêmes! ♪", german=" Geben wir alle unser Bestes! ♪", italian=" Facciamo del nostro meglio! ♪", spanish=" ¡Será una expedición chachi! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: URRÀ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:FadeOutBGM(120) end)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Urrgh... Well, that's settled.", french=" Grrr... Eh bien, c'est décidé.", german=" Urrgh... Tja, es ist beschlossen.", italian=" Urrgh... Beh, allora è deciso.", spanish=" Uf... Bueno, pues está decidido."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownRight)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sukatanku, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogaasu, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Fine. Let me explain the\nschedule.", french="Bien. Voici notre emploi du\ntemps.", german="Na gut. Lasst mich den Ablauf\nerklären.", italian="Bene. Ed ecco la tabella di\nmarcia.", spanish=" Vale. Os explicaré el plan."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Right after this, I will hold a\nbriefing on the expedition.", french="Juste après, je vous parlerai\ndes détails de l'expédition.", german="Gleich im Anschluss findet eine\nEinsatzbesprechung für die Expedition statt.", italian="Tra poco ci sarà una\nriunione per discutere della spedizione.", spanish="A continuación, hablaremos\nsobre la expedición."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="As such, the chosen members\n(that is, everyone)...", french="Ainsi, les membres choisis\n(c'est-à-dire tout le monde)...", german="Die ausgewählten Mitglieder\n(also alle)...", italian="Quindi, i Pokémon che sono stati\nscelti (cioè tutti)...", spanish="Los miembros elegidos\n(es decir, todo el mundo)..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Each of you should get prepared\nto embark on the expedition.", french="... devront se préparer pour\npartir en expédition.", german="Jeder von euch sollte sich auf\nden Beginn der Expedition vorbereiten.", italian="... devono prepararsi per la\nspedizione.", spanish="Cada uno de vosotros ha de\nprepararse para la expedición."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Let me remind you that this is a\nguild-exclusive expedition.[K] You may not bring\nnonguild members of your teams.", french="Cette expédition est exclusive\nà la Guilde.[K] Vous ne pouvez pas emmener de\ncoéquipiers qui ne font pas partie de la Guilde.", german="Vergesst nicht, dass dies eine\nGildenexpedition ist.[K] Team-Mitglieder, die nicht\nzur Gilde gehören, dürfen nicht mitkommen.", italian="Vorrei ricordarvi che questa è\nuna spedizione per i soli membri della Gilda.[K]\nNon potete portare altri Pokémon con voi.", spanish="Os recuerdo que esta es una\nexpedición del [CS:N]Pokégremio[CR].[K] No podéis traer a\notros Pokémon que no sean miembros."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="As such, you won't be able to\nadd members at [CS:K]Chimecho[CR] Assembly. They\nsimply aren't allowed to join the expedition.", french="Vous ne pouvez donc pas ajouter\nde coéquipiers du [CS:K]Rassemblement Eoko[CR]. Ils ne\nseront pas acceptés dans l'expédition.", german="Ihr könnt keine Mitglieder über\nden [CS:K]Palimpalim-Treffpunkt[CR] mitnehmen.\nSie dürfen an der Expedition nicht teilnehmen.", italian="Per questo motivo, non potrete\naggiungere Pokémon al Raduno [CS:K]Chimecho[CR]. Non\npossono partecipare alla nostra spedizione.", spanish="Por eso, no podéis escoger\nmiembros del [CS:K]Registro Chimecho[CR].\nNo hay sitio para ellos en la expedición."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Keep that in mind while you are\nmaking preparations.", french="Gardez cette règle en tête lors\nde vos préparatifs.", german="Denkt daran, wenn ihr eure\nVorbereitungen trefft.", italian="Tenetelo a mente mentre vi\npreparate.", spanish="Tened eso en cuenta cuando\nos preparéis para partir."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="When you are prepared for the\nupcoming journey, you should return here.", french="Quand vous voudrez partir,\nrevenez ici.", german="Sobald ihr bereit seid für die\nanstehende Reise, kommt hierher zurück.", italian="Quando avete finito di\nprepararvi per il viaggio che ci aspetta,\ntornate qui.", spanish="Preparad lo que necesitéis.\nCuando estéis listos debéis volver aquí."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Then, inform me of your\nreadiness.", french="Une fois vos préparatifs\nterminés, faites-le-moi savoir.", german="Informiert mich dann, sobald ihr\nfertig seid.", italian="Poi, informatemi quando avete\ncompletato i preparativi.", spanish="Estaré esperando a que me\naviséis cuando estéis listos."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" That is all. Dismissed!", french=" C'est tout. Rompez!", german=" Das ist alles. Ihr könnt gehen!", italian=" È tutto. Potete andare!", spanish=" Eso es todo. ¡Rompan filas!"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_pukurin, 420, 180, false, 2)
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(16), p.Y+(-16), false, 2) end
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_sukatanku, 324, 132, false, 2)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_zubatto, 324, 132, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_dogaasu, 324, 132, false, 2)
  GROUND:MoveToPosition(hero, 460, 228, false, 2)
  GROUND:MoveToPosition(partner, 468, 252, false, 2)
  do local p=npc_npc_diguda.Position; GROUND:MoveToPosition(npc_npc_diguda, p.X+(-8), p.Y+(-8), false, 2) end
  GROUND:MoveToPosition(npc_npc_bippa, 416, 268, false, 2)
  GROUND:MoveToPosition(npc_npc_dagutorio, 384, 268, false, 2)
  GROUND:MoveToPosition(npc_npc_kimawari, 436, 220, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 412, 224, false, 2)
  do local p=npc_npc_dagutorio.Position; GROUND:MoveToPosition(npc_npc_dagutorio, p.X+(0), p.Y+(-8), false, 2) end
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_heigani, 368, 228, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_dogoomu, 392, 220, false, 2)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_diguda, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Down)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  GROUND:EntTurn(npc_npc_heigani, Direction.DownRight)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="I could scream, I'm so happy!\nEveryone is going on the expedition!", french="Je suis trop contente, je ne sais\npas ce qui me retient de hurler de joie!\nNous faisons tous partie de l'expédition!", german="Ich könnte vor Glück schreien!\nAlle dürfen mit zur Expedition!", italian="Potrei urlare dalla gioia!\nPartecipiamo tutti alla spedizione!", spanish="¡Gritaría de felicidad!\n¡Vamos a ir todos a la expedición!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Our Guildmaster has done it\nagain. I'm so shocked, I'm tingling!", french="Notre Maître nous a refait le\ncoup. Je suis toute émue, toute guillerette!", german="Der Gildenmeister hat mich mal\nwieder überrascht! Ich zittere noch von dem\nSchock!", italian="Il nostro Capitano ha colpito\nancora. Sto tremando dall'emozione!", spanish="Nuestro Gran Bluff lo ha vuelto\na hacer. ¡Menuda sorpresa nos ha dado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I didn't think we'd get picked,\nso that came as a total shock!", french="Je ne pensais pas que nous en\nferions partie, quelle surprise!", german="Ich dachte nicht, dass wir\nausgewählt werden! Ich war total baff!", italian="Non pensavo che ce l'avremmo\nfatta, è stato proprio uno shock!", spanish="No creía que me fueran a\nescoger, ¡así que estoy muy sorprendido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I didn't think we'd get picked,\nso that came as a total shock!", french="Je ne pensais pas que nous en\nferions partie, quelle surprise!", german="Ich dachte nicht, dass wir\nausgewählt werden! Ich war total baff!", italian="Non pensavo che ce l'avremmo\nfatta, è stato proprio uno shock!", spanish="No creía que me fueran a\nescoger, ¡así que estoy muy sorprendido!"})
  else
  SkySceneKit.say({english="I wasn't expecting us to be\npicked, so that was a total surprise!", french="Je ne pensais pas que nous en\nferions partie, quelle surprise!", german="Ich dachte nicht, dass wir\nausgewählt werden! Ich war total baff!", italian="Non pensavo che ce l'avremmo\nfatta, è stato proprio uno shock!", spanish="No creía que me fueran a\nescoger, ¡así que estoy muy sorprendida!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'm glad we never gave up!", french="Je suis content que nous n'ayons\npas abandonné!", german="Ich bin froh, dass wir nie\naufgegeben haben!", italian="Sono felice che non ci siamo mai\narresi!", spanish="¡Me alegro de que no nos\nhayamos rendido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I'm glad we never gave up!", french="Je suis content que nous n'ayons\npas abandonné!", german="Ich bin froh, dass wir nie\naufgegeben haben!", italian="Sono felice che non ci siamo mai\narresi!", spanish="¡Me alegro de que no nos\nhayamos rendido!"})
  else
  SkySceneKit.say({english=" I'm glad we never gave up!", french="Je suis contente que nous\nn'ayons pas abandonné!", german="Ich bin froh, dass wir nie\naufgegeben haben!", italian="Sono felice che non abbiamo mai\nmollato!", spanish="¡Me alegro de que no nos\nhayamos rendido!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey!", french=" Eh dis donc!", german=" Hey, hey!", italian=" Ehi, ehi!", spanish=" ¡Oye, oye!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_diguda, Direction.Left)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Right)
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Sniff... By golly, I'm mighty\nhappy that they're even letting me go on this\nhere expedition...", french="Snif... Sapristi, j'suis hyper\ncontent qu'ils m'aient accepté pour\nl'expédition... J'vais m'rouler par terre...", german="Schnief... Menschenskind, ich bin\nso froh, dass ich mit auf die Expedition darf...", italian="Sniff... Ohibò, sono così felice\ndi partecipare anch'io a questa spedizione...", spanish="Snif... Cómo me alegro de que\nme permitan ir a esta expedición..."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Oh, but not just me! Why,\neveryone gets to go...", french="Oh, mais pas seulement moi!\nTout l'monde va y aller...", german="Oh, und nicht nur ich!\nAlle dürfen ja mit...", italian="Oh, ma non sono il solo! Tutti\nvi prenderanno parte...", spanish="Oh, y es que, además, vamos\na ir todos..."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Sniff... It's like I'm dreaming.\nIt's making me feel mighty emotional...[K] Sob...", french="Snif... J'crois que j'rêve!\nJ'suis vachement ému...[K] Snif...", german="Schnief... Das ist wie ein Traum.\nIch bin ganz bewegt und aufgewühlt.[K]\nSchluchz...", italian="Sniff... Mi sembra un sogno.\nÈ così commovente...[K] Sob...", spanish="Snif... Es como un sueño...\nEsto me está poniendo sentimental...[K] Snif..."})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="It's no dream. This is really\nhappening.", french="Ce n'est pas un rêve. C'est\nla réalité.", german="Das ist kein Traum. Es passiert\nwirklich.", italian="Non è un sogno. Sta succedendo\ndavvero.", spanish="No es ningún sueño.\nEsto está ocurriendo."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Anyway, since we are all going,\nit means that we're all going to be put\nto the test as well.", french="Quoi qu'il en soit, comme nous\ny allons tous, cela veut dire que nous allons\ntous être mis à l'épreuve.", german="Wie auch immer, dass wir alle\nmitgehen, bedeutet auch, dass es eine Prüfung\nfür uns alle sein wird.", italian="In ogni caso, visto che andiamo\ntutti, significa che verremo tutti messi alla\nprova.", spanish="El caso es que, al ir todos,\nseguro que nos pondrán a prueba."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="That's why I would like to\npropose that all of us apprentices work\nas one.", french="Je suggère donc que nous, les\napprentis, travaillions main dans la main.", german="Darum schlage ich vor, dass wir\nLehrlinge alle zusammenarbeiten.", italian="È per questo che vorremmo fare\nuna proposta: tutti noi apprendisti dovremmo\naiutarci a vicenda.", spanish="Por eso yo propongo que todos\nlos aprendices actuemos como uno solo."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="And let's make this expedition\na success!", french="Et assurons-nous que\nl'expédition soit un succès!", german="Und lasst uns diese Expedition zu\neinem Erfolg machen!", italian="Per rendere questa spedizione\nun successo!", spanish="¡Y hagamos que esta expedición\nsea todo un éxito!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Yippee! That's the spirit!", french="Youpiii! Je suis bien d'accord!\nÇa va être hyper génial!", german="Jippieee! Das ist die richtige\nEinstellung!", italian="Evviva! Questo è l'atteggiamento\ngiusto!", spanish=" ¡Bien dicho! ¡Así se habla!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_diguda, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GROUND:EntTurn(npc_npc_guregguru, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Yeah! THAT'S the spirit!", french=" Ouais! Ça va être SUPER!", german=" Ja! Das IST sie!", italian="Sì! QUESTO è proprio\nl'atteggiamento giusto!", spanish=" ¡Sí! ¡Así se habla!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Let's do our best!", french=" Faisons de notre mieux!", german=" Lasst uns unser Bestes geben!", italian=" Facciamo del nostro meglio!", spanish="¡Hay que hacerlo lo mejor\nque podamos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Sniff... Sniff...", french=" Snif... snif...", german=" Schnief... Schnief...", italian=" Sniff... Sniff...", spanish=" Snif... Snif..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's band together and do it!", french="Unissons nos efforts et nous y\narriverons!", german="Lasst uns zusammenhalten!\nWir schaffen es!", italian="Uniamo le forze e dimostriamo\ncosa sappiamo fare!", spanish="¡Tenemos que trabajar todos\njuntos y conseguirlo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's band together and do it!", french="Unissons nos efforts et nous y\narriverons!", german="Lasst uns zusammenhalten!\nWir schaffen es!", italian="Uniamo le forze e dimostriamo\ncosa sappiamo fare!", spanish="¡Tenemos que trabajar todos\njuntos y conseguirlo!"})
  else
  SkySceneKit.say({english=" Let's band together and do it!", french="Unissons nos efforts et nous y\narriverons!", german="Lasst uns zusammenhalten!\nWir schaffen es!", italian="Uniamo le forze e dimostriamo\ncosa sappiamo fare!", spanish="¡Tenemos que trabajar todos\njuntos y conseguirlo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_heigani, Direction.Down)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  -- SetAnimation(24) [anim idle native]
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Down)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_kimawari, Direction.Down)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  -- SetAnimation(66) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  GAME:WaitFrames(90)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  GROUND:TeleportTo(hero, 436, 268, Direction.Down)
  GROUND:TeleportTo(partner, 408, 268, Direction.Down)
  GROUND:TeleportTo(npc_npc_perappu, 456, 220, Direction.Down)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayFanfare("Fanfare/Note") end) -- me_Play(7) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]The Exploration Team Federation\n[CN]has sent a message...[W:30]", french="[CN]La Fédération des Equipes d'Exploration\n[CN]a envoyé un message...[W:30]", german="[CN]Der Erkundungsteamverband\n[CN]hat eine Nachricht geschickt.[W:30]", italian="[CN]Arriva un messaggio della Federazione\n[CN]Squadre d'Esplorazione![W:30]", spanish="[CN]La Federación de Exploradores\n[CN]envió un mensaje...[W:30]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayFanfare("Fanfare/LevelUp") end) -- me_Play(1) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][hero]'s team was rewarded\n[CN]with a bigger Treasure Bag![W:100]", french="[CN]L'équipe de [hero] reçoit\n[CN]un Sac à Trésor plus grand![W:100]", german="[CN]Das Team von [hero] erhält\n[CN]einen größeren Schatzbeutel zur Belohnung![W:100]", italian="[CN]La squadra di [hero] riceve in premio\n[CN]una Sacca dei tesori più capiente![W:100]", spanish="[CN]¡El equipo de [hero] fue recompensado\n[CN]con una Bolsa mayor![W:100]"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]You can now carry more\n[CN]items than you could before!", french="[CN]Dorénavant vous pourrez\n[CN]transporter plus d'objets!", german="[CN]Du kannst jetzt\n[CN]mehr Items als bisher tragen!", italian="[CN]Adesso potrete trasportare molti più\n[CN]strumenti di prima!", spanish="[CN]¡Ahora puedes llevar\n[CN]más objetos que antes!"})
  -- message_Close
  GAME:WaitFrames(30)
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SCENARIO_BALANCE_FLAG = 2 -- $SCENARIO_BALANCE_FLAG = 2 (ROM)
  SkySceneKit.cleanup_npcs()
end
