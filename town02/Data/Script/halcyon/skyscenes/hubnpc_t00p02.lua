-- GÉNÉRÉ par dev/tools/sky_compile_hub_npcs.py — NE PAS ÉDITER À LA MAIN.
-- NPC résidents canoniques du hub t00p02 (enter.sse ROM Sky EU: placements SSA exacts,
-- dialogues enterNN.ssb 5 langues; talk=nil = script ROM sans dialogue compilable, tracé).
local SkySceneKit = require 'halcyon.skyscenes.kit'
local function talk_npc_test008(hero, partner)
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="An event will be activated.\nWhich one would you like?", french="An event will be activated.\nWhich one would you like?", german="An event will be activated.\nWhich one would you like?", italian="An event will be activated.\nWhich one would you like?", spanish="An event will be activated.\nWhich one would you like?"})
end
local function talk_npc_test004(hero, partner)
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english="What can I help you with today?", french="What can I help you with today?", german="What can I help you with today?", italian="What can I help you with today?", spanish="What can I help you with today?"})
end
return {
  {species="makuhita", x=400, y=184, dir=Direction.Down, name="NPC_TEST008", talk=talk_npc_test008},
  {species="kangaskhan", x=264, y=192, dir=Direction.Down, name="NPC_TEST004", talk=talk_npc_test004},
}
