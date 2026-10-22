-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s03p0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 45) -- $SCENARIO_MAIN = scn[29,45] (ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The next morning...", french="[CN]Le lendemain matin...", german="[CN]Am nächsten Morgen...", italian="[CN]La mattina dopo...", spanish="[CN]Al día siguiente..."})
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_H02P99A, 'US03') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(15) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(20) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_manafi = SkySceneKit.spawn_npc("manaphy", 312, 184, Direction.Down, "NPC_MANAFI")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:EntTurn(partner, Direction.Left)
  -- SetAnimation(76) [anim idle native]
  -- SetAnimation(76) [anim idle native]
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DO_YOUR_BEST_AS_ALWAYS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "exclaim", 1) end)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(5)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Good morning, [hero]!", french=" Bonjour, [hero]!", german=" Guten Morgen, [hero]!", italian=" Buongiorno, [hero]!", spanish=" ¡Buenos días, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Good morning, [hero]!", french=" Bonjour, [hero]!", german=" Guten Morgen, [hero]!", italian=" Buongiorno, [hero]!", spanish=" ¡Buenos días, [hero]!"})
  else
  SkySceneKit.say({english=" Good morning, [hero]!", french=" Bonjour, [hero]!", german=" Guten Morgen, [hero]!", italian=" Buongiorno, [hero]!", spanish=" ¡Buenos días, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Hi!", french=" Ouiii!", german=" Hallo!", italian=" Ciao!", spanish=" ¡Hola!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_manafi, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_manafi, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Good morning, [CS:N]Manaphy[CR]!", french=" Bonjour, [CS:N]Manaphy[CR]!", german=" Guten Morgen, [CS:N]Manaphy[CR]!", italian=" Buongiorno, [CS:N]Manaphy[CR]!", spanish=" ¡Buenos días, [CS:N]Manaphy[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Good morning, [CS:N]Manaphy[CR]!", french=" Bonjour, [CS:N]Manaphy[CR]!", german=" Guten Morgen, [CS:N]Manaphy[CR]!", italian=" Buongiorno, [CS:N]Manaphy[CR]!", spanish=" ¡Buenos días, [CS:N]Manaphy[CR]!"})
  else
  SkySceneKit.say({english=" Good morning, [CS:N]Manaphy[CR]!", french=" Bonjour, [CS:N]Manaphy[CR]!", german=" Guten Morgen, [CS:N]Manaphy[CR]!", italian=" Buongiorno, [CS:N]Manaphy[CR]!", spanish=" ¡Buenos días, [CS:N]Manaphy[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right, [hero].", french=" Très bien, [hero].", german=" Alles klar, [hero].", italian=" Forza, [hero].", spanish=" Bueno, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK, [hero].", french=" Très bien, [hero].", german=" Okay, [hero].", italian=" Forza, [hero].", spanish=" Bueno, [hero]."})
  else
  SkySceneKit.say({english=" OK, [hero].", french=" Très bien, [hero].", german=" Okay, [hero].", italian=" Forza, [hero].", spanish=" Bueno, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We need to give a [CS:I]Blue Gummi[CR]\nto [CS:N]Manaphy[CR]!", french="Nous devons donner une\n[CS:I]Gelée Bleue[CR] à [CS:N]Manaphy[CR]!", german="Wir müssen für [CS:N]Manaphy[CR] ein\n[CS:I]Blaugummi[CR] besorgen.", italian="Dobbiamo dare una\n[CS:I]Gommablu[CR] a [CS:N]Manaphy[CR].", spanish="Tenemos que darle una [CS:I]Gomi Azul[CR]\na [CS:N]Manaphy[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We need to give a [CS:I]Blue Gummi[CR]\nto [CS:N]Manaphy[CR]!", french="Nous devons donner une\n[CS:I]Gelée Bleue[CR] à [CS:N]Manaphy[CR]!", german="Wir müssen für [CS:N]Manaphy[CR] ein\n[CS:I]Blaugummi[CR] besorgen.", italian="Dobbiamo dare una\n[CS:I]Gommablu[CR] a [CS:N]Manaphy[CR].", spanish="Tenemos que darle una [CS:I]Gomi Azul[CR]\na [CS:N]Manaphy[CR]."})
  else
  SkySceneKit.say({english="We need to give a [CS:I]Blue Gummi[CR]\nto [CS:N]Manaphy[CR]!", french="Nous devons donner une\n[CS:I]Gelée Bleue[CR] à [CS:N]Manaphy[CR]!", german="Wir müssen für [CS:N]Manaphy[CR] ein\n[CS:I]Blaugummi[CR] besorgen.", italian="Dobbiamo dare una\n[CS:I]Gommablu[CR] a [CS:N]Manaphy[CR].", spanish="Tenemos que darle una [CS:I]Gomi Azul[CR]\na [CS:N]Manaphy[CR]."})
  end
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
