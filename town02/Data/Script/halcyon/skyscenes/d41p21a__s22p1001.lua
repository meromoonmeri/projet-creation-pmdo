-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D41P21A/s22p1001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...[K] That wasn't so good.", french=" Argh...[K] Ce n'était pas brillant.", german=" Uff...[K] Das war nicht so gut.", italian=" Ugh...[K] Non è finita bene.", spanish=" Uf...[K] Así no lo conseguiremos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh...[K] That's not how it's done...", french=" Argh...[K] Ce n'était pas brillant.", german=" Uff...[K] So macht man es nicht...", italian=" Ugh...[K] Non è finita bene.", spanish=" Uf...[K] Así no lo conseguiremos."})
  else
  SkySceneKit.say({english=" Ugh...[K] That didn't go well...", french=" Argh...[K] Ce n'était pas brillant.", german=" Uff...[K] Das war nicht gut...", italian=" Ugh...[K] È andata male.", spanish=" Uf...[K] Así no lo conseguiremos."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D41P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_D41P21A, 'US22') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitLockLives
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Deep Dark Crater.ogg", true) end)
  GAME:WaitFrames(30)
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(9) -- Unlock(9) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  -- Turn2Direction ACTOR_NPC_JUPUTORU [acteur sans placement SSA zone: orientation non jouée]
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk! This is harsh...", french="Argh! On a passé un sale quart\nd'heure...", german=" Umpf! Das ist heftig...", italian=" Uff! È dura...", spanish=" Esto no es nada fácil..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk! This is a real challenge...", french="Argh! On a passé un sale quart\nd'heure...", german="Umpf! Das ist eine echte\nHerausforderung...", italian=" Uff! È dura...", spanish=" Es todo un reto..."})
  else
  SkySceneKit.say({english=" Urk! What a struggle...", french="Argh! On a passé un sale quart\nd'heure...", german=" Umpf! Was für ein Ringen...", italian=" Uff! È dura...", spanish=" Menuda paliza..."})
  end
  -- message_Close
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But we have to keep going.\nThere's nothing else we can do.", french="Mais on doit s'accrocher. C'est\nla seule chose à faire.", german="Aber wir müssen weitermachen.\nWir können nichts anderes tun.", italian="Ma dobbiamo andare avanti.\nNon possiamo fare altro.", spanish="Pero tenemos que seguir\nadelante. No hay otra opción."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But there's no other option.\nWe have to keep going.", french="Mais on doit s'accrocher. C'est\nla seule chose à faire.", german="Wir haben keine andere Wahl.\nWir müssen weitermachen.", italian="Ma dobbiamo andare avanti.\nNon possiamo fare altro.", spanish="Pero tenemos que seguir\nadelante. No hay otra opción."})
  else
  SkySceneKit.say({english="But we have to keep going.\nThat's all we can do.", french="Mais on doit s'accrocher. C'est\nla seule chose à faire.", german="Aber wir müssen weitermachen.\nEine andere Möglichkeit haben wir nicht.", italian="Ma dobbiamo andare avanti.\nNon possiamo fare altro.", spanish="Pero tenemos que seguir\nadelante. No hay otra opción."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 232, 168, Direction.Down, "NPC_KURESERIA")
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" So true.", french=" Bien dit.", german=" Wie wahr.", italian=" Hai ragione.", spanish=" Cierto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kureseria, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kureseria, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" We mustn't give up now.", french="On ne peut pas abandonner\nà ce stade.", german=" Wir dürfen jetzt nicht aufgeben.", italian=" Non dobbiamo arrenderci adesso.", spanish=" No debemos rendirnos ahora."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
