-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D08P11A/m09d0112.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D08P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hm? What's up, [hero]?", french=" Quoi? Qu'y a-t-il, [hero]?", german=" Hm? Was ist los, [hero]?", italian=" Eh? Cosa c'è, [hero]?", spanish=" ¿Qué pasa, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hm? What's wrong,\n[hero]?", french=" Quoi? Qu'y a-t-il, [hero]?", german="Hm? Stimmt was nicht,\n[hero]?", italian="Eh? Cosa c'è che non va,\n[hero]?", spanish=" ¿Qué te pasa, [hero]?"})
  else
  SkySceneKit.say({english="Hm? What's wrong,\n[hero]?", french=" Quoi? Qu'y a-t-il, [hero]?", german="Hm? Stimmt was nicht,\n[hero]?", italian="Eh? Cosa c'è che non va,\n[hero]?", spanish=" ¿Qué te ocurre, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...)", french="(...)", german="(...)", italian="(...)", spanish="(...)"})
  else
  SkySceneKit.say({english="(...)", french="(...)", german="(...)", italian="(...)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What's this weird sensation?)", french="(Quelle est cette sensation étrange?)", german="(Was ist das für ein seltsames Gefühl?)", italian="(Cos'è questa strana sensazione?)", spanish="(¿Qué es esa sensación tan rara?)"})
  else
  SkySceneKit.say({english="(What's this weird sensation?)", french="(Quelle est cette sensation étrange?)", german="(Was ist das für ein seltsames Gefühl?)", italian="(Cos'è questa strana sensazione?)", spanish="(¿Qué es esa sensación tan rara?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I don't know why I'm feeling this way...)", french="(Je ne sais pas pourquoi je ressens ça...)", german="(Ich weiß nicht, woher es kommt...)", italian="(Non so perché mi sento così...)", spanish="(No sé por qué me siento así.)"})
  else
  SkySceneKit.say({english="(I don't know why I'm feeling this way...)", french="(Je ne sais pas pourquoi je ressens ça...)", german="(Ich weiß nicht, woher es kommt...)", italian="(Non so perché mi sento così...)", spanish="(No sé por qué me siento así.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I...)", french="(Je...)", german="(Ich...)", italian="(Io...)", spanish="(Yo...)"})
  else
  SkySceneKit.say({english="(I...)", french="(Je...)", german="(Ich...)", italian="(Io...)", spanish="(Yo...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Wait a second! I know this place!)", french="(C'est ça! Je connais cet endroit!)", german="(Moment mal! Ich kenne diesen Ort!)", italian="(Un secondo! Questo posto lo conosco!)", spanish="(¡Un momento! ¡Yo conozco este sitio!)"})
  else
  SkySceneKit.say({english="(Wait a second! I know this place!)", french="(C'est ça! Je connais cet endroit!)", german="(Moment mal! Ich kenne diesen Ort!)", italian="(Un secondo! Questo posto lo conosco!)", spanish="(¡Un momento! ¡Yo conozco este sitio!)"})
  end
  -- message_Close
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:FadeIn(0) -- screen_FlushIn
end
