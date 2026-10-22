-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D02P11A/m02a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D02P11A) [neutre/état moteur]
  if true --[[BranchVariation: ROM Sky EU]] then -- if ROM: variation
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="You wake up one day, only to realize that\nyou've been turned into a Pokémon and are\nnow in a world inhabited only by Pokémon!", french="A votre grande surprise, vous vous réveillez\nun jour dans la peau d'un Pokémon, au cœur\nd'un monde peuplé de ces créatures!", german="Eines Tages wachst du auf und bemerkst, dass\ndu in ein Pokémon verwandelt wurdest und\ndich nun in der Welt der Pokémon befindest!", italian="Un giorno ti risvegli e ti rendi conto di essere\nun Pokémon che vive in un mondo popolato\nsolo da altri Pokémon!", spanish="Un día te despiertas en un mundo\nen el que solo hay Pokémon...\n¡Y te has convertido en uno de ellos!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="It's up to you to form an exploration team\nand embark on the adventure of a lifetime!", french="A vous de former une équipe d'exploration\npour vous embarquer dans l'aventure de\ntoute une vie!", german="Es liegt nun an dir, ein Erkundungsteam\nzu gründen und dich in das Abenteuer\ndeines Lebens zu stürzen!", italian="Il tuo compito è creare una squadra\nd'esplorazione e tuffarti nella più\nemozionante avventura che sia mai esistita!", spanish="¡Tu tarea consiste en formar un equipo\nexplorador y embarcarte en\nuna aventura inigualable!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Welcome to the fascinating world of\n[CS:L]Pokémon Mystery Dungeon: Explorers of Sky[CR]!\nNow YOU are the Pokémon!", french="Bienvenue dans le monde merveilleux de\n[CS:L]Pokémon Donjon Mystère: Explorateurs du Ciel[CR]!\nDésormais, c'est VOUS, le Pokémon!", german="Willkommen in der faszinierenden Welt von\n[CS:L]Pokémon Mystery Dungeon: Erkundungsteam\nHimmel[CR]! Jetzt bist DU das Pokémon!", italian="Un benvenuto nel meraviglioso mondo\ndi [CS:L]Pokémon Mystery Dungeon:[CR]\n[CS:L]Esploratori del cielo[CR]! Ora il Pokémon sei TU!", spanish="Te damos la bienvenida al fascinante mundo de\n[CS:L]Pokémon Mundo misterioso:\nExploradores del cielo[CR]. ¡Tú eres el Pokémon!"})
  GAME:FadeOut(false, 30)
  SkyProg.set(3, 3) -- $SCENARIO_MAIN = scn[3,3] (ROM)
  -- main_EnterDungeon(123, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Drenched Bluff.ogg", true) end)
  GROUND:MoveToPosition(hero, 276, 156, false, 2)
  GROUND:MoveToPosition(partner, 248, 156, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This must be the\nbluff's entrance.", french="Ce doit être l'entrée de\nla falaise.", german="Das muss der Eingang zur Klippe\nsein.", italian=" Questa dev'essere l'entrata.", spanish="Esta debe de ser la entrada\ndel risco."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This must be the\nbluff's entrance.", french="Ce doit être l'entrée de\nla falaise.", german="Das muss der Eingang zur Klippe\nsein.", italian=" Questa dev'essere l'entrata.", spanish="Esta debe de ser la entrada\ndel risco."})
  else
  SkySceneKit.say({english="This must be the\nbluff's entrance.", french="Ce doit être l'entrée de\nla falaise.", german="Das muss der Eingang zur Klippe\nsein.", italian=" Questa dev'essere l'entrata.", spanish="Supongo que esta es la entrada\ndel risco."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Spoink[CR]'s mission description said\nthe pearl is deep down on the B7F level.", french="Le descriptif de mission de\n[CS:N]Spoink[CR] disait que la perle se trouve à l'étage\nE. -7.", german="In der Beschreibung von [CS:N]Spoink[CR]\nstand, dass die Perle tief unten auf Ebene U7\nliegt.", italian="Nella descrizione della missione,\n[CS:N]Spoink[CR] diceva che la perla si trova al P. -7.", spanish="Según la descripción de [CS:N]Spoink[CR],\nla perla está en el piso -7."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Spoink[CR]'s mission description said\nthe pearl is deep down on the B7F level.", french="Le descriptif de mission de\n[CS:N]Spoink[CR] disait que la perle se trouve à l'étage\nE. -7.", german="In der Beschreibung von [CS:N]Spoink[CR]\nstand, dass die Perle tief unten auf Ebene U7\nliegt.", italian="Nella descrizione della missione,\n[CS:N]Spoink[CR] diceva che la perla si trova al P. -7.", spanish="Según la descripción de [CS:N]Spoink[CR],\nla perla está en el piso -7."})
  else
  SkySceneKit.say({english="[CS:N]Spoink[CR]'s mission description said\nthe pearl is deep down on the B7F level.", french="Le descriptif de mission de\n[CS:N]Spoink[CR] disait que la perle se trouve à l'étage\nE. -7.", german="In der Beschreibung von [CS:N]Spoink[CR]\nstand, dass die Perle tief unten auf Ebene U7\nliegt.", italian="Nella descrizione della missione,\n[CS:N]Spoink[CR] diceva che la perla si trova al P. -7.", spanish="Según la descripción de [CS:N]Spoink[CR],\nla perla está en el piso -7."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's supposed to be a really\ndangerous place. We'd better be careful.", french="Apparemment, c'est un endroit\ndangereux. Il faudra faire attention!", german="Dieser Ort soll wirklich\ngefährlich sein. Wir sollten Vorsicht walten\nlassen.", italian="Dicono che questo sia un posto\nmolto pericoloso. Sarà meglio avanzare con\nprudenza.", spanish="Al parecer es un sitio muy\npeligroso. Será mejor que vayamos con\nmucho cuidado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It sounds like a seriously\ndangerous place. Let's be careful.", french="Apparemment, c'est un endroit\ndangereux. Il faudra faire attention!", german="Hört sich nach einem wirklich\ngefährlichen Ort an. Wir sollten vorsichtig\nsein.", italian="Dicono che questo sia un posto\nmolto pericoloso. Sarà meglio essere prudenti.", spanish="Parece que es un sitio muy\npeligroso. Tengamos mucho cuidado."})
  else
  SkySceneKit.say({english="It's supposedly very dangerous.\nLet's be really careful.", french="Apparemment, c'est un endroit\ndangereux. Il faudra faire attention!", german="Angeblich ist der Ort sehr\ngefährlich. Lass uns sehr vorsichtig sein.", italian="Dicono che questo sia un posto\nmolto pericoloso. Sarà meglio agire con\nprudenza.", spanish="Al parecer es un sitio muy\npeligroso. Hay que ir con mucho cuidado."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's do our best, [hero]!", french="Faisons de notre mieux,\n[hero]!", german="Geben wir unser Bestes,\n[hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Hagámoslo lo mejor posible,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's do our best, [hero]!", french="Faisons de notre mieux,\n[hero]!", german="Geben wir unser Bestes,\n[hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Vamos a hacerlo lo mejor\nposible, [hero]!"})
  else
  SkySceneKit.say({english=" Let's do our best, [hero]!", french="Faisons de notre mieux,\n[hero]!", german="Geben wir unser Bestes,\n[hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish="¡Debemos esforzarnos\nal máximo, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 264, 92, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(partner, 264, 92, false, 2)
  GAME:WaitFrames(20)
  GAME:FadeOut(false, 30)
  SkyProg.set(3, 3) -- $SCENARIO_MAIN = scn[3,3] (ROM)
  -- main_EnterDungeon(3, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
end
