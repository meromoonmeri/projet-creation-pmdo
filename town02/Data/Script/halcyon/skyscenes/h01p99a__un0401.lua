-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99A/un0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(43, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [43, 2]
  end
  -- @label_3 [étiquette de flux ExplorerScript]
  if ((SV.SkyTalkBitFlags or {})[134] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[134]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 176, 136, Direction.Left, "NPC_DAGUTORIO")
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Heh ahhh...", french=" Ouff ouff...", german=" Hrrrrrkk püüüüüh...", italian=" Eeeh aaah...", spanish=" Je, jaaa..."})
  -- message_Close
  -- @label_2 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[134] = 1 -- $SCENARIO_TALK_BIT_FLAG[134] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" ...Oh! [K][CS:Y]Sunflora[CR]!", french=" ... Oh! [K][CS:Y]Héliatronc[CR]!", german=" ...Oh![K] [CS:Y]Sonnflora[CR]!", italian=" ... Oh! [K][CS:Y]Sunflora[CR]!", spanish=" ¡Anda...[K] [CS:Y]Sunflora[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Don't tell anyone...", french=" Ne dis à personne...", german=" Sag es keinem...", italian=" Non dire a nessuno...", spanish=" No le digas a nadie..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" ...that you saw us here...", french=" ... que tu nous as vus ici...", german=" Du hast mich nicht gesehen...", italian=" ... che ci hai visti qui...", spanish=" Que nos has visto aquí..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Just in case, I am telling you...[K]\nWe're here but...", french="Enfin, juste pour te dire...[K]\nNous sommes ici mais...", german="Nur zur Sicherheit verrat ich es\ndir...[K] Ich bin hier...", italian="Giusto perché tu lo sappia...[K]\nsiamo qui, ma...", spanish="Solo por si las moscas...[K]\nEstamos aquí, pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" We're not loafing on the job!", french=" ... nous ne tirons pas au flanc!", german="Aber das heißt nicht, dass ich\nauf der faulen Haut liege!", italian="... non è che stiamo battendo\nla fiacca!", spanish=" ¡No nos estamos escaqueando!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Hear me?[K] Not loafing on the job!", french="Entendu?[K] Nous ne tirons\npas au flanc!", german="Verstehst du?[K] Kein Faulenzen\nwährend der Arbeit!", italian="Hai sentito?[K] Non stiamo\nbattendo la fiacca!", spanish=" ¿Vale?[K] ¡No nos escaqueamos!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Definitely not trying to...[K]\nloaf on the...", french="Nous n'essayons absolument\npas...[K] de tirer...", german="Auf keinen Fall...[K] faulenzen\nwährend der...", italian="Non stiamo assolutamente...[K]\nbattendo...", spanish="Ni se te ocurra pensar que...[K]\nintentamos escaquearnos del..."})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Job!!", french=" ... au flanc!!", german=" Arbeit!", italian=" ... la fiacca!!!", spanish=" ¡¡Trabajo!!"})
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" Heh ahhh...", french=" Ouff ouff...", german=" Hrrrrrkk püüüüüh...", italian=" Eeeh aaah...", spanish=" Je, jaaa..."})
  -- message_Close
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
