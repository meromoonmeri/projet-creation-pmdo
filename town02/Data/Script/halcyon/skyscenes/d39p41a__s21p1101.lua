-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D39P41A/s21p1101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(66, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  SkyProg.set(29, 85) -- $SCENARIO_MAIN = scn[29,85] (ROM)
  -- back_SetGround(LEVEL_D39P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GROUND:MoveToPosition(partner, 356, 404, false, 2)
  GROUND:MoveToPosition(hero, 388, 404, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?[K] [hero], over there!", french=" Hein?[K] [hero], là-bas!", german="Sieh nur![K] [hero], da\ndrüben!", italian="Eh?[K] [hero], da\nquella parte!", spanish=" ¿Eh?[K] ¡[hero], mira ahí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh?[K] [hero], over there!", french=" Hein?[K] [hero], là-bas!", german="Sieh nur![K] [hero], da\ndrüben!", italian="Eh?[K] [hero], da\nquella parte!", spanish=" ¿Eh?[K] ¡[hero], mira ahí!"})
  else
  SkySceneKit.say({english=" Huh?[K] [hero], over there!", french=" Hein?[K] [hero], là-bas!", german="Sieh nur![K] [hero], da\ndrüben!", italian="Eh?[K] [hero], da\nquella parte!", spanish=" ¿Eh?[K] ¡[hero], mira ahí!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(372, 324, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 356, 332, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(hero, 388, 332, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's a dead end!", french=" C'est un cul-de-sac!", german=" Eine Sackgasse!", italian=" È un vicolo cieco!", spanish=" ¡No hay salida!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's a dead end!", french=" C'est un cul-de-sac!", german=" Eine Sackgasse!", italian=" È un vicolo cieco!", spanish=" ¡No hay salida!"})
  else
  SkySceneKit.say({english=" It's a dead end!", french=" C'est un cul-de-sac!", german=" Eine Sackgasse!", italian=" È un vicolo cieco!", spanish=" ¡No hay salida!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What'll we do now...?[K] We can't\ngo any farther.", french="Qu'est-ce qu'on fait\nmaintenant...?[K] Impossible d'aller plus loin.", german="Was machen wir jetzt?[K] Wir\nkönnen nicht mehr weitergehen.", italian="Adesso cosa facciamo...?[K] Non\npossiamo proseguire oltre.", spanish="¿Y ahora qué hacemos...?[K]\nNo podemos avanzar más."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What should we do...?[K] We can't\ngo any farther.", french="Qu'est-ce qu'on fait\nmaintenant...?[K] Impossible d'aller plus loin.", german="Was machen wir jetzt?[K] Wir\nkönnen nicht mehr weitergehen.", italian="Adesso cosa facciamo...?[K] Non\npossiamo proseguire oltre.", spanish="¿Y ahora qué hacemos...?[K]\nNo podemos avanzar más."})
  else
  SkySceneKit.say({english="What should we do...?[K] This is\nas far as we can go.", french="Qu'est-ce qu'on fait\nmaintenant...?[K] Impossible d'aller plus loin.", german="Was machen wir jetzt?[K] Es\ngeht nicht mehr weiter.", italian="Adesso cosa facciamo...?[K] Non\npossiamo proseguire oltre.", spanish="¿Y ahora qué hacemos...?[K]\nNo podemos avanzar más."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_EARTHQUAKE3 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1')
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa![K] Tremors!", french=" Ouah![K] Le sol tremble!", german=" Holla![K] Erschütterungen!", italian=" Ouch![K] Scosse!", spanish=" ¡Ah![K] ¡Temblores!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah![K] Tremors!", french=" Ouah![K] Le sol tremble!", german=" Uaah![K] Erschütterungen!", italian=" Aaah![K] Scosse!", spanish=" ¡Ah![K] ¡Temblores!"})
  else
  SkySceneKit.say({english=" Waah![K] Tremors!", french=" Ouah![K] Le sol tremble!", german=" Uaah![K] Erschütterungen!", italian=" Aaah![K] Scosse!", spanish=" ¡Ah![K] ¡Temblores!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(8195) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(80)
  local npc_npc_parukia = SkySceneKit.spawn_npc("palkia", 376, 240, Direction.Down, "NPC_PARUKIA")
  -- ResetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  do local p=npc_npc_parukia.Position; GROUND:MoveToPosition(npc_npc_parukia, p.X+(0), p.Y+(56), false, 2) end -- SlidePositionOffset
  -- GAP: se_Play(5128) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(15)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_parukia, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_parukia, 4) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(16), 6, false) end) -- MovePositionOffset performer/caméra
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- GAP: BGM BGM_DOWN_A_DARK_PATH non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]P-Palkia[CR]!", french=" [CS:N]P-Palkia[CR]!", german=" [CS:N]P-Palkia[CR]!", italian=" [CS:N]P-Palkia[CR]!", spanish=" ¡[CS:N]Palkia[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]P-Palkia[CR]!", french=" [CS:N]P-Palkia[CR]!", german=" [CS:N]P-Palkia[CR]!", italian=" [CS:N]P-Palkia[CR]!", spanish=" ¡[CS:N]Palkia[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]P-Palkia[CR]!", french=" [CS:N]P-Palkia[CR]!", german=" [CS:N]P-Palkia[CR]!", italian=" [CS:N]P-Palkia[CR]!", spanish=" ¡[CS:N]Palkia[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" YOUR RESISTANCE IS USELESS!", french="TOUTE RESISTANCE EST\nINUTILE!", german=" WIDERSTAND IST ZWECKLOS!", italian="È INUTILE OPPORRE\nRESISTENZA!", spanish=" ¡ES INÚTIL RESISTIRSE!"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="YOU WILL NEVER ESCAPE FROM\nTHIS PLACE!", french="VOUS NE SORTIREZ JAMAIS\nD'ICI!", german="VON HIER KOMMT IHR NICHT\nMEHR WEG!", italian=" NON USCIRETE MAI DA QUI!", spanish="¡NUNCA LOGRARÉIS ESCAPAR\nDE AQUÍ!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk...", french=" Argh...", german=" Uff...", italian=" Uh...", spanish=" Uf..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk...", french=" Argh...", german=" Uff...", italian=" Uh...", spanish=" Uf..."})
  else
  SkySceneKit.say({english=" Urk...", french=" Argh...", german=" Uff...", italian=" Uh...", spanish=" Uf..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" I WILL REVEAL WHY!", french=" ET VOICI POURQUOI!", german=" ICH ERÖFFNE EUCH, WARUM!", italian=" VI RIVELERÒ IL MOTIVO!", spanish=" ¡OS DIRÉ POR QUÉ!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" IT IS YOUR FATE...", french=" LE DESTIN VEUT QUE...", german=" ES IST EUER SCHICKSAL...", italian=" IL VOSTRO DESTINO È...", spanish=" ES VUESTRO DESTINO..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" TO BE OBLITERATED BY ME!", french=" ... JE VOUS ANEANTISSE!", german="VON MIR BESEITIGT ZU\nWERDEN!", italian=" ... SPARIRE PER MANO MIA!", spanish=" ¡QUE OS ELIMINE!"})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" H-here he comes, [hero]!", french=" Le... le voilà, [hero]!", german=" H-hier kommt es, [hero]!", italian=" Ecco che arriva, [hero]!", spanish="Vi... ¡viene hacia aquí,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" H-here he comes, [hero]!", french=" Le... le voilà, [hero]!", german=" H-hier kommt es, [hero]!", italian=" Ecco che arriva, [hero]!", spanish="Vi... ¡viene hacia aquí,\n[hero]!"})
  else
  SkySceneKit.say({english=" H-here he comes, [hero]!", french=" Le... le voilà, [hero]!", german=" H-hier kommt es, [hero]!", italian=" Ecco che arriva, [hero]!", spanish="Vi... ¡viene hacia aquí,\n[hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We have to fight!", french=" Nous allons devoir nous battre!", german=" Wir müssen kämpfen!", italian=" Dobbiamo lottare!", spanish=" ¡Hay que luchar!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We have to fight!", french=" Nous allons devoir nous battre!", german=" Wir müssen kämpfen!", italian=" Dobbiamo lottare!", spanish=" ¡Hay que luchar!"})
  else
  SkySceneKit.say({english=" We have to fight!", french=" Nous allons devoir nous battre!", german=" Wir müssen kämpfen!", italian=" Dobbiamo lottare!", spanish=" ¡Hay que luchar!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" THIS IS IT!", french=" C'EST FINI!", german=" ES IST SO WEIT!", italian=" È LA FINE!", spanish=" ¡HA LLEGADO EL MOMENTO!"})
  -- message_Close
  -- SetAnimation(18) [anim idle native]
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(5136) — id SE NDS sans portage PMDO identifié
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
