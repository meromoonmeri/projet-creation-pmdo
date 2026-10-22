-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D42P21A/enter25.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_yukikaburi = SkySceneKit.spawn_npc("snover", 248, 272, Direction.Up, "NPC_YUKIKABURI")
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="I don't really know where\n[CS:N]Jirachi[CR] lives...", french="Je ne sais pas vraiment où vit\n[CS:N]Jirachi[CR]...", german="Ich weiß nicht genau, wo\n[CS:N]Jirachi[CR] wohnt...", italian="Non ho idea di dove viva\n[CS:N]Jirachi[CR]...", spanish="La verdad es que no sé\ndónde vive [CS:N]Jirachi[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="But I think we're almost there.\nLet's keep going.", french="... mais je crois qu'on y est\npresque. Continuons.", german="Aber ich denke, wir sind so gut\nwie da. Gehen wir weiter!", italian="Ma credo che ormai ci siamo.\nAndiamo avanti.", spanish="Pero creo que ya casi estamos.\nVamos a continuar."})
  -- message_Close
  -- @label_0 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.cleanup_npcs()
end
