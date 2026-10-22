-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11B/m26a0605.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_ON_THE_BEACH_AT_DUSK_SHORTENED non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back_SetGround(LEVEL_D01P11B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- supervision_SpecialActing(21, 0, 0) [cadrage NDS]
  -- supervision2_SpecialActing(21, 0, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
  -- SetOutputAttribute(2) [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  GROUND:MoveToPosition(partner, 532, 196, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(partner, 532, 172, false, 1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wow! This is beautiful!", french=" Waouh! Comme c'est beau!", german=" Wow! Das ist wunderschön!", italian=" Wow! È bellissimo!", spanish=" ¡Vaya! ¡Es increíble!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, wow... This is beautiful!", french=" Waouh! Comme c'est beau!", german=" Oh, wow! Das ist wunderschön!", italian=" Oh, wow... È magnifico!", spanish=" ¡Qué hermoso!"})
  else
  SkySceneKit.say({english=" Oh, wow... This is so pretty!", french=" Waouh! Comme c'est beau!", german=" Oh, wow... Das ist so hübsch!", italian=" Oh, wow... È stupendo!", spanish=" ¡Qué bonito!"})
  end
  -- message_Close
  GAME:WaitFrames(60)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- screen2_FadeOut [sub déjà caché]
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- supervision_SpecialActing(3, 0, 0) [cadrage NDS]
  -- supervision2_SpecialActing(3, 0, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
end
