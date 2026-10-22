-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P28A/s31a2803.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  local npc_npc_nyuura = SkySceneKit.spawn_npc("sneasel", 288, 264, Direction.Down, "NPC_NYUURA")
  pcall(function() UI:SetSpeaker(npc_npc_nyuura) end)
  SkySceneKit.say({english=" Oof...[K] Unnh...", french=" Argh...[K] Ouhh...", german=" Ufff...[K] Uuugh...", italian=" Oooh...[K] Argh...", spanish=" Uf...[K] Arf..."})
  -- message_Close
  -- back_SetGround(LEVEL_D73P28A) [neutre/état moteur]
  -- supervision_StationCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_denryuu = SkySceneKit.spawn_npc("ampharos", 320, 288, Direction.UpLeft, "NPC_DENRYUU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- bgm2_PlayFadeIn(BGM_FIRE_CRACKLING4) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  do local p=npc_npc_nyuura.Position; GROUND:MoveToPosition(npc_npc_nyuura, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_nyuura.Position; GROUND:MoveToPosition(npc_npc_nyuura, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_nyuura.Position; GROUND:MoveToPosition(npc_npc_nyuura, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_nyuura.Position; GROUND:MoveToPosition(npc_npc_nyuura, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_nyuura) end)
  SkySceneKit.say({english=" Oof... Unnh...", french=" Ouuhh... que... où...?", german=" Ufff... Uuugh...", italian=" Oooh... Argh...", spanish=" Uf... Arf..."})
  -- message_Close
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 288, 240, Direction.Down, "NPC_SHEIMI")
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, "exclaim", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  local npc_npc_goorikii = SkySceneKit.spawn_npc("machoke", 240, 248, Direction.Up, "NPC_GOORIKII")
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(5)
  local npc_npc_kinogassa = SkySceneKit.spawn_npc("breloom", 208, 232, Direction.UpRight, "NPC_KINOGASSA")
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2)
  local npc_npc_kuchiito = SkySceneKit.spawn_npc("mawile", 240, 208, Direction.Down, "NPC_KUCHIITO")
  pcall(function() GROUND:CharSetEmote(npc_npc_kuchiito, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_goorikii, Direction.DownRight)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_kuchiito, Direction.DownRight)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_kinogassa, Direction.DownRight)
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Oh! He's awake!", french=" Il se réveille!", german=" Oh! Er ist wieder wach!", italian=" Oh! Si sta svegliando!", spanish=" ¡Eh, está consciente!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(276, 276, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_goorikii, 252, 268, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_kinogassa, 244, 244, false, 2)
  GAME:WaitFrames(7)
  GROUND:MoveToPosition(npc_npc_kuchiito, 264, 228, false, 2)
  GROUND:EntTurn(npc_npc_goorikii, Direction.Right)
  GROUND:EntTurn(npc_npc_kinogassa, Direction.DownRight)
  GROUND:EntTurn(npc_npc_kuchiito, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" [CS:N]Sneasel[CR]! Are you all right?!", french=" [CS:N]Farfuret[CR]! Tout va bien?!", german=" [CS:N]Sniebel[CR]! Geht es dir gut?!?", italian=" [CS:N]Sneasel[CR]! Stai bene?!", spanish=" ¡[CS:N]Sneasel[CR]! ¡¿Estás bien?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, -4) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_nyuura) end)
  SkySceneKit.say({english=" Uh... Where am I?", french=" Hein? Où suis-je?", german=" Was? Wo bin ich?", italian=" Uh? Dove sono?", spanish=" ¿Eh? ¿Dónde estoy?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="You fainted at the\n7th Station Clearing.", french="Tu t'es évanoui à la trouée\ndu 7[F:E] Relais.", german="Du bist auf der\n7. Zwischenlagerlichtung in Ohnmacht gefallen.", italian="Ti abbiamo trovato privo\ndi sensi al Bivacco 7.", spanish="Te has debilitado en la\nBase del Séptimo Puerto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="If [CS:N]Ampharos[CR] hadn't carried\nyou here, things would not have gone well for\nyou, seriously.", french="Si [CS:N]Pharamp[CR] ne t'avait pas\ntransporté ici, tu aurais pu avoir de\nsacrés problèmes, sérieusement.", german="Wenn dich [CS:N]Ampharos[CR] nicht\nhierher getragen hätte, wäre es böse für dich\nausgegangen.", italian="Se [CS:N]Ampharos[CR] non ti avesse\nportato qui, te la saresti vista davvero brutta,\ncredimi.", spanish="Si [CS:N]Ampharos[CR] no te hubiera\ntraído hasta aquí, las cosas se te habrían\npuesto muy feas..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, -4) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_nyuura) end)
  SkySceneKit.say({english=" You did that for me?", french=" Tu m'as...", german=" Das hast du für mich getan?", italian=" Hai fatto questo per me?", spanish=" ¿En serio has hecho eso por mí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="It wasn't just me. Everyone here\ncame to your rescue.", french="Je n'étais pas seul, tout le\nmonde ici a contribué à ton sauvetage.", german="Das war ich nicht allein. Alle\nhier haben bei deiner Rettung geholfen.", italian="Non è solo merito mio, tutti\nquanti qui sono venuti in tuo soccorso.", spanish="No solo he sido yo. Todos los que\nestamos aquí vinimos a rescatarte."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, -4) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_nyuura) end)
  SkySceneKit.say({english=" I see...[K] I...", french=" Je vois...[K] Je...", german=" Ach so...[K] Ich...", italian=" Capisco...[K] Io...", spanish=" Entiendo...[K] No sé qué..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_nyuura, "shock", 1) end)
  -- message_FacePositionOffset(1, -4) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_nyuura) end)
  SkySceneKit.say({english=" Unnh!", french=" Ouille!", german=" Ouuuh!", italian=" Pant!", spanish=" ¡Uuf!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="It's all right. You don't have to\nsay anything.", french="Ça va. Inutile de dire\nquoi que ce soit.", german="Ist schon okay.\nDu brauchst jetzt nichts zu sagen.", italian="Va tutto bene. Non c'è bisogno\ndi dire niente.", spanish="Tranquilo, tranquilo. No hace\nfalta que digas nada."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="You should really take it easy\nand rest.", french="Tu devrais te détendre\net essayer de reprendre des forces.", german="Mach erst einmal halblang\nund ruh dich etwas aus.", italian="È meglio che non ti sforzi\ne riposi per bene.", spanish="Lo que tienes que hacer es\ndescansar y tomártelo con calma."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, -4) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_nyuura) end)
  SkySceneKit.say({english=" .........", french=" ..........", german=" ..........", italian=" ..........", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_denryuu.Position; GROUND:MoveToPosition(npc_npc_denryuu, p.X+(-8), p.Y+(-8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="All of you may go on ahead\nthrough the mountain pass. I can take care\nof him.", french="Vous pouvez tous poursuivre\nvotre chemin à travers le col, à présent.\nJe vais prendre soin de lui.", german="Ihr anderen könnt euch schon\nzum Pass begeben. Ich kümmere mich um ihn.", italian="Mi prenderò io cura di lui.\nVoi proseguite pure lungo il passo.", spanish="Ya podéis atravesar el puerto\nalpino, yo me encargo de él."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_sheimi, Direction.DownRight)
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="You were all headed to the\nsummit, weren't you?", french="Vous vous dirigez tous\nvers le sommet, n'est-ce pas?", german="Ihr wolltet alle zum Gipfel,\nnicht wahr?", italian="Non volevate raggiungere\nla cima?", spanish="Os dirigíais todos a la cima,\n¿no es cierto?"})
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="This is the 8th Station, so you're\nalmost there.", french="Ici, c'est le 8[F:E] Relais,\nalors vous y êtes presque.", german="Ihr habt es fast geschafft.\nHier ist ja schon das 8. Zwischenlager.", italian="Qui siamo al Bivacco 8, quindi\nmanca poco.", spanish="Estamos en la Base del Octavo\nPuerto, así que ya casi habéis llegado."})
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english=" Do your best!", french=" Bon courage!", german=" Gebt euer Bestes!", italian=" Dateci dentro!", spanish=" ¡A por todas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kuchiito, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english=" B-but...", french=" M-mais...", german=" A-aber...", italian=" M-Ma...", spanish=" Pe... pero..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="There's nothing to be\naccomplished by all of you staying here.", french="Inutile de rester ici, il n'y a\nrien que vous puissiez faire de plus.", german="Wenn ihr hierbleibt, wird das\nauch nichts nützen.", italian=" Non serve che rimaniate qui.", spanish="Nada, nada, no serviría de gran\ncosa que os quedarais todos aquí."})
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="I can handle this on my own.\nGo on ahead.", french="Je peux m'occuper de lui\ntout seul. Poursuivez votre route.", german="Das schaffe ich allein.\nNun geht schon.", italian="Posso cavarmela da solo.\nAndate avanti.", spanish="Yo puedo encargarme de esto.\nContinuad."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english=" Are you sure...?", french=" Tu es sûr...?", german=" Bist du sicher?", italian=" Sei sicuro...?", spanish=" ¿Estás seguro...?"})
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="Well, all right. We'll leave\n[CS:N]Sneasel[CR] in your care.", french="Eh bien, soit, nous laissons\n[CS:N]Farfuret[CR] à tes soins.", german="Na gut. Wir werden [CS:N]Sniebel[CR]\nin deiner Obhut lassen.", italian="Ok, va bene. Lasceremo\n[CS:N]Sneasel[CR] alle tue cure.", spanish="Bueno, en ese caso dejamos a\n[CS:N]Sneasel[CR] en tus manos."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_D73P28A, 'US31') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(17) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(18) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(41) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(9) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  GAME:WaitFrames(30)
  -- GAP: BGM BGM_FIRE_CRACKLING4 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  SkySceneKit.cleanup_npcs()
end
