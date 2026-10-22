-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P05A/n04a1002.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V34P01A) [décor sub chargé: Sub_v34p01a]
  -- back_SetGround(LEVEL_G01P05A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 16.5, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  GROUND:TeleportTo(hero, 196, 236, Direction.Down)
  GROUND:EntTurn(hero, Direction.UpLeft)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 248, 224, Direction.DownLeft, "NPC_PERAPPU")
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  local npc_npc_jibakoiru = SkySceneKit.spawn_npc("magnezone", 168, 224, Direction.DownRight, "NPC_JIBAKOIRU")
  -- SetAnimation(25) [anim idle native]
  -- screen2_FlushOut [sub déjà caché]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  SkySubScreen.Show("v34p01a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="His alias is the Invincible\n[CS:N]Haunter[CR].", french="On le surnomme\n\"[CS:N]Spectrum[CR] l'Invincible\".", german="Er ist auch bekannt als\n[F:S2]Der unbesiegbare [CS:N]Alpollo[CR][F:E2].", italian="È anche conosciuto come\nl'invincibile [CS:N]Haunter[CR].", spanish=" Se apoda \\\"[CS:N]Haunter[CR], el Invencible\\\"."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I-invincible?", french=" L'In... l'Invincible?", german=" U-unbesiegbar?", italian=" I-Invincibile?", spanish=" ¿In... Invencible?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english=" ZZZT! That's right. ZZZT!", french=" ZZZT! Précisément. ZZZT!", german=" ZZZT! Stimmt genau. ZZZT!", italian=" ZZZT! Esatto. ZZZT!", spanish=" ¡Bzz! Exacto. ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! It doesn't matter how\nmany times you knock him out, he always\ngets right back up, good as new. ZZZT!", french="ZZZT! On a beau le mettre K.O.,\nil finit toujours par se relever sans la\nmoindre égratignure. ZZZT!", german="ZZZT! Egal, wie oft man ihn K.O.\ngehen lässt, er taucht immer wieder auf,\nals wäre nichts geschehen. ZZZT!", italian="ZZZT! Per quante volte finisca\nKO, sembra che riesca sempre a rimettersi\nin piedi, come se niente fosse. ZZZT!", spanish="¡Bzz! No importa cuántas veces\nlo dejes fuera de combate... Siempre se pone\nen pie, fresco como una rosa. ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! He must be invincible,\nthat [CS:N]Haunter[CR]! ZZZT!", french="ZZZT! Il est invincible,\nce [CS:N]Spectrum[CR], précisément! ZZZT!", german="ZZZT! Dieser [CS:N]Alpollo[CR] scheint\nwirklich unbesiegbar! ZZZT!", italian="ZZZT! È proprio invincibile,\nquell'[CS:N]Haunter[CR]! ZZZT!", spanish="¡Bzz! ¡Así que ese [CS:N]Haunter[CR]\ntiene que ser invencible! ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! That's why we haven't\nbeen able to catch him! ZZZT!", french="ZZZT! C'est ce qui explique\nnotre difficulté à l'attraper! ZZZT!", german="ZZZT! Deswegen konnten wir ihn\nbisher noch nicht dingfest machen! ZZZT!", italian="ZZZT! È questo il motivo per cui\nnon siamo ancora riusciti a catturarlo! ZZZT!", spanish="¡Bzz! Por eso no hemos podido\ncapturarlo. ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="... (An invincible Pokémon...[K]\n[CS:N]Haunter[CR]...)", french="... (Un Pokémon invincible du\nnom de... [K][CS:N]Spectrum[CR]...)", german="...(Ein unbesiegbares Pokémon...[K]\n[CS:N]Alpollo[CR]...)", italian="... (Un Pokémon invincibile...[K]\n[CS:N]Haunter[CR]...)", spanish="Uf... (Un Pokémon invencible...[K]\n[CS:N]Haunter[CR]...)"})
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Show("v34p01a", 0, false) -- screen2_FlushIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
