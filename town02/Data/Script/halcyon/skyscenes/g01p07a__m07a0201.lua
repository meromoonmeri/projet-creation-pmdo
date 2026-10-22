-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07A/m07a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  GAME:WaitFrames(30)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P06A) [décor sub chargé: Sub_v02p06a]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v02p06a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(150)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(90)
  pcall(function() UI:SetSpeaker("Zubat", true, "zubat", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_ZUBATTO (espèce ROM, sans placement zone)
  SkySceneKit.say({english="We just had dinner, but I could\ngo for some more food.", french="On vient juste de manger, mais\nj'ai encore un petit creux, moi.", german="Es gab gerade erst Abendessen,\naber ich könnte noch mehr vertragen.", italian="Abbiamo appena cenato, ma\nnon mi dispiacerebbe mangiare qualcos'altro.", spanish="Aunque acabamos de cenar, no\nme sentaría mal un poco más de comida."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Koffing", true, "koffing", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_DOGAASU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="My belly'll never get filled on\ngrub like that.", french="Cette nourriture me suffit pas!\nMoi, c'est pas un petit creux, c'est un gouffre!", german="Bei so einer Pampe wird mein\nMagen nie voll werden.", italian="Non riuscirò mai a riempirmi\nla pancia con quella roba.", spanish="Con lo que nos dan, no me\nbasta para llenar la tripa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Skuntank", true, "skuntank", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SUKATANKU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="All right. The guild members\nhave all gone off to bed...", french="C'est bon. Les membres de la\nGuilde sont tous allés se coucher...", german="Na gut. Die Gildenmitglieder sind\njetzt alle im Bett.", italian="Benone. I membri della Gilda\nsono andati a letto...", spanish="Muy bien. Todos los miembros\ndel [CS:N]Pokégremio[CR] se han acostado ya."})
  pcall(function() UI:SetSpeaker("Skuntank", true, "skuntank", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SUKATANKU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Let's go find it now.", french=" Cherchons-le.", german=" Gehen wir sie suchen.", italian=" Andiamo a cercare qualcosa.", spanish=" Ahora podemos ir a buscarla."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Zubat", true, "zubat", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_ZUBATTO (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Huh? Find what?", french=" Hein? Chercher quoi?", german=" Äh? Was suchen?", italian=" Eh? Cercare cosa?", spanish=" ¿A quién? ¿De qué hablas?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Skuntank", true, "skuntank", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SUKATANKU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="What else? The guild's food\nstock.", french="Ben le garde-manger de\nla Guilde, tiens!", german="Was wohl? Die Vorratskammer\nder Gilde.", italian="Cos'altro? Le scorte di cibo\ndella Gilda.", spanish="¿A qué me voy a referir?\nA la despensa del [CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker("Skuntank", true, "skuntank", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_SUKATANKU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="We'll find their food and give\nourselves a proper feast.", french="On va le dévaliser\npour se faire un vrai festin.", german="Wenn wir die Vorräte gefunden\nhaben, schlagen wir uns den Wanst voll.", italian="Cerchiamo dove tengono il cibo\ne mangiamo a sazietà!", spanish="Cuando encontremos la comida\nnos vamos a dar un buen festín."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Koffing", true, "koffing", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_DOGAASU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" I like that thinking, Chief!", french=" J'aime bien cette idée, chef!", german=" Die Idee gefällt mir, Boss!", italian=" Ottima idea, capo!", spanish=" ¡Una idea excelente, Jefe!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Zubat", true, "zubat", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_ZUBATTO (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Okay, let's get to it!", french=" Moi aussi, allons-y!", german=" Okay, fangen wir an!", italian=" Ok, andiamo!", spanish=" ¡Vamos ahora mismo!"})
  -- message_Close
  GAME:WaitFrames(90)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
