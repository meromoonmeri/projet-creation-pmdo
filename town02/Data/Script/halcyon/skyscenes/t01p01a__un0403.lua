-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/un0403.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(43, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [43, 2]
  end
  -- @label_2 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_sandopan = SkySceneKit.spawn_npc("sandslash", 384, 160, Direction.UpLeft, "NPC_SANDOPAN")
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="The outlaw [CS:N]Haunter[CR]?[K]\nYeah, I think I've heard about him.", french="Le [CS:N]Spectrum[CR] hors-la-loi?[K]\nOuais, je crois avoir entendu parler de lui.", german="Der Ganove [CS:N]Alpollo[CR]?[K] Doch, ich\nglaube, über den habe ich schon etwas gehört.", italian="Il Pokémon ricercato [CS:N]Haunter[CR]?[K]\nSì, mi pare di averne sentito parlare.", spanish="¿El malhechor [CS:N]Haunter[CR]?[K]\nSí, creo que me suena."})
  pcall(function() UI:SetSpeaker(npc_npc_sandopan) end)
  SkySceneKit.say({english="Sounds like he's a pretty\nfamous outlaw.", french="Il semblerait que ce soit un\nhors-la-loi assez connu.", german="Scheint ein ziemlich bekannter\nGanove zu sein.", italian="Sembra che sia un ricercato\npiuttosto famoso.", spanish="Parece que es un malhechor\nbastante famoso."})
  -- message_Close
  -- @label_1 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.cleanup_npcs()
end
