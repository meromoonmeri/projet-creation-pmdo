-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D55P41A/n06a1701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(152, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D55P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  local npc_npc_bosugodora = SkySceneKit.spawn_npc("aggron", 256, 192, Direction.Down, "NPC_BOSUGODORA")
  pcall(function() GROUND:CharSetEmote(npc_npc_bosugodora, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english=" GRAA-HAHAHAHA-HAHAHAHA!!", french=" GRAA HA HA HA HA HA HA HA!!", german=" GRAA-HAHAHAHA-HAHAHAHA!!!", italian=" GRAAA-AHAHAHAH-AHAHAHAH!!!", spanish=" ¡¡Jaaa, ja, ja, ja, ja, ja!!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_bosugodora, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english="You again![K] Did you come here\nfor another fight?!", french="Encore vous![K] Vous cherchez\nla bagarre?!", german="Ihr schon wieder![K] Seid ihr\nfür einen weiteren Kampf gekommen?!?", italian="Ancora voi![K] Siete qui per avere\nun'altra lezione?!", spanish="¡Otra vez vosotras![K] ¡¿Habéis\nvenido a por más pelea?!"})
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english="You just don't learn![K]\nGRAA-HAHAHAHA-HAHAHAHA!!", french="Vous n'avez pas retenu la\nleçon?![K] GRAA HA HA HA HA!!", german="Ihr lernt auch nicht dazu![K]\nGRAA-HAHAHAHA-HAHAHAHA!!!", italian="Ma non imparate mai![K]\nGRAAA-AHAHAHAH-AHAHAHAH!!!", spanish="¡Si es que no aprendéis![K]\n¡¡Jaaa, ja, ja, ja, ja, ja!!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_bosugodora, "happy", 1) end)
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_bosugodora, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_TEAM_CHARMS_THEME non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Hee-hee![K] Did you think we'd just\nstumble back in here without thinking?", french="Hi hi![K] Tu ne crois tout de même\npas que nous sommes là par hasard?", german="Hi-hi![K] Glaubst du, wir würden\nhier einfach wieder hineinstolpern, ohne\nnachzudenken?", italian="Ih ih![K] Pensavi che fossimo\ntornate qui senza sapere a cosa andavamo\nincontro?", spanish="¡Ji, ji![K] ¿Acaso crees que hemos\nllegado hasta aquí sin darnos cuenta?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Last time didn't go so well...", french="Tu nous as eues la dernière\nfois...", german="Das letzte Mal war nicht so\ntoll...", italian="L'ultima volta non è andata\ntanto bene...", spanish="La otra vez no nos fue\ndemasiado bien..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Don't you think we'd be\nplanning something this time?", french="Alors tu crois vraiment qu'on\nserait revenues sans avoir un plan?", german="Meinst du, wir haben dieses\nMal keinen Plan?", italian="Ma ora non credi che potremmo\naver messo a punto un piano per battervi?", spanish="¿No crees que podamos\nhabernos preparado para venceros?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 224, 248, Direction.Up, "NPC_CHAAREMU")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" This time, we won't lose!", french="Cette fois-ci, tu vas mordre\nla poussière!", german="Diesmal werden wir nicht\nverlieren!", italian=" Questa volta non perderemo!", spanish=" ¡Esta vez no vamos a perder!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english="Humph![K] As usual, you're only\ngood at talking!", french="Pfff![K] C'est toujours le même\nrefrain!", german="Humpf![K] Wie beim letzten Mal\nseid ihr nur schnell mit dem Mund. Der Rest\nist unserer nicht würdig!", italian="Umpf![K] Come al solito, siete\nbrave solo a parole!", spanish="¡Ja![K] Para variar, solo se os da\nbien parlotear."})
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english=" It's fine!", french=" Soit!", german=" Kommt nur!", italian=" E va bene!", spanish=" ¡A mí me da igual!"})
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english="How many times are you going to\ncome here...", french="Combien de fois comptez-vous\nrevenir...", german="Wie häufig wollt ihr hier\neigentlich noch herkommen?", italian="Quante altre volte volete\npassare per di qua...?", spanish="Pero... ¿cuántas veces pensáis\nvolver?"})
  -- message_Close
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english=" Just looking for a fight!?", french=" Vous avez envie de vous battre?", german="Seid ihr auf einen ordentlichen\nKampf aus?!?", italian="Non riuscite a fare a meno\ndi lottare, eh?!", spanish=" ¡¿Solo en busca de pelea?!"})
  -- message_Close
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english="Let's go! [CS:N]Lairon[CR]![K]\nGet them!", french="A l'attaque! [CS:N]Galegon[CR]![K]\nChargez!!", german="Zum Angriff! [CS:N]Stollrak[CR]![K]\nAuf sie!!!", italian="Forza, [CS:N]Lairon[CR]![K]\nAddosso!", spanish="¡Venga, [CS:N]Lairon[CR]![K]\n¡A por ellas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_kodora = SkySceneKit.spawn_npc("lairon", 272, 280, Direction.Up, "NPC_KODORA")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1)
  local npc_npc_kodora5 = SkySceneKit.spawn_npc("lairon", 200, 272, Direction.UpRight, "NPC_KODORA5")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(3)
  local npc_npc_kodora6 = SkySceneKit.spawn_npc("lairon", 176, 256, Direction.UpRight, "NPC_KODORA6")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1)
  local npc_npc_kodora2 = SkySceneKit.spawn_npc("lairon", 304, 272, Direction.UpLeft, "NPC_KODORA2")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(3)
  local npc_npc_kodora3 = SkySceneKit.spawn_npc("lairon", 328, 256, Direction.UpLeft, "NPC_KODORA3")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1)
  local npc_npc_kodora4 = SkySceneKit.spawn_npc("lairon", 232, 280, Direction.Up, "NPC_KODORA4")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora5, "happy", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora3, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora4, "happy", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora2, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora6, "happy", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_bosugodora) end)
  SkySceneKit.say({english="[CS:N]Lairon[CR]: GROOOAAAAHH!!", french="[CS:N]Galegon[CR]: Groooaaahh!", german="[CS:N]Stollrak[CR]: Groooaaah!", italian="[CS:N]Lairon[CR]: GROOOAAAAHHH!!", spanish="[CS:N]Lairon[CR]: ¡¡Groaaaaaaaaaaah!!"})
  GAME:WaitFrames(24)
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora5, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora4, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora2, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora3, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kodora6, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 288, 248, Direction.Up, "NPC_SAANAITO")
  GROUND:EntTurn(npc_npc_saanaito, Direction.DownRight)
  do local p=npc_npc_saanaito.Position; GROUND:MoveToPosition(npc_npc_saanaito, p.X+(-4), p.Y+(-4), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.DownLeft)
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(4), p.Y+(-4), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(18)
  -- SetAnimation(27) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="[CS:N]Medicham[CR]! [CS:Y]Lopunny[CR]!\nHere they come!", french="[CS:N]Charmina[CR]! [CS:Y]Lockpin[CR]!\nIls arrivent!", german="[CS:N]Meditalis[CR]! [CS:Y]Schlapor[CR]!\nNehmt euch in Acht, wir werden angegriffen!", italian="[CS:N]Medicham[CR]! [CS:Y]Lopunny[CR]!\nTenetevi pronte!", spanish="¡[CS:N]Medicham[CR], [CS:Y]Lopunny[CR]!\n¡Preparaos, que vienen!"})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  -- SetAnimation(24) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Anytime!", french=" Je les attends de pied ferme!", german=" Allzeit bereit!", italian=" Mettiamocela tutta!", spanish=" ¡Venga!"})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(24) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="OK.\nLet's go! [M:H8]", french=" O.K. C'est parti! [M:H8]", german=" Auf geht's! [M:H8]", italian=" Ok. Andiamo! [M:H8]", spanish=" De acuerdo. ¡Vamos! [M:H8]"})
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  -- supervision_SpecialActing(24, 0, 0) [cadrage NDS]
  -- supervision_SpecialActing(25, 0, 0) [cadrage NDS]
  -- GAP: se_Play(10249) — id SE NDS sans portage PMDO identifié
  -- supervision_SpecialActing(26, 0, 0) [cadrage NDS]
  GAME:WaitFrames(120)
  GAME:FadeOut(true, 30) -- screen_WhiteOutAll
  -- supervision_SpecialActing(3, 0, 0) [cadrage NDS]
  -- main_EnterDungeon(152, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
