-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D16P31A/m15a0405.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_D16P31A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(3) [neutre/état moteur]
  -- supervision_Acting(5) [neutre/état moteur]
  -- SetAnimation(10) [anim idle native]
  -- SetAnimation(10) [anim idle native]
  -- SetAnimation(10) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The quicksand pools allowed passage into the\n[CS:P]Underground Lake[CR]...)", french="(C'étaient les sables mouvants qui cachaient\nle passage vers le [CS:P]Lac Souterrain[CR]...)", german="(Dort waren die Treibsandstrudel der\nDurchgang zum [CS:P]Untergrundsee[CR].)", italian="(Per raggiungere il [CS:P]Lago Sotterraneo[CR] è\nstato necessario attraversare le sabbie\nmobili...)", spanish="(Las arenas movedizas fueron la clave para\ndar con el [CS:P]Lago Subterráneo[CR].)"})
  else
  SkySceneKit.say({english="(The quicksand pools allowed passage into the\n[CS:P]Underground Lake[CR]...)", french="(C'étaient les sables mouvants qui cachaient\nle passage vers le [CS:P]Lac Souterrain[CR]...)", german="(Dort waren die Treibsandstrudel der\nDurchgang zum [CS:P]Untergrundsee[CR].)", italian="(Per raggiungere il [CS:P]Lago Sotterraneo[CR] è\nstato necessario attraversare le sabbie\nmobili...)", spanish="(Las arenas movedizas fueron la clave para\ndar con el [CS:P]Lago Subterráneo[CR].)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Could this place lead to [CS:N]Azelf[CR]'s lake?)", french="(Est-ce que ces cristaux garderaient l'accès\nau lac de [CS:N]Créfadet[CR]?)", german="(Könnte es sein, dass von hier aus ein Weg\nzum See von [CS:N]Tobutz[CR] führt?)", italian="(Che sia qui il passaggio per il lago di [CS:N]Azelf[CR]?)", spanish="(¿Será este punto el que nos conduzca al lago\nde [CS:N]Azelf[CR]?)"})
  else
  SkySceneKit.say({english="(Could this place lead to [CS:N]Azelf[CR]'s lake?)", french="(Est-ce que ces cristaux garderaient l'accès\nau lac de [CS:N]Créfadet[CR]?)", german="(Könnte es sein, dass von hier aus ein Weg\nzum See von [CS:N]Tobutz[CR] führt?)", italian="(Che sia qui il passaggio per il lago di [CS:N]Azelf[CR]?)", spanish="(¿Será este punto el que nos conduzca al lago\nde [CS:N]Azelf[CR]?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It should be like those other two places.)", french="(Il n'y a pas de raison que ce soit différent\nici.)", german="(Es müsste so sein, wie an den anderen\nOrten.)", italian="(La situazione sembra essere la stessa delle\naltre volte.)", spanish="(Debe de ser como en esos otros dos sitios.)"})
  else
  SkySceneKit.say({english="(It should be like those other two places.)", french="(Il n'y a pas de raison que ce soit différent\nici.)", german="(Es müsste so sein, wie an den anderen\nOrten.)", italian="(La situazione sembra essere la stessa delle\naltre volte.)", spanish="(Debe de ser como en esos otros dos sitios.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(There should also be a secret here.)", french="(Il y a forcément un secret ici aussi.)", german="(Es müsste hier auch ein Geheimnis geben.)", italian="(Dovrebbe esserci un segreto anche qui.)", spanish="(Aquí también tiene que haber un secreto.)"})
  else
  SkySceneKit.say({english="(There should also be a secret here.)", french="(Il y a forcément un secret ici aussi.)", german="(Es müsste hier auch ein Geheimnis geben.)", italian="(Dovrebbe esserci un segreto anche qui.)", spanish="(Aquí también tiene que haber un secreto.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 300, 172, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  -- GAP: se_Play(7175) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A3_41) [routine d'objet NDS non simulée - documenté]
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A5_47) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(partner, 300, 188, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Whoa! This crystal changes\ncolor when you touch it!", french="Waouh! Le cristal change\nde couleur!", german="Boah! Der Kristall ändert seine\nFarbe, wenn man ihn berührt!", italian="Wow! Questo cristallo cambia\ncolore se lo tocchi!", spanish="¡Mira! Este cristal cambia de\ncolor cuando lo tocas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wow! This crystal changes color\nwhen you touch it!", french="Waouh! Le cristal change\nde couleur!", german="Wow! Der Kristall ändert seine\nFarbe, wenn man ihn berührt!", italian="Oh! Questo cristallo cambia\ncolore quando lo tocchi!", spanish="¡Vaya! Este cristal cambia de\ncolor cuando lo tocas."})
  else
  SkySceneKit.say({english="Oh, wow! This crystal changes\ncolor when you touch it!", french="Waouh! Le cristal change\nde couleur!", german="Oh, wow! Der Kristall ändert\nseine Farbe, wenn man ihn berührt!", italian="Oh! Questo cristallo cambia\ncolore quando lo tocchi!", spanish="¡Vaya! Este cristal cambia de\ncolor cuando lo tocas."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(180) end)
  GROUND:MoveToPosition(partner, 248, 244, false, 2)
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(hero, Direction.Left)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(7175) — id SE NDS sans portage PMDO identifié
  -- SetPositionMark OBJECT_D16P31A8_55 [cible sans placement SSA zone: placement non joué]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A4_43) [routine d'objet NDS non simulée - documenté]
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(4) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A7_52) [routine d'objet NDS non simulée - documenté]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This crystal changes color when\nyou touch it too.", french="Celui-ci change aussi de couleur\nquand on le touche.", german="Dieser Kristall ändert auch die\nFarbe, wenn man ihn anfasst.", italian="Ehi! Anche questo cristallo\ncambia colore quando viene toccato!", spanish=" ¡Y este de aquí también!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This crystal changes color when\nyou touch it too.", french="Celui-ci change aussi de couleur\nquand on le touche.", german="Dieser Kristall ändert auch die\nFarbe, wenn man ihn anfasst.", italian="Ehi! Anche questo cristallo\ncambia colore quando viene toccato!", spanish=" ¡Y este de aquí también!"})
  else
  SkySceneKit.say({english="This crystal changes color when\nyou touch it too.", french="Celui-ci change aussi de couleur\nquand on le touche.", german="Dieser Kristall ändert auch die\nFarbe, wenn man ihn anfasst.", italian="Ehi! Anche questo cristallo\ncambia colore quando viene toccato!", spanish=" ¡Y este de aquí también!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(10)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This might have something to do\nwith solving this place's secret.", french="C'est sûrement lié à la solution\nde ce mystère.", german="Vielleicht hat das etwas mit dem\nGeheimnis dieses Ortes zu tun.", italian="Sono sicuro che ha qualcosa a\nche fare con il segreto di questo posto.", spanish="Seguro que tiene algo que\nver con el secreto de este sitio."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This might have something to do\nwith solving this place's secret.", french="C'est sûrement lié à la solution\nde ce mystère.", german="Vielleicht hat das etwas mit dem\nGeheimnis dieses Ortes zu tun.", italian="Sono sicuro che ha qualcosa a\nche fare con il segreto di questo posto.", spanish="Seguro que tiene algo que\nver con el secreto de este sitio."})
  else
  SkySceneKit.say({english="This might be a clue to solving\nthis place's secret!", french="C'est sûrement lié à la solution\nde ce mystère.", german="Vielleicht ist das ein Hinweis auf\ndas Geheimnis, das dieser Ort verbirgt!", italian="Sono sicura che ha qualcosa a\nche fare con il segreto di questo posto.", spanish="Seguro que tiene algo que\nver con el secreto de este sitio."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You try touching them,\n[hero]!", french="Essaie par toi-même,\n[hero]! Touche les cristaux!", german="Berühre du sie mal,\n[hero]!", italian=" Prova tu, [hero]!", spanish="Intenta tocarlos tú,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Try touching them for yourself,\n[hero]!", french="Essaie par toi-même,\n[hero]! Touche les cristaux!", german="Berühre sie mal selbst,\n[hero]!", italian=" Prova tu, [hero]!", spanish="Intenta tocarlos tú,\n[hero]."})
  else
  SkySceneKit.say({english="See for yourself. Touch one of\nthese crystals, [hero].", french="Essaie par toi-même,\n[hero]! Touche les cristaux!", german="Versuch es selbst. Berühre\neinen Kristall, [hero].", italian=" Prova tu, [hero]!", spanish="Intenta tocarlos tú,\n[hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 352, 244, false, 2)
  GAME:WaitFrames(15)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Right)
  -- GAP: se_Play(7175) — id SE NDS sans portage PMDO identifié
  -- SetPositionMark OBJECT_D16P31A8_55 [cible sans placement SSA zone: placement non joué]
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A6_51) [routine d'objet NDS non simulée - documenté]
  -- supervision_RemoveActing(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(6) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A2_39) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(60)
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(7175) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(17) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A2_39) [routine d'objet NDS non simulée - documenté]
  -- supervision_RemoveActing(6) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(7) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D16P31A4_45) [routine d'objet NDS non simulée - documenté]
  -- message_FacePositionOffset(2, 1) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The color does change when I touch it.)", french="(C'est vrai, la couleur du cristal change quand\nje le touche.)", german="(Die Farbe ändert sich, wenn ich ihn berühre.)", italian="(È vero, il colore cambia quando lo tocco.)", spanish="(Cambia de color cuando lo toco.)"})
  else
  SkySceneKit.say({english="(The color does change when I touch it.)", french="(C'est vrai, la couleur du cristal change quand\nje le touche.)", german="(Die Farbe ändert sich, wenn ich ihn berühre.)", italian="(È vero, il colore cambia quando lo tocco.)", spanish="(Cambia de color cuando lo toco.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(And it can change into a variety of colors.)", french="(Et il peut prendre diverses couleurs.)", german="(Und er bekommt jedes Mal eine andere Farbe.)", italian="(Può diventare di diversi colori.)", spanish="(Y cambia a colores diferentes.)"})
  else
  SkySceneKit.say({english="(And it can change into a variety of colors.)", french="(Et il peut prendre diverses couleurs.)", german="(Und er bekommt jedes Mal eine andere Farbe.)", italian="(Può diventare di diversi colori.)", spanish="(Y cambia a colores diferentes.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- message_FacePositionOffset(2, 1) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Three crystals?)", french="(Trois cristaux?)", german="(Drei Kristalle?)", italian="(Tre cristalli...)", spanish="(¿Tres cristales?)"})
  else
  SkySceneKit.say({english="(Three crystals?)", french="(Trois cristaux?)", german="(Drei Kristalle?)", italian="(Tre cristalli...)", spanish="(¿Tres cristales?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 1) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Changing colors?)", french="(Qui changent de couleur?)", german="(Die ihre Farben ändern?)", italian="(Tre cristalli che cambiano colore...)", spanish="(¿Colores que cambian?)"})
  else
  SkySceneKit.say({english="(Changing colors?)", french="(Qui changent de couleur?)", german="(Die ihre Farben ändern?)", italian="(Tre cristalli che cambiano colore...)", spanish="(¿Colores que cambian?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What could this all mean?)", french="(Qu'est-ce que ça cache?)", german="(Was könnte das bedeuten?)", italian="(Cosa vorrà dire tutto questo?)", spanish="(¿Qué significado tendrá todo esto?)"})
  else
  SkySceneKit.say({english="(What could this all mean?)", french="(Qu'est-ce que ça cache?)", german="(Was könnte das bedeuten?)", italian="(Cosa vorrà dire tutto questo?)", spanish="(¿Qué significado tendrá todo esto?)"})
  end
  -- message_Close
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(2, 1) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Urk...)", french="(Argh...)", german="(Argh...)", italian="(Argh...)", spanish="(¡Huy!)"})
  else
  SkySceneKit.say({english="(Urk...)", french="(Argh...)", german="(Argh...)", italian="(Argh...)", spanish="(¡Huy!)"})
  end
  -- message_Close
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's starting...again...)", french="(Ça recommence...)", german="(Es fängt schon wieder an...)", italian="(Ricomincia...)", spanish="(Ya empieza... otra vez...)"})
  else
  SkySceneKit.say({english="(It's starting...again...)", french="(Ça recommence...)", german="(Es fängt schon wieder an...)", italian="(Ricomincia...)", spanish="(Ya empieza... otra vez...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(A Dimensional Scream...)", french="(Le Cri Dimensionnel...)", german="(Ein Dimensionaler Schrei...)", italian="(Ecco lo Squarcio Dimensionale...)", spanish="(La Percepción de Cronos.)"})
  else
  SkySceneKit.say({english="(A Dimensional Scream...)", french="(Le Cri Dimensionnel...)", german="(Ein Dimensionaler Schrei...)", italian="(Ecco lo Squarcio Dimensionale...)", spanish="(La Percepción de Cronos.)"})
  end
  -- message_Close
  GAME:FadeOut(false, 5)
end
