-- GÉNÉRÉ par dev/tools/sky_compile_hub_npcs.py — NE PAS ÉDITER À LA MAIN.
-- NPC résidents canoniques du hub g01p04a (enter.sse ROM Sky EU: placements SSA exacts,
-- dialogues enterNN.ssb 5 langues; talk=nil = script ROM sans dialogue compilable, tracé).
local SkySceneKit = require 'halcyon.skyscenes.kit'
local function talk_npc_guregguru(hero, partner)
      pcall(function() UI:ResetSpeaker() end)
      SkySceneKit.say({english=" Meh-heh-heh. You can't fail now!", french="Mwé hé hé... Vous ne pouvez\nplus échouer maintenant!", german="Mehehe. Ihr dürft jetzt nicht\nversagen!", italian=" Eh eh eh. Ora non potete fallire!", spanish="¡Je, je, je! ¡No podéis fracasar\nahora!"})
end
return {
  {species="chatot", x=168, y=96, dir=Direction.Down, name="NPC_PERAPPU", talk=nil},
  {species="loudred", x=168, y=96, dir=Direction.Down, name="NPC_DOGOOMU", talk=nil},
  {species="croagunk", x=232, y=224, dir=Direction.Down, name="NPC_GUREGGURU", talk=talk_npc_guregguru},
}
