-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m22a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SkyProg.set(23, 1) -- $SCENARIO_MAIN = scn[23,1] (ROM)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Ahem![K] So in short...", french=" Hum![K] Donc, en bref...", german=" Ähem![K] Machen wir es kurz!", italian=" Ehm![K] Quindi in poche parole...", spanish=" ¡Ejem![K] Resumiendo..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The [CS:P]Hidden Land[CR] remains\nshrouded in mystery...", french="Le mystère des [CS:P]Terres Illusoires[CR]\nreste intact...", german="Das [CS:P]Verborgene Land[CR] bleibt uns\nweiterhin ein Rätsel...", italian="... la [CS:P]Terra Nascosta[CR] rimane\navvolta nel mistero...", spanish="La [CS:P]Tierra Oculta[CR] permanece\nenvuelta en un halo de misterio..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" But we're not giving up!", french=" Mais il faut persévérer!", german=" Aber wir geben nicht auf!", italian=" Ma non dobbiamo mollare!", spanish=" ¡Pero no vamos a rendirnos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 360, 272, Direction.UpRight, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Up, "NPC_DOGOOMU")
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 392, 256, Direction.Up, "NPC_CHIRIIN")
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 456, 256, Direction.Up, "NPC_KIMAWARI")
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 392, 272, Direction.Up, "NPC_HEIGANI")
  -- SetAnimation(23) [anim idle native]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 424, 256, Direction.Up, "NPC_BIPPA")
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 456, 272, Direction.Up, "NPC_DIGUDA")
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: URRÀ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
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
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Let's get out there and\ninvestigate again today!", french=" Poursuivons l'enquête!", german="Lasst uns da heute rausgehen\nund weiter forschen!", italian="Oggi andremo di nuovo là\nfuori a indagare!", spanish="¡Volvamos ahí fuera a investigar\nun día más!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Let's go, everyone!", french=" Allez, tout le monde!", german=" Gehen wir, Leute!", italian=" Andiamo, gente!", spanish=" ¡Vamos allá!"})
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
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: URRÀ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
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
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Down)
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_diguda, Direction.Down)
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Left)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 424, 208, Direction.Down, "NPC_PUKURIN")
  GROUND:MoveToPosition(npc_npc_pukurin, 420, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 224, 252, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 188, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 240, 272, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 188, false, 2)
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(-32), p.Y+(0), false, 2) end -- Move2PositionOffset
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_kimawari, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 132, false, 2)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Where should we go investigate\ntoday, [hero]?", french="Où est-ce que notre enquête va\nnous mener aujourd'hui, [hero]?", german="Wo sollen wir heute\nnachforschen, [hero]?", italian="Oggi dove possiamo indagare,\n[hero]?", spanish="¿Dónde vamos a ir hoy,\n[hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Where should we go investigate\ntoday, [hero]?", french="Où est-ce que notre enquête va\nnous mener aujourd'hui, [hero]?", german="Wo sollen wir heute\nnachforschen, [hero]?", italian="Oggi dove possiamo indagare,\n[hero]?", spanish="¿Dónde vamos a ir hoy,\n[hero]?"})
  else
  SkySceneKit.say({english="Where should we go investigate\ntoday, [hero]?", french="Où est-ce que notre enquête va\nnous mener aujourd'hui, [hero]?", german="Wo sollen wir heute\nnachforschen, [hero]?", italian="Oggi dove possiamo indagare,\n[hero]?", spanish="¿Dónde vamos a ir hoy,\n[hero]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But, you know, we've already\ntalked to [CS:N]Torkoal[CR].", french="Hier, nous avons déjà rendu\nvisite à [CS:N]Chartor[CR].", german="Wir haben doch schon mit [CS:N]Qurtel[CR]\ngesprochen.", italian="Ma, sai, con [CS:N]Torkoal[CR] abbiamo già\nparlato.", spanish=" Ya hemos hablado con [CS:N]Torkoal[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But we've already talked to\n[CS:N]Torkoal[CR].", french="Hier, nous avons déjà rendu\nvisite à [CS:N]Chartor[CR].", german="Wir haben doch schon mit [CS:N]Qurtel[CR]\ngesprochen.", italian="Ma, sai, con [CS:N]Torkoal[CR] abbiamo già\nparlato.", spanish=" Ya hemos hablado con [CS:N]Torkoal[CR]."})
  else
  SkySceneKit.say({english="But we've already talked to\n[CS:N]Torkoal[CR].", french="Hier, nous avons déjà rendu\nvisite à [CS:N]Chartor[CR].", german="Wir haben doch schon mit [CS:N]Qurtel[CR]\ngesprochen.", italian="Ma, sai, con [CS:N]Torkoal[CR] abbiamo già\nparlato.", spanish=" Ya hemos hablado con [CS:N]Torkoal[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We don't have any other leads.", french=" Mais on n'a aucune autre piste.", german=" Wir haben keine Spur mehr.", italian=" Non abbiamo nessun altro indizio.", spanish=" No tenemos ninguna otra pista."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We're out of leads.", french=" Mais on n'a aucune autre piste.", german=" Uns fehlt jede Spur.", italian=" Abbiamo finito gli indizi.", spanish=" No tenemos ninguna otra pista."})
  else
  SkySceneKit.say({english="I don't know where to\nlook next.", french=" Mais on n'a aucune autre piste.", german="Ich weiß nicht, wo wir als\nNächstes suchen sollten.", italian=" Non so più dove cercare.", spanish="No sé dónde podemos seguir\nbuscando."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end) -- message_SetActor(ACTOR_NPC_DIGUDA)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Pokémon detected![K]\nPokémon detected!", french="Pokémon détecté![K]\nPokémon détecté!", german="Pokémon entdeckt![K] Pokémon\nentdeckt!", italian="Pokémon in arrivo![K] Pokémon in\narrivo!", spanish="¡Pokémon detectado!\n¡Pokémon detectado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end) -- message_SetActor(ACTOR_NPC_DOGOOMU)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Whose footprint?[K]\nWhose footprint?", french="Identification empreinte...[K]\nIdentification empreinte...", german="Wessen Fußabdruck?[K]\nWessen Fußabdruck?", italian="A chi corrisponde la forma della\nzampa?[K] A chi corrisponde la forma della\nzampa?", spanish="¿De quién es la huella?\n¿De quién es la huella?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end) -- message_SetActor(ACTOR_NPC_DIGUDA)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="The footprint belongs to...[K]\n[CS:N]Torkoal[CR], the town elder!", french="L'empreinte appartient à...[K]\n[CS:N]Chartor[CR], l'ancien du bourg!", german="Der Fußabdruck gehört...[K] [CS:N]Qurtel[CR],\ndem Dorfältesten!", italian="È la zampa di...[K] [CS:N]Torkoal[CR],\nl'anziano della città!", spanish="La huella es de...[K] ¡[CS:N]Torkoal[CR], el\nanciano de la aldea!"})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="The footprint belongs to\n[CS:N]Torkoal[CR], the town elder!", french="L'empreinte appartient à\n[CS:N]Chartor[CR], l'ancien du bourg!", german="Der Fußabdruck gehört [CS:N]Qurtel[CR],\ndem Dorfältesten!", italian="È la zampa di... [CS:N]Torkoal[CR],\nl'anziano della città!", spanish="La huella es de [CS:N]Torkoal[CR], el\nanciano de la aldea."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? [CS:N]Torkoal[CR] is here?", french=" Hein? [CS:N]Chartor[CR] est ici?", german=" So was! [CS:N]Qurtel[CR] ist hier?", italian=" Eh? [CS:N]Torkoal[CR] è qui?", spanish=" ¿Qué? ¿[CS:N]Torkoal[CR] está aquí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What? [CS:N]Torkoal[CR] is here?", french=" Hein? [CS:N]Chartor[CR] est ici?", german=" Was? [CS:N]Qurtel[CR] ist hier?", italian=" Cosa? [CS:N]Torkoal[CR] è qui?", spanish=" ¿Qué? ¿[CS:N]Torkoal[CR] está aquí?"})
  else
  SkySceneKit.say({english=" What? [CS:N]Torkoal[CR] is here?", french=" Hein? [CS:N]Chartor[CR] est ici?", german=" Was? [CS:N]Qurtel[CR] ist hier?", italian=" Cosa? [CS:N]Torkoal[CR] è qui?", spanish=" ¿Qué? ¿[CS:N]Torkoal[CR] está aquí?"})
  end
  -- message_Close
  GAME:FadeOut(false, 60)
  SkySceneKit.cleanup_npcs()
end
