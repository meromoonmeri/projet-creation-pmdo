-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/m22a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]It's [CS:N]Grovyle[CR]'s letter.[K]\n[CN]Would you like to read it?", french="[CN]C'est la lettre de [CS:N]Massko[CR].[K]\n[CN]La lire?", german="[CN]Es ist ein Brief von [CS:N]Reptain[CR].[K]\n[CN]Möchtest du ihn lesen?", italian="[CN]È la lettera di [CS:N]Grovyle[CR].[K]\n[CN]Vuoi leggerla?", spanish="[CN]Es la carta de [CS:N]Grovyle[CR].[K]\n[CN]¿Quieres leerla?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][partner] began reading\n[CN]the letter from [CS:N]Grovyle[CR].", french="[CN][partner] se met à lire\n[CN]la lettre de [CS:N]Massko[CR].", german="[CN][partner] liest den Brief\n[CN]von [CS:N]Reptain[CR] vor.", italian="[CN][partner] comincia a leggere\n[CN]la lettera di [CS:N]Grovyle[CR].", spanish="[CN][partner] empezó a leer\n[CN]la carta de [CS:N]Grovyle[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\"To [hero] and [partner]:[K]\nHow are you doing?\"", french="\"[hero] et [partner],[K]\nComment ça va, vous autres?", german="[F:S2]An [hero] und [partner]:[K]\nWie geht es euch?[F:E2]", italian="\"Per [hero] e [partner]:[K]\nCome va?\"", spanish="\"A [hero] y [partner]:[K]\n¿Qué tal os va?\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\\\"How goes your search for the [CS:P]Hidden Land[CR]?\\\"", french="Où en sont vos recherches au sujet des [CS:P]Terres\nIllusoires[CR]?", german="[F:S2]Wie läuft eure Suche nach dem\n[CS:P]Verborgenen Land[CR]?[F:E2]", italian="\"Come prosegue la vostra ricerca della\n[CS:P]Terra Nascosta[CR]?\"", spanish="\\\"¿Cómo va la búsqueda de la [CS:P]Tierra Oculta[CR]?\\\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\"Things are going well on my end. I've already\ncollected three Time Gears.\"", french="Tout va bien de mon côté. J'ai déjà récupéré\ntrois Rouages du Temps.", german="[F:S2]Für mich läuft es ganz gut. Ich habe schon\ndrei Zahnräder der Zeit eingesammelt.[F:E2]", italian="\"A me le cose stanno andando bene. Ho già\nraccolto tre Ingranaggi del Tempo.\"", spanish="\"A mí las cosas me van bien. Ya he recogido\ntres Engranajes del Tiempo.\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\\\"I have to find only two more Time Gears.\\\"", french="Il n'en reste plus que deux à trouver.", german="[F:S2]Ich muss nur noch zwei Zahnräder der Zeit\nfinden.[F:E2]", italian="\\\"Devo trovarne solo altri due.\\\"", spanish="\\\"Solo me falta encontrar otros dos.\\\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\\\"I plan to join you when I've collected all five.\\\"", french="Je vous rejoindrai dès que je les aurai tous\nles cinq.", german="[F:S2]Und ich habe vor, wieder zu euch zu stoßen,\nsobald ich alle fünf Zahnräder der Zeit habe.[F:E2]", italian="\"Pensavo di raggiungervi quando li avrò tutti\ne cinque.\"", spanish="\\\"Nos reuniremos cuando tenga los cinco.\\\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\"Plans have proceeded smoothly. [CS:N]Azelf[CR] and his\nfriends understood the situation. And they have\nfully cooperated.\"", french="Le plan fonctionne parfaitement. [CS:N]Créfadet[CR]\net ses amis ont compris la situation, et m'ont\napporté leur entière coopération.", german="[F:S2]Alles läuft nach Plan. [CS:N]Tobutz[CR] und seine\nFreunde haben die Situation verstanden und\nkooperieren.[F:E2]", italian="\"Il piano procede senza intoppi. [CS:N]Azelf[CR] e i suoi\namici hanno compreso la situazione. E hanno\ncooperato pienamente.\"", spanish="\"El plan va como estaba previsto. [CS:N]Azelf[CR] y\nsus amigos han entendido la situación y\nhan prestado toda su ayuda.\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\"[CS:N]Azelf[CR] told me that members of your guild let\nthem know I was coming. Thank you.\"", french="[CS:N]Créfadet[CR] m'a dit que des membres de votre\nGuilde les avaient avertis de ma venue.\nMerci beaucoup.", german="[F:S2][CS:N]Tobutz[CR] erzählte mir, dass Mitglieder eurer\nGilde sie wissen ließen, dass ich käme. Vielen\nDank dafür.[F:E2]", italian="\"[CS:N]Azelf[CR] mi ha detto che i membri della vostra\nGilda gli avevano comunicato che sarei\npassato. Grazie.\"", spanish="\"[CS:N]Azelf[CR] me dijo que los miembros del\n[CS:N]Pokégremio[CR] le advirtieron de que iba para allá.\nGracias.\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\"It's heartening to know that more and more\nPokémon are coming to trust us.\"", french="Ça fait chaud au cœur de savoir que de plus\nen plus de Pokémon croient en nous.", german="[F:S2]Es ist ermutigend, dass immer mehr Pokémon\ndazu übergehen, mir zu vertrauen.[F:E2]", italian="\"È incoraggiante sapere che sempre più\nPokémon cominciano a credere in noi.\"", spanish="\"Es reconfortante saber que cada vez hay\nmás Pokémon que entienden la situación.\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\"However, I will continue to stay away from\nTreasure Town and the guild.\"", french="Cependant, je vais continuer à me tenir\nà l'écart de Bourg-Trésor et de la Guilde.", german="[F:S2]Trotzdem werde ich mich von Schatzstadt\nund der Gilde fernhalten.[F:E2]", italian="\"Comunque, continuerò a tenermi lontano da\nBorgo Tesoro e dalla Gilda.\"", spanish="\"Sin embargo, seguiré sin acercarme\na Aldea Tesoro ni al [CS:N]Pokégremio[CR].\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\"First, I'm not certain if the Pokémon in this\nworld trust me entirely or not.\"", french="D'abord parce que je ne suis pas certain que\nles Pokémon de ce monde aient totalement\nconfiance en moi.", german="[F:S2]Zunächst einmal, weil ich nicht weiß, ob mir\ndie Pokémon in dieser Welt völlig vertrauen.[F:E2]", italian="\"Innanzitutto, non sono sicuro che in questo\nmondo tutti i Pokémon si fidino completamente\ndi me.\"", spanish="\"Para empezar, no estoy seguro de que\nlos Pokémon de este mundo confíen del\ntodo en mí.\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\"But there's something more troubling\nthan that.\"", french="Mais il y a autre chose qui me tracasse\nencore plus.", german="[F:S2]Aber es gibt noch etwas Beunruhigenderes.[F:E2]", italian="\\\"Ma c'è qualcosa che mi preoccupa di più.\\\"", spanish="\\\"Y hay algo mucho más inquietante.\\\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\"[CS:N]Dusknoir[CR] is liable to return from the future\nat any time.\"", french="[CS:N]Noctunoir[CR] est susceptible de revenir du futur\nà n'importe quel moment.", german="[F:S2]Es ist damit zu rechnen, dass [CS:N]Zwirrfinst[CR]\njederzeit aus der Zukunft zurückkommen\nkann.[F:E2]", italian="\"[CS:N]Dusknoir[CR] potrebbe tornare dal futuro\nin qualsiasi momento.\"", spanish="\"[CS:N]Dusknoir[CR] puede volver del futuro en cualquier\nmomento.\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\"Since [CS:N]Dusknoir[CR] will be coming, we should keep\na low profile.\"", french="Puisque [CS:N]Noctunoir[CR] va sûrement revenir,\non ferait mieux de garder profil bas.", german="[F:S2]Da [CS:N]Zwirrfinst[CR] kommen wird, sollten wir uns\nunauffällig verhalten.[F:E2]", italian="\"Dal momento che [CS:N]Dusknoir[CR] potrebbe tornare,\ndobbiamo tenere un profilo basso.\"", spanish="\"Como [CS:N]Dusknoir[CR] vendrá tarde o temprano,\nlo mejor será no llamar mucho la atención.\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\"This is another reason I should stay away\nfrom Treasure Town and the guild.\"", french="Raison de plus pour que je garde mes distances\navec Bourg-Trésor et la Guilde.", german="[F:S2]Dies ist ein anderer Grund, warum ich\nSchatzstadt und die Gilde meiden werde.[F:E2]", italian="\"Questa è un'altra ragione per cui mi tengo\nalla larga da Borgo Tesoro e dalla Gilda.\"", spanish="\"Ese es otro motivo por el que no quiero\nacercarme ni al [CS:N]Pokégremio[CR] ni a Aldea Tesoro.\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\"I may instead come back to Sharpedo Bluff or\nthe beach.\"", french="Je vous attendrai plutôt à la Falaise Sharpedo\nou sur la plage.", german="[F:S2]Stattdessen werde ich vielleicht zur\nTohaido-Klippe oder zum Strand kommen.[F:E2]", italian="\"Invece potrei tornare al Promontorio Sharpedo\no in spiaggia.\"", spanish="\"Si vuelvo, estaré en el Risco Sharpedo\no en la playa.\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\"If we should meet, we can then exchange\ninformation.\"", french="Si jamais on se retrouve, on pourra échanger\ndes informations plus précises.", german="[F:S2]Falls wir uns treffen, können wir dann\nInformationen austauschen.[F:E2]", italian="\"Se ci incontriamo, possiamo scambiarci\nqualche informazione.\"", spanish="\"Cuando nos encontremos, intercambiaremos\ninformación.\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\\\"Good luck on your end.\\\"", french="Bonne chance à vous.", german="[F:S2]Euch in jedem Fall viel Glück.[F:E2]", italian="\\\"Buona fortuna per tutto.\\\"", spanish="\\\"Que tengáis mucha suerte.\\\""})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="\"Together, we shall stop the planet's paralysis.\"\n- From [CS:N]Grovyle[CR]", french="Ensemble, on empêchera la Paralysie\nde la Planète.\"\n- [CS:N]Massko[CR]", german="[F:S2]Wir stoppen die Lähmung des Planeten!\n- Von [CS:N]Reptain[CR][F:E2]", italian="\"Insieme, possiamo fermare la paralisi del\npianeta.\"\n- Il vostro [CS:N]Grovyle[CR] -", spanish="\"Juntos, detendremos la parálisis del planeta.\"\nFirmado: [CS:N]Grovyle[CR]"})
  -- message_Close
  end
  end
end
