-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/un0405.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(43, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [43, 2]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_madatsubomi = SkySceneKit.spawn_npc("bellsprout", 360, 312, Direction.Up, "NPC_MADATSUBOMI")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_madatsubomi, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="We're Team [CS:X]Flame[CR].\nI'm the leader.", french="On est l'Equipe [CS:X]Flamme[CR].\nC'est moi le meneur.", german="Wir sind Team [CS:X]Flamme[CR]. Ich bin\nder Anführer.", italian="Noi siamo il Team [CS:X]Fiamma[CR].\nIo sono il leader.", spanish="Somos el [CS:X]Equipo Llameante[CR].\nEl líder soy yo."})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="I don't like to admit it, but I'm\nvery timid...", french="Ça me gêne de l'avouer, mais\nje suis très peureux...", german="Ich gebe das nicht gerne zu,\naber ich bin sehr ängstlich...", italian="Mi vergogno ad ammetterlo, ma\nsono un po' fifone...", spanish="No me gusta admitirlo, pero\nsoy algo temeroso..."})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="When my team members start\nfighting with fire, I can't do a thing but stand\nback and hope I don't get hit...", french="Quand mes coéquipiers se\nmettent à utiliser des attaques de type Feu, je\ndois rester à l'écart pour éviter d'être touché.", german="Wenn meine Team-Mitglieder mit\nFeuer kämpfen, kann ich nur dastehen und\nhoffen, dass ich nicht getroffen werde.", italian="Quando la mia squadra lotta\ncon il fuoco, non posso far altro che stare\nindietro e sperare che non mi colpiscano...", spanish="Cuando mis compañeros lanzan\nsus ataques de tipo Fuego, lo único que\npuedo hacer es apartarme..."})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english=" Ugh...[K]I feel so pathetic...", french="Pfff... [K]Je me trouve\npitoyable...", german="Uff,[K] ich fühle mich so\nerbärmlich.", italian=" Uh...[K] Mi sento così patetico...", spanish="Y confiar en que no me quemen.[K]\nQué patético resulto..."})
  -- message_Close
  -- @label_2 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif ((SV.SkyTalkBitFlags or {})[138] == 1) then -- elseif ROM: $SCENARIO_TALK_BIT_FLAG[138]
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english=" Hmmm...[K] Not afraid of fire...", french="Humm...[K]\nTu ne crains pas le feu...", german=" Hmm...[K] Keine Angst vor Feuer...", italian="Mmmh...[K] Non hai paura\ndel fuoco...", spanish=" Mmmm...[K] El fuego te da igual..."})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english=" I'm so jealous. Seriously...", french="Je t'envie vraiment.\nSérieux...", german=" Ich bin so neidisch... Ernsthaft...", italian=" Ti invidio davvero tanto...", spanish=" Qué envidia me das, de verdad..."})
  -- message_Close
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[138] = 1 -- $SCENARIO_TALK_BIT_FLAG[138] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="We're Team [CS:X]Flame[CR].\nI'm the leader.", french="On est l'Equipe [CS:X]Flamme[CR].\nC'est moi le meneur.", german="Wir sind Team [CS:X]Flamme[CR]. Ich bin\nder Anführer.", italian="Noi siamo il Team [CS:X]Fiamma[CR].\nIo sono il leader.", spanish="Somos el [CS:X]Equipo Llameante[CR].\nEl líder soy yo."})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="I don't like to admit it, but I'm\nvery timid...", french="Ça me gêne de l'avouer, mais\nje suis très peureux...", german="Ich gebe das nicht gerne zu,\naber ich bin sehr ängstlich...", italian="Mi vergogno ad ammetterlo, ma\nsono un po' fifone...", spanish="No me gusta admitirlo, pero\nsoy algo temeroso..."})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="When my team members start\nfighting with fire, I can't do a thing but stand\nback and hope I don't get hit...", french="Quand mes coéquipiers se\nmettent à utiliser des attaques de type Feu, je\ndois rester à l'écart pour éviter d'être touché.", german="Wenn meine Team-Mitglieder mit\nFeuer kämpfen, kann ich nur dastehen und\nhoffen, dass ich nicht getroffen werde.", italian="Quando la mia squadra lotta\ncon il fuoco, non posso far altro che stare\nindietro e sperare che non mi colpiscano...", spanish="Cuando mis compañeros lanzan\nsus ataques de tipo Fuego, lo único que\npuedo hacer es apartarme..."})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english=" I'm a Grass type...", french=" Je suis de type Plante...", german=" Ich bin ein Pflanzen-Pokémon...", italian=" Sono un Pokémon di tipo Erba...", spanish=" Soy de tipo Planta..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_madatsubomi, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="...Wait. [K]Looking at you, you're a\nGrass type too, aren't you...?", french="... Attends... [K]Tu m'as l'air d'être\nde type Plante, toi aussi, pas vrai...?", german="...Warte mal.[K] Wenn ich dich so\nansehe... Du bist doch auch ein\nPflanzen-Pokémon, oder?", italian="... Aspetta. [K]A ben guardarti,\nanche tu sei di tipo Erba, vero?", spanish="Pero, espera...[K] Ahora que me\nfijo, ¿no eres tú también de tipo Planta?"})
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english=" Aren't you afraid of fire?", french=" Tu n'as pas peur du feu?", german=" Hast du keine Angst vor Feuer?", italian=" Non hai paura del fuoco?", spanish=" ¿No te da miedo el fuego?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Not at all.", french=" Pas du tout.", german=" Überhaupt nicht.", italian=" Per niente.", spanish=" Para nada."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I'm fine, as long as I'm careful.", french="Ça ne me pose pas de problème,\nil suffit que je fasse attention.", german="Solange ich aufpasse, ist\nalles gut.", italian="Se sto attenta, non ho niente da\ntemere.", spanish=" No pasa nada si voy con cuidado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_madatsubomi) end)
  SkySceneKit.say({english="Oh...[K]really...[K]\nI'm jealous.", french="Oh...[K] vraiment?[K]\nJe t'envie.", german="Oh...[K] Wirklich...[K]\nDas macht mich neidisch.", italian="Oh...[K] davvero?[K]\nChe invidia.", spanish="Ah...[K] ¿En serio?...[K]\nJo, qué envidia."})
  -- message_Close
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
