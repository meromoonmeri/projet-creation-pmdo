-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D56P11A/n06a2601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D56P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 88, 80, Direction.DownRight, "NPC_CHAAREMU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 120, 112, Direction.DownRight, "NPC_SAANAITO")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_ILLUSION_STONE_CHAMBER non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_saanaito, 220, 212, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(hero, 204, 196, false, 2)
  GAME:WaitFrames(9)
  GROUND:MoveToPosition(npc_npc_chaaremu, 220, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(9)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" The beginning...", french=" De retour au point de départ...", german=" Wieder am Ausgangspunkt...", italian="Siamo di nuovo al punto\ndi partenza...", spanish=" Otra vez en el punto de partida..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" We're right back here again...", french=" Encore et toujours cet endroit...", german="Wir sind schon wieder hier\nherausgekommen...", italian=" Siamo tornate di nuovo qui...", spanish=" Volvemos a estar aquí..."})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "angry", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" ...What did you expect?", french=" ... A quoi vous attendiez-vous?", german=" ...Was habt ihr denn erwartet?", italian=" Che ti aspettavi?", spanish=" ¿Qué esperabas...?"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="We went in the same entrance\nas before!", french=" C'est un vrai labyrinthe!", german="Das Ganze hier ist ja auch ein\nriesiger Irrgarten!", italian="Questo posto è un enorme\nlabirinto!", spanish="¡Si hemos ido por el mismo\ncamino que antes!"})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="[CS:Y]Lopunny[CR]![K]\nAren't you going to try the other entrance?", french="[CS:Y]Lockpin[CR]![K]\nTu crois qu'on va réussir à traverser?", german="[CS:Y]Schlapor[CR]![K] Sollten wir nicht\nvielleicht eine andere Route versuchen?", italian="[CS:Y]Lopunny[CR]![K]\nSei sicura che ce la possiamo fare?", spanish="¡[CS:Y]Lopunny[CR]![K]\n¿No piensas probar por la otra entrada?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Huh?[K] That was interesting.", french=" Hein?[K] Intéressant.", german=" Hmmm...[K] Das war interessant.", italian=" Uh?[K] Non è interessante?", spanish=" ¿Eh?[K] Interesante..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I seem to be a\nbit confused. [M:H8]", french=" Je me sens un peu perdue. [M:H8]", german="Ich bin wohl ein\nwenig verwirrt. [M:H8]", italian="Sembra che mi sia confusa\nun po'. [M:H8]", spanish="Creo que estoy un poco\nconfusa. [M:H8]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" This isn't interesting at all!", french=" Ça n'a rien d'intéressant!", german="Das ist überhaupt\nnicht interessant!", italian=" Non è per nulla interessante!", spanish="¡A mí no me parece\nnada interesante!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="This time, select a different\nentrance already! Gee whiz!", french="Prenons une autre entrée! Allez,\nen piste!", german="Lass uns dieses Mal auf jeden\nFall einen anderen Weg nehmen! Du\nOrientierungskünstler!", italian="Questa volta scegliamo un altro\npercorso! Forza!", spanish="¡Más te vale que esta vez elijas\notra entrada! ¡Jo, es que ya te vale!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ResetOutputAttribute(2) [neutre/état moteur]
  -- ResetOutputAttribute(2) [neutre/état moteur]
  -- ResetOutputAttribute(2) [neutre/état moteur]
  SkySceneKit.cleanup_npcs()
end
