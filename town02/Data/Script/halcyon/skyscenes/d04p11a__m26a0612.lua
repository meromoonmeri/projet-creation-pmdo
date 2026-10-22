-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D04P11A/m26a0612.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_MEMORIES_RETURNED non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_D04P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'm going to believe you,\n[hero]!", french="Je te crois,\n[hero]!", german=" Ich glaube dir, [hero]!", italian="Ti credo,\n[hero]!", spanish=" ¡Me fiaré de ti, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm putting my faith in you,\n[hero]!", french="Je te crois,\n[hero]!", german=" Ich vertraue dir, [hero]!", italian="Ti credo,\n[hero]!", spanish=" ¡Confiaré en ti, [hero]!"})
  else
  SkySceneKit.say({english="I'm going to believe you,\n[hero]!", french="Je te crois,\n[hero]!", german=" Ich glaube dir, [hero]!", italian="Ti credo,\n[hero]!", spanish=" ¡Confiaré en ti, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yes! I totally believe in you,\n[hero]!", french="Oui! J'ai entièrement confiance\nen toi, [hero]!", german="Ja! Ich glaube fest an dich,\n[hero]!", italian="Sì! Mi fido ciecamente di te,\n[hero]!", spanish="¡La verdad es que creo en ti,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yes! I totally believe in you,\n[hero].", french="Oui! J'ai entièrement confiance\nen toi, [hero]!", german="Ja! Ich glaube fest an dich,\n[hero]!", italian="Sì! Mi fido ciecamente di te,\n[hero]!", spanish="¡La verdad es que creo en ti,\n[hero]!"})
  else
  SkySceneKit.say({english="Yes! I totally believe in you,\n[hero]!", french="Oui! J'ai entièrement confiance\nen toi, [hero]!", german="Ja! Ich glaube fest an dich,\n[hero]!", italian="Sì! Mi fido ciecamente di te,\n[hero]!", spanish="¡La verdad es que creo en ti,\n[hero]!"})
  end
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
end
