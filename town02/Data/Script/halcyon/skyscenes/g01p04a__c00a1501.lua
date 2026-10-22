-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/c00a1501.ssb (ROM sha256 1fa39d35…).
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
  SkySceneKit.say({english="Ah, you two! ♪[K] Let me give you\nyour assignment for today...", french="Ah, vous voilà, vous deux! ♪[K]\nVoyons voir ce que je vais vous confier\naujourd'hui...", german="Ah, ihr zwei! ♪[K] Lasst mich\neuch eure Aufgabe für heute mitteilen.", italian="Ah, voi due! ♪[K] Ecco gli\nincarichi per oggi...", spanish="¡Eh, pareja! ♪[K] Os voy a dar\nvuestro encargo para hoy..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Look up jobs on the Job Bulletin\nBoard and the Outlaw Notice Board.", french="Consultez les missions du\nTableau des Missions et des Avis\nde Recherche.", german="Seht nach Jobs auf dem\nJob-Infobrett und dem Ganoven-Infobrett.", italian="Guardate le missioni sulla\nBacheca dei ricercati e sulla Bacheca\ndelle missioni.", spanish="Hoy os toca cumplir misiones del\nTablón de Anuncios y del Tablón \"Se Busca\"."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Do the listed jobs. That will do\nfor today! ♪", french="Occupez-vous des missions\naffichées. Ce sera tout pour aujourd'hui! ♪", german="Erledigt die aufgelisteten Jobs.\nDas wird für heute reichen! ♪", italian="Oggi dovete dedicarvi alle\nmissioni in Bacheca! ♪", spanish="¡Haced las misiones! Con eso\nbastará por hoy. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Understood? No shirking your\nwork, OK?", french="Compris? Et on ne tire pas au\nflanc!", german="Verstanden? Nicht dem Plagen\nentsagen, okay?", italian="Capito? Non voglio perdigiorno\nqui, va bene?", spanish="Lo habéis entendido, ¿no? ¡Pues,\nvenga! ¡Y que no se os ocurra holgazanear!"})
  -- message_Close
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Well? If you understand, get\non with it!", french="Eh bien? Si vous avez compris,\nmettez-vous au travail!", german="Nun? Wenn ihr verstanden habt,\ndann auf ans Werk!", italian="Tutto chiaro? Se avete capito,\nal lavoro!", spanish="¿Qué pasa? Está todo claro,\n¿no? ¡A trabajar!"})
  -- message_Close
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.cleanup_npcs()
end
