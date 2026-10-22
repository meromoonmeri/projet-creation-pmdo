-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P05A/n04a0104.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]I'm [CS:Y]Sunflora[CR]![K]\n[CN]I'm an apprentice to the Guildmaster!", french="[CN]Je m'appelle [CS:Y]Héliatronc[CR]![K]\n[CN]Je suis une apprentie du Maître de la Guilde!", german="[CN]Ich bin [CS:Y]Sonnflora[CR]![K]\n[CN]Ich bin ein Gildenlehrling!", italian="[CN]Mi chiamo [CS:Y]Sunflora[CR]![K]\n[CN]Sono un'apprendista del Capitano!", spanish="[CN]¡Soy [CS:Y]Sunflora[CR]![K]\n[CN]¡Soy una aprendiz del [CS:N]Pokégremio[CR]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]I really enjoy life here at the guild!", french="[CN]Je trouve la vie à la Guilde méga-chouette!", german="[CN]Das Leben in der Gilde gefällt mir sehr gut!", italian="[CN]Adoro stare qui alla Gilda!", spanish="[CN]¡Me encanta la vida en el [CS:N]Pokégremio[CR]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]I really like treasure![K]\n[CN]And training is really fun!", french="[CN]J'adore les trésors![K]\n[CN]Et l'entraînement, c'est trop fun!", german="[CN]Ich mag Schätze wirklich gerne![K]\n[CN]Und das Training macht einen Riesenspaß!", italian="[CN]Mi piacciono tanto i tesori![K]\n[CN]E l'allenamento è davvero divertente!", spanish="[CN]¡Me encantan los tesoros![K]\n[CN]¡Y entrenar es superdivertido!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Since I've joined the guild, my exploration\n[CN]ability has really grown.", french="[CN]Depuis que j'ai rejoint la Guilde, mes capacités\n[CN]d'exploratrice se sont vraiment améliorées.", german="[CN]Seitdem ich in der Gilde bin, haben sich meine\n[CN]Erkunderfähigkeiten wirklich verbessert.", italian="[CN]Da quando sono arrivata alla Gilda, le mie doti\n[CN]di esploratrice sono migliorate tantissimo.", spanish="[CN]Desde que me uní al [CS:N]Pokégremio[CR] he mejorado\n[CN]mucho como exploradora."})
  -- message_Close
  -- back_SetGround(LEVEL_G01P05A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 204, 244, false, 2)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]A few days ago, I received a call\n[CN]from the Guildmaster...", french="[CN]Il y a quelques jours, le Maître\n[CN]m'a convoquée...", german="[CN]Vor einigen Tagen wurde ich\n[CN]zum Gildenmeister gerufen...", italian="[CN]Qualche giorno fa, il Capitano\n[CN]ha detto che voleva vedermi...", spanish="[CN]Hace unos días el Gran Bluff\n[CN]me mandó llamar..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]I was so nervous.\n[CN]I wondered what it could be about.", french="[CN]J'étais super nerveuse.\n[CN]Je me demandais de quoi il voulait me parler.", german="[CN]Ich war nervös. Ich war mir nicht sicher,\n[CN]weswegen er nach mir fragte.", italian="[CN]Ero così agitata, mi chiedevo\n[CN]quale potesse essere il motivo.", spanish="[CN]Me puse de los nervios.\n[CN]¡A saber qué querría!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]When I went to the\n[CN]Guildmaster's chamber to find out...", french="[CN]Quand je suis entrée dans\n[CN]la chambre du Maître...", german="[CN]Also ging ich zur Kammer des\n[CN]Gildenmeisters, um es herauszufinden...", italian="[CN]Quando sono entrata nella stanza\n[CN]del Capitano per scoprirlo...", spanish="[CN]Cuando me presenté en la\n[CN]Cámara del Gran Bluff..."})
  -- message_Close
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 208, 200, Direction.Down, "NPC_PUKURIN")
  -- SetAnimation(5) [anim idle native]
  GAME:WaitFrames(60)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Oh my gosh![K]\n[CN]I was praised!", french="[CN]Ben mince alors![K]\n[CN]On m'a fait des louanges!", german="[CN]Auweia![K]\n[CN]Ich wurde gelobt!", italian="[CN]Shock![K]\n[CN]Mi ha fatto i complimenti!", spanish="[CN]¡Jo, qué fuerte![K]\n[CN]¡Recibí un montón de elogios!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]I'd been working really hard and\n[CN]doing well on explorations!", french="[CN]J'avais travaillé si dur et je m'étais\n[CN]tellement appliquée pendant les explorations!", german="[CN]Weil ich wirklich hart gearbeitet und mich\n[CN]auf Erkundungen gut angestellt hatte!", italian="[CN]Avevo lavorato sodo e mi ero comportata\n[CN]bene durante le esplorazioni!", spanish="[CN]Había estado dándolo todo y teniendo\n[CN]éxito en mis exploraciones."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Oh my gosh! I was happy![K]\n[CN]I was so happy I thought I'd burst!", french="[CN]Ben mince alors! J'étais super heureuse![K]\n[CN]Tellement que j'ai failli sauter de joie!", german="[CN]Auweia, was habe ich mich gefreut![K] Ich freute\n[CN]mich so sehr, dass ich Angst hatte, zu platzen!", italian="[CN]Shock! Ero così felice![K]\n[CN]Mi sembrava di scoppiare dalla gioia!", spanish="[CN]¡Jo, qué pasada, me puse hipercontenta![K]\n[CN]¡Casi me desmayo de la emoción y todo!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]But...", french="[CN]Mais...", german="[CN]Aber...", italian="[CN]Ma...", spanish="[CN]Pero..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]I didn't really have a lot of\n[CN]self-confidence yet.", french="[CN]Je n'ai pas encore vraiment\n[CN]confiance en moi.", german="[CN]An meinem Selbstvertrauen könnte\n[CN]ich noch etwas arbeiten.", italian="[CN]Non avevo ancora molta\n[CN]fiducia in me stessa.", spanish="[CN]En realidad aún no tenía demasiada\n[CN]confianza en mí misma."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]So I wanted to study more\n[CN]with the Guildmaster.", french="[CN]Le Maître a encore tant\n[CN]à m'enseigner!", german="[CN]Deswegen möchte ich noch viel\n[CN]vom Gildenmeister lernen.", italian="[CN]Quindi volevo imparare tante\n[CN]altre cose dal Capitano.", spanish="[CN]Así que quería estudiar más\n[CN]con el Gran Bluff."})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
