-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99A/n01a0707.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_AIR_OF_UNEASE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_H01P99A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  local npc_npc_yukikaburi = SkySceneKit.spawn_npc("snover", 416, 176, Direction.Left, "NPC_YUKIKABURI")
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(-16), p.Y+(16), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yukikaburi, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukikaburi, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_tatsubei = SkySceneKit.spawn_npc("bagon", 496, 176, Direction.Left, "NPC_TATSUBEI")
  GROUND:MoveToPosition(npc_npc_tatsubei, 336, 172, false, 2)
  GROUND:MoveToPosition(npc_npc_yukikaburi, 336, 188, false, 2)
  GAME:WaitFrames(15)
  local npc_npc_guraigaa = SkySceneKit.spawn_npc("gligar", 496, 192, Direction.Left, "NPC_GURAIGAA")
  GROUND:MoveToPosition(npc_npc_guraigaa, 368, 188, false, 2)
  GROUND:EntTurn(npc_npc_tatsubei, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukikaburi, "sweating", 1) end)
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_tatsubei) end)
  SkySceneKit.say({english=" Ha![K] Finally caught you!", french=" Ah, ah![K] Fini de courir, mon gars!", german=" Ha![K] Endlich haben wir dich!", italian="Ah![K] Finalmente ti abbiamo\ncatturato!", spanish=" ¡Ja![K] ¡Ya eres nuestro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_guraigaa) end)
  SkySceneKit.say({english="You really ran for it!\nGwah ha ha!", french="Tu cours plus vite que ma\ngrand-mère, ma parole!\nOuarf arf arf!", german="Hast dich ganz schön beeilt!\nGwahaha!", italian="Ci hai fatto fare una bella\nsudata! Muah ah ah!", spanish="¡Y eso que corrías como loco!\n¡Jua, ja, ja!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukikaburi, "sweating", 1) end)
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" Ow-ow![K] Let go of me!", french=" Aïe! Ouille![K] Laissez-moi partir!", german=" Au-au![K] Lasst mich in Ruhe!", italian=" Ahi-ahi![K] Lasciatemi andare!", spanish=" ¡Ay, ay![K] ¡Dejadme!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_yukikaburi, "sweating", 1) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yukikaburi, npc_npc_tatsubei, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_tatsubei) end)
  SkySceneKit.say({english="Nope.[K] You know what we're\nlooking for...", french="Négatif.[K]\nTu sais ce qu'on cherche...", german="Vergiss es.[K] Du weißt, wonach\nwir suchen...", italian="No![K] Lo sai cosa stiamo\ncercando...", spanish="Ni hablar.[K] Ya sabes qué es\nlo que queremos..."})
  pcall(function() UI:SetSpeaker(npc_npc_tatsubei) end)
  SkySceneKit.say({english=" You of all people should know!", french="S'il y en a un qui doit le savoir,\nc'est bien toi!", german=" Gerade du solltest das wissen!", italian=" Dovresti saperlo bene!", spanish=" ¡Precisamente tú deberías saberlo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_guraigaa.Position; GROUND:MoveToPosition(npc_npc_guraigaa, p.X+(-8), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guraigaa, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_guraigaa) end)
  SkySceneKit.say({english=" Not here![K] The map's not here!", french=" La carte![K] Je la trouve pas!", german="Nicht hier![K] Die Karte ist\nnicht hier!", italian=" Non è qui![K] La mappa non è qui!", spanish=" ¡No está aquí![K] ¡El mapa no está aquí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_guraigaa, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_guraigaa) end)
  SkySceneKit.say({english=" [CS:N]Bagon[CR]![K] He doesn't have the map!", french=" [CS:N]Draby[CR]![K] Il a pas la carte!", german="[CS:N]Kindwurm[CR]![K] Er hat die Karte\nnicht!", italian=" [CS:N]Bagon[CR]![K] Non ha la mappa!", spanish=" ¡[CS:N]Bagon[CR]![K] ¡Que no tiene el mapa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_tatsubei, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_tatsubei, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_tatsubei) end)
  SkySceneKit.say({english=" WHAAAAT?!", french=" QUOIIIII?!", german=" WAAAAS?!?", italian=" COOOSAAA?!", spanish=" ¡¿Quéeee?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_tatsubei, npc_npc_yukikaburi, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guraigaa, npc_npc_yukikaburi, 4) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukikaburi, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_tatsubei) end)
  SkySceneKit.say({english=" Y-YOU![K] Where'd you stash it?!", french="M-misérable![K]\nOù l'as-tu planquée?!", german="D-du![K] Wo hast du sie\nversteckt?!?", italian=" T-TU![K] Dove l'hai nascosta?!", spanish=" ¡Oye![K] ¡¿Dónde lo has escondido?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(3) [anim idle native]
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(1)
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" I...[K] I don't know...", french=" Je...[K] je ne me souviens pas...", german=" Ich...[K] Ich weiß nicht...", italian=" Io...[K] non lo so...", spanish=" No...[K] No lo sé..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guraigaa, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_guraigaa) end)
  SkySceneKit.say({english=" LIAR!", french=" MENTEUR!", german=" LÜGNER!", italian=" NON MENTIRE!", spanish=" ¡Mentira!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_guraigaa, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_yukikaburi, Direction.Left)
  -- SetAnimation(22) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_yukikaburi, "shock", 1) end)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(-40), p.Y+(0), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(npc_npc_tatsubei, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" OUCH!", french=" AOUAH!", german=" AUTSCH!", italian=" AHIA!", spanish=" ¡Ay!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yukikaburi.Position; GROUND:MoveToPosition(npc_npc_yukikaburi, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" Ooooh...[K] No matter what...", french=" Ouuuuuh...[K] Je m'en fiche...", german=" Ooooh...[K] Egal, was ihr...", italian=" Oooh...[K] Non importa...", spanish=" Aaaaay...[K] Qué dolooor..."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="No matter what you do...[K] I'm not\ntelling you.", french="Tapez-moi, si ça vous chante...[K]\nMais je ne vous dirai rien!", german="Egal, was ihr auch macht...[K]\nIch werde euch nichts verraten.", italian="Non importa cosa mi farete...[K]\nNon ve lo dirò mai.", spanish="Da igual lo que hagáis...[K] No os lo\npienso decir."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_tatsubei) end)
  SkySceneKit.say({english=" ARGH!", french=" Malédiction!", german=" ARGH!", italian=" ARGH!", spanish=" ¡Córcholis!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_tatsubei, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_guraigaa, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_tatsubei) end)
  SkySceneKit.say({english="He has to have stashed it around\nhere somewhere![K] Look for it!", french="Il a dû la planquer quelque part\npar ici![K] Cherche-la!", german="Er muss sie hier irgendwo\nversteckt haben![K] Suchen wir sie!", italian="Deve averla nascosta qui\nda qualche parte![K] Cerchiamola!", spanish="¡Tiene que haberlo escondido\nen alguna parte![K] ¡Busca!"})
  -- message_Close
  do local p=npc_npc_guraigaa.Position; GROUND:MoveToPosition(npc_npc_guraigaa, p.X+(36), p.Y+(-24), false, 2) end
  GAME:WaitFrames(15)
  do local p=npc_npc_tatsubei.Position; GROUND:MoveToPosition(npc_npc_tatsubei, p.X+(-16), p.Y+(-16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_guraigaa.Position; GROUND:MoveToPosition(npc_npc_guraigaa, p.X+(0), p.Y+(-16), false, 2) end
  GAME:WaitFrames(15)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_tatsubei.Position; GROUND:MoveToPosition(npc_npc_tatsubei, p.X+(0), p.Y+(16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
