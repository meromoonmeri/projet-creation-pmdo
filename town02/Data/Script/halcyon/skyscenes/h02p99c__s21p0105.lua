-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99C/s21p0105.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_H02P99C) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:EntTurn(partner, Direction.Left)
  -- SetAnimation(76) [anim idle native]
  -- SetAnimation(76) [anim idle native]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner] was unusually upbeat then!)", french="(C'est vrai que ce matin-là, [partner] était\nbeaucoup plus enthousiaste que d'habitude!)", german="([partner] war ungewöhnlich gut drauf\ndamals!)", italian="([partner] era insolitamente ottimista!)", spanish="([partner] estaba demasiado alegre ese\ndía.)"})
  else
  SkySceneKit.say({english="([partner] was unusually upbeat then!)", french="(C'est vrai que ce matin-là, [partner] était\nbeaucoup plus enthousiaste que d'habitude!)", german="([partner] war ungewöhnlich gut drauf\ndamals!)", italian="([partner] era insolitamente ottimista!)", spanish="([partner] estaba demasiado alegre ese\ndía.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But [partner] had just woke from the\nsame dream about [CS:N]Cresselia[CR] that I had!)", french="(Nous avons pourtant dû faire le même\nrêve sur [CS:N]Cresselia[CR]!)", german="(Aber [partner] war gerade vom gleichen\nTraum über [CS:N]Cresselia[CR] aufgewacht,\nden ich auch hatte!)", italian="(Ma [partner] aveva appena sognato\n[CS:N]Cresselia[CR], proprio come me!)", spanish="(¡Y eso que acababa de tener el mismo sueño\ncon [CS:N]Cresselia[CR] que yo!)"})
  else
  SkySceneKit.say({english="(But [partner] had just woke from the\nsame dream about [CS:N]Cresselia[CR] that I had!)", french="(Nous avons pourtant dû faire le même\nrêve sur [CS:N]Cresselia[CR]!)", german="(Aber [partner] war gerade vom gleichen\nTraum über [CS:N]Cresselia[CR] aufgewacht,\nden ich auch hatte!)", italian="(Ma [partner] aveva appena sognato\n[CS:N]Cresselia[CR], proprio come me!)", spanish="(¡Y eso que acababa de tener el mismo sueño\ncon [CS:N]Cresselia[CR] que yo!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(At that moment, [partner] must have been\nacting extra cheerful around me...)", french="([partner] devait sûrement faire semblant\nde se réjouir devant moi...)", german="(In dem Moment muss sich [partner]\nabsichtlich fröhlich um mich herum verhalten\nhaben...)", italian="(In quel momento, probabilmente [partner]\nha cercato di essere più ottimista...)", spanish="(En aquel momento, [partner] quería\naparentar que estaba alegre...)"})
  else
  SkySceneKit.say({english="(At that moment, [partner] must have been\nacting extra cheerful around me...)", french="([partner] devait sûrement faire semblant\nde se réjouir devant moi...)", german="(In dem Moment muss sich [partner]\nabsichtlich fröhlich um mich herum verhalten\nhaben...)", italian="(In quel momento, probabilmente [partner]\nha cercato di essere più ottimista...)", spanish="(En aquel momento, [partner] quería\naparentar que estaba alegre...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Because [partner] suspected that I had\njust had the same dream...)", french="(En pensant que j'avais eu\nle même rêve...)", german="(Weil [partner] vermutete, dass ich genau\nden gleichen Traum gehabt hatte.)", italian="(... perché sospettava che io avessi fatto\nlo stesso sogno...)", spanish="(Porque, en el fondo, sospechaba que yo\ntambién había soñado lo mismo...)"})
  else
  SkySceneKit.say({english="(Because [partner] suspected that I had\njust had the same dream...)", french="(En pensant que j'avais eu\nle même rêve...)", german="(Weil [partner] vermutete, dass ich genau\nden gleichen Traum gehabt hatte.)", italian="(... perché sospettava che io avessi fatto\nlo stesso sogno...)", spanish="(Porque, en el fondo, sospechaba que yo\ntambién había soñado lo mismo...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...and tried to cheer me up.)", french="(... [partner] essayait de me réconforter.)", german="(Und mich daher aufheitern wollte.)", italian="(Voleva mettermi allegria.)", spanish="(Y quería intentar animarme.)"})
  else
  SkySceneKit.say({english="(...and tried to cheer me up.)", french="(... [partner] essayait de me réconforter.)", german="(Und mich daher aufheitern wollte.)", italian="(Voleva mettermi allegria.)", spanish="(Y quería intentar animarme.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner] had to have been frightened.)", french="([partner] a dû avoir très peur.)", german="([partner] muss auch Angst gehabt haben.)", italian="(Sicuramente [partner] aveva\nmolta paura.)", spanish="([partner] debió asustarse mucho.)"})
  else
  SkySceneKit.say({english="([partner] had to have been frightened.)", french="([partner] a dû avoir très peur.)", german="([partner] muss auch Angst gehabt haben.)", italian="(Sicuramente [partner] aveva\nmolta paura.)", spanish="([partner] debió asustarse mucho.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But [partner] was much more concerned\nabout me.)", french="(Mais mon bien-être lui importait plus que\nle sien.)", german="(Aber [partner] war viel besorgter um\nmich.)", italian="(Ma [partner] si preoccupava\ndi più per me.)", spanish="(Y, sin embargo, se preocupó más por mis\nsentimientos que por los suyos.)"})
  else
  SkySceneKit.say({english="(But [partner] was much more concerned\nabout me.)", french="(Mais mon bien-être lui importait plus que\nle sien.)", german="(Aber [partner] war viel besorgter um\nmich.)", italian="(Ma [partner] si preoccupava\ndi più per me.)", spanish="(Y, sin embargo, se preocupó más por mis\nsentimientos que por los suyos.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(............)", french="(............)", german="(............)", italian="(............)", spanish="(...)"})
  else
  SkySceneKit.say({english="(............)", french="(............)", german="(............)", italian="(............)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(... ...)"})
  else
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(... ...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Then in [CS:N]Azurill[CR]'s nightmare...[K] What [CS:N]Cresselia[CR]\nsaid, and what she tried to do...)", french="(Alors dans le cauchemar d'[CS:N]Azurill[CR]...[K] ce que\n[CS:N]Cresselia[CR] a dit, et ce qu'elle a essayé\nde faire...)", german="(Und dann in dem Albtraum von [CS:N]Azurill[CR]...[K] Was\n[CS:N]Cresselia[CR] sagte und was sie\nzu tun versuchte...)", italian="(Poi, dentro l'incubo di [CS:N]Azurill[CR]...[K] Quello che\n[CS:N]Cresselia[CR] ha detto e quello che ha provato\na fare...)", spanish="(Después, en la pesadilla de [CS:N]Azurill[CR]...[K] lo que\n[CS:N]Cresselia[CR] dijo y lo que intentó hacer...)"})
  else
  SkySceneKit.say({english="(Then in [CS:N]Azurill[CR]'s nightmare...[K] What [CS:N]Cresselia[CR]\nsaid, and what she tried to do...)", french="(Alors dans le cauchemar d'[CS:N]Azurill[CR]...[K] ce que\n[CS:N]Cresselia[CR] a dit, et ce qu'elle a essayé\nde faire...)", german="(Und dann in dem Albtraum von [CS:N]Azurill[CR]...[K] Was\n[CS:N]Cresselia[CR] sagte und was sie\nzu tun versuchte...)", italian="(Poi, dentro l'incubo di [CS:N]Azurill[CR]...[K] Quello che\n[CS:N]Cresselia[CR] ha detto e quello che ha provato\na fare...)", spanish="(Después, en la pesadilla de [CS:N]Azurill[CR]...[K] lo que\n[CS:N]Cresselia[CR] dijo y lo que intentó hacer...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I felt crushed by that, but...)", french="(C'était vraiment éprouvant, mais...)", german="(Das hat mich niedergeschmettert...)", italian="(Beh, mi ha fatto stare male, ma...)", spanish="(Me sentí devastado...)"})
  else
  SkySceneKit.say({english="(I felt crushed by that, but...)", french="(C'était vraiment éprouvant, mais...)", german="(Das hat mich niedergeschmettert...)", italian="(Beh, mi ha fatto stare male, ma...)", spanish="(Me sentí devastada...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But...[K] But...)", french="(Mais...[K] mais...)", german="(Aber...[K] Aber...)", italian="(Ma...[K] Ma...)", spanish="(Uf...[K] Pero...)"})
  else
  SkySceneKit.say({english="(But...[K] But...)", french="(Mais...[K] mais...)", german="(Aber...[K] Aber...)", italian="(Ma...[K] Ma...)", spanish="(Uf...[K] Pero...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That's why...)", french="(C'est la raison pour laquelle...)", german="(Genau deshalb!)", italian="(È per questo che...)", spanish="(Pero, precisamente por eso...)"})
  else
  SkySceneKit.say({english="(That's why...)", french="(C'est la raison pour laquelle...)", german="(Genau deshalb!)", italian="(È per questo che...)", spanish="(Pero, precisamente por eso...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I have to keep my spirits strong!)", french="(Je dois garder le moral!)", german="(Genau deshalb darf ich den Mut nicht\nverlieren!)", italian="(Sì, devo essere forte!)", spanish="(¡Tengo que ser fuerte!)"})
  else
  SkySceneKit.say({english="(I have to keep my spirits strong!)", french="(Je dois garder le moral!)", german="(Genau deshalb darf ich den Mut nicht\nverlieren!)", italian="(Sì, devo essere forte!)", spanish="(¡Tengo que ser fuerte!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(My spirits...[K]strong...)", french="(Garder...[K] le moral...)", german="(Meinen Mut...[K] nicht verlieren...)", italian="(Essere...[K] forte...)", spanish="(Levantar...[K] el ánimo...)"})
  else
  SkySceneKit.say({english="(My spirits...[K]strong...)", french="(Garder...[K] le moral...)", german="(Meinen Mut...[K] nicht verlieren...)", italian="(Essere...[K] forte...)", spanish="(Levantar...[K] el ánimo...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...spirits...)", french="(... le moral...)", german="(...Mut...)", italian="(Essere...)", spanish="(El ánimo...)"})
  else
  SkySceneKit.say({english="(...spirits...)", french="(... le moral...)", german="(...Mut...)", italian="(Essere...)", spanish="(El ánimo...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(... ...)"})
  else
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(... ...)"})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(210) end)
  -- SetAnimation(62) [anim idle native]
  GAME:WaitFrames(120)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(30)
end
