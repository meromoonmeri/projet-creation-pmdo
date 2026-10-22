-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11B/m26a0610.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM BGM_MEMORIES_RETURNED non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
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
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Would you join me to make an\nexploration team?", french="Veux-tu former une équipe\nd'exploration avec moi?", german="Würdest du mit mir ein\nErkundungsteam gründen?", italian="Vuoi formare una squadra\nd'esplorazione insieme a me?", spanish="¿Qué te parece si formamos\njuntos un equipo explorador?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Would you be willing to form an\nexploration team with me?", french="Veux-tu former une équipe\nd'exploration avec moi?", german="Könntest du dir vorstellen, mit\nmir ein Erkundungsteam zu gründen?", italian="Vuoi formare una squadra\nd'esplorazione insieme a me?", spanish="¿Te interesaría formar\nun equipo explorador conmigo?"})
  else
  SkySceneKit.say({english="Would you form an exploration\nteam with me?", french="Veux-tu former une équipe\nd'exploration avec moi?", german="Würdest du mit mir ein\nErkundungsteam gründen?", italian="Vuoi formare una squadra\nd'esplorazione insieme a me?", spanish="¿Quieres formar un equipo\nexplorador conmigo?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I think you and I would make a\ngood exploration team, [hero].", french="Je pense que, toi et moi, nous\nformerions une bonne équipe d'exploration,\n[hero].", german="Ich glaube, du und ich würden\nein gutes Erkundungsteam abgeben,\n[hero].", italian="Io e te saremmo un'ottima\nsquadra d'esplorazione, [hero].", spanish="Creo que los dos haríamos un\nequipo estupendo, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm convinced that I can form an\neffective exploration team with you,\n[hero].", french="Je pense que, toi et moi, nous\nformerions une bonne équipe d'exploration,\n[hero].", german="Ich bin mir sicher, dass wir ein\ngutes Erkundungsteam bilden können,\n[hero].", italian="Io e te saremmo un'ottima\nsquadra d'esplorazione, [hero].", spanish="Estoy convencido de que juntos\nharíamos un equipo estupendo, [hero]."})
  else
  SkySceneKit.say({english="I think we could make a good\nexploration team together, [hero].", french="Je pense que, toi et moi, nous\nformerions une bonne équipe d'exploration,\n[hero].", german="Ich glaube, wir beide wären ein\ngutes Erkundungsteam, [hero].", italian="Io e te saremmo un'ottima\nsquadra d'esplorazione, [hero].", spanish="Creo que formaríamos\nun equipo estupendo, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So, how about it?[K]\nCome on, please?", french="Alors, tu en penses quoi?[K]\nAllez, s'il te plaît?", german="Also, wie wäre es?[K]\nKomm schon, bitte!", italian="Allora, cosa ne dici?[K]\nDai, di' di sì!", spanish="Así que... ¿qué me dices?[K]\n¿Te apuntas?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So will you?[K] Please?", french="Alors, tu en penses quoi?[K]\nAllez, s'il te plaît?", german=" Was sagst du?[K] Bitte!", italian="Allora, cosa ne dici?[K]\nDai, di' di sì!", spanish="Así que... ¿qué me dices?[K]\n¿Lo hacemos?"})
  else
  SkySceneKit.say({english="So will you do that with me?[K]\nPlease?", french="Alors, tu en penses quoi?[K]\nAllez, s'il te plaît?", german=" Also, hast du Lust?[K] Bitte!", italian="Allora, cosa ne dici?[K]\nDai, di' di sì!", spanish="Así que... ¿qué me dices?[K]\n¿Te animas?"})
  end
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  SkySubScreen.Show("v01p03b", 0, false) -- screen2_FlushIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
