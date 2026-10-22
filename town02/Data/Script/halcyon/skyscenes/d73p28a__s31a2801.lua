-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P28A/s31a2801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 26) -- $SCENARIO_MAIN = scn[29,26] (ROM)
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 232, 416, Direction.Up, "NPC_SHEIMI")
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" The 8th Station Clearing! Hurry!", french="Direction la trouée\ndu 8[F:E] Relais! Vite!", german="Die 8. Zwischenlagerlichtung!\nBeeilung!", italian=" Ecco il Bivacco 8! Presto!", spanish="¡La Base del Octavo Puerto!\n¡Deprisa!"})
  -- message_Close
  -- back_SetGround(LEVEL_D73P28A) [neutre/état moteur]
  -- supervision_StationCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_denryuu = SkySceneKit.spawn_npc("ampharos", 192, 232, Direction.Left, "NPC_DENRYUU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(npc_npc_denryuu, 160, 228, false, 1)
  -- GAP: BGM BGM_FIRE_CRACKLING4 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_sheimi, 228, 308, false, 2)
  GROUND:MoveToPosition(hero, 228, 348, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 252, 340, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 204, 340, false, 2) end end
  GAME:WaitFrames(10)
  -- SetAnimation(5) [anim idle native]
  GAME:WaitFrames(40)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(npc_npc_denryuu, 188, 228, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" [CS:N]Ampharos[CR]!", french=" [CS:N]Pharamp[CR]!", german=" [CS:N]Ampharos[CR]!", italian=" [CS:N]Ampharos[CR]!", spanish=" ¡[CS:N]Ampharos[CR]!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_denryuu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_sheimi, 228, 272, false, 2)
  GROUND:MoveToPosition(hero, 228, 312, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 252, 300, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 204, 300, false, 2) end end
  GAME:WaitFrames(6)
  GROUND:MoveToPosition(npc_npc_denryuu, 228, 236, false, 2)
  GROUND:EntTurn(npc_npc_denryuu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="Oh! It's [CS:N]Shaymin[CR] from the\nvillage! I was wondering who it was.", french="Oh! C'est [CS:N]Shaymin[CR], du village\nen bas! Je me demandais de qui il pouvait\ns'agir.", german="Oh! Es ist [CS:N]Shaymin[CR] aus dem\nDorf! Ich habe mich gefragt, wer das wohl ist.", italian="Oh! Sei [CS:N]Shaymin[CR] del villaggio!\nMi chiedevo chi fosse.", spanish="¡Anda, pero si es [CS:N]Shaymin[CR],\nde la aldea! Ya me preguntaba quién sería."})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_denryuu, "happy", 1) end)
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="It's been a long time!\nHow have you been?", french=" Ça fait longtemps!", german="Es ist lange her!\nWie ist es dir ergangen?", italian="Ne è passato di tempo!\nCome stai?", spanish="¡Cuánto tiempo!\n¿Cómo te va todo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_denryuu, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="It has been a long time,\n[CS:N]Ampharos[CR].", french=" C'est vrai, [CS:N]Pharamp[CR].", german="Es ist wirklich lange her,\n[CS:N]Ampharos[CR].", italian="Hai ragione, è passato tanto\ntempo, [CS:N]Ampharos[CR].", spanish="Es cierto... Hacía mucho que no\nnos veíamos, [CS:N]Ampharos[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="But we don't have time to chat.\nWe're in a hurry!", french="Mais nous n'avons pas de temps\nà perdre! Il y a urgence!", german="Leider haben wir keine Zeit für\neinen Plausch. Wir müssen uns beeilen!", italian="Ma ora non possiamo\nchiacchierare! Dobbiamo fare in fretta!", spanish="Pero ahora no hay tiempo para\ncharlar, ¡tenemos una emergencia entre manos!"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_denryuu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english=" Indeed? Did something happen?", french=" Hein? Que se passe-t-il?", german=" Huch! Ist etwas passiert?", italian=" Uh? Cos'è successo?", spanish=" ¿Y eso? ¿Ha ocurrido algo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" At the 7th Station Clearing!", french=" A la trouée du 7[F:E] Relais!", german="Ja, bei der\n7. Zwischenlagerlichtung!", italian=" Al Bivacco 7!", spanish="¡Vamos deprisa a la Base del\nSéptimo Puerto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_denryuu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="Ah... Here I thought I was going\nto have my first guests in a long time, but it\nsounds like that will have to wait.", french="Oh. Je pensais pouvoir accueillir\nmes premiers invités depuis bien longtemps,\nmais, apparemment, ça devra attendre.", german="Ah... Ich hatte mich schon auf\ndie ersten Gäste seit Langem gefreut, aber\nich muss mich wohl noch etwas gedulden.", italian="Oh... E dire che pensavo si\ntrattasse di una visita amichevole, dopo così\ntanto tempo. Evidentemente mi sbagliavo...", spanish="Jo... Y yo que pensaba que iba a\ntener mis primeros invitados en la tira de\ntiempo... Mi gozo en un pozo."})
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english="I hear you. I'm on my way.\nThe 7th Station Clearing, you said?", french="Compris. J'y vais. La trouée\ndu 7[F:E] Relais, tu dis?", german="Na gut, ich mach mich dann mal\nauf den Weg. Zur 7. Zwischenlagerlichtung,\nsagtest du?", italian="Ho capito, mi metto subito\nin cammino. Hai detto il Bivacco 7, vero?", spanish="De acuerdo, voy. ¿A la Base del\nSéptimo Puerto, me has dicho?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Yes!", french=" Oui!", german=" Genau!", italian=" Sì!", spanish=" ¡Sí, sí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_denryuu) end)
  SkySceneKit.say({english=" You wait for me here.", french=" Vous m'attendrez ici.", german=" Wartet hier auf mich.", italian=" Voi aspettatemi qui.", spanish=" Esperadme aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" We're counting on you!", french=" On compte sur toi!", german=" Wir verlassen uns auf dich!", italian=" Contiamo su di te!", spanish=" ¡Contamos contigo!"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_denryuu, 228, 420, false, 2)
  GAME:WaitFrames(3)
  GROUND:MoveToPosition(npc_npc_sheimi, 244, 272, false, 2)
  GAME:WaitFrames(2)
  GROUND:EntTurn(npc_npc_sheimi, Direction.Left)
  GAME:WaitFrames(3)
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  GROUND:MoveToPosition(hero, 212, 312, false, 2)
  GAME:WaitFrames(2)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(3)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Down) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Down) end end
  GAME:WaitFrames(3)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2)
  GROUND:MoveToPosition(npc_npc_sheimi, 228, 272, false, 2)
  GROUND:EntTurn(npc_npc_sheimi, Direction.Down)
  GAME:WaitFrames(2) -- join WaitScreenFade
  SkySceneKit.cleanup_npcs()
end
