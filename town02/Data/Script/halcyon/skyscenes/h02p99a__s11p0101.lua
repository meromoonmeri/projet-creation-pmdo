-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s11p0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- GAP: BGM BGM_DO_YOUR_BEST_AS_ALWAYS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkyProg.set(29, 98) -- $SCENARIO_MAIN = scn[29,98] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[72] = 3 -- dungeon_mode(72) = DMODE_OPEN_AND_REQUEST (ROM)
  -- supervision_Acting(0) [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Oh! [hero]! [partner]!", french=" Oh! [hero]! [partner]!", german=" Oh! [hero]! [partner]!", italian=" Oh! [hero]! [partner]!", spanish=" ¡Eh! ¡[hero]! ¡[partner]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" Good morning! Are you awake?", french=" Bonjour! Vous êtes debout?", german=" Guten Morgen! Seid ihr wach?", italian=" Buongiorno! Dormite ancora?", spanish=" ¡Buenos días! ¿Ya os habéis despertado?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hm? Who's out there?", french=" Hm? Qui est-ce?", german=" Hm? Wer ist da draußen?", italian=" Eh? Chi c'è lì fuori?", spanish=" ¿Eh? ¿Quién anda ahí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hm? Who could that be?", french=" Hm? Qui est-ce?", german=" Hm? Wer könnte das sein?", italian=" Eh? Chi può essere?", spanish=" ¿Eh? ¿Quién anda ahí?"})
  else
  SkySceneKit.say({english=" Hm? Who's our visitor?", french=" Hm? Qui est-ce?", german=" Hm? Wer fragt?", italian=" Eh? Chi può essere?", spanish=" ¿Eh? ¿Quién anda ahí?"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
end
