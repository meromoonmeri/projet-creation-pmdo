-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D57P42A/n04a1402.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D57P42A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(1) [anim idle native]
  pcall(function() GAME:MoveCamera(284, 268, 1, false) end) -- SetPositionMark performer/caméra
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 264, 272, Direction.Left, "NPC_DOGOOMU")
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Right)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" A-are you ALL RIGHT, [CS:Y]Sunflora[CR]?", french=" Tout va BIEN, [CS:Y]Héliatronc[CR]?", german=" G-geht ES dir GUT, [CS:Y]Sonnflora[CR]?", italian=" T-Tutto BENE, [CS:Y]Sunflora[CR]?", spanish=" ¿Es... estás bien, [CS:Y]Sunflora[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Y-yeah... (Y-you saved me...)", french="Heu oui... (T-tu viens\nde me sauver...)", german="J-ja...\n(D-du hast mich gerettet...)", italian=" S-Sì... (M-Mi hai salvata...)", spanish=" Esto... sí... (Me ha salvado...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" I-is that SO?[K] GOOD.", french=" C'est VRAI?[K] PARFAIT.", german=" W-wirklich?[K] GUT.", italian=" D-DAVVERO?[K] BENE.", spanish=" ¿De verdad?[K] Menos mal."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Anyway...[K] It's not LIKE you to\nFALL BEHIND those guys like THAT.", french="C'est drôle...[K] ÇA ne te\nressemble PAS de te laisser IMPORTUNER\ncomme ÇA.", german="Komisch...[K] SIEHT dir GAR nicht\nÄHNLICH, mit DENEN so viel ÄRGER zu haben.", italian="Però...[K] Non è da TE farti\nMETTERE SOTTO da SIMILI tipi.", spanish="En fin...[K] No es propio de ti\ndejarte atosigar por tipos así."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Then AGAIN, you DID just\ntake a LOT of DAMAGE.", french="Et POURTANT, tu as PRIS un\nPAQUET de DEGATS.", german="ABER du HAST ganz schön\netwas ABBEKOMMEN.", italian=" EPPURE, hai subito MOLTI DANNI.", spanish="Pero bueno, la verdad es que\nhas recibido un montón de daño."})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="On THAT note, I just GOT here,\nso I'm doing FINE![K] Ha ha ha!", french="Mais MOI, je viens d'arriver\nalors je vais BIEN![K] Ha ha ha!", german="DAHER ist es wohl GUT, dass ich\nhier RECHTZEITIG aufgetaucht bin![K] Das FREUT\nmich! Hahaha!", italian="A proposito, io SONO appena\narrivato QUI, quindi sto BENE![K] Ah ah ah!", spanish="Por cierto, yo acabo de llegar,\nasí que estoy como una rosa.[K] ¡Ja, ja, ja!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  GAME:WaitFrames(15)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  GAME:FadeOut(true, 60) -- screen_WhiteOut
  GAME:WaitFrames(30)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
