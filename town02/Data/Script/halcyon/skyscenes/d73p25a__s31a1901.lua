-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P25A/s31a1901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 20) -- $SCENARIO_MAIN = scn[29,20] (ROM)
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 232, 408, Direction.Up, "NPC_SHEIMI")
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="I can see the\n5th Station Clearing! Let's hurry!", french="J'aperçois la trouée\ndu 5[F:E] Relais![K]\nDépêchons-nous!", german="Ich sehe bereits die\n5. Zwischenlagerlichtung! Beeilung!", italian="Ci siamo, vedo il Bivacco 5!\nSbrighiamoci!", spanish="¡Ya veo la Base del Quinto\nPuerto! ¡Deprisa!"})
  -- message_Close
  -- back_SetGround(LEVEL_D73P25A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  GAME:WaitFrames(30)
  local npc_npc_nyuura = SkySceneKit.spawn_npc("sneasel", 232, 184, Direction.Down, "NPC_NYUURA")
  pcall(function() UI:SetSpeaker(npc_npc_nyuura) end)
  SkySceneKit.say({english=" Ow...!", french=" Aïe...!", german=" Autsch!", italian=" Argh...!", spanish=" ¡Ay...!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_goorikii = SkySceneKit.spawn_npc("machoke", 232, 360, Direction.Up, "NPC_GOORIKII")
  GROUND:MoveToPosition(npc_npc_goorikii, 228, 244, false, 2)
  local npc_npc_kuchiito = SkySceneKit.spawn_npc("mawile", 208, 376, Direction.Up, "NPC_KUCHIITO")
  GROUND:MoveToPosition(npc_npc_kuchiito, 204, 244, false, 2)
  local npc_npc_kinogassa = SkySceneKit.spawn_npc("breloom", 256, 392, Direction.Up, "NPC_KINOGASSA")
  GROUND:MoveToPosition(npc_npc_kinogassa, 252, 244, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="Are you all right? We've come\nto help!", french=" Ça va? On est là pour t'aider!", german="Ist alles in Ordnung?\nWir sind gekommen, um zu helfen!", italian="Tutto bene? Siamo venuti\nad aiutarti!", spanish="¿Estás bien? Hemos venido a\nayudarte."})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  local npc_npc_masukippa3 = SkySceneKit.spawn_npc("carnivine", 264, 200, Direction.UpLeft, "NPC_MASUKIPPA3")
  pcall(function() GROUND:CharSetEmote(npc_npc_masukippa3, "exclaim", 1) end)
  local npc_npc_masukippa4 = SkySceneKit.spawn_npc("carnivine", 216, 168, Direction.Down, "NPC_MASUKIPPA4")
  pcall(function() GROUND:CharSetEmote(npc_npc_masukippa4, "exclaim", 1) end)
  GAME:WaitFrames(5)
  local npc_npc_masukippa5 = SkySceneKit.spawn_npc("carnivine", 248, 168, Direction.Down, "NPC_MASUKIPPA5")
  pcall(function() GROUND:CharSetEmote(npc_npc_masukippa5, "exclaim", 1) end)
  local npc_npc_masukippa = SkySceneKit.spawn_npc("carnivine", 232, 208, Direction.Up, "NPC_MASUKIPPA")
  pcall(function() GROUND:CharSetEmote(npc_npc_masukippa, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_masukippa2 = SkySceneKit.spawn_npc("carnivine", 200, 200, Direction.UpRight, "NPC_MASUKIPPA2")
  GROUND:EntTurn(npc_npc_masukippa2, Direction.Down)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_masukippa3, Direction.Down)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_masukippa, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(40), 40, false) end) -- MovePositionOffset performer/caméra
  GROUND:MoveToPosition(npc_npc_sheimi, 228, 276, false, 2)
  GROUND:MoveToPosition(hero, 228, 300, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 252, 292, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 204, 292, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Aha! I knew it!", french=" Aha! Je le savais!", german=" Aha! Wusste ich es doch!", italian=" Aha! Lo sapevo!", spanish=" ¡Ajá! ¡Lo sabía!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-40), 40, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:EntTurn(npc_npc_masukippa, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_masukippa) end)
  SkySceneKit.say({english="H-huh?\nYou came to h-help?", french="C-comment?\nVous êtes là pour l'aider, lui?", german="W-wie?\nIhr k-kamt, um z-zu helfen?", italian="C-Che?\nS-Siete venuti ad aiutarlo?", spanish=" ¿Que habéis venido a ayudar?"})
  pcall(function() UI:SetSpeaker(npc_npc_masukippa) end)
  SkySceneKit.say({english=" What do you think you're doing?!", french="Pour qui est-ce que\nvous vous prenez?!", german=" Was fällt euch eigentlich ein?!?", italian=" Che cosa credete di fare?!", spanish=" ¡¿Qué os habéis creído?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english=" We're Team [CS:X]Frontier[CR]!", french=" Nous sommes l'Equipe [CS:X]Eclaireurs[CR]!", german=" Wir sind Team [CS:X]Grenzland[CR]!", italian=" Noi siamo il Team [CS:X]Pioniere[CR]!", spanish=" ¡Somos el [CS:X]Equipo Frontera[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english="Only cowards would gang up on\none Pokémon!", french="Seuls des lâches oseraient\ns'attaquer à plusieurs à un seul Pokémon!", german="Nur Feiglinge würden als Gruppe\nein einzelnes Pokémon angreifen!", italian="Solo un branco di codardi\npuò prendersela con un Pokémon indifeso!", spanish="¡Solo una panda de cobardes se\nmetería con un solo Pokémon!"})
  pcall(function() UI:SetSpeaker(npc_npc_kuchiito) end)
  SkySceneKit.say({english=" This time we're your opponents!", french="Venez donc vous mesurer\nà nous!", german="Warum greift ihr nicht jemanden\nan, der euch ebenbürtig ist?!?", italian=" Perché non ci provate con noi?!", spanish="¡A ver si se os da tan bien\nun combate equitativo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_masukippa2, 196, 212, false, 2)
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:MoveToPosition(npc_npc_masukippa3, 260, 212, false, 2)
  GAME:WaitFrames(7)
  GROUND:MoveToPosition(npc_npc_masukippa4, 164, 204, false, 2)
  GROUND:MoveToPosition(npc_npc_masukippa5, 292, 204, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_masukippa4, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_masukippa5, Direction.DownLeft)
  do local p=npc_npc_nyuura.Position; GROUND:MoveToPosition(npc_npc_nyuura, p.X+(0), p.Y+(-88), false, 2) end
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_masukippa) end)
  SkySceneKit.say({english=" Oh! That sounds good!", french=" Oh, oh! Très alléchant!", german="Oh! Das klingt nach einer\nspannenden Herausforderung!", italian=" Oh! È un'ottima idea!", spanish=" Je, je, suena bien."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(40), 27, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_sheimi.Position; GROUND:MoveToPosition(npc_npc_sheimi, p.X+(0), p.Y+(-8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Hey! Wait a minute...", french=" Holà! Attendez une minute...", german=" He! Einen Augenblick mal...", italian=" Ehi! Aspettate un attimo...", spanish=" Eh, un momento..."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(121, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
