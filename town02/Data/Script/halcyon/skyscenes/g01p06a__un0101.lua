-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P06A/un0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 352, 208, Direction.Down, "NPC_CHIRIIN")
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" I know you can do it, [CS:Y]Bidoof[CR]!", french="Je sais que tu peux y arriver,\n[CS:Y]Keunotor[CR]!", german="Ich weiß, du kannst es\nschaffen, [CS:Y]Bidiza[CR]!", italian=" So che puoi farcela, [CS:Y]Bidoof[CR]!", spanish=" ¡Tú puedes, [CS:Y]Bidoof[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Good luck, [CS:Y]Bidoof[CR]!", french=" Tiens bon, [CS:Y]Keunotor[CR]!", german=" Viel Glück, [CS:Y]Bidiza[CR]!", italian=" Buona fortuna, [CS:Y]Bidoof[CR]!", spanish=" ¡Buena suerte, [CS:Y]Bidoof[CR]!"})
  -- message_Close
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp_side(40, 3) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 3]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" I know how you feel, [CS:Y]Bidoof[CR].", french="Je sais ce que tu ressens,\n[CS:Y]Keunotor[CR].", german="Ich weiß, wie du dich fühlst,\n[CS:Y]Bidiza[CR].", italian=" So come ti senti, [CS:Y]Bidoof[CR].", spanish=" Sé cómo te sientes, [CS:Y]Bidoof[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Even though you just ate, for\nsome reason, you suddenly feel hungry again...", french="Tu viens juste de manger et\npourtant, bizarrement, tu as encore faim.", german="Obwohl du gerade was gegessen\nhast, bekommst du plötzlich wieder Hunger...", italian="Per qualche ragione,\nappena finisci di mangiare ti viene\nancora fame...", spanish="Acabas de comer y, sin saber\nmuy bien por qué, vuelves a tener hambre..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" I think that happens to everyone.", french="Je crois que ça arrive\nà tout le monde.", german="Ich glaube, das passiert\njedem mal.", italian=" Penso che capiti a tutti.", spanish="Eso pasa hasta\nen las mejores familias."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="But it's not time for dinner yet,\nso please, be patient!", french="Mais ce n'est pas encore l'heure\ndu dîner, alors un peu de patience!", german="Aber es ist noch nicht\nEssenszeit, also gedulde dich bitte!", italian="Ma è ancora troppo presto per\nmangiare, quindi cerca di essere paziente!", spanish="Pero aún no es hora de cenar,\n¡así que debes tener paciencia!"})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(40, 2) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 2]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Hey! [CS:Y]Bidoof[CR]![K]\nI heard you're taking the day off! Excellent!", french="Hé! [CS:Y]Keunotor[CR]![K]\nJ'ai entendu dire que tu avais pris\ndes vacances! C'est super!", german="Hey, [CS:Y]Bidiza[CR]![K] Ich habe gehört,\ndass du dir ein Weilchen freigenommen hast!\nSpitze!", italian="Ehi! [CS:Y]Bidoof[CR]![K]\nHo sentito che ti sei preso qualche\ngiorno di vacanza! È fantastico!", spanish="¡Eh, [CS:Y]Bidoof[CR]![K]\nHe oído que te has tomado vacaciones. ¡Genial!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Since you're taking a day off,\nyou should make sure to have all kinds of fun!", french=" Profite à fond de tes vacances!", german="Wenn du dir ein Weilchen\nfreinimmst, solltest du dich besser gut\namüsieren!", italian="Visto che hai qualche giorno\nlibero a disposizione, cerca di divertirti\na più non posso!", spanish="¡Más te vale que a la vuelta\nme cuentes cómo has aprovechado el tiempo!"})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Hm?[K]\nAre you hungry already, [CS:Y]Bidoof[CR]?", french="Hm?[K] Tu as déjà faim,\n[CS:Y]Keunotor[CR]?", german="Hmm?[K]\nHast du schon Hunger, [CS:Y]Bidiza[CR]?", italian=" Mmmh?[K] Hai già fame, [CS:Y]Bidoof[CR]?", spanish="¿Cómo?[K] ¿Pero ya tienes\nhambre, [CS:Y]Bidoof[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" But it's not time to eat yet...", french="Mais ce n'est pas encore\nl'heure de manger...", german=" Es ist noch keine Essenszeit...", italian="Ma è ancora presto per\nmangiare...", spanish=" Pero si no es hora de comer..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Keep at your chores until then!", french="Concentre-toi sur ton travail\njusqu'au repas!", german="Halte dich bis dahin an deine\nPflichten!", italian="Sii paziente e continua\na svolgere i tuoi compiti!", spanish="¡Ocúpate de tus tareas\nhasta que sea la hora, comilón!"})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
