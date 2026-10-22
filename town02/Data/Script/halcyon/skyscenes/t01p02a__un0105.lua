-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/un0105.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) or (SkyProg.cmp_side(40, 3) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7] || scn($SCENARIO_SIDE) >= [40
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_yarukimono = SkySceneKit.spawn_npc("vigoroth", 184, 232, Direction.Right, "NPC_YARUKIMONO")
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" Yo! [CS:Y]Bidoof[CR]!", french=" Yo! [CS:Y]Keunotor[CR]!", german=" Hey! [CS:Y]Bidiza[CR]!", italian=" Ehilà! [CS:Y]Bidoof[CR]!", spanish=" ¡Buenas, [CS:Y]Bidoof[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Not that I'm particularly\nconcerned...", french="C'est pas que ça\nm'inquiète vraiment...", german="Nicht, dass es mich wirklich\nwas angehen würde...", italian=" Non che mi interessi molto...", spanish="No es que me preocupe\nespecialmente..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="But I haven't seen [CS:N]Spoink[CR]\nlately...", french="... mais j'ai pas vu [CS:N]Spoink[CR]\ndepuis quelque temps...", german="Aber ich habe [CS:N]Spoink[CR] schon\nlänger nicht mehr gesehen...", italian="... ma è da un po' che non vedo\n[CS:N]Spoink[CR]...", spanish="Pero hace tiempo que\nno veo a [CS:N]Spoink[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yeah, [K]have you heard about the\nrecent increase in bad Pokémon?", french="Ouaip, [K]t'as entendu parler\nde cette histoire de méchants Pokémon\nqui apparaissent ces derniers temps?", german="Jaaa,[K] hast du von dem\nAuftauchen der bösartigen Pokémon gehört?", italian="Ah sì, [K]hai sentito che\nultimamente sono comparsi un sacco\ndi Pokémon cattivi?", spanish="Ah,[K] ¿sabes que últimamente\nhay cada vez más Pokémon malvados?"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="[CS:N]Spoink[CR]...[K]\nHe carries a pearl on top of his head.", french="[CS:N]Spoink[CR]...[K]\nIl porte une perle sur sa tête.", german="[CS:N]Spoink[CR]...[K]\nAuf seinem Kopf trägt er eine wertvolle Perle.", italian="[CS:N]Spoink[CR]...[K]\nPorta sempre una perla in testa.", spanish="[CS:N]Spoink[CR]...[K]\nlleva una perla en la cabeza."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" So, I'm a little worried...", french="Alors, je me fais un peu\nde souci...", german=" Daher mache ich mir Sorgen...", italian=" Quindi sono un po' preoccupato...", spanish=" Así que me preocupa un pelín..."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="But...[K]\nMaybe I'm just being paranoid!", french="Mais...[K] je dois être un peu\nparanoïaque, voilà tout!", german="Aber...[K] Vielleicht bin ich auch\nschon ein bisschen paranoid!", italian=" Ma...[K] forse esagero!", spanish="Pero bueno...[K]\nSeguro que solo son paranoias mías."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" He always looks so happy...", french=" Il a toujours l'air si joyeux...", german="Ich habe ihn immer nur fröhlich\nerlebt...", italian=" Ha sempre un'aria così felice...", spanish=" Siempre parece tan contento..."})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="I guess he will show up\none day feeling happy...just like always!", french="Je pense qu'il va bientôt\nremontrer le bout de son groin, tout joyeux...\ncomme toujours!", german="Ich denke, er wird eines\nglücklichen Tages wieder auftauchen...\nFroh wie immer!", italian="Scommetto che prima o poi\nsalterà fuori felice come sempre!", spanish="Supongo que aparecerá un día\nde estos tan pancho... ¡como siempre!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_yarukimono, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" Hah-hahahaha!", french=" Hahahahaha!", german=" Ha-hahahaha!", italian=" Ah-ahahah!", spanish=" ¡Ja... ja, ja, ja, ja!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(npc_npc_yarukimono, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_yarukimono, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp_side(40, 2) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 2]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Yo! [CS:Y]Bidoof[CR]![K] How's guild life\ntreating you?", french="Yo! [CS:Y]Keunotor[CR]![K]\nComment on te traite, à la Guilde?", german="Hey! [CS:Y]Bidiza[CR]![K] Wie ergeht es\ndir in der Gilde?", italian="Ehilà! [CS:Y]Bidoof[CR]![K]\nCome va alla Gilda?", spanish="¡Buenas, [CS:Y]Bidoof[CR]![K]\n¿Cómo te va la vida en el [CS:N]Pokégremio[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english="Work hard at your training!\nWork real hard!", french="Entraîne-toi dur!\nLésine pas!", german="Gib dir viel Mühe beim Training!\nSehr viel Mühe!", italian="Dacci dentro con l'allenamento!\nNon mollare mai!", spanish="¡Entrena todo lo duro que sepas!\n¡Tienes que ir a por todas!"})
  pcall(function() UI:SetSpeaker(npc_npc_yarukimono) end)
  SkySceneKit.say({english=" Work hard and do your best!", french="Donne le meilleur de\ntoi-même!", german=" Arbeite hart und gib dein Bestes!", italian="Lavora sodo e fai del tuo\nmeglio!", spanish=" ¡Trabaja duro y dalo todo!"})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
