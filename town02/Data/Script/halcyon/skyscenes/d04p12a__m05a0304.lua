-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D04P12A/m05a0304.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
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
  SkySceneKit.say({english=" Yowowow...", french=" Oooh...", german=" Auauau...", italian=" Ahiahiahi...", spanish=" ¡Huyuyuy!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yowowow...", french=" Oooh...", german=" Auauau...", italian=" Ahiahiahi...", spanish=" ¡Huyuyuy!"})
  else
  SkySceneKit.say({english=" Yowowow...", french=" Oooh...", german=" Auauau...", italian=" Ahiahiahi...", spanish=" ¡Huyuyuy!"})
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
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" W-what is this?!", french=" Que... qu'est-ce que c'est?!", german=" W-was ist das?!?", italian=" Dove siamo finiti?!", spanish=" ¿Qué... qué es esto?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" W-what is this?!", french=" Que... qu'est-ce que c'est?!", german=" W-was ist das?!?", italian=" Dove siamo?!", spanish=" ¿Qué... qué es esto?"})
  else
  SkySceneKit.say({english=" W-what is this?!", french=" Que... qu'est-ce que c'est?!", german=" W-was ist das?!?", italian=" Cos'è questo posto?!", spanish=" ¿Qué... qué es esto?"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yes! It is a cave!", french=" Oui! C'est bien une grotte!", german=" Ja! Es ist eine Höhle!", italian=" Sì! È una caverna!", spanish=" ¡Hala! ¡Es una cueva!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes! It is a cave!", french=" Oui! C'est bien une grotte!", german=" Ja! Es ist eine Höhle!", italian=" Sì! È una caverna!", spanish=" ¡Hala! ¡Es una cueva!"})
  else
  SkySceneKit.say({english=" Yes! It is a cave!", french=" Oui! C'est bien une grotte!", german=" Ja! Es ist eine Höhle!", italian=" Sì! È una caverna!", spanish=" ¡Hala! ¡Es una cueva!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You were right after all,\n[hero]!", french="Tu avais raison,\n[hero]!", german="Du hattest tatsächlich recht,\n[hero]!", italian="Avevi ragione,\n[hero]!", spanish=" ¡Tenías razón, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You were right after all,\n[hero]!", french="Tu avais raison,\n[hero]!", german="Du hattest tatsächlich recht,\n[hero]!", italian="Avevi ragione,\n[hero]!", spanish=" ¡Tenías razón, [hero]!"})
  else
  SkySceneKit.say({english="You were right after all,\n[hero]!", french="Tu avais raison,\n[hero]!", german="Du hattest tatsächlich recht,\n[hero]!", italian="Avevi ragione,\n[hero]!", spanish=" ¡Tenías razón, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's go explore this cave,\n[hero]!", french="Partons explorer cette grotte,\n[hero]!", german="Lass uns diese Höhle erkunden,\n[hero]!", italian="Andiamo a esplorare questa\ncaverna, [hero]!", spanish="¡Vamos a explorar la cueva,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go explore this cave,\n[hero]!", french="Partons explorer cette grotte,\n[hero]!", german="Lass uns diese Höhle erkunden,\n[hero]!", italian="Andiamo a esplorare questa\ncaverna, [hero]!", spanish="¡Vamos a explorar la cueva,\n[hero]!"})
  else
  SkySceneKit.say({english="Let's go explore this cave,\n[hero]!", french="Partons explorer cette grotte,\n[hero]!", german="Lass uns diese Höhle erkunden,\n[hero]!", italian="Andiamo a esplorare questa\ncaverna, [hero]!", spanish="¡Vamos a explorar la cueva,\n[hero]!"})
  end
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's see what secrets it holds!", french="Et découvrons quels sont\nses secrets!", german=" Lüften wir ihr Geheimnis!", italian=" Vediamo quali segreti nasconde!", spanish=" ¡Veamos qué secretos esconde!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's see what secrets it holds!", french="Et découvrons quels sont\nses secrets!", german=" Lüften wir ihr Geheimnis!", italian=" Vediamo quali segreti nasconde!", spanish=" ¡Veamos qué secretos esconde!"})
  else
  SkySceneKit.say({english=" Let's see what secrets it holds!", french="Et découvrons quels sont\nses secrets!", german=" Lüften wir ihr Geheimnis!", italian=" Vediamo quali segreti nasconde!", spanish=" ¡Veamos qué secretos esconde!"})
  end
  -- message_Close
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-160), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-160), false, 2) end
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  SkyProg.set(6, 5) -- $SCENARIO_MAIN = scn[6,5] (ROM)
  -- main_EnterDungeon(6, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
end
