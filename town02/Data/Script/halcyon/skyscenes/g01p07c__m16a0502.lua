-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m16a0502.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[24] = 2 -- dungeon_mode(24) = DMODE_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[25] = 2 -- dungeon_mode(25) = DMODE_REQUEST (ROM)
  SkyProg.set(17, 4) -- $SCENARIO_MAIN = scn[17,4] (ROM)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P06A) [décor sub chargé: Sub_v02p06a]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v02p06a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(150)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  -- SetAnimation(76) [anim idle native]
  -- SetAnimation(76) [anim idle native]
  GAME:FadeIn(60) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  else
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ..............................", french=" ..............................", german=" ..............................", italian=" ..............................", spanish=" ... ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ..............................", french=" ..............................", german=" ..............................", italian=" ..............................", spanish=" ... ..."})
  else
  SkySceneKit.say({english=" ..............................", french=" ..............................", german=" ..............................", italian=" ..............................", spanish=" ... ..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [hero]...", french=" Dis, [hero]...", german=" Hey, [hero]...", italian=" Senti, [hero]...", spanish=" Oye, [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Listen, [hero]...", french=" Dis, [hero]...", german=" Hör mal, [hero]...", italian=" Ascolta, [hero]...", spanish=" [hero]..."})
  else
  SkySceneKit.say({english=" Say, [hero]...", french=" Dis, [hero]...", german=" Du, [hero]...", italian=" Ascolta, [hero]...", spanish=" Oye, [hero]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I wonder how [CS:N]Azelf[CR] and his\nfriends are doing?", french="Je me demande où en sont\n[CS:N]Créfadet[CR] et ses amis.", german="Wie es wohl [CS:N]Tobutz[CR]\nund seinen Freunden geht?", italian="Secondo te, cosa stanno\nfacendo [CS:N]Azelf[CR] e i suoi amici?", spanish="Me pregunto qué tal estarán\n[CS:N]Azelf[CR] y sus amigos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I wonder how [CS:N]Azelf[CR] and his\nfriends are doing?", french="Je me demande où en sont\n[CS:N]Créfadet[CR] et ses amis.", german="Wie es wohl [CS:N]Tobutz[CR]\nund seinen Freunden geht?", italian="Secondo te, cosa stanno\nfacendo [CS:N]Azelf[CR] e i suoi amici?", spanish="Me pregunto qué tal estarán\n[CS:N]Azelf[CR] y sus amigos."})
  else
  SkySceneKit.say({english="I wonder how [CS:N]Azelf[CR] and his\nfriends are doing?", french="Je me demande où en sont\n[CS:N]Créfadet[CR] et ses amis.", german="Wie es wohl [CS:N]Tobutz[CR]\nund seinen Freunden geht?", italian="Secondo te, cosa stanno\nfacendo [CS:N]Azelf[CR] e i suoi amici?", spanish="Me pregunto qué tal estarán\n[CS:N]Azelf[CR] y sus amigos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Do you think maybe they're\nfighting [CS:N]Grovyle[CR]?", french="Tu crois qu'ils sont en train\nde se battre contre [CS:N]Massko[CR]?", german="Glaubst du, dass sie gerade\ngegen [CS:N]Reptain[CR] kämpfen?", italian="Pensi che stiano lottando contro\n[CS:N]Grovyle[CR]?", spanish="¿Crees que ahora estarán\nluchando contra [CS:N]Grovyle[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Do you think that they may be\nfighting [CS:N]Grovyle[CR] now?", french="Tu crois qu'ils sont en train\nde se battre contre [CS:N]Massko[CR]?", german="Glaubst du, dass sie gerade\ngegen [CS:N]Reptain[CR] kämpfen?", italian="Pensi che stiano lottando contro\n[CS:N]Grovyle[CR]?", spanish="¿Crees que ahora estarán\nluchando contra [CS:N]Grovyle[CR]?"})
  else
  SkySceneKit.say({english="Do you think maybe they're\nfighting [CS:N]Grovyle[CR]?", french="Tu crois qu'ils sont en train\nde se battre contre [CS:N]Massko[CR]?", german="Glaubst du, dass sie gerade\ngegen [CS:N]Reptain[CR] kämpfen?", italian="Pensi che stiano lottando contro\n[CS:N]Grovyle[CR]?", spanish="¿Crees que ahora estarán\nluchando contra [CS:N]Grovyle[CR]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Oh, I just can't sleep when I\nthink about that.", french="Quand j'y pense, je n'arrive plus\nà trouver le sommeil.", german="Oh, ich kann nicht schlafen,\nwenn ich daran denke!", italian="Se ci penso, non riesco proprio a\ndormire.", spanish="Cuando me pongo a pensar en eso\nse me quita el sueño."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh, I just can't sleep with that\non my mind!", french="Quand j'y pense, je n'arrive plus\nà trouver le sommeil.", german="Oh, bei dem Gedanken kann ich\ngar nicht schlafen!", italian="Se ci penso, non riesco proprio a\ndormire.", spanish="Cuando me pongo a pensar en eso\nse me quita el sueño."})
  else
  SkySceneKit.say({english="Oh! I just can't sleep when I\nthink about that.", french="Quand j'y pense, je n'arrive plus\nà trouver le sommeil.", german="Oh, ich kann nicht schlafen,\nwenn ich daran denke!", italian="Se ci penso, non riesco proprio a\ndormire.", spanish="Cuando me pongo a pensar en eso\nse me quita el sueño."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But you know, when you think\nabout it, this is all so strange.", french="Et toute cette histoire est\nsi étrange, après tout.", german="Aber weißt du, wenn ich\ndarüber nachdenke, kommt mir alles so\nseltsam vor.", italian="Beh, certo che tutta questa\nstoria è proprio strana.", spanish="Pero es que si reflexionas\nun poco, ¡todo resulta tan extraño!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But if you stop to think, this is\nall so strange.", french="Et toute cette histoire est\nsi étrange, après tout.", german="Aber wenn man mal darüber\nnachdenkt, kommt einem alles so seltsam vor.", italian="Ma in effetti, riflettendoci, tutta\nquesta storia è così strana...", spanish="Pero es que si reflexionas\nun poco, ¡todo resulta tan extraño!"})
  else
  SkySceneKit.say({english="But if you stop to think, this is\nall so very strange.", french="Et toute cette histoire est\nsi étrange, après tout.", german="Aber wenn man mal darüber\nnachdenkt, kommt einem alles so seltsam vor.", italian="Ma in effetti, riflettendoci, tutta\nquesta storia è così strana...", spanish="Pero es que si reflexionas\nun poco, ¡todo resulta tan extraño!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I mean, Pokémon from the\nfuture?", french=" Des Pokémon venus du futur?", german="Ich meine, Pokémon aus der\nZukunft?", italian="Voglio dire... Pokémon che\nvengono dal futuro?", spanish=" ¿Pokémon del futuro?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I mean, Pokémon coming here\nfrom the future?", french=" Des Pokémon venus du futur?", german="Ich meine, Pokémon aus der\nZukunft?", italian="Pokémon che vengono dal\nfuturo? Incredibile!", spanish=" ¿Pokémon del futuro?"})
  else
  SkySceneKit.say({english="I mean, Pokémon from the\nfuture?", french=" Des Pokémon venus du futur?", german="Ich meine, Pokémon aus der\nZukunft?", italian="Pokémon che vengono dal\nfuturo? Incredibile!", spanish=" ¿Pokémon del futuro?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Like that's really possible...?", french=" Ça paraît tellement improbable...", german=" Ob das wirklich möglich ist?", italian=" Come può essere...?", spanish="¿Tú crees que algo así es\nrealmente posible?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Something like that is really\npossible...?", french=" Ça paraît tellement improbable...", german=" Ob so was wirklich möglich ist?", italian=" Come può essere...?", spanish="¿Tú crees que algo así es\nrealmente posible?"})
  else
  SkySceneKit.say({english="Something that extraordinary is\nreally possible...?", french=" Ça paraît tellement improbable...", german="Ob so was Unglaubliches wirklich\nmöglich ist?", italian=" Come può essere...?", spanish="¿Tú crees que algo así es\nrealmente posible?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That's true!)", french="(Ça, c'est bien vrai!)", german="(Stimmt!)", italian="(Ha ragione!)", spanish="(Tiene razón.)"})
  else
  SkySceneKit.say({english="(That's true!)", french="(Ça, c'est bien vrai!)", german="(Stimmt!)", italian="(Ha ragione!)", spanish="(Tiene razón.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's hard to accept that Pokémon could come\nfrom the future!)", french="(J'ai du mal à croire que des Pokémon\npuissent voyager dans le temps!)", german="(Es ist schwer, zu akzeptieren, dass ein\nPokémon aus der Zukunft kommen könnte!)", italian="(È difficile accettare l'idea che i Pokémon\npossano viaggiare nel tempo!)", spanish="(Cuesta creer que un Pokémon pueda venir\ndel futuro.)"})
  else
  SkySceneKit.say({english="(It's hard to accept that Pokémon could come\nfrom the future!)", french="(J'ai du mal à croire que des Pokémon\npuissent voyager dans le temps!)", german="(Es ist schwer, zu akzeptieren, dass ein\nPokémon aus der Zukunft kommen könnte!)", italian="(È difficile accettare l'idea che i Pokémon\npossano viaggiare nel tempo!)", spanish="(Cuesta creer que un Pokémon pueda venir\ndel futuro.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Come to think of it...)", french="(Réflexion faite...)", german="(Da fällt mir ein...)", italian="(Ora...)", spanish="(Ahora que lo pienso...)"})
  else
  SkySceneKit.say({english="(Come to think of it...)", french="(Réflexion faite...)", german="(Da fällt mir ein...)", italian="(Ora...)", spanish="(Ahora que lo pienso...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(This never crossed my mind before...)", french="(... ça ne m'avait jamais traversé l'esprit...)", german="(Daran habe ich noch gar nicht gedacht...)", italian="(Che strano... Non ci avevo mai pensato...)", spanish="(Hay una cosa que no me había cuestionado\nhasta ahora...)"})
  else
  SkySceneKit.say({english="(This never crossed my mind before...)", french="(... ça ne m'avait jamais traversé l'esprit...)", german="(Daran habe ich noch gar nicht gedacht...)", italian="(Che strano... Non ci avevo mai pensato...)", spanish="(Hay una cosa que no me había cuestionado\nhasta ahora...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The world of the future where [CS:N]Dusknoir[CR] and\n[CS:N]Grovyle[CR] came from...)", french="(Le futur d'où [CS:N]Noctunoir[CR] et\n[CS:N]Massko[CR] sont venus...)", german="(Die zukünftige Welt, aus der [CS:N]Zwirrfinst[CR] und\n[CS:N]Reptain[CR] kommen...)", italian="(Il mondo del futuro... quello da cui\nprovengono [CS:N]Dusknoir[CR] e [CS:N]Grovyle[CR]...)", spanish="(El mundo del futuro del que vienen [CS:N]Dusknoir[CR] y\n[CS:N]Grovyle[CR]...)"})
  else
  SkySceneKit.say({english="(The world of the future where [CS:N]Dusknoir[CR] and\n[CS:N]Grovyle[CR] came from...)", french="(Le futur d'où [CS:N]Noctunoir[CR] et\n[CS:N]Massko[CR] sont venus...)", german="(Die zukünftige Welt, aus der [CS:N]Zwirrfinst[CR] und\n[CS:N]Reptain[CR] kommen...)", italian="(Il mondo del futuro... quello da cui\nprovengono [CS:N]Dusknoir[CR] e [CS:N]Grovyle[CR]...)", spanish="(El mundo del futuro del que vienen [CS:N]Dusknoir[CR] y\n[CS:N]Grovyle[CR]...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What is it like?)", french="(A quoi peut-il bien ressembler?)", german="(Wie sie wohl ist?)", italian="(Chissà com'è...)", spanish="(¿Cómo será?)"})
  else
  SkySceneKit.say({english="(What is it like?)", french="(A quoi peut-il bien ressembler?)", german="(Wie sie wohl ist?)", italian="(Chissà com'è...)", spanish="(¿Cómo será?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Is the future like the present day...?)", french="(Le futur est-il similaire au présent...?)", german="(Ist die Zukunft wie die Gegenwart?)", italian="(Chissà se è come il presente...)", spanish="(¿Es el futuro igual que el presente?)"})
  else
  SkySceneKit.say({english="(Is the future like the present day...?)", french="(Le futur est-il similaire au présent...?)", german="(Ist die Zukunft wie die Gegenwart?)", italian="(Chissà se è come il presente...)", spanish="(¿Es el futuro igual que el presente?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Is it a world at peace?)", french="(Le monde y est-il en paix?)", german="(Ist es eine friedliche Welt?)", italian="(Chissà se c'è la pace nel futuro...)", spanish="(¿Será un mundo en paz?)"})
  else
  SkySceneKit.say({english="(Is it a world at peace?)", french="(Le monde y est-il en paix?)", german="(Ist es eine friedliche Welt?)", italian="(Chissà se c'è la pace nel futuro...)", spanish="(¿Será un mundo en paz?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oooooh...", french=" Oooooh...", german=" Uuuuuh...", italian=" Oooooh...", spanish=" Oooh..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oooooh...", french=" Oooooh...", german=" Uuuuuh...", italian=" Oooooh...", spanish=" Oooh..."})
  else
  SkySceneKit.say({english=" Oooooh...", french=" Oooooh...", german=" Uuuuuh...", italian=" Oooooh...", spanish=" Oooh..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's another early day tomorrow.\nI've gotta force myself to sleep.", french="On doit encore se lever tôt\ndemain. Il faut que je me force à dormir.", german="Morgen müssen wir wieder früh\nraus. Ich muss mich zwingen, einzuschlafen.", italian="Domani bisogna svegliarsi\npresto, come al solito. Devo proprio\ncercare di dormire un po'.", spanish="Mañana habrá que madrugar.\nNecesito descansar un poco."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's another early day tomorrow.\nI'd better force myself to sleep.", french="On doit encore se lever tôt\ndemain. Il faut que je me force à dormir.", german="Morgen müssen wir wieder früh\nraus. Ich muss mich zwingen, einzuschlafen.", italian="Domani bisogna svegliarsi\npresto, come al solito. Devo proprio\ncercare di dormire un po'.", spanish="Mañana habrá que madrugar.\nNecesito descansar un poco."})
  else
  SkySceneKit.say({english="It's another early day tomorrow.\nI'd better force myself to sleep.", french="On doit encore se lever tôt\ndemain. Il faut que je me force à dormir.", german="Morgen müssen wir wieder früh\nraus. Ich muss mich zwingen, einzuschlafen.", italian="Domani bisogna svegliarsi\npresto, come al solito. Devo proprio\ncercare di dormire un po'.", spanish="Mañana habrá que madrugar.\nNecesito descansar un poco."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'm going to sleep, [hero].\nGood night!", french="Je vais dormir, [hero].\nFais de beaux rêves!", german="Ich schlafe jetzt, [hero].\nGute Nacht!", italian="Mi sto per addormentare,\n[hero]. Buonanotte!", spanish="Yo voy a tratar de dormir,\n[hero]. ¡Buenas noches!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm going to sleep, [hero].\nGood night!", french="Je vais dormir, [hero].\nFais de beaux rêves!", german="Ich schlafe jetzt, [hero].\nGute Nacht!", italian="Mi sto per addormentare,\n[hero]. Buonanotte!", spanish="Yo voy a tratar de dormir,\n[hero]. ¡Buenas noches!"})
  else
  SkySceneKit.say({english="I'm going to sleep, [hero].\nSweet dreams!", french="Je vais dormir, [hero].\nFais de beaux rêves!", german="Ich schlafe jetzt, [hero].\nGute Nacht!", italian="Mi sto per addormentare,\n[hero]. Buonanotte!", spanish="Yo voy a tratar de dormir,\n[hero]. ¡Dulces sueños!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Tomorrow...[K]let's do our best...", french="Demain...[K] on fera de notre\nmieux...", german="Morgen...[K] Morgen geben wir\nunser Bestes...", italian="Domani...[K] dobbiamo darci\ndentro...", spanish="Mañana...[K] haremos todo lo que\npodamos..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Tomorrow...[K]let's do our best...", french="Demain...[K] on fera de notre\nmieux...", german="Morgen...[K] Morgen geben wir\nunser Bestes...", italian="Domani...[K] dobbiamo dare il\nmassimo...", spanish="Mañana...[K] haremos todo lo que\npodamos..."})
  else
  SkySceneKit.say({english=" Tomorrow...[K]let's do our best...", french="Demain...[K] on fera de notre\nmieux...", german="Morgen...[K] Morgen geben wir\nunser Bestes...", italian="Domani...[K] dobbiamo dare il\nmassimo...", spanish="Mañana...[K] haremos todo lo que\npodamos..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Good night...", french=" Bonne nuit...", german=" Gute Nacht...", italian=" Buonanotte...", spanish=" ¡Buenas noches!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Good night...", french=" Bonne nuit...", german=" Gute Nacht...", italian=" Buonanotte...", spanish=" ¡Buenas noches!"})
  else
  SkySceneKit.say({english=" Good night...", french=" Bonne nuit...", german=" Gute Nacht...", italian=" Buonanotte...", spanish=" ¡Buenas noches!"})
  end
  -- message_Close
  GAME:WaitFrames(30)
  -- SetAnimation(62) [anim idle native]
  -- SetAnimation(62) [anim idle native]
  GAME:WaitFrames(60)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(30)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
