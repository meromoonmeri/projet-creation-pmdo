-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99C/s20p0203.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_H02P99C) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:EntTurn(partner, Direction.Left)
  -- SetAnimation(62) [anim idle native]
  GAME:WaitFrames(2) -- join WaitSe
  GAME:FadeIn(5)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="Gasp!", french="Gloups!", german="Schluck!", italian="Gasp!", spanish="¡Ah!"})
  else
  SkySceneKit.say({english="Gasp!", french="Gloups!", german="Schluck!", italian="Gasp!", spanish="¡Ah!"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="...[K]Wh-what was that?", french="...[K] Qu... qu'est-ce que c'était?", german="...[K]W-was war das denn?", italian="...[K] C-Cosa è stato?", spanish="¿Qué...?[K] ¿Qué ha sido eso?"})
  else
  SkySceneKit.say({english="...[K]Wh-what was that?", french="...[K] Qu... qu'est-ce que c'était?", german="...[K]W-was war das denn?", italian="...[K] C-Cosa è stato?", spanish="¿Qué...?[K] ¿Qué ha sido eso?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="[partner] is...[K]asleep.", french="[partner]...[K] dort à poings fermés.", german="[partner]...[K] schläft.", italian="[partner] sta...[K] dormendo.", spanish="[partner] está...[K] durmiendo."})
  else
  SkySceneKit.say({english="[partner] is...[K]asleep.", french="[partner]...[K] dort à poings fermés.", german="[partner]...[K] schläft.", italian="[partner] sta...[K] dormendo.", spanish="[partner] está...[K] durmiendo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="I guess...[K]that was a dream...?", french="Je suppose...[K] que ce n'était qu'un rêve...", german="Ich nehme an,[K] das war ein Traum?", italian="Sarà stato...[K] un sogno?", spanish="Supongo...[K] que estaría soñando..."})
  else
  SkySceneKit.say({english="I guess...[K]that was a dream...?", french="Je suppose...[K] que ce n'était qu'un rêve...", german="Ich nehme an,[K] das war ein Traum?", italian="Sarà stato...[K] un sogno?", spanish="Supongo...[K] que estaría soñando..."})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="What a strange dream, though.", french="Mais quel rêve étrange.", german="Was für ein seltsamer Traum noch dazu.", italian="Ma che sogno strano.", spanish="Qué sueño más raro."})
  else
  SkySceneKit.say({english="What a strange dream, though.", french="Mais quel rêve étrange.", german="Was für ein seltsamer Traum noch dazu.", italian="Ma che sogno strano.", spanish="Qué sueño más raro."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="Well, there's nothing I can do about that...", french="Eh bien, il n'y a pas grand-chose à y faire...", german="Na ja, da kann ich wohl nichts machen...", italian="Beh, non c'è niente che io possa fare...", spanish="Bueno, qué le vamos a hacer..."})
  else
  SkySceneKit.say({english="Well, there's nothing I can do about that...", french="Eh bien, il n'y a pas grand-chose à y faire...", german="Na ja, da kann ich wohl nichts machen...", italian="Beh, non c'è niente che io possa fare...", spanish="Bueno, qué le vamos a hacer..."})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="It's not even dawn...[K] I'll get more sleep.", french="Il ne fait pas encore jour...[K] Je vais dormir\nencore un peu.", german="Es ist noch nicht einmal Morgen...[K] Ich lege\nmich noch mal schlafen.", italian="Non è ancora l'alba...[K] Dormirò ancora un po'.", spanish="Aún no ha amanecido...[K] Seguiré durmiendo."})
  else
  SkySceneKit.say({english="It's not even dawn...[K] I'll get more sleep.", french="Il ne fait pas encore jour...[K] Je vais dormir\nencore un peu.", german="Es ist noch nicht einmal Morgen...[K] Ich lege\nmich noch mal schlafen.", italian="Non è ancora l'alba...[K] Dormirò ancora un po'.", spanish="Aún no ha amanecido...[K] Seguiré durmiendo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- SetAnimation(76) [anim idle native]
  GAME:WaitFrames(60)
  -- SetAnimation(62) [anim idle native]
  GAME:WaitFrames(60)
  pcall(function() SOUND:FadeOutBGM(180) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(60)
end
