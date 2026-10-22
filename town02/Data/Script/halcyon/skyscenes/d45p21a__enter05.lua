-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D45P21A/enter05.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 110 then
  if (SkyProg.cmp_side(42, 8) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [42, 8]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_aamarudo = SkySceneKit.spawn_npc("armaldo", 248, 272, Direction.Up, "NPC_AAMARUDO")
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Let's try again.", french=" Essayons encore.", german=" Lass es uns noch mal probieren.", italian=" Riproviamoci.", spanish=" Volvamos a intentarlo."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" We'll get there this time.", french=" On y arrivera, cette fois-ci.", german=" Diesmal werden wir es schaffen.", italian=" Questa volta ce la faremo.", spanish=" Esta vez lo conseguiremos."})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" We're almost there.", french=" On y est presque.", german=" Wir sind fast da.", italian=" Ci siamo quasi.", spanish=" Ya casi hemos llegado."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Let's keep going, but remain\ncautious.", french="Continuons,\nmais restons sur nos gardes.", german="Lass uns den Weg fortsetzen,\naber bleib vorsichtig!", italian="Andiamo avanti, ma facciamo\nmolta attenzione.", spanish="Debemos continuar, pero\nsiempre con cautela."})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  -- @label_0 [étiquette de flux ExplorerScript]
  if (SkyProg.cmp_side(42, 5) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [42, 5]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="You can make a record of your\nadventure and take out items using the\nKangaskhan Rock.", french="Tu peux utiliser la Statue\nKangourex pour retirer un objet utile de la\nréserve et pour sauvegarder ton aventure.", german="Mithilfe des Kangama-Speichers\nkannst du deinen Fortschritt sichern oder\nItems aus dem Lager entnehmen.", italian="Puoi salvare la partita\ne prelevare gli strumenti usando\nla Statua Kangaskhan.", spanish="Puedes guardar tu aventura y\nsacar objetos de la consigna en\nla Roca de Kangaskhan."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Use the Kangaskhan Rock to\nprepare for the exploration.", french="Utilise la Statue Kangourex pour\npréparer l'exploration.", german="Verwende den\nKangama-Speicher, um dich für die\nErkundung vorzubereiten.", italian="Usa la Statua Kangaskhan per\nprepararti all'esplorazione.", spanish="Usa la Roca de Kangaskhan para\nprepararte para explorar."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Once you're done with that, let's\nhead out on our exploration.", french="Nous partirons dès que tu\nauras terminé.", german="Lass uns aufbrechen, wenn du\ndamit fertig bist.", italian="Quando hai finito, possiamo\nmetterci in cammino.", spanish="Cuando acabes, podremos partir\nde exploración."})
  -- message_Close
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="You can use the Kangaskhan Rock\nto take any items you might need.", french="Tu peux utiliser la\nStatue Kangourex pour retirer\nun objet utile de la réserve.", german="Du kannst den Kangama-Speicher\nverwenden, um benötigte Items aus dem Lager\nzu entnehmen.", italian="Puoi usare la Statua Kangaskhan\nper prelevare gli strumenti che ti servono.", spanish="Usa la Roca de Kangaskhan para\nsacar de la consigna los objetos que necesites."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Anyway, go ahead and make a\nrecord of your adventure and take out items\nusing the Kangaskhan Rock.", french="Très bien, vas-y: retire des\nobjets de la réserve et sauvegarde ton\naventure grâce à la Statue Kangourex.", german="Nun gut. Sichere deinen\nFortschritt oder nimm dir benötigte Items\nmithilfe des Kangama-Speichers.", italian="Non solo, puoi anche salvare\nla partita.", spanish="Luego, usa la Roca de Kangaskhan\npara guardar tu aventura, si quieres."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Once you're done with that, let's\nhead out on our exploration.", french="Nous partirons dès que tu\nauras terminé.", german="Lass uns auf Erkundung gehen,\nsobald du damit fertig bist!", italian="Quando hai finito, possiamo\ncominciare la nostra esplorazione.", spanish="Cuando estés listo podremos\nemprender nuestra exploración."})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
