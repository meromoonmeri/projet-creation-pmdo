-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D04P12A/m05a0502.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D04P12A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: se_Play(6657) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(65) [anim idle native]
  -- SetAnimation(65) [anim idle native]
  GROUND:MoveToPosition(hero, 220, 396, false, 2)
  GROUND:MoveToPosition(partner, 188, 372, false, 2)
  GROUND:EntTurn(hero, Direction.Left)
  -- SetAnimation(68) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GROUND:EntTurn(partner, Direction.Right)
  -- SetAnimation(68) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yowowow...", french=" Oooh...", german=" Auauau...", italian=" Ahiahiahi...", spanish=" ¡Aaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yowowow...", french=" Oooh...", german=" Auauau...", italian=" Ahiahiahi...", spanish=" ¡Aaaah!"})
  else
  SkySceneKit.say({english=" Yowowow...", french=" Oooh...", german=" Auauau...", italian=" Ahiahiahi...", spanish=" ¡Aaaah!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Waterfall Cave.ogg", true) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Are you all right, [hero]?", french=" Ça va, [hero]?", german=" Alles in Ordnung, [hero]?", italian=" Stai bene, [hero]?", spanish=" ¿Todo bien, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are you OK, [hero]?", french=" Ça va, [hero]?", german=" Alles okay, [hero]?", italian=" Stai bene, [hero]?", spanish=" ¿Estás bien, [hero]?"})
  else
  SkySceneKit.say({english=" Are you OK, [hero]?", french=" Ça va, [hero]?", german=" Alles okay, [hero]?", italian=" Stai bene, [hero]?", spanish=" ¿Estás bien, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go inside.", french=" Entrons.", german=" Gehen wir rein.", italian=" Entriamo.", spanish=" ¡Adelante!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go inside.", french=" Entrons.", german=" Gehen wir rein.", italian=" Entriamo.", spanish=" ¡Vamos!"})
  else
  SkySceneKit.say({english=" Let's go inside.", french=" Entrons.", german=" Gehen wir rein.", italian=" Entriamo.", spanish=" ¡Venga!"})
  end
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-160), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-160), false, 2) end
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  -- main_EnterDungeon(6, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
end
