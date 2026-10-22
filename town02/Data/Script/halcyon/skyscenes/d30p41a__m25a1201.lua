-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D30P41A/m25a1201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(43, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D30P41A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_HEAVY_FEELING non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: se_Play(7690) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 3) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(3)
  GAME:WaitFrames(40)
  local npc_npc_dark_diaruga = SkySceneKit.spawn_npc("dialga", 280, 240, Direction.Down, "NPC_DARK_DIARUGA")
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english="GRRR-OOOOOO...OOOOOH!![K]\nYOU AGAIN?!", french="GRRR-OOOOOO... OOOOOH!![K]\nENCORE VOUS?!", german="GRRR-OOOOOO...OOOOOH![K]\nIHR SCHON WIEDER!", italian="GRRR-OOOOOO... OOOOOH!![K]\nANCORA VOI?!", spanish="¡GRRRRRRR![K]\n¡¿OTRA VEZ AQUÍ?!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english="YOUR EFFORTS ARE FUTILE!\nI WON'T LET YOU DESTROY THE TOWER!", french="VOS EFFORTS SONT VAINS!\nJE NE VOUS LAISSERAI PAS DETRUIRE\nLA TOUR!", german="EURE ANSTRENGUNGEN SIND\nSINNLOS! ICH LASSE EUCH DEN TURM NICHT\nZERSTÖREN!", italian="I VOSTRI SFORZI SONO INUTILI!\nNON VI PERMETTERÒ DI DISTRUGGERE LA\nTORRE!", spanish="¡VUESTROS ESFUERZOS\nSERÁN EN VANO! ¡NO OS PERMITIRÉ\nQUE DESTRUYÁIS LA TORRE!"})
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english="TIME MUST NOT...[K] TIME...[K]\nGRRR-OOOOOO...OOOOOH!", french="LE TEMPS NE DOIT PAS...[K]\nLE TEMPS...[K] GRRR-OOOOOO... OOOOOH!", german="DIE ZEIT DARF NICHT...[K]\nDIE ZEIT...[K] GRRR-OOOOOO...OOOOOH!", italian="IL TEMPO NON DEVE...[K] IL\nTEMPO...[K] GRRR-OOOOOO... OOOOOH!", spanish="EL TIEMPO NO DEBE...[K]\nEL TIEMPO...[K] ¡GRRRRRRR!"})
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:N]Dialga[CR]'s taken on more darkness!)", french="(L'ombre s'empare de [CS:N]Dialga[CR]!)", german="(Die Dunkelheit hat noch mehr von [CS:N]Dialga[CR]\nBesitz ergriffen!)", italian="([CS:N]Dialga[CR] sta diventando più tenebroso!)", spanish="(¡La oscuridad ha afectado aún más a [CS:N]Dialga[CR]!)"})
  else
  SkySceneKit.say({english="([CS:N]Dialga[CR]'s taken on more darkness!)", french="(L'ombre s'empare de [CS:N]Dialga[CR]!)", german="(Die Dunkelheit hat noch mehr von [CS:N]Dialga[CR]\nBesitz ergriffen!)", italian="([CS:N]Dialga[CR] sta diventando più tenebroso!)", spanish="(¡La oscuridad ha afectado aún más a [CS:N]Dialga[CR]!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That darkness will soon consume him!)", french="(Elle va bientôt l'engloutir!)", german="(Die Dunkelheit wird es bald verzehren!)", italian="(L'oscurità lo consumerà presto!)", spanish="(¡Pronto se adueñará de él!)"})
  else
  SkySceneKit.say({english="(That darkness will soon consume him!)", french="(Elle va bientôt l'engloutir!)", german="(Die Dunkelheit wird es bald verzehren!)", italian="(L'oscurità lo consumerà presto!)", spanish="(¡Pronto se adueñará de él!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(We have to stop it!)", french="(Il faut arrêter ça!)", german="(Wir müssen das verhindern!)", italian="(Dobbiamo fermarlo!)", spanish="(¡Tenemos que detener esto!)"})
  else
  SkySceneKit.say({english="(We have to stop it!)", french="(Il faut arrêter ça!)", german="(Wir müssen das verhindern!)", italian="(Dobbiamo fermarlo!)", spanish="(¡Tenemos que detener esto!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(For the world![K] For the future!)", french="(Pour la planète![K] Pour le futur!)", german="(Für die Welt![K] Für die Zukunft!)", italian="(Per il mondo![K] Per il futuro!)", spanish="(¡Por el mundo![K] ¡Por el futuro!)"})
  else
  SkySceneKit.say({english="(For the world![K] For the future!)", french="(Pour la planète![K] Pour le futur!)", german="(Für die Welt![K] Für die Zukunft!)", italian="(Per il mondo![K] Per il futuro!)", spanish="(¡Por el mundo![K] ¡Por el futuro!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" H-here he comes, [hero]!", french="Il... il commence à se fâcher,\n[hero]!", german="E-es greift gleich an,\n[hero]!", italian="S-Si sta avvicinando,\n[hero]!", spanish=" ¡Aquí viene, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" H-here he comes, [hero]!", french="Il... il commence à se fâcher,\n[hero]!", german="E-es greift gleich an,\n[hero]!", italian="S-Si sta avvicinando,\n[hero]!", spanish=" ¡Aquí viene, [hero]!"})
  else
  SkySceneKit.say({english=" H-here he comes, [hero]!", french="Il... il commence à se fâcher,\n[hero]!", german="E-es greift gleich an,\n[hero]!", italian="S-Si sta avvicinando,\n[hero]!", spanish=" ¡Aquí viene, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_dark_diaruga) end)
  SkySceneKit.say({english=" GRRR-OOOOOO...OOOOOH!", french=" GRRR-OOOOOO... OOOOOH!", german=" GRRR-OOOOOO...OOOOOH!", italian=" GRRR-OOOOOO... OOOOOH!", spanish=" ¡GRRRRRRR!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(5140) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(43, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
