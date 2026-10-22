-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/un0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(43, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [43, 2]
  end
  -- @label_2 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_zanguusu = SkySceneKit.spawn_npc("zangoose", 360, 144, Direction.Down, "NPC_ZANGUUSU")
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="You and [CS:N]Haunter[CR] are both pretty\nfamous among exploration teams, you know...", french="Toi et [CS:N]Spectrum[CR], vous êtes\nplutôt célèbres parmi les équipes\nd'exploration, tu sais...", german="Du und dieser [CS:N]Alpollo[CR], ihr seid\nbeide recht bekannt unter Erkundungsteams,\nweißt du...", italian="Sai, tu e [CS:N]Haunter[CR] siete piuttosto\nfamosi tra le squadre d'esplorazione...", spanish="Tanto tú como [CS:N]Haunter[CR] gozáis de\nmucha fama entre los equipos exploradores..."})
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="I'd like to fight either one of\nyou one day...", french="J'aimerais affronter l'un de\nvous deux un jour.", german="Ich würde gerne einmal gegen\neinen von euch antreten...", italian="Un giorno o l'altro mi piacerebbe\nlottare contro uno di voi due...", spanish="Me encantaría combatir con\ncualquiera de los dos algún día..."})
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english=" Even if you win...", french=" Même si tu gagnes...", german=" Selbst wenn ich verliere...", italian="E anche se doveste avere\nla meglio...", spanish=" Aunque me venzas..."})
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="...I could probably get a\nscratch or two in with my sharp claws...", french="... je pourrais probablement te\nfaire une ou deux égratignures avec mes\ngriffes acérées...", german="Höchstwahrscheinlich könnte ich\ndir ein oder zwei Kratzer mit meinen Klauen\nverpassen...", italian="... credo che riuscirei ad\nassestare uno o due colpi con i miei\nartigli affilati.", spanish="Probablemente te llevarías\nun par de arañazos de mis afiladas garras..."})
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="Oooh...[K] Just thinking about it\nis exciting!", french="Oooh...[K] Rien que le fait d'y\npenser, ça me donne envie!", german="Oooh...[K] Allein daran zu denken\nist so aufregend!", italian="Oooh...[K] Solo a pensarci è così\nemozionante!", spanish="Córcholis...[K] ¡Me emociono\nsolo de pensarlo!"})
  pcall(function() UI:SetSpeaker(npc_npc_zanguusu) end)
  SkySceneKit.say({english="Please! [K]When you've got some\nfree time, come challenge me!", french="S'il te plaît! [K]Quand tu auras\nun moment de libre, viens me défier!", german="Bitte![K] Wenn du ein bisschen\nZeit hast, komm und fordere mich heraus!", italian="Ti prego! [K]Quando avrai un po' di\ntempo libero, vieni a sfidarmi!", spanish="¡Porfi![K] ¡Dime que cuando tengas\nalgo de tiempo vendrás a retarme!"})
  -- message_Close
  -- @label_1 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.cleanup_npcs()
end
