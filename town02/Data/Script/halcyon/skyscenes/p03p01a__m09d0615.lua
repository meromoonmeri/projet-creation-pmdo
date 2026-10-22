-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P03P01A/m09d0615.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_P03P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What did I just pick up on?)", french="(Qu'est-ce que je viens de voir?)", german="(Was habe ich da gerade wahrgenommen?)", italian="(Cosa sta succedendo?)", spanish="(¿Qué acabo de ver?)"})
  else
  SkySceneKit.say({english="(What did I just pick up on?)", french="(Qu'est-ce que je viens de voir?)", german="(Was habe ich da gerade wahrgenommen?)", italian="(Cosa sta succedendo?)", spanish="(¿Qué acabo de ver?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That was different from what I've\ngotten before.)", french="(C'était différent des autres visions.)", german="(Das war anders als die Visionen,\ndie ich bisher hatte.)", italian="(È stato diverso dalle altre visioni che ho\navuto.)", spanish="(No era como las visiones anteriores.)"})
  else
  SkySceneKit.say({english="(That was different from what I've\ngotten before.)", french="(C'était différent des autres visions.)", german="(Das war anders als die Visionen,\ndie ich bisher hatte.)", italian="(È stato diverso dalle altre visioni che ho\navuto.)", spanish="(No era como las visiones anteriores.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(This time, I only heard a voice...)", french="(Cette fois, j'ai simplement entendu\nune voix...)", german="(Diesmal habe ich nur eine Stimme gehört.)", italian="(Questa volta ho solo sentito una voce.)", spanish="(Esta vez, solo he podido oír una voz.)"})
  else
  SkySceneKit.say({english="(This time, I only heard a voice...)", french="(Cette fois, j'ai simplement entendu\nune voix...)", german="(Diesmal habe ich nur eine Stimme gehört.)", italian="(Questa volta ho solo sentito una voce.)", spanish="(Esta vez, solo he podido oír una voz.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(And I don't know whose voice that was.)", french="(Et j'ignore à qui elle appartient.)", german="(Und ich weiß nicht, wessen Stimme es war.)", italian="(E non so chi stesse parlando.)", spanish="(Y no sé a quién pertenecía.)"})
  else
  SkySceneKit.say({english="(And I don't know whose voice that was.)", french="(Et j'ignore à qui elle appartient.)", german="(Und ich weiß nicht, wessen Stimme es war.)", italian="(E non so chi stesse parlando.)", spanish="(Y no sé a quién pertenecía.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That voice...)", french="(Cette voix...)", german="(Diese Stimme...)", italian="(Quella voce...)", spanish="(Esa voz...)"})
  else
  SkySceneKit.say({english="(That voice...)", french="(Cette voix...)", german="(Diese Stimme...)", italian="(Quella voce...)", spanish="(Esa voz...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Whose voice was that?)", french="(L'ai-je déjà entendue?)", german="(Wessen Stimme war das?)", italian="(Di chi era quella voce?)", spanish="(¿De quién sería?)"})
  else
  SkySceneKit.say({english="(Whose voice was that?)", french="(L'ai-je déjà entendue?)", german="(Wessen Stimme war das?)", italian="(Di chi era quella voce?)", spanish="(¿De quién sería?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I didn't even get a sense of what the voice\nreally sounds like...)", french="(Je ne sais même plus à quoi ressemblait\ncette voix exactement...)", german="(Ich kann nicht einmal sagen, wie die Stimme\nwirklich klingt.)", italian="(Non ho neppure riconosciuto il suono di quella\nvoce...)", spanish="(Ni siquiera podría identificarla...)"})
  else
  SkySceneKit.say({english="(I didn't even get a sense of what the voice\nreally sounds like...)", french="(Je ne sais même plus à quoi ressemblait\ncette voix exactement...)", german="(Ich kann nicht einmal sagen, wie die Stimme\nwirklich klingt.)", italian="(Non ho neppure riconosciuto il suono di quella\nvoce...)", spanish="(Ni siquiera podría identificarla...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But it still bugs me for some reason...)", french="(Mais pour une raison inconnue, ça me\ntracasse...)", german="(Aber aus irgendeinem Grund lässt sie mich\nnicht los...)", italian="(Ma per qualche motivo mi ricorda\ncomunque qualcosa...)", spanish="(Pero por algún motivo, eso me irrita.)"})
  else
  SkySceneKit.say({english="(But it still bugs me for some reason...)", french="(Mais pour une raison inconnue, ça me\ntracasse...)", german="(Aber aus irgendeinem Grund lässt sie mich\nnicht los...)", italian="(Ma per qualche motivo mi ricorda\ncomunque qualcosa...)", spanish="(Pero por algún motivo, eso me irrita.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Are you all right, [hero]?", french=" Ça va, [hero]?", german=" Alles okay, [hero]?", italian=" Va tutto bene, [hero]?", spanish=" ¿Estás bien, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are you all right, [hero]?", french=" Ça va, [hero]?", german=" Alles okay, [hero]?", italian=" Va tutto bene, [hero]?", spanish=" ¿Estás bien, [hero]?"})
  else
  SkySceneKit.say({english=" Are you all right, [hero]?", french=" Ça va, [hero]?", german=" Alles okay, [hero]?", italian=" Va tutto bene, [hero]?", spanish=" ¿Estás bien, [hero]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Did you see something?", french=" Tu as vu quelque chose?", german=" Hast du etwas gesehen?", italian=" Hai visto qualcosa?", spanish=" ¿Has podido ver algo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Did you see something?", french=" Tu as vu quelque chose?", german=" Hast du etwas gesehen?", italian=" Hai visto qualcosa?", spanish=" ¿Has podido ver algo?"})
  else
  SkySceneKit.say({english=" Did you see something?", french=" Tu as vu quelque chose?", german=" Hast du etwas gesehen?", italian=" Hai visto qualcosa?", spanish=" ¿Has podido ver algo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What did that voice say?[K] Remember...)", french="(Qu'a dit cette voix?[K] Je dois me rappeler...)", german="(Was hat die Stimme gesagt?[K] Erinnere dich!)", italian="(Cosa ha detto quella voce?[K]\nDevo ricordarmelo...)", spanish="(¿Qué decía esa voz?[K] Recuerda...)"})
  else
  SkySceneKit.say({english="(What did that voice say?[K] Remember...)", french="(Qu'a dit cette voix?[K] Je dois me rappeler...)", german="(Was hat die Stimme gesagt?[K] Erinnere dich!)", italian="(Cosa ha detto quella voce?[K]\nDevo ricordarmelo...)", spanish="(¿Qué decía esa voz?[K] Recuerda...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That voice said...)", french="(La voix a dit...)", german="(Die Stimme hat gesagt...)", italian="(La voce ha detto...)", spanish="(Esa voz decía...)"})
  else
  SkySceneKit.say({english="(That voice said...)", french="(La voix a dit...)", german="(Die Stimme hat gesagt...)", italian="(La voce ha detto...)", spanish="(Esa voz decía...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It said, \"Place the Drought Stone in Groudon's\nheart,\" then said...)", french="(\"Place la Pierre-Sèche dans le\ncœur de Groudon\", puis elle a ajouté...)", german="(Sie hat gesagt, [F:S2]Setze den Melioriestein in\ndas Herz von Groudon[F:E2], und dann...)", italian="(... \"Metti la Pietra del Sole nel cuore di\nGroudon\", poi ha aggiunto...)", spanish="(Decía: \"Coloca la Piedra Sequía en el corazón\nde Groudon\"...)"})
  else
  SkySceneKit.say({english="(It said, \"Place the Drought Stone in Groudon's\nheart,\" then said...)", french="(\"Place la Pierre-Sèche dans le\ncœur de Groudon\", puis elle a ajouté...)", german="(Sie hat gesagt, [F:S2]Setze den Melioriestein in\ndas Herz von Groudon[F:E2], und dann...)", italian="(... \"Metti la Pietra del Sole nel cuore di\nGroudon\", poi ha aggiunto...)", spanish="(Decía: \"Coloca la Piedra Sequía en el corazón\nde Groudon\"...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(\\\"That lifts the fog!\\\")", french="(\\\"Le brouillard se lève!\\\")", german="([F:S2]Das löst den Nebel auf![F:E2])", italian="(\\\"Così la nebbia si alzerà!\\\")", spanish="(\\\"¡Eso disipará la niebla!\\\")"})
  else
  SkySceneKit.say({english="(\\\"That lifts the fog!\\\")", french="(\\\"Le brouillard se lève!\\\")", german="([F:S2]Das löst den Nebel auf![F:E2])", italian="(\\\"Così la nebbia si alzerà!\\\")", spanish="(\\\"¡Eso disipará la niebla!\\\")"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Wait a second![K] Drought Stone?!)", french="(La Pierre-Sèche?!)", german="(Moment mal![K] Melioriestein?!?)", italian="(Un attimo![K] La Pietra del Sole?!)", spanish="(¡Un segundo![K] ¡¿La Piedra Sequía?!)"})
  else
  SkySceneKit.say({english="(Wait a second![K] Drought Stone?!)", french="(La Pierre-Sèche?!)", german="(Moment mal![K] Melioriestein?!?)", italian="(Un attimo![K] La Pietra del Sole?!)", spanish="(¡Un segundo![K] ¡¿La Piedra Sequía?!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Is that maybe...)", french="(Peut-être que...)", german="(Ist das vielleicht...)", italian="(Che si tratti...)", spanish="(¿Tal vez se refiera...?)"})
  else
  SkySceneKit.say({english="(Is that maybe...)", french="(Peut-être que...)", german="(Ist das vielleicht...)", italian="(Che si tratti...)", spanish="(¿Tal vez se refiera...?)"})
  end
  -- message_Close
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
