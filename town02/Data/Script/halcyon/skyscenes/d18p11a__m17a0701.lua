-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D18P11A/m17a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(18, 4) -- $SCENARIO_MAIN = scn[18,4] (ROM)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...[K] We couldn't get through...", french=" Argh...[K] On a échoué...", german=" Ugh...[K] Wir haben versagt...", italian=" Uff...[K] Non ce l'abbiamo fatta...", spanish=" Ay...[K] No hemos podido pasar..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ouch...[K] We couldn't get through...", french=" Argh...[K] On a échoué...", german=" Autsch...[K] Wir haben versagt...", italian="Ouch...[K] Non ce l'abbiamo\nfatta...", spanish=" Ay...[K] No hemos podido pasar..."})
  else
  SkySceneKit.say({english=" Ouch...[K] We couldn't get through...", french=" Argh...[K] On a échoué...", german=" Autsch...[K] Wir haben versagt...", italian=" Ouch...[K] Non ce l'abbiamo fatta...", spanish=" Ay...[K] No hemos podido pasar..."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D18P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Chasm Cave.ogg", true) end)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  GAME:WaitFrames(15)
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 120, 200, Direction.Right, "NPC_JUPUTORU")
  GROUND:EntTurn(npc_npc_juputoru, Direction.Down)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hmmm... Maybe we got a little\ntoo careless.", french="Hum... On n'a pas fait assez\nattention.", german="Hmmm... Vielleicht waren wir\netwas zu leichtsinnig.", italian="Mmm... Forse dovevamo fare più\nattenzione.", spanish="Hum... Tal vez nos hemos\ndescuidado un poco."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hmmm... I think we got a little\ntoo careless.", french="Hum... On n'a pas fait assez\nattention.", german="Hmmm... Wir waren wohl zu\nleichtsinnig.", italian="Mmm... Dovevamo fare più\nattenzione.", spanish="Hum... Tal vez nos hemos\ndescuidado un poco."})
  else
  SkySceneKit.say({english="Hmmm... I think we were a bit\ntoo careless.", french="Hum... On n'a pas fait assez\nattention.", german="Hmmm... Ich glaube, wir waren\nzu leichtsinnig.", italian="Mmm... Dovevamo fare più\nattenzione.", spanish="Hum... Tal vez nos hemos\ndescuidado un poco."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I guess the [CS:N]Sableye[CR] aren't here\nyet...", french="On dirait que les [CS:N]Ténéfix[CR]\nne sont pas là...", german="Ich schätze, die [CS:N]Zobiris[CR] sind\nnoch nicht hier...", italian="Credo che i [CS:N]Sableye[CR] non siano\nancora arrivati.", spanish="Supongo que los [CS:N]Sableye[CR] aún no\nhan llegado hasta aquí..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I guess the [CS:N]Sableye[CR] aren't here\nyet...", french="On dirait que les [CS:N]Ténéfix[CR]\nne sont pas là...", german="Ich schätze, die [CS:N]Zobiris[CR] sind\nnoch nicht hier...", italian="Credo che i [CS:N]Sableye[CR] non siano\nancora arrivati.", spanish="Supongo que los [CS:N]Sableye[CR] aún no\nhan llegado hasta aquí..."})
  else
  SkySceneKit.say({english="I guess the [CS:N]Sableye[CR] aren't here\nyet...", french="On dirait que les [CS:N]Ténéfix[CR]\nne sont pas là...", german="Ich schätze, die [CS:N]Zobiris[CR] sind\nnoch nicht hier...", italian="Credo che i [CS:N]Sableye[CR] non siano\nancora arrivati.", spanish="Supongo que los [CS:N]Sableye[CR] aún no\nhan llegado hasta aquí..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Anyway, we need to get out of\nhere quick!", french="Enfin, il faut qu'on sorte d'ici\nau plus vite!", german="Auch egal, wir müssen schnell\nhier raus!", italian="In ogni caso, dobbiamo andarcene\nda qui alla svelta!", spanish="De todas formas, ¡debemos\nirnos de aquí cuanto antes!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Anyway, we have to get away\nfrom here.", french="Enfin, il faut qu'on sorte d'ici\nau plus vite!", german="Auch egal, wir müssen von hier\nweg.", italian="In ogni caso, dobbiamo andarcene\nda qui alla svelta!", spanish="De todas formas, ¡debemos\nirnos de aquí cuanto antes!"})
  else
  SkySceneKit.say({english="Anyway, we still have to get\naway from here quickly!", french="Enfin, il faut qu'on sorte d'ici\nau plus vite!", german="Auch egal, wir müssen trotzdem\nschnell hier raus!", italian="In ogni caso, dobbiamo andarcene\nda qui alla svelta!", spanish="De todas formas, ¡debemos\nirnos de aquí cuanto antes!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We'll go when you're ready.", french=" On part quand tu veux.", german=" Wir gehen, wenn du so weit bist.", italian=" Quando siamo pronti partiamo.", spanish=" Nos iremos cuando tú digas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go when you're ready.", french=" On part quand tu veux.", german=" Gehen wir, wenn du so weit bist.", italian=" Quando siamo pronti andiamo.", spanish=" Nos iremos cuando tú digas."})
  else
  SkySceneKit.say({english=" Let's go when you're ready.", french=" On part quand tu veux.", german=" Gehen wir, wenn du so weit bist.", italian=" Quando è tutto pronto andiamo.", spanish=" Nos iremos cuando tú digas."})
  end
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
