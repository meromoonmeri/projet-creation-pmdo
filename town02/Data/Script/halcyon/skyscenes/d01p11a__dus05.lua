-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/dus05.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- @label_3 [étiquette de flux ExplorerScript]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 432, 192, Direction.Down, "NPC_DAGUTORIO")
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Where do you want to go?", french=" Where do you want to go?", german=" Where do you want to go?", italian=" Where do you want to go?", spanish=" Where do you want to go?"})
  do local __choice = SkySceneKit.ask({{english="Ground Map", french="Ground Map", german="Ground Map", italian="Ground Map", spanish="Ground Map"}, {english="Cancel", french="Cancel", german="Cancel", italian="Cancel", spanish="Cancel"}}) -- message_SwitchMenu(1, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="No, there's something there.\nI can't do any digging over there.", french="No, there's something there.\nI can't do any digging over there.", german="No, there's something there.\nI can't do any digging over there.", italian="No, there's something there.\nI can't do any digging over there.", spanish="No, there's something there.\nI can't do any digging over there."})
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="What, you don't like getting into\nthe holes I dig?", french="What, you don't like getting into\nthe holes I dig?", german="What, you don't like getting into\nthe holes I dig?", italian="What, you don't like getting into\nthe holes I dig?", spanish="What, you don't like getting into\nthe holes I dig?"})
  -- @label_2 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="...All right. I'm going back to\nearth again.", french="...All right. I'm going back to\nearth again.", german="...All right. I'm going back to\nearth again.", italian="...All right. I'm going back to\nearth again.", spanish="...All right. I'm going back to\nearth again."})
  -- message_Close
  else -- default/annulation
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="What, you're canceling? I was\nall set to dig too.", french="What, you're canceling? I was\nall set to dig too.", german="What, you're canceling? I was\nall set to dig too.", italian="What, you're canceling? I was\nall set to dig too.", spanish="What, you're canceling? I was\nall set to dig too."})
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
