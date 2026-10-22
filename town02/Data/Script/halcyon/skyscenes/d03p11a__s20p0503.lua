-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D03P11A/s20p0503.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D03P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_jibakoiru = SkySceneKit.spawn_npc("magnezone", 280, 216, Direction.Down, "NPC_JIBAKOIRU")
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="We have been able to arrest a\nwanted outlaw! ZZZT!", french="Nous avons pu arrêter un\ncriminel recherché! ZZZT!", german="Dank euch konnten wir einen\ngesuchten Verbrecher fassen! ZZZT!", italian="Siamo riusciti ad arrestare un\nricercato! ZZZT!", spanish="¡Hemos podido arrestar\na un peligroso malhechor! ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! We owe you great thanks\nfor your cooperation! ZZZT!", french="ZZZT! Merci beaucoup de votre\ncoopération! ZZZT!", german="ZZZT! Wir sind euch für eure\nMitarbeit zu großem Dank verpflichtet! ZZZT!", italian="ZZZT! Grazie mille per la vostra\ncollaborazione! ZZZT!", spanish="¡Bzz! ¡Estamos muy agradecidos\npor vuestra colaboración! ¡Bzz!"})
  -- message_Close
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_jibakoiru, "happy", 1) end)
  local npc_npc_koiru = SkySceneKit.spawn_npc("magnemite", 296, 192, Direction.Down, "NPC_KOIRU")
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru, "happy", 1) end)
  local npc_npc_koiru2 = SkySceneKit.spawn_npc("magnemite", 264, 192, Direction.Down, "NPC_KOIRU2")
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru2, "happy", 1) end)
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_jibakoiru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru2, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! We will send the reward\nto your guild. Thank you again! ZZZT!", french="ZZZT! Nous remettrons la\nrécompense à votre Guilde. Merci\nencore! ZZZT!", german="ZZZT! Wir lassen die Belohnung\neurer Gilde zukommen. Nochmals danke! ZZZT!", italian="ZZZT! Manderemo la ricompensa\nalla Gilda. Grazie ancora! ZZZT!", spanish="¡Bzz! Enviaremos la recompensa\na vuestro [CS:N]Pokégremio[CR].\n¡Muchísimas gracias por todo! ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_suriipu = SkySceneKit.spawn_npc("drowzee", 280, 192, Direction.Down, "NPC_SURIIPU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_jibakoiru, npc_npc_suriipu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english=" ZZZT! Now come with us! ZZZT!", french=" ZZZT! Viens avec nous! ZZZT!", german=" ZZZT! Jetzt komm mit! ZZZT!", italian="ZZZT! Adesso vieni\ncon noi! ZZZT!", spanish="¡Bzz! Ahora, ¡ven con nosotros!\n¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_suriipu, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Awww...", french=" Aïe...", german=" Grmpf...", italian=" Awww...", spanish=" ¡Ay!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_jibakoiru.Position; GROUND:MoveToPosition(npc_npc_jibakoiru, p.X+(200), p.Y+(0), false, 2) end
  GAME:WaitFrames(15)
  -- ResetHitAttribute(31) [neutre/état moteur]
  -- ResetHitAttribute(31) [neutre/état moteur]
  -- ResetHitAttribute(31) [neutre/état moteur]
  GROUND:EntTurn(partner, Direction.UpRight)
  local npc_npc_ruriri = SkySceneKit.spawn_npc("azurill", 280, 256, Direction.Up, "NPC_RURIRI")
  GROUND:EntTurn(npc_npc_ruriri, Direction.UpRight)
  GROUND:EntTurn(npc_npc_koiru, Direction.Right)
  do local p=npc_npc_suriipu.Position; GROUND:MoveToPosition(npc_npc_suriipu, p.X+(16), p.Y+(16), false, 2) end
  do local p=npc_npc_koiru2.Position; GROUND:MoveToPosition(npc_npc_koiru2, p.X+(32), p.Y+(32), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(npc_npc_suriipu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(npc_npc_ruriri, Direction.Right)
  do local p=npc_npc_koiru.Position; GROUND:MoveToPosition(npc_npc_koiru, p.X+(200), p.Y+(0), false, 2) end
  do local p=npc_npc_suriipu.Position; GROUND:MoveToPosition(npc_npc_suriipu, p.X+(200), p.Y+(0), false, 2) end
  do local p=npc_npc_koiru2.Position; GROUND:MoveToPosition(npc_npc_koiru2, p.X+(200), p.Y+(0), false, 2) end
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
