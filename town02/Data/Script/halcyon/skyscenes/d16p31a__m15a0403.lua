-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D16P31A/m15a0403.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_D16P31A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetAnimation(10) [anim idle native]
  -- SetAnimation(10) [anim idle native]
  -- SetAnimation(10) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Groudon's stone statue held the secret!)", french="(C'est la statue de Groudon qui gardait\nle secret!)", german="(Da war die Statue von Groudon der\nSchlüssel!)", italian="(La chiave di tutto era nella statua di\nGroudon!)", spanish="(El secreto estaba en la estatua de Groudon.)"})
  else
  SkySceneKit.say({english="(Groudon's stone statue held the secret!)", french="(C'est la statue de Groudon qui gardait\nle secret!)", german="(Da war die Statue von Groudon der\nSchlüssel!)", italian="(La chiave di tutto era nella statua di\nGroudon!)", spanish="(El secreto estaba en la estatua de Groudon.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Then, on the way to the [CS:P]Underground Lake[CR],\nwhere we met [CS:N]Mesprit[CR]...)", french="(Plus tard, sur le chemin du [CS:P]Lac Souterrain[CR],\noù on a rencontré [CS:N]Créfollet[CR]...)", german="(Und dann, auf dem Weg zum [CS:P]Untergrundsee[CR],\nwo wir [CS:N]Vesprit[CR] trafen...)", italian="(Invece, nel nostro viaggio al [CS:P]Lago[CR]\n[CS:P]Sotterraneo[CR], dove abbiamo conosciuto\n[CS:N]Mesprit[CR]...)", spanish="(Luego, cuando fuimos al [CS:P]Lago Subterráneo[CR],\nantes de encontrarnos con [CS:N]Mesprit[CR]...)"})
  else
  SkySceneKit.say({english="(Then, on the way to the [CS:P]Underground Lake[CR],\nwhere we met [CS:N]Mesprit[CR]...)", french="(Plus tard, sur le chemin du [CS:P]Lac Souterrain[CR],\noù on a rencontré [CS:N]Créfollet[CR]...)", german="(Und dann, auf dem Weg zum [CS:P]Untergrundsee[CR],\nwo wir [CS:N]Vesprit[CR] trafen...)", italian="(Invece, nel nostro viaggio al [CS:P]Lago[CR]\n[CS:P]Sotterraneo[CR], dove abbiamo conosciuto\n[CS:N]Mesprit[CR]...)", spanish="(Luego, cuando fuimos al [CS:P]Lago Subterráneo[CR],\nantes de encontrarnos con [CS:N]Mesprit[CR]...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:FadeOut(false, 30)
end
