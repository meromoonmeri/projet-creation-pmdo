-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D55P11A/enter05.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" It's a promise, [CS:N]Sentret[CR].", french=" C'est une promesse, [CS:N]Fouinette[CR].", german=" Versprochen, [CS:N]Wiesor[CR].", italian=" Te lo prometto, [CS:N]Sentret[CR].", spanish=" Te lo prometo, [CS:N]Sentret[CR]."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Well, if we run into Team [CS:X]AWD[CR],\nwe'll make sure to give them what for!", french="Si on tombe sur l'Equipe [CS:X]DDA[CR],\non leur montrera de quel bois on se chauffe!", german="Nun gut. Wenn wir Team [CS:X]SPA[CR]\nin die Arme laufen, dann sorgen wir dafür,\ndass sie sich an uns erinnern werden!", italian="Se ci imbattiamo nel Team [CS:X]AWD[CR],\ngliela faremo vedere noi!", spanish="¡Si nos tropezamos con el [CS:X]Equipo\nWAD[CR], se va a enterar de lo que vale un peine!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_metamon_otachi = SkySceneKit.spawn_npc("sentret", 280, 304, Direction.Up, "NPC_METAMON_OTACHI")
  pcall(function() UI:SetSpeaker(npc_npc_metamon_otachi) end)
  SkySceneKit.say({english=" Th-thank you very much!", french=" Me... merci beaucoup!", german=" V-vielen Dank!", italian=" G-Grazie mille!", spanish=" Mu... muchas gracias."})
  -- message_Close
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.cleanup_npcs()
end
