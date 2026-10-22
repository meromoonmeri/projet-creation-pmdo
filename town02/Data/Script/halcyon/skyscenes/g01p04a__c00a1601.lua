-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/c00a1601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Ah, you two! ♪[K] Let me give you\nyour assignment for today...", french="Ah, vous voilà, vous deux! ♪[K]\nVoyons voir ce que je vais vous confier\naujourd'hui...", german="Ah, ihr zwei! ♪[K] Lasst mich euch\neure Aufgabe für heute mitteilen.", italian="Ah, voi due! ♪[K] Ecco gli\nincarichi per oggi...", spanish="¡Eh, pareja! ♪[K] Os voy a dar\nvuestro encargo para hoy..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Sentry duty! That's what we'll\nhave you do today.", french="Monter la garde! Voilà ce que\nvous allez faire aujourd'hui.", german="Wachdienst! Dafür werdet ihr\nheute eingeteilt.", italian="Turno di guardia! Oggi vi\noccuperete di questo.", spanish=" ¡Hoy os toca guardia! ¡Eso es!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" I'll leave you to it! ♪", french=" Je vous laisse faire! ♪", german="Ich überlasse euch das dann\nmal! ♪", italian=" Vi lascio al vostro lavoro! ♪", spanish=" Bueno, ¡aquí os dejo! ♪"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
