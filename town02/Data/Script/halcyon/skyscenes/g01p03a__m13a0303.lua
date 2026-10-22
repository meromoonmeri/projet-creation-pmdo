-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m13a0303.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P03A, 'UM13') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 352, 216, Direction.DownLeft, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 392, 224, Direction.Down, "NPC_PUKURIN")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 312, 216, Direction.Down, "NPC_YONOWAARU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 408, 240, Direction.UpLeft, "NPC_CHIRIIN")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(15)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(30)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 320, 248, Direction.UpRight, "NPC_DIGUDA")
  -- SetAnimation(4) [anim idle native]
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Um...[K] What about me...?", french=" Euh...[K] Et moi...?", german=" Ähm...[K] Und was ist mit mir?", italian=" Ehm...[K] E io...?", spanish=" Vaya...[K] ¿Y yo qué...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_diguda, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 352, 272, Direction.Up, "NPC_KIMAWARI")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_diguda, 4) end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 296, 240, Direction.UpRight, "NPC_DOGOOMU")
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_diguda, 4) end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 352, 248, Direction.Up, "NPC_HEIGANI")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_diguda, 4) end)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 384, 248, Direction.UpLeft, "NPC_GUREGGURU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_diguda, 4) end)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 408, 264, Direction.UpLeft, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_diguda, 4) end)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 376, 272, Direction.UpLeft, "NPC_BIPPA")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_diguda, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" [CS:N]Diglett[CR] will remain at the guild.", french=" [CS:N]Taupiqueur[CR] restera à la Guilde.", german=" [CS:N]Digda[CR] wird in der Gilde bleiben.", italian=" [CS:N]Diglett[CR] rimarrà alla Gilda.", spanish=" [CS:N]Diglett[CR], tú te quedarás aquí."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We can't very well leave the\nguild completely unattended.", french="Quelqu'un doit rester pour veiller\nau grain.", german="Wir können die Gilde nicht\nunbeaufsichtigt lassen.", italian="Non possiamo certo andarcene\nsenza lasciare qui qualcuno.", spanish="No podemos dejar el [CS:N]Pokégremio[CR]\ncompletamente desatendido."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chiriin, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="[CS:N]Croagunk[CR] and I are staying\nbehind at the guild too.", french="[CS:N]Cradopaud[CR] et moi, on reste\naussi à la Guilde.", german="[CS:N]Glibunkel[CR] und ich bleiben\nauch hier.", italian="Anche io e [CS:N]Croagunk[CR] resteremo\nqui.", spanish="[CS:N]Croagunk[CR] y yo también nos\nquedaremos en el [CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="The work we do at the guild is\nimportant too.[K] Let's make sure we keep up our\ngood work!", french="Le rôle qu'on remplit ici a\négalement son importance.[K] Continuons\nà faire du bon travail!", german="Unsere Arbeit hier ist auch\nwichtig.[K] Sehen wir zu, dass wir unseren Job\nso gut wie immer machen!", italian="Il lavoro che svolgiamo qui è\nimportante per tutti.[K] Anche noi dobbiamo\nimpegnarci!", spanish="El trabajo que hacemos aquí\ntambién es muy importante.[K] Por eso,\nno debemos descuidarlo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Y-yes!", french=" Oui!", german=" J-ja!", italian=" V-Va bene!", spanish=" ¡Sí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- message_FacePositionOffset(-2, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Now, let's find the Time Gears,\neveryone!", french="Et maintenant, objectif: les\nRouages du Temps!", german="Und nun lasst uns die Zahnräder\nder Zeit suchen, Pokémon!", italian="Andiamo e troviamo gli\nIngranaggi del Tempo!", spanish="Y, ahora, ¡encontrad esos\nEngranajes del Tiempo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.DownRight)
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  GROUND:EntTurn(npc_npc_diguda, Direction.UpRight)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  GROUND:EntTurn(npc_npc_guregguru, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" YOOM...TAH!", french=" TA... DAAA!", german=" LUUU... FIII!", italian=" BADABUM!", spanish=" ¡Genial!"})
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  -- SetAnimation(24) [anim idle native]
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: SÌÌÌÌÌÌ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Down)
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_diguda, Direction.Down)
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  do local p=npc_npc_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_yonowaaru, p.X+(-16), p.Y+(0), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(40), p.Y+(0), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(48), p.Y+(8), false, 2) end
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_chiriin, 516, 236, false, 2)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Right)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(npc_npc_dogoomu, 332, 124, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 332, 124, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 364, 172, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_heigani, 332, 124, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_kimawari, 332, 124, false, 2)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_perappu, 4) end)
  GAME:WaitFrames(30)
  pcall(function() GAME:MoveCamera(304, 252, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_yonowaaru, 304, 236, false, 2)
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-4), p.Y+(4), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="The [CS:P]Northern Desert[CR] is not only\nwide and deep, it is raked by vicious\nsandstorms.", french="Non seulement le [CS:P]Désert du Nord[CR]\nest immense, mais il est sans cesse balayé par\ndes tempêtes de sable dévastatrices.", german="Die [CS:P]Nordwüste[CR] ist nicht nur sehr\nweitläufig und tief, sondern wird auch von\nverheerenden Sandstürmen heimgesucht.", italian="Il [CS:P]Deserto del Nord[CR] non è solo\nmolto vasto, ma è anche spazzato da terribili\ntempeste di sabbia.", spanish="El [CS:P]Desierto Norte[CR] no solo es muy\nextenso, además suele estar asolado\npor fuertes tormentas de arena."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Please, do take care!", french="Prenez garde, je vous en\nconjure!", german=" Seid bitte vorsichtig!", italian="Vi prego di fare molta\nattenzione!", spanish="¡Tened mucho cuidado,\npor favor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yep! Thanks!", french=" C'est noté. Merci!", german=" Okay! Danke!", italian=" Ok! Lo faremo!", spanish=" Lo tendremos, gracias."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Will do! Thank you!", french=" C'est noté. Merci!", german=" Sind wir! Danke!", italian=" Sì! Staremo attenti!", spanish=" Lo tendremos, gracias."})
  else
  SkySceneKit.say({english=" Will do! Thank you!", french=" C'est noté. Merci!", german=" Sind wir! Danke!", italian=" Sì! Faremo attenzione!", spanish=" Lo tendremos, gracias."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[hero], let's give it our\nbest!", french="Donnons le meilleur de\nnous-mêmes, [hero]!", german="[hero], geben wir unser\nBestes!", italian=" Diamoci dentro, [hero]! ", spanish="[hero], ¡esforcémonos\ntodo lo posible!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [hero], let's do our best!", french="Donnons le meilleur de\nnous-mêmes, [hero]!", german="[hero], lass uns unser\nBestes geben!", italian="Dobbiamo fare del nostro meglio,\n[hero]!", spanish="[hero], ¡esforcémonos\ntodo lo posible!"})
  else
  SkySceneKit.say({english=" [hero], let's try our best!", french="Donnons le meilleur de\nnous-mêmes, [hero]!", german="[hero], strengen wir uns\nan!", italian="Dobbiamo fare del nostro meglio,\n[hero]!", spanish="[hero], ¡esforcémonos\ntodo lo posible!"})
  end
  -- message_Close
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[20] = 1 -- dungeon_mode(20) = DMODE_OPEN (ROM)
  SkySceneKit.cleanup_npcs()
end
