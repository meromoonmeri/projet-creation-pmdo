-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/un0105.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(40, 7) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 7]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Up, "NPC_DOGOOMU")
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Do YOUR best!", french=" FAIS de ton MIEUX!", german=" Gib DEIN Bestes!", italian=" DACCI DENTRO!", spanish=" ¡A por todas!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" HAVE a SUCCESSFUL exploration!", french="Je te SOUHAITE le succès\npour ton EXPLORATION!", german="AUF eine ERFOLGREICHE\nErkundung!", italian="BUONA FORTUNA per\nl'esplorazione!", spanish=" ¡Mucha suerte en tu exploración!"})
  -- message_Close
  -- @label_3 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp_side(40, 3) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 3]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" HEY! [CS:N]Diglett[CR]!", french=" Hé! [CS:N]Taupiqueur[CR]!", german=" HEY! [CS:N]Digda[CR]!", italian=" EHI! [CS:N]Diglett[CR]!", spanish=" ¡Oye! ¡[CS:N]Diglett[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Let me know right away if\nANYONE sketchy comes along!", french="Si jamais tu vois QUI QUE CE\nSOIT de louche, préviens-moi ILLICO!", german="Lass es mich sofort wissen,\nwenn IRGENDJEMAND Komisches hier\nvorbeikommt!", italian="Fammi sapere immediatamente\nse arriva QUALCUNO che non riconosci!", spanish="Mantenme informado si pasa por\naquí alguien con aspecto sospechoso."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 456, 272, Direction.Up, "NPC_DIGUDA")
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end) -- message_SetActor(ACTOR_NPC_DIGUDA)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Yes! Will do!", french=" Oui! Promis!", german=" Ja! Wird gemacht!", italian=" Sì! Certo!", spanish=" ¡Sí, señor! ¡A la orden!"})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(40, 2) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [40, 2]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" I HEARD you got the DAY OFF?", french="Il paraît que tu as PRIS\ndes VACANCES!", german="Ich habe GEHÖRT, dass du ein\nbisschen FREIE ZEIT hast.", italian="HO SENTITO che hai ottenuto\nqualche giorno di VACANZA!", spanish="¿Es cierto que te has tomado\nunos días libres?"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="You TALKED him INTO IT...[K]\nI'm JEALOUS...", french="Tu l'as EU avec ton BARATIN...[K]\nJe suis JALOUX...", german="Du HAST ihn ÜBERREDET...[K]\nIch bin NEIDISCH...", italian="DICI che lo HAI CONVINTO?[K]\nChe INVIDIA...", spanish="No sé cómo lo has convencido...[K]\n¡Me tienes verde de envidia!"})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="All right![K] Time to buck up and\nWORK HARD!", french="Allez![K] Maintenant, c'est l'heure\nde se mettre au boulot, et FISSA!\nHOP HOP HOP!", german="Zeit, uns zusammenzureißen\nund[K] HART ZU ARBEITEN!", italian="Va bene![K] È ora di spicciarsi e\ndi LAVORARE DURO!", spanish=" ¡Muy bien![K] ¡Hora de trabajar!"})
  -- message_Close
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
