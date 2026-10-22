-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/un0404.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(43, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [43, 2]
  end
  -- @label_2 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_bakuuda = SkySceneKit.spawn_npc("camerupt", 336, 288, Direction.DownRight, "NPC_BAKUUDA")
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english="[CS:N]Ponyta[CR] and I are great at using\nfire-based attacks, as you can imagine. But...", french="Comme vous vous en doutez,\nles attaques de type Feu n'ont pas de secret\npour [CS:N]Ponyta[CR] et moi. Mais...", german="[CS:N]Ponita[CR] und ich sind gut, wenn es\num das Verwenden von Feuer-Attacken geht,\nwie du dir vorstellen kannst. Aber...", italian="Come potrai immaginare, [CS:N]Ponyta[CR]\ne io siamo maestre negli attacchi di tipo Fuoco.\nMa...", spanish="Como supondrás, [CS:N]Ponyta[CR] y yo\nsomos unos ases atacando con fuego. Pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english="We leave swirling fire in our\nwake as we fight...[K]and that scares our leader.", french="On laisse des tourbillons de feu\ndans notre sillage...[K] et cela effraie\nnotre meneur.", german="Wir lassen Feuerwirbel an\nunseren Kampfschauplätzen zurück...[K] Und das\nmacht unserem Anführer Angst.", italian="Ci lasciamo alle spalle un turbine\ndi fuoco quando lottiamo...[K] e il nostro leader\nsi spaventa.", spanish="Al luchar dejamos una estela...[K]\nque asusta bastante a nuestro líder."})
  pcall(function() UI:SetSpeaker(npc_npc_bakuuda) end)
  SkySceneKit.say({english="I think our leader has lost\nconfidence because of this...[K] But I don't know\nwhat we can do about it.", french="Je crois que c'est pour ça que\nnotre meneur a perdu confiance en lui...[K]\nMais je ne vois pas ce qu'on peut y faire...", german="Ich glaube, unser Anführer hat\ndeshalb das Vertrauen verloren...[K] Ich bin mir\nnicht sicher, was wir dagegen tun können.", italian="Penso che il nostro leader abbia\nperso sicurezza...[K] Ma cosa ci possiamo\nfare?", spanish="Me temo que nuestro líder ha\nperdido la confianza...[K] pero no sé qué\npodemos hacer al respecto."})
  -- message_Close
  -- @label_1 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.cleanup_npcs()
end
