-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D31P31A/s01p0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D31P31A) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:N]Grand Master[CR]: Th-they got me...", french="[CS:N]Grand maître[CR]: Non, j'ai perdu...", german="[CS:N]Großmeister[CR]: S-sie haben mich erwischt...", italian="[CS:N]Sua Malvagità[CR]: M-Mi hanno sconfitto...", spanish="[CS:N]Gran malo[CR]: Me... Me tienen en sus manos."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:N]Grand Master[CR]: Everyone, run away!", french="[CS:N]Grand maître[CR]: Sauve qui peut!", german="[CS:N]Großmeister[CR]: Lauft alle weg!", italian="[CS:N]Sua Malvagità[CR]: Scappate!", spanish="[CS:N]Gran malo[CR]: ¡Rápido, retirada!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(2) [neutre/état moteur]
  -- GAP: se_Play(7430) — id SE NDS sans portage PMDO identifié
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 232, 280, Direction.Down, "NPC_PUKURIN")
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(200), false, 2) end
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:N]Grand Master[CR]: Aiyeeh!", french="[CS:N]Grand maître[CR]: Aiyaaah!", german="[CS:N]Großmeister[CR]: Aiiiieeeh!", italian="[CS:N]Sua Malvagità[CR]: Uppalalà!", spanish="[CS:N]Gran malo[CR]: ¡Ayayay!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- GAP: se_Play(7430) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(3) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 232, 280, Direction.Down, "NPC_PERAPPU")
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(200), false, 2) end
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:N]Minion[CR]: Squawk!", french="[CS:N]Sbire[CR]: Couaaac!", german="[CS:N]Untergebener[CR]: Kreisch!", italian="[CS:N]Sgherro[CR]: Squack!", spanish="[CS:N]Secuaz[CR]: ¡Cruac!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- GAP: se_Play(7430) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(4) [neutre/état moteur]
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 232, 280, Direction.Down, "NPC_KIMAWARI")
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(0), p.Y+(200), false, 2) end
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 248, 264, Direction.Down, "NPC_GUREGGURU")
  do local p=npc_npc_guregguru.Position; GROUND:MoveToPosition(npc_npc_guregguru, p.X+(0), p.Y+(200), false, 2) end
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:N]Minion[CR]: Eeeeeeek!", french="[CS:N]Sbire[CR]: Hiiiiiii!", german="[CS:N]Untergebene[CR]: Kreisch!", italian="[CS:N]Sgherro[CR]: Ehiiiiiii!", spanish="[CS:N]Secuaz[CR]: ¡Jo!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- GAP: se_Play(7430) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(5) [neutre/état moteur]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 232, 280, Direction.Down, "NPC_HEIGANI")
  do local p=npc_npc_heigani.Position; GROUND:MoveToPosition(npc_npc_heigani, p.X+(0), p.Y+(200), false, 2) end
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 240, 264, Direction.Down, "NPC_CHIRIIN")
  do local p=npc_npc_chiriin.Position; GROUND:MoveToPosition(npc_npc_chiriin, p.X+(0), p.Y+(200), false, 2) end
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 216, 264, Direction.Down, "NPC_DOGOOMU")
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(0), p.Y+(200), false, 2) end
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CS:N]Minion[CR]: Hey, hey!", french="[CS:N]Sbire[CR]: Eh dis donc!", german="[CS:N]Untergebener[CR]: Kreisch!", italian="[CS:N]Sgherro[CR]: Ehi, ehi!", spanish="[CS:N]Secuaz[CR]: ¡Oye, oye!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(60)
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  GROUND:MoveToPosition(hero, 244, 296, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(partner, 212, 296, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whew...", french=" Pfiou...", german=" Puh...", italian=" Fiuuu...", spanish=" Uf..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Whew...", french=" Pfiou...", german=" Puh...", italian=" Fiuuu...", spanish=" Uf..."})
  else
  SkySceneKit.say({english=" Whew...", french=" Pfiou...", german=" Puh...", italian=" Fiuuu...", spanish=" Uf..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So, uh, what was that\nall about...?", french=" Hein? Qu'est-ce qui leur a pris?", german="So, äh, und was sollte das\nGanze jetzt?", italian="Quindi, ehm, cos'è appena\nsuccesso...?", spanish=" ¿De qué iba todo esto?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What was that all about,\nI wonder...?", french=" Hein? Qu'est-ce qui leur a pris?", german="Was das wohl alles zu bedeuten\nhatte, möchte ich wissen...", italian="Quindi, ehm, cos'è appena\nsuccesso...?", spanish=" ¿De qué iba todo esto?"})
  else
  SkySceneKit.say({english="So, uh, what was that\nall about...?", french=" Hein? Qu'est-ce qui leur a pris?", german="So, äh, und was sollte das\nGanze jetzt?", italian="Quindi, ehm, cos'è appena\nsuccesso...?", spanish=" ¿De qué iba todo esto?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I guess we did all right.", french=" Je crois que nous avons réussi.", german="Ich denke, wir haben uns gut\ngeschlagen.", italian="Direi che ce la siamo cavata\nbene.", spanish=" Creo que ya está hecho."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Well, I guess we're done here.", french=" Je crois que nous avons réussi.", german="Nun, ich glaube, hier sind wir\nfertig.", italian="Direi che ce la siamo cavata\nbene.", spanish=" Creo que ya está hecho."})
  else
  SkySceneKit.say({english=" I guess it's all right.", french=" Je crois que nous avons réussi.", german=" Ich denke, das wäre erledigt.", italian="Direi che ce la siamo cavata\nbene.", spanish=" Creo que ya hemos terminado."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's move on...[K] Let's go to\n[CS:P]Luminous Spring[CR].", french="Avançons...[K] Allons à la\n[CS:P]Source Lumineuse[CR].", german="Ziehen wir weiter...[K] Gehen wir\nzur [CS:P]Glitzerquelle[CR].", italian="Proseguiamo...[K] Andiamo alla\n[CS:P]Sorgente Luccichio[CR].", spanish="Sigamos adelante...[K] Vayamos al\n[CS:P]Manantial Luminoso[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We should move on...[K] Let's go to\n[CS:P]Luminous Spring[CR].", french="Avançons...[K] Allons à la\n[CS:P]Source Lumineuse[CR].", german="Wir sollten weiterziehen...[K]\nLass uns zur [CS:P]Glitzerquelle[CR] gehen.", italian="Proseguiamo...[K] Andiamo alla\n[CS:P]Sorgente Luccichio[CR].", spanish="Sigamos adelante...[K] Vayamos al\n[CS:P]Manantial Luminoso[CR]."})
  else
  SkySceneKit.say({english="We should move on...[K] Let's go to\n[CS:P]Luminous Spring[CR].", french="Avançons...[K] Allons à la\n[CS:P]Source Lumineuse[CR].", german="Wir sollten weiterziehen...[K]\nLass uns zur [CS:P]Glitzerquelle[CR] gehen.", italian="Proseguiamo...[K] Andiamo alla\n[CS:P]Sorgente Luccichio[CR].", spanish="Continuemos...[K] Vayamos al\n[CS:P]Manantial Luminoso[CR]."})
  end
  -- message_Close
  GROUND:MoveToPosition(partner, 192, 164, false, 2)
  GROUND:MoveToPosition(hero, 264, 164, false, 2)
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT = 23 -- $COMPULSORY_SAVE_POINT = 23 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
