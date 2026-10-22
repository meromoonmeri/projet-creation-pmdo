-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/m00p0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  -- back_SetGround(LEVEL_P01P03A) [neutre/état moteur]
  -- supervision_StationCommon(7) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(40), p.Y+(0), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(48), p.Y+(0), false, 2) end
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 240, 200, Direction.Left, "NPC_CHIRIIN")
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Oh, [hero]![K] [partner]!", french=" Oh, [hero]![K] [partner]!", german=" Oh, [hero]![K] [partner]!", italian="Oh, [hero]![K]\n[partner]!", spanish="¡[hero]![K]\n¡[partner]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! [CS:N]Chimecho[CR]!", french=" Salut, [CS:N]Eoko[CR]!", german=" Hey! [CS:N]Palimpalim[CR]!", italian=" Ehi! [CS:N]Chimecho[CR]!", spanish=" ¿Qué hay, [CS:N]Chimecho[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! [CS:N]Chimecho[CR]!", french=" Salut, [CS:N]Eoko[CR]!", german=" Hey! [CS:N]Palimpalim[CR]!", italian=" Ehi! [CS:N]Chimecho[CR]!", spanish=" ¡Eh! ¡[CS:N]Chimecho[CR]!"})
  else
  SkySceneKit.say({english=" Hi! [CS:N]Chimecho[CR]!", french=" Salut, [CS:N]Eoko[CR]!", german=" Hallo! [CS:N]Palimpalim[CR]!", italian=" Ehilà! [CS:N]Chimecho[CR]!", spanish=" ¡Hola! ¡[CS:N]Chimecho[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(212, 196, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 196, 180, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(partner, 196, 204, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What's up?", french=" Quoi de neuf?", german=" Was ist los?", italian=" Come te la passi?", spanish=" ¿Qué pasa?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What's going on?", french=" Quoi de neuf?", german=" Was gibt es?", italian=" Come stai?", spanish=" ¿Qué sucede?"})
  else
  SkySceneKit.say({english=" What's happening?", french=" Quoi de neuf?", german=" Was liegt an?", italian=" Come stai?", spanish=" ¿Qué ocurre?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Oh, [hero]! [partner]!", french=" Oh, [hero]! [partner]!", german=" Oh, [hero]! [partner]!", italian=" Oh, [hero]! [partner]!", spanish="¡[hero]!\n¡[partner]!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Congratulations on graduating\nfrom the guild!", french="Félicitations! Vous avez\nobtenu le diplôme de la Guilde!", german="Herzlichen Glückwunsch zur\nbestandenen Gildenabschlussprüfung!", italian="Congratulazioni per aver\nsuperato l'esame di diploma della Gilda!", spanish="¡Enhorabuena por superar\nel gran reto del [CS:N]Pokégremio de Exploradores[CR]!"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Team [team:] now gets to\noperate in association with the guild, right?", french="Alors maintenant, l'Equipe\n[team:] travaille en association avec\nla Guilde, n'est-ce pas?", german="Team [team:] kann jetzt\nin Zusammenarbeit mit der Gilde operieren,\nnicht wahr?", italian="Adesso il Team [team:]\npuò operare in associazione con la Gilda,\nvero?", spanish="El [CS:X]Equipo[CR] [team:] ya puede\ncolaborar con el [CS:N]Pokégremio[CR], ¿verdad?"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="So your Assembly privileges also\nchange![K] Let the bell ring!", french="Dans ce cas, vous obtenez aussi\nd'autres privilèges pour le Rassemblement![K]\nFaisons sonner la cloche!", german="Also genießt ihr jetzt gewisse\nPrivilegien bei der Nutzung des Treffpunkts![K]\nLäutet die Glocke!", italian="Quindi cambiano anche i vostri\nprivilegi qui al Raduno![K] Che suoni la campana!", spanish="¡Así que vuestros privilegios en\nel registro cambian![K] ¡Que suene la campana!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="A new special service is\navailable to you!", french="Vous avez droit à un nouveau\nservice très spécial!", german="Ihr könnt jetzt einen neuen\nSonderservice in Anspruch nehmen!", italian="Un nuovo servizio speciale è a\nvostra disposizione!", spanish="¡Ahora tenéis a vuestra\ndisposición un nuevo servicio especial!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Special service?", french=" Un service très spécial?", german=" Sonderservice?", italian=" Servizio speciale?", spanish=" ¿Un servicio especial? ¿Ah, sí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Special service?", french=" Un service très spécial?", german=" Sonderservice?", italian=" Servizio speciale?", spanish=" ¿Un servicio especial...?"})
  else
  SkySceneKit.say({english=" A special service?", french=" Un service très spécial?", german=" Einen Sonderservice?", italian=" Servizio speciale?", spanish=" ¿Un servicio especial?"})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
