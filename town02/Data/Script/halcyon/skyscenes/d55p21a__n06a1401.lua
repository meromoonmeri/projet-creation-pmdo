-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D55P21A/n06a1401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 264, 296, Direction.Left, "NPC_SAANAITO")
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Everyone...[K]all right?", french=" Ça va...[K] les filles?", german=" Sind alle...[K] in Ordnung?", italian=" Ehi...[K] Tutto a posto?", spanish=" ¿Estáis todas...[K] bien?"})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D55P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 200, 296, Direction.Down, "NPC_CHAAREMU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Down)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Right)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Boulder Quarry.ogg", true) end)
  GAME:WaitFrames(30)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(7)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Right)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yeah.[K] I'm fine.", french=" Ouais.[K] Tout va bien.", german=" Ja.[K] Mir geht es gut.", italian=" Sì.[K] Io sto bene.", spanish=" Sí.[K] Yo estoy de lujo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="I'm all right too.[K] But I was a\nlittle unprepared.", french="Moi aussi.[K] Mais ils m'ont prise\nau dépourvu.", german="Bei mir ist auch alles okay.[K]\nIch war nur ein wenig unvorbereitet.", italian="Anch'io.[K] Ma sono stata presa\nun po' alla sprovvista.", spanish="Yo también estoy bien.[K] Pero\nno estaba preparada del todo."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="They were a little stronger...[K]\nthan I expected.", french="Je les ai très légèrement...[K]\nsous-estimés.", german="Sie waren doch etwas stärker,[K]\nals ich dachte.", italian="Sono più forti...[K] di quanto\nmi aspettassi.", spanish="Eran un poco más fuertes...[K]\nde lo que esperaba."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_saanaito, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="What should we do?[K] Look for\nanother way?", french="Qu'est-ce qu'on fait?[K] On cherche\nun autre chemin?", german="Was sollen wir jetzt tun?[K]\nEinen anderen Weg suchen?", italian="Che cosa facciamo?[K] Cerchiamo\nun'altra strada per proseguire?", spanish="¿Qué hacemos?[K] ¿Buscamos\notro camino?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, hero, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="No.[K] If we do that, there's a\nchance we'll get even more lost...", french="Non.[K] Nous risquerions de nous\nperdre encore davantage...", german="Nein.[K] Wenn wir das tun, werden\nwir uns sogar noch mehr verlaufen...", italian="No.[K] Rischieremmo di perderci\nancora di più...", spanish="No.[K] Así podríamos perdernos\naún más..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" And it will take a while.", french="Sans compter que nous perdrions\ndu temps.", german=" Und es würde Zeit kosten.", italian=" E sprecheremmo troppo tempo.", spanish=" Y nos llevaría un buen rato."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Anyhow...[K] We should think of a\nway to cross over there somehow.", french="En somme...[K] nous devrions\nréfléchir à un moyen de passer.", german="Wie dem auch sei...[K] Lasst uns\nüberlegen, wie wir dort hinüberkommen.", italian="Comunque...[K] dovremmo pensare\na un modo per superare quel punto.", spanish="En fin...[K] Deberíamos pensar en\nuna forma de cruzar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Yeah.", french=" Ouais.", german=" Genau.", italian=" Sì.", spanish=" Pues sí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Got it.", french=" Compris.", german=" Verstanden.", italian=" Ricevuto.", spanish=" Vale."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
