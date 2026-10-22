-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/un0104.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) or (SkyProg.cmp_side(40, 3) >= 0) or (SkyProg.cmp_side(40, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7] || scn($SCENARIO_SIDE) >= [40
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_yadon = SkySceneKit.spawn_npc("slowpoke", 224, 224, Direction.UpRight, "NPC_YADON")
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english="Hey...[K]does anyone ever call\nyou slow?", french="Hé...[K] On t'a déjà dit\nque tu étais lent?", german="Hey...[K] Hat irgendjemand\ndich schon mal als langsam bezeichnet?", italian="Ehi...[K] Ti hanno mai detto che sei\nun po' lento?", spanish="Oye...[K] ¿Se ha quejado alguien\nde tu lentitud alguna vez?"})
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english="They call us slow.[K]\nWe move really slowly...", french="Ils disent qu'on est lents.[K]\nOn se déplace vraiment lentement...", german="Sie sagen, wir seien langsam.[K]\nWir bewegen uns auch eher gemächlich...", italian="A noi lo ripetono sempre.[K]\nCi muoviamo molto lentamente...", spanish="A nosotros nos lo dicen siempre.[K]\nLa verdad es que nos movemos despacito..."})
  pcall(function() UI:SetSpeaker(npc_npc_yadon) end)
  SkySceneKit.say({english="But the truth is...[K]\nWe don't really have any ambition...", french="Mais la vérité...[K]\nc'est qu'on n'a pas franchement d'ambition...", german="Aber die Wahrheit ist...[K]\nWir haben einfach zu wenig Antrieb...", italian="Ma la verità è che...[K]\nnon abbiamo nessuna ambizione.", spanish="Pero la cosa es que...[K]\nno tenemos ambición alguna..."})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
