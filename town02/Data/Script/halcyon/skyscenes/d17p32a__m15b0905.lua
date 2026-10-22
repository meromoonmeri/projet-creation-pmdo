-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D17P32A/m15b0905.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_OH_NO non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_D17P32A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(This is...)", french="(C'est...)", german="(Das...)", italian="(Questa...)", spanish="(Esto es...)"})
  else
  SkySceneKit.say({english="(This is...)", french="(C'est...)", german="(Das...)", italian="(Questa...)", spanish="(Esto es...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(This is what I saw in my vision during that\nDimensional Scream!)", french="(C'est exactement comme dans la vision que\nj'ai eue!)", german="(Das habe ich in der Vision gesehen, die mir\nder Dimensionale Schrei eingegeben hat!)", italian="(Questa è la stessa scena che ho visto\ncon lo Squarcio Dimensionale!)", spanish="(¡Esto es lo que vi con la Percepción de\nCronos!)"})
  else
  SkySceneKit.say({english="(This is what I saw in my vision during that\nDimensional Scream!)", french="(C'est exactement comme dans la vision que\nj'ai eue!)", german="(Das habe ich in der Vision gesehen, die mir\nder Dimensionale Schrei eingegeben hat!)", italian="(Questa è la stessa scena che ho visto\ncon lo Squarcio Dimensionale!)", spanish="(¡Esto es lo que vi con la Percepción de\nCronos!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The vision I saw then...[K] It was an event in\nthe future after all!)", french="(Donc cette vision...[K] concernait bien\nun événement à venir!)", german="(Die Vision, die ich hatte...[K] Das war also doch\nein Ereignis aus der Zukunft!)", italian="(Allora si trattava...[K] di un evento futuro!)", spanish="(Esa visión que tuve...[K] ¡Realmente sucedía\nen el futuro!)"})
  else
  SkySceneKit.say({english="(The vision I saw then...[K] It was an event in\nthe future after all!)", french="(Donc cette vision...[K] concernait bien\nun événement à venir!)", german="(Die Vision, die ich hatte...[K] Das war also doch\nein Ereignis aus der Zukunft!)", italian="(Allora si trattava...[K] di un evento futuro!)", spanish="(Esa visión que tuve...[K] ¡Realmente sucedía\nen el futuro!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Who is that over there? [CS:N]Azelf[CR]?!", french=" C'est qui ça, là-bas? [CS:N]Créfadet[CR]?!", german=" Wer ist das? [CS:N]Tobutz[CR]?!?", italian=" Chi è quello? È forse [CS:N]Azelf[CR]?!", spanish=" ¿Quién está ahí? ¡¿[CS:N]Azelf[CR]?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Who is that over there? [CS:N]Azelf[CR]?!", french=" C'est qui ça, là-bas? [CS:N]Créfadet[CR]?!", german=" Wer ist das? [CS:N]Tobutz[CR]?!?", italian=" Chi è quello? È forse [CS:N]Azelf[CR]?!", spanish=" ¿Quién está ahí? ¡¿[CS:N]Azelf[CR]?!"})
  else
  SkySceneKit.say({english=" Who is that over there? [CS:N]Azelf[CR]?!", french=" C'est qui ça, là-bas? [CS:N]Créfadet[CR]?!", german=" Wer ist das? [CS:N]Tobutz[CR]?!?", italian=" Chi è quello? È forse [CS:N]Azelf[CR]?!", spanish=" ¿Quién está ahí? ¡¿[CS:N]Azelf[CR]?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" If it is, [CS:N]Azelf[CR]'s in trouble!", french="Si c'est bien lui, alors il a\ndes ennuis!", german="Wenn ja, dann steckt [CS:N]Tobutz[CR]\nin Schwierigkeiten!", italian=" Beh, se lo è, [CS:N]Azelf[CR] è nei guai!", spanish=" Si es así, ¡[CS:N]Azelf[CR] está en peligro!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" If it is, [CS:N]Azelf[CR]'s in trouble!", french="Si c'est bien lui, alors il a\ndes ennuis!", german="Wenn ja, dann steckt [CS:N]Tobutz[CR]\nin Schwierigkeiten!", italian=" Se lo è, [CS:N]Azelf[CR] è nei guai!", spanish=" Si es así, ¡[CS:N]Azelf[CR] está en peligro!"})
  else
  SkySceneKit.say({english=" If it is, [CS:N]Azelf[CR]'s in trouble!", french="Si c'est bien lui, alors il a\ndes ennuis!", german="Wenn ja, dann steckt [CS:N]Tobutz[CR]\nin Schwierigkeiten!", italian=" Se lo è, [CS:N]Azelf[CR] è nei guai!", spanish=" Si es así, ¡[CS:N]Azelf[CR] está en peligro!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go help! Hurry!", french=" Allons lui prêter main-forte!", german=" Helfen wir ihm! Schnell!", italian=" Andiamo ad aiutarlo! Presto!", spanish=" ¡Vamos a ayudarle! ¡Rápido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go help! Hurry!", french=" Allons lui prêter main-forte!", german=" Helfen wir ihm! Schnell!", italian=" Andiamo ad aiutarlo! Presto!", spanish=" ¡Vamos a ayudarle! ¡Rápido!"})
  else
  SkySceneKit.say({english=" Let's go help! Hurry!", french=" Allons lui prêter main-forte!", german=" Helfen wir ihm! Schnell!", italian=" Andiamo ad aiutarlo! Presto!", spanish=" ¡Vamos a ayudarle! ¡Rápido!"})
  end
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-180), 60, false) end) -- MovePositionOffset performer/caméra
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-180), false, 2) end
  GAME:WaitFrames(5)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-180), false, 2) end
  do local p=SkySceneKit.team_member(1).Position; GROUND:MoveToPosition(SkySceneKit.team_member(1), p.X+(0), p.Y+(-180), false, 2) end
  do local p=SkySceneKit.team_member(2).Position; GROUND:MoveToPosition(SkySceneKit.team_member(2), p.X+(0), p.Y+(-180), false, 2) end
  GAME:WaitFrames(10)
  GAME:FadeOut(false, 15)
end
