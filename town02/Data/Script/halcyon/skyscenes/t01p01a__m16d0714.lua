-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/m16d0714.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_T01P01A) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_s_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 352, 152, Direction.Down, "NPC_S_YONOWAARU")
  -- SetAnimation(27) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 352, 192, Direction.Down, "NPC_YONOWAARU")
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" It's too soon for farewells!", french="Il est encore trop tôt pour\nnous dire adieu!", german="Es ist noch zu früh, um sich\nzu verabschieden!", italian=" È troppo presto per gli addii!", spanish=" ¡Es muy pronto para despedidas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(28) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waah!", french=" Ouaaah!", german=" Waah!", italian=" Aargh!!!", spanish=" ¡Aaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah!", french=" Ouaaah!", german=" Waah!", italian=" Aaah!", spanish=" ¡Aaah!"})
  else
  SkySceneKit.say({english=" Waah!", french=" Ouaaah!", german=" Waah!", italian=" Aaah!", spanish=" ¡Aaah!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_ringuma = SkySceneKit.spawn_npc("ursaring", 272, 240, Direction.UpRight, "NPC_RINGUMA")
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "exclaim", 1) end)
  local npc_npc_s_diguda = SkySceneKit.spawn_npc("diglett", 440, 216, Direction.UpLeft, "NPC_S_DIGUDA")
  pcall(function() GROUND:CharSetEmote(npc_npc_s_diguda, "shock", 1) end)
  local npc_npc_s_perappu = SkySceneKit.spawn_npc("chatot", 392, 200, Direction.UpLeft, "NPC_S_PERAPPU")
  pcall(function() GROUND:CharSetEmote(npc_npc_s_perappu, "exclaim", 1) end)
  local npc_npc_s_bippa = SkySceneKit.spawn_npc("bidoof", 408, 176, Direction.Left, "NPC_S_BIPPA")
  pcall(function() GROUND:CharSetEmote(npc_npc_s_bippa, "shock", 1) end)
  local npc_npc_s_dogoomu = SkySceneKit.spawn_npc("loudred", 320, 200, Direction.UpRight, "NPC_S_DOGOOMU")
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dogoomu, "shock", 1) end)
  local npc_npc_s_dagutorio = SkySceneKit.spawn_npc("dugtrio", 408, 240, Direction.UpLeft, "NPC_S_DAGUTORIO")
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dagutorio, "exclaim", 1) end)
  local npc_npc_jibakoiru = SkySceneKit.spawn_npc("magnezone", 264, 200, Direction.UpRight, "NPC_JIBAKOIRU")
  pcall(function() GROUND:CharSetEmote(npc_npc_jibakoiru, "exclaim", 1) end)
  local npc_npc_himeguma = SkySceneKit.spawn_npc("teddiursa", 336, 240, Direction.Up, "NPC_HIMEGUMA")
  pcall(function() GROUND:CharSetEmote(npc_npc_himeguma, "shock", 1) end)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 448, 184, Direction.Left, "NPC_GUREGGURU")
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" You two...[K]are coming with me!", french="Vous deux...[K] vous venez avec\nmoi!", german=" Ihr zwei...[K] kommt mit mir!", italian=" Voi due...[K] venite con me!", spanish=" Porque...[K] ¡os venís conmigo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(50) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-16), false, 2) end -- SlidePositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_s_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_s_yonowaaru, p.X+(0), p.Y+(-24), false, 1) end -- SlidePositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-24), false, 1) end -- SlidePositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-24), false, 1) end -- SlidePositionOffset
  pcall(function() SOUND:FadeOutBGM(60) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Waaah!", italian=" Aaaah!", spanish=" ¡Aaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Waaah!", italian=" Aaaah!", spanish=" ¡Aaah!"})
  else
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Waaah!", italian=" Aaaah!", spanish=" ¡Aaah!"})
  end
  GAME:WaitFrames(45)
  -- message_CloseEnforce
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_diguda, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_perappu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_bippa, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dogoomu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_s_dagutorio, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_jibakoiru, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_himeguma, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 640, 216, Direction.Right, "NPC_BIPPA")
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" By gosh!", french=" Sapristi!", german=" Meine Güte!", italian=" Ohibò!", spanish=" ¡Córcholis!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 336, 248, Direction.Up, "NPC_CHIRIIN")
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" [partner]! [hero]!", french=" [partner]! [hero]!", german=" [partner]! [hero]!", italian=" [partner]! [hero]!", spanish=" ¡[partner]! ¡[hero]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_s_diguda.Position; GROUND:MoveToPosition(npc_npc_s_diguda, p.X+(-8), p.Y+(-12), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_guregguru.Position; GROUND:MoveToPosition(npc_npc_guregguru, p.X+(-12), p.Y+(-8), false, 2) end -- Move2PositionOffset
  local npc_npc_s_chiriin = SkySceneKit.spawn_npc("chimecho", 424, 200, Direction.Left, "NPC_S_CHIRIIN")
  do local p=npc_npc_s_chiriin.Position; GROUND:MoveToPosition(npc_npc_s_chiriin, p.X+(-12), p.Y+(-12), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_s_bippa.Position; GROUND:MoveToPosition(npc_npc_s_bippa, p.X+(-12), p.Y+(-8), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_s_dagutorio.Position; GROUND:MoveToPosition(npc_npc_s_dagutorio, p.X+(0), p.Y+(-12), false, 2) end -- Move2PositionOffset
  local npc_npc_s_pukurin = SkySceneKit.spawn_npc("wigglytuff", 416, 216, Direction.UpLeft, "NPC_S_PUKURIN")
  do local p=npc_npc_s_pukurin.Position; GROUND:MoveToPosition(npc_npc_s_pukurin, p.X+(-8), p.Y+(-12), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_s_perappu.Position; GROUND:MoveToPosition(npc_npc_s_perappu, p.X+(-8), p.Y+(-12), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  local npc_npc_s_heigani = SkySceneKit.spawn_npc("corphish", 384, 232, Direction.Up, "NPC_S_HEIGANI")
  do local p=npc_npc_s_heigani.Position; GROUND:MoveToPosition(npc_npc_s_heigani, p.X+(0), p.Y+(-20), false, 2) end -- Move2PositionOffset
  local npc_npc_kakureon1 = SkySceneKit.spawn_npc("kecleon", 360, 240, Direction.Up, "NPC_KAKUREON1")
  do local p=npc_npc_kakureon1.Position; GROUND:MoveToPosition(npc_npc_kakureon1, p.X+(0), p.Y+(-16), false, 2) end -- Move2PositionOffset
  local npc_npc_s_kimawari = SkySceneKit.spawn_npc("sunflora", 296, 200, Direction.UpRight, "NPC_S_KIMAWARI")
  do local p=npc_npc_s_kimawari.Position; GROUND:MoveToPosition(npc_npc_s_kimawari, p.X+(8), p.Y+(-12), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_s_dogoomu.Position; GROUND:MoveToPosition(npc_npc_s_dogoomu, p.X+(12), p.Y+(-16), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_himeguma.Position; GROUND:MoveToPosition(npc_npc_himeguma, p.X+(0), p.Y+(-12), false, 2) end -- Move2PositionOffset
  local npc_npc_s_yukushii = SkySceneKit.spawn_npc("uxie", 304, 224, Direction.UpRight, "NPC_S_YUKUSHII")
  do local p=npc_npc_s_yukushii.Position; GROUND:MoveToPosition(npc_npc_s_yukushii, p.X+(8), p.Y+(-12), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  local npc_npc_s_emuritto = SkySceneKit.spawn_npc("mesprit", 288, 224, Direction.UpRight, "NPC_S_EMURITTO")
  do local p=npc_npc_s_emuritto.Position; GROUND:MoveToPosition(npc_npc_s_emuritto, p.X+(8), p.Y+(-12), false, 2) end -- Move2PositionOffset
  local npc_npc_s_agunomu = SkySceneKit.spawn_npc("azelf", 328, 232, Direction.Up, "NPC_S_AGUNOMU")
  do local p=npc_npc_s_agunomu.Position; GROUND:MoveToPosition(npc_npc_s_agunomu, p.X+(8), p.Y+(-12), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_ringuma.Position; GROUND:MoveToPosition(npc_npc_ringuma, p.X+(12), p.Y+(-12), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_jibakoiru.Position; GROUND:MoveToPosition(npc_npc_jibakoiru, p.X+(12), p.Y+(-12), false, 2) end -- Move2PositionOffset
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_T01P01A5_194) [routine d'objet NDS non simulée - documenté]
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_kakureon1) end)
  SkySceneKit.say({english=" Wh-what was...", french=" Qu'est-ce que...", german=" W-was war...", italian=" C-Cosa...", spanish=" ¿Pero... qué...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 376, 248, Direction.Up, "NPC_KIMAWARI")
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" What just happened...?", french=" Qu'est-ce qui s'est passé...?", german=" Was ist gerade passiert?", italian=" Cos'è successo...?", spanish=" ¿Qué acaba de suceder...?"})
  -- message_Close
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
