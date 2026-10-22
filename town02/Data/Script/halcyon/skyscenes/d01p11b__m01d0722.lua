-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11B/m01d0722.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V01P03B) [décor sub chargé: Sub_v01p03b]
  -- back_SetGround(LEVEL_D01P11B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 33, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- screen2_FlushOut [sub déjà caché]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  SkySubScreen.Show("v01p03b", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So one day...[K]I happened to find\nsomething... My Relic Fragment.", french="Et un jour...[K] j'ai fait\nune découverte... mon Fragment de Relique.", german="Und eines Tages[K] fand ich dann\nzufällig dieses Reliktfragment.", italian="Un giorno...[K] ho trovato\nquesto... Il mio Frammento Antico.", spanish="No hace mucho...[K] encontré esta\nReliquia de Piedra."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So one day...[K]I happened to come\nacross my Relic Fragment.", french="Et un jour...[K] j'ai fait\nune découverte... mon Fragment de Relique.", german="Und eines Tages[K] gelangte ich\ndann zufällig an dieses Reliktfragment.", italian="Un giorno...[K] ho trovato\nquesto... Il mio Frammento Antico.", spanish="No hace mucho...[K] encontré esta\nReliquia de Piedra."})
  else
  SkySceneKit.say({english="And it just so happened...[K]that I\nfound this Relic Fragment.", french="Et un jour...[K] j'ai fait\nune découverte... mon Fragment de Relique.", german="Eines Tages passierte es dann...[K]\nIch fand dieses Reliktfragment.", italian="Un giorno...[K] ho trovato\nquesto... Il mio Frammento Antico.", spanish="No hace mucho...[K] encontré esta\nReliquia de Piedra."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Sure, it looks like junk, but take\na closer look...", french="C'est vrai, ça ressemble un peu\nà de la camelote, mais à y regarder de plus\nprès...", german="Klar, auf den ersten Blick ist es\nnur ein Brocken, aber wenn man genauer\nhinsieht...", italian="Sulle prime non sembra\nniente di speciale, ma dai un'occhiata più\nda vicino...", spanish="Ya sé que parece un pedrusco,\npero si miras más de cerca..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I admit that it looks like junk,\nbut take a closer look.", french="C'est vrai, ça ressemble un peu\nà de la camelote, mais à y regarder de plus\nprès...", german="Zugegeben, es sieht nicht so\nwertvoll aus. Aber sieh genauer hin.", italian="Sulle prime non sembra\nniente di speciale, ma dai un'occhiata più\nda vicino...", spanish="Ya sé que parece un pedrusco,\npero si miras más de cerca..."})
  else
  SkySceneKit.say({english="Sure, it does look like junk, but\ntake a closer look.", french="C'est vrai, ça ressemble un peu\nà de la camelote, mais à y regarder de plus\nprès...", german="Sicher, es sieht wie ein\nnutzloser Stein aus. Aber sieh genauer hin.", italian="Sulle prime non sembra\nniente di speciale, ma dai un'occhiata più\nda vicino...", spanish="Ya sé que parece un pedrusco,\npero si miras más de cerca..."})
  end
  -- message_Close
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(4), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-4), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetGround(V01P06B) [décor sub chargé: Sub_v01p06b]
  -- camera2_SetPositionMark(Position<'m1', 21, 15>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v01p06b", 15, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="See?[K] See that strange pattern\ninscribed on it?", french="Tu vois?[K] Tu vois ce motif\nétrange gravé dessus?", german="Siehst du?[K] Kannst du das Muster\nsehen?", italian="Vedi?[K] C'è uno strano disegno\ninciso sulla superficie.", spanish="¿Lo ves?[K] ¿Ves ese extraño\ndibujo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="See?[K] That inscription forms a\nstrange pattern, doesn't it?", french="Tu vois?[K] Tu vois ce motif\nétrange gravé dessus?", german="Siehst du?[K] Auf dem Stein ist ein\nmerkwürdiges Muster, nicht wahr?", italian="Vedi?[K] C'è uno strano disegno\ninciso sulla superficie.", spanish="¿Ves esto?[K] ¿Ves el extraño\ndibujo que tiene grabado?"})
  else
  SkySceneKit.say({english="Look there.[K] See that strange\npattern inscribed on it?", french="Tu vois?[K] Tu vois ce motif\nétrange gravé dessus?", german="Sieh mal.[K] Siehst du das\nmerkwürdige Muster auf dem Stein?", italian="Guarda qui.[K] C'è uno strano\ndisegno inciso sulla superficie.", spanish="¿Ves esto?[K] ¿Ves ese extraño\nsímbolo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's true. There is a strange inscription.)", french="(C'est vrai. Il y a un symbole un peu bizarre.)", german="(Stimmt. Da ist ein merkwürdiges Muster.)", italian="(È vero. C'è una strana incisione.)", spanish="(Es cierto. Tiene un extraño símbolo grabado.)"})
  else
  SkySceneKit.say({english="(It's true. There is a strange inscription.)", french="(C'est vrai. Il y a un symbole un peu bizarre.)", german="(Stimmt. Da ist ein merkwürdiges Muster.)", italian="(È vero. C'è una strana incisione.)", spanish="(Es cierto. Tiene un extraño símbolo grabado.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I've never seen a pattern like this.)", french="(Je n'avais encore jamais vu de motif de\nce genre.)", german="(So ein Muster habe ich noch nie gesehen.)", italian="(Non ho mai visto un disegno del genere.)", spanish="(Nunca había visto nada así.)"})
  else
  SkySceneKit.say({english="(I've never seen a pattern like this.)", french="(Je n'avais encore jamais vu de motif de\nce genre.)", german="(So ein Muster habe ich noch nie gesehen.)", italian="(Non ho mai visto un disegno del genere.)", spanish="(Nunca había visto nada así.)"})
  end
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Show("v01p06b", 0, false) -- screen2_FlushIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
