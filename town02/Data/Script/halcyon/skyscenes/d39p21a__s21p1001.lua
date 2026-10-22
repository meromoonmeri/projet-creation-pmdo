-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D39P21A/s21p1001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...[K] That wasn't so good...", french=" Argh...[K] Quel échec...", german=" Uff...[K] Das war nicht so gut...", italian="Ugh...[K] Non è andata molto\nbene...", spanish=" Uf...[K] ¡Menuda chapuza!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh...[K] That wasn't so great.", french=" Argh...[K] Quel échec...", german=" Uff...[K] Das war nicht so toll.", italian="Ugh...[K] Non è andata molto\nbene...", spanish=" Uf...[K] ¡Menuda actuación!"})
  else
  SkySceneKit.say({english=" Ugh...[K] We goofed...", french=" Argh...[K] Quel échec...", german=" Uff...[K] Das war nicht so gut...", italian=" Ugh...[K] Abbiamo fallito...", spanish=" Uf...[K] ¡Qué mal!"})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D39P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Sealed Ruin.ogg", true) end)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk! This is really tough...", french="Argh! C'est vraiment plus\ndifficile que prévu...", german=" Uff! Das war knüppelhart...", italian=" Ah! È davvero dura...", spanish=" Cuesta avanzar..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk! This is harsh going...", french="Argh! C'est vraiment plus\ndifficile que prévu...", german=" Uff! Ganz schön raue Gangart...", italian=" Ah! È davvero dura...", spanish=" Cuesta avanzar..."})
  else
  SkySceneKit.say({english=" Urk! This isn't so easy...", french="Argh! C'est vraiment plus\ndifficile que prévu...", german=" Uff! Das ist nicht so einfach...", italian=" Ah! Non è così facile...", spanish=" No es fácil seguir adelante..."})
  end
  -- message_Close
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But if we stick around here,\n[CS:N]Palkia[CR] could attack us again.", french="Mais si on reste dans les\nparages, [CS:N]Palkia[CR] risque de nous attaquer\nà nouveau.", german="Aber wenn wir hierbleiben,\nkönnte [CS:N]Palkia[CR] uns wieder angreifen.", italian="Ma se rimaniamo qui,\n[CS:N]Palkia[CR] potrebbe attaccarci di nuovo.", spanish="Pero si nos quedamos aquí,\n[CS:N]Palkia[CR] podría volver a atacarnos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But if we stay here, [CS:N]Palkia[CR] could\nattack us again.", french="Mais si on reste dans les\nparages, [CS:N]Palkia[CR] risque de nous attaquer\nà nouveau.", german="Aber wenn wir hierbleiben,\nkönnte [CS:N]Palkia[CR] uns wieder angreifen.", italian="Ma se rimaniamo qui,\n[CS:N]Palkia[CR] potrebbe attaccarci di nuovo.", spanish="Pero si nos quedamos aquí,\n[CS:N]Palkia[CR] podría volver a atacarnos."})
  else
  SkySceneKit.say({english="But if we stay here, [CS:N]Palkia[CR] could\nattack us again.", french="Mais si on reste dans les\nparages, [CS:N]Palkia[CR] risque de nous attaquer\nà nouveau.", german="Aber wenn wir hierbleiben,\nkönnte [CS:N]Palkia[CR] uns wieder angreifen.", italian="Ma se rimaniamo qui,\n[CS:N]Palkia[CR] potrebbe attaccarci di nuovo.", spanish="Pero si nos quedamos aquí,\n[CS:N]Palkia[CR] podría volver a atacarnos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's move it, [hero]!", french=" Allez, on bouge, [hero]!", german=" Los geht's, [hero]!", italian=" Muoviamoci, [hero]!", spanish=" ¡Hay que moverse, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's hustle, [hero]!", french=" Allez, on bouge, [hero]!", german="Lassen es uns angehen,\n[hero]!", italian=" Muoviamoci, [hero]!", spanish=" ¡Hay que moverse, [hero]!"})
  else
  SkySceneKit.say({english=" Let's hurry, [hero]!", french=" Allez, on bouge, [hero]!", german=" Beeilung, [hero]!", italian=" Muoviamoci, [hero]!", spanish=" ¡Deprisa, [hero]!"})
  end
  -- message_Close
end
