-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P05C/m02a0603.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P05C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 248, 232, Direction.UpLeft, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Guildmaster, I've brought you\nTeam [team:].", french="Maître, voici l'Equipe\n[team:].", german="Gildenmeister, ich bringe\ndir Team [team:].", italian="Capitano, squadra [team:]\na rapporto.", spanish="Gran Bluff, te he traído\nal [CS:X]Equipo[CR] [team:]."})
  -- message_Close
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Guildmaster...[K] Guildmaster?", french="Maître...[K] Maître?", german="Gildenmeister...[K] Gildenmeister?", italian="Capitano...[K] Capitano?", spanish=" Gran Bluff...[K] ¿Gran Bluff?"})
  -- message_Close
  GAME:WaitFrames(60)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 208, 200, Direction.Up, "NPC_PUKURIN")
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Hiya!", french=" Amis du soir, bonsoir!", german=" Hallöchen!", italian=" Ullalà!", spanish=" ¿Qué hay?"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Job not going well? That stinks!", french="Le travail ne se passe pas bien?\nC'est nul!", german="Der Job lief nicht gut?\nSo was Dummes!", italian="Le cose non stanno andando\nmolto bene? Che rabbia!", spanish="¿Vuestra misión no marcha\nbien? ¡Qué pena!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" That's why I'm giving you these!", french="C'est pour ça que je vous donne\nceci!", german=" Darum gebe ich euch das hier!", italian=" Allora, prendete questi!", spanish=" ¡Por eso os voy a dar esto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_pukurin, 220, 228, false, 2)
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(8), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN][CS:N]Wigglytuff[CR] gave you\n[CN]a [CS:I]Reviver Seed[CR]!", french="[CN][CS:N]Grodoudou[CR] vous donne\n[CN]une [CS:I]Résugraine[CR]!", german="[CN][CS:N]Knuddeluff[CR] gibt dir\n[CN]einen [CS:I]Belebersamen[CR]!", italian="[CN][CS:N]Wigglytuff[CR] consegna\n[CN]un [CS:I]Revitalseme[CR]!", spanish="[CN]¡[CS:N]Wigglytuff[CR] os dio\n[CN]una [CS:I]Sem. Revivir[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 73, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]In addition, he also gave you an [CS:I]Oran Berry[CR]!", french="[CN]Il vous donne aussi une [CS:I]Baie Oran[CR]!", german="[CN]Außerdem gibt er dir noch eine [CS:I]Sinelbeere[CR]!", italian="[CN]Inoltre, offre una [CS:I]Baccarancia[CR]!", spanish="[CN]Además, ¡os ha regalado una [CS:I]Baya Aranja[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 70, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CN]Incredibly, he also gave you a [CS:I]Max Elixir[CR]!", french="[CN]Incroyable, il vous donne en plus un [CS:I]Max Elixir[CR]!", german="[CN]Unglaublich! Er gibt dir auch noch ein\n[CN][CS:I]Top-Elixier[CR]!", italian="[CN]Wow! Consegna pure un [CS:I]Elisir Max[CR]!", spanish="[CN]Y por si fuera poco, ¡también os entrega\n[CN]un [CS:I]Elixir Máx.[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 99, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  GAME:WaitFrames(20)
  -- message_FacePositionOffset(2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Those items I gave you are all\nvery useful in dungeons.", french="Les objets que je viens de vous\ndonner sont très utiles dans les donjons!", german="Diese Items sind in Dungeons\nalle sehr nützlich.", italian="Gli strumenti che vi ho dato\npossono tornare molto utili nei dungeon.", spanish="Esos objetos que os he dado\nresultan muy útiles en los territorios\nmisteriosos."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Please give it your best effort\nagain tomorrow!", french="S'il vous plaît, redoublez\nd'efforts demain!", german="Bitte gebt euch Mühe und\nversucht es morgen noch einmal!", italian="Per favore, mettetecela tutta\nanche domani!", spanish="¡Ánimo para mañana!\n¡Procurad esforzaros mucho!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
