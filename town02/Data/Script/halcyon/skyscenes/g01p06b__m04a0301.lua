-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P06B/m04a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_NPC_PUKURIN
    local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 368, 232, Direction.Down, "NPC_PUKURIN")
    -- SetAnimation(5) [anim idle native]
    -- GAP: SetEffect EFFECT_APPLE_ON_HEAD — VFX sans émote PMDO équivalente
    SkySceneKit.lock(5) -- Lock(5) NDS
    -- @label_0 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    GROUND:EntTurn(npc_npc_pukurin, Direction.Up)
    GAME:WaitFrames(20)
    GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
    GAME:WaitFrames(20)
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(5123) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 344, 208, Direction.Left, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end) -- message_SetActor(ACTOR_NPC_PERAPPU)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" OK, everyone![K] Dinnertime! ♪", french="A table, tout le monde![K]\nC'est l'heure du dîner! ♪", german=" Okay, Leute![K] Essenszeit! ♪", italian=" Ok, gente![K] È ora di cena! ♪", spanish=" ¡Muy bien![K] ¡Todos a cenar! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: URRÀ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
  -- message_Close
  -- back_SetGround(LEVEL_G01P06B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(192, 212, 60, false) end) -- performer/caméra
  -- SetAnimation(43) [anim idle native]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 320, 232, Direction.Up, "NPC_DIGUDA")
  -- SetAnimation(42) [anim idle native]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 296, 232, Direction.Up, "NPC_DAGUTORIO")
  -- SetAnimation(42) [anim idle native]
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 248, 232, Direction.Up, "NPC_KIMAWARI")
  -- SetAnimation(42) [anim idle native]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 296, 184, Direction.Down, "NPC_HEIGANI")
  -- SetAnimation(42) [anim idle native]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 272, 184, Direction.Down, "NPC_BIPPA")
  -- SetAnimation(42) [anim idle native]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 272, 232, Direction.Up, "NPC_GUREGGURU")
  -- SetAnimation(42) [anim idle native]
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 320, 184, Direction.Down, "NPC_CHIRIIN")
  -- SetAnimation(42) [anim idle native]
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING_SLOW — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING_SLOW — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING_SLOW — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING_SLOW — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  -- SetAnimation(19) [anim idle native]
  -- GAP: BGM BGM_EATING non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- message_ResetActor() [neutre/état moteur]
  SkySceneKit.say({english="Crunch munch! Chomp chomp! Gobble gulp![K]\nCrunch munch! Chomp chomp! Gobble gulp!", french="Cronch cronch! Miam miam! Slurp slurp![K]\nCronch cronch! Miam miam! Slurp slurp!", german="Stopf-schling! Schmatz! Schlabber-schlürf![K]\nStopf-schling! Schmatz! Schlabber-schlürf!", italian="Gnam-gnam! Ingurg-ingurg! Slurp-slurp![K]\nGnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem![K]\n¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  SkySceneKit.say({english="Crunch munch! Chomp chomp! Gobble gulp![K]\nCrunch munch! Chomp chomp! Gobble gulp!", french="Cronch cronch! Miam miam! Slurp slurp![K]\nCronch cronch! Miam miam! Slurp slurp!", german="Stopf-schling! Schmatz! Schlabber-schlürf![K]\nStopf-schling! Schmatz! Schlabber-schlürf!", italian="Crunch-munch! Ingurg ingurg! Snuffle-slurp![K]\nGnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem![K]\n¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  SkySceneKit.say({english="Crunch munch! Chomp chomp! Gobble gulp![K]\nCrunch munch! Chomp chomp! Gobble gulp!", french="Cronch cronch! Miam miam! Slurp slurp![K]\nCronch cronch! Miam miam! Slurp slurp!", german="Stopf-schling! Schmatz! Schlabber-schlürf![K]\nStopf-schling! Schmatz! Schlabber-schlürf!", italian="Crunch-munch! Ingurg ingurg! Snuffle-slurp![K]\nGnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem![K]\n¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  SkySceneKit.say({english="Crunch munch! Chomp chomp! Gobble gulp![K]\nCrunch munch! Chomp chomp! Gobble gulp!", french="Cronch cronch! Miam miam! Slurp slurp![K]\nCronch cronch! Miam miam! Slurp slurp!", german="Stopf-schling! Schmatz! Schlabber-schlürf![K]\nStopf-schling! Schmatz! Schlabber-schlürf!", italian="Crunch-munch! Ingurg ingurg! Snuffle-slurp![K]\nGnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem![K]\n¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  -- message_CloseEnforce
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 168, 208, Direction.Right, "NPC_DOGOOMU")
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  -- SetAnimation(9) [anim idle native]
  -- message_FacePositionOffset(-2, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Uggggh...", french=" Aaaarf...", german=" Uggggh...", italian=" Uggggh...", spanish=" Aaayy..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'm...starving...", french=" Je... meurs de faim...", german=" Ich habe... Hunger...", italian=" Sto... morendo di fame...", spanish=" ¡Qué hambre!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So very...hungry...", french=" Je... meurs de faim...", german=" Ich habe... so Hunger...", italian=" Non ci vedo dalla fame...", spanish=" ¡Me muero de hambre!"})
  else
  SkySceneKit.say({english=" So hungry...", french=" Je... meurs de faim...", german=" So hungrig...", italian=" Sono... affamata...", spanish=" ¡Qué hambre!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Grrr...", french=" Grrr...", german=" Grrr...", italian=" Grrr...", spanish=" Grrr..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_dogoomu, 4) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_dogoomu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Come on, quit giving me the eye!", french="C'est bon, arrête de me\nregarder comme ça!", german="Komm schon, sieh mich nicht so\nan!", italian=" Dai, non guardarmi così!", spanish=" ¡No me mires con esa cara!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Don't glare at me like that...", french="C'est bon, arrête de me\nregarder comme ça!", german=" Sieh mich nicht so an.", italian="Dai, smettila di guardarmi\nin quel modo!", spanish=" ¡No me mires así!"})
  else
  SkySceneKit.say({english=" Please don't glare at me...", french="C'est bon, arrête de me\nregarder comme ça!", german=" Bitte sieh mich nicht so an.", italian=" Dai, smettila di guardarmi così!", spanish=" ¡No me mires de esa forma!"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(30)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" I'm stuffed! That was delicious!", french=" J'ai bien mangé! C'était délicieux!", german=" Bin ich satt! Das war köstlich!", italian=" Sono satollo! Che delizia!", spanish=" ¡Menudo atracón! ¡Qué rico estaba!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Oof... I'm so full and sleepy!", french="Ouf... Je suis calé! J'ai sommeil,\nmaintenant!", german=" Uuf... Ich bin so satt, ich könnte schlafen!", italian=" Uff... Tutto quel cibo mi ha messo sonno!", spanish="¡Uf! ¡Cómo me he puesto! Y encima\nahora me está entrando una modorra..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" We're all off to bed, then. Good night!", french=" On va tous se coucher, bonne nuit!", german=" Wir gehen dann mal ins Bett. Gute Nacht!", italian=" Allora, tutti a letto. Buonanotte!", spanish=" Ya hay que irse a la cama. ¡Buenas noches!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Good night!", french=" Bonne nuit!", german=" Gute Nacht!", italian=" Buonanotte!", spanish=" ¡Buenas noches!"})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
