-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99A/un0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 176, 136, Direction.Left, "NPC_DAGUTORIO")
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Hey, [CS:Y]Bidoof[CR]!", french=" Hé, [CS:Y]Keunotor[CR]!", german=" Hey, [CS:Y]Bidiza[CR]!", italian=" Ehi, [CS:Y]Bidoof[CR]!", spanish=" ¡Eh, [CS:Y]Bidoof[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Do your best on the exploration!\n(You know we really wanted to go...)", french="Fais de ton mieux pendant\nl'exploration! (Nous avions vraiment\nenvie d'y aller, nous aussi...)", german="Viel Spaß bei der Entdeckung!\n(Ach, ich wäre so gerne mitgekommen...)", italian="Fai del tuo meglio durante\nl'esplorazione! (Uffa! Volevamo venire\nanche noi...)", spanish="¡Explora lo mejor que sepas!\n(Con las ganas que teníamos de ir...)"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="I know you can do it!\n(It should have been us doing it...)", french="Nous savons que tu peux\nréussir!\n(C'est nous qui devrions être à ta place...)", german="Klaro, das schaffst du!\n(Ich hätte das machen sollen...)", italian="Ce la puoi fare!\n(Toccava a noi essere scelti...)", spanish="¡Ánimo, tú puedes!\n(Jo, tendríamos que haber ido nosotros...)"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Do your best!\n(Jealous... So jealous...)", french="Fais de ton mieux!\n(Jalousie... quand tu nous tiens...)", german="Gib dein Bestes!\n(Neidisch... Soooo neidisch...)", italian="Buona fortuna!\n(Invidia... Che invidia...)", spanish="¡Hazlo lo mejor posible!\n(Nos corroe la envidia...)"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Don't fail! (Still jealous...)", french="N'échoue pas!\n(La jalousie, encore...)", german="Und gib nicht auf!\n(Immer noch neidisch...)", italian=" Non deluderci! (Che gelosia...)", spanish="¡No nos falles!\n(Seguimos verdes de envidia...)"})
  -- message_Close
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp_side(40, 3) >= 0) or (SkyProg.cmp_side(40, 2) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 3] || scn($SCENARIO_SIDE) >= [40
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
