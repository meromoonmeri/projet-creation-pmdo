-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m07a1401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 312, 248, Direction.Right, "NPC_DOGAASU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(484, 252, 1, false) end) -- SetPositionMark performer/caméra
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" You two!", french=" Vous deux!", german=" Ihr zwei!", italian=" Voi due!", spanish=" ¡A ver, ese equipo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You two! I hope you will finally\nbring back some Perfect Apples today.", french="Vous deux! J'espère que vous\nallez enfin rapporter des Pommes Parfaites\naujourd'hui.", german="Ihr zwei! Ich hoffe, ihr kommt\nheute endlich mit ein paar Perfekten Äpfeln\nzurück.", italian="Voi due! Spero che oggi\nci porterete finalmente delle Mele Perfette.", spanish="Espero que hoy por fin podáis\ntraernos Manzanas Perfectas."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Perfect Apples can be found\ndeep in [CS:P]Apple Woods[CR].", french="Vous trouverez des Pommes\nParfaites au cœur du [CS:P]Bois aux Pommes[CR].", german="Ihr findet die Perfekten Äpfel\ntief im [CS:P]Apfelwald[CR].", italian="Le Mele Perfette si trovano\nnel cuore del [CS:P]Giardino dei Meli[CR].", spanish="Para encontrar Manzanas\nPerfectas tendréis que adentraros\nen el [CS:P]Manzanar[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="If you don't come back soon with\nsome Perfect Apples, the Guildmaster will...", french="Si vous ne revenez pas\nrapidement avec des Pommes Parfaites,\nle Maître va...", german="Wenn ihr nicht bald Perfekte\nÄpfel bringt, wird der Gildenmeister...", italian="Se non tornate entro breve con\nqualche Mela Perfetta, il Capitano...", spanish="Si no volvéis pronto con\nManzanas Perfectas, el Gran Bluff..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Anyway! We're counting on you!", french="Enfin voilà! Nous comptons\nsur vous!", german=" Egal! Wir zählen auf euch!", italian=" In ogni caso! Contiamo su di voi!", spanish=" ¡Bueno! ¡Contamos con vosotros!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Uh... All right.", french=" Euh... d'accord.", german=" Äh... In Ordnung.", italian=" Eh... Va bene.", spanish=" Eh... Vale."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Uh... All right.", french=" Euh... d'accord.", german=" Äh... In Ordnung.", italian=" Eh... Va bene.", spanish=" Eh... Vale."})
  else
  SkySceneKit.say({english=" Uh... All right.", french=" Euh... d'accord.", german=" Äh... In Ordnung.", italian=" Eh... Va bene.", spanish=" Eh... Vale."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's give it our best try,\n[hero]!", french="Donnons le meilleur de\nnous-mêmes, [hero]!", german="Versuchen wir unser Bestes,\n[hero]!", italian="Mettiamocela tutta,\n[hero]!", spanish="¡Hay que hacer todo lo que\npodamos, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's keep doing our best,\n[hero]!", french="Donnons le meilleur de\nnous-mêmes, [hero]!", german="Versuchen wir unser Bestes,\n[hero]!", italian="Mettiamocela tutta,\n[hero]!", spanish="¡Sigamos esforzándonos,\n[hero]!"})
  else
  SkySceneKit.say({english="Let's keep doing our best,\n[hero]!", french="Donnons le meilleur de\nnous-mêmes, [hero]!", german="Versuchen wir unser Bestes,\n[hero]!", italian="Mettiamocela tutta,\n[hero]!", spanish="¡Sigamos esforzándonos,\n[hero]!"})
  end
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
