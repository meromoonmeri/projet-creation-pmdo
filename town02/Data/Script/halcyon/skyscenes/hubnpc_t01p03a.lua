-- GÉNÉRÉ par dev/tools/sky_compile_hub_npcs.py — NE PAS ÉDITER À LA MAIN.
-- NPC résidents canoniques du hub t01p03a (enter.sse ROM Sky EU: placements SSA exacts,
-- dialogues enterNN.ssb 5 langues; talk=nil = script ROM sans dialogue compilable, tracé).
local SkySceneKit = require 'halcyon.skyscenes.kit'
local function talk_npc_garagara(hero, partner)
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="Welcome to [CS:K]Marowak[CR] Dojo.[K]\nTrain yourselves to become better explorers!", french="Bienvenue au [CS:K]Dojo Ossatueur[CR].[K]\nEntraînez-vous pour faire partie des meilleurs\nexplorateurs!", german="Willkommen im [CS:K]Knogga-Dojo[CR].[K]\nArbeitet an euch, damit ihr bessere Erkunder\nwerdet!", italian="Vi do il benvenuto al Dojo\n[CS:K]Marowak[CR].[K] Il luogo adatto per diventare\nesploratori coi fiocchi!", spanish="Os doy la bienvenida al [CS:K]Dojo[CR]\n[CS:K]Marowak[CR].[K] ¡Aquí podéis entrenaros para\naprender a explorar mucho mejor!"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="You've done the impossible, you\ntwo! Defeating [CS:N]Darkrai[CR]...!", french="Vous avez accompli l'impossible!\nTerrasser [CS:N]Darkrai[CR]...!", german="Ihr zwei habt das Unmögliche\ngeschafft! Ihr habt [CS:N]Darkrai[CR] besiegt!", italian="Avete fatto l'impossibile!\nSconfiggere [CS:N]Darkrai[CR]...!", spanish="¡Habéis hecho lo imposible!\n¡Derrotar a [CS:N]Darkrai[CR]!"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="I didn't expect any less of you!\nAfter all, you're students of [CS:K]Marowak[CR] Dojo!", french="Je n'en attendais pas moins de\nvotre part! Après tout, vous avez fait vos\narmes au [CS:K]Dojo Ossatueur[CR]!", german="Von euch hätte ich auch nichts\nGeringeres erwartet, seid ihr doch Schüler des\n[CS:K]Knogga-Dojos[CR]!", italian="Sapevo che ce l'avreste fatta!\nDopotutto, avete frequentato il Dojo [CS:K]Marowak[CR]!", spanish="¡No esperaba menos! Al fin y\nal cabo, ¡sois estudiantes del [CS:K]Dojo Marowak[CR]!"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="Oh?[K] You don't ever recall\nbecoming a student of this dojo?", french="Quoi?[K] Vous ne vous rappelez pas\navoir jamais fait vos armes dans ce dojo?", german="Oh?[K] Ihr könnt euch nicht daran\nerinnern, Schüler dieses Dojos geworden zu\nsein?", italian="Eh?[K] Non vi ricordate di\naver frequentato il Dojo?", spanish="¿Eh?[K] ¿No recordáis haberos\nconvertido en mis discípulos?"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="...[K]That's not important in the\ngrand scheme of things, is it? Ha!", french="... [K]Ça n'a aucune importance\ndans le grand ordre de l'univers, n'est-ce\npas? Ha!", german="...[K]Im Hinblick auf das große\nGanze ist das doch relativ belanglos, nicht\nwahr? Ha!", italian="...[K] Non ha importanza nel\ndisegno generale delle cose, no? Ah!", spanish="Hum...[K] Eso son nimiedades,\n¿no creéis? ¡Ja!"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="I heard what's going on from\nthe others!", french="Ah, vous voilà, vous deux!\nLes autres m'ont raconté ce qui\nse passait!", german="Ich habe von den anderen\nerfahren, was los ist!", italian="Ho saputo dagli altri cosa sta\nsuccedendo!", spanish=" ¡Ya me han contado!"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="It's you two! There's no failure\nin either of you!", french="Vous réussissez tout ce que\nvous entreprenez, ma parole!", german="Ihr zwei seid es! Keiner von\neuch ist ein Versager!", italian="Voi due non potete fallire!", spanish="Desde luego, sois un equipo\nexplorador de primera."})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english=" Go into battle with confidence!", french="Que la confiance vous\naccompagne au combat!", german="Zieht mit Zuversicht in den\nKampf!", italian="Andate e lottate avendo fiducia\nnei vostri mezzi!", spanish=" ¡Id a luchar con confianza!"})
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english=" Roooaaar!", french=" Grrrrrr!", german=" Roooaaar!", italian=" Grrrrrrr!", spanish=" ¡Grrrr!"})
end
return {
  {species="marowak", x=256, y=208, dir=Direction.Down, name="NPC_GARAGARA", talk=talk_npc_garagara},
}
