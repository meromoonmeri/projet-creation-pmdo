-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V37P03A/s31a3706.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back2_SetMode(5) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_V37P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- screen2_FadeIn(0, 30) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker("Shaymin", true, "shaymin", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SHEIMI_FC (espèce ROM, sans placement zone)
  SkySceneKit.say({english="That's right. Flying is so\nmuch fun!", french="Exactement.\nVoler, c'est tellement grisant!", german="Ganz genau. Und Fliegen macht\neine Menge Spaß!", italian="Esatto. Volare è proprio\ndivertente!", spanish=" Eso es. ¡Volar es divertidísimo!"})
  pcall(function() UI:SetSpeaker("Shaymin", true, "shaymin", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SHEIMI_FC (espèce ROM, sans placement zone)
  SkySceneKit.say({english="It's not much, but this is\na gift from me to you!", french="Ce n'est pas grand-chose,\nmais c'est un cadeau de ma part!", german="Ist nicht viel, aber betrachtet\nes als ein Geschenk von mir an euch!", italian="Non è molto, ma questo\nè un piccolo regalo da parte mia!", spanish="No es mucho, pero os lo dedico\ncomo regalo de todo corazón."})
  pcall(function() UI:SetSpeaker("Shaymin", true, "shaymin", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SHEIMI_FC (espèce ROM, sans placement zone)
  SkySceneKit.say({english="All right, let's soar down to the\nbase of the mountain!", french="Très bien, on décolle!\nRedescendons au pied de la montagne!", german="Alles klar, lasst uns den Berg\nhinuntersegeln!", italian="Forza, è ora di spiccare il volo\ne raggiungere la base della montagna!", spanish="De acuerdo, vamos volando al pie\nde la montaña."})
  pcall(function() UI:SetSpeaker("Shaymin", true, "shaymin", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SHEIMI_FC (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Hold on tight!", french=" Accrochez-vous!", german=" Gut festhalten!", italian=" Tenetevi forte!", spanish=" ¡Agarraos fuerte!"})
  -- message_Close
  -- GAP: se_Play(11019) — id SE NDS sans portage PMDO identifié
  pcall(function() GAME:MoveCamera(128, 220, 60, false) end) -- performer/caméra
  SkySubScreen.Hide(15) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(true, 15) -- screen_WhiteOutAll
  GAME:FadeOut(false, 0)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSe
  -- screen2_FadeIn(0, 30) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker("Shaymin", true, "shaymin", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SHEIMI_FC (espèce ROM, sans placement zone)
  SkySceneKit.say({english="[CN]And so Team [team:],\n[CN]which had successfully climbed to the\n[CN][CS:P]Sky Peak[CR] Summit...", french="[CN]Ainsi, l'Equipe [team:],\n[CN]après avoir conquis le\n[CN][CS:P]Sommet du Pic Céleste[CR]...", german="[CN]Team [team:] bedankte sich nach diesem\n[CN]erfolgreichen Ausflug zur [CS:P]Himmelsgipfelspitze[CR]\n[CN]vielmals beim lieben [CS:N]Shaymin[CR]...", italian="[CN]E così il Team [team:],\n[CN]che era riuscito a conquistare la vetta\n[CN]del [CS:P]Picco del Cielo[CR]...", spanish="[CN]De esta forma, tras subir\n[CN]con éxito a la [CS:P]Cumbre del Cielo[CR],\n[CN]el [CS:X]Equipo[CR] [team:]..."})
  pcall(function() UI:SetSpeaker("Shaymin", true, "shaymin", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SHEIMI_FC (espèce ROM, sans placement zone)
  SkySceneKit.say({english="[CN]Thanked [CS:N]Shaymin[CR]\n[CN]graciously and returned to Treasure Town.", french="[CN]... remercia [CS:N]Shaymin[CR]\n[CN]pour son aide et retourna à Bourg-Trésor.", german="[CN]Nach sicherem Flug kehrten\n[CN]alle nach Schatzstadt zurück.", italian="[CN]... ringraziò profondamente [CS:N]Shaymin[CR]\n[CN]e tornò a Borgo Tesoro.", spanish="[CN]Le dio las gracias gentilmente a [CS:N]Shaymin[CR]\n[CN]y volvió a Aldea Tesoro."})
  pcall(function() UI:SetSpeaker("Shaymin", true, "shaymin", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SHEIMI_FC (espèce ROM, sans placement zone)
  SkySceneKit.say({english="[CN]And on the evening of the day they returned,\n[CN]there was a huge party at [CS:K]Spinda[CR]'s Café...", french="[CN]Et le soir même de leur retour,\n[CN]on organisa une grande fête au [CS:K]Café Spinda[CR]...", german="[CN]Am Abend ihrer Rückkehr fand eine\n[CN]große Party im [CS:K]Pandir-Café[CR] statt.", italian="[CN]E quella sera, quando arrivarono a casa,\n[CN]ci fu un'enorme festa al Caffè di [CS:K]Spinda[CR]...", spanish="[CN]La noche de su regreso se celebró\n[CN]una gran fiesta en la [CS:K]Cafetería Spinda[CR]..."})
  pcall(function() UI:SetSpeaker("Shaymin", true, "shaymin", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SHEIMI_FC (espèce ROM, sans placement zone)
  SkySceneKit.say({english="[CN]Everyone stayed up until dawn,\n[CN]discussing the exploration...", french="[CN]Tout le monde resta jusqu'aux aurores\n[CN]et on parla beaucoup de l'exploration...", german="[CN]Das Austauschen der Erlebnisse und Geschichten\n[CN]dauerte bis in die frühen Morgenstunden...", italian="[CN]Rimasero tutti alzati fino a tardi\n[CN]a parlare dell'esplorazione...", spanish="[CN]Todos se quedaron despiertos hasta tarde\n[CN]hablando de la exploración..."})
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(60)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
end
