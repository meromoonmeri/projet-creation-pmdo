-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D28P44A/m25a0304.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D28P44A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(10) [anim idle native]
  -- GAP: SetEffect 653 — VFX sans émote PMDO équivalente
  -- GAP: BGM BGM_IN_THE_HANDS_OF_FATE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That's right...)", french="(C'est vrai...)", german="(Das stimmt...)", italian="(È vero...)", spanish="(Sí que es duro.)"})
  else
  SkySceneKit.say({english="(That's right...)", french="(C'est vrai...)", german="(Das stimmt...)", italian="(È vero...)", spanish="(Sí que es duro.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(If the future is changed, [CS:N]Grovyle[CR] will\ndisappear...)", french="(Si on modifie le futur, [CS:N]Massko[CR] disparaîtra...)", german="(Wenn die Zukunft verändert wird, dann wird\n[CS:N]Reptain[CR] verschwinden.)", italian="(Se il futuro cambia, [CS:N]Grovyle[CR] scomparirà...)", spanish="(Si el futuro cambia, [CS:N]Grovyle[CR] desaparecerá.)"})
  else
  SkySceneKit.say({english="(If the future is changed, [CS:N]Grovyle[CR] will\ndisappear...)", french="(Si on modifie le futur, [CS:N]Massko[CR] disparaîtra...)", german="(Wenn die Zukunft verändert wird, dann wird\n[CS:N]Reptain[CR] verschwinden.)", italian="(Se il futuro cambia, [CS:N]Grovyle[CR] scomparirà...)", spanish="(Si el futuro cambia, [CS:N]Grovyle[CR] desaparecerá.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(And...[K]I will disappear too...)", french="(Et moi aussi...[K] je disparaîtrai...)", german="(Und...[K] Auch ich werde verschwinden.)", italian="(E...[K] anche io scomparirò...)", spanish="(Y...[K] yo también.)"})
  else
  SkySceneKit.say({english="(And...[K]I will disappear too...)", french="(Et moi aussi...[K] je disparaîtrai...)", german="(Und...[K] Auch ich werde verschwinden.)", italian="(E...[K] anche io scomparirò...)", spanish="(Y...[K] yo también.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 276, 188, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(45)
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [hero].", french=" Eh, [hero].", german=" Hey, [hero].", italian=" Ehi, [hero].", spanish=" Oye, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey, [hero].", french=" Eh, [hero].", german=" Hey, [hero].", italian=" Ehi, [hero].", spanish=" Oye, [hero]."})
  else
  SkySceneKit.say({english=" Say, [hero].", french=" Eh, [hero].", german=" Sag mal, [hero].", italian=" Senti, [hero].", spanish=" Oye, [hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The last thing [CS:N]Grovyle[CR] said to\nyou, [hero]...", french="La dernière chose que [CS:N]Massko[CR]\nt'a dite, [hero]...", german="Das Letzte, was [CS:N]Reptain[CR] zu dir\nsagte, [hero]...", italian="L'ultima cosa che ti ha detto\n[CS:N]Grovyle[CR], [hero]...", spanish="Lo último que te dijo [CS:N]Grovyle[CR],\n[hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The last thing [CS:N]Grovyle[CR] said to\nyou, [hero]...", french="La dernière chose que [CS:N]Massko[CR]\nt'a dite, [hero]...", german="Das Letzte, was [CS:N]Reptain[CR] zu dir\nsagte, [hero]...", italian="L'ultima cosa che ti ha detto\n[CS:N]Grovyle[CR], [hero]...", spanish="Lo último que te dijo [CS:N]Grovyle[CR],\n[hero]..."})
  else
  SkySceneKit.say({english="The last thing [CS:N]Grovyle[CR] said to\nyou, [hero]...", french="La dernière chose que [CS:N]Massko[CR]\nt'a dite, [hero]...", german="Das Letzte, was [CS:N]Reptain[CR] zu dir\nsagte, [hero]...", italian="L'ultima cosa che ti ha detto\n[CS:N]Grovyle[CR], [hero]...", spanish="Lo último que te dijo [CS:N]Grovyle[CR],\n[hero]..."})
  end
  -- message_Close
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
