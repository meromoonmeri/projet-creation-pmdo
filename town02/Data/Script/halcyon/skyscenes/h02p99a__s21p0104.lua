-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s21p0104.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Why are you daydreaming?[K]\nIt's not like you, [hero].", french="Tu es ailleurs ou quoi?[K]\nÇa ne te ressemble pas, [hero].", german="Warum bist du so\ngedankenverloren?[K] Das kenne ich gar nicht\nvon dir, [hero].", italian="Stai sognando a occhi aperti?[K]\nNon è da te, [hero].", spanish="¿Qué haces mirando a las\nmusarañas?[K] No es propio de ti, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Why are you daydreaming?[K]\nIt's not like you, [hero].", french="Tu es ailleurs ou quoi?[K]\nÇa ne te ressemble pas, [hero].", german="Warum bist du so\ngedankenverloren?[K] Das kenne ich gar nicht\nvon dir, [hero].", italian="Stai sognando a occhi aperti?[K]\nNon è da te, [hero].", spanish="¿Qué haces mirando a las\nmusarañas?[K] No es propio de ti, [hero]."})
  else
  SkySceneKit.say({english="Why are you daydreaming?[K]\nIt's not like you, [hero].", french="Tu es ailleurs ou quoi?[K]\nÇa ne te ressemble pas, [hero].", german="Warum bist du so\ngedankenverloren?[K] Das kenne ich gar nicht\nvon dir, [hero].", italian="Stai sognando a occhi aperti?[K]\nNon è da te, [hero].", spanish="¿Qué haces mirando a las\nmusarañas?[K] No es propio de ti, [hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Come on, let's see some energy,\n[hero]!", french="Allons, un peu d'entrain,\n[hero]!", german="Komm schon, zeig etwas Elan,\n[hero]!", italian="Forza, mettici un po' di energia,\n[hero]!", spanish="Venga, ¡un poco de energía,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Come on, let's see some energy,\n[hero]!", french="Allons, un peu d'entrain,\n[hero]!", german="Komm schon, zeig etwas Elan,\n[hero]!", italian="Forza, mettici un po' di energia,\n[hero]!", spanish="Venga, ¡un poco de energía,\n[hero]!"})
  else
  SkySceneKit.say({english="Come on, let's see some energy,\n[hero]!", french="Allons, un peu d'entrain,\n[hero]!", german="Komm schon, zeig etwas Elan,\n[hero]!", italian="Forza, mettici un po' di energia,\n[hero]!", spanish="Venga, ¡un poco de energía,\n[hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner]'s even peppier than usual.)", french="([partner] montre encore plus de vivacité\nque d'habitude.)", german="([partner] ist sogar noch schwungvoller\nals gewöhnlich.)", italian="([partner] è più vivace del solito.)", spanish="(Qué vitalidad la de [partner].)"})
  else
  SkySceneKit.say({english="([partner]'s even peppier than usual.)", french="([partner] montre encore plus de vivacité\nque d'habitude.)", german="([partner] ist sogar noch schwungvoller\nals gewöhnlich.)", italian="([partner] è più vivace del solito.)", spanish="(Qué vitalidad la de [partner].)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But...[K][partner] could be right.)", french="(Mais...[K] [partner] a sûrement raison.)", german="(Aber...[K] [partner] könnte recht haben.)", italian="(Ma...[K] [partner] forse ha ragione.)", spanish="(Aunque...[K] [partner] tal vez tenga razón.)"})
  else
  SkySceneKit.say({english="(But...[K][partner] could be right.)", french="(Mais...[K] [partner] a sûrement raison.)", german="(Aber...[K] [partner] könnte recht haben.)", italian="(Ma...[K] [partner] forse ha ragione.)", spanish="(Aunque...[K] [partner] tal vez tenga razón.)"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
end
