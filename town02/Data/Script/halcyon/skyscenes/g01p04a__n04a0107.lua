-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/n04a0107.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Phew...", french=" Pfiou...", german=" Puuuh...", italian=" Fiuuu...", spanish=" Buf..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I was nervous, having been\ncalled in out of the blue like that!", french="L'angoisse! Se faire convoquer\ncomme ça, j'hallucine!", german="War ich vielleicht nervös,\neinfach so aus dem Nichts heraus gefragt\nzu werden!", italian="Che agitazione! Non mi aspettavo\ndi ricevere un incarico simile!", spanish="¡Estaba nerviosísima,\nno esperaba que me llamaran de sopetón!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But it was a request from the\nGuildmaster. (Oh my gosh, I'm so happy!)", french="Mais c'est une requête du\nMaître de la Guilde. (Ben mince alors,\nj'en perds les pétales!)", german="Aber schließlich war es ein\ndirekter Auftrag des Gildenmeisters.\n(Auweia, ich bin so froh!)", italian="Ma è una richiesta del Capitano.\n(Shock! Come sono felice!)", spanish="Pero era una petición del\nGran Bluff. (¡Jo, qué fuerte me parece!)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'm representing the guild on\nthis...[K] So I have to do my best!", french="C'est moi qui représenterai la\nGuilde sur ce coup-là...[K] Alors je dois m'en\nmontrer digne!", german="Als Repräsentantin der Gilde...[K]\nDa muss ich mich von der besten Seite zeigen!", italian="In questa missione\nrappresenterò la Gilda...[K] quindi\ndevo fare del mio meglio!", spanish="Voy en representación del\n[CS:N]Pokégremio[CR]...[K] ¡Tengo que darlo todo!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I have to do my best and\napprehend [CS:N]Haunter[CR]!", french="Je dois faire de mon mieux et\nappréhender ce [CS:N]Spectrum[CR]!", german="Ich muss mich anstrengen und\n[CS:N]Alpollo[CR] dingfest machen!", italian="Devo mettercela tutta\ne catturare [CS:N]Haunter[CR]!", spanish="Tengo que ir a por todas y\ncapturar a [CS:N]Haunter[CR]."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I should hurry and prepare so I\ncan head out!", french="Il faut que je me dépêche de me\npréparer pour partir!", german="Also besser nicht trödeln mit\nder Vorbereitung, damit ich bald los kann!", italian="È meglio che mi sbrighi\ne mi prepari per partire!", spanish="¡He de darme prisa y prepararme\npara poder salir cuanto antes!"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]The Special Episode\n[CN]\"Today's 'Oh My Gosh'\"\n[CN]stars [CS:Y]Sunflora[CR] as the main character.", french="[CN][CS:Y]Héliatronc[CR] est le personnage principal\n[CN]de l'Episode Spécial intitulé\n[CN]\"Ben mince alors!\".", german="[CN]Die Bonusepisode\n[CN][F:S2]Das [F:S2]Auweia[F:E2] des Tages[F:E2]\n[CN]mit [CS:Y]Sonnflora[CR] in der Hauptrolle.", italian="[CN]L'episodio speciale\n[CN]\"Una giornata da shock\"\n[CN]ha come protagonista [CS:Y]Sunflora[CR].", spanish="[CN]El capítulo especial\n[CN]\"¡O sea, pero qué fuerte!\"\n[CN]tiene a [CS:Y]Sunflora[CR] por protagonista."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]You will progress through the story with\n[CN][CS:Y]Sunflora[CR] as the playable character.", french="[CN]Vous incarnerez [CS:Y]Héliatronc[CR].", german="[CN]Du wirst die Geschichte mit [CS:Y]Sonnflora[CR]\n[CN]als spielbarem Charakter bestreiten.", italian="[CN]In questa storia impersonerai [CS:Y]Sunflora[CR].", spanish="[CN]Avanzarás en la historia\n[CN]con [CS:Y]Sunflora[CR]."})
  -- message_Close
end
