-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D30P21A/m25a1001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...[K] That was a mess.", french=" Argh...[K] Quel échec retentissant!", german=" Uff...[K] Das war nichts.", italian=" Uff...[K] Abbiamo fallito...", spanish=" Uf...[K] Menuda pifia."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh...[K] That wasn't good.", french=" Argh...[K] Quel échec retentissant!", german=" Uff...[K] Das war nicht gut.", italian=" Uff...[K] È andata male...", spanish=" Uf...[K] Menuda actuación."})
  else
  SkySceneKit.say({english=" Ugh...[K] We didn't do so well...", french=" Argh...[K] Quel échec retentissant!", german=" Uff...[K] Wir waren nicht gut...", italian="Uff...[K] Non è andata molto\nbene...", spanish=" Uf...[K] No hemos dado la talla."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D30P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_TEMPORAL_SPIRE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
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
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk![K] But we have to hurry.", french="Argh![K] Dépêchons-nous d'y\nretourner.", german="Umpf![K] Aber wir müssen uns\nbeeilen.", italian=" Oh![K] Dobbiamo darci una mossa.", spanish="Pero...[K] tenemos que darnos\nprisa."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk![K] We have to hurry.", french="Argh![K] Dépêchons-nous d'y\nretourner.", german="Umpf![K] Wir müssen uns\nbeeilen.", italian=" Uh![K] Dobbiamo far presto.", spanish="Pero...[K] tenemos que darnos\nprisa."})
  else
  SkySceneKit.say({english=" Urk![K] We have to get moving.", french="Argh![K] Dépêchons-nous d'y\nretourner.", german="Umpf![K] Wir müssen\nvorankommen.", italian=" Uh![K] Dobbiamo far presto.", spanish="Pero...[K] tenemos que darnos\nprisa."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We're getting really close...[K]\nWe have to keep going, [hero]!", french="On se rapproche...[K]\nTiens bon, [hero]!", german="Wir sind so nah dran...[K] Wir\ndürfen nicht aufgeben, [hero]!", italian="Ci siamo quasi...[K] Diamoci\ndentro, [hero]!", spanish="Estamos realmente cerca...[K]\n¡Tenemos que seguir adelante, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're nearly there...[K] Let's keep\ngoing, [hero]!", french="On se rapproche...[K]\nTiens bon, [hero]!", german="Wir haben es fast geschafft...[K]\nLass uns dranbleiben, [hero]!", italian="Ci siamo quasi...[K] Diamoci\ndentro, [hero]!", spanish="Ya casi estamos...[K] ¡Tenemos que\nseguir adelante, [hero]!"})
  else
  SkySceneKit.say({english="We're so close now...[K] We can't\ngive up now, [hero]!", french="On se rapproche...[K]\nTiens bon, [hero]!", german="Wir sind so nah dran...[K] Wir\nkönnen jetzt nicht aufgeben, [hero]!", italian="Ci siamo quasi...[K] Diamoci\ndentro, [hero]!", spanish="Estamos tan cerca ya...[K]\n¡No podemos rendirnos ahora, [hero]!"})
  end
  -- message_Close
end
